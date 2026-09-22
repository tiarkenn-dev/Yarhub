local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local Window = Rayfield:CreateWindow({
    name = "TiarHub | Violence District",
    subtitle = "by Tiar",
    sidebarLayout = true,
    configuration = { autoSave = true, autoLoad = true, fileName = "TiarHubFull" }
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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

local Visual = { Fullbright = false, NoFog = false, NoShadow = false, NoBloom = false, NoBlur = false, ColorCorrection = false, Saturation = 0, Brightness = 0 }
local VisualOriginal = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart, FogColor = Lighting.FogColor
}

local Parry = {
    Enabled = false, Mode = "Safety",
    SafetyDistance = 12, SafetyDebounce = 0.15, SafetyFaceSensitivity = 0.5,
    AggressiveDistance = 20, AggressiveDebounce = 0.05, AggressiveFaceSensitivity = -1
}

local SkillCheck = { Enabled = false }
local Wiggle = { Enabled = false, Spam = 5 }
local AutoFlee = { Enabled = false, DetectDistance = 50, Cooldown = 0.1 }
local LastFlee = 0
local FastVault = { Enabled = false, Speed = 1.2, ReplaceMap = { ["rbxassetid://83873880822918"] = "rbxassetid://136962284480779" } }
local VaultTracks = {}

local GunAim = {
    Enabled = false, Holding = false, TargetMode = "Killer",
    Strength = 1, Predict = true, PredictStrength = 0.12,
    FOV = 250, VisibilityCheck = false, AimPart = "HumanoidRootPart",
    ShowFOV = false, ShowTracer = false, TracerColor = Color3.fromRGB(255, 0, 0)
}

local KillerAim = { Enabled = false, FOV = 200, Strength = 0.5, Holding = false }

local Killer = {
    AutoAttack = false, AttackDelay = 0.45,
    AutoCarry = false, AutoHook = false, KillAll = false,
    AutoStalk = false, StalkRange = 150
}
local KillerBusy = false
local KillerTarget = nil
local StalkConnection = nil

local Movement = {
    WalkSpeedEnabled = false, WalkSpeedValue = 17.6, OriginalWalkSpeed = 16,
    JumpPowerEnabled = false, JumpPowerValue = 50, OriginalJumpPower = 50,
    NoClip = false, InfiniteJump = false
}

local Moonwalk = { Enabled = false, ShowButton = false, SpamSpeed = 30, Intensity = 35, SlowSpeed = 13, UseSlow = true }
local MoonwalkConnection = nil
local MoonwalkButton = nil
local ParryActive = false

local Crosshair = { Enabled = false, Size = 8, Thickness = 2, Color = Color3.fromRGB(255, 255, 255), Style = "Plus", OffsetX = 0, OffsetY = 0 }

local Emote = { Selected = "Mannrobics" }
local EmoteList = { "Mannrobics","Arm Swing","Schadenfreude","Kyoufuu","Backflip","Griddy","Friday Night","Floating Rest","OnePlays","Quick Combo","WarCry","Wave" }

local Masked = { CurrentPower = "Cobra" }
local MaskedPowers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}

local AntiLag = {
    Enabled = false,
    NoParticles = false, NoTextures = false,
    PhysicsThrottle = false, NoGlobalShadows = false, NetworkLag = false
}

local FPS = 0
local Frames = 0
local LastTick = tick()

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

local function getParryDistance()
    if Parry.Mode == "Aggressive" then return Parry.AggressiveDistance
    else return Parry.SafetyDistance end
end

local function getParryDebounce()
    if Parry.Mode == "Aggressive" then return Parry.AggressiveDebounce
    else return Parry.SafetyDebounce end
end

local function getParryFaceSensitivity()
    if Parry.Mode == "Aggressive" then return Parry.AggressiveFaceSensitivity
    else return Parry.SafetyFaceSensitivity end
endlocal ESPObjects = {}
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
        if ESP.Mode == "Outline" then
            h.FillTransparency = 1; h.OutlineTransparency = 0
        elseif ESP.Mode == "Fill" then
            h.FillTransparency = 0.5; h.OutlineTransparency = 1
        else
            h.FillTransparency = 0.9; h.OutlineTransparency = 0.3
        end
        h.FillColor = color; h.OutlineColor = color
    else
        local h = Instance.new("Highlight")
        h.FillColor = color; h.OutlineColor = color
        if ESP.Mode == "Outline" then
            h.FillTransparency = 1; h.OutlineTransparency = 0
        elseif ESP.Mode == "Fill" then
            h.FillTransparency = 0.5; h.OutlineTransparency = 1
        else
            h.FillTransparency = 0.9; h.OutlineTransparency = 0.3
        end
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
                if plr then
                    playerName = plr.Name
                    teamLabel = getTeamLabel(plr)
                end
            end
            local displayText = playerName
            if teamLabel ~= "" then
                displayText = string.format("[%s] %s", teamLabel, playerName)
            end

            if ESPNames[obj] then
                local bb = ESPNames[obj]
                bb.Size = UDim2.new(0, 250, 0, ESP.NameSize * 2)
                local lbl = bb:FindFirstChildOfClass("TextLabel")
                if lbl then
                    lbl.Text = displayText
                    lbl.TextSize = ESP.NameSize
                    lbl.TextColor3 = color
                end
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
        local old = generator:FindFirstChild("GenHighlight")
        if old then old:Destroy() end
        local oldName = generator:FindFirstChild("GenNameTag")
        if oldName then oldName:Destroy() end
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
        local child = generator:FindFirstChild("Progress")
        if child and child:IsA("ValueBase") then percent = child.Value; found = true end
    end
    if not found then
        local child = generator:FindFirstChild("RepairProgress")
        if child and child:IsA("ValueBase") then percent = child.Value; found = true end
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
    if ESP.Mode == "Outline" then
        h.FillTransparency = 1; h.OutlineTransparency = 0
    elseif ESP.Mode == "Fill" then
        h.FillTransparency = 0.5; h.OutlineTransparency = 1
    else
        h.FillTransparency = 0.9; h.OutlineTransparency = 0.3
    end
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
    if lbl then
        lbl.Text = labelText
        lbl.TextColor3 = color
    end
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

RunService.RenderStepped:Connect(function()
    Frames = Frames + 1
    if tick() - LastTick >= 1 then
        FPS = Frames
        Frames = 0
        LastTick = tick()
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        pcall(function()
            Rayfield:SetWatermark(string.format("TiarHub | FPS: %d | PING: %d ms", FPS, ping))
        end)
    end
end)

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
                            if ESP.Survivor and isSurv then
                                createESP(char, ESP.SurvivorColor, ESP.ShowName)
                            elseif ESP.Killer and isKiller then
                                createESP(char, ESP.KillerColor, ESP.ShowName)
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
                if pos and (pos - root.Position).Magnitude <= ESP.Distance then
                    UpdateGenerator(gen)
                else
                    local old = gen:FindFirstChild("GenHighlight")
                    if old then old:Destroy() end
                    local oldName = gen:FindFirstChild("GenNameTag")
                    if oldName then oldName:Destroy() end
                end
            end
        else
            for gen in pairs(CachedObjects.Generators) do
                local old = gen:FindFirstChild("GenHighlight")
                if old then old:Destroy() end
                local oldName = gen:FindFirstChild("GenNameTag")
                if oldName then oldName:Destroy() end
            end
        end

        if ESP.Hook then
            for hook in pairs(CachedObjects.Hooks) do
                local pos = GetPos(hook)
                if pos and (pos - root.Position).Magnitude <= ESP.Distance then
                    createESP(hook, ESP.HookColor, false)
                else removeESP(hook) end
            end
        else for hook in pairs(CachedObjects.Hooks) do removeESP(hook) end end

        if ESP.Pallet then
            for pallet in pairs(CachedObjects.Pallets) do
                local pos = GetPos(pallet)
                if pos and (pos - root.Position).Magnitude <= ESP.Distance then
                    createESP(pallet, ESP.PalletColor, false)
                else removeESP(pallet) end
            end
        else for pallet in pairs(CachedObjects.Pallets) do removeESP(pallet) end end

        if ESP.Window then
            for win in pairs(CachedObjects.Windows) do
                local pos = GetPos(win)
                if pos and (pos - root.Position).Magnitude <= ESP.Distance then
                    createESP(win, ESP.WindowColor, false)
                else removeESP(win) end
            end
        else for win in pairs(CachedObjects.Windows) do removeESP(win) end end

        if ESP.SCP then
            for scp in pairs(CachedSCP) do
                local pos = GetPos(scp)
                if pos and (pos - root.Position).Magnitude <= ESP.Distance then
                    createESP(scp, ESP.SCPColor, false)
                else removeESP(scp) end
            end
        else for scp in pairs(CachedSCP) do removeESP(scp) end end
    end)
end)local lastParry = 0

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
    local debounce = getParryDebounce()
    if now - lastParry < debounce then return end
    lastParry = now
    ParryActive = true
    if Moonwalk.Enabled then Moonwalk.Enabled = false end
    pressParryButton()
    task.delay(0.25, function() ParryActive = false end)
end

local function isFacingTarget(targetChar)
    local sensitivity = getParryFaceSensitivity()
    if sensitivity <= -1 then return true end
    local myChar = LocalPlayer.Character
    if not myChar then return false end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local enemyRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not enemyRoot then return false end
    local enemyForward = enemyRoot.CFrame.LookVector
    local directionToMe = (myRoot.Position - enemyRoot.Position).Unit
    local dot = enemyForward:Dot(directionToMe)
    return dot >= sensitivity
end

local hookedKillers = {}
local function hookKiller(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not Parry.Enabled then return end
        local anim = track.Animation
        if not anim then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end
        if KillerAnims["rbxassetid://" .. id] then
            local myRoot = getRoot()
            local enemyRoot = char:FindFirstChild("HumanoidRootPart")
            if myRoot and enemyRoot then
                local dist = (enemyRoot.Position - myRoot.Position).Magnitude
                local maxDist = getParryDistance()
                if dist <= maxDist then
                    if isFacingTarget(char) then
                        doParry()
                    end
                end
            end
        end
    end)
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if Parry.Enabled then
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
            if not SkillCheck.Enabled or busy then return end
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

local function AutoWiggle()
    if not Wiggle.Enabled then return end
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
    for i = 1, Wiggle.Spam do event:FireServer() end
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
if LocalPlayer.Character then pcall(function() hookVault(LocalPlayer.Character) end) endlocal Drawing = Drawing
local FOVCircle = nil
local TracerLine = nil

local function createFOVCircle()
    if not Drawing then return end
    if FOVCircle then FOVCircle:Remove() end
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Thickness = 1
    FOVCircle.NumSides = 60
    FOVCircle.Radius = GunAim.FOV
    FOVCircle.Filled = false
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Transparency = 0.5
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        if not Drawing then return end
        if FOVCircle then
            FOVCircle.Visible = GunAim.Enabled and GunAim.ShowFOV
            FOVCircle.Radius = GunAim.FOV
            FOVCircle.Position = Vector2.new(
                workspace.CurrentCamera.ViewportSize.X / 2,
                workspace.CurrentCamera.ViewportSize.Y / 2
            )
        end
    end)
end)

local function createTracer()
    if not Drawing then return end
    if TracerLine then TracerLine:Remove() end
    TracerLine = Drawing.new("Line")
    TracerLine.Visible = false
    TracerLine.Thickness = 1
    TracerLine.Color = GunAim.TracerColor
end

createTracer()

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
                            if GunAim.VisibilityCheck and not isVisible(hrp) then continue end
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
        if TracerLine then TracerLine.Visible = false end
        if not GunAim.Enabled or not GunAim.Holding then return end
        local cam = workspace.CurrentCamera
        local target = getClosestGunTarget()
        if not target then return end
        local pos = target.Position
        if GunAim.Predict then
            pos = pos + (target.AssemblyLinearVelocity * GunAim.PredictStrength)
        end
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, pos), GunAim.Strength)
        if GunAim.ShowTracer and TracerLine and Drawing then
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
end)local function GetDownedSurvivor()
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
    end)
end)

local WalkSpeedConnection = nil
local function applyWalkSpeed()
    if WalkSpeedConnection then WalkSpeedConnection:Disconnect() end
    WalkSpeedConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not Movement.WalkSpeedEnabled then return end
            local hum = getHum()
            if not hum then return end
            if hum.WalkSpeed ~= Movement.WalkSpeedValue then hum.WalkSpeed = Movement.WalkSpeedValue end
        end)
    end)
end

local function applyJumpPower()
    if not Movement.JumpPowerEnabled then return end
    local hum = getHum()
    if hum then hum.JumpPower = Movement.JumpPowerValue end
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

UserInputService.JumpRequest:Connect(function()
    if Movement.InfiniteJump then
        local hum = getHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local function startMoonwalk()
    if MoonwalkConnection then return end
    MoonwalkConnection = RunService.RenderStepped:Connect(function()
        pcall(function()
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

            local look = cam.CFrame.LookVector
            local flatLook = Vector3.new(look.X, 0, look.Z)
            if flatLook.Magnitude < 0.01 then return end
            flatLook = flatLook.Unit

            local angle = math.sin(tick() * Moonwalk.SpamSpeed) * Moonwalk.Intensity
            local rotatedLook = (CFrame.Angles(0, math.rad(angle), 0) * flatLook)

            humanoid:Move(rotatedLook, false)

            local targetCF = CFrame.new(hrp.Position, hrp.Position + flatLook)
            hrp.CFrame = targetCF * CFrame.Angles(0, math.rad(angle), 0)
        end)
    end)
end

local function stopMoonwalk()
    if MoonwalkConnection then
        MoonwalkConnection:Disconnect()
        MoonwalkConnection = nil
    end
    local hum = getHum()
    if hum then
        hum.AutoRotate = true
        if Movement.WalkSpeedEnabled then
            hum.WalkSpeed = Movement.WalkSpeedValue
        else
            hum.WalkSpeed = Movement.OriginalWalkSpeed
        end
    end
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

local CrosshairGui = nil
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

RunService.Heartbeat:Connect(function()
    pcall(function() AutoWiggle() end)
    pcall(function() applyVisual() end)
end)

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

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    applyVisual(true)
end)local LastVisualState = { Fullbright = nil, NoFog = nil, NoShadow = nil }

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
                Lighting.FogEnd = 100000
                Lighting.FogStart = 100000
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

local function toggleScreenEffects(disable)
    pcall(function()
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = not disable
            end
        end
    end)
end

Lighting.ChildAdded:Connect(function(v)
    task.wait(0.1)
    pcall(function()
        if Visual.NoBloom then
            if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") then v.Enabled = false end
        end
        if Visual.NoBlur then
            if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") then v.Enabled = false end
        end
    end)
end)

local ColorCorrection = nil

local function applyColorCorrection()
    pcall(function()
        if not ColorCorrection then
            ColorCorrection = Instance.new("ColorCorrectionEffect")
            ColorCorrection.Name = "TiarColorCorrection"
            ColorCorrection.Parent = Lighting
        end
        if Visual.ColorCorrection then
            ColorCorrection.Saturation = Visual.Saturation
            ColorCorrection.Brightness = Visual.Brightness
            ColorCorrection.Enabled = true
        else
            ColorCorrection.Enabled = false
        end
    end)
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

local function applyAntiLag()
    pcall(function()
        if AntiLag.PhysicsThrottle then
            settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.AlwaysThrottle
        else
            settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Default
        end
    end)

    pcall(function()
        if AntiLag.NoGlobalShadows then
            Lighting.GlobalShadows = false
        else
            Lighting.GlobalShadows = VisualOriginal.GlobalShadows
        end
    end)

    pcall(function()
        if AntiLag.NetworkLag then
            settings().Network.IncomingReplicationLag = -1000
        else
            settings().Network.IncomingReplicationLag = 0
        end
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
            if v:IsA("Texture") or v:IsA("Decal") then
                pcall(function() v.Transparency = 1 end)
            end
        end
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then
                pcall(function() v.Transparency = 0 end)
            end
        end
    end
end

startAntiLag()

local function applyVisualExtended()
    pcall(function()
        toggleScreenEffects(Visual.NoBloom)
        
        if Visual.NoBlur then
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") then
                    v.Enabled = false
                end
            end
        else
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") then
                    v.Enabled = true
                end
            end
        end
    end)
    applyColorCorrection()
end

RunService.Heartbeat:Connect(function()
    pcall(function() applyVisualExtended() end)
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    applyVisual(true)
    applyVisualExtended()
end)local ESPTab = Window:CreateTab({ name = "ESP", icon = 4483362458 })

ESPTab:CreateSection("Player ESP")
ESPTab:CreateToggle({ name = "ESP Survivor", currentValue = false, callback = function(v) ESP.Survivor = v end })
ESPTab:CreateColorPicker({ name = "Survivor Color", color = ESP.SurvivorColor, callback = function(c) ESP.SurvivorColor = c end })
ESPTab:CreateToggle({ name = "ESP Killer", currentValue = false, callback = function(v) ESP.Killer = v end })
ESPTab:CreateColorPicker({ name = "Killer Color", color = ESP.KillerColor, callback = function(c) ESP.KillerColor = c end })

ESPTab:CreateSection("Map ESP")
ESPTab:CreateToggle({ name = "ESP Generator (%)", currentValue = false, callback = function(v) ESP.Generator = v end })
ESPTab:CreateColorPicker({ name = "Generator Color", color = ESP.GeneratorColor, callback = function(c) ESP.GeneratorColor = c end })
ESPTab:CreateToggle({ name = "ESP Hook", currentValue = false, callback = function(v) ESP.Hook = v end })
ESPTab:CreateToggle({ name = "ESP Pallet", currentValue = false, callback = function(v) ESP.Pallet = v end })
ESPTab:CreateToggle({ name = "ESP Window", currentValue = false, callback = function(v) ESP.Window = v end })
ESPTab:CreateToggle({ name = "ESP SCP", currentValue = false, callback = function(v) ESP.SCP = v end })

ESPTab:CreateSection("Style")
ESPTab:CreateSlider({ name = "ESP Radius", range = {50, 2000}, increment = 50, suffix = "stud", currentValue = 300, callback = function(v) ESP.Distance = v end })
ESPTab:CreateDropdown({ name = "ESP Mode", options = {"Highlight", "Outline", "Fill"}, currentOption = "Highlight", callback = function(opt) ESP.Mode = opt end })
ESPTab:CreateToggle({ name = "Show Name Tag", currentValue = true, callback = function(v) ESP.ShowName = v end })
ESPTab:CreateSlider({ name = "Name Size", range = {8, 30}, increment = 1, suffix = "px", currentValue = 14, callback = function(v) ESP.NameSize = v end })

ESPTab:CreateSection("ESP Status")
ESPTab:CreateToggle({ name = "Enable Status ESP", currentValue = false, callback = function(v) ESPStatus.Enabled = v end })
ESPTab:CreateToggle({ name = "Show Name", currentValue = true, callback = function(v) ESPStatus.ShowName = v end })
ESPTab:CreateToggle({ name = "Show Distance", currentValue = true, callback = function(v) ESPStatus.ShowDistance = v end })
ESPTab:CreateToggle({ name = "Show Health", currentValue = false, callback = function(v) ESPStatus.ShowHealth = v end })

local SurvivorTab = Window:CreateTab({ name = "Survivor", icon = 4483362458 })

SurvivorTab:CreateSection("Auto Parry - Mode")
SurvivorTab:CreateToggle({ name = "Auto Parry", currentValue = false, callback = function(v) Parry.Enabled = v end })
SurvivorTab:CreateDropdown({ 
    name = "Parry Mode", 
    options = {"Safety", "Aggressive"}, 
    currentOption = "Safety", 
    callback = function(opt) Parry.Mode = opt end 
})
SurvivorTab:CreateParagraph({ title = "Mode Info", content = "Safety: dekat + cek arah. Aggressive: jauh + tanpa cek arah." })

SurvivorTab:CreateSection("Auto Parry - Safety Mode")
SurvivorTab:CreateSlider({ name = "Safety Distance", range = {5, 25}, increment = 1, suffix = "stud", currentValue = 12, callback = function(v) Parry.SafetyDistance = v end })
SurvivorTab:CreateSlider({ name = "Safety Debounce", range = {0.05, 0.5}, increment = 0.05, suffix = "s", currentValue = 0.15, callback = function(v) Parry.SafetyDebounce = v end })
SurvivorTab:CreateSlider({ name = "Safety Face Sens", range = {-1, 1}, increment = 0.05, currentValue = 0.5, callback = function(v) Parry.SafetyFaceSensitivity = v end })

SurvivorTab:CreateSection("Auto Parry - Aggressive Mode")
SurvivorTab:CreateSlider({ name = "Aggressive Distance", range = {10, 30}, increment = 1, suffix = "stud", currentValue = 20, callback = function(v) Parry.AggressiveDistance = v end })
SurvivorTab:CreateSlider({ name = "Aggressive Debounce", range = {0.02, 0.2}, increment = 0.01, suffix = "s", currentValue = 0.05, callback = function(v) Parry.AggressiveDebounce = v end })
SurvivorTab:CreateSlider({ name = "Aggressive Face Sens", range = {-1, 1}, increment = 0.05, currentValue = -1, callback = function(v) Parry.AggressiveFaceSensitivity = v end })

SurvivorTab:CreateSection("Auto Skill Check")
SurvivorTab:CreateToggle({ name = "Auto Skill Check", currentValue = false, callback = function(v) SkillCheck.Enabled = v; if v then startSkillCheck() end end })

SurvivorTab:CreateSection("Auto Wiggle")
SurvivorTab:CreateToggle({ name = "Auto Wiggle", currentValue = false, callback = function(v) Wiggle.Enabled = v end })
SurvivorTab:CreateSlider({ name = "Wiggle Spam", range = {1, 10}, increment = 1, suffix = "x", currentValue = 5, callback = function(v) Wiggle.Spam = v end })

SurvivorTab:CreateSection("Auto Flee Killer")
SurvivorTab:CreateToggle({ name = "Auto Flee Killer", currentValue = false, callback = function(v) AutoFlee.Enabled = v end })
SurvivorTab:CreateSlider({ name = "Flee Detect Distance", range = {10, 200}, increment = 5, suffix = "stud", currentValue = 50, callback = function(v) AutoFlee.DetectDistance = v end })

SurvivorTab:CreateSection("Fast Vault")
SurvivorTab:CreateToggle({ name = "Fast Vault", currentValue = false, callback = function(v) FastVault.Enabled = v end })
SurvivorTab:CreateSlider({ name = "Animation Speed", range = {1, 5}, increment = 0.1, suffix = "x", currentValue = 1.2, callback = function(v) FastVault.Speed = v end })

local AimTab = Window:CreateTab({ name = "Aimbot", icon = 4483362458 })

AimTab:CreateSection("Aimbot Survivor")
AimTab:CreateToggle({ name = "Aimbot (Hold RMB)", currentValue = false, callback = function(v) GunAim.Enabled = v end })
AimTab:CreateToggle({ name = "Show FOV Circle", currentValue = false, callback = function(v) GunAim.ShowFOV = v; if v and not FOVCircle then createFOVCircle() end end })
AimTab:CreateToggle({ name = "Show Tracer (ESP Laser)", currentValue = false, callback = function(v) GunAim.ShowTracer = v; if v and not TracerLine then createTracer() end end })
AimTab:CreateColorPicker({ name = "Tracer Color", color = GunAim.TracerColor, callback = function(c) GunAim.TracerColor = c; if TracerLine then TracerLine.Color = c end end })
AimTab:CreateDropdown({ name = "Aimbot Target", options = {"Killer", "Survivor", "Both"}, currentOption = "Killer", callback = function(opt) GunAim.TargetMode = opt end })
AimTab:CreateDropdown({ name = "Aim Part", options = {"Head", "HumanoidRootPart", "Torso"}, currentOption = "HumanoidRootPart", callback = function(opt) GunAim.AimPart = opt end })
AimTab:CreateSlider({ name = "Aimbot FOV", range = {50, 1000}, increment = 10, currentValue = 250, callback = function(v) GunAim.FOV = v end })
AimTab:CreateSlider({ name = "Aimbot Smoothness", range = {0.1, 1}, increment = 0.05, currentValue = 1, callback = function(v) GunAim.Strength = v end })
AimTab:CreateSlider({ name = "Aimbot Prediction", range = {0, 1}, increment = 0.01, currentValue = 0.12, callback = function(v) GunAim.PredictStrength = v end })
AimTab:CreateToggle({ name = "Visibility Check", currentValue = false, callback = function(v) GunAim.VisibilityCheck = v end })

AimTab:CreateSection("Killer Aim (Lock saat Hit)")
AimTab:CreateToggle({ name = "Killer Aim Lock", currentValue = false, callback = function(v) KillerAim.Enabled = v end })
AimTab:CreateSlider({ name = "Killer Aim FOV", range = {50, 500}, increment = 10, currentValue = 200, callback = function(v) KillerAim.FOV = v end })
AimTab:CreateSlider({ name = "Killer Aim Smoothness", range = {0.1, 1}, increment = 0.05, currentValue = 0.5, callback = function(v) KillerAim.Strength = v end })

local KillerTab = Window:CreateTab({ name = "Killer", icon = 4483362458 })

KillerTab:CreateSection("Attack")
KillerTab:CreateToggle({ name = "Auto Attack", currentValue = false, callback = function(v) Killer.AutoAttack = v end })
KillerTab:CreateToggle({ name = "Auto Kill All", currentValue = false, callback = function(v) Killer.KillAll = v end })

KillerTab:CreateSection("Carry & Hook")
KillerTab:CreateToggle({ name = "Auto Carry Downed", currentValue = false, callback = function(v) Killer.AutoCarry = v end })
KillerTab:CreateToggle({ name = "Auto Hook After Carry", currentValue = false, callback = function(v) Killer.AutoHook = v end })

KillerTab:CreateSection("Stalk")
KillerTab:CreateToggle({ name = "Auto Stalk", currentValue = false, callback = function(v) Killer.AutoStalk = v; if v then startAutoStalk() else stopAutoStalk() end end })
KillerTab:CreateSlider({ name = "Stalk Range", range = {50, 500}, increment = 10, suffix = "stud", currentValue = 150, callback = function(v) Killer.StalkRange = v end })

KillerTab:CreateSection("Masked Power")
KillerTab:CreateDropdown({ name = "Select Power", options = MaskedPowers, currentOption = "Cobra", callback = function(opt) Masked.CurrentPower = opt end })
KillerTab:CreateButton({ name = "Activate Power", callback = activateMasked })
KillerTab:CreateButton({ name = "Deactivate Power", callback = deactivateMasked })

local MiscTab = Window:CreateTab({ name = "Misc", icon = 4483362458 })

MiscTab:CreateSection("Walk Speed")
MiscTab:CreateToggle({ name = "Enable Walk Speed", currentValue = false, callback = function(v) Movement.WalkSpeedEnabled = v; if v then applyWalkSpeed() else local hum = getHum(); if hum then hum.WalkSpeed = Movement.OriginalWalkSpeed end end end })
MiscTab:CreateSlider({ name = "Walk Speed Value", range = {16, 100}, increment = 0.5, currentValue = 17.6, callback = function(v) Movement.WalkSpeedValue = v end })

MiscTab:CreateSection("Jump Power")
MiscTab:CreateToggle({ name = "Enable Jump Power", currentValue = false, callback = function(v) Movement.JumpPowerEnabled = v; if v then applyJumpPower() else local hum = getHum(); if hum then hum.JumpPower = Movement.OriginalJumpPower end end end })
MiscTab:CreateSlider({ name = "Jump Power Value", range = {0, 300}, increment = 5, currentValue = 50, callback = function(v) Movement.JumpPowerValue = v end })
MiscTab:CreateToggle({ name = "Infinite Jump", currentValue = false, callback = function(v) Movement.InfiniteJump = v end })

MiscTab:CreateSection("No Clip")
MiscTab:CreateToggle({ name = "No Clip", currentValue = false, callback = function(v) toggleNoClip(v) end })

MiscTab:CreateSection("Moonwalk")
MiscTab:CreateToggle({ name = "Moonwalk", currentValue = false, callback = function(v) Moonwalk.Enabled = v; if v then if not MoonwalkConnection then startMoonwalk() end else stopMoonwalk() end end })
MiscTab:CreateToggle({ name = "Moonwalk Button", currentValue = false, callback = function(v) Moonwalk.ShowButton = v; if v then createMoonwalkButton() else removeMoonwalkButton() end end })
MiscTab:CreateSlider({ name = "Spam Speed", range = {1, 50}, increment = 1, currentValue = 30, callback = function(v) Moonwalk.SpamSpeed = v end })
MiscTab:CreateSlider({ name = "Intensity", range = {1, 50}, increment = 1, currentValue = 35, callback = function(v) Moonwalk.Intensity = v end })

MiscTab:CreateSection("Emote")
MiscTab:CreateDropdown({ name = "Select Emote", options = EmoteList, currentOption = "Mannrobics", callback = function(opt) Emote.Selected = opt end })
MiscTab:CreateButton({ name = "Play Emote", callback = function() playEmote(Emote.Selected) end })

local VisualTab = Window:CreateTab({ name = "Visual", icon = 4483362458 })

VisualTab:CreateSection("Lighting")
VisualTab:CreateToggle({ name = "Fullbright", currentValue = false, callback = function(v) Visual.Fullbright = v; applyVisual() end })
VisualTab:CreateToggle({ name = "No Fog", currentValue = false, callback = function(v) Visual.NoFog = v; applyVisual() end })
VisualTab:CreateToggle({ name = "No Shadow", currentValue = false, callback = function(v) Visual.NoShadow = v; applyVisual() end })

VisualTab:CreateSection("Screen Effects")
VisualTab:CreateToggle({ name = "No Bloom", currentValue = false, callback = function(v) Visual.NoBloom = v; applyVisualExtended() end })
VisualTab:CreateToggle({ name = "No Blur / DOF", currentValue = false, callback = function(v) Visual.NoBlur = v; applyVisualExtended() end })

VisualTab:CreateSection("Color Correction")
VisualTab:CreateToggle({ name = "Enable Color Correction", currentValue = false, callback = function(v) Visual.ColorCorrection = v; applyColorCorrection() end })
VisualTab:CreateSlider({ name = "Saturation", range = {-1, 1}, increment = 0.05, currentValue = 0, callback = function(v) Visual.Saturation = v; applyColorCorrection() end })
VisualTab:CreateSlider({ name = "Brightness", range = {-1, 1}, increment = 0.05, currentValue = 0, callback = function(v) Visual.Brightness = v; applyColorCorrection() end })

local AntiLagTab = Window:CreateTab({ name = "Anti-Lag", icon = 4483362458 })

AntiLagTab:CreateSection("Anti-Lag Pack")
AntiLagTab:CreateToggle({ name = "Enable Anti-Lag", currentValue = false, callback = function(v) AntiLag.Enabled = v; if v then startAntiLag() end end })

AntiLagTab:CreateSection("Individual")
AntiLagTab:CreateToggle({ name = "No Particles", currentValue = false, callback = function(v) AntiLag.NoParticles = v; applyAntiLag() end })
AntiLagTab:CreateToggle({ name = "No Textures", currentValue = false, callback = function(v) AntiLag.NoTextures = v; applyAntiLag() end })
AntiLagTab:CreateToggle({ name = "Physics Throttle", currentValue = false, callback = function(v) AntiLag.PhysicsThrottle = v; applyAntiLag() end })
AntiLagTab:CreateToggle({ name = "No Global Shadows", currentValue = false, callback = function(v) AntiLag.NoGlobalShadows = v; applyAntiLag() end })
AntiLagTab:CreateToggle({ name = "Network Replication Lag", currentValue = false, callback = function(v) AntiLag.NetworkLag = v; applyAntiLag() end })

local CrosshairTab = Window:CreateTab({ name = "Crosshair", icon = 4483362458 })

CrosshairTab:CreateToggle({ name = "Enable Crosshair", currentValue = false, callback = function(v) Crosshair.Enabled = v end })
CrosshairTab:CreateColorPicker({ name = "Color", color = Crosshair.Color, callback = function(c) Crosshair.Color = c end })
CrosshairTab:CreateSlider({ name = "Size", range = {2, 30}, increment = 1, suffix = "px", currentValue = 8, callback = function(v) Crosshair.Size = v end })
CrosshairTab:CreateSlider({ name = "Thickness", range = {1, 5}, increment = 1, suffix = "px", currentValue = 2, callback = function(v) Crosshair.Thickness = v end })
CrosshairTab:CreateSlider({ name = "Position X", range = {-100, 100}, increment = 1, suffix = "px", currentValue = 0, callback = function(v) Crosshair.OffsetX = v end })
CrosshairTab:CreateSlider({ name = "Position Y", range = {-100, 100}, increment = 1, suffix = "px", currentValue = 0, callback = function(v) Crosshair.OffsetY = v end })

Rayfield:Notify({
    title = "TiarHub Full",
    content = "Script loaded! All features aktif.",
    duration = 6
})
