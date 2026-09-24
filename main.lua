-- =========================================================
-- ROOORHUB - BAGIAN 1/5 : CORE + CONFIG
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

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local Cam = workspace.CurrentCamera

local C = {
    BG = Color3.fromRGB(10, 8, 18),
    PANEL = Color3.fromRGB(20, 15, 35),
    ACC = Color3.fromRGB(255, 50, 130),
    ACC2 = Color3.fromRGB(0, 255, 200),
    ACC3 = Color3.fromRGB(255, 200, 0),
    ACC4 = Color3.fromRGB(150, 80, 255),
    TXT = Color3.fromRGB(245, 245, 255),
    DIM = Color3.fromRGB(130, 130, 160),
    RED = Color3.fromRGB(255, 70, 90),
    GRN = Color3.fromRGB(0, 255, 150),
}

local S = {
    Aimlock = { on = false, hold = false, target = "Survivor", part = "Head", fov = 250, radius = 500, predict = 0.12, smooth = 0.5, locked = false },
    AutoAtk = { on = false, delay = 0.35, last = 0 },
    KillAll = { on = false },
    Hitbox = { on = false, size = 15 },
    AntiStun = { on = false },
    Parry = { on = false, dist = 15 },
    Skill = { on = false },
    Wiggle = { on = false, spam = 5 },
    Flee = { on = false, dist = 50, last = 0 },
    Moonwalk = { on = false, spam = 30, intensity = 35, slow = 13, locked = false },
    GodMode = { on = false },
    GenBoost = { on = false, delay = 0.2, last = 0 },
    ESP = {
        surv = false, killer = false, gen = false,
        name = true, dist = true, hp = false, radius = 100,
        sc = Color3.fromRGB(60, 255, 120),
        kc = Color3.fromRGB(255, 60, 60),
        gc = Color3.fromRGB(255, 170, 0),
    },
    Visual = { fb = false, nofog = false, contrast = false, cv = 0.3, bv = 0.15, sv = 0.2, fire = false, fireType = "Red" },
    Move = { speedOn = false, speed = 17.6, jumpOn = false, jump = 50, noclip = false },
    FPS = { show = true },
    Buttons = { aimGui = nil, moonGui = nil, genGui = nil },
}

local TeamColors = {
    Killer = Color3.fromRGB(255, 60, 60),
    Survivor = Color3.fromRGB(60, 255, 120),
}

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

local CarryEvent, HookEvent, AttackEvent, GenBoostEvent
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
        local g = r:FindFirstChild("Generator")
        if g then
            GenBoostEvent = g:FindFirstChild("BoostEvent") 
                or g:FindFirstChild("BoostGenerator") 
                or g:FindFirstChild("Boost")
        end
    end
end)

function getRoot() local c = LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
function getHum() local c = LP.Character; return c and c:FindFirstChildOfClass("Humanoid") end
function isDowned()
    local c = LP.Character; if not c then return false end
    local h = c:FindFirstChildOfClass("Humanoid"); if not h then return false end
    return h.Health <= 0 or h.Health < 2
end
function getNearest(team, maxD)
    local r = getRoot(); if not r then return nil, math.huge end
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
function rnd(o, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 10); c.Parent = o end
function strk(o, col, t)
    local s = Instance.new("UIStroke"); s.Color = col or C.ACC; s.Thickness = t or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = o; return s
end
function rainbow()
    return ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,100,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,150)),
    }
end
function notify(text)
    if not gui then return end
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 240, 0, 40)
    n.Position = UDim2.new(1, 260, 1, -60)
    n.BackgroundColor3 = C.PANEL
    n.BorderSizePixel = 0
    n.Parent = gui
    rnd(n, 10)
    strk(n, C.ACC2, 1.5)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = C.TXT
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

print("✅ [1/5] Core loaded")-- =========================================================
-- ROOORHUB - BAGIAN 2/5 : GUI + TAB + COMPONENTS
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
floatBtn.TextColor3 = C.ACC2
floatBtn.TextSize = 22
floatBtn.Font = Enum.Font.GothamBold
floatBtn.BorderSizePixel = 0
floatBtn.AutoButtonColor = false
floatBtn.Parent = gui
rnd(floatBtn, 21)
local fbStrk = strk(floatBtn, C.ACC, 2)

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
local mainStrk = strk(main, C.ACC, 2, 0.2)

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
nLine.BackgroundColor3 = C.ACC
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
closeB.TextColor3 = C.RED
closeB.TextSize = 14
closeB.Font = Enum.Font.GothamBold
closeB.BorderSizePixel = 0
closeB.AutoButtonColor = false
closeB.Parent = head
rnd(closeB, 6)
strk(closeB, C.RED, 1, 0.6)
closeB.MouseButton1Click:Connect(function()
    main.Visible = false
    floatBtn.Visible = true
end)

local minB = Instance.new("TextButton")
minB.Size = UDim2.new(0, 24, 0, 24)
minB.Position = UDim2.new(1, -60, 0.5, -12)
minB.BackgroundColor3 = C.PANEL
minB.Text = "—"
minB.TextColor3 = C.ACC2
minB.TextSize = 14
minB.Font = Enum.Font.GothamBold
minB.BorderSizePixel = 0
minB.AutoButtonColor = false
minB.Parent = head
rnd(minB, 6)
strk(minB, C.ACC2, 1, 0.6)
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
strk(sb, C.ACC4, 1, 0.7)

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
strk(ct, C.ACC2, 1, 0.7)

local cs = Instance.new("ScrollingFrame")
cs.Size = UDim2.new(1, -14, 1, -14)
cs.Position = UDim2.new(0, 7, 0, 7)
cs.BackgroundTransparency = 1
cs.BorderSizePixel = 0
cs.ScrollBarThickness = 3
cs.ScrollBarImageColor3 = C.ACC
cs.CanvasSize = UDim2.new(0, 0, 0, 0)
cs.AutomaticCanvasSize = Enum.AutomaticSize.Y
cs.Parent = ct

local csL = Instance.new("UIListLayout")
csL.Padding = UDim.new(0, 5)
csL.SortOrder = Enum.SortOrder.LayoutOrder
csL.Parent = cs

-- TAB SYSTEM
local activeTab = nil
function makeTab(name, icon, order, cb)
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
    ind.BackgroundColor3 = C.ACC
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
            if c:IsA("TextLabel") then c.TextColor3 = C.TXT end
        end
        for _, c in pairs(cs:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
        if cb then pcall(cb) end
    end)
end

-- COMPONENTS
function sec(title, icon)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 22)
    f.BackgroundTransparency = 1
    f.Parent = cs
    local deco = Instance.new("Frame")
    deco.Size = UDim2.new(0, 3, 0, 14)
    deco.Position = UDim2.new(0, 4, 0.5, -7)
    deco.BackgroundColor3 = C.ACC
    deco.BorderSizePixel = 0
    deco.Parent = f
    rnd(deco, 2)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -16, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = icon .. "  " .. string.upper(title)
    l.TextColor3 = C.ACC3
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
    strk(f, C.ACC, 1, 0.8)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local t = Instance.new("Frame")
    t.Size = UDim2.new(0, 32, 0, 16)
    t.Position = UDim2.new(1, -42, 0.5, -8)
    t.BackgroundColor3 = def and C.ACC or C.PANEL
    t.BorderSizePixel = 0
    t.Parent = f
    rnd(t, 8)
    local tS = strk(t, def and C.ACC2 or C.DIM, 1, 0.5)
    local k = Instance.new("Frame")
    k.Size = UDim2.new(0, 12, 0, 12)
    k.Position = def and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    k.BackgroundColor3 = def and C.ACC2 or C.DIM
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
        k.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        k.BackgroundColor3 = state and C.ACC2 or C.DIM
        t.BackgroundColor3 = state and C.ACC or C.PANEL
        tS.Color = state and C.ACC2 or C.DIM
        if cb then pcall(cb, state) end
    end)
end

function btn(name, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -4, 0, 28)
    b.BackgroundColor3 = C.BG
    b.BackgroundTransparency = 0.3
    b.Text = name
    b.TextColor3 = C.TXT
    b.TextSize = 10
    b.Font = Enum.Font.GothamMedium
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = cs
    rnd(b, 8)
    strk(b, C.ACC2, 1, 0.7)
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
    strk(f, C.ACC, 1, 0.8)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 0, 16)
    l.Position = UDim2.new(0, 10, 0, 3)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 9
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0, 35, 0, 16)
    v.Position = UDim2.new(1, -42, 0, 3)
    v.BackgroundTransparency = 1
    v.Text = tostring(def)
    v.TextColor3 = C.ACC2
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
    fill.BackgroundColor3 = C.ACC
    fill.BorderSizePixel = 0
    fill.Parent = bg
    rnd(fill, 2)
    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 10, 0, 10)
    kn.Position = UDim2.new((def - min) / (max - min), -5, 0.5, -5)
    kn.BackgroundColor3 = C.TXT
    kn.BorderSizePixel = 0
    kn.ZIndex = 2
    kn.Parent = bg
    rnd(kn, 5)
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
    strk(f, C.ACC, 1, 0.8)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.5, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
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
    v.TextColor3 = C.ACC2
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
    strk(f, C.ACC, 1, 0.8)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
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
    strk(cB, C.ACC2, 1.5)
    local presets = {
        Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 170, 0),
        Color3.fromRGB(255, 255, 0), Color3.fromRGB(60, 255, 120),
        Color3.fromRGB(0, 200, 255), Color3.fromRGB(150, 80, 255),
        Color3.fromRGB(255, 50, 130), Color3.fromRGB(255, 255, 255),
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

print("✅ [2/5] GUI + Components loaded")-- =========================================================
-- BAGIAN 3/5 : ESP + PARRY + SKILL + GENBOOST (FALLENS)
-- =========================================================

-- ============== ESP SYSTEM (FALLENS) ==============
local ESPObjects = {}
local StatusESP = {}

-- Cache Object
local Cached = {
    Generators = {},
    Windows = {},
    Pallets = {}
}

local function cacheObject(obj)
    if obj.Name == "Generator" then
        Cached.Generators[obj] = true
    elseif obj.Name == "Window" then
        Cached.Windows[obj] = true
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        Cached.Pallets[obj] = true
    end
end

local function removeCache(obj)
    Cached.Generators[obj] = nil
    Cached.Windows[obj] = nil
    Cached.Pallets[obj] = nil
end

for _, obj in ipairs(workspace:GetDescendants()) do
    cacheObject(obj)
end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(removeCache)

function createESP(obj, color)
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
        if not parent and ESPObjects[obj] then
            ESPObjects[obj]:Destroy()
            ESPObjects[obj] = nil
        end
    end)
end

function removeESP(obj)
    if ESPObjects[obj] then
        ESPObjects[obj]:Destroy()
        ESPObjects[obj] = nil
    end
end

function createStatusESP(player, char, root)
    if not root then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    local isDown = hum.Health <= 0 or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true

    local dist = (head.Position - root.Position).Magnitude
    if dist > S.ESP.radius then
        if StatusESP[char] then StatusESP[char]:Destroy(); StatusESP[char] = nil end
        return
    end

    local text = ""
    if isDown then text = "🔻 DOWN\n" end
    if S.ESP.name then text = text .. player.Name .. "\n" end
    if S.ESP.dist then text = text .. string.format("Dist: %.0f\n", dist) end
    if S.ESP.hp then text = text .. string.format("HP: %.0f\n", hum.Health) end
    if text == "" then return end

    local billboard = StatusESP[char]
    local teamColor = Color3.new(1, 1, 1)
    if player.Team then
        if player.Team.Name == "Killer" then teamColor = TeamColors.Killer
        elseif player.Team.Name == "Survivors" then teamColor = TeamColors.Survivor end
    end
    if isDown then teamColor = Color3.fromRGB(255, 0, 0) end

    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 120, 0, 50)
        billboard.AlwaysOnTop = true
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
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
            label.TextColor3 = teamColor
        end
    end
end

function removeStatusESP(char)
    if StatusESP[char] then StatusESP[char]:Destroy(); StatusESP[char] = nil end
end

-- ============== AUTO PARRY (FALLENS) ==============
local lastParry = 0
local PARRY_DEBOUNCE = 0.2
local ParryActive = false
local hookedKillers = {}

local function pressRightClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
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
            local inset = GuiService:GetGuiInset()
            local x = pos.X + size.X/2 + inset.X
            local y = pos.Y + size.Y/2 + inset.Y
            VirtualInputManager:SendTouchEvent(8823, 0, x, y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8823, 2, x, y)
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
    if S.Moonwalk.on then S.Moonwalk.on = false end
    pressParryButton()
    task.delay(0.3, function() ParryActive = false end)
end

local function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end
    return (enemyRoot.Position - myRoot.Position).Magnitude <= S.Parry.dist
end

local function isFacingTarget(targetChar)
    local myChar = LP.Character
    if not myChar then return false end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local enemyRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not enemyRoot then return false end
    local enemyForward = enemyRoot.CFrame.LookVector
    local directionToMe = (myRoot.Position - enemyRoot.Position).Unit
    local dot = enemyForward:Dot(directionToMe)
    return dot >= 0.7
end

local function hookKiller(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true
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
        local fullId = "rbxassetid://" .. id
        if KillerAnims[fullId] then
            if not isInParryRange(char) then return end
            if not isFacingTarget(char) then return end
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

-- ============== AUTO SKILL CHECK (FALLENS) ==============
local skillConn = nil
local skillBusy = false
local TouchID = 8822
local ActionPath = "Survivor-mob.Controls.action.check"

local function pressSpace()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local function GetActionTarget()
    local current = PG
    for segment in string.gmatch(ActionPath, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function TriggerMobileButton()
    local b = GetActionTarget()
    if b and b:IsA("GuiObject") then
        local p, s, i = b.AbsolutePosition, b.AbsoluteSize, GuiService:GetGuiInset()
        local cx, cy = p.X + (s.X/2) + i.X, p.Y + (s.Y/2) + i.Y
        pcall(function()
            VirtualInputManager:SendTouchEvent(TouchID, 0, cx, cy)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(TouchID, 2, cx, cy)
        end)
    end
end

function startSkillCheck()
    if skillConn then skillConn:Disconnect() end
    skillConn = RunService.RenderStepped:Connect(function()
        if not S.Skill.on or skillBusy then return end
        local prompt = PG:FindFirstChild("SkillCheckPromptGui")
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

        local success =
            (startRange > endRange and (lr >= startRange or lr <= endRange))
            or (lr >= startRange and lr <= endRange)

        if success then
            skillBusy = true
            task.spawn(function()
                if UIS.TouchEnabled then
                    TriggerMobileButton()
                else
                    pressSpace()
                end
                task.wait(0.05)
                skillBusy = false
            end)
        end
    end)
end

-- ============== GENERATOR BOOST ==============
function runGenBoost()
    if not S.GenBoost.on then return end
    local now = tick()
    if now - S.GenBoost.last < S.GenBoost.delay then return end
    S.GenBoost.last = now
    if GenBoostEvent then
        pcall(function() GenBoostEvent:FireServer() end)
    end
end

-- ============== HITBOX EXPANDER ==============
local hbCache = {}
function applyHB(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local parts = {
        char:FindFirstChild("Head"),
        char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"),
        char:FindFirstChild("HumanoidRootPart"),
    }
    for _, p in pairs(parts) do
        if p and p:IsA("BasePart") then
            if not hbCache[p] then
                hbCache[p] = { Size = p.Size, Transparency = p.Transparency }
            end
            p.Size = Vector3.new(S.Hitbox.size, S.Hitbox.size, S.Hitbox.size)
            p.Transparency = 0.7
            p.CanCollide = false
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
            hbCache[p] = nil
        end
    end
end

-- ============== ANTI STUN ==============
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

print("✅ [3/5] ESP + Parry + Skill + GenBoost loaded")-- =========================================================
-- BAGIAN 4/5 : WIGGLE, FLEE, MOONWALK, FIRE, VISUAL, MOVEMENT
-- =========================================================

-- ============== AUTO WIGGLE ==============
function runWiggle()
    if not S.Wiggle.on then return end
    local char = LP.Character
    if not char then return end
    local carried = (char:FindFirstChild("IsCarried") and char.IsCarried.Value)
        or (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)
    if not carried then return end
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local carry = remotes and remotes:FindFirstChild("Carry")
    local ev = carry and carry:FindFirstChild("SelfUnHookEvent")
    if not ev then return end
    for i = 1, S.Wiggle.spam do
        ev:FireServer()
    end
end

-- ============== AUTO FLEE ==============
function runFlee()
    if not S.Flee.on then return end
    local root = getRoot()
    if not root then return end
    local killer, dist = getNearest("Killer", 999)
    if killer and dist <= S.Flee.dist and tick() - S.Flee.last > 0.1 then
        local killerRoot = killer:FindFirstChild("HumanoidRootPart")
        if killerRoot then
            local bestPoint, far = nil, 0
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and string.match(obj.Name, "^GeneratorPoint%d+$") then
                    local d = (obj.Position - killerRoot.Position).Magnitude
                    if d > far then far = d; bestPoint = obj end
                end
            end
            if bestPoint then
                S.Flee.last = tick()
                root.CFrame = bestPoint.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end

-- ============== MOONWALK (FALLENS) ==============
_G.MoonConn = nil

function startMoonwalk()
    if _G.MoonConn then return end
    _G.MoonConn = RunService.RenderStepped:Connect(function()
        if not S.Moonwalk.on or ParryActive or isDowned() then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        if hum.WalkSpeed ~= S.Moonwalk.slow then
            hum.WalkSpeed = S.Moonwalk.slow
        end

        local cam = workspace.CurrentCamera
        local look = cam.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit
            local baseCF = CFrame.new(hrp.Position, hrp.Position + flatLook)
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

-- ============== FIRE EFFECT ==============
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
        fire.Size = 5
        fire.Parent = hrp
    end
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

-- ============== VISUAL (FULLBRIGHT, NOFOG, CONTRAST) ==============
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
    -- Fullbright
    if S.Visual.fb then
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

    -- No Fog
    if S.Visual.nofog then
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
    else
        Lighting.FogEnd = origL.FogEnd
        Lighting.FogStart = origL.FogStart
    end

    -- Contrast (ColorCorrection)
    if S.Visual.contrast then
        if not contrastEffect then
            contrastEffect = Instance.new("ColorCorrectionEffect")
            contrastEffect.Name = "RoooorContrast"
            contrastEffect.Parent = Lighting
        end
        contrastEffect.Contrast = S.Visual.cv
        contrastEffect.Brightness = S.Visual.bv
        contrastEffect.Saturation = S.Visual.sv
    else
        if contrastEffect then
            contrastEffect:Destroy()
            contrastEffect = nil
        end
    end
end

-- ============== TELEPORT ==============
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

print("✅ [4/5] Wiggle + Flee + Moonwalk + Fire + Visual + Move loaded")-- =========================================================
-- BAGIAN 5/5 : FLOATING BUTTONS + ISI TAB + MAIN LOOP
-- =========================================================

-- =========================================================
-- FLOATING BUTTONS (AIMLOCK + MOONWALK + LOCK)
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
    b.TextColor3 = C.TXT
    b.TextSize = 22
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = g
    rnd(b, 23)
    local bs = strk(b, C.ACC2, 2)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 100, 0, 12)
    lbl.Position = UDim2.new(0.5, -50, 1, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = "AIMLOCK"
    lbl.TextColor3 = C.ACC2
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextStrokeTransparency = 0.3
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.Parent = b

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
            if S.Aimlock.locked then return end
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
            b.BackgroundColor3 = C.ACC4
            bs.Color = C.ACC
            startAimlock()
        else
            b.BackgroundColor3 = C.PANEL
            bs.Color = C.ACC2
        end
    end)

    S.Buttons.aimGui = g
end

function rmAimBtn()
    if S.Buttons.aimGui then S.Buttons.aimGui:Destroy(); S.Buttons.aimGui = nil end
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
    b.TextColor3 = C.TXT
    b.TextSize = 22
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = g
    rnd(b, 23)
    local bs = strk(b, C.ACC2, 2)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 100, 0, 12)
    lbl.Position = UDim2.new(0.5, -50, 1, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = "MOONWALK"
    lbl.TextColor3 = C.ACC2
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextStrokeTransparency = 0.3
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.Parent = b

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
            if S.Moonwalk.locked then return end
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
            b.BackgroundColor3 = C.ACC4
            bs.Color = C.ACC
            startMoonwalk()
        else
            b.BackgroundColor3 = C.PANEL
            bs.Color = C.ACC2
            stopMoonwalk()
            local hum = getHum()
            if hum then hum.WalkSpeed = 16 end
        end
    end)

    S.Buttons.moonGui = g
end

function rmMoonBtn()
    if S.Buttons.moonGui then S.Buttons.moonGui:Destroy(); S.Buttons.moonGui = nil end
end

function mkGenBtn()
    if S.Buttons.genGui then S.Buttons.genGui:Destroy() end
    local g = Instance.new("ScreenGui")
    g.Name = "Roooor_GenBtn"
    g.ResetOnSpawn = false
    g.IgnoreGuiInset = true
    g.Parent = PG

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 46, 0, 46)
    b.Position = UDim2.new(0.5, 0, 0.75, 0)
    b.BackgroundColor3 = C.PANEL
    b.Text = "⚡"
    b.TextColor3 = C.TXT
    b.TextSize = 22
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = g
    rnd(b, 23)
    local bs = strk(b, C.ACC2, 2)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 100, 0, 12)
    lbl.Position = UDim2.new(0.5, -50, 1, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = "GEN BOOST"
    lbl.TextColor3 = C.ACC2
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextStrokeTransparency = 0.3
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.Parent = b

    local drag = false
    local ds, dp
    local wasDragged = false

    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        S.GenBoost.on = not S.GenBoost.on
        if S.GenBoost.on then
            b.BackgroundColor3 = C.ACC4
            bs.Color = C.ACC
        else
            b.BackgroundColor3 = C.PANEL
            bs.Color = C.ACC2
        end
    end)

    S.Buttons.genGui = g
end

function rmGenBtn()
    if S.Buttons.genGui then S.Buttons.genGui:Destroy(); S.Buttons.genGui = nil end
end

-- =========================================================
-- ISI TAB
-- =========================================================

-- TAB INFO
makeTab("Info", "ℹ️", 1, function()
    sec("Script Info", "📋")
    lbl("RoooorHub Ultimate", C.ACC2)
    lbl("Status: Active", C.GRN)
    lbl("Dev: Roooor", C.TXT)

    sec("FPS/Ping", "🌊")
    tog("Show FPS/Ping", true, function(s) S.FPS.show = s end)

    sec("Floating Buttons", "🔘")
    tog("Show Aimlock Button", false, function(s) if s then mkAimBtn() else rmAimBtn() end end)
    tog("Show Moonwalk Button", false, function(s) if s then mkMoonBtn() else rmMoonBtn() end end)
    tog("Show GenBoost Button", false, function(s) if s then mkGenBtn() else rmGenBtn() end end)
end)

-- TAB KILLER
makeTab("Killer", "🔪", 2, function()
    sec("Aimlock", "🎯")
    tog("Enable Aimlock", false, function(s) S.Aimlock.on = s; if s then startAimlock() end end)
    drp("Target", {"Survivor", "Killer"}, "Survivor", function(v) S.Aimlock.target = v end)
    drp("Aim Part", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(v) S.Aimlock.part = v end)
    sl("FOV", 50, 1000, 250, function(v) S.Aimlock.fov = v end)
    sl("Radius", 50, 1000, 500, function(v) S.Aimlock.radius = v end)
    sl("Prediction", 0, 1, 0.12, function(v) S.Aimlock.predict = v end)
    sl("Smoothness", 0.05, 1, 0.5, function(v) S.Aimlock.smooth = v end)

    sec("Aimlock Button", "🎯")
    tog("Show Aimlock Button", false, function(s) if s then mkAimBtn() else rmAimBtn() end end)
    tog("🔒 Lock Aimlock Button", false, function(s) S.Aimlock.locked = s end)
    btn("🔄 Reset Posisi Aimlock", function()
        if S.Buttons.aimGui then
            local b = S.Buttons.aimGui:FindFirstChild("AimlockButton") or S.Buttons.aimGui:FindFirstChildWhichIsA("TextButton")
            if b then b.Position = UDim2.new(0.35, 0, 0.75, 0) end
        end
    end)

    sec("Auto Attack", "⚔️")
    tog("Auto Spam Attack", false, function(s) S.AutoAtk.on = s end)
    sl("Attack Delay", 0.1, 2, 0.35, function(v) S.AutoAtk.delay = v end)

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

    sec("Anti Stun", "💪")
    tog("Anti Stun", false, function(s) S.AntiStun.on = s end)
end)

-- TAB SURVIVOR
makeTab("Survivor", "🏃", 3, function()
    sec("Auto Parry", "🛡️")
    tog("Enable Auto Parry", false, function(s)
        S.Parry.on = s
        if s then scanKillers() end
    end)
    sl("Parry Distance", 5, 25, 15, function(v) S.Parry.dist = v end)

    sec("Auto Skill Check", "🎯")
    tog("Enable Skill Check", false, function(s)
        S.Skill.on = s
        if s then startSkillCheck() end
    end)

    sec("Generator Boost", "⚡")
    tog("Enable GenBoost", false, function(s) S.GenBoost.on = s end)
    sl("Boost Delay", 0.05, 1, 0.2, function(v) S.GenBoost.delay = v end)
    tog("Show GenBoost Button", false, function(s) if s then mkGenBtn() else rmGenBtn() end end)

    sec("Auto Wiggle", "🎯")
    tog("Auto Wiggle", false, function(s) S.Wiggle.on = s end)
    sl("Wiggle Spam", 1, 10, 5, function(v) S.Wiggle.spam = v end)

    sec("Auto Flee Killer", "🏃")
    tog("Auto Flee", false, function(s) S.Flee.on = s end)
    sl("Detect Distance", 10, 200, 50, function(v) S.Flee.dist = v end)

    sec("Moonwalk", "🌙")
    tog("Enable Moonwalk", false, function(s)
        S.Moonwalk.on = s
        if s then startMoonwalk() else stopMoonwalk() end
    end)
    sl("Spam Speed", 1, 100, 30, function(v) S.Moonwalk.spam = v end)
    sl("Intensity", 1, 90, 35, function(v) S.Moonwalk.intensity = v end)
    sl("Slow Speed", 5, 30, 13, function(v) S.Moonwalk.slow = v end)

    sec("Moonwalk Button", "🌙")
    tog("Show Moonwalk Button", false, function(s) if s then mkMoonBtn() else rmMoonBtn() end end)
    tog("🔒 Lock Moonwalk Button", false, function(s) S.Moonwalk.locked = s end)
    btn("🔄 Reset Posisi Moonwalk", function()
        if S.Buttons.moonGui then
            local b = S.Buttons.moonGui:FindFirstChildWhichIsA("TextButton")
            if b then b.Position = UDim2.new(0.65, 0, 0.75, 0) end
        end
    end)

    sec("God Mode", "🛡️")
    tog("Anti Knockdown", false, function(s) S.GodMode.on = s end)
end)

-- TAB ESP
makeTab("ESP", "👁️", 4, function()
    sec("Survivor ESP", "🟢")
    tog("ESP Survivor", false, function(s) S.ESP.surv = s end)
    cpk("Survivor Color", S.ESP.sc, function(c) S.ESP.sc = c end)

    sec("Killer ESP", "🔴")
    tog("ESP Killer", false, function(s) S.ESP.killer = s end)
    cpk("Killer Color", S.ESP.kc, function(c) S.ESP.kc = c end)

    sec("Generator ESP", "⚡")
    tog("ESP Generator", false, function(s) S.ESP.gen = s end)
    cpk("Generator Color", S.ESP.gc, function(c) S.ESP.gc = c end)

    sec("ESP Status", "📊")
    tog("Show Name", true, function(s) S.ESP.name = s end)
    tog("Show Distance", true, function(s) S.ESP.dist = s end)
    tog("Show Health", false, function(s) S.ESP.hp = s end)
    sl("ESP Radius", 50, 1000, 100, function(v) S.ESP.radius = v end)
end)

-- TAB VISUAL
makeTab("Visual", "🎨", 5, function()
    sec("Lighting", "☀️")
    tog("Fullbright", false, function(s) S.Visual.fb = s; applyVisual() end)
    tog("No Fog", false, function(s) S.Visual.nofog = s; applyVisual() end)

    sec("Contrast & Sharpen", "🔍")
    tog("Enable Contrast", false, function(s) S.Visual.contrast = s; applyVisual() end)
    sl("Contrast", -1, 2, 0.3, function(v) S.Visual.cv = v; applyVisual() end)
    sl("Brightness", -1, 1, 0.15, function(v) S.Visual.bv = v; applyVisual() end)
    sl("Saturation", -1, 1, 0.2, function(v) S.Visual.sv = v; applyVisual() end)

    sec("Fire Effect (5 Varian)", "🔥")
    tog("Enable Fire", false, function(s) S.Visual.fire = s; applyFire() end)
    drp("Fire Type", {"Red", "Blue", "Green", "Purple", "Rainbow"}, "Red", function(v)
        S.Visual.fireType = v
        applyFire()
    end)
end)

-- TAB MOVEMENT
makeTab("Movement", "🏃", 6, function()
    sec("Speed", "⚡")
    tog("Walk Speed", false, function(s)
        S.Move.speedOn = s
        if not s then
            local hum = getHum()
            if hum then hum.WalkSpeed = 16 end
        end
    end)
    sl("Speed Value", 16, 100, 17.6, function(v) S.Move.speed = v end)

    tog("Jump Power", false, function(s)
        S.Move.jumpOn = s
        if not s then
            local hum = getHum()
            if hum then hum.JumpPower = 50 end
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

-- TAB SETTINGS
makeTab("Settings", "⚙️", 7, function()
    sec("Keybind", "⌨️")
    lbl("RightShift = Toggle Menu", C.ACC2)
    lbl("Klik kanan = Aimlock", C.ACC2)

    sec("Script", "🚪")
    btn("🔄 Reset Semua Fitur", function()
        for k, v in pairs(S) do
            if type(v) == "table" and v.on ~= nil then v.on = false end
        end
        notify("Semua fitur direset!")
    end)
    btn("🚪 Unload Script", function()
        gui:Destroy()
    end)

    sec("Info", "ℹ️")
    lbl("Version: 3.0 Final", C.ACC3)
end)

-- =========================================================
-- FPS/PING
-- =========================================================
local fpsLbl = Instance.new("TextLabel")
fpsLbl.Size = UDim2.new(0, 140, 0, 20)
fpsLbl.Position = UDim2.new(0.5, -70, 0, 5)
fpsLbl.BackgroundColor3 = C.PANEL
fpsLbl.BackgroundTransparency = 0.4
fpsLbl.Text = "FPS: -- | PING: --"
fpsLbl.TextColor3 = C.ACC2
fpsLbl.TextSize = 11
fpsLbl.Font = Enum.Font.GothamBold
fpsLbl.TextStrokeTransparency = 0.5
fpsLbl.Parent = gui
rnd(fpsLbl, 6)
strk(fpsLbl, C.ACC, 1, 0.5)

local fCnt = 0
local tAcc = 0
RunService.RenderStepped:Connect(function(dt)
    fCnt = fCnt + 1
    tAcc = tAcc + dt
    if tAcc >= 1 then
        local fps = math.floor(fCnt / tAcc)
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        if S.FPS.show then
            fpsLbl.Text = string.format("FPS: %d | PING: %d ms", fps, ping)
        end
        fCnt = 0
        tAcc = 0
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
            -- ESP UPDATE
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
                                        createESP(char, S.ESP.sc)
                                    elseif S.ESP.killer and p.Team and p.Team.Name == "Killer" then
                                        createESP(char, S.ESP.kc)
                                    else
                                        removeESP(char)
                                    end
                                else
                                    removeESP(char)
                                end
                            end
                            createStatusESP(p, char, root)
                        else
                            removeESP(char)
                            removeStatusESP(char)
                        end
                    end
                end

                -- Generator ESP
                if S.ESP.gen then
                    for gen in pairs(Cached.Generators) do
                        if gen and gen.Parent then
                            local primary = gen.PrimaryPart or gen:FindFirstChildWhichIsA("BasePart")
                            if primary then
                                local dist = (primary.Position - root.Position).Magnitude
                                if dist <= S.ESP.radius then
                                    createESP(gen, S.ESP.gc)
                                else
                                    removeESP(gen)
                                end
                            end
                        end
                    end
                end
            end

            -- Auto Attack
            if S.AutoAtk.on and now - S.AutoAtk.last >= S.AutoAtk.delay then
                S.AutoAtk.last = now
                if AttackEvent then pcall(function() AttackEvent:FireServer(false) end) end
            end

            -- God Mode
            if S.GodMode.on then
                local hum = getHum()
                if hum and hum.Health < hum.MaxHealth then
                    pcall(function() hum.Health = hum.MaxHealth end)
                end
            end

            -- Anti Stun
            applyAntiStun()

            -- Walk Speed
            if S.Move.speedOn then
                local hum = getHum()
                if hum and hum.WalkSpeed ~= S.Move.speed then
                    hum.WalkSpeed = S.Move.speed
                end
            end

            -- Jump Power
            if S.Move.jumpOn then
                local hum = getHum()
                if hum and hum.JumpPower ~= S.Move.jump then
                    hum.JumpPower = S.Move.jump
                end
            end

            -- NoClip
            if S.Move.noclip and LP.Character then
                for _, p in pairs(LP.Character:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
                end
            end

            -- Hitbox
            if S.Hitbox.on and now - lastHB >= 0.3 then
                lastHB = now
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        if plr.Team and plr.Team.Name == "Survivors" then
                            applyHB(plr.Character)
                        end
                    end
                end
            end

            -- Fire Effect
            if S.Visual.fire then applyFire() end

            -- Scan Killers Parry
            if S.Parry.on and now - lastParry >= 2 then
                lastParry = now
                scanKillers()
            end
        end

        -- Slow Loop
        if now - lastSlow >= 0.5 then
            lastSlow = now
            if S.Flee.on then runFlee() end
            if S.Wiggle.on then runWiggle() end
        end

        -- GenBoost Loop
        if S.GenBoost.on then runGenBoost() end

        task.wait(0.1)
    end
end)

-- =========================================================
-- RESPAWN HANDLER
-- =========================================================
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    ParryActive = false
    hookedKillers = {}
    if S.Visual.fire then applyFire() end
    if S.Moonwalk.on then startMoonwalk() end
    if S.Parry.on then scanKillers() end
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
-- NEON ANIMASI
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
-- FINAL PRINT
-- =========================================================
print("=====================================================")
print("✅ [5/5] FINAL - Main Loop loaded")
print("🎉 ROOORHUB ULTIMATE - LOADED SUCCESSFULLY!")
print("=====================================================")
print("⌨️  RightShift = Toggle Menu")
print("🎯 Klik kanan = Aimlock")
print("🌙 Moonwalk = Konsisten Lobby & Ingame")
print("⚡ GenBoost = Tombol tersedia")
print("🔒 Lock Button = Kunci posisi tombol")
print("=====================================================")
