-- =========================================================
-- ROOORHUB PREMIUM ULTIMATE + FALLENS + MISC TAB
-- BAGIAN 1/16 : SERVICES + CONFIG + STATE + MISC STATE
-- Executor: Delta
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
    Moonwalk = false, MoonwalkSpam = 30, MoonwalkIntensity = 35, MoonwalkSlow = 13,
    MoonwalkLocked = false,
}

local S = _G.RoooorS

_G.ToggleStates = _G.ToggleStates or {}
_G.SliderStates = _G.SliderStates or {}

-- =========================================================
-- MISC STATE (semua fitur tambahan)
-- =========================================================
_G.RoooorMisc = _G.RoooorMisc or {
    -- Survivor
    AutoPallet = false, AutoPalletRange = 8,
    AutoVault = false, AutoVaultRange = 10,
    AutoHeal = false, AutoHealThreshold = 40,
    AutoRevive = false, AutoRepair = false, SkillPerfect = false,
    SafeZone = false, EscapeAlert = false, EscapeAlertRange = 60,
    -- Visual
    KillEffect = false,
    Trail = false, TrailColor = Color3.fromRGB(180, 80, 255),
    Aura = false, AuraColor = Color3.fromRGB(180, 80, 255),
    RGBUI = false,
    Crosshair = false, CrosshairColor = Color3.fromRGB(0, 255, 200), CrosshairSize = 8,
    NoClipCamera = false,
    ZoomOut = false, ZoomOutValue = 500,
    -- Anti
    AntiStun = false, AntiBlind = false, AntiGrab = false,
    AntiHook = false, AntiRagdoll = false, AntiParry = false,
    AntiKick = false, AntiAFK = false,
    -- Top 10
    Fly = false, FlySpeed = 50,
    TPtoPlayer = false,
    ItemESP = false, ItemESPColor = Color3.fromRGB(255, 255, 100),
    PlayerList = false,
}

local M = _G.RoooorMisc

print("✅ [1/16] Config + Misc State loaded (Delta)")-- =========================================================
-- BAGIAN 2/16 : FIRE LIST + FIRE CONFIG
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

print("✅ [2/16] Fire Config loaded")-- =========================================================
-- BAGIAN 3/16 : FIRE FEET + SKY + HELPERS + KILLER ANIMS
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
    Sunset = "rbxassetid://159454299", Night = "rbxassetid://159454299",
    Space = "rbxassetid://159454299", Alien = "rbxassetid://159454299",
    Purple = "rbxassetid://159454299", Pink = "rbxassetid://159454299",
    Cyan = "rbxassetid://159454299", Red = "rbxassetid://159454299",
    Blue = "rbxassetid://159454299", Green = "rbxassetid://159454299",
    Galaxy = "rbxassetid://159454299", Nebula = "rbxassetid://159454299",
    Aurora = "rbxassetid://159454299", Cosmic = "rbxassetid://159454299",
    Void = "rbxassetid://159454299", Heaven = "rbxassetid://159454299",
    Hell = "rbxassetid://159454299", Ocean = "rbxassetid://159454299",
    Desert = "rbxassetid://159454299", Forest = "rbxassetid://159454299",
    Snow = "rbxassetid://159454299", Storm = "rbxassetid://159454299",
    Rainbow = "rbxassetid://159454299", Golden = "rbxassetid://159454299",
}

-- KILLER ANIMATIONS (23 ID Fallens)
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

print("✅ [3/16] Fire Feet + Sky + Helpers + KillerAnims loaded")-- =========================================================
-- BAGIAN 4/16 : GUI WINDOW + HEADER + SIDEBAR SCROLLING
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
title.StrokeColor3 = Color3.new(0, 0, 0)
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

-- SIDEBAR (SCROLLING - biar muat banyak tab)
local sbFrame = Instance.new("Frame")
sbFrame.Size = UDim2.new(0, 120, 1, -72)
sbFrame.Position = UDim2.new(0, 12, 0, 62)
sbFrame.BackgroundColor3 = C.PANEL
sbFrame.BackgroundTransparency = 0.2
sbFrame.BorderSizePixel = 0
sbFrame.Parent = main
rnd(sbFrame, 14)
strk(sbFrame, C.ACC, 1, 0.6)
grad(sbFrame, C.PANEL, C.PANEL2, 90)

local sb = Instance.new("ScrollingFrame")
sb.Size = UDim2.new(1, -4, 1, -4)
sb.Position = UDim2.new(0, 2, 0, 2)
sb.BackgroundTransparency = 1
sb.BorderSizePixel = 0
sb.ScrollBarThickness = 4
sb.ScrollBarImageColor3 = C.ACC
sb.CanvasSize = UDim2.new(0, 0, 0, 0)
sb.AutomaticCanvasSize = Enum.AutomaticSize.Y
sb.ScrollingDirection = Enum.ScrollingDirection.Y
sb.Parent = sbFrame

local sbL = Instance.new("UIListLayout")
sbL.Padding = UDim.new(0, 5)
sbL.Parent = sb

local sbP = Instance.new("UIPadding")
sbP.PaddingTop = UDim.new(0, 8)
sbP.PaddingLeft = UDim.new(0, 4)
sbP.PaddingRight = UDim.new(0, 4)
sbP.PaddingBottom = UDim.new(0, 8)
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

print("✅ [4/16] GUI + Sidebar Scrolling loaded")-- =========================================================
-- BAGIAN 5/16 : COMPONENTS
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

function drp(name, options, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 32)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 10)
    strk(f, C.ACC, 1, 0.7)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.5, 0, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 11
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local idx = 1
    for i, o in ipairs(options) do if o == def then idx = i end end
    local cur = options[idx]

    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0.5, -30, 1, 0)
    v.Position = UDim2.new(0.5, 0, 0, 0)
    v.BackgroundTransparency = 1
    v.Text = tostring(cur) .. " ▶"
    v.TextColor3 = C.ACC2
    v.TextSize = 10
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

print("✅ [5/16] Components loaded")-- =========================================================
-- BAGIAN 6/16 : FIRE + FIRE FEET FUNCTIONS
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

print("✅ [6/16] Fire + Fire Feet loaded")-- =========================================================
-- BAGIAN 7/16 : ESP SYSTEM (FALLENS VERSION)
-- =========================================================

local ESPObjects = {}
local StatusESP = {}
local Cached = {
    Generators = {},
    Windows = {},
    Pallets = {},
    SCPs = {}
}

local function cacheObject(obj)
    local lname = string.lower(obj.Name)
    if obj.Name == "Generator" then
        Cached.Generators[obj] = true
    elseif obj.Name == "Window" then
        Cached.Windows[obj] = true
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        Cached.Pallets[obj] = true
    elseif string.find(lname, "scp") then
        Cached.SCPs[obj] = true
    end
end

for _, obj in ipairs(workspace:GetDescendants()) do cacheObject(obj) end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(function(obj)
    Cached.Generators[obj] = nil
    Cached.Windows[obj] = nil
    Cached.Pallets[obj] = nil
    Cached.SCPs[obj] = nil
    if ESPObjects[obj] then
        ESPObjects[obj]:Destroy()
        ESPObjects[obj] = nil
    end
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

    obj.AncestryChanged:Connect(function(_, parent)
        if not parent and ESPObjects[obj] then
            ESPObjects[obj]:Destroy()
            ESPObjects[obj] = nil
        end
    end)
end

local function removeESP(obj)
    if ESPObjects[obj] then
        ESPObjects[obj]:Destroy()
        ESPObjects[obj] = nil
    end
end

local function GetGameValue(obj, name)
    if not obj then return nil end
    local attr = obj:GetAttribute(name)
    if attr ~= nil then return attr end
    local child = obj:FindFirstChild(name)
    if child then
        local success, val = pcall(function() return child.Value end)
        if success then return val end
    end
    return nil
end

local function ApplyGenHighlight(object, color)
    local h = object:FindFirstChild("GenHighlight") or Instance.new("Highlight")
    h.Name = "GenHighlight"
    h.Adornee = object
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.7
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = object
end

local function CreateBillboard(text, color)
    local billboard = Instance.new("BillboardGui")
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
    label.TextSize = 12
    label.Parent = billboard

    return billboard
end

local function UpdateGenerator(generator)
    if not generator or not generator.Parent then return end
    if not S.ESP_Generator then
        local old = generator:FindFirstChild("GenESP")
        if old then old:Destroy() end
        local h = generator:FindFirstChild("GenHighlight")
        if h then h:Destroy() end
        return
    end
    local root = getRoot()
    if not root then return end

    local pos = generator:IsA("Model") and generator:GetPivot().Position or generator.Position
    if not pos then return end
    local dist = (pos - root.Position).Magnitude
    if dist > S.ESP_Radius then
        local old = generator:FindFirstChild("GenESP")
        if old then old:Destroy() end
        local h = generator:FindFirstChild("GenHighlight")
        if h then h:Destroy() end
        return
    end

    local percent = GetGameValue(generator, "RepairProgress") or GetGameValue(generator, "Progress") or 0
    local billboard = generator:FindFirstChild("GenESP")
    if percent >= 100 then
        if billboard then billboard:Destroy() end
        return
    end
    local cp = math.clamp(percent, 0, 100)
    local color = S.ESP_GenColor:Lerp(Color3.fromRGB(0, 255, 120), cp / 100)
    local text = string.format("[%.0f%%]", percent)

    if not billboard then
        billboard = CreateBillboard(text, color)
        billboard.Adornee = generator
        billboard.Parent = generator
    else
        local lbl2 = billboard:FindFirstChildOfClass("TextLabel")
        if lbl2 then
            lbl2.Text = text
            lbl2.TextColor3 = color
        end
    end
    ApplyGenHighlight(generator, color)
end

local function UpdateMapESP(obj, root)
    if not obj or not root then return end
    local pos
    if obj:IsA("Model") then
        pos = obj:GetPivot().Position
    elseif obj:IsA("BasePart") then
        pos = obj.Position
    end
    if not pos then return end
    local distance = (pos - root.Position).Magnitude

    if obj.Name == "Window" then
        if S.ESP_Window and distance <= S.ESP_Radius then
            createESP(obj, S.ESP_WindowColor)
        else
            removeESP(obj)
        end
    end
    if obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        if S.ESP_Pallet and distance <= S.ESP_Radius then
            createESP(obj, S.ESP_PalletColor)
        else
            removeESP(obj)
        end
    end
end

local function removeStatusESP(char)
    if StatusESP[char] then
        StatusESP[char]:Destroy()
        StatusESP[char] = nil
    end
end

local function createStatusESP(player, char, root)
    if not S.ESP_Name then
        removeStatusESP(char)
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
        removeStatusESP(char)
        return
    end

    local text = ""
    if isDown then text = text .. "🔻 DOWN\n" end
    text = text .. player.Name .. "\n"
    text = text .. string.format("Dist: %.0f\n", dist)
    text = text .. string.format("HP: %.0f", hum.Health)

    local billboard = StatusESP[char]
    local teamColor = S.ESP_DefaultColor
    if player.Team then
        if player.Team.Name == "Killer" then
            teamColor = S.ESP_KillerColor
        elseif player.Team.Name == "Survivors" then
            teamColor = S.ESP_SurvivorColor
        end
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

local function UpdateSCPEsp(root)
    if not S.ESP_SCP then
        for obj in pairs(Cached.SCPs) do
            removeESP(obj)
        end
        return
    end
    for obj in pairs(Cached.SCPs) do
        if obj and obj.Parent then
            local pos
            if obj:IsA("Model") then
                pos = obj:GetPivot().Position
            elseif obj:IsA("BasePart") then
                pos = obj.Position
            end
            if pos then
                local dist = (pos - root.Position).Magnitude
                if dist <= S.ESP_Radius then
                    createESP(obj, S.ESP_SCPColor)
                else
                    removeESP(obj)
                end
            end
        end
    end
end

-- Expose ke global
_G.Roooor_UpdateGenerator = UpdateGenerator
_G.Roooor_UpdateMapESP = UpdateMapESP
_G.Roooor_UpdateSCPEsp = UpdateSCPEsp
_G.Roooor_createStatusESP = createStatusESP
_G.Roooor_Cached = Cached
_G.Roooor_StatusESP = StatusESP
_G.Roooor_createESP = createESP
_G.Roooor_removeESP = removeESP

print("✅ [7/16] ESP (Fallens) loaded")-- =========================================================
-- BAGIAN 8/16 : AUTO PARRY (FALLENS) + AIMLOCK 2 MODE
-- =========================================================

local lastParry = 0
local PARRY_DEBOUNCE = 0.2
local ParryActive = false
local hookedKillers = _G.Roooor_HookedKillers or {}
_G.Roooor_HookedKillers = hookedKillers

local AttackPaths = {
    "Slasher-mob.Controls.attack",
    "Masked-mob.Controls.attack",
    "Killer-mob.Controls.attack"
}

local function GetParryButton()
    local current = PG
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function GetAttackButtonForParry()
    for _, path in ipairs(AttackPaths) do
        local current = PG
        for segment in string.gmatch(path, "[^%.]+") do
            current = current and current:FindFirstChild(segment)
        end
        if current and current:IsA("GuiObject") then
            return current
        end
    end
    return nil
end

local function pressRightClick()
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
        task.wait()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
    end)
end

local function pressParryButton()
    if UIS.TouchEnabled then
        local btn = GetParryButton()
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = GuiService:GetGuiInset()
            local x = pos.X + size.X / 2 + inset.X
            local y = pos.Y + size.Y / 2 + inset.Y
            pcall(function()
                VirtualInputManager:SendTouchEvent(8823, 0, x, y)
                task.wait(0.01)
                VirtualInputManager:SendTouchEvent(8823, 2, x, y)
            end)
        end
    else
        pressRightClick()
    end
end

local function doParry()
    local now = tick()
    if now - lastParry < PARRY_DEBOUNCE then return end
    lastParry = now
    ParryActive = true
    if S.Moonwalk then
        S.Moonwalk = false
        _G.ToggleStates["Enable Moonwalk"] = false
    end
    pressParryButton()
    task.delay(0.3, function()
        ParryActive = false
    end)
end

local function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end
    local dist = (enemyRoot.Position - myRoot.Position).Magnitude
    return dist <= (S.ParryDist + 5)
end

local function hookKiller(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    animator.AnimationPlayed:Connect(function(track)
        if not S.Parry then return end
        local anim = track.Animation
        if not anim then return end
        local id = tostring(anim.AnimationId):match("%d+")
        if not id then return end
        local fullId = "rbxassetid://" .. id
        if KillerAnims[fullId] then
            if not isInParryRange(char) then return end
            doParry()
        end
    end)

    task.spawn(function()
        while char.Parent and hookedKillers[char] do
            task.wait(0.03)
            if not S.Parry then break end
            local myRoot = getRoot()
            local eRoot = char:FindFirstChild("HumanoidRootPart")
            if not myRoot or not eRoot then continue end
            local dist = (eRoot.Position - myRoot.Position).Magnitude
            if dist > (S.ParryDist + 5) then continue end
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local anim = track.Animation
                if anim and anim.AnimationId then
                    local id = tostring(anim.AnimationId):match("%d+")
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

task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if S.Parry then scanKillers() end
    end
end)

_G.Roooor_ParryCircle = nil

function updateParryCircle()
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
    local size = (S.ParryDist + 5) * 2
    _G.Roooor_ParryCircle.Size = Vector3.new(0.1, size, size)
    local yOffset = root.Size.Y / 2 + 1.5
    _G.Roooor_ParryCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0)) * CFrame.Angles(0, 0, math.rad(90))
    _G.Roooor_ParryCircle.Color = C.ACC
    _G.Roooor_ParryCircle.Transparency = 0.5
end

-- AUTO SKILL CHECK
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
                VirtualInputManager:SendTouchEvent(8822, 0, p.X + s.X / 2 + i.X, p.Y + s.Y / 2 + i.Y)
                VirtualInputManager:SendTouchEvent(8822, 2, p.X + s.X / 2 + i.X, p.Y + s.Y / 2 + i.Y)
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

-- AIMLOCK BUTTON (2 MODE)
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

    local lbl2 = Instance.new("TextLabel")
    lbl2.Size = UDim2.new(0, 100, 0, 14)
    lbl2.Position = UDim2.new(0.5, -50, 1, 2)
    lbl2.BackgroundTransparency = 1
    lbl2.Text = "AIMLOCK"
    lbl2.TextColor3 = C.ACC2
    lbl2.TextSize = 10
    lbl2.Font = Enum.Font.GothamBlack
    lbl2.TextStrokeTransparency = 0.3
    lbl2.Parent = btn

    local modeLbl = Instance.new("TextLabel")
    modeLbl.Name = "ModeLabel"
    modeLbl.Size = UDim2.new(0, 100, 0, 12)
    modeLbl.Position = UDim2.new(0.5, -50, 1, 17)
    modeLbl.BackgroundTransparency = 1
    modeLbl.Text = S.AimlockMode or "KILLER"
    modeLbl.TextColor3 = C.ACC4
    modeLbl.TextSize = 9
    modeLbl.Font = Enum.Font.GothamBold
    modeLbl.Parent = btn

    local dragging, ds, dp, wasDragged = false, nil, nil, false

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
            btn.TextColor3 = Color3.new(1, 1, 1)
        else
            btn.BackgroundColor3 = C.PANEL
            bStrk.Color = C.ACC
            btn.TextColor3 = C.ACC2
        end
    end)

    btn.MouseButton2Click:Connect(function()
        if S.AimlockMode == "Killer" then
            S.AimlockMode = "Survivor"
            modeLbl.Text = "SURVIVOR"
            modeLbl.TextColor3 = C.GRN
        else
            S.AimlockMode = "Killer"
            modeLbl.Text = "KILLER"
            modeLbl.TextColor3 = C.ACC4
        end
    end)

    _G.AimlockButton = btnGui
end

_G.createAimlockButton = createAimlockButton

local function removeAimlockButton()
    if _G.AimlockButton then
        _G.AimlockButton:Destroy()
        _G.AimlockButton = nil
    end
end
_G.removeAimlockButton = removeAimlockButton

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

print("✅ [8/16] Auto Parry + Skill + Aimlock 2 Mode loaded")-- =========================================================
-- BAGIAN 9/16 : VISUAL + KORBLOX + HEADLESS + KILLER + MOONWALK FIX
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

-- KORBLOX (1 KAKI KANAN)
local KorbloxOrig = nil

function applyKorblox(s)
    local char = LP.Character
    if not char then return end
    local rightLeg = char:FindFirstChild("Right Leg")
        or char:FindFirstChild("RightUpperLeg")
        or char:FindFirstChild("RightLowerLeg")
    if not rightLeg then return end

    if s then
        if not KorbloxOrig then
            KorbloxOrig = {
                Color = rightLeg.Color,
                BrickColor = rightLeg.BrickColor,
                Material = rightLeg.Material,
                Size = rightLeg.Size,
            }
        end
        rightLeg.Color = Color3.fromRGB(27, 42, 53)
        rightLeg.Material = Enum.Material.Slate
        rightLeg.Transparency = 0

        local oldMesh = rightLeg:FindFirstChild("RoooorKorblox")
        if oldMesh then oldMesh:Destroy() end

        local mesh = Instance.new("SpecialMesh")
        mesh.Name = "RoooorKorblox"
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://1395869870"
        mesh.TextureId = "rbxassetid://1395869868"
        mesh.Scale = Vector3.new(1.15, 1.05, 1.15)
        mesh.Parent = rightLeg

        if char:FindFirstChild("Humanoid") and char.Humanoid.RigType == Enum.HumanoidRigType.R15 then
            pcall(function()
                rightLeg.Size = Vector3.new(1.2, 1.2, 1.2)
            end)
        end
    else
        local oldMesh = rightLeg:FindFirstChild("RoooorKorblox")
        if oldMesh then oldMesh:Destroy() end
        if KorbloxOrig then
            rightLeg.Color = KorbloxOrig.Color
            rightLeg.BrickColor = KorbloxOrig.BrickColor
            rightLeg.Material = KorbloxOrig.Material
            rightLeg.Size = KorbloxOrig.Size
            KorbloxOrig = nil
        else
            rightLeg.Material = Enum.Material.Plastic
        end
    end
end

task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if S.Korblox and LP.Character then
            local rightLeg = LP.Character:FindFirstChild("Right Leg")
                or LP.Character:FindFirstChild("RightUpperLeg")
                or LP.Character:FindFirstChild("RightLowerLeg")
            if rightLeg then
                if not rightLeg:FindFirstChild("RoooorKorblox") then
                    applyKorblox(true)
                else
                    if rightLeg.Color ~= Color3.fromRGB(27, 42, 53) then
                        rightLeg.Color = Color3.fromRGB(27, 42, 53)
                    end
                    if rightLeg.Transparency ~= 0 then
                        rightLeg.Transparency = 0
                    end
                end
            end
        end
    end
end)

-- HEADLESS
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
        task.wait(0.5)
        if S.Headless and LP.Character then
            local head = LP.Character:FindFirstChild("Head")
            if head then
                if head.Transparency ~= 1 then
                    head.Transparency = 1
                end
                for _, v in pairs(head:GetChildren()) do
                    if (v:IsA("Decal") or v:IsA("SpecialMesh") or v:IsA("Mesh")) and v.Transparency ~= 1 then
                        v.Transparency = 1
                    end
                end
            end
        end
    end
end)

-- WALK SPEED LOOP
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

-- INSTANT ESCAPE
function teleportToFinishLine()
    local root = getRoot()
    if not root then return end
    local found = nil
    local searchNames = {"fininshline", "finishline", "finish", "gate", "exit", "escape"}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local lname = string.lower(obj.Name)
            for _, search in ipairs(searchNames) do
                if string.find(lname, search) then
                    found = obj
                    break
                end
            end
            if found then break end
        end
    end
    if not found then
        warn("[RoooorHub] Finish line gak ketemu")
        return
    end
    root.CFrame = found.CFrame + Vector3.new(0, 5, 0)
end

-- FAST VAULT
local FastVaultMap = {
    ["rbxassetid://83873880822918"] = "rbxassetid://136962284480779",
}
local VaultTracks = {}

local function hookVault(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not S.FastVault then return end
        local anim = track.Animation
        if not anim or not anim.AnimationId then return end
        local id = tostring(anim.AnimationId):match("%d+")
        if not id then return end
        local fullId = "rbxassetid://" .. id
        local replaceId = FastVaultMap[fullId]
        if not replaceId then return end
        if VaultTracks[track] then return end
        VaultTracks[track] = true
        track:Stop()
        local newAnim = Instance.new("Animation")
        newAnim.AnimationId = replaceId
        local newTrack = animator:LoadAnimation(newAnim)
        newTrack.Priority = Enum.AnimationPriority.Action
        newTrack:Play()
        newTrack:AdjustSpeed(S.FastVaultSpeed or 1.5)
        newTrack.Stopped:Connect(function()
            VaultTracks[track] = nil
        end)
    end)
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    hookVault(char)
end)
if LP.Character then hookVault(LP.Character) end

-- MOONWALK FIX (LOBBY = INGAME)
_G.MoonwalkConn = nil
_G.MoonwalkAntiTP = nil
_G.MoonwalkLastCF = nil
_G.MoonwalkHeartbeat = nil

local function isDowned()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return hum.Health <= 0 or hum.Health < 2
end

function startMoonwalk()
    if _G.MoonwalkConn then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    pcall(function() hrp:SetNetworkOwner(LP) end)
    _G.MoonwalkLastCF = hrp.CFrame

    _G.MoonwalkConn = RunService.Heartbeat:Connect(function(dt)
        if not S.Moonwalk then return end
        if isDowned() then return end
        local char = LP.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not humanoid or not hrp or not cam then return end

        pcall(function()
            if hrp:GetNetworkOwner() ~= LP then
                hrp:SetNetworkOwner(LP)
            end
        end)

        if humanoid.WalkSpeed ~= S.MoonwalkSlow then
            humanoid.WalkSpeed = S.MoonwalkSlow
        end

        local look = cam.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit
            local angle = math.sin(tick() * S.MoonwalkSpam) * S.MoonwalkIntensity
            local baseCF = CFrame.new(hrp.Position, hrp.Position + flatLook)
            local targetCF = baseCF * CFrame.Angles(0, math.rad(angle), 0)
            hrp.CFrame = targetCF
            _G.MoonwalkLastCF = targetCF
            humanoid:Move(Vector3.new(0, 0, 1), true)
        end
    end)

    _G.MoonwalkAntiTP = RunService.Stepped:Connect(function()
        if not S.Moonwalk then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if _G.MoonwalkLastCF then
            local diff = (hrp.Position - _G.MoonwalkLastCF.Position).Magnitude
            if diff > 15 then
                hrp.CFrame = _G.MoonwalkLastCF
            end
        end
    end)

    _G.MoonwalkHeartbeat = task.spawn(function()
        while S.Moonwalk and _G.MoonwalkConn do
            task.wait(0.03)
            local char = LP.Character
            if not char then break end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then break end
            if hum.WalkSpeed ~= S.MoonwalkSlow then
                hum.WalkSpeed = S.MoonwalkSlow
            end
            pcall(function()
                if hrp:GetNetworkOwner() ~= LP then
                    hrp:SetNetworkOwner(LP)
                end
            end)
            if hum.PlatformStand then hum.PlatformStand = false end
            if hum:GetState() == Enum.HumanoidStateType.Freefall then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end)
end

function stopMoonwalk()
    if _G.MoonwalkConn then
        _G.MoonwalkConn:Disconnect()
        _G.MoonwalkConn = nil
    end
    if _G.MoonwalkAntiTP then
        _G.MoonwalkAntiTP:Disconnect()
        _G.MoonwalkAntiTP = nil
    end
    _G.MoonwalkLastCF = nil
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if S.WalkSpeed then
                hum.WalkSpeed = S.WalkSpeedVal + (S.WalkSpeedBoost or 0)
            else
                hum.WalkSpeed = 16
            end
        end
    end
end

-- KILLER FUNCTIONS
local lastAtk = 0
task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        if S.Killer_AutoAtk then
            local now = tick()
            if now - lastAtk >= (S.Killer_AtkDelay or 0.35) then
                lastAtk = now
                pcall(function()
                    local r = ReplicatedStorage:FindFirstChild("Remotes")
                    if r then
                        local a = r:FindFirstChild("Attacks")
                        if a then
                            local atk = a:FindFirstChild("BasicAttack")
                            if atk then atk:FireServer(false) end
                        end
                    end
                end)
            end
        end
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(0.2)
        if S.Killer_KillAll then
            local myRoot = getRoot()
            if myRoot then
                local closest, shortest = nil, 500
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Survivors" then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hrp and hum and hum.Health > 0 then
                            local dist = (hrp.Position - myRoot.Position).Magnitude
                            if dist < shortest then shortest = dist; closest = hrp end
                        end
                    end
                end
                if closest then
                    local targetPos = closest.Position + (closest.AssemblyLinearVelocity * 0.15)
                    local behind = closest.CFrame.LookVector * -3
                    myRoot.CFrame = CFrame.new(targetPos + behind, targetPos)
                    pcall(function()
                        local r = ReplicatedStorage:FindFirstChild("Remotes")
                        if r then
                            local a = r:FindFirstChild("Attacks")
                            if a then
                                local atk = a:FindFirstChild("BasicAttack")
                                if atk then atk:FireServer(false) end
                            end
                        end
                    end)
                end
            end
        end
    end
end)

local hitboxCache = {}
task.spawn(function()
    while gui.Parent do
        task.wait(0.3)
        if S.Killer_Hitbox then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Team and p.Team.Name == "Survivors" then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local parts = {
                            p.Character:FindFirstChild("Head"),
                            p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso"),
                            p.Character:FindFirstChild("HumanoidRootPart"),
                        }
                        for _, part in pairs(parts) do
                            if part and part:IsA("BasePart") then
                                if not hitboxCache[part] then
                                    hitboxCache[part] = { Size = part.Size, Transparency = part.Transparency, Material = part.Material, Color = part.Color }
                                end
                                local size = S.Killer_HitboxSize or 15
                                part.Size = Vector3.new(size, size, size)
                                part.CanCollide = false
                                if S.Killer_Hitbox_Visible then
                                    part.Transparency = 0.7
                                    part.BrickColor = BrickColor.new("Really red")
                                    part.Material = Enum.Material.Neon
                                else
                                    part.Transparency = 1
                                end
                            end
                        end
                    end
                end
            end        else
            for part, orig in pairs(hitboxCache) do
                if part and part.Parent then
                    part.Size = orig.Size
                    part.Transparency = orig.Transparency
                    part.CanCollide = true
                    part.Material = orig.Material
                    part.Color = orig.Color
                end
                hitboxCache[part] = nil
            end
        end
    end
end)

local function activateMaskedPower(power)
    pcall(function()
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        if r then
            local k = r:FindFirstChild("Killers")
            if k then
                local m = k:FindFirstChild("Masked")
                if m then
                    local ev = m:FindFirstChild("Activatepower")
                    if ev then ev:FireServer(power) end
                end
            end
        end
    end)
end

local function deactivateMaskedPower()
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
end

task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if S.Killer_AutoStalk then
            local myRoot = getRoot()
            if myRoot then
                local closest, shortest = nil, S.Killer_StalkRange or 150
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Survivors" then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hrp and hum and hum.Health > 30 then
                            local dist = (hrp.Position - myRoot.Position).Magnitude
                            if dist < shortest then shortest = dist; closest = p end
                        end
                    end
                end
                if closest then
                    pcall(function()
                        local r = ReplicatedStorage:FindFirstChild("Remotes")
                        if r then
                            local k = r:FindFirstChild("Killers")
                            if k then
                                local s = k:FindFirstChild("Stalker")
                                if s then
                                    local ev = s:FindFirstChild("StartStalking")
                                    if ev then ev:FireServer(closest) end
                                end
                            end
                        end
                    end)
                end
            end
        end
    end
end)

-- MOONWALK BUTTON
_G.MoonwalkButton = nil

function createMoonwalkButton()
    if _G.MoonwalkButton then _G.MoonwalkButton:Destroy() end
    local btnGui = Instance.new("ScreenGui")
    btnGui.Name = "RoooorMoonwalkBtn"
    btnGui.ResetOnSpawn = false
    btnGui.IgnoreGuiInset = true
    btnGui.Parent = PG
    local btn = Instance.new("TextButton")
    btn.Name = "MoonwalkBtn"
    btn.Size = UDim2.new(0, 52, 0, 52)
    btn.Position = UDim2.new(0.65, 0, 0.75, 0)
    btn.BackgroundColor3 = C.PANEL
    btn.Text = "🌙"
    btn.TextColor3 = C.ACC2
    btn.TextSize = 26
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = btnGui
    rnd(btn, 26)
    local bStrk = strk(btn, C.ACC, 2)
    local lbl2 = Instance.new("TextLabel")
    lbl2.Size = UDim2.new(0, 100, 0, 14)
    lbl2.Position = UDim2.new(0.5, -50, 1, 2)
    lbl2.BackgroundTransparency = 1
    lbl2.Text = "MOONWALK"
    lbl2.TextColor3 = C.ACC2
    lbl2.TextSize = 10
    lbl2.Font = Enum.Font.GothamBlack
    lbl2.TextStrokeTransparency = 0.3
    lbl2.Parent = btn
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
    local dragging, ds, dp, wasDragged = false, nil, nil, false
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if S.MoonwalkLocked then return end
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
        S.Moonwalk = not S.Moonwalk
        if S.Moonwalk then
            btn.BackgroundColor3 = C.ACC
            bStrk.Color = C.ACC2
            btn.TextColor3 = Color3.new(1, 1, 1)
            startMoonwalk()
        else
            btn.BackgroundColor3 = C.PANEL
            bStrk.Color = C.ACC
            btn.TextColor3 = C.ACC2
            stopMoonwalk()
        end
    end)
    _G.MoonwalkButton = btnGui
end

_G.createMoonwalkButton = createMoonwalkButton

function removeMoonwalkButton()
    if _G.MoonwalkButton then _G.MoonwalkButton:Destroy(); _G.MoonwalkButton = nil end
end
_G.removeMoonwalkButton = removeMoonwalkButton

function updateMoonwalkLock()
    if not _G.MoonwalkButton then return end
    local btn = _G.MoonwalkButton:FindFirstChild("MoonwalkBtn", true)
    if btn then
        local lockLbl = btn:FindFirstChild("LockLabel")
        if lockLbl then
            if S.MoonwalkLocked then
                lockLbl.Text = "🔒"
                lockLbl.TextColor3 = C.GOLD
            else
                lockLbl.Text = "🔓"
                lockLbl.TextColor3 = C.DIM
            end
        end
    end
end
_G.updateMoonwalkLock = updateMoonwalkLock

print("✅ [9/16] Visual + Korblox + Headless + Killer + Moonwalk FIX loaded")-- =========================================================
-- BAGIAN 10/16 : TAB FIRE + FIRE FEET
-- =========================================================

makeTab("Fire", "🔥", 1, function()
    sec("Fire Control", "⚙️")
    tog("Enable Fire", false, function(s) S.FireOn = s; applyFire() end)
    sl("Fire Size", 1, 15, 5, function(v) S.FireSize = v; applyFire() end)

    sec("Pilih Efek Fire (60)", "🔥")
    lbl("Klik efek untuk ganti", C.ACC2)

    for i, fireName in ipairs(FireList) do
        local btn2 = Instance.new("TextButton")
        btn2.Size = UDim2.new(1, -4, 0, 28)
        btn2.BackgroundColor3 = C.BG
        btn2.BackgroundTransparency = 0.4
        btn2.BorderSizePixel = 0
        btn2.Text = ""
        btn2.AutoButtonColor = false
        btn2.LayoutOrder = i + 100
        btn2.Parent = cs
        rnd(btn2, 8)
        local btnStroke = strk(btn2, C.ACC, 1, 0.6)

        local btnLbl = Instance.new("TextLabel")
        btnLbl.Size = UDim2.new(1, -10, 1, 0)
        btnLbl.Position = UDim2.new(0, 10, 0, 0)
        btnLbl.BackgroundTransparency = 1
        btnLbl.Text = "🔥 " .. fireName
        btnLbl.TextColor3 = C.TXT
        btnLbl.TextSize = 11
        btnLbl.Font = Enum.Font.GothamMedium
        btnLbl.TextXAlignment = Enum.TextXAlignment.Left
        btnLbl.Parent = btn2

        if S.FireType == fireName then
            btn2.BackgroundColor3 = C.ACC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
            btnStroke.Color = C.ACC2
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
                    local s = c:FindFirstChildOfClass("UIStroke")
                    if s then s.Color = C.ACC end
                end
            end
            btn2.BackgroundColor3 = C.ACC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
            btnStroke.Color = C.ACC2
        end)
    end
end)

makeTab("Fire Feet", "👟", 2, function()
    sec("Fire Feet Control", "👟")
    tog("Enable Fire Feet", false, function(s) S.FireFeetOn = s; applyFireFeet() end)

    sec("Pilih Efek Fire Feet (20)", "🔥")
    lbl("Klik efek untuk ganti", C.ACC2)

    for i, fireName in ipairs(FireFeetList) do
        local btn2 = Instance.new("TextButton")
        btn2.Size = UDim2.new(1, -4, 0, 28)
        btn2.BackgroundColor3 = C.BG
        btn2.BackgroundTransparency = 0.4
        btn2.BorderSizePixel = 0
        btn2.Text = ""
        btn2.AutoButtonColor = false
        btn2.LayoutOrder = i + 200
        btn2.Parent = cs
        rnd(btn2, 8)
        local btnStroke = strk(btn2, C.ACC, 1, 0.6)

        local btnLbl = Instance.new("TextLabel")
        btnLbl.Size = UDim2.new(1, -10, 1, 0)
        btnLbl.Position = UDim2.new(0, 10, 0, 0)
        btnLbl.BackgroundTransparency = 1
        btnLbl.Text = "👟 " .. fireName
        btnLbl.TextColor3 = C.TXT
        btnLbl.TextSize = 11
        btnLbl.Font = Enum.Font.GothamMedium
        btnLbl.TextXAlignment = Enum.TextXAlignment.Left
        btnLbl.Parent = btn2

        if S.FireFeetType == fireName then
            btn2.BackgroundColor3 = C.ACC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
            btnStroke.Color = C.ACC2
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
                    local s = c:FindFirstChildOfClass("UIStroke")
                    if s then s.Color = C.ACC end
                end
            end
            btn2.BackgroundColor3 = C.ACC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
            btnStroke.Color = C.ACC2
        end)
    end
end)

print("✅ [10/16] Tab Fire + Fire Feet loaded")-- =========================================================
-- BAGIAN 11/16 : TAB ESP + SURVIVOR + KILLER + VISUAL + MOVEMENT + SETTINGS
-- =========================================================

makeTab("ESP", "👁️", 3, function()
    sec("Player ESP + Nama", "🟢")
    tog("Enable ESP Name", false, function(s)
        S.ESP_Name = s
        if not s then
            for _, bb in pairs(_G.Roooor_StatusESP or {}) do if bb then bb:Destroy() end end
            _G.Roooor_StatusESP = {}
        end
    end)
    sl("Nama Size", 8, 60, 12, function(v) S.ESP_Size = v end)
    sl("ESP Radius", 50, 5000, 500, function(v) S.ESP_Radius = v end)
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

makeTab("Survivor", "🏃", 4, function()
    sec("Auto Parry 360°", "🛡️")
    tog("Enable Auto Parry", false, function(s) S.Parry = s; if s then scanKillers() end end)
    sl("Parry Distance", 3, 25, 8, function(v) S.ParryDist = v end)

    sec("Parry Circle", "🔵")
    tog("Enable Parry Circle", false, function(s) S.ParryCircle = s end)
    sl("Circle Size", 5, 50, 15, function(v) S.ParryCircleSize = v end)

    sec("Auto Skill Check", "🎯")
    tog("Enable Skill Check", false, function(s) S.Skill = s end)

    sec("Aimlock (2 Mode)", "🎯")
    tog("Enable Aimlock", false, function(s) S.Aimlock = s end)
    drp("Aimlock Mode", {"Killer", "Survivor"}, "Killer", function(v) S.AimlockMode = v end)
    sl("Aimlock Radius", 50, 5000, 500, function(v) S.AimlockRadius = v end)
    tog("Show Aimlock Button", false, function(s)
        if s then createAimlockButton() else removeAimlockButton() end
    end)
    tog("🔒 Lock Aimlock Button", false, function(s)
        S.AimlockLocked = s
    end)
    btn("🔄 Reset Posisi Aimlock", function()
        if _G.AimlockButton then
            local b = _G.AimlockButton:FindFirstChild("AimlockBtn", true)
            if b then b.Position = UDim2.new(0.35, 0, 0.75, 0) end
        end
    end)
    lbl("Klik kanan tombol 🎯 = switch mode", C.ACC2)
end)

makeTab("Killer", "🔪", 5, function()
    sec("Auto Attack", "⚔️")
    tog("Auto Spam Attack", false, function(s) S.Killer_AutoAtk = s end)
    sl("Attack Delay", 0.1, 2, 0.35, function(v) S.Killer_AtkDelay = v end)

    sec("Auto Kill All", "💀")
    tog("Auto Kill All", false, function(s) S.Killer_KillAll = s end)
    lbl("TP + Attack survivor terdekat", C.ACC2)
    lbl("⚠️ Beresiko ban di public", C.RED)

    sec("Hitbox Expander", "📦")
    tog("Enable Hitbox", false, function(s) S.Killer_Hitbox = s end)
    sl("Hitbox Size", 3, 50, 15, function(v) S.Killer_HitboxSize = v end)
    tog("Hide Hitbox Visual", false, function(s) S.Killer_Hitbox_Visible = not s end)
    lbl("Kalau ON = hitbox invisible, fitur tetap jalan", C.ACC2)

    sec("Masked Power", "🎭")
    drp("Select Power", {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}, "Cobra", function(v)
        S.MaskedPower = v
    end)
    btn("⚡ Activate Power", function() activateMaskedPower(S.MaskedPower or "Cobra") end)
    btn("❌ Deactivate Power", function() deactivateMaskedPower() end)

    sec("Auto Stalk", "👁️")
    tog("Auto Stalk", false, function(s) S.Killer_AutoStalk = s end)
    sl("Stalk Range", 50, 500, 150, function(v) S.Killer_StalkRange = v end)
end)

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

    sec("Sky Changer (25 Sky)", "🌤️")
    lbl("Klik untuk ganti sky", C.ACC2)
    for i, skyName in ipairs(SkyList) do
        local btn2 = Instance.new("TextButton")
        btn2.Size = UDim2.new(1, -4, 0, 26)
        btn2.BackgroundColor3 = C.BG
        btn2.BackgroundTransparency = 0.4
        btn2.BorderSizePixel = 0
        btn2.Text = ""
        btn2.AutoButtonColor = false
        btn2.LayoutOrder = i + 300
        btn2.Parent = cs
        rnd(btn2, 6)
        local btnStroke = strk(btn2, C.ACC, 1, 0.6)

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
            btn2.BackgroundColor3 = C.ACC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
            btnStroke.Color = C.ACC2
        end

        btn2.MouseButton1Click:Connect(function()
            S.SkyId = skyName
            applySky(skyName)
            for _, c in pairs(cs:GetChildren()) do
                if c:IsA("TextButton") and c.LayoutOrder > 300 then
                    c.BackgroundColor3 = C.BG
                    c.BackgroundTransparency = 0.4
                    local l = c:FindFirstChildOfClass("TextLabel")
                    if l then l.TextColor3 = C.TXT end
                    local s = c:FindFirstChildOfClass("UIStroke")
                    if s then s.Color = C.ACC end
                end
            end
            btn2.BackgroundColor3 = C.ACC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
            btnStroke.Color = C.ACC2
        end)
    end

    sec("Appearance", "💫")
    tog("Korblox Legs (1 Kaki)", false, function(s) S.Korblox = s; applyKorblox(s) end)
    tog("Headless", false, function(s) S.Headless = s; applyHeadless(s) end)
end)

makeTab("Movement", "🏃", 7, function()
    sec("Walk Speed", "⚡")
    tog("Enable Walk Speed", false, function(s) S.WalkSpeed = s end)
    sl("Speed Value", 16, 200, 16, function(v) S.WalkSpeedVal = v end)
    sl("Speed Boost", 0, 200, 0, function(v) S.WalkSpeedBoost = v end)

    sec("Instant Escape", "🚪")
    btn("🚀 Instant Escape (TP Finish)", function()
        teleportToFinishLine()
    end)
    lbl("Teleport ke finish line/gate", C.ACC2)

    sec("Fast Vault", "🏃")
    tog("Enable Fast Vault", false, function(s) S.FastVault = s end)
    sl("Animation Speed", 1, 5, 1.5, function(v) S.FastVaultSpeed = v end)

    sec("Moonwalk", "🌙")
    tog("Enable Moonwalk", false, function(s)
        S.Moonwalk = s
        if s then startMoonwalk() else stopMoonwalk() end
    end)
    sl("Spam Speed", 1, 100, 30, function(v) S.MoonwalkSpam = v end)
    sl("Intensity", 1, 90, 35, function(v) S.MoonwalkIntensity = v end)
    sl("Slow Speed", 5, 30, 13, function(v) S.MoonwalkSlow = v end)
    lbl("Lobby & Ingame SAMA (CFrame Fix)", C.GRN)

    sec("Moonwalk Floating Button", "🌙")
    tog("Show Moonwalk Button", false, function(s)
        if s then
            createMoonwalkButton()
            task.wait(0.1)
            updateMoonwalkLock()
        else
            removeMoonwalkButton()
        end
    end)
    tog("🔒 Lock Moonwalk Button", false, function(s)
        S.MoonwalkLocked = s
        updateMoonwalkLock()
    end)
    btn("🔄 Reset Posisi Moonwalk", function()
        if _G.MoonwalkButton then
            local b = _G.MoonwalkButton:FindFirstChild("MoonwalkBtn", true)
            if b then b.Position = UDim2.new(0.65, 0, 0.75, 0) end
        end
    end)
end)

makeTab("Settings", "⚙️", 8, function()
    sec("Keybind", "⌨️")
    lbl("RightShift = Toggle Menu", C.ACC2)
    lbl("Klik ⚡ = Buka Menu", C.ACC2)
    lbl("Drag Header = Pindah Window", C.DIM)
    lbl("Drag 🎯/🌙 = Pindah Tombol", C.DIM)
    lbl("Klik kanan 🎯 = Switch Aimlock Mode", C.DIM)

    sec("Info", "ℹ️")
    lbl("RoooorHub Premium Ultimate + Fallens + Misc", C.ACC4)
    lbl("60 Fire + 20 Fire Feet + 25 Sky", C.ACC2)
    lbl("ESP + Parry Anti-Miss + Aimlock 2 Mode", C.ACC2)
    lbl("Killer + Visual + Movement + Misc Tab", C.ACC2)
    lbl("Made with 💜", C.ACC3)
end)

print("✅ [11/16] Tab utama loaded")-- =========================================================
-- BAGIAN 12/16 : MAIN LOOP + KEYBIND + ANTI-RESET
-- =========================================================

local fpsPanel = Instance.new("Frame")
fpsPanel.Size = UDim2.new(0, 170, 0, 28)
fpsPanel.Position = UDim2.new(0.5, -85, 0, 8)
fpsPanel.BackgroundColor3 = C.PANEL
fpsPanel.BackgroundTransparency = 0.3
fpsPanel.BorderSizePixel = 0
fpsPanel.Parent = gui
rnd(fpsPanel, 14)
strk(fpsPanel, C.ACC, 1, 0.5)

local fpsGrad = Instance.new("UIGradient")
fpsGrad.Color = ColorSequence.new(C.ACC, C.ACC2, C.ACC3)
fpsGrad.Rotation = 0
fpsGrad.Parent = fpsPanel

task.spawn(function()
    while fpsPanel.Parent do
        for i = 0, 1, 0.01 do
            if not fpsPanel.Parent then break end
            fpsGrad.Rotation = i * 360
            task.wait(0.03)
        end
    end
end)

local fpsLbl = Instance.new("TextLabel")
fpsLbl.Size = UDim2.new(1, -10, 1, 0)
fpsLbl.Position = UDim2.new(0, 5, 0, 0)
fpsLbl.BackgroundTransparency = 1
fpsLbl.Text = "FPS: -- | PING: --"
fpsLbl.TextColor3 = C.TXT
fpsLbl.TextSize = 11
fpsLbl.Font = Enum.Font.GothamBold
fpsLbl.TextStrokeTransparency = 0.5
fpsLbl.Parent = fpsPanel

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
        fpsLbl.Text = string.format("FPS: %d | PING: %d ms", fps, ping)
        fCnt = 0
        tAcc = 0
    end
end)

task.spawn(function()
    while gui.Parent do
        local root = getRoot()
        if root then
            if S.ESP_Name then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            _G.Roooor_createStatusESP(p, p.Character, root)
                            local bb = _G.Roooor_StatusESP[p.Character]
                            if bb then
                                local lbl2 = bb:FindFirstChildOfClass("TextLabel")
                                if lbl2 and lbl2.TextSize ~= S.ESP_Size then
                                    lbl2.TextSize = S.ESP_Size
                                end
                            end
                        else
                            if _G.Roooor_StatusESP[p.Character] then
                                _G.Roooor_StatusESP[p.Character]:Destroy()
                                _G.Roooor_StatusESP[p.Character] = nil
                            end
                        end
                    end
                end
            end
            if S.ESP_Generator then
                for gen in pairs(_G.Roooor_Cached.Generators) do
                    if gen and gen.Parent then _G.Roooor_UpdateGenerator(gen) end
                end
            end
            if S.ESP_Pallet then
                for obj in pairs(_G.Roooor_Cached.Pallets) do
                    if obj and obj.Parent then _G.Roooor_UpdateMapESP(obj, root) end
                end
            end
            if S.ESP_Window then
                for obj in pairs(_G.Roooor_Cached.Windows) do
                    if obj and obj.Parent then _G.Roooor_UpdateMapESP(obj, root) end
                end
            end
            if S.ESP_SCP then
                _G.Roooor_UpdateSCPEsp(root)
            end
            if S.ESP_Name then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            local char = p.Character
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local dist = (hrp.Position - root.Position).Magnitude
                                if dist <= S.ESP_Radius then
                                    if p.Team and p.Team.Name == "Killer" then
                                        _G.Roooor_createESP(char, S.ESP_KillerColor)
                                    elseif p.Team and p.Team.Name == "Survivors" then
                                        _G.Roooor_createESP(char, S.ESP_SurvivorColor)
                                    else
                                        _G.Roooor_createESP(char, S.ESP_DefaultColor)
                                    end
                                else
                                    _G.Roooor_removeESP(char)
                                end
                            end
                        else
                            _G.Roooor_removeESP(p.Character)
                        end
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)

RunService.RenderStepped:Connect(function()
    if S.ParryCircle then
        updateParryCircle()
    end
end)

LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    hookedKillers = {}
    _G.Roooor_HookedKillers = {}

    if S.FireOn then applyFire() end
    if S.FireFeetOn then applyFireFeet() end
    if S.Parry then scanKillers() end
    if S.Korblox then task.wait(0.3); applyKorblox(true) end
    if S.Headless then task.wait(0.3); applyHeadless(true) end
    if S.FastVault then task.wait(0.5); hookVault(char) end
    if S.Moonwalk then
        task.wait(0.5)
        stopMoonwalk()
        task.wait(0.1)
        startMoonwalk()
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if main.Visible then
            main.Visible = false
            fBtn.Visible = true
        else
            main.Visible = true
            fBtn.Visible = false
        end
    end
end)

task.wait(0.3)
for _, c in pairs(sb:GetChildren()) do
    if c:IsA("TextButton") then
        c.MouseButton1Click:Fire()
        break
    end
end

task.spawn(function()
    while main.Parent do
        task.wait(0.05)
        if not M.RGBUI then
            local hue = (tick() * 0.3) % 1
            mainStrk.Color = Color3.fromHSV(hue, 1, 1)
            mainStrk.Transparency = 0.4
        end
    end
end)

-- ANTI-RESET FITUR UTAMA
task.spawn(function()
    while gui.Parent do
        task.wait(0.3)
        for name, val in pairs(_G.SliderStates) do
            if name == "Nama Size" then S.ESP_Size = val end
            if name == "ESP Radius" then S.ESP_Radius = val end
            if name == "Parry Distance" then S.ParryDist = val end
            if name == "Circle Size" then S.ParryCircleSize = val end
            if name == "Fire Size" then S.FireSize = val end
            if name == "Aimlock Radius" then S.AimlockRadius = val end
            if name == "Speed Value" then S.WalkSpeedVal = val end
            if name == "Speed Boost" then S.WalkSpeedBoost = val end
            if name == "Animation Speed" then S.FastVaultSpeed = val end
            if name == "Attack Delay" then S.Killer_AtkDelay = val end
            if name == "Hitbox Size" then S.Killer_HitboxSize = val end
            if name == "Stalk Range" then S.Killer_StalkRange = val end
            if name == "Spam Speed" then S.MoonwalkSpam = val end
            if name == "Intensity" then S.MoonwalkIntensity = val end
            if name == "Slow Speed" then S.MoonwalkSlow = val end
            if name == "Contrast Value" then S.ContrastVal = val end
            if name == "Saturation" then S.SaturationVal = val end
            if name == "FOV Value" then S.FOV = val end
        end
        for name, state in pairs(_G.ToggleStates) do
            if name == "Enable ESP Name" then S.ESP_Name = state end
            if name == "ESP Generator" then S.ESP_Generator = state end
            if name == "ESP Pallet" then S.ESP_Pallet = state end
            if name == "ESP Window" then S.ESP_Window = state end
            if name == "ESP SCP" then S.ESP_SCP = state end
            if name == "Enable Auto Parry" then
                if S.Parry ~= state then
                    S.Parry = state
                    if state then scanKillers() end
                end
            end
            if name == "Enable Parry Circle" then S.ParryCircle = state end
            if name == "Enable Fire" then S.FireOn = state end
            if name == "Enable Fire Feet" then S.FireFeetOn = state end
            if name == "Enable Skill Check" then S.Skill = state end
            if name == "Enable Aimlock" then S.Aimlock = state end
            if name == "Enable Walk Speed" then S.WalkSpeed = state end
            if name == "Fullbright" then S.Fullbright = state end
            if name == "No Fog" then S.NoFog = state end
            if name == "Ultra HD" then S.UltraHD = state end
            if name == "Contrast" then S.Contrast = state end
            if name == "Enable FOV" then S.FOVEnabled = state end
            if name == "Auto Spam Attack" then S.Killer_AutoAtk = state end
            if name == "Auto Kill All" then S.Killer_KillAll = state end
            if name == "Enable Hitbox" then S.Killer_Hitbox = state end
            if name == "Hide Hitbox Visual" then S.Killer_Hitbox_Visible = not state end
            if name == "Auto Stalk" then S.Killer_AutoStalk = state end
            if name == "Korblox Legs (1 Kaki)" then S.Korblox = state end
            if name == "Headless" then S.Headless = state end
            if name == "Enable Fast Vault" then S.FastVault = state end
            if name == "Enable Moonwalk" then
                if S.Moonwalk ~= state then
                    S.Moonwalk = state
                    if state then startMoonwalk() else stopMoonwalk() end
                end
            end
        end
    end
end)

print("✅ [12/16] Main Loop + Anti-Reset loaded")-- =========================================================
-- BAGIAN 13/16 : FUNGSI MISC — SURVIVOR + VISUAL + ANTI
-- =========================================================

local function findRemote(keyword)
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            if string.find(string.lower(obj.Name), string.lower(keyword)) then
                return obj
            end
        end
    end
    return nil
end

local PalletRemote = findRemote("pallet") or findRemote("drop")
local HealRemote = findRemote("heal") or findRemote("medkit")
local ReviveRemote = findRemote("revive") or findRemote("rescue")
local RepairRemote = findRemote("repair") or findRemote("generator")

-- =========================================================
-- SURVIVOR MISC
-- =========================================================

-- AUTO PALLET
task.spawn(function()
    while gui.Parent do
        task.wait(0.15)
        if M.AutoPallet then
            local myRoot = getRoot()
            if myRoot then
                local killerNear = false
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                        local krp = p.Character:FindFirstChild("HumanoidRootPart")
                        if krp and (krp.Position - myRoot.Position).Magnitude <= M.AutoPalletRange then
                            killerNear = true
                            break
                        end
                    end
                end
                if killerNear then
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name == "Pallet" or obj.Name == "Palletwrong") then
                            if (obj.Position - myRoot.Position).Magnitude <= 15 then
                                if PalletRemote then pcall(function() PalletRemote:FireServer(obj) end) end
                                local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
                                if prompt then
                                    pcall(function()
                                        prompt:InputHoldBegin()
                                        task.wait(0.05)
                                        prompt:InputHoldEnd()
                                    end)
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- AUTO VAULT
task.spawn(function()
    while gui.Parent do
        task.wait(0.15)
        if M.AutoVault then
            local myRoot = getRoot()
            if myRoot then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                        local krp = p.Character:FindFirstChild("HumanoidRootPart")
                        if krp and (krp.Position - myRoot.Position).Magnitude <= M.AutoVaultRange + 5 then
                            for _, obj in ipairs(workspace:GetDescendants()) do
                                if obj.Name == "Window" then
                                    local pos = obj:IsA("Model") and obj:GetPivot().Position or (obj:IsA("BasePart") and obj.Position)
                                    if pos and (pos - myRoot.Position).Magnitude <= M.AutoVaultRange then
                                        local targetPos = pos + (myRoot.Position - pos).Unit * 2 + Vector3.new(0, 2, 0)
                                        pcall(function() myRoot.CFrame = CFrame.new(targetPos) end)
                                        break
                                    end
                                end
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- AUTO HEAL
task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if M.AutoHeal and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and hum.Health < M.AutoHealThreshold then
                if HealRemote then pcall(function() HealRemote:FireServer() end) end
            end
        end
    end
end)

-- AUTO REVIVE
task.spawn(function()
    while gui.Parent do
        task.wait(1)
        if M.AutoRevive and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then
                if ReviveRemote then pcall(function() ReviveRemote:FireServer() end) end
            end
        end
    end
end)

-- AUTO REPAIR
task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if M.AutoRepair and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj.Name == "Generator" then
                        local pos = obj:IsA("Model") and obj:GetPivot().Position or (obj:IsA("BasePart") and obj.Position)
                        if pos and (pos - myRoot.Position).Magnitude <= 15 then
                            local prompt = obj:FindFirstChildOfClass("ProximityPrompt", true)
                                or (obj:IsA("Model") and obj:FindFirstChildWhichIsA("ProximityPrompt", true))
                            if prompt then pcall(function() prompt:InputHoldBegin() end) end
                            if RepairRemote then pcall(function() RepairRemote:FireServer(obj) end) end
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- SKILL PERFECT
task.spawn(function()
    while gui.Parent do
        task.wait(0.02)
        if M.SkillPerfect and LP.Character then
            local prompt = PG:FindFirstChild("SkillCheckPromptGui")
            if prompt then
                local check = prompt:FindFirstChild("Check")
                if check and check.Visible then
                    local line = check:FindFirstChild("Line")
                    local goal = check:FindFirstChild("Goal")
                    if line and goal then
                        pcall(function() line.Rotation = goal.Rotation end)
                    end
                end
            end
        end
    end
end)

-- SAFE ZONE FINDER
task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if M.SafeZone and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                local nearKiller = math.huge
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                        local krp = p.Character:FindFirstChild("HumanoidRootPart")
                        if krp then
                            local d = (krp.Position - myRoot.Position).Magnitude
                            if d < nearKiller then nearKiller = d end
                        end
                    end
                end
                if nearKiller < 50 then
                    local warn = PG:FindFirstChild("RoooorWarn")
                    if not warn then
                        warn = Instance.new("Frame")
                        warn.Name = "RoooorWarn"
                        warn.Size = UDim2.new(1, 0, 0, 6)
                        warn.Position = UDim2.new(0, 0, 0, 0)
                        warn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        warn.BorderSizePixel = 0
                        warn.Parent = gui
                    end
                    warn.BackgroundTransparency = 0.3
                    task.delay(0.3, function() if warn then warn.BackgroundTransparency = 1 end end)
                end
            end
        end
    end
end)

-- ESCAPE ALERT
task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if M.EscapeAlert and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                        local krp = p.Character:FindFirstChild("HumanoidRootPart")
                        if krp and (krp.Position - myRoot.Position).Magnitude <= M.EscapeAlertRange then
                            local al = PG:FindFirstChild("RoooorAlert")
                            if not al then
                                al = Instance.new("TextLabel")
                                al.Name = "RoooorAlert"
                                al.Size = UDim2.new(0, 300, 0, 40)
                                al.Position = UDim2.new(0.5, -150, 0, 100)
                                al.BackgroundTransparency = 0.3
                                al.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                                al.TextColor3 = Color3.fromRGB(255, 50, 50)
                                al.TextSize = 20
                                al.Font = Enum.Font.GothamBlack
                                al.Text = "⚠️ KILLER DEKET! ⚠️"
                                al.TextStrokeTransparency = 0
                                al.Parent = gui
                                rnd(al, 10)
                            end
                            al.Visible = true
                            task.delay(0.8, function() if al then al.Visible = false end end)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- =========================================================
-- VISUAL MISC
-- =========================================================

local trailObj, auraObj = nil, nil

function applyTrail(s)
    if trailObj then trailObj:Destroy(); trailObj = nil end
    if not s then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local a0 = Instance.new("Attachment")
    a0.Position = Vector3.new(0, 1, 0)
    a0.Parent = hrp
    local a1 = Instance.new("Attachment")
    a1.Position = Vector3.new(0, -1, 0)
    a1.Parent = hrp
    trailObj = Instance.new("Trail")
    trailObj.Attachment0 = a0
    trailObj.Attachment1 = a1
    trailObj.Color = ColorSequence.new(M.TrailColor, M.TrailColor)
    trailObj.Lifetime = 0.5
    trailObj.Parent = hrp
end

function applyAura(s)
    if auraObj then auraObj:Destroy(); auraObj = nil end
    if not s then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    auraObj = Instance.new("ParticleEmitter")
    auraObj.Texture = "rbxassetid://243660364"
    auraObj.Color = ColorSequence.new(M.AuraColor)
    auraObj.Size = NumberSequence.new(2)
    auraObj.Lifetime = NumberRange.new(0.5, 1)
    auraObj.Rate = 30
    auraObj.Speed = NumberRange.new(2)
    auraObj.SpreadAngle = Vector2.new(180, 180)
    auraObj.Parent = hrp
end

local function spawnKillEffect(pos)
    local p = Instance.new("Part")
    p.Anchored = true
    p.CanCollide = false
    p.Material = Enum.Material.Neon
    p.Shape = Enum.PartType.Ball
    p.Size = Vector3.new(2, 2, 2)
    p.Position = pos
    p.Color = Color3.fromRGB(255, 50, 50)
    p.Transparency = 0.3
    p.Parent = workspace
    TweenService:Create(p, TweenInfo.new(0.5), {
        Size = Vector3.new(15, 15, 15),
        Transparency = 1
    }):Play()
    task.delay(0.6, function() p:Destroy() end)
end

task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if M.KillEffect then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health <= 0 then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then spawnKillEffect(hrp.Position) end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(0.05)
        if M.RGBUI then
            local hue = (tick() * 0.3) % 1
            mainStrk.Color = Color3.fromHSV(hue, 1, 1)
            mainGrad.Color = ColorSequence.new(
                Color3.fromHSV(hue, 1, 0.1),
                Color3.fromHSV((hue + 0.3) % 1, 1, 0.15)
            )
        end
    end
end)

local crosshairGui = nil
function applyCrosshair(s)
    if crosshairGui then crosshairGui:Destroy(); crosshairGui = nil end
    if not s then return end
    crosshairGui = Instance.new("ScreenGui")
    crosshairGui.Name = "RoooorCrosshair"
    crosshairGui.ResetOnSpawn = false
    crosshairGui.IgnoreGuiInset = true
    crosshairGui.Parent = PG
    for i = 1, 4 do
        local ln = Instance.new("Frame")
        ln.BackgroundColor3 = M.CrosshairColor
        ln.BorderSizePixel = 0
        if i == 1 then
            ln.Size = UDim2.new(0, M.CrosshairSize, 0, 2)
            ln.Position = UDim2.new(0.5, -M.CrosshairSize - 3, 0.5, -1)
        elseif i == 2 then
            ln.Size = UDim2.new(0, M.CrosshairSize, 0, 2)
            ln.Position = UDim2.new(0.5, 3, 0.5, -1)
        elseif i == 3 then
            ln.Size = UDim2.new(0, 2, 0, M.CrosshairSize)
            ln.Position = UDim2.new(0.5, -1, 0.5, -M.CrosshairSize - 3)
        elseif i == 4 then
            ln.Size = UDim2.new(0, 2, 0, M.CrosshairSize)
            ln.Position = UDim2.new(0.5, -1, 0.5, 3)
        end
        ln.Parent = crosshairGui
    end
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 2, 0, 2)
    dot.Position = UDim2.new(0.5, -1, 0.5, -1)
    dot.BackgroundColor3 = M.CrosshairColor
    dot.BorderSizePixel = 0
    dot.Parent = crosshairGui
    rnd(dot, 1)
end

task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        local cam = workspace.CurrentCamera
        if cam then
            cam.CanCollide = not M.NoClipCamera
        end
    end
end)

function applyZoomOut()
    if M.ZoomOut then
        LP.CameraMaxZoomDistance = M.ZoomOutValue
    else
        LP.CameraMaxZoomDistance = 128
    end
end

-- =========================================================
-- ANTI MISC
-- =========================================================

task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        if M.AntiStun and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.WalkSpeed == 0 and S.WalkSpeed then hum.WalkSpeed = S.WalkSpeedVal end
                if hum.JumpPower == 0 then hum.JumpPower = 50 end
                if hum.PlatformStand then hum.PlatformStand = false end
            end
        end
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(0.2)
        if M.AntiBlind then
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("BlurEffect") then v.Size = 0 end
            end
            local cam = workspace.CurrentCamera
            if cam then
                for _, v in pairs(cam:GetChildren()) do
                    if v:IsA("BlurEffect") then v:Destroy() end
                end
            end
        end
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        if M.AntiGrab and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, v in pairs(hrp:GetChildren()) do
                    if v:IsA("WeldConstraint") or v:IsA("Weld") or v:IsA("Motor6D") then
                        local part1 = v.Part1 or v.Part0
                        if part1 and not part1:IsDescendantOf(LP.Character) then
                            v:Destroy()
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(0.2)
        if M.AntiHook and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Velocity.Magnitude > 200 then
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        if M.AntiRagdoll and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.PlatformStand then hum.PlatformStand = false end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(60)
        if M.AntiAFK then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end
    end
end)

print("✅ [13/16] Fungsi Misc (Survivor + Visual + Anti) loaded")-- =========================================================
-- BAGIAN 14/16 : FUNGSI MISC — TOP 10 (FLY + ITEM ESP + PLAYER LIST)
-- =========================================================

-- FLY
local flyBodyVelocity, flyBodyGyro, flyConn = nil, nil, nil

function startFly()
    if flyConn then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function() hrp:SetNetworkOwner(LP) end)
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = hrp
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyGyro.P = 15000
    flyBodyGyro.D = 500
    flyBodyGyro.Parent = hrp
    flyConn = RunService.RenderStepped:Connect(function()
        if not M.Fly then return end
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
        flyBodyVelocity.Velocity = moveDir * M.FlySpeed
        flyBodyGyro.CFrame = cam.CFrame
    end)
end

function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
end

-- ITEM ESP
task.spawn(function()
    while gui.Parent do
        task.wait(0.3)
        if M.ItemESP then
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
                                h.FillColor = M.ItemESPColor
                                h.OutlineColor = M.ItemESPColor
                                h.FillTransparency = 0.7
                                h.OutlineTransparency = 0.3
                                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                h.Parent = obj
                            end
                        end
                    end
                end
            end
        else
            for _, obj in ipairs(workspace:GetDescendants()) do
                local h = obj:FindFirstChild("RoooorItemHL")
                if h then h:Destroy() end
            end
        end
    end
end)

-- PLAYER LIST
local playerListGui = nil

function createPlayerList()
    if playerListGui then playerListGui:Destroy() end
    playerListGui = Instance.new("ScreenGui")
    playerListGui.Name = "RoooorPlayerList"
    playerListGui.ResetOnSpawn = false
    playerListGui.IgnoreGuiInset = true
    playerListGui.Parent = PG

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 300)
    frame.Position = UDim2.new(0, 15, 0.5, -150)
    frame.BackgroundColor3 = C.PANEL
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = playerListGui
    rnd(frame, 12)
    strk(frame, C.ACC, 1.5)

    local title2 = Instance.new("TextLabel")
    title2.Size = UDim2.new(1, -10, 0, 25)
    title2.Position = UDim2.new(0, 5, 0, 5)
    title2.BackgroundTransparency = 1
    title2.Text = "👥 PLAYER LIST"
    title2.TextColor3 = C.ACC4
    title2.TextSize = 12
    title2.Font = Enum.Font.GothamBlack
    title2.Parent = frame

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, -10, 1, -40)
    listFrame.Position = UDim2.new(0, 5, 0, 35)
    listFrame.BackgroundTransparency = 1
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 3
    listFrame.ScrollBarImageColor3 = C.ACC
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listFrame.Parent = frame

    local listL = Instance.new("UIListLayout")
    listL.Padding = UDim.new(0, 3)
    listL.Parent = listFrame

    task.spawn(function()
        while playerListGui and playerListGui.Parent do
            task.wait(1)
            if M.PlayerList then
                for _, c in pairs(listFrame:GetChildren()) do
                    if c:IsA("TextLabel") then c:Destroy() end
                end
                local root = getRoot()
                for _, p in pairs(Players:GetPlayers()) do
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, -5, 0, 20)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = p == LP and C.ACC4 or C.TXT
                    label.TextSize = 10
                    label.Font = Enum.Font.GothamMedium
                    label.TextXAlignment = Enum.TextXAlignment.Left
                    local team = p.Team and p.Team.Name or "None"
                    local dist = 0
                    if root and p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then dist = (hrp.Position - root.Position).Magnitude end
                    end
                    label.Text = string.format("%s [%s] %.0f", p.Name, team, dist)
                    label.Parent = listFrame
                end
            end
        end
    end)
end

-- Expose ke global
_G.Roooor_applyTrail = applyTrail
_G.Roooor_applyAura = applyAura
_G.Roooor_applyCrosshair = applyCrosshair
_G.Roooor_applyZoomOut = applyZoomOut
_G.Roooor_startFly = startFly
_G.Roooor_stopFly = stopFly
_G.Roooor_createPlayerList = createPlayerList

print("✅ [14/16] Fungsi Misc (Top 10) loaded")-- =========================================================
-- BAGIAN 15/16 : TAB MISC (SEMUA FITUR TAMBAHAN)
-- =========================================================

makeTab("Misc", "📦", 9, function()
    -- SURVIVOR
    sec("Auto Pallet Stun", "🪵")
    tog("Misc Auto Pallet", false, function(s) M.AutoPallet = s end)
    sl("Misc Pallet Range", 3, 20, 8, function(v) M.AutoPalletRange = v end)

    sec("Auto Vault Window", "🪟")
    tog("Misc Auto Vault", false, function(s) M.AutoVault = s end)
    sl("Misc Vault Range", 5, 25, 10, function(v) M.AutoVaultRange = v end)

    sec("Auto Heal", "💊")
    tog("Misc Auto Heal", false, function(s) M.AutoHeal = s end)
    sl("Misc Heal Threshold", 10, 100, 40, function(v) M.AutoHealThreshold = v end)

    sec("Auto Revive", "💀")
    tog("Misc Auto Revive", false, function(s) M.AutoRevive = s end)

    sec("Auto Repair Generator", "⚙️")
    tog("Misc Auto Repair", false, function(s) M.AutoRepair = s end)

    sec("Skill Perfect", "🎯")
    tog("Misc Skill Perfect", false, function(s) M.SkillPerfect = s end)

    sec("Safe Zone Finder", "🟢")
    tog("Misc Safe Zone", false, function(s) M.SafeZone = s end)

    sec("Escape Alert", "⚠️")
    tog("Misc Escape Alert", false, function(s) M.EscapeAlert = s end)
    sl("Misc Alert Range", 20, 200, 60, function(v) M.EscapeAlertRange = v end)

    -- VISUAL
    sec("═══ VISUAL ═══", "🎨")

    sec("Kill Effect", "💥")
    tog("Misc Kill Effect", false, function(s) M.KillEffect = s end)

    sec("Trail", "✨")
    tog("Misc Trail", false, function(s) M.Trail = s; applyTrail(s) end)
    cpk("Misc Trail Color", M.TrailColor, function(c) M.TrailColor = c; applyTrail(M.Trail) end)

    sec("Aura Effect", "🌟")
    tog("Misc Aura", false, function(s) M.Aura = s; applyAura(s) end)
    cpk("Misc Aura Color", M.AuraColor, function(c) M.AuraColor = c; applyAura(M.Aura) end)

    sec("RGB UI", "🌈")
    tog("Misc RGB UI", false, function(s) M.RGBUI = s end)

    sec("Crosshair", "➕")
    tog("Misc Crosshair", false, function(s) M.Crosshair = s; applyCrosshair(s) end)
    cpk("Misc Crosshair Color", M.CrosshairColor, function(c) M.CrosshairColor = c; applyCrosshair(M.Crosshair) end)
    sl("Misc Crosshair Size", 3, 30, 8, function(v) M.CrosshairSize = v; applyCrosshair(M.Crosshair) end)

    sec("Camera", "📷")
    tog("Misc No Clip Camera", false, function(s) M.NoClipCamera = s end)
    tog("Misc Zoom Out", false, function(s) M.ZoomOut = s; applyZoomOut() end)
    sl("Misc Zoom Distance", 100, 5000, 500, function(v) M.ZoomOutValue = v; applyZoomOut() end)

    -- ANTI
    sec("═══ ANTI / DEFENSE ═══", "🛡️")

    sec("Anti Stun", "⚡")
    tog("Misc Anti Stun", false, function(s) M.AntiStun = s end)

    sec("Anti Blind", "👁️")
    tog("Misc Anti Blind", false, function(s) M.AntiBlind = s end)

    sec("Anti Grab", "✋")
    tog("Misc Anti Grab", false, function(s) M.AntiGrab = s end)

    sec("Anti Hook", "🪝")
    tog("Misc Anti Hook", false, function(s) M.AntiHook = s end)

    sec("Anti Ragdoll", "🤸")
    tog("Misc Anti Ragdoll", false, function(s) M.AntiRagdoll = s end)

    sec("Anti Parry", "⚔️")
    tog("Misc Anti Parry", false, function(s) M.AntiParry = s end)

    sec("Anti AFK", "💤")
    tog("Misc Anti AFK", false, function(s) M.AntiAFK = s end)

    -- TOP 10
    sec("═══ TOP 10 BERGUNA ═══", "🏆")

    sec("Fly", "🕊️")
    tog("Misc Fly", false, function(s)
        M.Fly = s
        if s then startFly() else stopFly() end
    end)
    sl("Misc Fly Speed", 10, 200, 50, function(v) M.FlySpeed = v end)
    lbl("WASD + Space (naik) + LShift (turun)", C.ACC2)

    sec("Teleport", "🌀")
    tog("Misc TP to Player", false, function(s) M.TPtoPlayer = s end)
    lbl("Klik nama di Player List", C.DIM)

    sec("Item ESP", "📦")
    tog("Misc Item ESP", false, function(s) M.ItemESP = s end)
    cpk("Misc Item Color", M.ItemESPColor, function(c) M.ItemESPColor = c end)

    sec("Player List", "👥")
    tog("Misc Show Player List", false, function(s)
        M.PlayerList = s
        if s then createPlayerList()
        else
            if playerListGui then playerListGui:Destroy(); playerListGui = nil end
        end
    end)
end)

print("✅ [15/16] Tab Misc loaded")-- =========================================================
-- BAGIAN 16/16 : RESPAWN MISC + ANTI-RESET MISC + FINAL
-- =========================================================

-- RESPAWN RE-APPLY MISC
LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    if M.Trail then applyTrail(true) end
    if M.Aura then applyAura(true) end
    if M.Crosshair then applyCrosshair(true) end
    if M.ZoomOut then applyZoomOut() end
end)

-- ANTI-RESET MISC
task.spawn(function()
    while gui.Parent do
        task.wait(0.3)
        for name, state in pairs(_G.ToggleStates) do
            if name == "Misc Auto Pallet" then M.AutoPallet = state end
            if name == "Misc Auto Vault" then M.AutoVault = state end
            if name == "Misc Auto Heal" then M.AutoHeal = state end
            if name == "Misc Auto Revive" then M.AutoRevive = state end
            if name == "Misc Auto Repair" then M.AutoRepair = state end
            if name == "Misc Skill Perfect" then M.SkillPerfect = state end
            if name == "Misc Safe Zone" then M.SafeZone = state end
            if name == "Misc Escape Alert" then M.EscapeAlert = state end
            if name == "Misc Kill Effect" then M.KillEffect = state end
            if name == "Misc Trail" then M.Trail = state end
            if name == "Misc Aura" then M.Aura = state end
            if name == "Misc RGB UI" then M.RGBUI = state end
            if name == "Misc Crosshair" then M.Crosshair = state end
            if name == "Misc No Clip Camera" then M.NoClipCamera = state end
            if name == "Misc Zoom Out" then M.ZoomOut = state end
            if name == "Misc Anti Stun" then M.AntiStun = state end
            if name == "Misc Anti Blind" then M.AntiBlind = state end
            if name == "Misc Anti Grab" then M.AntiGrab = state end
            if name == "Misc Anti Hook" then M.AntiHook = state end
            if name == "Misc Anti Ragdoll" then M.AntiRagdoll = state end
            if name == "Misc Anti Parry" then M.AntiParry = state end
            if name == "Misc Anti AFK" then M.AntiAFK = state end
            if name == "Misc Fly" then
                if M.Fly ~= state then
                    M.Fly = state
                    if state then startFly() else stopFly() end
                end
            end
            if name == "Misc TP to Player" then M.TPtoPlayer = state end
            if name == "Misc Item ESP" then M.ItemESP = state end
            if name == "Misc Show Player List" then
                if M.PlayerList ~= state then
                    M.PlayerList = state
                    if state then createPlayerList()
                    else
                        if playerListGui then playerListGui:Destroy(); playerListGui = nil end
                    end
                end
            end
        end
        for name, val in pairs(_G.SliderStates) do
            if name == "Misc Pallet Range" then M.AutoPalletRange = val end
            if name == "Misc Vault Range" then M.AutoVaultRange = val end
            if name == "Misc Heal Threshold" then M.AutoHealThreshold = val end
            if name == "Misc Alert Range" then M.EscapeAlertRange = val end
            if name == "Misc Crosshair Size" then M.CrosshairSize = val end
            if name == "Misc Zoom Distance" then M.ZoomOutValue = val end
            if name == "Misc Fly Speed" then M.FlySpeed = val end
        end
    end
end)

-- =========================================================
-- FINAL PRINT
-- =========================================================
print("=====================================================")
print("✅ [16/16] ROOORHUB PREMIUM ULTIMATE + FALLENS + MISC")
print("🎉 FULL SUCCESS - ALL FEATURES LOADED!")
print("=====================================================")
print("📋 DAFTAR TAB:")
print("  1. 🔥 Fire        — 60 Efek")
print("  2. 👟 Fire Feet   — 20 Efek")
print("  3. 👁️ ESP         — Player + Gen(%) + Pallet + Window + SCP")
print("  4. 🏃 Survivor    — Parry + Skill + Aimlock 2 Mode")
print("  5. 🔪 Killer      — Auto Attack + Kill All + Hitbox + Masked")
print("  6. 🎨 Visual      — Fullbright + No Fog + FOV + 25 Sky")
print("  7. 🏃 Movement    — WalkSpeed + FastVault + Moonwalk FIX")
print("  8. ⚙️ Settings    — Info + Keybind")
print("  9. 📦 Misc        — Survivor+ + Visual+ + Anti + Top 10")
print("=====================================================")
print("⌨️ RightShift = Toggle Menu")
print("🖱️ Klik kanan 🎯 = Switch Aimlock Mode")
print("🖱️ Scroll sidebar = Lihat semua tab")
print("=====================================================")
print("✅ Anti-Reset System: AKTIF (fitur gak balik default)")
print("✅ Moonwalk Fix: LOBBY = INGAME")
print("✅ Korblox Auto-Reapply: AKTIF")
print("✅ Headless Auto-Reapply: AKTIF")
print("=====================================================")
