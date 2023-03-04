local g_Monitor ={};
local g_InfoQuote ={};
local g_OrderResult = {} ;
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
	local StrInfo = [[隐藏策略是一种主动成交型算法交易策略，当市场盘口中
	出现了期望价格的委托单，并且达到预定的买入或卖出数量时，则进行委托；
	否则再继续等待，直到满足条件的机会出现为止。]];
	
	local dat ={};
	dat['Name'] = '期望价较昨收(%)';
	dat['Type'] = 'decimal';
	dat['Key'] = 'ExpectPriceRate';
	dat['Min'] = -10.00;
	dat['Max'] = 10.00;
	dat['Now'] = 1.00;
	dat['Step'] = 0.01;
	table.insert(param,dat)
	local dat ={};
	dat['Name'] = '期望数量';
	dat['Type'] = 'number';
	dat['Key'] = 'ExpectNum';
	dat['Min'] = 100;
	dat['Max'] = 10000000000;
	dat['Now'] = 100;
	dat['Step'] = 100;
	table.insert(param,dat)
	local dat ={};
	dat['Name'] = '价格浮动(%)';
	dat['Type'] = 'decimal';
	dat['Key'] = 'FloatRate';
	dat['Max'] = 1.00;
	dat['Min'] = 0.00;
	dat['Now'] = 0.10;
	dat['Step'] = 0.01;
	table.insert(param,dat)
	return param,StrInfo ;
end
                         
function TimerOrder(param)   				--执行代码
	g_OrderResult = {};
	g_Monitor = param.Monitor;
	g_InfoQuote = param.InfoQuote;
	
	if g_Monitor and  next(g_Monitor) then
		g_Monitor = Hiddencontrol(g_Monitor);
	end	
 	return g_Monitor,g_OrderResult;
end
--~ print =hx_print;
function Hiddencontrol(v)
	if v and next(v) then
		HiddenInfo(v);	
		if v.LeftQty == 0 then
			v['Stop'] = 1;
			return v;
		end			

		if v['Stop'] == 0 and v.LeftQty >0 then
			v = CheckCondition(v,g_InfoQuote);
			return v;
		end 
	end	
	return v;
end

function CheckCondition(param,infoQuote)
	if param.ExpectNum ==nil or param.ExpectNum =='' or param.ExpectNum < 100  then
		param['Stop'] = 1;
		return param;
	end
	
	local stockInfo={};
	local panVolum = 0;
	local Price;
	if infoQuote and next(infoQuote) then
		stockInfo.OfferPx5  			= 	infoQuote['156'];				--申卖价五
		stockInfo.OfferQty5 			= 	infoQuote['157'];				--申卖量五
		stockInfo.OfferPx4  			= 	infoQuote['152'];				--申卖价四
		stockInfo.OfferQty4			 	= 	infoQuote['153'];				--申卖量四
		stockInfo.OfferPx3 			 	= 	infoQuote['34'];				--申卖价三
		stockInfo.OfferQty3 			= 	infoQuote['35'];				--申卖量三
		stockInfo.OfferPx2  			= 	infoQuote['32'];				--申卖价二
		stockInfo.OfferQty2 			= 	infoQuote['33'];				--申卖量二
		stockInfo.OfferPx1  			= 	infoQuote['30'];				--申卖价一
		stockInfo.OfferQty1 			= 	infoQuote['31'];				--申卖量一
		local LastPx					= 	infoQuote['10'];				--最新价
		local PrevClosePx				= 	infoQuote['6'];					--昨日收盘价
		stockInfo.PrevClosePx			= 	PrevClosePx						--昨日收盘价
		local OpenPx					= 	infoQuote['7'];					--今日开盘价
		stockInfo.LastPx				=	LastPx;							--最新价
		
		stockInfo.BidPx5  				= 	infoQuote['154'];				--申买价五
		stockInfo.BidQty5 				= 	infoQuote['155'];				--申买量五
		stockInfo.BidPx4  				= 	infoQuote['150'];				--申买价四
		stockInfo.BidQty4 				= 	infoQuote['151'];				--申买量四
		stockInfo.BidPx3  				= 	infoQuote['28'];				--申买价三
		stockInfo.BidQty3 				= 	infoQuote['29'];				--申买量三
		stockInfo.BidPx2  				= 	infoQuote['26'];				--申买价二
		stockInfo.BidQty2 				= 	infoQuote['27'];				--申买量二
		stockInfo.BidPx1  				= 	infoQuote['24'];				--申买价一
		stockInfo.BidQty1 				= 	infoQuote['25'];				--申买量一
		stockInfo.DailyPriceUpLimit		=	infoQuote['69'];				--涨停价
		stockInfo.DailyPriceDownLimit	=	infoQuote['70'];				--跌停价
		
		Price = stockInfo.PrevClosePx * (tonumber(param.ExpectPriceRate)/100 + 1);
		if param.Side == "Buy" then
			if stockInfo and next(stockInfo) then
				if Price >tonumber(stockInfo.OfferPx4 ) then
					panVolum = stockInfo.OfferQty1+stockInfo.OfferQty2+stockInfo.OfferQty3+stockInfo.OfferQty4+stockInfo.OfferQty5;
				elseif Price <= tonumber(stockInfo.OfferPx4) and Price >tonumber(stockInfo.OfferPx3 ) then
					panVolum = stockInfo.OfferQty1+stockInfo.OfferQty2+stockInfo.OfferQty3+stockInfo.OfferQty4;
				elseif Price <= tonumber(stockInfo.OfferPx3) and Price >tonumber(stockInfo.OfferPx2) then
					panVolum = stockInfo.OfferQty1+stockInfo.OfferQty2+stockInfo.OfferQty3;
				elseif Price <= tonumber(stockInfo.OfferPx2) and Price >tonumber(stockInfo.OfferPx1) then
					panVolum = stockInfo.OfferQty1+stockInfo.OfferQty2;
				elseif Price <= tonumber(stockInfo.OfferPx1) and Price >= stockInfo.LastPx then
					panVolum = stockInfo.OfferQty1;
				else
					panVolum = 0;
				end
			end
			
		elseif param.Side == "Sell" then	
			if stockInfo and next(stockInfo) then
				if Price <tonumber(stockInfo.BidPx4) then
					panVolum = stockInfo.BidQty1+stockInfo.BidQty2+stockInfo.BidQty3+stockInfo.BidQty4+stockInfo.BidQty5;
				elseif Price >= tonumber(stockInfo.BidPx4) and Price <tonumber(stockInfo.BidPx3 ) then
					panVolum = stockInfo.BidQty1+stockInfo.BidQty2+stockInfo.BidQty3+stockInfo.BidQty4;
				elseif Price >= tonumber(stockInfo.BidPx3) and Price <tonumber(stockInfo.BidPx2) then
					panVolum = stockInfo.BidQty1+stockInfo.BidQty2+stockInfo.BidQty3;
				elseif Price >= tonumber(stockInfo.BidPx2) and Price <tonumber(stockInfo.BidPx1) then
					panVolum = stockInfo.BidQty1+stockInfo.BidQty2;
				elseif Price >= tonumber(stockInfo.BidPx1) and Price <= stockInfo.LastPx then
					panVolum = stockInfo.BidQty1;
				else
					panVolum = 0;
				end		
			end
		end
	end
	
	if  panVolum ~= 0 and param.ExpectNum <= panVolum then
		
		local orderprice = DiffPrice(param.Side,Price,param.FloatRate,stockInfo);
 		
		local Status,Ret = HiddenOrder(param,orderprice);	
		if Status  then
			param = Ret ;
			return param;
		end	
	end
	return param;
end

function HiddenOrder(param,orderPrice)		--根据数量和价格下单
	if param and next(param) then 		
		local OrderList = {} ;		
		OrderList.Account = param.Account;
		OrderList.Side = param.Side;
		OrderList.SecurityID = param.SecurityID;
		OrderList.MarketID = param['MarketID'];
		OrderList.OrderQty = param.OrderQty;
		OrderList.OrderPrice = orderPrice;
		OrderList.Key = param.Key;
		
		local Result,Ret = OrderBuySell(OrderList);
		
		if Result then
			param['LastClOrdID'] = Ret.ClOrdID ;
			g_OrderResult = Ret;
			return true,param;
		end
	end	
	return false,{};	
end

function DiffPrice(side,price,rate,stockinfo)			--根据预设的浮动价格和最新价，计算每笔子单的委托价格
	local a = price * rate;
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
		if stockinfo.DailyPriceUpLimit and orderprice > stockinfo.DailyPriceUpLimit then
			orderprice = stockinfo.DailyPriceUpLimit;
		end
	else
		orderprice =  price - floatprice;
		if stockinfo.DailyPriceDownLimit and orderprice < stockinfo.DailyPriceDownLimit then
			orderprice = stockinfo.DailyPriceDownLimit;
		end
	end
	return orderprice;
	
end

function HiddenInfo(param)                 	--界面显示母单信息
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
end
