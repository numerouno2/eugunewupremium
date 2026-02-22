local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/numerouno2/eugunewupremium/refs/heads/main/localgame.lua"))()

local URL = Games[game.GameId]

if URL then
  loadstring(game:HttpGet(URL))()
end
