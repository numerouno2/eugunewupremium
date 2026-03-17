-- ══════════════════════════════════════════════════════
--          EUGUNEWU PREMIUM - ANIMATED LOADER
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ═══ CLEANUP OLD GUI ═══
if playerGui:FindFirstChild("EugunewuLoader") then
    playerGui:FindFirstChild("EugunewuLoader"):Destroy()
end

-- ═══ CREATE UI ═══
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EugunewuLoader"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- Dark overlay
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 1
Overlay.BorderSizePixel = 0
Overlay.ZIndex = 100
Overlay.Parent = ScreenGui

-- Main container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(0, 420, 0, 220)
Container.Position = UDim2.new(0.5, 0, 0.5, 0)
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ZIndex = 101
Container.Parent = ScreenGui

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 14)
ContainerCorner.Parent = Container

-- Container glow border
local ContainerStroke = Instance.new("UIStroke")
ContainerStroke.Color = Color3.fromRGB(100, 60, 255)
ContainerStroke.Thickness = 2
ContainerStroke.Transparency = 1
ContainerStroke.Parent = Container

-- Shadow behind container
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.ZIndex = 100
Shadow.Image = "rbxassetid://6015897843"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 1
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
Shadow.Parent = Container

-- ═══ LOGO ICON (Diamond shape) ═══
local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 50, 0, 50)
LogoFrame.Position = UDim2.new(0.5, 0, 0.08, 0)
LogoFrame.AnchorPoint = Vector2.new(0.5, 0)
LogoFrame.BackgroundColor3 = Color3.fromRGB(100, 60, 255)
LogoFrame.BackgroundTransparency = 1
LogoFrame.Rotation = 45
LogoFrame.ZIndex = 102
LogoFrame.Parent = Container

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 8)
LogoCorner.Parent = LogoFrame

local LogoGradient = Instance.new("UIGradient")
LogoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 80, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255))
}
LogoGradient.Rotation = 45
LogoGradient.Parent = LogoFrame

local LogoIcon = Instance.new("TextLabel")
LogoIcon.Size = UDim2.new(1, 0, 1, 0)
LogoIcon.BackgroundTransparency = 1
LogoIcon.Text = "E"
LogoIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoIcon.TextTransparency = 1
LogoIcon.Font = Enum.Font.GothamBlack
LogoIcon.TextSize = 22
LogoIcon.Rotation = -45
LogoIcon.ZIndex = 103
LogoIcon.Parent = LogoFrame

-- ═══ TITLE ═══
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0.38, 0)
Title.BackgroundTransparency = 1
Title.Text = "EUGUNEWU PREMIUM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.ZIndex = 102
Title.Parent = Container

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = Color3.fromRGB(100, 60, 255)
TitleStroke.Thickness = 1
TitleStroke.Transparency = 1
TitleStroke.Parent = Title

-- ═══ SUBTITLE ═══
local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, 0, 0, 18)
Subtitle.Position = UDim2.new(0, 0, 0.52, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Premium Script Loader"
Subtitle.TextColor3 = Color3.fromRGB(150, 140, 200)
Subtitle.TextTransparency = 1
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 13
Subtitle.ZIndex = 102
Subtitle.Parent = Container

-- ═══ LOADING BAR BACKGROUND ═══
local LoadBarBG = Instance.new("Frame")
LoadBarBG.Size = UDim2.new(0.75, 0, 0, 5)
LoadBarBG.Position = UDim2.new(0.125, 0, 0.72, 0)
LoadBarBG.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
LoadBarBG.BackgroundTransparency = 1
LoadBarBG.BorderSizePixel = 0
LoadBarBG.ZIndex = 102
LoadBarBG.Parent = Container

local LoadBarBGCorner = Instance.new("UICorner")
LoadBarBGCorner.CornerRadius = UDim.new(1, 0)
LoadBarBGCorner.Parent = LoadBarBG

-- Loading bar fill
local LoadBarFill = Instance.new("Frame")
LoadBarFill.Size = UDim2.new(0, 0, 1, 0)
LoadBarFill.BackgroundColor3 = Color3.fromRGB(130, 80, 255)
LoadBarFill.BackgroundTransparency = 1
LoadBarFill.BorderSizePixel = 0
LoadBarFill.ZIndex = 103
LoadBarFill.Parent = LoadBarBG

local LoadBarFillCorner = Instance.new("UICorner")
LoadBarFillCorner.CornerRadius = UDim.new(1, 0)
LoadBarFillCorner.Parent = LoadBarFill

local BarGradient = Instance.new("UIGradient")
BarGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 60, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))
}
BarGradient.Parent = LoadBarFill

-- ═══ STATUS TEXT ═══
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 18)
Status.Position = UDim2.new(0, 0, 0.83, 0)
Status.BackgroundTransparency = 1
Status.Text = ""
Status.TextColor3 = Color3.fromRGB(170, 165, 210)
Status.TextTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 11
Status.ZIndex = 102
Status.Parent = Container

-- ═══ PARTICLES (floating dots) ═══
local particles = {}
for i = 1, 12 do
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
    dot.Position = UDim2.new(math.random() * 0.9 + 0.05, 0, math.random() * 0.8 + 0.1, 0)
    dot.BackgroundColor3 = Color3.fromRGB(130, 80, 255)
    dot.BackgroundTransparency = 1
    dot.BorderSizePixel = 0
    dot.ZIndex = 102
    dot.Parent = Container
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    
    table.insert(particles, dot)
end

-- ═══ TWEEN HELPER ═══
local function tween(obj, props, duration, style, direction)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(
            duration or 0.5,
            style or Enum.EasingStyle.Quint,
            direction or Enum.EasingDirection.Out
        ),
        props
    )
    t:Play()
    return t
end

local function setProgress(pct, text, col)
    if text then Status.Text = text end
    if col then tween(Status, {TextColor3 = col}, 0.3) end
    tween(LoadBarFill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.6, Enum.EasingStyle.Quad)
end

-- ═══ ANIMATE PARTICLES ═══
local particleConnection
particleConnection = RunService.Heartbeat:Connect(function(dt)
    for _, dot in ipairs(particles) do
        if dot.BackgroundTransparency < 1 then
            dot.Position = UDim2.new(
                dot.Position.X.Scale,
                dot.Position.X.Offset,
                dot.Position.Y.Scale - dt * 0.02,
                0
            )
            if dot.Position.Y.Scale < 0 then
                dot.Position = UDim2.new(
                    math.random() * 0.9 + 0.05, 0,
                    1, 0
                )
            end
        end
    end
end)

-- ══════════════════════════════════════════════════════
--              ANIMATION SEQUENCE START
-- ══════════════════════════════════════════════════════

-- Phase 1: Fade in overlay
tween(Overlay, {BackgroundTransparency = 0.4}, 0.6)
task.wait(0.4)

-- Phase 2: Container appear (scale effect)
Container.Size = UDim2.new(0, 380, 0, 200)
tween(Container, {BackgroundTransparency = 0, Size = UDim2.new(0, 420, 0, 220)}, 0.5, Enum.EasingStyle.Back)
tween(ContainerStroke, {Transparency = 0.5}, 0.5)
tween(Shadow, {ImageTransparency = 0.5}, 0.5)
task.wait(0.3)

-- Phase 3: Logo appear (spin in)
LogoFrame.Rotation = 0
tween(LogoFrame, {BackgroundTransparency = 0, Rotation = 45}, 0.6, Enum.EasingStyle.Back)
tween(LogoIcon, {TextTransparency = 0}, 0.4)
task.wait(0.3)

-- Phase 4: Title slide in
Title.Position = UDim2.new(0, 0, 0.42, 0)
tween(Title, {TextTransparency = 0, Position = UDim2.new(0, 0, 0.38, 0)}, 0.5)
tween(TitleStroke, {Transparency = 0.6}, 0.5)
task.wait(0.2)

-- Phase 5: Subtitle fade
tween(Subtitle, {TextTransparency = 0}, 0.4)
task.wait(0.2)

-- Phase 6: Loading bar appear
tween(LoadBarBG, {BackgroundTransparency = 0}, 0.3)
tween(LoadBarFill, {BackgroundTransparency = 0}, 0.3)
tween(Status, {TextTransparency = 0}, 0.3)
task.wait(0.2)

-- Phase 7: Show particles
for _, dot in ipairs(particles) do
    task.defer(function()
        task.wait(math.random() * 0.5)
        tween(dot, {BackgroundTransparency = math.random() * 0.4 + 0.5}, 0.5)
    end)
end

-- ══════════════════════════════════════════════════════
--                  LOADING LOGIC
-- ══════════════════════════════════════════════════════

setProgress(0.15, "⚙️  Initializing loader...")
task.wait(0.6)

setProgress(0.30, "📡  Fetching script database...")
task.wait(0.4)

-- Load game list
local success, Games = pcall(function()
    return loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/numerouno2/eugunewupremium/refs/heads/main/localgame.lua"
    ))()
end)

if not success then
    setProgress(1, "❌  Failed to fetch database!", Color3.fromRGB(255, 80, 80))
    task.wait(2)
    
    -- Fade out
    tween(Overlay, {BackgroundTransparency = 1}, 0.5)
    tween(Container, {BackgroundTransparency = 1}, 0.5)
    tween(ContainerStroke, {Transparency = 1}, 0.3)
    tween(Shadow, {ImageTransparency = 1}, 0.3)
    tween(Title, {TextTransparency = 1}, 0.3)
    tween(TitleStroke, {Transparency = 1}, 0.3)
    tween(Subtitle, {TextTransparency = 1}, 0.3)
    tween(LogoFrame, {BackgroundTransparency = 1}, 0.3)
    tween(LogoIcon, {TextTransparency = 1}, 0.3)
    tween(LoadBarBG, {BackgroundTransparency = 1}, 0.3)
    tween(LoadBarFill, {BackgroundTransparency = 1}, 0.3)
    tween(Status, {TextTransparency = 1}, 0.3)
    for _, dot in ipairs(particles) do
        tween(dot, {BackgroundTransparency = 1}, 0.3)
    end
    task.wait(0.6)
    particleConnection:Disconnect()
    ScreenGui:Destroy()
    return
end

setProgress(0.50, "🔍  Searching for game script...")
task.wait(0.5)

local URL = Games[game.GameId]
local scriptFound = false

if URL then
    scriptFound = true
    setProgress(0.70, "✅  Game detected! (GameId match)")
    task.wait(0.5)
else
    setProgress(0.55, "🔄  Trying PlaceId lookup...")
    task.wait(0.4)
    
    URL = Games[game.PlaceId]
    if URL then
        scriptFound = true
        setProgress(0.70, "✅  Game detected! (PlaceId match)")
        task.wait(0.5)
    end
end

if scriptFound then
    -- ═══ SUCCESS ═══
    setProgress(0.85, "⚡  Downloading script...")
    task.wait(0.5)
    
    setProgress(1.0, "🚀  Launching Eugunewu Premium!")
    tween(ContainerStroke, {Color = Color3.fromRGB(80, 255, 120), Transparency = 0.2}, 0.4)
    tween(LoadBarFill, {BackgroundColor3 = Color3.fromRGB(80, 255, 120)}, 0.3)
    task.wait(1)
    
    -- ═══ FADE OUT ANIMATION ═══
    -- Title flies up
    tween(Title, {TextTransparency = 1, Position = UDim2.new(0, 0, 0.30, 0)}, 0.4)
    tween(TitleStroke, {Transparency = 1}, 0.3)
    tween(Subtitle, {TextTransparency = 1}, 0.3)
    task.wait(0.1)
    
    -- Logo spins out
    tween(LogoFrame, {BackgroundTransparency = 1, Rotation = 405}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tween(LogoIcon, {TextTransparency = 1}, 0.3)
    task.wait(0.1)
    
    -- Bar and status fade
    tween(LoadBarBG, {BackgroundTransparency = 1}, 0.3)
    tween(LoadBarFill, {BackgroundTransparency = 1}, 0.3)
    tween(Status, {TextTransparency = 1}, 0.3)
    task.wait(0.1)
    
    -- Particles fade
    for _, dot in ipairs(particles) do
        tween(dot, {BackgroundTransparency = 1}, 0.3)
    end
    task.wait(0.2)
    
    -- Container shrink out
    tween(Container, {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 380, 0, 200)
    }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tween(ContainerStroke, {Transparency = 1}, 0.3)
    tween(Shadow, {ImageTransparency = 1}, 0.3)
    task.wait(0.3)
    
    -- Overlay fade
    tween(Overlay, {BackgroundTransparency = 1}, 0.5)
    task.wait(0.5)
    
    -- Cleanup
    particleConnection:Disconnect()
    ScreenGui:Destroy()
    
    -- ═══ EXECUTE SCRIPT ═══
    loadstring(game:HttpGet(URL))()
    
else
    -- ═══ GAME NOT FOUND ═══
    setProgress(1.0, "❌  Game tidak terdaftar!", Color3.fromRGB(255, 80, 80))
    tween(ContainerStroke, {Color = Color3.fromRGB(255, 60, 60), Transparency = 0.2}, 0.4)
    task.wait(1.5)
    
    local gameId = tostring(game.GameId)
    local placeId = tostring(game.PlaceId)
    Status.Text = "GameId: " .. gameId .. "  |  PlaceId: " .. placeId
    warn("❌ Game tidak terdaftar!")
    warn("GameId: " .. gameId)
    warn("PlaceId: " .. placeId)
    task.wait(3)
    
    -- Fade out
    tween(Title, {TextTransparency = 1}, 0.3)
    tween(TitleStroke, {Transparency = 1}, 0.3)
    tween(Subtitle, {TextTransparency = 1}, 0.3)
    tween(LogoFrame, {BackgroundTransparency = 1}, 0.3)
    tween(LogoIcon, {TextTransparency = 1}, 0.3)
    tween(LoadBarBG, {BackgroundTransparency = 1}, 0.3)
    tween(LoadBarFill, {BackgroundTransparency = 1}, 0.3)
    tween(Status, {TextTransparency = 1}, 0.3)
    for _, dot in ipairs(particles) do
        tween(dot, {BackgroundTransparency = 1}, 0.3)
    end
    task.wait(0.2)
    tween(Container, {BackgroundTransparency = 1}, 0.4)
    tween(ContainerStroke, {Transparency = 1}, 0.3)
    tween(Shadow, {ImageTransparency = 1}, 0.3)
    task.wait(0.3)
    tween(Overlay, {BackgroundTransparency = 1}, 0.5)
    task.wait(0.5)
    
    particleConnection:Disconnect()
    ScreenGui:Destroy()
end
