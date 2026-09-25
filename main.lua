-- =========================================================
-- ROOORHUB GALAXY v3.2 - FULL + EXECUTE ANIM
-- BAGIAN 1/6 : LOADING + CONFIG + STATE
-- =========================================================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

C = {
    BG = Color3.fromRGB(8, 5, 20),
    BG2 = Color3.fromRGB(15, 8, 35),
    PANEL = Color3.fromRGB(18, 10, 40),
    PANEL2 = Color3.fromRGB(28, 15, 55),
    ACC = Color3.fromRGB(120, 60, 255),
    ACC2 = Color3.fromRGB(0, 230, 255),
    ACC3 = Color3.fromRGB(255, 80, 200),
    ACC4 = Color3.fromRGB(255, 200, 80),
    GOLD = Color3.fromRGB(255, 215, 0),
    FIRE_BRIGHT = Color3.fromRGB(220, 180, 255),
    TXT = Color3.fromRGB(240, 240, 255),
    DIM = Color3.fromRGB(130, 120, 180),
    GRN = Color3.fromRGB(0, 255, 150),
    RED = Color3.fromRGB(255, 70, 100),
}

function rnd(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = o
end

function strk(o, col, t, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or C.GOLD
    s.Thickness = t or 1.5
    s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = o
    return s
end

local BruhSoundId = "rbxassetid://9120386436"
function playToggleSound()
    task.spawn(function()
        pcall(function()
            local s = Instance.new("Sound")
            s.SoundId = BruhSoundId
            s.Volume = 0.5
            s.Parent = SoundService
            s:Play()
            task.wait(2)
            s:Destroy()
        end)
    end)
end
_G.Roooor_playSound = playToggleSound

-- LOADING GALAXY (1 detik)
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "RoooorLoading"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 2147483647
loadingGui.Parent = PG

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(5, 3, 15)
bg.BorderSizePixel = 0
bg.Parent = loadingGui

local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 8, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 5, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 8, 50)),
})
bgGrad.Parent = bg

task.spawn(function()
    while bg.Parent do
        for i = 0, 360, 4 do
            if not bg.Parent then break end
            bgGrad.Rotation = i
            task.wait(0.03)
        end
    end
end)

for i = 1, 30 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
    p.Position = UDim2.new(math.random(), 0, 1.1, 0)
    p.BackgroundColor3 = Color3.fromHSV(math.random(), 0.7, 1)
    p.BorderSizePixel = 0
    p.Parent = bg
    rnd(p, 999)
    task.spawn(function()
        while p.Parent do
            local speed = math.random(5, 15) / 1000
            p.Position = UDim2.new(p.Position.X.Scale, p.Position.X.Offset, p.Position.Y.Scale - speed, 0)
            p.BackgroundTransparency = p.BackgroundTransparency + 0.008
            if p.BackgroundTransparency >= 1 or p.Position.Y.Scale < -0.1 then
                p.Position = UDim2.new(math.random(), 0, 1.1, 0)
                p.BackgroundTransparency = 0
                p.BackgroundColor3 = Color3.fromHSV(math.random(), 0.7, 1)
            end
            task.wait(0.05)
        end
    end)
end

local ringContainer = Instance.new("Frame")
ringContainer.Size = UDim2.new(0, 240, 0, 240)
ringContainer.Position = UDim2.new(0.5, -120, 0.5, -180)
ringContainer.BackgroundTransparency = 1
ringContainer.Parent = bg

local rings = {}
for i = 1, 4 do
    local ring = Instance.new("Frame")
    local ringSize = 200 - (i-1) * 40
    ring.Size = UDim2.new(0, ringSize, 0, ringSize)
    ring.Position = UDim2.new(0.5, -ringSize/2, 0.5, -ringSize/2)
    ring.BackgroundTransparency = 1
    ring.Parent = ringContainer
    local rStrk = Instance.new("UIStroke")
    rStrk.Thickness = 4 - (i-1) * 0.5
    rStrk.Color = C.ACC2
    rStrk.Transparency = 0.05 + (i-1) * 0.12
    rStrk.Parent = ring
    local rGrad = Instance.new("UIGradient")
    rGrad.Color = ColorSequence.new({C.ACC, C.ACC2, C.ACC3})
    rGrad.Parent = rStrk
    table.insert(rings, {ring = ring, grad = rGrad, speed = 40 + i * 25, dir = i % 2 == 0 and -1 or 1})
end

local core = Instance.new("Frame")
core.Size = UDim2.new(0, 80, 0, 80)
core.Position = UDim2.new(0.5, -40, 0.5, -40)
core.BackgroundColor3 = C.ACC2
core.Parent = ringContainer
rnd(core, 999)

local coreIcon = Instance.new("TextLabel")
coreIcon.Size = UDim2.new(1, 0, 1, 0)
coreIcon.BackgroundTransparency = 1
coreIcon.Text = "✨"
coreIcon.TextSize = 44
coreIcon.Font = Enum.Font.GothamBlack
coreIcon.Parent = core

local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Size = UDim2.new(1, 0, 0, 70)
welcomeTitle.Position = UDim2.new(0, 0, 0.32, 0)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.Text = "SELAMAT DATANG"
welcomeTitle.TextColor3 = Color3.new(1, 1, 1)
welcomeTitle.TextSize = 48
welcomeTitle.Font = Enum.Font.GothamBlack
welcomeTitle.TextStrokeTransparency = 0
welcomeTitle.TextStrokeColor3 = C.ACC
welcomeTitle.Parent = bg

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 100)
subtitle.Position = UDim2.new(0, 0, 0.53, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "ROOORHUB GALAXY"
subtitle.TextColor3 = C.ACC2
subtitle.TextSize = 68
subtitle.Font = Enum.Font.GothamBlack
subtitle.TextStrokeTransparency = 0
subtitle.TextStrokeColor3 = C.ACC
subtitle.Parent = bg

local tagline = Instance.new("TextLabel")
tagline.Size = UDim2.new(1, 0, 0, 30)
tagline.Position = UDim2.new(0, 0, 0.73, 20)
tagline.BackgroundTransparency = 1
tagline.Text = "✨ SC PENGANGGURAN ✨"
tagline.TextColor3 = C.ACC2
tagline.TextSize = 16
tagline.Font = Enum.Font.GothamBold
tagline.TextStrokeTransparency = 0.3
tagline.TextStrokeColor3 = C.ACC
tagline.Parent = bg

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 420, 0, 6)
progressBar.Position = UDim2.new(0.5, -210, 0.9, 20)
progressBar.BackgroundColor3 = Color3.fromRGB(30, 15, 50)
progressBar.BorderSizePixel = 0
progressBar.Parent = bg
rnd(progressBar, 3)
strk(progressBar, C.ACC2, 1.5, 0.3)

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = C.ACC2
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBar
rnd(progressFill, 3)

task.spawn(function()
    local t = 0
    while bg.Parent do
        t = t + 0.025
        for _, data in ipairs(rings) do
            data.ring.Rotation = t * data.speed * data.dir
            data.grad.Rotation = t * 90 * data.dir
        end
        local pulse = 1 + math.sin(t * 4) * 0.15
        core.Size = UDim2.new(0, 80 * pulse, 0, 80 * pulse)
        core.Position = UDim2.new(0.5, -40 * pulse, 0.5, -40 * pulse)
        core.Rotation = t * 50
        task.wait(0.025)
    end
end)

task.spawn(function()
    for i = 0, 1, 0.02 do
        if not bg.Parent then break end
        progressFill.Size = UDim2.new(i, 0, 1, 0)
        task.wait(0.03)
    end
end)

task.delay(1.0, function()
    TweenService:Create(bg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    for _, el in pairs(bg:GetDescendants()) do
        pcall(function()
            if el:IsA("TextLabel") then
                TweenService:Create(el, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
            elseif el:IsA("Frame") then
                TweenService:Create(el, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
            elseif el:IsA("UIStroke") then
                TweenService:Create(el, TweenInfo.new(0.4), {Transparency = 1}):Play()
            end
        end)
    end
    task.wait(0.45)
    loadingGui:Destroy()
    print("[RoooorHub] ✅ Loading GUI destroyed")
end)

-- STATE
_G.RoooorS = _G.RoooorS or {
    FireOn = false, FireType = "Classic", FireSize = 5,
    FireFeetOn = false, FireFeetType = "Classic",
    DodgeRange = 15, AbyssDodge = false,
    ParryCircle = false, ParryCircleSize = 15,
    WalkSpeed = false, WalkSpeedVal = 16, WalkSpeedBoost = 0,
    SpeedHack = false, SpeedHackVal = 40,
    NoClip = false, Korblox = false, Headless = false,
    Killer_AutoAtk = false, Killer_AtkDelay = 0.35, Killer_KillAll = false,
    MaskedPower = "Cobra", AutoVault = false, InstantInteract = false,
    EightBitCrown = false, EightBitSize = 1, CrownX = 0, CrownY = 1.2, CrownZ = 0,
    Trail = false, TrailColor = Color3.fromRGB(120, 60, 255),
    Aura = false, AuraColor = Color3.fromRGB(120, 60, 255),
    KillEffect = false, Crosshair = false, CrosshairColor = Color3.fromRGB(0, 230, 255), CrosshairSize = 8,
    NoClipCamera = false, ZoomOut = false, ZoomOutValue = 500,
    Fullbright = false, FullbrightVal = 50, NoFog = false,
    UltraHD = false, Contrast = false, ContrastVal = 0.3, SaturationVal = 0.2,
    FOV = 70, FOVEnabled = false, SkyId = "Default",
    Bloom = false, BloomIntensity = 1.2, BloomSize = 24, BloomThreshold = 0.8,
    SunRays = false, SunRaysIntensity = 0.15, SunRaysSpread = 1,
    DepthOfField = false, DOFFocusDistance = 20, DOFInFocusRadius = 30, DOFFarIntensity = 0.3,
    Sharpen = false, SharpenAmount = 0.35,
    Cinematic = false, CinematicBarSize = 40, CinematicVignette = 0.4,
    AtmosphereHD = false, AtmosphereDensity = 0.3, AtmosphereHaze = 1.5, AtmosphereGlare = 0.2,
    AutoHeal = false, AutoHealThreshold = 40,
    AutoRepair = false, AutoRevive = false, AutoDodge = false,
    AntiGrab = false, AntiHook = false, AntiBlind = false, AntiStun = false,
    AntiRagdoll = false, AntiSlow = false, AntiAFK = false,
    SafeZone = false, EscapeAlert = false, EscapeAlertRange = 60,
    Fly = false, FlySpeed = 50,
    KillFeed = false, StunNotify = false,
    ExecuteAnim = true,
}
S = _G.RoooorS

_G.ToggleStates = _G.ToggleStates or {}
_G.SliderStates = _G.SliderStates or {}

ESP = _G.Roooor_ESP or {
    Survivor = false, Killer = false, Generator = false,
    Pallet = false, Window = false, SCP = false, Distance = 50,
}
_G.Roooor_ESP = ESP

ESPStatus = _G.Roooor_ESPStatus or {
    Enabled = false, ShowName = true, ShowDistance = true, ShowHealth = false, Radius = 50,
}
_G.Roooor_ESPStatus = ESPStatus

TeamColors = _G.Roooor_TeamColors or {
    Killer = Color3.fromRGB(255, 60, 60),
    Survivor = Color3.fromRGB(60, 255, 120),
}
_G.Roooor_TeamColors = TeamColors

AutoParry = _G.Roooor_AutoParry or {
    Enabled = false, ParryDistance = 15, ParryDelay = 0, Cooldown = 1,
    FaceSensitivity = -1, RequireFacing = false, Wiggle = false, WiggleSpam = 5,
}
_G.Roooor_AutoParry = AutoParry

SkillCheck = _G.Roooor_SkillCheck or { Enabled = false }
_G.Roooor_SkillCheck = SkillCheck

Combat = _G.Roooor_Combat or {
    AimlockEnabled = true,
    Holding = false,
    Mode = "Killer",
    Smoothness = 0.35,
    LockRadius = 300,
    AimPart = "Head",
    Predict = true,
    PredictStrength = 0.15,
    VisibilityCheck = false,
    WallCheck = false,
    FOVCircle = false,
    FOVRadius = 150,
    TriggerBotEnabled = false,
    TriggerDelay = 0.05,
    HitboxSurvivor = false,
    HitboxKiller = false,
    HitboxSize = 15,
    HitboxVisible = false,
}
_G.Roooor_Combat = Combat

print("✅ [1/6] Loading + Config + State loaded")-- =========================================================
-- BAGIAN 2/6 : FIRE CONFIG + SKY + KILLER ANIMS
-- =========================================================

FireList = {
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

FireConfig = {
    Classic = { c1 = Color3.fromRGB(120, 60, 255), c2 = Color3.fromRGB(0, 230, 255) },
    HellFire = { c1 = Color3.fromRGB(180, 0, 0), c2 = Color3.fromRGB(255, 80, 0), smoke = true },
    IceFire = { c1 = Color3.fromRGB(120, 200, 255), c2 = Color3.fromRGB(220, 240, 255), spark = true },
    ToxicFire = { c1 = Color3.fromRGB(0, 255, 50), c2 = Color3.fromRGB(180, 255, 0), smoke = true },
    VoidFire = { c1 = Color3.fromRGB(100, 0, 180), c2 = Color3.fromRGB(220, 50, 255), spark = true },
    GoldenKing = { c1 = Color3.fromRGB(255, 215, 0), c2 = Color3.fromRGB(255, 255, 120), spark = true },
    SakuraFire = { c1 = Color3.fromRGB(255, 150, 200), c2 = Color3.fromRGB(255, 220, 240), spark = true },
    EmeraldFire = { c1 = Color3.fromRGB(0, 220, 100), c2 = Color3.fromRGB(120, 255, 170) },
    BloodFire = { c1 = Color3.fromRGB(220, 0, 0), c2 = Color3.fromRGB(120, 0, 0), smoke = true },
    ShadowFire = { c1 = Color3.fromRGB(30, 30, 40), c2 = Color3.fromRGB(100, 0, 130), smoke = true },
    HolyFire = { c1 = Color3.fromRGB(255, 255, 255), c2 = Color3.fromRGB(255, 255, 220), spark = true },
    OceanFire = { c1 = Color3.fromRGB(0, 120, 255), c2 = Color3.fromRGB(120, 220, 255) },
    Firework = { c1 = Color3.fromRGB(255, 0, 120), c2 = Color3.fromRGB(255, 220, 50), rainbow = true, spark = true },
    Lava = { c1 = Color3.fromRGB(255, 100, 0), c2 = Color3.fromRGB(120, 30, 0), smoke = true },
    GhostFire = { c1 = Color3.fromRGB(200, 200, 255), c2 = Color3.fromRGB(255, 255, 255) },
    CosmicFire = { c1 = Color3.fromRGB(80, 0, 150), c2 = Color3.fromRGB(255, 120, 220), rainbow = true },
    DragonFire = { c1 = Color3.fromRGB(255, 80, 0), c2 = Color3.fromRGB(255, 220, 50), smoke = true },
    MysteryFire = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 255, 255), rainbow = true },
    RainbowFire = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 255, 255), rainbow = true, spark = true },
    LightningFire = { c1 = Color3.fromRGB(120, 220, 255), c2 = Color3.fromRGB(255, 255, 255), spark = true },
    GalaxyFire = { c1 = Color3.fromRGB(120, 60, 255), c2 = Color3.fromRGB(255, 200, 255), rainbow = true, spark = true },
    NebulaFire = { c1 = Color3.fromRGB(220, 80, 255), c2 = Color3.fromRGB(80, 220, 255), rainbow = true, spark = true },
    AuroraFire = { c1 = Color3.fromRGB(0, 255, 200), c2 = Color3.fromRGB(120, 255, 120), rainbow = true, spark = true },
    PhoenixFire = { c1 = Color3.fromRGB(255, 180, 0), c2 = Color3.fromRGB(255, 80, 0), smoke = true },
    DemonFire = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 0, 0), smoke = true },
    AngelFire = { c1 = Color3.fromRGB(255, 255, 220), c2 = Color3.fromRGB(255, 240, 255), spark = true },
    CrystalFire = { c1 = Color3.fromRGB(220, 255, 255), c2 = Color3.fromRGB(220, 220, 255), spark = true },
    NeonFire = { c1 = Color3.fromRGB(0, 255, 120), c2 = Color3.fromRGB(255, 0, 220), rainbow = true },
    PlasmaFire = { c1 = Color3.fromRGB(180, 0, 255), c2 = Color3.fromRGB(0, 220, 255), spark = true },
    QuantumFire = { c1 = Color3.fromRGB(0, 120, 255), c2 = Color3.fromRGB(255, 0, 120), rainbow = true },
    LegendaryFire = { c1 = Color3.fromRGB(255, 215, 0), c2 = Color3.fromRGB(255, 120, 0), spark = true },
    MythicFire = { c1 = Color3.fromRGB(220, 0, 255), c2 = Color3.fromRGB(255, 220, 0), rainbow = true },
    DivineFire = { c1 = Color3.fromRGB(255, 255, 255), c2 = Color3.fromRGB(255, 220, 120), spark = true },
    CursedFire = { c1 = Color3.fromRGB(100, 0, 0), c2 = Color3.fromRGB(220, 0, 220), smoke = true },
    AncientFire = { c1 = Color3.fromRGB(220, 180, 0), c2 = Color3.fromRGB(120, 60, 0), smoke = true },
    EternalFire = { c1 = Color3.fromRGB(255, 120, 220), c2 = Color3.fromRGB(120, 220, 255), rainbow = true },
    InfernoFire = { c1 = Color3.fromRGB(255, 40, 0), c2 = Color3.fromRGB(255, 220, 0), smoke = true },
    BifrostFire = { c1 = Color3.fromRGB(255, 120, 220), c2 = Color3.fromRGB(120, 255, 220), rainbow = true },
    ChaosFire = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 0, 255), rainbow = true },
    OmegaFire = { c1 = Color3.fromRGB(255, 215, 0), c2 = Color3.fromRGB(255, 0, 255), rainbow = true },
    SolarFire = { c1 = Color3.fromRGB(255, 180, 0), c2 = Color3.fromRGB(255, 255, 120), spark = true },
    LunarFire = { c1 = Color3.fromRGB(220, 220, 255), c2 = Color3.fromRGB(120, 170, 255), spark = true },
    EclipseFire = { c1 = Color3.fromRGB(80, 0, 120), c2 = Color3.fromRGB(255, 180, 0), spark = true },
    SolarFlare = { c1 = Color3.fromRGB(255, 120, 0), c2 = Color3.fromRGB(255, 255, 220), spark = true },
    VoidStorm = { c1 = Color3.fromRGB(80, 0, 120), c2 = Color3.fromRGB(220, 0, 255), rainbow = true, spark = true },
    StarFire = { c1 = Color3.fromRGB(255, 255, 220), c2 = Color3.fromRGB(255, 220, 120), spark = true },
    SupernovaFire = { c1 = Color3.fromRGB(255, 220, 0), c2 = Color3.fromRGB(255, 0, 220), rainbow = true, spark = true },
    BlackHoleFire = { c1 = Color3.fromRGB(0, 0, 0), c2 = Color3.fromRGB(120, 0, 180), smoke = true },
    MeteorFire = { c1 = Color3.fromRGB(255, 100, 0), c2 = Color3.fromRGB(220, 40, 0), smoke = true },
    CometFire = { c1 = Color3.fromRGB(120, 220, 255), c2 = Color3.fromRGB(220, 255, 255), spark = true },
    FrostFire = { c1 = Color3.fromRGB(220, 240, 255), c2 = Color3.fromRGB(120, 200, 255), spark = true },
    BlizzardFire = { c1 = Color3.fromRGB(240, 250, 255), c2 = Color3.fromRGB(170, 220, 255), spark = true, smoke = true },
    ThunderFire = { c1 = Color3.fromRGB(255, 255, 120), c2 = Color3.fromRGB(120, 120, 255), spark = true },
    StormFire = { c1 = Color3.fromRGB(100, 100, 180), c2 = Color3.fromRGB(220, 220, 255), spark = true, smoke = true },
    TornadoFire = { c1 = Color3.fromRGB(180, 180, 220), c2 = Color3.fromRGB(100, 100, 150), spark = true, smoke = true },
    SoulFire = { c1 = Color3.fromRGB(0, 255, 220), c2 = Color3.fromRGB(180, 255, 255), spark = true },
    SpiritFire = { c1 = Color3.fromRGB(220, 255, 255), c2 = Color3.fromRGB(180, 220, 255), spark = true },
    PhantomFire = { c1 = Color3.fromRGB(120, 0, 180), c2 = Color3.fromRGB(80, 0, 120), smoke = true },
    WraithFire = { c1 = Color3.fromRGB(50, 0, 80), c2 = Color3.fromRGB(180, 0, 220), smoke = true },
    ReaperFire = { c1 = Color3.fromRGB(0, 0, 0), c2 = Color3.fromRGB(255, 0, 0), smoke = true },
}
for _, name in ipairs(FireList) do
    if not FireConfig[name] then FireConfig[name] = FireConfig.Classic end
end

FireFeetList = {
    "Classic", "Blue", "Green", "Purple", "Rainbow", "Golden", "Pink",
    "Cyan", "RedFire", "Ice", "Toxic", "Electric", "Blood", "Ghost",
    "Cosmic", "Dragon", "Divine", "Demon", "Shadow", "Phoenix"
}
FireFeetConfig = {
    Classic = { c1 = Color3.fromRGB(120, 60, 255), c2 = Color3.fromRGB(0, 230, 255) },
    Blue = { c1 = Color3.fromRGB(0, 170, 255), c2 = Color3.fromRGB(0, 255, 255) },
    Green = { c1 = Color3.fromRGB(0, 255, 50), c2 = Color3.fromRGB(180, 255, 0) },
    Purple = { c1 = Color3.fromRGB(180, 0, 255), c2 = Color3.fromRGB(255, 0, 220) },
    Rainbow = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 255, 255), rainbow = true },
    Golden = { c1 = Color3.fromRGB(255, 215, 0), c2 = Color3.fromRGB(255, 255, 120) },
    Pink = { c1 = Color3.fromRGB(255, 120, 220), c2 = Color3.fromRGB(255, 200, 240) },
    Cyan = { c1 = Color3.fromRGB(0, 255, 255), c2 = Color3.fromRGB(120, 255, 255) },
    RedFire = { c1 = Color3.fromRGB(255, 40, 0), c2 = Color3.fromRGB(255, 120, 0) },
    Ice = { c1 = Color3.fromRGB(220, 240, 255), c2 = Color3.fromRGB(120, 200, 255) },
    Toxic = { c1 = Color3.fromRGB(0, 255, 120), c2 = Color3.fromRGB(120, 255, 0) },
    Electric = { c1 = Color3.fromRGB(255, 255, 120), c2 = Color3.fromRGB(120, 120, 255) },
    Blood = { c1 = Color3.fromRGB(220, 0, 0), c2 = Color3.fromRGB(120, 0, 0) },
    Ghost = { c1 = Color3.fromRGB(220, 220, 255), c2 = Color3.fromRGB(255, 255, 255) },
    Cosmic = { c1 = Color3.fromRGB(120, 60, 255), c2 = Color3.fromRGB(255, 220, 255), rainbow = true },
    Dragon = { c1 = Color3.fromRGB(255, 80, 0), c2 = Color3.fromRGB(255, 220, 0) },
    Divine = { c1 = Color3.fromRGB(255, 255, 255), c2 = Color3.fromRGB(255, 255, 220) },
    Demon = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 0, 0) },
    Shadow = { c1 = Color3.fromRGB(30, 30, 40), c2 = Color3.fromRGB(100, 0, 130) },
    Phoenix = { c1 = Color3.fromRGB(255, 180, 0), c2 = Color3.fromRGB(255, 80, 0) },
}
for _, name in ipairs(FireFeetList) do
    if not FireFeetConfig[name] then FireFeetConfig[name] = FireFeetConfig.Classic end
end

SkyList = { "Default", "Sunset", "Night", "Space", "Alien", "Purple", "Galaxy", "Void" }
SkyIds = {
    Sunset = { Bk = "rbxassetid://169210149", Dn = "rbxassetid://169210108", Ft = "rbxassetid://169210121", Lf = "rbxassetid://169210133", Rt = "rbxassetid://169210143", Up = "rbxassetid://169210149" },
    Night = { Bk = "rbxassetid://18703245834", Dn = "rbxassetid://18703245834", Ft = "rbxassetid://18703245834", Lf = "rbxassetid://18703245834", Rt = "rbxassetid://18703245834", Up = "rbxassetid://18703245834" },
    Space = { Bk = "rbxassetid://17817511804", Dn = "rbxassetid://17817520184", Ft = "rbxassetid://17817511804", Lf = "rbxassetid://17817511804", Rt = "rbxassetid://17817511804", Up = "rbxassetid://17817511804" },
    Alien = { Bk = "rbxassetid://10253172001", Dn = "rbxassetid://10253172001", Ft = "rbxassetid://10253172001", Lf = "rbxassetid://10253172001", Rt = "rbxassetid://10253172001", Up = "rbxassetid://10253172001" },
    Purple = { Bk = "rbxassetid://6021017254", Dn = "rbxassetid://6021011228", Ft = "rbxassetid://6021017254", Lf = "rbxassetid://6021017254", Rt = "rbxassetid://6021017254", Up = "rbxassetid://6021017254" },
    Galaxy = { Bk = "rbxassetid://126146408999925", Dn = "rbxassetid://118112392224589", Ft = "rbxassetid://121253817183621", Lf = "rbxassetid://138429250948648", Rt = "rbxassetid://126146408999925", Up = "rbxassetid://126146408999925" },
    Void = { Bk = "rbxassetid://17817511804", Dn = "rbxassetid://17817520184", Ft = "rbxassetid://17817511804", Lf = "rbxassetid://17817511804", Rt = "rbxassetid://17817511804", Up = "rbxassetid://17817511804" },
}

KillerAnims = {}
for _, id in ipairs({
    "105374834496520","113255068724446","118907603246885","129784271201071",
    "117042998468241","122812055447896","78935059863801","74968262036854",
    "78432063483146","132817836308238","133963973694098","111920872708571",
    "80411309607666","98163597193511","82666958311998","110355011987939",
    "139369275981133","135002183282873","121216847022485","130593238885843",
    "117070354890871","106871536134254","138720291317243"
}) do
    KillerAnims["rbxassetid://"..id] = true
end

print("✅ [2/6] Fire + Sky + KillerAnims loaded")-- =========================================================
-- BAGIAN 3/6 : SEMUA FUNGSI + AUTO PARRY + SKILL CHECK + HD + EXECUTE ANIM
-- =========================================================

-- FIRE (KEPALA)
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
    fire.Heat = 15
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
            fire.Heat = 10
            fire.Color = cfg.c1
            fire.SecondaryColor = cfg.c2
            fire.Parent = leg
        end
    end
end

task.spawn(function()
    while task.wait(0.3) do
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

-- 8-BIT CROWN
function apply8BitCrown(enable, size, posX, posY, posZ)
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("Roooor8BitCrown")
    if old then old:Destroy() end
    if not enable then return end
    size = size or 1
    posX = posX or 0
    posY = posY or 1.2
    posZ = posZ or 0

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
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(200, 150, 255)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(120, 60, 255)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 230, 255)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 80, 200)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(120, 60, 255))
    })
    emitter.Parent = crown
end

-- ESP SYSTEM
ESPObjects = {}
StatusESP = {}
CachedSCP = {}
Cached = { Generators = {}, Windows = {}, Pallets = {} }
GeneratorColor = Color3.fromRGB(255, 170, 0)
PalletColor = Color3.fromRGB(74, 255, 181)
WindowColor = Color3.fromRGB(74, 255, 181)
SCPColor = Color3.fromRGB(255, 0, 0)

function cacheObject(obj)
    if obj.Name == "Generator" then Cached.Generators[obj] = true
    elseif obj.Name == "Window" then Cached.Windows[obj] = true
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then Cached.Pallets[obj] = true
    end
    local name = string.lower(obj.Name)
    if string.find(name, "scp") then CachedSCP[obj] = true end
end

function removeCache(obj)
    Cached.Generators[obj] = nil
    Cached.Windows[obj] = nil
    Cached.Pallets[obj] = nil
    CachedSCP[obj] = nil
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
end

for _, obj in ipairs(workspace:GetDescendants()) do cacheObject(obj) end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(removeCache)

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

function removeESP(obj)
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
end

function removeStatusESP(char)
    if StatusESP[char] then StatusESP[char]:Destroy(); StatusESP[char] = nil end
end

function createStatusESP(player, char, root)
    if not ESPStatus.Enabled then removeStatusESP(char); return end
    if not root then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end
    local isDown = hum.Health <= 0 or hum.Health < 2
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
        if label then label.Text = text; label.TextColor3 = teamColor end
    end
end

function GetGameValue(obj, name)
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

function UpdateGenerator(generator)
    if not generator or not generator.Parent then return end
    if not ESP.Generator then
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
    local color = GeneratorColor:Lerp(Color3.fromRGB(0, 255, 120), cp / 100)
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
        label.TextSize = 12
        label.Parent = billboard
        billboard.Adornee = generator
        billboard.Parent = generator
    else
        local lbl = billboard:FindFirstChildOfClass("TextLabel")
        if lbl then lbl.Text = text; lbl.TextColor3 = color end
    end
    local h = generator:FindFirstChild("GenHighlight") or Instance.new("Highlight")
    h.Name = "GenHighlight"
    h.Adornee = generator
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.9
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = generator
end

function UpdateMapESP(obj, root)
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

function UpdateSCPEsp(root)
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

-- AUTO PARRY
PARRY_DEBOUNCE = 0.2
lastParry = 0
hookedKillers = _G.HookedKillers or {}
_G.HookedKillers = hookedKillers
ParryActive = false

function pressRightClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
end

function GetParryButton()
    local current = PG
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

function pressParryButton()
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

function doParry()
    local now = tick()
    if now - lastParry < PARRY_DEBOUNCE then return end
    lastParry = now
    ParryActive = true
    pressParryButton()
    task.delay(0.3, function() ParryActive = false end)
end

function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local eRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not eRoot then return false end
    local dist = (eRoot.Position - myRoot.Position).Magnitude
    return dist <= AutoParry.ParryDistance
end

function isFacingTarget(targetChar)
    if not AutoParry.RequireFacing then return true end
    if AutoParry.FaceSensitivity <= -1 then return true end
    local myChar = LP.Character
    if not myChar then return false end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local eRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not eRoot then return false end
    local enemyForward = eRoot.CFrame.LookVector
    local directionToMe = (myRoot.Position - eRoot.Position).Unit
    local dot = enemyForward:Dot(directionToMe)
    return dot >= AutoParry.FaceSensitivity
end

function hookKiller(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not AutoParry.Enabled then return end
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

function scanKillers()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
            hookKiller(p.Character)
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if AutoParry.Enabled then scanKillers() end
    end
end)

-- AUTO SKILL CHECK
function pressSpace()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

TouchID = 8822
ActionPath = "Survivor-mob.Controls.action.check"
SkillHeartbeat = nil
busy = false

function GetActionTarget()
    local current = PG
    for segment in string.gmatch(ActionPath, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

function TriggerMobileButton()
    local b = GetActionTarget()
    if b and b:IsA("GuiObject") then
        local p, s, i = b.AbsolutePosition, b.AbsoluteSize, GuiService:GetGuiInset()
        local cx, cy = p.X + (s.X/2) + i.X, p.Y + (s.Y/2) + i.Y
        pcall(function()
            VirtualInputManager:SendTouchEvent(TouchID, 0, cx, cy)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(TouchID, 2, cx, cy)
        end)
    end
end

function startSkillCheck()
    if SkillHeartbeat then SkillHeartbeat:Disconnect() end
    SkillHeartbeat = RunService.RenderStepped:Connect(function()
        if not SkillCheck.Enabled or busy then return end
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
        local success = (startRange > endRange and (lr >= startRange or lr <= endRange)) or (lr >= startRange and lr <= endRange)
        if success then
            busy = true
            task.spawn(function()
                if UIS.TouchEnabled then TriggerMobileButton() else pressSpace() end
                task.wait(0.05)
                busy = false
            end)
        end
    end)
end

-- TELEPORT
function teleportToFinishLine()
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
    else warn("[RoooorHub] Finish line gak ketemu") end
end

function teleportToGate()
    local root = getRoot()
    if not root then return end
    local found = nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = string.lower(obj.Name)
            if string.find(n, "gate") or string.find(n, "exit") or string.find(n, "escape") then
                found = obj
                break
            end
        end
    end
    if found then root.CFrame = found.CFrame + Vector3.new(0, 5, 0) + found.CFrame.LookVector * 5
    else warn("[RoooorHub] Gate gak ketemu") end
end

function teleportInsideGate()
    local root = getRoot()
    if not root then return end
    local found = nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = string.lower(obj.Name)
            if string.find(n, "inside") or string.find(n, "safe") or string.find(n, "chamber") then
                found = obj
                break
            end
        end
    end
    if found then root.CFrame = CFrame.new(found.Position + Vector3.new(0, 3, 0))
    else warn("[RoooorHub] Inside gate gak ketemu") end
end

-- NO CLIP
task.spawn(function()
    while task.wait(0.2) do
        if S.NoClip and LP.Character then
            for _, v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end
end)

-- VISUAL LIGHTING
origLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
}

function applyFullbright(s)
    if s then
        local bright = math.clamp((S.FullbrightVal or 50) / 100, 0, 2)
        Lighting.Brightness = 0.5 + bright * 3
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(math.min(bright, 1), math.min(bright, 1), math.min(bright, 1))
        Lighting.OutdoorAmbient = Color3.new(math.min(bright, 1), math.min(bright, 1), math.min(bright, 1))
        Lighting.GlobalShadows = S.FullbrightVal < 100
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
    else
        Lighting.Brightness = origLighting.Brightness
        Lighting.ClockTime = origLighting.ClockTime
        Lighting.Ambient = origLighting.Ambient
        Lighting.OutdoorAmbient = origLighting.OutdoorAmbient
        Lighting.GlobalShadows = origLighting.GlobalShadows
        Lighting.FogEnd = origLighting.FogEnd
        Lighting.FogStart = origLighting.FogStart
    end
end

function applyNoFog(s)
    pcall(function()
        if s then
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("Atmosphere") then
                    v.Density = 0; v.Haze = 0; v.Glare = 0
                end
            end
            Lighting.FogEnd = 9e9
            Lighting.FogStart = 9e9
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)
        else
            Lighting.FogEnd = origLighting.FogEnd or 100000
            Lighting.FogStart = origLighting.FogStart or 0
        end
    end)
end

task.spawn(function()
    while task.wait(1) do
        if S.NoFog then
            pcall(function()
                Lighting.FogEnd = 9e9
                Lighting.FogStart = 9e9
                for _, v in pairs(Lighting:GetChildren()) do
                    if v:IsA("Atmosphere") then
                        v.Density = 0; v.Haze = 0
                    end
                end
            end)
        end
    end
end)

origSky = nil
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("Sky") then origSky = v:Clone(); break end
end

function applySky(skyName)
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

function applyFOV()
    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = S.FOVEnabled and S.FOV or 70 end
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

function applyBloom()
    if S.Bloom then
        if not _G.RoooorBloom then
            _G.RoooorBloom = Instance.new("BloomEffect")
            _G.RoooorBloom.Parent = Lighting
        end
        _G.RoooorBloom.Intensity = S.BloomIntensity
        _G.RoooorBloom.Size = S.BloomSize
        _G.RoooorBloom.Threshold = S.BloomThreshold
    else
        if _G.RoooorBloom then _G.RoooorBloom:Destroy(); _G.RoooorBloom = nil end
    end
end

function applySunRays()
    if S.SunRays then
        if not _G.RoooorSunRays then
            _G.RoooorSunRays = Instance.new("SunRaysEffect")
            _G.RoooorSunRays.Parent = Lighting
        end
        _G.RoooorSunRays.Intensity = S.SunRaysIntensity
        _G.RoooorSunRays.Spread = S.SunRaysSpread
    else
        if _G.RoooorSunRays then _G.RoooorSunRays:Destroy(); _G.RoooorSunRays = nil end
    end
end

function applyDepthOfField()
    if S.DepthOfField then
        if not _G.RoooorDOF then
            _G.RoooorDOF = Instance.new("DepthOfFieldEffect")
            _G.RoooorDOF.Parent = Lighting
        end
        _G.RoooorDOF.FocusDistance = S.DOFFocusDistance
        _G.RoooorDOF.InFocusRadius = S.DOFInFocusRadius
        _G.RoooorDOF.FarIntensity = S.DOFFarIntensity
    else
        if _G.RoooorDOF then _G.RoooorDOF:Destroy(); _G.RoooorDOF = nil end
    end
end

function applySharpen()
    if S.Sharpen then
        if not _G.RoooorSharpen then
            pcall(function()
                _G.RoooorSharpen = Instance.new("SharpenEffect")
                _G.RoooorSharpen.Parent = Lighting
            end)
        end
        if _G.RoooorSharpen then
            _G.RoooorSharpen.Amount = S.SharpenAmount
        end
    else
        if _G.RoooorSharpen then _G.RoooorSharpen:Destroy(); _G.RoooorSharpen = nil end
    end
end

function applyCinematic()
    if S.Cinematic then
        if not _G.RoooorCinematicGui then
            _G.RoooorCinematicGui = Instance.new("ScreenGui")
            _G.RoooorCinematicGui.Name = "RoooorCinematic"
            _G.RoooorCinematicGui.ResetOnSpawn = false
            _G.RoooorCinematicGui.IgnoreGuiInset = true
            _G.RoooorCinematicGui.DisplayOrder = 99998
            _G.RoooorCinematicGui.Parent = PG

            local topBar = Instance.new("Frame")
            topBar.Name = "TopBar"
            topBar.Size = UDim2.new(1, 0, 0, S.CinematicBarSize)
            topBar.Position = UDim2.new(0, 0, 0, 0)
            topBar.BackgroundColor3 = Color3.new(0, 0, 0)
            topBar.BorderSizePixel = 0
            topBar.Parent = _G.RoooorCinematicGui

            local botBar = Instance.new("Frame")
            botBar.Name = "BotBar"
            botBar.Size = UDim2.new(1, 0, 0, S.CinematicBarSize)
            botBar.Position = UDim2.new(0, 0, 1, -S.CinematicBarSize)
            botBar.BackgroundColor3 = Color3.new(0, 0, 0)
            botBar.BorderSizePixel = 0
            botBar.Parent = _G.RoooorCinematicGui
        end
        local gui = _G.RoooorCinematicGui
        if gui then
            local top = gui:FindFirstChild("TopBar")
            local bot = gui:FindFirstChild("BotBar")
            if top then top.Size = UDim2.new(1, 0, 0, S.CinematicBarSize) end
            if bot then
                bot.Size = UDim2.new(1, 0, 0, S.CinematicBarSize)
                bot.Position = UDim2.new(0, 0, 1, -S.CinematicBarSize)
            end
        end
        if not _G.RoooorVignette then
            _G.RoooorVignette = Instance.new("ColorCorrectionEffect")
            _G.RoooorVignette.Parent = Lighting
        end
        _G.RoooorVignette.Brightness = -S.CinematicVignette * 0.5
        _G.RoooorVignette.Contrast = S.CinematicVignette * 0.3
    else
        if _G.RoooorCinematicGui then
            _G.RoooorCinematicGui:Destroy()
            _G.RoooorCinematicGui = nil
        end
        if _G.RoooorVignette then
            _G.RoooorVignette:Destroy()
            _G.RoooorVignette = nil
        end    end
end

function applyAtmosphereHD()
    if S.AtmosphereHD then
        if not _G.RoooorAtm then
            _G.RoooorAtm = Instance.new("Atmosphere")
            _G.RoooorAtm.Parent = Lighting
        end
        _G.RoooorAtm.Density = S.AtmosphereDensity
        _G.RoooorAtm.Haze = S.AtmosphereHaze
        _G.RoooorAtm.Glare = S.AtmosphereGlare
    else
        if _G.RoooorAtm then _G.RoooorAtm:Destroy(); _G.RoooorAtm = nil end
    end
end

-- KORBLOX / HEADLESS
KorbloxOrig = nil
function applyKorblox(s)
    local char = LP.Character
    if not char then return end
    local rightLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("RightLowerLeg")
    if not rightLeg then return end
    if s then
        if not KorbloxOrig then
            KorbloxOrig = { Transparency = rightLeg.Transparency, CanCollide = rightLeg.CanCollide }
        end
        rightLeg.Transparency = 1
        rightLeg.CanCollide = false
    else
        if KorbloxOrig then
            rightLeg.Transparency = KorbloxOrig.Transparency
            rightLeg.CanCollide = KorbloxOrig.CanCollide
            KorbloxOrig = nil
        else
            rightLeg.Transparency = 0
            rightLeg.CanCollide = true
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if S.Korblox and LP.Character then
            local rightLeg = LP.Character:FindFirstChild("Right Leg") or LP.Character:FindFirstChild("RightUpperLeg") or LP.Character:FindFirstChild("RightLowerLeg")
            if rightLeg and rightLeg.Transparency ~= 1 then
                rightLeg.Transparency = 1
                rightLeg.CanCollide = false
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

-- TRAIL / AURA / KILL EFFECT / CROSSHAIR / ZOOM
trailFireObj = nil
function applyTrail(enable, color)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if trailFireObj then trailFireObj:Destroy(); trailFireObj = nil end
    if not enable then return end
    trailFireObj = Instance.new("Part")
    trailFireObj.Name = "RoooorTrailFire"
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
    fire.Color = color or Color3.fromRGB(120, 60, 255)
    fire.SecondaryColor = Color3.fromRGB(0, 230, 255)
    fire.Parent = trailFireObj
    local smoke = Instance.new("Smoke")
    smoke.Size = 6
    smoke.RiseVelocity = 5
    smoke.Opacity = 0.5
    smoke.Color = Color3.fromRGB(50, 50, 50)
    smoke.Parent = trailFireObj
    local spark = Instance.new("Sparkles")
    spark.SparkleColor = color or Color3.fromRGB(0, 230, 255)
    spark.SparkleSize = 2
    spark.Parent = trailFireObj
end

auraObj = nil
function applyAura(enable, color)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if auraObj then auraObj:Destroy(); auraObj = nil end
    if not enable then return end
    auraObj = Instance.new("ParticleEmitter")
    auraObj.Texture = "rbxassetid://243660364"
    auraObj.Color = ColorSequence.new(color or Color3.fromRGB(120, 60, 255))
    auraObj.Size = NumberSequence.new(2)
    auraObj.Lifetime = NumberRange.new(0.5, 1)
    auraObj.Rate = 30
    auraObj.Speed = NumberRange.new(2)
    auraObj.SpreadAngle = Vector2.new(180, 180)
    auraObj.Parent = hrp
end

function spawnKillEffect(pos)
    local p = Instance.new("Part")
    p.Anchored = true
    p.CanCollide = false
    p.Material = Enum.Material.Neon
    p.Shape = Enum.PartType.Ball
    p.Size = Vector3.new(2, 2, 2)
    p.Position = pos
    p.Color = Color3.fromRGB(120, 60, 255)
    p.Transparency = 0.3
    p.Parent = workspace
    TweenService:Create(p, TweenInfo.new(0.5), { Size = Vector3.new(15, 15, 15), Transparency = 1 }):Play()
    task.delay(0.6, function() p:Destroy() end)
end

crosshairGui = nil
function applyCrosshair(enable, color, size)
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
        if i == 1 then
            ln.Size = UDim2.new(0, size or 8, 0, 2)
            ln.Position = UDim2.new(0.5, -(size or 8) - 3, 0.5, -1)
        elseif i == 2 then
            ln.Size = UDim2.new(0, size or 8, 0, 2)
            ln.Position = UDim2.new(0.5, 3, 0.5, -1)
        elseif i == 3 then
            ln.Size = UDim2.new(0, 2, 0, size or 8)
            ln.Position = UDim2.new(0.5, -1, 0.5, -(size or 8) - 3)
        elseif i == 4 then
            ln.Size = UDim2.new(0, 2, 0, size or 8)
            ln.Position = UDim2.new(0.5, -1, 0.5, 3)
        end
        ln.Parent = crosshairGui
    end
end

function applyZoomOut(enable, val)
    if enable then LP.CameraMaxZoomDistance = val or 500
    else LP.CameraMaxZoomDistance = 128 end
end

-- =========================================================
-- EXECUTE ANIMATION "ROOORHUB"
-- =========================================================
function showExecuteAnim(targetPos)
    if not S.ExecuteAnim then return end

    local part = Instance.new("Part")
    part.Name = "RoooorExecutePart"
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Size = Vector3.new(2, 2, 2)
    part.Position = targetPos + Vector3.new(0, 6, 0)
    part.Parent = workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RoooorExecuteGui"
    billboard.Size = UDim2.new(0, 500, 0, 120)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = math.huge
    billboard.Adornee = part
    billboard.Parent = part

    local glowFrame = Instance.new("Frame")
    glowFrame.Size = UDim2.new(0, 380, 0, 80)
    glowFrame.Position = UDim2.new(0.5, -190, 0.5, -40)
    glowFrame.BackgroundColor3 = C.ACC
    glowFrame.BackgroundTransparency = 0.5
    glowFrame.BorderSizePixel = 0
    glowFrame.Parent = billboard
    rnd(glowFrame, 20)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "ROOORHUB"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 60
    label.Font = Enum.Font.GothamBlack
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = C.ACC
    label.TextTransparency = 1
    label.Parent = billboard

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.ACC),
        ColorSequenceKeypoint.new(0.33, C.ACC2),
        ColorSequenceKeypoint.new(0.66, C.ACC3),
        ColorSequenceKeypoint.new(1, C.FIRE_BRIGHT),
    })
    grad.Parent = label

    local info = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(label, info, {
        TextTransparency = 0,
        TextSize = 70,
    }):Play()
    TweenService:Create(glowFrame, info, {
        BackgroundTransparency = 0.2,
        Size = UDim2.new(0, 480, 0, 100),
        Position = UDim2.new(0.5, -240, 0.5, -50),
    }):Play()
    TweenService:Create(part, info, {
        Position = part.Position + Vector3.new(0, 10, 0),
    }):Play()

    task.spawn(function()
        local t = 0
        while glowFrame.Parent do
            t = t + 0.03
            glowFrame.Rotation = math.sin(t * 2) * 5
            task.wait(0.03)
        end
    end)

    task.delay(0.8, function()
        TweenService:Create(label, TweenInfo.new(0.7), {
            TextTransparency = 1,
            TextSize = 40,
        }):Play()
        TweenService:Create(glowFrame, TweenInfo.new(0.7), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 700, 0, 150),
            Position = UDim2.new(0.5, -350, 0.5, -75),
        }):Play()
        task.wait(0.8)
        if part then part:Destroy() end
    end)
end

-- SIMPAN KE _G
_G.Roooor_applyFire = applyFire
_G.Roooor_applyFireFeet = applyFireFeet
_G.Roooor_apply8BitCrown = apply8BitCrown
_G.Roooor_createESP = createESP
_G.Roooor_removeESP = removeESP
_G.Roooor_createStatusESP = createStatusESP
_G.Roooor_UpdateGenerator = UpdateGenerator
_G.Roooor_UpdateMapESP = UpdateMapESP
_G.Roooor_UpdateSCPEsp = UpdateSCPEsp
_G.Roooor_scanKillers = scanKillers
_G.Roooor_startSkillCheck = startSkillCheck
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
_G.Roooor_teleportToGate = teleportToGate
_G.Roooor_teleportInsideGate = teleportInsideGate
_G.Roooor_spawnKillEffect = spawnKillEffect
_G.Roooor_showExecuteAnim = showExecuteAnim
_G.Roooor_applyBloom = applyBloom
_G.Roooor_applySunRays = applySunRays
_G.Roooor_applyDepthOfField = applyDepthOfField
_G.Roooor_applySharpen = applySharpen
_G.Roooor_applyCinematic = applyCinematic
_G.Roooor_applyAtmosphereHD = applyAtmosphereHD

print("✅ [3/6] Semua fungsi + Execute Anim loaded")-- =========================================================
-- BAGIAN 4/6 : FITUR LOOP + AIMLOCK + KILL FEED + MONITOR EXECUTE
-- =========================================================

-- AUTO HEAL
task.spawn(function()
    while task.wait(0.5) do
        if S.AutoHeal and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and hum.Health < S.AutoHealThreshold then
                pcall(function()
                    local backpack = LP:FindFirstChild("Backpack")
                    if backpack then
                        for _, item in pairs(backpack:GetChildren()) do
                            if item:IsA("Tool") and (
                                string.find(string.lower(item.Name), "medkit") or
                                string.find(string.lower(item.Name), "bandage") or
                                string.find(string.lower(item.Name), "heal")
                            ) then
                                local hum2 = LP.Character:FindFirstChildOfClass("Humanoid")
                                if hum2 then
                                    hum2:EquipTool(item)
                                    task.wait(0.1)
                                    item:Activate()
                                    task.wait(0.3)
                                    if item.Parent == LP.Character then hum2:UnequipTools() end
                                end
                                break
                            end
                        end
                    end
                end)
            end
        end
    end
end)

-- AUTO REPAIR
task.spawn(function()
    while task.wait(0.5) do
        if S.AutoRepair and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, obj in pairs(Cached.Generators) do
                    if obj and obj.Parent then
                        local pos = obj:IsA("Model") and obj:GetPivot().Position or (obj:IsA("BasePart") and obj.Position)
                        if pos and (pos - myRoot.Position).Magnitude <= 15 then
                            pcall(function()
                                local prompt = obj:FindFirstChildOfClass("ProximityPrompt", true)
                                if prompt then prompt:InputHoldBegin() end
                            end)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- AUTO REVIVE
task.spawn(function()
    while task.wait(1) do
        if S.AutoRevive and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Survivors" then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health <= 0 then
                            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and (hrp.Position - myRoot.Position).Magnitude <= 10 then
                                pcall(function()
                                    local prompt = p.Character:FindFirstChildOfClass("ProximityPrompt", true)
                                    if prompt then
                                        prompt:InputHoldBegin()
                                        task.wait(0.1)
                                        prompt:InputHoldEnd()
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- AUTO DODGE
task.spawn(function()
    while task.wait(0.2) do
        if S.AutoDodge and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                local closest, shortest = nil, S.DodgeRange or 30
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                        local krp = p.Character:FindFirstChild("HumanoidRootPart")
                        if krp then
                            local d = (krp.Position - myRoot.Position).Magnitude
                            if d < shortest then shortest = d; closest = krp end
                        end
                    end
                end
                if closest then
                    local dir = (myRoot.Position - closest.Position).Unit
                    local hum = LP.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum:Move(dir * 5, false) end
                end
            end
        end
    end
end)

-- ABYSS DODGE
task.spawn(function()
    while task.wait(0.1) do
        if S.AbyssDodge and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local killerName = string.lower(p.Name)
                        local charName = string.lower(p.Character.Name)
                        local teamName = p.Team and string.lower(p.Team.Name) or ""
                        local isAbyss = string.find(killerName, "abyss") or string.find(charName, "abyss") or string.find(teamName, "abyss")
                        if isAbyss then
                            local krp = p.Character:FindFirstChild("HumanoidRootPart")
                            local khum = p.Character:FindFirstChildOfClass("Humanoid")
                            if krp and khum then
                                local kanim = khum:FindFirstChildOfClass("Animator")
                                if kanim then
                                    for _, track in ipairs(kanim:GetPlayingAnimationTracks()) do
                                        local a = track.Animation
                                        if a and a.AnimationId then
                                            local id = a.AnimationId:match("%d+")
                                            if id and KillerAnims["rbxassetid://"..id] then
                                                local dist = (krp.Position - myRoot.Position).Magnitude
                                                if dist <= 20 then
                                                    local hum = LP.Character:FindFirstChildOfClass("Humanoid")
                                                    if hum then
                                                        pcall(function()
                                                            hum:ChangeState(Enum.HumanoidStateType.PlatformStanding)
                                                            task.wait(0.05)
                                                            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                                                        end)
                                                    end
                                                end
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- INSTANT INTERACT
task.spawn(function()
    while task.wait(0.3) do
        if S.InstantInteract and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        local parent = obj.Parent
                        local pos
                        if parent:IsA("BasePart") then pos = parent.Position
                        elseif parent:IsA("Model") then pos = parent:GetPivot().Position end
                        if pos and (pos - myRoot.Position).Magnitude <= 12 then
                            pcall(function()
                                obj:InputHoldBegin()
                                task.wait(0.05)
                                obj:InputHoldEnd()
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- AUTO VAULT
task.spawn(function()
    while task.wait(0.3) do
        if S.AutoVault and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, obj in pairs(Cached.Windows) do
                    if obj and obj.Parent then
                        local pos = obj:IsA("Model") and obj:GetPivot().Position or (obj:IsA("BasePart") and obj.Position)
                        if pos and (pos - myRoot.Position).Magnitude <= 8 then
                            pcall(function()
                                local prompt = obj:FindFirstChildOfClass("ProximityPrompt", true)
                                if prompt then
                                    prompt:InputHoldBegin()
                                    task.wait(0.05)
                                    prompt:InputHoldEnd()
                                end
                            end)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- ANTI GRAB
task.spawn(function()
    while task.wait(0.2) do
        if S.AntiGrab and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, v in pairs(hrp:GetChildren()) do
                    if v:IsA("WeldConstraint") or v:IsA("Weld") or v:IsA("Motor6D") then
                        local part1 = v.Part1 or v.Part0
                        if part1 and not part1:IsDescendantOf(LP.Character) then v:Destroy() end
                    end
                end
            end
        end
    end
end)

-- ANTI HOOK
task.spawn(function()
    while task.wait(0.2) do
        if S.AntiHook and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.AssemblyLinearVelocity.Magnitude > 200 then
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

-- ANTI BLIND
task.spawn(function()
    while task.wait(0.4) do
        if S.AntiBlind then
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

-- ANTI STUN / RAGDOLL / SLOW
task.spawn(function()
    while task.wait(0.2) do
        if not LP.Character then continue end
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if not hum then continue end
        if S.AntiStun then
            if hum.WalkSpeed == 0 and S.WalkSpeed then hum.WalkSpeed = S.WalkSpeedVal end
            if hum.PlatformStand then hum.PlatformStand = false end
        end
        if S.AntiRagdoll then
            if hum.PlatformStand then hum.PlatformStand = false end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
        if S.AntiSlow then
            if hum.WalkSpeed < 10 then hum.WalkSpeed = S.WalkSpeed and S.WalkSpeedVal or 16 end
        end
    end
end)

-- ANTI AFK
task.spawn(function()
    while task.wait(60) do
        if S.AntiAFK then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end
    end
end)

-- SPEED HACK
task.spawn(function()
    while task.wait(0.2) do
        if S.SpeedHack and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= S.SpeedHackVal then hum.WalkSpeed = S.SpeedHackVal end
        end
    end
end)

-- WALK SPEED
task.spawn(function()
    while task.wait(0.2) do
        if S.WalkSpeed and not S.SpeedHack and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local target = S.WalkSpeedVal + (S.WalkSpeedBoost or 0)
                if hum.WalkSpeed ~= target then hum.WalkSpeed = target end
            end
        end
    end
end)

-- SAFE ZONE
task.spawn(function()
    while task.wait(0.5) do
        if S.SafeZone and LP.Character then
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
                        warn.BackgroundColor3 = Color3.fromRGB(120, 60, 255)
                        warn.BorderSizePixel = 0
                        warn.Parent = PG
                    end
                    warn.BackgroundTransparency = 0.3
                    task.delay(0.3, function()
                        if warn then warn.BackgroundTransparency = 1 end
                    end)
                end
            end
        end
    end
end)

-- ESCAPE ALERT
task.spawn(function()
    while task.wait(0.5) do
        if S.EscapeAlert and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                        local krp = p.Character:FindFirstChild("HumanoidRootPart")
                        if krp and (krp.Position - myRoot.Position).Magnitude <= S.EscapeAlertRange then
                            local al = PG:FindFirstChild("RoooorAlert")
                            if not al then
                                al = Instance.new("TextLabel")
                                al.Name = "RoooorAlert"
                                al.Size = UDim2.new(0, 300, 0, 40)
                                al.Position = UDim2.new(0.5, -150, 0, 100)
                                al.BackgroundTransparency = 0.3
                                al.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                                al.TextColor3 = Color3.fromRGB(255, 80, 200)
                                al.TextSize = 20
                                al.Font = Enum.Font.GothamBlack
                                al.Text = "⚠️ KILLER DEKET! ⚠️"
                                al.TextStrokeTransparency = 0
                                al.Parent = PG
                                rnd(al, 10)
                            end
                            al.Visible = true
                            task.delay(0.8, function()
                                if al then al.Visible = false end
                            end)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- KILLER: AUTO ATTACK
lastAtk = 0
task.spawn(function()
    while task.wait(0.2) do
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

-- KILLER KILL ALL
task.spawn(function()
    while task.wait(0.4) do
        if S.Killer_KillAll and LP.Character then
            local myHum = LP.Character:FindFirstChildOfClass("Humanoid")
            if not myHum or myHum.Health <= 0 then continue end
            local isCarried = LP.Character:GetAttribute("IsCarried") or LP.Character:GetAttribute("IsCarrying")
                or LP.Character:GetAttribute("Hooked") or LP.Character:GetAttribute("Hook")
            if isCarried then continue end
            local myRoot = getRoot()
            if not myRoot then continue end
            local myPos = myRoot.Position
            local closest, shortest = nil, 60
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Team and p.Team.Name == "Survivors" then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local survivorHooked = p.Character:GetAttribute("Hooked") or p.Character:GetAttribute("IsCarried")
                            or p.Character:GetAttribute("IsHooked")
                        if survivorHooked then continue end
                        if hrp.Position.Y > 30 then continue end
                        local dist = (hrp.Position - myPos).Magnitude
                        if dist < shortest then shortest = dist; closest = hrp end
                    end
                end
            end
            if closest then
                local targetPos = closest.Position + (closest.AssemblyLinearVelocity * 0.15)
                local behind = closest.CFrame.LookVector * -3
                local newPos = targetPos + behind
                pcall(function()
                    myRoot.CFrame = CFrame.new(newPos, targetPos)
                    myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end)
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

-- PARRY CIRCLE
_G.Roooor_ParryCircle = nil
function updateParryCircle()
    local root = getRoot()
    if not S.ParryCircle or not root then
        if _G.Roooor_ParryCircle then _G.Roooor_ParryCircle:Destroy(); _G.Roooor_ParryCircle = nil end
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
    _G.Roooor_ParryCircle.Color = C.ACC2
    _G.Roooor_ParryCircle.Transparency = 0.5
end

RunService.RenderStepped:Connect(function()
    if S.ParryCircle then updateParryCircle() end
end)

-- MAIN ESP LOOP
local lastESPUpdate = 0
RunService.Heartbeat:Connect(function()
    local root = getRoot()
    if not root then return end
    local now = tick()
    if now - lastESPUpdate >= 0.08 then
        lastESPUpdate = now
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local char = p.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local distance = (hrp.Position - root.Position).Magnitude
                        if distance <= ESP.Distance then
                            if ESP.Survivor and p.Team and p.Team.Name == "Survivors" then
                                createESP(char, TeamColors.Survivor)
                            elseif ESP.Killer and p.Team and p.Team.Name == "Killer" then
                                createESP(char, TeamColors.Killer)
                            else removeESP(char) end
                        else removeESP(char) end
                    end
                    createStatusESP(p, char, root)
                else removeESP(char) end
            end
        end
        if ESP.Generator then
            for gen in pairs(Cached.Generators) do UpdateGenerator(gen) end
        end
        for obj in pairs(Cached.Windows) do UpdateMapESP(obj, root) end
        for obj in pairs(Cached.Pallets) do UpdateMapESP(obj, root) end
        UpdateSCPEsp(root)
    end
end)

-- AIMLOCK LOOP — HOLD TO AIM
local aimTarget = nil

local function getAimTarget()
    local root = getRoot()
    if not root then return nil end
    local myPos = root.Position
    local closest, shortest = nil, Combat.LockRadius or 300
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local valid = false
            if Combat.Mode == "Killer" and p.Team and p.Team.Name == "Survivors" then
                valid = true
            elseif Combat.Mode == "Survivor" and p.Team and p.Team.Name == "Killer" then
                valid = true
            end
            if valid then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local part = p.Character:FindFirstChild(Combat.AimPart or "Head")
                    if part then
                        local dist = (part.Position - myPos).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closest = part
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function(dt)
    if not Combat.AimlockEnabled then return end
    if not Combat.Holding then
        aimTarget = nil
        return
    end
    if not aimTarget or not aimTarget.Parent then
        aimTarget = getAimTarget()
    end
    if not aimTarget then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local myPos = cam.CFrame.Position
    local targetPos = aimTarget.Position
    if Combat.Predict then
        local vel = aimTarget.AssemblyLinearVelocity or Vector3.zero
        targetPos = targetPos + (vel * (Combat.PredictStrength or 0.15))
    end
    local dir = (targetPos - myPos).Unit
    local targetCF = CFrame.new(myPos, myPos + dir)
    local smooth = Combat.Smoothness or 0.35
    cam.CFrame = cam.CFrame:Lerp(targetCF, math.clamp(smooth * (dt * 60), 0, 1))
end)

-- MONITOR KILL → TAMPILKAN EXECUTE ANIM "ROOORHUB"
task.spawn(function()
    local lastHealth = {}
    while task.wait(0.3) do
        if not S.ExecuteAnim then continue end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    local prevHP = lastHealth[p] or hum.Health
                    if prevHP > 0 and hum.Health <= 0 then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            showExecuteAnim(hrp.Position)
                        end
                    end
                    lastHealth[p] = hum.Health
                end
            end
        end
    end
end)

-- KILL EFFECT LOOP
task.spawn(function()
    while task.wait(0.8) do
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
                        if p.Character:GetAttribute("RoooorKillEffect") then
                            p.Character:SetAttribute("RoooorKillEffect", false)
                        end
                    end
                end
            end
        end
    end
end)

-- NO CLIP CAMERA
task.spawn(function()
    while task.wait(0.2) do
        local cam = workspace.CurrentCamera
        if cam then cam.CanCollide = not S.NoClipCamera end
    end
end)

-- KILL FEED
killFeedGui = Instance.new("ScreenGui")
killFeedGui.Name = "RoooorKillFeed"
killFeedGui.ResetOnSpawn = false
killFeedGui.IgnoreGuiInset = true
killFeedGui.Parent = PG

local killFeedFrame = Instance.new("Frame")
killFeedFrame.Size = UDim2.new(0, 250, 0, 200)
killFeedFrame.Position = UDim2.new(1, -260, 0, 50)
killFeedFrame.BackgroundTransparency = 1
killFeedFrame.Parent = killFeedGui

local killFeedLayout = Instance.new("UIListLayout")
killFeedLayout.Padding = UDim.new(0, 4)
killFeedLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
killFeedLayout.Parent = killFeedFrame

function addKillFeed(killerName, survivorName)
    if not S.KillFeed then return end
    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1, 0, 0, 28)
    entry.BackgroundColor3 = Color3.fromRGB(30, 10, 45)
    entry.BackgroundTransparency = 0.2
    entry.BorderSizePixel = 0
    entry.Parent = killFeedFrame
    rnd(entry, 6)
    strk(entry, C.ACC, 1, 0.5)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 1, 0)
    lbl.Position = UDim2.new(0, 5, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "💀 " .. killerName .. " ➜ " .. survivorName
    lbl.TextColor3 = Color3.fromRGB(220, 180, 255)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = entry
    task.spawn(function()
        task.wait(4)
        TweenService:Create(entry, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(lbl, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        task.wait(0.6)
        entry:Destroy()
    end)
end

task.spawn(function()
    local lastHealth = {}
    while task.wait(0.5) do
        if not S.KillFeed then continue end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    local prevHP = lastHealth[p] or hum.Health
                    if prevHP > 0 and hum.Health <= 0 then
                        local killerName = "???"
                        if p:GetAttribute("LastAttacker") then
                            killerName = p:GetAttribute("LastAttacker")
                        end
                        addKillFeed(killerName, p.Name)
                    end
                    lastHealth[p] = hum.Health
                end
            end
        end
    end
end)

-- STUN NOTIFY
stunIcons = {}
function createStunIcon(killerChar)
    if stunIcons[killerChar] then return stunIcons[killerChar] end
    local head = killerChar:FindFirstChild("Head")
    if not head then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RoooorStunIcon"
    billboard.Size = UDim2.new(0, 60, 0, 60)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.Adornee = head
    billboard.Parent = head
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "💫"
    icon.TextColor3 = Color3.fromRGB(220, 180, 255)
    icon.TextSize = 40
    icon.Font = Enum.Font.GothamBlack
    icon.TextStrokeTransparency = 0
    icon.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    icon.Parent = billboard
    task.spawn(function()
        while billboard.Parent do
            billboard.StudsOffset = Vector3.new(0, 4 + math.sin(tick() * 5) * 0.5, 0)
            icon.Rotation = math.sin(tick() * 8) * 20
            task.wait(0.05)
        end
    end)
    stunIcons[killerChar] = billboard
    return billboard
end

function removeStunIcon(killerChar)
    if stunIcons[killerChar] then
        stunIcons[killerChar]:Destroy()
        stunIcons[killerChar] = nil
    end
end

task.spawn(function()
    while task.wait(0.2) do
        if not S.StunNotify then continue end
        local myRoot = getRoot()
        if not myRoot then continue end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                local krp = p.Character:FindFirstChild("HumanoidRootPart")
                if krp then
                    local dist = (krp.Position - myRoot.Position).Magnitude
                    if dist <= 80 then
                        local isStunned = false
                        local khum = p.Character:FindFirstChildOfClass("Humanoid")
                        if khum then
                            local animator = khum:FindFirstChildOfClass("Animator")
                            if animator then
                                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                    local a = track.Animation
                                    if a and a.AnimationId then
                                        local id = a.AnimationId:match("%d+")
                                        if id == "123047897844134" then isStunned = true; break end
                                    end
                                end
                            end
                        end
                        if isStunned then createStunIcon(p.Character)
                        else removeStunIcon(p.Character) end
                    else removeStunIcon(p.Character) end
                end
            end
        end
    end
end)

print("✅ [4/6] Loop + Aimlock + Kill Feed + Execute Monitor loaded")-- =========================================================
-- BAGIAN 5/6 : GUI GALAXY + TOMBOL KECIL + AIMLOCK + PANEL
-- =========================================================

gui = Instance.new("ScreenGui")
gui.Name = "RoooorHubGalaxy"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 9999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PG

-- TOMBOL MENU GALAXY (32×32) — posisi digeser ke bawah biar gak ketutup chat Roblox
btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(0, 32, 0, 32)
btnContainer.Position = UDim2.new(0, 15, 0.55, 0)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = gui

local outerGlow = Instance.new("Frame")
outerGlow.Size = UDim2.new(1, 14, 1, 14)
outerGlow.Position = UDim2.new(0, -7, 0, -7)
outerGlow.BackgroundColor3 = Color3.fromRGB(120, 60, 255)
outerGlow.BackgroundTransparency = 0.8
outerGlow.BorderSizePixel = 0
outerGlow.ZIndex = -1
outerGlow.Parent = btnContainer
rnd(outerGlow, 999)

local ringOuter = Instance.new("Frame")
ringOuter.Size = UDim2.new(1, 6, 1, 6)
ringOuter.Position = UDim2.new(0, -3, 0, -3)
ringOuter.BackgroundTransparency = 1
ringOuter.Parent = btnContainer

local ringOuterStroke = Instance.new("UIStroke")
ringOuterStroke.Thickness = 2
ringOuterStroke.Color = Color3.fromRGB(180, 100, 255)
ringOuterStroke.Transparency = 0.1
ringOuterStroke.Parent = ringOuter

local ringOuterGrad = Instance.new("UIGradient")
ringOuterGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 60, 255)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 230, 255)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(255, 80, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 60, 255)),
})
ringOuterGrad.Parent = ringOuterStroke

local ringInner = Instance.new("Frame")
ringInner.Size = UDim2.new(1, -2, 1, -2)
ringInner.Position = UDim2.new(0, 1, 0, 1)
ringInner.BackgroundTransparency = 1
ringInner.Parent = btnContainer

local ringInnerStroke = Instance.new("UIStroke")
ringInnerStroke.Thickness = 1
ringInnerStroke.Color = Color3.fromRGB(0, 230, 255)
ringInnerStroke.Transparency = 0.3
ringInnerStroke.Parent = ringInner

local mainBtn = Instance.new("TextButton")
mainBtn.Size = UDim2.new(1, -10, 1, -10)
mainBtn.Position = UDim2.new(0, 5, 0, 5)
mainBtn.BackgroundColor3 = Color3.fromRGB(25, 15, 50)
mainBtn.Text = "✨"
mainBtn.TextColor3 = Color3.fromRGB(220, 180, 255)
mainBtn.TextSize = 14
mainBtn.Font = Enum.Font.GothamBlack
mainBtn.BorderSizePixel = 0
mainBtn.AutoButtonColor = false
mainBtn.Parent = btnContainer
rnd(mainBtn, 999)

local btnGrad = Instance.new("UIGradient")
btnGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 30, 120)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 15, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 30, 120)),
})
btnGrad.Rotation = 45
btnGrad.Parent = mainBtn

local innerGlow = Instance.new("Frame")
innerGlow.Size = UDim2.new(0.5, 0, 0.5, 0)
innerGlow.Position = UDim2.new(0.25, 0, 0.25, 0)
innerGlow.BackgroundColor3 = Color3.fromRGB(0, 230, 255)
innerGlow.BackgroundTransparency = 0.6
innerGlow.BorderSizePixel = 0
innerGlow.ZIndex = -1
innerGlow.Parent = mainBtn
rnd(innerGlow, 999)

task.spawn(function()
    local t = 0
    while btnContainer.Parent do
        t = t + 0.03
        ringOuter.Rotation = t * 30
        ringOuterGrad.Rotation = t * 60
        ringInner.Rotation = -t * 50
        local pulse = (math.sin(t * 3) + 1) / 2
        outerGlow.BackgroundTransparency = 0.8 - pulse * 0.3
        outerGlow.Size = UDim2.new(1, 14 + pulse * 8, 1, 14 + pulse * 8)
        outerGlow.Position = UDim2.new(0, -7 - pulse * 4, 0, -7 - pulse * 4)
        ringOuterStroke.Transparency = 0.2 - pulse * 0.15
        ringInnerStroke.Transparency = 0.4 - pulse * 0.3
        btnGrad.Rotation = t * 30
        mainBtn.TextColor3 = Color3.fromHSV((t * 0.15) % 1, 0.5, 1)
        mainBtn.TextSize = 14 + math.sin(t * 4) * 1
        innerGlow.BackgroundTransparency = 0.6 - pulse * 0.4
        task.wait(0.03)
    end
end)

for i = 1, 8 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, 2, 0, 2)
    particle.BorderSizePixel = 0
    particle.ZIndex = 4
    particle.Parent = btnContainer
    rnd(particle, 999)
    local angle = (i / 8) * math.pi * 2
    local orbitSpeed = 1.5 + math.random() * 1.5
    local radius = 20
    task.spawn(function()
        while btnContainer.Parent do
            local t = tick()
            local x = math.cos(t * orbitSpeed + angle) * radius
            local y = math.sin(t * orbitSpeed + angle) * radius
            particle.Position = UDim2.new(0.5, x - 1, 0.5, y - 1)
            particle.BackgroundColor3 = Color3.fromHSV((t * 0.15 + i * 0.1) % 1, 0.7, 1)
            particle.BackgroundTransparency = 0.2 + math.sin(t * 4 + i) * 0.3
            task.wait(0.03)
        end
    end)
end

dragging = false
dragStart = nil
startPos = nil
wasDragged = false

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

-- AIMLOCK FLOATING BUTTON
aimBtnGui = Instance.new("ScreenGui")
aimBtnGui.Name = "RoooorAimlockBtn"
aimBtnGui.ResetOnSpawn = false
aimBtnGui.IgnoreGuiInset = true
aimBtnGui.DisplayOrder = 9999998
aimBtnGui.Parent = PG

aimContainer = Instance.new("Frame")
aimContainer.Size = UDim2.new(0, 40, 0, 40)
aimContainer.Position = UDim2.new(0, 15, 0.65, 0)
aimContainer.BackgroundTransparency = 1
aimContainer.Parent = aimBtnGui

local aimOuterRing = Instance.new("Frame")
aimOuterRing.Size = UDim2.new(1, 6, 1, 6)
aimOuterRing.Position = UDim2.new(0, -3, 0, -3)
aimOuterRing.BackgroundTransparency = 1
aimOuterRing.Parent = aimContainer

local aimOuterStroke = Instance.new("UIStroke")
aimOuterStroke.Thickness = 2
aimOuterStroke.Color = C.ACC2
aimOuterStroke.Transparency = 0.1
aimOuterStroke.Parent = aimOuterRing

local aimOuterGrad = Instance.new("UIGradient")
aimOuterGrad.Color = ColorSequence.new(C.ACC, C.ACC2, C.ACC3)
aimOuterGrad.Parent = aimOuterStroke

local aimBtn = Instance.new("TextButton")
aimBtn.Size = UDim2.new(1, -8, 1, -8)
aimBtn.Position = UDim2.new(0, 4, 0, 4)
aimBtn.BackgroundColor3 = Color3.fromRGB(25, 15, 50)
aimBtn.Text = "🎯"
aimBtn.TextColor3 = C.ACC2
aimBtn.TextSize = 18
aimBtn.Font = Enum.Font.GothamBlack
aimBtn.BorderSizePixel = 0
aimBtn.AutoButtonColor = false
aimBtn.Parent = aimContainer
rnd(aimBtn, 999)

local aimBtnGrad = Instance.new("UIGradient")
aimBtnGrad.Color = ColorSequence.new(
    Color3.fromRGB(60, 30, 120),
    Color3.fromRGB(25, 15, 50),
    Color3.fromRGB(60, 30, 120)
)
aimBtnGrad.Rotation = 45
aimBtnGrad.Parent = aimBtn

local aimModeLbl = Instance.new("TextLabel")
aimModeLbl.Size = UDim2.new(0, 100, 0, 14)
aimModeLbl.Position = UDim2.new(0.5, -50, 1, 2)
aimModeLbl.BackgroundTransparency = 1
aimModeLbl.Text = "KILLER"
aimModeLbl.TextColor3 = C.ACC4
aimModeLbl.TextSize = 9
aimModeLbl.Font = Enum.Font.GothamBlack
aimModeLbl.TextStrokeTransparency = 0.3
aimModeLbl.Parent = aimBtn

task.spawn(function()
    local t = 0
    while aimContainer.Parent do
        t = t + 0.03
        aimOuterRing.Rotation = t * 60
        aimOuterGrad.Rotation = t * 100
        local pulse = (math.sin(t * 4) + 1) / 2
        aimOuterStroke.Transparency = Combat.Holding and (0.1 - pulse * 0.1) or (0.5 - pulse * 0.3)
        task.wait(0.03)
    end
end)

aimDragging, aimDS, aimDP, aimWasDragged = false, nil, nil, false

aimContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        aimDragging = true
        aimWasDragged = false
        aimDS = input.Position
        aimDP = aimContainer.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if aimDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - aimDS
        if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then aimWasDragged = true end
        aimContainer.Position = UDim2.new(
            aimDP.X.Scale, aimDP.X.Offset + d.X,
            aimDP.Y.Scale, aimDP.Y.Offset + d.Y
        )
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
        Combat.Holding = true
        aimBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 120)
    end
end)

aimBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Combat.Holding = false
        aimBtn.BackgroundColor3 = Color3.fromRGB(25, 15, 50)
    end
end)

aimBtn.MouseButton2Click:Connect(function()
    if Combat.Mode == "Killer" then
        Combat.Mode = "Survivor"
        aimModeLbl.Text = "SURVIVOR"
        aimModeLbl.TextColor3 = C.GRN
    else
        Combat.Mode = "Killer"
        aimModeLbl.Text = "KILLER"
        aimModeLbl.TextColor3 = C.ACC4
    end
end)

_G.Roooor_setAimlockVisible = function(visible)
    if aimBtnGui then aimBtnGui.Enabled = visible end
end

-- PANEL MENU GALAXY
panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 420, 0, 340)
panel.Position = UDim2.new(0.5, -210, 0.5, -170)
panel.BackgroundColor3 = C.BG
panel.BackgroundTransparency = 0.05
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = gui
rnd(panel, 18)
strk(panel, C.ACC, 2, 0.3)

local panelGrad = Instance.new("UIGradient")
panelGrad.Color = ColorSequence.new(C.BG, C.BG2, C.BG)
panelGrad.Rotation = 45
panelGrad.Parent = panel

task.spawn(function()
    local starsGui = Instance.new("Frame")
    starsGui.Size = UDim2.new(1, 0, 1, 0)
    starsGui.BackgroundTransparency = 1
    starsGui.ZIndex = 0
    starsGui.ClipsDescendants = true
    starsGui.Parent = panel
    rnd(starsGui, 18)
    for i = 1, 50 do
        local star = Instance.new("Frame")
        star.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
        star.Position = UDim2.new(math.random(), 0, math.random(), 0)
        star.BackgroundColor3 = Color3.fromHSV(math.random(), 0.5, 1)
        star.BackgroundTransparency = math.random(30, 90) / 100
        star.BorderSizePixel = 0
        star.ZIndex = 0
        star.Parent = starsGui
        rnd(star, 999)
        task.spawn(function()
            while star.Parent do
                star.BackgroundTransparency = 0.3 + math.sin(tick() * 2 + i) * 0.5
                task.wait(0.1)
            end
        end)
    end
    for i = 1, 3 do
        local nebula = Instance.new("Frame")
        nebula.Size = UDim2.new(0, math.random(80, 150), 0, math.random(80, 150))
        nebula.Position = UDim2.new(math.random(), 0, math.random(), 0)
        nebula.BackgroundColor3 = Color3.fromHSV(math.random(), 0.7, 1)
        nebula.BackgroundTransparency = 0.85
        nebula.BorderSizePixel = 0
        nebula.ZIndex = 0
        nebula.Parent = starsGui
        rnd(nebula, 999)
        task.spawn(function()
            local startX = nebula.Position.X.Scale
            local startY = nebula.Position.Y.Scale
            while nebula.Parent do
                local t = tick()
                nebula.Position = UDim2.new(
                    startX + math.sin(t * 0.3 + i) * 0.05, 0,
                    startY + math.cos(t * 0.4 + i) * 0.05, 0
                )
                task.wait(0.1)
            end
        end)
    end
end)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = C.PANEL
header.BackgroundTransparency = 0.1
header.BorderSizePixel = 0
header.Parent = panel
rnd(header, 18)

local hPatch = Instance.new("Frame")
hPatch.Size = UDim2.new(1, 0, 0, 20)
hPatch.Position = UDim2.new(0, 0, 1, -20)
hPatch.BackgroundColor3 = C.PANEL
hPatch.BackgroundTransparency = 0.1
hPatch.BorderSizePixel = 0
hPatch.Parent = header

local neonLine = Instance.new("Frame")
neonLine.Size = UDim2.new(1, -40, 0, 3)
neonLine.Position = UDim2.new(0, 20, 1, -1.5)
neonLine.BackgroundColor3 = C.ACC2
neonLine.BorderSizePixel = 0
neonLine.Parent = header

local neonGrad = Instance.new("UIGradient")
neonGrad.Color = ColorSequence.new(
    Color3.fromRGB(120, 60, 255),
    Color3.fromRGB(0, 230, 255),
    Color3.fromRGB(255, 80, 200)
)
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
hTitle.Size = UDim2.new(1, -80, 1, 0)
hTitle.Position = UDim2.new(0, 16, 0, 0)
hTitle.BackgroundTransparency = 1
hTitle.Text = "✨ ROOORHUB GALAXY"
hTitle.TextColor3 = C.FIRE_BRIGHT
hTitle.TextSize = 13
hTitle.Font = Enum.Font.GothamBlack
hTitle.TextXAlignment = Enum.TextXAlignment.Left
hTitle.TextStrokeTransparency = 0.2
hTitle.TextStrokeColor3 = C.ACC
hTitle.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -30, 0.5, -11)
closeBtn.BackgroundColor3 = C.PANEL2
closeBtn.Text = "✕"
closeBtn.TextColor3 = C.RED
closeBtn.TextSize = 11
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = header
rnd(closeBtn, 7)
strk(closeBtn, C.RED, 1, 0.5)

sbFrame = Instance.new("Frame")
sbFrame.Size = UDim2.new(0, 105, 1, -58)
sbFrame.Position = UDim2.new(0, 10, 0, 50)
sbFrame.BackgroundColor3 = C.PANEL
sbFrame.BackgroundTransparency = 0.15
sbFrame.BorderSizePixel = 0
sbFrame.Parent = panel
rnd(sbFrame, 12)
strk(sbFrame, C.ACC, 1, 0.5)

sb = Instance.new("ScrollingFrame")
sb.Size = UDim2.new(1, -4, 1, -4)
sb.Position = UDim2.new(0, 2, 0, 2)
sb.BackgroundTransparency = 1
sb.BorderSizePixel = 0
sb.ScrollBarThickness = 3
sb.ScrollBarImageColor3 = C.ACC2
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

ct = Instance.new("Frame")
ct.Size = UDim2.new(1, -135, 1, -58)
ct.Position = UDim2.new(0, 122, 0, 50)
ct.BackgroundColor3 = C.PANEL
ct.BackgroundTransparency = 0.15
ct.BorderSizePixel = 0
ct.Parent = panel
rnd(ct, 12)
strk(ct, C.ACC, 1, 0.5)

cs = Instance.new("ScrollingFrame")
cs.Size = UDim2.new(1, -14, 1, -14)
cs.Position = UDim2.new(0, 7, 0, 7)
cs.BackgroundTransparency = 1
cs.BorderSizePixel = 0
cs.ScrollBarThickness = 3
cs.ScrollBarImageColor3 = C.ACC2
cs.CanvasSize = UDim2.new(0, 0, 0, 0)
cs.AutomaticCanvasSize = Enum.AutomaticSize.Y
cs.Parent = ct

local csL = Instance.new("UIListLayout")
csL.Padding = UDim.new(0, 5)
csL.Parent = cs

function sec(title, icon)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 22)
    f.BackgroundTransparency = 1
    f.Parent = cs
    local deco = Instance.new("Frame")
    deco.Size = UDim2.new(0, 4, 0, 14)
    deco.Position = UDim2.new(0, 4, 0.5, -7)
    deco.BackgroundColor3 = C.ACC
    deco.BorderSizePixel = 0
    deco.Parent = f
    rnd(deco, 2)
    local decoGrad = Instance.new("UIGradient")
    decoGrad.Color = ColorSequence.new(C.ACC, C.ACC2, C.ACC3)
    decoGrad.Parent = deco
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 1, 0)
    l.Position = UDim2.new(0, 14, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = icon .. " " .. string.upper(title)
    l.TextColor3 = C.FIRE_BRIGHT
    l.TextSize = 9
    l.Font = Enum.Font.GothamBlack
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
end

function lbl(text, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -4, 0, 16)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or C.DIM
    l.TextSize = 8
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = cs
end

function tog(name, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 28)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    local fStrk = strk(f, C.ACC, 1, 0.5)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 8, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 9
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local t = Instance.new("Frame")
    t.Size = UDim2.new(0, 32, 0, 16)
    t.Position = UDim2.new(1, -40, 0.5, -8)
    t.BorderSizePixel = 0
    t.Parent = f
    rnd(t, 9)
    local k = Instance.new("Frame")
    k.Size = UDim2.new(0, 11, 0, 11)
    k.BorderSizePixel = 0
    k.Parent = t
    rnd(k, 6)
    local saved = _G.ToggleStates[name]
    local state = (saved ~= nil) and saved or def
    _G.ToggleStates[name] = state
    t.BackgroundColor3 = state and C.ACC or C.PANEL
    k.Position = state and UDim2.new(1, -14, 0.5, -5.5) or UDim2.new(0, 3, 0.5, -5.5)
    k.BackgroundColor3 = state and Color3.new(1, 1, 1) or C.DIM
    local cB = Instance.new("TextButton")
    cB.Size = UDim2.new(1, 0, 1, 0)
    cB.BackgroundTransparency = 1
    cB.Text = ""
    cB.Parent = t
    cB.MouseButton1Click:Connect(function()
        state = not state
        _G.ToggleStates[name] = state
        TweenService:Create(k, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = state and UDim2.new(1, -14, 0.5, -5.5) or UDim2.new(0, 3, 0.5, -5.5),
            BackgroundColor3 = state and Color3.new(1, 1, 1) or C.DIM
        }):Play()
        TweenService:Create(t, TweenInfo.new(0.2), { BackgroundColor3 = state and C.ACC or C.PANEL }):Play()
        fStrk.Color = state and C.ACC2 or C.ACC
        playToggleSound()
        if cb then pcall(cb, state) end
    end)
end

function sl(name, min, max, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 36)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.ACC, 1, 0.5)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -55, 0, 14)
    l.Position = UDim2.new(0, 8, 0, 4)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 9
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local curVal = _G.SliderStates[name] or def
    _G.SliderStates[name] = curVal
    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0, 40, 0, 14)
    v.Position = UDim2.new(1, -48, 0, 4)
    v.BackgroundTransparency = 1
    v.Text = tostring(curVal)
    v.TextColor3 = C.ACC2
    v.TextSize = 9
    v.Font = Enum.Font.GothamBold
    v.TextXAlignment = Enum.TextXAlignment.Right
    v.Parent = f
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -20, 0, 5)
    bg.Position = UDim2.new(0, 10, 1, -11)
    bg.BackgroundColor3 = C.PANEL
    bg.BorderSizePixel = 0
    bg.Parent = f
    rnd(bg, 3)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((curVal - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = C.ACC2
    fill.BorderSizePixel = 0
    fill.Parent = bg
    rnd(fill, 3)
    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color = ColorSequence.new(C.ACC, C.ACC2, C.ACC3)
    fillGrad.Parent = fill
    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 11, 0, 11)
    kn.Position = UDim2.new((curVal - min) / (max - min), -5.5, 0.5, -5.5)
    kn.BackgroundColor3 = Color3.new(1, 1, 1)
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
        kn.Position = UDim2.new(pos, -5.5, 0.5, -5.5)
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
    strk(f, C.ACC, 1, 0.5)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 8, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 9
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local cB = Instance.new("TextButton")
    cB.Size = UDim2.new(0, 30, 0, 15)
    cB.Position = UDim2.new(1, -38, 0.5, -7.5)
    cB.BackgroundColor3 = def
    cB.Text = ""
    cB.BorderSizePixel = 0
    cB.Parent = f
    rnd(cB, 4)
    strk(cB, C.ACC2, 1.5)
    local presets = {
        Color3.fromRGB(120, 60, 255),
        Color3.fromRGB(0, 230, 255),
        Color3.fromRGB(255, 80, 200),
        Color3.fromRGB(255, 60, 60),
        Color3.fromRGB(60, 255, 120),
        Color3.fromRGB(255, 170, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 255, 255),
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
    b.Size = UDim2.new(1, -4, 0, 28)
    b.BackgroundColor3 = C.BG
    b.BackgroundTransparency = 0.4
    b.Text = name
    b.TextColor3 = C.TXT
    b.TextSize = 9
    b.Font = Enum.Font.GothamMedium
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = cs
    rnd(b, 8)
    strk(b, C.ACC2, 1, 0.5)
    b.MouseButton1Click:Connect(function()
        playToggleSound()
        if cb then pcall(cb) end
    end)
end

function drp(name, options, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 28)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.ACC, 1, 0.5)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.5, 0, 1, 0)
    l.Position = UDim2.new(0, 8, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 9
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local idx = 1
    for i, o in ipairs(options) do
        if o == def then idx = i end
    end
    local cur = options[idx]
    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0.5, -24, 1, 0)
    v.Position = UDim2.new(0.5, 0, 0, 0)
    v.BackgroundTransparency = 1
    v.Text = tostring(cur) .. " ▶"
    v.TextColor3 = C.ACC2
    v.TextSize = 8
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

activeTab = nil
function makeTab(name, icon, order, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 28)
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
    ind.BackgroundColor3 = C.ACC2
    ind.BorderSizePixel = 0
    ind.Parent = b
    rnd(ind, 2)
    local ico = Instance.new("TextLabel")
    ico.Size = UDim2.new(0, 20, 1, 0)
    ico.Position = UDim2.new(0, 6, 0, 0)
    ico.BackgroundTransparency = 1
    ico.Text = icon
    ico.TextColor3 = C.DIM
    ico.TextSize = 13
    ico.Font = Enum.Font.GothamBold
    ico.Parent = b
    local lblT = Instance.new("TextLabel")
    lblT.Size = UDim2.new(1, -26, 1, 0)
    lblT.Position = UDim2.new(0, 26, 0, 0)
    lblT.BackgroundTransparency = 1
    lblT.Text = string.upper(name)
    lblT.TextColor3 = C.DIM
    lblT.TextSize = 8
    lblT.Font = Enum.Font.GothamBlack
    lblT.TextXAlignment = Enum.TextXAlignment.Left
    lblT.Parent = b
    b.MouseButton1Click:Connect(function()
        if activeTab == b then return end
        if activeTab then
            activeTab.BackgroundTransparency = 1
            local oldInd = activeTab:FindFirstChildOfClass("Frame")
            if oldInd then
                TweenService:Create(oldInd, TweenInfo.new(0.2), { Size = UDim2.new(0, 3, 0, 0) }):Play()
            end
            for _, c in pairs(activeTab:GetChildren()) do
                if c:IsA("TextLabel") then
                    TweenService:Create(c, TweenInfo.new(0.2), { TextColor3 = C.DIM }):Play()
                end
            end
        end
        activeTab = b
        TweenService:Create(b, TweenInfo.new(0.2), { BackgroundTransparency = 0.7 }):Play()
        TweenService:Create(ind, TweenInfo.new(0.3, Enum.EasingStyle.Back), { Size = UDim2.new(0, 3, 0, 18) }):Play()
        for _, c in pairs(b:GetChildren()) do
            if c:IsA("TextLabel") then
                TweenService:Create(c, TweenInfo.new(0.2), { TextColor3 = C.TXT }):Play()
            end
        end
        for _, c in pairs(cs:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
        if cb then pcall(cb) end
    end)
end

_G.Roooor_sec = sec
_G.Roooor_lbl = lbl
_G.Roooor_tog = tog
_G.Roooor_sl = sl
_G.Roooor_cpk = cpk
_G.Roooor_btn = btn
_G.Roooor_drp = drp
_G.Roooor_makeTab = makeTab
_G.Roooor_cs = cs

mainBtn.MouseButton1Click:Connect(function()
    if wasDragged then wasDragged = false; return end
    panel.Visible = not panel.Visible
    playToggleSound()
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    playToggleSound()
end)

print("✅ [5/6] GUI GALAXY + Panel + Aimlock Button loaded")-- =========================================================
-- BAGIAN 6/6 : TAB UI + FINAL TOUCH + NOTIFIKASI
-- =========================================================
sec = _G.Roooor_sec
lbl = _G.Roooor_lbl
tog = _G.Roooor_tog
sl = _G.Roooor_sl
cpk = _G.Roooor_cpk
btn = _G.Roooor_btn
drp = _G.Roooor_drp
makeTab = _G.Roooor_makeTab
cs = _G.Roooor_cs

-- ============================
-- TAB: FIRE
-- ============================
makeTab("Fire", "🔥", 1, function()
    sec("Fire Control", "⚙️")
    tog("Enable Fire", false, function(s)
        S.FireOn = s
        applyFire()
    end)
    sl("Fire Size", 1, 15, 5, function(v)
        S.FireSize = v
        applyFire()
    end)
    sec("Pilih Efek Fire (60)", "🔥")
    lbl("Klik efek untuk ganti", C.FIRE_BRIGHT)
    for i, fireName in ipairs(FireList) do
        local btn2 = Instance.new("TextButton")
        btn2.Size = UDim2.new(1, -4, 0, 24)
        btn2.BackgroundColor3 = C.BG
        btn2.BackgroundTransparency = 0.4
        btn2.BorderSizePixel = 0
        btn2.Text = ""
        btn2.AutoButtonColor = false
        btn2.LayoutOrder = i + 100
        btn2.Parent = cs
        rnd(btn2, 7)
        strk(btn2, C.ACC, 1, 0.6)
        local btnLbl = Instance.new("TextLabel")
        btnLbl.Size = UDim2.new(1, -10, 1, 0)
        btnLbl.Position = UDim2.new(0, 8, 0, 0)
        btnLbl.BackgroundTransparency = 1
        btnLbl.Text = "🔥 " .. fireName
        btnLbl.TextColor3 = C.TXT
        btnLbl.TextSize = 9
        btnLbl.Font = Enum.Font.GothamMedium
        btnLbl.TextXAlignment = Enum.TextXAlignment.Left
        btnLbl.Parent = btn2
        if S.FireType == fireName then
            btn2.BackgroundColor3 = C.ACC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
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
            btn2.BackgroundColor3 = C.ACC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
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
        applyFireFeet()
    end)
    sec("Pilih Efek Fire Feet (20)", "🔥")
    lbl("Klik efek untuk ganti", C.FIRE_BRIGHT)
    for i, fireName in ipairs(FireFeetList) do
        local btn2 = Instance.new("TextButton")
        btn2.Size = UDim2.new(1, -4, 0, 24)
        btn2.BackgroundColor3 = C.BG
        btn2.BackgroundTransparency = 0.4
        btn2.BorderSizePixel = 0
        btn2.Text = ""
        btn2.AutoButtonColor = false
        btn2.LayoutOrder = i + 200
        btn2.Parent = cs
        rnd(btn2, 7)
        strk(btn2, C.ACC, 1, 0.6)
        local btnLbl = Instance.new("TextLabel")
        btnLbl.Size = UDim2.new(1, -10, 1, 0)
        btnLbl.Position = UDim2.new(0, 8, 0, 0)
        btnLbl.BackgroundTransparency = 1
        btnLbl.Text = "👟 " .. fireName
        btnLbl.TextColor3 = C.TXT
        btnLbl.TextSize = 9
        btnLbl.Font = Enum.Font.GothamMedium
        btnLbl.TextXAlignment = Enum.TextXAlignment.Left
        btnLbl.Parent = btn2
        if S.FireFeetType == fireName then
            btn2.BackgroundColor3 = C.ACC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
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
            btn2.BackgroundColor3 = C.ACC
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(1, 1, 1)
        end)
    end
end)

-- ============================
-- TAB: ESP
-- ============================
makeTab("ESP", "👁️", 3, function()
    sec("Player ESP", "🟢")
    tog("ESP Survivor", false, function(s) ESP.Survivor = s end)
    cpk("Survivor Color", TeamColors.Survivor, function(c) TeamColors.Survivor = c end)
    tog("ESP Killer", false, function(s) ESP.Killer = s end)
    cpk("Killer Color", TeamColors.Killer, function(c) TeamColors.Killer = c end)

    sec("Object ESP", "⚡")
    tog("ESP Generator", false, function(s) ESP.Generator = s end)
    cpk("Gen Color", GeneratorColor, function(c) GeneratorColor = c end)
    tog("ESP Pallet", false, function(s) ESP.Pallet = s end)
    cpk("Pallet Color", PalletColor, function(c) PalletColor = c end)
    tog("ESP Window", false, function(s) ESP.Window = s end)
    cpk("Window Color", WindowColor, function(c) WindowColor = c end)
    tog("ESP SCP", false, function(s) ESP.SCP = s end)
    cpk("SCP Color", SCPColor, function(c) SCPColor = c end)

    sec("ESP Distance", "📏")
    sl("ESP Radius", 10, 300, 50, function(v) ESP.Distance = v end)

    sec("Status ESP", "🟢")
    tog("Enable Status ESP", false, function(s) ESPStatus.Enabled = s end)
    tog("Show Name", true, function(s) ESPStatus.ShowName = s end)
    tog("Show Distance", true, function(s) ESPStatus.ShowDistance = s end)
    tog("Show Health", false, function(s) ESPStatus.ShowHealth = s end)
    sl("Status Radius", 20, 200, 50, function(v) ESPStatus.Radius = v end)
end)

-- ============================
-- TAB: SURVIVOR
-- ============================
makeTab("Survivor", "🏃", 4, function()
    sec("Auto Parry", "🛡️")
    tog("Enable Auto Parry", false, function(s)
        AutoParry.Enabled = s
        if s then scanKillers() end
    end)
    sl("Parry Distance", 5, 30, 15, function(v) AutoParry.ParryDistance = v end)
    sl("Face Sensitivity", -1, 1, -1, function(v)
        AutoParry.FaceSensitivity = v
        AutoParry.RequireFacing = (v > -1)
    end)
    lbl("Face Sens: -1 = 360° | 0.7 = Facing", C.GRN)
    sl("Parry Debounce", 0.05, 0.5, 0.2, function(v) PARRY_DEBOUNCE = v end)

    sec("Auto Skill Check", "⚡")
    tog("Auto Skill Check", false, function(s)
        SkillCheck.Enabled = s
        if s then startSkillCheck() end
    end)

    sec("Dodge & Defense", "🛡️")
    tog("Auto Dodge", false, function(s) S.AutoDodge = s end)
    sl("Dodge Range", 5, 30, 15, function(v) S.DodgeRange = v end)
    tog("Abyss Dodge", false, function(s) S.AbyssDodge = s end)
    tog("Anti Grab", false, function(s) S.AntiGrab = s end)
    tog("Anti Hook", false, function(s) S.AntiHook = s end)
    tog("Anti Blind", false, function(s) S.AntiBlind = s end)

    sec("Support", "💊")
    tog("Auto Heal", false, function(s) S.AutoHeal = s end)
    sl("Heal Threshold", 10, 90, 40, function(v) S.AutoHealThreshold = v end)
    tog("Auto Repair", false, function(s) S.AutoRepair = s end)
    tog("Auto Revive", false, function(s) S.AutoRevive = s end)
    tog("Instant Interact", false, function(s) S.InstantInteract = s end)
    tog("Auto Vault", false, function(s) S.AutoVault = s end)

    sec("Teleport", "🌀")
    btn("TP ke Finish Line", function() teleportToFinishLine() end)
    btn("TP ke Gate", function() teleportToGate() end)
    btn("TP ke Dalam Gate", function() teleportInsideGate() end)

    sec("Anti System", "🔒")
    tog("Anti Stun", false, function(s) S.AntiStun = s end)
    tog("Anti Ragdoll", false, function(s) S.AntiRagdoll = s end)
    tog("Anti Slow", false, function(s) S.AntiSlow = s end)
    tog("Anti AFK", false, function(s) S.AntiAFK = s end)

    sec("Parry Circle", "⭕")
    tog("Show Parry Circle", false, function(s) S.ParryCircle = s end)
    sl("Circle Size", 5, 30, 15, function(v) S.ParryCircleSize = v end)

    sec("Alert", "⚠️")
    tog("Safe Zone", false, function(s) S.SafeZone = s end)
    tog("Escape Alert", false, function(s) S.EscapeAlert = s end)
    sl("Alert Range", 20, 150, 60, function(v) S.EscapeAlertRange = v end)
end)

-- ============================
-- TAB: KILLER
-- ============================
makeTab("Killer", "🔪", 5, function()
    sec("Killer Attack", "⚔️")
    tog("Auto Attack", false, function(s) S.Killer_AutoAtk = s end)
    sl("Attack Delay", 0.1, 1, 0.35, function(v) S.Killer_AtkDelay = v end)
    tog("Kill All (Auto Chase + Atk)", false, function(s) S.Killer_KillAll = s end)

    sec("Killer Visual", "💀")
    tog("Kill Feed", false, function(s) S.KillFeed = s end)
    tog("Stun Notify", false, function(s) S.StunNotify = s end)
    tog("Kill Effect", false, function(s) S.KillEffect = s end)
    tog("Execute Anim (ROOORHUB)", true, function(s) S.ExecuteAnim = s end)
    lbl("Tulisan ROOORHUB muncul saat kill", C.ACC2)

    sec("Masked Power", "🎭")
    drp("Power", {"Cobra", "Bear", "Wolf", "Tiger", "Eagle"}, "Cobra", function(v) S.MaskedPower = v end)
end)

-- ============================
-- TAB: COMBAT / AIMLOCK
-- ============================
makeTab("Combat", "🎯", 6, function()
    sec("Aimlock", "🎯")
    tog("Enable Aimlock", true, function(s) Combat.AimlockEnabled = s end)
    lbl("⚠️ Tahan tombol 🎯 untuk lock", C.ACC2)
    lbl("Lepas tombol = lock hilang", C.GRN)

    drp("Mode", {"Killer", "Survivor"}, Combat.Mode, function(v) Combat.Mode = v end)
    sl("Smoothness", 0.05, 1, 0.35, function(v) Combat.Smoothness = v end)
    sl("Lock Radius", 50, 1000, 300, function(v) Combat.LockRadius = v end)
    drp("Aim Part", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Combat.AimPart, function(v) Combat.AimPart = v end)

    sec("Prediction", "📈")
    tog("Predict Movement", true, function(s) Combat.Predict = s end)
    sl("Predict Strength", 0, 0.5, 0.15, function(v) Combat.PredictStrength = v end)

    sec("Aimlock Button", "🔘")
    tog("Show Aimlock Button", false, function(s)
        if _G.Roooor_setAimlockVisible then _G.Roooor_setAimlockVisible(s) end
    end)
end)

-- ============================
-- TAB: VISUAL HD
-- ============================
makeTab("Visual HD", "✨", 7, function()
    sec("Lighting Dasar", "💡")
    tog("Fullbright", false, function(s)
        S.Fullbright = s
        applyFullbright(s)
    end)
    sl("Fullbright Level", 10, 200, 50, function(v)
        S.FullbrightVal = v
        if S.Fullbright then applyFullbright(true) end
    end)
    tog("No Fog", false, function(s)
        S.NoFog = s
        applyNoFog(s)
    end)
    tog("Ultra HD", false, function(s)
        S.UltraHD = s
        applyUltraHD()
    end)
    tog("Contrast+", false, function(s)
        S.Contrast = s
        applyContrast()
    end)
    sl("Contrast Value", -1, 1, 0.3, function(v)
        S.ContrastVal = v
        if S.Contrast then applyContrast() end
    end)
    sl("Saturation Value", -1, 1, 0.2, function(v)
        S.SaturationVal = v
        if S.Contrast then applyContrast() end
    end)

    sec("Sky", "🌌")
    drp("Skybox", SkyList, S.SkyId, function(v)
        S.SkyId = v
        applySky(v)
    end)

    sec("FOV", "🎥")
    tog("Enable FOV", false, function(s)
        S.FOVEnabled = s
        applyFOV()
    end)
    sl("FOV Value", 30, 120, 70, function(v)
        S.FOV = v
        if S.FOVEnabled then applyFOV() end
    end)

    sec("✨ Bloom HD", "💫")
    tog("Enable Bloom", false, function(s)
        S.Bloom = s
        applyBloom()
    end)
    sl("Bloom Intensity", 0, 5, 1.2, function(v)
        S.BloomIntensity = v
        if S.Bloom then applyBloom() end
    end)
    sl("Bloom Size", 0, 56, 24, function(v)
        S.BloomSize = v
        if S.Bloom then applyBloom() end
    end)
    sl("Bloom Threshold", 0, 2, 0.8, function(v)
        S.BloomThreshold = v
        if S.Bloom then applyBloom() end
    end)

    sec("☀️ Sun Rays", "🌞")
    tog("Enable Sun Rays", false, function(s)
        S.SunRays = s
        applySunRays()
    end)
    sl("Intensity", 0, 1, 0.15, function(v)
        S.SunRaysIntensity = v
        if S.SunRays then applySunRays() end
    end)
    sl("Spread", 0, 5, 1, function(v)
        S.SunRaysSpread = v
        if S.SunRays then applySunRays() end
    end)

    sec("🎬 Depth of Field", "📷")
    tog("Enable DOF", false, function(s)
        S.DepthOfField = s
        applyDepthOfField()
    end)
    sl("Focus Distance", 0, 200, 20, function(v)
        S.DOFFocusDistance = v
        if S.DepthOfField then applyDepthOfField() end
    end)
    sl("In Focus Radius", 0, 100, 30, function(v)
        S.DOFInFocusRadius = v
        if S.DepthOfField then applyDepthOfField() end
    end)
    sl("Far Intensity", 0, 1, 0.3, function(v)
        S.DOFFarIntensity = v
        if S.DepthOfField then applyDepthOfField() end
    end)

    sec("🔪 Sharpen HD", "⚡")
    tog("Enable Sharpen", false, function(s)
        S.Sharpen = s
        applySharpen()
    end)
    sl("Sharpen Amount", 0, 1, 0.35, function(v)
        S.SharpenAmount = v
        if S.Sharpen then applySharpen() end
    end)

    sec("🎥 Cinematic Mode", "🎞️")
    tog("Enable Cinematic", false, function(s)
        S.Cinematic = s
        applyCinematic()
    end)
    sl("Bar Size", 0, 150, 40, function(v)
        S.CinematicBarSize = v
        if S.Cinematic then applyCinematic() end
    end)
    sl("Vignette", 0, 1, 0.4, function(v)
        S.CinematicVignette = v
        if S.Cinematic then applyCinematic() end
    end)

    sec("🌫️ Atmosphere HD", "☁️")
    tog("Enable Atmosphere", false, function(s)
        S.AtmosphereHD = s
        applyAtmosphereHD()
    end)
    sl("Density", 0, 1, 0.3, function(v)
        S.AtmosphereDensity = v
        if S.AtmosphereHD then applyAtmosphereHD() end
    end)
    sl("Haze", 0, 10, 1.5, function(v)
        S.AtmosphereHaze = v
        if S.AtmosphereHD then applyAtmosphereHD() end
    end)
    sl("Glare", 0, 1, 0.2, function(v)
        S.AtmosphereGlare = v
        if S.AtmosphereHD then applyAtmosphereHD() end
    end)
end)

-- ============================
-- TAB: CROWN
-- ============================
makeTab("Crown", "👑", 8, function()
    sec("👑 8-Bit Crown", "✨")
    tog("Enable 8-Bit Crown", false, function(s)
        S.EightBitCrown = s
        apply8BitCrown(s, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
    end)

    sec("Size (Besar-Kecil)", "📏")
    sl("Crown Size", 0.5, 5, 1, function(v)
        S.EightBitSize = v
        if S.EightBitCrown then
            apply8BitCrown(true, v, S.CrownX, S.CrownY, S.CrownZ)
        end
    end)

    sec("Position Control", "🎯")
    sl("X (Kiri-Kanan)", -3, 3, 0, function(v)
        S.CrownX = v
        if S.EightBitCrown then
            apply8BitCrown(true, S.EightBitSize, v, S.CrownY, S.CrownZ)
        end
    end)
    sl("Y (Atas-Bawah)", -2, 5, 1.2, function(v)
        S.CrownY = v
        if S.EightBitCrown then
            apply8BitCrown(true, S.EightBitSize, S.CrownX, v, S.CrownZ)
        end
    end)
    sl("Z (Depan-Belakang)", -3, 3, 0, function(v)
        S.CrownZ = v
        if S.EightBitCrown then
            apply8BitCrown(true, S.EightBitSize, S.CrownX, S.CrownY, v)
        end
    end)
    lbl("X=0, Y=1.2, Z=0 = default", C.DIM)

    sec("Character Visual", "👤")
    tog("Korblox Leg", false, function(s)
        S.Korblox = s
        applyKorblox(s)
    end)
    tog("Headless", false, function(s)
        S.Headless = s
        applyHeadless(s)
    end)

    sec("Trail / Aura", "💫")
    tog("Trail Fire", false, function(s)
        S.Trail = s
        applyTrail(s, S.TrailColor)
    end)
    cpk("Trail Color", S.TrailColor, function(c)
        S.TrailColor = c
        if S.Trail then applyTrail(true, c) end
    end)
    tog("Aura", false, function(s)
        S.Aura = s
        applyAura(s, S.AuraColor)
    end)
    cpk("Aura Color", S.AuraColor, function(c)
        S.AuraColor = c
        if S.Aura then applyAura(true, c) end
    end)

    sec("Crosshair", "➕")
    tog("Enable Crosshair", false, function(s)
        S.Crosshair = s
        applyCrosshair(s, S.CrosshairColor, S.CrosshairSize)
    end)
    cpk("Crosshair Color", S.CrosshairColor, function(c)
        S.CrosshairColor = c
        if S.Crosshair then applyCrosshair(true, c, S.CrosshairSize) end
    end)
    sl("Crosshair Size", 4, 20, 8, function(v)
        S.CrosshairSize = v
        if S.Crosshair then applyCrosshair(true, S.CrosshairColor, v) end
    end)

    sec("Camera", "📷")
    tog("No Clip Camera", false, function(s) S.NoClipCamera = s end)
    tog("Zoom Out", false, function(s)
        S.ZoomOut = s
        applyZoomOut(s, S.ZoomOutValue)
    end)
    sl("Zoom Distance", 128, 2000, 500, function(v)
        S.ZoomOutValue = v
        if S.ZoomOut then applyZoomOut(true, v) end
    end)
end)

-- ============================
-- TAB: MOVEMENT
-- ============================
makeTab("Movement", "🏃", 9, function()
    sec("Walk Speed", "⚡")
    tog("Enable WalkSpeed", false, function(s) S.WalkSpeed = s end)
    sl("WalkSpeed Value", 16, 100, 16, function(v) S.WalkSpeedVal = v end)
    sl("Speed Boost", 0, 100, 0, function(v) S.WalkSpeedBoost = v end)

    sec("Speed Hack", "🚀")
    tog("Enable SpeedHack", false, function(s) S.SpeedHack = s end)
    sl("SpeedHack Value", 16, 300, 40, function(v) S.SpeedHackVal = v end)

    sec("No Clip", "👻")
    tog("Enable NoClip", false, function(s) S.NoClip = s end)
end)

-- ============================
-- TAB: MISC
-- ============================
makeTab("Misc", "⚙️", 10, function()
    sec("Info", "ℹ️")
    lbl("RoooorHub Galaxy v3.2", C.ACC2)
    lbl("Execute Anim: ROOORHUB", C.GRN)
    lbl("Hold-to-Aim Fixed", C.GRN)

    sec("Reset", "🔄")
    btn("Reset Semua Toggle", function()
        _G.ToggleStates = {}
        lbl("Toggle di-reset, reopen panel", C.RED)
    end)
    btn("Reset Semua Slider", function()
        _G.SliderStates = {}
        lbl("Slider di-reset, reopen panel", C.RED)
    end)

    sec("Credits", "💜")
    lbl("Made with 💜 by RoooorHub", C.ACC3)
end)

print("✅ [6/6] Tab UI loaded")

-- =========================================================
-- NOTIFIKASI WELCOME
-- =========================================================
task.spawn(function()
    task.wait(1.5)
    local notif = Instance.new("ScreenGui")
    notif.Name = "RoooorWelcomeNotif"
    notif.ResetOnSpawn = false
    notif.IgnoreGuiInset = true
    notif.DisplayOrder = 2147483647
    notif.Parent = PG

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 80)
    frame.Position = UDim2.new(0.5, -160, 0, -100)
    frame.BackgroundColor3 = C.BG
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = notif
    rnd(frame, 14)
    strk(frame, C.ACC2, 2, 0.2)

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new(C.ACC, C.BG2, C.ACC3)
    grad.Rotation = 45
    grad.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "✨ ROOORHUB GALAXY v3.2"
    title.TextColor3 = C.FIRE_BRIGHT
    title.TextSize = 16
    title.Font = Enum.Font.GothamBlack
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -20, 0, 20)
    sub.Position = UDim2.new(0, 10, 0, 36)
    sub.BackgroundTransparency = 1
    sub.Text = "✅ Script loaded successfully!"
    sub.TextColor3 = C.GRN
    sub.TextSize = 11
    sub.Font = Enum.Font.GothamBold
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = frame

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, -20, 0, 16)
    hint.Position = UDim2.new(0, 10, 0, 56)
    hint.BackgroundTransparency = 1
    hint.Text = "Klik tombol ✨ di kiri layar untuk buka menu"
    hint.TextColor3 = C.DIM
    hint.TextSize = 9
    hint.Font = Enum.Font.Gotham
    hint.TextXAlignment = Enum.TextXAlignment.Left
    hint.Parent = frame

    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -160, 0, 20)
    }):Play()

    task.delay(4, function()
        TweenService:Create(frame, TweenInfo.new(0.5), {
            Position = UDim2.new(0.5, -160, 0, -100)
        }):Play()
        task.wait(0.6)
        notif:Destroy()
    end)
end)

-- =========================================================
-- AUTO RE-APPLY (CROWN / FIRE / TRAIL / AURA)
-- =========================================================
task.spawn(function()
    while task.wait(1) do
        if S.EightBitCrown and LP.Character then
            local head = LP.Character:FindFirstChild("Head")
            if head and not head:FindFirstChild("Roooor8BitCrown") then
                apply8BitCrown(true, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
            end
        end
        if S.FireOn and LP.Character then
            local head = LP.Character:FindFirstChild("Head")
            if head and not head:FindFirstChild("RoooorFire") then
                applyFire()
            end
        end
        if S.Trail and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            local existing = LP.Character:FindFirstChild("RoooorTrailFire")
            if hrp and not existing then
                applyTrail(true, S.TrailColor)
            end
        end
        if S.Aura and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp and not auraObj then
                applyAura(true, S.AuraColor)
            end
        end
    end
end)

-- =========================================================
-- EVENT PLAYER JOIN / LEAVE
-- =========================================================
Players.PlayerAdded:Connect(function(p)
    if p ~= LP and p.Team and p.Team.Name == "Killer" then
        task.wait(2)
        if p.Character then hookKiller(p.Character) end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if p.Character then
        removeStatusESP(p.Character)
        removeESP(p.Character)
    end
    if stunIcons[p.Character] then
        stunIcons[p.Character]:Destroy()
        stunIcons[p.Character] = nil
    end
end)

-- =========================================================
-- AUTO OPEN PANEL (opsional — kalau mau panel kebuka otomatis)
-- =========================================================
-- task.spawn(function()
--     task.wait(4)
--     if panel then panel.Visible = true end
--     task.wait(0.5)
--     if sb then
--         for _, c in pairs(sb:GetChildren()) do
--             if c:IsA("TextButton") then
--                 c.MouseButton1Click:Fire()
--                 break
--             end
--         end
--     end
-- end)

-- =========================================================
-- WELCOME MESSAGE
-- =========================================================
print("╔════════════════════════════════════════╗")
print("║   ✨ ROOORHUB GALAXY v3.2 ✨           ║")
print("║   EXECUTE ANIM: ROOORHUB               ║")
print("║   Hold-to-Aim Fixed                    ║")
print("║   All Features Working                 ║")
print("╚════════════════════════════════════════╝")
print("✅ [6/6] Final Touch loaded")
print("🎉 SC SIAP DIGUNAKAN!")
print("📌 Tombol ✨ di KIRI LAYAR (posisi tengah)")
print("📌 Tombol 🎯 di KIRI LAYAR (posisi bawah)")
