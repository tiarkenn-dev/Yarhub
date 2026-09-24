-- =========================================================
-- ROOORHUB FINAL - BAGIAN 1/6 : CORE + CONFIG
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
local PlayerGui = LP:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

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
    Aimlock = { on = false, hold = false, target = "Survivor", part = "Head", fov = 250, radius = 500, predict = 0.12, smooth = 0.5 },
    AutoAtk = { on = false, delay = 0.35, last = 0 },
    KillAll = { on = false },
    Hitbox = { on = false, size = 15, onlySurv = true },
    AntiStun = { on = false },
    Parry = { on = false, dist = 12, face = 0.7, last = 0 },
    ParryCircle = { on = false, size = 12, color = Color3.fromRGB(255, 80, 80) },
    SkillCheck = { on = false },
    Wiggle = { on = false, spam = 5 },
    Flee = { on = false, dist = 50, last = 0 },
    Moonwalk = { on = false, spam = 30, intensity = 35, slow = 13 },
    GodMode = { on = false },
    ESP = { surv = false, survColor = Color3.fromRGB(60, 255, 120), killer = false, killerColor = Color3.fromRGB(255, 60, 60), gen = false, genColor = Color3.fromRGB(255, 170, 0), name = true, dist = true, hp = false, radius = 100 },
    Visual = { fullbright = false, nofog = false, fire = false, fireType = "Red" },
    Move = { speedOn = false, speed = 17.6, jumpOn = false, jump = 50, noclip = false },
    Avatar = { target = "", original = nil, uid = nil },
    FPS = { show = true },
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

function getRoot() local ch = LP.Character; return ch and ch:FindFirstChild("HumanoidRootPart") end
function getHum() local ch = LP.Character; return ch and ch:FindFirstChildOfClass("Humanoid") end
function isDowned()
    local ch = LP.Character; if not ch then return false end
    local h = ch:FindFirstChildOfClass("Humanoid"); if not h then return false end
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
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,100,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,150)),
    }
end

print("✅ BAGIAN 1/6 loaded")-- =========================================================
-- BAGIAN 2/6 : GUI + TAB SYSTEM
-- =========================================================

local gui = Instance.new("ScreenGui")
gui.Name = "RoooorHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- Float Button
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 40, 0, 40)
floatBtn.Position = UDim2.new(0, 15, 0.5, -20)
floatBtn.BackgroundColor3 = C.PANEL
floatBtn.Text = "⚡"
floatBtn.TextColor3 = C.ACCENT2
floatBtn.TextSize = 22
floatBtn.Font = Enum.Font.GothamBold
floatBtn.BorderSizePixel = 0
floatBtn.AutoButtonColor = false
floatBtn.Parent = gui
rnd(floatBtn, 20)
strk(floatBtn, C.ACCENT, 2)

local fName = Instance.new("TextLabel")
fName.Size = UDim2.new(0, 100, 0, 20)
fName.Position = UDim2.new(0.5, -50, 1, 2)
fName.BackgroundTransparency = 1
fName.Text = "ROOORHUB"
fName.TextColor3 = Color3.new(1,1,1)
fName.TextSize = 12
fName.Font = Enum.Font.GothamBlack
fName.TextStrokeTransparency = 0
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

-- Main
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 460, 0, 340)
main.Position = UDim2.new(0.5, -230, 0.5, -170)
main.BackgroundColor3 = C.BG
main.BackgroundTransparency = 0.05
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui
rnd(main, 14)
strk(main, C.ACCENT, 2, 0.2)

-- Header
local head = Instance.new("Frame")
head.Size = UDim2.new(1, 0, 0, 40)
head.BackgroundColor3 = C.PANEL
head.BackgroundTransparency = 0.1
head.BorderSizePixel = 0
head.Parent = main
rnd(head, 14)

local headPatch = Instance.new("Frame")
headPatch.Size = UDim2.new(1, 0, 0, 18)
headPatch.Position = UDim2.new(0, 0, 1, -18)
headPatch.BackgroundColor3 = C.PANEL
headPatch.BackgroundTransparency = 0.1
headPatch.BorderSizePixel = 0
headPatch.Parent = head

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
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ ROOORHUB"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 15
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextStrokeTransparency = 0
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
closeB.Size = UDim2.new(0, 22, 0, 22)
closeB.Position = UDim2.new(1, -30, 0.5, -11)
closeB.BackgroundColor3 = C.PANEL
closeB.Text = "✕"
closeB.TextColor3 = C.DANGER
closeB.TextSize = 13
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

floatBtn.MouseButton1Click:Connect(function()
    floatBtn.Visible = false
    main.Visible = true
end)

-- Sidebar
local sb = Instance.new("Frame")
sb.Size = UDim2.new(0, 110, 1, -60)
sb.Position = UDim2.new(0, 10, 0, 50)
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

-- Content
local ct = Instance.new("Frame")
ct.Size = UDim2.new(1, -140, 1, -60)
ct.Position = UDim2.new(0, 130, 0, 50)
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

print("✅ BAGIAN 2/6 loaded")-- =========================================================
-- BAGIAN 3/6 : UI COMPONENTS
-- =========================================================

function sec(title, icon)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 20)
    f.BackgroundTransparency = 1
    f.Parent = cs
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 1, 0)
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
    local cb2 = Instance.new("TextButton")
    cb2.Size = UDim2.new(1, 0, 1, 0)
    cb2.BackgroundTransparency = 1
    cb2.Text = ""
    cb2.Parent = t

    cb2.MouseButton1Click:Connect(function()
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

    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 10, 0, 10)
    kn.Position = UDim2.new((def - min) / (max - min), -5, 0.5, -5)
    kn.BackgroundColor3 = C.TEXT
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

    local cb2 = Instance.new("TextButton")
    cb2.Size = UDim2.new(1, 0, 1, 0)
    cb2.BackgroundTransparency = 1
    cb2.Text = ""
    cb2.Parent = f

    local idx = 1
    for i, o in ipairs(options) do if o == cur then idx = i end end

    cb2.MouseButton1Click:Connect(function()
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

print("✅ BAGIAN 3/6 loaded")-- =========================================================
-- BAGIAN 4/6 : FITUR LOGIC
-- =========================================================

-- ESP
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
    if ESPObjs[obj] then
        ESPObjs[obj]:Destroy()
        ESPObjs[obj] = nil
    end
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

    local tc = Color3.new(1,1,1)
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
        lb.Font = Enum.Font.GothamBold
        lb.TextSize = 12
        lb.Text = text
        lb.Parent = bb
        ESPBbs[char] = bb
    else
        local lb = bb:FindFirstChildOfClass("TextLabel")
        if lb then
            lb.Text = text
            lb.TextColor3 = tc
        end
    end
end

function rmESPBB(char)
    if ESPBbs[char] then ESPBbs[char]:Destroy(); ESPBbs[char] = nil end
end

-- Aimlock
function getAimTarget()
    local cam = Camera
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
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
                        local pos, vis = cam:WorldToViewportPoint(hrp.Position)
                        if vis then
                            local sd = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                            if sd < shortest then
                                shortest = sd
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
        local cf = CFrame.new(Camera.CFrame.Position, pos)
        Camera.CFrame = Camera.CFrame:Lerp(cf, S.Aimlock.smooth)
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

-- Hitbox
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

-- Anti Stun
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

-- AUTO PARRY (Fallens)
_G.ParryActive = false
_G.HookedKillers = {}

local function pressRC()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
end

local function getParryBtn()
    local cur = PlayerGui
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
    if now - S.Parry.last < 0.2 then return end
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
            if isInRange(char) then doParry() end
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

-- Parry Circle
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
    c.Transparency = 0.7
end

-- AUTO SKILL CHECK (Fallens)
local skillConn = nil
local skillBusy = false

local function pressSpace()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local function getActionTarget()
    local cur = PlayerGui
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
        local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
        if not prompt then return end
        local check = prompt:FindFirstChild("Check")
        if not check or not check.Visible then return end
        local line = check:FindFirstChild("Line")
        local goal = check:FindFirstChild("Goal")
        if not line or not goal then return end

        local lr = line.Rotation % 360
        local gr = goal.Rotation % 360
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

-- MOONWALK (Fallens)
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

        if hum.WalkSpeed ~= S.Moonwalk.slow then
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

-- Auto Wiggle
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

-- Auto Flee
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

-- Fire Effect
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

-- Visual
local origL = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows,
}

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
end

-- Avatar Stealer (Fallens)
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
    if not ok then return end
    S.Avatar.uid = uid
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    task.spawn(function()
        local d = Players:GetHumanoidDescriptionFromUserId(uid)
        applyBlocky(char)
        task.wait(0.3)
        removeAcc(char)
        task.wait(0.2)
        hum:ApplyDescriptionClientServer(d)
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
    end
end

-- Teleport
function tpPlayer(name)
    local t = Players:FindFirstChild(name)
    if t and t.Character and LP.Character then
        local tHRP = t.Character:FindFirstChild("HumanoidRootPart")
        local mHRP = LP.Character:FindFirstChild("HumanoidRootPart")
        if tHRP and mHRP then mHRP.CFrame = tHRP.CFrame + Vector3.new(0, 3, 0) end
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
    if closest then root.CFrame = closest.CFrame + Vector3.new(0, 5, 0) end
end

-- Auto Save Config
local HttpService = game:GetService("HttpService")

function saveCfg()
    local data = {
        Aimlock = S.Aimlock.on,
        Parry = S.Parry.on,
        SkillCheck = S.SkillCheck.on,
        Wiggle = S.Wiggle.on,
        Flee = S.Flee.on,
        Moonwalk = S.Moonwalk.on,
        GodMode = S.GodMode.on,
        ESP = { surv = S.ESP.surv, killer = S.ESP.killer, gen = S.ESP.gen, name = S.ESP.name, dist = S.ESP.dist, hp = S.ESP.hp },
        Visual = { fullbright = S.Visual.fullbright, nofog = S.Visual.nofog, fire = S.Visual.fire, fireType = S.Visual.fireType },
        Move = { speedOn = S.Move.speedOn, jumpOn = S.Move.jumpOn, noclip = S.Move.noclip },
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
            if d.ESP then
                S.ESP.surv = d.ESP.surv or false
                S.ESP.killer = d.ESP.killer or false
                S.ESP.gen = d.ESP.gen or false
                S.ESP.name = d.ESP.name ~= false
                S.ESP.dist = d.ESP.dist ~= false
                S.ESP.hp = d.ESP.hp or false
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

task.spawn(function() task.wait(1); loadCfg() end)
task.spawn(function()
    while gui.Parent do
        task.wait(10)
        saveCfg()
    end
end)
game:BindToClose(function() saveCfg() end)

print("✅ BAGIAN 4/6 loaded")-- =========================================================
-- BAGIAN 5/6 : ISI TAB
-- =========================================================

-- TAB 1 : INFO
local tInfo = makeTab("Info", "ℹ️", 1, function()
    sec("Script Info", "📋")
    lbl("RoooorHub Final", C.ACCENT2)
    lbl("Status: Active", C.OK)
    lbl("Dev: Roooor", C.TEXT)

    sec("FPS/Ping", "🌊")
    tog("Show FPS/Ping", true, function(s)
        S.FPS.show = s
    end)

    sec("Floating Buttons", "🔘")
    tog("Show Aimlock Button", false, function(s)
        if s then mkAimBtn() else rmAimBtn() end
    end)
    tog("Show Moonwalk Button", false, function(s)
        if s then mkMoonBtn() else rmMoonBtn() end
    end)
end)

-- TAB 2 : KILLER
local tKiller = makeTab("Killer", "🔪", 2, function()
    sec("Aimlock", "🎯")
    tog("Enable Aimlock", false, function(s)
        S.Aimlock.on = s
        if s then startAimlock() end
    end)
    drp("Target", {"Survivor", "Killer"}, "Survivor", function(v) S.Aimlock.target = v end)
    drp("Part", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(v) S.Aimlock.part = v end)
    sl("FOV", 50, 1000, 250, function(v) S.Aimlock.fov = v end)
    sl("Radius", 50, 1000, 500, function(v) S.Aimlock.radius = v end)
    sl("Predict", 0, 1, 0.12, function(v) S.Aimlock.predict = v end)
    sl("Smooth", 0.05, 1, 0.5, function(v) S.Aimlock.smooth = v end)

    sec("Auto Attack", "⚔️")
    tog("Auto Spam Attack", false, function(s) S.AutoAtk.on = s end)
    sl("Attack Delay", 0.1, 2, 0.35, function(v) S.AutoAtk.delay = v end)
    tog("Auto Kill All", false, function(s) S.KillAll.on = s end)

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
    tog("Only Survivors", true, function(s) S.Hitbox.onlySurv = s end)

    sec("Anti Stun", "💪")
    tog("Anti Stun", false, function(s) S.AntiStun.on = s end)
end)

-- TAB 3 : SURVIVOR
local tSurv = makeTab("Survivor", "🏃", 3, function()
    sec("Auto Parry", "🛡️")
    tog("Enable Auto Parry", false, function(s)
        S.Parry.on = s
        if s then scanKillers() end
    end)
    sl("Parry Distance", 5, 25, 12, function(v) S.Parry.dist = v end)
    sl("Face Sensitivity", -1, 1, 0.7, function(v) S.Parry.face = v end)

    sec("Parry Circle", "🔵")
    tog("Show Parry Circle", false, function(s) S.ParryCircle.on = s end)
    sl("Circle Size", 5, 50, 12, function(v) S.ParryCircle.size = v end)
    cpk("Circle Color", S.ParryCircle.color, function(c) S.ParryCircle.color = c end)

    sec("Auto Skill Check", "🎯")
    tog("Enable Skill Check", false, function(s)
        S.SkillCheck.on = s
        if s then startSkillCheck() end
    end)

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

    sec("God Mode", "🛡️")
    tog("Anti Knockdown", false, function(s) S.GodMode.on = s end)
end)

-- TAB 4 : ESP
local tESP = makeTab("ESP", "👁️", 4, function()
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
    sl("ESP Radius", 50, 1000, 100, function(v) S.ESP.radius = v end)
end)

-- TAB 5 : VISUAL
local tVisual = makeTab("Visual", "🎨", 5, function()
    sec("Lighting", "☀️")
    tog("Fullbright", false, function(s) S.Visual.fullbright = s; applyVisual() end)
    tog("No Fog", false, function(s) S.Visual.nofog = s; applyVisual() end)

    sec("Fire Effect", "🔥")
    tog("Enable Fire", false, function(s) S.Visual.fire = s; applyFire() end)
    drp("Fire Type", {"Red", "Blue", "Green", "Purple", "Rainbow"}, "Red", function(v)
        S.Visual.fireType = v
        applyFire()
    end)
end)

-- TAB 6 : MOVEMENT
local tMove = makeTab("Movement", "🏃", 6, function()
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

-- TAB 7 : AVATAR
local tAvatar = makeTab("Avatar", "🎭", 7, function()
    sec("Steal Avatar", "🎭")
    lbl("Masukin username target", C.ACCENT2)

    local inputF = Instance.new("Frame")
    inputF.Size = UDim2.new(1, -4, 0, 28)
    inputF.BackgroundColor3 = C.BG
    inputF.BackgroundTransparency = 0.3
    inputF.BorderSizePixel = 0
    inputF.Parent = cs
    rnd(inputF, 8)
    strk(inputF, C.ACCENT2, 1, 0.7)

    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(1, -16, 1, 0)
    tb.Position = UDim2.new(0, 8, 0, 0)
    tb.BackgroundTransparency = 1
    tb.Text = ""
    tb.PlaceholderText = "Ketik username..."
    tb.TextColor3 = C.TEXT
    tb.PlaceholderColor3 = C.DIM
    tb.TextSize = 10
    tb.Font = Enum.Font.GothamMedium
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.ClearTextOnFocus = false
    tb.Parent = inputF

    tb.FocusLost:Connect(function()
        S.Avatar.target = tb.Text
    end)

    btn("🎭 Copy Avatar", function()
        if S.Avatar.target == "" then S.Avatar.target = tb.Text end
        copyAvatar(S.Avatar.target)
    end)
    btn("🔄 Reset Avatar", function() resetAvatar() end)
    btn("💾 Save Avatar Skrg", function() saveAvatar() end)
end)

-- TAB 8 : SETTINGS
local tSet = makeTab("Settings", "⚙️", 8, function()
    sec("Keybind", "⌨️")
    lbl("RightShift = Toggle Menu", C.ACCENT2)
    lbl("Klik kanan = Aimlock", C.ACCENT2)

    sec("Config Save", "💾")
    btn("💾 Save Config Skrg", function() saveCfg() end)
    btn("📂 Load Config", function() loadCfg() end)
    btn("🗑️ Reset Config", function()
        if delfile and isfile("RoooorHub_Cfg.json") then
            delfile("RoooorHub_Cfg.json")
        end
    end)

    sec("Script", "🚪")
    btn("🔄 Reset Semua Fitur", function()
        for k, v in pairs(S) do
            if type(v) == "table" and v.on ~= nil then v.on = false end
        end
    end)
    btn("🚪 Unload Script", function()
        saveCfg()
        gui:Destroy()
    end)
end)

print("✅ BAGIAN 5/6 loaded")-- =========================================================
-- BAGIAN 6/6 : MAIN LOOP + FPS/PING + FLOATING + KEYBIND
-- =========================================================

-- FLOATING BUTTONS
function mkAimBtn()
    if S.FloatingButtons and S.FloatingButtons.Aimlock and S.FloatingButtons.Aimlock.Gui then
        S.FloatingButtons.Aimlock.Gui:Destroy()
    end
    local guiA = Instance.new("ScreenGui")
    guiA.Name = "Roooor_AimBtn"
    guiA.ResetOnSpawn = false
    guiA.IgnoreGuiInset = true
    guiA.Parent = PlayerGui

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 44, 0, 44)
    b.Position = UDim2.new(0.35, 0, 0.75, 0)
    b.BackgroundColor3 = C.PANEL
    b.Text = "🎯"
    b.TextColor3 = C.TEXT
    b.TextSize = 20
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = guiA
    rnd(b, 22)
    local bs = strk(b, C.ACCENT2, 2)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0, 100, 0, 12)
    l.Position = UDim2.new(0.5, -50, 1, 1)
    l.BackgroundTransparency = 1
    l.Text = "AIMLOCK"
    l.TextColor3 = C.ACCENT2
    l.TextSize = 9
    l.Font = Enum.Font.GothamBlack
    l.TextStrokeTransparency = 0.3
    l.Parent = b

    local drag = false
    local ds, dp
    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true
            ds = input.Position
            dp = b.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - ds
            b.Position = UDim2.new(dp.X.Scale, dp.X.Offset + d.X, dp.Y.Scale, dp.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)

    b.MouseButton1Click:Connect(function()
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

    if not S.FloatingButtons then S.FloatingButtons = {} end
    S.FloatingButtons.Aimlock = { Gui = guiA, Button = b }
end

function rmAimBtn()
    if S.FloatingButtons and S.FloatingButtons.Aimlock and S.FloatingButtons.Aimlock.Gui then
        S.FloatingButtons.Aimlock.Gui:Destroy()
        S.FloatingButtons.Aimlock = nil
    end
end

function mkMoonBtn()
    if S.FloatingButtons and S.FloatingButtons.Moonwalk and S.FloatingButtons.Moonwalk.Gui then
        S.FloatingButtons.Moonwalk.Gui:Destroy()
    end
    local guiM = Instance.new("ScreenGui")
    guiM.Name = "Roooor_MoonBtn"
    guiM.ResetOnSpawn = false
    guiM.IgnoreGuiInset = true
    guiM.Parent = PlayerGui

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 44, 0, 44)
    b.Position = UDim2.new(0.65, 0, 0.75, 0)
    b.BackgroundColor3 = C.PANEL
    b.Text = "🌙"
    b.TextColor3 = C.TEXT
    b.TextSize = 20
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = guiM
    rnd(b, 22)
    local bs = strk(b, C.ACCENT2, 2)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0, 100, 0, 12)
    l.Position = UDim2.new(0.5, -50, 1, 1)
    l.BackgroundTransparency = 1
    l.Text = "MOONWALK"
    l.TextColor3 = C.ACCENT2
    l.TextSize = 9
    l.Font = Enum.Font.GothamBlack
    l.TextStrokeTransparency = 0.3
    l.Parent = b

    local drag = false
    local ds, dp
    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true
            ds = input.Position
            dp = b.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - ds
            b.Position = UDim2.new(dp.X.Scale, dp.X.Offset + d.X, dp.Y.Scale, dp.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)

    b.MouseButton1Click:Connect(function()
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
            if hum then hum.WalkSpeed = 16 end
        end
    end)

    if not S.FloatingButtons then S.FloatingButtons = {} end
    S.FloatingButtons.Moonwalk = { Gui = guiM, Button = b }
end

function rmMoonBtn()
    if S.FloatingButtons and S.FloatingButtons.Moonwalk and S.FloatingButtons.Moonwalk.Gui then
        S.FloatingButtons.Moonwalk.Gui:Destroy()
        S.FloatingButtons.Moonwalk = nil
    end
end

-- FPS/PING
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

-- MAIN LOOP
local lastESP = 0
local lastParry = 0
local lastHB = 0
local lastSlow = 0

task.spawn(function()
    while gui.Parent do
        local now = tick()
        local root = getRoot()
        if root then
            -- ESP
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
                            local part = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                            if part and part:IsA("BasePart") then
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

            -- Auto Attack
            if S.AutoAtk.on and now - S.AutoAtk.last >= S.AutoAtk.delay then
                S.AutoAtk.last = now
                if AttackEvent then pcall(function() AttackEvent:FireServer(false) end) end
            end

            -- Kill All
            if S.KillAll.on then
                local target = getNearest("Survivors", 500)
                if target then
                    local tHRP = target:FindFirstChild("HumanoidRootPart")
                    if tHRP then
                        local tp = tHRP.Position + (tHRP.AssemblyLinearVelocity * 0.15)
                        local behind = tHRP.CFrame.LookVector * -3
                        root.CFrame = CFrame.new(tp + behind, tp)
                        if AttackEvent then pcall(function() AttackEvent:FireServer(false) end) end
                    end
                end
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

            -- Jump
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
                        if S.Hitbox.onlySurv then
                            if plr.Team and plr.Team.Name == "Survivors" then applyHB(plr.Character) end
                        else
                            applyHB(plr.Character)
                        end
                    end
                end
            end

            -- Fire
            if S.Visual.fire then applyFire() end

            -- Parry Circle
            updParryCircle()

            -- Scan Killers Parry
            if S.Parry.on and now - lastParry >= 2 then
                lastParry = now
                scanKillers()
            end
        end

        -- Slow loop
        if now - lastSlow >= 0.5 then
            lastSlow = now
            if S.Flee.on then runFlee() end
            if S.Wiggle.on then runWiggle() end
        end

        task.wait(0.1)
    end
end)

-- RESPAWN
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    _G.ParryActive = false
    _G.HookedKillers = {}
    if S.Visual.fire then applyFire() end
    if S.Moonwalk.on then startMoonwalk() end
    if S.Parry.on then scanKillers() end
end)

-- KEYBIND
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

-- BUKA TAB PERTAMA
task.wait(0.3)
if tInfo then tInfo.MouseButton1Click:Fire() end

-- NEON ANIMASI
task.spawn(function()
    while main.Parent do
        task.wait(0.05)
        local hue = (tick() * 0.3) % 1
        main.BackgroundColor3 = C.BG
    end
end)

print("=====================================================")
print("✅ [ROOORHUB] BAGIAN 6/6 loaded")
print("🎉 ROOORHUB FINAL - LOADED SUCCESSFULLY!")
print("=====================================================")
print("⌨️  RightShift = Toggle Menu")
print("🎯 Klik kanan = Aimlock")
print("🌙 Moonwalk = Konsisten")
print("💾 Auto Save Config = AKTIF")
print("=====================================================")
