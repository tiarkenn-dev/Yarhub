-- =========================================================
-- ROOORHUB PREMIUM ULTIMATE + FALLENS + 8BIT SET
-- BAGIAN 1/15 : SERVICES + CONFIG + STATE
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
}

local S = _G.RoooorS

_G.ToggleStates = _G.ToggleStates or {}
_G.SliderStates = _G.SliderStates or {}

_G.RoooorExtra = _G.RoooorExtra or {
    AutoPallet = false, AutoPalletRange = 8,
    AutoVault = false, AutoVaultRange = 10,
    AutoHeal = false, AutoHealThreshold = 40,
    AutoRevive = false, AutoRepair = false, SkillPerfect = false,
    SafeZone = false, EscapeAlert = false, EscapeAlertRange = 60,
    KillEffect = false,
    Trail = false, TrailColor = Color3.fromRGB(180, 80, 255),
    Aura = false, AuraColor = Color3.fromRGB(180, 80, 255),
    RGBUI = false,
    Crosshair = false, CrosshairColor = Color3.fromRGB(0, 255, 200), CrosshairSize = 8,
    NoClipCamera = false,
    ZoomOut = false, ZoomOutValue = 500,
    AntiStun = false, AntiBlind = false, AntiGrab = false,
    AntiHook = false, AntiRagdoll = false, AntiParry = false,
    AntiKick = false, AntiAFK = false,
    Fly = false, FlySpeed = 50,
    TPtoPlayer = false,
    ItemESP = false, ItemESPColor = Color3.fromRGB(255, 255, 100),
    PlayerList = false,
    -- 8-Bit Set Visual
    EightBitSet = false,
    EightBitCrown = false,
    EightBitHP = false,
    EightBitCat = false,
}

local X = _G.RoooorExtra

print("✅ [1/15] Config loaded (Delta Executor) + 8Bit State")-- =========================================================
-- BAGIAN 2/15 : FIRE LIST + FIRE CONFIG
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

print("✅ [2/15] Fire Config loaded")-- =========================================================
-- BAGIAN 3/15 : FIRE FEET + SKY + HELPERS + KILLER ANIMS
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

print("✅ [3/15] Fire Feet + Sky + Helpers + KillerAnims loaded")-- =========================================================
-- BAGIAN 4/15 : GUI WINDOW + HEADER + SIDEBAR SCROLLING
-- =========================================================

local gui = Instance.new("ScreenGui")
gui.Name = "RoooorHubPremium"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PG

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
sb.ScrollBarThickness = 3
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

print("✅ [4/15] GUI Window + Sidebar Scrolling loaded")-- =========================================================
-- BAGIAN 5/15 : COMPONENTS
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

print("✅ [5/15] Components loaded")-- =========================================================
-- BAGIAN 6/15 : FIRE + FIRE FEET FUNCTIONS
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

LP.CharacterAdded:Connect(function()
    task.wait(1)
    if S.FireOn then applyFire() end
    if S.FireFeetOn then applyFireFeet() end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        if S.FireOn and LP.Character then
            local head = LP.Character:FindFirstChild("Head")
            if head then
                local fire = head:FindFirstChild("RoooorFire")
                if not fire then
                    applyFire()
                else
                    local cfg = FireConfig[S.FireType] or FireConfig.Classic
                    if cfg.rainbow then
                        local t = tick()
                        fire.Color = Color3.fromHSV((t * 0.5) % 1, 1, 1)
                        fire.SecondaryColor = Color3.fromHSV(((t * 0.5) + 0.5) % 1, 1, 1)
                    end
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

print("✅ [6/15] Fire + Fire Feet loaded")-- =========================================================
-- BAGIAN 7/15 : ESP SYSTEM (FALLENS VERSION)
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

_G.Roooor_UpdateGenerator = UpdateGenerator
_G.Roooor_UpdateMapESP = UpdateMapESP
_G.Roooor_UpdateSCPEsp = UpdateSCPEsp
_G.Roooor_createStatusESP = createStatusESP
_G.Roooor_Cached = Cached
_G.Roooor_StatusESP = StatusESP
_G.Roooor_createESP = createESP
_G.Roooor_removeESP = removeESP

print("✅ [7/15] ESP (Fallens) loaded")-- =========================================================
-- BAGIAN 8/15 : AUTO PARRY GACOR MODE (ANTI MISS v3)
-- =========================================================

local lastParry = 0
local PARRY_DEBOUNCE = 0.05
local ParryActive = false
local hookedKillers = _G.Roooor_HookedKillers or {}
_G.Roooor_HookedKillers = hookedKillers

local function getParryRange()
    return (S.ParryDist or 8) + 10
end

local function GetParryButton()
    local current = PG
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function pressRightClick()
    pcall(function()
        local btn = GetParryButton()
        local x, y = 0, 0
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition + btn.AbsoluteSize / 2
            local inset = GuiService:GetGuiInset()
            x = pos.X + inset.X
            y = pos.Y + inset.Y
        end
        VirtualInputManager:SendMouseButtonEvent(x, y, 1, true, game, 0)
        task.wait(0.005)
        VirtualInputManager:SendMouseButtonEvent(x, y, 1, false, game, 0)
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
                task.wait(0.003)
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
    pressParryButton()
    task.delay(0.08, function()
        ParryActive = false
    end)
end

local function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end

    local vel = enemyRoot.AssemblyLinearVelocity
    local predicted = enemyRoot.Position + vel * 0.15
    local distNow = (enemyRoot.Position - myRoot.Position).Magnitude
    local distPred = (predicted - myRoot.Position).Magnitude

    local r = getParryRange()
    return distNow <= r or distPred <= r
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
            task.wait(0.005)
            if not S.Parry then break end
            local myRoot = getRoot()
            local eRoot = char:FindFirstChild("HumanoidRootPart")
            if not myRoot or not eRoot then continue end

            local dist = (eRoot.Position - myRoot.Position).Magnitude
            if dist > getParryRange() + 5 then continue end

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
        task.wait(0.2)
        if S.Parry then scanKillers() end
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.5)
        if S.Parry and p.Team and p.Team.Name == "Killer" then
            hookKiller(p.Character)
        end
    end)
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
    local size = (S.ParryCircleSize or 15) * 2
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

-- AIMLOCK BUTTON
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

print("✅ [8/15] Auto Parry GACOR + Skill + Aimlock loaded")-- =========================================================
-- BAGIAN 9/15 : VISUAL + KORBLOX + HEADLESS + KILLER
-- =========================================================

local origLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows,
}

function applyFullbright(s)
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

local origFogEnd, origFogStart
origFogEnd = Lighting.FogEnd
origFogStart = Lighting.FogStart

function applyNoFog(s)
    if s then
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
    else
        Lighting.FogEnd = origFogEnd
        Lighting.FogStart = origFogStart
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
            end
        else
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

print("✅ [9/15] Visual + Korblox + Headless + Killer loaded")-- =========================================================
-- BAGIAN 10/15 : TAB FIRE + FIRE FEET
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

print("✅ [10/15] Tab Fire + Fire Feet loaded")-- =========================================================
-- BAGIAN 11/15 : TAB ESP + SURVIVOR + KILLER + VISUAL + MOVEMENT + SETTINGS
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
    tog("Show Aimlock Button", false, function(s)
        if s then createAimlockButton() else removeAimlockButton() end
    end)
    tog("🔒 Lock Aimlock Button", false, function(s) S.AimlockLocked = s end)
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
    drp("Select Power", {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}, "Cobra", function(v) S.MaskedPower = v end)
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
    btn("🚀 Instant Escape (TP Finish)", function() teleportToFinishLine() end)
    lbl("Teleport ke finish line/gate", C.ACC2)

    sec("Fast Vault", "🏃")
    tog("Enable Fast Vault", false, function(s) S.FastVault = s end)
    sl("Animation Speed", 1, 5, 1.5, function(v) S.FastVaultSpeed = v end)
end)

makeTab("Settings", "⚙️", 8, function()
    sec("Keybind", "⌨️")
    lbl("RightShift = Toggle Menu", C.ACC2)
    lbl("Klik ⚡ = Buka Menu", C.ACC2)
    lbl("Drag Header = Pindah Window", C.DIM)
    lbl("Drag 🎯 = Pindah Tombol", C.DIM)
    lbl("Klik kanan 🎯 = Switch Aimlock Mode", C.DIM)

    sec("Info", "ℹ️")
    lbl("RoooorHub Premium Ultimate + Fallens", C.ACC4)
    lbl("60 Fire + 20 Fire Feet + 25 Sky", C.ACC2)
    lbl("ESP + Parry GACOR v3 + Aimlock 2 Mode", C.ACC2)
    lbl("Killer + Visual + Movement + Anti", C.ACC2)
    lbl("8-Bit Crown + HP + Cat Set", C.ACC2)
    lbl("Made with 💜", C.ACC3)
end)

print("✅ [11/15] Tab UI utama loaded")-- =========================================================
-- BAGIAN 12/15 : MAIN LOOP + KEYBIND
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
        if not X.RGBUI then
            local hue = (tick() * 0.3) % 1
            mainStrk.Color = Color3.fromHSV(hue, 1, 1)
            mainStrk.Transparency = 0.4
        end
    end
end)

print("✅ [12/15] Main Loop + Keybind loaded")-- =========================================================
-- BAGIAN 13/15 : FITUR TAMBAHAN + 8-BIT SET
-- =========================================================

local remoteCache = {}
local function findRemote(keyword)
    if remoteCache[keyword] ~= nil then return remoteCache[keyword] end
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            if string.find(string.lower(obj.Name), string.lower(keyword)) then
                remoteCache[keyword] = obj
                return obj
            end
        end
    end
    remoteCache[keyword] = false
    return nil
end

local PalletRemote = findRemote("pallet") or findRemote("drop")
local HealRemote = findRemote("heal") or findRemote("medkit")
local ReviveRemote = findRemote("revive") or findRemote("rescue")
local RepairRemote = findRemote("repair") or findRemote("generator")

task.spawn(function()
    while gui.Parent do
        task.wait(0.15)
        if X.AutoPallet then
            local myRoot = getRoot()
            if myRoot then
                local killerNear = false
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                        local krp = p.Character:FindFirstChild("HumanoidRootPart")
                        if krp and (krp.Position - myRoot.Position).Magnitude <= X.AutoPalletRange then
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

task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if X.AutoHeal and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and hum.Health < X.AutoHealThreshold then
                if HealRemote then pcall(function() HealRemote:FireServer() end) end
            end
        end
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(1)
        if X.AutoRevive and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then
                if ReviveRemote then pcall(function() ReviveRemote:FireServer() end) end
            end
        end
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if X.AutoRepair and LP.Character then
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

task.spawn(function()
    while gui.Parent do
        task.wait(0.02)
        if X.SkillPerfect and LP.Character then
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

task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if X.SafeZone and LP.Character then
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

task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if X.EscapeAlert and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                        local krp = p.Character:FindFirstChild("HumanoidRootPart")
                        if krp and (krp.Position - myRoot.Position).Magnitude <= X.EscapeAlertRange then
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

local trailObj, auraObj = nil, nil

local function applyTrail(s)
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
    trailObj.Color = ColorSequence.new(X.TrailColor, X.TrailColor)
    trailObj.Lifetime = 0.5
    trailObj.Parent = hrp
end

local function applyAura(s)
    if auraObj then auraObj:Destroy(); auraObj = nil end
    if not s then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    auraObj = Instance.new("ParticleEmitter")
    auraObj.Texture = "rbxassetid://243660364"
    auraObj.Color = ColorSequence.new(X.AuraColor)
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
        if X.KillEffect then
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
        if X.RGBUI then
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
local function applyCrosshair(s)
    if crosshairGui then crosshairGui:Destroy(); crosshairGui = nil end
    if not s then return end
    crosshairGui = Instance.new("ScreenGui")
    crosshairGui.Name = "RoooorCrosshair"
    crosshairGui.ResetOnSpawn = false
    crosshairGui.IgnoreGuiInset = true
    crosshairGui.Parent = PG
    for i = 1, 4 do
        local ln = Instance.new("Frame")
        ln.BackgroundColor3 = X.CrosshairColor
        ln.BorderSizePixel = 0
        if i == 1 then
            ln.Size = UDim2.new(0, X.CrosshairSize, 0, 2)
            ln.Position = UDim2.new(0.5, -X.CrosshairSize - 3, 0.5, -1)
        elseif i == 2 then
            ln.Size = UDim2.new(0, X.CrosshairSize, 0, 2)
            ln.Position = UDim2.new(0.5, 3, 0.5, -1)
        elseif i == 3 then
            ln.Size = UDim2.new(0, 2, 0, X.CrosshairSize)
            ln.Position = UDim2.new(0.5, -1, 0.5, -X.CrosshairSize - 3)
        elseif i == 4 then
            ln.Size = UDim2.new(0, 2, 0, X.CrosshairSize)
            ln.Position = UDim2.new(0.5, -1, 0.5, 3)
        end
        ln.Parent = crosshairGui
    end
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 2, 0, 2)
    dot.Position = UDim2.new(0.5, -1, 0.5, -1)
    dot.BackgroundColor3 = X.CrosshairColor
    dot.BorderSizePixel = 0
    dot.Parent = crosshairGui
    rnd(dot, 1)
end

task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        local cam = workspace.CurrentCamera
        if cam then
            cam.CanCollide = not X.NoClipCamera
        end
    end
end)

local function applyZoomOut()
    if X.ZoomOut then
        LP.CameraMaxZoomDistance = X.ZoomOutValue
    else
        LP.CameraMaxZoomDistance = 128
    end
end

task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        if X.AntiStun and LP.Character then
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
        if X.AntiBlind then
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
        if X.AntiGrab and LP.Character then
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
        if X.AntiHook and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.AssemblyLinearVelocity.Magnitude > 200 then
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        if X.AntiRagdoll and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.PlatformStand then hum.PlatformStand = false end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(60)
        if X.AntiAFK then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end
    end
end)

local flyBodyVelocity, flyBodyGyro, flyConn = nil, nil, nil

local function startFly()
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
        flyBodyVelocity.Velocity = moveDir * X.FlySpeed
        flyBodyGyro.CFrame = cam.CFrame
    end)
end

local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
end

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
        else
            for _, obj in ipairs(workspace:GetDescendants()) do
                local h = obj:FindFirstChild("RoooorItemHL")
                if h then h:Destroy() end
            end
        end
    end
end)

local playerListGui = nil
local function createPlayerList()
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
            if X.PlayerList then
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

-- =========================================================
-- 8-BIT SET: CROWN + HP BAR + TABBY CAT + EFEK API
-- =========================================================

local function apply8BitCrown(enable)
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local old = head:FindFirstChild("Roooor8BitCrown")
    if old then old:Destroy() end
    if not enable then return end

    local crown = Instance.new("Part")
    crown.Name = "Roooor8BitCrown"
    crown.Size = Vector3.new(2, 1.5, 2)
    crown.CanCollide = false
    crown.Massless = true
    crown.Transparency = 0
    crown.Parent = head

    local crownMesh = Instance.new("SpecialMesh")
    crownMesh.MeshType = Enum.MeshType.FileMesh
    crownMesh.MeshId = "rbxassetid://10138606900"
    crownMesh.TextureId = "rbxassetid://10138606949"
    crownMesh.Scale = Vector3.new(1.5, 1.5, 1.5)
    crownMesh.Parent = crown

    local crownWeld = Instance.new("Weld")
    crownWeld.Part0 = head
    crownWeld.Part1 = crown
    crownWeld.C0 = CFrame.new(0, 1.2, 0)
    crownWeld.Parent = crown

    local emitter = Instance.new("ParticleEmitter")
    emitter.Name = "CrownFire"
    emitter.Texture = "rbxassetid://243660364"
    emitter.LightEmission = 0.5
    emitter.Size = NumberSequence.new(1.5)
    emitter.Lifetime = NumberRange.new(2.5)
    emitter.Rate = 15
    emitter.Speed = NumberRange.new(3)
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

local function apply8BitHP(enable)
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local old = head:FindFirstChild("Roooor8BitHP")
    if old then old:Destroy() end
    if not enable then return end

    local hpBar = Instance.new("Part")
    hpBar.Name = "Roooor8BitHP"
    hpBar.Size = Vector3.new(1.5, 1.5, 0.5)
    hpBar.CanCollide = false
    hpBar.Massless = true
    hpBar.Transparency = 0
    hpBar.Parent = head

    local hpMesh = Instance.new("SpecialMesh")
    hpMesh.MeshType = Enum.MeshType.FileMesh
    hpMesh.MeshId = "rbxassetid://10138542409"
    hpMesh.TextureId = "rbxassetid://10138542374"
    hpMesh.Scale = Vector3.new(1.2, 1.2, 1.2)
    hpMesh.Parent = hpBar

    local hpWeld = Instance.new("Weld")
    hpWeld.Part0 = head
    hpWeld.Part1 = hpBar
    hpWeld.C0 = CFrame.new(1.2, 1.0, 0)
    hpWeld.Parent = hpBar

    local heart = Instance.new("ParticleEmitter")
    heart.Texture = "rbxassetid://6023564503"
    heart.Rate = 5
    heart.Lifetime = NumberRange.new(1.5)
    heart.Speed = NumberRange.new(1)
    heart.Size = NumberSequence.new(0.5)
    heart.Color = ColorSequence.new(Color3.fromRGB(255, 50, 100))
    heart.Parent = hpBar
end

local function apply8BitCat(enable)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local old = char:FindFirstChild("Roooor8BitCat")
    if old then old:Destroy() end
    if not enable then return end

    local cat = Instance.new("Part")
    cat.Name = "Roooor8BitCat"
    cat.Size = Vector3.new(1.5, 1.5, 1.5)
    cat.CanCollide = false
    cat.Massless = true
    cat.Transparency = 0
    cat.Parent = char

    local catMesh = Instance.new("SpecialMesh")
    catMesh.MeshType = Enum.MeshType.FileMesh
    catMesh.MeshId = "rbxassetid://10159617728"
    catMesh.Scale = Vector3.new(1, 1, 1)
    catMesh.Parent = cat

    local catWeld = Instance.new("Weld")
    catWeld.Part0 = hrp
    catWeld.Part1 = cat
    catWeld.C0 = CFrame.new(1.2, 0.8, 0)
    catWeld.Parent = cat
end

local function apply8BitSet(enable)
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    for _, name in ipairs({"Roooor8BitCrown", "Roooor8BitHP"}) do
        local old = head:FindFirstChild(name)
        if old then old:Destroy() end
    end
    local oldCat = char:FindFirstChild("Roooor8BitCat")
    if oldCat then oldCat:Destroy() end

    if not enable then return end

    apply8BitCrown(true)
    apply8BitHP(true)
    apply8BitCat(true)
end

_G.Roooor_applyTrail = applyTrail
_G.Roooor_applyAura = applyAura
_G.Roooor_applyCrosshair = applyCrosshair
_G.Roooor_applyZoomOut = applyZoomOut
_G.Roooor_startFly = startFly
_G.Roooor_stopFly = stopFly
_G.Roooor_createPlayerList = createPlayerList
_G.Roooor_apply8BitCrown = apply8BitCrown
_G.Roooor_apply8BitHP = apply8BitHP
_G.Roooor_apply8BitCat = apply8BitCat
_G.Roooor_apply8BitSet = apply8BitSet

print("✅ [13/15] Fitur Tambahan + 8-Bit Set loaded")-- =========================================================
-- BAGIAN 14/15 : TAB UI BARU + 8-BIT SET UI
-- =========================================================

makeTab("Survivor+", "🏃", 9, function()
    sec("Auto Pallet Stun", "🪵")
    tog("Enable Auto Pallet", false, function(s) X.AutoPallet = s end)
    sl("Pallet Range", 3, 20, 8, function(v) X.AutoPalletRange = v end)

    sec("Auto Heal", "💊")
    tog("Enable Auto Heal", false, function(s) X.AutoHeal = s end)
    sl("Heal Threshold HP", 10, 100, 40, function(v) X.AutoHealThreshold = v end)

    sec("Auto Revive", "💀")
    tog("Enable Auto Revive", false, function(s) X.AutoRevive = s end)

    sec("Auto Repair Generator", "⚙️")
    tog("Enable Auto Repair", false, function(s) X.AutoRepair = s end)

    sec("Skill Check Perfect", "🎯")
    tog("Enable Perfect Skill", false, function(s) X.SkillPerfect = s end)

    sec("Safe Zone Finder", "🟢")
    tog("Enable Safe Zone", false, function(s) X.SafeZone = s end)

    sec("Escape Alert", "⚠️")
    tog("Enable Escape Alert", false, function(s) X.EscapeAlert = s end)
    sl("Alert Range", 20, 200, 60, function(v) X.EscapeAlertRange = v end)
end)

makeTab("Visual+", "🎨", 10, function()
    sec("Kill Effect", "💥")
    tog("Enable Kill Effect", false, function(s) X.KillEffect = s end)

    sec("Trail", "✨")
    tog("Enable Trail", false, function(s) X.Trail = s; _G.Roooor_applyTrail(s) end)
    cpk("Trail Color", X.TrailColor, function(c) X.TrailColor = c; _G.Roooor_applyTrail(X.Trail) end)

    sec("Aura Effect", "🌟")
    tog("Enable Aura", false, function(s) X.Aura = s; _G.Roooor_applyAura(s) end)
    cpk("Aura Color", X.AuraColor, function(c) X.AuraColor = c; _G.Roooor_applyAura(X.Aura) end)

    sec("RGB UI", "🌈")
    tog("Enable RGB UI", false, function(s) X.RGBUI = s end)

    sec("Custom Crosshair", "➕")
    tog("Enable Crosshair", false, function(s) X.Crosshair = s; _G.Roooor_applyCrosshair(s) end)
    cpk("Crosshair Color", X.CrosshairColor, function(c) X.CrosshairColor = c; _G.Roooor_applyCrosshair(X.Crosshair) end)
    sl("Crosshair Size", 3, 30, 8, function(v) X.CrosshairSize = v; _G.Roooor_applyCrosshair(X.Crosshair) end)

    sec("Camera", "📷")
    tog("No Clip Camera", false, function(s) X.NoClipCamera = s end)
    tog("Zoom Out (Unlimited)", false, function(s) X.ZoomOut = s; _G.Roooor_applyZoomOut() end)
    sl("Zoom Distance", 100, 5000, 500, function(v) X.ZoomOutValue = v; _G.Roooor_applyZoomOut() end)

    sec("8-Bit Set (3 in 1)", "👑")
    tog("👑 8-Bit Royal Crown (+ Efek Api)", false, function(s)
        X.EightBitCrown = s
        _G.Roooor_apply8BitCrown(s)
    end)
    tog("❤️ 8-Bit HP Bar (+ Partikel Hati)", false, function(s)
        X.EightBitHP = s
        _G.Roooor_apply8BitHP(s)
    end)
    tog("🐱 8-Bit Tabby Cat", false, function(s)
        X.EightBitCat = s
        _G.Roooor_apply8BitCat(s)
    end)
    btn("🎁 PASANG SEMUA (3 in 1)", function()
        X.EightBitSet = true
        X.EightBitCrown = true
        X.EightBitHP = true
        X.EightBitCat = true
        _G.Roooor_apply8BitSet(true)
        _G.ToggleStates["👑 8-Bit Royal Crown (+ Efek Api)"] = true
        _G.ToggleStates["❤️ 8-Bit HP Bar (+ Partikel Hati)"] = true
        _G.ToggleStates["🐱 8-Bit Tabby Cat"] = true
    end)
    btn("❌ LEPAS SEMUA", function()
        X.EightBitSet = false
        X.EightBitCrown = false
        X.EightBitHP = false
        X.EightBitCat = false
        _G.Roooor_apply8BitSet(false)
        _G.ToggleStates["👑 8-Bit Royal Crown (+ Efek Api)"] = false
        _G.ToggleStates["❤️ 8-Bit HP Bar (+ Partikel Hati)"] = false
        _G.ToggleStates["🐱 8-Bit Tabby Cat"] = false
    end)
    lbl("Efek api mahkota + hati HP bar", C.GRN)
    lbl("Auto re-apply saat respawn", C.ACC2)
end)

makeTab("Anti", "🛡️", 11, function()
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

    sec("Anti Parry (Killer)", "⚔️")
    tog("Enable Anti Parry", false, function(s) X.AntiParry = s end)

    sec("Anti Kick", "🚫")
    tog("Enable Anti Kick", false, function(s) X.AntiKick = s end)

    sec("Anti AFK", "💤")
    tog("Enable Anti AFK", false, function(s) X.AntiAFK = s end)
end)

makeTab("Top 10", "🏆", 12, function()
    sec("Fly", "🕊️")
    tog("Enable Fly", false, function(s)
        X.Fly = s
        if s then _G.Roooor_startFly() else _G.Roooor_stopFly() end
    end)
    sl("Fly Speed", 10, 200, 50, function(v) X.FlySpeed = v end)
    lbl("WASD + Space (naik) + LShift (turun)", C.ACC2)

    sec("Teleport", "🌀")
    tog("Enable TP to Player", false, function(s) X.TPtoPlayer = s end)
    lbl("Klik nama player di Player List", C.DIM)

    sec("Item ESP", "📦")
    tog("Enable Item ESP", false, function(s) X.ItemESP = s end)
    cpk("Item Color", X.ItemESPColor, function(c) X.ItemESPColor = c end)

    sec("Player List", "👥")
    tog("Show Player List", false, function(s)
        X.PlayerList = s
        if s then _G.Roooor_createPlayerList()
        else
            local plg = PG:FindFirstChild("RoooorPlayerList")
            if plg then plg:Destroy() end
        end
    end)
end)

print("✅ [14/15] Tab UI baru + 8-Bit Set UI loaded")-- =========================================================
-- BAGIAN 15/15 : RESPAWN RE-APPLY + ANTI-RESET + FINAL PRINT
-- =========================================================

-- RESPAWN RE-APPLY FITUR BARU
LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    if X.Trail then _G.Roooor_applyTrail(true) end
    if X.Aura then _G.Roooor_applyAura(true) end
    if X.Crosshair then _G.Roooor_applyCrosshair(true) end
    if X.ZoomOut then _G.Roooor_applyZoomOut() end
    -- 8-Bit Set Re-Apply
    if X.EightBitCrown then task.wait(0.3); _G.Roooor_apply8BitCrown(true) end
    if X.EightBitHP then task.wait(0.3); _G.Roooor_apply8BitHP(true) end
    if X.EightBitCat then task.wait(0.3); _G.Roooor_apply8BitCat(true) end
end)

-- ANTI-RESET FITUR BARU
task.spawn(function()
    while gui.Parent do
        task.wait(0.3)
        for name, state in pairs(_G.ToggleStates) do
            if name == "Enable Auto Pallet" then X.AutoPallet = state end
            if name == "Enable Auto Heal" then X.AutoHeal = state end
            if name == "Enable Auto Revive" then X.AutoRevive = state end
            if name == "Enable Auto Repair" then X.AutoRepair = state end
            if name == "Enable Perfect Skill" then X.SkillPerfect = state end
            if name == "Enable Safe Zone" then X.SafeZone = state end
            if name == "Enable Escape Alert" then X.EscapeAlert = state end
            if name == "Enable Kill Effect" then X.KillEffect = state end
            if name == "Enable Trail" then X.Trail = state end
            if name == "Enable Aura" then X.Aura = state end
            if name == "Enable RGB UI" then X.RGBUI = state end
            if name == "Enable Crosshair" then X.Crosshair = state end
            if name == "No Clip Camera" then X.NoClipCamera = state end
            if name == "Zoom Out (Unlimited)" then X.ZoomOut = state end
            if name == "Enable Anti Stun" then X.AntiStun = state end
            if name == "Enable Anti Blind" then X.AntiBlind = state end
            if name == "Enable Anti Grab" then X.AntiGrab = state end
            if name == "Enable Anti Hook" then X.AntiHook = state end
            if name == "Enable Anti Ragdoll" then X.AntiRagdoll = state end
            if name == "Enable Anti Parry" then X.AntiParry = state end
            if name == "Enable Anti Kick" then X.AntiKick = state end
            if name == "Enable Anti AFK" then X.AntiAFK = state end
            if name == "Enable Fly" then
                if X.Fly ~= state then
                    X.Fly = state
                    if state then _G.Roooor_startFly() else _G.Roooor_stopFly() end
                end
            end
            if name == "Enable TP to Player" then X.TPtoPlayer = state end
            if name == "Enable Item ESP" then X.ItemESP = state end
            if name == "Show Player List" then
                if X.PlayerList ~= state then
                    X.PlayerList = state
                    if state then _G.Roooor_createPlayerList()
                    else
                        local plg = PG:FindFirstChild("RoooorPlayerList")
                        if plg then plg:Destroy() end
                    end
                end
            end
            -- 8-Bit Set Anti-Reset
            if name == "👑 8-Bit Royal Crown (+ Efek Api)" then
                if X.EightBitCrown ~= state then
                    X.EightBitCrown = state
                    _G.Roooor_apply8BitCrown(state)
                end
            end
            if name == "❤️ 8-Bit HP Bar (+ Partikel Hati)" then
                if X.EightBitHP ~= state then
                    X.EightBitHP = state
                    _G.Roooor_apply8BitHP(state)
                end
            end
            if name == "🐱 8-Bit Tabby Cat" then
                if X.EightBitCat ~= state then
                    X.EightBitCat = state
                    _G.Roooor_apply8BitCat(state)
                end
            end
        end
        for name, val in pairs(_G.SliderStates) do
            if name == "Pallet Range" then X.AutoPalletRange = val end
            if name == "Heal Threshold HP" then X.AutoHealThreshold = val end
            if name == "Alert Range" then X.EscapeAlertRange = val end
            if name == "Crosshair Size" then X.CrosshairSize = val end
            if name == "Zoom Distance" then X.ZoomOutValue = val end
            if name == "Fly Speed" then X.FlySpeed = val end
        end
    end
end)

-- =========================================================
-- FINAL PRINT
-- =========================================================
print("=====================================================")
print("✅ [15/15] ROOORHUB PREMIUM ULTIMATE + FALLENS + 8BIT")
print("🎉 FULL SUCCESS - ALL FEATURES LOADED!")
print("=====================================================")
print("📋 DAFTAR TAB:")
print("  1. 🔥 Fire          — 60 Efek")
print("  2. 👟 Fire Feet     — 20 Efek")
print("  3. 👁️ ESP           — Player + Gen(%) + Pallet + Window + SCP")
print("  4. 🏃 Survivor      — Parry GACOR v3 + Skill + Aimlock 2 Mode")
print("  5. 🔪 Killer        — Auto Attack + Kill All + Hitbox + Masked")
print("  6. 🎨 Visual        — Fullbright + No Fog + FOV + 25 Sky")
print("  7. 🏃 Movement      — WalkSpeed + FastVault")
print("  8. ⚙️ Settings      — Info + Keybind")
print("  9. 🏃 Survivor+     — Auto Pallet/Heal/Revive/Repair")
print(" 10. 🎨 Visual+       — Kill Effect + Trail + Aura + RGB + 8BIT SET")
print(" 11. 🛡️ Anti          — Stun + Blind + Grab + Hook + Ragdoll + AFK")
print(" 12. 🏆 Top 10        — Fly + TP + Item ESP + Player List")
print("=====================================================")
print("⌨️ RightShift = Toggle Menu")
print("🖱️ Klik kanan 🎯 = Switch Aimlock Mode")
print("=====================================================")
print("⚔️ Auto Parry GACOR v3: AKTIF")
print("   • Debounce 0.05s (super responsif)")
print("   • Prediksi gerak killer 0.15s")
print("   • Range +10 buffer (anti miss)")
print("   • Polling 0.005s")
print("=====================================================")
print("👑 8-BIT SET: Crown + HP Bar + Tabby Cat")
print("   • Efek api mahkota berwarna")
print("   • Partikel hati di HP bar")
print("   • Auto re-apply saat respawn")
print("   • 3 in 1 tombol PASANG SEMUA")
print("=====================================================")
print("🌙 Moonwalk: DIHAPUS TOTAL")
print("=====================================================")-- =========================================================
-- TAB BARU: 8-BIT SET (KHUSUS)
-- =========================================================

makeTab("8-Bit", "👑", 13, function()
    sec("8-Bit Royal Crown", "👑")
    tog("👑 Enable 8-Bit Crown", false, function(s)
        X.EightBitCrown = s
        if _G.Roooor_apply8BitCrown then
            _G.Roooor_apply8BitCrown(s)
        else
            warn("[8Bit] Fungsi apply8BitCrown gak ada!")
        end
    end)
    lbl("Mahkota pixel + efek api warna-warni", C.ACC2)
    lbl("Biru → Hijau → Kuning → Merah", C.GRN)

    sec("8-Bit HP Bar", "❤️")
    tog("❤️ Enable 8-Bit HP Bar", false, function(s)
        X.EightBitHP = s
        if _G.Roooor_apply8BitHP then
            _G.Roooor_apply8BitHP(s)
        else
            warn("[8Bit] Fungsi apply8BitHP gak ada!")
        end
    end)
    lbl("Bar HP pixel + partikel hati", C.ACC2)

    sec("8-Bit Tabby Cat", "🐱")
    tog("🐱 Enable 8-Bit Tabby Cat", false, function(s)
        X.EightBitCat = s
        if _G.Roooor_apply8BitCat then
            _G.Roooor_apply8BitCat(s)
        else
            warn("[8Bit] Fungsi apply8BitCat gak ada!")
        end
    end)
    lbl("Kucing pixel di bahu", C.ACC2)

    sec("QUICK ACTION", "⚡")
    btn("🎁 PASANG SEMUA (3 in 1)", function()
        X.EightBitSet = true
        X.EightBitCrown = true
        X.EightBitHP = true
        X.EightBitCat = true
        if _G.Roooor_apply8BitSet then
            _G.Roooor_apply8BitSet(true)
        end
        _G.ToggleStates["👑 Enable 8-Bit Crown"] = true
        _G.ToggleStates["❤️ Enable 8-Bit HP Bar"] = true
        _G.ToggleStates["🐱 Enable 8-Bit Tabby Cat"] = true
        print("[8Bit] Semua dipasang!")
    end)
    btn("❌ LEPAS SEMUA", function()
        X.EightBitSet = false
        X.EightBitCrown = false
        X.EightBitHP = false
        X.EightBitCat = false
        if _G.Roooor_apply8BitSet then
            _G.Roooor_apply8BitSet(false)
        end
        _G.ToggleStates["👑 Enable 8-Bit Crown"] = false
        _G.ToggleStates["❤️ Enable 8-Bit HP Bar"] = false
        _G.ToggleStates["🐱 Enable 8-Bit Tabby Cat"] = false
        print("[8Bit] Semua dilepas!")
    end)
    btn("🔄 Refresh / Re-apply", function()
        if _G.Roooor_apply8BitSet then
            _G.Roooor_apply8BitSet(false)
            task.wait(0.2)
            _G.Roooor_apply8BitSet(X.EightBitSet)
        end
    end)

    sec("INFO", "ℹ️")
    lbl("Tab ini khusus buat 8-Bit Set", C.ACC4)
    lbl("Kalau Crown/HP blank = mesh limited", C.DIM)
    lbl("Coba pakai UGC alternatif kalau blank", C.ACC2)
end)

print("✅ [BONUS] Tab 8-Bit loaded!")-- 8-Bit Tab Baru
if name == "👑 Enable 8-Bit Crown" then
    if X.EightBitCrown ~= state then
        X.EightBitCrown = state
        if _G.Roooor_apply8BitCrown then _G.Roooor_apply8BitCrown(state) end
    end
end
if name == "❤️ Enable 8-Bit HP Bar" then
    if X.EightBitHP ~= state then
        X.EightBitHP = state
        if _G.Roooor_apply8BitHP then _G.Roooor_apply8BitHP(state) end
    end
end
if name == "🐱 Enable 8-Bit Tabby Cat" then
    if X.EightBitCat ~= state then
        X.EightBitCat = state
        if _G.Roooor_apply8BitCat then _G.Roooor_apply8BitCat(state) end
    end
end
