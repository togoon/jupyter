
package.path = package.path.. ';..\\?.lua'
package.cpath = package.cpath.. ';..\\?.so'

local ladd = require "add"
print(ladd.add(45, 5))

-- package.cpath = package.cpath.. ';/home/at/test/Algo/lua/add/?.so;'

-- local path = '/home/at/test/Algo/lua/add/add.so'
-- local f = assert(loadlib(path, "luaopen_add"))
-- f()
