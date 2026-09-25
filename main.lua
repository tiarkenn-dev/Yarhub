-- =========================================================
-- COSMIC HUB — GALAXY EDITION v1
-- BAGIAN 1/8 : LOADING COSMIC + CONFIG + STATE (FIXED)
-- =========================================================

-- Reset state lama kalau re-inject
_G.CosmicS = nil
_G.CosmicToggle = nil
_G.CosmicSlider = nil
_G.CosmicHookKiller = nil

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

-- EXPOSE SERVICE (biar Bagian 8 bisa akses)
_G.Cosmic_LP = LP
_G.Cosmic_PG = PG
_G.Cosmic_UIS = UIS
_G.Cosmic_RunService = RunService
_G.Cosmic_TweenService = TweenService
_G.Cosmic_Lighting = Lighting
_G.Cosmic_ReplicatedStorage = ReplicatedStorage
_G.Cosmic_VIM = VirtualInputManager
_G.Cosmic_Stats = Stats
_G.Cosmic_GuiService = GuiService

-- =========================================================
-- GALAXY THEME COLOR
-- =========================================================
local C = {
    BG          = Color3.fromRGB(8, 6, 22),
    BG2         = Color3.fromRGB(14, 10, 35),
    PANEL       = Color3.fromRGB(18, 14, 42),
    PANEL2      = Color3.fromRGB(28, 20, 60),
    NEBULA      = Color3.fromRGB(120, 60, 220),
    NEBULA2     = Color3.fromRGB(80, 40, 180),
    STAR        = Color3.fromRGB(200, 220, 255),
    STAR_BRIGHT = Color3.fromRGB(240, 250, 255),
    COSMIC      = Color3.fromRGB(160, 80, 255),
    COSMIC2     = Color3.fromRGB(0, 200, 255),
    COSMIC3     = Color3.fromRGB(255, 80, 200),
    AURORA      = Color3.fromRGB(0, 255, 200),
    GOLD        = Color3.fromRGB(255, 215, 100),
    TXT         = Color3.fromRGB(235, 235, 255),
    DIM         = Color3.fromRGB(130, 130, 170),
    GRN         = Color3.fromRGB(0, 255, 150),
    RED         = Color3.fromRGB(255, 80, 120),
}

-- EXPOSE warna (biar Bagian lain bisa akses)
_G.Cosmic_C = C

-- Helper
local function rnd(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = o
end

local function strk(o, col, t, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or C.COSMIC
    s.Thickness = t or 1.5
    s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = o
    return s
end

-- EXPOSE helper (biar Bagian lain bisa akses)
_G.Cosmic_rnd = rnd
_G.Cosmic_strk = strk

-- =========================================================
-- LOADING COSMIC 4D (GALAXY STYLE)
-- =========================================================
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "CosmicLoading"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 999999
loadingGui.Parent = PG

-- Background
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 8)
bg.BorderSizePixel = 0
bg.Parent = loadingGui

local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 5, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 10, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 5, 30)),
})
bgGrad.Rotation = 0
bgGrad.Parent = bg

task.spawn(function()
    while bg.Parent do
        for i = 0, 360, 2 do
            if not bg.Parent then break end
            bgGrad.Rotation = i
            task.wait(0.03)
        end
    end
end)

-- Bintang jatuh
for i = 1, 40 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
    p.Position = UDim2.new(math.random(), 0, 1.1, 0)
    p.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
    p.BorderSizePixel = 0
    p.Parent = bg
    rnd(p, 999)

    task.spawn(function()
        while p.Parent do
            local speed = math.random(6, 15) / 1000
            p.Position = UDim2.new(p.Position.X.Scale - speed, 0, p.Position.Y.Scale - speed, 0)
            p.BackgroundTransparency = p.BackgroundTransparency + 0.008
            if p.BackgroundTransparency >= 1 or p.Position.Y.Scale < -0.1 then
                p.Position = UDim2.new(math.random(), 0, 1.1, 0)
                p.BackgroundTransparency = 0
            end
            task.wait(0.05)
        end
    end)
end

-- Ring nebula
local ringContainer = Instance.new("Frame")
ringContainer.Size = UDim2.new(0, 260, 0, 260)
ringContainer.Position = UDim2.new(0.5, -130, 0.5, -190)
ringContainer.BackgroundTransparency = 1
ringContainer.Parent = bg

local rings = {}
for i = 1, 5 do
    local ring = Instance.new("Frame")
    local ringSize = 220 - (i-1) * 40
    ring.Size = UDim2.new(0, ringSize, 0, ringSize)
    ring.Position = UDim2.new(0.5, -ringSize/2, 0.5, -ringSize/2)
    ring.BackgroundTransparency = 1
    ring.Parent = ringContainer

    local rStrk = Instance.new("UIStroke")
    rStrk.Thickness = 3.5 - (i-1) * 0.4
    rStrk.Color = C.COSMIC
    rStrk.Transparency = 0.05 + (i-1) * 0.1
    rStrk.Parent = ring

    local rGrad = Instance.new("UIGradient")
    rGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.COSMIC3),
        ColorSequenceKeypoint.new(0.33, C.COSMIC2),
        ColorSequenceKeypoint.new(0.66, C.COSMIC),
        ColorSequenceKeypoint.new(1, C.COSMIC3),
    })
    rGrad.Parent = rStrk

    table.insert(rings, {ring = ring, grad = rGrad, speed = 30 + i * 20, dir = i % 2 == 0 and -1 or 1})
end

-- Core planet
local core = Instance.new("Frame")
core.Size = UDim2.new(0, 90, 0, 90)
core.Position = UDim2.new(0.5, -45, 0.5, -45)
core.BackgroundColor3 = C.COSMIC
core.Parent = ringContainer
rnd(core, 999)
local coreGrad = Instance.new("UIGradient")
coreGrad.Color = ColorSequence.new(C.COSMIC3, C.COSMIC2, C.COSMIC)
coreGrad.Rotation = 45
coreGrad.Parent = core

local coreIcon = Instance.new("TextLabel")
coreIcon.Size = UDim2.new(1, 0, 1, 0)
coreIcon.BackgroundTransparency = 1
coreIcon.Text = "🌌"
coreIcon.TextSize = 48
coreIcon.Font = Enum.Font.GothamBlack
coreIcon.Parent = core

-- Text
local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Size = UDim2.new(1, 0, 0, 70)
welcomeTitle.Position = UDim2.new(0, 0, 0.32, 0)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.Text = "COSMIC HUB"
welcomeTitle.TextColor3 = Color3.new(1, 1, 1)
welcomeTitle.TextSize = 52
welcomeTitle.Font = Enum.Font.GothamBlack
welcomeTitle.TextStrokeTransparency = 0
welcomeTitle.TextStrokeColor3 = C.COSMIC3
welcomeTitle.Parent = bg
local welcomeGrad = Instance.new("UIGradient")
welcomeGrad.Color = ColorSequence.new(C.COSMIC2, C.STAR_BRIGHT, C.COSMIC)
welcomeGrad.Parent = welcomeTitle

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 100)
subtitle.Position = UDim2.new(0, 0, 0.53, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "GALAXY EDITION"
subtitle.TextColor3 = C.COSMIC2
subtitle.TextSize = 60
subtitle.Font = Enum.Font.GothamBlack
subtitle.TextStrokeTransparency = 0
subtitle.TextStrokeColor3 = C.COSMIC3
subtitle.Parent = bg
local subGrad = Instance.new("UIGradient")
subGrad.Color = ColorSequence.new(C.COSMIC2, C.STAR_BRIGHT, C.COSMIC)
subGrad.Parent = subtitle

local tagline = Instance.new("TextLabel")
tagline.Size = UDim2.new(1, 0, 0, 30)
tagline.Position = UDim2.new(0, 0, 0.73, 20)
tagline.BackgroundTransparency = 1
tagline.Text = "✨ VIOLENCE DISTRICT ✨"
tagline.TextColor3 = C.COSMIC
tagline.TextSize = 16
tagline.Font = Enum.Font.GothamBold
tagline.TextStrokeTransparency = 0.3
tagline.TextStrokeColor3 = C.COSMIC3
tagline.Parent = bg

-- Progress bar
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 420, 0, 6)
progressBar.Position = UDim2.new(0.5, -210, 0.9, 20)
progressBar.BackgroundColor3 = Color3.fromRGB(20, 15, 50)
progressBar.BorderSizePixel = 0
progressBar.Parent = bg
rnd(progressBar, 3)
strk(progressBar, C.COSMIC, 1.5, 0.3)

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = C.COSMIC2
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBar
rnd(progressFill, 3)
local fillGrad = Instance.new("UIGradient")
fillGrad.Color = ColorSequence.new(C.COSMIC3, C.COSMIC2, C.COSMIC)
fillGrad.Parent = progressFill

-- Animasi
task.spawn(function()
    local t = 0
    while bg.Parent do
        t = t + 0.025
        for _, data in ipairs(rings) do
            data.ring.Rotation = t * data.speed * data.dir
            data.grad.Rotation = t * 90 * data.dir
        end
        local pulse = 1 + math.sin(t * 4) * 0.15
        core.Size = UDim2.new(0, 90 * pulse, 0, 90 * pulse)
        core.Position = UDim2.new(0.5, -45 * pulse, 0.5, -45 * pulse)
        core.Rotation = t * 50
        welcomeTitle.TextSize = 52 + math.sin(t * 3) * 3
        subtitle.TextSize = 60 + math.sin(t * 3 + 0.5) * 4
        welcomeGrad.Rotation = math.sin(t) * 45
        subGrad.Rotation = math.sin(t * 1.5) * 45
        fillGrad.Rotation = t * 60
        task.wait(0.025)
    end
end)

task.spawn(function()
    for i = 0, 1, 0.015 do
        if not bg.Parent then break end
        progressFill.Size = UDim2.new(i, 0, 1, 0)
        task.wait(0.04)
    end
end)

-- Fade out (loading selesai)
task.delay(2.5, function()
    TweenService:Create(bg, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    for _, el in pairs(bg:GetDescendants()) do
        pcall(function()
            if el:IsA("TextLabel") then
                TweenService:Create(el, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
            elseif el:IsA("Frame") then
                TweenService:Create(el, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
            elseif el:IsA("UIStroke") then
                TweenService:Create(el, TweenInfo.new(0.6), {Transparency = 1}):Play()
            end
        end)
    end
    task.wait(0.6)
    loadingGui:Destroy()
end)

-- =========================================================
-- STATE (EXPOSE GLOBAL)
-- =========================================================
_G.CosmicS = {
    -- Fire
    FireOn = false, FireType = "Classic", FireSize = 5,
    FireFeetOn = false, FireFeetType = "Classic",
    -- Parry
    Parry = false, ParryDistance = 15,
    ParryCooldown = 0.2,
    FaceSensitivity = 0.7,
    ParryPredict = 0,
    ParryRangeVisual = true,
    ParryRangeColor = Color3.fromRGB(160, 80, 255),
    -- Skill Check
    SkillCheck = false, SkillCheckPerfect = false, SkillCheckSafeZone = 0.15,
    -- Crown
    EightBitCrown = false, EightBitSize = 1,
    CrownX = 0, CrownY = 1.2, CrownZ = 0,
    -- Trail / Aura
    Trail = false, TrailColor = Color3.fromRGB(160, 80, 255),
    Aura = false, AuraColor = Color3.fromRGB(160, 80, 255),
    KillEffect = false,
    -- Crosshair
    Crosshair = false, CrosshairStyle = "Plus",
    CrosshairColor = Color3.fromRGB(160, 220, 255),
    CrosshairSize = 8, CrosshairThick = 2,
    CrosshairX = 0, CrosshairY = 0,
    -- Movement
    WalkSpeed = false, WalkSpeedVal = 17.6,
    JumpPower = false, JumpPowerVal = 50,
    NoClip = false, Fly = false, FlySpeed = 50,
    -- Visual
    Fullbright = false, FullbrightVal = 50,
    NoFog = false, SkyId = "Default",
    FOVEnabled = false, FOV = 70,
    ZoomOut = false, ZoomOutValue = 500,
    -- HD Graphics
    Bloom = false, BloomIntensity = 0.6, BloomSize = 24, BloomThreshold = 0.9,
    SunRays = false, SunRaysIntensity = 0.15, SunRaysSpread = 1,
    DOF = false, DOFFocus = 0.5, DOFNear = 0.1, DOFFar = 1,
    Sharpen = false, SharpenAmount = 0.5,
    Cinematic = false,
    Atmosphere = false, AtmosphereDensity = 0.3,
    -- Misc
    FastVault = false, FastVaultSpeed = 1.2,
    Moonwalk = false, MoonwalkSpam = 30, MoonwalkIntensity = 35,
    -- Killer
    Killer_AutoAtk = false, Killer_AtkDelay = 0.35,
    Killer_KillAll = false,
    Killer_Hitbox = false, Killer_HitboxSize = 15,
    MaskedPower = "Cobra",
    -- Camera
    NoClipCamera = false,
    -- FPS Panel
    ShowFPS = true, FPSPos = "TopLeft",
}

_G.CosmicToggle = {}
_G.CosmicSlider = {}

_G.CosmicESP = {
    Survivor = false, Killer = false,
    Generator = false, Pallet = false,
    Window = false, SCP = false,
    Distance = 500,
}

_G.CosmicESPStatus = {
    Enabled = false,
    ShowName = true, ShowDistance = true,
    ShowHealth = false, Radius = 500,
}

_G.CosmicTeamColors = {
    Killer = Color3.fromRGB(255, 60, 60),
    Survivor = Color3.fromRGB(60, 255, 120),
}

_G.CosmicAimlock = {
    Enabled = false,
    Holding = false,
    Mode = "Killer",
    Strength = 0.35,
    Predict = 0.15,
    FOV = 300,
    Radius = 500,
    LockRadius = 100,
    AimPart = "HumanoidRootPart",
    ShowButton = false,
    AutoAttack = false,
}

_G.CosmicSkill = {
    Enabled = false,
    PerfectMode = false,
    SafeZone = 0.15,
}

_G.CosmicParry = {
    Enabled = false,
    Distance = 15,
    Debounce = 0.2,
    FaceSensitivity = 0.7,
    Predict = 0,
    RequireFacing = true,
}

print("✅ [1/8] Cosmic Loading + Config loaded (FIXED)")-- =========================================================
-- COSMIC HUB — BAGIAN 2/8 : FIRE CONFIG + SKY + KILLER ANIMS (FIXED)
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
    Classic       = { c1 = Color3.fromRGB(255, 120, 0),   c2 = Color3.fromRGB(255, 220, 80) },
    HellFire      = { c1 = Color3.fromRGB(180, 0, 0),     c2 = Color3.fromRGB(255, 80, 0),  smoke = true },
    IceFire       = { c1 = Color3.fromRGB(120, 200, 255), c2 = Color3.fromRGB(220, 240, 255), spark = true },
    ToxicFire     = { c1 = Color3.fromRGB(0, 255, 50),    c2 = Color3.fromRGB(180, 255, 0), smoke = true },
    VoidFire      = { c1 = Color3.fromRGB(100, 0, 180),   c2 = Color3.fromRGB(220, 50, 255), spark = true },
    GoldenKing    = { c1 = Color3.fromRGB(255, 215, 0),   c2 = Color3.fromRGB(255, 255, 120), spark = true },
    SakuraFire    = { c1 = Color3.fromRGB(255, 150, 200), c2 = Color3.fromRGB(255, 220, 240), spark = true },
    EmeraldFire   = { c1 = Color3.fromRGB(0, 220, 100),   c2 = Color3.fromRGB(120, 255, 170) },
    BloodFire     = { c1 = Color3.fromRGB(220, 0, 0),     c2 = Color3.fromRGB(120, 0, 0),    smoke = true },
    ShadowFire    = { c1 = Color3.fromRGB(30, 30, 40),    c2 = Color3.fromRGB(100, 0, 130),  smoke = true },
    HolyFire      = { c1 = Color3.fromRGB(255, 255, 255), c2 = Color3.fromRGB(255, 255, 220), spark = true },
    OceanFire     = { c1 = Color3.fromRGB(0, 120, 255),   c2 = Color3.fromRGB(120, 220, 255) },
    Firework      = { c1 = Color3.fromRGB(255, 0, 120),   c2 = Color3.fromRGB(255, 220, 50), rainbow = true, spark = true },
    Lava          = { c1 = Color3.fromRGB(255, 100, 0),   c2 = Color3.fromRGB(120, 30, 0),   smoke = true },
    GhostFire     = { c1 = Color3.fromRGB(200, 200, 255), c2 = Color3.fromRGB(255, 255, 255) },
    CosmicFire    = { c1 = Color3.fromRGB(80, 0, 150),    c2 = Color3.fromRGB(255, 120, 220), rainbow = true },
    DragonFire    = { c1 = Color3.fromRGB(255, 80, 0),    c2 = Color3.fromRGB(255, 220, 50), smoke = true },
    MysteryFire   = { c1 = Color3.fromRGB(255, 0, 0),     c2 = Color3.fromRGB(0, 255, 255),  rainbow = true },
    RainbowFire   = { c1 = Color3.fromRGB(255, 0, 0),     c2 = Color3.fromRGB(0, 255, 255),  rainbow = true, spark = true },
    LightningFire = { c1 = Color3.fromRGB(120, 220, 255), c2 = Color3.fromRGB(255, 255, 255), spark = true },
    GalaxyFire    = { c1 = Color3.fromRGB(100, 0, 220),   c2 = Color3.fromRGB(255, 200, 255), rainbow = true, spark = true },
    NebulaFire    = { c1 = Color3.fromRGB(220, 80, 255),  c2 = Color3.fromRGB(80, 220, 255),  rainbow = true, spark = true },
    AuroraFire    = { c1 = Color3.fromRGB(0, 255, 200),   c2 = Color3.fromRGB(120, 255, 120), rainbow = true, spark = true },
    PhoenixFire   = { c1 = Color3.fromRGB(255, 180, 0),   c2 = Color3.fromRGB(255, 80, 0),    smoke = true },
    DemonFire     = { c1 = Color3.fromRGB(255, 0, 0),     c2 = Color3.fromRGB(0, 0, 0),       smoke = true },
    AngelFire     = { c1 = Color3.fromRGB(255, 255, 220), c2 = Color3.fromRGB(255, 240, 255), spark = true },
    CrystalFire   = { c1 = Color3.fromRGB(220, 255, 255), c2 = Color3.fromRGB(220, 220, 255), spark = true },
    NeonFire      = { c1 = Color3.fromRGB(0, 255, 120),   c2 = Color3.fromRGB(255, 0, 220),   rainbow = true },
    PlasmaFire    = { c1 = Color3.fromRGB(180, 0, 255),   c2 = Color3.fromRGB(0, 220, 255),   spark = true },
    QuantumFire   = { c1 = Color3.fromRGB(0, 120, 255),   c2 = Color3.fromRGB(255, 0, 120),   rainbow = true },
    LegendaryFire = { c1 = Color3.fromRGB(255, 215, 0),   c2 = Color3.fromRGB(255, 120, 0),   spark = true },
    MythicFire    = { c1 = Color3.fromRGB(220, 0, 255),   c2 = Color3.fromRGB(255, 220, 0),   rainbow = true },
    DivineFire    = { c1 = Color3.fromRGB(255, 255, 255), c2 = Color3.fromRGB(255, 220, 120), spark = true },
    CursedFire    = { c1 = Color3.fromRGB(100, 0, 0),     c2 = Color3.fromRGB(220, 0, 220),   smoke = true },
    AncientFire   = { c1 = Color3.fromRGB(220, 180, 0),   c2 = Color3.fromRGB(120, 60, 0),    smoke = true },
    EternalFire   = { c1 = Color3.fromRGB(255, 120, 220), c2 = Color3.fromRGB(120, 220, 255), rainbow = true },
    InfernoFire   = { c1 = Color3.fromRGB(255, 40, 0),    c2 = Color3.fromRGB(255, 220, 0),   smoke = true },
    BifrostFire   = { c1 = Color3.fromRGB(255, 120, 220), c2 = Color3.fromRGB(120, 255, 220), rainbow = true },
    ChaosFire     = { c1 = Color3.fromRGB(255, 0, 0),     c2 = Color3.fromRGB(0, 0, 255),     rainbow = true },
    OmegaFire     = { c1 = Color3.fromRGB(255, 215, 0),   c2 = Color3.fromRGB(255, 0, 255),   rainbow = true },
    SolarFire     = { c1 = Color3.fromRGB(255, 180, 0),   c2 = Color3.fromRGB(255, 255, 120), spark = true },
    LunarFire     = { c1 = Color3.fromRGB(220, 220, 255), c2 = Color3.fromRGB(120, 170, 255), spark = true },
    EclipseFire   = { c1 = Color3.fromRGB(80, 0, 120),    c2 = Color3.fromRGB(255, 180, 0),   spark = true },
    SolarFlare    = { c1 = Color3.fromRGB(255, 120, 0),   c2 = Color3.fromRGB(255, 255, 220), spark = true },
    VoidStorm     = { c1 = Color3.fromRGB(80, 0, 120),    c2 = Color3.fromRGB(220, 0, 255),   rainbow = true, spark = true },
    StarFire      = { c1 = Color3.fromRGB(255, 255, 220), c2 = Color3.fromRGB(255, 220, 120), spark = true },
    SupernovaFire = { c1 = Color3.fromRGB(255, 220, 0),   c2 = Color3.fromRGB(255, 0, 220),   rainbow = true, spark = true },
    BlackHoleFire = { c1 = Color3.fromRGB(0, 0, 0),       c2 = Color3.fromRGB(120, 0, 180),   smoke = true },
    MeteorFire    = { c1 = Color3.fromRGB(255, 100, 0),   c2 = Color3.fromRGB(220, 40, 0),    smoke = true },
    CometFire     = { c1 = Color3.fromRGB(120, 220, 255), c2 = Color3.fromRGB(220, 255, 255), spark = true },
    FrostFire     = { c1 = Color3.fromRGB(220, 240, 255), c2 = Color3.fromRGB(120, 200, 255), spark = true },
    BlizzardFire  = { c1 = Color3.fromRGB(240, 250, 255), c2 = Color3.fromRGB(170, 220, 255), spark = true, smoke = true },
    ThunderFire   = { c1 = Color3.fromRGB(255, 255, 120), c2 = Color3.fromRGB(120, 120, 255), spark = true },
    StormFire     = { c1 = Color3.fromRGB(100, 100, 180), c2 = Color3.fromRGB(220, 220, 255), spark = true, smoke = true },
    TornadoFire   = { c1 = Color3.fromRGB(180, 180, 220), c2 = Color3.fromRGB(100, 100, 150), spark = true, smoke = true },
    SoulFire      = { c1 = Color3.fromRGB(0, 255, 220),   c2 = Color3.fromRGB(180, 255, 255), spark = true },
    SpiritFire    = { c1 = Color3.fromRGB(220, 255, 255), c2 = Color3.fromRGB(180, 220, 255), spark = true },
    PhantomFire   = { c1 = Color3.fromRGB(120, 0, 180),   c2 = Color3.fromRGB(80, 0, 120),    smoke = true },
    WraithFire    = { c1 = Color3.fromRGB(50, 0, 80),     c2 = Color3.fromRGB(180, 0, 220),   smoke = true },
    ReaperFire    = { c1 = Color3.fromRGB(0, 0, 0),       c2 = Color3.fromRGB(255, 0, 0),     smoke = true },
}

for _, name in ipairs(FireList) do
    if not FireConfig[name] then FireConfig[name] = FireConfig.Classic end
end

-- =========================================================
-- FIRE FEET
-- =========================================================
local FireFeetList = {
    "Classic", "Blue", "Green", "Purple", "Rainbow",
    "Golden", "Pink", "Cyan", "RedFire", "Ice",
    "Toxic", "Electric", "Blood", "Ghost", "Cosmic",
    "Dragon", "Divine", "Demon", "Shadow", "Phoenix"
}

local FireFeetConfig = {
    Classic  = { c1 = Color3.fromRGB(255, 120, 0),   c2 = Color3.fromRGB(255, 220, 80) },
    Blue     = { c1 = Color3.fromRGB(0, 170, 255),   c2 = Color3.fromRGB(0, 255, 255) },
    Green    = { c1 = Color3.fromRGB(0, 255, 50),    c2 = Color3.fromRGB(180, 255, 0) },
    Purple   = { c1 = Color3.fromRGB(180, 0, 255),   c2 = Color3.fromRGB(255, 0, 220) },
    Rainbow  = { c1 = Color3.fromRGB(255, 0, 0),     c2 = Color3.fromRGB(0, 255, 255), rainbow = true },
    Golden   = { c1 = Color3.fromRGB(255, 215, 0),   c2 = Color3.fromRGB(255, 255, 120) },
    Pink     = { c1 = Color3.fromRGB(255, 120, 220), c2 = Color3.fromRGB(255, 200, 240) },
    Cyan     = { c1 = Color3.fromRGB(0, 255, 255),   c2 = Color3.fromRGB(120, 255, 255) },
    RedFire  = { c1 = Color3.fromRGB(255, 40, 0),    c2 = Color3.fromRGB(255, 120, 0) },
    Ice      = { c1 = Color3.fromRGB(220, 240, 255), c2 = Color3.fromRGB(120, 200, 255) },
    Toxic    = { c1 = Color3.fromRGB(0, 255, 120),   c2 = Color3.fromRGB(120, 255, 0) },
    Electric = { c1 = Color3.fromRGB(255, 255, 120), c2 = Color3.fromRGB(120, 120, 255) },
    Blood    = { c1 = Color3.fromRGB(220, 0, 0),     c2 = Color3.fromRGB(120, 0, 0) },
    Ghost    = { c1 = Color3.fromRGB(220, 220, 255), c2 = Color3.fromRGB(255, 255, 255) },
    Cosmic   = { c1 = Color3.fromRGB(100, 0, 220),   c2 = Color3.fromRGB(255, 220, 255), rainbow = true },
    Dragon   = { c1 = Color3.fromRGB(255, 80, 0),    c2 = Color3.fromRGB(255, 220, 0) },
    Divine   = { c1 = Color3.fromRGB(255, 255, 255), c2 = Color3.fromRGB(255, 255, 220) },
    Demon    = { c1 = Color3.fromRGB(255, 0, 0),     c2 = Color3.fromRGB(0, 0, 0) },
    Shadow   = { c1 = Color3.fromRGB(30, 30, 40),    c2 = Color3.fromRGB(100, 0, 130) },
    Phoenix  = { c1 = Color3.fromRGB(255, 180, 0),   c2 = Color3.fromRGB(255, 80, 0) },
}

for _, name in ipairs(FireFeetList) do
    if not FireFeetConfig[name] then FireFeetConfig[name] = FireFeetConfig.Classic end
end

-- =========================================================
-- SKY CONFIG
-- =========================================================
local SkyList = {
    "Default", "Galaxy", "Nebula", "Cosmic", "Sunset",
    "Night", "Space", "Aurora",
}

local SkyIds = {
    Galaxy = {
        Bk = "rbxassetid://126146408999925", Dn = "rbxassetid://118112392224589",
        Ft = "rbxassetid://121253817183621", Lf = "rbxassetid://138429250948648",
        Rt = "rbxassetid://126146408999925", Up = "rbxassetid://126146408999925"
    },
    Nebula = {
        Bk = "rbxassetid://17817511804", Dn = "rbxassetid://17817520184",
        Ft = "rbxassetid://17817511804", Lf = "rbxassetid://17817511804",
        Rt = "rbxassetid://17817511804", Up = "rbxassetid://17817511804"
    },
    Cosmic = {
        Bk = "rbxassetid://17817511804", Dn = "rbxassetid://17817520184",
        Ft = "rbxassetid://17817511804", Lf = "rbxassetid://17817511804",
        Rt = "rbxassetid://17817511804", Up = "rbxassetid://17817511804"
    },
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
    Aurora = {
        Bk = "rbxassetid://10253172001", Dn = "rbxassetid://10253172001",
        Ft = "rbxassetid://10253172001", Lf = "rbxassetid://10253172001",
        Rt = "rbxassetid://10253172001", Up = "rbxassetid://10253172001"
    },
}

-- =========================================================
-- KILLER ANIMS
-- =========================================================
local KillerAnims = {}
for _, id in ipairs({
    "105374834496520","113255068724446","118907603246885","129784271201071",
    "117042998468241","122812055447896","78935059863801","74968262036854",
    "78432063483146","132817836308238","133963973694098","111920872708571",
    "80411309607666","98163597193511","82666958311998","110355011987939",
    "139369275981133","135002183282873","121216847022485","130593238885843",
    "117070354890871","106871536134254","138720291317243"
}) do KillerAnims["rbxassetid://"..id] = true end

local STUN_ANIM = "rbxassetid://123047897844134"
local PARRY_ANIM = "rbxassetid://127096285501517"
local BREAK_PALLET_ANIM = "rbxassetid://112166042383605"

-- EXPOSE GLOBAL (biar Bagian 3-8 bisa akses)
_G.Cosmic_FireList = FireList
_G.Cosmic_FireConfig = FireConfig
_G.Cosmic_FireFeetList = FireFeetList
_G.Cosmic_FireFeetConfig = FireFeetConfig
_G.Cosmic_SkyList = SkyList
_G.Cosmic_SkyIds = SkyIds
_G.Cosmic_KillerAnims = KillerAnims
_G.Cosmic_STUN_ANIM = STUN_ANIM
_G.Cosmic_PARRY_ANIM = PARRY_ANIM
_G.Cosmic_BREAK_PALLET_ANIM = BREAK_PALLET_ANIM

-- Helper getRoot (expose ke global)
function _G.Cosmic_getRoot()
    local c = _G.Cosmic_LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

print("✅ [2/8] Fire + Sky + KillerAnims loaded (FIXED)")-- =========================================================
-- COSMIC HUB — BAGIAN 3/8 : FUNGSI + PARRY + SKILLCHECK + ESP (FIXED)
-- =========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

local LP = _G.Cosmic_LP
local PG = _G.Cosmic_PG
local C = _G.Cosmic_C

local S = _G.CosmicS
local FireConfig = _G.Cosmic_FireConfig
local FireFeetConfig = _G.Cosmic_FireFeetConfig
local KillerAnims = _G.Cosmic_KillerAnims
local PARRY_ANIM = _G.Cosmic_PARRY_ANIM
local BREAK_PALLET_ANIM = _G.Cosmic_BREAK_PALLET_ANIM
local STUN_ANIM = _G.Cosmic_STUN_ANIM

local function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ============================
-- FIRE (KEPALA)
-- ============================
local function clearFire()
    if not LP.Character then return end
    local head = LP.Character:FindFirstChild("Head")
    if not head then return end
    for _, obj in pairs(head:GetChildren()) do
        if obj.Name == "CosmicFire" or obj.Name == "CosmicSmoke" or obj.Name == "CosmicSparkles" then
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
    fire.Name = "CosmicFire"
    fire.Size = S.FireSize
    fire.Heat = 15
    fire.Color = cfg.c1
    fire.SecondaryColor = cfg.c2
    fire.Parent = head

    if cfg.smoke then
        local smoke = Instance.new("Smoke")
        smoke.Name = "CosmicSmoke"
        smoke.Size = S.FireSize + 2
        smoke.RiseVelocity = 3
        smoke.Opacity = 0.4
        smoke.Color = cfg.c2
        smoke.Parent = head
    end
    if cfg.spark then
        local spark = Instance.new("Sparkles")
        spark.Name = "CosmicSparkles"
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
                if obj.Name == "CosmicFootFire" then obj:Destroy() end
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
            fire.Name = "CosmicFootFire"
            fire.Size = 4
            fire.Heat = 10
            fire.Color = cfg.c1
            fire.SecondaryColor = cfg.c2
            fire.Parent = leg
        end
    end
end

task.spawn(function()
    while task.wait(0.2) do
        if S.FireOn and LP.Character then
            local head = LP.Character:FindFirstChild("Head")
            local fire = head and head:FindFirstChild("CosmicFire")
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
                        local fire = leg:FindFirstChild("CosmicFootFire")
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
-- 8-BIT CROWN
-- ============================
local function apply8BitCrown(enable, size, posX, posY, posZ)
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("Cosmic8BitCrown")
    if old then old:Destroy() end
    if not enable then return end

    size = size or 1
    posX = posX or 0
    posY = posY or 1.2
    posZ = posZ or 0

    local crown = Instance.new("Part")
    crown.Name = "Cosmic8BitCrown"
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
    weld.C0 = CFrame.new(posX * size, posY * size, posZ * size)
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
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(160, 80, 255)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 122, 200)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 80, 200)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(120, 0, 220))
    })
    emitter.Parent = crown
end

-- =========================================================
-- ESP SYSTEM
-- =========================================================
local ESPObjects = {}
local StatusESP = {}
local CachedSCP = {}
local Cached = { Generators = {}, Windows = {}, Pallets = {} }

local GeneratorColor = Color3.fromRGB(255, 170, 0)
local PalletColor = Color3.fromRGB(74, 255, 181)
local WindowColor = Color3.fromRGB(74, 255, 181)
local SCPColor = Color3.fromRGB(255, 0, 0)

local ESP = _G.CosmicESP
local ESPStatus = _G.CosmicESPStatus
local TeamColors = _G.CosmicTeamColors

local function cacheObject(obj)
    if obj.Name == "Generator" then Cached.Generators[obj] = true
    elseif obj.Name == "Window" then Cached.Windows[obj] = true
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then Cached.Pallets[obj] = true end

    local name = string.lower(obj.Name)
    if string.find(name, "scp") then CachedSCP[obj] = true end
end

local function removeCache(obj)
    Cached.Generators[obj] = nil
    Cached.Windows[obj] = nil
    Cached.Pallets[obj] = nil
    CachedSCP[obj] = nil
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
end

for _, obj in ipairs(workspace:GetDescendants()) do cacheObject(obj) end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(removeCache)

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
    h.FillTransparency = 0.9
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = obj
    ESPObjects[obj] = h

    obj.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
        end
    end)
end

local function removeESP(obj)
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
end

local function removeStatusESP(char)
    if StatusESP[char] then StatusESP[char]:Destroy(); StatusESP[char] = nil end
end

local function createStatusESP(player, char, root)
    if not ESPStatus.Enabled then removeStatusESP(char); return end
    if not root then return end

    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    local isDown = hum.Health <= 0 or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true

    local dist = (head.Position - root.Position).Magnitude
    if dist > ESPStatus.Radius then removeStatusESP(char); return end

    local text = ""
    if isDown then text = text .. "🔻 DOWN\n" end
    if ESPStatus.ShowName then text = text .. player.Name .. "\n" end
    if ESPStatus.ShowDistance then text = text .. string.format("Dist: %.0f\n", dist) end
    if ESPStatus.ShowHealth then text = text .. string.format("HP: %.0f\n", hum.Health) end

    if text == "" then removeStatusESP(char); return end

    local billboard = StatusESP[char]
    local teamColor = Color3.new(1, 1, 1)
    if player.Team then
        if player.Team.Name == "Killer" then teamColor = TeamColors.Killer
        elseif player.Team.Name == "Survivors" then teamColor = TeamColors.Survivor end
    end
    if isDown then teamColor = Color3.fromRGB(255, 0, 0) end

    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 120, 0, 50)
        billboard.AlwaysOnTop = true

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = teamColor
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.Text = text
        label.Parent = billboard

        billboard.Adornee = head
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.Parent = char
        StatusESP[char] = billboard
    else
        local label = billboard:FindFirstChildOfClass("TextLabel")
        if label then
            label.Text = text
            label.TextColor3 = teamColor
        end
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

local function UpdateGenerator(generator)
    if not generator or not generator.Parent then return end

    if not ESP.Generator then
        local old = generator:FindFirstChild("CosmicGenESP")
        if old then old:Destroy() end
        local h = generator:FindFirstChild("CosmicGenHighlight")
        if h then h:Destroy() end
        return
    end

    local percent = GetGameValue(generator, "RepairProgress") or GetGameValue(generator, "Progress") or 0
    local billboard = generator:FindFirstChild("CosmicGenESP")

    if percent >= 100 then
        if billboard then billboard:Destroy() end
        return
    end

    local cp = math.clamp(percent, 0, 100)
    local color = GeneratorColor:Lerp(Color3.fromRGB(0, 255, 120), cp / 100)
    local text = string.format("[%.0f%%]", percent)

    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "CosmicGenESP"
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

        billboard.Adornee = generator
        billboard.Parent = generator
    else
        local lbl = billboard:FindFirstChildOfClass("TextLabel")
        if lbl then
            lbl.Text = text
            lbl.TextColor3 = color
        end
    end

    local h = generator:FindFirstChild("CosmicGenHighlight") or Instance.new("Highlight")
    h.Name = "CosmicGenHighlight"
    h.Adornee = generator
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.9
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = generator
end

local function UpdateMapESP(obj, root)
    if not obj or not root then return end
    local pos
    if obj:IsA("Model") then pos = obj:GetPivot().Position
    elseif obj:IsA("BasePart") then pos = obj.Position end
    if not pos then return end

    local distance = (pos - root.Position).Magnitude

    if obj.Name == "Window" then
        if ESP.Window and distance <= ESP.Distance then createESP(obj, WindowColor)
        else removeESP(obj) end
    end

    if obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        if ESP.Pallet and distance <= ESP.Distance then createESP(obj, PalletColor)
        else removeESP(obj) end
    end
end

local function UpdateSCPEsp(root)
    if not ESP.SCP then
        for obj in pairs(CachedSCP) do removeESP(obj) end
        return
    end

    for obj in pairs(CachedSCP) do
        if obj and obj.Parent then
            local pos
            if obj:IsA("Model") then pos = obj:GetPivot().Position
            elseif obj:IsA("BasePart") then pos = obj.Position end

            if pos then
                local dist = (pos - root.Position).Magnitude
                if dist <= ESP.Distance then createESP(obj, SCPColor)
                else removeESP(obj) end
            end
        end
    end
end

-- =========================================================
-- AUTO PARRY
-- =========================================================
local CosmicParry = _G.CosmicParry
local lastParry = 0
local hookedKillers = {}
_G.CosmicHookKiller = hookedKillers
local ParryActive = false
local ParryCircle = nil

local function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end

    local pos = enemyRoot.Position
    if CosmicParry.Predict and CosmicParry.Predict > 0 then
        pos = pos + (enemyRoot.AssemblyLinearVelocity * CosmicParry.Predict)
    end
    local dist = (pos - myRoot.Position).Magnitude
    return dist <= CosmicParry.Distance
end

local function isFacingTarget(targetChar)
    if not CosmicParry.RequireFacing then return true end
    if CosmicParry.FaceSensitivity <= -1 then return true end

    local myChar = LP.Character
    if not myChar then return false end

    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local enemyRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not enemyRoot then return false end

    local enemyForward = enemyRoot.CFrame.LookVector
    local directionToMe = (myRoot.Position - enemyRoot.Position).Unit
    local dot = enemyForward:Dot(directionToMe)
    return dot >= CosmicParry.FaceSensitivity
end

local function GetParryButton()
    local current = PG
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function pressRightClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
end

local function pressParryButton()
    if UIS.TouchEnabled then
        local btn = GetParryButton()
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = GuiService:GetGuiInset()
            local x = pos.X + size.X/2 + inset.X
            local y = pos.Y + size.Y/2 + inset.Y
            VirtualInputManager:SendTouchEvent(8823, 0, x, y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8823, 2, x, y)
        end
    else
        pressRightClick()
    end
end

local function doParry()
    local now = tick()
    if now - lastParry < CosmicParry.Debounce then return end
    lastParry = now

    ParryActive = true
    if S.Moonwalk then S.Moonwalk = false end

    pressParryButton()
    task.delay(0.3, function() ParryActive = false end)
end

local function hookKiller(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    animator.AnimationPlayed:Connect(function(track)
        if not CosmicParry.Enabled then return end
        local anim = track.Animation
        if not anim then return end

        local id = anim.AnimationId:match("%d+")
        if not id then return end
        local fullId = "rbxassetid://" .. id

        if KillerAnims[fullId] then
            if not isInParryRange(char) then return end
            if not isFacingTarget(char) then return end
            doParry()
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

task.spawn(function()
    while task.wait(0.8) do
        if CosmicParry.Enabled then scanKillers() end
    end
end)

local function updateParryCircle()
    local root = getRoot()
    if not CosmicParry.Enabled or not S.ParryRangeVisual or not root then
        if ParryCircle then ParryCircle:Destroy(); ParryCircle = nil end
        return
    end
    if not ParryCircle then
        ParryCircle = Instance.new("Part")
        ParryCircle.Shape = Enum.PartType.Cylinder
        ParryCircle.Anchored = true
        ParryCircle.CanCollide = false
        ParryCircle.Material = Enum.Material.Neon
        ParryCircle.Name = "CosmicParryCircle"
        ParryCircle.Parent = workspace
    end
    local size = CosmicParry.Distance * 2
    ParryCircle.Size = Vector3.new(0.2, size, size)
    local yOffset = root.Size.Y / 2 + 1.5
    ParryCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0)) * CFrame.Angles(0, 0, math.rad(90))
    ParryCircle.Color = S.ParryRangeColor or C.COSMIC
    ParryCircle.Transparency = 0.5
end

RunService.RenderStepped:Connect(function()
    if CosmicParry.Enabled and S.ParryRangeVisual then updateParryCircle() end
end)

-- =========================================================
-- AUTO SKILL CHECK
-- =========================================================
local CosmicSkill = _G.CosmicSkill
local skillBusy = false
local ActionPath = "Survivor-mob.Controls.action.check"

local function GetActionButton()
    local current = PG
    for segment in string.gmatch(ActionPath, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function triggerSkillCheck()
    if skillBusy then return end
    skillBusy = true

    pcall(function()
        if UIS.TouchEnabled then
            local b = GetActionButton()
            if b and b:IsA("GuiObject") then
                local p, s, i = b.AbsolutePosition, b.AbsoluteSize, GuiService:GetGuiInset()
                local cx = p.X + s.X/2 + i.X
                local cy = p.Y + s.Y/2 + i.Y
                VirtualInputManager:SendTouchEvent(8822, 0, cx, cy)
                task.wait(0.01)
                VirtualInputManager:SendTouchEvent(8822, 2, cx, cy)
            end
        else
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.01)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end
    end)

    task.wait(0.05)
    skillBusy = false
end

RunService.RenderStepped:Connect(function()
    if not CosmicSkill.Enabled then return end
    if skillBusy then return end

    local prompt = PG:FindFirstChild("SkillCheckPromptGui")
    if not prompt then return end

    local check = prompt:FindFirstChild("Check")
    if not check or not check.Visible then return end

    local line = check:FindFirstChild("Line")
    local goal = check:FindFirstChild("Goal")
    if not line or not goal then return end

    local lr = line.Rotation % 360
    local gr = goal.Rotation % 360

    local startZone = (gr + 102) % 360
    local endZone = (gr + 116) % 360

    local success = false
    if startZone > endZone then
        success = (lr >= startZone or lr <= endZone)
    else
        success = (lr >= startZone and lr <= endZone)
    end

    if success then
        triggerSkillCheck()
    end
end)

task.spawn(function()
    while task.wait(0.005) do
        if not CosmicSkill.Enabled then continue end
        if not CosmicSkill.PerfectMode then continue end

        local prompt = PG:FindFirstChild("SkillCheckPromptGui")
        if not prompt then continue end
        local check = prompt:FindFirstChild("Check")
        if not check or not check.Visible then continue end

        local line = check:FindFirstChild("Line")
        local goal = check:FindFirstChild("Goal")
        if not line or not goal then continue end

        pcall(function()
            line.Rotation = goal.Rotation + 108
        end)
    end
end)

-- =========================================================
-- TELEPORT
-- =========================================================
local function teleportToFinishLine()
    local root = getRoot()
    if not root then return end
    local found = nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.lower(obj.Name) == "fininshline" then
            found = obj
            break
        end
    end
    if found then root.CFrame = found.CFrame + Vector3.new(0, 5, 0)
    else warn("[CosmicHub] Finish gak ketemu") end
end

local function teleportToGate()
    local root = getRoot()
    if not root then return end
    local found = nil
    local names = {"gate", "exitgate", "escapegate", "exit_gate", "escape_gate", "finish", "finishline"}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local lname = string.lower(obj.Name)
            for _, search in ipairs(names) do
                if string.find(lname, search) then found = obj; break end
            end
            if found then break end
        end
    end
    if not found then warn("[CosmicHub] Gate gak ketemu"); return end
    root.CFrame = found.CFrame + Vector3.new(0, 5, 0) + found.CFrame.LookVector * 5
end

local function teleportInsideGate()
    local root = getRoot()
    if not root then return end
    local found = nil
    local names = {"inside", "room", "chamber", "safe", "gate", "escapegate", "exitgate"}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local lname = string.lower(obj.Name)
            for _, search in ipairs(names) do
                if string.find(lname, search) then found = obj; break end
            end
            if found then break end
        end
    end
    if not found then warn("[CosmicHub] Inside Gate gak ketemu"); return end
    root.CFrame = CFrame.new(found.Position + Vector3.new(0, 3, 0))
end

-- =========================================================
-- VISUAL FUNCTIONS
-- =========================================================
local origLighting = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
}

local function applyFullbright(s)
    if s then
        local bright = math.clamp((S.FullbrightVal or 50) / 100, 0, 1)
        Lighting.Brightness = 0.5 + bright * 2
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(bright, bright, bright)
        Lighting.OutdoorAmbient = Color3.new(bright, bright, bright)
        Lighting.GlobalShadows = S.FullbrightVal < 80
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
    if skyName and skyName ~= "Default" and _G.Cosmic_SkyIds[skyName] then
        local ids = _G.Cosmic_SkyIds[skyName]
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

local function applyZoomOut(enable, val)
    if enable then LP.CameraMaxZoomDistance = val or 500
    else LP.CameraMaxZoomDistance = 128 end
end

-- =========================================================
-- HD GRAPHICS
-- =========================================================
local hdEffects = {}

local function ensureEffect(name, class)
    if hdEffects[name] and hdEffects[name].Parent then return hdEffects[name] end
    local e = Instance.new(class)
    e.Name = "Cosmic_" .. name
    e.Parent = Lighting
    hdEffects[name] = e
    return e
end

local function applyHD()
    if S.Bloom then
        local b = ensureEffect("Bloom", "BloomEffect")
        b.Enabled = true
        b.Intensity = S.BloomIntensity
        b.Size = S.BloomSize
        b.Threshold = S.BloomThreshold
    else
        if hdEffects.Bloom then hdEffects.Bloom:Destroy(); hdEffects.Bloom = nil end
    end

    if S.SunRays then
        local sr = ensureEffect("SunRays", "SunRaysEffect")
        sr.Enabled = true
        sr.Intensity = S.SunRaysIntensity
        sr.Spread = S.SunRaysSpread
    else
        if hdEffects.SunRays then hdEffects.SunRays:Destroy(); hdEffects.SunRays = nil end
    end

    if S.DOF then
        local d = ensureEffect("DOF", "DepthOfFieldEffect")
        d.Enabled = true
        d.FocusDistance = S.DOFFocus
        d.NearIntensity = S.DOFNear
        d.FarIntensity = S.DOFFar
    else
        if hdEffects.DOF then hdEffects.DOF:Destroy(); hdEffects.DOF = nil end
    end

    if S.Sharpen then
        local cc = ensureEffect("Sharpen", "ColorCorrectionEffect")
        cc.Enabled = true
        cc.Contrast = S.SharpenAmount
        cc.Saturation = 0.05
    else
        if hdEffects.Sharpen then hdEffects.Sharpen:Destroy(); hdEffects.Sharpen = nil end
    end

    if S.Cinematic then
        local cc = ensureEffect("Cinematic", "ColorCorrectionEffect")
        cc.Enabled = true
        cc.Contrast = 0.15
        cc.Saturation = -0.1
        cc.TintColor = Color3.fromRGB(255, 240, 220)
    else
        if hdEffects.Cinematic then hdEffects.Cinematic:Destroy(); hdEffects.Cinematic = nil end
    end

    if S.Atmosphere then
        if not hdEffects.Atmosphere or not hdEffects.Atmosphere.Parent then
            local atm = Instance.new("Atmosphere")
            atm.Name = "Cosmic_Atmosphere"
            atm.Density = S.AtmosphereDensity
            atm.Offset = 0.25
            atm.Color = Color3.fromRGB(200, 180, 255)
            atm.Decay = Color3.fromRGB(120, 100, 200)
            atm.Glare = 0.3
            atm.Haze = 1.5
            atm.Parent = Lighting
            hdEffects.Atmosphere = atm
        else
            hdEffects.Atmosphere.Density = S.AtmosphereDensity
        end
    else
        if hdEffects.Atmosphere then hdEffects.Atmosphere:Destroy(); hdEffects.Atmosphere = nil end
    end
end

_G.Cosmic_hdEffects = hdEffects

-- =========================================================
-- NO CLIP
-- =========================================================
task.spawn(function()
    while task.wait(0.2) do
        if S.NoClip and LP.Character then
            for _, v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end
end)

-- =========================================================
-- EXPOSE SEMUA KE GLOBAL
-- =========================================================
_G.Cosmic_applyFire = applyFire
_G.Cosmic_applyFireFeet = applyFireFeet
_G.Cosmic_apply8BitCrown = apply8BitCrown
_G.Cosmic_createESP = createESP
_G.Cosmic_removeESP = removeESP
_G.Cosmic_createStatusESP = createStatusESP
_G.Cosmic_UpdateGenerator = UpdateGenerator
_G.Cosmic_UpdateMapESP = UpdateMapESP
_G.Cosmic_UpdateSCPEsp = UpdateSCPEsp
_G.Cosmic_scanKillers = scanKillers
_G.Cosmic_applyFullbright = applyFullbright
_G.Cosmic_applyNoFog = applyNoFog
_G.Cosmic_applySky = applySky
_G.Cosmic_applyFOV = applyFOV
_G.Cosmic_applyZoomOut = applyZoomOut
_G.Cosmic_applyHD = applyHD
_G.Cosmic_teleportToFinishLine = teleportToFinishLine
_G.Cosmic_teleportToGate = teleportToGate
_G.Cosmic_teleportInsideGate = teleportInsideGate

print("✅ [3/8] Fungsi + Parry + Skill Check + ESP + HD loaded (FIXED)")-- =========================================================
-- COSMIC HUB — BAGIAN 4/8 : LOOP UTAMA + KILLER + AIMLOCK + FPS (FIXED)
-- =========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")

local LP = _G.Cosmic_LP
local PG = _G.Cosmic_PG
local C = _G.Cosmic_C

local S = _G.CosmicS
local ESP = _G.CosmicESP
local ESPStatus = _G.CosmicESPStatus
local TeamColors = _G.CosmicTeamColors
local CosmicParry = _G.CosmicParry
local CosmicSkill = _G.CosmicSkill
local CosmicAimlock = _G.CosmicAimlock

local function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- =========================================================
-- WALKSPEED + JUMPPOWER
-- =========================================================
local function shouldDisableWalkSpeed()
    local char = LP.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local anim = track.Animation
                if anim and anim.AnimationId then
                    if anim.AnimationId == _G.Cosmic_PARRY_ANIM then return true end
                    if anim.AnimationId == _G.Cosmic_BREAK_PALLET_ANIM then return true end
                    if anim.AnimationId == _G.Cosmic_STUN_ANIM then return true end
                    local id = anim.AnimationId:match("%d+")
                    if id and _G.Cosmic_KillerAnims["rbxassetid://"..id] then
                        return true
                    end
                end
            end
        end
    end

    if hum and (
        hum.Health <= 0
        or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true
    ) then
        return true
    end

    return false
end

task.spawn(function()
    while task.wait(0.2) do
        if S.WalkSpeed and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and not shouldDisableWalkSpeed() then
                if hum.WalkSpeed ~= S.WalkSpeedVal then
                    hum.WalkSpeed = S.WalkSpeedVal
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if S.JumpPower and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.UseJumpPower ~= true then
                    hum.UseJumpPower = true
                end
                if hum.JumpPower ~= S.JumpPowerVal then
                    hum.JumpPower = S.JumpPowerVal
                end
            end
        end
    end
end)

-- =========================================================
-- FLY
-- =========================================================
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
        if not S.Fly then return end
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

        flyBV.Velocity = moveDir * S.FlySpeed
        flyBG.CFrame = cam.CFrame
    end)
end

local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
end

_G.Cosmic_startFly = startFly
_G.Cosmic_stopFly = stopFly

-- =========================================================
-- TRAIL / AURA / KILL EFFECT
-- =========================================================
local trailFireObj = nil
local function applyTrail(enable, color)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if trailFireObj then trailFireObj:Destroy(); trailFireObj = nil end
    if not enable then return end

    trailFireObj = Instance.new("Part")
    trailFireObj.Name = "CosmicTrailFire"
    trailFireObj.Size = Vector3.new(1, 1, 1)
    trailFireObj.Transparency = 1
    trailFireObj.CanCollide = false
    trailFireObj.Massless = true
    trailFireObj.Parent = char

    local weld = Instance.new("Weld")
    weld.Part0 = hrp
    weld.Part1 = trailFireObj
    weld.C0 = CFrame.new(0, -2, 2)
    weld.Parent = trailFireObj

    local fire = Instance.new("Fire")
    fire.Size = 8
    fire.Heat = 20
    fire.Color = color or C.COSMIC
    fire.SecondaryColor = C.COSMIC2
    fire.Parent = trailFireObj

    local smoke = Instance.new("Smoke")
    smoke.Size = 6
    smoke.RiseVelocity = 5
    smoke.Opacity = 0.5
    smoke.Color = Color3.fromRGB(80, 60, 120)
    smoke.Parent = trailFireObj

    local spark = Instance.new("Sparkles")
    spark.SparkleColor = color or C.COSMIC2
    spark.SparkleSize = 2
    spark.Parent = trailFireObj
end

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
    auraObj.Color = ColorSequence.new(color or C.COSMIC)
    auraObj.Size = NumberSequence.new(2)
    auraObj.Lifetime = NumberRange.new(0.5, 1)
    auraObj.Rate = 30
    auraObj.Speed = NumberRange.new(2)
    auraObj.SpreadAngle = Vector2.new(180, 180)
    auraObj.Parent = hrp
end

local function spawnKillEffect(pos)
    local p = Instance.new("Part")
    p.Anchored = true; p.CanCollide = false
    p.Material = Enum.Material.Neon
    p.Shape = Enum.PartType.Ball
    p.Size = Vector3.new(2, 2, 2)
    p.Position = pos
    p.Color = C.COSMIC3
    p.Transparency = 0.3
    p.Parent = workspace
    TweenService:Create(p, TweenInfo.new(0.5), {Size = Vector3.new(15, 15, 15), Transparency = 1}):Play()
    task.delay(0.6, function() p:Destroy() end)
end

-- =========================================================
-- CROSSHAIR
-- =========================================================
local crosshairGui = nil
local crosshairDrawings = {}

local function clearCrosshairGui()
    if crosshairGui then crosshairGui:Destroy(); crosshairGui = nil end
    for _, d in pairs(crosshairDrawings) do
        pcall(function() d:Remove() end)
    end
    crosshairDrawings = {}
end

local function applyCrosshair(enable, style, color, size, thick, offsetX, offsetY)
    clearCrosshairGui()
    if not enable then return end

    if Drawing and Drawing.new then
        local ok = pcall(function()
            if style == "Plus" then
                for i = 1, 4 do
                    local ln = Drawing.new("Line")
                    ln.Visible = true
                    ln.Color = color or C.STAR
                    ln.Thickness = thick or 2
                    table.insert(crosshairDrawings, ln)
                end
            elseif style == "Dot" then
                local dot = Drawing.new("Circle")
                dot.Filled = true
                dot.Visible = true
                dot.Color = color or C.STAR
                dot.Radius = (size or 8) / 2
                table.insert(crosshairDrawings, dot)
            elseif style == "Circle" then
                local circle = Drawing.new("Circle")
                circle.Filled = false
                circle.Visible = true
                circle.Color = color or C.STAR
                circle.Thickness = thick or 2
                circle.Radius = size or 8
                table.insert(crosshairDrawings, circle)
            end
        end)
        if ok and #crosshairDrawings > 0 then
            _G.Cosmic_crosshairMode = "Drawing"
            return
        end
    end

    _G.Cosmic_crosshairMode = "Gui"
    crosshairGui = Instance.new("ScreenGui")
    crosshairGui.Name = "CosmicCrosshair"
    crosshairGui.ResetOnSpawn = false
    crosshairGui.IgnoreGuiInset = true
    crosshairGui.Parent = PG

    local center = UDim2.new(0.5, offsetX or 0, 0.5, offsetY or 0)
    local col = color or C.STAR

    if style == "Plus" then
        for i = 1, 4 do
            local ln = Instance.new("Frame")
            ln.BackgroundColor3 = col
            ln.BorderSizePixel = 0
            if i == 1 then ln.Size = UDim2.new(0, size or 8, 0, thick or 2); ln.Position = center + UDim2.new(0, -(size or 8) - 3, 0, -(thick or 2)/2)
            elseif i == 2 then ln.Size = UDim2.new(0, size or 8, 0, thick or 2); ln.Position = center + UDim2.new(0, 3, 0, -(thick or 2)/2)
            elseif i == 3 then ln.Size = UDim2.new(0, thick or 2, 0, size or 8); ln.Position = center + UDim2.new(0, -(thick or 2)/2, 0, -(size or 8) - 3)
            elseif i == 4 then ln.Size = UDim2.new(0, thick or 2, 0, size or 8); ln.Position = center + UDim2.new(0, -(thick or 2)/2, 0, 3) end
            ln.Parent = crosshairGui
        end
    elseif style == "Dot" then
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, size or 8, 0, size or 8)
        dot.Position = center - UDim2.new(0, (size or 8)/2, 0, (size or 8)/2)
        dot.BackgroundColor3 = col
        dot.BorderSizePixel = 0
        dot.Parent = crosshairGui
        local cc = Instance.new("UICorner")
        cc.CornerRadius = UDim.new(1, 0)
        cc.Parent = dot
    elseif style == "Circle" then
        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, (size or 8) * 2, 0, (size or 8) * 2)
        circle.Position = center - UDim2.new(0, size or 8, 0, size or 8)
        circle.BackgroundTransparency = 1
        circle.Parent = crosshairGui
        local cc = Instance.new("UICorner")
        cc.CornerRadius = UDim.new(1, 0)
        cc.Parent = circle
        local s = Instance.new("UIStroke")
        s.Color = col
        s.Thickness = thick or 2
        s.Parent = circle
    end
end

local function updateCrosshairDrawings()
    if _G.Cosmic_crosshairMode ~= "Drawing" then return end
    if #crosshairDrawings == 0 then return end

    local cam = workspace.CurrentCamera
    if not cam then return end

    local center = Vector2.new(
        cam.ViewportSize.X / 2 + (S.CrosshairX or 0),
        cam.ViewportSize.Y / 2 + (S.CrosshairY or 0)
    )

    local style = S.CrosshairStyle
    local size = S.CrosshairSize or 8
    local col = S.CrosshairColor or C.STAR

    if style == "Plus" then
        for _, ln in pairs(crosshairDrawings) do
            ln.Color = col
        end
        crosshairDrawings[1].From = center + Vector2.new(-size, 0)
        crosshairDrawings[1].To = center + Vector2.new(-2, 0)
        crosshairDrawings[2].From = center + Vector2.new(size, 0)
        crosshairDrawings[2].To = center + Vector2.new(2, 0)
        crosshairDrawings[3].From = center + Vector2.new(0, -size)
        crosshairDrawings[3].To = center + Vector2.new(0, -2)
        crosshairDrawings[4].From = center + Vector2.new(0, size)
        crosshairDrawings[4].To = center + Vector2.new(0, 2)
    elseif style == "Dot" then
        crosshairDrawings[1].Position = center
        crosshairDrawings[1].Color = col
    elseif style == "Circle" then
        crosshairDrawings[1].Position = center
        crosshairDrawings[1].Color = col
    end
end

_G.Cosmic_applyTrail = applyTrail
_G.Cosmic_applyAura = applyAura
_G.Cosmic_applyCrosshair = applyCrosshair

-- =========================================================
-- AIMLOCK / AIMBOT
-- =========================================================
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Blacklist

local function isVisible(part)
    local cam = workspace.CurrentCamera
    if not cam then return false end
    rayParams.FilterDescendantsInstances = { LP.Character }
    local origin = cam.CFrame.Position
    local direction = part.Position - origin
    local result = workspace:Raycast(origin, direction, rayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

local function getClosestAimTarget()
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

    local closest, shortest = nil, CosmicAimlock.FOV

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team then
            local valid = false
            if CosmicAimlock.Mode == "Killer" and p.Team.Name == "Killer" then valid = true
            elseif CosmicAimlock.Mode == "Survivor" and p.Team.Name == "Survivors" then valid = true end

            if valid then
                local part = p.Character:FindFirstChild(CosmicAimlock.AimPart) or p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if part and hum and hum.Health > 0 then
                    local sp, visible = cam:WorldToViewportPoint(part.Position)
                    if visible then
                        local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if dist < shortest then
                            if isVisible(part) then
                                shortest = dist
                                closest = part
                            end
                        end
                    end
                end
            end
        end
    end

    return closest
end

local AttackEvent = nil
pcall(function()
    AttackEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("BasicAttack")
end)

task.spawn(function()
    while task.wait(0.03) do
        if not CosmicAimlock.Enabled then continue end
        if not CosmicAimlock.Holding then continue end

        local target = getClosestAimTarget()
        if not target then continue end

        local cam = workspace.CurrentCamera
        if not cam then continue end

        local pos = target.Position
        if CosmicAimlock.Predict and CosmicAimlock.Predict > 0 then
            pos = pos + (target.AssemblyLinearVelocity * CosmicAimlock.Predict)
        end

        local targetCF = CFrame.new(cam.CFrame.Position, pos)
        cam.CFrame = cam.CFrame:Lerp(targetCF, CosmicAimlock.Strength)

        if CosmicAimlock.AutoAttack and CosmicAimlock.Mode == "Killer" and AttackEvent then
            local myRoot = getRoot()
            if myRoot then
                local dist = (target.Position - myRoot.Position).Magnitude
                if dist <= CosmicAimlock.LockRadius then
                    pcall(function() AttackEvent:FireServer(false) end)
                end
            end
        end
    end
end)

-- =========================================================
-- KILLER: AUTO ATTACK
-- =========================================================
local lastAtk = 0
task.spawn(function()
    while task.wait(0.1) do
        if S.Killer_AutoAtk and AttackEvent then
            local now = tick()
            if now - lastAtk >= (S.Killer_AtkDelay or 0.35) then
                lastAtk = now
                pcall(function() AttackEvent:FireServer(false) end)
            end
        end
    end
end)

-- =========================================================
-- KILLER: KILL ALL
-- =========================================================
local function getNearestAliveSurvivor()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < shortest then shortest = d; closest = plr.Character end
            end
        end
    end
    return closest
end

task.spawn(function()
    while task.wait(0.3) do
        if S.Killer_KillAll and AttackEvent then
            local myRoot = getRoot()
            if not myRoot then continue end

            local char = LP.Character
            if not char then continue end
            local myHum = char:FindFirstChildOfClass("Humanoid")
            if not myHum or myHum.Health <= 0 then continue end

            local target = getNearestAliveSurvivor()
            if target then
                local tHRP = target:FindFirstChild("HumanoidRootPart")
                if tHRP then
                    local vel = tHRP.AssemblyLinearVelocity
                    local predict = vel * 0.15
                    local targetPos = tHRP.Position + predict
                    local behind = tHRP.CFrame.LookVector * -3
                    pcall(function()
                        myRoot.CFrame = CFrame.new(targetPos + behind, targetPos)
                    end)
                    pcall(function() AttackEvent:FireServer(false) end)
                end
            end
        end
    end
end)

-- =========================================================
-- KILLER: HITBOX
-- =========================================================
local hitboxCache = {}
task.spawn(function()
    while task.wait(0.4) do
        if S.Killer_Hitbox then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Team and p.Team.Name == "Survivors" then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local part = p.Character:FindFirstChild("HumanoidRootPart")
                        if part then
                            if not hitboxCache[part] then
                                hitboxCache[part] = {
                                    Size = part.Size,
                                    Transparency = part.Transparency,
                                    Material = part.Material,
                                    Color = part.Color,
                                    CanCollide = part.CanCollide
                                }
                            end
                            local size = S.Killer_HitboxSize or 15
                            part.Size = Vector3.new(size, size, size)
                            part.CanCollide = false
                            part.Transparency = 1
                        end
                    end
                end
            end
        else
            for part, orig in pairs(hitboxCache) do
                if part and part.Parent then
                    part.Size = orig.Size
                    part.Transparency = orig.Transparency
                    part.CanCollide = orig.CanCollide
                    part.Material = orig.Material
                    part.Color = orig.Color
                end
                hitboxCache[part] = nil
            end
        end
    end
end)

-- =========================================================
-- KILL EFFECT LOOP
-- =========================================================
task.spawn(function()
    while task.wait(0.8) do
        if S.KillEffect then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health <= 0 then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and not p.Character:GetAttribute("CosmicKillEffect") then
                            p.Character:SetAttribute("CosmicKillEffect", true)
                            spawnKillEffect(hrp.Position)
                        end
                    else
                        if p.Character:GetAttribute("CosmicKillEffect") then
                            p.Character:SetAttribute("CosmicKillEffect", false)
                        end
                    end
                end
            end
        end
    end
end)

-- =========================================================
-- NO CLIP CAMERA
-- =========================================================
task.spawn(function()
    while task.wait(0.2) do
        local cam = workspace.CurrentCamera
        if cam then cam.CanCollide = not S.NoClipCamera end
    end
end)

-- =========================================================
-- ESP MAIN LOOP
-- =========================================================
local lastESPUpdate = 0
RunService.Heartbeat:Connect(function()
    local root = getRoot()
    if not root then return end
    local now = tick()
    if now - lastESPUpdate < 0.08 then return end
    lastESPUpdate = now

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")

            if hum and hum.Health > 0 then
                if ESP.Survivor and p.Team and p.Team.Name == "Survivors" then
                    _G.Cosmic_createESP(char, TeamColors.Survivor)
                elseif ESP.Killer and p.Team and p.Team.Name == "Killer" then
                    _G.Cosmic_createESP(char, TeamColors.Killer)
                else
                    _G.Cosmic_removeESP(char)
                end
            else
                _G.Cosmic_removeESP(char)
            end
            _G.Cosmic_createStatusESP(p, char, root)
        end
    end

    if ESP.Generator then
        for gen in pairs(_G.Cosmic_hdEffects and {} or {}) do end  -- placeholder
    end

    -- Generator ESP dari cache Bagian 3
    for gen in pairs(workspace:GetDescendants()) do
        if gen.Name == "Generator" then
            _G.Cosmic_UpdateGenerator(gen)
        end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Window" or obj.Name == "Pallet" or obj.Name == "Palletwrong" then
            _G.Cosmic_UpdateMapESP(obj, root)
        end
    end
end)

-- =========================================================
-- FPS & PING PANEL (KIRI ATAS)
-- =========================================================
local fpsPanel = Instance.new("ScreenGui")
fpsPanel.Name = "CosmicFPS"
fpsPanel.ResetOnSpawn = false
fpsPanel.IgnoreGuiInset = true
fpsPanel.Parent = PG
_G.Cosmic_fpsPanel = fpsPanel

local fpsBox = Instance.new("Frame")
fpsBox.Size = UDim2.new(0, 170, 0, 26)
fpsBox.Position = UDim2.new(0, 10, 0, 10)
fpsBox.BackgroundColor3 = C.BG
fpsBox.BackgroundTransparency = 0.25
fpsBox.BorderSizePixel = 0
fpsBox.Parent = fpsPanel
local cc1 = Instance.new("UICorner"); cc1.CornerRadius = UDim.new(0, 8); cc1.Parent = fpsBox
local ss1 = Instance.new("UIStroke"); ss1.Color = C.COSMIC; ss1.Thickness = 1; ss1.Transparency = 0.3; ss1.Parent = fpsBox

local fpsGrad = Instance.new("UIGradient")
fpsGrad.Color = ColorSequence.new(C.COSMIC, C.COSMIC2, C.COSMIC3)
fpsGrad.Rotation = 45
fpsGrad.Parent = fpsBox

local fpsLbl = Instance.new("TextLabel")
fpsLbl.Size = UDim2.new(1, -10, 1, 0)
fpsLbl.Position = UDim2.new(0, 5, 0, 0)
fpsLbl.BackgroundTransparency = 1
fpsLbl.Text = "🌌 FPS: -- | PING: --"
fpsLbl.TextColor3 = C.STAR
fpsLbl.TextSize = 11
fpsLbl.Font = Enum.Font.GothamBold
fpsLbl.TextXAlignment = Enum.TextXAlignment.Left
fpsLbl.Parent = fpsBox

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
        fpsLbl.Text = string.format("🌌 FPS: %d | PING: %d ms", fps, ping)
        fCnt = 0
        tAcc = 0
    end
end)

-- =========================================================
-- CROSSHAIR UPDATE LOOP
-- =========================================================
RunService.RenderStepped:Connect(function()
    if S.Crosshair then
        updateCrosshairDrawings()
    end
end)

print("✅ [4/8] Loop utama + Killer + Aimlock + FPS loaded (FIXED)")-- =========================================================
-- COSMIC HUB — BAGIAN 5/8 : GUI + KOMPONEN + TOMBOL MENU (FIXED)
-- =========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LP = _G.Cosmic_LP
local PG = _G.Cosmic_PG
local C = _G.Cosmic_C

local rnd = _G.Cosmic_rnd
local strk = _G.Cosmic_strk

local gui = Instance.new("ScreenGui")
gui.Name = "CosmicHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PG

_G.Cosmic_gui = gui

-- =========================================================
-- TOMBOL MENU (PLANET KECIL + BISA DIGESER)
-- =========================================================
local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(0, 44, 0, 44)
btnContainer.Position = UDim2.new(0, 15, 0.3, 0)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = gui

local ring1 = Instance.new("Frame")
ring1.Size = UDim2.new(1, 10, 1, 10)
ring1.Position = UDim2.new(0, -5, 0, -5)
ring1.BackgroundTransparency = 1
ring1.Parent = btnContainer
local ring1Stroke = Instance.new("UIStroke")
ring1Stroke.Thickness = 2
ring1Stroke.Color = C.COSMIC
ring1Stroke.Transparency = 0.1
ring1Stroke.Parent = ring1
local ring1Grad = Instance.new("UIGradient")
ring1Grad.Color = ColorSequence.new(C.COSMIC3, C.COSMIC2, C.COSMIC, C.COSMIC3)
ring1Grad.Parent = ring1Stroke

local ring2 = Instance.new("Frame")
ring2.Size = UDim2.new(1, 5, 1, 5)
ring2.Position = UDim2.new(0, -2.5, 0, -2.5)
ring2.BackgroundTransparency = 1
ring2.Parent = btnContainer
local ring2Stroke = Instance.new("UIStroke")
ring2Stroke.Thickness = 1.2
ring2Stroke.Color = C.COSMIC2
ring2Stroke.Transparency = 0.3
ring2Stroke.Parent = ring2

local ring3 = Instance.new("Frame")
ring3.Size = UDim2.new(1, -8, 1, -8)
ring3.Position = UDim2.new(0, 4, 0, 4)
ring3.BackgroundTransparency = 1
ring3.Parent = btnContainer
local ring3Stroke = Instance.new("UIStroke")
ring3Stroke.Thickness = 0.8
ring3Stroke.Color = C.STAR
ring3Stroke.Transparency = 0.5
ring3Stroke.Parent = ring3

local mainBtn = Instance.new("TextButton")
mainBtn.Size = UDim2.new(1, -12, 1, -12)
mainBtn.Position = UDim2.new(0, 6, 0, 6)
mainBtn.BackgroundColor3 = C.PANEL2
mainBtn.Text = "🌌"
mainBtn.TextColor3 = C.STAR
mainBtn.TextSize = 20
mainBtn.Font = Enum.Font.GothamBlack
mainBtn.BorderSizePixel = 0
mainBtn.AutoButtonColor = false
mainBtn.Parent = btnContainer
rnd(mainBtn, 999)

local btnGrad = Instance.new("UIGradient")
btnGrad.Color = ColorSequence.new(C.COSMIC, C.PANEL2, C.COSMIC2)
btnGrad.Rotation = 45
btnGrad.Parent = mainBtn

local glow = Instance.new("Frame")
glow.Size = UDim2.new(1, 18, 1, 18)
glow.Position = UDim2.new(0, -9, 0, -9)
glow.BackgroundColor3 = C.COSMIC
glow.BackgroundTransparency = 0.5
glow.BorderSizePixel = 0
glow.ZIndex = -1
glow.Parent = mainBtn
rnd(glow, 999)

local innerGlow = Instance.new("Frame")
innerGlow.Size = UDim2.new(0.6, 0, 0.6, 0)
innerGlow.Position = UDim2.new(0.2, 0, 0.2, 0)
innerGlow.BackgroundColor3 = C.COSMIC2
innerGlow.BackgroundTransparency = 0.4
innerGlow.BorderSizePixel = 0
innerGlow.ZIndex = -1
innerGlow.Parent = mainBtn
rnd(innerGlow, 999)

-- Animasi tombol
task.spawn(function()
    local t = 0
    while btnContainer.Parent do
        t = t + 0.03
        ring1.Rotation = t * 60
        ring1Grad.Rotation = t * 120
        ring2.Rotation = -t * 90
        ring3.Rotation = t * 40

        local pulse = (math.sin(t * 4) + 1) / 2
        glow.BackgroundTransparency = 0.75 - pulse * 0.4
        glow.Size = UDim2.new(1, 12 + pulse * 14, 1, 12 + pulse * 14)
        glow.Position = UDim2.new(0, -6 - pulse * 7, 0, -6 - pulse * 7)
        innerGlow.BackgroundTransparency = 0.3 - pulse * 0.2
        btnGrad.Rotation = t * 40
        mainBtn.TextSize = 20 + math.sin(t * 5) * 2
        task.wait(0.03)
    end
end)

-- Partikel orbit
for i = 1, 12 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, 3, 0, 3)
    particle.BackgroundColor3 = C.STAR
    particle.BorderSizePixel = 0
    particle.Parent = btnContainer
    rnd(particle, 999)
    local angle = (i / 12) * math.pi * 2
    local orbitSpeed = 2 + math.random() * 2
    local radius = 28 + math.random() * 6

    task.spawn(function()
        while btnContainer.Parent do
            local t = tick()
            local x = math.cos(t * orbitSpeed + angle) * radius
            local y = math.sin(t * orbitSpeed + angle) * radius * 0.6
            particle.Position = UDim2.new(0.5, x - 1.5, 0.5, y - 1.5)
            particle.BackgroundTransparency = 0.1 + math.sin(t * 5 + i) * 0.3
            particle.BackgroundColor3 = Color3.fromHSV((t * 0.4 + i * 0.08) % 1, 0.6, 1)
            task.wait(0.03)
        end
    end)
end

-- Drag tombol
local dragging = false
local dragStart = nil
local startPos = nil
local wasDragged = false

btnContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        wasDragged = false
        dragStart = input.Position
        startPos = btnContainer.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then wasDragged = true end
        btnContainer.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- =========================================================
-- AIMLOCK FLOATING BUTTON
-- =========================================================
local aimBtnGui = Instance.new("ScreenGui")
aimBtnGui.Name = "CosmicAimlockBtn"
aimBtnGui.ResetOnSpawn = false
aimBtnGui.IgnoreGuiInset = true
aimBtnGui.Parent = PG

local aimContainer = Instance.new("Frame")
aimContainer.Size = UDim2.new(0, 48, 0, 48)
aimContainer.Position = UDim2.new(0, 15, 0.4, 0)
aimContainer.BackgroundTransparency = 1
aimContainer.Parent = aimBtnGui

local aimOuterRing = Instance.new("Frame")
aimOuterRing.Size = UDim2.new(1, 6, 1, 6)
aimOuterRing.Position = UDim2.new(0, -3, 0, -3)
aimOuterRing.BackgroundTransparency = 1
aimOuterRing.Parent = aimContainer
local aimOuterStroke = Instance.new("UIStroke")
aimOuterStroke.Thickness = 2
aimOuterStroke.Color = C.COSMIC2
aimOuterStroke.Transparency = 0.1
aimOuterStroke.Parent = aimOuterRing
local aimOuterGrad = Instance.new("UIGradient")
aimOuterGrad.Color = ColorSequence.new(C.COSMIC, C.COSMIC2, C.COSMIC3)
aimOuterGrad.Parent = aimOuterStroke

local aimInnerRing = Instance.new("Frame")
aimInnerRing.Size = UDim2.new(1, -2, 1, -2)
aimInnerRing.Position = UDim2.new(0, 1, 0, 1)
aimInnerRing.BackgroundTransparency = 1
aimInnerRing.Parent = aimContainer
local aimInnerStroke = Instance.new("UIStroke")
aimInnerStroke.Thickness = 1
aimInnerStroke.Color = C.COSMIC2
aimInnerStroke.Transparency = 0.3
aimInnerStroke.Parent = aimInnerRing

local aimBtn = Instance.new("TextButton")
aimBtn.Size = UDim2.new(1, -8, 1, -8)
aimBtn.Position = UDim2.new(0, 4, 0, 4)
aimBtn.BackgroundColor3 = C.PANEL2
aimBtn.Text = "🎯"
aimBtn.TextColor3 = C.COSMIC2
aimBtn.TextSize = 22
aimBtn.Font = Enum.Font.GothamBlack
aimBtn.BorderSizePixel = 0
aimBtn.AutoButtonColor = false
aimBtn.Parent = aimContainer
rnd(aimBtn, 999)

local aimBtnGrad = Instance.new("UIGradient")
aimBtnGrad.Color = ColorSequence.new(C.PANEL2, C.COSMIC, C.PANEL2)
aimBtnGrad.Rotation = 45
aimBtnGrad.Parent = aimBtn

local aimGlow = Instance.new("Frame")
aimGlow.Size = UDim2.new(1, 16, 1, 16)
aimGlow.Position = UDim2.new(0, -8, 0, -8)
aimGlow.BackgroundColor3 = C.COSMIC2
aimGlow.BackgroundTransparency = 0.6
aimGlow.BorderSizePixel = 0
aimGlow.ZIndex = -1
aimGlow.Parent = aimBtn
rnd(aimGlow, 999)

local aimModeLbl = Instance.new("TextLabel")
aimModeLbl.Size = UDim2.new(0, 100, 0, 14)
aimModeLbl.Position = UDim2.new(0.5, -50, 1, 2)
aimModeLbl.BackgroundTransparency = 1
aimModeLbl.Text = "KILLER"
aimModeLbl.TextColor3 = C.COSMIC3
aimModeLbl.TextSize = 9
aimModeLbl.Font = Enum.Font.GothamBlack
aimModeLbl.TextStrokeTransparency = 0.3
aimModeLbl.Parent = aimBtn
_G.Cosmic_aimModeLbl = aimModeLbl

local Aimlock = _G.CosmicAimlock

task.spawn(function()
    local t = 0
    while aimContainer.Parent do
        t = t + 0.03
        aimOuterRing.Rotation = t * 60
        aimOuterGrad.Rotation = t * 100
        aimInnerRing.Rotation = -t * 90

        local pulse = (math.sin(t * 4) + 1) / 2
        local baseTrans = Aimlock.Holding and 0.3 or 0.7
        aimGlow.BackgroundTransparency = baseTrans - pulse * 0.25
        local glowSize = Aimlock.Holding and 20 or 16
        aimGlow.Size = UDim2.new(1, glowSize + pulse * 8, 1, glowSize + pulse * 8)
        aimGlow.Position = UDim2.new(0, -(glowSize/2) - pulse * 4, 0, -(glowSize/2) - pulse * 4)
        aimBtnGrad.Rotation = t * 40
        task.wait(0.03)
    end
end)

local aimDragging, aimDS, aimDP, aimWasDragged = false, nil, nil, false
aimContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        aimDragging = true; aimWasDragged = false
        aimDS = input.Position; aimDP = aimContainer.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if aimDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - aimDS
        if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then aimWasDragged = true end
        aimContainer.Position = UDim2.new(aimDP.X.Scale, aimDP.X.Offset + d.X, aimDP.Y.Scale, aimDP.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        aimDragging = false
    end
end)

aimBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if aimWasDragged then return end
        Aimlock.Holding = true
        aimBtn.BackgroundColor3 = C.COSMIC
    end
end)

aimBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Aimlock.Holding = false
        aimBtn.BackgroundColor3 = C.PANEL2
    end
end)

aimBtn.MouseButton2Click:Connect(function()
    if Aimlock.Mode == "Killer" then
        Aimlock.Mode = "Survivor"
        aimModeLbl.Text = "SURVIVOR"
        aimModeLbl.TextColor3 = C.GRN
    else
        Aimlock.Mode = "Killer"
        aimModeLbl.Text = "KILLER"
        aimModeLbl.TextColor3 = C.COSMIC3
    end
end)

_G.Cosmic_setAimlockVisible = function(visible)
    if aimBtnGui then aimBtnGui.Enabled = visible end
end

task.spawn(function()
    task.wait(0.5)
    _G.Cosmic_setAimlockVisible(_G.CosmicAimlock.ShowButton)
end)

-- =========================================================
-- PANEL UTAMA
-- =========================================================
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 500, 0, 420)
panel.Position = UDim2.new(0.5, -250, 0.5, -210)
panel.BackgroundColor3 = C.BG
panel.BackgroundTransparency = 0.05
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = gui
rnd(panel, 18)
strk(panel, C.COSMIC, 2, 0.2)

_G.Cosmic_panel = panel

local panelGrad = Instance.new("UIGradient")
panelGrad.Color = ColorSequence.new(C.BG, C.BG2, C.BG)
panelGrad.Rotation = 45
panelGrad.Parent = panel

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = C.PANEL
header.BackgroundTransparency = 0.1
header.BorderSizePixel = 0
header.Parent = panel
rnd(header, 18)

local hPatch = Instance.new("Frame")
hPatch.Size = UDim2.new(1, 0, 0, 24)
hPatch.Position = UDim2.new(0, 0, 1, -24)
hPatch.BackgroundColor3 = C.PANEL
hPatch.BackgroundTransparency = 0.1
hPatch.BorderSizePixel = 0
hPatch.Parent = header

local neonLine = Instance.new("Frame")
neonLine.Size = UDim2.new(1, -40, 0, 3)
neonLine.Position = UDim2.new(0, 20, 1, -1.5)
neonLine.BackgroundColor3 = C.COSMIC2
neonLine.BorderSizePixel = 0
neonLine.Parent = header
local neonGrad = Instance.new("UIGradient")
neonGrad.Color = ColorSequence.new(C.COSMIC3, C.COSMIC2, C.STAR_BRIGHT, C.COSMIC2, C.COSMIC3)
neonGrad.Parent = neonLine

task.spawn(function()
    while neonLine.Parent do
        for i = 0, 1, 0.03 do
            if not neonLine.Parent then break end
            neonGrad.Rotation = i * 360
            task.wait(0.06)
        end
    end
end)

local hTitle = Instance.new("TextLabel")
hTitle.Size = UDim2.new(1, -100, 1, 0)
hTitle.Position = UDim2.new(0, 18, 0, 0)
hTitle.BackgroundTransparency = 1
hTitle.Text = "🌌 COSMIC HUB"
hTitle.TextColor3 = C.STAR
hTitle.TextSize = 15
hTitle.Font = Enum.Font.GothamBlack
hTitle.TextXAlignment = Enum.TextXAlignment.Left
hTitle.TextStrokeTransparency = 0.2
hTitle.TextStrokeColor3 = C.COSMIC3
hTitle.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
closeBtn.BackgroundColor3 = C.PANEL2
closeBtn.Text = "✕"
closeBtn.TextColor3 = C.RED
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = header
rnd(closeBtn, 8)
strk(closeBtn, C.RED, 1, 0.5)

-- Sidebar
local sbFrame = Instance.new("Frame")
sbFrame.Size = UDim2.new(0, 130, 1, -70)
sbFrame.Position = UDim2.new(0, 12, 0, 60)
sbFrame.BackgroundColor3 = C.PANEL
sbFrame.BackgroundTransparency = 0.2
sbFrame.BorderSizePixel = 0
sbFrame.Parent = panel
rnd(sbFrame, 12)
strk(sbFrame, C.COSMIC, 1, 0.6)

local sb = Instance.new("ScrollingFrame")
sb.Size = UDim2.new(1, -4, 1, -4)
sb.Position = UDim2.new(0, 2, 0, 2)
sb.BackgroundTransparency = 1
sb.BorderSizePixel = 0
sb.ScrollBarThickness = 3
sb.ScrollBarImageColor3 = C.COSMIC2
sb.CanvasSize = UDim2.new(0, 0, 0, 0)
sb.AutomaticCanvasSize = Enum.AutomaticSize.Y
sb.Parent = sbFrame
_G.Cosmic_sb = sb

local sbL = Instance.new("UIListLayout")
sbL.Padding = UDim.new(0, 4)
sbL.Parent = sb

local sbP = Instance.new("UIPadding")
sbP.PaddingTop = UDim.new(0, 6)
sbP.PaddingLeft = UDim.new(0, 4)
sbP.PaddingRight = UDim.new(0, 4)
sbP.PaddingBottom = UDim.new(0, 6)
sbP.Parent = sb

-- Content
local ct = Instance.new("Frame")
ct.Size = UDim2.new(1, -160, 1, -70)
ct.Position = UDim2.new(0, 150, 0, 60)
ct.BackgroundColor3 = C.PANEL
ct.BackgroundTransparency = 0.2
ct.BorderSizePixel = 0
ct.Parent = panel
rnd(ct, 12)
strk(ct, C.COSMIC, 1, 0.6)

local cs = Instance.new("ScrollingFrame")
cs.Size = UDim2.new(1, -16, 1, -16)
cs.Position = UDim2.new(0, 8, 0, 8)
cs.BackgroundTransparency = 1
cs.BorderSizePixel = 0
cs.ScrollBarThickness = 3
cs.ScrollBarImageColor3 = C.COSMIC2
cs.CanvasSize = UDim2.new(0, 0, 0, 0)
cs.AutomaticCanvasSize = Enum.AutomaticSize.Y
cs.Parent = ct
_G.Cosmic_cs = cs

local csL = Instance.new("UIListLayout")
csL.Padding = UDim.new(0, 5)
csL.Parent = cs

-- =========================================================
-- KOMPONEN UI
-- =========================================================
local function sec(title, icon)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 26)
    f.BackgroundTransparency = 1
    f.Parent = cs

    local deco = Instance.new("Frame")
    deco.Size = UDim2.new(0, 4, 0, 18)
    deco.Position = UDim2.new(0, 4, 0.5, -9)
    deco.BackgroundColor3 = C.COSMIC
    deco.BorderSizePixel = 0
    deco.Parent = f
    rnd(deco, 2)
    local decoGrad = Instance.new("UIGradient")
    decoGrad.Color = ColorSequence.new(C.COSMIC3, C.COSMIC2, C.COSMIC)
    decoGrad.Parent = deco

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 1, 0)
    l.Position = UDim2.new(0, 16, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = icon .. "  " .. string.upper(title)
    l.TextColor3 = C.STAR
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
    f.Size = UDim2.new(1, -4, 0, 32)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    local fStrk = strk(f, C.COSMIC, 1, 0.7)

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
    t.Size = UDim2.new(0, 36, 0, 18)
    t.Position = UDim2.new(1, -46, 0.5, -9)
    t.BorderSizePixel = 0
    t.Parent = f
    rnd(t, 9)

    local k = Instance.new("Frame")
    k.Size = UDim2.new(0, 12, 0, 12)
    k.BorderSizePixel = 0
    k.Parent = t
    rnd(k, 6)

    local saved = _G.CosmicToggle[name]
    local state = (saved ~= nil) and saved or def
    _G.CosmicToggle[name] = state

    t.BackgroundColor3 = state and C.COSMIC or C.PANEL
    k.Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    k.BackgroundColor3 = state and C.STAR_BRIGHT or C.DIM

    local cB = Instance.new("TextButton")
    cB.Size = UDim2.new(1, 0, 1, 0)
    cB.BackgroundTransparency = 1
    cB.Text = ""
    cB.Parent = t
    cB.MouseButton1Click:Connect(function()
        state = not state
        _G.CosmicToggle[name] = state
        TweenService:Create(k, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
            BackgroundColor3 = state and C.STAR_BRIGHT or C.DIM
        }):Play()
        TweenService:Create(t, TweenInfo.new(0.2), {BackgroundColor3 = state and C.COSMIC or C.PANEL}):Play()
        fStrk.Color = state and C.COSMIC2 or C.COSMIC
        if cb then pcall(cb, state) end
    end)
end

local function sl(name, min, max, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 42)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.COSMIC, 1, 0.7)

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

    local curVal = _G.CosmicSlider[name] or def
    _G.CosmicSlider[name] = curVal

    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0, 40, 0, 16)
    v.Position = UDim2.new(1, -50, 0, 4)
    v.BackgroundTransparency = 1
    v.Text = tostring(curVal)
    v.TextColor3 = C.COSMIC2
    v.TextSize = 10
    v.Font = Enum.Font.GothamBold
    v.TextXAlignment = Enum.TextXAlignment.Right
    v.Parent = f

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -24, 0, 5)
    bg.Position = UDim2.new(0, 12, 1, -14)
    bg.BackgroundColor3 = C.PANEL
    bg.BorderSizePixel = 0
    bg.Parent = f
    rnd(bg, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((curVal - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = C.COSMIC2
    fill.BorderSizePixel = 0
    fill.Parent = bg
    rnd(fill, 3)
    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color = ColorSequence.new(C.COSMIC, C.COSMIC2, C.COSMIC3)
    fillGrad.Parent = fill

    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 12, 0, 12)
    kn.Position = UDim2.new((curVal - min) / (max - min), -6, 0.5, -6)
    kn.BackgroundColor3 = C.STAR_BRIGHT
    kn.BorderSizePixel = 0
    kn.ZIndex = 2
    kn.Parent = bg
    rnd(kn, 6)
    strk(kn, C.COSMIC2, 2)

    local drag = false
    local function upd(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local val = math.floor((min + (max - min) * pos) * 100 + 0.5) / 100
        _G.CosmicSlider[name] = val
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
    strk(f, C.COSMIC, 1, 0.7)

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
    cB.Size = UDim2.new(0, 34, 0, 16)
    cB.Position = UDim2.new(1, -44, 0.5, -8)
    cB.BackgroundColor3 = def
    cB.Text = ""
    cB.BorderSizePixel = 0
    cB.Parent = f
    rnd(cB, 4)
    strk(cB, C.COSMIC2, 1.5)

    local presets = {
        Color3.fromRGB(160, 80, 255),
        Color3.fromRGB(0, 200, 255),
        Color3.fromRGB(255, 80, 200),
        Color3.fromRGB(255, 215, 100),
        Color3.fromRGB(0, 255, 150),
        Color3.fromRGB(255, 60, 60),
        Color3.fromRGB(200, 220, 255),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(20, 20, 30),
    }
    local idx = 1
    for i, c in ipairs(presets) do
        if c == def then idx = i; break end
    end
    cB.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #presets then idx = 1 end
        cB.BackgroundColor3 = presets[idx]
        if cb then pcall(cb, presets[idx]) end
    end)
end

local function btn(name, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -4, 0, 32)
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
    strk(b, C.COSMIC2, 1, 0.7)
    b.MouseButton1Click:Connect(function()
        if cb then pcall(cb) end
    end)
end

local function drp(name, options, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 32)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.COSMIC, 1, 0.7)

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
    v.TextColor3 = C.COSMIC2
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

-- =========================================================
-- TAB SYSTEM
-- =========================================================
local activeTab = nil
local function makeTab(name, icon, order, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 32)
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
    ind.BackgroundColor3 = C.COSMIC2
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
        TweenService:Create(ind, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 3, 0, 22)}):Play()
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

-- EXPOSE KOMPONEN KE GLOBAL (biar Bagian 6-7 bisa akses)
_G.Cosmic_sec = sec
_G.Cosmic_lbl = lbl
_G.Cosmic_tog = tog
_G.Cosmic_sl = sl
_G.Cosmic_cpk = cpk
_G.Cosmic_btn = btn
_G.Cosmic_drp = drp
_G.Cosmic_makeTab = makeTab
_G.Cosmic_btnContainer = btnContainer

-- BUKA/TUTUP PANEL
mainBtn.MouseButton1Click:Connect(function()
    if wasDragged then wasDragged = false; return end
    panel.Visible = not panel.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
end)

print("✅ [5/8] GUI + Komponen + Tombol Menu + Aimlock loaded (FIXED)")-- =========================================================
-- COSMIC HUB — BAGIAN 6/8 : TAB UI PART 1 (FIXED)
-- =========================================================

local C = _G.Cosmic_C
local S = _G.CosmicS
local ESP = _G.CosmicESP
local ESPStatus = _G.CosmicESPStatus
local TeamColors = _G.CosmicTeamColors

local FireList = _G.Cosmic_FireList
local FireFeetList = _G.Cosmic_FireFeetList

-- Ambil komponen dari Bagian 5
local sec = _G.Cosmic_sec
local lbl = _G.Cosmic_lbl
local tog = _G.Cosmic_tog
local sl = _G.Cosmic_sl
local cpk = _G.Cosmic_cpk
local btn = _G.Cosmic_btn
local drp = _G.Cosmic_drp
local makeTab = _G.Cosmic_makeTab
local cs = _G.Cosmic_cs

local rnd = _G.Cosmic_rnd
local strk = _G.Cosmic_strk

-- ============================
-- TAB: FIRE
-- ============================
makeTab("Fire", "🔥", 1, function()
    sec("Fire Control", "⚙️")
    tog("Enable Fire", false, function(s)
        S.FireOn = s
        if _G.Cosmic_applyFire then _G.Cosmic_applyFire() end
    end)
    sl("Fire Size", 1, 15, 5, function(v)
        S.FireSize = v
        if _G.Cosmic_applyFire then _G.Cosmic_applyFire() end
    end)

    sec("Pilih Efek Fire (60)", "🔥")
    lbl("Klik efek untuk ganti", C.COSMIC2)
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
        strk(btn2, C.COSMIC, 1, 0.6)

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
            btn2.BackgroundColor3 = C.COSMIC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = C.STAR_BRIGHT
        end

        btn2.MouseButton1Click:Connect(function()
            S.FireType = fireName
            if _G.Cosmic_applyFire then _G.Cosmic_applyFire() end
            for _, c in pairs(cs:GetChildren()) do
                if c:IsA("TextButton") and c.LayoutOrder > 100 and c.LayoutOrder < 200 then
                    c.BackgroundColor3 = C.BG
                    c.BackgroundTransparency = 0.4
                    local l = c:FindFirstChildOfClass("TextLabel")
                    if l then l.TextColor3 = C.TXT end
                end
            end
            btn2.BackgroundColor3 = C.COSMIC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = C.STAR_BRIGHT
        end)
    end
end)

-- ============================
-- TAB: FIRE FEET
-- ============================
makeTab("Fire Feet", "👟", 2, function()
    sec("Fire Feet Control", "👟")
    tog("Enable Fire Feet", false, function(s)
        S.FireFeetOn = s
        if _G.Cosmic_applyFireFeet then _G.Cosmic_applyFireFeet() end
    end)

    sec("Pilih Efek Fire Feet (20)", "🔥")
    lbl("Klik efek untuk ganti", C.COSMIC2)
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
        strk(btn2, C.COSMIC, 1, 0.6)

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
            btn2.BackgroundColor3 = C.COSMIC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = C.STAR_BRIGHT
        end

        btn2.MouseButton1Click:Connect(function()
            S.FireFeetType = fireName
            if _G.Cosmic_applyFireFeet then _G.Cosmic_applyFireFeet() end
            for _, c in pairs(cs:GetChildren()) do
                if c:IsA("TextButton") and c.LayoutOrder > 200 and c.LayoutOrder < 300 then
                    c.BackgroundColor3 = C.BG
                    c.BackgroundTransparency = 0.4
                    local l = c:FindFirstChildOfClass("TextLabel")
                    if l then l.TextColor3 = C.TXT end
                end
            end
            btn2.BackgroundColor3 = C.COSMIC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = C.STAR_BRIGHT
        end)
    end
end)

-- ============================
-- TAB: ESP
-- ============================
makeTab("ESP", "👁️", 3, function()
    sec("Player ESP", "🌌")
    tog("ESP Survivor", false, function(s) ESP.Survivor = s end)
    cpk("Survivor Color", TeamColors.Survivor, function(c) TeamColors.Survivor = c end)
    tog("ESP Killer", false, function(s) ESP.Killer = s end)
    cpk("Killer Color", TeamColors.Killer, function(c) TeamColors.Killer = c end)
    lbl("✅ Unlimited — gak ada limit radius", C.GRN)

    sec("Object ESP", "⚡")
    tog("ESP Generator", false, function(s) ESP.Generator = s end)
    cpk("Gen Color", Color3.fromRGB(255, 170, 0), function(c) end)
    tog("ESP Pallet", false, function(s) ESP.Pallet = s end)
    cpk("Pallet Color", Color3.fromRGB(74, 255, 181), function(c) end)
    tog("ESP Window", false, function(s) ESP.Window = s end)
    cpk("Window Color", Color3.fromRGB(74, 255, 181), function(c) end)
    tog("ESP SCP", false, function(s) ESP.SCP = s end)
    cpk("SCP Color", Color3.fromRGB(255, 0, 0), function(c) end)

    sec("Object Distance", "📏")
    sl("ESP Radius", 50, 3000, 500, function(v) ESP.Distance = v end)
    lbl("Max 3000 studs", C.COSMIC2)

    sec("Status ESP", "🟢")
    tog("Enable Status ESP", false, function(s) ESPStatus.Enabled = s end)
    tog("Show Name", true, function(s) ESPStatus.ShowName = s end)
    tog("Show Distance", true, function(s) ESPStatus.ShowDistance = s end)
    tog("Show Health", false, function(s) ESPStatus.ShowHealth = s end)
    sl("Status Radius", 20, 500, 500, function(v) ESPStatus.Radius = v end)
end)

-- ============================
-- TAB: SURVIVOR
-- ============================
makeTab("Survivor", "🏃", 4, function()
    sec("Auto Parry (Stabil + Debounce)", "🛡️")
    tog("Enable Auto Parry", false, function(s)
        _G.CosmicParry.Enabled = s
        S.Parry = s
        if s and _G.Cosmic_scanKillers then _G.Cosmic_scanKillers() end
    end)
    sl("Parry Distance", 5, 30, 15, function(v) _G.CosmicParry.Distance = v end)
    sl("Debounce (detik)", 0.05, 0.5, 0.2, function(v) _G.CosmicParry.Debounce = v end)
    sl("Predict (detik)", 0, 0.3, 0, function(v) _G.CosmicParry.Predict = v end)
    sl("Face Sensitivity", -1, 1, 0.7, function(v)
        _G.CosmicParry.FaceSensitivity = v
        _G.CosmicParry.RequireFacing = v > -1
    end)
    lbl("✅ -1 = 360° (semua arah)", C.GRN)
    lbl("✅ 0.7 = default (killer harus menghadap)", C.COSMIC2)
    lbl("✅ Debounce 0.2 = paling stabil", C.GRN)

    sec("Parry Range Visual", "🔵")
    tog("Show Parry Range", true, function(s) S.ParryRangeVisual = s end)
    cpk("Range Color", S.ParryRangeColor or Color3.fromRGB(160, 80, 255), function(c) S.ParryRangeColor = c end)

    sec("Auto Skill Check (Stabil)", "🎯")
    tog("Enable Skill Check", false, function(s)
        _G.CosmicSkill.Enabled = s
        S.SkillCheck = s
    end)
    tog("Perfect Mode", false, function(s)
        _G.CosmicSkill.PerfectMode = s
        S.SkillCheckPerfect = s
    end)
    lbl("✅ Trigger zona +102 sampai +116", C.GRN)
    lbl("✅ RenderStepped (smooth)", C.GRN)

    sec("Aimlock / Aimbot (Hold to Aim)", "🎯")
    tog("Show Aimlock Button", false, function(s)
        _G.CosmicAimlock.ShowButton = s
        if _G.Cosmic_setAimlockVisible then _G.Cosmic_setAimlockVisible(s) end
    end)
    tog("Enable Aimlock", false, function(s)
        _G.CosmicAimlock.Enabled = s
    end)
    drp("Mode", {"Killer", "Survivor"}, "Killer", function(v)
        _G.CosmicAimlock.Mode = v
        local lbl2 = _G.Cosmic_aimModeLbl
        if lbl2 then
            lbl2.Text = string.upper(v)
            if v == "Killer" then lbl2.TextColor3 = C.COSMIC3
            else lbl2.TextColor3 = C.GRN end
        end
    end)
    drp("Aim Part", {"Head", "HumanoidRootPart", "Torso"}, "HumanoidRootPart", function(v)
        _G.CosmicAimlock.AimPart = v
    end)
    sl("Smoothness", 0.05, 1, 0.35, function(v) _G.CosmicAimlock.Strength = v end)
    sl("Predict (detik)", 0, 0.5, 0.15, function(v) _G.CosmicAimlock.Predict = v end)
    sl("FOV", 50, 1000, 300, function(v) _G.CosmicAimlock.FOV = v end)
    sl("Lock Radius", 5, 200, 100, function(v) _G.CosmicAimlock.LockRadius = v end)
    tog("Auto-Attack (Aimbot)", false, function(s)
        _G.CosmicAimlock.AutoAttack = s
    end)
    lbl("HOLD 🎯 = aim aktif", C.COSMIC2)
    lbl("Klik kanan 🎯 = switch mode", C.DIM)
end)

-- ============================
-- TAB: KILLER
-- ============================
makeTab("Killer", "🔪", 5, function()
    sec("Auto Attack (Spam)", "⚔️")
    tog("Auto Spam Attack", false, function(s) S.Killer_AutoAtk = s end)
    sl("Attack Delay", 0.1, 2, 0.35, function(v) S.Killer_AtkDelay = v end)

    sec("Auto Kill All", "💀")
    tog("Auto Kill All", false, function(s) S.Killer_KillAll = s end)
    lbl("✅ Auto TP + attack survivor", C.GRN)
    lbl("⚠️ Beresiko ban di public", C.RED)

    sec("Hitbox Expander", "📦")
    tog("Enable Hitbox", false, function(s) S.Killer_Hitbox = s end)
    sl("Hitbox Size", 3, 50, 15, function(v) S.Killer_HitboxSize = v end)
    lbl("Hitbox invisible & aman", C.GRN)

    sec("Aimlock Killer", "🎯")
    tog("Enable Aimlock Killer", false, function(s)
        _G.CosmicAimlock.Enabled = s
        _G.CosmicAimlock.Mode = "Survivor"
        local lbl2 = _G.Cosmic_aimModeLbl
        if lbl2 then
            lbl2.Text = "SURVIVOR"
            lbl2.TextColor3 = C.GRN
        end
    end)
    lbl("Hold 🎯 = lock ke survivor", C.COSMIC2)

    sec("Masked Power", "🎭")
    drp("Select Power", {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}, "Cobra", function(v) S.MaskedPower = v end)
    btn("⚡ Activate Power", function()
        pcall(function()
            local RS = _G.Cosmic_ReplicatedStorage
            local r = RS:FindFirstChild("Remotes")
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
            local RS = _G.Cosmic_ReplicatedStorage
            local r = RS:FindFirstChild("Remotes")
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

print("✅ [6/8] Tab Part 1 loaded (FIXED)")-- =========================================================
-- COSMIC HUB — BAGIAN 7/8 : TAB UI PART 2 (FIXED)
-- =========================================================

local C = _G.Cosmic_C
local S = _G.CosmicS
local SkyList = _G.Cosmic_SkyList

-- Komponen dari Bagian 5
local sec = _G.Cosmic_sec
local lbl = _G.Cosmic_lbl
local tog = _G.Cosmic_tog
local sl = _G.Cosmic_sl
local cpk = _G.Cosmic_cpk
local btn = _G.Cosmic_btn
local drp = _G.Cosmic_drp
local makeTab = _G.Cosmic_makeTab
local cs = _G.Cosmic_cs

local rnd = _G.Cosmic_rnd
local strk = _G.Cosmic_strk

-- ============================
-- TAB: VISUAL
-- ============================
makeTab("Visual", "🎨", 6, function()
    sec("Lighting", "☀️")
    tog("Fullbright", false, function(s)
        S.Fullbright = s
        if _G.Cosmic_applyFullbright then _G.Cosmic_applyFullbright(s) end
    end)
    sl("Fullbright Level (0-100)", 0, 100, 50, function(v)
        S.FullbrightVal = v
        if S.Fullbright and _G.Cosmic_applyFullbright then _G.Cosmic_applyFullbright(true) end
    end)
    tog("No Fog", false, function(s)
        S.NoFog = s
        if _G.Cosmic_applyNoFog then _G.Cosmic_applyNoFog(s) end
    end)

    sec("Sky Changer", "🌌")
    lbl("Klik sky untuk ganti", C.COSMIC2)
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
        rnd(btn2, 7)
        strk(btn2, C.COSMIC, 1, 0.6)

        local btnLbl = Instance.new("TextLabel")
        btnLbl.Size = UDim2.new(1, -10, 1, 0)
        btnLbl.Position = UDim2.new(0, 10, 0, 0)
        btnLbl.BackgroundTransparency = 1
        btnLbl.Text = "🌌 " .. skyName
        btnLbl.TextColor3 = C.TXT
        btnLbl.TextSize = 10
        btnLbl.Font = Enum.Font.GothamMedium
        btnLbl.TextXAlignment = Enum.TextXAlignment.Left
        btnLbl.Parent = btn2

        if S.SkyId == skyName then
            btn2.BackgroundColor3 = C.COSMIC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = C.STAR_BRIGHT
        end

        btn2.MouseButton1Click:Connect(function()
            S.SkyId = skyName
            if _G.Cosmic_applySky then _G.Cosmic_applySky(skyName) end
            for _, c in pairs(cs:GetChildren()) do
                if c:IsA("TextButton") and c.LayoutOrder > 300 and c.LayoutOrder < 400 then
                    c.BackgroundColor3 = C.BG
                    c.BackgroundTransparency = 0.4
                    local l = c:FindFirstChildOfClass("TextLabel")
                    if l then l.TextColor3 = C.TXT end
                end
            end
            btn2.BackgroundColor3 = C.COSMIC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = C.STAR_BRIGHT
        end)
    end

    sec("Camera FOV", "📸")
    tog("Enable FOV", false, function(s)
        S.FOVEnabled = s
        if _G.Cosmic_applyFOV then _G.Cosmic_applyFOV() end
    end)
    sl("FOV Value", 40, 120, 70, function(v)
        S.FOV = v
        if _G.Cosmic_applyFOV then _G.Cosmic_applyFOV() end
    end)

    sec("Zoom Out", "🔍")
    tog("Zoom Out Unlimited", false, function(s)
        S.ZoomOut = s
        if _G.Cosmic_applyZoomOut then _G.Cosmic_applyZoomOut(s, S.ZoomOutValue) end
    end)
    sl("Max Zoom Distance", 100, 5000, 500, function(v)
        S.ZoomOutValue = v
        if S.ZoomOut and _G.Cosmic_applyZoomOut then _G.Cosmic_applyZoomOut(true, v) end
    end)
end)

-- ============================
-- TAB: HD GRAPHICS
-- ============================
makeTab("HD Graphics", "💎", 7, function()
    sec("Bloom", "✨")
    tog("Enable Bloom", false, function(s)
        S.Bloom = s
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)
    sl("Bloom Intensity", 0, 3, 0.6, function(v)
        S.BloomIntensity = v
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)
    sl("Bloom Size", 0, 60, 24, function(v)
        S.BloomSize = v
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)
    sl("Bloom Threshold", 0, 2, 0.9, function(v)
        S.BloomThreshold = v
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)

    sec("Sun Rays", "🌞")
    tog("Enable Sun Rays", false, function(s)
        S.SunRays = s
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)
    sl("Sun Rays Intensity", 0, 1, 0.15, function(v)
        S.SunRaysIntensity = v
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)
    sl("Sun Rays Spread", 0, 2, 1, function(v)
        S.SunRaysSpread = v
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)

    sec("Depth of Field", "🎬")
    tog("Enable DOF", false, function(s)
        S.DOF = s
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)
    sl("Focus Distance", 0, 5, 0.5, function(v)
        S.DOFFocus = v
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)
    sl("Near Intensity", 0, 1, 0.1, function(v)
        S.DOFNear = v
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)
    sl("Far Intensity", 0, 1, 1, function(v)
        S.DOFFar = v
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)

    sec("Sharpen (Contrast)", "🔪")
    tog("Enable Sharpen", false, function(s)
        S.Sharpen = s
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)
    sl("Sharpen Amount", 0, 1, 0.5, function(v)
        S.SharpenAmount = v
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)

    sec("Cinematic Mode", "🎥")
    tog("Enable Cinematic", false, function(s)
        S.Cinematic = s
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)
    lbl("Bar film + tint cinematic", C.COSMIC2)

    sec("Atmosphere HD", "🌫️")
    tog("Enable Atmosphere", false, function(s)
        S.Atmosphere = s
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)
    sl("Density", 0, 1, 0.3, function(v)
        S.AtmosphereDensity = v
        if _G.Cosmic_applyHD then _G.Cosmic_applyHD() end
    end)
    lbl("Atmosphere warna galaxy", C.COSMIC2)
end)

-- ============================
-- TAB: 8-BIT CROWN
-- ============================
makeTab("8-Bit Crown", "👑", 8, function()
    sec("Enable Crown", "👑")
    tog("👑 Enable 8-Bit Crown", false, function(s)
        S.EightBitCrown = s
        if _G.Cosmic_apply8BitCrown then
            _G.Cosmic_apply8BitCrown(s, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
        end
    end)
    lbl("Mahkota + partikel galaxy", C.COSMIC2)

    sec("Ukuran Crown", "📏")
    sl("Size", 0.3, 3, 1, function(v)
        S.EightBitSize = v
        if S.EightBitCrown and _G.Cosmic_apply8BitCrown then
            _G.Cosmic_apply8BitCrown(true, v, S.CrownX, S.CrownY, S.CrownZ)
        end
    end)

    sec("Posisi X (Kiri-Kanan)", "↔️")
    sl("X Position", -3, 3, 0, function(v)
        S.CrownX = v
        if S.EightBitCrown and _G.Cosmic_apply8BitCrown then
            _G.Cosmic_apply8BitCrown(true, S.EightBitSize, v, S.CrownY, S.CrownZ)
        end
    end)

    sec("Posisi Y (Atas-Bawah)", "↕️")
    sl("Y Position", -2, 3, 1.2, function(v)
        S.CrownY = v
        if S.EightBitCrown and _G.Cosmic_apply8BitCrown then
            _G.Cosmic_apply8BitCrown(true, S.EightBitSize, S.CrownX, v, S.CrownZ)
        end
    end)

    sec("Posisi Z (Depan-Belakang)", "🔃")
    sl("Z Position", -3, 3, 0, function(v)
        S.CrownZ = v
        if S.EightBitCrown and _G.Cosmic_apply8BitCrown then
            _G.Cosmic_apply8BitCrown(true, S.EightBitSize, S.CrownX, S.CrownY, v)
        end
    end)

    sec("Quick Position", "🎯")
    btn("⬆️ Ke Atas", function()
        S.CrownY = (S.CrownY or 1.2) + 0.3
        if _G.Cosmic_apply8BitCrown then
            _G.Cosmic_apply8BitCrown(true, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
        end
    end)
    btn("⬇️ Ke Bawah", function()
        S.CrownY = (S.CrownY or 1.2) - 0.3
        if _G.Cosmic_apply8BitCrown then
            _G.Cosmic_apply8BitCrown(true, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
        end
    end)
    btn("⬅️ Ke Kiri", function()
        S.CrownX = (S.CrownX or 0) - 0.3
        if _G.Cosmic_apply8BitCrown then
            _G.Cosmic_apply8BitCrown(true, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
        end
    end)
    btn("➡️ Ke Kanan", function()
        S.CrownX = (S.CrownX or 0) + 0.3
        if _G.Cosmic_apply8BitCrown then
            _G.Cosmic_apply8BitCrown(true, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
        end
    end)
    btn("🔄 Reset Posisi", function()
        S.CrownX = 0; S.CrownY = 1.2; S.CrownZ = 0
        if _G.Cosmic_apply8BitCrown then
            _G.Cosmic_apply8BitCrown(true, S.EightBitSize, 0, 1.2, 0)
        end
    end)
end)

-- ============================
-- TAB: VISUAL+
-- ============================
makeTab("Visual+", "✨", 9, function()
    sec("Trail Fire", "🔥")
    tog("Enable Trail Fire", false, function(s)
        S.Trail = s
        if _G.Cosmic_applyTrail then _G.Cosmic_applyTrail(s, S.TrailColor) end
    end)
    cpk("Trail Color", S.TrailColor, function(c)
        S.TrailColor = c
        if S.Trail and _G.Cosmic_applyTrail then _G.Cosmic_applyTrail(true, c) end
    end)

    sec("Aura Fire", "🔥")
    tog("Enable Aura Fire", false, function(s)
        S.Aura = s
        if _G.Cosmic_applyAura then _G.Cosmic_applyAura(s, S.AuraColor) end
    end)
    cpk("Aura Color", S.AuraColor, function(c)
        S.AuraColor = c
        if S.Aura and _G.Cosmic_applyAura then _G.Cosmic_applyAura(true, c) end
    end)

    sec("Kill Effect", "💥")
    tog("Enable Kill Effect", false, function(s) S.KillEffect = s end)

    sec("Crosshair", "➕")
    tog("Enable Crosshair", false, function(s)
        S.Crosshair = s
        if _G.Cosmic_applyCrosshair then
            _G.Cosmic_applyCrosshair(s, S.CrosshairStyle, S.CrosshairColor, S.CrosshairSize, S.CrosshairThick, S.CrosshairX, S.CrosshairY)
        end
    end)
    drp("Style", {"Plus", "Dot", "Circle"}, "Plus", function(v)
        S.CrosshairStyle = v
        if S.Crosshair and _G.Cosmic_applyCrosshair then
            _G.Cosmic_applyCrosshair(true, v, S.CrosshairColor, S.CrosshairSize, S.CrosshairThick, S.CrosshairX, S.CrosshairY)
        end
    end)
    cpk("Crosshair Color", S.CrosshairColor, function(c)
        S.CrosshairColor = c
        if S.Crosshair and _G.Cosmic_applyCrosshair then
            _G.Cosmic_applyCrosshair(true, S.CrosshairStyle, c, S.CrosshairSize, S.CrosshairThick, S.CrosshairX, S.CrosshairY)
        end
    end)
    sl("Size", 3, 30, 8, function(v)
        S.CrosshairSize = v
        if S.Crosshair and _G.Cosmic_applyCrosshair then
            _G.Cosmic_applyCrosshair(true, S.CrosshairStyle, S.CrosshairColor, v, S.CrosshairThick, S.CrosshairX, S.CrosshairY)
        end
    end)
    sl("Thickness", 1, 6, 2, function(v)
        S.CrosshairThick = v
        if S.Crosshair and _G.Cosmic_applyCrosshair then
            _G.Cosmic_applyCrosshair(true, S.CrosshairStyle, S.CrosshairColor, S.CrosshairSize, v, S.CrosshairX, S.CrosshairY)
        end
    end)
    sl("Offset X", -100, 100, 0, function(v)
        S.CrosshairX = v
        if S.Crosshair and _G.Cosmic_applyCrosshair then
            _G.Cosmic_applyCrosshair(true, S.CrosshairStyle, S.CrosshairColor, S.CrosshairSize, S.CrosshairThick, v, S.CrosshairY)
        end
    end)
    sl("Offset Y", -100, 100, 0, function(v)
        S.CrosshairY = v
        if S.Crosshair and _G.Cosmic_applyCrosshair then
            _G.Cosmic_applyCrosshair(true, S.CrosshairStyle, S.CrosshairColor, S.CrosshairSize, S.CrosshairThick, S.CrosshairX, v)
        end
    end)
end)

-- ============================
-- TAB: MOVEMENT
-- ============================
makeTab("Movement", "🏃", 10, function()
    sec("Walk Speed", "⚡")
    tog("Enable Walk Speed", false, function(s)
        S.WalkSpeed = s
        if not s then
            local LP = _G.Cosmic_LP
            if LP.Character then
                local hum = LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 16 end
            end
        end
    end)
    sl("Speed Value", 16, 200, 17.6, function(v) S.WalkSpeedVal = v end)

    sec("Jump Power", "🦘")
    tog("Enable Jump Power", false, function(s)
        S.JumpPower = s
        if not s then
            local LP = _G.Cosmic_LP
            if LP.Character then
                local hum = LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.JumpPower = 50 end
            end
        end
    end)
    sl("Jump Power Value", 0, 300, 50, function(v) S.JumpPowerVal = v end)

    sec("No Clip", "👻")
    tog("Enable No Clip", false, function(s) S.NoClip = s end)
    tog("No Clip Camera", false, function(s) S.NoClipCamera = s end)

    sec("Fly", "🕊️")
    tog("Enable Fly", false, function(s)
        S.Fly = s
        if s then
            if _G.Cosmic_startFly then _G.Cosmic_startFly() end
        else
            if _G.Cosmic_stopFly then _G.Cosmic_stopFly() end
        end
    end)
    sl("Fly Speed", 10, 200, 50, function(v) S.FlySpeed = v end)
    lbl("WASD + Space (naik) + LShift (turun)", C.COSMIC2)
end)

-- ============================
-- TAB: TELEPORT
-- ============================
makeTab("Teleport", "🌀", 11, function()
    sec("Teleport Finish", "🚪")
    btn("🚀 Instant Escape (TP Finish)", function()
        if _G.Cosmic_teleportToFinishLine then _G.Cosmic_teleportToFinishLine() end
    end)

    sec("Teleport Gate", "🌀")
    btn("🌀 TP ke Gate", function()
        if _G.Cosmic_teleportToGate then _G.Cosmic_teleportToGate() end
    end)
    btn("🚪 TP ke DALAM Gate", function()
        if _G.Cosmic_teleportInsideGate then _G.Cosmic_teleportInsideGate() end
    end)
end)

-- ============================
-- TAB: MISC
-- ============================
makeTab("Misc", "🏆", 12, function()
    sec("Fast Vault", "🏃")
    tog("Enable Fast Vault", false, function(s) S.FastVault = s end)
    sl("Animation Speed", 1, 5, 1.2, function(v) S.FastVaultSpeed = v end)

    sec("Moonwalk", "🕺")
    tog("Enable Moonwalk", false, function(s) S.Moonwalk = s end)
    sl("Spam Speed", 1, 50, 30, function(v) S.MoonwalkSpam = v end)
    sl("Intensity", 1, 50, 35, function(v) S.MoonwalkIntensity = v end)
    lbl("Auto-stop saat parry", C.COSMIC2)
end)

-- ============================
-- TAB: SETTINGS
-- ============================
makeTab("Settings", "⚙️", 13, function()
    sec("FPS & Ping Panel", "📊")
    tog("Show FPS/Ping", true, function(s)
        S.ShowFPS = s
        if _G.Cosmic_fpsPanel then
            _G.Cosmic_fpsPanel.Enabled = s
        end
    end)
    lbl("Posisi: Kiri Atas", C.COSMIC2)

    sec("Keybind", "⌨️")
    lbl("Klik 🌌 = Buka Menu", C.COSMIC2)
    lbl("Drag 🌌 = Pindah posisi", C.DIM)
    lbl("HOLD 🎯 = Aim aktif", C.COSMIC2)
    lbl("Klik kanan 🎯 = Switch mode", C.DIM)
    lbl("RightShift = Toggle Menu", C.COSMIC2)

    sec("Info", "ℹ️")
    lbl("🌌 COSMIC HUB — Galaxy Edition v1", C.STAR)
    lbl("60 Fire + 20 Fire Feet", C.COSMIC2)
    lbl("ESP Unlimited Radius", C.GRN)
    lbl("Parry Stabil + Debounce", C.GRN)
    lbl("Skill Check Stabil", C.GRN)
    lbl("Aimlock + Aimbot (Hold to Aim)", C.COSMIC2)
    lbl("HD Graphics (Bloom, DOF, dll)", C.COSMIC2)
    lbl("Lightweight & Smooth", C.GRN)

    sec("Credits", "💜")
    lbl("Cosmic Hub Team", C.COSMIC)
    lbl("Galaxy Edition", C.STAR)
end)

print("✅ [7/8] Tab Part 2 loaded (FIXED)")-- =========================================================
-- COSMIC HUB — BAGIAN 8/8 : RESPAWN + FINAL INIT (FIXED)
-- =========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LP = _G.Cosmic_LP
local PG = _G.Cosmic_PG
local C = _G.Cosmic_C

local S = _G.CosmicS
local gui = _G.Cosmic_gui
local panel = _G.Cosmic_panel
local sb = _G.Cosmic_sb

-- ============================
-- RESPAWN HANDLER
-- ============================
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)

    -- Reset parry hooks (kosongin isi, jangan replace)
    if _G.CosmicHookKiller then
        for k in pairs(_G.CosmicHookKiller) do
            _G.CosmicHookKiller[k] = nil
        end
    end

    -- Auto re-apply semua fitur
    if S.FireOn and _G.Cosmic_applyFire then pcall(_G.Cosmic_applyFire) end
    if S.FireFeetOn and _G.Cosmic_applyFireFeet then pcall(_G.Cosmic_applyFireFeet) end

    if S.EightBitCrown and _G.Cosmic_apply8BitCrown then
        task.wait(0.3)
        pcall(function()
            _G.Cosmic_apply8BitCrown(true, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
        end)
    end

    if S.Trail and _G.Cosmic_applyTrail then
        task.wait(0.3)
        pcall(function() _G.Cosmic_applyTrail(true, S.TrailColor) end)
    end

    if S.Aura and _G.Cosmic_applyAura then
        task.wait(0.3)
        pcall(function() _G.Cosmic_applyAura(true, S.AuraColor) end)
    end

    if S.Crosshair and _G.Cosmic_applyCrosshair then
        task.wait(0.3)
        pcall(function()
            _G.Cosmic_applyCrosshair(true, S.CrosshairStyle, S.CrosshairColor, S.CrosshairSize, S.CrosshairThick, S.CrosshairX, S.CrosshairY)
        end)
    end

    if S.ZoomOut and _G.Cosmic_applyZoomOut then
        task.wait(0.3)
        pcall(function() _G.Cosmic_applyZoomOut(true, S.ZoomOutValue) end)
    end

    if S.Fullbright and _G.Cosmic_applyFullbright then
        task.wait(0.3)
        pcall(function() _G.Cosmic_applyFullbright(true) end)
    end

    if S.NoFog and _G.Cosmic_applyNoFog then
        task.wait(0.3)
        pcall(function() _G.Cosmic_applyNoFog(true) end)
    end

    if S.FOVEnabled and _G.Cosmic_applyFOV then
        task.wait(0.3)
        pcall(function() _G.Cosmic_applyFOV() end)
    end

    if (S.Bloom or S.SunRays or S.DOF or S.Sharpen or S.Cinematic or S.Atmosphere) and _G.Cosmic_applyHD then
        task.wait(0.3)
        pcall(_G.Cosmic_applyHD)
    end

    if _G.CosmicParry.Enabled and _G.Cosmic_scanKillers then
        task.wait(0.5)
        pcall(_G.Cosmic_scanKillers)
    end
end)

-- ============================
-- ANTI-RESET TOGGLE SYNC
-- ============================
task.spawn(function()
    while task.wait(0.4) do
        if not gui or not gui.Parent then break end
        for name, state in pairs(_G.CosmicToggle) do
            if name == "Enable Fire" and S.FireOn ~= state then
                S.FireOn = state
                if _G.Cosmic_applyFire then pcall(_G.Cosmic_applyFire) end
            end
            if name == "Enable Fire Feet" and S.FireFeetOn ~= state then
                S.FireFeetOn = state
                if _G.Cosmic_applyFireFeet then pcall(_G.Cosmic_applyFireFeet) end
            end
            if name == "👑 Enable 8-Bit Crown" and S.EightBitCrown ~= state then
                S.EightBitCrown = state
                if _G.Cosmic_apply8BitCrown then
                    pcall(function()
                        _G.Cosmic_apply8BitCrown(state, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
                    end)
                end
            end
            if name == "Enable Trail Fire" and S.Trail ~= state then
                S.Trail = state
                if _G.Cosmic_applyTrail then
                    pcall(function() _G.Cosmic_applyTrail(state, S.TrailColor) end)
                end
            end
            if name == "Enable Aura Fire" and S.Aura ~= state then
                S.Aura = state
                if _G.Cosmic_applyAura then
                    pcall(function() _G.Cosmic_applyAura(state, S.AuraColor) end)
                end
            end
            if name == "Fullbright" and S.Fullbright ~= state then
                S.Fullbright = state
                if _G.Cosmic_applyFullbright then
                    pcall(function() _G.Cosmic_applyFullbright(state) end)
                end
            end
            if name == "No Fog" and S.NoFog ~= state then
                S.NoFog = state
                if _G.Cosmic_applyNoFog then
                    pcall(function() _G.Cosmic_applyNoFog(state) end)
                end
            end
            if name == "Enable FOV" and S.FOVEnabled ~= state then
                S.FOVEnabled = state
                if _G.Cosmic_applyFOV then
                    pcall(function() _G.Cosmic_applyFOV() end)
                end
            end
            if name == "Enable Auto Parry" and _G.CosmicParry.Enabled ~= state then
                _G.CosmicParry.Enabled = state
                if state and _G.Cosmic_scanKillers then pcall(_G.Cosmic_scanKillers) end
            end
            if name == "Enable Skill Check" and _G.CosmicSkill.Enabled ~= state then
                _G.CosmicSkill.Enabled = state
            end
            if name == "Perfect Mode" and _G.CosmicSkill.PerfectMode ~= state then
                _G.CosmicSkill.PerfectMode = state
            end
            if name == "Enable Aimlock" and _G.CosmicAimlock.Enabled ~= state then
                _G.CosmicAimlock.Enabled = state
            end
            if name == "Show Aimlock Button" and _G.CosmicAimlock.ShowButton ~= state then
                _G.CosmicAimlock.ShowButton = state
                if _G.Cosmic_setAimlockVisible then _G.Cosmic_setAimlockVisible(state) end
            end
        end
    end
end)

-- ============================
-- HD EFFECT AUTO RE-APPLY
-- ============================
Lighting.ChildRemoved:Connect(function(child)
    if not _G.Cosmic_hdEffects then return end
    for name, eff in pairs(_G.Cosmic_hdEffects) do
        if eff == child then
            _G.Cosmic_hdEffects[name] = nil
        end
    end
    task.wait(0.5)
    if (S.Bloom or S.SunRays or S.DOF or S.Sharpen or S.Cinematic or S.Atmosphere) and _G.Cosmic_applyHD then
        pcall(_G.Cosmic_applyHD)
    end
end)

-- ============================
-- KEYBIND RightShift
-- ============================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if panel then
            panel.Visible = not panel.Visible
        end
    end
end)

-- ============================
-- BUKA TAB PERTAMA (Fire)
-- ============================
task.wait(0.3)
if sb then
    for _, c in pairs(sb:GetChildren()) do
        if c:IsA("TextButton") then
            c.MouseButton1Click:Fire()
            break
        end
    end
end

-- =========================================================
-- FINAL PRINT
-- =========================================================
print("=====================================================")
print("🌌 COSMIC HUB — GALAXY EDITION v1")
print("✅ FULL SUCCESS — ALL FEATURES LOADED!")
print("=====================================================")
print("📋 DAFTAR TAB:")
print("  1.  🔥 Fire            — 60 Efek + Size Slider")
print("  2.  👟 Fire Feet       — 20 Efek")
print("  3.  👁️ ESP             — Player + Object + Status (Unlimited)")
print("  4.  🏃 Survivor        — Parry + Skill Check + Aimlock/Aimbot")
print("  5.  🔪 Killer          — Auto Attack + Kill All + Hitbox + Masked")
print("  6.  🎨 Visual          — Fullbright + Sky Galaxy + FOV + Zoom")
print("  7.  💎 HD Graphics     — Bloom, SunRays, DOF, Sharpen, Cinematic, Atmosphere")
print("  8.  👑 8-Bit Crown     — X, Y, Z, Size terpisah")
print("  9.  ✨ Visual+         — Trail + Aura + Crosshair + Kill Effect")
print(" 10.  🏃 Movement        — WalkSpeed + JumpPower + NoClip + Fly")
print(" 11.  🌀 Teleport        — Finish + Gate + Inside Gate")
print(" 12.  🏆 Misc            — Fast Vault + Moonwalk")
print(" 13.  ⚙️ Settings        — FPS Panel + Info + Credits")
print("=====================================================")
print("🎯 AUTO PARRY STABIL:")
print("   • Debounce 0.2s (gak spam)")
print("   • Face check slider (-1 = 360°)")
print("   • Predict opsional")
print("   • AnimationPlayed (bukan polling lag)")
print("=====================================================")
print("🎯 AUTO SKILL CHECK:")
print("   • RenderStepped (smooth)")
print("   • Zona +102~+116")
print("   • Perfect Mode tersedia")
print("=====================================================")
print("👁️ ESP SYSTEM:")
print("   • Survivor + Killer UNLIMITED radius")
print("   • Generator progress live")
print("   • Status ESP (nama, dist, HP)")
print("=====================================================")
print("🎯 AIMLOCK / AIMBOT:")
print("   • Hold-to-Aim (tombol 🎯)")
print("   • Mode Killer / Survivor")
print("   • Auto-Attack toggle")
print("   • Smoothness + Predict bisa diatur")
print("=====================================================")
print("💎 HD GRAPHICS:")
print("   • Bloom + Sun Rays + DOF")
print("   • Sharpen + Cinematic + Atmosphere")
print("=====================================================")
print("🌌 TOMBOL MENU GALAXY (KECIL + BISA DIGESER)")
print("📊 FPS/PING PANEL di KIRI ATAS")
print("=====================================================")
print("🌌 Cara pakai:")
print("   1. Klik tombol 🌌 (kiri atas) untuk buka menu")
print("   2. Atau tekan RightShift")
print("   3. HOLD tombol 🎯 untuk aimlock")
print("=====================================================")
print("Total: 70+ FITUR PREMIUM — LIGHTWEIGHT")
print("🌌 Cosmic Hub — Made with 💜")
print("=====================================================")
