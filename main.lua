-- =========================================================
-- BAGIAN 4/4 : ISI TAB + MAIN LOOP
-- =========================================================

-- =========================================================
-- TAB 1 : INFO
-- =========================================================
local tabInfo = CreateTab("Info", "ℹ️", 1, function()
    CreateSection("Script Info", "📋")
    CreateLabel("RoooorHub Ultimate Killer", Config.ACCENT2)
    CreateLabel("Status: Active", Config.SUCCESS)
    CreateLabel("Dev: Roooor", Config.TEXT)

    CreateSection("FPS/Ping", "🌊")
    CreateToggle("Show FPS/Ping", true, function(state)
        State.Stats.ShowWatermark = state
        FPSLabel.Visible = state
    end)

    CreateSection("Floating Buttons", "🔘")
    CreateToggle("Show Aimlock Button", false, function(state)
        ToggleAimlockButton(state)
    end)
    CreateToggle("Show Moonwalk Button", false, function(state)
        ToggleMoonwalkButton(state)
    end)
end)

-- =========================================================
-- TAB 2 : KILLER
-- =========================================================
local tabKiller = CreateTab("Killer", "🔪", 2, function()
    CreateSection("Aimlock", "🎯")
    CreateToggle("Enable Aimlock", false, function(state)
        State.Aimlock.Enabled = state
        if state then StartAimlock() end
    end)
    CreateDropdown("Target", {"Survivor", "Killer"}, "Survivor", function(v) State.Aimlock.Target = v end)
    CreateDropdown("Aim Part", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(v) State.Aimlock.AimPart = v end)
    CreateSlider("FOV", 50, 1000, 250, function(v) State.Aimlock.FOV = v end)
    CreateSlider("Radius", 50, 1000, 500, function(v) State.Aimlock.Radius = v end)
    CreateSlider("Prediction", 0, 1, 0.12, function(v) State.Aimlock.Prediction = v end)
    CreateSlider("Smoothness", 0.05, 1, 0.5, function(v) State.Aimlock.Smoothness = v end)

    CreateSection("Aimlock Button", "🎯")
    CreateToggle("Show Aimlock Button", false, function(state) ToggleAimlockButton(state) end)
    CreateToggle("🔒 Lock Aimlock", false, function(state)
        State.FloatingButtons.Aimlock.Locked = state
        UpdateButtonLockStatus("Aimlock")
    end)
    CreateButton("🔄 Reset Posisi Aimlock", function() ResetButtonPosition("Aimlock") end)

    CreateSection("Auto Attack", "⚔️")
    CreateToggle("Auto Spam Attack", false, function(state) State.AutoSpamAttack.Enabled = state end)
    CreateSlider("Attack Delay", 0.1, 2, 0.35, function(v) State.AutoSpamAttack.Delay = v end)
    CreateToggle("Auto Kill All", false, function(state) State.AutoKillAll.Enabled = state end)
    CreateSlider("Kill Predict", 0, 1, 0.15, function(v) State.AutoKillAll.PredictStrength = v end)
    CreateSlider("Behind Offset", 1, 10, 3, function(v) State.AutoKillAll.BehindOffset = v end)

    CreateSection("Auto Carry + Hook", "🏃")
    CreateToggle("Auto Carry Downed", false, function(state) State.AutoCarry.Enabled = state end)

    CreateSection("Auto Stalk", "👁️")
    CreateToggle("Auto Stalk", false, function(state) State.AutoStalk.Enabled = state end)
    CreateSlider("Stalk Range", 50, 500, 150, function(v) State.AutoStalk.StalkRange = v end)

    CreateSection("Masked Power", "🎭")
    CreateDropdown("Select Power", State.MaskedPower.Powers, "Cobra", function(v) State.MaskedPower.CurrentPower = v end)
    CreateButton("⚡ Activate Power", function()
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        local k = r and r:FindFirstChild("Killers")
        local m = k and k:FindFirstChild("Masked")
        local e = m and m:FindFirstChild("Activatepower")
        if e then e:FireServer(State.MaskedPower.CurrentPower) end
    end)
    CreateButton("❌ Deactivate Power", function()
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        local k = r and r:FindFirstChild("Killers")
        local m = k and k:FindFirstChild("Masked")
        local e = m and m:FindFirstChild("Deactivatepower")
        if e then e:FireServer() end
    end)

    CreateSection("Hitbox Expander", "📦")
    CreateToggle("Enable Hitbox", false, function(state)
        State.HitboxExpander.Enabled = state
        if not state then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    ResetHitboxExpander(plr.Character)
                end
            end
        end
    end)
    CreateSlider("Hitbox Size", 3, 30, 15, function(v) State.HitboxExpander.Size = v end)
    CreateSlider("Transparency", 0, 1, 0.7, function(v) State.HitboxExpander.Transparency = v end)
    CreateColorPicker("Hitbox Color", State.HitboxExpander.Color, function(c) State.HitboxExpander.Color = c end)
    CreateToggle("Only Survivors", true, function(state) State.HitboxExpander.OnlySurvivors = state end)

    CreateSection("Anti Stun", "💪")
    CreateToggle("Anti Stun", false, function(state) State.AntiStun.Enabled = state end)
end)

-- =========================================================
-- TAB 3 : SURVIVOR
-- =========================================================
local tabSurvivor = CreateTab("Survivor", "🏃", 3, function()
    CreateSection("Auto Parry", "🛡️")
    CreateToggle("Enable Auto Parry", false, function(state)
        State.AutoParry.Enabled = state
        if state then ScanKillersForParry() end
    end)
    CreateSlider("Parry Distance", 5, 25, 12, function(v) State.AutoParry.ParryDistance = v end)
    CreateSlider("Face Sensitivity", -1, 1, 0.7, function(v) State.AutoParry.FaceSensitivity = v end)

    CreateSection("Parry Circle", "🔵")
    CreateToggle("Show Parry Circle", false, function(state) State.ParryCircle.Enabled = state end)
    CreateSlider("Circle Size", 5, 50, 12, function(v) State.ParryCircle.Size = v end)
    CreateColorPicker("Circle Color", State.ParryCircle.Color, function(c) State.ParryCircle.Color = c end)
    CreateSlider("Transparency", 0, 1, 0.7, function(v) State.ParryCircle.Transparency = v end)

    CreateSection("Auto Skill Check", "🎯")
    CreateToggle("Enable Skill Check", false, function(state)
        State.SkillCheck.Enabled = state
        if state then StartSkillCheck() end
    end)

    CreateSection("Auto Wiggle", "🎯")
    CreateToggle("Auto Wiggle", false, function(state) State.AutoWiggle.Enabled = state end)
    CreateSlider("Wiggle Spam", 1, 10, 5, function(v) State.AutoWiggle.Spam = v end)

    CreateSection("Auto Flee Killer", "🏃")
    CreateToggle("Auto Flee", false, function(state) State.AutoFlee.Enabled = state end)
    CreateSlider("Detect Distance", 10, 200, 50, function(v) State.AutoFlee.DetectDistance = v end)

    CreateSection("Moonwalk", "🌙")
    CreateToggle("Enable Moonwalk", false, function(state)
        State.Moonwalk.Enabled = state
        if state then StartMoonwalk() else StopMoonwalk() end
    end)
    CreateSlider("Spam Speed", 1, 100, 30, function(v) State.Moonwalk.SpamSpeed = v end)
    CreateSlider("Intensity", 1, 90, 35, function(v) State.Moonwalk.Intensity = v end)
    CreateSlider("Slow Speed", 5, 30, 13, function(v) State.Moonwalk.SlowSpeed = v end)

    CreateSection("Moonwalk Button", "🌙")
    CreateToggle("Show Moonwalk Button", false, function(state) ToggleMoonwalkButton(state) end)
    CreateToggle("🔒 Lock Moonwalk", false, function(state)
        State.FloatingButtons.Moonwalk.Locked = state
        UpdateButtonLockStatus("Moonwalk")
    end)
    CreateButton("🔄 Reset Posisi Moonwalk", function() ResetButtonPosition("Moonwalk") end)

    CreateSection("God Mode", "🛡️")
    CreateToggle("Anti Knockdown", false, function(state) State.GodMode.Enabled = state end)
end)

-- =========================================================
-- TAB 4 : ESP
-- =========================================================
local tabESP = CreateTab("ESP", "👁️", 4, function()
    CreateSection("Survivor ESP", "🟢")
    CreateToggle("ESP Survivor", false, function(state) State.ESP.SurvivorEnabled = state end)
    CreateColorPicker("Survivor Color", State.ESP.SurvivorColor, function(c) State.ESP.SurvivorColor = c end)

    CreateSection("Killer ESP", "🔴")
    CreateToggle("ESP Killer", false, function(state) State.ESP.KillerEnabled = state end)
    CreateColorPicker("Killer Color", State.ESP.KillerColor, function(c) State.ESP.KillerColor = c end)

    CreateSection("Generator ESP", "⚡")
    CreateToggle("ESP Generator", false, function(state) State.ESP.GeneratorEnabled = state end)
    CreateColorPicker("Generator Color", State.ESP.GeneratorColor, function(c) State.ESP.GeneratorColor = c end)

    CreateSection("ESP Status", "📊")
    CreateToggle("Show Name", true, function(state) State.ESP.ShowName = state end)
    CreateToggle("Show Distance", true, function(state) State.ESP.ShowDistance = state end)
    CreateToggle("Show Health", false, function(state) State.ESP.ShowHealth = state end)
    CreateColorPicker("Name Color", State.ESP.NameColor, function(c) State.ESP.NameColor = c end)
    CreateSlider("Name Size", 8, 24, 12, function(v) State.ESP.NameSize = v end)
    CreateSlider("ESP Radius", 50, 1000, 100, function(v) State.ESP.Radius = v end)
end)

-- =========================================================
-- TAB 5 : VISUAL
-- =========================================================
local tabVisual = CreateTab("Visual", "🎨", 5, function()
    CreateSection("Lighting", "☀️")
    CreateToggle("Fullbright", false, function(state) State.Visual.Fullbright = state; ApplyVisual() end)
    CreateToggle("No Fog", false, function(state) State.Visual.NoFog = state; ApplyVisual() end)

    CreateSection("Sky", "🌤️")
    CreateToggle("Custom Sky", false, function(state) State.Visual.CustomSky = state; ApplyVisual() end)
    CreateDropdown("Sky Preset", {"Sunset", "Night", "Space", "Alien"}, "Sunset", function(v)
        State.Visual.SkyId = "rbxassetid://159454299"
        if State.Visual.CustomSky then ApplyVisual() end
    end)

    CreateSection("Contrast", "🔍")
    CreateToggle("Enable Contrast", false, function(state) State.Visual.Contrast = state; ApplyVisual() end)
    CreateSlider("Contrast", -1, 2, 0.3, function(v) State.Visual.ContrastValue = v; ApplyVisual() end)
    CreateSlider("Brightness", -1, 1, 0.15, function(v) State.Visual.Brightness = v; ApplyVisual() end)
    CreateSlider("Saturation", -1, 1, 0.2, function(v) State.Visual.Saturation = v; ApplyVisual() end)

    CreateSection("Fire Effect", "🔥")
    CreateToggle("Enable Fire", false, function(state) State.FireEffect.Enabled = state; ApplyFireEffect() end)
    CreateDropdown("Fire Type", {"Red", "Blue", "Green", "Purple", "Rainbow"}, "Red", function(v)
        State.FireEffect.Type = v
        ApplyFireEffect()
    end)
    CreateSlider("Fire Size", 1, 20, 5, function(v) State.FireEffect.Size = v; ApplyFireEffect() end)
end)

-- =========================================================
-- TAB 6 : MOVEMENT
-- =========================================================
local tabMovement = CreateTab("Movement", "🏃", 6, function()
    CreateSection("Speed", "⚡")
    CreateToggle("Walk Speed", false, function(state)
        State.Movement.WalkSpeedEnabled = state
        if not state then
            local hum = getHumanoid()
            if hum then hum.WalkSpeed = State.Movement.OriginalWalkSpeed end
        end
    end)
    CreateSlider("Speed", 16, 100, 17.6, function(v) State.Movement.WalkSpeedValue = v end)
    CreateToggle("Jump Power", false, function(state)
        State.Movement.JumpPowerEnabled = state
        if not state then
            local hum = getHumanoid()
            if hum then hum.JumpPower = State.Movement.OriginalJumpPower end
        end
    end)
    CreateSlider("Jump", 50, 300, 50, function(v) State.Movement.JumpPowerValue = v end)
    CreateToggle("No Clip", false, function(state) State.Movement.NoClip = state end)

    CreateSection("Teleport", "📍")
    CreateButton("🚀 TP Player Acak", function()
        local list = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP then table.insert(list, p) end
        end
        if #list > 0 then TeleportToPlayer(list[math.random(1, #list)].Name) end
    end)
    CreateButton("🚪 TP Gate", function() TeleportToObject("gate") end)
    CreateButton("🪵 TP Pallet", function() TeleportToObject("pallet") end)
    CreateButton("🪟 TP Window", function() TeleportToObject("window") end)
    CreateButton("⚡ TP Generator", function() TeleportToObject("generator") end)
end)

-- =========================================================
-- TAB 7 : AVATAR
-- =========================================================
local tabAvatar = CreateTab("Avatar", "🎭", 7, function()
    CreateSection("Steal Avatar", "🎭")
    CreateLabel("Masukin username target", Config.ACCENT2)

    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(1, -6, 0, 32)
    inputFrame.BackgroundColor3 = Config.BG
    inputFrame.BackgroundTransparency = 0.3
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = contentScroll
    Round(inputFrame, 10)
    Stroke(inputFrame, Config.ACCENT2, 1, 0.7)

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -16, 1, 0)
    textBox.Position = UDim2.new(0, 8, 0, 0)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
    textBox.PlaceholderText = "Ketik username..."
    textBox.TextColor3 = Config.TEXT
    textBox.PlaceholderColor3 = Config.TEXT_DIM
    textBox.TextSize = 11
    textBox.Font = Enum.Font.GothamMedium
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.ClearTextOnFocus = false
    textBox.Parent = inputFrame

    textBox.FocusLost:Connect(function()
        State.AvatarStealer.TargetUsername = textBox.Text
    end)

    CreateButton("🎭 Copy Avatar", function()
        if State.AvatarStealer.TargetUsername == "" then
            State.AvatarStealer.TargetUsername = textBox.Text
        end
        CopyAvatar(State.AvatarStealer.TargetUsername)
    end)
    CreateButton("🔄 Reset Avatar", function() ResetAvatar() end)
    CreateButton("💾 Save Avatar Skrg", function() SaveOriginalAppearance() end)

    CreateSection("Opsi", "⚙️")
    CreateToggle("Blocky Body", true, function(state) State.AvatarStealer.BlockyBody = state end)
end)

-- =========================================================
-- TAB 8 : SETTINGS
-- =========================================================
local tabSettings = CreateTab("Settings", "⚙️", 8, function()
    CreateSection("Keybind", "⌨️")
    CreateLabel("RightShift = Toggle Menu", Config.ACCENT2)
    CreateLabel("Klik kanan = Aimlock", Config.ACCENT2)

    CreateSection("Config Save", "💾")
    CreateButton("💾 Save Config Skrg", function() SaveConfig() end)
    CreateButton("📂 Load Config", function() LoadConfig() end)
    CreateButton("🗑️ Reset Config", function()
        if delfile and isfile("RoooorHub_Config.json") then
            delfile("RoooorHub_Config.json")
        end
    end)

    CreateSection("Script", "🚪")
    CreateButton("🔄 Reset Semua Fitur", function()
        for k, v in pairs(State) do
            if type(v) == "table" and v.Enabled ~= nil then v.Enabled = false end
        end
    end)
    CreateButton("🚪 Unload Script", function()
        SaveConfig()
        ScreenGui:Destroy()
        if State.FloatingButtons.Aimlock.Gui then State.FloatingButtons.Aimlock.Gui:Destroy() end
        if State.FloatingButtons.Moonwalk.Gui then State.FloatingButtons.Moonwalk.Gui:Destroy() end
        if State.ParryCircle.CirclePart then State.ParryCircle.CirclePart:Destroy() end
    end)
end)

-- =========================================================
-- FPS/PING COUNTER (AKURAT - sesuai HP)
-- =========================================================
local FrameCount = 0
local TimeAccum = 0

RunService.RenderStepped:Connect(function(dt)
    FrameCount = FrameCount + 1
    TimeAccum = TimeAccum + dt
    if TimeAccum >= 1 then
        local fps = math.floor(FrameCount / TimeAccum)
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        if State.Stats.ShowWatermark then
            FPSLabel.Text = string.format("FPS: %d | PING: %d ms", fps, ping)
        end
        FrameCount = 0
        TimeAccum = 0
    end
end)

-- =========================================================
-- MAIN LOOP
-- =========================================================
local LastESPScan = 0
local LastParryScan = 0
local LastHitboxScan = 0
local LastSlowLoop = 0

task.spawn(function()
    while ScreenGui.Parent do
        local now = tick()
        local root = getRoot()
        if root then
            if now - LastESPScan >= 0.1 then
                LastESPScan = now
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local char = p.Character
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local dist = (hrp.Position - root.Position).Magnitude
                                if dist <= State.ESP.Radius then
                                    if State.ESP.SurvivorEnabled and p.Team and p.Team.Name == "Survivors" then
                                        CreateESP(char, State.ESP.SurvivorColor)
                                    elseif State.ESP.KillerEnabled and p.Team and p.Team.Name == "Killer" then
                                        CreateESP(char, State.ESP.KillerColor)
                                    else
                                        RemoveESP(char)
                                    end
                                else
                                    RemoveESP(char)
                                end
                            end
                            CreateStatusESP(p, char, root)
                        else
                            RemoveESP(char)
                            RemoveStatusESP(char)
                        end
                    end
                end

                if State.ESP.GeneratorEnabled then
                    for gen in pairs(Cached.Generators) do
                        if gen and gen.Parent then
                            local primary = gen.PrimaryPart or gen:FindFirstChildWhichIsA("BasePart")
                            if primary then
                                local dist = (primary.Position - root.Position).Magnitude
                                if dist <= State.ESP.Radius then
                                    CreateESP(gen, State.ESP.GeneratorColor)
                                else
                                    RemoveESP(gen)
                                end
                            end
                        end
                    end
                end
            end

            if State.AutoSpamAttack.Enabled and now - (_G.LastAtk or 0) >= State.AutoSpamAttack.Delay then
                _G.LastAtk = now
                if AttackEvent then pcall(function() AttackEvent:FireServer(false) end) end
            end

            if State.AutoKillAll.Enabled then
                local target = getNearestTarget("Survivors", 500)
                if target then
                    local tHRP = target:FindFirstChild("HumanoidRootPart")
                    if tHRP then
                        local targetPos = tHRP.Position + (tHRP.AssemblyLinearVelocity * State.AutoKillAll.PredictStrength)
                        local behind = tHRP.CFrame.LookVector * -State.AutoKillAll.BehindOffset
                        root.CFrame = CFrame.new(targetPos + behind, targetPos)
                        if AttackEvent then pcall(function() AttackEvent:FireServer(false) end) end
                    end
                end
            end

            if State.GodMode.Enabled then
                local hum = getHumanoid()
                if hum and hum.Health < hum.MaxHealth then
                    pcall(function() hum.Health = hum.MaxHealth end)
                end
            end

            ApplyAntiStun()

            if State.Movement.WalkSpeedEnabled then
                local hum = getHumanoid()
                if hum and hum.WalkSpeed ~= State.Movement.WalkSpeedValue then
                    hum.WalkSpeed = State.Movement.WalkSpeedValue
                end
            end

            if State.Movement.JumpPowerEnabled then
                local hum = getHumanoid()
                if hum and hum.JumpPower ~= State.Movement.JumpPowerValue then
                    hum.JumpPower = State.Movement.JumpPowerValue
                end
            end

            if State.Movement.NoClip and LP.Character then
                for _, p in pairs(LP.Character:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
                end
            end

            if State.HitboxExpander.Enabled and now - LastHitboxScan >= 0.3 then
                LastHitboxScan = now
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        if State.HitboxExpander.OnlySurvivors then
                            if plr.Team and plr.Team.Name == "Survivors" then
                                ApplyHitboxExpander(plr.Character)
                            end
                        else
                            ApplyHitboxExpander(plr.Character)
                        end
                    end
                end
            end

            if State.FireEffect.Enabled then ApplyFireEffect() end

            UpdateParryCircle()

            if State.AutoParry.Enabled and now - LastParryScan >= 2 then
                LastParryScan = now
                ScanKillersForParry()
            end
        end

        if now - LastSlowLoop >= 0.5 then
            LastSlowLoop = now
            if State.AutoFlee.Enabled then RunAutoFlee() end
            if State.AutoCarry.Enabled then RunAutoCarry() end
            if State.AutoStalk.Enabled then RunAutoStalk() end
            if State.AutoWiggle.Enabled then RunAutoWiggle() end
        end

        task.wait(0.1)
    end
end)

-- Respawn
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    _G.ParryActive = false
    _G.CarryBusy = false
    _G.HookedKillers = {}
    if State.FireEffect.Enabled then ApplyFireEffect() end
    if State.Moonwalk.Enabled then StartMoonwalk() end
    if State.AutoParry.Enabled then ScanKillersForParry() end
end)

-- Buka tab pertama
task.wait(0.3)
if tabInfo then tabInfo.MouseButton1Click:Fire() end

-- Keybind RightShift
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

-- Neon stroke animasi
task.spawn(function()
    while Main.Parent do
        task.wait(0.05)
        local hue = (tick() * 0.3) % 1
        mainStroke.Color = Color3.fromHSV(hue, 1, 1)
        mainStroke.Transparency = 0.4
    end
end)

-- FINAL PRINT
print("=====================================================")
print("✅ [ROOORHUB] BAGIAN 4/4 loaded")
print("🎉 ROOORHUB ULTIMATE KILLER - LOADED SUCCESSFULLY!")
print("=====================================================")
print("⌨️  RightShift = Toggle Menu")
print("🎯 Klik kanan = Aimlock")
print("🛡️ Auto Parry & Skill Check = WORK")
print("🌙 Moonwalk = Konsisten Lobby & Ingame")
print("💾 Auto Save Config = AKTIF")
print("=====================================================")-- =========================================================
-- BAGIAN 3/4 : FITUR LOGIC (SEMUA GLOBAL)
-- =========================================================

-- =========================================================
-- ESP SYSTEM (PERSIS FALLENS)
-- =========================================================
local ESPObjects = {}
local StatusESP = {}

local Cached = {
    Generators = {},
    Windows = {},
    Pallets = {}
}

local function cacheObject(obj)
    if obj.Name == "Generator" then
        Cached.Generators[obj] = true
    elseif obj.Name == "Window" then
        Cached.Windows[obj] = true
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        Cached.Pallets[obj] = true
    end
end

local function removeCache(obj)
    Cached.Generators[obj] = nil
    Cached.Windows[obj] = nil
    Cached.Pallets[obj] = nil
end

for _, obj in ipairs(workspace:GetDescendants()) do
    cacheObject(obj)
end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(removeCache)

function CreateESP(obj, color)
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
        if not parent and ESPObjects[obj] then
            ESPObjects[obj]:Destroy()
            ESPObjects[obj] = nil
        end
    end)
end

function RemoveESP(obj)
    if ESPObjects[obj] then
        ESPObjects[obj]:Destroy()
        ESPObjects[obj] = nil
    end
end

function CreateStatusESP(player, char, root)
    if not State.ESP.ShowName and not State.ESP.ShowDistance and not State.ESP.ShowHealth then
        if StatusESP[char] then
            StatusESP[char]:Destroy()
            StatusESP[char] = nil
        end
        return
    end
    if not root then return end

    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    local isDown = hum.Health <= 0 or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true

    local dist = (head.Position - root.Position).Magnitude
    if dist > State.ESP.Radius then
        if StatusESP[char] then
            StatusESP[char]:Destroy()
            StatusESP[char] = nil
        end
        return
    end

    local text = ""
    if isDown then text = "🔻 DOWN\n" end
    if State.ESP.ShowName then text = text .. player.Name .. "\n" end
    if State.ESP.ShowDistance then text = text .. string.format("Dist: %.0f\n", dist) end
    if State.ESP.ShowHealth then text = text .. string.format("HP: %.0f\n", hum.Health) end
    if text == "" then return end

    local billboard = StatusESP[char]
    local teamColor = State.ESP.NameColor
    if player.Team then
        if player.Team.Name == "Killer" then
            teamColor = State.ESP.KillerColor
        elseif player.Team.Name == "Survivors" then
            teamColor = State.ESP.SurvivorColor
        end
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
        label.TextSize = State.ESP.NameSize
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
            label.TextSize = State.ESP.NameSize
        end
    end
end

function RemoveStatusESP(char)
    if StatusESP[char] then
        StatusESP[char]:Destroy()
        StatusESP[char] = nil
    end
end

-- =========================================================
-- AIMLOCK
-- =========================================================
function GetClosestAimTarget()
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
                    if (hrp.Position - root.Position).Magnitude <= State.Aimlock.Radius then
                        local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                        if visible then
                            local screenDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                            if screenDist < shortest then
                                shortest = screenDist
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

function StartAimlock()
    if _G.AimConn then return end
    _G.AimConn = RunService.RenderStepped:Connect(function()
        if not State.Aimlock.Enabled or not State.Aimlock.Holding then return end
        local target = GetClosestAimTarget()
        if not target then return end
        local pos = target.Position
        if State.Aimlock.Prediction > 0 then
            pos = pos + (target.AssemblyLinearVelocity * State.Aimlock.Prediction)
        end
        local targetCF = CFrame.new(Camera.CFrame.Position, pos)
        Camera.CFrame = Camera.CFrame:Lerp(targetCF, State.Aimlock.Smoothness)
    end)
end

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
-- HITBOX EXPANDER
-- =========================================================
local hitboxCache = {}

function ApplyHitboxExpander(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local parts = {
        char:FindFirstChild("Head"),
        char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"),
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

function ResetHitboxExpander(char)
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
-- ANTI STUN
-- =========================================================
function ApplyAntiStun()
    if not State.AntiStun.Enabled then return end
    local hum = getHumanoid()
    if not hum then return end
    local st = hum:GetState()
    if st == Enum.HumanoidStateType.FallingDown
    or st == Enum.HumanoidStateType.Ragdoll
    or st == Enum.HumanoidStateType.Dead then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end

-- =========================================================
-- AUTO PARRY (PERSIS FALLENS)
-- =========================================================
local lastParry = 0
local PARRY_DEBOUNCE = 0.2
_G.ParryActive = false
_G.HookedKillers = {}

local function pressRightClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
end

local AttackPaths = {
    "Slasher-mob.Controls.attack",
    "Masked-mob.Controls.attack",
    "Killer-mob.Controls.attack"
}

local function GetParryButton()
    local current = PlayerGui
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
    _G.ParryActive = true

    if State.Moonwalk.Enabled then
        State.Moonwalk.Enabled = false
    end

    pressParryButton()

    task.delay(0.3, function()
        _G.ParryActive = false
    end)
end

local function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end
    return (enemyRoot.Position - myRoot.Position).Magnitude <= State.AutoParry.ParryDistance
end

local function isFacingTarget(targetChar)
    if State.AutoParry.FaceSensitivity <= -1 then return true end
    local myChar = LP.Character
    if not myChar then return false end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local enemyRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not enemyRoot then return false end
    local enemyForward = enemyRoot.CFrame.LookVector
    local directionToMe = (myRoot.Position - enemyRoot.Position).Unit
    local dot = enemyForward:Dot(directionToMe)
    return dot >= State.AutoParry.FaceSensitivity
end

local function hookKiller(char)
    if _G.HookedKillers[char] then return end
    _G.HookedKillers[char] = true
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    animator.AnimationPlayed:Connect(function(track)
        if not State.AutoParry.Enabled then return end
        local anim = track.Animation
        if not anim then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end
        local fullId = "rbxassetid://" .. id
        if KillerAnims[fullId] then
            if not isInParryRange(char) then return end
            if not isFacingTarget(char) then return end
            doParry()
        end
    end)
end

function ScanKillersForParry()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team and p.Team.Name == "Killer" then
            hookKiller(p.Character)
        end
    end
end

-- =========================================================
-- PARRY CIRCLE
-- =========================================================
function UpdateParryCircle()
    local root = getRoot()
    if not State.ParryCircle.Enabled or not root then
        if State.ParryCircle.CirclePart then
            State.ParryCircle.CirclePart:Destroy()
            State.ParryCircle.CirclePart = nil
        end
        return
    end
    if not State.ParryCircle.CirclePart then
        local c = Instance.new("Part")
        c.Shape = Enum.PartType.Cylinder
        c.Anchored = true
        c.CanCollide = false
        c.Material = Enum.Material.Neon
        c.Name = "RoooorParryCircle"
        c.Parent = workspace
        State.ParryCircle.CirclePart = c
    end
    local size = State.ParryCircle.Size * 2
    local c = State.ParryCircle.CirclePart
    c.Size = Vector3.new(0.2, size, size)
    c.CFrame = CFrame.new(root.Position - Vector3.new(0, root.Size.Y/2 + 1.5, 0))
        * CFrame.Angles(0, 0, math.rad(90))
    c.Color = State.ParryCircle.Color
    c.Transparency = State.ParryCircle.Transparency
end

-- =========================================================
-- AUTO SKILL CHECK (PERSIS FALLENS)
-- =========================================================
local function pressSpace()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local TouchID = 8822
local ActionPath = "Survivor-mob.Controls.action.check"
local SkillHeartbeat = nil
local skillBusy = false

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

function StartSkillCheck()
    if SkillHeartbeat then SkillHeartbeat:Disconnect() end
    SkillHeartbeat = RunService.RenderStepped:Connect(function()
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
-- MOONWALK (PERSIS FALLENS)
-- =========================================================
_G.MoonwalkConn = nil

function StartMoonwalk()
    if _G.MoonwalkConn then return end
    _G.MoonwalkConn = RunService.RenderStepped:Connect(function()
        if not State.Moonwalk.Enabled or _G.ParryActive or isDowned() then return end
        local char = LP.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not humanoid or not hrp or not cam then return end

        if State.Moonwalk.UseSlow and humanoid.WalkSpeed ~= State.Moonwalk.SlowSpeed then
            humanoid.WalkSpeed = State.Moonwalk.SlowSpeed
        end

        local look = cam.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit
            local baseCF = CFrame.new(hrp.Position, hrp.Position + flatLook)
            local angle = math.sin(tick() * State.Moonwalk.SpamSpeed) * State.Moonwalk.Intensity
            hrp.CFrame = baseCF * CFrame.Angles(0, math.rad(angle), 0)
            humanoid:Move(Vector3.new(0, 0, 1), true)
        end
    end)
end

function StopMoonwalk()
    if _G.MoonwalkConn then
        _G.MoonwalkConn:Disconnect()
        _G.MoonwalkConn = nil
    end
end

-- =========================================================
-- AUTO WIGGLE
-- =========================================================
function RunAutoWiggle()
    if not State.AutoWiggle.Enabled then return end
    local char = LP.Character
    if not char then return end
    local carried =
        (char:FindFirstChild("IsCarried") and char.IsCarried.Value) or
        (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)
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
-- AUTO FLEE
-- =========================================================
function GetFarthestGeneratorPoint(killerRoot)
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

function RunAutoFlee()
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
-- AUTO CARRY
-- =========================================================
function GetDowned()
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

function GetHook()
    local root = getRoot()
    if not root then return nil end
    local bestHook, sd = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "HookPoint" and obj:IsA("BasePart") then
            local dist = (obj.Position - root.Position).Magnitude
            if dist < sd and dist < 400 then sd = dist; bestHook = obj end
        end
    end
    return bestHook
end

function RunAutoCarry()
    if not State.AutoCarry.Enabled or _G.CarryBusy then return end
    _G.CarryBusy = true
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
        _G.CarryBusy = false
    end)
end

-- =========================================================
-- AUTO STALK
-- =========================================================
function GetClosestSurvivorForStalk()
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

function RunAutoStalk()
    if not State.AutoStalk.Enabled then return end
    local target = GetClosestSurvivorForStalk()
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
-- FIRE EFFECT (5 VARIAN)
-- =========================================================
function ApplyFireEffect()
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

-- =========================================================
-- VISUAL
-- =========================================================
local origLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows,
}
local contrastEffect = nil

function ApplyVisual()
    if State.Visual.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = origLighting.Brightness
        Lighting.ClockTime = origLighting.ClockTime
        Lighting.Ambient = origLighting.Ambient
        Lighting.OutdoorAmbient = origLighting.OutdoorAmbient
        Lighting.GlobalShadows = origLighting.GlobalShadows
    end
    if State.Visual.NoFog then
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
    else
        Lighting.FogEnd = origLighting.FogEnd
        Lighting.FogStart = origLighting.FogStart
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
-- TELEPORT
-- =========================================================
function TeleportToPlayer(name)
    local target = Players:FindFirstChild(name)
    if target and target.Character and LP.Character then
        local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
        local mHRP = LP.Character:FindFirstChild("HumanoidRootPart")
        if tHRP and mHRP then
            mHRP.CFrame = tHRP.CFrame + Vector3.new(0, 3, 0)
        end
    end
end

function TeleportToObject(objectName)
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
-- AVATAR STEALER (PERSIS FALLENS)
-- =========================================================
function SaveOriginalAppearance()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        State.AvatarStealer.OriginalDescription = hum:GetAppliedDescription()
    end
end

function ApplyBlockyBody(character)
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

function RemoveAllClothingAndAccessories(character)
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("Accessory") or v:IsA("Clothing") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
            v:Destroy()
        end
    end
end

function CopyAvatar(username)
    if not username or username == "" then return end
    SaveOriginalAppearance()
    local success, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    if not success then return end
    State.AvatarStealer.CurrentStealedUserId = userId

    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    task.spawn(function()
        local desc = Players:GetHumanoidDescriptionFromUserId(userId)
        if State.AvatarStealer.BlockyBody then
            ApplyBlockyBody(char)
            task.wait(0.3)
        end
        RemoveAllClothingAndAccessories(char)
        task.wait(0.2)
        hum:ApplyDescriptionClientServer(desc)
    end)
end

function ResetAvatar()
    if not State.AvatarStealer.OriginalDescription then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        RemoveAllClothingAndAccessories(char)
        hum:ApplyDescriptionClientServer(State.AvatarStealer.OriginalDescription)
        State.AvatarStealer.CurrentStealedUserId = nil
    end
end

LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    if State.AvatarStealer.CurrentStealedUserId then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local desc = Players:GetHumanoidDescriptionFromUserId(State.AvatarStealer.CurrentStealedUserId)
            if State.AvatarStealer.BlockyBody then
                ApplyBlockyBody(char)
            end
            RemoveAllClothingAndAccessories(char)
            hum:ApplyDescriptionClientServer(desc)
        end
    end
end)

-- =========================================================
-- AUTO SAVE CONFIG
-- =========================================================
local HttpService = game:GetService("HttpService")

function SaveConfig()
    local saveData = {
        Aimlock = State.Aimlock.Enabled,
        AutoParry = State.AutoParry.Enabled,
        SkillCheck = State.SkillCheck.Enabled,
        AutoWiggle = State.AutoWiggle.Enabled,
        AutoFlee = State.AutoFlee.Enabled,
        Moonwalk = State.Moonwalk.Enabled,
        GodMode = State.GodMode.Enabled,
        ESP = {
            Survivor = State.ESP.SurvivorEnabled,
            Killer = State.ESP.KillerEnabled,
            Generator = State.ESP.GeneratorEnabled,
            ShowName = State.ESP.ShowName,
            ShowDistance = State.ESP.ShowDistance,
            ShowHealth = State.ESP.ShowHealth,
        },
        Visual = {
            Fullbright = State.Visual.Fullbright,
            NoFog = State.Visual.NoFog,
            FireEffect = State.FireEffect.Enabled,
            FireType = State.FireEffect.Type,
        },
        Movement = {
            WalkSpeed = State.Movement.WalkSpeedEnabled,
            JumpPower = State.Movement.JumpPowerEnabled,
            NoClip = State.Movement.NoClip,
        },
    }
    pcall(function()
        if writefile then
            writefile("RoooorHub_Config.json", HttpService:JSONEncode(saveData))
        end
    end)
end

function LoadConfig()
    pcall(function()
        if isfile and isfile("RoooorHub_Config.json") then
            local data = HttpService:JSONDecode(readfile("RoooorHub_Config.json"))
            if data.Aimlock ~= nil then State.Aimlock.Enabled = data.Aimlock end
            if data.AutoParry ~= nil then State.AutoParry.Enabled = data.AutoParry end
            if data.SkillCheck ~= nil then State.SkillCheck.Enabled = data.SkillCheck end
            if data.AutoWiggle ~= nil then State.AutoWiggle.Enabled = data.AutoWiggle end
            if data.AutoFlee ~= nil then State.AutoFlee.Enabled = data.AutoFlee end
            if data.Moonwalk ~= nil then State.Moonwalk.Enabled = data.Moonwalk end
            if data.GodMode ~= nil then State.GodMode.Enabled = data.GodMode end
            if data.ESP then
                State.ESP.SurvivorEnabled = data.ESP.Survivor or false
                State.ESP.KillerEnabled = data.ESP.Killer or false
                State.ESP.GeneratorEnabled = data.ESP.Generator or false
                State.ESP.ShowName = data.ESP.ShowName ~= false
                State.ESP.ShowDistance = data.ESP.ShowDistance ~= false
                State.ESP.ShowHealth = data.ESP.ShowHealth or false
            end
            if data.Visual then
                State.Visual.Fullbright = data.Visual.Fullbright or false
                State.Visual.NoFog = data.Visual.NoFog or false
                State.FireEffect.Enabled = data.Visual.FireEffect or false
                State.FireEffect.Type = data.Visual.FireType or "Red"
            end
            if data.Movement then
                State.Movement.WalkSpeedEnabled = data.Movement.WalkSpeed or false
                State.Movement.JumpPowerEnabled = data.Movement.JumpPower or false
                State.Movement.NoClip = data.Movement.NoClip or false
            end
        end
    end)
end

task.spawn(function()
    task.wait(1)
    LoadConfig()
end)

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(10)
        SaveConfig()
    end
end)

game:BindToClose(function()
    SaveConfig()
end)

print("✅ [ROOORHUB] BAGIAN 3/4 loaded")-- =========================================================
-- BAGIAN 2/4 : UI COMPONENTS (FIXED - SEMUA GLOBAL)
-- =========================================================

-- SECTION
function CreateSection(title, icon)
    local sec = Instance.new("Frame")
    sec.Size = UDim2.new(1, -4, 0, 24)
    sec.BackgroundTransparency = 1
    sec.Parent = contentScroll

    local deco = Instance.new("Frame")
    deco.Size = UDim2.new(0, 3, 0, 14)
    deco.Position = UDim2.new(0, 4, 0.5, -7)
    deco.BackgroundColor3 = Config.ACCENT
    deco.BorderSizePixel = 0
    deco.Parent = sec
    Round(deco, 2)

    local decoGrad = Instance.new("UIGradient")
    decoGrad.Color = RainbowSeq()
    decoGrad.Rotation = 90
    decoGrad.Parent = deco

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -16, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = icon .. "  " .. string.upper(title)
    lbl.TextColor3 = Config.ACCENT3
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = sec
end

-- LABEL
function CreateLabel(text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -6, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Config.TEXT_DIM
    lbl.TextSize = 10
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.Parent = contentScroll
end

-- TOGGLE
function CreateToggle(name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 34)
    frame.BackgroundColor3 = Config.BG
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = contentScroll
    Round(frame, 10)
    Stroke(frame, Config.ACCENT, 1, 0.8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Config.TEXT
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 38, 0, 18)
    toggle.Position = UDim2.new(1, -48, 0.5, -9)
    toggle.BackgroundColor3 = default and Config.ACCENT or Config.PANEL
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    Round(toggle, 9)
    local toggleStroke = Stroke(toggle, default and Config.ACCENT2 or Config.TEXT_DIM, 1, 0.5)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = default and Config.ACCENT2 or Config.TEXT_DIM
    knob.BorderSizePixel = 0
    knob.Parent = toggle
    Round(knob, 7)

    local state = default
    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Parent = toggle

    clickBtn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
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
function CreateButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 32)
    btn.BackgroundColor3 = Config.BG
    btn.BackgroundTransparency = 0.3
    btn.Text = name
    btn.TextColor3 = Config.TEXT
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = contentScroll
    Round(btn, 10)
    Stroke(btn, Config.ACCENT2, 1, 0.7)

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
function CreateSlider(name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 44)
    frame.BackgroundColor3 = Config.BG
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = contentScroll
    Round(frame, 10)
    Stroke(frame, Config.ACCENT, 1, 0.8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 0, 18)
    lbl.Position = UDim2.new(0, 12, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Config.TEXT
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 40, 0, 18)
    valLbl.Position = UDim2.new(1, -50, 0, 4)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(default)
    valLbl.TextColor3 = Config.ACCENT2
    valLbl.TextSize = 10
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = frame

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -24, 0, 5)
    barBg.Position = UDim2.new(0, 12, 1, -13)
    barBg.BackgroundColor3 = Config.PANEL
    barBg.BorderSizePixel = 0
    barBg.Parent = frame
    Round(barBg, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Config.ACCENT
    fill.BorderSizePixel = 0
    fill.Parent = barBg
    Round(fill, 3)

    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color = ColorSequence.new(Config.ACCENT, Config.ACCENT2)
    fillGrad.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    knob.BackgroundColor3 = Config.TEXT
    knob.BorderSizePixel = 0
    knob.ZIndex = 2
    knob.Parent = barBg
    Round(knob, 6)
    Stroke(knob, Config.ACCENT2, 2)

    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        local val = math.floor((min + (max - min) * pos) * 100 + 0.5) / 100
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, -6, 0.5, -6)
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
function CreateDropdown(name, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 34)
    frame.BackgroundColor3 = Config.BG
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = contentScroll
    Round(frame, 10)
    Stroke(frame, Config.ACCENT, 1, 0.8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Config.TEXT
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local current = default or options[1]
    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0.5, -24, 1, 0)
    valLbl.Position = UDim2.new(0.5, 0, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(current)
    valLbl.TextColor3 = Config.ACCENT2
    valLbl.TextSize = 10
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
    Round(list, 8)
    Stroke(list, Config.ACCENT2, 1, 0.5)

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = list

    local listPad = Instance.new("UIPadding")
    listPad.PaddingTop = UDim.new(0, 3)
    listPad.PaddingBottom = UDim.new(0, 3)
    listPad.Parent = list

    local function close()
        open = false
        TweenService:Create(list, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        task.delay(0.2, function() list.Visible = false end)
    end

    local function openList()
        open = true
        list.Visible = true
        list.Size = UDim2.new(1, 0, 0, 0)
        for _, c in pairs(list:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, -6, 0, 24)
            optBtn.BackgroundColor3 = Config.BG
            optBtn.BackgroundTransparency = 1
            optBtn.Text = tostring(opt)
            optBtn.TextColor3 = Config.TEXT
            optBtn.TextSize = 10
            optBtn.Font = Enum.Font.GothamMedium
            optBtn.BorderSizePixel = 0
            optBtn.LayoutOrder = i
            optBtn.Parent = list
            Round(optBtn, 5)
            optBtn.MouseButton1Click:Connect(function()
                current = opt
                valLbl.Text = tostring(opt)
                if callback then pcall(callback, opt) end
                close()
            end)
        end
        local targetH = math.min(#options * 26 + 6, 160)
        TweenService:Create(list, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetH)}):Play()
    end

    clickBtn.MouseButton1Click:Connect(function()
        if open then close() else openList() end
    end)
end

-- COLOR PICKER
function CreateColorPicker(name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 34)
    frame.BackgroundColor3 = Config.BG
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = contentScroll
    Round(frame, 10)
    Stroke(frame, Config.ACCENT, 1, 0.8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Config.TEXT
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 40, 0, 20)
    colorBtn.Position = UDim2.new(1, -50, 0.5, -10)
    colorBtn.BackgroundColor3 = default
    colorBtn.Text = ""
    colorBtn.BorderSizePixel = 0
    colorBtn.Parent = frame
    Round(colorBtn, 5)
    Stroke(colorBtn, Config.ACCENT2, 1.5)

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
    local colorIdx = 1

    colorBtn.MouseButton1Click:Connect(function()
        colorIdx = colorIdx + 1
        if colorIdx > #presets then colorIdx = 1 end
        local c = presets[colorIdx]
        colorBtn.BackgroundColor3 = c
        if callback then pcall(callback, c) end
    end)
end

-- =========================================================
-- FLOATING BUTTON SYSTEM
-- =========================================================
function CreateFloatingButton(id, icon, label, defaultPos, callback)
    local data = State.FloatingButtons[id]
    if not data then return end

    if data.Gui then data.Gui:Destroy(); data.Gui = nil end

    local gui = Instance.new("ScreenGui")
    gui.Name = "Roooor_" .. id .. "_Btn"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    gui.Parent = PlayerGui
    data.Gui = gui

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 44)
    btn.Position = data.Position or defaultPos
    btn.BackgroundColor3 = Config.PANEL
    btn.Text = icon
    btn.TextColor3 = Config.TEXT
    btn.TextSize = 20
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = gui
    Round(btn, 22)
    local btnStroke = Stroke(btn, Config.ACCENT2, 2)
    data.Button = btn

    local btnGrad = Instance.new("UIGradient")
    btnGrad.Color = ColorSequence.new(Config.PANEL, Config.ACCENT4, Config.PANEL)
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
    Round(glow, 26)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 100, 0, 14)
    lbl.Position = UDim2.new(0.5, -50, 1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Config.ACCENT2
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextStrokeTransparency = 0.3
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.Parent = btn

    local lockLbl = Instance.new("TextLabel")
    lockLbl.Name = "LockLabel"
    lockLbl.Size = UDim2.new(0, 100, 0, 10)
    lockLbl.Position = UDim2.new(0.5, -50, 1, 15)
    lockLbl.BackgroundTransparency = 1
    lockLbl.Text = "🔓 UNLOCKED"
    lockLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lockLbl.TextSize = 8
    lockLbl.Font = Enum.Font.GothamBold
    lockLbl.TextStrokeTransparency = 0.4
    lockLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lockLbl.Visible = false
    lockLbl.Parent = btn

    local dragB = false
    local dBStart, dBStartPos
    local wasDragged = false
    local lastClick = 0

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            if data.Locked then return end
            dragB = true
            wasDragged = false
            dBStart = input.Position
            dBStartPos = btn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragB = false end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragB and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dBStart
            if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then wasDragged = true end
            btn.Position = UDim2.new(
                dBStartPos.X.Scale, dBStartPos.X.Offset + d.X,
                dBStartPos.Y.Scale, dBStartPos.Y.Offset + d.Y
            )
            data.Position = btn.Position
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if wasDragged then wasDragged = false; return end
        if tick() - lastClick < 0.15 then return end
        lastClick = tick()
        if callback then pcall(callback, btn, btnStroke) end
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
                if hum then
                    if State.Movement.WalkSpeedEnabled then
                        hum.WalkSpeed = State.Movement.WalkSpeedValue
                    else
                        hum.WalkSpeed = 16
                    end
                end
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

print("✅ [ROOORHUB] BAGIAN 2/4 loaded")-- =========================================================
-- ROOORHUB - ULTIMATE KILLER (FIXED)
-- BAGIAN 1/4 : CORE + GUI BASE
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

local Config = {
    BG = Color3.fromRGB(10, 8, 18),
    PANEL = Color3.fromRGB(20, 15, 35),
    ACCENT = Color3.fromRGB(255, 50, 130),
    ACCENT2 = Color3.fromRGB(0, 255, 200),
    ACCENT3 = Color3.fromRGB(255, 200, 0),
    ACCENT4 = Color3.fromRGB(150, 80, 255),
    TEXT = Color3.fromRGB(245, 245, 255),
    TEXT_DIM = Color3.fromRGB(130, 130, 160),
    DANGER = Color3.fromRGB(255, 70, 90),
    SUCCESS = Color3.fromRGB(0, 255, 150),
}

local State = {
    MaskedPower = { Enabled = false, CurrentPower = "Cobra", Powers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"} },
    AutoSpamAttack = { Enabled = false, Delay = 0.35 },
    AutoKillAll = { Enabled = false, PredictStrength = 0.15, BehindOffset = 3 },
    AutoCarry = { Enabled = false },
    AutoStalk = { Enabled = false, StalkRange = 150 },
    Aimlock = { Enabled = false, Holding = false, Target = "Survivor", AimPart = "Head", FOV = 250, Radius = 500, Prediction = 0.12, Smoothness = 0.5 },
    HitboxExpander = { Enabled = false, Size = 15, Transparency = 0.7, Color = Color3.fromRGB(255, 50, 130), OnlySurvivors = true },
    AntiStun = { Enabled = false },
    AutoParry = { Enabled = false, ParryDistance = 12, FaceSensitivity = 0.7 },
    ParryCircle = { Enabled = false, Size = 12, Color = Color3.fromRGB(255, 80, 80), Transparency = 0.7, CirclePart = nil },
    AutoFlee = { Enabled = false, DetectDistance = 50, Cooldown = 0.1, LastFlee = 0 },
    AutoWiggle = { Enabled = false, Spam = 5 },
    SkillCheck = { Enabled = false },
    Moonwalk = { Enabled = false, SpamSpeed = 30, Intensity = 35, SlowSpeed = 13, UseSlow = true },
    Visual = { NoFog = false, Fullbright = false, CustomSky = false, SkyId = "rbxassetid://159454299", Contrast = false, ContrastValue = 0.3, Brightness = 0.15, Saturation = 0.2 },
    FireEffect = { Enabled = false, Type = "Red", Size = 5 },
    ESP = { SurvivorEnabled = false, SurvivorColor = Color3.fromRGB(60, 255, 120), KillerEnabled = false, KillerColor = Color3.fromRGB(255, 60, 60), GeneratorEnabled = false, GeneratorColor = Color3.fromRGB(255, 170, 0), ShowName = true, ShowDistance = true, ShowHealth = false, NameColor = Color3.fromRGB(255, 255, 255), NameSize = 12, Radius = 100 },
    Movement = { WalkSpeedEnabled = false, WalkSpeedValue = 17.6, OriginalWalkSpeed = 16, JumpPowerEnabled = false, JumpPowerValue = 50, OriginalJumpPower = 50, NoClip = false },
    Stats = { ShowWatermark = true },
    GodMode = { Enabled = false },
    FloatingButtons = {
        Aimlock = { Enabled = false, Locked = false, Gui = nil, Button = nil, Position = UDim2.new(0.35, 0, 0.75, 0), DefaultPosition = UDim2.new(0.35, 0, 0.75, 0) },
        Moonwalk = { Enabled = false, Locked = false, Gui = nil, Button = nil, Position = UDim2.new(0.65, 0, 0.75, 0), DefaultPosition = UDim2.new(0.65, 0, 0.75, 0) },
    },
    AvatarStealer = { TargetUsername = "", OriginalDescription = nil, CurrentStealedUserId = nil, BlockyBody = true },
}

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

local FireVariants = {
    Red = { Primary = Color3.fromRGB(255, 60, 0), Secondary = Color3.fromRGB(255, 200, 0) },
    Blue = { Primary = Color3.fromRGB(0, 150, 255), Secondary = Color3.fromRGB(0, 255, 255) },
    Green = { Primary = Color3.fromRGB(0, 255, 100), Secondary = Color3.fromRGB(150, 255, 0) },
    Purple = { Primary = Color3.fromRGB(180, 0, 255), Secondary = Color3.fromRGB(255, 0, 200) },
    Rainbow = { Primary = Color3.fromRGB(255, 0, 0), Secondary = Color3.fromRGB(0, 255, 255) },
}

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
-- GLOBAL HELPER FUNCTIONS (BUKAN LOCAL!)
-- =========================================================
function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

function getHumanoid()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

function isDowned()
    local c = LP.Character
    if not c then return false end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return false end
    return h.Health <= 0 or h.Health < 2
        or c:GetAttribute("Downed") == true
        or c:GetAttribute("IsDown") == true
end

function getNearestTarget(teamName, maxDist)
    local r = getRoot()
    if not r then return nil, math.huge end
    local best, dist = nil, maxDist or math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Team and p.Team.Name == teamName then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (hrp.Position - r.Position).Magnitude
                if d < dist then dist = d; best = p.Character end
            end
        end
    end
    return best, dist
end

function getNearestKiller()
    return getNearestTarget("Killer", 999)
end

function Round(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 12)
    c.Parent = obj
end

function Stroke(obj, color, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or Config.ACCENT
    s.Thickness = thick or 1.5
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

function RainbowSeq()
    return ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 150, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(150, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 150)),
    }
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoooorHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(0, 140, 0, 20)
FPSLabel.Position = UDim2.new(0.5, -70, 0, 5)
FPSLabel.BackgroundColor3 = Config.PANEL
FPSLabel.BackgroundTransparency = 0.4
FPSLabel.Text = "FPS: -- | PING: --"
FPSLabel.TextColor3 = Config.ACCENT2
FPSLabel.TextSize = 11
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextStrokeTransparency = 0.5
FPSLabel.Parent = ScreenGui
Round(FPSLabel, 6)
Stroke(FPSLabel, Config.ACCENT, 1, 0.5)

local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 38, 0, 38)
FloatBtn.Position = UDim2.new(0, 20, 0.5, -19)
FloatBtn.BackgroundColor3 = Config.PANEL
FloatBtn.Text = "⚡"
FloatBtn.TextColor3 = Config.ACCENT2
FloatBtn.TextSize = 20
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.BorderSizePixel = 0
FloatBtn.AutoButtonColor = false
FloatBtn.Parent = ScreenGui
Round(FloatBtn, 19)
local floatStroke = Stroke(FloatBtn, Config.ACCENT, 2)

local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(0, 100, 0, 22)
NameLabel.Position = UDim2.new(0.5, -50, 1, 3)
NameLabel.BackgroundTransparency = 1
NameLabel.Text = "ROOORHUB"
NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLabel.TextSize = 12
NameLabel.Font = Enum.Font.GothamBlack
NameLabel.TextStrokeTransparency = 0
NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
NameLabel.Parent = FloatBtn

local nameGrad = Instance.new("UIGradient")
nameGrad.Color = RainbowSeq()
nameGrad.Parent = NameLabel

task.spawn(function()
    while NameLabel.Parent do
        for i = 0, 1, 0.02 do
            if not NameLabel.Parent then break end
            nameGrad.Rotation = i * 360
            task.wait(0.05)
        end
    end
end)

local dragF = false
local dragFStart, dragFPos
FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragF = true
        dragFStart = input.Position
        dragFPos = FloatBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragF = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragF and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragFStart
        FloatBtn.Position = UDim2.new(dragFPos.X.Scale, dragFPos.X.Offset + d.X, dragFPos.Y.Scale, dragFPos.Y.Offset + d.Y)
    end
end)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 480, 0, 360)
Main.Position = UDim2.new(0.5, -240, 0.5, -180)
Main.BackgroundColor3 = Config.BG
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui
Round(Main, 16)
local mainStroke = Stroke(Main, Config.ACCENT, 2, 0.2)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Config.PANEL
Header.BackgroundTransparency = 0.1
Header.BorderSizePixel = 0
Header.Parent = Main
Round(Header, 16)

local headerPatch = Instance.new("Frame")
headerPatch.Size = UDim2.new(1, 0, 0, 20)
headerPatch.Position = UDim2.new(0, 0, 1, -20)
headerPatch.BackgroundColor3 = Config.PANEL
headerPatch.BackgroundTransparency = 0.1
headerPatch.BorderSizePixel = 0
headerPatch.Parent = Header

local neonLine = Instance.new("Frame")
neonLine.Size = UDim2.new(1, -30, 0, 2)
neonLine.Position = UDim2.new(0, 15, 1, -1)
neonLine.BackgroundColor3 = Config.ACCENT
neonLine.BorderSizePixel = 0
neonLine.Parent = Header
local neonGrad = Instance.new("UIGradient")
neonGrad.Color = RainbowSeq()
neonGrad.Parent = neonLine

task.spawn(function()
    while neonLine.Parent do
        for i = 0, 1, 0.02 do
            if not neonLine.Parent then break end
            neonGrad.Rotation = i * 360
            task.wait(0.05)
        end
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 45, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ ROOORHUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.StrokeTransparency = 0
Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Title.Parent = Header

local titleGrad = Instance.new("UIGradient")
titleGrad.Color = RainbowSeq()
titleGrad.Parent = Title

task.spawn(function()
    while Title.Parent do
        for i = 0, 1, 0.02 do
            if not Title.Parent then break end
            titleGrad.Rotation = i * 360
            task.wait(0.05)
        end
    end
end)

local function makeCtrlBtn(icon, xPos, color, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 24, 0, 24)
    b.Position = UDim2.new(1, xPos, 0.5, -12)
    b.BackgroundColor3 = Config.PANEL
    b.Text = icon
    b.TextColor3 = color
    b.TextSize = 14
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = Header
    Round(b, 6)
    Stroke(b, color, 1, 0.6)
    b.MouseButton1Click:Connect(cb)
end

makeCtrlBtn("✕", -34, Config.DANGER, function()
    Main.Visible = false
    FloatBtn.Visible = true
end)
makeCtrlBtn("—", -64, Config.ACCENT2, function()
    Main.Visible = false
    FloatBtn.Visible = true
end)

FloatBtn.MouseButton1Click:Connect(function()
    FloatBtn.Visible = false
    Main.Visible = true
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -65)
Sidebar.Position = UDim2.new(0, 12, 0, 55)
Sidebar.BackgroundColor3 = Config.PANEL
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Round(Sidebar, 12)
Stroke(Sidebar, Config.ACCENT4, 1, 0.7)

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 4)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Parent = Sidebar

local sidebarPad = Instance.new("UIPadding")
sidebarPad.PaddingTop = UDim.new(0, 8)
sidebarPad.PaddingLeft = UDim.new(0, 6)
sidebarPad.PaddingRight = UDim.new(0, 6)
sidebarPad.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -156, 1, -65)
Content.Position = UDim2.new(0, 144, 0, 55)
Content.BackgroundColor3 = Config.PANEL
Content.BackgroundTransparency = 0.3
Content.BorderSizePixel = 0
Content.Parent = Main
Round(Content, 12)
Stroke(Content, Config.ACCENT2, 1, 0.7)

local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Size = UDim2.new(1, -16, 1, -16)
contentScroll.Position = UDim2.new(0, 8, 0, 8)
contentScroll.BackgroundTransparency = 1
contentScroll.BorderSizePixel = 0
contentScroll.ScrollBarThickness = 3
contentScroll.ScrollBarImageColor3 = Config.ACCENT
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentScroll.Parent = Content

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 6)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentScroll

-- =========================================================
-- TAB SYSTEM (GLOBAL)
-- =========================================================
_G.ActiveTab = nil

function CreateTab(name, icon, order, callback)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(1, 0, 0, 32)
    tab.BackgroundColor3 = Config.BG
    tab.BackgroundTransparency = 1
    tab.Text = ""
    tab.BorderSizePixel = 0
    tab.LayoutOrder = order
    tab.AutoButtonColor = false
    tab.Parent = Sidebar
    Round(tab, 8)

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0, 0)
    indicator.Position = UDim2.new(0, 0, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.BackgroundColor3 = Config.ACCENT
    indicator.BorderSizePixel = 0
    indicator.Parent = tab
    Round(indicator, 2)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 24, 1, 0)
    iconLbl.Position = UDim2.new(0, 8, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextColor3 = Config.TEXT_DIM
    iconLbl.TextSize = 14
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = tab

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -36, 1, 0)
    label.Position = UDim2.new(0, 36, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = string.upper(name)
    label.TextColor3 = Config.TEXT_DIM
    label.TextSize = 10
    label.Font = Enum.Font.GothamBlack
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tab

    tab.MouseButton1Click:Connect(function()
        if _G.ActiveTab == tab then return end
        if _G.ActiveTab then
            local oldInd = _G.ActiveTab:FindFirstChildOfClass("Frame")
            _G.ActiveTab.BackgroundTransparency = 1
            for _, c in pairs(_G.ActiveTab:GetChildren()) do
                if c:IsA("TextLabel") then c.TextColor3 = Config.TEXT_DIM end
            end
            if oldInd then oldInd.Size = UDim2.new(0, 3, 0, 0) end
        end
        _G.ActiveTab = tab
        tab.BackgroundTransparency = 0.75
        indicator.Size = UDim2.new(0, 3, 0, 20)
        for _, c in pairs(tab:GetChildren()) do
            if c:IsA("TextLabel") then c.TextColor3 = Config.TEXT end
        end
        for _, c in pairs(contentScroll:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
        if callback then pcall(callback) end
    end)
end

local dragW = false
local dragWStart, dragWPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragW = true
        dragWStart = input.Position
        dragWPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragW = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragW and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragWStart
        Main.Position = UDim2.new(dragWPos.X.Scale, dragWPos.X.Offset + d.X, dragWPos.Y.Scale, dragWPos.Y.Offset + d.Y)
    end
end)

print("✅ [ROOORHUB] BAGIAN 1/4 loaded")
