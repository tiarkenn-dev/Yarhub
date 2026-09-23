-- ⚡ TIARHUB v19 - Part 1/5: Setup + Config + ESP
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local InsertService = game:GetService("InsertService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local RainbowHue = 0
RunService.Heartbeat:Connect(function() RainbowHue = (RainbowHue + 0.008) % 1 end)
local function getRainbowColor() return Color3.fromHSV(RainbowHue, 1, 1) end

local Window = Rayfield:CreateWindow({
    name = "⚡ TiarHub ⚡",
    subtitle = "Violence District | v19",
    sidebarLayout = true,
    configuration = { autoSave = true, autoLoad = true, fileName = "TiarHubV19" }
})

-- ESP CONFIG
local ESP = {
    Survivor=false, Killer=false, Generator=false, Hook=false, Pallet=false, Window=false, SCP=false,
    Distance=300, Mode="Highlight", ShowName=true, NameSize=14,
    SurvivorColor=Color3.fromRGB(60,255,120), KillerColor=Color3.fromRGB(255,60,60),
    GeneratorColor=Color3.fromRGB(255,170,0), HookColor=Color3.fromRGB(180,80,255),
    PalletColor=Color3.fromRGB(255,220,80), WindowColor=Color3.fromRGB(80,255,255),
    SCPColor=Color3.fromRGB(255,0,0)
}
local ESPStatus = { Enabled=false, ShowName=true, ShowDistance=true, ShowHealth=false, Radius=100 }
local KillerWarning = { Enabled=false, Distance=60, Color=Color3.fromRGB(255,0,0) }

-- VISUAL CONFIG
local Visual = {
    Fullbright=false, NoFog=false, NoShadow=false, NoBloom=false, NoBlur=false,
    ColorCorrection=false, Saturation=0, Brightness=0, Contrast=0,
    AmbientColorEnabled=false, AmbientColor=Color3.fromRGB(255,255,255),
    ClockTimeEnabled=false, ClockTime=14,
    FogControlEnabled=false, FogEnd=100000, FogStart=0, FogColor=Color3.fromRGB(200,200,200),
    NoBlood=false
}
local VisualOriginal = {
    Brightness=Lighting.Brightness, ClockTime=Lighting.ClockTime,
    Ambient=Lighting.Ambient, OutdoorAmbient=Lighting.OutdoorAmbient,
    GlobalShadows=Lighting.GlobalShadows, FogEnd=Lighting.FogEnd,
    FogStart=Lighting.FogStart, FogColor=Lighting.FogColor
}

-- AUTO CONFIG
local PARRY_PRESETS = {
    Safety = { Distance=12, Debounce=0.15, Face=0.5, RequireFacing=true },
    Aggressive = { Distance=20, Debounce=0.05, Face=-1, RequireFacing=false }
}
local Auto = { Parry=false, ParryMode="Safety", ParryDistance=12, FaceSensitivity=0.5, RequireFacing=true, SkillCheck=false, Wiggle=false, WiggleSpam=5 }
local PARRY_DEBOUNCE = 0.15
local function applyParryPreset(mode)
    local p = PARRY_PRESETS[mode]; if not p then return end
    Auto.ParryDistance=p.Distance; Auto.FaceSensitivity=p.Face; Auto.RequireFacing=p.RequireFacing; PARRY_DEBOUNCE=p.Debounce
end

local ParryRangeVisual = { Enabled=false, Color=Color3.fromRGB(255,80,80), Transparency=0.7, RainbowMode=false, PulseEnabled=true }
local ParryCircle=nil; local ParryCircleInner=nil; local ParryActive=false
local AutoFlee = { Enabled=false, DetectDistance=50, Cooldown=0.1 }
local LastFlee = 0
local FastVault = { Enabled=false, Speed=1.2, ReplaceMap={ ["rbxassetid://83873880822918"]="rbxassetid://136962284480779" } }
local VaultTracks = {}
local AutoDodgeAbyss = { Enabled=false, DetectRange=18, Cooldown=0.5, CrouchDuration=0.3, LastDodge=0, IsCrouching=false }

-- FAKE PERKS + COOLDOWN 70s
local FakePerks = {
    Flowstate = { Enabled=false, Duration=3, SpeedBoost=20, Cooldown=30, LastUse=0 },
    SnakeStep = { Enabled=false, SpeedBoost=90, Cooldown=30, LastUse=0 },
    QuickRecovery = { Enabled=false, Cooldown=30, LastUse=0 },
    LastVault=0, LastCrouchState=false
}

local SilentAimSpear = { Enabled=false, TargetMode="Killer", FOV=250, AimPart="HumanoidRootPart", Prediction=0.12, Holding=false, ShowFOV=false }
local SilentAimCircle = nil
local Teleport = { LastTeleport=0, Cooldown=0.5 }
local AutoEscape = { Enabled=false, DetectDistance=40, Cooldown=0.8, LastEscape=0 }
local SkillCheckMode = "Perfect"

-- SOUND
local SoundFeedback = { Enabled=true, CurrentSound="Click", Volume=0.5, LastPlay=0, Cooldown=0.05 }
local SoundList = { Click="rbxassetid://6895079853", Switch="rbxassetid://876939830", Beep="rbxassetid://4817809188", Bell="rbxassetid://5156781795", Whoosh="rbxassetid://5063167535" }
local SoundInstance = nil
local function initSound()
    if SoundInstance then return end
    SoundInstance = Instance.new("Sound"); SoundInstance.Name="TiarClickSound"; SoundInstance.Volume=SoundFeedback.Volume
    pcall(function() SoundInstance.Parent=SoundService end)
    if not SoundInstance.Parent then SoundInstance.Parent=CoreGui end
end
local function playClickSound()
    if not SoundFeedback.Enabled then return end
    local now = tick()
    if now - SoundFeedback.LastPlay < SoundFeedback.Cooldown then return end
    SoundFeedback.LastPlay = now; initSound()
    pcall(function()
        SoundInstance.SoundId = SoundList[SoundFeedback.CurrentSound] or SoundList.Click
        SoundInstance.Volume = SoundFeedback.Volume; SoundInstance:Play()
    end)
end
initSound()

local AvatarCopier = { Enabled=true, TargetUsername="", OriginalDescription=nil, CurrentCopiedUserId=nil, BlockyBody=true }

-- AIMBOT
local GunAim = { Enabled=false, Holding=false, TargetMode="Killer", Strength=1, Predict=true, PredictStrength=0.12, FOV=250, VisibilityCheck=false, AimPart="HumanoidRootPart", ShowTracer=false, TracerColor=Color3.fromRGB(255,0,0) }
local FOVCircle=nil; local FOVCircleInner=nil; local FOVCircleVisible=false
local FOVCircleSize=250; local FOVCircleColor=Color3.fromRGB(255,255,255)
local KillerAim = { Enabled=false, FOV=200, Strength=0.5, Holding=false }

-- AIMLOCK
local Aimlock = { Enabled=false, Mode="Killer", RadiusLock=250, AimPart="Head", Smoothness=0.35, Prediction=true, PredictStrength=0.12, ShowFOV=true, AutoSnap=false, Target=nil, Holding=false, Locked=false }
local AimlockFOV = nil

-- KILLER
local Killer = { AutoAttack=false, AutoCarry=false, AutoHook=false, KillAll=false, AutoStalk=false, StalkRange=150, AutoHookAllDowned=false, AutoHookAllRange=500, AutoSprint=false, AutoSprintValue=30, AutoFaceTarget=false, AutoFaceRange=20, PredictionAttack=false, PredictStrength=0.15 }
local KillerBusy=false; local KillerTarget=nil; local StalkConnection=nil
local HitMarker = { Enabled=false, Color=Color3.fromRGB(255,0,0), Size=20, Thickness=2, Duration=0.15 }
local HitMarkerLines={}; local HitMarkerActive=false; local HitMarkerEnd=0
local ChaseDetector = { Enabled=false, Range=30, LastNotify=0, Cooldown=2 }

-- MOVEMENT
local Movement = { WalkSpeedEnabled=false, WalkSpeedValue=17.6, OriginalWalkSpeed=16, NoClip=false }
local Moonwalk = { Enabled=false, ShowButton=false, SpamSpeed=30, Intensity=35, SlowSpeed=13, UseSlow=true, Mode="Default", FOVPreset=90 }
local MoonwalkConnection=nil; local MoonwalkHeartbeat=nil
local Crosshair = { Enabled=false, Size=8, Thickness=2, Color=Color3.fromRGB(255,255,255), OffsetX=0, OffsetY=0 }
local CrosshairGui = nil
local Emote = { Selected="Mannrobics" }
local EmoteList = { "Mannrobics","Arm Swing","Schadenfreude","Kyoufuu","Backflip","Griddy","Friday Night","Floating Rest","OnePlays","Quick Combo","WarCry","Wave" }
local Masked = { CurrentPower="Cobra" }
local MaskedPowers = {"Cobra","Richter","Brandon","Rabbit","Alex"}
local FPS=0; local Frames=0; local LastTick=tick()

-- KILLER ANIMS
local KillerAnims = {
["rbxassetid://105374834496520"]=true,["rbxassetid://113255068724446"]=true,["rbxassetid://118907603246885"]=true,
["rbxassetid://129784271201071"]=true,["rbxassetid://117042998468241"]=true,["rbxassetid://122812055447896"]=true,
["rbxassetid://78935059863801"]=true,["rbxassetid://74968262036854"]=true,["rbxassetid://78432063483146"]=true,
["rbxassetid://132817836308238"]=true,["rbxassetid://133963973694098"]=true,["rbxassetid://111920872708571"]=true,
["rbxassetid://80411309607666"]=true,["rbxassetid://98163597193511"]=true,["rbxassetid://82666958311998"]=true,
["rbxassetid://110355011987939"]=true,["rbxassetid://139369275981139"]=true,["rbxassetid://135002183282873"]=true,
["rbxassetid://121216847022485"]=true,["rbxassetid://130593238885843"]=true,["rbxassetid://117070354890871"]=true,
["rbxassetid://106871536134254"]=true,["rbxassetid://138720291317243"]=true
}

local function findRemote(path)
    local cur = ReplicatedStorage
    for segment in string.gmatch(path, "[^%.]+") do
        cur = cur and cur:FindFirstChild(segment)
        if not cur then return nil end
    end
    return cur
end
local AttackEvent = findRemote("Remotes.Attacks.BasicAttack")
local CarryEvent = findRemote("Remotes.Carry.CarrySurvivorEvent")
local HookEvent = findRemote("Remotes.Carry.HookEvent")
local EmoteRemote = findRemote("Remotes.EmoteHandler")

-- HELPER
local function getRoot() local char = LocalPlayer.Character; return char and char:FindFirstChild("HumanoidRootPart") end
local function getHum() local char = LocalPlayer.Character; return char and char:FindFirstChildOfClass("Humanoid") end
local function isDowned() local hum = getHum(); if not hum then return false end; return hum.Health<=0 or hum.Health<2 end
local function shouldDisableWalkSpeed()
    local char = LocalPlayer.Character; if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local anim = track.Animation
                if anim and anim.AnimationId then
                    local id = anim.AnimationId:match("%d+")
                    if id and KillerAnims["rbxassetid://"..id] then return true end
                end
            end
        end
    end
    if hum and (hum.Health<=0 or hum.Health<2) then return true end
    return false
end
local function GetPos(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj.Position end
    if obj:IsA("Model") then
        local ok, pivot = pcall(function() return obj:GetPivot().Position end)
        if ok then return pivot end
    end
    return nil
end
local function getTeamLabel(plr)
    if not plr.Team then return "?" end
    if plr.Team.Name=="Killer" then return "KILLER" end
    if plr.Team.Name=="Survivors" or plr.Team.Name=="Survivor" then return "SURVIVOR" end
    return plr.Team.Name
end
local function GetNearestKiller()
    local root = getRoot(); if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team and plr.Team.Name=="Killer" and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position-root.Position).Magnitude
                if dist<shortest then shortest=dist; closest=hrp end
            end
        end
    end
    return closest, shortest
end

-- ESP SYSTEM
local ESPObjects={}; local ESPNames={}; local StatusESP={}
local CachedObjects = { Generators={}, Hooks={}, Pallets={}, Windows={} }
local CachedSCP = {}
local function removeESP(obj)
    if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj]=nil end
    if ESPNames[obj] then ESPNames[obj]:Destroy(); ESPNames[obj]=nil end
end
local function createESP(obj, color, showName, customName)
    if not obj then return end
    if ESPObjects[obj] then
        local h = ESPObjects[obj]
        if ESP.Mode=="Outline" then h.FillTransparency=1; h.OutlineTransparency=0
        elseif ESP.Mode=="Fill" then h.FillTransparency=0.5; h.OutlineTransparency=1
        else h.FillTransparency=0.9; h.OutlineTransparency=0.3 end
        h.FillColor=color; h.OutlineColor=color
    else
        local h = Instance.new("Highlight")
        h.FillColor=color; h.OutlineColor=color
        if ESP.Mode=="Outline" then h.FillTransparency=1; h.OutlineTransparency=0
        elseif ESP.Mode=="Fill" then h.FillTransparency=0.5; h.OutlineTransparency=1
        else h.FillTransparency=0.9; h.OutlineTransparency=0.3 end
        h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Parent=obj; ESPObjects[obj]=h
        obj.AncestryChanged:Connect(function(_, parent) if not parent then removeESP(obj) end end)
    end
    if showName then
        local head = obj:FindFirstChild("Head")
        local adornee = head or (obj:IsA("BasePart") and obj)
        if adornee then
            local playerName = customName or "?"; local teamLabel = ""
            if not customName then
                local plr = Players:GetPlayerFromCharacter(obj)
                if plr then playerName=plr.Name; teamLabel=getTeamLabel(plr) end
            end
            local displayText = playerName
            if teamLabel ~= "" then displayText = string.format("[%s] %s", teamLabel, playerName) end
            if ESPNames[obj] then
                local bb = ESPNames[obj]; bb.Size = UDim2.new(0,250,0,ESP.NameSize*2)
                local lbl = bb:FindFirstChildOfClass("TextLabel")
                if lbl then lbl.Text=displayText; lbl.TextSize=ESP.NameSize; lbl.TextColor3=color end
            else
                local bb = Instance.new("BillboardGui")
                bb.Size = UDim2.new(0,250,0,ESP.NameSize*2); bb.AlwaysOnTop=true
                bb.StudsOffset=Vector3.new(0,2.5,0); bb.Adornee=adornee; bb.Parent=obj
                local lbl = Instance.new("TextLabel")
                lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1; lbl.Text=displayText
                lbl.TextColor3=color; lbl.TextStrokeTransparency=0; lbl.TextStrokeColor3=Color3.new(0,0,0)
                lbl.Font=Enum.Font.GothamBold; lbl.TextSize=ESP.NameSize; lbl.Parent=bb
                ESPNames[obj]=bb
            end
        end
    end
end
local function UpdateGenerator(gen)
    if not gen or not gen.Parent then return end
    if not ESP.Generator then
        local o=gen:FindFirstChild("GenHighlight"); if o then o:Destroy() end
        local n=gen:FindFirstChild("GenNameTag"); if n then n:Destroy() end
        return
    end
    local percent=0; local found=false
    local a=gen:GetAttribute("Progress"); if a and type(a)=="number" then percent=a; found=true end
    if not found then
        local a2=gen:GetAttribute("RepairProgress"); if a2 and type(a2)=="number" then percent=a2; found=true end
    end
    if not found then
        for _, v in ipairs(gen:GetDescendants()) do
            if v:IsA("ValueBase") and (v.Name=="Progress" or v.Name=="RepairProgress" or v.Name=="Percent") then percent=v.Value; found=true; break end
        end
    end
    if not found then
        for _, v in ipairs(gen:GetChildren()) do if v:IsA("NumberValue") then percent=v.Value; found=true; break end end
    end
    percent=math.clamp(percent,0,100)
    local color=ESP.GeneratorColor; local txt="Generator"
    if found then
        color=ESP.GeneratorColor:Lerp(Color3.fromRGB(0,255,120),percent/100)
        txt=string.format("Gen %.0f%%", percent)
    end
    local h=gen:FindFirstChild("GenHighlight") or Instance.new("Highlight")
    h.Name="GenHighlight"; h.Adornee=gen; h.FillColor=color; h.OutlineColor=color
    if ESP.Mode=="Outline" then h.FillTransparency=1; h.OutlineTransparency=0
    elseif ESP.Mode=="Fill" then h.FillTransparency=0.5; h.OutlineTransparency=1
    else h.FillTransparency=0.9; h.OutlineTransparency=0.3 end
    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Parent=gen
    local bb=gen:FindFirstChild("GenNameTag")
    if not bb then
        bb=Instance.new("BillboardGui"); bb.Name="GenNameTag"; bb.Size=UDim2.new(0,150,0,40)
        bb.AlwaysOnTop=true; bb.StudsOffset=Vector3.new(0,3,0); bb.Adornee=gen; bb.Parent=gen
        local lbl=Instance.new("TextLabel")
        lbl.Name="Label"; lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
        lbl.TextStrokeTransparency=0; lbl.TextStrokeColor3=Color3.new(0,0,0)
        lbl.Font=Enum.Font.GothamBold; lbl.TextSize=14; lbl.Parent=bb
    end
    local lbl=bb:FindFirstChild("Label") or bb:FindFirstChildOfClass("TextLabel")
    if lbl then lbl.Text=txt; lbl.TextColor3=color end
end
local function removeStatusESP(char) if StatusESP[char] then StatusESP[char]:Destroy(); StatusESP[char]=nil end end
local function createStatusESP(player, char, root)
    if not ESPStatus.Enabled then removeStatusESP(char); return end
    if not root then return end
    local head=char:FindFirstChild("Head"); local hum=char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end
    local isDown = hum.Health<=0 or hum.Health<2
    local dist = (head.Position-root.Position).Magnitude
    if dist > ESPStatus.Radius then removeStatusESP(char); return end
    local text = ""
    local teamLabel = getTeamLabel(player)
    if isDown then text="DOWN\n" end
    text = text .. string.format("[%s]\n", teamLabel)
    if ESPStatus.ShowName then text=text..player.Name.."\n" end
    if ESPStatus.ShowDistance then text=text..string.format("Dist: %.0f\n",dist) end
    if ESPStatus.ShowHealth then text=text..string.format("HP: %.0f\n",hum.Health) end
    if text=="" then removeStatusESP(char); return end
    local bb=StatusESP[char]
    if not bb then
        bb=Instance.new("BillboardGui"); bb.Size=UDim2.new(0,150,0,60); bb.AlwaysOnTop=true
        local lbl=Instance.new("TextLabel")
        lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1; lbl.TextStrokeTransparency=0
        lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12; lbl.Parent=bb
        bb.Adornee=head; bb.StudsOffset=Vector3.new(0,3,0); bb.Parent=char; StatusESP[char]=bb
    end
    local lbl=bb:FindFirstChildOfClass("TextLabel")
    if lbl then
        lbl.Text=text
        local tc=Color3.new(1,1,1)
        if player.Team then
            if player.Team.Name=="Killer" then tc=ESP.KillerColor
            elseif player.Team.Name=="Survivors" or player.Team.Name=="Survivor" then tc=ESP.SurvivorColor end
        end
        if isDown then tc=Color3.fromRGB(255,0,0) end
        lbl.TextColor3=tc
    end
end
local function cacheObject(obj)
    if not obj then return end
    if not obj:IsA("BasePart") and not obj:IsA("Model") then return end
    local name=obj.Name
    if name=="Generator" then CachedObjects.Generators[obj]=true
    elseif string.find(name,"Hook") and obj:IsA("BasePart") then CachedObjects.Hooks[obj]=true
    elseif name=="Pallet" or name=="Palletwrong" then CachedObjects.Pallets[obj]=true
    elseif name=="Window" then CachedObjects.Windows[obj]=true end
    if string.find(string.lower(name),"scp") then CachedSCP[obj]=true end
end
for _, obj in ipairs(workspace:GetDescendants()) do cacheObject(obj) end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(function(obj)
    CachedObjects.Generators[obj]=nil; CachedObjects.Hooks[obj]=nil
    CachedObjects.Pallets[obj]=nil; CachedObjects.Windows[obj]=nil
    CachedSCP[obj]=nil; removeESP(obj)
end)
local WarningGui=nil
local function updateWarning()
    pcall(function()
        local root = getRoot()
        if not KillerWarning.Enabled or not root then
            if WarningGui then WarningGui.Enabled=false end
            return
        end
        local nearest, dist = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local isKiller = p.Team and p.Team.Name=="Killer"
                if isKiller then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local d = (hrp.Position-root.Position).Magnitude
                        if d<dist then dist=d; nearest=p end
                    end
                end
            end
        end
        if not WarningGui then
            WarningGui=Instance.new("ScreenGui"); WarningGui.Name="TiarKillerWarning"
            WarningGui.ResetOnSpawn=false; WarningGui.IgnoreGuiInset=true; WarningGui.Parent=PlayerGui
            local frame=Instance.new("Frame")
            frame.Name="Border"; frame.Size=UDim2.new(1,0,1,0); frame.BackgroundTransparency=1; frame.Parent=WarningGui
            local stroke=Instance.new("UIStroke")
            stroke.Name="Stroke"; stroke.Thickness=12; stroke.Color=KillerWarning.Color
            stroke.Transparency=0.5; stroke.Parent=frame
            local text=Instance.new("TextLabel")
            text.Name="WarnText"; text.Size=UDim2.new(0,400,0,60)
            text.Position=UDim2.new(0.5,-200,0,40); text.BackgroundTransparency=1
            text.Text="KILLER DEKAT"; text.TextColor3=KillerWarning.Color
            text.TextStrokeTransparency=0; text.TextStrokeColor3=Color3.new(0,0,0)
            text.Font=Enum.Font.GothamBlack; text.TextScaled=true; text.Visible=false; text.Parent=WarningGui
        end
        WarningGui.Enabled=true
        local border=WarningGui:FindFirstChild("Border")
        local stroke=border and border:FindFirstChild("Stroke")
        local warnText=WarningGui:FindFirstChild("WarnText")
        if dist <= KillerWarning.Distance then
            if stroke then stroke.Transparency=0.3 end
            if warnText then warnText.Visible=true; warnText.Text=string.format("KILLER DEKAT (%.0f stud)",dist) end
        else
            if stroke then stroke.Transparency=0.9 end
            if warnText then warnText.Visible=false end
        end
    end)
end
RunService.RenderStepped:Connect(function()
    Frames = Frames + 1
    if tick() - LastTick >= 1 then
        FPS = Frames; Frames = 0; LastTick = tick()
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        pcall(function() Rayfield:SetWatermark(string.format("⚡ TiarHub v19 ⚡ | FPS: %d | PING: %d ms", FPS, ping)) end)
    end
end)
local lastUpdate = 0
RunService.RenderStepped:Connect(function()
    pcall(function()
        local root = getRoot(); if not root then return end
        local now = tick()
        if now - lastUpdate < 0.3 then return end
        lastUpdate = now
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local dist = (hrp.Position-root.Position).Magnitude
                        if dist <= ESP.Distance then
                            local isKiller = p.Team and p.Team.Name=="Killer"
                            local isSurv = p.Team and (p.Team.Name=="Survivors" or p.Team.Name=="Survivor")
                            if ESP.Survivor and isSurv then createESP(char, ESP.SurvivorColor, ESP.ShowName)
                            elseif ESP.Killer and isKiller then createESP(char, ESP.KillerColor, ESP.ShowName)
                            else removeESP(char) end
                        else removeESP(char) end
                    end
                    createStatusESP(p, char, root)
                else removeESP(char); removeStatusESP(char) end
            end
        end
        if ESP.Generator then
            for gen in pairs(CachedObjects.Generators) do
                local pos = GetPos(gen)
                if pos and (pos-root.Position).Magnitude <= ESP.Distance then UpdateGenerator(gen)
                else
                    local o=gen:FindFirstChild("GenHighlight"); if o then o:Destroy() end
                    local n=gen:FindFirstChild("GenNameTag"); if n then n:Destroy() end
                end
            end
        end
        if ESP.Hook then
            for hook in pairs(CachedObjects.Hooks) do
                local pos = GetPos(hook)
                if pos and (pos-root.Position).Magnitude <= ESP.Distance then createESP(hook, ESP.HookColor, false)
                else removeESP(hook) end
            end
        else for hook in pairs(CachedObjects.Hooks) do removeESP(hook) end end
        if ESP.Pallet then
            for pallet in pairs(CachedObjects.Pallets) do
                local pos = GetPos(pallet)
                if pos and (pos-root.Position).Magnitude <= ESP.Distance then createESP(pallet, ESP.PalletColor, false)
                else removeESP(pallet) end
            end
        else for pallet in pairs(CachedObjects.Pallets) do removeESP(pallet) end end
        if ESP.Window then
            for win in pairs(CachedObjects.Windows) do
                local pos = GetPos(win)
                if pos and (pos-root.Position).Magnitude <= ESP.Distance then createESP(win, ESP.WindowColor, false)
                else removeESP(win) end
            end
        else for win in pairs(CachedObjects.Windows) do removeESP(win) end end
        if ESP.SCP then
            for scp in pairs(CachedSCP) do
                local pos = GetPos(scp)
                if pos and (pos-root.Position).Magnitude <= ESP.Distance then createESP(scp, ESP.SCPColor, false)
                else removeESP(scp) end
            end
        else for scp in pairs(CachedSCP) do removeESP(scp) end end
        updateWarning()
    end)
end)
print("[TiarHub v19] Part 1/5 loaded.")-- AUTO PARRY
local lastParry = 0
local function pressRightClick()
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0,0,1,true,game,0); task.wait()
        VirtualInputManager:SendMouseButtonEvent(0,0,1,false,game,0)
    end)
end
local function GetParryButton()
    local cur = PlayerGui
    for seg in string.gmatch("Survivor-mob.Controls.Gui-mob","[^%.]+") do cur = cur and cur:FindFirstChild(seg) end
    return cur
end
local function pressParryButton()
    if UserInputService.TouchEnabled then
        local btn = GetParryButton()
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition; local size = btn.AbsoluteSize
            local inset = game:GetService("GuiService"):GetGuiInset()
            pcall(function()
                VirtualInputManager:SendTouchEvent(8823,0,pos.X+size.X/2+inset.X,pos.Y+size.Y/2+inset.Y)
                task.wait(0.01)
                VirtualInputManager:SendTouchEvent(8823,2,pos.X+size.X/2+inset.X,pos.Y+size.Y/2+inset.Y)
            end)
        end
    else pressRightClick() end
end
local function doParry()
    local now = tick()
    if now - lastParry < PARRY_DEBOUNCE then return end
    lastParry = now; ParryActive = true; pressParryButton()
    task.delay(0.25, function() ParryActive = false end)
end
local hookedKillers = {}; local lastKillerParry = {}
local function hookKiller(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator"); if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not Auto.Parry then return end
        local anim = track.Animation; if not anim then return end
        local id = anim.AnimationId:match("%d+"); if not id then return end
        if not KillerAnims["rbxassetid://"..id] then return end
        local myRoot = getRoot(); local enemyRoot = char:FindFirstChild("HumanoidRootPart")
        if not myRoot or not enemyRoot then return end
        local dist = (enemyRoot.Position - myRoot.Position).Magnitude
        if dist > Auto.ParryDistance then return end
        local now = tick()
        if lastKillerParry[char] and now-lastKillerParry[char]<0.4 then return end
        lastKillerParry[char] = now; doParry()
    end)
end
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if Auto.Parry then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name=="Killer" then hookKiller(p.Character) end
                end
            end
        end)
    end
end)

-- AUTO SKILL CHECK
local TouchID = 8822
local ActionPath = "Survivor-mob.Controls.action.check"
local busy = false; local SkillHeartbeat = nil
local function GetActionTarget()
    local cur = PlayerGui
    for seg in string.gmatch(ActionPath,"[^%.]+") do cur = cur and cur:FindFirstChild(seg) end
    return cur
end
local function pressSpace()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.Space,false,game); task.wait()
        VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.Space,false,game)
    end)
end
local function TriggerMobileButton()
    local b = GetActionTarget()
    if b and b:IsA("GuiObject") then
        local p,s,i = b.AbsolutePosition, b.AbsoluteSize, game:GetService("GuiService"):GetGuiInset()
        pcall(function()
            VirtualInputManager:SendTouchEvent(TouchID,0,p.X+(s.X/2)+i.X,p.Y+(s.Y/2)+i.Y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(TouchID,2,p.X+(s.X/2)+i.X,p.Y+(s.Y/2)+i.Y)
        end)
    end
end
local function startSkillCheck()
    if SkillHeartbeat then SkillHeartbeat:Disconnect() end
    SkillHeartbeat = RunService.RenderStepped:Connect(function()
        pcall(function()
            if not Auto.SkillCheck or busy then return end
            local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui"); if not prompt then return end
            local check = prompt:FindFirstChild("Check"); if not check or not check.Visible then return end
            local line = check:FindFirstChild("Line"); local goal = check:FindFirstChild("Goal")
            if not line or not goal then return end
            local lr = line.Rotation%360; local gr = goal.Rotation%360
            if SkillCheckMode == "Instant" then
                busy = true
                task.spawn(function()
                    if UserInputService.TouchEnabled then TriggerMobileButton() else pressSpace() end
                    task.wait(0.05); busy = false
                end)
            else
                local cg = (gr+109)%360
                local diff = math.abs(lr-cg); if diff>180 then diff=360-diff end
                if diff<=3 then
                    busy = true
                    task.spawn(function()
                        if UserInputService.TouchEnabled then TriggerMobileButton() else pressSpace() end
                        task.wait(0.05); busy = false
                    end)
                end
            end
        end)
    end)
end

-- AUTO WIGGLE
local function AutoWiggle()
    if not Auto.Wiggle then return end
    local char = LocalPlayer.Character; if not char then return end
    local carried = (char:FindFirstChild("IsCarried") and char.IsCarried.Value) or (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)
    if not carried then return end
    local rem = ReplicatedStorage:FindFirstChild("Remotes"); if not rem then return end
    local car = rem:FindFirstChild("Carry"); if not car then return end
    local ev = car:FindFirstChild("SelfUnHookEvent"); if not ev then return end
    for i = 1, Auto.WiggleSpam do ev:FireServer() end
end

-- AUTO FLEE
local function GetFarthestGeneratorPoint(killerRoot)
    if not killerRoot then return nil end
    local bestPoint, farthest = nil, 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.match(obj.Name, "^GeneratorPoint%d+$") then
            local dist = (obj.Position - killerRoot.Position).Magnitude
            if dist > farthest then farthest=dist; bestPoint=obj end
        end
    end
    return bestPoint
end
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if not AutoFlee.Enabled then return end
            local root = getRoot(); if not root then return end
            local killerRoot, distance = GetNearestKiller()
            if killerRoot and distance <= AutoFlee.DetectDistance and tick()-LastFlee > AutoFlee.Cooldown then
                local point = GetFarthestGeneratorPoint(killerRoot)
                if point then LastFlee = tick(); root.CFrame = point.CFrame + Vector3.new(0,5,0) end
            end
        end)
    end
end)

-- AUTO DODGE ABYSS
local function IsAbyssKiller(plr)
    if not plr or not plr.Character then return false end
    if not plr.Team or plr.Team.Name~="Killer" then return false end
    if string.find(string.lower(plr.Character.Name),"abyss") then return true end
    if string.find(string.lower(plr.Name),"abyss") then return true end
    return false
end
local function GetNearestAbyss()
    local root = getRoot(); if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and IsAbyssKiller(plr) then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position-root.Position).Magnitude
                if d<shortest then shortest=d; closest=hrp end
            end
        end
    end
    return closest, shortest
end
local function FindCrouchButton()
    local paths = {"Survivor-mob.Controls.Gui-mob.Crouch","Survivor-mob.Controls.Gui-mob.crouch","Survivor-mob.Controls.crouch","Survivor-mob.Controls.Crouch","Survivor-mob.Controls.action.crouch","Survivor-mob.Controls.action.Crouch"}
    for _, path in ipairs(paths) do
        local cur = PlayerGui
        for seg in string.gmatch(path,"[^%.]+") do cur = cur and cur:FindFirstChild(seg) end
        if cur and cur:IsA("GuiObject") then return cur end
    end
    for _, v in ipairs(PlayerGui:GetDescendants()) do
        if v:IsA("GuiObject") and string.find(string.lower(v.Name),"crouch") then return v end
    end
    return nil
end
local function PressCrouchButton()
    local btn = FindCrouchButton()
    if btn then
        local pos = btn.AbsolutePosition; local size = btn.AbsoluteSize
        local inset = game:GetService("GuiService"):GetGuiInset()
        local x = pos.X+size.X/2+inset.X; local y = pos.Y+size.Y/2+inset.Y
        pcall(function()
            VirtualInputManager:SendTouchEvent(7777,0,x,y); task.wait(0.05)
            VirtualInputManager:SendTouchEvent(7777,2,x,y)
        end)
        return true
    end
    if not UserInputService.TouchEnabled then
        pcall(function()
            VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.C,false,game); task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.C,false,game)
        end)
        return true
    end
    return false
end
local function DoDodgeAbyss()
    if AutoDodgeAbyss.IsCrouching then return end
    AutoDodgeAbyss.IsCrouching = true
    PressCrouchButton()
    task.delay(AutoDodgeAbyss.CrouchDuration, function()
        if AutoDodgeAbyss.Enabled then PressCrouchButton() end
        AutoDodgeAbyss.IsCrouching = false
    end)
end
task.spawn(function()
    while task.wait(0.15) do
        pcall(function()
            if not AutoDodgeAbyss.Enabled then return end
            local root = getRoot(); if not root then return end
            if isDowned() then return end
            local abyssRoot, dist = GetNearestAbyss()
            if not abyssRoot then return end
            if dist > AutoDodgeAbyss.DetectRange then return end
            local now = tick()
            if now - AutoDodgeAbyss.LastDodge < AutoDodgeAbyss.Cooldown then return end
            AutoDodgeAbyss.LastDodge = now; DoDodgeAbyss()
        end)
    end
end)

-- FAKE PERKS + COOLDOWN 70s
local function hookFakeFlowstate(char)
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator"); if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not FakePerks.Flowstate.Enabled then return end
        local now = tick()
        if now - FakePerks.Flowstate.LastUse < FakePerks.Flowstate.Cooldown then return end
        local anim = track.Animation; if not anim or not anim.AnimationId then return end
        local id = anim.AnimationId:match("%d+"); if not id then return end
        local vaultIds = { ["rbxassetid://83873880822918"]=true, ["rbxassetid://136962284480779"]=true }
        if vaultIds["rbxassetid://"..id] then
            if now - FakePerks.LastVault < 1 then return end
            FakePerks.LastVault = now; FakePerks.Flowstate.LastUse = now
            local orig = hum.WalkSpeed
            hum.WalkSpeed = orig * (1 + FakePerks.Flowstate.SpeedBoost/100)
            Rayfield:Notify({ title="Fake Flowstate", content="Speed boost aktif!", duration=2 })
            task.delay(FakePerks.Flowstate.Duration, function()
                if hum and hum.Parent then hum.WalkSpeed = orig end
            end)
        end
    end)
end
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if not FakePerks.SnakeStep.Enabled then return end
            local char = LocalPlayer.Character; if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
            local crouch = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or (hum.HipHeight and hum.HipHeight<1.5)
            local now = tick()
            if crouch and not FakePerks.LastCrouchState then
                if now - FakePerks.SnakeStep.LastUse < FakePerks.SnakeStep.Cooldown then return end
                FakePerks.SnakeStep.LastUse = now; FakePerks.LastCrouchState = true
                hum.WalkSpeed = FakePerks.SnakeStep.SpeedBoost
            elseif not crouch and FakePerks.LastCrouchState then
                FakePerks.LastCrouchState = false
                if Movement.WalkSpeedEnabled then hum.WalkSpeed = Movement.WalkSpeedValue else hum.WalkSpeed = 16 end
            end
        end)
    end
end)
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if not FakePerks.QuickRecovery.Enabled then return end
            local char = LocalPlayer.Character; if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
            local now = tick()
            if now - FakePerks.QuickRecovery.LastUse < FakePerks.QuickRecovery.Cooldown then return end
            if hum:GetState()==Enum.HumanoidStateType.FallingDown or hum:GetState()==Enum.HumanoidStateType.Ragdoll or hum.Health<hum.MaxHealth*0.3 then
                FakePerks.QuickRecovery.LastUse = now
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            end
        end)
    end
end)
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1); pcall(function() hookFakeFlowstate(char) end)
end)
if LocalPlayer.Character then pcall(function() hookFakeFlowstate(LocalPlayer.Character) end) end

-- FOV CIRCLE + TRACER
local Drawing = Drawing
local TracerLine = nil
local function createFOVCircle()
    if not Drawing then return end
    if FOVCircle then FOVCircle:Remove() end
    if FOVCircleInner then FOVCircleInner:Remove() end
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible=false; FOVCircle.Thickness=2; FOVCircle.NumSides=80
    FOVCircle.Radius=FOVCircleSize; FOVCircle.Filled=false
    FOVCircle.Color=FOVCircleColor; FOVCircle.Transparency=0.6
    FOVCircleInner = Drawing.new("Circle")
    FOVCircleInner.Visible=false; FOVCircleInner.Thickness=1; FOVCircleInner.NumSides=80
    FOVCircleInner.Radius=FOVCircleSize-3; FOVCircleInner.Filled=false
    FOVCircleInner.Color=FOVCircleColor; FOVCircleInner.Transparency=0.3
end
local function createTracer()
    if not Drawing then return end
    if TracerLine then TracerLine:Remove() end
    TracerLine = Drawing.new("Line")
    TracerLine.Visible=false; TracerLine.Thickness=1; TracerLine.Color=GunAim.TracerColor
end
createTracer(); createFOVCircle()
RunService.RenderStepped:Connect(function()
    pcall(function()
        if not FOVCircle then return end
        if FOVCircleVisible then
            FOVCircle.Visible=true; FOVCircle.Radius=FOVCircleSize; FOVCircle.Color=FOVCircleColor
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            if FOVCircleInner then
                FOVCircleInner.Visible=true; FOVCircleInner.Radius=FOVCircleSize-3
                FOVCircleInner.Color=FOVCircleColor; FOVCircleInner.Position=FOVCircle.Position
            end
        else
            FOVCircle.Visible=false
            if FOVCircleInner then FOVCircleInner.Visible=false end
        end
    end)
end)

-- AIMLOCK
if Drawing then
    AimlockFOV = Drawing.new("Circle")
    AimlockFOV.Visible=false; AimlockFOV.Thickness=2; AimlockFOV.NumSides=80
    AimlockFOV.Radius=Aimlock.RadiusLock; AimlockFOV.Filled=false
    AimlockFOV.Color=Color3.fromRGB(255,60,60); AimlockFOV.Transparency=0.6
end
local function getAimlockTarget()
    local root = getRoot(); if not root then return nil end
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local closest, shortest = nil, Aimlock.RadiusLock
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local team = plr.Team and plr.Team.Name or "?"
            local valid = false
            if Aimlock.Mode=="Killer" and team=="Killer" then valid=true
            elseif Aimlock.Mode=="Survivor" and (team=="Survivors" or team=="Survivor") then valid=true
            elseif Aimlock.Mode=="Auto" then valid=true end
            if valid then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local aimPart = plr.Character:FindFirstChild(Aimlock.AimPart) or hrp
                if hrp and hum and hum.Health>0 and aimPart then
                    local pos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X,pos.Y)-center).Magnitude
                        if dist<shortest then shortest=dist; closest=aimPart end
                    end
                end
            end
        end
    end
    return closest
end
RunService.RenderStepped:Connect(function()
    pcall(function()
        if AimlockFOV then
            AimlockFOV.Visible = Aimlock.ShowFOV and Aimlock.Enabled
            AimlockFOV.Radius = Aimlock.RadiusLock
            AimlockFOV.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        end
        if not Aimlock.Enabled then return end
        if not Aimlock.Holding and not Aimlock.AutoSnap and not Aimlock.Locked then return end
        local target = getAimlockTarget(); if not target then return end
        Aimlock.Target = target
        local pos = target.Position
        if Aimlock.Prediction then pos = pos + (target.AssemblyLinearVelocity * Aimlock.PredictStrength) end
        local cf = CFrame.new(Camera.CFrame.Position, pos)
        if Aimlock.AutoSnap or Aimlock.Locked then Camera.CFrame = cf
        else Camera.CFrame = Camera.CFrame:Lerp(cf, Aimlock.Smoothness) end
    end)
end)

-- SILENT AIM VEIL SPEAR
local function getSilentAimTarget()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local closest, shortest = nil, SilentAimSpear.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team then
            local valid = false
            if SilentAimSpear.TargetMode=="Killer" and p.Team.Name=="Killer" then valid=true
            elseif SilentAimSpear.TargetMode=="Survivor" and (p.Team.Name=="Survivors" or p.Team.Name=="Survivor") then valid=true
            elseif SilentAimSpear.TargetMode=="Both" then valid=true end
            if valid then
                local hrp = p.Character:FindFirstChild(SilentAimSpear.AimPart) or p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health>0 then
                    local pos, visible = Camera:WorldToViewportPoint(hrp.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X,pos.Y)-center).Magnitude
                        if dist<shortest then shortest=dist; closest=hrp end
                    end
                end
            end
        end
    end
    return closest
end
if Drawing then
    SilentAimCircle = Drawing.new("Circle")
    SilentAimCircle.Visible=false; SilentAimCircle.Thickness=2; SilentAimCircle.NumSides=60
    SilentAimCircle.Radius=SilentAimSpear.FOV; SilentAimCircle.Filled=false
    SilentAimCircle.Color=Color3.fromRGB(150,0,255); SilentAimCircle.Transparency=0.6
end
RunService.RenderStepped:Connect(function()
    pcall(function()
        if SilentAimCircle then
            SilentAimCircle.Visible = SilentAimSpear.Enabled and SilentAimSpear.ShowFOV
            SilentAimCircle.Radius = SilentAimSpear.FOV
            SilentAimCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        end
        if not SilentAimSpear.Enabled or not SilentAimSpear.Holding then return end
        local target = getSilentAimTarget(); if not target then return end
        local pos = target.Position
        if SilentAimSpear.Prediction > 0 then pos = pos + (target.AssemblyLinearVelocity * SilentAimSpear.Prediction) end
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, pos)
    end)
end)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if not SilentAimSpear.Enabled then return end
            local char = LocalPlayer.Character; if not char then return end
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and string.find(string.lower(tool.Name),"veil") then SilentAimSpear.Holding = true
            else SilentAimSpear.Holding = false end
        end)
    end
end)

-- HIT MARKER
local function createHitMarkerLines()
    if not Drawing then return end
    for _, v in pairs(HitMarkerLines) do pcall(function() v:Remove() end) end
    HitMarkerLines = {}
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Visible=false; line.Thickness=HitMarker.Thickness; line.Color=HitMarker.Color
        table.insert(HitMarkerLines, line)
    end
end
local function triggerHitMarker()
    HitMarkerActive = true; HitMarkerEnd = tick() + HitMarker.Duration
    if #HitMarkerLines == 0 then createHitMarkerLines() end
end
RunService.RenderStepped:Connect(function()
    pcall(function()
        if not Drawing then return end
        if not HitMarker.Enabled or not HitMarkerActive or tick()>HitMarkerEnd then
            HitMarkerActive = false
            for _, v in pairs(HitMarkerLines) do v.Visible=false end
            return
        end
        if #HitMarkerLines == 0 then createHitMarkerLines() end
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        local s = HitMarker.Size
        for _, v in pairs(HitMarkerLines) do
            v.Thickness=HitMarker.Thickness; v.Color=HitMarker.Color; v.Visible=true
        end
        HitMarkerLines[1].From=center+Vector2.new(-s,-s); HitMarkerLines[1].To=center+Vector2.new(-s/2,-s/2)
        HitMarkerLines[2].From=center+Vector2.new(s,-s); HitMarkerLines[2].To=center+Vector2.new(s/2,-s/2)
        HitMarkerLines[3].From=center+Vector2.new(-s,s); HitMarkerLines[3].To=center+Vector2.new(-s/2,s/2)
        HitMarkerLines[4].From=center+Vector2.new(s,s); HitMarkerLines[4].To=center+Vector2.new(s/2,s/2)
    end)
end)

-- AIMBOT + KILLER AIM
local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist
local function isVisible(part)
    RayParams.FilterDescendantsInstances = { LocalPlayer.Character }
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)
    local result = workspace:Raycast(origin, direction, RayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end
local function getClosestGunTarget()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local closest, shortest = nil, GunAim.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team then
            local valid = false
            if GunAim.TargetMode=="Killer" and p.Team.Name=="Killer" then valid=true
            elseif GunAim.TargetMode=="Survivor" and (p.Team.Name=="Survivors" or p.Team.Name=="Survivor") then valid=true
            elseif GunAim.TargetMode=="Both" then valid=true end
            if valid then
                local hrp = p.Character:FindFirstChild(GunAim.AimPart) or p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health>0 then
                    local pos, visible = Camera:WorldToViewportPoint(hrp.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X,pos.Y)-center).Magnitude
                        if dist<shortest then
                            if GunAim.VisibilityCheck and not isVisible(hrp) then
                            else shortest=dist; closest=hrp end
                        end
                    end
                end
            end
        end
    end
    return closest
end
RunService.RenderStepped:Connect(function()
    pcall(function()
        if not GunAim.Enabled or not GunAim.Holding then
            if TracerLine then TracerLine.Visible=false end
            return
        end
        local target = getClosestGunTarget()
        if not target then
            if TracerLine then TracerLine.Visible=false end
            return
        end
        local pos = target.Position
        if GunAim.Predict then pos = pos + (target.AssemblyLinearVelocity * GunAim.PredictStrength) end
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, pos), GunAim.Strength)
        if GunAim.ShowTracer and TracerLine then
            local sp, on = Camera:WorldToViewportPoint(target.Position)
            if on then
                TracerLine.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                TracerLine.To = Vector2.new(sp.X, sp.Y)
                TracerLine.Color = GunAim.TracerColor; TracerLine.Visible = true
            end
        end
    end)
end)
local function getClosestSurvivorForKiller()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local closest, shortest = nil, KillerAim.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local isSurv = p.Team and (p.Team.Name=="Survivors" or p.Team.Name=="Survivor")
            if isSurv then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health>0 then
                    local pos, visible = Camera:WorldToViewportPoint(hrp.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X,pos.Y)-center).Magnitude
                        if dist<shortest then shortest=dist; closest=hrp end
                    end
                end
            end
        end
    end
    return closest
end
RunService.RenderStepped:Connect(function()
    pcall(function()
        if not KillerAim.Enabled then return end
        local mouseHeld = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        if not (KillerAim.Holding or mouseHeld) then return end
        local target = getClosestSurvivorForKiller(); if not target then return end
        local pos = target.Position
        if GunAim.Predict then pos = pos + (target.AssemblyLinearVelocity * GunAim.PredictStrength) end
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, pos), KillerAim.Strength)
    end)
end)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType==Enum.UserInputType.MouseButton2 then GunAim.Holding=true; KillerAim.Holding=true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton2 then GunAim.Holding=false; KillerAim.Holding=false end
end)
print("[TiarHub v19] Part 2/5 loaded.")-- KILLER HELPERS
local function GetDownedSurvivor()
    local root = getRoot(); if not root then return nil end
    local best, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health>0 and hum.Health<=hum.MaxHealth*0.25 then
                local d = (hrp.Position-root.Position).Magnitude
                if d<dist then dist=d; best=p.Character end
            end
        end
    end
    return best
end
local function GetNearestAliveSurvivor()
    local root = getRoot(); if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health>30 then
                local d = (hrp.Position-root.Position).Magnitude
                if d<shortest then shortest=d; closest=p.Character end
            end
        end
    end
    return closest
end
local function GetHook()
    local root = getRoot(); if not root then return nil end
    local best, shortest = nil, math.huge
    for hook in pairs(CachedObjects.Hooks) do
        local pos = GetPos(hook)
        if pos then
            local d = (pos-root.Position).Magnitude
            if d<shortest and d<400 then shortest=d; best=hook end
        end
    end
    return best
end
local function startAutoStalk()
    if StalkConnection then return end
    StalkConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not Killer.AutoStalk then return end
            local root = getRoot(); if not root then return end
            local target, dist = nil, math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health>30 then
                        local d = (hrp.Position-root.Position).Magnitude
                        if d<=Killer.StalkRange and d<dist then dist=d; target=p end
                    end
                end
            end
            if target then
                local stalkEvent = findRemote("Remotes.Killers.Stalker.StartStalking")
                if stalkEvent then pcall(function() stalkEvent:FireServer(target) end) end
            end
        end)
    end)
end
local function stopAutoStalk()
    if StalkConnection then StalkConnection:Disconnect(); StalkConnection=nil end
end

-- KILLER MAIN LOOP
RunService.Heartbeat:Connect(function()
    pcall(function()
        if not getRoot() then return end
        if Killer.AutoAttack and AttackEvent then
            pcall(function() AttackEvent:FireServer(false) end)
            if HitMarker.Enabled and math.random(1,3)==1 then triggerHitMarker() end
        end
        if Killer.AutoHookAllDowned and HookEvent and not KillerBusy then
            local root = getRoot()
            if root then
                local bH, bD = nil, Killer.AutoHookAllRange
                for hook in pairs(CachedObjects.Hooks) do
                    local pos = GetPos(hook)
                    if pos then
                        local d = (pos-root.Position).Magnitude
                        if d<bD then bD=d; bH=hook end
                    end
                end
                if bH then
                    local hp = GetPos(bH)
                    if hp then
                        root.CFrame = CFrame.new(hp)*CFrame.new(0,4,-3)
                        task.wait(0.3)
                        for i=1,3 do HookEvent:FireServer(bH); task.wait(0.1) end
                    end
                end
            end
        end
        if Killer.AutoCarry and not KillerBusy and CarryEvent then
            KillerBusy = true
            task.spawn(function()
                local target = GetDownedSurvivor()
                local root = getRoot()
                if target and root then
                    local tRoot = target:FindFirstChild("HumanoidRootPart")
                    if tRoot then
                        root.CFrame = tRoot.CFrame*CFrame.new(0,3,-2)
                        task.wait(0.4)
                        for i=1,4 do CarryEvent:FireServer(target); task.wait(0.2) end
                        task.wait(0.6)
                        if Killer.AutoHook and HookEvent then
                            local hook = GetHook()
                            if hook then
                                local hp = GetPos(hook)
                                if hp then
                                    root.CFrame = CFrame.new(hp)*CFrame.new(0,4,-3)
                                    task.wait(0.7)
                                    for i=1,6 do HookEvent:FireServer(hook); task.wait(0.15) end
                                end
                            end
                        end
                    end
                end
                task.wait(1.5); KillerBusy = false
            end)
        end
        if Killer.KillAll and AttackEvent then
            local root = getRoot()
            if root then
                if not KillerTarget or not KillerTarget:FindFirstChild("Humanoid") or KillerTarget.Humanoid.Health<=35 then
                    KillerTarget = GetNearestAliveSurvivor()
                end
                if KillerTarget then
                    local targetHRP = KillerTarget:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        local v = targetHRP.AssemblyLinearVelocity
                        local p = v*0.15
                        local tp = targetHRP.Position + p
                        local behind = targetHRP.CFrame.LookVector*-3
                        root.CFrame = CFrame.new(tp+behind, tp)
                    end
                    pcall(function() AttackEvent:FireServer(false) end)
                end
            end
        end
        if Killer.AutoSprint then
            local hum = getHum()
            if hum and hum.WalkSpeed<Killer.AutoSprintValue then
                local target = GetNearestAliveSurvivor()
                if target then
                    local hrp = target:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local myRoot = getRoot()
                        if myRoot then
                            local d = (hrp.Position-myRoot.Position).Magnitude
                            if d<100 then hum.WalkSpeed = Killer.AutoSprintValue end
                        end
                    end
                end
            end
        end
        if Killer.AutoFaceTarget then
            local root = getRoot()
            if root then
                local target = GetNearestAliveSurvivor()
                if target then
                    local hrp = target:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local d = (hrp.Position-root.Position).Magnitude
                        if d<=Killer.AutoFaceRange then
                            local myHum = getHum()
                            if myHum then
                                myHum.AutoRotate = false
                                local look = CFrame.new(root.Position, hrp.Position).LookVector
                                root.CFrame = CFrame.new(root.Position, root.Position+Vector3.new(look.X,0,look.Z))
                            end
                        end
                    end
                end
            end
        end
        if Killer.PredictionAttack and AttackEvent then
            local root = getRoot()
            if root then
                local target = GetNearestAliveSurvivor()
                if target then
                    local hrp = target:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local d = (hrp.Position-root.Position).Magnitude
                        if d<15 then
                            local vel = hrp.AssemblyLinearVelocity
                            local predPos = hrp.Position + (vel*Killer.PredictStrength)
                            local myHum = getHum()
                            if myHum then myHum.AutoRotate = false end
                            root.CFrame = CFrame.new(root.Position, predPos)
                            pcall(function() AttackEvent:FireServer(false) end)
                            if HitMarker.Enabled then triggerHitMarker() end
                        end
                    end
                end
            end
        end
        if ChaseDetector.Enabled then
            local now = tick()
            if now - ChaseDetector.LastNotify > ChaseDetector.Cooldown then
                local root = getRoot()
                if root then
                    local closest, dist = nil, math.huge
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            local isSurv = p.Team and (p.Team.Name=="Survivors" or p.Team.Name=="Survivor")
                            if isSurv then
                                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    local d = (hrp.Position-root.Position).Magnitude
                                    if d<dist then dist=d; closest=p end
                                end
                            end
                        end
                    end
                    if closest and dist<=ChaseDetector.Range then
                        ChaseDetector.LastNotify = now
                        Rayfield:Notify({ title="Chase Alert", content=string.format("Survivor dalam %.0f stud!",dist), duration=2 })
                    end
                end
            end
        end
    end)
end)

-- FAST VAULT
local function normalizeId(id)
    local num = tostring(id):match("%d+")
    return num and ("rbxassetid://"..num)
end
local function hookVault(char)
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator"); if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        pcall(function()
            if not FastVault.Enabled then return end
            local anim = track.Animation
            if not anim or not anim.AnimationId then return end
            local id = normalizeId(anim.AnimationId); if not id then return end
            local replaceId = FastVault.ReplaceMap[id]; if not replaceId then return end
            if VaultTracks[track] then return end
            VaultTracks[track] = true
            track:Stop()
            local newAnim = Instance.new("Animation")
            newAnim.AnimationId = replaceId
            local newTrack = animator:LoadAnimation(newAnim)
            newTrack.Priority = Enum.AnimationPriority.Action
            newTrack:Play(); newTrack:AdjustSpeed(FastVault.Speed)
            newTrack.Stopped:Connect(function() VaultTracks[track]=nil end)
        end)
    end)
end
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5); pcall(function() hookVault(char) end)
end)
if LocalPlayer.Character then pcall(function() hookVault(LocalPlayer.Character) end) end

-- WALKSPEED + NOCLIP
local WalkSpeedConnection = nil
local function applyWalkSpeed()
    if WalkSpeedConnection then WalkSpeedConnection:Disconnect() end
    WalkSpeedConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not Movement.WalkSpeedEnabled then return end
            local hum = getHum(); if not hum then return end
            if shouldDisableWalkSpeed() then return end
            if hum.WalkSpeed ~= Movement.WalkSpeedValue then hum.WalkSpeed = Movement.WalkSpeedValue end
        end)
    end)
end
local NoClipConnection = nil
local function toggleNoClip(state)
    Movement.NoClip = state
    if state then
        if NoClipConnection then NoClipConnection:Disconnect() end
        NoClipConnection = RunService.RenderStepped:Connect(function()
            pcall(function()
                if not Movement.NoClip then return end
                local char = LocalPlayer.Character; if not char then return end
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end)
        end)
    else
        if NoClipConnection then NoClipConnection:Disconnect(); NoClipConnection=nil end
        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end
end

-- MOONWALK
local function applyMoonwalkFOV()
    if not Camera then return end
    if Moonwalk.Enabled then Camera.FieldOfView = Moonwalk.FOVPreset end
end
local function startMoonwalk()
    if MoonwalkConnection then return end
    local hum0 = getHum(); if hum0 then hum0.AutoRotate = false end
    MoonwalkConnection = RunService.RenderStepped:Connect(function()
        if not Moonwalk.Enabled or ParryActive or isDowned() then return end
        local char = LocalPlayer.Character
        if not char or not char.Parent then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not (humanoid and hrp and Camera) then return end
        humanoid.AutoRotate = false
        if Moonwalk.UseSlow and humanoid.WalkSpeed ~= Moonwalk.SlowSpeed then humanoid.WalkSpeed = Moonwalk.SlowSpeed end
        local look = Moonwalk.Mode=="Camera" and Camera.CFrame.LookVector or Camera.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit
            local baseCF = CFrame.new(hrp.Position, hrp.Position+flatLook)
            local angle = math.sin(tick()*Moonwalk.SpamSpeed)*Moonwalk.Intensity
            hrp.CFrame = baseCF*CFrame.Angles(0, math.rad(angle), 0)
            humanoid:Move(Vector3.new(0,0,1), true)
        end
    end)
    if MoonwalkHeartbeat then MoonwalkHeartbeat:Disconnect() end
    MoonwalkHeartbeat = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not Moonwalk.Enabled then return end
            local char = LocalPlayer.Character; if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.AutoRotate = false end
        end)
    end)
end
local function stopMoonwalk()
    if MoonwalkConnection then MoonwalkConnection:Disconnect(); MoonwalkConnection=nil end
    if MoonwalkHeartbeat then MoonwalkHeartbeat:Disconnect(); MoonwalkHeartbeat=nil end
    local hum = getHum()
    if hum then
        hum.AutoRotate = true
        if Movement.WalkSpeedEnabled then hum.WalkSpeed = Movement.WalkSpeedValue
        else hum.WalkSpeed = Movement.OriginalWalkSpeed end
    end
    if Camera then Camera.FieldOfView = 70 end
end

-- CROSSHAIR
local function updateCrosshair()
    pcall(function()
        if not Crosshair.Enabled then
            if CrosshairGui then CrosshairGui.Enabled = false end
            return
        end
        if not CrosshairGui then
            CrosshairGui = Instance.new("ScreenGui")
            CrosshairGui.Name="TiarCrosshair"; CrosshairGui.ResetOnSpawn=false
            CrosshairGui.IgnoreGuiInset=true; CrosshairGui.Parent=PlayerGui
            local h = Instance.new("Frame"); h.Name="H"
            h.AnchorPoint=Vector2.new(0.5,0.5); h.BorderSizePixel=0; h.Parent=CrosshairGui
            local v = Instance.new("Frame"); v.Name="V"
            v.AnchorPoint=Vector2.new(0.5,0.5); v.BorderSizePixel=0; v.Parent=CrosshairGui
        end
        CrosshairGui.Enabled = true
        local h = CrosshairGui:FindFirstChild("H")
        local v = CrosshairGui:FindFirstChild("V")
        if h then
            h.Size = UDim2.new(0, Crosshair.Size*2, 0, Crosshair.Thickness)
            h.Position = UDim2.new(0.5, Crosshair.OffsetX, 0.5, Crosshair.OffsetY)
            h.BackgroundColor3 = Crosshair.Color
        end
        if v then
            v.Size = UDim2.new(0, Crosshair.Thickness, 0, Crosshair.Size*2)
            v.Position = UDim2.new(0.5, Crosshair.OffsetX, 0.5, Crosshair.OffsetY)
            v.BackgroundColor3 = Crosshair.Color
        end
    end)
end
RunService.RenderStepped:Connect(function() updateCrosshair() end)
RunService.Heartbeat:Connect(function() pcall(function() AutoWiggle() end) end)

-- EMOTE + MASKED
local function playEmote(name)
    if EmoteRemote then pcall(function() EmoteRemote:FireServer(name) end) end
end
local function activateMasked()
    local event = findRemote("Remotes.Killers.Masked.Activatepower")
    if event then pcall(function() event:FireServer(Masked.CurrentPower) end) end
end
local function deactivateMasked()
    local event = findRemote("Remotes.Killers.Masked.Deactivatepower")
    if event then pcall(function() event:FireServer() end) end
end

-- VISUAL
local LastVS = { Fullbright=nil, NoFog=nil, NoShadow=nil }
local function applyVisual(force)
    pcall(function()
        if force or LastVS.Fullbright ~= Visual.Fullbright then
            LastVS.Fullbright = Visual.Fullbright
            if Visual.Fullbright then
                Lighting.Brightness=2; Lighting.ClockTime=14
                Lighting.Ambient=Color3.new(1,1,1); Lighting.OutdoorAmbient=Color3.new(1,1,1)
            else
                Lighting.Brightness=VisualOriginal.Brightness; Lighting.ClockTime=VisualOriginal.ClockTime
                Lighting.Ambient=VisualOriginal.Ambient; Lighting.OutdoorAmbient=VisualOriginal.OutdoorAmbient
            end
        end
        if force or LastVS.NoFog ~= Visual.NoFog then
            LastVS.NoFog = Visual.NoFog
            if Visual.NoFog then Lighting.FogEnd=100000; Lighting.FogStart=100000
            else Lighting.FogEnd=VisualOriginal.FogEnd; Lighting.FogStart=VisualOriginal.FogStart; Lighting.FogColor=VisualOriginal.FogColor end
        end
        if force or LastVS.NoShadow ~= Visual.NoShadow then
            LastVS.NoShadow = Visual.NoShadow
            Lighting.GlobalShadows = not Visual.NoShadow
        end
        if Visual.AmbientColorEnabled then
            Lighting.Ambient = Visual.AmbientColor; Lighting.OutdoorAmbient = Visual.AmbientColor
        end
        if Visual.ClockTimeEnabled then Lighting.ClockTime = Visual.ClockTime end
        if Visual.FogControlEnabled then
            Lighting.FogEnd = Visual.FogEnd; Lighting.FogStart = Visual.FogStart; Lighting.FogColor = Visual.FogColor
        end
    end)
end
local function toggleScreenEffects()
    pcall(function()
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") then v.Enabled = not Visual.NoBloom end
            if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") then v.Enabled = not Visual.NoBlur end
        end
    end)
end
local ColorCorrection = nil
local function getOrCreateCC()
    if ColorCorrection and ColorCorrection.Parent then return ColorCorrection end
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("ColorCorrectionEffect") and v.Name=="TiarColorCorrection" then ColorCorrection = v; return v end
    end
    ColorCorrection = Instance.new("ColorCorrectionEffect")
    ColorCorrection.Name="TiarColorCorrection"; ColorCorrection.Parent=Lighting
    ColorCorrection.Enabled = true; return ColorCorrection
end
local function applyColorCorrection()
    local cc = getOrCreateCC(); if not cc then return end
    cc.Saturation = Visual.Saturation or 0; cc.Brightness = Visual.Brightness or 0; cc.Contrast = Visual.Contrast or 0
    local en = Visual.ColorCorrection or (Visual.Saturation and Visual.Saturation~=0) or (Visual.Brightness and Visual.Brightness~=0) or (Visual.Contrast and Visual.Contrast~=0)
    cc.Enabled = en and true or false
end
local function resetColorCorrection()
    Visual.Saturation=0; Visual.Brightness=0; Visual.Contrast=0
    local cc = getOrCreateCC()
    if cc then cc.Saturation=0; cc.Brightness=0; cc.Contrast=0 end
end
local function removeBlood()
    pcall(function()
        if Visual.NoBlood then
            for _, v in pairs(workspace:GetDescendants()) do
                local n = string.lower(v.Name)
                if (v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Trail")) and (n:find("blood") or n:find("gore") or n:find("splat")) then
                    pcall(function()
                        if v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1 else v.Enabled=false end
                    end)
                end
            end
        end
    end)
end
RunService.Heartbeat:Connect(function()
    pcall(function()
        applyVisual(); toggleScreenEffects(); applyColorCorrection(); removeBlood()
        if Moonwalk.Enabled then applyMoonwalkFOV() end
    end)
end)

-- TELEPORT
local function findNearestByNames(names, maxDist)
    local root = getRoot(); if not root then return nil, math.huge end
    local best, bestDist = nil, maxDist or math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            for _, target in ipairs(names) do
                if obj.Name==target or string.find(obj.Name, target, 1, true) then
                    local pos = GetPos(obj)
                    if pos then
                        local d = (pos-root.Position).Magnitude
                        if d<bestDist then bestDist=d; best=obj end
                    end
                    break
                end
            end
        end
    end
    return best, bestDist
end
local function teleportTo(obj)
    if not obj then return false end
    local now = tick()
    if now - Teleport.LastTeleport < Teleport.Cooldown then return false end
    Teleport.LastTeleport = now
    local root = getRoot(); if not root then return false end
    local pos = GetPos(obj); if not pos then return false end
    pcall(function() root.CFrame = CFrame.new(pos+Vector3.new(0,5,0)) end)
    return true
end
local function teleportToGenerator() return teleportTo(findNearestByNames({"Generator","GeneratorPoint"})) end
local function teleportToGate() return teleportTo(findNearestByNames({"Gate","Exit","ExitGate","fininshline","FinishLine"})) end
local function teleportToWindow() return teleportTo(findNearestByNames({"Window"})) end
local function teleportToPallet() return teleportTo(findNearestByNames({"Pallet","Palletwrong"})) end
local function teleportToHook() return teleportTo(findNearestByNames({"HookPoint","Hook"})) end
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if not AutoEscape.Enabled then return end
            local root = getRoot(); if not root then return end
            local killerRoot, dist = GetNearestKiller()
            if not killerRoot or dist > AutoEscape.DetectDistance then return end
            if tick() - AutoEscape.LastEscape < AutoEscape.Cooldown then return end
            local target = findNearestByNames({"Gate","Exit","ExitGate","fininshline","FinishLine"}, 1000)
            if not target then target = findNearestByNames({"Window"}, 500) end
            if not target then target = findNearestByNames({"Pallet","Palletwrong"}, 500) end
            if not target then target = findNearestByNames({"Generator"}, 500) end
            if target then AutoEscape.LastEscape = tick(); teleportTo(target) end
        end)
    end
end)

-- COPY AVATAR FULL (Fallens)
local function saveOrig()
    local c = LocalPlayer.Character; if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then AvatarCopier.OriginalDescription = h:GetAppliedDescription() end
end
local function rmClothes(c)
    for _, v in pairs(c:GetDescendants()) do
        if v:IsA("Accessory") or v:IsA("Clothing") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then v:Destroy() end
    end
end
local function loadA(id)
    if not id or id==0 or id=="0" then return nil end
    local ok, a = pcall(function() return InsertService:LoadAsset(tonumber(id)) end)
    if ok and a then return a end
end
local function copyAvatarFull(u)
    if not u or u=="" then Rayfield:Notify({title="Copy Avatar",content="Username kosong!"}); return end
    saveOrig()
    local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(u) end)
    if not ok or not uid then Rayfield:Notify({title="Copy Avatar",content="User '"..u.."' gak ketemu!"}); return end
    AvatarCopier.CurrentCopiedUserId = uid
    local c = LocalPlayer.Character; if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid"); if not h then return end
    task.spawn(function()
        local okD, d = pcall(function() return Players:GetHumanoidDescriptionFromUserId(uid) end)
        if not okD or not d then Rayfield:Notify({title="Copy Avatar",content="Gagal!"}); return end
        for _, v in pairs(c:GetDescendants()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then pcall(function() v:Destroy() end) end
        end
        task.wait(0.2)
        if AvatarCopier.BlockyBody then
            pcall(function()
                local b = Instance.new("HumanoidDescription")
                b.BodyTypeScale=1; b.DepthScale=1; b.HeadScale=1; b.HeightScale=1; b.ProportionScale=0; b.WidthScale=1
                b.HeadColor=d.HeadColor; b.TorsoColor=d.TorsoColor
                b.LeftArmColor=d.LeftArmColor; b.RightArmColor=d.RightArmColor
                b.LeftLegColor=d.LeftLegColor; b.RightLegColor=d.RightLegColor
                h:ApplyDescriptionClientServer(b)
            end)
            task.wait(0.5)
        end
        pcall(function() h:ApplyDescriptionClientServer(d) end)
        task.wait(0.5)
        if d.Shirt and tonumber(d.Shirt) and tonumber(d.Shirt)>0 then
            local a = loadA(d.Shirt)
            if a then for _, v in pairs(a:GetChildren()) do if v:IsA("Shirt") then v:Clone().Parent=c; break end end; a:Destroy()
            else pcall(function() local s=Instance.new("Shirt"); s.ShirtTemplate="rbxassetid://"..tostring(d.Shirt); s.Parent=c end) end
        end
        task.wait(0.3)
        if d.Pants and tonumber(d.Pants) and tonumber(d.Pants)>0 then
            local a = loadA(d.Pants)
            if a then for _, v in pairs(a:GetChildren()) do if v:IsA("Pants") then v:Clone().Parent=c; break end end; a:Destroy()
            else pcall(function() local p=Instance.new("Pants"); p.PantsTemplate="rbxassetid://"..tostring(d.Pants); p.Parent=c end) end
        end
        task.wait(0.3)
        if d.GraphicTShirt and tonumber(d.GraphicTShirt) and tonumber(d.GraphicTShirt)>0 then
            pcall(function() local st=Instance.new("ShirtGraphic"); st.Graphic="rbxassetid://"..tostring(d.GraphicTShirt); st.Parent=c end)
        end
        task.wait(0.3)
        if d.AccessoryBlob and d.AccessoryBlob~="" then
            for id in string.gmatch(d.AccessoryBlob,"[^;]+") do
                local n = tonumber(id)
                if n and n>0 then
                    local o, a = pcall(function() return InsertService:LoadAsset(n) end)
                    if o and a then
                        for _, v in pairs(a:GetChildren()) do
                            if v:IsA("Accessory") or v:IsA("Hat") then pcall(function() v:Clone().Parent=c end) end
                        end
                        a:Destroy()
                    end
                    task.wait(0.1)
                end
            end
        end
        task.wait(0.3)
        if d.Face and tonumber(d.Face) and tonumber(d.Face)>0 then
            local hd = c:FindFirstChild("Head")
            if hd then
                local of = hd:FindFirstChildOfClass("Decal"); if of then of:Destroy() end
                pcall(function() local f=Instance.new("Decal"); f.Name="face"; f.Face=Enum.NormalId.Front; f.Texture="rbxassetid://"..tostring(d.Face); f.Parent=hd end)
            end
        end
        task.wait(0.3)
        Rayfield:Notify({title="Copy Avatar",content="✓ "..u.." (Full)"})
    end)
end
local function resetAvatar()
    if not AvatarCopier.OriginalDescription then Rayfield:Notify({title="Reset",content="Belum ada original!"}); return end
    local c = LocalPlayer.Character; if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid"); if not h then return end
    rmClothes(c); task.wait(0.1)
    pcall(function() h:ApplyDescriptionClientServer(AvatarCopier.OriginalDescription) end)
    AvatarCopier.CurrentCopiedUserId = nil
    Rayfield:Notify({title="Reset",content="✓ Original balik!"})
end
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    if AvatarCopier.CurrentCopiedUserId then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then
            local okD, d = pcall(function() return Players:GetHumanoidDescriptionFromUserId(AvatarCopier.CurrentCopiedUserId) end)
            if okD and d then pcall(function() h:ApplyDescriptionClientServer(d) end) end
        end
    end
end)
print("[TiarHub v19] Part 3/5 loaded.")local ESPTab = Window:CreateTab({ name="ESP", icon=0 })
ESPTab:CreateSection("Player ESP")
ESPTab:CreateToggle({ name="ESP Survivor", currentValue=false, flag="esp_survivor", callback=function(v) ESP.Survivor=v end })
ESPTab:CreateColorPicker({ name="Survivor Color", color=ESP.SurvivorColor, flag="esp_survivor_color", callback=function(c) ESP.SurvivorColor=c end })
ESPTab:CreateToggle({ name="ESP Killer", currentValue=false, flag="esp_killer", callback=function(v) ESP.Killer=v end })
ESPTab:CreateColorPicker({ name="Killer Color", color=ESP.KillerColor, flag="esp_killer_color", callback=function(c) ESP.KillerColor=c end })
ESPTab:CreateSection("Map ESP")
ESPTab:CreateToggle({ name="ESP Generator (%)", currentValue=false, flag="esp_gen", callback=function(v) ESP.Generator=v end })
ESPTab:CreateColorPicker({ name="Generator Color", color=ESP.GeneratorColor, flag="esp_gen_c", callback=function(c) ESP.GeneratorColor=c end })
ESPTab:CreateToggle({ name="ESP Hook", currentValue=false, flag="esp_hook", callback=function(v) ESP.Hook=v end })
ESPTab:CreateColorPicker({ name="Hook Color", color=ESP.HookColor, flag="esp_hook_c", callback=function(c) ESP.HookColor=c end })
ESPTab:CreateToggle({ name="ESP Pallet", currentValue=false, flag="esp_pallet", callback=function(v) ESP.Pallet=v end })
ESPTab:CreateColorPicker({ name="Pallet Color", color=ESP.PalletColor, flag="esp_pallet_c", callback=function(c) ESP.PalletColor=c end })
ESPTab:CreateToggle({ name="ESP Window", currentValue=false, flag="esp_window", callback=function(v) ESP.Window=v end })
ESPTab:CreateColorPicker({ name="Window Color", color=ESP.WindowColor, flag="esp_window_c", callback=function(c) ESP.WindowColor=c end })
ESPTab:CreateToggle({ name="ESP SCP", currentValue=false, flag="esp_scp", callback=function(v) ESP.SCP=v end })
ESPTab:CreateColorPicker({ name="SCP Color", color=ESP.SCPColor, flag="esp_scp_c", callback=function(c) ESP.SCPColor=c end })
ESPTab:CreateSection("Style")
ESPTab:CreateSlider({ name="ESP Radius", range={50,2000}, increment=50, suffix="stud", currentValue=300, flag="esp_radius", callback=function(v) ESP.Distance=v end })
ESPTab:CreateDropdown({ name="ESP Mode", options={"Highlight","Outline","Fill"}, currentOption="Highlight", flag="esp_mode", callback=function(opt) ESP.Mode=opt end })
ESPTab:CreateToggle({ name="Show Name Tag", currentValue=true, flag="esp_name", callback=function(v) ESP.ShowName=v end })
ESPTab:CreateSlider({ name="Name Size", range={8,30}, increment=1, suffix="px", currentValue=14, flag="esp_namesize", callback=function(v) ESP.NameSize=v end })
ESPTab:CreateSection("ESP Status")
ESPTab:CreateToggle({ name="Enable Status ESP", currentValue=false, flag="espstatus_on", callback=function(v) ESPStatus.Enabled=v end })
ESPTab:CreateToggle({ name="Show Name", currentValue=true, flag="espstatus_name", callback=function(v) ESPStatus.ShowName=v end })
ESPTab:CreateToggle({ name="Show Distance", currentValue=true, flag="espstatus_dist", callback=function(v) ESPStatus.ShowDistance=v end })
ESPTab:CreateToggle({ name="Show Health", currentValue=false, flag="espstatus_hp", callback=function(v) ESPStatus.ShowHealth=v end })
ESPTab:CreateSection("Killer Warning")
ESPTab:CreateToggle({ name="Killer Warning", currentValue=false, flag="kwarn_on", callback=function(v) KillerWarning.Enabled=v end })
ESPTab:CreateColorPicker({ name="Warning Color", color=KillerWarning.Color, flag="kwarn_c", callback=function(c) KillerWarning.Color=c end })
ESPTab:CreateSlider({ name="Warning Distance", range={20,200}, increment=5, suffix="stud", currentValue=60, flag="kwarn_d", callback=function(v) KillerWarning.Distance=v end })

local SurvivorTab = Window:CreateTab({ name="Survivor", icon=0 })
SurvivorTab:CreateSection("Auto Parry")
SurvivorTab:CreateToggle({ name="Auto Parry", currentValue=false, flag="parry_on", callback=function(v) Auto.Parry=v end })
SurvivorTab:CreateDropdown({ name="Parry Mode", options={"Safety","Aggressive"}, currentOption="Safety", flag="parry_mode", callback=function(opt) Auto.ParryMode=opt; applyParryPreset(opt); Rayfield:Notify({ title="Parry Mode", content="Mode: "..opt }) end })
SurvivorTab:CreateToggle({ name="Show Parry Range", currentValue=false, flag="parry_range", callback=function(v) ParryRangeVisual.Enabled=v end })
SurvivorTab:CreateToggle({ name="Parry Rainbow Mode", currentValue=false, flag="parry_rb", callback=function(v) ParryRangeVisual.RainbowMode=v end })
SurvivorTab:CreateToggle({ name="Parry Pulse Effect", currentValue=true, flag="parry_pulse", callback=function(v) ParryRangeVisual.PulseEnabled=v end })
SurvivorTab:CreateColorPicker({ name="Parry Range Color", color=ParryRangeVisual.Color, flag="parry_c", callback=function(c) ParryRangeVisual.Color=c end })
SurvivorTab:CreateSlider({ name="Parry Circle Size", range={5,50}, increment=1, suffix="stud", currentValue=12, flag="parry_size", callback=function(v) Auto.ParryDistance=v end })
SurvivorTab:CreateSlider({ name="Parry Transparency", range={0,1}, increment=0.05, currentValue=0.7, flag="parry_trans", callback=function(v) ParryRangeVisual.Transparency=v end })
SurvivorTab:CreateSection("Auto Skill Check")
SurvivorTab:CreateToggle({ name="Auto Skill Check", currentValue=false, flag="skillcheck", callback=function(v) Auto.SkillCheck=v; if v then startSkillCheck() end end })
SurvivorTab:CreateDropdown({ name="Skill Check Mode", options={"Instant","Perfect"}, currentOption="Perfect", flag="skill_mode", callback=function(opt) SkillCheckMode=opt; Rayfield:Notify({ title="Skill Check", content="Mode: "..opt }) end })
SurvivorTab:CreateSection("Auto Wiggle / Flee")
SurvivorTab:CreateToggle({ name="Auto Wiggle", currentValue=false, flag="wiggle", callback=function(v) Auto.Wiggle=v end })
SurvivorTab:CreateSlider({ name="Wiggle Spam", range={1,10}, increment=1, suffix="x", currentValue=5, flag="wiggle_spam", callback=function(v) Auto.WiggleSpam=v end })
SurvivorTab:CreateToggle({ name="Auto Flee Killer", currentValue=false, flag="flee", callback=function(v) AutoFlee.Enabled=v end })
SurvivorTab:CreateSlider({ name="Flee Distance", range={10,200}, increment=5, suffix="stud", currentValue=50, flag="flee_d", callback=function(v) AutoFlee.DetectDistance=v end })
SurvivorTab:CreateSection("Fast Vault")
SurvivorTab:CreateToggle({ name="Fast Vault", currentValue=false, flag="vault", callback=function(v) FastVault.Enabled=v end })
SurvivorTab:CreateSlider({ name="Animation Speed", range={1,5}, increment=0.1, suffix="x", currentValue=1.2, flag="vault_sp", callback=function(v) FastVault.Speed=v end })
SurvivorTab:CreateSection("Auto Dodge Abyss")
SurvivorTab:CreateToggle({ name="Auto Dodge Abyss", currentValue=false, flag="ad_abyss", callback=function(v) AutoDodgeAbyss.Enabled=v end })
SurvivorTab:CreateSlider({ name="Detect Range", range={5,50}, increment=1, suffix="stud", currentValue=18, flag="ad_r", callback=function(v) AutoDodgeAbyss.DetectRange=v end })
SurvivorTab:CreateSlider({ name="Cooldown", range={0.1,3}, increment=0.1, suffix="s", currentValue=0.5, flag="ad_cd", callback=function(v) AutoDodgeAbyss.Cooldown=v end })
SurvivorTab:CreateSlider({ name="Crouch Duration", range={0.1,2}, increment=0.1, suffix="s", currentValue=0.3, flag="ad_dur", callback=function(v) AutoDodgeAbyss.CrouchDuration=v end })
SurvivorTab:CreateSection("🎭 Fake Perks")
SurvivorTab:CreateToggle({ name="Fake Flowstate", currentValue=false, flag="fp_flow", callback=function(v) FakePerks.Flowstate.Enabled=v end })
SurvivorTab:CreateSlider({ name="Flowstate Boost (%)", range={10,50}, increment=5, suffix="%", currentValue=20, flag="fp_flow_sp", callback=function(v) FakePerks.Flowstate.SpeedBoost=v end })
SurvivorTab:CreateSlider({ name="Flowstate Duration", range={1,10}, increment=0.5, suffix="s", currentValue=3, flag="fp_flow_dur", callback=function(v) FakePerks.Flowstate.Duration=v end })
SurvivorTab:CreateSlider({ name="Flowstate Cooldown", range={1,70}, increment=1, suffix="s", currentValue=30, flag="fp_flow_cd", callback=function(v) FakePerks.Flowstate.Cooldown=v end })
SurvivorTab:CreateToggle({ name="Fake Snake Step", currentValue=false, flag="fp_snake", callback=function(v) FakePerks.SnakeStep.Enabled=v end })
SurvivorTab:CreateSlider({ name="Snake Step Speed", range={16,100}, increment=1, currentValue=90, flag="fp_snake_sp", callback=function(v) FakePerks.SnakeStep.SpeedBoost=v end })
SurvivorTab:CreateSlider({ name="Snake Step Cooldown", range={1,70}, increment=1, suffix="s", currentValue=30, flag="fp_snake_cd", callback=function(v) FakePerks.SnakeStep.Cooldown=v end })
SurvivorTab:CreateToggle({ name="Fake Quick Recovery", currentValue=false, flag="fp_recovery", callback=function(v) FakePerks.QuickRecovery.Enabled=v end })
SurvivorTab:CreateSlider({ name="Quick Recovery Cooldown", range={1,70}, increment=1, suffix="s", currentValue=30, flag="fp_qr_cd", callback=function(v) FakePerks.QuickRecovery.Cooldown=v end })

local AimlockTab = Window:CreateTab({ name="Aimlock", icon=0 })
AimlockTab:CreateSection("🎯 Target Lock")
AimlockTab:CreateDropdown({ name="Target Mode", options={"Killer","Survivor","Auto"}, currentOption="Killer", flag="aim_mode", callback=function(opt) Aimlock.Mode=opt end })
AimlockTab:CreateSlider({ name="Radius Lock", range={50,1000}, increment=10, suffix="stud", currentValue=250, flag="aim_radius", callback=function(v) Aimlock.RadiusLock=v end })
AimlockTab:CreateDropdown({ name="Aim Part", options={"Head","UpperTorso","HumanoidRootPart"}, currentOption="Head", flag="aim_part", callback=function(opt) Aimlock.AimPart=opt end })
AimlockTab:CreateSection("⚙️ Behavior")
AimlockTab:CreateToggle({ name="Enable Aimlock", currentValue=false, flag="aim_on", callback=function(v) Aimlock.Enabled=v; Aimlock.Holding=v end })
AimlockTab:CreateToggle({ name="Auto Snap", currentValue=false, flag="aim_snap", callback=function(v) Aimlock.AutoSnap=v end })
AimlockTab:CreateSlider({ name="Smoothness", range={0.05,1}, increment=0.05, currentValue=0.35, flag="aim_smooth", callback=function(v) Aimlock.Smoothness=v end })
AimlockTab:CreateToggle({ name="Prediction", currentValue=true, flag="aim_pred", callback=function(v) Aimlock.Prediction=v end })
AimlockTab:CreateSlider({ name="Prediction Strength", range={0,0.5}, increment=0.01, currentValue=0.12, flag="aim_predstr", callback=function(v) Aimlock.PredictStrength=v end })
AimlockTab:CreateToggle({ name="Show Radius Circle", currentValue=true, flag="aim_fov", callback=function(v) Aimlock.ShowFOV=v end })

local AimTab = Window:CreateTab({ name="Aimbot", icon=0 })
AimTab:CreateSection("Aimbot Survivor")
AimTab:CreateToggle({ name="Aimbot (Hold RMB)", currentValue=false, flag="gun_on", callback=function(v) GunAim.Enabled=v end })
AimTab:CreateToggle({ name="Show FOV Circle", currentValue=false, flag="gun_fovc", callback=function(v) FOVCircleVisible=v; if v and not FOVCircle then createFOVCircle() end end })
AimTab:CreateSlider({ name="FOV Circle Size", range={50,1000}, increment=10, suffix="px", currentValue=250, flag="gun_fovsz", callback=function(v) FOVCircleSize=v end })
AimTab:CreateColorPicker({ name="FOV Circle Color", color=FOVCircleColor, flag="gun_fovcl", callback=function(c) FOVCircleColor=c end })
AimTab:CreateDropdown({ name="Aimbot Target", options={"Killer","Survivor","Both"}, currentOption="Killer", flag="gun_tgt", callback=function(opt) GunAim.TargetMode=opt end })
AimTab:CreateDropdown({ name="Aim Part", options={"Head","HumanoidRootPart","Torso"}, currentOption="HumanoidRootPart", flag="gun_part", callback=function(opt) GunAim.AimPart=opt end })
AimTab:CreateSlider({ name="Aimbot FOV", range={50,1000}, increment=10, currentValue=250, flag="gun_fov", callback=function(v) GunAim.FOV=v end })
AimTab:CreateSlider({ name="Aimbot Smoothness", range={0.1,1}, increment=0.05, currentValue=1, flag="gun_sm", callback=function(v) GunAim.Strength=v end })
AimTab:CreateSlider({ name="Aimbot Prediction", range={0,1}, increment=0.01, currentValue=0.12, flag="gun_pr", callback=function(v) GunAim.PredictStrength=v end })
AimTab:CreateSection("🗡️ Silent Aim Veil Spear")
AimTab:CreateToggle({ name="Enable Silent Aim Spear", currentValue=false, flag="silent_on", callback=function(v) SilentAimSpear.Enabled=v end })
AimTab:CreateToggle({ name="Show Silent Aim FOV", currentValue=false, flag="silent_fov", callback=function(v) SilentAimSpear.ShowFOV=v end })
AimTab:CreateDropdown({ name="Silent Aim Target", options={"Killer","Survivor","Both"}, currentOption="Killer", flag="silent_tgt", callback=function(opt) SilentAimSpear.TargetMode=opt end })
AimTab:CreateDropdown({ name="Silent Aim Part", options={"Head","HumanoidRootPart","Torso"}, currentOption="HumanoidRootPart", flag="silent_part", callback=function(opt) SilentAimSpear.AimPart=opt end })
AimTab:CreateSlider({ name="Silent Aim FOV", range={50,1000}, increment=10, currentValue=250, flag="silent_fovv", callback=function(v) SilentAimSpear.FOV=v end })
AimTab:CreateSlider({ name="Silent Aim Prediction", range={0,1}, increment=0.01, currentValue=0.12, flag="silent_pr", callback=function(v) SilentAimSpear.Prediction=v end })
AimTab:CreateSection("Hit Marker")
AimTab:CreateToggle({ name="Enable Hit Marker", currentValue=false, flag="hm_on", callback=function(v) HitMarker.Enabled=v; if v and #HitMarkerLines==0 then createHitMarkerLines() end end })
AimTab:CreateColorPicker({ name="Hit Marker Color", color=HitMarker.Color, flag="hm_c", callback=function(c) HitMarker.Color=c end })
AimTab:CreateSlider({ name="Hit Marker Size", range={5,50}, increment=1, suffix="px", currentValue=20, flag="hm_s", callback=function(v) HitMarker.Size=v end })
AimTab:CreateSection("Killer Aim (Lock saat Hit)")
AimTab:CreateToggle({ name="Killer Aim Lock", currentValue=false, flag="kaim_on", callback=function(v) KillerAim.Enabled=v end })
AimTab:CreateSlider({ name="Killer Aim FOV", range={50,500}, increment=10, currentValue=200, flag="kaim_fov", callback=function(v) KillerAim.FOV=v end })
AimTab:CreateSlider({ name="Killer Aim Smoothness", range={0.1,1}, increment=0.05, currentValue=0.5, flag="kaim_sm", callback=function(v) KillerAim.Strength=v end })

local KillerTab = Window:CreateTab({ name="Killer", icon=0 })
KillerTab:CreateSection("Attack")
KillerTab:CreateToggle({ name="Auto Attack", currentValue=false, flag="k_attack", callback=function(v) Killer.AutoAttack=v end })
KillerTab:CreateToggle({ name="Auto Kill All", currentValue=false, flag="k_killall", callback=function(v) Killer.KillAll=v end })
KillerTab:CreateToggle({ name="Prediction Attack", currentValue=false, flag="k_predict", callback=function(v) Killer.PredictionAttack=v end })
KillerTab:CreateSlider({ name="Prediction Strength", range={0,1}, increment=0.05, currentValue=0.15, flag="k_predstr", callback=function(v) Killer.PredictStrength=v end })
KillerTab:CreateSection("Carry & Hook")
KillerTab:CreateToggle({ name="Auto Carry Downed", currentValue=false, flag="k_carry", callback=function(v) Killer.AutoCarry=v end })
KillerTab:CreateToggle({ name="Auto Hook After Carry", currentValue=false, flag="k_hook", callback=function(v) Killer.AutoHook=v end })
KillerTab:CreateToggle({ name="Auto Hook All Downed", currentValue=false, flag="k_hookall", callback=function(v) Killer.AutoHookAllDowned=v end })
KillerTab:CreateSlider({ name="Hook All Range", range={100,2000}, increment=50, suffix="stud", currentValue=500, flag="k_hookall_r", callback=function(v) Killer.AutoHookAllRange=v end })
KillerTab:CreateSection("Auto Sprint")
KillerTab:CreateToggle({ name="Auto Sprint", currentValue=false, flag="k_sprint", callback=function(v) Killer.AutoSprint=v end })
KillerTab:CreateSlider({ name="Sprint Speed", range={16,100}, increment=1, currentValue=30, flag="k_sprint_v", callback=function(v) Killer.AutoSprintValue=v end })
KillerTab:CreateSection("Auto Face Target")
KillerTab:CreateToggle({ name="Auto Face Survivor", currentValue=false, flag="k_face", callback=function(v) Killer.AutoFaceTarget=v end })
KillerTab:CreateSlider({ name="Face Range", range={5,100}, increment=5, suffix="stud", currentValue=20, flag="k_face_r", callback=function(v) Killer.AutoFaceRange=v end })
KillerTab:CreateSection("Chase Detector")
KillerTab:CreateToggle({ name="Chase Alert", currentValue=false, flag="k_chase", callback=function(v) ChaseDetector.Enabled=v end })
KillerTab:CreateSlider({ name="Chase Range", range={10,200}, increment=5, suffix="stud", currentValue=30, flag="k_chase_r", callback=function(v) ChaseDetector.Range=v end })
KillerTab:CreateSection("Stalk")
KillerTab:CreateToggle({ name="Auto Stalk", currentValue=false, flag="k_stalk", callback=function(v) Killer.AutoStalk=v; if v then startAutoStalk() else stopAutoStalk() end end })
KillerTab:CreateSlider({ name="Stalk Range", range={50,500}, increment=10, suffix="stud", currentValue=150, flag="k_stalk_r", callback=function(v) Killer.StalkRange=v end })
KillerTab:CreateSection("Masked Power")
KillerTab:CreateDropdown({ name="Select Power", options=MaskedPowers, currentOption="Cobra", flag="k_masked", callback=function(opt) Masked.CurrentPower=opt end })
KillerTab:CreateButton({ name="Activate Power", callback=activateMasked })
KillerTab:CreateButton({ name="Deactivate Power", callback=deactivateMasked })

local TeleportTab = Window:CreateTab({ name="Teleport", icon=0 })
TeleportTab:CreateSection("Teleport Cepat")
TeleportTab:CreateButton({ name="📍 Ke Generator", callback=function()
    if teleportToGenerator() then Rayfield:Notify({ title="TP", content="Ke Generator ✓" })
    else Rayfield:Notify({ title="TP", content="Gak ketemu" }) end
end })
TeleportTab:CreateButton({ name="🚪 Ke Gate / Exit", callback=function()
    if teleportToGate() then Rayfield:Notify({ title="TP", content="Ke Gate ✓" })
    else Rayfield:Notify({ title="TP", content="Gak ketemu" }) end
end })
TeleportTab:CreateButton({ name="🪟 Ke Window", callback=function()
    if teleportToWindow() then Rayfield:Notify({ title="TP", content="Ke Window ✓" })
    else Rayfield:Notify({ title="TP", content="Gak ketemu" }) end
end })
TeleportTab:CreateButton({ name="🟨 Ke Pallet", callback=function()
    if teleportToPallet() then Rayfield:Notify({ title="TP", content="Ke Pallet ✓" })
    else Rayfield:Notify({ title="TP", content="Gak ketemu" }) end
end })
TeleportTab:CreateButton({ name="🪝 Ke Hook", callback=function()
    if teleportToHook() then Rayfield:Notify({ title="TP", content="Ke Hook ✓" })
    else Rayfield:Notify({ title="TP", content="Gak ketemu" }) end
end })
TeleportTab:CreateSection("Auto Escape")
TeleportTab:CreateToggle({ name="Auto Escape", currentValue=false, flag="auto_escape", callback=function(v) AutoEscape.Enabled=v end })
TeleportTab:CreateSlider({ name="Detect Distance", range={10,200}, increment=5, suffix="stud", currentValue=40, flag="escape_d", callback=function(v) AutoEscape.DetectDistance=v end })
TeleportTab:CreateSlider({ name="Cooldown", range={0.2,3}, increment=0.1, suffix="s", currentValue=0.8, flag="escape_cd", callback=function(v) AutoEscape.Cooldown=v end })

local AvatarTab = Window:CreateTab({ name="Avatar", icon=0 })
AvatarTab:CreateSection("Copy Avatar (Full - Fallens)")
AvatarTab:CreateInput({ name="Target Username", currentValue="", placeholder="Ketik username (tanpa @)", flag="av_user", callback=function(v) AvatarCopier.TargetUsername=v end })
AvatarTab:CreateButton({ name="🎭 Copy Avatar (Full)", callback=function() copyAvatarFull(AvatarCopier.TargetUsername) end })
AvatarTab:CreateButton({ name="🔄 Reset to Original", callback=resetAvatar })
AvatarTab:CreateButton({ name="💾 Save Current as Original", callback=function()
    saveOrig()
    Rayfield:Notify({ title="Save Avatar", content="Original disimpan!" })
end })
AvatarTab:CreateToggle({ name="Blocky Body (R6 Style)", currentValue=true, flag="av_blocky", callback=function(v) AvatarCopier.BlockyBody=v end })

local MiscTab = Window:CreateTab({ name="Misc", icon=0 })
MiscTab:CreateSection("Walk Speed")
MiscTab:CreateToggle({ name="Enable Walk Speed", currentValue=false, flag="m_ws", callback=function(v) Movement.WalkSpeedEnabled=v; if v then applyWalkSpeed() else local hum=getHum(); if hum then hum.WalkSpeed=Movement.OriginalWalkSpeed end end end })
MiscTab:CreateSlider({ name="Walk Speed Value", range={16,100}, increment=0.5, currentValue=17.6, flag="m_ws_val", callback=function(v) Movement.WalkSpeedValue=v end })
MiscTab:CreateSection("No Clip")
MiscTab:CreateToggle({ name="No Clip", currentValue=false, flag="m_noclip", callback=function(v) toggleNoClip(v) end })
MiscTab:CreateSection("🌙 Moonwalk")
MiscTab:CreateToggle({ name="Moonwalk", currentValue=false, flag="m_moon", callback=function(v) Moonwalk.Enabled=v; if v then startMoonwalk(); applyMoonwalkFOV() else stopMoonwalk() end end })
MiscTab:CreateDropdown({ name="Moonwalk Mode", options={"Default","Camera"}, currentOption="Default", flag="m_moon_mode", callback=function(opt) Moonwalk.Mode=opt end })
MiscTab:CreateDropdown({ name="Moonwalk FOV", options={"70","90","120"}, currentOption="90", flag="m_moon_fov", callback=function(opt) Moonwalk.FOVPreset=tonumber(opt); if Moonwalk.Enabled then applyMoonwalkFOV() end end })
MiscTab:CreateSlider({ name="Spam Speed", range={1,50}, increment=1, currentValue=30, flag="m_moon_spam", callback=function(v) Moonwalk.SpamSpeed=v end })
MiscTab:CreateSlider({ name="Intensity", range={1,50}, increment=1, currentValue=35, flag="m_moon_int", callback=function(v) Moonwalk.Intensity=v end })
MiscTab:CreateSection("Emote")
MiscTab:CreateDropdown({ name="Select Emote", options=EmoteList, currentOption="Mannrobics", flag="m_emote", callback=function(opt) Emote.Selected=opt end })
MiscTab:CreateButton({ name="Play Emote", callback=function() playEmote(Emote.Selected) end })

local VisualTab = Window:CreateTab({ name="Visual", icon=0 })
VisualTab:CreateSection("Lighting")
VisualTab:CreateToggle({ name="Fullbright", currentValue=false, flag="v_fb", callback=function(v) Visual.Fullbright=v; applyVisual(true) end })
VisualTab:CreateToggle({ name="No Fog", currentValue=false, flag="v_nofog", callback=function(v) Visual.NoFog=v; applyVisual(true) end })
VisualTab:CreateToggle({ name="No Shadow", currentValue=false, flag="v_noshadow", callback=function(v) Visual.NoShadow=v; applyVisual(true) end })
VisualTab:CreateSection("Ambient & Time")
VisualTab:CreateToggle({ name="Custom Ambient Color", currentValue=false, flag="v_amb", callback=function(v) Visual.AmbientColorEnabled=v; applyVisual(true) end })
VisualTab:CreateColorPicker({ name="Ambient Color", color=Visual.AmbientColor, flag="v_amb_c", callback=function(c) Visual.AmbientColor=c; applyVisual(true) end })
VisualTab:CreateToggle({ name="Custom Clock Time", currentValue=false, flag="v_clock", callback=function(v) Visual.ClockTimeEnabled=v; applyVisual(true) end })
VisualTab:CreateSlider({ name="Clock Time", range={0,24}, increment=1, currentValue=14, flag="v_clock_v", callback=function(v) Visual.ClockTime=v; applyVisual(true) end })
VisualTab:CreateSection("Fog Control")
VisualTab:CreateToggle({ name="Custom Fog", currentValue=false, flag="v_fog", callback=function(v) Visual.FogControlEnabled=v; applyVisual(true) end })
VisualTab:CreateSlider({ name="Fog End", range={0,100000}, increment=100, currentValue=100000, flag="v_fog_e", callback=function(v) Visual.FogEnd=v; applyVisual(true) end })
VisualTab:CreateSlider({ name="Fog Start", range={0,100000}, increment=100, currentValue=0, flag="v_fog_s", callback=function(v) Visual.FogStart=v; applyVisual(true) end })
VisualTab:CreateColorPicker({ name="Fog Color", color=Visual.FogColor, flag="v_fog_c", callback=function(c) Visual.FogColor=c; applyVisual(true) end })
VisualTab:CreateSection("Screen Effects")
VisualTab:CreateToggle({ name="No Bloom", currentValue=false, flag="v_nobloom", callback=function(v) Visual.NoBloom=v; toggleScreenEffects() end })
VisualTab:CreateToggle({ name="No Blur / DOF", currentValue=false, flag="v_noblur", callback=function(v) Visual.NoBlur=v; toggleScreenEffects() end })
VisualTab:CreateToggle({ name="No Blood", currentValue=false, flag="v_noblood", callback=function(v) Visual.NoBlood=v; removeBlood() end })
VisualTab:CreateSection("Color Correction")
VisualTab:CreateToggle({ name="Enable Color Correction", currentValue=false, flag="v_cc", callback=function(v) Visual.ColorCorrection=v; applyColorCorrection() end })
VisualTab:CreateSlider({ name="Saturation", range={-1,1}, increment=0.05, currentValue=0, flag="v_sat", callback=function(v) Visual.Saturation=v; applyColorCorrection() end })
VisualTab:CreateSlider({ name="Brightness", range={-1,1}, increment=0.05, currentValue=0, flag="v_bright", callback=function(v) Visual.Brightness=v; applyColorCorrection() end })
VisualTab:CreateSlider({ name="Contrast", range={-1,1}, increment=0.05, currentValue=0, flag="v_contrast", callback=function(v) Visual.Contrast=v; applyColorCorrection() end })
VisualTab:CreateButton({ name="🔄 Reset Color", callback=function() resetColorCorrection(); Rayfield:Notify({ title="Color Reset", content="Reset ok" }) end })

local CrosshairTab = Window:CreateTab({ name="Crosshair", icon=0 })
CrosshairTab:CreateToggle({ name="Enable Crosshair", currentValue=false, flag="ch_on", callback=function(v) Crosshair.Enabled=v end })
CrosshairTab:CreateColorPicker({ name="Color", color=Crosshair.Color, flag="ch_c", callback=function(c) Crosshair.Color=c end })
CrosshairTab:CreateSlider({ name="Size", range={2,30}, increment=1, suffix="px", currentValue=8, flag="ch_s", callback=function(v) Crosshair.Size=v end })
CrosshairTab:CreateSlider({ name="Thickness", range={1,5}, increment=1, suffix="px", currentValue=2, flag="ch_t", callback=function(v) Crosshair.Thickness=v end })
CrosshairTab:CreateSlider({ name="Position X", range={-100,100}, increment=1, suffix="px", currentValue=0, flag="ch_x", callback=function(v) Crosshair.OffsetX=v end })
CrosshairTab:CreateSlider({ name="Position Y", range={-100,100}, increment=1, suffix="px", currentValue=0, flag="ch_y", callback=function(v) Crosshair.OffsetY=v end })

local QuickTab = Window:CreateTab({ name="Quick Actions", icon=0 })
QuickTab:CreateSection("🚀 Teleport Cepat")
QuickTab:CreateButton({ name="📍 Ke Generator", callback=function() teleportToGenerator() end })
QuickTab:CreateButton({ name="🚪 Ke Gate / Exit", callback=function() teleportToGate() end })
QuickTab:CreateButton({ name="🪝 Ke Hook", callback=function() teleportToHook() end })
QuickTab:CreateSection("⚡ One-Tap Mode")
QuickTab:CreateButton({ name="🟢 Survivor Mode ON", callback=function()
    Auto.Parry=true; Auto.SkillCheck=true; Auto.Wiggle=true
    ESP.Survivor=true; ESP.Killer=true; ESP.Generator=true
    Movement.WalkSpeedEnabled=true; Movement.WalkSpeedValue=20; applyWalkSpeed()
    Visual.Fullbright=true; applyVisual(true)
    Rayfield:Notify({ title="Mode", content="Survivor Pro ON!", duration=3 })
end })
QuickTab:CreateButton({ name="🔴 Killer Mode ON", callback=function()
    Killer.AutoAttack=true; Killer.AutoCarry=true; Killer.AutoHook=true; Killer.KillAll=true
    ESP.Survivor=true; ESP.Hook=true
    Movement.WalkSpeedEnabled=true; Movement.WalkSpeedValue=22; applyWalkSpeed()
    Rayfield:Notify({ title="Mode", content="Killer Pro ON!", duration=3 })
end })
QuickTab:CreateButton({ name="🛑 Panic Mode", callback=function()
    Auto.Parry=false; Auto.SkillCheck=false; Auto.Wiggle=false
    ESP.Survivor=false; ESP.Killer=false; ESP.Generator=false; ESP.Hook=false; ESP.Pallet=false; ESP.Window=false; ESP.SCP=false
    Killer.AutoAttack=false; Killer.AutoCarry=false; Killer.AutoHook=false; Killer.KillAll=false
    Movement.WalkSpeedEnabled=false; Movement.NoClip=false; toggleNoClip(false)
    Aimlock.Enabled=false; Aimlock.Holding=false; Aimlock.Locked=false
    Moonwalk.Enabled=false; stopMoonwalk()
    Rayfield:Notify({ title="Mode", content="Panic! Semua OFF.", duration=3 })
end })

local UISettingsTab = Window:CreateTab({ name="UI Settings", icon=0 })
UISettingsTab:CreateSection("Sound Feedback")
UISettingsTab:CreateToggle({ name="Enable Click Sound", currentValue=true, flag="sf_on", callback=function(v) SoundFeedback.Enabled=v end })
UISettingsTab:CreateDropdown({ name="Sound Type", options={"Click","Switch","Beep","Bell","Whoosh"}, currentOption="Click", flag="sf_type", callback=function(opt) SoundFeedback.CurrentSound=opt; playClickSound() end })
UISettingsTab:CreateSlider({ name="Volume", range={0,1}, increment=0.05, currentValue=0.5, flag="sf_vol", callback=function(v) SoundFeedback.Volume=v; if SoundInstance then SoundInstance.Volume=v end; playClickSound() end })
UISettingsTab:CreateButton({ name="🔊 Test Sound", callback=function() playClickSound() end })

print("[TiarHub v19] Part 4/5 loaded.")-- ============ FLOATING BUTTONS ============
local SaveData = { AMPos=UDim2.new(0.05,0,0.35,0), MWPos=UDim2.new(0.05,0,0.45,0), LKPos=UDim2.new(0.05,0,0.55,0) }
pcall(function()
    if isfile and isfile("TiarV19_Config.json") then
        local d = HttpService:JSONDecode(readfile("TiarV19_Config.json"))
        if d.AMPos then SaveData.AMPos = UDim2.new(d.AMPos[1],d.AMPos[2],d.AMPos[3],d.AMPos[4]) end
        if d.MWPos then SaveData.MWPos = UDim2.new(d.MWPos[1],d.MWPos[2],d.MWPos[3],d.MWPos[4]) end
        if d.LKPos then SaveData.LKPos = UDim2.new(d.LKPos[1],d.LKPos[2],d.LKPos[3],d.LKPos[4]) end
    end
end)
local function savePos()
    pcall(function()
        if writefile then
            writefile("TiarV19_Config.json", HttpService:JSONEncode({
                AMPos={SaveData.AMPos.X.Scale,SaveData.AMPos.X.Offset,SaveData.AMPos.Y.Scale,SaveData.AMPos.Y.Offset},
                MWPos={SaveData.MWPos.X.Scale,SaveData.MWPos.X.Offset,SaveData.MWPos.Y.Scale,SaveData.MWPos.Y.Offset},
                LKPos={SaveData.LKPos.X.Scale,SaveData.LKPos.X.Offset,SaveData.LKPos.Y.Scale,SaveData.LKPos.Y.Offset}
            }))
        end
    end)
end

local FloatingGui = Instance.new("ScreenGui")
FloatingGui.Name="TiarV19_Floating"; FloatingGui.ResetOnSpawn=false
FloatingGui.IgnoreGuiInset=true; FloatingGui.Parent=PlayerGui

local function makeDraggable(frame, which)
    local dragging=false; local dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true; dragStart=input.Position; startPos=frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            if dragging then
                dragging=false
                if which=="AM" then SaveData.AMPos=frame.Position
                elseif which=="MW" then SaveData.MWPos=frame.Position
                elseif which=="LK" then SaveData.LKPos=frame.Position end
                savePos()
            end
        end
    end)
end

local function makeButton(name, text, pos, color, which, onClick)
    local btn = Instance.new("TextButton")
    btn.Name=name; btn.Text=text; btn.Size=UDim2.fromOffset(55,55); btn.Position=pos
    btn.BackgroundColor3=Color3.fromRGB(18,18,22); btn.BackgroundTransparency=0.1
    btn.TextColor3=color; btn.Font=Enum.Font.GothamBlack; btn.TextSize=16
    btn.AutoButtonColor=false; btn.Parent=FloatingGui
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    local stroke = Instance.new("UIStroke")
    stroke.Color=color; stroke.Thickness=2; stroke.Transparency=0.2; stroke.Parent=btn
    local glow = Instance.new("UIStroke")
    glow.Color=color; glow.Thickness=6; glow.Transparency=0.7; glow.Parent=btn
    btn.MouseButton1Click:Connect(function() onClick(btn, stroke) end)
    btn.MouseEnter:Connect(function() btn.BackgroundColor3=Color3.fromRGB(28,28,35) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3=Color3.fromRGB(18,18,22) end)
    makeDraggable(btn, which)
    return btn
end

local AMButton = makeButton("AMButton","AM",SaveData.AMPos,Color3.fromRGB(255,60,60),"AM",function(btn,stroke)
    Aimlock.Enabled = not Aimlock.Enabled
    Aimlock.Holding = Aimlock.Enabled
    if Aimlock.Enabled then
        stroke.Color=Color3.fromRGB(0,255,100); btn.TextColor3=Color3.fromRGB(0,255,100)
    else
        stroke.Color=Color3.fromRGB(255,60,60); btn.TextColor3=Color3.fromRGB(255,60,60)
    end
end)

local MWButton = makeButton("MWButton","MW",SaveData.MWPos,Color3.fromRGB(170,0,255),"MW",function(btn,stroke)
    Moonwalk.Enabled = not Moonwalk.Enabled
    if Moonwalk.Enabled then
        stroke.Color=Color3.fromRGB(0,255,100); btn.TextColor3=Color3.fromRGB(0,255,100)
        startMoonwalk(); applyMoonwalkFOV()
    else
        stroke.Color=Color3.fromRGB(170,0,255); btn.TextColor3=Color3.fromRGB(170,0,255)
        stopMoonwalk()
    end
end)

local LKButton = makeButton("LKButton","LK",SaveData.LKPos,Color3.fromRGB(255,200,0),"LK",function(btn,stroke)
    Aimlock.Locked = not Aimlock.Locked
    if Aimlock.Locked then
        Aimlock.Enabled=true; Aimlock.Holding=true
        stroke.Color=Color3.fromRGB(0,255,100); btn.TextColor3=Color3.fromRGB(0,255,100)
    else
        stroke.Color=Color3.fromRGB(255,200,0); btn.TextColor3=Color3.fromRGB(255,200,0)
    end
end)

-- ============ AUTO APPLY ON RESPAWN ============
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    pcall(function()
        applyVisual(true); toggleScreenEffects(); applyColorCorrection()
        if Moonwalk.Enabled then task.wait(0.5); startMoonwalk(); applyMoonwalkFOV() end
        if FakePerks.Flowstate.Enabled then hookFakeFlowstate(char) end
    end)
end)

-- ============ NOTIFIKASI ============
task.wait(1)
Rayfield:Notify({ title="⚡ TiarHub v19 ⚡", content="Script loaded! Tombol AM/MW/LK muncul.", duration=8 })
task.wait(2)
Rayfield:Notify({ title="🎯 Fitur Baru", content="Cooldown 70s + Copy Avatar Full + Tab Aimlock + LK button", duration=8 })
task.wait(2)
Rayfield:Notify({ title="💡 Tips", content="Drag tombol AM/MW/LK. Auto-save posisi.", duration=8 })

print("============================================")
print("  ⚡ TIARHUB v19 - ALL LOADED ⚡")
print("  ==========================================")
print("  [✓] ESP + Killer Warning")
print("  [✓] Auto Parry + Skill Check")
print("  [✓] Fake Perks + Cooldown 70s")
print("  [✓] Silent Aim Veil Spear")
print("  [✓] Aimbot + FOV + Tracer")
print("  [✓] Aimlock (Killer/Survivor/Auto)")
print("  [✓] Hit Marker")
print("  [✓] Killer System + Stalk")
print("  [✓] Movement + Moonwalk 2 Mode")
print("  [✓] Copy Avatar FULL (Fallens)")
print("  [✓] Teleport + Auto Escape")
print("  [✓] Visual + Color Correction")
print("  [✓] Crosshair + Sound")
print("  [✓] Quick Actions (Mode Presets)")
print("  [✓] Tombol AM / MW / LK")
print("  ==========================================")
print("  🎮 Violence District | TiarHub v19")
print("============================================")
