-- =========================================================
-- ROOORHUB - ULTIMATE KILLER EDITION (REWRITE)
-- BAGIAN 1/9 : SERVICES, CONFIG & HELPER
-- =========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- =========================================================
-- CONFIG WARNA
-- =========================================================
local Config = {
    BG        = Color3.fromRGB(10, 8, 18),
    PANEL     = Color3.fromRGB(20, 15, 35),
    ACCENT    = Color3.fromRGB(255, 50, 130),
    ACCENT2   = Color3.fromRGB(0, 255, 200),
    ACCENT3   = Color3.fromRGB(255, 200, 0),
    ACCENT4   = Color3.fromRGB(150, 80, 255),
    TEXT      = Color3.fromRGB(245, 245, 255),
    TEXT_DIM  = Color3.fromRGB(130, 130, 160),
    DANGER    = Color3.fromRGB(255, 70, 90),
    SUCCESS   = Color3.fromRGB(0, 255, 150),
}

-- =========================================================
-- STATE
-- =========================================================
local State = {
    -- KILLER
    MaskedPower = { Enabled = false, CurrentPower = "Cobra", Powers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"} },
    AutoSpamAttack = { Enabled = false, Delay = 0.35, LastAttack = 0 },
    AutoKillAll = { Enabled = false, PredictStrength = 0.15, BehindOffset = 3 },
    AutoCarry = { Enabled = false, Busy = false },
    AutoStalk = { Enabled = false, StalkRange = 150 },
    Aimlock = { Enabled = false, Holding = false, Target = "Survivor", AimPart = "Head", FOV = 250, Radius = 500, Prediction = 0.12, Smoothness = 0.5, VisibilityCheck = true, CurrentTarget = nil },
    HitboxExpander = { Enabled = false, Size = 15, Transparency = 0.7, Color = Color3.fromRGB(255, 50, 130), OnlySurvivors = true },
    AntiStun = { Enabled = false },

    -- SURVIVOR
    AutoParry = { Enabled = false, ParryDistance = 12, ParryCooldown = 0.2, LastParry = 0 },
    ParryCircle = { Enabled = false, Size = 12, Color = Color3.fromRGB(255, 80, 80), Transparency = 0.7, CirclePart = nil },
    AutoFlee = { Enabled = false, DetectDistance = 50, Cooldown = 0.1, LastFlee = 0 },
    AutoWiggle = { Enabled = false, Spam = 5 },

    -- SKILL
    SkillCheck = { Enabled = false, Mode = "Perfect" },

    -- MOONWALK
    Moonwalk = { Enabled = false, ShowButton = false, SpamSpeed = 25, Intensity = 25, SlowSpeed = 13 },

    -- AVATAR
    AvatarStealer = { TargetUsername = "", OriginalDescription = nil, CurrentUserId = nil, BlockyBody = false },

    -- VISUAL
    Visual = { NoFog = false, Fullbright = false, CustomSky = false, SkyId = "rbxassetid://159454299", Contrast = false, ContrastValue = 0.3, Brightness = 0.15, Saturation = 0.2 },

    -- FIRE EFFECT
    FireEffect = { Enabled = false, Type = "Red", Size = 5 },

    -- ESP
    ESP = { SurvivorEnabled = false, SurvivorColor = Color3.fromRGB(60, 255, 120), KillerEnabled = false, KillerColor = Color3.fromRGB(255, 60, 60), GeneratorEnabled = false, GeneratorColor = Color3.fromRGB(255, 170, 0), ShowName = true, ShowDistance = true, ShowHealth = true, NameColor = Color3.fromRGB(255, 255, 255), NameSize = 12, Radius = 500, Objects = {}, Billboards = {} },

    -- MOVEMENT
    Movement = { WalkSpeedEnabled = false, WalkSpeedValue = 20, OriginalWalkSpeed = 16, JumpPowerEnabled = false, JumpPowerValue = 50, OriginalJumpPower = 50, NoClip = false },

    -- STATS
    Stats = { FPS = 0, Ping = 0, ShowWatermark = true },

    -- GOD MODE
    GodMode = { Enabled = false },

    -- FLOATING BUTTONS
    FloatingButtons = {
        Aimlock = { Enabled = false, Locked = false, Gui = nil, Button = nil, Position = UDim2.new(0.35, 0, 0.75, 0), DefaultPosition = UDim2.new(0.35, 0, 0.75, 0) },
        Moonwalk = { Enabled = false, Locked = false, Gui = nil, Button = nil, Position = UDim2.new(0.65, 0, 0.75, 0), DefaultPosition = UDim2.new(0.65, 0, 0.75, 0) },
    },
}

-- =========================================================
-- KILLER ANIMATIONS (dari Fallens)
-- =========================================================
local KillerAnims = {
    ["rbxassetid://105374834496520"] = true,
    ["rbxassetid://113255068724446"] = true,
    ["rbxassetid://118907603246885"] = true,
    ["rbxassetid://129784271201071"] = true,
    ["rbxassetid://117042998468241"] = true,
    ["rbxassetid://122812055447896"] = true,
    ["rbxassetid://78935059863801"] = true,
    ["rbxassetid://74968262036854"] = true,
    ["rbxassetid://78432063483146"] = true,
    ["rbxassetid://132817836308238"] = true,
    ["rbxassetid://133963973694098"] = true,
    ["rbxassetid://111920872708571"] = true,
    ["rbxassetid://80411309607666"] = true,
    ["rbxassetid://98163597193511"] = true,
    ["rbxassetid://82666958311998"] = true,
    ["rbxassetid://110355011987939"] = true,
    ["rbxassetid://139369275981139"] = true,
    ["rbxassetid://135002183282873"] = true,
    ["rbxassetid://121216847022485"] = true,
    ["rbxassetid://130593238885843"] = true,
    ["rbxassetid://117070354890871"] = true,
    ["rbxassetid://106871536134254"] = true,
    ["rbxassetid://138720291317243"] = true,
}

-- =========================================================
-- FIRE VARIANTS
-- =========================================================
local FireVariants = {
    Red = { Primary = Color3.fromRGB(255, 60, 0), Secondary = Color3.fromRGB(255, 200, 0) },
    Blue = { Primary = Color3.fromRGB(0, 150, 255), Secondary = Color3.fromRGB(0, 255, 255) },
    Green = { Primary = Color3.fromRGB(0, 255, 100), Secondary = Color3.fromRGB(150, 255, 0) },
    Purple = { Primary = Color3.fromRGB(180, 0, 255), Secondary = Color3.fromRGB(255, 0, 200) },
    Rainbow = { Primary = Color3.fromRGB(255, 0, 0), Secondary = Color3.fromRGB(0, 255, 255) },
}

-- =========================================================
-- HELPER FUNCTIONS
-- =========================================================
function getRoot()
    local char = LP.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

function getHumanoid()
    local char = LP.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

function isDowned()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return hum.Health <= 0 or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true
end

function getNearestTarget(teamName, maxDist)
    local root = getRoot()
    if not root then return nil, math.huge end
    local closest, shortest = nil, maxDist or math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local validTeam = true
            if teamName and plr.Team then validTeam = (plr.Team.Name == teamName) end
            if validTeam then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local d = (hrp.Position - root.Position).Magnitude
                    if d < shortest then shortest = d; closest = plr.Character end
                end
            end
        end
    end
    return closest, shortest
end

function getNearestKiller()
    return getNearestTarget("Killer", 999)
end

print("✅ [ROOORHUB] BAGIAN 1/9 loaded")-- =========================================================
-- BAGIAN 3/9 : TOMBOL LOCK SYSTEM + UI COMPONENTS
-- =========================================================

-- =========================================================
-- FLOATING BUTTON SYSTEM
-- =========================================================
function CreateFloatingButton(id, icon, label, defaultPos, callback)
    local data = State.FloatingButtons[id]
    if not data then return end

    if data.Gui then
        data.Gui:Destroy()
        data.Gui = nil
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "Roooor_" .. id .. "_Btn"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    gui.Parent = PlayerGui
    data.Gui = gui

    local btn = Instance.new("TextButton")
    btn.Name = id .. "Button"
    btn.Size = UDim2.new(0, 52, 0, 52)
    btn.Position = data.Position or defaultPos
    btn.BackgroundColor3 = Config.PANEL
    btn.Text = icon
    btn.TextColor3 = Config.TEXT
    btn.TextSize = 24
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = gui
    round(btn, 26)
    local btnStroke = stroke(btn, Config.ACCENT2, 2)
    data.Button = btn

    local btnGrad = Instance.new("UIGradient")
    btnGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Config.PANEL),
        ColorSequenceKeypoint.new(0.5, Config.ACCENT4),
        ColorSequenceKeypoint.new(1, Config.PANEL),
    }
    btnGrad.Rotation = 45
    btnGrad.Parent = btn

    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 8, 1, 8)
    glow.Position = UDim2.new(0, -4, 0, -4)
    glow.BackgroundColor3 = Config.ACCENT
    glow.BackgroundTransparency = 0.75
    glow.BorderSizePixel = 0
    glow.ZIndex = -1
    glow.Parent = btn
    round(glow, 30)

    local lbl = Instance.new("TextLabel")
    lbl.Name = "Label"
    lbl.Size = UDim2.new(0, 100, 0, 16)
    lbl.Position = UDim2.new(0.5, -50, 1, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Config.ACCENT2
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextStrokeTransparency = 0.3
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.Parent = btn

    local lockLbl = Instance.new("TextLabel")
    lockLbl.Name = "LockLabel"
    lockLbl.Size = UDim2.new(0, 100, 0, 12)
    lockLbl.Position = UDim2.new(0.5, -50, 1, 18)
    lockLbl.BackgroundTransparency = 1
    lockLbl.Text = "🔓 UNLOCKED"
    lockLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lockLbl.TextSize = 9
    lockLbl.Font = Enum.Font.GothamBold
    lockLbl.TextStrokeTransparency = 0.4
    lockLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lockLbl.Visible = false
    lockLbl.Parent = btn

    task.spawn(function()
        while btn.Parent do
            local t = tick()
            local pulse = (math.sin(t * 3) + 1) / 2
            glow.BackgroundTransparency = 0.85 - pulse * 0.35
            glow.Size = UDim2.new(1, 6 + pulse * 8, 1, 6 + pulse * 8)
            glow.Position = UDim2.new(0, -3 - pulse * 4, 0, -3 - pulse * 4)
            local hue = (t * 0.3) % 1
            btnStroke.Color = hsv(hue, 1, 1)
            glow.BackgroundColor3 = hsv(hue, 1, 1)
            task.wait(0.03)
        end
    end)

    local draggingBtn = false
    local dragStart, startPos
    local wasDragged = false
    local lastClickTime = 0

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            if data.Locked then return end
            draggingBtn = true
            wasDragged = false
            dragStart = input.Position
            startPos = btn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingBtn = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if draggingBtn and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then
                wasDragged = true
            end
            btn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
            data.Position = btn.Position
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if wasDragged then
            wasDragged = false
            return
        end
        if tick() - lastClickTime < 0.15 then return end
        lastClickTime = tick()
        if callback then pcall(callback, btn, btnStroke, glow, lockLbl) end
    end)

    return btn
end

function UpdateButtonLockStatus(id)
    local data = State.FloatingButtons[id]
    if not data or not data.Button then return end
    local lockLbl = data.Button:FindFirstChild("LockLabel")
    if not lockLbl then return end
    if data.Locked then
        lockLbl.Text = "🔒 LOCKED"
        lockLbl.TextColor3 = Color3.fromRGB(255, 200, 0)
        lockLbl.Visible = true
    else
        lockLbl.Text = "🔓 UNLOCKED"
        lockLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        lockLbl.Visible = false
    end
end

function ToggleAimlockButton(show)
    if show then
        CreateFloatingButton("Aimlock", "🎯", "AIMLOCK", State.FloatingButtons.Aimlock.Position, function(btn, btnStroke)
            State.Aimlock.Enabled = not State.Aimlock.Enabled
            if State.Aimlock.Enabled then
                btn.BackgroundColor3 = Config.ACCENT4
                btnStroke.Color = Config.ACCENT
            else
                btn.BackgroundColor3 = Config.PANEL
                btnStroke.Color = Config.ACCENT2
            end
        end)
        State.FloatingButtons.Aimlock.Enabled = true
        UpdateButtonLockStatus("Aimlock")
    else
        if State.FloatingButtons.Aimlock.Gui then
            State.FloatingButtons.Aimlock.Gui:Destroy()
            State.FloatingButtons.Aimlock.Gui = nil
            State.FloatingButtons.Aimlock.Button = nil
        end
        State.FloatingButtons.Aimlock.Enabled = false
    end
end

function ToggleMoonwalkButton(show)
    if show then
        CreateFloatingButton("Moonwalk", "🌙", "MOONWALK", State.FloatingButtons.Moonwalk.Position, function(btn, btnStroke)
            State.Moonwalk.Enabled = not State.Moonwalk.Enabled
            if State.Moonwalk.Enabled then
                btn.BackgroundColor3 = Config.ACCENT4
                btnStroke.Color = Config.ACCENT
            else
                btn.BackgroundColor3 = Config.PANEL
                btnStroke.Color = Config.ACCENT2
                local hum = getHumanoid()
                if hum then hum.WalkSpeed = 16 end
            end
        end)
        State.FloatingButtons.Moonwalk.Enabled = true
        UpdateButtonLockStatus("Moonwalk")
    else
        if State.FloatingButtons.Moonwalk.Gui then
            State.FloatingButtons.Moonwalk.Gui:Destroy()
            State.FloatingButtons.Moonwalk.Gui = nil
            State.FloatingButtons.Moonwalk.Button = nil
        end
        State.FloatingButtons.Moonwalk.Enabled = false
    end
end

function ResetButtonPosition(id)
    local data = State.FloatingButtons[id]
    if not data or not data.Button then return end
    data.Button.Position = data.DefaultPosition
    data.Position = data.DefaultPosition
end

-- =========================================================
-- UI COMPONENTS
-- =========================================================

-- SECTION HEADER
local function createSection(title, icon)
    local sec = Instance.new("Frame")
    sec.Size = UDim2.new(1, -4, 0, 32)
    sec.BackgroundTransparency = 1
    sec.Parent = contentScroll

    local deco = Instance.new("Frame")
    deco.Size = UDim2.new(0, 4, 0, 18)
    deco.Position = UDim2.new(0, 4, 0.5, -9)
    deco.BackgroundColor3 = Config.ACCENT
    deco.BorderSizePixel = 0
    deco.Parent = sec
    round(deco, 2)

    local decoGrad = Instance.new("UIGradient")
    decoGrad.Color = rainbowSequence()
    decoGrad.Rotation = 90
    decoGrad.Parent = deco

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = icon .. "  " .. string.upper(title)
    lbl.TextColor3 = Config.ACCENT3
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = sec
end

-- LABEL
local function createLabel(text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -6, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Config.TEXT_DIM
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.Parent = contentScroll
end

-- TOGGLE
local function createToggle(name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 42)
    frame.BackgroundColor3 = Config.BG
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = contentScroll
    round(frame, 12)
    stroke(frame, Config.ACCENT, 1, 0.8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Config.TEXT
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 44, 0, 22)
    toggle.Position = UDim2.new(1, -56, 0.5, -11)
    toggle.BackgroundColor3 = Config.PANEL
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    round(toggle, 11)
    local toggleStroke = stroke(toggle, Config.TEXT_DIM, 1, 0.5)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = default and Config.ACCENT2 or Config.TEXT_DIM
    knob.BorderSizePixel = 0
    knob.Parent = toggle
    round(knob, 8)

    local state = default
    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Parent = toggle

    clickBtn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = state and Config.ACCENT2 or Config.TEXT_DIM
        }):Play()
        TweenService:Create(toggle, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Config.ACCENT or Config.PANEL
        }):Play()
        toggleStroke.Color = state and Config.ACCENT2 or Config.TEXT_DIM
        if callback then pcall(callback, state) end
    end)
end

-- BUTTON
local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 38)
    btn.BackgroundColor3 = Config.BG
    btn.BackgroundTransparency = 0.3
    btn.Text = name
    btn.TextColor3 = Config.TEXT
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = contentScroll
    round(btn, 12)
    stroke(btn, Config.ACCENT2, 1, 0.7)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Config.ACCENT, BackgroundTransparency = 0.5
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Config.BG, BackgroundTransparency = 0.3
        }):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then pcall(callback) end
    end)
end

-- SLIDER
local function createSlider(name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 55)
    frame.BackgroundColor3 = Config.BG
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = contentScroll
    round(frame, 12)
    stroke(frame, Config.ACCENT, 1, 0.8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 0, 22)
    lbl.Position = UDim2.new(0, 14, 0, 6)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Config.TEXT
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 50, 0, 22)
    valLbl.Position = UDim2.new(1, -60, 0, 6)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(default)
    valLbl.TextColor3 = Config.ACCENT2
    valLbl.TextSize = 12
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = frame

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -28, 0, 6)
    barBg.Position = UDim2.new(0, 14, 1, -16)
    barBg.BackgroundColor3 = Config.PANEL
    barBg.BorderSizePixel = 0
    barBg.Parent = frame
    round(barBg, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Config.ACCENT
    fill.BorderSizePixel = 0
    fill.Parent = barBg
    round(fill, 3)

    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color = ColorSequence.new(Config.ACCENT, Config.ACCENT2)
    fillGrad.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    knob.BackgroundColor3 = Config.TEXT
    knob.BorderSizePixel = 0
    knob.ZIndex = 2
    knob.Parent = barBg
    round(knob, 7)
    stroke(knob, Config.ACCENT2, 2)

    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        local val = math.floor((min + (max - min) * pos) * 100 + 0.5) / 100
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, -7, 0.5, -7)
        valLbl.Text = tostring(val)
        if callback then pcall(callback, val) end
    end

    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- DROPDOWN
local function createDropdown(name, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 42)
    frame.BackgroundColor3 = Config.BG
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = contentScroll
    round(frame, 12)
    stroke(frame, Config.ACCENT, 1, 0.8)
    frame.ClipsDescendants = false

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Config.TEXT
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local current = default or options[1]
    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0.5, -30, 1, 0)
    valLbl.Position = UDim2.new(0.5, 0, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = current
    valLbl.TextColor3 = Config.ACCENT2
    valLbl.TextSize = 12
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = frame

    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Parent = frame

    local open = false
    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 1, 4)
    list.BackgroundColor3 = Config.PANEL
    list.BorderSizePixel = 0
    list.Visible = false
    list.ZIndex = 10
    list.Parent = frame
    round(list, 10)
    stroke(list, Config.ACCENT2, 1, 0.5)

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = list

    local listPad = Instance.new("UIPadding")
    listPad.PaddingTop = UDim.new(0, 4)
    listPad.PaddingBottom = UDim.new(0, 4)
    listPad.Parent = list

    local function close()
        open = false
        TweenService:Create(list, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        task.delay(0.2, function()
            list.Visible = false
        end)
    end

    local function openList()
        open = true
        list.Visible = true
        list.Size = UDim2.new(1, 0, 0, 0)
        for _, c in pairs(list:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for _, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, -8, 0, 28)
            optBtn.BackgroundColor3 = Config.BG
            optBtn.BackgroundTransparency = 1
            optBtn.Text = opt
            optBtn.TextColor3 = Config.TEXT
            optBtn.TextSize = 12
            optBtn.Font = Enum.Font.GothamMedium
            optBtn.BorderSizePixel = 0
            optBtn.Parent = list
            round(optBtn, 6)
            optBtn.MouseEnter:Connect(function()
                optBtn.BackgroundTransparency = 0.5
                optBtn.BackgroundColor3 = Config.ACCENT
            end)
            optBtn.MouseLeave:Connect(function()
                optBtn.BackgroundTransparency = 1
            end)
            optBtn.MouseButton1Click:Connect(function()
                current = opt
                valLbl.Text = opt
                if callback then pcall(callback, opt) end
                close()
            end)
        end
        local targetH = math.min(#options * 30 + 8, 200)
        TweenService:Create(list, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetH)}):Play()
    end

    clickBtn.MouseButton1Click:Connect(function()
        if open then close() else openList() end
    end)
end

-- COLOR PICKER
local function createColorPicker(name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 42)
    frame.BackgroundColor3 = Config.BG
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = contentScroll
    round(frame, 12)
    stroke(frame, Config.ACCENT, 1, 0.8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Config.TEXT
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 50, 0, 24)
    colorBtn.Position = UDim2.new(1, -64, 0.5, -12)
    colorBtn.BackgroundColor3 = default
    colorBtn.Text = ""
    colorBtn.BorderSizePixel = 0
    colorBtn.Parent = frame
    round(colorBtn, 6)
    stroke(colorBtn, Config.ACCENT2, 1.5)

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
    local colorIdx = 1

    colorBtn.MouseButton1Click:Connect(function()
        colorIdx = colorIdx + 1
        if colorIdx > #presets then colorIdx = 1 end
        local c = presets[colorIdx]
        colorBtn.BackgroundColor3 = c
        if callback then pcall(callback, c) end
    end)
end

print("✅ [ROOORHUB] BAGIAN 3/9 loaded")-- =========================================================
-- BAGIAN 2/9 : UI UTILITY + GUI BASE
-- =========================================================

-- UTILITY
local function round(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 14)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Config.ACCENT
    s.Thickness = thickness or 1.5
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function hsv(h, s, v) return Color3.fromHSV(h, s, v) end

local function rainbowSequence()
    return ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 150, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(150, 0, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 150)),
    }
end

-- SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoooorHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- FPS/PING DI LAYAR (bukan di menu)
local FPSLabel = Instance.new("TextLabel")
FPSLabel.Name = "FPSLabel"
FPSLabel.Size = UDim2.new(0, 180, 0, 24)
FPSLabel.Position = UDim2.new(0.5, -90, 0, 5)
FPSLabel.BackgroundColor3 = Config.PANEL
FPSLabel.BackgroundTransparency = 0.4
FPSLabel.Text = "FPS: -- | PING: --"
FPSLabel.TextColor3 = Config.ACCENT2
FPSLabel.TextSize = 12
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextStrokeTransparency = 0.5
FPSLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
FPSLabel.Parent = ScreenGui
round(FPSLabel, 8)
local fpsStroke = stroke(FPSLabel, Config.ACCENT, 1, 0.5)

-- FLOATING TOGGLE BUTTON
local FloatBtn = Instance.new("TextButton")
FloatBtn.Name = "FloatBtn"
FloatBtn.Size = UDim2.new(0, 42, 0, 42)
FloatBtn.Position = UDim2.new(0, 20, 0.5, -21)
FloatBtn.BackgroundColor3 = Config.PANEL
FloatBtn.Text = "⚡"
FloatBtn.TextColor3 = Config.ACCENT2
FloatBtn.TextSize = 22
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.BorderSizePixel = 0
FloatBtn.AutoButtonColor = false
FloatBtn.Parent = ScreenGui
round(FloatBtn, 21)
local floatStroke = stroke(FloatBtn, Config.ACCENT, 2)

local GlowRing = Instance.new("Frame")
GlowRing.Size = UDim2.new(1, 10, 1, 10)
GlowRing.Position = UDim2.new(0, -5, 0, -5)
GlowRing.BackgroundColor3 = Config.ACCENT
GlowRing.BackgroundTransparency = 0.7
GlowRing.BorderSizePixel = 0
GlowRing.ZIndex = -1
GlowRing.Parent = FloatBtn
round(GlowRing, 30)

local NameShadow = Instance.new("TextLabel")
NameShadow.Size = UDim2.new(0, 110, 0, 26)
NameShadow.Position = UDim2.new(0.5, -55, 1, 6)
NameShadow.BackgroundTransparency = 1
NameShadow.Text = "ROOORHUB"
NameShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
NameShadow.TextTransparency = 0.25
NameShadow.TextSize = 14
NameShadow.Font = Enum.Font.GothamBlack
NameShadow.ZIndex = 1
NameShadow.Parent = FloatBtn

local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(0, 110, 0, 26)
NameLabel.Position = UDim2.new(0.5, -55, 1, 4)
NameLabel.BackgroundTransparency = 1
NameLabel.Text = "ROOORHUB"
NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLabel.TextSize = 14
NameLabel.Font = Enum.Font.GothamBlack
NameLabel.TextStrokeTransparency = 0
NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
NameLabel.ZIndex = 2
NameLabel.Parent = FloatBtn

local nameGrad = Instance.new("UIGradient")
nameGrad.Color = rainbowSequence()
nameGrad.Parent = NameLabel

task.spawn(function()
    while NameLabel.Parent do
        for i = 0, 1, 0.02 do
            if not NameLabel.Parent then break end
            nameGrad.Rotation = i * 360
            task.wait(0.03)
        end
    end
end)

task.spawn(function()
    while FloatBtn.Parent do
        local t = tick()
        local pulse = (math.sin(t * 3) + 1) / 2
        GlowRing.BackgroundTransparency = 0.8 - pulse * 0.35
        GlowRing.Size = UDim2.new(1, 8 + pulse * 8, 1, 8 + pulse * 8)
        GlowRing.Position = UDim2.new(0, -4 - pulse * 4, 0, -4 - pulse * 4)
        local hue = (t * 0.3) % 1
        floatStroke.Color = hsv(hue, 1, 1)
        GlowRing.BackgroundColor3 = hsv(hue, 1, 1)
        task.wait(0.03)
    end
end)

-- DRAG FLOAT
local draggingFloat = false
local floatDragStart, floatStartPos
FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFloat = true
        floatDragStart = input.Position
        floatStartPos = FloatBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingFloat = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if draggingFloat and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - floatDragStart
        FloatBtn.Position = UDim2.new(floatStartPos.X.Scale, floatStartPos.X.Offset + d.X, floatStartPos.Y.Scale, floatStartPos.Y.Offset + d.Y)
    end
end)

-- MAIN WINDOW
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 640, 0, 440)
Main.Position = UDim2.new(0.5, -320, 0.5, -220)
Main.BackgroundColor3 = Config.BG
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui
round(Main, 22)
local mainStroke = stroke(Main, Config.ACCENT, 2, 0.2)

local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5028857084"
shadow.ImageColor3 = Config.ACCENT
shadow.ImageTransparency = 0.5
shadow.ZIndex = -2
shadow.Parent = Main

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Config.PANEL
Header.BackgroundTransparency = 0.1
Header.BorderSizePixel = 0
Header.Parent = Main
round(Header, 22)

local headerPatch = Instance.new("Frame")
headerPatch.Size = UDim2.new(1, 0, 0, 22)
headerPatch.Position = UDim2.new(0, 0, 1, -22)
headerPatch.BackgroundColor3 = Config.PANEL
headerPatch.BackgroundTransparency = 0.1
headerPatch.BorderSizePixel = 0
headerPatch.Parent = Header

local neonLine = Instance.new("Frame")
neonLine.Size = UDim2.new(1, -40, 0, 3)
neonLine.Position = UDim2.new(0, 20, 1, -1.5)
neonLine.BackgroundColor3 = Config.ACCENT
neonLine.BorderSizePixel = 0
neonLine.Parent = Header
local neonLineGrad = Instance.new("UIGradient")
neonLineGrad.Color = rainbowSequence()
neonLineGrad.Parent = neonLine

task.spawn(function()
    while neonLine.Parent do
        for i = 0, 1, 0.02 do
            if not neonLine.Parent then break end
            neonLineGrad.Rotation = i * 360
            task.wait(0.03)
        end
    end
end)

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 45, 1, 0)
Logo.Position = UDim2.new(0, 14, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "⚡"
Logo.TextColor3 = Config.ACCENT2
Logo.TextSize = 30
Logo.Font = Enum.Font.GothamBold
Logo.Parent = Header

local TitleShadow = Instance.new("TextLabel")
TitleShadow.Size = UDim2.new(0, 300, 1, 0)
TitleShadow.Position = UDim2.new(0, 66, 0, 3)
TitleShadow.BackgroundTransparency = 1
TitleShadow.Text = "ROOORHUB"
TitleShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
TitleShadow.TextTransparency = 0.3
TitleShadow.TextSize = 24
TitleShadow.Font = Enum.Font.GothamBlack
TitleShadow.TextXAlignment = Enum.TextXAlignment.Left
TitleShadow.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 64, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ROOORHUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextStrokeTransparency = 0
Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Title.Parent = Header

local titleGrad = Instance.new("UIGradient")
titleGrad.Color = rainbowSequence()
titleGrad.Parent = Title

task.spawn(function()
    while Title.Parent do
        for i = 0, 1, 0.02 do
            if not Title.Parent then break end
            titleGrad.Rotation = i * 360
            task.wait(0.03)
        end
    end
end)

local function makeCtrlBtn(icon, xPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.Position = UDim2.new(1, xPos, 0.5, -14)
    btn.BackgroundColor3 = Config.PANEL
    btn.Text = icon
    btn.TextColor3 = color
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = Header
    round(btn, 8)
    stroke(btn, color, 1, 0.6)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color, TextColor3 = Config.BG}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Config.PANEL, TextColor3 = color}):Play()
    end)
    btn.MouseButton1Click:Connect(callback)
end

local function hideToFloat()
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.25)
    Main.Visible = false
    FloatBtn.Visible = true
    FloatBtn.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(FloatBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 42, 0, 42)
    }):Play()
end

makeCtrlBtn("✕", -42, Config.DANGER, hideToFloat)
makeCtrlBtn("—", -78, Config.ACCENT2, hideToFloat)

FloatBtn.MouseButton1Click:Connect(function()
    FloatBtn.Visible = false
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 640, 0, 440), Position = UDim2.new(0.5, -320, 0.5, -220)
    }):Play()
end)

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 155, 1, -85)
Sidebar.Position = UDim2.new(0, 15, 0, 70)
Sidebar.BackgroundColor3 = Config.PANEL
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
round(Sidebar, 16)
stroke(Sidebar, Config.ACCENT4, 1, 0.7)

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 6)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Parent = Sidebar

local sidebarPad = Instance.new("UIPadding")
sidebarPad.PaddingTop = UDim.new(0, 10)
sidebarPad.PaddingLeft = UDim.new(0, 8)
sidebarPad.PaddingRight = UDim.new(0, 8)
sidebarPad.Parent = Sidebar

-- CONTENT
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -200, 1, -85)
Content.Position = UDim2.new(0, 185, 0, 70)
Content.BackgroundColor3 = Config.PANEL
Content.BackgroundTransparency = 0.3
Content.BorderSizePixel = 0
Content.Parent = Main
round(Content, 16)
stroke(Content, Config.ACCENT2, 1, 0.7)

local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Size = UDim2.new(1, -20, 1, -20)
contentScroll.Position = UDim2.new(0, 10, 0, 10)
contentScroll.BackgroundTransparency = 1
contentScroll.BorderSizePixel = 0
contentScroll.ScrollBarThickness = 4
contentScroll.ScrollBarImageColor3 = Config.ACCENT
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentScroll.Parent = Content

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentScroll

-- TAB SYSTEM
local Tabs = {}
local ActiveTab = nil

local function createTab(name, icon, order, callback)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(1, 0, 0, 40)
    tab.BackgroundColor3 = Config.BG
    tab.BackgroundTransparency = 1
    tab.Text = ""
    tab.BorderSizePixel = 0
    tab.LayoutOrder = order
    tab.AutoButtonColor = false
    tab.Parent = Sidebar
    round(tab, 12)

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 4, 0, 0)
    indicator.Position = UDim2.new(0, 0, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.BackgroundColor3 = Config.ACCENT
    indicator.BorderSizePixel = 0
    indicator.Parent = tab
    round(indicator, 2)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 32, 1, 0)
    iconLbl.Position = UDim2.new(0, 10, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextColor3 = Config.TEXT_DIM
    iconLbl.TextSize = 17
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = tab

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -48, 1, 0)
    label.Position = UDim2.new(0, 46, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = string.upper(name)
    label.TextColor3 = Config.TEXT_DIM
    label.TextSize = 11
    label.Font = Enum.Font.GothamBlack
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tab

    tab.MouseEnter:Connect(function()
        if ActiveTab ~= tab then
            TweenService:Create(tab, TweenInfo.new(0.15), {BackgroundTransparency = 0.75}):Play()
            TweenService:Create(label, TweenInfo.new(0.15), {TextColor3 = Config.TEXT}):Play()
        end
    end)
    tab.MouseLeave:Connect(function()
        if ActiveTab ~= tab then
            TweenService:Create(tab, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
            TweenService:Create(label, TweenInfo.new(0.15), {TextColor3 = Config.TEXT_DIM}):Play()
        end
    end)

    tab.MouseButton1Click:Connect(function()
        if ActiveTab == tab then return end
        if ActiveTab then
            local oldInd = ActiveTab:FindFirstChildOfClass("Frame")
            TweenService:Create(ActiveTab, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            for _, c in pairs(ActiveTab:GetChildren()) do
                if c:IsA("TextLabel") then
                    TweenService:Create(c, TweenInfo.new(0.2), {TextColor3 = Config.TEXT_DIM}):Play()
                end
            end
            if oldInd then
                TweenService:Create(oldInd, TweenInfo.new(0.2), {Size = UDim2.new(0, 4, 0, 0)}):Play()
            end
        end
        ActiveTab = tab
        TweenService:Create(tab, TweenInfo.new(0.2), {BackgroundTransparency = 0.75}):Play()
        TweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Size = UDim2.new(0, 4, 0, 26)}):Play()
        for _, c in pairs(tab:GetChildren()) do
            if c:IsA("TextLabel") then
                TweenService:Create(c, TweenInfo.new(0.2), {TextColor3 = Config.TEXT}):Play()
            end
        end
        for _, c in pairs(contentScroll:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
        if callback then callback() end
    end)

    return tab
end

-- DRAG WINDOW
local dragging = false
local dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

print("✅ [ROOORHUB] BAGIAN 2/9 loaded")-- =========================================================
-- BAGIAN 4/9 : FITUR LOGIC (PART 1)
-- ESP, AIMLOCK, HITBOX, ANTI-STUN
-- =========================================================

-- VARIABEL
local ParryActive = false
local CarryBusy = false
local LastAttack = 0
local hookedKillers = {}

-- REMOTES (dari Fallens)
local CarryEvent, HookEvent, AttackEvent
pcall(function()
    local remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
    if remotes then
        local carry = remotes:FindFirstChild("Carry")
        if carry then
            CarryEvent = carry:FindFirstChild("CarrySurvivorEvent")
            HookEvent = carry:FindFirstChild("HookEvent")
        end
        local attacks = remotes:FindFirstChild("Attacks")
        if attacks then
            AttackEvent = attacks:FindFirstChild("BasicAttack")
        end
    end
end)

-- =========================================================
-- [1] ESP SYSTEM
-- =========================================================
local ESPObjects = {}

local function createESP(obj, color)
    if not obj then return end
    if ESPObjects[obj] then
        local h = ESPObjects[obj]
        h.FillColor = color
        h.OutlineColor = color
        return
    end
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.85
    h.OutlineTransparency = 0.2
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = obj
    ESPObjects[obj] = h
    obj.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if ESPObjects[obj] then
                ESPObjects[obj]:Destroy()
                ESPObjects[obj] = nil
            end
        end
    end)
end

local function removeESP(obj)
    if ESPObjects[obj] then
        ESPObjects[obj]:Destroy()
        ESPObjects[obj] = nil
    end
end

local function updateESPStatus(plr, char, root)
    if not char or not root then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    local isDown = hum.Health <= 0 or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true

    local dist = (head.Position - root.Position).Magnitude
    if dist > State.ESP.Radius then
        if State.ESP.Billboards[char] then
            State.ESP.Billboards[char]:Destroy()
            State.ESP.Billboards[char] = nil
        end
        return
    end

    local text = ""
    if isDown then text = "🔻 DOWN\n" end
    if State.ESP.ShowName then text = text .. plr.Name .. "\n" end
    if State.ESP.ShowDistance then text = text .. string.format("Dist: %.0f\n", dist) end
    if State.ESP.ShowHealth then text = text .. string.format("HP: %.0f", hum.Health) end
    if text == "" then return end

    local billboard = State.ESP.Billboards[char]
    local teamColor = State.ESP.NameColor
    if plr.Team then
        if plr.Team.Name == "Killer" then teamColor = State.ESP.KillerColor
        elseif plr.Team.Name == "Survivors" then teamColor = State.ESP.SurvivorColor end
    end
    if isDown then teamColor = Color3.fromRGB(255, 0, 0) end

    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 130, 0, 50)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = teamColor
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = State.ESP.NameSize
        label.Text = text
        label.Parent = billboard
        billboard.Adornee = head
        billboard.Parent = char
        State.ESP.Billboards[char] = billboard
    else
        local label = billboard:FindFirstChildOfClass("TextLabel")
        if label then
            label.Text = text
            label.TextColor3 = teamColor
            label.TextSize = State.ESP.NameSize
        end
    end
end

-- =========================================================
-- [2] AIMLOCK SYSTEM
-- =========================================================
local rayParamsAim = RaycastParams.new()
rayParamsAim.FilterType = Enum.RaycastFilterType.Exclude

local function isVisibleToCamera(targetPart)
    if not targetPart then return false end
    rayParamsAim.FilterDescendantsInstances = {LP.Character}
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local result = workspace:Raycast(origin, direction, rayParamsAim)
    if not result then return true end
    return result.Instance:IsDescendantOf(targetPart.Parent)
end

local function getClosestAimTarget()
    local cam = Camera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, shortest = nil, State.Aimlock.FOV
    local root = getRoot()
    if not root then return nil end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local validTeam = false
            if State.Aimlock.Target == "Survivor" and plr.Team and plr.Team.Name == "Survivors" then
                validTeam = true
            elseif State.Aimlock.Target == "Killer" and plr.Team and plr.Team.Name == "Killer" then
                validTeam = true
            end
            if validTeam then
                local hrp = plr.Character:FindFirstChild(State.Aimlock.AimPart)
                    or plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local dist3D = (hrp.Position - root.Position).Magnitude
                    if dist3D <= State.Aimlock.Radius then
                        local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                        if visible then
                            local screenDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                            if screenDist < shortest then
                                if not State.Aimlock.VisibilityCheck or isVisibleToCamera(hrp) then
                                    shortest = screenDist
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

local aimConnection = nil

local function startAimlock()
    if aimConnection then return end
    aimConnection = RunService.RenderStepped:Connect(function()
        if not State.Aimlock.Enabled then
            State.Aimlock.CurrentTarget = nil
            return
        end
        if not State.Aimlock.Holding then
            State.Aimlock.CurrentTarget = nil
            return
        end
        local target = getClosestAimTarget()
        if not target then return end
        State.Aimlock.CurrentTarget = target
        local pos = target.Position
        if State.Aimlock.Prediction > 0 then
            pos = pos + (target.AssemblyLinearVelocity * State.Aimlock.Prediction)
        end
        local targetCF = CFrame.new(Camera.CFrame.Position, pos)
        local smooth = math.clamp(State.Aimlock.Smoothness, 0, 1)
        Camera.CFrame = Camera.CFrame:Lerp(targetCF, smooth)
    end)
end

-- Deteksi tahan (mouse kanan / touch)
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        State.Aimlock.Holding = true
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        State.Aimlock.Holding = false
    end
end)

-- =========================================================
-- [3] HITBOX EXPANDER
-- =========================================================
local hitboxCache = {}

local function applyHitboxExpander(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    local parts = {
        char:FindFirstChild("Head"),
        char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"),
        char:FindFirstChild("LowerTorso"),
        char:FindFirstChild("HumanoidRootPart"),
    }
    for _, part in pairs(parts) do
        if part and part:IsA("BasePart") then
            if not hitboxCache[part] then
                hitboxCache[part] = { Size = part.Size, Transparency = part.Transparency }
            end
            part.Size = Vector3.new(State.HitboxExpander.Size, State.HitboxExpander.Size, State.HitboxExpander.Size)
            part.Transparency = State.HitboxExpander.Transparency
            part.CanCollide = false
            part.BrickColor = BrickColor.new(State.HitboxExpander.Color)
            part.Material = Enum.Material.Neon
        end
    end
end

local function resetHitboxExpander(char)
    if not char then return end
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") and hitboxCache[part] then
            part.Size = hitboxCache[part].Size
            part.Transparency = hitboxCache[part].Transparency
            part.CanCollide = true
            part.Material = Enum.Material.Plastic
            hitboxCache[part] = nil
        end
    end
end

-- =========================================================
-- [4] ANTI STUN
-- =========================================================
local function applyAntiStun()
    if not State.AntiStun.Enabled then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local state = hum:GetState()
    if state == Enum.HumanoidStateType.FallingDown
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.Dead then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
end

print("✅ [ROOORHUB] BAGIAN 4/9 loaded - ESP, AIMLOCK, HITBOX, ANTI-STUN")-- =========================================================
-- BAGIAN 6/9 : FITUR LOGIC (PART 3)
-- AUTO FLEE, WIGGLE, CARRY, STALK, FIRE, VISUAL, TELEPORT, AVATAR
-- =========================================================

-- =========================================================
-- [9] AUTO WIGGLE
-- =========================================================
local function AutoWiggle()
    if not State.AutoWiggle.Enabled then return end
    local char = LP.Character
    if not char then return end

    local carried = (char:FindFirstChild("IsCarried") and char.IsCarried.Value)
        or (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)
    if not carried then return end

    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return end
    local carry = remotes:FindFirstChild("Carry")
    if not carry then return end
    local event = carry:FindFirstChild("SelfUnHookEvent")
    if not event then return end

    for i = 1, State.AutoWiggle.Spam do
        event:FireServer()
    end
end

-- =========================================================
-- [10] AUTO FLEE KILLER
-- =========================================================
local function GetFarthestGeneratorPoint(killerRoot)
    if not killerRoot then return nil end
    local bestPoint, farthestDistance = nil, 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.match(obj.Name, "^GeneratorPoint%d+$") then
            local dist = (obj.Position - killerRoot.Position).Magnitude
            if dist > farthestDistance then
                farthestDistance = dist
                bestPoint = obj
            end
        end
    end
    return bestPoint
end

local function runAutoFlee()
    if not State.AutoFlee.Enabled then return end
    local root = getRoot()
    if not root then return end
    local killerRoot, distance = getNearestKiller()
    if killerRoot and distance <= State.AutoFlee.DetectDistance 
    and tick() - State.AutoFlee.LastFlee > State.AutoFlee.Cooldown then
        local point = GetFarthestGeneratorPoint(killerRoot)
        if point then
            State.AutoFlee.LastFlee = tick()
            root.CFrame = point.CFrame + Vector3.new(0, 5, 0)
        end
    end
end

-- =========================================================
-- [11] AUTO CARRY + HOOK
-- =========================================================
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

local function GetHook()
    local root = getRoot()
    if not root then return nil end
    local bestHook, shortestDistance = nil, math.huge
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

local function runAutoCarry()
    if not State.AutoCarry.Enabled or CarryBusy then return end
    CarryBusy = true
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
        CarryBusy = false
    end)
end

-- =========================================================
-- [12] AUTO STALK
-- =========================================================
local function getClosestSurvivorForStalk()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist <= State.AutoStalk.StalkRange and dist < shortest then
                    shortest = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

local function runAutoStalk()
    if not State.AutoStalk.Enabled then return end
    local target = getClosestSurvivorForStalk()
    if not target then return end
    local stalkEvent = ReplicatedStorage:FindFirstChild("Remotes", true)
        and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
        and ReplicatedStorage.Remotes.Killers:FindFirstChild("Stalker", true)
        and ReplicatedStorage.Remotes.Killers.Stalker:FindFirstChild("StartStalking")
    if stalkEvent then
        pcall(function() stalkEvent:FireServer(target) end)
    end
end

-- =========================================================
-- [13] FIRE EFFECT (5 VARIAN)
-- =========================================================
local fireConnection = nil

local function applyFireEffect()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not State.FireEffect.Enabled then
        if hrp:FindFirstChild("RoooorFire") then
            hrp.RoooorFire:Destroy()
        end
        return
    end

    local variant = FireVariants[State.FireEffect.Type] or FireVariants.Red
    local fire = hrp:FindFirstChild("RoooorFire")
    if not fire then
        fire = Instance.new("Fire")
        fire.Name = "RoooorFire"
        fire.Heat = 10
        fire.Parent = hrp
    end
    fire.Size = State.FireEffect.Size
    fire.Color = variant.Primary
    fire.SecondaryColor = variant.Secondary
end

-- Rainbow fire animation
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.1)
        if State.FireEffect.Enabled and State.FireEffect.Type == "Rainbow" then
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
-- [14] VISUAL (No Fog, Fullbright, Sky, Contrast)
-- =========================================================
local originalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows,
}
local contrastEffect = nil

local function applyVisual()
    if State.Visual.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = originalLighting.Brightness
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.Ambient = originalLighting.Ambient
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.GlobalShadows = originalLighting.GlobalShadows
    end

    if State.Visual.NoFog then
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
    else
        Lighting.FogEnd = originalLighting.FogEnd
        Lighting.FogStart = originalLighting.FogStart
    end

    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end
    if State.Visual.CustomSky then
        local sky = Instance.new("Sky")
        sky.SkyboxBk = State.Visual.SkyId
        sky.SkyboxDn = State.Visual.SkyId
        sky.SkyboxFt = State.Visual.SkyId
        sky.SkyboxLf = State.Visual.SkyId
        sky.SkyboxRt = State.Visual.SkyId
        sky.SkyboxUp = State.Visual.SkyId
        sky.Parent = Lighting
    end

    if State.Visual.Contrast then
        if not contrastEffect then
            contrastEffect = Instance.new("ColorCorrectionEffect")
            contrastEffect.Name = "RoooorContrast"
            contrastEffect.Parent = Lighting
        end
        contrastEffect.Contrast = State.Visual.ContrastValue
        contrastEffect.Brightness = State.Visual.Brightness
        contrastEffect.Saturation = State.Visual.Saturation
    else
        if contrastEffect then
            contrastEffect:Destroy()
            contrastEffect = nil
        end
    end
end

-- =========================================================
-- [15] TELEPORT
-- =========================================================
local function teleportToPlayer(name)
    local target = Players:FindFirstChild(name)
    if target and target.Character and LP.Character then
        local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
        local mHRP = LP.Character:FindFirstChild("HumanoidRootPart")
        if tHRP and mHRP then
            mHRP.CFrame = tHRP.CFrame + Vector3.new(0, 3, 0)
        end
    end
end

local function teleportToObject(objectName)
    local root = getRoot()
    if not root then return end
    local closest, shortest = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(objectName:lower()) then
            local d = (obj.Position - root.Position).Magnitude
            if d < shortest then shortest = d; closest = obj end
        end
    end
    if closest then root.CFrame = closest.CFrame + Vector3.new(0, 5, 0) end
end

-- =========================================================
-- [16] AVATAR STEALER (FULL - dengan aksesoris)
-- =========================================================
local AvatarStealer = State.AvatarStealer

local function saveOriginalAppearance()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        AvatarStealer.OriginalDescription = hum:GetAppliedDescription()
    end
end

local function removeAllAccessories(character)
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("Accessory") or v:IsA("Clothing") or v:IsA("Shirt")
        or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
            v:Destroy()
        end
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
    pcall(function() hum:ApplyDescriptionClientServer(desc) end)
end

local function copyAvatar(username)
    if not username or username == "" then return end
    saveOriginalAppearance()

    local success, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    if not success or not userId then
        warn("[RoooorHub] Username gak ditemukan: " .. username)
        return
    end

    AvatarStealer.CurrentUserId = userId

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
        removeAllAccessories(char)
        task.wait(0.2)
        pcall(function()
            hum:ApplyDescriptionClientServer(desc)
        end)
    end)
end

local function resetAvatar()
    if not AvatarStealer.OriginalDescription then
        saveOriginalAppearance()
        if not AvatarStealer.OriginalDescription then return end
    end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        removeAllAccessories(char)
        task.wait(0.1)
        pcall(function()
            hum:ApplyDescriptionClientServer(AvatarStealer.OriginalDescription)
        end)
        AvatarStealer.CurrentUserId = nil
    end
end

-- Auto restore setelah respawn
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    if AvatarStealer.CurrentUserId then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local desc = Players:GetHumanoidDescriptionFromUserId(AvatarStealer.CurrentUserId)
            if AvatarStealer.BlockyBody then
                applyBlockyBody(char)
                task.wait(0.2)
            end
            removeAllAccessories(char)
            task.wait(0.1)
            pcall(function()
                hum:ApplyDescriptionClientServer(desc)
            end)
        end
    end
end)

print("✅ [ROOORHUB] BAGIAN 6/9 loaded - ALL LOGIC DONE")-- =========================================================
-- BAGIAN 5/9 : FITUR LOGIC (PART 2)
-- AUTO PARRY (FIXED), SKILL CHECK (FIXED), MOONWALK (FIXED)
-- =========================================================

-- =========================================================
-- [5] AUTO PARRY (FIXED - langsung work)
-- =========================================================
local function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end
    local dist = (enemyRoot.Position - myRoot.Position).Magnitude
    return dist <= State.AutoParry.ParryDistance
end

local function doParry()
    local now = tick()
    if now - State.AutoParry.LastParry < State.AutoParry.ParryCooldown then return end
    State.AutoParry.LastParry = now
    ParryActive = true

    -- Trigger parry (mobile button atau PC right-click)
    if UIS.TouchEnabled then
        pcall(function()
            VirtualInputManager:SendTouchEvent(8823, 0, Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8823, 2, Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        end)
    else
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
            task.wait()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
        end)
    end

    task.delay(0.3, function()
        ParryActive = false
    end)
end

local function hookKillerForParry(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    animator.AnimationPlayed:Connect(function(track)
        if not State.AutoParry.Enabled then return end
        if ParryActive then return end
        local anim = track.Animation
        if not anim or not anim.AnimationId then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end
        local fullId = "rbxassetid://" .. id

        if KillerAnims[fullId] then
            if not isInParryRange(char) then return end
            -- Langsung parry tanpa delay (fixed)
            task.wait(State.AutoParry.ParryDelay or 0.05)
            doParry()
        end
    end)
end

local function scanKillersForParry()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
            hookKillerForParry(p.Character)
        end
    end
end

-- =========================================================
-- [6] PARRY CIRCLE VISUAL
-- =========================================================
local function updateParryCircle()
    local root = getRoot()
    if not State.ParryCircle.Enabled or not root then
        if State.ParryCircle.CirclePart then
            State.ParryCircle.CirclePart:Destroy()
            State.ParryCircle.CirclePart = nil
        end
        return
    end

    if not State.ParryCircle.CirclePart then
        local circle = Instance.new("Part")
        circle.Shape = Enum.PartType.Cylinder
        circle.Anchored = true
        circle.CanCollide = false
        circle.Material = Enum.Material.Neon
        circle.Name = "RoooorParryCircle"
        circle.Parent = workspace
        State.ParryCircle.CirclePart = circle
    end

    local size = State.ParryCircle.Size * 2
    local circle = State.ParryCircle.CirclePart
    circle.Size = Vector3.new(0.2, size, size)
    local yOffset = root.Size.Y / 2 + 1.5
    circle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0))
        * CFrame.Angles(0, 0, math.rad(90))
    circle.Color = State.ParryCircle.Color
    circle.Transparency = State.ParryCircle.Transparency
end

-- =========================================================
-- [7] AUTO SKILL CHECK (FIXED)
-- =========================================================
local skillConnection = nil
local skillBusy = false
local TouchID = 8822
local ActionPath = "Survivor-mob.Controls.action.check"

local function GetActionTarget()
    local current = PlayerGui
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

local function pressSpace()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end

local function startSkillCheck()
    if skillConnection then skillConnection:Disconnect() end
    skillConnection = RunService.RenderStepped:Connect(function()
        if not State.SkillCheck.Enabled or skillBusy then return end

        local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
        if not prompt then return end

        local check = prompt:FindFirstChild("Check")
        if not check or not check.Visible then return end

        local line = check:FindFirstChild("Line")
        local goal = check:FindFirstChild("Goal")
        if not line or not goal then return end

        local lr = line.Rotation % 360
        local gr = goal.Rotation % 360

        -- Mode Instant: langsung spam
        if State.SkillCheck.Mode == "Instant" then
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
            return
        end

        -- Mode Perfect: cek zone
        local startRange = (gr + 102) % 360
        local endRange = (gr + 116) % 360
        local success = (startRange > endRange and (lr >= startRange or lr <= endRange))
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
-- [8] MOONWALK (FIXED - sama di lobby & ingame)
-- =========================================================
local moonwalkConnection = nil

local function startMoonwalk()
    if moonwalkConnection then return end
    moonwalkConnection = RunService.RenderStepped:Connect(function()
        if not State.Moonwalk.Enabled or ParryActive or isDowned() then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        if hum.WalkSpeed ~= State.Moonwalk.SlowSpeed then
            hum.WalkSpeed = State.Moonwalk.SlowSpeed
        end

        -- FIXED: pakai CFrame rotation (sama di lobby & ingame)
        local cam = workspace.CurrentCamera
        if not cam then return end
        local look = cam.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit
            local baseCF = CFrame.new(hrp.Position, hrp.Position + flatLook)
            local angle = math.sin(tick() * State.Moonwalk.SpamSpeed) * State.Moonwalk.Intensity
            hrp.CFrame = baseCF * CFrame.Angles(0, math.rad(angle), 0)
            hum:Move(Vector3.new(0, 0, 1), true)
        end
    end)
end

local function stopMoonwalk()
    if moonwalkConnection then
        moonwalkConnection:Disconnect()
        moonwalkConnection = nil
    end
end

print("✅ [ROOORHUB] BAGIAN 5/9 loaded - PARRY, SKILLCHECK, MOONWALK")-- =========================================================
-- BAGIAN 7/9 : ISI TAB (INFO, ESP, KILLER)
-- =========================================================

-- =========================================================
-- TAB 1 : INFO
-- =========================================================
local tabInfo = createTab("Info", "ℹ️", 1, function()
    createSection("Script Info", "📋")
    createLabel("Script: RoooorHub Ultimate Killer", Config.ACCENT2)
    createLabel("Status: Active", Config.SUCCESS)
    createLabel("Developer: Roooor", Config.TEXT)
    createLabel("UI: Graffiti Rainbow", Config.ACCENT3)

    createSection("Watermark", "🌊")
    createToggle("Show FPS/Ping", true, function(state)
        State.Stats.ShowWatermark = state
        FPSLabel.Visible = state
    end)

    createSection("Floating Buttons", "🔘")
    createToggle("Show Aimlock Button", false, function(state)
        ToggleAimlockButton(state)
    end)
    createToggle("Show Moonwalk Button", false, function(state)
        ToggleMoonwalkButton(state)
    end)
end)

-- =========================================================
-- TAB 2 : ESP
-- =========================================================
local tabESP = createTab("ESP", "👁️", 2, function()
    createSection("Survivor ESP", "🟢")
    createToggle("ESP Survivor", false, function(state)
        State.ESP.SurvivorEnabled = state
    end)
    createColorPicker("Survivor Color", State.ESP.SurvivorColor, function(c)
        State.ESP.SurvivorColor = c
    end)

    createSection("Killer ESP", "🔴")
    createToggle("ESP Killer", false, function(state)
        State.ESP.KillerEnabled = state
    end)
    createColorPicker("Killer Color", State.ESP.KillerColor, function(c)
        State.ESP.KillerColor = c
    end)

    createSection("Generator ESP", "⚡")
    createToggle("ESP Generator", false, function(state)
        State.ESP.GeneratorEnabled = state
    end)
    createColorPicker("Generator Color", State.ESP.GeneratorColor, function(c)
        State.ESP.GeneratorColor = c
    end)

    createSection("ESP Status", "📊")
    createToggle("Show Name", true, function(state)
        State.ESP.ShowName = state
    end)
    createToggle("Show Distance", true, function(state)
        State.ESP.ShowDistance = state
    end)
    createToggle("Show Health", true, function(state)
        State.ESP.ShowHealth = state
    end)
    createColorPicker("Name Color", State.ESP.NameColor, function(c)
        State.ESP.NameColor = c
    end)
    createSlider("Name Size", 8, 24, 12, function(v)
        State.ESP.NameSize = v
    end)
    createSlider("ESP Radius", 50, 2000, 500, function(v)
        State.ESP.Radius = v
    end)
end)

-- =========================================================
-- TAB 3 : KILLER
-- =========================================================
local tabKiller = createTab("Killer", "🔪", 3, function()
    createSection("Aimlock", "🎯")
    createToggle("Enable Aimlock", false, function(state)
        State.Aimlock.Enabled = state
        if state then startAimlock() end
    end)
    createDropdown("Target", {"Survivor", "Killer"}, "Survivor", function(v)
        State.Aimlock.Target = v
    end)
    createDropdown("Aim Part", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(v)
        State.Aimlock.AimPart = v
    end)
    createSlider("FOV", 50, 1000, 250, function(v)
        State.Aimlock.FOV = v
    end)
    createSlider("Radius", 50, 1000, 500, function(v)
        State.Aimlock.Radius = v
    end)
    createSlider("Prediction", 0, 1, 0.12, function(v)
        State.Aimlock.Prediction = v
    end)
    createSlider("Smoothness", 0.05, 1, 0.5, function(v)
        State.Aimlock.Smoothness = v
    end)
    createToggle("Visibility Check", true, function(state)
        State.Aimlock.VisibilityCheck = state
    end)

    createSection("Aimlock Floating Button", "🎯")
    createToggle("Show Aimlock Button", false, function(state)
        ToggleAimlockButton(state)
    end)
    createToggle("🔒 Lock Aimlock Button", false, function(state)
        State.FloatingButtons.Aimlock.Locked = state
        UpdateButtonLockStatus("Aimlock")
    end)
    createButton("🔄 Reset Posisi Aimlock", function()
        ResetButtonPosition("Aimlock")
    end)

    createSection("Auto Attack", "⚔️")
    createToggle("Auto Spam Attack", false, function(state)
        State.AutoSpamAttack.Enabled = state
    end)
    createSlider("Attack Delay", 0.1, 2, 0.35, function(v)
        State.AutoSpamAttack.Delay = v
    end)
    createToggle("Auto Kill All", false, function(state)
        State.AutoKillAll.Enabled = state
    end)
    createSlider("Kill Predict", 0, 1, 0.15, function(v)
        State.AutoKillAll.PredictStrength = v
    end)
    createSlider("Behind Offset", 1, 10, 3, function(v)
        State.AutoKillAll.BehindOffset = v
    end)

    createSection("Auto Carry + Hook", "🏃")
    createToggle("Auto Carry Downed", false, function(state)
        State.AutoCarry.Enabled = state
    end)

    createSection("Auto Stalk", "👁️")
    createToggle("Auto Stalk", false, function(state)
        State.AutoStalk.Enabled = state
    end)
    createSlider("Stalk Range", 50, 500, 150, function(v)
        State.AutoStalk.StalkRange = v
    end)

    createSection("Masked Power", "🎭")
    createDropdown("Select Power", State.MaskedPower.Powers, "Cobra", function(v)
        State.MaskedPower.CurrentPower = v
    end)
    createButton("⚡ Activate Power", function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local killers = remotes:FindFirstChild("Killers")
            if killers then
                local masked = killers:FindFirstChild("Masked")
                if masked then
                    local ev = masked:FindFirstChild("Activatepower")
                    if ev then ev:FireServer(State.MaskedPower.CurrentPower) end
                end
            end
        end
    end)
    createButton("❌ Deactivate Power", function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local killers = remotes:FindFirstChild("Killers")
            if killers then
                local masked = killers:FindFirstChild("Masked")
                if masked then
                    local ev = masked:FindFirstChild("Deactivatepower")
                    if ev then ev:FireServer() end
                end
            end
        end
    end)

    createSection("Hitbox Expander", "📦")
    createToggle("Enable Hitbox", false, function(state)
        State.HitboxExpander.Enabled = state
        if not state then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    resetHitboxExpander(plr.Character)
                end
            end
        end
    end)
    createSlider("Hitbox Size", 3, 30, 15, function(v)
        State.HitboxExpander.Size = v
    end)
    createSlider("Transparency", 0, 1, 0.7, function(v)
        State.HitboxExpander.Transparency = v
    end)
    createColorPicker("Hitbox Color", State.HitboxExpander.Color, function(c)
        State.HitboxExpander.Color = c
    end)
    createToggle("Only Survivors", true, function(state)
        State.HitboxExpander.OnlySurvivors = state
    end)

    createSection("Anti Stun", "💪")
    createToggle("Anti Stun", false, function(state)
        State.AntiStun.Enabled = state
    end)

    createSection("Skill Check (Auto)", "🎯")
    createToggle("Auto Skill Check", false, function(state)
        State.SkillCheck.Enabled = state
        if state then startSkillCheck() end
    end)
    createDropdown("Mode", {"Perfect", "Instant"}, "Perfect", function(v)
        State.SkillCheck.Mode = v
    end)

    createSection("Auto Wiggle", "🎯")
    createToggle("Auto Wiggle", false, function(state)
        State.AutoWiggle.Enabled = state
    end)
    createSlider("Wiggle Spam", 1, 10, 5, function(v)
        State.AutoWiggle.Spam = v
    end)

    createSection("Auto Flee Killer", "🏃")
    createToggle("Auto Flee Killer", false, function(state)
        State.AutoFlee.Enabled = state
    end)
    createSlider("Detect Distance", 10, 200, 50, function(v)
        State.AutoFlee.DetectDistance = v
    end)
end)

print("✅ [ROOORHUB] BAGIAN 7/9 loaded - TAB INFO, ESP, KILLER")-- =========================================================
-- BAGIAN 8/9 : ISI TAB (SURVIVOR, VISUAL, MOVEMENT, AVATAR, SETTINGS)
-- =========================================================

-- =========================================================
-- TAB 4 : SURVIVOR
-- =========================================================
local tabSurvivor = createTab("Survivor", "🏃", 4, function()
    createSection("Auto Parry", "🛡️")
    createToggle("Enable Auto Parry", false, function(state)
        State.AutoParry.Enabled = state
        if state then scanKillersForParry() end
    end)
    createSlider("Parry Distance", 5, 25, 12, function(v)
        State.AutoParry.ParryDistance = v
    end)
    createSlider("Parry Cooldown", 0.1, 1, 0.2, function(v)
        State.AutoParry.ParryCooldown = v
    end)

    createSection("Parry Circle", "🔵")
    createToggle("Show Parry Circle", false, function(state)
        State.ParryCircle.Enabled = state
    end)
    createSlider("Circle Size", 5, 50, 12, function(v)
        State.ParryCircle.Size = v
    end)
    createColorPicker("Circle Color", State.ParryCircle.Color, function(c)
        State.ParryCircle.Color = c
    end)
    createSlider("Transparency", 0, 1, 0.7, function(v)
        State.ParryCircle.Transparency = v
    end)

    createSection("Moonwalk", "🌙")
    createToggle("Enable Moonwalk", false, function(state)
        State.Moonwalk.Enabled = state
        if state then startMoonwalk() else stopMoonwalk() end
    end)
    createSlider("Spam Speed", 1, 100, 25, function(v)
        State.Moonwalk.SpamSpeed = v
    end)
    createSlider("Intensity", 1, 90, 25, function(v)
        State.Moonwalk.Intensity = v
    end)
    createSlider("Slow Speed", 5, 30, 13, function(v)
        State.Moonwalk.SlowSpeed = v
    end)

    createSection("Moonwalk Floating Button", "🌙")
    createToggle("Show Moonwalk Button", false, function(state)
        ToggleMoonwalkButton(state)
    end)
    createToggle("🔒 Lock Moonwalk Button", false, function(state)
        State.FloatingButtons.Moonwalk.Locked = state
        UpdateButtonLockStatus("Moonwalk")
    end)
    createButton("🔄 Reset Posisi Moonwalk", function()
        ResetButtonPosition("Moonwalk")
    end)

    createSection("God Mode", "🛡️")
    createToggle("Anti Knockdown", false, function(state)
        State.GodMode.Enabled = state
    end)
end)

-- =========================================================
-- TAB 5 : VISUAL
-- =========================================================
local tabVisual = createTab("Visual", "🎨", 5, function()
    createSection("Lighting", "☀️")
    createToggle("Fullbright", false, function(state)
        State.Visual.Fullbright = state
        applyVisual()
    end)
    createToggle("No Fog", false, function(state)
        State.Visual.NoFog = state
        applyVisual()
    end)

    createSection("Sky", "🌤️")
    createToggle("Custom Sky", false, function(state)
        State.Visual.CustomSky = state
        applyVisual()
    end)
    createDropdown("Sky Preset", {
        "Sunset", "Night", "Space", "Alien"
    }, "Sunset", function(v)
        local skies = {
            ["Sunset"] = "rbxassetid://159454299",
            ["Night"] = "rbxassetid://159454299",
            ["Space"] = "rbxassetid://159454299",
            ["Alien"] = "rbxassetid://159454299",
        }
        State.Visual.SkyId = skies[v] or "rbxassetid://159454299"
        if State.Visual.CustomSky then applyVisual() end
    end)

    createSection("Contrast & Sharpen", "🔍")
    createToggle("Enable Contrast", false, function(state)
        State.Visual.Contrast = state
        applyVisual()
    end)
    createSlider("Contrast Value", -1, 2, 0.3, function(v)
        State.Visual.ContrastValue = v
        applyVisual()
    end)
    createSlider("Brightness", -1, 1, 0.15, function(v)
        State.Visual.Brightness = v
        applyVisual()
    end)
    createSlider("Saturation", -1, 1, 0.2, function(v)
        State.Visual.Saturation = v
        applyVisual()
    end)

    createSection("Fire Effect (5 Varian)", "🔥")
    createToggle("Enable Fire", false, function(state)
        State.FireEffect.Enabled = state
        applyFireEffect()
    end)
    createDropdown("Fire Type", {
        "Red", "Blue", "Green", "Purple", "Rainbow"
    }, "Red", function(v)
        State.FireEffect.Type = v
        applyFireEffect()
    end)
    createSlider("Fire Size", 1, 20, 5, function(v)
        State.FireEffect.Size = v
        applyFireEffect()
    end)
end)

-- =========================================================
-- TAB 6 : MOVEMENT
-- =========================================================
local tabMovement = createTab("Movement", "🏃", 6, function()
    createSection("Speed", "⚡")
    createToggle("Walk Speed", false, function(state)
        State.Movement.WalkSpeedEnabled = state
    end)
    createSlider("Speed Value", 16, 100, 20, function(v)
        State.Movement.WalkSpeedValue = v
    end)
    createToggle("Jump Power", false, function(state)
        State.Movement.JumpPowerEnabled = state
    end)
    createSlider("Jump Value", 50, 300, 50, function(v)
        State.Movement.JumpPowerValue = v
    end)
    createToggle("No Clip", false, function(state)
        State.Movement.NoClip = state
    end)

    createSection("Teleport", "📍")
    createButton("🚀 TP ke Player Acak", function()
        local list = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP then table.insert(list, p) end
        end
        if #list > 0 then
            teleportToPlayer(list[math.random(1, #list)].Name)
        end
    end)
    createButton("🚪 TP ke Gate", function()
        teleportToObject("gate")
    end)
    createButton("🪵 TP ke Pallet", function()
        teleportToObject("pallet")
    end)
    createButton("🪟 TP ke Window", function()
        teleportToObject("window")
    end)
    createButton("⚡ TP ke Generator", function()
        teleportToObject("generator")
    end)
end)

-- =========================================================
-- TAB 7 : AVATAR
-- =========================================================
local tabAvatar = createTab("Avatar", "🎭", 7, function()
    createSection("Steal Avatar", "🎭")
    createLabel("Masukin username target", Config.ACCENT2)

    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(1, -6, 0, 38)
    inputFrame.BackgroundColor3 = Config.BG
    inputFrame.BackgroundTransparency = 0.3
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = contentScroll
    round(inputFrame, 12)
    stroke(inputFrame, Config.ACCENT2, 1, 0.7)

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -20, 1, 0)
    textBox.Position = UDim2.new(0, 10, 0, 0)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
    textBox.PlaceholderText = "Ketik username target..."
    textBox.TextColor3 = Config.TEXT
    textBox.PlaceholderColor3 = Config.TEXT_DIM
    textBox.TextSize = 13
    textBox.Font = Enum.Font.GothamMedium
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.ClearTextOnFocus = false
    textBox.Parent = inputFrame

    textBox.FocusLost:Connect(function()
        AvatarStealer.TargetUsername = textBox.Text
    end)

    createButton("🎭 Copy Avatar (Full)", function()
        if AvatarStealer.TargetUsername == "" then
            AvatarStealer.TargetUsername = textBox.Text
        end
        copyAvatar(AvatarStealer.TargetUsername)
    end)
    createButton("🔄 Reset ke Avatar Sendiri", function()
        resetAvatar()
    end)
    createButton("💾 Simpan Avatar Skrg", function()
        saveOriginalAppearance()
    end)

    createSection("Opsi", "⚙️")
    createToggle("Blocky Body", false, function(state)
        AvatarStealer.BlockyBody = state
    end)

    createSection("Info", "ℹ️")
    createLabel("• Copy Avatar = copy tubuh + aksesoris", Config.ACCENT2)
    createLabel("• Blocky = blocky classic", Config.TEXT_DIM)
    createLabel("• Reset = balik avatar sendiri", Config.TEXT_DIM)
end)

-- =========================================================
-- TAB 8 : SETTINGS
-- =========================================================
local tabSettings = createTab("Settings", "⚙️", 8, function()
    createSection("Keybind", "⌨️")
    createLabel("RightShift = Toggle Menu", Config.ACCENT2)
    createLabel("Klik kanan (PC) = Aimlock", Config.ACCENT2)
    createLabel("Klik tombol float = Toggle fitur", Config.ACCENT2)

    createSection("Config", "💾")
    createButton("💾 Save Config", function()
        print("Config saved!")
    end)
    createButton("🔄 Reset Semua Fitur", function()
        for k, v in pairs(State) do
            if type(v) == "table" and v.Enabled ~= nil then
                v.Enabled = false
            end
        end
        print("All features reset")
    end)
    createButton("🚪 Unload Script", function()
        ScreenGui:Destroy()
        if State.FloatingButtons.Aimlock.Gui then
            State.FloatingButtons.Aimlock.Gui:Destroy()
        end
        if State.FloatingButtons.Moonwalk.Gui then
            State.FloatingButtons.Moonwalk.Gui:Destroy()
        end
        if State.ParryCircle.CirclePart then
            State.ParryCircle.CirclePart:Destroy()
        end
        print("Script unloaded")
    end)
end)

print("✅ [ROOORHUB] BAGIAN 8/9 loaded - TAB SURVIVOR, VISUAL, MOVEMENT, AVATAR, SETTINGS")-- =========================================================
-- BAGIAN 9/9 : MAIN LOOP + FPS/PING + KEYBIND
-- =========================================================

-- =========================================================
-- FPS/PING UPDATE LOOP (di layar)
-- =========================================================
local Frames = 0
local LastFrameTick = tick()

task.spawn(function()
    while ScreenGui.Parent do
        local now = tick()
        Frames = Frames + 1
        if now - LastFrameTick >= 1 then
            local fps = Frames
            Frames = 0
            LastFrameTick = now
            local ping = 0
            pcall(function()
                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            State.Stats.FPS = fps
            State.Stats.Ping = ping
            if State.Stats.ShowWatermark then
                FPSLabel.Text = string.format("FPS: %d | PING: %d ms", fps, ping)
            end
        end
        task.wait(0.1)
    end
end)

-- =========================================================
-- HEARTBEAT LOOP (logic non-visual)
-- =========================================================
RunService.Heartbeat:Connect(function()
    local now = tick()
    local root = getRoot()
    if not root then return end

    -- Auto Spam Attack
    if State.AutoSpamAttack.Enabled and now - LastAttack >= State.AutoSpamAttack.Delay then
        LastAttack = now
        if AttackEvent then
            pcall(function() AttackEvent:FireServer(false) end)
        end
    end

    -- Auto Kill All
    if State.AutoKillAll.Enabled then
        local target = getNearestTarget("Survivors", 500)
        if target then
            local tHRP = target:FindFirstChild("HumanoidRootPart")
            local tHum = target:FindFirstChildOfClass("Humanoid")
            if tHRP and tHum and tHum.Health > 0 then
                local predict = tHRP.AssemblyLinearVelocity * State.AutoKillAll.PredictStrength
                local targetPos = tHRP.Position + predict
                local behind = tHRP.CFrame.LookVector * -State.AutoKillAll.BehindOffset
                root.CFrame = CFrame.new(targetPos + behind, targetPos)
                if AttackEvent then
                    pcall(function() AttackEvent:FireServer(false) end)
                end
            end
        end
    end

    -- God Mode
    if State.GodMode.Enabled then
        local hum = getHumanoid()
        if hum and hum.Health < hum.MaxHealth then
            pcall(function() hum.Health = hum.MaxHealth end)
        end
    end

    -- Anti Stun
    applyAntiStun()

    -- Walk Speed
    if State.Movement.WalkSpeedEnabled then
        local hum = getHumanoid()
        if hum and hum.WalkSpeed ~= State.Movement.WalkSpeedValue then
            hum.WalkSpeed = State.Movement.WalkSpeedValue
        end
    end

    -- Jump Power
    if State.Movement.JumpPowerEnabled then
        local hum = getHumanoid()
        if hum and hum.JumpPower ~= State.Movement.JumpPowerValue then
            hum.JumpPower = State.Movement.JumpPowerValue
        end
    end

    -- No Clip
    if State.Movement.NoClip and LP.Character then
        for _, p in pairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
            end
        end
    end

    -- Hitbox Expander
    if State.HitboxExpander.Enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                if State.HitboxExpander.OnlySurvivors then
                    if plr.Team and plr.Team.Name == "Survivors" then
                        applyHitboxExpander(plr.Character)
                    end
                else
                    applyHitboxExpander(plr.Character)
                end
            end
        end
    end

    -- Fire Effect (permanent)
    if State.FireEffect.Enabled then
        applyFireEffect()
    end
end)

-- =========================================================
-- RENDERSTEPPED LOOP (visual)
-- =========================================================
RunService.RenderStepped:Connect(function()
    local root = getRoot()
    if not root then return end

    -- ESP Player
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local char = plr.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist <= State.ESP.Radius then
                        if State.ESP.SurvivorEnabled and plr.Team and plr.Team.Name == "Survivors" then
                            createESP(char, State.ESP.SurvivorColor)
                        elseif State.ESP.KillerEnabled and plr.Team and plr.Team.Name == "Killer" then
                            createESP(char, State.ESP.KillerColor)
                        else
                            removeESP(char)
                        end
                        updateESPStatus(plr, char, root)
                    else
                        removeESP(char)
                        if State.ESP.Billboards[char] then
                            State.ESP.Billboards[char]:Destroy()
                            State.ESP.Billboards[char] = nil
                        end
                    end
                end
            else
                removeESP(char)
            end
        end
    end

    -- ESP Generator
    if State.ESP.GeneratorEnabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("generator") then
                local dist = (obj.Position - root.Position).Magnitude
                if dist <= State.ESP.Radius then
                    createESP(obj, State.ESP.GeneratorColor)
                else
                    removeESP(obj)
                end
            end
        end
    end

    -- Parry Circle
    updateParryCircle()
end)

-- =========================================================
-- SCAN KILLER buat hook parry (tiap 1 detik)
-- =========================================================
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(1)
        if State.AutoParry.Enabled then
            scanKillersForParry()
        end
    end
end)

-- =========================================================
-- AUTO FLEE LOOP (setiap 0.2 detik)
-- =========================================================
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.2)
        if State.AutoFlee.Enabled then
            runAutoFlee()
        end
    end
end)

-- =========================================================
-- AUTO CARRY LOOP (setiap 0.5 detik)
-- =========================================================
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.5)
        if State.AutoCarry.Enabled then
            runAutoCarry()
        end
    end
end)

-- =========================================================
-- AUTO STALK LOOP (setiap 0.3 detik)
-- =========================================================
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.3)
        if State.AutoStalk.Enabled then
            runAutoStalk()
        end
    end
end)

-- =========================================================
-- AUTO WIGGLE LOOP (setiap 0.1 detik)
-- =========================================================
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.1)
        if State.AutoWiggle.Enabled then
            AutoWiggle()
        end
    end
end)

-- =========================================================
-- RESPAWN HANDLER
-- =========================================================
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    ParryActive = false
    CarryBusy = false
    hookedKillers = {}
    if State.FireEffect.Enabled then applyFireEffect() end
    if State.Moonwalk.Enabled then startMoonwalk() end
end)

-- =========================================================
-- BUKA TAB PERTAMA
-- =========================================================
task.wait(0.3)
if tabInfo then
    tabInfo.MouseButton1Click:Fire()
end

-- =========================================================
-- KEYBIND RightShift (toggle menu)
-- =========================================================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if Main.Visible then
            Main.Visible = false
            FloatBtn.Visible = true
        else
            Main.Visible = true
            FloatBtn.Visible = false
        end
    end
end)

-- =========================================================
-- NEON STROKE ANIMASI WINDOW
-- =========================================================
task.spawn(function()
    while Main.Parent do
        task.wait(0.05)
        local t = tick()
        local hue = (t * 0.3) % 1
        mainStroke.Color = hsv(hue, 1, 1)
        mainStroke.Transparency = 0.4
    end
end)

-- =========================================================
-- FINAL PRINT
-- =========================================================
print("=====================================================")
print("✅ ROOORHUB ULTIMATE KILLER - LOADED SUCCESSFULLY!")
print("=====================================================")
print("⌨️  RightShift = Toggle Menu")
print("🎯 Aimlock Button = Auto Toggle Aimlock")
print("🌙 Moonwalk Button = Auto Toggle Moonwalk")
print("🔒 Lock = Kunci posisi tombol")
print("=====================================================")
