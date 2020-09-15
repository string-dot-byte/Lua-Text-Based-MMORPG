**Information**
This text based MMORPG was developped by the following Lua developers: 
Daark#7373
Viken#0243

This project is open sourced and can be used in any way. This project is no longer being worked on as there isn't much to add into updates. Note that **there are multiple bugs**, but I don't have the motivation to fix them.


**Usage**
api file has all the functions you need to run your text based MMORPG. Start your code in main.lua such indicated under the documentation in this file.


**Documentation**

api.asSpawnHostileUpdate() -- Optional, must be defined if wanted.

api.postSpawnHostileUpdate() -- Also optional.

api.addToInv(material, quantity) -- Adds the given number of material to the player.

api.takeFromInv(material, quantity) -- Takes the number of the material away from the player.

api.getMaterial(material) -- Returns the amount of the material in your inventory.

api.changeStat(stat, number) -- Sets the chosen stat to the number.

api.getStat(stat) -- Returns the given stats value.

api.wait(number) -- Waits for the given number in seconds before continuing the code.

api.createHostile({name="name",health=1,reward=100,attack=4,xp=1,{"drop 1"}}) -- The hostiles drops are optional.

api.addCommand({name="name",usage="test",aliases={"t"}}, function() -- Aliases table are optional.
  print("you ran the command")
end)

api.checkForCommandInput() -- Allows the user to run a command.

api.doStat(stat, math_operator, number) -- Modifies the given stat by the number using the given math operator.

api.spawnHostile(hostile_name) -- Spawns the given hostile for the player to fight.

api.whisper(text) -- Prints text indicating the user was talking to themselves in a roleplay sense.

api.createMaterial({name="name",rarity=1}) -- Creates an item/material with the given name and rarity.

api.playerHas(material_name) -- Returns true if the user has at least one of the given material, returns false if they dont.

api.register() -- No arguments, recommended to be the second line of code after requiring the api. Can break your game if you dont call it at the start.



api.createShop({name = "mainshop1", items = {["yeet"] = 5, ["lol"] = 2}}) -- Note that the items must exist as materials to properly work.

api.openShop("mainshop1")



**How to start your game's code**

require "api"
api.register()
api.createHostile(
    {
        name = "Test",
        health = 5,
        reward = 100,
        attack = 1,
        xp = 100
    }
)
api.spawnHostile("Test")
