-- ⚡ TIARHUB v21 FINAL
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

local Window = Rayfield:CreateWindow({
    name = "⚡ TiarHub ⚡",
    subtitle = "Violence District | v21",
    sidebarLayout = true,
    configuration = { autoSave = false, autoLoad = false, fileName = "TiarV21" }
})

local ESP = { Survivor=false, Killer=false, Generator=false, Hook=false, Pallet=false, Window=false, SCP=false, Distance=300, Mode="Highlight", ShowName=true, NameSize=14, SurvivorColor=Color3.fromRGB(60,255,120), KillerColor=Color3.fromRGB(255,60,60), GeneratorColor=Color3.fromRGB(255,170,0), HookColor=Color3.fromRGB(180,80,255), PalletColor=Color3.fromRGB(255,220,80), WindowColor=Color3.fromRGB(80,255,255), SCPColor=Color3.fromRGB(255,0,0) }
local ESPStatus = { Enabled=false, ShowName=true, ShowDistance=true, ShowHealth=false, Radius=100 }
local KillerWarning = { Enabled=false, Distance=60, Color=Color3.fromRGB(255,0,0) }
local Visual = { Fullbright=false, NoFog=false, NoShadow=false, NoBloom=false, NoBlur=false, ColorCorrection=false, Saturation=0, Brightness=0, Contrast=0, NoBlood=false }
local VisualOriginal = { Brightness=Lighting.Brightness, ClockTime=Lighting.ClockTime, Ambient=Lighting.Ambient, OutdoorAmbient=Lighting.OutdoorAmbient, GlobalShadows=Lighting.GlobalShadows, FogEnd=Lighting.FogEnd, FogStart=Lighting.FogStart, FogColor=Lighting.FogColor }
local Auto = { Parry=false, ParryDistance=12, SkillCheck=false, Wiggle=false, WiggleSpam=5 }
local AutoFlee = { Enabled=false, DetectDistance=50, Cooldown=0.1 }
local LastFlee = 0
local FastVault = { Enabled=false, Speed=1.2, ReplaceMap={ ["rbxassetid://83873880822918"]="rbxassetid://136962284480779" } }
local VaultTracks = {}
local AutoDodgeAbyss = { Enabled=false, DetectRange=18, Cooldown=0.5, CrouchDuration=0.3, LastDodge=0, IsCrouching=false }
local SilentAimSpear = { Enabled=false, TargetMode="Killer", FOV=250, AimPart="HumanoidRootPart", Prediction=0.12, Holding=false, ShowFOV=false }
local Teleport = { LastTeleport=0, Cooldown=0.5 }
local AutoEscape = { Enabled=false, DetectDistance=40, Cooldown=0.8, LastEscape=0 }
local SkillCheckMode = "Perfect"
local SoundFeedback = { Enabled=true, CurrentSound="Click", Volume=0.5, LastPlay=0, Cooldown=0.05 }
local SoundList = { Click="rbxassetid://6895079853", Switch="rbxassetid://876939830", Beep="rbxassetid://4817809188", Bell="rbxassetid://5156781795", Whoosh="rbxassetid://5063167535" }
local SoundInstance = nil
local function initSound() if SoundInstance then return end; SoundInstance=Instance.new("Sound"); SoundInstance.Name="TiarClickSound"; SoundInstance.Volume=SoundFeedback.Volume; pcall(function() SoundInstance.Parent=SoundService end); if not SoundInstance.Parent then SoundInstance.Parent=CoreGui end end
local function playClickSound() if not SoundFeedback.Enabled then return end; local now=tick(); if now-SoundFeedback.LastPlay<SoundFeedback.Cooldown then return end; SoundFeedback.LastPlay=now; initSound(); pcall(function() SoundInstance.SoundId=SoundList[SoundFeedback.CurrentSound] or SoundList.Click; SoundInstance.Volume=SoundFeedback.Volume; SoundInstance:Play() end) end
initSound()

local AvatarCopier = { TargetUsername="", OriginalDescription=nil, CurrentCopiedUserId=nil, BlockyBody=true }
local GunAim = { Enabled=false, Holding=false, TargetMode="Killer", Strength=1, Predict=true, PredictStrength=0.12, FOV=250, AimPart="HumanoidRootPart" }
local FOVCircle=nil; local FOVCircleInner=nil; local FOVCircleVisible=false; local FOVCircleSize=250; local FOVCircleColor=Color3.fromRGB(255,255,255)
local KillerAim = { Enabled=false, FOV=200, Strength=0.5, Holding=false }
local AimlockKiller = { Enabled=false, FOV=200, Strength=0.35, Prediction=true, PredictStrength=0.12, AimPart="Head" }
local AimlockKillerCircle = nil
local AutoAimSurvivor = { Enabled=false, RadiusLock=250, AimPart="Head", Smoothness=0.4, ShowRadius=true, Locked=false }
local AutoAimFOV = nil
local ESPCircle = { Enabled=false, Radius=5, Color=Color3.fromRGB(0,255,100) }
local ESPCircleDrawing = nil
local Killer = { AutoAttack=false, AutoCarry=false, AutoHook=false, KillAll=false, AutoStalk=false, StalkRange=150, AutoHookAllDowned=false, AutoHookAllRange=500, AutoSprint=false, AutoSprintValue=30, AutoFaceTarget=false, AutoFaceRange=20, PredictionAttack=false, PredictStrength=0.15 }
local KillerBusy=false; local KillerTarget=nil; local StalkConnection=nil
local HitMarker = { Enabled=false, Color=Color3.fromRGB(255,0,0), Size=20, Thickness=2, Duration=0.15 }
local HitMarkerLines={}; local HitMarkerActive=false; local HitMarkerEnd=0
local ChaseDetector = { Enabled=false, Range=30, LastNotify=0, Cooldown=2 }
local Movement = { WalkSpeedEnabled=false, WalkSpeedValue=17.6, OriginalWalkSpeed=16, NoClip=false }
local Moonwalk = { Enabled=false, SpamSpeed=30, Intensity=35, SlowSpeed=13, UseSlow=true, Mode="Default", FOVPreset=90 }
local MoonwalkConnection=nil; local MoonwalkHeartbeat=nil
local Crosshair = { Enabled=false, Size=8, Thickness=2, Color=Color3.fromRGB(255,255,255), OffsetX=0, OffsetY=0 }
local CrosshairGui = nil
local Masked = { CurrentPower="Cobra" }
local MaskedPowers = {"Cobra","Richter","Brandon","Rabbit","Alex"}
local CameraZoom = { UnlimitedZoom=false, MaxDistance=1000, MinDistance=0, FOVEnabled=false, FOV=90, DefaultFOV=workspace.CurrentCamera.FieldOfView }
local JerkTool = { Enabled=false }
local currentJerkTool = nil
local FPS=0; local Frames=0; local LastTick=tick()
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
local function findRemote(path) local cur=ReplicatedStorage; for seg in string.gmatch(path,"[^%.]+") do cur=cur and cur:FindFirstChild(seg); if not cur then return nil end end return cur end
local AttackEvent = findRemote("Remotes.Attacks.BasicAttack")
local CarryEvent = findRemote("Remotes.Carry.CarrySurvivorEvent")
local HookEvent = findRemote("Remotes.Carry.HookEvent")
local EmoteRemote = findRemote("Remotes.EmoteHandler")
local function getRoot() local c=LocalPlayer.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c=LocalPlayer.Character; return c and c:FindFirstChildOfClass("Humanoid") end
local function isDowned() local h=getHum(); if not h then return false end; return h.Health<=0 or h.Health<2 end
local function shouldDisableWalkSpeed()
    local c=LocalPlayer.Character; if not c then return false end
    local h=c:FindFirstChildOfClass("Humanoid")
    if h then
        local a=h:FindFirstChildOfClass("Animator")
        if a then
            for _,t in ipairs(a:GetPlayingAnimationTracks()) do
                local an=t.Animation
                if an and an.AnimationId then
                    local id=an.AnimationId:match("%d+")
                    if id and KillerAnims["rbxassetid://"..id] then return true end
                end
            end
        end
    end
    if h and (h.Health<=0 or h.Health<2) then return true end
    return false
end
local function GetPos(obj) if not obj then return nil end; if obj:IsA("BasePart") then return obj.Position end; if obj:IsA("Model") then local ok,p=pcall(function() return obj:GetPivot().Position end); if ok then return p end end return nil end
local function getTeamLabel(plr) if not plr.Team then return "?" end; if plr.Team.Name=="Killer" then return "KILLER" end; if plr.Team.Name=="Survivors" or plr.Team.Name=="Survivor" then return "SURVIVOR" end; return plr.Team.Name end
local function GetNearestKiller()
    local r=getRoot(); if not r then return nil end
    local c,s=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LocalPlayer and plr.Team and plr.Team.Name=="Killer" and plr.Character then
            local h=plr.Character:FindFirstChild("HumanoidRootPart")
            if h then local d=(h.Position-r.Position).Magnitude; if d<s then s=d; c=h end end
        end
    end
    return c,s
end

-- ESP SYSTEM
local ESPObjects={}; local ESPNames={}; local StatusESP={}
local CachedObjects = { Generators={}, Hooks={}, Pallets={}, Windows={} }
local CachedSCP = {}
local function removeESP(obj) if ESPObjects[obj] then ESPObjects[obj]:Destroy(); ESPObjects[obj]=nil end; if ESPNames[obj] then ESPNames[obj]:Destroy(); ESPNames[obj]=nil end end
local function createESP(obj,color,showName,customName)
    if not obj then return end
    if ESPObjects[obj] then
        local h=ESPObjects[obj]
        if ESP.Mode=="Outline" then h.FillTransparency=1; h.OutlineTransparency=0
        elseif ESP.Mode=="Fill" then h.FillTransparency=0.5; h.OutlineTransparency=1
        else h.FillTransparency=0.9; h.OutlineTransparency=0.3 end
        h.FillColor=color; h.OutlineColor=color
    else
        local h=Instance.new("Highlight"); h.FillColor=color; h.OutlineColor=color
        if ESP.Mode=="Outline" then h.FillTransparency=1; h.OutlineTransparency=0
        elseif ESP.Mode=="Fill" then h.FillTransparency=0.5; h.OutlineTransparency=1
        else h.FillTransparency=0.9; h.OutlineTransparency=0.3 end
        h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Parent=obj; ESPObjects[obj]=h
        obj.AncestryChanged:Connect(function(_,p) if not p then removeESP(obj) end end)
    end
    if showName then
        local head=obj:FindFirstChild("Head")
        local ad=head or (obj:IsA("BasePart") and obj)
        if ad then
            local pn=customName or "?"; local tl=""
            if not customName then local plr=Players:GetPlayerFromCharacter(obj); if plr then pn=plr.Name; tl=getTeamLabel(plr) end end
            local dt=pn; if tl~="" then dt=string.format("[%s] %s",tl,pn) end
            if ESPNames[obj] then
                local bb=ESPNames[obj]; bb.Size=UDim2.new(0,250,0,ESP.NameSize*2)
                local lbl=bb:FindFirstChildOfClass("TextLabel")
                if lbl then lbl.Text=dt; lbl.TextSize=ESP.NameSize; lbl.TextColor3=color end
            else
                local bb=Instance.new("BillboardGui"); bb.Size=UDim2.new(0,250,0,ESP.NameSize*2)
                bb.AlwaysOnTop=true; bb.StudsOffset=Vector3.new(0,2.5,0); bb.Adornee=ad; bb.Parent=obj
                local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
                lbl.Text=dt; lbl.TextColor3=color; lbl.TextStrokeTransparency=0; lbl.TextStrokeColor3=Color3.new(0,0,0)
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
    if not found then local a2=gen:GetAttribute("RepairProgress"); if a2 and type(a2)=="number" then percent=a2; found=true end end
    if not found then for _,v in ipairs(gen:GetDescendants()) do if v:IsA("ValueBase") and (v.Name=="Progress" or v.Name=="RepairProgress" or v.Name=="Percent") then percent=v.Value; found=true; break end end end
    if not found then for _,v in ipairs(gen:GetChildren()) do if v:IsA("NumberValue") then percent=v.Value; found=true; break end end end
    percent=math.clamp(percent,0,100)
    local color=ESP.GeneratorColor; local txt="Generator"
    if found then color=ESP.GeneratorColor:Lerp(Color3.fromRGB(0,255,120),percent/100); txt=string.format("Gen %.0f%%",percent) end
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
        local lbl=Instance.new("TextLabel"); lbl.Name="Label"; lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
        lbl.TextStrokeTransparency=0; lbl.TextStrokeColor3=Color3.new(0,0,0); lbl.Font=Enum.Font.GothamBold; lbl.TextSize=14; lbl.Parent=bb
    end
    local lbl=bb:FindFirstChild("Label") or bb:FindFirstChildOfClass("TextLabel")
    if lbl then lbl.Text=txt; lbl.TextColor3=color end
end
local function removeStatusESP(char) if StatusESP[char] then StatusESP[char]:Destroy(); StatusESP[char]=nil end end
local function createStatusESP(player,char,root)
    if not ESPStatus.Enabled then removeStatusESP(char); return end
    if not root then return end
    local head=char:FindFirstChild("Head"); local hum=char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end
    local isDown=hum.Health<=0 or hum.Health<2
    local dist=(head.Position-root.Position).Magnitude
    if dist>ESPStatus.Radius then removeStatusESP(char); return end
    local text=""; local tl=getTeamLabel(player)
    if isDown then text="DOWN\n" end
    text=text..string.format("[%s]\n",tl)
    if ESPStatus.ShowName then text=text..player.Name.."\n" end
    if ESPStatus.ShowDistance then text=text..string.format("Dist: %.0f\n",dist) end
    if ESPStatus.ShowHealth then text=text..string.format("HP: %.0f\n",hum.Health) end
    if text=="" then removeStatusESP(char); return end
    local bb=StatusESP[char]
    if not bb then
        bb=Instance.new("BillboardGui"); bb.Size=UDim2.new(0,150,0,60); bb.AlwaysOnTop=true
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
        lbl.TextStrokeTransparency=0; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12; lbl.Parent=bb
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
    local n=obj.Name
    if n=="Generator" then CachedObjects.Generators[obj]=true
    elseif string.find(n,"Hook") and obj:IsA("BasePart") then CachedObjects.Hooks[obj]=true
    elseif n=="Pallet" or n=="Palletwrong" then CachedObjects.Pallets[obj]=true
    elseif n=="Window" then CachedObjects.Windows[obj]=true end
    if string.find(string.lower(n),"scp") then CachedSCP[obj]=true end
end
for _,obj in ipairs(workspace:GetDescendants()) do cacheObject(obj) end
workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(function(obj)
    CachedObjects.Generators[obj]=nil; CachedObjects.Hooks[obj]=nil
    CachedObjects.Pallets[obj]=nil; CachedObjects.Windows[obj]=nil
    CachedSCP[obj]=nil; removeESP(obj)
end)
local WarningGui=nil
local function updateWarning()
    pcall(function()
        local root=getRoot()
        if not KillerWarning.Enabled or not root then
            if WarningGui then WarningGui.Enabled=false end
            return
        end
        local nearest, dist = nil, math.huge
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                local isK=p.Team and p.Team.Name=="Killer"
                if isK then
                    local h=p.Character:FindFirstChild("HumanoidRootPart")
                    if h then local d=(h.Position-root.Position).Magnitude; if d<dist then dist=d; nearest=p end end
                end
            end
        end
        if not WarningGui then
            WarningGui=Instance.new("ScreenGui"); WarningGui.Name="TiarKillerWarning"
            WarningGui.ResetOnSpawn=false; WarningGui.IgnoreGuiInset=true; WarningGui.Parent=PlayerGui
            local f=Instance.new("Frame"); f.Name="Border"; f.Size=UDim2.new(1,0,1,0); f.BackgroundTransparency=1; f.Parent=WarningGui
            local st=Instance.new("UIStroke"); st.Name="Stroke"; st.Thickness=12; st.Color=KillerWarning.Color; st.Transparency=0.5; st.Parent=f
            local t=Instance.new("TextLabel"); t.Name="WarnText"; t.Size=UDim2.new(0,400,0,60)
            t.Position=UDim2.new(0.5,-200,0,40); t.BackgroundTransparency=1; t.Text="KILLER DEKAT"
            t.TextColor3=KillerWarning.Color; t.TextStrokeTransparency=0; t.TextStrokeColor3=Color3.new(0,0,0)
            t.Font=Enum.Font.GothamBlack; t.TextScaled=true; t.Visible=false; t.Parent=WarningGui
        end
        WarningGui.Enabled=true
        local b=WarningGui:FindFirstChild("Border")
        local st=b and b:FindFirstChild("Stroke")
        local wt=WarningGui:FindFirstChild("WarnText")
        if dist<=KillerWarning.Distance then
            if st then st.Transparency=0.3 end
            if wt then wt.Visible=true; wt.Text=string.format("KILLER DEKAT (%.0f stud)",dist) end
        else
            if st then st.Transparency=0.9 end
            if wt then wt.Visible=false end
        end
    end)
end
RunService.RenderStepped:Connect(function()
    Frames=Frames+1
    if tick()-LastTick>=1 then
        FPS=Frames; Frames=0; LastTick=tick()
    end
end)
local lastUpdate=0
RunService.RenderStepped:Connect(function()
    pcall(function()
        local root=getRoot(); if not root then return end
        local now=tick()
        if now-lastUpdate<0.3 then return end
        lastUpdate=now
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                local char=p.Character
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health>0 then
                    local hrp=char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local dist=(hrp.Position-root.Position).Magnitude
                        if dist<=ESP.Distance then
                            local isK=p.Team and p.Team.Name=="Killer"
                            local isS=p.Team and (p.Team.Name=="Survivors" or p.Team.Name=="Survivor")
                            if ESP.Survivor and isS then createESP(char,ESP.SurvivorColor,ESP.ShowName)
                            elseif ESP.Killer and isK then createESP(char,ESP.KillerColor,ESP.ShowName)
                            else removeESP(char) end
                        else removeESP(char) end
                    end
                    createStatusESP(p,char,root)
                else removeESP(char); removeStatusESP(char) end
            end
        end
        if ESP.Generator then for g in pairs(CachedObjects.Generators) do local pos=GetPos(g); if pos and (pos-root.Position).Magnitude<=ESP.Distance then UpdateGenerator(g) else local o=g:FindFirstChild("GenHighlight"); if o then o:Destroy() end; local n=g:FindFirstChild("GenNameTag"); if n then n:Destroy() end end end end
        if ESP.Hook then for h in pairs(CachedObjects.Hooks) do local pos=GetPos(h); if pos and (pos-root.Position).Magnitude<=ESP.Distance then createESP(h,ESP.HookColor,false) else removeESP(h) end end else for h in pairs(CachedObjects.Hooks) do removeESP(h) end end
        if ESP.Pallet then for pa in pairs(CachedObjects.Pallets) do local pos=GetPos(pa); if pos and (pos-root.Position).Magnitude<=ESP.Distance then createESP(pa,ESP.PalletColor,false) else removeESP(pa) end end else for pa in pairs(CachedObjects.Pallets) do removeESP(pa) end end
        if ESP.Window then for w in pairs(CachedObjects.Windows) do local pos=GetPos(w); if pos and (pos-root.Position).Magnitude<=ESP.Distance then createESP(w,ESP.WindowColor,false) else removeESP(w) end end else for w in pairs(CachedObjects.Windows) do removeESP(w) end end
        if ESP.SCP then for s in pairs(CachedSCP) do local pos=GetPos(s); if pos and (pos-root.Position).Magnitude<=ESP.Distance then createESP(s,ESP.SCPColor,false) else removeESP(s) end end else for s in pairs(CachedSCP) do removeESP(s) end end
        updateWarning()
    end)
end)
print("[TiarHub v21] Part 1/5 loaded.")-- AUTO PARRY (Semua Arah)
local lastParry = 0
local ParryActive2 = false
local function GetParryButton()
    local cur = PlayerGui
    for seg in string.gmatch("Survivor-mob.Controls.Gui-mob","[^%.]+") do cur = cur and cur:FindFirstChild(seg) end
    return cur
end
local function pressParryButton()
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
end
task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            if not Auto.Parry then return end
            if ParryActive2 then return end
            local myRoot = getRoot(); if not myRoot then return end
            local myHum = getHum(); if not myHum or myHum.Health <= 0 then return end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Team and plr.Team.Name == "Killer" then
                    local kHum = plr.Character:FindFirstChildOfClass("Humanoid")
                    local kRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                    if kHum and kRoot and kHum.Health > 0 then
                        local animator = kHum:FindFirstChildOfClass("Animator")
                        if animator then
                            local isAttacking = false
                            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                local anim = track.Animation
                                if anim and anim.AnimationId then
                                    local id = anim.AnimationId:match("%d+")
                                    if id and KillerAnims["rbxassetid://"..id] then isAttacking = true; break end
                                end
                            end
                            if isAttacking then
                                local dist = (kRoot.Position - myRoot.Position).Magnitude
                                if dist <= Auto.ParryDistance then
                                    ParryActive2 = true
                                    pressParryButton()
                                    task.delay(0.3, function() ParryActive2 = false end)
                                    break
                                end
                            end
                        end
                    end
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
local function GetFarthestGeneratorPoint(kr)
    if not kr then return nil end
    local bp, fd = nil, 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.match(obj.Name,"^GeneratorPoint%d+$") then
            local d = (obj.Position-kr.Position).Magnitude
            if d>fd then fd=d; bp=obj end
        end
    end
    return bp
end
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if not AutoFlee.Enabled then return end
            local root = getRoot(); if not root then return end
            local kr, dist = GetNearestKiller()
            if kr and dist <= AutoFlee.DetectDistance and tick()-LastFlee > AutoFlee.Cooldown then
                local pt = GetFarthestGeneratorPoint(kr)
                if pt then LastFlee = tick(); root.CFrame = pt.CFrame + Vector3.new(0,5,0) end
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
    local c,s = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and IsAbyssKiller(plr) then
            local h = plr.Character:FindFirstChild("HumanoidRootPart")
            if h then local d=(h.Position-root.Position).Magnitude; if d<s then s=d; c=h end end
        end
    end
    return c,s
end
local function FindCrouchButton()
    local paths = {"Survivor-mob.Controls.Gui-mob.Crouch","Survivor-mob.Controls.Gui-mob.crouch","Survivor-mob.Controls.crouch","Survivor-mob.Controls.Crouch"}
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
            local a, dist = GetNearestAbyss()
            if not a then return end
            if dist > AutoDodgeAbyss.DetectRange then return end
            local now = tick()
            if now-AutoDodgeAbyss.LastDodge < AutoDodgeAbyss.Cooldown then return end
            AutoDodgeAbyss.LastDodge = now; DoDodgeAbyss()
        end)
    end
end)

-- FAST VAULT
local function normalizeId(id)
    local n = tostring(id):match("%d+")
    return n and ("rbxassetid://"..n)
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
            local na = Instance.new("Animation"); na.AnimationId = replaceId
            local nt = animator:LoadAnimation(na)
            nt.Priority = Enum.AnimationPriority.Action
            nt:Play(); nt:AdjustSpeed(FastVault.Speed)
            nt.Stopped:Connect(function() VaultTracks[track]=nil end)
        end)
    end)
end
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5); pcall(function() hookVault(char) end)
end)
if LocalPlayer.Character then pcall(function() hookVault(LocalPlayer.Character) end) end

-- FOV CIRCLE + TRACER (Aimbot Survivor)
local Drawing = Drawing
local TracerLine = nil
local function createFOVCircle()
    if not Drawing then return end
    if FOVCircle then FOVCircle:Remove() end
    if FOVCircleInner then FOVCircleInner:Remove() end
    FOVCircle = Drawing.new("Circle"); FOVCircle.Visible=false; FOVCircle.Thickness=2; FOVCircle.NumSides=80
    FOVCircle.Radius=FOVCircleSize; FOVCircle.Filled=false; FOVCircle.Color=FOVCircleColor; FOVCircle.Transparency=0.6
    FOVCircleInner = Drawing.new("Circle"); FOVCircleInner.Visible=false; FOVCircleInner.Thickness=1; FOVCircleInner.NumSides=80
    FOVCircleInner.Radius=FOVCircleSize-3; FOVCircleInner.Filled=false; FOVCircleInner.Color=FOVCircleColor; FOVCircleInner.Transparency=0.3
end
createFOVCircle()

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

-- AIMBOT SURVIVOR
local function getClosestGunTarget()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local c, s = nil, GunAim.FOV
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
                    local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                    if vis then
                        local d = (Vector2.new(pos.X,pos.Y)-center).Magnitude
                        if d<s then s=d; c=hrp end
                    end
                end
            end
        end
    end
    return c
end
RunService.RenderStepped:Connect(function()
    pcall(function()
        if not GunAim.Enabled or not GunAim.Holding then
            if TracerLine then TracerLine.Visible=false end
            return
        end
        local t = getClosestGunTarget()
        if not t then if TracerLine then TracerLine.Visible=false end; return end
        local pos = t.Position
        if GunAim.Predict then pos = pos + (t.AssemblyLinearVelocity * GunAim.PredictStrength) end
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, pos), GunAim.Strength)
    end)
end)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then GunAim.Holding=true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then GunAim.Holding=false end
end)

-- KILLER AIM (Lock saat Hit)
local function getClosestSurvivorForKiller()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local c, s = nil, KillerAim.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local isS = p.Team and (p.Team.Name=="Survivors" or p.Team.Name=="Survivor")
            if isS then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health>0 then
                    local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                    if vis then
                        local d = (Vector2.new(pos.X,pos.Y)-center).Magnitude
                        if d<s then s=d; c=hrp end
                    end
                end
            end
        end
    end
    return c
end
RunService.RenderStepped:Connect(function()
    pcall(function()
        if not KillerAim.Enabled then return end
        local mh = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        if not (KillerAim.Holding or mh) then return end
        local t = getClosestSurvivorForKiller(); if not t then return end
        local pos = t.Position
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, pos), KillerAim.Strength)
    end)
end)

-- SILENT AIM VEIL SPEAR
local SilentAimCircle = nil
if Drawing then
    SilentAimCircle = Drawing.new("Circle")
    SilentAimCircle.Visible=false; SilentAimCircle.Thickness=2; SilentAimCircle.NumSides=60
    SilentAimCircle.Radius=SilentAimSpear.FOV; SilentAimCircle.Filled=false
    SilentAimCircle.Color=Color3.fromRGB(150,0,255); SilentAimCircle.Transparency=0.6
end
local function getSilentAimTarget()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local c, s = nil, SilentAimSpear.FOV
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
                    local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                    if vis then
                        local d = (Vector2.new(pos.X,pos.Y)-center).Magnitude
                        if d<s then s=d; c=hrp end
                    end
                end
            end
        end
    end
    return c
end
RunService.RenderStepped:Connect(function()
    pcall(function()
        if SilentAimCircle then
            SilentAimCircle.Visible = SilentAimSpear.Enabled and SilentAimSpear.ShowFOV
            SilentAimCircle.Radius = SilentAimSpear.FOV
            SilentAimCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        end
        if not SilentAimSpear.Enabled or not SilentAimSpear.Holding then return end
        local t = getSilentAimTarget(); if not t then return end
        local pos = t.Position
        if SilentAimSpear.Prediction > 0 then pos = pos + (t.AssemblyLinearVelocity * SilentAimSpear.Prediction) end
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
createHitMarkerLines()
RunService.RenderStepped:Connect(function()
    pcall(function()
        if not Drawing then return end
        if not HitMarker.Enabled then
            for _, v in pairs(HitMarkerLines) do v.Visible=false end
            return
        end
        if not HitMarkerActive or tick() > HitMarkerEnd then
            for _, v in pairs(HitMarkerLines) do v.Visible=false end
            return
        end
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

-- AIMLOCK KILLER
if Drawing then
    AimlockKillerCircle = Drawing.new("Circle")
    AimlockKillerCircle.Visible=false; AimlockKillerCircle.Thickness=2; AimlockKillerCircle.NumSides=80
    AimlockKillerCircle.Radius=AimlockKiller.FOV; AimlockKillerCircle.Filled=false
    AimlockKillerCircle.Color=Color3.fromRGB(255,60,60); AimlockKillerCircle.Transparency=0.6
end
local function getAimlockKillerTarget()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local c, s = nil, AimlockKiller.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local isK = p.Team and p.Team.Name=="Killer"
            if isK then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local ap = p.Character:FindFirstChild(AimlockKiller.AimPart) or p.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health>0 and ap then
                    local pos, vis = Camera:WorldToViewportPoint(ap.Position)
                    if vis then
                        local d = (Vector2.new(pos.X,pos.Y)-center).Magnitude
                        if d<s then s=d; c=ap end
                    end
                end
            end
        end
    end
    return c
end
RunService.RenderStepped:Connect(function()
    pcall(function()
        if AimlockKillerCircle then
            AimlockKillerCircle.Visible = AimlockKiller.Enabled
            AimlockKillerCircle.Radius = AimlockKiller.FOV
            AimlockKillerCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        end
        if not AimlockKiller.Enabled then return end
        local t = getAimlockKillerTarget(); if not t then return end
        local pos = t.Position
        if AimlockKiller.Prediction then pos = pos + (t.AssemblyLinearVelocity * AimlockKiller.PredictStrength) end
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, pos), AimlockKiller.Strength)
    end)
end)

-- AUTO AIM LOCK SURVIVOR (buat killer)
if Drawing then
    AutoAimFOV = Drawing.new("Circle")
    AutoAimFOV.Visible=false; AutoAimFOV.Thickness=2; AutoAimFOV.NumSides=80
    AutoAimFOV.Filled=false; AutoAimFOV.Color=Color3.fromRGB(255,100,100); AutoAimFOV.Transparency=0.6
end
local function getAutoAimTarget()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local c, s = nil, AutoAimSurvivor.RadiusLock
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team then
            local isS = p.Team.Name=="Survivors" or p.Team.Name=="Survivor"
            if isS then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local ap = p.Character:FindFirstChild(AutoAimSurvivor.AimPart) or p.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health>0 and ap then
                    local pos, vis = Camera:WorldToViewportPoint(ap.Position)
                    if vis then
                        local d = (Vector2.new(pos.X,pos.Y)-center).Magnitude
                        if d<s then s=d; c=ap end
                    end
                end
            end
        end
    end
    return c
end
RunService.RenderStepped:Connect(function()
    pcall(function()
        if AutoAimFOV then
            AutoAimFOV.Visible = AutoAimSurvivor.Enabled and AutoAimSurvivor.ShowRadius
            AutoAimFOV.Radius = AutoAimSurvivor.RadiusLock
            AutoAimFOV.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        end
        if not AutoAimSurvivor.Enabled or not AutoAimSurvivor.Locked then return end
        local t = getAutoAimTarget(); if not t then return end
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), AutoAimSurvivor.Smoothness)
    end)
end)

-- ESP CIRCLE (Lock ke Tubuh — garis)
if Drawing then
    ESPCircleDrawing = Drawing.new("Circle")
    ESPCircleDrawing.Visible=false; ESPCircleDrawing.Thickness=2; ESPCircleDrawing.NumSides=60
    ESPCircleDrawing.Filled=false; ESPCircleDrawing.Color=ESPCircle.Color; ESPCircleDrawing.Transparency=1
    ESPCircleDrawing.Radius=ESPCircle.Radius
end
RunService.RenderStepped:Connect(function()
    pcall(function()
        if not ESPCircleDrawing then return end
        if not ESPCircle.Enabled then ESPCircleDrawing.Visible = false; return end
        local root = getRoot(); if not root then ESPCircleDrawing.Visible = false; return end
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        if not onScreen then ESPCircleDrawing.Visible = false; return end
        ESPCircleDrawing.Visible = true
        ESPCircleDrawing.Position = Vector2.new(pos.X, pos.Y)
        ESPCircleDrawing.Radius = ESPCircle.Radius
        ESPCircleDrawing.Color = ESPCircle.Color
    end)
end)

print("[TiarHub v21] Part 2/5 loaded.")-- KILLER HELPERS
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
    local c, s = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health>30 then
                local d = (hrp.Position-root.Position).Magnitude
                if d<s then s=d; c=p.Character end
            end
        end
    end
    return c
end
local function GetHook()
    local root = getRoot(); if not root then return nil end
    local bh, bs = nil, math.huge
    for hook in pairs(CachedObjects.Hooks) do
        local pos = GetPos(hook)
        if pos then
            local d = (pos-root.Position).Magnitude
            if d<bs and d<400 then bs=d; bh=hook end
        end
    end
    return bh
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
                    local th = KillerTarget:FindFirstChild("HumanoidRootPart")
                    if th then
                        local v = th.AssemblyLinearVelocity
                        local p = v*0.15
                        local tp = th.Position + p
                        local bh = th.CFrame.LookVector*-3
                        root.CFrame = CFrame.new(tp+bh, tp)
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
                            local mh = getHum()
                            if mh then
                                mh.AutoRotate = false
                                local lk = CFrame.new(root.Position, hrp.Position).LookVector
                                root.CFrame = CFrame.new(root.Position, root.Position+Vector3.new(lk.X,0,lk.Z))
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
                            local pp = hrp.Position + (vel*Killer.PredictStrength)
                            local mh = getHum()
                            if mh then mh.AutoRotate = false end
                            root.CFrame = CFrame.new(root.Position, pp)
                            pcall(function() AttackEvent:FireServer(false) end)
                        end
                    end
                end
            end
        end
        if ChaseDetector.Enabled then
            local now = tick()
            if now-ChaseDetector.LastNotify > ChaseDetector.Cooldown then
                local root = getRoot()
                if root then
                    local c, d = nil, math.huge
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            local isS = p.Team and (p.Team.Name=="Survivors" or p.Team.Name=="Survivor")
                            if isS then
                                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    local dd = (hrp.Position-root.Position).Magnitude
                                    if dd<d then d=dd; c=p end
                                end
                            end
                        end
                    end
                    if c and d<=ChaseDetector.Range then
                        ChaseDetector.LastNotify = now
                        Rayfield:Notify({ title="Chase Alert", content=string.format("Survivor %.0f stud!",d), duration=2 })
                    end
                end
            end
        end
    end)
end)

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
    local h0 = getHum(); if h0 then h0.AutoRotate = false end
    MoonwalkConnection = RunService.RenderStepped:Connect(function()
        if not Moonwalk.Enabled then return end
        local char = LocalPlayer.Character
        if not char or not char.Parent then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not (humanoid and hrp and Camera) then return end
        humanoid.AutoRotate = false
        if Moonwalk.UseSlow and humanoid.WalkSpeed ~= Moonwalk.SlowSpeed then humanoid.WalkSpeed = Moonwalk.SlowSpeed end
        local lk = Camera.CFrame.LookVector
        local fl = Vector3.new(lk.X, 0, lk.Z)
        if fl.Magnitude > 0 then
            fl = fl.Unit
            local bcf = CFrame.new(hrp.Position, hrp.Position+fl)
            local ang = math.sin(tick()*Moonwalk.SpamSpeed)*Moonwalk.Intensity
            hrp.CFrame = bcf*CFrame.Angles(0, math.rad(ang), 0)
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
local function playEmote(name) if EmoteRemote then pcall(function() EmoteRemote:FireServer(name) end) end end
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
        if v:IsA("ColorCorrectionEffect") and v.Name=="TiarCC" then ColorCorrection=v; return v end
    end
    ColorCorrection = Instance.new("ColorCorrectionEffect")
    ColorCorrection.Name="TiarCC"; ColorCorrection.Parent=Lighting; ColorCorrection.Enabled=true; return ColorCorrection
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
    local best, bd = nil, maxDist or math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            for _, target in ipairs(names) do
                if obj.Name==target or string.find(obj.Name, target, 1, true) then
                    local pos = GetPos(obj)
                    if pos then
                        local d = (pos-root.Position).Magnitude
                        if d<bd then bd=d; best=obj end
                    end
                    break
                end
            end
        end
    end
    return best, bd
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
            local kr, dist = GetNearestKiller()
            if not kr or dist > AutoEscape.DetectDistance then return end
            if tick() - AutoEscape.LastEscape < AutoEscape.Cooldown then return end
            local target = findNearestByNames({"Gate","Exit","ExitGate","fininshline","FinishLine"}, 1000)
            if not target then target = findNearestByNames({"Window"}, 500) end
            if not target then target = findNearestByNames({"Pallet","Palletwrong"}, 500) end
            if not target then target = findNearestByNames({"Generator"}, 500) end
            if target then AutoEscape.LastEscape = tick(); teleportTo(target) end
        end)
    end
end)

-- COPY AVATAR
local function saveOriginalAppearance()
    local char = LocalPlayer.Character; if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return false end
    local ok, desc = pcall(function() return hum:GetAppliedDescription() end)
    if ok and desc then AvatarCopier.OriginalDescription = desc; return true end
    return false
end
local function copyAvatar(username)
    if not username or username=="" then Rayfield:Notify({ title="Copy Avatar", content="Username kosong!" }); return false end
    saveOriginalAppearance()
    local ok, userId = pcall(function() return Players:GetUserIdFromNameAsync(username) end)
    if not ok or not userId then Rayfield:Notify({ title="Copy Avatar", content="User '"..username.."' tidak ditemukan!" }); return false end
    AvatarCopier.CurrentCopiedUserId = userId
    local char = LocalPlayer.Character; if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return false end
    task.spawn(function()
        local okD, desc = pcall(function() return Players:GetHumanoidDescriptionFromUserId(userId) end)
        if not okD or not desc then Rayfield:Notify({ title="Copy Avatar", content="Gagal ambil deskripsi!" }); return end
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then pcall(function() v:Destroy() end) end
        end
        task.wait(0.2)
        if AvatarCopier.BlockyBody then
            pcall(function()
                local bd = Instance.new("HumanoidDescription")
                bd.BodyTypeScale=1; bd.DepthScale=1; bd.HeadScale=1; bd.HeightScale=1; bd.ProportionScale=0; bd.WidthScale=1
                bd.HeadColor=desc.HeadColor; bd.TorsoColor=desc.TorsoColor
                bd.LeftArmColor=desc.LeftArmColor; bd.RightArmColor=desc.RightArmColor
                bd.LeftLegColor=desc.LeftLegColor; bd.RightLegColor=desc.RightLegColor
                hum:ApplyDescriptionClientServer(bd)
            end)
            task.wait(0.5)
        end
        pcall(function() hum:ApplyDescriptionClientServer(desc) end)
        task.wait(0.5)
        if desc.Face and tonumber(desc.Face) and tonumber(desc.Face)>0 then
            local head = char:FindFirstChild("Head")
            if head then
                local of = head:FindFirstChildOfClass("Decal"); if of then of:Destroy() end
                pcall(function() local f=Instance.new("Decal"); f.Name="face"; f.Face=Enum.NormalId.Front; f.Texture="rbxassetid://"..tostring(desc.Face); f.Parent=head end)
            end
        end
        task.wait(0.3)
        if desc.AccessoryBlob and desc.AccessoryBlob~="" then
            for aid in string.gmatch(desc.AccessoryBlob,"[^;]+") do
                local id = tonumber(aid)
                if id and id>0 then
                    local ok, a = pcall(function() return InsertService:LoadAsset(id) end)
                    if ok and a then
                        for _, v in pairs(a:GetChildren()) do
                            if v:IsA("Accessory") or v:IsA("Hat") then pcall(function() v:Clone().Parent=char end) end
                        end
                        a:Destroy()
                    end
                    task.wait(0.1)
                end
            end
        end
        Rayfield:Notify({ title="Copy Avatar", content="✓ Copy: "..username.." (FULL)" })
    end)
    return true
end
local function resetAvatar()
    if not AvatarCopier.OriginalDescription then return end
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then pcall(function() v:Destroy() end) end
    end
    task.wait(0.1)
    pcall(function() hum:ApplyDescriptionClientServer(AvatarCopier.OriginalDescription) end)
    AvatarCopier.CurrentCopiedUserId = nil
    Rayfield:Notify({ title="Reset Avatar", content="Original balik!" })
end
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    if AvatarCopier.CurrentCopiedUserId then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local okD, desc = pcall(function() return Players:GetHumanoidDescriptionFromUserId(AvatarCopier.CurrentCopiedUserId) end)
            if okD and desc then pcall(function() hum:ApplyDescriptionClientServer(desc) end) end
        end
    end
end)

print("[TiarHub v21] Part 3/5 loaded.")-- CAMERA ZOOM + FOV
local function applyUnlimitedZoom()
    if CameraZoom.UnlimitedZoom then
        LocalPlayer.CameraMaxZoomDistance = CameraZoom.MaxDistance
        LocalPlayer.CameraMinZoomDistance = CameraZoom.MinDistance
    else
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end
end
local function applyCameraFOV()
    local cam = workspace.CurrentCamera
    if not cam then return end
    if CameraZoom.FOVEnabled then
        cam.FieldOfView = CameraZoom.FOV
    else
        cam.FieldOfView = CameraZoom.DefaultFOV
    end
end
RunService.RenderStepped:Connect(function()
    if CameraZoom.FOVEnabled then
        local cam = workspace.CurrentCamera
        if cam and cam.FieldOfView ~= CameraZoom.FOV then
            cam.FieldOfView = CameraZoom.FOV
        end
    end
end)

-- JERK TOOL
local function createJerkTool()
    if currentJerkTool then currentJerkTool:Destroy() end
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    local backpack = LocalPlayer:FindFirstChildWhichIsA("Backpack")
    if not humanoid or not backpack then return end

    local tool = Instance.new("Tool")
    tool.Name = "Jerk Off"
    tool.ToolTip = "in the stripped club. straight up 'jorking it'. and by 'it', haha, well. let's just say. My peanits."
    tool.RequiresHandle = false
    tool.Parent = backpack
    currentJerkTool = tool

    local jorkin = false
    local track = nil

    local function stopTomfoolery()
        jorkin = false
        if track then track:Stop(); track = nil end
    end

    tool.Equipped:Connect(function() jorkin = true end)
    tool.Unequipped:Connect(stopTomfoolery)
    humanoid.Died:Connect(stopTomfoolery)

    task.spawn(function()
        while task.wait() do
            if not JerkTool.Enabled or not jorkin then
                if track then track:Stop() end
                continue
            end
            local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
            if not track then
                local anim = Instance.new("Animation")
                anim.AnimationId = not isR15 and "rbxassetid://72042024" or "rbxassetid://698251653"
                track = humanoid:LoadAnimation(anim)
            end
            track:Play()
            track:AdjustSpeed(isR15 and 0.7 or 0.65)
            track.TimePosition = 0.6
            task.wait(0.1)
            while track and track.TimePosition < (not isR15 and 0.65 or 0.7) do
                task.wait(0.1)
            end
            if track then track:Stop() end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if JerkTool.Enabled then createJerkTool() end
end)

-- WATERMARK BAGUS (Gradient + FPS/Ping)
local BeautifulWM = Instance.new("ScreenGui")
BeautifulWM.Name = "TiarWM"
BeautifulWM.ResetOnSpawn = false
BeautifulWM.IgnoreGuiInset = true
BeautifulWM.Parent = PlayerGui

local wmFrame = Instance.new("Frame")
wmFrame.Name = "WM"
wmFrame.Size = UDim2.new(0, 240, 0, 40)
wmFrame.Position = UDim2.new(0.5, -120, 0, 10)
wmFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
wmFrame.BackgroundTransparency = 0.15
wmFrame.BorderSizePixel = 0
wmFrame.Parent = BeautifulWM

local wmCorner = Instance.new("UICorner")
wmCorner.CornerRadius = UDim.new(0, 12)
wmCorner.Parent = wmFrame

local wmStroke = Instance.new("UIStroke")
wmStroke.Color = Color3.fromRGB(90, 120, 210)
wmStroke.Thickness = 2
wmStroke.Transparency = 0.3
wmStroke.Parent = wmFrame

local wmLabel = Instance.new("TextLabel")
wmLabel.Size = UDim2.new(1, 0, 1, 0)
wmLabel.BackgroundTransparency = 1
wmLabel.Text = "⚡ TiarHub ⚡ | FPS: 60 | PING: 30"
wmLabel.TextColor3 = Color3.fromRGB(220, 230, 255)
wmLabel.TextStrokeTransparency = 0.5
wmLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
wmLabel.Font = Enum.Font.GothamBold
wmLabel.TextSize = 13
wmLabel.Parent = wmFrame

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            wmLabel.Text = string.format("⚡ TiarHub ⚡ | FPS: %d | PING: %d", FPS, ping)
        end)
    end
end)

-- Efek glow gradient watermark
task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            local hue = (tick() * 0.1) % 1
            wmStroke.Color = Color3.fromHSV(hue, 0.6, 1)
        end)
    end
end)

print("[TiarHub v21] Part 4/5 loaded.")-- ============ UI TABS ============
local ESPTab = Window:CreateTab({ name="ESP", icon=0 })
ESPTab:CreateSection("Player ESP")
ESPTab:CreateToggle({ name="ESP Survivor", currentValue=false, flag="esp_surv", callback=function(v) ESP.Survivor=v end })
ESPTab:CreateColorPicker({ name="Survivor Color", color=ESP.SurvivorColor, flag="esp_surv_c", callback=function(c) ESP.SurvivorColor=c end })
ESPTab:CreateToggle({ name="ESP Killer", currentValue=false, flag="esp_kill", callback=function(v) ESP.Killer=v end })
ESPTab:CreateColorPicker({ name="Killer Color", color=ESP.KillerColor, flag="esp_kill_c", callback=function(c) ESP.KillerColor=c end })
ESPTab:CreateSection("Map ESP")
ESPTab:CreateToggle({ name="ESP Generator", currentValue=false, flag="esp_gen", callback=function(v) ESP.Generator=v end })
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

-- SURVIVOR TAB
local SurvivorTab = Window:CreateTab({ name="Survivor", icon=0 })
SurvivorTab:CreateSection("Auto Parry (Semua Arah)")
SurvivorTab:CreateToggle({ name="Auto Parry", currentValue=false, flag="parry_on", callback=function(v) Auto.Parry=v end })
SurvivorTab:CreateSlider({ name="Parry Distance", range={5,50}, increment=1, suffix="stud", currentValue=12, flag="parry_d", callback=function(v) Auto.ParryDistance=v end })
SurvivorTab:CreateParagraph({ title="Info", content="Auto Parry work di semua arah (depan, samping, belakang)." })
SurvivorTab:CreateSection("Auto Skill Check")
SurvivorTab:CreateToggle({ name="Auto Skill Check", currentValue=false, flag="skillcheck", callback=function(v) Auto.SkillCheck=v; if v then startSkillCheck() end end })
SurvivorTab:CreateDropdown({ name="Skill Check Mode", options={"Instant","Perfect"}, currentOption="Perfect", flag="skill_mode", callback=function(opt) SkillCheckMode=opt end })
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
SurvivorTab:CreateSection("🌙 Tombol Floating MW (Moonwalk)")
SurvivorTab:CreateToggle({ name="Show MW Button (Moonwalk)", currentValue=false, flag="show_mw", callback=function(v)
    if MWButton then MWButton.Visible = v end
end })
SurvivorTab:CreateParagraph({ title="Info", content="Toggle ON → tombol MW muncul di layar. OFF → hilang." })

-- AIMBOT TAB
local AimTab = Window:CreateTab({ name="Aimbot", icon=0 })
AimTab:CreateSection("Aimbot Survivor (buat nembak)")
AimTab:CreateToggle({ name="Aimbot (Hold RMB)", currentValue=false, flag="gun_on", callback=function(v) GunAim.Enabled=v end })
AimTab:CreateToggle({ name="Show FOV Circle", currentValue=false, flag="gun_fovc", callback=function(v) FOVCircleVisible=v; if v and not FOVCircle then createFOVCircle() end end })
AimTab:CreateSlider({ name="FOV Circle Size", range={50,1000}, increment=10, suffix="px", currentValue=250, flag="gun_fovsz", callback=function(v) FOVCircleSize=v end })
AimTab:CreateColorPicker({ name="FOV Circle Color", color=FOVCircleColor, flag="gun_fovcl", callback=function(c) FOVCircleColor=c end })
AimTab:CreateDropdown({ name="Aimbot Target", options={"Killer","Survivor","Both"}, currentOption="Killer", flag="gun_tgt", callback=function(opt) GunAim.TargetMode=opt end })
AimTab:CreateDropdown({ name="Aim Part", options={"Head","HumanoidRootPart","Torso"}, currentOption="HumanoidRootPart", flag="gun_part", callback=function(opt) GunAim.AimPart=opt end })
AimTab:CreateSlider({ name="Aimbot FOV", range={50,1000}, increment=10, currentValue=250, flag="gun_fov", callback=function(v) GunAim.FOV=v end })
AimTab:CreateSlider({ name="Smoothness", range={0.1,1}, increment=0.05, currentValue=1, flag="gun_sm", callback=function(v) GunAim.Strength=v end })
AimTab:CreateSlider({ name="Prediction", range={0,1}, increment=0.01, currentValue=0.12, flag="gun_pr", callback=function(v) GunAim.PredictStrength=v end })

AimTab:CreateSection("🎯 Auto Aim Lock Survivor")
AimTab:CreateToggle({ name="Enable Auto Aim Lock", currentValue=false, flag="aal_on", callback=function(v) AutoAimSurvivor.Enabled=v end })
AimTab:CreateToggle({ name="Lock Radius (auto snap)", currentValue=false, flag="aal_lock", callback=function(v) AutoAimSurvivor.Locked=v end })
AimTab:CreateSlider({ name="Radius Lock", range={50,1000}, increment=10, suffix="px", currentValue=250, flag="aal_rad", callback=function(v) AutoAimSurvivor.RadiusLock=v end })
AimTab:CreateDropdown({ name="Aim Part", options={"Head","UpperTorso","HumanoidRootPart"}, currentOption="Head", flag="aal_part", callback=function(opt) AutoAimSurvivor.AimPart=opt end })
AimTab:CreateSlider({ name="Smoothness", range={0.05,1}, increment=0.05, currentValue=0.4, flag="aal_sm", callback=function(v) AutoAimSurvivor.Smoothness=v end })
AimTab:CreateToggle({ name="Show Radius Circle", currentValue=true, flag="aal_show", callback=function(v) AutoAimSurvivor.ShowRadius=v end })

AimTab:CreateSection("🗡️ Silent Aim Veil Spear")
AimTab:CreateToggle({ name="Enable Silent Aim Spear", currentValue=false, flag="silent_on", callback=function(v) SilentAimSpear.Enabled=v end })
AimTab:CreateToggle({ name="Show FOV", currentValue=false, flag="silent_fov", callback=function(v) SilentAimSpear.ShowFOV=v end })
AimTab:CreateDropdown({ name="Silent Target", options={"Killer","Survivor","Both"}, currentOption="Killer", flag="silent_tgt", callback=function(opt) SilentAimSpear.TargetMode=opt end })
AimTab:CreateSlider({ name="Silent FOV", range={50,1000}, increment=10, currentValue=250, flag="silent_fovv", callback=function(v) SilentAimSpear.FOV=v end })

AimTab:CreateSection("🎯 Killer Aim (Lock saat Hit)")
AimTab:CreateToggle({ name="Killer Aim Lock", currentValue=false, flag="kaim_on", callback=function(v) KillerAim.Enabled=v end })
AimTab:CreateSlider({ name="Killer Aim FOV", range={50,500}, increment=10, currentValue=200, flag="kaim_fov", callback=function(v) KillerAim.FOV=v end })

AimTab:CreateSection("🔒 Tombol Floating AIM")
AimTab:CreateToggle({ name="Show AIM Button (Auto Aim)", currentValue=false, flag="show_aim", callback=function(v)
    if AIMButton then AIMButton.Visible = v end
end })

-- AIMLOCK TAB
local AimlockTab = Window:CreateTab({ name="Aimlock", icon=0 })
AimlockTab:CreateSection("🎯 Aimlock Killer")
AimlockTab:CreateToggle({ name="Enable Aimlock Killer", currentValue=false, flag="ak_on", callback=function(v) AimlockKiller.Enabled=v end })
AimlockTab:CreateDropdown({ name="Aim Part", options={"Head","UpperTorso","HumanoidRootPart"}, currentOption="Head", flag="ak_part", callback=function(opt) AimlockKiller.AimPart=opt end })
AimlockTab:CreateSlider({ name="FOV Radius", range={50,1000}, increment=10, suffix="px", currentValue=200, flag="ak_fovsz", callback=function(v) AimlockKiller.FOV=v end })
AimlockTab:CreateSlider({ name="Smoothness", range={0.05,1}, increment=0.05, currentValue=0.35, flag="ak_sm", callback=function(v) AimlockKiller.Strength=v end })
AimlockTab:CreateSlider({ name="Prediction", range={0,1}, increment=0.01, currentValue=0.12, flag="ak_pred", callback=function(v) AimlockKiller.PredictStrength=v end })

AimlockTab:CreateSection("⚪ ESP Circle (Lock ke Tubuh)")
AimlockTab:CreateToggle({ name="Enable ESP Circle", currentValue=false, flag="ec_on", callback=function(v) ESPCircle.Enabled=v end })
AimlockTab:CreateSlider({ name="Circle Radius", range={2,50}, increment=1, suffix="px", currentValue=5, flag="ec_r", callback=function(v) ESPCircle.Radius=v end })
AimlockTab:CreateColorPicker({ name="Circle Color", color=ESPCircle.Color, flag="ec_c", callback=function(c) ESPCircle.Color=c end })

AimlockTab:CreateSection("🔒 Tombol Floating AK")
AimlockTab:CreateToggle({ name="Show AK Button (Aimlock)", currentValue=false, flag="show_ak", callback=function(v)
    if AKButton then AKButton.Visible = v end
end })

-- KILLER TAB
local KillerTab = Window:CreateTab({ name="Killer", icon=0 })
KillerTab:CreateSection("Attack")
KillerTab:CreateToggle({ name="Auto Attack", currentValue=false, flag="k_attack", callback=function(v) Killer.AutoAttack=v end })
KillerTab:CreateToggle({ name="Auto Kill All", currentValue=false, flag="k_killall", callback=function(v) Killer.KillAll=v end })
KillerTab:CreateToggle({ name="Prediction Attack", currentValue=false, flag="k_predict", callback=function(v) Killer.PredictionAttack=v end })
KillerTab:CreateSection("Carry & Hook")
KillerTab:CreateToggle({ name="Auto Carry Downed", currentValue=false, flag="k_carry", callback=function(v) Killer.AutoCarry=v end })
KillerTab:CreateToggle({ name="Auto Hook After Carry", currentValue=false, flag="k_hook", callback=function(v) Killer.AutoHook=v end })
KillerTab:CreateToggle({ name="Auto Hook All Downed", currentValue=false, flag="k_hookall", callback=function(v) Killer.AutoHookAllDowned=v end })
KillerTab:CreateSection("Auto Sprint")
KillerTab:CreateToggle({ name="Auto Sprint", currentValue=false, flag="k_sprint", callback=function(v) Killer.AutoSprint=v end })
KillerTab:CreateSlider({ name="Sprint Speed", range={16,100}, increment=1, currentValue=30, flag="k_sprint_v", callback=function(v) Killer.AutoSprintValue=v end })
KillerTab:CreateSection("Stalk")
KillerTab:CreateToggle({ name="Auto Stalk", currentValue=false, flag="k_stalk", callback=function(v) Killer.AutoStalk=v; if v then startAutoStalk() else stopAutoStalk() end end })
KillerTab:CreateSlider({ name="Stalk Range", range={50,500}, increment=10, suffix="stud", currentValue=150, flag="k_stalk_r", callback=function(v) Killer.StalkRange=v end })
KillerTab:CreateSection("Masked Power")
KillerTab:CreateDropdown({ name="Select Power", options=MaskedPowers, currentOption="Cobra", flag="k_masked", callback=function(opt) Masked.CurrentPower=opt end })
KillerTab:CreateButton({ name="⚡ Activate Power", callback=activateMasked })
KillerTab:CreateButton({ name="🛑 Deactivate Power", callback=deactivateMasked })

-- TELEPORT TAB
local TeleportTab = Window:CreateTab({ name="Teleport", icon=0 })
TeleportTab:CreateSection("Teleport Cepat")
TeleportTab:CreateButton({ name="📍 Ke Generator", callback=function() if teleportToGenerator() then Rayfield:Notify({ title="TP", content="Generator ✓" }) else Rayfield:Notify({ title="TP", content="Gak ketemu" }) end end })
TeleportTab:CreateButton({ name="🚪 Ke Gate", callback=function() if teleportToGate() then Rayfield:Notify({ title="TP", content="Gate ✓" }) else Rayfield:Notify({ title="TP", content="Gak ketemu" }) end end })
TeleportTab:CreateButton({ name="🪟 Ke Window", callback=function() if teleportToWindow() then Rayfield:Notify({ title="TP", content="Window ✓" }) else Rayfield:Notify({ title="TP", content="Gak ketemu" }) end end })
TeleportTab:CreateButton({ name="🟨 Ke Pallet", callback=function() if teleportToPallet() then Rayfield:Notify({ title="TP", content="Pallet ✓" }) else Rayfield:Notify({ title="TP", content="Gak ketemu" }) end end })
TeleportTab:CreateButton({ name="🪝 Ke Hook", callback=function() if teleportToHook() then Rayfield:Notify({ title="TP", content="Hook ✓" }) else Rayfield:Notify({ title="TP", content="Gak ketemu" }) end end })
TeleportTab:CreateSection("Auto Escape")
TeleportTab:CreateToggle({ name="Auto Escape", currentValue=false, flag="auto_esc", callback=function(v) AutoEscape.Enabled=v end })
TeleportTab:CreateSlider({ name="Detect Distance", range={10,200}, increment=5, suffix="stud", currentValue=40, flag="esc_d", callback=function(v) AutoEscape.DetectDistance=v end })

-- AVATAR TAB
local AvatarTab = Window:CreateTab({ name="Avatar", icon=0 })
AvatarTab:CreateSection("Copy Avatar Full")
AvatarTab:CreateInput({ name="Target Username", currentValue="", placeholder="Ketik username", flag="av_user", callback=function(v) AvatarCopier.TargetUsername=v end })
AvatarTab:CreateButton({ name="🎭 Copy Avatar (FULL)", callback=function() copyAvatar(AvatarCopier.TargetUsername) end })
AvatarTab:CreateButton({ name="🔄 Reset to Original", callback=function() resetAvatar() end })
AvatarTab:CreateButton({ name="💾 Save Current as Original", callback=function()
    if saveOriginalAppearance() then Rayfield:Notify({ title="Save", content="Original disimpan!" }) else Rayfield:Notify({ title="Save", content="Gagal!" }) end
end })
AvatarTab:CreateToggle({ name="Blocky Body", currentValue=true, flag="av_blocky", callback=function(v) AvatarCopier.BlockyBody=v end })

-- CAMERA ZOOM TAB
local ZoomTab = Window:CreateTab({ name="Camera Zoom", icon=0 })
ZoomTab:CreateSection("Zoom Out")
ZoomTab:CreateToggle({ name="Unlimited Zoom Out", currentValue=false, flag="cz_unlim", callback=function(v) CameraZoom.UnlimitedZoom=v; applyUnlimitedZoom() end })
ZoomTab:CreateSlider({ name="Max Zoom Distance", range={100,5000}, increment=100, suffix="stud", currentValue=1000, flag="cz_max", callback=function(v) CameraZoom.MaxDistance=v; if CameraZoom.UnlimitedZoom then applyUnlimitedZoom() end end })
ZoomTab:CreateSection("FOV")
ZoomTab:CreateDropdown({ name="FOV Preset", options={"70","90","120"}, currentOption="90", flag="cz_fovp", callback=function(opt)
    CameraZoom.FOV = tonumber(opt); CameraZoom.FOVEnabled = true; applyCameraFOV()
    Rayfield:Notify({ title="FOV", content="Set ke "..opt })
end })
ZoomTab:CreateToggle({ name="Enable Custom FOV", currentValue=false, flag="cz_fovon", callback=function(v) CameraZoom.FOVEnabled=v; applyCameraFOV() end })
ZoomTab:CreateSlider({ name="FOV Value", range={40,150}, increment=5, currentValue=90, flag="cz_fov", callback=function(v) CameraZoom.FOV=v; if CameraZoom.FOVEnabled then applyCameraFOV() end end })
ZoomTab:CreateButton({ name="🔄 Reset Zoom + FOV", callback=function()
    CameraZoom.UnlimitedZoom=false; CameraZoom.FOVEnabled=false
    applyUnlimitedZoom(); applyCameraFOV()
    Rayfield:Notify({ title="Reset", content="Zoom + FOV normal" })
end })

-- MISC TAB
local MiscTab = Window:CreateTab({ name="Misc", icon=0 })
MiscTab:CreateSection("Walk Speed")
MiscTab:CreateToggle({ name="Enable Walk Speed", currentValue=false, flag="m_ws", callback=function(v) Movement.WalkSpeedEnabled=v; if v then applyWalkSpeed() else local hum=getHum(); if hum then hum.WalkSpeed=16 end end end })
MiscTab:CreateSlider({ name="Walk Speed Value", range={16,100}, increment=0.5, currentValue=17.6, flag="m_ws_v", callback=function(v) Movement.WalkSpeedValue=v end })
MiscTab:CreateSection("No Clip")
MiscTab:CreateToggle({ name="No Clip", currentValue=false, flag="m_noclip", callback=function(v) toggleNoClip(v) end })
MiscTab:CreateSection("🌙 Moonwalk")
MiscTab:CreateToggle({ name="Moonwalk", currentValue=false, flag="m_moon", callback=function(v) Moonwalk.Enabled=v; if v then startMoonwalk(); applyMoonwalkFOV() else stopMoonwalk() end end })
MiscTab:CreateDropdown({ name="Moonwalk Mode", options={"Default","Camera"}, currentOption="Default", flag="m_moon_mode", callback=function(opt) Moonwalk.Mode=opt end })
MiscTab:CreateSlider({ name="Spam Speed", range={1,50}, increment=1, currentValue=30, flag="m_moon_spam", callback=function(v) Moonwalk.SpamSpeed=v end })
MiscTab:CreateSlider({ name="Intensity", range={1,50}, increment=1, currentValue=35, flag="m_moon_int", callback=function(v) Moonwalk.Intensity=v end })
MiscTab:CreateSection("🎭 Jerk Tool")
MiscTab:CreateToggle({ name="Enable Jerk Tool", currentValue=false, flag="jerk_on", callback=function(v)
    JerkTool.Enabled = v
    if v then createJerkTool(); Rayfield:Notify({ title="Jerk Tool", content="Cek backpack!" })
    else if currentJerkTool then currentJerkTool:Destroy(); currentJerkTool=nil end end
end })

-- VISUAL TAB
local VisualTab = Window:CreateTab({ name="Visual", icon=0 })
VisualTab:CreateSection("Lighting")
VisualTab:CreateToggle({ name="Fullbright", currentValue=false, flag="v_fb", callback=function(v) Visual.Fullbright=v; applyVisual(true) end })
VisualTab:CreateToggle({ name="No Fog", currentValue=false, flag="v_nofog", callback=function(v) Visual.NoFog=v; applyVisual(true) end })
VisualTab:CreateToggle({ name="No Shadow", currentValue=false, flag="v_noshadow", callback=function(v) Visual.NoShadow=v; applyVisual(true) end })
VisualTab:CreateSection("Screen Effects")
VisualTab:CreateToggle({ name="No Bloom", currentValue=false, flag="v_nobloom", callback=function(v) Visual.NoBloom=v; toggleScreenEffects() end })
VisualTab:CreateToggle({ name="No Blur", currentValue=false, flag="v_noblur", callback=function(v) Visual.NoBlur=v; toggleScreenEffects() end })
VisualTab:CreateToggle({ name="No Blood", currentValue=false, flag="v_noblood", callback=function(v) Visual.NoBlood=v; removeBlood() end })
VisualTab:CreateSection("Color Correction")
VisualTab:CreateToggle({ name="Enable CC", currentValue=false, flag="v_cc", callback=function(v) Visual.ColorCorrection=v; applyColorCorrection() end })
VisualTab:CreateSlider({ name="Saturation", range={-1,1}, increment=0.05, currentValue=0, flag="v_sat", callback=function(v) Visual.Saturation=v; applyColorCorrection() end })
VisualTab:CreateSlider({ name="Brightness", range={-1,1}, increment=0.05, currentValue=0, flag="v_bright", callback=function(v) Visual.Brightness=v; applyColorCorrection() end })
VisualTab:CreateSlider({ name="Contrast", range={-1,1}, increment=0.05, currentValue=0, flag="v_contrast", callback=function(v) Visual.Contrast=v; applyColorCorrection() end })
VisualTab:CreateButton({ name="🔄 Reset Color", callback=function() resetColorCorrection() end })

-- CROSSHAIR TAB
local CrosshairTab = Window:CreateTab({ name="Crosshair", icon=0 })
CrosshairTab:CreateToggle({ name="Enable Crosshair", currentValue=false, flag="ch_on", callback=function(v) Crosshair.Enabled=v end })
CrosshairTab:CreateColorPicker({ name="Color", color=Crosshair.Color, flag="ch_c", callback=function(c) Crosshair.Color=c end })
CrosshairTab:CreateSlider({ name="Size", range={2,30}, increment=1, suffix="px", currentValue=8, flag="ch_s", callback=function(v) Crosshair.Size=v end })
CrosshairTab:CreateSlider({ name="Thickness", range={1,5}, increment=1, suffix="px", currentValue=2, flag="ch_t", callback=function(v) Crosshair.Thickness=v end })

-- UI SETTINGS TAB
local UISettingsTab = Window:CreateTab({ name="UI Settings", icon=0 })
UISettingsTab:CreateSection("Sound Feedback")
UISettingsTab:CreateToggle({ name="Enable Click Sound", currentValue=true, flag="sf_on", callback=function(v) SoundFeedback.Enabled=v end })
UISettingsTab:CreateDropdown({ name="Sound Type", options={"Click","Switch","Beep","Bell","Whoosh"}, currentOption="Click", flag="sf_type", callback=function(opt) SoundFeedback.CurrentSound=opt; playClickSound() end })
UISettingsTab:CreateSlider({ name="Volume", range={0,1}, increment=0.05, currentValue=0.5, flag="sf_vol", callback=function(v) SoundFeedback.Volume=v; if SoundInstance then SoundInstance.Volume=v end end })
UISettingsTab:CreateSection("Config Manual (Auto-Save OFF)")
UISettingsTab:CreateButton({ name="💾 Save Config", callback=function() Rayfield:SaveConfiguration(); Rayfield:Notify({ title="Save", content="Config disimpan!" }) end })
UISettingsTab:CreateButton({ name="🔄 Load Config", callback=function() Rayfield:LoadConfiguration(); Rayfield:Notify({ title="Load", content="Config diload!" }) end })

-- QUICK ACTIONS TAB
local QuickTab = Window:CreateTab({ name="Quick Actions", icon=0 })
QuickTab:CreateSection("⚡ Mode Preset")
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
QuickTab:CreateButton({ name="🛑 Panic Mode (OFF semua)", callback=function()
    Auto.Parry=false; Auto.SkillCheck=false; Auto.Wiggle=false
    ESP.Survivor=false; ESP.Killer=false; ESP.Generator=false; ESP.Hook=false; ESP.Pallet=false; ESP.Window=false; ESP.SCP=false
    Killer.AutoAttack=false; Killer.AutoCarry=false; Killer.AutoHook=false; Killer.KillAll=false
    Movement.WalkSpeedEnabled=false; Movement.NoClip=false; toggleNoClip(false)
    AimlockKiller.Enabled=false; AutoAimSurvivor.Enabled=false; AutoAimSurvivor.Locked=false
    Moonwalk.Enabled=false; stopMoonwalk()
    Rayfield:Notify({ title="Mode", content="Panic! Semua OFF.", duration=3 })
end })

-- ============ TOMBOL FLOATING (MW + AIM + AK) ============
local FloatGui = Instance.new("ScreenGui")
FloatGui.Name = "TiarFloat"
FloatGui.ResetOnSpawn = false
FloatGui.IgnoreGuiInset = true
FloatGui.Parent = PlayerGui

local FloatPos = {
    MW = UDim2.new(0.05, 0, 0.45, 0),
    AIM = UDim2.new(0.05, 0, 0.55, 0),
    AK = UDim2.new(0.05, 0, 0.65, 0)
}
pcall(function()
    if isfile and isfile("TiarFloat.json") then
        local d = HttpService:JSONDecode(readfile("TiarFloat.json"))
        if d.MW then FloatPos.MW = UDim2.new(d.MW[1],d.MW[2],d.MW[3],d.MW[4]) end
        if d.AIM then FloatPos.AIM = UDim2.new(d.AIM[1],d.AIM[2],d.AIM[3],d.AIM[4]) end
        if d.AK then FloatPos.AK = UDim2.new(d.AK[1],d.AK[2],d.AK[3],d.AK[4]) end
    end
end)
local function saveFloatPos()
    pcall(function()
        if writefile then
            writefile("TiarFloat.json", HttpService:JSONEncode({
                MW={FloatPos.MW.X.Scale,FloatPos.MW.X.Offset,FloatPos.MW.Y.Scale,FloatPos.MW.Y.Offset},
                AIM={FloatPos.AIM.X.Scale,FloatPos.AIM.X.Offset,FloatPos.AIM.Y.Scale,FloatPos.AIM.Y.Offset},
                AK={FloatPos.AK.X.Scale,FloatPos.AK.X.Offset,FloatPos.AK.Y.Scale,FloatPos.AK.Y.Offset}
            }))
        end
    end)
end
local function makeDraggable(frame, which)
    local dragging=false; local ds, sp
    frame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true; ds=input.Position; sp=frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
            local delta = input.Position - ds
            frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset+delta.X, sp.Y.Scale, sp.Y.Offset+delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            if dragging then
                dragging=false
                if which=="MW" then FloatPos.MW=frame.Position
                elseif which=="AIM" then FloatPos.AIM=frame.Position
                elseif which=="AK" then FloatPos.AK=frame.Position end
                saveFloatPos()
            end
        end
    end)
end
local function makeBtn(name,text,pos,color,which,onClick)
    local btn = Instance.new("TextButton")
    btn.Name=name; btn.Text=text; btn.Size=UDim2.fromOffset(55,55); btn.Position=pos
    btn.BackgroundColor3=Color3.fromRGB(18,18,22); btn.BackgroundTransparency=0.1
    btn.TextColor3=color; btn.Font=Enum.Font.GothamBlack; btn.TextSize=16
    btn.AutoButtonColor=false; btn.Parent=FloatGui
    btn.Visible = false
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

local MWButton = makeBtn("MWButton","MW",FloatPos.MW,Color3.fromRGB(170,0,255),"MW",function(btn,stroke)
    Moonwalk.Enabled = not Moonwalk.Enabled
    if Moonwalk.Enabled then
        stroke.Color=Color3.fromRGB(0,255,100); btn.TextColor3=Color3.fromRGB(0,255,100)
        startMoonwalk(); applyMoonwalkFOV()
    else
        stroke.Color=Color3.fromRGB(170,0,255); btn.TextColor3=Color3.fromRGB(170,0,255)
        stopMoonwalk()
    end
end)

local AIMButton = makeBtn("AIMButton","AIM",FloatPos.AIM,Color3.fromRGB(255,100,100),"AIM",function(btn,stroke)
    AutoAimSurvivor.Enabled = not AutoAimSurvivor.Enabled
    AutoAimSurvivor.Locked = AutoAimSurvivor.Enabled
    if AutoAimSurvivor.Enabled then
        stroke.Color=Color3.fromRGB(0,255,100); btn.TextColor3=Color3.fromRGB(0,255,100)
    else
        stroke.Color=Color3.fromRGB(255,100,100); btn.TextColor3=Color3.fromRGB(255,100,100)
    end
end)

local AKButton = makeBtn("AKButton","AK",FloatPos.AK,Color3.fromRGB(255,60,60),"AK",function(btn,stroke)
    AimlockKiller.Enabled = not AimlockKiller.Enabled
    if AimlockKiller.Enabled then
        stroke.Color=Color3.fromRGB(0,255,100); btn.TextColor3=Color3.fromRGB(0,255,100)
    else
        stroke.Color=Color3.fromRGB(255,60,60); btn.TextColor3=Color3.fromRGB(255,60,60)
    end
end)

-- AUTO RESPAWN
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    pcall(function()
        applyVisual(true); toggleScreenEffects(); applyColorCorrection()
        if Moonwalk.Enabled then task.wait(0.5); startMoonwalk(); applyMoonwalkFOV() end
    end)
end)

-- NOTIFIKASI
task.wait(1)
Rayfield:Notify({ title="⚡ TiarHub v21 ⚡", content="Script loaded! Semua fitur siap.", duration=8 })
task.wait(2)
Rayfield:Notify({ title="💡 Tombol Floating", content="Buka Survivor/Aimbot/Aimlock → toggle Show Button", duration=8 })

print("============================================")
print("  ⚡ TIARHUB v21 FINAL - LOADED ⚡")
print("  ==========================================")
print("  [✓] ESP + Killer Warning")
print("  [✓] Auto Parry (Semua Arah)")
print("  [✓] Auto Skill Check / Wiggle / Flee")
print("  [✓] Fast Vault + Dodge Abyss")
print("  [✓] Aimbot + Silent Aim + Killer Aim")
print("  [✓] Auto Aim Lock Survivor + Radius")
print("  [✓] Aimlock Killer")
print("  [✓] ESP Circle (Lock Tubuh)")
print("  [✓] Killer System + Stalk")
print("  [✓] Movement + Moonwalk + NoClip")
print("  [✓] Copy Avatar Full")
print("  [✓] Teleport + Auto Escape")
print("  [✓] Camera Zoom + FOV (70/90/120)")
print("  [✓] Jerk Tool + Masked Power")
print("  [✓] Visual + Color Correction")
print("  [✓] Crosshair + Sound")
print("  [✓] Tombol Floating MW/AIM/AK")
print("  [✓] Watermark Gradient")
print("  [✓] Quick Actions (Preset Mode)")
print("  [✓] Auto-Save OFF")
print("  ==========================================")
print("  🎮 Violence District | TiarHub v21")
print("============================================")
