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
print("============================================")
