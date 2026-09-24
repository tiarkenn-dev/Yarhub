-- ═══════════════════════════════════════════
--   TIARHUB 4D + FALLENS FEATURES
--   BAGIAN 1/5 : Setup, Splash, Config, Helper
-- ═══════════════════════════════════════════

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true

-- ═══════════════════════════════════════════
--  🎬 SPLASH SCREEN
-- ═══════════════════════════════════════════
local function ShowSplash()
    local splash = Instance.new("ScreenGui")
    splash.Name = "TiarHubSplash"
    splash.IgnoreGuiInset = true
    splash.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    splash.Parent = game:GetService("CoreGui")
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(5, 10, 25)
    bg.BorderSizePixel = 0
    bg.Parent = splash
    
    local title = Instance.new("TextLabel")
    title.Text = "TIARHUB 4D"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 72
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 100)
    title.Position = UDim2.new(0, 0, 0.4, 0)
    title.TextStrokeTransparency = 0.2
    title.TextStrokeColor3 = Color3.fromRGB(0, 100, 200)
    title.Parent = bg
    
    local loading = Instance.new("TextLabel")
    loading.Text = "LOADING..."
    loading.Font = Enum.Font.GothamBold
    loading.TextSize = 18
    loading.TextColor3 = Color3.fromRGB(150, 200, 255)
    loading.BackgroundTransparency = 1
    loading.Size = UDim2.new(1, 0, 0, 30)
    loading.Position = UDim2.new(0, 0, 0.55, 0)
    loading.Parent = bg
    
    task.wait(2)
    for i = 0, 1, 0.05 do
        bg.BackgroundTransparency = i
        title.TextTransparency = i
        title.TextStrokeTransparency = i
        loading.TextTransparency = i
        task.wait(0.02)
    end
    splash:Destroy()
end

ShowSplash()

-- ═══════════════════════════════════════════
--  🪟 WINDOW
-- ═══════════════════════════════════════════
local Window = Library:CreateWindow({
    Title = "TIARHUB 4D",
    Footer = "Violence District",
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
--  🔵 PALET WARNA
-- ═══════════════════════════════════════════
local NEON_BLUE   = Color3.fromRGB(30, 150, 255)
local DEEP_BLUE   = Color3.fromRGB(0, 80, 180)
local DARK_BLUE   = Color3.fromRGB(0, 40, 90)
local BLACK_BLUE  = Color3.fromRGB(10, 20, 40)
local WHITE_BLUE  = Color3.fromRGB(220, 235, 255)
local CYAN_ACCENT = Color3.fromRGB(0, 255, 255)

-- ═══════════════════════════════════════════
--  SERVICES
-- ═══════════════════════════════════════════
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
local Camera = workspace.CurrentCamera

-- ============ REMOTES ============
local function findRemote(path)
    local cur = ReplicatedStorage
    for segment in string.gmatch(path, "[^%.]+") do
        cur = cur and cur:FindFirstChild(segment)
        if not cur then return nil end
    end
    return cur
end

local CarryEvent = findRemote("Remotes.Carry.CarrySurvivorEvent")
local HookEvent = findRemote("Remotes.Carry.HookEvent")
local AttackEvent = findRemote("Remotes.Attacks.BasicAttack")
local EmoteRemote = findRemote("Remotes.EmoteHandler")

-- ============ CONFIG ============
local Config = {
    ESP_Survivor = false, ESP_Killer = false, ESP_Generator = false,
    ESP_Hook = false, ESP_Pallet = false, ESP_Vault = false, ESP_Window = false, ESP_Blood = false, ESP_SCP = false,
    ESP_Distance = 500,
    ESP_SurvivorColor = Color3.fromRGB(60, 255, 120),
    ESP_KillerColor = Color3.fromRGB(255, 60, 60),
    ESP_GeneratorColor = Color3.fromRGB(255, 170, 0),
    ESP_HookColor = Color3.fromRGB(180, 80, 255),
    ESP_PalletColor = Color3.fromRGB(255, 220, 80),
    ESP_VaultColor = Color3.fromRGB(80, 255, 255),
    ESP_WindowColor = Color3.fromRGB(80, 255, 255),
    ESP_BloodColor = Color3.fromRGB(255, 30, 30),
    ESP_SCPColor = Color3.fromRGB(255, 0, 0),
    ESPStatus = { Enabled = false, ShowName = true, ShowDistance = true, ShowHealth = false, ShowState = true, Radius = 200 },
    
    AutoParry = false, ParryDistance = 15, ParryDebounce = 0.2,
    ParryMode = "Instant",
    ParryRangeVisual = { Enabled = false, Color = Color3.fromRGB(255, 80, 80), Transparency = 0.7 },
    
    AutoSkillCheck = false,
    AutoWiggle = false, WiggleSpam = 5,
    AutoFlee = false, FleeDistance = 50, FleeCooldown = 0.1,
    FastVault = false, VaultAnimSpeed = 1.2,
    VaultSpeedBoost = false, VaultBoostValue = 20,
    FlowstateNoCooldown = false,
    SurvivorSpeedBoost = false, SurvivorSpeedBoostValue = 22,
    GodMode = false,
    
    WalkSpeedEnabled = false, WalkSpeedValue = 17.6, OriginalWalkSpeed = 16,
    JumpPowerEnabled = false, JumpPowerValue = 50, OriginalJumpPower = 50,
    NoClip = false,
    
    GunAim = { Enabled = false, Holding = false, TargetMode = "Killer", Strength = 1, Predict = true, PredictStrength = 0.12, FOV = 250, VisibilityCheck = false, AimPart = "HumanoidRootPart", LockMode = "Hold" },
    AttackAim = { Enabled = false, Holding = false, Strength = 1, Predict = true, PredictStrength = 0.12, FOV = 250, AimPart = "HumanoidRootPart" },
    Killer = { AutoAttack = false, KillAll = false, AutoCarry = false, AutoHook = false, AutoStalk = false, StalkRange = 150, AutoSprint = false, AutoSprintValue = 30, PredictionAttack = false, PredictStrength = 0.15 },
    Moonwalk = { Enabled = false, SpamSpeed = 30, Intensity = 35, SlowSpeed = 13, UseSlow = true, ShowButton = false },
    KillerPropertyDisplay = false,
    HealthStateTracking = true,
}

-- ============ HELPER ============
local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
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

local function getHealthState(plr, char)
    if not char then return "Unknown" end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return "Unknown" end
    local hooked = char:GetAttribute("Hooked") or char:GetAttribute("IsHooked")
    if hooked then return "HOOKED" end
    local knocked = hum.Health <= 0 or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true
    if knocked then return "KNOCKED" end
    if hum.Health < hum.MaxHealth * 0.7 then return "INJURED" end
    return "HEALED"
end

local function getStateColor(state)
    if state == "HOOKED" then return Color3.fromRGB(255, 0, 0)
    elseif state == "KNOCKED" then return Color3.fromRGB(255, 80, 0)
    elseif state == "INJURED" then return Color3.fromRGB(255, 200, 0)
    elseif state == "HEALED" then return Color3.fromRGB(0, 255, 100)
    end
    return Color3.new(1, 1, 1)
end

local KillerAnims = {
    ["rbxassetid://105374834496520"] = true, ["rbxassetid://113255068724446"] = true,
    ["rbxassetid://118907603246885"] = true, ["rbxassetid://129784271201071"] = true,
    ["rbxassetid://117042998468241"] = true, ["rbxassetid://122812055447896"] = true,
    ["rbxassetid://78935059863801"] = true, ["rbxassetid://74968262036854"] = true,
    ["rbxassetid://78432063483146"] = true, ["rbxassetid://132817836308238"] = true,
    ["rbxassetid://133963973694098"] = true, ["rbxassetid://111920872708571"] = true,
}

print("[TiarHub 4D] Bagian 1/5 loaded.")-- ═══════════════════════════════════════════
--  BAGIAN 2/5 : ESP SYSTEM
-- ═══════════════════════════════════════════

-- ============ ESP OBJECTS ============
local ESPObjects = {}
local ESPNames = {}
local StatusESP = {}
local CachedObjects = { Generators = {}, Hooks = {}, Pallets = {}, Windows = {}, Vaults = {}, Bloods = {} }
local CachedSCP = {}

local function removeESP(obj)
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
    if ESPNames[obj] then ESPNames[obj]:Destroy(); ESPNames[obj] = nil end
end

local function createESP(obj, color, showName, nameText)
    if not obj or not obj.Parent then return end
    if not ESPObjects[obj] then
        local h = Instance.new("Highlight")
        h.FillColor = color
        h.OutlineColor = color
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0.3
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = obj
        ESPObjects[obj] = h
        obj.AncestryChanged:Connect(function(_, parent)
            if not parent then removeESP(obj) end
        end)
    else
        ESPObjects[obj].FillColor = color
        ESPObjects[obj].OutlineColor = color
    end
    
    if showName and nameText then
        local head = obj:FindFirstChild("Head") or obj:FindFirstChild("HumanoidRootPart")
        local adornee = head or (obj:IsA("BasePart") and obj)
        if adornee then
            if not ESPNames[obj] then
                local bb = Instance.new("BillboardGui")
                bb.Size = UDim2.new(0, 200, 0, 30)
                bb.AlwaysOnTop = true
                bb.StudsOffset = Vector3.new(0, 3, 0)
                bb.Adornee = adornee
                bb.Parent = obj
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = color
                lbl.TextStrokeTransparency = 0
                lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 14
                lbl.Parent = bb
                ESPNames[obj] = bb
            end
            local bb = ESPNames[obj]
            local lbl = bb:FindFirstChildOfClass("TextLabel")
            if lbl then lbl.Text = nameText; lbl.TextColor3 = color end
        end
    end
end

-- ============ CACHE OBJECT ============
local function cacheObject(obj)
    if not obj then return end
    if not obj:IsA("BasePart") and not obj:IsA("Model") and not obj:IsA("Decal") 
       and not obj:IsA("Texture") and not obj:IsA("ParticleEmitter") then return end
    
    local name = obj.Name
    local lname = string.lower(name)
    
    if name == "Generator" then CachedObjects.Generators[obj] = true
    elseif name == "HookPoint" or (string.find(name, "Hook") and obj:IsA("BasePart")) then CachedObjects.Hooks[obj] = true
    elseif name == "Pallet" or name == "Palletwrong" then CachedObjects.Pallets[obj] = true
    elseif name == "Window" then CachedObjects.Windows[obj] = true
    elseif string.find(name, "Vault") then CachedObjects.Vaults[obj] = true
    end
    
    if lname:find("blood") or lname:find("gore") or lname:find("splat") then
        CachedObjects.Bloods[obj] = true
    end
    
    if lname:find("scp") then CachedSCP[obj] = true end
end

for _, obj in ipairs(workspace:GetDescendants()) do cacheObject(obj) end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(function(obj)
    CachedObjects.Generators[obj] = nil
    CachedObjects.Hooks[obj] = nil
    CachedObjects.Pallets[obj] = nil
    CachedObjects.Windows[obj] = nil
    CachedObjects.Vaults[obj] = nil
    CachedObjects.Bloods[obj] = nil
    CachedSCP[obj] = nil
    removeESP(obj)
end)

-- ============ STATUS ESP ============
local function removeStatusESP(char)
    if StatusESP[char] then StatusESP[char]:Destroy(); StatusESP[char] = nil end
end

local function createStatusESP(player, char, root)
    if not Config.ESPStatus.Enabled then removeStatusESP(char); return end
    if not root then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end
    
    local dist = (head.Position - root.Position).Magnitude
    if dist > Config.ESPStatus.Radius then removeStatusESP(char); return end
    
    local state = getHealthState(player, char)
    local text = ""
    
    if Config.ESPStatus.ShowState and state ~= "HEALED" then
        text = text .. state .. "\n"
    end
    if Config.ESPStatus.ShowName then
        text = text .. "[" .. getTeamLabel(player) .. "] " .. player.Name .. "\n"
    end
    if Config.ESPStatus.ShowDistance then
        text = text .. string.format("Dist: %.0f\n", dist)
    end
    if Config.ESPStatus.ShowHealth then
        text = text .. string.format("HP: %.0f/%.0f", hum.Health, hum.MaxHealth)
    end
    
    if text == "" then removeStatusESP(char); return end
    
    local bb = StatusESP[char]
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 200, 0, 80)
        bb.AlwaysOnTop = true
        bb.StudsOffset = Vector3.new(0, 3.5, 0)
        bb.Adornee = head
        bb.Parent = char
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.Parent = bb
        StatusESP[char] = bb
    end
    
    local lbl = bb:FindFirstChildOfClass("TextLabel")
    if lbl then
        lbl.Text = text
        local tc = Color3.new(1, 1, 1)
        if player.Team then
            if player.Team.Name == "Killer" then tc = Config.ESP_KillerColor
            elseif player.Team.Name == "Survivors" or player.Team.Name == "Survivor" then tc = Config.ESP_SurvivorColor end
        end
        if state == "HOOKED" or state == "KNOCKED" then
            tc = getStateColor(state)
        end
        lbl.TextColor3 = tc
    end
end

-- ============ GENERATOR PROGRESS ============
local function UpdateGenerator(generator)
    if not generator or not generator.Parent then return end
    if not Config.ESP_Generator then
        local old = generator:FindFirstChild("GenHighlight"); if old then old:Destroy() end
        local oldName = generator:FindFirstChild("GenNameTag"); if oldName then oldName:Destroy() end
        return
    end
    
    local percent = 0
    local attr = generator:GetAttribute("Progress") or generator:GetAttribute("RepairProgress")
    if attr and type(attr) == "number" then percent = attr end
    if not attr then
        for _, v in ipairs(generator:GetDescendants()) do
            if v:IsA("ValueBase") and (v.Name == "Progress" or v.Name == "RepairProgress") then
                percent = v.Value; break
            end
        end
    end
    
    percent = math.clamp(percent, 0, 100)
    local color = Config.ESP_GeneratorColor:Lerp(Color3.fromRGB(0, 255, 120), percent / 100)
    
    local h = generator:FindFirstChild("GenHighlight") or Instance.new("Highlight")
    h.Name = "GenHighlight"
    h.Adornee = generator
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.5
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = generator
    
    local bb = generator:FindFirstChild("GenNameTag")
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Name = "GenNameTag"
        bb.Size = UDim2.new(0, 120, 0, 30)
        bb.AlwaysOnTop = true
        bb.StudsOffset = Vector3.new(0, 4, 0)
        bb.Adornee = generator
        bb.Parent = generator
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.Parent = bb
    end
    local lbl = bb:FindFirstChildOfClass("TextLabel")
    if lbl then lbl.Text = string.format("Gen %.0f%%", percent); lbl.TextColor3 = color end
end

-- ============ KILLER INFO DISPLAY ============
local KillerInfoGui = nil

local function updateKillerProperty()
    if not Config.KillerPropertyDisplay then
        if KillerInfoGui then KillerInfoGui.Enabled = false end
        return
    end
    local root = getRoot()
    if not root then 
        if KillerInfoGui then KillerInfoGui.Enabled = false end
        return 
    end
    
    local nearestKiller, nearestDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team and p.Team.Name == "Killer" and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - root.Position).Magnitude
                if d < nearestDist then nearestDist = d; nearestKiller = p end
            end
        end
    end
    
    if not nearestKiller then 
        if KillerInfoGui then KillerInfoGui.Enabled = false end
        return 
    end
    
    if not KillerInfoGui then
        KillerInfoGui = Instance.new("ScreenGui")
        KillerInfoGui.Name = "KillerInfoGui"
        KillerInfoGui.ResetOnSpawn = false
        KillerInfoGui.Parent = PlayerGui
        local frame = Instance.new("Frame")
        frame.Name = "Frame"
        frame.Size = UDim2.new(0, 220, 0, 95)
        frame.Position = UDim2.new(0, 15, 0.5, -47)
        frame.BackgroundColor3 = BLACK_BLUE
        frame.BackgroundTransparency = 0.2
        frame.BorderSizePixel = 0
        frame.Parent = KillerInfoGui
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = frame
        local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(255, 60, 60); s.Thickness = 1.5; s.Parent = frame
        local lbl = Instance.new("TextLabel")
        lbl.Name = "Info"
        lbl.Size = UDim2.new(1, -10, 1, -10)
        lbl.Position = UDim2.new(0, 5, 0, 5)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(255, 200, 200)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextYAlignment = Enum.TextYAlignment.Top
        lbl.TextWrapped = true
        lbl.Parent = frame
    end
    
    KillerInfoGui.Enabled = true
    
    local hum = nearestKiller.Character:FindFirstChildOfClass("Humanoid")
    local info = string.format("🎯 KILLER NEAREST\nNama: %s\nJarak: %.0f stud\nHP: %.0f / %.0f",
        nearestKiller.Name, nearestDist,
        hum and hum.Health or 0, hum and hum.MaxHealth or 0)
    
    local activity = "Idle"
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local anim = track.Animation
                if anim and anim.AnimationId then
                    local id = anim.AnimationId:match("%d+")
                    if id and KillerAnims["rbxassetid://" .. id] then
                        activity = "ATTACKING!"; break
                    end
                end
            end
        end
    end
    
    info = info .. "\nStatus: " .. activity
    local lbl = KillerInfoGui.Frame:FindFirstChild("Info")
    if lbl then
        lbl.Text = info
        lbl.TextColor3 = (activity == "ATTACKING!") and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 200, 200)
    end
end

print("[TiarHub 4D] Bagian 2/5 loaded. ESP System siap.")-- ═══════════════════════════════════════════
--  BAGIAN 3/5 : AUTO PARRY + SURVIVOR + MOVEMENT
-- ═══════════════════════════════════════════

-- ============ AUTO PARRY ============
local lastParry = 0
local ParryActive = false
local ParryCircle = nil
local hookedKillers = {}
local lastKillerParry = {}

local function pressRightClick()
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
        task.wait(0.01)
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
    if now - lastParry < Config.ParryDebounce then return end
    lastParry = now
    ParryActive = true
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
        if not Config.AutoParry then return end
        local anim = track.Animation
        if not anim then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end
        if not KillerAnims["rbxassetid://" .. id] then return end
        
        local myRoot = getRoot()
        local enemyRoot = char:FindFirstChild("HumanoidRootPart")
        if not myRoot or not enemyRoot then return end
        local dist = (enemyRoot.Position - myRoot.Position).Magnitude
        if dist > Config.ParryDistance then return end
        
        local now = tick()
        if lastKillerParry[char] and now - lastKillerParry[char] < 0.4 then return end
        lastKillerParry[char] = now
        doParry()
    end)
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if Config.AutoParry then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
                        hookKiller(p.Character)
                    end
                end
            end
        end)
    end
end)

-- ============ AUTO SKILL CHECK ============
local SkillHeartbeat = nil
local busy = false
local TouchID = 8822
local ActionPath = "Survivor-mob.Controls.action.check"

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
        local p, s, i = b.AbsolutePosition, b.AbsoluteSize, game:GetService("GuiService"):GetGuiInset()
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
            if not Config.AutoSkillCheck or busy then return end
            local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
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
            local success = (startRange > endRange and (lr >= startRange or lr <= endRange))
                or (lr >= startRange and lr <= endRange)
            
            if success then
                busy = true
                task.spawn(function()
                    if UserInputService.TouchEnabled then TriggerMobileButton() else pressSpace() end
                    task.wait(0.05)
                    busy = false
                end)
            end
        end)
    end)
end

-- ============ AUTO WIGGLE ============
local function AutoWiggle()
    if not Config.AutoWiggle then return end
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
    for i = 1, Config.WiggleSpam do event:FireServer() end
end

-- ============ AUTO FLEE ============
local LastFlee = 0

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
            if not Config.AutoFlee then return end
            local root = getRoot()
            if not root then return end
            local killerRoot, distance = GetNearestKiller()
            if killerRoot and distance <= Config.FleeDistance and tick() - LastFlee > Config.FleeCooldown then
                local point = GetFarthestGeneratorPoint(killerRoot)
                if point then
                    LastFlee = tick()
                    root.CFrame = point.CFrame + Vector3.new(0, 5, 0)
                end
            end
        end)
    end
end)

-- ============ FAKE PERKS ============
local LastVaultTime = 0

local function hookFakeFlowstate(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not Config.FastVault then return end
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
            if now - LastVaultTime < 1 then return end
            LastVaultTime = now
            track:Stop()
            local newAnim = Instance.new("Animation")
            newAnim.AnimationId = "rbxassetid://136962284480779"
            local newTrack = animator:LoadAnimation(newAnim)
            newTrack.Priority = Enum.AnimationPriority.Action
            newTrack:Play()
            newTrack:AdjustSpeed(Config.VaultAnimSpeed)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function() hookFakeFlowstate(char) end)
end)
if LocalPlayer.Character then pcall(function() hookFakeFlowstate(LocalPlayer.Character) end) end

-- Vault Speed Boost
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if not Config.VaultSpeedBoost then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if tick() - LastVaultTime < 1 then
                if hum.WalkSpeed < Config.OriginalWalkSpeed + Config.VaultBoostValue then
                    hum.WalkSpeed = Config.OriginalWalkSpeed + Config.VaultBoostValue
                end
            end
        end)
    end
end)

-- Flowstate No Cooldown
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if not Config.FlowstateNoCooldown then return end
            local char = LocalPlayer.Character
            if not char then return end
            char:SetAttribute("FlowstateCooldown", 0)
            char:SetAttribute("VaultCooldown", 0)
            char:SetAttribute("Exhausted", false)
        end)
    end
end)

-- Survivor Speed Boost (crouch)
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if not Config.SurvivorSpeedBoost then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local isCrouching = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
                or (hum.HipHeight and hum.HipHeight < 1.5)
            if isCrouching then
                hum.WalkSpeed = Config.SurvivorSpeedBoostValue
            else
                if not Config.WalkSpeedEnabled and hum.WalkSpeed == Config.SurvivorSpeedBoostValue then
                    hum.WalkSpeed = 16
                end
            end
        end)
    end
end)

-- ============ GOD MODE ============
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if not Config.GodMode then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if hum.Health < hum.MaxHealth then
                pcall(function() hum.Health = hum.MaxHealth end)
            end
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Dead 
                or state == Enum.HumanoidStateType.FallingDown 
                or state == Enum.HumanoidStateType.Ragdoll then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end)
    end
end)

-- ============ WALKSPEED & JUMP & NOCLIP ============
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

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if Config.WalkSpeedEnabled then
                local hum = getHum()
                if hum and not shouldDisableWalkSpeed() then
                    if hum.WalkSpeed ~= Config.WalkSpeedValue then
                        hum.WalkSpeed = Config.WalkSpeedValue
                    end
                end
            end
            if Config.JumpPowerEnabled then
                local hum = getHum()
                if hum and hum.JumpPower ~= Config.JumpPowerValue then
                    hum.JumpPower = Config.JumpPowerValue
                end
            end
            if Config.NoClip then
                local char = LocalPlayer.Character
                if char then
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            end
        end)
    end
end)

-- ============ PARRY CIRCLE VISUAL ============
RunService.RenderStepped:Connect(function()
    pcall(function()
        local root = getRoot()
        if not root or not Config.ParryRangeVisual.Enabled then
            if ParryCircle then ParryCircle:Destroy(); ParryCircle = nil end
            return
        end
        if not ParryCircle then
            ParryCircle = Instance.new("Part")
            ParryCircle.Shape = Enum.PartType.Cylinder
            ParryCircle.Anchored = true
            ParryCircle.CanCollide = false
            ParryCircle.Material = Enum.Material.Neon
            ParryCircle.Parent = workspace
        end
        local size = Config.ParryDistance * 2
        local yOffset = root.Size.Y / 2 + 1.5
        ParryCircle.Size = Vector3.new(0.2, size, size)
        ParryCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0)) * CFrame.Angles(0, 0, math.rad(90))
        ParryCircle.Color = Config.ParryRangeVisual.Color
        ParryCircle.Transparency = Config.ParryRangeVisual.Transparency
    end)
end)

-- ============ MOONWALK ============
local MoonwalkConnection = nil

local function startMoonwalk()
    if MoonwalkConnection then return end
    local hum = getHum()
    if hum then hum.AutoRotate = false end
    MoonwalkConnection = RunService.RenderStepped:Connect(function()
        if not Config.Moonwalk.Enabled or ParryActive then return end
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not (humanoid and hrp and cam) then return end
        humanoid.AutoRotate = false
        if Config.Moonwalk.UseSlow then humanoid.WalkSpeed = Config.Moonwalk.SlowSpeed end
        local look = cam.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit
            local baseCF = CFrame.new(hrp.Position, hrp.Position + flatLook)
            local angle = math.sin(tick() * Config.Moonwalk.SpamSpeed) * Config.Moonwalk.Intensity
            hrp.CFrame = baseCF * CFrame.Angles(0, math.rad(angle), 0)
            humanoid:Move(Vector3.new(0, 0, 1), true)
        end
    end)
end

local function stopMoonwalk()
    if MoonwalkConnection then MoonwalkConnection:Disconnect(); MoonwalkConnection = nil end
    local hum = getHum()
    if hum then
        hum.AutoRotate = true
        hum.WalkSpeed = Config.WalkSpeedEnabled and Config.WalkSpeedValue or Config.OriginalWalkSpeed
    end
end

print("[TiarHub 4D] Bagian 3/5 loaded. Survivor + Movement siap.")-- ═══════════════════════════════════════════
--  BAGIAN 4/5 : AIMBOT + KILLER SYSTEM
-- ═══════════════════════════════════════════

-- ============ FOV CIRCLE ============
local FOVCircle = nil
local FOVCircleVisible = false
local FOVCircleSize = 250
local FOVCircleColor = NEON_BLUE

RunService.RenderStepped:Connect(function()
    pcall(function()
        if FOVCircleVisible then
            if not FOVCircle then
                FOVCircle = Drawing.new("Circle")
                FOVCircle.Thickness = 2
                FOVCircle.NumSides = 80
                FOVCircle.Filled = false
            end
            FOVCircle.Visible = true
            FOVCircle.Radius = FOVCircleSize
            FOVCircle.Color = FOVCircleColor
            FOVCircle.Transparency = 0.6
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        elseif FOVCircle then
            FOVCircle.Visible = false
        end
    end)
end)

-- ============ AIMBOT ============
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
    local closest, shortest = nil, Config.GunAim.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team then
            local valid = false
            if Config.GunAim.TargetMode == "Killer" and p.Team.Name == "Killer" then valid = true
            elseif Config.GunAim.TargetMode == "Survivor" and (p.Team.Name == "Survivors" or p.Team.Name == "Survivor") then valid = true
            elseif Config.GunAim.TargetMode == "Both" then valid = true end
            if valid then
                local hrp = p.Character:FindFirstChild(Config.GunAim.AimPart) or p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest then
                            if not Config.GunAim.VisibilityCheck or isVisible(hrp) then
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

local function getClosestAttackTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, shortest = nil, Config.AttackAim.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team and p.Team.Name == "Survivors" and p.Character then
            local hrp = p.Character:FindFirstChild(Config.AttackAim.AimPart)
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

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    pcall(function()
        if Config.GunAim.Enabled and Config.GunAim.Holding then
            local target = getClosestGunTarget()
            if target then
                local cam = workspace.CurrentCamera
                local pos = target.Position
                if Config.GunAim.Predict then
                    pos = pos + (target.AssemblyLinearVelocity * Config.GunAim.PredictStrength)
                end
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, pos), Config.GunAim.Strength)
            end
        end
        if Config.AttackAim.Enabled and Config.AttackAim.Holding then
            local target = getClosestAttackTarget()
            if target then
                local cam = workspace.CurrentCamera
                local pos = target.Position
                if Config.AttackAim.Predict then
                    pos = pos + (target.AssemblyLinearVelocity * Config.AttackAim.PredictStrength)
                end
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, pos), Config.AttackAim.Strength)
            end
        end
    end)
end)

-- Input Binding untuk Aimbot (RMB)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if Config.GunAim.LockMode == "Hold" then
            Config.GunAim.Holding = true
            Config.AttackAim.Holding = true
        elseif Config.GunAim.LockMode == "Toggle" then
            Config.GunAim.Holding = not Config.GunAim.Holding
            Config.AttackAim.Holding = Config.GunAim.Holding
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if Config.GunAim.LockMode == "Hold" then
            Config.GunAim.Holding = false
            Config.AttackAim.Holding = false
        end
    end
end)

-- ============ KILLER SYSTEM ============
local KillerBusy = false
local KillerTarget = nil
local StalkConnection = nil

local function GetDowned()
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
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
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

-- Auto Stalk
local function startAutoStalk()
    if StalkConnection then return end
    StalkConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not Config.Killer.AutoStalk then return end
            local root = getRoot()
            if not root then return end
            local target, dist = nil, math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 30 then
                        local d = (hrp.Position - root.Position).Magnitude
                        if d <= Config.Killer.StalkRange and d < dist then dist = d; target = p end
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

-- Killer Main Loop
RunService.Heartbeat:Connect(function()
    pcall(function()
        if not getRoot() then return end

        -- Auto Attack
        if Config.Killer.AutoAttack and AttackEvent then
            pcall(function() AttackEvent:FireServer(false) end)
        end

        -- Auto Carry + Hook
        if Config.Killer.AutoCarry and not KillerBusy and CarryEvent then
            KillerBusy = true
            task.spawn(function()
                local target = GetDowned()
                local root = getRoot()
                if target and root then
                    local tRoot = target:FindFirstChild("HumanoidRootPart")
                    if tRoot then
                        root.CFrame = tRoot.CFrame * CFrame.new(0, 3, -2)
                        task.wait(0.4)
                        for i = 1, 4 do CarryEvent:FireServer(target); task.wait(0.2) end
                        task.wait(0.6)
                        if Config.Killer.AutoHook and HookEvent then
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

        -- Kill All
        if Config.Killer.KillAll and AttackEvent then
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

        -- Prediction Attack
        if Config.Killer.PredictionAttack and AttackEvent then
            local root = getRoot()
            if root then
                local target = GetNearestAliveSurvivor()
                if target then
                    local hrp = target:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local d = (hrp.Position - root.Position).Magnitude
                        if d < 15 then
                            local vel = hrp.AssemblyLinearVelocity
                            local predPos = hrp.Position + (vel * Config.Killer.PredictStrength)
                            local myHum = getHum()
                            if myHum then myHum.AutoRotate = false end
                            root.CFrame = CFrame.new(root.Position, predPos)
                            pcall(function() AttackEvent:FireServer(false) end)
                        end
                    end
                end
            end
        end

        -- Auto Sprint
        if Config.Killer.AutoSprint then
            local hum = getHum()
            if hum and hum.WalkSpeed < Config.Killer.AutoSprintValue then
                local target = GetNearestAliveSurvivor()
                if target then
                    local hrp = target:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local myRoot = getRoot()
                        if myRoot then
                            local d = (hrp.Position - myRoot.Position).Magnitude
                            if d < 100 then hum.WalkSpeed = Config.Killer.AutoSprintValue end
                        end
                    end
                end
            end
        end
    end)
end)

print("[TiarHub 4D] Bagian 4/5 loaded. Aimbot + Killer siap.")-- ═══════════════════════════════════════════
--  BAGIAN 5/5 : MAIN LOOP + UI + STARTUP
-- ═══════════════════════════════════════════

-- ============ TABS ============
local Tabs = {
    Combat   = Window:AddTab("Combat",   "sword"),
    Movement = Window:AddTab("Movement", "activity"),
    Killer   = Window:AddTab("Killer",   "skull"),
    Visuals  = Window:AddTab("Visuals",  "eye"),
    Settings = Window:AddTab("Settings", "settings"),
}

-- ============ MAIN ESP LOOP ============
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            local root = getRoot()
            if not root then return end
            
            -- Player ESP
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local char = p.Character
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local dist = (hrp.Position - root.Position).Magnitude
                            if dist <= Config.ESP_Distance then
                                local isKiller = p.Team and p.Team.Name == "Killer"
                                local isSurv = p.Team and (p.Team.Name == "Survivors" or p.Team.Name == "Survivor")
                                if Config.ESP_Survivor and isSurv then
                                    createESP(char, Config.ESP_SurvivorColor, true, getTeamLabel(p) .. " | " .. p.Name)
                                elseif Config.ESP_Killer and isKiller then
                                    createESP(char, Config.ESP_KillerColor, true, getTeamLabel(p) .. " | " .. p.Name)
                                else
                                    removeESP(char)
                                end
                            else removeESP(char) end
                        end
                        createStatusESP(p, char, root)
                    else
                        removeESP(char); removeStatusESP(char)
                    end
                end
            end
            
            -- Generator
            if Config.ESP_Generator then
                for gen in pairs(CachedObjects.Generators) do
                    local pos = GetPos(gen)
                    if pos and (pos - root.Position).Magnitude <= Config.ESP_Distance then
                        UpdateGenerator(gen)
                    else
                        local old = gen:FindFirstChild("GenHighlight"); if old then old:Destroy() end
                        local oldName = gen:FindFirstChild("GenNameTag"); if oldName then oldName:Destroy() end
                    end
                end
            end
            
            -- Hook
            if Config.ESP_Hook then
                for hook in pairs(CachedObjects.Hooks) do
                    local pos = GetPos(hook)
                    if pos and (pos - root.Position).Magnitude <= Config.ESP_Distance then
                        createESP(hook, Config.ESP_HookColor)
                    else removeESP(hook) end
                end
            else for h in pairs(CachedObjects.Hooks) do removeESP(h) end end
            
            -- Pallet
            if Config.ESP_Pallet then
                for pallet in pairs(CachedObjects.Pallets) do
                    local pos = GetPos(pallet)
                    if pos and (pos - root.Position).Magnitude <= Config.ESP_Distance then
                        createESP(pallet, Config.ESP_PalletColor)
                    else removeESP(pallet) end
                end
            else for p in pairs(CachedObjects.Pallets) do removeESP(p) end end
            
            -- Window
            if Config.ESP_Window then
                for win in pairs(CachedObjects.Windows) do
                    local pos = GetPos(win)
                    if pos and (pos - root.Position).Magnitude <= Config.ESP_Distance then
                        createESP(win, Config.ESP_WindowColor)
                    else removeESP(win) end
                end
            else for w in pairs(CachedObjects.Windows) do removeESP(w) end end
            
            -- Vault
            if Config.ESP_Vault then
                for v in pairs(CachedObjects.Vaults) do
                    local pos = GetPos(v)
                    if pos and (pos - root.Position).Magnitude <= Config.ESP_Distance then
                        createESP(v, Config.ESP_VaultColor)
                    else removeESP(v) end
                end
            else for v in pairs(CachedObjects.Vaults) do removeESP(v) end end
            
            -- Blood
            if Config.ESP_Blood then
                for b in pairs(CachedObjects.Bloods) do
                    if b:IsA("BasePart") then
                        local pos = b.Position
                        if (pos - root.Position).Magnitude <= Config.ESP_Distance then
                            createESP(b, Config.ESP_BloodColor)
                        else removeESP(b) end
                    end
                end
            else for b in pairs(CachedObjects.Bloods) do removeESP(b) end end
            
            -- SCP
            if Config.ESP_SCP then
                for scp in pairs(CachedSCP) do
                    local pos = GetPos(scp)
                    if pos and (pos - root.Position).Magnitude <= Config.ESP_Distance then
                        createESP(scp, Config.ESP_SCPColor)
                    else removeESP(scp) end
                end
            else for s in pairs(CachedSCP) do removeESP(s) end end
            
            updateKillerProperty()
            AutoWiggle()
        end)
    end
end)

-- ═══════════════════════════════════════════
--  TAB 1 : COMBAT (SURVIVOR)
-- ═══════════════════════════════════════════
local CombatLeft = Tabs.Combat:AddLeftGroupbox("Auto Parry", "shield")
local CombatRight = Tabs.Combat:AddRightGroupbox("Survivor Features", "user")

CombatLeft:AddToggle("AutoParry", {
    Text = "Auto Parry",
    Default = false,
    Callback = function(v) Config.AutoParry = v end,
}):AddKeybind({ Text = "Keybind", Default = Enum.KeyCode.Q })

CombatLeft:AddDropdown("ParryMode", {
    Text = "Parry Mode",
    Values = {"Instant", "Delayed", "Predictive"},
    Default = "Instant",
    Multi = false,
    Callback = function(v) Config.ParryMode = v end,
})

CombatLeft:AddSlider("ParryRange", {
    Text = "Detection Range",
    Default = 15, Min = 5, Max = 50,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) Config.ParryDistance = v end,
})

CombatLeft:AddToggle("ShowRange", {
    Text = "Show Parry Range",
    Default = false,
    Callback = function(v) Config.ParryRangeVisual.Enabled = v end,
})

CombatLeft:AddColorPicker("RangeColor", {
    Text = "Range Color",
    Default = Color3.fromRGB(255, 80, 80),
    Callback = function(c) Config.ParryRangeVisual.Color = c end,
})

CombatRight:AddToggle("AutoSkillCheck", {
    Text = "Auto Skill Check",
    Default = false,
    Callback = function(v) 
        Config.AutoSkillCheck = v
        if v then startSkillCheck() end
    end,
})

CombatRight:AddToggle("AutoWiggle", {
    Text = "Auto Wiggle",
    Default = false,
    Callback = function(v) Config.AutoWiggle = v end,
})

CombatRight:AddSlider("WiggleSpam", {
    Text = "Wiggle Spam",
    Default = 5, Min = 1, Max = 10,
    Rounding = 0, Suffix = "x",
    Callback = function(v) Config.WiggleSpam = v end,
})

CombatRight:AddToggle("AutoFlee", {
    Text = "Auto Flee Killer",
    Default = false,
    Callback = function(v) Config.AutoFlee = v end,
})

CombatRight:AddSlider("FleeDistance", {
    Text = "Flee Detect Distance",
    Default = 50, Min = 10, Max = 200,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) Config.FleeDistance = v end,
})

CombatRight:AddDivider()

CombatRight:AddToggle("GodMode", {
    Text = "God Mode (Anti Knock)",
    Default = false,
    Callback = function(v) Config.GodMode = v end,
})

-- ═══════════════════════════════════════════
--  TAB 2 : MOVEMENT
-- ═══════════════════════════════════════════
local MoveLeft = Tabs.Movement:AddLeftGroupbox("Speed", "zap")
local MoveRight = Tabs.Movement:AddRightGroupbox("Vault & Movement", "move")

MoveLeft:AddToggle("WalkSpeedToggle", {
    Text = "Walk Speed",
    Default = false,
    Callback = function(v)
        Config.WalkSpeedEnabled = v
        if not v then
            local hum = getHum()
            if hum then hum.WalkSpeed = Config.OriginalWalkSpeed end
        end
    end,
})

MoveLeft:AddSlider("WalkSpeedSlider", {
    Text = "Walk Speed Value",
    Default = 17.6, Min = 16, Max = 100,
    Rounding = 1,
    Callback = function(v) Config.WalkSpeedValue = v end,
})

MoveLeft:AddToggle("SpeedBoostSurvivor", {
    Text = "Survivor Speed Boost (Crouch)",
    Default = false,
    Callback = function(v) Config.SurvivorSpeedBoost = v end,
})

MoveLeft:AddSlider("SurvivorSpeedValue", {
    Text = "Speed Boost Value",
    Default = 22, Min = 16, Max = 100,
    Rounding = 0,
    Callback = function(v) Config.SurvivorSpeedBoostValue = v end,
})

MoveLeft:AddDivider()

MoveLeft:AddToggle("JumpPowerToggle", {
    Text = "Custom Jump Power",
    Default = false,
    Callback = function(v)
        Config.JumpPowerEnabled = v
        if not v then
            local hum = getHum()
            if hum then hum.JumpPower = Config.OriginalJumpPower end
        end
    end,
})

MoveLeft:AddSlider("JumpPowerSlider", {
    Text = "Jump Power Value",
    Default = 50, Min = 0, Max = 300,
    Rounding = 0,
    Callback = function(v) Config.JumpPowerValue = v end,
})

MoveLeft:AddToggle("NoClipToggle", {
    Text = "No Clip",
    Default = false,
    Callback = function(v) Config.NoClip = v end,
})

MoveRight:AddToggle("FastVault", {
    Text = "Fast Vault",
    Default = false,
    Callback = function(v) Config.FastVault = v end,
})

MoveRight:AddSlider("VaultSpeed", {
    Text = "Animation Speed",
    Default = 1.2, Min = 1, Max = 5,
    Rounding = 1, Suffix = "x",
    Callback = function(v) Config.VaultAnimSpeed = v end,
})

MoveRight:AddToggle("VaultSpeedBoost", {
    Text = "Vault Speed Boost",
    Default = false,
    Callback = function(v) Config.VaultSpeedBoost = v end,
})

MoveRight:AddSlider("VaultBoostValue", {
    Text = "Vault Boost Value",
    Default = 20, Min = 5, Max = 50,
    Rounding = 0,
    Callback = function(v) Config.VaultBoostValue = v end,
})

MoveRight:AddToggle("FlowstateNoCooldown", {
    Text = "Flowstate No Cooldown",
    Default = false,
    Callback = function(v) Config.FlowstateNoCooldown = v end,
})

MoveRight:AddDivider()

MoveRight:AddToggle("MoonwalkToggle", {
    Text = "Moonwalk",
    Default = false,
    Callback = function(v)
        Config.Moonwalk.Enabled = v
        if v then startMoonwalk() else stopMoonwalk() end
    end,
})

MoveRight:AddSlider("MoonwalkSpeed", {
    Text = "Spam Speed",
    Default = 30, Min = 1, Max = 50,
    Rounding = 0,
    Callback = function(v) Config.Moonwalk.SpamSpeed = v end,
})

MoveRight:AddSlider("MoonwalkIntensity", {
    Text = "Intensity",
    Default = 35, Min = 1, Max = 50,
    Rounding = 0,
    Callback = function(v) Config.Moonwalk.Intensity = v end,
})

MoveRight:AddButton({
    Text = "Instant Escape",
    Func = function()
        local root = getRoot()
        if not root then return end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if string.lower(obj.Name) == "fininshline" and obj:IsA("BasePart") then
                root.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                Library:Notify({ Title = "Escaped!", Duration = 2 })
                return
            end
        end
    end,
})

-- ═══════════════════════════════════════════
--  TAB 3 : KILLER
-- ═══════════════════════════════════════════
local KillerLeft = Tabs.Killer:AddLeftGroupbox("Attack", "sword")
local KillerRight = Tabs.Killer:AddRightGroupbox("Aim Lock & Power", "skull")

KillerLeft:AddToggle("AutoAttack", {
    Text = "Auto Spam Attack",
    Default = false,
    Callback = function(v) Config.Killer.AutoAttack = v end,
})

KillerLeft:AddToggle("KillAll", {
    Text = "Auto Kill All",
    Default = false,
    Callback = function(v) Config.Killer.KillAll = v end,
})

KillerLeft:AddToggle("PredictionAttack", {
    Text = "Prediction Attack",
    Default = false,
    Callback = function(v) Config.Killer.PredictionAttack = v end,
})

KillerLeft:AddSlider("PredictionStrength", {
    Text = "Prediction Strength",
    Default = 0.15, Min = 0, Max = 1,
    Rounding = 2,
    Callback = function(v) Config.Killer.PredictStrength = v end,
})

KillerLeft:AddDivider()

KillerLeft:AddToggle("AutoCarry", {
    Text = "Auto Carry Downed",
    Default = false,
    Callback = function(v) Config.Killer.AutoCarry = v end,
})

KillerLeft:AddToggle("AutoHookAfterCarry", {
    Text = "Auto Hook After Carry",
    Default = false,
    Callback = function(v) Config.Killer.AutoHook = v end,
})

KillerLeft:AddToggle("AutoStalk", {
    Text = "Auto Stalk",
    Default = false,
    Callback = function(v)
        Config.Killer.AutoStalk = v
        if v then startAutoStalk() else stopAutoStalk() end
    end,
})

KillerLeft:AddSlider("StalkRange", {
    Text = "Stalk Range",
    Default = 150, Min = 50, Max = 500,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) Config.Killer.StalkRange = v end,
})

KillerRight:AddToggle("GunAimEnabled", {
    Text = "Aim Lock",
    Default = false,
    Callback = function(v) Config.GunAim.Enabled = v end,
})

KillerRight:AddDropdown("GunAimTarget", {
    Values = {"Killer", "Survivor", "Both"},
    Default = "Survivor",
    Text = "Target",
    Callback = function(v) Config.GunAim.TargetMode = v end,
})

KillerRight:AddDropdown("GunAimPart", {
    Text = "Aim Part",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Default = "HumanoidRootPart",
    Callback = function(v) Config.GunAim.AimPart = v end,
})

KillerRight:AddSlider("GunAimFOV", {
    Text = "FOV",
    Default = 250, Min = 50, Max = 1000,
    Rounding = 0,
    Callback = function(v) Config.GunAim.FOV = v end,
})

KillerRight:AddSlider("GunAimPredict", {
    Text = "Prediction",
    Default = 0.12, Min = 0, Max = 1,
    Rounding = 2,
    Callback = function(v) Config.GunAim.PredictStrength = v end,
})

KillerRight:AddDropdown("LockMode", {
    Text = "Lock Mode",
    Values = {"Hold", "Toggle"},
    Default = "Hold",
    Callback = function(v) Config.GunAim.LockMode = v end,
})

KillerRight:AddDropdown("SelectPower", {
    Text = "Select Power",
    Values = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"},
    Default = "Cobra",
    Callback = function(v) 
        local ev = findRemote("Remotes.Killers.Masked.Activatepower")
        if ev then ev:FireServer(v) end
    end,
})

KillerRight:AddButton({
    Text = "Deactivate Power",
    Func = function()
        local ev = findRemote("Remotes.Killers.Masked.Deactivatepower")
        if ev then ev:FireServer() end
    end,
})

-- ═══════════════════════════════════════════
--  TAB 4 : VISUALS (ESP)
-- ═══════════════════════════════════════════
local VisLeft = Tabs.Visuals:AddLeftGroupbox("Player ESP", "eye")
local VisRight = Tabs.Visuals:AddRightGroupbox("Map ESP", "map")

VisLeft:AddToggle("ESPSurvivor", {
    Text = "ESP Survivor",
    Default = false,
    Callback = function(v) Config.ESP_Survivor = v end,
})

VisLeft:AddColorPicker("ESP_SurvivorColor", {
    Text = "Survivor Color",
    Default = Color3.fromRGB(60, 255, 120),
    Callback = function(c) Config.ESP_SurvivorColor = c end,
})

VisLeft:AddToggle("ESPKiller", {
    Text = "ESP Killer",
    Default = false,
    Callback = function(v) Config.ESP_Killer = v end,
})

VisLeft:AddColorPicker("ESP_KillerColor", {
    Text = "Killer Color",
    Default = Color3.fromRGB(255, 60, 60),
    Callback = function(c) Config.ESP_KillerColor = c end,
})

VisLeft:AddDivider()

VisLeft:AddToggle("ESPStatus", {
    Text = "ESP Status (Health/Distance)",
    Default = false,
    Callback = function(v) Config.ESPStatus.Enabled = v end,
})

VisLeft:AddToggle("ESPStatusHealth", {
    Text = "Show Health",
    Default = false,
    Callback = function(v) Config.ESPStatus.ShowHealth = v end,
})

VisLeft:AddToggle("ESPStatusState", {
    Text = "Show Health State",
    Default = true,
    Callback = function(v) Config.ESPStatus.ShowState = v end,
})

VisLeft:AddSlider("ESPStatusRadius", {
    Text = "Status Radius",
    Default = 200, Min = 20, Max = 1000,
    Rounding = 0,
    Callback = function(v) Config.ESPStatus.Radius = v end,
})

VisRight:AddToggle("ESPGenerator", {
    Text = "ESP Generator (%)",
    Default = false,
    Callback = function(v) Config.ESP_Generator = v end,
})

VisRight:AddColorPicker("ESP_GenColor", {
    Text = "Generator Color",
    Default = Color3.fromRGB(255, 170, 0),
    Callback = function(c) Config.ESP_GeneratorColor = c end,
})

VisRight:AddToggle("ESPHook", {
    Text = "ESP Hook",
    Default = false,
    Callback = function(v) Config.ESP_Hook = v end,
})

VisRight:AddColorPicker("ESP_HookColor", {
    Text = "Hook Color",
    Default = Color3.fromRGB(180, 80, 255),
    Callback = function(c) Config.ESP_HookColor = c end,
})

VisRight:AddToggle("ESPPallet", {
    Text = "ESP Pallet",
    Default = false,
    Callback = function(v) Config.ESP_Pallet = v end,
})

VisRight:AddColorPicker("ESP_PalletColor", {
    Text = "Pallet Color",
    Default = Color3.fromRGB(255, 220, 80),
    Callback = function(c) Config.ESP_PalletColor = c end,
})

VisRight:AddToggle("ESPWindow", {
    Text = "ESP Window",
    Default = false,
    Callback = function(v) Config.ESP_Window = v end,
})

VisRight:AddToggle("ESPVault", {
    Text = "ESP Vault",
    Default = false,
    Callback = function(v) Config.ESP_Vault = v end,
})

VisRight:AddToggle("ESPBlood", {
    Text = "ESP Blood",
    Default = false,
    Callback = function(v) Config.ESP_Blood = v end,
})

VisRight:AddColorPicker("ESP_BloodColor", {
    Text = "Blood Color",
    Default = Color3.fromRGB(255, 30, 30),
    Callback = function(c) Config.ESP_BloodColor = c end,
})

VisRight:AddToggle("ESFSCP", {
    Text = "ESP SCP",
    Default = false,
    Callback = function(v) Config.ESP_SCP = v end,
})

VisRight:AddSlider("ESPRadius", {
    Text = "ESP Radius",
    Default = 500, Min = 50, Max = 5000,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) Config.ESP_Distance = v end,
})

VisRight:AddDivider()

VisRight:AddToggle("KillerPropertyDisplay", {
    Text = "Killer Info Display",
    Default = false,
    Callback = function(v) Config.KillerPropertyDisplay = v end,
})

VisRight:AddToggle("FOVCircleToggle", {
    Text = "Show FOV Circle",
    Default = false,
    Callback = function(v) FOVCircleVisible = v end,
})

-- ═══════════════════════════════════════════
--  TAB 5 : SETTINGS
-- ═══════════════════════════════════════════
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("TiarHub4D")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

-- ═══════════════════════════════════════════
--  📊 STATS PANEL
-- ═══════════════════════════════════════════
local statsGui = Instance.new("ScreenGui")
statsGui.Name = "TiarHubStats"
statsGui.ResetOnSpawn = false
statsGui.Parent = CoreGui

local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(0, 150, 0, 90)
statsFrame.Position = UDim2.new(1, -170, 0, 20)
statsFrame.BackgroundColor3 = BLACK_BLUE
statsFrame.BackgroundTransparency = 0.2
statsFrame.BorderSizePixel = 0
statsFrame.Parent = statsGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = statsFrame

local stroke = Instance.new("UIStroke")
stroke.Color = NEON_BLUE
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = statsFrame

local statsTitle = Instance.new("TextLabel")
statsTitle.Text = "STATS"
statsTitle.Font = Enum.Font.GothamBlack
statsTitle.TextSize = 14
statsTitle.TextColor3 = CYAN_ACCENT
statsTitle.BackgroundTransparency = 1
statsTitle.Size = UDim2.new(1, 0, 0, 20)
statsTitle.Position = UDim2.new(0, 0, 0, 5)
statsTitle.Parent = statsFrame

local statsText = Instance.new("TextLabel")
statsText.Name = "StatsText"
statsText.Font = Enum.Font.GothamBold
statsText.TextSize = 13
statsText.TextColor3 = WHITE_BLUE
statsText.BackgroundTransparency = 1
statsText.Size = UDim2.new(1, -10, 1, -25)
statsText.Position = UDim2.new(0, 5, 0, 25)
statsText.TextXAlignment = Enum.TextXAlignment.Left
statsText.TextYAlignment = Enum.TextYAlignment.Top
statsText.Text = "FPS: --\nPing: --\nPlayers: --"
statsText.Parent = statsFrame

task.spawn(function()
    while statsFrame.Parent do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local players = #Players:GetPlayers()
        statsText.Text = string.format("FPS: %d\nPing: %d ms\nPlayers: %d", fps, ping, players)
        task.wait(1)
    end
end)

-- ═══════════════════════════════════════════
--  ⌨️ KEYBIND TOGGLE GUI (RightControl)
-- ═══════════════════════════════════════════
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        if Window.UI then Window.UI.Visible = guiVisible end
        statsFrame.Visible = guiVisible
        Library:Notify({ Title = guiVisible and "GUI Shown" or "GUI Hidden", Duration = 2 })
    end
end)

-- ═══════════════════════════════════════════
--  📢 NOTIF STARTUP
-- ═══════════════════════════════════════════
Library:Notify({
    Title = "TIARHUB 4D",
    Description = "Loaded Successfully - Violence District",
    Time = 5,
})

print("============================================")
print("  ⚡ TIARHUB 4D + FALLENS FEATURES ⚡")
print("  ✅ All Features Loaded")
print("============================================")
