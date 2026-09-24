-- =========================================================
-- ROOORHUB ULTIMATE - BAGIAN 1/7 : CORE
-- =========================================================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local Cam = workspace.CurrentCamera

local C = {
    BG = Color3.fromRGB(10, 8, 18),
    PANEL = Color3.fromRGB(20, 15, 35),
    ACCENT = Color3.fromRGB(255, 50, 130),
    ACCENT2 = Color3.fromRGB(0, 255, 200),
    ACCENT3 = Color3.fromRGB(255, 200, 0),
    ACCENT4 = Color3.fromRGB(150, 80, 255),
    TEXT = Color3.fromRGB(245, 245, 255),
    DIM = Color3.fromRGB(130, 130, 160),
    DANGER = Color3.fromRGB(255, 70, 90),
    OK = Color3.fromRGB(0, 255, 150),
}

local S = {
    Aimlock = { on = false, hold = false, target = "Survivor", part = "Head", fov = 250, radius = 500, predict = 0.12, smooth = 0.5, visCheck = true },
    AutoAtk = { on = false, delay = 0.35, last = 0 },
    KillAll = { on = false, predict = 0.15, behind = 3 },
    AutoCarry = { on = false },
    AutoStalk = { on = false, range = 150 },
    MaskedPower = { power = "Cobra", powers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"} },
    Hitbox = { on = false, size = 15, transp = 0.7, color = Color3.fromRGB(255, 50, 130), onlySurv = true },
    AntiStun = { on = false },
    Parry = { on = false, dist = 12, face = 0.7, last = 0, cooldown = 0.2 },
    ParryCircle = { on = false, size = 12, color = Color3.fromRGB(255, 80, 80), transp = 0.7 },
    SkillCheck = { on = false, mode = "Perfect" },
    Wiggle = { on = false, spam = 5 },
    Flee = { on = false, dist = 50, last = 0, cooldown = 0.1 },
    Moonwalk = { on = false, spam = 30, intensity = 35, slow = 13, useSlow = true },
    GodMode = { on = false },
    ESP = {
        surv = false, killer = false, gen = false,
        name = true, dist = true, hp = false,
        radius = 100,
        survColor = Color3.fromRGB(60, 255, 120),
        killerColor = Color3.fromRGB(255, 60, 60),
        genColor = Color3.fromRGB(255, 170, 0),
        nameColor = Color3.fromRGB(255, 255, 255),
        nameSize = 12,
    },
    Visual = {
        fullbright = false, nofog = false, noshadow = false,
        customSky = false, skyId = "rbxassetid://159454299",
        contrast = false, contrastVal = 0.3, brightness = 0.15, saturation = 0.2,
        fire = false, fireType = "Red", fireSize = 5,
    },
    Move = {
        speedOn = false, speed = 17.6, origSpeed = 16,
        jumpOn = false, jump = 50, origJump = 50,
        noclip = false,
    },
    Avatar = { target = "", original = nil, uid = nil, blocky = true },
    FPS = { show = true },
    Buttons = { aimOn = false, moonOn = false, aimGui = nil, moonGui = nil, aimLocked = false, moonLocked = false },
}

-- Killer Anims (23 ID dari Fallens)
local KillerAnims = {}
for _, id in ipairs({
    "105374834496520","113255068724446","118907603246885","129784271201071",
    "117042998468241","122812055447896","78935059863801","74968262036854",
    "78432063483146","132817836308238","133963973694098","111920872708571",
    "80411309607666","98163597193511","82666958311998","110355011987939",
    "139369275981139","135002183282873","121216847022485","130593238885843",
    "117070354890871","106871536134254","138720291317243"
}) do KillerAnims["rbxassetid://"..id] = true end

local FireV = {
    Red = {c = Color3.fromRGB(255,60,0), s = Color3.fromRGB(255,200,0)},
    Blue = {c = Color3.fromRGB(0,150,255), s = Color3.fromRGB(0,255,255)},
    Green = {c = Color3.fromRGB(0,255,100), s = Color3.fromRGB(150,255,0)},
    Purple = {c = Color3.fromRGB(180,0,255), s = Color3.fromRGB(255,0,200)},
    Rainbow = {c = Color3.fromRGB(255,0,0), s = Color3.fromRGB(0,255,255)},
}

-- Remotes
local CarryEvent, HookEvent, AttackEvent
pcall(function()
    local r = ReplicatedStorage:WaitForChild("Remotes", 5)
    if r then
        local c = r:FindFirstChild("Carry")
        if c then
            CarryEvent = c:FindFirstChild("CarrySurvivorEvent")
            HookEvent = c:FindFirstChild("HookEvent")
        end
        local a = r:FindFirstChild("Attacks")
        if a then AttackEvent = a:FindFirstChild("BasicAttack") end
    end
end)

-- =========================================================
-- HELPERS
-- =========================================================
function getRoot()
    local ch = LP.Character
    return ch and ch:FindFirstChild("HumanoidRootPart")
end
function getHum()
    local ch = LP.Character
    return ch and ch:FindFirstChildOfClass("Humanoid")
end
function isDowned()
    local ch = LP.Character
    if not ch then return false end
    local h = ch:FindFirstChildOfClass("Humanoid")
    if not h then return false end
    return h.Health <= 0 or h.Health < 2
        or ch:GetAttribute("Downed") == true
        or ch:GetAttribute("IsDown") == true
        or ch:GetAttribute("Knocked") == true
end
function getNearest(team, maxD)
    local r = getRoot()
    if not r then return nil, math.huge end
    local best, d = nil, maxD or math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team and p.Team.Name == team then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and h and h.Health > 0 then
                local dist = (hrp.Position - r.Position).Magnitude
                if dist < d then d = dist; best = p.Character end
            end
        end
    end
    return best, d
end
function rnd(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = o
end
function strk(o, col, t, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or C.ACCENT
    s.Thickness = t or 1.5
    s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = o
    return s
end
function rainbow()
    return ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255,150,0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,200,255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(150,0,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,150)),
    }
end
function notify(text)
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 240, 0, 40)
    n.Position = UDim2.new(1, 260, 1, -60)
    n.BackgroundColor3 = C.PANEL
    n.BorderSizePixel = 0
    n.Parent = gui
    rnd(n, 10)
    strk(n, C.ACCENT2, 1.5)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = C.TEXT
    l.TextSize = 12
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = n
    TweenService:Create(n, TweenInfo.new(0.3), {Position = UDim2.new(1, -260, 1, -60)}):Play()
    task.delay(3, function()
        TweenService:Create(n, TweenInfo.new(0.3), {Position = UDim2.new(1, 260, 1, -60)}):Play()
        task.wait(0.3)
        n:Destroy()
    end)
end

print("✅ [BAGIAN 1/7] Core loaded")-- =========================================================
-- BAGIAN 2/7 : GUI + TAB SYSTEM
-- =========================================================

local gui = Instance.new("ScreenGui")
gui.Name = "RoooorHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PG

-- FLOAT BUTTON
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 42, 0, 42)
floatBtn.Position = UDim2.new(0, 15, 0.5, -21)
floatBtn.BackgroundColor3 = C.PANEL
floatBtn.Text = "⚡"
floatBtn.TextColor3 = C.ACCENT2
floatBtn.TextSize = 22
floatBtn.Font = Enum.Font.GothamBold
floatBtn.BorderSizePixel = 0
floatBtn.AutoButtonColor = false
floatBtn.Parent = gui
rnd(floatBtn, 21)
local fbStrk = strk(floatBtn, C.ACCENT, 2)

local fName = Instance.new("TextLabel")
fName.Size = UDim2.new(0, 100, 0, 20)
fName.Position = UDim2.new(0.5, -50, 1, 2)
fName.BackgroundTransparency = 1
fName.Text = "ROOORHUB"
fName.TextColor3 = Color3.new(1,1,1)
fName.TextSize = 12
fName.Font = Enum.Font.GothamBlack
fName.TextStrokeTransparency = 0
fName.TextStrokeColor3 = Color3.new(0,0,0)
fName.Parent = floatBtn
local fGrad = Instance.new("UIGradient")
fGrad.Color = rainbow()
fGrad.Parent = fName

task.spawn(function()
    while fName.Parent do
        for i = 0, 1, 0.02 do
            if not fName.Parent then break end
            fGrad.Rotation = i * 360
            task.wait(0.05)
        end
    end
end)

task.spawn(function()
    while floatBtn.Parent do
        task.wait(0.05)
        local hue = (tick() * 0.3) % 1
        fbStrk.Color = Color3.fromHSV(hue, 1, 1)
    end
end)

-- DRAG FLOAT
local dragF = false
local dragFStart, dragFPos
floatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragF = true
        dragFStart = input.Position
        dragFPos = floatBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragF = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragF and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragFStart
        floatBtn.Position = UDim2.new(dragFPos.X.Scale, dragFPos.X.Offset + d.X, dragFPos.Y.Scale, dragFPos.Y.Offset + d.Y)
    end
end)

-- MAIN WINDOW
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 480, 0, 360)
main.Position = UDim2.new(0.5, -240, 0.5, -180)
main.BackgroundColor3 = C.BG
main.BackgroundTransparency = 0.05
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui
rnd(main, 16)
local mainStrk = strk(main, C.ACCENT, 2, 0.2)

local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5028857084"
shadow.ImageColor3 = C.ACCENT
shadow.ImageTransparency = 0.5
shadow.ZIndex = -2
shadow.Parent = main

-- HEADER
local head = Instance.new("Frame")
head.Size = UDim2.new(1, 0, 0, 42)
head.BackgroundColor3 = C.PANEL
head.BackgroundTransparency = 0.1
head.BorderSizePixel = 0
head.Parent = main
rnd(head, 16)

local hPatch = Instance.new("Frame")
hPatch.Size = UDim2.new(1, 0, 0, 20)
hPatch.Position = UDim2.new(0, 0, 1, -20)
hPatch.BackgroundColor3 = C.PANEL
hPatch.BackgroundTransparency = 0.1
hPatch.BorderSizePixel = 0
hPatch.Parent = head

local nLine = Instance.new("Frame")
nLine.Size = UDim2.new(1, -30, 0, 2)
nLine.Position = UDim2.new(0, 15, 1, -1)
nLine.BackgroundColor3 = C.ACCENT
nLine.BorderSizePixel = 0
nLine.Parent = head
local nGrad = Instance.new("UIGradient")
nGrad.Color = rainbow()
nGrad.Parent = nLine
task.spawn(function()
    while nLine.Parent do
        for i = 0, 1, 0.02 do
            if not nLine.Parent then break end
            nGrad.Rotation = i * 360
            task.wait(0.05)
        end
    end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 45, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ ROOORHUB"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 15
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.new(0,0,0)
title.Parent = head
local tGrad = Instance.new("UIGradient")
tGrad.Color = rainbow()
tGrad.Parent = title
task.spawn(function()
    while title.Parent do
        for i = 0, 1, 0.02 do
            if not title.Parent then break end
            tGrad.Rotation = i * 360
            task.wait(0.05)
        end
    end
end)

local closeB = Instance.new("TextButton")
closeB.Size = UDim2.new(0, 24, 0, 24)
closeB.Position = UDim2.new(1, -32, 0.5, -12)
closeB.BackgroundColor3 = C.PANEL
closeB.Text = "✕"
closeB.TextColor3 = C.DANGER
closeB.TextSize = 14
closeB.Font = Enum.Font.GothamBold
closeB.BorderSizePixel = 0
closeB.AutoButtonColor = false
closeB.Parent = head
rnd(closeB, 6)
strk(closeB, C.DANGER, 1, 0.6)
closeB.MouseButton1Click:Connect(function()
    main.Visible = false
    floatBtn.Visible = true
end)

local minB = Instance.new("TextButton")
minB.Size = UDim2.new(0, 24, 0, 24)
minB.Position = UDim2.new(1, -60, 0.5, -12)
minB.BackgroundColor3 = C.PANEL
minB.Text = "—"
minB.TextColor3 = C.ACCENT2
minB.TextSize = 14
minB.Font = Enum.Font.GothamBold
minB.BorderSizePixel = 0
minB.AutoButtonColor = false
minB.Parent = head
rnd(minB, 6)
strk(minB, C.ACCENT2, 1, 0.6)
minB.MouseButton1Click:Connect(function()
    main.Visible = false
    floatBtn.Visible = true
end)

floatBtn.MouseButton1Click:Connect(function()
    floatBtn.Visible = false
    main.Visible = true
end)

-- SIDEBAR
local sb = Instance.new("Frame")
sb.Size = UDim2.new(0, 115, 1, -62)
sb.Position = UDim2.new(0, 10, 0, 52)
sb.BackgroundColor3 = C.PANEL
sb.BackgroundTransparency = 0.3
sb.BorderSizePixel = 0
sb.Parent = main
rnd(sb, 10)
strk(sb, C.ACCENT4, 1, 0.7)

local sbL = Instance.new("UIListLayout")
sbL.Padding = UDim.new(0, 4)
sbL.SortOrder = Enum.SortOrder.LayoutOrder
sbL.Parent = sb

local sbP = Instance.new("UIPadding")
sbP.PaddingTop = UDim.new(0, 6)
sbP.PaddingLeft = UDim.new(0, 5)
sbP.PaddingRight = UDim.new(0, 5)
sbP.Parent = sb

-- CONTENT
local ct = Instance.new("Frame")
ct.Size = UDim2.new(1, -145, 1, -62)
ct.Position = UDim2.new(0, 135, 0, 52)
ct.BackgroundColor3 = C.PANEL
ct.BackgroundTransparency = 0.3
ct.BorderSizePixel = 0
ct.Parent = main
rnd(ct, 10)
strk(ct, C.ACCENT2, 1, 0.7)

local cs = Instance.new("ScrollingFrame")
cs.Size = UDim2.new(1, -14, 1, -14)
cs.Position = UDim2.new(0, 7, 0, 7)
cs.BackgroundTransparency = 1
cs.BorderSizePixel = 0
cs.ScrollBarThickness = 3
cs.ScrollBarImageColor3 = C.ACCENT
cs.CanvasSize = UDim2.new(0, 0, 0, 0)
cs.AutomaticCanvasSize = Enum.AutomaticSize.Y
cs.Parent = ct

local csL = Instance.new("UIListLayout")
csL.Padding = UDim.new(0, 5)
csL.SortOrder = Enum.SortOrder.LayoutOrder
csL.Parent = cs

-- TAB SYSTEM
local activeTab = nil

function makeTab(name, icon, order, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = C.BG
    b.BackgroundTransparency = 1
    b.Text = ""
    b.BorderSizePixel = 0
    b.LayoutOrder = order
    b.AutoButtonColor = false
    b.Parent = sb
    rnd(b, 7)

    local ind = Instance.new("Frame")
    ind.Size = UDim2.new(0, 3, 0, 0)
    ind.Position = UDim2.new(0, 0, 0.5, 0)
    ind.AnchorPoint = Vector2.new(0, 0.5)
    ind.BackgroundColor3 = C.ACCENT
    ind.BorderSizePixel = 0
    ind.Parent = b
    rnd(ind, 2)

    local ico = Instance.new("TextLabel")
    ico.Size = UDim2.new(0, 20, 1, 0)
    ico.Position = UDim2.new(0, 8, 0, 0)
    ico.BackgroundTransparency = 1
    ico.Text = icon
    ico.TextColor3 = C.DIM
    ico.TextSize = 12
    ico.Font = Enum.Font.GothamBold
    ico.Parent = b

    local lblT = Instance.new("TextLabel")
    lblT.Size = UDim2.new(1, -32, 1, 0)
    lblT.Position = UDim2.new(0, 32, 0, 0)
    lblT.BackgroundTransparency = 1
    lblT.Text = string.upper(name)
    lblT.TextColor3 = C.DIM
    lblT.TextSize = 9
    lblT.Font = Enum.Font.GothamBlack
    lblT.TextXAlignment = Enum.TextXAlignment.Left
    lblT.Parent = b

    b.MouseButton1Click:Connect(function()
        if activeTab == b then return end
        if activeTab then
            activeTab.BackgroundTransparency = 1
            for _, c in pairs(activeTab:GetChildren()) do
                if c:IsA("TextLabel") then c.TextColor3 = C.DIM end
            end
            local oldInd = activeTab:FindFirstChildOfClass("Frame")
            if oldInd then oldInd.Size = UDim2.new(0, 3, 0, 0) end
        end
        activeTab = b
        b.BackgroundTransparency = 0.75
        ind.Size = UDim2.new(0, 3, 0, 18)
        for _, c in pairs(b:GetChildren()) do
            if c:IsA("TextLabel") then c.TextColor3 = C.TEXT end
        end
        for _, c in pairs(cs:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
        if callback then pcall(callback) end
    end)
end

-- DRAG WINDOW
local dragW = false
local dragWStart, dragWPos
head.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragW = true
        dragWStart = input.Position
        dragWPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragW = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragW and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragWStart
        main.Position = UDim2.new(dragWPos.X.Scale, dragWPos.X.Offset + d.X, dragWPos.Y.Scale, dragWPos.Y.Offset + d.Y)
    end
end)

print("✅ [BAGIAN 2/7] GUI + Tab System loaded")-- =========================================================
-- BAGIAN 3/7 : UI COMPONENTS
-- =========================================================

function sec(title, icon)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 22)
    f.BackgroundTransparency = 1
    f.Parent = cs

    local deco = Instance.new("Frame")
    deco.Size = UDim2.new(0, 3, 0, 14)
    deco.Position = UDim2.new(0, 4, 0.5, -7)
    deco.BackgroundColor3 = C.ACCENT
    deco.BorderSizePixel = 0
    deco.Parent = f
    rnd(deco, 2)
    local decoG = Instance.new("UIGradient")
    decoG.Color = rainbow()
    decoG.Rotation = 90
    decoG.Parent = deco

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -16, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = icon .. "  " .. string.upper(title)
    l.TextColor3 = C.ACCENT3
    l.TextSize = 10
    l.Font = Enum.Font.GothamBlack
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
end

function lbl(text, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -4, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or C.DIM
    l.TextSize = 9
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = cs
end

function tog(name, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 28)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.ACCENT, 1, 0.8)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TEXT
    l.TextSize = 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local t = Instance.new("Frame")
    t.Size = UDim2.new(0, 32, 0, 16)
    t.Position = UDim2.new(1, -42, 0.5, -8)
    t.BackgroundColor3 = def and C.ACCENT or C.PANEL
    t.BorderSizePixel = 0
    t.Parent = f
    rnd(t, 8)
    local tS = strk(t, def and C.ACCENT2 or C.DIM, 1, 0.5)

    local k = Instance.new("Frame")
    k.Size = UDim2.new(0, 12, 0, 12)
    k.Position = def and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    k.BackgroundColor3 = def and C.ACCENT2 or C.DIM
    k.BorderSizePixel = 0
    k.Parent = t
    rnd(k, 6)

    local state = def
    local cB = Instance.new("TextButton")
    cB.Size = UDim2.new(1, 0, 1, 0)
    cB.BackgroundTransparency = 1
    cB.Text = ""
    cB.Parent = t

    cB.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(k, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
            BackgroundColor3 = state and C.ACCENT2 or C.DIM
        }):Play()
        TweenService:Create(t, TweenInfo.new(0.15), {
            BackgroundColor3 = state and C.ACCENT or C.PANEL
        }):Play()
        tS.Color = state and C.ACCENT2 or C.DIM
        if cb then pcall(cb, state) end
    end)
end

function btn(name, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -4, 0, 28)
    b.BackgroundColor3 = C.BG
    b.BackgroundTransparency = 0.3
    b.Text = name
    b.TextColor3 = C.TEXT
    b.TextSize = 10
    b.Font = Enum.Font.GothamMedium
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = cs
    rnd(b, 8)
    strk(b, C.ACCENT2, 1, 0.7)

    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.1), {BackgroundTransparency = 0.5, BackgroundColor3 = C.ACCENT}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.1), {BackgroundTransparency = 0.3, BackgroundColor3 = C.BG}):Play()
    end)
    b.MouseButton1Click:Connect(function()
        if cb then pcall(cb) end
    end)
end

function sl(name, min, max, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 38)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.ACCENT, 1, 0.8)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 0, 16)
    l.Position = UDim2.new(0, 10, 0, 3)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TEXT
    l.TextSize = 9
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0, 35, 0, 16)
    v.Position = UDim2.new(1, -42, 0, 3)
    v.BackgroundTransparency = 1
    v.Text = tostring(def)
    v.TextColor3 = C.ACCENT2
    v.TextSize = 9
    v.Font = Enum.Font.GothamBold
    v.TextXAlignment = Enum.TextXAlignment.Right
    v.Parent = f

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -20, 0, 4)
    bg.Position = UDim2.new(0, 10, 1, -10)
    bg.BackgroundColor3 = C.PANEL
    bg.BorderSizePixel = 0
    bg.Parent = f
    rnd(bg, 2)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = C.ACCENT
    fill.BorderSizePixel = 0
    fill.Parent = bg
    rnd(fill, 2)
    local fGrad = Instance.new("UIGradient")
    fGrad.Color = ColorSequence.new(C.ACCENT, C.ACCENT2)
    fGrad.Parent = fill

    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 10, 0, 10)
    kn.Position = UDim2.new((def - min) / (max - min), -5, 0.5, -5)
    kn.BackgroundColor3 = C.TEXT
    kn.BorderSizePixel = 0
    kn.ZIndex = 2
    kn.Parent = bg
    rnd(kn, 5)
    strk(kn, C.ACCENT2, 2)

    local drag = false
    local function upd(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local val = math.floor((min + (max - min) * pos) * 100 + 0.5) / 100
        fill.Size = UDim2.new(pos, 0, 1, 0)
        kn.Position = UDim2.new(pos, -5, 0.5, -5)
        v.Text = tostring(val)
        if cb then pcall(cb, val) end
    end
    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true
            upd(input)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            upd(input)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
end

function drp(name, options, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 28)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.ACCENT, 1, 0.8)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.5, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TEXT
    l.TextSize = 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local cur = def or options[1]
    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0.5, -20, 1, 0)
    v.Position = UDim2.new(0.5, 0, 0, 0)
    v.BackgroundTransparency = 1
    v.Text = tostring(cur)
    v.TextColor3 = C.ACCENT2
    v.TextSize = 9
    v.Font = Enum.Font.GothamBold
    v.TextXAlignment = Enum.TextXAlignment.Right
    v.Parent = f

    local cB = Instance.new("TextButton")
    cB.Size = UDim2.new(1, 0, 1, 0)
    cB.BackgroundTransparency = 1
    cB.Text = ""
    cB.Parent = f

    local idx = 1
    for i, o in ipairs(options) do if o == cur then idx = i end end

    cB.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then idx = 1 end
        cur = options[idx]
        v.Text = tostring(cur)
        if cb then pcall(cb, cur) end
    end)
end

function cpk(name, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 28)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.ACCENT, 1, 0.8)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TEXT
    l.TextSize = 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local cB = Instance.new("TextButton")
    cB.Size = UDim2.new(0, 32, 0, 16)
    cB.Position = UDim2.new(1, -42, 0.5, -8)
    cB.BackgroundColor3 = def
    cB.Text = ""
    cB.BorderSizePixel = 0
    cB.Parent = f
    rnd(cB, 4)
    strk(cB, C.ACCENT2, 1.5)

    local presets = {
        Color3.fromRGB(255, 60, 60),
        Color3.fromRGB(255, 170, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(60, 255, 120),
        Color3.fromRGB(0, 200, 255),
        Color3.fromRGB(150, 80, 255),
        Color3.fromRGB(255, 50, 130),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(20, 20, 20),
    }
    local idx = 1

    cB.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #presets then idx = 1 end
        local c = presets[idx]
        cB.BackgroundColor3 = c
        if cb then pcall(cb, c) end
    end)
end

function inp(name, placeholder, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 28)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.3
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.ACCENT2, 1, 0.7)

    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(1, -16, 1, 0)
    tb.Position = UDim2.new(0, 8, 0, 0)
    tb.BackgroundTransparency = 1
    tb.Text = ""
    tb.PlaceholderText = placeholder or "..."
    tb.TextColor3 = C.TEXT
    tb.PlaceholderColor3 = C.DIM
    tb.TextSize = 10
    tb.Font = Enum.Font.GothamMedium
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.ClearTextOnFocus = false
    tb.Parent = f

    tb.FocusLost:Connect(function()
        if cb then pcall(cb, tb.Text) end
    end)
    return tb
end

print("✅ [BAGIAN 3/7] UI Components loaded")-- =========================================================
-- BAGIAN 4/7 : FITUR LOGIC PART 1
-- ESP, AIMLOCK, HITBOX, ANTISTUN, PARRY, SKILLCHECK, MOONWALK
-- =========================================================

-- =========================================================
-- ESP SYSTEM
-- =========================================================
local ESPObjs = {}
local ESPBbs = {}

function mkESP(obj, color)
    if not obj then return end
    if ESPObjs[obj] then
        ESPObjs[obj].FillColor = color
        ESPObjs[obj].OutlineColor = color
        return
    end
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.9
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = obj
    ESPObjs[obj] = h
end

function rmESP(obj)
    if ESPObjs[obj] then ESPObjs[obj]:Destroy(); ESPObjs[obj] = nil end
end

function mkESPBB(plr, char, root)
    if not char or not root then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    local dist = (head.Position - root.Position).Magnitude
    if dist > S.ESP.radius then
        if ESPBbs[char] then ESPBbs[char]:Destroy(); ESPBbs[char] = nil end
        return
    end

    local text = ""
    if S.ESP.name then text = text .. plr.Name .. "\n" end
    if S.ESP.dist then text = text .. string.format("[%.0f]", dist) .. "\n" end
    if S.ESP.hp then text = text .. string.format("HP: %.0f", hum.Health) end
    if text == "" then text = plr.Name end

    local tc = S.ESP.nameColor
    if plr.Team then
        if plr.Team.Name == "Killer" then tc = S.ESP.killerColor
        elseif plr.Team.Name == "Survivors" then tc = S.ESP.survColor end
    end

    local bb = ESPBbs[char]
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 130, 0, 50)
        bb.AlwaysOnTop = true
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.Adornee = head
        bb.Parent = char

        local lb = Instance.new("TextLabel")
        lb.Size = UDim2.new(1, 0, 1, 0)
        lb.BackgroundTransparency = 1
        lb.TextColor3 = tc
        lb.TextStrokeTransparency = 0
        lb.TextStrokeColor3 = Color3.new(0,0,0)
        lb.Font = Enum.Font.GothamBold
        lb.TextSize = S.ESP.nameSize
        lb.Text = text
        lb.Parent = bb
        ESPBbs[char] = bb
    else
        local lb = bb:FindFirstChildOfClass("TextLabel")
        if lb then
            lb.Text = text
            lb.TextColor3 = tc
            lb.TextSize = S.ESP.nameSize
        end
    end
end

function rmESPBB(char)
    if ESPBbs[char] then ESPBbs[char]:Destroy(); ESPBbs[char] = nil end
end

-- =========================================================
-- AIMLOCK
-- =========================================================
local function isVisible(part)
    if not part then return false end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {LP.Character}
    local dir = part.Position - Cam.CFrame.Position
    local res = workspace:Raycast(Cam.CFrame.Position, dir, rp)
    if not res then return true end
    return res.Instance:IsDescendantOf(part.Parent)
end

function getAimTarget()
    local center = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
    local closest, shortest = nil, S.Aimlock.fov
    local root = getRoot()
    if not root then return nil end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local valid = false
            if S.Aimlock.target == "Survivor" and plr.Team and plr.Team.Name == "Survivors" then valid = true end
            if S.Aimlock.target == "Killer" and plr.Team and plr.Team.Name == "Killer" then valid = true end
            if valid then
                local hrp = plr.Character:FindFirstChild(S.Aimlock.part)
                    or plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    if (hrp.Position - root.Position).Magnitude <= S.Aimlock.radius then
                        local pos, vis = Cam:WorldToViewportPoint(hrp.Position)
                        if vis then
                            local sd = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                            if sd < shortest then
                                if not S.Aimlock.visCheck or isVisible(hrp) then
                                    shortest = sd
                                    closest = hrp
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

function startAimlock()
    if _G.AimConn then return end
    _G.AimConn = RunService.RenderStepped:Connect(function()
        if not S.Aimlock.on or not S.Aimlock.hold then return end
        local t = getAimTarget()
        if not t then return end
        local pos = t.Position
        if S.Aimlock.predict > 0 then
            pos = pos + (t.AssemblyLinearVelocity * S.Aimlock.predict)
        end
        local cf = CFrame.new(Cam.CFrame.Position, pos)
        Cam.CFrame = Cam.CFrame:Lerp(cf, S.Aimlock.smooth)
    end)
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        S.Aimlock.hold = true
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        S.Aimlock.hold = false
    end
end)

-- =========================================================
-- HITBOX EXPANDER
-- =========================================================
local hbCache = {}

function applyHB(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local parts = {
        char:FindFirstChild("Head"),
        char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"),
        char:FindFirstChild("LowerTorso"),
        char:FindFirstChild("HumanoidRootPart"),
    }
    for _, p in pairs(parts) do
        if p and p:IsA("BasePart") then
            if not hbCache[p] then
                hbCache[p] = { Size = p.Size, Transparency = p.Transparency }
            end
            p.Size = Vector3.new(S.Hitbox.size, S.Hitbox.size, S.Hitbox.size)
            p.Transparency = S.Hitbox.transp
            p.CanCollide = false
            p.BrickColor = BrickColor.new(S.Hitbox.color)
            p.Material = Enum.Material.Neon
        end
    end
end

function resetHB(char)
    if not char then return end
    for _, p in pairs(char:GetChildren()) do
        if p:IsA("BasePart") and hbCache[p] then
            p.Size = hbCache[p].Size
            p.Transparency = hbCache[p].Transparency
            p.CanCollide = true
            p.Material = Enum.Material.Plastic
            hbCache[p] = nil
        end
    end
end

-- =========================================================
-- ANTI STUN
-- =========================================================
function applyAntiStun()
    if not S.AntiStun.on then return end
    local hum = getHum()
    if not hum then return end
    local st = hum:GetState()
    if st == Enum.HumanoidStateType.FallingDown
    or st == Enum.HumanoidStateType.Ragdoll
    or st == Enum.HumanoidStateType.Dead then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end

-- =========================================================
-- AUTO PARRY (PERSIS FALLENS)
-- =========================================================
_G.ParryActive = false
_G.HookedKillers = {}

local function pressRC()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
end

local function getParryBtn()
    local cur = PG
    for seg in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        cur = cur and cur:FindFirstChild(seg)
    end
    return cur
end

local function pressParry()
    if UIS.TouchEnabled then
        local b = getParryBtn()
        if b and b:IsA("GuiObject") then
            local p, sz = b.AbsolutePosition, b.AbsoluteSize
            local ins = GuiService:GetGuiInset()
            local x, y = p.X + sz.X/2 + ins.X, p.Y + sz.Y/2 + ins.Y
            VirtualInputManager:SendTouchEvent(8823, 0, x, y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8823, 2, x, y)
        end
    else
        pressRC()
    end
end

local function doParry()
    local now = tick()
    if now - S.Parry.last < S.Parry.cooldown then return end
    S.Parry.last = now
    _G.ParryActive = true
    if S.Moonwalk.on then S.Moonwalk.on = false end
    pressParry()
    task.delay(0.3, function() _G.ParryActive = false end)
end

local function isInRange(killer)
    local myRoot = getRoot()
    if not myRoot or not killer then return false end
    local eRoot = killer:FindFirstChild("HumanoidRootPart")
    if not eRoot then return false end
    return (eRoot.Position - myRoot.Position).Magnitude <= S.Parry.dist
end

local function isFacing(target)
    if S.Parry.face <= -1 then return true end
    local myRoot = getRoot()
    local eRoot = target and target:FindFirstChild("HumanoidRootPart")
    if not myRoot or not eRoot then return false end
    local eFwd = eRoot.CFrame.LookVector
    local dirToMe = (myRoot.Position - eRoot.Position).Unit
    return eFwd:Dot(dirToMe) >= S.Parry.face
end

local function hookKiller(char)
    if _G.HookedKillers[char] then return end
    _G.HookedKillers[char] = true
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not S.Parry.on then return end
        local anim = track.Animation
        if not anim then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end
        if KillerAnims["rbxassetid://"..id] then
            if not isInRange(char) then return end
            if not isFacing(char) then return end
            doParry()
        end
    end)
end

function scanKillers()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
            hookKiller(p.Character)
        end
    end
end

-- =========================================================
-- PARRY CIRCLE
-- =========================================================
function updParryCircle()
    local root = getRoot()
    if not S.ParryCircle.on or not root then
        if _G.ParryCirclePart then _G.ParryCirclePart:Destroy(); _G.ParryCirclePart = nil end
        return
    end
    if not _G.ParryCirclePart then
        local c = Instance.new("Part")
        c.Shape = Enum.PartType.Cylinder
        c.Anchored = true
        c.CanCollide = false
        c.Material = Enum.Material.Neon
        c.Name = "RoooorParryCircle"
        c.Parent = workspace
        _G.ParryCirclePart = c
    end
    local sz = S.ParryCircle.size * 2
    local c = _G.ParryCirclePart
    c.Size = Vector3.new(0.2, sz, sz)
    c.CFrame = CFrame.new(root.Position - Vector3.new(0, root.Size.Y/2 + 1.5, 0))
        * CFrame.Angles(0, 0, math.rad(90))
    c.Color = S.ParryCircle.color
    c.Transparency = S.ParryCircle.transp
end

-- =========================================================
-- AUTO SKILL CHECK (PERSIS FALLENS)
-- =========================================================
local skillConn = nil
local skillBusy = false

local function pressSpace()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local function getActionTarget()
    local cur = PG
    for seg in string.gmatch("Survivor-mob.Controls.action.check", "[^%.]+") do
        cur = cur and cur:FindFirstChild(seg)
    end
    return cur
end

local function triggerMobile()
    local b = getActionTarget()
    if b and b:IsA("GuiObject") then
        local p, sz = b.AbsolutePosition, b.AbsoluteSize
        local ins = GuiService:GetGuiInset()
        local x, y = p.X + sz.X/2 + ins.X, p.Y + sz.Y/2 + ins.Y
        pcall(function()
            VirtualInputManager:SendTouchEvent(8822, 0, x, y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8822, 2, x, y)
        end)
    end
end

function startSkillCheck()
    if skillConn then skillConn:Disconnect() end
    skillConn = RunService.RenderStepped:Connect(function()
        if not S.SkillCheck.on or skillBusy then return end
        local prompt = PG:FindFirstChild("SkillCheckPromptGui")
        if not prompt then return end
        local check = prompt:FindFirstChild("Check")
        if not check or not check.Visible then return end
        local line = check:FindFirstChild("Line")
        local goal = check:FindFirstChild("Goal")
        if not line or not goal then return end

        local lr = line.Rotation % 360
        local gr = goal.Rotation % 360

        if S.SkillCheck.mode == "Instant" then
            skillBusy = true
            task.spawn(function()
                if UIS.TouchEnabled then triggerMobile() else pressSpace() end
                task.wait(0.05)
                skillBusy = false
            end)
            return
        end

        local sr = (gr + 102) % 360
        local er = (gr + 116) % 360
        local ok = (sr > er and (lr >= sr or lr <= er)) or (lr >= sr and lr <= er)

        if ok then
            skillBusy = true
            task.spawn(function()
                if UIS.TouchEnabled then triggerMobile() else pressSpace() end
                task.wait(0.05)
                skillBusy = false
            end)
        end
    end)
end

-- =========================================================
-- MOONWALK (PERSIS FALLENS - konsisten lobby & ingame)
-- =========================================================
_G.MoonConn = nil

function startMoonwalk()
    if _G.MoonConn then return end
    _G.MoonConn = RunService.RenderStepped:Connect(function()
        if not S.Moonwalk.on or _G.ParryActive or isDowned() then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not hum or not hrp or not cam then return end

        if S.Moonwalk.useSlow and hum.WalkSpeed ~= S.Moonwalk.slow then
            hum.WalkSpeed = S.Moonwalk.slow
        end

        local look = cam.CFrame.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude > 0 then
            flat = flat.Unit
            local baseCF = CFrame.new(hrp.Position, hrp.Position + flat)
            local angle = math.sin(tick() * S.Moonwalk.spam) * S.Moonwalk.intensity
            hrp.CFrame = baseCF * CFrame.Angles(0, math.rad(angle), 0)
            hum:Move(Vector3.new(0, 0, 1), true)
        end
    end)
end

function stopMoonwalk()
    if _G.MoonConn then
        _G.MoonConn:Disconnect()
        _G.MoonConn = nil
    end
end

print("✅ [BAGIAN 4/7] Fitur Logic 1 loaded")-- =========================================================
-- BAGIAN 5/7 : FITUR LOGIC PART 2
-- WIGGLE, FLEE, CARRY, STALK, FIRE, VISUAL, AVATAR, TELEPORT, CONFIG
-- =========================================================

-- =========================================================
-- AUTO WIGGLE
-- =========================================================
function runWiggle()
    if not S.Wiggle.on then return end
    local char = LP.Character
    if not char then return end
    local carried = (char:FindFirstChild("IsCarried") and char.IsCarried.Value)
        or (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)
    if not carried then return end
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return end
    local carry = remotes:FindFirstChild("Carry")
    if not carry then return end
    local ev = carry:FindFirstChild("SelfUnHookEvent")
    if not ev then return end
    for i = 1, S.Wiggle.spam do ev:FireServer() end
end

-- =========================================================
-- AUTO FLEE
-- =========================================================
function GetFarthestGenPoint(killerRoot)
    if not killerRoot then return nil end
    local bestPoint, far = nil, 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.match(obj.Name, "^GeneratorPoint%d+$") then
            local d = (obj.Position - killerRoot.Position).Magnitude
            if d > far then far = d; bestPoint = obj end
        end
    end
    return bestPoint
end

function runFlee()
    if not S.Flee.on then return end
    local root = getRoot()
    if not root then return end
    local killer, dist = getNearest("Killer", 999)
    if killer and dist <= S.Flee.dist and tick() - S.Flee.last > S.Flee.cooldown then
        local killerRoot = killer:FindFirstChild("HumanoidRootPart")
        if killerRoot then
            local point = GetFarthestGenPoint(killerRoot)
            if point then
                S.Flee.last = tick()
                root.CFrame = point.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end

-- =========================================================
-- AUTO CARRY + HOOK
-- =========================================================
function GetDowned()
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

function GetHook()
    local root = getRoot()
    if not root then return nil end
    local bestHook, sd = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "HookPoint" and obj:IsA("BasePart") then
            local dist = (obj.Position - root.Position).Magnitude
            if dist < sd and dist < 400 then sd = dist; bestHook = obj end
        end
    end
    return bestHook
end

function runCarry()
    if not S.AutoCarry.on or _G.CarryBusy then return end
    _G.CarryBusy = true
    task.spawn(function()
        local target = GetDowned()
        local root = getRoot()
        if target and root then
            local tRoot = target:FindFirstChild("HumanoidRootPart")
            if tRoot then
                root.CFrame = tRoot.CFrame * CFrame.new(0, 3, -2)
                task.wait(0.4)
                if CarryEvent then
                    for i = 1, 4 do
                        pcall(function() CarryEvent:FireServer(target) end)
                        task.wait(0.2)
                    end
                end
                task.wait(0.6)
                local hook = GetHook()
                if hook then
                    root.CFrame = hook.CFrame * CFrame.new(0, 4, -3)
                    task.wait(0.7)
                    if HookEvent then
                        for i = 1, 6 do
                            pcall(function() HookEvent:FireServer(hook) end)
                            task.wait(0.15)
                        end
                    end
                end
            end
        end
        task.wait(2)
        _G.CarryBusy = false
    end)
end

-- =========================================================
-- AUTO STALK
-- =========================================================
function GetClosestSurvForStalk()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist <= S.AutoStalk.range and dist < shortest then
                    shortest = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

function runStalk()
    if not S.AutoStalk.on then return end
    local target = GetClosestSurvForStalk()
    if not target then return end
    local ev = ReplicatedStorage:FindFirstChild("Remotes", true)
        and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
        and ReplicatedStorage.Remotes.Killers:FindFirstChild("Stalker", true)
        and ReplicatedStorage.Remotes.Killers.Stalker:FindFirstChild("StartStalking")
    if ev then
        pcall(function() ev:FireServer(target) end)
    end
end

-- =========================================================
-- FIRE EFFECT (5 VARIAN)
-- =========================================================
function applyFire()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not S.Visual.fire then
        if hrp:FindFirstChild("RoooorFire") then hrp.RoooorFire:Destroy() end
        return
    end
    local v = FireV[S.Visual.fireType] or FireV.Red
    local fire = hrp:FindFirstChild("RoooorFire")
    if not fire then
        fire = Instance.new("Fire")
        fire.Name = "RoooorFire"
        fire.Heat = 10
        fire.Parent = hrp
    end
    fire.Size = S.Visual.fireSize
    fire.Color = v.c
    fire.SecondaryColor = v.s
end

-- Rainbow fire animation
task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        if S.Visual.fire and S.Visual.fireType == "Rainbow" then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local fire = hrp and hrp:FindFirstChild("RoooorFire")
            if fire then
                local t = tick()
                fire.Color = Color3.fromHSV((t * 0.5) % 1, 1, 1)
                fire.SecondaryColor = Color3.fromHSV(((t * 0.5) + 0.5) % 1, 1, 1)
            end
        end
    end
end)

-- =========================================================
-- VISUAL (Fullbright, No Fog, Sky, Contrast)
-- =========================================================
local origL = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows,
}
local contrastEffect = nil

function applyVisual()
    if S.Visual.fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = origL.Brightness
        Lighting.ClockTime = origL.ClockTime
        Lighting.Ambient = origL.Ambient
        Lighting.OutdoorAmbient = origL.OutdoorAmbient
        Lighting.GlobalShadows = origL.GlobalShadows
    end

    if S.Visual.nofog then
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
    else
        Lighting.FogEnd = origL.FogEnd
        Lighting.FogStart = origL.FogStart
    end

    if S.Visual.noshadow then
        Lighting.GlobalShadows = false
    end

    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end
    if S.Visual.customSky then
        local sky = Instance.new("Sky")
        sky.SkyboxBk = S.Visual.skyId
        sky.SkyboxDn = S.Visual.skyId
        sky.SkyboxFt = S.Visual.skyId
        sky.SkyboxLf = S.Visual.skyId
        sky.SkyboxRt = S.Visual.skyId
        sky.SkyboxUp = S.Visual.skyId
        sky.Parent = Lighting
    end

    if S.Visual.contrast then
        if not contrastEffect then
            contrastEffect = Instance.new("ColorCorrectionEffect")
            contrastEffect.Name = "RoooorContrast"
            contrastEffect.Parent = Lighting
        end
        contrastEffect.Contrast = S.Visual.contrastVal
        contrastEffect.Brightness = S.Visual.brightness
        contrastEffect.Saturation = S.Visual.saturation
    else
        if contrastEffect then
            contrastEffect:Destroy()
            contrastEffect = nil
        end
    end
end

-- =========================================================
-- AVATAR STEALER (PERSIS FALLENS)
-- =========================================================
function saveAvatar()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then S.Avatar.original = hum:GetAppliedDescription() end
end

function applyBlocky(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local d = Instance.new("HumanoidDescription")
    d.BodyTypeScale = 1
    d.DepthScale = 1
    d.HeadScale = 1
    d.HeightScale = 1
    d.ProportionScale = 0
    d.WidthScale = 1
    hum:ApplyDescriptionClientServer(d)
end

function removeAcc(char)
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("Accessory") or v:IsA("Clothing") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
            v:Destroy()
        end
    end
end

function copyAvatar(username)
    if not username or username == "" then return end
    saveAvatar()
    local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(username) end)
    if not ok then
        notify("Username gak ditemukan!")
        return
    end
    S.Avatar.uid = uid
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    task.spawn(function()
        local d = Players:GetHumanoidDescriptionFromUserId(uid)
        if S.Avatar.blocky then
            applyBlocky(char)
            task.wait(0.3)
        end
        removeAcc(char)
        task.wait(0.2)
        hum:ApplyDescriptionClientServer(d)
        notify("Avatar dicopy!")
    end)
end

function resetAvatar()
    if not S.Avatar.original then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        removeAcc(char)
        hum:ApplyDescriptionClientServer(S.Avatar.original)
        S.Avatar.uid = nil
        notify("Avatar direset!")
    end
end

LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    if S.Avatar.uid then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local d = Players:GetHumanoidDescriptionFromUserId(S.Avatar.uid)
            if S.Avatar.blocky then applyBlocky(char) end
            removeAcc(char)
            hum:ApplyDescriptionClientServer(d)
        end
    end
end)

-- =========================================================
-- TELEPORT
-- =========================================================
function tpPlayer(name)
    local t = Players:FindFirstChild(name)
    if t and t.Character and LP.Character then
        local tHRP = t.Character:FindFirstChild("HumanoidRootPart")
        local mHRP = LP.Character:FindFirstChild("HumanoidRootPart")
        if tHRP and mHRP then
            mHRP.CFrame = tHRP.CFrame + Vector3.new(0, 3, 0)
        end
    end
end

function tpObj(objName)
    local root = getRoot()
    if not root then return end
    local closest, sd = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(objName:lower()) then
            local d = (obj.Position - root.Position).Magnitude
            if d < sd then sd = d; closest = obj end
        end
    end
    if closest then
        root.CFrame = closest.CFrame + Vector3.new(0, 5, 0)
    end
end

-- =========================================================
-- AUTO SAVE CONFIG
-- =========================================================
function saveCfg()
    local data = {
        Aimlock = S.Aimlock.on,
        Parry = S.Parry.on,
        SkillCheck = S.SkillCheck.on,
        Wiggle = S.Wiggle.on,
        Flee = S.Flee.on,
        Moonwalk = S.Moonwalk.on,
        GodMode = S.GodMode.on,
        AutoAtk = S.AutoAtk.on,
        KillAll = S.KillAll.on,
        AutoCarry = S.AutoCarry.on,
        AutoStalk = S.AutoStalk.on,
        Hitbox = S.Hitbox.on,
        AntiStun = S.AntiStun.on,
        ESP = {
            surv = S.ESP.surv,
            killer = S.ESP.killer,
            gen = S.ESP.gen,
            name = S.ESP.name,
            dist = S.ESP.dist,
            hp = S.ESP.hp,
            radius = S.ESP.radius,
        },
        Visual = {
            fullbright = S.Visual.fullbright,
            nofog = S.Visual.nofog,
            fire = S.Visual.fire,
            fireType = S.Visual.fireType,
        },
        Move = {
            speedOn = S.Move.speedOn,
            jumpOn = S.Move.jumpOn,
            noclip = S.Move.noclip,
        },
    }
    pcall(function()
        if writefile then
            writefile("RoooorHub_Cfg.json", HttpService:JSONEncode(data))
        end
    end)
end

function loadCfg()
    pcall(function()
        if isfile and isfile("RoooorHub_Cfg.json") then
            local d = HttpService:JSONDecode(readfile("RoooorHub_Cfg.json"))
            if d.Aimlock ~= nil then S.Aimlock.on = d.Aimlock end
            if d.Parry ~= nil then S.Parry.on = d.Parry end
            if d.SkillCheck ~= nil then S.SkillCheck.on = d.SkillCheck end
            if d.Wiggle ~= nil then S.Wiggle.on = d.Wiggle end
            if d.Flee ~= nil then S.Flee.on = d.Flee end
            if d.Moonwalk ~= nil then S.Moonwalk.on = d.Moonwalk end
            if d.GodMode ~= nil then S.GodMode.on = d.GodMode end
            if d.AutoAtk ~= nil then S.AutoAtk.on = d.AutoAtk end
            if d.KillAll ~= nil then S.KillAll.on = d.KillAll end
            if d.AutoCarry ~= nil then S.AutoCarry.on = d.AutoCarry end
            if d.AutoStalk ~= nil then S.AutoStalk.on = d.AutoStalk end
            if d.Hitbox ~= nil then S.Hitbox.on = d.Hitbox end
            if d.AntiStun ~= nil then S.AntiStun.on = d.AntiStun end
            if d.ESP then
                S.ESP.surv = d.ESP.surv or false
                S.ESP.killer = d.ESP.killer or false
                S.ESP.gen = d.ESP.gen or false
                S.ESP.name = d.ESP.name ~= false
                S.ESP.dist = d.ESP.dist ~= false
                S.ESP.hp = d.ESP.hp or false
                S.ESP.radius = d.ESP.radius or 100
            end
            if d.Visual then
                S.Visual.fullbright = d.Visual.fullbright or false
                S.Visual.nofog = d.Visual.nofog or false
                S.Visual.fire = d.Visual.fire or false
                S.Visual.fireType = d.Visual.fireType or "Red"
            end
            if d.Move then
                S.Move.speedOn = d.Move.speedOn or false
                S.Move.jumpOn = d.Move.jumpOn or false
                S.Move.noclip = d.Move.noclip or false
            end
        end
    end)
end

task.spawn(function()
    task.wait(1)
    loadCfg()
end)
task.spawn(function()
    while gui.Parent do
        task.wait(10)
        saveCfg()
    end
end)
game:BindToClose(function() saveCfg() end)

print("✅ [BAGIAN 5/7] Fitur Logic 2 loaded")-- =========================================================
-- BAGIAN 6/7 : ISI TAB
-- =========================================================

-- =========================================================
-- TAB 1 : INFO
-- =========================================================
local tabInfo = makeTab("Info", "ℹ️", 1, function()
    sec("Script Info", "📋")
    lbl("RoooorHub Ultimate", C.ACCENT2)
    lbl("Status: Active", C.OK)
    lbl("Dev: Roooor", C.TEXT)

    sec("FPS/Ping", "🌊")
    tog("Show FPS/Ping", true, function(s) S.FPS.show = s end)

    sec("Floating Buttons", "🔘")
    tog("Show Aimlock Button", false, function(s) if s then mkAimBtn() else rmAimBtn() end end)
    tog("Show Moonwalk Button", false, function(s) if s then mkMoonBtn() else rmMoonBtn() end end)
end)

-- =========================================================
-- TAB 2 : KILLER
-- =========================================================
local tabKiller = makeTab("Killer", "🔪", 2, function()
    sec("Aimlock", "🎯")
    tog("Enable Aimlock", false, function(s)
        S.Aimlock.on = s
        if s then startAimlock() end
    end)
    drp("Target", {"Survivor", "Killer"}, "Survivor", function(v) S.Aimlock.target = v end)
    drp("Aim Part", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(v) S.Aimlock.part = v end)
    sl("FOV", 50, 1000, 250, function(v) S.Aimlock.fov = v end)
    sl("Radius", 50, 1000, 500, function(v) S.Aimlock.radius = v end)
    sl("Prediction", 0, 1, 0.12, function(v) S.Aimlock.predict = v end)
    sl("Smoothness", 0.05, 1, 0.5, function(v) S.Aimlock.smooth = v end)
    tog("Visibility Check", true, function(s) S.Aimlock.visCheck = s end)

    sec("Auto Attack", "⚔️")
    tog("Auto Spam Attack", false, function(s) S.AutoAtk.on = s end)
    sl("Attack Delay", 0.1, 2, 0.35, function(v) S.AutoAtk.delay = v end)
    tog("Auto Kill All", false, function(s) S.KillAll.on = s end)
    sl("Kill Predict", 0, 1, 0.15, function(v) S.KillAll.predict = v end)
    sl("Behind Offset", 1, 10, 3, function(v) S.KillAll.behind = v end)

    sec("Auto Carry + Hook", "🏃")
    tog("Auto Carry Downed", false, function(s) S.AutoCarry.on = s end)

    sec("Auto Stalk", "👁️")
    tog("Auto Stalk", false, function(s) S.AutoStalk.on = s end)
    sl("Stalk Range", 50, 500, 150, function(v) S.AutoStalk.range = v end)

    sec("Masked Power", "🎭")
    drp("Select Power", S.MaskedPower.powers, "Cobra", function(v) S.MaskedPower.power = v end)
    btn("⚡ Activate Power", function()
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        local k = r and r:FindFirstChild("Killers")
        local m = k and k:FindFirstChild("Masked")
        local e = m and m:FindFirstChild("Activatepower")
        if e then e:FireServer(S.MaskedPower.power) end
    end)
    btn("❌ Deactivate Power", function()
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        local k = r and r:FindFirstChild("Killers")
        local m = k and k:FindFirstChild("Masked")
        local e = m and m:FindFirstChild("Deactivatepower")
        if e then e:FireServer() end
    end)

    sec("Hitbox Expander", "📦")
    tog("Enable Hitbox", false, function(s)
        S.Hitbox.on = s
        if not s then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then resetHB(p.Character) end
            end
        end
    end)
    sl("Hitbox Size", 3, 30, 15, function(v) S.Hitbox.size = v end)
    sl("Transparency", 0, 1, 0.7, function(v) S.Hitbox.transp = v end)
    cpk("Hitbox Color", S.Hitbox.color, function(c) S.Hitbox.color = c end)
    tog("Only Survivors", true, function(s) S.Hitbox.onlySurv = s end)

    sec("Anti Stun", "💪")
    tog("Anti Stun", false, function(s) S.AntiStun.on = s end)
end)

-- =========================================================
-- TAB 3 : SURVIVOR
-- =========================================================
local tabSurv = makeTab("Survivor", "🏃", 3, function()
    sec("Auto Parry", "🛡️")
    tog("Enable Auto Parry", false, function(s)
        S.Parry.on = s
        if s then scanKillers() end
    end)
    sl("Parry Distance", 5, 25, 12, function(v) S.Parry.dist = v end)
    sl("Cooldown", 0.1, 1, 0.2, function(v) S.Parry.cooldown = v end)
    sl("Face Sensitivity", -1, 1, 0.7, function(v) S.Parry.face = v end)

    sec("Parry Circle", "🔵")
    tog("Show Parry Circle", false, function(s) S.ParryCircle.on = s end)
    sl("Circle Size", 5, 50, 12, function(v) S.ParryCircle.size = v end)
    cpk("Circle Color", S.ParryCircle.color, function(c) S.ParryCircle.color = c end)
    sl("Transparency", 0, 1, 0.7, function(v) S.ParryCircle.transp = v end)

    sec("Auto Skill Check", "🎯")
    tog("Enable Skill Check", false, function(s)
        S.SkillCheck.on = s
        if s then startSkillCheck() end
    end)
    drp("Mode", {"Perfect", "Instant"}, "Perfect", function(v) S.SkillCheck.mode = v end)

    sec("Auto Wiggle", "🎯")
    tog("Auto Wiggle", false, function(s) S.Wiggle.on = s end)
    sl("Wiggle Spam", 1, 10, 5, function(v) S.Wiggle.spam = v end)

    sec("Auto Flee Killer", "🏃")
    tog("Auto Flee", false, function(s) S.Flee.on = s end)
    sl("Detect Distance", 10, 200, 50, function(v) S.Flee.dist = v end)
    sl("Cooldown", 0.1, 1, 0.1, function(v) S.Flee.cooldown = v end)

    sec("Moonwalk", "🌙")
    tog("Enable Moonwalk", false, function(s)
        S.Moonwalk.on = s
        if s then startMoonwalk() else stopMoonwalk() end
    end)
    sl("Spam Speed", 1, 100, 30, function(v) S.Moonwalk.spam = v end)
    sl("Intensity", 1, 90, 35, function(v) S.Moonwalk.intensity = v end)
    sl("Slow Speed", 5, 30, 13, function(v) S.Moonwalk.slow = v end)
    tog("Use Slow Speed", true, function(s) S.Moonwalk.useSlow = s end)

    sec("God Mode", "🛡️")
    tog("Anti Knockdown", false, function(s) S.GodMode.on = s end)
end)

-- =========================================================
-- TAB 4 : ESP
-- =========================================================
local tabESP = makeTab("ESP", "👁️", 4, function()
    sec("Survivor ESP", "🟢")
    tog("ESP Survivor", false, function(s) S.ESP.surv = s end)
    cpk("Survivor Color", S.ESP.survColor, function(c) S.ESP.survColor = c end)

    sec("Killer ESP", "🔴")
    tog("ESP Killer", false, function(s) S.ESP.killer = s end)
    cpk("Killer Color", S.ESP.killerColor, function(c) S.ESP.killerColor = c end)

    sec("Generator ESP", "⚡")
    tog("ESP Generator", false, function(s) S.ESP.gen = s end)
    cpk("Generator Color", S.ESP.genColor, function(c) S.ESP.genColor = c end)

    sec("ESP Status", "📊")
    tog("Show Name", true, function(s) S.ESP.name = s end)
    tog("Show Distance", true, function(s) S.ESP.dist = s end)
    tog("Show Health", false, function(s) S.ESP.hp = s end)
    cpk("Name Color", S.ESP.nameColor, function(c) S.ESP.nameColor = c end)
    sl("Name Size", 8, 24, 12, function(v) S.ESP.nameSize = v end)
    sl("ESP Radius", 50, 1000, 100, function(v) S.ESP.radius = v end)
end)

-- =========================================================
-- TAB 5 : VISUAL
-- =========================================================
local tabVisual = makeTab("Visual", "🎨", 5, function()
    sec("Lighting", "☀️")
    tog("Fullbright", false, function(s) S.Visual.fullbright = s; applyVisual() end)
    tog("No Fog", false, function(s) S.Visual.nofog = s; applyVisual() end)
    tog("No Shadow", false, function(s) S.Visual.noshadow = s; applyVisual() end)

    sec("Sky", "🌤️")
    tog("Custom Sky", false, function(s) S.Visual.customSky = s; applyVisual() end)
    drp("Sky Preset", {"Sunset", "Night", "Space", "Alien"}, "Sunset", function(v)
        S.Visual.skyId = "rbxassetid://159454299"
        if S.Visual.customSky then applyVisual() end
    end)

    sec("Contrast & Sharpen", "🔍")
    tog("Enable Contrast", false, function(s) S.Visual.contrast = s; applyVisual() end)
    sl("Contrast", -1, 2, 0.3, function(v) S.Visual.contrastVal = v; applyVisual() end)
    sl("Brightness", -1, 1, 0.15, function(v) S.Visual.brightness = v; applyVisual() end)
    sl("Saturation", -1, 1, 0.2, function(v) S.Visual.saturation = v; applyVisual() end)

    sec("Fire Effect (5 Varian)", "🔥")
    tog("Enable Fire", false, function(s) S.Visual.fire = s; applyFire() end)
    drp("Fire Type", {"Red", "Blue", "Green", "Purple", "Rainbow"}, "Red", function(v)
        S.Visual.fireType = v
        applyFire()
    end)
    sl("Fire Size", 1, 20, 5, function(v) S.Visual.fireSize = v; applyFire() end)
end)

-- =========================================================
-- TAB 6 : MOVEMENT
-- =========================================================
local tabMove = makeTab("Movement", "🏃", 6, function()
    sec("Speed", "⚡")
    tog("Walk Speed", false, function(s)
        S.Move.speedOn = s
        if not s then
            local hum = getHum()
            if hum then hum.WalkSpeed = S.Move.origSpeed end
        end
    end)
    sl("Speed Value", 16, 100, 17.6, function(v) S.Move.speed = v end)

    tog("Jump Power", false, function(s)
        S.Move.jumpOn = s
        if not s then
            local hum = getHum()
            if hum then hum.JumpPower = S.Move.origJump end
        end
    end)
    sl("Jump Value", 50, 300, 50, function(v) S.Move.jump = v end)

    tog("No Clip", false, function(s) S.Move.noclip = s end)

    sec("Teleport", "📍")
    btn("🚀 TP Player Acak", function()
        local list = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP then table.insert(list, p) end
        end
        if #list > 0 then tpPlayer(list[math.random(1, #list)].Name) end
    end)
    btn("🚪 TP Gate", function() tpObj("gate") end)
    btn("🪵 TP Pallet", function() tpObj("pallet") end)
    btn("🪟 TP Window", function() tpObj("window") end)
    btn("⚡ TP Generator", function() tpObj("generator") end)
end)

-- =========================================================
-- TAB 7 : AVATAR
-- =========================================================
local tabAvatar = makeTab("Avatar", "🎭", 7, function()
    sec("Steal Avatar", "🎭")
    lbl("Masukin username target", C.ACCENT2)

    local tb = inp("Username", "Ketik username...", function(v)
        S.Avatar.target = v
    end)

    btn("🎭 Copy Avatar", function()
        if S.Avatar.target == "" and tb then
            S.Avatar.target = tb.Text
        end
        copyAvatar(S.Avatar.target)
    end)
    btn("🔄 Reset Avatar", function() resetAvatar() end)
    btn("💾 Save Avatar Skrg", function() saveAvatar() end)

    sec("Opsi", "⚙️")
    tog("Blocky Body", true, function(s) S.Avatar.blocky = s end)
end)

-- =========================================================
-- TAB 8 : SETTINGS
-- =========================================================
local tabSettings = makeTab("Settings", "⚙️", 8, function()
    sec("Keybind", "⌨️")
    lbl("RightShift = Toggle Menu", C.ACCENT2)
    lbl("Klik kanan = Aimlock", C.ACCENT2)
    lbl("Klik kiri ⚡ = Buka menu", C.ACCENT2)

    sec("Config Save", "💾")
    btn("💾 Save Config Skrg", function() saveCfg(); notify("Config saved!") end)
    btn("📂 Load Config", function() loadCfg(); notify("Config loaded!") end)
    btn("🗑️ Reset Config", function()
        if delfile and isfile("RoooorHub_Cfg.json") then
            delfile("RoooorHub_Cfg.json")
            notify("Config deleted!")
        end
    end)

    sec("Script", "🚪")
    btn("🔄 Reset Semua Fitur", function()
        for k, v in pairs(S) do
            if type(v) == "table" and v.on ~= nil then v.on = false end
        end
        notify("Semua fitur direset!")
    end)
    btn("🚪 Unload Script", function()
        saveCfg()
        gui:Destroy()
    end)

    sec("Info", "ℹ️")
    lbl("Version: 3.0", C.ACCENT3)
    lbl("Built with love 💖", C.DIM)
end)

print("✅ [BAGIAN 6/7] Isi Tab loaded")-- =========================================================
-- BAGIAN 7/7 : FLOATING BUTTONS + MAIN LOOP + FINAL
-- =========================================================

-- =========================================================
-- FLOATING BUTTONS
-- =========================================================
function mkAimBtn()
    if S.Buttons.aimGui then S.Buttons.aimGui:Destroy() end
    local g = Instance.new("ScreenGui")
    g.Name = "Roooor_AimBtn"
    g.ResetOnSpawn = false
    g.IgnoreGuiInset = true
    g.Parent = PG

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 46, 0, 46)
    b.Position = UDim2.new(0.35, 0, 0.75, 0)
    b.BackgroundColor3 = C.PANEL
    b.Text = "🎯"
    b.TextColor3 = C.TEXT
    b.TextSize = 22
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = g
    rnd(b, 23)
    local bs = strk(b, C.ACCENT2, 2)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0, 100, 0, 12)
    l.Position = UDim2.new(0.5, -50, 1, 2)
    l.BackgroundTransparency = 1
    l.Text = "AIMLOCK"
    l.TextColor3 = C.ACCENT2
    l.TextSize = 9
    l.Font = Enum.Font.GothamBlack
    l.TextStrokeTransparency = 0.3
    l.TextStrokeColor3 = Color3.new(0,0,0)
    l.Parent = b

    local lk = Instance.new("TextLabel")
    lk.Name = "LockLabel"
    lk.Size = UDim2.new(0, 100, 0, 10)
    lk.Position = UDim2.new(0.5, -50, 1, 15)
    lk.BackgroundTransparency = 1
    lk.Text = "🔓"
    lk.TextColor3 = Color3.fromRGB(200, 200, 200)
    lk.TextSize = 8
    lk.Font = Enum.Font.GothamBold
    lk.TextStrokeTransparency = 0.4
    lk.TextStrokeColor3 = Color3.new(0,0,0)
    lk.Parent = b

    local drag = false
    local ds, dp
    local wasDragged = false
    local lastClick = 0

    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if S.Buttons.aimLocked then return end
            drag = true
            wasDragged = false
            ds = input.Position
            dp = b.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - ds
            if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then wasDragged = true end
            b.Position = UDim2.new(dp.X.Scale, dp.X.Offset + d.X, dp.Y.Scale, dp.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)

    b.MouseButton1Click:Connect(function()
        if wasDragged then wasDragged = false; return end
        if tick() - lastClick < 0.15 then return end
        lastClick = tick()
        S.Aimlock.on = not S.Aimlock.on
        if S.Aimlock.on then
            b.BackgroundColor3 = C.ACCENT4
            bs.Color = C.ACCENT
            startAimlock()
        else
            b.BackgroundColor3 = C.PANEL
            bs.Color = C.ACCENT2
        end
    end)

    S.Buttons.aimGui = g
    S.Buttons.aimOn = true
end

function rmAimBtn()
    if S.Buttons.aimGui then S.Buttons.aimGui:Destroy(); S.Buttons.aimGui = nil end
    S.Buttons.aimOn = false
end

function mkMoonBtn()
    if S.Buttons.moonGui then S.Buttons.moonGui:Destroy() end
    local g = Instance.new("ScreenGui")
    g.Name = "Roooor_MoonBtn"
    g.ResetOnSpawn = false
    g.IgnoreGuiInset = true
    g.Parent = PG

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 46, 0, 46)
    b.Position = UDim2.new(0.65, 0, 0.75, 0)
    b.BackgroundColor3 = C.PANEL
    b.Text = "🌙"
    b.TextColor3 = C.TEXT
    b.TextSize = 22
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = g
    rnd(b, 23)
    local bs = strk(b, C.ACCENT2, 2)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0, 100, 0, 12)
    l.Position = UDim2.new(0.5, -50, 1, 2)
    l.BackgroundTransparency = 1
    l.Text = "MOONWALK"
    l.TextColor3 = C.ACCENT2
    l.TextSize = 9
    l.Font = Enum.Font.GothamBlack
    l.TextStrokeTransparency = 0.3
    l.TextStrokeColor3 = Color3.new(0,0,0)
    l.Parent = b

    local lk = Instance.new("TextLabel")
    lk.Name = "LockLabel"
    lk.Size = UDim2.new(0, 100, 0, 10)
    lk.Position = UDim2.new(0.5, -50, 1, 15)
    lk.BackgroundTransparency = 1
    lk.Text = "🔓"
    lk.TextColor3 = Color3.fromRGB(200, 200, 200)
    lk.TextSize = 8
    lk.Font = Enum.Font.GothamBold
    lk.TextStrokeTransparency = 0.4
    lk.TextStrokeColor3 = Color3.new(0,0,0)
    lk.Parent = b

    local drag = false
    local ds, dp
    local wasDragged = false
    local lastClick = 0

    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if S.Buttons.moonLocked then return end
            drag = true
            wasDragged = false
            ds = input.Position
            dp = b.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - ds
            if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then wasDragged = true end
            b.Position = UDim2.new(dp.X.Scale, dp.X.Offset + d.X, dp.Y.Scale, dp.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)

    b.MouseButton1Click:Connect(function()
        if wasDragged then wasDragged = false; return end
        if tick() - lastClick < 0.15 then return end
        lastClick = tick()
        S.Moonwalk.on = not S.Moonwalk.on
        if S.Moonwalk.on then
            b.BackgroundColor3 = C.ACCENT4
            bs.Color = C.ACCENT
            startMoonwalk()
        else
            b.BackgroundColor3 = C.PANEL
            bs.Color = C.ACCENT2
            stopMoonwalk()
            local hum = getHum()
            if hum then
                if S.Move.speedOn then
                    hum.WalkSpeed = S.Move.speed
                else
                    hum.WalkSpeed = 16
                end
            end
        end
    end)

    S.Buttons.moonGui = g
    S.Buttons.moonOn = true
end

function rmMoonBtn()
    if S.Buttons.moonGui then S.Buttons.moonGui:Destroy(); S.Buttons.moonGui = nil end
    S.Buttons.moonOn = false
end

-- =========================================================
-- FPS/PING COUNTER
-- =========================================================
local fpsLbl = Instance.new("TextLabel")
fpsLbl.Size = UDim2.new(0, 140, 0, 20)
fpsLbl.Position = UDim2.new(0.5, -70, 0, 5)
fpsLbl.BackgroundColor3 = C.PANEL
fpsLbl.BackgroundTransparency = 0.4
fpsLbl.Text = "FPS: -- | PING: --"
fpsLbl.TextColor3 = C.ACCENT2
fpsLbl.TextSize = 11
fpsLbl.Font = Enum.Font.GothamBold
fpsLbl.TextStrokeTransparency = 0.5
fpsLbl.TextStrokeColor3 = Color3.new(0,0,0)
fpsLbl.Parent = gui
rnd(fpsLbl, 6)
strk(fpsLbl, C.ACCENT, 1, 0.5)

local frameCnt = 0
local timeAcc = 0

RunService.RenderStepped:Connect(function(dt)
    frameCnt = frameCnt + 1
    timeAcc = timeAcc + dt
    if timeAcc >= 1 then
        local fps = math.floor(frameCnt / timeAcc)
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        if S.FPS.show then
            fpsLbl.Text = string.format("FPS: %d | PING: %d ms", fps, ping)
        end
        frameCnt = 0
        timeAcc = 0
    end
end)

-- =========================================================
-- MAIN LOOP
-- =========================================================
local lastESP = 0
local lastParry = 0
local lastHB = 0
local lastSlow = 0

task.spawn(function()
    while gui.Parent do
        local now = tick()
        local root = getRoot()
        if root then
            -- ESP UPDATE (tiap 0.1s)
            if now - lastESP >= 0.1 then
                lastESP = now
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local char = p.Character
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local dist = (hrp.Position - root.Position).Magnitude
                                if dist <= S.ESP.radius then
                                    if S.ESP.surv and p.Team and p.Team.Name == "Survivors" then
                                        mkESP(char, S.ESP.survColor)
                                    elseif S.ESP.killer and p.Team and p.Team.Name == "Killer" then
                                        mkESP(char, S.ESP.killerColor)
                                    else
                                        rmESP(char)
                                    end
                                else
                                    rmESP(char)
                                end
                            end
                            mkESPBB(p, char, root)
                        else
                            rmESP(char)
                            rmESPBB(char)
                        end
                    end
                end

                if S.ESP.gen then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name == "Generator" then
                            local part = nil
                            if obj:IsA("Model") then
                                part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                            elseif obj:IsA("BasePart") then
                                part = obj
                            end
                            if part then
                                local dist = (part.Position - root.Position).Magnitude
                                if dist <= S.ESP.radius then
                                    mkESP(obj, S.ESP.genColor)
                                else
                                    rmESP(obj)
                                end
                            end
                        end
                    end
                end
            end

            -- AUTO ATTACK
            if S.AutoAtk.on and now - S.AutoAtk.last >= S.AutoAtk.delay then
                S.AutoAtk.last = now
                if AttackEvent then pcall(function() AttackEvent:FireServer(false) end) end
            end

            -- AUTO KILL ALL
            if S.KillAll.on then
                local target = getNearest("Survivors", 500)
                if target then
                    local tHRP = target:FindFirstChild("HumanoidRootPart")
                    if tHRP then
                        local tp = tHRP.Position + (tHRP.AssemblyLinearVelocity * S.KillAll.predict)
                        local behind = tHRP.CFrame.LookVector * -S.KillAll.behind
                        root.CFrame = CFrame.new(tp + behind, tp)
                        if AttackEvent then pcall(function() AttackEvent:FireServer(false) end) end
                    end
                end
            end

            -- GOD MODE
            if S.GodMode.on then
                local hum = getHum()
                if hum and hum.Health < hum.MaxHealth then
                    pcall(function() hum.Health = hum.MaxHealth end)
                end
            end

            -- ANTI STUN
            applyAntiStun()

            -- WALK SPEED
            if S.Move.speedOn then
                local hum = getHum()
                if hum and hum.WalkSpeed ~= S.Move.speed then
                    hum.WalkSpeed = S.Move.speed
                end
            end

            -- JUMP POWER
            if S.Move.jumpOn then
                local hum = getHum()
                if hum and hum.JumpPower ~= S.Move.jump then
                    hum.JumpPower = S.Move.jump
                end
            end

            -- NOCLIP
            if S.Move.noclip and LP.Character then
                for _, p in pairs(LP.Character:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
                end
            end

            -- HITBOX (tiap 0.3s)
            if S.Hitbox.on and now - lastHB >= 0.3 then
                lastHB = now
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        if S.Hitbox.onlySurv then
                            if plr.Team and plr.Team.Name == "Survivors" then
                                applyHB(plr.Character)
                            end
                        else
                            applyHB(plr.Character)
                        end
                    end
                end
            end

            -- FIRE
            if S.Visual.fire then applyFire() end

            -- PARRY CIRCLE
            updParryCircle()

            -- SCAN KILLERS PARRY (tiap 2s)
            if S.Parry.on and now - lastParry >= 2 then
                lastParry = now
                scanKillers()
            end
        end

        -- SLOW LOOP (tiap 0.5s)
        if now - lastSlow >= 0.5 then
            lastSlow = now
            if S.Flee.on then runFlee() end
            if S.Wiggle.on then runWiggle() end
            if S.AutoCarry.on then runCarry() end
            if S.AutoStalk.on then runStalk() end
        end

        task.wait(0.1)
    end
end)

-- =========================================================
-- RESPAWN HANDLER
-- =========================================================
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    _G.ParryActive = false
    _G.CarryBusy = false
    _G.HookedKillers = {}
    if S.Visual.fire then applyFire() end
    if S.Moonwalk.on then startMoonwalk() end
    if S.Parry.on then scanKillers() end
    if S.Avatar.uid then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local d = Players:GetHumanoidDescriptionFromUserId(S.Avatar.uid)
            if S.Avatar.blocky then applyBlocky(char) end
            task.wait(0.2)
            removeAcc(char)
            task.wait(0.1)
            hum:ApplyDescriptionClientServer(d)
        end
    end
end)

-- =========================================================
-- KEYBIND RightShift
-- =========================================================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if main.Visible then
            main.Visible = false
            floatBtn.Visible = true
        else
            main.Visible = true
            floatBtn.Visible = false
        end
    end
end)

-- =========================================================
-- NEON STROKE ANIMASI
-- =========================================================
task.spawn(function()
    while main.Parent do
        task.wait(0.05)
        local hue = (tick() * 0.3) % 1
        mainStrk.Color = Color3.fromHSV(hue, 1, 1)
        mainStrk.Transparency = 0.4
    end
end)

-- =========================================================
-- BUKA TAB PERTAMA
-- =========================================================
task.wait(0.3)
for _, c in pairs(sb:GetChildren()) do
    if c:IsA("TextButton") then
        c.MouseButton1Click:Fire()
        break
    end
end

-- =========================================================
-- FINAL PRINT
-- =========================================================
print("=====================================================")
print("✅ [BAGIAN 7/7] Final loaded")
print("🎉 ROOORHUB ULTIMATE - LOADED SUCCESSFULLY!")
print("=====================================================")
print("⌨️  RightShift = Toggle Menu")
print("🎯 Klik kanan = Aimlock")
print("🎯 Klik ⚡ = Buka menu")
print("🌙 Moonwalk = Konsisten Lobby & Ingame")
print("💾 Auto Save Config = AKTIF")
print("=====================================================")
