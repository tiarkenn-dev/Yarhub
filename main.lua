-- ================================================================
-- YARHUB ULTIMATE - REBUILD
-- PART 1 of 6
-- ================================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local WS = game:GetService("Workspace")
local RS = game:GetService("RunService")
local GS = game:GetService("GuiService")
local VIM = game:GetService("VirtualInputManager")
local Rep = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local Cam = WS.CurrentCamera
local isMobile = UIS.TouchEnabled

_G.SkillOn = false
_G.SkillMode = "Perfect"
_G.Fullbright = false
_G.NoFog = false
_G.AvaTarget = ""

-- HELPER
local function GetRoot()
    return LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
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

-- FULLBRIGHT + NO FOG
local OrigLight = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart
}

task.spawn(function()
    while task.wait(0.3) do
        if _G.Fullbright then
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
            Lighting.GlobalShadows = false
        end
        if _G.NoFog then
            Lighting.FogEnd = 9e9
            Lighting.FogStart = 0
        end
    end
end)

local function ToggleFullbright(state)
    _G.Fullbright = state
    if not state then
        Lighting.Brightness = OrigLight.Brightness
        Lighting.ClockTime = OrigLight.ClockTime
        Lighting.Ambient = OrigLight.Ambient
        Lighting.OutdoorAmbient = OrigLight.OutdoorAmbient
        Lighting.GlobalShadows = OrigLight.GlobalShadows
    end
end

local function ToggleNoFog(state)
    _G.NoFog = state
    if not state then
        Lighting.FogEnd = OrigLight.FogEnd
        Lighting.FogStart = OrigLight.FogStart
    end
end

local FOV = { Enabled = false, Value = 70, Default = Cam.FieldOfView }

RS.RenderStepped:Connect(function()
    if FOV.Enabled and Cam and Cam.FieldOfView ~= FOV.Value then
        Cam.FieldOfView = FOV.Value
    end
end)

local function ToggleFOV(state)
    FOV.Enabled = state
    if not state and Cam then Cam.FieldOfView = FOV.Default end
end

-- REMOTES
local CarryEvent = Rep:FindFirstChild("Remotes") and Rep.Remotes:FindFirstChild("Carry") and Rep.Remotes.Carry:FindFirstChild("CarrySurvivorEvent")
local HookEvent = Rep:FindFirstChild("Remotes") and Rep.Remotes:FindFirstChild("Carry") and Rep.Remotes.Carry:FindFirstChild("HookEvent")
local AttackEvent = Rep:FindFirstChild("Remotes") and Rep.Remotes:FindFirstChild("Attacks") and Rep.Remotes.Attacks:FindFirstChild("BasicAttack")
local StalkEvent = Rep:FindFirstChild("Remotes") and Rep.Remotes:FindFirstChild("Killers") and Rep.Remotes.Killers:FindFirstChild("Stalker") and Rep.Remotes.Killers.Stalker:FindFirstChild("StartStalking")
local WiggleEvent = Rep:FindFirstChild("Remotes") and Rep.Remotes:FindFirstChild("Carry") and Rep.Remotes.Carry:FindFirstChild("SelfUnHookEvent")
local RepairEvent = Rep:FindFirstChild("Remotes") and Rep.Remotes:FindFirstChild("Generator") and Rep.Remotes.Generator:FindFirstChild("RepairEvent")-- ================================================================
-- PART 2 of 6 - ESP + Skillcheck
-- ================================================================

local ESP = {
    On = false, SV = true, KL = true, GN = true, SCP = false,
    SVc = Color3.fromRGB(0,255,0),
    KLc = Color3.fromRGB(255,0,0),
    GNc = Color3.fromRGB(255,170,0),
    SCPc = Color3.fromRGB(255,0,0),
    ShowName = true, ShowDist = true, ShowProg = true,
    FillT = 1, OutT = 0, TextSize = 14, MaxDist = 500, UpdateRate = 0.6,
}

local espFolder = Instance.new("Folder")
espFolder.Name = "Yarhub_ESP"
espFolder.Parent = CoreGui

local active = {}
local mapCache = nil
local CachedSCP = {}

for _, obj in ipairs(WS:GetDescendants()) do
    if obj.Name:lower():find("scp") then CachedSCP[obj] = true end
end
WS.DescendantAdded:Connect(function(o)
    if o.Name:lower():find("scp") then CachedSCP[o] = true end
end)
WS.DescendantRemoving:Connect(function(o) CachedSCP[o] = nil end)

local function GetMap()
    if mapCache and mapCache.Parent then return mapCache end
    mapCache = WS:FindFirstChild("Map")
    return mapCache
end

local function MakeHL(target, color, key, isChar)
    if active[key] and active[key].HL then
        local h = active[key].HL
        h.FillColor = color; h.OutlineColor = color
        return active[key]
    end
    local h = Instance.new("Highlight")
    h.Adornee = target
    h.FillColor = color; h.OutlineColor = color
    h.FillTransparency = isChar and ESP.FillT or 1
    h.OutlineTransparency = ESP.OutT
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = espFolder
    active[key] = active[key] or {}
    active[key].HL = h
    return active[key]
end

local function MakeLbl(target, color, key)
    local e = active[key]
    if e and e.BB then
        e.BB.Parent = espFolder
        if e.Lbl then e.Lbl.TextSize = ESP.TextSize; e.Lbl.TextColor3 = color end
        return e
    end
    local bb = Instance.new("BillboardGui")
    bb.Adornee = target
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 100, 0, 30)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.LightInfluence = 0
    bb.MaxDistance = ESP.MaxDist
    bb.Parent = espFolder
    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(1, 0, 0, 20)
    lb.BackgroundTransparency = 1
    lb.TextColor3 = color
    lb.TextStrokeTransparency = 0
    lb.TextStrokeColor3 = Color3.new(0,0,0)
    lb.TextSize = ESP.TextSize
    lb.Font = Enum.Font.GothamBold
    lb.Text = ""
    lb.Parent = bb
    local pg = Instance.new("Frame")
    pg.Size = UDim2.new(1, 0, 0, 5)
    pg.Position = UDim2.new(0, 0, 0, 22)
    pg.BackgroundColor3 = Color3.new(0,0,0)
    pg.BackgroundTransparency = 0.4
    pg.BorderSizePixel = 0
    pg.Visible = false
    pg.Parent = bb
    local pf = Instance.new("Frame")
    pf.Size = UDim2.new(0, 0, 1, 0)
    pf.BackgroundColor3 = color
    pf.BorderSizePixel = 0
    pf.Parent = pg
    active[key] = e or {}
    active[key].BB = bb
    active[key].Lbl = lb
    active[key].PB = pg
    active[key].PF = pf
    return active[key]
end

local function CleanESP(used)
    for k, e in pairs(active) do
        if not used[k] then
            if e.HL then e.HL:Destroy() end
            if e.BB then e.BB:Destroy() end
            active[k] = nil
        end
    end
end

local function GetProg(g)
    local v = g:GetAttribute("ProgressRepair") or g:GetAttribute("RepairProgress") or g:GetAttribute("Progress")
    if v then return math.clamp(v, 0, 100) end
    local po = g:FindFirstChild("Progress", true)
    if po and po:IsA("ValueBase") then return math.clamp(po.Value, 0, 100) end
    return 0
end

task.spawn(function()
    while true do
        task.wait(ESP.UpdateRate)
        if not ESP.On then
            for k, e in pairs(active) do
                if e.HL then e.HL:Destroy() end
                if e.BB then e.BB:Destroy() end
                active[k] = nil
            end
            task.wait(0.5)
            continue
        end
        local used = {}
        local camPos = Cam.CFrame.Position
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LP then continue end
            local c = p.Character
            if not c then continue end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            local h = c:FindFirstChildOfClass("Humanoid")
            if not (hrp and h and h.Health > 0) then continue end
            local dist = (hrp.Position - camPos).Magnitude
            if dist > ESP.MaxDist then continue end
            local killer = IsKiller(p)
            local col, show = nil, false
            if killer and ESP.KL then col = ESP.KLc; show = true
            elseif not killer and ESP.SV then col = ESP.SVc; show = true end
            if show then
                local k = "P_" .. p.UserId
                used[k] = true
                local e = MakeHL(c, col, k, true)
                if e.HL then e.HL.Adornee = c; e.HL.FillColor = col; e.HL.OutlineColor = col end
                if ESP.ShowName or ESP.ShowDist then
                    local le = MakeLbl(hrp, col, k)
                    if le.Lbl then
                        le.Lbl.TextColor3 = col
                        le.Lbl.TextSize = ESP.TextSize
                        local txt = ""
                        if ESP.ShowName and ESP.ShowDist then
                            txt = string.format("%s [%dm]", p.Name, math.floor(dist))
                        elseif ESP.ShowName then txt = p.Name
                        elseif ESP.ShowDist then txt = string.format("[%dm]", math.floor(dist)) end
                        le.Lbl.Text = txt
                        le.BB.Adornee = hrp
                    end
                end
            end
        end
        if ESP.GN then
            local m = GetMap()
            if m then
                for _, o in ipairs(m:GetDescendants()) do
                    if o:IsA("Model") and o.Name == "Generator" then
                        local k = "G_" .. o:GetDebugId()
                        used[k] = true
                        local col = ESP.GNc
                        local e = MakeHL(o, col, k, false)
                        if e.HL then e.HL.Adornee = o; e.HL.FillColor = col; e.HL.OutlineColor = col end
                        local mp = o:FindFirstChild("Main") or o:FindFirstChildWhichIsA("BasePart")
                        if mp and ESP.ShowProg then
                            local pr = GetProg(o)
                            local le = MakeLbl(mp, col, k)
                            if le.Lbl then
                                le.Lbl.TextColor3 = col
                                le.Lbl.TextSize = ESP.TextSize
                                le.Lbl.Text = string.format("GEN [%d%%]", math.floor(pr))
                                le.BB.Adornee = mp
                                if pr > 0 then
                                    le.PB.Visible = true
                                    le.PF.BackgroundColor3 = col
                                    le.PF.Size = UDim2.new(pr/100, 0, 1, 0)
                                else le.PB.Visible = false end
                            end
                        end
                    end
                end
            end
        end
        if ESP.SCP then
            for obj in pairs(CachedSCP) do
                if obj and obj.Parent then
                    local k = "S_" .. obj:GetDebugId()
                    used[k] = true
                    local e = MakeHL(obj, ESP.SCPc, k, false)
                    if e.HL then e.HL.Adornee = obj; e.HL.FillColor = ESP.SCPc; e.HL.OutlineColor = ESP.SCPc end
                end
            end
        end
        CleanESP(used)
    end
end)

-- AUTO SKILLCHECK
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
end)-- ================================================================
-- PART 3 of 6 - Parry + Aimbot + Silent Veil
-- ================================================================

local AutoParry = { Enabled = false, Range = 15, Debounce = 0.2, LastParry = 0, ShowCircle = true }

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

local ParryCircle = nil

RS.RenderStepped:Connect(function()
    local root = GetRoot()
    if not root or not AutoParry.ShowCircle then
        if ParryCircle then ParryCircle:Destroy(); ParryCircle = nil end
        return
    end
    if not ParryCircle then
        ParryCircle = Instance.new("Part")
        ParryCircle.Shape = Enum.PartType.Cylinder
        ParryCircle.Anchored = true
        ParryCircle.CanCollide = false
        ParryCircle.Material = Enum.Material.Neon
        ParryCircle.Color = Color3.fromRGB(0, 150, 255)
        ParryCircle.Transparency = 0.7
        ParryCircle.Parent = WS
    end
    local yOff = root.Size.Y / 2 + 1.5
    ParryCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOff, 0)) * CFrame.Angles(0, 0, math.rad(90))
    ParryCircle.Size = Vector3.new(0.2, AutoParry.Range * 2, AutoParry.Range * 2)
end)

local function PressParry()
    local current = PG
    for seg in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(seg)
    end
    if current and current:IsA("GuiObject") then
        local p, s = current.AbsolutePosition, current.AbsoluteSize
        local ins = GS:GetGuiInset()
        local x = p.X + s.X/2 + ins.X
        local y = p.Y + s.Y/2 + ins.Y
        pcall(function() VIM:SendTouchEvent(8823, 0, x, y) end)
        task.wait(0.01)
        pcall(function() VIM:SendTouchEvent(8823, 2, x, y) end)
    elseif not isMobile then
        pcall(function()
            VIM:SendMouseButtonEvent(0, 0, 1, true, game, 0)
            task.wait()
            VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0)
        end)
    end
end

local function DoParry()
    local now = tick()
    if now - AutoParry.LastParry < AutoParry.Debounce then return end
    AutoParry.LastParry = now
    task.spawn(PressParry)
end

local hookedKillers = {}
local function HookKiller(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true
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
            local myRoot = GetRoot()
            local enemyRoot = char:FindFirstChild("HumanoidRootPart")
            if myRoot and enemyRoot then
                if (enemyRoot.Position - myRoot.Position).Magnitude <= AutoParry.Range then
                    DoParry()
                end
            end
        end
    end)
end

task.spawn(function()
    while task.wait(2) do
        if AutoParry.Enabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and IsKiller(p) then
                    HookKiller(p.Character)
                end
            end
        end
    end
end)

-- AIMBOT
local GunAim = { Enabled = false, Holding = false, TargetMode = "Killer", Strength = 1, Predict = true, PredictStrength = 0.12, FOV = 250, WallCheck = true }
local AttackAim = { Enabled = false, Holding = false, Strength = 1, Predict = true, PredictStrength = 0.12, FOV = 250, WallCheck = true }

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = true; AttackAim.Holding = true
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = false; AttackAim.Holding = false
    end
end)

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist

local function IsVisible(part, wallCheck)
    if not wallCheck then return true end
    if not part then return false end
    RayParams.FilterDescendantsInstances = { LP.Character }
    local origin = Cam.CFrame.Position
    local result = WS:Raycast(origin, part.Position - origin, RayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

local function GetGunTarget()
    local center = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
    local closest, shortest = nil, GunAim.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team then
            local valid = false
            if GunAim.TargetMode == "Killer" and IsKiller(p) then valid = true
            elseif GunAim.TargetMode == "Survivor" and IsSurvivor(p) then valid = true end
            if valid then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 and IsVisible(hrp, GunAim.WallCheck) then
                    local pos, vis = Cam:WorldToViewportPoint(hrp.Position)
                    if vis then
                        local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if d < shortest then shortest = d; closest = hrp end
                    end
                end
            end
        end
    end
    return closest
end

local function GetAttackTarget()
    local center = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
    local closest, shortest = nil, AttackAim.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and IsSurvivor(p) and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 and IsVisible(hrp, AttackAim.WallCheck) then
                local pos, vis = Cam:WorldToViewportPoint(hrp.Position)
                if vis then
                    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if d < shortest then shortest = d; closest = hrp end
                end
            end
        end
    end
    return closest
end

RS.RenderStepped:Connect(function()
    if GunAim.Enabled and GunAim.Holding then
        local t = GetGunTarget()
        if t then
            local pos = t.Position
            if GunAim.Predict then
                pos = pos + (t.AssemblyLinearVelocity * GunAim.PredictStrength)
            end
            Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, pos), GunAim.Strength)
        end
    end
    if AttackAim.Enabled and AttackAim.Holding then
        local t = GetAttackTarget()
        if t then
            local pos = t.Position
            if AttackAim.Predict then
                pos = pos + (t.AssemblyLinearVelocity * AttackAim.PredictStrength)
            end
            Cam.CFrame = CFrame.new(Cam.CFrame.Position, pos)
        end
    end
end)

-- SILENT AIM VEIL
local SilentVeil = { Enabled = false, TargetMode = "Survivor", FOV = 300, WallCheck = true, PredictGravity = true, GravityComp = 1.0, SpeedEstimate = 100 }

local VeilRemotes = {}
local function ScanVeilRemotes()
    VeilRemotes = {}
    for _, obj in ipairs(Rep:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local n = obj.Name:lower()
            if n:find("spear") or n:find("veil") or n:find("throw") 
            or n:find("projectile") or n:find("ranged") then
                table.insert(VeilRemotes, obj)
            end
        end
    end
    return #VeilRemotes
end

ScanVeilRemotes()
task.spawn(function() while task.wait(5) do ScanVeilRemotes() end end)

local function GetVeilTarget()
    local center = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
    local closest, shortest = nil, SilentVeil.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team then
            local valid = false
            if SilentVeil.TargetMode == "Survivor" and IsSurvivor(p) then valid = true
            elseif SilentVeil.TargetMode == "Killer" and IsKiller(p) then valid = true
            elseif SilentVeil.TargetMode == "All" then valid = true end
            if valid then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 and IsVisible(hrp, SilentVeil.WallCheck) then
                    local pos, vis = Cam:WorldToViewportPoint(hrp.Position)
                    if vis then
                        local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if d < shortest then shortest = d; closest = hrp end
                    end
                end
            end
        end
    end
    return closest
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if SilentVeil.Enabled and method == "FireServer" then
        local isVeil = false
        for _, remote in ipairs(VeilRemotes) do
            if self == remote then isVeil = true break end
        end
        if isVeil then
            local target = GetVeilTarget()
            if target then
                local args = {...}
                local dist = (target.Position - Cam.CFrame.Position).Magnitude
                local travelTime = dist / math.max(SilentVeil.SpeedEstimate, 10)
                local predicted = target.Position + (target.AssemblyLinearVelocity * travelTime)
                if SilentVeil.PredictGravity then
                    local g = 196.2 * SilentVeil.GravityComp
                    predicted = predicted + Vector3.new(0, 0.5 * g * travelTime * travelTime, 0)
                end
                args[1] = predicted
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end)-- ================================================================
-- PART 4 of 6 - Killer + Gen Boost
-- ================================================================

local AutoKill = { Enabled = false, Range = 500, Delay = 0.45, LastAttack = 0 }
local AutoStalk = { Enabled = false, Range = 150, Conn = nil }
local AutoCarry = { Enabled = false, Range = 10 }
local MaskedPowers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}

RS.Heartbeat:Connect(function()
    if not AutoKill.Enabled then return end
    local now = tick()
    if now - AutoKill.LastAttack < AutoKill.Delay then return end
    local root = GetRoot()
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
    if closest and shortest <= AutoKill.Range then
        AutoKill.LastAttack = now
        pcall(function()
            if AttackEvent then AttackEvent:FireServer(closest) end
        end)
    end
end)

local function StartAutoStalk()
    if AutoStalk.Conn then AutoStalk.Conn:Disconnect() end
    AutoStalk.Conn = RS.Heartbeat:Connect(function()
        if not AutoStalk.Enabled then return end
        local root = GetRoot()
        if not root then return end
        local closest, shortest = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character and IsSurvivor(plr) then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 30 then
                    local d = (hrp.Position - root.Position).Magnitude
                    if d <= AutoStalk.Range and d < shortest then
                        shortest = d
                        closest = plr
                    end
                end
            end
        end
        if closest and StalkEvent then
            pcall(function() StalkEvent:FireServer(closest) end)
        end
    end)
end

local function StopAutoStalk()
    if AutoStalk.Conn then AutoStalk.Conn:Disconnect(); AutoStalk.Conn = nil end
end

local function GetDowned()
    local root = GetRoot()
    if not root then return nil end
    local best, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and IsSurvivor(p) then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 and hum.Health <= hum.MaxHealth * 0.25 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < dist then dist = d; best = p.Character end
            end
        end
    end
    return best, dist
end

task.spawn(function()
    while task.wait(0.5) do
        if not AutoCarry.Enabled then continue end
        local target, dist = GetDowned()
        if target and dist <= AutoCarry.Range then
            pcall(function()
                if CarryEvent then CarryEvent:FireServer(target) end
            end)
        end
    end
end)

local function GetHook()
    local root = GetRoot()
    if not root then return nil end
    local bestHook, shortest = nil, math.huge
    for _, obj in pairs(WS:GetDescendants()) do
        if obj.Name == "HookPoint" and obj:IsA("BasePart") then
            local dist = (obj.Position - root.Position).Magnitude
            if dist < shortest and dist < 400 then
                shortest = dist
                bestHook = obj
            end
        end
    end
    return bestHook
end

local function AutoHookNearest()
    local downed = GetDowned()
    if not downed then
        Rayfield:Notify({Title="Yarhub", Content="Tidak ada survivor downed", Duration=2})
        return
    end
    local hook = GetHook()
    if not hook then
        Rayfield:Notify({Title="Yarhub", Content="Tidak ada hook dekat", Duration=2})
        return
    end
    pcall(function()
        if HookEvent then HookEvent:FireServer(hook, downed) end
    end)
    Rayfield:Notify({Title="Yarhub", Content="Hook dikirim!", Duration=2})
end

local function SetMaskedPower(powerName)
    local powerRemote = Rep:FindFirstChild("Remotes") 
        and Rep.Remotes:FindFirstChild("Killers") 
        and Rep.Remotes.Killers:FindFirstChild("Masked") 
        and Rep.Remotes.Killers.Masked:FindFirstChild("SetPower")
    if powerRemote then
        pcall(function()
            powerRemote:FireServer(powerName)
        end)
        Rayfield:Notify({Title="Yarhub", Content="Power: "..powerName, Duration=2})
    else
        Rayfield:Notify({Title="Yarhub", Content="Remote Masked tidak ditemukan", Duration=3})
    end
end

local AutoWiggle = { Enabled = false, Spam = 5 }

task.spawn(function()
    while task.wait(0.2) do
        if not AutoWiggle.Enabled then continue end
        local char = LP.Character
        if not char then continue end
        local carried = (char:FindFirstChild("IsCarried") and char.IsCarried.Value) 
            or (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)
        if carried and WiggleEvent then
            for i = 1, AutoWiggle.Spam do
                pcall(function() WiggleEvent:FireServer() end)
            end
        end
    end
end)

-- ==================== GEN BYPASS (KODINGAN KAMU) ====================
GenBypass = {
    Enabled = false,
    Button = nil,
    UI = nil,
    Cache = {},
    CacheTimer = 0,
    Processed = {},
    HotkeyCode = Enum.KeyCode.G,
    Range = 8,
}

function GB_GetAllGenerators()
    local now = tick()
    if now - GenBypass.CacheTimer < 5 then
        return GenBypass.Cache
    end
    GenBypass.Cache = {}
    GenBypass.CacheTimer = now
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return GenBypass.Cache end
    pcall(function()
        for _, v in pairs(mapFolder:GetDescendants()) do
            if v:IsA("Model") and v.Name == "Generator" then
                local isReal = v:GetAttribute("RepairProgress") ~= nil
                    or v:GetAttribute("kickcount") ~= nil
                    or v:GetAttribute("ProgressRepair") ~= nil
                if isReal then
                    table.insert(GenBypass.Cache, v)
                end
            end
        end
    end)
    return GenBypass.Cache
end

function GB_GetPoints(genModel)
    local points = {}
    pcall(function()
        for _, obj in pairs(genModel:GetChildren()) do
            if obj.Name:find("GeneratorPoint") and obj:IsA("BasePart") then
                table.insert(points, obj)
            end
        end
    end)
    return points
end

function GB_WaitRepairing(point, timeout)
    local start = tick()
    while tick() - start < (timeout or 1) do
        if point:GetAttribute("IsRepairing") == true then
            return true
        end
        task.wait(0.05)
    end
    return false
end

function GB_DoRepair(targetPoint)
    local genModel = targetPoint.Parent    if GenBypass.Processed[genModel] then return end
    GenBypass.Processed[genModel] = true
    local character = LP.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        GenBypass.Processed[genModel] = nil
        return
    end
    local RepairEv = RepairEvent
    local originalCFrame = hrp.CFrame
    pcall(function()
        for _, point in pairs(GB_GetPoints(genModel)) do
            if point ~= targetPoint and point.Parent then
                hrp.Anchored = true
                hrp.CFrame = point.CFrame
                task.wait(0.15)
                pcall(function()
                    if RepairEv then RepairEv:FireServer(point, true) end
                end)
                if not GB_WaitRepairing(point, 0.8) then
                    pcall(function()
                        if RepairEv then RepairEv:FireServer(point, false) end
                    end)
                    task.wait(0.1)
                    hrp.CFrame = point.CFrame
                    task.wait(0.15)
                    pcall(function()
                        if RepairEv then RepairEv:FireServer(point, true) end
                    end)
                    GB_WaitRepairing(point, 0.5)
                end
                hrp.Anchored = false
                task.wait(0.05)
            end
        end
    end)
    pcall(function()
        if hrp and hrp.Parent then
            hrp.Anchored = false
            hrp.CFrame = originalCFrame
        end
    end)
    task.wait(0.1)
    pcall(function()
        if RepairEv then RepairEv:FireServer(targetPoint, false) end
    end)
end

function GB_GetNearestPoint()
    local character = LP.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local bestPoint = nil
    local bestDist = math.huge
    for _, gen in pairs(GB_GetAllGenerators()) do
        for _, point in pairs(GB_GetPoints(gen)) do
            local d = (hrp.Position - point.Position).Magnitude
            if d < bestDist then
                bestDist = d
                bestPoint = point
            end
        end
    end
    return bestPoint, bestDist
end

function GB_IsPromptVisible()
    local ok, frame = pcall(function()
        return LP.PlayerGui.pcprompts.Frame.GeneratorRepair
    end)
    return ok and frame and frame.Visible
end

function GB_UpdateButton()
    if GenBypass.Button then
        GenBypass.Button.Visible = GenBypass.Enabled and isMobile
    end
end

function GB_CreateButton()
    local oldUI = LP.PlayerGui:FindFirstChild("BypassGenUI")
    if oldUI then oldUI:Destroy() end
    GenBypass.UI = Instance.new("ScreenGui")
    GenBypass.UI.Name = "BypassGenUI"
    GenBypass.UI.ResetOnSpawn = false
    GenBypass.UI.IgnoreGuiInset = true
    GenBypass.UI.Parent = LP:WaitForChild("PlayerGui")
    GenBypass.Button = Instance.new("ImageButton")
    GenBypass.Button.Name = "BypassGenButton"
    GenBypass.Button.Size = UDim2.new(0, 60, 0, 60)
    GenBypass.Button.Position = UDim2.new(0.88, 0, 0.55, 0)
    GenBypass.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    GenBypass.Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GenBypass.Button.BackgroundTransparency = 0.15
    GenBypass.Button.AutoButtonColor = true
    GenBypass.Button.Visible = false
    GenBypass.Button.ZIndex = 10
    GenBypass.Button.Parent = GenBypass.UI
    Instance.new("UICorner", GenBypass.Button).CornerRadius = UDim.new(1, 0)
    local s = Instance.new("UIStroke", GenBypass.Button)
    s.Color = Color3.fromRGB(255, 255, 255)
    s.Thickness = 2
    s.Transparency = 0.2
    local lbl = Instance.new("TextLabel", GenBypass.Button)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "BYPASS"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11
    GenBypass.Button.MouseButton1Click:Connect(function()
        if not GenBypass.Enabled then return end
        local bestPoint, bestDist = GB_GetNearestPoint()
        if bestPoint and bestDist <= GenBypass.Range then
            GB_DoRepair(bestPoint)
        end
    end)
end

GB_CreateButton()

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    GB_CreateButton()
    GB_UpdateButton()
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp or isMobile then return end
    if input.KeyCode == GenBypass.HotkeyCode and GenBypass.Enabled then
        if not GB_IsPromptVisible() then return end
        local bestPoint, bestDist = GB_GetNearestPoint()
        if not bestPoint or bestDist > GenBypass.Range then return end
        if GenBypass.Processed[bestPoint.Parent] then return end
        GB_DoRepair(bestPoint)
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if not GenBypass.Enabled then return end
    if not GB_IsPromptVisible() then return end
    local bestPoint, bestDist = GB_GetNearestPoint()
    if not bestPoint or bestDist > GenBypass.Range then return end
    if GenBypass.Processed[bestPoint.Parent] then return end
    GB_DoRepair(bestPoint)
end)

task.spawn(function()
    while true do
        task.wait(2)
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for genModel in pairs(GenBypass.Processed) do
                if not genModel or not genModel.Parent then
                    GenBypass.Processed[genModel] = nil
                else
                    local nearAny = false
                    for _, point in pairs(GB_GetPoints(genModel)) do
                        if point.Parent and (hrp.Position - point.Position).Magnitude <= 10 then
                            nearAny = true
                            break
                        end
                    end
                    if not nearAny then
                        GenBypass.Processed[genModel] = nil
                    end
                end
            end
        end
    end
end)

function setGenBypass(v)
    GenBypass.Enabled = v
    GB_UpdateButton()
end-- ================================================================
-- PART 5 of 6 - Movement + God Mode + FPS/Ping
-- ================================================================

local Movement = {
    SpeedEnabled = false, SpeedValue = 20,
    JumpEnabled = false, JumpValue = 50,
    Noclip = false, NoclipConn = nil,
}

task.spawn(function()
    while task.wait(0.1) do
        local char = LP.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then continue end
        if Movement.SpeedEnabled then
            if hum.WalkSpeed ~= Movement.SpeedValue then
                hum.WalkSpeed = Movement.SpeedValue
            end
        end
        if Movement.JumpEnabled then
            if hum.JumpPower ~= Movement.JumpValue then
                hum.JumpPower = Movement.JumpValue
                hum.UseJumpPower = true
            end
        end
    end
end)

local function NoclipPart(p)
    if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
end

local function EnableNoclip()
    if Movement.NoclipConn then Movement.NoclipConn:Disconnect() end
    Movement.NoclipConn = RS.Stepped:Connect(function()
        local char = LP.Character
        if char and Movement.Noclip then
            for _, p in ipairs(char:GetDescendants()) do pcall(NoclipPart, p) end
        end
    end)
end

local function DisableNoclip()
    if Movement.NoclipConn then Movement.NoclipConn:Disconnect(); Movement.NoclipConn = nil end
    local char = LP.Character
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end

local GodMode = { Enabled = false }
task.spawn(function()
    while task.wait(0.3) do
        if not GodMode.Enabled then continue end
        local char = LP.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if hum.Health < hum.MaxHealth then
                pcall(function() hum.Health = hum.MaxHealth end)
            end
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Dead 
            or state == Enum.HumanoidStateType.FallingDown 
            or state == Enum.HumanoidStateType.Ragdoll then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end
    end
end)

local FastVault = { Enabled = false, Speed = 30 }
RS.Heartbeat:Connect(function()
    if not FastVault.Enabled then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * 8)
    local hit = WS:FindPartOnRayWithIgnoreList(ray, {char})
    if hit and (hit.Name == "Window" or hit.Name == "Pallet" or hit.Name == "Palletwrong") then
        if hum.WalkSpeed ~= FastVault.Speed then hum.WalkSpeed = FastVault.Speed end
    else
        if hum.WalkSpeed == FastVault.Speed then hum.WalkSpeed = 16 end
    end
end)

-- FPS/PING
local FPSPing = { Enabled = true, FPS = 0, Ping = 0, Frames = 0, LastTick = tick() }

local FPSScreenGui = Instance.new("ScreenGui")
FPSScreenGui.Name = "Yarhub_FPSPing"
FPSScreenGui.ResetOnSpawn = false
FPSScreenGui.Parent = CoreGui

local FPSFrame = Instance.new("Frame")
FPSFrame.Size = UDim2.new(0, 220, 0, 30)
FPSFrame.Position = UDim2.new(0, 10, 0, 40)
FPSFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
FPSFrame.BackgroundTransparency = 0.3
FPSFrame.BorderSizePixel = 0
FPSFrame.Parent = FPSScreenGui
Instance.new("UICorner", FPSFrame).CornerRadius = UDim.new(0, 8)

local FPSStroke = Instance.new("UIStroke", FPSFrame)
FPSStroke.Color = Color3.fromRGB(0, 120, 220)
FPSStroke.Thickness = 1.5

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1, 0, 1, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 14
FPSLabel.Text = "YARHUB | FPS: 60 | Ping: 0 ms"
FPSLabel.Parent = FPSFrame

RS.RenderStepped:Connect(function()
    if not FPSPing.Enabled then FPSFrame.Visible = false; return end
    FPSFrame.Visible = true
    FPSPing.Frames = FPSPing.Frames + 1
    if tick() - FPSPing.LastTick >= 1 then
        FPSPing.FPS = FPSPing.Frames
        FPSPing.Frames = 0
        FPSPing.LastTick = tick()
        pcall(function()
            FPSPing.Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        FPSLabel.Text = string.format("YARHUB | FPS: %d | Ping: %d ms", FPSPing.FPS, FPSPing.Ping)
    end
end)-- ================================================================
-- PART 6 of 6 - Moonwalk + UI Rayfield
-- ================================================================

-- MOONWALK (KODINGAN KAMU)
local Moonwalk = {
    Enabled = false,
    ShowButton = true,
    SpamSpeed = 30,
    Intensity = 35,
    SlowSpeed = 13,
    UseSlow = true
}

local MoonwalkConnection = nil
local MoonwalkButton = nil
local MWLocked = false

local function getMWChar()
    local char = LP.Character
    if not char or not char.Parent then return nil end
    return char
end

local function getMWHum()
    local char = getMWChar()
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function stopMoonwalk()
    if MoonwalkConnection then
        MoonwalkConnection:Disconnect()
        MoonwalkConnection = nil
    end
    local hum = getMWHum()
    if hum then hum.WalkSpeed = 16 end
end

local function startMoonwalk()
    if MoonwalkConnection then
        MoonwalkConnection:Disconnect()
        MoonwalkConnection = nil
    end
    MoonwalkConnection = RS.RenderStepped:Connect(function()
        if not Moonwalk.Enabled then return end
        local char = getMWChar()
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not humanoid or not hrp or not cam then return end
        if Moonwalk.UseSlow then
            if humanoid.WalkSpeed ~= Moonwalk.SlowSpeed then
                humanoid.WalkSpeed = Moonwalk.SlowSpeed
            end
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
    end)
end

local function setMoonwalk(state)
    Moonwalk.Enabled = state
    if state then startMoonwalk() else stopMoonwalk() end
end

local function createMoonwalkButton()
    if not PG or not PG.Parent then return end
    if MoonwalkButton then
        MoonwalkButton:Destroy()
        MoonwalkButton = nil
    end
    local gui = Instance.new("ScreenGui")
    gui.Name = "MoonwalkGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = CoreGui
    local btn = Instance.new("ImageButton")
    btn.Name = "MoonwalkButton"
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0.65, 0, 0.75, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.9
    btn.Image = "rbxassetid://93349170559446"
    btn.ImageTransparency = 0.1
    btn.Parent = gui
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Parent = btn
    local dragging, dragStart, startPos = false, nil, nil
    btn.InputBegan:Connect(function(input)
        if MWLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not dragging or MWLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(
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
    btn.Activated:Connect(function()
        setMoonwalk(not Moonwalk.Enabled)
        if Moonwalk.Enabled then
            stroke.Color = Color3.fromRGB(170, 0, 255)
            stroke.Transparency = 0.2
        else
            stroke.Color = Color3.fromRGB(255, 255, 255)
            stroke.Transparency = 0.8
        end
    end)
    MoonwalkButton = gui
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Moonwalk.Enabled then startMoonwalk() end
end)

if Moonwalk.ShowButton then
    createMoonwalkButton()
end

-- ================================================================
-- UI RAYFIELD
-- ================================================================
local Win = Rayfield:CreateWindow({
   Name = "Yarhub Ultimate",
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

local VisualT = Win:CreateTab("Visual")
local SkillT  = Win:CreateTab("Skillcheck")
local ParryT  = Win:CreateTab("Parry")
local AimT    = Win:CreateTab("Aimbot")
local KillerT = Win:CreateTab("Killer")
local EspT    = Win:CreateTab("ESP")
local GenT    = Win:CreateTab("Gen Bypass")
local MoveT   = Win:CreateTab("Movement")
local MwT     = Win:CreateTab("Moonwalk")
local InfoT   = Win:CreateTab("Info")

Rayfield:Notify({Title="Yarhub Ultimate", Content="Semua fitur dimuat!", Duration=5})

-- VISUAL
VisualT:CreateSection("Fullbright & Fog")
VisualT:CreateToggle({Name="Fullbright", CurrentValue=false,
   Callback=function(v) ToggleFullbright(v) end})
VisualT:CreateToggle({Name="No Fog", CurrentValue=false,
   Callback=function(v) ToggleNoFog(v) end})
VisualT:CreateSection("FOV")
VisualT:CreateToggle({Name="Aktifkan FOV", CurrentValue=false,
   Callback=function(v) ToggleFOV(v) end})
VisualT:CreateSlider({Name="FOV Value", Range={50,120}, Increment=1, CurrentValue=70,
   Callback=function(v) FOV.Value = v end})

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
   Callback=function(v) AutoParry.Enabled = v end})
ParryT:CreateSlider({Name="Jarak", Range={5,30}, Increment=1, CurrentValue=15,
   Callback=function(v) AutoParry.Range = v end})
ParryT:CreateSlider({Name="Delay", Range={0.05,1}, Increment=0.05, CurrentValue=0.2,
   Callback=function(v) AutoParry.Debounce = v end})
ParryT:CreateToggle({Name="Lingkaran Visual", CurrentValue=true,
   Callback=function(v) AutoParry.ShowCircle = v end})

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
   Callback=function(v) GunAim.WallCheck = v end})
AimT:CreateSection("Attack Aimbot")
AimT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v) AttackAim.Enabled = v end})
AimT:CreateSlider({Name="Strength Attack", Range={0.05,1}, Increment=0.05, CurrentValue=1,
   Callback=function(v) AttackAim.Strength = v end})
AimT:CreateSection("Silent Aim Veil ⚠️")
AimT:CreateToggle({Name="Aktifkan Silent Veil", CurrentValue=false,
   Callback=function(v)
      SilentVeil.Enabled = v
      if v then Rayfield:Notify({Title="⚠️ Silent", Content="Risiko ban tinggi!", Duration=4}) end
   end})
AimT:CreateDropdown({Name="Target", Options={"Survivor","Killer","All"},
   CurrentOption={"Survivor"}, Callback=function(O) SilentVeil.TargetMode = O[1] end})
AimT:CreateSlider({Name="FOV Veil", Range={50,500}, Increment=10, CurrentValue=300,
   Callback=function(v) SilentVeil.FOV = v end})
AimT:CreateToggle({Name="Wallcheck Veil", CurrentValue=true,
   Callback=function(v) SilentVeil.WallCheck = v end})
AimT:CreateToggle({Name="Predict Gravity", CurrentValue=true,
   Callback=function(v) SilentVeil.PredictGravity = v end})
AimT:CreateSlider({Name="Gravity Comp", Range={0.5,2}, Increment=0.1, CurrentValue=1,
   Callback=function(v) SilentVeil.GravityComp = v end})
AimT:CreateButton({Name="Scan Spear Remotes",
   Callback=function()
      local c = ScanVeilRemotes()
      Rayfield:Notify({Title="Yarhub", Content="Found "..c.." remotes", Duration=3})
   end})

-- KILLER
KillerT:CreateSection("Auto Kill All ⚠️")
KillerT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v)
      AutoKill.Enabled = v
      if v then Rayfield:Notify({Title="Auto Kill", Content="AKTIF!", Duration=3}) end
   end})
KillerT:CreateSlider({Name="Kill Range", Range={50,1000}, Increment=50, CurrentValue=500,
   Callback=function(v) AutoKill.Range = v end})
KillerT:CreateSlider({Name="Attack Delay", Range={0.1,2}, Increment=0.05, CurrentValue=0.45,
   Callback=function(v) AutoKill.Delay = v end})
KillerT:CreateSection("Auto Stalk")
KillerT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v)
      AutoStalk.Enabled = v
      if v then StartAutoStalk() else StopAutoStalk() end
   end})
KillerT:CreateSlider({Name="Stalk Range", Range={50,300}, Increment=10, CurrentValue=150,
   Callback=function(v) AutoStalk.Range = v end})
KillerT:CreateSection("Auto Carry + Hook")
KillerT:CreateToggle({Name="Aktifkan Auto Carry", CurrentValue=false,
   Callback=function(v) AutoCarry.Enabled = v end})
KillerT:CreateSlider({Name="Carry Range", Range={5,30}, Increment=1, CurrentValue=10,
   Callback=function(v) AutoCarry.Range = v end})
KillerT:CreateButton({Name="Auto Hook Sekarang",
   Callback=function() AutoHookNearest() end})
KillerT:CreateSection("Masked Power")
for _, power in ipairs(MaskedPowers) do
   KillerT:CreateButton({Name=power, Callback=function() SetMaskedPower(power) end})
end
KillerT:CreateSection("Auto Wiggle")
KillerT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v) AutoWiggle.Enabled = v end})
KillerT:CreateSlider({Name="Spam/detik", Range={1,20}, Increment=1, CurrentValue=5,
   Callback=function(v) AutoWiggle.Spam = v end})

-- ESP
EspT:CreateSection("Target")
EspT:CreateToggle({Name="Aktifkan ESP", CurrentValue=false,
   Callback=function(v) ESP.On = v end})
EspT:CreateToggle({Name="Survivor (Hijau)", CurrentValue=true,
   Callback=function(v) ESP.SV = v end})
EspT:CreateToggle({Name="Killer (Merah)", CurrentValue=true,
   Callback=function(v) ESP.KL = v end})
EspT:CreateToggle({Name="Generator (Orange)", CurrentValue=true,
   Callback=function(v) ESP.GN = v end})
EspT:CreateToggle({Name="SCP (Merah)", CurrentValue=false,
   Callback=function(v) ESP.SCP = v end})
EspT:CreateSection("Ukuran")
EspT:CreateSlider({Name="Ukuran Text", Range={8,32}, Increment=1, CurrentValue=14,
   Callback=function(v) ESP.TextSize = v end})
EspT:CreateSlider({Name="Jarak Max", Range={50,2000}, Increment=50, CurrentValue=500,
   Callback=function(v) ESP.MaxDist = v end})

-- GEN BYPASS
GenT:CreateSection("Generator Bypass")
GenT:CreateToggle({Name="Aktifkan Gen Bypass", CurrentValue=false,
   Callback=function(v)
      setGenBypass(v)
      if v then Rayfield:Notify({Title="Yarhub", Content="Gen Bypass ON", Duration=2}) end
   end})
GenT:CreateSlider({Name="Jarak Bypass (stud)", Range={4,20}, Increment=1, CurrentValue=8,
   Callback=function(v) GenBypass.Range = v end})
GenT:CreateButton({Name="Repair Terdekat Manual",
   Callback=function()
      local p, d = GB_GetNearestPoint()
      if p and d <= GenBypass.Range then
         GB_DoRepair(p)
         Rayfield:Notify({Title="Yarhub", Content="Repair dikirim!", Duration=2})
      end
   end})
GenT:CreateButton({Name="Reset Cache",
   Callback=function()
      GenBypass.Cache = {}
      GenBypass.Processed = {}
      GenBypass.CacheTimer = 0
      Rayfield:Notify({Title="Yarhub", Content="Cache di-reset", Duration=2})
   end})
GenT:CreateParagraph({Title="Cara Pakai",
   Content="1. Aktifkan Gen Bypass\n2. Mobile: tap tombol BYPASS\n3. PC: pencet G atau klik mouse"})

-- MOVEMENT
MoveT:CreateSection("God Mode ⚠️")
MoveT:CreateToggle({Name="Aktifkan God Mode", CurrentValue=false,
   Callback=function(v)
      GodMode.Enabled = v
      if v then Rayfield:Notify({Title="⚠️ God Mode", Content="Risiko ban!", Duration=4}) end
   end})
MoveT:CreateSection("Speed & Jump")
MoveT:CreateToggle({Name="WalkSpeed ON", CurrentValue=false,
   Callback=function(v) Movement.SpeedEnabled = v end})
MoveT:CreateSlider({Name="WalkSpeed", Range={16,100}, Increment=2, CurrentValue=20,
   Callback=function(v) Movement.SpeedValue = v end})
MoveT:CreateToggle({Name="JumpPower ON", CurrentValue=false,
   Callback=function(v) Movement.JumpEnabled = v end})
MoveT:CreateSlider({Name="JumpPower", Range={50,200}, Increment=5, CurrentValue=50,
   Callback=function(v) Movement.JumpValue = v end})
MoveT:CreateSection("Noclip")
MoveT:CreateToggle({Name="Noclip", CurrentValue=false,
   Callback=function(v)
      Movement.Noclip = v
      if v then EnableNoclip() else DisableNoclip() end
   end})
MoveT:CreateSection("Fast Vault")
MoveT:CreateToggle({Name="Aktifkan Fast Vault", CurrentValue=false,
   Callback=function(v) FastVault.Enabled = v end})
MoveT:CreateSlider({Name="Vault Speed", Range={16,50}, Increment=2, CurrentValue=30,
   Callback=function(v) FastVault.Speed = v end})

-- MOONWALK
MwT:CreateSection("Moonwalk")
MwT:CreateToggle({Name="Aktifkan Moonwalk", CurrentValue=false,
   Callback=function(v)
      setMoonwalk(v)
      Rayfield:Notify({Title="Yarhub", Content=v and "Moonwalk ON" or "Moonwalk OFF", Duration=2})
   end})
MwT:CreateToggle({Name="Tampilkan Tombol MW", CurrentValue=true,
   Callback=function(v)
      Moonwalk.ShowButton = v
      if v then
         createMoonwalkButton()
      else
         if MoonwalkButton then MoonwalkButton:Destroy(); MoonwalkButton = nil end
      end
   end})
MwT:CreateToggle({Name="🔒 Lock Tombol MW", CurrentValue=false,
   Callback=function(v)
      MWLocked = v
      Rayfield:Notify({Title="Yarhub", Content=v and "Tombol DILOCK" or "Tombol UNLOCK", Duration=2})
   end})
MwT:CreateSlider({Name="Spam Speed", Range={1,50}, Increment=1, CurrentValue=30,
   Callback=function(v) Moonwalk.SpamSpeed = v end})
MwT:CreateSlider({Name="Intensity", Range={1,50}, Increment=1, CurrentValue=35,
   Callback=function(v) Moonwalk.Intensity = v end})
MwT:CreateSlider({Name="Slow Speed", Range={1,30}, Increment=1, CurrentValue=13,
   Callback=function(v) Moonwalk.SlowSpeed = v end})
MwT:CreateToggle({Name="Use Slow Speed", CurrentValue=true,
   Callback=function(v) Moonwalk.UseSlow = v end})

-- INFO
InfoT:CreateSection("FPS/Ping")
InfoT:CreateToggle({Name="Tampilkan FPS/Ping", CurrentValue=true,
   Callback=function(v) FPSPing.Enabled = v end})
InfoT:CreateSection("Tentang")
InfoT:CreateParagraph({
   Title = "Yarhub Ultimate",
   Content = "Fitur Lengkap:\n" ..
             "- Anti Lag + Fullbright + No Fog + FOV\n" ..
             "- Auto Skillcheck (2 Mode)\n" ..
             "- Auto Parry + Circle\n" ..
             "- Aimbot (Gun + Attack + Wallcheck)\n" ..
             "- Silent Aim Veil Spear\n" ..
             "- Auto Kill All + Auto Stalk\n" ..
             "- Auto Carry + Auto Hook + Masked Power\n" ..
             "- Auto Wiggle\n" ..
             "- ESP (Survivor + Killer + Generator + SCP)\n" ..
             "- Gen Bypass (Auto Repair)\n" ..
             "- God Mode + Speed + Jump + Noclip\n" ..
             "- Fast Vault\n" ..
             "- Moonwalk + Lock Tombol\n" ..
             "- FPS/Ping Display\n\n" ..
             "Total 10 Tab\n" ..
             "Dibuat oleh: Yarhub"
})-- ================================================================
-- PART 7 of 8 - EXTENDED FEATURES
-- ================================================================

-- ==================== ESP PRO ====================
local ESPPro = {
    Pallet = false, Window = false,
    StatusBillboard = false, HealthBar = false, ItemESP = false,
    MaxDist = 500,
    PalletColor = Color3.fromRGB(74, 255, 181),
    WindowColor = Color3.fromRGB(74, 255, 181),
    ItemColor = Color3.fromRGB(255, 215, 0),
}

local espProFolder = Instance.new("Folder")
espProFolder.Name = "Yarhub_ESPPro"
espProFolder.Parent = CoreGui

local ProESPObjects = {}
local StatusBillboards = {}

local function ProCreateESP(obj, color, key)
    if ProESPObjects[key] then
        ProESPObjects[key].FillColor = color
        ProESPObjects[key].OutlineColor = color
        return
    end
    local h = Instance.new("Highlight")
    h.Adornee = obj
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.9
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = espProFolder
    ProESPObjects[key] = h
end

local function ProRemoveESP(key)
    if ProESPObjects[key] then
        ProESPObjects[key]:Destroy()
        ProESPObjects[key] = nil
    end
end

local function CreateStatusBillboard(char, player, isDown, dist, hp)
    if StatusBillboards[char] then
        StatusBillboards[char]:Destroy()
    end
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 130, 0, 60)
    bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.Parent = char
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = isDown and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Text = string.format("%s%s\nDist: %.0f\nHP: %.0f", 
        isDown and "🔻 DOWN\n" or "",
        player.Name, dist, hp)
    label.Parent = bb
    
    bb.Adornee = head
    StatusBillboards[char] = bb
end

task.spawn(function()
    while task.wait(0.4) do
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then task.wait(1) continue end
        
        for key, obj in pairs(ProESPObjects) do
            if not obj.Adornee or not obj.Adornee.Parent then
                ProRemoveESP(key)
            end
        end
        
        if ESPPro.Pallet then
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name == "Pallet" or obj.Name == "Palletwrong") then
                    local pivot = obj:GetPivot()
                    local dist = (pivot.Position - root.Position).Magnitude
                    if dist <= ESPPro.MaxDist then
                        ProCreateESP(obj, ESPPro.PalletColor, "P_" .. obj:GetDebugId())
                    end
                end
            end
        end
        
        if ESPPro.Window then
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and obj.Name == "Window" then
                    local pivot = obj:GetPivot()
                    local dist = (pivot.Position - root.Position).Magnitude
                    if dist <= ESPPro.MaxDist then
                        ProCreateESP(obj, ESPPro.WindowColor, "W_" .. obj:GetDebugId())
                    end
                end
            end
        end
        
        if ESPPro.ItemESP then
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Tool") or obj.Name:find("Medkit") or obj.Name:find("Bandage") then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        local dist = (handle.Position - root.Position).Magnitude
                        if dist <= ESPPro.MaxDist then
                            ProCreateESP(handle, ESPPro.ItemColor, "I_" .. obj:GetDebugId())
                        end
                    end
                end
            end
        end
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hum and hrp then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist <= ESPPro.MaxDist then
                        local isDown = hum.Health <= 0 or hum.Health < 2
                            or p.Character:GetAttribute("Downed") == true
                            or p.Character:GetAttribute("IsDown") == true
                            or p.Character:GetAttribute("Knocked") == true
                        
                        if ESPPro.StatusBillboard then
                            CreateStatusBillboard(p.Character, p, isDown, dist, hum.Health)
                        end
                        
                        if ESPPro.HealthBar then
                            ProCreateESP(p.Character, Color3.fromRGB(255, 100, 100), "H_" .. p.UserId)
                        end
                    end
                end
            end
        end
    end
end)

-- ==================== VISUAL PRO ====================
local VisualPro = {
    CleanSky = false, NoScreenEffects = false,
    LowGraphics = false, RGBCharacter = false,
    CameraZoom = false, MaxZoom = 1000,
}

local ScreenEffectTypes = {
    "ColorCorrectionEffect", "DepthOfFieldEffect",
    "BlurEffect", "SunRaysEffect", "BloomEffect"
}

local DisabledEffects = {}

local function ApplyCleanSky(state)
    if state then
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Sky") then
                v:Destroy()
            end
        end
    end
end

local function ApplyNoScreenEffects(state)
    if state then
        for _, v in pairs(Lighting:GetChildren()) do
            for _, t in pairs(ScreenEffectTypes) do
                if v:IsA(t) then
                    DisabledEffects[v] = v.Enabled
                    v.Enabled = false
                end
            end
        end
    else
        for obj, s in pairs(DisabledEffects) do
            if obj and obj.Parent then obj.Enabled = s end
        end
        DisabledEffects = {}
    end
end

local function ApplyLowGraphics(state)
    pcall(function()
        if state then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        else
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end
    end)
end

local function ApplyCameraZoom(state)
    if state then
        LP.CameraMaxZoomDistance = VisualPro.MaxZoom
        LP.CameraMinZoomDistance = 0
    else
        LP.CameraMaxZoomDistance = 128
        LP.CameraMinZoomDistance = 0.5
    end
end

task.spawn(function()
    local hue = 0
    while task.wait(0.05) do
        if VisualPro.RGBCharacter and LP.Character then
            hue = (hue + 0.01) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            for _, v in ipairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Color = color
                end
            end
        end
    end
end)

-- ==================== KILLER PRO ====================
local KillerPro = {
    NoStun = false, VaultSpeed = false, InfiniteLunge = false,
    BurstAttack = false, InstantKill = false,
    AutoFarm = false, AutoArm = false, ForceFlowstate = false,
}

-- No Stun (cegah state Stunned)
task.spawn(function()
    while task.wait(0.1) do
        if not KillerPro.NoStun then continue end
        local char = LP.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end)
        end
    end
end)

-- Vault Speed (percepat lompat window/pallet)
RS.Heartbeat:Connect(function()
    if not KillerPro.VaultSpeed then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * 8)
    local hit = WS:FindPartOnRayWithIgnoreList(ray, {char})
    if hit and (hit.Name == "Window" or hit.Name == "Pallet" or hit.Name == "Palletwrong") then
        if hum.WalkSpeed ~= 30 then hum.WalkSpeed = 30 end
    else
        if hum.WalkSpeed == 30 then hum.WalkSpeed = 16 end
    end
end)

-- Infinite Lunge (extend attack range)
local originalAttackRange = nil
task.spawn(function()
    while task.wait(0.5) do
        if not KillerPro.InfiniteLunge then continue end
        for _, v in ipairs(WS:GetDescendants()) do
            if v:IsA("NumberValue") and (v.Name:lower():find("range") or v.Name:lower():find("reach")) then
                v.Value = 50
            end
        end
    end
end)

-- Burst Attack (spam attack)
task.spawn(function()
    while task.wait(0.1) do
        if not KillerPro.BurstAttack then continue end
        local char = LP.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then continue end
        pcall(function()
            if AttackEvent then
                AttackEvent:FireServer()
            end
        end)
    end
end)

-- Instant Kill (spam attack dengan delay kecil)
local InstantKillDelay = 0.05
task.spawn(function()
    while task.wait(InstantKillDelay) do
        if not KillerPro.InstantKill then continue end
        local root = GetRoot()
        if not root then continue end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and IsSurvivor(p) then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - root.Position).Magnitude <= 15 then
                    pcall(function()
                        if AttackEvent then AttackEvent:FireServer(p.Character) end
                    end)
                    break
                end
            end
        end
    end
end)

-- Force Flowstate (trigger flowstate attribute)
local function ApplyFlowstate(state)
    local char = LP.Character
    if not char then return end
    if state then
        pcall(function()
            char:SetAttribute("Flowstate", true)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetAttribute("Flowstate", true)
            end
        end)
    else
        pcall(function()
            char:SetAttribute("Flowstate", false)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetAttribute("Flowstate", false)
            end
        end)
    end
end

-- ==================== COMBAT PRO ====================
local CombatPro = {
    AntiBlind = false, NoSlowdown = false,
}

task.spawn(function()
    while task.wait(0.2) do
        if not CombatPro.AntiBlind then continue end
        local char = LP.Character
        if not char then continue end
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then
                v.Enabled = false
            end
        end
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BlurEffect") then v.Enabled = false end
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if not CombatPro.NoSlowdown then continue end
        local char = LP.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed < 16 and hum.WalkSpeed > 0 then
            -- Cek kalau bukan sengaja diset user
            if not Movement.SpeedEnabled then
                hum.WalkSpeed = 16
            end
        end
    end
end)

-- Silent Aim Pistol
local SilentPistol = { Enabled = false, TargetMode = "Killer", FOV = 200, WallCheck = true }

local PistolRemotes = {}
task.spawn(function()
    while task.wait(5) do
        PistolRemotes = {}
        for _, obj in ipairs(Rep:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local n = obj.Name:lower()
                if n:find("gun") or n:find("pistol") or n:find("shoot") or n:find("fire") then
                    table.insert(PistolRemotes, obj)
                end
            end
        end
    end
end)

-- ==================== UTILITY PRO ====================
local UtilityPro = {
    AntiAFK = false, AntiFling = false,
}

-- Anti-AFK
LP.Idled:Connect(function()
    if UtilityPro.AntiAFK then
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end
end)

-- Anti-Fling
task.spawn(function()
    while task.wait(0.5) do
        if not UtilityPro.AntiFling then continue end
        local char = LP.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel = hrp.Velocity.Magnitude
            if vel > 500 then
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

-- Server Hop / Rejoin / Copy Job ID
local function ServerHop()
    local TS = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local success, err = pcall(function()
        TS:Teleport(placeId, LP)
    end)
    if not success then
        Rayfield:Notify({Title="Yarhub", Content="Gagal hop: "..tostring(err), Duration=3})
    end
end

local function RejoinServer()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
end

local function CopyJobId()
    local jobId = game.JobId
    if setclipboard then
        setclipboard(jobId)
        Rayfield:Notify({Title="Yarhub", Content="Job ID dicopy: "..jobId, Duration=3})
    else
        Rayfield:Notify({Title="Yarhub", Content="Job ID: "..jobId, Duration=5})
    end
end

-- ==================== FUN ====================
local Fun = {
    JerkTool = false, EmoteSpam = false,
}

-- Jerk Tool
local currentJerkTool = nil
local function CreateJerkTool()
    if currentJerkTool then currentJerkTool:Destroy() end
    local char = LP.Character
    if not char then return end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    local tool = Instance.new("Tool")
    tool.Name = "Jerk Off"
    tool.RequiresHandle = false
    tool.Parent = backpack
    currentJerkTool = tool
    tool.Equipped:Connect(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local anim = Instance.new("Animation")
            anim.AnimationId = hum.RigType == Enum.HumanoidRigType.R15 
                and "rbxassetid://698251653" 
                or "rbxassetid://72042024"
            local track = hum:LoadAnimation(anim)
            track.Looped = true
            track:Play()
            tool.Unequipped:Connect(function() track:Stop() end)
        end
    end)
end

-- Emote System
local Emotes = {
    "Mannrobics", "Arm Swing", "Schadenfreude",
    "Kyoufuu", "Backflip", "Griddy", "Friday Night",
    "Floating Rest", "OnePlays", "Quick Combo",
    "WarCry", "Wave"
}

local function PlayEmote(emoteName)
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    local emoteRemote = Rep:FindFirstChild("Remotes")
        and Rep.Remotes:FindFirstChild("Emotes")
    if emoteRemote then
        pcall(function()
            emoteRemote:FireServer(emoteName)
        end)
    end
end

-- Avatar Blocky
local function ApplyBlockyBody(state)
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if state then
        local desc = Instance.new("HumanoidDescription")
        desc.BodyTypeScale = 1
        desc.DepthScale = 1
        desc.HeadScale = 1
        desc.HeightScale = 1
        desc.ProportionScale = 0
        desc.WidthScale = 1
        pcall(function()
            hum:ApplyDescriptionClientServer(desc)
        end)
    end
    end-- ================================================================
-- PART 8 of 8 - UI EXTENDED
-- ================================================================

local ESPProT = Win:CreateTab("ESP Pro")
local VisProT = Win:CreateTab("Visual Pro")
local KillProT = Win:CreateTab("Killer Pro")
local ComProT = Win:CreateTab("Combat Pro")
local UtilProT = Win:CreateTab("Utility Pro")
local FunT = Win:CreateTab("Fun")

Rayfield:Notify({Title="Yarhub Extended", Content="35 fitur tambahan dimuat!", Duration=5})

-- ESP PRO
ESPProT:CreateSection("ESP Pallet & Window")
ESPProT:CreateToggle({Name="ESP Pallet", CurrentValue=false,
   Callback=function(v) ESPPro.Pallet = v end})
ESPProT:CreateToggle({Name="ESP Window", CurrentValue=false,
   Callback=function(v) ESPPro.Window = v end})
ESPProT:CreateToggle({Name="ESP Item (Tool/Medkit)", CurrentValue=false,
   Callback=function(v) ESPPro.ItemESP = v end})

ESPProT:CreateSection("ESP Status Billboard")
ESPProT:CreateToggle({Name="Status Billboard (Nama+Jarak+HP)", CurrentValue=false,
   Callback=function(v) ESPPro.StatusBillboard = v end})
ESPProT:CreateToggle({Name="Health Bar ESP", CurrentValue=false,
   Callback=function(v) ESPPro.HealthBar = v end})

ESPProT:CreateSection("Pengaturan")
ESPProT:CreateSlider({Name="Jarak Max", Range={50,2000}, Increment=50, CurrentValue=500,
   Callback=function(v) ESPPro.MaxDist = v end})
ESPProT:CreateColorPicker({Name="Warna Pallet", Color=Color3.fromRGB(74,255,181),
   Callback=function(c) ESPPro.PalletColor = c end})
ESPProT:CreateColorPicker({Name="Warna Window", Color=Color3.fromRGB(74,255,181),
   Callback=function(c) ESPPro.WindowColor = c end})
ESPProT:CreateColorPicker({Name="Warna Item", Color=Color3.fromRGB(255,215,0),
   Callback=function(c) ESPPro.ItemColor = c end})

-- VISUAL PRO
VisProT:CreateSection("FPS Boost")
VisProT:CreateToggle({Name="Clean Sky (hapus skybox)", CurrentValue=false,
   Callback=function(v)
      VisualPro.CleanSky = v
      ApplyCleanSky(v)
   end})
VisProT:CreateToggle({Name="No Screen Effects (blur, bloom)", CurrentValue=false,
   Callback=function(v)
      VisualPro.NoScreenEffects = v
      ApplyNoScreenEffects(v)
   end})
VisProT:CreateToggle({Name="Low Graphics Mode ⚠️", CurrentValue=false,
   Callback=function(v)
      VisualPro.LowGraphics = v
      ApplyLowGraphics(v)
   end})

VisProT:CreateSection("Camera & Karakter")
VisProT:CreateToggle({Name="Camera Unlimited Zoom", CurrentValue=false,
   Callback=function(v)
      VisualPro.CameraZoom = v
      ApplyCameraZoom(v)
   end})
VisProT:CreateSlider({Name="Max Zoom Distance", Range={200,5000}, Increment=100, CurrentValue=1000,
   Callback=function(v)
      VisualPro.MaxZoom = v
      if VisualPro.CameraZoom then ApplyCameraZoom(true) end
   end})
VisProT:CreateToggle({Name="RGB Character 🎨", CurrentValue=false,
   Callback=function(v) VisualPro.RGBCharacter = v end})

-- KILLER PRO
KillProT:CreateSection("Chase Tools")
KillProT:CreateToggle({Name="No Stun ⚠️", CurrentValue=false,
   Callback=function(v) KillerPro.NoStun = v end})
KillProT:CreateToggle({Name="Vault Speed", CurrentValue=false,
   Callback=function(v) KillerPro.VaultSpeed = v end})
KillProT:CreateToggle({Name="Infinite Lunge ⚠️", CurrentValue=false,
   Callback=function(v) KillerPro.InfiniteLunge = v end})
KillProT:CreateToggle({Name="Force Flowstate Perk", CurrentValue=false,
   Callback=function(v)
      KillerPro.ForceFlowstate = v
      ApplyFlowstate(v)
   end})

KillProT:CreateSection("Attack Tools ⚠️⚠️")
KillProT:CreateToggle({Name="Burst Attack (spam) ⚠️", CurrentValue=false,
   Callback=function(v)
      KillerPro.BurstAttack = v
      if v then Rayfield:Notify({Title="⚠️", Content="Burst - risiko ban!", Duration=4}) end
   end})
KillProT:CreateToggle({Name="Instant Kill ⚠️⚠️", CurrentValue=false,
   Callback=function(v)
      KillerPro.InstantKill = v
      if v then Rayfield:Notify({Title="⚠️⚠️", Content="INSTANT KILL - SANGAT BERISIKO!", Duration=5}) end
   end})

-- COMBAT PRO
ComProT:CreateSection("Defense")
ComProT:CreateToggle({Name="Anti Blind", CurrentValue=false,
   Callback=function(v) CombatPro.AntiBlind = v end})
ComProT:CreateToggle({Name="No Slowdown", CurrentValue=false,
   Callback=function(v) CombatPro.NoSlowdown = v end})

ComProT:CreateSection("Silent Aim Pistol ⚠️")
ComProT:CreateToggle({Name="Aktifkan Silent Aim Pistol", CurrentValue=false,
   Callback=function(v)
      SilentPistol.Enabled = v
      if v then Rayfield:Notify({Title="⚠️ Silent", Content="Risiko ban!", Duration=4}) end
   end})
ComProT:CreateDropdown({Name="Target", Options={"Killer","Survivor","All"},
   CurrentOption={"Killer"}, Callback=function(O) SilentPistol.TargetMode = O[1] end})
ComProT:CreateSlider({Name="FOV", Range={50,500}, Increment=10, CurrentValue=200,
   Callback=function(v) SilentPistol.FOV = v end})

-- UTILITY PRO
UtilProT:CreateSection("Anti & Auto")
UtilProT:CreateToggle({Name="Anti-AFK", CurrentValue=false,
   Callback=function(v)
      UtilityPro.AntiAFK = v
      Rayfield:Notify({Title="Yarhub", Content=v and "Anti-AFK ON" or "Anti-AFK OFF", Duration=2})
   end})
UtilProT:CreateToggle({Name="Anti-Fling", CurrentValue=false,
   Callback=function(v) UtilityPro.AntiFling = v end})

UtilProT:CreateSection("Server")
UtilProT:CreateButton({Name="Server Hop", Callback=function()
   Rayfield:Notify({Title="Yarhub", Content="Hop server...", Duration=2})
   task.wait(1)
   ServerHop()
end})
UtilProT:CreateButton({Name="Rejoin Server", Callback=function()
   Rayfield:Notify({Title="Yarhub", Content="Rejoin...", Duration=2})
   task.wait(1)
   RejoinServer()
end})
UtilProT:CreateButton({Name="Copy Job ID", Callback=function() CopyJobId() end})

-- FUN
FunT:CreateSection("Fun Tools")
FunT:CreateToggle({Name="Jerk Tool", CurrentValue=false,
   Callback=function(v)
      Fun.JerkTool = v
      if v then CreateJerkTool() end
   end})

FunT:CreateSection("Emote")
FunT:CreateDropdown({Name="Pilih Emote", Options=Emotes,
   CurrentOption={"Mannrobics"},
   Callback=function(O) Fun.SelectedEmote = O[1] end})
FunT:CreateButton({Name="Play Emote", Callback=function()
   if Fun.SelectedEmote then
      PlayEmote(Fun.SelectedEmote)
   else
      PlayEmote("Mannrobics")
   end
end})

FunT:CreateSection("Avatar")
FunT:CreateToggle({Name="Blocky Body", CurrentValue=false,
   Callback=function(v) ApplyBlockyBody(v) end})

Rayfield:Notify({Title="Yarhub Extended", Content="35 fitur aktif! Test 1-1 ya!", Duration=6})-- ================================================================
-- PART 9 - ADVANCED FEATURES
-- ================================================================

-- ==================== MOVEMENT ADVANCED ====================
local MoveAdv = {
    InfiniteJump = false,
    BunnyHop = false,
    Fly = false,
    FlySpeed = 50,
    TeleportToPlayer = false,
    TeleportTarget = "",
    NoGravity = false,
}

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if MoveAdv.InfiniteJump then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Bunny Hop
task.spawn(function()
    while task.wait(0.1) do
        if not MoveAdv.BunnyHop then continue end
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial ~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Fly
local flyConn = nil
local bodyVel = nil
local bodyGyro = nil

local function StartFly()
    if flyConn then flyConn:Disconnect() end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVel.Velocity = Vector3.new(0, 0, 0)
    bodyVel.Parent = hrp
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp
    
    flyConn = RS.RenderStepped:Connect(function()
        if not MoveAdv.Fly then return end
        if not bodyVel or not bodyVel.Parent then return end
        
        local moveDir = Vector3.new(0, 0, 0)
        local camCF = workspace.CurrentCamera.CFrame
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camCF.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camCF.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camCF.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camCF.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
        end
        
        bodyVel.Velocity = moveDir * MoveAdv.FlySpeed
        bodyGyro.CFrame = camCF
    end)
end

local function StopFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
end

-- No Gravity
task.spawn(function()
    while task.wait(0.1) do
        if not MoveAdv.NoGravity then continue end
        local char = LP.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
        end
    end
end)

-- Teleport to Player
local function TeleportToPlayerFunc(playerName)
    if not playerName or playerName == "" then return end
    local target = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Name:lower():find(playerName:lower()) and p.Character then
            target = p
            break
        end
    end
    if target and target.Character then
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp and targetHrp then
            hrp.CFrame = targetHrp.CFrame + Vector3.new(0, 3, 0)
            Rayfield:Notify({Title="Yarhub", Content="Teleport ke: "..target.Name, Duration=2})
        end
    else
        Rayfield:Notify({Title="Yarhub", Content="Player gak ditemukan", Duration=2})
    end
end

-- Teleport to Generator
local function TeleportToGen()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local bestGen, bestDist = nil, math.huge
    local map = WS:FindFirstChild("Map")
    if map then
        for _, v in pairs(map:GetDescendants()) do
            if v:IsA("Model") and v.Name == "Generator" then
                local pivot = v:GetPivot()
                local dist = (pivot.Position - root.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    bestGen = v
                end
            end
        end
    end
    if bestGen then
        root.CFrame = bestGen:GetPivot() + Vector3.new(0, 5, 0)
        Rayfield:Notify({Title="Yarhub", Content="Teleport ke Generator", Duration=2})
    end
end

-- ==================== COMBAT ADVANCED ====================
local CombatAdv = {
    AimAssist = false,
    AimAssistStrength = 0.3,
    AimAssistFOV = 150,
    HitboxExpander = false,
    HitboxSize = 10,
    AutoDodge = false,
    DodgeRange = 20,
}

-- Aim Assist (halus, gak lock)
RS.RenderStepped:Connect(function()
    if not CombatAdv.AimAssist then return end
    if not UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then return end
    
    local center = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
    local closest, shortest = nil, CombatAdv.AimAssistFOV
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local killer = IsKiller(p)
            if killer then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos, vis = Cam:WorldToViewportPoint(hrp.Position)
                    if vis then
                        local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if d < shortest then
                            shortest = d
                            closest = hrp
                        end
                    end
                end
            end
        end
    end
    
    if closest then
        local targetCF = CFrame.new(Cam.CFrame.Position, closest.Position)
        Cam.CFrame = Cam.CFrame:Lerp(targetCF, CombatAdv.AimAssistStrength * 0.1)
    end
end)

-- Hitbox Expander
local originalSizes = {}
task.spawn(function()
    while task.wait(0.5) do
        if not CombatAdv.HitboxExpander then
            -- Restore
            for part, size in pairs(originalSizes) do
                if part and part.Parent then
                    part.Size = size
                end
            end
            originalSizes = {}
            continue
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and IsKiller(p) then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not originalSizes[hrp] then
                        originalSizes[hrp] = hrp.Size
                    end
                    hrp.Size = Vector3.new(
                        CombatAdv.HitboxSize,
                        CombatAdv.HitboxSize,
                        CombatAdv.HitboxSize
                    )
                    hrp.Transparency = 0.5
                    hrp.CanCollide = false
                end
            end
        end
    end
end)

-- Auto Dodge
task.spawn(function()
    while task.wait(0.1) do
        if not CombatAdv.AutoDodge then continue end
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and IsKiller(p) then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist <= CombatAdv.DodgeRange then
                        -- Dodge ke samping
                        local dodgeDir = root.CFrame.RightVector * (math.random() > 0.5 and 1 or -1)
                        root.Velocity = dodgeDir * 50 + Vector3.new(0, 20, 0)
                    end
                end
            end
        end
    end
end)

-- ==================== UTILITY ADVANCED ====================
local UtilAdv = {
    ShowCoords = false,
    TimePlayed = false,
    AutoRejoin = false,
    StartTime = tick(),
}

-- Show Coordinates
local coordGui = Instance.new("ScreenGui")
coordGui.Name = "Yarhub_Coords"
coordGui.ResetOnSpawn = false
coordGui.Parent = CoreGui

local coordLabel = Instance.new("TextLabel")
coordLabel.Size = UDim2.new(0, 250, 0, 25)
coordLabel.Position = UDim2.new(0, 10, 0, 80)
coordLabel.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
coordLabel.BackgroundTransparency = 0.3
coordLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
coordLabel.Font = Enum.Font.Code
coordLabel.TextSize = 14
coordLabel.Text = "X: 0 | Y: 0 | Z: 0"
coordLabel.Visible = false
coordLabel.Parent = coordGui

local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(0, 250, 0, 25)
timeLabel.Position = UDim2.new(0, 10, 0, 110)
timeLabel.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
timeLabel.BackgroundTransparency = 0.3
timeLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
timeLabel.Font = Enum.Font.Code
timeLabel.TextSize = 14
timeLabel.Text = "Time: 00:00"
timeLabel.Visible = false
timeLabel.Parent = coordGui

task.spawn(function()
    while task.wait(0.2) do
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        
        if UtilAdv.ShowCoords and root then
            coordLabel.Visible = true
            local p = root.Position
            coordLabel.Text = string.format("X: %.0f | Y: %.0f | Z: %.0f", p.X, p.Y, p.Z)
        else
            coordLabel.Visible = false
        end
        
        if UtilAdv.TimePlayed then
            timeLabel.Visible = true
            local elapsed = tick() - UtilAdv.StartTime
            local mins = math.floor(elapsed / 60)
            local secs = math.floor(elapsed % 60)
            timeLabel.Text = string.format("Time: %02d:%02d", mins, secs)
        else
            timeLabel.Visible = false
        end
    end
end)

-- Auto Rejoin on Kick
game:GetService("Players").PlayerRemoving:Connect(function(p)
    if p == LP then
        if UtilAdv.AutoRejoin then
            task.wait(2)
            game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
        end
    end
end)

-- ==================== ESP ADVANCED ====================
local ESPAdv = {
    Tracer = false,
    Arrow = false,
    TracerColor = Color3.fromRGB(0, 255, 100),
    ArrowColor = Color3.fromRGB(255, 100, 100),
}

local tracerDrawings = {}
local arrowDrawings = {}

-- ESP Tracer
RS.RenderStepped:Connect(function()
    -- Cleanup yang gak kepake
    for _, d in pairs(tracerDrawings) do
        if d.Remove then d:Remove() end
    end
    tracerDrawings = {}
    
    if not ESPAdv.Tracer then return end
    
    local bottomCenter = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y)
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local killer = IsKiller(p)
            if hrp and killer then
                local pos, vis = Cam:WorldToViewportPoint(hrp.Position)
                if vis then
                    local line = Drawing.new("Line")
                    line.From = bottomCenter
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Color = ESPAdv.TracerColor
                    line.Thickness = 1
                    line.Transparency = 1
                    line.Visible = true
                    table.insert(tracerDrawings, line)
                end
            end
        end
    end
end)

-- ESP Arrow (panah arah)
RS.RenderStepped:Connect(function()
    for _, d in pairs(arrowDrawings) do
        if d.Remove then d:Remove() end
    end
    arrowDrawings = {}
    
    if not ESPAdv.Arrow then return end
    
    local center = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local killer = IsKiller(p)
            if hrp and killer then
                local pos, vis = Cam:WorldToViewportPoint(hrp.Position)
                if not vis then
                    -- Target di luar layar, tunjukkan panah
                    local targetScreen = Cam:WorldToViewportPoint(hrp.Position)
                    local dir = Vector2.new(targetScreen.X, targetScreen.Y) - center
                    local arrowPos = center + dir.Unit * 200
                    
                    local arrow = Drawing.new("Triangle")
                    arrow.PointA = arrowPos + Vector2.new(0, -15)
                    arrow.PointB = arrowPos + Vector2.new(-10, 10)
                    arrow.PointC = arrowPos + Vector2.new(10, 10)
                    arrow.Color = ESPAdv.ArrowColor
                    arrow.Filled = true
                    arrow.Visible = true
                    table.insert(arrowDrawings, arrow)
                end
            end
        end
    end
end)

-- ==================== SURVIVOR ADVANCED ====================
local SurvAdv = {
    AntiCarry = false,
    AutoVault = false,
    AutoHeal = false,
    HealThreshold = 50,
}

-- Anti-Carry
task.spawn(function()
    while task.wait(0.1) do
        if not SurvAdv.AntiCarry then continue end
        local char = LP.Character
        if not char then continue end
        local carried = (char:FindFirstChild("IsCarried") and char.IsCarried.Value)
            or (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)
        if carried and WiggleEvent then
            for i = 1, 10 do
                pcall(function() WiggleEvent:FireServer() end)
            end
        end
    end
end)

-- Auto Vault
task.spawn(function()
    while task.wait(0.3) do
        if not SurvAdv.AutoVault then continue end
        local char = LP.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial == Enum.Material.Air then
            -- Di udara, cek ada window/pallet dekat
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * 5)
                local hit = WS:FindPartOnRayWithIgnoreList(ray, {char})
                if hit and (hit.Name == "Window" or hit.Name == "Pallet") then
                    -- Auto vault trigger
                    pcall(function()
                        VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                        task.wait(0.05)
                        VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    end)
                end
            end
        end
    end
end)

-- Auto Heal
task.spawn(function()
    while task.wait(0.5) do
        if not SurvAdv.AutoHeal then continue end
        local char = LP.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health < SurvAdv.HealThreshold and hum.Health > 0 then
            -- Cari medkit di backpack
            local backpack = LP:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool.Name:lower():find("med") or tool.Name:lower():find("heal") then
                        local hum2 = char:FindFirstChildOfClass("Humanoid")
                        if hum2 then
                            hum2:EquipTool(tool)
                            task.wait(0.1)
                            pcall(function()
                                tool:Activate()
                            end)
                        end
                        break
                    end
                end
            end
        end
    end
end)-- ================================================================
-- PART 9b - UI Advanced Features
-- ================================================================

local AdvMoveT = Win:CreateTab("Movement Adv")
local AdvComT = Win:CreateTab("Combat Adv")
local AdvUtilT = Win:CreateTab("Utility Adv")
local AdvSurvT = Win:CreateTab("Survivor Adv")

-- MOVEMENT ADV
AdvMoveT:CreateSection("Jump Tools")
AdvMoveT:CreateToggle({Name="Infinite Jump", CurrentValue=false,
   Callback=function(v) MoveAdv.InfiniteJump = v end})
AdvMoveT:CreateToggle({Name="Bunny Hop", CurrentValue=false,
   Callback=function(v) MoveAdv.BunnyHop = v end})

AdvMoveT:CreateSection("Fly ⚠️")
AdvMoveT:CreateToggle({Name="Aktifkan Fly (WASD + Space/Ctrl)", CurrentValue=false,
   Callback=function(v)
      MoveAdv.Fly = v
      if v then StartFly() else StopFly() end
      Rayfield:Notify({Title="Yarhub", Content=v and "Fly ON" or "Fly OFF", Duration=2})
   end})
AdvMoveT:CreateSlider({Name="Fly Speed", Range={10,200}, Increment=10, CurrentValue=50,
   Callback=function(v) MoveAdv.FlySpeed = v end})

AdvMoveT:CreateSection("Gravity")
AdvMoveT:CreateToggle({Name="No Gravity", CurrentValue=false,
   Callback=function(v) MoveAdv.NoGravity = v end})

AdvMoveT:CreateSection("Teleport ⚠️")
AdvMoveT:CreateInput({
   Name = "Nama Player Target",
   PlaceholderText = "Contoh: Player123",
   RemoveTextAfterFocusLost = false,
   Callback = function(text) MoveAdv.TeleportTarget = text end,
})
AdvMoveT:CreateButton({Name="Teleport ke Player",
   Callback=function() TeleportToPlayerFunc(MoveAdv.TeleportTarget) end})
AdvMoveT:CreateButton({Name="Teleport ke Generator Terdekat",
   Callback=function() TeleportToGen() end})

-- COMBAT ADV
AdvComT:CreateSection("Aim Assist")
AdvComT:CreateToggle({Name="Aim Assist (halus)", CurrentValue=false,
   Callback=function(v) CombatAdv.AimAssist = v end})
AdvComT:CreateSlider({Name="Strength", Range={0.1,1}, Increment=0.05, CurrentValue=0.3,
   Callback=function(v) CombatAdv.AimAssistStrength = v end})
AdvComT:CreateSlider({Name="FOV", Range={50,500}, Increment=10, CurrentValue=150,
   Callback=function(v) CombatAdv.AimAssistFOV = v end})

AdvComT:CreateSection("Hitbox Expander ⚠️")
AdvComT:CreateToggle({Name="Hitbox Expander", CurrentValue=false,
   Callback=function(v)
      CombatAdv.HitboxExpander = v
      if v then Rayfield:Notify({Title="⚠️ Hitbox", Content="Risiko ban!", Duration=4}) end
   end})
AdvComT:CreateSlider({Name="Hitbox Size", Range={5,30}, Increment=1, CurrentValue=10,
   Callback=function(v) CombatAdv.HitboxSize = v end})

AdvComT:CreateSection("Auto Dodge")
AdvComT:CreateToggle({Name="Auto Dodge", CurrentValue=false,
   Callback=function(v) CombatAdv.AutoDodge = v end})
AdvComT:CreateSlider({Name="Dodge Range", Range={5,50}, Increment=1, CurrentValue=20,
   Callback=function(v) CombatAdv.DodgeRange = v end})

-- UTILITY ADV
AdvUtilT:CreateSection("Info Display")
AdvUtilT:CreateToggle({Name="Show Coordinates", CurrentValue=false,
   Callback=function(v) UtilAdv.ShowCoords = v end})
AdvUtilT:CreateToggle({Name="Time Played Counter", CurrentValue=false,
   Callback=function(v) UtilAdv.TimePlayed = v end})

AdvUtilT:CreateSection("Recovery")
AdvUtilT:CreateToggle({Name="Auto Rejoin on Kick", CurrentValue=false,
   Callback=function(v) UtilAdv.AutoRejoin = v end})

AdvUtilT:CreateSection("ESP Advanced")
AdvUtilT:CreateToggle({Name="ESP Tracer (garis ke killer)", CurrentValue=false,
   Callback=function(v) ESPAdv.Tracer = v end})
AdvUtilT:CreateColorPicker({Name="Warna Tracer", Color=Color3.fromRGB(0,255,100),
   Callback=function(c) ESPAdv.TracerColor = c end})
AdvUtilT:CreateToggle({Name="ESP Arrow (panah luar layar)", CurrentValue=false,
   Callback=function(v) ESPAdv.Arrow = v end})
AdvUtilT:CreateColorPicker({Name="Warna Arrow", Color=Color3.fromRGB(255,100,100),
   Callback=function(c) ESPAdv.ArrowColor = c end})

-- SURVIVOR ADV
AdvSurvT:CreateSection("Anti-Carry")
AdvSurvT:CreateToggle({Name="Anti-Carry (auto wiggle)", CurrentValue=false,
   Callback=function(v) SurvAdv.AntiCarry = v end})

AdvSurvT:CreateSection("Auto Vault")
AdvSurvT:CreateToggle({Name="Auto Vault", CurrentValue=false,
   Callback=function(v) SurvAdv.AutoVault = v end})

AdvSurvT:CreateSection("Auto Heal")
AdvSurvT:CreateToggle({Name="Auto Heal (pakai medkit)", CurrentValue=false,
   Callback=function(v) SurvAdv.AutoHeal = v end})
AdvSurvT:CreateSlider({Name="Heal Threshold (%)", Range={10,90}, Increment=5, CurrentValue=50,
   Callback=function(v) SurvAdv.HealThreshold = v end})

Rayfield:Notify({Title="Yarhub Part 9", Content="Advanced features dimuat!", Duration=5})
