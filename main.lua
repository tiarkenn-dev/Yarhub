-- ═══════════════════════════════════════════════════════════
--   TIARHUB x VIOLENCE DISTRICT
--   Bagian 1 : Setup, Library, Splash Screen
-- ═══════════════════════════════════════════════════════════

-- ─── SERVICES ─────────────────────────────────────────────
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local VirtualInputManager= game:GetService("VirtualInputManager")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local Lighting           = game:GetService("Lighting")
local HttpService        = game:GetService("HttpService")
local TweenService       = game:GetService("TweenService")
local Stats              = game:GetService("Stats")
local Workspace          = game:GetService("Workspace")

local LocalPlayer        = Players.LocalPlayer
local PlayerGui          = LocalPlayer:WaitForChild("PlayerGui")
local Camera             = workspace.CurrentCamera

-- ─── LIBRARY OBSIDIAN ─────────────────────────────────────
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library        = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager   = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager    = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true

-- ─── WARNA TEMA TIARHUB ───────────────────────────────────
local Theme = {
    NEON_BLUE   = Color3.fromRGB(30, 150, 255),
    DEEP_BLUE   = Color3.fromRGB(0, 80, 180),
    DARK_BLUE   = Color3.fromRGB(0, 40, 90),
    BLACK_BLUE  = Color3.fromRGB(10, 20, 40),
    WHITE_BLUE  = Color3.fromRGB(220, 235, 255),
    CYAN_ACCENT = Color3.fromRGB(0, 255, 255),

    Killer   = Color3.fromRGB(255, 60, 60),
    Survivor = Color3.fromRGB(60, 255, 120),
    Gen      = Color3.fromRGB(255, 170, 0),
    Pallet   = Color3.fromRGB(74, 255, 181),
    Window   = Color3.fromRGB(74, 255, 181),
    SCP      = Color3.fromRGB(255, 0, 0),
    Circle   = Color3.fromRGB(0, 255, 255),
}

-- ─── SET SCHEME OBSIDIAN ──────────────────────────────────
Library.Scheme.AccentColor     = Theme.NEON_BLUE
Library.Scheme.BackgroundColor = Theme.BLACK_BLUE
Library.Scheme.MainColor       = Color3.fromRGB(20, 35, 65)
Library.Scheme.OutlineColor    = Theme.DEEP_BLUE
Library.Scheme.FontColor       = Theme.WHITE_BLUE

-- ═══════════════════════════════════════════════════════════
--   SPLASH SCREEN
-- ═══════════════════════════════════════════════════════════
local function ShowSplash()
    local splash = Instance.new("ScreenGui")
    splash.Name = "TiarHubSplash"
    splash.IgnoreGuiInset = true
    splash.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    splash.DisplayOrder = 999
    splash.Parent = game:GetService("CoreGui")

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Theme.BLACK_BLUE
    bg.BorderSizePixel = 0
    bg.Parent = splash

    -- Judul
    local title = Instance.new("TextLabel")
    title.Text = "TIARHUB"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 72
    title.TextColor3 = Theme.CYAN_ACCENT
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 100)
    title.Position = UDim2.new(0, 0, 0.4, 0)
    title.TextStrokeTransparency = 0.2
    title.TextStrokeColor3 = Theme.NEON_BLUE
    title.Parent = bg

    -- Subtitle
    local sub = Instance.new("TextLabel")
    sub.Text = "VIOLENCE DISTRICT EDITION"
    sub.Font = Enum.Font.GothamBold
    sub.TextSize = 16
    sub.TextColor3 = Theme.WHITE_BLUE
    sub.BackgroundTransparency = 1
    sub.Size = UDim2.new(1, 0, 0, 25)
    sub.Position = UDim2.new(0, 0, 0.52, 0)
    sub.Parent = bg

    -- Loading bar background
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0, 300, 0, 6)
    barBg.Position = UDim2.new(0.5, -150, 0.6, 0)
    barBg.BackgroundColor3 = Theme.DARK_BLUE
    barBg.BorderSizePixel = 0
    barBg.Parent = bg

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = barBg

    -- Loading bar fill
    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Theme.NEON_BLUE
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = barFill

    local fillGlow = Instance.new("UIStroke")
    fillGlow.Color = Theme.CYAN_ACCENT
    fillGlow.Thickness = 2
    fillGlow.Transparency = 0.5
    fillGlow.Parent = barFill

    -- Loading text
    local loading = Instance.new("TextLabel")
    loading.Text = "LOADING..."
    loading.Font = Enum.Font.GothamBold
    loading.TextSize = 14
    loading.TextColor3 = Color3.fromRGB(150, 200, 255)
    loading.BackgroundTransparency = 1
    loading.Size = UDim2.new(1, 0, 0, 20)
    loading.Position = UDim2.new(0, 0, 0.64, 0)
    loading.Parent = bg

    -- Animate loading
    TweenService:Create(barFill, TweenInfo.new(1.8, Enum.EasingStyle.Quad), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()

    task.wait(2)

    -- Fade out
    for i = 0, 1, 0.05 do
        bg.BackgroundTransparency = i
        title.TextTransparency = i
        title.TextStrokeTransparency = i
        sub.TextTransparency = i
        barBg.BackgroundTransparency = i
        barFill.BackgroundTransparency = i
        fillGlow.Transparency = i
        loading.TextTransparency = i
        task.wait(0.02)
    end

    splash:Destroy()
end

ShowSplash()

-- ═══════════════════════════════════════════════════════════
--   WINDOW
-- ═══════════════════════════════════════════════════════════
local Window = Library:CreateWindow({
    Title = "TIARHUB",
    Footer = "v1.0 | Violence District",
    Icon = 0,
    NotifySide = "Right",
    ShowCustomCursor = true,
    Size = UDim2.fromOffset(560, 400),
})

task.wait(0.1)
if Window.UI then
    Window.UI.Position = UDim2.new(0.5, 0, 0.03, 0)
    Window.UI.AnchorPoint = Vector2.new(0.5, 0)
end

-- ═══════════════════════════════════════════════════════════
--   STATS PANEL (FPS / PING / PLAYERS)
-- ═══════════════════════════════════════════════════════════
local statsGui = Instance.new("ScreenGui")
statsGui.Name = "TiarHubStats"
statsGui.ResetOnSpawn = false
statsGui.Parent = game:GetService("CoreGui")

local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(0, 160, 0, 95)
statsFrame.Position = UDim2.new(1, -180, 0, 20)
statsFrame.BackgroundColor3 = Theme.BLACK_BLUE
statsFrame.BackgroundTransparency = 0.2
statsFrame.BorderSizePixel = 0
statsFrame.Parent = statsGui

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 8)
sCorner.Parent = statsFrame

local sStroke = Instance.new("UIStroke")
sStroke.Color = Theme.NEON_BLUE
sStroke.Thickness = 1.5
sStroke.Transparency = 0.3
sStroke.Parent = statsFrame

local sTitle = Instance.new("TextLabel")
sTitle.Text = "TIARHUB STATS"
sTitle.Font = Enum.Font.GothamBlack
sTitle.TextSize = 13
sTitle.TextColor3 = Theme.CYAN_ACCENT
sTitle.BackgroundTransparency = 1
sTitle.Size = UDim2.new(1, 0, 0, 20)
sTitle.Position = UDim2.new(0, 0, 0, 5)
sTitle.Parent = statsFrame

local sText = Instance.new("TextLabel")
sText.Font = Enum.Font.GothamBold
sText.TextSize = 13
sText.TextColor3 = Theme.WHITE_BLUE
sText.BackgroundTransparency = 1
sText.Size = UDim2.new(1, -15, 1, -28)
sText.Position = UDim2.new(0, 10, 0, 28)
sText.TextXAlignment = Enum.TextXAlignment.Left
sText.TextYAlignment = Enum.TextYAlignment.Top
sText.Text = "FPS: --\nPING: --\nPLAYERS: --"
sText.Parent = statsFrame

task.spawn(function()
    local frames, lastTick, fps = 0, tick(), 0
    RunService.RenderStepped:Connect(function()
        frames += 1
        if tick() - lastTick >= 1 then
            fps = frames
            frames = 0
            lastTick = tick()
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local count = #Players:GetPlayers()
            sText.Text = string.format("FPS: %d\nPING: %d ms\nPLAYERS: %d", fps, ping, count)
        end
    end)
end)

-- ═══════════════════════════════════════════════════════════
--   TAB UTAMA
-- ═══════════════════════════════════════════════════════════
local Tabs = {
    Info     = Window:AddTab("Info",     "info"),
    Combat   = Window:AddTab("Combat",   "sword"),
    Visuals  = Window:AddTab("Visuals",  "eye"),
    Movement = Window:AddTab("Movement", "activity"),
    Auto     = Window:AddTab("Auto",     "zap"),
    Player   = Window:AddTab("Player",   "user"),
    Settings = Window:AddTab("Settings", "settings"),
}

-- ═══════════════════════════════════════════════════════════
--   KONFIGURASI GLOBAL (dipakai semua bagian)
-- ═══════════════════════════════════════════════════════════
_G.TiarConfig = {
    ESP = {
        Killer = false, Survivor = false,
        Generator = false, Pallet = false,
        Window = false, SCP = false,
        Distance = 300,
        KillerColor   = Theme.Killer,
        SurvivorColor = Theme.Survivor,
        GenColor      = Theme.Gen,
        PalletColor   = Theme.Pallet,
        WindowColor   = Theme.Window,
        SCPColor      = Theme.SCP,
    },
    ESPStatus = {
        Enabled = false, ShowName = true,
        ShowDistance = true, ShowHealth = false,
        Radius = 200,
    },
    ESPCircle = {
        Enabled = false,
        Size = 6,
        Thickness = 0.1,
        Color = Theme.Circle,
        Transparency = 0.5,
    },
    AutoParry = {
        Enabled = false,
        Distance = 15,
        Cooldown = 0.2,
    },
    AutoSkillCheck = { Enabled = false },
    AutoWiggle     = { Enabled = false, Spam = 5 },
    AutoFlee       = { Enabled = false, Distance = 50, Cooldown = 0.1 },
    Aimlock = {
        Enabled = false, Target = "Survivor",
        AimPart = "HumanoidRootPart",
        FOV = 250, Predict = 0.12,
    },
    WalkSpeed = { Enabled = false, Value = 17.6 },
    JumpPower = { Enabled = false, Value = 50 },
    NoClip    = { Enabled = false },
    Moonwalk  = { Enabled = false, Spam = 30, Intensity = 35, Slow = 13 },
    FastVault = { Enabled = false, Speed = 1.2 },
    Crosshair = {
        Enabled = false, Style = "Plus",
        Size = 8, Thickness = 2,
        Color = Color3.fromRGB(255,255,255),
        OffsetX = 0, OffsetY = 0,
    },
    VisualContrast = {
        Enabled = false,
        Contrast = 1.0, Saturation = 1.0,
        Brightness = 0.0,
        Tint = Color3.fromRGB(255,255,255),
        TintTransparency = 1,
    },
    Fullbright = { Enabled = false },
    FOV = { Enabled = false, Value = 70 },
    Zoom = { Enabled = false, Max = 1000 },
}

-- ═══════════════════════════════════════════════════════════
--   HELPER UMUM
-- ═══════════════════════════════════════════════════════════
local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- Notif wrapper
local function notify(title, desc, duration)
    Library:Notify({
        Title = title,
        Description = desc or "",
        Time = duration or 3,
        Icon = 0,
    })
end

-- ═══════════════════════════════════════════════════════════
--   KEYBIND TOGGLE GUI (RightShift)
-- ═══════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Library:Toggle()
    end
end)

-- ═══════════════════════════════════════════════════════════
--   KILLER ANIM ID (23 ID dari lu)
-- ═══════════════════════════════════════════════════════════
_G.KillerAnims = {
    ["rbxassetid://105374834496520"] = true,
    ["rbxassetid://113255068724446"] = true,
    ["rbxassetid://118907603246885"] = true,
    ["rbxassetid://129784271201071"] = true,
    ["rbxassetid://117042998468241"] = true,
    ["rbxassetid://122812055447896"] = true,
    ["rbxassetid://78935059863801"]  = true,
    ["rbxassetid://74968262036854"]  = true,
    ["rbxassetid://78432063483146"]  = true,
    ["rbxassetid://132817836308238"] = true,
    ["rbxassetid://133963973694098"] = true,
    ["rbxassetid://111920872708571"] = true,
    ["rbxassetid://80411309607666"]  = true,
    ["rbxassetid://98163597193511"]  = true,
    ["rbxassetid://82666958311998"]  = true,
    ["rbxassetid://110355011987939"] = true,
    ["rbxassetid://139369275981139"] = true,
    ["rbxassetid://135002183282873"] = true,
    ["rbxassetid://121216847022485"] = true,
    ["rbxassetid://130593238885843"] = true,
    ["rbxassetid://117070354890871"] = true,
    ["rbxassetid://106871536134254"] = true,
    ["rbxassetid://138720291317243"] = true,
}

-- Anim ID Parry (dari script lu)
_G.ParryAnimId = "rbxassetid://127096285501517"

-- ═══════════════════════════════════════════════════════════
--   REMOTE EVENTS
-- ═══════════════════════════════════════════════════════════
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
_G.Remotes = {
    Carry  = Remotes and Remotes:WaitForChild("Carry", 5),
    Attack = Remotes and Remotes:WaitForChild("Attacks", 5),
    Gen    = Remotes and Remotes:WaitForChild("Generator", 5),
    Emote  = Remotes and Remotes:WaitForChild("EmoteHandler", 5),
}

notify("TIARHUB", "Bagian 1 Loaded ✓", 3)

-- ═══════════════════════════════════════════════════════════
--   END OF BAGIAN 1
-- ═══════════════════════════════════════════════════════════-- ═══════════════════════════════════════════════════════════
--   TIARHUB x VIOLENCE DISTRICT
--   Bagian 2 : Tab Info + Tab Combat
-- ═══════════════════════════════════════════════════════════

-- Ambil config & fungsi dari Bagian 1
local Config  = _G.TiarConfig
local KillerAnims = _G.KillerAnims
local ParryAnimId = _G.ParryAnimId
local Theme   = {
    NEON_BLUE   = Color3.fromRGB(30, 150, 255),
    DEEP_BLUE   = Color3.fromRGB(0, 80, 180),
    WHITE_BLUE  = Color3.fromRGB(220, 235, 255),
    CYAN_ACCENT = Color3.fromRGB(0, 255, 255),
}

local function notify(title, desc, dur)
    Library:Notify({ Title = title, Description = desc or "", Time = dur or 3, Icon = 0 })
end

-- ═══════════════════════════════════════════════════════════
--   TAB INFO
-- ═══════════════════════════════════════════════════════════
local InfoBox    = Tabs.Info:AddLeftGroupbox("Script Info", "info")
local CreditsBox = Tabs.Info:AddRightGroupbox("Credits", "user")

InfoBox:AddLabel("Script    : TIARHUB x Violence District")
InfoBox:AddLabel("Version   : 1.0.0")
InfoBox:AddLabel("Game      : Violence District")
InfoBox:AddLabel("Build     : Modular (7 parts)")
InfoBox:AddDivider()
InfoBox:AddLabel("Status    : ✅ Loaded")

InfoBox:AddButton({
    Text = "📋 Copy Discord",
    Func = function()
        setclipboard("https://discord.gg/tiarhub")
        notify("Copied!", "Discord link disalin", 2)
    end
})

CreditsBox:AddLabel("Developer  : Tiar")
CreditsBox:AddDivider()
CreditsBox:AddLabel("Library    : Obsidian UI")
CreditsBox:AddLabel("Base       : Fallens Freemium")
CreditsBox:AddLabel("Helpers    : •༶amill༶•")
CreditsBox:AddDivider()

CreditsBox:AddButton({
    Text = "💖 Support Dev",
    Func = function()
        setclipboard("https://sociabuzz.com/amill_al/tribe")
        notify("Thanks!", "Link support disalin", 2)
    end
})

-- ═══════════════════════════════════════════════════════════
--   TAB COMBAT — GROUPBOXES
-- ═══════════════════════════════════════════════════════════
local ParryBox     = Tabs.Combat:AddLeftGroupbox("Auto Parry",  "sword")
local AimlockBox   = Tabs.Combat:AddLeftGroupbox("Aimlock",     "crosshair")
local CrosshairBox = Tabs.Combat:AddRightGroupbox("Crosshair",  "crosshair")

-- ═══════════════════════════════════════════════════════════
--   AUTO PARRY 360° (FIX)
-- ═══════════════════════════════════════════════════════════
-- Cara kerja:
--   1. Hook animator killer di sekitar player
--   2. Cek animasi yang dimainkan killer
--   3. Kalau animasi = salah satu dari 23 KillerAnims → PARRY
--   4. PARRY 360° = tidak cek arah hadap
-- ═══════════════════════════════════════════════════════════

local PARRY_DEBOUNCE = 0.2
local lastParry = 0
local ParryActive = false
local ParryCircle = nil

local function getLocalRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- PC: Klik Kanan
local function pressRightClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait(0.02)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
end

-- Mobile: cari tombol parry
local function getParryButton()
    local current = PlayerGui
    for seg in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(seg)
    end
    return current
end

local function pressParryButton()
    if UserInputService.TouchEnabled then
        local btn = getParryButton()
        if btn and btn:IsA("GuiObject") then
            local pos, size = btn.AbsolutePosition, btn.AbsoluteSize
            local inset = game:GetService("GuiService"):GetGuiInset()
            local x = pos.X + size.X/2 + inset.X
            local y = pos.Y + size.Y/2 + inset.Y
            VirtualInputManager:SendTouchEvent(8823, 0, x, y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8823, 2, x, y)
        else
            pressRightClick()
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

-- 🔥 CEK JARAK DOANG — GAK CEK ARAH (360°)
local function isInParryRange(killerChar)
    local myRoot = getLocalRoot()
    if not myRoot or not killerChar then return false end

    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end

    local dist = (enemyRoot.Position - myRoot.Position).Magnitude
    return dist <= Config.AutoParry.Distance
end

-- Hook killer (pantau animasi mereka)
local hookedKillers = {}

local function hookKiller(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    animator.AnimationPlayed:Connect(function(track)
        if not Config.AutoParry.Enabled then return end
        if ParryActive then return end

        local anim = track.Animation
        if not anim or not anim.AnimationId then return end

        local id = anim.AnimationId:match("%d+")
        if not id then return end

        local fullId = "rbxassetid://" .. id

        -- 🔥 CEK 23 KILLER ANIM
        if KillerAnims[fullId] then
            if not isInParryRange(char) then return end

            -- ⚡ 360° PARRY — GAK CEK DEPAN/BELAKANG/SAMPING
            doParry()
        end
    end)
end

-- Scan killer tiap 0.8 detik
task.spawn(function()
    while task.wait(0.8) do
        if Config.AutoParry.Enabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
                    hookKiller(p.Character)
                end
            end
        end
    end
end)

-- Circle visualizer untuk parry range
local function updateParryCircle()
    local root = getLocalRoot()

    if not Config.AutoParry.Enabled or not root then
        if ParryCircle then ParryCircle:Destroy(); ParryCircle = nil end
        return
    end

    if not ParryCircle then
        ParryCircle = Instance.new("Part")
        ParryCircle.Name = "TiarParryCircle"
        ParryCircle.Shape = Enum.PartType.Cylinder
        ParryCircle.Anchored = true
        ParryCircle.CanCollide = false
        ParryCircle.Material = Enum.Material.Neon
        ParryCircle.Parent = workspace
    end

    local size = Config.AutoParry.Distance * 2
    local yOffset = root.Size.Y / 2 + 1.5

    ParryCircle.Size = Vector3.new(0.1, size, size)
    ParryCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0))
        * CFrame.Angles(0, 0, math.rad(90))
    ParryCircle.Color = Theme.NEON_BLUE
    ParryCircle.Transparency = 0.85
end

-- ═══════════════════════════════════════════════════════════
--   AIMLOCK (Killer / Survivor / SCP)
-- ═══════════════════════════════════════════════════════════
local AimHolding = false
local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist

local function isVisible(part)
    RayParams.FilterDescendantsInstances = { LocalPlayer.Character }
    local origin = Camera.CFrame.Position
    local dir = part.Position - origin
    local result = workspace:Raycast(origin, dir, RayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

local function getClosestTarget()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local closest, shortest = nil, Config.Aimlock.FOV

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team then
            local valid = false
            if Config.Aimlock.Target == "Killer"   and p.Team.Name == "Killer"    then valid = true end
            if Config.Aimlock.Target == "Survivor" and p.Team.Name == "Survivors" then valid = true end

            if valid then
                local hrp = p.Character:FindFirstChild(Config.Aimlock.AimPart)
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local pos, visible = Camera:WorldToViewportPoint(hrp.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest and isVisible(hrp) then
                            shortest = dist
                            closest = hrp
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- Deteksi mouse kanan ditahan (PC)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimHolding = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimHolding = false
    end
end)

-- Loop aimlock
RunService.RenderStepped:Connect(function()
    if not Config.Aimlock.Enabled then return end
    if not AimHolding then return end

    local target = getClosestTarget()
    if not target then return end

    local pos = target.Position
    if Config.Aimlock.Predict > 0 then
        pos = pos + target.AssemblyLinearVelocity * Config.Aimlock.Predict
    end

    local cf = CFrame.new(Camera.CFrame.Position, pos)
    Camera.CFrame = Camera.CFrame:Lerp(cf, 0.35)
end)

-- ═══════════════════════════════════════════════════════════
--   CROSSHAIR (pakai Drawing API)
-- ═══════════════════════════════════════════════════════════
local CrosshairDrawings = {}
local LastCrosshairStyle = nil
local crosshairCreated = false

local function clearCrosshair()
    for _, v in pairs(CrosshairDrawings) do
        if v and v.Remove then v:Remove() end
    end
    CrosshairDrawings = {}
    crosshairCreated = false
end

local function drawCrosshair()
    local C = Config.Crosshair

    if not C.Enabled then
        for _, v in pairs(CrosshairDrawings) do
            if v then v.Visible = false end
        end
        return
    end

    if LastCrosshairStyle ~= C.Style then
        clearCrosshair()
        LastCrosshairStyle = C.Style
    end

    local center = Vector2.new(
        Camera.ViewportSize.X / 2 + C.OffsetX,
        Camera.ViewportSize.Y / 2 + C.OffsetY
    )

    if not crosshairCreated then
        crosshairCreated = true
        if C.Style == "Plus" then
            for i = 1, 4 do
                local line = Drawing.new("Line")
                line.Visible = true
                table.insert(CrosshairDrawings, line)
            end
        elseif C.Style == "Dot" then
            local dot = Drawing.new("Circle")
            dot.Filled = true
            dot.Visible = true
            table.insert(CrosshairDrawings, dot)
        elseif C.Style == "Circle" then
            local circle = Drawing.new("Circle")
            circle.Filled = false
            circle.Visible = true
            table.insert(CrosshairDrawings, circle)
        end
    end

    if C.Style == "Plus" then
        for _, line in pairs(CrosshairDrawings) do
            line.Color = C.Color
            line.Thickness = C.Thickness
            line.Visible = true
        end
        CrosshairDrawings[1].From = center + Vector2.new(-C.Size, 0)
        CrosshairDrawings[1].To   = center + Vector2.new(-2, 0)
        CrosshairDrawings[2].From = center + Vector2.new(C.Size, 0)
        CrosshairDrawings[2].To   = center + Vector2.new(2, 0)
        CrosshairDrawings[3].From = center + Vector2.new(0, -C.Size)
        CrosshairDrawings[3].To   = center + Vector2.new(0, -2)
        CrosshairDrawings[4].From = center + Vector2.new(0, C.Size)
        CrosshairDrawings[4].To   = center + Vector2.new(0, 2)
    elseif C.Style == "Dot" then
        local dot = CrosshairDrawings[1]
        dot.Position = center
        dot.Radius = C.Size / 2
        dot.Color = C.Color
        dot.Visible = true
    elseif C.Style == "Circle" then
        local circle = CrosshairDrawings[1]
        circle.Position = center
        circle.Radius = C.Size
        circle.Color = C.Color
        circle.Thickness = C.Thickness
        circle.Visible = true
    end
end

RunService.RenderStepped:Connect(function()
    updateParryCircle()
    drawCrosshair()
end)

-- ═══════════════════════════════════════════════════════════
--   UI — AUTO PARRY
-- ═══════════════════════════════════════════════════════════
local ParryToggle = ParryBox:AddToggle("AutoParry", {
    Text = "Auto Parry (360°)",
    Default = false,
    Tooltip = "Parry otomatis, gak peduli arah killer",
    Callback = function(v)
        Config.AutoParry.Enabled = v
        if v then
            notify("Auto Parry", "Aktif — 360° mode", 2)
        end
    end,
})

ParryToggle:AddKeybind({
    Text = "Toggle Key",
    Default = Enum.KeyCode.Q,
    Callback = function() end,
})

ParryBox:AddSlider("ParryDistance", {
    Text = "Parry Distance",
    Default = 15,
    Min = 5,
    Max = 30,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(v) Config.AutoParry.Distance = v end,
})

ParryBox:AddLabel("ℹ️ Parry pakai 23 Killer Anim ID")
ParryBox:AddLabel("ℹ️ Trigger: killer attack animation")

-- ═══════════════════════════════════════════════════════════
--   UI — AIMLOCK
-- ═══════════════════════════════════════════════════════════
AimlockBox:AddToggle("AimlockEnabled", {
    Text = "Aimlock",
    Default = false,
    Callback = function(v)
        Config.Aimlock.Enabled = v
    end,
})

AimlockBox:AddDropdown("AimTarget", {
    Text = "Target",
    Values = { "Killer", "Survivor" },
    Default = "Survivor",
    Multi = false,
    Callback = function(v) Config.Aimlock.Target = v end,
})

AimlockBox:AddDropdown("AimPart", {
    Text = "Aim Part",
    Values = { "Head", "HumanoidRootPart", "UpperTorso", "Torso" },
    Default = "HumanoidRootPart",
    Multi = false,
    Callback = function(v) Config.Aimlock.AimPart = v end,
})

AimlockBox:AddSlider("AimFOV", {
    Text = "FOV",
    Default = 250,
    Min = 30,
    Max = 800,
    Rounding = 0,
    Callback = function(v) Config.Aimlock.FOV = v end,
})

AimlockBox:AddSlider("AimPredict", {
    Text = "Prediction",
    Default = 0.12,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(v) Config.Aimlock.Predict = v end,
})

AimlockBox:AddLabel("ℹ️ Tahan klik kanan buat lock")

-- ═══════════════════════════════════════════════════════════
--   UI — CROSSHAIR
-- ═══════════════════════════════════════════════════════════
local CHToggle = CrosshairBox:AddToggle("CrosshairEnabled", {
    Text = "Enable Crosshair",
    Default = false,
    Callback = function(v) Config.Crosshair.Enabled = v end,
})

CHToggle:AddColorPicker("CrosshairColor", {
    Default = Color3.fromRGB(255,255,255),
    Title = "Crosshair Color",
    Callback = function(c) Config.Crosshair.Color = c end,
})

CrosshairBox:AddDropdown("CrosshairStyle", {
    Text = "Style",
    Values = { "Plus", "Dot", "Circle" },
    Default = "Plus",
    Multi = false,
    Callback = function(v) Config.Crosshair.Style = v end,
})

CrosshairBox:AddSlider("CrosshairSize", {
    Text = "Size",
    Default = 8,
    Min = 2,
    Max = 30,
    Rounding = 0,
    Callback = function(v) Config.Crosshair.Size = v end,
})

CrosshairBox:AddSlider("CrosshairThick", {
    Text = "Thickness",
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(v) Config.Crosshair.Thickness = v end,
})

CrosshairBox:AddSlider("CrosshairX", {
    Text = "Position X",
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 0,
    Callback = function(v) Config.Crosshair.OffsetX = v end,
})

CrosshairBox:AddSlider("CrosshairY", {
    Text = "Position Y",
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 0,
    Callback = function(v) Config.Crosshair.OffsetY = v end,
})

-- ═══════════════════════════════════════════════════════════
--   END OF BAGIAN 2
-- ═══════════════════════════════════════════════════════════-- ═══════════════════════════════════════════════════════════
--   TIARHUB x VIOLENCE DISTRICT
--   Bagian 3 : Tab Visuals
-- ═══════════════════════════════════════════════════════════

local Config = _G.TiarConfig
local Theme  = {
    NEON_BLUE   = Color3.fromRGB(30, 150, 255),
    WHITE_BLUE  = Color3.fromRGB(220, 235, 255),
    CYAN_ACCENT = Color3.fromRGB(0, 255, 255),
    DARK_BLUE   = Color3.fromRGB(0, 40, 90),
}

local function notify(t, d, du)
    Library:Notify({ Title = t, Description = d or "", Time = du or 3, Icon = 0 })
end

-- ═══════════════════════════════════════════════════════════
--   GROUPBOXES
-- ═══════════════════════════════════════════════════════════
local ESPBox       = Tabs.Visuals:AddLeftGroupbox("ESP - Players", "eye")
local ESPObjBox    = Tabs.Visuals:AddLeftGroupbox("ESP - Objects", "box")
local ESPStatusBox = Tabs.Visuals:AddRightGroupbox("ESP Status", "info")
local CircleBox    = Tabs.Visuals:AddRightGroupbox("ESP Circle (Self)", "circle")
local VisualBox    = Tabs.Visuals:AddLeftGroupbox("Visual Contrast", "sun")
local CameraBox    = Tabs.Visuals:AddRightGroupbox("Camera & Zoom", "camera")

-- ═══════════════════════════════════════════════════════════
--   ESP SYSTEM — Core
-- ═══════════════════════════════════════════════════════════
local ESPObjects = {}   -- [Model/Part] = Highlight
local StatusESP  = {}   -- [Character] = BillboardGui
local GenBB      = {}   -- [Generator] = BillboardGui

-- Cache objek map (biar gak scan terus-terusan)
local CachedSCP        = {}
local CachedGenerators = {}
local CachedWindows    = {}
local CachedPallets    = {}

-- ─── HIGHLIGHT CREATOR ─────────────────────────────────────
local function removeESP(obj)
    if ESPObjects[obj] then
        ESPObjects[obj]:Destroy()
        ESPObjects[obj] = nil
    end
end

local function createESP(obj, color)
    if not obj or not obj.Parent then return end

    if ESPObjects[obj] then
        -- Update warna aja
        ESPObjects[obj].FillColor    = color
        ESPObjects[obj].OutlineColor = color
        return
    end

    local h = Instance.new("Highlight")
    h.FillColor          = color
    h.OutlineColor       = color
    h.FillTransparency   = 0.85
    h.OutlineTransparency= 0.3
    h.DepthMode          = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent             = obj

    ESPObjects[obj] = h

    obj.AncestryChanged:Connect(function(_, parent)
        if not parent then removeESP(obj) end
    end)
end

-- ─── BILLBOARD CREATOR (buat ESP Status / Generator) ──────
local function createBillboard(adornee, size, offset)
    local bb = Instance.new("BillboardGui")
    bb.Name = "TiarBB"
    bb.Size = size or UDim2.new(0, 150, 0, 60)
    bb.StudsOffset = offset or Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = adornee
    bb.Parent = adornee

    local label = Instance.new("TextLabel")
    label.Name = "TiarLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextStrokeTransparency = 0
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Text = ""
    label.Parent = bb

    return bb, label
end

-- ─── CACHE BUILDER ─────────────────────────────────────────
local function cacheObject(obj)
    local name = string.lower(obj.Name)
    if name:find("scp")             then CachedSCP[obj] = true end
    if obj.Name == "Generator"      then CachedGenerators[obj] = true end
    if obj.Name == "Window"         then CachedWindows[obj] = true end
    if obj.Name == "Pallet"
       or obj.Name == "Palletwrong" then CachedPallets[obj] = true end
end

local function removeCache(obj)
    CachedSCP[obj] = nil
    CachedGenerators[obj] = nil
    CachedWindows[obj] = nil
    CachedPallets[obj] = nil
end

for _, obj in ipairs(workspace:GetDescendants()) do
    cacheObject(obj)
end

workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(function(obj)
    removeCache(obj)
    removeESP(obj)
end)

-- ═══════════════════════════════════════════════════════════
--   ESP STATUS (Nama / Distance / Health / Downed)
-- ═══════════════════════════════════════════════════════════
local function removeStatusESP(char)
    if StatusESP[char] then
        StatusESP[char]:Destroy()
        StatusESP[char] = nil
    end
end

local function isDownedChar(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return hum.Health <= 0
        or hum.Health < 2
        or char:GetAttribute("Downed")  == true
        or char:GetAttribute("IsDown")  == true
        or char:GetAttribute("Knocked") == true
end

local function updateStatusESP(player, char, myRoot)
    if not Config.ESPStatus.Enabled then
        removeStatusESP(char)
        return
    end

    local head = char:FindFirstChild("Head")
    local hum  = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    local dist = (head.Position - myRoot.Position).Magnitude
    if dist > Config.ESPStatus.Radius then
        removeStatusESP(char)
        return
    end

    local isDown = isDownedChar(char)
    local text = ""

    if isDown then text = text .. "🔻 DOWN\n" end
    if Config.ESPStatus.ShowName     then text = text .. player.Name .. "\n" end
    if Config.ESPStatus.ShowDistance then text = text .. string.format("Dist: %.0f\n", dist) end
    if Config.ESPStatus.ShowHealth   then text = text .. string.format("HP: %.0f\n", hum.Health) end

    if text == "" then removeStatusESP(char) return end

    -- Warna berdasarkan team
    local teamColor = Color3.new(1,1,1)
    if player.Team then
        if player.Team.Name == "Killer"      then teamColor = Config.ESP.KillerColor end
        if player.Team.Name == "Survivors"   then teamColor = Config.ESP.SurvivorColor end
    end
    if isDown then teamColor = Color3.fromRGB(255,0,0) end

    local bb = StatusESP[char]
    if not bb then
        bb, _ = createBillboard(head, UDim2.new(0, 130, 0, 60), Vector3.new(0, 2.5, 0))
        StatusESP[char] = bb
    end

    local label = bb:FindFirstChild("TiarLabel")
    if label then
        label.Text = text
        label.TextColor3 = teamColor
    end
end

-- ═══════════════════════════════════════════════════════════
--   ESP GENERATOR (dengan progress %)
-- ═══════════════════════════════════════════════════════════
local function getGameValue(obj, name)
    if not obj then return nil end
    local attr = obj:GetAttribute(name)
    if attr ~= nil then return attr end
    local child = obj:FindFirstChild(name)
    if child then
        local ok, val = pcall(function() return child.Value end)
        if ok then return val end
    end
    return nil
end

local function updateGenerator(gen)
    if not gen or not gen.Parent then return end

    if not Config.ESP.Generator then
        if GenBB[gen] then GenBB[gen]:Destroy(); GenBB[gen] = nil end
        removeESP(gen)
        return
    end

    local percent =
        getGameValue(gen, "RepairProgress") or
        getGameValue(gen, "Progress") or
        0

    if percent >= 100 then
        if GenBB[gen] then GenBB[gen]:Destroy(); GenBB[gen] = nil end
        return
    end

    local cp = math.clamp(percent, 0, 100)
    local color = Config.ESP.GenColor:Lerp(Color3.fromRGB(0,255,120), cp/100)
    local text = string.format("[%.0f%%]", percent)

    if not GenBB[gen] then
        local bb, _ = createBillboard(gen, UDim2.new(0, 120, 0, 30), Vector3.new(0, 3, 0))
        GenBB[gen] = bb
    end

    local label = GenBB[gen]:FindFirstChild("TiarLabel")
    if label then
        label.Text = text
        label.TextColor3 = color
    end

    createESP(gen, color)
end

-- ═══════════════════════════════════════════════════════════
--   ESP CIRCLE (Player Sendiri)
-- ═══════════════════════════════════════════════════════════
local SelfCircle = nil

local function updateSelfCircle()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not Config.ESPCircle.Enabled or not root then
        if SelfCircle then SelfCircle:Destroy(); SelfCircle = nil end
        return
    end

    if not SelfCircle then
        SelfCircle = Instance.new("Part")
        SelfCircle.Name = "TiarSelfCircle"
        SelfCircle.Shape = Enum.PartType.Cylinder
        SelfCircle.Anchored = true
        SelfCircle.CanCollide = false
        SelfCircle.Material = Enum.Material.Neon
        SelfCircle.Parent = workspace
    end

    local C = Config.ESPCircle
    local yOffset = root.Size.Y / 2 + 0.5

    SelfCircle.Size = Vector3.new(C.Thickness, C.Size, C.Size)
    SelfCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0))
        * CFrame.Angles(0, 0, math.rad(90))
    SelfCircle.Color = C.Color
    SelfCircle.Transparency = C.Transparency
end

-- ═══════════════════════════════════════════════════════════
--   VISUAL CONTRAST (ColorCorrection)
-- ═══════════════════════════════════════════════════════════
local ColorCorrection = Instance.new("ColorCorrectionEffect")
ColorCorrection.Name = "TiarContrast"
ColorCorrection.Enabled = false
ColorCorrection.Parent = Lighting

local function applyContrast()
    local C = Config.VisualContrast
    if C.Enabled then
        ColorCorrection.Enabled = true
        ColorCorrection.Contrast = C.Contrast
        ColorCorrection.Saturation = C.Saturation
        ColorCorrection.Brightness = C.Brightness
        ColorCorrection.TintColor = C.Tint
    else
        ColorCorrection.Enabled = false
    end
end

-- Preset
local ContrastPresets = {
    ["Default"]      = { Enabled = false, Contrast = 1.0, Saturation = 1.0, Brightness = 0.0,  Tint = Color3.fromRGB(255,255,255) },
    ["Competitive"]  = { Enabled = true,  Contrast = 1.4, Saturation = 1.3, Brightness = 0.05, Tint = Color3.fromRGB(255,255,255) },
    ["Horror"]       = { Enabled = true,  Contrast = 1.6, Saturation = 0.8, Brightness = -0.05,Tint = Color3.fromRGB(180,100,100) },
    ["Night Vision"] = { Enabled = true,  Contrast = 1.5, Saturation = 1.2, Brightness = 0.3,  Tint = Color3.fromRGB(80,255,120) },
    ["FPS Boost"]    = { Enabled = true,  Contrast = 1.1, Saturation = 0.7, Brightness = 0.0,  Tint = Color3.fromRGB(255,255,255) },
}

-- ═══════════════════════════════════════════════════════════
--   FULLBRIGHT
-- ═══════════════════════════════════════════════════════════
local FBOriginal = {
    Brightness = Lighting.Brightness,
    ClockTime  = Lighting.ClockTime,
    Ambient    = Lighting.Ambient,
    Outdoor    = Lighting.OutdoorAmbient,
    Shadows    = Lighting.GlobalShadows,
}

local function applyFullbright()
    if Config.Fullbright.Enabled then
        Lighting.Brightness     = 2
        Lighting.ClockTime      = 14
        Lighting.Ambient        = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    else
        Lighting.Brightness     = FBOriginal.Brightness
        Lighting.ClockTime      = FBOriginal.ClockTime
        Lighting.Ambient        = FBOriginal.Ambient
        Lighting.OutdoorAmbient = FBOriginal.Outdoor
    end
end

-- ═══════════════════════════════════════════════════════════
--   MAIN VISUAL LOOP
-- ═══════════════════════════════════════════════════════════
local lastVisualUpdate = 0

RunService.RenderStepped:Connect(function()
    local now = tick()

    -- Update tiap 0.05 detik (20 FPS cukup buat ESP)
    if now - lastVisualUpdate < 0.05 then
        updateSelfCircle()
        return
    end
    lastVisualUpdate = now

    local root = LocalPlayer.Character
        and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- ── ESP PLAYER ──
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")

            if hum and hrp and hum.Health > 0 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist <= Config.ESP.Distance then
                    if Config.ESP.Survivor and p.Team and p.Team.Name == "Survivors" then
                        createESP(char, Config.ESP.SurvivorColor)
                    elseif Config.ESP.Killer and p.Team and p.Team.Name == "Killer" then
                        createESP(char, Config.ESP.KillerColor)
                    else
                        removeESP(char)
                    end
                else
                    removeESP(char)
                end
                updateStatusESP(p, char, root)
            else
                removeESP(char)
                removeStatusESP(char)
            end
        end
    end

    -- ── ESP GENERATOR ──
    if Config.ESP.Generator then
        for gen in pairs(CachedGenerators) do
            updateGenerator(gen)
        end
    end

    -- ── ESP SCP ──
    if Config.ESP.SCP then
        for obj in pairs(CachedSCP) do
            if obj and obj.Parent then
                local pos
                if obj:IsA("Model")      then pos = obj:GetPivot().Position
                elseif obj:IsA("BasePart") then pos = obj.Position end
                if pos then
                    local dist = (pos - root.Position).Magnitude
                    if dist <= Config.ESP.Distance then
                        createESP(obj, Config.ESP.SCPColor)
                    else
                        removeESP(obj)
                    end
                end
            end
        end
    else
        for obj in pairs(CachedSCP) do removeESP(obj) end
    end

    -- ── ESP WINDOW ──
    for obj in pairs(CachedWindows) do
        if obj and obj.Parent then
            local pos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
            local dist = (pos - root.Position).Magnitude
            if Config.ESP.Window and dist <= Config.ESP.Distance then
                createESP(obj, Config.ESP.WindowColor)
            else
                removeESP(obj)
            end
        end
    end

    -- ── ESP PALLET ──
    for obj in pairs(CachedPallets) do
        if obj and obj.Parent then
            local pos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
            local dist = (pos - root.Position).Magnitude
            if Config.ESP.Pallet and dist <= Config.ESP.Distance then
                createESP(obj, Config.ESP.PalletColor)
            else
                removeESP(obj)
            end
        end
    end

    updateSelfCircle()
end)

-- ═══════════════════════════════════════════════════════════
--   UI — ESP PLAYERS
-- ═══════════════════════════════════════════════════════════
local SurvivorESPToggle = ESPBox:AddToggle("SurvivorESP", {
    Text = "ESP Survivor",
    Default = false,
    Callback = function(v) Config.ESP.Survivor = v end,
})
SurvivorESPToggle:AddColorPicker("SurvivorESPColor", {
    Default = Config.ESP.SurvivorColor,
    Title = "Survivor Color",
    Callback = function(c) Config.ESP.SurvivorColor = c end,
})

local KillerESPToggle = ESPBox:AddToggle("KillerESP", {
    Text = "ESP Killer",
    Default = false,
    Callback = function(v) Config.ESP.Killer = v end,
})
KillerESPToggle:AddColorPicker("KillerESPColor", {
    Default = Config.ESP.KillerColor,
    Title = "Killer Color",
    Callback = function(c) Config.ESP.KillerColor = c end,
})

ESPBox:AddSlider("ESPDistance", {
    Text = "ESP Radius",
    Default = 300,
    Min = 20,
    Max = 2000,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(v) Config.ESP.Distance = v end,
})

-- ═══════════════════════════════════════════════════════════
--   UI — ESP OBJECTS
-- ═══════════════════════════════════════════════════════════
local GenESPToggle = ESPObjBox:AddToggle("ESPGenerator", {
    Text = "ESP Generator (progress)",
    Default = false,
    Callback = function(v) Config.ESP.Generator = v end,
})
GenESPToggle:AddColorPicker("GenESPColor", {
    Default = Config.ESP.GenColor,
    Title = "Generator Color",
    Callback = function(c) Config.ESP.GenColor = c end,
})

local SCPESPToggle = ESPObjBox:AddToggle("ESPSCP", {
    Text = "ESP SCP",
    Default = false,
    Callback = function(v) Config.ESP.SCP = v end,
})
SCPESPToggle:AddColorPicker("SCPColor", {
    Default = Config.ESP.SCPColor,
    Title = "SCP Color",
    Callback = function(c) Config.ESP.SCPColor = c end,
})

local PalletESPToggle = ESPObjBox:AddToggle("ESPPallet", {
    Text = "ESP Pallet",
    Default = false,
    Callback = function(v) Config.ESP.Pallet = v end,
})
PalletESPToggle:AddColorPicker("PalletColor", {
    Default = Config.ESP.PalletColor,
    Title = "Pallet Color",
    Callback = function(c) Config.ESP.PalletColor = c end,
})

local WindowESPToggle = ESPObjBox:AddToggle("ESPWindow", {
    Text = "ESP Window",
    Default = false,
    Callback = function(v) Config.ESP.Window = v end,
})
WindowESPToggle:AddColorPicker("WindowColor", {
    Default = Config.ESP.WindowColor,
    Title = "Window Color",
    Callback = function(c) Config.ESP.WindowColor = c end,
})

-- ═══════════════════════════════════════════════════════════
--   UI — ESP STATUS
-- ═══════════════════════════════════════════════════════════
ESPStatusBox:AddToggle("ESPStatusEnabled", {
    Text = "Enable Status ESP",
    Default = false,
    Callback = function(v) Config.ESPStatus.Enabled = v end,
})

ESPStatusBox:AddToggle("ShowName", {
    Text = "Show Name",
    Default = true,
    Callback = function(v) Config.ESPStatus.ShowName = v end,
})

ESPStatusBox:AddToggle("ShowDist", {
    Text = "Show Distance",
    Default = true,
    Callback = function(v) Config.ESPStatus.ShowDistance = v end,
})

ESPStatusBox:AddToggle("ShowHP", {
    Text = "Show Health",
    Default = false,
    Callback = function(v) Config.ESPStatus.ShowHealth = v end,
})

ESPStatusBox:AddSlider("StatusRadius", {
    Text = "Status Radius",
    Default = 200,
    Min = 20,
    Max = 1000,
    Rounding = 0,
    Callback = function(v) Config.ESPStatus.Radius = v end,
})

-- ═══════════════════════════════════════════════════════════
--   UI — ESP CIRCLE (PLAYER SENDIRI)
-- ═══════════════════════════════════════════════════════════
local CircleToggle = CircleBox:AddToggle("ESPCircleEnabled", {
    Text = "Enable ESP Circle",
    Default = false,
    Tooltip = "Lingkaran neon di bawah player sendiri",
    Callback = function(v) Config.ESPCircle.Enabled = v end,
})
CircleToggle:AddColorPicker("ESPCircleColor", {
    Default = Config.ESPCircle.Color,
    Title = "Circle Color",
    Callback = function(c) Config.ESPCircle.Color = c end,
})

CircleBox:AddSlider("CircleSize", {
    Text = "Circle Size",
    Default = 6,
    Min = 2,
    Max = 50,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(v) Config.ESPCircle.Size = v end,
})

CircleBox:AddSlider("CircleThick", {
    Text = "Circle Thickness",
    Default = 0.1,
    Min = 0.05,
    Max = 1,
    Rounding = 2,
    Callback = function(v) Config.ESPCircle.Thickness = v end,
})

CircleBox:AddSlider("CircleTrans", {
    Text = "Circle Transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(v) Config.ESPCircle.Transparency = v end,
})

-- ═══════════════════════════════════════════════════════════
--   UI — VISUAL CONTRAST
-- ═══════════════════════════════════════════════════════════
VisualBox:AddDropdown("ContrastPreset", {
    Text = "Preset",
    Values = { "Default", "Competitive", "Horror", "Night Vision", "FPS Boost" },
    Default = "Default",
    Multi = false,
    Callback = function(v)
        local preset = ContrastPresets[v]
        if not preset then return end
        Config.VisualContrast = {
            Enabled = preset.Enabled,
            Contrast = preset.Contrast,
            Saturation = preset.Saturation,
            Brightness = preset.Brightness,
            Tint = preset.Tint,
        }
        applyContrast()
        notify("Contrast", "Preset: " .. v, 2)
    end,
})

VisualBox:AddToggle("ContrastEnabled", {
    Text = "Enable Contrast",
    Default = false,
    Callback = function(v)
        Config.VisualContrast.Enabled = v
        applyContrast()
    end,
})

VisualBox:AddSlider("ContrastValue", {
    Text = "Contrast",
    Default = 1.0,
    Min = 0.5,
    Max = 2.5,
    Rounding = 2,
    Callback = function(v)
        Config.VisualContrast.Contrast = v
        applyContrast()
    end,
})

VisualBox:AddSlider("SaturationValue", {
    Text = "Saturation",
    Default = 1.0,
    Min = 0,
    Max = 2.5,
    Rounding = 2,
    Callback = function(v)
        Config.VisualContrast.Saturation = v
        applyContrast()
    end,
})

VisualBox:AddSlider("BrightnessValue", {
    Text = "Brightness",
    Default = 0.0,
    Min = -0.5,
    Max = 0.5,
    Rounding = 2,
    Callback = function(v)
        Config.VisualContrast.Brightness = v
        applyContrast()
    end,
})

VisualBox:AddColorPicker("TintColor", {
    Default = Color3.fromRGB(255,255,255),
    Title = "Tint Color",
    Callback = function(c)
        Config.VisualContrast.Tint = c
        applyContrast()
    end,
})

VisualBox:AddDivider()

VisualBox:AddToggle("FullbrightToggle", {
    Text = "Fullbright",
    Default = false,
    Callback = function(v)
        Config.Fullbright.Enabled = v
        applyFullbright()
    end,
})

-- ═══════════════════════════════════════════════════════════
--   UI — CAMERA & ZOOM
-- ═══════════════════════════════════════════════════════════
local ZoomToggle = CameraBox:AddToggle("UnlimitedZoom", {
    Text = "Unlimited Zoom",
    Default = false,
    Callback = function(v)
        Config.Zoom.Enabled = v
        if v then
            LocalPlayer.CameraMaxZoomDistance = Config.Zoom.Max
            LocalPlayer.CameraMinZoomDistance = 0
        else
            LocalPlayer.CameraMaxZoomDistance = 128
            LocalPlayer.CameraMinZoomDistance = 0.5
        end
    end,
})

CameraBox:AddSlider("ZoomMax", {
    Text = "Max Zoom Distance",
    Default = 1000,
    Min = 100,
    Max = 5000,
    Rounding = 0,
    Callback = function(v)
        Config.Zoom.Max = v
        if Config.Zoom.Enabled then
            LocalPlayer.CameraMaxZoomDistance = v
        end
    end,
})

local FOVToggle = CameraBox:AddToggle("CustomFOV", {
    Text = "Custom FOV",
    Default = false,
    Callback = function(v)
        Config.FOV.Enabled = v
        if v then
            Camera.FieldOfView = Config.FOV.Value
        else
            Camera.FieldOfView = 70
        end
    end,
})

CameraBox:AddSlider("FOVValue", {
    Text = "FOV Value",
    Default = 70,
    Min = 30,
    Max = 120,
    Rounding = 0,
    Callback = function(v)
        Config.FOV.Value = v
        if Config.FOV.Enabled then
            Camera.FieldOfView = v
        end
    end,
})

-- ═══════════════════════════════════════════════════════════
--   APPLY SAAT RESPAWN
-- ═══════════════════════════════════════════════════════════
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if Config.Fullbright.Enabled then applyFullbright() end
    if Config.ESPCircle.Enabled and SelfCircle then
        SelfCircle:Destroy()
        SelfCircle = nil
    end
end)

-- ═══════════════════════════════════════════════════════════
--   END OF BAGIAN 3
-- ═══════════════════════════════════════════════════════════-- ═══════════════════════════════════════════════════════════
--   TIARHUB x VIOLENCE DISTRICT
--   Bagian 4 : Tab Movement
-- ═══════════════════════════════════════════════════════════

local Config = _G.TiarConfig
local Theme  = {
    NEON_BLUE  = Color3.fromRGB(30, 150, 255),
    WHITE_BLUE = Color3.fromRGB(220, 235, 255),
}

local function notify(t, d, du)
    Library:Notify({ Title = t, Description = d or "", Time = du or 3, Icon = 0 })
end

-- ═══════════════════════════════════════════════════════════
--   GROUPBOXES
-- ═══════════════════════════════════════════════════════════
local SpeedBox    = Tabs.Movement:AddLeftGroupbox("Speed", "zap")
local JumpBox     = Tabs.Movement:AddLeftGroupbox("Jump", "arrow-up")
local VaultBox    = Tabs.Movement:AddRightGroupbox("Vault & Animation", "activity")
local MoonwalkBox = Tabs.Movement:AddRightGroupbox("Moonwalk", "moon")
local TeleportBox = Tabs.Movement:AddLeftGroupbox("Teleport", "map-pin")

-- ═══════════════════════════════════════════════════════════
--   HELPER
-- ═══════════════════════════════════════════════════════════
local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Cek kondisi khusus (down, stun, animasi tertentu) → pause walkspeed
local PauseAnims = {
    ["rbxassetid://127096285501517"] = true,  -- Parry
    ["rbxassetid://112166042383605"] = true,  -- Break Pallet
    ["rbxassetid://123047897844134"] = true,  -- Stun
    ["http://www.roblox.com/asset/?id=126965695851149"] = true,  -- WalkCrouch
    ["http://www.roblox.com/asset/?id=135084204086504"] = true,  -- WalkCrouchInjured
}

local function shouldPauseMods()
    local char = LocalPlayer.Character
    if not char then return true end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return true end

    -- Downed check
    if hum.Health <= 0
    or hum.Health < 2
    or char:GetAttribute("Downed")  == true
    or char:GetAttribute("IsDown")  == true
    or char:GetAttribute("Knocked") == true then
        return true
    end

    -- Anim check
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            local anim = track.Animation
            if anim and anim.AnimationId then
                local normalized = anim.AnimationId
                if PauseAnims[normalized] then return true end

                -- Cek killer anim juga
                local id = normalized:match("%d+")
                if id then
                    local fullId = "rbxassetid://" .. id
                    if _G.KillerAnims[fullId] then return true end
                end
            end
        end
    end

    return false
end

-- ═══════════════════════════════════════════════════════════
--   WALKSPEED
-- ═══════════════════════════════════════════════════════════
local WalkConn = nil
local OriginalWalkSpeed = 16

local function applyWalkSpeed()
    if WalkConn then WalkConn:Disconnect(); WalkConn = nil end
    if not Config.WalkSpeed.Enabled then return end

    WalkConn = RunService.Heartbeat:Connect(function()
        if not Config.WalkSpeed.Enabled then return end
        if shouldPauseMods() then return end

        local hum = getHum()
        if not hum then return end

        if hum.WalkSpeed ~= Config.WalkSpeed.Value then
            hum.WalkSpeed = Config.WalkSpeed.Value
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
--   JUMP POWER
-- ═══════════════════════════════════════════════════════════
local JumpConn = nil
local OriginalJumpPower = 50

local function applyJumpPower()
    if JumpConn then JumpConn:Disconnect(); JumpConn = nil end
    if not Config.JumpPower.Enabled then return end

    JumpConn = RunService.Heartbeat:Connect(function()
        if not Config.JumpPower.Enabled then return end
        if shouldPauseMods() then return end

        local hum = getHum()
        if not hum then return end

        if hum.UseJumpPower then
            if hum.JumpPower ~= Config.JumpPower.Value then
                hum.JumpPower = Config.JumpPower.Value
            end
        else
            if hum.JumpHeight ~= Config.JumpPower.Value / 7.5 then
                hum.JumpHeight = Config.JumpPower.Value / 7.5
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
--   NOCLIP
-- ═══════════════════════════════════════════════════════════
local NoClipConn = nil

local function enableNoClip()
    if NoClipConn then NoClipConn:Disconnect(); NoClipConn = nil end

    NoClipConn = RunService.Stepped:Connect(function()
        if not Config.NoClip.Enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

local function disableNoClip()
    if NoClipConn then NoClipConn:Disconnect(); NoClipConn = nil end
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════
--   MOONWALK
-- ═══════════════════════════════════════════════════════════
local MoonwalkConn = nil
local MoonwalkButton = nil
local ParryActiveRef = false  -- di-set dari Bagian 2 kalau perlu

local function startMoonwalk()
    if MoonwalkConn then return end

    MoonwalkConn = RunService.RenderStepped:Connect(function()
        if not Config.Moonwalk.Enabled then return end
        if shouldPauseMods() then return end

        local char = LocalPlayer.Character
        if not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not hum or not hrp or not cam then return end

        if Config.Moonwalk.Enabled and hum.WalkSpeed ~= Config.Moonwalk.Slow then
            hum.WalkSpeed = Config.Moonwalk.Slow
        end

        local look = cam.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit
            local baseCF = CFrame.new(hrp.Position, hrp.Position + flatLook)
            local angle = math.sin(tick() * Config.Moonwalk.Spam) * Config.Moonwalk.Intensity
            hrp.CFrame = baseCF * CFrame.Angles(0, math.rad(angle), 0)
            hum:Move(Vector3.new(0, 0, 1), true)
        end
    end)
end

local function stopMoonwalk()
    if MoonwalkConn then
        MoonwalkConn:Disconnect()
        MoonwalkConn = nil
    end
    local hum = getHum()
    if hum then
        if Config.WalkSpeed.Enabled then
            hum.WalkSpeed = Config.WalkSpeed.Value
        else
            hum.WalkSpeed = OriginalWalkSpeed
        end
    end
end

-- ─── Moonwalk BUTTON (on-screen) ───────────────────────────
local function createMoonwalkButton()
    if MoonwalkButton then MoonwalkButton:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "TiarMoonwalkButton"
    gui.ResetOnSpawn = false
    gui.Parent = PlayerGui

    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0.65, 0, 0.75, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.9
    btn.Image = "rbxassetid://93349170559446"
    btn.ImageTransparency = 0.1
    btn.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        Config.Moonwalk.Enabled = not Config.Moonwalk.Enabled
        if Config.Moonwalk.Enabled then
            stroke.Color = Color3.fromRGB(170, 0, 255)
            startMoonwalk()
        else
            stroke.Color = Color3.fromRGB(255, 255, 255)
            stopMoonwalk()
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

-- ═══════════════════════════════════════════════════════════
--   FAST VAULT (Anim Replace)
-- ═══════════════════════════════════════════════════════════
local VaultReplace = {
    ["rbxassetid://83873880822918"] = "rbxassetid://136962284480779",  -- Running → Finesse
}

local VaultTracks = {}

local function normalizeId(id)
    local num = tostring(id):match("%d+")
    return num and ("rbxassetid://" .. num)
end

local function hookVault(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    animator.AnimationPlayed:Connect(function(track)
        if not Config.FastVault.Enabled then return end

        local anim = track.Animation
        if not anim or not anim.AnimationId then return end

        local id = normalizeId(anim.AnimationId)
        if not id then return end

        local replaceId = VaultReplace[id]
        if not replaceId then return end
        if VaultTracks[track] then return end

        VaultTracks[track] = true
        track:Stop()

        local newAnim = Instance.new("Animation")
        newAnim.AnimationId = replaceId

        local newTrack = animator:LoadAnimation(newAnim)
        newTrack.Priority = Enum.AnimationPriority.Action
        newTrack:Play()
        newTrack:AdjustSpeed(Config.FastVault.Speed)

        newTrack.Stopped:Connect(function()
            VaultTracks[track] = nil
        end)
    end)
end

-- ═══════════════════════════════════════════════════════════
--   ANIMATION SPEED (global)
-- ═══════════════════════════════════════════════════════════
local AnimSpeedConn = nil

local function applyAnimSpeed()
    if AnimSpeedConn then AnimSpeedConn:Disconnect(); AnimSpeedConn = nil end

    AnimSpeedConn = RunService.Heartbeat:Connect(function()
        if not Config.FastVault.Enabled then return end
        local hum = getHum()
        if not hum then return end

        local animator = hum:FindFirstChildOfClass("Animator")
        if not animator then return end

        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:AdjustSpeed(Config.FastVault.Speed)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
--   INSTANT ESCAPE (Teleport ke Finish Line)
-- ═══════════════════════════════════════════════════════════
local function teleportToFinishLine()
    local root = getRoot()
    if not root then
        notify("Escape", "Player gak ada", 2)
        return
    end

    local found = nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if string.lower(obj.Name) == "fininshline" and obj:IsA("BasePart") then
            found = obj
            break
        end
    end

    if not found then
        -- Fallback: cari Exit / Finish
        for _, obj in ipairs(workspace:GetDescendants()) do
            local n = string.lower(obj.Name)
            if obj:IsA("BasePart") and (n:find("exit") or n:find("finish")) then
                found = obj
                break
            end
        end
    end

    if not found then
        notify("Escape", "Finish line gak ketemu", 2)
        return
    end

    root.CFrame = found.CFrame + Vector3.new(0, 5, 0)
    notify("Escape", "Teleported!", 2)
end

-- ═══════════════════════════════════════════════════════════
--   UI — SPEED
-- ═══════════════════════════════════════════════════════════
SpeedBox:AddToggle("WalkSpeedToggle", {
    Text = "Walk Speed",
    Default = false,
    Callback = function(v)
        Config.WalkSpeed.Enabled = v
        if v then
            applyWalkSpeed()
        else
            if WalkConn then WalkConn:Disconnect(); WalkConn = nil end
            local hum = getHum()
            if hum then hum.WalkSpeed = OriginalWalkSpeed end
        end
    end,
})

SpeedBox:AddSlider("WalkSpeedSlider", {
    Text = "Walk Speed Value",
    Default = 17.6,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Callback = function(v) Config.WalkSpeed.Value = v end,
})

SpeedBox:AddSlider("SpamSpeedValue", {
    Text = "Spam Speed",
    Default = 30,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Tooltip = "Kecepatan rotasi moonwalk / spam movement",
    Callback = function(v) Config.Moonwalk.Spam = v end,
})

SpeedBox:AddSlider("IntensityValue", {
    Text = "Intensity",
    Default = 35,
    Min = 1,
    Max = 90,
    Rounding = 0,
    Tooltip = "Sudut rotasi moonwalk (derajat)",
    Callback = function(v) Config.Moonwalk.Intensity = v end,
})

-- ═══════════════════════════════════════════════════════════
--   UI — JUMP
-- ═══════════════════════════════════════════════════════════
JumpBox:AddToggle("JumpPowerToggle", {
    Text = "Custom Jump Power",
    Default = false,
    Callback = function(v)
        Config.JumpPower.Enabled = v
        if v then
            applyJumpPower()
        else
            if JumpConn then JumpConn:Disconnect(); JumpConn = nil end
            local hum = getHum()
            if hum then
                if hum.UseJumpPower then
                    hum.JumpPower = OriginalJumpPower
                else
                    hum.JumpHeight = OriginalJumpPower / 7.5
                end
            end
        end
    end,
})

JumpBox:AddSlider("JumpPowerValue", {
    Text = "Jump Power",
    Default = 50,
    Min = 0,
    Max = 300,
    Rounding = 0,
    Callback = function(v) Config.JumpPower.Value = v end,
})

JumpBox:AddDivider()

JumpBox:AddToggle("NoClipToggle", {
    Text = "No Clip",
    Default = false,
    Tooltip = "Tembus dinding & objek",
    Callback = function(v)
        Config.NoClip.Enabled = v
        if v then enableNoClip() else disableNoClip() end
    end,
})

-- ═══════════════════════════════════════════════════════════
--   UI — VAULT
-- ═══════════════════════════════════════════════════════════
VaultBox:AddToggle("FastVaultToggle", {
    Text = "Fast Vault",
    Default = false,
    Callback = function(v)
        Config.FastVault.Enabled = v
    end,
})

VaultBox:AddSlider("VaultSpeedFactor", {
    Text = "Vault Speed Factor",
    Default = 1.2,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Tooltip = "1 = normal, 5 = super cepat",
    Callback = function(v) Config.FastVault.Speed = v end,
})

VaultBox:AddToggle("GlobalAnimSpeed", {
    Text = "Global Anim Speed",
    Default = false,
    Callback = function(v)
        Config.FastVault.Enabled = v
        if v then applyAnimSpeed() else
            if AnimSpeedConn then AnimSpeedConn:Disconnect(); AnimSpeedConn = nil end
        end
    end,
})

-- ═══════════════════════════════════════════════════════════
--   UI — MOONWALK
-- ═══════════════════════════════════════════════════════════
local MWToggle = MoonwalkBox:AddToggle("MoonwalkEnabled", {
    Text = "Moonwalk (PC Keybind)",
    Default = false,
    Callback = function(v)
        Config.Moonwalk.Enabled = v
        if v then startMoonwalk() else stopMoonwalk() end
    end,
})
MWToggle:AddKeybind({
    Text = "Keybind",
    Default = Enum.KeyCode.V,
    Callback = function() end,
})

MoonwalkBox:AddToggle("MoonwalkButtonToggle", {
    Text = "Moonwalk On-Screen Button",
    Default = false,
    Callback = function(v)
        if v then createMoonwalkButton() else removeMoonwalkButton() end
    end,
})

MoonwalkBox:AddSlider("MoonwalkSlowSpeed", {
    Text = "Moonwalk Speed",
    Default = 13,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Callback = function(v) Config.Moonwalk.Slow = v end,
})

-- ═══════════════════════════════════════════════════════════
--   UI — TELEPORT
-- ═══════════════════════════════════════════════════════════
TeleportBox:AddButton({
    Text = "⚡ Instant Escape",
    Func = function() teleportToFinishLine() end,
})

TeleportBox:AddButton({
    Text = "📡 Teleport ke Generator",
    Func = function()
        local root = getRoot()
        if not root then return end

        local nearest, dist = nil, math.huge
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == "Generator" then
                local pivot = obj:GetPivot().Position
                local d = (pivot - root.Position).Magnitude
                if d < dist then dist = d; nearest = obj end
            end
        end

        if nearest then
            root.CFrame = CFrame.new(nearest:GetPivot().Position + Vector3.new(0,5,0))
            notify("TP", "Generator terdekat", 2)
        else
            notify("TP", "Gak ada generator", 2)
        end
    end,
})

-- ═══════════════════════════════════════════════════════════
--   AUTO APPLY SAAT RESPAWN
-- ═══════════════════════════════════════════════════════════
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)

    -- Reset nilai original
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        OriginalWalkSpeed = hum.WalkSpeed
        OriginalJumpPower = hum.UseJumpPower and hum.JumpPower or 50
    end

    -- Re-apply kalau toggle masih nyala
    if Config.WalkSpeed.Enabled then applyWalkSpeed() end
    if Config.JumpPower.Enabled then applyJumpPower() end
    if Config.NoClip.Enabled then enableNoClip() end
    if Config.Moonwalk.Enabled then startMoonwalk() end
    if Config.FastVault.Enabled then hookVault(char) end
end)

-- Apply ke karakter sekarang
if LocalPlayer.Character then
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        OriginalWalkSpeed = hum.WalkSpeed
        OriginalJumpPower = hum.UseJumpPower and hum.JumpPower or 50
    end
    hookVault(LocalPlayer.Character)
end

-- ═══════════════════════════════════════════════════════════
--   END OF BAGIAN 4
-- ═══════════════════════════════════════════════════════════-- ═══════════════════════════════════════════════════════════
--   TIARHUB x VIOLENCE DISTRICT
--   Bagian 5 : Tab Auto
-- ═══════════════════════════════════════════════════════════

local Config = _G.TiarConfig
local Theme  = {
    NEON_BLUE  = Color3.fromRGB(30, 150, 255),
    WHITE_BLUE = Color3.fromRGB(220, 235, 255),
}

local function notify(t, d, du)
    Library:Notify({ Title = t, Description = d or "", Time = du or 3, Icon = 0 })
end

-- ═══════════════════════════════════════════════════════════
--   GROUPBOXES
-- ═══════════════════════════════════════════════════════════
local SkillBox  = Tabs.Auto:AddLeftGroupbox("Auto Skill Check", "check")
local WiggleBox = Tabs.Auto:AddLeftGroupbox("Auto Wiggle",       "activity")
local FleeBox   = Tabs.Auto:AddRightGroupbox("Auto Flee Killer", "run")
local StalkBox  = Tabs.Auto:AddRightGroupbox("Auto Stalk (Killer)", "eye")

-- ═══════════════════════════════════════════════════════════
--   HELPER
-- ═══════════════════════════════════════════════════════════
local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- ═══════════════════════════════════════════════════════════
--   AUTO SKILL CHECK
-- ═══════════════════════════════════════════════════════════
-- Logic:
--   1. Cari GUI SkillCheckPromptGui
--   2. Baca rotasi Line vs Goal
--   3. Kalau Line masuk zona Goal → tekan Space (PC) / tap button (Mobile)
-- ═══════════════════════════════════════════════════════════

local SkillConn = nil
local SkillBusy = false
local SkillLastHit = 0

-- PC: tekan Space
local function pressSpace()
    VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.Space, false, game)
    task.wait(0.03)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

-- Mobile: tap tombol action.check
local TouchID = 8822
local ActionPath = "Survivor-mob.Controls.action.check"

local function getActionTarget()
    local cur = PlayerGui
    for seg in string.gmatch(ActionPath, "[^%.]+") do
        cur = cur and cur:FindFirstChild(seg)
    end
    return cur
end

local function triggerMobileButton()
    local btn = getActionTarget()
    if btn and btn:IsA("GuiObject") then
        local pos   = btn.AbsolutePosition
        local size  = btn.AbsoluteSize
        local inset = game:GetService("GuiService"):GetGuiInset()
        local x = pos.X + size.X/2 + inset.X
        local y = pos.Y + size.Y/2 + inset.Y

        pcall(function()
            VirtualInputManager:SendTouchEvent(TouchID, 0, x, y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(TouchID, 2, x, y)
        end)
    end
end

local function startSkillCheck()
    if SkillConn then SkillConn:Disconnect() end

    SkillConn = RunService.RenderStepped:Connect(function()
        if not Config.AutoSkillCheck.Enabled then return end
        if SkillBusy then return end

        local now = tick()
        if now - SkillLastHit < 0.15 then return end

        local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
        if not prompt then return end

        local check = prompt:FindFirstChild("Check")
        if not check or not check.Visible then return end

        local line = check:FindFirstChild("Line")
        local goal = check:FindFirstChild("Goal")
        if not line or not goal then return end

        local lr = line.Rotation % 360
        local gr = goal.Rotation % 360

        -- Zona goal: sekitar 14° dari titik goal
        local startRange = (gr + 102) % 360
        local endRange   = (gr + 116) % 360

        local success = (startRange > endRange and (lr >= startRange or lr <= endRange))
                        or (lr >= startRange and lr <= endRange)

        if success then
            SkillBusy = true
            SkillLastHit = now

            task.spawn(function()
                if UserInputService.TouchEnabled then
                    triggerMobileButton()
                else
                    pressSpace()
                end
                task.wait(0.05)
                SkillBusy = false
            end)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
--   AUTO WIGGLE
-- ═══════════════════════════════════════════════════════════
-- Logic:
--   Cek apakah player lagi digendong (IsCarried)
--   Kalau iya → spam SelfUnHookEvent
-- ═══════════════════════════════════════════════════════════

local function isCarried()
    local char = LocalPlayer.Character
    if not char then return false end

    local carried = char:FindFirstChild("IsCarried")
    local carrying = char:FindFirstChild("IsCarrying")

    if carried and carried.Value then return true end
    if carrying and carrying.Value then return true end
    return false
end

local function getWiggleRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return nil end
    local carry = remotes:FindFirstChild("Carry")
    if not carry then return nil end
    return carry:FindFirstChild("SelfUnHookEvent")
end

local WiggleConn = nil

local function startAutoWiggle()
    if WiggleConn then WiggleConn:Disconnect() end

    WiggleConn = RunService.Heartbeat:Connect(function()
        if not Config.AutoWiggle.Enabled then return end
        if not isCarried() then return end

        local event = getWiggleRemote()
        if not event then return end

        for i = 1, Config.AutoWiggle.Spam do
            pcall(function() event:FireServer() end)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
--   AUTO FLEE KILLER
-- ═══════════════════════════════════════════════════════════
-- Logic:
--   Cari killer terdekat
--   Kalau dalam range → TP ke GeneratorPoint yang paling jauh dari killer
-- ═══════════════════════════════════════════════════════════

local FleeLastTick = 0

local function getNearestKiller()
    local root = getRoot()
    if not root then return nil end

    local closest, shortest = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team and p.Team.Name == "Killer" and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - root.Position).Magnitude
                if d < shortest then
                    shortest = d
                    closest = hrp
                end
            end
        end
    end
    return closest, shortest
end

local function getFarthestGeneratorPoint(killerRoot)
    if not killerRoot then return nil end

    local best, dist = nil, 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.match(obj.Name, "^GeneratorPoint%d+$") then
            local d = (obj.Position - killerRoot.Position).Magnitude
            if d > dist then
                dist = d
                best = obj
            end
        end
    end
    return best
end

task.spawn(function()
    while task.wait(0.2) do
        if not Config.AutoFlee.Enabled then continue end

        local root = getRoot()
        if not root then continue end

        local killerRoot, distance = getNearestKiller()
        if killerRoot and distance and distance <= Config.AutoFlee.Distance
           and tick() - FleeLastTick > Config.AutoFlee.Cooldown then

            local point = getFarthestGeneratorPoint(killerRoot)
            if point then
                FleeLastTick = tick()
                root.CFrame = point.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
--   AUTO STALK (buat Killer — karakter Myers-like)
-- ═══════════════════════════════════════════════════════════
local StalkConn = nil

local function getClosestSurvivorForStalk()
    local root = getRoot()
    if not root then return nil end

    local closest, shortest = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local d = (hrp.Position - root.Position).Magnitude
                if d <= Config.Stalk.Range and d < shortest then
                    shortest = d
                    closest = p
                end
            end
        end
    end
    return closest
end

local function getStalkRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return nil end
    local killers = remotes:FindFirstChild("Killers")
    if not killers then return nil end
    local stalker = killers:FindFirstChild("Stalker")
    if not stalker then return nil end
    return stalker:FindFirstChild("StartStalking")
end

local function startAutoStalk()
    if StalkConn then StalkConn:Disconnect() end

    StalkConn = RunService.Heartbeat:Connect(function()
        if not Config.Stalk.Enabled then return end

        local target = getClosestSurvivorForStalk()
        if not target then return end

        local event = getStalkRemote()
        if event then
            pcall(function() event:FireServer(target) end)
        end
    end)
end

local function stopAutoStalk()
    if StalkConn then
        StalkConn:Disconnect()
        StalkConn = nil
    end
end

-- ═══════════════════════════════════════════════════════════
--   UI — AUTO SKILL CHECK
-- ═══════════════════════════════════════════════════════════
SkillBox:AddToggle("AutoSkillCheck", {
    Text = "Auto Skill Check",
    Default = false,
    Tooltip = "Otomatis hit skill check generator",
    Callback = function(v)
        Config.AutoSkillCheck.Enabled = v
        if v then startSkillCheck() end
    end,
})

SkillBox:AddLabel("ℹ️ Support PC (Space) & Mobile (tap)")
SkillBox:AddLabel("ℹ️ Auto detect SkillCheckPromptGui")

-- ═══════════════════════════════════════════════════════════
--   UI — AUTO WIGGLE
-- ═══════════════════════════════════════════════════════════
WiggleBox:AddToggle("AutoWiggle", {
    Text = "Auto Wiggle",
    Default = false,
    Tooltip = "Spam self-unhook kalau digendong killer",
    Callback = function(v)
        Config.AutoWiggle.Enabled = v
        if v then startAutoWiggle() end
    end,
})

WiggleBox:AddSlider("WiggleSpam", {
    Text = "Spam Intensity",
    Default = 5,
    Min = 1,
    Max = 30,
    Rounding = 0,
    Tooltip = "Jumlah spam per heartbeat",
    Callback = function(v) Config.AutoWiggle.Spam = v end,
})

-- ═══════════════════════════════════════════════════════════
--   UI — AUTO FLEE KILLER
-- ═══════════════════════════════════════════════════════════
FleeBox:AddToggle("AutoFlee", {
    Text = "Auto Flee Killer",
    Default = false,
    Tooltip = "Auto TP ke generator terjauh kalau killer deket",
    Callback = function(v) Config.AutoFlee.Enabled = v end,
})

FleeBox:AddSlider("FleeDistance", {
    Text = "Detect Distance",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(v) Config.AutoFlee.Distance = v end,
})

FleeBox:AddSlider("FleeCooldown", {
    Text = "Cooldown",
    Default = 0.1,
    Min = 0.05,
    Max = 2,
    Rounding = 2,
    Suffix = " s",
    Callback = function(v) Config.AutoFlee.Cooldown = v end,
})

FleeBox:AddLabel("ℹ️ Butuh GeneratorPoint di workspace")

-- ═══════════════════════════════════════════════════════════
--   UI — AUTO STALK
-- ═══════════════════════════════════════════════════════════
StalkBox:AddToggle("AutoStalk", {
    Text = "Auto Stalk",
    Default = false,
    Tooltip = "Auto stalk survivor terdekat (buat killer Myers-like)",
    Callback = function(v)
        Config.Stalk.Enabled = v
        if v then startAutoStalk() else stopAutoStalk() end
    end,
})

StalkBox:AddSlider("StalkRange", {
    Text = "Stalk Range",
    Default = 150,
    Min = 20,
    Max = 500,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(v) Config.Stalk.Range = v end,
})

StalkBox:AddLabel("ℹ️ Cuma work buat killer Stalker-type")

-- ═══════════════════════════════════════════════════════════
--   END OF BAGIAN 5
-- ═══════════════════════════════════════════════════════════-- ═══════════════════════════════════════════════════════════
--   TIARHUB x VIOLENCE DISTRICT
--   Bagian 6 : Tab Player
-- ═══════════════════════════════════════════════════════════

local Config = _G.TiarConfig
local Theme  = {
    NEON_BLUE  = Color3.fromRGB(30, 150, 255),
    WHITE_BLUE = Color3.fromRGB(220, 235, 255),
}

local function notify(t, d, du)
    Library:Notify({ Title = t, Description = d or "", Time = du or 3, Icon = 0 })
end

-- ═══════════════════════════════════════════════════════════
--   GROUPBOXES
-- ═══════════════════════════════════════════════════════════
local MaskedBox = Tabs.Player:AddLeftGroupbox("Masked Power", "sparkles")
local KillerBox = Tabs.Player:AddLeftGroupbox("Killer Abilities", "skull")
local EmoteBox  = Tabs.Player:AddRightGroupbox("Emote", "music")
local AvatarBox = Tabs.Player:AddRightGroupbox("Avatar Stealer", "user")
local FunBox    = Tabs.Player:AddRightGroupbox("Fun / Troll", "smile")

-- ═══════════════════════════════════════════════════════════
--   HELPER
-- ═══════════════════════════════════════════════════════════
local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- ═══════════════════════════════════════════════════════════
--   MASKED POWER
-- ═══════════════════════════════════════════════════════════
local MaskedPowers = { "Cobra", "Richter", "Brandon", "Rabbit", "Alex" }
local MaskedState = { Current = "Cobra" }

local function getMaskedRemote(name)
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return nil end
    local killers = remotes:FindFirstChild("Killers")
    if not killers then return nil end
    local masked = killers:FindFirstChild("Masked")
    if not masked then return nil end
    return masked:FindFirstChild(name)
end

local function activatePower()
    local event = getMaskedRemote("Activatepower")
    if event then
        pcall(function() event:FireServer(MaskedState.Current) end)
        notify("Masked", "Activated: " .. MaskedState.Current, 2)
    else
        notify("Masked", "Remote gak ketemu", 2)
    end
end

local function deactivatePower()
    local event = getMaskedRemote("Deactivatepower")
    if event then
        pcall(function() event:FireServer() end)
        notify("Masked", "Deactivated", 2)
    else
        notify("Masked", "Remote gak ketemu", 2)
    end
end

-- ═══════════════════════════════════════════════════════════
--   KILLER ABILITIES (Auto Kill / Attack / Carry)
-- ═══════════════════════════════════════════════════════════
local KillerState = {
    KillAll      = false,
    AutoAttack   = false,
    AutoCarry    = false,
    AttackDelay  = 0.45,
    KillRange    = 500,
}

local KillerBusy   = false
local KillerTarget = nil
local LastAttack   = 0

-- Remote refs
local function getAttackEvent()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return nil end
    local attacks = remotes:FindFirstChild("Attacks")
    if not attacks then return nil end
    return attacks:FindFirstChild("BasicAttack")
end

local function getCarryEvent()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return nil end
    local carry = remotes:FindFirstChild("Carry")
    if not carry then return nil end
    return carry:FindFirstChild("CarrySurvivorEvent")
end

local function getHookEvent()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return nil end
    local carry = remotes:FindFirstChild("Carry")
    if not carry then return nil end
    return carry:FindFirstChild("HookEvent")
end

local function getNearestAliveSurvivor()
    local root = getRoot()
    if not root then return nil end

    local closest, shortest = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < shortest and d <= KillerState.KillRange then
                    shortest = d
                    closest = p.Character
                end
            end
        end
    end
    return closest
end

local function getDownedSurvivor()
    local root = getRoot()
    if not root then return nil end

    local best, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 and hum.Health <= hum.MaxHealth * 0.25 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < dist then
                    dist = d
                    best = p.Character
                end
            end
        end
    end
    return best
end

local function getHookPoint()
    local root = getRoot()
    if not root then return nil end

    local best, shortest = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "HookPoint" then
            local d = (obj.Position - root.Position).Magnitude
            if d < shortest and d < 400 then
                shortest = d
                best = obj
            end
        end
    end
    return best
end

-- ─── KILLER LOOP ───────────────────────────────────────────
task.spawn(function()
    while task.wait(0.05) do

        -- AUTO ATTACK
        if KillerState.AutoAttack then
            local now = tick()
            if now - LastAttack >= KillerState.AttackDelay then
                LastAttack = now
                local attack = getAttackEvent()
                if attack then
                    pcall(function() attack:FireServer(false) end)
                end
            end
        end

        -- AUTO CARRY + HOOK
        if KillerState.AutoCarry and not KillerBusy then
            KillerBusy = true

            task.spawn(function()
                local target = getDownedSurvivor()
                local root = getRoot()

                if target and root then
                    local tRoot = target:FindFirstChild("HumanoidRootPart")
                    if tRoot then
                        root.CFrame = tRoot.CFrame * CFrame.new(0, 3, -2)
                        task.wait(0.4)

                        local carry = getCarryEvent()
                        if carry then
                            for i = 1, 4 do
                                pcall(function() carry:FireServer(target) end)
                                task.wait(0.2)
                            end
                        end
                        task.wait(0.6)

                        local hook = getHookPoint()
                        if hook then
                            root.CFrame = hook.CFrame * CFrame.new(0, 4, -3)
                            task.wait(0.7)

                            local hookEvent = getHookEvent()
                            if hookEvent then
                                for i = 1, 6 do
                                    pcall(function() hookEvent:FireServer(hook) end)
                                    task.wait(0.15)
                                end
                            end
                        end
                    end
                end

                task.delay(2, function() KillerBusy = false end)
            end)
        end

        -- AUTO KILL ALL
        if KillerState.KillAll then
            local root = getRoot()
            if root then
                if not KillerTarget
                or not KillerTarget:FindFirstChild("Humanoid")
                or KillerTarget.Humanoid.Health <= 35 then
                    KillerTarget = getNearestAliveSurvivor()
                end

                if KillerTarget then
                    local tHRP = KillerTarget:FindFirstChild("HumanoidRootPart")
                    if tHRP then
                        local velocity = tHRP.AssemblyLinearVelocity
                        local predict = velocity * 0.15
                        local targetPos = tHRP.Position + predict
                        local behind = tHRP.CFrame.LookVector * -3
                        root.CFrame = CFrame.new(targetPos + behind, targetPos)
                    end

                    local attack = getAttackEvent()
                    if attack then
                        pcall(function() attack:FireServer(false) end)
                    end
                end
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
--   EMOTE
-- ═══════════════════════════════════════════════════════════
local EmoteList = {
    "Mannrobics", "Arm Swing", "Schadenfreude", "Kyoufuu",
    "Backflip", "Griddy", "Friday Night", "Floating Rest",
    "OnePlays", "Quick Combo", "WarCry", "Wave"
}

local EmoteSelected = "Mannrobics"
local EmoteBtnGui = nil
local EmoteLabelRef = nil

local function getEmoteRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return nil end
    return remotes:FindFirstChild("EmoteHandler")
end

local function playEmote(name)
    local event = getEmoteRemote()
    if event then
        pcall(function() event:FireServer(name) end)
    end
end

local function createEmoteButton()
    if EmoteBtnGui then EmoteBtnGui:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "TiarEmoteButton"
    gui.ResetOnSpawn = false
    gui.Parent = PlayerGui

    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0.55, 0, 0.75, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.9
    btn.Image = "rbxassetid://93349170559446"
    btn.ImageTransparency = 0.1
    btn.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 80, 0, 20)
    label.Position = UDim2.new(0.5, -40, -0.6, 0)
    label.BackgroundTransparency = 1
    label.Text = EmoteSelected
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.Parent = btn

    btn.MouseButton1Click:Connect(function()
        playEmote(EmoteSelected)
        stroke.Color = Color3.fromRGB(90, 120, 210)
        task.delay(0.3, function()
            stroke.Color = Color3.fromRGB(255, 255, 255)
        end)
    end)

    EmoteBtnGui = gui
    EmoteLabelRef = label
end

local function removeEmoteButton()
    if EmoteBtnGui then
        EmoteBtnGui:Destroy()
        EmoteBtnGui = nil
        EmoteLabelRef = nil
    end
end

-- ═══════════════════════════════════════════════════════════
--   AVATAR STEALER
-- ═══════════════════════════════════════════════════════════
local AvatarState = {
    TargetUsername = "",
    OriginalDescription = nil,
    StealedUserId = nil,
    BlockyBody = true,
}

local function saveOriginalAppearance()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        AvatarState.OriginalDescription = hum:GetAppliedDescription()
        notify("Avatar", "Original saved", 2)
    end
end

local function applyBlockyBody(character)
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local desc = Instance.new("HumanoidDescription")
    desc.BodyTypeScale     = 1
    desc.DepthScale        = 1
    desc.HeadScale         = 1
    desc.HeightScale       = 1
    desc.ProportionScale   = 0
    desc.WidthScale        = 1

    hum:ApplyDescriptionClientServer(desc)
end

local function removeAllClothing(character)
    for _, v in ipairs(character:GetDescendants()) do
        if v:IsA("Accessory")
        or v:IsA("Clothing")
        or v:IsA("Shirt")
        or v:IsA("Pants")
        or v:IsA("ShirtGraphic") then
            v:Destroy()
        end
    end
end

local function copyAvatar(username)
    if not username or username == "" then
        notify("Avatar", "Username kosong", 2)
        return
    end

    saveOriginalAppearance()

    local ok, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    if not ok then
        notify("Avatar", "User gak ketemu", 2)
        return
    end

    AvatarState.StealedUserId = userId

    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    task.spawn(function()
        local desc = Players:GetHumanoidDescriptionFromUserId(userId)

        if AvatarState.BlockyBody then
            applyBlockyBody(char)
            task.wait(0.3)
        end

        removeAllClothing(char)
        task.wait(0.2)

        hum:ApplyDescriptionClientServer(desc)
        notify("Avatar", "Copied: " .. username, 2)
    end)
end

local function resetAvatar()
    if not AvatarState.OriginalDescription then
        notify("Avatar", "Belum ada original saved", 2)
        return
    end

    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        removeAllClothing(char)
        hum:ApplyDescriptionClientServer(AvatarState.OriginalDescription)
        AvatarState.StealedUserId = nil
        notify("Avatar", "Reset ke original", 2)
    end
end

-- Auto restore pas respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    if AvatarState.StealedUserId then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local desc = Players:GetHumanoidDescriptionFromUserId(AvatarState.StealedUserId)
            if AvatarState.BlockyBody then applyBlockyBody(char) end
            removeAllClothing(char)
            hum:ApplyDescriptionClientServer(desc)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
--   JERK TOOL (fun)
-- ═══════════════════════════════════════════════════════════
local JerkState = { Enabled = false }
local CurrentJerkTool = nil

local function createJerkTool()
    if CurrentJerkTool then CurrentJerkTool:Destroy() end

    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not hum or not backpack then return end

    local tool = Instance.new("Tool")
    tool.Name = "Jerk Off"
    tool.ToolTip = "in the stripped club. straight up \"jorking it\""
    tool.RequiresHandle = false
    tool.Parent = backpack

    CurrentJerkTool = tool

    local jorkin = false
    local track = nil

    local function stopTomfoolery()
        jorkin = false
        if track then
            track:Stop()
            track = nil
        end
    end

    tool.Equipped:Connect(function() jorkin = true end)
    tool.Unequipped:Connect(stopTomfoolery)
    hum.Died:Connect(stopTomfoolery)

    task.spawn(function()
        while task.wait() do
            if not JerkState.Enabled or not jorkin then
                if track then track:Stop() end
                continue
            end

            local isR15 = hum.RigType == Enum.HumanoidRigType.R15
            if not track then
                local anim = Instance.new("Animation")
                anim.AnimationId = isR15
                    and "rbxassetid://698251653"
                    or  "rbxassetid://72042024"
                track = hum:LoadAnimation(anim)
            end

            track:Play()
            track:AdjustSpeed(isR15 and 0.7 or 0.65)
            track.TimePosition = 0.6
            task.wait(0.1)

            while track and track.TimePosition < (isR15 and 0.7 or 0.65) do
                task.wait(0.1)
            end
            if track then track:Stop() end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if JerkState.Enabled then createJerkTool() end
end)

-- ═══════════════════════════════════════════════════════════
--   UI — MASKED POWER
-- ═══════════════════════════════════════════════════════════
MaskedBox:AddDropdown("MaskedPowerSelect", {
    Text = "Select Power",
    Values = MaskedPowers,
    Default = "Cobra",
    Multi = false,
    Callback = function(v) MaskedState.Current = v end,
})

MaskedBox:AddButton({
    Text = "⚡ Activate Power",
    Func = activatePower,
})

MaskedBox:AddButton({
    Text = "🛑 Deactivate Power",
    Func = deactivatePower,
})

-- ═══════════════════════════════════════════════════════════
--   UI — KILLER ABILITIES
-- ═══════════════════════════════════════════════════════════
KillerBox:AddToggle("AutoKillAll", {
    Text = "Auto Kill All",
    Default = false,
    Tooltip = "TP ke survivor + spam attack",
    Callback = function(v) KillerState.KillAll = v end,
})

KillerBox:AddToggle("AutoSpamAttack", {
    Text = "Auto Spam Attack",
    Default = false,
    Callback = function(v) KillerState.AutoAttack = v end,
})

KillerBox:AddSlider("AttackDelay", {
    Text = "Attack Delay",
    Default = 0.45,
    Min = 0.1,
    Max = 2,
    Rounding = 2,
    Suffix = " s",
    Callback = function(v) KillerState.AttackDelay = v end,
})

KillerBox:AddDivider()

KillerBox:AddToggle("AutoCarry", {
    Text = "Auto Carry + Hook",
    Default = false,
    Tooltip = "Auto gendong survivor downed + hook",
    Callback = function(v) KillerState.AutoCarry = v end,
})

KillerBox:AddSlider("KillRange", {
    Text = "Kill Range",
    Default = 500,
    Min = 50,
    Max = 2000,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(v) KillerState.KillRange = v end,
})

-- ═══════════════════════════════════════════════════════════
--   UI — EMOTE
-- ═══════════════════════════════════════════════════════════
EmoteBox:AddDropdown("EmoteSelect", {
    Text = "Select Emote",
    Values = EmoteList,
    Default = "Mannrobics",
    Multi = false,
    Callback = function(v)
        EmoteSelected = v
        if EmoteLabelRef then EmoteLabelRef.Text = v end
    end,
})

EmoteBox:AddButton({
    Text = "▶️ Play Emote",
    Func = function() playEmote(EmoteSelected) end,
})

EmoteBox:AddToggle("ShowEmoteButton", {
    Text = "Show On-Screen Button",
    Default = false,
    Callback = function(v)
        if v then createEmoteButton() else removeEmoteButton() end
    end,
})

-- ═══════════════════════════════════════════════════════════
--   UI — AVATAR STEALER
-- ═══════════════════════════════════════════════════════════
AvatarBox:AddInput("AvatarUsername", {
    Text = "Target Username",
    Default = "",
    Placeholder = "Ketik username...",
    Finished = true,
    Callback = function(v) AvatarState.TargetUsername = v end,
})

AvatarBox:AddButton({
    Text = "📥 Copy Avatar",
    Func = function() copyAvatar(AvatarState.TargetUsername) end,
})

AvatarBox:AddButton({
    Text = "🔄 Reset to Original",
    Func = resetAvatar,
})

AvatarBox:AddButton({
    Text = "💾 Save Current as Original",
    Func = saveOriginalAppearance,
})

-- ═══════════════════════════════════════════════════════════
--   UI — FUN / TROLL
-- ═══════════════════════════════════════════════════════════
FunBox:AddToggle("JerkTool", {
    Text = "Jerk Tool",
    Default = false,
    Callback = function(v)
        JerkState.Enabled = v
        if v then
            createJerkTool()
        else
            if CurrentJerkTool then
                CurrentJerkTool:Destroy()
                CurrentJerkTool = nil
            end
        end
    end,
})

-- ═══════════════════════════════════════════════════════════
--   END OF BAGIAN 6
-- ═══════════════════════════════════════════════════════════-- ═══════════════════════════════════════════════════════════
--   TIARHUB x VIOLENCE DISTRICT
--   Bagian 7 : Tab Settings + Finalization
-- ═══════════════════════════════════════════════════════════

local Config = _G.TiarConfig
local Theme  = {
    NEON_BLUE   = Color3.fromRGB(30, 150, 255),
    WHITE_BLUE  = Color3.fromRGB(220, 235, 255),
    CYAN_ACCENT = Color3.fromRGB(0, 255, 255),
}

local function notify(t, d, du)
    Library:Notify({ Title = t, Description = d or "", Time = du or 3, Icon = 0 })
end

-- ═══════════════════════════════════════════════════════════
--   GROUPBOXES
-- ═══════════════════════════════════════════════════════════
local SettingBox = Tabs.Settings:AddLeftGroupbox("Menu Settings", "wrench")
local ConfigBox  = Tabs.Settings:AddRightGroupbox("Config & Theme", "settings")
local AboutBox   = Tabs.Settings:AddLeftGroupbox("About", "info")

-- ═══════════════════════════════════════════════════════════
--   SETTING: CUSTOM CURSOR
-- ═══════════════════════════════════════════════════════════
SettingBox:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(v)
        Library.ShowCustomCursor = v
    end,
})

-- ═══════════════════════════════════════════════════════════
--   SETTING: NOTIFICATION SIDE
-- ═══════════════════════════════════════════════════════════
SettingBox:AddDropdown("NotificationSide", {
    Text = "Notification Side",
    Values = { "Left", "Right" },
    Default = "Right",
    Multi = false,
    Callback = function(v)
        Library:SetNotifySide(v)
    end,
})

-- ═══════════════════════════════════════════════════════════
--   SETTING: DPI SCALE
-- ═══════════════════════════════════════════════════════════
SettingBox:AddDropdown("DPIDropdown", {
    Text = "DPI Scale",
    Values = { "50%", "75%", "85%", "100%", "125%", "150%" },
    Default = "100%",
    Multi = false,
    Callback = function(v)
        local num = tonumber(v:gsub("%%", ""))
        if num then
            Library:SetDPIScale(num)
        end
    end,
})

-- ═══════════════════════════════════════════════════════════
--   SETTING: CORNER RADIUS
-- ═══════════════════════════════════════════════════════════
SettingBox:AddSlider("UICornerSlider", {
    Text = "Corner Radius",
    Default = 20,
    Min = 0,
    Max = 30,
    Rounding = 0,
    Callback = function(v)
        Window:SetCornerRadius(v)
    end,
})

-- ═══════════════════════════════════════════════════════════
--   SETTING: WATERMARK
-- ═══════════════════════════════════════════════════════════
local Watermark = Library:AddDraggableLabel("TIARHUB")

SettingBox:AddToggle("WatermarkToggle", {
    Text = "Show Watermark",
    Default = true,
    Callback = function(v)
        Watermark.Visible = v
    end,
})

-- ═══════════════════════════════════════════════════════════
--   SETTING: WATERMARK UPDATE (FPS / PING)
-- ═══════════════════════════════════════════════════════════
local FPS, Frames, LastTick = 0, 0, tick()

RunService.RenderStepped:Connect(function()
    Frames += 1
    if tick() - LastTick >= 1 then
        FPS = Frames
        Frames = 0
        LastTick = tick()

        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        Watermark:SetText(string.format(
            "TIARHUB | FPS: %d | PING: %d ms",
            FPS, ping
        ))
    end
end)

-- ═══════════════════════════════════════════════════════════
--   THEME MANAGER
-- ═══════════════════════════════════════════════════════════
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("TiarHub")

-- Custom tema TIARHUB biru
ThemeManager:SaveCustomTheme({
    Name = "TiarHub Blue",
    AccentColor     = Theme.NEON_BLUE,
    BackgroundColor = Color3.fromRGB(10, 20, 40),
    MainColor       = Color3.fromRGB(20, 35, 65),
    OutlineColor    = Color3.fromRGB(0, 80, 180),
    FontColor       = Theme.WHITE_BLUE,
})

ThemeManager:ApplyToTab(Tabs.Settings)

-- ═══════════════════════════════════════════════════════════
--   SAVE MANAGER
-- ═══════════════════════════════════════════════════════════
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("TiarHub/configs")
SaveManager:BuildConfigSection(Tabs.Settings)

-- ═══════════════════════════════════════════════════════════
--   ABOUT BOX
-- ═══════════════════════════════════════════════════════════
AboutBox:AddLabel("TIARHUB x Violence District")
AboutBox:AddLabel("Version : 1.0.0")
AboutBox:AddLabel("Build   : Modular 7-part")
AboutBox:AddDivider()
AboutBox:AddButton({
    Text = "🔄 Reload Script",
    Func = function()
        Library:Unload()
        task.wait(0.5)
        -- Note: reload manual (gak bisa auto karena loadstring gak bisa self-reload)
        notify("Reload", "Ketik loadstring lagi", 3)
    end,
})

AboutBox:AddButton({
    Text = "❌ Unload Script",
    Func = function()
        Library:Unload()
    end,
})

-- ═══════════════════════════════════════════════════════════
--   KEYBIND INFO
-- ═══════════════════════════════════════════════════════════
AboutBox:AddDivider()
AboutBox:AddLabel("⌨️ RightShift = Toggle GUI")
AboutBox:AddLabel("⌨️ RightControl = Toggle (alt)")
AboutBox:AddLabel("⌨️ Q = Auto Parry Toggle")
AboutBox:AddLabel("⌨️ V = Moonwalk Toggle")
AboutBox:AddLabel("🖱️ Right Click (hold) = Aimlock")

-- ═══════════════════════════════════════════════════════════
--   EXTRA KEYBIND (RightControl)
-- ═══════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Library:Toggle()
    end
end)

-- ═══════════════════════════════════════════════════════════
--   APPLY SEMUA SETTING SAAT START
-- ═══════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(0.5)

    -- Watermark start
    Watermark:SetText("TIARHUB | Loading...")
    Watermark.Visible = true

    -- Notif welcome
    notify("TIARHUB", "Loaded ✓ | 7 parts", 4)
    task.wait(1.5)
    notify("Tip", "RightShift buat toggle menu", 4)
end)

-- ═══════════════════════════════════════════════════════════
--   CLEANUP SAAT PLAYER LEAVE
-- ═══════════════════════════════════════════════════════════
game:BindToClose(function()
    -- Cleanup
    if _G.TiarCleanup then
        pcall(_G.TiarCleanup)
    end
end)

-- ═══════════════════════════════════════════════════════════
--   END OF BAGIAN 7 — SCRIPT COMPLETE
-- ═══════════════════════════════════════════════════════════
print("╔══════════════════════════════════════════╗")
print("║   TIARHUB x VIOLENCE DISTRICT           ║")
print("║   ✅ All 7 parts loaded                 ║")
print("║   RightShift = Toggle Menu              ║")
print("╚══════════════════════════════════════════╝")
