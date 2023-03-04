local g_Monitor ={};
local g_InfoQuote ={};
--[[                                

g_Monitor   -- 母单监控信息  
{
["Key"] = 1,    --监控标识
 ["LeftQty"] = 0,
["MarketID"] = "SZA",
["TradeVolume"] = 0,
 ["Account"] = "15396614",
 ["Side"] = "Buy",
 ["Symbol"] = "平安银行",
 ["Stop"] = 0,
 ["SecurityID"] = "000001",
 ["OrderQty"] = 100,
 ["LastClOrdID"] = "274302218",   --最新一个报单编号记录
                               ---  基本参数
  
 ["Str"] = "监控单 000001,时间范围1422-142300,下单间隔 15秒, 买入 100股！",    --自定义监控信息规定
 ["ClOrdID"] = {         --子单报单记录
 [1] = {
 ["index"] = 1,    --界面显示需求标识 ，可以不理他
 ["Price"] = 16.48,
 ["UserID"] = "15396614",
 ["OrdType"] = "Limit",
 ["OrderStatus"] = "未成交",
 ["ClOrdID"] = "274302218",
 ["CxlQty"] = 0,
 ["TradeVolume"] = 0,
 ["SecurityExchange"] = "SZA",
 ["Side"] = "Buy",
 ["Symbol"] = "平安银行",
 ["OrderQty"] = 100,
 ["AvgPx"] = 0,
 ["OrderEntryTime"] = "14:22:18",
 ["OrdStatus"] = "未成交",
 ["TradeDate"] = "20150413",
 ["StatusMsg"] = "",
 ["SecurityID"] = "000001",}
},

g_InfoQuote   -- 监控的股票的10档报价
{

 ["70"] = 14.72,                    跌停板       
 ["152"] = 16.51,		            卖四
 ["55"] = "平安银行",				证券名称
 ["34"] = 16.5,                      卖三
 ["35"] = 138100,					卖三量
 ["157"] = 6100,					卖五量					
 ["29"] = 54927,					买三量
 ["10"] = 16.48,					现价
 ["153"] = 12000,					卖四量
 ["69"] = 18,						涨停板
 ["28"] = 16.44,					买三
 ["154"] = 16.42,					买五
 ["25"] = 3200,						买一量
 ["150"] = 16.43,					买四
 ["156"] = 16.52,					卖五
 ["151"] = 64060,					买四量				
 ["7"] = 17,						开盘
 ["6"] = 16.36,						昨收
 ["155"] = 60300,					买五
 ["24"] = 16.46,					买一
 ["27"] = 161555,					买二量
 ["26"] = 16.45,					买二
 ["31"] = 147852,					卖一量
 ["30"] = 16.48,					卖一
 ["33"] = 68360,					卖二量
 ["32"] = 16.49,}					卖二
 
 
 
  ["70"] = 16.34,
 ["152"] = 18.21,
 ["55"] = "浦发银行",
 ["34"] = 18.2,
 ["35"] = 997702,
 ["157"] = 254596,
 ["29"] = 233300,
 ["10"] = 18.18,
 ["153"] = 167162,
 ["69"] = 19.98,
 ["28"] = 18.14,
 ["154"] = 18.12,
 ["25"] = 58815,
 ["150"] = 18.13,
 ["156"] = 18.22,
 ["151"] = 486013,
 ["7"] = 18.3,
 ["6"] = 18.16,
 ["155"] = 507093,
 ["24"] = 18.16,
 ["27"] = 280800,
 ["26"] = 18.15,
 ["31"] = 126377,
 ["30"] = 18.18,
 ["33"] = 910603,
 ["32"] = 18.19,


g_InfoHq = {};      --监控的股票的当日分时行情
{

 ["1"] = {      --时间点
 [1] = "201504130930",
 [2] = "201504130931",
},
 ["10"] = {  --报价
 [1] = 16.93,
 [2] = 16.87,
},}

OrderBuySell(Param)  交易下单  
Param.Account  --交易账号
Param.Side  --买卖方向 Buy Sell
Param.SecurityID  --股票代码
Param.MarketID  --市场代码
Param.OrderQty -- 下单数量
Param.OrderPrice --下单价格

返回 true,Ret 或者 false; true为下单成功，false为失败 
Ret 信息为 
Ret['SecurityID'] 
Ret['Side']
Ret['OrderQty']
Ret['Price']
Ret['ClOrdID']


OrderCancel(Param)
Param.Account  --交易账号
Param.SecurityID --股票代码
Param.ClOrdID  --撤的合同编号
返回 true 或者 false; true为下单成功，false为失败
GetKLineHq(code,period,begintime,endtime)  -- 返回行情 ret,err

]]--
--[[
	Name  显示的参数名称
	Type  参数的输入格式  time date number decimal text 分别是 时间 日期 数字 小数 文本 
		   Select为选择框 
	Key   界面返回到策略端的参数key值
	Max/Min/Now  最大值 最小值及当期值 是只对time date number decimal text而言 ，其中text无Max和Min值
	List  是Select选择框 特有的一个信息['List']其中Value为限定返回的值 Name为显示的信息



]]--
function TypeInit()   						--参数规划 ，只在初始化时候执行
	local param = {};
	local StrInfo = [[冰山算法，通过把一个很大的单子拆分成几个小的单子。
	每次只提交一个小单，等该小单全部成交后，再提交下一个小单，直到整个
	大单成交完成为止。]];
	
	local dat ={};
	local NowTT = os.date("%H%M%S");
	if tonumber(NowTT) <= 93000 then
		dat['Now'] = '09:30:00';
	elseif tonumber(NowTT) >113000 and tonumber(NowTT)<=130000 then
		dat['Now'] = '13:00:00';
	elseif tonumber(NowTT)>=150000 then
		dat['Now'] = '15:00:00';
	else
		if #NowTT==5 then
			NowTT = '0'..NowTT;
		end
		dat['Now'] = string.sub(NowTT,1,2)..':'..string.sub(NowTT,3,4)..':'..string.sub(NowTT,5,6);
	end
	dat['Name'] = '开始时间';
	dat['Type'] = 'time';
	dat['Key'] = 'BeginTime';
	dat['Max'] = '15:00:00';
	dat['Min'] = '00:00:00';
	table.insert(param,dat);
	local dat ={};
	dat['Name'] = '结束时间';
	dat['Type'] = 'time';
	dat['Key'] = 'EndTime';
	dat['Max'] = '15:00:00';
	dat['Min'] = '09:30:00';
	dat['Now'] = '15:00:00';
	table.insert(param,dat);
	local dat ={};
	dat['Name'] = '委托价格';
	dat['Type'] = 'Select';
	dat['Key'] = 'StockPosition';
	dat['List'] = {};
	local list ={};
	list.Value = "10" ;
	list.Name = "最新价" ;
	table.insert(dat['List'],list);
	local list ={};
	list.Value = "24" ;
	list.Name = "买1价" ;
	table.insert(dat['List'],list);
	local list ={};
	list.Value = "26" ;
	list.Name = "买2价" ;
	table.insert(dat['List'],list);
	local list ={};
	list.Value = "28" ;
	list.Name = "买3价" ;
	table.insert(dat['List'],list);
	local list ={};
	list.Value = "150" ;
	list.Name = "买4价" ;
	table.insert(dat['List'],list);
	local list ={};
	list.Value = "154" ;
	list.Name = "买5价" ;
	table.insert(dat['List'],list);
	local list ={};
	list.Value = "30" ;
	list.Name = "卖1价" ;
	table.insert(dat['List'],list);
	local list ={};
	list.Value = "32" ;
	list.Name = "卖2价" ;
	table.insert(dat['List'],list);
	local list ={};
	list.Value = "34" ;
	list.Name = "卖3价" ;
	table.insert(dat['List'],list);
	local list ={};
	list.Value = "152" ;
	list.Name = "卖4价" ;
	table.insert(dat['List'],list);
	local list ={};
	list.Value = "156" ;
	list.Name = "卖5价" ;
	table.insert(dat['List'],list);
	table.insert(param,dat)
	local dat ={};
	dat['Name'] = '价格浮动(%)';
	dat['Type'] = 'decimal';
	dat['Key'] = 'FloatRate';
	dat['Max'] = 1.0;
	dat['Min'] = 0.0;
	dat['Now'] = 0.1;
	dat['Step'] = 0.1;
	table.insert(param,dat)
	local dat ={};
	dat['Name'] = '每单占比(%)';
	dat['Type'] = 'decimal';
	dat['Key'] = 'Rate';
	dat['Max'] = 100.0;
	dat['Min'] = 0.1;
	dat['Now'] = 5.0;
	dat['Step']=0.1;
	table.insert(param,dat);
	local dat ={};
	dat['Name'] = '结束后继续';
	dat['Type'] = 'Select';
	dat['Key'] = 'Allow';
	dat['List'] = {};
	list ={};
	list.Value = "0" ;
	list.Name = "不允许" ;
	table.insert(dat['List'],list);
	list ={};
	list.Value = "1" ;
	list.Name = "允许" ;
	table.insert(dat['List'],list);
	table.insert(param,dat);
	local dat ={};
	dat['Name'] = '未成交撤单';
	dat['Type'] = 'Select';
	dat['Key'] = 'CanCel';
	dat['List'] = {};
	list ={};
	list.Value = "0" ;
	list.Name = "不允许" ;
	table.insert(dat['List'],list);
	list ={};
	list.Value = "0.25" ;
	list.Name = "15秒" ;
	table.insert(dat['List'],list);
	list ={};
	list.Value = "0.5" ;
	list.Name = "30秒" ;
	table.insert(dat['List'],list);
	list ={};
	list.Value = "1" ;
	list.Name = "60秒" ;
	table.insert(dat['List'],list);
	list ={};
	list.Value = "1.5" ;
	list.Name = "90秒" ;
	table.insert(dat['List'],list);
	table.insert(param,dat);
	
	return param,StrInfo ;
end
    
---print = hx_print;	
	
local g_nowtime;	
local g_Ret;	
function TimerOrder(param)   				--执行代码
	g_Monitor = param.Monitor;
	g_InfoQuote = param.InfoQuote;
	
	g_nowtime = param.NowTime;
	g_Ret = nil;
	if g_Monitor and  next(g_Monitor) then
		g_Monitor= Icecontrol(g_Monitor);
	end	
 	return g_Monitor,g_Ret;
end

function Icecontrol(v)
	if v and next(v) then
		if tonumber(v.EndTime)<=tonumber(v.BeginTime) then
			v['Stop'] = 1;
			return v;
		end
		
		IceInfo(v);	
		JudgeCanCel(v);
		
		local TimeFlag = JudgeTime(v.EndTime,v.Allow); 
		if v.LeftQty == 0 or TimeFlag == 0 or (tonumber(os.date("%H%M%S",g_nowtime))>=145000) then
			v['Stop'] = 1;
			return v;
		end			
				
		local OrderFlag = JudgeOrder(v);
		if v['Stop'] == 0 and v.LeftQty >0 and OrderFlag == 1 and tonumber(os.date("%H%M%S",g_nowtime))>=tonumber(v.BeginTime) then				
			if g_InfoQuote['10'] and  g_InfoQuote['10'] ~='' then				
				local NewPrice =  g_InfoQuote['10'];
				if NewPrice==nil or NewPrice==0 or NewPrice=='' then
						return v;
					end
					
				local vol = IceVol(v);
				local Status,Ret = IceOrder(v,vol,NewPrice);	

				if Status  then
					v = Ret ;
					return v;
				end					
			end															
		end
	end	
	return v;
end

function JudgeCanCel(param)					--在预设的撤单间隔内，对未成交的子单经行撤单
	if param and next(param) then
		local canceltime = initcancel(param.CanCel);
		if param.ClOrdID and canceltime then
			local OrderClOrdID = param.ClOrdID;
			
			for i=1,#OrderClOrdID do
				local OrderStr = OrderClOrdID[i].OrderStatus;
				if OrderStr and not(string.find(OrderStr,'已成')) and not(string.find(OrderStr,'撤')) then
					local timestep;
					if OrderClOrdID[i].OrderEntryTime then
						timestep = JudgeStep(OrderClOrdID[i].OrderEntryTime);
					end
					 
					if timestep and timestep >= canceltime then
						local OrderList = {};
						OrderList.Account = param.Account;
						OrderList.SecurityID = param.SecurityID;
						OrderList.ClOrdID = OrderClOrdID[i].ClOrdID;						
						local Result,Err = OrderCancel(OrderList);
						if Result or string.find(Err,'已撤单') then
							param['ClOrdID'][i].OrderStatus = "已撤";
						elseif string.find(Err,'已成交') then
							param['ClOrdID'][i].OrderStatus = "已成";	
						end	
						return;
					end					
				end				
			end
		end
	end
end

function JudgeStep(time)					--判断当前时间与子单委托时间的时间差
	local nowtime = os.date("%H%M%S",g_nowtime);
	local HH = string.sub(nowtime,1,2)  
    local MM = string.sub(nowtime,3,4)  
	local SS = string.sub(nowtime,5,6)
	local time = string.sub(time,1,2)..string.sub(time,4,5)..string.sub(time,7,8) ;
	local HH2 = string.sub(time,1,2)  
    local MM2 = string.sub(time,3,4)  
	local SS2 = string.sub(time,5,6)  
    local dt1 = os.time{year='2015', month='01', day='01', hour=HH,min=MM,sec=SS}  
	local dt2 = os.time{year='2015', month='01', day='01', hour=HH2,min=MM2,sec=SS2} 
	local a = dt1 - dt2;
	
	if tonumber(nowtime)>=130000 and tonumber(time)<=113000 then
		a = a - 1.5*3600;
	end
	
	return a;	
end

function initcancel(flag)					--初始化撤单间隔时间
	if flag == '0' then
		return;
	elseif flag == '0.25' then
		return 15;	
	elseif flag == '0.5' then
		return 30;
	elseif flag == '1' then
		return 60;
	elseif flag == '1.5' then
		return 90;
	end
end

function JudgeTime(endtime,allow)			--判断超过设定的结束时间后，是否继续
	local nowtime = os.date("%H%M%S",g_nowtime);
	if tonumber(nowtime) >= tonumber(endtime) then
		if allow == '0' then
			return 0;
		end
	end
	return 1;
end

function JudgeOrder(param)					--判断所有完成的子单是否已经完全成交或撤单
	local Flag = 0;
	if param and next(param) then
		if param.ClOrdID and next(param.ClOrdID) then
			local Hisorder = param.ClOrdID;
			local sumorder = 0;
			
			for i=1,#Hisorder do
				local orderstr = Hisorder[i].OrderStatus;
				if orderstr and (orderstr =='已成' or orderstr =='已撤') then
					sumorder = sumorder+1;
				end
			end
			
			if sumorder == #Hisorder then
				Flag = 1;
			end
		else
			Flag = 1;
		end
	end
	return Flag;
end

function IceVol(param)						--计算每笔子单的数量
	if param and next(param) then
		if param.everyvol == nil or param.everyvol == '' then
			param.everyvol = math.floor(param.OrderQty * param.Rate/100/100)*100;
		end
	end

	return param.everyvol;
	
end

function IceOrder(param,vol,newprice)		--根据数量和价格下单
	if param and next(param) then 
		if vol < 100 then
			vol = 100;
		end
		
		if vol > param.LeftQty then
			vol = param.LeftQty;
		end	
		
		local price = DiffPrice(param.Side,newprice,param.FloatRate);
		local OrderList = {} ;		
		OrderList.Account = param.Account;
		OrderList.Side = param.Side;
		OrderList.SecurityID = param.SecurityID;
		OrderList.MarketID = param['MarketID'];
		OrderList.OrderQty = vol;
		OrderList.OrderPrice = price;
		OrderList.Key = param.Key;
		local Result,Ret = OrderBuySell(OrderList);
		g_Ret = Ret;
		if Result then
			param.EntryTime = g_nowtime;	
			param['LastClOrdID'] = Ret.ClOrdID ;	
			return true,param;
		end
	end	
	return false,{};	
end

function DiffPrice(side,price,rate)			--根据预设的浮动价格和最新价，计算每笔子单的委托价格
	local a = price*rate;
	local b = a%1;
	local floatprice;
	if b>=0.5 then
		floatprice = (a-b+1)/100;
	else
		floatprice = (a-b)/100;
	end
	
	local orderprice;
	if side == 'Buy' then
		orderprice =  price + floatprice;
		if g_InfoQuote['69'] and orderprice > tonumber(g_InfoQuote['69']) then
			orderprice = tonumber(g_InfoQuote['69']);
		end
	else
		orderprice =  price - floatprice;
		if g_InfoQuote['70'] and orderprice < tonumber(g_InfoQuote['70']) then
			orderprice = tonumber(g_InfoQuote['70']);
		end
	end
	return orderprice;
	
end

function IceInfo(param)                 	--界面显示母单信息
	if param and next(param) then
		if param.Str==nil or param.Str=='' then
			param.Str = '监控单 '..param.SecurityID..',';
			if param.Side =='Sell' then
				param.Str = param.Str..' 卖出 ' ;
			else 
				param.Str = param.Str..' 买入 '
			end
			param.Str = param.Str..param.OrderQty..'股！';
		end
		
--~ 		if param.initflag == nil or param.initflag == '' then
--~ 			local NowTime = os.date("%H%M%S",os.time());
--~ 			if tonumber(param.BeginTime) <= math.max(93000,tonumber(NowTime)) then
--~ 				param.BeginTime = tostring(math.max(930,tonumber(NowTime)));
--~ 				if tonumber(param.BeginTime) < 130000 and tonumber(param.BeginTime)>113000 then
--~ 					param.BeginTime = '130000';
--~ 				end
--~ 				
--~ 				if string.len(param.BeginTime) == 5 then
--~ 					param.BeginTime = '0'..param.BeginTime;
--~ 				end
--~ 			end

--~ 			if tonumber(param.EndTime) <= math.min(150000,tonumber(NowTime)) then
--~ 				param.EndTime = tostring(math.min(150000,tonumber(NowTime)));
--~ 				if tonumber(param.EndTime) < 130000 and tonumber(param.EndTime)>113000 then
--~ 					param.EndTime = '113000';
--~ 				end
--~ 				
--~ 				if string.len(param.EndTime) == 5 then
--~ 					param.EndTime = '0'..param.EndTime;
--~ 				end		
--~ 			end
--~ 			param.initflag = 1;
--~ 		end
	end	
end