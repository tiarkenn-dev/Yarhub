-- ═══════════════════════════════════════════
--   TIARHUB 4D - FULL EDITION
--   Auto Parry 360° + Moonwalk + ESP + Skill Check
-- ═══════════════════════════════════════════

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true

-- ═══ SERVICES ═══
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ═══ SPLASH SCREEN ═══
local function ShowSplash()
    local splash = Instance.new("ScreenGui")
    splash.Name = "TiarHubSplash"
    splash.IgnoreGuiInset = true
    splash.Parent = CoreGui
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(5, 10, 25)
    bg.BorderSizePixel = 0
    bg.Parent = splash
    
    local title = Instance.new("TextLabel")
    title.Text = "TIARHUB 4D"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 60
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
    
    task.wait(1.5)
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

-- ═══ WINDOW ═══
local Window = Library:CreateWindow({
    Title = "TIARHUB 4D",
    Footer = "Violence District",
    Icon = 0,
    NotifySide = "Right",
    ShowCustomCursor = true,
    Size = UDim2.fromOffset(540, 400),
})

task.wait(0.1)
if Window.UI then
    Window.UI.Position = UDim2.new(0.5, 0, 0.03, 0)
    Window.UI.AnchorPoint = Vector2.new(0.5, 0)
end

-- ═══ PALET WARNA ═══
local NEON_BLUE   = Color3.fromRGB(30, 150, 255)
local BLACK_BLUE  = Color3.fromRGB(10, 20, 40)
local WHITE_BLUE  = Color3.fromRGB(220, 235, 255)
local CYAN_ACCENT = Color3.fromRGB(0, 255, 255)

-- ═══ CONFIG ═══
local Config = {
    -- Auto Parry
    AutoParry = false,
    ParryDistance = 15,
    ParryDebounce = 0.15,
    Parry360 = true,  -- parry 360°, gak peduli arah hadap

    -- Auto Skill Check
    AutoSkillCheck = false,
    SkillCheckMode = "Perfect",

    -- Moonwalk
    Moonwalk = false,
    MoonwalkSpam = 30,
    MoonwalkIntensity = 35,
    MoonwalkSlowSpeed = 13,
    MoonwalkButton = false,

    -- ESP
    ESP_Survivor = false,
    ESP_Killer = false,
    ESP_Generator = false,
    ESP_Distance = 500,
    ESP_NameSize = 14,
    ESP_ShowName = true,
    ESP_ShowDistance = true,
    ESP_ShowProgress = true,
    ESP_SurvivorColor = Color3.fromRGB(60, 255, 120),
    ESP_KillerColor = Color3.fromRGB(255, 60, 60),
    ESP_GeneratorColor = Color3.fromRGB(255, 170, 0),
}

-- ═══ HELPER ═══
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

local function findRemote(path)
    local cur = ReplicatedStorage
    for segment in string.gmatch(path, "[^%.]+") do
        cur = cur and cur:FindFirstChild(segment)
        if not cur then return nil end
    end
    return cur
end

-- Animasi attack killer
local KillerAnims = {
    ["rbxassetid://105374834496520"] = true, ["rbxassetid://113255068724446"] = true,
    ["rbxassetid://118907603246885"] = true, ["rbxassetid://129784271201071"] = true,
    ["rbxassetid://117042998468241"] = true, ["rbxassetid://122812055447896"] = true,
    ["rbxassetid://78935059863801"] = true, ["rbxassetid://74968262036854"] = true,
    ["rbxassetid://78432063483146"] = true, ["rbxassetid://132817836308238"] = true,
    ["rbxassetid://133963973694098"] = true, ["rbxassetid://111920872708571"] = true,
    ["rbxassetid://80411309607666"] = true, ["rbxassetid://98163597193511"] = true,
    ["rbxassetid://82666958311998"] = true, ["rbxassetid://110355011987939"] = true,
}

-- ═══ ESP SYSTEM ═══
local ESPObjects = {}
local ESPNames = {}
local CachedObjects = { Generators = {} }

local function removeESP(obj)
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
    if ESPNames[obj] then ESPNames[obj]:Destroy(); ESPNames[obj] = nil end
end

local function createESP(obj, color, nameText)
    if not obj or not obj.Parent then return end
    
    -- Highlight
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
    
    -- Name Tag
    if Config.ESP_ShowName and nameText then
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
                lbl.TextSize = Config.ESP_NameSize
                lbl.Parent = bb
                ESPNames[obj] = bb
            end
            
            local bb = ESPNames[obj]
            local lbl = bb:FindFirstChildOfClass("TextLabel")
            if lbl then
                lbl.Text = nameText
                lbl.TextColor3 = color
                lbl.TextSize = Config.ESP_NameSize  -- Update size tiap frame
            end
        end
    end
end

-- Cache generator
local function cacheObject(obj)
    if not obj or not obj.Parent then return end
    if obj:IsA("BasePart") or obj:IsA("Model") then
        if obj.Name == "Generator" then
            CachedObjects.Generators[obj] = true
        end
    end
end

for _, obj in ipairs(workspace:GetDescendants()) do cacheObject(obj) end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(function(obj)
    CachedObjects.Generators[obj] = nil
    removeESP(obj)
end)

-- Update generator dengan progress
local function UpdateGenerator(generator)
    if not generator or not generator.Parent then return end
    if not Config.ESP_Generator then
        local h = generator:FindFirstChild("GenHighlight"); if h then h:Destroy() end
        local n = generator:FindFirstChild("GenNameTag"); if n then n:Destroy() end
        return
    end
    
    -- Baca progress
    local percent = 0
    local found = false
    local attr = generator:GetAttribute("Progress") or generator:GetAttribute("RepairProgress")
    if attr and type(attr) == "number" then percent = attr; found = true end
    
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
    
    -- Warna gradient dari kuning ke hijau sesuai progress
    local color = Config.ESP_GeneratorColor:Lerp(Color3.fromRGB(0, 255, 100), percent / 100)
    
    -- Highlight
    local h = generator:FindFirstChild("GenHighlight") or Instance.new("Highlight")
    h.Name = "GenHighlight"
    h.Adornee = generator
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.5
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = generator
    
    -- Billboard dengan progress
    local bb = generator:FindFirstChild("GenNameTag")
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Name = "GenNameTag"
        bb.Size = UDim2.new(0, 150, 0, 40)
        bb.AlwaysOnTop = true
        bb.StudsOffset = Vector3.new(0, 4, 0)
        bb.Adornee = generator
        bb.Parent = generator
        
        local lbl = Instance.new("TextLabel")
        lbl.Name = "Label"
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = Config.ESP_NameSize
        lbl.Parent = bb
    end
    
    local lbl = bb:FindFirstChild("Label")
    if lbl then
        if Config.ESP_ShowProgress and found then
            lbl.Text = string.format("Generator\n%.0f%%", percent)
        else
            lbl.Text = "Generator"
        end
        lbl.TextColor3 = color
        lbl.TextSize = Config.ESP_NameSize
    end
end

-- ═══ AUTO PARRY (360° — GAK PEDULI ARAH HADAP) ═══
local lastParry = 0
local ParryActive = false
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
        
        -- 🔥 Cek radius (bukan facing arah lagi — jadi parry 360°)
        local myRoot = getRoot()
        local enemyRoot = char:FindFirstChild("HumanoidRootPart")
        if not myRoot or not enemyRoot then return end
        local dist = (enemyRoot.Position - myRoot.Position).Magnitude
        if dist > Config.ParryDistance then return end
        
        -- Debounce per killer
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

-- ═══ AUTO SKILL CHECK (PERFECT) ═══
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

-- ═══ MOONWALK ═══
local MoonwalkConnection = nil
local MoonwalkButtonGui = nil

local function startMoonwalk()
    if MoonwalkConnection then return end
    local hum = getHum()
    if hum then hum.AutoRotate = false end
    MoonwalkConnection = RunService.RenderStepped:Connect(function()
        if not Config.Moonwalk or ParryActive then return end
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not (humanoid and hrp and cam) then return end
        humanoid.AutoRotate = false
        if humanoid.WalkSpeed ~= Config.MoonwalkSlowSpeed then
            humanoid.WalkSpeed = Config.MoonwalkSlowSpeed
        end
        local look = cam.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit
            local baseCF = CFrame.new(hrp.Position, hrp.Position + flatLook)
            local angle = math.sin(tick() * Config.MoonwalkSpam) * Config.MoonwalkIntensity
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
        hum.WalkSpeed = 16
    end
end

local function createMoonwalkButton()
    if MoonwalkButtonGui then MoonwalkButtonGui:Destroy() end
    
    MoonwalkButtonGui = Instance.new("ScreenGui")
    MoonwalkButtonGui.Name = "TiarMoonwalkBtn"
    MoonwalkButtonGui.ResetOnSpawn = false
    MoonwalkButtonGui.Parent = PlayerGui
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = UDim2.new(0.75, 0, 0.7, 0)
    btn.BackgroundColor3 = BLACK_BLUE
    btn.BackgroundTransparency = 0.2
    btn.Text = "🌙"
    btn.TextSize = 30
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = MoonwalkButtonGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = NEON_BLUE
    stroke.Thickness = 2
    stroke.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Config.Moonwalk = not Config.Moonwalk
        if Config.Moonwalk then
            stroke.Color = Color3.fromRGB(255, 100, 255)
            startMoonwalk()
            Library:Notify({ Title = "Moonwalk ON", Time = 2 })
        else
            stroke.Color = NEON_BLUE
            stopMoonwalk()
            Library:Notify({ Title = "Moonwalk OFF", Time = 2 })
        end
    end)
end

local function removeMoonwalkButton()
    if MoonwalkButtonGui then MoonwalkButtonGui:Destroy(); MoonwalkButtonGui = nil end
end

-- ═══ MAIN ESP LOOP ═══
task.spawn(function()
    while task.wait(0.15) do
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
                                    local txt = ""
                                    if Config.ESP_ShowName then
                                        txt = string.format("[%s] %s", getTeamLabel(p), p.Name)
                                    end
                                    if Config.ESP_ShowDistance then
                                        txt = txt .. string.format("\n%.0f studs", dist)
                                    end
                                    createESP(char, Config.ESP_SurvivorColor, txt)
                                elseif Config.ESP_Killer and isKiller then
                                    local txt = ""
                                    if Config.ESP_ShowName then
                                        txt = string.format("[%s] %s", getTeamLabel(p), p.Name)
                                    end
                                    if Config.ESP_ShowDistance then
                                        txt = txt .. string.format("\n%.0f studs", dist)
                                    end
                                    createESP(char, Config.ESP_KillerColor, txt)
                                else
                                    removeESP(char)
                                end
                            else
                                removeESP(char)
                            end
                        end
                    else
                        removeESP(char)
                    end
                end
            end
            
            -- Generator ESP
            if Config.ESP_Generator then
                for gen in pairs(CachedObjects.Generators) do
                    local pos = GetPos(gen)
                    if pos and (pos - root.Position).Magnitude <= Config.ESP_Distance then
                        UpdateGenerator(gen)
                    else
                        local h = gen:FindFirstChild("GenHighlight"); if h then h:Destroy() end
                        local n = gen:FindFirstChild("GenNameTag"); if n then n:Destroy() end
                    end
                end
            else
                for gen in pairs(CachedObjects.Generators) do
                    local h = gen:FindFirstChild("GenHighlight"); if h then h:Destroy() end
                    local n = gen:FindFirstChild("GenNameTag"); if n then n:Destroy() end
                end
            end
        end)
    end
end)

-- ═══════════════════════════════════════════
--  TABS
-- ═══════════════════════════════════════════
local Tabs = {
    Combat   = Window:AddTab("Combat",   "sword"),
    Movement = Window:AddTab("Movement", "activity"),
    Visuals  = Window:AddTab("Visuals",  "eye"),
    Settings = Window:AddTab("Settings", "settings"),
}

-- ═══ TAB COMBAT ═══
local CombatLeft  = Tabs.Combat:AddLeftGroupbox("Auto Parry", "shield")
local CombatRight = Tabs.Combat:AddRightGroupbox("Survivor Features", "user")

CombatLeft:AddToggle("AutoParry", {
    Text = "Auto Parry (360°)",
    Default = false,
    Tooltip = "Parry walau hadap belakang/depan/samping",
    Callback = function(v) Config.AutoParry = v end,
})

CombatLeft:AddSlider("ParryDistance", {
    Text = "Detection Range",
    Default = 15, Min = 5, Max = 50,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) Config.ParryDistance = v end,
})

CombatLeft:AddSlider("ParryDebounce", {
    Text = "Debounce (detik)",
    Default = 0.15, Min = 0.05, Max = 1,
    Rounding = 2,
    Callback = function(v) Config.ParryDebounce = v end,
})

CombatRight:AddToggle("AutoSkillCheck", {
    Text = "Auto Skill Check (Perfect)",
    Default = false,
    Callback = function(v) 
        Config.AutoSkillCheck = v
        if v then startSkillCheck() end
    end,
})

-- ═══ TAB MOVEMENT ═══
local MoveGroup = Tabs.Movement:AddLeftGroupbox("Moonwalk", "moon")

MoveGroup:AddToggle("MoonwalkToggle", {
    Text = "Moonwalk",
    Default = false,
    Callback = function(v)
        Config.Moonwalk = v
        if v then startMoonwalk() else stopMoonwalk() end
    end,
})

MoveGroup:AddToggle("MoonwalkButtonToggle", {
    Text = "Show Moonwalk Button",
    Default = false,
    Callback = function(v)
        Config.MoonwalkButton = v
        if v then createMoonwalkButton() else removeMoonwalkButton() end
    end,
})

MoveGroup:AddSlider("MoonwalkSpam", {
    Text = "Spam Speed",
    Default = 30, Min = 1, Max = 50,
    Rounding = 0,
    Callback = function(v) Config.MoonwalkSpam = v end,
})

MoveGroup:AddSlider("MoonwalkIntensity", {
    Text = "Intensity",
    Default = 35, Min = 1, Max = 50,
    Rounding = 0,
    Callback = function(v) Config.MoonwalkIntensity = v end,
})

-- ═══ TAB VISUALS (ESP) ═══
local VisLeft  = Tabs.Visuals:AddLeftGroupbox("Player ESP", "eye")
local VisRight = Tabs.Visuals:AddRightGroupbox("Generator ESP", "cpu")

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

VisLeft:AddToggle("ESP_ShowName", {
    Text = "Show Name",
    Default = true,
    Callback = function(v) Config.ESP_ShowName = v end,
})

VisLeft:AddToggle("ESP_ShowDistance", {
    Text = "Show Distance",
    Default = true,
    Callback = function(v) Config.ESP_ShowDistance = v end,
})

VisLeft:AddSlider("ESP_NameSize", {
    Text = "Name Size",
    Default = 14, Min = 8, Max = 30,
    Rounding = 0, Suffix = " px",
    Callback = function(v) Config.ESP_NameSize = v end,
})

VisLeft:AddSlider("ESP_Distance", {
    Text = "ESP Radius",
    Default = 500, Min = 50, Max = 3000,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) Config.ESP_Distance = v end,
})

VisRight:AddToggle("ESPGenerator", {
    Text = "ESP Generator (%)",
    Default = false,
    Callback = function(v) Config.ESP_Generator = v end,
})

VisRight:AddColorPicker("ESP_GeneratorColor", {
    Text = "Generator Color",
    Default = Color3.fromRGB(255, 170, 0),
    Callback = function(c) Config.ESP_GeneratorColor = c end,
})

VisRight:AddToggle("ESP_ShowProgress", {
    Text = "Show Progress %",
    Default = true,
    Callback = function(v) Config.ESP_ShowProgress = v end,
})

-- ═══ TAB SETTINGS ═══
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("TiarHub4D")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

-- ═══ STATS PANEL ═══
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

Instance.new("UICorner", statsFrame).CornerRadius = UDim.new(0, 8)

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
        local ok, fps = pcall(function() return math.floor(1 / RunService.RenderStepped:Wait()) end)
        local ok2, ping = pcall(function() return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        local players = #Players:GetPlayers()
        statsText.Text = string.format("FPS: %s\nPing: %s ms\nPlayers: %d", 
            ok and fps or "--", ok2 and ping or "--", players)
        task.wait(1)
    end
end)

-- ═══ KEYBIND TOGGLE GUI ═══
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        if Window.UI then Window.UI.Visible = guiVisible end
        statsFrame.Visible = guiVisible
    end
end)

-- ═══ NOTIF STARTUP ═══
Library:Notify({
    Title = "TIARHUB 4D",
    Description = "Loaded! Auto Parry 360 + Moonwalk + ESP",
    Time = 5,
})

print("============================================")
print("  ⚡ TIARHUB 4D - ALL LOADED ⚡")
print("  ✅ Auto Parry 360°")
print("  ✅ Moonwalk + Button")
print("  ✅ Auto Skill Check Perfect")
print("  ✅ ESP Survivor/Killer/Generator")
print("============================================")-- ═══════════════════════════════════════════
--  BAGIAN 2/4 : RANGE CIRCLE + ESP SYSTEM
-- ═══════════════════════════════════════════

-- ═══════════════════════════════════════════
--  RANGE CIRCLE (di area tubuh kita)
--  Bisa di besar-kecilkan pakai slider
-- ═══════════════════════════════════════════
local RangeCirclePart = nil

local function updateRangeCircle()
    pcall(function()
        local root = getRoot()
        if not root or not Config.ParryRangeVisual then
            if RangeCirclePart then RangeCirclePart:Destroy(); RangeCirclePart = nil end
            return
        end

        if not RangeCirclePart then
            RangeCirclePart = Instance.new("Part")
            RangeCirclePart.Name = "TiarRangeCircle"
            RangeCirclePart.Shape = Enum.PartType.Cylinder
            RangeCirclePart.Anchored = true
            RangeCirclePart.CanCollide = false
            RangeCirclePart.Material = Enum.Material.Neon
            RangeCirclePart.Parent = workspace
        end

        local size = Config.ParryDistance * 2
        local yOffset = root.Size.Y / 2 + 1.5

        RangeCirclePart.Size = Vector3.new(0.2, size, size)
        RangeCirclePart.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0)) * CFrame.Angles(0, 0, math.rad(90))
        RangeCirclePart.Transparency = 0.6
        RangeCirclePart.Color = Config.ParryRangeColor
    end)
end

RunService.RenderStepped:Connect(updateRangeCircle)

-- ═══════════════════════════════════════════
--  ESP SYSTEM
-- ═══════════════════════════════════════════
local ESPObjects = {}
local ESPNames = {}
local CachedGenerators = {}

local function removeESP(obj)
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
    if ESPNames[obj] then ESPNames[obj]:Destroy(); ESPNames[obj] = nil end
end

local function createESP(obj, color, nameText)
    if not obj or not obj.Parent then return end

    -- Highlight
    if not ESPObjects[obj] then
        local h = Instance.new("Highlight")
        h.FillColor = color
        h.OutlineColor = color
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0.2
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

    -- Name Tag
    if Config.ESP_ShowName and nameText then
        local head = obj:FindFirstChild("Head") or obj:FindFirstChild("HumanoidRootPart")
        local adornee = head or (obj:IsA("BasePart") and obj)
        if adornee then
            if not ESPNames[obj] then
                local bb = Instance.new("BillboardGui")
                bb.Size = UDim2.new(0, 250, 0, 40)
                bb.AlwaysOnTop = true
                bb.StudsOffset = Vector3.new(0, 3, 0)
                bb.Adornee = adornee
                bb.Parent = obj

                local lbl = Instance.new("TextLabel")
                lbl.Name = "NameLabel"
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = color
                lbl.TextStrokeTransparency = 0
                lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = Config.ESP_NameSize
                lbl.Parent = bb
                ESPNames[obj] = bb
            end

            local bb = ESPNames[obj]
            local lbl = bb:FindFirstChild("NameLabel")
            if lbl then
                lbl.Text = nameText
                lbl.TextColor3 = color
                lbl.TextSize = Config.ESP_NameSize
            end
        end
    else
        -- Kalau show name dimatiin, destroy tag lama
        if ESPNames[obj] then
            ESPNames[obj]:Destroy()
            ESPNames[obj] = nil
        end
    end
end

-- Cache generator
local function cacheObj(obj)
    if not obj or not obj.Parent then return end
    if (obj:IsA("BasePart") or obj:IsA("Model")) and obj.Name == "Generator" then
        CachedGenerators[obj] = true
    end
end

for _, obj in ipairs(workspace:GetDescendants()) do cacheObj(obj) end
workspace.DescendantAdded:Connect(cacheObj)
workspace.DescendantRemoving:Connect(function(obj)
    CachedGenerators[obj] = nil
    removeESP(obj)
end)

-- Update generator ESP + progress
local function UpdateGenerator(gen)
    if not gen or not gen.Parent then return end
    if not Config.ESP_Generator then
        local h = gen:FindFirstChild("TiarGenHL"); if h then h:Destroy() end
        local n = gen:FindFirstChild("TiarGenTag"); if n then n:Destroy() end
        return
    end

    -- Baca progress
    local percent = 0
    local found = false
    local attr = gen:GetAttribute("Progress") or gen:GetAttribute("RepairProgress")
    if attr and type(attr) == "number" then percent = attr; found = true end

    if not found then
        for _, v in ipairs(gen:GetDescendants()) do
            if v:IsA("ValueBase") and (v.Name == "Progress" or v.Name == "RepairProgress" or v.Name == "Percent") then
                percent = v.Value; found = true; break
            end
        end
    end
    if not found then
        for _, v in ipairs(gen:GetChildren()) do
            if v:IsA("NumberValue") then percent = v.Value; found = true; break end
        end
    end

    percent = math.clamp(percent, 0, 100)

    -- Warna gradient: dari warna pilihan → hijau sesuai progress
    local color = Config.ESP_GeneratorColor:Lerp(Color3.fromRGB(0, 255, 100), percent / 100)

    -- Highlight
    local h = gen:FindFirstChild("TiarGenHL") or Instance.new("Highlight")
    h.Name = "TiarGenHL"
    h.Adornee = gen
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.5
    h.OutlineTransparency = 0.2
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = gen

    -- Billboard dengan progress
    local bb = gen:FindFirstChild("TiarGenTag")
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Name = "TiarGenTag"
        bb.Size = UDim2.new(0, 180, 0, 45)
        bb.AlwaysOnTop = true
        bb.StudsOffset = Vector3.new(0, 4, 0)
        bb.Adornee = gen
        bb.Parent = gen

        local lbl = Instance.new("TextLabel")
        lbl.Name = "GenLabel"
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = Config.ESP_NameSize
        lbl.Parent = bb
    end

    local lbl = bb:FindFirstChild("GenLabel")
    if lbl then
        if Config.ESP_ShowProgress and found then
            lbl.Text = string.format("Generator\n%.0f%%", percent)
        else
            lbl.Text = "Generator"
        end
        lbl.TextColor3 = color
        lbl.TextSize = Config.ESP_NameSize
    end
end

-- ═══════════════════════════════════════════
--  MAIN ESP LOOP
-- ═══════════════════════════════════════════
task.spawn(function()
    while task.wait(0.15) do
        pcall(function()
            local root = getRoot()
            if not root then return end

            -- ESP Survivor
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local char = p.Character
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local dist = (hrp.Position - root.Position).Magnitude
                            local isSurv = p.Team and (p.Team.Name == "Survivors" or p.Team.Name == "Survivor")

                            if Config.ESP_Survivor and isSurv and dist <= Config.ESP_Distance then
                                local txt = ""
                                if Config.ESP_ShowName then
                                    txt = string.format("[%s] %s", getTeamLabel(p), p.Name)
                                end
                                if Config.ESP_ShowDistance then
                                    txt = txt .. string.format("\n%.0f studs", dist)
                                end
                                createESP(char, Config.ESP_SurvivorColor, txt)
                            else
                                removeESP(char)
                            end
                        end
                    else
                        removeESP(char)
                    end
                end
            end

            -- ESP Generator
            if Config.ESP_Generator then
                for gen in pairs(CachedGenerators) do
                    local pos = GetPos(gen)
                    if pos and (pos - root.Position).Magnitude <= Config.ESP_Distance then
                        UpdateGenerator(gen)
                    else
                        local h = gen:FindFirstChild("TiarGenHL"); if h then h:Destroy() end
                        local n = gen:FindFirstChild("TiarGenTag"); if n then n:Destroy() end
                    end
                end
            else
                for gen in pairs(CachedGenerators) do
                    local h = gen:FindFirstChild("TiarGenHL"); if h then h:Destroy() end
                    local n = gen:FindFirstChild("TiarGenTag"); if n then n:Destroy() end
                end
            end
        end)
    end
end)

print("[TiarHub 5D] Bagian 2/4 loaded. ESP + Range Circle siap.")-- ═══════════════════════════════════════════
--  BAGIAN 3/4 : AUTO PARRY + SKILL CHECK + MOONWALK
-- ═══════════════════════════════════════════

-- ═══════════════════════════════════════════
--  AUTO PARRY (2 MODE)
-- ═══════════════════════════════════════════
local lastParry = 0
local ParryActive = false
local hookedKillers = {}
local lastKillerParry = {}

local function pressParryButton()
    if UserInputService.TouchEnabled then
        local cur = PlayerGui
        for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
            cur = cur and cur:FindFirstChild(segment)
        end
        if cur and cur:IsA("GuiObject") then
            local pos = cur.AbsolutePosition
            local size = cur.AbsoluteSize
            local inset = game:GetService("GuiService"):GetGuiInset()
            VirtualInputManager:SendTouchEvent(8823, 0, pos.X + size.X/2 + inset.X, pos.Y + size.Y/2 + inset.Y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8823, 2, pos.X + size.X/2 + inset.X, pos.Y + size.Y/2 + inset.Y)
        end
    else
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
        task.wait(0.01)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
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

        -- Cek mode parry
        if Config.ParryMode == "Aggressive" then
            -- Aggressive: parry kalau killer deket (max 20 studs)
            if dist > math.min(Config.ParryDistance, 20) then return end
        else
            -- Safety: parry kalau dalam range deteksi
            if dist > Config.ParryDistance then return end
        end

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

-- ═══════════════════════════════════════════
--  AUTO SKILL CHECK (2 MODE: Instant & Perfect)
-- ═══════════════════════════════════════════
local SkillHeartbeat = nil
local skillBusy = false

local function pressSpace()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local function TriggerMobileSkill()
    local cur = PlayerGui
    for segment in string.gmatch("Survivor-mob.Controls.action.check", "[^%.]+") do
        cur = cur and cur:FindFirstChild(segment)
    end
    if cur and cur:IsA("GuiObject") then
        local p, s, i = cur.AbsolutePosition, cur.AbsoluteSize, game:GetService("GuiService"):GetGuiInset()
        VirtualInputManager:SendTouchEvent(8822, 0, p.X + (s.X/2) + i.X, p.Y + (s.Y/2) + i.Y)
        task.wait(0.01)
        VirtualInputManager:SendTouchEvent(8822, 2, p.X + (s.X/2) + i.X, p.Y + (s.Y/2) + i.Y)
    end
end

local function doSkillPress()
    if UserInputService.TouchEnabled then TriggerMobileSkill() else pressSpace() end
end

local function startSkillCheck()
    if SkillHeartbeat then SkillHeartbeat:Disconnect() end
    SkillHeartbeat = RunService.RenderStepped:Connect(function()
        pcall(function()
            if not Config.AutoSkillCheck or skillBusy then return end
            local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
            if not prompt then return end
            local check = prompt:FindFirstChild("Check")
            if not check or not check.Visible then return end
            local line = check:FindFirstChild("Line")
            local goal = check:FindFirstChild("Goal")
            if not line or not goal then return end

            if Config.SkillMode == "Instant" then
                skillBusy = true
                task.spawn(function()
                    doSkillPress()
                    task.wait(0.05)
                    skillBusy = false
                end)
            else
                -- Perfect mode
                local lr = line.Rotation % 360
                local gr = goal.Rotation % 360
                local startRange = (gr + 102) % 360
                local endRange = (gr + 116) % 360
                local success = (startRange > endRange and (lr >= startRange or lr <= endRange))
                    or (lr >= startRange and lr <= endRange)

                if success then
                    skillBusy = true
                    task.spawn(function()
                        doSkillPress()
                        task.wait(0.05)
                        skillBusy = false
                    end)
                end
            end
        end)
    end)
end

-- ═══════════════════════════════════════════
--  MOONWALK
-- ═══════════════════════════════════════════
local MoonwalkConn = nil

local function startMoonwalk()
    if MoonwalkConn then return end
    MoonwalkConn = RunService.RenderStepped:Connect(function()
        if not Config.Moonwalk or ParryActive then return end
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not (humanoid and hrp and cam) then return end
        humanoid.AutoRotate = false
        humanoid.WalkSpeed = Config.MoonwalkSlowSpeed
        local look = cam.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit
            local baseCF = CFrame.new(hrp.Position, hrp.Position + flatLook)
            local angle = math.sin(tick() * Config.MoonwalkSpam) * Config.MoonwalkIntensity
            hrp.CFrame = baseCF * CFrame.Angles(0, math.rad(angle), 0)
            humanoid:Move(Vector3.new(0, 0, 1), true)
        end
    end)
end

local function stopMoonwalk()
    if MoonwalkConn then MoonwalkConn:Disconnect(); MoonwalkConn = nil end
    local hum = getHum()
    if hum then
        hum.AutoRotate = true
        hum.WalkSpeed = 16
    end
end

-- ═══════════════════════════════════════════
--  MOONWALK BUTTON (Draggable + Lock)
-- ═══════════════════════════════════════════
local MWBtnGui = nil
local MWBtnLocked = false

local function createMoonwalkButton()
    if MWBtnGui then MWBtnGui:Destroy() end

    MWBtnGui = Instance.new("ScreenGui")
    MWBtnGui.Name = "TiarMWBtn"
    MWBtnGui.ResetOnSpawn = false
    MWBtnGui.Parent = PlayerGui

    -- Container (buat drag)
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 60, 0, 60)
    container.Position = UDim2.new(0.8, 0, 0.7, 0)
    container.BackgroundColor3 = BLACK_BLUE
    container.BackgroundTransparency = 0.15
    container.BorderSizePixel = 0
    container.Parent = MWBtnGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.Name = "Stroke"
    stroke.Color = NEON_BLUE
    stroke.Thickness = 2
    stroke.Parent = container

    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "🌙"
    icon.TextSize = 28
    icon.Font = Enum.Font.GothamBlack
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.Parent = container

    -- Lock overlay
    local lockOverlay = Instance.new("TextLabel")
    lockOverlay.Name = "LockOverlay"
    lockOverlay.Size = UDim2.new(0.4, 0, 0.4, 0)
    lockOverlay.Position = UDim2.new(0.6, 0, 0.6, 0)
    lockOverlay.BackgroundTransparency = 1
    lockOverlay.Text = "🔒"
    lockOverlay.TextSize = 14
    lockOverlay.Visible = false
    lockOverlay.Parent = container

    -- Tombol klik
    local btn = Instance.new("TextButton")
    btn.Name = "ClickBtn"
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = container

    -- Drag logic
    local dragging = false
    local dragStart, startPos

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = container.Position
        end
    end)

    btn.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement 
           or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            container.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
           or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                local moved = math.abs(input.Position.X - dragStart.X) + math.abs(input.Position.Y - dragStart.Y)
                -- Kalau gak gerak (cuma klik), toggle moonwalk
                if moved < 10 then
                    Config.Moonwalk = not Config.Moonwalk
                    if Config.Moonwalk then
                        stroke.Color = Color3.fromRGB(255, 100, 255)
                        startMoonwalk()
                        Library:Notify({ Title = "Moonwalk", Description = "ON", Time = 2 })
                    else
                        stroke.Color = NEON_BLUE
                        stopMoonwalk()
                        Library:Notify({ Title = "Moonwalk", Description = "OFF", Time = 2 })
                    end
                end
            end
        end
    end)

    -- Function update lock
    local function updateLock(state)
        MWBtnLocked = state
        lockOverlay.Visible = state
        if state then
            stroke.Color = Color3.fromRGB(255, 200, 0)
            btn.Active = false
        else
            stroke.Color = Config.Moonwalk and Color3.fromRGB(255, 100, 255) or NEON_BLUE
            btn.Active = true
        end
    end

    _G.TiarMWBtnUpdateLock = updateLock
end

local function removeMoonwalkButton()
    if MWBtnGui then MWBtnGui:Destroy(); MWBtnGui = nil end
end

print("[TiarHub 5D] Bagian 3/4 loaded. Parry + Skill + Moonwalk siap.")-- ═══════════════════════════════════════════
--  BAGIAN 4/4 : VISUAL + UI TABS + STARTUP
-- ═══════════════════════════════════════════

-- ═══════════════════════════════════════════
--  VISUAL (Fullbright, No Fog, Contrast)
-- ═══════════════════════════════════════════
local VisualOriginal = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    FogColor = Lighting.FogColor,
}
local CC = nil

local function getCC()
    if CC and CC.Parent then return CC end
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("ColorCorrectionEffect") and v.Name == "TiarCC" then
            CC = v
            return v
        end
    end
    CC = Instance.new("ColorCorrectionEffect")
    CC.Name = "TiarCC"
    CC.Parent = Lighting
    return CC
end

local function applyVisual()
    pcall(function()
        -- Fullbright
        if Config.Fullbright then
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

        -- No Fog
        if Config.NoFog then
            Lighting.FogEnd = 100000
            Lighting.FogStart = 100000
        else
            Lighting.FogEnd = VisualOriginal.FogEnd
            Lighting.FogStart = VisualOriginal.FogStart
            Lighting.FogColor = VisualOriginal.FogColor
        end

        -- Contrast
        local cc = getCC()
        if Config.Contrast then
            cc.Contrast = Config.ContrastValue
            cc.Enabled = true
        else
            cc.Contrast = 0
            cc.Enabled = false
        end
    end)
end

RunService.Heartbeat:Connect(function()
    pcall(applyVisual)
end)

-- ═══════════════════════════════════════════
--  UI TABS
-- ═══════════════════════════════════════════
local Tabs = {
    Combat   = Window:AddTab("Combat",   "sword"),
    Movement = Window:AddTab("Movement", "activity"),
    Visuals  = Window:AddTab("Visuals",  "eye"),
    Settings = Window:AddTab("Settings", "settings"),
}

-- ═══════════════════════════════════════════
--  TAB COMBAT
-- ═══════════════════════════════════════════
local ParryGroup  = Tabs.Combat:AddLeftGroupbox("Auto Parry", "shield")
local SkillGroup  = Tabs.Combat:AddRightGroupbox("Auto Skill Check", "check")

ParryGroup:AddToggle("AutoParry", {
    Text = "Auto Parry",
    Default = false,
    Tooltip = "Otomatis parry serangan killer",
    Callback = function(v) Config.AutoParry = v end,
})

ParryGroup:AddDropdown("ParryMode", {
    Text = "Parry Mode",
    Values = {"Safety", "Aggressive"},
    Default = "Safety",
    Multi = false,
    Callback = function(v) Config.ParryMode = v end,
})

ParryGroup:AddSlider("ParryRange", {
    Text = "Detection Range",
    Default = 15, Min = 5, Max = 50,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) Config.ParryDistance = v end,
})

ParryGroup:AddToggle("ShowRange", {
    Text = "Show Range Circle",
    Default = false,
    Callback = function(v) Config.ParryRangeVisual = v end,
})

ParryGroup:AddColorPicker("RangeColor", {
    Text = "Range Circle Color",
    Default = Color3.fromRGB(255, 80, 80),
    Callback = function(c) Config.ParryRangeColor = c end,
})

ParryGroup:AddSlider("ParryDebounce", {
    Text = "Debounce (detik)",
    Default = 0.15, Min = 0.05, Max = 1,
    Rounding = 2,
    Callback = function(v) Config.ParryDebounce = v end,
})

SkillGroup:AddToggle("AutoSkillCheck", {
    Text = "Auto Skill Check",
    Default = false,
    Callback = function(v)
        Config.AutoSkillCheck = v
        if v then startSkillCheck() end
    end,
})

SkillGroup:AddDropdown("SkillMode", {
    Text = "Skill Check Mode",
    Values = {"Perfect", "Instant"},
    Default = "Perfect",
    Multi = false,
    Callback = function(v) Config.SkillMode = v end,
})

-- ═══════════════════════════════════════════
--  TAB MOVEMENT
-- ═══════════════════════════════════════════
local MWGroup = Tabs.Movement:AddLeftGroupbox("Moonwalk", "move")

MWGroup:AddToggle("Moonwalk", {
    Text = "Enable Moonwalk",
    Default = false,
    Callback = function(v)
        Config.Moonwalk = v
        if v then startMoonwalk() else stopMoonwalk() end
    end,
})

MWGroup:AddSlider("MoonwalkSpam", {
    Text = "Spam Speed",
    Default = 30, Min = 1, Max = 50,
    Rounding = 0,
    Callback = function(v) Config.MoonwalkSpam = v end,
})

MWGroup:AddSlider("MoonwalkIntensity", {
    Text = "Intensity",
    Default = 35, Min = 1, Max = 50,
    Rounding = 0,
    Callback = function(v) Config.MoonwalkIntensity = v end,
})

MWGroup:AddDivider()

MWGroup:AddToggle("MoonwalkButton", {
    Text = "Show Moonwalk Button",
    Default = false,
    Tooltip = "Tombol floating yang bisa digeser",
    Callback = function(v)
        if v then createMoonwalkButton() else removeMoonwalkButton() end
    end,
})

MWGroup:AddToggle("MoonwalkLock", {
    Text = "Lock Moonwalk Button",
    Default = false,
    Tooltip = "Kunci posisi tombol biar gak gerak",
    Callback = function(v)
        if _G.TiarMWBtnUpdateLock then
            _G.TiarMWBtnUpdateLock(v)
        end
    end,
})

-- ═══════════════════════════════════════════
--  TAB VISUALS
-- ═══════════════════════════════════════════
local ESPGroup   = Tabs.Visuals:AddLeftGroupbox("ESP Players", "eye")
local GenGroup   = Tabs.Visuals:AddRightGroupbox("ESP Generator", "cpu")
local VisGroup   = Tabs.Visuals:AddLeftGroupbox("Lighting", "sun")

ESPGroup:AddToggle("ESPSurvivor", {
    Text = "ESP Survivor",
    Default = false,
    Callback = function(v) Config.ESP_Survivor = v end,
})

ESPGroup:AddColorPicker("ESPSurvivorColor", {
    Text = "Survivor Color",
    Default = Color3.fromRGB(60, 255, 120),
    Callback = function(c) Config.ESP_SurvivorColor = c end,
})

ESPGroup:AddDivider()

ESPGroup:AddToggle("ESPShowName", {
    Text = "Show Name Tag",
    Default = true,
    Callback = function(v) Config.ESP_ShowName = v end,
})

ESPGroup:AddToggle("ESPShowDistance", {
    Text = "Show Distance",
    Default = true,
    Callback = function(v) Config.ESP_ShowDistance = v end,
})

ESPGroup:AddSlider("ESPNameSize", {
    Text = "Name Size",
    Default = 14, Min = 8, Max = 30,
    Rounding = 0, Suffix = " px",
    Callback = function(v) Config.ESP_NameSize = v end,
})

ESPGroup:AddSlider("ESPDistance", {
    Text = "ESP Radius",
    Default = 500, Min = 50, Max = 3000,
    Rounding = 0, Suffix = " studs",
    Callback = function(v) Config.ESP_Distance = v end,
})

GenGroup:AddToggle("ESPGenerator", {
    Text = "ESP Generator",
    Default = false,
    Callback = function(v) Config.ESP_Generator = v end,
})

GenGroup:AddColorPicker("ESPGeneratorColor", {
    Text = "Generator Color",
    Default = Color3.fromRGB(255, 170, 0),
    Callback = function(c) Config.ESP_GeneratorColor = c end,
})

GenGroup:AddToggle("ESPShowProgress", {
    Text = "Show Progress %",
    Default = true,
    Callback = function(v) Config.ESP_ShowProgress = v end,
})

VisGroup:AddToggle("Fullbright", {
    Text = "Fullbright",
    Default = false,
    Callback = function(v) Config.Fullbright = v end,
})

VisGroup:AddToggle("NoFog", {
    Text = "No Fog",
    Default = false,
    Callback = function(v) Config.NoFog = v end,
})

VisGroup:AddToggle("Contrast", {
    Text = "Enable Contrast",
    Default = false,
    Callback = function(v) Config.Contrast = v end,
})

VisGroup:AddSlider("ContrastValue", {
    Text = "Contrast Level",
    Default = 0.2, Min = 0, Max = 1,
    Rounding = 2,
    Callback = function(v) Config.ContrastValue = v end,
})

-- ═══════════════════════════════════════════
--  TAB SETTINGS
-- ═══════════════════════════════════════════
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("TiarHub5D")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

-- ═══════════════════════════════════════════
--  STATS PANEL
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

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 8)
sCorner.Parent = statsFrame

local sStroke = Instance.new("UIStroke")
sStroke.Color = NEON_BLUE
sStroke.Thickness = 1.5
sStroke.Transparency = 0.3
sStroke.Parent = statsFrame

local statsTitle = Instance.new("TextLabel")
statsTitle.Text = "STATS"
statsTitle.Font = Enum.Font.GothamBlack
statsTitle.TextSize = 14
statsTitle.TextColor3 = CYAN
statsTitle.BackgroundTransparency = 1
statsTitle.Size = UDim2.new(1, 0, 0, 20)
statsTitle.Position = UDim2.new(0, 0, 0, 5)
statsTitle.Parent = statsFrame

local statsText = Instance.new("TextLabel")
statsText.Font = Enum.Font.GothamBold
statsText.TextSize = 13
statsText.TextColor3 = Color3.fromRGB(220, 235, 255)
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
--  KEYBIND TOGGLE GUI
-- ═══════════════════════════════════════════
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        if Window.UI then Window.UI.Visible = guiVisible end
        statsFrame.Visible = guiVisible
    end
end)

-- ═══════════════════════════════════════════
--  NOTIF STARTUP
-- ═══════════════════════════════════════════
Library:Notify({
    Title = "TIARHUB 5D",
    Description = "Loaded Successfully!",
    Time = 5,
})

print("============================================")
print("  ⚡ TIARHUB 5D - ALL LOADED ⚡")
print("  ✅ Auto Parry 2 Mode + Range Circle")
print("  ✅ Auto Skill Check 2 Mode")
print("  ✅ ESP Survivor + Generator Progress")
print("  ✅ Moonwalk + Draggable Button + Lock")
print("  ✅ Fullbright + No Fog + Contrast")
print("============================================")
