require("luahq");       							   --行情模块
local trade = require('trade');						   --交易模块

function OnStart()
	print( '---------'.. os.date("%Y%m%d %X",os.time() ).. '---------'  );                   -->20140618 17:46:41
	local Init_ret, AccountList, current_account, errmsg, nSimu=trade.InitTrade('real');     --股票账户初始化
	if Init_ret and AccountList  then
		print('---------当前账户----------'..current_account)
	else
		print('---------账户初始化失败, 请保持网络连接和资金账户已登录----------')
	--	SendInfoLog("Error", '账户初始化失败, 请保持网络连接和资金账户已登录'	);
		return;
	end

	local accountList={};
	for i,v in ipairs(Init_ret) do
		if v.result then
			table.insert(accountList,v.account);   -- 推送账户信息
		end
	end

	SendToControl(accountList, "accountRet");  -- 推送用户登陆账户信息

end