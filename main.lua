--[[
    ╔══════════════════════════════════════════╗
    ║           EUGUNEWU HUB LOADER           ║
    ║         Premium Script Loader            ║
    ╚══════════════════════════════════════════╝
]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gameId = game.PlaceId

-- Games Database
local Games = {
    [83369512629707] = {
        url = "https://raw.githubusercontent.com/numerouno2/gamesdump/refs/heads/main/sawahindo.lua",
        name = "Sawah Indo"
    },
    [131848958487439] = {
        url = "https://raw.githubusercontent.com/numerouno2/gamesdump/refs/heads/main/ruangriung.lua",
        name = "Ruang Riung"
    },
    [8356562067] = {
        url = "https://raw.githubusercontent.com/numerouno2/gamesdump/refs/heads/main/indovoice.lua",
        name = "Indo Voice"
    },
    [85695526103771] = {
        url = "https://raw.githubusercontent.com/numerouno2/gamesdump/refs/heads/main/danauindo.lua",
        name = "Danau Voice"
    },
    [130342654546662] = {
        url = "https://raw.githubusercontent.com/numerouno2/gamesdump/refs/heads/main/Sambungkata.lua",
        name = "Sambung Kata"
    },
    [93978595733734] = {
        url = "https://raw.githubusercontent.com/numerouno2/gamesdump/refs/heads/main/ViolenceDistrict.lua",
        name = "Violence District"
    },
    [72774564502867] = {
        url = "https://raw.githubusercontent.com/numerouno2/gamesdump/refs/heads/main/Lengkapikata.lua",
        name = "Lengkapi Kata"
    },
    [78632820802305] = {
        url = "https://raw.githubusercontent.com/numerouno2/gamesdump/refs/heads/main/IndoStrike.lua",
        name = "Indo Strike"
    },
}

local currentGame = Games[gameId]
local gameName = currentGame and currentGame.name or "Unknown"
local scriptUrl = currentGame and currentGame.url or nil

-- Cleanup
local oldGui = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("EugunewuHub")
if oldGui then oldGui:Destroy() end

-- ════════════════════════════════════
--     PRE-FETCH SCRIPT IMMEDIATELY
-- ════════════════════════════════════
local scriptContent = nil
local compiledFunc = nil
local fetchDone = false
local fetchFailed = false
local fetchErrorMsg = ""

if scriptUrl then
    task.spawn(function()
        local ok, err = pcall(function()
            scriptContent = game:HttpGet(scriptUrl, true)
        end)
        if not ok or not scriptContent or #scriptContent < 10 then
            fetchFailed = true
            fetchErrorMsg = "Download failed"
        else
            local func, cerr = loadstring(scriptContent)
            if func then
                compiledFunc = func
            else
                fetchFailed = true
                fetchErrorMsg = "Compile error"
                warn("[EUGUNEWU HUB] Compile Error: " .. tostring(cerr))
            end
        end
        fetchDone = true
    end)
end

-- ════════════════════════════════════
--          CREATE GUI
-- ════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EugunewuHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = player.PlayerGui
end

-- Helpers
local activeConnections = {}
local activeTweens = {}
local alive = true

local function tw(obj, props, duration, style, direction)
    style = style or Enum.EasingStyle.Quint
    direction = direction or Enum.EasingDirection.Out
    local t = TweenService:Create(obj, TweenInfo.new(duration, style, direction), props)
    t:Play()
    table.insert(activeTweens, t)
    return t
end

local function cleanupAll()
    alive = false
    for _, c in ipairs(activeConnections) do pcall(function() c:Disconnect() end) end
    for _, t in ipairs(activeTweens) do pcall(function() t:Cancel() end) end
    activeConnections = {}
    activeTweens = {}
end

local function createCorner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function createStroke(p, col, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = col or Color3.fromRGB(130, 80, 255)
    s.Thickness = thick or 1.5
    s.Transparency = trans or 0.4
    s.Parent = p
    return s
end

-- ════════════════════════════════════
--          OVERLAY
-- ════════════════════════════════════
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 1
Overlay.BorderSizePixel = 0
Overlay.ZIndex = 1
Overlay.Parent = ScreenGui

-- ════════════════════════════════════
--          MAIN FRAME
-- ════════════════════════════════════
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 420, 0, 310)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Main.BorderSizePixel = 0
Main.BackgroundTransparency = 1
Main.ZIndex = 2
Main.ClipsDescendants = true
Main.Parent = ScreenGui
createCorner(Main, 16)
local MainStroke = createStroke(Main, Color3.fromRGB(90, 60, 200), 2, 0.3)

-- Inner glow
local InnerGlow = Instance.new("Frame")
InnerGlow.Size = UDim2.new(1, -4, 1, -4)
InnerGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
InnerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
InnerGlow.BackgroundTransparency = 1
InnerGlow.BorderSizePixel = 0
InnerGlow.ZIndex = 2
InnerGlow.Parent = Main
createCorner(InnerGlow, 14)
createStroke(InnerGlow, Color3.fromRGB(60, 40, 140), 1, 0.6)

-- ════════════════════════════════════
--       TOP & BOTTOM ACCENT LINES
-- ════════════════════════════════════
local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(1, 0, 0, 3)
AccentLine.Position = UDim2.new(0, 0, 0, 0)
AccentLine.BackgroundColor3 = Color3.fromRGB(130, 80, 255)
AccentLine.BorderSizePixel = 0
AccentLine.ZIndex = 5
AccentLine.BackgroundTransparency = 1
AccentLine.Parent = Main

local AccentGradient = Instance.new("UIGradient")
AccentGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 30, 255)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(130, 60, 255)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 60, 200)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(60, 200, 255)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(130, 60, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 30, 255)),
})
AccentGradient.Parent = AccentLine

local BottomLine = Instance.new("Frame")
BottomLine.Size = UDim2.new(1, 0, 0, 2)
BottomLine.Position = UDim2.new(0, 0, 1, -2)
BottomLine.BackgroundColor3 = Color3.fromRGB(130, 80, 255)
BottomLine.BorderSizePixel = 0
BottomLine.ZIndex = 5
BottomLine.BackgroundTransparency = 1
BottomLine.Parent = Main

local BottomGradient = Instance.new("UIGradient")
BottomGradient.Color = AccentGradient.Color
BottomGradient.Parent = BottomLine

-- ════════════════════════════════════
--          LOGO
-- ════════════════════════════════════
local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 72, 0, 72)
LogoFrame.Position = UDim2.new(0.5, 0, 0, 28)
LogoFrame.AnchorPoint = Vector2.new(0.5, 0)
LogoFrame.BackgroundTransparency = 1
LogoFrame.ZIndex = 5
LogoFrame.Parent = Main

local OuterRing = Instance.new("Frame")
OuterRing.Size = UDim2.new(1, 10, 1, 10)
OuterRing.Position = UDim2.new(0.5, 0, 0.5, 0)
OuterRing.AnchorPoint = Vector2.new(0.5, 0.5)
OuterRing.BackgroundTransparency = 1
OuterRing.ZIndex = 5
OuterRing.Parent = LogoFrame
createCorner(OuterRing, 999)
local OuterRingStroke = createStroke(OuterRing, Color3.fromRGB(130, 80, 255), 2.5, 0.15)

local OuterRing2 = Instance.new("Frame")
OuterRing2.Size = UDim2.new(1, 20, 1, 20)
OuterRing2.Position = UDim2.new(0.5, 0, 0.5, 0)
OuterRing2.AnchorPoint = Vector2.new(0.5, 0.5)
OuterRing2.BackgroundTransparency = 1
OuterRing2.ZIndex = 4
OuterRing2.Parent = LogoFrame
createCorner(OuterRing2, 999)
createStroke(OuterRing2, Color3.fromRGB(80, 50, 180), 1, 0.6)

local InnerCircle = Instance.new("Frame")
InnerCircle.Size = UDim2.new(0, 58, 0, 58)
InnerCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
InnerCircle.AnchorPoint = Vector2.new(0.5, 0.5)
InnerCircle.BackgroundColor3 = Color3.fromRGB(18, 14, 38)
InnerCircle.BorderSizePixel = 0
InnerCircle.ZIndex = 6
InnerCircle.BackgroundTransparency = 1
InnerCircle.Parent = LogoFrame
createCorner(InnerCircle, 999)
createStroke(InnerCircle, Color3.fromRGB(110, 70, 230), 1.5, 0.4)

local LogoLetter = Instance.new("TextLabel")
LogoLetter.Size = UDim2.new(1, 0, 1, 0)
LogoLetter.BackgroundTransparency = 1
LogoLetter.Text = "E"
LogoLetter.TextColor3 = Color3.fromRGB(180, 140, 255)
LogoLetter.TextSize = 28
LogoLetter.Font = Enum.Font.GothamBold
LogoLetter.ZIndex = 7
LogoLetter.TextTransparency = 1
LogoLetter.Parent = InnerCircle

-- ════════════════════════════════════
--          LABELS
-- ════════════════════════════════════
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 108)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "EUGUNEWU HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 24
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.ZIndex = 5
TitleLabel.TextTransparency = 1
TitleLabel.Parent = Main

local TitleGrad = Instance.new("UIGradient")
TitleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 110, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 190, 255)),
})
TitleGrad.Parent = TitleLabel

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Size = UDim2.new(1, 0, 0, 18)
SubtitleLabel.Position = UDim2.new(0, 0, 0, 138)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text = "Premium Script Loader"
SubtitleLabel.TextColor3 = Color3.fromRGB(120, 120, 160)
SubtitleLabel.TextSize = 12
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.ZIndex = 5
SubtitleLabel.TextTransparency = 1
SubtitleLabel.Parent = Main

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -60, 0, 20)
StatusLabel.Position = UDim2.new(0.5, 0, 0, 172)
StatusLabel.AnchorPoint = Vector2.new(0.5, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Initializing..."
StatusLabel.TextColor3 = Color3.fromRGB(190, 190, 220)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.ZIndex = 5
StatusLabel.TextTransparency = 1
StatusLabel.Parent = Main

-- ════════════════════════════════════
--       PROGRESS BAR (UPGRADED)
-- ════════════════════════════════════
local ProgressBG = Instance.new("Frame")
ProgressBG.Size = UDim2.new(1, -60, 0, 10)
ProgressBG.Position = UDim2.new(0.5, 0, 0, 200)
ProgressBG.AnchorPoint = Vector2.new(0.5, 0)
ProgressBG.BackgroundColor3 = Color3.fromRGB(20, 18, 40)
ProgressBG.BorderSizePixel = 0
ProgressBG.ZIndex = 5
ProgressBG.BackgroundTransparency = 1
ProgressBG.Parent = Main
createCorner(ProgressBG, 999)
createStroke(ProgressBG, Color3.fromRGB(50, 40, 100), 1, 0.5)

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(120, 70, 255)
ProgressFill.BorderSizePixel = 0
ProgressFill.ZIndex = 6
ProgressFill.ClipsDescendants = true
ProgressFill.Parent = ProgressBG
createCorner(ProgressFill, 999)

local FillGradient = Instance.new("UIGradient")
FillGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 40, 255)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(140, 70, 255)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(200, 80, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 200, 255)),
})
FillGradient.Parent = ProgressFill

-- Top glow on bar
local ProgressGlow = Instance.new("Frame")
ProgressGlow.Size = UDim2.new(1, 0, 0.45, 0)
ProgressGlow.Position = UDim2.new(0, 0, 0, 0)
ProgressGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProgressGlow.BackgroundTransparency = 0.75
ProgressGlow.BorderSizePixel = 0
ProgressGlow.ZIndex = 7
ProgressGlow.Parent = ProgressFill
createCorner(ProgressGlow, 999)

-- Shimmer
local Shimmer = Instance.new("Frame")
Shimmer.Size = UDim2.new(0.15, 0, 1, 0)
Shimmer.Position = UDim2.new(-0.2, 0, 0, 0)
Shimmer.BackgroundTransparency = 1
Shimmer.BorderSizePixel = 0
Shimmer.ZIndex = 8
Shimmer.Parent = ProgressFill
createCorner(Shimmer, 999)

local ShimmerGrad = Instance.new("UIGradient")
ShimmerGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.4, 0.6),
    NumberSequenceKeypoint.new(0.5, 0.5),
    NumberSequenceKeypoint.new(0.6, 0.6),
    NumberSequenceKeypoint.new(1, 1),
})
ShimmerGrad.Parent = Shimmer

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Size = UDim2.new(1, -60, 0, 18)
PercentLabel.Position = UDim2.new(0.5, 0, 0, 214)
PercentLabel.AnchorPoint = Vector2.new(0.5, 0)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Color3.fromRGB(140, 100, 255)
PercentLabel.TextSize = 11
PercentLabel.Font = Enum.Font.GothamBold
PercentLabel.TextXAlignment = Enum.TextXAlignment.Right
PercentLabel.ZIndex = 5
PercentLabel.TextTransparency = 1
PercentLabel.Parent = Main

-- ════════════════════════════════════
--          FOOTER
-- ════════════════════════════════════
local Sep = Instance.new("Frame")
Sep.Size = UDim2.new(1, -60, 0, 1)
Sep.Position = UDim2.new(0.5, 0, 0, 248)
Sep.AnchorPoint = Vector2.new(0.5, 0)
Sep.BackgroundColor3 = Color3.fromRGB(50, 40, 90)
Sep.BackgroundTransparency = 1
Sep.BorderSizePixel = 0
Sep.ZIndex = 5
Sep.Parent = Main

local SepGrad = Instance.new("UIGradient")
SepGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.2, 0.3),
    NumberSequenceKeypoint.new(0.8, 0.3),
    NumberSequenceKeypoint.new(1, 1),
})
SepGrad.Parent = Sep

local PlayerInfo = Instance.new("TextLabel")
PlayerInfo.Size = UDim2.new(0.5, -30, 0, 16)
PlayerInfo.Position = UDim2.new(0, 30, 0, 260)
PlayerInfo.BackgroundTransparency = 1
PlayerInfo.Text = "👤 " .. player.Name
PlayerInfo.TextColor3 = Color3.fromRGB(100, 100, 140)
PlayerInfo.TextSize = 10
PlayerInfo.Font = Enum.Font.Gotham
PlayerInfo.TextXAlignment = Enum.TextXAlignment.Left
PlayerInfo.TextTruncate = Enum.TextTruncate.AtEnd
PlayerInfo.ZIndex = 5
PlayerInfo.TextTransparency = 1
PlayerInfo.Parent = Main

local GameInfo = Instance.new("TextLabel")
GameInfo.Size = UDim2.new(0.5, -30, 0, 16)
GameInfo.Position = UDim2.new(1, -30, 0, 260)
GameInfo.AnchorPoint = Vector2.new(1, 0)
GameInfo.BackgroundTransparency = 1
GameInfo.Text = "🎮 " .. gameName
GameInfo.TextColor3 = Color3.fromRGB(100, 100, 140)
GameInfo.TextSize = 10
GameInfo.Font = Enum.Font.Gotham
GameInfo.TextXAlignment = Enum.TextXAlignment.Right
GameInfo.TextTruncate = Enum.TextTruncate.AtEnd
GameInfo.ZIndex = 5
GameInfo.TextTransparency = 1
GameInfo.Parent = Main

local VersionInfo = Instance.new("TextLabel")
VersionInfo.Size = UDim2.new(1, -60, 0, 16)
VersionInfo.Position = UDim2.new(0.5, 0, 0, 280)
VersionInfo.AnchorPoint = Vector2.new(0.5, 0)
VersionInfo.BackgroundTransparency = 1
VersionInfo.Text = "v2.2.0 • EUGUNEWU"
VersionInfo.TextColor3 = Color3.fromRGB(60, 60, 90)
VersionInfo.TextSize = 9
VersionInfo.Font = Enum.Font.Gotham
VersionInfo.ZIndex = 5
VersionInfo.TextTransparency = 1
VersionInfo.Parent = Main

-- ════════════════════════════════════
--          PARTICLES
-- ════════════════════════════════════
local function spawnParticle()
    if not alive then return end
    pcall(function()
        local p = Instance.new("Frame")
        local s = math.random(2, 5)
        p.Size = UDim2.new(0, s, 0, s)
        p.Position = UDim2.new(math.random(5, 95) / 100, 0, 1.05, 0)
        local cols = {
            Color3.fromRGB(130, 80, 255),
            Color3.fromRGB(80, 180, 255),
            Color3.fromRGB(255, 80, 200),
            Color3.fromRGB(100, 255, 200),
        }
        p.BackgroundColor3 = cols[math.random(1, #cols)]
        p.BackgroundTransparency = math.random(40, 70) / 100
        p.BorderSizePixel = 0
        p.ZIndex = 3
        p.Parent = Main
        createCorner(p, 999)

        local dur = math.random(20, 40) / 10
        local t = tw(p, {
            Position = UDim2.new(p.Position.X.Scale + (math.random(-20, 20) / 100), 0, -0.1, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, s * 0.3, 0, s * 0.3)
        }, dur, Enum.EasingStyle.Linear)
        t.Completed:Connect(function() p:Destroy() end)
    end)
end

-- ════════════════════════════════════
--          PROGRESS SETTER
-- ════════════════════════════════════
local function setProgress(percent, status)
    if status then StatusLabel.Text = status end
    PercentLabel.Text = math.floor(percent) .. "%"
    tw(ProgressFill, {
        Size = UDim2.new(math.clamp(percent / 100, 0, 1), 0, 1, 0)
    }, 0.25, Enum.EasingStyle.Quart)
end

-- ════════════════════════════════════
--       BACKGROUND ANIMATIONS
-- ════════════════════════════════════
local spinAngle, spinAngle2, gradRot = 0, 0, 0
local spinConn = RunService.Heartbeat:Connect(function(dt)
    if not alive then return end
    spinAngle = (spinAngle + dt * 80) % 360
    spinAngle2 = (spinAngle2 - dt * 50) % 360
    gradRot = (gradRot + dt * 60) % 360
    OuterRing.Rotation = spinAngle
    OuterRing2.Rotation = spinAngle2
    AccentGradient.Rotation = gradRot
    BottomGradient.Rotation = gradRot + 180
    FillGradient.Rotation = (gradRot * 0.5) % 360
end)
table.insert(activeConnections, spinConn)

task.spawn(function()
    while alive do
        Shimmer.Position = UDim2.new(-0.2, 0, 0, 0)
        tw(Shimmer, {Position = UDim2.new(1.1, 0, 0, 0)}, 0.8, Enum.EasingStyle.Linear)
        task.wait(1.5)
    end
end)

local pTimer = 0
local pConn = RunService.Heartbeat:Connect(function(dt)
    if not alive then return end
    pTimer = pTimer + dt
    if pTimer >= 0.35 then
        pTimer = 0
        spawnParticle()
    end
end)
table.insert(activeConnections, pConn)

task.spawn(function()
    while alive do
        tw(InnerCircle, {Size = UDim2.new(0, 62, 0, 62)}, 0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.6)
        tw(InnerCircle, {Size = UDim2.new(0, 55, 0, 55)}, 0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.6)
    end
end)

task.spawn(function()
    local hue = 0
    while alive do
        hue = (hue + 0.003) % 1
        OuterRingStroke.Color = Color3.fromHSV(hue, 0.6, 0.85)
        MainStroke.Color = Color3.fromHSV((hue + 0.15) % 1, 0.5, 0.7)
        task.wait(0.03)
    end
end)

-- ════════════════════════════════════
--          INTRO ANIMATION
-- ════════════════════════════════════
Main.Size = UDim2.new(0, 420, 0, 0)
Main.BackgroundTransparency = 1

tw(Overlay, {BackgroundTransparency = 0.4}, 0.4, Enum.EasingStyle.Quad)
task.wait(0.1)

tw(Main, {Size = UDim2.new(0, 420, 0, 310), BackgroundTransparency = 0}, 0.4, Enum.EasingStyle.Back)
task.wait(0.25)

tw(AccentLine, {BackgroundTransparency = 0}, 0.2)
tw(BottomLine, {BackgroundTransparency = 0.3}, 0.2)

local fadeEls = {LogoLetter, TitleLabel, SubtitleLabel, StatusLabel, PercentLabel, PlayerInfo, GameInfo, VersionInfo}
for i, obj in ipairs(fadeEls) do
    task.delay(i * 0.03, function()
        tw(obj, {TextTransparency = 0}, 0.2)
    end)
end

tw(InnerCircle, {BackgroundTransparency = 0}, 0.2)
tw(ProgressBG, {BackgroundTransparency = 0}, 0.2)
tw(Sep, {BackgroundTransparency = 0.3}, 0.2)

task.wait(0.3)

-- ════════════════════════════════════
--          EXIT ANIMATION
-- ════════════════════════════════════
local function exitAnimation(callback)
    cleanupAll()

    for _, obj in pairs(Main:GetDescendants()) do
        pcall(function()
            if obj:IsA("TextLabel") then
                tw(obj, {TextTransparency = 1}, 0.15)
            elseif obj:IsA("Frame") then
                tw(obj, {BackgroundTransparency = 1}, 0.15)
            end
        end)
    end

    task.wait(0.1)

    tw(Main, {
        Size = UDim2.new(0, 420, 0, 0),
        BackgroundTransparency = 1
    }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)

    tw(Overlay, {BackgroundTransparency = 1}, 0.3)

    task.wait(0.3)
    ScreenGui:Destroy()

    if callback then callback() end
end

local function showSuccess(name)
    tw(ProgressFill, {BackgroundColor3 = Color3.fromRGB(50, 210, 100)}, 0.2)
    tw(OuterRingStroke, {Color = Color3.fromRGB(50, 210, 100)}, 0.2)
    tw(LogoLetter, {TextColor3 = Color3.fromRGB(50, 210, 100)}, 0.2)
    LogoLetter.Text = "✓"
    LogoLetter.TextSize = 28
    StatusLabel.TextColor3 = Color3.fromRGB(50, 210, 100)
    StatusLabel.Text = "✅ " .. name .. " Loaded!"
end

local function showError(msg)
    tw(ProgressFill, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}, 0.2)
    tw(OuterRingStroke, {Color = Color3.fromRGB(220, 50, 50)}, 0.2)
    tw(LogoLetter, {TextColor3 = Color3.fromRGB(220, 50, 50)}, 0.2)
    LogoLetter.Text = "✕"
    LogoLetter.TextSize = 28
    StatusLabel.TextColor3 = Color3.fromRGB(220, 100, 100)
    StatusLabel.Text = msg
end

-- ════════════════════════════════════════════
--   MAIN LOADING (SCRIPT SUDAH DI-FETCH!)
-- ════════════════════════════════════════════

if scriptUrl then
    setProgress(10, "🔍 Detected: " .. gameName)
    task.wait(0.2)

    setProgress(30, "📡 Connecting...")
    task.wait(0.15)

    setProgress(50, "📥 Downloading...")

    -- Tunggu fetch selesai (sudah berjalan dari awal!)
    local waited = 0
    while not fetchDone and waited < 15 do
        task.wait(0.05)
        waited = waited + 0.05
        local fakeP = math.min(50 + (waited / 15) * 40, 90)
        setProgress(fakeP, "⚡ Downloading...")
    end

    if fetchFailed or not fetchDone then
        setProgress(100, "")
        task.wait(0.1)
        showError("❌ " .. fetchErrorMsg)
        task.wait(1.5)
        exitAnimation()
        return
    end

    setProgress(95, "🔧 Preparing...")
    task.wait(0.1)

    setProgress(100, "✅ Ready!")
    task.wait(0.1)

    showSuccess(gameName)
    task.wait(0.4)

    -- LANGSUNG EXIT DAN JALANKAN SCRIPT
    exitAnimation(function()
        local ok, err = pcall(compiledFunc)
        if not ok then
            warn("[EUGUNEWU HUB] Execution Error: " .. tostring(err))
        end
    end)

else
    setProgress(20, "🔍 Detecting game...")
    task.wait(0.25)

    setProgress(60, "📂 Searching database...")
    task.wait(0.2)

    setProgress(100, "")
    task.wait(0.1)

    showError("❌ Game not supported!")
    task.wait(0.3)

    StatusLabel.TextSize = 11
    StatusLabel.Text = "Game ID " .. tostring(gameId) .. " not in database"

    task.wait(2)
    exitAnimation()
end
