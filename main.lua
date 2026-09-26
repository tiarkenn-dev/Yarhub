--[[
    ╔══════════════════════════════════════════════╗
    ║           COSMIC HUB - v3.1                  ║
    ║   Moonwalk + Fast Vault 100% FALLENS         ║
    ║   + Crosshair 8 Mode + FPS Boost + Extra     ║
    ╚══════════════════════════════════════════════╝
]]

-- =========================================================
-- SECTION 1/11 : LOADING + CONFIG + STATE
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
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- WARNA TEMA
C = {
    BG = Color3.fromRGB(10, 5, 25),
    BG2 = Color3.fromRGB(20, 10, 45),
    PANEL = Color3.fromRGB(22, 12, 48),
    PANEL2 = Color3.fromRGB(35, 18, 75),
    ACC = Color3.fromRGB(140, 70, 255),
    ACC2 = Color3.fromRGB(0, 200, 255),
    ACC3 = Color3.fromRGB(255, 100, 200),
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

local ToggleSoundId = "rbxassetid://6073491164"

function playToggleSound()
    task.spawn(function()
        pcall(function()
            local s = Instance.new("Sound")
            s.SoundId = ToggleSoundId
            s.Volume = 0.5
            s.Parent = SoundService
            s:Play()
            task.wait(2)
            s:Destroy()
        end)
    end)
end

_G.Roooor_playSound = playToggleSound

-- LOADING GALAXY
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "CosmicLoading"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 999999
loadingGui.Parent = PG

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(8, 4, 20)
bg.BorderSizePixel = 0
bg.Parent = loadingGui

local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 10, 55)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 5, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 10, 55)),
})
bgGrad.Parent = bg

local ringContainer = Instance.new("Frame")
ringContainer.Size = UDim2.new(0, 240, 0, 240)
ringContainer.Position = UDim2.new(0.5, -120, 0.5, -180)
ringContainer.BackgroundTransparency = 1
ringContainer.Parent = bg

local rings = {}
for i = 1, 3 do
    local ring = Instance.new("Frame")
    local ringSize = 200 - (i - 1) * 50
    ring.Size = UDim2.new(0, ringSize, 0, ringSize)
    ring.Position = UDim2.new(0.5, -ringSize / 2, 0.5, -ringSize / 2)
    ring.BackgroundTransparency = 1
    ring.Parent = ringContainer

    local rStrk = Instance.new("UIStroke")
    rStrk.Thickness = 4 - (i - 1) * 0.5
    rStrk.Color = C.ACC2
    rStrk.Transparency = 0.05 + (i - 1) * 0.15
    rStrk.Parent = ring

    local rGrad = Instance.new("UIGradient")
    rGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.ACC),
        ColorSequenceKeypoint.new(0.5, C.ACC2),
        ColorSequenceKeypoint.new(1, C.ACC3),
    })
    rGrad.Parent = rStrk

    table.insert(rings, { ring = ring, grad = rGrad, speed = 40 + i * 25, dir = i % 2 == 0 and -1 or 1 })
end

local core = Instance.new("Frame")
core.Size = UDim2.new(0, 80, 0, 80)
core.Position = UDim2.new(0.5, -40, 0.5, -40)
core.BackgroundColor3 = C.ACC2
core.Parent = ringContainer
rnd(core, 999)

local coreGrad = Instance.new("UIGradient")
coreGrad.Color = ColorSequence.new(C.ACC, C.ACC2, C.ACC3)
coreGrad.Rotation = 45
coreGrad.Parent = core

local coreIcon = Instance.new("TextLabel")
coreIcon.Size = UDim2.new(1, 0, 1, 0)
coreIcon.BackgroundTransparency = 1
coreIcon.Text = "🌌"
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

local welcomeGrad = Instance.new("UIGradient")
welcomeGrad.Color = ColorSequence.new(C.ACC, C.ACC2, C.ACC3)
welcomeGrad.Parent = welcomeTitle

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 100)
subtitle.Position = UDim2.new(0, 0, 0.53, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "COSMIC HUB"
subtitle.TextColor3 = C.ACC2
subtitle.TextSize = 68
subtitle.Font = Enum.Font.GothamBlack
subtitle.TextStrokeTransparency = 0
subtitle.TextStrokeColor3 = C.ACC
subtitle.Parent = bg

local subGrad = Instance.new("UIGradient")
subGrad.Color = ColorSequence.new(C.ACC2, Color3.fromRGB(255, 220, 255), C.ACC3)
subGrad.Parent = subtitle

local tagline = Instance.new("TextLabel")
tagline.Size = UDim2.new(1, 0, 0, 30)
tagline.Position = UDim2.new(0, 0, 0.73, 20)
tagline.BackgroundTransparency = 1
tagline.Text = "✨ COSMIC HUB ✨"
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

local progGrad = Instance.new("UIGradient")
progGrad.Color = ColorSequence.new(C.ACC, C.ACC2, C.ACC3)
progGrad.Parent = progressFill

task.spawn(function()
    local t = 0
    while bg.Parent do
        t = t + 0.03
        for _, data in ipairs(rings) do
            data.ring.Rotation = t * data.speed * data.dir
            data.grad.Rotation = t * 90 * data.dir
        end
        local pulse = 1 + math.sin(t * 4) * 0.15
        core.Size = UDim2.new(0, 80 * pulse, 0, 80 * pulse)
        core.Position = UDim2.new(0.5, -40 * pulse, 0.5, -40 * pulse)
        core.Rotation = t * 50
        welcomeTitle.TextSize = 48 + math.sin(t * 3) * 3
        subtitle.TextSize = 68 + math.sin(t * 3 + 0.5) * 4
        task.wait(0.03)
    end
end)

task.spawn(function()
    for i = 0, 1, 0.02 do
        if not bg.Parent then break end
        progressFill.Size = UDim2.new(i, 0, 1, 0)
        task.wait(0.03)
    end
end)

task.delay(1.5, function()
    TweenService:Create(bg, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
    for _, el in pairs(bg:GetDescendants()) do
        pcall(function()
            if el:IsA("TextLabel") then
                TweenService:Create(el, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
            elseif el:IsA("Frame") then
                TweenService:Create(el, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
            elseif el:IsA("UIStroke") then
                TweenService:Create(el, TweenInfo.new(0.5), { Transparency = 1 }):Play()
            end
        end)
    end
    task.wait(0.5)
    loadingGui:Destroy()
end)

-- STATE UTAMA
_G.RoooorSavedStates = _G.RoooorSavedStates or {}

_G.RoooorS = _G.RoooorS or {
    -- Fire
    FireOn = false, FireType = "Classic", FireSize = 5,
    FireFeetOn = false, FireFeetType = "Classic",

    -- Parry
    ParryCircle = true, ParryCircleSize = 12,

    -- Movement
    WalkSpeed = false, WalkSpeedVal = 16, WalkSpeedBoost = 0,
    SpeedHack = false, SpeedHackVal = 40,
    NoClip = false, NoClipCamera = false,
    Fly = false, FlySpeed = 50,

    -- Character
    Korblox = true, KorbloxType = "Pencil",
    KorbloxYOffset = 0.6, KorbloxScale = 1,
    Headless = true,
    EightBitOn = true, EightBitType = "Royal Crown",
    EightBitSize = 1.24, EightBitHeight = 0.88,

    -- Effects
    Trail = false, TrailColor = Color3.fromRGB(120, 60, 255),
    Aura = false, AuraColor = Color3.fromRGB(120, 60, 255),
    KillEffect = false,

    -- CROSSHAIR 8 MODE + 2 WARNA
    Crosshair = false,
    CrosshairColor = Color3.fromRGB(0, 200, 255),
    CrosshairSize = 8,
    CrosshairThickness = 2,
    CrosshairStyle = "Plus",
    CrosshairColorMode = "Solid",
    CrosshairOffsetX = 0,
    CrosshairOffsetY = 0,

    -- Camera
    ZoomOut = false, ZoomOutValue = 500,
    FOV = 70, FOVEnabled = false,

    -- Visual
    Fullbright = false, FullbrightVal = 50,
    NoFog = false, UltraHD = false,
    Contrast = false, ContrastVal = 0.3, SaturationVal = 0.2,
    SkyId = "Default",

    -- FPS BOOST
    NoScreenEffects = false,
    LowGraphics = false,
    CleanSky = false,

    -- HUD
    SafeZone = false, EscapeAlert = false, EscapeAlertRange = 60,
    KillFeed = false, StunNotify = false,
    AntiAFK = false, ShowFPS = true, ShowPing = true,

    -- Killer
    Killer_AutoAtk = false, Killer_AtkDelay = 0.35,
    Killer_KillAll = false,
    MaskedPower = "Cobra",
    InstantInteract = false,

    -- AUTO CARRY + AUTO HOOK
    AutoCarry = false,
    AutoHook = false,
    CarryRange = 60,

    -- HD
    HDBoost = false, HDShader = false, HDSky = false,
    HDTexture = false, HDReflection = false, HDBloom = false,
    HDShadow = false, HDWater = false, HDSunRays = false,
    HDDepthField = false, HDAntiAliasing = false,

    -- Beam
    FireBeamOn = false, FireBeamType = "Classic Beam",
    FireBeamColor = Color3.fromRGB(120, 60, 255),

    -- ESP
    ESPNameMode = "Text", ESPNameSize = 12,

    -- AUTO ESCAPE GATE
    AutoEscapeGate = false,
    AutoEscapeRange = 50,
    AutoEscapeUseKillerCheck = true,
    AutoEscapeUseGenCheck = true,
}
S = _G.RoooorS

FPSPingConfig = _G.Roooor_FPSPing or { Size = 1, X = 0, Y = 0 }
_G.Roooor_FPSPing = FPSPingConfig

_G.ToggleStates = _G.ToggleStates or {}
_G.SliderStates = _G.SliderStates or {}

ESP = _G.Roooor_ESP or {
    Survivor = true, Killer = true, Generator = true,
    Pallet = false, Window = false, SCP = false, Distance = 500,
}
_G.Roooor_ESP = ESP

ESPStatus = _G.Roooor_ESPStatus or {
    Enabled = false, ShowName = true, ShowDistance = true,
    ShowHealth = false, Radius = 50,
}
_G.Roooor_ESPStatus = ESPStatus

TeamColors = _G.Roooor_TeamColors or {
    Killer = Color3.fromRGB(255, 60, 60),
    Survivor = Color3.fromRGB(0, 120, 255),
}
_G.Roooor_TeamColors = TeamColors

-- AUTO PARRY (Distance 5-20, Debounce 0.1-0.5)
AutoParry = _G.Roooor_AutoParry or {
    Enabled = true,
    ParryDistance = 15,
    ParryDelay = 0,
    Cooldown = 1,
    FaceSensitivity = 0.7,
    RequireFacing = true,
    Wiggle = false,
    WiggleSpam = 5,
}
_G.Roooor_AutoParry = AutoParry

PARRY_DEBOUNCE = 0.2
ParryActive = false

-- AUTO SKILL CHECK
SkillCheck = _G.Roooor_SkillCheck or {
    Enabled = true,
    Mode = "Perfect",
    HideNeedle = false,
    Success = 0,
    Total = 0,
}
_G.Roooor_SkillCheck = SkillCheck

-- =========================================================
-- MOONWALK (100% PERSIS FALLENS)
-- =========================================================
Moonwalk = _G.Roooor_Moonwalk or {
    Enabled = false,
    ShowButton = false,
    SpamSpeed = 30,
    Intensity = 35,
    SlowSpeed = 13,
    UseSlow = true,
    ButtonPos = UDim2.new(0.65, 0, 0.75, 0),
    GuiInstance = nil,
    ImageId = "rbxassetid://93349170559446",  -- 🆕 FALLENS ID
}
_G.Roooor_Moonwalk = Moonwalk

MoonwalkConnection = nil

-- =========================================================
-- FAST VAULT (100% PERSIS FALLENS)
-- =========================================================
FastVault = _G.Roooor_FastVault or {
    Enabled = false,
    Speed = 1.2,
    ReplaceMap = {
        ["rbxassetid://83873880822918"] = "rbxassetid://136962284480779", -- Running → Finesse
    },
}
_G.Roooor_FastVault = FastVault

VaultTracks = {}

-- AUTO FLEE KILLER
AutoFlee = _G.Roooor_AutoFlee or {
    Enabled = false,
    DetectDistance = 50,
    Cooldown = 0.1,
    LastFlee = 0,
}
_G.Roooor_AutoFlee = AutoFlee

-- LIST LAINNYA
EightBitList = { "Royal Crown" }
EightBitIds = { ["Royal Crown"] = 10138606900 }

KorbloxList = { "Pencil" }
KorbloxIds = { ["Pencil"] = 902942093 }

FireBeamList = {
    "Classic Beam", "Laser Beam", "Rainbow Beam",
    "Fire Wings", "Fire Halo", "Fire Hands",
    "Fire Foot Trail", "Fire Body Aura", "Fire Mouth", "Fire Eyes Glow",
}

GodMode = _G.Roooor_GodMode or { Enabled = false }
_G.Roooor_GodMode = GodMode

Combat = _G.Roooor_Combat or {
    AimlockEnabled = false,
    Holding = false,
    AttackHeld = false,
    Mode = "Killer",
    Smoothness = 0.01,
    LockRadius = 150,
    AimPart = "Head",
    Predict = true,
    PredictStrength = 0.15,
    VisibilityCheck = false,
    WallCheck = false,
    FOVCircle = false,
    FOVRadius = 200,
    TriggerBotEnabled = false,
    TriggerDelay = 0.05,
    HitboxSurvivor = false,
    HitboxKiller = false,
    HitboxSize = 25,
    HitboxVisible = false,
}
_G.Roooor_Combat = Combat

-- REMOTES
pcall(function()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local carry = remotes:FindFirstChild("Carry")
        if carry then
            CarryEvent = carry:FindFirstChild("CarrySurvivorEvent")
            HookEvent = carry:FindFirstChild("HookEvent")
        end
        local atk = remotes:FindFirstChild("Attacks")
        if atk then
            AttackEvent = atk:FindFirstChild("BasicAttack")
        end
    end
end)

print("✅ [1/11] COSMIC HUB v3.1 - Base + State loaded")
print("   Moonwalk  : 100% FALLENS")
print("   Fast Vault: 100% FALLENS")
print("   Auto Parry: Distance 5-20, Debounce 0.1-0.5")
print("   Crosshair : 8 MODE + 2 WARNA")-- =========================================================
-- SECTION 2/11 : FIRE CONFIG + SKY + KILLER ANIMS
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
    if not FireConfig[name] then
        FireConfig[name] = FireConfig.Classic
    end
end

FireFeetList = {
    "Classic", "Blue", "Green", "Purple", "Rainbow",
    "Golden", "Pink", "Cyan", "RedFire", "Ice",
    "Toxic", "Electric", "Blood", "Ghost", "Cosmic",
    "Dragon", "Divine", "Demon", "Shadow", "Phoenix"
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
    if not FireFeetConfig[name] then
        FireFeetConfig[name] = FireFeetConfig.Classic
    end
end

SkyList = {
    "Default", "Sunset", "Night", "Space", "Alien",
    "Purple", "Galaxy", "Void",
}

SkyIds = {
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

-- KILLER ANIMS (23 ID)
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

print("✅ [2/11] COSMIC HUB - Fire + Sky + KillerAnims loaded")-- =========================================================
-- SECTION 3/11 : FUNGSI UTAMA
-- =========================================================

-- =========================================================
-- AUTO SAVE SYSTEM
-- =========================================================
function saveState(key, value)
    _G.RoooorSavedStates = _G.RoooorSavedStates or {}
    _G.RoooorSavedStates[key] = value
end

function loadState(key, default)
    _G.RoooorSavedStates = _G.RoooorSavedStates or {}
    return _G.RoooorSavedStates[key] or default
end

task.spawn(function()
    while task.wait(2) do
        _G.RoooorSavedStates = _G.RoooorSavedStates or {}
        _G.RoooorSavedStates.S = S
        _G.RoooorSavedStates.ESP = ESP
        _G.RoooorSavedStates.AutoParry = AutoParry
        _G.RoooorSavedStates.SkillCheck = SkillCheck
        _G.RoooorSavedStates.Moonwalk = Moonwalk
        _G.RoooorSavedStates.Combat = Combat
        _G.RoooorSavedStates.GodMode = GodMode
        _G.RoooorSavedStates.AutoFlee = AutoFlee
        _G.RoooorSavedStates.FastVault = FastVault
    end
end)

-- =========================================================
-- FIRE (KEPALA)
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
    while task.wait(0.4) do
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

-- =========================================================
-- 8-BIT ROYAL CROWN (CLIENT-ONLY)
-- =========================================================
eightBitPart = nil

function clear8Bit()
    if eightBitPart then
        eightBitPart:Destroy()
        eightBitPart = nil
    end
end

function apply8Bit(enable, itemName, size, height)
    clear8Bit()
    if not enable then return end

    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    size = size or S.EightBitSize or 1.24
    height = height or S.EightBitHeight or 0.88

    eightBitPart = Instance.new("Part")
    eightBitPart.Name = "Client8Bit"
    eightBitPart.Size = Vector3.new(2, 2, 2) * size
    eightBitPart.CanCollide = false
    eightBitPart.Massless = true
    eightBitPart.Transparency = 0
    eightBitPart.Parent = head

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://10138606900"
    mesh.TextureId = "rbxassetid://10138606949"
    mesh.Scale = Vector3.new(1.5, 1.5, 1.5) * size
    mesh.Parent = eightBitPart

    local weld = Instance.new("Weld")
    weld.Part0 = head
    weld.Part1 = eightBitPart
    weld.C0 = CFrame.new(0, height * size, 0)
    weld.Parent = eightBitPart
end

-- =========================================================
-- KORBLOX PENCIL (CLIENT-ONLY)
-- =========================================================
korbloxParts = {}
korbloxOrigData = {}

function clearKorblox()
    for _, part in pairs(korbloxParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    korbloxParts = {}

    local char = LP.Character
    if char then
        for legName, data in pairs(korbloxOrigData) do
            local leg = char:FindFirstChild(legName)
            if leg then
                leg.Transparency = data.trans
                leg.CanCollide = data.collide
            end
        end
    end
    korbloxOrigData = {}
end

function applyKorblox(enable, mode, yOffset, scale)
    clearKorblox()
    if not enable then return end

    yOffset = yOffset or S.KorbloxYOffset or 0.6
    scale = scale or S.KorbloxScale or 1

    local char = LP.Character
    if not char then return end

    local legParts = {}
    for _, name in ipairs({
        "Right Leg", "RightUpperLeg", "RightLowerLeg", "RightFoot",
        "Right Knee", "Right Hip"
    }) do
        local leg = char:FindFirstChild(name)
        if leg then
            table.insert(legParts, leg)
        end
    end

    if #legParts == 0 then return end

    for _, leg in ipairs(legParts) do
        korbloxOrigData[leg.Name] = {
            trans = leg.Transparency,
            collide = leg.CanCollide,
        }
        leg.Transparency = 1
        leg.CanCollide = false
    end

    local mainPart = legParts[1]

    local korbloxPart = Instance.new("Part")
    korbloxPart.Name = "ClientKorblox"
    korbloxPart.Size = mainPart.Size
    korbloxPart.CanCollide = false
    korbloxPart.Massless = true
    korbloxPart.Transparency = 0
    korbloxPart.Parent = char

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://902942093"
    mesh.TextureId = "rbxassetid://902843398"

    local legSize = mainPart.Size
    mesh.Scale = Vector3.new(
        legSize.X * scale,
        legSize.Y * scale,
        legSize.Z * scale
    )
    mesh.Parent = korbloxPart

    local weld = Instance.new("Weld")
    weld.Part0 = mainPart
    weld.Part1 = korbloxPart
    weld.C0 = CFrame.new(0, yOffset, 0)
    weld.Parent = korbloxPart

    table.insert(korbloxParts, korbloxPart)
end

-- =========================================================
-- HEADLESS
-- =========================================================
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
                    if (v:IsA("Decal") or v:IsA("SpecialMesh") or v:IsA("Mesh"))
                        and v.Transparency ~= 1 then
                        v.Transparency = 1
                    end
                end
            end
        end
    end
end)

-- =========================================================
-- FIRE BEAM (10 EFEK)
-- =========================================================
fireBeamParts = {}
fireBeamConns = {}

function clearFireBeam()
    for _, p in pairs(fireBeamParts) do
        if p and p.Parent then p:Destroy() end
    end
    fireBeamParts = {}
    for _, c in pairs(fireBeamConns) do
        if c then pcall(function() c:Disconnect() end) end
    end
    fireBeamConns = {}
end

function applyFireBeam(enable, beamType, color)
    clearFireBeam()
    if not enable then return end

    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    beamType = beamType or S.FireBeamType or "Classic Beam"
    color = color or S.FireBeamColor or Color3.fromRGB(120, 60, 255)

    local function createBeamAttachment(parentPart, offset, lightColor)
        if not parentPart then return end
        local att = Instance.new("Attachment")
        att.Position = offset
        att.Parent = parentPart

        local beam = Instance.new("Beam")
        beam.Color = ColorSequence.new(lightColor)
        beam.Width0 = 0.15
        beam.Width1 = 0.15
        beam.FaceCamera = true
        beam.Attachment0 = att
        beam.LightEmission = 1
        beam.LightInfluence = 0
        beam.Parent = parentPart

        local fire = Instance.new("Fire")
        fire.Size = 2
        fire.Heat = 20
        fire.Color = lightColor
        fire.SecondaryColor = Color3.new(1, 1, 1)
        fire.Parent = parentPart

        return att
    end

    if beamType == "Classic Beam" then
        createBeamAttachment(head, Vector3.new(0.3, 0.2, -0.5), color)
        createBeamAttachment(head, Vector3.new(-0.3, 0.2, -0.5), color)
    elseif beamType == "Laser Beam" then
        createBeamAttachment(head, Vector3.new(0.3, 0.2, -0.5), Color3.fromRGB(0, 230, 255))
        createBeamAttachment(head, Vector3.new(-0.3, 0.2, -0.5), Color3.fromRGB(0, 230, 255))
    elseif beamType == "Rainbow Beam" then
        createBeamAttachment(head, Vector3.new(0.3, 0.2, -0.5), color)
        createBeamAttachment(head, Vector3.new(-0.3, 0.2, -0.5), color)
        table.insert(fireBeamConns, RunService.RenderStepped:Connect(function()
            local t = tick()
            for _, beam in pairs(head:GetChildren()) do
                if beam:IsA("Beam") then
                    beam.Color = ColorSequence.new(Color3.fromHSV((t * 0.5) % 1, 1, 1))
                end
            end
        end))
    elseif beamType == "Fire Wings" then
        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        if torso then
            createBeamAttachment(torso, Vector3.new(1, 1, 0), color)
            createBeamAttachment(torso, Vector3.new(-1, 1, 0), color)
        end
    elseif beamType == "Fire Halo" then
        for i = 1, 12 do
            local angle = (i / 12) * math.pi * 2
            createBeamAttachment(head, Vector3.new(math.cos(angle) * 1.5, 1.5, math.sin(angle) * 1.5), color)
        end
    elseif beamType == "Fire Hands" then
        local lHand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
        local rHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
        if lHand then createBeamAttachment(lHand, Vector3.new(0, -0.5, 0), color) end
        if rHand then createBeamAttachment(rHand, Vector3.new(0, -0.5, 0), color) end
    elseif beamType == "Fire Foot Trail" then
        local lFoot = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg")
        local rFoot = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg")
        if lFoot then createBeamAttachment(lFoot, Vector3.new(0, -0.5, 0), color) end
        if rFoot then createBeamAttachment(rFoot, Vector3.new(0, -0.5, 0), color) end
    elseif beamType == "Fire Body Aura" then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for i = 1, 8 do
                local angle = (i / 8) * math.pi * 2
                createBeamAttachment(hrp, Vector3.new(math.cos(angle) * 1, 0, math.sin(angle) * 1), color)
            end
        end
    elseif beamType == "Fire Mouth" then
        createBeamAttachment(head, Vector3.new(0, -0.3, -0.6), color)
    elseif beamType == "Fire Eyes Glow" then
        createBeamAttachment(head, Vector3.new(0.3, 0.3, -0.5), color)
        createBeamAttachment(head, Vector3.new(-0.3, 0.3, -0.5), color)
    end
end

-- =========================================================
-- HD VISUAL (8 EXTRA)
-- =========================================================
hdExtras = {}

function applyHDTexture(s)
    if s then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
        end)
    end
end

function applyHDReflection(s)
    if s then
        if not hdExtras.Reflection then
            hdExtras.Reflection = Instance.new("ColorCorrectionEffect")
            hdExtras.Reflection.Name = "CosmicReflection"
            hdExtras.Reflection.Brightness = 0.05
            hdExtras.Reflection.Contrast = 0.1
            hdExtras.Reflection.Parent = Lighting
        end
    else
        if hdExtras.Reflection then hdExtras.Reflection:Destroy(); hdExtras.Reflection = nil end
    end
end

function applyHDBloom(s)
    if s then
        if not hdExtras.Bloom then
            hdExtras.Bloom = Instance.new("BloomEffect")
            hdExtras.Bloom.Name = "CosmicHDBloom2"
            hdExtras.Bloom.Intensity = 0.7
            hdExtras.Bloom.Size = 24
            hdExtras.Bloom.Threshold = 0.9
            hdExtras.Bloom.Parent = Lighting
        end
    else
        if hdExtras.Bloom then hdExtras.Bloom:Destroy(); hdExtras.Bloom = nil end
    end
end

function applyHDShadow(s)
    if s then
        Lighting.GlobalShadows = true
    end
end

function applyHDWater(s)
    if s then
        if not hdExtras.Water then
            hdExtras.Water = Instance.new("ColorCorrectionEffect")
            hdExtras.Water.Name = "CosmicWater"
            hdExtras.Water.TintColor = Color3.fromRGB(180, 220, 255)
            hdExtras.Water.Parent = Lighting
        end
    else
        if hdExtras.Water then hdExtras.Water:Destroy(); hdExtras.Water = nil end
    end
end

function applyHDSunRays(s)
    if s then
        if not hdExtras.SunRays then
            hdExtras.SunRays = Instance.new("SunRaysEffect")
            hdExtras.SunRays.Name = "CosmicSunRays"
            hdExtras.SunRays.Intensity = 0.15
            hdExtras.SunRays.Spread = 1
            hdExtras.SunRays.Parent = Lighting
        end
    else
        if hdExtras.SunRays then hdExtras.SunRays:Destroy(); hdExtras.SunRays = nil end
    end
end

function applyHDDepthField(s)
    if s then
        if not hdExtras.DepthField then
            hdExtras.DepthField = Instance.new("DepthOfFieldEffect")
            hdExtras.DepthField.Name = "CosmicDOF"
            hdExtras.DepthField.FarIntensity = 0.15
            hdExtras.DepthField.FocusDistance = 20
            hdExtras.DepthField.InFocusRadius = 15
            hdExtras.DepthField.NearIntensity = 0.1
            hdExtras.DepthField.Parent = Lighting
        end
    else
        if hdExtras.DepthField then hdExtras.DepthField:Destroy(); hdExtras.DepthField = nil end
    end
end

function applyHDAntiAliasing(s)
    if s then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
        end)
    end
end

-- =========================================================
-- MISC UTILITY (Anti-AFK + Rejoin + Server Hop)
-- =========================================================
function applyAntiAFK(enable)
    S.AntiAFK = enable
end

function serverHop()
    local HttpService = game:GetService("HttpService")
    task.spawn(function()
        local servers = {}
        pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local response = HttpService:JSONDecode(game:HttpGet(url))
            if response and response.data then
                for _, server in ipairs(response.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        table.insert(servers, server.id)
                    end
                end
            end
        end)
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, randomServer, LP)
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Server Hop",
                Text = "Nggak ada server lain 😐",
                Duration = 3
            })
        end
    end)
end

function rejoinServer()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
end

-- =========================================================
-- FPS + PING COUNTER (🆕 PUTIH SOLID - NO GRADIENT)
-- =========================================================
fpsPingGui = nil
fpsCounter = 0
fpsLastTime = tick()
currentFPS = 0
currentPing = 0

function createFPSPingGui()
    if fpsPingGui then fpsPingGui:Destroy() end
    fpsPingGui = Instance.new("ScreenGui")
    fpsPingGui.Name = "CosmicFPSPing"
    fpsPingGui.ResetOnSpawn = false
    fpsPingGui.IgnoreGuiInset = true
    fpsPingGui.Parent = PG

    local sizeScale = FPSPingConfig.Size or 1

    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, math.floor(110 * sizeScale), 0, math.floor(42 * sizeScale))
    frame.Position = UDim2.new(1, -math.floor(120 * sizeScale) + (FPSPingConfig.X or 0), 0, 5 + (FPSPingConfig.Y or 0))
    frame.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = fpsPingGui
    rnd(frame, 8)
    strk(frame, C.ACC, 1.5, 0.3)

    -- 🆕 FPS LABEL - PUTIH SOLID
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Name = "FPSLabel"
    fpsLabel.Size = UDim2.new(1, -8, 0, 18 * sizeScale)
    fpsLabel.Position = UDim2.new(0, 4, 0, 3)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS: 0"
    fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- 🆕 PUTIH
    fpsLabel.TextSize = math.floor(11 * sizeScale)
    fpsLabel.Font = Enum.Font.GothamBold
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.Parent = frame
    -- ❌ NO GRADIENT - HAPUS UIGRADIENT

    -- 🆕 PING LABEL - PUTIH SOLID
    local pingLabel = Instance.new("TextLabel")
    pingLabel.Name = "PingLabel"
    pingLabel.Size = UDim2.new(1, -8, 0, 18 * sizeScale)
    pingLabel.Position = UDim2.new(0, 4, 0, 21 * sizeScale)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text = "Ping: 0 ms"
    pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- 🆕 PUTIH
    pingLabel.TextSize = math.floor(11 * sizeScale)
    pingLabel.Font = Enum.Font.GothamBold
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left
    pingLabel.Parent = frame
    -- ❌ NO GRADIENT - HAPUS UIGRADIENT
end

-- FPS counter via RenderStepped (NO STUTTER)
RunService.RenderStepped:Connect(function()
    fpsCounter = fpsCounter + 1
    if tick() - fpsLastTime >= 1 then
        currentFPS = fpsCounter
        fpsCounter = 0
        fpsLastTime = tick()
        pcall(function()
            currentPing = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if not fpsPingGui then
            createFPSPingGui()
        end
        if fpsPingGui then
            local frame = fpsPingGui:FindFirstChild("MainFrame")
            if frame then
                local fpsLabel = frame:FindFirstChild("FPSLabel")
                local pingLabel = frame:FindFirstChild("PingLabel")
                if fpsLabel and pingLabel then
                    if S.ShowFPS then
                        fpsLabel.Visible = true
                        fpsLabel.Text = "FPS: " .. tostring(currentFPS)
                    else
                        fpsLabel.Visible = false
                    end
                    if S.ShowPing then
                        pingLabel.Visible = true
                        pingLabel.Text = "Ping: " .. tostring(currentPing) .. " ms"
                    else
                        pingLabel.Visible = false
                    end
                end
            end
        end
    end
end)

function updateFPSPing()
    if fpsPingGui then
        fpsPingGui:Destroy()
        fpsPingGui = nil
    end
    createFPSPingGui()
end

_G.Roooor_updateFPSPing = updateFPSPing

print("✅ [3/11] COSMIC HUB - Fungsi utama loaded (FPS/Ping PUTIH)")-- =========================================================
-- SECTION 4/11 : ESP + PARRY + SKILLCHECK + MOONWALK + FASTVAULT + CROSSHAIR
-- =========================================================

-- ESP SYSTEM (SAMA KAYAK SEBELUMNYA)
ESPObjects = {}
StatusESP = {}
CachedSCP = {}
Cached = { Generators = {}, Windows = {}, Pallets = {} }
GeneratorColor = Color3.fromRGB(255, 170, 0)
PalletColor = Color3.fromRGB(74, 255, 181)
WindowColor = Color3.fromRGB(74, 255, 181)
SCPColor = Color3.fromRGB(255, 0, 0)

function cacheObject(obj)
    if obj.Name == "Generator" then
        Cached.Generators[obj] = true
    elseif obj.Name == "Window" then
        Cached.Windows[obj] = true
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        Cached.Pallets[obj] = true
    end
    local name = string.lower(obj.Name)
    if string.find(name, "scp") then
        CachedSCP[obj] = true
    end
end

function removeCache(obj)
    Cached.Generators[obj] = nil
    Cached.Windows[obj] = nil
    Cached.Pallets[obj] = nil
    CachedSCP[obj] = nil
    if ESPObjects[obj] then
        ESPObjects[obj]:Destroy()
        ESPObjects[obj] = nil
    end
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
            if ESPObjects[obj] then
                ESPObjects[obj]:Destroy()
                ESPObjects[obj] = nil
            end
        end
    end)
end

function removeESP(obj)
    if ESPObjects[obj] then
        ESPObjects[obj]:Destroy()
        ESPObjects[obj] = nil
    end
end

function removeStatusESP(char)
    if StatusESP[char] then
        StatusESP[char]:Destroy()
        StatusESP[char] = nil
    end
end

function createStatusESP(player, char, root)
    if not ESPStatus.Enabled then
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
    if dist > ESPStatus.Radius then
        removeStatusESP(char)
        return
    end

    local text = ""
    if isDown then text = text .. "🔻 DOWN\n" end
    if ESPStatus.ShowName then text = text .. player.Name .. "\n" end
    if ESPStatus.ShowDistance then text = text .. string.format("Dist: %.0f\n", dist) end
    if ESPStatus.ShowHealth then text = text .. string.format("HP: %.0f\n", hum.Health) end
    if text == "" then
        removeStatusESP(char)
        return
    end

    local billboard = StatusESP[char]
    local teamColor = Color3.new(1, 1, 1)
    if player.Team then
        if player.Team.Name == "Killer" then
            teamColor = TeamColors.Killer
        elseif player.Team.Name == "Survivors" then
            teamColor = TeamColors.Survivor
        end
    end
    if isDown then teamColor = Color3.fromRGB(255, 0, 0) end

    local mode = S.ESPNameMode or "Text"
    local size = S.ESPNameSize or 12

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
        label.TextSize = size
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
            label.TextSize = size
        end
    end

    local label = billboard:FindFirstChildOfClass("TextLabel")
    if label then
        if mode == "Galaxy" then
            local grad = label:FindFirstChildOfClass("UIGradient")
            if not grad then
                grad = Instance.new("UIGradient")
                grad.Parent = label
            end
            local t = tick()
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHSV((t * 0.3) % 1, 0.8, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.fromHSV((t * 0.3 + 0.33) % 1, 0.8, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV((t * 0.3 + 0.66) % 1, 0.8, 1)),
            })
            grad.Rotation = (t * 60) % 360
        else
            local grad = label:FindFirstChildOfClass("UIGradient")
            if grad then grad:Destroy() end
        end
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
    local percent = GetGameValue(generator, "RepairProgress")
        or GetGameValue(generator, "Progress") or 0
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
        if lbl then
            lbl.Text = text
            lbl.TextColor3 = color
        end
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
    if obj:IsA("Model") then
        pos = obj:GetPivot().Position
    elseif obj:IsA("BasePart") then
        pos = obj.Position
    end
    if not pos then return end
    local distance = (pos - root.Position).Magnitude

    if obj.Name == "Window" then
        if ESP.Window and distance <= ESP.Distance then
            createESP(obj, WindowColor)
        else
            removeESP(obj)
        end
    end

    if obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        if ESP.Pallet and distance <= ESP.Distance then
            createESP(obj, PalletColor)
        else
            removeESP(obj)
        end
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
            if obj:IsA("Model") then
                pos = obj:GetPivot().Position
            elseif obj:IsA("BasePart") then
                pos = obj.Position
            end
            if pos then
                local dist = (pos - root.Position).Magnitude
                if dist <= ESP.Distance then
                    createESP(obj, SCPColor)
                else
                    removeESP(obj)
                end
            end
        end
    end
end

-- =========================================================
-- AUTO PARRY (SAMA KAYAK SEBELUMNYA)
-- =========================================================
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

function shouldBlockParry()
    local char = LP.Character
    if not char then return true end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return true end

    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            local anim = track.Animation
            if anim and anim.AnimationId then
                if anim.AnimationId == "rbxassetid://127096285501517" then return true end
                if anim.AnimationId == "rbxassetid://112166042383605" then return true end
                if anim.AnimationId == "http://www.roblox.com/asset/?id=126965695851149" then return true end
                if anim.AnimationId == "http://www.roblox.com/asset/?id=135084204086504" then return true end
                if anim.AnimationId == "rbxassetid://123047897844134" then return true end
            end
        end
    end

    if hum.Health <= 0 or hum.Health < 2 then return true end
    if char:GetAttribute("Downed") == true then return true end
    if char:GetAttribute("IsDown") == true then return true end
    if char:GetAttribute("Knocked") == true then return true end

    return false
end

function doParry()
    if shouldBlockParry() then return end

    local now = tick()
    if now - lastParry < PARRY_DEBOUNCE then return end
    lastParry = now

    ParryActive = true
    pressParryButton()

    task.delay(0.3, function()
        ParryActive = false
    end)
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

-- =========================================================
-- AUTO SKILL CHECK (2 MODE)
-- =========================================================
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

        local gr = goal.Rotation % 360

        -- MODE INSTANT
        if SkillCheck.Mode == "Instant" then
            local targetRot = (gr + 109) % 360
            pcall(function() line.Rotation = targetRot end)

            if SkillCheck.HideNeedle then
                pcall(function() line.Visible = false end)
            end

            busy = true
            task.spawn(function()
                if UIS.TouchEnabled then TriggerMobileButton() else pressSpace() end
                SkillCheck.Success += 1
                SkillCheck.Total += 1
                task.wait(0.05)
                busy = false
                if SkillCheck.HideNeedle then
                    pcall(function() line.Visible = true end)
                end
            end)
            return
        end

        -- MODE PERFECT
        local lr = line.Rotation % 360
        local startRange = (gr + 102) % 360
        local endRange = (gr + 116) % 360

        local success =
            (startRange > endRange and (lr >= startRange or lr <= endRange))
            or (lr >= startRange and lr <= endRange)

        if success then
            busy = true
            task.spawn(function()
                if UIS.TouchEnabled then TriggerMobileButton() else pressSpace() end
                SkillCheck.Success += 1
                SkillCheck.Total += 1
                task.wait(0.05)
                busy = false
            end)
        end
    end)
end

task.spawn(function()
    task.wait(1)
    if SkillCheck.Enabled then
        startSkillCheck()
    end
end)

-- =========================================================
-- MOONWALK LOGIC (100% PERSIS FALLENS)
-- =========================================================
function isDowned()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    return hum.Health <= 0
        or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true
end

function startMoonwalk()
    if MoonwalkConnection then return end

    MoonwalkConnection = RunService.RenderStepped:Connect(function()
        if not Moonwalk.Enabled then return end
        if ParryActive then return end
        if isDowned() then return end

        local char = LP.Character
        if not char or not char.Parent then return end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera

        if not humanoid or not hrp or not cam then return end

        if Moonwalk.UseSlow and humanoid.WalkSpeed ~= Moonwalk.SlowSpeed then
            humanoid.WalkSpeed = Moonwalk.SlowSpeed
        end

        local look = cam.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)

        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit
            local baseCF = CFrame.new(hrp.Position, hrp.Position + flatLook)
            local angle = math.sin(tick() * Moonwalk.SpamSpeed) * Moonwalk.Intensity
            hrp.CFrame = baseCF * CFrame.Angles(0, math.rad(angle), 0)
            humanoid:Move(Vector3.new(0, 0, 1), true)
        end
    end)
end

function stopMoonwalk()
    if MoonwalkConnection then
        MoonwalkConnection:Disconnect()
        MoonwalkConnection = nil
    end
end

-- =========================================================
-- FAST VAULT (100% PERSIS FALLENS)
-- =========================================================
function normalizeVaultId(id)
    local num = tostring(id):match("%d+")
    return num and ("rbxassetid://" .. num)
end

function hookVault(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    animator.AnimationPlayed:Connect(function(track)
        if not FastVault.Enabled then return end

        local anim = track.Animation
        if not anim or not anim.AnimationId then return end

        local id = normalizeVaultId(anim.AnimationId)
        if not id then return end

        local replaceId = FastVault.ReplaceMap[id]
        if not replaceId then return end

        if VaultTracks[track] then return end
        VaultTracks[track] = true

        track:Stop()

        local newAnim = Instance.new("Animation")
        newAnim.AnimationId = replaceId

        local newTrack = animator:LoadAnimation(newAnim)

        newTrack.Priority = Enum.AnimationPriority.Action

        newTrack:Play()
        newTrack:AdjustSpeed(FastVault.Speed)

        newTrack.Stopped:Connect(function()
            VaultTracks[track] = nil
        end)
    end)
end

-- APPLY KE CHARACTER (PERSIS FALLENS)
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    hookVault(char)
end)

if LP.Character then
    hookVault(LP.Character)
end

-- =========================================================
-- PARRY CIRCLE (BEAM RING)
-- =========================================================
parryCirclePart = nil
parryCircleAttachments = {}
parryCircleBeams = {}

function clearParryCircle()
    if parryCirclePart then
        parryCirclePart:Destroy()
        parryCirclePart = nil
    end
    parryCircleAttachments = {}
    parryCircleBeams = {}
end

function createParryCircle()
    clearParryCircle()
    parryCirclePart = Instance.new("Part")
    parryCirclePart.Name = "CosmicParryRing"
    parryCirclePart.Anchored = true
    parryCirclePart.CanCollide = false
    parryCirclePart.Transparency = 1
    parryCirclePart.Size = Vector3.new(1, 0.1, 1)
    parryCirclePart.Parent = workspace

    local segments = 36
    for i = 1, segments do
        local angle = (i / segments) * math.pi * 2
        local att = Instance.new("Attachment")
        att.Position = Vector3.new(math.cos(angle), 0, math.sin(angle))
        att.Parent = parryCirclePart
        table.insert(parryCircleAttachments, att)
    end

    for i = 1, segments do
        local attA = parryCircleAttachments[i]
        local attB = parryCircleAttachments[i % segments + 1]

        local beam = Instance.new("Beam")
        beam.Attachment0 = attA
        beam.Attachment1 = attB
        beam.Width0 = 0.4
        beam.Width1 = 0.4
        beam.FaceCamera = true
        beam.LightEmission = 1
        beam.LightInfluence = 0
        beam.Segments = 1
        beam.Transparency = NumberSequence.new(0.3)
        beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 100))
        beam.Parent = parryCirclePart
        table.insert(parryCircleBeams, beam)
    end
end

function updateParryCircle()
    local root = getRoot()
    if not S.ParryCircle or not root then
        clearParryCircle()
        return
    end

    if not parryCirclePart or not parryCirclePart.Parent then
        createParryCircle()
    end

    local radius = S.ParryCircleSize or 12
    local myPos = root.Position
    local yOffset = root.Size.Y / 2 + 1.5

    local killerInside = false
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
            local eRoot = p.Character:FindFirstChild("HumanoidRootPart")
            if eRoot then
                local dist = (eRoot.Position - myPos).Magnitude
                if dist <= radius then
                    killerInside = true
                    break
                end
            end
        end
    end

    local ringColor = killerInside and Color3.fromRGB(255, 40, 40) or Color3.fromRGB(0, 255, 100)
    local ringTrans = killerInside and 0.2 or 0.4

    parryCirclePart.Position = Vector3.new(myPos.X, myPos.Y - yOffset, myPos.Z)

    for i, att in ipairs(parryCircleAttachments) do
        local angle = (i / 36) * math.pi * 2
        att.Position = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
    end

    for _, beam in ipairs(parryCircleBeams) do
        beam.Color = ColorSequence.new(ringColor)
        beam.Transparency = NumberSequence.new(ringTrans)
    end
end

RunService.RenderStepped:Connect(function()
    if S.ParryCircle then updateParryCircle() end
end)

-- =========================================================
-- TELEPORT FINISH LINE
-- =========================================================
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
    if found then
        root.CFrame = found.CFrame + Vector3.new(0, 5, 0)
    else
        warn("[COSMIC HUB] Finish line gak ketemu")
    end
end

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
-- VISUAL (Fullbright, Sky, FOV, dll) - SAMA KAYAK SEBELUMNYA
-- =========================================================
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
                    v.Density = 0
                    v.Haze = 0
                    v.Glare = 0
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
            end)
        end
    end
end)

origSky = nil
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("Sky") then
        origSky = v:Clone()
        break
    end
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
    if cam then
        cam.FieldOfView = S.FOVEnabled and S.FOV or 70
    end
end

function applyUltraHD()
    if S.UltraHD then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
        end)
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
        if _G.RoooorHD then
            _G.RoooorHD:Destroy()
            _G.RoooorHD = nil
        end
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
        if _G.ContrastFx then
            _G.ContrastFx:Destroy()
            _G.ContrastFx = nil
        end
    end
end

hdBoostOrig = nil
hdShaderObj = nil
hdSkyOrig = nil

function applyHDBoost(s)
    if s then
        if not hdBoostOrig then
            hdBoostOrig = {
                QualityLevel = settings().Rendering.QualityLevel,
                GlobalShadows = Lighting.GlobalShadows,
            }
        end
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
        end)
        Lighting.GlobalShadows = true
    else
        if hdBoostOrig then
            pcall(function()
                settings().Rendering.QualityLevel = hdBoostOrig.QualityLevel
            end)
            Lighting.GlobalShadows = hdBoostOrig.GlobalShadows
        end
    end
end

function applyHDShader(s)
    if s then
        if not hdShaderObj then
            hdShaderObj = Instance.new("ColorCorrectionEffect")
            hdShaderObj.Name = "CosmicHDShader"
            hdShaderObj.Parent = Lighting
        end
        hdShaderObj.Contrast = 0.15
        hdShaderObj.Saturation = 0.12
        hdShaderObj.Brightness = 0.02

        if not _G.CosmicHDBloom then
            _G.CosmicHDBloom = Instance.new("BloomEffect")
            _G.CosmicHDBloom.Name = "CosmicHDBloom"
            _G.CosmicHDBloom.Intensity = 0.4
            _G.CosmicHDBloom.Size = 20
            _G.CosmicHDBloom.Threshold = 1.2
            _G.CosmicHDBloom.Parent = Lighting
        end
    else
        if hdShaderObj then hdShaderObj:Destroy(); hdShaderObj = nil end
        if _G.CosmicHDBloom then _G.CosmicHDBloom:Destroy(); _G.CosmicHDBloom = nil end
    end
end

function applyHDSky(s)
    if s then
        if not hdSkyOrig then
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("Sky") then
                    hdSkyOrig = v:Clone()
                    break
                end
            end
        end
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("Sky") then v:Destroy() end
        end

        if not _G.CosmicHDAtmosphere then
            _G.CosmicHDAtmosphere = Instance.new("Atmosphere")
            _G.CosmicHDAtmosphere.Name = "CosmicHDAtmosphere"
            _G.CosmicHDAtmosphere.Density = 0.3
            _G.CosmicHDAtmosphere.Offset = 0.25
            _G.CosmicHDAtmosphere.Color = Color3.fromRGB(199, 199, 199)
            _G.CosmicHDAtmosphere.Decay = Color3.fromRGB(106, 112, 125)
            _G.CosmicHDAtmosphere.Glare = 0.2
            _G.CosmicHDAtmosphere.Haze = 1.5
            _G.CosmicHDAtmosphere.Parent = Lighting
        end
    else
        if _G.CosmicHDAtmosphere then
            _G.CosmicHDAtmosphere:Destroy()
            _G.CosmicHDAtmosphere = nil
        end
    end
end

trailFireObj = nil
function applyTrail(enable, color)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if trailFireObj then
        trailFireObj:Destroy()
        trailFireObj = nil
    end
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

    if auraObj then
        auraObj:Destroy()
        auraObj = nil
    end
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

    TweenService:Create(p, TweenInfo.new(0.5), {
        Size = Vector3.new(15, 15, 15),
        Transparency = 1
    }):Play()

    task.delay(0.6, function() p:Destroy() end)
end

-- =========================================================
-- CROSSHAIR 8 MODE + 2 WARNA (SAMA KAYAK SEBELUMNYA)
-- =========================================================
crosshairGui = nil
crosshairParts = {}
crosshairGalaxyConn = nil

function clearCrosshair()
    if crosshairGui then
        crosshairGui:Destroy()
        crosshairGui = nil
    end
    if crosshairGalaxyConn then
        crosshairGalaxyConn:Disconnect()
        crosshairGalaxyConn = nil
    end
    crosshairParts = {}
end

function applyCrosshair(enable, color, size)
    clearCrosshair()
    if not enable then return end

    local style = S.CrosshairStyle or "Plus"
    local colorMode = S.CrosshairColorMode or "Solid"
    local thickness = S.CrosshairThickness or 2
    local offX = S.CrosshairOffsetX or 0
    local offY = S.CrosshairOffsetY or 0
    size = size or S.CrosshairSize or 8

    crosshairGui = Instance.new("ScreenGui")
    crosshairGui.Name = "CosmicCrosshair"
    crosshairGui.ResetOnSpawn = false
    crosshairGui.IgnoreGuiInset = true
    crosshairGui.Parent = PG

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 0, 0, 0)
    container.Position = UDim2.new(0.5, offX, 0.5, offY)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundTransparency = 1
    container.Parent = crosshairGui

    local baseColor = color or S.CrosshairColor or C.ACC2

    local function mkBar(w, h, x, y, rot)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, w, 0, h)
        f.Position = UDim2.new(0, x, 0, y)
        f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.BackgroundColor3 = baseColor
        f.BorderSizePixel = 0
        f.Rotation = rot or 0
        f.Parent = container
        table.insert(crosshairParts, f)
        return f
    end

    local function mkDot(r)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, r, 0, r)
        f.Position = UDim2.new(0, 0, 0, 0)
        f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.BackgroundColor3 = baseColor
        f.BorderSizePixel = 0
        f.Parent = container
        rnd(f, 999)
        table.insert(crosshairParts, f)
        return f
    end

    local function mkOutline(w, h, r)
        local c = Instance.new("Frame")
        c.Size = UDim2.new(0, w, 0, h)
        c.AnchorPoint = Vector2.new(0.5, 0.5)
        c.Position = UDim2.new(0, 0, 0, 0)
        c.BackgroundTransparency = 1
        c.Rotation = r or 0
        c.Parent = container
        local s = Instance.new("UIStroke")
        s.Thickness = thickness
        s.Color = baseColor
        s.Parent = c
        rnd(c, 999)
        table.insert(crosshairParts, c)
        return c
    end

    if style == "Plus" then
        mkBar(size, thickness, -size/2 - 2, 0)
        mkBar(size, thickness,  size/2 + 2, 0)
        mkBar(thickness, size, 0, -size/2 - 2)
        mkBar(thickness, size, 0,  size/2 + 2)
    elseif style == "Dot" then
        mkDot(size)
    elseif style == "Circle" then
        mkOutline(size*2, size*2)
    elseif style == "X" then
        mkBar(size, thickness, 0, 0, 45)
        mkBar(size, thickness, 0, 0, -45)
    elseif style == "Square" then
        mkOutline(size*2, size*2)
    elseif style == "Diamond" then
        mkOutline(size*2, size*2, 45)
    elseif style == "TShape" then
        mkBar(size*1.5, thickness, 0, -size/2 - 2)
        mkBar(thickness, size, 0, size/2)
    elseif style == "CrossDot" then
        mkBar(size, thickness, -size/2 - 2, 0)
        mkBar(size, thickness,  size/2 + 2, 0)
        mkBar(thickness, size, 0, -size/2 - 2)
        mkBar(thickness, size, 0,  size/2 + 2)
        mkDot(thickness + 2)
    end

    if colorMode == "Galaxy" then
        for _, part in ipairs(crosshairParts) do
            local grad = Instance.new("UIGradient")
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 60, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 230, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 200)),
            })
            grad.Parent = part
        end

        crosshairGalaxyConn = RunService.RenderStepped:Connect(function()
            if not crosshairGui then return end
            local t = tick() * 60
            for _, part in ipairs(crosshairParts) do
                local grad = part:FindFirstChildOfClass("UIGradient")
                if grad then
                    grad.Rotation = (t + (part.AbsolutePosition.X % 100)) % 360
                end
            end
        end)
    end
end

-- =========================================================
-- FLY
-- =========================================================
flyBV, flyBG, flyConn = nil, nil, nil
function startFly()
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

        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        flyBV.Velocity = moveDir * S.FlySpeed
        flyBG.CFrame = cam.CFrame
    end)
end

function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
end

-- EXPORT
_G.Roooor_applyFire = applyFire
_G.Roooor_applyFireFeet = applyFireFeet
_G.Roooor_apply8Bit = apply8Bit
_G.Roooor_applyKorblox = applyKorblox
_G.Roooor_applyFireBeam = applyFireBeam
_G.Roooor_applyHDTexture = applyHDTexture
_G.Roooor_applyHDReflection = applyHDReflection
_G.Roooor_applyHDBloom = applyHDBloom
_G.Roooor_applyHDShadow = applyHDShadow
_G.Roooor_applyHDWater = applyHDWater
_G.Roooor_applyHDSunRays = applyHDSunRays
_G.Roooor_applyHDDepthField = applyHDDepthField
_G.Roooor_applyHDAntiAliasing = applyHDAntiAliasing
_G.Roooor_createESP = createESP
_G.Roooor_removeESP = removeESP
_G.Roooor_createStatusESP = createStatusESP
_G.Roooor_UpdateGenerator = UpdateGenerator
_G.Roooor_UpdateMapESP = UpdateMapESP
_G.Roooor_UpdateSCPEsp = UpdateSCPEsp
_G.Roooor_scanKillers = scanKillers
_G.Roooor_startSkillCheck = startSkillCheck
_G.Roooor_startMoonwalk = startMoonwalk
_G.Roooor_stopMoonwalk = stopMoonwalk
_G.Roooor_applyFullbright = applyFullbright
_G.Roooor_applyNoFog = applyNoFog
_G.Roooor_applySky = applySky
_G.Roooor_applyFOV = applyFOV
_G.Roooor_applyUltraHD = applyUltraHD
_G.Roooor_applyContrast = applyContrast
_G.Roooor_applyHeadless = applyHeadless
_G.Roooor_applyTrail = applyTrail
_G.Roooor_applyAura = applyAura
_G.Roooor_applyCrosshair = applyCrosshair
_G.Roooor_clearCrosshair = clearCrosshair
_G.Roooor_applyZoomOut = applyZoomOut
_G.Roooor_teleportToFinishLine = teleportToFinishLine
_G.Roooor_spawnKillEffect = spawnKillEffect
_G.Roooor_startFly = startFly
_G.Roooor_stopFly = stopFly
_G.Roooor_applyHDBoost = applyHDBoost
_G.Roooor_applyHDShader = applyHDShader
_G.Roooor_applyHDSky = applyHDSky
_G.Roooor_applyAntiAFK = applyAntiAFK
_G.Roooor_serverHop = serverHop
_G.Roooor_rejoinServer = rejoinServer
_G.Roooor_updateFPSPing = updateFPSPing
_G.Roooor_hookVault = hookVault
_G.Roooor_isDowned = isDowned

print("✅ [4/11] COSMIC HUB - ESP + Parry + SkillCheck + Moonwalk + FastVault + Crosshair loaded")
print("   Moonwalk  : 100% FALLENS")
print("   FastVault : 100% FALLENS")-- =========================================================
-- SECTION 5/11 : FITUR AKTIF + LOOP UTAMA
-- =========================================================

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
                        if parent:IsA("BasePart") then
                            pos = parent.Position
                        elseif parent:IsA("Model") then
                            pos = parent:GetPivot().Position
                        end
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

-- SPEED HACK
task.spawn(function()
    while task.wait(0.2) do
        if S.SpeedHack and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= S.SpeedHackVal then
                hum.WalkSpeed = S.SpeedHackVal
            end
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
                if hum.WalkSpeed ~= target then
                    hum.WalkSpeed = target
                end
            end
        end
    end
end)

-- ANTI-AFK LOOP
task.spawn(function()
    while task.wait(60) do
        if S.AntiAFK then
            pcall(function()
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
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
                    local warn = PG:FindFirstChild("CosmicWarn")
                    if not warn then
                        warn = Instance.new("Frame")
                        warn.Name = "CosmicWarn"
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
                            local al = PG:FindFirstChild("CosmicAlert")
                            if not al then
                                al = Instance.new("TextLabel")
                                al.Name = "CosmicAlert"
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

-- KILL FEED
killFeedGui = Instance.new("ScreenGui")
killFeedGui.Name = "CosmicKillFeed"
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
    billboard.Name = "CosmicStunIcon"
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
                                        if id == "123047897844134" then
                                            isStunned = true
                                            break
                                        end
                                    end
                                end
                            end
                        end
                        if isStunned then
                            createStunIcon(p.Character)
                        else
                            removeStunIcon(p.Character)
                        end
                    else
                        removeStunIcon(p.Character)
                    end
                end
            end
        end
    end
end)

-- KILLER AUTO ATTACK
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

            local isCarried = LP.Character:GetAttribute("IsCarried")
                or LP.Character:GetAttribute("IsCarrying")
                or LP.Character:GetAttribute("Hooked")
                or LP.Character:GetAttribute("Hook")
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
                        local survivorHooked = p.Character:GetAttribute("Hooked")
                            or p.Character:GetAttribute("IsCarried")
                            or p.Character:GetAttribute("IsHooked")
                        if survivorHooked then continue end
                        if hrp.Position.Y > 30 then continue end
                        local dist = (hrp.Position - myPos).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closest = hrp
                        end
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

-- AUTO WIGGLE
task.spawn(function()
    while task.wait(0.5) do
        if not AutoParry.Wiggle then continue end
        local char = LP.Character
        if not char then continue end

        local carried = (char:FindFirstChild("IsCarried") and char.IsCarried.Value)
            or (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)

        if not carried then continue end

        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes then continue end
        local carry = remotes:FindFirstChild("Carry")
        if not carry then continue end
        local event = carry:FindFirstChild("SelfUnHookEvent")
        if not event then continue end

        for i = 1, (AutoParry.WiggleSpam or 5) do
            pcall(function() event:FireServer() end)
        end
    end
end)

-- AUTO FLEE KILLER
function GetNearestKillerForFlee()
    local root = getRoot()
    if not root then return nil, math.huge end

    local closest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Team and plr.Team.Name == "Killer" and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = hrp
                end
            end
        end
    end
    return closest, shortest
end

function GetFarthestGeneratorPoint(killerRoot)
    if not killerRoot then return nil end
    local bestPoint, farthestDistance = nil, 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.match(obj.Name, "^GeneratorPoint%d+$") then
            local dist = (obj.Position - killerRoot.Position).Magnitude
            if dist > farthestDistance then
                farthestDistance = dist
                bestPoint = obj
            end
        end
    end
    return bestPoint
end

task.spawn(function()
    while task.wait(0.2) do
        if not AutoFlee.Enabled then continue end
        local root = getRoot()
        if not root then continue end

        local killerRoot, distance = GetNearestKillerForFlee()
        if killerRoot and distance <= AutoFlee.DetectDistance
           and tick() - AutoFlee.LastFlee > AutoFlee.Cooldown then
            local point = GetFarthestGeneratorPoint(killerRoot)
            if point then
                AutoFlee.LastFlee = tick()
                pcall(function()
                    root.CFrame = point.CFrame + Vector3.new(0, 5, 0)
                end)
            end
        end
    end
end)

-- FPS BOOST
local ScreenEffectTypes = {
    "ColorCorrectionEffect", "DepthOfFieldEffect", "BlurEffect",
    "SunRaysEffect", "BloomEffect"
}
DisabledEffects = {}

function applyNoScreenEffects()
    if S.NoScreenEffects then
        for _, v in pairs(Lighting:GetChildren()) do
            for _, t in pairs(ScreenEffectTypes) do
                if v:IsA(t) then
                    DisabledEffects[v] = v.Enabled
                    v.Enabled = false
                end
            end
        end
    else
        for obj, state in pairs(DisabledEffects) do
            if obj and obj.Parent then obj.Enabled = state end
        end
        DisabledEffects = {}
    end
end

Lighting.ChildAdded:Connect(function(v)
    if not S.NoScreenEffects then return end
    task.wait()
    for _, t in pairs(ScreenEffectTypes) do
        if v:IsA(t) then
            DisabledEffects[v] = v.Enabled
            v.Enabled = false
        end
    end
end)

function applyLowGraphics()
    pcall(function()
        if S.LowGraphics then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        else
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end
    end)
end

function applyCleanSky()
    if S.CleanSky then
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Sky") then v:Destroy() end
        end
    end
end

-- AUTO CARRY + AUTO HOOK
KillerBusy = false

function GetDownedSurvivor()
    local root = getRoot()
    if not root then return nil end
    local best, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 and hum.Health <= hum.MaxHealth * 0.25 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < dist and d <= S.CarryRange then
                    dist = d
                    best = p.Character
                end
            end
        end
    end
    return best
end

function GetHookPoint()
    local root = getRoot()
    if not root then return nil end
    local bestHook, shortestDistance = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "HookPoint" and obj:IsA("BasePart") then
            local dist = (obj.Position - root.Position).Magnitude
            if dist < shortestDistance and dist < 400 then
                shortestDistance = dist
                bestHook = obj
            end
        end
    end
    return bestHook
end

task.spawn(function()
    while task.wait(0.2) do
        if not S.AutoCarry or KillerBusy then continue end

        local CarryEvent = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Carry", true)
            and ReplicatedStorage.Remotes.Carry:FindFirstChild("CarrySurvivorEvent")
        local HookEvent = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Carry", true)
            and ReplicatedStorage.Remotes.Carry:FindFirstChild("HookEvent")

        if not CarryEvent or not HookEvent then continue end

        local target = GetDownedSurvivor()
        local root = getRoot()

        if target and root then
            KillerBusy = true
            local tRoot = target:FindFirstChild("HumanoidRootPart")
            if tRoot then
                root.CFrame = tRoot.CFrame * CFrame.new(0, 3, -2)
                task.wait(0.4)
                for i = 1, 4 do
                    pcall(function() CarryEvent:FireServer(target) end)
                    task.wait(0.2)
                end
                task.wait(0.6)

                if S.AutoHook then
                    local hook = GetHookPoint()
                    if hook then
                        root.CFrame = hook.CFrame * CFrame.new(0, 4, -3)
                        task.wait(0.7)
                        for i = 1, 6 do
                            pcall(function() HookEvent:FireServer(hook) end)
                            task.wait(0.15)
                        end
                    end
                end
            end
            task.delay(2, function() KillerBusy = false end)
        end
    end
end)

-- AUTO ESCAPE GATE
task.spawn(function()
    while task.wait(1) do
        if not S.AutoEscapeGate then continue end
        local root = getRoot()
        if not root then continue end

        local killerNear = false
        if S.AutoEscapeUseKillerCheck then
            local kRoot, kDist = GetNearestKillerForFlee()
            if kRoot and kDist <= (S.AutoEscapeRange or 50) then
                killerNear = true
            end
        end

        local genDone = false
        if S.AutoEscapeUseGenCheck then
            local total, done = 0, 0
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "Generator" then
                    total = total + 1
                    local p = obj:GetAttribute("RepairProgress")
                        or obj:GetAttribute("Progress") or 0
                    if p >= 100 then done = done + 1 end
                end
            end
            if total > 0 and done >= total then genDone = true end
        end

        if killerNear or genDone then
            local found = nil
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local n = string.lower(obj.Name)
                    if n == "fininshline" or n == "finishline" 
                       or n == "escape" or n == "escapegate"
                       or string.find(n, "escape") then
                        found = obj
                        break
                    end
                end
            end

            if found then
                pcall(function()
                    root.CFrame = found.CFrame + Vector3.new(0, 5, 0)
                end)
            end
        end
    end
end)

-- MAIN ESP LOOP
local lastESPUpdate = 0
RunService.Heartbeat:Connect(function()
    local root = getRoot()
    if not root then return end

    local now = tick()
    if now - lastESPUpdate >= 0.1 then
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
                            else
                                removeESP(char)
                            end
                        else
                            removeESP(char)
                        end
                    end
                    createStatusESP(p, char, root)
                else
                    removeESP(char)
                end
            end
        end

        if ESP.Generator then
            for gen in pairs(Cached.Generators) do
                UpdateGenerator(gen)
            end
        end

        for obj in pairs(Cached.Windows) do UpdateMapESP(obj, root) end
        for obj in pairs(Cached.Pallets) do UpdateMapESP(obj, root) end

        UpdateSCPEsp(root)

        if S.NoScreenEffects then applyNoScreenEffects() end
        if S.LowGraphics then applyLowGraphics() end
        if S.CleanSky then applyCleanSky() end
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

-- NO CLIP CAMERA
task.spawn(function()
    while task.wait(0.2) do
        local cam = workspace.CurrentCamera
        if cam then
            cam.CanCollide = not S.NoClipCamera
        end
    end
end)

print("✅ [5/11] COSMIC HUB - Fitur aktif + Loop utama loaded")-- =========================================================
-- SECTION 6/11 : GUI COSMIC HUB + TOMBOL + PANEL
-- =========================================================
gui = Instance.new("ScreenGui")
gui.Name = "CosmicHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PG

-- =========================================================
-- TOMBOL MENU COSMIC
-- =========================================================
btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(0, 32, 0, 32)
btnContainer.Position = UDim2.new(0, 15, 0.3, 0)
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

for i = 1, 6 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, 2, 0, 2)
    particle.BorderSizePixel = 0
    particle.ZIndex = 4
    particle.Parent = btnContainer
    rnd(particle, 999)

    local angle = (i / 6) * math.pi * 2
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
            task.wait(0.04)
        end
    end)
end

dragging = false
dragStart = nil
startPos = nil
wasDragged = false

btnContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        wasDragged = false
        dragStart = input.Position
        startPos = btnContainer.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
            wasDragged = true
        end
        btnContainer.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- =========================================================
-- PANEL MENU COSMIC
-- =========================================================
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
panelGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.BG),
    ColorSequenceKeypoint.new(0.5, C.BG2),
    ColorSequenceKeypoint.new(1, C.BG),
})
panelGrad.Rotation = 45
panelGrad.Parent = panel

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
        for i = 0, 1, 0.04 do
            if not neonLine.Parent then break end
            neonGrad.Rotation = i * 360
            task.wait(0.08)
        end
    end
end)

local hTitle = Instance.new("TextLabel")
hTitle.Size = UDim2.new(1, -80, 1, 0)
hTitle.Position = UDim2.new(0, 16, 0, 0)
hTitle.BackgroundTransparency = 1
hTitle.Text = "✨ COSMIC HUB"
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

-- =========================================================
-- KOMPONEN UI
-- =========================================================
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
        _G.RoooorSavedStates = _G.RoooorSavedStates or {}
        _G.RoooorSavedStates[name] = state
        TweenService:Create(k, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = state and UDim2.new(1, -14, 0.5, -5.5) or UDim2.new(0, 3, 0.5, -5.5),
            BackgroundColor3 = state and Color3.new(1, 1, 1) or C.DIM
        }):Play()
        TweenService:Create(t, TweenInfo.new(0.2), {
            BackgroundColor3 = state and C.ACC or C.PANEL
        }):Play()
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

    _G.RoooorSavedStates = _G.RoooorSavedStates or {}
    local curVal = _G.SliderStates[name] or def
    if _G.RoooorSavedStates[name] ~= nil then
        curVal = _G.RoooorSavedStates[name]
    end
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
        local pos = math.clamp(
            (input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X,
            0, 1
        )
        local val = math.floor((min + (max - min) * pos) * 100 + 0.5) / 100
        _G.SliderStates[name] = val
        _G.RoooorSavedStates = _G.RoooorSavedStates or {}
        _G.RoooorSavedStates[name] = val
        fill.Size = UDim2.new(pos, 0, 1, 0)
        kn.Position = UDim2.new(pos, -5.5, 0.5, -5.5)
        v.Text = tostring(val)
        if cb then pcall(cb, val) end
    end

    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            drag = true
            upd(input)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            upd(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
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
                TweenService:Create(oldInd, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 3, 0, 0)
                }):Play()
            end
            for _, c in pairs(activeTab:GetChildren()) do
                if c:IsA("TextLabel") then
                    TweenService:Create(c, TweenInfo.new(0.2), {TextColor3 = C.DIM}):Play()
                end
            end
        end

        activeTab = b
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
        TweenService:Create(ind, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 3, 0, 18)
        }):Play()

        for _, c in pairs(b:GetChildren()) do
            if c:IsA("TextLabel") then
                TweenService:Create(c, TweenInfo.new(0.2), {TextColor3 = C.TXT}):Play()
            end
        end

        for _, c in pairs(cs:GetChildren()) do
            if not c:IsA("UIListLayout") then
                c:Destroy()
            end
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
    if wasDragged then
        wasDragged = false
        return
    end
    panel.Visible = not panel.Visible
    playToggleSound()
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    playToggleSound()
end)

print("✅ [6/11] COSMIC HUB - GUI + Tombol + Panel loaded")-- =========================================================
-- SECTION 7/11 : TAB UI PART 1
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

-- ============================================================
-- TAB 1: SURVIVOR
-- ============================================================
makeTab("Survivor", "🏃", 1, function()

    sec("Auto Parry", "🛡️")
    tog("Enable Auto Parry", true, function(s)
        AutoParry.Enabled = s
        if s then scanKillers() end
    end)
    lbl("Parry otomatis saat killer nyerang", C.FIRE_BRIGHT)

    sl("Parry Distance", 5, 20, 15, function(v)
        AutoParry.ParryDistance = v
    end)

    sl("Face Sensitivity", -1, 1, 0.7, function(v)
        AutoParry.FaceSensitivity = v
        AutoParry.RequireFacing = (v > -1)
    end)
    lbl("0.7 = Facing (recommended)", C.GRN)

    sl("Parry Debounce", 0.1, 0.5, 0.2, function(v)
        PARRY_DEBOUNCE = v
    end)
    lbl("0.2 = Responsif", C.FIRE_BRIGHT)

    sec("Parry Circle (Hijau/Merah)", "⭕")
    tog("Show Parry Circle", true, function(s) S.ParryCircle = s end)
    sl("Circle Size", 5, 30, 12, function(v) S.ParryCircleSize = v end)
    lbl("Hijau = aman | Merah = killer dalem", C.FIRE_BRIGHT)

    sec("Auto Skill Check (2 MODE)", "⚡")
    tog("Enable Auto Skill Check", true, function(s)
        SkillCheck.Enabled = s
        if s then startSkillCheck() end
    end)

    drp("Mode", {"Perfect", "Instant"}, "Perfect", function(v)
        SkillCheck.Mode = v
    end)
    lbl("Perfect = tunggu zona | Instant = paksa jarum", C.FIRE_BRIGHT)

    tog("Hide Needle (Instant only)", false, function(s)
        SkillCheck.HideNeedle = s
    end)

    btn("🔄 Reset Counter", function()
        SkillCheck.Success = 0
        SkillCheck.Total = 0
    end)

    sec("Auto Wiggle (Anti Gendong)", "🔓")
    tog("Enable Auto Wiggle", false, function(s)
        AutoParry.Wiggle = s
    end)
    lbl("Spam lepas kalau digendong killer", C.GRN)
    sl("Wiggle Spam", 1, 20, 5, function(v)
        AutoParry.WiggleSpam = v
    end)

    sec("Auto Flee Killer", "🏃‍♂️")
    tog("Enable Auto Flee", false, function(s)
        AutoFlee.Enabled = s
    end)
    lbl("TP ke generator terjauh kalau killer deket", C.FIRE_BRIGHT)
    sl("Detect Distance", 10, 150, 50, function(v)
        AutoFlee.DetectDistance = v
    end)
    sl("Cooldown", 0.1, 5, 0.5, function(v)
        AutoFlee.Cooldown = v
    end)

    sec("Fast Vault (FALLENS)", "⚡")
    tog("Enable Fast Vault", false, function(s)
        FastVault.Enabled = s
        if s and LP.Character then
            hookVault(LP.Character)
        end
    end)
    lbl("Ganti animasi vault jadi lebih cepat", C.GRN)
    sl("Animation Speed", 1, 5, 1.2, function(v)
        FastVault.Speed = v
    end)

    sec("Auto Escape Gate", "🚪")
    tog("Enable Auto Escape", false, function(s)
        S.AutoEscapeGate = s
    end)
    lbl("TP ke finish kalau cukup gen / killer deket", C.FIRE_BRIGHT)

    tog("Trigger: Killer Deket", true, function(s)
        S.AutoEscapeUseKillerCheck = s
    end)
    tog("Trigger: Generator Cukup", true, function(s)
        S.AutoEscapeUseGenCheck = s
    end)
    sl("Killer Range", 10, 150, 50, function(v)
        S.AutoEscapeRange = v
    end)

    sec("God Mode", "🛡️")
    tog("God Mode (Full)", false, function(s)
        GodMode.Enabled = s
    end)
    lbl("Anti Down + Anti Stun + Anti Grab", C.DIM)

    sec("Support", "💊")
    tog("Instant Interact", false, function(s) S.InstantInteract = s end)

    sec("Teleport", "🌀")
    btn("TP ke Finish Line", function()
        teleportToFinishLine()
    end)

    sec("Alert", "⚠️")
    tog("Safe Zone", false, function(s) S.SafeZone = s end)
    tog("Escape Alert", false, function(s) S.EscapeAlert = s end)
    sl("Alert Range", 20, 150, 60, function(v) S.EscapeAlertRange = v end)
    tog("Stun Notify", false, function(s) S.StunNotify = s end)
    tog("Kill Feed", false, function(s) S.KillFeed = s end)
end)

-- ============================================================
-- TAB 2: KILLER
-- ============================================================
makeTab("Killer", "🔪", 2, function()

    sec("Auto Attack", "⚔️")
    tog("Killer Auto Attack", false, function(s) S.Killer_AutoAtk = s end)
    sl("Attack Delay", 0.1, 1, 0.35, function(v) S.Killer_AtkDelay = v end)

    sec("Kill All", "💀")
    tog("Killer Kill All", false, function(s) S.Killer_KillAll = s end)
    lbl("Auto TP ke survivor + attack", C.DIM)

    sec("Auto Carry + Hook", "🎒")
    tog("Auto Carry (Downed)", false, function(s) S.AutoCarry = s end)
    lbl("Auto gendong survivor yang down", C.FIRE_BRIGHT)
    tog("Auto Hook", false, function(s) S.AutoHook = s end)
    lbl("Auto hook survivor yang digendong", C.FIRE_BRIGHT)
    sl("Carry Range", 10, 200, 60, function(v) S.CarryRange = v end)

    sec("Masked Power", "🎭")
    drp("Select Power", {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}, "Cobra", function(v)
        S.MaskedPower = v
    end)

    btn("Activate Power", function()
        local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
            and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
            and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Activatepower")
        if Event then
            Event:FireServer(S.MaskedPower)
        end
    end)

    btn("Deactivate Power", function()
        local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
            and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
            and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Deactivatepower")
        if Event then
            Event:FireServer()
        end
    end)
end)

-- ============================================================
-- TAB 3: ESP
-- ============================================================
makeTab("ESP", "👁️", 3, function()
    sec("Player ESP", "🟢")
    tog("ESP Survivor", true, function(s) ESP.Survivor = s end)
    cpk("Survivor Color", TeamColors.Survivor, function(c) TeamColors.Survivor = c end)
    tog("ESP Killer", true, function(s) ESP.Killer = s end)
    cpk("Killer Color", TeamColors.Killer, function(c) TeamColors.Killer = c end)

    sec("Object ESP", "⚡")
    tog("ESP Generator", true, function(s) ESP.Generator = s end)
    cpk("Gen Color", GeneratorColor, function(c) GeneratorColor = c end)
    tog("ESP Pallet", false, function(s) ESP.Pallet = s end)
    cpk("Pallet Color", PalletColor, function(c) PalletColor = c end)
    tog("ESP Window", false, function(s) ESP.Window = s end)
    cpk("Window Color", WindowColor, function(c) WindowColor = c end)
    tog("ESP SCP", false, function(s) ESP.SCP = s end)
    cpk("SCP Color", SCPColor, function(c) SCPColor = c end)

    sec("ESP Distance", "📏")
    sl("ESP Radius", 10, 500, 500, function(v) ESP.Distance = v end)
    lbl("Max 500 (default 500)", C.GRN)

    sec("Status ESP", "🟢")
    tog("Enable Status ESP", false, function(s) ESPStatus.Enabled = s end)
    tog("Show Name", true, function(s) ESPStatus.ShowName = s end)
    tog("Show Distance", true, function(s) ESPStatus.ShowDistance = s end)
    tog("Show Health", false, function(s) ESPStatus.ShowHealth = s end)
    sl("Status Radius", 20, 500, 50, function(v) ESPStatus.Radius = v end)

    sec("Nama Mode", "✨")
    drp("Name Mode", {"Text", "Galaxy"}, "Text", function(v)
        S.ESPNameMode = v
    end)
    sl("Name Size", 8, 30, 12, function(v)
        S.ESPNameSize = v
    end)
    lbl("Text = biasa | Galaxy = gradient muter", C.FIRE_BRIGHT)
end)

-- ============================================================
-- TAB 4: FIRE
-- ============================================================
makeTab("Fire", "🔥", 4, function()
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

-- ============================================================
-- TAB 5: MOONWALK (100% PERSIS FALLENS)
-- ============================================================
makeTab("Moonwalk", "🕺", 5, function()

    sec("Moonwalk Control", "🕺")
    tog("Enable Moonwalk (Keybind V)", false, function(s)
        Moonwalk.Enabled = s
        if s then
            startMoonwalk()
        else
            stopMoonwalk()
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if S.WalkSpeed then
                    hum.WalkSpeed = S.WalkSpeedVal
                elseif S.SpeedHack then
                    hum.WalkSpeed = S.SpeedHackVal
                else
                    hum.WalkSpeed = 16
                end
            end
        end
    end)
    lbl("Tekan V juga bisa toggle", C.GRN)

    sec("Button", "🎯")
    tog("Show Moonwalk Button", false, function(s)
        Moonwalk.ShowButton = s
        if s then
            createMoonwalkButton()
        else
            removeMoonwalkButton()
        end
    end)
    lbl("Image ID: 93349170559446 (FALLENS)", C.FIRE_BRIGHT)

    sec("Sensitivitas", "⚙️")
    sl("Spam Speed", 1, 50, 30, function(v)
        Moonwalk.SpamSpeed = v
    end)
    lbl("Kecepatan goyang", C.DIM)

    sl("Intensity", 1, 50, 35, function(v)
        Moonwalk.Intensity = v
    end)
    lbl("Besarnya goyangan (derajat)", C.DIM)

    sl("Walk Speed (Moonwalk)", 5, 20, 13, function(v)
        Moonwalk.SlowSpeed = v
    end)
    lbl("Kecepatan jalan pas moonwalk", C.DIM)

    tog("Use Slow Speed", true, function(s)
        Moonwalk.UseSlow = s
    end)
end)

print("✅ [7/11] COSMIC HUB - Survivor + Killer + ESP + Fire + Moonwalk loaded")-- =========================================================
-- SECTION 8/11 : TAB UI PART 2 + MOONWALK BUTTON (FALLENS)
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

-- =========================================================
-- MOONWALK BUTTON (100% PERSIS FALLENS - NO LOCK, NO DRAG)
-- =========================================================
function createMoonwalkButton()
    if not PG or not PG.Parent then return end
    if Moonwalk.GuiInstance then Moonwalk.GuiInstance:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "MoonwalkGui"
    gui.ResetOnSpawn = false
    gui.Parent = PG

    local btn = Instance.new("ImageButton")
    btn.Name = "ToggleButton"
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = Moonwalk.ButtonPos
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.9
    btn.Image = "rbxassetid://93349170559446"  -- FALLENS ID
    btn.ImageTransparency = 0.1
    btn.AutoButtonColor = false
    btn.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        Moonwalk.Enabled = not Moonwalk.Enabled

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if Moonwalk.Enabled then
            stroke.Color = Color3.fromRGB(170, 0, 255)
            if not MoonwalkConnection then
                startMoonwalk()
            end
        else
            stroke.Color = Color3.fromRGB(255, 255, 255)
            if hum then
                if S.WalkSpeed then
                    hum.WalkSpeed = S.WalkSpeedVal
                elseif S.SpeedHack then
                    hum.WalkSpeed = S.SpeedHackVal
                else
                    hum.WalkSpeed = 16
                end
            end
        end
    end)

    Moonwalk.GuiInstance = gui
end

function removeMoonwalkButton()
    if Moonwalk.GuiInstance then
        Moonwalk.GuiInstance:Destroy()
        Moonwalk.GuiInstance = nil
    end
end

_G.createMoonwalkButton = createMoonwalkButton
_G.removeMoonwalkButton = removeMoonwalkButton

-- ============================================================
-- TAB 6: FIRE FEET
-- ============================================================
makeTab("Fire Feet", "👟", 6, function()
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

-- ============================================================
-- TAB 7: MISC
-- ============================================================
makeTab("Misc", "⚙️", 7, function()

    sec("Movement", "🏃")
    tog("Walk Speed", false, function(s) S.WalkSpeed = s end)
    sl("Walk Speed Value", 16, 100, 16, function(v) S.WalkSpeedVal = v end)

    tog("Speed Hack", false, function(s) S.SpeedHack = s end)
    sl("Speed Hack Value", 20, 200, 40, function(v) S.SpeedHackVal = v end)

    tog("No Clip", false, function(s) S.NoClip = s end)
    tog("No Clip Camera", false, function(s) S.NoClipCamera = s end)

    tog("Fly", false, function(s)
        S.Fly = s
        if s then
            startFly()
        else
            stopFly()
        end
    end)
    sl("Fly Speed", 10, 300, 50, function(v) S.FlySpeed = v end)

    sec("Character", "🎭")
    tog("Headless", true, function(s)
        S.Headless = s
        applyHeadless(s)
    end)

    sec("Misc Utility", "🛠️")
    tog("Anti-AFK", false, function(s)
        S.AntiAFK = s
        applyAntiAFK(s)
    end)
    lbl("Biar nggak kena kick AFK", C.GRN)

    tog("Show FPS Counter", true, function(s) S.ShowFPS = s end)
    tog("Show Ping Counter", true, function(s) S.ShowPing = s end)

    sl("FPS/Ping Size", 0.5, 3, 1, function(v)
        FPSPingConfig.Size = v
        if _G.Roooor_updateFPSPing then _G.Roooor_updateFPSPing() end
    end)

    sl("FPS/Ping X", -1000, 200, 0, function(v)
        FPSPingConfig.X = v
        if _G.Roooor_updateFPSPing then _G.Roooor_updateFPSPing() end
    end)

    sl("FPS/Ping Y", -200, 500, 0, function(v)
        FPSPingConfig.Y = v
        if _G.Roooor_updateFPSPing then _G.Roooor_updateFPSPing() end
    end)

    btn("🔄 Rejoin Server", function() rejoinServer() end)
    btn("🌐 Server Hop", function() serverHop() end)
end)

-- ============================================================
-- TAB 8: PLAYER (FPS Boost)
-- ============================================================
makeTab("Player", "👤", 8, function()

    sec("Aimlock Mode", "🎯")
    drp("Aim Mode", {"Killer", "Survivor"}, "Killer", function(v)
        Combat.Mode = v
    end)

    sec("FPS Boost", "🚀")
    tog("No Screen Effects", false, function(s)
        S.NoScreenEffects = s
        applyNoScreenEffects()
    end)
    lbl("Matikan blur, bloom, DOF (FPS naik)", C.GRN)

    tog("Low Graphics", false, function(s)
        S.LowGraphics = s
        applyLowGraphics()
    end)
    lbl("Quality Level 1 (FPS paling tinggi)", C.GRN)

    tog("Clean Sky", false, function(s)
        S.CleanSky = s
        applyCleanSky()
    end)
    lbl("Hapus Sky (FPS boost)", C.GRN)

    sec("Info", "ℹ️")
    lbl("🎯 Aimbot = Hold tombol serang", C.FIRE_BRIGHT)
    lbl("PC: klik kanan | HP: tombol attack", C.DIM)
    lbl("🕺 Moonwalk: Tekan V", C.FIRE_BRIGHT)

    sec("Danger Zone", "⚠️")
    btn("✨ UNLOAD COSMIC HUB", function()
        pcall(function()
            if gui then gui:Destroy() end
            if killFeedGui then killFeedGui:Destroy() end
            if loadingGui then loadingGui:Destroy() end
            if crosshairGui then crosshairGui:Destroy() end
            if fpsPingGui then fpsPingGui:Destroy() end
            clear8Bit()
            clearKorblox()
            clearFireBeam()
            clearParryCircle()
            stopMoonwalk()
            removeMoonwalkButton()
        end)
        _G.RoooorS = nil
        _G.Roooor_ESP = nil
        _G.Roooor_ESPStatus = nil
        _G.Roooor_AutoParry = nil
        _G.Roooor_SkillCheck = nil
        _G.Roooor_Moonwalk = nil
        _G.Roooor_Combat = nil
        _G.Roooor_GodMode = nil
    end)
end)

-- ============================================================
-- TAB 9: VISUAL (Crosshair 8 Mode + Fire Beam + 8-Bit + Korblox)
-- ============================================================
makeTab("Visual", "✨", 9, function()

    sec("Fullbright & No Fog", "💡")
    tog("Fullbright (max 200)", false, function(s)
        S.Fullbright = s
        applyFullbright(s)
    end)
    sl("Brightness Level", 10, 200, 100, function(v)
        S.FullbrightVal = v
        if S.Fullbright then applyFullbright(true) end
    end)

    tog("No Fog (Fix)", false, function(s)
        S.NoFog = s
        applyNoFog(s)
    end)

    sec("HD Visual (Ringan)", "💎")
    tog("HD Graphics Boost", false, function(s)
        S.HDBoost = s
        applyHDBoost(s)
    end)
    tog("HD Character Shader", false, function(s)
        S.HDShader = s
        applyHDShader(s)
    end)
    tog("HD Sky Atmosphere", false, function(s)
        S.HDSky = s
        applyHDSky(s)
    end)

    sec("HD Visual (Extra)", "🌟")
    tog("HD Texture", false, function(s) S.HDTexture = s; applyHDTexture(s) end)
    tog("HD Reflection", false, function(s) S.HDReflection = s; applyHDReflection(s) end)
    tog("HD Bloom", false, function(s) S.HDBloom = s; applyHDBloom(s) end)
    tog("HD Shadow", false, function(s) S.HDShadow = s; applyHDShadow(s) end)
    tog("HD Water", false, function(s) S.HDWater = s; applyHDWater(s) end)
    tog("HD Sun Rays", false, function(s) S.HDSunRays = s; applyHDSunRays(s) end)
    tog("HD Depth of Field", false, function(s) S.HDDepthField = s; applyHDDepthField(s) end)
    tog("HD Anti-Aliasing", false, function(s) S.HDAntiAliasing = s; applyHDAntiAliasing(s) end)

    sec("Lighting", "💡")
    tog("Ultra HD", false, function(s) S.UltraHD = s; applyUltraHD() end)
    tog("Contrast Boost", false, function(s) S.Contrast = s; applyContrast() end)
    sl("Contrast", 0, 1, 0.3, function(v) S.ContrastVal = v; applyContrast() end)
    sl("Saturation", 0, 1, 0.2, function(v) S.SaturationVal = v; applyContrast() end)

    sec("Sky", "🌌")
    drp("Sky Preset", SkyList, "Default", function(v)
        S.SkyId = v
        applySky(v)
    end)

    sec("Camera", "🎥")
    tog("FOV Override", false, function(s) S.FOVEnabled = s; applyFOV() end)
    sl("FOV Value", 40, 120, 70, function(v) S.FOV = v; if S.FOVEnabled then applyFOV() end end)
    tog("Zoom Out", false, function(s) S.ZoomOut = s; applyZoomOut(s, S.ZoomOutValue) end)
    sl("Max Zoom Distance", 100, 1000, 500, function(v)
        S.ZoomOutValue = v
        if S.ZoomOut then applyZoomOut(true, v) end
    end)

    sec("8-Bit Royal Crown (Client)", "👑")
    tog("Enable 8-Bit Crown", true, function(s)
        S.EightBitOn = s
        apply8Bit(s, "Royal Crown", S.EightBitSize, S.EightBitHeight)
    end)
    sl("Size", 0.3, 3, 1.24, function(v)
        S.EightBitSize = v
        if S.EightBitOn then apply8Bit(true, "Royal Crown", v, S.EightBitHeight) end
    end)
    sl("Height", -1, 4, 0.88, function(v)
        S.EightBitHeight = v
        if S.EightBitOn then apply8Bit(true, "Royal Crown", S.EightBitSize, v) end
    end)

    sec("Korblox Pencil (Client)", "🦴")
    tog("Enable Korblox", true, function(s)
        S.Korblox = s
        applyKorblox(s, "Pencil", S.KorbloxYOffset, S.KorbloxScale)
    end)
    sl("Korblox Y", -2, 2, 0.6, function(v)
        S.KorbloxYOffset = v
        if S.Korblox then applyKorblox(true, "Pencil", v, S.KorbloxScale) end
    end)
    sl("Korblox Scale", 0.3, 3, 1, function(v)
        S.KorbloxScale = v
        if S.Korblox then applyKorblox(true, "Pencil", S.KorbloxYOffset, v) end
    end)

    -- CROSSHAIR 8 MODE
    sec("Crosshair 8 Mode 🆕", "🎯")

    tog("Enable Crosshair", false, function(s)
        S.Crosshair = s
        applyCrosshair(s, S.CrosshairColor, S.CrosshairSize)
    end)

    drp("Style (8 Mode)", {
        "Plus", "Dot", "Circle", "X",
        "Square", "Diamond", "TShape", "CrossDot"
    }, "Plus", function(v)
        S.CrosshairStyle = v
        if S.Crosshair then
            applyCrosshair(true, S.CrosshairColor, S.CrosshairSize)
        end
    end)

    drp("Color Mode", {"Solid", "Galaxy"}, "Solid", function(v)
        S.CrosshairColorMode = v
        if S.Crosshair then
            applyCrosshair(true, S.CrosshairColor, S.CrosshairSize)
        end
    end)
    lbl("Solid = warna biasa | Galaxy = gradient muter", C.FIRE_BRIGHT)

    cpk("Crosshair Color", S.CrosshairColor, function(c)
        S.CrosshairColor = c
        if S.Crosshair then
            applyCrosshair(true, c, S.CrosshairSize)
        end
    end)

    sl("Crosshair Size", 4, 30, 8, function(v)
        S.CrosshairSize = v
        if S.Crosshair then
            applyCrosshair(true, S.CrosshairColor, v)
        end
    end)

    sl("Crosshair Thickness", 1, 6, 2, function(v)
        S.CrosshairThickness = v
        if S.Crosshair then
            applyCrosshair(true, S.CrosshairColor, S.CrosshairSize)
        end
    end)

    sl("Offset X", -200, 200, 0, function(v)
        S.CrosshairOffsetX = v
        if S.Crosshair then
            applyCrosshair(true, S.CrosshairColor, S.CrosshairSize)
        end
    end)

    sl("Offset Y", -200, 200, 0, function(v)
        S.CrosshairOffsetY = v
        if S.Crosshair then
            applyCrosshair(true, S.CrosshairColor, S.CrosshairSize)
        end
    end)

    -- FIRE BEAM
    sec("Fire Beam (10 Efek)", "🔥")
    tog("Enable Fire Beam", false, function(s)
        S.FireBeamOn = s
        applyFireBeam(s, S.FireBeamType, S.FireBeamColor)
    end)

    for _, beamName in ipairs(FireBeamList) do
        local btn3 = Instance.new("TextButton")
        btn3.Size = UDim2.new(1, -4, 0, 24)
        btn3.BackgroundColor3 = C.BG
        btn3.BackgroundTransparency = 0.4
        btn3.BorderSizePixel = 0
        btn3.Text = ""
        btn3.AutoButtonColor = false
        btn3.Parent = cs
        rnd(btn3, 7)
        strk(btn3, C.ACC, 1, 0.6)

        local btnLbl3 = Instance.new("TextLabel")
        btnLbl3.Size = UDim2.new(1, -10, 1, 0)
        btnLbl3.Position = UDim2.new(0, 8, 0, 0)
        btnLbl3.BackgroundTransparency = 1
        btnLbl3.Text = "🔥 " .. beamName
        btnLbl3.TextColor3 = C.TXT
        btnLbl3.TextSize = 9
        btnLbl3.Font = Enum.Font.GothamMedium
        btnLbl3.TextXAlignment = Enum.TextXAlignment.Left
        btnLbl3.Parent = btn3

        if S.FireBeamType == beamName then
            btn3.BackgroundColor3 = C.ACC
            btn3.BackgroundTransparency = 0
            btnLbl3.TextColor3 = Color3.new(1, 1, 1)
        end

        btn3.MouseButton1Click:Connect(function()
            S.FireBeamType = beamName
            applyFireBeam(S.FireBeamOn, beamName, S.FireBeamColor)
            for _, c in pairs(cs:GetChildren()) do
                if c:IsA("TextButton") and c:FindFirstChildOfClass("TextLabel") then
                    local lx = c:FindFirstChildOfClass("TextLabel")
                    if lx and string.sub(lx.Text, 1, 4) == "🔥 " then
                        c.BackgroundColor3 = C.BG
                        c.BackgroundTransparency = 0.4
                        lx.TextColor3 = C.TXT
                    end
                end
            end
            btn3.BackgroundColor3 = C.ACC
            btn3.BackgroundTransparency = 0
            btnLbl3.TextColor3 = Color3.new(1, 1, 1)
        end)
    end

    cpk("Beam Color", S.FireBeamColor, function(c)
        S.FireBeamColor = c
        if S.FireBeamOn then applyFireBeam(true, S.FireBeamType, c) end
    end)

    sec("Character Effects", "✨")
    tog("Fire Trail", false, function(s)
        S.Trail = s
        applyTrail(s, S.TrailColor)
    end)
    cpk("Trail Color", S.TrailColor, function(c)
        S.TrailColor = c
        if S.Trail then applyTrail(true, c) end
    end)

    tog("Aura Fire", false, function(s)
        S.Aura = s
        applyAura(s, S.AuraColor)
    end)
    cpk("Aura Color", S.AuraColor, function(c)
        S.AuraColor = c
        if S.Aura then applyAura(true, c) end
    end)

    tog("Kill Effect", false, function(s) S.KillEffect = s end)
end)

-- ============================================================
-- TAB 10: COMBAT
-- ============================================================
makeTab("Combat", "⚔️", 10, function()
    sec("Aimbot (Hold to Aim - INSTAN)", "🎯")
    tog("Enable Aimbot", false, function(s)
        Combat.AimlockEnabled = s
        if not s then
            Combat.AttackHeld = false
            Combat.Holding = false
        end
    end)
    lbl("Tahan tombol attack = auto nempel", C.FIRE_BRIGHT)
    drp("Aim Mode", {"Killer", "Survivor"}, "Killer", function(v) Combat.Mode = v end)
    drp("Aim Part", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(v) Combat.AimPart = v end)
    sl("Smoothness", 0.01, 1, 0.01, function(v) Combat.Smoothness = v end)
    lbl("0.01 = INSTAN nempel", C.GRN)
    sl("Lock Radius (studs)", 10, 500, 150, function(v) Combat.LockRadius = v end)
    sl("FOV Radius (layar)", 50, 500, 200, function(v) Combat.FOVRadius = v end)
    tog("Show FOV Circle", false, function(s) Combat.FOVCircle = s end)

    sec("Prediction", "📈")
    tog("Predict Movement", true, function(s) Combat.Predict = s end)
    sl("Predict Strength", 0, 1, 0.15, function(v) Combat.PredictStrength = v end)

    sec("Visibility Check", "👁️")
    tog("Anti-Wall (Silent)", false, function(s) Combat.VisibilityCheck = s end)
    tog("Anti-Wall (Strict)", false, function(s) Combat.WallCheck = s end)

    sec("Trigger Bot", "🔫")
    tog("Auto Attack saat lock", false, function(s) Combat.TriggerBotEnabled = s end)
    sl("Trigger Delay", 0.01, 0.5, 0.05, function(v) Combat.TriggerDelay = v end)

    sec("Hitbox (BESAR - 2 Mode)", "📦")
    tog("Hitbox Survivor Mode", false, function(s) Combat.HitboxSurvivor = s end)
    tog("Hitbox Killer Mode", false, function(s) Combat.HitboxKiller = s end)
    sl("Hitbox Size", 10, 120, 25, function(v) Combat.HitboxSize = v end)
    lbl("Max 120 (manual ON)", C.GRN)
    tog("Show Hitbox (Visible)", false, function(s) Combat.HitboxVisible = s end)

    sec("Keybind", "⌨️")
    lbl("Hold tombol serang = aimbot ON", C.FIRE_BRIGHT)
end)

-- ============================================================
-- TAB 11: EXTRA
-- ============================================================
makeTab("Extra", "✨", 11, function()
    sec("Teleport", "🌀")
    btn("🚪 TP ke Finish Line", function() teleportToFinishLine() end)

    sec("Sound", "🔊")
    btn("🔊 Test Sound", function() playToggleSound() end)
    lbl("Sound aktif saat toggle ON/OFF", C.DIM)
end)

print("✅ [8/11] COSMIC HUB - Tab UI Part 2 + Moonwalk Button (FALLENS) loaded")-- =========================================================
-- SECTION 9/11 : FINAL - COMBAT + EXTRA + AUTO RE-APPLY
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

-- =========================================================
-- COMBAT SYSTEM (AIMLOCK)
-- =========================================================
RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist

function isVisible(part)
    if not Combat.VisibilityCheck and not Combat.WallCheck then return true end
    local cam = workspace.CurrentCamera
    if not cam then return true end
    RayParams.FilterDescendantsInstances = { LP.Character }
    local origin = cam.CFrame.Position
    local direction = (part.Position - origin)
    local result = workspace:Raycast(origin, direction, RayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

fovGui = nil
function createFOVCircle()
    if fovGui then fovGui:Destroy(); fovGui = nil end
    fovGui = Instance.new("ScreenGui")
    fovGui.Name = "CosmicFOV"
    fovGui.ResetOnSpawn = false
    fovGui.IgnoreGuiInset = true
    fovGui.Parent = PG
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 0, 0, 0)
    circle.Position = UDim2.new(0.5, 0, 0.5, 0)
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.BackgroundTransparency = 1
    circle.Parent = fovGui
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = C.ACC2
    stroke.Transparency = 0.3
    stroke.Parent = circle
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle
    return circle
end

task.spawn(function()
    while task.wait(0.1) do
        if Combat.FOVCircle then
            if not fovGui then createFOVCircle() end
            local circle = fovGui:FindFirstChildOfClass("Frame")
            if circle then
                local r = Combat.FOVRadius * 2
                circle.Size = UDim2.new(0, r, 0, r)
                circle.Visible = true
            end
        else
            if fovGui then
                local circle = fovGui:FindFirstChildOfClass("Frame")
                if circle then circle.Visible = false end
            end
        end
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if not Combat.AimlockEnabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Combat.AttackHeld = true
    end
    if input.UserInputType == Enum.UserInputType.Touch then
        Combat.AttackHeld = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Combat.AttackHeld = false
    end
    if input.UserInputType == Enum.UserInputType.Touch then
        Combat.AttackHeld = false
    end
end)

task.spawn(function()
    function getAttackBtn()
        local paths = {
            "Survivor-mob.Controls.Gui-mob",
            "Slasher-mob.Controls.attack",
            "Masked-mob.Controls.attack",
            "Killer-mob.Controls.attack",
        }
        for _, path in ipairs(paths) do
            local cur = PG
            for seg in string.gmatch(path, "[^%.]+") do
                cur = cur and cur:FindFirstChild(seg)
            end
            if cur and cur:IsA("GuiObject") then
                return cur
            end
        end
    end
    local lastBtn = nil
    while task.wait(1) do
        local btn = getAttackBtn()
        if btn and btn ~= lastBtn then
            lastBtn = btn
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    Combat.AttackHeld = true
                end
            end)
            btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    Combat.AttackHeld = false
                end
            end)
        end
    end
end)

lastTrigger = 0

task.spawn(function()
    while task.wait(0.01) do
        if not Combat.AimlockEnabled then continue end
        if not Combat.AttackHeld and not Combat.Holding then continue end
        local myRoot = getRoot()
        if not myRoot then continue end
        local cam = workspace.CurrentCamera
        if not cam then continue end
        local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        local closest, shortest = nil, Combat.LockRadius
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local teamName = p.Team and p.Team.Name or ""
                local valid = false
                if Combat.Mode == "Killer" and teamName == "Killer" then
                    valid = true
                elseif Combat.Mode == "Survivor" and teamName == "Survivors" then
                    valid = true
                end
                if valid then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    local aimPart = p.Character:FindFirstChild(Combat.AimPart)
                        or p.Character:FindFirstChild("Head")
                        or p.Character:FindFirstChild("HumanoidRootPart")
                    if hum and hum.Health > 0 and aimPart then
                        local dist3D = (aimPart.Position - myRoot.Position).Magnitude
                        if dist3D < shortest then
                            if Combat.VisibilityCheck or Combat.WallCheck then
                                if not isVisible(aimPart) then continue end
                            end
                            local pos2D, onScreen = cam:WorldToViewportPoint(aimPart.Position)
                            if onScreen then
                                local dist2D = (Vector2.new(pos2D.X, pos2D.Y) - center).Magnitude
                                if dist2D <= Combat.FOVRadius then
                                    shortest = dist3D
                                    closest = aimPart
                                end
                            end
                        end
                    end
                end
            end
        end
        if closest then
            local pos = closest.Position
            if Combat.Predict then
                pos = pos + (closest.AssemblyLinearVelocity * Combat.PredictStrength)
            end
            local targetCF = CFrame.new(cam.CFrame.Position, pos)
            local smooth = math.clamp(Combat.Smoothness, 0.01, 1)
            cam.CFrame = cam.CFrame:Lerp(targetCF, smooth)
            if Combat.TriggerBotEnabled then
                local now = tick()
                if now - lastTrigger >= Combat.TriggerDelay then
                    lastTrigger = now
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

hitboxCache = {}

task.spawn(function()
    while task.wait(0.5) do
        local myTeam = LP.Team and LP.Team.Name or ""
        local enabled = false
        if Combat.HitboxSurvivor and myTeam == "Survivors" then enabled = true end
        if Combat.HitboxKiller and myTeam == "Killer" then enabled = true end
        if enabled then
            local targetTeam = (myTeam == "Survivors") and "Killer" or "Survivors"
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Team and p.Team.Name == targetTeam then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local part = p.Character:FindFirstChild("HumanoidRootPart")
                        if part then
                            if not hitboxCache[part] then
                                hitboxCache[part] = {
                                    Size = part.Size,
                                    Transparency = part.Transparency,
                                    CanCollide = part.CanCollide,
                                    Material = part.Material,
                                }
                            end
                            local size = Combat.HitboxSize or 25
                            part.Size = Vector3.new(size, size, size)
                            part.CanCollide = false
                            part.Transparency = Combat.HitboxVisible and 0.5 or 1
                            part.Material = Enum.Material.ForceField
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
                end
                hitboxCache[part] = nil
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if not GodMode.Enabled then continue end
        if not LP.Character then continue end
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if not hum then continue end
        if hum.Health > 0 and hum.Health < hum.MaxHealth then
            pcall(function() hum.Health = hum.MaxHealth end)
        end
        if hum.PlatformStand then hum.PlatformStand = false end
        pcall(function()
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Dead
                or state == Enum.HumanoidStateType.FallingDown
                or state == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
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
end)

-- =========================================================
-- AUTO RE-APPLY SAAT RESPAWN
-- =========================================================
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    if S.FireOn then pcall(applyFire) end
    if S.FireFeetOn then pcall(applyFireFeet) end
    if S.EightBitOn then
        pcall(function() apply8Bit(true, "Royal Crown", S.EightBitSize, S.EightBitHeight) end)
    end
    if S.Korblox then
        pcall(function() applyKorblox(true, "Pencil", S.KorbloxYOffset, S.KorbloxScale) end)
    end
    if S.FireBeamOn then pcall(function() applyFireBeam(true, S.FireBeamType, S.FireBeamColor) end) end
    if S.Trail then pcall(function() applyTrail(true, S.TrailColor) end) end
    if S.Aura then pcall(function() applyAura(true, S.AuraColor) end) end
    if S.Headless then pcall(function() applyHeadless(true) end) end
    if S.FOVEnabled then pcall(applyFOV) end
    if S.SkyId and S.SkyId ~= "Default" then pcall(function() applySky(S.SkyId) end) end
    if S.HDBoost then pcall(function() applyHDBoost(true) end) end
    if S.HDShader then pcall(function() applyHDShader(true) end) end
    if S.HDSky then pcall(function() applyHDSky(true) end) end
    if S.HDTexture then pcall(function() applyHDTexture(true) end) end
    if S.HDReflection then pcall(function() applyHDReflection(true) end) end
    if S.HDBloom then pcall(function() applyHDBloom(true) end) end
    if S.HDShadow then pcall(function() applyHDShadow(true) end) end
    if S.HDWater then pcall(function() applyHDWater(true) end) end
    if S.HDSunRays then pcall(function() applyHDSunRays(true) end) end
    if S.HDDepthField then pcall(function() applyHDDepthField(true) end) end
    if S.HDAntiAliasing then pcall(function() applyHDAntiAliasing(true) end) end
    if S.NoClip then
        task.wait(0.3)
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    if Moonwalk.ShowButton then
        task.wait(0.5)
        pcall(createMoonwalkButton)
    end
    -- FAST VAULT HOOK (PERSIS FALLENS)
    pcall(function() hookVault(char) end)
end)

task.spawn(function()
    while task.wait(1) do
        if AutoParry.Enabled then scanKillers() end
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        task.wait(1)
        if AutoParry.Enabled then
            if p.Team and p.Team.Name == "Killer" then
                hookKiller(char)
            end
        end
    end)
end)

-- =========================================================
-- KEYBIND V UNTUK MOONWALK (PERSIS FALLENS)
-- =========================================================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.V then
        Moonwalk.Enabled = not Moonwalk.Enabled

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if Moonwalk.Enabled then
            startMoonwalk()
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "Moonwalk",
                    Text = "🕺 ON",
                    Duration = 1.5
                })
            end)
        else
            stopMoonwalk()
            if hum then
                if S.WalkSpeed then
                    hum.WalkSpeed = S.WalkSpeedVal
                elseif S.SpeedHack then
                    hum.WalkSpeed = S.SpeedHackVal
                else
                    hum.WalkSpeed = 16
                end
            end
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "Moonwalk",
                    Text = "OFF",
                    Duration = 1.5
                })
            end)
        end
    end
end)

-- AUTO APPLY ON EXECUTE
task.spawn(function()
    task.wait(3)
    pcall(createFPSPingGui)
    if LP.Character then
        if S.Headless then pcall(function() applyHeadless(true) end) end
        if S.Korblox then
            pcall(function() applyKorblox(true, "Pencil", S.KorbloxYOffset, S.KorbloxScale) end)
        end
        if S.EightBitOn then
            pcall(function() apply8Bit(true, "Royal Crown", S.EightBitSize, S.EightBitHeight) end)
        end
        if AutoParry.Enabled then pcall(scanKillers) end
        if SkillCheck.Enabled then pcall(startSkillCheck) end
        if FastVault.Enabled then
            pcall(function() hookVault(LP.Character) end)
        end
    end
end)

print("✅ [9/11] COSMIC HUB - Final Combat + Auto Re-Apply + Keybind V loaded")-- =========================================================
-- SECTION 10/11 : LOGIC FITUR BARU (RAPIH)
-- =========================================================

-- =========================================================
-- AUTO WIGGLE LOOP
-- =========================================================
task.spawn(function()
    while task.wait(0.5) do
        if not AutoParry.Wiggle then continue end
        local char = LP.Character
        if not char then continue end
        local carried = (char:FindFirstChild("IsCarried") and char.IsCarried.Value)
            or (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)
        if not carried then continue end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes then continue end
        local carry = remotes:FindFirstChild("Carry")
        if not carry then continue end
        local event = carry:FindFirstChild("SelfUnHookEvent")
        if not event then continue end
        for i = 1, (AutoParry.WiggleSpam or 5) do
            pcall(function() event:FireServer() end)
        end
    end
end)

-- =========================================================
-- AUTO FLEE LOOP
-- =========================================================
task.spawn(function()
    while task.wait(0.2) do
        if not AutoFlee.Enabled then continue end
        local root = getRoot()
        if not root then continue end
        local killerRoot, distance = GetNearestKillerForFlee()
        if killerRoot and distance <= AutoFlee.DetectDistance
           and tick() - AutoFlee.LastFlee > AutoFlee.Cooldown then
            local point = GetFarthestGeneratorPoint(killerRoot)
            if point then
                AutoFlee.LastFlee = tick()
                pcall(function()
                    root.CFrame = point.CFrame + Vector3.new(0, 5, 0)
                end)
            end
        end
    end
end)

-- =========================================================
-- AUTO ESCAPE LOOP
-- =========================================================
task.spawn(function()
    while task.wait(1) do
        if not S.AutoEscapeGate then continue end
        local root = getRoot()
        if not root then continue end

        local killerNear = false
        if S.AutoEscapeUseKillerCheck then
            local kRoot, kDist = GetNearestKillerForFlee()
            if kRoot and kDist <= (S.AutoEscapeRange or 50) then
                killerNear = true
            end
        end

        local genDone = false
        if S.AutoEscapeUseGenCheck then
            local total, done = 0, 0
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "Generator" then
                    total = total + 1
                    local p = obj:GetAttribute("RepairProgress")
                        or obj:GetAttribute("Progress") or 0
                    if p >= 100 then done = done + 1 end
                end
            end
            if total > 0 and done >= total then genDone = true end
        end

        if killerNear or genDone then
            local found = nil
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local n = string.lower(obj.Name)
                    if n == "fininshline" or n == "finishline" 
                       or n == "escape" or n == "escapegate"
                       or string.find(n, "escape") then
                        found = obj
                        break
                    end
                end
            end
            if found then
                pcall(function()
                    root.CFrame = found.CFrame + Vector3.new(0, 5, 0)
                end)
            end
        end
    end
end)

-- =========================================================
-- FAST VAULT HOOK (PERSIS FALLENS)
-- =========================================================
LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    if FastVault.Enabled then
        pcall(function() hookVault(char) end)
    end
end)

if LP.Character then
    pcall(function() hookVault(LP.Character) end)
end

-- =========================================================
-- AUTO CARRY LOOP
-- =========================================================
task.spawn(function()
    while task.wait(0.2) do
        if not S.AutoCarry or KillerBusy then continue end

        local CarryEvent = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Carry", true)
            and ReplicatedStorage.Remotes.Carry:FindFirstChild("CarrySurvivorEvent")
        local HookEvent = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Carry", true)
            and ReplicatedStorage.Remotes.Carry:FindFirstChild("HookEvent")

        if not CarryEvent or not HookEvent then continue end

        local target = GetDownedSurvivor()
        local root = getRoot()

        if target and root then
            KillerBusy = true
            local tRoot = target:FindFirstChild("HumanoidRootPart")
            if tRoot then
                root.CFrame = tRoot.CFrame * CFrame.new(0, 3, -2)
                task.wait(0.4)
                for i = 1, 4 do
                    pcall(function() CarryEvent:FireServer(target) end)
                    task.wait(0.2)
                end
                task.wait(0.6)

                if S.AutoHook then
                    local hook = GetHookPoint()
                    if hook then
                        root.CFrame = hook.CFrame * CFrame.new(0, 4, -3)
                        task.wait(0.7)
                        for i = 1, 6 do
                            pcall(function() HookEvent:FireServer(hook) end)
                            task.wait(0.15)
                        end
                    end
                end
            end
            task.delay(2, function() KillerBusy = false end)
        end
    end
end)

-- =========================================================
-- FPS BOOST LOOP
-- =========================================================
task.spawn(function()
    while task.wait(1) do
        if S.NoScreenEffects then applyNoScreenEffects() end
        if S.LowGraphics then applyLowGraphics() end
        if S.CleanSky then applyCleanSky() end
    end
end)

print("✅ [10/11] COSMIC HUB - Logic fitur baru loaded")-- =========================================================
-- SECTION 11/11 : PRINT FINAL
-- =========================================================
task.wait(0.5)

print("╔══════════════════════════════════════════╗")
print("║  ✨ COSMIC HUB v3.1 ✨                   ║")
print("║  ✅ SEMUA FITUR LOADED                   ║")
print("╠══════════════════════════════════════════╣")
print("║  🛡️ Auto Parry (5-20)                    ║")
print("║  ⚡ Auto Skill Check (2 MODE)            ║")
print("║  🕺 Moonwalk (FALLENS 100%)              ║")
print("║  ⚡ Fast Vault (FALLENS 100%)            ║")
print("║  🔓 Auto Wiggle                          ║")
print("║  🏃 Auto Flee Killer                     ║")
print("║  🚪 Auto Escape Gate                     ║")
print("║  🎒 Auto Carry + Hook                    ║")
print("║  🚀 FPS Boost (3 Mode)                   ║")
print("║  🎯 Crosshair 8 Mode + 2 Warna           ║")
print("║  🎯 Aimbot INSTAN + Hold to Aim          ║")
print("║  📦 Hitbox BESAR + 2 Mode                ║")
print("║  🛡️ God Mode                             ║")
print("║  👑 8-Bit Royal Crown (CLIENT-ONLY)      ║")
print("║  🦴 Korblox Pencil (CLIENT-ONLY)         ║")
print("║  🔥 Fire Beam 10 efek                    ║")
print("║  💎 HD Visual + 8 HD Extra               ║")
print("║  🌌 ESP Nama 2 Mode                      ║")
print("║  🎵 Sound: Android Notif                 ║")
print("║  🛠️ Anti-AFK + Rejoin + Server Hop       ║")
print("║  📊 FPS + Ping Counter (PUTIH)           ║")
print("╠══════════════════════════════════════════╣")
print("║  🎮 Buka menu: Klik tombol ✨           ║")
print("║  🎯 Aimbot: Hold tombol serang           ║")
print("║  🕺 Moonwalk: Tekan V                    ║")
print("║  🛡️ Auto Parry ON = GACOR!               ║")
print("╚══════════════════════════════════════════╝")

print("✅ [11/11] COSMIC HUB v3.1 - FINAL LOADED! ✨")
