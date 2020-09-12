require "api"
api.register()
os.execute("clear")
---------------------
--//Setup\\--

api.createHostile(
  {
  name="Monster",
  health=10,
  reward=50,
  attack=1,
  xp=5
})

api.addCommand({name="UserStats",usage="Stats",aliases={"st", "stt", "stats", "info"}}, function()
   print(string.format("\nYou have %d money,\n%d/%d HP,\n%d damage per hit,\n%d Defense,\n%d/%d XP,\nLevel %d,\n%d kills\n", api.getStat("money"), api.getStat("health"), api.getStat("StartingHealth"), api.getStat("attack"), api.getStat("defense"), api.getStat("xp"), api.getStat("xpRequirement"), api.getStat("level"), api.getStat("kills")))
end)

----------------------
--//Running Game\\--
os.execute("clear")

api.checkForCommandInput()

api.spawnHostile("Monster")
