temp = {}
stuff = {}
api = {
    addons = {},
    hostiles = {},
    materials = {},
    items = {},
    commands = {},
    shops = {},
    asSpawnHostileUpdate = function() end,
    postSpawnHostileUpdate = function() end,
    addToInv = function(m, n)
    	for _,v in pairs(api.materials) do
    		print(v)
    	end
        local t = {}
        for _,v in pairs(api.materials) do
            if v[1] == m then
                local file = io.open("inv.txt", "r")
                for line in file:lines() do
                    table.insert(t, line)
                end
                file:close()
                local counter = 0
                for each, val in pairs(t) do
                    if string.match(val, m) then
                        local num = ""
                        for i in string.gmatch(t[each], "%d+") do
                            num = i
                        end
                        t[each] = m .. " " .. num + n
                        local file = io.open("inv.txt", "w")
                        for eachkk, eachvv in pairs(t) do
                            file:write(eachvv .. "\n")
                        end
                        file:close()
                        t = {}
                    end
                end
            end
        end
    end,
    takeFromInv = function(m, n)
        temp = {}
        local file = io.open("inv.txt", "r")
        for line in file:lines() do
            table.insert(temp, line)
        end
        file:close()
        for k, v in pairs(temp) do
            local counter = 0
            if string.match(v, m) then
                local tnum = ""
                for i in string.gmatch(v, "%d+") do
                    tnum = tnum .. i
                end
                temp[k] = m .. " " .. tonumber(tnum) - n
                if n > tonumber(tnum) then
                    print("Taking value is too high. Must be equal to or lower than.")
                    os.exit()
                end
                local file = io.open("inv.txt", "w")
                for _, v in pairs(temp) do
                    file:write(v .. "\n")
                end
                file:flush()
                file:close()
            else
                counter = counter + 1
            end
            if counter == #temp then
                print("")
            end
        end
        temp = {}
    end,
    changeStat = function(s, n)
        local file = io.open("data.txt", "r")
        for line in file:lines() do
            table.insert(temp, line)
        end
        for k, v in pairs(temp) do
        	local true_line = ""
        	for i in string.gmatch(v, "%a+") do
        		true_line = true_line..i
        	end
            if true_line == s then
                temp[k] = s .. " " .. n
            end
        end
        file:close()
        os.remove("data.txt")
        local file = io.open("data.txt", "w")
        for _, v in pairs(temp) do
            file:write(v .. "\n")
        end
        file:flush()
        file:close()
        temp = {}
    end,
    getStat = function(s)
        stuff = {}
        for line in io.lines("data.txt") do
            table.insert(stuff, line)
        end
        for _, v in pairs(stuff) do
            if string.match(v, s) then
                for i in string.gmatch(v, "%d+") do
                    return tonumber(i)
                end
            end
        end
    end,
    wait = function(x)
        os.execute("sleep " .. x)
    end,
    createHostile = function(properties)
        local data = {}
        data.name = properties.name
        data.health = properties.health
        data.reward = properties.reward
        data.damage = properties.attack
        data.xpgive = properties.xp
        data.drops = properties.drops
        table.insert(api.hostiles, data)
        return data
    end,
    addCommand = function(t, f)
        if t.aliases ~= nil then
            table.insert(api.commands, {t.name, t.usage, t.aliases, f})
        else
            table.insert(api.commands, {t.name, t.usage, f})
        end
    end,
    checkForCommandInput = function()
        args = {}
        local cc = 0
        local input = io.read()
        for i in string.gmatch(input, "%S+") do
            table.insert(args, i)
        end
        for k,v in pairs(api.commands) do
            if v[4] ~= nil then
                if v[2] == args[1] then
                    v[4]()
                    do return end
                else
                    for first, second in pairs(v[3]) do
                        if second == args[1] then
                            v[4]()
                        else
                            cc = cc + 1
                            if cc == #v[3] then
                                print("Unrecognized command.")
                            end
                        end
                    end
                end
            end
        end
        if input == ".exit" then
            os.exit()
        end
    end,
    doStat = function(s, o, n)
        local file = io.open("data.txt", "r")
        for line in file:lines() do
            table.insert(temp, line)
        end
        for k, v in pairs(temp) do
        	local real_line = ""
        	for i in string.gmatch(temp[k], "%a+") do
        		real_line = real_line..i
        	end
            if real_line == s then
                local test = ""
                for i in string.gmatch(v, "%d+") do
                    test = i
                end
                if o == "+" then
                    temp[k] = s .. " " .. test + n
                elseif o == "-" then
                    temp[k] = s .. " " .. test - n
                elseif o == "/" then
                    temp[k] = s .. " " .. test / n
                elseif o == "*" then
                    temp[k] = s .. " " .. test * n
                end
            end
        end
        file:close()
        os.remove("data.txt")
        local file = io.open("data.txt", "w")
        for _, v in pairs(temp) do
            file:write(v .. "\n")
        end
        file:flush()
        file:close()
        temp = {}
    end,
    spawnHostile = function(n)
		local _symbol = "|>"
        api.asSpawnHostileUpdate()
        for k, v in pairs(api.hostiles) do
            if v.name == n then
                local shealth = api.getStat("StartingHealth")
                local hvalue = v.health
                local turn_counter = 1
                print(_symbol .. " A " .. v.name .. " has spawned!")
                while hvalue ~= 0 do
                    if turn_counter == 1 then
                        print(_symbol .. " " .. v.name .. " attacks you for " .. v.damage .. " damage!")
                        api.doStat("health", "-", v.damage)
                        if math.floor(api.getStat("health")) == 0 then
                            print(_symbol .. " R.I.P, your dead!")
                            api.changeStat("health", shealth)
                            do return end
                        end
                        print(_symbol .. " You have " .. api.getStat("health") .. " health left!")
                        turn_counter = 0
                    elseif turn_counter == 0 then
                        print(_symbol .. " Would you like to: fight, heal, check, or flee?")
                        local response = io.read()
                        if response == "fight" then
                            hvalue = hvalue - api.getStat("attack")
                            if hvalue <= 0 then
                                api.doStat("kills", "+", 1)
                                print(_symbol .. " " .. v.name .. " has been defeated!")
                                print(_symbol .. " +" .. v.reward .. " money, +" .. v.xpgive .. " XP!")
                                if v.drops ~= nil then
                                    for dropk, dropv in pairs(v.drops) do
                                        api.addToInv(dropv, 1)
                                        print(_symbol .. " You have been rewarded with a: " .. dropv)
                                    end
                                end
                                api.doStat("money", "+", v.reward)
                                api.doStat("xp", "+", v.xpgive)
                                if tonumber(api.getStat("xp")) >= tonumber(api.getStat("xpRequirement")) then
    								local levels = tonumber(api.getStat("xp")) / tonumber(api.getStat("xpRequirement"))
    								local remainder = tonumber(api.getStat("xp")) % tonumber(api.getStat("xpRequirement"))
    								api.doStat("level", "+", math.floor(levels))
    								api.changeStat("xp", remainder)
                                end
                                do return end
                            end
                            print(_symbol .. " " .. v.name .. " has " .. hvalue .. " health left!")
                            turn_counter = 1
                        elseif response == "heal" then
                            print(_symbol .. " " .. api.getStat("defense") .. " health has been restored!")
                            api.doStat("health", "+", api.getStat("defense"))
                            turn_counter = 1
                        elseif response == "check" then
                            print(_symbol .. " " .. v.name .. ": " .. hvalue .. " health remaining, " .. v.damage .. " attack")
                            turn_counter = 1
                        elseif response == "flee" then
                            math.randomseed(os.time())
                            math.random(); math.random(); math.random();
                            local rn = math.random(0, 10)
                            if rn < 5 then
                                print(_symbol .. " You escaped!")
                                do return end
                            else
                                print(_symbol .. " You got away! For half a second... :(")
                                turn_counter = 1
                            end
                        end
                    end
                end
            end
        end
        api.postSpawnHostileUpdate()
    end,
    whisper = function(txt)
        print("SELF " .. _symbol .. " " .. txt)
    end,
    createMaterial = function(t)
        local data = {}
        data.name = t.name
        data.rarity = t.rarity
        table.insert(api.materials, {t.name, t.rarity})
    end,    
    playerHas = function(m, am)
        local file = io.open("inv.txt", "r")
        local ic = 0
        for line in file:lines() do
            if string.match(line, m) then
                local findnum = ""
                for i in string.gmatch(line, "%d") do
                    findnum = findnum .. i
                end             
                if tonumber(findnum) >= am then
                    return true
                else
                    return false
                end
            end
        end
        file:close()
    end,
    getMaterial = function(m)
        local file = io.open("inv.txt", "r")
        local ic = 0
        for line in file:lines() do
            if string.match(line, m) then
                local findnum = ""
                for i in string.gmatch(line, "%d") do
                    findnum = findnum .. i
                end             
                return tonumber(findnum)
            end
        end
        file:close()
    end,
    checkXP = function()
    	if tonumber(api.getStat("xp")) >= tonumber(api.getStat("xpRequirement")) then
    		local levels = tonumber(api.getStat("xp")) / tonumber(api.getStat("xpRequirement"))
    		local remainder = tonumber(api.getStat("xp")) % tonumber(api.getStat("xpRequirement"))
    		api.doStat("level", "+", math.floor(levels))
    		api.changeStat("xp", remainder)
    	else
    		return false
    	end
    end,
    createShop = function(t)
    	table.insert(api.shops, {t.name, t.items})
    end,
    openShop = function(n)
    	for k,v in pairs(api.shops) do
    		if v[1] == n then
    			for item, price in pairs(v[2]) do
    				print("Item: " .. item .. " Price: " .. price)
    			end
    			print("What would you like to purchase? (TYPE 0 TO EXIT)")
    			local purchaseID = io.read()
    			local counter = 0
    			for id, cost in pairs(v[2]) do
    				if purchaseID == id then
    					if api.getStat("money") >= cost then
    						if api.playerHas(id, 0) then
    							print("How many would you like?")
    							local quantity = io.read()
    							if quantity * cost <= api.getStat("money") then
    								api.doStat("money", "-", quantity * cost)
    								api.addToInv(id, quantity)
    								print("Success!")
    								do return end
    							else
    								print("You do not have enough money. :(")
    								do return end
    							end
    						else
    							print("That does not exist! Please contact the developer of this game.")
    							do return end
    						end
    					else
    						print("You cannot even afford one of those! (Get more money)")
    						do return end
    					end
    				else
    					if purchaseID == "0" then
    						do return end
    					else
    						counter = counter + 1
    						if counter == #v[2] then
    							print("This is not the message you were looking for. (Item not found)")
    							do return end
    						end
    					end
    				end
    			end
    		end
    	end
    end,
    register = function()
        local file = io.open("data.txt", "r")
        if file then
            file:close()
        else
            local file = io.open("data.txt", "w")
            file:write("money 0 \n")
            file:write("health 0 \n")
            file:write("attack 1 \n")
            file:write("defense 1 \n")
            file:write("xp 0 \n")
            file:write("level 0 \n")
            file:write("kills 0 \n")
            file:write("StartingHealth 5 \n")
            file:write("xpRequirement 100 \n")
            file:close()
            api.changeStat("health", api.getStat("StartingHealth"))
        end
        local file = io.open("inv.txt", "r")
        if file then
            for k,v in pairs(api.materials) do
                if string.match(file:read("*a"), v[1]) then
                	do return end
                else
                    local file = io.open("inv.txt", "a")
                    file:write(v[1].." 0".."\n")
                end
            end
        else
            local file = io.open("inv.txt", "w")
            file:close()
        end
        file:close()
    end
}
