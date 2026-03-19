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

-- Get current game data
local currentGame = Games[gameId]
local gameName = currentGame and currentGame.name or "Unknown"
local scriptUrl = currentGame and currentGame.url or nil

-- ═══════════════════════════════════════
--          CLEANUP OLD GUI
-- ═══════════════════════════════════════
local oldGui = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("EugunewuHub")
if oldGui then oldGui:Destroy() end

-- ═══════════════════════════════════════
--          CREATE SCREEN GUI
-- ═══════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EugunewuHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

-- Try to parent to CoreGui first, fallback to PlayerGui
local guiParent = (syn and syn.protect_gui) or (gethui and gethui()) or player.PlayerGui
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = player.PlayerGui
end

-- ═══════════════════════════════════════
--          HELPER FUNCTIONS
-- ═══════════════════════════════════════
local activeConnections = {}
local activeTweens = {}

local function tween(obj, props, duration, style, direction)
    style = style or Enum.EasingStyle.Quint
    direction = direction or Enum.EasingDirection.Out
    local t = TweenService:Create(obj, TweenInfo.new(duration, style, direction), props)
    t:Play()
    table.insert(activeTweens, t)
    return t
end

local function cleanupAll()
    for _, conn in ipairs(activeConnections) do
        pcall(function() conn:Disconnect() end)
    end
    for _, tw in ipairs(activeTweens) do
        pcall(function() tw:Cancel() end)
    end
    activeConnections = {}
    activeTweens = {}
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(130, 80, 255)
    stroke.Thickness = thickness or 1.5
    stroke.Transparency = transparency or 0.4
    stroke.Parent = parent
    return stroke
end

-- ═══════════════════════════════════════
--          BACKGROUND OVERLAY
-- ═══════════════════════════════════════
local Overlay = Instance.new("Frame")
Overlay.Name = "Overlay"
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 1
Overlay.BorderSizePixel = 0
Overlay.ZIndex = 1
Overlay.Parent = ScreenGui

-- ═══════════════════════════════════════
--          MAIN CONTAINER
-- ═══════════════════════════════════════
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 400, 0, 300)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
Main.BorderSizePixel = 0
Main.BackgroundTransparency = 1
Main.ZIndex = 2
Main.Parent = ScreenGui

createCorner(Main, 14)

local MainStroke = createStroke(Main, Color3.fromRGB(80, 50, 180), 1.5, 0.5)

-- Clip container for particles
Main.ClipsDescendants = true

-- ═══════════════════════════════════════
--          TOP ACCENT LINE
-- ═══════════════════════════════════════
local AccentLine = Instance.new("Frame")
AccentLine.Name = "AccentLine"
AccentLine.Size = UDim2.new(1, 0, 0, 3)
AccentLine.Position = UDim2.new(0, 0, 0, 0)
AccentLine.BackgroundColor3 = Color3.fromRGB(130, 80, 255)
AccentLine.BorderSizePixel = 0
AccentLine.ZIndex = 5
AccentLine.Parent = Main

local AccentGradient = Instance.new("UIGradient")
AccentGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 50, 255)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(160, 80, 255)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 80, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 180, 255)),
})
AccentGradient.Parent = AccentLine

-- ═══════════════════════════════════════
--          LOGO SECTION
-- ═══════════════════════════════════════
local LogoFrame = Instance.new("Frame")
LogoFrame.Name = "LogoFrame"
LogoFrame.Size = UDim2.new(0, 70, 0, 70)
LogoFrame.Position = UDim2.new(0.5, 0, 0, 30)
LogoFrame.AnchorPoint = Vector2.new(0.5, 0)
LogoFrame.BackgroundTransparency = 1
LogoFrame.ZIndex = 5
LogoFrame.Parent = Main

-- Outer Ring (will spin)
local OuterRing = Instance.new("Frame")
OuterRing.Name = "OuterRing"
OuterRing.Size = UDim2.new(1, 6, 1, 6)
OuterRing.Position = UDim2.new(0.5, 0, 0.5, 0)
OuterRing.AnchorPoint = Vector2.new(0.5, 0.5)
OuterRing.BackgroundTransparency = 1
OuterRing.ZIndex = 5
OuterRing.Parent = LogoFrame

local OuterRingStroke = createStroke(OuterRing, Color3.fromRGB(130, 80, 255), 2, 0.3)
createCorner(OuterRing, 999)

-- Inner Circle
local InnerCircle = Instance.new("Frame")
InnerCircle.Name = "InnerCircle"
InnerCircle.Size = UDim2.new(0, 56, 0, 56)
InnerCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
InnerCircle.AnchorPoint = Vector2.new(0.5, 0.5)
InnerCircle.BackgroundColor3 = Color3.fromRGB(20, 16, 40)
InnerCircle.BorderSizePixel = 0
InnerCircle.ZIndex = 6
InnerCircle.Parent = LogoFrame

createCorner(InnerCircle, 999)
createStroke(InnerCircle, Color3.fromRGB(100, 60, 220), 1.5, 0.5)

-- Logo Letter
local LogoLetter = Instance.new("TextLabel")
LogoLetter.Name = "LogoLetter"
LogoLetter.Size = UDim2.new(1, 0, 1, 0)
LogoLetter.BackgroundTransparency = 1
LogoLetter.Text = "E"
LogoLetter.TextColor3 = Color3.fromRGB(170, 130, 255)
LogoLetter.TextSize = 28
LogoLetter.Font = Enum.Font.GothamBold
LogoLetter.ZIndex = 7
LogoLetter.Parent = InnerCircle

-- ═══════════════════════════════════════
--          TEXT LABELS
-- ═══════════════════════════════════════
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 108)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "EUGUNEWU HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 24
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.ZIndex = 5
TitleLabel.Parent = Main

local TitleGrad = Instance.new("UIGradient")
TitleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 110, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 190, 255)),
})
TitleGrad.Parent = TitleLabel

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Name = "Subtitle"
SubtitleLabel.Size = UDim2.new(1, 0, 0, 18)
SubtitleLabel.Position = UDim2.new(0, 0, 0, 138)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text = "Premium Script Loader"
SubtitleLabel.TextColor3 = Color3.fromRGB(120, 120, 160)
SubtitleLabel.TextSize = 12
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.ZIndex = 5
SubtitleLabel.Parent = Main

-- ═══════════════════════════════════════
--          STATUS & PROGRESS
-- ═══════════════════════════════════════
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Status"
StatusLabel.Size = UDim2.new(1, -60, 0, 20)
StatusLabel.Position = UDim2.new(0.5, 0, 0, 175)
StatusLabel.AnchorPoint = Vector2.new(0.5, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Initializing..."
StatusLabel.TextColor3 = Color3.fromRGB(190, 190, 220)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.ZIndex = 5
StatusLabel.Parent = Main

-- Progress Background
local ProgressBG = Instance.new("Frame")
ProgressBG.Name = "ProgressBG"
ProgressBG.Size = UDim2.new(1, -60, 0, 8)
ProgressBG.Position = UDim2.new(0.5, 0, 0, 202)
ProgressBG.AnchorPoint = Vector2.new(0.5, 0)
ProgressBG.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
ProgressBG.BorderSizePixel = 0
ProgressBG.ZIndex = 5
ProgressBG.Parent = Main

createCorner(ProgressBG, 999)

-- Progress Fill
local ProgressFill = Instance.new("Frame")
ProgressFill.Name = "Fill"
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(120, 70, 255)
ProgressFill.BorderSizePixel = 0
ProgressFill.ZIndex = 6
ProgressFill.Parent = ProgressBG

createCorner(ProgressFill, 999)

local FillGradient = Instance.new("UIGradient")
FillGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 50, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 90, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 170, 255)),
})
FillGradient.Parent = ProgressFill

-- Progress Shimmer
local Shimmer = Instance.new("Frame")
Shimmer.Name = "Shimmer"
Shimmer.Size = UDim2.new(0.3, 0, 1, 0)
Shimmer.Position = UDim2.new(-0.3, 0, 0, 0)
Shimmer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Shimmer.BackgroundTransparency = 0.85
Shimmer.BorderSizePixel = 0
Shimmer.ZIndex = 7
Shimmer.Parent = ProgressFill

createCorner(Shimmer, 999)

-- Percentage
local PercentLabel = Instance.new("TextLabel")
PercentLabel.Name = "Percent"
PercentLabel.Size = UDim2.new(1, -60, 0, 18)
PercentLabel.Position = UDim2.new(0.5, 0, 0, 214)
PercentLabel.AnchorPoint = Vector2.new(0.5, 0)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Color3.fromRGB(120, 80, 255)
PercentLabel.TextSize = 11
PercentLabel.Font = Enum.Font.GothamBold
PercentLabel.TextXAlignment = Enum.TextXAlignment.Right
PercentLabel.ZIndex = 5
PercentLabel.Parent = Main

-- ═══════════════════════════════════════
--          SEPARATOR & FOOTER
-- ═══════════════════════════════════════
local Sep = Instance.new("Frame")
Sep.Name = "Separator"
Sep.Size = UDim2.new(1, -60, 0, 1)
Sep.Position = UDim2.new(0.5, 0, 0, 245)
Sep.AnchorPoint = Vector2.new(0.5, 0)
Sep.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
Sep.BackgroundTransparency = 0.5
Sep.BorderSizePixel = 0
Sep.ZIndex = 5
Sep.Parent = Main

local PlayerInfo = Instance.new("TextLabel")
PlayerInfo.Name = "PlayerInfo"
PlayerInfo.Size = UDim2.new(0.5, -30, 0, 16)
PlayerInfo.Position = UDim2.new(0, 30, 0, 255)
PlayerInfo.BackgroundTransparency = 1
PlayerInfo.Text = "User: " .. player.Name
PlayerInfo.TextColor3 = Color3.fromRGB(100, 100, 140)
PlayerInfo.TextSize = 10
PlayerInfo.Font = Enum.Font.Gotham
PlayerInfo.TextXAlignment = Enum.TextXAlignment.Left
PlayerInfo.TextTruncate = Enum.TextTruncate.AtEnd
PlayerInfo.ZIndex = 5
PlayerInfo.Parent = Main

local GameInfo = Instance.new("TextLabel")
GameInfo.Name = "GameInfo"
GameInfo.Size = UDim2.new(0.5, -30, 0, 16)
GameInfo.Position = UDim2.new(1, -30, 0, 255)
GameInfo.AnchorPoint = Vector2.new(1, 0)
GameInfo.BackgroundTransparency = 1
GameInfo.Text = "Game: " .. gameName
GameInfo.TextColor3 = Color3.fromRGB(100, 100, 140)
GameInfo.TextSize = 10
GameInfo.Font = Enum.Font.Gotham
GameInfo.TextXAlignment = Enum.TextXAlignment.Right
GameInfo.TextTruncate = Enum.TextTruncate.AtEnd
GameInfo.ZIndex = 5
GameInfo.Parent = Main

local VersionInfo = Instance.new("TextLabel")
VersionInfo.Name = "Version"
VersionInfo.Size = UDim2.new(1, -60, 0, 16)
VersionInfo.Position = UDim2.new(0.5, 0, 0, 274)
VersionInfo.AnchorPoint = Vector2.new(0.5, 0)
VersionInfo.BackgroundTransparency = 1
VersionInfo.Text = "v2.1.0"
VersionInfo.TextColor3 = Color3.fromRGB(70, 70, 100)
VersionInfo.TextSize = 9
VersionInfo.Font = Enum.Font.Gotham
VersionInfo.ZIndex = 5
VersionInfo.Parent = Main

-- ═══════════════════════════════════════
--          FLOATING PARTICLES
-- ═══════════════════════════════════════
local function spawnParticle()
    pcall(function()
        local p = Instance.new("Frame")
        local s = math.random(2, 4)
        p.Size = UDim2.new(0, s, 0, s)
        p.Position = UDim2.new(math.random(5, 95) / 100, 0, 1.05, 0)
        p.BackgroundColor3 = Color3.fromRGB(
            math.random(80, 160),
            math.random(50, 120),
            255
        )
        p.BackgroundTransparency = math.random(50, 80) / 100
        p.BorderSizePixel = 0
        p.ZIndex = 3
        p.Parent = Main
        createCorner(p, 999)

        local dur = math.random(25, 50) / 10
        local t = tween(p, {
            Position = UDim2.new(p.Position.X.Scale + (math.random(-15, 15) / 100), 0, -0.05, 0),
            BackgroundTransparency = 1
        }, dur, Enum.EasingStyle.Linear)

        t.Completed:Connect(function()
            p:Destroy()
        end)
    end)
end

-- ═══════════════════════════════════════
--          PROGRESS FUNCTION
-- ═══════════════════════════════════════
local function setProgress(percent, status)
    if status then
        StatusLabel.Text = status
    end
    PercentLabel.Text = math.floor(percent) .. "%"
    tween(ProgressFill, {
        Size = UDim2.new(math.clamp(percent / 100, 0, 1), 0, 1, 0)
    }, 0.4, Enum.EasingStyle.Quart)
end

-- ═══════════════════════════════════════
--          ANIMATIONS START
-- ═══════════════════════════════════════

-- Ring spin
local spinAngle = 0
local spinConn = RunService.Heartbeat:Connect(function(dt)
    spinAngle = (spinAngle + dt * 90) % 360
    OuterRing.Rotation = spinAngle
    AccentGradient.Rotation = (AccentGradient.Rotation + dt * 40) % 360
end)
table.insert(activeConnections, spinConn)

-- Shimmer loop
local shimmerConn
local function shimmerLoop()
    shimmerConn = RunService.Heartbeat:Connect(function(dt)
        -- Handled by tween below
    end)
    table.insert(activeConnections, shimmerConn)

    while ScreenGui and ScreenGui.Parent do
        Shimmer.Position = UDim2.new(-0.3, 0, 0, 0)
        local t = tween(Shimmer, {Position = UDim2.new(1.1, 0, 0, 0)}, 1.2, Enum.EasingStyle.Linear)
        task.wait(1.8)
    end
end
task.spawn(shimmerLoop)

-- Particle spawner
local particleTimer = 0
local particleConn = RunService.Heartbeat:Connect(function(dt)
    particleTimer = particleTimer + dt
    if particleTimer >= 0.4 then
        particleTimer = 0
        spawnParticle()
    end
end)
table.insert(activeConnections, particleConn)

-- Logo pulse
task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        tween(InnerCircle, {Size = UDim2.new(0, 60, 0, 60)}, 0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.7)
        tween(InnerCircle, {Size = UDim2.new(0, 54, 0, 54)}, 0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.7)
    end
end)

-- ═══════════════════════════════════════
--          INTRO ANIMATION
-- ═══════════════════════════════════════
Main.Size = UDim2.new(0, 400, 0, 0)
Main.BackgroundTransparency = 1

-- Make all text invisible initially
for _, obj in pairs(Main:GetDescendants()) do
    if obj:IsA("TextLabel") then
        obj.TextTransparency = 1
    elseif obj:IsA("Frame") and obj.Name ~= "Main" then
        if obj.BackgroundTransparency < 0.5 then
            obj.BackgroundTransparency = 1
        end
    end
end

-- Fade overlay
tween(Overlay, {BackgroundTransparency = 0.4}, 0.6, Enum.EasingStyle.Quad)
task.wait(0.2)

-- Expand main
tween(Main, {
    Size = UDim2.new(0, 400, 0, 300),
    BackgroundTransparency = 0
}, 0.7, Enum.EasingStyle.Back)
task.wait(0.4)

-- Fade in all elements
for _, obj in pairs(Main:GetDescendants()) do
    if obj:IsA("TextLabel") then
        tween(obj, {TextTransparency = 0}, 0.5)
    end
end

tween(AccentLine, {BackgroundTransparency = 0}, 0.4)
tween(InnerCircle, {BackgroundTransparency = 0}, 0.4)
tween(ProgressBG, {BackgroundTransparency = 0}, 0.4)
tween(Sep, {BackgroundTransparency = 0.5}, 0.4)

task.wait(0.5)

-- ═══════════════════════════════════════
--          LOADING SEQUENCE
-- ═══════════════════════════════════════

local function exitAnimation(callback)
    -- Stop animations
    cleanupAll()

    -- Fade everything out
    for _, obj in pairs(Main:GetDescendants()) do
        pcall(function()
            if obj:IsA("TextLabel") then
                tween(obj, {TextTransparency = 1}, 0.3)
            elseif obj:IsA("Frame") then
                tween(obj, {BackgroundTransparency = 1}, 0.3)
            end
        end)
    end

    task.wait(0.2)

    tween(Main, {
        Size = UDim2.new(0, 400, 0, 0),
        BackgroundTransparency = 1
    }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)

    tween(Overlay, {BackgroundTransparency = 1}, 0.6)

    task.wait(0.7)

    ScreenGui:Destroy()

    if callback then
        callback()
    end
end

local function showSuccess(name)
    tween(ProgressFill, {BackgroundColor3 = Color3.fromRGB(60, 200, 100)}, 0.4)
    tween(OuterRingStroke, {Color = Color3.fromRGB(60, 200, 100)}, 0.4)
    tween(LogoLetter, {TextColor3 = Color3.fromRGB(60, 200, 100)}, 0.4)
    LogoLetter.Text = "✓"
    LogoLetter.TextSize = 26
    StatusLabel.TextColor3 = Color3.fromRGB(60, 200, 100)
    StatusLabel.Text = "Loaded: " .. name
end

local function showError(msg)
    tween(ProgressFill, {BackgroundColor3 = Color3.fromRGB(220, 60, 60)}, 0.4)
    tween(OuterRingStroke, {Color = Color3.fromRGB(220, 60, 60)}, 0.4)
    tween(LogoLetter, {TextColor3 = Color3.fromRGB(220, 60, 60)}, 0.4)
    LogoLetter.Text = "!"
    LogoLetter.TextSize = 30
    StatusLabel.TextColor3 = Color3.fromRGB(220, 100, 100)
    StatusLabel.Text = msg
end

-- ═══════════════════════════════════════
--          MAIN LOADING LOGIC
-- ═══════════════════════════════════════

if scriptUrl then
    -- ===== SUPPORTED GAME =====
    setProgress(5, "Detecting game...")
    task.wait(0.6)

    setProgress(15, "Found: " .. gameName)
    task.wait(0.5)

    setProgress(30, "Connecting to server...")
    task.wait(0.6)

    setProgress(45, "Downloading script...")
    task.wait(0.5)

    -- Actually fetch the script
    local scriptContent = nil
    local fetchSuccess, fetchError = pcall(function()
        setProgress(55, "Fetching data...")
        scriptContent = game:HttpGet(scriptUrl, true)
    end)

    if not fetchSuccess or not scriptContent or #scriptContent < 10 then
        setProgress(100, "")
        task.wait(0.2)
        showError("Download failed!")
        task.wait(2.5)
        exitAnimation()
        return
    end

    setProgress(70, "Verifying integrity...")
    task.wait(0.4)

    setProgress(85, "Compiling...")
    task.wait(0.3)

    -- Compile the script
    local compiledFunc, compileError = loadstring(scriptContent)

    if not compiledFunc then
        setProgress(100, "")
        task.wait(0.2)
        showError("Compile error!")
        warn("[EUGUNEWU HUB] Compile Error: " .. tostring(compileError))
        task.wait(2.5)
        exitAnimation()
        return
    end

    setProgress(95, "Preparing launch...")
    task.wait(0.3)

    setProgress(100, "Ready!")
    task.wait(0.3)

    showSuccess(gameName)
    task.wait(1.2)

    -- Exit and execute
    exitAnimation(function()
        -- Execute script after UI is gone
        local execSuccess, execError = pcall(compiledFunc)
        if not execSuccess then
            warn("[EUGUNEWU HUB] Execution Error: " .. tostring(execError))
        end
    end)

else
    -- ===== UNSUPPORTED GAME =====
    setProgress(10, "Detecting game...")
    task.wait(0.6)

    setProgress(30, "Searching database...")
    task.wait(0.6)

    setProgress(60, "Checking compatibility...")
    task.wait(0.5)

    setProgress(100, "")
    task.wait(0.3)

    showError("Game not supported!")
    task.wait(0.5)

    StatusLabel.TextSize = 11
    StatusLabel.Text = "Game ID " .. tostring(gameId) .. " is not in database"

    task.wait(3)

    exitAnimation()
end
