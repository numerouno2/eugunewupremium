local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/USERNAMEKAMU/REPOKAMU/main/GameList.lua"))()

local URL = Games[game.GameId]

if URL then
    loadstring(game:HttpGet(URL))()
else
    -- Game tidak terdaftar
    local gameId = tostring(game.GameId)
    local placeId = tostring(game.PlaceId)

    -- Coba pakai PlaceId juga
    URL = Games[game.PlaceId]
    if URL then
        loadstring(game:HttpGet(URL))()
    else
        warn("❌ Game tidak terdaftar!")
        warn("GameId: " .. gameId)
        warn("PlaceId: " .. placeId)
    end
end
