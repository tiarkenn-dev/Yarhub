-- YARHUB ULTIMATE FINAL
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local WS = game:GetService("Workspace")
local RS = game:GetService("RunService")
local GS = game:GetService("GuiService")
local VIM = game:GetService("VirtualInputManager")
local Rep = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local Cam = WS.CurrentCamera
local isMobile = UIS.TouchEnabled

_G.SkillOn = false
_G.SkillMode = "Perfect"
_G.Fullbright = false
_G.NoFog = false
_G.AvaTarget = ""

local OrigLight = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart
}

task.spawn(function()
    while task.wait(0.3) do
        if _G.Fullbright then
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
            Lighting.GlobalShadows = false
        end
        if _G.NoFog then
            Lighting.FogEnd = 9e9
            Lighting.FogStart = 0
        end
    end
end)

local function ToggleFullbright(state)
    _G.Fullbright = state
    if not state then
        Lighting.Brightness = OrigLight.Brightness
        Lighting.ClockTime = OrigLight.ClockTime
        Lighting.Ambient = OrigLight.Ambient
        Lighting.OutdoorAmbient = OrigLight.OutdoorAmbient
        Lighting.GlobalShadows = OrigLight.GlobalShadows
    end
end

local function ToggleNoFog(state)
    _G.NoFog = state
    if not state then
        Lighting.FogEnd = OrigLight.FogEnd
        Lighting.FogStart = OrigLight.FogStart
    end
end

local FOV = { Enabled = false, Value = 70, Default = Cam.FieldOfView }

RS.RenderStepped:Connect(function()
    if FOV.Enabled and Cam and Cam.FieldOfView ~= FOV.Value then
        Cam.FieldOfView = FOV.Value
    end
end)

local function ToggleFOV(state)
    FOV.Enabled = state
    if not state and Cam then Cam.FieldOfView = FOV.Default end
end

local function IsKiller(p)
    if p:GetAttribute("Role") == "Killer" then return true end
    if p.Team and p.Team.Name == "Killer" then return true end
    return false
end-- AUTO PARRY
local AutoParry = { Enabled = false, Range = 15, Debounce = 0.2, LastParry = 0, ShowCircle = true }

local KillerAnims = {
    ["rbxassetid://105374834496520"] = true, ["rbxassetid://113255068724446"] = true,
    ["rbxassetid://118907603246885"] = true, ["rbxassetid://129784271201071"] = true,
    ["rbxassetid://117042998468241"] = true, ["rbxassetid://122812055447896"] = true,
    ["rbxassetid://78935059863801"] = true, ["rbxassetid://74968262036854"] = true,
    ["rbxassetid://78432063483146"] = true, ["rbxassetid://132817836308238"] = true,
    ["rbxassetid://133963973694098"] = true, ["rbxassetid://111920872708571"] = true,
    ["rbxassetid://80411309607666"] = true, ["rbxassetid://98163597193511"] = true,
    ["rbxassetid://82666958311998"] = true, ["rbxassetid://110355011987939"] = true,
    ["rbxassetid://139369275981139"] = true, ["rbxassetid://135002183282873"] = true,
    ["rbxassetid://121216847022485"] = true, ["rbxassetid://130593238885843"] = true,
    ["rbxassetid://117070354890871"] = true, ["rbxassetid://106871536134254"] = true,
    ["rbxassetid://138720291317243"] = true,
}

local ParryCircle = nil

RS.RenderStepped:Connect(function()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root or not AutoParry.ShowCircle then
        if ParryCircle then ParryCircle:Destroy(); ParryCircle = nil end
        return
    end
    if not ParryCircle then
        ParryCircle = Instance.new("Part")
        ParryCircle.Shape = Enum.PartType.Cylinder
        ParryCircle.Anchored = true
        ParryCircle.CanCollide = false
        ParryCircle.Material = Enum.Material.Neon
        ParryCircle.Name = "Yarhub_ParryCircle"
        ParryCircle.Color = Color3.fromRGB(0, 150, 255)
        ParryCircle.Transparency = 0.7
        ParryCircle.Parent = WS
    end
    local yOff = root.Size.Y / 2 + 1.5
    ParryCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOff, 0)) * CFrame.Angles(0, 0, math.rad(90))
    ParryCircle.Size = Vector3.new(0.2, AutoParry.Range * 2, AutoParry.Range * 2)
end)

local function PressParry()
    local current = PG
    for seg in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(seg)
    end
    if current and current:IsA("GuiObject") then
        local p, s = current.AbsolutePosition, current.AbsoluteSize
        local ins = GS:GetGuiInset()
        local x = p.X + s.X/2 + ins.X
        local y = p.Y + s.Y/2 + ins.Y
        pcall(function() VIM:SendTouchEvent(8823, 0, x, y) end)
        task.wait(0.01)
        pcall(function() VIM:SendTouchEvent(8823, 2, x, y) end)
    elseif not isMobile then
        pcall(function()
            VIM:SendMouseButtonEvent(0, 0, 1, true, game, 0)
            task.wait()
            VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0)
        end)
    end
end

local function DoParry()
    local now = tick()
    if now - AutoParry.LastParry < AutoParry.Debounce then return end
    AutoParry.LastParry = now
    task.spawn(PressParry)
end

local hookedKillers = {}
local function HookKiller(char)
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
        if KillerAnims["rbxassetid://" .. id] then
            local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            local enemyRoot = char:FindFirstChild("HumanoidRootPart")
            if myRoot and enemyRoot then
                if (enemyRoot.Position - myRoot.Position).Magnitude <= AutoParry.Range then
                    DoParry()
                end
            end
        end
    end)
end

task.spawn(function()
    while task.wait(2) do
        if AutoParry.Enabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and IsKiller(p) then
                    HookKiller(p.Character)
                end
            end
        end
    end
end)

-- AIMBOT + WALLCHECK
local GunAim = {
    Enabled = false, Holding = false, TargetMode = "Killer",
    Strength = 1, Predict = true, PredictStrength = 0.12,
    FOV = 250, WallCheck = true,
}
local AttackAim = {
    Enabled = false, Holding = false, Strength = 1,
    Predict = true, PredictStrength = 0.12, FOV = 250, WallCheck = true,
}

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = true; AttackAim.Holding = true
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = false; AttackAim.Holding = false
    end
end)

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist

local function IsVisible(part)
    if not GunAim.WallCheck then return true end
    if not part then return false end
    RayParams.FilterDescendantsInstances = { LP.Character }
    local origin = Cam.CFrame.Position
    local result = WS:Raycast(origin, part.Position - origin, RayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

local function GetGunTarget()
    local center = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
    local closest, shortest = nil, GunAim.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team then
            local valid = false
            if GunAim.TargetMode == "Killer" and p.Team.Name == "Killer" then valid = true
            elseif GunAim.TargetMode == "Survivor" and p.Team.Name == "Survivors" then valid = true end
            if valid then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 and IsVisible(hrp) then
                    local pos, vis = Cam:WorldToViewportPoint(hrp.Position)
                    if vis then
                        local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if d < shortest then shortest = d; closest = hrp end
                    end
                end
            end
        end
    end
    return closest
end

local function GetAttackTarget()
    local center = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
    local closest, shortest = nil, AttackAim.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Team and p.Team.Name == "Survivors" and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 and IsVisible(hrp) then
                local pos, vis = Cam:WorldToViewportPoint(hrp.Position)
                if vis then
                    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if d < shortest then shortest = d; closest = hrp end
                end
            end
        end
    end
    return closest
end

RS.RenderStepped:Connect(function()
    if GunAim.Enabled and GunAim.Holding then
        local t = GetGunTarget()
        if t then
            local pos = t.Position
            if GunAim.Predict then
                pos = pos + (t.AssemblyLinearVelocity * GunAim.PredictStrength)
            end
            Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, pos), GunAim.Strength)
        end
    end
    if AttackAim.Enabled and AttackAim.Holding then
        local t = GetAttackTarget()
        if t then
            local pos = t.Position
            if AttackAim.Predict then
                pos = pos + (t.AssemblyLinearVelocity * AttackAim.PredictStrength)
            end
            Cam.CFrame = CFrame.new(Cam.CFrame.Position, pos)
        end
    end
end)-- SILENT AIM PISTOL
local SilentAim = {
    Enabled = false, TargetMode = "Killer", FOV = 150, WallCheck = true,
}

local function SilentIsVisible(part)
    if not SilentAim.WallCheck then return true end
    if not part then return false end
    RayParams.FilterDescendantsInstances = { LP.Character }
    local result = WS:Raycast(Cam.CFrame.Position, part.Position - Cam.CFrame.Position, RayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

local function GetSilentTarget()
    local center = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
    local closest, shortest = nil, SilentAim.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team then
            local valid = false
            if SilentAim.TargetMode == "Killer" and p.Team.Name == "Killer" then valid = true
            elseif SilentAim.TargetMode == "Survivor" and p.Team.Name == "Survivors" then valid = true end
            if valid then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 and SilentIsVisible(hrp) then
                    local pos, vis = Cam:WorldToViewportPoint(hrp.Position)
                    if vis then
                        local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if d < shortest then shortest = d; closest = hrp end
                    end
                end
            end
        end
    end
    return closest
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if SilentAim.Enabled and method == "FireServer" then
        local n = self.Name:lower()
        if n:find("gun") or n:find("pistol") or n:find("shoot") or n:find("fire") then
            local target = GetSilentTarget()
            if target then
                local args = {...}
                args[1] = target
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end)

-- FAST VAULT
local FastVault = { Enabled = false, Speed = 30 }
RS.Heartbeat:Connect(function()
    if not FastVault.Enabled then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * 8)
    local hit = WS:FindPartOnRayWithIgnoreList(ray, {char})
    if hit and (hit.Name == "Window" or hit.Name == "Pallet" or hit.Name == "Palletwrong") then
        if hum.WalkSpeed ~= FastVault.Speed then hum.WalkSpeed = FastVault.Speed end
    else
        if hum.WalkSpeed == FastVault.Speed then hum.WalkSpeed = 16 end
    end
end)

-- GOD MODE
local GodMode = { Enabled = false }
task.spawn(function()
    while task.wait(0.3) do
        if not GodMode.Enabled then continue end
        local char = LP.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
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
    end
end)

-- MOVEMENT
local Movement = {
    SpeedEnabled = false, SpeedValue = 20,
    JumpEnabled = false, JumpValue = 50,
    Noclip = false, NoclipConn = nil,
}

task.spawn(function()
    while task.wait(0.1) do
        local char = LP.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then continue end
        if Movement.SpeedEnabled then
            if hum.WalkSpeed ~= Movement.SpeedValue then
                hum.WalkSpeed = Movement.SpeedValue
            end
        end
        if Movement.JumpEnabled then
            if hum.JumpPower ~= Movement.JumpValue then
                hum.JumpPower = Movement.JumpValue
                hum.UseJumpPower = true
            end
        end
    end
end)

local function NoclipPart(p)
    if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
end

local function EnableNoclip()
    if Movement.NoclipConn then Movement.NoclipConn:Disconnect() end
    Movement.NoclipConn = RS.Stepped:Connect(function()
        local char = LP.Character
        if char and Movement.Noclip then
            for _, p in ipairs(char:GetDescendants()) do pcall(NoclipPart, p) end
        end
    end)
end

local function DisableNoclip()
    if Movement.NoclipConn then Movement.NoclipConn:Disconnect(); Movement.NoclipConn = nil end
    local char = LP.Character
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
    end-- COPY AVATAR
local AvatarStealer = { Original = nil, CurrentUserId = nil }

local function RemoveClothes(char)
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("Accessory") or v:IsA("Shirt")
        or v:IsA("Pants") or v:IsA("ShirtGraphic") then
            pcall(function() v:Destroy() end)
        end
    end
end

local function CopyAvatar(username)
    if not username or username == "" then
        Rayfield:Notify({Title="Yarhub", Content="Isi username dulu!", Duration=2})
        return
    end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    AvatarStealer.Original = hum:GetAppliedDescription()
    local ok, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    if not ok then
        Rayfield:Notify({Title="Yarhub", Content="User tidak ditemukan!", Duration=3})
        return
    end
    AvatarStealer.CurrentUserId = userId
    task.spawn(function()
        local ok2, desc = pcall(function()
            return Players:GetHumanoidDescriptionFromUserId(userId)
        end)
        if not ok2 or not desc then return end
        RemoveClothes(char)
        task.wait(0.2)
        local success = false
        pcall(function() hum:ApplyDescriptionClientServer(desc); success = true end)
        if not success then
            pcall(function() hum:ApplyDescription(desc); success = true end)
        end
        if success then
            Rayfield:Notify({Title="Yarhub", Content="✅ Avatar dicopy: "..username, Duration=3})
        end
    end)
end

local function ResetAvatar()
    if not AvatarStealer.Original then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        RemoveClothes(char)
        pcall(function() hum:ApplyDescriptionClientServer(AvatarStealer.Original) end)
        AvatarStealer.CurrentUserId = nil
        Rayfield:Notify({Title="Yarhub", Content="Avatar di-reset!", Duration=3})
    end
end

-- AUTO SKILLCHECK
local Skill = { LastGoal = nil, Clicked = false, WasActive = false }
local SkillBusy = false

local function PressSkill()
    if isMobile then
        local btn = PG:FindFirstChild("check", true)
        if btn and btn:IsA("GuiObject") then
            local p, s = btn.AbsolutePosition, btn.AbsoluteSize
            local ins = GS:GetGuiInset()
            local x = p.X + s.X/2 + ins.X
            local y = p.Y + s.Y/2 + ins.Y
            pcall(function() VIM:SendTouchEvent(8822, 0, x, y) end)
            task.wait(0.01)
            pcall(function() VIM:SendTouchEvent(8822, 2, x, y) end)
        end
    else
        pcall(function() VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game) end)
        task.wait(0.01)
        pcall(function() VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game) end)
    end
end

local function GetCheck()
    for _, n in ipairs({"SkillCheckPromptGui", "SkillCheckPromptGui-con"}) do
        local g = PG:FindFirstChild(n, true)
        if g then
            local c = g:FindFirstChild("Check", true)
            if c and c.Visible then
                local l = c:FindFirstChild("Line", true)
                local go = c:FindFirstChild("Goal", true)
                if l and go then return l, go end
            end
        end
    end
end

local function AngDiff(a, b)
    local d = b - a
    if d > 180 then d = d - 360 end
    if d < -180 then d = d + 360 end
    return d
end

local function UpdateSkill()
    if SkillBusy then return end
    local line, goal = GetCheck()
    if not (line and goal) then
        Skill.LastGoal = nil; Skill.Clicked = false; Skill.WasActive = false
        return
    end
    local lr = line.Rotation % 360
    local gr = goal.Rotation % 360
    if _G.SkillMode == "Instan" then
        if not Skill.WasActive then
            Skill.WasActive = true
            SkillBusy = true
            task.spawn(function()
                PressSkill()
                task.wait(0.05)
                SkillBusy = false
            end)
        end
        Skill.LastGoal = gr
        return
    end
    if not Skill.WasActive then
        Skill.WasActive = true; Skill.LastGoal = gr; Skill.Clicked = false
        return
    end
    if Skill.LastGoal and math.abs(AngDiff(Skill.LastGoal, gr)) > 5 then
        Skill.Clicked = false
    end
    Skill.LastGoal = gr
    if Skill.Clicked then return end
    local sR = (gr + 102) % 360
    local eR = (gr + 116) % 360
    local inZone
    if sR > eR then inZone = (lr >= sR or lr <= eR)
    else inZone = (lr >= sR and lr <= eR) end
    if inZone then
        Skill.Clicked = true
        SkillBusy = true
        task.spawn(function()
            PressSkill()
            task.wait(0.05)
            SkillBusy = false
        end)
    end
end

RS.RenderStepped:Connect(function()
    if _G.SkillOn then UpdateSkill() end
end)

-- FPS/PING
local FPSPing = { Enabled = true, FPS = 0, Ping = 0, Frames = 0, LastTick = tick() }
local FPSScreenGui = Instance.new("ScreenGui")
FPSScreenGui.Name = "Yarhub_FPSPing"
FPSScreenGui.ResetOnSpawn = false
FPSScreenGui.Parent = CoreGui

local FPSFrame = Instance.new("Frame")
FPSFrame.Size = UDim2.new(0, 200, 0, 30)
FPSFrame.Position = UDim2.new(0, 10, 0, 40)
FPSFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
FPSFrame.BackgroundTransparency = 0.3
FPSFrame.BorderSizePixel = 0
FPSFrame.Parent = FPSScreenGui
Instance.new("UICorner", FPSFrame).CornerRadius = UDim.new(0, 8)

local FPSStroke = Instance.new("UIStroke", FPSFrame)
FPSStroke.Color = Color3.fromRGB(0, 120, 220)
FPSStroke.Thickness = 1.5

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1, 0, 1, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 14
FPSLabel.Text = "Yarhub | FPS: 60 | Ping: 0 ms"
FPSLabel.Parent = FPSFrame

RS.RenderStepped:Connect(function()
    if not FPSPing.Enabled then FPSFrame.Visible = false; return end
    FPSFrame.Visible = true
    FPSPing.Frames = FPSPing.Frames + 1
    if tick() - FPSPing.LastTick >= 1 then
        FPSPing.FPS = FPSPing.Frames
        FPSPing.Frames = 0
        FPSPing.LastTick = tick()
        pcall(function()
            FPSPing.Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        FPSLabel.Text = string.format("Yarhub | FPS: %d | Ping: %d ms", FPSPing.FPS, FPSPing.Ping)
    end
end)-- AUTO FLEE
local AutoFlee = { Enabled = false, Range = 50, Cooldown = 0.5, LastFlee = 0 }

local function GetNearestKiller()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and IsKiller(p) then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - root.Position).Magnitude
                if d < shortest then shortest = d; closest = hrp end
            end
        end
    end
    return closest, shortest
end

local function GetFarthestGenPoint(killerRoot)
    if not killerRoot then return nil end
    local best, farthest = nil, 0
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("BasePart") and string.match(obj.Name, "^GeneratorPoint%d+$") then
            local d = (obj.Position - killerRoot.Position).Magnitude
            if d > farthest then farthest = d; best = obj end
        end
    end
    return best
end

task.spawn(function()
    while task.wait(0.2) do
        if not AutoFlee.Enabled then continue end
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local killerRoot, dist = GetNearestKiller()
        if killerRoot and dist <= AutoFlee.Range and tick() - AutoFlee.LastFlee > AutoFlee.Cooldown then
            local point = GetFarthestGenPoint(killerRoot)
            if point then
                AutoFlee.LastFlee = tick()
                root.CFrame = point.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end)

-- AUTO WIGGLE
local AutoWiggle = { Enabled = false, Spam = 5 }
local WiggleEvent = Rep:FindFirstChild("Remotes")
    and Rep.Remotes:FindFirstChild("Carry")
    and Rep.Remotes.Carry:FindFirstChild("SelfUnHookEvent")

task.spawn(function()
    while task.wait(0.2) do
        if not AutoWiggle.Enabled then continue end
        local char = LP.Character
        if not char then continue end
        local carried =
            (char:FindFirstChild("IsCarried") and char.IsCarried.Value) or
            (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)
        if carried and WiggleEvent then
            for i = 1, AutoWiggle.Spam do
                pcall(function() WiggleEvent:FireServer() end)
            end
        end
    end
end)

-- ESP
local ESP = {
    On = false, SV = true, KL = true, GN = true,
    SVc = Color3.fromRGB(0,255,0), KLc = Color3.fromRGB(255,0,0), GNc = Color3.fromRGB(255,105,180),
    ShowName = true, ShowDist = true, ShowProg = true,
    FillT = 1, OutT = 0, TextSize = 14, MaxDist = 500, UpdateRate = 0.6,
}

local espFolder = Instance.new("Folder")
espFolder.Name = "Yarhub_ESP"
espFolder.Parent = CoreGui

local active = {}
local mapCache = nil

local function GetMap()
    if mapCache and mapCache.Parent then return mapCache end
    mapCache = WS:FindFirstChild("Map")
    return mapCache
end

local function MakeHL(target, color, key, isChar)
    if active[key] and active[key].HL then
        local h = active[key].HL
        h.FillColor = color; h.OutlineColor = color
        return active[key]
    end
    local h = Instance.new("Highlight")
    h.Adornee = target
    h.FillColor = color; h.OutlineColor = color
    h.FillTransparency = isChar and ESP.FillT or 1
    h.OutlineTransparency = ESP.OutT
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = espFolder
    active[key] = active[key] or {}
    active[key].HL = h
    return active[key]
end

local function MakeLbl(target, color, key)
    local e = active[key]
    if e and e.BB then
        e.BB.Parent = espFolder
        if e.Lbl then e.Lbl.TextSize = ESP.TextSize; e.Lbl.TextColor3 = color end
        return e
    end
    local bb = Instance.new("BillboardGui")
    bb.Adornee = target
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 100, 0, 30)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.LightInfluence = 0
    bb.MaxDistance = ESP.MaxDist
    bb.Parent = espFolder
    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(1, 0, 0, 20)
    lb.BackgroundTransparency = 1
    lb.TextColor3 = color
    lb.TextStrokeTransparency = 0
    lb.TextStrokeColor3 = Color3.new(0,0,0)
    lb.TextSize = ESP.TextSize
    lb.Font = Enum.Font.GothamBold
    lb.Text = ""
    lb.Parent = bb
    local pg = Instance.new("Frame")
    pg.Size = UDim2.new(1, 0, 0, 5)
    pg.Position = UDim2.new(0, 0, 0, 22)
    pg.BackgroundColor3 = Color3.new(0,0,0)
    pg.BackgroundTransparency = 0.4
    pg.BorderSizePixel = 0
    pg.Visible = false
    pg.Parent = bb
    local pf = Instance.new("Frame")
    pf.Size = UDim2.new(0, 0, 1, 0)
    pf.BackgroundColor3 = color
    pf.BorderSizePixel = 0
    pf.Parent = pg
    active[key] = e or {}
    active[key].BB = bb
    active[key].Lbl = lb
    active[key].PB = pg
    active[key].PF = pf
    return active[key]
end

local function Clean(used)
    for k, e in pairs(active) do
        if not used[k] then
            if e.HL then e.HL:Destroy() end
            if e.BB then e.BB:Destroy() end
            active[k] = nil
        end
    end
end

local function GetProg(g)
    local v = g:GetAttribute("ProgressRepair") or g:GetAttribute("RepairProgress") or g:GetAttribute("Progress")
    if v then return math.clamp(v, 0, 100) end
    local po = g:FindFirstChild("Progress", true)
    if po and po:IsA("ValueBase") then return math.clamp(po.Value, 0, 100) end
    return 0
end

task.spawn(function()
    while true do
        task.wait(ESP.UpdateRate)
        if not ESP.On then
            for k, e in pairs(active) do
                if e.HL then e.HL:Destroy() end
                if e.BB then e.BB:Destroy() end
                active[k] = nil
            end
            task.wait(0.5)
            continue
        end
        local used = {}
        local camPos = Cam.CFrame.Position
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LP then continue end
            local c = p.Character
            if not c then continue end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            local h = c:FindFirstChildOfClass("Humanoid")
            if not (hrp and h and h.Health > 0) then continue end
            local dist = (hrp.Position - camPos).Magnitude
            if dist > ESP.MaxDist then continue end
            local killer = IsKiller(p)
            local col, show = nil, false
            if killer and ESP.KL then col = ESP.KLc; show = true
            elseif not killer and ESP.SV then col = ESP.SVc; show = true end
            if show then
                local k = "P_" .. p.UserId
                used[k] = true
                local e = MakeHL(c, col, k, true)
                if e.HL then e.HL.Adornee = c; e.HL.FillColor = col; e.HL.OutlineColor = col end
                if ESP.ShowName or ESP.ShowDist then
                    local le = MakeLbl(hrp, col, k)
                    if le.Lbl then
                        le.Lbl.TextColor3 = col
                        le.Lbl.TextSize = ESP.TextSize
                        local txt = ""
                        if ESP.ShowName and ESP.ShowDist then
                            txt = string.format("%s [%dm]", p.Name, math.floor(dist))
                        elseif ESP.ShowName then txt = p.Name
                        elseif ESP.ShowDist then txt = string.format("[%dm]", math.floor(dist)) end
                        le.Lbl.Text = txt
                        le.BB.Adornee = hrp
                    end
                end
            end
        end
        if ESP.GN then
            local m = GetMap()
            if m then
                for _, o in ipairs(m:GetDescendants()) do
                    if o:IsA("Model") and o.Name == "Generator" then
                        local k = "G_" .. o:GetDebugId()
                        used[k] = true
                        local col = ESP.GNc
                        local e = MakeHL(o, col, k, false)
                        if e.HL then e.HL.Adornee = o; e.HL.FillColor = col; e.HL.OutlineColor = col end
                        local mp = o:FindFirstChild("Main") or o:FindFirstChildWhichIsA("BasePart")
                        if mp and ESP.ShowProg then
                            local pr = GetProg(o)
                            local le = MakeLbl(mp, col, k)
                            if le.Lbl then
                                le.Lbl.TextColor3 = col
                                le.Lbl.TextSize = ESP.TextSize
                                le.Lbl.Text = string.format("GEN [%d%%]", math.floor(pr))
                                le.BB.Adornee = mp
                                if pr > 0 then
                                    le.PB.Visible = true
                                    le.PF.BackgroundColor3 = col
                                    le.PF.Size = UDim2.new(pr/100, 0, 1, 0)
                                else le.PB.Visible = false end
                            end
                        end
                    end
                end
            end
        end
        Clean(used)
    end
end)-- MOONWALK (KODINGAN KAMU)
local Moonwalk = {
    Enabled = false,
    ShowButton = true,
    SpamSpeed = 30,
    Intensity = 35,
    SlowSpeed = 13,
    UseSlow = true
}

local MoonwalkConnection = nil
local MoonwalkButton = nil
local MWLocked = false

local function getMWChar()
    local char = LP.Character
    if not char or not char.Parent then return nil end
    return char
end

local function getMWHum()
    local char = getMWChar()
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function stopMoonwalk()
    if MoonwalkConnection then
        MoonwalkConnection:Disconnect()
        MoonwalkConnection = nil
    end
    local hum = getMWHum()
    if hum then hum.WalkSpeed = 16 end
end

local function startMoonwalk()
    if MoonwalkConnection then
        MoonwalkConnection:Disconnect()
        MoonwalkConnection = nil
    end
    MoonwalkConnection = RS.RenderStepped:Connect(function()
        if not Moonwalk.Enabled then return end
        local char = getMWChar()
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not humanoid or not hrp or not cam then return end
        if Moonwalk.UseSlow then
            if humanoid.WalkSpeed ~= Moonwalk.SlowSpeed then
                humanoid.WalkSpeed = Moonwalk.SlowSpeed
            end
        end
        local look = cam.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit
            local baseCF = CFrame.new(hrp.Position, hrp.Position + flatLook)
            local angle = math.sin(tick() * Moonwalk.SpamSpeed) * Moonwalk.Intensity
            hrp.CFrame = baseCF * CFrame.Angles(0, math.rad(angle), 0)
            humanoid:Move(Vector3.new(0, 0, 1), true)
        end
    end)
end

local function setMoonwalk(state)
    Moonwalk.Enabled = state
    if state then startMoonwalk() else stopMoonwalk() end
end

local function createMoonwalkButton()
    if not PG or not PG.Parent then return end
    if MoonwalkButton then
        MoonwalkButton:Destroy()
        MoonwalkButton = nil
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "MoonwalkGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = CoreGui

    local btn = Instance.new("ImageButton")
    btn.Name = "MoonwalkButton"
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0.65, 0, 0.75, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.9
    btn.Image = "rbxassetid://93349170559446"
    btn.ImageTransparency = 0.1
    btn.Parent = gui

    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Parent = btn

    local dragging = false
    local dragStart
    local startPos

    btn.InputBegan:Connect(function(input)
        if MWLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging or MWLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(
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
    end)

    btn.Activated:Connect(function()
        setMoonwalk(not Moonwalk.Enabled)
        if Moonwalk.Enabled then
            stroke.Color = Color3.fromRGB(170, 0, 255)
            stroke.Transparency = 0.2
        else
            stroke.Color = Color3.fromRGB(255, 255, 255)
            stroke.Transparency = 0.8
        end
    end)

    MoonwalkButton = gui
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Moonwalk.Enabled then startMoonwalk() end
end)

if Moonwalk.ShowButton then
    createMoonwalkButton()
        end-- UI
local Win = Rayfield:CreateWindow({
   Name = "Yarhub",
   LoadingTitle = "Yarhub",
   LoadingSubtitle = "by Yarhub",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false,
   Theme = {
      AccentColor     = Color3.fromRGB(0, 120, 220),
      BackgroundColor = Color3.fromRGB(10, 20, 40),
      MainColor       = Color3.fromRGB(20, 40, 80),
      OutlineColor    = Color3.fromRGB(50, 130, 230),
      FontColor       = Color3.fromRGB(200, 230, 255),
   }
})

local MainT  = Win:CreateTab("Visual")
local LagT   = Win:CreateTab("Anti Lag")
local SkillT = Win:CreateTab("Skillcheck")
local ParryT = Win:CreateTab("Parry")
local AimT   = Win:CreateTab("Aimbot")
local EspT   = Win:CreateTab("ESP")
local MoveT  = Win:CreateTab("Movement")
local MwT    = Win:CreateTab("Moonwalk")
local AvaT   = Win:CreateTab("Avatar")
local InfoT  = Win:CreateTab("Informasi")

Rayfield:Notify({Title="Yarhub", Content="Semua fitur dimuat!", Duration=5})

MainT:CreateSection("Fullbright & Fog")
MainT:CreateToggle({Name="Fullbright", CurrentValue=false,
   Callback=function(v) ToggleFullbright(v) end})
MainT:CreateToggle({Name="No Fog", CurrentValue=false,
   Callback=function(v) ToggleNoFog(v) end})
MainT:CreateSection("FOV Changer")
MainT:CreateToggle({Name="Aktifkan FOV", CurrentValue=false,
   Callback=function(v) ToggleFOV(v) end})
MainT:CreateSlider({Name="FOV Value", Range={50,120}, Increment=1, CurrentValue=70,
   Callback=function(v) FOV.Value = v end})

LagT:CreateSection("Render")
LagT:CreateToggle({Name="Global Shadows OFF", CurrentValue=false,
   Callback=function(v) Lighting.GlobalShadows = not v end})
LagT:CreateToggle({Name="Atmosphere OFF", CurrentValue=false,
   Callback=function(v)
      for _,x in ipairs(Lighting:GetChildren()) do
         if x:IsA("Atmosphere") then x.Enabled = not v end
      end
   end})
LagT:CreateToggle({Name="Post-Effects OFF", CurrentValue=false,
   Callback=function(v)
      for _,x in ipairs(Lighting:GetChildren()) do
         if x:IsA("PostEffect") then x.Enabled = not v end
      end
   end})
LagT:CreateSection("Optimasi")
LagT:CreateButton({Name="Hapus Partikel", Callback=function()
   for _,x in ipairs(WS:GetDescendants()) do
      if x:IsA("ParticleEmitter") or x:IsA("Fire") or x:IsA("Smoke") then x.Enabled = false end
   end
end})
LagT:CreateButton({Name="Hapus Trails", Callback=function()
   for _,x in ipairs(WS:GetDescendants()) do
      if x:IsA("Trail") or x:IsA("Beam") then x.Enabled = false end
   end
end})
LagT:CreateButton({Name="Unlock FPS", Callback=function()
   pcall(function() setfpscap(999) end)
end})
LagT:CreateButton({Name="Garbage Collection", Callback=function()
   collectgarbage("collect")
end})
LagT:CreateButton({Name="Potato Mode", Callback=function()
   for _,x in ipairs(WS:GetDescendants()) do
      if x:IsA("BasePart") then
         x.Material = Enum.Material.SmoothPlastic
         x.CastShadow = false
      end
   end
   Lighting.GlobalShadows = false
end})

SkillT:CreateSection("Auto Skillcheck")
SkillT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v) _G.SkillOn = v end})
SkillT:CreateDropdown({Name="Mode", Options={"Instan","Perfect"},
   CurrentOption={"Perfect"},
   Callback=function(O) _G.SkillMode = O[1] end})

ParryT:CreateSection("Auto Parry")
ParryT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v) AutoParry.Enabled = v end})
ParryT:CreateSlider({Name="Jarak", Range={5,30}, Increment=1, CurrentValue=15,
   Callback=function(v) AutoParry.Range = v end})
ParryT:CreateToggle({Name="Lingkaran Visual", CurrentValue=true,
   Callback=function(v) AutoParry.ShowCircle = v end})

AimT:CreateSection("Gun Aimbot")
AimT:CreateToggle({Name="Aktifkan Gun Aimbot", CurrentValue=false,
   Callback=function(v) GunAim.Enabled = v end})
AimT:CreateDropdown({Name="Target", Options={"Killer","Survivor"},
   CurrentOption={"Killer"}, Callback=function(O) GunAim.TargetMode = O[1] end})
AimT:CreateSlider({Name="Strength", Range={0.05,1}, Increment=0.05, CurrentValue=1,
   Callback=function(v) GunAim.Strength = v end})
AimT:CreateSlider({Name="FOV", Range={50,500}, Increment=10, CurrentValue=250,
   Callback=function(v) GunAim.FOV = v end})
AimT:CreateToggle({Name="Wallcheck", CurrentValue=true,
   Callback=function(v) GunAim.WallCheck = v end})

AimT:CreateSection("Attack Aimbot")
AimT:CreateToggle({Name="Aktifkan", CurrentValue=false,
   Callback=function(v) AttackAim.Enabled = v end})
AimT:CreateSlider({Name="Strength Attack", Range={0.05,1}, Increment=0.05, CurrentValue=1,
   Callback=function(v) AttackAim.Strength = v end})
AimT:CreateToggle({Name="Wallcheck Attack", CurrentValue=true,
   Callback=function(v) AttackAim.WallCheck = v end})

AimT:CreateSection("Silent Aim Pistol ⚠️")
AimT:CreateToggle({Name="Aktifkan Silent Aim", CurrentValue=false,
   Callback=function(v)
      SilentAim.Enabled = v
      if v then Rayfield:Notify({Title="⚠️ Silent Aim", Content="Risiko tinggi!", Duration=4}) end
   end})
AimT:CreateDropdown({Name="Target", Options={"Killer","Survivor"},
   CurrentOption={"Killer"}, Callback=function(O) SilentAim.TargetMode = O[1] end})
AimT:CreateSlider({Name="FOV", Range={50,500}, Increment=10, CurrentValue=150,
   Callback=function(v) SilentAim.FOV = v end})
AimT:CreateToggle({Name="Wallcheck", CurrentValue=true,
   Callback=function(v) SilentAim.WallCheck = v end})

AimT:CreateSection("Fast Vault")
AimT:CreateToggle({Name="Aktifkan Fast Vault", CurrentValue=false,
   Callback=function(v) FastVault.Enabled = v end})
AimT:CreateSlider({Name="Vault Speed", Range={16,50}, Increment=2, CurrentValue=30,
   Callback=function(v) FastVault.Speed = v end})

EspT:CreateSection("Target")
EspT:CreateToggle({Name="Aktifkan ESP", CurrentValue=false,
   Callback=function(v) ESP.On = v end})
EspT:CreateToggle({Name="Survivor (Hijau)", CurrentValue=true,
   Callback=function(v) ESP.SV = v end})
EspT:CreateToggle({Name="Killer (Merah)", CurrentValue=true,
   Callback=function(v) ESP.KL = v end})
EspT:CreateToggle({Name="Generator (Pink)", CurrentValue=true,
   Callback=function(v) ESP.GN = v end})
EspT:CreateSection("Ukuran")
EspT:CreateSlider({Name="Ukuran Text", Range={8,32}, Increment=1, CurrentValue=14,
   Callback=function(v) ESP.TextSize = v end})
EspT:CreateSlider({Name="Jarak Max", Range={50,2000}, Increment=50, CurrentValue=500,
   Callback=function(v) ESP.MaxDist = v end})
EspT:CreateSection("Warna")
EspT:CreateColorPicker({Name="Survivor", Color=Color3.fromRGB(0,255,0),
   Callback=function(c) ESP.SVc = c end})
EspT:CreateColorPicker({Name="Killer", Color=Color3.fromRGB(255,0,0),
   Callback=function(c) ESP.KLc = c end})
EspT:CreateColorPicker({Name="Generator", Color=Color3.fromRGB(255,105,180),
   Callback=function(c) ESP.GNc = c end})

MoveT:CreateSection("God Mode")
MoveT:CreateToggle({Name="Aktifkan God Mode ⚠️", CurrentValue=false,
   Callback=function(v)
      GodMode.Enabled = v
      if v then Rayfield:Notify({Title="⚠️ God Mode", Content="Risiko ban!", Duration=4}) end
   end})

MoveT:CreateSection("Speed & Jump")
MoveT:CreateToggle({Name="WalkSpeed ON", CurrentValue=false,
   Callback=function(v) Movement.SpeedEnabled = v end})
MoveT:CreateSlider({Name="WalkSpeed Value", Range={16,100}, Increment=2, CurrentValue=20,
   Callback=function(v) Movement.SpeedValue = v end})
MoveT:CreateToggle({Name="JumpPower ON", CurrentValue=false,
   Callback=function(v) Movement.JumpEnabled = v end})
MoveT:CreateSlider({Name="JumpPower Value", Range={50,200}, Increment=5, CurrentValue=50,
   Callback=function(v) Movement.JumpValue = v end})

MoveT:CreateSection("Noclip")
MoveT:CreateToggle({Name="Noclip", CurrentValue=false,
   Callback=function(v)
      Movement.Noclip = v
      if v then EnableNoclip() else DisableNoclip() end
   end})

MoveT:CreateSection("Auto Flee")
MoveT:CreateToggle({Name="Aktifkan Auto Flee ⚠️", CurrentValue=false,
   Callback=function(v) AutoFlee.Enabled = v end})
MoveT:CreateSlider({Name="Detect Range", Range={20,100}, Increment=5, CurrentValue=50,
   Callback=function(v) AutoFlee.Range = v end})

MoveT:CreateSection("Auto Wiggle")
MoveT:CreateToggle({Name="Aktifkan Auto Wiggle", CurrentValue=false,
   Callback=function(v) AutoWiggle.Enabled = v end})
MoveT:CreateSlider({Name="Spam per Detik", Range={1,20}, Increment=1, CurrentValue=5,
   Callback=function(v) AutoWiggle.Spam = v end})

MwT:CreateSection("Moonwalk")
MwT:CreateToggle({Name="Aktifkan Moonwalk", CurrentValue=false,
   Callback=function(v)
      setMoonwalk(v)
      Rayfield:Notify({Title="Yarhub", Content=v and "Moonwalk ON" or "Moonwalk OFF", Duration=2})
   end})
MwT:CreateToggle({Name="Tampilkan Tombol MW", CurrentValue=true,
   Callback=function(v)
      Moonwalk.ShowButton = v
      if v then
         createMoonwalkButton()
      else
         if MoonwalkButton then MoonwalkButton:Destroy(); MoonwalkButton = nil end
      end
   end})
MwT:CreateToggle({Name="🔒 Lock Tombol MW", CurrentValue=false,
   Callback=function(v)
      MWLocked = v
      Rayfield:Notify({Title="Yarhub", Content=v and "Tombol DILOCK" or "Tombol UNLOCK", Duration=2})
   end})
MwT:CreateSlider({Name="Spam Speed", Range={1,50}, Increment=1, CurrentValue=30,
   Callback=function(v) Moonwalk.SpamSpeed = v end})
MwT:CreateSlider({Name="Intensity", Range={1,50}, Increment=1, CurrentValue=35,
   Callback=function(v) Moonwalk.Intensity = v end})
MwT:CreateSlider({Name="Slow Speed", Range={1,30}, Increment=1, CurrentValue=13,
   Callback=function(v) Moonwalk.SlowSpeed = v end})
MwT:CreateToggle({Name="Use Slow Speed", CurrentValue=true,
   Callback=function(v) Moonwalk.UseSlow = v end})

AvaT:CreateSection("Copy Avatar")
AvaT:CreateInput({
   Name = "Username Target",
   PlaceholderText = "Masukkan username...",
   RemoveTextAfterFocusLost = false,
   Callback = function(text) _G.AvaTarget = text end,
})
AvaT:CreateButton({Name="Copy Avatar", Callback=function()
   if _G.AvaTarget then CopyAvatar(_G.AvaTarget) end
end})
AvaT:CreateButton({Name="Reset Avatar", Callback=function() ResetAvatar() end})

InfoT:CreateSection("FPS/Ping")
InfoT:CreateToggle({Name="Tampilkan FPS/Ping", CurrentValue=true,
   Callback=function(v) FPSPing.Enabled = v end})
InfoT:CreateSection("Tentang")
InfoT:CreateParagraph({
   Title = "Yarhub Ultimate",
   Content = "Fitur Lengkap:\n" ..
             "- Anti Lag + Fullbright + No Fog + FOV\n" ..
             "- Auto Skillcheck (2 Mode)\n" ..
             "- Auto Parry + Circle\n" ..
             "- Aimbot + Wallcheck\n" ..
             "- Silent Aim Pistol ⚠️\n" ..
             "- Fast Vault\n" ..
             "- God Mode ⚠️\n" ..
             "- Movement (Speed/Jump/NoClip)\n" ..
             "- Auto Flee + Auto Wiggle\n" ..
             "- ESP (Player + Generator)\n" ..
             "- Moonwalk + Lock Tombol\n" ..
             "- Copy Avatar\n" ..
             "- FPS/Ping"
})
