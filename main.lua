-- ============================================
-- TIARHUB v19 FINAL - File 1/2
-- Setup + Config + ESP + Survivor + Aimbot
-- ============================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ============ WINDOW ============
local Window = Rayfield:CreateWindow({
    name = "TiarHub",
    subtitle = "Violence District | v19",
    sidebarLayout = true,
})

-- ============ CONFIG - ESP ============
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

-- ============ CONFIG - AUTO PARRY ============
local PARRY_PRESETS = {
    Safety     = { Distance = 12, Debounce = 0.15, Face = 0.5, RequireFacing = true },
    Aggressive = { Distance = 20, Debounce = 0.05, Face = -1,  RequireFacing = false }
}
local Auto = { Parry = false, ParryMode = "Safety", ParryDistance = 12, FaceSensitivity = 0.5, RequireFacing = true, SkillCheck = false, Wiggle = false, WiggleSpam = 5 }
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

-- ============ CONFIG - FAKE PERKS (4 MACAM) ============
local FakePerks = {
    Flowstate = { Enabled = false, Duration = 3, SpeedBoost = 20, Cooldown = 60, LastUse = 0 },
    SnakeStep = { Enabled = false, SpeedBoost = 90, Cooldown = 0, LastUse = 0 },
    QuickRecovery = { Enabled = false, Cooldown = 30, LastUse = 0 },
    PerfectLanding = { Enabled = false, Cooldown = 45, LastUse = 0 },
    LastVault = 0, LastCrouchState = false
}

-- ============ CONFIG - AIMLOCK KILLER ============
local AimlockKiller = { Enabled = false, ShowButton = false, LockRadius = 100, Smoothness = 0.5, Button = nil }

-- ============ CONFIG - SILENT AIM VEIL SPEAR ============
local SilentAimSpear = { Enabled = false, TargetMode = "Killer", FOV = 250, AimPart = "HumanoidRootPart", Prediction = 0.12, Holding = false, ShowFOV = false }
local SilentAimCircle = nil

-- ============ CONFIG - AIMBOT ============
local GunAim = { Enabled = false, Holding = false, TargetMode = "Killer", Strength = 1, Predict = true, PredictStrength = 0.12, FOV = 250, VisibilityCheck = false, AimPart = "HumanoidRootPart", ShowTracer = false, TracerColor = Color3.fromRGB(255, 0, 0) }
local FOVCircle = nil
local FOVCircleInner = nil
local FOVCircleVisible = false
local FOVCircleSize = 250
local FOVCircleColor = Color3.fromRGB(255, 255, 255)
local TracerLine = nil
local Drawing = Drawing
local KillerAim = { Enabled = false, FOV = 200, Strength = 0.5, Holding = false }

-- ============ CONFIG - KILLER ============
local Killer = { AutoAttack = false, AutoCarry = false, AutoHook = false, KillAll = false, AutoStalk = false, StalkRange = 150, AutoHookAllDowned = false, AutoHookAllRange = 500, AutoSprint = false, AutoSprintValue = 30, AutoFaceTarget = false, AutoFaceRange = 20, PredictionAttack = false, PredictStrength = 0.15 }
local KillerBusy = false
local KillerTarget = nil
local StalkConnection = nil
local HitMarker = { Enabled = false, Color = Color3.fromRGB(255, 0, 0), Size = 20, Thickness = 2, Duration = 0.15 }
local HitMarkerLines = {}
local HitMarkerActive = false
local HitMarkerEnd = 0
local ChaseDetector = { Enabled = false, Range = 30, LastNotify = 0, Cooldown = 2 }

-- ============ CONFIG - MOVEMENT ============
local Movement = { WalkSpeedEnabled = false, WalkSpeedValue = 17.6, OriginalWalkSpeed = 16, NoClip = false }

-- ============ CONFIG - MOONWALK ============
local Moonwalk = { Enabled = false, ShowButton = false, SpamSpeed = 30, Intensity = 35, SlowSpeed = 13, UseSlow = true, Mode = "Default", FOVPreset = 90 }
local MoonwalkConnection = nil
local MoonwalkHeartbeat = nil
local MoonwalkButton = nil
local ParryActive = false

-- ============ CONFIG - CROSSHAIR ============
local Crosshair = { Enabled = false, Size = 8, Thickness = 2, Color = Color3.fromRGB(255, 255, 255), OffsetX = 0, OffsetY = 0 }
local CrosshairGui = nil

-- ============ CONFIG - EMOTE ============
local Emote = { Selected = "Mannrobics" }
local EmoteList = { "Mannrobics","Arm Swing","Schadenfreude","Kyoufuu","Backflip","Griddy","Friday Night","Floating Rest","OnePlays","Quick Combo","WarCry","Wave" }

-- ============ CONFIG - MASKED ============
local Masked = { CurrentPower = "Cobra" }
local MaskedPowers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}

-- ============ CONFIG - VISUAL ============
local Visual = { Fullbright = false, NoFog = false, NoShadow = false, NoBloom = false, NoBlur = false, ColorCorrection = false, Saturation = 0, Brightness = 0, Contrast = 0, AmbientColorEnabled = false, AmbientColor = Color3.fromRGB(255, 255, 255), ClockTimeEnabled = false, ClockTime = 14, FogControlEnabled = false, FogEnd = 100000, FogStart = 0, FogColor = Color3.fromRGB(200, 200, 200), NoCameraShake = false, NoBlood = false }
local VisualOriginal = { Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient, GlobalShadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart, FogColor = Lighting.FogColor }

-- ============ CONFIG - ANTI-LAG ============
local AntiLag = { Enabled = false, NoParticles = false, NoTextures = false, PhysicsThrottle = false, NoGlobalShadows = false, NetworkLag = false }
local HideSpark = { Enabled = false }
local HiddenSparkCache = {}

-- ============ CONFIG - TELEPORT ============
local Teleport = { LastTeleport = 0, Cooldown = 0.5 }
local AutoEscape = { Enabled = false, DetectDistance = 40, Cooldown = 0.8, LastEscape = 0 }

-- ============ KILLER ANIM IDS ============
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

-- ============ REMOTES ============
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

-- ============ HELPER ============
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

-- ============ ESP SYSTEM ============
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
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = ESP.NameSize
                lbl.Parent = bb
                ESPNames[obj] = bb
            end
        end
    end
end

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

RunService.RenderStepped:Connect(function()
    Frames = (Frames or 0) + 1
    if tick() - LastTick >= 1 then
        local fps = Frames
        Frames = 0
        LastTick = tick()
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        pcall(function()
            Rayfield:SetWatermark(string.format("TiarHub | FPS: %d | PING: %d ms", fps, ping))
        end)
    end
end)
local LastTick = tick()
local Frames = 0

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

        if ParryRangeVisual.Enabled and root then
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
            if ParryRangeVisual.PulseEnabled then pulse = math.sin(tick() * 3) * 0.15 end
            local sizeOuter = baseSize + pulse
            local sizeInner = baseSize - 0.8
            local yOffset = root.Size.Y / 2 + 1.5
            local cframe = CFrame.new(root.Position - Vector3.new(0, yOffset, 0)) * CFrame.Angles(0, 0, math.rad(90))
            ParryCircle.Size = Vector3.new(0.3, sizeOuter, sizeOuter)
            ParryCircle.CFrame = cframe
            ParryCircle.Transparency = ParryRangeVisual.Transparency
            ParryCircleInner.Size = Vector3.new(0.15, sizeInner, sizeInner)
            ParryCircleInner.CFrame = cframe
            ParryCircleInner.Transparency = ParryRangeVisual.Transparency + 0.15
            local color = ParryRangeVisual.Color
            if ParryRangeVisual.RainbowMode then
                local hue = (tick() * 0.1) % 1
                color = Color3.fromHSV(hue, 1, 1)
            end
            ParryCircle.Color = color
            ParryCircleInner.Color = color
        else
            if ParryCircle then ParryCircle:Destroy(); ParryCircle = nil end
            if ParryCircleInner then ParryCircleInner:Destroy(); ParryCircleInner = nil end
        end

        updateWarning()
    end)
end)

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
                    if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
                        hookKiller(p.Character)
                    end
                end
            end
        end)
    end
end)

print("[TiarHub v19] File 1/2 loaded.")-- ============================================
-- TIARHUB v19 FINAL - File 2/2
-- Killer + Movement + Visual + Teleport + UI + Startup
-- ============================================

-- ============ FAKE PERKS ============
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
        local vaultIds = { ["rbxassetid://83873880822918"] = true, ["rbxassetid://136962284480779"] = true }
        if vaultIds["rbxassetid://" .. id] then
            FakePerks.Flowstate.LastUse = now
            local originalSpeed = hum.WalkSpeed
            hum.WalkSpeed = originalSpeed * (1 + FakePerks.Flowstate.SpeedBoost / 100)
            Rayfield:Notify({ title = "Fake Flowstate", content = "Speed boost aktif!", duration = 2 })
            task.delay(FakePerks.Flowstate.Duration, function()
                if hum and hum.Parent then hum.WalkSpeed = originalSpeed end
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
            local isCrouching = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or (hum.HipHeight and hum.HipHeight < 1.5)
            if isCrouching and not FakePerks.LastCrouchState then
                FakePerks.LastCrouchState = true
                hum.WalkSpeed = FakePerks.SnakeStep.SpeedBoost
            elseif not isCrouching and FakePerks.LastCrouchState then
                FakePerks.LastCrouchState = false
                hum.WalkSpeed = Movement.WalkSpeedEnabled and Movement.WalkSpeedValue or 16
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
            local now = tick()
            if now - FakePerks.QuickRecovery.LastUse < FakePerks.QuickRecovery.Cooldown then return end
            if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum.Health < hum.MaxHealth * 0.3 then
                FakePerks.QuickRecovery.LastUse = now
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
                Rayfield:Notify({ title = "Quick Recovery", content = "Recovery aktif!", duration = 1.5 })
            end
        end)
    end
end)

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
                    Rayfield:Notify({ title = "Perfect Landing", content = "Anti damage jatuh!", duration = 1.5 })
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

-- ============ AIMBOT / FOV CIRCLE ============
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
            FOVCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
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

-- ============ SILENT AIM ============
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
            SilentAimCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
        end
        if not SilentAimSpear.Enabled then return end
        if not SilentAimSpear.Holding then return end
        local target = getSilentAimTarget()
        if not target then return end
        local cam = workspace.CurrentCamera
        local pos = target.Position
        if SilentAimSpear.Prediction > 0 then pos = pos + (target.AssemblyLinearVelocity * SilentAimSpear.Prediction) end
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
            if tool and string.find(string.lower(tool.Name), "veil") then SilentAimSpear.Holding = true
            else SilentAimSpear.Holding = false end
        end)
    end
end)

-- ============ AIMLOCK KILLER BUTTON ============
local function getClosestKillerForLock()
    local root = getRoot()
    local cam = workspace.CurrentCamera
    if not root or not cam then return nil end
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, shortest = nil, AimlockKiller.LockRadius
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
        if not AimlockKiller.Enabled then return end
        local target = getClosestKillerForLock()
        if not target then return end
        local cam = workspace.CurrentCamera
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, target.Position), AimlockKiller.Smoothness)
    end)
end)

local function createAimlockButton()
    pcall(function()
        if AimlockKiller.Button then AimlockKiller.Button:Destroy() end
        local gui = Instance.new("ScreenGui")
        gui.Name = "AimlockButtonGui"
        gui.ResetOnSpawn = false
        gui.Parent = PlayerGui
        local btn = Instance.new("ImageButton")
        btn.Size = UDim2.new(0, 50, 0, 50)
        btn.Position = UDim2.new(0.55, 0, 0.75, 0)
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
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 60, 0, 20)
        label.Position = UDim2.new(0.5, -30, -0.5, 0)
        label.BackgroundTransparency = 1
        label.Text = "AIM"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0.5
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.Parent = btn
        btn.MouseButton1Click:Connect(function()
            AimlockKiller.Enabled = not AimlockKiller.Enabled
            if AimlockKiller.Enabled then
                stroke.Color = Color3.fromRGB(255, 0, 0)
                label.Text = "LOCK"
                Rayfield:Notify({ title = "Aimlock Killer", content = "Aimlock ON", duration = 2 })
            else
                stroke.Color = Color3.fromRGB(255, 255, 255)
                label.Text = "AIM"
                Rayfield:Notify({ title = "Aimlock Killer", content = "Aimlock OFF", duration = 2 })
            end
        end)
        AimlockKiller.Button = gui
    end)
end

local function removeAimlockButton()
    if AimlockKiller.Button then AimlockKiller.Button:Destroy(); AimlockKiller.Button = nil end
end

print("[TiarHub v19] File 2/2 loaded. Lanjut ke UI...")-- ============================================
-- TIARHUB v19 - UI MENU
-- ============================================

-- ============ ESP TAB ============
local ESPTab = Window:CreateTab({ name = "ESP", icon = 4 })
ESPTab:CreateSection("Player ESP")
ESPTab:CreateToggle({ name = "ESP Survivor", currentValue = false, flag = "esp_survivor", callback = function(v) ESP.Survivor = v end })
ESPTab:CreateColorPicker({ name = "Survivor Color", color = ESP.SurvivorColor, flag = "esp_survivor_color", callback = function(c) ESP.SurvivorColor = c end })
ESPTab:CreateToggle({ name = "ESP Killer", currentValue = false, flag = "esp_killer", callback = function(v) ESP.Killer = v end })
ESPTab:CreateColorPicker({ name = "Killer Color", color = ESP.KillerColor, flag = "esp_killer_color", callback = function(c) ESP.KillerColor = c end })
ESPTab:CreateSection("Map ESP")
ESPTab:CreateToggle({ name = "ESP Generator (%)", currentValue = false, flag = "esp_generator", callback = function(v) ESP.Generator = v end })
ESPTab:CreateColorPicker({ name = "Generator Color", color = ESP.GeneratorColor, flag = "esp_gen_color", callback = function(c) ESP.GeneratorColor = c end })
ESPTab:CreateToggle({ name = "ESP Hook", currentValue = false, flag = "esp_hook", callback = function(v) ESP.Hook = v end })
ESPTab:CreateToggle({ name = "ESP Pallet", currentValue = false, flag = "esp_pallet", callback = function(v) ESP.Pallet = v end })
ESPTab:CreateToggle({ name = "ESP Window", currentValue = false, flag = "esp_window", callback = function(v) ESP.Window = v end })
ESPTab:CreateToggle({ name = "ESP SCP", currentValue = false, flag = "esp_scp", callback = function(v) ESP.SCP = v end })
ESPTab:CreateSection("Style")
ESPTab:CreateSlider({ name = "ESP Radius", range = {50, 2000}, increment = 50, suffix = "stud", currentValue = 300, flag = "esp_radius", callback = function(v) ESP.Distance = v end })
ESPTab:CreateDropdown({ name = "ESP Mode", options = {"Highlight", "Outline", "Fill"}, currentOption = "Highlight", flag = "esp_mode", callback = function(opt) ESP.Mode = opt end })
ESPTab:CreateToggle({ name = "Show Name Tag", currentValue = true, flag = "esp_name", callback = function(v) ESP.ShowName = v end })

-- ============ SURVIVOR TAB ============
local SurvivorTab = Window:CreateTab({ name = "Survivor", icon = 3 })
SurvivorTab:CreateSection("Auto Parry")
SurvivorTab:CreateToggle({ name = "Auto Parry", currentValue = false, flag = "parry_on", callback = function(v) Auto.Parry = v end })
SurvivorTab:CreateDropdown({ name = "Parry Mode", options = {"Safety", "Aggressive"}, currentOption = "Safety", flag = "parry_mode", callback = function(opt) Auto.ParryMode = opt; applyParryPreset(opt); Rayfield:Notify({ title = "Parry Mode", content = "Mode: " .. opt }) end })
SurvivorTab:CreateToggle({ name = "Show Parry Range", currentValue = false, flag = "parry_range", callback = function(v) ParryRangeVisual.Enabled = v end })
SurvivorTab:CreateToggle({ name = "Parry Rainbow", currentValue = false, flag = "parry_rainbow", callback = function(v) ParryRangeVisual.RainbowMode = v end })
SurvivorTab:CreateSlider({ name = "Parry Circle Size", range = {5, 50}, increment = 1, suffix = "stud", currentValue = 12, flag = "parry_size", callback = function(v) Auto.ParryDistance = v end })

SurvivorTab:CreateSection("Fake Perks")
SurvivorTab:CreateToggle({ name = "Fake Flowstate", currentValue = false, flag = "fp_flow", callback = function(v) FakePerks.Flowstate.Enabled = v end })
SurvivorTab:CreateSlider({ name = "Flowstate Cooldown", range = {0, 100}, increment = 1, suffix = "s", currentValue = 60, flag = "fp_flow_cd", callback = function(v) FakePerks.Flowstate.Cooldown = v end })
SurvivorTab:CreateToggle({ name = "Fake Snake Step", currentValue = false, flag = "fp_snake", callback = function(v) FakePerks.SnakeStep.Enabled = v end })
SurvivorTab:CreateSlider({ name = "Snake Step Speed", range = {16, 150}, increment = 1, currentValue = 90, flag = "fp_snake_speed", callback = function(v) FakePerks.SnakeStep.SpeedBoost = v end })
SurvivorTab:CreateToggle({ name = "Fake Quick Recovery", currentValue = false, flag = "fp_recovery", callback = function(v) FakePerks.QuickRecovery.Enabled = v end })
SurvivorTab:CreateSlider({ name = "Quick Recovery Cooldown", range = {0, 100}, increment = 1, suffix = "s", currentValue = 30, flag = "fp_recovery_cd", callback = function(v) FakePerks.QuickRecovery.Cooldown = v end })
SurvivorTab:CreateToggle({ name = "Fake Perfect Landing", currentValue = false, flag = "fp_landing", callback = function(v) FakePerks.PerfectLanding.Enabled = v end })
SurvivorTab:CreateSlider({ name = "Perfect Landing Cooldown", range = {0, 100}, increment = 1, suffix = "s", currentValue = 45, flag = "fp_landing_cd", callback = function(v) FakePerks.PerfectLanding.Cooldown = v end })

-- ============ AIMBOT TAB ============
local AimTab = Window:CreateTab({ name = "Aimbot", icon = 5 })
AimTab:CreateSection("Aimlock Killer Button")
AimTab:CreateToggle({ name = "Show Aimlock Button", currentValue = false, flag = "al_show_btn", callback = function(v) AimlockKiller.ShowButton = v; if v then createAimlockButton() else removeAimlockButton() end end })
AimTab:CreateSlider({ name = "Lock Radius", range = {20, 500}, increment = 10, suffix = "stud", currentValue = 100, flag = "al_radius", callback = function(v) AimlockKiller.LockRadius = v end })
AimTab:CreateSlider({ name = "Smoothness", range = {0.1, 1}, increment = 0.05, currentValue = 0.5, flag = "al_smooth", callback = function(v) AimlockKiller.Smoothness = v end })

AimTab:CreateSection("Aimbot")
AimTab:CreateToggle({ name = "Aimbot (Hold RMB)", currentValue = false, flag = "aim_on", callback = function(v) GunAim.Enabled = v end })
AimTab:CreateToggle({ name = "Show FOV Circle", currentValue = false, flag = "aim_fovcircle", callback = function(v) FOVCircleVisible = v; if v and not FOVCircle then createFOVCircle() end end })
AimTab:CreateToggle({ name = "Show Tracer", currentValue = false, flag = "aim_tracer", callback = function(v) GunAim.ShowTracer = v; if v and not TracerLine then createTracer() end end })
AimTab:CreateDropdown({ name = "Target", options = {"Killer", "Survivor", "Both"}, currentOption = "Killer", flag = "aim_target", callback = function(opt) GunAim.TargetMode = opt end })
AimTab:CreateSlider({ name = "FOV", range = {50, 1000}, increment = 10, currentValue = 250, flag = "aim_fov", callback = function(v) GunAim.FOV = v end })
AimTab:CreateSlider({ name = "Smoothness", range = {0.1, 1}, increment = 0.05, currentValue = 1, flag = "aim_smooth", callback = function(v) GunAim.Strength = v end })
AimTab:CreateSlider({ name = "Prediction", range = {0, 1}, increment = 0.01, currentValue = 0.12, flag = "aim_predict", callback = function(v) GunAim.PredictStrength = v end })

AimTab:CreateSection("Silent Aim Veil Spear")
AimTab:CreateToggle({ name = "Enable Silent Aim", currentValue = false, flag = "silent_spear", callback = function(v) SilentAimSpear.Enabled = v end })
AimTab:CreateToggle({ name = "Show FOV", currentValue = false, flag = "silent_fov", callback = function(v) SilentAimSpear.ShowFOV = v end })
AimTab:CreateDropdown({ name = "Target", options = {"Killer", "Survivor", "Both"}, currentOption = "Killer", flag = "silent_target", callback = function(opt) SilentAimSpear.TargetMode = opt end })
AimTab:CreateSlider({ name = "FOV", range = {50, 1000}, increment = 10, currentValue = 250, flag = "silent_fov_val", callback = function(v) SilentAimSpear.FOV = v end })
AimTab:CreateSlider({ name = "Prediction", range = {0, 1}, increment = 0.01, currentValue = 0.12, flag = "silent_pred", callback = function(v) SilentAimSpear.Prediction = v end })

-- ============ KILLER TAB ============
local KillerTab = Window:CreateTab({ name = "Killer", icon = 7 })
KillerTab:CreateSection("Attack")
KillerTab:CreateToggle({ name = "Auto Attack", currentValue = false, flag = "k_attack", callback = function(v) Killer.AutoAttack = v end })
KillerTab:CreateToggle({ name = "Auto Kill All", currentValue = false, flag = "k_killall", callback = function(v) Killer.KillAll = v end })
KillerTab:CreateSection("Carry & Hook")
KillerTab:CreateToggle({ name = "Auto Carry", currentValue = false, flag = "k_carry", callback = function(v) Killer.AutoCarry = v end })
KillerTab:CreateToggle({ name = "Auto Hook", currentValue = false, flag = "k_hook", callback = function(v) Killer.AutoHook = v end })
KillerTab:CreateSection("Stalk")
KillerTab:CreateToggle({ name = "Auto Stalk", currentValue = false, flag = "k_stalk", callback = function(v) Killer.AutoStalk = v end })
KillerTab:CreateSlider({ name = "Stalk Range", range = {50, 500}, increment = 10, suffix = "stud", currentValue = 150, flag = "k_stalk_range", callback = function(v) Killer.StalkRange = v end })
KillerTab:CreateSection("Masked Power")
KillerTab:CreateDropdown({ name = "Select Power", options = MaskedPowers, currentOption = "Cobra", flag = "k_masked", callback = function(opt) Masked.CurrentPower = opt end })
KillerTab:CreateButton({ name = "Activate Power", callback = function() 
    local event = findRemote("Remotes.Killers.Masked.Activatepower")
    if event then pcall(function() event:FireServer(Masked.CurrentPower) end) end
end })
KillerTab:CreateButton({ name = "Deactivate Power", callback = function() 
    local event = findRemote("Remotes.Killers.Masked.Deactivatepower")
    if event then pcall(function() event:FireServer() end) end
end })

-- ============ MISC TAB ============
local MiscTab = Window:CreateTab({ name = "Misc", icon = 2 })
MiscTab:CreateSection("Walk Speed")
MiscTab:CreateToggle({ name = "Enable Walk Speed", currentValue = false, flag = "m_ws", callback = function(v) 
    Movement.WalkSpeedEnabled = v
    if v then
        task.spawn(function()
            while Movement.WalkSpeedEnabled do
                local hum = getHum()
                if hum and not shouldDisableWalkSpeed() then
                    hum.WalkSpeed = Movement.WalkSpeedValue
                end
                task.wait(0.1)
            end
        end)
    else
        local hum = getHum()
        if hum then hum.WalkSpeed = Movement.OriginalWalkSpeed end
    end
end })
MiscTab:CreateSlider({ name = "Walk Speed Value", range = {16, 100}, increment = 0.5, currentValue = 17.6, flag = "m_ws_val", callback = function(v) Movement.WalkSpeedValue = v end })
MiscTab:CreateSection("No Clip")
MiscTab:CreateToggle({ name = "No Clip", currentValue = false, flag = "m_noclip", callback = function(v) 
    Movement.NoClip = v
    if v then
        task.spawn(function()
            while Movement.NoClip do
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end })
MiscTab:CreateSection("Moonwalk")
MiscTab:CreateToggle({ name = "Moonwalk", currentValue = false, flag = "m_moonwalk", callback = function(v) Moonwalk.Enabled = v end })
MiscTab:CreateToggle({ name = "Moonwalk Button", currentValue = false, flag = "m_moonwalk_btn", callback = function(v) Moonwalk.ShowButton = v end })
MiscTab:CreateSection("Emote")
MiscTab:CreateDropdown({ name = "Select Emote", options = EmoteList, currentOption = "Mannrobics", flag = "m_emote", callback = function(opt) Emote.Selected = opt end })
MiscTab:CreateButton({ name = "Play Emote", callback = function() 
    if EmoteRemote then pcall(function() EmoteRemote:FireServer(Emote.Selected) end) end
end })

-- ============ VISUAL TAB ============
local VisualTab = Window:CreateTab({ name = "Visual", icon = 1 })
VisualTab:CreateSection("Lighting")
VisualTab:CreateToggle({ name = "Fullbright", currentValue = false, flag = "v_fb", callback = function(v) 
    Visual.Fullbright = v
    if v then
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
end })
VisualTab:CreateToggle({ name = "No Fog", currentValue = false, flag = "v_nofog", callback = function(v) 
    Visual.NoFog = v
    if v then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
    else
        Lighting.FogEnd = VisualOriginal.FogEnd
        Lighting.FogStart = VisualOriginal.FogStart
    end
end })
VisualTab:CreateToggle({ name = "No Shadow", currentValue = false, flag = "v_noshadow", callback = function(v) 
    Visual.NoShadow = v
    Lighting.GlobalShadows = not v
end })
VisualTab:CreateSection("Color Correction")
VisualTab:CreateSlider({ name = "Saturation", range = {-1, 1}, increment = 0.05, currentValue = 0, flag = "v_sat", callback = function(v) 
    Visual.Saturation = v
    Visual.ColorCorrection = true
    local cc = Lighting:FindFirstChild("TiarCC") or Instance.new("ColorCorrectionEffect")
    cc.Name = "TiarCC"
    cc.Parent = Lighting
    cc.Enabled = true
    cc.Saturation = v
    cc.Brightness = Visual.Brightness
    cc.Contrast = Visual.Contrast
end })
VisualTab:CreateSlider({ name = "Brightness", range = {-1, 1}, increment = 0.05, currentValue = 0, flag = "v_bright", callback = function(v) 
    Visual.Brightness = v
    Visual.ColorCorrection = true
    local cc = Lighting:FindFirstChild("TiarCC") or Instance.new("ColorCorrectionEffect")
    cc.Name = "TiarCC"
    cc.Parent = Lighting
    cc.Enabled = true
    cc.Saturation = Visual.Saturation
    cc.Brightness = v
    cc.Contrast = Visual.Contrast
end })
VisualTab:CreateSlider({ name = "Contrast", range = {-1, 1}, increment = 0.05, currentValue = 0, flag = "v_contrast", callback = function(v) 
    Visual.Contrast = v
    Visual.ColorCorrection = true
    local cc = Lighting:FindFirstChild("TiarCC") or Instance.new("ColorCorrectionEffect")
    cc.Name = "TiarCC"
    cc.Parent = Lighting
    cc.Enabled = true
    cc.Saturation = Visual.Saturation
    cc.Brightness = Visual.Brightness
    cc.Contrast = v
end })

-- ============ ANTI-LAG TAB ============
local AntiLagTab = Window:CreateTab({ name = "Anti-Lag", icon = 8 })
AntiLagTab:CreateToggle({ name = "No Particles", currentValue = false, flag = "al_particles", callback = function(v) AntiLag.NoParticles = v end })
AntiLagTab:CreateToggle({ name = "No Textures", currentValue = false, flag = "al_textures", callback = function(v) AntiLag.NoTextures = v end })
AntiLagTab:CreateToggle({ name = "No Global Shadows", currentValue = false, flag = "al_shadows", callback = function(v) Lighting.GlobalShadows = not v end })

-- ============ NOTIFIKASI STARTUP ============
Rayfield:Notify({
    title = "TiarHub v19",
    content = "Script loaded! Semua fitur siap dipakai.",
    duration = 6
})

print("[TiarHub v19] UI loaded. Semua siap!")
