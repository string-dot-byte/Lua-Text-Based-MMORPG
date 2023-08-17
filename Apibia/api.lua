local util = require 'util'

local api = {
	Hostiles = {},
	Commands = {}
}

function api.Register()

end

function api.GetStat(val)
	return util.GetKeyValue('data.txt', val)
end

function api.CreateHostile(properties)
	local data = {
		Name = properties.Name,
		Health = properties.Health,
		Damage = properties.Damage,
    XP = properties.XP,
    Drops =  properties.Drops
	}

	table.insert(api.Hostiles, data)
	return data
end

function api.CheckForCommandInput()
	local input = io.read()
	
end

local symbol = util.GetKeyValue('Immutable/settings.txt', 'Symbol')
function api.SpawnHostile(name)
	local FoundHostileData
	for _, v in ipairs(api.Hostiles) do
		if v.Name == name then
			FoundHostileData = v
			break
		end
	end

	if not FoundHostileData then return end

	local HostileHealth = type(FoundHostileData.Health) == 'function' and FoundHostileData.Health() or FoundHostileData.Health

	print(symbol .. ' ' .. util.GetArticleWithNoun(FoundHostileData.Name, true) .. ' has spawned!')

	local Turn = 1
	while true do
		if Turn == 1 then
			local HostileDamage = type(FoundHostileData.Damage) == 'function' and FoundHostileData.Damage() or FoundHostileData.Damage

			util.WriteFileKey('data.txt', 'Health', tonumber(util.GetKeyValue('data.txt', 'Health'))-HostileDamage)
			print(symbol .. ' ' .. FoundHostileData.Name .. ' attacks you for ' .. HostileDamage .. ' damage!')

			if tonumber(util.GetKeyValue('data.txt', 'Health')) <= 0 then
				print(symbol .. ' R.I.P, you\'re dead dead!')
				break
			end
		else
			print(symbol .. ' Would you like to: fight, heal, check, or flee?')
			local response = io.read()
			
		end

		Turn = Turn == 1 and 0 or 1
	end
end


function api.Wait(x)
	os.execute("sleep " .. x)
end



return api