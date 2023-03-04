-- table.foreach( _G, print )


--table 继承

-- print(package.path)  --> lua文件的搜索路径
-- print(package.cpath) --> lua c文件的搜索路径






package.path = string.format("%s;%s?.lua;%s/LuaS.lua",  package.path  , "D:/Cache/LuaTest/Usu/", "D:/Cache/LuaTest/Usu/")
print(package.path) -->lua文件的搜索路径
 local luas=require("LuaS");




