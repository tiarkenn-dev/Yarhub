-- =========================================================
-- ROOORHUB PREMIUM - BAGIAN 1/12 : SERVICES + CONFIG
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

local C = {
    BG = Color3.fromRGB(8, 6, 16),
    BG2 = Color3.fromRGB(12, 9, 24),
    PANEL = Color3.fromRGB(18, 12, 32),
    PANEL2 = Color3.fromRGB(25, 18, 45),
    ACC = Color3.fromRGB(180, 80, 255),
    ACC2 = Color3.fromRGB(0, 230, 255),
    ACC3 = Color3.fromRGB(255, 50, 180),
    ACC4 = Color3.fromRGB(255, 200, 50),
    TXT = Color3.fromRGB(245, 245, 255),
    DIM = Color3.fromRGB(120, 120, 160),
    GRN = Color3.fromRGB(0, 255, 150),
    RED = Color3.fromRGB(255, 70, 100),
    GOLD = Color3.fromRGB(255, 215, 0),
}

_G.RoooorS = _G.RoooorS or {
    FireOn = false, FireType = "Classic", FireSize = 5,
    FireFeetOn = false, FireFeetType = "Classic",
    ESP_Name = false, ESP_Size = 12, ESP_Radius = 500,
    ESP_Generator = false, ESP_GenColor = Color3.fromRGB(255, 170, 0),
    ESP_Pallet = false, ESP_PalletColor = Color3.fromRGB(74, 255, 181),
    ESP_Window = false, ESP_WindowColor = Color3.fromRGB(74, 255, 181),
    ESP_SCP = false, ESP_SCPColor = Color3.fromRGB(255, 0, 0),
    ESP_DefaultColor = Color3.fromRGB(255, 255, 255),
    ESP_KillerColor = Color3.fromRGB(255, 60, 60),
    ESP_SurvivorColor = Color3.fromRGB(60, 255, 120),
    Parry = false, ParryDist = 8,
    ParryCircle = false, ParryCircleSize = 15,
    Skill = false,
    UltraHD = false, Contrast = false, ContrastVal = 0.3, SaturationVal = 0.2,
    Fullbright = false, NoFog = false, FOV = 70, FOVEnabled = false,
    SkyId = "Default",
    Aimlock = false, AimlockRadius = 500, AimlockLocked = false,
    WalkSpeed = false, WalkSpeedVal = 16, WalkSpeedBoost = 0,
    Korblox = false, Headless = false,
}

local S = _G.RoooorS

_G.ToggleStates = _G.ToggleStates or {}
_G.SliderStates = _G.SliderStates or {}

print("✅ [1/12] Config loaded")-- =========================================================
-- BAGIAN 2/12 : FIRE LIST + CONFIG
-- =========================================================

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
    HellFire = { c1 = Color3.fromRGB(150, 0, 0), c2 = Color3.fromRGB(255, 50, 0), smoke = true },
    IceFire = { c1 = Color3.fromRGB(100, 200, 255), c2 = Color3.fromRGB(200, 240, 255), spark = true },
    ToxicFire = { c1 = Color3.fromRGB(0, 255, 50), c2 = Color3.fromRGB(150, 255, 0), smoke = true },
    VoidFire = { c1 = Color3.fromRGB(80, 0, 150), c2 = Color3.fromRGB(200, 0, 255), spark = true },
    GoldenKing = { c1 = Color3.fromRGB(255, 215, 0), c2 = Color3.fromRGB(255, 255, 100), spark = true },
    SakuraFire = { c1 = Color3.fromRGB(255, 150, 200), c2 = Color3.fromRGB(255, 200, 230), spark = true },
    EmeraldFire = { c1 = Color3.fromRGB(0, 200, 100), c2 = Color3.fromRGB(100, 255, 150) },
    BloodFire = { c1 = Color3.fromRGB(200, 0, 0), c2 = Color3.fromRGB(100, 0, 0), smoke = true },
    ShadowFire = { c1 = Color3.fromRGB(20, 20, 30), c2 = Color3.fromRGB(80, 0, 100), smoke = true },
    HolyFire = { c1 = Color3.fromRGB(255, 255, 255), c2 = Color3.fromRGB(255, 255, 200), spark = true },
    OceanFire = { c1 = Color3.fromRGB(0, 100, 255), c2 = Color3.fromRGB(100, 200, 255) },
    Firework = { c1 = Color3.fromRGB(255, 0, 100), c2 = Color3.fromRGB(255, 200, 0), rainbow = true, spark = true },
    Lava = { c1 = Color3.fromRGB(255, 80, 0), c2 = Color3.fromRGB(100, 20, 0), smoke = true },
    GhostFire = { c1 = Color3.fromRGB(200, 200, 255), c2 = Color3.fromRGB(255, 255, 255) },
    CosmicFire = { c1 = Color3.fromRGB(50, 0, 100), c2 = Color3.fromRGB(255, 100, 200), rainbow = true },
    DragonFire = { c1 = Color3.fromRGB(255, 50, 0), c2 = Color3.fromRGB(255, 200, 0), smoke = true },
    MysteryFire = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 255, 255), rainbow = true },
    RainbowFire = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 255, 255), rainbow = true, spark = true },
    LightningFire = { c1 = Color3.fromRGB(100, 200, 255), c2 = Color3.fromRGB(255, 255, 255), spark = true },
    GalaxyFire = { c1 = Color3.fromRGB(80, 0, 200), c2 = Color3.fromRGB(255, 200, 255), rainbow = true, spark = true },
    NebulaFire = { c1 = Color3.fromRGB(200, 50, 255), c2 = Color3.fromRGB(50, 200, 255), rainbow = true, spark = true },
    AuroraFire = { c1 = Color3.fromRGB(0, 255, 200), c2 = Color3.fromRGB(100, 255, 100), rainbow = true, spark = true },
    PhoenixFire = { c1 = Color3.fromRGB(255, 150, 0), c2 = Color3.fromRGB(255, 50, 0), smoke = true },
    DemonFire = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 0, 0), smoke = true },
    AngelFire = { c1 = Color3.fromRGB(255, 255, 200), c2 = Color3.fromRGB(255, 220, 255), spark = true },
    CrystalFire = { c1 = Color3.fromRGB(200, 255, 255), c2 = Color3.fromRGB(200, 200, 255), spark = true },
    NeonFire = { c1 = Color3.fromRGB(0, 255, 100), c2 = Color3.fromRGB(255, 0, 200), rainbow = true },
    PlasmaFire = { c1 = Color3.fromRGB(150, 0, 255), c2 = Color3.fromRGB(0, 200, 255), spark = true },
    QuantumFire = { c1 = Color3.fromRGB(0, 100, 255), c2 = Color3.fromRGB(255, 0, 100), rainbow = true },
    LegendaryFire = { c1 = Color3.fromRGB(255, 215, 0), c2 = Color3.fromRGB(255, 100, 0), spark = true },
    MythicFire = { c1 = Color3.fromRGB(200, 0, 255), c2 = Color3.fromRGB(255, 200, 0), rainbow = true },
    DivineFire = { c1 = Color3.fromRGB(255, 255, 255), c2 = Color3.fromRGB(255, 200, 100), spark = true },
    CursedFire = { c1 = Color3.fromRGB(80, 0, 0), c2 = Color3.fromRGB(200, 0, 200), smoke = true },
    AncientFire = { c1 = Color3.fromRGB(200, 150, 0), c2 = Color3.fromRGB(100, 50, 0), smoke = true },
    EternalFire = { c1 = Color3.fromRGB(255, 100, 200), c2 = Color3.fromRGB(100, 200, 255), rainbow = true },
    InfernoFire = { c1 = Color3.fromRGB(255, 30, 0), c2 = Color3.fromRGB(255, 200, 0), smoke = true },
    BifrostFire = { c1 = Color3.fromRGB(255, 100, 200), c2 = Color3.fromRGB(100, 255, 200), rainbow = true },
    ChaosFire = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 0, 255), rainbow = true },
    OmegaFire = { c1 = Color3.fromRGB(255, 215, 0), c2 = Color3.fromRGB(255, 0, 255), rainbow = true },
    SolarFire = { c1 = Color3.fromRGB(255, 150, 0), c2 = Color3.fromRGB(255, 255, 100), spark = true },
    LunarFire = { c1 = Color3.fromRGB(200, 220, 255), c2 = Color3.fromRGB(100, 150, 255), spark = true },
    EclipseFire = { c1 = Color3.fromRGB(50, 0, 100), c2 = Color3.fromRGB(255, 150, 0), spark = true },
    SolarFlare = { c1 = Color3.fromRGB(255, 100, 0), c2 = Color3.fromRGB(255, 255, 200), spark = true },
    VoidStorm = { c1 = Color3.fromRGB(50, 0, 80), c2 = Color3.fromRGB(200, 0, 255), rainbow = true, spark = true },
    StarFire = { c1 = Color3.fromRGB(255, 255, 200), c2 = Color3.fromRGB(255, 200, 100), spark = true },
    SupernovaFire = { c1 = Color3.fromRGB(255, 200, 0), c2 = Color3.fromRGB(255, 0, 200), rainbow = true, spark = true },
    BlackHoleFire = { c1 = Color3.fromRGB(0, 0, 0), c2 = Color3.fromRGB(100, 0, 150), smoke = true },
    MeteorFire = { c1 = Color3.fromRGB(255, 80, 0), c2 = Color3.fromRGB(200, 30, 0), smoke = true },
    CometFire = { c1 = Color3.fromRGB(100, 200, 255), c2 = Color3.fromRGB(200, 255, 255), spark = true },
    FrostFire = { c1 = Color3.fromRGB(200, 240, 255), c2 = Color3.fromRGB(100, 180, 255), spark = true },
    BlizzardFire = { c1 = Color3.fromRGB(220, 240, 255), c2 = Color3.fromRGB(150, 200, 255), spark = true, smoke = true },
    ThunderFire = { c1 = Color3.fromRGB(255, 255, 100), c2 = Color3.fromRGB(100, 100, 255), spark = true },
    StormFire = { c1 = Color3.fromRGB(80, 80, 150), c2 = Color3.fromRGB(200, 200, 255), spark = true, smoke = true },
    TornadoFire = { c1 = Color3.fromRGB(150, 150, 200), c2 = Color3.fromRGB(80, 80, 120), spark = true, smoke = true },
    SoulFire = { c1 = Color3.fromRGB(0, 255, 200), c2 = Color3.fromRGB(150, 255, 255), spark = true },
    SpiritFire = { c1 = Color3.fromRGB(200, 255, 255), c2 = Color3.fromRGB(150, 200, 255), spark = true },
    PhantomFire = { c1 = Color3.fromRGB(100, 0, 150), c2 = Color3.fromRGB(50, 0, 100), smoke = true },
    WraithFire = { c1 = Color3.fromRGB(30, 0, 50), c2 = Color3.fromRGB(150, 0, 200), smoke = true },
    ReaperFire = { c1 = Color3.fromRGB(0, 0, 0), c2 = Color3.fromRGB(255, 0, 0), smoke = true },
}

print("✅ [2/12] Fire Config loaded")-- =========================================================
-- BAGIAN 3/12 : FIRE FEET + SKY + HELPERS
-- =========================================================

local FireFeetList = {
    "Classic", "Blue", "Green", "Purple", "Rainbow",
    "Golden", "Pink", "Cyan", "RedFire", "Ice",
    "Toxic", "Electric", "Blood", "Ghost", "Cosmic",
    "Dragon", "Divine", "Demon", "Shadow", "Phoenix"
}

local FireFeetConfig = {
    Classic = { c1 = Color3.fromRGB(255, 100, 0), c2 = Color3.fromRGB(255, 200, 0) },
    Blue = { c1 = Color3.fromRGB(0, 150, 255), c2 = Color3.fromRGB(0, 255, 255) },
    Green = { c1 = Color3.fromRGB(0, 255, 50), c2 = Color3.fromRGB(150, 255, 0) },
    Purple = { c1 = Color3.fromRGB(150, 0, 255), c2 = Color3.fromRGB(255, 0, 200) },
    Rainbow = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 255, 255), rainbow = true },
    Golden = { c1 = Color3.fromRGB(255, 215, 0), c2 = Color3.fromRGB(255, 255, 100) },
    Pink = { c1 = Color3.fromRGB(255, 100, 200), c2 = Color3.fromRGB(255, 180, 220) },
    Cyan = { c1 = Color3.fromRGB(0, 255, 255), c2 = Color3.fromRGB(100, 255, 255) },
    RedFire = { c1 = Color3.fromRGB(255, 30, 0), c2 = Color3.fromRGB(255, 100, 0) },
    Ice = { c1 = Color3.fromRGB(200, 240, 255), c2 = Color3.fromRGB(100, 180, 255) },
    Toxic = { c1 = Color3.fromRGB(0, 255, 100), c2 = Color3.fromRGB(100, 255, 0) },
    Electric = { c1 = Color3.fromRGB(255, 255, 100), c2 = Color3.fromRGB(100, 100, 255) },
    Blood = { c1 = Color3.fromRGB(200, 0, 0), c2 = Color3.fromRGB(100, 0, 0) },
    Ghost = { c1 = Color3.fromRGB(200, 200, 255), c2 = Color3.fromRGB(255, 255, 255) },
    Cosmic = { c1 = Color3.fromRGB(80, 0, 200), c2 = Color3.fromRGB(255, 200, 255), rainbow = true },
    Dragon = { c1 = Color3.fromRGB(255, 50, 0), c2 = Color3.fromRGB(255, 200, 0) },
    Divine = { c1 = Color3.fromRGB(255, 255, 255), c2 = Color3.fromRGB(255, 255, 200) },
    Demon = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 0, 0) },
    Shadow = { c1 = Color3.fromRGB(20, 20, 30), c2 = Color3.fromRGB(80, 0, 100) },
    Phoenix = { c1 = Color3.fromRGB(255, 150, 0), c2 = Color3.fromRGB(255, 50, 0) },
}

local SkyList = {
    "Default", "Sunset", "Night", "Space", "Alien",
    "Purple", "Pink", "Cyan", "Red", "Blue",
    "Green", "Galaxy", "Nebula", "Aurora", "Cosmic",
    "Void", "Heaven", "Hell", "Ocean", "Desert",
    "Forest", "Snow", "Storm", "Rainbow", "Golden",
}

local SkyIds = {
    Sunset = "rbxassetid://159454299",
    Night = "rbxassetid://159454299",
    Space = "rbxassetid://159454299",
    Alien = "rbxassetid://159454299",
    Purple = "rbxassetid://159454299",
    Pink = "rbxassetid://159454299",
    Cyan = "rbxassetid://159454299",
    Red = "rbxassetid://159454299",
    Blue = "rbxassetid://159454299",
    Green = "rbxassetid://159454299",
    Galaxy = "rbxassetid://159454299",
    Nebula = "rbxassetid://159454299",
    Aurora = "rbxassetid://159454299",
    Cosmic = "rbxassetid://159454299",
    Void = "rbxassetid://159454299",
    Heaven = "rbxassetid://159454299",
    Hell = "rbxassetid://159454299",
    Ocean = "rbxassetid://159454299",
    Desert = "rbxassetid://159454299",
    Forest = "rbxassetid://159454299",
    Snow = "rbxassetid://159454299",
    Storm = "rbxassetid://159454299",
    Rainbow = "rbxassetid://159454299",
    Golden = "rbxassetid://159454299",
}

local KillerAnims = {}
for _, id in ipairs({
    "105374834496520","113255068724446","118907603246885","129784271201071",
    "117042998468241","122812055447896","78935059863801","74968262036854",
    "78432063483146","132817836308238","133963973694098","111920872708571",
    "80411309607666","98163597193511","82666958311998","110355011987939",
    "139369275981133","135002183282873","121216847022485","130593238885843",
    "117070354890871","106871536134254","138720291317243"
}) do KillerAnims["rbxassetid://"..id] = true end

function rnd(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = o
end

function strk(o, col, t, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or C.ACC
    s.Thickness = t or 1.5
    s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = o
    return s
end

function grad(o, c1, c2, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c1, c2)
    g.Rotation = rot or 0
    g.Parent = o
    return g
end

function gradientRainbow(o)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, C.ACC),
        ColorSequenceKeypoint.new(0.25, C.ACC2),
        ColorSequenceKeypoint.new(0.5, C.ACC3),
        ColorSequenceKeypoint.new(0.75, C.ACC4),
        ColorSequenceKeypoint.new(1, C.ACC),
    }
    g.Parent = o
    return g
end

function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

print("✅ [3/12] Fire Feet + Sky + Helpers loaded")-- =========================================================
-- BAGIAN 4/12 : GUI WINDOW + HEADER
-- =========================================================

local gui = Instance.new("ScreenGui")
gui.Name = "RoooorHubPremium"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PG

-- FLOAT BUTTON
local fBtn = Instance.new("TextButton")
fBtn.Size = UDim2.new(0, 48, 0, 48)
fBtn.Position = UDim2.new(0, 15, 0.5, -24)
fBtn.BackgroundColor3 = C.PANEL
fBtn.Text = "⚡"
fBtn.TextColor3 = C.ACC2
fBtn.TextSize = 26
fBtn.Font = Enum.Font.GothamBlack
fBtn.BorderSizePixel = 0
fBtn.AutoButtonColor = false
fBtn.Parent = gui
rnd(fBtn, 24)
local fbStrk = strk(fBtn, C.ACC, 2.5)
grad(fBtn, C.PANEL, C.PANEL2, 45)

local glowRing = Instance.new("Frame")
glowRing.Size = UDim2.new(1, 12, 1, 12)
glowRing.Position = UDim2.new(0, -6, 0, -6)
glowRing.BackgroundColor3 = C.ACC
glowRing.BackgroundTransparency = 0.7
glowRing.BorderSizePixel = 0
glowRing.ZIndex = -1
glowRing.Parent = fBtn
rnd(glowRing, 30)

task.spawn(function()
    while fBtn.Parent do
        local t = tick()
        local pulse = (math.sin(t * 2.5) + 1) / 2
        glowRing.BackgroundTransparency = 0.85 - pulse * 0.4
        glowRing.Size = UDim2.new(1, 8 + pulse * 10, 1, 8 + pulse * 10)
        glowRing.Position = UDim2.new(0, -4 - pulse * 5, 0, -4 - pulse * 5)
        task.wait(0.03)
    end
end)

task.spawn(function()
    local angle = 0
    while fBtn.Parent do
        angle += 3
        fBtn.Rotation = math.sin(math.rad(angle)) * 8
        task.wait(0.03)
    end
end)

task.spawn(function()
    while fBtn.Parent do
        for i = 0, 1, 0.02 do
            if not fBtn.Parent then break end
            fbStrk.Color = C.ACC:Lerp(C.ACC2, i)
            task.wait(0.05)
        end
        for i = 0, 1, 0.02 do
            if not fBtn.Parent then break end
            fbStrk.Color = C.ACC2:Lerp(C.ACC3, i)
            task.wait(0.05)
        end
        for i = 0, 1, 0.02 do
            if not fBtn.Parent then break end
            fbStrk.Color = C.ACC3:Lerp(C.ACC, i)
            task.wait(0.05)
        end
    end
end)

-- MAIN WINDOW
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 480, 0, 450)
main.Position = UDim2.new(0.5, -240, 0.5, -225)
main.BackgroundColor3 = C.BG
main.BackgroundTransparency = 0.05
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui
rnd(main, 20)
local mainStrk = strk(main, C.ACC, 2.5, 0.2)

local mainGrad = Instance.new("UIGradient")
mainGrad.Color = ColorSequence.new(C.BG, C.BG2, C.BG)
mainGrad.Rotation = 45
mainGrad.Parent = main

local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0, -20, 0, -20)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5028857084"
shadow.ImageColor3 = C.ACC
shadow.ImageTransparency = 0.6
shadow.ZIndex = -2
shadow.Parent = main

-- HEADER
local head = Instance.new("Frame")
head.Size = UDim2.new(1, 0, 0, 50)
head.BackgroundColor3 = C.PANEL
head.BackgroundTransparency = 0.1
head.BorderSizePixel = 0
head.Parent = main
rnd(head, 20)

local hPatch = Instance.new("Frame")
hPatch.Size = UDim2.new(1, 0, 0, 25)
hPatch.Position = UDim2.new(0, 0, 1, -25)
hPatch.BackgroundColor3 = C.PANEL
hPatch.BackgroundTransparency = 0.1
hPatch.BorderSizePixel = 0
hPatch.Parent = head

local neonLine = Instance.new("Frame")
neonLine.Size = UDim2.new(1, -40, 0, 3)
neonLine.Position = UDim2.new(0, 20, 1, -1.5)
neonLine.BackgroundColor3 = C.ACC
neonLine.BorderSizePixel = 0
neonLine.Parent = head
local neonGrad = gradientRainbow(neonLine)

task.spawn(function()
    while neonLine.Parent do
        for i = 0, 1, 0.02 do
            if not neonLine.Parent then break end
            neonGrad.Rotation = i * 360
            task.wait(0.05)
        end
    end
end)

local iconLbl = Instance.new("TextLabel")
iconLbl.Size = UDim2.new(0, 45, 1, 0)
iconLbl.Position = UDim2.new(0, 15, 0, 0)
iconLbl.BackgroundTransparency = 1
iconLbl.Text = "⚡"
iconLbl.TextColor3 = C.ACC4
iconLbl.TextSize = 28
iconLbl.Font = Enum.Font.GothamBlack
iconLbl.Parent = head

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 60, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ROOORHUB PREMIUM"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextStrokeTransparency = 0.3
title.TextStrokeColor3 = Color3.new(0, 0, 0)
title.Parent = head
local titleGrad = gradientRainbow(title)

task.spawn(function()
    while title.Parent do
        for i = 0, 1, 0.02 do
            if not title.Parent then break end
            titleGrad.Rotation = i * 360
            task.wait(0.05)
        end
    end
end)

local closeB = Instance.new("TextButton")
closeB.Size = UDim2.new(0, 28, 0, 28)
closeB.Position = UDim2.new(1, -38, 0.5, -14)
closeB.BackgroundColor3 = C.PANEL2
closeB.Text = "✕"
closeB.TextColor3 = C.RED
closeB.TextSize = 14
closeB.Font = Enum.Font.GothamBlack
closeB.BorderSizePixel = 0
closeB.AutoButtonColor = false
closeB.Parent = head
rnd(closeB, 8)
strk(closeB, C.RED, 1, 0.5)
closeB.MouseEnter:Connect(function()
    TweenService:Create(closeB, TweenInfo.new(0.1), {BackgroundColor3 = C.RED, TextColor3 = Color3.new(1,1,1)}):Play()
end)
closeB.MouseLeave:Connect(function()
    TweenService:Create(closeB, TweenInfo.new(0.1), {BackgroundColor3 = C.PANEL2, TextColor3 = C.RED}):Play()
end)
closeB.MouseButton1Click:Connect(function()
    main.Visible = false
    fBtn.Visible = true
end)

local minB = Instance.new("TextButton")
minB.Size = UDim2.new(0, 28, 0, 28)
minB.Position = UDim2.new(1, -72, 0.5, -14)
minB.BackgroundColor3 = C.PANEL2
minB.Text = "—"
minB.TextColor3 = C.ACC4
minB.TextSize = 16
minB.Font = Enum.Font.GothamBlack
minB.BorderSizePixel = 0
minB.AutoButtonColor = false
minB.Parent = head
rnd(minB, 8)
strk(minB, C.ACC4, 1, 0.5)
minB.MouseButton1Click:Connect(function()
    main.Visible = false
    fBtn.Visible = true
end)

fBtn.MouseButton1Click:Connect(function()
    fBtn.Visible = false
    main.Visible = true
    main.Size = UDim2.new(0, 0, 0, 0)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 480, 0, 450),
        Position = UDim2.new(0.5, -240, 0.5, -225)
    }):Play()
end)

-- SIDEBAR
local sb = Instance.new("Frame")
sb.Size = UDim2.new(0, 120, 1, -72)
sb.Position = UDim2.new(0, 12, 0, 62)
sb.BackgroundColor3 = C.PANEL
sb.BackgroundTransparency = 0.2
sb.BorderSizePixel = 0
sb.Parent = main
rnd(sb, 14)
strk(sb, C.ACC, 1, 0.6)
grad(sb, C.PANEL, C.PANEL2, 90)

local sbL = Instance.new("UIListLayout")
sbL.Padding = UDim.new(0, 5)
sbL.Parent = sb

local sbP = Instance.new("UIPadding")
sbP.PaddingTop = UDim.new(0, 8)
sbP.PaddingLeft = UDim.new(0, 6)
sbP.PaddingRight = UDim.new(0, 6)
sbP.Parent = sb

-- CONTENT
local ct = Instance.new("Frame")
ct.Size = UDim2.new(1, -150, 1, -72)
ct.Position = UDim2.new(0, 140, 0, 62)
ct.BackgroundColor3 = C.PANEL
ct.BackgroundTransparency = 0.2
ct.BorderSizePixel = 0
ct.Parent = main
rnd(ct, 14)
strk(ct, C.ACC2, 1, 0.6)
grad(ct, C.PANEL, C.PANEL2, 45)

local cs = Instance.new("ScrollingFrame")
cs.Size = UDim2.new(1, -16, 1, -16)
cs.Position = UDim2.new(0, 8, 0, 8)
cs.BackgroundTransparency = 1
cs.BorderSizePixel = 0
cs.ScrollBarThickness = 3
cs.ScrollBarImageColor3 = C.ACC
cs.CanvasSize = UDim2.new(0, 0, 0, 0)
cs.AutomaticCanvasSize = Enum.AutomaticSize.Y
cs.Parent = ct

local csL = Instance.new("UIListLayout")
csL.Padding = UDim.new(0, 6)
csL.Parent = cs

print("✅ [4/12] GUI Window loaded")-- =========================================================
-- BAGIAN 5/12 : COMPONENTS
-- =========================================================

function sec(title, icon)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 26)
    f.BackgroundTransparency = 1
    f.Parent = cs
    local deco = Instance.new("Frame")
    deco.Size = UDim2.new(0, 4, 0, 18)
    deco.Position = UDim2.new(0, 4, 0.5, -9)
    deco.BackgroundColor3 = C.ACC
    deco.BorderSizePixel = 0
    deco.Parent = f
    rnd(deco, 2)
    gradientRainbow(deco)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 1, 0)
    l.Position = UDim2.new(0, 16, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = icon .. "  " .. string.upper(title)
    l.TextColor3 = C.ACC4
    l.TextSize = 11
    l.Font = Enum.Font.GothamBlack
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
end

function lbl(text, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -4, 0, 20)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or C.DIM
    l.TextSize = 10
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = cs
end

function tog(name, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 34)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 10)
    local fStrk = strk(f, C.ACC, 1, 0.7)
    grad(f, C.BG, C.BG2, 90)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -60, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 11
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local t = Instance.new("Frame")
    t.Size = UDim2.new(0, 38, 0, 20)
    t.Position = UDim2.new(1, -50, 0.5, -10)
    t.BorderSizePixel = 0
    t.Parent = f
    rnd(t, 10)

    local k = Instance.new("Frame")
    k.Size = UDim2.new(0, 14, 0, 14)
    k.BorderSizePixel = 0
    k.Parent = t
    rnd(k, 7)

    local saved = _G.ToggleStates[name]
    local state = (saved ~= nil) and saved or def
    _G.ToggleStates[name] = state

    t.BackgroundColor3 = state and C.ACC or C.PANEL
    k.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    k.BackgroundColor3 = state and C.ACC2 or C.DIM

    local cB = Instance.new("TextButton")
    cB.Size = UDim2.new(1, 0, 1, 0)
    cB.BackgroundTransparency = 1
    cB.Text = ""
    cB.Parent = t
    cB.MouseButton1Click:Connect(function()
        state = not state
        _G.ToggleStates[name] = state
        TweenService:Create(k, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
            BackgroundColor3 = state and C.ACC2 or C.DIM
        }):Play()
        TweenService:Create(t, TweenInfo.new(0.2), {
            BackgroundColor3 = state and C.ACC or C.PANEL
        }):Play()
        fStrk.Color = state and C.ACC2 or C.ACC
        if cb then pcall(cb, state) end
    end)
end

function sl(name, min, max, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 44)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 10)
    strk(f, C.ACC, 1, 0.7)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -60, 0, 18)
    l.Position = UDim2.new(0, 12, 0, 5)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 11
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local curVal = _G.SliderStates[name] or def
    _G.SliderStates[name] = curVal

    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0, 40, 0, 18)
    v.Position = UDim2.new(1, -52, 0, 5)
    v.BackgroundTransparency = 1
    v.Text = tostring(curVal)
    v.TextColor3 = C.ACC2
    v.TextSize = 11
    v.Font = Enum.Font.GothamBold
    v.TextXAlignment = Enum.TextXAlignment.Right
    v.Parent = f

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -26, 0, 6)
    bg.Position = UDim2.new(0, 13, 1, -15)
    bg.BackgroundColor3 = C.PANEL
    bg.BorderSizePixel = 0
    bg.Parent = f
    rnd(bg, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((curVal - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = C.ACC
    fill.BorderSizePixel = 0
    fill.Parent = bg
    rnd(fill, 3)
    grad(fill, C.ACC, C.ACC2, 90)

    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 14, 0, 14)
    kn.Position = UDim2.new((curVal - min) / (max - min), -7, 0.5, -7)
    kn.BackgroundColor3 = C.TXT
    kn.BorderSizePixel = 0
    kn.ZIndex = 2
    kn.Parent = bg
    rnd(kn, 7)
    strk(kn, C.ACC2, 2)

    local drag = false
    local function upd(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local val = math.floor((min + (max - min) * pos) * 100 + 0.5) / 100
        _G.SliderStates[name] = val
        fill.Size = UDim2.new(pos, 0, 1, 0)
        kn.Position = UDim2.new(pos, -7, 0.5, -7)
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
    f.Size = UDim2.new(1, -4, 0, 34)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 10)
    strk(f, C.ACC, 1, 0.7)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -55, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 11
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local cB = Instance.new("TextButton")
    cB.Size = UDim2.new(0, 36, 0, 18)
    cB.Position = UDim2.new(1, -48, 0.5, -9)
    cB.BackgroundColor3 = def
    cB.Text = ""
    cB.BorderSizePixel = 0
    cB.Parent = f
    rnd(cB, 5)
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
        cB.BackgroundColor3 = presets[idx]
        if cb then pcall(cb, presets[idx]) end
    end)
end

function btn(name, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -4, 0, 32)
    b.BackgroundColor3 = C.BG
    b.BackgroundTransparency = 0.4
    b.Text = name
    b.TextColor3 = C.TXT
    b.TextSize = 11
    b.Font = Enum.Font.GothamMedium
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = cs
    rnd(b, 10)
    strk(b, C.ACC2, 1, 0.7)
    b.MouseButton1Click:Connect(function()
        if cb then pcall(cb) end
    end)
end

-- TAB SYSTEM
local activeTab = nil
function makeTab(name, icon, order, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 34)
    b.BackgroundColor3 = C.BG
    b.BackgroundTransparency = 1
    b.Text = ""
    b.BorderSizePixel = 0
    b.LayoutOrder = order
    b.AutoButtonColor = false
    b.Parent = sb
    rnd(b, 8)

    local ind = Instance.new("Frame")
    ind.Size = UDim2.new(0, 3, 0, 0)
    ind.Position = UDim2.new(0, 0, 0.5, 0)
    ind.AnchorPoint = Vector2.new(0, 0.5)
    ind.BackgroundColor3 = C.ACC
    ind.BorderSizePixel = 0
    ind.Parent = b
    rnd(ind, 2)

    local ico = Instance.new("TextLabel")
    ico.Size = UDim2.new(0, 24, 1, 0)
    ico.Position = UDim2.new(0, 8, 0, 0)
    ico.BackgroundTransparency = 1
    ico.Text = icon
    ico.TextColor3 = C.DIM
    ico.TextSize = 16
    ico.Font = Enum.Font.GothamBold
    ico.Parent = b

    local lblT = Instance.new("TextLabel")
    lblT.Size = UDim2.new(1, -32, 1, 0)
    lblT.Position = UDim2.new(0, 34, 0, 0)
    lblT.BackgroundTransparency = 1
    lblT.Text = string.upper(name)
    lblT.TextColor3 = C.DIM
    lblT.TextSize = 10
    lblT.Font = Enum.Font.GothamBlack
    lblT.TextXAlignment = Enum.TextXAlignment.Left
    lblT.Parent = b

    b.MouseButton1Click:Connect(function()
        if activeTab == b then return end
        if activeTab then
            activeTab.BackgroundTransparency = 1
            local oldInd = activeTab:FindFirstChildOfClass("Frame")
            if oldInd then
                TweenService:Create(oldInd, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 0)}):Play()
            end
            for _, c in pairs(activeTab:GetChildren()) do
                if c:IsA("TextLabel") then
                    TweenService:Create(c, TweenInfo.new(0.2), {TextColor3 = C.DIM}):Play()
                end
            end
        end
        activeTab = b
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
        TweenService:Create(ind, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 3, 0, 24)}):Play()
        for _, c in pairs(b:GetChildren()) do
            if c:IsA("TextLabel") then
                TweenService:Create(c, TweenInfo.new(0.2), {TextColor3 = C.TXT}):Play()
            end
        end
        for _, c in pairs(cs:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
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

print("✅ [5/12] Components loaded")-- =========================================================
-- BAGIAN 6/12 : FIRE + FIRE FEET FUNCTIONS
-- =========================================================

function clearFire()
    if not LP.Character then return end
    local head = LP.Character:FindFirstChild("Head")
    if not head then return end
    for _, obj in pairs(head:GetChildren()) do
        if obj.Name == "RoooorFire" or obj.Name == "RoooorSmoke" or obj.Name == "RoooorSparkles" then
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

    local fire = Instance.new("Fire")
    fire.Name = "RoooorFire"
    fire.Size = S.FireSize
    fire.Heat = 10
    fire.Color = cfg.c1
    fire.SecondaryColor = cfg.c2
    fire.Parent = head

    if cfg.smoke then
        local smoke = Instance.new("Smoke")
        smoke.Name = "RoooorSmoke"
        smoke.Size = S.FireSize + 2
        smoke.RiseVelocity = 3
        smoke.Opacity = 0.4
        smoke.Color = cfg.c2
        smoke.Parent = head
    end
    if cfg.spark then
        local spark = Instance.new("Sparkles")
        spark.Name = "RoooorSparkles"
        spark.SparkleColor = cfg.c2
        spark.SparkleSize = 1
        spark.Parent = head
    end
end

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
                end
            end
        end
    end
end)

function clearFireFeet()
    if not LP.Character then return end
    local lLeg = LP.Character:FindFirstChild("Left Leg") or LP.Character:FindFirstChild("LeftUpperLeg")
    local rLeg = LP.Character:FindFirstChild("Right Leg") or LP.Character:FindFirstChild("RightUpperLeg")
    for _, leg in pairs({lLeg, rLeg}) do
        if leg then
            for _, obj in pairs(leg:GetChildren()) do
                if obj.Name == "RoooorFootFire" then obj:Destroy() end
            end
        end
    end
end

function applyFireFeet()
    clearFireFeet()
    if not S.FireFeetOn then return end
    local char = LP.Character
    if not char then return end
    local lLeg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg")
    local rLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg")
    local cfg = FireFeetConfig[S.FireFeetType] or FireFeetConfig.Classic

    for _, leg in pairs({lLeg, rLeg}) do
        if leg then
            local fire = Instance.new("Fire")
            fire.Name = "RoooorFootFire"
            fire.Size = 4
            fire.Heat = 8
            fire.Color = cfg.c1
            fire.SecondaryColor = cfg.c2
            fire.Parent = leg
        end
    end
end

task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        if S.FireFeetOn and LP.Character then
            local cfg = FireFeetConfig[S.FireFeetType] or FireFeetConfig.Classic
            if cfg.rainbow then
                local char = LP.Character
                local lLeg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg")
                local rLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg")
                local t = tick()
                for _, leg in pairs({lLeg, rLeg}) do
                    if leg then
                        local fire = leg:FindFirstChild("RoooorFootFire")
                        if fire then
                            fire.Color = Color3.fromHSV((t * 0.5) % 1, 1, 1)
                            fire.SecondaryColor = Color3.fromHSV(((t * 0.5) + 0.5) % 1, 1, 1)
                        end
                    end
                end
            end
        end
    end
end)

print("✅ [6/12] Fire + Fire Feet loaded")-- =========================================================
-- BAGIAN 7/12 : ESP FUNCTIONS
-- =========================================================

local StatusESP = {}
local ESPObjects = {}
local Cached = { Generators = {}, Windows = {}, Pallets = {}, SCPs = {} }

local function cacheObject(obj)
    if obj.Name == "Generator" then Cached.Generators[obj] = true
    elseif obj.Name == "Window" then Cached.Windows[obj] = true
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then Cached.Pallets[obj] = true
    elseif string.find(string.lower(obj.Name), "scp") then Cached.SCPs[obj] = true
    end
end

for _, obj in ipairs(workspace:GetDescendants()) do cacheObject(obj) end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(function(obj)
    Cached.Generators[obj] = nil
    Cached.Windows[obj] = nil
    Cached.Pallets[obj] = nil
    Cached.SCPs[obj] = nil
end)

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
end

function removeESP(obj)
    if ESPObjects[obj] then
        ESPObjects[obj]:Destroy()
        ESPObjects[obj] = nil
    end
end

function createStatusESP(player, char, root)
    if not S.ESP_Name then
        if StatusESP[char] then StatusESP[char]:Destroy(); StatusESP[char] = nil end
        return
    end
    if not root then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local dist = (head.Position - root.Position).Magnitude
    if dist > S.ESP_Radius then
        if StatusESP[char] then StatusESP[char]:Destroy(); StatusESP[char] = nil end
        return
    end
    local color = S.ESP_DefaultColor
    if player.Team then
        if player.Team.Name == "Killer" then color = S.ESP_KillerColor
        elseif player.Team.Name == "Survivors" then color = S.ESP_SurvivorColor end
    end
    local bb = StatusESP[char]
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 150, 0, 30)
        bb.AlwaysOnTop = true
        bb.StudsOffset = Vector3.new(0, 3, 0)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = color
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = S.ESP_Size
        label.Parent = bb
        bb.Adornee = head
        bb.Parent = char
        StatusESP[char] = bb
    else
        local label = bb:FindFirstChildOfClass("TextLabel")
        if label then
            label.Text = player.Name
            label.TextColor3 = color
            label.TextSize = S.ESP_Size
        end
    end
end

function updateObjESP(obj, root, enabled, color)
    if not obj or not root then return end
    local pos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
    if not pos then return end
    if enabled and (pos - root.Position).Magnitude <= S.ESP_Radius then
        createESP(obj, color)
    else
        removeESP(obj)
    end
end

print("✅ [7/12] ESP loaded")-- =========================================================
-- BAGIAN 8/12 : PARRY + SKILL + AIMLOCK
-- =========================================================

local lastParry = 0
local HookedKillers = _G.HookedKillers or {}

local function doParry()
    if tick() - lastParry < 0.1 then return end
    lastParry = tick()
    if UIS.TouchEnabled then
        pcall(function()
            VirtualInputManager:SendTouchEvent(8823, 0, 200, 200)
            VirtualInputManager:SendTouchEvent(8823, 2, 200, 200)
        end)
    else
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
        end)
    end
end

local function hookKiller(char)
    if HookedKillers[char] then return end
    HookedKillers[char] = true
    _G.HookedKillers = HookedKillers
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    task.spawn(function()
        while HookedKillers[char] and char.Parent do
            task.wait(0.03)
            if not S.Parry then break end
            local myRoot = getRoot()
            local eRoot = char:FindFirstChild("HumanoidRootPart")
            if not myRoot or not eRoot then continue end
            if (eRoot.Position - myRoot.Position).Magnitude > S.ParryDist then continue end
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local anim = track.Animation
                if anim then
                    local id = anim.AnimationId:match("%d+")
                    if id and KillerAnims["rbxassetid://"..id] then
                        doParry()
                        break
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

task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if S.Parry then scanKillers() end
    end
end)

_G.ParryCirclePart = nil
function updateParryCircle()
    local root = getRoot()
    if not S.ParryCircle or not root then
        if _G.ParryCirclePart then _G.ParryCirclePart:Destroy(); _G.ParryCirclePart = nil end
        return
    end
    if not _G.ParryCirclePart then
        _G.ParryCirclePart = Instance.new("Part")
        _G.ParryCirclePart.Shape = Enum.PartType.Cylinder
        _G.ParryCirclePart.Anchored = true
        _G.ParryCirclePart.CanCollide = false
        _G.ParryCirclePart.Material = Enum.Material.Neon
        _G.ParryCirclePart.Parent = workspace
    end
    local size = S.ParryCircleSize * 2
    _G.ParryCirclePart.Size = Vector3.new(0.1, size, size)
    local yOffset = root.Size.Y / 2 + 1.5
    _G.ParryCirclePart.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0)) * CFrame.Angles(0, 0, math.rad(90))
    _G.ParryCirclePart.Color = C.ACC
    _G.ParryCirclePart.Transparency = 0.5
end

local skillBusy = false
local function doSkillCheck()
    if skillBusy then return end
    skillBusy = true
    pcall(function()
        if UIS.TouchEnabled then
            local b = PG
            for seg in string.gmatch("Survivor-mob.Controls.action.check", "[^%.]+") do
                b = b and b:FindFirstChild(seg)
            end
            if b and b:IsA("GuiObject") then
                local p, s, i = b.AbsolutePosition, b.AbsoluteSize, GuiService:GetGuiInset()
                VirtualInputManager:SendTouchEvent(8822, 0, p.X + s.X/2 + i.X, p.Y + s.Y/2 + i.Y)
                VirtualInputManager:SendTouchEvent(8822, 2, p.X + s.X/2 + i.X, p.Y + s.Y/2 + i.Y)
            end
        else
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end
    end)
    task.wait(0.05)
    skillBusy = false
end

task.spawn(function()
    while gui.Parent do
        task.wait(0.02)
        if S.Skill then
            local prompt = PG:FindFirstChild("SkillCheckPromptGui")
            if prompt then
                local check = prompt:FindFirstChild("Check")
                if check and check.Visible then
                    local line = check:FindFirstChild("Line")
                    local goal = check:FindFirstChild("Goal")
                    if line and goal then
                        local lr = line.Rotation % 360
                        local gr = goal.Rotation % 360
                        local sr = (gr + 102) % 360
                        local er = (gr + 116) % 360
                        if (sr > er and (lr >= sr or lr <= er)) or (lr >= sr and lr <= er) then
                            doSkillCheck()
                        end
                    end
                end
            end
        end
    end
end)

_G.AimlockButton = nil

local function createAimlockButton()
    if _G.AimlockButton then _G.AimlockButton:Destroy() end
    
    local btnGui = Instance.new("ScreenGui")
    btnGui.Name = "RoooorAimlockBtn"
    btnGui.ResetOnSpawn = false
    btnGui.IgnoreGuiInset = true
    btnGui.Parent = PG
    
    local btn = Instance.new("TextButton")
    btn.Name = "AimlockBtn"
    btn.Size = UDim2.new(0, 52, 0, 52)
    btn.Position = UDim2.new(0.35, 0, 0.75, 0)
    btn.BackgroundColor3 = C.PANEL
    btn.Text = "🎯"
    btn.TextColor3 = C.ACC2
    btn.TextSize = 26
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = btnGui
    rnd(btn, 26)
    local bStrk = strk(btn, C.ACC, 2)
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 100, 0, 14)
    lbl.Position = UDim2.new(0.5, -50, 1, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = "AIMLOCK"
    lbl.TextColor3 = C.ACC2
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextStrokeTransparency = 0.3
    lbl.Parent = btn
    
    local lockLbl = Instance.new("TextLabel")
    lockLbl.Name = "LockLabel"
    lockLbl.Size = UDim2.new(0, 100, 0, 12)
    lockLbl.Position = UDim2.new(0.5, -50, 1, 17)
    lockLbl.BackgroundTransparency = 1
    lockLbl.Text = "🔓"
    lockLbl.TextColor3 = C.DIM
    lockLbl.TextSize = 9
    lockLbl.Font = Enum.Font.GothamBold
    lockLbl.Parent = btn
    
    local dragging = false
    local ds, dp
    local wasDragged = false
    
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if S.AimlockLocked then return end
            dragging = true
            wasDragged = false
            ds = input.Position
            dp = btn.Position
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - ds
            if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then wasDragged = true end
            btn.Position = UDim2.new(dp.X.Scale, dp.X.Offset + d.X, dp.Y.Scale, dp.Y.Offset + d.Y)
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        if wasDragged then wasDragged = false; return end
        S.Aimlock = not S.Aimlock
        if S.Aimlock then
            btn.BackgroundColor3 = C.ACC
            bStrk.Color = C.ACC2
            btn.TextColor3 = Color3.new(1,1,1)
        else
            btn.BackgroundColor3 = C.PANEL
            bStrk.Color = C.ACC
            btn.TextColor3 = C.ACC2
        end
    end)
    
    _G.AimlockButton = btnGui
end

local function removeAimlockButton()
    if _G.AimlockButton then _G.AimlockButton:Destroy(); _G.AimlockButton = nil end
end

local function updateAimlockLock()
    if not _G.AimlockButton then return end
    local btn = _G.AimlockButton:FindFirstChild("AimlockBtn", true)
    if btn then
        local lockLbl = btn:FindFirstChild("LockLabel")
        if lockLbl then
            if S.AimlockLocked then
                lockLbl.Text = "🔒"
                lockLbl.TextColor3 = C.GOLD
            else
                lockLbl.Text = "🔓"
                lockLbl.TextColor3 = C.DIM
            end
        end
    end
end

task.spawn(function()
    while gui.Parent do
        task.wait(0.03)
        if S.Aimlock then
            local myRoot = getRoot()
            if myRoot then
                local closest, shortest = nil, S.AimlockRadius
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Survivors" then
                        local hrp = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hrp and hum and hum.Health > 0 then
                            local dist = (hrp.Position - myRoot.Position).Magnitude
                            if dist < shortest then
                                shortest = dist
                                closest = hrp
                            end
                        end
                    end
                end
                if closest then
                    local cam = workspace.CurrentCamera
                    local targetCF = CFrame.new(cam.CFrame.Position, closest.Position)
                    cam.CFrame = cam.CFrame:Lerp(targetCF, 0.4)
                end
            end
        end
    end
end)

print("✅ [8/12] Parry + Skill + Aimlock loaded")-- =========================================================
-- BAGIAN 9/12 : VISUAL FUNCTIONS
-- =========================================================

function applyFullbright(s)
    if s then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(70, 70, 70)
        Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
        Lighting.GlobalShadows = true
    end
end

function applyNoFog(s)
    if s then
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
    else
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
    end
end

local origSky = nil
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("Sky") then origSky = v:Clone() break end
end

function applySky(skyName)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end
    if skyName and skyName ~= "Default" then
        local skyId = SkyIds[skyName] or "rbxassetid://159454299"
        local sky = Instance.new("Sky")
        sky.SkyboxBk = skyId
        sky.SkyboxDn = skyId
        sky.SkyboxFt = skyId
        sky.SkyboxLf = skyId
        sky.SkyboxRt = skyId
        sky.SkyboxUp = skyId
        sky.Parent = Lighting
    elseif origSky then
        origSky:Clone().Parent = Lighting
    end
end

function applyFOV()
    local cam = workspace.CurrentCamera
    if cam then
        if S.FOVEnabled then
            cam.FieldOfView = S.FOV
        else
            cam.FieldOfView = 70
        end
    end
end

function applyUltraHD()
    if S.UltraHD then
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level10 end)
        Lighting.GlobalShadows = true
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        if not _G.RoooorHD then
            _G.RoooorHD = Instance.new("ColorCorrectionEffect")
            _G.RoooorHD.Parent = Lighting
        end
        _G.RoooorHD.Contrast = 0.2
        _G.RoooorHD.Saturation = 0.15
    else
        if _G.RoooorHD then _G.RoooorHD:Destroy(); _G.RoooorHD = nil end
    end
end

function applyContrast()
    if S.Contrast then
        if not _G.ContrastFx then
            _G.ContrastFx = Instance.new("ColorCorrectionEffect")
            _G.ContrastFx.Parent = Lighting
        end
        _G.ContrastFx.Contrast = S.ContrastVal
        _G.ContrastFx.Saturation = S.SaturationVal
    else
        if _G.ContrastFx then _G.ContrastFx:Destroy(); _G.ContrastFx = nil end
    end
end

function applyKorblox(s)
    local char = LP.Character
    if not char then return end
    local lLeg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg")
    local rLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg")
    for _, leg in pairs({lLeg, rLeg}) do
        if leg then
            if s then
                leg.BrickColor = BrickColor.new("Really black")
                leg.Material = Enum.Material.Slate
                if not leg:FindFirstChild("RoooorKorblox") then
                    local mesh = Instance.new("SpecialMesh")
                    mesh.Name = "RoooorKorblox"
                    mesh.MeshType = Enum.MeshType.FileMesh
                    mesh.MeshId = "rbxassetid://1395869870"
                    mesh.Parent = leg
                end
            else
                if leg:FindFirstChild("RoooorKorblox") then
                    leg.RoooorKorblox:Destroy()
                end
                leg.Material = Enum.Material.Plastic
            end
        end
    end
end

function applyHeadless(s)
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if s then
        head.Transparency = 1
        for _, v in pairs(head:GetChildren()) do
            if v:IsA("Decal") or v:IsA("SpecialMesh") or v:IsA("Mesh") then
                v.Transparency = 1
            end
        end
    else
        head.Transparency = 0
        for _, v in pairs(head:GetChildren()) do
            if v:IsA("Decal") or v:IsA("SpecialMesh") or v:IsA("Mesh") then
                v.Transparency = 0
            end
        end
    end
end

task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        if S.WalkSpeed and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local target = S.WalkSpeedVal + (S.WalkSpeedBoost or 0)
                if hum.WalkSpeed ~= target then
                    hum.WalkSpeed = target
                end
            end
        end
    end
end)

print("✅ [9/12] Visual loaded")-- =========================================================
-- BAGIAN 10/12 : ISI TAB FIRE + FIRE FEET
-- =========================================================

-- TAB FIRE
makeTab("Fire", "🔥", 1, function()
    sec("Fire Control", "⚙️")
    tog("Enable Fire", false, function(s) S.FireOn = s; applyFire() end)
    sl("Fire Size", 1, 15, 5, function(v) S.FireSize = v; applyFire() end)

    sec("Pilih Efek Fire (60)", "🔥")
    lbl("Klik efek untuk ganti", C.ACC2)

    for i, fireName in ipairs(FireList) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 28)
        btn.BackgroundColor3 = C.BG
        btn.BackgroundTransparency = 0.4
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.LayoutOrder = i + 100
        btn.Parent = cs
        rnd(btn, 8)
        local btnStroke = strk(btn, C.ACC, 1, 0.6)

        local btnLbl = Instance.new("TextLabel")
        btnLbl.Size = UDim2.new(1, -10, 1, 0)
        btnLbl.Position = UDim2.new(0, 10, 0, 0)
        btnLbl.BackgroundTransparency = 1
        btnLbl.Text = "🔥 " .. fireName
        btnLbl.TextColor3 = C.TXT
        btnLbl.TextSize = 11
        btnLbl.Font = Enum.Font.GothamMedium
        btnLbl.TextXAlignment = Enum.TextXAlignment.Left
        btnLbl.Parent = btn

        if S.FireType == fireName then
            btn.BackgroundColor3 = C.ACC
            btn.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
            btnStroke.Color = C.ACC2
        end

        btn.MouseButton1Click:Connect(function()
            S.FireType = fireName
            applyFire()
            for _, c in pairs(cs:GetChildren()) do
                if c:IsA("TextButton") and c.LayoutOrder > 100 and c.LayoutOrder < 200 then
                    c.BackgroundColor3 = C.BG
                    c.BackgroundTransparency = 0.4
                    local l = c:FindFirstChildOfClass("TextLabel")
                    if l then l.TextColor3 = C.TXT end
                end
            end
            btn.BackgroundColor3 = C.ACC
            btn.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
            btnStroke.Color = C.ACC2
        end)
    end
end)

-- TAB FIRE FEET
makeTab("Fire Feet", "👟", 2, function()
    sec("Fire Feet Control", "👟")
    tog("Enable Fire Feet", false, function(s) S.FireFeetOn = s; applyFireFeet() end)

    sec("Pilih Efek Fire Feet (20)", "🔥")
    lbl("Klik efek untuk ganti", C.ACC2)

    for i, fireName in ipairs(FireFeetList) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 28)
        btn.BackgroundColor3 = C.BG
        btn.BackgroundTransparency = 0.4
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.LayoutOrder = i + 200
        btn.Parent = cs
        rnd(btn, 8)
        local btnStroke = strk(btn, C.ACC, 1, 0.6)

        local btnLbl = Instance.new("TextLabel")
        btnLbl.Size = UDim2.new(1, -10, 1, 0)
        btnLbl.Position = UDim2.new(0, 10, 0, 0)
        btnLbl.BackgroundTransparency = 1
        btnLbl.Text = "👟 " .. fireName
        btnLbl.TextColor3 = C.TXT
        btnLbl.TextSize = 11
        btnLbl.Font = Enum.Font.GothamMedium
        btnLbl.TextXAlignment = Enum.TextXAlignment.Left
        btnLbl.Parent = btn

        if S.FireFeetType == fireName then
            btn.BackgroundColor3 = C.ACC
            btn.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
            btnStroke.Color = C.ACC2
        end

        btn.MouseButton1Click:Connect(function()
            S.FireFeetType = fireName
            applyFireFeet()
            for _, c in pairs(cs:GetChildren()) do
                if c:IsA("TextButton") and c.LayoutOrder > 200 and c.LayoutOrder < 300 then
                    c.BackgroundColor3 = C.BG
                    c.BackgroundTransparency = 0.4
                    local l = c:FindFirstChildOfClass("TextLabel")
                    if l then l.TextColor3 = C.TXT end
                end
            end
            btn.BackgroundColor3 = C.ACC
            btn.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
            btnStroke.Color = C.ACC2
        end)
    end
end)

print("✅ [10/12] Tab Fire + Fire Feet loaded")-- =========================================================
-- BAGIAN 11/12 : ISI TAB ESP + SURVIVOR + VISUAL + MOVEMENT
-- =========================================================

-- TAB ESP
makeTab("ESP", "👁️", 3, function()
    sec("Player ESP + Nama", "🟢")
    tog("Enable ESP Name", false, function(s)
        S.ESP_Name = s
        if not s then
            for _, bb in pairs(StatusESP) do if bb then bb:Destroy() end end
            StatusESP = {}
        end
    end)
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

-- TAB SURVIVOR
makeTab("Survivor", "🏃", 4, function()
    sec("Auto Parry 360°", "🛡️")
    tog("Enable Auto Parry", false, function(s) S.Parry = s; if s then scanKillers() end end)
    sl("Parry Distance", 3, 15, 8, function(v) S.ParryDist = v end)

    sec("Parry Circle", "🔵")
    tog("Enable Parry Circle", false, function(s) S.ParryCircle = s end)
    sl("Circle Size", 5, 50, 15, function(v) S.ParryCircleSize = v end)

    sec("Auto Skill Check", "🎯")
    tog("Enable Skill Check", false, function(s) S.Skill = s end)

    sec("Aimlock Killer → Survivor", "🎯")
    tog("Enable Aimlock", false, function(s) S.Aimlock = s end)
    sl("Aimlock Radius", 50, 2000, 500, function(v) S.AimlockRadius = v end)
    tog("Show Aimlock Button", false, function(s)
        if s then createAimlockButton() else removeAimlockButton() end
    end)
    tog("🔒 Lock Aimlock Button", false, function(s)
        S.AimlockLocked = s
        updateAimlockLock()
    end)
    btn("🔄 Reset Posisi Aimlock", function()
        if _G.AimlockButton then
            local b = _G.AimlockButton:FindFirstChild("AimlockBtn", true)
            if b then b.Position = UDim2.new(0.35, 0, 0.75, 0) end
        end
    end)
end)

-- TAB VISUAL
makeTab("Visual", "🎨", 5, function()
    sec("Top 5 Wajib", "⭐")
    tog("Fullbright", false, function(s) S.Fullbright = s; applyFullbright(s) end)
    tog("No Fog", false, function(s) S.NoFog = s; applyNoFog(s) end)
    tog("Ultra HD", false, function(s) S.UltraHD = s; applyUltraHD() end)
    tog("Contrast", false, function(s) S.Contrast = s; applyContrast() end)
    sl("Contrast Value", -1, 2, 0.3, function(v) S.ContrastVal = v; applyContrast() end)
    sl("Saturation", -1, 1, 0.2, function(v) S.SaturationVal = v; applyContrast() end)

    sec("FOV Changer", "📸")
    tog("Enable FOV", false, function(s) S.FOVEnabled = s; applyFOV() end)
    sl("FOV Value", 40, 120, 70, function(v) S.FOV = v; applyFOV() end)

    sec("Sky Changer (25 Sky)", "🌤️")
    lbl("Klik untuk ganti sky", C.ACC2)
    for i, skyName in ipairs(SkyList) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 26)
        btn.BackgroundColor3 = C.BG
        btn.BackgroundTransparency = 0.4
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.LayoutOrder = i + 300
        btn.Parent = cs
        rnd(btn, 6)
        local btnStroke = strk(btn, C.ACC, 1, 0.6)

        local btnLbl = Instance.new("TextLabel")
        btnLbl.Size = UDim2.new(1, -10, 1, 0)
        btnLbl.Position = UDim2.new(0, 10, 0, 0)
        btnLbl.BackgroundTransparency = 1
        btnLbl.Text = "🌤️ " .. skyName
        btnLbl.TextColor3 = C.TXT
        btnLbl.TextSize = 10
        btnLbl.Font = Enum.Font.GothamMedium
        btnLbl.TextXAlignment = Enum.TextXAlignment.Left
        btnLbl.Parent = btn

        if S.SkyId == skyName then
            btn.BackgroundColor3 = C.ACC
            btn.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
            btnStroke.Color = C.ACC2
        end

        btn.MouseButton1Click:Connect(function()
            S.SkyId = skyName
            applySky(skyName)
            for _, c in pairs(cs:GetChildren()) do
                if c:IsA("TextButton") and c.LayoutOrder > 300 then
                 
