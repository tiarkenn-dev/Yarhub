-- =========================================================
-- ROOORHUB PREMIUM ULTIMATE + 8BIT + FINAL
-- BAGIAN 1/7 : LOADING ANIMATION + CONFIG
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
    GOLD = Color3.fromRGB(255, 215, 0),
    TXT = Color3.fromRGB(245, 245, 255),
    DIM = Color3.fromRGB(120, 120, 160),
    GRN = Color3.fromRGB(0, 255, 150),
    RED = Color3.fromRGB(255, 70, 100),
}

local function rnd(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = o
end

local function strk(o, col, t, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or C.GOLD
    s.Thickness = t or 1.5
    s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = o
    return s
end

-- =========================================================
-- LOADING ANIMATION 3D
-- =========================================================
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "RoooorLoading"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 999999
loadingGui.Parent = PG

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BorderSizePixel = 0
bg.Parent = loadingGui

local logoContainer = Instance.new("Frame")
logoContainer.Size = UDim2.new(0, 220, 0, 220)
logoContainer.Position = UDim2.new(0.5, -110, 0.5, -110)
logoContainer.BackgroundTransparency = 1
logoContainer.Parent = bg

local outerRing = Instance.new("Frame")
outerRing.Size = UDim2.new(1, 0, 1, 0)
outerRing.BackgroundTransparency = 1
outerRing.Parent = logoContainer
local outerStroke = Instance.new("UIStroke")
outerStroke.Thickness = 4
outerStroke.Color = C.ACC
outerStroke.Transparency = 0.2
outerStroke.Parent = outerRing
local outerGrad = Instance.new("UIGradient")
outerGrad.Color = ColorSequence.new(C.ACC, C.ACC2, C.ACC3, C.ACC4)
outerGrad.Parent = outerStroke

local innerRing = Instance.new("Frame")
innerRing.Size = UDim2.new(0.7, 0, 0.7, 0)
innerRing.Position = UDim2.new(0.15, 0, 0.15, 0)
innerRing.BackgroundTransparency = 1
innerRing.Parent = logoContainer
local innerStroke = Instance.new("UIStroke")
innerStroke.Thickness = 3
innerStroke.Color = Color3.new(1, 1, 1)
innerStroke.Transparency = 0.5
innerStroke.Parent = innerRing

local core = Instance.new("Frame")
core.Size = UDim2.new(0.3, 0, 0.3, 0)
core.Position = UDim2.new(0.35, 0, 0.35, 0)
core.BackgroundColor3 = C.ACC2
core.Parent = logoContainer
rnd(core, 999)

local loadText = Instance.new("TextLabel")
loadText.Size = UDim2.new(1, 0, 0, 30)
loadText.Position = UDim2.new(0, 0, 1, 20)
loadText.BackgroundTransparency = 1
loadText.Text = "ROOORHUB LOADING..."
loadText.TextColor3 = C.ACC
loadText.TextSize = 14
loadText.Font = Enum.Font.GothamBlack
loadText.TextStrokeTransparency = 0.5
loadText.Parent = logoContainer

-- 3D-ish rotation
task.spawn(function()
    local t = 0
    while bg.Parent do
        t = t + 0.02
        outerRing.Rotation = t * 50
        innerRing.Rotation = -t * 80
        core.Size = UDim2.new(0.3 + math.sin(t * 3) * 0.05, 0, 0.3 + math.sin(t * 3) * 0.05, 0)
        core.Position = UDim2.new(0.35 - math.sin(t * 3) * 0.025, 0, 0.35 - math.sin(t * 3) * 0.025, 0)
        outerGrad.Rotation = t * 100
        task.wait(0.02)
    end
end)

-- Loading progress
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 300, 0, 4)
progressBar.Position = UDim2.new(0.5, -150, 1, 60)
progressBar.BackgroundColor3 = C.PANEL
progressBar.BorderSizePixel = 0
progressBar.Parent = logoContainer
rnd(progressBar, 2)

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = C.ACC2
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBar
rnd(progressFill, 2)

task.spawn(function()
    for i = 0, 1, 0.02 do
        if not bg.Parent then break end
        progressFill.Size = UDim2.new(i, 0, 1, 0)
        task.wait(0.045)
    end
end)

-- Auto destroy setelah 3 detik
task.delay(3, function()
    TweenService:Create(bg, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    TweenService:Create(logoContainer, TweenInfo.new(0.8), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.8)
    loadingGui:Destroy()
end)

-- =========================================================
-- STATE
-- =========================================================
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
    AimlockMode = "Killer",
    WalkSpeed = false, WalkSpeedVal = 16, WalkSpeedBoost = 0,
    Korblox = false, Headless = false,
    Killer_AutoAtk = false, Killer_AtkDelay = 0.35,
    Killer_KillAll = false,
    Killer_Hitbox = false, Killer_HitboxSize = 15,
    Killer_Hitbox_Visible = true,
    Killer_AutoStalk = false, Killer_StalkRange = 150,
    MaskedPower = "Cobra",
    FastVault = false, FastVaultSpeed = 1.5,
    EightBitCrown = false, EightBitHP = false, EightBitCat = false,
    EightBitSize = 1,
    Trail = false, TrailColor = Color3.fromRGB(180, 80, 255),
    Aura = false, AuraColor = Color3.fromRGB(180, 80, 255),
    KillEffect = false,
    Crosshair = false, CrosshairColor = Color3.fromRGB(0, 255, 200), CrosshairSize = 8,
    NoClipCamera = false,
    ZoomOut = false, ZoomOutValue = 500,
    RGBUI = false,
}

local S = _G.RoooorS
_G.ToggleStates = _G.ToggleStates or {}
_G.SliderStates = _G.SliderStates or {}

_G.RoooorExtra = _G.RoooorExtra or {
    AntiStun = false, AntiBlind = false, AntiGrab = false,
    AntiHook = false, AntiRagdoll = false, AntiAFK = false,
    Fly = false, FlySpeed = 50,
    ItemESP = false, ItemESPColor = Color3.fromRGB(255, 255, 100),
}
local X = _G.RoooorExtra

print("✅ [1/7] Loading + Config loaded")-- =========================================================
-- BAGIAN 2/7 : FIRE CONFIG + FIRE FEET + SKY + KILLER ANIMS
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
    "Purple", "Galaxy", "Void",
}

-- SKY IDS (FIX — yang work)
local SkyIds = {
    Sunset = {
        Bk = "rbxassetid://169210149", Dn = "rbxassetid://169210108",
        Ft = "rbxassetid://169210121", Lf = "rbxassetid://169210133",
        Rt = "rbxassetid://169210143", Up = "rbxassetid://169210149"
    },
    Night = {
        Bk = "rbxassetid://18703245834", Dn = "rbxassetid://18703245834",
        Ft = "rbxassetid://18703245834", Lf = "rbxassetid://18703245834",
        Rt = "rbxassetid://18703245834", Up = "rbxassetid://18703245834"
    },
    Space = {
        Bk = "rbxassetid://17817511804", Dn = "rbxassetid://17817520184",
        Ft = "rbxassetid://17817511804", Lf = "rbxassetid://17817511804",
        Rt = "rbxassetid://17817511804", Up = "rbxassetid://17817511804"
    },
    Alien = {
        Bk = "rbxassetid://10253172001", Dn = "rbxassetid://10253172001",
        Ft = "rbxassetid://10253172001", Lf = "rbxassetid://10253172001",
        Rt = "rbxassetid://10253172001", Up = "rbxassetid://10253172001"
    },
    Purple = {
        Bk = "rbxassetid://6021017254", Dn = "rbxassetid://6021011228",
        Ft = "rbxassetid://6021017254", Lf = "rbxassetid://6021017254",
        Rt = "rbxassetid://6021017254", Up = "rbxassetid://6021017254"
    },
    Galaxy = {
        Bk = "rbxassetid://126146408999925", Dn = "rbxassetid://118112392224589",
        Ft = "rbxassetid://121253817183621", Lf = "rbxassetid://138429250948648",
        Rt = "rbxassetid://126146408999925", Up = "rbxassetid://126146408999925"
    },
    Void = {
        Bk = "rbxassetid://17817511804", Dn = "rbxassetid://17817520184",
        Ft = "rbxassetid://17817511804", Lf = "rbxassetid://17817511804",
        Rt = "rbxassetid://17817511804", Up = "rbxassetid://17817511804"
    },
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

local function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

print("✅ [2/7] Fire + Fire Feet + Sky + KillerAnims loaded")-- =========================================================
-- BAGIAN 3/7 : SEMUA FUNGSI
-- =========================================================

-- ============================
-- FIRE
-- ============================
local function clearFire()
    if not LP.Character then return end
    local head = LP.Character:FindFirstChild("Head")
    if not head then return end
    for _, obj in pairs(head:GetChildren()) do
        if obj.Name == "RoooorFire" or obj.Name == "RoooorSmoke" or obj.Name == "RoooorSparkles" then
            obj:Destroy()
        end
    end
end

local function applyFire()
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

local function clearFireFeet()
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

local function applyFireFeet()
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

-- Rainbow loop
task.spawn(function()
    while task.wait(0.1) do
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

-- ============================
-- 8-BIT (BISA RESIZE + EFEK ASLI)
-- ============================
local function apply8BitCrown(enable, size)
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("Roooor8BitCrown")
    if old then old:Destroy() end
    if not enable then return end

    size = size or 1
    local crown = Instance.new("Part")
    crown.Name = "Roooor8BitCrown"
    crown.Size = Vector3.new(2, 1.5, 2) * size
    crown.CanCollide = false
    crown.Massless = true
    crown.Transparency = 0
    crown.Parent = head

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://10138606900"
    mesh.TextureId = "rbxassetid://10138606949"
    mesh.Scale = Vector3.new(1.5, 1.5, 1.5) * size
    mesh.Parent = crown

    local weld = Instance.new("Weld")
    weld.Part0 = head
    weld.Part1 = crown
    weld.C0 = CFrame.new(0, 1.2 * size, 0)
    weld.Parent = crown

    local emitter = Instance.new("ParticleEmitter")
    emitter.Texture = "rbxassetid://243660364"
    emitter.Rate = 15
    emitter.Lifetime = NumberRange.new(2.5)
    emitter.Speed = NumberRange.new(3)
    emitter.Size = NumberSequence.new(1.5 * size)
    emitter.SpreadAngle = Vector2.new(15, 15)
    emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    emitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(131, 253, 255)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(0, 213, 255)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 122, 34)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(198, 42, 11))
    })
    emitter.Parent = crown
end

local function apply8BitHP(enable, size)
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("Roooor8BitHP")
    if old then old:Destroy() end
    if not enable then return end

    size = size or 1
    local hp = Instance.new("Part")
    hp.Name = "Roooor8BitHP"
    hp.Size = Vector3.new(1.5, 1.5, 0.5) * size
    hp.CanCollide = false
    hp.Massless = true
    hp.Transparency = 0
    hp.Parent = head

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://10138542409"
    mesh.TextureId = "rbxassetid://10138542374"
    mesh.Scale = Vector3.new(1.2, 1.2, 1.2) * size
    mesh.Parent = hp

    local weld = Instance.new("Weld")
    weld.Part0 = head
    weld.Part1 = hp
    weld.C0 = CFrame.new(1.2 * size, 1.0 * size, 0)
    weld.Parent = hp

    local heart = Instance.new("ParticleEmitter")
    heart.Texture = "rbxassetid://6023564503"
    heart.Rate = 5
    heart.Lifetime = NumberRange.new(1.5)
    heart.Speed = NumberRange.new(1)
    heart.Size = NumberSequence.new(0.5 * size)
    heart.Color = ColorSequence.new(Color3.fromRGB(255, 50, 100))
    heart.Parent = hp
end

local function apply8BitCat(enable, size)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local old = char:FindFirstChild("Roooor8BitCat")
    if old then old:Destroy() end
    if not enable then return end

    size = size or 1
    local cat = Instance.new("Part")
    cat.Name = "Roooor8BitCat"
    cat.Size = Vector3.new(1.5, 1.5, 1.5) * size
    cat.CanCollide = false
    cat.Massless = true
    cat.Transparency = 0
    cat.Parent = char

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://10159617728"
    mesh.Scale = Vector3.new(1, 1, 1) * size
    mesh.Parent = cat

    local weld = Instance.new("Weld")
    weld.Part0 = hrp
    weld.Part1 = cat
    weld.C0 = CFrame.new(1.2 * size, 0.8 * size, 0)
    weld.Parent = cat
end

local function apply8BitSet(enable)
    apply8BitCrown(enable, S.EightBitSize)
    apply8BitHP(enable, S.EightBitSize)
    apply8BitCat(enable, S.EightBitSize)
end

-- ============================
-- ESP
-- ============================
local ESPObjects = {}
local StatusESP = {}
local Cached = { Generators = {}, Windows = {}, Pallets = {}, SCPs = {} }

local function cacheObject(obj)
    if obj.Name == "Generator" then Cached.Generators[obj] = true
    elseif obj.Name == "Window" then Cached.Windows[obj] = true
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then Cached.Pallets[obj] = true
    elseif string.find(string.lower(obj.Name), "scp") then Cached.SCPs[obj] = true end
end

for _, obj in ipairs(workspace:GetDescendants()) do cacheObject(obj) end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(function(obj)
    Cached.Generators[obj] = nil
    Cached.Windows[obj] = nil
    Cached.Pallets[obj] = nil
    Cached.SCPs[obj] = nil
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
end)

local function createESP(obj, color)
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

local function removeESP(obj)
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
end

local function createStatusESP(player, char, root)
    if not S.ESP_Name then
        if StatusESP[char] then StatusESP[char]:Destroy(); StatusESP[char] = nil end
        return
    end
    if not root then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    local dist = (head.Position - root.Position).Magnitude
    if dist > S.ESP_Radius then
        if StatusESP[char] then StatusESP[char]:Destroy(); StatusESP[char] = nil end
        return
    end

    local isDown = hum.Health <= 0
    local text = (isDown and "🔻 DOWN\n" or "") .. player.Name .. "\n" ..
        string.format("Dist: %.0f\n", dist) .. string.format("HP: %.0f", hum.Health)

    local billboard = StatusESP[char]
    local teamColor = S.ESP_DefaultColor
    if player.Team then
        if player.Team.Name == "Killer" then teamColor = S.ESP_KillerColor
        elseif player.Team.Name == "Survivors" then teamColor = S.ESP_SurvivorColor end
    end
    if isDown then teamColor = Color3.fromRGB(255, 0, 0) end

    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 150, 0, 50)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = teamColor
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = S.ESP_Size
        label.Parent = billboard
        billboard.Adornee = head
        billboard.Parent = char
        StatusESP[char] = billboard
    else
        local label = billboard:FindFirstChildOfClass("TextLabel")
        if label then
            label.Text = text
            label.TextColor3 = teamColor
            label.TextSize = S.ESP_Size
        end
    end
end

-- ============================
-- AUTO PARRY GACOR v3
-- ============================
local lastParry = 0
local PARRY_DEBOUNCE = 0.05
local hookedKillers = _G.HookedKillers or {}
_G.HookedKillers = hookedKillers

local function getParryRange() return (S.ParryDist or 8) + 10 end

local function GetParryButton()
    local cur = PG
    for seg in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        cur = cur and cur:FindFirstChild(seg)
    end
    return cur
end

local function pressParry()
    pcall(function()
        local btn = GetParryButton()
        if UIS.TouchEnabled then
            if btn and btn:IsA("GuiObject") then
                local pos = btn.AbsolutePosition + btn.AbsoluteSize/2
                local inset = GuiService:GetGuiInset()
                VirtualInputManager:SendTouchEvent(8823, 0, pos.X + inset.X, pos.Y + inset.Y)
                task.wait(0.003)
                VirtualInputManager:SendTouchEvent(8823, 2, pos.X + inset.X, pos.Y + inset.Y)
            end
        else
            local x, y = 0, 0
            if btn and btn:IsA("GuiObject") then
                local pos = btn.AbsolutePosition + btn.AbsoluteSize/2
                local inset = GuiService:GetGuiInset()
                x = pos.X + inset.X
                y = pos.Y + inset.Y
            end
            VirtualInputManager:SendMouseButtonEvent(x, y, 1, true, game, 0)
            task.wait(0.005)
            VirtualInputManager:SendMouseButtonEvent(x, y, 1, false, game, 0)
        end
    end)
end

local function doParry()
    local now = tick()
    if now - lastParry < PARRY_DEBOUNCE then return end
    lastParry = now
    pressParry()
end

local function isInRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local eRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not eRoot then return false end
    local vel = eRoot.AssemblyLinearVelocity
    local pred = eRoot.Position + vel * 0.15
    local dNow = (eRoot.Position - myRoot.Position).Magnitude
    local dPred = (pred - myRoot.Position).Magnitude
    local r = getParryRange()
    return dNow <= r or dPred <= r
end

local function hookKiller(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local anim = hum:FindFirstChildOfClass("Animator")
    if not anim then return end

    anim.AnimationPlayed:Connect(function(track)
        if not S.Parry then return end
        local a = track.Animation
        if not a then return end
        local id = tostring(a.AnimationId):match("%d+")
        if id and KillerAnims["rbxassetid://"..id] and isInRange(char) then
            doParry()
        end
    end)

    task.spawn(function()
        while char.Parent and hookedKillers[char] do
            task.wait(0.005)
            if not S.Parry then break end
            local myRoot = getRoot()
            local eRoot = char:FindFirstChild("HumanoidRootPart")
            if not myRoot or not eRoot then continue end
            if (eRoot.Position - myRoot.Position).Magnitude > getParryRange() + 5 then continue end
            for _, track in ipairs(anim:GetPlayingAnimationTracks()) do
                local a = track.Animation
                if a and a.AnimationId then
                    local id = tostring(a.AnimationId):match("%d+")
                    if id and KillerAnims["rbxassetid://"..id] then
                        doParry()
                        break
                    end
                end
            end
        end
    end)
end

local function scanKillers()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
            hookKiller(p.Character)
        end
    end
end

-- ============================
-- VISUAL
-- ============================
local origLighting = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
}

local function applyFullbright(s)
    if s then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = origLighting.Brightness
        Lighting.ClockTime = origLighting.ClockTime
        Lighting.Ambient = origLighting.Ambient
        Lighting.OutdoorAmbient = origLighting.OutdoorAmbient
        Lighting.GlobalShadows = origLighting.GlobalShadows
    end
end

local function applyNoFog(s)
    if s then
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
    else
        Lighting.FogEnd = origLighting.FogEnd
        Lighting.FogStart = origLighting.FogStart
    end
end

local origSky = nil
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("Sky") then origSky = v:Clone() break end
end

local function applySky(skyName)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end
    if skyName and skyName ~= "Default" and SkyIds[skyName] then
        local ids = SkyIds[skyName]
        local sky = Instance.new("Sky")
        sky.SkyboxBk = ids.Bk
        sky.SkyboxDn = ids.Dn or ids.Bk
        sky.SkyboxFt = ids.Ft or ids.Bk
        sky.SkyboxLf = ids.Lf or ids.Bk
        sky.SkyboxRt = ids.Rt or ids.Bk
        sky.SkyboxUp = ids.Up or ids.Bk
        sky.Parent = Lighting
    elseif origSky then
        origSky:Clone().Parent = Lighting
    end
end

local function applyFOV()
    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = S.FOVEnabled and S.FOV or 70 end
end

local function applyUltraHD()
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

local function applyContrast()
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

-- KORBLOX (FIX)
local KorbloxOrig = nil
local function applyKorblox(s)
    local char = LP.Character
    if not char then return end
    local rightLeg = char:FindFirstChild("Right Leg")
        or char:FindFirstChild("RightUpperLeg")
        or char:FindFirstChild("RightLowerLeg")
    if not rightLeg then return end

    if s then
        if not KorbloxOrig then
            KorbloxOrig = {Color = rightLeg.Color, Material = rightLeg.Material, Size = rightLeg.Size}
        end
        rightLeg.Color = Color3.fromRGB(27, 42, 53)
        rightLeg.Material = Enum.Material.Slate
        rightLeg.Transparency = 0

        local oldMesh = rightLeg:FindFirstChild("RoooorKorblox")
        if oldMesh then oldMesh:Destroy() end

        local mesh = Instance.new("SpecialMesh")
        mesh.Name = "RoooorKorblox"
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://902942093"
        mesh.TextureId = "rbxassetid://902942089"
        mesh.Scale = Vector3.new(1, 1, 1)
        mesh.Parent = rightLeg
    else
        local oldMesh = rightLeg:FindFirstChild("RoooorKorblox")
        if oldMesh then oldMesh:Destroy() end
        if KorbloxOrig then
            rightLeg.Color = KorbloxOrig.Color
            rightLeg.Material = KorbloxOrig.Material
            rightLeg.Size = KorbloxOrig.Size
            KorbloxOrig = nil
        else
            rightLeg.Material = Enum.Material.Plastic
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if S.Korblox and LP.Character then
            local rightLeg = LP.Character:FindFirstChild("Right Leg")
                or LP.Character:FindFirstChild("RightUpperLeg")
                or LP.Character:FindFirstChild("RightLowerLeg")
            if rightLeg and not rightLeg:FindFirstChild("RoooorKorblox") then
                applyKorblox(true)
            end
        end
    end
end)

-- HEADLESS
local function applyHeadless(s)
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if s then
        head.Transparency = 1
        for _, v in pairs(head:GetChildren()) do
            if v:IsA("Decal") or v:IsA("SpecialMesh") or v:IsA("Mesh") then v.Transparency = 1 end
        end
    else
        head.Transparency = 0
        for _, v in pairs(head:GetChildren()) do
            if v:IsA("Decal") or v:IsA("SpecialMesh") or v:IsA("Mesh") then v.Transparency = 0 end
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if S.Headless and LP.Character then
            local head = LP.Character:FindFirstChild("Head")
            if head then
                if head.Transparency ~= 1 then head.Transparency = 1 end
                for _, v in pairs(head:GetChildren()) do
                    if (v:IsA("Decal") or v:IsA("SpecialMesh") or v:IsA("Mesh")) and v.Transparency ~= 1 then
                        v.Transparency = 1
                    end
                end
            end
        end
    end
end)

-- WALK SPEED
task.spawn(function()
    while task.wait(0.1) do
        if S.WalkSpeed and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local target = S.WalkSpeedVal + (S.WalkSpeedBoost or 0)
                if hum.WalkSpeed ~= target then hum.WalkSpeed = target end
            end
        end
    end
end)

-- TRAIL EFFECT
local trailObj = nil
local function applyTrail(enable, color)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if trailObj then trailObj:Destroy(); trailObj = nil end
    if not enable then return end
    local a0 = Instance.new("Attachment"); a0.Position = Vector3.new(0, 1, 0); a0.Parent = hrp
    local a1 = Instance.new("Attachment"); a1.Position = Vector3.new(0, -1, 0); a1.Parent = hrp
    trailObj = Instance.new("Trail")
    trailObj.Attachment0 = a0
    trailObj.Attachment1 = a1
    trailObj.Color = ColorSequence.new(color or C.ACC)
    trailObj.Lifetime = 0.5
    trailObj.LightEmission = 1
    trailObj.Parent = hrp
end

-- AURA EFFECT
local auraObj = nil
local function applyAura(enable, color)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if auraObj then auraObj:Destroy(); auraObj = nil end
    if not enable then return end
    auraObj = Instance.new("ParticleEmitter")
    auraObj.Texture = "rbxassetid://243660364"
    auraObj.Color = ColorSequence.new(color or C.ACC)
    auraObj.Size = NumberSequence.new(2)
    auraObj.Lifetime = NumberRange.new(0.5, 1)
    auraObj.Rate = 30
    auraObj.Speed = NumberRange.new(2)
    auraObj.SpreadAngle = Vector2.new(180, 180)
    auraObj.Parent = hrp
end

-- KILL EFFECT
local function spawnKillEffect(pos)
    local p = Instance.new("Part")
    p.Anchored = true; p.CanCollide = false
    p.Material = Enum.Material.Neon
    p.Shape = Enum.PartType.Ball
    p.Size = Vector3.new(2, 2, 2)
    p.Position = pos
    p.Color = Color3.fromRGB(255, 50, 50)
    p.Transparency = 0.3
    p.Parent = workspace
    TweenService:Create(p, TweenInfo.new(0.5), {Size = Vector3.new(15, 15, 15), Transparency = 1}):Play()
    task.delay(0.6, function() p:Destroy() end)
end

-- CROSSHAIR
local crosshairGui = nil
local function applyCrosshair(enable, color, size)
    if crosshairGui then crosshairGui:Destroy(); crosshairGui = nil end
    if not enable then return end
    crosshairGui = Instance.new("ScreenGui")
    crosshairGui.Name = "RoooorCrosshair"
    crosshairGui.ResetOnSpawn = false
    crosshairGui.IgnoreGuiInset = true
    crosshairGui.Parent = PG
    for i = 1, 4 do
        local ln = Instance.new("Frame")
        ln.BackgroundColor3 = color or C.ACC2
        ln.BorderSizePixel = 0
        if i == 1 then ln.Size = UDim2.new(0, size or 8, 0, 2); ln.Position = UDim2.new(0.5, -(size or 8) - 3, 0.5, -1)
        elseif i == 2 then ln.Size = UDim2.new(0, size or 8, 0, 2); ln.Position = UDim2.new(0.5, 3, 0.5, -1)
        elseif i == 3 then ln.Size = UDim2.new(0, 2, 0, size or 8); ln.Position = UDim2.new(0.5, -1, 0.5, -(size or 8) - 3)
        elseif i == 4 then ln.Size = UDim2.new(0, 2, 0, size or 8); ln.Position = UDim2.new(0.5, -1, 0.5, 3) end
        ln.Parent = crosshairGui
    end
end

-- ZOOM OUT
local function applyZoomOut(enable, val)
    if enable then LP.CameraMaxZoomDistance = val or 500
    else LP.CameraMaxZoomDistance = 128 end
end

-- TELEPORT FINISH
local function teleportToFinishLine()
    local root = getRoot()
    if not root then return end
    local found = nil
    local names = {"fininshline", "finishline", "finish", "gate", "exit", "escape"}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local lname = string.lower(obj.Name)
            for _, search in ipairs(names) do
                if string.find(lname, search) then found = obj; break end
            end
            if found then break end
        end
    end
    if found then root.CFrame = found.CFrame + Vector3.new(0, 5, 0)
    else warn("[RoooorHub] Finish gak ketemu") end
end

-- GLOBAL
_G.Roooor_applyFire = applyFire
_G.Roooor_applyFireFeet = applyFireFeet
_G.Roooor_apply8BitCrown = apply8BitCrown
_G.Roooor_apply8BitHP = apply8BitHP
_G.Roooor_apply8BitCat = apply8BitCat
_G.Roooor_apply8BitSet = apply8BitSet
_G.Roooor_createESP = createESP
_G.Roooor_removeESP = removeESP
_G.Roooor_createStatusESP = createStatusESP
_G.Roooor_Cached = Cached
_G.Roooor_StatusESP = StatusESP
_G.Roooor_scanKillers = scanKillers
_G.Roooor_applyFullbright = applyFullbright
_G.Roooor_applyNoFog = applyNoFog
_G.Roooor_applySky = applySky
_G.Roooor_applyFOV = applyFOV
_G.Roooor_applyUltraHD = applyUltraHD
_G.Roooor_applyContrast = applyContrast
_G.Roooor_applyKorblox = applyKorblox
_G.Roooor_applyHeadless = applyHeadless
_G.Roooor_applyTrail = applyTrail
_G.Roooor_applyAura = applyAura
_G.Roooor_applyCrosshair = applyCrosshair
_G.Roooor_applyZoomOut = applyZoomOut
_G.Roooor_teleportToFinishLine = teleportToFinishLine
_G.Roooor_spawnKillEffect = spawnKillEffect

print("✅ [3/7] Semua fungsi loaded")-- =========================================================
-- BAGIAN 4/7 : GUI + KOMPONEN
-- =========================================================

local gui = Instance.new("ScreenGui")
gui.Name = "RoooorHubNew"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PG

-- TOMBOL FLOATING (DIPERKECIL)
local mainBtn = Instance.new("TextButton")
mainBtn.Size = UDim2.new(0, 46, 0, 46)
mainBtn.Position = UDim2.new(0, 15, 0.3, 0)
mainBtn.BackgroundColor3 = C.PANEL
mainBtn.Text = "⚡"
mainBtn.TextColor3 = C.GOLD
mainBtn.TextSize = 24
mainBtn.Font = Enum.Font.GothamBlack
mainBtn.BorderSizePixel = 0
mainBtn.AutoButtonColor = false
mainBtn.Parent = gui
rnd(mainBtn, 23)
strk(mainBtn, C.GOLD, 2)

local glow = Instance.new("Frame")
glow.Size = UDim2.new(1, 12, 1, 12)
glow.Position = UDim2.new(0, -6, 0, -6)
glow.BackgroundColor3 = C.GOLD
glow.BackgroundTransparency = 0.7
glow.BorderSizePixel = 0
glow.ZIndex = -1
glow.Parent = mainBtn
rnd(glow, 30)

task.spawn(function()
    while mainBtn.Parent do
        local t = tick()
        local pulse = (math.sin(t * 3) + 1) / 2
        glow.BackgroundTransparency = 0.85 - pulse * 0.4
        glow.Size = UDim2.new(1, 8 + pulse * 10, 1, 8 + pulse * 10)
        glow.Position = UDim2.new(0, -4 - pulse * 5, 0, -4 - pulse * 5)
        task.wait(0.03)
    end
end)

-- PANEL (DIPERKECIL)
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 440, 0, 380)
panel.Position = UDim2.new(0.5, -220, 0.5, -190)
panel.BackgroundColor3 = C.BG
panel.BackgroundTransparency = 0.05
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = gui
rnd(panel, 18)
strk(panel, C.GOLD, 2, 0.2)

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 46)
header.BackgroundColor3 = C.PANEL
header.BackgroundTransparency = 0.1
header.BorderSizePixel = 0
header.Parent = panel
rnd(header, 18)

local hPatch = Instance.new("Frame")
hPatch.Size = UDim2.new(1, 0, 0, 23)
hPatch.Position = UDim2.new(0, 0, 1, -23)
hPatch.BackgroundColor3 = C.PANEL
hPatch.BackgroundTransparency = 0.1
hPatch.BorderSizePixel = 0
hPatch.Parent = header

-- NEON LINE (EFEK KEREN)
local neonLine = Instance.new("Frame")
neonLine.Size = UDim2.new(1, -40, 0, 2)
neonLine.Position = UDim2.new(0, 20, 1, -1)
neonLine.BackgroundColor3 = C.ACC
neonLine.BorderSizePixel = 0
neonLine.Parent = header
local neonGrad = Instance.new("UIGradient")
neonGrad.Color = ColorSequence.new(C.ACC, C.ACC2, C.ACC3, C.ACC4)
neonGrad.Parent = neonLine

task.spawn(function()
    while neonLine.Parent do
        for i = 0, 1, 0.02 do
            if not neonLine.Parent then break end
            neonGrad.Rotation = i * 360
            task.wait(0.05)
        end
    end
end)

local hTitle = Instance.new("TextLabel")
hTitle.Size = UDim2.new(1, -100, 1, 0)
hTitle.Position = UDim2.new(0, 18, 0, 0)
hTitle.BackgroundTransparency = 1
hTitle.Text = "⚡ ROOORHUB PREMIUM + 8BIT"
hTitle.TextColor3 = C.GOLD
hTitle.TextSize = 14
hTitle.Font = Enum.Font.GothamBlack
hTitle.TextXAlignment = Enum.TextXAlignment.Left
hTitle.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0.5, -13)
closeBtn.BackgroundColor3 = C.PANEL2
closeBtn.Text = "✕"
closeBtn.TextColor3 = C.RED
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = header
rnd(closeBtn, 7)
strk(closeBtn, C.RED, 1, 0.5)

-- SIDEBAR
local sbFrame = Instance.new("Frame")
sbFrame.Size = UDim2.new(0, 118, 1, -66)
sbFrame.Position = UDim2.new(0, 12, 0, 58)
sbFrame.BackgroundColor3 = C.PANEL
sbFrame.BackgroundTransparency = 0.2
sbFrame.BorderSizePixel = 0
sbFrame.Parent = panel
rnd(sbFrame, 12)
strk(sbFrame, C.GOLD, 1, 0.6)

local sb = Instance.new("ScrollingFrame")
sb.Size = UDim2.new(1, -4, 1, -4)
sb.Position = UDim2.new(0, 2, 0, 2)
sb.BackgroundTransparency = 1
sb.BorderSizePixel = 0
sb.ScrollBarThickness = 3
sb.ScrollBarImageColor3 = C.GOLD
sb.CanvasSize = UDim2.new(0, 0, 0, 0)
sb.AutomaticCanvasSize = Enum.AutomaticSize.Y
sb.Parent = sbFrame

local sbL = Instance.new("UIListLayout")
sbL.Padding = UDim.new(0, 4)
sbL.Parent = sb

local sbP = Instance.new("UIPadding")
sbP.PaddingTop = UDim.new(0, 6)
sbP.PaddingLeft = UDim.new(0, 4)
sbP.PaddingRight = UDim.new(0, 4)
sbP.PaddingBottom = UDim.new(0, 6)
sbP.Parent = sb

-- CONTENT
local ct = Instance.new("Frame")
ct.Size = UDim2.new(1, -148, 1, -66)
ct.Position = UDim2.new(0, 138, 0, 58)
ct.BackgroundColor3 = C.PANEL
ct.BackgroundTransparency = 0.2
ct.BorderSizePixel = 0
ct.Parent = panel
rnd(ct, 12)
strk(ct, C.GOLD, 1, 0.6)

local cs = Instance.new("ScrollingFrame")
cs.Size = UDim2.new(1, -16, 1, -16)
cs.Position = UDim2.new(0, 8, 0, 8)
cs.BackgroundTransparency = 1
cs.BorderSizePixel = 0
cs.ScrollBarThickness = 3
cs.ScrollBarImageColor3 = C.GOLD
cs.CanvasSize = UDim2.new(0, 0, 0, 0)
cs.AutomaticCanvasSize = Enum.AutomaticSize.Y
cs.Parent = ct

local csL = Instance.new("UIListLayout")
csL.Padding = UDim.new(0, 5)
csL.Parent = cs

-- ============================
-- KOMPONEN UI
-- ============================
local function sec(title, icon)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 24)
    f.BackgroundTransparency = 1
    f.Parent = cs
    local deco = Instance.new("Frame")
    deco.Size = UDim2.new(0, 4, 0, 16)
    deco.Position = UDim2.new(0, 4, 0.5, -8)
    deco.BackgroundColor3 = C.GOLD
    deco.BorderSizePixel = 0
    deco.Parent = f
    rnd(deco, 2)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 1, 0)
    l.Position = UDim2.new(0, 16, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = icon .. "  " .. string.upper(title)
    l.TextColor3 = C.GOLD
    l.TextSize = 10
    l.Font = Enum.Font.GothamBlack
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
end

local function lbl(text, color)
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

local function tog(name, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 30)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    local fStrk = strk(f, C.GOLD, 1, 0.7)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -55, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local t = Instance.new("Frame")
    t.Size = UDim2.new(0, 34, 0, 18)
    t.Position = UDim2.new(1, -44, 0.5, -9)
    t.BorderSizePixel = 0
    t.Parent = f
    rnd(t, 9)

    local k = Instance.new("Frame")
    k.Size = UDim2.new(0, 12, 0, 12)
    k.BorderSizePixel = 0
    k.Parent = t
    rnd(k, 6)

    local saved = _G.ToggleStates[name]
    local state = (saved ~= nil) and saved or def
    _G.ToggleStates[name] = state

    t.BackgroundColor3 = state and C.GOLD or C.PANEL
    k.Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
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
            Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
            BackgroundColor3 = state and C.ACC2 or C.DIM
        }):Play()
        TweenService:Create(t, TweenInfo.new(0.2), {BackgroundColor3 = state and C.GOLD or C.PANEL}):Play()
        fStrk.Color = state and C.GRN or C.GOLD
        if cb then pcall(cb, state) end
    end)
end

local function sl(name, min, max, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 40)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.GOLD, 1, 0.7)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -60, 0, 16)
    l.Position = UDim2.new(0, 10, 0, 4)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local curVal = _G.SliderStates[name] or def
    _G.SliderStates[name] = curVal

    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0, 40, 0, 16)
    v.Position = UDim2.new(1, -50, 0, 4)
    v.BackgroundTransparency = 1
    v.Text = tostring(curVal)
    v.TextColor3 = C.ACC2
    v.TextSize = 10
    v.Font = Enum.Font.GothamBold
    v.TextXAlignment = Enum.TextXAlignment.Right
    v.Parent = f

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -24, 0, 5)
    bg.Position = UDim2.new(0, 12, 1, -13)
    bg.BackgroundColor3 = C.PANEL
    bg.BorderSizePixel = 0
    bg.Parent = f
    rnd(bg, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((curVal - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = C.GOLD
    fill.BorderSizePixel = 0
    fill.Parent = bg
    rnd(fill, 3)

    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 12, 0, 12)
    kn.Position = UDim2.new((curVal - min) / (max - min), -6, 0.5, -6)
    kn.BackgroundColor3 = C.TXT
    kn.BorderSizePixel = 0
    kn.ZIndex = 2
    kn.Parent = bg
    rnd(kn, 6)
    strk(kn, C.ACC2, 2)

    local drag = false
    local function upd(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local val = math.floor((min + (max - min) * pos) * 100 + 0.5) / 100
        _G.SliderStates[name] = val
        fill.Size = UDim2.new(pos, 0, 1, 0)
        kn.Position = UDim2.new(pos, -6, 0.5, -6)
        v.Text = tostring(val)
        if cb then pcall(cb, val) end
    end
    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true; upd(input)
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

local function cpk(name, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 30)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.GOLD, 1, 0.7)

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
        cB.BackgroundColor3 = presets[idx]
        if cb then pcall(cb, presets[idx]) end
    end)
end

local function btn(name, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -4, 0, 30)
    b.BackgroundColor3 = C.BG
    b.BackgroundTransparency = 0.4
    b.Text = name
    b.TextColor3 = C.TXT
    b.TextSize = 10
    b.Font = Enum.Font.GothamMedium
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = cs
    rnd(b, 8)
    strk(b, C.GOLD, 1, 0.7)
    b.MouseButton1Click:Connect(function()
        if cb then pcall(cb) end
    end)
end

local function drp(name, options, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 30)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.GOLD, 1, 0.7)

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

    local idx = 1
    for i, o in ipairs(options) do if o == def then idx = i end end
    local cur = options[idx]

    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0.5, -26, 1, 0)
    v.Position = UDim2.new(0.5, 0, 0, 0)
    v.BackgroundTransparency = 1
    v.Text = tostring(cur) .. " ▶"
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
    cB.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then idx = 1 end
        cur = options[idx]
        v.Text = tostring(cur) .. " ▶"
        if cb then pcall(cb, cur) end
    end)
end

local activeTab = nil
local function makeTab(name, icon, order, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 30)
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
    ind.BackgroundColor3 = C.GOLD
    ind.BorderSizePixel = 0
    ind.Parent = b
    rnd(ind, 2)

    local ico = Instance.new("TextLabel")
    ico.Size = UDim2.new(0, 22, 1, 0)
    ico.Position = UDim2.new(0, 7, 0, 0)
    ico.BackgroundTransparency = 1
    ico.Text = icon
    ico.TextColor3 = C.DIM
    ico.TextSize = 14
    ico.Font = Enum.Font.GothamBold
    ico.Parent = b

    local lblT = Instance.new("TextLabel")
    lblT.Size = UDim2.new(1, -28, 1, 0)
    lblT.Position = UDim2.new(0, 30, 0, 0)
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
        TweenService:Create(ind, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 3, 0, 20)}):Play()
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

-- DRAG
local dragging, ds, dp, wasDragged = false, nil, nil, false
mainBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; wasDragged = false
        ds = input.Position; dp = mainBtn.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - ds
        if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then wasDragged = true end
        mainBtn.Position = UDim2.new(dp.X.Scale, dp.X.Offset + d.X, dp.Y.Scale, dp.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

mainBtn.MouseButton1Click:Connect(function()
    if wasDragged then wasDragged = false; return end
    panel.Visible = not panel.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
end)

-- Expose global untuk tab
_G.Roooor_sec = sec
_G.Roooor_lbl = lbl
_G.Roooor_tog = tog
_G.Roooor_sl = sl
_G.Roooor_cpk = cpk
_G.Roooor_btn = btn
_G.Roooor_drp = drp
_G.Roooor_makeTab = makeTab
_G.Roooor_cs = cs
_G.Roooor_sb = sb

print("✅ [4/7] GUI + Komponen loaded")-- =========================================================
-- BAGIAN 5/7 : TAB UI PART 1
-- =========================================================

-- ============================
-- TAB: FIRE
-- ============================
makeTab("Fire", "🔥", 1, function()
    sec("Fire Control", "⚙️")
    tog("Enable Fire", false, function(s) S.FireOn = s; applyFire() end)
    sl("Fire Size", 1, 15, 5, function(v) S.FireSize = v; applyFire() end)

    sec("Pilih Efek Fire (60)", "🔥")
    lbl("Klik efek untuk ganti", C.ACC2)
    for i, fireName in ipairs(FireList) do
        local btn2 = Instance.new("TextButton")
        btn2.Size = UDim2.new(1, -4, 0, 26)
        btn2.BackgroundColor3 = C.BG
        btn2.BackgroundTransparency = 0.4
        btn2.BorderSizePixel = 0
        btn2.Text = ""
        btn2.AutoButtonColor = false
        btn2.LayoutOrder = i + 100
        btn2.Parent = cs
        rnd(btn2, 7)
        local btnStroke = strk(btn2, C.GOLD, 1, 0.6)
        local btnLbl = Instance.new("TextLabel")
        btnLbl.Size = UDim2.new(1, -10, 1, 0)
        btnLbl.Position = UDim2.new(0, 10, 0, 0)
        btnLbl.BackgroundTransparency = 1
        btnLbl.Text = "🔥 " .. fireName
        btnLbl.TextColor3 = C.TXT
        btnLbl.TextSize = 10
        btnLbl.Font = Enum.Font.GothamMedium
        btnLbl.TextXAlignment = Enum.TextXAlignment.Left
        btnLbl.Parent = btn2
        if S.FireType == fireName then
            btn2.BackgroundColor3 = C.GOLD
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(0.1, 0.1, 0.1)
        end
        btn2.MouseButton1Click:Connect(function()
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
            btn2.BackgroundColor3 = C.GOLD
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(0.1, 0.1, 0.1)
        end)
    end
end)

-- ============================
-- TAB: FIRE FEET
-- ============================
makeTab("Fire Feet", "👟", 2, function()
    sec("Fire Feet Control", "👟")
    tog("Enable Fire Feet", false, function(s) S.FireFeetOn = s; applyFireFeet() end)

    sec("Pilih Efek Fire Feet (20)", "🔥")
    lbl("Klik efek untuk ganti", C.ACC2)
    for i, fireName in ipairs(FireFeetList) do
        local btn2 = Instance.new("TextButton")
        btn2.Size = UDim2.new(1, -4, 0, 26)
        btn2.BackgroundColor3 = C.BG
        btn2.BackgroundTransparency = 0.4
        btn2.BorderSizePixel = 0
        btn2.Text = ""
        btn2.AutoButtonColor = false
        btn2.LayoutOrder = i + 200
        btn2.Parent = cs
        rnd(btn2, 7)
        local btnLbl = Instance.new("TextLabel")
        btnLbl.Size = UDim2.new(1, -10, 1, 0)
        btnLbl.Position = UDim2.new(0, 10, 0, 0)
        btnLbl.BackgroundTransparency = 1
        btnLbl.Text = "👟 " .. fireName
        btnLbl.TextColor3 = C.TXT
        btnLbl.TextSize = 10
        btnLbl.Font = Enum.Font.GothamMedium
        btnLbl.TextXAlignment = Enum.TextXAlignment.Left
        btnLbl.Parent = btn2
        if S.FireFeetType == fireName then
            btn2.BackgroundColor3 = C.GOLD
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(0.1, 0.1, 0.1)
        end
        btn2.MouseButton1Click:Connect(function()
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
            btn2.BackgroundColor3 = C.GOLD
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(0.1, 0.1, 0.1)
        end)
    end
end)

-- ============================
-- TAB: ESP
-- ============================
makeTab("ESP", "👁️", 3, function()
    sec("Player ESP + Nama", "🟢")
    tog("Enable ESP Name", false, function(s)
        S.ESP_Name = s
        if not s then
            for _, bb in pairs(StatusESP) do if bb then bb:Destroy() end end
        end
    end)
    sl("Nama Size", 8, 60, 12, function(v) S.ESP_Size = v end)
    sl("ESP Radius", 50, 5000, 500, function(v) S.ESP_Radius = v end)
    cpk("Default Color", S.ESP_DefaultColor, function(c) S.ESP_DefaultColor = c end)
    cpk("Killer Color", S.ESP_KillerColor, function(c) S.ESP_KillerColor = c end)
    cpk("Survivor Color", S.ESP_SurvivorColor, function(c) S.ESP_SurvivorColor = c end)

    sec("Generator ESP", "⚡")
    tog("ESP Generator", false, function(s) S.ESP_Generator = s end)

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

-- ============================
-- TAB: SURVIVOR
-- ============================
makeTab("Survivor", "🏃", 4, function()
    sec("Auto Parry 360° GACOR", "🛡️")
    tog("Enable Auto Parry", false, function(s) S.Parry = s; if s then scanKillers() end end)
    sl("Parry Distance", 3, 25, 8, function(v) S.ParryDist = v end)
    lbl("Anti-miss + Prediksi gerak killer", C.GRN)

    sec("Parry Circle", "🔵")
    tog("Enable Parry Circle", false, function(s) S.ParryCircle = s end)
    sl("Circle Size", 5, 50, 15, function(v) S.ParryCircleSize = v end)

    sec("Auto Skill Check", "🎯")
    tog("Enable Skill Check", false, function(s) S.Skill = s end)

    sec("Aimlock (2 Mode)", "🎯")
    tog("Enable Aimlock", false, function(s) S.Aimlock = s end)
    drp("Aimlock Mode", {"Killer", "Survivor"}, "Killer", function(v) S.AimlockMode = v end)
    sl("Aimlock Radius", 50, 5000, 500, function(v) S.AimlockRadius = v end)
end)

-- ============================
-- TAB: KILLER
-- ============================
makeTab("Killer", "🔪", 5, function()
    sec("Auto Attack", "⚔️")
    tog("Auto Spam Attack", false, function(s) S.Killer_AutoAtk = s end)
    sl("Attack Delay", 0.1, 2, 0.35, function(v) S.Killer_AtkDelay = v end)

    sec("Auto Kill All", "💀")
    tog("Auto Kill All", false, function(s) S.Killer_KillAll = s end)
    lbl("⚠️ Beresiko ban di public", C.RED)

    sec("Hitbox Expander", "📦")
    tog("Enable Hitbox", false, function(s) S.Killer_Hitbox = s end)
    sl("Hitbox Size", 3, 50, 15, function(v) S.Killer_HitboxSize = v end)
    tog("Hide Hitbox Visual", false, function(s) S.Killer_Hitbox_Visible = not s end)

    sec("Masked Power", "🎭")
    drp("Select Power", {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}, "Cobra", function(v) S.MaskedPower = v end)
    btn("⚡ Activate Power", function()
        pcall(function()
            local r = ReplicatedStorage:FindFirstChild("Remotes")
            if r then
                local k = r:FindFirstChild("Killers")
                if k then
                    local m = k:FindFirstChild("Masked")
                    if m then
                        local ev = m:FindFirstChild("Activatepower")
                        if ev then ev:FireServer(S.MaskedPower or "Cobra") end
                    end
                end
            end
        end)
    end)
    btn("❌ Deactivate Power", function()
        pcall(function()
            local r = ReplicatedStorage:FindFirstChild("Remotes")
            if r then
                local k = r:FindFirstChild("Killers")
                if k then
                    local m = k:FindFirstChild("Masked")
                    if m then
                        local ev = m:FindFirstChild("Deactivatepower")
                        if ev then ev:FireServer() end
                    end
                end
            end
        end)
    end)
end)

print("✅ [5/7] Tab Part 1 loaded")-- =========================================================
-- BAGIAN 6/7 : TAB UI PART 2
-- =========================================================

-- ============================
-- TAB: VISUAL
-- ============================
makeTab("Visual", "🎨", 6, function()
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

    sec("Sky Changer (7 Sky)", "🌤️")
    lbl("Klik untuk ganti sky", C.ACC2)
    for i, skyName in ipairs(SkyList) do
        local btn2 = Instance.new("TextButton")
        btn2.Size = UDim2.new(1, -4, 0, 24)
        btn2.BackgroundColor3 = C.BG
        btn2.BackgroundTransparency = 0.4
        btn2.BorderSizePixel = 0
        btn2.Text = ""
        btn2.AutoButtonColor = false
        btn2.LayoutOrder = i + 300
        btn2.Parent = cs
        rnd(btn2, 6)
        local btnLbl = Instance.new("TextLabel")
        btnLbl.Size = UDim2.new(1, -10, 1, 0)
        btnLbl.Position = UDim2.new(0, 10, 0, 0)
        btnLbl.BackgroundTransparency = 1
        btnLbl.Text = "🌤️ " .. skyName
        btnLbl.TextColor3 = C.TXT
        btnLbl.TextSize = 10
        btnLbl.Font = Enum.Font.GothamMedium
        btnLbl.TextXAlignment = Enum.TextXAlignment.Left
        btnLbl.Parent = btn2
        if S.SkyId == skyName then
            btn2.BackgroundColor3 = C.GOLD
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(0.1, 0.1, 0.1)
        end
        btn2.MouseButton1Click:Connect(function()
            S.SkyId = skyName
            applySky(skyName)
            for _, c in pairs(cs:GetChildren()) do
                if c:IsA("TextButton") and c.LayoutOrder > 300 and c.LayoutOrder < 400 then
                    c.BackgroundColor3 = C.BG
                    c.BackgroundTransparency = 0.4
                    local l = c:FindFirstChildOfClass("TextLabel")
                    if l then l.TextColor3 = C.TXT end
                end
            end
            btn2.BackgroundColor3 = C.GOLD
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(0.1, 0.1, 0.1)
        end)
    end

    sec("Appearance", "💫")
    tog("Korblox Legs (1 Kaki)", false, function(s) S.Korblox = s; applyKorblox(s) end)
    tog("Headless", false, function(s) S.Headless = s; applyHeadless(s) end)
end)

-- ============================
-- TAB: 8-BIT (KHUSUS)
-- ============================
makeTab("8-Bit", "👑", 7, function()
    sec("8-Bit Royal Crown", "👑")
    tog("👑 Enable 8-Bit Crown", false, function(s)
        S.EightBitCrown = s
        apply8BitCrown(s, S.EightBitSize)
    end)
    lbl("Mahkota pixel + efek api warna-warni", C.ACC2)

    sec("8-Bit HP Bar", "❤️")
    tog("❤️ Enable 8-Bit HP Bar", false, function(s)
        S.EightBitHP = s
        apply8BitHP(s, S.EightBitSize)
    end)
    lbl("Bar HP pixel + partikel hati", C.ACC2)

    sec("8-Bit Tabby Cat", "🐱")
    tog("🐱 Enable 8-Bit Tabby Cat", false, function(s)
        S.EightBitCat = s
        apply8BitCat(s, S.EightBitSize)
    end)
    lbl("Kucing pixel di bahu", C.ACC2)

    sec("Ukuran 8-Bit", "📏")
    sl("8-Bit Size", 0.3, 3, 1, function(v)
        S.EightBitSize = v
        if S.EightBitCrown then apply8BitCrown(true, v) end
        if S.EightBitHP then apply8BitHP(true, v) end
        if S.EightBitCat then apply8BitCat(true, v) end
    end)
    lbl("Bisa diperbesar & diperkecil", C.GRN)

    sec("QUICK ACTION", "⚡")
    btn("🎁 PASANG SEMUA (3 in 1)", function()
        S.EightBitCrown = true
        S.EightBitHP = true
        S.EightBitCat = true
        apply8BitSet(true)
        _G.ToggleStates["👑 Enable 8-Bit Crown"] = true
        _G.ToggleStates["❤️ Enable 8-Bit HP Bar"] = true
        _G.ToggleStates["🐱 Enable 8-Bit Tabby Cat"] = true
        print("[8Bit] Semua dipasang!")
    end)
    btn("❌ LEPAS SEMUA", function()
        S.EightBitCrown = false
        S.EightBitHP = false
        S.EightBitCat = false
        apply8BitSet(false)
        _G.ToggleStates["👑 Enable 8-Bit Crown"] = false
        _G.ToggleStates["❤️ Enable 8-Bit HP Bar"] = false
        _G.ToggleStates["🐱 Enable 8-Bit Tabby Cat"] = false
        print("[8Bit] Semua dilepas!")
    end)
    btn("🔄 Refresh / Re-apply", function()
        apply8BitSet(false)
        task.wait(0.2)
        apply8BitSet(S.EightBitCrown or S.EightBitHP or S.EightBitCat)
    end)
end)

-- ============================
-- TAB: VISUAL+ (15 FITUR EXTRA)
-- ============================
makeTab("Visual+", "✨", 8, function()
    sec("Efek Jejak", "👣")
    tog("Enable Trail", false, function(s)
        S.Trail = s
        applyTrail(s, S.TrailColor)
    end)
    cpk("Trail Color", S.TrailColor, function(c)
        S.TrailColor = c
        if S.Trail then applyTrail(true, c) end
    end)

    sec("Efek Aura", "🌟")
    tog("Enable Aura", false, function(s)
        S.Aura = s
        applyAura(s, S.AuraColor)
    end)
    cpk("Aura Color", S.AuraColor, function(c)
        S.AuraColor = c
        if S.Aura then applyAura(true, c) end
    end)

    sec("Efek Kill", "💥")
    tog("Enable Kill Effect", false, function(s) S.KillEffect = s end)
    lbl("Muncul efek ledakan saat killer kill", C.ACC2)

    sec("Crosshair", "➕")
    tog("Enable Crosshair", false, function(s)
        S.Crosshair = s
        applyCrosshair(s, S.CrosshairColor, S.CrosshairSize)
    end)
    cpk("Crosshair Color", S.CrosshairColor, function(c)
        S.CrosshairColor = c
        if S.Crosshair then applyCrosshair(true, c, S.CrosshairSize) end
    end)
    sl("Crosshair Size", 3, 30, 8, function(v)
        S.CrosshairSize = v
        if S.Crosshair then applyCrosshair(true, S.CrosshairColor, v) end
    end)

    sec("Camera", "📷")
    tog("No Clip Camera", false, function(s) S.NoClipCamera = s end)
    tog("Zoom Out (Unlimited)", false, function(s)
        S.ZoomOut = s
        applyZoomOut(s, S.ZoomOutValue)
    end)
    sl("Zoom Distance", 100, 5000, 500, function(v)
        S.ZoomOutValue = v
        if S.ZoomOut then applyZoomOut(true, v) end
    end)

    sec("RGB UI", "🌈")
    tog("Enable RGB UI", false, function(s) S.RGBUI = s end)
end)

-- ============================
-- TAB: MOVEMENT
-- ============================
makeTab("Movement", "🏃", 9, function()
    sec("Walk Speed", "⚡")
    tog("Enable Walk Speed", false, function(s) S.WalkSpeed = s end)
    sl("Speed Value", 16, 200, 16, function(v) S.WalkSpeedVal = v end)
    sl("Speed Boost", 0, 200, 0, function(v) S.WalkSpeedBoost = v end)

    sec("Instant Escape", "🚪")
    btn("🚀 Instant Escape (TP Finish)", function() teleportToFinishLine() end)
    lbl("Teleport ke finish line/gate", C.ACC2)

    sec("Fast Vault", "🏃")
    tog("Enable Fast Vault", false, function(s) S.FastVault = s end)
    sl("Animation Speed", 1, 5, 1.5, function(v) S.FastVaultSpeed = v end)
end)

-- ============================
-- TAB: ANTI
-- ============================
makeTab("Anti", "🛡️", 10, function()
    sec("Anti Stun", "⚡")
    tog("Enable Anti Stun", false, function(s) X.AntiStun = s end)

    sec("Anti Blind", "👁️")
    tog("Enable Anti Blind", false, function(s) X.AntiBlind = s end)

    sec("Anti Grab", "✋")
    tog("Enable Anti Grab", false, function(s) X.AntiGrab = s end)

    sec("Anti Hook", "🪝")
    tog("Enable Anti Hook", false, function(s) X.AntiHook = s end)

    sec("Anti Ragdoll", "🤸")
    tog("Enable Anti Ragdoll", false, function(s) X.AntiRagdoll = s end)

    sec("Anti AFK", "💤")
    tog("Enable Anti AFK", false, function(s) X.AntiAFK = s end)
end)

-- ============================
-- TAB: TOP 10
-- ============================
makeTab("Top 10", "🏆", 11, function()
    sec("Fly", "🕊️")
    tog("Enable Fly", false, function(s)
        X.Fly = s
        if s then
            if _G.Roooor_startFly then _G.Roooor_startFly() end
        else
            if _G.Roooor_stopFly then _G.Roooor_stopFly() end
        end
    end)
    sl("Fly Speed", 10, 200, 50, function(v) X.FlySpeed = v end)
    lbl("WASD + Space (naik) + LShift (turun)", C.ACC2)

    sec("Item ESP", "📦")
    tog("Enable Item ESP", false, function(s) X.ItemESP = s end)
    cpk("Item Color", X.ItemESPColor, function(c) X.ItemESPColor = c end)
end)

-- ============================
-- TAB: SETTINGS
-- ============================
makeTab("Settings", "⚙️", 12, function()
    sec("Keybind", "⌨️")
    lbl("Klik tombol ⚡ = Buka Menu", C.ACC2)
    lbl("Drag Header = Pindah Window", C.DIM)
    lbl("Drag ⚡ = Pindah Tombol", C.DIM)

    sec("Info", "ℹ️")
    lbl("RoooorHub Premium Ultimate + 8Bit", C.GOLD)
    lbl("60 Fire + 20 Fire Feet + 7 Sky", C.ACC2)
    lbl("ESP + Parry GACOR v3 + 8Bit Set", C.ACC2)
    lbl("15 Fitur Visual Extra", C.ACC2)
    lbl("Made with 💜", C.ACC3)
end)

print("✅ [6/7] Tab Part 2 loaded")-- =========================================================
-- BAGIAN 7/7 : MAIN LOOP + SKILL + AIMLOCK + FLY + FINAL
-- =========================================================

-- ============================
-- AUTO SKILL CHECK
-- ============================
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

-- ============================
-- AIMLOCK LOOP
-- ============================
task.spawn(function()
    while gui.Parent do
        task.wait(0.03)
        if S.Aimlock then
            local myRoot = getRoot()
            if myRoot then
                local closest, shortest = nil, S.AimlockRadius
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local valid = false
                        if S.AimlockMode == "Killer" and p.Team and p.Team.Name == "Killer" then
                            valid = true
                        elseif S.AimlockMode == "Survivor" and p.Team and p.Team.Name == "Survivors" then
                            valid = true
                        end
                        if valid then
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

-- ============================
-- PARRY CIRCLE
-- ============================
_G.Roooor_ParryCircle = nil
local function updateParryCircle()
    local root = getRoot()
    if not S.ParryCircle or not root then
        if _G.Roooor_ParryCircle then
            _G.Roooor_ParryCircle:Destroy()
            _G.Roooor_ParryCircle = nil
        end
        return
    end
    if not _G.Roooor_ParryCircle then
        _G.Roooor_ParryCircle = Instance.new("Part")
        _G.Roooor_ParryCircle.Shape = Enum.PartType.Cylinder
        _G.Roooor_ParryCircle.Anchored = true
        _G.Roooor_ParryCircle.CanCollide = false
        _G.Roooor_ParryCircle.Material = Enum.Material.Neon
        _G.Roooor_ParryCircle.Name = "RoooorParryCircle"
        _G.Roooor_ParryCircle.Parent = workspace
    end
    local size = (S.ParryCircleSize or 15) * 2
    _G.Roooor_ParryCircle.Size = Vector3.new(0.1, size, size)
    local yOffset = root.Size.Y / 2 + 1.5
    _G.Roooor_ParryCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0)) * CFrame.Angles(0, 0, math.rad(90))
    _G.Roooor_ParryCircle.Color = C.GOLD
    _G.Roooor_ParryCircle.Transparency = 0.5
end

RunService.RenderStepped:Connect(function()
    if S.ParryCircle then updateParryCircle() end
end)

-- ============================
-- SCAN KILLER (PARROY)
-- ============================
task.spawn(function()
    while gui.Parent do
        task.wait(0.2)
        if S.Parry then scanKillers() end
    end
end)

-- ============================
-- MAIN ESP LOOP
-- ============================
task.spawn(function()
    while gui.Parent do
        local root = getRoot()
        if root then
            if S.ESP_Name then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            createStatusESP(p, p.Character, root)
                        else
                            if StatusESP[p.Character] then
                                StatusESP[p.Character]:Destroy()
                                StatusESP[p.Character] = nil
                            end
                        end
                    end
                end
            end
            if S.ESP_Pallet then
                for obj in pairs(Cached.Pallets) do
                    if obj and obj.Parent then
                        local pos = obj:IsA("Model") and obj:GetPivot().Position or (obj:IsA("BasePart") and obj.Position)
                        if pos and (pos - root.Position).Magnitude <= S.ESP_Radius then
                            createESP(obj, S.ESP_PalletColor)
                        else
                            removeESP(obj)
                        end
                    end
                end
            end
            if S.ESP_Window then
                for obj in pairs(Cached.Windows) do
                    if obj and obj.Parent then
                        local pos = obj:IsA("Model") and obj:GetPivot().Position or (obj:IsA("BasePart") and obj.Position)
                        if pos and (pos - root.Position).Magnitude <= S.ESP_Radius then
                            createESP(obj, S.ESP_WindowColor)
                        else
                            removeESP(obj)
                        end
                    end
                end
            end
            if S.ESP_SCP then
                for obj in pairs(Cached.SCPs) do
                    if obj and obj.Parent then
                        local pos = obj:IsA("Model") and obj:GetPivot().Position or (obj:IsA("BasePart") and obj.Position)
                        if pos and (pos - root.Position).Magnitude <= S.ESP_Radius then
                            createESP(obj, S.ESP_SCPColor)
                        else
                            removeESP(obj)
                        end
                    end
                end
            end
            if S.ESP_Generator then
                for gen in pairs(Cached.Generators) do
                    if gen and gen.Parent then
                        local pos = gen:IsA("Model") and gen:GetPivot().Position or (gen:IsA("BasePart") and gen.Position)
                        if pos and (pos - root.Position).Magnitude <= S.ESP_Radius then
                            createESP(gen, S.ESP_GenColor)
                        else
                            removeESP(gen)
                        end
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)

-- ============================
-- KILL EFFECT LOOP
-- ============================
task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if S.KillEffect then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health <= 0 then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and not p.Character:GetAttribute("RoooorKillEffect") then
                            p.Character:SetAttribute("RoooorKillEffect", true)
                            spawnKillEffect(hrp.Position)
                        end
                    else
                        p.Character:SetAttribute("RoooorKillEffect", false)
                    end
                end
            end
        end
    end
end)

-- ============================
-- NO CLIP CAMERA LOOP
-- ============================
task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        local cam = workspace.CurrentCamera
        if cam then
            cam.CanCollide = not S.NoClipCamera
        end
    end
end)

-- ============================
-- RGB UI LOOP
-- ============================
task.spawn(function()
    while gui.Parent do
        task.wait(0.05)
        if S.RGBUI then
            local hue = (tick() * 0.3) % 1
            hTitle.TextColor3 = Color3.fromHSV(hue, 1, 1)
            neonGrad.Color = ColorSequence.new(
                Color3.fromHSV(hue, 1, 1),
                Color3.fromHSV((hue + 0.25) % 1, 1, 1),
                Color3.fromHSV((hue + 0.5) % 1, 1, 1),
                Color3.fromHSV((hue + 0.75) % 1, 1, 1)
            )
        end
    end
end)

-- ============================
-- FLY
-- ============================
local flyBV, flyBG, flyConn = nil, nil, nil
local function startFly()
    if flyConn then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function() hrp:SetNetworkOwner(LP) end)
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBV.Parent = hrp
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBG.P = 15000
    flyBG.D = 500
    flyBG.Parent = hrp
    flyConn = RunService.RenderStepped:Connect(function()
        if not X.Fly then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not hrp or not cam then return end
        local moveDir = Vector3.new(0, 0, 0)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local md = hum.MoveDirection
            if md.Magnitude > 0 then
                moveDir = cam.CFrame.LookVector * md.Z + cam.CFrame.RightVector * md.X
                moveDir = Vector3.new(moveDir.X, 0, moveDir.Z).Unit
            end
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir + Vector3.new(0, -1, 0) end
        flyBV.Velocity = moveDir * X.FlySpeed
        flyBG.CFrame = cam.CFrame
    end)
end

local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
end

_G.Roooor_startFly = startFly
_G.Roooor_stopFly = stopFly

-- ============================
-- ITEM ESP LOOP
-- ============================
task.spawn(function()
    while gui.Parent do
        task.wait(0.3)
        if X.ItemESP then
            local root = getRoot()
            if root then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    local lname = string.lower(obj.Name)
                    if obj:IsA("BasePart") and (
                        string.find(lname, "medkit") or string.find(lname, "key") or
                        string.find(lname, "flashlight") or string.find(lname, "battery") or
                        string.find(lname, "bandage")
                    ) then
                        if (obj.Position - root.Position).Magnitude <= S.ESP_Radius then
                            if not obj:FindFirstChild("RoooorItemHL") then
                                local h = Instance.new("Highlight")
                                h.Name = "RoooorItemHL"
                                h.FillColor = X.ItemESPColor
                                h.OutlineColor = X.ItemESPColor
                                h.FillTransparency = 0.7
                                h.OutlineTransparency = 0.3
                                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                h.Parent = obj
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ============================
-- RESPAWN HANDLER
-- ============================
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    hookedKillers = {}
    _G.HookedKillers = hookedKillers

    if S.FireOn then applyFire() end
    if S.FireFeetOn then applyFireFeet() end
    if S.Parry then scanKillers() end
    if S.Korblox then task.wait(0.3); applyKorblox(true) end
    if S.Headless then task.wait(0.3); applyHeadless(true) end
    if S.EightBitCrown then task.wait(0.3); apply8BitCrown(true, S.EightBitSize) end
    if S.EightBitHP then task.wait(0.3); apply8BitHP(true, S.EightBitSize) end
    if S.EightBitCat then task.wait(0.3); apply8BitCat(true, S.EightBitSize) end
    if S.Trail then task.wait(0.3); applyTrail(true, S.TrailColor) end
    if S.Aura then task.wait(0.3); applyAura(true, S.AuraColor) end
    if S.Crosshair then task.wait(0.3); applyCrosshair(true, S.CrosshairColor, S.CrosshairSize) end
    if S.ZoomOut then task.wait(0.3); applyZoomOut(true, S.ZoomOutValue) end
end)

-- ============================
-- ANTI-RESET
-- ============================
task.spawn(function()
    while gui.Parent do
        task.wait(0.3)
        for name, state in pairs(_G.ToggleStates) do
            if name == "👑 Enable 8-Bit Crown" then
                if S.EightBitCrown ~= state then
                    S.EightBitCrown = state
                    apply8BitCrown(state, S.EightBitSize)
                end
            end
            if name == "❤️ Enable 8-Bit HP Bar" then
                if S.EightBitHP ~= state then
                    S.EightBitHP = state
                    apply8BitHP(state, S.EightBitSize)
                end
            end
            if name == "🐱 Enable 8-Bit Tabby Cat" then
                if S.EightBitCat ~= state then
                    S.EightBitCat = state
                    apply8BitCat(state, S.EightBitSize)
                end
            end
            if name == "Enable Trail" then
                if S.Trail ~= state then
                    S.Trail = state
                    applyTrail(state, S.TrailColor)
                end
            end
            if name == "Enable Aura" then
                if S.Aura ~= state then
                    S.Aura = state
                    applyAura(state, S.AuraColor)
                end
            end
            if name == "Enable Crosshair" then
                if S.Crosshair ~= state then
                    S.Crosshair = state
                    applyCrosshair(state, S.CrosshairColor, S.CrosshairSize)
                end
            end
        end
    end
end)

-- ============================
-- FPS PANEL
-- ============================
local fpsPanel = Instance.new("Frame")
fpsPanel.Size = UDim2.new(0, 150, 0, 24)
fpsPanel.Position = UDim2.new(0.5, -75, 0, 6)
fpsPanel.BackgroundColor3 = C.PANEL
fpsPanel.BackgroundTransparency = 0.3
fpsPanel.BorderSizePixel = 0
fpsPanel.Parent = gui
rnd(fpsPanel, 12)
strk(fpsPanel, C.GOLD, 1, 0.5)

local fpsLbl = Instance.new("TextLabel")
fpsLbl.Size = UDim2.new(1, -10, 1, 0)
fpsLbl.Position = UDim2.new(0, 5, 0, 0)
fpsLbl.BackgroundTransparency = 1
fpsLbl.Text = "FPS: -- | PING: --"
fpsLbl.TextColor3 = C.TXT
fpsLbl.TextSize = 10
fpsLbl.Font = Enum.Font.GothamBold
fpsLbl.Parent = fpsPanel

local fCnt, tAcc = 0, 0
RunService.RenderStepped:Connect(function(dt)
    fCnt = fCnt + 1
    tAcc = tAcc + dt
    if tAcc >= 1 then
        local fps = math.floor(fCnt / tAcc)
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        fpsLbl.Text = string.format("FPS: %d | PING: %d ms", fps, ping)
        fCnt = 0
        tAcc = 0
    end
end)

-- ============================
-- BUKA TAB PERTAMA
-- ============================
task.wait(0.3)
for _, c in pairs(sb:GetChildren()) do
    if c:IsA("TextButton") then
        c.MouseButton1Click:Fire()
        break
    end
end

-- ============================
-- FINAL PRINT
-- ============================
print("=====================================================")
print("✅ ROOORHUB PREMIUM ULTIMATE + 8BIT FINAL")
print("🎉 FULL SUCCESS - ALL FEATURES LOADED!")
print("=====================================================")
print("📋 DAFTAR TAB:")
print("  1. 🔥 Fire          — 60 Efek")
print("  2. 👟 Fire Feet     — 20 Efek")
print("  3. 👁️ ESP           — Player + Gen + Pallet + Window + SCP")
print("  4. 🏃 Survivor      — Parry GACOR + Skill + Aimlock")
print("  5. 🔪 Killer        — Attack + KillAll + Hitbox + Masked")
print("  6. 🎨 Visual        — Fullbright + NoFog + UltraHD + 7 Sky + Korblox")
print("  7. 👑 8-Bit         — Crown + HP + Cat (BISA RESIZE!)")
print("  8. ✨ Visual+       — Trail + Aura + KillEffect + Crosshair + RGB")
print("  9. 🏃 Movement      — WalkSpeed + Instant Escape + FastVault")
print(" 10. 🛡️ Anti          — Stun + Blind + Grab + Hook + Ragdoll + AFK")
print(" 11. 🏆 Top 10        — Fly + Item ESP")
print(" 12. ⚙️ Settings      — Info + Keybind")
print("=====================================================")
print("✨ Loading Animation 3D: AKTIF")
print("🎨 GUI baru lebih keren & diperkecil")
print("⚔️ Auto Parry GACOR v3: AKTIF")
print("👑 8-Bit resize: 0.3x - 3x")
print("🌤️ Sky yang WORK: Sunset, Night, Space, Alien, Purple, Galaxy, Void")
print("=====================================================")
