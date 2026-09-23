-- ═══════════════════════════════════════════════════════════
--   TIARHUB x VIOLENCE DISTRICT — V3 (Better Debug)
--   Bagian 1 : Setup, Library, Splash, Window, Tabs
-- ═══════════════════════════════════════════════════════════

print("═══ [TIARHUB] SCRIPT START ═══")

-- ═══════════════════════════════════════════════════════════
--   STEP 1: SERVICES
-- ═══════════════════════════════════════════════════════════
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local VirtualInputManager= game:GetService("VirtualInputManager")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local Lighting           = game:GetService("Lighting")
local TweenService       = game:GetService("TweenService")
local Stats              = game:GetService("Stats")

local LocalPlayer        = Players.LocalPlayer
local PlayerGui          = LocalPlayer:WaitForChild("PlayerGui")
local Camera             = workspace.CurrentCamera

print("[TIARHUB] ✅ Step 1: Services OK")

-- ═══════════════════════════════════════════════════════════
--   STEP 2: LIBRARY OBSIDIAN
-- ═══════════════════════════════════════════════════════════
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

print("[TIARHUB] Downloading Library...")
local okLib, Library = pcall(function()
    return loadstring(game:HttpGet(repo .. "Library.lua"))()
end)

if not okLib or not Library then
    warn("[TIARHUB] ❌ Library FAILED:", Library)
    return
end

print("[TIARHUB] ✅ Step 2: Library OK")

local okTM, ThemeManager = pcall(function()
    return loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
end)

local okSM, SaveManager = pcall(function()
    return loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
end)

print("[TIARHUB] ThemeManager:", okTM, "| SaveManager:", okSM)

Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true

-- ═══════════════════════════════════════════════════════════
--   STEP 3: WARNA TEMA
-- ═══════════════════════════════════════════════════════════
local Theme = {
    NEON_BLUE  = Color3.fromRGB(30, 150, 255),
    WHITE_BLUE = Color3.fromRGB(220, 235, 255),
    CYAN       = Color3.fromRGB(0, 255, 255),
    BLACK_BLUE = Color3.fromRGB(10, 20, 40),
}

pcall(function()
    Library.Scheme.AccentColor     = Theme.NEON_BLUE
    Library.Scheme.BackgroundColor = Theme.BLACK_BLUE
    Library.Scheme.MainColor       = Color3.fromRGB(20, 35, 65)
    Library.Scheme.OutlineColor    = Color3.fromRGB(0, 80, 180)
    Library.Scheme.FontColor       = Theme.WHITE_BLUE
end)

print("[TIARHUB] ✅ Step 3: Theme OK")

-- ═══════════════════════════════════════════════════════════
--   STEP 4: SPLASH SCREEN
-- ═══════════════════════════════════════════════════════════
print("[TIARHUB] Showing splash...")

local function ShowSplash()
    local splash = Instance.new("ScreenGui")
    splash.Name = "TiarHubSplash"
    splash.IgnoreGuiInset = true
    splash.DisplayOrder = 999
    splash.Parent = PlayerGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Theme.BLACK_BLUE
    bg.BorderSizePixel = 0
    bg.Parent = splash

    local title = Instance.new("TextLabel")
    title.Text = "TIARHUB"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 60
    title.TextColor3 = Theme.CYAN
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 80)
    title.Position = UDim2.new(0, 0, 0.42, 0)
    title.TextStrokeTransparency = 0.2
    title.TextStrokeColor3 = Theme.NEON_BLUE
    title.Parent = bg

    local sub = Instance.new("TextLabel")
    sub.Text = "VIOLENCE DISTRICT v3.0"
    sub.Font = Enum.Font.GothamBold
    sub.TextSize = 14
    sub.TextColor3 = Theme.WHITE_BLUE
    sub.BackgroundTransparency = 1
    sub.Size = UDim2.new(1, 0, 0, 25)
    sub.Position = UDim2.new(0, 0, 0.52, 0)
    sub.Parent = bg

    local loading = Instance.new("TextLabel")
    loading.Text = "Loading..."
    loading.Font = Enum.Font.GothamBold
    loading.TextSize = 13
    loading.TextColor3 = Color3.fromRGB(150, 200, 255)
    loading.BackgroundTransparency = 1
    loading.Size = UDim2.new(1, 0, 0, 20)
    loading.Position = UDim2.new(0, 0, 0.58, 0)
    loading.Parent = bg

    task.wait(1.5)

    for i = 0, 1, 0.1 do
        bg.BackgroundTransparency = i
        title.TextTransparency = i
        title.TextStrokeTransparency = i
        sub.TextTransparency = i
        loading.TextTransparency = i
        task.wait(0.03)
    end

    splash:Destroy()
end

local okSplash = pcall(ShowSplash)
print("[TIARHUB] ✅ Step 4: Splash done (" .. tostring(okSplash) .. ")")

-- ═══════════════════════════════════════════════════════════
--   STEP 5: WINDOW
-- ═══════════════════════════════════════════════════════════
print("[TIARHUB] Creating Window...")

local okWin, Window = pcall(function()
    return Library:CreateWindow({
        Title = "TIARHUB",
        Footer = "v3.0 | Violence District",
        Icon = 0,
        NotifySide = "Right",
        ShowCustomCursor = true,
        Size = UDim2.fromOffset(520, 400),
    })
end)

if not okWin or not Window then
    warn("[TIARHUB] ❌ Window FAILED:", Window)
    return
end

print("[TIARHUB] ✅ Step 5: Window OK")

task.wait(0.2)

if Window.UI then
    pcall(function()
        Window.UI.Position = UDim2.new(0.5, 0, 0.05, 0)
        Window.UI.AnchorPoint = Vector2.new(0.5, 0)
    end)
end

-- ═══════════════════════════════════════════════════════════
--   STEP 6: CONFIG (LOCAL, gak pakai _G)
-- ═══════════════════════════════════════════════════════════
local Config = {
    ESP = {
        Killer = false, Survivor = false,
        Generator = false, Pallet = false,
        Window = false, SCP = false,
        Distance = 300,
        KillerColor   = Color3.fromRGB(255, 60, 60),
        SurvivorColor = Color3.fromRGB(60, 255, 120),
        GenColor      = Color3.fromRGB(255, 170, 0),
        PalletColor   = Color3.fromRGB(74, 255, 181),
        WindowColor   = Color3.fromRGB(74, 255, 181),
        SCPColor      = Color3.fromRGB(255, 0, 0),
    },
    ESPStatus = {
        Enabled = false, ShowName = true,
        ShowDistance = true, ShowHealth = false,
        Radius = 200,
    },
    ESPCircle = {
        Enabled = false, Size = 6, Thickness = 0.1,
        Color = Color3.fromRGB(0, 255, 255),
        Transparency = 0.5,
    },
    AutoParry = {
        Enabled = false, Distance = 15, Cooldown = 0.2,
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
        Enabled = false, Contrast = 1.0,
        Saturation = 1.0, Brightness = 0.0,
        Tint = Color3.fromRGB(255,255,255),
    },
    Fullbright = { Enabled = false },
    FOV = { Enabled = false, Value = 70 },
    Zoom = { Enabled = false, Max = 1000 },
    Stalk = { Enabled = false, Range = 150 },
}

print("[TIARHUB] ✅ Step 6: Config OK")

-- ═══════════════════════════════════════════════════════════
--   STEP 7: KILLER ANIMS (23 ID)
-- ═══════════════════════════════════════════════════════════
local KillerAnims = {
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

print("[TIARHUB] ✅ Step 7: KillerAnims OK (23 ids)")

-- ═══════════════════════════════════════════════════════════
--   STEP 8: REMOTES
-- ═══════════════════════════════════════════════════════════
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
if not Remotes then
    Remotes = ReplicatedStorage:WaitForChild("Remotes", 15)
end

print("[TIARHUB] ✅ Step 8: Remotes =", Remotes ~= nil)

-- ═══════════════════════════════════════════════════════════
--   STEP 9: HELPER FUNCTIONS
-- ═══════════════════════════════════════════════════════════
local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function notify(title, desc, dur)
    pcall(function()
        Library:Notify({
            Title = title,
            Description = desc or "",
            Time = dur or 3,
            Icon = 0,
        })
    end)
end

print("[TIARHUB] ✅ Step 9: Helpers OK")

-- ═══════════════════════════════════════════════════════════
--   STEP 10: TABS
-- ═══════════════════════════════════════════════════════════
print("[TIARHUB] Creating Tabs...")

local Tabs = {
    Info     = Window:AddTab("Info",     "info"),
    Combat   = Window:AddTab("Combat",   "sword"),
    Visuals  = Window:AddTab("Visuals",  "eye"),
    Movement = Window:AddTab("Movement", "activity"),
    Auto     = Window:AddTab("Auto",     "zap"),
    Player   = Window:AddTab("Player",   "user"),
    Settings = Window:AddTab("Settings", "settings"),
}

print("[TIARHUB] ✅ Step 10: 7 Tabs created")

-- ═══════════════════════════════════════════════════════════
--   STEP 11: TEST GROUPBOX (buat mastiin tab gak kosong)
-- ═══════════════════════════════════════════════════════════
print("[TIARHUB] Creating test groupbox...")

local TestBox = Tabs.Info:AddLeftGroupbox("Script Info", "info")

TestBox:AddLabel("TIARHUB x Violence District")
TestBox:AddLabel("Version: 3.0")
TestBox:AddLabel("Status: Loading...")
TestBox:AddDivider()
TestBox:AddLabel("Kalau lu liat ini, tab work ✅")

print("[TIARHUB] ✅ Step 11: Test groupbox OK")

-- ═══════════════════════════════════════════════════════════
--   STEP 12: STATS PANEL
-- ═══════════════════════════════════════════════════════════
local statsGui = Instance.new("ScreenGui")
statsGui.Name = "TiarHubStats"
statsGui.ResetOnSpawn = false
statsGui.Parent = PlayerGui

local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(0, 150, 0, 90)
statsFrame.Position = UDim2.new(1, -165, 0, 20)
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
sTitle.Text = "STATS"
sTitle.Font = Enum.Font.GothamBlack
sTitle.TextSize = 12
sTitle.TextColor3 = Theme.CYAN
sTitle.BackgroundTransparency = 1
sTitle.Size = UDim2.new(1, 0, 0, 18)
sTitle.Position = UDim2.new(0, 0, 0, 4)
sTitle.Parent = statsFrame

local sText = Instance.new("TextLabel")
sText.Font = Enum.Font.GothamBold
sText.TextSize = 12
sText.TextColor3 = Theme.WHITE_BLUE
sText.BackgroundTransparency = 1
sText.Size = UDim2.new(1, -12, 1, -25)
sText.Position = UDim2.new(0, 8, 0, 24)
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
            local okPing, ping = pcall(function()
                return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            if not okPing then ping = 0 end
            local count = #Players:GetPlayers()
            sText.Text = string.format("FPS: %d\nPING: %d ms\nPLAYERS: %d", fps, ping, count)
        end
    end)
end)

print("[TIARHUB] ✅ Step 12: Stats panel OK")

-- ═══════════════════════════════════════════════════════════
--   STEP 13: KEYBIND TOGGLE
-- ═══════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Library:Toggle()
    end
end)

print("[TIARHUB] ✅ Step 13: Keybind OK")

-- ═══════════════════════════════════════════════════════════
--   DONE
-- ═══════════════════════════════════════════════════════════
notify("TIARHUB v3.0", "Bagian 1 selesai ✓", 3)

print("╔══════════════════════════════════════════════╗")
print("║   TIARHUB v3.0 — BAGIAN 1 LOADED             ║")
print("║   ✅ Step 1-13 selesai                       ║")
print("║   Kalau tab kosong → error di Bagian 2-7     ║")
print("╚══════════════════════════════════════════════╝")

print("═══ [TIARHUB] BAGIAN 1 END ═══")-- ═══════════════════════════════════════════════════════════
--   TIARHUB x VIOLENCE DISTRICT — ALL-IN-ONE
--   NO _G — Semua Local
-- ═══════════════════════════════════════════════════════════

print("[TIARHUB] Starting...")

-- ═══ SERVICES ═══
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local VirtualInputManager= game:GetService("VirtualInputManager")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local Lighting           = game:GetService("Lighting")
local Stats              = game:GetService("Stats")
local LocalPlayer        = Players.LocalPlayer
local PlayerGui          = LocalPlayer:WaitForChild("PlayerGui")
local Camera             = workspace.CurrentCamera

print("[TIARHUB] Services OK")

-- ═══ LIBRARY ═══
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

print("[TIARHUB] Library OK")

Library.Scheme.AccentColor     = Color3.fromRGB(30, 150, 255)
Library.Scheme.BackgroundColor = Color3.fromRGB(10, 20, 40)
Library.Scheme.MainColor       = Color3.fromRGB(20, 35, 65)
Library.Scheme.OutlineColor    = Color3.fromRGB(0, 80, 180)
Library.Scheme.FontColor       = Color3.fromRGB(220, 235, 255)
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true

-- ═══ WINDOW ═══
local Window = Library:CreateWindow({
    Title = "TIARHUB",
    Footer = "Violence District",
    Icon = 0,
    NotifySide = "Right",
    ShowCustomCursor = true,
    Size = UDim2.fromOffset(520, 400),
})

task.wait(0.1)
if Window.UI then
    Window.UI.Position = UDim2.new(0.5, 0, 0.05, 0)
    Window.UI.AnchorPoint = Vector2.new(0.5, 0)
end

print("[TIARHUB] Window OK")

-- ═══ CONFIG ═══
local Config = {
    ESP = {
        Killer=false, Survivor=false, Generator=false, Pallet=false, Window=false, SCP=false,
        Distance=300,
        KillerColor=Color3.fromRGB(255,60,60),
        SurvivorColor=Color3.fromRGB(60,255,120),
        GenColor=Color3.fromRGB(255,170,0),
        PalletColor=Color3.fromRGB(74,255,181),
        WindowColor=Color3.fromRGB(74,255,181),
        SCPColor=Color3.fromRGB(255,0,0),
        NameSize=14,
        ESPMode="Highlight",
    },
    ESPStatus = { Enabled=false, ShowName=true, ShowDistance=true, ShowHealth=false, Radius=200 },
    ESPCircle = { Enabled=false, Size=6, Thickness=0.1, Color=Color3.fromRGB(0,255,255), Transparency=0.5 },
    AutoParry = { Enabled=false, Distance=15, Mode="Instant" },
    AutoSkillCheck = { Enabled=false },
    AutoWiggle = { Enabled=false, Spam=5 },
    AutoFlee = { Enabled=false, Distance=50, Cooldown=0.1 },
    Aimlock = { Enabled=false, Target="Survivor", AimPart="HumanoidRootPart", FOV=250, Predict=0.12, LockMode="Camera" },
    WalkSpeed = { Enabled=false, Value=17.6 },
    JumpPower = { Enabled=false, Value=50 },
    NoClip = { Enabled=false },
    Moonwalk = { Enabled=false, Spam=30, Intensity=35, Slow=13 },
    FastVault = { Enabled=false, Speed=1.2 },
    Crosshair = { Enabled=false, Style="Plus", Size=8, Thickness=2, Color=Color3.fromRGB(255,255,255), OffsetX=0, OffsetY=0 },
    VisualContrast = { Enabled=false, Contrast=1.0, Saturation=1.0, Brightness=0.0, Tint=Color3.fromRGB(255,255,255) },
    Fullbright = { Enabled=false },
    FOV = { Enabled=false, Value=70 },
    Zoom = { Enabled=false, Max=1000 },
    Stalk = { Enabled=false, Range=150 },
    Killer = { KillAll=false, AutoAttack=false, AutoCarry=false, AttackDelay=0.45, KillRange=500, BlockVaults=false, AntiBlind=false, BreakSpeed=0 },
    Masked = { Power="Cobra" },
    Avatar = { Username="", Original=nil, UserId=nil, Blocky=true },
    Jerk = { Enabled=false },
    GodMode = { Enabled=false },
    InfiniteLunge = { Enabled=false },
    NoStun = { Enabled=false },
    InstantHeal = { Enabled=false },
    FlowState = { Enabled=false },
}

print("[TIARHUB] Config OK")

-- ═══ KILLER ANIMS (23 ID) ═══
local KillerAnims = {
    ["rbxassetid://105374834496520"]=true, ["rbxassetid://113255068724446"]=true,
    ["rbxassetid://118907603246885"]=true, ["rbxassetid://129784271201071"]=true,
    ["rbxassetid://117042998468241"]=true, ["rbxassetid://122812055447896"]=true,
    ["rbxassetid://78935059863801"]=true,  ["rbxassetid://74968262036854"]=true,
    ["rbxassetid://78432063483146"]=true,  ["rbxassetid://132817836308238"]=true,
    ["rbxassetid://133963973694098"]=true, ["rbxassetid://111920872708571"]=true,
    ["rbxassetid://80411309607666"]=true,  ["rbxassetid://98163597193511"]=true,
    ["rbxassetid://82666958311998"]=true,  ["rbxassetid://110355011987939"]=true,
    ["rbxassetid://139369275981139"]=true, ["rbxassetid://135002183282873"]=true,
    ["rbxassetid://121216847022485"]=true, ["rbxassetid://130593238885843"]=true,
    ["rbxassetid://117070354890871"]=true, ["rbxassetid://106871536134254"]=true,
    ["rbxassetid://138720291317243"]=true,
}

-- Anim ID Parry (dari script lu)
local ParryAnimId = "rbxassetid://127096285501517"

print("[TIARHUB] KillerAnims OK (23 ids)")

-- ═══ REMOTES ═══
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 15)
print("[TIARHUB] Remotes:", Remotes ~= nil)

-- ═══ HELPER ═══
local function getRoot() local c=LocalPlayer.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c=LocalPlayer.Character; return c and c:FindFirstChildOfClass("Humanoid") end
local function notify(t,d,du) pcall(function() Library:Notify({Title=t,Description=d or "",Time=du or 3,Icon=0}) end) end

print("[TIARHUB] Helpers OK")

-- ═══ SPLASH ═══
local function ShowSplash()
    local splash = Instance.new("ScreenGui")
    splash.IgnoreGuiInset = true
    splash.DisplayOrder = 999
    splash.Parent = PlayerGui
    local bg = Instance.new("Frame", splash)
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.fromRGB(10,20,40)
    bg.BorderSizePixel = 0
    local t1 = Instance.new("TextLabel", bg)
    t1.Text = "TIARHUB"
    t1.Font = Enum.Font.GothamBlack
    t1.TextSize = 60
    t1.TextColor3 = Color3.fromRGB(0,255,255)
    t1.BackgroundTransparency = 1
    t1.Size = UDim2.new(1,0,0,80)
    t1.Position = UDim2.new(0,0,0.42,0)
    t1.TextStrokeTransparency = 0.2
    t1.TextStrokeColor3 = Color3.fromRGB(30,150,255)
    local sub = Instance.new("TextLabel", bg)
    sub.Text = "VIOLENCE DISTRICT"
    sub.Font = Enum.Font.GothamBold
    sub.TextSize = 14
    sub.TextColor3 = Color3.fromRGB(220,235,255)
    sub.BackgroundTransparency = 1
    sub.Size = UDim2.new(1,0,0,20)
    sub.Position = UDim2.new(0,0,0.52,0)
    task.wait(1.2)
    splash:Destroy()
end

pcall(ShowSplash)
print("[TIARHUB] Splash done")

-- ═══ TABS ═══
local Tabs = {
    Info     = Window:AddTab("Info",     "info"),
    Combat   = Window:AddTab("Combat",   "sword"),
    Visuals  = Window:AddTab("Visuals",  "eye"),
    Movement = Window:AddTab("Movement", "activity"),
    Auto     = Window:AddTab("Auto",     "zap"),
    Player   = Window:AddTab("Player",   "user"),
    Settings = Window:AddTab("Settings", "settings"),
}

print("[TIARHUB] 7 Tabs OK")
print("═══ BAGIAN A DONE — LANJUT BAGIAN B ═══")-- ═══════════════════════════════════════════════════════════
--   BAGIAN B — INFO + COMBAT
-- ═══════════════════════════════════════════════════════════

print("[TIARHUB] Bagian B loading...")

-- ═══════════════════════════════════════════════════════════
--   TAB 1: INFO
-- ═══════════════════════════════════════════════════════════
local InfoBox    = Tabs.Info:AddLeftGroupbox("Script Info", "info")
local CreditsBox = Tabs.Info:AddRightGroupbox("Credits", "user")

InfoBox:AddLabel("TIARHUB x Violence District")
InfoBox:AddLabel("Version : All-in-One")
InfoBox:AddLabel("Status  : ✅ Loaded")
InfoBox:AddDivider()
InfoBox:AddButton({
    Text = "📋 Copy Discord",
    Func = function()
        setclipboard("https://discord.gg/tiarhub")
        notify("Copied!", "Discord disalin", 2)
    end,
})

CreditsBox:AddLabel("Developer : Tiar")
CreditsBox:AddDivider()
CreditsBox:AddLabel("Library   : Obsidian UI")
CreditsBox:AddLabel("Base      : Fallens Freemium")
CreditsBox:AddDivider()
CreditsBox:AddButton({
    Text = "💖 Support Dev",
    Func = function()
        setclipboard("https://sociabuzz.com/amill_al/tribe")
        notify("Thanks!", "Link disalin", 2)
    end,
})

print("[TIARHUB] Info tab OK")

-- ═══════════════════════════════════════════════════════════
--   TAB 2: COMBAT
-- ═══════════════════════════════════════════════════════════
local ParryBox     = Tabs.Combat:AddLeftGroupbox("Auto Parry 360°", "sword")
local AimBox       = Tabs.Combat:AddLeftGroupbox("Aimlock", "crosshair")
local CrosshairBox = Tabs.Combat:AddRightGroupbox("Crosshair", "crosshair")

-- ─── AUTO PARRY 360° ───
local lastParry      = 0
local ParryActive    = false
local ParryCircle    = nil
local hookedKillers  = {}

local function pressRightClick()
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
        task.wait(0.02)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
    end)
end

local function getParryButton()
    local cur = PlayerGui
    for seg in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        cur = cur and cur:FindFirstChild(seg)
    end
    return cur
end

local function pressParryButton()
    if UserInputService.TouchEnabled then
        local btn = getParryButton()
        if btn and btn:IsA("GuiObject") then
            local pos, size = btn.AbsolutePosition, btn.AbsoluteSize
            local inset = game:GetService("GuiService"):GetGuiInset()
            local x = pos.X + size.X/2 + inset.X
            local y = pos.Y + size.Y/2 + inset.Y
            pcall(function()
                VirtualInputManager:SendTouchEvent(8823, 0, x, y)
                task.wait(0.01)
                VirtualInputManager:SendTouchEvent(8823, 2, x, y)
            end)
        else
            pressRightClick()
        end
    else
        pressRightClick()
    end
end

local function doParry()
    local now = tick()
    if now - lastParry < 0.2 then return end
    lastParry = now
    ParryActive = true
    pressParryButton()
    task.delay(0.3, function() ParryActive = false end)
end

local function hookKiller(char)
    if not char or hookedKillers[char] then return end
    hookedKillers[char] = true

    local hum = char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    animator.AnimationPlayed:Connect(function(track)
        if not Config.AutoParry.Enabled or ParryActive then return end
        local anim = track.Animation
        if not anim or not anim.AnimationId then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end
        local fullId = "rbxassetid://" .. id

        if KillerAnims[fullId] then
            local myRoot = getRoot()
            local enemyRoot = char:FindFirstChild("HumanoidRootPart")
            if myRoot and enemyRoot then
                local dist = (myRoot.Position - enemyRoot.Position).Magnitude
                if dist <= Config.AutoParry.Distance then
                    doParry()  -- ✅ 360° tanpa cek arah
                end
            end
        end
    end)
end

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

local function updateParryCircle()
    local root = getRoot()
    if not Config.AutoParry.Enabled or not root then
        if ParryCircle then ParryCircle:Destroy(); ParryCircle = nil end
        return
    end
    if not ParryCircle then
        ParryCircle = Instance.new("Part")
        ParryCircle.Shape = Enum.PartType.Cylinder
        ParryCircle.Anchored = true
        ParryCircle.CanCollide = false
        ParryCircle.Material = Enum.Material.Neon
        ParryCircle.Name = "TiarParryCircle"
        ParryCircle.Parent = workspace
    end
    local size = Config.AutoParry.Distance * 2
    local yOff = root.Size.Y / 2 + 1.5
    ParryCircle.Size = Vector3.new(0.1, size, size)
    ParryCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOff, 0))
        * CFrame.Angles(0, 0, math.rad(90))
    ParryCircle.Color = Color3.fromRGB(30, 150, 255)
    ParryCircle.Transparency = 0.85
end

-- ─── AIMLOCK ───
local AimHolding = false
local RayParams = RaycastParams.new()
pcall(function() RayParams.FilterType = Enum.RaycastFilterType.Exclude end)

local function isVisible(part)
    RayParams.FilterDescendantsInstances = { LocalPlayer.Character }
    local result = workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, RayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

local function getClosestTarget()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local closest, shortest = nil, Config.Aimlock.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team then
            local valid = (Config.Aimlock.Target == "Killer" and p.Team.Name == "Killer")
                       or (Config.Aimlock.Target == "Survivor" and p.Team.Name == "Survivors")
            if valid then
                local hrp = p.Character:FindFirstChild(Config.Aimlock.AimPart)
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                    if vis then
                        local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if d < shortest and isVisible(hrp) then
                            shortest = d
                            closest = hrp
                        end
                    end
                end
            end
        end
    end
    return closest
end

UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.UserInputType == Enum.UserInputType.MouseButton2 then
        AimHolding = true
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then
        AimHolding = false
    end
end)

RunService.RenderStepped:Connect(function()
    if not Config.Aimlock.Enabled or not AimHolding then return end
    local target = getClosestTarget()
    if not target then return end
    local pos = target.Position
    if Config.Aimlock.Predict > 0 then
        pos = pos + target.AssemblyLinearVelocity * Config.Aimlock.Predict
    end
    if Config.Aimlock.LockMode == "Camera" then
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, pos), 0.35)
    end
end)

-- ─── CROSSHAIR ───
local CrosshairDrawings = {}
local CHCreated = false
local CHLastStyle = nil

local function clearCrosshair()
    for _, v in pairs(CrosshairDrawings) do
        if v and v.Remove then v:Remove() end
    end
    CrosshairDrawings = {}
    CHCreated = false
end

RunService.RenderStepped:Connect(function()
    local C = Config.Crosshair
    if not C.Enabled then
        for _, v in pairs(CrosshairDrawings) do if v then v.Visible = false end end
        return
    end
    if CHLastStyle ~= C.Style then
        clearCrosshair()
        CHLastStyle = C.Style
    end
    local center = Vector2.new(Camera.ViewportSize.X/2 + C.OffsetX, Camera.ViewportSize.Y/2 + C.OffsetY)

    if not CHCreated then
        CHCreated = true
        if C.Style == "Plus" then
            for i = 1, 4 do
                local l = Drawing.new("Line")
                l.Visible = true
                table.insert(CrosshairDrawings, l)
            end
        elseif C.Style == "Dot" then
            local d = Drawing.new("Circle")
            d.Filled = true
            d.Visible = true
            table.insert(CrosshairDrawings, d)
        elseif C.Style == "Circle" then
            local c = Drawing.new("Circle")
            c.Filled = false
            c.Visible = true
            table.insert(CrosshairDrawings, c)
        end
    end

    if C.Style == "Plus" then
        for _, l in pairs(CrosshairDrawings) do
            l.Color = C.Color
            l.Thickness = C.Thickness
            l.Visible = true
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
        CrosshairDrawings[1].Position = center
        CrosshairDrawings[1].Radius = C.Size / 2
        CrosshairDrawings[1].Color = C.Color
        CrosshairDrawings[1].Visible = true
    elseif C.Style == "Circle" then
        CrosshairDrawings[1].Position = center
        CrosshairDrawings[1].Radius = C.Size
        CrosshairDrawings[1].Color = C.Color
        CrosshairDrawings[1].Thickness = C.Thickness
        CrosshairDrawings[1].Visible = true
    end
end)

-- ─── UI CONTROLS ───
ParryBox:AddToggle("AutoParry", {
    Text = "Auto Parry (360°)",
    Default = false,
    Callback = function(v)
        Config.AutoParry.Enabled = v
        if v then notify("Parry", "ON - 360°", 2) end
    end,
})
ParryBox:AddSlider("ParryDistance", {
    Text = "Parry Distance",
    Default = 15, Min = 5, Max = 30, Rounding = 0,
    Suffix = " studs",
    Callback = function(v) Config.AutoParry.Distance = v end,
})
ParryBox:AddLabel("ℹ️ Trigger: 23 Killer Anim ID")

AimBox:AddToggle("AimlockEnabled", {
    Text = "Aimlock",
    Default = false,
    Callback = function(v) Config.Aimlock.Enabled = v end,
})
AimBox:AddDropdown("AimTarget", {
    Text = "Target", Values = {"Killer","Survivor"}, Default = "Survivor",
    Callback = function(v) Config.Aimlock.Target = v end,
})
AimBox:AddDropdown("AimPart", {
    Text = "Aim Part", Values = {"Head","HumanoidRootPart","Torso"}, Default = "HumanoidRootPart",
    Callback = function(v) Config.Aimlock.AimPart = v end,
})
AimBox:AddSlider("AimFOV", {
    Text = "FOV", Default = 250, Min = 30, Max = 800, Rounding = 0,
    Callback = function(v) Config.Aimlock.FOV = v end,
})
AimBox:AddSlider("AimPredict", {
    Text = "Prediction", Default = 0.12, Min = 0, Max = 1, Rounding = 2,
    Callback = function(v) Config.Aimlock.Predict = v end,
})

CrosshairBox:AddToggle("Crosshair", {
    Text = "Enable Crosshair",
    Default = false,
    Callback = function(v) Config.Crosshair.Enabled = v end,
})
CrosshairBox:AddDropdown("CHStyle", {
    Text = "Style", Values = {"Plus","Dot","Circle"}, Default = "Plus",
    Callback = function(v) Config.Crosshair.Style = v end,
})
CrosshairBox:AddSlider("CHSize", {
    Text = "Size", Default = 8, Min = 2, Max = 30, Rounding = 0,
    Callback = function(v) Config.Crosshair.Size = v end,
})
CrosshairBox:AddSlider("CHThick", {
    Text = "Thickness", Default = 2, Min = 1, Max = 10, Rounding = 0,
    Callback = function(v) Config.Crosshair.Thickness = v end,
})
CrosshairBox:AddSlider("CHX", {
    Text = "Position X", Default = 0, Min = -100, Max = 100, Rounding = 0,
    Callback = function(v) Config.Crosshair.OffsetX = v end,
})
CrosshairBox:AddSlider("CHY", {
    Text = "Position Y", Default = 0, Min = -100, Max = 100, Rounding = 0,
    Callback = function(v) Config.Crosshair.OffsetY = v end,
})

-- Loop parry circle
RunService.RenderStepped:Connect(function()
    updateParryCircle()
end)

print("[TIARHUB] Combat tab OK")
print("═══ BAGIAN B DONE — LANJUT BAGIAN C ═══")-- ═══════════════════════════════════════════════════════════
--   BAGIAN C — VISUALS
-- ═══════════════════════════════════════════════════════════

print("[TIARHUB] Bagian C loading...")

-- ═══ GROUPBOXES ═══
local ESPBox       = Tabs.Visuals:AddLeftGroupbox("ESP - Players", "eye")
local ESPObjBox    = Tabs.Visuals:AddLeftGroupbox("ESP - Objects", "box")
local ESPStatusBox = Tabs.Visuals:AddRightGroupbox("ESP Status", "info")
local CircleBox    = Tabs.Visuals:AddRightGroupbox("ESP Circle (Self)", "circle")
local VisualBox    = Tabs.Visuals:AddLeftGroupbox("Visual Contrast", "sun")
local CameraBox    = Tabs.Visuals:AddRightGroupbox("Camera & Zoom", "camera")

-- ═══ CACHE ═══
local ESPObjects       = {}
local StatusESP        = {}
local GenBB            = {}
local SelfCircle       = nil
local CachedSCP        = {}
local CachedGenerators = {}
local CachedWindows    = {}
local CachedPallets    = {}

-- ═══ ESP CORE ═══
local function removeESP(obj)
    if ESPObjects[obj] then
        ESPObjects[obj]:Destroy()
        ESPObjects[obj] = nil
    end
end

local function createESP(obj, color)
    if not obj or not obj.Parent then return end
    if ESPObjects[obj] then
        ESPObjects[obj].FillColor    = color
        ESPObjects[obj].OutlineColor = color
        return
    end
    local h = Instance.new("Highlight")
    h.FillColor           = color
    h.OutlineColor        = color
    h.FillTransparency    = 0.85
    h.OutlineTransparency = 0.3
    h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent              = obj
    ESPObjects[obj] = h

    obj.AncestryChanged:Connect(function(_, parent)
        if not parent then removeESP(obj) end
    end)
end

local function createBB(adornee, size, offset, nameSize)
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
    label.TextSize = nameSize or Config.ESP.NameSize
    label.TextStrokeTransparency = 0
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Text = ""
    label.Parent = bb

    return bb, label
end

-- ═══ CACHE OBJECT ═══
local function cacheObject(obj)
    local name = string.lower(obj.Name)
    if name:find("scp")             then CachedSCP[obj] = true end
    if obj.Name == "Generator"      then CachedGenerators[obj] = true end
    if obj.Name == "Window"         then CachedWindows[obj] = true end
    if obj.Name == "Pallet"
       or obj.Name == "Palletwrong" then CachedPallets[obj] = true end
end

for _, obj in ipairs(workspace:GetDescendants()) do
    cacheObject(obj)
end

workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(function(obj)
    CachedSCP[obj] = nil
    CachedGenerators[obj] = nil
    CachedWindows[obj] = nil
    CachedPallets[obj] = nil
    removeESP(obj)
end)

print("[TIARHUB] ESP cache ready")

-- ═══ ESP STATUS ═══
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

    local teamColor = Color3.new(1,1,1)
    if player.Team then
        if player.Team.Name == "Killer"    then teamColor = Config.ESP.KillerColor end
        if player.Team.Name == "Survivors" then teamColor = Config.ESP.SurvivorColor end
    end
    if isDown then teamColor = Color3.fromRGB(255,0,0) end

    local bb = StatusESP[char]
    if not bb then
        bb, _ = createBB(head, UDim2.new(0, 130, 0, 60), Vector3.new(0, 2.5, 0), Config.ESP.NameSize)
        StatusESP[char] = bb
    end

    local label = bb:FindFirstChild("TiarLabel")
    if label then
        label.Text = text
        label.TextColor3 = teamColor
        label.TextSize = Config.ESP.NameSize
    end
end

-- ═══ ESP GENERATOR ═══
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
    local percent = getGameValue(gen, "RepairProgress") or getGameValue(gen, "Progress") or 0
    if percent >= 100 then
        if GenBB[gen] then GenBB[gen]:Destroy(); GenBB[gen] = nil end
        return
    end
    local cp = math.clamp(percent, 0, 100)
    local color = Config.ESP.GenColor:Lerp(Color3.fromRGB(0,255,120), cp/100)
    local text = string.format("[%.0f%%]", percent)

    if not GenBB[gen] then
        local bb, _ = createBB(gen, UDim2.new(0, 120, 0, 30), Vector3.new(0, 3, 0), 12)
        GenBB[gen] = bb
    end
    local label = GenBB[gen]:FindFirstChild("TiarLabel")
    if label then
        label.Text = text
        label.TextColor3 = color
    end
    createESP(gen, color)
end

-- ═══ ESP CIRCLE SELF ═══
local function updateSelfCircle()
    local root = getRoot()
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

-- ═══ VISUAL CONTRAST ═══
local ColorCorrection = Instance.new("ColorCorrectionEffect")
ColorCorrection.Name = "TiarContrast"
ColorCorrection.Enabled = false
ColorCorrection.Parent = Lighting

local function applyContrast()
    local C = Config.VisualContrast
    if C.Enabled then
        ColorCorrection.Enabled = true
        ColorCorrection.Contrast   = C.Contrast
        ColorCorrection.Saturation = C.Saturation
        ColorCorrection.Brightness = C.Brightness
        ColorCorrection.TintColor  = C.Tint
    else
        ColorCorrection.Enabled = false
    end
end

local ContrastPresets = {
    ["Default"]      = { c=1.0, s=1.0, b=0.0,  t=Color3.fromRGB(255,255,255) },
    ["Competitive"]  = { c=1.4, s=1.3, b=0.05, t=Color3.fromRGB(255,255,255) },
    ["Horror"]       = { c=1.6, s=0.8, b=-0.05,t=Color3.fromRGB(180,100,100) },
    ["Night Vision"] = { c=1.5, s=1.2, b=0.3,  t=Color3.fromRGB(80,255,120) },
    ["FPS Boost"]    = { c=1.1, s=0.7, b=0.0,  t=Color3.fromRGB(255,255,255) },
}

-- ═══ FULLBRIGHT ═══
local FBOriginal = {
    Brightness = Lighting.Brightness,
    ClockTime  = Lighting.ClockTime,
    Ambient    = Lighting.Ambient,
    Outdoor    = Lighting.OutdoorAmbient,
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

-- ═══ MAIN VISUAL LOOP ═══
local lastVisualUpdate = 0
RunService.RenderStepped:Connect(function()
    local now = tick()
    if now - lastVisualUpdate < 0.05 then
        updateSelfCircle()
        return
    end
    lastVisualUpdate = now

    local root = getRoot()

    -- ESP Player
    if root then
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
    end

    -- ESP Generator
    if Config.ESP.Generator then
        for gen in pairs(CachedGenerators) do
            updateGenerator(gen)
        end
    end

    -- ESP SCP
    if Config.ESP.SCP and root then
        for obj in pairs(CachedSCP) do
            if obj and obj.Parent then
                local pos
                if obj:IsA("Model")       then pos = obj:GetPivot().Position
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

    -- ESP Window + Pallet
    if root then
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
    end

    updateSelfCircle()
end)

print("[TIARHUB] Visual loop ready")

-- ═══ UI — ESP PLAYERS ═══
local SurvivorToggle = ESPBox:AddToggle("SurvivorESP", {
    Text = "ESP Survivor", Default = false,
    Callback = function(v) Config.ESP.Survivor = v end,
})
SurvivorToggle:AddColorPicker("SurvivorESPColor", {
    Default = Config.ESP.SurvivorColor, Title = "Survivor Color",
    Callback = function(c) Config.ESP.SurvivorColor = c end,
})

local KillerToggle = ESPBox:AddToggle("KillerESP", {
    Text = "ESP Killer", Default = false,
    Callback = function(v) Config.ESP.Killer = v end,
})
KillerToggle:AddColorPicker("KillerESPColor", {
    Default = Config.ESP.KillerColor, Title = "Killer Color",
    Callback = function(c) Config.ESP.KillerColor = c end,
})

ESPBox:AddSlider("ESPDistance", {
    Text = "ESP Radius", Default = 300, Min = 20, Max = 2000, Rounding = 0,
    Suffix = " studs",
    Callback = function(v) Config.ESP.Distance = v end,
})

ESPBox:AddSlider("ESPNameSize", {
    Text = "ESP Name Size", Default = 14, Min = 8, Max = 40, Rounding = 0,
    Callback = function(v) Config.ESP.NameSize = v end,
})

-- ═══ UI — ESP OBJECTS ═══
local GenToggle = ESPObjBox:AddToggle("ESPGenerator", {
    Text = "ESP Generator (progress)", Default = false,
    Callback = function(v) Config.ESP.Generator = v end,
})
GenToggle:AddColorPicker("GenESPColor", {
    Default = Config.ESP.GenColor, Title = "Generator Color",
    Callback = function(c) Config.ESP.GenColor = c end,
})

local SCPToggle = ESPObjBox:AddToggle("ESPSCP", {
    Text = "ESP SCP", Default = false,
    Callback = function(v) Config.ESP.SCP = v end,
})
SCPToggle:AddColorPicker("SCPColor", {
    Default = Config.ESP.SCPColor, Title = "SCP Color",
    Callback = function(c) Config.ESP.SCPColor = c end,
})

local PalletToggle = ESPObjBox:AddToggle("ESPPallet", {
    Text = "ESP Pallet", Default = false,
    Callback = function(v) Config.ESP.Pallet = v end,
})
PalletToggle:AddColorPicker("PalletColor", {
    Default = Config.ESP.PalletColor, Title = "Pallet Color",
    Callback = function(c) Config.ESP.PalletColor = c end,
})

local WindowToggle = ESPObjBox:AddToggle("ESPWindow", {
    Text = "ESP Window", Default = false,
    Callback = function(v) Config.ESP.Window = v end,
})
WindowToggle:AddColorPicker("WindowColor", {
    Default = Config.ESP.WindowColor, Title = "Window Color",
    Callback = function(c) Config.ESP.WindowColor = c end,
})

-- ═══ UI — ESP STATUS ═══
ESPStatusBox:AddToggle("ESPStatusEnabled", {
    Text = "Enable Status ESP", Default = false,
    Callback = function(v) Config.ESPStatus.Enabled = v end,
})
ESPStatusBox:AddToggle("ShowName", {
    Text = "Show Name", Default = true,
    Callback = function(v) Config.ESPStatus.ShowName = v end,
})
ESPStatusBox:AddToggle("ShowDist", {
    Text = "Show Distance", Default = true,
    Callback = function(v) Config.ESPStatus.ShowDistance = v end,
})
ESPStatusBox:AddToggle("ShowHP", {
    Text = "Show Health", Default = false,
    Callback = function(v) Config.ESPStatus.ShowHealth = v end,
})
ESPStatusBox:AddSlider("StatusRadius", {
    Text = "Status Radius", Default = 200, Min = 20, Max = 1000, Rounding = 0,
    Callback = function(v) Config.ESPStatus.Radius = v end,
})

-- ═══ UI — ESP CIRCLE ═══
local CircleToggle = CircleBox:AddToggle("ESPCircleEnabled", {
    Text = "Enable ESP Circle", Default = false,
    Tooltip = "Lingkaran neon di bawah player",
    Callback = function(v) Config.ESPCircle.Enabled = v end,
})
CircleToggle:AddColorPicker("ESPCircleColor", {
    Default = Config.ESPCircle.Color, Title = "Circle Color",
    Callback = function(c) Config.ESPCircle.Color = c end,
})
CircleBox:AddSlider("CircleSize", {
    Text = "Circle Size", Default = 6, Min = 2, Max = 50, Rounding = 0,
    Suffix = " studs",
    Callback = function(v) Config.ESPCircle.Size = v end,
})
CircleBox:AddSlider("CircleThick", {
    Text = "Circle Thickness", Default = 0.1, Min = 0.05, Max = 1, Rounding = 2,
    Callback = function(v) Config.ESPCircle.Thickness = v end,
})
CircleBox:AddSlider("CircleTrans", {
    Text = "Circle Transparency", Default = 0.5, Min = 0, Max = 1, Rounding = 2,
    Callback = function(v) Config.ESPCircle.Transparency = v end,
})

-- ═══ UI — VISUAL CONTRAST ═══
VisualBox:AddDropdown("ContrastPreset", {
    Text = "Preset",
    Values = { "Default", "Competitive", "Horror", "Night Vision", "FPS Boost" },
    Default = "Default",
    Multi = false,
    Callback = function(v)
        local p = ContrastPresets[v]
        if not p then return end
        Config.VisualContrast.Enabled    = true
        Config.VisualContrast.Contrast   = p.c
        Config.VisualContrast.Saturation = p.s
        Config.VisualContrast.Brightness = p.b
        Config.VisualContrast.Tint       = p.t
        applyContrast()
        notify("Contrast", "Preset: " .. v, 2)
    end,
})

VisualBox:AddToggle("ContrastEnabled", {
    Text = "Enable Contrast", Default = false,
    Callback = function(v)
        Config.VisualContrast.Enabled = v
        applyContrast()
    end,
})

VisualBox:AddSlider("ContrastValue", {
    Text = "Contrast", Default = 1.0, Min = 0.5, Max = 2.5, Rounding = 2,
    Callback = function(v) Config.VisualContrast.Contrast = v; applyContrast() end,
})
VisualBox:AddSlider("SaturationValue", {
    Text = "Saturation", Default = 1.0, Min = 0, Max = 2.5, Rounding = 2,
    Callback = function(v) Config.VisualContrast.Saturation = v; applyContrast() end,
})
VisualBox:AddSlider("BrightnessValue", {
    Text = "Brightness", Default = 0.0, Min = -0.5, Max = 0.5, Rounding = 2,
    Callback = function(v) Config.VisualContrast.Brightness = v; applyContrast() end,
})
VisualBox:AddColorPicker("TintColor", {
    Default = Color3.fromRGB(255,255,255), Title = "Tint Color",
    Callback = function(c) Config.VisualContrast.Tint = c; applyContrast() end,
})
VisualBox:AddDivider()
VisualBox:AddToggle("FullbrightToggle", {
    Text = "Fullbright", Default = false,
    Callback = function(v) Config.Fullbright.Enabled = v; applyFullbright() end,
})

-- ═══ UI — CAMERA ═══
CameraBox:AddToggle("UnlimitedZoom", {
    Text = "Unlimited Zoom", Default = false,
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
    Text = "Max Zoom Distance", Default = 1000, Min = 100, Max = 5000, Rounding = 0,
    Callback = function(v)
        Config.Zoom.Max = v
        if Config.Zoom.Enabled then LocalPlayer.CameraMaxZoomDistance = v end
    end,
})
CameraBox:AddToggle("CustomFOV", {
    Text = "Custom FOV", Default = false,
    Callback = function(v)
        Config.FOV.Enabled = v
        Camera.FieldOfView = v and Config.FOV.Value or 70
    end,
})
CameraBox:AddSlider("FOVValue", {
    Text = "FOV Value", Default = 70, Min = 30, Max = 120, Rounding = 0,
    Callback = function(v)
        Config.FOV.Value = v
        if Config.FOV.Enabled then Camera.FieldOfView = v end
    end,
})

-- ═══ RESPAWN ═══
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if Config.Fullbright.Enabled then applyFullbright() end
    if SelfCircle then SelfCircle:Destroy(); SelfCircle = nil end
end)

print("[TIARHUB] Bagian C DONE — Visuals OK ✅")
print("═══ BAGIAN C DONE — LANJUT BAGIAN D ═══")-- ═══════════════════════════════════════════════════════════
--   BAGIAN D — MOVEMENT
-- ═══════════════════════════════════════════════════════════

print("[TIARHUB] Bagian D loading...")

-- ═══ GROUPBOXES ═══
local SpeedBox    = Tabs.Movement:AddLeftGroupbox("Speed", "zap")
local JumpBox     = Tabs.Movement:AddLeftGroupbox("Jump & NoClip", "arrow-up")
local VaultBox    = Tabs.Movement:AddRightGroupbox("Vault & Anim", "activity")
local MWBox       = Tabs.Movement:AddRightGroupbox("Moonwalk", "moon")
local TeleportBox = Tabs.Movement:AddLeftGroupbox("Teleport", "map-pin")

-- ═══ PAUSE ANIMS ═══
local PauseAnims = {
    ["rbxassetid://127096285501517"] = true,  -- Parry
    ["rbxassetid://112166042383605"] = true,  -- Break Pallet
    ["rbxassetid://123047897844134"] = true,  -- Stun
    ["http://www.roblox.com/asset/?id=126965695851149"] = true,
    ["http://www.roblox.com/asset/?id=135084204086504"] = true,
}

local function shouldPauseMods()
    local char = LocalPlayer.Character
    if not char then return true end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return true end

    if hum.Health <= 0
    or hum.Health < 2
    or char:GetAttribute("Downed")  == true
    or char:GetAttribute("IsDown")  == true
    or char:GetAttribute("Knocked") == true then
        return true
    end

    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            local anim = track.Animation
            if anim and anim.AnimationId then
                if PauseAnims[anim.AnimationId] then return true end
                local id = anim.AnimationId:match("%d+")
                if id then
                    if KillerAnims["rbxassetid://" .. id] then return true end
                end
            end
        end
    end
    return false
end

-- ═══ WALKSPEED ═══
local WalkConn = nil
local OrigWS = 16

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

-- ═══ JUMP POWER ═══
local JumpConn = nil
local OrigJP = 50

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
            local h = Config.JumpPower.Value / 7.5
            if hum.JumpHeight ~= h then hum.JumpHeight = h end
        end
    end)
end

-- ═══ NOCLIP ═══
local NoClipConn = nil

local function enableNoClip()
    if NoClipConn then NoClipConn:Disconnect(); NoClipConn = nil end
    NoClipConn = RunService.Stepped:Connect(function()
        if not Config.NoClip.Enabled then return end
        local c = LocalPlayer.Character
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
            end
        end
    end)
end

local function disableNoClip()
    if NoClipConn then NoClipConn:Disconnect(); NoClipConn = nil end
    local c = LocalPlayer.Character
    if c then
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end

-- ═══ MOONWALK ═══
local MWConn = nil
local MWButton = nil

local function startMoonwalk()
    if MWConn then return end
    MWConn = RunService.RenderStepped:Connect(function()
        if not Config.Moonwalk.Enabled then return end
        if shouldPauseMods() then return end

        local c = LocalPlayer.Character
        if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        local hrp = c:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not h or not hrp or not cam then return end

        if h.WalkSpeed ~= Config.Moonwalk.Slow then
            h.WalkSpeed = Config.Moonwalk.Slow
        end

        local look = cam.CFrame.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude > 0 then
            flat = flat.Unit
            local base = CFrame.new(hrp.Position, hrp.Position + flat)
            local angle = math.sin(tick() * Config.Moonwalk.Spam) * Config.Moonwalk.Intensity
            hrp.CFrame = base * CFrame.Angles(0, math.rad(angle), 0)
            h:Move(Vector3.new(0, 0, 1), true)
        end
    end)
end

local function stopMoonwalk()
    if MWConn then MWConn:Disconnect(); MWConn = nil end
    local h = getHum()
    if h then
        h.WalkSpeed = Config.WalkSpeed.Enabled and Config.WalkSpeed.Value or OrigWS
    end
end

local function createMWButton()
    if MWButton then MWButton:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "TiarMoonwalkBtn"
    gui.ResetOnSpawn = false
    gui.Parent = PlayerGui

    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 55, 0, 55)
    btn.Position = UDim2.new(0.68, 0, 0.72, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.85
    btn.Image = "rbxassetid://93349170559446"
    btn.ImageTransparency = 0.1
    btn.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.6
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

    MWButton = gui
end

local function removeMWButton()
    if MWButton then MWButton:Destroy(); MWButton = nil end
end

-- ═══ FAST VAULT ═══
local VaultReplace = {
    ["rbxassetid://83873880822918"] = "rbxassetid://136962284480779",
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

-- ═══ TELEPORT ═══
local function tpFinish()
    local root = getRoot()
    if not root then notify("TP","Player gak ada",2); return end
    for _, o in ipairs(workspace:GetDescendants()) do
        local n = string.lower(o.Name)
        if o:IsA("BasePart") and (n == "fininshline" or n:find("exit") or n:find("finish")) then
            root.CFrame = o.CFrame + Vector3.new(0, 5, 0)
            notify("TP", "Finish!", 2)
            return
        end
    end
    notify("TP", "Finish line gak ketemu", 2)
end

local function tpGen()
    local root = getRoot(); if not root then return end
    local best, dist = nil, math.huge
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("Model") and o.Name == "Generator" then
            local d = (o:GetPivot().Position - root.Position).Magnitude
            if d < dist then dist = d; best = o end
        end
    end
    if best then
        root.CFrame = CFrame.new(best:GetPivot().Position + Vector3.new(0,5,0))
        notify("TP", "Generator terdekat", 2)
    else
        notify("TP", "Gak ada generator", 2)
    end
end

local function tpKiller()
    local root = getRoot(); if not root then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team and p.Team.Name == "Killer" and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                root.CFrame = hrp.CFrame * CFrame.new(0, 0, 5)
                notify("TP", "Ke Killer", 2)
                return
            end
        end
    end
    notify("TP", "Killer gak ketemu", 2)
end

-- ═══ UI — SPEED ═══
SpeedBox:AddToggle("WalkSpeedToggle", {
    Text = "Walk Speed", Default = false,
    Callback = function(v)
        Config.WalkSpeed.Enabled = v
        if v then
            applyWalkSpeed()
        else
            if WalkConn then WalkConn:Disconnect(); WalkConn = nil end
            local h = getHum(); if h then h.WalkSpeed = OrigWS end
        end
    end,
})
SpeedBox:AddSlider("WalkSpeedSlider", {
    Text = "Walk Speed Value", Default = 17.6, Min = 16, Max = 100, Rounding = 1,
    Callback = function(v) Config.WalkSpeed.Value = v end,
})
SpeedBox:AddSlider("SpamSpeedValue", {
    Text = "Spam Speed", Default = 30, Min = 1, Max = 100, Rounding = 0,
    Callback = function(v) Config.Moonwalk.Spam = v end,
})
SpeedBox:AddSlider("IntensityValue", {
    Text = "Intensity", Default = 35, Min = 1, Max = 90, Rounding = 0,
    Callback = function(v) Config.Moonwalk.Intensity = v end,
})

-- ═══ UI — JUMP & NOCLIP ═══
JumpBox:AddToggle("JumpPowerToggle", {
    Text = "Custom Jump Power", Default = false,
    Callback = function(v)
        Config.JumpPower.Enabled = v
        if v then
            applyJumpPower()
        else
            if JumpConn then JumpConn:Disconnect(); JumpConn = nil end
            local h = getHum()
            if h then
                if h.UseJumpPower then h.JumpPower = OrigJP
                else h.JumpHeight = OrigJP / 7.5 end
            end
        end
    end,
})
JumpBox:AddSlider("JumpPowerValue", {
    Text = "Jump Power", Default = 50, Min = 0, Max = 300, Rounding = 0,
    Callback = function(v) Config.JumpPower.Value = v end,
})
JumpBox:AddDivider()
JumpBox:AddToggle("NoClipToggle", {
    Text = "No Clip", Default = false,
    Callback = function(v)
        Config.NoClip.Enabled = v
        if v then enableNoClip() else disableNoClip() end
    end,
})

-- ═══ UI — VAULT ═══
VaultBox:AddToggle("FastVaultToggle", {
    Text = "Fast Vault", Default = false,
    Callback = function(v) Config.FastVault.Enabled = v end,
})
VaultBox:AddSlider("VaultSpeedFactor", {
    Text = "Vault Speed Factor", Default = 1.2, Min = 1, Max = 5, Rounding = 1,
    Callback = function(v) Config.FastVault.Speed = v end,
})

-- ═══ UI — MOONWALK ═══
local MWToggle = MWBox:AddToggle("MoonwalkEnabled", {
    Text = "Moonwalk (Keybind)", Default = false,
    Callback = function(v)
        Config.Moonwalk.Enabled = v
        if v then startMoonwalk() else stopMoonwalk() end
    end,
})
MWToggle:AddKeybind({
    Text = "Keybind", Default = Enum.KeyCode.V,
    Callback = function() end,
})
MWBox:AddToggle("MoonwalkButtonToggle", {
    Text = "On-Screen Button", Default = false,
    Callback = function(v)
        if v then createMWButton() else removeMWButton() end
    end,
})
MWBox:AddSlider("MoonwalkSlow", {
    Text = "Moonwalk Speed", Default = 13, Min = 1, Max = 50, Rounding = 0,
    Callback = function(v) Config.Moonwalk.Slow = v end,
})

-- ═══ UI — TELEPORT ═══
TeleportBox:AddButton({ Text = "⚡ Instant Escape", Func = tpFinish })
TeleportBox:AddButton({ Text = "📡 TP ke Generator", Func = tpGen })
TeleportBox:AddButton({ Text = "🔪 TP ke Killer", Func = tpKiller })

-- ═══ RESPAWN ═══
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    local h = char:FindFirstChildOfClass("Humanoid")
    if h then
        OrigWS = h.WalkSpeed
        OrigJP = h.UseJumpPower and h.JumpPower or 50
    end
    if Config.WalkSpeed.Enabled then applyWalkSpeed() end
    if Config.JumpPower.Enabled then applyJumpPower() end
    if Config.NoClip.Enabled then enableNoClip() end
    if Config.Moonwalk.Enabled then startMoonwalk() end
    if Config.FastVault.Enabled then hookVault(char) end
end)

if LocalPlayer.Character then
    local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then
        OrigWS = h.WalkSpeed
        OrigJP = h.UseJumpPower and h.JumpPower or 50
    end
    hookVault(LocalPlayer.Character)
end

print("[TIARHUB] Bagian D — Movement DONE ✅")
print("═══ BAGIAN D DONE — LANJUT BAGIAN E ═══")-- ═══════════════════════════════════════════════════════════
--   BAGIAN E — AUTO + PLAYER
-- ═══════════════════════════════════════════════════════════

print("[TIARHUB] Bagian E loading...")

-- ═══════════════════════════════════════════════════════════
--   TAB 5: AUTO
-- ═══════════════════════════════════════════════════════════
local SkillBox  = Tabs.Auto:AddLeftGroupbox("Auto Skill Check", "check")
local WiggleBox = Tabs.Auto:AddLeftGroupbox("Auto Wiggle", "activity")
local FleeBox   = Tabs.Auto:AddRightGroupbox("Auto Flee Killer", "run")
local StalkBox  = Tabs.Auto:AddRightGroupbox("Auto Stalk (Killer)", "eye")

-- ═══ AUTO SKILL CHECK ═══
local SkillConn    = nil
local SkillBusy    = false
local SkillLastHit = 0

local function pressSpace()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.Space, false, game)
        task.wait(0.03)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end

local function getActionTarget()
    local cur = PlayerGui
    for seg in string.gmatch("Survivor-mob.Controls.action.check", "[^%.]+") do
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
            VirtualInputManager:SendTouchEvent(8822, 0, x, y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8822, 2, x, y)
        end)
    end
end

local function startSkillCheck()
    if SkillConn then SkillConn:Disconnect() end
    SkillConn = RunService.RenderStepped:Connect(function()
        if not Config.AutoSkillCheck.Enabled then return end
        if SkillBusy then return end
        if tick() - SkillLastHit < 0.15 then return end

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
            SkillBusy = true
            SkillLastHit = tick()
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

-- ═══ AUTO WIGGLE ═══
local WiggleConn = nil

local function isCarried()
    local c = LocalPlayer.Character
    if not c then return false end
    local a = c:FindFirstChild("IsCarried")
    local b = c:FindFirstChild("IsCarrying")
    return (a and a.Value) or (b and b.Value)
end

local function getWiggleRemote()
    if not Remotes then return nil end
    local carry = Remotes:FindFirstChild("Carry")
    if not carry then return nil end
    return carry:FindFirstChild("SelfUnHookEvent")
end

local function startAutoWiggle()
    if WiggleConn then WiggleConn:Disconnect() end
    WiggleConn = RunService.Heartbeat:Connect(function()
        if not Config.AutoWiggle.Enabled then return end
        if not isCarried() then return end
        local ev = getWiggleRemote()
        if not ev then return end
        for i = 1, Config.AutoWiggle.Spam do
            pcall(function() ev:FireServer() end)
        end
    end)
end

-- ═══ AUTO FLEE KILLER ═══
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
                if d < shortest then shortest = d; closest = hrp end
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
            if d > dist then dist = d; best = obj end
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

-- ═══ AUTO STALK ═══
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
    if not Remotes then return nil end
    local killers = Remotes:FindFirstChild("Killers")
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
        local ev = getStalkRemote()
        if ev then pcall(function() ev:FireServer(target) end) end
    end)
end

local function stopAutoStalk()
    if StalkConn then StalkConn:Disconnect(); StalkConn = nil end
end

-- ═══ UI — AUTO ═══
SkillBox:AddToggle("AutoSkillCheck", {
    Text = "Auto Skill Check", Default = false,
    Tooltip = "PC: Space | Mobile: tap",
    Callback = function(v)
        Config.AutoSkillCheck.Enabled = v
        if v then startSkillCheck() end
    end,
})

WiggleBox:AddToggle("AutoWiggle", {
    Text = "Auto Wiggle", Default = false,
    Callback = function(v)
        Config.AutoWiggle.Enabled = v
        if v then startAutoWiggle() end
    end,
})
WiggleBox:AddSlider("WiggleSpam", {
    Text = "Spam Intensity", Default = 5, Min = 1, Max = 30, Rounding = 0,
    Callback = function(v) Config.AutoWiggle.Spam = v end,
})

FleeBox:AddToggle("AutoFlee", {
    Text = "Auto Flee Killer", Default = false,
    Callback = function(v) Config.AutoFlee.Enabled = v end,
})
FleeBox:AddSlider("FleeDistance", {
    Text = "Detect Distance", Default = 50, Min = 10, Max = 200, Rounding = 0,
    Suffix = " studs",
    Callback = function(v) Config.AutoFlee.Distance = v end,
})
FleeBox:AddSlider("FleeCooldown", {
    Text = "Cooldown", Default = 0.1, Min = 0.05, Max = 2, Rounding = 2,
    Suffix = " s",
    Callback = function(v) Config.AutoFlee.Cooldown = v end,
})

StalkBox:AddToggle("AutoStalk", {
    Text = "Auto Stalk", Default = false,
    Tooltip = "Buat killer Myers-like",
    Callback = function(v)
        Config.Stalk.Enabled = v
        if v then startAutoStalk() else stopAutoStalk() end
    end,
})
StalkBox:AddSlider("StalkRange", {
    Text = "Stalk Range", Default = 150, Min = 20, Max = 500, Rounding = 0,
    Suffix = " studs",
    Callback = function(v) Config.Stalk.Range = v end,
})

print("[TIARHUB] Auto tab OK")

-- ═══════════════════════════════════════════════════════════
--   TAB 6: PLAYER
-- ═══════════════════════════════════════════════════════════
local MaskedBox = Tabs.Player:AddLeftGroupbox("Masked Power", "sparkles")
local KillerBox = Tabs.Player:AddLeftGroupbox("Killer Abilities", "skull")
local EmoteBox  = Tabs.Player:AddRightGroupbox("Emote", "music")
local AvatarBox = Tabs.Player:AddRightGroupbox("Avatar Stealer", "user")
local FunBox    = Tabs.Player:AddRightGroupbox("Fun / Troll", "smile")

-- ═══ MASKED POWER ═══
local MaskedPowers = { "Cobra", "Richter", "Brandon", "Rabbit", "Alex" }

local function getMaskedRemote(name)
    if not Remotes then return nil end
    local killers = Remotes:FindFirstChild("Killers")
    if not killers then return nil end
    local masked = killers:FindFirstChild("Masked")
    if not masked then return nil end
    return masked:FindFirstChild(name)
end

local function activatePower()
    local ev = getMaskedRemote("Activatepower")
    if ev then
        pcall(function() ev:FireServer(Config.Masked.Power) end)
        notify("Masked", "Activated: " .. Config.Masked.Power, 2)
    else
        notify("Masked", "Remote gak ketemu", 2)
    end
end

local function deactivatePower()
    local ev = getMaskedRemote("Deactivatepower")
    if ev then
        pcall(function() ev:FireServer() end)
        notify("Masked", "Deactivated", 2)
    else
        notify("Masked", "Remote gak ketemu", 2)
    end
end

-- ═══ KILLER ABILITIES ═══
local KillerBusy   = false
local KillerTarget = nil
local LastAttack   = 0

local function getAttackEvent()
    if not Remotes then return nil end
    local attacks = Remotes:FindFirstChild("Attacks")
    if not attacks then return nil end
    return attacks:FindFirstChild("BasicAttack")
end

local function getCarryEvent()
    if not Remotes then return nil end
    local carry = Remotes:FindFirstChild("Carry")
    if not carry then return nil end
    return carry:FindFirstChild("CarrySurvivorEvent")
end

local function getHookEvent()
    if not Remotes then return nil end
    local carry = Remotes:FindFirstChild("Carry")
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
                if d < shortest and d <= Config.Killer.KillRange then
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
                if d < dist then dist = d; best = p.Character end
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
            if d < shortest and d < 400 then shortest = d; best = obj end
        end
    end
    return best
end

task.spawn(function()
    while task.wait(0.05) do
        if Config.Killer.AutoAttack then
            if tick() - LastAttack >= Config.Killer.AttackDelay then
                LastAttack = tick()
                local ev = getAttackEvent()
                if ev then pcall(function() ev:FireServer(false) end) end
            end
        end

        if Config.Killer.AutoCarry and not KillerBusy then
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
                            local he = getHookEvent()
                            if he then
                                for i = 1, 6 do
                                    pcall(function() he:FireServer(hook) end)
                                    task.wait(0.15)
                                end
                            end
                        end
                    end
                end
                task.delay(2, function() KillerBusy = false end)
            end)
        end

        if Config.Killer.KillAll then
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
                        local v = tHRP.AssemblyLinearVelocity
                        local pred = v * 0.15
                        local tPos = tHRP.Position + pred
                        local behind = tHRP.CFrame.LookVector * -3
                        root.CFrame = CFrame.new(tPos + behind, tPos)
                    end
                    local atk = getAttackEvent()
                    if atk then pcall(function() atk:FireServer(false) end) end
                end
            end
        end
    end
end)

-- ═══ EMOTE ═══
local EmoteList = {
    "Mannrobics", "Arm Swing", "Schadenfreude", "Kyoufuu",
    "Backflip", "Griddy", "Friday Night", "Floating Rest",
    "OnePlays", "Quick Combo", "WarCry", "Wave"
}

local EmoteSelected = "Mannrobics"
local EmoteBtnGui   = nil
local EmoteLabelRef = nil

local function getEmoteRemote()
    if not Remotes then return nil end
    return Remotes:FindFirstChild("EmoteHandler")
end

local function playEmote(name)
    local ev = getEmoteRemote()
    if ev then pcall(function() ev:FireServer(name) end) end
end

local function createEmoteButton()
    if EmoteBtnGui then EmoteBtnGui:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "TiarEmoteBtn"
    gui.ResetOnSpawn = false
    gui.Parent = PlayerGui

    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 55, 0, 55)
    btn.Position = UDim2.new(0.55, 0, 0.72, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.85
    btn.Image = "rbxassetid://93349170559446"
    btn.ImageTransparency = 0.1
    btn.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.6
    stroke.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 100, 0, 20)
    label.Position = UDim2.new(0.5, -50, -0.6, 0)
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
        EmoteBtnGui   = nil
        EmoteLabelRef = nil
    end
end

-- ═══ AVATAR STEALER ═══
local function saveOriginalAppearance()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        Config.Avatar.Original = hum:GetAppliedDescription()
        notify("Avatar", "Original saved", 2)
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
    hum:ApplyDescriptionClientServer(desc)
end

local function removeAllClothing(character)
    for _, v in ipairs(character:GetDescendants()) do
        if v:IsA("Accessory") or v:IsA("Clothing")
        or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
            v:Destroy()
        end
    end
end

local function copyAvatar(username)
    if not username or username == "" then
        notify("Avatar", "Username kosong", 2); return
    end
    saveOriginalAppearance()
    local ok, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    if not ok then notify("Avatar", "User gak ketemu", 2); return end
    Config.Avatar.UserId = userId

    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    task.spawn(function()
        local desc = Players:GetHumanoidDescriptionFromUserId(userId)
        if Config.Avatar.Blocky then
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
    if not Config.Avatar.Original then
        notify("Avatar", "Belum ada original", 2); return
    end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        removeAllClothing(char)
        hum:ApplyDescriptionClientServer(Config.Avatar.Original)
        Config.Avatar.UserId = nil
        notify("Avatar", "Reset ke original", 2)
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    if Config.Avatar.UserId then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local desc = Players:GetHumanoidDescriptionFromUserId(Config.Avatar.UserId)
            if Config.Avatar.Blocky then applyBlockyBody(char) end
            removeAllClothing(char)
            hum:ApplyDescriptionClientServer(desc)
        end
    end
end)

-- ═══ JERK TOOL ═══
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
    tool.ToolTip = "in the stripped club"
    tool.RequiresHandle = false
    tool.Parent = backpack
    CurrentJerkTool = tool

    local jorkin = false
    local track  = nil

    local function stop()
        jorkin = false
        if track then track:Stop(); track = nil end
    end

    tool.Equipped:Connect(function() jorkin = true end)
    tool.Unequipped:Connect(stop)
    hum.Died:Connect(stop)

    task.spawn(function()
        while task.wait() do
            if not Config.Jerk.Enabled or not jorkin then
                if track then track:Stop() end
                continue
            end
            local isR15 = hum.RigType == Enum.HumanoidRigType.R15
            if not track then
                local anim = Instance.new("Animation")
                anim.AnimationId = isR15 and "rbxassetid://698251653" or "rbxassetid://72042024"
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
    if Config.Jerk.Enabled then createJerkTool() end
end)

-- ═══ UI — MASKED ═══
MaskedBox:AddDropdown("MaskedSelect", {
    Text = "Select Power", Values = MaskedPowers, Default = "Cobra", Multi = false,
    Callback = function(v) Config.Masked.Power = v end,
})
MaskedBox:AddButton({ Text = "⚡ Activate Power", Func = activatePower })
MaskedBox:AddButton({ Text = "🛑 Deactivate Power", Func = deactivatePower })

-- ═══ UI — KILLER ABILITIES ═══
KillerBox:AddToggle("AutoKillAll", {
    Text = "Auto Kill All", Default = false,
    Callback = function(v) Config.Killer.KillAll = v end,
})
KillerBox:AddToggle("AutoSpamAttack", {
    Text = "Auto Spam Attack", Default = false,
    Callback = function(v) Config.Killer.AutoAttack = v end,
})
KillerBox:AddSlider("AttackDelay", {
    Text = "Attack Delay", Default = 0.45, Min = 0.1, Max = 2, Rounding = 2,
    Suffix = " s",
    Callback = function(v) Config.Killer.AttackDelay = v end,
})
KillerBox:AddDivider()
KillerBox:AddToggle("AutoCarry", {
    Text = "Auto Carry + Hook", Default = false,
    Callback = function(v) Config.Killer.AutoCarry = v end,
})
KillerBox:AddSlider("KillRange", {
    Text = "Kill Range", Default = 500, Min = 50, Max = 2000, Rounding = 0,
    Suffix = " studs",
    Callback = function(v) Config.Killer.KillRange = v end,
})

-- ═══ UI — EMOTE ═══
EmoteBox:AddDropdown("EmoteSelect", {
    Text = "Select Emote", Values = EmoteList, Default = "Mannrobics", Multi = false,
    Callback = function(v)
        EmoteSelected = v
        if EmoteLabelRef then EmoteLabelRef.Text = v end
    end,
})
EmoteBox:AddButton({ Text = "▶️ Play Emote", Func = function() playEmote(EmoteSelected) end })
EmoteBox:AddToggle("ShowEmoteBtn", {
    Text = "Show On-Screen Button", Default = false,
    Callback = function(v)
        if v then createEmoteButton() else removeEmoteButton() end
    end,
})

-- ═══ UI — AVATAR ═══
AvatarBox:AddInput("AvatarUsername", {
    Text = "Target Username", Default = "", Placeholder = "Ketik username...",
    Finished = true,
    Callback = function(v) Config.Avatar.Username = v end,
})
AvatarBox:AddButton({ Text = "📥 Copy Avatar", Func = function() copyAvatar(Config.Avatar.Username) end })
AvatarBox:AddButton({ Text = "🔄 Reset to Original", Func = resetAvatar })
AvatarBox:AddButton({ Text = "💾 Save as Original", Func = saveOriginalAppearance })

-- ═══ UI — FUN ═══
FunBox:AddToggle("JerkTool", {
    Text = "Jerk Tool", Default = false,
    Callback = function(v)
        Config.Jerk.Enabled = v
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

print("[TIARHUB] Player tab OK")
print("[TIARHUB] Bagian E DONE ✅")
print("═══ BAGIAN E DONE — LANJUT BAGIAN F (FINAL) ═══")-- ═══════════════════════════════════════════════════════════
--   BAGIAN F — SETTINGS + FINALIZATION (FINAL)
-- ═══════════════════════════════════════════════════════════

print("[TIARHUB] Bagian F loading...")

-- ═══════════════════════════════════════════════════════════
--   TAB 7: SETTINGS
-- ═══════════════════════════════════════════════════════════
local SettingBox = Tabs.Settings:AddLeftGroupbox("Menu Settings", "wrench")
local ConfigBox  = Tabs.Settings:AddRightGroupbox("Config & Theme", "settings")
local AboutBox   = Tabs.Settings:AddLeftGroupbox("About", "info")

-- ═══ CUSTOM CURSOR ═══
SettingBox:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor", Default = true,
    Callback = function(v) Library.ShowCustomCursor = v end,
})

-- ═══ NOTIFICATION SIDE ═══
SettingBox:AddDropdown("NotificationSide", {
    Text = "Notification Side",
    Values = { "Left", "Right" },
    Default = "Right", Multi = false,
    Callback = function(v) Library:SetNotifySide(v) end,
})

-- ═══ DPI SCALE ═══
SettingBox:AddDropdown("DPIDropdown", {
    Text = "DPI Scale",
    Values = { "50%", "75%", "85%", "100%", "125%", "150%" },
    Default = "100%", Multi = false,
    Callback = function(v)
        local n = tonumber(v:gsub("%%", ""))
        if n then Library:SetDPIScale(n) end
    end,
})

-- ═══ CORNER RADIUS ═══
SettingBox:AddSlider("UICornerSlider", {
    Text = "Corner Radius", Default = 20, Min = 0, Max = 30, Rounding = 0,
    Callback = function(v)
        if Window.SetCornerRadius then Window:SetCornerRadius(v) end
    end,
})

-- ═══ WATERMARK ═══
local Watermark = Library:AddDraggableLabel("TIARHUB")

SettingBox:AddToggle("WatermarkToggle", {
    Text = "Show Watermark", Default = true,
    Callback = function(v) Watermark.Visible = v end,
})

-- Update watermark (FPS / PING)
local FPS, Frames, LastTick = 0, 0, tick()
RunService.RenderStepped:Connect(function()
    Frames += 1
    if tick() - LastTick >= 1 then
        FPS = Frames
        Frames = 0
        LastTick = tick()
        local ok, ping = pcall(function()
            return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        if not ok then ping = 0 end
        Watermark:SetText(string.format(
            "TIARHUB | FPS: %d | PING: %d ms",
            FPS, ping
        ))
    end
end)

-- ═══ THEME MANAGER ═══
if ThemeManager then
    pcall(function()
        ThemeManager:SetLibrary(Library)
        ThemeManager:SetFolder("TiarHub")
        if ThemeManager.SaveCustomTheme then
            ThemeManager:SaveCustomTheme({
                Name            = "TiarHub Blue",
                AccentColor     = Color3.fromRGB(30, 150, 255),
                BackgroundColor = Color3.fromRGB(10, 20, 40),
                MainColor       = Color3.fromRGB(20, 35, 65),
                OutlineColor    = Color3.fromRGB(0, 80, 180),
                FontColor       = Color3.fromRGB(220, 235, 255),
            })
        end
        ThemeManager:ApplyToTab(Tabs.Settings)
    end)
    print("[TIARHUB] ThemeManager configured")
end

-- ═══ SAVE MANAGER ═══
if SaveManager then
    pcall(function()
        SaveManager:SetLibrary(Library)
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetIgnoreIndexes({})
        SaveManager:SetFolder("TiarHub/configs")
        SaveManager:BuildConfigSection(Tabs.Settings)
    end)
    print("[TIARHUB] SaveManager configured")
end

-- ═══ ABOUT ═══
AboutBox:AddLabel("TIARHUB x Violence District")
AboutBox:AddLabel("Version : All-in-One")
AboutBox:AddLabel("Build   : 7 Tabs Modular")
AboutBox:AddDivider()

AboutBox:AddButton({
    Text = "❌ Unload Script",
    Func = function()
        pcall(function() Library:Unload() end)
    end,
})

AboutBox:AddDivider()
AboutBox:AddLabel("⌨️ RightShift = Toggle Menu")
AboutBox:AddLabel("⌨️ RightControl = Toggle (alt)")
AboutBox:AddLabel("⌨️ Q = Auto Parry")
AboutBox:AddLabel("⌨️ V = Moonwalk")
AboutBox:AddLabel("🖱️ Right Click = Aimlock")

-- ═══════════════════════════════════════════════════════════
--   EXTRA KEYBIND
-- ═══════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Library:Toggle()
    end
end)

-- ═══════════════════════════════════════════════════════════
--   STATS PANEL
-- ═══════════════════════════════════════════════════════════
local statsGui = Instance.new("ScreenGui")
statsGui.Name = "TiarHubStats"
statsGui.ResetOnSpawn = false
statsGui.Parent = PlayerGui

local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(0, 150, 0, 90)
statsFrame.Position = UDim2.new(1, -165, 0, 20)
statsFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
statsFrame.BackgroundTransparency = 0.2
statsFrame.BorderSizePixel = 0
statsFrame.Parent = statsGui

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 8)
sCorner.Parent = statsFrame

local sStroke = Instance.new("UIStroke")
sStroke.Color = Color3.fromRGB(30, 150, 255)
sStroke.Thickness = 1.5
sStroke.Transparency = 0.3
sStroke.Parent = statsFrame

local sTitle = Instance.new("TextLabel")
sTitle.Text = "STATS"
sTitle.Font = Enum.Font.GothamBlack
sTitle.TextSize = 12
sTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
sTitle.BackgroundTransparency = 1
sTitle.Size = UDim2.new(1, 0, 0, 18)
sTitle.Position = UDim2.new(0, 0, 0, 4)
sTitle.Parent = statsFrame

local sText = Instance.new("TextLabel")
sText.Font = Enum.Font.GothamBold
sText.TextSize = 12
sText.TextColor3 = Color3.fromRGB(220, 235, 255)
sText.BackgroundTransparency = 1
sText.Size = UDim2.new(1, -12, 1, -25)
sText.Position = UDim2.new(0, 8, 0, 24)
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
            local okPing, ping = pcall(function()
                return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            if not okPing then ping = 0 end
            local count = #Players:GetPlayers()
            sText.Text = string.format("FPS: %d\nPING: %d ms\nPLAYERS: %d", fps, ping, count)
        end
    end)
end)

-- ═══════════════════════════════════════════════════════════
--   CLEANUP
-- ═══════════════════════════════════════════════════════════
game:BindToClose(function()
    if SelfCircle then SelfCircle:Destroy() end
    if ParryCircle then ParryCircle:Destroy() end
    if ColorCorrection then ColorCorrection:Destroy() end
end)

-- ═══════════════════════════════════════════════════════════
--   FINAL NOTIFICATION
-- ═══════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(0.3)
    Watermark:SetText("TIARHUB | Loading...")
    Watermark.Visible = true
    notify("TIARHUB", "All features loaded ✓", 4)
    task.wait(1.5)
    notify("Tip", "RightShift = Toggle Menu", 4)
end)

-- ═══════════════════════════════════════════════════════════
--   FINAL PRINT
-- ═══════════════════════════════════════════════════════════
print("╔══════════════════════════════════════════════╗")
print("║   TIARHUB x VIOLENCE DISTRICT               ║")
print("║   ✅ Bagian A  — Setup & Window              ║")
print("║   ✅ Bagian B  — Combat                      ║")
print("║   ✅ Bagian C  — Visuals                     ║")
print("║   ✅ Bagian D  — Movement                    ║")
print("║   ✅ Bagian E  — Auto & Player               ║")
print("║   ✅ Bagian F  — Settings (FINAL)            ║")
print("║                                              ║")
print("║   🎮 RightShift = Toggle Menu                ║")
print("╚══════════════════════════════════════════════╝")

print("[TIARHUB] ALL PARTS LOADED — READY!")
