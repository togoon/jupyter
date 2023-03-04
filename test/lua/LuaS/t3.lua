.\?.lua;D:\Cache\jSoft\Lua\5.1\lua\?.lua;D:\Cache\jSoft\Lua\5.1\lua\?\init.lua;D:\Cache\jSoft\Lua\5.1\?.lua;D:\Cache\jSoft\Lua\5.1\?\init.lua


local p = "E:/dep/code/lua/"  
local m_package_path = package.path  
package.path = string.format("%s;%s?.lua;%s?/init.lua",  m_package_path, p, p) 
.\?.lua;D:\Cache\jSoft\Lua\5.1\lua\?.lua;D:\Cache\jSoft\Lua\5.1\lua\?\init.lua;D:\Cache\jSoft\Lua\5.1\?.lua;D:\Cache\jSoft\Lua\5.1\?\init.lua;E:/dep/code/lua/?.lua;E:/dep/code/lua/?/init.lua

