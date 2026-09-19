-- ================================================================
-- YARHUB ULTIMATE - FULL EDITION
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
local function GetRoot() return LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") end
local function GetHum() return LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") end
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
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart
}

task.spawn(function()
    while task.wait(0.5) do
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

-- FOV
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

-- SPEED BOOST (1-100)
local SpeedBoost = { Enabled = false, Value = 16, Original = 16 }

task.spawn(function()
    while task.wait(0.15) do
        if SpeedBoost.Enabled then
            local hum = GetHum()
            if hum and hum.WalkSpeed ~= SpeedBoost.Value then
                hum.WalkSpeed = SpeedBoost.Value
            end
        end
    end
end)

local function ToggleSpeed(state)
    SpeedBoost.Enabled = state
    if state then
        local hum = GetHum()
        if hum then hum.WalkSpeed = SpeedBoost.Value end
    else
        local hum = GetHum()
        if hum then hum.WalkSpeed = SpeedBoost.Original end
    end
end

-- JUMP POWER
local JumpBoost = { Enabled = false, Value = 50, Original = 50 }

task.spawn(function()
    while task.wait(0.15) do
        if JumpBoost.Enabled then
            local hum = GetHum()
            if hum and hum.JumpPower ~= JumpBoost.Value then
                hum.JumpPower = JumpBoost.Value
                hum.UseJumpPower = true
            end
        end
    end
end)

-- CROSSHAIR
local Crosshair = {
    Enabled = false, Size = 8, Thickness = 2,
    Color = Color3.fromRGB(0, 255, 100), Style = "Plus"
}
local CHDrawings = {}
local CHCreated = false
local LastCH = nil

local function ClearCH()
    for _, v in pairs(CHDrawings) do
        if v.Remove then v:Remove() end
    end
    CHDrawings = {}
    CHCreated = false
end

RS.RenderStepped:Connect(function()
    if not Crosshair.Enabled then
        for _, v in pairs(CHDrawings) do
            if v then v.Visible = false end
        end
        return
    end
    if LastCH ~= Crosshair.Style then
        ClearCH()
        LastCH = Crosshair.Style
    end
    local center = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
    if not CHCreated then
        CHCreated = true
        if Crosshair.Style == "Plus" then
            for i = 1, 4 do
                local line = Drawing.new("Line")
                line.Visible = true
                table.insert(CHDrawings, line)
            end
        elseif Crosshair.Style == "Dot" then
            local d = Drawing.new("Circle")
            d.Filled = true; d.Visible = true
            table.insert(CHDrawings, d)
        elseif Crosshair.Style == "Circle" then
            local c = Drawing.new("Circle")
            c.Filled = false; c.Visible = true
            table.insert(CHDrawings, c)
        end
    end
    if Crosshair.Style == "Plus" then
        for _, l in pairs(CHDrawings) do
            l.Color = Crosshair.Color
            l.Thickness = Crosshair.Thickness
        end
        CHDrawings[1].From = center + Vector2.new(-Crosshair.Size, 0)
        CHDrawings[1].To = center + Vector2.new(-2, 0)
        CHDrawings[2].From = center + Vector2.new(Crosshair.Size, 0)
        CHDrawings[2].To = center + Vector2.new(2, 0)
        CHDrawings[3].From = center + Vector2.new(0, -Crosshair.Size)
        CHDrawings[3].To = center + Vector2.new(0, -2)
        CHDrawings[4].From = center + Vector2.new(0, Crosshair.Size)
        CHDrawings[4].To = center + Vector2.new(0, 2)
    elseif Crosshair.Style == "Dot" then
        local d = CHDrawings[1]
        d.Position = center; d.Radius = Crosshair.Size/2; d.Color = Crosshair.Color
    elseif Crosshair.Style == "Circle" then
        local c = CHDrawings[1]
        c.Position = center; c.Radius = Crosshair.Size
        c.Color = Crosshair.Color; c.Thickness = Crosshair.Thickness
    end
end)

-- FPS/PING
local FPSPing = { Enabled = true, FPS = 0, Ping = 0, Frames = 0, LastTick = tick() }
local FPSGui = Instance.new("ScreenGui")
FPSGui.Name = "Yarhub_FPS"
FPSGui.ResetOnSpawn = false
FPSGui.Parent = CoreGui

local FPSFrame = Instance.new("Frame")
FPSFrame.Size = UDim2.new(0, 210, 0, 28)
FPSFrame.Position = UDim2.new(0, 10, 0, 40)
FPSFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
FPSFrame.BackgroundTransparency = 0.3
FPSFrame.BorderSizePixel = 0
FPSFrame.Parent = FPSGui
Instance.new("UICorner", FPSFrame).CornerRadius = UDim.new(0, 6)

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1, 0, 1, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 13
FPSLabel.Text = "YARHUB | FPS: 60 | Ping: 0"
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
        FPSLabel.Text = string.format("YARHUB | FPS: %d | Ping: %d", FPSPing.FPS, FPSPing.Ping)
    end
end)

-- ANTI-AFK
local AntiAFK = { Enabled = false }
LP.Idled:Connect(function()
    if AntiAFK.Enabled then
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end
end)

-- REMOTES
local CarryEvent = Rep:FindFirstChild("Remotes") and Rep.Remotes:FindFirstChild("Carry") and Rep.Remotes.Carry:FindFirstChild("CarrySurvivorEvent")
local HookEvent = Rep:FindFirstChild("Remotes") and Rep.Remotes:FindFirstChild("Carry") and Rep.Remotes.Carry:FindFirstChild("HookEvent")
local AttackEvent = Rep:FindFirstChild("Remotes") and Rep.Remotes:FindFirstChild("Attacks") and Rep.Remotes.Attacks:FindFirstChild("BasicAttack")
local WiggleEvent = Rep:FindFirstChild("Remotes") and Rep.Remotes:FindFirstChild("Carry") and Rep.Remotes.Carry:FindFirstChild("SelfUnHookEvent")
local RepairEvent = Rep:FindFirstChild("Remotes") and Rep.Remotes:FindFirstChild("Generator") and Rep.Remotes.Generator:FindFirstChild("RepairEvent")
local StalkEvent = Rep:FindFirstChild("Remotes") and Rep.Remotes:FindFirstChild("Killers") and Rep.Remotes.Killers:FindFirstChild("Stalker") and Rep.Remotes.Killers.Stalker:FindFirstChild("StartStalking")-- ================================================================
-- PART 2 of 6 - ESP + SKILLCHECK
-- ================================================================

-- ESP SYSTEM (Warna Bisa Diubah)
local ESP = {
    On = false, SV = true, KL = true, GN = true, SCP = false,
    SVc = Color3.fromRGB(0, 255, 0),
    KLc = Color3.fromRGB(255, 0, 0),
    GNc = Color3.fromRGB(255, 105, 180),
    SCPc = Color3.fromRGB(255, 0, 0),
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

local function Clean(used)
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
                if e.HL then
                    e.HL.Adornee = c
                    e.HL.FillColor = col
                    e.HL.OutlineColor = col
                end
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
                    if e.HL then e.HL.Adornee = obj end
                end
            end
        end
        Clean(used)
    end
end)

-- AUTO SKILLCHECK (INSTAN + PERFECT FIXED)
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
        Skill.LastGoal = nil
        Skill.Clicked = false
        Skill.WasActive = false
        return
    end
    local lr = line.Rotation % 360
    local gr = goal.Rotation % 360

    -- MODE INSTAN
    if _G.SkillMode == "Instan" then
        local isNew = false
        if not Skill.WasActive then
            isNew = true
        elseif Skill.LastGoal and math.abs(AngDiff(Skill.LastGoal, gr)) > 5 then
            isNew = true
        end
        if isNew then
            Skill.WasActive = true
            Skill.LastGoal = gr
            Skill.Clicked = false
            SkillBusy = true
            task.spawn(function()
                PressSkill()
                task.wait(0.1)
                SkillBusy = false
                Skill.Clicked = true
            end)
        end
        return
    end

    -- MODE PERFECT
    if not Skill.WasActive then
        Skill.WasActive = true
        Skill.LastGoal = gr
        Skill.Clicked = false
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
-- PART 3 of 6 - PARRY + AIMBOT
-- ================================================================

-- AUTO PARRY
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

-- AIMBOT + WALLCHECK
local GunAim = {
    Enabled = false, Holding = false, TargetMode = "Killer",
    Strength = 1, Predict = true, PredictStrength = 0.12,
    FOV = 250, WallCheck = true,
}

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = true
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = false
    end
end)

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist

local function IsVisible(part)
    if not GunAim.WallCheck then return true end
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
                if hrp and hum and hum.Health > 0 and IsVisible(hrp) then
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
end)-- ================================================================
-- PART 4 of 6 - KILLER + GEN BOOST
-- ================================================================

local AutoKill = { Enabled = false, Range = 500, Delay = 0.45, LastAttack = 0 }
local AutoStalk = { Enabled = false, Range = 150, Conn = nil }
local AutoCarry = { Enabled = false, Range = 10 }
local AutoWiggle = { Enabled = false, Spam = 5 }

-- AUTO KILL ALL
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

-- AUTO STALK
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

-- AUTO CARRY
task.spawn(function()
    while task.wait(0.5) do
        if not AutoCarry.Enabled then continue end
        local root = GetRoot()
        if not root then continue end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and IsSurvivor(p) then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 and hum.Health <= hum.MaxHealth * 0.25 then
                    if (hrp.Position - root.Position).Magnitude <= AutoCarry.Range then
                        pcall(function()
                            if CarryEvent then CarryEvent:FireServer(p.Character) end
                        end)
                        break
                    end
                end
            end
        end
    end
end)

-- AUTO HOOK
local function AutoHookNearest()
    local root = GetRoot()
    if not root then return end
    local downed = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and IsSurvivor(p) then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and hum.Health <= hum.MaxHealth * 0.25 then
                downed = p.Character
                break
            end
        end
    end
    if not downed then
        Rayfield:Notify({Title="Yarhub", Content="Tidak ada survivor downed", Duration=2})
        return
    end
    local hook = nil
    local shortest = math.huge
    for _, obj in pairs(WS:GetDescendants()) do
        if obj.Name == "HookPoint" and obj:IsA("BasePart") then
            local d = (obj.Position - root.Position).Magnitude
            if d < shortest and d < 400 then
                shortest = d
                hook = obj
            end
        end
    end
    if hook then
        pcall(function()
            if HookEvent then HookEvent:FireServer(hook, downed) end
        end)
        Rayfield:Notify({Title="Yarhub", Content="Hook dikirim!", Duration=2})
    end
end

-- AUTO WIGGLE
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

-- GEN BOOST (KODINGAN KAMU)
GenBypass = {
    Enabled = false, Cache = {}, CacheTimer = 0,
    Processed = {}, Range = 8,
}

local function GB_GetAllGenerators()
    local now = tick()
    if now - GenBypass.CacheTimer < 5 then return GenBypass.Cache end
    GenBypass.Cache = {}
    GenBypass.CacheTimer = now
    local map = WS:FindFirstChild("Map")
    if not map then return GenBypass.Cache end
    pcall(function()
        for _, v in pairs(map:GetDescendants()) do
            if v:IsA("Model") and v.Name == "Generator" then
                if v:GetAttribute("RepairProgress") ~= nil
                    or v:GetAttribute("kickcount") ~= nil
                    or v:GetAttribute("ProgressRepair") ~= nil then
                    table.insert(GenBypass.Cache, v)
                end
            end
        end
    end)
    return GenBypass.Cache
end

local function GB_GetPoints(genModel)
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

local function GB_WaitRepairing(point, timeout)
    local start = tick()
    while tick() - start < (timeout or 1) do
        if point:GetAttribute("IsRepairing") == true then return true end
        task.wait(0.05)
    end
    return false
end

local function GB_DoRepair(targetPoint)
    local genModel = targetPoint.Parent
    if GenBypass.Processed[genModel] then return end
    GenBypass.Processed[genModel] = true
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        GenBypass.Processed[genModel] = nil
        return
    end
    local originalCFrame = hrp.CFrame
    pcall(function()
        for _, point in pairs(GB_GetPoints(genModel)) do
            if point ~= targetPoint and point.Parent then
                hrp.Anchored = true
                hrp.CFrame = point.CFrame
                task.wait(0.15)
                pcall(function()
                    if RepairEvent then RepairEvent:FireServer(point, true) end
                end)
                if not GB_WaitRepairing(point, 0.8) then
                    pcall(function()
                        if RepairEvent then RepairEvent:FireServer(point, false) end
                    end)
                    task.wait(0.1)
                    hrp.CFrame = point.CFrame
                    task.wait(0.15)
                    pcall(function()
                        if RepairEvent then RepairEvent:FireServer(point, true) end
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
        if RepairEvent then RepairEvent:FireServer(targetPoint, false) end
    end)
end

local function GB_GetNearestPoint()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local bestPoint, bestDist = nil, math.huge
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

-- Auto Gen Boost
task.spawn(function()
    while task.wait(0.5) do
        if not GenBypass.Enabled then continue end
        local p, d = GB_GetNearestPoint()
        if p and d <= GenBypass.Range then
            GB_DoRepair(p)
        end
    end
end)

-- Cleanup processed
task.spawn(function()
    while task.wait(2) do
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
                    if not nearAny then GenBypass.Processed[genModel] = nil end
                end
            end
        end
    end
end)-- ================================================================
-- PART 5 of 6 - MOONWALK + AVATAR + MOVEMENT
-- ================================================================

-- MOONWALK (KODINGAN KAMU)
local Moonwalk = {
    Enabled = false, ShowButton = false,
    SpamSpeed = 30, Intensity = 35, SlowSpeed = 13, UseSlow = true
}

local MoonwalkConnection = nil
local MoonwalkButton = nil

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
    if MoonwalkButton then MoonwalkButton:Destroy(); MoonwalkButton = nil end
    local gui = Instance.new("ScreenGui")
    gui.Name = "MoonwalkGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = PG
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
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    btn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            UIS.InputChanged:Connect(function(changed)
                if changed == input and dragging then
                    local delta = input.Position - dragStart
                    btn.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + delta.X,
                        startPos.Y.Scale, startPos.Y.Offset + delta.Y
                    )
                end
            end)
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

local function removeMoonwalkButton()
    if MoonwalkButton then
        MoonwalkButton:Destroy()
        MoonwalkButton = nil
    end
end

-- Keybind V
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.V then
        setMoonwalk(not Moonwalk.Enabled)
    end
end)

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Moonwalk.Enabled then startMoonwalk() end
end)

if Moonwalk.ShowButton then
    createMoonwalkButton()
end

-- MOVEMENT (Noclip)
local Movement = { Noclip = false, NoclipConn = nil }

local function NoclipPart(p)
    if p:IsA("BasePart") then p.CanCollide = false end
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

-- COPY AVATAR
local AvatarStealer = { Original = nil, CurrentUserId = nil }

local function RemoveClothes(char)
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("Accessory") or v:IsA("Shirt")
        or v:IsA("Pants") or v:IsA("ShirtGraphic") then
            pcall(function() v:Destroy() end)
        end
    end
end

local function CopyAvatar(username)
    if not username or username == "" then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    AvatarStealer.Original = hum:GetAppliedDescription()
    local ok, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    if not ok then
        Rayfield:Notify({Title="Yarhub", Content="User tidak ditemukan!", Duration=3})
        return
    end
    AvatarStealer.CurrentUserId = userId
    task.spawn(function()
        local ok2, desc = pcall(function()
            return Players:GetHumanoidDescriptionFromUserId(userId)
        end)
        if not ok2 or not desc then return end
        RemoveClothes(char)
        task.wait(0.2)
        local success = false
        pcall(function() hum:ApplyDescriptionClientServer(desc); success = true end)
        if not success then
            pcall(function() hum:ApplyDescription(desc); success = true end)
        end
        if success then
            Rayfield:Notify({Title="Yarhub", Content="✅ Avatar dicopy: "..username, Duration=3})
        end
    end)
end

local function ResetAvatar()
    if not AvatarStealer.Original then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        RemoveClothes(char)
        pcall(function() hum:ApplyDescriptionClientServer(AvatarStealer.Original) end)
        AvatarStealer.CurrentUserId = nil
        Rayfield:Notify({Title="Yarhub", Content="Avatar di-reset!", Duration=3})
    end
end-- ================================================================
-- PART 6 of 6 - UI RAYFIELD
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

local MainT   = Win:CreateTab("Visual")
local SkillT  = Win:CreateTab("Skillcheck")
local ParryT  = Win:CreateTab("Parry")
local AimT    = Win:CreateTab("Aimbot")
local KillerT = Win:CreateTab("Killer")
local EspT    = Win:CreateTab("ESP")
local GenT    = Win:CreateTab("Gen Boost")
local MoveT   = Win:CreateTab("Movement")
local MwT     = Win:CreateTab("Moonwalk")
local AvatarT = Win:CreateTab("Avatar")
local InfoT   = Win:CreateTab("Info")

Rayfield:Notify({Title="Yarhub", Content="Semua fitur dimuat!", Duration=5})

-- VISUAL
MainT:CreateSection("Fullbright & Fog")
MainT:CreateToggle({Name="Fullbright", CurrentValue=false,
   Callback=function(v) ToggleFullbright(v) end})
MainT:CreateToggle({Name="No Fog", CurrentValue=false,
   Callback=function(v) ToggleNoFog(v) end})
MainT:CreateSection("FOV Changer")
MainT:CreateToggle({Name="Aktifkan FOV", CurrentValue=false,
   Callback=function(v) ToggleFOV(v) end})
MainT:CreateSlider({Name="FOV Value", Range={50,120}, Increment=1, CurrentValue=70,
   Callback=function(v) FOV.Value = v end})
MainT:CreateSection("Crosshair")
MainT:CreateToggle({Name="Aktifkan Crosshair", CurrentValue=false,
   Callback=function(v) Crosshair.Enabled = v end})
MainT:CreateDropdown({Name="Style", Options={"Plus","Dot","Circle"},
   CurrentOption={"Plus"},
   Callback=function(O) Crosshair.Style = O[1] end})
MainT:CreateSlider({Name="Ukuran", Range={3,20}, Increment=1, CurrentValue=8,
   Callback=function(v) Crosshair.Size = v end})
MainT:CreateColorPicker({Name="Warna", Color=Color3.fromRGB(0,255,100),
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
   CurrentOption={"Killer"},
   Callback=function(O) GunAim.TargetMode = O[1] end})
AimT:CreateSlider({Name="Strength", Range={0.05,1}, Increment=0.05, CurrentValue=1,
   Callback=function(v) GunAim.Strength = v end})
AimT:CreateSlider({Name="FOV", Range={50,500}, Increment=10, CurrentValue=250,
   Callback=function(v) GunAim.FOV = v end})
AimT:CreateToggle({Name="Wallcheck", CurrentValue=true,
   Callback=function(v) GunAim.WallCheck = v end})

-- KILLER
KillerT:CreateSection("Auto Kill All ⚠️")
KillerT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v) AutoKill.Enabled = v end})
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
KillerT:CreateToggle({Name="Auto Carry", CurrentValue=false,
   Callback=function(v) AutoCarry.Enabled = v end})
KillerT:CreateSlider({Name="Carry Range", Range={5,30}, Increment=1, CurrentValue=10,
   Callback=function(v) AutoCarry.Range = v end})
KillerT:CreateButton({Name="Auto Hook Sekarang",
   Callback=function() AutoHookNearest() end})
KillerT:CreateSection("Auto Wiggle")
KillerT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v) AutoWiggle.Enabled = v end})
KillerT:CreateSlider({Name="Spam/detik", Range={1,20}, Increment=1, CurrentValue=5,
   Callback=function(v) AutoWiggle.Spam = v end})

-- ESP
EspT:CreateSection("Target")
EspT:CreateToggle({Name="Aktifkan ESP", CurrentValue=false,
   Callback=function(v) ESP.On = v end})
EspT:CreateToggle({Name="Survivor", CurrentValue=true,
   Callback=function(v) ESP.SV = v end})
EspT:CreateToggle({Name="Killer", CurrentValue=true,
   Callback=function(v) ESP.KL = v end})
EspT:CreateToggle({Name="Generator", CurrentValue=true,
   Callback=function(v) ESP.GN = v end})
EspT:CreateToggle({Name="SCP", CurrentValue=false,
   Callback=function(v) ESP.SCP = v end})
EspT:CreateSection("Ukuran")
EspT:CreateSlider({Name="Ukuran Text", Range={8,32}, Increment=1, CurrentValue=14,
   Callback=function(v) ESP.TextSize = v end})
EspT:CreateSlider({Name="Jarak Max", Range={50,2000}, Increment=50, CurrentValue=500,
   Callback=function(v) ESP.MaxDist = v end})
EspT:CreateSlider({Name="Update Rate", Range={0.1,2}, Increment=0.1, CurrentValue=0.6,
   Callback=function(v) ESP.UpdateRate = v end})
EspT:CreateSection("🎨 Warna Custom")
EspT:CreateColorPicker({Name="Warna Survivor", Color=Color3.fromRGB(0,255,0),
   Callback=function(c) ESP.SVc = c end})
EspT:CreateColorPicker({Name="Warna Killer", Color=Color3.fromRGB(255,0,0),
   Callback=function(c) ESP.KLc = c end})
EspT:CreateColorPicker({Name="Warna Generator", Color=Color3.fromRGB(255,105,180),
   Callback=function(c) ESP.GNc = c end})

-- GEN BOOST
GenT:CreateSection("Generator Boost")
GenT:CreateToggle({Name="Aktifkan Gen Boost", CurrentValue=false,
   Callback=function(v)
      GenBypass.Enabled = v
      if v then Rayfield:Notify({Title="Yarhub", Content="Gen Boost ON", Duration=2}) end
   end})
GenT:CreateSlider({Name="Jarak Boost (stud)", Range={4,20}, Increment=1, CurrentValue=8,
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

-- MOVEMENT
MoveT:CreateSection("Speed Boost")
MoveT:CreateToggle({Name="Aktifkan Speed", CurrentValue=false,
   Callback=function(v) ToggleSpeed(v) end})
MoveT:CreateSlider({Name="Speed (1-100)", Range={1,100}, Increment=1, CurrentValue=16,
   Callback=function(v) SpeedBoost.Value = v end})
MoveT:CreateSection("Jump Power")
MoveT:CreateToggle({Name="Aktifkan Jump", CurrentValue=false,
   Callback=function(v) JumpBoost.Enabled = v end})
MoveT:CreateSlider({Name="Jump Power", Range={50,200}, Increment=5, CurrentValue=50,
   Callback=function(v) JumpBoost.Value = v end})
MoveT:CreateSection("Noclip")
MoveT:CreateToggle({Name="Noclip", CurrentValue=false,
   Callback=function(v)
      Movement.Noclip = v
      if v then EnableNoclip() else DisableNoclip() end
   end})

-- MOONWALK
MwT:CreateSection("Kontrol")
MwT:CreateToggle({Name="Aktifkan Moonwalk", CurrentValue=false,
   Callback=function(v)
      setMoonwalk(v)
      Rayfield:Notify({Title="Yarhub", Content=v and "Moonwalk ON" or "Moonwalk OFF", Duration=2})
   end})
MwT:CreateToggle({Name="Tampilkan Tombol MW", CurrentValue=false,
   Callback=function(v)
      Moonwalk.ShowButton = v
      if v then createMoonwalkButton() else removeMoonwalkButton() end
   end})
MwT:CreateSlider({Name="Spam Speed", Range={1,50}, Increment=1, CurrentValue=30,
   Callback=function(v) Moonwalk.SpamSpeed = v end})
MwT:CreateSlider({Name="Intensity", Range={1,50}, Increment=1, CurrentValue=35,
   Callback=function(v) Moonwalk.Intensity = v end})
MwT:CreateSlider({Name="Slow Speed", Range={1,30}, Increment=1, CurrentValue=13,
   Callback=function(v) Moonwalk.SlowSpeed = v end})
MwT:CreateToggle({Name="Use Slow Speed", CurrentValue=true,
   Callback=function(v) Moonwalk.UseSlow = v end})
MwT:CreateParagraph({Title="Cara Pakai",
   Content="1. Toggle ON atau tekan V\n2. Tekan joystick/WASD\n3. Karakter gerak MUNDUR + goyang"})

-- AVATAR
AvatarT:CreateSection("Copy Avatar")
AvatarT:CreateInput({
   Name = "Username Target",
   PlaceholderText = "Masukkan username...",
   RemoveTextAfterFocusLost = false,
   Callback = function(text) _G.AvaTarget = text end,
})
AvatarT:CreateButton({Name="Copy Avatar",
   Callback=function()
      if _G.AvaTarget then CopyAvatar(_G.AvaTarget) end
   end})
AvatarT:CreateButton({Name="Reset Avatar",
   Callback=function() ResetAvatar() end})

-- INFO
InfoT:CreateSection("FPS/Ping")
InfoT:CreateToggle({Name="Tampilkan FPS/Ping", CurrentValue=true,
   Callback=function(v) FPSPing.Enabled = v end})
InfoT:CreateSection("Utility")
InfoT:CreateToggle({Name="Anti-AFK", CurrentValue=false,
   Callback=function(v) AntiAFK.Enabled = v end})
InfoT:CreateSection("Tentang")
InfoT:CreateParagraph({
   Title = "Yarhub Ultimate",
   Content = "Fitur Lengkap:\n" ..
             "- Fullbright + No Fog + FOV + Crosshair\n" ..
             "- Auto Skillcheck (2 Mode)\n" ..
             "- Auto Parry + Circle\n" ..
             "- Aimbot + Wallcheck\n" ..
             "- Auto Kill + Stalk + Carry + Hook + Wiggle\n" ..
             "- ESP + Warna Custom (Survivor + Killer + Generator + SCP)\n" ..
             "- Gen Boost (Auto Repair)\n" ..
             "- Speed Boost (1-100) + Jump + Noclip\n" ..
             "- Moonwalk + Keybind V\n" ..
             "- Copy Avatar + Reset\n" ..
             "- FPS/Ping + Anti-AFK\n\n" ..
             "Total 11 Tab\n" ..
             "Dibuat oleh: Yarhub"
})
