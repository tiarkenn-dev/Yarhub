-- =========================================================
-- ROOORHUB - FIRE + CONTRAST
-- =========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

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
}

local S = {
    FireOn = false,
    FireType = "Classic",
    FireSize = 5,
    ContrastOn = false,
    ContrastVal = 0.3,
    BrightnessVal = 0.15,
    SaturationVal = 0.2,
}

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
gui.Name = "RoooorFire"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PG

-- Float Button
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 42, 0, 42)
floatBtn.Position = UDim2.new(0, 15, 0.5, -21)
floatBtn.BackgroundColor3 = C.PANEL
floatBtn.Text = "🔥"
floatBtn.TextColor3 = C.ACC3
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
fName.Text = "FIRE + CONTRAST"
fName.TextColor3 = Color3.new(1,1,1)
fName.TextSize = 9
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

-- Drag Float
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

-- Main Window
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 380, 0, 360)
main.Position = UDim2.new(0.5, -190, 0.5, -180)
main.BackgroundColor3 = C.BG
main.BackgroundTransparency = 0.05
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui
rnd(main, 14)
strk(main, C.ACC, 2)

-- Header
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
title.Text = "🔥 FIRE + CONTRAST"
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

-- Content
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

-- Components
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
-- FIRE SYSTEM
-- =========================================================
function clearFire()
    if not LP.Character then return end
    local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(hrp:GetChildren()) do
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
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local cfg = FireConfig[S.FireType] or FireConfig.Classic

    local fire = Instance.new("Fire")
    fire.Name = "RoooorFire"
    fire.Size = S.FireSize
    fire.Heat = 10
    fire.Color = cfg.c1
    fire.SecondaryColor = cfg.c2
    fire.Parent = hrp

    if cfg.smoke then
        local smoke = Instance.new("Smoke")
        smoke.Name = "RoooorSmoke"
        smoke.Size = S.FireSize + 2
        smoke.RiseVelocity = 3
        smoke.Opacity = 0.4
        smoke.Color = cfg.smokeColor or Color3.fromRGB(50, 50, 50)
        smoke.Parent = hrp
    end

    if cfg.spark then
        local spark = Instance.new("Sparkles")
        spark.Name = "RoooorSparkles"
        spark.SparkleColor = cfg.c2
        spark.Parent = hrp
    end

    if cfg.rainbow then
        local light = Instance.new("PointLight")
        light.Name = "RoooorPointLight"
        light.Color = cfg.c1
        light.Range = 15
        light.Brightness = 2
        light.Parent = hrp
    end
end

-- Rainbow animation
task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        if S.FireOn and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            local fire = hrp and hrp:FindFirstChild("RoooorFire")
            if fire then
                local cfg = FireConfig[S.FireType] or FireConfig.Classic
                if cfg.rainbow then
                    local t = tick()
                    fire.Color = Color3.fromHSV((t * 0.5) % 1, 1, 1)
                    fire.SecondaryColor = Color3.fromHSV(((t * 0.5) + 0.5) % 1, 1, 1)
                    local light = hrp:FindFirstChild("RoooorPointLight")
                    if light then
                        light.Color = Color3.fromHSV((t * 0.5) % 1, 1, 1)
                    end
                end
            end
        end
    end
end)

-- =========================================================
-- CONTRAST SYSTEM
-- =========================================================
local contrastEffect = nil

function applyContrast()
    if S.ContrastOn then
        if not contrastEffect then
            contrastEffect = Instance.new("ColorCorrectionEffect")
            contrastEffect.Name = "RoooorContrast"
            contrastEffect.Parent = Lighting
        end
        contrastEffect.Contrast = S.ContrastVal
        contrastEffect.Brightness = S.BrightnessVal
        contrastEffect.Saturation = S.SaturationVal
    else
        if contrastEffect then
            contrastEffect:Destroy()
            contrastEffect = nil
        end
    end
end

-- =========================================================
-- ISI MENU
-- =========================================================

sec("Fire Effect (20 Varian)", "🔥")
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

sec("Contrast", "🔍")
tog("Enable Contrast", false, function(s)
    S.ContrastOn = s
    applyContrast()
end)
sl("Contrast Value", -1, 2, 0.3, function(v)
    S.ContrastVal = v
    applyContrast()
end)
sl("Brightness", -1, 1, 0.15, function(v)
    S.BrightnessVal = v
    applyContrast()
end)
sl("Saturation", -1, 1, 0.2, function(v)
    S.SaturationVal = v
    applyContrast()
end)

-- =========================================================
-- RESPAWN HANDLER
-- =========================================================
LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    if S.FireOn then applyFire() end
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
print("✅ ROOORHUB FIRE + CONTRAST - LOADED!")
print("=========================================")
print("🔥 Fire: 20 Varian")
print("🔍 Contrast: 3 Slider")
print("⌨️ RightShift = Toggle Menu")
print("=========================================")
