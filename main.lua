-- =========================================================
-- ROOORHUB - FIRE HEAD + ESP + PARRY + SKILLCHECK
-- =========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
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
}

-- FIRE VARIANTS (20)
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

-- 23 KILLER ANIMS (FALLENS)
local KillerAnims = {}
for _, id in ipairs({
    "105374834496520","113255068724446","118907603246885","129784271201071",
    "117042998468241","122812055447896","78935059863801","74968262036854",
    "78432063483146","132817836308238","133963973694098","111920872708571",
    "80411309607666","98163597193511","82666958311998","110355011987939",
    "139369275981139","135002183282873","121216847022485","130593238885843",
    "117070354890871","106871536134254","138720291317243"
}) do KillerAnims["rbxassetid://"..id] = true end

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

-- GUI
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
main.Size = UDim2.new(0, 400, 0, 380)
main.Position = UDim2.new(0.5, -200, 0.5, -190)
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

-- CONTENT
local ct = Instance.new("Frame")
ct.Size = UDim2.new(1, -20, 1, -52)
ct.Position = UDim2.new(0, 10, 0, 47)
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

-- =========================================================
-- FIRE DI KEPALA
-- =========================================================
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

-- Rainbow animation
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

-- =========================================================
-- ESP NAMA (dengan size slider)
-- =========================================================
local ESPBillboards = {}

function createESPName(player, char, root)
    if not S.ESP_Name then
        if ESPBillboards[char] then
            ESPBillboards[char]:Destroy()
            ESPBillboards[char] = nil
        end
        return
    end
    if not root then return end

    local head = char:FindFirstChild("Head")
    if not head then return end

    local dist = (head.Position - root.Position).Magnitude
    if dist > S.ESP_Radius then
        if ESPBillboards[char] then
            ESPBillboards[char]:Destroy()
            ESPBillboards[char] = nil
        end
        return
    end

    -- Warna sesuai team
    local teamColor = Color3.fromRGB(255, 255, 255)
    if player.Team then
        if player.Team.Name == "Killer" then
            teamColor = Color3.fromRGB(255, 60, 60)
        elseif player.Team.Name == "Survivors" then
            teamColor = Color3.fromRGB(60, 255, 120)
        end
    end

    local billboard = ESPBillboards[char]
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
        ESPBillboards[char] = billboard
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
    for char, bb in pairs(ESPBillboards) do
        if bb then bb:Destroy() end
    end
    ESPBillboards = {}
end

-- =========================================================
-- AUTO PARRY (FALLENS)
-- =========================================================
local lastParry = 0
local PARRY_DEBOUNCE = 0.2
local ParryActive = false
local hookedKillers = {}

local function pressRightClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
end

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
    pressParryButton()
    task.delay(0.3, function() ParryActive = false end)
end

local function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end
    return (enemyRoot.Position - myRoot.Position).Magnitude <= S.ParryDist
end

local function hookKiller(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true
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

function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

function scanKillers()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
            hookKiller(p.Character)
        end
    end
end

-- =========================================================
-- PARRY CIRCLE (BULAT GARIS)
-- =========================================================
local ParryCirclePart = nil

function updateParryCircle()
    local root = getRoot()
    if not S.ParryCircle or not root then
        if ParryCirclePart then
            ParryCirclePart:Destroy()
            ParryCirclePart = nil
        end
        return
    end

    if not ParryCirclePart then
        ParryCirclePart = Instance.new("Part")
        ParryCirclePart.Shape = Enum.PartType.Cylinder
        ParryCirclePart.Anchored = true
        ParryCirclePart.CanCollide = false
        ParryCirclePart.Material = Enum.Material.Neon
        ParryCirclePart.Name = "RoooorParryCircle"
        ParryCirclePart.Parent = workspace
    end

    local size = S.ParryCircleSize * 2
    ParryCirclePart.Size = Vector3.new(0.1, size, size)

    local yOffset = root.Size.Y / 2 + 1.5
    ParryCirclePart.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0))
        * CFrame.Angles(0, 0, math.rad(90))

    ParryCirclePart.Color = Color3.fromRGB(255, 80, 80)
    ParryCirclePart.Transparency = 0.5
end

-- =========================================================
-- AUTO SKILL CHECK (FALLENS)
-- =========================================================
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
        if not S.Skill or skillBusy then return end
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

-- =========================================================
-- ISI MENU
-- =========================================================

sec("Fire di Kepala (20 Varian)", "🔥")
tog("Enable Fire", false, function(s)
    S.FireOn = s
    applyFire()
end)
drp("Fire Type", FireList, "Classic", function(v)
    S.FireType = v
    applyFire()
end)
sl("Fire Size", 1, 15, 5, function(v)
    S.FireSize = v
    applyFire()
end)

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
                            if ESPBillboards[p.Character] then
                                ESPBillboards[p.Character]:Destroy()
                                ESPBillboards[p.Character] = nil
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
-- RESPAWN HANDLER
-- =========================================================
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    ParryActive = false
    hookedKillers = {}
    if S.FireOn then applyFire() end
    if S.Parry then scanKillers() end
end)

-- =========================================================
-- KEYBIND
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
-- FINAL PRINT
-- =========================================================
print("=========================================")
print("✅ ROOORHUB - LOADED!")
print("=========================================")
print("🔥 Fire di Kepala (20 Varian)")
print("👁️ ESP Nama (Besar-Kecil)")
print("🛡️ Auto Parry (Fallens)")
print("🔵 Parry Circle Bulat Garis")
print("🎯 Auto Skill Check (Fallens)")
print("=========================================")
print("⌨️ RightShift = Toggle Menu")
print("=========================================")
