--~ g_MonitorList
--~ g_InfoQuoteList
--~ g_InfoHqList
--~ local g_Param ={};

local g_Monitor ={};
local g_InfoQuote ={};

local g_time;
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
 ['EntryTime'] = '23134646546' ,
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
 ['1']= '1265465465465465465',
 
 
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
.......

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
	local StrInfo = [[TWAP将交易时间进行均匀分割，并在每个分割节点
	上将均匀拆分的订单进行提交。TWAP 策略设计的目的是在使交易对市场
	影响最小化的同时提供一个较低的平均成交价格，从而达到减小交易成本
	的目的。]];
	
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
	table.insert(param,dat)
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
	local list ={};
	list.Value = "MarketPriceOrder";
	list.Name = "市价委托" ;
	table.insert(dat['List'],list);
	table.insert(param,dat)
	local dat ={};
	dat['Name'] = '下单间隔';
	dat['Type'] = 'number';
	dat['Key'] = 'Second';
	dat['Max'] = 100000;
	dat['Min'] = 1;
	dat['Now'] = 15;
	dat['Step'] = 1
	table.insert(param,dat);
	return param,StrInfo;
end


function TimerOrder(param)   						--执行代码
    local orderret;
	g_Monitor = param.Monitor;
	g_InfoQuote = param.InfoQuote;

	g_time = param.NowTime ; 
	if g_Monitor and  next(g_Monitor) then	
		g_Monitor,orderret = twapcontrol(g_Monitor);  
	end	

 	return g_Monitor,orderret;
end

function twapcontrol(v)
	local orderret;
	if v and next(v) then
		if v.LeftQty == 0 then
			v['Stop'] = 1;
			return v;
		end
		-----获取母单信息
		v = twapinfo(v);    
		
		--第一次计算下单次数，若已经计算，则跳过
		if v.Num == nil and v.flag == nil and v['Stop'] == 0 then
			v.BeginTime,v.EndTime = inittime(v.BeginTime,v.EndTime);
			if not(v.BeginTime and v.EndTime) then
				v['Stop'] = 1;
				return v;
			elseif tonumber(v.BeginTime)<113000 and tonumber(v.EndTime)>=130000 then
				v.TimeFlag = true;	
			end
			v.Num,v.flag = totaltimes(v.BeginTime,v.EndTime,v.Second);
		end
		
		--处理算法开始时间在上午，结束时间在下午这一特殊情况的下单问题
		if v and v.TimeFlag and v.EntryTime and tonumber(os.date("%H%M%S",v.EntryTime+v.Second))>113000 then
			v.EntryTime =  v.EntryTime + 1.5*3600;
			v.TimeFlag = false;			
		end
		
		
		local Time = g_time;
		if v['Stop'] == 0 and v.LeftQty >=100 and tonumber(os.date("%H%M%S",Time))>=tonumber(v.BeginTime) then
			if (v.LastClOrdID==nil or (Time-v.EntryTime) >= v.Second ) then			
				if v.StockPosition and  v.StockPosition ~='' then
					local price;
					if v.StockPosition == "MarketPriceOrder" then
						price = "MarketPrice";
					else
						price =  g_InfoQuote[tostring(v.StockPosition)];
					end
					
					if price == nil or price == "" then
						return v;
					end
					
					local vol = twapvol(v);
					local Status,Ret = twaporder(v,vol,price);	
					if Status  then
						orderret = Ret ;
						
					end					
				end												
			end
		end
		return v,orderret;
	end
	
end

function inittime(begintime,endtime)  				--处理开始时间与结束时间参数  
		
	 local ticktime = g_time;
	 local NowTime = os.date("%H%M%S",ticktime);

	if tonumber(begintime) <= math.max(93000,tonumber(NowTime)) then
		begintime = tostring(math.max(93000,tonumber(NowTime)));
		if tonumber(begintime) < 130000 and tonumber(begintime)>113000 then
			begintime = '130000';
		end
		if string.len(begintime) == 5 then
			begintime = '0'..begintime;
		end
	end
	
	if tonumber(endtime) <= tonumber(NowTime) then
		return;
	elseif tonumber(endtime)>=150000 then
		endtime = "150000";	
	elseif tonumber(endtime) < 130000 and tonumber(endtime)>113000 then
		endtime = '113000';
	end
	
	if string.len(endtime) == 5 then
		endtime = '0'..endtime;
	end
	
	if tonumber(begintime)>=tonumber(endtime) then
		return;
	end

	return begintime,endtime;

end

function totaltimes(begintime,endtime,second)       --计算下单次数
	local HH = string.sub(begintime,1,2);  
    local MM = string.sub(begintime,3,4);  
	local SS = string.sub(begintime,5,6);  
	local HH2 = string.sub(endtime,1,2) ; 
    local MM2 = string.sub(endtime,3,4) ; 
	local SS2 = string.sub(endtime,5,6)	;
	local flag = 0;

	--计算策略初始时间的时间差
    local dt1 = os.time{year='2015', month='01', day='01', hour=HH,min=MM,sec=SS};  
	local dt2 = os.time{year='2015', month='01', day='01', hour=HH2,min=MM2,sec=SS2 }; 
	local c= (dt2- dt1);

	if tonumber(begintime) <= 113000 and tonumber(endtime) >= 130000 then
		c = c - 1.5*3600;
		flag = 1;
	end	
	--根据时间差和下单间隔，计算下单次数
	local num = math.ceil(c/second);
--~ 	print(num,flag)
	return num,flag;
	
end

function twapvol(v)                      			--计算当前的子单大小
	local vol;
	if v and next(v) then
		if v.Num >= 1 then
			local a = v.LeftQty/100;
			local b = (a/v.Num)%1;

			if b>=0.5 then							--调整子单大小
				vol = math.floor(a/v.Num )*100 + 100;
			else
				vol = math.floor(a/v.Num )*100;
				if v.sumtwap == nil then
					v.sumtwap = 0;
				end
				
				if vol < 100 then					--若子单量不足一手，则累加到满足一手时下单
					v.sumtwap = v.sumtwap + (a/v.Num)*100;
					if v.sumtwap >= 100 then
						vol = math.floor(v.sumtwap/100)*100;
						v.sumtwap = v.sumtwap - vol;
					else
						vol = 0;
--~ 						print('下单不足'..v.sumtwap)
					end
				end
			end	
		else
			vol = v.LeftQty;
			v['Stop']=1;
		end
		
		v.Num = v.Num - 1;
		return vol;
	end
end

function twaporder(v,vol,price)             		--TWAP策略下单
    local Ret ={};
	if v and next(v) then  
		local Result = false;
		
		if vol >= 100 then
			local OrderList = {} ;
			OrderList.Account = v.Account;
			OrderList.Side = v.Side;
			OrderList.SecurityID =v.SecurityID;
			OrderList.MarketID = v['MarketID'];
			OrderList.OrderQty = vol;
			OrderList.OrderPrice = price;
			OrderList.Key = v.Key;
			Result,Ret = OrderBuySell(OrderList);
			
			if Result then				
				v.EntryTime = g_time;	   
				v['LastClOrdID'] =Ret.ClOrdID ;				
				return true,Ret;
			end
		end
	end
	
	return true,Ret;	
end

function twapinfo(param)                 			--界面显示母单信息
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
	end	
	return param;
end


--[[
----orderret-->
{
 ["Str"] = "监控单 000001, 买入 1000000股！",
 ["Index"] = 0,
 ["flag"] = 0,
 ["BackTestDate"] = "20150518",
 ["LeftQty"] = 1000000,
 ["BeginTime"] = "093002",
 ["LastClOrdID"] = 0,
 ["TradeVolume"] = 0,
 ["Num"] = 239,
 ["Side"] = "Buy",
 ["Symbol"] = "平安银行",
 ["EndTime"] = "103000",
 ["Second"] = 15,
 ["OrderQty"] = 1000000,
 ["Stop"] = 0,
 ["EntryTime"] = "1431912602",
 ["MarketID"] = "SZA",
 ["Account"] = "wanghao@myhexin.com_20150519175020",
 ["StockPosition"] = "10",
 ["SecurityID"] = "000001",
}

]]--
