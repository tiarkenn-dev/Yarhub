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

-- STATE (PAKAI _G BIAR GAK KE-RESET)
_G.RoooorS = _G.RoooorS or {
    FireOn = false,
    FireType = "Classic",
    FireSize = 5,
    ESP_Name = false,
    ESP_Size = 12,
    ESP_Radius = 500,
    Parry = false,
    ParryDist = 15,
    ParryCircle = false,
    ParryCircleSize = 15,
    Skill = false,
    UltraHD = false,
    Contrast = false,
    ContrastVal = 0.3,
    BrightnessVal = 0.1,
    SaturationVal = 0.2,
    FPS = true,
}

local S = _G.RoooorS

-- TOGGLE STATE TRACKER
_G.ToggleStates = _G.ToggleStates or {}
_G.ToggleObjects = _G.ToggleObjects or {}

-- 20 FIRE VARIANTS
local FireList = {
    "Classic", "Rainbow", "Lightning", "Hell", "Ice",
    "Toxic", "Void", "GoldenKing", "Sakura", "Emerald",
    "Blood", "Shadow", "Holy", "Ocean", "Firework",
    "Lava", "Ghost", "Cosmic", "Dragon", "Mystery"
}

local FireConfig = {
    Classic = { c1 = Color3.fromRGB(255, 100, 0), c2 = Color3.fromRGB(255, 200, 0) },
    Rainbow = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 255, 255), rainbow = true },
    Lightning = { c1 = Color3.fromRGB(100, 200, 255), c2 = Color3.fromRGB(255, 255, 255), spark = true },
    Hell = { c1 = Color3.fromRGB(150, 0, 0), c2 = Color3.fromRGB(255, 50, 0), smoke = true, smokeColor = Color3.fromRGB(20, 20, 20) },
    Ice = { c1 = Color3.fromRGB(100, 200, 255), c2 = Color3.fromRGB(200, 240, 255), spark = true },
    Toxic = { c1 = Color3.fromRGB(0, 255, 50), c2 = Color3.fromRGB(150, 255, 0), smoke = true, smokeColor = Color3.fromRGB(50, 200, 50) },
    Void = { c1 = Color3.fromRGB(80, 0, 150), c2 = Color3.fromRGB(200, 0, 255), spark = true },
    GoldenKing = { c1 = Color3.fromRGB(255, 215, 0), c2 = Color3.fromRGB(255, 255, 100), spark = true },
    Sakura = { c1 = Color3.fromRGB(255, 150, 200), c2 = Color3.fromRGB(255, 200, 230), spark = true },
    Emerald = { c1 = Color3.fromRGB(0, 200, 100), c2 = Color3.fromRGB(100, 255, 150) },
    Blood = { c1 = Color3.fromRGB(200, 0, 0), c2 = Color3.fromRGB(100, 0, 0), smoke = true, smokeColor = Color3.fromRGB(80, 0, 0) },
    Shadow = { c1 = Color3.fromRGB(20, 20, 30), c2 = Color3.fromRGB(80, 0, 100), smoke = true, smokeColor = Color3.fromRGB(40, 0, 60) },
    Holy = { c1 = Color3.fromRGB(255, 255, 255), c2 = Color3.fromRGB(255, 255, 200), spark = true },
    Ocean = { c1 = Color3.fromRGB(0, 100, 255), c2 = Color3.fromRGB(100, 200, 255) },
    Firework = { c1 = Color3.fromRGB(255, 0, 100), c2 = Color3.fromRGB(255, 200, 0), rainbow = true, spark = true },
    Lava = { c1 = Color3.fromRGB(255, 80, 0), c2 = Color3.fromRGB(100, 20, 0), smoke = true, smokeColor = Color3.fromRGB(60, 30, 0) },
    Ghost = { c1 = Color3.fromRGB(200, 200, 255), c2 = Color3.fromRGB(255, 255, 255) },
    Cosmic = { c1 = Color3.fromRGB(50, 0, 100), c2 = Color3.fromRGB(255, 100, 200), spark = true, rainbow = true },
    Dragon = { c1 = Color3.fromRGB(255, 50, 0), c2 = Color3.fromRGB(255, 200, 0), smoke = true, smokeColor = Color3.fromRGB(100, 50, 0) },
    Mystery = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 255, 255), rainbow = true },
}

-- 23 KILLER ANIMS
local KillerAnims = {}
for _, id in ipairs({
    "105374834496520","113255068724446","118907603246885","129784271201071",
    "117042998468241","122812055447896","78935059863801","74968262036854",
    "78432063483146","132817836308238","133963973694098","111920872708571",
    "80411309607666","98163597193511","82666958311998","110355011987939",
    "139369275981139","135002183282873","121216847022485","130593238885843",
    "117070354890871","106871536134254","138720291317243"
}) do KillerAnims["rbxassetid://"..id] = true end

function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

function rnd(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = o
end

function strk(o, col, t)
    local s = Instance.new("UIStroke")
    s.Color = col or C.ACC
    s.Thickness = t or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = o
    return s
end

function rainbowSeq()
    return ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,100,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,150)),
    }
end

print("✅ [1/5] Core loaded")-- =========================================================
-- ROOORHUB - BAGIAN 2/5 : GUI + COMPONENTS + STATE SYNC
-- =========================================================

local gui = Instance.new("ScreenGui")
gui.Name = "RoooorHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
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
fName.Size = UDim2.new(0, 110, 0, 20)
fName.Position = UDim2.new(0.5, -55, 1, 2)
fName.BackgroundTransparency = 1
fName.Text = "ROOORHUB"
fName.TextColor3 = Color3.new(1,1,1)
fName.TextSize = 11
fName.Font = Enum.Font.GothamBlack
fName.TextStrokeTransparency = 0
fName.TextStrokeColor3 = Color3.new(0,0,0)
fName.Parent = floatBtn
local fGrad = Instance.new("UIGradient")
fGrad.Color = rainbowSeq()
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

-- DRAG
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
main.Size = UDim2.new(0, 420, 0, 400)
main.Position = UDim2.new(0.5, -210, 0.5, -200)
main.BackgroundColor3 = C.BG
main.BackgroundTransparency = 0.05
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui
rnd(main, 14)
local mainStrk = strk(main, C.ACC, 2)

-- HEADER
local head = Instance.new("Frame")
head.Size = UDim2.new(1, 0, 0, 42)
head.BackgroundColor3 = C.PANEL
head.BorderSizePixel = 0
head.Parent = main
rnd(head, 14)

local hPatch = Instance.new("Frame")
hPatch.Size = UDim2.new(1, 0, 0, 20)
hPatch.Position = UDim2.new(0, 0, 1, -20)
hPatch.BackgroundColor3 = C.PANEL
hPatch.BorderSizePixel = 0
hPatch.Parent = head

local nLine = Instance.new("Frame")
nLine.Size = UDim2.new(1, -30, 0, 2)
nLine.Position = UDim2.new(0, 15, 1, -1)
nLine.BackgroundColor3 = C.ACC
nLine.BorderSizePixel = 0
nLine.Parent = head
local nGrad = Instance.new("UIGradient")
nGrad.Color = rainbowSeq()
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
tGrad.Color = rainbowSeq()
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
        -- Sync toggle state setiap buka tab
        task.wait(0.1)
        syncToggles()
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

-- TOGGLE DENGAN STATE SYNC (INI YANG BIKIN GAK MATI SENDIRI)
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
    _G.ToggleStates[name] = state

    -- Simpan object buat sync
    _G.ToggleObjects[name] = {
        setState = function(newState)
            state = newState
            _G.ToggleStates[name] = newState
            k.Position = newState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            k.BackgroundColor3 = newState and C.ACC2 or C.DIM
            t.BackgroundColor3 = newState and C.ACC or C.PANEL
            tS.Color = newState and C.ACC2 or C.DIM
        end
    }

    local cB = Instance.new("TextButton")
    cB.Size = UDim2.new(1, 0, 1, 0)
    cB.BackgroundTransparency = 1
    cB.Text = ""
    cB.Parent = t
    cB.MouseButton1Click:Connect(function()
        state = not state
        _G.ToggleStates[name] = state
        k.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        k.BackgroundColor3 = state and C.ACC2 or C.DIM
        t.BackgroundColor3 = state and C.ACC or C.PANEL
        tS.Color = state and C.ACC2 or C.DIM
        if cb then pcall(cb, state) end
    end)
end

-- SYNC FUNCTION
function syncToggles()
    for name, obj in pairs(_G.ToggleObjects) do
        if obj.setState and _G.ToggleStates[name] ~= nil then
            obj.setState(_G.ToggleStates[name])
        end
    end
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

-- AUTO SYNC TIAP 0.5 DETIK (INI KUNCINYA)
task.spawn(function()
    while gui.Parent do
        task.wait(0.5)
        if syncToggles then pcall(syncToggles) end
    end
end)

print("✅ [2/5] GUI + State Sync loaded")-- =========================================================
-- ROOORHUB - BAGIAN 3/5 : FIRE + ESP + PARRY + SKILLCHECK
-- =========================================================

-- ============== FIRE DI KEPALA (20 VARIAN) ==============
function clearFire()
    if not LP.Character then return end
    local head = LP.Character:FindFirstChild("Head")
    if not head then return end
    for _, obj in pairs(head:GetChildren()) do
        if obj.Name == "RoooorFire" or obj.Name == "RoooorSmoke"
        or obj.Name == "RoooorSparkles" or obj.Name == "RoooorPointLight" then
            obj:Destroy()
        end
    end
end

function applyFire()
    clearFire()
    if not S.FireOn then return end
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local cfg = FireConfig[S.FireType] or FireConfig.Classic

    local fire = Instance.new("Fire")
    fire.Name = "RoooorFire"
    fire.Size = S.FireSize
    fire.Heat = 10
    fire.Color = cfg.c1
    fire.SecondaryColor = cfg.c2
    fire.Parent = head

    if cfg.smoke then
        local smoke = Instance.new("Smoke")
        smoke.Name = "RoooorSmoke"
        smoke.Size = S.FireSize + 2
        smoke.RiseVelocity = 3
        smoke.Opacity = 0.4
        smoke.Color = cfg.smokeColor or Color3.fromRGB(50, 50, 50)
        smoke.Parent = head
    end

    if cfg.spark then
        local spark = Instance.new("Sparkles")
        spark.Name = "RoooorSparkles"
        spark.SparkleColor = cfg.c2
        spark.Parent = head
    end

    if cfg.rainbow then
        local light = Instance.new("PointLight")
        light.Name = "RoooorPointLight"
        light.Color = cfg.c1
        light.Range = 15
        light.Brightness = 2
        light.Parent = head
    end
end

-- Rainbow fire animation
task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        if S.FireOn and LP.Character then
            local head = LP.Character:FindFirstChild("Head")
            local fire = head and head:FindFirstChild("RoooorFire")
            if fire then
                local cfg = FireConfig[S.FireType] or FireConfig.Classic
                if cfg.rainbow then
                    local t = tick()
                    fire.Color = Color3.fromHSV((t * 0.5) % 1, 1, 1)
                    fire.SecondaryColor = Color3.fromHSV(((t * 0.5) + 0.5) % 1, 1, 1)
                    local light = head:FindFirstChild("RoooorPointLight")
                    if light then
                        light.Color = Color3.fromHSV((t * 0.5) % 1, 1, 1)
                    end
                end
            end
        end
    end
end)

-- ============== ESP NAMA (SIZE SLIDER) ==============
_G.ESPBillboards = _G.ESPBillboards or {}

function createESPName(player, char, root)
    if not S.ESP_Name then
        if _G.ESPBillboards[char] then
            _G.ESPBillboards[char]:Destroy()
            _G.ESPBillboards[char] = nil
        end
        return
    end
    if not root then return end

    local head = char:FindFirstChild("Head")
    if not head then return end

    local dist = (head.Position - root.Position).Magnitude
    if dist > S.ESP_Radius then
        if _G.ESPBillboards[char] then
            _G.ESPBillboards[char]:Destroy()
            _G.ESPBillboards[char] = nil
        end
        return
    end

    local teamColor = Color3.fromRGB(255, 255, 255)
    if player.Team then
        if player.Team.Name == "Killer" then
            teamColor = Color3.fromRGB(255, 60, 60)
        elseif player.Team.Name == "Survivors" then
            teamColor = Color3.fromRGB(60, 255, 120)
        end
    end

    local billboard = _G.ESPBillboards[char]
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "RoooorESPName"
        billboard.Size = UDim2.new(0, 200, 0, 30)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = teamColor
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = S.ESP_Size
        label.Parent = billboard

        billboard.Adornee = head
        billboard.Parent = char
        _G.ESPBillboards[char] = billboard
    else
        local label = billboard:FindFirstChildOfClass("TextLabel")
        if label then
            label.Text = player.Name
            label.TextColor3 = teamColor
            label.TextSize = S.ESP_Size
        end
    end
end

function clearAllESP()
    for char, bb in pairs(_G.ESPBillboards) do
        if bb then bb:Destroy() end
    end
    _G.ESPBillboards = {}
end

-- ============== AUTO PARRY (FALLENS - WORK) ==============
local lastParry = 0
local PARRY_DEBOUNCE = 0.15
_G.ParryActive = false
_G.HookedKillers = _G.HookedKillers or {}

function pressRightClick()
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
        task.wait()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
    end)
end

function GetParryButton()
    local current = PG
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

function pressParryButton()
    local didIt = false
    -- Try 1: Mobile
    if UIS.TouchEnabled then
        local btn = GetParryButton()
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = GuiService:GetGuiInset()
            local x = pos.X + size.X/2 + inset.X
            local y = pos.Y + size.Y/2 + inset.Y
            pcall(function()
                VirtualInputManager:SendTouchEvent(8823, 0, x, y)
                task.wait(0.01)
                VirtualInputManager:SendTouchEvent(8823, 2, x, y)
            end)
            didIt = true
        end
    end
    -- Try 2: Right Click (PC)
    if not didIt then
        pressRightClick()
    end
end

function doParry()
    local now = tick()
    if now - lastParry < PARRY_DEBOUNCE then return end
    lastParry = now
    _G.ParryActive = true
    pressParryButton()
    task.delay(0.3, function() _G.ParryActive = false end)
end

function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end
    return (enemyRoot.Position - myRoot.Position).Magnitude <= S.ParryDist
end

function hookKiller(char)
    if _G.HookedKillers[char] then return end
    _G.HookedKillers[char] = true
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not S.Parry then return end
        local anim = track.Animation
        if not anim then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end
        local fullId = "rbxassetid://" .. id
        if KillerAnims[fullId] then
            if not isInParryRange(char) then return end
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

-- Auto scan killer tiap 1 detik
task.spawn(function()
    while gui.Parent do
        task.wait(1)
        if S.Parry then scanKillers() end
    end
end)

-- ============== PARRY CIRCLE (BULAT GARIS) ==============
_G.ParryCirclePart = nil

function updateParryCircle()
    local root = getRoot()
    if not S.ParryCircle or not root then
        if _G.ParryCirclePart then
            _G.ParryCirclePart:Destroy()
            _G.ParryCirclePart = nil
        end
        return
    end

    if not _G.ParryCirclePart then
        _G.ParryCirclePart = Instance.new("Part")
        _G.ParryCirclePart.Shape = Enum.PartType.Cylinder
        _G.ParryCirclePart.Anchored = true
        _G.ParryCirclePart.CanCollide = false
        _G.ParryCirclePart.Material = Enum.Material.Neon
        _G.ParryCirclePart.Name = "RoooorParryCircle"
        _G.ParryCirclePart.Parent = workspace
    end

    local size = S.ParryCircleSize * 2
    _G.ParryCirclePart.Size = Vector3.new(0.1, size, size)

    local yOffset = root.Size.Y / 2 + 1.5
    _G.ParryCirclePart.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0))
        * CFrame.Angles(0, 0, math.rad(90))

    _G.ParryCirclePart.Color = Color3.fromRGB(255, 80, 80)
    _G.ParryCirclePart.Transparency = 0.5
end

-- ============== AUTO SKILL CHECK (FALLENS - WORK) ==============
_G.SkillConn = nil
local skillBusy = false
local TouchID = 8822
local ActionPath = "Survivor-mob.Controls.action.check"

function pressSpace()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end

function GetActionTarget()
    local current = PG
    for segment in string.gmatch(ActionPath, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

function TriggerMobileButton()
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
    if _G.SkillConn then _G.SkillConn:Disconnect() end
    _G.SkillConn = RunService.RenderStepped:Connect(function()
        if not S.Skill or skillBusy then return end

        -- Cari prompt dengan multiple nama
        local prompt = PG:FindFirstChild("SkillCheckPromptGui")
            or PG:FindFirstChild("SkillCheckGui")
            or PG:FindFirstChild("GeneratorGui")

        if not prompt then return end

        local check = prompt:FindFirstChild("Check")
            or prompt:FindFirstChild("skillCheck")
            or prompt:FindFirstChild("SkillCheck")

        if not check or not check.Visible then return end

        local line = check:FindFirstChild("Line") or check:FindFirstChild("line")
        local goal = check:FindFirstChild("Goal") or check:FindFirstChild("goal")

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

print("✅ [3/5] Fire + ESP + Parry + Skill loaded")-- =========================================================
-- ROOORHUB - BAGIAN 4/5 : ULTRA HD + CONTRAST
-- =========================================================

-- ============== GRAFIK ULTRA HD (RINGAN) ==============
local origSettings = {
    QualityLevel = nil,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
}

pcall(function()
    origSettings.QualityLevel = settings().Rendering.QualityLevel
end)

function applyUltraHD()
    if S.UltraHD then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
        end)

        Lighting.GlobalShadows = true
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.Ambient = Color3.fromRGB(100, 100, 100)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)

        if not _G.RoooorHD then
            _G.RoooorHD = Instance.new("ColorCorrectionEffect")
            _G.RoooorHD.Name = "RoooorHD"
            _G.RoooorHD.Parent = Lighting
        end
        _G.RoooorHD.Contrast = 0.2
        _G.RoooorHD.Brightness = 0.05
        _G.RoooorHD.Saturation = 0.15

        if not _G.RoooorBloom then
            _G.RoooorBloom = Instance.new("BloomEffect")
            _G.RoooorBloom.Name = "RoooorBloom"
            _G.RoooorBloom.Intensity = 0.4
            _G.RoooorBloom.Size = 20
            _G.RoooorBloom.Threshold = 1
            _G.RoooorBloom.Parent = Lighting
        end

        if not _G.RoooorSunRays then
            _G.RoooorSunRays = Instance.new("SunRaysEffect")
            _G.RoooorSunRays.Name = "RoooorSunRays"
            _G.RoooorSunRays.Intensity = 0.1
            _G.RoooorSunRays.Spread = 1
            _G.RoooorSunRays.Parent = Lighting
        end
    else
        pcall(function()
            if origSettings.QualityLevel then
                settings().Rendering.QualityLevel = origSettings.QualityLevel
            end
        end)

        Lighting.GlobalShadows = origSettings.GlobalShadows
        Lighting.Brightness = origSettings.Brightness
        Lighting.ClockTime = origSettings.ClockTime
        Lighting.FogEnd = origSettings.FogEnd
        Lighting.FogStart = origSettings.FogStart
        Lighting.Ambient = origSettings.Ambient
        Lighting.OutdoorAmbient = origSettings.OutdoorAmbient

        if _G.RoooorHD then _G.RoooorHD:Destroy(); _G.RoooorHD = nil end
        if _G.RoooorBloom then _G.RoooorBloom:Destroy(); _G.RoooorBloom = nil end
        if _G.RoooorSunRays then _G.RoooorSunRays:Destroy(); _G.RoooorSunRays = nil end
    end
end

-- ============== CONTRAST ==============
_G.ContrastFx = nil

function applyContrast()
    if S.Contrast then
        if not _G.ContrastFx then
            _G.ContrastFx = Instance.new("ColorCorrectionEffect")
            _G.ContrastFx.Name = "RoooorContrast"
            _G.ContrastFx.Parent = Lighting
        end
        _G.ContrastFx.Contrast = S.ContrastVal
        _G.ContrastFx.Brightness = S.BrightnessVal
        _G.ContrastFx.Saturation = S.SaturationVal
    else
        if _G.ContrastFx then
            _G.ContrastFx:Destroy()
            _G.ContrastFx = nil
        end
    end
end

print("✅ [4/5] Ultra HD + Contrast loaded")-- =========================================================
-- ROOORHUB - BAGIAN 5/5 : ISI TAB + MAIN LOOP + FINAL
-- =========================================================

-- ============== TAB 1 : INFO ==============
makeTab("Info", "ℹ️", 1, function()
    sec("Script Info", "📋")
    lbl("RoooorHub Ultimate", C.ACC2)
    lbl("Status: Active", C.GRN)
    lbl("Dev: Roooor", C.TXT)

    sec("FPS/Ping", "🌊")
    tog("Show FPS/Ping", true, function(s) S.FPS = s end)
end)

-- ============== TAB 2 : FIRE ==============
makeTab("Fire", "🔥", 2, function()
    sec("Fire di Kepala", "🔥")
    tog("Enable Fire", false, function(s)
        S.FireOn = s
        applyFire()
    end)
    drp("Fire Type (20)", FireList, "Classic", function(v)
        S.FireType = v
        applyFire()
    end)
    sl("Fire Size", 1, 15, 5, function(v)
        S.FireSize = v
        applyFire()
    end)

    sec("Info", "ℹ️")
    lbl("20 Varian Fire Unik", C.ACC2)
    lbl("Classic, Rainbow, Lightning, Hell", C.DIM)
    lbl("Ice, Toxic, Void, GoldenKing, Sakura", C.DIM)
    lbl("Emerald, Blood, Shadow, Holy, Ocean", C.DIM)
    lbl("Firework, Lava, Ghost, Cosmic", C.DIM)
    lbl("Dragon, Mystery", C.DIM)
end)

-- ============== TAB 3 : ESP ==============
makeTab("ESP", "👁️", 3, function()
    sec("ESP Nama (Besar-Kecil)", "👁️")
    tog("Enable ESP Name", false, function(s)
        S.ESP_Name = s
        if not s then clearAllESP() end
    end)
    sl("Nama Size", 8, 40, 12, function(v)
        S.ESP_Size = v
    end)
    sl("ESP Radius", 50, 2000, 500, function(v)
        S.ESP_Radius = v
    end)

    sec("Info Warna", "🎨")
    lbl("Killer = Merah", Color3.fromRGB(255, 60, 60))
    lbl("Survivor = Hijau", Color3.fromRGB(60, 255, 120))
end)

-- ============== TAB 4 : SURVIVOR ==============
makeTab("Survivor", "🏃", 4, function()
    sec("Auto Parry", "🛡️")
    tog("Enable Auto Parry", false, function(s)
        S.Parry = s
        if s then scanKillers() end
    end)
    sl("Parry Distance", 5, 25, 15, function(v)
        S.ParryDist = v
    end)

    sec("Parry Circle (Bulat Garis)", "🔵")
    tog("Enable Parry Circle", false, function(s)
        S.ParryCircle = s
    end)
    sl("Circle Size", 5, 50, 15, function(v)
        S.ParryCircleSize = v
    end)

    sec("Auto Skill Check", "🎯")
    tog("Enable Skill Check", false, function(s)
        S.Skill = s
        if s then startSkillCheck() end
    end)
end)

-- ============== TAB 5 : VISUAL ==============
makeTab("Visual", "🎨", 5, function()
    sec("Grafik Ultra HD (Ringan)", "🎨")
    tog("Enable Ultra HD", false, function(s)
        S.UltraHD = s
        applyUltraHD()
    end)
    lbl("Kualitas gambar HD", C.ACC2)
    lbl("Tetap ringan di HP kentang", C.GRN)

    sec("Contrast & Sharpen", "🔍")
    tog("Enable Contrast", false, function(s)
        S.Contrast = s
        applyContrast()
    end)
    sl("Contrast Value", -1, 2, 0.3, function(v)
        S.ContrastVal = v
        applyContrast()
    end)
    sl("Brightness", -1, 1, 0.1, function(v)
        S.BrightnessVal = v
        applyContrast()
    end)
    sl("Saturation", -1, 1, 0.2, function(v)
        S.SaturationVal = v
        applyContrast()
    end)
end)

-- ============== TAB 6 : SETTINGS ==============
makeTab("Settings", "⚙️", 6, function()
    sec("Keybind", "⌨️")
    lbl("RightShift = Toggle Menu", C.ACC2)

    sec("Script", "🚪")
    btn("🔄 Reset Semua Fitur", function()
        S.FireOn = false
        S.ESP_Name = false
        S.Parry = false
        S.ParryCircle = false
        S.Skill = false
        S.UltraHD = false
        S.Contrast = false
        clearFire()
        clearAllESP()
        applyUltraHD()
        applyContrast()
        syncToggles()
    end)
    btn("🚪 Unload Script", function()
        clearFire()
        clearAllESP()
        if _G.RoooorHD then _G.RoooorHD:Destroy() end
        if _G.RoooorBloom then _G.RoooorBloom:Destroy() end
        if _G.RoooorSunRays then _G.RoooorSunRays:Destroy() end
        if _G.ParryCirclePart then _G.ParryCirclePart:Destroy() end
        gui:Destroy()
    end)

    sec("Info", "ℹ️")
    lbl("Version: 5.0 Final", C.ACC3)
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
        if S.FPS then
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

task.spawn(function()
    while gui.Parent do
        local now = tick()
        local root = getRoot()

        if root then
            -- ESP Nama
            if S.ESP_Name and now - lastESP >= 0.1 then
                lastESP = now
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            createESPName(p, p.Character, root)
                        else
                            if _G.ESPBillboards[p.Character] then
                                _G.ESPBillboards[p.Character]:Destroy()
                                _G.ESPBillboards[p.Character] = nil
                            end
                        end
                    end
                end
            end

            -- Scan Killers Parry
            if S.Parry and now - lastParry >= 2 then
                lastParry = now
                scanKillers()
            end
        end

        -- Update Parry Circle
        updateParryCircle()

        task.wait(0.1)
    end
end)

-- =========================================================
-- RESPAWN HANDLER (RE-APPLY SEMUA FITUR YANG ON)
-- =========================================================
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    _G.ParryActive = false
    _G.HookedKillers = {}
    if S.FireOn then applyFire() end
    if S.Parry then scanKillers() end
    if S.Skill then startSkillCheck() end
    if S.UltraHD then applyUltraHD() end
    if S.Contrast then applyContrast() end
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
-- FINAL PRINT
-- =========================================================
print("=====================================================")
print("✅ [5/5] FINAL loaded")
print("🎉 ROOORHUB ULTIMATE - LOADED SUCCESSFULLY!")
print("=====================================================")
print("🔥 Fire di Kepala (20 Varian)")
print("👁️ ESP Nama (Size Slider)")
print("🛡️ Auto Parry (Fallens - WORK)")
print("🔵 Parry Circle (Bulat Garis)")
print("🎯 Auto Skill Check (Fallens - WORK)")
print("🎨 Grafik Ultra HD (Ringan)")
print("🔍 Contrast (3 Slider)")
print("🔄 STATE SYNC AKTIF - Fitur GAK MATI SENDIRI")
print("=====================================================")
print("⌨️ RightShift = Toggle Menu")
print("=====================================================")-- =========================================================
-- PATCH: ANTI FITUR OFF SENDIRI
-- Paste di PALING BAWAH script
-- =========================================================

-- 1. AUTO-SAVE STATE ke _G (biar gak ke-reset)
local function saveState()
    _G.RoooorS_Saved = {
        FireOn = S.FireOn,
        FireType = S.FireType,
        FireSize = S.FireSize,
        ESP_Name = S.ESP_Name,
        ESP_Size = S.ESP_Size,
        ESP_Radius = S.ESP_Radius,
        Parry = S.Parry,
        ParryDist = S.ParryDist,
        ParryCircle = S.ParryCircle,
        ParryCircleSize = S.ParryCircleSize,
        Skill = S.Skill,
        UltraHD = S.UltraHD,
        Contrast = S.Contrast,
        ContrastVal = S.ContrastVal,
        BrightnessVal = S.BrightnessVal,
        SaturationVal = S.SaturationVal,
    }
end

-- 2. AUTO-RESTORE STATE tiap 1 detik
local function restoreState()
    if _G.RoooorS_Saved then
        for k, v in pairs(_G.RoooorS_Saved) do
            if S[k] ~= v then
                S[k] = v
                print("[RoooorHub] Restored:", k, "=", v)
            end
        end
    end
end

-- 3. AUTO RE-APPLY efek yang ilang
local function reapplyEffects()
    if S.FireOn then
        local head = LP.Character and LP.Character:FindFirstChild("Head")
        if head and not head:FindFirstChild("RoooorFire") then
            applyFire()
            print("[RoooorHub] Re-apply Fire")
        end
    end
    if S.ParryCircle then
        if not _G.ParryCirclePart then
            updateParryCircle()
            print("[RoooorHub] Re-apply Parry Circle")
        end
    end
    if S.UltraHD then
        if not _G.RoooorHD then
            applyUltraHD()
            print("[RoooorHub] Re-apply Ultra HD")
        end
    end
    if S.Contrast then
        if not _G.ContrastFx then
            applyContrast()
            print("[RoooorHub] Re-apply Contrast")
        end
    end
end

-- 4. LOOP UTAMA - jalan tiap 1 detik
task.spawn(function()
    while gui.Parent do
        task.wait(1)
        saveState()
        restoreState()
        reapplyEffects()
        if syncToggles then syncToggles() end
    end
end)

-- 5. AUTO RESTART kalau script crash
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not gui.Parent then
                print("[RoooorHub] Script crashed, reloading...")
            end
        end)
    end
end)

print("✅ [PATCH] Anti-Off System Active")
