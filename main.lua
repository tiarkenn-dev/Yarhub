-- =========================================================
-- ROOORHUB ULTIMATE - BAGIAN 1/6 : CORE + CONFIG
-- =========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local Cam = workspace.CurrentCamera

local C = {
    BG = Color3.fromRGB(10, 8, 18),
    PANEL = Color3.fromRGB(20, 15, 35),
    ACC = Color3.fromRGB(255, 50, 130),
    ACC2 = Color3.fromRGB(0, 255, 200),
    ACC3 = Color3.fromRGB(255, 200, 0),
    ACC4 = Color3.fromRGB(150, 80, 255),
    TXT = Color3.fromRGB(245, 245, 255),
    DIM = Color3.fromRGB(130, 130, 160),
    RED = Color3.fromRGB(255, 70, 90),
    GRN = Color3.fromRGB(0, 255, 150),
}

-- STATE GLOBAL (ANTI RESET)
_G.RoooorS = _G.RoooorS or {
    FireOn = false,
    FireType = "Classic",
    FireSize = 5,
    ESP_Name = false,
    ESP_Size = 12,
    ESP_Radius = 500,
    ESP_ShowName = true,
    ESP_ShowDist = true,
    ESP_ShowHP = false,
    ESP_DefaultColor = Color3.fromRGB(255, 255, 255),
    ESP_KillerColor = Color3.fromRGB(255, 60, 60),
    ESP_SurvivorColor = Color3.fromRGB(60, 255, 120),
    ESP_Generator = false,
    ESP_GenColor = Color3.fromRGB(255, 170, 0),
    ESP_Pallet = false,
    ESP_PalletColor = Color3.fromRGB(74, 255, 181),
    ESP_Window = false,
    ESP_WindowColor = Color3.fromRGB(74, 255, 181),
    ESP_SCP = false,
    ESP_SCPColor = Color3.fromRGB(255, 0, 0),
    Parry = false,
    ParryDist = 8,
    ParryCircle = false,
    ParryCircleSize = 15,
    Skill = false,
    UltraHD = false,
    Contrast = false,
    ContrastVal = 0.3,
    BrightnessVal = 0.1,
    SaturationVal = 0.2,
    FPS = true,
}

local S = _G.RoooorS

-- STATE SYNC
_G.ToggleStates = _G.ToggleStates or {}
_G.ToggleObjects = _G.ToggleObjects or {}
_G.SliderStates = _G.SliderStates or {}
_G.DropdownStates = _G.DropdownStates or {}

-- 60 FIRE EFFECT
local FireList = {
    "Classic", "HellFire", "IceFire", "ToxicFire", "VoidFire",
    "GoldenKing", "SakuraFire", "EmeraldFire", "BloodFire", "ShadowFire",
    "HolyFire", "OceanFire", "Firework", "Lava", "GhostFire",
    "CosmicFire", "DragonFire", "MysteryFire", "RainbowFire", "LightningFire",
    "GalaxyFire", "NebulaFire", "AuroraFire", "PhoenixFire", "DemonFire",
    "AngelFire", "CrystalFire", "NeonFire", "PlasmaFire", "QuantumFire",
    "LegendaryFire", "MythicFire", "DivineFire", "CursedFire", "AncientFire",
    "EternalFire", "InfernoFire", "BifrostFire", "ChaosFire", "OmegaFire",
    "SolarFire", "LunarFire", "EclipseFire", "SolarFlare", "VoidStorm",
    "StarFire", "SupernovaFire", "BlackHoleFire", "MeteorFire", "CometFire",
    "FrostFire", "BlizzardFire", "ThunderFire", "StormFire", "TornadoFire",
    "SoulFire", "SpiritFire", "PhantomFire", "WraithFire", "ReaperFire"
}

local FireConfig = {
    Classic = { c1 = Color3.fromRGB(255, 100, 0), c2 = Color3.fromRGB(255, 200, 0) },
    HellFire = { c1 = Color3.fromRGB(150, 0, 0), c2 = Color3.fromRGB(255, 50, 0), smoke = true, smokeColor = Color3.fromRGB(20, 20, 20) },
    IceFire = { c1 = Color3.fromRGB(100, 200, 255), c2 = Color3.fromRGB(200, 240, 255), spark = true, light = Color3.fromRGB(100, 200, 255) },
    ToxicFire = { c1 = Color3.fromRGB(0, 255, 50), c2 = Color3.fromRGB(150, 255, 0), smoke = true, smokeColor = Color3.fromRGB(50, 200, 50) },
    VoidFire = { c1 = Color3.fromRGB(80, 0, 150), c2 = Color3.fromRGB(200, 0, 255), spark = true, light = Color3.fromRGB(150, 0, 255) },
    GoldenKing = { c1 = Color3.fromRGB(255, 215, 0), c2 = Color3.fromRGB(255, 255, 100), spark = true, light = Color3.fromRGB(255, 215, 0) },
    SakuraFire = { c1 = Color3.fromRGB(255, 150, 200), c2 = Color3.fromRGB(255, 200, 230), spark = true },
    EmeraldFire = { c1 = Color3.fromRGB(0, 200, 100), c2 = Color3.fromRGB(100, 255, 150), light = Color3.fromRGB(0, 255, 150) },
    BloodFire = { c1 = Color3.fromRGB(200, 0, 0), c2 = Color3.fromRGB(100, 0, 0), smoke = true, smokeColor = Color3.fromRGB(80, 0, 0) },
    ShadowFire = { c1 = Color3.fromRGB(20, 20, 30), c2 = Color3.fromRGB(80, 0, 100), smoke = true, smokeColor = Color3.fromRGB(40, 0, 60) },
    HolyFire = { c1 = Color3.fromRGB(255, 255, 255), c2 = Color3.fromRGB(255, 255, 200), spark = true, light = Color3.fromRGB(255, 255, 255) },
    OceanFire = { c1 = Color3.fromRGB(0, 100, 255), c2 = Color3.fromRGB(100, 200, 255), light = Color3.fromRGB(0, 150, 255) },
    Firework = { c1 = Color3.fromRGB(255, 0, 100), c2 = Color3.fromRGB(255, 200, 0), spark = true, rainbow = true },
    Lava = { c1 = Color3.fromRGB(255, 80, 0), c2 = Color3.fromRGB(100, 20, 0), smoke = true, smokeColor = Color3.fromRGB(60, 30, 0) },
    GhostFire = { c1 = Color3.fromRGB(200, 200, 255), c2 = Color3.fromRGB(255, 255, 255) },
    CosmicFire = { c1 = Color3.fromRGB(50, 0, 100), c2 = Color3.fromRGB(255, 100, 200), spark = true, rainbow = true },
    DragonFire = { c1 = Color3.fromRGB(255, 50, 0), c2 = Color3.fromRGB(255, 200, 0), smoke = true, smokeColor = Color3.fromRGB(100, 50, 0) },
    MysteryFire = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 255, 255), rainbow = true },
    RainbowFire = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 255, 255), rainbow = true, spark = true },
    LightningFire = { c1 = Color3.fromRGB(100, 200, 255), c2 = Color3.fromRGB(255, 255, 255), spark = true, light = Color3.fromRGB(200, 220, 255) },
    GalaxyFire = { c1 = Color3.fromRGB(80, 0, 200), c2 = Color3.fromRGB(255, 200, 255), spark = true, rainbow = true, light = Color3.fromRGB(150, 100, 255) },
    NebulaFire = { c1 = Color3.fromRGB(200, 50, 255), c2 = Color3.fromRGB(50, 200, 255), spark = true, rainbow = true },
    AuroraFire = { c1 = Color3.fromRGB(0, 255, 200), c2 = Color3.fromRGB(100, 255, 100), spark = true, rainbow = true },
    PhoenixFire = { c1 = Color3.fromRGB(255, 150, 0), c2 = Color3.fromRGB(255, 50, 0), smoke = true, smokeColor = Color3.fromRGB(200, 100, 0), light = Color3.fromRGB(255, 150, 0) },
    DemonFire = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 0, 0), smoke = true, smokeColor = Color3.fromRGB(50, 0, 0), light = Color3.fromRGB(255, 0, 0) },
    AngelFire = { c1 = Color3.fromRGB(255, 255, 200), c2 = Color3.fromRGB(255, 220, 255), spark = true, light = Color3.fromRGB(255, 255, 220) },
    CrystalFire = { c1 = Color3.fromRGB(200, 255, 255), c2 = Color3.fromRGB(200, 200, 255), spark = true, light = Color3.fromRGB(220, 240, 255) },
    NeonFire = { c1 = Color3.fromRGB(0, 255, 100), c2 = Color3.fromRGB(255, 0, 200), spark = true, rainbow = true, light = Color3.fromRGB(0, 255, 150) },
    PlasmaFire = { c1 = Color3.fromRGB(150, 0, 255), c2 = Color3.fromRGB(0, 200, 255), spark = true, light = Color3.fromRGB(150, 100, 255) },
    QuantumFire = { c1 = Color3.fromRGB(0, 100, 255), c2 = Color3.fromRGB(255, 0, 100), rainbow = true, spark = true },
    LegendaryFire = { c1 = Color3.fromRGB(255, 215, 0), c2 = Color3.fromRGB(255, 100, 0), spark = true, light = Color3.fromRGB(255, 200, 0) },
    MythicFire = { c1 = Color3.fromRGB(200, 0, 255), c2 = Color3.fromRGB(255, 200, 0), spark = true, rainbow = true },
    DivineFire = { c1 = Color3.fromRGB(255, 255, 255), c2 = Color3.fromRGB(255, 200, 100), spark = true, light = Color3.fromRGB(255, 240, 200) },
    CursedFire = { c1 = Color3.fromRGB(80, 0, 0), c2 = Color3.fromRGB(200, 0, 200), smoke = true, smokeColor = Color3.fromRGB(50, 0, 50) },
    AncientFire = { c1 = Color3.fromRGB(200, 150, 0), c2 = Color3.fromRGB(100, 50, 0), smoke = true, smokeColor = Color3.fromRGB(80, 60, 0) },
    EternalFire = { c1 = Color3.fromRGB(255, 100, 200), c2 = Color3.fromRGB(100, 200, 255), rainbow = true, spark = true },
    InfernoFire = { c1 = Color3.fromRGB(255, 30, 0), c2 = Color3.fromRGB(255, 200, 0), smoke = true, smokeColor = Color3.fromRGB(100, 30, 0), light = Color3.fromRGB(255, 80, 0) },
    BifrostFire = { c1 = Color3.fromRGB(255, 100, 200), c2 = Color3.fromRGB(100, 255, 200), rainbow = true, spark = true, light = Color3.fromRGB(200, 200, 255) },
    ChaosFire = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 0, 255), rainbow = true, spark = true },
    OmegaFire = { c1 = Color3.fromRGB(255, 215, 0), c2 = Color3.fromRGB(255, 0, 255), rainbow = true, spark = true, light = Color3.fromRGB(255, 150, 200) },
    SolarFire = { c1 = Color3.fromRGB(255, 150, 0), c2 = Color3.fromRGB(255, 255, 100), spark = true, light = Color3.fromRGB(255, 200, 0) },
    LunarFire = { c1 = Color3.fromRGB(200, 220, 255), c2 = Color3.fromRGB(100, 150, 255), spark = true, light = Color3.fromRGB(150, 200, 255) },
    EclipseFire = { c1 = Color3.fromRGB(50, 0, 100), c2 = Color3.fromRGB(255, 150, 0), spark = true, light = Color3.fromRGB(150, 100, 200) },
    SolarFlare = { c1 = Color3.fromRGB(255, 100, 0), c2 = Color3.fromRGB(255, 255, 200), spark = true, light = Color3.fromRGB(255, 150, 0) },
    VoidStorm = { c1 = Color3.fromRGB(50, 0, 80), c2 = Color3.fromRGB(200, 0, 255), spark = true, rainbow = true, light = Color3.fromRGB(150, 0, 255) },
    StarFire = { c1 = Color3.fromRGB(255, 255, 200), c2 = Color3.fromRGB(255, 200, 100), spark = true, light = Color3.fromRGB(255, 230, 150) },
    SupernovaFire = { c1 = Color3.fromRGB(255, 200, 0), c2 = Color3.fromRGB(255, 0, 200), spark = true, rainbow = true, light = Color3.fromRGB(255, 100, 150) },
    BlackHoleFire = { c1 = Color3.fromRGB(0, 0, 0), c2 = Color3.fromRGB(100, 0, 150), smoke = true, smokeColor = Color3.fromRGB(30, 0, 50), light = Color3.fromRGB(80, 0, 120) },
    MeteorFire = { c1 = Color3.fromRGB(255, 80, 0), c2 = Color3.fromRGB(200, 30, 0), smoke = true, smokeColor = Color3.fromRGB(100, 50, 0), light = Color3.fromRGB(255, 80, 0) },
    CometFire = { c1 = Color3.fromRGB(100, 200, 255), c2 = Color3.fromRGB(200, 255, 255), spark = true, light = Color3.fromRGB(150, 220, 255) },
    FrostFire = { c1 = Color3.fromRGB(200, 240, 255), c2 = Color3.fromRGB(100, 180, 255), spark = true, light = Color3.fromRGB(180, 220, 255) },
    BlizzardFire = { c1 = Color3.fromRGB(220, 240, 255), c2 = Color3.fromRGB(150, 200, 255), spark = true, smoke = true, smokeColor = Color3.fromRGB(220, 240, 255) },
    ThunderFire = { c1 = Color3.fromRGB(255, 255, 100), c2 = Color3.fromRGB(100, 100, 255), spark = true, light = Color3.fromRGB(200, 200, 255) },
    StormFire = { c1 = Color3.fromRGB(80, 80, 150), c2 = Color3.fromRGB(200, 200, 255), spark = true, smoke = true, smokeColor = Color3.fromRGB(80, 80, 120) },
    TornadoFire = { c1 = Color3.fromRGB(150, 150, 200), c2 = Color3.fromRGB(80, 80, 120), spark = true, smoke = true, smokeColor = Color3.fromRGB(100, 100, 150) },
    SoulFire = { c1 = Color3.fromRGB(0, 255, 200), c2 = Color3.fromRGB(150, 255, 255), spark = true, light = Color3.fromRGB(100, 255, 220) },
    SpiritFire = { c1 = Color3.fromRGB(200, 255, 255), c2 = Color3.fromRGB(150, 200, 255), spark = true, light = Color3.fromRGB(200, 240, 255) },
    PhantomFire = { c1 = Color3.fromRGB(100, 0, 150), c2 = Color3.fromRGB(50, 0, 100), smoke = true, smokeColor = Color3.fromRGB(60, 0, 100), light = Color3.fromRGB(100, 0, 150) },
    WraithFire = { c1 = Color3.fromRGB(30, 0, 50), c2 = Color3.fromRGB(150, 0, 200), smoke = true, smokeColor = Color3.fromRGB(50, 0, 80) },
    ReaperFire = { c1 = Color3.fromRGB(0, 0, 0), c2 = Color3.fromRGB(255, 0, 0), smoke = true, smokeColor = Color3.fromRGB(80, 0, 0), light = Color3.fromRGB(150, 0, 0) },
}

-- Print buat cek fire loaded
print("🔥 Fire Config:", #FireList, "efek loaded")
print("🔥 Contoh:", FireConfig.Classic and "Classic OK" or "Classic KOSONG")

local KillerAnims = {}
for _, id in ipairs({
    "105374834496520","113255068724446","118907603246885","129784271201071",
    "117042998468241","122812055447896","78935059863801","74968262036854",
    "78432063483146","132817836308238","133963973694098","111920872708571",
    "80411309607666","98163597193511","82666958311998","110355011987939",
    "139369275981139","135002183282873","121216847022485","130593238885843",
    "117070354890871","106871536134254","138720291317243"
}) do KillerAnims["rbxassetid://"..id] = true end

function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

function rnd(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = o
end

function strk(o, col, t)
    local s = Instance.new("UIStroke")
    s.Color = col or C.ACC
    s.Thickness = t or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = o
    return s
end

function rainbowSeq()
    return ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,100,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,150)),
    }
end

print("✅ [1/6] Core loaded")-- =========================================================
-- BAGIAN 2/6 : GUI + COMPONENTS + STATE SYNC
-- =========================================================

local gui = Instance.new("ScreenGui")
gui.Name = "RoooorHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PG

-- FLOAT BUTTON
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 42, 0, 42)
floatBtn.Position = UDim2.new(0, 15, 0.5, -21)
floatBtn.BackgroundColor3 = C.PANEL
floatBtn.Text = "⚡"
floatBtn.TextColor3 = C.ACC2
floatBtn.TextSize = 22
floatBtn.Font = Enum.Font.GothamBold
floatBtn.BorderSizePixel = 0
floatBtn.AutoButtonColor = false
floatBtn.Parent = gui
rnd(floatBtn, 21)
local fbStrk = strk(floatBtn, C.ACC, 2)

local fName = Instance.new("TextLabel")
fName.Size = UDim2.new(0, 110, 0, 20)
fName.Position = UDim2.new(0.5, -55, 1, 2)
fName.BackgroundTransparency = 1
fName.Text = "ROOORHUB"
fName.TextColor3 = Color3.new(1,1,1)
fName.TextSize = 11
fName.Font = Enum.Font.GothamBlack
fName.TextStrokeTransparency = 0
fName.TextStrokeColor3 = Color3.new(0,0,0)
fName.Parent = floatBtn
local fGrad = Instance.new("UIGradient")
fGrad.Color = rainbowSeq()
fGrad.Parent = fName

task.spawn(function()
    while fName.Parent do
        for i = 0, 1, 0.02 do
            if not fName.Parent then break end
            fGrad.Rotation = i * 360
            task.wait(0.05)
        end
    end
end)

task.spawn(function()
    while floatBtn.Parent do
        task.wait(0.05)
        local hue = (tick() * 0.3) % 1
        fbStrk.Color = Color3.fromHSV(hue, 1, 1)
    end
end)

-- DRAG FLOAT
local dragF = false
local dragFStart, dragFPos
floatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragF = true
        dragFStart = input.Position
        dragFPos = floatBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragF = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragF and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragFStart
        floatBtn.Position = UDim2.new(dragFPos.X.Scale, dragFPos.X.Offset + d.X, dragFPos.Y.Scale, dragFPos.Y.Offset + d.Y)
    end
end)

-- MAIN WINDOW
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 440, 0, 420)
main.Position = UDim2.new(0.5, -220, 0.5, -210)
main.BackgroundColor3 = C.BG
main.BackgroundTransparency = 0.05
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui
rnd(main, 14)
local mainStrk = strk(main, C.ACC, 2)

-- HEADER
local head = Instance.new("Frame")
head.Size = UDim2.new(1, 0, 0, 42)
head.BackgroundColor3 = C.PANEL
head.BorderSizePixel = 0
head.Parent = main
rnd(head, 14)

local hPatch = Instance.new("Frame")
hPatch.Size = UDim2.new(1, 0, 0, 20)
hPatch.Position = UDim2.new(0, 0, 1, -20)
hPatch.BackgroundColor3 = C.PANEL
hPatch.BorderSizePixel = 0
hPatch.Parent = head

local nLine = Instance.new("Frame")
nLine.Size = UDim2.new(1, -30, 0, 2)
nLine.Position = UDim2.new(0, 15, 1, -1)
nLine.BackgroundColor3 = C.ACC
nLine.BorderSizePixel = 0
nLine.Parent = head
local nGrad = Instance.new("UIGradient")
nGrad.Color = rainbowSeq()
nGrad.Parent = nLine

task.spawn(function()
    while nLine.Parent do
        for i = 0, 1, 0.02 do
            if not nLine.Parent then break end
            nGrad.Rotation = i * 360
            task.wait(0.05)
        end
    end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 45, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ ROOORHUB ULTIMATE"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 15
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.new(0,0,0)
title.Parent = head
local tGrad = Instance.new("UIGradient")
tGrad.Color = rainbowSeq()
tGrad.Parent = title

task.spawn(function()
    while title.Parent do
        for i = 0, 1, 0.02 do
            if not title.Parent then break end
            tGrad.Rotation = i * 360
            task.wait(0.05)
        end
    end
end)

local closeB = Instance.new("TextButton")
closeB.Size = UDim2.new(0, 24, 0, 24)
closeB.Position = UDim2.new(1, -32, 0.5, -12)
closeB.BackgroundColor3 = C.PANEL
closeB.Text = "✕"
closeB.TextColor3 = C.RED
closeB.TextSize = 14
closeB.Font = Enum.Font.GothamBold
closeB.BorderSizePixel = 0
closeB.AutoButtonColor = false
closeB.Parent = head
rnd(closeB, 6)
strk(closeB, C.RED, 1, 0.6)
closeB.MouseButton1Click:Connect(function()
    main.Visible = false
    floatBtn.Visible = true
end)

floatBtn.MouseButton1Click:Connect(function()
    floatBtn.Visible = false
    main.Visible = true
end)

-- SIDEBAR
local sb = Instance.new("Frame")
sb.Size = UDim2.new(0, 115, 1, -62)
sb.Position = UDim2.new(0, 10, 0, 52)
sb.BackgroundColor3 = C.PANEL
sb.BackgroundTransparency = 0.3
sb.BorderSizePixel = 0
sb.Parent = main
rnd(sb, 10)
strk(sb, C.ACC4, 1, 0.7)

local sbL = Instance.new("UIListLayout")
sbL.Padding = UDim.new(0, 4)
sbL.SortOrder = Enum.SortOrder.LayoutOrder
sbL.Parent = sb

local sbP = Instance.new("UIPadding")
sbP.PaddingTop = UDim.new(0, 6)
sbP.PaddingLeft = UDim.new(0, 5)
sbP.PaddingRight = UDim.new(0, 5)
sbP.Parent = sb

-- CONTENT
local ct = Instance.new("Frame")
ct.Size = UDim2.new(1, -145, 1, -62)
ct.Position = UDim2.new(0, 135, 0, 52)
ct.BackgroundColor3 = C.PANEL
ct.BackgroundTransparency = 0.3
ct.BorderSizePixel = 0
ct.Parent = main
rnd(ct, 10)
strk(ct, C.ACC2, 1, 0.7)

-- 🔥 CONTENT SCROLL (ZINDEX TINGGI BIAR DROPDOWN MUNCUL DI ATAS)
local cs = Instance.new("ScrollingFrame")
cs.Size = UDim2.new(1, -14, 1, -14)
cs.Position = UDim2.new(0, 7, 0, 7)
cs.BackgroundTransparency = 1
cs.BorderSizePixel = 0
cs.ScrollBarThickness = 3
cs.ScrollBarImageColor3 = C.ACC
cs.CanvasSize = UDim2.new(0, 0, 0, 0)
cs.AutomaticCanvasSize = Enum.AutomaticSize.Y
cs.Parent = ct

local csL = Instance.new("UIListLayout")
csL.Padding = UDim.new(0, 5)
csL.SortOrder = Enum.SortOrder.LayoutOrder
csL.Parent = cs

-- TAB SYSTEM
local activeTab = nil
function makeTab(name, icon, order, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = C.BG
    b.BackgroundTransparency = 1
    b.Text = ""
    b.BorderSizePixel = 0
    b.LayoutOrder = order
    b.AutoButtonColor = false
    b.Parent = sb
    rnd(b, 7)
    local ind = Instance.new("Frame")
    ind.Size = UDim2.new(0, 3, 0, 0)
    ind.Position = UDim2.new(0, 0, 0.5, 0)
    ind.AnchorPoint = Vector2.new(0, 0.5)
    ind.BackgroundColor3 = C.ACC
    ind.BorderSizePixel = 0
    ind.Parent = b
    rnd(ind, 2)
    local ico = Instance.new("TextLabel")
    ico.Size = UDim2.new(0, 20, 1, 0)
    ico.Position = UDim2.new(0, 8, 0, 0)
    ico.BackgroundTransparency = 1
    ico.Text = icon
    ico.TextColor3 = C.DIM
    ico.TextSize = 12
    ico.Font = Enum.Font.GothamBold
    ico.Parent = b
    local lblT = Instance.new("TextLabel")
    lblT.Size = UDim2.new(1, -32, 1, 0)
    lblT.Position = UDim2.new(0, 32, 0, 0)
    lblT.BackgroundTransparency = 1
    lblT.Text = string.upper(name)
    lblT.TextColor3 = C.DIM
    lblT.TextSize = 9
    lblT.Font = Enum.Font.GothamBlack
    lblT.TextXAlignment = Enum.TextXAlignment.Left
    lblT.Parent = b
    b.MouseButton1Click:Connect(function()
        if activeTab == b then return end
        if activeTab then
            activeTab.BackgroundTransparency = 1
            for _, c in pairs(activeTab:GetChildren()) do
                if c:IsA("TextLabel") then c.TextColor3 = C.DIM end
            end
            local oldInd = activeTab:FindFirstChildOfClass("Frame")
            if oldInd then oldInd.Size = UDim2.new(0, 3, 0, 0) end
        end
        activeTab = b
        b.BackgroundTransparency = 0.75
        ind.Size = UDim2.new(0, 3, 0, 18)
        for _, c in pairs(b:GetChildren()) do
            if c:IsA("TextLabel") then c.TextColor3 = C.TXT end
        end
        for _, c in pairs(cs:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
        if cb then pcall(cb) end
        task.wait(0.1)
        if syncToggles then syncToggles() end
    end)
end

-- COMPONENTS
function sec(title, icon)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 22)
    f.BackgroundTransparency = 1
    f.Parent = cs
    local deco = Instance.new("Frame")
    deco.Size = UDim2.new(0, 3, 0, 14)
    deco.Position = UDim2.new(0, 4, 0.5, -7)
    deco.BackgroundColor3 = C.ACC
    deco.BorderSizePixel = 0
    deco.Parent = f
    rnd(deco, 2)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -16, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = icon .. "  " .. string.upper(title)
    l.TextColor3 = C.ACC3
    l.TextSize = 10
    l.Font = Enum.Font.GothamBlack
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
end

function lbl(text, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -4, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or C.DIM
    l.TextSize = 9
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = cs
end

-- 🔥 TOGGLE DENGAN STATE SYNC
function tog(name, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 28)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.ACC, 1, 0.8)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local t = Instance.new("Frame")
    t.Size = UDim2.new(0, 32, 0, 16)
    t.Position = UDim2.new(1, -42, 0.5, -8)
    t.BorderSizePixel = 0
    t.Parent = f
    rnd(t, 8)
    local k = Instance.new("Frame")
    k.Size = UDim2.new(0, 12, 0, 12)
    k.BorderSizePixel = 0
    k.Parent = t
    rnd(k, 6)

    local savedState = _G.ToggleStates[name]
    local state
    if savedState ~= nil then
        state = savedState
    else
        state = def
        _G.ToggleStates[name] = state
    end

    t.BackgroundColor3 = state and C.ACC or C.PANEL
    local tS = strk(t, state and C.ACC2 or C.DIM, 1, 0.5)
    k.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    k.BackgroundColor3 = state and C.ACC2 or C.DIM

    _G.ToggleObjects[name] = {
        setState = function(newState)
            state = newState
            _G.ToggleStates[name] = newState
            k.Position = newState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            k.BackgroundColor3 = newState and C.ACC2 or C.DIM
            t.BackgroundColor3 = newState and C.ACC or C.PANEL
            tS.Color = newState and C.ACC2 or C.DIM
        end
    }

    local cB = Instance.new("TextButton")
    cB.Size = UDim2.new(1, 0, 1, 0)
    cB.BackgroundTransparency = 1
    cB.Text = ""
    cB.Parent = t
    cB.MouseButton1Click:Connect(function()
        state = not state
        _G.ToggleStates[name] = state
        k.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        k.BackgroundColor3 = state and C.ACC2 or C.DIM
        t.BackgroundColor3 = state and C.ACC or C.PANEL
        tS.Color = state and C.ACC2 or C.DIM
        if cb then pcall(cb, state) end
    end)
end

function syncToggles()
    for name, obj in pairs(_G.ToggleObjects) do
        if obj.setState and _G.ToggleStates[name] ~= nil then
            obj.setState(_G.ToggleStates[name])
        end
    end
end

-- 🔥 DROPDOWN FIX (PASTI MUNCUL)
function drp(name, options, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 28)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.ACC, 1, 0.8)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.5, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local savedValue = _G.DropdownStates[name]
    local cur = savedValue or def or options[1]
    _G.DropdownStates[name] = cur

    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0.5, -20, 1, 0)
    v.Position = UDim2.new(0.5, 0, 0, 0)
    v.BackgroundTransparency = 1
    v.Text = tostring(cur)
    v.TextColor3 = C.ACC2
    v.TextSize = 9
    v.Font = Enum.Font.GothamBold
    v.TextXAlignment = Enum.TextXAlignment.Right
    v.Parent = f

    local cB = Instance.new("TextButton")
    cB.Size = UDim2.new(1, 0, 1, 0)
    cB.BackgroundTransparency = 1
    cB.Text = ""
    cB.Parent = f

    -- LIST
    local listOpen = false
    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.Position = UDim2.new(0, 0, 1, 4)
    listFrame.BackgroundColor3 = C.PANEL
    listFrame.BorderSizePixel = 0
    listFrame.Visible = false
    listFrame.ZIndex = 100
    listFrame.Parent = gui  -- 🔥 PARENT KE GUI (biar muncul di atas semua)
    rnd(listFrame, 8)
    strk(listFrame, C.ACC2, 1.5)

    local listScroll = Instance.new("ScrollingFrame")
    listScroll.Size = UDim2.new(1, -4, 1, -4)
    listScroll.Position = UDim2.new(0, 2, 0, 2)
    listScroll.BackgroundTransparency = 1
    listScroll.BorderSizePixel = 0
    listScroll.ScrollBarThickness = 2
    listScroll.ScrollBarImageColor3 = C.ACC
    listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listScroll.Parent = listFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = listScroll

    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, -4, 0, 22)
        optBtn.BackgroundColor3 = C.BG
        optBtn.BackgroundTransparency = 0.5
        optBtn.Text = opt
        optBtn.TextColor3 = C.TXT
        optBtn.TextSize = 9
        optBtn.Font = Enum.Font.GothamMedium
        optBtn.BorderSizePixel = 0
        optBtn.AutoButtonColor = false
        optBtn.LayoutOrder = i
        optBtn.Parent = listScroll
        rnd(optBtn, 4)
        optBtn.MouseButton1Click:Connect(function()
            cur = opt
            _G.DropdownStates[name] = cur
            v.Text = tostring(cur)
            listFrame.Visible = false
            listOpen = false
            if cb then pcall(cb, cur) end
        end)
    end

    cB.MouseButton1Click:Connect(function()
        listOpen = not listOpen
        if listOpen then
            -- 🔥 POSISI LIST (di bawah dropdown)
            local absPos = f.AbsolutePosition
            local absSize = f.AbsoluteSize
            local h = math.min(#options * 24 + 8, 250)
            listFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
            listFrame.Size = UDim2.new(0, absSize.X, 0, h)
            listFrame.Visible = true
        else
            listFrame.Visible = false
        end
    end)
end

-- 🔥 SLIDER DENGAN STATE SYNC
function sl(name, min, max, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 38)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.ACC, 1, 0.8)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 0, 16)
    l.Position = UDim2.new(0, 10, 0, 3)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 9
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local savedValue = _G.SliderStates[name]
    local curVal = savedValue or def
    _G.SliderStates[name] = curVal

    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0, 35, 0, 16)
    v.Position = UDim2.new(1, -42, 0, 3)
    v.BackgroundTransparency = 1
    v.Text = tostring(curVal)
    v.TextColor3 = C.ACC2
    v.TextSize = 9
    v.Font = Enum.Font.GothamBold
    v.TextXAlignment = Enum.TextXAlignment.Right
    v.Parent = f
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -20, 0, 4)
    bg.Position = UDim2.new(0, 10, 1, -10)
    bg.BackgroundColor3 = C.PANEL
    bg.BorderSizePixel = 0
    bg.Parent = f
    rnd(bg, 2)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((curVal - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = C.ACC
    fill.BorderSizePixel = 0
    fill.Parent = bg
    rnd(fill, 2)
    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 10, 0, 10)
    kn.Position = UDim2.new((curVal - min) / (max - min), -5, 0.5, -5)
    kn.BackgroundColor3 = C.TXT
    kn.BorderSizePixel = 0
    kn.ZIndex = 2
    kn.Parent = bg
    rnd(kn, 5)
    local drag = false
    local function upd(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local val = math.floor((min + (max - min) * pos) * 100 + 0.5) / 100
        _G.SliderStates[name] = val
        fill.Size = UDim2.new(pos, 0, 1, 0)
        kn.Position = UDim2.new(pos, -5, 0.5, -5)
        v.Text = tostring(val)
        if cb then pcall(cb, val) end
    end
    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true
            upd(input)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            upd(input)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
end

function cpk(name, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 28)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.ACC, 1, 0.8)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local cB = Instance.new("TextButton")
    cB.Size = UDim2.new(0, 32, 0, 16)
    cB.Position = UDim2.new(1, -42, 0.5, -8)
    cB.BackgroundColor3 = def
    cB.Text = ""
    cB.BorderSizePixel = 0
    cB.Parent = f
    rnd(cB, 4)
    strk(cB, C.ACC2, 1.5)
    local presets = {
        Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 170, 0),
        Color3.fromRGB(255, 255, 0), Color3.fromRGB(60, 255, 120),
        Color3.fromRGB(0, 200, 255), Color3.fromRGB(150, 80, 255),
        Color3.fromRGB(255, 50, 130), Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(20, 20, 20),
    }
    local idx = 1
    cB.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #presets then idx = 1 end
        local c = presets[idx]
        cB.BackgroundColor3 = c
        if cb then pcall(cb, c) end
    end)
end

function btn(name, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -4, 0, 28)
    b.BackgroundColor3 = C.BG
    b.BackgroundTransparency = 0.3
    b.Text = name
    b.TextColor3 = C.TXT
    b.TextSize = 10
    b.Font = Enum.Font.GothamMedium
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = cs
    rnd(b, 8)
    strk(b, C.ACC2, 1, 0.7)
    b.MouseButton1Click:Connect(function()
        if cb then pcall(cb) end
    end)
end

-- DRAG WINDOW
local dragW = false
local dragWStart, dragWPos
head.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragW = true
        dragWStart = input.Position
        dragWPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragW = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragW and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragWStart
        main.Position = UDim2.new(dragWPos.X.Scale, dragWPos.X.Offset + d.X, dragWPos.Y.Scale, dragWPos.Y.Offset + d.Y)
    end
end)

-- AUTO SYNC
task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if syncToggles then pcall(syncToggles) end
    end
end)

print("✅ [2/6] GUI + Components + Dropdown FIX loaded")-- =========================================================
-- BAGIAN 3/6 : FIRE KEPALA + ESP LENGKAP
-- =========================================================

-- ============== FIRE DI KEPALA ==============
function clearFire()
    if not LP.Character then return end
    local head = LP.Character:FindFirstChild("Head")
    if not head then return end
    for _, obj in pairs(head:GetChildren()) do
        if obj.Name == "RoooorFire" or obj.Name == "RoooorSmoke"
        or obj.Name == "RoooorSparkles" or obj.Name == "RoooorPointLight" then
            obj:Destroy()
        end
    end
end

function applyFire()
    clearFire()
    if not S.FireOn then return end
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local cfg = FireConfig[S.FireType] or FireConfig.Classic

    -- 🔥 FIRE DI KEPALA
    local fire = Instance.new("Fire")
    fire.Name = "RoooorFire"
    fire.Size = S.FireSize
    fire.Heat = 10
    fire.Color = cfg.c1
    fire.SecondaryColor = cfg.c2
    fire.Parent = head

    -- Smoke
    if cfg.smoke then
        local smoke = Instance.new("Smoke")
        smoke.Name = "RoooorSmoke"
        smoke.Size = S.FireSize + 2
        smoke.RiseVelocity = 3
        smoke.Opacity = 0.4
        smoke.Color = cfg.smokeColor or Color3.fromRGB(50, 50, 50)
        smoke.Parent = head
    end

    -- Sparkles
    if cfg.spark then
        local spark = Instance.new("Sparkles")
        spark.Name = "RoooorSparkles"
        spark.SparkleColor = cfg.c2
        spark.SparkleSize = 1
        spark.Parent = head
    end

    -- PointLight
    if cfg.light then
        local light = Instance.new("PointLight")
        light.Name = "RoooorPointLight"
        light.Color = cfg.light
        light.Range = 15
        light.Brightness = 2
        light.Parent = head
    end

    print("[RoooorHub] Fire applied:", S.FireType)
end

-- Rainbow fire animation
task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        if S.FireOn and LP.Character then
            local head = LP.Character:FindFirstChild("Head")
            local fire = head and head:FindFirstChild("RoooorFire")
            if fire then
                local cfg = FireConfig[S.FireType] or FireConfig.Classic
                if cfg.rainbow then
                    local t = tick()
                    fire.Color = Color3.fromHSV((t * 0.5) % 1, 1, 1)
                    fire.SecondaryColor = Color3.fromHSV(((t * 0.5) + 0.5) % 1, 1, 1)
                    local light = head:FindFirstChild("RoooorPointLight")
                    if light then
                        light.Color = Color3.fromHSV((t * 0.5) % 1, 1, 1)
                    end
                end
            end
        end
    end
end)

-- ============== ESP SYSTEM ==============
local ESPObjects = {}
local StatusESP = {}

-- Object Cache
local Cached = {
    Generators = {},
    Windows = {},
    Pallets = {},
    SCPs = {}
}

local function cacheObject(obj)
    if obj.Name == "Generator" then
        Cached.Generators[obj] = true
    elseif obj.Name == "Window" then
        Cached.Windows[obj] = true
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        Cached.Pallets[obj] = true
    elseif string.find(string.lower(obj.Name), "scp") then
        Cached.SCPs[obj] = true
    end
end

local function removeCache(obj)
    Cached.Generators[obj] = nil
    Cached.Windows[obj] = nil
    Cached.Pallets[obj] = nil
    Cached.SCPs[obj] = nil
end

for _, obj in ipairs(workspace:GetDescendants()) do
    cacheObject(obj)
end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(removeCache)

-- Create Highlight
function createESP(obj, color)
    if not obj then return end
    if ESPObjects[obj] then
        ESPObjects[obj].FillColor = color
        ESPObjects[obj].OutlineColor = color
        return
    end
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.7
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = obj
    ESPObjects[obj] = h
    obj.AncestryChanged:Connect(function(_, parent)
        if not parent and ESPObjects[obj] then
            ESPObjects[obj]:Destroy()
            ESPObjects[obj] = nil
        end
    end)
end

function removeESP(obj)
    if ESPObjects[obj] then
        ESPObjects[obj]:Destroy()
        ESPObjects[obj] = nil
    end
end

-- ESP Nama + Status
function createStatusESP(player, char, root)
    if not S.ESP_Name then
        if StatusESP[char] then
            StatusESP[char]:Destroy()
            StatusESP[char] = nil
        end
        return
    end
    if not root then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    local isDown = hum.Health <= 0 or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true

    local dist = (head.Position - root.Position).Magnitude
    if dist > S.ESP_Radius then
        if StatusESP[char] then
            StatusESP[char]:Destroy()
            StatusESP[char] = nil
        end
        return
    end

    local text = ""
    if isDown then text = "🔻 DOWN\n" end
    if S.ESP_ShowName then text = text .. player.Name .. "\n" end
    if S.ESP_ShowDist then text = text .. string.format("[%.0f]", dist) .. "\n" end
    if S.ESP_ShowHP then text = text .. string.format("HP: %.0f", hum.Health) end
    if text == "" then text = player.Name end

    local color = S.ESP_DefaultColor
    if player.Team then
        if player.Team.Name == "Killer" then
            color = S.ESP_KillerColor
        elseif player.Team.Name == "Survivors" then
            color = S.ESP_SurvivorColor
        end
    end
    if isDown then color = Color3.fromRGB(255, 0, 0) end

    local billboard = StatusESP[char]
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "RoooorESP"
        billboard.Size = UDim2.new(0, 150, 0, 60)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = color
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = S.ESP_Size
        label.Text = text
        label.Parent = billboard

        billboard.Adornee = head
        billboard.Parent = char
        StatusESP[char] = billboard
    else
        local label = billboard:FindFirstChildOfClass("TextLabel")
        if label then
            label.Text = text
            label.TextColor3 = color
            label.TextSize = S.ESP_Size
        end
    end
end

function removeStatusESP(char)
    if StatusESP[char] then
        StatusESP[char]:Destroy()
        StatusESP[char] = nil
    end
end

function GetGameValue(obj, name)
    if not obj then return nil end
    local attr = obj:GetAttribute(name)
    if attr ~= nil then return attr end
    local child = obj:FindFirstChild(name)
    if child then
        local s, v = pcall(function() return child.Value end)
        if s then return v end
    end
    return nil
end

-- ESP Generator
function updateGenerator(gen)
    if not gen or not gen.Parent then return end
    if not S.ESP_Generator then
        local old = gen:FindFirstChild("GenESP")
        if old then old:Destroy() end
        removeESP(gen)
        return
    end
    local percent = GetGameValue(gen, "RepairProgress") or GetGameValue(gen, "Progress") or 0
    local billboard = gen:FindFirstChild("GenESP")

    if percent >= 100 then
        if billboard then billboard:Destroy() end
        return
    end

    local color = S.ESP_GenColor
    local text = string.format("[%.0f%%]", percent)

    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "GenESP"
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.AlwaysOnTop = true
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = color
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = S.ESP_Size
        label.Parent = billboard
        billboard.Adornee = gen
        billboard.Parent = gen
    else
        local lbl = billboard:FindFirstChildOfClass("TextLabel")
        if lbl then
            lbl.Text = text
            lbl.TextColor3 = color
            lbl.TextSize = S.ESP_Size
        end
    end
    createESP(gen, color)
end

-- ESP Pallet
function updatePallet(obj, root)
    if not obj or not root then return end
    local pos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
    if not pos then return end
    if S.ESP_Pallet and (pos - root.Position).Magnitude <= S.ESP_Radius then
        createESP(obj, S.ESP_PalletColor)
    else
        removeESP(obj)
    end
end

-- ESP Window
function updateWindow(obj, root)
    if not obj or not root then return end
    local pos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
    if not pos then return end
    if S.ESP_Window and (pos - root.Position).Magnitude <= S.ESP_Radius then
        createESP(obj, S.ESP_WindowColor)
    else
        removeESP(obj)
    end
end

-- ESP SCP
function updateSCP(obj, root)
    if not obj or not root then return end
    local pos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
    if not pos then return end
    if S.ESP_SCP and (pos - root.Position).Magnitude <= S.ESP_Radius then
        createESP(obj, S.ESP_SCPColor)
    else
        removeESP(obj)
    end
end

print("✅ [3/6] Fire Kepala + ESP Lengkap loaded")-- =========================================================
-- BAGIAN 4/6 : AUTO PARRY 360° + CIRCLE + SKILLCHECK
-- =========================================================

-- ============== AUTO PARRY 360° (SEMUA ARAH) ==============
local lastParry = 0
local PARRY_DEBOUNCE = 0.05
_G.ParryActive = false
_G.HookedKillers = _G.HookedKillers or {}

-- Cache parry button
local ParryButtonCache = nil
function GetParryButton()
    if ParryButtonCache and ParryButtonCache.Parent then
        return ParryButtonCache
    end
    local current = PG
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    ParryButtonCache = current
    return current
end

-- Press Parry (3 fallback)
function pressParryButton()
    -- Prioritas 1: Mobile
    if UIS.TouchEnabled then
        local btn = GetParryButton()
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = GuiService:GetGuiInset()
            local x = pos.X + size.X/2 + inset.X
            local y = pos.Y + size.Y/2 + inset.Y
            pcall(function()
                VirtualInputManager:SendTouchEvent(8823, 0, x, y)
                VirtualInputManager:SendTouchEvent(8823, 2, x, y)
            end)
            return
        end
    end
    -- Prioritas 2: PC Right-Click
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
    end)
    -- Prioritas 3: Remote fallback
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local combat = remotes:FindFirstChild("Combat")
                or remotes:FindFirstChild("Attacks")
                or remotes:FindFirstChild("Parry")
            if combat then
                local parry = combat:FindFirstChild("Parry")
                    or combat:FindFirstChild("ParryEvent")
                    or combat:FindFirstChild("BasicParry")
                if parry then parry:FireServer() end
            end
        end
    end)
end

-- DO PARRY
function doParry()
    local now = tick()
    if now - lastParry < PARRY_DEBOUNCE then return end
    lastParry = now
    _G.ParryActive = true
    pressParryButton()
    task.delay(0.05, function() _G.ParryActive = false end)
end

-- Range check (TANPA FACING - 360°)
function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end
    local dist = (enemyRoot.Position - myRoot.Position).Magnitude
    return dist <= S.ParryDist and dist > 0.5
end

-- Hook Killer (2 method: Event + Prediction Loop 360°)
function hookKiller(char)
    if _G.HookedKillers[char] then return end
    _G.HookedKillers[char] = true

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    -- METHOD 1: Event AnimationPlayed
    animator.AnimationPlayed:Connect(function(track)
        if not S.Parry then return end
        if _G.ParryActive then return end
        local anim = track.Animation
        if not anim then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end
        if KillerAnims["rbxassetid://"..id] then
            if isInParryRange(char) then
                doParry()
            end
        end
    end)

    -- 🔥 METHOD 2: Prediction Loop (360° - SEMUA ARAH)
    task.spawn(function()
        while _G.HookedKillers[char] and char.Parent do
            task.wait(0.03)  -- Cek tiap 30ms (ringan)
            if not S.Parry then break end
            if _G.ParryActive then continue end

            -- Cek jarak DULU (hemat performa)
            if not isInParryRange(char) then continue end

            -- Cek animasi (semua arah, gak peduli facing)
            local playing = animator:GetPlayingAnimationTracks()
            for _, track in ipairs(playing) do
                local anim = track.Animation
                if anim then
                    local id = anim.AnimationId:match("%d+")
                    if id then
                        local fullId = "rbxassetid://" .. id
                        if KillerAnims[fullId] then
                            doParry()
                            break
                        end
                    end
                end
            end
        end
    end)
end

function scanKillers()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
            hookKiller(p.Character)
        end
    end
end

-- Auto scan tiap 0.2 detik
task.spawn(function()
    while gui.Parent do
        task.wait(0.2)
        if S.Parry then scanKillers() end
    end
end)

-- ============== PARRY CIRCLE ==============
_G.ParryCirclePart = nil
function updateParryCircle()
    local root = getRoot()
    if not S.ParryCircle or not root then
        if _G.ParryCirclePart then
            _G.ParryCirclePart:Destroy()
            _G.ParryCirclePart = nil
        end
        return
    end
    if not _G.ParryCirclePart then
        _G.ParryCirclePart = Instance.new("Part")
        _G.ParryCirclePart.Shape = Enum.PartType.Cylinder
        _G.ParryCirclePart.Anchored = true
        _G.ParryCirclePart.CanCollide = false
        _G.ParryCirclePart.Material = Enum.Material.Neon
        _G.ParryCirclePart.Name = "RoooorParryCircle"
        _G.ParryCirclePart.Parent = workspace
    end
    local size = S.ParryCircleSize * 2
    _G.ParryCirclePart.Size = Vector3.new(0.1, size, size)
    local yOffset = root.Size.Y / 2 + 1.5
    _G.ParryCirclePart.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0))
        * CFrame.Angles(0, 0, math.rad(90))
    _G.ParryCirclePart.Color = Color3.fromRGB(255, 80, 80)
    _G.ParryCirclePart.Transparency = 0.5
end

-- ============== AUTO SKILL CHECK ==============
_G.SkillConn = nil
local skillBusy = false
local TouchID = 8822
local ActionPath = "Survivor-mob.Controls.action.check"

-- Cache action button
local ActionButtonCache = nil
function GetActionTarget()
    if ActionButtonCache and ActionButtonCache.Parent then
        return ActionButtonCache
    end
    local current = PG
    for segment in string.gmatch(ActionPath, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    ActionButtonCache = current
    return current
end

function pressSpace()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end

function TriggerMobileButton()
    local b = GetActionTarget()
    if b and b:IsA("GuiObject") then
        local p, s, i = b.AbsolutePosition, b.AbsoluteSize, GuiService:GetGuiInset()
        local cx, cy = p.X + (s.X/2) + i.X, p.Y + (s.Y/2) + i.Y
        pcall(function()
            VirtualInputManager:SendTouchEvent(TouchID, 0, cx, cy)
            VirtualInputManager:SendTouchEvent(TouchID, 2, cx, cy)
        end)
    end
end

function startSkillCheck()
    if _G.SkillConn then _G.SkillConn:Disconnect() end
    _G.SkillConn = RunService.RenderStepped:Connect(function()
        if not S.Skill or skillBusy then return end
        local prompt = PG:FindFirstChild("SkillCheckPromptGui")
        if not prompt then return end
        local check = prompt:FindFirstChild("Check")
        if not check or not check.Visible then return end
        local line = check:FindFirstChild("Line")
        local goal = check:FindFirstChild("Goal")
        if not line or not goal then return end

        local lr = line.Rotation % 360
        local gr = goal.Rotation % 360
        local startRange = (gr + 102) % 360
        local endRange = (gr + 116) % 360
        local success = (startRange > endRange and (lr >= startRange or lr <= endRange))
            or (lr >= startRange and lr <= endRange)

        if success then
            skillBusy = true
            task.spawn(function()
                if UIS.TouchEnabled then
                    TriggerMobileButton()
                else
                    pressSpace()
                end
                task.wait(0.05)
                skillBusy = false
            end)
        end
    end)
end

print("✅ [4/6] Parry 360° + Circle + SkillCheck loaded")-- =========================================================
-- BAGIAN 5/6 : ULTRA HD + CONTRAST
-- =========================================================

-- ============== ULTRA HD ==============
local origSettings = {
    QualityLevel = nil,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
}

pcall(function()
    origSettings.QualityLevel = settings().Rendering.QualityLevel
end)

function applyUltraHD()
    if S.UltraHD then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
        end)

        Lighting.GlobalShadows = true
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.Ambient = Color3.fromRGB(100, 100, 100)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)

        if not _G.RoooorHD then
            _G.RoooorHD = Instance.new("ColorCorrectionEffect")
            _G.RoooorHD.Name = "RoooorHD"
            _G.RoooorHD.Parent = Lighting
        end
        _G.RoooorHD.Contrast = 0.2
        _G.RoooorHD.Brightness = 0.05
        _G.RoooorHD.Saturation = 0.15

        if not _G.RoooorBloom then
            _G.RoooorBloom = Instance.new("BloomEffect")
            _G.RoooorBloom.Name = "RoooorBloom"
            _G.RoooorBloom.Intensity = 0.4
            _G.RoooorBloom.Size = 20
            _G.RoooorBloom.Threshold = 1
            _G.RoooorBloom.Parent = Lighting
        end

        if not _G.RoooorSunRays then
            _G.RoooorSunRays = Instance.new("SunRaysEffect")
            _G.RoooorSunRays.Name = "RoooorSunRays"
            _G.RoooorSunRays.Intensity = 0.1
            _G.RoooorSunRays.Spread = 1
            _G.RoooorSunRays.Parent = Lighting
        end
    else
        pcall(function()
            if origSettings.QualityLevel then
                settings().Rendering.QualityLevel = origSettings.QualityLevel
            end
        end)

        Lighting.GlobalShadows = origSettings.GlobalShadows
        Lighting.Brightness = origSettings.Brightness
        Lighting.ClockTime = origSettings.ClockTime
        Lighting.FogEnd = origSettings.FogEnd
        Lighting.FogStart = origSettings.FogStart
        Lighting.Ambient = origSettings.Ambient
        Lighting.OutdoorAmbient = origSettings.OutdoorAmbient

        if _G.RoooorHD then _G.RoooorHD:Destroy(); _G.RoooorHD = nil end
        if _G.RoooorBloom then _G.RoooorBloom:Destroy(); _G.RoooorBloom = nil end
        if _G.RoooorSunRays then _G.RoooorSunRays:Destroy(); _G.RoooorSunRays = nil end
    end
end

-- ============== CONTRAST ==============
_G.ContrastFx = nil

function applyContrast()
    if S.Contrast then
        if not _G.ContrastFx then
            _G.ContrastFx = Instance.new("ColorCorrectionEffect")
            _G.ContrastFx.Name = "RoooorContrast"
            _G.ContrastFx.Parent = Lighting
        end
        _G.ContrastFx.Contrast = S.ContrastVal
        _G.ContrastFx.Brightness = S.BrightnessVal
        _G.ContrastFx.Saturation = S.SaturationVal
    else
        if _G.ContrastFx then
            _G.ContrastFx:Destroy()
            _G.ContrastFx = nil
        end
    end
end

print("✅ [5/6] Ultra HD + Contrast loaded")-- =========================================================
-- BAGIAN 6/6 : ISI TAB + MAIN LOOP + FINAL
-- =========================================================

-- TAB 1 : INFO
makeTab("Info", "ℹ️", 1, function()
    sec("Script Info", "📋")
    lbl("RoooorHub Ultimate", C.ACC2)
    lbl("Status: Active", C.GRN)
    lbl("Dev: Roooor", C.TXT)
    sec("FPS/Ping", "🌊")
    tog("Show FPS/Ping", true, function(s) S.FPS = s end)
end)

-- TAB 2 : FIRE
makeTab("Fire", "🔥", 2, function()
    sec("Fire di Kepala (60 Varian)", "🔥")
    tog("Enable Fire", false, function(s)
        S.FireOn = s
        applyFire()
    end)
    drp("Fire Type", FireList, "Classic", function(v)
        S.FireType = v
        applyFire()
    end)
    sl("Fire Size", 1, 15, 5, function(v)
        S.FireSize = v
        applyFire()
    end)
    lbl("Klik dropdown untuk pilih efek", C.ACC2)
    lbl("60 efek fire di kepala", C.DIM)
end)

-- TAB 3 : ESP
makeTab("ESP", "👁️", 3, function()
    sec("Player ESP", "🟢")
    tog("ESP Player + Nama", false, function(s)
        S.ESP_Name = s
        if not s then
            for _, bb in pairs(StatusESP) do
                if bb then bb:Destroy() end
            end
            StatusESP = {}
        end
    end)
    tog("Show Name", true, function(s) S.ESP_ShowName = s end)
    tog("Show Distance", true, function(s) S.ESP_ShowDist = s end)
    tog("Show Health", false, function(s) S.ESP_ShowHP = s end)
    sl("Nama Size", 8, 40, 12, function(v) S.ESP_Size = v end)
    sl("ESP Radius", 50, 2000, 500, function(v) S.ESP_Radius = v end)
    cpk("Default Color", S.ESP_DefaultColor, function(c) S.ESP_DefaultColor = c end)
    cpk("Killer Color", S.ESP_KillerColor, function(c) S.ESP_KillerColor = c end)
    cpk("Survivor Color", S.ESP_SurvivorColor, function(c) S.ESP_SurvivorColor = c end)

    sec("Generator ESP", "⚡")
    tog("ESP Generator", false, function(s) S.ESP_Generator = s end)
    cpk("Gen Color", S.ESP_GenColor, function(c) S.ESP_GenColor = c end)

    sec("Pallet ESP", "🪵")
    tog("ESP Pallet", false, function(s) S.ESP_Pallet = s end)
    cpk("Pallet Color", S.ESP_PalletColor, function(c) S.ESP_PalletColor = c end)

    sec("Window ESP", "🪟")
    tog("ESP Window", false, function(s) S.ESP_Window = s end)
    cpk("Window Color", S.ESP_WindowColor, function(c) S.ESP_WindowColor = c end)

    sec("SCP ESP", "👹")
    tog("ESP SCP", false, function(s) S.ESP_SCP = s end)
    cpk("SCP Color", S.ESP_SCPColor, function(c) S.ESP_SCPColor = c end)
end)

-- TAB 4 : SURVIVOR
makeTab("Survivor", "🏃", 4, function()
    sec("Auto Parry 360°", "🛡️")
    tog("Enable Auto Parry", false, function(s)
        S.Parry = s
        if s then scanKillers() end
    end)
    sl("Parry Distance", 3, 15, 8, function(v) S.ParryDist = v end)
    lbl("360° - Semua arah", C.ACC2)
    lbl("Rekomendasi jarak: 8", C.DIM)

    sec("Parry Circle", "🔵")
    tog("Enable Parry Circle", false, function(s) S.ParryCircle = s end)
    sl("Circle Size", 5, 50, 15, function(v) S.ParryCircleSize = v end)

    sec("Auto Skill Check", "🎯")
    tog("Enable Skill Check", false, function(s)
        S.Skill = s
        if s then startSkillCheck() end
    end)
end)

-- TAB 5 : VISUAL
makeTab("Visual", "🎨", 5, function()
    sec("Grafik Ultra HD", "🎨")
    tog("Enable Ultra HD", false, function(s)
        S.UltraHD = s
        applyUltraHD()
    end)
    lbl("Kualitas gambar HD", C.ACC2)
    lbl("Tetap ringan di HP kentang", C.GRN)

    sec("Contrast", "🔍")
    tog("Enable Contrast", false, function(s)
        S.Contrast = s
        applyContrast()
    end)
    sl("Contrast Value", -1, 2, 0.3, function(v) S.ContrastVal = v; applyContrast() end)
    sl("Brightness", -1, 1, 0.1, function(v) S.BrightnessVal = v; applyContrast() end)
    sl("Saturation", -1, 1, 0.2, function(v) S.SaturationVal = v; applyContrast() end)
end)

-- TAB 6 : SETTINGS
makeTab("Settings", "⚙️", 6, function()
    sec("Keybind", "⌨️")
    lbl("RightShift = Toggle Menu", C.ACC2)

    sec("Script", "🚪")
    btn("🔄 Reset Semua Fitur", function()
        S.FireOn = false
        S.ESP_Name = false
        S.Parry = false
        S.ParryCircle = false
        S.Skill = false
        S.UltraHD = false
        S.Contrast = false
        S.ESP_Generator = false
        S.ESP_Pallet = false
        S.ESP_Window = false
        S.ESP_SCP = false
        clearFire()
        applyUltraHD()
        applyContrast()
        if syncToggles then syncToggles() end
    end)

    btn("🚪 Unload Script", function()
        clearFire()
        if _G.RoooorHD then _G.RoooorHD:Destroy() end
        if _G.RoooorBloom then _G.RoooorBloom:Destroy() end
        if _G.RoooorSunRays then _G.RoooorSunRays:Destroy() end
        if _G.ParryCirclePart then _G.ParryCirclePart:Destroy() end
        if _G.ContrastFx then _G.ContrastFx:Destroy() end
        gui:Destroy()
    end)

    sec("Info", "ℹ️")
    lbl("Version: 7.0 Ultimate", C.ACC3)
    lbl("60 Fire + ESP + Parry 360°", C.DIM)
    lbl("Skill + Ultra HD + Contrast", C.DIM)
end)

-- =========================================================
-- FPS/PING
-- =========================================================
local fpsLbl = Instance.new("TextLabel")
fpsLbl.Size = UDim2.new(0, 140, 0, 20)
fpsLbl.Position = UDim2.new(0.5, -70, 0, 5)
fpsLbl.BackgroundColor3 = C.PANEL
fpsLbl.BackgroundTransparency = 0.4
fpsLbl.Text = "FPS: -- | PING: --"
fpsLbl.TextColor3 = C.ACC2
fpsLbl.TextSize = 11
fpsLbl.Font = Enum.Font.GothamBold
fpsLbl.TextStrokeTransparency = 0.5
fpsLbl.Parent = gui
rnd(fpsLbl, 6)
strk(fpsLbl, C.ACC, 1, 0.5)

local fCnt = 0
local tAcc = 0
RunService.RenderStepped:Connect(function(dt)
    fCnt = fCnt + 1
    tAcc = tAcc + dt
    if tAcc >= 1 then
        local fps = math.floor(fCnt / tAcc)
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        if S.FPS then
            fpsLbl.Text = string.format("FPS: %d | PING: %d ms", fps, ping)
        end
        fCnt = 0
        tAcc = 0
    end
end)

-- =========================================================
-- MAIN LOOP
-- =========================================================
local lastESP = 0
local lastParry = 0

task.spawn(function()
    while gui.Parent do
        local now = tick()
        local root = getRoot()

        if root then
            -- ESP UPDATE (tiap 0.2s - hemat performa)
            if now - lastESP >= 0.2 then
                lastESP = now

                -- Player ESP
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            createStatusESP(p, p.Character, root)
                            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local dist = (hrp.Position - root.Position).Magnitude
                                if dist <= S.ESP_Radius and S.ESP_Name then
                                    local color = S.ESP_DefaultColor
                                    if p.Team then
                                        if p.Team.Name == "Killer" then color = S.ESP_KillerColor
                                        elseif p.Team.Name == "Survivors" then color = S.ESP_SurvivorColor end
                                    end
                                    createESP(p.Character, color)
                                else
                                    removeESP(p.Character)
                                end
                            end
                        else
                            removeStatusESP(p.Character)
                            removeESP(p.Character)
                        end
                    end
                end

                -- Generator ESP
                for gen in pairs(Cached.Generators) do
                    if gen and gen.Parent then updateGenerator(gen) end
                end

                -- Pallet ESP
                for obj in pairs(Cached.Pallets) do
                    if obj and obj.Parent then updatePallet(obj, root) end
                end

                -- Window ESP
                for obj in pairs(Cached.Windows) do
                    if obj and obj.Parent then updateWindow(obj, root) end
                end

                -- SCP ESP
                for obj in pairs(Cached.SCPs) do
                    if obj and obj.Parent then updateSCP(obj, root) end
                end
            end

            -- Scan Killers Parry (tiap 1s)
            if S.Parry and now - lastParry >= 1 then
                lastParry = now
                scanKillers()
            end
        end

        -- Update Parry Circle
        updateParryCircle()

        task.wait(0.1)
    end
end)

-- =========================================================
-- RESPAWN HANDLER
-- =========================================================
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    _G.ParryActive = false
    _G.HookedKillers = {}
    ParryButtonCache = nil
    ActionButtonCache = nil
    if S.FireOn then applyFire() end
    if S.Parry then scanKillers() end
    if S.Skill then startSkillCheck() end
    if S.UltraHD then applyUltraHD() end
    if S.Contrast then applyContrast() end
end)

-- =========================================================
-- KEYBIND RightShift
-- =========================================================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if main.Visible then
            main.Visible = false
            floatBtn.Visible = true
        else
            main.Visible = true
            floatBtn.Visible = false
        end
    end
end)

-- =========================================================
-- BUKA TAB PERTAMA
-- =========================================================
task.wait(0.3)
for _, c in pairs(sb:GetChildren()) do
    if c:IsA("TextButton") then
        c.MouseButton1Click:Fire()
        break
    end
end

-- =========================================================
-- NEON ANIMASI
-- =========================================================
task.spawn(function()
    while main.Parent do
        task.wait(0.05)
        local hue = (tick() * 0.3) % 1
        mainStrk.Color = Color3.fromHSV(hue, 1, 1)
        mainStrk.Transparency = 0.4
    end
end)

-- =========================================================
-- FINAL PRINT
-- =========================================================
print("=====================================================")
print("✅ [6/6] FINAL loaded")
print("🎉 ROOORHUB ULTIMATE - LOADED SUCCESSFULLY!")
print("=====================================================")
print("🔥 60 Fire Effect di Kepala (Dropdown)")
print("👁️ ESP Lengkap (Player/Gen/Pallet/Window/SCP)")
print("🎨 ESP Custom Warna + Nama Size Slider")
print("🛡️ Auto Parry 360° (Semua Arah)")
print("🔵 Parry Circle Bulat Garis")
print("🎯 Auto Skill Check (Fallens)")
print("🎨 Ultra HD + Contrast")
print("🔄 State Sync (Toggle/Slider/Dropdown GAK RESET)")
print("=====================================================")
print("⌨️ RightShift = Toggle Menu")
print("=====================================================")
