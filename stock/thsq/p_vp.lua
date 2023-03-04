--~ g_MonitorList
--~ g_InfoQuoteList
--~ g_InfoHqList
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

 ["70"] = 14.72,
 ["152"] = 16.51,
 ["55"] = "平安银行",
 ["34"] = 16.5,
 ["35"] = 138100,
 ["157"] = 6100,
 ["29"] = 54927,
 ["10"] = 16.48,
 ["153"] = 12000,
 ["69"] = 18,
 ["28"] = 16.44,
 ["154"] = 16.42,
 ["25"] = 3200,
 ["150"] = 16.43,
 ["156"] = 16.52,
 ["151"] = 64060,
 ["7"] = 17,
 ["6"] = 16.36,
 ["155"] = 60300,
 ["24"] = 16.46,
 ["27"] = 161555,
 ["26"] = 16.45,
 ["31"] = 147852,
 ["30"] = 16.48,
 ["33"] = 68360,
 ["32"] = 16.49,}


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
function TypeInit()   								--参数规划 ，只在初始化时候执行
	local param = {};
	local StrInfo = [[该策略可以帮助投资者在要求的时间范围内完成规模相当于
		市场交易量指定比例的委托交易，该指定比例称作参与率，投资者可以通过设定
		不同的参与率来控制自己的交易节奏，跟踪市场行情。]];
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
	table.insert(param,dat)
--~ 	
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
	dat['Name'] = '分段周期(分)';
	dat['Type'] = 'Select';
	dat['Key'] = 'Period';
	dat['List'] = {};
	list ={};
	list.Value = "oneminute" ;
	list.Name = "1" ;
	table.insert(dat['List'],list);
	list ={};
	list.Value = "fiveminutes" ;
	list.Name = "5" ;
	table.insert(dat['List'],list);
	list ={};
	list.Value = "fifteenminutes" ;
	list.Name = "15" ;
	table.insert(dat['List'],list);
	table.insert(param,dat)
	local dat ={};
	dat['Name'] = '参与率(%)';
	dat['Type'] = 'decimal';
	dat['Key'] = 'ParticiRate';
	dat['Max'] = 100.00;
	dat['Min'] = 0.00;
	dat['Now'] = 1.00;
	dat['Step']=0.01;
	table.insert(param,dat)
	local dat ={};
	dat['Name'] = '下单间隔';
	dat['Type'] = 'number';
	dat['Key'] = 'Second';
	dat['Max'] = 1000000;
	dat['Min'] = 1;
	dat['Now'] = 15;
	dat['Step'] = 1;
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

	return param,StrInfo ;
end

local g_nowtime;
local g_Ret;
--~ print = hx_print;
function TimerOrder(param)  						--执行代码
	
	g_Monitor= param.Monitor;
	g_InfoQuote= param.InfoQuote;

    g_nowtime = param.NowTime;
	g_Ret = nil;
	if g_Monitor and  next(g_Monitor)  then
		g_Monitor = vpcontrol(g_Monitor);
		
	end
	return g_Monitor,g_Ret;
end

function vpcontrol(v)
	if v and next(v) then
			
		if v.LeftQty == 0 or (tonumber(v.BeginTime)>=tonumber(v.EndTime)) or (tonumber(os.date("%H%M%S",g_nowtime))>=145950) then
			v['Stop'] = 1;
			return v;
		end

		v = vpinfo(v);
		local Time = g_nowtime;
		if not(v['VP'] and next(v['VP'])) then
			v = vpinit(v);
			if v['Stop'] == 1 then
				return v;
			end
		else			
			local Flag = checkstop(v['VP']);
			if Flag == 0 then
				v['Stop'] = 1;
				return;
			end
			if v.Allow == '0' and tonumber(os.date("%H%M%S",Time))>tonumber(v.EndTime) then
				v['Stop'] = 1;
				return;
			end
		end
		
		--处理算法开始时间在上午，结束时间在下午这一特殊情况的下单问题
		if v and v.TimeFlag and v.EntryTime and tonumber(os.date("%H%M%S",v.EntryTime+v.Second))>113000 then
			v.EntryTime =  v.EntryTime + 1.5*3600;
			v.TimeFlag = false;			
		end
		
		if v.LeftQty >0 and v['Stop']==0  and tonumber(os.date("%H%M%S",Time))>=tonumber(v.BeginTime) then
			if v.LastClOrdID==nil or  ((Time-v.EntryTime)>=v.Second ) then
				if v.StockPosition  and  v.StockPosition ~='' then
					local price =  g_InfoQuote[tostring(v.StockPosition)];
					if price==nil or price==0 or price=='' then
						return param;
					end
					local Status,Ret = vporder(v,price);
					
					if Status  then
						v = Ret ;
						return v;
					end					
				end	
			end
		end			
	end
	return v;
end

function vpinfo(param)                              --界面显示母单信息
	if param and next(param) then
		if param.Str==nil or param.Str=='' then
			param.Str = '监控单 '..param.SecurityID..',时间范围'..param.BeginTime..'-'..param.EndTime..',下单间隔 '..param.Second..'秒,';
			if param.Side =='Sell' then
				param.Str = param.Str..' 卖出 ' ;
			else 
				param.Str = param.Str..' 买入 ';
			end
			param.Str = param.Str..param.OrderQty..'股！';
		end
	end	
	return param;
end

function inittime(begintime,endtime,allow)          --处理开始时间与结束时间参数
	local NowTime = os.date("%H%M%S",g_nowtime);
	if tonumber(begintime) <= math.max(93000,tonumber(NowTime)) then
		begintime = tostring(math.max(93000,tonumber(NowTime)));
		if tonumber(begintime) < 130000 and tonumber(begintime)>113000 then
			begintime = '130000';
		end
		if string.len(begintime) == 5 then
			begintime = '0'..begintime;
		end
	end
	
	if allow == '0' then
		if tonumber(begintime) <= tonumber(NowTime) then
			begintime = tostring(NowTime);
			if tonumber(begintime) < 130000 and tonumber(begintime)>113000 then
				begintime = '130000';
			end
		
			if string.len(begintime) == 5 then
				begintime = '0'..begintime;
			end
		end
	
		if tonumber(endtime) <= tonumber(NowTime) then
			begintime = endtime;
			return begintime,endtime;
		end

		if tonumber(endtime) < 130000 and tonumber(endtime)>113000 then
			endtime = '113000';
		end
		if string.len(endtime) == 5 then
			endtime = '0'..endtime;
		end		
		
	else
		endtime = '150000';
	end
	
	return begintime,endtime;

end

function checkstop(param)                           --检查是否已经结束
	local flag = 0;
	if param and next(param) then
		for i=1,#param do
			if param[i][2] ~= 0 and  param[i][3] ~= 0  then
				flag = 1;
				break
			end
		end
	end
	return flag;
end

function vporder(v,price)							--VP策略下单
	if v and v['VP'] and next(v['VP']) then
		
		for i=1,#(v['VP']),1 do
			local val = v['VP'][i] ;
			local Result =false ;
			local Ret;
			local qty = 0;
			if val[2]>0 then
				--将时间间隔内计算好的委托数量，按照计算好的下单次数经行下单
				qty= val[2]/val[3];
				if qty<100 then
					if qty > 0 then						
						qty = 100;					
					else
						break
					end
				else
					--当剩余委托量不足时，按剩余量下单
					qty = math.floor(qty/100)*100;
					if (v.LeftQty - qty) <100  then
						qty = v.LeftQty;
					end
				end

				local OrderList = {};
				OrderList.Account = v.Account;
				OrderList.Side = v.Side;
				OrderList.SecurityID = v.SecurityID;
				OrderList.MarketID = v['MarketID'];
				OrderList.OrderQty = qty;
				OrderList.OrderPrice = price;
				OrderList.Key = v.Key;

				Result,Ret = OrderBuySell(OrderList);
				g_Ret = Ret;
				if Result then
					v['VP'][i][3] = val[3] - 1;
					v['VP'][i][2] = val[2] - qty;
					v['LastClOrdID'] = Ret.ClOrdID ;

					return true,v;
				else
					return false,{};
				end

			end
		end
	end
	return false,{};
end

function initdate()									--初始化参考周期  默认取截止到当前交易日前的30天
	local enddate= os.date("%Y%m%d",g_nowtime - 24*3600)..'15'..'00';
	local time1 = os.time{year=string.sub(enddate,1,4), month=string.sub(enddate,5,6), day=string.sub(enddate,7,8), hour='09',min='30',sec='00'}
	local time2 = time1 - 24*30*3600;
	local startdate = os.date("%Y%m%d%H%M",time2);
	
	return startdate,enddate;
	
end

function vpinit(v)									--VP初始化，计算各时间段内的委托量
	
	local StartDate,EndDate = initdate();
	local Ret,ErrMsg = GetKLineHq(v.SecurityID,v.Period,StartDate,EndDate);
	
	local detail = {};
	if Ret and next(Ret) then
		local param  ={};
		for i=1,#Ret,1 do	
			local value = Ret[i] ;
			local time = string.sub(value['Time'],9,12);
			if param[time]==nil  then
				param[time] = 0 ;
			end
			if param[time] then
				param[time] = param[time]+value['Vol'];
			end
		end
		if param and next(param) then
			for kk,vv in  pairs(param) do
				table.insert(detail,{tonumber(kk),vv});
			end
			table.sort(detail,function(a, b) return tonumber(b[1])>tonumber(a[1]) end);
		end
		detail  = initkline(detail);
		for i=1,#detail do
			if #(tostring(detail[i][1])) == 5 then
				detail[i][1] = '0'..detail[i][1];
			end
		end
	end
	
	v.BeginTime,v.EndTime = inittime(v.BeginTime,v.EndTime,v.Allow);
	if tonumber(v.BeginTime) >= tonumber(v.EndTime) then
		return v;
	elseif tonumber(v.BeginTime)<113000 and tonumber(v.EndTime)>=130000 then
		v.TimeFlag = true;
	end
	
	local begintt= string.sub(v.BeginTime,1,4);
	local endtt = string.sub(v.EndTime,1,4);

	--根据历史成交量数据，预测当日成交量分布状况
	if detail and next(detail) then
		local alldetail = 0;
		for i=1,#detail,1 do
			local lasttime ;
			if i==1 then
				lasttime = '0930' ;
			else 
				lasttime = detail[i-1][1] ;
			end	
			if tonumber(begintt)<=tonumber(lasttime) then
				if tonumber(endtt)>=tonumber(detail[i][1]) then
					local len2 = math.floor(OrderTimeDev(detail[i][1]..'00',lasttime..'00')/60) ;
					detail[i][2] = detail[i][2];
					detail[i][3] = len2;
				else
					local len1 = math.floor(OrderTimeDev(detail[i][1]..'00',lasttime..'00')/60) ;
					local len2 = math.floor(OrderTimeDev(endtt..'00',lasttime..'00')/60) ;
					detail[i][2] = detail[i][2]*len2/len1;
					detail[i][3] = len2	;			
				end
			elseif tonumber(begintt)>tonumber(lasttime) and tonumber(begintt)<=tonumber(detail[i][1]) then
--~ 				print('bbbb',lasttime,detail[i][1])
				if tonumber(endtt)>=tonumber(detail[i][1]) then
					local len1 = math.floor(OrderTimeDev(detail[i][1]..'00',lasttime..'00')/60) ;
					local len2 = math.floor(OrderTimeDev(detail[i][1]..'00',begintt..'00')/60) ;
					detail[i][2] = detail[i][2]*len2/len1;
					detail[i][3] = len2;
				else
					local len1 = math.floor(OrderTimeDev(detail[i][1]..'00',lasttime..'00')/60) ;
					local len2 = math.floor(OrderTimeDev(endtt..'00',begintt..'00')/60) ;
					detail[i][2] = detail[i][2]*len2/len1;
					detail[i][3] = len2;
				end
			elseif  tonumber(begintt)>tonumber(detail[i][1]) or tonumber(endtt)<=tonumber(lasttime) then
--~ 				print('cccc',lasttime,detail[i][1])
				detail[i][2] = 0;
				detail[i][3] = 0;
			end
			alldetail = alldetail + detail[i][2];
			detail[i][3] = math.floor(detail[i][3]*60/v.Second);
		end

		local allqty = v.OrderQty; 
		for i=1,#detail,1 do
			if allqty == 0 then
				break
			end
			
			--根据设定的参与率，确定各时间间隔内的委托数量和下单次数
			if detail[i][2] > 0 then
				local ParticiRate = tonumber(v.ParticiRate);
				if ParticiRate==0 then
					v['Stop'] = 1;
					return v ;
				end
				
				local a = math.floor(detail[i][2]*ParticiRate/(#detail)/100)*100;

				if a >= allqty then
					detail[i][2] = allqty;
					for k=(i+1),#detail do
						detail[k][2] = 0;
						detail[k][3] = 0;
					end
					allqty = 0;
					break										
				else
					if a < 100 then
						detail[i][2] = 100;
						allqty = allqty - 100;
						detail[i][3] = 1;
					else
						detail[i][2] = a;
						allqty = allqty - a;
					end					
				end				
			end
		end
	end

	v['VP'] = detail ;
	
	return v ;
end

function initkline(param)							--处理09:30与13:00特殊的K线数据
	local a;
	local b;
	if param and next(param) then
		for i=1,#param do
			if param[i][1] == 930 then
				param[i+1][2] =  param[i+1][2] + param[i][2];
				a = i;
			end
			if param[i][1] == 1300 then
				param[i+1][2] =  param[i+1][2] + param[i][2];
				b = i;
			end
		end
		if a then
			if b then
				table.remove(param,a);
				table.remove(param,b - 1);
			else
				table.remove(param,a);
			end
		end

	end
	return param;
end

function OrderTimeDev(Time,Time2)					--时间计算函数
    if string.len(Time) == 5 then
		Time = '0'..Time;
	end
	if string.len(Time2) == 5 then
		Time2 = '0'..Time2;
	end
	
	local HH = string.sub(Time,1,2);  
    local MM = string.sub(Time,3,4) ; 
	local SS = string.sub(Time,5,6) ; 
	local HH2 = string.sub(Time2,1,2) ; 
    local MM2 = string.sub(Time2,3,4);  
	local SS2 = string.sub(Time2,5,6) ; 
    local dt1 = os.time{year='2015', month='01', day='01', hour=HH,min=MM,sec=SS} ; 
	local dt2 = os.time{year='2015', month='01', day='01', hour=HH2,min=MM2,sec=SS2 } ;
	local b = dt2;
	local c = (dt1- dt2);
	local num = 0;
	
	for i=1,c,1 do 
		local new = tonumber(os.date("%H%M%S", b + i ));
		if (new>93000 and new<=113000) or (new>=130000 and new<=150000)  then 
			num = num + 1;
		end
	end
	
    return num;
end