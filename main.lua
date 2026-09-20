-- ================================================================
-- YARHUB PANDU HUB STYLE
-- PART 1 of 6
-- ================================================================

-- LOAD OBSIDIAN
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- TEMA (Pandu Hub style - biru)
Library.Scheme.AccentColor     = Color3.fromRGB(90, 120, 210)
Library.Scheme.BackgroundColor = Color3.fromRGB(15, 15, 20)
Library.Scheme.MainColor       = Color3.fromRGB(55, 60, 80)
Library.Scheme.OutlineColor    = Color3.fromRGB(70, 85, 130)
Library.Scheme.FontColor       = Color3.fromRGB(200, 215, 255)

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local isMobile = UserInputService.TouchEnabled

-- STATE
_G.SkillOn = false
_G.Fullbright = false
_G.NoFog = false

-- HELPER
local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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

-- ==================== WINDOW (PANDU HUB STYLE) ====================
local Window = Library:CreateWindow({
    Title = "Yarhub",
    Footer = "Violence District - by Yarhub",
    Icon = 93349170559446,
    IconSize = UDim2.fromOffset(40, 40),
    CornerRadius = 20,
    NotifySide = "Right",
    ShowCustomCursor = true,
    ShowMobileButtons = false,
    ToggleKeybind = Enum.KeyCode.LeftControl,
    Size = UDim2.fromOffset(500, 420),
    EnableSidebarResize = false,
    EnableCompacting = true,
    SidebarCompacted = true,    -- ✅ SIDEBAR COMPACT (kayak Pandu Hub)
})

-- WATERMARK (Bisa di-drag)
local Watermark = Library:AddDraggableLabel("YARHUB")

local FPS = 0
local Frames = 0
local LastTick = tick()

RunService.RenderStepped:Connect(function()
    Frames = Frames + 1
    if tick() - LastTick >= 1 then
        FPS = Frames
        Frames = 0
        LastTick = tick()
        local Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        Watermark:SetText(string.format("YARHUB | FPS: %d | PING: %d ms", FPS, Ping))
    end
end)

-- ==================== TABS (PANDU HUB STYLE) ====================
local Tabs = {
    Visual  = Window:AddTab("Visual", "sparkles"),
    Combat  = Window:AddTab("Combat", "swords"),
    ESP     = Window:AddTab("ESP", "eye"),
    Protect = Window:AddTab("Perlindungan", "shield"),
    Utility = Window:AddTab("Utility", "wrench"),
    Settings = Window:AddTab("Settings", "settings"),
}

-- ==================== REMOTES ====================
local RepairEvent = ReplicatedStorage:FindFirstChild("Remotes")
    and ReplicatedStorage.Remotes:FindFirstChild("Generator")
    and ReplicatedStorage.Remotes.Generator:FindFirstChild("RepairEvent")
local WiggleEvent = ReplicatedStorage:FindFirstChild("Remotes")
    and ReplicatedStorage.Remotes:FindFirstChild("Carry")
    and ReplicatedStorage.Remotes.Carry:FindFirstChild("SelfUnHookEvent")
local AttackEvent = ReplicatedStorage:FindFirstChild("Remotes")
    and ReplicatedStorage.Remotes:FindFirstChild("Attacks")
    and ReplicatedStorage.Remotes.Attacks:FindFirstChild("BasicAttack")

print("[Yarhub] Part 1 loaded - Window + Tabs created")-- ================================================================
-- PART 2 of 6 - VISUAL
-- ================================================================

-- FULLBRIGHT + NO FOG
local OrigLight = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
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

-- FOV
local FOV = { Enabled = false, Value = 70, Default = Camera.FieldOfView }

RunService.RenderStepped:Connect(function()
    if FOV.Enabled and Camera and Camera.FieldOfView ~= FOV.Value then
        Camera.FieldOfView = FOV.Value
    end
end)

local function ToggleFOV(state)
    FOV.Enabled = state
    if not state and Camera then Camera.FieldOfView = FOV.Default end
end

-- CROSSHAIR
local Crosshair = {
    Enabled = false, Size = 8, Thickness = 2,
    Color = Color3.fromRGB(0, 255, 100), Style = "Plus",
}

local CHDrawings = {}
local CHCreated = false
local LastCHStyle = nil

local function ClearCH()
    for _, v in pairs(CHDrawings) do
        if v.Remove then v:Remove() end
    end
    CHDrawings = {}
    CHCreated = false
end

RunService.RenderStepped:Connect(function()
    if not Crosshair.Enabled then
        for _, v in pairs(CHDrawings) do
            if v then v.Visible = false end
        end
        return
    end
    if LastCHStyle ~= Crosshair.Style then
        ClearCH()
        LastCHStyle = Crosshair.Style
    end
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
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
        for _, line in pairs(CHDrawings) do
            line.Color = Crosshair.Color
            line.Thickness = Crosshair.Thickness
        end
        CHDrawings[1].From = center + Vector2.new(-Crosshair.Size, 0)
        CHDrawings[1].To   = center + Vector2.new(-2, 0)
        CHDrawings[2].From = center + Vector2.new(Crosshair.Size, 0)
        CHDrawings[2].To   = center + Vector2.new(2, 0)
        CHDrawings[3].From = center + Vector2.new(0, -Crosshair.Size)
        CHDrawings[3].To   = center + Vector2.new(0, -2)
        CHDrawings[4].From = center + Vector2.new(0, Crosshair.Size)
        CHDrawings[4].To   = center + Vector2.new(0, 2)
    elseif Crosshair.Style == "Dot" then
        local d = CHDrawings[1]
        d.Position = center; d.Radius = Crosshair.Size/2; d.Color = Crosshair.Color
    elseif Crosshair.Style == "Circle" then
        local c = CHDrawings[1]
        c.Position = center; c.Radius = Crosshair.Size
        c.Color = Crosshair.Color; c.Thickness = Crosshair.Thickness
    end
end)

-- CLEAN SKY + NO SCREEN EFFECTS + LOW GRAPHICS
local VisualPro = { CleanSky = false, NoScreenEffects = false, LowGraphics = false }

local ScreenEffectTypes = {"ColorCorrectionEffect", "DepthOfFieldEffect", "BlurEffect", "SunRaysEffect", "BloomEffect"}
local DisabledEffects = {}

local function ApplyCleanSky(state)
    if state then
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Sky") then v:Destroy() end
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

-- CAMERA ZOOM
local CameraZoom = {
    Enabled = false, MaxDistance = 2000, MinDistance = 0,
    DefaultMax = LocalPlayer.CameraMaxZoomDistance,
    DefaultMin = LocalPlayer.CameraMinZoomDistance,
}

task.spawn(function()
    while task.wait(0.3) do
        if CameraZoom.Enabled then
            LocalPlayer.CameraMaxZoomDistance = CameraZoom.MaxDistance
            LocalPlayer.CameraMinZoomDistance = CameraZoom.MinDistance
        end
    end
end)

local function ToggleCameraZoom(state)
    CameraZoom.Enabled = state
    if not state then
        LocalPlayer.CameraMaxZoomDistance = CameraZoom.DefaultMax
        LocalPlayer.CameraMinZoomDistance = CameraZoom.DefaultMin
    end
end

print("[Yarhub] Part 2 loaded - Visual functions ready")-- ================================================================
-- PART 3 of 6 - COMBAT
-- ================================================================

-- AUTO SKILLCHECK (PERFECT ONLY)
local Skill = { LastGoal = nil, Clicked = false, WasActive = false }
local SkillBusy = false

local function PressSkill()
    if isMobile then
        local btn = PlayerGui:FindFirstChild("check", true)
        if btn and btn:IsA("GuiObject") then
            local p, s = btn.AbsolutePosition, btn.AbsoluteSize
            local ins = GuiService:GetGuiInset()
            local x = p.X + s.X/2 + ins.X
            local y = p.Y + s.Y/2 + ins.Y
            pcall(function() VirtualInputManager:SendTouchEvent(8822, 0, x, y) end)
            task.wait(0.01)
            pcall(function() VirtualInputManager:SendTouchEvent(8822, 2, x, y) end)
        end
    else
        pcall(function() VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game) end)
        task.wait(0.01)
        pcall(function() VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game) end)
    end
end

local function GetCheck()
    for _, n in ipairs({"SkillCheckPromptGui", "SkillCheckPromptGui-con"}) do
        local g = PlayerGui:FindFirstChild(n, true)
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

RunService.RenderStepped:Connect(function()
    if _G.SkillOn then UpdateSkill() end
end)

-- ==================== AUTO PARRY (FIXED) ====================
local AutoParry = {
    Enabled = false,
    Range = 15,
    Debounce = 0.15,
    LastParry = 0,
    ShowCircle = true,
    ParryButtonPath = nil,
    DebugMode = false,
}

local function FindParryButton()
    local paths = {
        {"Survivor-mob", "Controls", "Gui-mob"},
        {"Survivor-mob", "Controls", "action", "check"},
        {"Survivor-mob", "Controls"},
        {"Controls", "Gui-mob"},
    }
    for _, path in ipairs(paths) do
        local current = PlayerGui
        local ok = true
        for _, seg in ipairs(path) do
            if current then current = current:FindFirstChild(seg)
            else ok = false; break end
        end
        if ok and current and current:IsA("GuiObject") then return current end
    end
    for _, obj in ipairs(PlayerGui:GetDescendants()) do
        if obj:IsA("GuiObject") and obj.Name:lower():find("parry") then return obj end
    end
    return nil
end

local function PressParry()
    if isMobile then
        local btn = AutoParry.ParryButtonPath or FindParryButton()
        if btn and btn:IsA("GuiObject") then
            local p, s = btn.AbsolutePosition, btn.AbsoluteSize
            local ins = GuiService:GetGuiInset()
            local x = p.X + s.X/2 + ins.X
            local y = p.Y + s.Y/2 + ins.Y
            pcall(function() VirtualInputManager:SendTouchEvent(8823, 0, x, y) end)
            task.wait(0.01)
            pcall(function() VirtualInputManager:SendTouchEvent(8823, 2, x, y) end)
        end
    else
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
        end)
    end
end

local function DoParry()
    local now = tick()
    if now - AutoParry.LastParry < AutoParry.Debounce then return end
    AutoParry.LastParry = now
    task.spawn(PressParry)
end

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

RunService.RenderStepped:Connect(function()
    local root = getRoot()
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
        ParryCircle.Color = Color3.fromRGB(90, 120, 210)
        ParryCircle.Transparency = 0.7
        ParryCircle.Parent = Workspace
    end
    local yOff = root.Size.Y / 2 + 1.5
    ParryCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOff, 0)) * CFrame.Angles(0, 0, math.rad(90))
    ParryCircle.Size = Vector3.new(0.2, AutoParry.Range * 2, AutoParry.Range * 2)
end)

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
            local myRoot = getRoot()
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
                if p ~= LocalPlayer and p.Character and IsKiller(p) then
                    HookKiller(p.Character)
                end
            end
        end
    end
end)

print("[Yarhub] Part 3 loaded - Combat ready")-- ================================================================
-- PART 4 of 6 - ESP + AIMBOT
-- ================================================================

-- ESP SYSTEM
local ESP = {
    On = false, SV = true, KL = true, GN = true,
    SVc = Color3.fromRGB(0, 255, 0),
    KLc = Color3.fromRGB(255, 0, 0),
    GNc = Color3.fromRGB(255, 105, 180),
    ShowName = true, ShowDist = true, ShowProg = true,
    FillT = 1, OutT = 0, TextSize = 14, MaxDist = 500, UpdateRate = 0.6,
}

local espFolder = Instance.new("Folder")
espFolder.Name = "Yarhub_ESP"
espFolder.Parent = CoreGui

local active = {}
local mapCache = nil

local function GetMap()
    if mapCache and mapCache.Parent then return mapCache end
    mapCache = Workspace:FindFirstChild("Map")
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
        local camPos = Camera.CFrame.Position
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
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
        CleanESP(used)
    end
end)

-- AIMBOT
local GunAim = {
    Enabled = false, Holding = false, TargetMode = "Killer",
    Strength = 1, Predict = true, PredictStrength = 0.12,
    FOV = 250, WallCheck = true,
}

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = false
    end
end)

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist

local function IsVisible(part)
    if not GunAim.WallCheck then return true end
    if not part then return false end
    RayParams.FilterDescendantsInstances = { LocalPlayer.Character }
    local origin = Camera.CFrame.Position
    local result = Workspace:Raycast(origin, part.Position - origin, RayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

local function GetGunTarget()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local closest, shortest = nil, GunAim.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team then
            local valid = false
            if GunAim.TargetMode == "Killer" and IsKiller(p) then valid = true
            elseif GunAim.TargetMode == "Survivor" and IsSurvivor(p) then valid = true end
            if valid then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 and IsVisible(hrp) then
                    local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
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

RunService.RenderStepped:Connect(function()
    if GunAim.Enabled and GunAim.Holding then
        local t = GetGunTarget()
        if t then
            local pos = t.Position
            if GunAim.Predict then
                pos = pos + (t.AssemblyLinearVelocity * GunAim.PredictStrength)
            end
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, pos), GunAim.Strength)
        end
    end
end)

print("[Yarhub] Part 4 loaded - ESP + Aimbot ready")-- ================================================================
-- PART 5 of 6 - PERLINDUNGAN
-- ================================================================

-- AUTO VAULT
local AutoVault = { Enabled = false, Range = 6, Cooldown = 0.5, LastVault = 0 }

task.spawn(function()
    while task.wait(0.2) do
        if not AutoVault.Enabled then continue end
        local char = LocalPlayer.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        local now = tick()
        if now - AutoVault.LastVault < AutoVault.Cooldown then continue end
        local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * AutoVault.Range)
        local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {char})
        if hit then
            local n = hit.Name:lower()
            local pN = hit.Parent and hit.Parent.Name:lower() or ""
            if n:find("window") or n:find("pallet") or pN:find("window") or pN:find("pallet") then
                AutoVault.LastVault = now
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                end)
            end
        end
    end
end)

-- ITEM ESP
local ItemESP = { Enabled = false, Color = Color3.fromRGB(255, 215, 0), MaxDist = 500,
    Keywords = {"medkit", "bandage", "toolbox", "med", "heal", "tool"} }
local ItemESPObjects = {}

local function ItemCreateESP(obj, key)
    if ItemESPObjects[key] then
        ItemESPObjects[key].FillColor = ItemESP.Color
        ItemESPObjects[key].OutlineColor = ItemESP.Color
        return
    end
    local h = Instance.new("Highlight")
    h.Adornee = obj
    h.FillColor = ItemESP.Color
    h.OutlineColor = ItemESP.Color
    h.FillTransparency = 0.7
    h.OutlineTransparency = 0.2
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = CoreGui
    ItemESPObjects[key] = h
end

local function ItemRemoveESP(key)
    if ItemESPObjects[key] then
        ItemESPObjects[key]:Destroy()
        ItemESPObjects[key] = nil
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if not ItemESP.Enabled then
            for key in pairs(ItemESPObjects) do ItemRemoveESP(key) end
            continue
        end
        local root = getRoot()
        if not root then continue end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") or obj:IsA("Model") then
                local n = obj.Name:lower()
                local isItem = false
                for _, kw in ipairs(ItemESP.Keywords) do
                    if n:find(kw) then isItem = true break end
                end
                if isItem then
                    local pos
                    if obj:IsA("Model") then pos = obj:GetPivot().Position
                    elseif obj:IsA("Tool") then
                        local h = obj:FindFirstChild("Handle")
                        if h then pos = h.Position end
                    elseif obj:IsA("BasePart") then pos = obj.Position end
                    if pos and (pos - root.Position).Magnitude <= ItemESP.MaxDist then
                        local target = obj
                        if obj:IsA("Tool") and obj:FindFirstChild("Handle") then target = obj.Handle end
                        ItemCreateESP(target, "I_" .. obj:GetDebugId())
                    end
                end
            end
        end
    end
end)

-- PLAYER ALERT
local PlayerAlert = { Enabled = false, Range = 40, Cooldown = 3, LastAlert = 0 }

local AlertSound = Instance.new("Sound")
AlertSound.SoundId = "rbxassetid://9046416788"
AlertSound.Volume = 2
AlertSound.Parent = game:GetService("SoundService")

task.spawn(function()
    while task.wait(0.5) do
        if not PlayerAlert.Enabled then continue end
        local root = getRoot()
        if not root then continue end
        local closestKiller = nil
        local shortest = math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and IsKiller(p) then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local d = (hrp.Position - root.Position).Magnitude
                    if d < shortest then shortest = d; closestKiller = p end
                end
            end
        end
        if closestKiller and shortest <= PlayerAlert.Range then
            local now = tick()
            if now - PlayerAlert.LastAlert >= PlayerAlert.Cooldown then
                PlayerAlert.LastAlert = now
                Library:Notify({
                    Title = "🚨 KILLER DEKAT!",
                    Content = string.format("%s - %.0f stud!", closestKiller.Name, shortest),
                    Duration = 3
                })
                pcall(function() AlertSound:Play() end)
            end
        end
    end
end)

-- FAST VAULT
local FastVault = { Enabled = false, Speed = 30, Original = 16 }

task.spawn(function()
    while task.wait(0.1) do
        if not FastVault.Enabled then continue end
        local char = LocalPlayer.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then continue end
        local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * 8)
        local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {char})
        local shouldSpeed = false        if hit then
            local n = hit.Name:lower()
            local pN = hit.Parent and hit.Parent.Name:lower() or ""
            if n:find("window") or n:find("pallet") or pN:find("window") or pN:find("pallet") then
                shouldSpeed = true
            end
        end
        if shouldSpeed and hum.WalkSpeed ~= FastVault.Speed then
            hum.WalkSpeed = FastVault.Speed
        elseif not shouldSpeed and hum.WalkSpeed == FastVault.Speed then
            hum.WalkSpeed = FastVault.Original
        end
    end
end)

-- ANTI-BLIND
local AntiBlind = { Enabled = false }
local DisabledBlinds = {}

local function ApplyAntiBlind(state)
    if state then
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then
                DisabledBlinds[v] = v.Enabled
                v.Enabled = false
            end
        end
        for _, v in pairs(Camera:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then
                DisabledBlinds[v] = v.Enabled
                v.Enabled = false
            end
        end
    else
        for obj, s in pairs(DisabledBlinds) do
            if obj and obj.Parent then obj.Enabled = s end
        end
        DisabledBlinds = {}
    end
end

task.spawn(function()
    while task.wait(1) do
        if AntiBlind.Enabled then ApplyAntiBlind(true) end
    end
end)

print("[Yarhub] Part 5 loaded - Perlindungan ready")-- ================================================================
-- PART 6 of 6 - UTILITY + UI FINAL
-- ================================================================

-- ==================== GEN BOOST ====================
local GenBypass = { Enabled = false, Cache = {}, CacheTimer = 0, Processed = {}, Range = 8 }

local function GB_GetAllGenerators()
    local now = tick()
    if now - GenBypass.CacheTimer < 5 then return GenBypass.Cache end
    GenBypass.Cache = {}
    GenBypass.CacheTimer = now
    local map = Workspace:FindFirstChild("Map")
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
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        GenBypass.Processed[genModel] = nil
        return
    end
    local orig = hrp.CFrame
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
            hrp.CFrame = orig
        end
    end)
    task.wait(0.1)
    pcall(function()
        if RepairEvent then RepairEvent:FireServer(targetPoint, false) end
    end)
end

local function GB_GetNearestPoint()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local bestPoint, bestDist = nil, math.huge
    for _, gen in pairs(GB_GetAllGenerators()) do
        for _, point in pairs(GB_GetPoints(gen)) do
            local d = (hrp.Position - point.Position).Magnitude
            if d < bestDist then bestDist = d; bestPoint = point end
        end
    end
    return bestPoint, bestDist
end

task.spawn(function()
    while task.wait(0.5) do
        if not GenBypass.Enabled then continue end
        local p, d = GB_GetNearestPoint()
        if p and d <= GenBypass.Range then GB_DoRepair(p) end
    end
end)

-- AUTO WIGGLE
local AutoWiggle = { Enabled = false, Spam = 8, Cooldown = 0.15, LastWiggle = 0 }

task.spawn(function()
    while task.wait(0.15) do
        if not AutoWiggle.Enabled then continue end
        local char = LocalPlayer.Character
        if not char then continue end
        local carried = false
        pcall(function()
            carried = (char:FindFirstChild("IsCarried") and char.IsCarried.Value)
                or (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)
        end)
        if carried then
            local now = tick()
            if now - AutoWiggle.LastWiggle >= AutoWiggle.Cooldown then
                AutoWiggle.LastWiggle = now
                for i = 1, AutoWiggle.Spam do
                    pcall(function()
                        if WiggleEvent then WiggleEvent:FireServer() end
                    end)
                end
            end
        end
    end
end)

-- ANTI-AFK
local AntiAFK = { Enabled = true }
LocalPlayer.Idled:Connect(function()
    if AntiAFK.Enabled then
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end
end)

-- ==================== UI (PANDU HUB STYLE) ====================

-- TAB VISUAL
local VisualBox = Tabs.Visual:AddLeftGroupbox("Render", "sun")
VisualBox:AddToggle("Fullbright", {
    Text = "Fullbright", Default = false,
    Callback = function(v) ToggleFullbright(v) end
})
VisualBox:AddToggle("NoFog", {
    Text = "No Fog", Default = false,
    Callback = function(v) ToggleNoFog(v) end
})
VisualBox:AddToggle("CleanSky", {
    Text = "Clean Sky", Default = false,
    Callback = function(v)
        VisualPro.CleanSky = v
        ApplyCleanSky(v)
    end
})
VisualBox:AddToggle("NoScreen", {
    Text = "No Screen Effects", Default = false,
    Callback = function(v)
        VisualPro.NoScreenEffects = v
        ApplyNoScreenEffects(v)
    end
})
VisualBox:AddToggle("LowGraphics", {
    Text = "Low Graphics ⚠️", Default = false,
    Callback = function(v)
        VisualPro.LowGraphics = v
        ApplyLowGraphics(v)
    end
})

local CamBox = Tabs.Visual:AddRightGroupbox("Camera", "camera")
CamBox:AddToggle("FOVToggle", {
    Text = "Aktifkan FOV", Default = false,
    Callback = function(v) ToggleFOV(v) end
})
CamBox:AddSlider("FOVValue", {
    Text = "FOV Value", Min = 50, Max = 120, Default = 70, Rounding = 0,
    Callback = function(v) FOV.Value = v end
})
CamBox:AddToggle("ZoomToggle", {
    Text = "Unlimited Zoom", Default = false,
    Callback = function(v) ToggleCameraZoom(v) end
})
CamBox:AddSlider("ZoomDist", {
    Text = "Max Zoom Distance", Min = 200, Max = 5000, Default = 2000, Rounding = 0,
    Callback = function(v) CameraZoom.MaxDistance = v end
})

local CHBox = Tabs.Visual:AddLeftGroupbox("Crosshair", "crosshair")
CHBox:AddToggle("CHToggle", {
    Text = "Aktifkan Crosshair", Default = false,
    Callback = function(v) Crosshair.Enabled = v end
})
CHBox:AddDropdown("CHStyle", {
    Text = "Style", Values = {"Plus", "Dot", "Circle"}, Default = "Plus",
    Callback = function(v) Crosshair.Style = v end
})
CHBox:AddSlider("CHSize", {
    Text = "Ukuran", Min = 3, Max = 30, Default = 8, Rounding = 0,
    Callback = function(v) Crosshair.Size = v end
})
CHBox:AddColorPicker("CHColor", {
    Text = "Warna", Default = Color3.fromRGB(0, 255, 100),
    Callback = function(c) Crosshair.Color = c end
})

-- TAB COMBAT
local SkillBox = Tabs.Combat:AddLeftGroupbox("Auto Skillcheck", "target")
SkillBox:AddToggle("SkillToggle", {
    Text = "Aktifkan Auto Skillcheck", Default = false,
    Callback = function(v)
        _G.SkillOn = v
        Library:Notify({Title = "Yarhub", Content = v and "Skillcheck ON" or "OFF", Duration = 2})
    end
})
SkillBox:AddLabel("Mode: Perfect (Falens)")

local ParryBox = Tabs.Combat:AddRightGroupbox("Auto Parry ⚔️", "sword")
ParryBox:AddToggle("ParryToggle", {
    Text = "Aktifkan Auto Parry", Default = false,
    Callback = function(v)
        AutoParry.Enabled = v
        if v then
            AutoParry.ParryButtonPath = FindParryButton()
            Library:Notify({
                Title = "Parry",
                Content = "ON! Tombol: " .. (AutoParry.ParryButtonPath and AutoParry.ParryButtonPath.Name or "auto-detect"),
                Duration = 3
            })
        end
    end
})
ParryBox:AddSlider("ParryRange", {
    Text = "Jarak Parry", Min = 5, Max = 30, Default = 15, Rounding = 0,
    Callback = function(v) AutoParry.Range = v end
})
ParryBox:AddSlider("ParryDelay", {
    Text = "Delay Parry", Min = 0.05, Max = 1, Default = 0.15, Rounding = 2,
    Callback = function(v) AutoParry.Debounce = v end
})
ParryBox:AddToggle("ParryCircle", {
    Text = "Lingkaran Visual", Default = true,
    Callback = function(v) AutoParry.ShowCircle = v end
})
ParryBox:AddToggle("ParryDebug", {
    Text = "Debug Mode", Default = false,
    Callback = function(v) AutoParry.DebugMode = v end
})
ParryBox:AddButton({
    Text = "🔄 Cari Tombol Parry Manual",
    Func = function()
        AutoParry.ParryButtonPath = FindParryButton()
        if AutoParry.ParryButtonPath then
            Library:Notify({Title = "Parry", Content = "Tombol: " .. AutoParry.ParryButtonPath:GetFullName(), Duration = 4})
        else
            Library:Notify({Title = "Parry", Content = "Tombol GAK ditemukan!", Duration = 4})
        end
    end
})

-- TAB ESP
local ESPBox = Tabs.ESP:AddLeftGroupbox("ESP Target", "eye")
ESPBox:AddToggle("ESPToggle", {
    Text = "Aktifkan ESP", Default = false,
    Callback = function(v) ESP.On = v end
})
ESPBox:AddToggle("ESPSV", {
    Text = "Survivor (Hijau)", Default = true,
    Callback = function(v) ESP.SV = v end
})
ESPBox:AddToggle("ESPKL", {
    Text = "Killer (Merah)", Default = true,
    Callback = function(v) ESP.KL = v end
})
ESPBox:AddToggle("ESPGN", {
    Text = "Generator (Pink)", Default = true,
    Callback = function(v) ESP.GN = v end
})

local ESPBox2 = Tabs.ESP:AddRightGroupbox("Setting ESP", "settings")
ESPBox2:AddSlider("ESPText", {
    Text = "Ukuran Text", Min = 8, Max = 32, Default = 14, Rounding = 0,
    Callback = function(v) ESP.TextSize = v end
})
ESPBox2:AddSlider("ESPDist", {
    Text = "Jarak Max", Min = 50, Max = 2000, Default = 500, Rounding = 0,
    Callback = function(v) ESP.MaxDist = v end
})

local ColorBox = Tabs.ESP:AddLeftGroupbox("🎨 Warna ESP", "palette")
ColorBox:AddColorPicker("ColorSV", {
    Text = "Warna Survivor", Default = Color3.fromRGB(0, 255, 0),
    Callback = function(c) ESP.SVc = c end
})
ColorBox:AddColorPicker("ColorKL", {
    Text = "Warna Killer", Default = Color3.fromRGB(255, 0, 0),
    Callback = function(c) ESP.KLc = c end
})
ColorBox:AddColorPicker("ColorGN", {
    Text = "Warna Generator", Default = Color3.fromRGB(255, 105, 180),
    Callback = function(c) ESP.GNc = c end
})

local AimBox = Tabs.ESP:AddRightGroupbox("Aimbot", "crosshair")
AimBox:AddToggle("AimToggle", {
    Text = "Aktifkan Aimbot", Default = false,
    Callback = function(v) GunAim.Enabled = v end
})
AimBox:AddDropdown("AimTarget", {
    Text = "Target", Values = {"Killer", "Survivor"}, Default = "Killer",
    Callback = function(v) GunAim.TargetMode = v end
})
AimBox:AddSlider("AimStrength", {
    Text = "Strength", Min = 0.05, Max = 1, Default = 1, Rounding = 2,
    Callback = function(v) GunAim.Strength = v end
})
AimBox:AddSlider("AimFOV", {
    Text = "FOV", Min = 50, Max = 500, Default = 250, Rounding = 0,
    Callback = function(v) GunAim.FOV = v end
})
AimBox:AddToggle("AimWall", {
    Text = "Wallcheck", Default = true,
    Callback = function(v) GunAim.WallCheck = v end
})

-- TAB PERLINDUNGAN
local VaultBox = Tabs.Protect:AddLeftGroupbox("Auto Vault", "footprints")
VaultBox:AddToggle("VaultToggle", {
    Text = "Aktifkan Auto Vault", Default = false,
    Callback = function(v) AutoVault.Enabled = v end
})
VaultBox:AddSlider("VaultRange", {
    Text = "Jarak Deteksi", Min = 3, Max = 15, Default = 6, Rounding = 0,
    Callback = function(v) AutoVault.Range = v end
})

local FastVBox = Tabs.Protect:AddRightGroupbox("Fast Vault", "zap")
FastVBox:AddToggle("FastVToggle", {
    Text = "Aktifkan Fast Vault", Default = false,
    Callback = function(v) FastVault.Enabled = v end
})
FastVBox:AddSlider("FastVSpeed", {
    Text = "Vault Speed", Min = 16, Max = 50, Default = 30, Rounding = 0,
    Callback = function(v) FastVault.Speed = v end
})

local ItemBox = Tabs.Protect:AddLeftGroupbox("Item ESP 📦", "package")
ItemBox:AddToggle("ItemToggle", {
    Text = "Aktifkan Item ESP", Default = false,
    Callback = function(v) ItemESP.Enabled = v end
})
ItemBox:AddColorPicker("ItemColor", {
    Text = "Warna Item", Default = Color3.fromRGB(255, 215, 0),
    Callback = function(c) ItemESP.Color = c end
})

local AlertBox = Tabs.Protect:AddRightGroupbox("Player Alert 🚨", "bell")
AlertBox:AddToggle("AlertToggle", {
    Text = "Aktifkan Alert", Default = false,
    Callback = function(v) PlayerAlert.Enabled = v end
})
AlertBox:AddSlider("AlertRange", {
    Text = "Jarak Alert", Min = 10, Max = 100, Default = 40, Rounding = 0,
    Callback = function(v) PlayerAlert.Range = v end
})

local BlindBox = Tabs.Protect:AddLeftGroupbox("Anti-Blind 🕶️", "eye-off")
BlindBox:AddToggle("BlindToggle", {
    Text = "Aktifkan Anti-Blind", Default = false,
    Callback = function(v)
        AntiBlind.Enabled = v
        ApplyAntiBlind(v)
    end
})

-- TAB UTILITY
local GenBox = Tabs.Utility:AddLeftGroupbox("Gen Boost", "zap")
GenBox:AddToggle("GenToggle", {
    Text = "Aktifkan Gen Boost", Default = false,
    Callback = function(v)
        GenBypass.Enabled = v
        Library:Notify({Title = "Yarhub", Content = v and "Gen Boost ON" or "OFF", Duration = 2})
    end
})
GenBox:AddSlider("GenRange", {
    Text = "Jarak Boost", Min = 4, Max = 20, Default = 8, Rounding = 0,
    Callback = function(v) GenBypass.Range = v end
})
GenBox:AddButton({
    Text = "Repair Terdekat Manual",
    Func = function()
        local p, d = GB_GetNearestPoint()
        if p and d <= GenBypass.Range then
            GB_DoRepair(p)
            Library:Notify({Title = "Yarhub", Content = "Repair dikirim!", Duration = 2})
        end
    end
})

local WiggleBox = Tabs.Utility:AddRightGroupbox("Auto Wiggle", "move")
WiggleBox:AddToggle("WiggleToggle", {
    Text = "Aktifkan Auto Wiggle", Default = false,
    Callback = function(v) AutoWiggle.Enabled = v end
})
WiggleBox:AddSlider("WiggleSpam", {
    Text = "Spam per Detik", Min = 1, Max = 20, Default = 8, Rounding = 0,
    Callback = function(v) AutoWiggle.Spam = v end
})

local UtilBox = Tabs.Utility:AddLeftGroupbox("Setting", "settings")
UtilBox:AddToggle("AFKToggle", {
    Text = "Anti-AFK", Default = true,
    Callback = function(v) AntiAFK.Enabled = v end
})

-- TAB SETTINGS (Theme + Save Manager)
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

-- NOTIFIKASI
Library:Notify("🎨 Yarhub Pandu Hub Style dimuat!", 5)
Library:Notify("⚔️ Kalau Auto Parry gak work - klik 'Cari Tombol Parry Manual'", 6)

print("[Yarhub] Part 6 loaded - UI FINAL ready")
print("[Yarhub] === SCRIPT COMPLETE ===")
