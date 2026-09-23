-- ============================================
-- ⚡ TIARHUB v17.5 + PATCH - Part 1/6
-- Setup, Config & Helper
-- ============================================

if _G.TiarHubLoaded then
    warn("[TiarHub] Script udah jalan. Skip Part 1.")
    return
end

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local InsertService = game:GetService("InsertService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Share ke _G
_G.Rayfield = Rayfield
_G.Players = Players
_G.RunService = RunService
_G.ReplicatedStorage = ReplicatedStorage
_G.UserInputService = UserInputService
_G.VirtualInputManager = VirtualInputManager
_G.Lighting = Lighting
_G.Stats = Stats
_G.CoreGui = CoreGui
_G.SoundService = SoundService
_G.InsertService = InsertService
_G.LocalPlayer = LocalPlayer
_G.PlayerGui = PlayerGui

-- ============ RAINBOW ============
local RainbowHue = 0
RunService.Heartbeat:Connect(function()
    RainbowHue = (RainbowHue + 0.008) % 1
end)
local function getRainbowColor()
    return Color3.fromHSV(RainbowHue, 1, 1)
end
_G.getRainbowColor = getRainbowColor

-- ============ WINDOW ============
local Window = Rayfield:CreateWindow({
    name = "⚡ TiarHub ⚡",
    subtitle = "Violence District | v17.5",
    sidebarLayout = true,
    configuration = { autoSave = true, autoLoad = true, fileName = "TiarHubV17" }
})
_G.TiarHubWindow = Window

-- ============ CONFIG - ESP ============
_G.ESP = {
    Survivor = false, Killer = false, Generator = false,
    Hook = false, Pallet = false, Window = false, SCP = false,
    Distance = 300, Mode = "Highlight",
    ShowName = true, NameSize = 14,
    SurvivorColor = Color3.fromRGB(60, 255, 120),
    KillerColor = Color3.fromRGB(255, 60, 60),
    GeneratorColor = Color3.fromRGB(255, 170, 0),
    HookColor = Color3.fromRGB(180, 80, 255),
    PalletColor = Color3.fromRGB(255, 220, 80),
    WindowColor = Color3.fromRGB(80, 255, 255),
    SCPColor = Color3.fromRGB(255, 0, 0)
}

_G.ESPStatus = { Enabled = false, ShowName = true, ShowDistance = true, ShowHealth = false, Radius = 100 }
_G.KillerWarning = { Enabled = false, Distance = 60, Color = Color3.fromRGB(255, 0, 0) }

_G.Visual = {
    Fullbright = false, NoFog = false, NoShadow = false,
    NoBloom = false, NoBlur = false,
    ColorCorrection = false,
    Saturation = 0, Brightness = 0, Contrast = 0,
    AmbientColorEnabled = false,
    AmbientColor = Color3.fromRGB(255, 255, 255),
    ClockTimeEnabled = false, ClockTime = 14,
    FogControlEnabled = false, FogEnd = 100000, FogStart = 0,
    FogColor = Color3.fromRGB(200, 200, 200),
    NoCameraShake = false, NoBlood = false
}

_G.VisualOriginal = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart, FogColor = Lighting.FogColor
}

-- ============ CONFIG - AUTO PARRY ============
local PARRY_PRESETS = {
    Safety     = { Distance = 12, Debounce = 0.15, Face = 0.5, RequireFacing = true },
    Aggressive = { Distance = 20, Debounce = 0.05, Face = -1,  RequireFacing = false }
}
_G.PARRY_PRESETS = PARRY_PRESETS

_G.Auto = {
    Parry = false, ParryMode = "Safety",
    ParryDistance = 12, FaceSensitivity = 0.5, RequireFacing = true,
    SkillCheck = false, Wiggle = false, WiggleSpam = 5
}

_G.PARRY_DEBOUNCE = 0.15

local function applyParryPreset(mode)
    local p = PARRY_PRESETS[mode]
    if not p then return end
    _G.Auto.ParryDistance = p.Distance
    _G.Auto.FaceSensitivity = p.Face
    _G.Auto.RequireFacing = p.RequireFacing
    _G.PARRY_DEBOUNCE = p.Debounce
end
_G.applyParryPreset = applyParryPreset

_G.ParryRangeVisual = {
    Enabled = false, Color = Color3.fromRGB(255, 80, 80),
    Transparency = 0.7, RainbowMode = false, PulseEnabled = true
}
_G.ParryCircle = nil
_G.ParryCircleInner = nil

_G.AutoFlee = { Enabled = false, DetectDistance = 50, Cooldown = 0.1 }
_G.LastFlee = 0

_G.FastVault = {
    Enabled = false, Speed = 1.2,
    ReplaceMap = { ["rbxassetid://83873880822918"] = "rbxassetid://136962284480779" }
}
_G.VaultTracks = {}

_G.AutoDodgeAbyss = {
    Enabled = false, DetectRange = 18, Cooldown = 0.5,
    CrouchDuration = 0.3, LastDodge = 0, IsCrouching = false
}

_G.FakePerks = {
    Flowstate = { Enabled = false, Duration = 3, SpeedBoost = 20 },
    SnakeStep = { Enabled = false, SpeedBoost = 90 },
    QuickRecovery = { Enabled = false },
    LastVault = 0, LastCrouchState = false
}

_G.SilentAimSpear = {
    Enabled = false, TargetMode = "Killer",
    FOV = 250, AimPart = "HumanoidRootPart",
    Prediction = 0.12, Holding = false, ShowFOV = false
}

_G.HideSpark = { Enabled = false }
_G.HiddenSparkCache = {}

_G.Teleport = { LastTeleport = 0, Cooldown = 0.5 }
_G.AutoEscape = { Enabled = false, DetectDistance = 40, Cooldown = 0.8, LastEscape = 0 }
_G.SkillCheckMode = "Perfect"

_G.SoundFeedback = { Enabled = true, CurrentSound = "Click", Volume = 0.5, LastPlay = 0, Cooldown = 0.05 }

local SoundList = {
    Click  = "rbxassetid://6895079853",
    Switch = "rbxassetid://876939830",
    Beep   = "rbxassetid://4817809188",
    Bell   = "rbxassetid://5156781795",
    Whoosh = "rbxassetid://5063167535"
}
_G.SoundList = SoundList

_G.SoundInstance = nil

local function initSound()
    if _G.SoundInstance then return end
    local s = Instance.new("Sound")
    s.Name = "TiarClickSound"
    s.Volume = _G.SoundFeedback.Volume
    pcall(function() s.Parent = SoundService end)
    if not s.Parent then s.Parent = CoreGui end
    _G.SoundInstance = s
end

local function playClickSound()
    if not _G.SoundFeedback.Enabled then return end
    local now = tick()
    if now - _G.SoundFeedback.LastPlay < _G.SoundFeedback.Cooldown then return end
    _G.SoundFeedback.LastPlay = now
    initSound()
    pcall(function()
        _G.SoundInstance.SoundId = _G.SoundList[_G.SoundFeedback.CurrentSound] or _G.SoundList.Click
        _G.SoundInstance.Volume = _G.SoundFeedback.Volume
        _G.SoundInstance:Play()
    end)
end
_G.playClickSound = playClickSound
initSound()

_G.AvatarCopier = {
    Enabled = true, TargetUsername = "",
    OriginalDescription = nil, CurrentCopiedUserId = nil, BlockyBody = true
}

_G.GunAim = {
    Enabled = false, Holding = false, TargetMode = "Killer",
    Strength = 1, Predict = true, PredictStrength = 0.12,
    FOV = 250, VisibilityCheck = false, AimPart = "HumanoidRootPart",
    ShowTracer = false, TracerColor = Color3.fromRGB(255, 0, 0)
}

_G.FOVCircle = nil
_G.FOVCircleInner = nil
_G.FOVCircleVisible = false
_G.FOVCircleSize = 250
_G.FOVCircleColor = Color3.fromRGB(255, 255, 255)

_G.KillerAim = { Enabled = false, FOV = 200, Strength = 0.5, Holding = false }

_G.Killer = {
    AutoAttack = false,
    AutoCarry = false, AutoHook = false, KillAll = false,
    AutoStalk = false, StalkRange = 150,
    AutoHookAllDowned = false, AutoHookAllRange = 500,
    AutoSprint = false, AutoSprintValue = 30,
    AutoFaceTarget = false, AutoFaceRange = 20,
    PredictionAttack = false, PredictStrength = 0.15
}
_G.KillerBusy = false
_G.KillerTarget = nil
_G.StalkConnection = nil

_G.HitMarker = {
    Enabled = false, Color = Color3.fromRGB(255, 0, 0),
    Size = 20, Thickness = 2, Duration = 0.15
}
_G.HitMarkerLines = {}
_G.HitMarkerActive = false
_G.HitMarkerEnd = 0

_G.ChaseDetector = { Enabled = false, Range = 30, LastNotify = 0, Cooldown = 2 }

_G.Movement = {
    WalkSpeedEnabled = false, WalkSpeedValue = 17.6, OriginalWalkSpeed = 16,
    NoClip = false
}

_G.Moonwalk = {
    Enabled = false, ShowButton = false,
    SpamSpeed = 30, Intensity = 35, SlowSpeed = 13, UseSlow = true,
    Mode = "Default", FOVPreset = 90
}
_G.MoonwalkConnection = nil
_G.MoonwalkHeartbeat = nil
_G.MoonwalkButton = nil
_G.ParryActive = false

_G.Crosshair = { Enabled = false, Size = 8, Thickness = 2, Color = Color3.fromRGB(255, 255, 255), OffsetX = 0, OffsetY = 0 }
_G.CrosshairGui = nil

_G.Emote = { Selected = "Mannrobics" }
_G.EmoteList = { "Mannrobics","Arm Swing","Schadenfreude","Kyoufuu","Backflip","Griddy","Friday Night","Floating Rest","OnePlays","Quick Combo","WarCry","Wave" }

_G.Masked = { CurrentPower = "Cobra" }
_G.MaskedPowers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}

_G.AntiLag = {
    Enabled = false, NoParticles = false, NoTextures = false,
    PhysicsThrottle = false, NoGlobalShadows = false, NetworkLag = false
}

_G.FPS = 0
_G.Frames = 0
_G.LastTick = tick()

-- ============ ⭐ AIMLOCK BARU ============
_G.Aimlock = {
    Enabled = false,
    Mode = "Killer",
    RadiusLock = 250,
    AimPart = "Head",
    Smoothness = 0.35,
    Prediction = true,
    PredictStrength = 0.12,
    ShowFOV = true,
    AutoSnap = false,
    Target = nil
}
_G.AimlockFOV = nil

_G.KillerAnims = {
["rbxassetid://105374834496520"] = true, ["rbxassetid://113255068724446"] = true,
["rbxassetid://118907603246885"] = true, ["rbxassetid://129784271201071"] = true,
["rbxassetid://117042998468241"] = true, ["rbxassetid://122812055447896"] = true,
["rbxassetid://78935059863801"] = true, ["rbxassetid://74968262036854"] = true,
["rbxassetid://78432063483146"] = true, ["rbxassetid://132817836308238"] = true,
["rbxassetid://133963973694098"] = true, ["rbxassetid://111920872708571"] = true,
["rbxassetid://80411309607666"] = true, ["rbxassetid://98163597193511"] = true,
["rbxassetid://82666958311998"] = true, ["rbxassetid://110355011987939"] = true,
["rbxassetid://139369275981139"] = true, ["rbxassetid://135002183282873"] = true,
["rbxassetid://121216847022485"] = true, ["rbxassetid://130593238885843"] = true,
["rbxassetid://117070354890871"] = true, ["rbxassetid://106871536134254"] = true,
["rbxassetid://138720291317243"] = true
}

-- ============ REMOTES ============
local function findRemote(path)
    local cur = ReplicatedStorage
    for segment in string.gmatch(path, "[^%.]+") do
        cur = cur and cur:FindFirstChild(segment)
        if not cur then return nil end
    end
    return cur
end
_G.findRemote = findRemote

_G.AttackEvent = findRemote("Remotes.Attacks.BasicAttack")
_G.CarryEvent = findRemote("Remotes.Carry.CarrySurvivorEvent")
_G.HookEvent = findRemote("Remotes.Carry.HookEvent")
_G.EmoteRemote = findRemote("Remotes.EmoteHandler")

-- ============ HELPER ============
local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end
_G.getRoot = getRoot

local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end
_G.getHum = getHum

local function isDowned()
    local hum = getHum()
    if not hum then return false end
    return hum.Health <= 0 or hum.Health < 2
end
_G.isDowned = isDowned

local function shouldDisableWalkSpeed()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local anim = track.Animation
                if anim and anim.AnimationId then
                    local id = anim.AnimationId:match("%d+")
                    if id and _G.KillerAnims["rbxassetid://" .. id] then return true end
                end
            end
        end
    end
    if hum and (hum.Health <= 0 or hum.Health < 2) then return true end
    return false
end
_G.shouldDisableWalkSpeed = shouldDisableWalkSpeed

local function GetPos(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj.Position end
    if obj:IsA("Model") then
        local ok, pivot = pcall(function() return obj:GetPivot().Position end)
        if ok then return pivot end
    end
    return nil
end
_G.GetPos = GetPos

local function getTeamLabel(plr)
    if not plr.Team then return "?" end
    if plr.Team.Name == "Killer" then return "KILLER" end
    if plr.Team.Name == "Survivors" or plr.Team.Name == "Survivor" then return "SURVIVOR" end
    return plr.Team.Name
end
_G.getTeamLabel = getTeamLabel

local function GetNearestKiller()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team and plr.Team.Name == "Killer" and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < shortest then shortest = dist; closest = hrp end
            end
        end
    end
    return closest, shortest
end
_G.GetNearestKiller = GetNearestKiller

_G.TiarHubLoaded = true
print("[TiarHub v17.5] Part 1/6 loaded. Ketik part berikutnya.")-- ============================================
-- ⚡ TIARHUB v17.5 + PATCH - Part 2/6
-- ESP System
-- ============================================

if not _G.TiarHubLoaded then
    warn("[TiarHub] Jalankan Part 1 dulu!")
    return
end

local Players = _G.Players
local RunService = _G.RunService
local LocalPlayer = _G.LocalPlayer
local PlayerGui = _G.PlayerGui
local ESP = _G.ESP
local ESPStatus = _G.ESPStatus
local KillerWarning = _G.KillerWarning
local getRoot = _G.getRoot
local getTeamLabel = _G.getTeamLabel
local GetPos = _G.GetPos

-- ============ ESP OBJECT STORAGE ============
local ESPObjects = {}
local ESPNames = {}
local StatusESP = {}
local CachedObjects = { Generators = {}, Hooks = {}, Pallets = {}, Windows = {} }
local CachedSCP = {}

_G.ESPObjects = ESPObjects
_G.ESPNames = ESPNames
_G.StatusESP = StatusESP
_G.CachedObjects = CachedObjects
_G.CachedSCP = CachedSCP

-- ============ REMOVE ESP ============
local function removeESP(obj)
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
    if ESPNames[obj] then ESPNames[obj]:Destroy(); ESPNames[obj] = nil end
end
_G.removeESP = removeESP

-- ============ CREATE ESP ============
local function createESP(obj, color, showName, customName)
    if not obj then return end
    if ESPObjects[obj] then
        local h = ESPObjects[obj]
        if ESP.Mode == "Outline" then h.FillTransparency = 1; h.OutlineTransparency = 0
        elseif ESP.Mode == "Fill" then h.FillTransparency = 0.5; h.OutlineTransparency = 1
        else h.FillTransparency = 0.9; h.OutlineTransparency = 0.3 end
        h.FillColor = color; h.OutlineColor = color
    else
        local h = Instance.new("Highlight")
        h.FillColor = color; h.OutlineColor = color
        if ESP.Mode == "Outline" then h.FillTransparency = 1; h.OutlineTransparency = 0
        elseif ESP.Mode == "Fill" then h.FillTransparency = 0.5; h.OutlineTransparency = 1
        else h.FillTransparency = 0.9; h.OutlineTransparency = 0.3 end
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = obj
        ESPObjects[obj] = h
        obj.AncestryChanged:Connect(function(_, parent)
            if not parent then removeESP(obj) end
        end)
    end
    if showName then
        local head = obj:FindFirstChild("Head")
        local adornee = head or (obj:IsA("BasePart") and obj)
        if adornee then
            local playerName = customName or "?"
            local teamLabel = ""
            if not customName then
                local plr = Players:GetPlayerFromCharacter(obj)
                if plr then playerName = plr.Name; teamLabel = getTeamLabel(plr) end
            end
            local displayText = playerName
            if teamLabel ~= "" then displayText = string.format("[%s] %s", teamLabel, playerName) end
            if ESPNames[obj] then
                local bb = ESPNames[obj]
                bb.Size = UDim2.new(0, 250, 0, ESP.NameSize * 2)
                local lbl = bb:FindFirstChildOfClass("TextLabel")
                if lbl then lbl.Text = displayText; lbl.TextSize = ESP.NameSize; lbl.TextColor3 = color end
            else
                local bb = Instance.new("BillboardGui")
                bb.Size = UDim2.new(0, 250, 0, ESP.NameSize * 2)
                bb.AlwaysOnTop = true
                bb.StudsOffset = Vector3.new(0, 2.5, 0)
                bb.Adornee = adornee
                bb.Parent = obj
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = displayText
                lbl.TextColor3 = color
                lbl.TextStrokeTransparency = 0
                lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = ESP.NameSize
                lbl.Parent = bb
                ESPNames[obj] = bb
            end
        end
    end
end
_G.createESP = createESP

-- ============ UPDATE GENERATOR ============
local function UpdateGenerator(generator)
    if not generator or not generator.Parent then return end
    if not ESP.Generator then
        local old = generator:FindFirstChild("GenHighlight"); if old then old:Destroy() end
        local oldName = generator:FindFirstChild("GenNameTag"); if oldName then oldName:Destroy() end
        return
    end
    local percent = 0
    local found = false
    local attr = generator:GetAttribute("Progress")
    if attr and type(attr) == "number" then percent = attr; found = true end
    if not found then
        local attr2 = generator:GetAttribute("RepairProgress")
        if attr2 and type(attr2) == "number" then percent = attr2; found = true end
    end
    if not found then
        for _, v in ipairs(generator:GetDescendants()) do
            if v:IsA("ValueBase") and (v.Name == "Progress" or v.Name == "RepairProgress" or v.Name == "Percent") then
                percent = v.Value; found = true; break
            end
        end
    end
    if not found then
        for _, v in ipairs(generator:GetChildren()) do
            if v:IsA("NumberValue") then percent = v.Value; found = true; break end
        end
    end
    percent = math.clamp(percent, 0, 100)
    local color = ESP.GeneratorColor
    local labelText = "Generator"
    if found then
        color = ESP.GeneratorColor:Lerp(Color3.fromRGB(0, 255, 120), percent / 100)
        labelText = string.format("Gen %.0f%%", percent)
    end
    local h = generator:FindFirstChild("GenHighlight") or Instance.new("Highlight")
    h.Name = "GenHighlight"
    h.Adornee = generator
    h.FillColor = color
    h.OutlineColor = color
    if ESP.Mode == "Outline" then h.FillTransparency = 1; h.OutlineTransparency = 0
    elseif ESP.Mode == "Fill" then h.FillTransparency = 0.5; h.OutlineTransparency = 1
    else h.FillTransparency = 0.9; h.OutlineTransparency = 0.3 end
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = generator
    local bb = generator:FindFirstChild("GenNameTag")
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Name = "GenNameTag"
        bb.Size = UDim2.new(0, 150, 0, 40)
        bb.AlwaysOnTop = true
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.Adornee = generator
        bb.Parent = generator
        local lbl = Instance.new("TextLabel")
        lbl.Name = "Label"
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 14
        lbl.Parent = bb
    end
    local lbl = bb:FindFirstChild("Label") or bb:FindFirstChildOfClass("TextLabel")
    if lbl then lbl.Text = labelText; lbl.TextColor3 = color end
end
_G.UpdateGenerator = UpdateGenerator

-- ============ STATUS ESP ============
local function removeStatusESP(char)
    if StatusESP[char] then StatusESP[char]:Destroy(); StatusESP[char] = nil end
end
_G.removeStatusESP = removeStatusESP

local function createStatusESP(player, char, root)
    if not ESPStatus.Enabled then removeStatusESP(char); return end
    if not root then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end
    local isDown = hum.Health <= 0 or hum.Health < 2
    local dist = (head.Position - root.Position).Magnitude
    if dist > ESPStatus.Radius then removeStatusESP(char); return end
    local text = ""
    local teamLabel = getTeamLabel(player)
    if isDown then text = "DOWN\n" end
    text = text .. string.format("[%s]\n", teamLabel)
    if ESPStatus.ShowName then text = text .. player.Name .. "\n" end
    if ESPStatus.ShowDistance then text = text .. string.format("Dist: %.0f\n", dist) end
    if ESPStatus.ShowHealth then text = text .. string.format("HP: %.0f\n", hum.Health) end
    if text == "" then removeStatusESP(char); return end
    local bb = StatusESP[char]
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 150, 0, 60)
        bb.AlwaysOnTop = true
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextStrokeTransparency = 0
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.Parent = bb
        bb.Adornee = head
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.Parent = char
        StatusESP[char] = bb
    end
    local lbl = bb:FindFirstChildOfClass("TextLabel")
    if lbl then
        lbl.Text = text
        local tc = Color3.new(1, 1, 1)
        if player.Team then
            if player.Team.Name == "Killer" then tc = ESP.KillerColor
            elseif player.Team.Name == "Survivors" or player.Team.Name == "Survivor" then tc = ESP.SurvivorColor end
        end
        if isDown then tc = Color3.fromRGB(255, 0, 0) end
        lbl.TextColor3 = tc
    end
end
_G.createStatusESP = createStatusESP

-- ============ OBJECT CACHE ============
local function cacheObject(obj)
    if not obj then return end
    if not obj:IsA("BasePart") and not obj:IsA("Model") then return end
    local name = obj.Name
    if name == "Generator" then CachedObjects.Generators[obj] = true
    elseif string.find(name, "Hook") and obj:IsA("BasePart") then CachedObjects.Hooks[obj] = true
    elseif name == "Pallet" or name == "Palletwrong" then CachedObjects.Pallets[obj] = true
    elseif name == "Window" then CachedObjects.Windows[obj] = true
    end
    if string.find(string.lower(name), "scp") then CachedSCP[obj] = true end
end
_G.cacheObject = cacheObject

for _, obj in ipairs(workspace:GetDescendants()) do cacheObject(obj) end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(function(obj)
    CachedObjects.Generators[obj] = nil
    CachedObjects.Hooks[obj] = nil
    CachedObjects.Pallets[obj] = nil
    CachedObjects.Windows[obj] = nil
    CachedSCP[obj] = nil
    removeESP(obj)
end)

-- ============ KILLER WARNING ============
local WarningGui = nil
local function updateWarning()
    pcall(function()
        local root = getRoot()
        if not KillerWarning.Enabled or not root then
            if WarningGui then WarningGui.Enabled = false end
            return
        end
        local nearest, dist = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local isKiller = p.Team and p.Team.Name == "Killer"
                if isKiller then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local d = (hrp.Position - root.Position).Magnitude
                        if d < dist then dist = d; nearest = p end
                    end
                end
            end
        end
        if not WarningGui then
            WarningGui = Instance.new("ScreenGui")
            WarningGui.Name = "TiarKillerWarning"
            WarningGui.ResetOnSpawn = false
            WarningGui.IgnoreGuiInset = true
            WarningGui.Parent = PlayerGui
            local frame = Instance.new("Frame")
            frame.Name = "Border"
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 1
            frame.Parent = WarningGui
            local stroke = Instance.new("UIStroke")
            stroke.Name = "Stroke"
            stroke.Thickness = 12
            stroke.Color = KillerWarning.Color
            stroke.Transparency = 0.5
            stroke.Parent = frame
            local text = Instance.new("TextLabel")
            text.Name = "WarnText"
            text.Size = UDim2.new(0, 400, 0, 60)
            text.Position = UDim2.new(0.5, -200, 0, 40)
            text.BackgroundTransparency = 1
            text.Text = "KILLER DEKAT"
            text.TextColor3 = KillerWarning.Color
            text.TextStrokeTransparency = 0
            text.TextStrokeColor3 = Color3.new(0, 0, 0)
            text.Font = Enum.Font.GothamBlack
            text.TextScaled = true
            text.Visible = false
            text.Parent = WarningGui
        end
        WarningGui.Enabled = true
        local border = WarningGui:FindFirstChild("Border")
        local stroke = border and border:FindFirstChild("Stroke")
        local warnText = WarningGui:FindFirstChild("WarnText")
        if dist <= KillerWarning.Distance then
            if stroke then stroke.Transparency = 0.3 end
            if warnText then warnText.Visible = true; warnText.Text = string.format("KILLER DEKAT (%.0f stud)", dist) end
        else
            if stroke then stroke.Transparency = 0.9 end
            if warnText then warnText.Visible = false end
        end
    end)
end
_G.updateWarning = updateWarning

-- ============ WATERMARK FPS/PING ============
RunService.RenderStepped:Connect(function()
    _G.Frames = _G.Frames + 1
    if tick() - _G.LastTick >= 1 then
        _G.FPS = _G.Frames
        _G.Frames = 0
        _G.LastTick = tick()
        local ping = math.floor(_G.Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        pcall(function()
            _G.Rayfield:SetWatermark(string.format("⚡ TiarHub ⚡ | FPS: %d | PING: %d ms", _G.FPS, ping))
        end)
    end
end)

-- ============ MAIN ESP LOOP ============
local lastUpdate = 0
RunService.RenderStepped:Connect(function()
    pcall(function()
        local root = getRoot()
        if not root then return end
        local now = tick()
        if now - lastUpdate < 0.3 then return end
        lastUpdate = now

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local dist = (hrp.Position - root.Position).Magnitude
                        if dist <= ESP.Distance then
                            local isKiller = p.Team and p.Team.Name == "Killer"
                            local isSurv = p.Team and (p.Team.Name == "Survivors" or p.Team.Name == "Survivor")
                            if ESP.Survivor and isSurv then createESP(char, ESP.SurvivorColor, ESP.ShowName)
                            elseif ESP.Killer and isKiller then createESP(char, ESP.KillerColor, ESP.ShowName)
                            else removeESP(char) end
                        else removeESP(char) end
                    end
                    createStatusESP(p, char, root)
                else removeESP(char); removeStatusESP(char) end
            end
        end

        if ESP.Generator then
            for gen in pairs(CachedObjects.Generators) do
                local pos = GetPos(gen)
                if pos and (pos - root.Position).Magnitude <= ESP.Distance then UpdateGenerator(gen)
                else
                    local old = gen:FindFirstChild("GenHighlight"); if old then old:Destroy() end
                    local oldName = gen:FindFirstChild("GenNameTag"); if oldName then oldName:Destroy() end
                end
            end
        end

        if ESP.Hook then
            for hook in pairs(CachedObjects.Hooks) do
                local pos = GetPos(hook)
                if pos and (pos - root.Position).Magnitude <= ESP.Distance then createESP(hook, ESP.HookColor, false)
                else removeESP(hook) end
            end
        else for hook in pairs(CachedObjects.Hooks) do removeESP(hook) end end

        if ESP.Pallet then
            for pallet in pairs(CachedObjects.Pallets) do
                local pos = GetPos(pallet)
                if pos and (pos - root.Position).Magnitude <= ESP.Distance then createESP(pallet, ESP.PalletColor, false)
                else removeESP(pallet) end
            end
        else for pallet in pairs(CachedObjects.Pallets) do removeESP(pallet) end end

        if ESP.Window then
            for win in pairs(CachedObjects.Windows) do
                local pos = GetPos(win)
                if pos and (pos - root.Position).Magnitude <= ESP.Distance then createESP(win, ESP.WindowColor, false)
                else removeESP(win) end
            end
        else for win in pairs(CachedObjects.Windows) do removeESP(win) end end

        if ESP.SCP then
            for scp in pairs(CachedSCP) do
                local pos = GetPos(scp)
                if pos and (pos - root.Position).Magnitude <= ESP.Distance then createESP(scp, ESP.SCPColor, false)
                else removeESP(scp) end
            end
        else for scp in pairs(CachedSCP) do removeESP(scp) end end

        updateWarning()
    end)
end)

print("[TiarHub v17.5] Part 2/6 loaded. Ketik 'lanjut' buat Part 3.")-- ============================================
-- ⚡ TIARHUB v17.5 + PATCH - Part 3/6
-- Survivor + Aimbot + Fake Perks
-- ============================================

if not _G.TiarHubLoaded then
    warn("[TiarHub] Jalankan Part 1 dulu!")
    return
end

local Players = _G.Players
local RunService = _G.RunService
local ReplicatedStorage = _G.ReplicatedStorage
local UserInputService = _G.UserInputService
local VirtualInputManager = _G.VirtualInputManager
local LocalPlayer = _G.LocalPlayer
local PlayerGui = _G.PlayerGui

local Auto = _G.Auto
local AutoFlee = _G.AutoFlee
local AutoDodgeAbyss = _G.AutoDodgeAbyss
local FakePerks = _G.FakePerks
local SilentAimSpear = _G.SilentAimSpear
local Movement = _G.Movement
local GunAim = _G.GunAim
local KillerAim = _G.KillerAim
local HitMarker = _G.HitMarker

local getRoot = _G.getRoot
local getHum = _G.getHum
local isDowned = _G.isDowned
local GetNearestKiller = _G.GetNearestKiller
local KillerAnims = _G.KillerAnims
local findRemote = _G.findRemote

-- ============ AUTO PARRY ============
local lastParry = 0

local function pressRightClick()
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
        task.wait()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
    end)
end

local function GetParryButton()
    local current = PlayerGui
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function pressParryButton()
    if UserInputService.TouchEnabled then
        local btn = GetParryButton()
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = game:GetService("GuiService"):GetGuiInset()
            pcall(function()
                VirtualInputManager:SendTouchEvent(8823, 0, pos.X + size.X/2 + inset.X, pos.Y + size.Y/2 + inset.Y)
                task.wait(0.01)
                VirtualInputManager:SendTouchEvent(8823, 2, pos.X + size.X/2 + inset.X, pos.Y + size.Y/2 + inset.Y)
            end)
        end
    else
        pressRightClick()
    end
end

local function doParry()
    local now = tick()
    if now - lastParry < _G.PARRY_DEBOUNCE then return end
    lastParry = now
    _G.ParryActive = true
    pressParryButton()
    task.delay(0.25, function() _G.ParryActive = false end)
end

local hookedKillers = {}
local lastKillerParry = {}

local function hookKiller(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    animator.AnimationPlayed:Connect(function(track)
        if not Auto.Parry then return end
        local anim = track.Animation
        if not anim then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end
        if not KillerAnims["rbxassetid://" .. id] then return end

        local myRoot = getRoot()
        local enemyRoot = char:FindFirstChild("HumanoidRootPart")
        if not myRoot or not enemyRoot then return end

        local dist = (enemyRoot.Position - myRoot.Position).Magnitude
        if dist > Auto.ParryDistance then return end

        local now = tick()
        if lastKillerParry[char] and now - lastKillerParry[char] < 0.4 then return end
        lastKillerParry[char] = now

        doParry()
    end)
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if Auto.Parry then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        if p.Team and p.Team.Name == "Killer" then
                            hookKiller(p.Character)
                        end
                    end
                end
            end
        end)
    end
end)

-- ============ AUTO SKILL CHECK ============
local TouchID = 8822
local ActionPath = "Survivor-mob.Controls.action.check"
local busy = false
local SkillHeartbeat = nil

local function GetActionTarget()
    local current = PlayerGui
    for segment in string.gmatch(ActionPath, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function pressSpace()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end

local function TriggerMobileButton()
    local b = GetActionTarget()
    if b and b:IsA("GuiObject") then
        local p = b.AbsolutePosition
        local s = b.AbsoluteSize
        local i = game:GetService("GuiService"):GetGuiInset()
        pcall(function()
            VirtualInputManager:SendTouchEvent(TouchID, 0, p.X + (s.X/2) + i.X, p.Y + (s.Y/2) + i.Y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(TouchID, 2, p.X + (s.X/2) + i.X, p.Y + (s.Y/2) + i.Y)
        end)
    end
end

local function startSkillCheck()
    if SkillHeartbeat then SkillHeartbeat:Disconnect() end
    SkillHeartbeat = RunService.RenderStepped:Connect(function()
        pcall(function()
            if not Auto.SkillCheck or busy then return end
            local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
            if not prompt then return end
            local check = prompt:FindFirstChild("Check")
            if not check or not check.Visible then return end
            local line = check:FindFirstChild("Line")
            local goal = check:FindFirstChild("Goal")
            if not line or not goal then return end
            local lr = line.Rotation % 360
            local gr = goal.Rotation % 360

            if _G.SkillCheckMode == "Instant" then
                busy = true
                task.spawn(function()
                    if UserInputService.TouchEnabled then TriggerMobileButton() else pressSpace() end
                    task.wait(0.05)
                    busy = false
                end)
            else
                local centerGoal = (gr + 109) % 360
                local diff = math.abs(lr - centerGoal)
                if diff > 180 then diff = 360 - diff end
                if diff <= 3 then
                    busy = true
                    task.spawn(function()
                        if UserInputService.TouchEnabled then TriggerMobileButton() else pressSpace() end
                        task.wait(0.05)
                        busy = false
                    end)
                end
            end
        end)
    end)
end
_G.startSkillCheck = startSkillCheck

-- ============ AUTO WIGGLE ============
local function AutoWiggle()
    if not Auto.Wiggle then return end
    local char = LocalPlayer.Character
    if not char then return end
    local carried = (char:FindFirstChild("IsCarried") and char.IsCarried.Value)
        or (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)
    if not carried then return end
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return end
    local carry = remotes:FindFirstChild("Carry")
    if not carry then return end
    local event = carry:FindFirstChild("SelfUnHookEvent")
    if not event then return end
    for i = 1, Auto.WiggleSpam do event:FireServer() end
end
_G.AutoWiggle = AutoWiggle

-- ============ AUTO FLEE ============
local function GetFarthestGeneratorPoint(killerRoot)
    if not killerRoot then return nil end
    local bestPoint, farthest = nil, 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.match(obj.Name, "^GeneratorPoint%d+$") then
            local dist = (obj.Position - killerRoot.Position).Magnitude
            if dist > farthest then farthest = dist; bestPoint = obj end
        end
    end
    return bestPoint
end

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if not AutoFlee.Enabled then return end
            local root = getRoot()
            if not root then return end
            local killerRoot, distance = GetNearestKiller()
            if killerRoot and distance <= AutoFlee.DetectDistance and tick() - _G.LastFlee > AutoFlee.Cooldown then
                local point = GetFarthestGeneratorPoint(killerRoot)
                if point then
                    _G.LastFlee = tick()
                    root.CFrame = point.CFrame + Vector3.new(0, 5, 0)
                end
            end
        end)
    end
end)

-- ============ AUTO DODGE ABYSS ============
local function IsAbyssKiller(plr)
    if not plr or not plr.Character then return false end
    if not plr.Team or plr.Team.Name ~= "Killer" then return false end
    if string.find(string.lower(plr.Character.Name), "abyss") then return true end
    if string.find(string.lower(plr.Name), "abyss") then return true end
    return false
end

local function GetNearestAbyss()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and IsAbyssKiller(plr) then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - root.Position).Magnitude
                if d < shortest then shortest = d; closest = hrp end
            end
        end
    end
    return closest, shortest
end

local function FindCrouchButton()
    local paths = {
        "Survivor-mob.Controls.Gui-mob.Crouch",
        "Survivor-mob.Controls.Gui-mob.crouch",
        "Survivor-mob.Controls.crouch",
        "Survivor-mob.Controls.Crouch",
        "Survivor-mob.Controls.action.crouch",
        "Survivor-mob.Controls.action.Crouch",
    }
    for _, path in ipairs(paths) do
        local cur = PlayerGui
        for segment in string.gmatch(path, "[^%.]+") do
            cur = cur and cur:FindFirstChild(segment)
        end
        if cur and cur:IsA("GuiObject") then return cur end
    end
    for _, v in ipairs(PlayerGui:GetDescendants()) do
        if v:IsA("GuiObject") and string.find(string.lower(v.Name), "crouch") then
            return v
        end
    end
    return nil
end

local function PressCrouchButton()
    local btn = FindCrouchButton()
    if btn then
        local pos = btn.AbsolutePosition
        local size = btn.AbsoluteSize
        local inset = game:GetService("GuiService"):GetGuiInset()
        local x = pos.X + size.X/2 + inset.X
        local y = pos.Y + size.Y/2 + inset.Y
        pcall(function()
            VirtualInputManager:SendTouchEvent(7777, 0, x, y)
            task.wait(0.05)
            VirtualInputManager:SendTouchEvent(7777, 2, x, y)
        end)
        return true
    end
    if not UserInputService.TouchEnabled then
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        end)
        return true
    end
    return false
end

local function DoDodgeAbyss()
    if AutoDodgeAbyss.IsCrouching then return end
    AutoDodgeAbyss.IsCrouching = true
    PressCrouchButton()
    task.delay(AutoDodgeAbyss.CrouchDuration, function()
        if AutoDodgeAbyss.Enabled then
            PressCrouchButton()
        end
        AutoDodgeAbyss.IsCrouching = false
    end)
end

task.spawn(function()
    while task.wait(0.15) do
        pcall(function()
            if not AutoDodgeAbyss.Enabled then return end
            local root = getRoot()
            if not root then return end
            if isDowned() then return end
            local abyssRoot, dist = GetNearestAbyss()
            if not abyssRoot then return end
            if dist > AutoDodgeAbyss.DetectRange then return end
            local now = tick()
            if now - AutoDodgeAbyss.LastDodge < AutoDodgeAbyss.Cooldown then return end
            AutoDodgeAbyss.LastDodge = now
            DoDodgeAbyss()
        end)
    end
end)

-- ============ FAKE PERKS ============
local function hookFakeFlowstate(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    animator.AnimationPlayed:Connect(function(track)
        if not FakePerks.Flowstate.Enabled then return end
        local anim = track.Animation
        if not anim or not anim.AnimationId then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end

        local vaultIds = {
            ["rbxassetid://83873880822918"] = true,
            ["rbxassetid://136962284480779"] = true,
        }

        if vaultIds["rbxassetid://" .. id] then
            local now = tick()
            if now - FakePerks.LastVault < 1 then return end
            FakePerks.LastVault = now

            local originalSpeed = hum.WalkSpeed
            hum.WalkSpeed = originalSpeed * (1 + FakePerks.Flowstate.SpeedBoost / 100)

            _G.Rayfield:Notify({ title = "Fake Flowstate", content = "Speed boost aktif!", duration = 2 })

            task.delay(FakePerks.Flowstate.Duration, function()
                if hum and hum.Parent then
                    hum.WalkSpeed = originalSpeed
                end
            end)
        end
    end)
end

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if not FakePerks.SnakeStep.Enabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end

            local isCrouching = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
                or (hum.HipHeight and hum.HipHeight < 1.5)

            if isCrouching and not FakePerks.LastCrouchState then
                FakePerks.LastCrouchState = true
                hum.WalkSpeed = FakePerks.SnakeStep.SpeedBoost
            elseif not isCrouching and FakePerks.LastCrouchState then
                FakePerks.LastCrouchState = false
                if Movement.WalkSpeedEnabled then
                    hum.WalkSpeed = Movement.WalkSpeedValue
                else
                    hum.WalkSpeed = 16
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if not FakePerks.QuickRecovery.Enabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end

            if hum:GetState() == Enum.HumanoidStateType.FallingDown
                or hum:GetState() == Enum.HumanoidStateType.Ragdoll
                or hum.Health < hum.MaxHealth * 0.3 then
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
            end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function() hookFakeFlowstate(char) end)
end)
if LocalPlayer.Character then pcall(function() hookFakeFlowstate(LocalPlayer.Character) end) end

-- ============ FOV CIRCLE (AIMBOT) ============
local Drawing = Drawing
local TracerLine = nil

local function createFOVCircle()
    if not Drawing then return end
    if _G.FOVCircle then _G.FOVCircle:Remove() end
    if _G.FOVCircleInner then _G.FOVCircleInner:Remove() end
    _G.FOVCircle = Drawing.new("Circle")
    _G.FOVCircle.Visible = false
    _G.FOVCircle.Thickness = 2
    _G.FOVCircle.NumSides = 80
    _G.FOVCircle.Radius = _G.FOVCircleSize
    _G.FOVCircle.Filled = false
    _G.FOVCircle.Color = _G.FOVCircleColor
    _G.FOVCircle.Transparency = 0.6
    _G.FOVCircleInner = Drawing.new("Circle")
    _G.FOVCircleInner.Visible = false
    _G.FOVCircleInner.Thickness = 1
    _G.FOVCircleInner.NumSides = 80
    _G.FOVCircleInner.Radius = _G.FOVCircleSize - 3
    _G.FOVCircleInner.Filled = false
    _G.FOVCircleInner.Color = _G.FOVCircleColor
    _G.FOVCircleInner.Transparency = 0.3
end
_G.createFOVCircle = createFOVCircle

local function createTracer()
    if not Drawing then return end
    if TracerLine then TracerLine:Remove() end
    TracerLine = Drawing.new("Line")
    TracerLine.Visible = false
    TracerLine.Thickness = 1
    TracerLine.Color = GunAim.TracerColor
end
_G.createTracer = createTracer

createTracer()
createFOVCircle()

RunService.RenderStepped:Connect(function()
    pcall(function()
        if not _G.FOVCircle then return end
        if _G.FOVCircleVisible then
            _G.FOVCircle.Visible = true
            _G.FOVCircle.Radius = _G.FOVCircleSize
            _G.FOVCircle.Color = _G.FOVCircleColor
            _G.FOVCircle.Position = Vector2.new(
                workspace.CurrentCamera.ViewportSize.X / 2,
                workspace.CurrentCamera.ViewportSize.Y / 2
            )
            if _G.FOVCircleInner then
                _G.FOVCircleInner.Visible = true
                _G.FOVCircleInner.Radius = _G.FOVCircleSize - 3
                _G.FOVCircleInner.Color = _G.FOVCircleColor
                _G.FOVCircleInner.Position = _G.FOVCircle.Position
            end
        else
            _G.FOVCircle.Visible = false
            if _G.FOVCircleInner then _G.FOVCircleInner.Visible = false end
        end
    end)
end)

-- ============ SILENT AIM VEIL SPEAR ============
local function getSilentAimTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, shortest = nil, SilentAimSpear.FOV

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team then
            local valid = false
            if SilentAimSpear.TargetMode == "Killer" and p.Team.Name == "Killer" then valid = true
            elseif SilentAimSpear.TargetMode == "Survivor" and (p.Team.Name == "Survivors" or p.Team.Name == "Survivor") then valid = true
            elseif SilentAimSpear.TargetMode == "Both" then valid = true end

            if valid then
                local hrp = p.Character:FindFirstChild(SilentAimSpear.AimPart)
                    or p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closest = hrp
                        end
                    end
                end
            end
        end
    end
    return closest
end

if Drawing then
    _G.SilentAimCircle = Drawing.new("Circle")
    _G.SilentAimCircle.Visible = false
    _G.SilentAimCircle.Thickness = 2
    _G.SilentAimCircle.NumSides = 60
    _G.SilentAimCircle.Radius = SilentAimSpear.FOV
    _G.SilentAimCircle.Filled = false
    _G.SilentAimCircle.Color = Color3.fromRGB(150, 0, 255)
    _G.SilentAimCircle.Transparency = 0.6
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        if _G.SilentAimCircle then
            _G.SilentAimCircle.Visible = SilentAimSpear.Enabled and SilentAimSpear.ShowFOV
            _G.SilentAimCircle.Radius = SilentAimSpear.FOV
            _G.SilentAimCircle.Position = Vector2.new(
                workspace.CurrentCamera.ViewportSize.X / 2,
                workspace.CurrentCamera.ViewportSize.Y / 2
            )
        end

        if not SilentAimSpear.Enabled then return end
        if not SilentAimSpear.Holding then return end

        local target = getSilentAimTarget()
        if not target then return end

        local cam = workspace.CurrentCamera
        local pos = target.Position

        if SilentAimSpear.Prediction > 0 then
            pos = pos + (target.AssemblyLinearVelocity * SilentAimSpear.Prediction)
        end

        cam.CFrame = CFrame.new(cam.CFrame.Position, pos)
    end)
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if not SilentAimSpear.Enabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and string.find(string.lower(tool.Name), "veil") then
                SilentAimSpear.Holding = true
            else
                SilentAimSpear.Holding = false
            end
        end)
    end
end)

-- ============ HIT MARKER ============
local function createHitMarkerLines()
    if not Drawing then return end
    for _, v in pairs(_G.HitMarkerLines) do pcall(function() v:Remove() end) end
    _G.HitMarkerLines = {}
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = HitMarker.Thickness
        line.Color = HitMarker.Color
        table.insert(_G.HitMarkerLines, line)
    end
end
_G.createHitMarkerLines = createHitMarkerLines

local function triggerHitMarker()
    _G.HitMarkerActive = true
    _G.HitMarkerEnd = tick() + HitMarker.Duration
    if #_G.HitMarkerLines == 0 then createHitMarkerLines() end
end
_G.triggerHitMarker = triggerHitMarker

RunService.RenderStepped:Connect(function()
    pcall(function()
        if not Drawing then return end
        if not HitMarker.Enabled then
            for _, v in pairs(_G.HitMarkerLines) do v.Visible = false end
            return
        end
        if not _G.HitMarkerActive or tick() > _G.HitMarkerEnd then
            _G.HitMarkerActive = false
            for _, v in pairs(_G.HitMarkerLines) do v.Visible = false end
            return
        end
        if #_G.HitMarkerLines == 0 then createHitMarkerLines() end
        local cam = workspace.CurrentCamera
        local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        local s = HitMarker.Size
        for _, v in pairs(_G.HitMarkerLines) do
            v.Thickness = HitMarker.Thickness
            v.Color = HitMarker.Color
            v.Visible = true
        end
        _G.HitMarkerLines[1].From = center + Vector2.new(-s, -s)
        _G.HitMarkerLines[1].To   = center + Vector2.new(-s/2, -s/2)
        _G.HitMarkerLines[2].From = center + Vector2.new(s, -s)
        _G.HitMarkerLines[2].To   = center + Vector2.new(s/2, -s/2)
        _G.HitMarkerLines[3].From = center + Vector2.new(-s, s)
        _G.HitMarkerLines[3].To   = center + Vector2.new(-s/2, s/2)
        _G.HitMarkerLines[4].From = center + Vector2.new(s, s)
        _G.HitMarkerLines[4].To   = center + Vector2.new(s/2, s/2)
    end)
end)

-- ============ AIMBOT SURVIVOR ============
local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist

local function isVisible(part)
    local cam = workspace.CurrentCamera
    RayParams.FilterDescendantsInstances = { LocalPlayer.Character }
    local origin = cam.CFrame.Position
    local direction = (part.Position - origin)
    local result = workspace:Raycast(origin, direction, RayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

local function getClosestGunTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, shortest = nil, GunAim.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team then
            local valid = false
            if GunAim.TargetMode == "Killer" and p.Team.Name == "Killer" then valid = true
            elseif GunAim.TargetMode == "Survivor" and (p.Team.Name == "Survivors" or p.Team.Name == "Survivor") then valid = true
            elseif GunAim.TargetMode == "Both" then valid = true end
            if valid then
                local hrp = p.Character:FindFirstChild(GunAim.AimPart) or p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest then
                            if GunAim.VisibilityCheck and not isVisible(hrp) then
                            else
                                shortest = dist
                                closest = hrp
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        if not GunAim.Enabled then
            if TracerLine then TracerLine.Visible = false end
            return
        end
        if not GunAim.Holding then
            if TracerLine then TracerLine.Visible = false end
            return
        end
        local cam = workspace.CurrentCamera
        local target = getClosestGunTarget()
        if not target then
            if TracerLine then TracerLine.Visible = false end
            return
        end
        local pos = target.Position
        if GunAim.Predict then
            pos = pos + (target.AssemblyLinearVelocity * GunAim.PredictStrength)
        end
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, pos), GunAim.Strength)
        if GunAim.ShowTracer and TracerLine then
            local screenPos, onScreen = cam:WorldToViewportPoint(target.Position)
            if onScreen then
                TracerLine.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                TracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
                TracerLine.Color = GunAim.TracerColor
                TracerLine.Visible = true
            end
        end
    end)
end)

local function getClosestSurvivorForKiller()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, shortest = nil, KillerAim.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local isSurvivor = p.Team and (p.Team.Name == "Survivors" or p.Team.Name == "Survivor")
            if isSurvivor then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest then shortest = dist; closest = hrp end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        if not KillerAim.Enabled then return end
        local mouseHeld = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        if not (KillerAim.Holding or mouseHeld) then return end
        local target = getClosestSurvivorForKiller()
        if not target then return end
        local cam = workspace.CurrentCamera
        local pos = target.Position
        if GunAim.Predict then
            pos = pos + (target.AssemblyLinearVelocity * GunAim.PredictStrength)
        end
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, pos), KillerAim.Strength)
    end)
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = true
        KillerAim.Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = false
        KillerAim.Holding = false
    end
end)

print("[TiarHub v17.5] Part 3/6 loaded. Ketik 'lanjut' buat Part 4.")-- ============================================
-- ⚡ TIARHUB v17.5 + PATCH - Part 4/6
-- Killer + Movement + Visual + Teleport
-- ============================================

if not _G.TiarHubLoaded then
    warn("[TiarHub] Jalankan Part 1 dulu!")
    return
end

local Players = _G.Players
local RunService = _G.RunService
local ReplicatedStorage = _G.ReplicatedStorage
local UserInputService = _G.UserInputService
local Lighting = _G.Lighting
local LocalPlayer = _G.LocalPlayer
local PlayerGui = _G.PlayerGui

local Killer = _G.Killer
local Movement = _G.Movement
local Moonwalk = _G.Moonwalk
local Visual = _G.Visual
local VisualOriginal = _G.VisualOriginal
local AntiLag = _G.AntiLag
local Crosshair = _G.Crosshair
local AutoEscape = _G.AutoEscape
local HideSpark = _G.HideSpark

local getRoot = _G.getRoot
local getHum = _G.getHum
local isDowned = _G.isDowned
local shouldDisableWalkSpeed = _G.shouldDisableWalkSpeed
local GetPos = _G.GetPos
local findRemote = _G.findRemote
local GetNearestKiller = _G.GetNearestKiller

local AttackEvent = _G.AttackEvent
local CarryEvent = _G.CarryEvent
local HookEvent = _G.HookEvent
local EmoteRemote = _G.EmoteRemote

local CachedObjects = _G.CachedObjects
local TriggerHitMarker = _G.triggerHitMarker

-- ============ KILLER HELPERS ============
local function GetDownedSurvivor()
    local root = getRoot()
    if not root then return nil end
    local best, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 and hum.Health <= hum.MaxHealth * 0.25 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < dist then dist = d; best = p.Character end
            end
        end
    end
    return best
end

local function GetNearestAliveSurvivor()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < shortest then shortest = d; closest = p.Character end
            end
        end
    end
    return closest
end
_G.GetNearestAliveSurvivor = GetNearestAliveSurvivor

local function GetHook()
    local root = getRoot()
    if not root then return nil end
    local bestHook, shortest = nil, math.huge
    for hook in pairs(CachedObjects.Hooks) do
        local pos = GetPos(hook)
        if pos then
            local dist = (pos - root.Position).Magnitude
            if dist < shortest and dist < 400 then shortest = dist; bestHook = hook end
        end
    end
    return bestHook
end

local function startAutoStalk()
    if _G.StalkConnection then return end
    _G.StalkConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not Killer.AutoStalk then return end
            local root = getRoot()
            if not root then return end
            local target, dist = nil, math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 30 then
                        local d = (hrp.Position - root.Position).Magnitude
                        if d <= Killer.StalkRange and d < dist then dist = d; target = p end
                    end
                end
            end
            if target then
                local stalkEvent = findRemote("Remotes.Killers.Stalker.StartStalking")
                if stalkEvent then pcall(function() stalkEvent:FireServer(target) end) end
            end
        end)
    end)
end

local function stopAutoStalk()
    if _G.StalkConnection then _G.StalkConnection:Disconnect(); _G.StalkConnection = nil end
end
_G.startAutoStalk = startAutoStalk
_G.stopAutoStalk = stopAutoStalk

-- ============ KILLER MAIN LOOP ============
RunService.Heartbeat:Connect(function()
    pcall(function()
        if not getRoot() then return end

        if Killer.AutoAttack and AttackEvent then
            pcall(function() AttackEvent:FireServer(false) end)
            if _G.HitMarker.Enabled and math.random(1,3) == 1 and TriggerHitMarker then triggerHitMarker() end
        end

        if Killer.AutoHookAllDowned and HookEvent and not _G.KillerBusy then
            local root = getRoot()
            if root then
                local bestHook, bestDist = nil, Killer.AutoHookAllRange
                for hook in pairs(CachedObjects.Hooks) do
                    local pos = GetPos(hook)
                    if pos then
                        local d = (pos - root.Position).Magnitude
                        if d < bestDist then bestDist = d; bestHook = hook end
                    end
                end
                if bestHook then
                    local hp = GetPos(bestHook)
                    if hp then
                        root.CFrame = CFrame.new(hp) * CFrame.new(0, 4, -3)
                        task.wait(0.3)
                        for i = 1, 3 do HookEvent:FireServer(bestHook); task.wait(0.1) end
                    end
                end
            end
        end

        if Killer.AutoCarry and not _G.KillerBusy and CarryEvent then
            _G.KillerBusy = true
            task.spawn(function()
                local target = GetDownedSurvivor()
                local root = getRoot()
                if target and root then
                    local tRoot = target:FindFirstChild("HumanoidRootPart")
                    if tRoot then
                        root.CFrame = tRoot.CFrame * CFrame.new(0, 3, -2)
                        task.wait(0.4)
                        for i = 1, 4 do CarryEvent:FireServer(target); task.wait(0.2) end
                        task.wait(0.6)
                        if Killer.AutoHook and HookEvent then
                            local hook = GetHook()
                            if hook then
                                local hp = GetPos(hook)
                                if hp then
                                    root.CFrame = CFrame.new(hp) * CFrame.new(0, 4, -3)
                                    task.wait(0.7)
                                    for i = 1, 6 do HookEvent:FireServer(hook); task.wait(0.15) end
                                end
                            end
                        end
                    end
                end
                task.wait(1.5)
                _G.KillerBusy = false
            end)
        end

        if Killer.KillAll and AttackEvent then
            local root = getRoot()
            if root then
                if not _G.KillerTarget or not _G.KillerTarget:FindFirstChild("Humanoid") or _G.KillerTarget.Humanoid.Health <= 35 then
                    _G.KillerTarget = GetNearestAliveSurvivor()
                end
                if _G.KillerTarget then
                    local targetHRP = _G.KillerTarget:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        local velocity = targetHRP.AssemblyLinearVelocity
                        local predict = velocity * 0.15
                        local targetPos = targetHRP.Position + predict
                        local behind = targetHRP.CFrame.LookVector * -3
                        root.CFrame = CFrame.new(targetPos + behind, targetPos)
                    end
                    pcall(function() AttackEvent:FireServer(false) end)
                end
            end
        end

        if Killer.AutoSprint then
            local hum = getHum()
            if hum and hum.WalkSpeed < Killer.AutoSprintValue then
                local target = GetNearestAliveSurvivor()
                if target then
                    local hrp = target:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local myRoot = getRoot()
                        if myRoot then
                            local d = (hrp.Position - myRoot.Position).Magnitude
                            if d < 100 then hum.WalkSpeed = Killer.AutoSprintValue end
                        end
                    end
                end
            end
        end

        if Killer.AutoFaceTarget then
            local root = getRoot()
            if root then
                local target = GetNearestAliveSurvivor()
                if target then
                    local hrp = target:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local d = (hrp.Position - root.Position).Magnitude
                        if d <= Killer.AutoFaceRange then
                            local myHum = getHum()
                            if myHum then
                                myHum.AutoRotate = false
                                local look = CFrame.new(root.Position, hrp.Position).LookVector
                                root.CFrame = CFrame.new(root.Position, root.Position + Vector3.new(look.X, 0, look.Z))
                            end
                        end
                    end
                end
            end
        end

        if Killer.PredictionAttack and AttackEvent then
            local root = getRoot()
            if root then
                local target = GetNearestAliveSurvivor()
                if target then
                    local hrp = target:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local d = (hrp.Position - root.Position).Magnitude
                        if d < 15 then
                            local vel = hrp.AssemblyLinearVelocity
                            local predPos = hrp.Position + (vel * Killer.PredictStrength)
                            local myHum = getHum()
                            if myHum then myHum.AutoRotate = false end
                            root.CFrame = CFrame.new(root.Position, predPos)
                            pcall(function() AttackEvent:FireServer(false) end)
                            if _G.HitMarker.Enabled and TriggerHitMarker then triggerHitMarker() end
                        end
                    end
                end
            end
        end

        if _G.ChaseDetector.Enabled then
            local now = tick()
            if now - _G.ChaseDetector.LastNotify > _G.ChaseDetector.Cooldown then
                local root = getRoot()
                if root then
                    local closest, dist = nil, math.huge
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            local isSurv = p.Team and (p.Team.Name == "Survivors" or p.Team.Name == "Survivor")
                            if isSurv then
                                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    local d = (hrp.Position - root.Position).Magnitude
                                    if d < dist then dist = d; closest = p end
                                end
                            end
                        end
                    end
                    if closest and dist <= _G.ChaseDetector.Range then
                        _G.ChaseDetector.LastNotify = now
                        _G.Rayfield:Notify({ title = "Chase Alert", content = string.format("Survivor dalam %.0f stud!", dist), duration = 2 })
                    end
                end
            end
        end
    end)
end)

-- ============ FAST VAULT ============
local function normalizeId(id)
    local num = tostring(id):match("%d+")
    return num and ("rbxassetid://" .. num)
end

local function hookVault(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        pcall(function()
            if not _G.FastVault.Enabled then return end
            local anim = track.Animation
            if not anim or not anim.AnimationId then return end
            local id = normalizeId(anim.AnimationId)
            if not id then return end
            local replaceId = _G.FastVault.ReplaceMap[id]
            if not replaceId then return end
            if _G.VaultTracks[track] then return end
            _G.VaultTracks[track] = true
            track:Stop()
            local newAnim = Instance.new("Animation")
            newAnim.AnimationId = replaceId
            local newTrack = animator:LoadAnimation(newAnim)
            newTrack.Priority = Enum.AnimationPriority.Action
            newTrack:Play()
            newTrack:AdjustSpeed(_G.FastVault.Speed)
            newTrack.Stopped:Connect(function() _G.VaultTracks[track] = nil end)
        end)
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5); pcall(function() hookVault(char) end)
end)
if LocalPlayer.Character then pcall(function() hookVault(LocalPlayer.Character) end) end

-- ============ WALKSPEED & NOCLIP ============
local WalkSpeedConnection = nil
local function applyWalkSpeed()
    if WalkSpeedConnection then WalkSpeedConnection:Disconnect() end
    WalkSpeedConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not Movement.WalkSpeedEnabled then return end
            local hum = getHum()
            if not hum then return end
            if shouldDisableWalkSpeed() then return end
            if hum.WalkSpeed ~= Movement.WalkSpeedValue then hum.WalkSpeed = Movement.WalkSpeedValue end
        end)
    end)
end
_G.applyWalkSpeed = applyWalkSpeed

local NoClipConnection = nil
local function toggleNoClip(state)
    Movement.NoClip = state
    if state then
        if NoClipConnection then NoClipConnection:Disconnect() end
        NoClipConnection = RunService.RenderStepped:Connect(function()
            pcall(function()
                if not Movement.NoClip then return end
                local char = LocalPlayer.Character
                if not char then return end
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end)
        end)
    else
        if NoClipConnection then NoClipConnection:Disconnect(); NoClipConnection = nil end
        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end
end
_G.toggleNoClip = toggleNoClip

-- ============ MOONWALK ============
local function applyMoonwalkFOV()
    local cam = workspace.CurrentCamera
    if not cam then return end
    if Moonwalk.Enabled then
        cam.FieldOfView = Moonwalk.FOVPreset
    end
end
_G.applyMoonwalkFOV = applyMoonwalkFOV

local function startMoonwalk()
    if _G.MoonwalkConnection then return end
    local hum0 = getHum()
    if hum0 then hum0.AutoRotate = false end

    _G.MoonwalkConnection = RunService.RenderStepped:Connect(function()
        if not Moonwalk.Enabled or _G.ParryActive or isDowned() then return end
        local char = LocalPlayer.Character
        if not char or not char.Parent then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not (humanoid and hrp and cam) then return end

        humanoid.AutoRotate = false
        if Moonwalk.UseSlow and humanoid.WalkSpeed ~= Moonwalk.SlowSpeed then
            humanoid.WalkSpeed = Moonwalk.SlowSpeed
        end

        if Moonwalk.Mode == "Camera" then
            local camLook = cam.CFrame.LookVector
            local flatCam = Vector3.new(camLook.X, 0, camLook.Z)
            if flatCam.Magnitude > 0 then
                flatCam = flatCam.Unit
                local baseCF = CFrame.new(hrp.Position, hrp.Position + flatCam)
                local angle = math.sin(tick() * Moonwalk.SpamSpeed) * Moonwalk.Intensity
                hrp.CFrame = baseCF * CFrame.Angles(0, math.rad(angle), 0)
                humanoid:Move(Vector3.new(0, 0, 1), true)
            end
        else
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
    end)

    if _G.MoonwalkHeartbeat then _G.MoonwalkHeartbeat:Disconnect() end
    _G.MoonwalkHeartbeat = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not Moonwalk.Enabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.AutoRotate = false end
        end)
    end)
end
_G.startMoonwalk = startMoonwalk

local function stopMoonwalk()
    if _G.MoonwalkConnection then _G.MoonwalkConnection:Disconnect(); _G.MoonwalkConnection = nil end
    if _G.MoonwalkHeartbeat then _G.MoonwalkHeartbeat:Disconnect(); _G.MoonwalkHeartbeat = nil end
    local hum = getHum()
    if hum then
        hum.AutoRotate = true
        if Movement.WalkSpeedEnabled then hum.WalkSpeed = Movement.WalkSpeedValue
        else hum.WalkSpeed = Movement.OriginalWalkSpeed end
    end
    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = 70 end
end
_G.stopMoonwalk = stopMoonwalk

-- ============ CROSSHAIR ============
local function updateCrosshair()
    pcall(function()
        if not Crosshair.Enabled then
            if _G.CrosshairGui then _G.CrosshairGui.Enabled = false end
            return
        end
        if not _G.CrosshairGui then
            _G.CrosshairGui = Instance.new("ScreenGui")
            _G.CrosshairGui.Name = "TiarCrosshair"
            _G.CrosshairGui.ResetOnSpawn = false
            _G.CrosshairGui.IgnoreGuiInset = true
            _G.CrosshairGui.Parent = PlayerGui
            local h = Instance.new("Frame"); h.Name = "H"
            h.AnchorPoint = Vector2.new(0.5, 0.5); h.BorderSizePixel = 0; h.Parent = _G.CrosshairGui
            local v = Instance.new("Frame"); v.Name = "V"
            v.AnchorPoint = Vector2.new(0.5, 0.5); v.BorderSizePixel = 0; v.Parent = _G.CrosshairGui
        end
        _G.CrosshairGui.Enabled = true
        local h = _G.CrosshairGui:FindFirstChild("H")
        local v = _G.CrosshairGui:FindFirstChild("V")
        if h then
            h.Size = UDim2.new(0, Crosshair.Size * 2, 0, Crosshair.Thickness)
            h.Position = UDim2.new(0.5, Crosshair.OffsetX, 0.5, Crosshair.OffsetY)
            h.BackgroundColor3 = Crosshair.Color
        end
        if v then
            v.Size = UDim2.new(0, Crosshair.Thickness, 0, Crosshair.Size * 2)
            v.Position = UDim2.new(0.5, Crosshair.OffsetX, 0.5, Crosshair.OffsetY)
            v.BackgroundColor3 = Crosshair.Color
        end
    end)
end
RunService.RenderStepped:Connect(function() updateCrosshair() end)
RunService.Heartbeat:Connect(function() pcall(function() if _G.AutoWiggle then _G.AutoWiggle() end end) end)

-- ============ EMOTE + MASKED ============
local function playEmote(name)
    if EmoteRemote then pcall(function() EmoteRemote:FireServer(name) end) end
end
_G.playEmote = playEmote

local function activateMasked()
    local event = findRemote("Remotes.Killers.Masked.Activatepower")
    if event then pcall(function() event:FireServer(_G.Masked.CurrentPower) end) end
end
_G.activateMasked = activateMasked

local function deactivateMasked()
    local event = findRemote("Remotes.Killers.Masked.Deactivatepower")
    if event then pcall(function() event:FireServer() end) end
end
_G.deactivateMasked = deactivateMasked

-- ============ VISUAL SYSTEM ============
local LastVisualState = { Fullbright = nil, NoFog = nil, NoShadow = nil }

local function applyVisual(force)
    pcall(function()
        if force or LastVisualState.Fullbright ~= Visual.Fullbright then
            LastVisualState.Fullbright = Visual.Fullbright
            if Visual.Fullbright then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.Ambient = Color3.new(1, 1, 1)
                Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            else
                Lighting.Brightness = VisualOriginal.Brightness
                Lighting.ClockTime = VisualOriginal.ClockTime
                Lighting.Ambient = VisualOriginal.Ambient
                Lighting.OutdoorAmbient = VisualOriginal.OutdoorAmbient
            end
        end
        if force or LastVisualState.NoFog ~= Visual.NoFog then
            LastVisualState.NoFog = Visual.NoFog
            if Visual.NoFog then
                Lighting.FogEnd = 100000; Lighting.FogStart = 100000
            else
                Lighting.FogEnd = VisualOriginal.FogEnd
                Lighting.FogStart = VisualOriginal.FogStart
                Lighting.FogColor = VisualOriginal.FogColor
            end
        end
        if force or LastVisualState.NoShadow ~= Visual.NoShadow then
            LastVisualState.NoShadow = Visual.NoShadow
            Lighting.GlobalShadows = not Visual.NoShadow
        end

        if Visual.AmbientColorEnabled then
            Lighting.Ambient = Visual.AmbientColor
            Lighting.OutdoorAmbient = Visual.AmbientColor
        end
        if Visual.ClockTimeEnabled then
            Lighting.ClockTime = Visual.ClockTime
        end
        if Visual.FogControlEnabled then
            Lighting.FogEnd = Visual.FogEnd
            Lighting.FogStart = Visual.FogStart
            Lighting.FogColor = Visual.FogColor
        end
    end)
end
_G.applyVisual = applyVisual

local function toggleScreenEffects()
    pcall(function()
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") then v.Enabled = not Visual.NoBloom end
            if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") then v.Enabled = not Visual.NoBlur end
        end
    end)
end
_G.toggleScreenEffects = toggleScreenEffects

local ColorCorrection = nil
local function getOrCreateCC()
    if ColorCorrection and ColorCorrection.Parent then return ColorCorrection end
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("ColorCorrectionEffect") and v.Name == "TiarColorCorrection" then
            ColorCorrection = v
            return v
        end
    end
    ColorCorrection = Instance.new("ColorCorrectionEffect")
    ColorCorrection.Name = "TiarColorCorrection"
    ColorCorrection.Parent = Lighting
    ColorCorrection.Enabled = true
    return ColorCorrection
end

local function applyColorCorrection()
    local cc = getOrCreateCC()
    if not cc then return end
    cc.Saturation = Visual.Saturation or 0
    cc.Brightness = Visual.Brightness or 0
    cc.Contrast = Visual.Contrast or 0
    local shouldEnable = Visual.ColorCorrection
        or (Visual.Saturation and Visual.Saturation ~= 0)
        or (Visual.Brightness and Visual.Brightness ~= 0)
        or (Visual.Contrast and Visual.Contrast ~= 0)
    cc.Enabled = shouldEnable and true or false
end
_G.applyColorCorrection = applyColorCorrection

local function resetColorCorrection()
    Visual.Saturation = 0
    Visual.Brightness = 0
    Visual.Contrast = 0
    local cc = getOrCreateCC()
    if cc then
        cc.Saturation = 0
        cc.Brightness = 0
        cc.Contrast = 0
    end
end
_G.resetColorCorrection = resetColorCorrection

local function removeBlood()
    pcall(function()
        if Visual.NoBlood then
            for _, v in pairs(workspace:GetDescendants()) do
                local name = string.lower(v.Name)
                if (v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Trail")) 
                   and (name:find("blood") or name:find("gore") or name:find("splat")) then
                    pcall(function() 
                        if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1
                        else v.Enabled = false end
                    end)
                end
            end
        end
    end)
end
_G.removeBlood = removeBlood

local function applyAntiLag()
    pcall(function()
        if AntiLag.PhysicsThrottle then
            settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.AlwaysThrottle
        else
            settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Default
        end
    end)
    pcall(function()
        if AntiLag.NoGlobalShadows then Lighting.GlobalShadows = false
        else Lighting.GlobalShadows = VisualOriginal.GlobalShadows end
    end)
    pcall(function()
        if AntiLag.NetworkLag then settings().Network.IncomingReplicationLag = -1000
        else settings().Network.IncomingReplicationLag = 0 end
    end)
end
_G.applyAntiLag = applyAntiLag

RunService.Heartbeat:Connect(function()
    pcall(function() 
        applyVisual()
        toggleScreenEffects()
        applyColorCorrection()
        removeBlood()
        if Moonwalk.Enabled then applyMoonwalkFOV() end
    end)
end)

-- ============ HIDE SPARK ============
local HiddenSparkCache = _G.HiddenSparkCache
local function isRedSpark(obj)
    if not obj then return false end
    if not (obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles")) then
        return false
    end
    local name = string.lower(obj.Name)
    if name:find("parry") or name:find("spark") or name:find("blood")
       or name:find("slash") or name:find("hit") or name:find("impact") then
        return true
    end
    if obj:IsA("ParticleEmitter") then
        local ok, c = pcall(function() return obj.Color end)
        if ok and c and c.R > 0.5 and c.G < 0.4 and c.B < 0.4 then return true end
    end
    return false
end

local HideSparkConn = nil
local function startHideSpark()
    if HideSparkConn then return end
    for _, v in ipairs(workspace:GetDescendants()) do
        if isRedSpark(v) then
            HiddenSparkCache[v] = true
            pcall(function() v.Enabled = false; if v.Transparency then v.Transparency = 1 end end)
        end
    end
    HideSparkConn = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not HideSpark.Enabled then return end
            for _, v in ipairs(workspace:GetDescendants()) do
                if not HiddenSparkCache[v] and isRedSpark(v) then
                    HiddenSparkCache[v] = true
                    pcall(function() v.Enabled = false; if v.Transparency then v.Transparency = 1 end end)
                end
            end
        end)
    end)
end

local function stopHideSpark()
    if HideSparkConn then HideSparkConn:Disconnect(); HideSparkConn = nil end
    _G.HiddenSparkCache = {}
end
_G.startHideSpark = startHideSpark
_G.stopHideSpark = stopHideSpark

-- ============ TELEPORT SYSTEM ============
local function findNearestByNames(names, maxDist)
    local root = getRoot()
    if not root then return nil, math.huge end
    local best, bestDist = nil, maxDist or math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            for _, target in ipairs(names) do
                if obj.Name == target or string.find(obj.Name, target, 1, true) then
                    local pos = GetPos(obj)
                    if pos then
                        local d = (pos - root.Position).Magnitude
                        if d < bestDist then bestDist = d; best = obj end
                    end
                    break
                end
            end
        end
    end
    return best, bestDist
end

local function teleportTo(obj)
    if not obj then return false end
    local now = tick()
    if now - _G.Teleport.LastTeleport < _G.Teleport.Cooldown then return false end
    _G.Teleport.LastTeleport = now
    local root = getRoot()
    if not root then return false end
    local pos = GetPos(obj)
    if not pos then return false end
    pcall(function() root.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0)) end)
    return true
end
_G.teleportTo = teleportTo

_G.teleportToGenerator = function() return teleportTo(findNearestByNames({"Generator", "GeneratorPoint"})) end
_G.teleportToGate = function() return teleportTo(findNearestByNames({"Gate", "Exit", "ExitGate", "fininshline", "FinishLine"})) end
_G.teleportToWindow = function() return teleportTo(findNearestByNames({"Window"})) end
_G.teleportToPallet = function() return teleportTo(findNearestByNames({"Pallet", "Palletwrong"})) end
_G.teleportToHook = function() return teleportTo(findNearestByNames({"HookPoint", "Hook"})) end

task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if not AutoEscape.Enabled then return end
            local root = getRoot()
            if not root then return end
            local killerRoot, dist = GetNearestKiller()
            if not killerRoot or dist > AutoEscape.DetectDistance then return end
            if tick() - AutoEscape.LastEscape < AutoEscape.Cooldown then return end
            local target = findNearestByNames({"Gate", "Exit", "ExitGate", "fininshline", "FinishLine"}, 1000)
            if not target then target = findNearestByNames({"Window"}, 500) end
            if not target then target = findNearestByNames({"Pallet", "Palletwrong"}, 500) end
            if not target then target = findNearestByNames({"Generator"}, 500) end
            if target then
                AutoEscape.LastEscape = tick()
                teleportTo(target)
            end
        end)
    end
end)

print("[TiarHub v17.5] Part 4/6 loaded. Ketik 'lanjut' buat Part 5.")-- ============================================
-- ⚡ TIARHUB v17.5 + PATCH - Part 5/6
-- UI Menu Lengkap
-- ============================================

if not _G.TiarHubLoaded then
    warn("[TiarHub] Jalankan Part 1 dulu!")
    return
end

local Rayfield = _G.Rayfield
local Window = _G.TiarHubWindow
local PlayerGui = _G.PlayerGui
local Players = _G.Players
local LocalPlayer = _G.LocalPlayer
local RunService = _G.RunService

-- Shortcut ke config global
local ESP = _G.ESP
local ESPStatus = _G.ESPStatus
local KillerWarning = _G.KillerWarning
local Auto = _G.Auto
local ParryRangeVisual = _G.ParryRangeVisual
local AutoFlee = _G.AutoFlee
local AutoDodgeAbyss = _G.AutoDodgeAbyss
local FakePerks = _G.FakePerks
local FastVault = _G.FastVault
local SilentAimSpear = _G.SilentAimSpear
local GunAim = _G.GunAim
local KillerAim = _G.KillerAim
local HitMarker = _G.HitMarker
local Killer = _G.Killer
local ChaseDetector = _G.ChaseDetector
local Movement = _G.Movement
local Moonwalk = _G.Moonwalk
local Visual = _G.Visual
local AntiLag = _G.AntiLag
local Crosshair = _G.Crosshair
local AutoEscape = _G.AutoEscape
local HideSpark = _G.HideSpark
local Masked = _G.Masked
local MaskedPowers = _G.MaskedPowers
local Emote = _G.Emote
local EmoteList = _G.EmoteList
local SoundFeedback = _G.SoundFeedback
local Aimlock = _G.Aimlock

-- ============ ESP TAB ============
local ESPTab = Window:CreateTab({ name = "ESP", icon = 0 })
ESPTab:CreateSection("Player ESP")
ESPTab:CreateToggle({ name = "ESP Survivor", currentValue = false, flag = "esp_survivor", callback = function(v) ESP.Survivor = v end })
ESPTab:CreateColorPicker({ name = "Survivor Color", color = ESP.SurvivorColor, flag = "esp_survivor_color", callback = function(c) ESP.SurvivorColor = c end })
ESPTab:CreateToggle({ name = "ESP Killer", currentValue = false, flag = "esp_killer", callback = function(v) ESP.Killer = v end })
ESPTab:CreateColorPicker({ name = "Killer Color", color = ESP.KillerColor, flag = "esp_killer_color", callback = function(c) ESP.KillerColor = c end })
ESPTab:CreateSection("Map ESP")
ESPTab:CreateToggle({ name = "ESP Generator (%)", currentValue = false, flag = "esp_generator", callback = function(v) ESP.Generator = v end })
ESPTab:CreateColorPicker({ name = "Generator Color", color = ESP.GeneratorColor, flag = "esp_gen_color", callback = function(c) ESP.GeneratorColor = c end })
ESPTab:CreateToggle({ name = "ESP Hook", currentValue = false, flag = "esp_hook", callback = function(v) ESP.Hook = v end })
ESPTab:CreateColorPicker({ name = "Hook Color", color = ESP.HookColor, flag = "esp_hook_color", callback = function(c) ESP.HookColor = c end })
ESPTab:CreateToggle({ name = "ESP Pallet", currentValue = false, flag = "esp_pallet", callback = function(v) ESP.Pallet = v end })
ESPTab:CreateColorPicker({ name = "Pallet Color", color = ESP.PalletColor, flag = "esp_pallet_color", callback = function(c) ESP.PalletColor = c end })
ESPTab:CreateToggle({ name = "ESP Window", currentValue = false, flag = "esp_window", callback = function(v) ESP.Window = v end })
ESPTab:CreateColorPicker({ name = "Window Color", color = ESP.WindowColor, flag = "esp_window_color", callback = function(c) ESP.WindowColor = c end })
ESPTab:CreateToggle({ name = "ESP SCP", currentValue = false, flag = "esp_scp", callback = function(v) ESP.SCP = v end })
ESPTab:CreateColorPicker({ name = "SCP Color", color = ESP.SCPColor, flag = "esp_scp_color", callback = function(c) ESP.SCPColor = c end })
ESPTab:CreateSection("Style")
ESPTab:CreateSlider({ name = "ESP Radius", range = {50, 2000}, increment = 50, suffix = "stud", currentValue = 300, flag = "esp_radius", callback = function(v) ESP.Distance = v end })
ESPTab:CreateDropdown({ name = "ESP Mode", options = {"Highlight", "Outline", "Fill"}, currentOption = "Highlight", flag = "esp_mode", callback = function(opt) ESP.Mode = opt end })
ESPTab:CreateToggle({ name = "Show Name Tag", currentValue = true, flag = "esp_name", callback = function(v) ESP.ShowName = v end })
ESPTab:CreateSlider({ name = "Name Size", range = {8, 30}, increment = 1, suffix = "px", currentValue = 14, flag = "esp_namesize", callback = function(v) ESP.NameSize = v end })
ESPTab:CreateSection("ESP Status")
ESPTab:CreateToggle({ name = "Enable Status ESP", currentValue = false, flag = "espstatus_on", callback = function(v) ESPStatus.Enabled = v end })
ESPTab:CreateToggle({ name = "Show Name", currentValue = true, flag = "espstatus_name", callback = function(v) ESPStatus.ShowName = v end })
ESPTab:CreateToggle({ name = "Show Distance", currentValue = true, flag = "espstatus_dist", callback = function(v) ESPStatus.ShowDistance = v end })
ESPTab:CreateToggle({ name = "Show Health", currentValue = false, flag = "espstatus_hp", callback = function(v) ESPStatus.ShowHealth = v end })
ESPTab:CreateSection("Killer Warning")
ESPTab:CreateToggle({ name = "Killer Warning", currentValue = false, flag = "kwarn_on", callback = function(v) KillerWarning.Enabled = v end })
ESPTab:CreateColorPicker({ name = "Warning Color", color = KillerWarning.Color, flag = "kwarn_color", callback = function(c) KillerWarning.Color = c end })
ESPTab:CreateSlider({ name = "Warning Distance", range = {20, 200}, increment = 5, suffix = "stud", currentValue = 60, flag = "kwarn_dist", callback = function(v) KillerWarning.Distance = v end })

-- ============ SURVIVOR TAB ============
local SurvivorTab = Window:CreateTab({ name = "Survivor", icon = 0 })
SurvivorTab:CreateSection("Auto Parry")
SurvivorTab:CreateToggle({ name = "Auto Parry", currentValue = false, flag = "parry_on", callback = function(v) Auto.Parry = v end })
SurvivorTab:CreateDropdown({ name = "Parry Mode", options = {"Safety", "Aggressive"}, currentOption = "Safety", flag = "parry_mode", callback = function(opt) Auto.ParryMode = opt; _G.applyParryPreset(opt); Rayfield:Notify({ title = "Parry Mode", content = "Mode: " .. opt }) end })
SurvivorTab:CreateToggle({ name = "Show Parry Range", currentValue = false, flag = "parry_range", callback = function(v) ParryRangeVisual.Enabled = v end })
SurvivorTab:CreateToggle({ name = "Parry Rainbow Mode", currentValue = false, flag = "parry_rainbow", callback = function(v) ParryRangeVisual.RainbowMode = v end })
SurvivorTab:CreateToggle({ name = "Parry Pulse Effect", currentValue = true, flag = "parry_pulse", callback = function(v) ParryRangeVisual.PulseEnabled = v end })
SurvivorTab:CreateColorPicker({ name = "Parry Range Color", color = ParryRangeVisual.Color, flag = "parry_color", callback = function(c) ParryRangeVisual.Color = c end })
SurvivorTab:CreateSlider({ name = "Parry Circle Size", range = {5, 50}, increment = 1, suffix = "stud", currentValue = 12, flag = "parry_size", callback = function(v) Auto.ParryDistance = v end })
SurvivorTab:CreateSlider({ name = "Parry Range Transparency", range = {0, 1}, increment = 0.05, currentValue = 0.7, flag = "parry_trans", callback = function(v) ParryRangeVisual.Transparency = v end })

SurvivorTab:CreateSection("Auto Skill Check")
SurvivorTab:CreateToggle({ name = "Auto Skill Check", currentValue = false, flag = "skillcheck", callback = function(v) Auto.SkillCheck = v; if v and _G.startSkillCheck then _G.startSkillCheck() end end })
SurvivorTab:CreateDropdown({ name = "Skill Check Mode", options = {"Instant", "Perfect"}, currentOption = "Perfect", flag = "skill_mode", callback = function(opt) _G.SkillCheckMode = opt; Rayfield:Notify({ title = "Skill Check", content = "Mode: " .. opt }) end })

SurvivorTab:CreateSection("Auto Wiggle / Flee")
SurvivorTab:CreateToggle({ name = "Auto Wiggle", currentValue = false, flag = "wiggle", callback = function(v) Auto.Wiggle = v end })
SurvivorTab:CreateSlider({ name = "Wiggle Spam", range = {1, 10}, increment = 1, suffix = "x", currentValue = 5, flag = "wiggle_spam", callback = function(v) Auto.WiggleSpam = v end })
SurvivorTab:CreateToggle({ name = "Auto Flee Killer", currentValue = false, flag = "flee", callback = function(v) AutoFlee.Enabled = v end })
SurvivorTab:CreateSlider({ name = "Flee Detect Distance", range = {10, 200}, increment = 5, suffix = "stud", currentValue = 50, flag = "flee_dist", callback = function(v) AutoFlee.DetectDistance = v end })

SurvivorTab:CreateSection("Fast Vault")
SurvivorTab:CreateToggle({ name = "Fast Vault", currentValue = false, flag = "vault", callback = function(v) FastVault.Enabled = v end })
SurvivorTab:CreateSlider({ name = "Animation Speed", range = {1, 5}, increment = 0.1, suffix = "x", currentValue = 1.2, flag = "vault_speed", callback = function(v) FastVault.Speed = v end })

SurvivorTab:CreateSection("Auto Dodge Abyss")
SurvivorTab:CreateToggle({ name = "Auto Dodge Abyss (Crouch)", currentValue = false, flag = "auto_dodge_abyss", callback = function(v) AutoDodgeAbyss.Enabled = v end })
SurvivorTab:CreateSlider({ name = "Detect Range", range = {5, 50}, increment = 1, suffix = "stud", currentValue = 18, flag = "ad_abyss_range", callback = function(v) AutoDodgeAbyss.DetectRange = v end })
SurvivorTab:CreateSlider({ name = "Cooldown", range = {0.1, 3}, increment = 0.1, suffix = "s", currentValue = 0.5, flag = "ad_abyss_cd", callback = function(v) AutoDodgeAbyss.Cooldown = v end })
SurvivorTab:CreateSlider({ name = "Crouch Duration", range = {0.1, 2}, increment = 0.1, suffix = "s", currentValue = 0.3, flag = "ad_abyss_dur", callback = function(v) AutoDodgeAbyss.CrouchDuration = v end })

SurvivorTab:CreateSection("🎭 Fake Perks")
SurvivorTab:CreateToggle({ name = "Fake Flowstate (Speed Boost on Vault)", currentValue = false, flag = "fp_flow", callback = function(v) FakePerks.Flowstate.Enabled = v end })
SurvivorTab:CreateSlider({ name = "Flowstate Speed Boost (%)", range = {10, 50}, increment = 5, suffix = "%", currentValue = 20, flag = "fp_flow_speed", callback = function(v) FakePerks.Flowstate.SpeedBoost = v end })
SurvivorTab:CreateSlider({ name = "Flowstate Duration", range = {1, 10}, increment = 0.5, suffix = "s", currentValue = 3, flag = "fp_flow_dur", callback = function(v) FakePerks.Flowstate.Duration = v end })
SurvivorTab:CreateToggle({ name = "Fake Snake Step (Crouch Speed)", currentValue = false, flag = "fp_snake", callback = function(v) FakePerks.SnakeStep.Enabled = v end })
SurvivorTab:CreateSlider({ name = "Snake Step Speed", range = {16, 100}, increment = 1, currentValue = 90, flag = "fp_snake_speed", callback = function(v) FakePerks.SnakeStep.SpeedBoost = v end })
SurvivorTab:CreateToggle({ name = "Fake Quick Recovery", currentValue = false, flag = "fp_recovery", callback = function(v) FakePerks.QuickRecovery.Enabled = v end })

-- ============ AIMBOT TAB ============
local AimTab = Window:CreateTab({ name = "Aimbot", icon = 0 })
AimTab:CreateSection("Aimbot Survivor")
AimTab:CreateToggle({ name = "Aimbot (Hold RMB)", currentValue = false, flag = "aim_on", callback = function(v) GunAim.Enabled = v end })
AimTab:CreateToggle({ name = "Show FOV Circle", currentValue = false, flag = "aim_fovcircle", callback = function(v) _G.FOVCircleVisible = v; if v and not _G.FOVCircle and _G.createFOVCircle then _G.createFOVCircle() end end })
AimTab:CreateSlider({ name = "FOV Circle Size", range = {50, 1000}, increment = 10, suffix = "px", currentValue = 250, flag = "aim_fovsize", callback = function(v) _G.FOVCircleSize = v end })
AimTab:CreateColorPicker({ name = "FOV Circle Color", color = _G.FOVCircleColor, flag = "aim_fovcolor", callback = function(c) _G.FOVCircleColor = c end })
AimTab:CreateDropdown({ name = "Aimbot Target", options = {"Killer", "Survivor", "Both"}, currentOption = "Killer", flag = "aim_target", callback = function(opt) GunAim.TargetMode = opt end })
AimTab:CreateDropdown({ name = "Aim Part", options = {"Head", "HumanoidRootPart", "Torso"}, currentOption = "HumanoidRootPart", flag = "aim_part", callback = function(opt) GunAim.AimPart = opt end })
AimTab:CreateSlider({ name = "Aimbot FOV", range = {50, 1000}, increment = 10, currentValue = 250, flag = "aim_fov", callback = function(v) GunAim.FOV = v end })
AimTab:CreateSlider({ name = "Aimbot Smoothness", range = {0.1, 1}, increment = 0.05, currentValue = 1, flag = "aim_smooth", callback = function(v) GunAim.Strength = v end })
AimTab:CreateSlider({ name = "Aimbot Prediction", range = {0, 1}, increment = 0.01, currentValue = 0.12, flag = "aim_predict", callback = function(v) GunAim.PredictStrength = v end })

AimTab:CreateSection("🗡️ Silent Aim Veil Spear")
AimTab:CreateToggle({ name = "Enable Silent Aim Spear", currentValue = false, flag = "silent_spear", callback = function(v) SilentAimSpear.Enabled = v end })
AimTab:CreateToggle({ name = "Show Silent Aim FOV", currentValue = false, flag = "silent_fov", callback = function(v) SilentAimSpear.ShowFOV = v end })
AimTab:CreateDropdown({ name = "Silent Aim Target", options = {"Killer", "Survivor", "Both"}, currentOption = "Killer", flag = "silent_target", callback = function(opt) SilentAimSpear.TargetMode = opt end })
AimTab:CreateDropdown({ name = "Silent Aim Part", options = {"Head", "HumanoidRootPart", "Torso"}, currentOption = "HumanoidRootPart", flag = "silent_part", callback = function(opt) SilentAimSpear.AimPart = opt end })
AimTab:CreateSlider({ name = "Silent Aim FOV", range = {50, 1000}, increment = 10, currentValue = 250, flag = "silent_fov_val", callback = function(v) SilentAimSpear.FOV = v end })
AimTab:CreateSlider({ name = "Silent Aim Prediction", range = {0, 1}, increment = 0.01, currentValue = 0.12, flag = "silent_pred", callback = function(v) SilentAimSpear.Prediction = v end })

AimTab:CreateSection("Hit Marker")
AimTab:CreateToggle({ name = "Enable Hit Marker", currentValue = false, flag = "hm_on", callback = function(v) HitMarker.Enabled = v; if v and #_G.HitMarkerLines == 0 and _G.createHitMarkerLines then _G.createHitMarkerLines() end end })
AimTab:CreateColorPicker({ name = "Hit Marker Color", color = HitMarker.Color, flag = "hm_color", callback = function(c) HitMarker.Color = c end })
AimTab:CreateSlider({ name = "Hit Marker Size", range = {5, 50}, increment = 1, suffix = "px", currentValue = 20, flag = "hm_size", callback = function(v) HitMarker.Size = v end })

AimTab:CreateSection("Killer Aim (Lock saat Hit)")
AimTab:CreateToggle({ name = "Killer Aim Lock", currentValue = false, flag = "kaim_on", callback = function(v) KillerAim.Enabled = v end })
AimTab:CreateSlider({ name = "Killer Aim FOV", range = {50, 500}, increment = 10, currentValue = 200, flag = "kaim_fov", callback = function(v) KillerAim.FOV = v end })
AimTab:CreateSlider({ name = "Killer Aim Smoothness", range = {0.1, 1}, increment = 0.05, currentValue = 0.5, flag = "kaim_smooth", callback = function(v) KillerAim.Strength = v end })

-- ============ KILLER TAB ============
local KillerTab = Window:CreateTab({ name = "Killer", icon = 0 })
KillerTab:CreateSection("Attack")
KillerTab:CreateToggle({ name = "Auto Attack", currentValue = false, flag = "k_attack", callback = function(v) Killer.AutoAttack = v end })
KillerTab:CreateToggle({ name = "Auto Kill All", currentValue = false, flag = "k_killall", callback = function(v) Killer.KillAll = v end })
KillerTab:CreateToggle({ name = "Prediction Attack", currentValue = false, flag = "k_predict", callback = function(v) Killer.PredictionAttack = v end })
KillerTab:CreateSlider({ name = "Prediction Strength", range = {0, 1}, increment = 0.05, currentValue = 0.15, flag = "k_predict_str", callback = function(v) Killer.PredictStrength = v end })
KillerTab:CreateSection("Carry & Hook")
KillerTab:CreateToggle({ name = "Auto Carry Downed", currentValue = false, flag = "k_carry", callback = function(v) Killer.AutoCarry = v end })
KillerTab:CreateToggle({ name = "Auto Hook After Carry", currentValue = false, flag = "k_hook", callback = function(v) Killer.AutoHook = v end })
KillerTab:CreateToggle({ name = "Auto Hook All Downed", currentValue = false, flag = "k_hookall", callback = function(v) Killer.AutoHookAllDowned = v end })
KillerTab:CreateSlider({ name = "Hook All Range", range = {100, 2000}, increment = 50, suffix = "stud", currentValue = 500, flag = "k_hookall_range", callback = function(v) Killer.AutoHookAllRange = v end })
KillerTab:CreateSection("Auto Sprint")
KillerTab:CreateToggle({ name = "Auto Sprint", currentValue = false, flag = "k_sprint", callback = function(v) Killer.AutoSprint = v end })
KillerTab:CreateSlider({ name = "Sprint Speed", range = {16, 100}, increment = 1, currentValue = 30, flag = "k_sprint_val", callback = function(v) Killer.AutoSprintValue = v end })
KillerTab:CreateSection("Auto Face Target")
KillerTab:CreateToggle({ name = "Auto Face Survivor", currentValue = false, flag = "k_face", callback = function(v) Killer.AutoFaceTarget = v end })
KillerTab:CreateSlider({ name = "Face Range", range = {5, 100}, increment = 5, suffix = "stud", currentValue = 20, flag = "k_face_range", callback = function(v) Killer.AutoFaceRange = v end })
KillerTab:CreateSection("Chase Detector")
KillerTab:CreateToggle({ name = "Chase Alert", currentValue = false, flag = "k_chase", callback = function(v) ChaseDetector.Enabled = v end })
KillerTab:CreateSlider({ name = "Chase Range", range = {10, 200}, increment = 5, suffix = "stud", currentValue = 30, flag = "k_chase_range", callback = function(v) ChaseDetector.Range = v end })
KillerTab:CreateSection("Stalk")
KillerTab:CreateToggle({ name = "Auto Stalk", currentValue = false, flag = "k_stalk", callback = function(v) Killer.AutoStalk = v; if v and _G.startAutoStalk then _G.startAutoStalk() elseif _G.stopAutoStalk then _G.stopAutoStalk() end end })
KillerTab:CreateSlider({ name = "Stalk Range", range = {50, 500}, increment = 10, suffix = "stud", currentValue = 150, flag = "k_stalk_range", callback = function(v) Killer.StalkRange = v end })
KillerTab:CreateSection("Masked Power")
KillerTab:CreateDropdown({ name = "Select Power", options = MaskedPowers, currentOption = "Cobra", flag = "k_masked", callback = function(opt) Masked.CurrentPower = opt end })
KillerTab:CreateButton({ name = "Activate Power", callback = function() if _G.activateMasked then _G.activateMasked() end end })
KillerTab:CreateButton({ name = "Deactivate Power", callback = function() if _G.deactivateMasked then _G.deactivateMasked() end end })

-- ============ TELEPORT TAB ============
local TeleportTab = Window:CreateTab({ name = "Teleport", icon = 0 })
TeleportTab:CreateSection("Teleport Cepat")
TeleportTab:CreateButton({ name = "📍 Teleport ke Generator", callback = function()
    if _G.teleportToGenerator and _G.teleportToGenerator() then Rayfield:Notify({ title = "Teleport", content = "Ke Generator ✓" })
    else Rayfield:Notify({ title = "Teleport", content = "Generator tidak ditemukan" }) end
end })
TeleportTab:CreateButton({ name = "🚪 Teleport ke Gate / Exit", callback = function()
    if _G.teleportToGate and _G.teleportToGate() then Rayfield:Notify({ title = "Teleport", content = "Ke Gate ✓" })
    else Rayfield:Notify({ title = "Teleport", content = "Gate tidak ditemukan" }) end
end })
TeleportTab:CreateButton({ name = "🪟 Teleport ke Window", callback = function()
    if _G.teleportToWindow and _G.teleportToWindow() then Rayfield:Notify({ title = "Teleport", content = "Ke Window ✓" })
    else Rayfield:Notify({ title = "Teleport", content = "Window tidak ditemukan" }) end
end })
TeleportTab:CreateButton({ name = "🟨 Teleport ke Pallet", callback = function()
    if _G.teleportToPallet and _G.teleportToPallet() then Rayfield:Notify({ title = "Teleport", content = "Ke Pallet ✓" })
    else Rayfield:Notify({ title = "Teleport", content = "Pallet tidak ditemukan" }) end
end })
TeleportTab:CreateButton({ name = "🪝 Teleport ke Hook", callback = function()
    if _G.teleportToHook and _G.teleportToHook() then Rayfield:Notify({ title = "Teleport", content = "Ke Hook ✓" })
    else Rayfield:Notify({ title = "Teleport", content = "Hook tidak ditemukan" }) end
end })
TeleportTab:CreateSection("Auto Escape")
TeleportTab:CreateToggle({ name = "Auto Escape (Kabur dari Killer)", currentValue = false, flag = "auto_escape", callback = function(v) AutoEscape.Enabled = v end })
TeleportTab:CreateSlider({ name = "Detect Distance", range = {10, 200}, increment = 5, suffix = "stud", currentValue = 40, flag = "escape_dist", callback = function(v) AutoEscape.DetectDistance = v end })
TeleportTab:CreateSlider({ name = "Cooldown", range = {0.2, 3}, increment = 0.1, suffix = "s", currentValue = 0.8, flag = "escape_cd", callback = function(v) AutoEscape.Cooldown = v end })

-- ============ MISC TAB ============
local MiscTab = Window:CreateTab({ name = "Misc", icon = 0 })
MiscTab:CreateSection("Walk Speed")
MiscTab:CreateToggle({ name = "Enable Walk Speed", currentValue = false, flag = "m_ws", callback = function(v) Movement.WalkSpeedEnabled = v; if v and _G.applyWalkSpeed then _G.applyWalkSpeed() else local hum = _G.getHum(); if hum then hum.WalkSpeed = Movement.OriginalWalkSpeed end end end })
MiscTab:CreateSlider({ name = "Walk Speed Value", range = {16, 100}, increment = 0.5, currentValue = 17.6, flag = "m_ws_val", callback = function(v) Movement.WalkSpeedValue = v end })
MiscTab:CreateSection("No Clip")
MiscTab:CreateToggle({ name = "No Clip", currentValue = false, flag = "m_noclip", callback = function(v) if _G.toggleNoClip then _G.toggleNoClip(v) end end })
MiscTab:CreateSection("🌙 Moonwalk")
MiscTab:CreateToggle({ name = "Moonwalk", currentValue = false, flag = "m_moonwalk", callback = function(v) Moonwalk.Enabled = v; if v and _G.startMoonwalk then _G.startMoonwalk(); if _G.applyMoonwalkFOV then _G.applyMoonwalkFOV() end elseif _G.stopMoonwalk then _G.stopMoonwalk() end end })
MiscTab:CreateDropdown({ name = "Moonwalk Mode", options = {"Default", "Camera"}, currentOption = "Default", flag = "m_moon_mode", callback = function(opt) Moonwalk.Mode = opt; Rayfield:Notify({ title = "Moonwalk Mode", content = "Mode: " .. opt }) end })
MiscTab:CreateDropdown({ name = "Moonwalk FOV", options = {"70", "90", "120"}, currentOption = "90", flag = "m_moon_fov", callback = function(opt) Moonwalk.FOVPreset = tonumber(opt); if Moonwalk.Enabled and _G.applyMoonwalkFOV then _G.applyMoonwalkFOV() end end })
MiscTab:CreateSlider({ name = "Spam Speed", range = {1, 50}, increment = 1, currentValue = 30, flag = "m_moon_spam", callback = function(v) Moonwalk.SpamSpeed = v end })
MiscTab:CreateSlider({ name = "Intensity", range = {1, 50}, increment = 1, currentValue = 35, flag = "m_moon_int", callback = function(v) Moonwalk.Intensity = v end })
MiscTab:CreateSection("Emote")
MiscTab:CreateDropdown({ name = "Select Emote", options = EmoteList, currentOption = "Mannrobics", flag = "m_emote", callback = function(opt) Emote.Selected = opt end })
MiscTab:CreateButton({ name = "Play Emote", callback = function() if _G.playEmote then _G.playEmote(Emote.Selected) end end })

-- ============ VISUAL TAB ============
local VisualTab = Window:CreateTab({ name = "Visual", icon = 0 })
VisualTab:CreateSection("Lighting")
VisualTab:CreateToggle({ name = "Fullbright", currentValue = false, flag = "v_fb", callback = function(v) Visual.Fullbright = v; if _G.applyVisual then _G.applyVisual(true) end end })
VisualTab:CreateToggle({ name = "No Fog", currentValue = false, flag = "v_nofog", callback = function(v) Visual.NoFog = v; if _G.applyVisual then _G.applyVisual(true) end end })
VisualTab:CreateToggle({ name = "No Shadow", currentValue = false, flag = "v_noshadow", callback = function(v) Visual.NoShadow = v; if _G.applyVisual then _G.applyVisual(true) end end })
VisualTab:CreateSection("Ambient & Time")
VisualTab:CreateToggle({ name = "Custom Ambient Color", currentValue = false, flag = "v_ambient", callback = function(v) Visual.AmbientColorEnabled = v; if _G.applyVisual then _G.applyVisual(true) end end })
VisualTab:CreateColorPicker({ name = "Ambient Color", color = Visual.AmbientColor, flag = "v_ambient_color", callback = function(c) Visual.AmbientColor = c; if _G.applyVisual then _G.applyVisual(true) end end })
VisualTab:CreateToggle({ name = "Custom Clock Time", currentValue = false, flag = "v_clock", callback = function(v) Visual.ClockTimeEnabled = v; if _G.applyVisual then _G.applyVisual(true) end end })
VisualTab:CreateSlider({ name = "Clock Time", range = {0, 24}, increment = 1, currentValue = 14, flag = "v_clock_val", callback = function(v) Visual.ClockTime = v; if _G.applyVisual then _G.applyVisual(true) end end })
VisualTab:CreateSection("Fog Control")
VisualTab:CreateToggle({ name = "Custom Fog", currentValue = false, flag = "v_fog", callback = function(v) Visual.FogControlEnabled = v; if _G.applyVisual then _G.applyVisual(true) end end })
VisualTab:CreateSlider({ name = "Fog End", range = {0, 100000}, increment = 100, currentValue = 100000, flag = "v_fog_end", callback = function(v) Visual.FogEnd = v; if _G.applyVisual then _G.applyVisual(true) end end })
VisualTab:CreateSlider({ name = "Fog Start", range = {0, 100000}, increment = 100, currentValue = 0, flag = "v_fog_start", callback = function(v) Visual.FogStart = v; if _G.applyVisual then _G.applyVisual(true) end end })
VisualTab:CreateColorPicker({ name = "Fog Color", color = Visual.FogColor, flag = "v_fog_color", callback = function(c) Visual.FogColor = c; if _G.applyVisual then _G.applyVisual(true) end end })
VisualTab:CreateSection("Screen Effects")
VisualTab:CreateToggle({ name = "No Bloom", currentValue = false, flag = "v_nobloom", callback = function(v) Visual.NoBloom = v; if _G.toggleScreenEffects then _G.toggleScreenEffects() end end })
VisualTab:CreateToggle({ name = "No Blur / DOF", currentValue = false, flag = "v_noblur", callback = function(v) Visual.NoBlur = v; if _G.toggleScreenEffects then _G.toggleScreenEffects() end end })
VisualTab:CreateToggle({ name = "No Blood", currentValue = false, flag = "v_noblood", callback = function(v) Visual.NoBlood = v; if _G.removeBlood then _G.removeBlood() end end })
VisualTab:CreateSection("Color Correction")
VisualTab:CreateToggle({ name = "Enable Color Correction", currentValue = false, flag = "v_cc", callback = function(v) Visual.ColorCorrection = v; if _G.applyColorCorrection then _G.applyColorCorrection() end end })
VisualTab:CreateSlider({ name = "Saturation", range = {-1, 1}, increment = 0.05, currentValue = 0, flag = "v_sat", callback = function(v) Visual.Saturation = v; if _G.applyColorCorrection then _G.applyColorCorrection() end end })
VisualTab:CreateSlider({ name = "Brightness", range = {-1, 1}, increment = 0.05, currentValue = 0, flag = "v_bright", callback = function(v) Visual.Brightness = v; if _G.applyColorCorrection then _G.applyColorCorrection() end end })
VisualTab:CreateSlider({ name = "Contrast", range = {-1, 1}, increment = 0.05, currentValue = 0, flag = "v_contrast", callback = function(v) Visual.Contrast = v; if _G.applyColorCorrection then _G.applyColorCorrection() end end })
VisualTab:CreateButton({ name = "🔄 Reset Color", callback = function() 
    if _G.resetColorCorrection then _G.resetColorCorrection() end
    Rayfield:Notify({ title = "Color Reset", content = "Saturation, Brightness, Contrast di-reset ke 0." }) 
end })
VisualTab:CreateSection("Effect")
VisualTab:CreateToggle({ name = "Hide Red Spark", currentValue = false, flag = "v_hide_spark", callback = function(v) HideSpark.Enabled = v; if v and _G.startHideSpark then _G.startHideSpark() elseif _G.stopHideSpark then _G.stopHideSpark() end end })

-- ============ ANTI-LAG TAB ============
local AntiLagTab = Window:CreateTab({ name = "Anti-Lag", icon = 0 })
AntiLagTab:CreateSection("Anti-Lag Pack")
AntiLagTab:CreateToggle({ name = "Enable Anti-Lag", currentValue = false, flag = "al_on", callback = function(v) AntiLag.Enabled = v; if v and _G.applyAntiLag then _G.applyAntiLag() end end })
AntiLagTab:CreateSection("Individual")
AntiLagTab:CreateToggle({ name = "No Particles", currentValue = false, flag = "al_particles", callback = function(v) AntiLag.NoParticles = v; if _G.applyAntiLag then _G.applyAntiLag() end end })
AntiLagTab:CreateToggle({ name = "No Textures", currentValue = false, flag = "al_textures", callback = function(v) AntiLag.NoTextures = v; if _G.applyAntiLag then _G.applyAntiLag() end end })
AntiLagTab:CreateToggle({ name = "Physics Throttle", currentValue = false, flag = "al_physics", callback = function(v) AntiLag.PhysicsThrottle = v; if _G.applyAntiLag then _G.applyAntiLag() end end })
AntiLagTab:CreateToggle({ name = "No Global Shadows", currentValue = false, flag = "al_shadows", callback = function(v) AntiLag.NoGlobalShadows = v; if _G.applyAntiLag then _G.applyAntiLag() end end })
AntiLagTab:CreateToggle({ name = "Network Replication Lag", currentValue = false, flag = "al_net", callback = function(v) AntiLag.NetworkLag = v; if _G.applyAntiLag then _G.applyAntiLag() end end })

-- ============ CROSSHAIR TAB ============
local CrosshairTab = Window:CreateTab({ name = "Crosshair", icon = 0 })
CrosshairTab:CreateToggle({ name = "Enable Crosshair", currentValue = false, flag = "ch_on", callback = function(v) Crosshair.Enabled = v end })
CrosshairTab:CreateColorPicker({ name = "Color", color = Crosshair.Color, flag = "ch_color", callback = function(c) Crosshair.Color = c end })
CrosshairTab:CreateSlider({ name = "Size", range = {2, 30}, increment = 1, suffix = "px", currentValue = 8, flag = "ch_size", callback = function(v) Crosshair.Size = v end })
CrosshairTab:CreateSlider({ name = "Thickness", range = {1, 5}, increment = 1, suffix = "px", currentValue = 2, flag = "ch_thick", callback = function(v) Crosshair.Thickness = v end })
CrosshairTab:CreateSlider({ name = "Position X", range = {-100, 100}, increment = 1, suffix = "px", currentValue = 0, flag = "ch_x", callback = function(v) Crosshair.OffsetX = v end })
CrosshairTab:CreateSlider({ name = "Position Y", range = {-100, 100}, increment = 1, suffix = "px", currentValue = 0, flag = "ch_y", callback = function(v) Crosshair.OffsetY = v end })

-- ============ UI SETTINGS TAB ============
local UISettingsTab = Window:CreateTab({ name = "UI Settings", icon = 0 })
UISettingsTab:CreateSection("Sound Feedback")
UISettingsTab:CreateToggle({ name = "Enable Click Sound", currentValue = true, flag = "sf_on", callback = function(v) SoundFeedback.Enabled = v end })
UISettingsTab:CreateDropdown({ name = "Sound Type", options = {"Click", "Switch", "Beep", "Bell", "Whoosh"}, currentOption = "Click", flag = "sf_type", callback = function(opt)
    SoundFeedback.CurrentSound = opt
    if _G.playClickSound then _G.playClickSound() end
end })
UISettingsTab:CreateSlider({ name = "Volume", range = {0, 1}, increment = 0.05, currentValue = 0.5, flag = "sf_vol", callback = function(v)
    SoundFeedback.Volume = v
    if _G.SoundInstance then _G.SoundInstance.Volume = v end
    if _G.playClickSound then _G.playClickSound() end
end })
UISettingsTab:CreateButton({ name = "🔊 Test Sound", callback = function()
    if _G.playClickSound then _G.playClickSound() end
    Rayfield:Notify({ title = "Sound", content = "Sound: " .. SoundFeedback.CurrentSound })
end })

print("[TiarHub v17.5] Part 5/6 loaded. Ketik 'lanjut' buat Part 6 (terakhir).")
