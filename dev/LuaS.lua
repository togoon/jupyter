


---------------------------全局环境--------------------------------

--[[

print("\n","-----------------_G---------------------------");
for k,v in pairs(_G) do print(k,v); end

print("\n","-----------------_G.table---------------------------");
for k,v in pairs(_G.table) do print(k,v); end

print("\n","-----------------_G.io---------------------------");
for k,v in pairs(_G.io) do print(k,v); end

print("\n","-----------------_G.coroutine---------------------------");
for k,v in pairs(_G.coroutine) do print(k,v); end

print("\n","-----------------_G.string---------------------------");
for k,v in pairs(_G.string) do print(k,v); end


print("\n","-----------------_G.package---------------------------");
for k,v in pairs(_G.package) do print(k,v); end

print("\n","-----------------_G.os---------------------------");
for k,v in pairs(_G.os) do print(k,v); end

print("\n","-----------------_G.math---------------------------");
for k,v in pairs(_G.math) do print(k,v); end

print("\n","-----------------_G.debug---------------------------");
for k,v in pairs(_G.debug) do print(k,v); end

--]]

----------------------------------- 分支 if/elseif/ elseif/else/end /elseif/end----------------------------

--[[
do           --  clunk
print "分支 IF-ElseIF-ElseIF-End"

local age=40      -- 局部变量
local sex="Male"

--age = io.read()

if age == 40 and sex =="Male" then
    print("男人四十一枝花")
elseif age > 60 and sex ~="Female" then
    print("old man without country!")
elseif age < 20 then
    io.write("too young, too naive!\n")
else
    local age = io.read()
    print("Your age is "..age)
end

end

--]]


----------------------------------------协程 多线程---create----status-yield-resume------------


--[[

local co = coroutine.create(function () print("hi") end) --创建协同程序成功时，为挂起态(suspended)，此时协同程序未运行
print(co)     --> thread: 0x8071d98
print(coroutine.status(co))     --> suspended  --协同3状态：挂起(suspended)、运行(running)、终止(dead)
coroutine.resume(co)             --> hi         --resume运行(running)
print(coroutine.status(co))     --> dead       --协同程序打印出"hi"后，任务完成，便进入终止态(dead)

co = coroutine.create(function () for i=1,10 do  print("----co----  ", i) ; coroutine.yield()  end end) --yield处被挂起(suspended)
coroutine.resume(co)             --> co   1
print(coroutine.status(co))     --> suspended
coroutine.resume(co)             --> co   2
coroutine.resume(co)            --> co   3
coroutine.resume(co)            --> co   10
coroutine.resume(co)           -- prints nothing
print(coroutine.resume(co))       --> false   cannot resume dead coroutine --最后一次调用时，协同体已结束，因此协同程序处于终止态。如激活它，resume将返回false和错误信息

co = coroutine.create(function (a,b,c) print("co ", a,b,c) end)
coroutine.resume(co, 1, 2, 3)      --> co  1  2  3 --resume把参数传递给协同的主程序

co = coroutine.create(function (a,b)  coroutine.yield(a + b, a - b) end)  --数据由yield传给resume。
print(coroutine.resume(co, 20, 10))    --> true  30  10  --true表明调用成功，true之后的部分，即是yield的参数

co = coroutine.create (function ()  print("++++co+++++  ", coroutine.yield() )  end)

coroutine.resume(co)
coroutine.resume(co, 4, 5)      --> co  4  5 --resume的参数，会被传递给yield

co = coroutine.create(function ()    return 6, 7  end)
print(coroutine.resume(co))     --> true  6  7  协同代码结束时的返回值，也会传给resume

--assert(0, "invalid input") ;    --断言 false nil

--]]


----------------------------------------时间与日期 Time/Date--------------------

--[[
do           --  clunk

print(os.time{year=1971, month=1, day=1, hour=0})                   -->31507200  构造时间
print(os.time{year=1971, month=1, day=1, hour=0, sec=1})            -->31507201  构造时间
print(os.time{year=1971, month=1, day=1, hour=0, minute=1, sec=1})  -->31510801  构造时间
print(os.time{year=1970, month=1, day=1})                           -->14400  起始时间 1970.01.01

print(os.time() );                        -->1403084206  空参数:默认本机系统时间(累计秒数 始1970.01.01)
print(os.date("%c",os.time() ) );        -->06/18/14 17:36:46  date日期时间格式输出 time秒数 反函数
print(os.date("%Y%m%d %X",os.time() ) ); -->20140618 17:46:41
--  %a-weekday:Wed  %A-weekday:Wednesday  %b-month:Sep  %B-month:September  %c-date&time:09/16/9823:48:10
--  %d-day:01-31  %H-hour24:00-23  %I-hour12:01-12  %M-minute:00-59  %m-month:00-12  %p-am\pm:pm  %S-second:00-61
--  %w-weekday:0-6  %x-date:09/16/98  %X-time:23:48:10  %Y-year4:1998  %y-year2:00-99  %%-%

for k,v in pairs(os.date("*t",os.time())) do print(k,v); end
 --> 一维表格  [hour]=17,[min]=36,[wday]=4,[day]=18,[month]=6,[year]=2014,[sec]=46,[yday]=169,[isdst]=FALSE

end
--]]


----------------------------------------时间与日期 分支 switch---------------------------------
--[[
switch={}
switch[1]=function() return '一月' end
switch[2]=function() return '二月' end
switch[3]=function() return '三月' end
switch[4]=function() return '四月' end
switch[5]=function() return '五月' end
switch[6]=function() return '六月' end
switch[7]=function() return '七月' end
switch[8]=function() return '八月' end
switch[9]=function() return '九月' end
switch[10]=function() return '十月' end
switch[11]=function() return '十一月' end
switch[12]=function() return '十二月' end

print(switch[1]())  -->一月
--]]

--[[
local switch = {
    [1] = function()    -- for case 1
        print "Case 1."
    end,
    [2] = function()    -- for case 2
        print "Case 2."
    end,
    [3] = function()    -- for case 3
        print "Case 3."
    end
}

local a = 3
local f = switch[a]
if(f) then
    f()
else                -- for case default
    print "Case default."
end
--]]


--[[
local curDaySec=os.time();                                 --分隔循环 curDaySec=lmDaySec-24*3600;
local curDay=os.date("*t",curDaySec);                      --当前日期Table
local lmDaySec=curDaySec-27*24*3600;                       --27天前,跨月不能查询成交记录,须分割查询
local lmDay=os.date("*t",lmDaySec);
local endTime  =os.date("%Y%m%d", os.time{ year=curDay.year, month=curDay.month, day=curDay.day } );
local startTime=os.date("%Y%m%d", os.time{ year=lmDay.year,  month=lmDay.month,  day=lmDay.day  } );

print(os.date("%Y%m%d %X",os.time() ) ); -->20140618 17:46:41
print(os.time{year=1971, month=1, day=1, hour=0, minute=1, sec=1})  -->31510801  构造时间


--]]


--[[
local date={};                          --日期时间变量集合
date.curDay=os.date("*t",os.time());    --当前日期时间
date.curMonthFirstDayS  =os.time{year=date.curDay.year, month=date.curDay.month, day=1,hour=0};    --当月1号秒数
date.nextMonthFirstDayS=os.time{year=date.curDay.year, month=date.curDay.month+1, day=1,hour=0};   --次月1号秒数
date.curMonthFirstDay=os.date("*t",date.curMonthFirstDayS);    --当月1号日期表  --wday西历星期天/七为1, 周六为7 中历-1循环
date.nextMonthFirstDay=os.date("*t",date.nextMonthFirstDayS);  --次月1号日期表

local wdays={  [2]=function() return 3 end; [3]=function() return 1 end; [4]=function() return 1 end;
				[5]=function() return 1 end; [6]=function() return 1 end; [7]=function() return 1 end;
				[1]=function() return 2 end; }

date.curMonthLastTradeDay=os.date("*t", date.nextMonthFirstDayS-3600*24*wdays[date.nextMonthFirstDay.wday]()  ); --本月最后一个自然交易日

print(os.date("%Y%m%d",os.time()));

--print(os.date("%Y%m%d", os.time{ year=os.date("*t",os.time()).year, month=os.date("*t",os.time()).month-1, day=os.date("*t",os.time()).day+1 }    ));

local curDay=os.date("*t",os.time());
print(os.date("%Y%m%d", os.time()-29*24*3600   ));
local tDay=os.time{year=2016, month=3, day=31,hour=0};
print(os.date("%Y%m%d", tDay   ));
print(os.date("%Y%m%d", tDay-27*24*3600   ));

for k,v in pairs(date.curMonthLastTradeDay) do
--	print(k,'\t', v);
end

--]]

--[[
local date={};                          --日期时间变量集合
date.curDay=os.date("*t",os.time());    --当前日期时间

date.curMonthFirstDayS  =os.time{year=date.curDay.year, month=date.curDay.month, day=1,hour=0};    --当月1号秒数
date.nextMonthFirstDayS=os.time{year=date.curDay.year, month=date.curDay.month+1, day=1,hour=0};   --次月1号秒数

date.curMonthFirstDay=os.date("*t",date.curMonthFirstDayS);    --当月1号日期表  --wday西历星期天/七为1, 周六为7 中历-1循环
date.nextMonthFirstDay=os.date("*t",date.nextMonthFirstDayS);  --次月1号日期表

local wdays={  [2]=function() return 3 end; [3]=function() return 1 end; [4]=function() return 1 end;
				[5]=function() return 1 end; [6]=function() return 1 end; [7]=function() return 1 end;
				[1]=function() return 2 end; }

date.curMonthLastTradeDay=os.date("*t", date.nextMonthFirstDayS-3600*24*wdays[date.nextMonthFirstDay.wday]()  ); --本月最后一个自然交易日

local curDay=os.date("*t",os.time());    --当前日期时间
local nmFirstDayS=os.time{year=curDay.year, month=curDay.month+1, day=1,hour=0};   --次月1号秒数
local cmLastTradeDay=os.date("*t", nmFirstDayS-3600*24*wdays[os.date("*t",nmFirstDayS).wday]()  ); --本月最后一个自然交易日(节假日为次月开盘平仓)
local cmLastTradeTimeS=os.time{year=curDay.year, month=curDay.month, day=cmLastTradeDay.day,hour=14, minute=40, sec=0}; --本月底平仓时间 14:40

--print(os.time())
--print(cmLastTradeTimeS)

local cmltd=table.concat(cmLastTradeDay,'');
print(cmltd)

for k,v in pairs(cmLastTradeDay) do
--print(k,'\t', v);
end

print("20140801"-"20140731");

--]]




--------------------------------加载 dofile/require/loadstring------------------------------

--dofile()：读入文件编译并执行,dofile每次都要编译, 本质上位辅助函数，真正实现其功能的是loadfile()
--loadfile()：编译代码成中间码，返回编译后chunk作为函数，不执行代码，不抛出错误信息，返回错误码和nil；编译一次，但可多次运行
--loadstring()函数：读入的不是chunk，而是从一个串中读入； 运行错误的话，也不会抛出错误，而是返回错误码和nil；
--loadstring和loadfile都不会产生边界效应，他们仅仅是编译，而不是定义chunk成为自己内部的一个匿名函数；
--require 函数加载一个模块时，在表package.loaded中查找是否存在，有的话就返回该值；
--loadfile会将文件当作函数来加载，require会将模块名作为参数传给该函数。若有返回值则将返回值放入表package.loaded中。若没有则返回表package.loaded中的值。
--module 函数：

--[[

local p = "D:/Cache/LuaTest/Usu/"
local m_package_path = package.path
package.path = string.format("%s;%s?.lua;%s/LuaS.lua",  m_package_path, p, p)

--print(package.path) -->lua文件的搜索路径


module "mymodule"
local modname = "mymodule"  --定义模块名
local M = {}                  --定义用于返回的模块表
_G[modname] = M               --将模块表加入到全局变量中
package.loaded[modname] = M  --将模块表加入到package.loaded中，防止多次加载
setfenv(1,M)                  --将模块表设置为函数的环境表，这使得模块中所有操作是以在模块表中，定义函数就直接定义在模块表中

--]]


-------------------------加载 文件 模块 字符串 require dofie loadfile  loadstring load module ---------------------------

--[[
do
--mod.lua 被加载模块   返回M表


local M = {}
local function sayMyName()
  print('Hrunkner.Mod.Local')
end

function M.sayHello()
  print('Why hello there, Public')
  sayMyName()
end


return M

end
--]]


--[[
--加载函数 mod.lua (同目录)

require('mod').sayHello()  -- require Only Once 运行文件mod.lua  --return M{}
dofile('mod.lua').sayHello()     -- dofile  Once/Again 运行(多次)文件mod.lua (含文件名) --return M{}
loadfile('mod.lua') ().sayHello()  --load & Not Run
loadstring('print(343)') ()  --返回一个函数

--]]


--[[
do
-- BeRequired.lua
print(" require 用法 实例 ")

--私有函数
local function myPrivateFunction()
  print("this is a private function!")
end
--共有接口
function Vprint()
  myPrivateFunction()
  print("this is a public function!")
  print("This is a required package!")
  print("\n")

end
Vprint()
--标识类名 创建一个类
complex = {Vprint = Vprint}

end
--]]

--[[
do
-- main.lua
print(" require 用法 实例 ")

package.path = package.path .. ";?.lua"     --模板式的路径 ?的地方由require函数中获得
print(package.path)

local requiredpackage = require("BeRequired")  --这行是必须得要的　

print(requiredpackage,'\n')

function Vprint()
print("main print!",'\n')
end
Vprint()  -- main print

local requirecomplex = {}  --声明一个对象
requirecomplex = complex  --创建该对象
requirecomplex.Vprint()  --require中对象

end
--]]




---------------------------------------------------字符串 string--------------------------------------------

--[=[


--字符串格式化 format
-- 十进制'd'；十六进制'x'；八进制'o'；浮点数'f'；字符串's'
print( string.format("%%c:%c",83) )      -->S%c:数字转ASCII字符
print( string.format("%+d",17.0) )       -->+17%d:数字转符号整数
print( string.format("%05d",17) )        -->00017
print( string.format("%o",17) )          -->21%o:数字转8进制
print( string.format("%u",3.14) )        -->3%u:数字转无符号整数
print( string.format("%x",13) )          -->d%x,%X(大写) 数字转16进制
print( string.format("%e",1000) )        -->1.000000e+03%e,%E(大写) 数字转科学记录法
print( string.format("%6.3f",13) )       -->13.000%f,数字转浮点
print( string.format("%q","One\nTwo") )  -->"One \n Two"%g,%G数字转短格式
print( string.format("%s","monkey") )    -->monkey%s, 字符串格式
print( string.format("%10s","monkey") )  -->monkey
print( string.format("%5.3s","monkey") ) -->mon

print( string.byte("[in brackets]", 2) ) -->105  byte(string [,pos]) 第pos个字符的整数表示形式(ASCII码).如i为105.同样pos为负是倒着数；
print( string.char(97,105) ) -->ai  char(i1,i2...):i1,i2为整型,将i1,i2..等转化为对应的字符然后连接成字符串,并返回.如i1=97则返回a；
print( string.len("Hello World") )    -->11           字符串s的长度；
print( string.rep("a", 2^10) )        -->1Kb 字符串   重复n次字符串s的串
print( string.lower("Hello World") )  -->hello world  小写
print( string.upper("Hello World") )  -->HELLO WORLD  大写
print( string.reverse("Hello World")) -->dlroW olleH  倒序
--table.sort(a, function (a, b) return string.lower(a) < string.lower(b) end) --数组排序: 大小写无关
print( string.sub("[in brackets]", 2, -2) ) --> in brackets sub(s,i,[j]) 截取s的从i到j串, -i表示倒数第几位, [j]默认-1

print( string.gsub("Lua is cute", "cute", "great") )   --> Lua is great
--string.gsub("原字符串", "要找的字符串", "希望替换成的字符串", [n替换次数])不写替换次数的情况下会全部替换
--基于模式匹配: 返回两个值 -- 替换后的字符串和替换执行次数
print( string.gsub("all lii", "l", "x") )              --> axx xii
print( string.gsub("Lua is great", "perl", "tcl") )    --> Lua is great
--print( string.dump(functoin) ) --返回给定函数的二进制表示的字符串，之后在其上应用loadstring返回函数的拷贝。function必须是不带upvalue的Lua函数；
--function test()  print("just a test") end ; local sd = string.dump(test) ; local ls = loadstring(sd) ; ls() ;

print( string.find("hello world", "hello") )                             --> 1    5
print( string.sub("hello world", string.find("hello world", "hello"))) --> hello 着重在字符串里找完全一样的子字符串
print(string.find("hello world", "lll") )      --> nil  plain:true 将关闭样式简单匹配模式,变为无格式匹配
--string.find("原字符串", "要找的字符串", [n起始位置(支持负索引) [,plain] ]) 返回两个值: 起始索引和结尾索引

print( string.match("My birthday is 8/4/1991!", "%d+/%d+/%d+") )  -->8/4/1991  基于模式匹配:在字符串date中找出特定格式的信息
--string.math("原字符串", "要找的字符串")，也是在字符串中搜索，但是注重的是模式匹配的那部分子字符串


--模式匹配
-- .任意字符    %a字母    %c控制字符    %d数字    %l小写字母    %p标点字符    %s空白符    %u大写字母    %w字母和数字    %x十六进制数字    %z代表0的字符
-- +1次或多次 *0次或多次 -0次或多次(最短匹配) ?0次或1次   锚点^起始处, 锚点$结束处. 例如^MYADDON:.+表示以MYADDON:开头的字符串
-- 特殊字符 ( ) . % + - * ? [ ^ $   '%' 转义字符  '%.' 匹配点  '%%' 匹配字符 '%'

--string.gmatch(str, pattern): 返回迭代器函数
--[[ 显示每个单词
s = "hello world from Lua"
local tbWords = {}
for w in string.gmatch(s, "%a+") do tbWords[#tbWords + 1] = w  end
for _, val in pairs(tbWords) do  print(val) end
--]]

--string.gfind(s,pat):在字符串s中查找匹配正则pat的子字符串
--[[  收集一个字符串中所有的单词，然后插入到一个表中
local words = {}
local s="hello hi, again!";
for w in string.gfind(s, "%a") do
    table.insert(words, w)
end
--]]


----------------string split函数 ------------------------------------
--[[
function Split(szFullString, szSeparator)
local nFindStartIndex = 1
local nSplitIndex = 1
local nSplitArray = {}
while true do
   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
   if not nFindLastIndex then
    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
    break
   end
   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
   nFindStartIndex = nFindLastIndex + string.len(szSeparator)
   nSplitIndex = nSplitIndex + 1
end
return nSplitArray
end
--测试
local str = "1234,389,abc";
local list = Split(str, ",");
for i = 1, #list
do
	str = string.format("index %d: value = %s", i, list[i]);
	print(str);
end


string.split = function(s, p)
    local rt= {}
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
    return rt
end


--使用例子一
local str = 'abc,123,hello,ok'
local list = string.split(str, ',')
for _, s in ipairs(list） do
    print(s)
end

--结果：
abc
123
hello
ok


--使用例子二
local str = 'abc \n123 \t hello ok'
local list = string.split(str, '%s')
for _, s in ipairs(list） do
    print(s)
end

--结果：
--abc
--123
--hello
--ok



--]]



--]=]




-------------------------------------------文件读存/输出-------------------------------------

--[[
do
-- 似乎不支持大文件(不能超过9k?)
function FileSaveLoad()
      local file = io.open("c:\\in.lua", "r");
      assert(file);
      local data = file:read("*a"); -- 读取所有内容
      file:close();
      file = io.open("c:\\out.lua", "w");
      assert(file);
      file:write(data);
      file:close();
end
FileSaveLoad();

-------


tb01= {
    [1] = "bbbbbb";
    [2] = "ffffff";
    [3] = "cccccc";
    [4] = "xxxxxx";
    [5] = "eeeeee";
};


local f = assert(io.open("d:\\test20140721.txt", "a+"));

f:write(os.date("%Y%m%d %X",os.time()).."\n")

for v,k in pairs(tb01) do

--	print(v,'  \t',k)
f:write(v..' '..k..'\n')

end

f:close()


local file = assert(io.open("d:\\test20140721.txt","r"));
for line in file:lines() do
 print(line)
end
file:close()


--------


local filePath = "D:\\1.txt"
function readFile(file)
    assert(file,"file open failed")
    local fileTab = {}
    local line = file:read()
    while line do
        print("get line",line)
        table.insert(fileTab,line)
        line = file:read()
    end
    return fileTab
end

function writeFile(file,fileTab)
    assert(file,"file open failed")
    for i,line in ipairs(fileTab) do
        print("write ",line)
        file:write(line)
        file:write("\n")
    end
end

function main()
    print("start")
    local fileRead = io.open(filePath)
    if fileRead then
        local tab = readFile(fileRead)
        fileRead:close()
        table.remove(tab,1)
        local fileWrite = io.open(filePath,"w")
        if fileWrite then
            writeFile(fileWrite,tab)
            fileWrite:close()
        end
    end
end

main()

--------

require('luacom')
--新建Excel文件
function _ExcelBookNew(Visible)
local oExcel = luacom.CreateObject("Excel.Application")
if oExcel == nil then error("Object is not create") end
--处理是否可见
if tonumber(Visible) == nil then error("Visible is not a number") end
if Visible == nil then Visible = 1 end
if Visible > 1 then Visible = 1 end
if Visible < 0 then Visible = 0 end

oExcel.Visible = Visible
oExcel.WorkBooks:Add()
oExcel.ActiveWorkbook.Sheets(1):Select()
return oExcel
end
--打开已有的Excel文件
function _ExcelBookOpen(FilePath,Visible,ReadOnly)
local oExcel = luacom.CreateObject("Excel.Application")
if oExcel == nil then error("Object is not create") end
--查看文件是否存在
local t=io.open(FilePath,"r")
if t == nil then
--文件不存在时的处理
oExcel.Application:quit()
oExcel=nil
error("File is not exists")
else
t:close()
end
--处理是否可见ReadOnly
if Visible == nil then Visible = 1 end
if tonumber(Visible) == nil then error("Visible is not a number") end
if Visible > 1 then Visible = 1 end
if Visible < 0 then Visible = 0 end
--处理是否只读
if ReadOnly == nil then ReadOnly = 0 end
if tonumber(ReadOnly) == nil then error("ReadOnly is not a number") end
if ReadOnly > 1 then ReadOnly = 1 end
if ReadOnly < 0 then ReadOnly = 0 end
oExcel.Visible = Visible
--打开指定文件
oExcel.WorkBooks:Open(FilePath,nil,ReadOnly)
oExcel.ActiveWorkbook.Sheets(1):Select()
return oExcel
end
--写入Cells数据
function _ExcelWriteCell(oExcel,Value,Row,Column)
--验证参数
if oExcel == nil then error("oExcel is not a object!") end
if tonumber(Row) == nil or Row < 1 then error("Row is not a valid number!") end
if tonumber(Column) == nil or Column < 1 then error("Column is not a valid number!") end
--对指定Cell位置赋值
oExcel.Activesheet.Cells(Row, Column).Value2 = Value
return 1
end
--读取Cells数据
function _ExcelReadCell(oExcel,Row,Column)
--验证参数
if oExcel == nil then error("oExcel is not a object!") end
if tonumber(Row) == nil or Row < 1 then error("Row is not a valid number!") end
if tonumber(Column) == nil or Column < 1 then error("returnColumn is not a valid number!") end
--返回指定Cell位置值
return oExcel.Activesheet.Cells(Row, Column).Value2
end
--保存Excel文件
function _ExcelBookSave(oExcel, Alerts)
--验证参数
if oExcel == nil then error("oExcel is not a object!") end
--处理是否提示
if Alerts == nil then Alerts = 0 end
if tonumber(Alerts) == nil then error("Alerts is not a number") end
if Alerts > 1 then Alerts = 1 end
if Alerts < 0 then Alerts = 0 end
oExcel.Application.DisplayAlerts = Alerts
oExcel.Application.ScreenUpdating = Alerts
--进行保存
oExcel.ActiveWorkBook:Save()
if not Alerts then
oExcel.Application.DisplayAlerts = 1
oExcel.Application.ScreenUpdating = 1
end
return 1
end
--另存Excel文件
function _ExcelBookSaveAs(oExcel,FilePath,Type,Alerts,OverWrite)
--验证参数
if oExcel == nil then error("oExcel is not a object!") end
--处理保存文件类型
if Type == nil then Type = "xls" end
if Type == "xls" or Type == "csv" or Type == "txt" or Type == "template" or Type == "html" then
if Type == "xls" then Type = -4143 end -- xlWorkbookNormal
if Type == "csv" then Type = 6 end -- xlCSV
if Type == "txt" then Type = -4158 end -- xlCurrentPlatformText
if Type == "template" then Type = 17 end -- xlTemplate
if Type == "html" then Type = 44 end -- xlHtml
else
error("Type is not a valid type")
end
--处理是否提示
if Alerts == nil then Alerts = 0 end
if tonumber(Alerts) == nil then error("Alerts is not a number") end
if Alerts > 1 then Alerts = 1 end
if Alerts < 0 then Alerts = 0 end
oExcel.Application.DisplayAlerts = Alerts
oExcel.Application.ScreenUpdating = Alerts
--处理文件是否OverWrite
if OverWrite == nil then OverWrite = 0 end
--查看文件是否存在
local t=io.open(FilePath,"r")
--如果文件存在且OverWrite参数为0，返回错误
if not t == nil then
if not OverWrite then
t:close()
error("Can't overwrite the file!")
end
t:close()
os.remove(FilePath)
end
--保存文件
if FilePath == nil then error("FilePath is not valid !") end
--使用ActiveWorkBook时，在已经打开文件时，无法另存，所以使用WorkBookS(1)进行处理
oExcel.WorkBookS(1):SaveAs(FilePath,Type)
--继续处理Alerts参数，以便继续使用
if not Alerts then
oExcel.Application.DisplayAlerts = 1
oExcel.Application.ScreenUpdating = 1
end
return 1
end
--关闭Excel文件
function _ExcelBookClose(oExcel,Save,Alerts)
--验证参数
if oExcel == nil then error("oExcel is not a object!") end
--处理是否保存
if Save == nil then Save = 1 end
if tonumber(Save) == nil then error("Save is not a number") end
if Save > 1 then Save = 1 end
if Save < 0 then Save = 0 end
--处理是否提示
if Alerts == nil then Alerts = 0 end
if tonumber(Alerts) == nil then error("Alerts is not a number") end
if Alerts > 1 then Alerts = 1 end
if Alerts < 0 then Alerts = 0 end

if Save == 1 then oExcel.ActiveWorkBook:save() end
oExcel.Application.DisplayAlerts = Alerts
oExcel.Application.ScreenUpdating = Alerts
oExcel.Application:Quit()
return 1
end
--列出所有Sheet
function _ExcelSheetList(oExcel)
--验证参数
if oExcel == nil then error("oExcel is not a object!") end
local temp = oExcel.ActiveWorkbook.Sheets.Count
local tab = {}
tab[0] = temp
for i = 1,temp do
tab[i] = oExcel.ActiveWorkbook.Sheets(i).Name
end
--返回一个table，其中tab[0]为个数
return tab
end
--激活指定的sheet
function _ExcelSheetActivate(oExcel, vSheet)
local tab = {}
local found = 0
--验证参数
if oExcel == nil then error("oExcel is not a object!") end
--设置默认sheet为1
if vSheet == nil then vSheet = 1 end
--如果提供参数为数字
if tonumber(vSheet) ~= nil then
if oExcel.ActiveWorkbook.Sheets.Count < tonumber(vSheet) then error("The sheet value is to biger!") end
--如果提供参数为字符
else
tab = _ExcelSheetList(oExcel)
for i = 1 , tab[0] do
if tab[i] == vSheet then found = 1 end
end
if found ~= 1 then error("Can't find the sheet") end
end
oExcel.ActiveWorkbook.Sheets(vSheet):Select ()
return 1
end


--参数基本做到了可以省略
require('Unicode')
b=assert(_ExcelBookOpen("c://d.xls"))
assert(_ExcelSheetActivate(b))
assert(_ExcelWriteCell(b,Unicode.a2u8("哈哈"),1,1))
assert(_ExcelBookSave(b,1))
assert(_ExcelBookClose(b))

b=assert(_ExcelBookNew(1))
tab=assert(_ExcelSheetList(b))
for i,v in pairs(tab) do
print(i,v)
end
assert(_ExcelSheetActivate(b,"Sheet2"))
--b=assert(_ExcelBookOpen("c://d.xls",1,0))
assert(_ExcelWriteCell(b,"haha",1,1))
assert(_ExcelBookSaveAs(b,"c://a","txt",0,0))
print(_ExcelReadCell(b,1,1))
assert(_ExcelBookClose(b))


---------


-------------------------------非循环表格处理----------------------------------------------


HERO = 1;
MONSTER = 2;
BUILDING = 3;
SUMUNIT = 4;
cha = {};
cha[1] =
{
      basic =
      {
      Name = "农民",    --NPC名字
      cha_type = HERO,  --NPC模型
      },
      combat =
      {
       acquire = 600.00,  --主动攻击范围
       basic_def = 10,   --基础防御
      },
};

function SaveTableContent(file, obj)
      local szType = type(obj);
      print(szType);
      if szType == "number" then
            file:write(obj);
      elseif szType == "string" then
            file:write(string.format("%q", obj));
      elseif szType == "table" then
            --把table的内容格式化写入文件
            file:write("{\n");
            for i, v in pairs(obj) do
                  file:write("[");
                  SaveTableContent(file, i);
                  file:write("]=\n");
                  SaveTableContent(file, v);
                  file:write(", \n");
             end
            file:write("}\n");
      else
      error("can't serialize a "..szType);
      end
end

function SaveTable()
      local file = io.open("e:\\00_00_00_海外组_学习\\写入.txt", "w");
      assert(file);
      file:write("cha = {}\n");
      file:write("cha[1] = \n");
      SaveTableContent(file, cha[1]);
      file:write("}\n");
      file:close();
end

SaveTable();


end

--]]

----------------------------------------循环计数---------------------------------

--[[
do           --  clunk

function newCounter()
    local i = 0
    return function()     -- anonymous function
       i = i + 1
        return i
    end
end

local c1 = newCounter()
print(c1())  --> 1
print(c1())  --> 2
print(c1())  --> 3

local sum = 0
local num = 1
while num <= 100 do
    sum = sum + num
    num = num + 1
end
print("sum =",sum)

end
--]]

------------------------------------------函数定义--------------------------------------

--[[

function pythagorean(a,b) local c2=a^2+b^2 return (c2^0.5) end
print (pythagorean(30,40));

print (math.randomseed(23));

--table 函数变量
a={p=print};    a.p("hi, aTion","\n")

--]]

------------------------------函数 嵌套引用 自递归 阶乘 命令输入n------------------------------------

--[[
do

-- defines a factorial function
function fact (n)
    if n == 0 then
       return 1
    else
       return n * fact(n-1)
    end
end

print("enter a number:")
a = io.read("*number")      -- read a number
print(fact(a))

end
--]]

----------------------------------------------随机数------------------------------------

--[[
print(math.random(100))
print(math.randomseed( os.time() ))
print(math.random());  print(math.random());  print(math.random());
print(math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) ))
--]]

------------------------------------------模拟导数-----------------------------------

--[[

function derviative(f,delta)
	local delta=delta or 1e-4
	return function (x)
		return (f(x+delta)-f(x))/delta
	end
end

local c=derviative(math.sin)
print (math.cos(10),c(10),"\n")


--]]




----------------------------------------------冒号(:)与点号(.)的区别--------------------------

--[[
do

--用lua进行面向对象的编程,声明方法和调用方法统一用冒号,对于属性的调用全部用点号

--1、定义的时候：Class:test()与 Class.test(self)是等价的，点号(.)要达到冒号(:)的效果要加一个self参数到第一个参数；
--2、调用的时候：object:test() 与object.test(object)等价，点号(.)要添加对象自身到第一个参数。
--总结：可以把点号(.)作为静态方法来看待，冒号(:)作为成员方法来看待。

Class = {}
Class.__index = Class

function Class.new(x,y)
    local cls = {}
    setmetatable(cls, Class)
    cls.x = x
    cls.y = y
    return cls
end
function Class:test()   -- Class:test()与 Class.test(self)是等价
    print(self.x,self.y)
end

object = Class.new(10,20)
object:test() ;  object.test(object) ;  -- 等价于


end
--]]


-------------------------------------------------------Table---------------------------------------------


--[[
do

print("table 引用 ")

tt = {"hello", 55};                                      --表中可以不同类型  任意类型的值来作数组的索引

local function helloWorld()
   print( "Hello World A !" )
end

table = { 10 ,[tt] = "table", 29, ["flag"] = 5, key=11,  3.14,  [6]=6e-3 , 40 , 60, [10]="7K", [11]={1,2,3} , func=helloWorld , function() print( "Hello World B !" ); end,  helloWorld  };

print(table.key);     print(table["key"]);    print(table['key']);   print("\n")  --11 等价索引
print(table["flag"]);    print(table.flag);    print(table['flag']);   print("\n")  --5  等价索引

print(table[1]);    print(table[2]);   print(table[3]);  print(table[4]);   print(table[5]);    print(table[6]) ;   print(table[10]) ;  print(table[11]) ;  print(table[11][3]) ;   print("\n");       --非注索引 自序(排前)组成局部数组 20 已注数字序号, 须大于非注索引个数  值为table时, 返回地址

print(table[tt]);        --table(名)作数组的索引

table.func();  table[6]() ;  table[7]()    -- Hello World!   table function引用 注意下标

end

--]]



--[===[

-----------------------------------------------------Table 插入----------------------------------

local tbl = {"alpha", "beta", "gamma", "delta"}
table.sort(tbl)   --排正序
print(table.concat(tbl, ", ")	,"\n") -- alpha, beta, delta, gamma
print(table.concat(tbl, ": "),"\n")
print(table.concat(tbl, nil, 1, 2))
print(table.concat(tbl, "\n", 2, 3))


table.insert(tbl, "delta")   --插入
table.insert(tbl, "epsilon")
table.insert(tbl, 3, "zeta")
print(table.concat(tbl, ", ")	,"\n")


local tb2 = {[1] = "a", [2] = "b", [3] = "c", [26] = "z"}
print(#tb2)   -->3   因为26和之前的数字不连续, 所以不算在数组部分内
print(table.maxn(tb2))
tb2[91.32] = true
print(table.maxn(tb2))


-----------------------------------------------------Table 复制----------------------------------

function copy_table(ori_tab)
    if type(ori_tab) ~= "table" then
        return
    end
    local new_tab = {}
    for k,v in pairs(ori_tab) do
        local vtype = type(v)
        if vtype == "table" then
            new_tab[k] = copy_table(v)
        else
            new_tab[k] = v
        end
    end
    return new_tab
end

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end

        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end




print("-----------------table copy 复制表--------------")

function copytable(table_a)
  local table_b = {}
  for k, v in pairs(table_a) do
    if type(v) ~= "table" then
      table_b[k] = v
    else
      table_b[k] = copytable(v)
    end
  end
  return table_b
end

a = { a = "ab", b = "rt", c = "rf" , { 8, 2 }  }

b = copytable(a)

--assert(a[1][1] == 8)

table.insert(b,{3,4});

function show_table(b)
	local i = 0
	for k, v in pairs(b) do
		if type(v) ~= "table" then   print(k,":" , v)
		else
			show_table(v)
    end
	end
end


show_table(b);
print("-------------------------")
show_table(a);




----------------------------Table ToString 表格转字符---------------------

print("\n","-----------TableToString-----------------");

function MultiString(s,n)
	local r=""
	for i=1,n do
		r=r..s
	end
	return r
end
--o ,obj;b use [];n \n;t num \t;
function TableToString(o,n,b,t)
	if type(b) ~= "boolean" and b ~= nil then
		print("expected third argument %s is a boolean", tostring(b))
	end
if(b==nil)then b=true end
t=t or 1
local s=""
if type(o) == "number" or
	type(o) == "function" or
	type(o) == "boolean" or
	type(o) == "nil" then
	s = s..tostring(o)
elseif type(o) == "string" then
	s = s..string.format("%q",o)
elseif type(o) == "table" then
	s = s.."{"
	if(n)then
	s = s.."\n"..MultiString("  ",t)
end
for k,v in pairs(o) do
	if b then
		s = s.."["
	end

	s = s .. TableToString(k,n, b,t+1)

	if b then
		s = s .."]"
	end

	s = s.. " = "
	s = s.. TableToString(v,n, b,t+1)
	s = s .. ","
	if(n)then
	s=s.."\n"..MultiString("  ",t)
end
end
s = s.."}"

end
return s;
end

local ati=TableToString(at,n,b,t);


print(ati);



------------------------Tabel 插表，含新key值--------------------------


function MergeTable(ta,tb)
	for m, v in pairs(tb) do
		ta[m]=v;
	end
	for n, val in pairs(ta) do
		print(n.."="..val)
	end
end

local td={szName="aaa",szKey="bbb"}
local te={nAge=15,szFaction="ccc"}

--MergeTable(td,te);


------------------------Tabel 插数据，设置key值--------------------------

local th={"aaa", 25, "策划"}
local ti={"bbb", 24, "程序"}
local tj={"ccc", 26, "测试"}
local tk={};
local tl={};

table.insert(tk,th);
table.insert(tk,ti);
table.insert(tk,tj);

for i,val in ipairs(tk) do
	local tm={};
	tm.szName=val[1];
	tm.nAge=val[2];
	tm.szTitle=val[3];
	table.insert(tl,tm);
end

for a,v1 in pairs(tl) do
	for b,v2 in pairs(v1) do
		print(a,b.."="..v2);
	end
end

print(tl[1].szTitle)

for k,v in ipairs(tl) do
	--print(k,v);

end


------------------------Tabel 整表输出 改写Print--------------------------

--三层table嵌套打印
function Print(var,varName)
	if varName then print(varName.."={");  else print("{");  end
	for k,v in pairs (var) do
		if type(v)=="table" then
			print("\t"..k.."=={");
			for l,w in pairs (v) do

				if type(w)=="table" then
					print("\t"..l.."==={");
					for m,w in pairs(w) do
						print("\t",m,w);
					end
					print("\t".."}");
				else print("\t",l,w);
				end

			end
			print("\t".."}");
		else print("\t"..k,v);
		end
	end
	print("}");
end


Print(date,"date");


function Print(obj)
	function PrintTable(obj)
		local getIndent, quoteStr, wrapKey, wrapVal, isArray, dumpObj
		getIndent = function(level)
			return string.rep("\t", level)
		end
		quoteStr = function(str)
			str = string.gsub(str, "[%c\\\"]", {
				["\t"] = "\\t",
				["\r"] = "\\r",
				["\n"] = "\\n",
				["\""] = "\\\"",
				["\\"] = "\\\\",
			})
			return '"' .. str .. '"'
		end
		wrapKey = function(val)
			if type(val) == "number" then
				return "[" .. val .. "]"
			elseif type(val) == "string" then
				return "[" .. quoteStr(val) .. "]"
			else
				return "[" .. tostring(val) .. "]"
			end
		end
		wrapVal = function(val, level)
			if type(val) == "table" then
				return dumpObj(val, level)
			elseif type(val) == "number" then
				return val
			elseif type(val) == "string" then
				return quoteStr(val)
			else
				return tostring(val)
			end
		end
		local isArray = function(arr)
			local count = 0
			for k, v in pairs(arr) do
				count = count + 1
			end
			for i = 1, count do
				if arr[i] == nil then
					return false
				end
			end
			return true, count
		end
		dumpObj = function(obj, level)
			if type(obj) ~= "table" then
				return wrapVal(obj)
			end
			level = level + 1
			local tokens = {}
			tokens[#tokens + 1] = "{"
			local ret, count = isArray(obj)
			if ret then
				for i = 1, count do
					tokens[#tokens + 1] = getIndent(level) .. wrapVal(obj[i], level) .. ","
				end
			else
				for k, v in pairs(obj) do
					tokens[#tokens + 1] = getIndent(level) .. wrapKey(k) .. " = " .. wrapVal(v, level) .. ","
				end
			end
			tokens[#tokens + 1] = getIndent(level - 1) .. "}"
			return table.concat(tokens, "\n")
		end
		return dumpObj(obj, 0)
	end

	print(PrintTable(obj));
end


local obj = {
    string1 = "Hi! My name is LiXianlin",
    string2 = "aa\tbb\rcc\ndd\\ee\"ff",
    string3 = "a\\tb\\rc\\n\\\\ee\"ff",
    int = 9527,
    float = 3.1415,
    bool = true,
    array = {
        1, 2, 3,
        {
            a = 21,
            b = 22,
            c = 23,
        },
    },
    table = {
        x = 100,
        y = 200,
        w = 960,
        h = 640,
    },
    [88] = 88888,
    [9.7] = 22222,
}

print("\n","----------------输出table测试-------------------","\n");

Print(obj);


------------------------table 迭代 遍历 递归调用---------------------------------------


table1 = {
    name = "Android Developer",
    email = "hpccns@gmail.com",
    url = "http://blog.csdn.net/hpccn",
    quote = [[
    There are
    10 types of pepole
    who can understand binary.
    ]],--多行文字
    embeddedTab = {
        em1 = xx,
        x =0,
        {x =1, y =2 } -- 再内嵌table
    }-- 内嵌table
}

tab = "    "
function print_table(t, i)
    local indent ="" -- i缩进，当前调用缩进
    for j = 0, i do
        indent = indent .. tab
    end
    for k, v in pairs(t) do
        if (type(v) == "table") then -- type(v) 当前类型时否table 如果是，则需要递归，
            print(indent .. "" .. k .. " is a table ")
            print_table(v, i + 1) -- 递归调用
            print(indent .. " end table ".. k .. "")
        else -- 否则直接输出当前值

            print(indent .. "" .. k .. "=" .. v.."")
        end
    end
end


print_table(table1, 0)



print( "-------------------Table(多层嵌套) 定位 以value 查找其他 value-------------------"  );


local tbcd=
{
 [1] = {
 ["szName"] = "aaa",
 ["szTitle"] = "策划",
 ["nAge"] = 25,
}
,
 [2] = {
 ["szName"] = "bbb",
 ["szTitle"] = "程序",
 ["nAge"] = 24,
}
,
 [3] = {
 ["szName"] = "ccc",
 ["szTitle"] = "测试",
 ["nAge"] = 26,
}
,
}



local g_t=nil;

for v,k in ipairs(tbcd) do
	for s,j in pairs(k) do
		if j=="测试" then
			--print(v,s,j) ;
			g_t=v;
		end
	end
end



print ("-----tbcd[g_t].nAge :-------", tbcd[g_t].nAge);  -->26





--]]




-----------------------------------------------Table 遍历----------------------------------

--[=[

do

local tbl = {"alpha", "beta", ["one"] = "uno", ["two"] = "dos"}

for key, value in ipairs(tbl) do     -->1 alpha \ 2 beta
print(key, value)                     --ipairs()函数用于遍历table中的数组部分
end  --这样的循环必须要求tbtest中的key为顺序的，且必从1开始，ipairs只会从1开始按连续的key顺序遍历到key不连续为止

for key, value in pairs(tbl) do       -->1 alpha \ 2 beta \one uno \ two dos
print(key, value)                      --pairs()函数用于整个table, 即包括数组及非数组部分
end                 --遍历顺序并非是tb1中table的排列顺序，而是根据tb1中key的hash值排列的顺序来遍历的

for i=1, #(tbl) do
print(key, value)
end
--只能遍历当tbtest中存在key为1的value时才会出现结果，而且是按照key从1开始依次递增1的顺序来遍历，找到一个递增不是1的时候就结束不再遍历，无论后面是否仍然是顺序的key

for i=1, table.maxn(tbl) do        --效率太低
print(key, value)
end

function pairsByKeys(t)               --迭代器
    local a = {}
    for n in pairs(t) do
        a[#a+1] = n
    end
    table.sort(a)
    local i = 0
    return function()
    i = i + 1
    return a[i], t[a[i]]
    end
end

for key, value in pairsByKeys(tbl) do
 if nSeq <= key then
 return key
 end
end

end

--]=]


-----------------------------------------------Table 排序----------------------------------

--[=[

do

local tbl = {"apple", "pear", "orange", "grape"}      --纯数组,无hash

table.sort(tbl)                                                              --默认升序
print(table.concat(tbl, "、"))


local sort_func1 = function(a, b) return a > b end  --大者在前
table.sort(tbl, sort_func1)                                           --降序
print(table.concat(tbl, "、"))

local sort_func2 = function(a, b) return a < b end  --小前
table.sort(tbl, sort_func2)                                           --升序
print(table.concat(tbl, "、"))





t = {} --Lua有一个函数table.sort可以对表进行排序, 带2个参数, 第一个参数是表, 第二个参数是排序函数.

t[1] = {name="digoal", age=30}
t[2] = {name="francs", age=29}
t[3] = {name="dage", age=34}
table.sort(t, function(x,y) return x.name < y.name end) --使用table.sort对表进行排序, 第二个参数是一个函数, 可以是匿名函数或者函数变量.

f = function(x,y) return x.name < y.name end
table.sort(t, f)  --排序后, 表的内容被改变. 所以table.sort实际上是变更了表的内容的.
print( t[1].name ) --dage
print( t[2].name ) --digoal
print( t[3].name ) --francs

table.sort(t, function(x,y) return x.name > y.name end) --按照name倒序排
print( t[1].name ) --francs
print( t[2].name ) --digoal
print( t[3].name ) --dage

table.sort(t, function(x,y) return x.age > y.age end) --按照年龄倒序排
print( t[1].name, t[1].age ) --dage    34
print( t[2].name, t[2].age ) --digoal  30
print( t[3].name, t[3].age ) --francs  29




--数值数组排序（字符串跟数值混在一起的数组是不能sort）
local test_table = {2,1,3}
table.sort(test_table)
for key,value in pairs(test_table) do
    print(key,value)
end

--> 1   1
--> 2   2
--> 3   3

--字符串数组排序
local test_table = {"a","c","b"}
table.sort(test_table)
for key,value in pairs(test_table) do
    print(key,value)
end

--> 1   a
--> 2   b
--> 3   c

print("-----------按键名Key排序---------------")


--键值对Table排序（按Key排序，不是Value）
local test_table = {a=3,b=2,c=4,d=1,}
local key_table = {}
local value_table={}

for key,_ in pairs(test_table) do     --取出所有的键
    table.insert(key_table,key)
end

table.sort(key_table)                 --对所有键进行排序

for _,key in pairs(key_table) do
    print(key,test_table[key])
end

--> a   3
--> b   2
--> c   4
--> d	1


table.sort(test_table);                --对所有键进行排序
for k,v in pairs (test_table) do
	--print (k,v)
end



--table.sort(test_table,function(a,b) return(a.a<b.a) end) --按name排降序

print("-----------按键值Value排序---(两轮循环)------------")

for _,value in pairs(test_table) do     --取出所有的键
    table.insert(value_table,value)
end

table.sort(value_table)                 --对所有键进行排序

for _,value in pairs(value_table) do
	for k,v in pairs(test_table) do
		if v==value then
		print(k,value)
		end
	end
end

-->d	1
-->b	2
-->a	3
-->c	4





local network={
    {name="grauna",IP="210.26.30.34"},
    {name="arraial",IP="210.26.30.23"},
    {name="lua",IP="210.26.23.12"},
    {name="derain",IP="210.26.23.20"},
}

table.sort(network,function(a,b) return(a.name<b.name) end) --按name排降序
for k, v in pairs(network) do  print(k, v.name ,v.IP ) end
print("\n")

table.sort(network,function(a,b) return(a.name>b.name) end) --按name排升序
for k, v in pairs(network) do  print(k, v.name,v.IP) end
print("\n")



local tbl = {"alpha", "beta", "gamma", "delta"}
table.sort(tbl)
print(table.concat(tbl, ", "))  -->alpha, beta, delta, gamma

sortFunc = function(a, b) return b < a end
table.sort(tbl, sortFunc)
print(table.concat(tbl, ", ")) -->gamma, delta, beta, alpha

local guild = {}

table.insert(guild, {
　name = "Cladhaire",
　class = "Rogue",
　level = 70,
})

table.insert(guild, {
　name = "Sagart",
　class = "Priest",
　level = 70,
})

table.insert(guild, {
　name = "Mallaithe",
　class = "Warlock",
　level = 40,
})


function sortLevelNameAsc(a, b)  --按等级升序排序, 在等级相同时, 按姓名升序排序
　if a.level == b.level then
　　return a.name < b.name
　else
　　return a.level < b.level
　end
end


table.sort(guild, sortLevelNameAsc)
for idx, value in ipairs(guild) do print(idx, value.name) end
-->1, Mallaithe
-->2, Cladhaire
-->3, Sagart



end
--]=]


--------------------------------------------字符串转table-------------------------------------

--[[
do;

local a = "{pos=3, name='物品', color='金黄色'}"
local b = loadstring("return "..a);
a = b();
print(a.pos, a.name, a.color)  --物品

end;
--]]


--------------------table 安插、删除和查找时间复杂度为O(1)的集合-------------------------

--[[
do

function newset()
     local reverse = {} --以数据为key，数据在set中的位置为value
     local set = {} --一个数组，其中的value就是要管理的数据
     return setmetatable(set,{__index = {
          insert = function(set,value)
               if not reverse[value] then
                    table.insert(set,value)
                    reverse[value] = table.getn(set)
               end
          end,

          remove = function(set,value)
               local index = reverse[value]
               if index then
                    reverse[value] = nil
                    local top = table.remove(set) --删除数组中最后一个元素
                    if top ~= value then
                         --若不是要删除的值，则替换它
                         reverse[top] = index
                         set[index] = top
                    end
               end
          end,

          find = function(set,value)
               local index = reverse[value]
               return (index and true or false)
          end,
     }})
end


local s = newset()
s:insert("hi0")
s:insert("hi1")

for k,V in ipairs(s) do
     print(k,V)                    --> hi0   -->hi1
end

print(s:find("hi0"))     -->true
s:remove("hi0")
print(s:find("hi0"))    -->false

end
--]]

-------------------打印以类型功能实现table嵌套table-----------------------

--[[
do

local cclog = function( ... )
    local tv = "\n"
    local xn = 0
    local function tvlinet(xn)
        -- body
        for i=1,xn do
            tv = tv.."\t"
        end
    end

    local function printTab(i,v)
        -- body
        if type(v) == "table" then
            tvlinet(xn)
            xn = xn + 1
            tv = tv..""..i..":Table{\n"
            table.foreach(v,printTab)
            tvlinet(xn)
            tv = tv.."}\n"
            xn = xn - 1
        elseif type(v) == nil then
            tvlinet(xn)
            tv = tv..i..":nil\n"
        else
            tvlinet(xn)
            tv = tv..i..":"..tostring(v).."\n"
        end
    end
    local function dumpParam(tab)
        for i=1, #tab do
            if tab[i] == nil then
                tv = tv.."nil\t"
            elseif type(tab[i]) == "table" then
                xn = xn + 1
                tv = tv.."\ntable{\n"
                table.foreach(tab[i],printTab)
                tv = tv.."\t}\n"
            else
                tv = tv..tostring(tab[i]).."\t"
            end
        end
    end
    local x = ...
    if type(x) == "table" then
        table.foreach(x,printTab)
    else
        dumpParam({...})
        -- table.foreach({...},printTab)
    end
    print(tv)
end

    local ttt = {23,aa=23,23,
                    {bbb=23,"dsd",false,nil,
                        {32,ccc="23dd",
                            {23,"sdfsdf",
                                {234,addd="23233jjjjsdOK"}
                            }
                        }
                    },
                    {dd = "sd",23},
                true
                }

    cclog(23,"sdf",ttt,"sdssssf",323223,false)

end
--]]


--------------------------------------------------面向对象实现----------------------------------------
--[==[
do


Acount = {
    balance = 0,
    withdraw = function(self ,v)
        self.balance = self.balance - v
    end
}

function Acount:deposit(v)
    self.balance = self.balance + v
end

function Acount:new(o)
    --让o 不可能为空，是一个表
    o = o or {}
    --这里的self是Acount自身 ，则表o的元表是Acount
    setmetatable(o ,self)
    --__index指向Account自身,当new的对象(也就是表)找不到元素时，则会从Account表中找。
    self.__index = self
    return o
end

a = Acount:new({balance = 0})
b = Acount:new{balance = 55}

--这里a调用deposit方法，但是找不到，于是去它的元表里找
--相当于:gemetatable(a).__index.deposit(a ,1000)
a:deposit(1000)
b:deposit(1000)
print(a.balance)
print(b.balance)


end
--]==]


-------------------------------------------------------元表---------------------------------------------

--[==[
do

t = {}
print(getmetatable(t))  --显示过元表 此时是nil

--可以用setmetatable来设置或修改任何table的元表
t1 = {}
setmetatable(t,t1)
-- assert(getmetatable(t) == t1, "No Meta")    -- if not n then error("invalid input") end

--给一个table关联元表 就是当你访问的这个table所访问的值不存在的时候 会返回默认的元表里的值, 可以理解成面向对象里的继承, 元表就是它的父类 如果本身有值就用本身的值 没值就用父类的值
local t = {}
local mt = {7,8,9}
setmetatable(t,{__index = mt}) --可以理解成lua的面向对象, mt是父类 t是子类
print(t[3])



--------------------------------------元表 元方法-------------------------------------
-- table的元表提供一种机制，可以重定义table的一些操作。类似js的prototype行为

f1 = {a = 1, b = 2} -- 表示一个分数 a/b.  1/2
f2 = {a = 2, b = 3}

-- 这个是错误的：
-- s = f1 + f2

metafraction = {}
function metafraction.__add(f1, f2)
sum = {}
sum.b = f1.b * f2.b
sum.a = f1.a * f2.b + f2.a * f1.b
return sum
end

setmetatable(f1, metafraction)
setmetatable(f2, metafraction)

s = f1 + f2 -- 调用在f1的元表上的__add(f1, f2) 方法
 print (s.a.."/"..s.b)  --7/6

-- 类形式的模式： -- 元表的__index 可以重载点运算符的查找
defaultFavs = {animal = 'gru', food = 'donuts'}
myFavs = {food = 'pizza'}
setmetatable(myFavs, {__index = defaultFavs})
eatenBy = myFavs.animal -- 可以工作！这要感谢元表的支持

 print (eatenBy)  --gru

-- 这里是table的元方法的全部清单：
-- __add(a, b)                     for a + b
-- __sub(a, b)                     for a - b
-- __mul(a, b)                     for a * b
-- __div(a, b)                     for a / b
-- __mod(a, b)                     for a % b
-- __pow(a, b)                     for a ^ b
-- __unm(a)                        for -a
-- __concat(a, b)                  for a .. b
-- __len(a)                        for #a
-- __eq(a, b)                      for a == b
-- __lt(a, b)                      for a < b
-- __le(a, b)                      for a <= b
-- __index(a, b)  <fn or a table>  for a.b
-- __newindex(a, b, c)             for a.b = c
-- __call(a, ...)                  for a(...)


-- [[
Set = {}
mt = {} --元表

function Set.new(l)
    local set = {}
    setmetatable(set, mt)
    for _, v in ipairs(l) do
        set[v] = true
    end
    return set
end


--================================================
function Set.tostring(set)
    local l = {}
    for e in pairs(set) do
        l[#l + 1] = e
    end
    return "{" .. table.concat(l, ",") .. "}"
end


function Set.print(s)
    print(Set.tostring(s))
end


--1 加(__add), 并集===============================
function Set.union(a, b)
--[[    if getmetatable(a) ~= mt or getmetatable(b) ~= mt then
        error("attemp to 'add' a set with a non-set value", 2)   --error第二个参数的含义P116
    end]]
    local res = Set.new{}
    for k in pairs(a) do res[k] = true end
    for k in pairs(b) do res[k] = true end
    return res
end

s1 = Set.new{10, 20, 30, 50}
s2 = Set.new{30, 1}
--print(getmetatable(s1))
--print(getmetatable(s2))
mt.__add = Set.union

s3 = s1 + s2
--Set.print(s3)

--[[元表混用
s = Set.new{1, 2, 3}
s = s + 8
Set.print(s + 8)
]]

--2 乘(__mul), 交集==============================
function Set.intersection(a, b)
    local res = Set.new{}
    for k in pairs(a) do
        res[k] = b[k]
    end
    return res
end

mt.__mul = Set.intersection

--Set.print(s2 * s1)



--3 关系类===================================NaN的概念====
mt.__le = function(a, b)
    for k in pairs(a) do
        if not b[k] then return false end
    end
return true
end

mt.__lt = function(a, b)
    return a <= b and not (b <= a)
end

mt.__eq = function(a, b)           --竟然能这么用！？----
    return a <= b and b <= a
end

g1 = Set.new{2, 4, 3}
g2 = Set.new{4, 10, 2}
print(g1 <= g2)
print(g1 < g2)
print(g1 >= g2)
print(g1 > g2)
print(g1 == g1 * g2)

--]]

--============================================
--4 table访问的元方法=========================
-- [[
--__index有关继承的典型示例
Window = {}
Window.prototype = {x = 0, y = 0, width = 100, height}
Window.mt = {}

function Window.new(o)
    setmetatable(o, Window.mt)
    return o
end

Window.mt.__index = function (table, key)
    return Window.prototype[key]
end

w = Window.new{x = 10, y = 20}
print(w.width)

--__index修改table默认值
function setDefault (t, d)
    local mt = {__index = function () return d end}
    setmetatable(t, mt)
end

tab = {x = 10, y = 20}
print(tab.x, tab.z)
setDefault(tab, 0)
print(tab.x, tab.z)

--]]

--13.4.5 只读的table
function readOnly(t)
    local proxy = {}
    local mt = {
    __index = t,
    __newindex = function(t, k, v)
        error("attempt to update a read-only table", 2)
    end
    }
    setmetatable(proxy, mt)
    return proxy
end

days = readOnly{"Sunday", "Monday", "Tuesday", "W", "T", "F", "S"}
print(days[1])
--days[2] = "Noday"   --只读的table , 限制更新


------------------------------------------------- 类风格的table和继承---------------------------------

Dog = {} -- 类? 其实完全是一个table

function Dog:new() -- 函数tablename:fn(...) 与函数tablename.fn(self, ...) 是一样的  -- 冒号（:）只是添加了self作为第一个参数
newObj = {sound = 'woof'} -- newObj是类Dog的一个实例
self.__index = self -- self为初始化的类实例。通常self = Dog，不过继承关系可以改变这个, 如果把newObj的元表和__index都设置为self， newObj就可以得到self的函数
return setmetatable(newObj, self) -- setmetatable返回其第一个参数
end

function Dog:makeSound() -- 冒号（：）在第2条是工作的，不过这里我们期望  self是一个实例，而不是类
print('I say ' .. self.sound)
end

mrDog = Dog:new() -- 与Dog.new(Dog)类似，所以 self = Dog in new().
mrDog:makeSound() -- 'I say woof' -- 与mrDog.makeSound(mrDog)一样; self = mrDog.


-- 继承的例子

LoudDog = Dog:new() -- LoudDog获得Dog的方法和变量列表

function LoudDog:makeSound()
s = self.sound .. ' ' -- 通过new()，self有一个'sound'的key from new()
print(s .. s .. s)
end

seymour = LoudDog:new() -- 与LoudDog.new(LoudDog)一样，并且被转换成  Dog.new(LoudDog)，因为LoudDog没有'new' 的key，  不过在它的元表可以看到 __index = Dog。结果: seymour的元表是LoudDog，并且 LoudDog.__index = LoudDog。所以有seymour.key =seymour.key, LoudDog.key, Dog.key, 要看针对给定的key哪一个table排在前面。

seymour:makeSound() -- 'woof woof woof' -- 在LoudDog可以找到'makeSound'的key；这与
-- LoudDog.makeSound(seymour)一样.


-- 如果需要，子类也可以有new()，与基类的类似：
function LoudDog:new()
newObj = {}
-- 初始化newObj
self.__index = self
return setmetatable(newObj, self)
end


------------------------------------------类继承-------------------------

A = {}   --基类A

function A:new(o)         --构造 A:New(o)与 A.New(self,o)
    o = o or {}
    setmetatable(o,self)   --元表
    self.__index = self         --__index方法是用来确定一个表在被作为元表时的查找方法
    return o
end

function A:funName()
    print('A')
end

--若想从这个类派生出一个子类B，以使其能打印出类名。则先需要创建一个空的类，从基类继承所有的操作：
B = A:new()

s = B:new()   --B从A中继承了new，就像继承其他方法一样。不过这次new在执行时，它的self参数表示为B。因此，s的元表为B，B中字段__index的值也是B。s继承自B，而B又继承自A


function B:funName()   --B重写funName()函数
    print('B')
end

s:funName()    --输出的是B




end
--]==]


--[[
do
-------------------------类构造-------------------------

Class = {x=0,y=0}
Class.__index = Class    --重定义元表的索引，必须要有
function Class:new(x,y)   --模拟构造体，一般名称为new()
        local self = {}
        setmetatable(self, Class)
        self.x = x
        self.y = y
        return self
end
function Class:test()
    print(self.x,self.y)
end

function Class:gto()  --新定义的一个函数gto()
   return 100
end

function Class:gio()
   return self:gto() * 2   --这里会引用gto()
end

function Class:plus()
    self.x = self.x + 1
        self.y = self.y + 1
end

-------------------------类实现-------------------------

objA = Class:new(1,2)
objA:test()                 -->1    2
print(objA.x,objA.y)   --> 1    2

-------------------------类继承-------------------------

Main = {z=0}   --声明了新的属性Z
setmetatable(Main, Class)   --设置类型是Class
Main.__index = Main  --还是和类定义一样，表索引设定为自身

function Main:new(x,y,z)   --构造体，加上了一个新的参数
   local self = {}  --初始化对象自身
   self = Class:new(x,y) --将对象自身设定为父类，这个语句相当于其他语言的super
   setmetatable(self, Main)   --将对象自身元表设定为Main类
   self.z= z   --新的属性初始化，如果没有将会按照声明=0
   return self
end

-------------------------类多态-------------------------


function Main:go()   --定义一个新的方法
   self.x = self.x + 10
end

function Main:test()   --重定义父类的方法
    print(self.x,self.y,self.z)
end

-------------------------类测试-------------------------

c = Main:new(20,40,100)
c:test()
d = Main:new(10,50,200)
d:go()
d:plus()
d:test()
c:test()

end



-------------------------类实现-------------------------

ClassYM = {x=0,y=0}  --这句是重定义元表的索引，必须要有，
ClassYM.__index = ClassYM

function ClassYM:new(x,y)  --模拟构造体，一般名称为new()
        local self = {}
        setmetatable(self, ClassYM)   --必须要有
        self.x = x
        self.y = y
  return self
end

function ClassYM:test()
    print(self.x,self.y)
end

objA = ClassYM:new(1,2)
objA:test()
print(objA.x,objA.y)

-- 运行结果如下：
-- 1   2
-- 1   2

-- print(objA:x,objA:y) -- 会报错，调用ojbA.test也会报错

objA = ClassYM:new(1,2)  -- 调用
-- 再调用objA.test()时结果如下：-- 2  0

objA = ClassYM:new(self,1,2)  -- 如调用
-- 再调用objA.test()时结果如下：
-- 1  2

Main = {z=0}   --2，继承 声明了新的属性Z
setmetatable(Main, Class)  --设置类型是Class
Main.__index = Main  --还是和类定义一样，表索引设定为自身

function Main:new(x,y,z)   --这里是构造体，看，加上了一个新的参数
   local self = {}  --初始化对象自身
   self = Class:new(x,y) --将对象自身设定为父类，这个语句相当于其他语言的super
   setmetatable(self, Main) --将对象自身元表设定为Main类
   self.z= z --新的属性初始化，如果没有将会按照声明=0
   return self
end

function Main:go()  --定义一个新的方法
   self.x = self.x + 10
end

function Main:test()   --重定义父类的方法
    print(self.x,self.y,self.z)
end

c = Main:new(20,40,100)   -- 测试代码如下：
c:test()
d = Main:new(10,50,200)
d:go()
d:plus()
d:test()
c:test()

Class = {x=0,y=0}   -- 3，多态
Class.__index = Class
function Class:new(x,y)
        local self = {}
        setmetatable(self, Class)
        self.x = x
        self.y = y
  return self
end

function Class:test()
    print(self.x,self.y)
end

function Class:gto()  --新定义的一个函数gto()
   return 100
end

function Class:gio()   --这里会引用gto()
   return self:gto() * 2
end

function Class:plus()
    self.x = self.x + 1
        self.y = self.y + 1
end

Main = {z=0}  --继承部分代码如下：
setmetatable(Main, Class)
Main.__index = Main

function Main:new(x,y,z)
   local self = {}
   self = Class:new(x,y)
   setmetatable(self, Main)
   self.z= z
   return self
end

function Main:gto()   --重新定义了gto()
   return 50
end

function Main:go()
   self.x = self.x + 10
end

function Main:test()
    print(self.x,self.y,self.z)
end

a = Class:new(10,20)   --测试代码如下：
print(a:gio())
d = Main:new(10,50,200)
print(d:gio())
print(a:gio())




Account={ test1=function(a) print("Account test1") end }
Account.test2=function(a) print("Account test2") end
function Account.test3(a) print("Account test3") end

--用lua进行面向对象的编程,声明方法和调用方法统一用冒号,对于属性的调用全部用点号

function Account:new (o)  --类的实例化

  o = o or {}
  setmetatable(o, self)
  self.__index = self

  return o

end

function Account.print0(o,a)
  print(a)
end

function Account:print1(a)
  print(a)
end


--方法定义测试
Account.test1()
Account.test2()
Account.test3()

--类测试
acc=Account:new()
acc.test1()
acc.print0(acc,"dot print0")
acc:print0("not dot print0")
acc.print1(acc,"dot print1")
acc:print1("not dot print1")

acc.specialMethod=function(specialMethodTest)
  print(specialMethodTest)
end

acc.specialMethod("smt test")

--继承测试
SpecialAccount = Account:new()
s = SpecialAccount:new{limit=1000.00}

--多重继承测试
Named = {}

function Named:getname ()

  return self.name

end

function Named:setname (n)

  self.name = n

end

local function search (k, plist)

  for i=1, table.getn(plist) do

    local v = plist[i][k]

    if v then return v end

  end

end

function createClass (...)

  local c = {}      -- new class

  setmetatable(c, {__index = function (t, k)

    return search(k, arg)

    end})

    c.__index = c

    function c:new (o)

      o = o or {}

      setmetatable(o, c)

      return o

    end

    return c

  end
  NamedAccount = createClass(Account, Named)

  account = NamedAccount:new{name = "Paul"}

  print(account:getname())


  --私有性

function newAccount (initialBalance)
    local self = {balance = initialBalance}

    local withdraw = function (v)
       self.balance = self.balance - v
    end

    local deposit = function (v)
       self.balance = self.balance + v
    end

    local getBalance = function () return self.balance end

    return {

       withdraw = withdraw,
       deposit = deposit,
       getBalance = getBalance

    }

end

acc1 = newAccount(100.00)
acc1.withdraw(40.00)
159
print(acc1.getBalance())    --> 60







--]]


-----------------------------------Url 分割----------------------------------------------

--[=[
do

function Split(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
  local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
  if not nFindLastIndex then
    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
    break
  end
  nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
  nFindStartIndex = nFindLastIndex + string.len(szSeparator)
  nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end

function parseUrl(url)
	local t1 = nil
	--,
	t1= Split(url,',')

	--?
	url = t1[1]
	t1=Split(t1[1],'?')

	url=t1[2]
	--&

	t1=Split(t1[2],'&')
	local res = {}
	for k,v in pairs(t1) do
		i = 1
		t1 = Split(v,'=')
		res[t1[1]]={}
		res[t1[1]]=t1[2]
		i=i+1
	end
	return res
end


local url = 'http://192.168.1.113:8080/openG3/m/appPanel.vm?appId=1&appkey=111111&sid=12345,game/js/'
local res = parseUrl('http://www.baidu.com')
print('appkey= '..res.appkey)
print('sid= '..res.sid)
print('appid= '..res.appId)

end

--]=]


-------------------------键盘输入测试，求任意数的平方、平方根------------------------------

--[[
--input.lua
print "请输入一个数"
i=io.read()
a=i^2
b=math.sqrt(i)
print(i .. "的平方=" .. a)
print(i .. "平方根=" .. b)
--]]

------------------------------print "用Lua解百钱百鸡：公鸡5钱 母鸡3钱 鸡仔1/3钱"---------------------

--[[

-- chicken.lua
for a=1,20 do
	for b=1,33 do
		for c=1,100 do
			if a+b+c==100 and 5*a+3*b+1/3*c==100 then
				print ("公鸡" .. a,"母鸡" .. b,"鸡仔" .. c)
			end
		end
	end
end
print "OK"
--io.read()
--]]

------------------------------------清屏方法--------------------------------

--[[

--luacls.lua

a={}
a={"aa","bb","cc","dd"}

for i =1, #a do
	print(a[i])
end
print ("表中共有"..#a.."个成员")

-- clear screen
if os.getenv("OS")=="Windows_NT" then
	os.execute("cls")
end

for i=1,9 do
	print ("this is line "..i)
end

--]]

----------------------写出文件------------------------

--[[

--inputfile.lua
--追加方式

--myfile=io.open("c:\\namelist.txt","a")
--print(myfile)


for k in myfile:lines() do
  print(k)
end
myfile:close()
--]]


--[[

file = io.open("c:\\namelist.txt","a+")
file:write("1234567890 \n")   --写文件
file:close()


file = io.open("c:\\namelist.txt","r")
for l in file:lines() do   print(l)  end   --读文件
file:close()
--]]


--[[

while true do
  io.write("姓名：")
  sname=io.read()
  if sname == "quit" then
    io.close(myfile)
    break
  else
    myfile:write(sname .. "\n")
    print()
  end
end
print("OK!")

--]]

---------------------------测试文本输入 --输入quit退出--------------------

--[[
--write.lua

while true do
  io.write "请输入你的名字："
  name=io.read()
  if name=="quit" then
    break
  else
    print("您好," .. name .. "!")
    print ""
  end
end
--]]


---------------------------不定参数的妙用-------------------------------------------

--[[
function fun(...)
  for i=1, arg.n do    -->接收到的所有参数都被自动写入一个表arg中
    print(arg[i])       -->arg.n表示表中的最大索引
  end
end
fun(1,2,3,"hello",true)
--]]

---------------------------求平方和立方根-----------------------------------

--[[

a=3^2
b=math.sqrt(4)

--开3次方
c=8^(1/3)   -->结果=2

print(a,b,c)
--]]

------------------------------多个表达式写在一行上----------------------------

--[[
a=1 b=2 c="hello"
print(a,b,c)
--]]

-------------------------逻辑运算的特殊用法------------------------------------

--[[

x=false and 2     -->结果=2,如果x不等1,则等于2
print(x)

x=1 and 2 and 3    -->结果=3,返回最后一个为假的值
print(x)

y=1 or 2      -->结果=1,返回第一个为真的值
print(y)
--]]

-----------------------Lua 作为数据描述语言使用----------------------------------

--[==[
do
-- db.lua

local entry={
title = "Tecgraf",
org = "Computer Graphics Technology Group, PUC-Rio",
url = "http://www.tecgraf.puc-rio.br/",
contact = "Waldemar Celes",
description = [[
TeCGraf is the result of a partnership between PUC-Rio,
the Pontifical Catholic University of Rio de Janeiro,
and <A HREF="http://www.petrobras.com.br/">PETROBRAS</A>,
the Brazilian Oil Company.
TeCGraf is Lua's birthplace,
and the language has been used there since 1993.
Currently, more than thirty programmers in TeCGraf use
Lua regularly; they have written more than two hundred
thousand lines of code, distributed among dozens of
final products.]]
}

print(entry.description);

function fwrite (fmt, ...)
  return io.write(string.format(fmt, unpack(arg)))
end

function BEGIN()
io.write([[
<HTML>
<HEAD><TITLE>Projects using Lua</TITLE></HEAD>
<BODY BGCOLOR="#FFFFFF">
Here are brief descriptions of some projects around the
world that use <A HREF="home.html">Lua</A>.
]])
end

function entry0 (o)
  N=N + 1
  local title = o.title or '(no title)'
 fwrite('<LI><A HREF="#%d">%s</A>\n', N, title)
end

function entry1 (o)
  N=N + 1
  local title = o.title or o.org or 'org'
 fwrite('<HR>\n<H3>\n')
  local href = ''

  if o.url then
  href = string.format(' HREF="%s"', o.url)
 end
 fwrite('<A NAME="%d"%s>%s</A>\n', N, href, title)

  if o.title and o.org then
  fwrite('\n<SMALL><EM>%s</EM></SMALL>', o.org)
 end
 fwrite('\n</H3>\n')

  if o.description then
  fwrite('%s', string.gsub(o.description,
       '\n\n\n*', '<P>\n'))
  fwrite('<P>\n')
 end

  if o.email then
  fwrite('Contact: <A HREF="mailto:%s">%s</A>\n',
    o.email, o.contact or o.email)
  elseif o.contact then
  fwrite('Contact: %s\n', o.contact)
 end
end

function END()
fwrite('</BODY></HTML>\n')
end

BEGIN()

N = 0
entry = entry0
fwrite('<UL>\n')
dofile('D:\\My Documents\\Contacts\\db.lua')
fwrite('</UL>\n')

N = 0
entry = entry1
dofile('D:\\My Documents\\Contacts\\db.lua')

END()

end
--]==]

-----------------------------读入文件到table.lua---------------------------------------

--[==[

os.execute("dir G:\\Temp\\TV\\*.txt /b >G:\\Temp\\TV\\temp.txt")    --写出文件
io.input("G:\\Temp\\TV\\temp.txt")  --读入文件

--将文件按行写入table

files={}
for t in io.lines() do
  table.insert(files,t)
end

--遍历table

for i=1,#files do
  print (files[i])
end

for i=1,#t do     --2维 索引4内容
  print (t[i]["4"])
end


io.close()
--]==]


-------------------------------------CSV--------------------------

--[[

function ParseCSVLine (line,sep)
	local res = {}
	local pos = 1
	sep = sep or ','
	while true do
		local c = string.sub(line,pos,pos)
		if (c == "") then break end
		if (c == '"') then
			-- quoted value (ignore separator within)
			local txt = ""
			repeat
				local startp,endp = string.find(line,'^%b""',pos)
				txt = txt..string.sub(line,startp+1,endp-1)
				pos = endp + 1
				c = string.sub(line,pos,pos)
				if (c == '"') then txt = txt..'"' end
				-- check first char AFTER quoted string, if it is another
				-- quoted string without separator, then append it
				-- this is the way to "escape" the quote char in a quote. example:
				--   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
			until (c ~= '"')
			table.insert(res,txt)
			assert(c == sep or c == "")
			pos = pos + 1
		else
			-- no quotes used, just look for the first separator
			local startp,endp = string.find(line,sep,pos)
			if (startp) then
				table.insert(res,string.sub(line,pos,startp-1))
				pos = endp + 1
			else
				-- no separator found -> use rest of string and terminate
				table.insert(res,string.sub(line,pos))
				break
			end
		end
	end
	return res
end

--]]


--[[

--读取Csv文件

--csv解析


-- 去掉字符串左空白
local function trim_left(s)
    return string.gsub(s, "^%s+", "");
end


-- 去掉字符串右空白
local function trim_right(s)
    return string.gsub(s, "%s+$", "");
end

-- 解析一行
local function parseline(line)
    local ret = {};

    local s = line .. ",";  -- 添加逗号,保证能得到最后一个字段

    while (s ~= "") do
        --print(0,s);
        local v = "";
        local tl = true;
        local tr = true;

        while(s ~= "" and string.find(s, "^,") == nil) do
            --print(1,s);
            if(string.find(s, "^\"")) then
                local _,_,vx,vz = string.find(s, "^\"(.-)\"(.*)");
                --print(2,vx,vz);
                if(vx == nil) then
                    return nil;  -- 不完整的一行
                end

                -- 引号开头的不去空白
                if(v == "") then
                    tl = false;
                end

                v = v..vx;
                s = vz;

                --print(3,v,s);

                while(string.find(s, "^\"")) do
                    local _,_,vx,vz = string.find(s, "^\"(.-)\"(.*)");
                    --print(4,vx,vz);
                    if(vx == nil) then
                        return nil;
                    end

                    v = v.."\""..vx;
                    s = vz;
                    --print(5,v,s);
                end

                tr = true;
            else
                local _,_,vx,vz = string.find(s, "^(.-)([,\"].*)");
                --print(6,vx,vz);
                if(vx~=nil) then
                    v = v..vx;
                    s = vz;
                else
                    v = v..s;
                    s = "";
                end
                --print(7,v,s);

                tr = false;
            end
        end

        if(tl) then v = trim_left(v); end
        if(tr) then v = trim_right(v); end

        ret[table.getn(ret)+1] = v;
        --print(8,"ret["..table.getn(ret).."]=".."\""..v.."\"");

        if(string.find(s, "^,")) then
            s = string.gsub(s,"^,", "");
        end

    end

    return ret;
end



--解析csv文件的每一行
local function getRowContent(file)
    local content;

    local check = false
    local count = 0
    while true do
        local t = file:read()
        if not t then  if count==0 then check = true end  break end

        if not content then
            content = t
        else
            content = content..t
        end

        local i = 1
        while true do
            local index = string.find(t, "\"", i)
            if not index then break end
            i = index + 1
            count = count + 1
        end

        if count % 2 == 0 then check = true break end
    end

    if not check then  assert(1~=1) end
    return content
end



--解析csv文件
function LoadCsv(fileName)
    local ret = {};

    local file = io.open(fileName, "r")
    assert(file)
    local content = {}
    while true do
        local line = getRowContent(file)
        if not line then break end
        table.insert(content, line)
    end

    for k,v in pairs(content) do
        ret[table.getn(ret)+1] = parseline(v);
    end


    file:close()

    return ret
end


--test
--local t= LoadCsv("csvtesttxt.csv")
--for k,v in pairs(t) do
--  local tt = v
--  local s = ""
--  for i,j in pairs(tt) do
--      s = string.format("%s,%s",s,j)
--  end
--  print ("",s)
--end
--]]

-----------------Used to escape "'s by toCSV----------------------


--[==[

function escapeCSV (s)
  if string.find(s, '[,"]') then
    s = '"' .. string.gsub(s, '"', '""') .. '"'
  end
  return s
end


-- Convert from CSV string to table (converts a single line of a CSV file)
function fromCSV (s)
  s = s .. ','        -- ending comma
  local t = {}        -- table to collect fields
  local fieldstart = 1
  repeat
    -- next field is quoted? (start with `"'?)
    if string.find(s, '^"', fieldstart) then
      local a, c
      local i  = fieldstart
      repeat
        -- find closing quote
        a, i, c = string.find(s, '"("?)', i+1)
      until c ~= '"'    -- quote not followed by quote?
      if not i then error('unmatched "') end
      local f = string.sub(s, fieldstart+1, i-1)
      table.insert(t, (string.gsub(f, '""', '"')))
      fieldstart = string.find(s, ',', i) + 1
    else                -- unquoted; find next comma
      local nexti = string.find(s, ',', fieldstart)
      table.insert(t, string.sub(s, fieldstart, nexti-1))
      fieldstart = nexti + 1
    end
  until fieldstart > string.len(s)
  return t
end


-- Convert from table to CSV string
function toCSV (tt)
  local s = ""
-- ChM 23.02.2014: changed pairs to ipairs
-- assumption is that fromCSV and toCSV maintain data as ordered array
  for _,p in ipairs(tt) do
    s = s .. "," .. escapeCSV(p)
  end
  return string.sub(s, 2)      -- remove first comma
end


local network={name="grauna",IP="210.26.30.34"}
for k, v in pairs(network) do  print(k, network.name, network.IP) end
local cs=toCSV(network)
print(cs)

file = io.open("d:\\namelist.txt","a+")
--file:write(cs)   --写文件
--file:write("name", "\t", "IP","\n")
for k, v in pairs(network) do  file:write( k, "\t")  end ;  file:write("\n") ;
for k, v in pairs(network) do  file:write( network.name, "\t",network.IP,"\n") end

file:close()

--]==]


----------------------系列化----------------table 转 s ----------------表 转 字符串---------------



--[[

function sz_T2S(_t)    --table转字符串(只取标准写法，以防止因系统的遍历次序导致ID乱序)
    local szRet = "{"
    function doT2S(_i, _v)
        if "number" == type(_i) then
            szRet = szRet .. "[" .. _i .. "] = "
            if "number" == type(_v) then
                szRet = szRet .. _v .. ","
            elseif "string" == type(_v) then
                szRet = szRet .. '"' .. _v .. '"' .. ","
            elseif "table" == type(_v) then
                szRet = szRet .. sz_T2S(_v) .. ","
            else
                szRet = szRet .. "nil,"
            end
        elseif "string" == type(_i) then
            szRet = szRet .. '["' .. _i .. '"] = '
            if "number" == type(_v) then
                szRet = szRet .. _v .. ","
            elseif "string" == type(_v) then
                szRet = szRet .. '"' .. _v .. '"' .. ","
            elseif "table" == type(_v) then
                szRet = szRet .. sz_T2S(_v) .. ","
            else
                szRet = szRet .. "nil,"
            end
        end
    end
    table.foreach(_t, doT2S)
    szRet = szRet .. "}"
    return szRet
end



function t_S2T(_szText)   --字符串转table(反序列化,异常数据直接返回nil)
    --栈
    function stack_newStack()
        local first = 1
        local last = 0
        local stack = {}
        local m_public = {}
        function m_public.pushBack(_tempObj)
            last = last + 1
            stack[last] = _tempObj
        end
        function m_public.temp_getBack()
            if m_public.bool_isEmpty() then
                return nil
            else
                local val = stack[last]
                return val
            end
        end
        function m_public.popBack()
            stack[last] = nil
            last = last - 1
        end
        function m_public.bool_isEmpty()
            if first > last then
                first = 1
                last = 0
                return true
            else
                return false
            end
        end
        function m_public.clear()
            while false == m_public.bool_isEmpty() do
                stack.popFront()
            end
        end
        return m_public
    end
    function getVal(_szVal)
        local s, e = string.find(_szVal,'"',1,string.len(_szVal))
        if nil ~= s and nil ~= e then
            --return _szVal
            return string.sub(_szVal,2,string.len(_szVal)-1)
        else
            return tonumber(_szVal)
        end
    end

    local m_szText = _szText
    local charTemp = string.sub(m_szText,1,1)
    if "{" == charTemp then
        m_szText = string.sub(m_szText,2,string.len(m_szText))
    end
    function doS2T()
        local tRet = {}
        local tTemp = nil
        local stackOperator = stack_newStack()
        local stackItem = stack_newStack()
        local val = ""
        while true do
            local dLen = string.len(m_szText)
            if dLen <= 0 then
                break
            end

            charTemp = string.sub(m_szText,1,1)
            if "[" == charTemp or "=" == charTemp then
                stackOperator.pushBack(charTemp)
                m_szText = string.sub(m_szText,2,dLen)
            elseif '"' == charTemp then
                local s, e = string.find(m_szText, '"', 2, dLen)
                if nil ~= s and nil ~= e then
                    val = val .. string.sub(m_szText,1,s)
                    m_szText = string.sub(m_szText,s+1,dLen)
                else
                    return nil
                end
            elseif "]" == charTemp then
                if "[" == stackOperator.temp_getBack() then
                    stackOperator.popBack()
                    stackItem.pushBack(val)
                    val = ""
                    m_szText = string.sub(m_szText,2,dLen)
                else
                    return nil
                end
            elseif "," == charTemp then
                if "=" == stackOperator.temp_getBack() then
                    stackOperator.popBack()
                    local Item = stackItem.temp_getBack()
                    Item = getVal(Item)
                    stackItem.popBack()
                    if nil ~= tTemp then
                        tRet[Item] = tTemp
                        tTemp = nil
                    else
                        tRet[Item] = getVal(val)
                    end
                    val = ""
                    m_szText = string.sub(m_szText,2,dLen)
                else
                    return nil
                end
            elseif "{" == charTemp then
                m_szText = string.sub(m_szText,2,string.len(m_szText))
                local t = doS2T()
                if nil ~= t then
                    szText = sz_T2S(t)
                    tTemp = t
                    --val = val .. szText
                else
                    return nil
                end
            elseif "}" == charTemp then
                m_szText = string.sub(m_szText,2,string.len(m_szText))
                return tRet
            elseif " " ~= charTemp then
                val = val .. charTemp
                m_szText = string.sub(m_szText,2,dLen)
            else
                m_szText = string.sub(m_szText,2,dLen)
            end
        end
        return tRet
    end
    local t = doS2T()
    return t
end


function t2s(_t)    --table转字符串(只取标准写法，以防止因系统的遍历次序导致ID乱序)
    local Ret = "{"
    function dot2s(_i, _v)
        if "number" == type(_i) then
            Ret = Ret .. "[" .. _i .. "]="
            if "number" == type(_v) then
                Ret = Ret .. _v .. ","
            elseif "string" == type(_v) then
                Ret = Ret .. '"' .. _v .. '"' .. ","
            elseif "table" == type(_v) then
                Ret = Ret .. t2s(_v) .. ","
            else
                Ret = Ret .. "nil,"
            end
        elseif "string" == type(_i) then
            Ret = Ret .. '["' .. _i .. '"]='
            if "number" == type(_v) then
                Ret = Ret .. _v .. ","
            elseif "string" == type(_v) then
                Ret = Ret .. '"' .. _v .. '"' .. ","
            elseif "table" == type(_v) then
                Ret = Ret .. t2s(_v) .. ","
            else
                Ret = Ret .. "nil,"
            end
        end
    end
    table.foreach(_t, dot2s)
    Ret = Ret .. "}"
    return Ret
end

local t1={1,2,{"a",3},"b", ["th"]="c", };
print(t2s(t1));

print(type(t1));



--]]

-----------------------------多线程---------------------------------------

--[===[

function addBuffer1()                                       -- 循环检测和补充buffer1
    while true do                                                 -- 主循环
        if getColor(100, 100) ~= 0x000000 then  -- 如果没有buffer1
            touchDown(0, 100, 100);                       -- 释放buffer1
            touchUp(0);
        end
        mSleep(500);
        coroutine.yield();                                       -- 主动挂起自己
    end
end


function addBuffer2()                                       -- 循环检测和补充buffer2
    while true do                                                 -- 主循环
        if getColor(200, 200) ~= 0x000000 then  -- 如果没有buffer2
            touchDown(0, 200, 200);                       -- 释放buffer2
            touchUp(0);
        end
        mSleep(500);
        coroutine.yield();                                       -- 主动挂起自己
    end
end


function addBuffer3()                                       -- 循环检测和补充buffer3
    while true do                                                 -- 主循环
        if getColor(300, 300) ~= 0x000000 then  -- 如果没有buffer3
            touchDown(0, 300, 300);                       -- 释放buffer3
            touchUp(0);
        end
        mSleep(500);
        coroutine.yield();                                       -- 主动挂起自己
    end
end


function addBuffer4()                                       -- 循环检测和补充buffer4
    while true do                                                 -- 主循环
        if getColor(400, 400) ~= 0x000000 then  -- 如果没有buffer4
            touchDown(0, 400, 400);                       -- 释放buffer4
            touchUp(0);
        end
        mSleep(500);
        coroutine.yield();                                        -- 主动挂起自己
    end
end


function addBuffer5()                                        -- 循环检测和补充buffer5
    while true do                                                  -- 主循环
         if getColor(500, 500) ~= 0x000000 then  -- 如果没有buffer5
            touchDown(0, 500, 500);                        -- 释放buffer5
            touchUp(0);
        end
        mSleep(500);
        coroutine.yield();                                        -- 主动挂起自己
    end
end


function kill()                                                     -- 循环打怪一直到怪物死亡
    while true do
        if getColor(600, 600) ~= 0x000000 then  -- 如果怪物没死
           touchDown(0, 1000, 1000);                    -- 释放一次技能
           touchUp(0);
        end
        mSleep(500);
        coroutine.yield();                                       -- 主动挂起自己
    end
end


function main()
    co1 = coroutine.create(addBuffer1);
    co2 = coroutine.create(addBuffer2);
    co3 = coroutine.create(addBuffer3);
    co4 = coroutine.create(addBuffer4);
    co5 = coroutine.create(addBuffer5);
    co6 = coroutine.create(kill);


    while true do
        coroutine.resume(co1);
        coroutine.resume(co2);
        coroutine.resume(co3);
        coroutine.resume(co4);
        coroutine.resume(co5);
        coroutine.resume(co6);
    end
end






--]===]

--------------------------------------策略-------------------------------

-----------------------------MA--------------------------------

do

function CalcMA(closeData, step, param)

	local calc = step or #closeData;
	if #closeData < calc + param then
		return nil
	end
	--print("closeData: ",closeData);
	local ma = {}
	for i=1, calc do
		ma[i] = 0
	end
	for i=0,step-1 do
		local Sum = 0;
		for j=0,param-1 do
			Sum = closeData[#closeData - i - j] + Sum;
		end
		ma[step-i] = Sum/param
	end
	return ma
end

function Cross(data1, data2)
	return data1 ~= nil and data2 ~= nil and
		data1[#data1-1] < data2[#data2-1] and data1[#data1] > data2[#data2];
end

function QryTradingAccount()
	local Request={};
	Request['current_account'] = current_account;
	Request['InvestorID']		= current_account;
	local retInfo, err = trade.FutureQueryFunds(Request);
	if retInfo ~= nil then
		print("QryTradingAccount", retInfo);
	else
		print("QryTradingAccount", err);
	end
end

local tbcd={Name='300033',
Time={20131218,20131219,20131220,20131223,20131224,20131225,20131226,20131227,20131230,20131231,20140102,20140103,20140106,20140107,20140108,20140109,20140110,20140113,20140114,20140115,20140116,20140117,20140120,20140121,20140122,20140123,20140124,20140127,20140128,20140129,20140130,20140207,20140210,20140211,20140212,20140213,20140214,20140217,20140218,20140219,20140220,20140221,20140224,20140225,20140226,20140227,20140228,20140303,20140304,20140305,20140306,20140307,20140310,20140311,20140312,20140313,20140314,20140317,20140318,20140319,20140320,20140321,20140324,20140325,20140326,20140327,20140328,20140331,20140401,20140402,20140403,20140404,20140408,20140409,20140410,20140411,20140414,20140415,20140416,20140417,20140418,20140421,20140422,20140423,20140424,20140425,20140428,20140429,20140430,20140505,20140506,20140507,20140508,20140509,20140512,20140513,20140514,20140515,20140516,20140609},
Open={11.46,11.3,11.36,11.01,10.99,11.13,11.86,11.58,12.72,12.47,11.87,11.89,12.03,11.45,11.58,11.93,11.42,11.1,10.96,11.27,11.47,11.37,11.43,11.27,11.5,11.88,12,12.92,12.72,12.38,13.1,13.54,13.77,13.8,13.67,13.5,12.94,13.34,13.48,13.35,13.99,13.27,13.28,12.91,11.56,11.55,11.15,11.48,11.77,11.78,12.37,12.3,11.76,11.35,11.42,11.65,11.49,11.46,11.82,11.86,11.85,11.47,11.67,11.7,11.65,11.73,11.27,10.8,10.63,11.06,11.15,11.47,11.48,11.12,11.33,11.61,11.52,11.53,11.97,12.24,12.17,12.46,13.42,13.32,12.97,13.12,12.67,11.52,11.27,11.66,11.98,12.33,12.08,12.66,12.63,12.38,12.97,13.27,12.84,13.78},
High={11.46,11.45,11.36,11.29,11.32,11.85,11.95,12.82,12.72,12.47,12.21,12.32,12.12,11.8,12.25,12.2,11.62,11.21,11.27,11.56,11.62,11.51,11.5,12.18,11.97,12.35,13.32,13.11,12.88,13.37,14.36,14.01,14.07,14.32,13.72,13.92,13.35,13.84,13.71,14.52,14.12,13.47,13.38,13.24,11.7,11.85,11.62,11.74,12.12,12.72,12.66,12.37,11.87,11.6,11.67,11.65,11.67,11.81,12.07,11.95,11.92,11.65,12,11.89,11.85,11.77,11.42,11.06,11.19,11.06,11.62,11.82,11.55,11.35,11.91,11.86,11.72,12.46,12.37,12.33,12.75,13.48,13.95,13.47,13.81,13.62,12.67,12.03,11.8,12.14,12.73,12.61,13.02,12.76,13.12,13.32,13.22,13.72,13.41,13.78},
Low={11.24,11.22,10.77,10.73,10.99,11.13,11.55,11.55,12.43,11.77,11.74,11.85,11.3,11.42,11.58,11.62,10.89,10.93,10.91,11.17,11.31,11.23,11.07,11.22,11.47,11.77,11.99,12.49,12.18,12.38,13.06,13.47,13.48,13.42,13.17,12.88,12.77,13.22,13.34,13.07,13.35,13.17,12.76,11.62,11.04,11.22,11.09,11.36,11.51,11.78,12.18,11.88,11.23,11.22,11.22,11.47,11.39,11.33,11.76,11.65,11.37,10.96,11.59,11.53,11.53,11.23,10.77,10.52,10.62,10.73,11.13,11.28,10.92,11.12,11.2,11.41,11.47,11.52,11.87,12.01,11.98,12.38,12.93,12.97,12.97,12.73,11.83,11.07,11.22,11.56,11.95,11.99,12.02,12.12,12.61,12.38,12.88,12.72,11.8,13.78},
Close={11.3,11.23,11.3,11.03,11.22,11.82,11.67,12.81,12.47,11.85,12.08,12.17,11.47,11.58,12.07,11.67,11.1,10.96,11.27,11.55,11.37,11.5,11.3,11.6,11.93,12.17,12.88,12.71,12.37,13.25,13.56,13.74,13.93,13.54,13.67,12.95,13.17,13.47,13.4,13.97,13.37,13.39,12.91,11.72,11.56,11.22,11.52,11.71,11.94,12.42,12.3,12.01,11.35,11.5,11.51,11.59,11.59,11.8,11.86,11.75,11.48,11.63,11.77,11.6,11.73,11.32,10.78,10.8,11.08,10.81,11.4,11.58,11.13,11.29,11.85,11.62,11.59,12.19,12.2,12.07,12.49,13.48,13.37,13.02,13.33,12.8,11.88,11.27,11.67,11.95,12.46,12.16,12.66,12.37,12.7,13.02,13.21,12.86,12.49,13.78},
Volume={460940,409390,868242,304560,545424,1381486,854432,4885342,2317778,3172790,2703254,2531752,2906142,993468,3767374,3136014,2473774,1079716,1224924,2025622,1582998,1394442,1214666,4055256,3641432,4774380,8829678,6160638,3010974,5705368,8627592,6678006,6198676,5751578,3505316,4162260,3943478,4836316,3786452,9633372,6613920,3802196,3970772,6602922,3227956,3791132,2446392,2265630,2794162,4068048,2567218,2163372,2099214,1098580,1161420,1216700,1017686,2220170,1739452,1376504,1664300,1738906,1715056,1249046,1044570,1780954,2749416,1259522,2236046,1791796,4507168,4968324,8262372,3564744,6726214,5048050,2099790,9079268,4503520,3019110,5292396,9567366,8870928,3486200,5944328,4857974,4576814,7633000,4462754,3086054,4797280,3078718,4012382,2920860,4811484,6333502,3499082,7006026,8264128,0},
Amount={5207639,4639566.5,9622944,3361051.75,6125999,16022356,10019326,61007192,29059926,37968820,32436236,30671970,33786040,11494554,45404700,37276556,27766370,11952068,13637747,23038346,18095026,15918905,13774463,47413844,42797352,57956864,111937872,78768008,37402000,73857248,119357208,91915528,85710776,79580488,47221056,55942560,51636592,65499164,51284800,133716920,90527648,50694364,51552992,82448744,36697632,43896264,27621322,26372626,33184998,49950120,31777406,26143792,24092378,12599457,13332614,14075254,11724511,25935010,20696754,16202013,19440812,19701296,20236638,14606954,12258778,20290838,30153604,13490177,24649758,19362276,51176628,57680720,91563744,40108388,77665736,58685056,24335824,109772952,54597660,36495308,66035852,125757008,119281624,45986492,80049888,63531272,55268052,86825976,51731540,36674148,59519984,37819020,50307508,36127516,61551284,82752296,45749748,93176056,102288112,0},
}

--for k=1,#tbcd.Close do   print(tbcd.Close[k])  end   --测试输出
--for k=1,#tbcd["High"] do   print(tbcd["High"][k])  end   --测试输出

tbma=tbcd.Close
tbmb=CalcMA(tbcd.Close,30,5)

tbmc= tbmb or  {4,5,6,7,8}
for k=1,#tbmc do   print(k,'\t', tbmc[k])  end   --测试输出

end










--------------------------------------模块-------------------------------



function QueryCC(nowAccount)      --查询持仓
	local retMsg,msgErr = trade.StockQueryPosition(nowAccount);
	if retMsg ~= nil then
--		print('持仓是')
--		print(retMsg["RetData"]);
		SendToControl(retMsg["RetData"] or {}, 'cc_ret'); --发送持仓至main.lua cc_ret变量
		return retMsg["RetData"];  --返回持仓
	else
		SendToControl('持仓查询失败'..msgErr, 'ERROR');
		return {};
	end
end


function QueryCJ(nowAccount)      --查询成交(当日)
	local time = os.date("%Y%m%d");
	local retMsg,msgErr = trade.StockQueryExecution(nowAccount, nil, nil, nil, time, time);
	if retMsg ~= nil then
--		print('----成交-----')
--		print(retMsg);
		SendToControl(retMsg["RetData"] or {}, 'cj_ret');	--发送成交至main.lua cj_ret变量
		return retMsg["RetData"];  --返回成交
	else
		SendToControl('成交查询失败'..msgErr, 'ERROR');
	end
end


function QueryWT(nowAccount)      --查询委托(当日)
	local time = os.date("%Y%m%d");
	local retMsg,msgErr = trade.StockQueryEntrust(nowAccount,nil,nil,nil,time,time);
	if retMsg ~= nil then
--		print('委托查询成功！:::::::');
--		print(retMsg);
		SendToControl(retMsg["RetData"] or {}, 'entrust_ret');	--发送委托至main.lua entrust_ret变量
	else
		print('QueryWT',msgErr);
		SendToControl('委托查询失败'..msgErr, 'ERROR');
	end
end




--格式化日期
function FormatDate(olddate)
	local year = string.sub(olddate, 1, 4);
	local month = string.sub(olddate, 6, 7);
	local day = string.sub(olddate, 9, 10);
	local newdate = year .. month .. day;
	return newdate;
end


--计算N周期最高价
function  Highest(M,N,Price)                  --参数M表示计算的第一根K线至当前的根数，N是计算的最后一K线至当前的根数(不比较)，
	local hest=0;
	for i=N,M,1 do                            --循环次数(比较K根数): M-N+1 , N<M<=#-1  N为0时, 含自身 1,前一个(信号K线)
		hest=math.max(hest,Price[#Price-i]);   --区间循环, 从#-M到#-N的最高值, 即最近N期不比较, 到最近N-1期截止,
--@		print(i,Price[#Price-i],#Price-i);     --@
	end
	return hest;
end

--计算N周期最低价
function  Lowest(M,N,Price)                     --参数M表示计算的第一根K线至当前的根数，N是计算的最后一K线至当前的根数，
	local lest=Price[#Price-M];                 --M > N
	for i=N,M,1 do                              --从-M到-N，
		lest=math.min(lest,Price[#Price-i]);
	end
	return lest;
end

--将时间转换为秒
function timetosec(time)

	local day1 = {};
	day1.year,day1.month,day1.day,day1.hour,day1.sec = string.match(time,"(%d%d%d%d)(%d%d)(%d%d)(%d%d)(%d%d)");
	local lasttimesec = os.time(day1);
	return lasttimesec;
end

--打印信息--中间部--------
function SendInfoLog(msgtype, message)
	local msginfo = string.format("[%s]", message);
	local InfoLog = {};
	InfoLog["MsgInfo"] = msginfo;
	InfoLog["MsgType"] = msgtype;
	SendToControl(InfoLog,"InfoLog");
end


----------------------------------启动函数 init()------------------------------------------

function init()
	page.callAsy('onStart', {});                --< 异调 cl.lua onStart函数
	page.setPageRecvCallBack(onRecvCb);         --回调函数onRecvCb
    page.callAsy("OnStart",{})      --启动策略
    page.setPageRecvCallBack(HandleRecvCallBack);    --注册回调

end
init();


----------------------------------功能测试函数 显示log.html------------------------------------------

function ConsolePrint(lMsgType,lMsg,lTitle)
	local lCurTime = string.format("[%s]", os.date("%Y-%m-%d %H:%M:%S"));
	local lPrint   = string.format("%s[%s]%s: %s\r\n", lCurTime, lMsgType, lTitle, lMsg);
	div_log:append_html(lPrint);
end

--ConsolePrint("lMsgType","lMsg","lTitle") ; --

function logPrint(logMsg)                       --日志消息打印 logmsg变量 .index .msg
	if messageList == nil then messageList = {};  end
	table.insert(messageList, logMsg);
	local function sortIndex(a,b) return a.index>b.index; end
	table.sort(messageList, sortIndex);
	local tbhtml={};
	for k,v in pairs(messageList) do
		table.insert(tbhtml,string.format([[<tr><td>--&lt;%s</td></tr>]],v.msg));  -- &lt; html字符<
	end
	log.html = table.concat(tbhtml,'');
end


function t2s(_t)    --table转字符串(只取标准写法，以防止因系统的遍历次序导致ID乱序)  类似改写的print
    local Ret = "{"
    function dot2s(_i, _v)
        if "number" == type(_i) then
            Ret = Ret .. "[" .. _i .. "]="
            if "number" == type(_v) then
                Ret = Ret .. _v .. ","
            elseif "string" == type(_v) then
                Ret = Ret .. '"' .. _v .. '"' .. ","
            elseif "table" == type(_v) then
                Ret = Ret .. t2s(_v) .. ","
            else
                Ret = Ret .. "nil,"
            end
        elseif "string" == type(_i) then
            Ret = Ret .. '["' .. _i .. '"]='
            if "number" == type(_v) then
                Ret = Ret .. _v .. ","
            elseif "string" == type(_v) then
                Ret = Ret .. '"' .. _v .. '"' .. ","
            elseif "table" == type(_v) then
                Ret = Ret .. t2s(_v) .. ","
            else
                Ret = Ret .. "nil,"
            end
        end
    end
    table.foreach(_t, dot2s)
    Ret = Ret .. "}"
    return Ret
end

function test(Var,vName)                                   --test("123"); --> 123 仅作查看变量值调试用, 耗内存
	if type(Var)=="table" then Var=t2s(Var); end;
	local test={index=0, msg="", }                         --声明测试变量
	local daySec = os.date("*t", os.time())                --当日时间明细
	daySec.hour=0; daySec.min=0; daySec.sec=0;             --当日时分秒置0, 再求差值, 即为当日秒数
	local dSec=os.time()-os.time(daySec);                  --当天秒数 86400(总) --将时间转换为秒
	for i=1,10^7 do    end;                                --空循环, 取cpu毫秒时间差
	test.index= 86400*10^4-(dSec*10^4+os.clock()*10^2) ;   --先进先出
	if vName==nil then vName="Var"; end
	test.msg=string.format("[%s]:[%s]:[%s]", os.date("%H:%M:%S"), vName, Var);
	logPrint(test);
end

--	test("-------------------aTion 20140630----------------------");
--	local t1={1,2,{"a",3},"b", ["th"]="c", };
--	test(t1,"t1");  --> {[1]=1,[2]=2,[3]={[1]="a",[2]=3,},[4]="b",["th"]="c",}



function outFileX(data,fPathName)                    --输出变量到文件"d:\\test20140701.txt", 便于测试观测
	local today=os.date("%Y%m%d",os.time())
	fPathName=fPathName or "d:\\test"..today..".txt"   --默认"d:\\test(当前日期).txt"
	local f = assert(io.open(fPathName, "a+"));     --"d:\\test20140701.txt"
--	f:write(os.date("%Y%m%d %X",os.time()).."\n")   --输出三层, 第四层后合并成字符串输出

	if type(data)~="table" then f:write(data..'\n')
	else
		for k,v in pairs(data) do
			if type(v)~="table" then f:write(k..' '..v..'\n')
			else
				outFile(v)                         --递归循环, 但仅显示单层, 须重新对应理顺
			end
		end
	end
	f:close()
end

--local tData={1,2,{31,{321,322,{3231,3232,3233},324,{3251,3252,3253,3254}}},4,5};
--outFileX(tData)                                    --输出到文件"d:\\test20140701.txt"(默认)


function outFileY(data,fPathName)                            --输出日志文件(TQ)
  local today=os.date("%Y%m%d",os.time())
  fPathName=fPathName or "d:\\test"..today..".txt"         --默认"d:\\test(当前日期).txt"
  local f = assert(io.open(fPathName, "a+"));              --"d:\\test20140701.txt"
  local dayTime=os.date("%Y%m%d %X").."\t";
  f:write(dayTime..json.encode(data)..'\n')                --json字符串编码 数组和hash值混合编码, ?只能编数组
  f:close()
end



function outFile(data,fPathName)                    --输出变量到文件"d:\\test20140701.txt", 便于测试观测
	local today=os.date("%Y%m%d",os.time())
	fPathName=fPathName or "d:\\test"..today..".txt"   --默认"d:\\test(当前日期).txt"
	local f = assert(io.open(fPathName, "a+"));     --"d:\\test20140701.txt"
	f:write(os.date("%Y%m%d %X",os.time()).."\n")   --输出四层, 第五层后合并成字符串输出

	if type(data)~="table" then f:write(data..'\n')
	else
		for k,v in pairs(data) do
			if type(v)~="table" then f:write(k..' '..v..'\n')
			else
				for k1,v1 in pairs(v) do
					if  type(v1)~="table"  then	f:write(k..' '..k1..' '..v1..'\n')
					else
						for k2,v2 in pairs(v1) do
							if type(v2)~="table" then f:write(k..' '..k1..' '..k2..' '..v2..'\n')
							else
								for k3,v3 in pairs(v2) do
									if type(v3)~="table" then f:write(k..' '..k1..' '..k2..' '..k3..' '..v3..'\n')
									else f:write(k..' '..k1..' '..k2..' '..k3..' '..table.concat(v3,',')..'\n')
									end
								end
							end
						end
					end
				end
			end
		end
	end
	f:close()
end

--local tData={1,2,{31,{321,322,{3231,3232,3233},324,{3251,3252,3253,3254}}},4,5};
--outFile(tData)                                    --输出到文件"d:\\test20140701.txt"(默认)

function packQueryFunds(nowAccount)  --封装trade.StockQueryFunds 返回账户信息 处理返回["TotalAssets"]=0 问题的封装
  local retInfo, errorInfo = trade.StockQueryFunds(nowAccount,'SH'); --取得账户信息，填'SH'没有影响
  if retInfo ~= nil then
      if retInfo['TotalAssets']==0  then
        local ccTable = QueryCC(nowAccount); --查询持仓返回
      for k,v in pairs(ccTable) do
        retInfo['TotalAssets'] = retInfo['TotalAssets'] + v["OutMainCntryUIndex"];  --每只股票持仓市值相加
      end
      retInfo['TotalAssets'] = retInfo['TotalAssets'] + retInfo["FrozenValue"] + retInfo['AvailableValue'];
      return retInfo;  --股票市值+冻结资金+可用资金
    else
      return retInfo;
      end
  else
    SendInfoLog("Error", '账户: '..nowAccount..' 查询资金失败! '..tostring(errorInfo) );
    return ;
  end
end







