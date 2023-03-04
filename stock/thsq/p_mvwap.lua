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
function TypeInit()   --参数规划 ，只在初始化时候执行
	local param = {};
	local StrInfo = [[基于对传统的MVWAP算法进行优化和改进。当市场实时价格
	小于此时的VWAP市场价时，在原有计划交易量的基础上进行放大（*1.7），如果能够将
	放大的部分成交或部分成交，则有助于降低VWAP成交价；反之，当市场实时
	价格大于此时的VWAP市场价时，在原有计划交易量的基础上进行缩减（*0.3），也有助
	于降低VWAP成交价，从而达到控制交易成本的目的。]];
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
	dat['Name'] = '样本天数';
	dat['Type'] = 'number';
	dat['Key'] = 'Days';
	dat['Max'] = 1000000;
	dat['Min'] = 1;
	dat['Now'] = 30;
	dat['Step'] = 1
	table.insert(param,dat)
	local dat ={};
	dat['Name'] = '下单间隔';
	dat['Type'] = 'number';
	dat['Key'] = 'Second';
	dat['Max'] = 1000000;
	dat['Min'] = 1;
	dat['Now'] = 15;
	dat['Step'] = 1
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
	
	return param,StrInfo;
end



local g_nowtime;
local g_Ret;
--~ print = hx_print;
function TimerOrder(param)  								--执行代码
	
	g_Monitor= param.Monitor;
	g_InfoQuote= param.InfoQuote;
    g_nowtime = param.NowTime;
	g_Ret = nil;
	if g_Monitor and  next(g_Monitor) then
		g_Monitor = mvwapcontrol(g_Monitor);
	end
	return g_Monitor,g_Ret;
end

function mvwapcontrol(param)
	if param and next(param) then			
		if param.LeftQty == 0 or (tonumber(os.date("%H%M%S",g_nowtime))>=145950) then
			param['Stop'] = 1;
			return param;
		end
		
		param = mvwapinfo(param);
		if not(param['MVWAP'] and next(param['MVWAP'])) then

			param.BeginTime,param.EndTime = inittime(param.BeginTime,param.EndTime);
			if tonumber(param.BeginTime) >= tonumber(param.EndTime) then
				param['Stop'] = 1;
				return param;
			elseif tonumber(param.BeginTime)<113000 and tonumber(param.EndTime)>=130000 then
				param.TimeFlag = true;
			end
			param = mvwapinit(param);
		else
			local Flag = checkstop(param['MVWAP']);
			if Flag == 0 then
				if param.Allow == '0' then
					param['Stop'] = 1;
					return param;
				else
					param.BeginTime,param.EndTime = UpdateTime(param.BeginTime,param.EndTime,param.Second,param.MarketID);
					if param.BeginTime and param.EndTime then
						if tonumber(param.BeginTime)<113000 and tonumber(param.EndTime)>=130000 then
							param.TimeFlag = true;
						end
						param = mvwapinit(param);
					else
						param['Stop'] = 1;
						return param;
					end					
				end								
			end
		end
		
		local Time = g_nowtime;	
		--处理算法开始时间在上午，结束时间在下午这一特殊情况的下单问题
		if param and param.TimeFlag and param.EntryTime and tonumber(os.date("%H%M%S",param.EntryTime+param.Second))>113000 then
			param.EntryTime =  param.EntryTime + 1.5*3600;
			param.TimeFlag = false;			
		end
		
		if param.LeftQty >=100 and param['Stop']==0 and tonumber(param.BeginTime)<=tonumber(os.date("%H%M%S",Time)) then
			if param.LastClOrdID==nil or  ((Time-param.EntryTime)>=param.Second ) then
				if param.StockPosition  and  param.StockPosition ~='' then
					local price =  g_InfoQuote[tostring(param.StockPosition)];
					if price==nil or price==0 or price=='' then
						return param;
					end
					local Status,Ret = mvwaporder(param,price);
					
					if Status  then
						param = Ret ;
						return param;
					end					
				end	
			end
		end			
	end
	return param;
end

function UpdateTime(begintime,endtime,second,market)	 	--更新下单结束后的初始时间，以便对为完成的数量继续委托
	if tonumber(endtime) >= 150000 then
		return;
	end
	
	local HH = string.sub(begintime,1,2)  
    local MM = string.sub(begintime,3,4)  
	local SS = string.sub(begintime,5,6)  
	local HH2 = string.sub(endtime,1,2)  
    local MM2 = string.sub(endtime,3,4)  
	local SS2 = string.sub(endtime,5,6)  
    local dt1 = os.time{year='2015', month='01', day='01', hour=HH,min=MM,sec=SS}; 
	local dt2 = os.time{year='2015', month='01', day='01', hour=HH2,min=MM2,sec=SS2};	
	local c= (dt2- dt1);
	
	if tonumber(begintime)<113000 and tonumber(endtime)>130000 then
		c = c- 1.5*3600;
	end
	
	local NewBegintime = dt2 + second;
	local NewEndtime = NewBegintime + c;
	if tonumber(endtime)<=113000 then		
		if tonumber(os.date("%H%M%S",NewBegintime)) > 113000 then
			NewBegintime = NewBegintime +1.5*3600;
			NewEndtime = NewBegintime + c;
		elseif tonumber(os.date("%H%M%S",NewEndtime)) > 113000 then
			NewEndtime = NewEndtime + 1.5*3600;
		end
	end

	NewBegintime = os.date("%H%M%S",NewBegintime);
	NewEndtime = os.date("%H%M%S",NewEndtime);
	
	if tonumber(NewBegintime) > 150000 then
		return;
	end
	
	if tonumber(NewEndtime) > 150000 then
		if string.sub(market,1,2) == 'SH' then
			NewEndtime = '150000'
		else			
			NewEndtime = '145700';
		end
	end	

	return NewBegintime,NewEndtime;
end

function inittime(begintime,endtime)              			--处理开始时间与结束时间参数
	if tonumber(endtime) >= 150000 then
		endtime = '150000';
	end
	
	if tonumber(begintime)<=93000 then
		begintime = '093000'
	end
	
	local NowTime = os.date("%H%M%S",g_nowtime);
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
	
	return begintime,endtime;
end

function vwapmarket(param)									--计算市场VWAP
	local sumvalue = 0;
	local sumvol = 0;
	if param and next(param) then
		if param.market == nil then
			param.market = {};
		end
			
		if g_InfoQuote and next(g_InfoQuote) and g_InfoQuote['10'] and g_InfoQuote['49'] then
			local a = {g_InfoQuote['10'],g_InfoQuote['49']};
			table.insert(param.market,a);
			
			for i=1,#(param.market) do
				local pricevalue = param.market[i];
				sumvalue = sumvalue +  pricevalue[1]*pricevalue[2];
				sumvol = sumvol + pricevalue[2];
			end
			return sumvalue/sumvol - (sumvalue/sumvol)%0.01;
		else
			return nil;
		end		
	end
end

function checkstop(param)                               	--检查是否已经结束
	local flag = 0;
	if param and next(param) then
		for i=1,#param do
			if param[i][3] ~= 0 then
				flag = 1;
				break
			end
		end
	end
	return flag;
end

function UpdateRate(param) 									--更新各K线上的比率 	
	
	if param and next(param) then
		local sum = 0;
		for i=1,#param do
			if param[i][2] ~= 0 then
				sum = sum + param[i][2];
			end			
		end
		
 		local sumtt = 0;
		for i=1,#param do
			if param[i][2] ~= 0 then
				n = i;
			end
		end
		
		for i=1,#param do
			if param[i][2] ~= 0 then
				m= i;
				break;
			end
		end
			
		for i =m,n-1 do
			param[i][2] = param[i][2]/sum;
			sumtt = sumtt + param[i][2];
		end
		param[n][2] = 1 - sumtt;					
	end	
	return param;
end

function mvwaporder(v,price)								--MVWAP下单
	local marketvwap = vwapmarket(v);
	if v and v['MVWAP'] and next(v['MVWAP']) then
		for i=1,#(v['MVWAP']),1 do
			local val = v['MVWAP'][i] ;
			local Result = false;
			local Ret;
			local qty = 0;
			if val[3]>0 then
				qty = v.LeftQty * val[2]/val[3];
				if not(marketvwap) then
					marketvwap = price;
				end

				if price >= marketvwap then
					qty = qty*0.3;
				else
					qty = qty*1.7;
				end
				
				
				if qty < 100 then
					qty = 100;
				else
					qty = math.floor(qty/100)*100;
				end
				
				if qty >= v.LeftQty  then
					qty = v.LeftQty;
				end
				
				local OrderList = {};
				OrderList.Account = v.Account
				OrderList.Side = v.Side;
				OrderList.SecurityID = v.SecurityID;
				OrderList.MarketID = v['MarketID'];
				OrderList.OrderQty = qty;
				OrderList.OrderPrice = price;
				OrderList.Key = v.Key;

				Result,Ret = OrderBuySell(OrderList);	
				g_Ret = Ret;
				if Result then
					val[2] = val[2] - val[2]/val[3];
					val[3] = val[3] - 1;
					v['MVWAP'] = UpdateRate(v['MVWAP']);					
					v['LastClOrdID'] = Ret.ClOrdID ;
					v['EntryTime'] = g_nowtime;
					--print("entytime///////////////",g_nowtime)
					return true,v;
				else
					return false,{};
				end
			end
		end
	end
	return false,{};
end

function mvwapinfo(param)                               	--界面显示母单信息
	if param and next(param) then
		if param.Str==nil or param.Str=='' then
			param.Str = '监控单 '..param.SecurityID..',时间范围'..param.BeginTime..'-'..param.EndTime..',下单间隔 '..param.Second..'秒,';
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
	
function initdate(day)										--初始化样本天数
	local enddate= os.date("%Y%m%d",g_nowtime - 24*3600)..'15'..'00';
	local time1 = os.time{year=string.sub(enddate,1,4), month=string.sub(enddate,5,6), day=string.sub(enddate,7,8), hour='09',min='30',sec='00'}
	local time2 = time1 - 24*day*3600;
	local startdate = os.date("%Y%m%d%H%M",time2);
	
	return startdate,enddate;	
end

function initkline(param)									--对930和1300时间点的K线数据处理
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

function mvwapinit(v)										--下单比例初始化
	local StartDate,EndDate = initdate(v.Days);
	local Ret,ErrMsg = GetKLineHq(v.SecurityID,v.Period,StartDate,EndDate);
	
	local detail ={};
	if Ret and next(Ret) then
		local param  ={};
		for i=1,#Ret,1 do
			local value = Ret[i] ;
			local time = string.sub(value['Time'],9,12);
			if param[time]==nil  then
				param[time] = 0 ;
			end
			if param[time] then
				param[time] = param[time]+value['Vol'] ;
			end
		end
		
		
		if param and next(param) then
			for kk,vv in  pairs(param) do
				table.insert(detail,{tonumber(kk),vv});
			end
			table.sort(detail,function(a, b) return tonumber(b[1])>tonumber(a[1]) end);
		end	
		for i=1,#detail do
			if detail[i][2] == 0 then
				 detail[i][2] =  detail[i-1][2];
			end
		end	
		detail  = initkline(detail);	
	else
		return v;
	end
 	
	begintt = string.sub(v.BeginTime,1,4);
	endtt = string.sub(v.EndTime,1,4);

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
					detail[i][3] = len2
				else
					local len1 = math.floor(OrderTimeDev(detail[i][1]..'00',lasttime..'00')/60) ;
					local len2 = math.floor(OrderTimeDev(endtt..'00',lasttime..'00')/60) ;
					detail[i][2] = detail[i][2]*len2/len1;
					detail[i][3] = len2
				end
			elseif tonumber(begintt)>=tonumber(lasttime) and tonumber(begintt)<tonumber(detail[i][1]) then
				if tonumber(endtt)>=tonumber(detail[i][1]) then
					local len1 = math.floor(OrderTimeDev(detail[i][1]..'00',lasttime..'00')/60) ;
					local len2 = math.floor(OrderTimeDev(detail[i][1]..'00',begintt..'00')/60) ;
					detail[i][2] = detail[i][2]*len2/len1;
					detail[i][3] = len2
				else
					local len1 = math.floor(OrderTimeDev(detail[i][1]..'00',lasttime..'00')/60) ;
					local len2 = math.floor(OrderTimeDev(endtt..'00',begintt..'00')/60) ;
					detail[i][2] = detail[i][2]*len2/len1;
					detail[i][3] = len2
				end
			elseif  tonumber(begintt)>=tonumber(detail[i][1]) or tonumber(endtt)<=tonumber(lasttime) then
				detail[i][2] = 0;
				detail[i][3] = 0;
			end
			alldetail = alldetail + detail[i][2];
			detail[i][3] = math.floor(detail[i][3]*60/v.Second);
		end
 		
		local sumrate = 0;
		for i=1,#detail-1,1 do
			if detail[i][2] > 0 then 
				detail[i][2] = detail[i][2]/alldetail;
				sumrate = sumrate + detail[i][2]
			end
		end
		detail[#detail][2] = 1 - sumrate;
	end
	v['MVWAP'] = detail;
	return v ;
end
	
function OrderTimeDev(Time,Time2)                        	--时间计算函数
	if string.len(Time) == 5 then
		Time = '0'..Time;
	end
	if string.len(Time2) == 5 then
		Time2 = '0'..Time2;
	end
	
    local HH = string.sub(Time,1,2)  
    local MM = string.sub(Time,3,4)  
	local SS = string.sub(Time,5,6)  
	local HH2 = string.sub(Time2,1,2)  
    local MM2 = string.sub(Time2,3,4)  
	local SS2 = string.sub(Time2,5,6)  
    local dt1 = os.time{year='2015', month='01', day='01', hour=HH,min=MM,sec=SS}  
	local dt2 = os.time{year='2015', month='01', day='01', hour=HH2,min=MM2,sec=SS2 } 
	local b = dt2 ;
	local c= (dt1- dt2);
	local num = 0;
	for i=1,c,1 do 
		local new =tonumber(os.date("%H%M%S", b + i ));
		if (new>93000 and new<=113000) or (new>=130000 and new<=150000)  then 
			num=num+1;
		end
	end
    return num
end