--[[
    ╔══════════════════════════════════════════════════════╗
    ║                                                      ║
    ║              ✨ C O S M I C   H U B ✨               ║
    ║                                                      ║
    ║   Auto Parry • SkillCheck 2 Mode • Moonwalk          ║
    ║   Aimlock • Killer • ESP • Fire • Visual             ║
    ║                                                      ║
    ╚══════════════════════════════════════════════════════╝
]]

-- ============================================
-- LOAD OBSIDIAN LIB
-- ============================================
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

-- THEME COSMIC (ungu/cyan)
Library.Scheme.AccentColor     = Color3.fromRGB(140, 70, 255)
Library.Scheme.BackgroundColor = Color3.fromRGB(15, 10, 30)
Library.Scheme.MainColor       = Color3.fromRGB(35, 20, 65)
Library.Scheme.OutlineColor    = Color3.fromRGB(120, 70, 200)
Library.Scheme.FontColor       = Color3.fromRGB(220, 200, 255)

-- ============================================
-- SERVICES
-- ============================================
local Players              = game:GetService("Players")
local RunService           = game:GetService("RunService")
local UserInputService     = game:GetService("UserInputService")
local VirtualInputManager  = game:GetService("VirtualInputManager")
local TweenService         = game:GetService("TweenService")
local GuiService           = game:GetService("GuiService")
local Lighting             = game:GetService("Lighting")
local ReplicatedStorage    = game:GetService("ReplicatedStorage")
local Stats                = game:GetService("Stats")
local SoundService         = game:GetService("SoundService")
local StarterGui           = game:GetService("StarterGui")

local LocalPlayer  = Players.LocalPlayer
local PlayerGui    = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================
-- HELPER
-- ============================================
local function getRoot()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function isDowned()
    local char = LocalPlayer.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    return hum.Health <= 0
        or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true
end

-- ============================================
-- WARNA COSMIC
-- ============================================
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

-- ============================================
-- STATE UTAMA
-- ============================================
_G.CosmicSavedStates = _G.CosmicSavedStates or {}

_G.CosmicS = _G.CosmicS or {
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
    Crosshair = false, CrosshairColor = Color3.fromRGB(0, 200, 255), CrosshairSize = 8,

    -- Camera
    ZoomOut = false, ZoomOutValue = 500,
    FOV = 70, FOVEnabled = false,

    -- Visual
    Fullbright = false, FullbrightVal = 50,
    NoFog = false, UltraHD = false,
    Contrast = false, ContrastVal = 0.3, SaturationVal = 0.2,
    SkyId = "Default",

    -- HUD
    SafeZone = false, EscapeAlert = false, EscapeAlertRange = 60,
    KillFeed = false, StunNotify = false,
    AntiAFK = false, ShowFPS = true, ShowPing = true,

    -- Killer
    Killer_AutoAtk = false, Killer_AtkDelay = 0.35,
    Killer_KillAll = false,
    Killer_AutoCarry = false, Killer_CarryDelay = 0.4, Killer_HookSpam = 6,
    Killer_AutoStalk = false, Killer_StalkRange = 150,
    MaskedPower = "Cobra",
    InstantInteract = false,

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
}
S = _G.CosmicS

-- ============================================
-- STATE ESP
-- ============================================
ESP = _G.Cosmic_ESP or {
    Survivor = true, Killer = true, Generator = true,
    Pallet = false, Window = false, SCP = false, Distance = 500,
}
_G.Cosmic_ESP = ESP

ESPStatus = _G.Cosmic_ESPStatus or {
    Enabled = false, ShowName = true, ShowDistance = true,
    ShowHealth = false, Radius = 50,
}
_G.Cosmic_ESPStatus = ESPStatus

TeamColors = _G.Cosmic_TeamColors or {
    Killer = Color3.fromRGB(255, 60, 60),
    Survivor = Color3.fromRGB(0, 120, 255),
}
_G.Cosmic_TeamColors = TeamColors

-- ============================================
-- STATE AUTO PARRY
-- ============================================
AutoParry = _G.Cosmic_AutoParry or {
    Enabled = true,
    ParryDistance = 15,
    ParryDelay = 0,
    Cooldown = 1,
    FaceSensitivity = 0.7,
    RequireFacing = true,
    Wiggle = false,
    WiggleSpam = 5,
}
_G.Cosmic_AutoParry = AutoParry

-- ============================================
-- STATE SKILL CHECK (2 MODE)
-- ============================================
SkillCheck = _G.Cosmic_SkillCheck or {
    Enabled = true,
    Mode = "Perfect",
    HideNeedle = false,
    Success = 0,
    Total = 0,
}
_G.Cosmic_SkillCheck = SkillCheck

-- ============================================
-- STATE MOONWALK
-- ============================================
Moonwalk = _G.Cosmic_Moonwalk or {
    Enabled = false,
    ShowButton = false,
    SpamSpeed = 30,
    Intensity = 35,
    SlowSpeed = 13,
    UseSlow = true,
    ButtonLocked = true,
    ButtonPos = UDim2.new(0.65, 0, 0.75, 0),
    LockIconRef = nil,
    GuiInstance = nil,
    Connection = nil,
    ImageId = "rbxassetid://93349170559446",  -- 🖼️ bisa diganti
}
_G.Cosmic_Moonwalk = Moonwalk

-- ============================================
-- STATE GOD MODE
-- ============================================
GodMode = _G.Cosmic_GodMode or { Enabled = false }
_G.Cosmic_GodMode = GodMode

-- ============================================
-- STATE COMBAT (AIMLOCK FALLENS)
-- ============================================
Combat = _G.Cosmic_Combat or {
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
_G.Cosmic_Combat = Combat

-- ============================================
-- FPS / PING CONFIG
-- ============================================
FPSPingConfig = _G.Cosmic_FPSPing or { Size = 1, X = 0, Y = 0 }
_G.Cosmic_FPSPing = FPSPingConfig

_G.ToggleStates = _G.ToggleStates or {}
_G.SliderStates = _G.SliderStates or {}

-- ============================================
-- SOUND TOGGLE
-- ============================================
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

print("✅ [1/20] COSMIC HUB - Base + State loaded")
print("   Skill Check : 2 MODE (Perfect + Instant)")
print("   Moonwalk    : READY")
print("   Combat      : Aimlock Fallens")
print("   Killer      : AutoAttack + KillAll + AutoCarry + AutoStalk")-- ============================================
-- SECTION 2/20 : LOADING SCREEN COSMIC
-- ============================================

local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "CosmicLoading"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 999999
loadingGui.Parent = PlayerGui

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

-- Ring container
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

-- Core
local core = Instance.new("Frame")
core.Size = UDim2.new(0, 80, 0, 80)
core.Position = UDim2.new(0.5, -40, 0.5, -40)
core.BackgroundColor3 = C.ACC2
core.Parent = ringContainer

local coreCorner = Instance.new("UICorner")
coreCorner.CornerRadius = UDim.new(1, 0)
coreCorner.Parent = core

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

-- Welcome title
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

-- Subtitle
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

-- Tagline
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

-- Progress bar
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 420, 0, 6)
progressBar.Position = UDim2.new(0.5, -210, 0.9, 20)
progressBar.BackgroundColor3 = Color3.fromRGB(30, 15, 50)
progressBar.BorderSizePixel = 0
progressBar.Parent = bg

local pbCorner = Instance.new("UICorner")
pbCorner.CornerRadius = UDim.new(0, 3)
pbCorner.Parent = progressBar

local pbStroke = Instance.new("UIStroke")
pbStroke.Color = C.ACC2
pbStroke.Thickness = 1.5
pbStroke.Transparency = 0.3
pbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
pbStroke.Parent = progressBar

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = C.ACC2
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBar

local pfCorner = Instance.new("UICorner")
pfCorner.CornerRadius = UDim.new(0, 3)
pfCorner.Parent = progressFill

local progGrad = Instance.new("UIGradient")
progGrad.Color = ColorSequence.new(C.ACC, C.ACC2, C.ACC3)
progGrad.Parent = progressFill

-- Animation loop
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

-- Progress animation
task.spawn(function()
    for i = 0, 1, 0.02 do
        if not bg.Parent then break end
        progressFill.Size = UDim2.new(i, 0, 1, 0)
        task.wait(0.03)
    end
end)

-- Fade out
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

print("✅ [2/20] COSMIC HUB - Loading Screen loaded")-- ============================================
-- SECTION 3/20 : FUNGSI DASAR
-- ============================================

-- ============================================
-- FIRE CONFIG (LIST + WARNA)
-- ============================================
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

EightBitList = { "Royal Crown" }
EightBitIds = { ["Royal Crown"] = 10138606900 }

KorbloxList = { "Pencil" }
KorbloxIds = { ["Pencil"] = 902942093 }

FireBeamList = {
    "Classic Beam", "Laser Beam", "Rainbow Beam",
    "Fire Wings", "Fire Halo", "Fire Hands",
    "Fire Foot Trail", "Fire Body Aura", "Fire Mouth", "Fire Eyes Glow",
}

-- ============================================
-- FUNGSI FIRE
-- ============================================
function clearFire()
    if not LocalPlayer.Character then return end
    local head = LocalPlayer.Character:FindFirstChild("Head")
    if not head then return end
    for _, obj in pairs(head:GetChildren()) do
        if obj.Name == "CosmicFire" or obj.Name == "CosmicSmoke" or obj.Name == "CosmicSparkles" then
            obj:Destroy()
        end
    end
end

function applyFire()
    clearFire()
    if not S.FireOn then return end
    local char = LocalPlayer.Character
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

function clearFireFeet()
    if not LocalPlayer.Character then return end
    local lLeg = LocalPlayer.Character:FindFirstChild("Left Leg") or LocalPlayer.Character:FindFirstChild("LeftUpperLeg")
    local rLeg = LocalPlayer.Character:FindFirstChild("Right Leg") or LocalPlayer.Character:FindFirstChild("RightUpperLeg")
    for _, leg in pairs({lLeg, rLeg}) do
        if leg then
            for _, obj in pairs(leg:GetChildren()) do
                if obj.Name == "CosmicFootFire" then obj:Destroy() end
            end
        end
    end
end

function applyFireFeet()
    clearFireFeet()
    if not S.FireFeetOn then return end
    local char = LocalPlayer.Character
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

-- Rainbow fire loop
task.spawn(function()
    while task.wait(0.4) do
        if S.FireOn and LocalPlayer.Character then
            local head = LocalPlayer.Character:FindFirstChild("Head")
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
    end
end)

-- ============================================
-- FUNGSI 8-BIT ROYAL CROWN
-- ============================================
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

    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    size = size or S.EightBitSize or 1.24
    height = height or S.EightBitHeight or 0.88

    eightBitPart = Instance.new("Part")
    eightBitPart.Name = "Cosmic8Bit"
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

-- ============================================
-- FUNGSI KORBLOX PENCIL
-- ============================================
korbloxParts = {}
korbloxOrigData = {}

function clearKorblox()
    for _, part in pairs(korbloxParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    korbloxParts = {}

    local char = LocalPlayer.Character
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

    local char = LocalPlayer.Character
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
    korbloxPart.Name = "CosmicKorblox"
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

-- ============================================
-- FUNGSI HEADLESS
-- ============================================
function applyHeadless(s)
    local char = LocalPlayer.Character
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
        if S.Headless and LocalPlayer.Character then
            local head = LocalPlayer.Character:FindFirstChild("Head")
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

-- ============================================
-- FUNGSI FIRE BEAM
-- ============================================
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

    local char = LocalPlayer.Character
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

-- ============================================
-- FUNGSI HD VISUAL
-- ============================================
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

-- ============================================
-- FUNGSI MISC
-- ============================================
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
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, randomServer, LocalPlayer)
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
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end

-- ============================================
-- FUNGSI FPS + PING
-- ============================================
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
    fpsPingGui.Parent = PlayerGui

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

    local frCorner = Instance.new("UICorner")
    frCorner.CornerRadius = UDim.new(0, 8)
    frCorner.Parent = frame

    local frStroke = Instance.new("UIStroke")
    frStroke.Color = C.ACC
    frStroke.Thickness = 1.5
    frStroke.Transparency = 0.3
    frStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    frStroke.Parent = frame

    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Name = "FPSLabel"
    fpsLabel.Size = UDim2.new(1, -8, 0, 18 * sizeScale)
    fpsLabel.Position = UDim2.new(0, 4, 0, 3)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS: 0"
    fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    fpsLabel.TextSize = math.floor(11 * sizeScale)
    fpsLabel.Font = Enum.Font.GothamBold
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.Parent = frame

    local fpsGrad = Instance.new("UIGradient")
    fpsGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 120)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(120, 60, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 230, 255)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 80, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 120)),
    })
    fpsGrad.Parent = fpsLabel

    local pingLabel = Instance.new("TextLabel")
    pingLabel.Name = "PingLabel"
    pingLabel.Size = UDim2.new(1, -8, 0, 18 * sizeScale)
    pingLabel.Position = UDim2.new(0, 4, 0, 21 * sizeScale)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text = "Ping: 0 ms"
    pingLabel.TextColor3 = Color3.fromRGB(0, 230, 255)
    pingLabel.TextSize = math.floor(11 * sizeScale)
    pingLabel.Font = Enum.Font.GothamBold
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left
    pingLabel.Parent = frame

    local pingGrad = Instance.new("UIGradient")
    pingGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 230, 255)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 80, 200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 60, 255)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 255, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 230, 255)),
    })
    pingGrad.Parent = pingLabel
end

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

print("✅ [3/20] COSMIC HUB - Fungsi dasar loaded")
print("   Fire, FireFeet, 8Bit, Korblox, Headless")
print("   FireBeam, HD Visual, Anti-AFK, Server Hop")
print("   FPS/Ping Counter (NO STUTTER)")-- ============================================
-- SECTION 4/20 : ESP SYSTEM
-- ============================================

ESPObjects = {}
StatusESP = {}
CachedSCP = {}
Cached = { Generators = {}, Windows = {}, Pallets = {} }
GeneratorColor = Color3.fromRGB(255, 170, 0)
PalletColor = Color3.fromRGB(74, 255, 181)
WindowColor = Color3.fromRGB(74, 255, 181)
SCPColor = Color3.fromRGB(255, 0, 0)

-- ============================================
-- CACHE SYSTEM
-- ============================================
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

-- ============================================
-- CREATE / REMOVE ESP
-- ============================================
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

-- ============================================
-- STATUS ESP (NAME / DIST / HP)
-- ============================================
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

-- ============================================
-- GENERATOR ESP
-- ============================================
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

-- ============================================
-- MAP ESP (PALLET / WINDOW)
-- ============================================
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

-- ============================================
-- SCP ESP
-- ============================================
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

-- ============================================
-- EXPORT KE _G
-- ============================================
_G.Cosmic_createESP = createESP
_G.Cosmic_removeESP = removeESP
_G.Cosmic_createStatusESP = createStatusESP
_G.Cosmic_UpdateGenerator = UpdateGenerator
_G.Cosmic_UpdateMapESP = UpdateMapESP
_G.Cosmic_UpdateSCPEsp = UpdateSCPEsp

print("✅ [4/20] COSMIC HUB - ESP System loaded")-- ============================================
-- SECTION 5/20 : AUTO PARRY + SKILLCHECK 2 MODE
-- ============================================

-- ============================================
-- AUTO PARRY
-- ============================================
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
    local current = PlayerGui
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

function pressParryButton()
    if UserInputService.TouchEnabled then
        local btn = GetParryButton()
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = GuiService:GetGuiInset()
            local x = pos.X + size.X / 2 + inset.X
            local y = pos.Y + size.Y / 2 + inset.Y
            VirtualInputManager:SendTouchEvent(8823, 0, x, y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8823, 2, x, y)
        end
    else
        pressRightClick()
    end
end

function shouldBlockParry()
    local char = LocalPlayer.Character
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

    local myChar = LocalPlayer.Character
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
        if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
            hookKiller(p.Character)
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if AutoParry.Enabled then scanKillers() end
    end
end)

-- ============================================
-- AUTO SKILL CHECK (2 MODE)
-- ============================================
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
    local current = PlayerGui
    for segment in string.gmatch(ActionPath, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

function TriggerMobileButton()
    local b = GetActionTarget()
    if b and b:IsA("GuiObject") then
        local p, s, i = b.AbsolutePosition, b.AbsoluteSize, GuiService:GetGuiInset()
        local cx, cy = p.X + (s.X / 2) + i.X, p.Y + (s.Y / 2) + i.Y
        pcall(function()
            VirtualInputManager:SendTouchEvent(TouchID, 0, cx, cy)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(TouchID, 2, cx, cy)
        end)
    end
end

function triggerSkillCheckInput()
    if UserInputService.TouchEnabled then
        TriggerMobileButton()
    else
        pressSpace()
    end
end

function startSkillCheck()
    if SkillHeartbeat then SkillHeartbeat:Disconnect() end

    SkillHeartbeat = RunService.RenderStepped:Connect(function()
        if not SkillCheck.Enabled or busy then return end

        local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
        if not prompt then return end

        local check = prompt:FindFirstChild("Check")
        if not check or not check.Visible then return end

        local line = check:FindFirstChild("Line")
        local goal = check:FindFirstChild("Goal")
        if not line or not goal then return end

        local gr = goal.Rotation % 360

        -- ============ MODE INSTANT ============
        if SkillCheck.Mode == "Instant" then
            local targetRot = (gr + 109) % 360
            pcall(function() line.Rotation = targetRot end)

            if SkillCheck.HideNeedle then
                pcall(function() line.Visible = false end)
            end

            busy = true
            task.spawn(function()
                triggerSkillCheckInput()
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

        -- ============ MODE PERFECT ============
        local lr = line.Rotation % 360
        local startRange = (gr + 102) % 360
        local endRange = (gr + 116) % 360

        local success =
            (startRange > endRange and (lr >= startRange or lr <= endRange))
            or (lr >= startRange and lr <= endRange)

        if success then
            busy = true
            task.spawn(function()
                triggerSkillCheckInput()
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

-- ============================================
-- EXPORT KE _G
-- ============================================
_G.Cosmic_scanKillers = scanKillers
_G.Cosmic_startSkillCheck = startSkillCheck
_G.Cosmic_hookKiller = hookKiller
_G.Cosmic_doParry = doParry

print("✅ [5/20] COSMIC HUB - Auto Parry + SkillCheck 2 Mode loaded")-- ============================================
-- SECTION 6/20 : MOONWALK LOGIC + BUTTON
-- ============================================

-- ============================================
-- MOONWALK LOGIC
-- ============================================
function startMoonwalk()
    if Moonwalk.Connection then return end

    Moonwalk.Connection = RunService.RenderStepped:Connect(function()
        if not Moonwalk.Enabled then return end
        if isDowned() then return end
        if ParryActive then return end

        local char = LocalPlayer.Character
        if not char or not char.Parent then return end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp      = char:FindFirstChild("HumanoidRootPart")
        local cam      = workspace.CurrentCamera

        if not humanoid or not hrp or not cam then return end

        if Moonwalk.UseSlow and humanoid.WalkSpeed ~= Moonwalk.SlowSpeed then
            humanoid.WalkSpeed = Moonwalk.SlowSpeed
        end

        local look = cam.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)

        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit

            local baseCF = CFrame.new(hrp.Position, hrp.Position + flatLook)
            local angle  = math.sin(tick() * Moonwalk.SpamSpeed) * Moonwalk.Intensity

            hrp.CFrame = baseCF * CFrame.Angles(0, math.rad(angle), 0)
            humanoid:Move(Vector3.new(0, 0, 1), true)
        end
    end)
end

function stopMoonwalk()
    if Moonwalk.Connection then
        Moonwalk.Connection:Disconnect()
        Moonwalk.Connection = nil
    end
end

-- ============================================
-- MOONWALK BUTTON
-- ============================================
function createMoonwalkButton()
    if not PlayerGui or not PlayerGui.Parent then return end
    if Moonwalk.GuiInstance then Moonwalk.GuiInstance:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "CosmicMoonwalk"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = PlayerGui

    local btn = Instance.new("ImageButton")
    btn.Name = "ToggleButton"
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = Moonwalk.ButtonPos
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.9
    btn.Image = Moonwalk.ImageId
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

    -- 🔒 Icon lock
    local lockIcon = Instance.new("TextLabel")
    lockIcon.Size = UDim2.new(0, 14, 0, 14)
    lockIcon.Position = UDim2.new(1, -16, 0, 2)
    lockIcon.BackgroundTransparency = 1
    lockIcon.Text = "🔒"
    lockIcon.TextColor3 = Color3.fromRGB(255, 80, 80)
    lockIcon.TextScaled = true
    lockIcon.Font = Enum.Font.GothamBold
    lockIcon.Visible = Moonwalk.ButtonLocked
    lockIcon.Parent = btn

    Moonwalk.LockIconRef = lockIcon

    -- DRAG SYSTEM
    local dragging = false
    local dragInput, dragStart, startPos
    local wasDragged = false

    btn.InputBegan:Connect(function(input)
        if Moonwalk.ButtonLocked then return end

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            wasDragged = false
            dragStart = input.Position
            startPos = btn.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    btn.InputChanged:Connect(function(input)
        if Moonwalk.ButtonLocked then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Moonwalk.ButtonLocked then return end
        if not dragging then return end
        if input ~= dragInput then return end

        local delta = input.Position - dragStart

        if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
            wasDragged = true
        end

        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )

        btn.Position = newPos
        Moonwalk.ButtonPos = newPos
    end)

    -- TOGGLE
    btn.MouseButton1Click:Connect(function()
        if wasDragged then return end

        Moonwalk.Enabled = not Moonwalk.Enabled

        local hum = getHumanoid()

        if Moonwalk.Enabled then
            stroke.Color = Color3.fromRGB(170, 0, 255)

            if not Moonwalk.Connection then
                startMoonwalk()
            end
        else
            stroke.Color = Color3.fromRGB(255, 255, 255)

            if hum then
                hum.WalkSpeed = 16
            end
        end
    end)

    Moonwalk.GuiInstance = gui
end

function removeMoonwalkButton()
    if Moonwalk.GuiInstance then
        Moonwalk.GuiInstance:Destroy()
        Moonwalk.GuiInstance = nil
        Moonwalk.LockIconRef = nil
    end
end

-- ============================================
-- EXPORT KE _G
-- ============================================
_G.Cosmic_startMoonwalk = startMoonwalk
_G.Cosmic_stopMoonwalk = stopMoonwalk
_G.Cosmic_createMoonwalkButton = createMoonwalkButton
_G.Cosmic_removeMoonwalkButton = removeMoonwalkButton

print("✅ [6/20] COSMIC HUB - Moonwalk Logic + Button loaded")-- ============================================
-- SECTION 7/20 : COMBAT / AIMLOCK FALLENS
-- ============================================

RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist

function isVisible(part)
    if not Combat.VisibilityCheck and not Combat.WallCheck then return true end
    local cam = workspace.CurrentCamera
    if not cam then return true end
    RayParams.FilterDescendantsInstances = { LocalPlayer.Character }
    local origin = cam.CFrame.Position
    local direction = (part.Position - origin)
    local result = workspace:Raycast(origin, direction, RayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

-- ============================================
-- FOV CIRCLE
-- ============================================
fovGui = nil
function createFOVCircle()
    if fovGui then fovGui:Destroy(); fovGui = nil end
    fovGui = Instance.new("ScreenGui")
    fovGui.Name = "CosmicFOV"
    fovGui.ResetOnSpawn = false
    fovGui.IgnoreGuiInset = true
    fovGui.Parent = PlayerGui
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

-- ============================================
-- INPUT DETECTION (HOLD TO AIM)
-- ============================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if not Combat.AimlockEnabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Combat.AttackHeld = true
    end
    if input.UserInputType == Enum.UserInputType.Touch then
        Combat.AttackHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Combat.AttackHeld = false
    end
    if input.UserInputType == Enum.UserInputType.Touch then
        Combat.AttackHeld = false
    end
end)

-- Mobile attack button hook
task.spawn(function()
    local function getAttackBtn()
        local paths = {
            "Survivor-mob.Controls.Gui-mob",
            "Slasher-mob.Controls.attack",
            "Masked-mob.Controls.attack",
            "Killer-mob.Controls.attack",
        }
        for _, path in ipairs(paths) do
            local cur = PlayerGui
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

-- ============================================
-- MAIN AIMLOCK LOOP
-- ============================================
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
            if p ~= LocalPlayer and p.Character then
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

-- ============================================
-- HITBOX SYSTEM
-- ============================================
hitboxCache = {}

task.spawn(function()
    while task.wait(0.5) do
        local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name or ""
        local enabled = false
        if Combat.HitboxSurvivor and myTeam == "Survivors" then enabled = true end
        if Combat.HitboxKiller and myTeam == "Killer" then enabled = true end
        if enabled then
            local targetTeam = (myTeam == "Survivors") and "Killer" or "Survivors"
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == targetTeam then
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

-- ============================================
-- GOD MODE LOOP
-- ============================================
task.spawn(function()
    while task.wait(0.1) do
        if not GodMode.Enabled then continue end
        if not LocalPlayer.Character then continue end
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
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
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, v in pairs(hrp:GetChildren()) do
                if v:IsA("WeldConstraint") or v:IsA("Weld") or v:IsA("Motor6D") then
                    local part1 = v.Part1 or v.Part0
                    if part1 and not part1:IsDescendantOf(LocalPlayer.Character) then
                        v:Destroy()
                    end
                end
            end
        end
    end
end)

print("✅ [7/20] COSMIC HUB - Combat / Aimlock Fallens loaded")
print("   Hold to Aim + Trigger Bot + Hitbox + God Mode")-- ============================================
-- SECTION 8/20 : AUTOCARRY (AUTO HOOK) + AUTO STALK
-- ============================================

-- ============================================
-- GET DOWNED SURVIVOR
-- ============================================
function GetDowned()
    local root = getRoot()
    if not root then return nil end

    local best, dist = nil, math.huge

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Survivors" then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")

            if hum and hrp and hum.Health > 0 and hum.Health <= hum.MaxHealth * 0.25 then
                local hooked = p.Character:GetAttribute("Hooked")
                    or p.Character:GetAttribute("IsCarried")
                    or p.Character:GetAttribute("IsHooked")
                if not hooked then
                    local d = (hrp.Position - root.Position).Magnitude
                    if d < dist then
                        dist = d
                        best = p.Character
                    end
                end
            end
        end
    end

    return best
end

-- ============================================
-- GET HOOK POINT
-- ============================================
function GetHook()
    local root = getRoot()
    if not root then return nil end

    local bestHook = nil
    local shortestDistance = math.huge

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

-- ============================================
-- AUTO CARRY LOOP
-- ============================================
KillerBusy = false
lastCarry = 0

task.spawn(function()
    while task.wait(0.2) do
        if not S.Killer_AutoCarry then continue end
        if KillerBusy then continue end
        if tick() - lastCarry < (S.Killer_CarryDelay or 0.4) then continue end

        local myChar = LocalPlayer.Character
        if not myChar then continue end
        local myHum = myChar:FindFirstChildOfClass("Humanoid")
        if not myHum or myHum.Health <= 0 then continue end

        local isCarried = myChar:GetAttribute("IsCarried")
            or myChar:GetAttribute("IsCarrying")
            or myChar:GetAttribute("Hooked")
            or myChar:GetAttribute("Hook")
        if isCarried then continue end

        local target = GetDowned()
        local root = getRoot()

        if target and root then
            KillerBusy = true
            lastCarry = tick()

            task.spawn(function()
                local tRoot = target:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    -- TP ke survivor down
                    pcall(function()
                        root.CFrame = tRoot.CFrame * CFrame.new(0, 3, -2)
                    end)
                    task.wait(0.4)

                    -- Carry event
                    local carryEvent = ReplicatedStorage:FindFirstChild("Remotes")
                        and ReplicatedStorage.Remotes:FindFirstChild("Carry")
                        and ReplicatedStorage.Remotes.Carry:FindFirstChild("CarrySurvivorEvent")
                    if carryEvent then
                        for i = 1, 4 do
                            pcall(function()
                                carryEvent:FireServer(target)
                            end)
                            task.wait(0.2)
                        end
                    end

                    task.wait(0.6)

                    -- Cari hook + hook
                    local hook = GetHook()
                    if hook then
                        pcall(function()
                            root.CFrame = hook.CFrame * CFrame.new(0, 4, -3)
                        end)
                        task.wait(0.7)

                        local hookEvent = ReplicatedStorage:FindFirstChild("Remotes")
                            and ReplicatedStorage.Remotes:FindFirstChild("Carry")
                            and ReplicatedStorage.Remotes.Carry:FindFirstChild("HookEvent")
                        if hookEvent then
                            local hookSpam = S.Killer_HookSpam or 6
                            for i = 1, hookSpam do
                                pcall(function()
                                    hookEvent:FireServer(hook)
                                end)
                                task.wait(0.15)
                            end
                        end
                    end
                end

                task.delay(2, function() KillerBusy = false end)
            end)
        end
    end
end)

-- ============================================
-- GET CLOSEST SURVIVOR (UNTUK AUTO STALK)
-- ============================================
function GetClosestSurvivorForStalk()
    local root = getRoot()
    if not root then return nil end

    local closest, shortest = nil, math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Team and plr.Team.Name == "Survivors" then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")

            if hum and hrp and hum.Health > 30 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist <= (S.Killer_StalkRange or 150) and dist < shortest then
                    shortest = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

-- ============================================
-- AUTO STALK LOOP
-- ============================================
StalkConnection = nil

function startAutoStalk()
    if StalkConnection then return end

    StalkConnection = RunService.Heartbeat:Connect(function()
        if not S.Killer_AutoStalk then return end

        local target = GetClosestSurvivorForStalk()
        if not target or not target.Character then return end

        local stalkEvent = ReplicatedStorage:FindFirstChild("Remotes", true)
                          and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
                          and ReplicatedStorage.Remotes.Killers:FindFirstChild("Stalker", true)
                          and ReplicatedStorage.Remotes.Killers.Stalker:FindFirstChild("StartStalking")

        if stalkEvent then
            pcall(function()
                stalkEvent:FireServer(target)
            end)
        end
    end)
end

function stopAutoStalk()
    if StalkConnection then
        StalkConnection:Disconnect()
        StalkConnection = nil
    end
end

-- ============================================
-- EXPORT KE _G
-- ============================================
_G.Cosmic_GetDowned = GetDowned
_G.Cosmic_GetHook = GetHook
_G.Cosmic_startAutoStalk = startAutoStalk
_G.Cosmic_stopAutoStalk = stopAutoStalk

print("✅ [8/20] COSMIC HUB - AutoCarry + Auto Stalk loaded")
print("   AutoCarry: TP + Carry + Hook")
print("   Auto Stalk: Auto stalk survivor")-- ============================================
-- SECTION 9/20 : KILLER LOGIC + FITUR AKTIF
-- ============================================

-- ============================================
-- KILLER: AUTO ATTACK
-- ============================================
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

-- ============================================
-- KILLER: KILL ALL (AUTO CHASE + ATTACK)
-- ============================================
function GetNearestAliveSurvivor()
    local root = getRoot()
    if not root then return nil end

    local closest, shortest = nil, math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Team and plr.Team.Name == "Survivors" then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")

            if hum and hrp and hum.Health > 30 then
                local hooked = plr.Character:GetAttribute("Hooked")
                    or plr.Character:GetAttribute("IsCarried")
                    or plr.Character:GetAttribute("IsHooked")
                if not hooked and hrp.Position.Y <= 30 then
                    local d = (hrp.Position - root.Position).Magnitude
                    if d < shortest then
                        shortest = d
                        closest = plr.Character
                    end
                end
            end
        end
    end

    return closest
end

task.spawn(function()
    while task.wait(0.4) do
        if S.Killer_KillAll and LocalPlayer.Character then
            local myHum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not myHum or myHum.Health <= 0 then continue end

            local isCarried = LocalPlayer.Character:GetAttribute("IsCarried")
                or LocalPlayer.Character:GetAttribute("IsCarrying")
                or LocalPlayer.Character:GetAttribute("Hooked")
                or LocalPlayer.Character:GetAttribute("Hook")
            if isCarried then continue end

            local target = GetNearestAliveSurvivor()
            local root = getRoot()

            if target and root then
                local targetHRP = target:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    local velocity = targetHRP.AssemblyLinearVelocity
                    local predict = velocity * 0.15
                    local targetPos = targetHRP.Position + predict
                    local behind = targetHRP.CFrame.LookVector * -3

                    pcall(function()
                        root.CFrame = CFrame.new(targetPos + behind, targetPos)
                        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
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
    end
end)

-- ============================================
-- INSTANT INTERACT (PROXIMITY PROMPT)
-- ============================================
task.spawn(function()
    while task.wait(0.3) do
        if S.InstantInteract and LocalPlayer.Character then
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

-- ============================================
-- SPEED HACK
-- ============================================
task.spawn(function()
    while task.wait(0.2) do
        if S.SpeedHack and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= S.SpeedHackVal then
                hum.WalkSpeed = S.SpeedHackVal
            end
        end
    end
end)

-- ============================================
-- WALK SPEED
-- ============================================
task.spawn(function()
    while task.wait(0.2) do
        if S.WalkSpeed and not S.SpeedHack and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local target = S.WalkSpeedVal + (S.WalkSpeedBoost or 0)
                if hum.WalkSpeed ~= target then
                    hum.WalkSpeed = target
                end
            end
        end
    end
end)

-- ============================================
-- ANTI-AFK LOOP
-- ============================================
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

-- ============================================
-- SAFE ZONE
-- ============================================
task.spawn(function()
    while task.wait(0.5) do
        if S.SafeZone and LocalPlayer.Character then
            local myRoot = getRoot()
            if myRoot then
                local nearKiller = math.huge
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
                        local krp = p.Character:FindFirstChild("HumanoidRootPart")
                        if krp then
                            local d = (krp.Position - myRoot.Position).Magnitude
                            if d < nearKiller then nearKiller = d end
                        end
                    end
                end
                if nearKiller < 50 then
                    local warn = PlayerGui:FindFirstChild("CosmicWarn")
                    if not warn then
                        warn = Instance.new("Frame")
                        warn.Name = "CosmicWarn"
                        warn.Size = UDim2.new(1, 0, 0, 6)
                        warn.Position = UDim2.new(0, 0, 0, 0)
                        warn.BackgroundColor3 = Color3.fromRGB(120, 60, 255)
                        warn.BorderSizePixel = 0
                        warn.Parent = PlayerGui
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

-- ============================================
-- ESCAPE ALERT
-- ============================================
task.spawn(function()
    while task.wait(0.5) do
        if S.EscapeAlert and LocalPlayer.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
                        local krp = p.Character:FindFirstChild("HumanoidRootPart")
                        if krp and (krp.Position - myRoot.Position).Magnitude <= S.EscapeAlertRange then
                            local al = PlayerGui:FindFirstChild("CosmicAlert")
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
                                al.Parent = PlayerGui
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

-- ============================================
-- KILL FEED
-- ============================================
killFeedGui = Instance.new("ScreenGui")
killFeedGui.Name = "CosmicKillFeed"
killFeedGui.ResetOnSpawn = false
killFeedGui.IgnoreGuiInset = true
killFeedGui.Parent = PlayerGui

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
    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 6)
    entryCorner.Parent = entry
    local entryStroke = Instance.new("UIStroke")
    entryStroke.Color = C.ACC
    entryStroke.Thickness = 1
    entryStroke.Transparency = 0.5
    entryStroke.Parent = entry

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
        TweenService:Create(entry, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(lbl, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
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

-- ============================================
-- STUN NOTIFY
-- ============================================
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
            if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
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

-- ============================================
-- MAIN ESP LOOP
-- ============================================
local lastESPUpdate = 0

RunService.Heartbeat:Connect(function()
    local root = getRoot()
    if not root then return end

    local now = tick()
    if now - lastESPUpdate >= 0.1 then
        lastESPUpdate = now

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
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
    end
end)

-- ============================================
-- NO CLIP CAMERA
-- ============================================
task.spawn(function()
    while task.wait(0.2) do
        local cam = workspace.CurrentCamera
        if cam then
            cam.CanCollide = not S.NoClipCamera
        end
    end
end)

print("✅ [9/20] COSMIC HUB - Killer + Fitur Aktif loaded")
print("   Killer: AutoAttack, KillAll")
print("   Active: InstantInteract, SpeedHack, AntiAFK")
print("   HUD: SafeZone, EscapeAlert, KillFeed, StunNotify")
print("   ESP: Main Loop")-- ============================================
-- SECTION 10/20 : VISUAL FUNCTIONS
-- ============================================

-- ============================================
-- ORIGINAL LIGHTING (BUAT RESTORE)
-- ============================================
origLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
}

-- ============================================
-- FULLBRIGHT
-- ============================================
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

-- ============================================
-- NO FOG
-- ============================================
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

-- ============================================
-- SKY
-- ============================================
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

-- ============================================
-- FOV
-- ============================================
function applyFOV()
    local cam = workspace.CurrentCamera
    if cam then
        cam.FieldOfView = S.FOVEnabled and S.FOV or 70
    end
end

-- ============================================
-- ULTRA HD
-- ============================================
function applyUltraHD()
    if S.UltraHD then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
        end)
        Lighting.GlobalShadows = true
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        if not _G.CosmicHD then
            _G.CosmicHD = Instance.new("ColorCorrectionEffect")
            _G.CosmicHD.Parent = Lighting
        end
        _G.CosmicHD.Contrast = 0.2
        _G.CosmicHD.Saturation = 0.15
    else
        if _G.CosmicHD then
            _G.CosmicHD:Destroy()
            _G.CosmicHD = nil
        end
    end
end

-- ============================================
-- CONTRAST BOOST
-- ============================================
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

-- ============================================
-- HD BOOST / SHADER / SKY
-- ============================================
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

-- ============================================
-- TRAIL
-- ============================================
trailFireObj = nil
function applyTrail(enable, color)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if trailFireObj then
        trailFireObj:Destroy()
        trailFireObj = nil
    end
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
    fire.Color = color or Color3.fromRGB(120, 60, 255)
    fire.SecondaryColor = Color3.fromRGB(0, 230, 255)
    fire.Parent = trailFireObj

    local spark = Instance.new("Sparkles")
    spark.SparkleColor = color or Color3.fromRGB(0, 230, 255)
    spark.SparkleSize = 2
    spark.Parent = trailFireObj
end

-- ============================================
-- AURA
-- ============================================
auraObj = nil
function applyAura(enable, color)
    local char = LocalPlayer.Character
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

-- ============================================
-- KILL EFFECT
-- ============================================
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

task.spawn(function()
    while task.wait(0.8) do
        if S.KillEffect then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
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

-- ============================================
-- CROSSHAIR
-- ============================================
crosshairGui = nil
function applyCrosshair(enable, color, size)
    if crosshairGui then
        crosshairGui:Destroy()
        crosshairGui = nil
    end
    if not enable then return end

    crosshairGui = Instance.new("ScreenGui")
    crosshairGui.Name = "CosmicCrosshair"
    crosshairGui.ResetOnSpawn = false
    crosshairGui.IgnoreGuiInset = true
    crosshairGui.Parent = PlayerGui

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

-- ============================================
-- ZOOM OUT
-- ============================================
function applyZoomOut(enable, val)
    if enable then
        LocalPlayer.CameraMaxZoomDistance = val or 500
    else
        LocalPlayer.CameraMaxZoomDistance = 128
    end
end

-- ============================================
-- FLY
-- ============================================
flyBV, flyBG, flyConn = nil, nil, nil
function startFly()
    if flyConn then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    pcall(function() hrp:SetNetworkOwner(LocalPlayer) end)

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
        local char = LocalPlayer.Character
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

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
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

-- ============================================
-- TELEPORT FINISH
-- ============================================
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

-- ============================================
-- EXPORT KE _G
-- ============================================
_G.Cosmic_applyFullbright = applyFullbright
_G.Cosmic_applyNoFog = applyNoFog
_G.Cosmic_applySky = applySky
_G.Cosmic_applyFOV = applyFOV
_G.Cosmic_applyUltraHD = applyUltraHD
_G.Cosmic_applyContrast = applyContrast
_G.Cosmic_applyTrail = applyTrail
_G.Cosmic_applyAura = applyAura
_G.Cosmic_applyCrosshair = applyCrosshair
_G.Cosmic_applyZoomOut = applyZoomOut
_G.Cosmic_startFly = startFly
_G.Cosmic_stopFly = stopFly
_G.Cosmic_teleportToFinishLine = teleportToFinishLine
_G.Cosmic_applyHDBoost = applyHDBoost
_G.Cosmic_applyHDShader = applyHDShader
_G.Cosmic_applyHDSky = applyHDSky

print("✅ [10/20] COSMIC HUB - Visual Functions loaded")
print("   Fullbright, NoFog, Sky, FOV, UltraHD, Contrast")
print("   HD Boost / Shader / Sky")
print("   Trail, Aura, KillEffect, Crosshair, ZoomOut, Fly")-- ============================================
-- SECTION 11/20 : TOMBOL COSMIC + WINDOW + TABS
-- ============================================

-- ============================================
-- TOMBOL MENU COSMIC (CUSTOM, BUKAN OBSIDIAN DEFAULT)
-- ============================================
btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(0, 32, 32)
btnContainer.Position = UDim2.new(0, 15, 0.3, 0)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = PlayerGui

local outerGlow = Instance.new("Frame")
outerGlow.Size = UDim2.new(1, 14, 1, 14)
outerGlow.Position = UDim2.new(0, -7, 0, -7)
outerGlow.BackgroundColor3 = Color3.fromRGB(140, 70, 255)
outerGlow.BackgroundTransparency = 0.8
outerGlow.BorderSizePixel = 0
outerGlow.ZIndex = -1
outerGlow.Parent = btnContainer

local outerGlowCorner = Instance.new("UICorner")
outerGlowCorner.CornerRadius = UDim.new(1, 0)
outerGlowCorner.Parent = outerGlow

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

local mainBtnCorner = Instance.new("UICorner")
mainBtnCorner.CornerRadius = UDim.new(1, 0)
mainBtnCorner.Parent = mainBtn

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

local innerGlowCorner = Instance.new("UICorner")
innerGlowCorner.CornerRadius = UDim.new(1, 0)
innerGlowCorner.Parent = innerGlow

-- Animasi ring + glow + pulse
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

-- Partikel orbit
for i = 1, 6 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, 2, 0, 2)
    particle.BorderSizePixel = 0
    particle.ZIndex = 4
    particle.Parent = btnContainer

    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(1, 0)
    pCorner.Parent = particle

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

-- Drag system
local btnDragging = false
local btnDragStart = nil
local btnStartPos = nil
local btnWasDragged = false

btnContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = true
        btnWasDragged = false
        btnDragStart = input.Position
        btnStartPos = btnContainer.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnDragStart
        if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
            btnWasDragged = true
        end
        btnContainer.Position = UDim2.new(
            btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X,
            btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = false
    end
end)

-- ============================================
-- CREATE WINDOW OBSIDIAN
-- ============================================
local Window = Library:CreateWindow({
    Title = "Cosmic Hub",
    Footer = "Auto Parry + SkillCheck + Moonwalk",
    Icon = 93349170559446,
    IconSize = UDim2.fromOffset(40, 40),
    CornerRadius = 20,
    NotifySide = "Right",
    ShowCustomCursor = true,
    ShowMobileButtons = false,
    ToggleKeybind = Enum.KeyCode.LeftControl,
    Size = UDim2.fromOffset(520, 380),
    EnableSidebarResize = false,
    EnableCompacting = true,
    SidebarCompacted = true,
})

-- Hide tombol Obsidian default (biar cuma tombol cosmic)
task.spawn(function()
    task.wait(0.5)
    pcall(function()
        local coreGui = game:GetService("CoreGui")
        for _, obj in pairs(coreGui:GetDescendants()) do
            if obj.Name == "ToggleButton" or obj.Name == "MobileToggle" then
                if obj.Parent and obj.Parent ~= btnContainer then
                    obj.Visible = false
                end
            end
        end
    end)
end)

-- Connect tombol cosmic ke Library:Toggle()
mainBtn.MouseButton1Click:Connect(function()
    if btnWasDragged then
        btnWasDragged = false
        return
    end
    Library:Toggle()
end)

-- ============================================
-- TABS (12 TAB - SEMUA FITUR MASUK)
-- ============================================
local SurvivorTab = Window:AddTab("Survivor", "user")
local KillerTab   = Window:AddTab("Killer", "skull")
local AimbotTab   = Window:AddTab("Aimbot", "crosshair")
local ESPTab      = Window:AddTab("ESP", "eye")
local FireTab     = Window:AddTab("Fire", "flame")
local FireFeetTab = Window:AddTab("Fire Feet", "footprints")
local MoonwalkTab = Window:AddTab("Moonwalk", "music")
local MiscTab     = Window:AddTab("Misc", "sliders-horizontal")
local VisualTab   = Window:AddTab("Visual", "sparkles")
local PlayerTab   = Window:AddTab("Player", "settings-2")
local ExtraTab    = Window:AddTab("Extra", "star")
local UITab       = Window:AddTab("UI Settings", "wrench")

print("✅ [11/20] COSMIC HUB - Tombol Cosmic + Window + 12 Tabs loaded")
print("   Tabs: Survivor, Killer, Aimbot, ESP, Fire, Fire Feet")
print("         Moonwalk, Misc, Visual, Player, Extra, UI Settings")-- ============================================
-- SECTION 12/20 : TAB SURVIVOR
-- ============================================

-- ============================================
-- AUTO PARRY
-- ============================================
local ParryBox = SurvivorTab:AddLeftGroupbox("Auto Parry", "shield")

ParryBox:AddToggle("ParryEnable", {
    Text = "Enable Auto Parry",
    Default = true,
    Callback = function(v)
        AutoParry.Enabled = v
        if v then scanKillers() end
    end
})

ParryBox:AddSlider("ParryDistance", {
    Text = "Parry Distance",
    Default = 15,
    Min = 5,
    Max = 30,
    Rounding = 0,
    Callback = function(v)
        AutoParry.ParryDistance = v
    end
})

ParryBox:AddSlider("FaceSensitivity", {
    Text = "Face Sensitivity",
    Default = 0.7,
    Min = -1,
    Max = 1,
    Rounding = 2,
    Callback = function(v)
        AutoParry.FaceSensitivity = v
        AutoParry.RequireFacing = (v > -1)
    end
})

ParryBox:AddSlider("ParryDebounce", {
    Text = "Parry Debounce",
    Default = 0.2,
    Min = 0.05,
    Max = 1,
    Rounding = 2,
    Callback = function(v)
        PARRY_DEBOUNCE = v
    end
})

-- ============================================
-- AUTO SKILL CHECK (2 MODE)
-- ============================================
local SkillBox = SurvivorTab:AddLeftGroupbox("Auto Skill Check (2 Mode)", "target")

SkillBox:AddToggle("SkillEnable", {
    Text = "Enable Auto Skill Check",
    Default = true,
    Callback = function(v)
        SkillCheck.Enabled = v
        if v then startSkillCheck() end
    end
})

SkillBox:AddDropdown("SkillMode", {
    Text = "Mode",
    Values = {"Perfect", "Instant"},
    Default = "Perfect",
    Multi = false,
    Callback = function(v)
        SkillCheck.Mode = v
    end
})

SkillBox:AddToggle("HideNeedle", {
    Text = "Hide Needle (Instant Only)",
    Default = false,
    Callback = function(v)
        SkillCheck.HideNeedle = v
    end
})

SkillBox:AddDivider()

local StatsLabel = SkillBox:AddLabel("Success: 0 / 0")

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            StatsLabel:SetText(string.format(
                "Success: %d / %d",
                SkillCheck.Success,
                SkillCheck.Total
            ))
        end)
    end
end)

SkillBox:AddButton({
    Text = "Reset Counter",
    Func = function()
        SkillCheck.Success = 0
        SkillCheck.Total = 0
        Library:Notify({
            Title = "Counter direset!",
            Duration = 2
        })
    end
})

-- ============================================
-- GOD MODE
-- ============================================
local GodBox = SurvivorTab:AddLeftGroupbox("God Mode", "shield-check")

GodBox:AddToggle("GodModeEnable", {
    Text = "Enable God Mode",
    Default = false,
    Callback = function(v)
        GodMode.Enabled = v
    end
})

GodBox:AddLabel("Anti Down + Anti Stun + Anti Grab")

-- ============================================
-- PARRY CIRCLE
-- ============================================
local CircleBox = SurvivorTab:AddRightGroupbox("Parry Circle", "circle")

CircleBox:AddToggle("ParryCircleEnable", {
    Text = "Show Parry Circle",
    Default = true,
    Callback = function(v)
        S.ParryCircle = v
    end
})

CircleBox:AddSlider("ParryCircleSize", {
    Text = "Circle Size",
    Default = 12,
    Min = 5,
    Max = 30,
    Rounding = 0,
    Callback = function(v)
        S.ParryCircleSize = v
    end
})

CircleBox:AddLabel("Hijau = aman | Merah = killer dalem")

-- ============================================
-- SUPPORT
-- ============================================
local SupportBox = SurvivorTab:AddRightGroupbox("Support", "heart")

SupportBox:AddToggle("InstantInteract", {
    Text = "Instant Interact",
    Default = false,
    Callback = function(v)
        S.InstantInteract = v
    end
})

SupportBox:AddButton({
    Text = "TP ke Finish Line",
    Func = function()
        teleportToFinishLine()
    end
})

-- ============================================
-- ALERTS
-- ============================================
local AlertBox = SurvivorTab:AddRightGroupbox("Alerts", "bell")

AlertBox:AddToggle("SafeZone", {
    Text = "Safe Zone",
    Default = false,
    Callback = function(v)
        S.SafeZone = v
    end
})

AlertBox:AddToggle("EscapeAlert", {
    Text = "Escape Alert",
    Default = false,
    Callback = function(v)
        S.EscapeAlert = v
    end
})

AlertBox:AddSlider("AlertRange", {
    Text = "Alert Range",
    Default = 60,
    Min = 20,
    Max = 150,
    Rounding = 0,
    Callback = function(v)
        S.EscapeAlertRange = v
    end
})

AlertBox:AddToggle("StunNotify", {
    Text = "Stun Notify",
    Default = false,
    Callback = function(v)
        S.StunNotify = v
    end
})

AlertBox:AddToggle("KillFeed", {
    Text = "Kill Feed",
    Default = false,
    Callback = function(v)
        S.KillFeed = v
    end
})

print("✅ [12/20] COSMIC HUB - Tab Survivor loaded")
print("   Auto Parry, SkillCheck 2 Mode, GodMode")
print("   Parry Circle, Instant Interact, TP, Alerts")-- ============================================
-- SECTION 13/20 : TAB KILLER
-- ============================================

-- ============================================
-- AUTO ATTACK
-- ============================================
local AtkBox = KillerTab:AddLeftGroupbox("Auto Attack", "sword")

AtkBox:AddToggle("KillerAutoAtk", {
    Text = "Killer Auto Attack",
    Default = false,
    Callback = function(v)
        S.Killer_AutoAtk = v
    end
})

AtkBox:AddSlider("KillerAtkDelay", {
    Text = "Attack Delay",
    Default = 0.35,
    Min = 0.1,
    Max = 1,
    Rounding = 2,
    Callback = function(v)
        S.Killer_AtkDelay = v
    end
})

-- ============================================
-- KILL ALL
-- ============================================
local KillAllBox = KillerTab:AddLeftGroupbox("Kill All", "skull")

KillAllBox:AddToggle("KillerKillAll", {
    Text = "Killer Kill All",
    Default = false,
    Callback = function(v)
        S.Killer_KillAll = v
    end
})

KillAllBox:AddLabel("Auto TP ke survivor + attack")

-- ============================================
-- AUTO CARRY (AUTO HOOK)
-- ============================================
local CarryBox = KillerTab:AddLeftGroupbox("Auto Carry (Auto Hook)", "anchor")

CarryBox:AddToggle("KillerAutoCarry", {
    Text = "Enable AutoCarry",
    Default = false,
    Callback = function(v)
        S.Killer_AutoCarry = v
    end
})

CarryBox:AddSlider("CarryDelay", {
    Text = "Carry Delay",
    Default = 0.4,
    Min = 0.1,
    Max = 2,
    Rounding = 2,
    Callback = function(v)
        S.Killer_CarryDelay = v
    end
})

CarryBox:AddSlider("HookSpam", {
    Text = "Hook Spam",
    Default = 6,
    Min = 1,
    Max = 15,
    Rounding = 0,
    Callback = function(v)
        S.Killer_HookSpam = v
    end
})

CarryBox:AddLabel("Auto TP survivor down → carry → hook")

-- ============================================
-- AUTO STALK
-- ============================================
local StalkBox = KillerTab:AddLeftGroupbox("Auto Stalk", "eye")

StalkBox:AddToggle("KillerAutoStalk", {
    Text = "Enable Auto Stalk",
    Default = false,
    Callback = function(v)
        S.Killer_AutoStalk = v
        if v then
            startAutoStalk()
        else
            stopAutoStalk()
        end
    end
})

StalkBox:AddSlider("StalkRange", {
    Text = "Stalk Range",
    Default = 150,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        S.Killer_StalkRange = v
    end
})

-- ============================================
-- MASKED POWER
-- ============================================
local MaskBox = KillerTab:AddRightGroupbox("Masked Power", "drama")

MaskBox:AddDropdown("MaskedPowerSelect", {
    Text = "Select Power",
    Values = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"},
    Default = "Cobra",
    Multi = false,
    Callback = function(v)
        S.MaskedPower = v
    end
})

MaskBox:AddButton({
    Text = "Activate Power",
    Func = function()
        local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
            and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
            and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Activatepower")
        if Event then
            Event:FireServer(S.MaskedPower)
        end
    end
})

MaskBox:AddButton({
    Text = "Deactivate Power",
    Func = function()
        local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
            and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
            and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Deactivatepower")
        if Event then
            Event:FireServer()
        end
    end
})

-- ============================================
-- HITBOX (PINDAH DARI COMBAT)
-- ============================================
local HitboxBox = KillerTab:AddRightGroupbox("Hitbox (Besar)", "box")

HitboxBox:AddToggle("HitboxSurvivor", {
    Text = "Hitbox Survivor Mode",
    Default = false,
    Callback = function(v)
        Combat.HitboxSurvivor = v
    end
})

HitboxBox:AddToggle("HitboxKiller", {
    Text = "Hitbox Killer Mode",
    Default = false,
    Callback = function(v)
        Combat.HitboxKiller = v
    end
})

HitboxBox:AddSlider("HitboxSize", {
    Text = "Hitbox Size",
    Default = 25,
    Min = 10,
    Max = 120,
    Rounding = 0,
    Callback = function(v)
        Combat.HitboxSize = v
    end
})

HitboxBox:AddToggle("HitboxVisible", {
    Text = "Show Hitbox (Visible)",
    Default = false,
    Callback = function(v)
        Combat.HitboxVisible = v
    end
})

HitboxBox:AddLabel("Max 120 (manual ON)")

print("✅ [13/20] COSMIC HUB - Tab Killer loaded")
print("   AutoAttack, KillAll, AutoCarry, AutoStalk")
print("   MaskedPower, Hitbox (2 mode)")-- ============================================
-- SECTION 14/20 : TAB AIMBOT
-- ============================================

-- ============================================
-- AIMBOT UTAMA (HOLD TO AIM)
-- ============================================
local AimBox = AimbotTab:AddLeftGroupbox("Aimbot (Hold to Aim)", "crosshair")

AimBox:AddToggle("AimbotEnable", {
    Text = "Enable Aimbot",
    Default = false,
    Callback = function(v)
        Combat.AimlockEnabled = v
        if not v then
            Combat.AttackHeld = false
            Combat.Holding = false
        end
    end
})

AimBox:AddLabel("Tahan tombol attack = auto nempel")
AimBox:AddLabel("PC: klik kanan | HP: tombol attack")

AimBox:AddDropdown("AimMode", {
    Text = "Aim Mode",
    Values = {"Killer", "Survivor"},
    Default = "Killer",
    Multi = false,
    Callback = function(v)
        Combat.Mode = v
    end
})

AimBox:AddDropdown("AimPart", {
    Text = "Aim Part",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Default = "Head",
    Multi = false,
    Callback = function(v)
        Combat.AimPart = v
    end
})

AimBox:AddSlider("Smoothness", {
    Text = "Smoothness",
    Default = 0.01,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Callback = function(v)
        Combat.Smoothness = v
    end
})

AimBox:AddLabel("0.01 = INSTAN nempel")

AimBox:AddSlider("LockRadius", {
    Text = "Lock Radius (studs)",
    Default = 150,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        Combat.LockRadius = v
    end
})

AimBox:AddSlider("FOVRadius", {
    Text = "FOV Radius (layar)",
    Default = 200,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        Combat.FOVRadius = v
    end
})

AimBox:AddToggle("FOVCircle", {
    Text = "Show FOV Circle",
    Default = false,
    Callback = function(v)
        Combat.FOVCircle = v
    end
})

-- ============================================
-- PREDICTION
-- ============================================
local PredBox = AimbotTab:AddRightGroupbox("Prediction", "trending-up")

PredBox:AddToggle("PredictEnable", {
    Text = "Predict Movement",
    Default = true,
    Callback = function(v)
        Combat.Predict = v
    end
})

PredBox:AddSlider("PredictStrength", {
    Text = "Predict Strength",
    Default = 0.15,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(v)
        Combat.PredictStrength = v
    end
})

-- ============================================
-- VISIBILITY CHECK
-- ============================================
local VisBox = AimbotTab:AddRightGroupbox("Visibility Check", "eye")

VisBox:AddToggle("AntiWallSilent", {
    Text = "Anti-Wall (Silent)",
    Default = false,
    Callback = function(v)
        Combat.VisibilityCheck = v
    end
})

VisBox:AddToggle("AntiWallStrict", {
    Text = "Anti-Wall (Strict)",
    Default = false,
    Callback = function(v)
        Combat.WallCheck = v
    end
})

-- ============================================
-- TRIGGER BOT
-- ============================================
local TriggerBox = AimbotTab:AddRightGroupbox("Trigger Bot", "zap")

TriggerBox:AddToggle("TriggerBotEnable", {
    Text = "Auto Attack saat lock",
    Default = false,
    Callback = function(v)
        Combat.TriggerBotEnabled = v
    end
})

TriggerBox:AddSlider("TriggerDelay", {
    Text = "Trigger Delay",
    Default = 0.05,
    Min = 0.01,
    Max = 0.5,
    Rounding = 2,
    Callback = function(v)
        Combat.TriggerDelay = v
    end
})

-- ============================================
-- INFO
-- ============================================
local InfoBox = AimbotTab:AddRightGroupbox("Info", "info")

InfoBox:AddLabel("🎯 Aimbot = Hold tombol serang")
InfoBox:AddLabel("PC: klik kanan")
InfoBox:AddLabel("HP: tombol attack")
InfoBox:AddDivider()
InfoBox:AddLabel("Smoothness 0.01 = instan")
InfoBox:AddLabel("Smoothness 1.0 = lambat")
InfoBox:AddDivider()
InfoBox:AddLabel("Mode Killer = target killer")
InfoBox:AddLabel("Mode Survivor = target survivor")

print("✅ [14/20] COSMIC HUB - Tab Aimbot loaded")
print("   Hold to Aim + Prediction + Visibility")
print("   Trigger Bot + FOV Circle")-- ============================================
-- SECTION 15/20 : TAB ESP
-- ============================================

-- ============================================
-- PLAYER ESP
-- ============================================
local PlayerESPBox = ESPTab:AddLeftGroupbox("Player ESP", "users")

PlayerESPBox:AddToggle("ESPSurvivor", {
    Text = "ESP Survivor",
    Default = true,
    Callback = function(v)
        ESP.Survivor = v
    end
})

PlayerESPBox:AddColorPicker("SurvivorColor", {
    Default = TeamColors.Survivor,
    Title = "Survivor Color",
    Callback = function(c)
        TeamColors.Survivor = c
    end
})

PlayerESPBox:AddToggle("ESPKiller", {
    Text = "ESP Killer",
    Default = true,
    Callback = function(v)
        ESP.Killer = v
    end
})

PlayerESPBox:AddColorPicker("KillerColor", {
    Default = TeamColors.Killer,
    Title = "Killer Color",
    Callback = function(c)
        TeamColors.Killer = c
    end
})

-- ============================================
-- OBJECT ESP
-- ============================================
local ObjectESPBox = ESPTab:AddLeftGroupbox("Object ESP", "box")

ObjectESPBox:AddToggle("ESPGenerator", {
    Text = "ESP Generator",
    Default = true,
    Callback = function(v)
        ESP.Generator = v
    end
})

ObjectESPBox:AddColorPicker("GeneratorColor", {
    Default = GeneratorColor,
    Title = "Gen Color",
    Callback = function(c)
        GeneratorColor = c
    end
})

ObjectESPBox:AddToggle("ESPPallet", {
    Text = "ESP Pallet",
    Default = false,
    Callback = function(v)
        ESP.Pallet = v
    end
})

ObjectESPBox:AddColorPicker("PalletColor", {
    Default = PalletColor,
    Title = "Pallet Color",
    Callback = function(c)
        PalletColor = c
    end
})

ObjectESPBox:AddToggle("ESPWindow", {
    Text = "ESP Window",
    Default = false,
    Callback = function(v)
        ESP.Window = v
    end
})

ObjectESPBox:AddColorPicker("WindowColor", {
    Default = WindowColor,
    Title = "Window Color",
    Callback = function(c)
        WindowColor = c
    end
})

ObjectESPBox:AddToggle("ESPSCP", {
    Text = "ESP SCP",
    Default = false,
    Callback = function(v)
        ESP.SCP = v
    end
})

ObjectESPBox:AddColorPicker("SCPColor", {
    Default = SCPColor,
    Title = "SCP Color",
    Callback = function(c)
        SCPColor = c
    end
})

-- ============================================
-- ESP DISTANCE
-- ============================================
local DistBox = ESPTab:AddRightGroupbox("ESP Distance", "ruler")

DistBox:AddSlider("ESPDistance", {
    Text = "ESP Radius",
    Default = 500,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        ESP.Distance = v
    end
})

DistBox:AddLabel("Max 500 (default 500)")

-- ============================================
-- STATUS ESP
-- ============================================
local StatusBox = ESPTab:AddRightGroupbox("Status ESP", "user-check")

StatusBox:AddToggle("ESPStatusEnable", {
    Text = "Enable Status ESP",
    Default = false,
    Callback = function(v)
        ESPStatus.Enabled = v
    end
})

StatusBox:AddToggle("ESPStatusName", {
    Text = "Show Name",
    Default = true,
    Callback = function(v)
        ESPStatus.ShowName = v
    end
})

StatusBox:AddToggle("ESPStatusDistance", {
    Text = "Show Distance",
    Default = true,
    Callback = function(v)
        ESPStatus.ShowDistance = v
    end
})

StatusBox:AddToggle("ESPStatusHealth", {
    Text = "Show Health",
    Default = false,
    Callback = function(v)
        ESPStatus.ShowHealth = v
    end
})

StatusBox:AddSlider("ESPStatusRadius", {
    Text = "Status Radius",
    Default = 50,
    Min = 20,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        ESPStatus.Radius = v
    end
})

-- ============================================
-- NAMA MODE
-- ============================================
local NameBox = ESPTab:AddRightGroupbox("Nama Mode", "type")

NameBox:AddDropdown("ESPNameMode", {
    Text = "Name Mode",
    Values = {"Text", "Galaxy"},
    Default = "Text",
    Multi = false,
    Callback = function(v)
        S.ESPNameMode = v
    end
})

NameBox:AddSlider("ESPNameSize", {
    Text = "Name Size",
    Default = 12,
    Min = 8,
    Max = 30,
    Rounding = 0,
    Callback = function(v)
        S.ESPNameSize = v
    end
})

NameBox:AddLabel("Text = biasa")
NameBox:AddLabel("Galaxy = gradient muter")

print("✅ [15/20] COSMIC HUB - Tab ESP loaded")
print("   Player ESP, Object ESP, Distance")
print("   Status ESP, Nama Mode (Text/Galaxy)")-- ============================================
-- SECTION 16/20 : TAB FIRE + FIRE FEET
-- ============================================

-- ============================================
-- TAB FIRE
-- ============================================
local FireBox = FireTab:AddLeftGroupbox("Fire Control", "flame")

FireBox:AddToggle("FireEnable", {
    Text = "Enable Fire",
    Default = false,
    Callback = function(v)
        S.FireOn = v
        applyFire()
    end
})

FireBox:AddSlider("FireSize", {
    Text = "Fire Size",
    Default = 5,
    Min = 1,
    Max = 15,
    Rounding = 0,
    Callback = function(v)
        S.FireSize = v
        applyFire()
    end
})

-- ============================================
-- FIRE LIST (60 VARIAN)
-- ============================================
local FireListBox = FireTab:AddRightGroupbox("Pilih Efek Fire (60)", "list")

FireListBox:AddLabel("Klik efek untuk ganti")

local fireButtons = {}

for i, fireName in ipairs(FireList) do
    local btn = FireListBox:AddButton({
        Text = "🔥 " .. fireName,
        Func = function()
            S.FireType = fireName
            applyFire()

            -- Reset semua warna button
            for _, data in pairs(fireButtons) do
                if data.btn and data.btn.SetTextColor then
                    pcall(function() data.btn:SetTextColor(Color3.fromRGB(240, 240, 255)) end)
                end
            end

            -- Highlight yang aktif
            local data = fireButtons[fireName]
            if data and data.btn and data.btn.SetTextColor then
                pcall(function() data.btn:SetTextColor(Color3.fromRGB(170, 0, 255)) end)
            end
        end
    })

    fireButtons[fireName] = { btn = btn }
end

-- ============================================
-- TAB FIRE FEET
-- ============================================
local FeetBox = FireFeetTab:AddLeftGroupbox("Fire Feet Control", "footprints")

FeetBox:AddToggle("FireFeetEnable", {
    Text = "Enable Fire Feet",
    Default = false,
    Callback = function(v)
        S.FireFeetOn = v
        applyFireFeet()
    end
})

-- ============================================
-- FIRE FEET LIST (20 VARIAN)
-- ============================================
local FeetListBox = FireFeetTab:AddRightGroupbox("Pilih Efek Fire Feet (20)", "list")

FeetListBox:AddLabel("Klik efek untuk ganti")

local feetButtons = {}

for i, fireName in ipairs(FireFeetList) do
    local btn = FeetListBox:AddButton({
        Text = "👟 " .. fireName,
        Func = function()
            S.FireFeetType = fireName
            applyFireFeet()

            -- Reset semua warna button
            for _, data in pairs(feetButtons) do
                if data.btn and data.btn.SetTextColor then
                    pcall(function() data.btn:SetTextColor(Color3.fromRGB(240, 240, 255)) end)
                end
            end

            -- Highlight yang aktif
            local data = feetButtons[fireName]
            if data and data.btn and data.btn.SetTextColor then
                pcall(function() data.btn:SetTextColor(Color3.fromRGB(170, 0, 255)) end)
            end
        end
    })

    feetButtons[fireName] = { btn = btn }
end

print("✅ [16/20] COSMIC HUB - Tab Fire + Fire Feet loaded")
print("   Fire: 60 varian")
print("   Fire Feet: 20 varian")-- ============================================
-- SECTION 17/20 : TAB MOONWALK
-- ============================================

-- ============================================
-- MOONWALK CONTROL
-- ============================================
local MWBox = MoonwalkTab:AddLeftGroupbox("Moonwalk Control", "music")

MWBox:AddToggle("MoonwalkEnable", {
    Text = "Enable Moonwalk (Keybind V)",
    Default = false,
    Callback = function(v)
        Moonwalk.Enabled = v

        local hum = getHumanoid()

        if v then
            startMoonwalk()
        else
            stopMoonwalk()
            if hum then
                hum.WalkSpeed = 16
            end
        end
    end
})

MWBox:AddLabel("Tekan V juga bisa toggle")

-- ============================================
-- BUTTON
-- ============================================
local ButtonBox = MoonwalkTab:AddLeftGroupbox("Button", "mouse-pointer")

ButtonBox:AddToggle("MoonwalkShowButton", {
    Text = "Show Moonwalk Button",
    Default = false,
    Callback = function(v)
        Moonwalk.ShowButton = v
        if v then
            createMoonwalkButton()
        else
            removeMoonwalkButton()
        end
    end
})

ButtonBox:AddToggle("MoonwalkLockButton", {
    Text = "🔒 Lock Button Position",
    Default = true,
    Callback = function(v)
        Moonwalk.ButtonLocked = v
        if Moonwalk.LockIconRef then
            Moonwalk.LockIconRef.Visible = v
        end
    end
})

ButtonBox:AddLabel("ON = gak bisa digeser")
ButtonBox:AddLabel("OFF = bisa drag")

ButtonBox:AddButton({
    Text = "🔄 Reset Button Position",
    Func = function()
        Moonwalk.ButtonPos = UDim2.new(0.65, 0, 0.75, 0)
        if Moonwalk.GuiInstance then
            createMoonwalkButton()
        end
        Library:Notify({
            Title = "Posisi button direset!",
            Duration = 2
        })
    end
})

-- ============================================
-- SENSITIVITAS
-- ============================================
local SensBox = MoonwalkTab:AddRightGroupbox("Sensitivitas", "sliders")

SensBox:AddSlider("MoonwalkSpamSpeed", {
    Text = "Spam Speed",
    Default = 30,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Callback = function(v)
        Moonwalk.SpamSpeed = v
    end
})

SensBox:AddLabel("Kecepatan goyang")

SensBox:AddSlider("MoonwalkIntensity", {
    Text = "Intensity",
    Default = 35,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Callback = function(v)
        Moonwalk.Intensity = v
    end
})

SensBox:AddLabel("Besarnya goyangan (derajat)")

SensBox:AddSlider("MoonwalkSlowSpeed", {
    Text = "Walk Speed (Moonwalk)",
    Default = 13,
    Min = 5,
    Max = 20,
    Rounding = 0,
    Callback = function(v)
        Moonwalk.SlowSpeed = v
    end
})

SensBox:AddLabel("Kecepatan jalan pas moonwalk")

SensBox:AddToggle("MoonwalkUseSlow", {
    Text = "Use Slow Speed",
    Default = true,
    Callback = function(v)
        Moonwalk.UseSlow = v
    end
})

-- ============================================
-- INFO
-- ============================================
local MWInfoBox = MoonwalkTab:AddRightGroupbox("Info", "info")

MWInfoBox:AddLabel("🕺 Moonwalk = goyang badan")
MWInfoBox:AddLabel("Auto stop kalau parry/downed")
MWInfoBox:AddDivider()
MWInfoBox:AddLabel("Button → tombol di layar")
MWInfoBox:AddLabel("Keybind V → toggle cepat")
MWInfoBox:AddDivider()
MWInfoBox:AddLabel("🔒 Lock = gak bisa digeser")
MWInfoBox:AddLabel("🔓 Unlock = bisa drag")

print("✅ [17/20] COSMIC HUB - Tab Moonwalk loaded")
print("   Enable, Show Button, Lock, Sensitivitas")-- ============================================
-- SECTION 18/20 : TAB MISC
-- ============================================

-- ============================================
-- MOVEMENT
-- ============================================
local MoveBox = MiscTab:AddLeftGroupbox("Movement", "move")

MoveBox:AddToggle("WalkSpeedToggle", {
    Text = "Walk Speed",
    Default = false,
    Callback = function(v)
        S.WalkSpeed = v
    end
})

MoveBox:AddSlider("WalkSpeedVal", {
    Text = "Walk Speed Value",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Callback = function(v)
        S.WalkSpeedVal = v
    end
})

MoveBox:AddToggle("SpeedHackToggle", {
    Text = "Speed Hack",
    Default = false,
    Callback = function(v)
        S.SpeedHack = v
    end
})

MoveBox:AddSlider("SpeedHackVal", {
    Text = "Speed Hack Value",
    Default = 40,
    Min = 20,
    Max = 200,
    Rounding = 0,
    Callback = function(v)
        S.SpeedHackVal = v
    end
})

MoveBox:AddToggle("NoClipToggle", {
    Text = "No Clip",
    Default = false,
    Callback = function(v)
        S.NoClip = v
    end
})

MoveBox:AddToggle("NoClipCameraToggle", {
    Text = "No Clip Camera",
    Default = false,
    Callback = function(v)
        S.NoClipCamera = v
    end
})

MoveBox:AddToggle("FlyToggle", {
    Text = "Fly",
    Default = false,
    Callback = function(v)
        S.Fly = v
        if v then
            startFly()
        else
            stopFly()
        end
    end
})

MoveBox:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 50,
    Min = 10,
    Max = 300,
    Rounding = 0,
    Callback = function(v)
        S.FlySpeed = v
    end
})

-- ============================================
-- CHARACTER
-- ============================================
local CharBox = MiscTab:AddLeftGroupbox("Character", "user")

CharBox:AddToggle("HeadlessToggle", {
    Text = "Headless",
    Default = true,
    Callback = function(v)
        S.Headless = v
        applyHeadless(v)
    end
})

-- ============================================
-- MISC UTILITY
-- ============================================
local UtilBox = MiscTab:AddRightGroupbox("Misc Utility", "settings")

UtilBox:AddToggle("AntiAFKToggle", {
    Text = "Anti-AFK",
    Default = false,
    Callback = function(v)
        S.AntiAFK = v
        applyAntiAFK(v)
    end
})

UtilBox:AddLabel("Biar nggak kena kick AFK")

UtilBox:AddToggle("ShowFPSToggle", {
    Text = "Show FPS Counter",
    Default = true,
    Callback = function(v)
        S.ShowFPS = v
    end
})

UtilBox:AddToggle("ShowPingToggle", {
    Text = "Show Ping Counter",
    Default = true,
    Callback = function(v)
        S.ShowPing = v
    end
})

UtilBox:AddSlider("FPSPingSize", {
    Text = "FPS/Ping Size",
    Default = 1,
    Min = 0.5,
    Max = 3,
    Rounding = 1,
    Callback = function(v)
        FPSPingConfig.Size = v
        if updateFPSPing then updateFPSPing() end
    end
})

UtilBox:AddLabel("Besar/kecil FPS + Ping")

UtilBox:AddSlider("FPSPingX", {
    Text = "FPS/Ping X",
    Default = 0,
    Min = -1000,
    Max = 200,
    Rounding = 0,
    Callback = function(v)
        FPSPingConfig.X = v
        if updateFPSPing then updateFPSPing() end
    end
})

UtilBox:AddSlider("FPSPingY", {
    Text = "FPS/Ping Y",
    Default = 0,
    Min = -200,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        FPSPingConfig.Y = v
        if updateFPSPing then updateFPSPing() end
    end
})

-- ============================================
-- SERVER
-- ============================================
local ServerBox = MiscTab:AddRightGroupbox("Server", "server")

ServerBox:AddButton({
    Text = "🔄 Rejoin Server",
    Func = function()
        rejoinServer()
    end
})

ServerBox:AddButton({
    Text = "🌐 Server Hop",
    Func = function()
        serverHop()
    end
})

ServerBox:AddLabel("Pindah server random")

print("✅ [18/20] COSMIC HUB - Tab Misc loaded")
print("   Movement: WalkSpeed, SpeedHack, NoClip, Fly")
print("   Character: Headless")
print("   Utility: Anti-AFK, FPS/Ping, Rejoin, Server Hop")-- ============================================
-- SECTION 19/20 : TAB VISUAL + PLAYER + EXTRA + UI SETTINGS
-- ============================================

-- ============================================
-- TAB VISUAL
-- ============================================
local FBBox = VisualTab:AddLeftGroupbox("Fullbright & No Fog", "sun")

FBBox:AddToggle("FullbrightToggle", {
    Text = "Fullbright",
    Default = false,
    Callback = function(v)
        S.Fullbright = v
        applyFullbright(v)
    end
})

FBBox:AddSlider("FullbrightVal", {
    Text = "Brightness Level",
    Default = 100,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Callback = function(v)
        S.FullbrightVal = v
        if S.Fullbright then applyFullbright(true) end
    end
})

FBBox:AddToggle("NoFogToggle", {
    Text = "No Fog (Fix)",
    Default = false,
    Callback = function(v)
        S.NoFog = v
        applyNoFog(v)
    end
})

-- ============================================
-- HD VISUAL
-- ============================================
local HDBox = VisualTab:AddLeftGroupbox("HD Visual", "sparkles")

HDBox:AddToggle("HDBoostToggle", {
    Text = "HD Graphics Boost",
    Default = false,
    Callback = function(v)
        S.HDBoost = v
        applyHDBoost(v)
    end
})

HDBox:AddToggle("HDShaderToggle", {
    Text = "HD Character Shader",
    Default = false,
    Callback = function(v)
        S.HDShader = v
        applyHDShader(v)
    end
})

HDBox:AddToggle("HDSkyToggle", {
    Text = "HD Sky Atmosphere",
    Default = false,
    Callback = function(v)
        S.HDSky = v
        applyHDSky(v)
    end
})

HDBox:AddToggle("HDTextureToggle", {
    Text = "HD Texture",
    Default = false,
    Callback = function(v)
        S.HDTexture = v
        applyHDTexture(v)
    end
})

HDBox:AddToggle("HDReflectionToggle", {
    Text = "HD Reflection",
    Default = false,
    Callback = function(v)
        S.HDReflection = v
        applyHDReflection(v)
    end
})

HDBox:AddToggle("HDBloomToggle", {
    Text = "HD Bloom",
    Default = false,
    Callback = function(v)
        S.HDBloom = v
        applyHDBloom(v)
    end
})

HDBox:AddToggle("HDShadowToggle", {
    Text = "HD Shadow",
    Default = false,
    Callback = function(v)
        S.HDShadow = v
        applyHDShadow(v)
    end
})

HDBox:AddToggle("HDWaterToggle", {
    Text = "HD Water",
    Default = false,
    Callback = function(v)
        S.HDWater = v
        applyHDWater(v)
    end
})

HDBox:AddToggle("HDSunRaysToggle", {
    Text = "HD Sun Rays",
    Default = false,
    Callback = function(v)
        S.HDSunRays = v
        applyHDSunRays(v)
    end
})

HDBox:AddToggle("HDDepthFieldToggle", {
    Text = "HD Depth of Field",
    Default = false,
    Callback = function(v)
        S.HDDepthField = v
        applyHDDepthField(v)
    end
})

HDBox:AddToggle("HDAntiAliasingToggle", {
    Text = "HD Anti-Aliasing",
    Default = false,
    Callback = function(v)
        S.HDAntiAliasing = v
        applyHDAntiAliasing(v)
    end
})

-- ============================================
-- LIGHTING
-- ============================================
local LightBox = VisualTab:AddLeftGroupbox("Lighting", "lightbulb")

LightBox:AddToggle("UltraHDToggle", {
    Text = "Ultra HD",
    Default = false,
    Callback = function(v)
        S.UltraHD = v
        applyUltraHD()
    end
})

LightBox:AddToggle("ContrastToggle", {
    Text = "Contrast Boost",
    Default = false,
    Callback = function(v)
        S.Contrast = v
        applyContrast()
    end
})

LightBox:AddSlider("ContrastVal", {
    Text = "Contrast",
    Default = 0.3,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(v)
        S.ContrastVal = v
        applyContrast()
    end
})

LightBox:AddSlider("SaturationVal", {
    Text = "Saturation",
    Default = 0.2,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(v)
        S.SaturationVal = v
        applyContrast()
    end
})

-- ============================================
-- SKY + CAMERA
-- ============================================
local SkyBox = VisualTab:AddRightGroupbox("Sky & Camera", "cloud")

SkyBox:AddDropdown("SkyPreset", {
    Text = "Sky Preset",
    Values = SkyList,
    Default = "Default",
    Multi = false,
    Callback = function(v)
        S.SkyId = v
        applySky(v)
    end
})

SkyBox:AddToggle("FOVToggle", {
    Text = "FOV Override",
    Default = false,
    Callback = function(v)
        S.FOVEnabled = v
        applyFOV()
    end
})

SkyBox:AddSlider("FOVVal", {
    Text = "FOV Value",
    Default = 70,
    Min = 40,
    Max = 120,
    Rounding = 0,
    Callback = function(v)
        S.FOV = v
        if S.FOVEnabled then applyFOV() end
    end
})

SkyBox:AddToggle("ZoomOutToggle", {
    Text = "Zoom Out",
    Default = false,
    Callback = function(v)
        S.ZoomOut = v
        applyZoomOut(v, S.ZoomOutValue)
    end
})

SkyBox:AddSlider("ZoomOutVal", {
    Text = "Max Zoom Distance",
    Default = 500,
    Min = 100,
    Max = 1000,
    Rounding = 0,
    Callback = function(v)
        S.ZoomOutValue = v
        if S.ZoomOut then applyZoomOut(true, v) end
    end
})

-- ============================================
-- 8-BIT + KORBLOX
-- ============================================
local CharBox = VisualTab:AddRightGroupbox("8-Bit Crown & Korblox", "crown")

CharBox:AddToggle("EightBitToggle", {
    Text = "Enable 8-Bit Crown",
    Default = true,
    Callback = function(v)
        S.EightBitOn = v
        apply8Bit(v, "Royal Crown", S.EightBitSize, S.EightBitHeight)
    end
})

CharBox:AddSlider("EightBitSize", {
    Text = "Size",
    Default = 1.24,
    Min = 0.3,
    Max = 3,
    Rounding = 2,
    Callback = function(v)
        S.EightBitSize = v
        if S.EightBitOn then apply8Bit(true, "Royal Crown", v, S.EightBitHeight) end
    end
})

CharBox:AddSlider("EightBitHeight", {
    Text = "Height",
    Default = 0.88,
    Min = -1,
    Max = 4,
    Rounding = 2,
    Callback = function(v)
        S.EightBitHeight = v
        if S.EightBitOn then apply8Bit(true, "Royal Crown", S.EightBitSize, v) end
    end
})

CharBox:AddDivider()

CharBox:AddToggle("KorbloxToggle", {
    Text = "Enable Korblox",
    Default = true,
    Callback = function(v)
        S.Korblox = v
        applyKorblox(v, "Pencil", S.KorbloxYOffset, S.KorbloxScale)
    end
})

CharBox:AddSlider("KorbloxY", {
    Text = "Korblox Y",
    Default = 0.6,
    Min = -2,
    Max = 2,
    Rounding = 2,
    Callback = function(v)
        S.KorbloxYOffset = v
        if S.Korblox then applyKorblox(true, "Pencil", v, S.KorbloxScale) end
    end
})

CharBox:AddSlider("KorbloxScale", {
    Text = "Korblox Scale",
    Default = 1,
    Min = 0.3,
    Max = 3,
    Rounding = 2,
    Callback = function(v)
        S.KorbloxScale = v
        if S.Korblox then applyKorblox(true, "Pencil", S.KorbloxYOffset, v) end
    end
})

-- ============================================
-- CHARACTER EFFECTS
-- ============================================
local FxBox = VisualTab:AddRightGroupbox("Character Effects", "wand")

FxBox:AddToggle("TrailToggle", {
    Text = "Fire Trail",
    Default = false,
    Callback = function(v)
        S.Trail = v
        applyTrail(v, S.TrailColor)
    end
})

FxBox:AddColorPicker("TrailColor", {
    Default = S.TrailColor,
    Title = "Trail Color",
    Callback = function(c)
        S.TrailColor = c
        if S.Trail then applyTrail(true, c) end
    end
})

FxBox:AddToggle("AuraToggle", {
    Text = "Aura Fire",
    Default = false,
    Callback = function(v)
        S.Aura = v
        applyAura(v, S.AuraColor)
    end
})

FxBox:AddColorPicker("AuraColor", {
    Default = S.AuraColor,
    Title = "Aura Color",
    Callback = function(c)
        S.AuraColor = c
        if S.Aura then applyAura(true, c) end
    end
})

FxBox:AddToggle("KillEffectToggle", {
    Text = "Kill Effect",
    Default = false,
    Callback = function(v)
        S.KillEffect = v
    end
})

-- ============================================
-- CROSSHAIR
-- ============================================
local CrossBox = VisualTab:AddRightGroupbox("Crosshair", "crosshair")

CrossBox:AddToggle("CrosshairToggle", {
    Text = "Enable Crosshair",
    Default = false,
    Callback = function(v)
        S.Crosshair = v
        applyCrosshair(v, S.CrosshairColor, S.CrosshairSize)
    end
})

CrossBox:AddColorPicker("CrosshairColor", {
    Default = S.CrosshairColor,
    Title = "Crosshair Color",
    Callback = function(c)
        S.CrosshairColor = c
        if S.Crosshair then applyCrosshair(true, c, S.CrosshairSize) end
    end
})

CrossBox:AddSlider("CrosshairSize", {
    Text = "Crosshair Size",
    Default = 8,
    Min = 4,
    Max = 20,
    Rounding = 0,
    Callback = function(v)
        S.CrosshairSize = v
        if S.Crosshair then applyCrosshair(true, S.CrosshairColor, v) end
    end
})

-- ============================================
-- TAB PLAYER
-- ============================================
local InfoBox = PlayerTab:AddLeftGroupbox("Info", "info")

InfoBox:AddLabel("🎯 Aimbot = Hold tombol serang")
InfoBox:AddLabel("PC: klik kanan")
InfoBox:AddLabel("HP: tombol attack")
InfoBox:AddDivider()
InfoBox:AddLabel("🕺 Moonwalk = Tekan V")
InfoBox:AddLabel("⚡ SkillCheck = Tab Survivor")
InfoBox:AddDivider()
InfoBox:AddLabel("✨ Tombol menu: klik ✨")

-- ============================================
-- TAB EXTRA
-- ============================================
local ExtraBox = ExtraTab:AddLeftGroupbox("Extra", "star")

ExtraBox:AddButton({
    Text = "🚪 TP ke Finish Line",
    Func = function()
        teleportToFinishLine()
    end
})

ExtraBox:AddButton({
    Text = "🔊 Test Sound",
    Func = function()
        playToggleSound()
    end
})

ExtraBox:AddLabel("Sound aktif saat toggle ON/OFF")

-- ============================================
-- TAB UI SETTINGS
-- ============================================
local UISettingBox = UITab:AddLeftGroupbox("Menu Settings", "wrench")

UISettingBox:AddToggle("WatermarkToggle", {
    Text = "Watermark",
    Default = true,
    Callback = function(Value)
        -- Watermark (kalau ada)
    end
})

UISettingBox:AddDropdown("NotificationSide", {
    Values = {"Left", "Right"},
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end
})

UISettingBox:AddDropdown("DPIDropdown", {
    Values = {"50%", "75%", "85%", "100%", "125%", "150%"},
    Default = "85%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)
        Library:SetDPIScale(DPI)
    end
})

UISettingBox:AddSlider("UICornerSlider", {
    Text = "Corner Radius",
    Default = 20,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Callback = function(value)
        Window:SetCornerRadius(value)
    end
})

UISettingBox:AddDivider()

UISettingBox:AddButton({
    Text = "✨ Unload Script",
    Func = function()
        pcall(function()
            stopMoonwalk()
            if SkillHeartbeat then SkillHeartbeat:Disconnect() end
            removeMoonwalkButton()
            stopFly()
            clear8Bit()
            clearKorblox()
            clearFireBeam()
            clearParryCircle()
            if fpsPingGui then fpsPingGui:Destroy() end
            if killFeedGui then killFeedGui:Destroy() end
            if crosshairGui then crosshairGui:Destroy() end
            Library:Unload()
        end)
    end
})

print("✅ [19/20] COSMIC HUB - Visual + Player + Extra + UI Settings loaded")-- ============================================
-- SECTION 20/20 : FINAL
-- ============================================

-- ============================================
-- AUTO RE-APPLY SAAT RESPAWN
-- ============================================
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.5)

    -- Fire
    if S.FireOn then pcall(applyFire) end
    if S.FireFeetOn then pcall(applyFireFeet) end

    -- Character
    if S.EightBitOn then
        pcall(function() apply8Bit(true, "Royal Crown", S.EightBitSize, S.EightBitHeight) end)
    end
    if S.Korblox then
        pcall(function() applyKorblox(true, "Pencil", S.KorbloxYOffset, S.KorbloxScale) end)
    end
    if S.Headless then pcall(function() applyHeadless(true) end) end

    -- Beam
    if S.FireBeamOn then
        pcall(function() applyFireBeam(true, S.FireBeamType, S.FireBeamColor) end)
    end

    -- Effects
    if S.Trail then pcall(function() applyTrail(true, S.TrailColor) end) end
    if S.Aura then pcall(function() applyAura(true, S.AuraColor) end) end

    -- Camera
    if S.FOVEnabled then pcall(applyFOV) end
    if S.SkyId and S.SkyId ~= "Default" then
        pcall(function() applySky(S.SkyId) end)
    end

    -- HD
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

    -- NoClip
    if S.NoClip then
        task.wait(0.3)
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- Moonwalk Button
    if Moonwalk.ShowButton then
        task.wait(0.5)
        pcall(createMoonwalkButton)
    end

    -- Scan killers (Auto Parry)
    if AutoParry.Enabled then
        task.wait(0.5)
        pcall(scanKillers)
    end

    -- SkillCheck
    if SkillCheck.Enabled then
        task.wait(0.5)
        pcall(startSkillCheck)
    end
end)

-- ============================================
-- AUTO SCAN KILLER (LOOP)
-- ============================================
task.spawn(function()
    while task.wait(1) do
        if AutoParry.Enabled then scanKillers() end
    end
end)

-- ============================================
-- PLAYER ADDED (HOOK KILLER BARU)
-- ============================================
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

-- ============================================
-- KEYBIND V UNTUK MOONWALK
-- ============================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.V then
        Moonwalk.Enabled = not Moonwalk.Enabled

        local hum = getHumanoid()

        if Moonwalk.Enabled then
            startMoonwalk()
            Library:Notify({
                Title = "Moonwalk ON",
                Duration = 1.5
            })
        else
            stopMoonwalk()
            if hum then
                hum.WalkSpeed = 16
            end
            Library:Notify({
                Title = "Moonwalk OFF",
                Duration = 1.5
            })
        end
    end
end)

-- ============================================
-- AUTO APPLY ON EXECUTE
-- ============================================
task.spawn(function()
    task.wait(3)
    pcall(createFPSPingGui)

    if LocalPlayer.Character then
        if S.Headless then pcall(function() applyHeadless(true) end) end
        if S.Korblox then
            pcall(function() applyKorblox(true, "Pencil", S.KorbloxYOffset, S.KorbloxScale) end)
        end
        if S.EightBitOn then
            pcall(function() apply8Bit(true, "Royal Crown", S.EightBitSize, S.EightBitHeight) end)
        end
        if AutoParry.Enabled then pcall(scanKillers) end
        if SkillCheck.Enabled then pcall(startSkillCheck) end
    end
end)

-- ============================================
-- PRINT FINAL
-- ============================================
task.wait(0.5)

print("╔══════════════════════════════════════════════════════╗")
print("║                                                      ║")
print("║              ✨ C O S M I C   H U B ✨               ║")
print("║                                                      ║")
print("║              ✅ SEMUA FITUR LOADED                   ║")
print("║                                                      ║")
print("╠══════════════════════════════════════════════════════╣")
print("║  🛡️  Auto Parry (Sama Fallens)                       ║")
print("║  ⚡  Auto Skill Check (2 MODE!)                      ║")
print("║      → Perfect + Instant + Hide Needle               ║")
print("║  🕺  Moonwalk (Keybind V + Button + Lock)            ║")
print("║  🎯  Aimbot (Hold to Aim) + Trigger Bot              ║")
print("║  🔪  Killer (AutoAttack + KillAll)                   ║")
print("║  🎣  AutoCarry (TP + Carry + Hook)                   ║")
print("║  🕵️  Auto Stalk                                       ║")
print("║  📦  Hitbox (2 Mode, max 120)                        ║")
print("║  🎭  Masked Power (5 Power)                          ║")
print("║  👁️  ESP (Player + Object + Status)                  ║")
print("║  🔥  Fire (60 varian)                                ║")
print("║  👟  Fire Feet (20 varian)                           ║")
print("║  ✨  Visual (HD + Fullbright + Sky)                  ║")
print("║  👑  8-Bit Crown + 🦴 Korblox (Client)               ║")
print("║  📊  FPS + Ping Counter                              ║")
print("║  🛠️  Anti-AFK + Rejoin + Server Hop                  ║")
print("║                                                      ║")
print("╠══════════════════════════════════════════════════════╣")
print("║  🎮  Buka menu: Klik tombol ✨                       ║")
print("║  🎯  Aimbot: Hold tombol serang                      ║")
print("║  🕺  Moonwalk: Tekan V                               ║")
print("║  ⚡  SkillCheck: Tab Survivor                        ║")
print("║                                                      ║")
print("╚══════════════════════════════════════════════════════╝")

print("✅ [20/20] COSMIC HUB - FINAL LOADED! ✨")
