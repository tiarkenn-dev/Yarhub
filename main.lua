-- ═══════════════════════════════════════════
--   TIARHUB x VIOLENCE DISTRICT
--   Rayfield Gen2 Edition - BAGIAN 1
-- ═══════════════════════════════════════════
print("[TIARHUB] Starting...")

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local Cam = workspace.CurrentCamera

-- LIBRARY RAYFIELD GEN2
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/gen2'))()

print("[TIARHUB] Library OK")

-- CONFIG
local Config = {
    ESP = {
        Survivor=false, Killer=false, Generator=false, Pallet=false, Window=false, SCP=false,
        Distance=300,
        KillerColor=Color3.fromRGB(255,60,60),
        SurvivorColor=Color3.fromRGB(60,255,120),
        GenColor=Color3.fromRGB(255,170,0),
        PalletColor=Color3.fromRGB(74,255,181),
        WindowColor=Color3.fromRGB(74,255,181),
        SCPColor=Color3.fromRGB(255,0,0),
    },
    ESPStatus = { Enabled=false, ShowName=true, ShowDistance=true, ShowHealth=false, Radius=200 },
    Auto = { SkillCheck=false, Parry=false, Wiggle=false, WiggleSpam=5,
             ParryDistance=15, FaceSensitivity=0.7, RequireFacing=true },
    AutoFlee = { Enabled=false, DetectDistance=50, Cooldown=0.1 },
    GunAim = { Enabled=false, TargetMode="Killer", Predict=true, PredictStrength=0.12,
               FOV=250, AimPart="HumanoidRootPart", Strength=0.35 },
    AttackAim = { Enabled=false, Predict=true, PredictStrength=0.12, FOV=250, AimPart="HumanoidRootPart" },
    Killer = { KillAll=false, AutoAttack=false, AutoCarry=false, KillRange=500, AttackDelay=0.45 },
    Masked = { CurrentPower="Cobra" },
    Moonwalk = { Enabled=false, ShowButton=false, SpamSpeed=30, Intensity=35, SlowSpeed=13 },
    CameraZoom = { UnlimitedZoom=false, MaxDistance=1000, MinDistance=0,
                   FOVEnabled=false, FOV=70, DefaultFOV=workspace.CurrentCamera.FieldOfView },
    AutoStalk = { Enabled=false, StalkRange=150 },
    ParryRangeVisual = { Enabled=false, Color=Color3.fromRGB(255,80,80), Transparency=0.9 },
    PlayerMods = { GodMode=false },
    Movement = { JumpPowerEnabled=false, JumpPowerValue=50, OriginalJumpPower=50,
                 WalkSpeedEnabled=false, WalkSpeedValue=17.6, OriginalWalkSpeed=16, NoClip=false },
    Emote = { Selected="Mannrobics" },
    Crosshair = { Enabled=false, Size=8, Thickness=2, Color=Color3.fromRGB(255,255,255),
                  Style="Plus", OffsetX=0, OffsetY=0 },
    Visual = { Fullbright=false, NoShadow=false, Ambient=false, AmbientColor=Color3.fromRGB(255,255,255),
               Brightness=2, ClockTime=14, LowGraphics=false, CleanSky=false, NoScreenEffects=false },
    FastVault = { Enabled=false, Speed=1.2,
                  ReplaceMap = { ["rbxassetid://83873880822918"] = "rbxassetid://136962284480779" } },
}

-- KILLER ANIMS
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

-- REMOTES
local CarryEvent, HookEvent, AttackEvent, EmoteRemote
pcall(function()
    local R = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 30)
    if R then
        local Carry = R:FindFirstChild("Carry")
        if Carry then
            CarryEvent = Carry:FindFirstChild("CarrySurvivorEvent")
            HookEvent = Carry:FindFirstChild("HookEvent")
        end
        local Attacks = R:FindFirstChild("Attacks")
        if Attacks then AttackEvent = Attacks:FindFirstChild("BasicAttack") end
        EmoteRemote = R:FindFirstChild("EmoteHandler")
    end
end)

-- HELPER
local function getRoot() local c=LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c=LP.Character; return c and c:FindFirstChildOfClass("Humanoid") end

print("[TIARHUB] Config OK")

-- WINDOW RAYFIELD
local Window = Rayfield:CreateWindow({
    Name = "TIARHUB",
    Subtitle = "Violence District",
    LoadingTitle = "TIARHUB Loading",
    LoadingSubtitle = "by Tiar",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TiarHub",
        FileName = "Config"
    },
    KeySystem = false,
    SidebarLayout = true,
})

local function notify(title, content, dur)
    pcall(function()
        Window:Notify({ Title = title, Content = content or "", Duration = dur or 3 })
    end)
end

-- TABS
local InfoTab    = Window:CreateTab({ Name = "Info",     Icon = 4483362458 })
local CombatTab  = Window:CreateTab({ Name = "Combat",   Icon = 4483362458 })
local MoveTab    = Window:CreateTab({ Name = "Movement", Icon = 4483362458 })
local KillerTab  = Window:CreateTab({ Name = "Killer",   Icon = 4483362458 })
local VisualTab  = Window:CreateTab({ Name = "Visuals",  Icon = 4483362458 })
local SettingTab = Window:CreateTab({ Name = "Settings", Icon = 4483362458 })

print("[TIARHUB] Tabs OK")

-- ═══════════════════════════════════════════
--  TAB INFO
-- ═══════════════════════════════════════════
InfoTab:CreateSection("Script Info")

InfoTab:CreateParagraph({
    Title = "TIARHUB",
    Content = "Violence District | Rayfield Gen2 Edition | Version 1.0",
})

InfoTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/tiarhub")
        notify("Copied", "Discord link copied!", 2)
    end,
})

InfoTab:CreateSection("Credits")

InfoTab:CreateParagraph({
    Title = "Credits",
    Content = "Base: Fallens Freemium\nLibrary: Rayfield Gen2\nDev: Tiar",
})

-- ═══════════════════════════════════════════
--  TAB COMBAT
-- ═══════════════════════════════════════════
CombatTab:CreateSection("Auto Parry")

local lastParry, PARRY_DEBOUNCE = 0, 0.2
local ParryActive = false
local ParryCircle = nil
local hookedKillers = {}

local function pressRightClick()
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0,0,1,true,game,0)
        task.wait(0.02)
        VirtualInputManager:SendMouseButtonEvent(0,0,1,false,game,0)
    end)
end

local function GetParryButton()
    local cur = PG
    for s in string.gmatch("Survivor-mob.Controls.Gui-mob","[^%.]+") do
        cur = cur and cur:FindFirstChild(s)
    end
    return cur
end

local function pressParryButton()
    if UserInputService.TouchEnabled then
        local btn = GetParryButton()
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
        else pressRightClick() end
    else pressRightClick() end
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
    return (enemyRoot.Position - myRoot.Position).Magnitude <= Config.Auto.ParryDistance
end

local function isFacingTarget(targetChar)
    if not Config.Auto.RequireFacing then return true end
    local myChar = LP.Character
    if not myChar then return false end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local enemyRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not enemyRoot then return false end
    local dot = enemyRoot.CFrame.LookVector:Dot((myRoot.Position - enemyRoot.Position).Unit)
    if Config.Auto.FaceSensitivity <= -1 then return true end
    return dot >= Config.Auto.FaceSensitivity
end

local function hookKiller(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not Config.Auto.Parry then return end
        local anim = track.Animation
        if not anim then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end
        if KillerAnims["rbxassetid://"..id] then
            if not isInParryRange(char) then return end
            if not isFacingTarget(char) then return end
            doParry()
        end
    end)
end

task.spawn(function()
    while task.wait(0.8) do
        if Config.Auto.Parry then
            for _,p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
                    hookKiller(p.Character)
                end
            end
        end
    end
end)

local function updateParryCircle()
    local root = getRoot()
    if not Config.ParryRangeVisual.Enabled or not root then
        if ParryCircle then ParryCircle:Destroy(); ParryCircle = nil end
        return
    end
    if not ParryCircle then
        ParryCircle = Instance.new("Part")
        ParryCircle.Shape = Enum.PartType.Cylinder
        ParryCircle.Anchored = true
        ParryCircle.CanCollide = false
        ParryCircle.Material = Enum.Material.Neon
        ParryCircle.Name = "ParryRangeCircle"
        ParryCircle.Parent = workspace
    end
    local size = Config.Auto.ParryDistance * 2
    local yOffset = root.Size.Y / 2 + 1.5
    ParryCircle.Size = Vector3.new(0.2, size, size)
    ParryCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0)) * CFrame.Angles(0, 0, math.rad(90))
    ParryCircle.Color = Config.ParryRangeVisual.Color
    ParryCircle.Transparency = Config.ParryRangeVisual.Transparency
end

RunService.RenderStepped:Connect(updateParryCircle)

CombatTab:CreateToggle({
    Name = "Auto Parry 360",
    CurrentValue = false,
    Flag = "AutoParry",
    Callback = function(v)
        Config.Auto.Parry = v
        Config.ParryRangeVisual.Enabled = v
    end,
})

CombatTab:CreateSlider({
    Name = "Parry Distance",
    Range = {5, 30},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 15,
    Flag = "ParryDistance",
    Callback = function(v) Config.Auto.ParryDistance = v end,
})

CombatTab:CreateSlider({
    Name = "Face Sensitivity",
    Range = {-1, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 0.7,
    Flag = "FaceSensitivity",
    Callback = function(v) Config.Auto.FaceSensitivity = v end,
})

CombatTab:CreateToggle({
    Name = "Show Parry Range",
    CurrentValue = false,
    Flag = "ShowParryRange",
    Callback = function(v)
        Config.ParryRangeVisual.Enabled = v
        if not v and ParryCircle then ParryCircle:Destroy(); ParryCircle = nil end
    end,
})

CombatTab:CreateColorPicker({
    Name = "Range Color",
    Color = Color3.fromRGB(255, 80, 80),
    Flag = "ParryColor",
    Callback = function(c) Config.ParryRangeVisual.Color = c end,
})

-- AIMLOCK
CombatTab:CreateSection("Aimlock")

local GunAimHolding = false
local AttackAimHolding = false
local RayParams = RaycastParams.new()
pcall(function() RayParams.FilterType = Enum.RaycastFilterType.Exclude end)

local function isVisible(part)
    RayParams.FilterDescendantsInstances = { LP.Character }
    local result = workspace:Raycast(Cam.CFrame.Position, part.Position - Cam.CFrame.Position, RayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

local function getClosestTarget(mode, aimPart, fov)
    local ctr = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
    local closest, shortest = nil, fov
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team then
            local valid = false
            if mode == "Killer" and p.Team.Name == "Killer" then valid = true end
            if mode == "Survivor" and p.Team.Name == "Survivors" then valid = true end
            if valid then
                local hrp = p.Character:FindFirstChild(aimPart)
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local pos, vis = Cam:WorldToViewportPoint(hrp.Position)
                    if vis then
                        local d = (Vector2.new(pos.X, pos.Y) - ctr).Magnitude
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

UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAimHolding = true
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAimHolding = false
    end
end)

RunService.RenderStepped:Connect(function()
    if Config.GunAim.Enabled and GunAimHolding then
        local t = getClosestTarget(Config.GunAim.TargetMode, Config.GunAim.AimPart, Config.GunAim.FOV)
        if t then
            local pos = t.Position
            if Config.GunAim.Predict then pos = pos + t.AssemblyLinearVelocity * Config.GunAim.PredictStrength end
            Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, pos), Config.GunAim.Strength)
        end
    end
end)

CombatTab:CreateToggle({
    Name = "Aimlock",
    CurrentValue = false,
    Flag = "GunAim",
    Callback = function(v) Config.GunAim.Enabled = v end,
})

CombatTab:CreateDropdown({
    Name = "Target",
    Options = {"Killer", "Survivor"},
    CurrentOption = {"Killer"},
    Flag = "GunAimTarget",
    Callback = function(opt)
        Config.GunAim.TargetMode = type(opt) == "table" and opt[1] or opt
    end,
})

CombatTab:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head", "HumanoidRootPart", "Torso"},
    CurrentOption = {"HumanoidRootPart"},
    Flag = "GunAimPart",
    Callback = function(opt)
        Config.GunAim.AimPart = type(opt) == "table" and opt[1] or opt
    end,
})

CombatTab:CreateSlider({
    Name = "Aim FOV",
    Range = {50, 1000},
    Increment = 10,
    Suffix = "",
    CurrentValue = 250,
    Flag = "AimFOV",
    Callback = function(v) Config.GunAim.FOV = v end,
})

CombatTab:CreateSlider({
    Name = "Aim Prediction",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.12,
    Flag = "AimPredict",
    Callback = function(v) Config.GunAim.PredictStrength = v end,
})

-- CROSSHAIR
CombatTab:CreateSection("Crosshair")

local CrosshairDrawings = {}
local CrosshairCreated = false
local LastCrosshairStyle = nil

local function clearCrosshair()
    for _,v in pairs(CrosshairDrawings) do if v and v.Remove then v:Remove() end end
    CrosshairDrawings = {}
    CrosshairCreated = false
end

RunService.RenderStepped:Connect(function()
    local C = Config.Crosshair
    if not C.Enabled then
        for _,v in pairs(CrosshairDrawings) do if v then v.Visible = false end end
        return
    end
    if LastCrosshairStyle ~= C.Style then clearCrosshair(); LastCrosshairStyle = C.Style end
    local ctr = Vector2.new(Cam.ViewportSize.X/2 + C.OffsetX, Cam.ViewportSize.Y/2 + C.OffsetY)
    if not CrosshairCreated then
        CrosshairCreated = true
        if C.Style == "Plus" then
            for i=1,4 do
                local l = Drawing.new("Line"); l.Visible = true; table.insert(CrosshairDrawings, l)
            end
        elseif C.Style == "Dot" then
            local d = Drawing.new("Circle"); d.Filled = true; d.Visible = true; table.insert(CrosshairDrawings, d)
        else
            local c = Drawing.new("Circle"); c.Filled = false; c.Visible = true; table.insert(CrosshairDrawings, c)
        end
    end
    if C.Style == "Plus" then
        for _,l in pairs(CrosshairDrawings) do l.Color = C.Color; l.Thickness = C.Thickness; l.Visible = true end
        CrosshairDrawings[1].From = ctr+Vector2.new(-C.Size,0); CrosshairDrawings[1].To = ctr+Vector2.new(-2,0)
        CrosshairDrawings[2].From = ctr+Vector2.new(C.Size,0);  CrosshairDrawings[2].To = ctr+Vector2.new(2,0)
        CrosshairDrawings[3].From = ctr+Vector2.new(0,-C.Size); CrosshairDrawings[3].To = ctr+Vector2.new(0,-2)
        CrosshairDrawings[4].From = ctr+Vector2.new(0,C.Size);  CrosshairDrawings[4].To = ctr+Vector2.new(0,2)
    elseif C.Style == "Dot" then
        CrosshairDrawings[1].Position = ctr; CrosshairDrawings[1].Radius = C.Size/2; CrosshairDrawings[1].Color = C.Color
    else
        CrosshairDrawings[1].Position = ctr; CrosshairDrawings[1].Radius = C.Size
        CrosshairDrawings[1].Color = C.Color; CrosshairDrawings[1].Thickness = C.Thickness
    end
end)

CombatTab:CreateToggle({
    Name = "Enable Crosshair",
    CurrentValue = false,
    Flag = "CrosshairOn",
    Callback = function(v) Config.Crosshair.Enabled = v end,
})

CombatTab:CreateDropdown({
    Name = "Style",
    Options = {"Plus", "Dot", "Circle"},
    CurrentOption = {"Plus"},
    Flag = "CrosshairStyle",
    Callback = function(opt)
        Config.Crosshair.Style = type(opt) == "table" and opt[1] or opt
    end,
})

CombatTab:CreateSlider({
    Name = "Crosshair Size",
    Range = {2, 30},
    Increment = 1,
    Suffix = "",
    CurrentValue = 8,
    Flag = "CrosshairSize",
    Callback = function(v) Config.Crosshair.Size = v end,
})

CombatTab:CreateSlider({
    Name = "Crosshair X",
    Range = {-100, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 0,
    Flag = "CrosshairX",
    Callback = function(v) Config.Crosshair.OffsetX = v end,
})

CombatTab:CreateSlider({
    Name = "Crosshair Y",
    Range = {-100, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 0,
    Flag = "CrosshairY",
    Callback = function(v) Config.Crosshair.OffsetY = v end,
})

print("[TIARHUB] BAGIAN 1 DONE")-- ═══════════════════════════════════════════
--   BAGIAN 2: Movement + Killer
--   Rayfield Gen2
-- ═══════════════════════════════════════════
print("[TIARHUB] Bagian 2 loading...")

-- ═══════════════════════════════════════════
--  TAB MOVEMENT
-- ═══════════════════════════════════════════
MoveTab:CreateSection("Speed")

local WalkSpeedConnection = nil

local function shouldDisableWalkSpeed()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            local anim = track.Animation
            if anim and anim.AnimationId then
                if anim.AnimationId == "rbxassetid://127096285501517" then return true end
                if anim.AnimationId == "rbxassetid://112166042383605" then return true end
                if anim.AnimationId == "rbxassetid://123047897844134" then return true end
                local id = anim.AnimationId:match("%d+")
                if id and KillerAnims["rbxassetid://"..id] then return true end
            end
        end
    end
    if hum.Health <= 0 or hum.Health < 2
    or char:GetAttribute("Downed") == true
    or char:GetAttribute("IsDown") == true
    or char:GetAttribute("Knocked") == true then
        return true
    end
    return false
end

local function applyWalkSpeed()
    if WalkSpeedConnection then WalkSpeedConnection:Disconnect() end
    WalkSpeedConnection = RunService.Heartbeat:Connect(function()
        if not Config.Movement.WalkSpeedEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if shouldDisableWalkSpeed() then return end
        if hum.WalkSpeed ~= Config.Movement.WalkSpeedValue then
            hum.WalkSpeed = Config.Movement.WalkSpeedValue
        end
    end)
end

local function applyJumpPower()
    if not Config.Movement.JumpPowerEnabled then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if hum.UseJumpPower then hum.JumpPower = Config.Movement.JumpPowerValue
        else hum.JumpHeight = Config.Movement.JumpPowerValue / 7.5 end
    end
end

MoveTab:CreateToggle({
    Name = "Walk Speed",
    CurrentValue = false,
    Flag = "WalkSpeedToggle",
    Callback = function(v)
        Config.Movement.WalkSpeedEnabled = v
        if v then applyWalkSpeed()
        else
            if WalkSpeedConnection then WalkSpeedConnection:Disconnect() end
            local hum = getHum()
            if hum then hum.WalkSpeed = Config.Movement.OriginalWalkSpeed end
        end
    end,
})

MoveTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 17,
    Flag = "WalkSpeedValue",
    Callback = function(v) Config.Movement.WalkSpeedValue = v end,
})

-- JUMP
MoveTab:CreateSection("Jump")

MoveTab:CreateToggle({
    Name = "Custom Jump Power",
    CurrentValue = false,
    Flag = "JumpPowerToggle",
    Callback = function(v)
        Config.Movement.JumpPowerEnabled = v
        if v then applyJumpPower()
        else
            local hum = getHum()
            if hum then
                if hum.UseJumpPower then hum.JumpPower = Config.Movement.OriginalJumpPower
                else hum.JumpHeight = Config.Movement.OriginalJumpPower / 7.5 end
            end
        end
    end,
})

MoveTab:CreateSlider({
    Name = "Jump Power Value",
    Range = {0, 300},
    Increment = 5,
    Suffix = "",
    CurrentValue = 50,
    Flag = "JumpPowerValue",
    Callback = function(v) Config.Movement.JumpPowerValue = v end,
})

-- NOCLIP
MoveTab:CreateSection("No Clip")

local NoClipConnection = nil

local function applyNoClip()
    local char = LP.Character
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide then
            if Config.Movement.NoClip then v.CanCollide = false
            else v.CanCollide = true end
        end
    end
end

local function toggleNoClip(state)
    Config.Movement.NoClip = state
    if state then
        if NoClipConnection then NoClipConnection:Disconnect() end
        NoClipConnection = RunService.RenderStepped:Connect(function()
            if Config.Movement.NoClip then applyNoClip() end
        end)
    else
        if NoClipConnection then NoClipConnection:Disconnect(); NoClipConnection = nil end
        local char = LP.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end
end

MoveTab:CreateToggle({
    Name = "No Clip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(v) toggleNoClip(v) end,
})

-- MOONWALK
MoveTab:CreateSection("Moonwalk")

local MoonwalkConnection = nil
local MoonwalkButton = nil

local function isDowned()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return hum.Health <= 0 or hum.Health < 2
    or char:GetAttribute("Downed") == true
    or char:GetAttribute("IsDown") == true
    or char:GetAttribute("Knocked") == true
end

local function startMoonwalk()
    if MoonwalkConnection then return end
    MoonwalkConnection = RunService.RenderStepped:Connect(function()
        if not Config.Moonwalk.Enabled then return end
        if ParryActive or isDowned() then return end
        local char = LP.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not humanoid or not hrp or not cam then return end
        if humanoid.WalkSpeed ~= Config.Moonwalk.SlowSpeed then
            humanoid.WalkSpeed = Config.Moonwalk.SlowSpeed
        end
        local look = cam.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit
            local baseCF = CFrame.new(hrp.Position, hrp.Position + flatLook)
            local angle = math.sin(tick() * Config.Moonwalk.SpamSpeed) * Config.Moonwalk.Intensity
            hrp.CFrame = baseCF * CFrame.Angles(0, math.rad(angle), 0)
            humanoid:Move(Vector3.new(0, 0, 1), true)
        end
    end)
end

local function stopMoonwalk()
    if MoonwalkConnection then MoonwalkConnection:Disconnect(); MoonwalkConnection = nil end
    local hum = getHum()
    if hum then
        if Config.Movement.WalkSpeedEnabled then hum.WalkSpeed = Config.Movement.WalkSpeedValue
        else hum.WalkSpeed = 16 end
    end
end

local function createMoonwalkButton()
    if not PG or not PG.Parent then return end
    if MoonwalkButton then MoonwalkButton:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "MoonwalkGui"
    gui.ResetOnSpawn = false
    gui.Parent = PG
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
    if MoonwalkButton then MoonwalkButton:Destroy(); MoonwalkButton = nil end
end

MoveTab:CreateToggle({
    Name = "Moonwalk",
    CurrentValue = false,
    Flag = "MoonwalkToggle",
    Callback = function(v)
        Config.Moonwalk.Enabled = v
        if v then startMoonwalk() else stopMoonwalk() end
    end,
})

MoveTab:CreateKeybind({
    Name = "Moonwalk Keybind",
    CurrentKeybind = "V",
    HoldToInteract = false,
    Flag = "MoonwalkKey",
    Callback = function()
        Config.Moonwalk.Enabled = not Config.Moonwalk.Enabled
        if Config.Moonwalk.Enabled then startMoonwalk() else stopMoonwalk() end
    end,
})

MoveTab:CreateToggle({
    Name = "Show Moonwalk Button",
    CurrentValue = false,
    Flag = "MoonwalkBtn",
    Callback = function(v)
        Config.Moonwalk.ShowButton = v
        if v then createMoonwalkButton() else removeMoonwalkButton() end
    end,
})

MoveTab:CreateSlider({
    Name = "Spam Speed",
    Range = {1, 50},
    Increment = 1,
    Suffix = "",
    CurrentValue = 30,
    Flag = "MoonwalkSpam",
    Callback = function(v) Config.Moonwalk.SpamSpeed = v end,
})

MoveTab:CreateSlider({
    Name = "Intensity",
    Range = {1, 50},
    Increment = 1,
    Suffix = "",
    CurrentValue = 35,
    Flag = "MoonwalkIntensity",
    Callback = function(v) Config.Moonwalk.Intensity = v end,
})

-- FAST VAULT
MoveTab:CreateSection("Vault & TP")

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
        local replaceId = Config.FastVault.ReplaceMap[id]
        if not replaceId or VaultTracks[track] then return end
        VaultTracks[track] = true
        track:Stop()
        local newAnim = Instance.new("Animation")
        newAnim.AnimationId = replaceId
        local newTrack = animator:LoadAnimation(newAnim)
        newTrack.Priority = Enum.AnimationPriority.Action
        newTrack:Play()
        newTrack:AdjustSpeed(Config.FastVault.Speed)
        newTrack.Stopped:Connect(function() VaultTracks[track] = nil end)
    end)
end

local function teleportToFinishLine()
    local root = getRoot()
    if not root then notify("TP","No player",2); return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if string.lower(obj.Name) == "fininshline" and obj:IsA("BasePart") then
            root.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
            notify("Escape","TP!",2); return
        end
    end
    notify("Escape","Gak ketemu",2)
end

MoveTab:CreateToggle({
    Name = "Fast Vault",
    CurrentValue = false,
    Flag = "FastVaultToggle",
    Callback = function(v) Config.FastVault.Enabled = v end,
})

MoveTab:CreateSlider({
    Name = "Vault Animation Speed",
    Range = {1, 5},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 1.2,
    Flag = "VaultSpeed",
    Callback = function(v) Config.FastVault.Speed = v end,
})

MoveTab:CreateButton({
    Name = "Instant Escape",
    Callback = function() teleportToFinishLine() end,
})

-- ZOOM
MoveTab:CreateSection("Zoom & FOV")

local function applyUnlimitedZoom()
    if Config.CameraZoom.UnlimitedZoom then
        LP.CameraMaxZoomDistance = Config.CameraZoom.MaxDistance
        LP.CameraMinZoomDistance = Config.CameraZoom.MinDistance
    else
        LP.CameraMaxZoomDistance = 128
        LP.CameraMinZoomDistance = 0.5
    end
end

local function applyCameraFOV()
    local cam = workspace.CurrentCamera
    if not cam then return end
    if Config.CameraZoom.FOVEnabled then cam.FieldOfView = Config.CameraZoom.FOV
    else cam.FieldOfView = Config.CameraZoom.DefaultFOV end
end

MoveTab:CreateToggle({
    Name = "Unlimited Zoom",
    CurrentValue = false,
    Flag = "UnlimitedZoom",
    Callback = function(v)
        Config.CameraZoom.UnlimitedZoom = v
        applyUnlimitedZoom()
    end,
})

MoveTab:CreateSlider({
    Name = "Max Zoom Distance",
    Range = {100, 5000},
    Increment = 100,
    Suffix = "",
    CurrentValue = 1000,
    Flag = "MaxZoom",
    Callback = function(v)
        Config.CameraZoom.MaxDistance = v
        if Config.CameraZoom.UnlimitedZoom then applyUnlimitedZoom() end
    end,
})

MoveTab:CreateToggle({
    Name = "Custom FOV",
    CurrentValue = false,
    Flag = "CustomFOV",
    Callback = function(v)
        Config.CameraZoom.FOVEnabled = v
        applyCameraFOV()
    end,
})

MoveTab:CreateSlider({
    Name = "Camera FOV",
    Range = {40, 120},
    Increment = 1,
    Suffix = "",
    CurrentValue = 70,
    Flag = "CameraFOV",
    Callback = function(v)
        Config.CameraZoom.FOV = v
        if Config.CameraZoom.FOVEnabled then applyCameraFOV() end
    end,
})

-- Respawn handler
LP.CharacterAdded:Connect(function(char)
    task.wait(0.8)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        Config.Movement.OriginalWalkSpeed = hum.WalkSpeed
        Config.Movement.OriginalJumpPower = hum.UseJumpPower and hum.JumpPower or 50
    end
    applyWalkSpeed()
    applyJumpPower()
    if Config.Movement.NoClip then toggleNoClip(true) end
    applyUnlimitedZoom()
    hookVault(char)
end)

-- ═══════════════════════════════════════════
--  TAB KILLER
-- ═══════════════════════════════════════════
KillerTab:CreateSection("Auto Abilities")

local KillerBusy = false
local KillerTarget = nil
local MaskedPowers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}

local function GetDowned()
    local root = getRoot()
    if not root then return nil end
    local best, dist = nil, math.huge
    for _,p in pairs(Players:GetPlayers()) do
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

local function GetNearestAliveSurvivor()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < shortest and d <= Config.Killer.KillRange then
                    shortest = d
                    closest = plr.Character
                end
            end
        end
    end
    return closest
end

local function getClosestSurvivorForStalk()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local d = (hrp.Position - root.Position).Magnitude
                if d <= Config.AutoStalk.StalkRange and d < shortest then
                    shortest = d
                    closest = plr
                end
            end
        end
    end
    return closest
end

task.spawn(function()
    while task.wait(0.05) do
        if Config.Killer.AutoAttack and AttackEvent then
            pcall(function() AttackEvent:FireServer(false) end)
        end

        if Config.Killer.AutoCarry and not KillerBusy then
            KillerBusy = true
            task.spawn(function()
                local target = GetDowned()
                local root = getRoot()
                if target and root and CarryEvent and HookEvent then
                    local tRoot = target:FindFirstChild("HumanoidRootPart")
                    if tRoot then
                        root.CFrame = tRoot.CFrame * CFrame.new(0, 3, -2)
                        task.wait(0.4)
                        for i = 1, 4 do
                            pcall(function() CarryEvent:FireServer(target) end)
                            task.wait(0.2)
                        end
                        task.wait(0.6)
                        local hook = GetHook()
                        if hook then
                            root.CFrame = hook.CFrame * CFrame.new(0, 4, -3)
                            task.wait(0.7)
                            for i = 1, 6 do
                                pcall(function() HookEvent:FireServer(hook) end)
                                task.wait(0.15)
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
                if not KillerTarget or not KillerTarget:FindFirstChild("Humanoid") or KillerTarget.Humanoid.Health <= 35 then
                    KillerTarget = GetNearestAliveSurvivor()
                end
                if KillerTarget then
                    local targetHRP = KillerTarget:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        local velocity = targetHRP.AssemblyLinearVelocity * 0.15
                        local targetPos = targetHRP.Position + velocity
                        local behind = targetHRP.CFrame.LookVector * -3
                        root.CFrame = CFrame.new(targetPos + behind, targetPos)
                    end
                    if AttackEvent then
                        pcall(function() AttackEvent:FireServer(false) end)
                    end
                end
            end
        end

        if Config.AutoStalk.Enabled then
            local target = getClosestSurvivorForStalk()
            if target then
                local stalkEvent = ReplicatedStorage:FindFirstChild("Remotes") and
                                   ReplicatedStorage.Remotes:FindFirstChild("Killers") and
                                   ReplicatedStorage.Remotes.Killers:FindFirstChild("Stalker") and
                                   ReplicatedStorage.Remotes.Killers.Stalker:FindFirstChild("StartStalking")
                if stalkEvent then
                    pcall(function() stalkEvent:FireServer(target) end)
                end
            end
        end
    end
end)

KillerTab:CreateToggle({
    Name = "Auto Stalk",
    CurrentValue = false,
    Flag = "AutoStalk",
    Callback = function(v) Config.AutoStalk.Enabled = v end,
})

KillerTab:CreateToggle({
    Name = "Auto Spam Attack",
    CurrentValue = false,
    Flag = "AutoAttack",
    Callback = function(v) Config.Killer.AutoAttack = v end,
})

KillerTab:CreateToggle({
    Name = "Auto Kill All",
    CurrentValue = false,
    Flag = "KillAll",
    Callback = function(v) Config.Killer.KillAll = v end,
})

KillerTab:CreateToggle({
    Name = "Auto Carry + Hook",
    CurrentValue = false,
    Flag = "AutoCarry",
    Callback = function(v) Config.Killer.AutoCarry = v end,
})

KillerTab:CreateSlider({
    Name = "Attack Delay",
    Range = {0.1, 2},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.45,
    Flag = "AttackDelay",
    Callback = function(v) Config.Killer.AttackDelay = v end,
})

KillerTab:CreateSlider({
    Name = "Kill Range",
    Range = {50, 2000},
    Increment = 50,
    Suffix = " studs",
    CurrentValue = 500,
    Flag = "KillRange",
    Callback = function(v) Config.Killer.KillRange = v end,
})

-- MASKED POWER
KillerTab:CreateSection("Masked Power")

KillerTab:CreateDropdown({
    Name = "Select Power",
    Options = MaskedPowers,
    CurrentOption = {"Cobra"},
    Flag = "MaskedSelect",
    Callback = function(opt)
        Config.Masked.CurrentPower = type(opt) == "table" and opt[1] or opt
    end,
})

KillerTab:CreateButton({
    Name = "Activate Power",
    Callback = function()
        local Event = ReplicatedStorage:FindFirstChild("Remotes") and
                      ReplicatedStorage.Remotes:FindFirstChild("Killers") and
                      ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked") and
                      ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Activatepower")
        if Event then
            Event:FireServer(Config.Masked.CurrentPower)
            notify("Masked", "Activated: "..Config.Masked.CurrentPower, 2)
        end
    end,
})

KillerTab:CreateButton({
    Name = "Deactivate Power",
    Callback = function()
        local Event = ReplicatedStorage:FindFirstChild("Remotes") and
                      ReplicatedStorage.Remotes:FindFirstChild("Killers") and
                      ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked") and
                      ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Deactivatepower")
        if Event then
            Event:FireServer()
            notify("Masked", "Deactivated", 2)
        end
    end,
})

-- KILLER AIMLOCK
KillerTab:CreateSection("Killer Aimlock")

local AttackAimHolding = false

UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.UserInputType == Enum.UserInputType.MouseButton2 then
        AttackAimHolding = true
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then
        AttackAimHolding = false
    end
end)

RunService.RenderStepped:Connect(function()
    if Config.AttackAim.Enabled and AttackAimHolding then
        local t = getClosestTarget("Survivor", Config.AttackAim.AimPart, Config.AttackAim.FOV)
        if t then
            local pos = t.Position
            if Config.AttackAim.Predict then
                pos = pos + t.AssemblyLinearVelocity * Config.AttackAim.PredictStrength
            end
            Cam.CFrame = CFrame.new(Cam.CFrame.Position, pos)
        end
    end
end)

KillerTab:CreateToggle({
    Name = "Aimlock Attack (Survivor)",
    CurrentValue = false,
    Flag = "AttackAim",
    Callback = function(v) Config.AttackAim.Enabled = v end,
})

print("[TIARHUB] BAGIAN 2 DONE")-- ═══════════════════════════════════════════
--   BAGIAN 3: Visuals + Auto
--   Rayfield Gen2
-- ═══════════════════════════════════════════
print("[TIARHUB] Bagian 3 loading...")

-- ═══════════════════════════════════════════
--  TAB VISUALS
-- ═══════════════════════════════════════════
VisualTab:CreateSection("ESP Players")

local ESPObjects = {}
local StatusESP = {}
local CachedSCP = {}
local GeneratorColor = Config.ESP.GenColor
local PalletColor = Config.ESP.PalletColor
local WindowColor = Config.ESP.WindowColor
local SCPColor = Config.ESP.SCPColor

for _, obj in ipairs(workspace:GetDescendants()) do
    if string.find(string.lower(obj.Name), "scp") then
        CachedSCP[obj] = true
    end
end

workspace.DescendantAdded:Connect(function(obj)
    if string.find(string.lower(obj.Name), "scp") then
        CachedSCP[obj] = true
    end
end)

local function removeESP(obj)
    if ESPObjects[obj] then
        ESPObjects[obj]:Destroy()
        ESPObjects[obj] = nil
    end
end

workspace.DescendantRemoving:Connect(function(obj)
    CachedSCP[obj] = nil
    removeESP(obj)
end)

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
        if not parent then removeESP(obj) end
    end)
end

-- GENERATOR
local function GetGameValue(obj, name)
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

local function ApplyGenHighlight(object, color)
    local h = object:FindFirstChild("GenHighlight") or Instance.new("Highlight")
    h.Name = "GenHighlight"
    h.Adornee = object
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.9
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = object
end

local function CreateBillboard(text, color)
    local billboard = Instance.new("BillboardGui")
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
    return billboard
end

local function UpdateGenerator(generator)
    if not generator or not generator.Parent then return end
    if not Config.ESP.Generator then
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
    local color = GeneratorColor:Lerp(Color3.fromRGB(0,255,120), cp / 100)
    local text = string.format("[%.0f%%]", percent)
    if not billboard then
        billboard = CreateBillboard(text, color)
        billboard.Adornee = generator
        billboard.Parent = generator
    else
        local lbl = billboard:FindFirstChildOfClass("TextLabel")
        if lbl then
            lbl.Text = text
            lbl.TextColor3 = color
        end
    end
    ApplyGenHighlight(generator, color)
end

local function UpdateMapESP(obj, root)
    if not obj or not root then return end
    local pos
    if obj:IsA("Model") then pos = obj:GetPivot().Position
    elseif obj:IsA("BasePart") then pos = obj.Position end
    if not pos then return end
    local distance = (pos - root.Position).Magnitude

    if obj.Name == "Window" then
        if Config.ESP.Window and distance <= Config.ESP.Distance then createESP(obj, WindowColor)
        else removeESP(obj) end
    end
    if obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        if Config.ESP.Pallet and distance <= Config.ESP.Distance then createESP(obj, PalletColor)
        else removeESP(obj) end
    end
end

-- STATUS ESP
local function removeStatusESP(char)
    if StatusESP[char] then
        StatusESP[char]:Destroy()
        StatusESP[char] = nil
    end
end

local function createStatusESP(player, char, root)
    if not Config.ESPStatus.Enabled then removeStatusESP(char); return end
    if not root then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    local isDown = hum.Health <= 0 or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true

    local dist = (head.Position - root.Position).Magnitude
    if dist > Config.ESPStatus.Radius then removeStatusESP(char); return end

    local text = ""
    if isDown then text = "DOWN\n" end
    if Config.ESPStatus.ShowName then text = text .. player.Name .. "\n" end
    if Config.ESPStatus.ShowDistance then text = text .. string.format("Dist: %.0f\n", dist) end
    if Config.ESPStatus.ShowHealth then text = text .. string.format("HP: %.0f\n", hum.Health) end
    if text == "" then removeStatusESP(char); return end

    local billboard = StatusESP[char]
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 120, 0, 50)
        billboard.AlwaysOnTop = true
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.Parent = billboard
        billboard.Adornee = head
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.Parent = char
        StatusESP[char] = billboard
    end
    local label = billboard:FindFirstChildOfClass("TextLabel")
    if label then
        label.Text = text
        local tc = Color3.new(1,1,1)
        if player.Team then
            if player.Team.Name == "Killer" then tc = Config.ESP.KillerColor
            elseif player.Team.Name == "Survivors" then tc = Config.ESP.SurvivorColor end
        end
        if isDown then tc = Color3.fromRGB(255, 0, 0) end
        label.TextColor3 = tc
    end
end

-- SCP ESP
local function UpdateSCPEsp(root)
    if not Config.ESP.SCP then
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
                if dist <= Config.ESP.Distance then createESP(obj, SCPColor)
                else removeESP(obj) end
            end
        end
    end
end

-- MAIN ESP LOOP
local lastESPUpdate = 0
RunService.RenderStepped:Connect(function()
    local now = tick()
    if now - lastESPUpdate < 0.05 then return end
    lastESPUpdate = now
    local root = getRoot()
    if not root then return end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local distance = (hrp.Position - root.Position).Magnitude
                    if distance <= Config.ESP.Distance then
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
                end
                createStatusESP(p, char, root)
            else
                removeESP(char)
            end
        end
    end

    if Config.ESP.Generator then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "Generator" and obj:IsA("Model") then
                UpdateGenerator(obj)
            end
        end
    end

    UpdateSCPEsp(root)

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Window" or obj.Name == "Pallet" or obj.Name == "Palletwrong" then
            UpdateMapESP(obj, root)
        end
    end
end)

-- ESP UI
VisualTab:CreateToggle({
    Name = "ESP Survivor",
    CurrentValue = false,
    Flag = "ESPSurvivor",
    Callback = function(v) Config.ESP.Survivor = v end,
})

VisualTab:CreateColorPicker({
    Name = "Survivor Color",
    Color = Config.ESP.SurvivorColor,
    Flag = "ColorSurvivor",
    Callback = function(c) Config.ESP.SurvivorColor = c end,
})

VisualTab:CreateToggle({
    Name = "ESP Killer",
    CurrentValue = false,
    Flag = "ESPKiller",
    Callback = function(v) Config.ESP.Killer = v end,
})

VisualTab:CreateColorPicker({
    Name = "Killer Color",
    Color = Config.ESP.KillerColor,
    Flag = "ColorKiller",
    Callback = function(c) Config.ESP.KillerColor = c end,
})

VisualTab:CreateToggle({
    Name = "ESP Generator",
    CurrentValue = false,
    Flag = "ESPGen",
    Callback = function(v) Config.ESP.Generator = v end,
})

VisualTab:CreateColorPicker({
    Name = "Generator Color",
    Color = Config.ESP.GenColor,
    Flag = "ColorGen",
    Callback = function(c) Config.ESP.GenColor = c; GeneratorColor = c end,
})

VisualTab:CreateToggle({
    Name = "ESP SCP",
    CurrentValue = false,
    Flag = "ESPSCP",
    Callback = function(v) Config.ESP.SCP = v end,
})

VisualTab:CreateColorPicker({
    Name = "SCP Color",
    Color = Config.ESP.SCPColor,
    Flag = "ColorSCP",
    Callback = function(c) Config.ESP.SCPColor = c; SCPColor = c end,
})

VisualTab:CreateToggle({
    Name = "ESP Pallet",
    CurrentValue = false,
    Flag = "ESPPallet",
    Callback = function(v) Config.ESP.Pallet = v end,
})

VisualTab:CreateColorPicker({
    Name = "Pallet Color",
    Color = Config.ESP.PalletColor,
    Flag = "ColorPallet",
    Callback = function(c) Config.ESP.PalletColor = c; PalletColor = c end,
})

VisualTab:CreateToggle({
    Name = "ESP Window",
    CurrentValue = false,
    Flag = "ESPWindow",
    Callback = function(v) Config.ESP.Window = v end,
})

VisualTab:CreateColorPicker({
    Name = "Window Color",
    Color = Config.ESP.WindowColor,
    Flag = "ColorWindow",
    Callback = function(c) Config.ESP.WindowColor = c; WindowColor = c end,
})

VisualTab:CreateSlider({
    Name = "ESP Radius",
    Range = {10, 2000},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 300,
    Flag = "ESPDistance",
    Callback = function(v) Config.ESP.Distance = v end,
})

-- ESP STATUS UI
VisualTab:CreateSection("ESP Status")

VisualTab:CreateToggle({
    Name = "Enable Status ESP",
    CurrentValue = false,
    Flag = "StatusEnabled",
    Callback = function(v) Config.ESPStatus.Enabled = v end,
})

VisualTab:CreateToggle({
    Name = "Show Name",
    CurrentValue = true,
    Flag = "StatusName",
    Callback = function(v) Config.ESPStatus.ShowName = v end,
})

VisualTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = true,
    Flag = "StatusDist",
    Callback = function(v) Config.ESPStatus.ShowDistance = v end,
})

VisualTab:CreateToggle({
    Name = "Show Health",
    CurrentValue = false,
    Flag = "StatusHP",
    Callback = function(v) Config.ESPStatus.ShowHealth = v end,
})

VisualTab:CreateSlider({
    Name = "Status Radius",
    Range = {20, 500},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 200,
    Flag = "StatusRadius",
    Callback = function(v) Config.ESPStatus.Radius = v end,
})

-- GRAPHICS
VisualTab:CreateSection("Graphics")

local original = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows
}

local function applyVisual()
    local V = Config.Visual
    if V.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    else
        Lighting.Brightness = original.Brightness
        Lighting.ClockTime = original.ClockTime
        Lighting.Ambient = original.Ambient
        Lighting.OutdoorAmbient = original.OutdoorAmbient
    end
    Lighting.GlobalShadows = not V.NoShadow
    if V.Ambient then
        Lighting.Ambient = V.AmbientColor
        Lighting.OutdoorAmbient = V.AmbientColor
        Lighting.Brightness = V.Brightness
        Lighting.ClockTime = V.ClockTime
    end
end

local function applyOptimization()
    pcall(function()
        if Config.Visual.LowGraphics then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        else
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end
    end)
    if Config.Visual.CleanSky then
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Sky") then v:Destroy() end
        end
    end
end

local ScreenEffectTypes = {"ColorCorrectionEffect","DepthOfFieldEffect","BlurEffect","SunRaysEffect","BloomEffect"}
local DisabledEffects = {}

local function applyNoScreenEffects()
    if Config.Visual.NoScreenEffects then
        for _, v in pairs(Lighting:GetChildren()) do
            for _, t in pairs(ScreenEffectTypes) do
                if v:IsA(t) then
                    DisabledEffects[v] = v.Enabled
                    v.Enabled = false
                end
            end
        end
    else
        for obj, state in pairs(DisabledEffects) do
            if obj and obj.Parent then obj.Enabled = state end
        end
        DisabledEffects = {}
    end
end

VisualTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(v) Config.Visual.Fullbright = v; applyVisual() end,
})

VisualTab:CreateToggle({
    Name = "No Shadow",
    CurrentValue = false,
    Flag = "NoShadow",
    Callback = function(v) Config.Visual.NoShadow = v; applyVisual() end,
})

VisualTab:CreateToggle({
    Name = "Low Graphics",
    CurrentValue = false,
    Flag = "LowGraphics",
    Callback = function(v) Config.Visual.LowGraphics = v; applyOptimization() end,
})

VisualTab:CreateToggle({
    Name = "No Screen Effects",
    CurrentValue = false,
    Flag = "NoScreenEffects",
    Callback = function(v) Config.Visual.NoScreenEffects = v; applyNoScreenEffects() end,
})

VisualTab:CreateToggle({
    Name = "Clean Sky",
    CurrentValue = false,
    Flag = "CleanSky",
    Callback = function(v) Config.Visual.CleanSky = v; applyOptimization() end,
})

-- Clock & Ambient
VisualTab:CreateSection("Clock & Ambient")

VisualTab:CreateSlider({
    Name = "Clock Time",
    Range = {0, 24},
    Increment = 1,
    Suffix = "h",
    CurrentValue = 14,
    Flag = "ClockTime",
    Callback = function(v)
        Config.Visual.ClockTime = v
        Config.Visual.Ambient = true
        applyVisual()
    end,
})

VisualTab:CreateSlider({
    Name = "Brightness",
    Range = {0, 5},
    Increment = 0.5,
    Suffix = "",
    CurrentValue = 2,
    Flag = "Brightness",
    Callback = function(v)
        Config.Visual.Brightness = v
        Config.Visual.Ambient = true
        applyVisual()
    end,
})

-- ═══════════════════════════════════════════
--  AUTO SURVIVOR (Killer tab)
-- ═══════════════════════════════════════════
KillerTab:CreateSection("Auto Survivor")

local SkillHeartbeat = nil
local busy = false

local function pressSpace()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end

local function GetActionTarget()
    local current = PG
    for segment in string.gmatch("Survivor-mob.Controls.action.check", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function TriggerMobileButton()
    local b = GetActionTarget()
    if b and b:IsA("GuiObject") then
        local p, s, i = b.AbsolutePosition, b.AbsoluteSize, game:GetService("GuiService"):GetGuiInset()
        local cx, cy = p.X + (s.X/2) + i.X, p.Y + (s.Y/2) + i.Y
        pcall(function()
            VirtualInputManager:SendTouchEvent(8822, 0, cx, cy)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8822, 2, cx, cy)
        end)
    end
end

local function startSkillCheck()
    if SkillHeartbeat then SkillHeartbeat:Disconnect() end
    SkillHeartbeat = RunService.RenderStepped:Connect(function()
        if not Config.Auto.SkillCheck or busy then return end
        local prompt = PG:FindFirstChild("SkillCheckPromptGui")
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
        local success = (sr > er and (lr >= sr or lr <= er)) or (lr >= sr and lr <= er)
        if success then
            busy = true
            task.spawn(function()
                if UserInputService.TouchEnabled then TriggerMobileButton() else pressSpace() end
                task.wait(0.05)
                busy = false
            end)
        end
    end)
end

local function AutoWiggle()
    if not Config.Auto.Wiggle then return end
    local char = LP.Character
    if not char then return end
    local carried = (char:FindFirstChild("IsCarried") and char.IsCarried.Value) or
                    (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)
    if not carried then return end
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return end
    local carry = remotes:FindFirstChild("Carry")
    if not carry then return end
    local event = carry:FindFirstChild("SelfUnHookEvent")
    if not event then return end
    for i = 1, Config.Auto.WiggleSpam do
        pcall(function() event:FireServer() end)
    end
end

local LastFlee = 0
local function GetNearestKiller()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Team and plr.Team.Name == "Killer" and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < shortest then shortest = dist; closest = hrp end
            end
        end
    end
    return closest, shortest
end

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

local function applyGodMode()
    if not Config.PlayerMods.GodMode then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum.Health < hum.MaxHealth then
        pcall(function() hum.Health = hum.MaxHealth end)
    end
    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Dead
    or state == Enum.HumanoidStateType.FallingDown
    or state == Enum.HumanoidStateType.Ragdoll then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end

task.spawn(function()
    while task.wait(0.2) do
        applyGodMode()
        AutoWiggle()
        if Config.AutoFlee.Enabled then
            local root = getRoot()
            if root then
                local killerRoot, distance = GetNearestKiller()
                if killerRoot and distance <= Config.AutoFlee.DetectDistance
                and tick() - LastFlee > Config.AutoFlee.Cooldown then
                    local point = GetFarthestGeneratorPoint(killerRoot)
                    if point then
                        LastFlee = tick()
                        root.CFrame = point.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end
        end
    end
end)

KillerTab:CreateToggle({
    Name = "Auto Skill Check",
    CurrentValue = false,
    Flag = "SkillCheck",
    Callback = function(v)
        Config.Auto.SkillCheck = v
        if v then startSkillCheck() end
    end,
})

KillerTab:CreateToggle({
    Name = "Auto Wiggle",
    CurrentValue = false,
    Flag = "AutoWiggle",
    Callback = function(v) Config.Auto.Wiggle = v end,
})

KillerTab:CreateSlider({
    Name = "Wiggle Spam",
    Range = {1, 30},
    Increment = 1,
    Suffix = "",
    CurrentValue = 5,
    Flag = "WiggleSpam",
    Callback = function(v) Config.Auto.WiggleSpam = v end,
})

KillerTab:CreateToggle({
    Name = "Auto Flee Killer",
    CurrentValue = false,
    Flag = "AutoFlee",
    Callback = function(v) Config.AutoFlee.Enabled = v end,
})

KillerTab:CreateSlider({
    Name = "Flee Distance",
    Range = {10, 200},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = 50,
    Flag = "FleeDistance",
    Callback = function(v) Config.AutoFlee.DetectDistance = v end,
})

KillerTab:CreateToggle({
    Name = "God Mode (Anti KnockDown)",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(v) Config.PlayerMods.GodMode = v end,
})

print("[TIARHUB] BAGIAN 3 DONE")-- ═══════════════════════════════════════════
--   BAGIAN 4: Settings + Emote + Finalize
--   Rayfield Gen2
-- ═══════════════════════════════════════════
print("[TIARHUB] Bagian 4 loading...")

-- ═══════════════════════════════════════════
--  TAB SETTINGS — Emote
-- ═══════════════════════════════════════════
SettingTab:CreateSection("Emote")

local EmoteList = {
    "Mannrobics", "Arm Swing", "Schadenfreude", "Kyoufuu",
    "Backflip", "Griddy", "Friday Night", "Floating Rest",
    "OnePlays", "Quick Combo", "WarCry", "Wave"
}

local function playEmote(name)
    if EmoteRemote then
        pcall(function() EmoteRemote:FireServer(name) end)
        notify("Emote", "Playing: "..name, 2)
    end
end

SettingTab:CreateDropdown({
    Name = "Select Emote",
    Options = EmoteList,
    CurrentOption = {"Mannrobics"},
    Flag = "EmoteSelect",
    Callback = function(opt)
        Config.Emote.Selected = type(opt) == "table" and opt[1] or opt
    end,
})

SettingTab:CreateButton({
    Name = "Play Emote",
    Callback = function() playEmote(Config.Emote.Selected) end,
})

-- ═══════════════════════════════════════════
--  TAB SETTINGS — Menu
-- ═══════════════════════════════════════════
SettingTab:CreateSection("Menu Settings")

SettingTab:CreateButton({
    Name = "Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/tiarhub")
        notify("Discord", "Link copied!", 3)
    end,
})

SettingTab:CreateButton({
    Name = "Unload Script",
    Callback = function()
        pcall(function() Rayfield:Destroy() end)
    end,
})

-- ═══════════════════════════════════════════
--  TAB SETTINGS — Info
-- ═══════════════════════════════════════════
SettingTab:CreateSection("Info")

SettingTab:CreateParagraph({
    Title = "Keybind",
    Content = "RightShift = Toggle Menu\nRight Click (hold) = Aimlock\nV = Moonwalk",
})

SettingTab:CreateParagraph({
    Title = "About",
    Content = "TIARHUB x Violence District\nRayfield Gen2 Edition\nVersion 1.0",
})

-- ═══════════════════════════════════════════
--  STATS PANEL (Watermark)
-- ═══════════════════════════════════════════
local statsGui = Instance.new("ScreenGui")
statsGui.Name = "TiarStats"
statsGui.ResetOnSpawn = false
statsGui.Parent = PG

local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(0, 160, 0, 95)
statsFrame.Position = UDim2.new(1, -175, 0, 20)
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
sTitle.Text = "TIARHUB STATS"
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
    local f, lt, fps = 0, tick(), 0
    RunService.RenderStepped:Connect(function()
        f += 1
        if tick() - lt >= 1 then
            fps = f; f = 0; lt = tick()
            local ok, p = pcall(function()
                return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            sText.Text = string.format("FPS: %d\nPING: %d ms\nPLAYERS: %d", fps, ok and p or 0, #Players:GetPlayers())
        end
    end)
end)

-- ═══════════════════════════════════════════
--  NOTIF WELCOME
-- ═══════════════════════════════════════════
task.spawn(function()
    task.wait(0.5)
    notify("TIARHUB", "All features loaded!", 5)
    task.wait(1.5)
    notify("Tip", "RightShift = Toggle Menu", 4)
end)

-- ═══════════════════════════════════════════
--  CLEANUP
-- ═══════════════════════════════════════════
game:BindToClose(function()
    if SelfCircle then SelfCircle:Destroy() end
    if ParryCircle then ParryCircle:Destroy() end
end)

-- ═══════════════════════════════════════════
--  FINAL PRINT
-- ═══════════════════════════════════════════
print("==========================================")
print("  TIARHUB x VIOLENCE DISTRICT")
print("  Rayfield Gen2 Edition")
print("  BAGIAN 1-4 LOADED")
print("  RightShift = Toggle Menu")
print("==========================================")
print("[TIARHUB] SCRIPT COMPLETE")
