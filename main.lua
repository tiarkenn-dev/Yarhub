-- =========================================================
-- SECTION 1/13 : LOADING GALAXY + CONFIG + STATE
-- =========================================================

Players = game:GetService("Players")
UIS = game:GetService("UserInputService")
RunService = game:GetService("RunService")
TweenService = game:GetService("TweenService")
Lighting = game:GetService("Lighting")
ReplicatedStorage = game:GetService("ReplicatedStorage")
VirtualInputManager = game:GetService("VirtualInputManager")
Stats = game:GetService("Stats")
GuiService = game:GetService("GuiService")
SoundService = game:GetService("SoundService")
StarterGui = game:GetService("StarterGui")

LP = Players.LocalPlayer
PG = LP:WaitForChild("PlayerGui")

function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

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

local _toggleSoundInstance = nil
function playToggleSound()
    task.spawn(function()
        pcall(function()
            if not _toggleSoundInstance or not _toggleSoundInstance.Parent then
                _toggleSoundInstance = Instance.new("Sound")
                _toggleSoundInstance.SoundId = ToggleSoundId
                _toggleSoundInstance.Volume = 0.5
                _toggleSoundInstance.Parent = SoundService
            end
            _toggleSoundInstance:Play()
        end)
    end)
end

_G.Roooor_playSound = playToggleSound

-- =========================================================
-- LOADING
-- =========================================================
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "CosmicLoading"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 999999
loadingGui.Parent = PG

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(5, 2, 15)
bg.BorderSizePixel = 0
bg.Parent = loadingGui

local nebula = Instance.new("Frame")
nebula.Size = UDim2.new(1, 0, 1, 0)
nebula.BackgroundColor3 = Color3.fromRGB(20, 5, 50)
nebula.BorderSizePixel = 0
nebula.BackgroundTransparency = 0.3
nebula.Parent = bg

local nebulaGrad = Instance.new("UIGradient")
nebulaGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(80, 20, 180)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(20, 5, 60)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 100, 180)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(40, 5, 90)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(120, 20, 200)),
})
nebulaGrad.Rotation = 45
nebulaGrad.Parent = nebula

task.spawn(function()
    local t = 0
    while nebula.Parent do
        t = t + 0.005
        nebulaGrad.Rotation = (t * 20) % 360
        task.wait(0.08)
    end
end)

local starContainer = Instance.new("Frame")
starContainer.Size = UDim2.new(1, 0, 1, 0)
starContainer.BackgroundTransparency = 1
starContainer.Parent = bg

local stars = {}
for i = 1, 20 do
    local star = Instance.new("Frame")
    star.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(math.random(180, 255), math.random(180, 255), 255)
    star.BorderSizePixel = 0
    star.BackgroundTransparency = math.random(20, 60) / 100
    star.Parent = starContainer
    rnd(star, 999)
    table.insert(stars, {
        obj = star,
        speed = math.random(10, 40) / 10000,
        twinkle = math.random() * math.pi * 2
    })
end

task.spawn(function()
    while starContainer.Parent do
        for _, s in ipairs(stars) do
            if s.obj and s.obj.Parent then
                local p = s.obj.Position
                local newY = p.Y.Scale + s.speed
                if newY > 1 then
                    newY = 0
                    s.obj.Position = UDim2.new(math.random(), 0, 0, 0)
                else
                    s.obj.Position = UDim2.new(p.X.Scale, 0, newY, 0)
                end
                s.twinkle = s.twinkle + 0.1
                s.obj.BackgroundTransparency = 0.4 + math.sin(s.twinkle) * 0.3
            end
        end
        task.wait(0.12)
    end
end)

local galaxyHolder = Instance.new("Frame")
galaxyHolder.Size = UDim2.new(0, 400, 0, 400)
galaxyHolder.Position = UDim2.new(0.5, -200, 0.5, -200)
galaxyHolder.BackgroundTransparency = 1
galaxyHolder.Parent = bg

local spiral1 = Instance.new("Frame")
spiral1.Size = UDim2.new(0, 300, 0, 300)
spiral1.Position = UDim2.new(0.5, -150, 0.5, -150)
spiral1.BackgroundTransparency = 1
spiral1.Parent = galaxyHolder

local spiral1Stroke = Instance.new("UIStroke")
spiral1Stroke.Thickness = 60
spiral1Stroke.Transparency = 0.85
spiral1Stroke.Color = Color3.fromRGB(140, 70, 255)
spiral1Stroke.Parent = spiral1
rnd(spiral1, 999)

local spiral1Grad = Instance.new("UIGradient")
spiral1Grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 70, 255)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 100, 200)),
})
spiral1Grad.Parent = spiral1Stroke

local spiral2 = Instance.new("Frame")
spiral2.Size = UDim2.new(0, 260, 0, 260)
spiral2.Position = UDim2.new(0.5, -130, 0.5, -130)
spiral2.BackgroundTransparency = 1
spiral2.Parent = galaxyHolder

local spiral2Stroke = Instance.new("UIStroke")
spiral2Stroke.Thickness = 40
spiral2Stroke.Transparency = 0.88
spiral2Stroke.Color = Color3.fromRGB(255, 100, 200)
spiral2Stroke.Parent = spiral2
rnd(spiral2, 999)

local spiral2Grad = Instance.new("UIGradient")
spiral2Grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 100, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(140, 70, 255)),
})
spiral2Grad.Rotation = 180
spiral2Grad.Parent = spiral2Stroke

task.spawn(function()
    local t = 0
    while galaxyHolder.Parent do
        t = t + 1
        spiral1.Rotation = t * 0.8
        spiral2.Rotation = -t * 1.1
        spiral1Grad.Rotation = (t * 2) % 360
        spiral2Grad.Rotation = 180 + (t * 1.5) % 360
        task.wait(0.08)
    end
end)

local titleGlow = Instance.new("Frame")
titleGlow.Size = UDim2.new(0, 500, 0, 100)
titleGlow.Position = UDim2.new(0.5, -250, 0.42, -50)
titleGlow.BackgroundColor3 = Color3.fromRGB(140, 70, 255)
titleGlow.BackgroundTransparency = 0.85
titleGlow.BorderSizePixel = 0
titleGlow.Parent = bg
rnd(titleGlow, 999)

local glowGrad = Instance.new("UIGradient")
glowGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 200)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(140, 70, 255)),
})
glowGrad.Parent = titleGlow

local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Size = UDim2.new(1, 0, 0, 90)
welcomeTitle.Position = UDim2.new(0, 0, 0.42, -20)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.Text = "COSMIC"
welcomeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
welcomeTitle.TextSize = 0
welcomeTitle.Font = Enum.Font.GothamBlack
welcomeTitle.TextStrokeTransparency = 0.4
welcomeTitle.TextStrokeColor3 = Color3.fromRGB(140, 70, 255)
welcomeTitle.TextTransparency = 0
welcomeTitle.Parent = bg

local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(140, 70, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 200)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(140, 70, 255)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 200, 255)),
})
titleGrad.Parent = welcomeTitle

task.spawn(function()
    local t = 0
    while welcomeTitle.Parent do
        t = t + 1
        titleGrad.Rotation = (t * 2) % 360
        task.wait(0.08)
    end
end)

welcomeTitle.TextSize = 0
welcomeTitle.TextTransparency = 1
TweenService:Create(welcomeTitle, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    TextSize = 68,
    TextTransparency = 0
}):Play()

task.spawn(function()
    task.wait(1.2)
    while titleGlow.Parent do
        TweenService:Create(titleGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.6,
            Size = UDim2.new(0, 560, 0, 120),
            Position = UDim2.new(0.5, -280, 0.42, -60)
        }):Play()
        task.wait(1.3)
        TweenService:Create(titleGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.85,
            Size = UDim2.new(0, 500, 0, 100),
            Position = UDim2.new(0.5, -250, 0.42, -50)
        }):Play()
        task.wait(1.3)
    end
end)

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 24)
subtitle.Position = UDim2.new(0, 0, 0.42, 70)
subtitle.BackgroundTransparency = 1
subtitle.Text = "L O A D I N G"
subtitle.TextColor3 = Color3.fromRGB(180, 220, 255)
subtitle.TextSize = 14
subtitle.Font = Enum.Font.GothamBold
subtitle.TextStrokeTransparency = 0.5
subtitle.TextStrokeColor3 = Color3.fromRGB(0, 100, 180)
subtitle.TextTransparency = 1
subtitle.Parent = bg

TweenService:Create(subtitle, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    TextTransparency = 0
}):Play()

task.spawn(function()
    task.wait(1)
    while subtitle.Parent do
        TweenService:Create(subtitle, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
            TextTransparency = 0.4
        }):Play()
        task.wait(0.9)
        TweenService:Create(subtitle, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
            TextTransparency = 0
        }):Play()
        task.wait(0.9)
    end
end)

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 320, 0, 4)
barBg.Position = UDim2.new(0.5, -160, 0.42, 110)
barBg.BackgroundColor3 = Color3.fromRGB(30, 15, 60)
barBg.BorderSizePixel = 0
barBg.BackgroundTransparency = 0.4
barBg.Parent = bg
rnd(barBg, 999)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
barFill.BorderSizePixel = 0
barFill.Parent = barBg
rnd(barFill, 999)

local barFillGrad = Instance.new("UIGradient")
barFillGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 70, 255)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 100, 200)),
})
barFillGrad.Parent = barFill

TweenService:Create(barFill, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Size = UDim2.new(1, 0, 1, 0)
}):Play()

local barGlow = Instance.new("Frame")
barGlow.Size = UDim2.new(1, 12, 2, 12)
barGlow.Position = UDim2.new(0, -6, 0, -6)
barGlow.BackgroundColor3 = Color3.fromRGB(140, 70, 255)
barGlow.BackgroundTransparency = 0.7
barGlow.BorderSizePixel = 0
barGlow.ZIndex = -1
barGlow.Parent = barBg
rnd(barGlow, 999)

task.delay(1.6, function()
    if not loadingGui then return end

    if bg and bg.Parent then
        TweenService:Create(bg, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play()
    end
    if welcomeTitle and welcomeTitle.Parent then
        TweenService:Create(welcomeTitle, TweenInfo.new(0.5), {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }):Play()
    end
    if subtitle and subtitle.Parent then
        TweenService:Create(subtitle, TweenInfo.new(0.5), {
            TextTransparency = 1
        }):Play()
    end
    if nebula and nebula.Parent then
        TweenService:Create(nebula, TweenInfo.new(0.6), {
            BackgroundTransparency = 1
        }):Play()
    end
    if titleGlow and titleGlow.Parent then
        TweenService:Create(titleGlow, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()
    end
    if barBg and barBg.Parent then
        TweenService:Create(barBg, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()
    end
    if barGlow and barGlow.Parent then
        TweenService:Create(barGlow, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()
    end

    task.wait(0.8)
    if loadingGui then loadingGui:Destroy() end
end)

-- =========================================================
-- STATE
-- =========================================================

_G.RoooorSavedStates = _G.RoooorSavedStates or {}

_G.RoooorS = _G.RoooorS or {
    FireOn = true, FireType = "CosmicFire", FireSize = 5,
    ParryCircle = true, ParryCircleSize = 12,
    WalkSpeed = false, WalkSpeedVal = 16, WalkSpeedBoost = 0,
    SpeedHack = false, SpeedHackVal = 40,
    NoClip = false, NoClipCamera = false,
    Korblox = true, KorbloxType = "Pencil",
    KorbloxYOffset = 0.6, KorbloxScale = 1,
    Headless = true,
    EightBitOn = true, EightBitType = "Royal Crown",
    EightBitSize = 1.24, EightBitHeight = 0.88,
    Trail = false, TrailColor = Color3.fromRGB(120, 60, 255),
    Aura = false, AuraColor = Color3.fromRGB(120, 60, 255),
    KillEffect = false,
    Crosshair = false,
    CrosshairColor = Color3.fromRGB(0, 200, 255),
    CrosshairSize = 8, CrosshairThickness = 2,
    CrosshairStyle = "Plus", CrosshairColorMode = "Solid",
    CrosshairOffsetX = 0, CrosshairOffsetY = 0,
    ZoomOut = false, ZoomOutValue = 500,
    FOV = 90, FOVEnabled = true,
    Fullbright = false, FullbrightVal = 50,
    NoFog = false, UltraHD = false,
    Contrast = true, ContrastVal = 0.3, SaturationVal = 0.2,
    SkyId = "SunsetHD",
    SkyAutoApplied = false,
    NoScreenEffects = false, LowGraphics = false, CleanSky = false,
    HDSky = false,
    AntiAFK = false, ShowFPS = true, ShowPing = true,
    Killer_AutoAtk = false, Killer_AtkDelay = 0.35,
    Killer_KillAll = false, MaskedPower = "Cobra",
    InstantInteract = false,
    AutoCarry = false, AutoHook = false, CarryRange = 60,
    HDTexture = false, HDReflection = false, HDBloom = false,
    HDShadow = false, HDWater = false, HDSunRays = false,
    HDDepthField = false, HDAntiAliasing = false,
    FireBeamOn = false, FireBeamType = "Classic Beam",
    FireBeamColor = Color3.fromRGB(120, 60, 255),
    ESPNameMode = "Galaxy", ESPNameSize = 9.35,
    ESPGenMode = "Classic",
    ESPGenBarSize = 80,
    ESPGenBarHeight = 14,
    ESPGenBarTextSize = 10,
    KillFeed = false,
    StunNotify = false,
    AutoEscapeGate = false, AutoEscapeRange = 50,
    AutoEscapeUseKillerCheck = true, AutoEscapeUseGenCheck = true,
}
S = _G.RoooorS

FPSPingConfig = _G.Roooor_FPSPing or { Size = 1, X = 0, Y = 0 }
_G.Roooor_FPSPing = FPSPingConfig

_G.ToggleStates = _G.ToggleStates or {}
_G.SliderStates = _G.SliderStates or {}
_G.DropdownStates = _G.DropdownStates or {}

ESP = _G.Roooor_ESP or {
    Survivor = true, Killer = true, Generator = true,
    Pallet = true, Window = true, SCP = true, Distance = 1000,
}
_G.Roooor_ESP = ESP

ESPStatus = _G.Roooor_ESPStatus or {
    Enabled = true, ShowName = true, ShowDistance = true,
    ShowHealth = true, Radius = 1000,
}
_G.Roooor_ESPStatus = ESPStatus

TeamColors = _G.Roooor_TeamColors or {
    Killer = Color3.fromRGB(255, 60, 60),
    Survivor = Color3.fromRGB(0, 120, 255),
}
_G.Roooor_TeamColors = TeamColors

Hitbox = _G.Roooor_Hitbox or {
    Enabled = false, Size = 70, TextSize = 10,
    Color = Color3.fromRGB(255, 255, 255),
    ColorKiller = Color3.fromRGB(255, 255, 255),
    ColorSurvivor = Color3.fromRGB(255, 255, 255),
    Mode = "Auto", WallBang = true,
}
_G.Roooor_Hitbox = Hitbox

HitboxESPObjects = {}
HitboxOriginalSizes = {}

AutoParry = _G.Roooor_AutoParry or {
    Enabled = false, ParryDistance = 15, ParryDelay = 0,
    Cooldown = 0.5, FaceSensitivity = 0.7, RequireFacing = true,
    Wiggle = false, WiggleSpam = 5,
}
_G.Roooor_AutoParry = AutoParry

AP_CameraFix = { Enabled = true }
AP_ESPCircle = {
    Enabled = true,
    ColorNormal = Color3.fromRGB(0, 255, 100),
    ColorDanger = Color3.fromRGB(255, 50, 50),
    Thickness = 0.4, Segments = 36, YOffset = -2.5
}
AP_PARRY_DEBOUNCE = 0.2

PARRY_DEBOUNCE = 0.1
ParryActive = false

SkillCheck = _G.Roooor_SkillCheck or {
    Enabled = true, Mode = "Perfect", HideNeedle = false,
    Success = 0, Total = 0,
}
_G.Roooor_SkillCheck = SkillCheck

Moonwalk = _G.Roooor_Moonwalk or {
    Enabled = false, Locked = false, SpamSpeed = 30,
    Intensity = 35, SlowSpeed = 13, UseSlow = true, ShowButton = true,
}
_G.Roooor_Moonwalk = Moonwalk

FastVault = _G.Roooor_FastVault or {
    Enabled = false, Speed = 1.2,
    ReplaceMap = {
        ["rbxassetid://83873880822918"] = "rbxassetid://136962284480779",
    },
}
_G.Roooor_FastVault = FastVault

VaultTracks = {}

AutoFlee = _G.Roooor_AutoFlee or {
    Enabled = false, DetectDistance = 50, Cooldown = 0.1, LastFlee = 0,
}
_G.Roooor_AutoFlee = AutoFlee

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

Aimlock = _G.RoooorAimlock or {
    Enabled = false,
    Radius = 80,
    TargetTeam = "Survivors",
    AimPart = "HumanoidRootPart",
    Holding = false,
    CurrentTarget = nil,
}
_G.RoooorAimlock = Aimlock

Aimlock_AttackButtons = {}

print("✅ [1/13] COSMIC - Base + State + Auto ON Config Loaded")
print("🛡️ Auto Parry: Radius 15 | Debounce 0.2 | Face 0.7")
print("📊 ESP Gen Mode: Classic / Bar")-- =========================================================
-- SECTION 2/13 : FIRE CONFIG + SKY + KILLER ANIMS
-- =========================================================

FireList = {
    "Classic","HellFire","IceFire","ToxicFire","VoidFire",
    "GoldenKing","SakuraFire","EmeraldFire","BloodFire","ShadowFire",
    "HolyFire","OceanFire","Firework","Lava","GhostFire",
    "CosmicFire","DragonFire","MysteryFire","RainbowFire","LightningFire",
    "GalaxyFire","NebulaFire","AuroraFire","PhoenixFire","DemonFire",
    "AngelFire","CrystalFire","NeonFire","PlasmaFire","QuantumFire",
    "LegendaryFire","MythicFire","DivineFire","CursedFire","AncientFire",
    "EternalFire","InfernoFire","BifrostFire","ChaosFire","OmegaFire",
    "SolarFire","LunarFire","EclipseFire","SolarFlare","VoidStorm",
    "StarFire","SupernovaFire","BlackHoleFire","MeteorFire","CometFire",
    "FrostFire","BlizzardFire","ThunderFire","StormFire","TornadoFire",
    "SoulFire","SpiritFire","PhantomFire","WraithFire","ReaperFire"
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

SkyList = {
    "Default", "Sunset", "Night", "Space",
    "Alien", "Purple", "Galaxy", "Void",
    "GalaxyPurple", "GalaxyBlue", "GalaxyPink", "GalaxyMulticolor",
    "Nebula", "CosmicStorm", "Aurora",
    "SunsetHD", "NightHD", "DeepSpace",
}

SkyIds = {
    Sunset = { Bk = "rbxassetid://169210149", Dn = "rbxassetid://169210108", Ft = "rbxassetid://169210121", Lf = "rbxassetid://169210133", Rt = "rbxassetid://169210143", Up = "rbxassetid://169210149" },
    Night = { Bk = "rbxassetid://18703245834", Dn = "rbxassetid://18703245834", Ft = "rbxassetid://18703245834", Lf = "rbxassetid://18703245834", Rt = "rbxassetid://18703245834", Up = "rbxassetid://18703245834" },
    Space = { Bk = "rbxassetid://17817511804", Dn = "rbxassetid://17817520184", Ft = "rbxassetid://17817511804", Lf = "rbxassetid://17817511804", Rt = "rbxassetid://17817511804", Up = "rbxassetid://17817511804" },
    Alien = { Bk = "rbxassetid://10253172001", Dn = "rbxassetid://10253172001", Ft = "rbxassetid://10253172001", Lf = "rbxassetid://10253172001", Rt = "rbxassetid://10253172001", Up = "rbxassetid://10253172001" },
    Purple = { Bk = "rbxassetid://6021017254", Dn = "rbxassetid://6021011228", Ft = "rbxassetid://6021017254", Lf = "rbxassetid://6021017254", Rt = "rbxassetid://6021017254", Up = "rbxassetid://6021017254" },
    Galaxy = { Bk = "rbxassetid://126146408999925", Dn = "rbxassetid://118112392224589", Ft = "rbxassetid://121253817183621", Lf = "rbxassetid://138429250948648", Rt = "rbxassetid://126146408999925", Up = "rbxassetid://126146408999925" },
    Void = { Bk = "rbxassetid://17817511804", Dn = "rbxassetid://17817520184", Ft = "rbxassetid://17817511804", Lf = "rbxassetid://17817511804", Rt = "rbxassetid://17817511804", Up = "rbxassetid://17817511804" },
    GalaxyPurple = { Bk = "rbxassetid://126146408999925", Dn = "rbxassetid://118112392224589", Ft = "rbxassetid://121253817183621", Lf = "rbxassetid://138429250948648", Rt = "rbxassetid://126146408999925", Up = "rbxassetid://126146408999925" },
    GalaxyBlue = { Bk = "rbxassetid://159454299", Dn = "rbxassetid://159454296", Ft = "rbxassetid://159454293", Lf = "rbxassetid://159454286", Rt = "rbxassetid://159454300", Up = "rbxassetid://159454288" },
    GalaxyPink = { Bk = "rbxassetid://6021017254", Dn = "rbxassetid://6021011228", Ft = "rbxassetid://6021017254", Lf = "rbxassetid://6021017254", Rt = "rbxassetid://6021017254", Up = "rbxassetid://6021017254" },
    GalaxyMulticolor = { Bk = "rbxassetid://126146408999925", Dn = "rbxassetid://118112392224589", Ft = "rbxassetid://121253817183621", Lf = "rbxassetid://138429250948648", Rt = "rbxassetid://126146408999925", Up = "rbxassetid://126146408999925" },
    Nebula = { Bk = "rbxassetid://126146408999925", Dn = "rbxassetid://118112392224589", Ft = "rbxassetid://121253817183621", Lf = "rbxassetid://138429250948648", Rt = "rbxassetid://126146408999925", Up = "rbxassetid://126146408999925" },
    CosmicStorm = { Bk = "rbxassetid://17817511804", Dn = "rbxassetid://17817520184", Ft = "rbxassetid://17817511804", Lf = "rbxassetid://17817511804", Rt = "rbxassetid://17817511804", Up = "rbxassetid://17817511804" },
    Aurora = { Bk = "rbxassetid://159454299", Dn = "rbxassetid://159454296", Ft = "rbxassetid://159454293", Lf = "rbxassetid://159454286", Rt = "rbxassetid://159454300", Up = "rbxassetid://159454288" },
    SunsetHD = { Bk = "rbxassetid://169210149", Dn = "rbxassetid://169210108", Ft = "rbxassetid://169210121", Lf = "rbxassetid://169210133", Rt = "rbxassetid://169210143", Up = "rbxassetid://169210149" },
    NightHD = { Bk = "rbxassetid://18703245834", Dn = "rbxassetid://18703245834", Ft = "rbxassetid://18703245834", Lf = "rbxassetid://18703245834", Rt = "rbxassetid://18703245834", Up = "rbxassetid://18703245834" },
    DeepSpace = { Bk = "rbxassetid://17817511804", Dn = "rbxassetid://17817520184", Ft = "rbxassetid://17817511804", Lf = "rbxassetid://17817511804", Rt = "rbxassetid://17817511804", Up = "rbxassetid://17817511804" },
}

-- 🆕 KILLER ANIMS (+5 ID dari FALLENS)
KillerAnims = {}
for _, id in ipairs({
    "105374834496520","113255068724446","118907603246885","129784271201071",
    "117042998468241","122812055447896","78935059863801","74968262036854",
    "78432063483146","132817836308238","133963973694098","111920872708571",
    "80411309607666","98163597193511","82666958311998","110355011987939",
    "139369275981139","135002183282873","121216847022485","130593238885843",
    "117070354890871","106871536134254","138720291317243",
    -- 🆕 TAMBAHAN DARI FALLENS
    "127096285501517",  -- PARRY ANIM
    "112166042383605",  -- BREAK PALLET
    "123047897844134",  -- STUN
    "126965695851149",  -- WALKCROUCH
    "135084204086504"   -- WALKCROUCH INJURED
}) do
    KillerAnims["rbxassetid://"..id] = true
end

print("✅ [2/13] COSMIC - Fire + Sky (18) + KillerAnims (28) Loaded")
print("🎯 KillerAnims: 23 Original + 5 Fallens")-- =========================================================
-- SECTION 3/13 : FUNGSI UTAMA + HD SKY + APPLY SKY
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
        _G.RoooorSavedStates.Hitbox = Hitbox
        _G.RoooorSavedStates.GodMode = GodMode
        _G.RoooorSavedStates.AutoFlee = AutoFlee
        _G.RoooorSavedStates.FastVault = FastVault
    end
end)

-- FIRE
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

task.spawn(function()
    while task.wait(0.8) do
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

-- 8-BIT ROYAL CROWN
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

-- KORBLOX PENCIL
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
    if not char then return end
    for legName, data in pairs(korbloxOrigData) do
        local leg = char:FindFirstChild(legName)
        if leg then
            leg.Transparency = data.trans
            leg.CanCollide = data.collide
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

-- HD VISUAL EXTRAS
hdExtras = {}

function applyHDSky(s)
    if s then
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere") then v:Destroy() end
        end

        pcall(function()
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            Lighting.FogColor = Color3.fromRGB(200, 220, 255)
        end)

        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("Sky") then v:Destroy() end
        end

        local cleanSky = Instance.new("Sky")
        cleanSky.Name = "HDSky_Clean"
        cleanSky.SkyboxBk = "rbxassetid://159454299"
        cleanSky.SkyboxDn = "rbxassetid://159454296"
        cleanSky.SkyboxFt = "rbxassetid://159454293"
        cleanSky.SkyboxLf = "rbxassetid://159454286"
        cleanSky.SkyboxRt = "rbxassetid://159454300"
        cleanSky.SkyboxUp = "rbxassetid://159454288"
        cleanSky.Parent = Lighting

        local lightAtmo = Instance.new("Atmosphere")
        lightAtmo.Name = "HDSky_Light"
        lightAtmo.Density = 0.1
        lightAtmo.Offset = 0.1
        lightAtmo.Color = Color3.fromRGB(220, 230, 255)
        lightAtmo.Decay = Color3.fromRGB(180, 200, 240)
        lightAtmo.Glare = 0
        lightAtmo.Haze = 0
        lightAtmo.Parent = Lighting

        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.fromRGB(150, 160, 180)
        Lighting.OutdoorAmbient = Color3.fromRGB(180, 190, 210)
    else
        local oldSky = Lighting:FindFirstChild("HDSky_Clean")
        if oldSky then oldSky:Destroy() end
        local oldAtmo = Lighting:FindFirstChild("HDSky_Light")
        if oldAtmo then oldAtmo:Destroy() end

        pcall(function()
            Lighting.FogEnd = origLighting.FogEnd or 100000
            Lighting.FogStart = origLighting.FogStart or 0
            Lighting.Brightness = origLighting.Brightness
            Lighting.ClockTime = origLighting.ClockTime
            Lighting.Ambient = origLighting.Ambient
            Lighting.OutdoorAmbient = origLighting.OutdoorAmbient
        end)

        if origSky then
            local existing = Lighting:FindFirstChild("OrigSky_Clone")
            if not existing then
                local c = origSky:Clone()
                c.Name = "OrigSky_Clone"
                c.Parent = Lighting
            end
        end
    end
end

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

-- APPLY SKY
function applySky(skyName)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end

    if not skyName or skyName == "Default" then
        if origSky then
            local c = origSky:Clone()
            c.Name = "OrigSky_Clone"
            c.Parent = Lighting
        end
        print("[SKY] Restored default sky")
        return
    end

    local ids = SkyIds[skyName]
    if not ids then
        warn("[SKY] Sky '" .. tostring(skyName) .. "' gak ada, fallback")
        ids = SkyIds.SunsetHD
    end

    local sky = Instance.new("Sky")
    sky.Name = "CosmicSky_" .. skyName
    sky.SkyboxBk = ids.Bk
    sky.SkyboxDn = ids.Dn or ids.Bk
    sky.SkyboxFt = ids.Ft or ids.Bk
    sky.SkyboxLf = ids.Lf or ids.Bk
    sky.SkyboxRt = ids.Rt or ids.Bk
    sky.SkyboxUp = ids.Up or ids.Bk
    sky.Parent = Lighting

    print("[SKY] Applied:", skyName)
end

-- MISC UTILITY
function applyAntiAFK(enable)
    S.AntiAFK = enable
end

function rejoinServer()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
end

-- FPS + PING
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

    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 110, 0, 42)
    frame.Position = UDim2.new(1, -120, 0, 5)
    frame.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = fpsPingGui
    rnd(frame, 8)
    strk(frame, C.ACC, 1.5, 0.3)

    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Name = "FPSLabel"
    fpsLabel.Size = UDim2.new(1, -8, 0, 18)
    fpsLabel.Position = UDim2.new(0, 4, 0, 3)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS: 0"
    fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fpsLabel.TextSize = 11
    fpsLabel.Font = Enum.Font.GothamBold
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.Parent = frame

    local pingLabel = Instance.new("TextLabel")
    pingLabel.Name = "PingLabel"
    pingLabel.Size = UDim2.new(1, -8, 0, 18)
    pingLabel.Position = UDim2.new(0, 4, 0, 21)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text = "Ping: 0 ms"
    pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    pingLabel.TextSize = 11
    pingLabel.Font = Enum.Font.GothamBold
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left
    pingLabel.Parent = frame
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

_G.Roooor_updateFPSPing = updateFPSPing

print("✅ [3/13] COSMIC - Fungsi Utama + HD Sky + Apply Sky Loaded")-- =========================================================
-- SECTION 4/13 : ESP + AUTO PARRY + MOONWALK + HITBOX
-- =========================================================

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
        if ESPObjects[obj].FillColor ~= color then
            ESPObjects[obj].FillColor = color
            ESPObjects[obj].OutlineColor = color
        end
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
    if isDown then text = text .. "DOWN\n" end
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
            if label.Text ~= text then label.Text = text end
            if label.TextColor3 ~= teamColor then label.TextColor3 = teamColor end
            if label.TextSize ~= size then label.TextSize = size end
        end
    end

    if mode ~= "Galaxy" then
        local label = billboard:FindFirstChildOfClass("TextLabel")
        if label then
            local grad = label:FindFirstChildOfClass("UIGradient")
            if grad then grad:Destroy() end
        end
    end
end

-- GALAXY NAME ANIMATOR
task.spawn(function()
    while task.wait(0.15) do
        if S.ESPNameMode == "Galaxy" then
            for char, billboard in pairs(StatusESP) do
                if not billboard or not billboard.Parent then
                    StatusESP[char] = nil
                    continue
                end
                local label = billboard:FindFirstChildOfClass("TextLabel")
                if label then
                    local grad = label:FindFirstChildOfClass("UIGradient")
                    if not grad then
                        grad = Instance.new("UIGradient")
                        grad.Parent = label
                    end
                    local t = tick()
                    grad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromHSV((t * 0.5) % 1, 1, 1)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromHSV((t * 0.5 + 0.33) % 1, 1, 1)),
                        ColorSequenceKeypoint.new(0.66, Color3.fromHSV((t * 0.5 + 0.66) % 1, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV((t * 0.5) % 1, 1, 1)),
                    })
                    grad.Rotation = (t * 120) % 360
                end
            end
        end
    end
end)

-- ESP GENERATOR
function GetGameValue(obj, name)
    if not obj then return nil end
    local attr = obj:GetAttribute(name)
    if attr ~= nil then return attr end
    local child = obj:FindFirstChild(name)
    if child and child:IsA("ValueBase") then
        local ok, val = pcall(function() return child.Value end)
        if ok then return val end
    end
    return nil
end

function GetGeneratorProgress(gen)
    if not gen then return 0 end
    local names = {
        "RepairProgress", "Progress", "Value", "RepairValue",
        "ProgressValue", "GenProgress", "Repaired", "Repair",
        "Percent", "Percentage", "RepairPercent"
    }
    for _, n in ipairs(names) do
        local v = GetGameValue(gen, n)
        if v ~= nil and type(v) == "number" then return v end
    end
    for _, d in ipairs(gen:GetDescendants()) do
        if d:IsA("ValueBase") then
            local ln = string.lower(d.Name)
            if ln:find("progress") or ln:find("repair")
               or ln:find("percent") or ln:find("value") then
                local ok, val = pcall(function() return d.Value end)
                if ok and type(val) == "number" then return val end
            end
        end
    end
    for _, attrName in ipairs(gen:GetAttributes()) do
        local v = gen:GetAttribute(attrName)
        if type(v) == "number" and v >= 0 and v <= 100 then
            local lower = string.lower(attrName)
            if lower:find("progress") or lower:find("repair")
               or lower:find("value") or lower:find("percent") then
                return v
            end
        end
    end
    return 0
end

function ApplyGenHighlight(object, color)
    if not object then return end
    local h = object:FindFirstChild("GenHighlight") or Instance.new("Highlight")
    h.Name = "GenHighlight"
    h.Adornee = object
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.9
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = object
end

function UpdateGenerator(generator)
    if not generator or not generator.Parent then return end

    if not ESP.Generator then
        local a = generator:FindFirstChild("GenESP")
        if a then a:Destroy() end
        local b = generator:FindFirstChild("GenESPBar")
        if b then b:Destroy() end
        local h = generator:FindFirstChild("GenHighlight")
        if h then h:Destroy() end
        return
    end

    local percent = GetGeneratorProgress(generator)
    local cp = math.clamp(percent, 0, 100)

    -- MODE CLASSIC
    if S.ESPGenMode == "Classic" then
        local oldBar = generator:FindFirstChild("GenESPBar")
        if oldBar then oldBar:Destroy() end

        if percent >= 100 then
            local old = generator:FindFirstChild("GenESP")
            if old then old:Destroy() end
            local h = generator:FindFirstChild("GenHighlight")
            if h then h:Destroy() end
            return
        end

        local color = GeneratorColor:Lerp(Color3.fromRGB(0, 255, 120), cp / 100)
        local text = string.format("[%.0f%%]", percent)

        local billboard = generator:FindFirstChild("GenESP")
        if not billboard then
            billboard = Instance.new("BillboardGui")
            billboard.Name = "GenESP"
            billboard.Size = UDim2.new(0, 100, 0, 30)
            billboard.AlwaysOnTop = true

            local label = Instance.new("TextLabel")
            label.Name = "GenLabel"
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
            local lbl2 = billboard:FindFirstChild("GenLabel")
            if lbl2 then
                lbl2.Text = text
                lbl2.TextColor3 = color
            end
        end
        ApplyGenHighlight(generator, color)

    -- MODE BAR
    elseif S.ESPGenMode == "Bar" then
        local oldClassic = generator:FindFirstChild("GenESP")
        if oldClassic then oldClassic:Destroy() end

        if percent >= 100 then
            local old = generator:FindFirstChild("GenESPBar")
            if old then old:Destroy() end
            local h = generator:FindFirstChild("GenHighlight")
            if h then h:Destroy() end
            return
        end

        local barSize = S.ESPGenBarSize or 80
        local barHeight = S.ESPGenBarHeight or 14
        local textSize = S.ESPGenBarTextSize or 10

        local billboard = generator:FindFirstChild("GenESPBar")
        if not billboard then
            billboard = Instance.new("BillboardGui")
            billboard.Name = "GenESPBar"
            billboard.Size = UDim2.new(0, barSize, 0, barHeight)
            billboard.AlwaysOnTop = true
            billboard.StudsOffset = Vector3.new(0, 1.5, 0)
            billboard.Adornee = generator
            billboard.Parent = generator

            local barBg = Instance.new("Frame")
            barBg.Name = "BarBg"
            barBg.Size = UDim2.new(1, 0, 1, 0)
            barBg.Position = UDim2.new(0, 0, 0, 0)
            barBg.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
            barBg.BorderSizePixel = 0
            barBg.Parent = billboard

            local bbc = Instance.new("UICorner")
            bbc.CornerRadius = UDim.new(1, 0)
            bbc.Parent = barBg

            local bbStroke = Instance.new("UIStroke")
            bbStroke.Name = "Border"
            bbStroke.Thickness = 1
            bbStroke.Color = Color3.fromRGB(120, 70, 200)
            bbStroke.Transparency = 0.3
            bbStroke.Parent = barBg

            local barFill = Instance.new("Frame")
            barFill.Name = "BarFill"
            barFill.Size = UDim2.new(0, 0, 1, 0)
            barFill.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
            barFill.BorderSizePixel = 0
            barFill.Parent = barBg

            local bfc = Instance.new("UICorner")
            bfc.CornerRadius = UDim.new(1, 0)
            bfc.Parent = barFill

            local pctText = Instance.new("TextLabel")
            pctText.Name = "PctText"
            pctText.Size = UDim2.new(1, 0, 1, 0)
            pctText.Position = UDim2.new(0, 0, 0, 0)
            pctText.BackgroundTransparency = 1
            pctText.Text = "0%"
            pctText.TextColor3 = Color3.fromRGB(255, 255, 255)
            pctText.TextSize = textSize
            pctText.Font = Enum.Font.GothamBold
            pctText.TextXAlignment = Enum.TextXAlignment.Center
            pctText.TextYAlignment = Enum.TextYAlignment.Center
            pctText.TextStrokeTransparency = 0.2
            pctText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            pctText.ZIndex = 10
            pctText.Parent = barBg
        end

        if billboard.AbsoluteSize.X ~= barSize
           or billboard.AbsoluteSize.Y ~= barHeight then
            billboard.Size = UDim2.new(0, barSize, 0, barHeight)
        end

        local barBg = billboard:FindFirstChild("BarBg")
        if barBg then
            local barFill = barBg:FindFirstChild("BarFill")
            local pctText = barBg:FindFirstChild("PctText")
            if barFill then
                barFill.Size = UDim2.new(cp / 100, 0, 1, 0)
            end
            if pctText then
                pctText.Text = string.format("%.0f%%", percent)
                pctText.TextSize = textSize
            end
        end

        local color = GeneratorColor:Lerp(Color3.fromRGB(0, 255, 120), cp / 100)
        ApplyGenHighlight(generator, color)
    end
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
-- AUTO PARRY GACOR (SETTING BARU: 15/0.2/0.7)
-- =========================================================
AP_lastParry = 0
AP_parryCount = 0
AP_hookedKillers = _G.AP_HookedKillers or {}
_G.AP_HookedKillers = AP_hookedKillers
AP_wasLocked = false

AP_Config = {
    Debounce = 0.2,
    Radius = 15,
    FaceSensitivity = 0.7,
    EnableFaceCheck = true,
    EnableAttributeCheck = true,
    EnableVelocityCheck = true,
    RadiusProximity = 15,
}

function AP_GetParryButton()
    local current = PG
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

function AP_FindParryButton()
    local btn = AP_GetParryButton()
    if btn and btn:IsA("GuiObject") and btn.Visible then
        return btn
    end
    for _, obj in pairs(PG:GetDescendants()) do
        if obj:IsA("GuiObject") and obj.Visible then
            local n = string.lower(obj.Name)
            if n:find("parry") or n:find("block") or n:find("guard") then
                return obj
            end
        end
    end
    return nil
end

function AP_PressRightClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
end

function AP_PressParryButton()
    if UIS.TouchEnabled then
        local btn = AP_FindParryButton()
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = GuiService:GetGuiInset()
            local x = pos.X + size.X / 2 + inset.X
            local y = pos.Y + size.Y / 2 + inset.Y
            VirtualInputManager:SendTouchEvent(8823, 0, x, y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8823, 2, x, y)
        else
            AP_PressRightClick()
        end
    else
        AP_PressRightClick()
    end
end

local _oldAP_PressParryButton = AP_PressParryButton
function AP_PressParryButton()
    _oldAP_PressParryButton()
    task.delay(0.05, function()
        local cam = workspace.CurrentCamera
        local char = LP.Character
        if cam and char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                pcall(function()
                    cam.CameraType = Enum.CameraType.Custom
                    cam.CameraSubject = hum
                    cam.Focus = CFrame.new(cam.CFrame.Position)
                end)
            end
        end
    end)
end

function AP_IsInRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end
    return (enemyRoot.Position - myRoot.Position).Magnitude <= AP_Config.Radius
end

function AP_IsFacingMe(killerChar)
    if not AP_Config.EnableFaceCheck then return true end
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end
    local toMe = (myRoot.Position - enemyRoot.Position).Unit
    local killerLook = enemyRoot.CFrame.LookVector
    local dot = killerLook:Dot(toMe)
    return dot >= AP_Config.FaceSensitivity
end

function AP_IsAttacking(killerChar)
    if not AP_Config.EnableAttributeCheck then return true end
    local checks = {
        "IsAttacking", "Attacking", "IsSwinging",
        "Swinging", "AttackActive", "IsParrying",
    }
    for _, attr in ipairs(checks) do
        if killerChar:GetAttribute(attr) == true then
            return true
        end
    end
    return true
end

function AP_IsMovingTowardsMe(killerChar)
    if not AP_Config.EnableVelocityCheck then return true end
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end
    local velocity = enemyRoot.AssemblyLinearVelocity
    if velocity.Magnitude < 5 then return true end
    local moveDir = velocity.Unit
    local toMe = (myRoot.Position - enemyRoot.Position).Unit
    local dot = moveDir:Dot(toMe)
    return dot >= 0
end

function AP_DoParry()
    local now = tick()
    if now - AP_lastParry < AP_Config.Debounce then return end
    AP_lastParry = now
    AP_parryCount = AP_parryCount + 1
    print("[AP] PARRY #" .. AP_parryCount)
    AP_PressParryButton()
end

function AP_HookKiller(char)
    if AP_hookedKillers[char] then return end
    AP_hookedKillers[char] = true

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

        if KillerAnims["rbxassetid://" .. id] then
            if not AP_IsInRange(char) then return end
            if not AP_IsFacingMe(char) then return end
            if not AP_IsAttacking(char) then return end
            if not AP_IsMovingTowardsMe(char) then return end
            AP_DoParry()
        end
    end)

    char.AttributeChanged:Connect(function(attr)
        if not AutoParry.Enabled then return end
        local attackingAttrs = {
            "IsAttacking", "Attacking", "IsSwinging",
            "Swinging", "AttackActive"
        }
        for _, a in ipairs(attackingAttrs) do
            if attr == a and char:GetAttribute(a) == true then
                if not AP_IsInRange(char) then return end
                if not AP_IsFacingMe(char) then return end
                if not AP_IsMovingTowardsMe(char) then return end
                AP_DoParry()
                return
            end
        end
    end)
end

function AP_ScanKillers()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
            AP_HookKiller(p.Character)
        end
    end
end

for _, p in pairs(Players:GetPlayers()) do
    p.CharacterAdded:Connect(function(c)
        AP_hookedKillers[c] = nil
        task.wait(1)
        AP_ScanKillers()
    end)
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        AP_hookedKillers[c] = nil
        task.wait(1)
        AP_ScanKillers()
    end)
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if AutoParry.Enabled then AP_ScanKillers() end
    end
end)

-- PROXIMITY PRE-TRIGGER
task.spawn(function()
    while task.wait(0.1) do
        if not AutoParry.Enabled then continue end
        local myRoot = getRoot()
        if not myRoot then continue end

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                local killerRoot = p.Character:FindFirstChild("HumanoidRootPart")
                if killerRoot then
                    local dist = (killerRoot.Position - myRoot.Position).Magnitude
                    if dist <= AP_Config.RadiusProximity then
                        if AP_IsFacingMe(p.Character)
                           and AP_IsMovingTowardsMe(p.Character) then
                            local hum = p.Character:FindFirstChildOfClass("Humanoid")
                            if hum then
                                local animator = hum:FindFirstChildOfClass("Animator")
                                if animator then
                                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                        local a = track.Animation
                                        if a and a.AnimationId then
                                            local id = a.AnimationId:match("%d+")
                                            if KillerAnims["rbxassetid://" .. id] then
                                                AP_DoParry()
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

-- CAMERA FIX
AP_CamLastForced = 0
AP_CamLastCFrame = nil
AP_CamStuckTime = 0

task.spawn(function()
    while task.wait(0.3) do
        if not AP_CameraFix.Enabled then continue end

        local cam = workspace.CurrentCamera
        local char = LP.Character
        if not cam or not char then continue end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        local isStuck = false

        if cam.CameraType ~= Enum.CameraType.Custom then isStuck = true end
        if cam.CameraSubject ~= hum then isStuck = true end

        local state = hum:GetState()
        if state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.Dead
            or state == Enum.HumanoidStateType.PlatformStanding then
            isStuck = true
        end

        if not AP_CamLastCFrame then
            AP_CamLastCFrame = cam.CFrame
            AP_CamStuckTime = tick()
        else
            local diff = (cam.CFrame.Position - AP_CamLastCFrame.Position).Magnitude
            if diff < 0.01 then
                if tick() - AP_CamStuckTime > 1.2 then
                    isStuck = true
                end
            else
                AP_CamStuckTime = tick()
                AP_CamLastCFrame = cam.CFrame
            end
        end

        local guiFocus = GuiService.SelectedObject
        if guiFocus then isStuck = false end

        if isStuck then
            local now = tick()
            if now - AP_CamLastForced > 0.3 then
                AP_CamLastForced = now
                pcall(function()
                    cam.CameraType = Enum.CameraType.Custom
                    cam.CameraSubject = hum
                    cam.CameraMode = Enum.CameraMode.Classic
                    cam.Focus = CFrame.new(cam.CFrame.Position)
                end)
            end
        end
    end
end)-- AP CIRCLE
AP_parryCirclePart = nil
AP_parryCircleAttachments = {}
AP_parryCircleBeams = {}

function AP_ClearCircle()
    if AP_parryCirclePart then
        AP_parryCirclePart:Destroy()
        AP_parryCirclePart = nil
    end
    AP_parryCircleAttachments = {}
    AP_parryCircleBeams = {}
end

function AP_CreateCircle()
    AP_ClearCircle()

    AP_parryCirclePart = Instance.new("Part")
    AP_parryCirclePart.Name = "AP_ParryRingBeam"
    AP_parryCirclePart.Anchored = true
    AP_parryCirclePart.CanCollide = false
    AP_parryCirclePart.CanQuery = false
    AP_parryCirclePart.CanTouch = false
    AP_parryCirclePart.Transparency = 1
    AP_parryCirclePart.Size = Vector3.new(1, 0.1, 1)
    AP_parryCirclePart.Parent = workspace

    local segments = AP_ESPCircle.Segments
    for i = 1, segments do
        local angle = (i / segments) * math.pi * 2
        local att = Instance.new("Attachment")
        att.Position = Vector3.new(math.cos(angle), 0, math.sin(angle))
        att.Parent = AP_parryCirclePart
        table.insert(AP_parryCircleAttachments, att)
    end

    for i = 1, segments do
        local attA = AP_parryCircleAttachments[i]
        local attB = AP_parryCircleAttachments[(i % segments) + 1]
        local beam = Instance.new("Beam")
        beam.Attachment0 = attA
        beam.Attachment1 = attB
        beam.Width0 = AP_ESPCircle.Thickness
        beam.Width1 = AP_ESPCircle.Thickness
        beam.FaceCamera = true
        beam.LightEmission = 1
        beam.LightInfluence = 0
        beam.Segments = 1
        beam.Transparency = NumberSequence.new(0)
        beam.Color = ColorSequence.new(AP_ESPCircle.ColorNormal)
        beam.Parent = AP_parryCirclePart
        table.insert(AP_parryCircleBeams, beam)
    end
end

function AP_UpdateCircle()
    local root = getRoot()
    if not AP_ESPCircle.Enabled or not root then
        if AP_parryCirclePart then AP_ClearCircle() end
        return
    end

    if not AP_parryCirclePart or not AP_parryCirclePart.Parent then
        AP_CreateCircle()
    end

    local radius = AutoParry.ParryDistance
    local myPos = root.Position
    local yOffset = AP_ESPCircle.YOffset

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

    local ringColor = killerInside and AP_ESPCircle.ColorDanger or AP_ESPCircle.ColorNormal

    AP_parryCirclePart.Position = Vector3.new(myPos.X, myPos.Y + yOffset, myPos.Z)

    for i, att in ipairs(AP_parryCircleAttachments) do
        local angle = (i / AP_ESPCircle.Segments) * math.pi * 2
        att.Position = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
    end

    for _, beam in ipairs(AP_parryCircleBeams) do
        beam.Width0 = AP_ESPCircle.Thickness
        beam.Width1 = AP_ESPCircle.Thickness
        beam.Color = ColorSequence.new(ringColor)
        beam.Transparency = NumberSequence.new(0)
    end
end

-- =========================================================
-- AUTO SKILL CHECK (FALLENS STYLE — Perfect + King's Scourge)
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

        local lr = line.Rotation % 360
        local gr = goal.Rotation % 360

        -- INSTANT MODE
        if SkillCheck.Mode == "Instant" then
            local targetRot = (gr + 109) % 360
            pcall(function() line.Rotation = targetRot end)
            busy = true

            task.spawn(function()
                if UIS.TouchEnabled then
                    TriggerMobileButton()
                else
                    pressSpace()
                end
                SkillCheck.Success += 1
                SkillCheck.Total += 1
                task.wait(0.05)
                busy = false
            end)
            return
        end

        -- PERFECT MODE (Fallens Style, King's Scourge Ready)
        if SkillCheck.Mode == "Perfect" then
            local startRange = (gr + 102) % 360
            local endRange   = (gr + 116) % 360

            local success =
                (startRange > endRange and (lr >= startRange or lr <= endRange))
                or (lr >= startRange and lr <= endRange)

            if success then
                busy = true

                task.spawn(function()
                    if UIS.TouchEnabled then
                        TriggerMobileButton()
                    else
                        pressSpace()
                    end
                    SkillCheck.Success += 1
                    SkillCheck.Total += 1
                    task.wait(0.05)
                    busy = false
                end)
            end
            return
        end
    end)
end

task.spawn(function()
    task.wait(1)
    if SkillCheck.Enabled then
        startSkillCheck()
    end
end)

-- MOONWALK
function mwIsDowned()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return hum.Health <= 0 or hum.Health < 2
end

function mwResetSpeed()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 16 end
end

function setMoonwalk(state)
    if Moonwalk.Locked and state ~= Moonwalk.Enabled then
        return false
    end
    Moonwalk.Enabled = state
    if not state then mwResetSpeed() end
    return true
end

if PG:FindFirstChild("MW_BottomBtn") then
    PG.MW_BottomBtn:Destroy()
end

mwBtnGui = Instance.new("ScreenGui")
mwBtnGui.Name = "MW_BottomBtn"
mwBtnGui.ResetOnSpawn = false
mwBtnGui.IgnoreGuiInset = true
mwBtnGui.Parent = PG

mwBtn = Instance.new("TextButton")
mwBtn.Size = UDim2.fromOffset(60, 60)
mwBtn.Position = UDim2.new(0, 20, 1, -100)
mwBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mwBtn.Text = "MW"
mwBtn.TextColor3 = Color3.new(1, 1, 1)
mwBtn.TextSize = 16
mwBtn.Font = Enum.Font.GothamBlack
mwBtn.AutoButtonColor = false
mwBtn.Active = true
mwBtn.Draggable = true
mwBtn.Parent = mwBtnGui

local mwBtnCorner = Instance.new("UICorner")
mwBtnCorner.CornerRadius = UDim.new(1, 0)
mwBtnCorner.Parent = mwBtn

local mwBtnStroke = Instance.new("UIStroke")
mwBtnStroke.Thickness = 2
mwBtnStroke.Color = Color3.fromRGB(255, 255, 255)
mwBtnStroke.Transparency = 0.5
mwBtnStroke.Parent = mwBtn

mwLockBtn = Instance.new("TextButton")
mwLockBtn.Size = UDim2.fromOffset(60, 22)
mwLockBtn.Position = UDim2.new(0, 20, 1, -128)
mwLockBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
mwLockBtn.Text = "UNLOCK"
mwLockBtn.TextColor3 = Color3.new(1, 1, 1)
mwLockBtn.TextSize = 10
mwLockBtn.Font = Enum.Font.GothamBold
mwLockBtn.AutoButtonColor = false
mwLockBtn.Parent = mwBtnGui

local mwLockCorner = Instance.new("UICorner")
mwLockCorner.CornerRadius = UDim.new(1, 0)
mwLockCorner.Parent = mwLockBtn

local mwLockStroke = Instance.new("UIStroke")
mwLockStroke.Thickness = 1.5
mwLockStroke.Color = Color3.fromRGB(255, 255, 255)
mwLockStroke.Transparency = 0.5
mwLockStroke.Parent = mwLockBtn

function mwBtnUpdateUI()
    if Moonwalk.Enabled then
        mwBtn.Text = "MW ON"
        mwBtnStroke.Color = Color3.fromRGB(170, 0, 255)
        mwBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 120)
    else
        mwBtn.Text = "MW"
        mwBtnStroke.Color = Color3.fromRGB(255, 255, 255)
        mwBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    end

    if Moonwalk.Locked then
        mwLockBtn.Text = "LOCKED"
        mwLockBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        mwLockBtn.Text = "UNLOCK"
        mwLockBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    end
end

mwBtn.MouseButton1Click:Connect(function()
    if Moonwalk.Locked then
        mwBtn.Text = "X"
        task.delay(0.8, mwBtnUpdateUI)
        return
    end
    setMoonwalk(not Moonwalk.Enabled)
    mwBtnUpdateUI()
end)

mwLockBtn.MouseButton1Click:Connect(function()
    Moonwalk.Locked = not Moonwalk.Locked
    mwBtnUpdateUI()
end)

mwBtnUpdateUI()

-- HITBOX (TEXT ANGKA)
HitboxTextObjects = {}
HitboxTextOriginalSizes = {}

function hitboxCreateText(targetPart, sizeValue, color)
    if not targetPart then return end
    local char = targetPart.Parent
    if not char then return end

    local existing = char:FindFirstChild("CosmicHitboxText")
    if existing then
        local lbl = existing:FindFirstChildOfClass("TextLabel")
        if lbl then
            lbl.Text = tostring(sizeValue)
            lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
            lbl.TextSize = Hitbox.TextSize or 10
        end
        return
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CosmicHitboxText"
    billboard.Size = UDim2.new(0, 60, 0, 30)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.Adornee = targetPart
    billboard.Parent = char

    local lbl = Instance.new("TextLabel")
    lbl.Name = "HitboxLabel"
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = tostring(sizeValue)
    lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    lbl.TextStrokeTransparency = 0
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = Hitbox.TextSize or 10
    lbl.Parent = billboard

    HitboxTextObjects[targetPart] = billboard
end

function hitboxRemoveText(targetPart)
    if not targetPart then return end
    local char = targetPart.Parent
    if char then
        local billboard = char:FindFirstChild("CosmicHitboxText")
        if billboard then billboard:Destroy() end
    end
    HitboxTextObjects[targetPart] = nil
end

function hitboxClearAll()
    for part, _ in pairs(HitboxTextObjects) do
        hitboxRemoveText(part)
    end
    HitboxTextObjects = {}
    for part, origSize in pairs(HitboxTextOriginalSizes) do
        if part and part.Parent then
            part.Size = origSize
            part.Transparency = 0
        end
    end
    HitboxTextOriginalSizes = {}
end

function hitboxUpdateVisibility()
    for part, billboard in pairs(HitboxTextObjects) do
        if billboard and billboard.Parent then
            local lbl = billboard:FindFirstChildOfClass("TextLabel")
            if lbl then
                lbl.TextSize = Hitbox.TextSize or 10
                lbl.TextColor3 = Hitbox.Color or Color3.fromRGB(255, 255, 255)
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.3) do
        if not Hitbox.Enabled then
            hitboxClearAll()
            continue
        end

        local myRoot = getRoot()
        if not myRoot then continue end
        local myTeam = LP.Team and LP.Team.Name or ""

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local targetTeam = p.Team and p.Team.Name or ""
                local shouldHit = false

                if Hitbox.Mode == "Auto" then
                    if myTeam == "Survivors" and targetTeam == "Killer" then
                        shouldHit = true
                    elseif myTeam == "Killer" and targetTeam == "Survivors" then
                        shouldHit = true
                    end
                elseif Hitbox.Mode == "Killer" and targetTeam == "Killer" then
                    shouldHit = true
                elseif Hitbox.Mode == "Survivor" and targetTeam == "Survivors" then
                    shouldHit = true
                end

                if shouldHit then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local dist = (hrp.Position - myRoot.Position).Magnitude
                        if not HitboxTextOriginalSizes[hrp] then
                            HitboxTextOriginalSizes[hrp] = hrp.Size
                        end
                        if dist <= Hitbox.Size then
                            hrp.Size = Vector3.new(Hitbox.Size, Hitbox.Size, Hitbox.Size)
                            hrp.Transparency = 1
                            hrp.CanCollide = not Hitbox.WallBang
                        end

                        local color = (targetTeam == "Killer")
                            and Hitbox.ColorKiller
                            or Hitbox.ColorSurvivor

                        hitboxCreateText(hrp, Hitbox.Size, color)
                    end
                end
            end
        end
    end
end)

-- FAST VAULT + TELEPORT + NOCLIP + VISUAL
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

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    hookVault(char)
end)

if LP.Character then
    hookVault(LP.Character)
end

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
    end
end

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

-- VISUAL FUNCTIONS
origLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
}

origSky = nil
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("Sky") then
        origSky = v:Clone()
        break
    end
end

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

function applyFOV()
    local cam = workspace.CurrentCamera
    if cam then
        cam.FieldOfView = S.FOVEnabled and S.FOV or 90
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

function applyZoomOut(enable, value)
    if enable then
        LP.CameraMaxZoomDistance = value or 500
        LP.CameraMinZoomDistance = 0.5
    else
        LP.CameraMaxZoomDistance = 128
        LP.CameraMinZoomDistance = 0.5
    end
end

-- CROSSHAIR
crosshairGui = nil
crosshairParts = {}

function clearCrosshair()
    if crosshairGui then
        crosshairGui:Destroy()
        crosshairGui = nil
    end
    crosshairParts = {}
end

function applyCrosshair(enable, color, size)
    clearCrosshair()
    if not enable then return end
    local style = S.CrosshairStyle or "Plus"
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
    container.Size = UDim2.new(0, 0, 0, 0)
    container.Position = UDim2.new(0.5, offX, 0.5, offY)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundTransparency = 1
    container.Parent = crosshairGui

    local baseColor = color or S.CrosshairColor or C.ACC2

    local function mkBar(w, h, x, y)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, w, 0, h)
        f.Position = UDim2.new(0, x, 0, y)
        f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.BackgroundColor3 = baseColor
        f.BorderSizePixel = 0
        f.Parent = container
        table.insert(crosshairParts, f)
    end

    if style == "Plus" then
        mkBar(size, thickness, -size/2 - 2, 0)
        mkBar(size, thickness,  size/2 + 2, 0)
        mkBar(thickness, size, 0, -size/2 - 2)
        mkBar(thickness, size, 0,  size/2 + 2)
    end
end

-- Character Effects
trailFireObj = nil
function applyTrail(enable, color)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if trailFireObj then trailFireObj:Destroy(); trailFireObj = nil end
    if not enable then return end
    trailFireObj = Instance.new("Part")
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
    fire.Color = color or Color3.fromRGB(120, 60, 255)
    fire.Parent = trailFireObj
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
    TweenService:Create(p, TweenInfo.new(0.5), {
        Size = Vector3.new(15, 15, 15),
        Transparency = 1
    }):Play()
    task.delay(0.6, function() p:Destroy() end)
end

-- EXPORTS
_G.Roooor_applyFire = applyFire
_G.Roooor_apply8Bit = apply8Bit
_G.Roooor_applyKorblox = applyKorblox
_G.Roooor_applyHDSky = applyHDSky
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
_G.Roooor_scanKillers = AP_ScanKillers
_G.Roooor_startSkillCheck = startSkillCheck
_G.Roooor_setMoonwalk = setMoonwalk
_G.Roooor_mwBtnUpdateUI = mwBtnUpdateUI
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
_G.Roooor_applyAntiAFK = applyAntiAFK
_G.Roooor_rejoinServer = rejoinServer
_G.Roooor_updateFPSPing = updateFPSPing
_G.Roooor_hookVault = hookVault
_G.Roooor_hitboxClearAll = hitboxClearAll
_G.Roooor_hitboxUpdateVisibility = hitboxUpdateVisibility
_G.Roooor_GetGeneratorProgress = GetGeneratorProgress

_G.AP_ScanKillers = AP_ScanKillers
_G.AP_ClearCircle = AP_ClearCircle
_G.AP_GetCount = function() return AP_parryCount end
_G.AP_Config = AP_Config

print("✅ [4/13] COSMIC - ESP + Auto Parry + Moonwalk + Hitbox Loaded")
print("🛡️ Auto Parry: Radius 15 | Debounce 0.2 | Face 0.7")
print("📊 ESP Gen: Classic + Bar")
print("⚡ Auto Skill Check: Fallens Style (Perfect 102-116°)")-- =========================================================
-- SECTION 5/13 : FITUR AKTIF + LOOP UTAMA
-- =========================================================

-- GABUNGAN RENDERSTEPPED (3 → 1)
RunService.RenderStepped:Connect(function()
    -- Auto Parry Circle
    if AutoParry.Enabled then
        pcall(AP_UpdateCircle)
    end

    -- FOV Anti-Override
    if S.FOVEnabled then
        local cam = workspace.CurrentCamera
        if cam and math.abs(cam.FieldOfView - S.FOV) > 0.5 then
            pcall(function() cam.FieldOfView = S.FOV end)
        end
    end

    -- Moonwalk
    if Moonwalk.Enabled and not ParryActive and not mwIsDowned() then
        local char = LP.Character
        if char and char.Parent then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local cam = workspace.CurrentCamera
            if humanoid and hrp and cam then
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
            end
        end
    end
end)

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

task.spawn(function()
    while task.wait(120) do
        if S.AntiAFK then
            pcall(function()
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
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
    lbl.Text = killerName .. " > " .. survivorName
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
    icon.Text = "STUN"
    icon.TextColor3 = Color3.fromRGB(220, 180, 255)
    icon.TextSize = 20
    icon.Font = Enum.Font.GothamBlack
    icon.TextStrokeTransparency = 0
    icon.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    icon.Parent = billboard
    task.spawn(function()
        while billboard.Parent do
            billboard.StudsOffset = Vector3.new(0, 4 + math.sin(tick() * 5) * 0.5, 0)
            icon.Rotation = math.sin(tick() * 8) * 20
            task.wait(0.08)
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
    while task.wait(0.3) do
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

-- AUTO WIGGLE
task.spawn(function()
    while task.wait(1) do
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

-- AUTO FLEE
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

_G.CachedGenPoints = nil
_G.CachedGenPointsTime = 0

function GetFarthestGeneratorPoint(killerRoot)
    if not killerRoot then return nil end
    if not _G.CachedGenPoints or tick() - _G.CachedGenPointsTime > 3 then
        _G.CachedGenPoints = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and string.match(obj.Name, "^GeneratorPoint%d+$") then
                table.insert(_G.CachedGenPoints, obj)
            end
        end
        _G.CachedGenPointsTime = tick()
    end

    local bestPoint, farthestDistance = nil, 0
    for _, obj in ipairs(_G.CachedGenPoints) do
        if obj and obj.Parent then
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

-- AUTO CARRY + HOOK
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
    while task.wait(3) do
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
    if now - lastESPUpdate >= 0.2 then
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
    while task.wait(2) do
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

print("✅ [5/13] COSMIC - Fitur Aktif + Loop Utama Loaded")
print("⚡ RenderStepped: 3 → 1")
print("⚡ ESP Loop: 0.2s | Anti-AFK: 120s")-- =========================================================
-- SECTION 6/13 : GUI COSMIC + TOMBOL + PANEL
-- =========================================================

gui = Instance.new("ScreenGui")
gui.Name = "CosmicHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PG

-- TOMBOL MENU COSMIC
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
mainBtn.Text = "C"
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
        t = t + 0.05
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
        task.wait(0.05)
    end
end)

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

-- PANEL MENU
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
        for i = 0, 1, 0.08 do
            if not neonLine.Parent then break end
            neonGrad.Rotation = i * 360
            task.wait(0.1)
        end
    end
end)

local hTitle = Instance.new("TextLabel")
hTitle.Size = UDim2.new(1, -80, 1, 0)
hTitle.Position = UDim2.new(0, 16, 0, 0)
hTitle.BackgroundTransparency = 1
hTitle.Text = "COSMIC"
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
closeBtn.Text = "X"
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

-- KOMPONEN UI
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
    local state
    if saved ~= nil then
        state = saved
    else
        state = def
    end
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

-- DROPDOWN PERSISTENT
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

    _G.DropdownStates = _G.DropdownStates or {}
    local savedIdx = _G.DropdownStates[name]
    local idx = savedIdx or 1
    if not savedIdx then
        for i, o in ipairs(options) do
            if o == def then idx = i end
        end
        _G.DropdownStates[name] = idx
    end
    local cur = options[idx]

    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0.5, -24, 1, 0)
    v.Position = UDim2.new(0.5, 0, 0, 0)
    v.BackgroundTransparency = 1
    v.Text = tostring(cur) .. " >"
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
        _G.DropdownStates[name] = idx
        v.Text = tostring(cur) .. " >"
        if cb then pcall(cb, cur) end
    end)

    if cb and savedIdx then
        task.defer(function()
            pcall(cb, cur)
        end)
    end
end

-- 🆕 MAKE TAB DENGAN ICON EMOJI
activeTab = nil
function makeTab(name, icon, order, cb)
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
    ind.BackgroundColor3 = C.ACC2
    ind.BorderSizePixel = 0
    ind.Parent = b
    rnd(ind, 2)

    local ico = Instance.new("TextLabel")
    ico.Size = UDim2.new(0, 24, 1, 0)
    ico.Position = UDim2.new(0, 4, 0, 0)
    ico.BackgroundTransparency = 1
    ico.Text = icon
    ico.TextColor3 = C.DIM
    ico.TextSize = 16
    ico.Font = Enum.Font.GothamBold
    ico.Parent = b

    local lblT = Instance.new("TextLabel")
    lblT.Size = UDim2.new(1, -30, 1, 0)
    lblT.Position = UDim2.new(0, 30, 0, 0)
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

print("✅ [6/13] COSMIC - GUI + Tombol + Panel Loaded")
print("🆕 Dropdown persistent + icon emoji")-- =========================================================
-- SECTION 7/13 : TAB UI PART 1
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

-- TAB 1: SURVIVOR
makeTab("Survivor", "🏃", 1, function()

    sec("Auto Parry (MULTI-LAYER)", "🛡️")
    tog("Enable Auto Parry", false, function(s)
        AutoParry.Enabled = s
    end)
    lbl("Radius 15 | Debounce 0.2 | Face 0.7", C.GRN)
    lbl("Face + Attribute + Velocity Check", C.FIRE_BRIGHT)

    sl("Parry Distance", 5, 40, 15, function(v)
        AutoParry.ParryDistance = v
        AP_Config.Radius = v
    end)
    lbl("Default 15", C.GRN)

    sl("Debounce", 0.05, 1, 0.2, function(v)
        AP_PARRY_DEBOUNCE = v
        AP_Config.Debounce = v
    end)
    lbl("Default 0.2", C.FIRE_BRIGHT)

    sl("Face Sensitivity", 0, 1, 0.7, function(v)
        AP_Config.FaceSensitivity = v
    end)
    lbl("Default 0.7", C.GRN)

    tog("Enable Face Check", true, function(s)
        AP_Config.EnableFaceCheck = s
    end)
    lbl("Wajib killer ngadep lo", C.DIM)

    tog("Enable Attribute Check", true, function(s)
        AP_Config.EnableAttributeCheck = s
    end)
    lbl("Cek IsAttacking attribute", C.DIM)

    tog("Enable Velocity Check", true, function(s)
        AP_Config.EnableVelocityCheck = s
    end)
    lbl("Cek killer gerak ke arah lo", C.DIM)

    sl("Circle Height", -5, 15, -2.5, function(v)
        AP_ESPCircle.YOffset = v
    end)
    lbl("-2.5 = rata tanah", C.GRN)

    tog("Show Circle", true, function(s)
        AP_ESPCircle.Enabled = s
        if not s then AP_ClearCircle() end
    end)
    lbl("Hijau aman | Merah killer masuk", C.FIRE_BRIGHT)

    btn("Reset Parry Counter", function()
        AP_parryCount = 0
    end)

    sec("Auto Skill Check (2 MODE)", "⚡")
    tog("Enable Auto Skill Check", true, function(s)
        SkillCheck.Enabled = s
        if s then startSkillCheck() end
    end)

    drp("Mode", {"Perfect", "Instant"}, "Perfect", function(v)
        SkillCheck.Mode = v
    end)
    lbl("Perfect = Fallens Style (102-116°)", C.FIRE_BRIGHT)
    lbl("Support King's Scourge ✅", C.GRN)

    tog("Hide Needle (Instant only)", false, function(s)
        SkillCheck.HideNeedle = s
    end)

    btn("Reset Counter", function()
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

    sec("Fast Vault", "⚡")
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
end)

-- TAB 2: KILLER
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

-- TAB 3: ESP
makeTab("ESP", "👁️", 3, function()
    sec("Player ESP", "🟢")
    tog("ESP Survivor", true, function(s) ESP.Survivor = s end)
    cpk("Survivor Color", TeamColors.Survivor, function(c) TeamColors.Survivor = c end)
    tog("ESP Killer", true, function(s) ESP.Killer = s end)
    cpk("Killer Color", TeamColors.Killer, function(c) TeamColors.Killer = c end)

    sec("Object ESP", "⚡")
    tog("ESP Generator", true, function(s) ESP.Generator = s end)
    cpk("Gen Color", GeneratorColor, function(c) GeneratorColor = c end)

    drp("Generator Mode", {"Classic", "Bar"}, "Classic", function(v)
        S.ESPGenMode = v
        for gen in pairs(Cached.Generators) do
            local a = gen:FindFirstChild("GenESP")
            if a then a:Destroy() end
            local b = gen:FindFirstChild("GenESPBar")
            if b then b:Destroy() end
        end
    end)
    lbl("Classic = [%] di atas | Bar = angka di dalam bar", C.FIRE_BRIGHT)

    sl("Bar Width", 40, 200, 80, function(v)
        S.ESPGenBarSize = v
        for gen in pairs(Cached.Generators) do
            local b = gen:FindFirstChild("GenESPBar")
            if b then
                b.Size = UDim2.new(0, v, 0, S.ESPGenBarHeight or 14)
            end
        end
    end)
    lbl("Default 80", C.GRN)

    sl("Bar Height", 8, 40, 14, function(v)
        S.ESPGenBarHeight = v
        for gen in pairs(Cached.Generators) do
            local b = gen:FindFirstChild("GenESPBar")
            if b then
                b.Size = UDim2.new(0, S.ESPGenBarSize or 80, 0, v)
            end
        end
    end)
    lbl("Default 14", C.GRN)

    sl("Text Size", 6, 30, 10, function(v)
        S.ESPGenBarTextSize = v
        for gen in pairs(Cached.Generators) do
            local b = gen:FindFirstChild("GenESPBar")
            if b then
                local bg = b:FindFirstChild("BarBg")
                if bg then
                    local t = bg:FindFirstChild("PctText")
                    if t then t.TextSize = v end
                end
            end
        end
    end)
    lbl("Default 10", C.GRN)

    tog("ESP Pallet", true, function(s) ESP.Pallet = s end)
    cpk("Pallet Color", PalletColor, function(c) PalletColor = c end)
    tog("ESP Window", true, function(s) ESP.Window = s end)
    cpk("Window Color", WindowColor, function(c) WindowColor = c end)
    tog("ESP SCP", true, function(s) ESP.SCP = s end)
    cpk("SCP Color", SCPColor, function(c) SCPColor = c end)

    sec("ESP Distance", "📏")
    sl("ESP Radius", 10, 1000, 1000, function(v) ESP.Distance = v end)
    lbl("Max 1000 (default 1000)", C.GRN)

    sec("Status ESP", "🟢")
    tog("Enable Status ESP", true, function(s) ESPStatus.Enabled = s end)
    tog("Show Name", true, function(s) ESPStatus.ShowName = s end)
    tog("Show Distance", true, function(s) ESPStatus.ShowDistance = s end)
    tog("Show Health", true, function(s) ESPStatus.ShowHealth = s end)
    sl("Status Radius", 20, 1000, 1000, function(v) ESPStatus.Radius = v end)

    sec("Nama Mode", "✨")
    drp("Name Mode", {"Text", "Galaxy"}, "Galaxy", function(v)
        S.ESPNameMode = v
    end)
    lbl("Default: Galaxy (animated rainbow)", C.GRN)
    sl("Name Size", 8, 30, 9.35, function(v)
        S.ESPNameSize = v
    end)
    lbl("Default: 9.35", C.GRN)
end)

-- TAB 4: FIRE
makeTab("Fire", "🔥", 4, function()
    sec("Fire Control", "⚙️")
    tog("Enable Fire", true, function(s)
        S.FireOn = s
        applyFire()
    end)
    lbl("Default ON: CosmicFire", C.GRN)

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
        btnLbl.Text = fireName
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

-- TAB 5: MOONWALK
makeTab("Moonwalk", "🕺", 5, function()

    sec("Moonwalk (TOMBOL MW ONLY)", "🕺")
    lbl("Cukup tombol MW di pojok layar", C.FIRE_BRIGHT)
    lbl("Klik MW = ON/OFF", C.GRN)
    lbl("Klik tombol LOCK = Lock state", C.ACC2)
    lbl("Tekan V juga bisa toggle", C.DIM)

    tog("Enable Moonwalk", Moonwalk.Enabled, function(s)
        if setMoonwalk then
            setMoonwalk(s)
        else
            Moonwalk.Enabled = s
        end
        if _G.Roooor_mwBtnUpdateUI then pcall(_G.Roooor_mwBtnUpdateUI) end
    end)

    sec("Lock", "🔒")
    tog("Lock Moonwalk", Moonwalk.Locked, function(s)
        Moonwalk.Locked = s
        if _G.Roooor_mwBtnUpdateUI then pcall(_G.Roooor_mwBtnUpdateUI) end
    end)

    sec("Tombol MW", "🎯")
    tog("Show MW Button", Moonwalk.ShowButton, function(s)
        Moonwalk.ShowButton = s
        if mwBtnGui then mwBtnGui.Enabled = s end
    end)

    btn("Reset Posisi Tombol MW", function()
        if mwBtn then
            mwBtn.Position = UDim2.new(0, 20, 1, -100)
        end
        if mwLockBtn then
            mwLockBtn.Position = UDim2.new(0, 20, 1, -128)
        end
    end)

    sec("Setting Internal", "⚙️")
    sl("Spam Speed", 1, 50, Moonwalk.SpamSpeed, function(v)
        Moonwalk.SpamSpeed = v
    end)

    sl("Intensity", 1, 50, Moonwalk.Intensity, function(v)
        Moonwalk.Intensity = v
    end)

    sl("Slow Speed", 5, 20, Moonwalk.SlowSpeed, function(v)
        Moonwalk.SlowSpeed = v
    end)

    tog("Use Slow Speed", Moonwalk.UseSlow, function(s)
        Moonwalk.UseSlow = s
    end)
end)

print("✅ [7/13] COSMIC - Survivor + Killer + ESP + Fire + Moonwalk Loaded")
print("🛡️ Auto Parry: Radius 15 | Debounce 0.2 | Face 0.7")-- =========================================================
-- SECTION 8/13 : TAB UI PART 2
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

-- TAB 7: MISC
makeTab("Misc", "⚙️", 7, function()

    sec("Movement", "🏃")
    tog("Walk Speed", false, function(s) S.WalkSpeed = s end)
    sl("Walk Speed Value", 16, 100, 16, function(v) S.WalkSpeedVal = v end)

    tog("Speed Hack", false, function(s) S.SpeedHack = s end)
    sl("Speed Hack Value", 20, 200, 40, function(v) S.SpeedHackVal = v end)

    tog("No Clip", false, function(s) S.NoClip = s end)
    tog("No Clip Camera", false, function(s) S.NoClipCamera = s end)

    sec("FOV (Default 90)", "🎥")
    lbl("Default FOV: 90 (auto ON)", C.GRN)
    lbl("Klik preset buat ganti FOV", C.FIRE_BRIGHT)

    local FOV70Btn = Instance.new("TextButton")
    FOV70Btn.Size = UDim2.new(0.32, -3, 0, 30)
    FOV70Btn.Position = UDim2.new(0, 0, 0, 0)
    FOV70Btn.BackgroundColor3 = C.BG
    FOV70Btn.BackgroundTransparency = 0.4
    FOV70Btn.Text = "FOV 70"
    FOV70Btn.TextColor3 = C.TXT
    FOV70Btn.TextSize = 10
    FOV70Btn.Font = Enum.Font.GothamBold
    FOV70Btn.BorderSizePixel = 0
    FOV70Btn.AutoButtonColor = false
    FOV70Btn.Parent = cs
    rnd(FOV70Btn, 8)
    strk(FOV70Btn, C.ACC, 1, 0.5)

    local FOV90Btn = Instance.new("TextButton")
    FOV90Btn.Size = UDim2.new(0.32, -3, 0, 30)
    FOV90Btn.Position = UDim2.new(0.34, 0, 0, 0)
    FOV90Btn.BackgroundColor3 = C.BG
    FOV90Btn.BackgroundTransparency = 0.4
    FOV90Btn.Text = "FOV 90"
    FOV90Btn.TextColor3 = C.GRN
    FOV90Btn.TextSize = 10
    FOV90Btn.Font = Enum.Font.GothamBold
    FOV90Btn.BorderSizePixel = 0
    FOV90Btn.AutoButtonColor = false
    FOV90Btn.Parent = cs
    rnd(FOV90Btn, 8)
    strk(FOV90Btn, C.GRN, 1.5, 0.2)

    local FOV120Btn = Instance.new("TextButton")
    FOV120Btn.Size = UDim2.new(0.32, -3, 0, 30)
    FOV120Btn.Position = UDim2.new(0.68, 0, 0, 0)
    FOV120Btn.BackgroundColor3 = C.BG
    FOV120Btn.BackgroundTransparency = 0.4
    FOV120Btn.Text = "FOV 120"
    FOV120Btn.TextColor3 = C.TXT
    FOV120Btn.TextSize = 10
    FOV120Btn.Font = Enum.Font.GothamBold
    FOV120Btn.BorderSizePixel = 0
    FOV120Btn.AutoButtonColor = false
    FOV120Btn.Parent = cs
    rnd(FOV120Btn, 8)
    strk(FOV120Btn, C.ACC, 1, 0.5)

    local function updateFOVButtons(activeFOV)
        if activeFOV == 70 then
            FOV70Btn.BackgroundColor3 = C.ACC
            FOV70Btn.BackgroundTransparency = 0
            FOV70Btn.TextColor3 = Color3.new(1, 1, 1)
            FOV90Btn.BackgroundColor3 = C.BG
            FOV90Btn.BackgroundTransparency = 0.4
            FOV90Btn.TextColor3 = C.TXT
            FOV120Btn.BackgroundColor3 = C.BG
            FOV120Btn.BackgroundTransparency = 0.4
            FOV120Btn.TextColor3 = C.TXT
        elseif activeFOV == 90 then
            FOV90Btn.BackgroundColor3 = C.GRN
            FOV90Btn.BackgroundTransparency = 0
            FOV90Btn.TextColor3 = Color3.new(0, 0, 0)
            FOV70Btn.BackgroundColor3 = C.BG
            FOV70Btn.BackgroundTransparency = 0.4
            FOV70Btn.TextColor3 = C.TXT
            FOV120Btn.BackgroundColor3 = C.BG
            FOV120Btn.BackgroundTransparency = 0.4
            FOV120Btn.TextColor3 = C.TXT
        elseif activeFOV == 120 then
            FOV120Btn.BackgroundColor3 = C.ACC
            FOV120Btn.BackgroundTransparency = 0
            FOV120Btn.TextColor3 = Color3.new(1, 1, 1)
            FOV70Btn.BackgroundColor3 = C.BG
            FOV70Btn.BackgroundTransparency = 0.4
            FOV70Btn.TextColor3 = C.TXT
            FOV90Btn.BackgroundColor3 = C.BG
            FOV90Btn.BackgroundTransparency = 0.4
            FOV90Btn.TextColor3 = C.TXT
        end
    end

    FOV70Btn.MouseButton1Click:Connect(function()
        S.FOV = 70
        S.FOVEnabled = true
        applyFOV()
        updateFOVButtons(70)
        playToggleSound()
    end)

    FOV90Btn.MouseButton1Click:Connect(function()
        S.FOV = 90
        S.FOVEnabled = true
        applyFOV()
        updateFOVButtons(90)
        playToggleSound()
    end)

    FOV120Btn.MouseButton1Click:Connect(function()
        S.FOV = 120
        S.FOVEnabled = true
        applyFOV()
        updateFOVButtons(120)
        playToggleSound()
    end)

    updateFOVButtons(S.FOV or 90)

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

    tog("Show FPS Counter", true, function(s) S.ShowFPS = s end)
    tog("Show Ping Counter", true, function(s) S.ShowPing = s end)

    btn("Rejoin Server", function() rejoinServer() end)
end)

-- TAB 9: VISUAL
makeTab("Visual", "✨", 9, function()

    sec("Fullbright & No Fog", "💡")
    tog("Fullbright", false, function(s)
        S.Fullbright = s
        applyFullbright(s)
    end)
    sl("Brightness Level", 10, 200, 100, function(v)
        S.FullbrightVal = v
        if S.Fullbright then applyFullbright(true) end
    end)

    tog("No Fog", false, function(s)
        S.NoFog = s
        applyNoFog(s)
    end)

    sec("HD Sky (Clean)", "🔷")
    tog("HD Sky (Clean)", false, function(s)
        S.HDSky = s
        applyHDSky(s)
    end)
    lbl("Langit jernih + atmosphere tipis", C.FIRE_BRIGHT)

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
    tog("Contrast Boost", true, function(s) S.Contrast = s; applyContrast() end)
    lbl("Default: ON", C.GRN)
    sl("Contrast", 0, 1, 0.3, function(v) S.ContrastVal = v; applyContrast() end)
    sl("Saturation", 0, 1, 0.2, function(v) S.SaturationVal = v; applyContrast() end)

    sec("Sky (18 Preset)", "🌌")
    drp("Sky Preset", SkyList, "SunsetHD", function(v)
        S.SkyId = v
        applySky(v)
    end)
    lbl("Default: SunsetHD (auto ON)", C.GRN)

    sec("Camera", "🎥")
    lbl("FOV pindah ke Tab Misc (70/90/120)", C.FIRE_BRIGHT)
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

    sec("Crosshair 8 Mode", "🎯")
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

    sec("FPS Boost", "🚀")
    tog("No Screen Effects", false, function(s)
        S.NoScreenEffects = s
        applyNoScreenEffects()
    end)
    lbl("Matikan blur, bloom, DOF", C.GRN)

    tog("Low Graphics", false, function(s)
        S.LowGraphics = s
        applyLowGraphics()
    end)
    lbl("Quality Level 1", C.GRN)

    tog("Clean Sky", false, function(s)
        S.CleanSky = s
        applyCleanSky()
    end)
    lbl("Hapus Sky (FPS boost)", C.GRN)

    sec("Info", "ℹ️")
    lbl("Moonwalk: Tombol MW / Tekan V", C.FIRE_BRIGHT)
    lbl("Auto Parry: Tab Survivor", C.FIRE_BRIGHT)
    lbl("Hitbox: Tab Hitbox", C.FIRE_BRIGHT)
    lbl("Aimbot: Tab Aimbot", C.FIRE_BRIGHT)

    sec("Danger Zone", "⚠️")
    btn("UNLOAD COSMIC HUB", function()
        pcall(function()
            if gui then gui:Destroy() end
            if killFeedGui then killFeedGui:Destroy() end
            if loadingGui then loadingGui:Destroy() end
            if crosshairGui then crosshairGui:Destroy() end
            if fpsPingGui then fpsPingGui:Destroy() end
            if mwBtnGui then mwBtnGui:Destroy() end
            if Aimlock_Gui then Aimlock_Gui:Destroy() end
            clear8Bit()
            clearKorblox()
            AP_ClearCircle()
            hitboxClearAll()
        end)
        _G.RoooorS = nil
        _G.Roooor_ESP = nil
        _G.Roooor_ESPStatus = nil
        _G.Roooor_AutoParry = nil
        _G.Roooor_SkillCheck = nil
        _G.Roooor_Moonwalk = nil
        _G.Roooor_Hitbox = nil
        _G.Roooor_GodMode = nil
        _G.RoooorAimlock = nil
    end)
end)

-- TAB 10: HITBOX
makeTab("Hitbox", "📦", 10, function()

    sec("Hitbox Control (TEXT ANGKA)", "📦")
    tog("Enable Hitbox", false, function(s)
        Hitbox.Enabled = s
        if not s then hitboxClearAll() end
    end)
    lbl("Text angka di atas kepala target", C.FIRE_BRIGHT)

    sl("Hitbox Size (Radius)", 10, 70, 70, function(v)
        Hitbox.Size = v
        hitboxUpdateVisibility()
    end)
    lbl("Max 70 studs (default 70)", C.GRN)

    sl("Text Size", 5, 30, 10, function(v)
        Hitbox.TextSize = v
        hitboxUpdateVisibility()
    end)
    lbl("Besar-kecil text di kepala", C.GRN)

    sec("Mode Target", "🎯")
    drp("Mode", {"Auto", "Killer", "Survivor"}, "Auto", function(v)
        Hitbox.Mode = v
    end)
    lbl("Auto = deteksi tim kita", C.DIM)

    sec("Text Color", "🎨")
    cpk("Killer Text Color", Hitbox.ColorKiller, function(c)
        Hitbox.ColorKiller = c
        hitboxUpdateVisibility()
    end)

    cpk("Survivor Text Color", Hitbox.ColorSurvivor, function(c)
        Hitbox.ColorSurvivor = c
        hitboxUpdateVisibility()
    end)

    sec("Advanced", "⚙️")
    tog("Wall Bang (tembus tembok)", true, function(s)
        Hitbox.WallBang = s
    end)
end)

print("✅ [8/13] COSMIC - Misc + Visual + Hitbox Loaded")-- =========================================================
-- SECTION 9/13 : AUTO RE-APPLY + KEYBIND
-- =========================================================

-- AUTO APPLY SEMUA SAAT EXECUTE
task.spawn(function()
    task.wait(4)

    if S.FireOn then
        pcall(applyFire)
        print("[AUTO] Fire applied:", S.FireType)
    end

    if S.SkyId and S.SkyId ~= "Default" then
        pcall(function()
            applySky(S.SkyId)
        end)
        S.SkyAutoApplied = true
        print("[AUTO] Sky applied:", S.SkyId)
    end

    if S.Contrast then
        pcall(applyContrast)
        print("[AUTO] Contrast applied")
    end

    if S.FOVEnabled then
        pcall(applyFOV)
        print("[AUTO] FOV applied:", S.FOV)
    end

    print("[AUTO] ESP Name Mode:", S.ESPNameMode, "| Size:", S.ESPNameSize)
    print("[AUTO] ESP Gen Mode:", S.ESPGenMode)
    print("[AUTO] Auto Parry: Radius 15 | Debounce 0.2 | Face 0.7")
end)

-- AUTO RE-APPLY SAAT RESPAWN
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    if S.FireOn then pcall(applyFire) end
    if S.EightBitOn then
        pcall(function() apply8Bit(true, "Royal Crown", S.EightBitSize, S.EightBitHeight) end)
    end
    if S.Korblox then
        pcall(function() applyKorblox(true, "Pencil", S.KorbloxYOffset, S.KorbloxScale) end)
    end
    if S.Trail then pcall(function() applyTrail(true, S.TrailColor) end) end
    if S.Aura then pcall(function() applyAura(true, S.AuraColor) end) end
    if S.Headless then pcall(function() applyHeadless(true) end) end
    if S.FOVEnabled then pcall(applyFOV) end
    if S.SkyId and S.SkyId ~= "Default" then pcall(function() applySky(S.SkyId) end) end
    if S.Contrast then pcall(applyContrast) end
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
    pcall(function() hookVault(char) end)
end)

task.spawn(function()
    while task.wait(1) do
        if AutoParry.Enabled then AP_ScanKillers() end
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        task.wait(1)
        if AutoParry.Enabled then
            if p.Team and p.Team.Name == "Killer" then
                AP_HookKiller(char)
            end
        end
    end)
end)

-- KEYBIND V UNTUK MOONWALK
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.V then
        if Moonwalk.Locked then
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "Moonwalk",
                    Text = "LOCKED!",
                    Duration = 1
                })
            end)
            return
        end

        setMoonwalk(not Moonwalk.Enabled)
        if _G.Roooor_mwBtnUpdateUI then pcall(_G.Roooor_mwBtnUpdateUI) end

        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Moonwalk",
                Text = Moonwalk.Enabled and "ON" or "OFF",
                Duration = 1.5
            })
        end)
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
        if AutoParry.Enabled then pcall(AP_ScanKillers) end
        if SkillCheck.Enabled then pcall(startSkillCheck) end
        if FastVault.Enabled then
            pcall(function() hookVault(LP.Character) end)
        end
    end
end)

print("✅ [9/13] COSMIC - Auto Re-Apply + Keybind V Loaded")
print("🔥 Fire:", S.FireType, "(auto ON)")
print("🔷 Sky:", S.SkyId, "(auto ON)")
print("🎨 Contrast:", S.Contrast, "(auto ON)")
print("🎥 FOV:", S.FOV, "(auto ON)")
print("🛡️ Auto Parry: Radius 15 | Debounce 0.2")-- =========================================================
-- SECTION 10/13 : LOGIC FITUR BARU + FIX FOV BIND
-- =========================================================

-- AUTO WIGGLE LOOP
task.spawn(function()
    while task.wait(1) do
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

-- AUTO FLEE LOOP
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

-- AUTO ESCAPE LOOP
task.spawn(function()
    while task.wait(3) do
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

-- FAST VAULT HOOK
LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    if FastVault.Enabled then
        pcall(function() hookVault(char) end)
    end
end)

if LP.Character then
    pcall(function() hookVault(LP.Character) end)
end

-- AUTO CARRY LOOP
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

-- FPS BOOST LOOP
task.spawn(function()
    while task.wait(1) do
        if S.NoScreenEffects then applyNoScreenEffects() end
        if S.LowGraphics then applyLowGraphics() end
        if S.CleanSky then applyCleanSky() end
    end
end)

-- GABUNG SKY + FIRE AUTO-REAPPLY (2 → 1)
task.spawn(function()
    while task.wait(8) do
        -- Sky check
        if S.SkyId and S.SkyId ~= "Default" then
            local currentSky = nil
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("Sky") then
                    currentSky = v
                    break
                end
            end
            if not currentSky or not currentSky.Name:find("CosmicSky_") then
                pcall(function() applySky(S.SkyId) end)
            end
        end
        -- Fire check
        if S.FireOn and LP.Character then
            local head = LP.Character:FindFirstChild("Head")
            if head and not head:FindFirstChild("RoooorFire") then
                pcall(applyFire)
            end
        end
    end
end)

print("✅ [10/13] COSMIC - Logic Fitur Baru Loaded")
print("⚡ Sky+Fire Auto-Reapply: 1 loop (8s)")-- =========================================================
-- SECTION 11/13 : PRINT FINAL
-- =========================================================
task.wait(0.5)

print("╔══════════════════════════════════════════╗")
print("║  COSMIC HUB                              ║")
print("║  SEMUA FITUR LOADED                      ║")
print("╠══════════════════════════════════════════╣")
print("║  AUTO ON SAAT EXECUTE:                   ║")
print("║     -> Fire: CosmicFire                  ║")
print("║     -> ESP: Galaxy Mode (Size 9.35)      ║")
print("║     -> Contrast: ON                      ║")
print("║     -> Sky: SunsetHD                     ║")
print("║     -> FOV: 90 (Tab Misc)                ║")
print("║     -> Auto Parry: Radius 15             ║")
print("║     -> Auto Parry: Debounce 0.2          ║")
print("║     -> Auto Parry: Face 0.7              ║")
print("╠══════════════════════════════════════════╣")
print("║  AUTO PARRY (MULTI-LAYER)                ║")
print("║     -> Animasi Killer (28 ID)            ║")
print("║     -> Radius + Jarak                    ║")
print("║     -> Face Check (0.7)                  ║")
print("║     -> Attribute Check                   ║")
print("║     -> Velocity Check                    ║")
print("║     -> Proximity Pre-Trigger             ║")
print("║     -> Camera Freeze FIX                 ║")
print("╠══════════════════════════════════════════╣")
print("║  AUTO SKILL CHECK (2 MODE)               ║")
print("║     -> Instant: paksa sukses             ║")
print("║     -> Perfect: Fallens Style            ║")
print("║     -> Support King's Scourge            ║")
print("╠══════════════════════════════════════════╣")
print("║  FITUR LAIN:                             ║")
print("║     -> Moonwalk (Tombol MW + LOCK)       ║")
print("║     -> Fast Vault                        ║")
print("║     -> Auto Wiggle                       ║")
print("║     -> Auto Flee Killer                  ║")
print("║     -> Auto Escape Gate                  ║")
print("║     -> Auto Carry + Hook                 ║")
print("║     -> FPS Boost (3 Mode)                ║")
print("║     -> Crosshair 8 Mode                  ║")
print("║     -> Hitbox (TEXT ANGKA)               ║")
print("║     -> God Mode                          ║")
print("║     -> 8-Bit Royal Crown                 ║")
print("║     -> Korblox Pencil                    ║")
print("║     -> HD Sky (Jernih)                   ║")
print("║     -> Sky 18 PRESET                     ║")
print("║     -> ESP Galaxy (Animated)             ║")
print("║     -> ESP Generator (Classic + Bar)     ║")
print("║     -> Anti-AFK + Rejoin                 ║")
print("║     -> FPS + Ping Counter                ║")
print("╠══════════════════════════════════════════╣")
print("║  ANTI-ILANG MENU (Section 13)            ║")
print("║     -> ResetOnSpawn = false              ║")
print("║     -> Recovery Loop                     ║")
print("║     -> Respawn Re-apply                  ║")
print("║     -> Place Change Detect               ║")
print("╠══════════════════════════════════════════╣")
print("║  Buka menu: Klik tombol C                ║")
print("║  FOV: Tab Misc (70/90/120)               ║")
print("║  Aimbot: Tab Aimbot (Section 12)         ║")
print("║  Hitbox: Tab Hitbox                      ║")
print("╚══════════════════════════════════════════╝")

print("✅ [11/13] COSMIC - FINAL LOADED!")
print("🔥 Fire: CosmicFire (auto ON)")
print("🌈 ESP: Galaxy Mode (Size 9.35)")
print("🎨 Contrast: ON")
print("🔷 Sky: SunsetHD (auto ON)")
print("🎥 FOV: 90 (auto ON)")
print("🛡️ Auto Parry: Radius 15 | Debounce 0.2 | Face 0.7")
print("⚡ Auto Skill Check: Fallens Style")-- =========================================================
-- SECTION 12/13 : AIMBOT (TAB AIMBOT COSMIC)
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

-- AIMBOT CORE
Aimlock_AttackButtons = Aimlock_AttackButtons or {}

local function isAttackButton(obj)
    if not obj:IsA("GuiObject") then return false end
    local n = string.lower(obj.Name)
    if n:find("attack") or n:find("slash") or n:find("swing") or n:find("hit") then
        return true
    end
    return false
end

function Aimlock_ScanAttackButtons()
    table.clear(Aimlock_AttackButtons)
    for _, obj in pairs(PG:GetDescendants()) do
        if isAttackButton(obj) and obj.Visible then
            table.insert(Aimlock_AttackButtons, obj)
        end
    end
    print("[AIMBOT] Found " .. #Aimlock_AttackButtons .. " attack button(s)")
end

function Aimlock_HookAttackButtons()
    Aimlock_ScanAttackButtons()

    for _, btnObj in ipairs(Aimlock_AttackButtons) do
        if not btnObj:GetAttribute("AimlockHooked") then
            btnObj:SetAttribute("AimlockHooked", true)

            btnObj.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch
                   or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Aimlock.Holding = true
                end
            end)

            btnObj.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch
                   or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Aimlock.Holding = false
                end
            end)
        end
    end
end

task.spawn(function()
    while task.wait(5) do
        if Aimlock.Enabled then
            Aimlock_HookAttackButtons()
        end
    end
end)

function Aimlock_GetClosestSurvivor()
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local closest = nil
    local shortest = Aimlock.Radius

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local isTarget = false
            if p.Team and p.Team.Name == Aimlock.TargetTeam then
                isTarget = true
            end

            if isTarget then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local targetPart = p.Character:FindFirstChild(Aimlock.AimPart)

                local isDowned = false
                if hum then
                    isDowned = hum.Health <= 0
                        or hum.Health < 2
                        or p.Character:GetAttribute("Downed") == true
                        or p.Character:GetAttribute("IsDown") == true
                        or p.Character:GetAttribute("Knocked") == true
                        or hum:GetState() == Enum.HumanoidStateType.Dead
                        or hum:GetState() == Enum.HumanoidStateType.Physics
                end

                if not isDowned and hum and hum.Health > 0 and targetPart then
                    local dist = (targetPart.Position - myRoot.Position).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = targetPart
                    end
                end
            end
        end
    end
    return closest
end

Aimlock_CameraConn = nil

function Aimlock_StartLoop()
    if Aimlock_CameraConn then return end

    Aimlock_CameraConn = RunService.RenderStepped:Connect(function()
        if not Aimlock.Enabled then return end
        if not Aimlock.Holding then return end

        local cam = workspace.CurrentCamera
        if not cam then return end

        local target = Aimlock_GetClosestSurvivor()
        if not target then return end

        Aimlock.CurrentTarget = target

        local camPos = cam.CFrame.Position
        local targetPos = target.Position

        cam.CFrame = CFrame.new(camPos, targetPos)
    end)
end

function Aimlock_StopLoop()
    if Aimlock_CameraConn then
        Aimlock_CameraConn:Disconnect()
        Aimlock_CameraConn = nil
    end
    Aimlock.CurrentTarget = nil

    local cam = workspace.CurrentCamera
    local char = LP.Character
    if cam and char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                cam.CameraType = Enum.CameraType.Custom
                cam.CameraSubject = hum
            end)
        end
    end
end

-- FLOATING GUI
Aimlock_Gui = nil
Aimlock_FloatingBtn = nil
Aimlock_FloatingPanel = nil

function Aimlock_CreateFloatingGUI()
    if Aimlock_Gui then Aimlock_Gui:Destroy() end

    Aimlock_Gui = Instance.new("ScreenGui")
    Aimlock_Gui.Name = "AimlockFloatingGUI"
    Aimlock_Gui.ResetOnSpawn = false
    Aimlock_Gui.IgnoreGuiInset = true
    Aimlock_Gui.Parent = PG

    Aimlock_FloatingBtn = Instance.new("TextButton")
    Aimlock_FloatingBtn.Size = UDim2.new(0, 45, 0, 45)
    Aimlock_FloatingBtn.Position = UDim2.new(0, 20, 0, 90)
    Aimlock_FloatingBtn.BackgroundColor3 = Color3.fromRGB(120, 20, 40)
    Aimlock_FloatingBtn.Text = "A"
    Aimlock_FloatingBtn.TextSize = 20
    Aimlock_FloatingBtn.Font = Enum.Font.GothamBlack
    Aimlock_FloatingBtn.TextColor3 = Color3.new(1, 1, 1)
    Aimlock_FloatingBtn.BorderSizePixel = 0
    Aimlock_FloatingBtn.AutoButtonColor = false
    Aimlock_FloatingBtn.Draggable = true
    Aimlock_FloatingBtn.Active = true
    Aimlock_FloatingBtn.Parent = Aimlock_Gui

    local corner1 = Instance.new("UICorner")
    corner1.CornerRadius = UDim.new(1, 0)
    corner1.Parent = Aimlock_FloatingBtn

    local stroke1 = Instance.new("UIStroke")
    stroke1.Thickness = 2
    stroke1.Color = Color3.fromRGB(255, 100, 120)
    stroke1.Parent = Aimlock_FloatingBtn

    Aimlock_FloatingPanel = Instance.new("Frame")
    Aimlock_FloatingPanel.Size = UDim2.new(0, 240, 0, 140)
    Aimlock_FloatingPanel.Position = UDim2.new(0.5, -120, 0.5, -70)
    Aimlock_FloatingPanel.BackgroundColor3 = Color3.fromRGB(15, 8, 20)
    Aimlock_FloatingPanel.BackgroundTransparency = 0.05
    Aimlock_FloatingPanel.BorderSizePixel = 0
    Aimlock_FloatingPanel.Visible = false
    Aimlock_FloatingPanel.Parent = Aimlock_Gui

    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 14)
    corner2.Parent = Aimlock_FloatingPanel

    local stroke2 = Instance.new("UIStroke")
    stroke2.Thickness = 2
    stroke2.Color = Color3.fromRGB(255, 100, 120)
    stroke2.Parent = Aimlock_FloatingPanel

    local hdr = Instance.new("Frame")
    hdr.Size = UDim2.new(1, 0, 0, 28)
    hdr.BackgroundColor3 = Color3.fromRGB(60, 15, 25)
    hdr.BorderSizePixel = 0
    hdr.Parent = Aimlock_FloatingPanel

    local hdrCorner = Instance.new("UICorner")
    hdrCorner.CornerRadius = UDim.new(0, 14)
    hdrCorner.Parent = hdr

    local hdrPatch = Instance.new("Frame")
    hdrPatch.Size = UDim2.new(1, 0, 0, 14)
    hdrPatch.Position = UDim2.new(0, 0, 1, -14)
    hdrPatch.BackgroundColor3 = Color3.fromRGB(60, 15, 25)
    hdrPatch.BorderSizePixel = 0
    hdrPatch.Parent = hdr

    local ttl = Instance.new("TextLabel")
    ttl.Size = UDim2.new(1, -40, 1, 0)
    ttl.Position = UDim2.new(0, 10, 0, 0)
    ttl.BackgroundTransparency = 1
    ttl.Text = "AIMBOT"
    ttl.TextColor3 = Color3.fromRGB(255, 180, 190)
    ttl.TextSize = 11
    ttl.Font = Enum.Font.GothamBlack
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Parent = hdr

    local clsBtn = Instance.new("TextButton")
    clsBtn.Size = UDim2.new(0, 20, 0, 20)
    clsBtn.Position = UDim2.new(1, -26, 0.5, -10)
    clsBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 40)
    clsBtn.Text = "X"
    clsBtn.TextColor3 = Color3.fromRGB(255, 100, 120)
    clsBtn.TextSize = 10
    clsBtn.Font = Enum.Font.GothamBlack
    clsBtn.BorderSizePixel = 0
    clsBtn.AutoButtonColor = false
    clsBtn.Parent = hdr

    local clsCorner = Instance.new("UICorner")
    clsCorner.CornerRadius = UDim.new(0, 5)
    clsCorner.Parent = clsBtn

    local statLbl = Instance.new("TextLabel")
    statLbl.Name = "StatusLabel"
    statLbl.Size = UDim2.new(1, -20, 0, 18)
    statLbl.Position = UDim2.new(0, 10, 0, 35)
    statLbl.BackgroundTransparency = 1
    statLbl.Text = "Status: HOLD ATTACK"
    statLbl.TextColor3 = Color3.fromRGB(100, 255, 150)
    statLbl.TextSize = 10
    statLbl.Font = Enum.Font.GothamBold
    statLbl.TextXAlignment = Enum.TextXAlignment.Left
    statLbl.Parent = Aimlock_FloatingPanel

    local radLbl = Instance.new("TextLabel")
    radLbl.Name = "RadiusLabel"
    radLbl.Size = UDim2.new(1, -20, 0, 14)
    radLbl.Position = UDim2.new(0, 10, 0, 60)
    radLbl.BackgroundTransparency = 1
    radLbl.Text = string.format("Radius: %.0f studs", Aimlock.Radius)
    radLbl.TextColor3 = Color3.fromRGB(220, 200, 200)
    radLbl.TextSize = 9
    radLbl.Font = Enum.Font.GothamMedium
    radLbl.TextXAlignment = Enum.TextXAlignment.Left
    radLbl.Parent = Aimlock_FloatingPanel

    local slBg = Instance.new("Frame")
    slBg.Name = "SliderBg"
    slBg.Size = UDim2.new(1, -20, 0, 6)
    slBg.Position = UDim2.new(0, 10, 0, 82)
    slBg.BackgroundColor3 = Color3.fromRGB(60, 30, 40)
    slBg.BorderSizePixel = 0
    slBg.Parent = Aimlock_FloatingPanel

    local slBgCorner = Instance.new("UICorner")
    slBgCorner.CornerRadius = UDim.new(1, 0)
    slBgCorner.Parent = slBg

    local slFill = Instance.new("Frame")
    slFill.Name = "Fill"
    slFill.Size = UDim2.new((Aimlock.Radius - 5) / (100 - 5), 0, 1, 0)
    slFill.BackgroundColor3 = Color3.fromRGB(255, 100, 120)
    slFill.BorderSizePixel = 0
    slFill.Parent = slBg

    local slFillCorner = Instance.new("UICorner")
    slFillCorner.CornerRadius = UDim.new(1, 0)
    slFillCorner.Parent = slFill

    local slKnob = Instance.new("Frame")
    slKnob.Name = "Knob"
    slKnob.Size = UDim2.new(0, 12, 0, 12)
    slKnob.Position = UDim2.new((Aimlock.Radius - 5) / (100 - 5), -6, 0.5, -6)
    slKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    slKnob.BorderSizePixel = 0
    slKnob.Parent = slBg

    local slKnobCorner = Instance.new("UICorner")
    slKnobCorner.CornerRadius = UDim.new(1, 0)
    slKnobCorner.Parent = slKnob

    local infLbl = Instance.new("TextLabel")
    infLbl.Size = UDim2.new(1, -20, 0, 30)
    infLbl.Position = UDim2.new(0, 10, 0, 100)
    infLbl.BackgroundTransparency = 1
    infLbl.Text = "Hold ATTACK = lock\nLepas = bebas"
    infLbl.TextColor3 = Color3.fromRGB(200, 180, 180)
    infLbl.TextSize = 9
    infLbl.Font = Enum.Font.Gotham
    infLbl.TextXAlignment = Enum.TextXAlignment.Left
    infLbl.TextYAlignment = Enum.TextYAlignment.Top
    infLbl.Parent = Aimlock_FloatingPanel

    Aimlock_FloatingBtn.MouseButton1Click:Connect(function()
        Aimlock_FloatingPanel.Visible = not Aimlock_FloatingPanel.Visible
    end)

    clsBtn.MouseButton1Click:Connect(function()
        Aimlock_FloatingPanel.Visible = false
    end)

    local draggingSl = false

    local function updateFloatingSlider(input)
        local pos = math.clamp(
            (input.Position.X - slBg.AbsolutePosition.X) / slBg.AbsoluteSize.X,
            0, 1
        )
        local val = math.floor(5 + (100 - 5) * pos + 0.5)
        Aimlock.Radius = val
        slFill.Size = UDim2.new(pos, 0, 1, 0)
        slKnob.Position = UDim2.new(pos, -6, 0.5, -6)
        radLbl.Text = string.format("Radius: %.0f studs", val)
    end

    slBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            draggingSl = true
            updateFloatingSlider(input)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if draggingSl and (input.UserInputType == Enum.UserInputType.MouseMovement
           or input.UserInputType == Enum.UserInputType.Touch) then
            updateFloatingSlider(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            draggingSl = false
        end
    end)
end

function Aimlock_RemoveFloatingGUI()
    if Aimlock_Gui then
        Aimlock_Gui:Destroy()
        Aimlock_Gui = nil
        Aimlock_FloatingBtn = nil
        Aimlock_FloatingPanel = nil
    end
end

-- TAB AIMBOT (TAB 6)
makeTab("Aimbot", "🎯", 6, function()

    sec("Aimbot Control", "🎯")
    tog("Enable Aimbot", false, function(s)
        Aimlock.Enabled = s
        if s then
            Aimlock_HookAttackButtons()
            Aimlock_StartLoop()
        else
            Aimlock.Holding = false
            Aimlock_StopLoop()
        end
    end)
    lbl("Hold ATTACK = kamera lock ke survivor", C.FIRE_BRIGHT)

    sec("Show Floating GUI", "👁️")
    tog("Show Aimbot GUI", false, function(s)
        if s then
            Aimlock_CreateFloatingGUI()
        else
            Aimlock_RemoveFloatingGUI()
        end
    end)
    lbl("ON = tombol A muncul di layar", C.GRN)
    lbl("OFF = gak keliatan", C.DIM)

    sec("Radius Setting", "📏")
    sl("Aimbot Radius", 5, 100, 80, function(v)
        Aimlock.Radius = v
        if Aimlock_FloatingPanel then
            local radLbl = Aimlock_FloatingPanel:FindFirstChild("RadiusLabel")
            if radLbl then
                radLbl.Text = string.format("Radius: %.0f studs", v)
            end
        end
    end)
    lbl("Default 80 | Max 100", C.GRN)

    sec("Target", "🎯")
    drp("Aim Part", {"HumanoidRootPart", "Head", "UpperTorso"}, "HumanoidRootPart", function(v)
        Aimlock.AimPart = v
    end)
    lbl("Part target yang di-lock", C.DIM)

    lbl("Target: Survivor (buat Killer)", C.FIRE_BRIGHT)
    lbl("Lepas tombol = kamera bebas", C.GRN)
    lbl("Skip kalo survivor downed", C.DIM)

    sec("Test", "🔧")
    btn("Scan Attack Buttons", function()
        Aimlock_ScanAttackButtons()
    end)
    lbl("Cek output di console (F9)", C.DIM)

    btn("Manual Toggle Floating GUI", function()
        if Aimlock_Gui then
            Aimlock_RemoveFloatingGUI()
        else
            Aimlock_CreateFloatingGUI()
        end
    end)
end)

print("✅ [12/13] COSMIC - AIMBOT TAB Loaded")
print("🎯 Target Survivor | Radius max 100")
print("👁️ Floating GUI: Toggle di tab Aimbot")-- =========================================================
-- SECTION 13/13 : ANTI-ILANG MENU + AUTO RECREATE
-- =========================================================

pcall(function()
    if gui then gui.ResetOnSpawn = false end
    if killFeedGui then killFeedGui.ResetOnSpawn = false end
    if mwBtnGui then mwBtnGui.ResetOnSpawn = false end
    if crosshairGui then crosshairGui.ResetOnSpawn = false end
    if fpsPingGui then fpsPingGui.ResetOnSpawn = false end
    if loadingGui then loadingGui.ResetOnSpawn = false end
    if Aimlock_Gui then Aimlock_Gui.ResetOnSpawn = false end
end)

function RecreateAllGUI()
    if not gui or not gui.Parent then
        local existing = PG:FindFirstChild("CosmicHub")
        if existing then
            gui = existing
            gui.ResetOnSpawn = false
        else
            warn("[RECREATE] CosmicHub ilang total!")
        end
    end

    if not fpsPingGui or not fpsPingGui.Parent then
        local existing = PG:FindFirstChild("CosmicFPSPing")
        if existing then
            fpsPingGui = existing
            fpsPingGui.ResetOnSpawn = false
        else
            pcall(createFPSPingGui)
        end
    end

    if not mwBtnGui or not mwBtnGui.Parent then
        local existing = PG:FindFirstChild("MW_BottomBtn")
        if existing then
            mwBtnGui = existing
            mwBtnGui.ResetOnSpawn = false
        end
    end

    if not killFeedGui or not killFeedGui.Parent then
        local existing = PG:FindFirstChild("CosmicKillFeed")
        if existing then
            killFeedGui = existing
            killFeedGui.ResetOnSpawn = false
        end
    end

    if crosshairGui and not crosshairGui.Parent then
        crosshairGui = nil
    end

    if Aimlock_Gui and not Aimlock_Gui.Parent then
        Aimlock_Gui = nil
    end
end

task.spawn(function()
    while task.wait(1) do
        pcall(RecreateAllGUI)
    end
end)

LP.CharacterAdded:Connect(function(char)
    task.wait(2)
    print("[RESPAWN] Re-apply fitur...")
    pcall(function()
        if S.FireOn then applyFire() end
        if S.Korblox then
            applyKorblox(true, "Pencil", S.KorbloxYOffset, S.KorbloxScale)
        end
        if S.EightBitOn then
            apply8Bit(true, "Royal Crown", S.EightBitSize, S.EightBitHeight)
        end
        if S.Headless then applyHeadless(true) end
        if S.FOVEnabled then applyFOV() end
        if S.SkyId and S.SkyId ~= "Default" then applySky(S.SkyId) end
        if S.Contrast then applyContrast() end
        if AutoParry.Enabled then AP_ScanKillers() end
        if SkillCheck.Enabled then startSkillCheck() end
        if FastVault.Enabled then hookVault(char) end
    end)

    task.wait(0.5)
    pcall(function()
        if gui then gui.ResetOnSpawn = false end
        if killFeedGui then killFeedGui.ResetOnSpawn = false end
        if mwBtnGui then mwBtnGui.ResetOnSpawn = false end
    end)
    print("[RESPAWN] Selesai!")
end)

local _lastPlaceId = game.PlaceId
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if game.PlaceId ~= _lastPlaceId then
                print("[PLACE-CHANGE] Pindah place!")
                print("  Old:", _lastPlaceId, "-> New:", game.PlaceId)
                _lastPlaceId = game.PlaceId

                task.wait(3)
                pcall(RecreateAllGUI)

                pcall(function()
                    if S.FireOn then applyFire() end
                    if S.Korblox then
                        applyKorblox(true, "Pencil", S.KorbloxYOffset, S.KorbloxScale)
                    end
                    if S.EightBitOn then
                        apply8Bit(true, "Royal Crown", S.EightBitSize, S.EightBitHeight)
                    end
                    if S.Headless then applyHeadless(true) end
                    if S.FOVEnabled then applyFOV() end
                    if S.SkyId and S.SkyId ~= "Default" then applySky(S.SkyId) end
                    if S.Contrast then applyContrast() end
                    if AutoParry.Enabled then AP_ScanKillers() end
                    if SkillCheck.Enabled then startSkillCheck() end
                end)

                print("[PLACE-CHANGE] Re-apply selesai!")
            end
        end)
    end
end)

print("")
print("═══════════════════════════════════════════")
print("  SECTION 13 - ANTI-ILANG MENU")
print("═══════════════════════════════════════════")
print("  ResetOnSpawn = false")
print("  Recovery loop tiap 1 detik")
print("  Auto re-apply pas respawn")
print("  Detect place change")
print("═══════════════════════════════════════════")
print("✅ [13/13] ANTI-ILANG MENU LOADED")
print("")
