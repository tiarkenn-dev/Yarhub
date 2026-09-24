-- ═══════════════════════════════════════════
--   TIARHUB
--   UI: Obsidian | Game: Violence District
-- ═══════════════════════════════════════════

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true

-- ─── SERVICES ─────────────────────────────────
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ─── WINDOW ───────────────────────────────────
local Window = Library:CreateWindow({
    Title = "TIARHUB",
    Footer = "Violence District | v1.0",
    Icon = 0,
    NotifySide = "Right",
    ShowCustomCursor = true,
    Size = UDim2.fromOffset(540, 380),
})

task.wait(0.1)
if Window.UI then
    Window.UI.Position = UDim2.new(0.5, 0, 0.03, 0)
    Window.UI.AnchorPoint = Vector2.new(0.5, 0)
end

-- ═══════════════════════════════════════════
--  TABS
-- ═══════════════════════════════════════════
local Tabs = {
    Combat   = Window:AddTab("Combat",   "sword"),
    Aimlock  = Window:AddTab("Aimlock",  "crosshair"),
    Killer   = Window:AddTab("Killer",   "skull"),
    Visuals  = Window:AddTab("Visuals",  "eye"),
    Movement = Window:AddTab("Movement", "activity"),
    Teleport = Window:AddTab("Teleport", "map-pin"),
    Avatar   = Window:AddTab("Avatar",   "user"),
    Crosshair= Window:AddTab("Crosshair","crosshair"),
    AntiLag  = Window:AddTab("Anti-Lag", "zap"),
    Settings = Window:AddTab("Settings", "settings"),
}

-- ═══════════════════════════════════════════
--  CONFIG - ESP
-- ═══════════════════════════════════════════
local ESP = {
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
local ESPStatus = { Enabled = false, ShowName = true, ShowDistance = true, ShowHealth = false, Radius = 100 }
local KillerWarning = { Enabled = false, Distance = 60, Color = Color3.fromRGB(255, 0, 0) }

-- ═══════════════════════════════════════════
--  CONFIG - VISUAL
-- ═══════════════════════════════════════════
local Visual = {
    Fullbright = false, NoFog = false, NoShadow = false,
    NoBloom = false, NoBlur = false, ColorCorrection = false,
    Saturation = 0, Brightness = 0, Contrast = 0,
}
local VisualOriginal = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart, FogColor = Lighting.FogColor
}

-- ═══════════════════════════════════════════
--  CONFIG - AUTO PARRY
-- ═══════════════════════════════════════════
local PARRY_PRESETS = {
    Safety     = { Distance = 12, Debounce = 0.15, Face = 0.5, RequireFacing = true },
    Aggressive = { Distance = 20, Debounce = 0.05, Face = -1,  RequireFacing = false }
}
local Auto = {
    Parry = false, ParryMode = "Safety",
    ParryDistance = 12, FaceSensitivity = 0.5, RequireFacing = true,
    SkillCheck = false, Wiggle = false, WiggleSpam = 5
}
local PARRY_DEBOUNCE = 0.15
local function applyParryPreset(mode)
    local p = PARRY_PRESETS[mode]
    if not p then return end
    Auto.ParryDistance = p.Distance
    Auto.FaceSensitivity = p.Face
    Auto.RequireFacing = p.RequireFacing
    PARRY_DEBOUNCE = p.Debounce
end

local ParryRangeVisual = { Enabled = false, Color = Color3.fromRGB(255, 80, 80), Transparency = 0.7, RainbowMode = false, PulseEnabled = true }
local ParryCircle = nil
local ParryCircleInner = nil
local AutoFlee = { Enabled = false, DetectDistance = 50, Cooldown = 0.1 }
local LastFlee = 0
local FastVault = { Enabled = false, Speed = 1.2, ReplaceMap = { ["rbxassetid://83873880822918"] = "rbxassetid://136962284480779" } }
local VaultTracks = {}

-- ═══════════════════════════════════════════
--  CONFIG - AUTO DODGE
-- ═══════════════════════════════════════════
local AutoDodgeAbyss = { Enabled = false, DetectRange = 18, Cooldown = 0.5, CrouchDuration = 0.3, LastDodge = 0, IsCrouching = false }

-- ═══════════════════════════════════════════
--  CONFIG - FAKE PERKS
-- ═══════════════════════════════════════════
local FakePerks = {
    Flowstate = { Enabled = false, Duration = 3, SpeedBoost = 20, Cooldown = 60, LastUse = 0 },
    SnakeStep = { Enabled = false, SpeedBoost = 90, Cooldown = 30, LastUse = 0 },
    QuickRecovery = { Enabled = false, Cooldown = 60, LastUse = 0 },
    PerfectLanding = { Enabled = false, Cooldown = 90, LastUse = 0 },
    LastVault = 0, LastCrouchState = false
}

-- ═══════════════════════════════════════════
--  CONFIG - AIMBOT
-- ═══════════════════════════════════════════
local GunAim = {
    Enabled = false, Holding = false, TargetMode = "Killer",
    Strength = 1, Predict = true, PredictStrength = 0.12,
    FOV = 250, VisibilityCheck = false, AimPart = "HumanoidRootPart",
    ShowTracer = false, TracerColor = Color3.fromRGB(255, 0, 0)
}

local KillerAimbot = {
    Enabled = false, Holding = false,
    FOV = 200, Strength = 0.5,
    Predict = true, PredictStrength = 0.12,
    AimPart = "HumanoidRootPart",
    ShowFOV = false, ShowTracer = false,
    TracerColor = Color3.fromRGB(255, 0, 0)
}

local Aimlock = {
    Enabled = false,
    LockRadius = 100,
    FOVRadius = 300,
    Smoothness = 0.4,
    ShowFOVCircle = true,
    Button = nil,
    Circle = nil
}

-- ═══════════════════════════════════════════
--  CONFIG - SILENT AIM
-- ═══════════════════════════════════════════
local SilentAimSpear = { Enabled = false, TargetMode = "Killer", FOV = 250, AimPart = "HumanoidRootPart", Prediction = 0.12, Holding = false, ShowFOV = false }

-- ═══════════════════════════════════════════
--  CONFIG - HIDE SPARK
-- ═══════════════════════════════════════════
local HideSpark = { Enabled = false }
local HiddenSparkCache = {}

-- ═══════════════════════════════════════════
--  CONFIG - TELEPORT
-- ═══════════════════════════════════════════
local Teleport = { LastTeleport = 0, Cooldown = 0.5 }
local AutoEscape = { Enabled = false, DetectDistance = 40, Cooldown = 0.8, LastEscape = 0 }

-- ═══════════════════════════════════════════
--  CONFIG - SKILL CHECK
-- ═══════════════════════════════════════════
local SkillCheckMode = "Perfect"

-- ═══════════════════════════════════════════
--  CONFIG - KILLER
-- ═══════════════════════════════════════════
local Killer = {
    AutoAttack = false, AutoCarry = false, AutoHook = false, KillAll = false,
    AutoStalk = false, StalkRange = 150,
    AutoHookAllDowned = false, AutoHookAllRange = 500,
    AutoSprint = false, AutoSprintValue = 30,
    AutoFaceTarget = false, AutoFaceRange = 20,
    PredictionAttack = false, PredictStrength = 0.15
}
local KillerBusy = false
local KillerTarget = nil
local StalkConnection = nil
local HitMarker = { Enabled = false, Color = Color3.fromRGB(255, 0, 0), Size = 20, Thickness = 2, Duration = 0.15 }
local HitMarkerLines = {}
local HitMarkerActive = false
local HitMarkerEnd = 0
local ChaseDetector = { Enabled = false, Range = 30, LastNotify = 0, Cooldown = 2 }

-- ═══════════════════════════════════════════
--  CONFIG - MOVEMENT
-- ═══════════════════════════════════════════
local Movement = { WalkSpeedEnabled = false, WalkSpeedValue = 17.6, OriginalWalkSpeed = 16, NoClip = false }

-- ═══════════════════════════════════════════
--  CONFIG - MOONWALK
-- ═══════════════════════════════════════════
local Moonwalk = { Enabled = false, ShowButton = false, SpamSpeed = 30, Intensity = 35, SlowSpeed = 13, UseSlow = true, Mode = "Default", FOVPreset = 90 }
local MoonwalkConnection = nil
local MoonwalkHeartbeat = nil
local MoonwalkButton = nil
local ParryActive = false

-- ═══════════════════════════════════════════
--  CONFIG - CROSSHAIR
-- ═══════════════════════════════════════════
local Crosshair = { Enabled = false, Size = 8, Thickness = 2, Color = Color3.fromRGB(255, 255, 255), OffsetX = 0, OffsetY = 0 }
local CrosshairGui = nil

-- ═══════════════════════════════════════════
--  CONFIG - EMOTE
-- ═══════════════════════════════════════════
local Emote = { Selected = "Mannrobics" }
local EmoteList = { "Mannrobics","Arm Swing","Schadenfreude","Kyoufuu","Backflip","Griddy","Friday Night","Floating Rest","OnePlays","Quick Combo","WarCry","Wave" }

-- ═══════════════════════════════════════════
--  CONFIG - MASKED
-- ═══════════════════════════════════════════
local Masked = { CurrentPower = "Cobra" }
local MaskedPowers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}

-- ═══════════════════════════════════════════
--  CONFIG - ANTI-LAG
-- ═══════════════════════════════════════════
local AntiLag = { Enabled = false, NoParticles = false, NoTextures = false, PhysicsThrottle = false, NoGlobalShadows = false, NetworkLag = false }

-- ═══════════════════════════════════════════
--  CONFIG - AVATAR COPIER
-- ═══════════════════════════════════════════
local AvatarCopier = { Enabled = true, TargetUsername = "", OriginalDescription = nil, CurrentCopiedUserId = nil, BlockyBody = true }

-- ═══════════════════════════════════════════
--  KILLER ANIM IDS
-- ═══════════════════════════════════════════
local KillerAnims = {
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

-- ═══════════════════════════════════════════
--  REMOTES
-- ═══════════════════════════════════════════
local function findRemote(path)
    local cur = ReplicatedStorage
    for segment in string.gmatch(path, "[^%.]+") do
        cur = cur and cur:FindFirstChild(segment)
        if not cur then return nil end
    end
    return cur
end

local AttackEvent = findRemote("Remotes.Attacks.BasicAttack")
local CarryEvent = findRemote("Remotes.Carry.CarrySurvivorEvent")
local HookEvent = findRemote("Remotes.Carry.HookEvent")
local EmoteRemote = findRemote("Remotes.EmoteHandler")

-- ═══════════════════════════════════════════
--  HELPER
-- ═══════════════════════════════════════════
local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end
local function isDowned()
    local hum = getHum()
    if not hum then return false end
    return hum.Health <= 0 or hum.Health < 2
end
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
                    if id and KillerAnims["rbxassetid://" .. id] then return true end
                end
            end
        end
    end
    if hum and (hum.Health <= 0 or hum.Health < 2) then return true end
    return false
end
local function GetPos(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj.Position end
    if obj:IsA("Model") then
        local ok, pivot = pcall(function() return obj:GetPivot().Position end)
        if ok then return pivot end
    end
    return nil
end
local function getTeamLabel(plr)
    if not plr.Team then return "?" end
    if plr.Team.Name == "Killer" then return "KILLER" end
    if plr.Team.Name == "Survivors" or plr.Team.Name == "Survivor" then return "SURVIVOR" end
    return plr.Team.Name
end
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

print("[TIARHUB] Part 1/10 loaded.")-- ═══════════════════════════════════════════
--  ESP SYSTEM
-- ═══════════════════════════════════════════

local ESPObjects = {}
local ESPNames = {}
local StatusESP = {}
local CachedObjects = { Generators = {}, Hooks = {}, Pallets = {}, Windows = {} }
local CachedSCP = {}

local function removeESP(obj)
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
    if ESPNames[obj] then ESPNames[obj]:Destroy(); ESPNames[obj] = nil end
end

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
                lbl.Font = Enum.Font.GothamBlack
                lbl.TextSize = ESP.NameSize
                lbl.Parent = bb
                ESPNames[obj] = bb
            end
        end
    end
end

-- ─── GENERATOR ESP ────────────────────────────
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

-- ─── STATUS ESP ───────────────────────────────
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

-- ─── CACHE OBJECT ─────────────────────────────
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

-- ─── KILLER WARNING ───────────────────────────
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

-- ═══════════════════════════════════════════
--  FPS/PING WATERMARK
-- ═══════════════════════════════════════════
local FPS = 0
local Frames = 0
local LastTick = tick()

RunService.RenderStepped:Connect(function()
    Frames = Frames + 1
    if tick() - LastTick >= 1 then
        FPS = Frames
        Frames = 0
        LastTick = tick()
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        pcall(function()
            if Library.SetWatermark then
                Library:SetWatermark(string.format("TIARHUB | FPS: %d | PING: %d ms", FPS, ping))
            end
        end)
    end
end)

-- ═══════════════════════════════════════════
--  MAIN ESP LOOP
-- ═══════════════════════════════════════════
local lastUpdate = 0
RunService.RenderStepped:Connect(function()
    pcall(function()
        local root = getRoot()
        if not root then return end
        local now = tick()
        if now - lastUpdate < 0.05 then return end
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

-- ═══════════════════════════════════════════
--  PARRY CIRCLE (SMOOTH)
-- ═══════════════════════════════════════════
RunService.RenderStepped:Connect(function()
    pcall(function()
        local root = getRoot()
        if not ParryRangeVisual.Enabled or not root then
            if ParryCircle then ParryCircle:Destroy(); ParryCircle = nil end
            if ParryCircleInner then ParryCircleInner:Destroy(); ParryCircleInner = nil end
            return
        end

        if not ParryCircle then
            ParryCircle = Instance.new("Part")
            ParryCircle.Shape = Enum.PartType.Cylinder
            ParryCircle.Anchored = true
            ParryCircle.CanCollide = false
            ParryCircle.Material = Enum.Material.Neon
            ParryCircle.Name = "ParryCircleOuter"
            ParryCircle.Parent = workspace
        end
        if not ParryCircleInner then
            ParryCircleInner = Instance.new("Part")
            ParryCircleInner.Shape = Enum.PartType.Cylinder
            ParryCircleInner.Anchored = true
            ParryCircleInner.CanCollide = false
            ParryCircleInner.Material = Enum.Material.Neon
            ParryCircleInner.Name = "ParryCircleInner"
            ParryCircleInner.Parent = workspace
        end

        local baseSize = Auto.ParryDistance * 2
        local pulse = 0
        if ParryRangeVisual.PulseEnabled then
            pulse = math.sin(tick() * 3) * 0.15
        end

        local sizeOuter = baseSize + pulse
        local sizeInner = baseSize - 0.8
        local yOffset = root.Size.Y / 2 + 1.5
        local targetCF = CFrame.new(root.Position - Vector3.new(0, yOffset, 0)) * CFrame.Angles(0, 0, math.rad(90))

        ParryCircle.Size = Vector3.new(0.3, sizeOuter, sizeOuter)
        ParryCircle.CFrame = ParryCircle.CFrame:Lerp(targetCF, 0.4)
        ParryCircle.Transparency = ParryRangeVisual.Transparency

        ParryCircleInner.Size = Vector3.new(0.15, sizeInner, sizeInner)
        ParryCircleInner.CFrame = ParryCircle.CFrame
        ParryCircleInner.Transparency = ParryRangeVisual.Transparency + 0.15

        local color = ParryRangeVisual.Color
        if ParryRangeVisual.RainbowMode then
            color = Color3.fromHSV((tick() * 0.1) % 1, 1, 1)
        end
        ParryCircle.Color = color
        ParryCircleInner.Color = color
    end)
end)

print("[TIARHUB] Part 2/10 loaded.")-- ═══════════════════════════════════════════
--  AUTO PARRY SYSTEM
-- ═══════════════════════════════════════════

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
    if now - lastParry < PARRY_DEBOUNCE then return end
    lastParry = now
    ParryActive = true
    pressParryButton()
    task.delay(0.25, function() ParryActive = false end)
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

-- ═══════════════════════════════════════════
--  AUTO SKILL CHECK
-- ═══════════════════════════════════════════

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

            if SkillCheckMode == "Instant" then
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

-- ═══════════════════════════════════════════
--  AUTO WIGGLE
-- ═══════════════════════════════════════════

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

-- ═══════════════════════════════════════════
--  AUTO FLEE
-- ═══════════════════════════════════════════

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
            if killerRoot and distance <= AutoFlee.DetectDistance and tick() - LastFlee > AutoFlee.Cooldown then
                local point = GetFarthestGeneratorPoint(killerRoot)
                if point then
                    LastFlee = tick()
                    root.CFrame = point.CFrame + Vector3.new(0, 5, 0)
                end
            end
        end)
    end
end)

-- ═══════════════════════════════════════════
--  AUTO DODGE ABYSS
-- ═══════════════════════════════════════════

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

-- ═══════════════════════════════════════════
--  FAKE PERKS (4 MACAM + COOLDOWN)
-- ═══════════════════════════════════════════

-- 1. FAKE FLOWSTATE
local function hookFakeFlowstate(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    animator.AnimationPlayed:Connect(function(track)
        if not FakePerks.Flowstate.Enabled then return end
        local now = tick()
        if now - FakePerks.Flowstate.LastUse < FakePerks.Flowstate.Cooldown then return end

        local anim = track.Animation
        if not anim or not anim.AnimationId then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end

        local vaultIds = {
            ["rbxassetid://83873880822918"] = true,
            ["rbxassetid://136962284480779"] = true,
        }

        if vaultIds["rbxassetid://" .. id] then
            FakePerks.Flowstate.LastUse = now
            local originalSpeed = hum.WalkSpeed
            hum.WalkSpeed = originalSpeed * (1 + FakePerks.Flowstate.SpeedBoost / 100)
            Library:Notify({ Title = "Fake Flowstate", Description = "Speed boost aktif!", Time = 2 })
            task.delay(FakePerks.Flowstate.Duration, function()
                if hum and hum.Parent then
                    hum.WalkSpeed = originalSpeed
                end
            end)
        end
    end)
end

-- 2. FAKE SNAKE STEP
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if not FakePerks.SnakeStep.Enabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end

            local now = tick()
            if now - FakePerks.SnakeStep.LastUse < FakePerks.SnakeStep.Cooldown then return end

            local isCrouching = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
                or (hum.HipHeight and hum.HipHeight < 1.5)

            if isCrouching and not FakePerks.LastCrouchState then
                FakePerks.LastCrouchState = true
                FakePerks.SnakeStep.LastUse = now
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

-- 3. FAKE QUICK RECOVERY
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if not FakePerks.QuickRecovery.Enabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end

            local now = tick()
            if now - FakePerks.QuickRecovery.LastUse < FakePerks.QuickRecovery.Cooldown then return end

            if hum:GetState() == Enum.HumanoidStateType.FallingDown
                or hum:GetState() == Enum.HumanoidStateType.Ragdoll
                or hum.Health < hum.MaxHealth * 0.3 then
                FakePerks.QuickRecovery.LastUse = now
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
                Library:Notify({ Title = "Quick Recovery", Description = "Recovery aktif!", Time = 1.5 })
            end
        end)
    end
end)

-- 4. FAKE PERFECT LANDING
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if not FakePerks.PerfectLanding.Enabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end

            local now = tick()
            if now - FakePerks.PerfectLanding.LastUse < FakePerks.PerfectLanding.Cooldown then return end

            if hum:GetState() == Enum.HumanoidStateType.Freefall then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.AssemblyLinearVelocity.Y < -50 then
                    FakePerks.PerfectLanding.LastUse = now
                    pcall(function()
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                        hum.Health = hum.MaxHealth
                    end)
                    Library:Notify({ Title = "Perfect Landing", Description = "Anti damage jatuh!", Time = 1.5 })
                end
            end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function() hookFakeFlowstate(char) end)
end)
if LocalPlayer.Character then pcall(function() hookFakeFlowstate(LocalPlayer.Character) end) end

print("[TIARHUB] Part 3/10 loaded.")-- ═══════════════════════════════════════════
--  AIMBOT SYSTEM + AIMLOCK + SILENT AIM
-- ═══════════════════════════════════════════

local Drawing = Drawing

-- ─── FOV CIRCLE (PISTOL) ──────────────────────
local FOVCircle = nil
local FOVCircleInner = nil
local FOVCircleVisible = false
local FOVCircleSize = 250
local FOVCircleColor = Color3.fromRGB(255, 255, 255)
local TracerLine = nil

local function createFOVCircle()
    if not Drawing then return end
    if FOVCircle then FOVCircle:Remove() end
    if FOVCircleInner then FOVCircleInner:Remove() end
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Thickness = 2
    FOVCircle.NumSides = 80
    FOVCircle.Radius = FOVCircleSize
    FOVCircle.Filled = false
    FOVCircle.Color = FOVCircleColor
    FOVCircle.Transparency = 0.6
    FOVCircleInner = Drawing.new("Circle")
    FOVCircleInner.Visible = false
    FOVCircleInner.Thickness = 1
    FOVCircleInner.NumSides = 80
    FOVCircleInner.Radius = FOVCircleSize - 3
    FOVCircleInner.Filled = false
    FOVCircleInner.Color = FOVCircleColor
    FOVCircleInner.Transparency = 0.3
end

local function createTracer()
    if not Drawing then return end
    if TracerLine then TracerLine:Remove() end
    TracerLine = Drawing.new("Line")
    TracerLine.Visible = false
    TracerLine.Thickness = 1
    TracerLine.Color = GunAim.TracerColor
end

createTracer()
createFOVCircle()

RunService.RenderStepped:Connect(function()
    pcall(function()
        if not FOVCircle then return end
        if FOVCircleVisible then
            FOVCircle.Visible = true
            FOVCircle.Radius = FOVCircleSize
            FOVCircle.Color = FOVCircleColor
            FOVCircle.Position = Vector2.new(
                workspace.CurrentCamera.ViewportSize.X / 2,
                workspace.CurrentCamera.ViewportSize.Y / 2
            )
            if FOVCircleInner then
                FOVCircleInner.Visible = true
                FOVCircleInner.Radius = FOVCircleSize - 3
                FOVCircleInner.Color = FOVCircleColor
                FOVCircleInner.Position = FOVCircle.Position
            end
        else
            FOVCircle.Visible = false
            if FOVCircleInner then FOVCircleInner.Visible = false end
        end
    end)
end)

-- ─── RAYCAST ──────────────────────────────────
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

-- ─── AIMBOT PISTOL (TARGET KILLER) ────────────
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

-- ─── AIMBOT KILLER (TARGET SURVIVOR) ──────────
local KillerAimbotCircle = nil
local KillerAimbotTracer = nil

local function createKillerAimbotCircle()
    if not Drawing then return end
    if KillerAimbotCircle then KillerAimbotCircle:Remove() end
    KillerAimbotCircle = Drawing.new("Circle")
    KillerAimbotCircle.Visible = false
    KillerAimbotCircle.Thickness = 2
    KillerAimbotCircle.NumSides = 80
    KillerAimbotCircle.Radius = KillerAimbot.FOV
    KillerAimbotCircle.Filled = false
    KillerAimbotCircle.Color = Color3.fromRGB(255, 100, 100)
    KillerAimbotCircle.Transparency = 0.6
end

local function createKillerAimbotTracer()
    if not Drawing then return end
    if KillerAimbotTracer then KillerAimbotTracer:Remove() end
    KillerAimbotTracer = Drawing.new("Line")
    KillerAimbotTracer.Visible = false
    KillerAimbotTracer.Thickness = 1
    KillerAimbotTracer.Color = KillerAimbot.TracerColor
end

createKillerAimbotCircle()
createKillerAimbotTracer()

local function getClosestKillerAimbotTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, shortest = nil, KillerAimbot.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local isSurvivor = p.Team and (p.Team.Name == "Survivors" or p.Team.Name == "Survivor")
            if isSurvivor then
                local hrp = p.Character:FindFirstChild(KillerAimbot.AimPart) or p.Character:FindFirstChild("HumanoidRootPart")
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

RunService.RenderStepped:Connect(function()
    pcall(function()
        if KillerAimbotCircle then
            KillerAimbotCircle.Visible = KillerAimbot.Enabled and KillerAimbot.ShowFOV
            KillerAimbotCircle.Radius = KillerAimbot.FOV
            KillerAimbotCircle.Position = Vector2.new(
                workspace.CurrentCamera.ViewportSize.X / 2,
                workspace.CurrentCamera.ViewportSize.Y / 2
            )
        end
        if not KillerAimbot.Enabled then
            if KillerAimbotTracer then KillerAimbotTracer.Visible = false end
            return
        end
        if not KillerAimbot.Holding then
            if KillerAimbotTracer then KillerAimbotTracer.Visible = false end
            return
        end
        local cam = workspace.CurrentCamera
        local target = getClosestKillerAimbotTarget()
        if not target then
            if KillerAimbotTracer then KillerAimbotTracer.Visible = false end
            return
        end
        local pos = target.Position
        if KillerAimbot.Predict then
            pos = pos + (target.AssemblyLinearVelocity * KillerAimbot.PredictStrength)
        end
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, pos), KillerAimbot.Strength)
        if KillerAimbot.ShowTracer and KillerAimbotTracer then
            local screenPos, onScreen = cam:WorldToViewportPoint(target.Position)
            if onScreen then
                KillerAimbotTracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                KillerAimbotTracer.To = Vector2.new(screenPos.X, screenPos.Y)
                KillerAimbotTracer.Color = KillerAimbot.TracerColor
                KillerAimbotTracer.Visible = true
            end
        end
    end)
end)

-- ─── AIMLOCK BUTTON ───────────────────────────
local function createAimlockCircle()
    if not Drawing then return end
    if Aimlock.Circle then Aimlock.Circle:Remove() end
    Aimlock.Circle = Drawing.new("Circle")
    Aimlock.Circle.Visible = false
    Aimlock.Circle.Thickness = 2
    Aimlock.Circle.NumSides = 80
    Aimlock.Circle.Radius = Aimlock.FOVRadius
    Aimlock.Circle.Filled = false
    Aimlock.Circle.Color = Color3.fromRGB(255, 50, 50)
    Aimlock.Circle.Transparency = 0.5
end
createAimlockCircle()

local function getClosestKillerForAimlock()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, shortest = nil, Aimlock.LockRadius
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
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
    return closest
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        if not Aimlock.Enabled then
            if Aimlock.Circle then Aimlock.Circle.Visible = false end
            return
        end
        if Aimlock.Circle and Aimlock.ShowFOVCircle then
            Aimlock.Circle.Visible = true
            Aimlock.Circle.Radius = Aimlock.FOVRadius
            Aimlock.Circle.Position = Vector2.new(
                workspace.CurrentCamera.ViewportSize.X / 2,
                workspace.CurrentCamera.ViewportSize.Y / 2
            )
        elseif Aimlock.Circle then
            Aimlock.Circle.Visible = false
        end
        local target = getClosestKillerForAimlock()
        if not target then return end
        local cam = workspace.CurrentCamera
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, target.Position), Aimlock.Smoothness)
    end)
end)

local function createAimlockBtn()
    pcall(function()
        if Aimlock.Button then Aimlock.Button:Destroy() end
        local gui = Instance.new("ScreenGui")
        gui.Name = "AimlockBtnGui"
        gui.ResetOnSpawn = false
        gui.Parent = PlayerGui
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 60, 0, 60)
        btn.Position = UDim2.new(0.5, 0, 0.85, 0)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = "AIM"
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 14
        btn.TextStrokeTransparency = 0.5
        btn.Parent = gui
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = btn
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(255, 50, 50)
        stroke.Transparency = 0.3
        stroke.Parent = btn
        btn.MouseButton1Click:Connect(function()
            Aimlock.Enabled = not Aimlock.Enabled
            if Aimlock.Enabled then
                btn.Text = "LOCK"
                btn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
                Library:Notify({ Title = "Aimlock", Description = "Aimlock ON", Time = 2 })
            else
                btn.Text = "AIM"
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                Library:Notify({ Title = "Aimlock", Description = "Aimlock OFF", Time = 2 })
            end
        end)
        Aimlock.Button = gui
    end)
end

local function removeAimlockBtn()
    if Aimlock.Button then Aimlock.Button:Destroy(); Aimlock.Button = nil end
end

-- ─── SILENT AIM VEIL SPEAR ────────────────────
local SilentAimCircle = nil

local function createSilentAimCircle()
    if not Drawing then return end
    if SilentAimCircle then SilentAimCircle:Remove() end
    SilentAimCircle = Drawing.new("Circle")
    SilentAimCircle.Visible = false
    SilentAimCircle.Thickness = 2
    SilentAimCircle.NumSides = 60
    SilentAimCircle.Radius = SilentAimSpear.FOV
    SilentAimCircle.Filled = false
    SilentAimCircle.Color = Color3.fromRGB(150, 0, 255)
    SilentAimCircle.Transparency = 0.6
end
createSilentAimCircle()

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
                local hrp = p.Character:FindFirstChild(SilentAimSpear.AimPart) or p.Character:FindFirstChild("HumanoidRootPart")
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
        if SilentAimCircle then
            SilentAimCircle.Visible = SilentAimSpear.Enabled and SilentAimSpear.ShowFOV
            SilentAimCircle.Radius = SilentAimSpear.FOV
            SilentAimCircle.Position = Vector2.new(
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

-- ─── INPUT DETECTION ──────────────────────────
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = true
        KillerAimbot.Holding = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = false
        KillerAimbot.Holding = false
    end
end)

print("[TIARHUB] Part 4/10 loaded.")-- ═══════════════════════════════════════════
--  KILLER SYSTEM
-- ═══════════════════════════════════════════

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
    if StalkConnection then return end
    StalkConnection = RunService.Heartbeat:Connect(function()
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
    if StalkConnection then StalkConnection:Disconnect(); StalkConnection = nil end
end

RunService.Heartbeat:Connect(function()
    pcall(function()
        if not getRoot() then return end

        if Killer.AutoAttack and AttackEvent then
            pcall(function() AttackEvent:FireServer(false) end)
            if HitMarker.Enabled and math.random(1,3) == 1 then triggerHitMarker() end
        end

        if Killer.AutoHookAllDowned and HookEvent and not KillerBusy then
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

        if Killer.AutoCarry and not KillerBusy and CarryEvent then
            KillerBusy = true
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
                KillerBusy = false
            end)
        end

        if Killer.KillAll and AttackEvent then
            local root = getRoot()
            if root then
                if not KillerTarget or not KillerTarget:FindFirstChild("Humanoid") or KillerTarget.Humanoid.Health <= 35 then
                    KillerTarget = GetNearestAliveSurvivor()
                end
                if KillerTarget then
                    local targetHRP = KillerTarget:FindFirstChild("HumanoidRootPart")
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
                            if HitMarker.Enabled then triggerHitMarker() end
                        end
                    end
                end
            end
        end

        if ChaseDetector.Enabled then
            local now = tick()
            if now - ChaseDetector.LastNotify > ChaseDetector.Cooldown then
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
                    if closest and dist <= ChaseDetector.Range then
                        ChaseDetector.LastNotify = now
                        Library:Notify({ Title = "Chase Alert", Description = string.format("Survivor dalam %.0f stud!", dist), Time = 2 })
                    end
                end
            end
        end
    end)
end)

-- ═══════════════════════════════════════════
--  FAST VAULT
-- ═══════════════════════════════════════════

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
            if not FastVault.Enabled then return end
            local anim = track.Animation
            if not anim or not anim.AnimationId then return end
            local id = normalizeId(anim.AnimationId)
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
            newTrack.Stopped:Connect(function() VaultTracks[track] = nil end)
        end)
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5); pcall(function() hookVault(char) end)
end)
if LocalPlayer.Character then pcall(function() hookVault(LocalPlayer.Character) end) end

-- ═══════════════════════════════════════════
--  WALKSPEED & NOCLIP
-- ═══════════════════════════════════════════

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

-- ═══════════════════════════════════════════
--  MOONWALK (2 MODE)
-- ═══════════════════════════════════════════

local function applyMoonwalkFOV()
    local cam = workspace.CurrentCamera
    if not cam then return end
    if Moonwalk.Enabled then
        cam.FieldOfView = Moonwalk.FOVPreset
    end
end

local function startMoonwalk()
    if MoonwalkConnection then return end
    local hum0 = getHum()
    if hum0 then hum0.AutoRotate = false end

    MoonwalkConnection = RunService.RenderStepped:Connect(function()
        if not Moonwalk.Enabled or ParryActive or isDowned() then return end
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

    if MoonwalkHeartbeat then MoonwalkHeartbeat:Disconnect() end
    MoonwalkHeartbeat = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not Moonwalk.Enabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.AutoRotate = false end
        end)
    end)
end

local function stopMoonwalk()
    if MoonwalkConnection then MoonwalkConnection:Disconnect(); MoonwalkConnection = nil end
    if MoonwalkHeartbeat then MoonwalkHeartbeat:Disconnect(); MoonwalkHeartbeat = nil end
    local hum = getHum()
    if hum then
        hum.AutoRotate = true
        if Movement.WalkSpeedEnabled then hum.WalkSpeed = Movement.WalkSpeedValue
        else hum.WalkSpeed = Movement.OriginalWalkSpeed end
    end
    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = 70 end
end

local function createMoonwalkButton()
    pcall(function()
        if MoonwalkButton then MoonwalkButton:Destroy() end
        local gui = Instance.new("ScreenGui")
        gui.Name = "MoonwalkGui"
        gui.ResetOnSpawn = false
        gui.Parent = PlayerGui
        local btn = Instance.new("ImageButton")
        btn.Size = UDim2.new(0, 50, 0, 50)
        btn.Position = UDim2.new(0.65, 0, 0.75, 0)
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.9
        btn.Parent = gui
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
        local stroke = Instance.new("UIStroke")
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Thickness = 1.2
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Transparency = 0.8
        stroke.Parent = btn
        btn.MouseButton1Click:Connect(function()
            Moonwalk.Enabled = not Moonwalk.Enabled
            if Moonwalk.Enabled then
                stroke.Color = Color3.fromRGB(170, 0, 255)
                if not MoonwalkConnection then startMoonwalk() end
                applyMoonwalkFOV()
            else
                stroke.Color = Color3.fromRGB(255, 255, 255)
                stopMoonwalk()
            end
        end)
        MoonwalkButton = gui
    end)
end

local function removeMoonwalkButton()
    if MoonwalkButton then MoonwalkButton:Destroy(); MoonwalkButton = nil end
end

-- ═══════════════════════════════════════════
--  CROSSHAIR
-- ═══════════════════════════════════════════

local function updateCrosshair()
    pcall(function()
        if not Crosshair.Enabled then
            if CrosshairGui then CrosshairGui.Enabled = false end
            return
        end
        if not CrosshairGui then
            CrosshairGui = Instance.new("ScreenGui")
            CrosshairGui.Name = "TiarCrosshair"
            CrosshairGui.ResetOnSpawn = false
            CrosshairGui.IgnoreGuiInset = true
            CrosshairGui.Parent = PlayerGui
            local h = Instance.new("Frame"); h.Name = "H"
            h.AnchorPoint = Vector2.new(0.5, 0.5); h.BorderSizePixel = 0; h.Parent = CrosshairGui
            local v = Instance.new("Frame"); v.Name = "V"
            v.AnchorPoint = Vector2.new(0.5, 0.5); v.BorderSizePixel = 0; v.Parent = CrosshairGui
        end
        CrosshairGui.Enabled = true
        local h = CrosshairGui:FindFirstChild("H")
        local v = CrosshairGui:FindFirstChild("V")
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
RunService.Heartbeat:Connect(function() pcall(function() AutoWiggle() end) end)

local function playEmote(name)
    if EmoteRemote then pcall(function() EmoteRemote:FireServer(name) end) end
end

local function activateMasked()
    local event = findRemote("Remotes.Killers.Masked.Activatepower")
    if event then pcall(function() event:FireServer(Masked.CurrentPower) end) end
end
local function deactivateMasked()
    local event = findRemote("Remotes.Killers.Masked.Deactivatepower")
    if event then pcall(function() event:FireServer() end) end
end

print("[TIARHUB] Part 5/10 loaded.")-- ═══════════════════════════════════════════
--  COPY AVATAR
-- ═══════════════════════════════════════════

local function saveOriginalAppearance()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local ok, desc = pcall(function() return hum:GetAppliedDescription() end)
    if ok and desc then
        AvatarCopier.OriginalDescription = desc
        return true
    end
    return false
end

local function copyAvatar(username)
    if not username or username == "" then
        Library:Notify({ Title = "Copy Avatar", Description = "Username kosong!", Time = 3 })
        return false
    end
    saveOriginalAppearance()

    local ok, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    if not ok or not userId then
        Library:Notify({ Title = "Copy Avatar", Description = "User '" .. username .. "' tidak ditemukan!", Time = 3 })
        return false
    end

    AvatarCopier.CurrentCopiedUserId = userId
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    task.spawn(function()
        local okDesc, desc = pcall(function()
            return Players:GetHumanoidDescriptionFromUserId(userId)
        end)
        if not okDesc or not desc then
            Library:Notify({ Title = "Copy Avatar", Description = "Gagal ambil deskripsi!", Time = 3 })
            return
        end

        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
                pcall(function() v:Destroy() end)
            end
        end
        task.wait(0.2)

        if AvatarCopier.BlockyBody then
            pcall(function()
                local bd = Instance.new("HumanoidDescription")
                bd.BodyTypeScale = 1; bd.DepthScale = 1; bd.HeadScale = 1
                bd.HeightScale = 1; bd.ProportionScale = 0; bd.WidthScale = 1
                bd.HeadColor = desc.HeadColor; bd.TorsoColor = desc.TorsoColor
                bd.LeftArmColor = desc.LeftArmColor; bd.RightArmColor = desc.RightArmColor
                bd.LeftLegColor = desc.LeftLegColor; bd.RightLegColor = desc.RightLegColor
                hum:ApplyDescriptionClientServer(bd)
            end)
            task.wait(0.5)
        end

        pcall(function() hum:ApplyDescriptionClientServer(desc) end)
        Library:Notify({ Title = "Copy Avatar", Description = "Copy: " .. username .. " OK", Time = 3 })
    end)
    return true
end

local function resetAvatar()
    if not AvatarCopier.OriginalDescription then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
            pcall(function() v:Destroy() end)
        end
    end
    task.wait(0.1)
    pcall(function() hum:ApplyDescriptionClientServer(AvatarCopier.OriginalDescription) end)
    AvatarCopier.CurrentCopiedUserId = nil
    Library:Notify({ Title = "Reset Avatar", Description = "Avatar original balik!", Time = 3 })
end

-- ═══════════════════════════════════════════
--  VISUAL
-- ═══════════════════════════════════════════

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
    end)
end

local function toggleScreenEffects()
    pcall(function()
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") then v.Enabled = not Visual.NoBloom end
            if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") then v.Enabled = not Visual.NoBlur end
        end
    end)
end

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

RunService.Heartbeat:Connect(function()
    pcall(function() 
        applyVisual()
        toggleScreenEffects()
        applyColorCorrection()
        if Moonwalk.Enabled then applyMoonwalkFOV() end
    end)
end)

-- ═══════════════════════════════════════════
--  HIDE RED SPARK
-- ═══════════════════════════════════════════

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
    HiddenSparkCache = {}
end

-- ═══════════════════════════════════════════
--  TELEPORT SYSTEM
-- ═══════════════════════════════════════════

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
    if now - Teleport.LastTeleport < Teleport.Cooldown then return false end
    Teleport.LastTeleport = now
    local root = getRoot()
    if not root then return false end
    local pos = GetPos(obj)
    if not pos then return false end
    pcall(function() root.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0)) end)
    return true
end

local function teleportToGenerator() return teleportTo(findNearestByNames({"Generator", "GeneratorPoint"})) end
local function teleportToGate() return teleportTo(findNearestByNames({"Gate", "Exit", "ExitGate", "fininshline", "FinishLine"})) end
local function teleportToWindow() return teleportTo(findNearestByNames({"Window"})) end
local function teleportToPallet() return teleportTo(findNearestByNames({"Pallet", "Palletwrong"})) end
local function teleportToHook() return teleportTo(findNearestByNames({"HookPoint", "Hook"})) end

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

-- ═══════════════════════════════════════════
--  ANTI-LAG
-- ═══════════════════════════════════════════

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
    if AntiLag.NoParticles then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                pcall(function() v.Enabled = false end)
            end
        end
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                pcall(function() v.Enabled = true end)
            end
        end
    end
    if AntiLag.NoTextures then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then pcall(function() v.Transparency = 1 end) end
        end
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then pcall(function() v.Transparency = 0 end) end
        end
    end
end

local AntiLagConnection = nil
local function startAntiLag()
    if AntiLagConnection then AntiLagConnection:Disconnect() end
    AntiLagConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not AntiLag.Enabled then return end
            if AntiLag.NoParticles then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                        if v.Enabled then v.Enabled = false end
                    end
                end
            end
            if AntiLag.NoTextures then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Texture") or v:IsA("Decal") then
                        if v.Transparency ~= 1 then v.Transparency = 1 end
                    end
                end
            end
        end)
    end)
end

startAntiLag()

-- ═══════════════════════════════════════════
--  HIT MARKER LINES
-- ═══════════════════════════════════════════

local function createHitMarkerLines()
    if not Drawing then return end
    for _, v in pairs(HitMarkerLines) do pcall(function() v:Remove() end) end
    HitMarkerLines = {}
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = HitMarker.Thickness
        line.Color = HitMarker.Color
        table.insert(HitMarkerLines, line)
    end
end

function triggerHitMarker()
    HitMarkerActive = true
    HitMarkerEnd = tick() + HitMarker.Duration
    if #HitMarkerLines == 0 then createHitMarkerLines() end
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        if not Drawing then return end
        if not HitMarker.Enabled then
            for _, v in pairs(HitMarkerLines) do v.Visible = false end
            return
        end
        if not HitMarkerActive or tick() > HitMarkerEnd then
            HitMarkerActive = false
            for _, v in pairs(HitMarkerLines) do v.Visible = false end
            return
        end
        if #HitMarkerLines == 0 then createHitMarkerLines() end
        local cam = workspace.CurrentCamera
        local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        local s = HitMarker.Size
        local t = HitMarker.Thickness
        for _, v in pairs(HitMarkerLines) do
            v.Thickness = t
            v.Color = HitMarker.Color
            v.Visible = true
        end
        HitMarkerLines[1].From = center + Vector2.new(-s, -s)
        HitMarkerLines[1].To   = center + Vector2.new(-s/2, -s/2)
        HitMarkerLines[2].From = center + Vector2.new(s, -s)
        HitMarkerLines[2].To   = center + Vector2.new(s/2, -s/2)
        HitMarkerLines[3].From = center + Vector2.new(-s, s)
        HitMarkerLines[3].To   = center + Vector2.new(-s/2, s/2)
        HitMarkerLines[4].From = center + Vector2.new(s, s)
        HitMarkerLines[4].To   = center + Vector2.new(s/2, s/2)
    end)
end)

print("[TIARHUB] Part 6/10 loaded.")-- ═══════════════════════════════════════════
--  TAB 1 : COMBAT
-- ═══════════════════════════════════════════

local CombatLeft  = Tabs.Combat:AddLeftGroupbox("Auto Parry", "shield")
local CombatRight = Tabs.Combat:AddRightGroupbox("Parry Config", "sliders")

CombatLeft:AddToggle("AutoParry", {
    Text = "Auto Parry",
    Default = false,
    Tooltip = "Otomatis memparry serangan musuh",
    Callback = function(v) Auto.Parry = v end,
}):AddKeybind({ Text = "Keybind", Default = Enum.KeyCode.Q })

CombatLeft:AddDropdown("ParryMode", {
    Text = "Parry Mode",
    Values = {"Safety", "Aggressive"},
    Default = "Safety",
    Multi = false,
    Callback = function(v) 
        Auto.ParryMode = v
        applyParryPreset(v)
        Library:Notify({ Title = "Parry Mode", Description = "Mode: " .. v, Time = 3 })
    end,
})

CombatLeft:AddSlider("ParryRange", {
    Text = "Detection Range",
    Default = 12, Min = 5, Max = 50,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) Auto.ParryDistance = v end,
})

CombatLeft:AddSlider("ParryFace", {
    Text = "Face Sensitivity",
    Default = 0.5, Min = -1, Max = 1,
    Rounding = 2,
    Callback = function(v) Auto.FaceSensitivity = v end,
})

CombatRight:AddToggle("ShowRange", {
    Text = "Show Parry Range",
    Default = false,
    Callback = function(v) ParryRangeVisual.Enabled = v end,
})

CombatRight:AddToggle("ParryRainbow", {
    Text = "Rainbow Parry Circle",
    Default = false,
    Callback = function(v) ParryRangeVisual.RainbowMode = v end,
})

CombatRight:AddToggle("ParryPulse", {
    Text = "Pulse Effect",
    Default = true,
    Callback = function(v) ParryRangeVisual.PulseEnabled = v end,
})

CombatRight:AddColorPicker("RangeColor", {
    Text = "Range Color",
    Default = Color3.fromRGB(255, 80, 80),
    Transparency = 0.3,
    Callback = function(c) ParryRangeVisual.Color = c end,
})

CombatRight:AddSlider("RangeTransparency", {
    Text = "Range Transparency",
    Default = 0.7, Min = 0, Max = 1,
    Rounding = 2,
    Callback = function(v) ParryRangeVisual.Transparency = v end,
})

-- ─── Skill Check ──────────────────────────────
local SkillGroup = Tabs.Combat:AddLeftGroupbox("Auto Skill Check", "zap")

SkillGroup:AddToggle("AutoSkillCheck", {
    Text = "Auto Skill Check",
    Default = false,
    Callback = function(v)
        Auto.SkillCheck = v
        if v then startSkillCheck() end
    end,
})

SkillGroup:AddDropdown("SkillCheckMode", {
    Text = "Mode",
    Values = {"Instant", "Perfect"},
    Default = "Perfect",
    Multi = false,
    Callback = function(v)
        SkillCheckMode = v
        Library:Notify({ Title = "Skill Check", Description = "Mode: " .. v, Time = 3 })
    end,
})

-- ─── Fake Perks ───────────────────────────────
local FakePerksBox = Tabs.Combat:AddRightGroupbox("Fake Perks (All in One)", "star")

FakePerksBox:AddToggle("FakeFlowstate", {
    Text = "Fake Flowstate",
    Default = false,
    Tooltip = "Speed boost saat vault",
    Callback = function(v) FakePerks.Flowstate.Enabled = v end,
})

FakePerksBox:AddSlider("FlowstateCooldown", {
    Text = "Flowstate Cooldown",
    Default = 60, Min = 0, Max = 120,
    Rounding = 0, Suffix = "s",
    Callback = function(v) FakePerks.Flowstate.Cooldown = v end,
})

FakePerksBox:AddToggle("FakeSnakeStep", {
    Text = "Fake Snake Step",
    Default = false,
    Tooltip = "Speed boost saat crouch",
    Callback = function(v) FakePerks.SnakeStep.Enabled = v end,
})

FakePerksBox:AddSlider("SnakeStepCooldown", {
    Text = "Snake Step Cooldown",
    Default = 30, Min = 0, Max = 120,
    Rounding = 0, Suffix = "s",
    Callback = function(v) FakePerks.SnakeStep.Cooldown = v end,
})

FakePerksBox:AddToggle("FakeQuickRecovery", {
    Text = "Fake Quick Recovery",
    Default = false,
    Callback = function(v) FakePerks.QuickRecovery.Enabled = v end,
})

FakePerksBox:AddSlider("QuickRecoveryCooldown", {
    Text = "Quick Recovery Cooldown",
    Default = 60, Min = 0, Max = 120,
    Rounding = 0, Suffix = "s",
    Callback = function(v) FakePerks.QuickRecovery.Cooldown = v end,
})

FakePerksBox:AddToggle("FakePerfectLanding", {
    Text = "Fake Perfect Landing",
    Default = false,
    Callback = function(v) FakePerks.PerfectLanding.Enabled = v end,
})

FakePerksBox:AddSlider("PerfectLandingCooldown", {
    Text = "Perfect Landing Cooldown",
    Default = 90, Min = 0, Max = 120,
    Rounding = 0, Suffix = "s",
    Callback = function(v) FakePerks.PerfectLanding.Cooldown = v end,
})

-- ─── Auto Dodge & Wiggle & Flee ────────────────
local DodgeBox = Tabs.Combat:AddLeftGroupbox("Auto Dodge & Extra", "move")

DodgeBox:AddToggle("AutoDodgeAbyss", {
    Text = "Auto Dodge Abyss",
    Default = false,
    Tooltip = "Auto crouch kalau ada Abyss deket",
    Callback = function(v) AutoDodgeAbyss.Enabled = v end,
})

DodgeBox:AddSlider("AbyssRange", {
    Text = "Detect Range",
    Default = 18, Min = 5, Max = 50,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) AutoDodgeAbyss.DetectRange = v end,
})

DodgeBox:AddSlider("AbyssCooldown", {
    Text = "Cooldown",
    Default = 0.5, Min = 0.1, Max = 3,
    Rounding = 2, Suffix = "s",
    Callback = function(v) AutoDodgeAbyss.Cooldown = v end,
})

DodgeBox:AddToggle("AutoWiggle", {
    Text = "Auto Wiggle",
    Default = false,
    Callback = function(v) Auto.Wiggle = v end,
})

DodgeBox:AddSlider("WiggleSpam", {
    Text = "Wiggle Spam",
    Default = 5, Min = 1, Max = 10,
    Rounding = 0, Suffix = "x",
    Callback = function(v) Auto.WiggleSpam = v end,
})

DodgeBox:AddToggle("AutoFlee", {
    Text = "Auto Flee Killer",
    Default = false,
    Callback = function(v) AutoFlee.Enabled = v end,
})

DodgeBox:AddSlider("FleeDistance", {
    Text = "Flee Detect Distance",
    Default = 50, Min = 10, Max = 200,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) AutoFlee.DetectDistance = v end,
})

-- ═══════════════════════════════════════════
--  TAB 2 : AIMLOCK
-- ═══════════════════════════════════════════

local AimlockLeft  = Tabs.Aimlock:AddLeftGroupbox("Aimbot Pistol (Survivor)", "crosshair")
local AimlockRight = Tabs.Aimlock:AddRightGroupbox("Aimbot Killer", "skull")
local AimlockBtn   = Tabs.Aimlock:AddLeftGroupbox("Aimlock Button", "target")

-- ─── AIMBOT PISTOL ────────────────────────────
AimlockLeft:AddToggle("GunAim", {
    Text = "Aimbot Pistol (Hold RMB)",
    Default = false,
    Callback = function(v) GunAim.Enabled = v end,
})

AimlockLeft:AddToggle("GunAimFOVCircle", {
    Text = "Show FOV Circle",
    Default = false,
    Callback = function(v) 
        FOVCircleVisible = v
        if v and not FOVCircle then createFOVCircle() end
    end,
})

AimlockLeft:AddToggle("GunAimTracer", {
    Text = "Show Tracer",
    Default = false,
    Callback = function(v) 
        GunAim.ShowTracer = v
        if v and not TracerLine then createTracer() end
    end,
})

AimlockLeft:AddDropdown("GunAimTarget", {
    Text = "Target",
    Values = {"Killer", "Survivor", "Both"},
    Default = "Killer",
    Multi = false,
    Callback = function(v) GunAim.TargetMode = v end,
})

AimlockLeft:AddDropdown("GunAimPart", {
    Text = "Aim Part",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Default = "HumanoidRootPart",
    Multi = false,
    Callback = function(v) GunAim.AimPart = v end,
})

AimlockLeft:AddSlider("GunAimFOV", {
    Text = "FOV",
    Default = 250, Min = 50, Max = 1000,
    Rounding = 0,
    Callback = function(v) GunAim.FOV = v end,
})

AimlockLeft:AddSlider("GunAimSmooth", {
    Text = "Smoothness",
    Default = 1, Min = 0.1, Max = 1,
    Rounding = 2,
    Callback = function(v) GunAim.Strength = v end,
})

AimlockLeft:AddSlider("GunAimPredict", {
    Text = "Prediction",
    Default = 0.12, Min = 0, Max = 1,
    Rounding = 2,
    Callback = function(v) GunAim.PredictStrength = v end,
})

AimlockLeft:AddToggle("GunAimVisCheck", {
    Text = "Visibility Check",
    Default = false,
    Callback = function(v) GunAim.VisibilityCheck = v end,
})

AimlockLeft:AddColorPicker("GunAimTracerColor", {
    Text = "Tracer Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(c) 
        GunAim.TracerColor = c
        if TracerLine then TracerLine.Color = c end
    end,
})

-- ─── AIMBOT KILLER ────────────────────────────
AimlockRight:AddToggle("KillerAimbot", {
    Text = "Aimbot Killer (Hold RMB)",
    Default = false,
    Callback = function(v) KillerAimbot.Enabled = v end,
})

AimlockRight:AddToggle("KillerAimbotFOV", {
    Text = "Show FOV Circle",
    Default = false,
    Callback = function(v) KillerAimbot.ShowFOV = v end,
})

AimlockRight:AddToggle("KillerAimbotTracer", {
    Text = "Show Tracer",
    Default = false,
    Callback = function(v) KillerAimbot.ShowTracer = v end,
})

AimlockRight:AddDropdown("KillerAimbotPart", {
    Text = "Aim Part",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Default = "HumanoidRootPart",
    Multi = false,
    Callback = function(v) KillerAimbot.AimPart = v end,
})

AimlockRight:AddSlider("KillerAimbotFOVVal", {
    Text = "FOV",
    Default = 200, Min = 50, Max = 1000,
    Rounding = 0,
    Callback = function(v) KillerAimbot.FOV = v end,
})

AimlockRight:AddSlider("KillerAimbotSmooth", {
    Text = "Smoothness",
    Default = 0.5, Min = 0.1, Max = 1,
    Rounding = 2,
    Callback = function(v) KillerAimbot.Strength = v end,
})

AimlockRight:AddSlider("KillerAimbotPredict", {
    Text = "Prediction",
    Default = 0.12, Min = 0, Max = 1,
    Rounding = 2,
    Callback = function(v) KillerAimbot.PredictStrength = v end,
})

AimlockRight:AddColorPicker("KillerAimbotTracerColor", {
    Text = "Tracer Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(c) KillerAimbot.TracerColor = c end,
})

-- ─── AIMLOCK BUTTON ────────────────────────────
AimlockBtn:AddToggle("ShowAimlockButton", {
    Text = "Show Aimlock Button",
    Default = false,
    Callback = function(v)
        if v then createAimlockBtn() else removeAimlockBtn() end
    end,
})

AimlockBtn:AddSlider("LockRadius", {
    Text = "Lock Radius",
    Default = 100, Min = 20, Max = 500,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) Aimlock.LockRadius = v end,
})

AimlockBtn:AddSlider("FOVRadius", {
    Text = "FOV Circle Radius",
    Default = 300, Min = 50, Max = 800,
    Rounding = 0, Suffix = "px",
    Callback = function(v) Aimlock.FOVRadius = v end,
})

AimlockBtn:AddSlider("AimlockSmooth", {
    Text = "Smoothness",
    Default = 0.4, Min = 0.1, Max = 1,
    Rounding = 2,
    Callback = function(v) Aimlock.Smoothness = v end,
})

AimlockBtn:AddToggle("ShowAimlockFOV", {
    Text = "Show FOV Circle",
    Default = true,
    Callback = function(v) Aimlock.ShowFOVCircle = v end,
})

-- ─── SILENT AIM ──────────────────────────────
local SilentAimBox = Tabs.Aimlock:AddRightGroupbox("Silent Aim Veil Spear", "target")

SilentAimBox:AddToggle("SilentAim", {
    Text = "Enable Silent Aim",
    Default = false,
    Tooltip = "Aktif otomatis saat Veil Spear equipped",
    Callback = function(v) SilentAimSpear.Enabled = v end,
})

SilentAimBox:AddToggle("SilentAimFOVCircle", {
    Text = "Show FOV",
    Default = false,
    Callback = function(v) SilentAimSpear.ShowFOV = v end,
})

SilentAimBox:AddDropdown("SilentAimTarget", {
    Text = "Target",
    Values = {"Killer", "Survivor", "Both"},
    Default = "Killer",
    Multi = false,
    Callback = function(v) SilentAimSpear.TargetMode = v end,
})

SilentAimBox:AddDropdown("SilentAimPart", {
    Text = "Aim Part",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Default = "HumanoidRootPart",
    Multi = false,
    Callback = function(v) SilentAimSpear.AimPart = v end,
})

SilentAimBox:AddSlider("SilentAimFOV", {
    Text = "FOV",
    Default = 250, Min = 50, Max = 1000,
    Rounding = 0,
    Callback = function(v) SilentAimSpear.FOV = v end,
})

SilentAimBox:AddSlider("SilentAimPredict", {
    Text = "Prediction",
    Default = 0.12, Min = 0, Max = 1,
    Rounding = 2,
    Callback = function(v) SilentAimSpear.Prediction = v end,
})

print("[TIARHUB] Part 7/10 loaded.")-- ═══════════════════════════════════════════
--  TAB 3 : KILLER
-- ═══════════════════════════════════════════

local KillerLeft  = Tabs.Killer:AddLeftGroupbox("Attack", "sword")
local KillerRight = Tabs.Killer:AddRightGroupbox("Carry & Stalk", "skull")
local KillerMasked = Tabs.Killer:AddLeftGroupbox("Masked Power", "sparkles")
local KillerHitMarker = Tabs.Killer:AddRightGroupbox("Hit Marker", "crosshair")

-- ─── ATTACK ──────────────────────────────────
KillerLeft:AddToggle("AutoAttack", {
    Text = "Auto Attack",
    Default = false,
    Callback = function(v) Killer.AutoAttack = v end,
})

KillerLeft:AddToggle("AutoKillAll", {
    Text = "Auto Kill All",
    Default = false,
    Callback = function(v) Killer.KillAll = v end,
})

KillerLeft:AddToggle("PredictionAttack", {
    Text = "Prediction Attack",
    Default = false,
    Callback = function(v) Killer.PredictionAttack = v end,
})

KillerLeft:AddSlider("KillPredictStr", {
    Text = "Prediction Strength",
    Default = 0.15, Min = 0, Max = 1,
    Rounding = 2,
    Callback = function(v) Killer.PredictStrength = v end,
})

KillerLeft:AddToggle("AutoSprint", {
    Text = "Auto Sprint (deket survivor)",
    Default = false,
    Callback = function(v) Killer.AutoSprint = v end,
})

KillerLeft:AddSlider("AutoSprintVal", {
    Text = "Sprint Speed",
    Default = 30, Min = 16, Max = 100,
    Rounding = 0,
    Callback = function(v) Killer.AutoSprintValue = v end,
})

KillerLeft:AddToggle("AutoFaceTarget", {
    Text = "Auto Face Survivor",
    Default = false,
    Callback = function(v) Killer.AutoFaceTarget = v end,
})

KillerLeft:AddSlider("FaceRange", {
    Text = "Face Range",
    Default = 20, Min = 5, Max = 100,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) Killer.AutoFaceRange = v end,
})

-- ─── CARRY & STALK ────────────────────────────
KillerRight:AddToggle("AutoCarry", {
    Text = "Auto Carry Downed",
    Default = false,
    Callback = function(v) Killer.AutoCarry = v end,
})

KillerRight:AddToggle("AutoHook", {
    Text = "Auto Hook After Carry",
    Default = false,
    Callback = function(v) Killer.AutoHook = v end,
})

KillerRight:AddToggle("AutoHookAllDowned", {
    Text = "Auto Hook All Downed",
    Default = false,
    Callback = function(v) Killer.AutoHookAllDowned = v end,
})

KillerRight:AddSlider("HookAllRange", {
    Text = "Hook All Range",
    Default = 500, Min = 100, Max = 2000,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) Killer.AutoHookAllRange = v end,
})

KillerRight:AddToggle("AutoStalk", {
    Text = "Auto Stalk",
    Default = false,
    Callback = function(v) 
        Killer.AutoStalk = v
        if v then startAutoStalk() else stopAutoStalk() end
    end,
})

KillerRight:AddSlider("StalkRange", {
    Text = "Stalk Range",
    Default = 150, Min = 50, Max = 500,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) Killer.StalkRange = v end,
})

KillerRight:AddToggle("ChaseAlert", {
    Text = "Chase Alert",
    Default = false,
    Callback = function(v) ChaseDetector.Enabled = v end,
})

KillerRight:AddSlider("ChaseRange", {
    Text = "Chase Range",
    Default = 30, Min = 10, Max = 200,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) ChaseDetector.Range = v end,
})

-- ─── MASKED POWER ─────────────────────────────
KillerMasked:AddDropdown("MaskedPower", {
    Text = "Select Power",
    Values = MaskedPowers,
    Default = "Cobra",
    Multi = false,
    Searchable = true,
    Callback = function(v) Masked.CurrentPower = v end,
})

KillerMasked:AddButton({
    Text = "Activate Power",
    Func = function() activateMasked() end,
})

KillerMasked:AddButton({
    Text = "Deactivate Power",
    Func = function() deactivateMasked() end,
})

-- ─── HIT MARKER ───────────────────────────────
KillerHitMarker:AddToggle("HitMarkerOn", {
    Text = "Enable Hit Marker",
    Default = false,
    Callback = function(v) 
        HitMarker.Enabled = v
        if v and #HitMarkerLines == 0 then createHitMarkerLines() end
    end,
})

KillerHitMarker:AddColorPicker("HitMarkerColor", {
    Text = "Hit Marker Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(c) HitMarker.Color = c end,
})

KillerHitMarker:AddSlider("HitMarkerSize", {
    Text = "Size",
    Default = 20, Min = 5, Max = 50,
    Rounding = 0, Suffix = "px",
    Callback = function(v) HitMarker.Size = v end,
})

KillerHitMarker:AddSlider("HitMarkerThickness", {
    Text = "Thickness",
    Default = 2, Min = 1, Max = 5,
    Rounding = 0, Suffix = "px",
    Callback = function(v) HitMarker.Thickness = v end,
})

-- ═══════════════════════════════════════════
--  TAB 4 : VISUALS
-- ═══════════════════════════════════════════

local ESPLeft  = Tabs.Visuals:AddLeftGroupbox("ESP - Player", "eye")
local ESPRight = Tabs.Visuals:AddRightGroupbox("ESP - Map", "map")
local ESPStatusBox = Tabs.Visuals:AddLeftGroupbox("ESP - Status", "user")
local WarningBox = Tabs.Visuals:AddRightGroupbox("Killer Warning", "alert-triangle")
local VisBox = Tabs.Visuals:AddLeftGroupbox("Visual", "sun")
local SparkBox = Tabs.Visuals:AddRightGroupbox("Effect", "sparkles")

-- ─── ESP PLAYER ───────────────────────────────
ESPL

:AddToggle("ESPSurvivor", {
    Text = "ESP Survivor",
    Default = false,
    Callback = function(v) ESP.Survivor = v end,
})

ESPL:AddColorPicker("ESPSurvivorColor", {
    Text = "Survivor Color",
    Default = ESP.SurvivorColor,
    Callback = function(c) ESP.SurvivorColor = c end,
})

ESPL:AddToggle("ESPKiller", {
    Text = "ESP Killer",
    Default = false,
    Callback = function(v) ESP.Killer = v end,
})

ESPL:AddColorPicker("ESPKillerColor", {
    Text = "Killer Color",
    Default = ESP.KillerColor,
    Callback = function(c) ESP.KillerColor = c end,
})

-- ─── ESP MAP ──────────────────────────────────
ESPRight:AddToggle("ESPGenerator", {
    Text = "ESP Generator (%)",
    Default = false,
    Callback = function(v) ESP.Generator = v end,
})

ESPRight:AddColorPicker("ESPGenColor", {
    Text = "Generator Color",
    Default = ESP.GeneratorColor,
    Callback = function(c) ESP.GeneratorColor = c end,
})

ESPRight:AddToggle("ESPHook", {
    Text = "ESP Hook",
    Default = false,
    Callback = function(v) ESP.Hook = v end,
})

ESPRight:AddToggle("ESPPallet", {
    Text = "ESP Pallet",
    Default = false,
    Callback = function(v) ESP.Pallet = v end,
})

ESPRight:AddToggle("ESPWindow", {
    Text = "ESP Window",
    Default = false,
    Callback = function(v) ESP.Window = v end,
})

ESPRight:AddToggle("ESPSCP", {
    Text = "ESP SCP",
    Default = false,
    Callback = function(v) ESP.SCP = v end,
})

ESPRight:AddSlider("ESPDistance", {
    Text = "ESP Radius",
    Default = 300, Min = 50, Max = 2000,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) ESP.Distance = v end,
})

ESPRight:AddDropdown("ESPMode", {
    Text = "ESP Mode",
    Values = {"Highlight", "Outline", "Fill"},
    Default = "Highlight",
    Multi = false,
    Callback = function(v) ESP.Mode = v end,
})

ESPRight:AddToggle("ESPShowName", {
    Text = "Show Name Tag",
    Default = true,
    Callback = function(v) ESP.ShowName = v end,
})

-- ─── ESP STATUS ───────────────────────────────
ESPStatusBox:AddToggle("ESPStatusOn", {
    Text = "Enable Status ESP",
    Default = false,
    Callback = function(v) ESPStatus.Enabled = v end,
})

ESPStatusBox:AddToggle("ESPStatusName", {
    Text = "Show Name",
    Default = true,
    Callback = function(v) ESPStatus.ShowName = v end,
})

ESPStatusBox:AddToggle("ESPStatusDistance", {
    Text = "Show Distance",
    Default = true,
    Callback = function(v) ESPStatus.ShowDistance = v end,
})

ESPStatusBox:AddToggle("ESPStatusHealth", {
    Text = "Show Health",
    Default = false,
    Callback = function(v) ESPStatus.ShowHealth = v end,
})

-- ─── KILLER WARNING ───────────────────────────
WarningBox:AddToggle("KillerWarning", {
    Text = "Killer Warning",
    Default = false,
    Callback = function(v) KillerWarning.Enabled = v end,
})

WarningBox:AddColorPicker("WarningColor", {
    Text = "Warning Color",
    Default = KillerWarning.Color,
    Callback = function(c) KillerWarning.Color = c end,
})

WarningBox:AddSlider("WarningDistance", {
    Text = "Warning Distance",
    Default = 60, Min = 20, Max = 200,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) KillerWarning.Distance = v end,
})

-- ─── VISUAL ───────────────────────────────────
VisBox:AddToggle("Fullbright", {
    Text = "Fullbright",
    Default = false,
    Callback = function(v) 
        Visual.Fullbright = v
        applyVisual(true)
    end,
})

VisBox:AddToggle("NoFog", {
    Text = "No Fog",
    Default = false,
    Callback = function(v) 
        Visual.NoFog = v
        applyVisual(true)
    end,
})

VisBox:AddToggle("NoShadow", {
    Text = "No Shadow",
    Default = false,
    Callback = function(v) 
        Visual.NoShadow = v
        applyVisual(true)
    end,
})

VisBox:AddToggle("NoBloom", {
    Text = "No Bloom",
    Default = false,
    Callback = function(v) 
        Visual.NoBloom = v
        toggleScreenEffects()
    end,
})

VisBox:AddToggle("NoBlur", {
    Text = "No Blur / DOF",
    Default = false,
    Callback = function(v) 
        Visual.NoBlur = v
        toggleScreenEffects()
    end,
})

-- ─── COLOR CORRECTION ─────────────────────────
local ColorCorrBox = Tabs.Visuals:AddRightGroupbox("Color Correction", "palette")

ColorCorrBox:AddToggle("ColorCorrOn", {
    Text = "Enable Color Correction",
    Default = false,
    Callback = function(v) 
        Visual.ColorCorrection = v
        applyColorCorrection()
    end,
})

ColorCorrBox:AddSlider("ColorSaturation", {
    Text = "Saturation",
    Default = 0, Min = -1, Max = 1,
    Rounding = 2,
    Callback = function(v) 
        Visual.Saturation = v
        applyColorCorrection()
    end,
})

ColorCorrBox:AddSlider("ColorBrightness", {
    Text = "Brightness",
    Default = 0, Min = -1, Max = 1,
    Rounding = 2,
    Callback = function(v) 
        Visual.Brightness = v
        applyColorCorrection()
    end,
})

ColorCorrBox:AddSlider("ColorContrast", {
    Text = "Contrast",
    Default = 0, Min = -1, Max = 1,
    Rounding = 2,
    Callback = function(v) 
        Visual.Contrast = v
        applyColorCorrection()
    end,
})

ColorCorrBox:AddButton({
    Text = "Reset Color",
    Func = function() 
        resetColorCorrection()
        Library:Notify({ Title = "Color Reset", Description = "Saturation, Brightness, Contrast di-reset ke 0.", Time = 3 })
    end,
})

-- ─── HIDE SPARK ───────────────────────────────
SparkBox:AddToggle("HideRedSpark", {
    Text = "Hide Red Spark (Parry Effect)",
    Default = false,
    Callback = function(v) 
        HideSpark.Enabled = v
        if v then startHideSpark() else stopHideSpark() end
    end,
})

print("[TIARHUB] Part 8/10 loaded.")-- ═══════════════════════════════════════════
--  TAB 5 : MOVEMENT
-- ═══════════════════════════════════════════

local MoveLeft  = Tabs.Movement:AddLeftGroupbox("Speed & Jump", "zap")
local MoveRight = Tabs.Movement:AddRightGroupbox("Moonwalk", "moon")
local MoveExtra = Tabs.Movement:AddLeftGroupbox("Extra", "move")
local EmoteBox  = Tabs.Movement:AddRightGroupbox("Emote", "music")

-- ─── SPEED ────────────────────────────────────
MoveLeft:AddToggle("WalkSpeed", {
    Text = "Enable Walk Speed",
    Default = false,
    Callback = function(v) 
        Movement.WalkSpeedEnabled = v
        if v then applyWalkSpeed() 
        else 
            local hum = getHum()
            if hum then hum.WalkSpeed = Movement.OriginalWalkSpeed end
        end
    end,
})

MoveLeft:AddSlider("WalkSpeedVal", {
    Text = "Walk Speed Value",
    Default = 17.6, Min = 16, Max = 100,
    Rounding = 1,
    Callback = function(v) Movement.WalkSpeedValue = v end,
})

MoveLeft:AddToggle("NoClip", {
    Text = "No Clip",
    Default = false,
    Callback = function(v) toggleNoClip(v) end,
})

-- ─── MOONWALK ─────────────────────────────────
MoveRight:AddToggle("MoonwalkOn", {
    Text = "Enable Moonwalk",
    Default = false,
    Callback = function(v) 
        Moonwalk.Enabled = v
        if v then startMoonwalk(); applyMoonwalkFOV()
        else stopMoonwalk() end
    end,
})

MoveRight:AddDropdown("MoonwalkMode", {
    Text = "Moonwalk Mode",
    Values = {"Default", "Camera"},
    Default = "Default",
    Multi = false,
    Callback = function(v) 
        Moonwalk.Mode = v
        Library:Notify({ Title = "Moonwalk Mode", Description = "Mode: " .. v, Time = 2 })
    end,
})

MoveRight:AddDropdown("MoonwalkFOV", {
    Text = "Moonwalk FOV",
    Values = {"70", "90", "120"},
    Default = "90",
    Multi = false,
    Callback = function(v) 
        Moonwalk.FOVPreset = tonumber(v)
        if Moonwalk.Enabled then applyMoonwalkFOV() end
    end,
})

MoveRight:AddToggle("MoonwalkBtn", {
    Text = "Show Moonwalk Button",
    Default = false,
    Callback = function(v) 
        Moonwalk.ShowButton = v
        if v then createMoonwalkButton() else removeMoonwalkButton() end
    end,
})

MoveRight:AddSlider("MoonwalkSpam", {
    Text = "Spam Speed",
    Default = 30, Min = 1, Max = 50,
    Rounding = 0,
    Callback = function(v) Moonwalk.SpamSpeed = v end,
})

MoveRight:AddSlider("MoonwalkIntensity", {
    Text = "Intensity",
    Default = 35, Min = 1, Max = 50,
    Rounding = 1,
    Callback = function(v) Moonwalk.Intensity = v end,
})

-- ─── EXTRA ────────────────────────────────────
MoveExtra:AddToggle("FastVault", {
    Text = "Fast Vault",
    Default = false,
    Callback = function(v) FastVault.Enabled = v end,
})

MoveExtra:AddSlider("FastVaultSpeed", {
    Text = "Vault Speed",
    Default = 1.2, Min = 1, Max = 5,
    Rounding = 1, Suffix = "x",
    Callback = function(v) FastVault.Speed = v end,
})

-- ─── EMOTE ────────────────────────────────────
EmoteBox:AddDropdown("EmoteSelect", {
    Text = "Select Emote",
    Values = EmoteList,
    Default = "Mannrobics",
    Multi = false,
    Searchable = true,
    Callback = function(v) Emote.Selected = v end,
})

EmoteBox:AddButton({
    Text = "Play Emote",
    Func = function() playEmote(Emote.Selected) end,
})

-- ═══════════════════════════════════════════
--  TAB 6 : TELEPORT
-- ═══════════════════════════════════════════

local TpLeft  = Tabs.Teleport:AddLeftGroupbox("Teleport Cepat", "map-pin")
local TpRight = Tabs.Teleport:AddRightGroupbox("Auto Escape", "shield")

TpLeft:AddButton({
    Text = "Teleport ke Generator",
    Func = function()
        if teleportToGenerator() then
            Library:Notify({ Title = "Teleport", Description = "Ke Generator OK", Time = 2 })
        else
            Library:Notify({ Title = "Teleport", Description = "Generator tidak ditemukan", Time = 2 })
        end
    end,
})

TpLeft:AddButton({
    Text = "Teleport ke Gate / Exit",
    Func = function()
        if teleportToGate() then
            Library:Notify({ Title = "Teleport", Description = "Ke Gate OK", Time = 2 })
        else
            Library:Notify({ Title = "Teleport", Description = "Gate tidak ditemukan", Time = 2 })
        end
    end,
})

TpLeft:AddButton({
    Text = "Teleport ke Window",
    Func = function()
        if teleportToWindow() then
            Library:Notify({ Title = "Teleport", Description = "Ke Window OK", Time = 2 })
        else
            Library:Notify({ Title = "Teleport", Description = "Window tidak ditemukan", Time = 2 })
        end
    end,
})

TpLeft:AddButton({
    Text = "Teleport ke Pallet",
    Func = function()
        if teleportToPallet() then
            Library:Notify({ Title = "Teleport", Description = "Ke Pallet OK", Time = 2 })
        else
            Library:Notify({ Title = "Teleport", Description = "Pallet tidak ditemukan", Time = 2 })
        end
    end,
})

TpLeft:AddButton({
    Text = "Teleport ke Hook",
    Func = function()
        if teleportToHook() then
            Library:Notify({ Title = "Teleport", Description = "Ke Hook OK", Time = 2 })
        else
            Library:Notify({ Title = "Teleport", Description = "Hook tidak ditemukan", Time = 2 })
        end
    end,
})

TpRight:AddToggle("AutoEscape", {
    Text = "Auto Escape (Kabur dari Killer)",
    Default = false,
    Callback = function(v) AutoEscape.Enabled = v end,
})

TpRight:AddSlider("EscapeDist", {
    Text = "Detect Distance",
    Default = 40, Min = 10, Max = 200,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) AutoEscape.DetectDistance = v end,
})

TpRight:AddSlider("EscapeCooldown", {
    Text = "Cooldown",
    Default = 0.8, Min = 0.2, Max = 3,
    Rounding = 1, Suffix = "s",
    Callback = function(v) AutoEscape.Cooldown = v end,
})

-- ═══════════════════════════════════════════
--  TAB 7 : AVATAR
-- ═══════════════════════════════════════════

local AvaBox = Tabs.Avatar:AddLeftGroupbox("Copy Avatar", "user")

AvaBox:AddInput("AvatarUsername", {
    Text = "Target Username",
    Default = "",
    Placeholder = "Ketik username (tanpa @)",
    Numeric = false,
    Finished = true,
    Callback = function(v) AvatarCopier.TargetUsername = v end,
})

AvaBox:AddButton({
    Text = "Copy Avatar",
    Func = function() copyAvatar(AvatarCopier.TargetUsername) end,
})

AvaBox:AddButton({
    Text = "Reset to Original",
    Func = function() resetAvatar() end,
})

AvaBox:AddButton({
    Text = "Save Current as Original",
    Func = function()
        if saveOriginalAppearance() then
            Library:Notify({ Title = "Save Avatar", Description = "Avatar original disimpan!", Time = 3 })
        else
            Library:Notify({ Title = "Save Avatar", Description = "Gagal simpan avatar!", Time = 3 })
        end
    end,
})

AvaBox:AddToggle("BlockyBody", {
    Text = "Blocky Body (R6 Style)",
    Default = true,
    Callback = function(v) AvatarCopier.BlockyBody = v end,
})

-- ═══════════════════════════════════════════
--  TAB 8 : CROSSHAIR
-- ═══════════════════════════════════════════

local CrossBox = Tabs.Crosshair:AddLeftGroupbox("Crosshair", "crosshair")

CrossBox:AddToggle("CrosshairOn", {
    Text = "Enable Crosshair",
    Default = false,
    Callback = function(v) Crosshair.Enabled = v end,
})

CrossBox:AddColorPicker("CrosshairColor", {
    Text = "Color",
    Default = Crosshair.Color,
    Callback = function(c) Crosshair.Color = c end,
})

CrossBox:AddSlider("CrosshairSize", {
    Text = "Size",
    Default = 8, Min = 2, Max = 30,
    Rounding = 0, Suffix = "px",
    Callback = function(v) Crosshair.Size = v end,
})

CrossBox:AddSlider("CrosshairThickness", {
    Text = "Thickness",
    Default = 2, Min = 1, Max = 5,
    Rounding = 0, Suffix = "px",
    Callback = function(v) Crosshair.Thickness = v end,
})

CrossBox:AddSlider("CrosshairX", {
    Text = "Position X",
    Default = 0, Min = -100, Max = 100,
    Rounding = 0, Suffix = "px",
    Callback = function(v) Crosshair.OffsetX = v end,
})

CrossBox:AddSlider("CrosshairY", {
    Text = "Position Y",
    Default = 0, Min = -100, Max = 100,
    Rounding = 0, Suffix = "px",
    Callback = function(v) Crosshair.OffsetY = v end,
})

-- ═══════════════════════════════════════════
--  TAB 9 : ANTI-LAG
-- ═══════════════════════════════════════════

local LagBox = Tabs.AntiLag:AddLeftGroupbox("Anti-Lag Pack", "zap")

LagBox:AddToggle("AntiLagOn", {
    Text = "Enable Anti-Lag",
    Default = false,
    Callback = function(v) 
        AntiLag.Enabled = v
        if v then startAntiLag() end
    end,
})

LagBox:AddToggle("NoParticles", {
    Text = "No Particles",
    Default = false,
    Callback = function(v) 
        AntiLag.NoParticles = v
        applyAntiLag()
    end,
})

LagBox:AddToggle("NoTextures", {
    Text = "No Textures",
    Default = false,
    Callback = function(v) 
        AntiLag.NoTextures = v
        applyAntiLag()
    end,
})

LagBox:AddToggle("PhysicsThrottle", {
    Text = "Physics Throttle",
    Default = false,
    Callback = function(v) 
        AntiLag.PhysicsThrottle = v
        applyAntiLag()
    end,
})

LagBox:AddToggle("NoGlobalShadows", {
    Text = "No Global Shadows",
    Default = false,
    Callback = function(v) 
        AntiLag.NoGlobalShadows = v
        applyAntiLag()
    end,
})

LagBox:AddToggle("NetworkLag", {
    Text = "Network Replication Lag",
    Default = false,
    Callback = function(v) 
        AntiLag.NetworkLag = v
        applyAntiLag()
    end,
})

print("[TIARHUB] Part 9/10 loaded.")-- ═══════════════════════════════════════════
--  TAB 10 : SETTINGS (Theme + Config)
-- ═══════════════════════════════════════════

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("TiarHub")
ThemeManager:SetFolder("TiarHub")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

-- ═══════════════════════════════════════════
--  AUTO APPLY ON RESPAWN
-- ═══════════════════════════════════════════

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    pcall(function()
        applyVisual(true)
        toggleScreenEffects()
        applyColorCorrection()
        if AntiLag.Enabled then applyAntiLag() end
        if Moonwalk.Enabled then
            task.wait(0.5)
            startMoonwalk()
            applyMoonwalkFOV()
        end
        if FakePerks.Flowstate.Enabled then
            hookFakeFlowstate(char)
        end
        if Movement.NoClip then
            toggleNoClip(true)
        end
        if Movement.WalkSpeedEnabled then
            applyWalkSpeed()
        end
    end)
end)

-- ═══════════════════════════════════════════
--  NOTIFIKASI STARTUP
-- ═══════════════════════════════════════════

task.wait(1)
Library:Notify({
    Title = "TIARHUB",
    Description = "Loaded Successfully - Obsidian UI",
    Time = 5,
    Icon = 0,
})

task.wait(2)
Library:Notify({
    Title = "Fitur Utama",
    Description = "ESP | Auto Parry | Aimbot Pisah | Aimlock Button | Fake Perks",
    Time = 6,
    Icon = 0,
})

task.wait(2)
Library:Notify({
    Title = "Tips",
    Description = "Combat Tab - Parry | Aimlock Tab - Aimbot | Killer Tab - Killer System",
    Time = 6,
    Icon = 0,
})

-- ═══════════════════════════════════════════
--  PRINT STATUS
-- ═══════════════════════════════════════════

print("════════════════════════════════════════════")
print("  TIARHUB - ALL LOADED")
print("  ════════════════════════════════════════")
print("  [OK] ESP System + Killer Warning")
print("  [OK] Auto Parry (2 Mode) + Parry Circle Smooth")
print("  [OK] Skill Check (Instant/Perfect)")
print("  [OK] Auto Dodge Abyss")
print("  [OK] 4 Fake Perks + Cooldown Slider")
print("  [OK] Aimbot Pistol (Aimlock Tab)")
print("  [OK] Aimbot Killer (Aimlock Tab)")
print("  [OK] Aimlock Button + Lock Radius + FOV Radius")
print("  [OK] Silent Aim Veil Spear")
print("  [OK] Killer System + Hit Marker")
print("  [OK] Movement + Moonwalk 2 Mode + FOV")
print("  [OK] Copy Avatar")
print("  [OK] Teleport System + Auto Escape")
print("  [OK] Visual + Fix Contrast + Hide Spark")
print("  [OK] Anti-Lag")
print("  [OK] Crosshair")
print("  [OK] ThemeManager + SaveManager")
print("  ════════════════════════════════════════")
print("  Violence District | by Tiar")
print("════════════════════════════════════════════")
