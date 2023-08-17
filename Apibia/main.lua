local util = require 'util'
local api = require'api'

--util.WriteFileKey('test.txt', 'egg', 2)

api.CreateHostile({
		Name = 'Demon',
		Health = 2,
		Damage = 1,
    XP = 5,
    Drops =  nil
	})

api.SpawnHostile('Demon')