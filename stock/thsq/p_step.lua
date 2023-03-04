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
function TypeInit()   													--参数规划 ，只在初始化时候执行
	local param = {};
	local StrInfo = [[Step算法实际上是一种对价格进行分层成交的策略，目标
	是在买入（卖出）交易中尽可能地压低（提升）成交均价。简单来讲，Step就
	是在不同的价格区间进行不同成交量比例的配置。]];
	
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
	table.insert(param,dat);
	local dat ={};
	dat['Name'] = '价格分层比(%)';
	dat['Type'] = 'decimal';
	dat['Key'] = 'PriceRate';
	dat['Max'] = 10.00;
	dat['Min'] = 0.00;
	dat['Now'] = 5.00;
	dat['Step']=0.01;
	table.insert(param,dat);
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
	table.insert(param,dat)

	return param,StrInfo ;
end

local g_nowtime;
local g_Ret;
--~   print = hx_print;

function TimerOrder(param)  								 			--执行代码
	
	g_Monitor= param.Monitor;
	g_InfoQuote= param.InfoQuote;

    g_nowtime = param.NowTime;

	g_Ret = nil;
	if g_Monitor and  next(g_Monitor) then
		g_Monitor = Stepcontrol(g_Monitor);
	end
	return g_Monitor,g_Ret;
end

function Stepcontrol(v)
	if v and next(v) then
		
		if v.LeftQty == 0 or (tonumber(v.EndTime) ==nil or tonumber(v.BeginTime)==nil) or (v.Allow == '0' and tonumber(os.date("%H%M%S",g_nowtime))>tonumber(v.EndTime))
			or tonumber(v.EndTime) <= tonumber(v.BeginTime) or (tonumber(os.date("%H%M%S",g_nowtime))>=145950)  then
			
			v['Stop'] = 1;
			return v;
		end

		v = Stepinfo(v);
		local Time = g_nowtime;
		if v['Stop']==0 and not(v['STEP'] and next(v['STEP'])) then
			v = Stepinit(v);
		else
			--检查是否已经结束
			local Flag = checkstop(v['STEP']);			
			if Flag == 0 then
				if v.Allow == '0' then
					v['Stop'] = 1;
					return v;
				else                                   
				--允许对未完成的交易量继续委托
					if v.BeginTime and v.EndTime then
						v.BeginTime,v.EndTime = UpdateTime(v.BeginTime,v.EndTime,v.Second,v.MarketID);
						if v.BeginTime and v.EndTime then
							v = Stepinit(v);
						else
							return v;
						end
					else
						return v;
					end														
				end
			end
		end
		--处理算法开始时间在上午，结束时间在下午这一特殊情况的下单问题
		if v and v.TimeFlag and v.EntryTime and tonumber(os.date("%H%M%S",v.EntryTime+v.Second))>113000 then
			v.EntryTime =  v.EntryTime + 1.5*3600;
			v.TimeFlag = false;			
		end
		
		if v.LeftQty >0 and v['Stop']==0 and tonumber(os.date("%H%M%S",g_nowtime))>=tonumber(v.BeginTime) then
			if v.LastClOrdID==nil or  ((Time - v.EntryTime)>=v.Second ) then
				if v.StockPosition  and  v.StockPosition ~='' then
					local price =  g_InfoQuote[tostring(v.StockPosition)];
					if price==nil or price==0 or price=='' then
						return v;
					end
					local Status,Ret = Steporder(v,price);
					
					if Status  then
						v = Ret;
						return v;
					end					
				end	
			end
		end			
	end
	return v;
end

function Stepinfo(param)                                       			--界面显示母单信息
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

function UpdateTime(begintime,endtime,second,market)	 				--更新下单结束后的初始时间，以便对未完成的数量继续委托
	if tonumber(endtime) >= 150000 then
		return;
	end
	
	if #begintime == 5 then
		begintime = '0'..begintime
	end
	if #endtime == 5 then
		endtime = '0'..endtime
	end
	
	
	local HH = string.sub(begintime,1,2)  
    local MM = string.sub(begintime,3,4)  
	local SS = string.sub(begintime,5,6)  
	local HH2 = string.sub(endtime,1,2)  
    local MM2 = string.sub(endtime,3,4)  
	local SS2 = string.sub(endtime,5,6)  
    local dt1 = os.time{year='2015', month='01', day='01', hour=HH,min=MM,sec=SS}; 
	local dt2 = os.time{year='2015', month='01', day='01', hour=HH2,min=MM2,sec=SS2};

	--计算开始时间与结束时间的差值
	local c= (dt2- dt1);
	if tonumber(begintime)<113000 and tonumber(endtime)>130000 then
		c = c- 1.5*3600;
	end
	
	--更新后的开始时间与结束时间的时间差，与更新前相同（不在交易时间内除外）
	local NewBegintime = g_nowtime + second;
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

function inittime(begintime,endtime,market)                       				--处理开始时间与结束时间参数
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
	
	local endFlag;
	if string.sub(market,1,2) == 'SH' then
		endFlag = 150000;
	else
		if tonumber(endtime) >= 145700 then
			endtime = '145700';
		end
		endFlag = 145700;
	end
	
	if tonumber(endtime) <= tonumber(NowTime) then
		return;
	elseif tonumber(endtime) >= endFlag then
		endtime = tostring(endFlag);	
	elseif tonumber(endtime) < 130000 and tonumber(endtime)>113000 then
		endtime = '113000';
	end
	
	if string.len(endtime) == 5 then
		endtime = '0'..endtime;
	end
	
	if tonumber(begintime)>=tonumber(endtime) then
		return;
	end

--~ 	
--~ 	if tonumber(endtime) <= math.min(endFlag,tonumber(NowTime)) then
--~ 		endtime = tostring(math.min(endFlag,tonumber(NowTime)));
--~ 		if tonumber(endtime) < 130000 and tonumber(endtime)>113000 then
--~ 			endtime = '113000';
--~ 		end
--~ 		if string.len(endtime) == 5 then
--~ 			endtime = '0'..endtime;
--~ 		end		
--~ 	end
--~ 	
	
	return begintime,endtime;

end

function checkstop(param)                                      			--检查是否已经结束
	local flag = 0;
	if param and next(param) then
		for i=1,#param do
			if param[i][2] ~= 0 then
				flag = 1;
				break
			end
		end
	end
	return flag;
end

function Steporder(v,price)												--Step策略下单
	if v and v['STEP'] and next(v['STEP']) then
		
		--检查当前价格所在的价格区间，计算委托量占比
		local volrate = checkprice(price,v.PriceRate,v.Side);
		if volrate == 0 then
			return;
		end
		
		for i=1,#(v['STEP']),1 do
			local val = v['STEP'][i] ;
			local Result =false ;
			local Ret;
			local qty = 0;
			if val[2]>0 then
				--根据价格区间计算的委托量占比，委托下单
				qty= volrate * val[2]/val[3];
				
				if qty<100 then
					if qty > 0 then
						qty = 100;
					else
						break
					end
				else
					qty = math.floor(qty/100)*100;
				end
				if qty > v.LeftQty then
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

function checkprice(price,rate,side)											--检查价格所在的区间，确定委托量占比
	local Close = g_InfoQuote['6'];
	local floatprice = Close * tonumber(rate)/100;
 	if side == "Buy" then
		if price < (Close-floatprice) then
			return 0.3;
		elseif price >= (Close-floatprice) and price <= (Close+floatprice) then
			return 0.1;
		else
			return 0;
		end
	else
		if price < (Close-floatprice) then
			return 0;
		elseif price >= (Close-floatprice) and price <= (Close+floatprice) then
			return 0.1;
		else
			return 0.3;
		end
	end
	
end

function initdate()														--初始化参考周期  默认取截止到当前交易日前的30天
	local enddate= os.date("%Y%m%d",g_nowtime - 24*3600)..'15'..'00';
	local time1 = os.time{year=string.sub(enddate,1,4), month=string.sub(enddate,5,6), day=string.sub(enddate,7,8), hour='09',min='30',sec='00'}
	local time2 = time1 - 24*30*3600;
	local startdate = os.date("%Y%m%d%H%M",time2);
	
	return startdate,enddate;
	
end

function Stepinit(v)													--STEP初始化，预测各时间段内的成交量分布
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
	end
	
	v.BeginTime,v.EndTime = inittime(v.BeginTime,v.EndTime,v.MarketID);

	if not(v.BeginTime and v.EndTime) then
		v['Stop'] = 1;
		return v;
	elseif tonumber(v.BeginTime)<113000 and tonumber(v.EndTime)>=130000 then
		v.TimeFlag = true;	
	end
	
	local begintt = string.sub(v.BeginTime,1,4);
	local endtt = string.sub(v.EndTime,1,4);
	
	if detail and next(detail) then
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
			elseif tonumber(begintt)>tonumber(lasttime) and tonumber(begintt)<=tonumber(detail[i][1]) then
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
			elseif  tonumber(begintt)>tonumber(detail[i][1]) or tonumber(endtt)<=tonumber(lasttime) then	
				detail[i][2] = 0;
				detail[i][3] = 0;
			end
			detail[i][3] = math.floor(detail[i][3]*60/v.Second);
		end
		
		for i=1,#detail do
			detail[i][2] = detail[i][2]/(#detail);
		end
	end
	
	v['STEP'] = detail ;	

	return v ;
end

function initkline(param)												--处理0930与1300极端状况的K线分布
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

function OrderTimeDev(Time,Time2)										--时间计算函数
    if #Time == 5 then
		Time = '0'..Time;
	end
	if #Time2 == 5 then
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