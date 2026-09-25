-- =========================================================
-- ROOORHUB ULTIMATE FIRE EDITION v3
-- BAGIAN 1/8 : LOADING 4D + CONFIG + STATE
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
    BG = Color3.fromRGB(6, 4, 12),
    BG2 = Color3.fromRGB(10, 7, 20),
    PANEL = Color3.fromRGB(15, 10, 28),
    PANEL2 = Color3.fromRGB(22, 15, 40),
    ACC = Color3.fromRGB(180, 80, 255),
    ACC2 = Color3.fromRGB(0, 230, 255),
    ACC3 = Color3.fromRGB(255, 50, 180),
    ACC4 = Color3.fromRGB(255, 200, 50),
    GOLD = Color3.fromRGB(255, 215, 0),
    FIRE1 = Color3.fromRGB(255, 120, 0),
    FIRE2 = Color3.fromRGB(255, 220, 80),
    FIRE3 = Color3.fromRGB(255, 60, 0),
    FIRE_BRIGHT = Color3.fromRGB(255, 240, 150),
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
-- LOADING 4D HD
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

local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 8, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 15, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 8, 0)),
})
bgGrad.Rotation = 0
bgGrad.Parent = bg

task.spawn(function()
    while bg.Parent do
        for i = 0, 360, 1 do
            if not bg.Parent then break end
            bgGrad.Rotation = i
            task.wait(0.02)
        end
    end
end)

-- Partikel api lebih terang
for i = 1, 40 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, math.random(4, 10), 0, math.random(4, 10))
    p.Position = UDim2.new(math.random(), 0, 1.1, 0)
    p.BackgroundColor3 = Color3.fromRGB(255, math.random(100, 220), math.random(0, 100))
    p.BorderSizePixel = 0
    p.Parent = bg
    rnd(p, 999)

    task.spawn(function()
        while p.Parent do
            local speed = math.random(8, 18) / 1000
            p.Position = UDim2.new(p.Position.X.Scale, p.Position.X.Offset, p.Position.Y.Scale - speed, 0)
            p.BackgroundTransparency = p.BackgroundTransparency + 0.008
            if p.BackgroundTransparency >= 1 or p.Position.Y.Scale < -0.1 then
                p.Position = UDim2.new(math.random(), 0, 1.1, 0)
                p.BackgroundTransparency = 0
                p.BackgroundColor3 = Color3.fromRGB(255, math.random(100, 220), math.random(0, 100))
            end
            task.wait(0.04)
        end
    end)
end

-- Rings
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
    rStrk.Color = C.FIRE2
    rStrk.Transparency = 0.05 + (i-1) * 0.12
    rStrk.Parent = ring

    local rGrad = Instance.new("UIGradient")
    rGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.FIRE3),
        ColorSequenceKeypoint.new(0.5, C.FIRE_BRIGHT),
        ColorSequenceKeypoint.new(1, C.FIRE1),
    })
    rGrad.Parent = rStrk

    table.insert(rings, {ring = ring, grad = rGrad, speed = 40 + i * 25, dir = i % 2 == 0 and -1 or 1})
end

local core = Instance.new("Frame")
core.Size = UDim2.new(0, 80, 0, 80)
core.Position = UDim2.new(0.5, -40, 0.5, -40)
core.BackgroundColor3 = C.FIRE_BRIGHT
core.Parent = ringContainer
rnd(core, 999)
local coreGrad = Instance.new("UIGradient")
coreGrad.Color = ColorSequence.new(C.FIRE1, C.FIRE_BRIGHT, C.FIRE3)
coreGrad.Rotation = 45
coreGrad.Parent = core

local coreIcon = Instance.new("TextLabel")
coreIcon.Size = UDim2.new(1, 0, 1, 0)
coreIcon.BackgroundTransparency = 1
coreIcon.Text = "🔥"
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
welcomeTitle.TextStrokeColor3 = C.FIRE3
welcomeTitle.Parent = bg
local welcomeGrad = Instance.new("UIGradient")
welcomeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.FIRE1),
    ColorSequenceKeypoint.new(0.5, C.FIRE_BRIGHT),
    ColorSequenceKeypoint.new(1, C.FIRE1),
})
welcomeGrad.Parent = welcomeTitle

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 100)
subtitle.Position = UDim2.new(0, 0, 0.53, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "SC PENGANGGURAN"
subtitle.TextColor3 = C.FIRE2
subtitle.TextSize = 68
subtitle.Font = Enum.Font.GothamBlack
subtitle.TextStrokeTransparency = 0
subtitle.TextStrokeColor3 = C.FIRE3
subtitle.Parent = bg
local subGrad = Instance.new("UIGradient")
subGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.FIRE2),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 220)),
    ColorSequenceKeypoint.new(1, C.FIRE1),
})
subGrad.Parent = subtitle

local tagline = Instance.new("TextLabel")
tagline.Size = UDim2.new(1, 0, 0, 30)
tagline.Position = UDim2.new(0, 0, 0.73, 20)
tagline.BackgroundTransparency = 1
tagline.Text = "🔥 ULTIMATE FIRE EDITION v3 🔥"
tagline.TextColor3 = C.FIRE2
tagline.TextSize = 16
tagline.Font = Enum.Font.GothamBold
tagline.TextStrokeTransparency = 0.3
tagline.TextStrokeColor3 = C.FIRE3
tagline.Parent = bg

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 420, 0, 6)
progressBar.Position = UDim2.new(0.5, -210, 0.9, 20)
progressBar.BackgroundColor3 = Color3.fromRGB(40, 15, 5)
progressBar.BorderSizePixel = 0
progressBar.Parent = bg
rnd(progressBar, 3)
strk(progressBar, C.FIRE2, 1.5, 0.3)

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = C.FIRE_BRIGHT
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBar
rnd(progressFill, 3)
local progGrad = Instance.new("UIGradient")
progGrad.Color = ColorSequence.new(C.FIRE3, C.FIRE_BRIGHT, Color3.fromRGB(255, 255, 220))
progGrad.Parent = progressFill

local progText = Instance.new("TextLabel")
progText.Size = UDim2.new(1, 0, 0, 18)
progText.Position = UDim2.new(0, 0, 1, 6)
progText.BackgroundTransparency = 1
progText.Text = "Loading... 0%"
progText.TextColor3 = C.FIRE2
progText.TextSize = 11
progText.Font = Enum.Font.GothamBold
progText.Parent = progressBar

task.spawn(function()
    local t = 0
    while bg.Parent do
        t = t + 0.02
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
        welcomeGrad.Rotation = math.sin(t) * 45
        subGrad.Rotation = math.sin(t * 1.5) * 45
        task.wait(0.02)
    end
end)

task.spawn(function()
    for i = 0, 1, 0.01 do
        if not bg.Parent then break end
        progressFill.Size = UDim2.new(i, 0, 1, 0)
        progText.Text = string.format("Loading... %d%%", math.floor(i * 100))
        task.wait(0.035)
    end
end)

task.delay(3.5, function()
    TweenService:Create(bg, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    for _, el in pairs(bg:GetDescendants()) do
        pcall(function()
            if el:IsA("TextLabel") then
                TweenService:Create(el, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
            elseif el:IsA("Frame") then
                TweenService:Create(el, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
            elseif el:IsA("UIStroke") then
                TweenService:Create(el, TweenInfo.new(0.8), {Transparency = 1}):Play()
            end
        end)
    end
    task.wait(0.8)
    loadingGui:Destroy()
end)

-- =========================================================
-- STATE
-- =========================================================
_G.RoooorS = _G.RoooorS or {
    FireOn = false, FireType = "Classic", FireSize = 5,
    FireFeetOn = false, FireFeetType = "Classic",
    ESP_Name = false, ESP_Size = 14, ESP_Radius = 500,
    ESP_Generator = false, ESP_GenColor = Color3.fromRGB(255, 170, 0),
    ESP_Pallet = false, ESP_PalletColor = Color3.fromRGB(74, 255, 181),
    ESP_Window = false, ESP_WindowColor = Color3.fromRGB(74, 255, 181),
    ESP_SCP = false, ESP_SCPColor = Color3.fromRGB(255, 0, 0),
    ESP_Item = false, ESP_ItemColor = Color3.fromRGB(255, 255, 100),
    ESP_DefaultColor = Color3.fromRGB(255, 255, 255),
    ESP_KillerColor = Color3.fromRGB(255, 60, 60),
    ESP_SurvivorColor = Color3.fromRGB(60, 255, 120),
    Parry = false, ParryDist = 8,
    AntiFakeHit = false, DodgeRange = 15,
    AbyssDodge = false,
    ParryCircle = false, ParryCircleSize = 15,
    Skill = false,
    Aimlock = false, AimlockRadius = 500,
    AimlockMode = "Killer",
    WalkSpeed = false, WalkSpeedVal = 16, WalkSpeedBoost = 0,
    SpeedHack = false, SpeedHackVal = 40,
    Korblox = false, Headless = false,
    Killer_AutoAtk = false, Killer_AtkDelay = 0.35,
    Killer_KillAll = false,
    Killer_Hitbox = false, Killer_HitboxSize = 15,
    Killer_Hitbox_Visible = true,
    MaskedPower = "Cobra",
    FastVault = false, FastVaultSpeed = 1.5,
    AutoVault = false, InstantInteract = false,
    EightBitCrown = false,
    EightBitSize = 1,
    CrownX = 0, CrownY = 1.2, CrownZ = 0,
    Trail = false, TrailColor = Color3.fromRGB(255, 120, 0),
    Aura = false, AuraColor = Color3.fromRGB(255, 120, 0),
    KillEffect = false,
    Crosshair = false, CrosshairColor = Color3.fromRGB(0, 255, 200), CrosshairSize = 8,
    NoClipCamera = false,
    ZoomOut = false, ZoomOutValue = 500,
    RGBUI = false,
    Fullbright = false, FullbrightVal = 50,
    NoFog = false,
    UltraHD = false, Contrast = false, ContrastVal = 0.3, SaturationVal = 0.2,
    FOV = 70, FOVEnabled = false,
    SkyId = "Default",
    AutoHeal = false, AutoHealThreshold = 40,
    AutoRepair = false,
    AutoRevive = false,
    AutoDodge = false,
    AntiGrab = false, AntiHook = false,
    AntiBlind = false, AntiStun = false, AntiRagdoll = false,
    AntiSlow = false, AntiAFK = false,
    SafeZone = false, EscapeAlert = false, EscapeAlertRange = 60,
    TPtoPlayer = false,
    Fly = false, FlySpeed = 50,
    PlayerList = false,
}

local S = _G.RoooorS
_G.ToggleStates = _G.ToggleStates or {}
_G.SliderStates = _G.SliderStates or {}

print("✅ [1/8] Loading 4D + Config loaded")-- =========================================================
-- BAGIAN 2/8 : FIRE CONFIG + SKY + KILLER ANIMS
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
    Classic = { c1 = Color3.fromRGB(255, 120, 0), c2 = Color3.fromRGB(255, 220, 80) },
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
    GalaxyFire = { c1 = Color3.fromRGB(100, 0, 220), c2 = Color3.fromRGB(255, 200, 255), rainbow = true, spark = true },
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

-- Fallback: pastikan semua fire ada config
for _, name in ipairs(FireList) do
    if not FireConfig[name] then
        FireConfig[name] = FireConfig.Classic
    end
end

local FireFeetList = {
    "Classic", "Blue", "Green", "Purple", "Rainbow",
    "Golden", "Pink", "Cyan", "RedFire", "Ice",
    "Toxic", "Electric", "Blood", "Ghost", "Cosmic",
    "Dragon", "Divine", "Demon", "Shadow", "Phoenix"
}

local FireFeetConfig = {
    Classic = { c1 = Color3.fromRGB(255, 120, 0), c2 = Color3.fromRGB(255, 220, 80) },
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
    Cosmic = { c1 = Color3.fromRGB(100, 0, 220), c2 = Color3.fromRGB(255, 220, 255), rainbow = true },
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

local SkyList = {
    "Default", "Sunset", "Night", "Space", "Alien",
    "Purple", "Galaxy", "Void",
}

local SkyIds = {
    Sunset = { Bk = "rbxassetid://169210149", Dn = "rbxassetid://169210108",
        Ft = "rbxassetid://169210121", Lf = "rbxassetid://169210133",
        Rt = "rbxassetid://169210143", Up = "rbxassetid://169210149" },
    Night = { Bk = "rbxassetid://18703245834", Dn = "rbxassetid://18703245834",
        Ft = "rbxassetid://18703245834", Lf = "rbxassetid://18703245834",
        Rt = "rbxassetid://18703245834", Up = "rbxassetid://18703245834" },
    Space = { Bk = "rbxassetid://17817511804", Dn = "rbxassetid://17817520184",
        Ft = "rbxassetid://17817511804", Lf = "rbxassetid://17817511804",
        Rt = "rbxassetid://17817511804", Up = "rbxassetid://17817511804" },
    Alien = { Bk = "rbxassetid://10253172001", Dn = "rbxassetid://10253172001",
        Ft = "rbxassetid://10253172001", Lf = "rbxassetid://10253172001",
        Rt = "rbxassetid://10253172001", Up = "rbxassetid://10253172001" },
    Purple = { Bk = "rbxassetid://6021017254", Dn = "rbxassetid://6021011228",
        Ft = "rbxassetid://6021017254", Lf = "rbxassetid://6021017254",
        Rt = "rbxassetid://6021017254", Up = "rbxassetid://6021017254" },
    Galaxy = { Bk = "rbxassetid://126146408999925", Dn = "rbxassetid://118112392224589",
        Ft = "rbxassetid://121253817183621", Lf = "rbxassetid://138429250948648",
        Rt = "rbxassetid://126146408999925", Up = "rbxassetid://126146408999925" },
    Void = { Bk = "rbxassetid://17817511804", Dn = "rbxassetid://17817520184",
        Ft = "rbxassetid://17817511804", Lf = "rbxassetid://17817511804",
        Rt = "rbxassetid://17817511804", Up = "rbxassetid://17817511804" },
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

print("✅ [2/8] Fire + Sky + KillerAnims loaded")-- =========================================================
-- BAGIAN 3/8 : SEMUA FUNGSI
-- =========================================================

-- FIRE
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
            fire.Heat = 10
            fire.Color = cfg.c1
            fire.SecondaryColor = cfg.c2
            fire.Parent = leg
        end
    end
end

task.spawn(function()
    while task.wait(0.15) do
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

-- 8-BIT CROWN
local function apply8BitCrown(enable, size, posX, posY, posZ)
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
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(131, 253, 255)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(0, 213, 255)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 122, 34)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(198, 42, 11))
    })
    emitter.Parent = crown
end

-- =========================================================
-- ESP FIXED v3 (SEMUA TIPE WORK)
-- =========================================================
local ESPObjects = {}
local StatusESP = {}
local Cached = { Generators = {}, Windows = {}, Pallets = {}, SCPs = {}, Items = {} }

local function cacheObject(obj)
    local lname = string.lower(obj.Name)
    if obj.Name == "Generator" then Cached.Generators[obj] = true
    elseif obj.Name == "Window" then Cached.Windows[obj] = true
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then Cached.Pallets[obj] = true
    elseif string.find(lname, "scp") then Cached.SCPs[obj] = true
    elseif obj:IsA("BasePart") then
        if string.find(lname, "medkit") or string.find(lname, "key") or
           string.find(lname, "flashlight") or string.find(lname, "battery") or
           string.find(lname, "bandage") then
            Cached.Items[obj] = true
        end
    end
end

for _, obj in ipairs(workspace:GetDescendants()) do cacheObject(obj) end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(function(obj)
    Cached.Generators[obj] = nil
    Cached.Windows[obj] = nil
    Cached.Pallets[obj] = nil
    Cached.SCPs[obj] = nil
    Cached.Items[obj] = nil
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
end)

local function createESP(obj, color)
    if not obj or not obj.Parent then return end
    if ESPObjects[obj] then
        ESPObjects[obj].FillColor = color
        ESPObjects[obj].OutlineColor = color
        return
    end
    pcall(function()
        local h = Instance.new("Highlight")
        h.Name = "RoooorESP"
        h.FillColor = color
        h.OutlineColor = color
        h.FillTransparency = 0.6
        h.OutlineTransparency = 0.2
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Adornee = obj
        h.Parent = obj
        ESPObjects[obj] = h
    end)
end

local function removeESP(obj)
    if ESPObjects[obj] then
        pcall(function() ESPObjects[obj]:Destroy() end)
        ESPObjects[obj] = nil
    end
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
        billboard.Size = UDim2.new(0, 200, 0, 60)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = teamColor
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
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

-- =========================================================
-- AUTO PARRY GACOR v4 + ANTI FAKE HIT
-- =========================================================
local lastParry = 0
local PARRY_DEBOUNCE = 0.05
local lastDodge = 0
local DODGE_DEBOUNCE = 0.2
local hookedKillers = _G.HookedKillers or {}
_G.HookedKillers = hookedKillers

local function getParryRange() return (S.ParryDist or 8) + 10 end

-- Cek apakah killer BENARAN attack (bukan fake)
local function isRealAttack(killerChar)
    local hum = killerChar:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local anim = hum:FindFirstChildOfClass("Animator")
    if not anim then return false end

    for _, track in ipairs(anim:GetPlayingAnimationTracks()) do
        local a = track.Animation
        if a and a.AnimationId then
            local id = tostring(a.AnimationId):match("%d+")
            if id and KillerAnims["rbxassetid://"..id] then
                -- Cek waktu animasi > 0.05 (beneran main)
                if track.TimePosition > 0.05 then
                    return true
                end
            end
        end
    end
    return false
end

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

-- DODGE: menghindar ke samping
local function doDodge(killerRoot)
    local now = tick()
    if now - lastDodge < DODGE_DEBOUNCE then return end
    lastDodge = now

    local myRoot = getRoot()
    if not myRoot or not killerRoot then return end

    local dirAway = (myRoot.Position - killerRoot.Position).Unit
    local perpendicular = Vector3.new(-dirAway.Z, 0, dirAway.X)
    local dodgeDir = math.random() > 0.5 and perpendicular or -perpendicular

    pcall(function()
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:Move(dodgeDir * 10, false)
        end
    end)
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

    -- TRIGGER 1: Animation hook
    anim.AnimationPlayed:Connect(function(track)
        if not S.Parry and not S.AntiFakeHit then return end
        local a = track.Animation
        if not a then return end
        local id = tostring(a.AnimationId):match("%d+")
        if not id then return end
        if not KillerAnims["rbxassetid://"..id] then return end

        local myRoot = getRoot()
        local eRoot = char:FindFirstChild("HumanoidRootPart")
        if not myRoot or not eRoot then return end
        local dist = (eRoot.Position - myRoot.Position).Magnitude
        if dist > getParryRange() then return end

        task.wait(0.05)
        if isRealAttack(char) then
            if S.Parry then doParry() end
        else
            if S.AntiFakeHit then doDodge(eRoot) end
        end
    end)

    -- TRIGGER 2: Polling
    task.spawn(function()
        while char.Parent and hookedKillers[char] do
            task.wait(0.01)
            if not S.Parry and not S.AntiFakeHit then break end

            local myRoot = getRoot()
            local eRoot = char:FindFirstChild("HumanoidRootPart")
            if not myRoot or not eRoot then continue end

            local dist = (eRoot.Position - myRoot.Position).Magnitude
            if dist > getParryRange() + 5 then continue end

            for _, track in ipairs(anim:GetPlayingAnimationTracks()) do
                local a = track.Animation
                if a and a.AnimationId then
                    local id = tostring(a.AnimationId):match("%d+")
                    if id and KillerAnims["rbxassetid://"..id] then
                        if isRealAttack(char) then
                            if S.Parry then doParry() end
                        elseif S.AntiFakeHit then
                            doDodge(eRoot)
                        end
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

task.spawn(function()
    while task.wait(0.3) do
        if S.Parry or S.AntiFakeHit then scanKillers() end
    end
end)

-- =========================================================
-- AUTO DODGE KILLER ABYSS (Crouch saat Slash)
-- =========================================================
task.spawn(function()
    while task.wait(0.05) do
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
                                            local id = tostring(a.AnimationId):match("%d+")
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
                                                        pcall(function()
                                                            local currentCF = myRoot.CFrame
                                                            myRoot.CFrame = CFrame.new(currentCF.Position - Vector3.new(0, 2, 0)) * (currentCF - currentCF.Position)
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

-- =========================================================
-- VISUAL FUNCTIONS
-- =========================================================
local origLighting = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
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

-- KAKI SATU HILANG
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
            local rightLeg = LP.Character:FindFirstChild("Right Leg")
                or LP.Character:FindFirstChild("RightUpperLeg")
                or LP.Character:FindFirstChild("RightLowerLeg")
            if rightLeg and rightLeg.Transparency ~= 1 then
                rightLeg.Transparency = 1
                rightLeg.CanCollide = false
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

-- TRAIL FIRE
local trailFireObj = nil
local function applyTrail(enable, color)
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
    fire.Color = color or Color3.fromRGB(255, 120, 0)
    fire.SecondaryColor = Color3.fromRGB(255, 220, 80)
    fire.Parent = trailFireObj

    local smoke = Instance.new("Smoke")
    smoke.Size = 6
    smoke.RiseVelocity = 5
    smoke.Opacity = 0.5
    smoke.Color = Color3.fromRGB(50, 50, 50)
    smoke.Parent = trailFireObj

    local spark = Instance.new("Sparkles")
    spark.SparkleColor = color or Color3.fromRGB(255, 220, 80)
    spark.SparkleSize = 2
    spark.Parent = trailFireObj
end

-- AURA FIRE
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
    auraObj.Color = ColorSequence.new(color or Color3.fromRGB(255, 120, 0))
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

-- FLY
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

-- EXPOSE GLOBAL
_G.Roooor_applyFire = applyFire
_G.Roooor_applyFireFeet = applyFireFeet
_G.Roooor_apply8BitCrown = apply8BitCrown
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
_G.Roooor_startFly = startFly
_G.Roooor_stopFly = stopFly

print("✅ [3/8] Semua fungsi loaded (ESP FIXED v3 + Parry v4 + Anti Fake Hit)")-- =========================================================
-- BAGIAN 4/8 : FITUR BARU + LOOP UTAMA
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
                            if item:IsA("Tool") and (string.find(string.lower(item.Name), "medkit") or string.find(string.lower(item.Name), "bandage") or string.find(string.lower(item.Name), "heal")) then
                                local hum2 = LP.Character:FindFirstChildOfClass("Humanoid")
                                if hum2 then
                                    hum2:EquipTool(item)
                                    task.wait(0.1)
                                    item:Activate()
                                    task.wait(0.3)
                                    if item.Parent == LP.Character then
                                        hum2:UnequipTools()
                                    end
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

-- AUTO DODGE (basic)
task.spawn(function()
    while task.wait(0.15) do
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

-- INSTANT INTERACT
task.spawn(function()
    while task.wait(0.2) do
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
    while task.wait(0.25) do
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
    while task.wait(0.15) do
        if S.AntiGrab and LP.Character then
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
    while task.wait(0.3) do
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

-- ANTI STUN
task.spawn(function()
    while task.wait(0.15) do
        if S.AntiStun and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.WalkSpeed == 0 and S.WalkSpeed then hum.WalkSpeed = S.WalkSpeedVal end
                if hum.PlatformStand then hum.PlatformStand = false end
            end
        end
    end
end)

-- ANTI RAGDOLL
task.spawn(function()
    while task.wait(0.15) do
        if S.AntiRagdoll and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.PlatformStand then hum.PlatformStand = false end
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end
    end
end)

-- ANTI SLOW
task.spawn(function()
    while task.wait(0.25) do
        if S.AntiSlow and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed < 10 then
                hum.WalkSpeed = S.WalkSpeed and S.WalkSpeedVal or 16
            end
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
    while task.wait(0.15) do
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
    while task.wait(0.15) do
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

-- KILLER: AUTO ATTACK / KILL ALL / HITBOX
local lastAtk = 0
task.spawn(function()
    while task.wait(0.15) do
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
    while task.wait(0.25) do
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
                    myRoot.CFrame = CFrame.new(targetPos + closest.CFrame.LookVector * -3, targetPos)
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
    while task.wait(0.35) do
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

-- PLAYER LIST
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
    strk(frame, C.FIRE2, 1.5)

    local title2 = Instance.new("TextLabel")
    title2.Size = UDim2.new(1, -10, 0, 25)
    title2.Position = UDim2.new(0, 5, 0, 5)
    title2.BackgroundTransparency = 1
    title2.Text = "👥 PLAYER LIST"
    title2.TextColor3 = C.FIRE2
    title2.TextSize = 12
    title2.Font = Enum.Font.GothamBlack
    title2.Parent = frame

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, -10, 1, -40)
    listFrame.Position = UDim2.new(0, 5, 0, 35)
    listFrame.BackgroundTransparency = 1
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 3
    listFrame.ScrollBarImageColor3 = C.FIRE2
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listFrame.Parent = frame

    local listL = Instance.new("UIListLayout")
    listL.Padding = UDim.new(0, 3)
    listL.Parent = listFrame

    task.spawn(function()
        while playerListGui and playerListGui.Parent do
            task.wait(1)
            if S.PlayerList then
                for _, c in pairs(listFrame:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                local root = getRoot()
                for _, p in pairs(Players:GetPlayers()) do
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, -5, 0, 20)
                    btn.BackgroundTransparency = 1
                    btn.TextColor3 = p == LP and C.FIRE2 or C.TXT
                    btn.TextSize = 10
                    btn.Font = Enum.Font.GothamMedium
                    btn.TextXAlignment = Enum.TextXAlignment.Left
                    btn.Text = ""
                    btn.AutoButtonColor = false
                    local team = p.Team and p.Team.Name or "None"
                    local dist = 0
                    if root and p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then dist = (hrp.Position - root.Position).Magnitude end
                    end
                    btn.Text = string.format("%s [%s] %.0f", p.Name, team, dist)
                    btn.Parent = listFrame
                    if S.TPtoPlayer and p ~= LP then
                        btn.MouseButton1Click:Connect(function()
                            local root = getRoot()
                            local targetHrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                            if root and targetHrp then
                                root.CFrame = targetHrp.CFrame + Vector3.new(0, 2, 0)
                            end
                        end)
                    end
                end
            end
        end
    end)
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
    while task.wait(0.05) do
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

-- AIMLOCK
task.spawn(function()
    while task.wait(0.05) do
        if S.Aimlock then
            local myRoot = getRoot()
            if myRoot then
                local closest, shortest = nil, S.AimlockRadius
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local valid = false
                        if S.AimlockMode == "Killer" and p.Team and p.Team.Name == "Killer" then valid = true
                        elseif S.AimlockMode == "Survivor" and p.Team and p.Team.Name == "Survivors" then valid = true end
                        if valid then
                            local hrp = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                            local hum = p.Character:FindFirstChildOfClass("Humanoid")
                            if hrp and hum and hum.Health > 0 then
                                local dist = (hrp.Position - myRoot.Position).Magnitude
                                if dist < shortest then shortest = dist; closest = hrp end
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

-- PARRY CIRCLE
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
    _G.Roooor_ParryCircle.Color = C.FIRE2
    _G.Roooor_ParryCircle.Transparency = 0.5
end

RunService.RenderStepped:Connect(function()
    if S.ParryCircle then updateParryCircle() end
end)

-- MAIN ESP LOOP
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
            if S.ESP_Item then
                for obj in pairs(Cached.Items) do
                    if obj and obj.Parent then
                        local pos = obj:IsA("BasePart") and obj.Position
                        if pos and (pos - root.Position).Magnitude <= S.ESP_Radius then
                            createESP(obj, S.ESP_ItemColor)
                        else
                            removeESP(obj)
                        end
                    end
                end
            end
        end
        task.wait(0.3)
    end
end)

-- KILL EFFECT LOOP
task.spawn(function()
    while task.wait(0.6) do
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
    while task.wait(0.15) do
        local cam = workspace.CurrentCamera
        if cam then
            cam.CanCollide = not S.NoClipCamera
        end
    end
end)

-- SCAN KILLER LOOP
task.spawn(function()
    while task.wait(0.3) do
        if S.Parry or S.AntiFakeHit then scanKillers() end
    end
end)

_G.Roooor_createPlayerList = createPlayerList

print("✅ [4/8] Fitur baru + Loop utama loaded")-- =========================================================
-- BAGIAN 5/8 : GUI + KOMPONEN
-- =========================================================

local gui = Instance.new("ScreenGui")
gui.Name = "RoooorHubFire"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PG

-- ============================
-- TOMBOL MENU KECIL + API TERANG
-- ============================
local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(0, 42, 0, 42)
btnContainer.Position = UDim2.new(0, 15, 0.3, 0)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = gui

-- Outer rotating ring
local outerRing = Instance.new("Frame")
outerRing.Size = UDim2.new(1, 6, 1, 6)
outerRing.Position = UDim2.new(0, -3, 0, -3)
outerRing.BackgroundTransparency = 1
outerRing.Parent = btnContainer
local outerRingStroke = Instance.new("UIStroke")
outerRingStroke.Thickness = 2
outerRingStroke.Color = C.FIRE_BRIGHT
outerRingStroke.Transparency = 0.1
outerRingStroke.Parent = outerRing
local outerRingGrad = Instance.new("UIGradient")
outerRingGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.FIRE3),
    ColorSequenceKeypoint.new(0.5, C.FIRE_BRIGHT),
    ColorSequenceKeypoint.new(1, C.FIRE1),
})
outerRingGrad.Parent = outerRingStroke

-- Inner ring
local innerRing = Instance.new("Frame")
innerRing.Size = UDim2.new(1, -2, 1, -2)
innerRing.Position = UDim2.new(0, 1, 0, 1)
innerRing.BackgroundTransparency = 1
innerRing.Parent = btnContainer
local innerRingStroke = Instance.new("UIStroke")
innerRingStroke.Thickness = 1
innerRingStroke.Color = C.FIRE2
innerRingStroke.Transparency = 0.3
innerRingStroke.Parent = innerRing

-- Main button
local mainBtn = Instance.new("TextButton")
mainBtn.Size = UDim2.new(1, -8, 1, -8)
mainBtn.Position = UDim2.new(0, 4, 0, 4)
mainBtn.BackgroundColor3 = Color3.fromRGB(45, 15, 5)
mainBtn.Text = "🔥"
mainBtn.TextColor3 = C.FIRE_BRIGHT
mainBtn.TextSize = 20
mainBtn.Font = Enum.Font.GothamBlack
mainBtn.BorderSizePixel = 0
mainBtn.AutoButtonColor = false
mainBtn.Parent = btnContainer
rnd(mainBtn, 999)

local btnGrad = Instance.new("UIGradient")
btnGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 20, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 10, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 20, 0)),
})
btnGrad.Rotation = 45
btnGrad.Parent = mainBtn

-- Glow pulse terang
local glow = Instance.new("Frame")
glow.Size = UDim2.new(1, 16, 1, 16)
glow.Position = UDim2.new(0, -8, 0, -8)
glow.BackgroundColor3 = C.FIRE_BRIGHT
glow.BackgroundTransparency = 0.5
glow.BorderSizePixel = 0
glow.ZIndex = -1
glow.Parent = mainBtn
rnd(glow, 999)

-- Animasi loop
task.spawn(function()
    local t = 0
    while btnContainer.Parent do
        t = t + 0.03
        outerRing.Rotation = t * 60
        outerRingGrad.Rotation = t * 100
        innerRing.Rotation = -t * 90
        local pulse = (math.sin(t * 4) + 1) / 2
        glow.BackgroundTransparency = 0.75 - pulse * 0.35
        glow.Size = UDim2.new(1, 10 + pulse * 12, 1, 10 + pulse * 12)
        glow.Position = UDim2.new(0, -5 - pulse * 6, 0, -5 - pulse * 6)
        btnGrad.Rotation = t * 40
        mainBtn.TextSize = 20 + math.sin(t * 5) * 2
        task.wait(0.03)
    end
end)

-- Partikel api di sekitar tombol (lebih terang)
for i = 1, 10 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, 4, 0, 4)
    particle.BackgroundColor3 = C.FIRE_BRIGHT
    particle.BorderSizePixel = 0
    particle.Parent = btnContainer
    rnd(particle, 999)
    local angle = (i / 10) * math.pi * 2

    task.spawn(function()
        while btnContainer.Parent do
            local t = tick()
            local radius = 26
            local x = math.cos(t * 2.5 + angle) * radius
            local y = math.sin(t * 2.5 + angle) * radius
            particle.Position = UDim2.new(0.5, x - 2, 0.5, y - 2)
            particle.BackgroundTransparency = 0.1 + math.sin(t * 5 + i) * 0.25
            particle.BackgroundColor3 = Color3.fromHSV((t * 0.4 + i * 0.08) % 1, 0.75, 1)
            task.wait(0.03)
        end
    end)
end

-- ============================
-- PANEL
-- ============================
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 480, 0, 400)
panel.Position = UDim2.new(0.5, -240, 0.5, -200)
panel.BackgroundColor3 = C.BG
panel.BackgroundTransparency = 0.05
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = gui
rnd(panel, 18)
strk(panel, C.FIRE2, 2, 0.2)

local panelGrad = Instance.new("UIGradient")
panelGrad.Color = ColorSequence.new(C.BG, C.BG2, C.BG)
panelGrad.Rotation = 45
panelGrad.Parent = panel

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

local neonLine = Instance.new("Frame")
neonLine.Size = UDim2.new(1, -40, 0, 3)
neonLine.Position = UDim2.new(0, 20, 1, -1.5)
neonLine.BackgroundColor3 = C.FIRE_BRIGHT
neonLine.BorderSizePixel = 0
neonLine.Parent = header
local neonGrad = Instance.new("UIGradient")
neonGrad.Color = ColorSequence.new(C.FIRE3, C.FIRE_BRIGHT, Color3.fromRGB(255, 255, 240), C.FIRE_BRIGHT, C.FIRE3)
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
hTitle.Text = "🔥 ROOORHUB ULTIMATE v3"
hTitle.TextColor3 = C.FIRE_BRIGHT
hTitle.TextSize = 14
hTitle.Font = Enum.Font.GothamBlack
hTitle.TextXAlignment = Enum.TextXAlignment.Left
hTitle.TextStrokeTransparency = 0.2
hTitle.TextStrokeColor3 = C.FIRE3
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
sbFrame.Size = UDim2.new(0, 122, 1, -66)
sbFrame.Position = UDim2.new(0, 12, 0, 58)
sbFrame.BackgroundColor3 = C.PANEL
sbFrame.BackgroundTransparency = 0.2
sbFrame.BorderSizePixel = 0
sbFrame.Parent = panel
rnd(sbFrame, 12)
strk(sbFrame, C.FIRE2, 1, 0.6)

local sb = Instance.new("ScrollingFrame")
sb.Size = UDim2.new(1, -4, 1, -4)
sb.Position = UDim2.new(0, 2, 0, 2)
sb.BackgroundTransparency = 1
sb.BorderSizePixel = 0
sb.ScrollBarThickness = 3
sb.ScrollBarImageColor3 = C.FIRE2
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
ct.Size = UDim2.new(1, -152, 1, -66)
ct.Position = UDim2.new(0, 142, 0, 58)
ct.BackgroundColor3 = C.PANEL
ct.BackgroundTransparency = 0.2
ct.BorderSizePixel = 0
ct.Parent = panel
rnd(ct, 12)
strk(ct, C.FIRE2, 1, 0.6)

local cs = Instance.new("ScrollingFrame")
cs.Size = UDim2.new(1, -16, 1, -16)
cs.Position = UDim2.new(0, 8, 0, 8)
cs.BackgroundTransparency = 1
cs.BorderSizePixel = 0
cs.ScrollBarThickness = 3
cs.ScrollBarImageColor3 = C.FIRE2
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
    deco.BackgroundColor3 = C.FIRE2
    deco.BorderSizePixel = 0
    deco.Parent = f
    rnd(deco, 2)
    local decoGrad = Instance.new("UIGradient")
    decoGrad.Color = ColorSequence.new(C.FIRE1, C.FIRE_BRIGHT, C.FIRE3)
    decoGrad.Parent = deco
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 1, 0)
    l.Position = UDim2.new(0, 16, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = icon .. "  " .. string.upper(title)
    l.TextColor3 = C.FIRE_BRIGHT
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
    local fStrk = strk(f, C.FIRE2, 1, 0.7)

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

    t.BackgroundColor3 = state and C.FIRE1 or C.PANEL
    k.Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    k.BackgroundColor3 = state and C.FIRE_BRIGHT or C.DIM

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
            BackgroundColor3 = state and C.FIRE_BRIGHT or C.DIM
        }):Play()
        TweenService:Create(t, TweenInfo.new(0.2), {BackgroundColor3 = state and C.FIRE1 or C.PANEL}):Play()
        fStrk.Color = state and C.FIRE_BRIGHT or C.FIRE3
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
    strk(f, C.FIRE2, 1, 0.7)

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
    v.TextColor3 = C.FIRE_BRIGHT
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
    fill.BackgroundColor3 = C.FIRE_BRIGHT
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
    strk(kn, C.FIRE_BRIGHT, 2)

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
    strk(f, C.FIRE2, 1, 0.7)

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
    strk(cB, C.FIRE_BRIGHT, 1.5)

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
    strk(b, C.FIRE_BRIGHT, 1, 0.7)
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
    strk(f, C.FIRE2, 1, 0.7)

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
    v.TextColor3 = C.FIRE_BRIGHT
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
    ind.BackgroundColor3 = C.FIRE_BRIGHT
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
btnContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; wasDragged = false
        ds = input.Position; dp = btnContainer.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - ds
        if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then wasDragged = true end
        btnContainer.Position = UDim2.new(dp.X.Scale, dp.X.Offset + d.X, dp.Y.Scale, dp.Y.Offset + d.Y)
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

print("✅ [5/8] GUI + Komponen loaded (Tombol Kecil + Api Terang)")-- =========================================================
-- BAGIAN 6/8 : TAB UI PART 1
-- =========================================================

-- ============================
-- TAB: FIRE
-- ============================
makeTab("Fire", "🔥", 1, function()
    sec("Fire Control", "⚙️")
    tog("Enable Fire", false, function(s) S.FireOn = s; applyFire() end)
    sl("Fire Size", 1, 15, 5, function(v) S.FireSize = v; applyFire() end)

    sec("Pilih Efek Fire (60)", "🔥")
    lbl("Klik efek untuk ganti", C.FIRE_BRIGHT)
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
        strk(btn2, C.FIRE2, 1, 0.6)
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
            btn2.BackgroundColor3 = C.FIRE2
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
            btn2.BackgroundColor3 = C.FIRE2
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
    lbl("Klik efek untuk ganti", C.FIRE_BRIGHT)
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
        strk(btn2, C.FIRE2, 1, 0.6)
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
            btn2.BackgroundColor3 = C.FIRE2
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
            btn2.BackgroundColor3 = C.FIRE2
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
            _G.Roooor_StatusESP = {}
        end
    end)
    sl("Nama Size", 8, 60, 14, function(v) S.ESP_Size = v end)
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

    sec("Item ESP", "📦")
    tog("ESP Item", false, function(s) S.ESP_Item = s end)
    cpk("Item Color", S.ESP_ItemColor, function(c) S.ESP_ItemColor = c end)
end)

-- ============================
-- TAB: SURVIVOR (Ada Anti Fake Hit + Abyss Dodge)
-- ============================
makeTab("Survivor", "🏃", 4, function()
    sec("Auto Parry 360° GACOR v4", "🛡️")
    tog("Enable Auto Parry", false, function(s) S.Parry = s; if s then scanKillers() end end)
    sl("Parry Distance", 3, 25, 8, function(v) S.ParryDist = v end)
    lbl("Anti-miss + Prediksi + Real Attack Detect", C.GRN)

    sec("Anti Fake Hit", "⚡")
    tog("Enable Anti Fake Hit", false, function(s)
        S.AntiFakeHit = s
        if s then scanKillers() end
    end)
    sl("Dodge Range", 5, 30, 15, function(v) S.DodgeRange = v end)
    lbl("Kalau killer fake hit, auto hindar", C.FIRE_BRIGHT)

    sec("Anti Abyss Dodge", "🌀")
    tog("Enable Abyss Dodge", false, function(s) S.AbyssDodge = s end)
    lbl("Abyss slash = auto jongkok", C.FIRE_BRIGHT)

    sec("Parry Circle", "🔵")
    tog("Enable Parry Circle", false, function(s) S.ParryCircle = s end)
    sl("Circle Size", 5, 50, 15, function(v) S.ParryCircleSize = v end)

    sec("Auto Skill Check", "🎯")
    tog("Enable Skill Check", false, function(s) S.Skill = s end)

    sec("Auto Heal", "💊")
    tog("Enable Auto Heal", false, function(s) S.AutoHeal = s end)
    sl("Heal Threshold HP", 10, 100, 40, function(v) S.AutoHealThreshold = v end)

    sec("Auto Repair Generator", "⚙️")
    tog("Enable Auto Repair", false, function(s) S.AutoRepair = s end)

    sec("Auto Revive", "💀")
    tog("Enable Auto Revive", false, function(s) S.AutoRevive = s end)

    sec("Auto Dodge Killer", "🏃")
    tog("Enable Auto Dodge", false, function(s) S.AutoDodge = s end)

    sec("Auto Vault", "🪟")
    tog("Enable Auto Vault", false, function(s) S.AutoVault = s end)

    sec("Instant Interact", "⚡")
    tog("Enable Instant Interact", false, function(s) S.InstantInteract = s end)

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

print("✅ [6/8] Tab Part 1 loaded")-- =========================================================
-- BAGIAN 7/8 : TAB UI PART 2
-- =========================================================

-- ============================
-- TAB: VISUAL
-- ============================
makeTab("Visual", "🎨", 6, function()
    sec("Top 5 Wajib", "⭐")
    tog("Fullbright", false, function(s) S.Fullbright = s; applyFullbright(s) end)
    sl("Fullbright Level (0-100)", 0, 100, 50, function(v)
        S.FullbrightVal = v
        if S.Fullbright then applyFullbright(true) end
    end)
    lbl("0 = gelap, 50 = normal, 100 = terang", C.FIRE_BRIGHT)
    tog("No Fog", false, function(s) S.NoFog = s; applyNoFog(s) end)
    tog("Ultra HD", false, function(s) S.UltraHD = s; applyUltraHD() end)
    tog("Contrast", false, function(s) S.Contrast = s; applyContrast() end)
    sl("Contrast Value", -1, 2, 0.3, function(v) S.ContrastVal = v; applyContrast() end)
    sl("Saturation", -1, 1, 0.2, function(v) S.SaturationVal = v; applyContrast() end)

    sec("FOV Changer", "📸")
    tog("Enable FOV", false, function(s) S.FOVEnabled = s; applyFOV() end)
    sl("FOV Value", 40, 120, 70, function(v) S.FOV = v; applyFOV() end)

    sec("Sky Changer (7 Sky)", "🌤️")
    lbl("Klik untuk ganti sky", C.FIRE_BRIGHT)
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
        strk(btn2, C.FIRE2, 1, 0.6)
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
            btn2.BackgroundColor3 = C.FIRE2
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
            btn2.BackgroundColor3 = C.FIRE2
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(0.1, 0.1, 0.1)
        end)
    end

    sec("Appearance", "💫")
    tog("Kaki Satu Hilang (Kanan)", false, function(s) S.Korblox = s; applyKorblox(s) end)
    tog("Headless", false, function(s) S.Headless = s; applyHeadless(s) end)
end)

-- ============================
-- TAB: 8-BIT CROWN
-- ============================
makeTab("8-Bit", "👑", 7, function()
    sec("8-Bit Royal Crown", "👑")
    tog("👑 Enable 8-Bit Crown", false, function(s)
        S.EightBitCrown = s
        apply8BitCrown(s, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
    end)
    lbl("Mahkota pixel + efek api warna-warni", C.FIRE_BRIGHT)

    sec("Ukuran Crown", "📏")
    sl("Size", 0.3, 3, 1, function(v)
        S.EightBitSize = v
        if S.EightBitCrown then
            apply8BitCrown(true, v, S.CrownX, S.CrownY, S.CrownZ)
        end
    end)

    sec("Posisi X (Kiri-Kanan)", "↔️")
    sl("X Position", -3, 3, 0, function(v)
        S.CrownX = v
        if S.EightBitCrown then
            apply8BitCrown(true, S.EightBitSize, v, S.CrownY, S.CrownZ)
        end
    end)

    sec("Posisi Y (Atas-Bawah)", "↕️")
    sl("Y Position", -2, 3, 1.2, function(v)
        S.CrownY = v
        if S.EightBitCrown then
            apply8BitCrown(true, S.EightBitSize, S.CrownX, v, S.CrownZ)
        end
    end)

    sec("Posisi Z (Depan-Belakang)", "🔃")
    sl("Z Position", -3, 3, 0, function(v)
        S.CrownZ = v
        if S.EightBitCrown then
            apply8BitCrown(true, S.EightBitSize, S.CrownX, S.CrownY, v)
        end
    end)

    sec("QUICK POSITION", "🎯")
    btn("⬆️ Ke Atas", function()
        S.CrownY = (S.CrownY or 1.2) + 0.3
        apply8BitCrown(true, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
    end)
    btn("⬇️ Ke Bawah", function()
        S.CrownY = (S.CrownY or 1.2) - 0.3
        apply8BitCrown(true, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
    end)
    btn("⬅️ Ke Kiri", function()
        S.CrownX = (S.CrownX or 0) - 0.3
        apply8BitCrown(true, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
    end)
    btn("➡️ Ke Kanan", function()
        S.CrownX = (S.CrownX or 0) + 0.3
        apply8BitCrown(true, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
    end)
    btn("🔄 Reset Posisi", function()
        S.CrownX = 0; S.CrownY = 1.2; S.CrownZ = 0
        apply8BitCrown(true, S.EightBitSize, 0, 1.2, 0)
    end)
end)

-- ============================
-- TAB: VISUAL+
-- ============================
makeTab("Visual+", "✨", 8, function()
    sec("Efek Jejak Berapi", "🔥")
    tog("Enable Trail Fire", false, function(s)
        S.Trail = s
        applyTrail(s, S.TrailColor)
    end)
    cpk("Trail Fire Color", S.TrailColor, function(c)
        S.TrailColor = c
        if S.Trail then applyTrail(true, c) end
    end)
    lbl("Api muncul di belakang karakter", C.FIRE_BRIGHT)

    sec("Efek Aura Berapi", "🔥")
    tog("Enable Aura Fire", false, function(s)
        S.Aura = s
        applyAura(s, S.AuraColor)
    end)
    cpk("Aura Fire Color", S.AuraColor, function(c)
        S.AuraColor = c
        if S.Aura then applyAura(true, c) end
    end)

    sec("Efek Kill", "💥")
    tog("Enable Kill Effect", false, function(s) S.KillEffect = s end)

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

    sec("Speed Hack", "🚀")
    tog("Enable Speed Hack", false, function(s) S.SpeedHack = s end)
    sl("Speed Hack Value", 20, 300, 40, function(v) S.SpeedHackVal = v end)

    sec("Fly", "🕊️")
    tog("Enable Fly", false, function(s)
        S.Fly = s
        if s then _G.Roooor_startFly() else _G.Roooor_stopFly() end
    end)
    sl("Fly Speed", 10, 200, 50, function(v) S.FlySpeed = v end)
    lbl("WASD + Space (naik) + LShift (turun)", C.FIRE_BRIGHT)

    sec("Instant Escape", "🚪")
    btn("🚀 Instant Escape (TP Finish)", function() teleportToFinishLine() end)

    sec("Fast Vault", "🏃")
    tog("Enable Fast Vault", false, function(s) S.FastVault = s end)
    sl("Animation Speed", 1, 5, 1.5, function(v) S.FastVaultSpeed = v end)
end)

-- ============================
-- TAB: ANTI
-- ============================
makeTab("Anti", "🛡️", 10, function()
    sec("Anti Grab", "✋")
    tog("Enable Anti Grab", false, function(s) S.AntiGrab = s end)

    sec("Anti Hook", "🪝")
    tog("Enable Anti Hook", false, function(s) S.AntiHook = s end)

    sec("Anti Blind", "👁️")
    tog("Enable Anti Blind", false, function(s) S.AntiBlind = s end)

    sec("Anti Stun", "⚡")
    tog("Enable Anti Stun", false, function(s) S.AntiStun = s end)

    sec("Anti Ragdoll", "🤸")
    tog("Enable Anti Ragdoll", false, function(s) S.AntiRagdoll = s end)

    sec("Anti Slow", "🐌")
    tog("Enable Anti Slow", false, function(s) S.AntiSlow = s end)

    sec("Anti AFK", "💤")
    tog("Enable Anti AFK", false, function(s) S.AntiAFK = s end)
end)

-- ============================
-- TAB: TOP 10
-- ============================
makeTab("Top 10", "🏆", 11, function()
    sec("Safe Zone Warning", "🟢")
    tog("Enable Safe Zone", false, function(s) S.SafeZone = s end)

    sec("Escape Alert", "⚠️")
    tog("Enable Escape Alert", false, function(s) S.EscapeAlert = s end)
    sl("Alert Range", 20, 200, 60, function(v) S.EscapeAlertRange = v end)

    sec("Player List", "👥")
    tog("Show Player List", false, function(s)
        S.PlayerList = s
        if s then
            _G.Roooor_createPlayerList()
        else
            local plg = PG:FindFirstChild("RoooorPlayerList")
            if plg then plg:Destroy() end
        end
    end)
    tog("Enable TP to Player", false, function(s) S.TPtoPlayer = s end)
    lbl("Klik nama player di list", C.DIM)
end)

-- ============================
-- TAB: SETTINGS
-- ============================
makeTab("Settings", "⚙️", 12, function()
    sec("Keybind", "⌨️")
    lbl("Klik tombol 🔥 = Buka Menu", C.FIRE_BRIGHT)
    lbl("Drag tombol 🔥 = Pindah posisi", C.DIM)
    lbl("RightShift = Toggle Menu", C.DIM)

    sec("Info", "ℹ️")
    lbl("RoooorHub Ultimate Fire v3", C.FIRE_BRIGHT)
    lbl("60 Fire + 20 Fire Feet + 7 Sky", C.FIRE_BRIGHT)
    lbl("ESP Fixed + Fullbright Slider", C.FIRE_BRIGHT)
    lbl("Parry v4 + Anti Fake Hit + Abyss Dodge", C.GRN)
    lbl("Auto Skill Check (TIDAK DIUBAH)", C.GRN)
    lbl("Made with 🔥", C.FIRE_BRIGHT)
end)

print("✅ [7/8] Tab Part 2 loaded")-- =========================================================
-- BAGIAN 8/8 : RESPAWN + ANTI-RESET + FPS + FINAL
-- =========================================================

-- ============================
-- RESPAWN HANDLER
-- ============================
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    hookedKillers = {}
    _G.HookedKillers = hookedKillers

    if S.FireOn then applyFire() end
    if S.FireFeetOn then applyFireFeet() end
    if S.Parry or S.AntiFakeHit then scanKillers() end
    if S.Korblox then task.wait(0.3); applyKorblox(true) end
    if S.Headless then task.wait(0.3); applyHeadless(true) end
    if S.EightBitCrown then task.wait(0.3); apply8BitCrown(true, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ) end
    if S.Trail then task.wait(0.3); applyTrail(true, S.TrailColor) end
    if S.Aura then task.wait(0.3); applyAura(true, S.AuraColor) end
    if S.Crosshair then task.wait(0.3); applyCrosshair(true, S.CrosshairColor, S.CrosshairSize) end
    if S.ZoomOut then task.wait(0.3); applyZoomOut(true, S.ZoomOutValue) end
    if S.Fullbright then task.wait(0.3); applyFullbright(true) end
    if S.NoFog then task.wait(0.3); applyNoFog(true) end
    if S.UltraHD then task.wait(0.3); applyUltraHD() end
    if S.Contrast then task.wait(0.3); applyContrast() end
    if S.FOVEnabled then task.wait(0.3); applyFOV() end
end)

-- ============================
-- ANTI-RESET TOGGLE
-- ============================
task.spawn(function()
    while gui.Parent do
        task.wait(0.4)
        for name, state in pairs(_G.ToggleStates) do
            if name == "👑 Enable 8-Bit Crown" then
                if S.EightBitCrown ~= state then
                    S.EightBitCrown = state
                    apply8BitCrown(state, S.EightBitSize, S.CrownX, S.CrownY, S.CrownZ)
                end
            end
            if name == "Enable Fire" then
                if S.FireOn ~= state then
                    S.FireOn = state
                    applyFire()
                end
            end
            if name == "Enable Fire Feet" then
                if S.FireFeetOn ~= state then
                    S.FireFeetOn = state
                    applyFireFeet()
                end
            end
            if name == "Kaki Satu Hilang (Kanan)" then
                if S.Korblox ~= state then
                    S.Korblox = state
                    applyKorblox(state)
                end
            end
            if name == "Headless" then
                if S.Headless ~= state then
                    S.Headless = state
                    applyHeadless(state)
                end
            end
            if name == "Enable Trail Fire" then
                if S.Trail ~= state then
                    S.Trail = state
                    applyTrail(state, S.TrailColor)
                end
            end
            if name == "Enable Aura Fire" then
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
            if name == "Fullbright" then
                if S.Fullbright ~= state then
                    S.Fullbright = state
                    applyFullbright(state)
                end
            end
            if name == "No Fog" then
                if S.NoFog ~= state then
                    S.NoFog = state
                    applyNoFog(state)
                end
            end
            if name == "Ultra HD" then
                if S.UltraHD ~= state then
                    S.UltraHD = state
                    applyUltraHD()
                end
            end
            if name == "Contrast" then
                if S.Contrast ~= state then
                    S.Contrast = state
                    applyContrast()
                end
            end
            if name == "Enable FOV" then
                if S.FOVEnabled ~= state then
                    S.FOVEnabled = state
                    applyFOV()
                end
            end
            if name == "Enable Auto Parry" then
                if S.Parry ~= state then
                    S.Parry = state
                    if state then scanKillers() end
                end
            end
            if name == "Enable Anti Fake Hit" then
                if S.AntiFakeHit ~= state then
                    S.AntiFakeHit = state
                    if state then scanKillers() end
                end
            end
            if name == "Enable Abyss Dodge" then
                if S.AbyssDodge ~= state then
                    S.AbyssDodge = state
                end
            end
            if name == "Enable ESP Name" then
                if S.ESP_Name ~= state then
                    S.ESP_Name = state
                end
            end
            if name == "ESP Generator" then S.ESP_Generator = state end
            if name == "ESP Pallet" then S.ESP_Pallet = state end
            if name == "ESP Window" then S.ESP_Window = state end
            if name == "ESP SCP" then S.ESP_SCP = state end
            if name == "ESP Item" then S.ESP_Item = state end
        end
    end
end)

-- ============================
-- FPS PANEL (FIRE STYLE)
-- ============================
local fpsPanel = Instance.new("Frame")
fpsPanel.Size = UDim2.new(0, 150, 0, 24)
fpsPanel.Position = UDim2.new(0.5, -75, 0, 6)
fpsPanel.BackgroundColor3 = Color3.fromRGB(30, 10, 5)
fpsPanel.BackgroundTransparency = 0.3
fpsPanel.BorderSizePixel = 0
fpsPanel.Parent = gui
rnd(fpsPanel, 12)
strk(fpsPanel, C.FIRE_BRIGHT, 1, 0.4)

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
-- KEYBIND RightShift
-- ============================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        panel.Visible = not panel.Visible
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
-- =========================================================
print("=====================================================")
print("🔥 ROOORHUB ULTIMATE FIRE EDITION v3")
print("🎉 FULL SUCCESS - ALL FEATURES LOADED!")
print("=====================================================")
print("📋 DAFTAR TAB:")
print("  1. 🔥 Fire          — 60 Efek (semua work!)")
print("  2. 👟 Fire Feet     — 20 Efek")
print("  3. 👁️ ESP           — Player + Gen + Pallet + Window + SCP + Item (FIXED)")
print("  4. 🏃 Survivor      — Parry v4 + Anti Fake Hit + Abyss Dodge")
print("  5. 🔪 Killer        — Attack + KillAll + Hitbox + Masked")
print("  6. 🎨 Visual        — Fullbright Slider 0-100 + NoFog + Sky")
print("  7. 👑 8-Bit Crown   — Bisa diatur posisi + ukuran")
print("  8. ✨ Visual+       — Trail Fire + Aura Fire + RGB + Crosshair")
print("  9. 🏃 Movement      — WalkSpeed + SpeedHack + Fly")
print(" 10. 🛡️ Anti          — Grab + Hook + Blind + Stun + Ragdoll + Slow")
print(" 11. 🏆 Top 10        — SafeZone + EscapeAlert + PlayerList")
print(" 12. ⚙️ Settings      — Info + Keybind")
print("=====================================================")
print("✨ Loading 4D HD 'SELAMAT DATANG SC PENGANGGURAN'")
print("🔥 Tombol menu KECIL + API TERANG + BISA DIGESER")
print("⚔️ Auto Parry GACOR v4 (Real Attack Detection)")
print("⚡ Anti Fake Hit (fake = dodge, real = parry)")
print("🌀 Abyss Dodge (Crouch saat slash)")
print("👁️ ESP FIXED — semua tipe work")
print("📊 Fullbright slider 0-100")
print("👑 8-Bit Crown bisa diatur posisi X/Y/Z")
print("=====================================================")
print("Total: 60+ FITUR PREMIUM")
print("=====================================================")
