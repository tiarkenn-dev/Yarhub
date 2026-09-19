-- ================================================================
-- YARHUB ULTIMATE - FULL FALENS EDITION
-- PART 1 of 8
-- ================================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local isMobile = UserInputService.TouchEnabled

-- ALIASES
local LP = LocalPlayer
local PG = PlayerGui
local Cam = Camera
local WS = Workspace
local RS = RunService
local GS = GuiService
local VIM = VirtualInputManager
local Rep = ReplicatedStorage
local UIS = UserInputService

-- STATE
_G.SkillOn = false
_G.SkillMode = "Perfect"
_G.Fullbright = false
_G.NoFog = false
_G.AvaTarget = ""

-- HELPER
local function getRoot()
    return LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    return LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
end

local function getAnimId(id)
    return tostring(id):match("%d+")
end

local function IsKiller(p)
    if p:GetAttribute("Role") == "Killer" then return true end
    if p.Team and p.Team.Name == "Killer" then return true end
    return false
end

local function IsSurvivor(p)
    if p:GetAttribute("Role") == "Survivor" then return true end
    if p.Team and p.Team.Name == "Survivors" then return true end
    return false
end

-- GET DOWNED
local function GetDowned()
    local root = getRoot()
    if not root then return nil end
    local best, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
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

-- GET HOOK
local function GetHook()
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

-- REMOTES
local CarryEvent = Rep:WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("CarrySurvivorEvent")
local HookEvent = Rep:WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("HookEvent")
local AttackEvent = Rep:WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("BasicAttack")
local SkillCheckRemote = Rep:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("SkillCheckResultEvent")
local WiggleEvent = Rep:WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("SelfUnHookEvent")
local RepairEvent = Rep:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("RepairEvent")
local StalkEvent = Rep:FindFirstChild("Remotes") and Rep.Remotes:FindFirstChild("Killers") and Rep.Remotes.Killers:FindFirstChild("Stalker") and Rep.Remotes.Killers.Stalker:FindFirstChild("StartStalking")-- ================================================================
-- PART 2 of 8 - ESP FULL
-- ================================================================

local ESP = {
    Survivor = false,
    Killer = false,
    Generator = false,
    Pallet = false,
    Window = false,
    SCP = false,
    Distance = 500,
}

local ESPStatus = {
    Enabled = false,
    ShowName = true,
    ShowDistance = true,
    ShowHealth = false,
    Radius = 500,
}

local TeamColors = {
    Killer = Color3.fromRGB(255, 60, 60),
    Survivor = Color3.fromRGB(60, 255, 120),
}

local ESPObjects = {}
local CachedSCP = {}

for _, obj in ipairs(workspace:GetDescendants()) do
    local name = string.lower(obj.Name)
    if string.find(name, "scp") then
        CachedSCP[obj] = true
    end
end

workspace.DescendantAdded:Connect(function(obj)
    local name = string.lower(obj.Name)
    if string.find(name, "scp") then
        CachedSCP[obj] = true
    end
end)

local function removeESP(obj)
    if ESPObjects[obj] then
        ESPObjects[obj]:Destroy()
        ESPObjects[obj] = nil
    end
end

workspace.DescendantRemoving:Connect(function(obj)
    CachedSCP[obj] = nil
    removeESP(obj)
end)

local function createESP(obj, color)
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
        if not parent then removeESP(obj) end
    end)
end

-- ESP Generator
local GeneratorColor = Color3.fromRGB(255, 170, 0)
local PalletColor = Color3.fromRGB(74, 255, 181)
local WindowColor = Color3.fromRGB(74, 255, 181)
local SCPColor = Color3.fromRGB(255, 0, 0)

local function GetGameValue(obj, name)
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

local function ApplyGenHighlight(object, color)
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

local function CreateBillboard(text, color)
    local billboard = Instance.new("BillboardGui")
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
    return billboard
end

local function UpdateGenerator(generator)
    if not generator or not generator.Parent then return end
    if not ESP.Generator then
        local old = generator:FindFirstChild("GenESP")
        if old then old:Destroy() end
        local h = generator:FindFirstChild("GenHighlight")
        if h then h:Destroy() end
        return
    end
    local percent = GetGameValue(generator, "RepairProgress") or GetGameValue(generator, "Progress") or 0
    local billboard = generator:FindFirstChild("GenESP")
    if percent >= 100 then
        if billboard then billboard:Destroy() end
        return
    end
    local cp = math.clamp(percent, 0, 100)
    local color = GeneratorColor:Lerp(Color3.fromRGB(0,255,120), cp / 100)
    local text = string.format("[%.0f%%]", percent)
    if not billboard then
        billboard = CreateBillboard(text, color)
        billboard.Adornee = generator
        billboard.Parent = generator
    else
        local lbl = billboard:FindFirstChildOfClass("TextLabel")
        if lbl then
            lbl.Text = text
            lbl.TextColor3 = color
        end
    end
    ApplyGenHighlight(generator, color)
end

-- ESP Status Billboard
local StatusESP = {}

local function removeStatusESP(char)
    if StatusESP[char] then
        StatusESP[char]:Destroy()
        StatusESP[char] = nil
    end
end

local function createStatusESP(player, char, root)
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
    if isDown then text = "🔻 DOWN\n" end
    if ESPStatus.ShowName then text = text .. player.Name .. "\n" end
    if ESPStatus.ShowDistance then text = text .. string.format("Dist: %.0f\n", dist) end
    if ESPStatus.ShowHealth then text = text .. string.format("HP: %.0f\n", hum.Health) end
    if text == "" then
        removeStatusESP(char)
        return
    end
    local billboard = StatusESP[char]
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 120, 0, 50)
        billboard.AlwaysOnTop = true
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        local teamColor = Color3.new(1,1,1)
        if player.Team then
            if player.Team.Name == "Killer" then teamColor = TeamColors.Killer
            elseif player.Team.Name == "Survivors" then teamColor = TeamColors.Survivor end
        end
        if isDown then teamColor = Color3.fromRGB(255, 0, 0) end
        label.TextColor3 = teamColor
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
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
            local teamColor = Color3.new(1,1,1)
            if player.Team then
                if player.Team.Name == "Killer" then teamColor = TeamColors.Killer
                elseif player.Team.Name == "Survivors" then teamColor = TeamColors.Survivor end
            end
            if isDown then teamColor = Color3.fromRGB(255, 0, 0) end
            label.TextColor3 = teamColor
        end
    end
end

-- ESP Update Loop
task.spawn(function()
    while task.wait(0.3) do
        local root = getRoot()
        if not root then
            task.wait(1)
            continue
        end
        
        -- Cleanup
        for obj in pairs(ESPObjects) do
            if not obj.Parent then
                ESPObjects[obj]:Destroy()
                ESPObjects[obj] = nil
            end
        end
        
        -- ESP SCP
        if ESP.SCP then
            for obj in pairs(CachedSCP) do
                if obj and obj.Parent then
                    local pos
                    if obj:IsA("Model") then pos = obj:GetPivot().Position
                    elseif obj:IsA("BasePart") then pos = obj.Position end
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
        else
            for obj in pairs(CachedSCP) do
                removeESP(obj)
            end
        end
        
        -- ESP Generator
        for _, gen in ipairs(workspace:GetDescendants()) do
            if gen:IsA("Model") and gen.Name == "Generator" then
                UpdateGenerator(gen)
            end
        end
        
        -- ESP Window + Pallet
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "Window" then
                if ESP.Window then
                    local pos = obj:IsA("Model") and obj:GetPivot().Position or (obj:IsA("BasePart") and obj.Position)
                    if pos and (pos - root.Position).Magnitude <= ESP.Distance then
                        createESP(obj, WindowColor)
                    else
                        removeESP(obj)
                    end
                else
                    removeESP(obj)
                end
            end
            if obj.Name == "Pallet" or obj.Name == "Palletwrong" then
                if ESP.Pallet then
                    local pos = obj:IsA("Model") and obj:GetPivot().Position or (obj:IsA("BasePart") and obj.Position)
                    if pos and (pos - root.Position).Magnitude <= ESP.Distance then
                        createESP(obj, PalletColor)
                    else
                        removeESP(obj)
                    end
                else
                    removeESP(obj)
                end
            end
        end
        
        -- ESP Players + Status Billboard
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist <= ESP.Distance then
                        local killer = IsKiller(p)
                        if killer and ESP.Killer then
                            createESP(p.Character, TeamColors.Killer)
                        elseif not killer and ESP.Survivor then
                            createESP(p.Character, TeamColors.Survivor)
                        else
                            removeESP(p.Character)
                        end
                        createStatusESP(p, p.Character, root)
                    else
                        removeESP(p.Character)
                        removeStatusESP(p.Character)
                    end
                end
            end
        end
    end
end)-- ================================================================
-- PART 3 of 8 - SKILLCHECK + PARRY
-- ================================================================

-- AUTO SKILL CHECK
local Skill = { LastGoal = nil, Clicked = false, WasActive = false }
local SkillBusy = false

local function PressSkill()
    if isMobile then
        local btn = PG:FindFirstChild("check", true)
        if btn and btn:IsA("GuiObject") then
            local p, s = btn.AbsolutePosition, btn.AbsoluteSize
            local ins = GS:GetGuiInset()
            local x = p.X + s.X/2 + ins.X
            local y = p.Y + s.Y/2 + ins.Y
            pcall(function() VIM:SendTouchEvent(8822, 0, x, y) end)
            task.wait(0.01)
            pcall(function() VIM:SendTouchEvent(8822, 2, x, y) end)
        end
    else
        pcall(function() VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game) end)
        task.wait(0.01)
        pcall(function() VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game) end)
    end
end

local function GetCheck()
    for _, n in ipairs({"SkillCheckPromptGui", "SkillCheckPromptGui-con"}) do
        local g = PG:FindFirstChild(n, true)
        if g then
            local c = g:FindFirstChild("Check", true)
            if c and c.Visible then
                local l = c:FindFirstChild("Line", true)
                local go = c:FindFirstChild("Goal", true)
                if l and go then return l, go end
            end
        end
    end
end

local function AngDiff(a, b)
    local d = b - a
    if d > 180 then d = d - 360 end
    if d < -180 then d = d + 360 end
    return d
end

local function UpdateSkill()
    if SkillBusy then return end
    local line, goal = GetCheck()
    if not (line and goal) then
        Skill.LastGoal = nil; Skill.Clicked = false; Skill.WasActive = false
        return
    end
    local lr = line.Rotation % 360
    local gr = goal.Rotation % 360
    if _G.SkillMode == "Instan" then
        if not Skill.WasActive then
            Skill.WasActive = true
            SkillBusy = true
            task.spawn(function()
                PressSkill()
                task.wait(0.05)
                SkillBusy = false
            end)
        end
        Skill.LastGoal = gr
        return
    end
    if not Skill.WasActive then
        Skill.WasActive = true; Skill.LastGoal = gr; Skill.Clicked = false
        return
    end
    if Skill.LastGoal and math.abs(AngDiff(Skill.LastGoal, gr)) > 5 then
        Skill.Clicked = false
    end
    Skill.LastGoal = gr
    if Skill.Clicked then return end
    local sR = (gr + 102) % 360
    local eR = (gr + 116) % 360
    local inZone
    if sR > eR then inZone = (lr >= sR or lr <= eR)
    else inZone = (lr >= sR and lr <= eR) end
    if inZone then
        Skill.Clicked = true
        SkillBusy = true
        task.spawn(function()
            PressSkill()
            task.wait(0.05)
            SkillBusy = false
        end)
    end
end

RS.RenderStepped:Connect(function()
    if _G.SkillOn then UpdateSkill() end
end)

-- AUTO PARRY + CIRCLE
local Auto = {
    Parry = false,
    ParryDelay = 0,
    ParryCooldown = 1,
    ParryDistance = 15,
    FaceSensitivity = 0.7,
    RequireFacing = true,
}

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
    ["rbxassetid://138720291317243"] = true,
}

local ParryRangeVisual = { Enabled = false, Color = Color3.fromRGB(255, 80, 80), Transparency = 0.9 }
local ParryCircle = nil

local function updateParryCircle()
    local root = getRoot()
    if not ParryRangeVisual.Enabled or not root then
        if ParryCircle then ParryCircle:Destroy(); ParryCircle = nil end
        return
    end
    if not ParryCircle then
        ParryCircle = Instance.new("Part")
        ParryCircle.Shape = Enum.PartType.Cylinder
        ParryCircle.Anchored = true
        ParryCircle.CanCollide = false
        ParryCircle.Material = Enum.Material.Neon
        ParryCircle.Name = "ParryRangeCircle"
        ParryCircle.Parent = workspace
    end
    local size = Auto.ParryDistance * 2
    ParryCircle.Size = Vector3.new(0.2, size, size)
    local yOffset = root.Size.Y / 2 + 1.5
    ParryCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0)) * CFrame.Angles(0, 0, math.rad(90))
    ParryCircle.Color = ParryRangeVisual.Color
    ParryCircle.Transparency = ParryRangeVisual.Transparency
end

local function pressRightClick()
    VIM:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait()
    VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0)
end

local AttackPaths = {
    "Slasher-mob.Controls.attack",
    "Masked-mob.Controls.attack",
    "Killer-mob.Controls.attack"
}

local function GetParryButton()
    local current = PG
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function pressParryButton()
    if UIS.TouchEnabled then
        local btn = GetParryButton()
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = GS:GetGuiInset()
            local x = pos.X + size.X/2 + inset.X
            local y = pos.Y + size.Y/2 + inset.Y
            VIM:SendTouchEvent(8823, 0, x, y)
            task.wait(0.01)
            VIM:SendTouchEvent(8823, 2, x, y)
        end
    else
        pressRightClick()
    end
end

local lastParry = 0
local PARRY_DEBOUNCE = 0.2

local function doParry()
    local now = tick()
    if now - lastParry < PARRY_DEBOUNCE then return end
    lastParry = now
    pressParryButton()
end

local function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end
    local dist = (enemyRoot.Position - myRoot.Position).Magnitude
    return dist <= Auto.ParryDistance
end

local function isFacingTarget(targetChar)
    if not Auto.RequireFacing then return true end
    local myChar = LP.Character
    if not myChar then return false end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local enemyRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not enemyRoot then return false end
    local enemyForward = enemyRoot.CFrame.LookVector
    local directionToMe = (myRoot.Position - enemyRoot.Position).Unit
    local dot = enemyForward:Dot(directionToMe)
    if Auto.FaceSensitivity <= -1 then return true end
    return dot >= Auto.FaceSensitivity
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
        if not Auto.Parry then return end
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

task.spawn(function()
    while task.wait(2) do
        if Auto.Parry then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and IsKiller(p) then
                    hookKiller(p.Character)
                end
            end
        end
    end
end)

RS.RenderStepped:Connect(updateParryCircle)-- ================================================================
-- PART 4 of 8 - AIMBOT
-- ================================================================

local GunAim = {
    Enabled = false,
    Holding = false,
    TargetMode = "Killer",
    Strength = 1,
    Predict = true,
    PredictStrength = 0.12,
    FOV = 250,
    VisibilityCheck = true,
    Target = nil,
    AimPart = "HumanoidRootPart"
}

local AttackAim = {
    Enabled = false,
    Holding = false,
    Strength = 1,
    Predict = true,
    PredictStrength = 0.12,
    FOV = 250,
    VisibilityCheck = true,
    AimPart = "HumanoidRootPart"
}

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = true
        AttackAim.Holding = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = false
        AttackAim.Holding = false
    end
end)

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist

local function isVisible(part)
    local cam = workspace.CurrentCamera
    RayParams.FilterDescendantsInstances = { LP.Character }
    local origin = cam.CFrame.Position
    local direction = (part.Position - origin)
    local result = workspace:Raycast(origin, direction, RayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

local function getClosestGunTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest = nil
    local shortest = GunAim.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team then
            local valid = false
            if GunAim.TargetMode == "Killer" and IsKiller(p) then valid = true
            elseif GunAim.TargetMode == "Survivor" and IsSurvivor(p) then valid = true end
            if valid then
                local hrp = p.Character:FindFirstChild(GunAim.AimPart)
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest then
                            if GunAim.VisibilityCheck then
                                if not isVisible(hrp) then continue end
                            end
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

local function getClosestAttackTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest = nil
    local shortest = AttackAim.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and IsSurvivor(p) and p.Character then
            local hrp = p.Character:FindFirstChild(AttackAim.AimPart)
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
    return closest
end

RS.RenderStepped:Connect(function()
    if GunAim.Enabled and GunAim.Holding then
        local target = getClosestGunTarget()
        if target then
            local cam = workspace.CurrentCamera
            local pos = target.Position
            if GunAim.Predict then
                pos = pos + (target.AssemblyLinearVelocity * GunAim.PredictStrength)
            end
            local cf = CFrame.new(cam.CFrame.Position, pos)
            cam.CFrame = cam.CFrame:Lerp(cf, GunAim.Strength)
        end
    end
    if AttackAim.Enabled and AttackAim.Holding then
        local target = getClosestAttackTarget()
        if target then
            local cam = workspace.CurrentCamera
            local pos = target.Position
            if AttackAim.Predict then
                pos = pos + (target.AssemblyLinearVelocity * AttackAim.PredictStrength)
            end
            cam.CFrame = CFrame.new(cam.CFrame.Position, pos)
        end
    end
end)-- ================================================================
-- PART 5 of 8 - KILLER FEATURES
-- ================================================================

local AutoKill = {
    KillAll = false,
    AutoAttack = false,
    AutoCarry = false,
    KillRange = 500,
    AttackDelay = 0.45
}

local AutoStalk = {
    Enabled = false,
    StalkRange = 150,
    Target = nil
}

local Auto = Auto or {}
Auto.Wiggle = false
Auto.WiggleSpam = 5

local KillerBusy = false
local KillerTarget = nil

-- AUTO KILL ALL
RS.Heartbeat:Connect(function()
    if not AutoKill.KillAll then return end
    local root = getRoot()
    if not root then return end
    local closest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and IsSurvivor(plr) then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < shortest then shortest = d; closest = plr.Character end
            end
        end
    end
    if closest and shortest <= AutoKill.KillRange then
        pcall(function()
            if AttackEvent then AttackEvent:FireServer(closest) end
        end)
    end
end)

-- AUTO WIGGLE
task.spawn(function()
    while task.wait(0.2) do
        if not Auto.Wiggle then continue end
        local char = LP.Character
        if not char then continue end
        local carried = (char:FindFirstChild("IsCarried") and char.IsCarried.Value) 
            or (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)
        if carried and WiggleEvent then
            for i = 1, Auto.WiggleSpam do
                pcall(function() WiggleEvent:FireServer() end)
            end
        end
    end
end)

-- AUTO STALK
local StalkConnection = nil

local function getClosestSurvivorForStalk()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and IsSurvivor(plr) then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist <= AutoStalk.StalkRange and dist < shortest then
                    shortest = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

local function startAutoStalk()
    if StalkConnection then return end
    StalkConnection = RS.Heartbeat:Connect(function()
        if not AutoStalk.Enabled then return end
        local target = getClosestSurvivorForStalk()
        if not target or not target.Character then return end
        if StalkEvent then
            pcall(function() StalkEvent:FireServer(target) end)
        end
    end)
end

local function stopAutoStalk()
    if StalkConnection then
        StalkConnection:Disconnect()
        StalkConnection = nil
    end
end

-- AUTO CARRY
task.spawn(function()
    while task.wait(0.5) do
        if not AutoKill.AutoCarry then continue end
        local downed = GetDowned()
        if downed then
            pcall(function()
                if CarryEvent then CarryEvent:FireServer(downed) end
            end)
        end
    end
end)-- ================================================================
-- PART 6 of 8 - VISUAL
-- ================================================================

local Visual = {
    Fullbright = false,
    NoShadow = false,
    Ambient = false,
    AmbientColor = Color3.fromRGB(255,255,255),
    ClockTimeEnabled = true,
    Brightness = 2,
    ClockTime = 14,
    LowGraphics = false,
    NoFog = false,
    CleanSky = false,
    NoScreenEffects = false
}

local OrigVisual = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows
}

local LastState = { Fullbright = nil, NoShadow = nil, Ambient = nil, AmbientColor = nil, Brightness = nil, ClockTime = nil, LowGraphics = nil, CleanSky = nil }

local function applyVisual(force)
    if force or LastState.Fullbright ~= Visual.Fullbright then
        LastState.Fullbright = Visual.Fullbright
        if Visual.Fullbright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.new(1,1,1)
            Lighting.OutdoorAmbient = Color3.new(1,1,1)
        else
            Lighting.Brightness = OrigVisual.Brightness
            Lighting.ClockTime = OrigVisual.ClockTime
            Lighting.Ambient = OrigVisual.Ambient
            Lighting.OutdoorAmbient = OrigVisual.OutdoorAmbient
        end
    end
    if force or LastState.NoShadow ~= Visual.NoShadow then
        LastState.NoShadow = Visual.NoShadow
        Lighting.GlobalShadows = not Visual.NoShadow
    end
    if force or LastState.Ambient ~= Visual.Ambient or LastState.AmbientColor ~= Visual.AmbientColor or LastState.Brightness ~= Visual.Brightness or LastState.ClockTime ~= Visual.ClockTime then
        LastState.Ambient = Visual.Ambient
        LastState.AmbientColor = Visual.AmbientColor
        LastState.Brightness = Visual.Brightness
        LastState.ClockTime = Visual.ClockTime
        if Visual.Ambient then
            Lighting.Ambient = Visual.AmbientColor
            Lighting.OutdoorAmbient = Visual.AmbientColor
            Lighting.Brightness = Visual.Brightness
            Lighting.ClockTime = Visual.ClockTime
        elseif not Visual.Fullbright then
            Lighting.Brightness = OrigVisual.Brightness
            Lighting.ClockTime = OrigVisual.ClockTime
            Lighting.Ambient = OrigVisual.Ambient
            Lighting.OutdoorAmbient = OrigVisual.OutdoorAmbient
        end
    end
end-- ================================================================
-- PART 7 of 8 - MOVEMENT + CAMERA + CROSSHAIR + AVATAR
-- ================================================================

local Movement = {
    JumpPowerEnabled = false,
    JumpPowerValue = 50,
    OriginalJumpPower = 50,
    WalkSpeedEnabled = false,
    WalkSpeedValue = 17.6,
    OriginalWalkSpeed = 16,
    NoClip = false
}

local PlayerMods = { GodMode = false }

local SpeedBoostLite = { Enabled = false, Value = 16, Original = 16 }

task.spawn(function()
    while task.wait(0.1) do
        if Movement.WalkSpeedEnabled then
            local hum = getHum()
            if hum and hum.WalkSpeed ~= Movement.WalkSpeedValue then
                hum.WalkSpeed = Movement.WalkSpeedValue
            end
        end
        if SpeedBoostLite.Enabled then
            local hum = getHum()
            if hum and hum.WalkSpeed ~= SpeedBoostLite.Value then
                hum.WalkSpeed = SpeedBoostLite.Value
            end
        end
        if Movement.JumpPowerEnabled then
            local hum = getHum()
            if hum and hum.JumpPower ~= Movement.JumpPowerValue then
                hum.JumpPower = Movement.JumpPowerValue
            end
        end
    end
end)

-- NOCLIP
local NoClipConnection = nil
local function applyNoClip()
    local char = LP.Character
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not Movement.NoClip
        end
    end
end

local function toggleNoClip(state)
    Movement.NoClip = state
    if state then
        if NoClipConnection then NoClipConnection:Disconnect() end
        NoClipConnection = RS.RenderStepped:Connect(applyNoClip)
    else
        if NoClipConnection then NoClipConnection:Disconnect() NoClipConnection = nil end
        applyNoClip()
    end
end

-- GOD MODE
local function applyGodMode()
    if not PlayerMods.GodMode then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum.Health < hum.MaxHealth then
        pcall(function() hum.Health = hum.MaxHealth end)
    end
    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Dead or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Ragdoll then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end

task.spawn(function()
    while task.wait(0.3) do
        if PlayerMods.GodMode then applyGodMode() end
    end
end)

-- CAMERA ZOOM + FOV
local CameraZoom = {
    UnlimitedZoom = false,
    MaxDistance = 1000,
    MinDistance = 0,
    FOVEnabled = false,
    FOV = 70,
    DefaultFOV = workspace.CurrentCamera.FieldOfView
}

local function applyUnlimitedZoom()
    if CameraZoom.UnlimitedZoom then
        LP.CameraMaxZoomDistance = CameraZoom.MaxDistance
        LP.CameraMinZoomDistance = CameraZoom.MinDistance
    else
        LP.CameraMaxZoomDistance = 128
        LP.CameraMinZoomDistance = 0.5
    end
end

local function applyCameraFOV()
    local cam = workspace.CurrentCamera
    if not cam then return end
    if CameraZoom.FOVEnabled then
        cam.FieldOfView = CameraZoom.FOV
    else
        cam.FieldOfView = CameraZoom.DefaultFOV
    end
end

-- CROSSHAIR
local Crosshair = {
    Enabled = false,
    Size = 8,
    Thickness = 2,
    Color = Color3.fromRGB(255,255,255),
    Style = "Plus",
    OffsetX = 0,
    OffsetY = 0
}

local CrosshairDrawings = {}
local created = false
local LastCrosshairStyle = nil

local function clearCrosshair()
    for _,v in pairs(CrosshairDrawings) do
        if v.Remove then v:Remove() end
    end
    CrosshairDrawings = {}
    created = false
end

RS.RenderStepped:Connect(function()
    if not Crosshair.Enabled then
        for _,v in pairs(CrosshairDrawings) do
            if v then v.Visible = false end
        end
        return
    end
    if LastCrosshairStyle ~= Crosshair.Style then
        clearCrosshair()
        LastCrosshairStyle = Crosshair.Style
    end
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2 + Crosshair.OffsetX, cam.ViewportSize.Y / 2 + Crosshair.OffsetY)
    if not created then
        created = true
        if Crosshair.Style == "Plus" then
            for i = 1,4 do
                local line = Drawing.new("Line")
                line.Visible = true
                table.insert(CrosshairDrawings, line)
            end
        elseif Crosshair.Style == "Dot" then
            local dot = Drawing.new("Circle")
            dot.Filled = true
            dot.Visible = true
            table.insert(CrosshairDrawings, dot)
        elseif Crosshair.Style == "Circle" then
            local circle = Drawing.new("Circle")
            circle.Filled = false
            circle.Visible = true
            table.insert(CrosshairDrawings, circle)
        end
    end
    if Crosshair.Style == "Plus" then
        for _,line in pairs(CrosshairDrawings) do
            line.Color = Crosshair.Color
            line.Thickness = Crosshair.Thickness
        end
        CrosshairDrawings[1].From = center + Vector2.new(-Crosshair.Size,0)
        CrosshairDrawings[1].To = center + Vector2.new(-2,0)
        CrosshairDrawings[2].From = center + Vector2.new(Crosshair.Size,0)
        CrosshairDrawings[2].To = center + Vector2.new(2,0)
        CrosshairDrawings[3].From = center + Vector2.new(0,-Crosshair.Size)
        CrosshairDrawings[3].To = center + Vector2.new(0,-2)
        CrosshairDrawings[4].From = center + Vector2.new(0,Crosshair.Size)
        CrosshairDrawings[4].To = center + Vector2.new(0,2)
    elseif Crosshair.Style == "Dot" then
        local dot = CrosshairDrawings[1]
        dot.Position = center
        dot.Radius = Crosshair.Size / 2
        dot.Color = Crosshair.Color
    elseif Crosshair.Style == "Circle" then
        local circle = CrosshairDrawings[1]
        circle.Position = center
        circle.Radius = Crosshair.Size
        circle.Color = Crosshair.Color
        circle.Thickness = Crosshair.Thickness
    end
end)

-- AVATAR STEALER
local AvatarStealer = {
    OriginalDescription = nil,
    CurrentStealedUserId = nil,
    BlockyBody = true
}

local function saveOriginalAppearance()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        AvatarStealer.OriginalDescription = hum:GetAppliedDescription()
    end
end

local function applyBlockyBody(character)
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local desc = Instance.new("HumanoidDescription")
    desc.BodyTypeScale = 1
    desc.DepthScale = 1
    desc.HeadScale = 1
    desc.HeightScale = 1
    desc.ProportionScale = 0
    desc.WidthScale = 1
    hum:ApplyDescriptionClientServer(desc)
end

local function removeAllClothingAndAccessories(character)
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("Accessory") or v:IsA("Clothing") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
            v:Destroy()
        end
    end
end

local function copyAvatar(username)
    if not username or username == "" then return end
    saveOriginalAppearance()
    local success, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    if not success then return end
    AvatarStealer.CurrentStealedUserId = userId
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    task.spawn(function()
        local desc = Players:GetHumanoidDescriptionFromUserId(userId)
        if AvatarStealer.BlockyBody then
            applyBlockyBody(char)
            task.wait(0.3)
        end
        removeAllClothingAndAccessories(char)
        task.wait(0.2)
        hum:ApplyDescriptionClientServer(desc)
    end)
end

local function resetAvatar()
    if not AvatarStealer.OriginalDescription then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        removeAllClothingAndAccessories(char)
        hum:ApplyDescriptionClientServer(AvatarStealer.OriginalDescription)
        AvatarStealer.CurrentStealedUserId = nil
    end
    end-- ================================================================
-- PART 8 of 8 - UI RAYFIELD
-- ================================================================

local Win = Rayfield:CreateWindow({
   Name = "Yarhub Ultimate - Full Falens",
   LoadingTitle = "Yarhub",
   LoadingSubtitle = "by Yarhub",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false,
   Theme = {
      AccentColor     = Color3.fromRGB(0, 120, 220),
      BackgroundColor = Color3.fromRGB(10, 20, 40),
      MainColor       = Color3.fromRGB(20, 40, 80),
      OutlineColor    = Color3.fromRGB(50, 130, 230),
      FontColor       = Color3.fromRGB(200, 230, 255),
   }
})

local VisualT  = Win:CreateTab("Visual")
local SkillT   = Win:CreateTab("Skillcheck")
local ParryT   = Win:CreateTab("Parry")
local AimT     = Win:CreateTab("Aimbot")
local KillerT  = Win:CreateTab("Killer")
local EspT     = Win:CreateTab("ESP")
local MoveT    = Win:CreateTab("Movement")
local AvatarT  = Win:CreateTab("Avatar")
local InfoT    = Win:CreateTab("Info")

Rayfield:Notify({Title="Yarhub", Content="Full Falens Edition dimuat!", Duration=5})

-- VISUAL
VisualT:CreateSection("Render")
VisualT:CreateToggle({Name="Fullbright", CurrentValue=false,
   Callback=function(v) ToggleFullbright(v) end})
VisualT:CreateToggle({Name="No Fog", CurrentValue=false,
   Callback=function(v) ToggleNoFog(v) end})
VisualT:CreateToggle({Name="No Shadow", CurrentValue=false,
   Callback=function(v)
      Visual.NoShadow = v
      applyVisual(true)
   end})
VisualT:CreateToggle({Name="Clean Sky", CurrentValue=false,
   Callback=function(v) ApplyCleanSky(v) end})
VisualT:CreateToggle({Name="No Screen Effects", CurrentValue=false,
   Callback=function(v) ApplyNoScreenEffects(v) end})
VisualT:CreateToggle({Name="Low Graphics", CurrentValue=false,
   Callback=function(v) ApplyLowGraphics(v) end})
VisualT:CreateToggle({Name="Custom Ambient", CurrentValue=false,
   Callback=function(v)
      Visual.Ambient = v
      applyVisual(true)
   end})
VisualT:CreateColorPicker({Name="Ambient Color", Color=Color3.fromRGB(255,255,255),
   Callback=function(c)
      Visual.AmbientColor = c
      applyVisual(true)
   end})

VisualT:CreateSection("Camera")
VisualT:CreateToggle({Name="Unlimited Zoom", CurrentValue=false,
   Callback=function(v)
      CameraZoom.UnlimitedZoom = v
      applyUnlimitedZoom()
   end})
VisualT:CreateSlider({Name="Max Zoom Distance", Range={200,5000}, Increment=100, CurrentValue=1000,
   Callback=function(v)
      CameraZoom.MaxDistance = v
      if CameraZoom.UnlimitedZoom then applyUnlimitedZoom() end
   end})
VisualT:CreateToggle({Name="FOV Changer", CurrentValue=false,
   Callback=function(v)
      CameraZoom.FOVEnabled = v
      applyCameraFOV()
   end})
VisualT:CreateSlider({Name="FOV Value", Range={50,120}, Increment=1, CurrentValue=70,
   Callback=function(v)
      CameraZoom.FOV = v
      if CameraZoom.FOVEnabled then applyCameraFOV() end
   end})

VisualT:CreateSection("Crosshair")
VisualT:CreateToggle({Name="Aktifkan Crosshair", CurrentValue=false,
   Callback=function(v) Crosshair.Enabled = v end})
VisualT:CreateDropdown({Name="Style", Options={"Plus","Dot","Circle"},
   CurrentOption={"Plus"},
   Callback=function(O) Crosshair.Style = O[1] end})
VisualT:CreateSlider({Name="Ukuran", Range={3,20}, Increment=1, CurrentValue=8,
   Callback=function(v) Crosshair.Size = v end})
VisualT:CreateColorPicker({Name="Warna", Color=Color3.fromRGB(255,255,255),
   Callback=function(c) Crosshair.Color = c end})

-- SKILLCHECK
SkillT:CreateSection("Auto Skillcheck")
SkillT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v) _G.SkillOn = v end})
SkillT:CreateDropdown({Name="Mode", Options={"Instan","Perfect"},
   CurrentOption={"Perfect"},
   Callback=function(O) _G.SkillMode = O[1] end})

-- PARRY
ParryT:CreateSection("Auto Parry")
ParryT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v) Auto.Parry = v end})
ParryT:CreateSlider({Name="Jarak Parry", Range={5,30}, Increment=1, CurrentValue=15,
   Callback=function(v) Auto.ParryDistance = v end})
ParryT:CreateToggle({Name="Wajib Menghadap", CurrentValue=true,
   Callback=function(v) Auto.RequireFacing = v end})
ParryT:CreateToggle({Name="Lingkaran Visual", CurrentValue=false,
   Callback=function(v) ParryRangeVisual.Enabled = v end})

-- AIMBOT
AimT:CreateSection("Gun Aimbot")
AimT:CreateToggle({Name="Aktifkan Gun Aimbot", CurrentValue=false,
   Callback=function(v) GunAim.Enabled = v end})
AimT:CreateDropdown({Name="Target", Options={"Killer","Survivor"},
   CurrentOption={"Killer"}, Callback=function(O) GunAim.TargetMode = O[1] end})
AimT:CreateSlider({Name="Strength", Range={0.05,1}, Increment=0.05, CurrentValue=1,
   Callback=function(v) GunAim.Strength = v end})
AimT:CreateSlider({Name="FOV", Range={50,500}, Increment=10, CurrentValue=250,
   Callback=function(v) GunAim.FOV = v end})
AimT:CreateToggle({Name="Wallcheck", CurrentValue=true,
   Callback=function(v) GunAim.VisibilityCheck = v end})

AimT:CreateSection("Attack Aimbot (Killer)")
AimT:CreateToggle({Name="Aktifkan Attack Aimbot", CurrentValue=false,
   Callback=function(v) AttackAim.Enabled = v end})
AimT:CreateSlider({Name="Strength Attack", Range={0.05,1}, Increment=0.05, CurrentValue=1,
   Callback=function(v) AttackAim.Strength = v end})
AimT:CreateSlider({Name="FOV Attack", Range={50,500}, Increment=10, CurrentValue=250,
   Callback=function(v) AttackAim.FOV = v end})

-- KILLER
KillerT:CreateSection("Auto Kill All ⚠️")
KillerT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v) AutoKill.KillAll = v end})
KillerT:CreateSlider({Name="Kill Range", Range={50,1000}, Increment=50, CurrentValue=500,
   Callback=function(v) AutoKill.KillRange = v end})

KillerT:CreateSection("Auto Stalk")
KillerT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v)
      AutoStalk.Enabled = v
      if v then startAutoStalk() else stopAutoStalk() end
   end})
KillerT:CreateSlider({Name="Stalk Range", Range={50,300}, Increment=10, CurrentValue=150,
   Callback=function(v) AutoStalk.StalkRange = v end})

KillerT:CreateSection("Auto Carry")
KillerT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v) AutoKill.AutoCarry = v end})

KillerT:CreateSection("Auto Wiggle")
KillerT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v) Auto.Wiggle = v end})
KillerT:CreateSlider({Name="Spam per Detik", Range={1,20}, Increment=1, CurrentValue=5,
   Callback=function(v) Auto.WiggleSpam = v end})

-- ESP
EspT:CreateSection("Target")
EspT:CreateToggle({Name="Survivor (Hijau)", CurrentValue=false,
   Callback=function(v) ESP.Survivor = v end})
EspT:CreateToggle({Name="Killer (Merah)", CurrentValue=false,
   Callback=function(v) ESP.Killer = v end})
EspT:CreateToggle({Name="Generator (Oranye)", CurrentValue=false,
   Callback=function(v) ESP.Generator = v end})
EspT:CreateToggle({Name="Pallet", CurrentValue=false,
   Callback=function(v) ESP.Pallet = v end})
EspT:CreateToggle({Name="Window", CurrentValue=false,
   Callback=function(v) ESP.Window = v end})
EspT:CreateToggle({Name="SCP", CurrentValue=false,
   Callback=function(v) ESP.SCP = v end})
EspT:CreateSlider({Name="Jarak Max", Range={50,2000}, Increment=50, CurrentValue=500,
   Callback=function(v) ESP.Distance = v end})

EspT:CreateSection("ESP Status")
EspT:CreateToggle({Name="Status Billboard", CurrentValue=false,
   Callback=function(v) ESPStatus.Enabled = v end})
EspT:CreateToggle({Name="Tampilkan Nama", CurrentValue=true,
   Callback=function(v) ESPStatus.ShowName = v end})
EspT:CreateToggle({Name="Tampilkan Jarak", CurrentValue=true,
   Callback=function(v) ESPStatus.ShowDistance = v end})
EspT:CreateToggle({Name="Tampilkan HP", CurrentValue=false,
   Callback=function(v) ESPStatus.ShowHealth = v end})

-- MOVEMENT
MoveT:CreateSection("Speed")
MoveT:CreateToggle({Name="WalkSpeed ON", CurrentValue=false,
   Callback=function(v) Movement.WalkSpeedEnabled = v end})
MoveT:CreateSlider({Name="WalkSpeed Value", Range={16,100}, Increment=2, CurrentValue=20,
   Callback=function(v) Movement.WalkSpeedValue = v end})
MoveT:CreateToggle({Name="JumpPower ON", CurrentValue=false,
   Callback=function(v) Movement.JumpPowerEnabled = v end})
MoveT:CreateSlider({Name="JumpPower Value", Range={50,200}, Increment=5, CurrentValue=50,
   Callback=function(v) Movement.JumpPowerValue = v end})

MoveT:CreateSection("Noclip")
MoveT:CreateToggle({Name="Noclip", CurrentValue=false,
   Callback=function(v) toggleNoClip(v) end})

MoveT:CreateSection("God Mode ⚠️")
MoveT:CreateToggle({Name="Aktifkan God Mode", CurrentValue=false,
   Callback=function(v)
      PlayerMods.GodMode = v
      if v then Rayfield:Notify({Title="⚠️", Content="God Mode ON - risiko ban!", Duration=4}) end
   end})

-- AVATAR
AvatarT:CreateSection("Copy Avatar")
AvatarT:CreateInput({
   Name = "Username Target",
   PlaceholderText = "Masukkan username...",
   RemoveTextAfterFocusLost = false,
   Callback = function(text) _G.AvaTarget = text end,
})
AvatarT:CreateToggle({Name="Blocky Body", CurrentValue=true,
   Callback=function(v) AvatarStealer.BlockyBody = v end})
AvatarT:CreateButton({Name="Copy Avatar",
   Callback=function()
      if _G.AvaTarget then copyAvatar(_G.AvaTarget) end
   end})
AvatarT:CreateButton({Name="Reset Avatar",
   Callback=function() resetAvatar() end})

-- INFO
InfoT:CreateSection("Tentang")
InfoT:CreateParagraph({
   Title = "Yarhub Ultimate - Full Falens",
   Content = "Fitur Lengkap:\n" ..
             "- ESP (Survivor + Killer + Gen + Pallet + Window + SCP + Status)\n" ..
             "- Auto Skillcheck (2 Mode)\n" ..
             "- Auto Parry + Face Check + Circle\n" ..
             "- Aimbot (Gun + Attack + Wallcheck)\n" ..
             "- Killer (Auto Kill + Stalk + Carry + Wiggle)\n" ..
             "- Visual (Fullbright + No Fog + No Shadow + Clean Sky + No Screen + Low Graphics)\n" ..
             "- Camera (Zoom + FOV)\n" ..
             "- Crosshair Custom\n" ..
             "- Movement (Speed + Jump + Noclip + God Mode)\n" ..
             "- Copy Avatar + Blocky Body\n\n" ..
             "Total: 61 Fitur Falens\n" ..
             "Dibuat oleh: Yarhub"
})
