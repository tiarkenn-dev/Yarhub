-- =========================================================
-- ROOORHUB ULTIMATE FIRE EDITION v11
-- BAGIAN 1/8 : LOADING 4D + CONFIG + STATE
-- PARRY 360° + SKILL CHECK FIXED + LIGHTWEIGHT
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

local C = {
    BG = Color3.fromRGB(6, 4, 12),
    BG2 = Color3.fromRGB(10, 7, 20),
    PANEL = Color3.fromRGB(15, 10, 28),
    PANEL2 = Color3.fromRGB(22, 15, 40),
    ACC = Color3.fromRGB(180, 80, 255),
    ACC2 = Color3.fromRGB(0, 230, 255),
    ACC3 = Color3.fromRGB(255, 50, 180),
    ACC4 = Color3.fromRGB(255, 200, 50),
    GOLD = Color3.fromRGB(255, 215, 0),
    FIRE1 = Color3.fromRGB(255, 120, 0),
    FIRE2 = Color3.fromRGB(255, 220, 80),
    FIRE3 = Color3.fromRGB(255, 60, 0),
    FIRE_BRIGHT = Color3.fromRGB(255, 240, 150),
    TXT = Color3.fromRGB(245, 245, 255),
    DIM = Color3.fromRGB(120, 120, 160),
    GRN = Color3.fromRGB(0, 255, 150),
    RED = Color3.fromRGB(255, 70, 100),
}

local function rnd(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = o
end

local function strk(o, col, t, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or C.GOLD
    s.Thickness = t or 1.5
    s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = o
    return s
end

-- =========================================================
-- LOADING 4D FIRE RING (SIMPLE)
-- =========================================================
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "RoooorLoading"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 999999
loadingGui.Parent = PG

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BorderSizePixel = 0
bg.Parent = loadingGui

local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Size = UDim2.new(1, 0, 0, 70)
welcomeTitle.Position = UDim2.new(0, 0, 0.32, 0)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.Text = "SELAMAT DATANG"
welcomeTitle.TextColor3 = Color3.new(1, 1, 1)
welcomeTitle.TextSize = 48
welcomeTitle.Font = Enum.Font.GothamBlack
welcomeTitle.TextStrokeTransparency = 0
welcomeTitle.TextStrokeColor3 = C.FIRE3
welcomeTitle.Parent = bg

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 100)
subtitle.Position = UDim2.new(0, 0, 0.53, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "SC PENGANGGURAN"
subtitle.TextColor3 = C.FIRE2
subtitle.TextSize = 68
subtitle.Font = Enum.Font.GothamBlack
subtitle.TextStrokeTransparency = 0
subtitle.TextStrokeColor3 = C.FIRE3
subtitle.Parent = bg

local tagline = Instance.new("TextLabel")
tagline.Size = UDim2.new(1, 0, 0, 30)
tagline.Position = UDim2.new(0, 0, 0.73, 20)
tagline.BackgroundTransparency = 1
tagline.Text = "🔥 ULTIMATE FIRE v11 🔥"
tagline.TextColor3 = C.FIRE2
tagline.TextSize = 16
tagline.Font = Enum.Font.GothamBold
tagline.TextStrokeTransparency = 0.3
tagline.TextStrokeColor3 = C.FIRE3
tagline.Parent = bg

task.delay(2.5, function()
    TweenService:Create(bg, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    for _, el in pairs(bg:GetDescendants()) do
        pcall(function()
            if el:IsA("TextLabel") then
                TweenService:Create(el, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
            elseif el:IsA("Frame") then
                TweenService:Create(el, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
            end
        end)
    end
    task.wait(0.6)
    loadingGui:Destroy()
end)

-- =========================================================
-- STATE
-- =========================================================
_G.RoooorS = _G.RoooorS or {
    FireOn = false, FireType = "Classic", FireSize = 5,
    FireFeetOn = false, FireFeetType = "Classic",
    Parry = false, AntiFakeHit = false, DodgeRange = 15,
    AbyssDodge = false, ParryCircle = false, ParryCircleSize = 15,
    Skill = false, WalkSpeed = false, WalkSpeedVal = 16, WalkSpeedBoost = 0,
    SpeedHack = false, SpeedHackVal = 40, NoClip = false,
    Korblox = false, Headless = false,
    Killer_AutoAtk = false, Killer_AtkDelay = 0.35, Killer_KillAll = false,
    Killer_Hitbox = false, Killer_HitboxSize = 15, Killer_Hitbox_Visible = false,
    MaskedPower = "Cobra", FastVault = false, FastVaultSpeed = 1.5,
    AutoVault = false, InstantInteract = false,
    EightBitCrown = false, EightBitSize = 1, CrownX = 0, CrownY = 1.2, CrownZ = 0,
    Trail = false, TrailColor = Color3.fromRGB(255, 120, 0),
    Aura = false, AuraColor = Color3.fromRGB(255, 120, 0),
    KillEffect = false, Crosshair = false,
    CrosshairColor = Color3.fromRGB(0, 255, 200), CrosshairSize = 8,
    NoClipCamera = false, ZoomOut = false, ZoomOutValue = 500,
    RGBUI = false, Fullbright = false, FullbrightVal = 50, NoFog = false,
    UltraHD = false, Contrast = false, ContrastVal = 0.3, SaturationVal = 0.2,
    FOV = 70, FOVEnabled = false, SkyId = "Default",
    AutoHeal = false, AutoHealThreshold = 40, AutoRepair = false,
    AutoRevive = false, AutoDodge = false, AntiGrab = false, AntiHook = false,
    AntiBlind = false, AntiStun = false, AntiRagdoll = false, AntiSlow = false,
    AntiAFK = false, SafeZone = false,
    EscapeAlert = false, EscapeAlertRange = 60,
    TPtoPlayer = false, Fly = false, FlySpeed = 50,
    PlayerList = false, KillFeed = false, StunNotify = false,
}

local S = _G.RoooorS
_G.ToggleStates = _G.ToggleStates or {}
_G.SliderStates = _G.SliderStates or {}

-- ESP CONFIG
_G.Roooor_ESP = _G.Roooor_ESP or {
    Survivor = false, Killer = false, Generator = false,
    Pallet = false, Window = false, SCP = false, Distance = 50,
}

_G.Roooor_ESPStatus = _G.Roooor_ESPStatus or {
    Enabled = false, ShowName = true, ShowDistance = true,
    ShowHealth = false, Radius = 50,
}

_G.Roooor_TeamColors = _G.Roooor_TeamColors or {
    Killer = Color3.fromRGB(255, 60, 60),
    Survivor = Color3.fromRGB(60, 255, 120),
}

-- ✅ AUTO PARRY (360° - NO FACE CHECK)
_G.Roooor_AutoParry = _G.Roooor_AutoParry or {
    Enabled = false,
    ParryDistance = 20,
    AntiMiss = true,
    ParryDelay = 0.005,
    Cooldown = 0.2,
    Buffer = 10,
}

-- ✅ AUTO SKILL CHECK (INSTANT + PERFECT)
_G.Roooor_SkillCheck = _G.Roooor_SkillCheck or {
    Enabled = false,
    PerfectMode = false,
    SafeZone = 0.15,
}

-- AIMLOCK
_G.Roooor_AimlockBtn = _G.Roooor_AimlockBtn or {
    Enabled = true, ShowButton = false, Holding = false,
    Mode = "Killer", Radius = 500, LockRadius = 50, Strength = 0.4,
}

print("✅ [1/8] Loading + Config loaded")-- =========================================================
-- BAGIAN 2/8 : FIRE CONFIG + SKY + KILLER ANIMS
-- =========================================================
local FireList = {
    "Classic", "HellFire", "IceFire", "ToxicFire", "VoidFire",
    "GoldenKing", "SakuraFire", "EmeraldFire", "BloodFire", "ShadowFire",
    "HolyFire", "OceanFire", "Firework", "Lava", "GhostFire",
}

local FireConfig = {
    Classic = { c1 = Color3.fromRGB(255, 120, 0), c2 = Color3.fromRGB(255, 220, 80) },
    HellFire = { c1 = Color3.fromRGB(180, 0, 0), c2 = Color3.fromRGB(255, 80, 0), smoke = true },
    IceFire = { c1 = Color3.fromRGB(120, 200, 255), c2 = Color3.fromRGB(220, 240, 255), spark = true },
    ToxicFire = { c1 = Color3.fromRGB(0, 255, 50), c2 = Color3.fromRGB(180, 255, 0), smoke = true },
    VoidFire = { c1 = Color3.fromRGB(100, 0, 180), c2 = Color3.fromRGB(220, 50, 255), spark = true },
    GoldenKing = { c1 = Color3.fromRGB(255, 215, 0), c2 = Color3.fromRGB(255, 255, 120), spark = true },
    SakuraFire = { c1 = Color3.fromRGB(255, 150, 200), c2 = Color3.fromRGB(255, 220, 240), spark = true },
    EmeraldFire = { c1 = Color3.fromRGB(0, 220, 100), c2 = Color3.fromRGB(120, 255, 170) },
    BloodFire = { c1 = Color3.fromRGB(220, 0, 0), c2 = Color3.fromRGB(120, 0, 0), smoke = true },
    ShadowFire = { c1 = Color3.fromRGB(30, 30, 40), c2 = Color3.fromRGB(100, 0, 130), smoke = true },
    HolyFire = { c1 = Color3.fromRGB(255, 255, 255), c2 = Color3.fromRGB(255, 255, 220), spark = true },
    OceanFire = { c1 = Color3.fromRGB(0, 120, 255), c2 = Color3.fromRGB(120, 220, 255) },
    Firework = { c1 = Color3.fromRGB(255, 0, 120), c2 = Color3.fromRGB(255, 220, 50), rainbow = true, spark = true },
    Lava = { c1 = Color3.fromRGB(255, 100, 0), c2 = Color3.fromRGB(120, 30, 0), smoke = true },
    GhostFire = { c1 = Color3.fromRGB(200, 200, 255), c2 = Color3.fromRGB(255, 255, 255) },
}

for _, name in ipairs(FireList) do
    if not FireConfig[name] then FireConfig[name] = FireConfig.Classic end
end

local FireFeetList = {
    "Classic", "Blue", "Green", "Purple", "Rainbow", "Golden",
    "Pink", "Cyan", "RedFire", "Ice", "Toxic", "Electric",
}

local FireFeetConfig = {
    Classic = { c1 = Color3.fromRGB(255, 120, 0), c2 = Color3.fromRGB(255, 220, 80) },
    Blue = { c1 = Color3.fromRGB(0, 170, 255), c2 = Color3.fromRGB(0, 255, 255) },
    Green = { c1 = Color3.fromRGB(0, 255, 50), c2 = Color3.fromRGB(180, 255, 0) },
    Purple = { c1 = Color3.fromRGB(180, 0, 255), c2 = Color3.fromRGB(255, 0, 220) },
    Rainbow = { c1 = Color3.fromRGB(255, 0, 0), c2 = Color3.fromRGB(0, 255, 255), rainbow = true },
    Golden = { c1 = Color3.fromRGB(255, 215, 0), c2 = Color3.fromRGB(255, 255, 120) },
    Pink = { c1 = Color3.fromRGB(255, 120, 220), c2 = Color3.fromRGB(255, 200, 240) },
    Cyan = { c1 = Color3.fromRGB(0, 255, 255), c2 = Color3.fromRGB(120, 255, 255) },
    RedFire = { c1 = Color3.fromRGB(255, 40, 0), c2 = Color3.fromRGB(255, 120, 0) },
    Ice = { c1 = Color3.fromRGB(220, 240, 255), c2 = Color3.fromRGB(120, 200, 255) },
    Toxic = { c1 = Color3.fromRGB(0, 255, 120), c2 = Color3.fromRGB(120, 255, 0) },
    Electric = { c1 = Color3.fromRGB(255, 255, 120), c2 = Color3.fromRGB(120, 120, 255) },
}

for _, name in ipairs(FireFeetList) do
    if not FireFeetConfig[name] then FireFeetConfig[name] = FireFeetConfig.Classic end
end

local SkyList = { "Default", "Sunset", "Night", "Space", "Alien", "Purple", "Galaxy", "Void" }

local SkyIds = {
    Sunset = { Bk = "rbxassetid://169210149", Dn = "rbxassetid://169210108", Ft = "rbxassetid://169210121", Lf = "rbxassetid://169210133", Rt = "rbxassetid://169210143", Up = "rbxassetid://169210149" },
    Night = { Bk = "rbxassetid://18703245834", Dn = "rbxassetid://18703245834", Ft = "rbxassetid://18703245834", Lf = "rbxassetid://18703245834", Rt = "rbxassetid://18703245834", Up = "rbxassetid://18703245834" },
    Space = { Bk = "rbxassetid://17817511804", Dn = "rbxassetid://17817520184", Ft = "rbxassetid://17817511804", Lf = "rbxassetid://17817511804", Rt = "rbxassetid://17817511804", Up = "rbxassetid://17817511804" },
    Alien = { Bk = "rbxassetid://10253172001", Dn = "rbxassetid://10253172001", Ft = "rbxassetid://10253172001", Lf = "rbxassetid://10253172001", Rt = "rbxassetid://10253172001", Up = "rbxassetid://10253172001" },
    Purple = { Bk = "rbxassetid://6021017254", Dn = "rbxassetid://6021011228", Ft = "rbxassetid://6021017254", Lf = "rbxassetid://6021017254", Rt = "rbxassetid://6021017254", Up = "rbxassetid://6021017254" },
    Galaxy = { Bk = "rbxassetid://126146408999925", Dn = "rbxassetid://118112392224589", Ft = "rbxassetid://121253817183621", Lf = "rbxassetid://138429250948648", Rt = "rbxassetid://126146408999925", Up = "rbxassetid://126146408999925" },
    Void = { Bk = "rbxassetid://17817511804", Dn = "rbxassetid://17817520184", Ft = "rbxassetid://17817511804", Lf = "rbxassetid://17817511804", Rt = "rbxassetid://17817511804", Up = "rbxassetid://17817511804" },
}

-- ✅ KILLER ANIMS (FALLENS - 23 ID)
local KillerAnims = {}
for _, id in ipairs({
    "105374834496520","113255068724446","118907603246885","129784271201071",
    "117042998468241","122812055447896","78935059863801","74968262036854",
    "78432063483146","132817836308238","133963973694098","111920872708571",
    "80411309607666","98163597193511","82666958311998","110355011987939",
    "139369275981133","135002183282873","121216847022485","130593238885843",
    "117070354890871","106871536134254","138720291317243"
}) do
    KillerAnims["rbxassetid://"..id] = true
end

local function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

print("✅ [2/8] Fire + Sky + KillerAnims loaded")-- =========================================================
-- BAGIAN 3/8 : SEMUA FUNGSI + AUTO PARRY 360°
-- =========================================================

-- ============================
-- FIRE (KEPALA)
-- ============================
local function clearFire()
    if not LP.Character then return end
    local head = LP.Character:FindFirstChild("Head")
    if not head then return end
    for _, obj in pairs(head:GetChildren()) do
        if obj.Name == "RoooorFire" or obj.Name == "RoooorSmoke" or obj.Name == "RoooorSparkles" then
            obj:Destroy()
        end
    end
end

local function applyFire()
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
    fire.Heat = 15
    fire.Color = cfg.c1
    fire.SecondaryColor = cfg.c2
    fire.Parent = head

    if cfg.smoke then
        local smoke = Instance.new("Smoke")
        smoke.Name = "RoooorSmoke"
        smoke.Size = S.FireSize + 2
        smoke.RiseVelocity = 3
        smoke.Opacity = 0.4
        smoke.Color = cfg.c2
        smoke.Parent = head
    end

    if cfg.spark then
        local spark = Instance.new("Sparkles")
        spark.Name = "RoooorSparkles"
        spark.SparkleColor = cfg.c2
        spark.SparkleSize = 1
        spark.Parent = head
    end
end

local function clearFireFeet()
    if not LP.Character then return end
    local lLeg = LP.Character:FindFirstChild("Left Leg") or LP.Character:FindFirstChild("LeftUpperLeg")
    local rLeg = LP.Character:FindFirstChild("Right Leg") or LP.Character:FindFirstChild("RightUpperLeg")
    for _, leg in pairs({lLeg, rLeg}) do
        if leg then
            for _, obj in pairs(leg:GetChildren()) do
                if obj.Name == "RoooorFootFire" then obj:Destroy() end
            end
        end
    end
end

local function applyFireFeet()
    clearFireFeet()
    if not S.FireFeetOn then return end
    local char = LP.Character
    if not char then return end
    local lLeg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg")
    local rLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg")
    local cfg = FireFeetConfig[S.FireFeetType] or FireFeetConfig.Classic
    for _, leg in pairs({lLeg, rLeg}) do
        if leg then
            local fire = Instance.new("Fire")
            fire.Name = "RoooorFootFire"
            fire.Size = 4
            fire.Heat = 10
            fire.Color = cfg.c1
            fire.SecondaryColor = cfg.c2
            fire.Parent = leg
        end
    end
end

task.spawn(function()
    while task.wait(0.3) do
        if S.FireOn and LP.Character then
            local head = LP.Character:FindFirstChild("Head")
            local fire = head and head:FindFirstChild("RoooorFire")
            if fire then
                local cfg = FireConfig[S.FireType] or FireConfig.Classic
                if cfg.rainbow then
                    local t = tick()
                    fire.Color = Color3.fromHSV((t * 0.5) % 1, 1, 1)
                    fire.SecondaryColor = Color3.fromHSV(((t * 0.5) + 0.5) % 1, 1, 1)
                end
            end
        end
    end
end)

-- =========================================================
-- AUTO PARRY 360° (WORKS FROM ALL DIRECTIONS - FALLENS STYLE)
-- =========================================================
local AutoParry = _G.Roooor_AutoParry
local lastParry = 0
local hookedKillers = _G.HookedKillers or {}
_G.HookedKillers = hookedKillers
local ParryActive = false

local PARRY_DEBOUNCE = 0.2

local function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end

    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end

    local vel = enemyRoot.AssemblyLinearVelocity
    local predicted = enemyRoot.Position + (vel * 0.15)
    local distNow = (enemyRoot.Position - myRoot.Position).Magnitude
    local distPredict = (predicted - myRoot.Position).Magnitude
    local range = AutoParry.ParryDistance

    return distNow <= range or distPredict <= range
end

local function GetParryButton()
    local current = PG
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function pressRightClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
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

    task.delay(0.3, function()
        ParryActive = false
    end)
end

local function hookKiller(char)
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
        local fullId = "rbxassetid://" .. id
        if KillerAnims[fullId] then
            if isInParryRange(char) then
                doParry()
            end
        end
    end)
end

local function scanKillers()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
            hookKiller(p.Character)
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if AutoParry.Enabled then scanKillers() end
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if AutoParry.Enabled and p.Team and p.Team.Name == "Killer" then
            hookKiller(p.Character)
        end
    end)
end)

LP.CharacterAdded:Connect(function()
    task.wait(2)
    if AutoParry.Enabled then scanKillers() end
end)-- =========================================================
-- AUTO SKILL CHECK (INSTANT + PERFECT)
-- =========================================================
local SkillCheck = _G.Roooor_SkillCheck
local skillBusy = false
local ActionPath = "Survivor-mob.Controls.action.check"

local function GetActionButton()
    local current = PG
    for segment in string.gmatch(ActionPath, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function triggerSkillCheck()
    if skillBusy then return end
    skillBusy = true
    pcall(function()
        if UIS.TouchEnabled then
            local b = GetActionButton()
            if b and b:IsA("GuiObject") then
                local p, s, i = b.AbsolutePosition, b.AbsoluteSize, GuiService:GetGuiInset()
                local cx = p.X + s.X/2 + i.X
                local cy = p.Y + s.Y/2 + i.Y
                VirtualInputManager:SendTouchEvent(8822, 0, cx, cy)
                task.wait(0.01)
                VirtualInputManager:SendTouchEvent(8822, 2, cx, cy)
            end
        else
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.01)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end
    end)
    task.wait(0.05)
    skillBusy = false
end

task.spawn(function()
    while task.wait(0.01) do
        if not SkillCheck.Enabled then continue end

        local prompt = PG:FindFirstChild("SkillCheckPromptGui")
        if not prompt then continue end

        local check = prompt:FindFirstChild("Check")
        if not check or not check.Visible then continue end

        local line = check:FindFirstChild("Line")
        local goal = check:FindFirstChild("Goal")
        if not line or not goal then continue end

        if SkillCheck.PerfectMode then
            pcall(function()
                line.Rotation = goal.Rotation + 108
            end)
            triggerSkillCheck()
            continue
        end

        local lr = line.Rotation % 360
        local gr = goal.Rotation % 360
        local startZone = (gr + 102) % 360
        local endZone = (gr + 116) % 360

        local inZone = false
        if startZone > endZone then
            inZone = (lr >= startZone or lr <= endZone)
        else
            inZone = (lr >= startZone and lr <= endZone)
        end

        if not inZone then
            local distanceToZone = 0
            if startZone > endZone then
                if lr > endZone and lr < startZone then
                    distanceToZone = math.min(math.abs(lr - startZone), math.abs(lr - endZone))
                end
            else
                if lr < startZone then
                    distanceToZone = startZone - lr
                elseif lr > endZone then
                    distanceToZone = lr - endZone
                end
            end
            if distanceToZone > 0 and distanceToZone <= (SkillCheck.SafeZone * 360) then
                inZone = true
            end
        end

        if inZone and not skillBusy then
            triggerSkillCheck()
        end
    end
end)

-- =========================================================
-- ESP SYSTEM
-- =========================================================
local ESPObjects = {}
local StatusESP = {}
local CachedSCP = {}
local Cached = { Generators = {}, Windows = {}, Pallets = {} }

local GeneratorColor = Color3.fromRGB(255, 170, 0)
local PalletColor = Color3.fromRGB(74, 255, 181)
local WindowColor = Color3.fromRGB(74, 255, 181)
local SCPColor = Color3.fromRGB(255, 0, 0)

local ESP = _G.Roooor_ESP
local ESPStatus = _G.Roooor_ESPStatus
local TeamColors = _G.Roooor_TeamColors

local function cacheObject(obj)
    if obj.Name == "Generator" then Cached.Generators[obj] = true
    elseif obj.Name == "Window" then Cached.Windows[obj] = true
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then Cached.Pallets[obj] = true end

    local name = string.lower(obj.Name)
    if string.find(name, "scp") then CachedSCP[obj] = true end
end

local function removeCache(obj)
    Cached.Generators[obj] = nil
    Cached.Windows[obj] = nil
    Cached.Pallets[obj] = nil
    CachedSCP[obj] = nil
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
end

for _, obj in ipairs(workspace:GetDescendants()) do cacheObject(obj) end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(removeCache)

local function createESP(obj, color)
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
        if not parent then
            if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
        end
    end)
end

local function removeESP(obj)
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj] = nil end
end

local function removeStatusESP(char)
    if StatusESP[char] then StatusESP[char]:Destroy(); StatusESP[char] = nil end
end

local function createStatusESP(player, char, root)
    if not ESPStatus.Enabled then removeStatusESP(char); return end
    if not root then return end

    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    local isDown = hum.Health <= 0 or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true

    local dist = (head.Position - root.Position).Magnitude
    if dist > ESPStatus.Radius then removeStatusESP(char); return end

    local text = ""
    if isDown then text = text .. "🔻 DOWN\n" end
    if ESPStatus.ShowName then text = text .. player.Name .. "\n" end
    if ESPStatus.ShowDistance then text = text .. string.format("Dist: %.0f\n", dist) end
    if ESPStatus.ShowHealth then text = text .. string.format("HP: %.0f\n", hum.Health) end
    if text == "" then removeStatusESP(char); return end

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

local function GetGameValue(obj, name)
    if not obj then return nil end
    local attr = obj:GetAttribute(name)
    if attr ~= nil then return attr end
    local child = obj:FindFirstChild(name)
    if child then
        local success, val = pcall(function() return child.Value end)
        if success then return val end
    end
    return nil
end

local function UpdateGenerator(generator)
    if not generator or not generator.Parent then return end
    if not ESP.Generator then
        local old = generator:FindFirstChild("GenESP")
        if old then old:Destroy() end
        local h = generator:FindFirstChild("GenHighlight")
        if h then h:Destroy() end
        return
    end
    local percent = GetGameValue(generator, "RepairProgress") or GetGameValue(generator, "Progress") or 0
    local billboard = generator:FindFirstChild("GenESP")
    if percent >= 100 then
        if billboard then billboard:Destroy() end
        return
    end
    local cp = math.clamp(percent, 0, 100)
    local color = GeneratorColor:Lerp(Color3.fromRGB(0, 255, 120), cp / 100)
    local text = string.format("[%.0f%%]", percent)

    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "GenESP"
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.AlwaysOnTop = true
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = color
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.Parent = billboard
        billboard.Adornee = generator
        billboard.Parent = generator
    else
        local lbl = billboard:FindFirstChildOfClass("TextLabel")
        if lbl then
            lbl.Text = text
            lbl.TextColor3 = color
        end
    end

    local h = generator:FindFirstChild("GenHighlight") or Instance.new("Highlight")
    h.Name = "GenHighlight"
    h.Adornee = generator
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.9
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = generator
end

local function UpdateMapESP(obj, root)
    if not obj or not root then return end
    local pos
    if obj:IsA("Model") then pos = obj:GetPivot().Position
    elseif obj:IsA("BasePart") then pos = obj.Position end
    if not pos then return end
    local distance = (pos - root.Position).Magnitude

    if obj.Name == "Window" then
        if ESP.Window and distance <= ESP.Distance then createESP(obj, WindowColor)
        else removeESP(obj) end
    end
    if obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        if ESP.Pallet and distance <= ESP.Distance then createESP(obj, PalletColor)
        else removeESP(obj) end
    end
end

local function UpdateSCPEsp(root)
    if not ESP.SCP then
        for obj in pairs(CachedSCP) do removeESP(obj) end
        return
    end
    for obj in pairs(CachedSCP) do
        if obj and obj.Parent then
            local pos
            if obj:IsA("Model") then pos = obj:GetPivot().Position
            elseif obj:IsA("BasePart") then pos = obj.Position end
            if pos then
                local dist = (pos - root.Position).Magnitude
                if dist <= ESP.Distance then createESP(obj, SCPColor)
                else removeESP(obj) end
            end
        end
    end
end

print("✅ [3/8] Auto Parry 360° + Auto Skill Check + ESP loaded")-- =========================================================
-- BAGIAN 4/8 : FITUR BARU + LOOP UTAMA (LIGHTWEIGHT)
-- =========================================================

-- AUTO HEAL
task.spawn(function()
    while task.wait(0.5) do
        if S.AutoHeal and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and hum.Health < S.AutoHealThreshold then
                pcall(function()
                    local backpack = LP:FindFirstChild("Backpack")
                    if backpack then
                        for _, item in pairs(backpack:GetChildren()) do
                            if item:IsA("Tool") and (string.find(string.lower(item.Name), "medkit")
                                or string.find(string.lower(item.Name), "bandage")
                                or string.find(string.lower(item.Name), "heal")) then
                                local hum2 = LP.Character:FindFirstChildOfClass("Humanoid")
                                if hum2 then
                                    hum2:EquipTool(item)
                                    task.wait(0.1)
                                    item:Activate()
                                    task.wait(0.3)
                                    if item.Parent == LP.Character then hum2:UnequipTools() end
                                end
                                break
                            end
                        end
                    end
                end)
            end
        end
    end
end)

-- AUTO REPAIR
task.spawn(function()
    while task.wait(0.5) do
        if S.AutoRepair and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, obj in pairs(Cached.Generators) do
                    if obj and obj.Parent then
                        local pos = obj:IsA("Model") and obj:GetPivot().Position or (obj:IsA("BasePart") and obj.Position)
                        if pos and (pos - myRoot.Position).Magnitude <= 15 then
                            pcall(function()
                                local prompt = obj:FindFirstChildOfClass("ProximityPrompt", true)
                                if prompt then prompt:InputHoldBegin() end
                            end)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- AUTO REVIVE
task.spawn(function()
    while task.wait(1) do
        if S.AutoRevive and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Survivors" then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health <= 0 then
                            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and (hrp.Position - myRoot.Position).Magnitude <= 10 then
                                pcall(function()
                                    local prompt = p.Character:FindFirstChildOfClass("ProximityPrompt", true)
                                    if prompt then
                                        prompt:InputHoldBegin()
                                        task.wait(0.1)
                                        prompt:InputHoldEnd()
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- AUTO DODGE
task.spawn(function()
    while task.wait(0.2) do
        if S.AutoDodge and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                local closest, shortest = nil, S.DodgeRange or 30
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                        local krp = p.Character:FindFirstChild("HumanoidRootPart")
                        if krp then
                            local d = (krp.Position - myRoot.Position).Magnitude
                            if d < shortest then shortest = d; closest = krp end
                        end
                    end
                end
                if closest then
                    local dir = (myRoot.Position - closest.Position).Unit
                    local hum = LP.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum:Move(dir * 5, false) end
                end
            end
        end
    end
end)

-- AUTO DODGE ABYSS
task.spawn(function()
    while task.wait(0.1) do
        if S.AbyssDodge and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local killerName = string.lower(p.Name)
                        local charName = string.lower(p.Character.Name)
                        local teamName = p.Team and string.lower(p.Team.Name) or ""
                        local isAbyss = string.find(killerName, "abyss") or string.find(charName, "abyss") or string.find(teamName, "abyss")
                        if isAbyss then
                            local krp = p.Character:FindFirstChild("HumanoidRootPart")
                            local khum = p.Character:FindFirstChildOfClass("Humanoid")
                            if krp and khum then
                                local kanim = khum:FindFirstChildOfClass("Animator")
                                if kanim then
                                    for _, track in ipairs(kanim:GetPlayingAnimationTracks()) do
                                        local a = track.Animation
                                        if a and a.AnimationId then
                                            local id = a.AnimationId:match("%d+")
                                            if id and KillerAnims["rbxassetid://"..id] then
                                                local dist = (krp.Position - myRoot.Position).Magnitude
                                                if dist <= 20 then
                                                    local hum = LP.Character:FindFirstChildOfClass("Humanoid")
                                                    if hum then
                                                        pcall(function()
                                                            hum:ChangeState(Enum.HumanoidStateType.PlatformStanding)
                                                            task.wait(0.05)
                                                            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                                                        end)
                                                    end
                                                end
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- INSTANT INTERACT
task.spawn(function()
    while task.wait(0.3) do
        if S.InstantInteract and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        local parent = obj.Parent
                        local pos
                        if parent:IsA("BasePart") then pos = parent.Position
                        elseif parent:IsA("Model") then pos = parent:GetPivot().Position end
                        if pos and (pos - myRoot.Position).Magnitude <= 12 then
                            pcall(function()
                                obj:InputHoldBegin()
                                task.wait(0.05)
                                obj:InputHoldEnd()
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- AUTO VAULT
task.spawn(function()
    while task.wait(0.3) do
        if S.AutoVault and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, obj in pairs(Cached.Windows) do
                    if obj and obj.Parent then
                        local pos = obj:IsA("Model") and obj:GetPivot().Position or (obj:IsA("BasePart") and obj.Position)
                        if pos and (pos - myRoot.Position).Magnitude <= 8 then
                            pcall(function()
                                local prompt = obj:FindFirstChildOfClass("ProximityPrompt", true)
                                if prompt then
                                    prompt:InputHoldBegin()
                                    task.wait(0.05)
                                    prompt:InputHoldEnd()
                                end
                            end)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- ANTI GRAB
task.spawn(function()
    while task.wait(0.2) do
        if S.AntiGrab and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, v in pairs(hrp:GetChildren()) do
                    if v:IsA("WeldConstraint") or v:IsA("Weld") or v:IsA("Motor6D") then
                        local part1 = v.Part1 or v.Part0
                        if part1 and not part1:IsDescendantOf(LP.Character) then
                            v:Destroy()
                        end
                    end
                end
            end
        end
    end
end)

-- ANTI HOOK
task.spawn(function()
    while task.wait(0.2) do
        if S.AntiHook and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.AssemblyLinearVelocity.Magnitude > 200 then
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

-- ANTI BLIND
task.spawn(function()
    while task.wait(0.4) do
        if S.AntiBlind then
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("BlurEffect") then v.Size = 0 end
            end
            local cam = workspace.CurrentCamera
            if cam then
                for _, v in pairs(cam:GetChildren()) do
                    if v:IsA("BlurEffect") then v:Destroy() end
                end
            end
        end
    end
end)

-- ANTI SYSTEM GABUNGAN
task.spawn(function()
    while task.wait(0.2) do
        if not LP.Character then continue end
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if not hum then continue end

        if S.AntiStun then
            if hum.WalkSpeed == 0 and S.WalkSpeed then hum.WalkSpeed = S.WalkSpeedVal end
            if hum.PlatformStand then hum.PlatformStand = false end
        end
        if S.AntiRagdoll then
            if hum.PlatformStand then hum.PlatformStand = false end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
        if S.AntiSlow then
            if hum.WalkSpeed < 10 then hum.WalkSpeed = S.WalkSpeed and S.WalkSpeedVal or 16 end
        end
    end
end)

-- ANTI AFK
task.spawn(function()
    while task.wait(60) do
        if S.AntiAFK then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end
    end
end)-- SPEED HACK
task.spawn(function()
    while task.wait(0.2) do
        if S.SpeedHack and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= S.SpeedHackVal then
                hum.WalkSpeed = S.SpeedHackVal
            end
        end
    end
end)

-- WALK SPEED
task.spawn(function()
    while task.wait(0.2) do
        if S.WalkSpeed and not S.SpeedHack and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local target = S.WalkSpeedVal + (S.WalkSpeedBoost or 0)
                if hum.WalkSpeed ~= target then
                    hum.WalkSpeed = target
                end
            end
        end
    end
end)

-- SAFE ZONE
task.spawn(function()
    while task.wait(0.5) do
        if S.SafeZone and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                local nearKiller = math.huge
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                        local krp = p.Character:FindFirstChild("HumanoidRootPart")
                        if krp then
                            local d = (krp.Position - myRoot.Position).Magnitude
                            if d < nearKiller then nearKiller = d end
                        end
                    end
                end
                if nearKiller < 50 then
                    local warn = PG:FindFirstChild("RoooorWarn")
                    if not warn then
                        warn = Instance.new("Frame")
                        warn.Name = "RoooorWarn"
                        warn.Size = UDim2.new(1, 0, 0, 6)
                        warn.Position = UDim2.new(0, 0, 0, 0)
                        warn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        warn.BorderSizePixel = 0
                        warn.Parent = PG
                    end
                    warn.BackgroundTransparency = 0.3
                    task.delay(0.3, function()
                        if warn then warn.BackgroundTransparency = 1 end
                    end)
                end
            end
        end
    end
end)

-- ESCAPE ALERT
task.spawn(function()
    while task.wait(0.5) do
        if S.EscapeAlert and LP.Character then
            local myRoot = getRoot()
            if myRoot then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                        local krp = p.Character:FindFirstChild("HumanoidRootPart")
                        if krp and (krp.Position - myRoot.Position).Magnitude <= S.EscapeAlertRange then
                            local al = PG:FindFirstChild("RoooorAlert")
                            if not al then
                                al = Instance.new("TextLabel")
                                al.Name = "RoooorAlert"
                                al.Size = UDim2.new(0, 300, 0, 40)
                                al.Position = UDim2.new(0.5, -150, 0, 100)
                                al.BackgroundTransparency = 0.3
                                al.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                                al.TextColor3 = Color3.fromRGB(255, 50, 50)
                                al.TextSize = 20
                                al.Font = Enum.Font.GothamBlack
                                al.Text = "⚠️ KILLER DEKET! ⚠️"
                                al.TextStrokeTransparency = 0
                                al.Parent = PG
                                rnd(al, 10)
                            end
                            al.Visible = true
                            task.delay(0.8, function()
                                if al then al.Visible = false end
                            end)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- KILL FEED KHUSUS KILLER
local killFeedGui = Instance.new("ScreenGui")
killFeedGui.Name = "RoooorKillFeed"
killFeedGui.ResetOnSpawn = false
killFeedGui.IgnoreGuiInset = true
killFeedGui.Parent = PG

local killFeedFrame = Instance.new("Frame")
killFeedFrame.Size = UDim2.new(0, 250, 0, 200)
killFeedFrame.Position = UDim2.new(1, -260, 0, 50)
killFeedFrame.BackgroundTransparency = 1
killFeedFrame.Parent = killFeedGui

local killFeedLayout = Instance.new("UIListLayout")
killFeedLayout.Padding = UDim.new(0, 4)
killFeedLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
killFeedLayout.Parent = killFeedFrame

local function addKillFeed(killerName, survivorName)
    if not S.KillFeed then return end
    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1, 0, 0, 28)
    entry.BackgroundColor3 = Color3.fromRGB(30, 10, 5)
    entry.BackgroundTransparency = 0.2
    entry.BorderSizePixel = 0
    entry.Parent = killFeedFrame
    rnd(entry, 6)
    strk(entry, C.RED, 1, 0.5)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 1, 0)
    lbl.Position = UDim2.new(0, 5, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "💀 " .. killerName .. " ➜ " .. survivorName
    lbl.TextColor3 = Color3.fromRGB(255, 100, 100)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = entry
    task.spawn(function()
        task.wait(4)
        TweenService:Create(entry, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(lbl, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        task.wait(0.6)
        entry:Destroy()
    end)
end

task.spawn(function()
    local lastHealth = {}
    while task.wait(0.5) do
        if not S.KillFeed then continue end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    local prevHP = lastHealth[p] or hum.Health
                    if prevHP > 0 and hum.Health <= 0 then
                        local killerName = "???"
                        if p:GetAttribute("LastAttacker") then killerName = p:GetAttribute("LastAttacker") end
                        addKillFeed(killerName, p.Name)
                    end
                    lastHealth[p] = hum.Health
                end
            end
        end
    end
end)

-- NOTIFIKASI KILLER STUN
local stunIcons = {}
local function createStunIcon(killerChar)
    if stunIcons[killerChar] then return stunIcons[killerChar] end
    local head = killerChar:FindFirstChild("Head")
    if not head then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RoooorStunIcon"
    billboard.Size = UDim2.new(0, 60, 0, 60)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.Adornee = head
    billboard.Parent = head
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "💫"
    icon.TextColor3 = Color3.fromRGB(255, 255, 100)
    icon.TextSize = 40
    icon.Font = Enum.Font.GothamBlack
    icon.TextStrokeTransparency = 0
    icon.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    icon.Parent = billboard
    stunIcons[killerChar] = billboard
    return billboard
end

local function removeStunIcon(killerChar)
    if stunIcons[killerChar] then stunIcons[killerChar]:Destroy() stunIcons[killerChar] = nil end
end

task.spawn(function()
    while task.wait(0.3) do
        if not S.StunNotify then continue end
        local myRoot = getRoot()
        if not myRoot then continue end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                local krp = p.Character:FindFirstChild("HumanoidRootPart")
                if krp then
                    local dist = (krp.Position - myRoot.Position).Magnitude
                    if dist <= 80 then
                        local isStunned = false
                        local khum = p.Character:FindFirstChildOfClass("Humanoid")
                        if khum then
                            local animator = khum:FindFirstChildOfClass("Animator")
                            if animator then
                                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                    local a = track.Animation
                                    if a and a.AnimationId then
                                        local id = a.AnimationId:match("%d+")
                                        if id == "123047897844134" then isStunned = true break end
                                    end
                                end
                            end
                        end
                        if isStunned then createStunIcon(p.Character)
                        else removeStunIcon(p.Character) end
                    else removeStunIcon(p.Character) end
                end
            end
        end
    end
end)

-- KILLER: AUTO ATTACK
local lastAtk = 0
task.spawn(function()
    while task.wait(0.2) do
        if S.Killer_AutoAtk then
            local now = tick()
            if now - lastAtk >= (S.Killer_AtkDelay or 0.35) then
                lastAtk = now
                pcall(function()
                    local r = ReplicatedStorage:FindFirstChild("Remotes")
                    if r then
                        local a = r:FindFirstChild("Attacks")
                        if a then
                            local atk = a:FindFirstChild("BasicAttack")
                            if atk then atk:FireServer(false) end
                        end
                    end
                end)
            end
        end
    end
end)

-- KILLER KILL ALL
task.spawn(function()
    while task.wait(0.4) do
        if S.Killer_KillAll and LP.Character then
            local myHum = LP.Character:FindFirstChildOfClass("Humanoid")
            if not myHum or myHum.Health <= 0 then continue end
            local isCarried = LP.Character:GetAttribute("IsCarried") or LP.Character:GetAttribute("IsCarrying")
                or LP.Character:GetAttribute("Hooked") or LP.Character:GetAttribute("Hook")
            if isCarried then continue end

            local myRoot = getRoot()
            if not myRoot then continue end
            local myPos = myRoot.Position
            local closest, shortest = nil, 60

            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Team and p.Team.Name == "Survivors" then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local survivorHooked = p.Character:GetAttribute("Hooked")
                            or p.Character:GetAttribute("IsCarried")
                            or p.Character:GetAttribute("IsHooked")
                        if survivorHooked then continue end
                        if hrp.Position.Y > 30 then continue end
                        local dist = (hrp.Position - myPos).Magnitude
                        if dist < shortest then shortest = dist closest = hrp end
                    end
                end
            end

            if closest then
                local targetPos = closest.Position + (closest.AssemblyLinearVelocity * 0.15)
                local behind = closest.CFrame.LookVector * -3
                local newPos = targetPos + behind
                pcall(function()
                    myRoot.CFrame = CFrame.new(newPos, targetPos)
                    myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end)
                pcall(function()
                    local r = ReplicatedStorage:FindFirstChild("Remotes")
                    if r then
                        local a = r:FindFirstChild("Attacks")
                        if a then
                            local atk = a:FindFirstChild("BasicAttack")
                            if atk then atk:FireServer(false) end
                        end
                    end
                end)
            end
        end
    end
end)

-- HITBOX
local hitboxCache = {}
task.spawn(function()
    while task.wait(0.5) do
        if S.Killer_Hitbox then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Team and p.Team.Name == "Survivors" then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local isCarried = p.Character:GetAttribute("IsCarried")
                            or p.Character:GetAttribute("Carried")
                            or p.Character:GetAttribute("Hooked")
                            or p.Character:FindFirstChild("CarriedBy")
                        if isCarried then continue end
                        local part = p.Character:FindFirstChild("HumanoidRootPart")
                        if part then
                            if not hitboxCache[part] then
                                hitboxCache[part] = {
                                    Size = part.Size, Transparency = part.Transparency,
                                    Material = part.Material, Color = part.Color, CanCollide = part.CanCollide
                                }
                            end
                            local size = S.Killer_HitboxSize or 15
                            part.Size = Vector3.new(size, size, size)
                            part.CanCollide = false
                            part.Transparency = 1
                        end
                    end
                end
            end
        else
            for part, orig in pairs(hitboxCache) do
                if part and part.Parent then
                    part.Size = orig.Size
                    part.Transparency = orig.Transparency
                    part.CanCollide = orig.CanCollide
                    part.Material = orig.Material
                    part.Color = orig.Color
                end
                hitboxCache[part] = nil
            end
        end
    end
end)

-- PARRY CIRCLE
_G.Roooor_ParryCircle = nil
local function updateParryCircle()
    local root = getRoot()
    if not S.ParryCircle or not root then
        if _G.Roooor_ParryCircle then
            _G.Roooor_ParryCircle:Destroy()
            _G.Roooor_ParryCircle = nil
        end
        return
    end
    if not _G.Roooor_ParryCircle then
        _G.Roooor_ParryCircle = Instance.new("Part")
        _G.Roooor_ParryCircle.Shape = Enum.PartType.Cylinder
        _G.Roooor_ParryCircle.Anchored = true
        _G.Roooor_ParryCircle.CanCollide = false
        _G.Roooor_ParryCircle.Material = Enum.Material.Neon
        _G.Roooor_ParryCircle.Name = "RoooorParryCircle"
        _G.Roooor_ParryCircle.Parent = workspace
    end
    local size = (S.ParryCircleSize or 15) * 2
    _G.Roooor_ParryCircle.Size = Vector3.new(0.1, size, size)
    local yOffset = root.Size.Y / 2 + 1.5
    _G.Roooor_ParryCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0))
        * CFrame.Angles(0, 0, math.rad(90))
    _G.Roooor_ParryCircle.Color = C.FIRE2
    _G.Roooor_ParryCircle.Transparency = 0.5
end

RunService.RenderStepped:Connect(function()
    if S.ParryCircle then updateParryCircle() end
end)

-- MAIN ESP LOOP
local lastESPUpdate = 0
RunService.Heartbeat:Connect(function()
    local root = getRoot()
    if not root then return end
    local now = tick()
    if now - lastESPUpdate >= 0.08 then
        lastESPUpdate = now
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local char = p.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local distance = (hrp.Position - root.Position).Magnitude
                        if distance <= ESP.Distance then
                            if ESP.Survivor and p.Team and p.Team.Name == "Survivors" then
                                createESP(char, TeamColors.Survivor)
                            elseif ESP.Killer and p.Team and p.Team.Name == "Killer" then
                                createESP(char, TeamColors.Killer)
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
                end
            end
        end
        if ESP.Generator then
            for gen in pairs(Cached.Generators) do UpdateGenerator(gen) end
        end
        for obj in pairs(Cached.Windows) do UpdateMapESP(obj, root) end
        for obj in pairs(Cached.Pallets) do UpdateMapESP(obj, root) end
        UpdateSCPEsp(root)
    end
end)

-- KILL EFFECT LOOP
task.spawn(function()
    while task.wait(0.8) do
        if S.KillEffect then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health <= 0 then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and not p.Character:GetAttribute("RoooorKillEffect") then
                            p.Character:SetAttribute("RoooorKillEffect", true)
                            local ef = Instance.new("Part")
                            ef.Anchored = true; ef.CanCollide = false
                            ef.Material = Enum.Material.Neon
                            ef.Shape = Enum.PartType.Ball
                            ef.Size = Vector3.new(2, 2, 2)
                            ef.Position = hrp.Position
                            ef.Color = Color3.fromRGB(255, 50, 50)
                            ef.Transparency = 0.3
                            ef.Parent = workspace
                            TweenService:Create(ef, TweenInfo.new(0.5), {Size = Vector3.new(15, 15, 15), Transparency = 1}):Play()
                            task.delay(0.6, function() ef:Destroy() end)
                        end
                    else
                        if p.Character:GetAttribute("RoooorKillEffect") then
                            p.Character:SetAttribute("RoooorKillEffect", false)
                        end
                    end
                end
            end
        end
    end
end)

-- NO CLIP CAMERA
task.spawn(function()
    while task.wait(0.2) do
        local cam = workspace.CurrentCamera
        if cam then cam.CanCollide = not S.NoClipCamera end
    end
end)

print("✅ [4/8] Fitur baru + Loop utama loaded (LIGHTWEIGHT)")-- =========================================================
-- BAGIAN 5/8 : GUI + KOMPONEN + TOMBOL R + AIMLOCK
-- =========================================================
local gui = Instance.new("ScreenGui")
gui.Name = "RoooorHubFire"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PG

-- =========================================================
-- TOMBOL MENU "R" 4D (BISA DIGESER)
-- =========================================================
local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(0, 42, 0, 42)
btnContainer.Position = UDim2.new(0, 15, 0.3, 0)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = gui

-- Ring 1 (outer)
local ring1 = Instance.new("Frame")
ring1.Size = UDim2.new(1, 8, 1, 8)
ring1.Position = UDim2.new(0, -4, 0, -4)
ring1.BackgroundTransparency = 1
ring1.Parent = btnContainer

local ring1Stroke = Instance.new("UIStroke")
ring1Stroke.Thickness = 2
ring1Stroke.Color = C.FIRE_BRIGHT
ring1Stroke.Transparency = 0.1
ring1Stroke.Parent = ring1

local ring1Grad = Instance.new("UIGradient")
ring1Grad.Color = ColorSequence.new(C.FIRE3, C.FIRE_BRIGHT, C.FIRE1, C.FIRE2, C.FIRE3)
ring1Grad.Parent = ring1Stroke

-- Ring 2
local ring2 = Instance.new("Frame")
ring2.Size = UDim2.new(1, 4, 1, 4)
ring2.Position = UDim2.new(0, -2, 0, -2)
ring2.BackgroundTransparency = 1
ring2.Parent = btnContainer

local ring2Stroke = Instance.new("UIStroke")
ring2Stroke.Thickness = 1.2
ring2Stroke.Color = C.FIRE2
ring2Stroke.Transparency = 0.3
ring2Stroke.Parent = ring2

-- Ring 3
local ring3 = Instance.new("Frame")
ring3.Size = UDim2.new(1, -8, 1, -8)
ring3.Position = UDim2.new(0, 4, 0, 4)
ring3.BackgroundTransparency = 1
ring3.Parent = btnContainer

local ring3Stroke = Instance.new("UIStroke")
ring3Stroke.Thickness = 0.8
ring3Stroke.Color = C.FIRE1
ring3Stroke.Transparency = 0.5
ring3Stroke.Parent = ring3

-- Main button (HURUF R)
local mainBtn = Instance.new("TextButton")
mainBtn.Size = UDim2.new(1, -12, 1, -12)
mainBtn.Position = UDim2.new(0, 6, 0, 6)
mainBtn.BackgroundColor3 = Color3.fromRGB(40, 12, 4)
mainBtn.Text = "R"
mainBtn.TextColor3 = C.FIRE_BRIGHT
mainBtn.TextSize = 22
mainBtn.Font = Enum.Font.GothamBlack
mainBtn.BorderSizePixel = 0
mainBtn.AutoButtonColor = false
mainBtn.Parent = btnContainer
rnd(mainBtn, 999)

local btnGrad = Instance.new("UIGradient")
btnGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 25, 5)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 12, 4)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 25, 5)),
})
btnGrad.Rotation = 45
btnGrad.Parent = mainBtn

local glow = Instance.new("Frame")
glow.Size = UDim2.new(1, 16, 1, 16)
glow.Position = UDim2.new(0, -8, 0, -8)
glow.BackgroundColor3 = C.FIRE_BRIGHT
glow.BackgroundTransparency = 0.5
glow.BorderSizePixel = 0
glow.ZIndex = -1
glow.Parent = mainBtn
rnd(glow, 999)

local innerGlow = Instance.new("Frame")
innerGlow.Size = UDim2.new(0.6, 0, 0.6, 0)
innerGlow.Position = UDim2.new(0.2, 0, 0.2, 0)
innerGlow.BackgroundColor3 = C.FIRE1
innerGlow.BackgroundTransparency = 0.4
innerGlow.BorderSizePixel = 0
innerGlow.ZIndex = -1
innerGlow.Parent = mainBtn
rnd(innerGlow, 999)

-- Animasi
task.spawn(function()
    local t = 0
    while btnContainer.Parent do
        t = t + 0.03
        ring1.Rotation = t * 60
        ring1Grad.Rotation = t * 120
        ring2.Rotation = -t * 90
        ring3.Rotation = t * 40
        local pulse = (math.sin(t * 4) + 1) / 2
        glow.BackgroundTransparency = 0.75 - pulse * 0.4
        glow.Size = UDim2.new(1, 10 + pulse * 12, 1, 10 + pulse * 12)
        glow.Position = UDim2.new(0, -5 - pulse * 6, 0, -5 - pulse * 6)
        innerGlow.BackgroundTransparency = 0.3 - pulse * 0.2
        btnGrad.Rotation = t * 40
        mainBtn.TextSize = 22 + math.sin(t * 5) * 2
        mainBtn.TextColor3 = Color3.fromHSV((t * 0.15) % 1, 0.9, 1)
        task.wait(0.03)
    end
end)

-- Partikel orbit
for i = 1, 10 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, 3, 0, 3)
    particle.BackgroundColor3 = C.FIRE_BRIGHT
    particle.BorderSizePixel = 0
    particle.Parent = btnContainer
    rnd(particle, 999)
    local angle = (i / 10) * math.pi * 2
    local orbitSpeed = 2 + math.random() * 2
    local radius = 26 + math.random() * 6
    task.spawn(function()
        while btnContainer.Parent do
            local t = tick()
            local x = math.cos(t * orbitSpeed + angle) * radius
            local y = math.sin(t * orbitSpeed + angle) * radius * 0.6
            particle.Position = UDim2.new(0.5, x - 1.5, 0.5, y - 1.5)
            particle.BackgroundTransparency = 0.1 + math.sin(t * 5 + i) * 0.3
            particle.BackgroundColor3 = Color3.fromHSV((t * 0.4 + i * 0.07) % 1, 0.9, 1)
            task.wait(0.03)
        end
    end)
end

-- DRAG MENU "R"
local dragging = false
local dragStart = nil
local startPos = nil
local wasDragged = false

btnContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        wasDragged = false
        dragStart = input.Position
        startPos = btnContainer.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then wasDragged = true end
        btnContainer.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)-- =========================================================
-- PANEL (MENU UTAMA)
-- =========================================================
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 480, 0, 400)
panel.Position = UDim2.new(0.5, -240, 0.5, -200)
panel.BackgroundColor3 = C.BG
panel.BackgroundTransparency = 0.05
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = gui
rnd(panel, 18)
strk(panel, C.FIRE2, 2, 0.2)

local panelGrad = Instance.new("UIGradient")
panelGrad.Color = ColorSequence.new(C.BG, C.BG2, C.BG)
panelGrad.Rotation = 45
panelGrad.Parent = panel

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 46)
header.BackgroundColor3 = C.PANEL
header.BackgroundTransparency = 0.1
header.BorderSizePixel = 0
header.Parent = panel
rnd(header, 18)

local hPatch = Instance.new("Frame")
hPatch.Size = UDim2.new(1, 0, 0, 23)
hPatch.Position = UDim2.new(0, 0, 1, -23)
hPatch.BackgroundColor3 = C.PANEL
hPatch.BackgroundTransparency = 0.1
hPatch.BorderSizePixel = 0
hPatch.Parent = header

local neonLine = Instance.new("Frame")
neonLine.Size = UDim2.new(1, -40, 0, 3)
neonLine.Position = UDim2.new(0, 20, 1, -1.5)
neonLine.BackgroundColor3 = C.FIRE_BRIGHT
neonLine.BorderSizePixel = 0
neonLine.Parent = header

local neonGrad = Instance.new("UIGradient")
neonGrad.Color = ColorSequence.new(C.FIRE3, C.FIRE_BRIGHT, Color3.fromRGB(255, 255, 240), C.FIRE_BRIGHT, C.FIRE3)
neonGrad.Parent = neonLine

task.spawn(function()
    while neonLine.Parent do
        for i = 0, 1, 0.03 do
            if not neonLine.Parent then break end
            neonGrad.Rotation = i * 360
            task.wait(0.06)
        end
    end
end)

local hTitle = Instance.new("TextLabel")
hTitle.Size = UDim2.new(1, -100, 1, 0)
hTitle.Position = UDim2.new(0, 18, 0, 0)
hTitle.BackgroundTransparency = 1
hTitle.Text = "🔥 ROOORHUB ULTIMATE v11"
hTitle.TextColor3 = C.FIRE_BRIGHT
hTitle.TextSize = 14
hTitle.Font = Enum.Font.GothamBlack
hTitle.TextXAlignment = Enum.TextXAlignment.Left
hTitle.TextStrokeTransparency = 0.2
hTitle.TextStrokeColor3 = C.FIRE3
hTitle.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0.5, -13)
closeBtn.BackgroundColor3 = C.PANEL2
closeBtn.Text = "✕"
closeBtn.TextColor3 = C.RED
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = header
rnd(closeBtn, 7)
strk(closeBtn, C.RED, 1, 0.5)

-- SIDEBAR
local sbFrame = Instance.new("Frame")
sbFrame.Size = UDim2.new(0, 122, 1, -66)
sbFrame.Position = UDim2.new(0, 12, 0, 58)
sbFrame.BackgroundColor3 = C.PANEL
sbFrame.BackgroundTransparency = 0.2
sbFrame.BorderSizePixel = 0
sbFrame.Parent = panel
rnd(sbFrame, 12)
strk(sbFrame, C.FIRE2, 1, 0.6)

local sb = Instance.new("ScrollingFrame")
sb.Size = UDim2.new(1, -4, 1, -4)
sb.Position = UDim2.new(0, 2, 0, 2)
sb.BackgroundTransparency = 1
sb.BorderSizePixel = 0
sb.ScrollBarThickness = 3
sb.ScrollBarImageColor3 = C.FIRE2
sb.CanvasSize = UDim2.new(0, 0, 0, 0)
sb.AutomaticCanvasSize = Enum.AutomaticSize.Y
sb.Parent = sbFrame

local sbL = Instance.new("UIListLayout")
sbL.Padding = UDim.new(0, 4)
sbL.Parent = sb

local sbP = Instance.new("UIPadding")
sbP.PaddingTop = UDim.new(0, 6)
sbP.PaddingLeft = UDim.new(0, 4)
sbP.PaddingRight = UDim.new(0, 4)
sbP.PaddingBottom = UDim.new(0, 6)
sbP.Parent = sb

-- CONTENT
local ct = Instance.new("Frame")
ct.Size = UDim2.new(1, -152, 1, -66)
ct.Position = UDim2.new(0, 142, 0, 58)
ct.BackgroundColor3 = C.PANEL
ct.BackgroundTransparency = 0.2
ct.BorderSizePixel = 0
ct.Parent = panel
rnd(ct, 12)
strk(ct, C.FIRE2, 1, 0.6)

local cs = Instance.new("ScrollingFrame")
cs.Size = UDim2.new(1, -16, 1, -16)
cs.Position = UDim2.new(0, 8, 0, 8)
cs.BackgroundTransparency = 1
cs.BorderSizePixel = 0
cs.ScrollBarThickness = 3
cs.ScrollBarImageColor3 = C.FIRE2
cs.CanvasSize = UDim2.new(0, 0, 0, 0)
cs.AutomaticCanvasSize = Enum.AutomaticSize.Y
cs.Parent = ct

local csL = Instance.new("UIListLayout")
csL.Padding = UDim.new(0, 5)
csL.Parent = cs-- =========================================================
-- AIMLOCK FLOATING BUTTON
-- =========================================================
local aimBtnGui = Instance.new("ScreenGui")
aimBtnGui.Name = "RoooorAimlockBtn"
aimBtnGui.ResetOnSpawn = false
aimBtnGui.IgnoreGuiInset = true
aimBtnGui.Parent = PG

local aimContainer = Instance.new("Frame")
aimContainer.Size = UDim2.new(0, 46, 0, 46)
aimContainer.Position = UDim2.new(0, 15, 0.4, 0)
aimContainer.BackgroundTransparency = 1
aimContainer.Parent = aimBtnGui

local aimOuterRing = Instance.new("Frame")
aimOuterRing.Size = UDim2.new(1, 6, 1, 6)
aimOuterRing.Position = UDim2.new(0, -3, 0, -3)
aimOuterRing.BackgroundTransparency = 1
aimOuterRing.Parent = aimContainer

local aimOuterStroke = Instance.new("UIStroke")
aimOuterStroke.Thickness = 2
aimOuterStroke.Color = C.ACC2
aimOuterStroke.Transparency = 0.1
aimOuterStroke.Parent = aimOuterRing

local aimOuterGrad = Instance.new("UIGradient")
aimOuterGrad.Color = ColorSequence.new(C.ACC, C.ACC2, C.ACC3)
aimOuterGrad.Parent = aimOuterStroke

local aimInnerRing = Instance.new("Frame")
aimInnerRing.Size = UDim2.new(1, -2, 1, -2)
aimInnerRing.Position = UDim2.new(0, 1, 0, 1)
aimInnerRing.BackgroundTransparency = 1
aimInnerRing.Parent = aimContainer

local aimInnerStroke = Instance.new("UIStroke")
aimInnerStroke.Thickness = 1
aimInnerStroke.Color = C.ACC2
aimInnerStroke.Transparency = 0.3
aimInnerStroke.Parent = aimInnerRing

local aimBtn = Instance.new("TextButton")
aimBtn.Size = UDim2.new(1, -8, 1, -8)
aimBtn.Position = UDim2.new(0, 4, 0, 4)
aimBtn.BackgroundColor3 = Color3.fromRGB(15, 25, 45)
aimBtn.Text = "🎯"
aimBtn.TextColor3 = C.ACC2
aimBtn.TextSize = 22
aimBtn.Font = Enum.Font.GothamBlack
aimBtn.BorderSizePixel = 0
aimBtn.AutoButtonColor = false
aimBtn.Parent = aimContainer
rnd(aimBtn, 999)

local aimBtnGrad = Instance.new("UIGradient")
aimBtnGrad.Color = ColorSequence.new(Color3.fromRGB(20, 40, 80), Color3.fromRGB(15, 25, 50), Color3.fromRGB(20, 40, 80))
aimBtnGrad.Rotation = 45
aimBtnGrad.Parent = aimBtn

local aimGlow = Instance.new("Frame")
aimGlow.Size = UDim2.new(1, 16, 1, 16)
aimGlow.Position = UDim2.new(0, -8, 0, -8)
aimGlow.BackgroundColor3 = C.ACC2
aimGlow.BackgroundTransparency = 0.6
aimGlow.BorderSizePixel = 0
aimGlow.ZIndex = -1
aimGlow.Parent = aimBtn
rnd(aimGlow, 999)

local aimModeLbl = Instance.new("TextLabel")
aimModeLbl.Size = UDim2.new(0, 100, 0, 14)
aimModeLbl.Position = UDim2.new(0.5, -50, 1, 2)
aimModeLbl.BackgroundTransparency = 1
aimModeLbl.Text = "KILLER"
aimModeLbl.TextColor3 = C.ACC4
aimModeLbl.TextSize = 9
aimModeLbl.Font = Enum.Font.GothamBlack
aimModeLbl.TextStrokeTransparency = 0.3
aimModeLbl.Parent = aimBtn

local Aimlock = _G.Roooor_AimlockBtn

task.spawn(function()
    local t = 0
    while aimContainer.Parent do
        t = t + 0.03
        aimOuterRing.Rotation = t * 60
        aimOuterGrad.Rotation = t * 100
        aimInnerRing.Rotation = -t * 90
        local pulse = (math.sin(t * 4) + 1) / 2
        local baseTrans = Aimlock.Holding and 0.3 or 0.7
        aimGlow.BackgroundTransparency = baseTrans - pulse * 0.25
        local glowSize = Aimlock.Holding and 20 or 16
        aimGlow.Size = UDim2.new(1, glowSize + pulse * 8, 1, glowSize + pulse * 8)
        aimGlow.Position = UDim2.new(0, -(glowSize/2) - pulse * 4, 0, -(glowSize/2) - pulse * 4)
        aimBtnGrad.Rotation = t * 40
        task.wait(0.03)
    end
end)

-- DRAG AIMLOCK
local aimDragging, aimDS, aimDP, aimWasDragged = false, nil, nil, false

aimContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        aimDragging = true; aimWasDragged = false
        aimDS = input.Position; aimDP = aimContainer.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if aimDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - aimDS
        if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then aimWasDragged = true end
        aimContainer.Position = UDim2.new(
            aimDP.X.Scale, aimDP.X.Offset + d.X,
            aimDP.Y.Scale, aimDP.Y.Offset + d.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        aimDragging = false
    end
end)

-- HOLD TO AIM
aimBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        if aimWasDragged then return end
        Aimlock.Holding = true
        aimBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
    end
end)

aimBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        Aimlock.Holding = false
        aimBtn.BackgroundColor3 = Color3.fromRGB(15, 25, 45)
    end
end)

aimBtn.MouseButton2Click:Connect(function()
    if Aimlock.Mode == "Killer" then
        Aimlock.Mode = "Survivor"
        aimModeLbl.Text = "SURVIVOR"
        aimModeLbl.TextColor3 = C.GRN
    else
        Aimlock.Mode = "Killer"
        aimModeLbl.Text = "KILLER"
        aimModeLbl.TextColor3 = C.ACC4
    end
end)

-- SHOW/HIDE AIMLOCK
_G.Roooor_setAimlockVisible = function(visible)
    if aimBtnGui then aimBtnGui.Enabled = visible end
end

task.spawn(function()
    task.wait(0.5)
    if _G.Roooor_setAimlockVisible then
        _G.Roooor_setAimlockVisible(_G.Roooor_AimlockBtn.ShowButton)
    end
end)

-- AIMLOCK LOOP
task.spawn(function()
    while aimContainer.Parent do
        task.wait(0.03)
        if not Aimlock.Holding then continue end
        local myRoot = getRoot()
        if not myRoot then continue end

        local closest, shortest = nil, Aimlock.Radius
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local valid = false
                if Aimlock.Mode == "Killer" and p.Team and p.Team.Name == "Killer" then valid = true
                elseif Aimlock.Mode == "Survivor" and p.Team and p.Team.Name == "Survivors" then valid = true end

                if valid then
                    local hrp = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local dist = (hrp.Position - myRoot.Position).Magnitude
                        if dist < shortest then shortest = dist closest = hrp end
                    end
                end
            end
        end

        if closest and shortest <= Aimlock.LockRadius then
            local cam = workspace.CurrentCamera
            local targetCF = CFrame.new(cam.CFrame.Position, closest.Position)
            cam.CFrame = cam.CFrame:Lerp(targetCF, Aimlock.Strength)
        end
    end
end)-- KOMPONEN UI
local function sec(title, icon)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 24)
    f.BackgroundTransparency = 1
    f.Parent = cs

    local deco = Instance.new("Frame")
    deco.Size = UDim2.new(0, 4, 0, 16)
    deco.Position = UDim2.new(0, 4, 0.5, -8)
    deco.BackgroundColor3 = C.FIRE2
    deco.BorderSizePixel = 0
    deco.Parent = f
    rnd(deco, 2)

    local decoGrad = Instance.new("UIGradient")
    decoGrad.Color = ColorSequence.new(C.FIRE1, C.FIRE_BRIGHT, C.FIRE3)
    decoGrad.Parent = deco

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 1, 0)
    l.Position = UDim2.new(0, 16, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = icon .. " " .. string.upper(title)
    l.TextColor3 = C.FIRE_BRIGHT
    l.TextSize = 10
    l.Font = Enum.Font.GothamBlack
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
end

local function lbl(text, color)
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

local function tog(name, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 30)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    local fStrk = strk(f, C.FIRE2, 1, 0.7)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -55, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local t = Instance.new("Frame")
    t.Size = UDim2.new(0, 34, 0, 18)
    t.Position = UDim2.new(1, -44, 0.5, -9)
    t.BorderSizePixel = 0
    t.Parent = f
    rnd(t, 9)

    local k = Instance.new("Frame")
    k.Size = UDim2.new(0, 12, 0, 12)
    k.BorderSizePixel = 0
    k.Parent = t
    rnd(k, 6)

    local saved = _G.ToggleStates[name]
    local state = (saved ~= nil) and saved or def
    _G.ToggleStates[name] = state

    t.BackgroundColor3 = state and C.FIRE1 or C.PANEL
    k.Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    k.BackgroundColor3 = state and C.FIRE_BRIGHT or C.DIM

    local cB = Instance.new("TextButton")
    cB.Size = UDim2.new(1, 0, 1, 0)
    cB.BackgroundTransparency = 1
    cB.Text = ""
    cB.Parent = t

    cB.MouseButton1Click:Connect(function()
        state = not state
        _G.ToggleStates[name] = state
        TweenService:Create(k, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
            BackgroundColor3 = state and C.FIRE_BRIGHT or C.DIM
        }):Play()
        TweenService:Create(t, TweenInfo.new(0.2), {BackgroundColor3 = state and C.FIRE1 or C.PANEL}):Play()
        fStrk.Color = state and C.FIRE_BRIGHT or C.FIRE3
        if cb then pcall(cb, state) end
    end)
end

local function sl(name, min, max, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 40)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.FIRE2, 1, 0.7)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -60, 0, 16)
    l.Position = UDim2.new(0, 10, 0, 4)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = C.TXT
    l.TextSize = 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local curVal = _G.SliderStates[name] or def
    _G.SliderStates[name] = curVal

    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0, 40, 0, 16)
    v.Position = UDim2.new(1, -50, 0, 4)
    v.BackgroundTransparency = 1
    v.Text = tostring(curVal)
    v.TextColor3 = C.FIRE_BRIGHT
    v.TextSize = 10
    v.Font = Enum.Font.GothamBold
    v.TextXAlignment = Enum.TextXAlignment.Right
    v.Parent = f

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -24, 0, 5)
    bg.Position = UDim2.new(0, 12, 1, -13)
    bg.BackgroundColor3 = C.PANEL
    bg.BorderSizePixel = 0
    bg.Parent = f
    rnd(bg, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((curVal - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = C.FIRE_BRIGHT
    fill.BorderSizePixel = 0
    fill.Parent = bg
    rnd(fill, 3)

    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 12, 0, 12)
    kn.Position = UDim2.new((curVal - min) / (max - min), -6, 0.5, -6)
    kn.BackgroundColor3 = C.TXT
    kn.BorderSizePixel = 0
    kn.ZIndex = 2
    kn.Parent = bg
    rnd(kn, 6)
    strk(kn, C.FIRE_BRIGHT, 2)

    local drag = false

    local function upd(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local val = math.floor((min + (max - min) * pos) * 100 + 0.5) / 100
        _G.SliderStates[name] = val
        fill.Size = UDim2.new(pos, 0, 1, 0)
        kn.Position = UDim2.new(pos, -6, 0.5, -6)
        v.Text = tostring(val)
        if cb then pcall(cb, val) end
    end

    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            drag = true; upd(input)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            upd(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
end-- =========================================================
-- BAGIAN 6/8 : TAB UI PART 1
-- =========================================================

-- ============================
-- TAB: FIRE
-- ============================
makeTab("Fire", "🔥", 1, function()
    sec("Fire Control", "⚙️")
    tog("Enable Fire", false, function(s) S.FireOn = s; applyFire() end)
    sl("Fire Size", 1, 15, 5, function(v) S.FireSize = v; applyFire() end)

    sec("Pilih Efek Fire", "🔥")
    lbl("Klik efek untuk ganti", C.FIRE_BRIGHT)

    for i, fireName in ipairs(FireList) do
        local btn2 = Instance.new("TextButton")
        btn2.Size = UDim2.new(1, -4, 0, 26)
        btn2.BackgroundColor3 = C.BG
        btn2.BackgroundTransparency = 0.4
        btn2.BorderSizePixel = 0
        btn2.Text = ""
        btn2.AutoButtonColor = false
        btn2.LayoutOrder = i + 100
        btn2.Parent = cs
        rnd(btn2, 7)
        strk(btn2, C.FIRE2, 1, 0.6)

        local btnLbl = Instance.new("TextLabel")
        btnLbl.Size = UDim2.new(1, -10, 1, 0)
        btnLbl.Position = UDim2.new(0, 10, 0, 0)
        btnLbl.BackgroundTransparency = 1
        btnLbl.Text = "🔥 " .. fireName
        btnLbl.TextColor3 = C.TXT
        btnLbl.TextSize = 10
        btnLbl.Font = Enum.Font.GothamMedium
        btnLbl.TextXAlignment = Enum.TextXAlignment.Left
        btnLbl.Parent = btn2

        if S.FireType == fireName then
            btn2.BackgroundColor3 = C.FIRE2
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(0.1, 0.1, 0.1)
        end

        btn2.MouseButton1Click:Connect(function()
            S.FireType = fireName
            applyFire()
            for _, c in pairs(cs:GetChildren()) do
                if c:IsA("TextButton") and c.LayoutOrder > 100 and c.LayoutOrder < 200 then
                    c.BackgroundColor3 = C.BG
                    c.BackgroundTransparency = 0.4
                    local l = c:FindFirstChildOfClass("TextLabel")
                    if l then l.TextColor3 = C.TXT end
                end
            end
            btn2.BackgroundColor3 = C.FIRE2
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(0.1, 0.1, 0.1)
        end)
    end
end)

-- ============================
-- TAB: FIRE FEET
-- ============================
makeTab("Fire Feet", "👟", 2, function()
    sec("Fire Feet Control", "👟")
    tog("Enable Fire Feet", false, function(s) S.FireFeetOn = s; applyFireFeet() end)

    sec("Pilih Efek Fire Feet", "🔥")
    lbl("Klik efek untuk ganti", C.FIRE_BRIGHT)

    for i, fireName in ipairs(FireFeetList) do
        local btn2 = Instance.new("TextButton")
        btn2.Size = UDim2.new(1, -4, 0, 26)
        btn2.BackgroundColor3 = C.BG
        btn2.BackgroundTransparency = 0.4
        btn2.BorderSizePixel = 0
        btn2.Text = ""
        btn2.AutoButtonColor = false
        btn2.LayoutOrder = i + 200
        btn2.Parent = cs
        rnd(btn2, 7)
        strk(btn2, C.FIRE2, 1, 0.6)

        local btnLbl = Instance.new("TextLabel")
        btnLbl.Size = UDim2.new(1, -10, 1, 0)
        btnLbl.Position = UDim2.new(0, 10, 0, 0)
        btnLbl.BackgroundTransparency = 1
        btnLbl.Text = "👟 " .. fireName
        btnLbl.TextColor3 = C.TXT
        btnLbl.TextSize = 10
        btnLbl.Font = Enum.Font.GothamMedium
        btnLbl.TextXAlignment = Enum.TextXAlignment.Left
        btnLbl.Parent = btn2

        if S.FireFeetType == fireName then
            btn2.BackgroundColor3 = C.FIRE2
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(0.1, 0.1, 0.1)
        end

        btn2.MouseButton1Click:Connect(function()
            S.FireFeetType = fireName
            applyFireFeet()
            for _, c in pairs(cs:GetChildren()) do
                if c:IsA("TextButton") and c.LayoutOrder > 200 and c.LayoutOrder < 300 then
                    c.BackgroundColor3 = C.BG
                    c.BackgroundTransparency = 0.4
                    local l = c:FindFirstChildOfClass("TextLabel")
                    if l then l.TextColor3 = C.TXT end
                end
            end
            btn2.BackgroundColor3 = C.FIRE2
            btn2.BackgroundTransparency = 0
            btnLbl.TextColor3 = Color3.new(0.1, 0.1, 0.1)
        end)
    end
end)

-- ============================
-- TAB: ESP
-- ============================
makeTab("ESP", "👁️", 3, function()
    sec("Player ESP", "🟢")
    tog("ESP Survivor", false, function(s) ESP.Survivor = s end)
    cpk("Survivor Color", TeamColors.Survivor, function(c) TeamColors.Survivor = c end)
    tog("ESP Killer", false, function(s) ESP.Killer = s end)
    cpk("Killer Color", TeamColors.Killer, function(c) TeamColors.Killer = c end)

    sec("Object ESP", "⚡")
    tog("ESP Generator", false, function(s) ESP.Generator = s end)
    cpk("Gen Color", GeneratorColor, function(c) GeneratorColor = c end)
    tog("ESP Pallet", false, function(s) ESP.Pallet = s end)
    cpk("Pallet Color", PalletColor, function(c) PalletColor = c end)
    tog("ESP Window", false, function(s) ESP.Window = s end)
    cpk("Window Color", WindowColor, function(c) WindowColor = c end)
    tog("ESP SCP", false, function(s) ESP.SCP = s end)
    cpk("SCP Color", SCPColor, function(c) SCPColor = c end)

    sec("ESP Distance", "📏")
    sl("ESP Radius", 10, 300, 50, function(v) ESP.Distance = v end)
    lbl("Max 300 (limited biar fokus)", C.GRN)

    sec("Status ESP", "🟢")
    tog("Enable Status ESP", false, function(s) ESPStatus.Enabled = s end)
    tog("Show Name", true, function(s) ESPStatus.ShowName = s end)
    tog("Show Distance", true, function(s) ESPStatus.ShowDistance = s end)
    tog("Show Health", false, function(s) ESPStatus.ShowHealth = s end)
    sl("Status Radius", 20, 200, 50, function(v) ESPStatus.Radius = v end)
end)local function cpk(name, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 30)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.FIRE2, 1, 0.7)

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
    strk(cB, C.FIRE_BRIGHT, 1.5)

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
        cB.BackgroundColor3 = presets[idx]
        if cb then pcall(cb, presets[idx]) end
    end)
end

local function btn(name, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -4, 0, 30)
    b.BackgroundColor3 = C.BG
    b.BackgroundTransparency = 0.4
    b.Text = name
    b.TextColor3 = C.TXT
    b.TextSize = 10
    b.Font = Enum.Font.GothamMedium
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = cs
    rnd(b, 8)
    strk(b, C.FIRE_BRIGHT, 1, 0.7)

    b.MouseButton1Click:Connect(function()
        if cb then pcall(cb) end
    end)
end

local function drp(name, options, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 30)
    f.BackgroundColor3 = C.BG
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.Parent = cs
    rnd(f, 8)
    strk(f, C.FIRE2, 1, 0.7)

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

    local idx = 1
    for i, o in ipairs(options) do
        if o == def then idx = i end
    end
    local cur = options[idx]

    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0.5, -26, 1, 0)
    v.Position = UDim2.new(0.5, 0, 0, 0)
    v.BackgroundTransparency = 1
    v.Text = tostring(cur) .. " ▶"
    v.TextColor3 = C.FIRE_BRIGHT
    v.TextSize = 9
    v.Font = Enum.Font.GothamBold
    v.TextXAlignment = Enum.TextXAlignment.Right
    v.Parent = f

    local cB = Instance.new("TextButton")
    cB.Size = UDim2.new(1, 0, 1, 0)
    cB.BackgroundTransparency = 1
    cB.Text = ""
    cB.Parent = f

    cB.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then idx = 1 end
        cur = options[idx]
        v.Text = tostring(cur) .. " ▶"
        if cb then pcall(cb, cur) end
    end)
end

-- =========================================================
-- TAB SYSTEM
-- =========================================================
local activeTab = nil

local function makeTab(name, icon, order, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 30)
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
    ind.BackgroundColor3 = C.FIRE_BRIGHT
    ind.BorderSizePixel = 0
    ind.Parent = b
    rnd(ind, 2)

    local ico = Instance.new("TextLabel")
    ico.Size = UDim2.new(0, 22, 1, 0)
    ico.Position = UDim2.new(0, 7, 0, 0)
    ico.BackgroundTransparency = 1
    ico.Text = icon
    ico.TextColor3 = C.DIM
    ico.TextSize = 14
    ico.Font = Enum.Font.GothamBold
    ico.Parent = b

    local lblT = Instance.new("TextLabel")
    lblT.Size = UDim2.new(1, -28, 1, 0)
    lblT.Position = UDim2.new(0, 30, 0, 0)
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
            local oldInd = activeTab:FindFirstChildOfClass("Frame")
            if oldInd then
                TweenService:Create(oldInd, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 0)}):Play()
            end
            for _, c in pairs(activeTab:GetChildren()) do
                if c:IsA("TextLabel") then
                    TweenService:Create(c, TweenInfo.new(0.2), {TextColor3 = C.DIM}):Play()
                end
            end
        end

        activeTab = b
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
        TweenService:Create(ind, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 3, 0, 20)}):Play()
        for _, c in pairs(b:GetChildren()) do
            if c:IsA("TextLabel") then
                TweenService:Create(c, TweenInfo.new(0.2), {TextColor3 = C.TXT}):Play()
            end
        end

        for _, c in pairs(cs:GetChildren()) do
            if not c:IsA("UIListLayout") then
                c:Destroy()
            end
        end

        if cb then pcall(cb) end
    end)
end

-- EVENT: Buka/Tutup Panel
mainBtn.MouseButton1Click:Connect(function()
    if wasDragged then wasDragged = false; return end
    panel.Visible = not panel.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
end)

print("✅ [5/8] GUI + Komponen + Tombol R + Aimlock loaded")-- ============================
-- TAB: SURVIVOR (AUTO PARRY 360° + AUTO SKILL CHECK)
-- ============================
makeTab("Survivor", "🏃", 4, function()
    sec("Auto Parry 360° (SEMUA ARAH)", "🛡️")
    tog("Enable Auto Parry", false, function(s)
        AutoParry.Enabled = s
        if s then scanKillers() end
    end)
    sl("Parry Distance", 5, 30, 20, function(v)
        AutoParry.ParryDistance = v
    end)

    sec("Auto Skill Check", "⚡")
    tog("Enable Auto Skill Check", false, function(s)
        SkillCheck.Enabled = s
    end)
    tog("Perfect Skill Check Mode", false, function(s)
        SkillCheck.PerfectMode = s
        if s then SkillCheck.Enabled = true end
    end)
    sl("Safe Zone", 0, 1, 0.15, function(v)
        SkillCheck.SafeZone = v
    end)

    sec("Parry Circle Visual", "🎯")
    tog("Show Parry Circle", false, function(s)
        S.ParryCircle = s
    end)
    sl("Parry Circle Size", 5, 50, 15, function(v)
        S.ParryCircleSize = v
    end)

    sec("Auto Wiggle", "🐛")
    tog("Enable Auto Wiggle", false, function(s)
        S.AutoWiggle = s
    end)
    sl("Wiggle Spam", 1, 20, 5, function(v)
        S.WiggleSpam = v
    end)

    sec("Auto Flee Killer", "🏃")
    tog("Enable Auto Flee", false, function(s)
        S.AutoFlee = s
    end)
    sl("Detect Distance", 20, 100, 50, function(v)
        S.DodgeRange = v
    end)

    sec("Survivor Utility", "⚙️")
    tog("Anti KnockDown (GodMode)", false, function(s)
        S.GodMode = s
    end)
    tog("Auto Heal", false, function(s)
        S.AutoHeal = s
    end)
    sl("Heal Threshold", 10, 90, 40, function(v)
        S.AutoHealThreshold = v
    end)
    tog("Auto Repair Generator", false, function(s)
        S.AutoRepair = s
    end)
    tog("Auto Revive Teammate", false, function(s)
        S.AutoRevive = s
    end)
    tog("Fast Vault", false, function(s)
        S.FastVault = s
    end)
    sl("Vault Speed", 1, 5, 1.5, function(v)
        S.FastVaultSpeed = v
    end)
    tog("Instant Interact", false, function(s)
        S.InstantInteract = s
    end)
    tog("Auto Vault", false, function(s)
        S.AutoVault = s
    end)

    sec("Anti System", "🛡️")
    tog("Anti Grab", false, function(s) S.AntiGrab = s end)
    tog("Anti Hook", false, function(s) S.AntiHook = s end)
    tog("Anti Blind", false, function(s) S.AntiBlind = s end)
    tog("Anti Stun", false, function(s) S.AntiStun = s end)
    tog("Anti Ragdoll", false, function(s) S.AntiRagdoll = s end)
    tog("Anti Slow", false, function(s) S.AntiSlow = s end)
    tog("Anti AFK", false, function(s) S.AntiAFK = s end)

    sec("Escape & Alert", "🚨")
    tog("Safe Zone Warning", false, function(s) S.SafeZone = s end)
    tog("Escape Alert", false, function(s) S.EscapeAlert = s end)
    sl("Escape Alert Range", 20, 200, 60, function(v) S.EscapeAlertRange = v end)

    sec("Auto Dodge Abyss", "🌀")
    tog("Auto Dodge Abyss Slash", false, function(s) S.AbyssDodge = s end)
    lbl("Auto jongkok pas Abyss slash", C.GRN)

    sec("Teleport", "🚀")
    btn("⚡ Teleport ke Finish Line", function()
        teleportToFinishLine()
    end)
    btn("🚪 Teleport ke Gate", function()
        teleportToGate()
    end)
    btn("🏠 Teleport Inside Gate", function()
        teleportInsideGate()
    end)
end)-- ============================
-- TAB: VISUAL
-- ============================
makeTab("Visual", "✨", 7, function()
    sec("Lighting", "💡")
    tog("Fullbright", false, function(s)
        S.Fullbright = s
        if S.Fullbright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        end
    end)
    sl("Fullbright Value", 0, 100, 50, function(v)
        S.FullbrightVal = v
    end)
    tog("No Fog", false, function(s)
        S.NoFog = s
        if s then
            Lighting.FogEnd = 9e9
            Lighting.FogStart = 9e9
        end
    end)
    tog("Ultra HD", false, function(s)
        S.UltraHD = s
    end)
    tog("Contrast", false, function(s)
        S.Contrast = s
    end)
    sl("Contrast Value", 0, 1, 0.3, function(v)
        S.ContrastVal = v
    end)
    sl("Saturation Value", 0, 1, 0.2, function(v)
        S.SaturationVal = v
    end)

    sec("Sky", "🌌")
    drp("Select Sky", SkyList, "Default", function(v)
        S.SkyId = v
    end)

    sec("Ambient", "🌈")
    sl("Brightness", 0, 5, 2, function(v)
        Lighting.Brightness = v
    end)
    sl("Clock Time", 0, 24, 14, function(v)
        Lighting.ClockTime = v
    end)
end)

-- ============================
-- TAB: INFO
-- ============================
makeTab("Info", "ℹ️", 8, function()
    sec("Script Info", "📜")
    lbl("Script: RoooorHub Ultimate v11", C.FIRE_BRIGHT)
    lbl("Edition: Fire Edition", C.TXT)
    lbl("Version: 11.0.0", C.TXT)
    lbl("Game: Violence District", C.TXT)

    sec("Credits", "👑")
    lbl("Developer: Roooor", C.FIRE_BRIGHT)
    lbl("Patched by: Fallens Fix", C.GRN)
    lbl("Parry: 360° Full Work", C.GRN)
    lbl("Skill Check: Instant + Perfect", C.GRN)

    sec("Links", "🔗")
    btn("📋 Copy Discord Link", function()
        setclipboard("https://discord.gg/3kmTx8Aeew")
    end)
end)

-- ============================
-- TAB: UI SETTINGS
-- ============================
makeTab("UI Settings", "⚙️", 9, function()
    sec("Menu", "🖥️")
    tog("Watermark", true, function(v)
        local wm = PG:FindFirstChild("RoooorWatermark")
        if wm then wm.Visible = v end
    end)

    sec("Aimlock Button", "🎯")
    tog("Show Aimlock Button", false, function(v)
        _G.Roooor_AimlockBtn.ShowButton = v
        if _G.Roooor_setAimlockVisible then
            _G.Roooor_setAimlockVisible(v)
        end
    end)

    sec("Config", "💾")
    btn("💾 Save Config", function()
        local cfg = {}
        for k, v in pairs(S) do
            if type(v) ~= "function" and type(v) ~= "table" then
                cfg[k] = v
            end
        end
        pcall(function()
            if writefile then
                writefile("RoooorHub_Config.json", game:GetService("HttpService"):JSONEncode(cfg))
                print("[RoooorHub] Config saved!")
            end
        end)
    end)
    btn("📂 Load Config", function()
        pcall(function()
            if readfile and isfile and isfile("RoooorHub_Config.json") then
                local data = game:GetService("HttpService"):JSONDecode(readfile("RoooorHub_Config.json"))
                for k, v in pairs(data) do
                    if S[k] ~= nil then S[k] = v end
                end
                print("[RoooorHub] Config loaded!")
            end
        end)
    end)

    sec("Unload", "🚪")
    btn("❌ Unload Script", function()
        pcall(function()
            if loadingGui then loadingGui:Destroy() end
            if gui then gui:Destroy() end
            if aimBtnGui then aimBtnGui:Destroy() end
            print("[RoooorHub] Unloaded!")
        end)
    end)
end)

-- =========================================================
-- WATERMARK
-- =========================================================
local watermark = Instance.new("TextLabel")
watermark.Name = "RoooorWatermark"
watermark.Size = UDim2.new(0, 250, 0, 24)
watermark.Position = UDim2.new(0, 15, 0, 15)
watermark.BackgroundTransparency = 0.5
watermark.BackgroundColor3 = C.BG
watermark.Text = "🔥 ROOORHUB v11 | FPS: --"
watermark.TextColor3 = C.FIRE_BRIGHT
watermark.TextSize = 12
watermark.Font = Enum.Font.GothamBold
watermark.TextStrokeTransparency = 0.3
watermark.TextStrokeColor3 = C.FIRE3
watermark.Parent = gui
rnd(watermark, 6)
strk(watermark, C.FIRE2, 1, 0.4)

-- Watermark update loop
task.spawn(function()
    local frames = 0
    local lastTime = tick()

    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        if tick() - lastTime >= 1 then
            local fps = frames
            frames = 0
            lastTime = tick()

            local ping = 0
            pcall(function()
                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)

            watermark.Text = string.format("🔥 ROOORHUB v11 | FPS: %d | PING: %d ms", fps, ping)
        end
    end)
end)

print("========================================")
print("✅ ROOORHUB ULTIMATE FIRE v11 LOADED")
print("🔥 Auto Parry 360° - FIXED")
print("⚡ Auto Skill Check - Instant + Perfect")
print("💪 Semua fitur lengkap")
print("========================================")

-- Buka tab pertama default
task.wait(0.5)
local firstTab = sb:FindFirstChildOfClass("TextButton")
if firstTab then
    firstTab:FindFirstChildOfClass("TextButton") or firstTab.MouseButton1Click:Fire()
    end-- ============================
-- TAB: KILLER
-- ============================
makeTab("Killer", "🔪", 5, function()
    sec("Killer Auto", "⚔️")
    tog("Auto Attack Spam", false, function(s)
        S.Killer_AutoAtk = s
    end)
    sl("Attack Delay", 0.1, 2, 0.35, function(v)
        S.Killer_AtkDelay = v
    end)
    tog("Auto Kill All", false, function(s)
        S.Killer_KillAll = s
    end)
    tog("Auto Stalk", false, function(s)
        S.AutoStalk = s
    end)

    sec("Hitbox Expander", "📦")
    tog("Enable Hitbox", false, function(s)
        S.Killer_Hitbox = s
    end)
    sl("Hitbox Size", 5, 50, 15, function(v)
        S.Killer_HitboxSize = v
    end)

    sec("Masked Power", "🎭")
    drp("Select Power", {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}, "Cobra", function(v)
        S.MaskedPower = v
    end)
    btn("🔥 Activate Power", function()
        local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
            and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
            and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Activatepower")
        if Event then Event:FireServer(S.MaskedPower) end
    end)
    btn("❌ Deactivate Power", function()
        local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
            and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
            and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Deactivatepower")
        if Event then Event:FireServer() end
    end)

    sec("Killer UI", "🔔")
    tog("Kill Feed", false, function(s)
        S.KillFeed = s
    end)
    tog("Stun Notify", false, function(s)
        S.StunNotify = s
    end)
end)

-- ============================
-- TAB: MISC
-- ============================
makeTab("Misc", "⚙️", 6, function()
    sec("Movement", "🏃")
    tog("Walk Speed", false, function(s)
        S.WalkSpeed = s
    end)
    sl("Walk Speed Value", 16, 32, 16, function(v)
        S.WalkSpeedVal = v
    end)
    sl("Speed Boost", 0, 50, 0, function(v)
        S.WalkSpeedBoost = v
    end)
    tog("Speed Hack", false, function(s)
        S.SpeedHack = s
    end)
    sl("Speed Hack Value", 20, 100, 40, function(v)
        S.SpeedHackVal = v
    end)
    tog("Jump Power", false, function(s)
        S.JumpPower = s
    end)
    sl("Jump Power Value", 50, 300, 50, function(v)
        S.JumpPowerVal = v
    end)
    tog("No Clip", false, function(s)
        S.NoClip = s
    end)
    tog("Fly", false, function(s)
        S.Fly = s
    end)
    sl("Fly Speed", 20, 200, 50, function(v)
        S.FlySpeed = v
    end)

    sec("Character Mod", "🎭")
    tog("Korblox (Kaki Hilang)", false, function(s)
        S.Korblox = s
    end)
    tog("Headless", false, function(s)
        S.Headless = s
    end)
    tog("8-Bit Crown", false, function(s)
        S.EightBitCrown = s
    end)
    sl("Crown Size", 0.5, 3, 1, function(v)
        S.EightBitSize = v
    end)

    sec("Effect", "✨")
    tog("Trail Fire", false, function(s)
        S.Trail = s
    end)
    cpk("Trail Color", Color3.fromRGB(255, 120, 0), function(c)
        S.TrailColor = c
    end)
    tog("Aura Fire", false, function(s)
        S.Aura = s
    end)
    cpk("Aura Color", Color3.fromRGB(255, 120, 0), function(c)
        S.AuraColor = c
    end)
    tog("Kill Effect", false, function(s)
        S.KillEffect = s
    end)

    sec("Crosshair", "🎯")
    tog("Enable Crosshair", false, function(s)
        S.Crosshair = s
    end)
    cpk("Crosshair Color", Color3.fromRGB(0, 255, 200), function(c)
        S.CrosshairColor = c
    end)
    sl("Crosshair Size", 3, 20, 8, function(v)
        S.CrosshairSize = v
    end)

    sec("Camera", "📷")
    tog("No Clip Camera", false, function(s)
        S.NoClipCamera = s
    end)
    tog("Unlimited Zoom Out", false, function(s)
        S.ZoomOut = s
    end)
    sl("Zoom Distance", 100, 2000, 500, function(v)
        S.ZoomOutValue = v
    end)
    tog("Custom FOV", false, function(s)
        S.FOVEnabled = s
    end)
    sl("FOV Value", 40, 120, 70, function(v)
        S.FOV = v
    end)

    sec("Extra", "🎁")
    tog("Auto Heal", false, function(s) S.AutoHeal = s end)
    tog("Auto Repair", false, function(s) S.AutoRepair = s end)
    tog("Auto Revive", false, function(s) S.AutoRevive = s end)
    tog("Instant Interact", false, function(s) S.InstantInteract = s end)
    tog("Auto Vault", false, function(s) S.AutoVault = s end)
end)
