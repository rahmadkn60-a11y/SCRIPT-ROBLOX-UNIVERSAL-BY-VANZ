local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Lighting = game:GetService("Lighting");
local Workspace = game:GetService("Workspace");
local CoreGui = game:GetService("CoreGui");
local HttpService = game:GetService("HttpService");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local StarterGui = game:GetService("StarterGui");
local Terrain = Workspace:FindFirstChildOfClass("Terrain");
local LP = Players.LocalPlayer;

local T = {
    bg = Color3.fromRGB(4, 2, 6);
    panel = Color3.fromRGB(14, 8, 18);
    row = Color3.fromRGB(22, 14, 28);
    accent = Color3.fromRGB(255, 20, 60);
    text = Color3.fromRGB(245, 235, 250);
    dim = Color3.fromRGB(120, 100, 135);
    on = Color3.fromRGB(255, 0, 40);
    off = Color3.fromRGB(45, 35, 55);
    warn = Color3.fromRGB(255, 180, 0);
};

local function guid()
    return HttpService:GenerateGUID(false):gsub("-", "");
end;

local function clearOld()
    local names = { "vanzFPSUltra", "vanzFPSUltraLogo" };
    for _, n in ipairs(names) do;
        pcall(function()
            if gethui then;
                local h = gethui();
                local o = h:FindFirstChild(n);
                if o then o:Destroy(); end;
            end;
        end);
        pcall(function()
            local o = CoreGui:FindFirstChild(n);
            if o then o:Destroy(); end;
        end);
        pcall(function()
            local o = LP.PlayerGui:FindFirstChild(n);
            if o then o:Destroy(); end;
        end);
    end;
end;

clearOld();

local parentGui = LP:WaitForChild("PlayerGui");
pcall(function()
    if gethui then;
        local h = gethui();
        if h then parentGui = h; end;
    end;
end);

local screen = Instance.new("ScreenGui");
screen.Name = "vanzFPSUltra";
screen.ResetOnSpawn = false;
screen.IgnoreGuiInset = true;
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
screen.DisplayOrder = 999999;
screen.Enabled = true;
screen.Parent = parentGui;

local main = Instance.new("Frame");
main.Name = "Main";
main.AnchorPoint = Vector2.new(0.5, 0.5);
main.Size = UDim2.new(0, 260, 0.85, 0);
main.Position = UDim2.new(0.5, 0, 0.5, 0);
main.BackgroundColor3 = T.bg;
main.BorderSizePixel = 0;
main.Active = true;
main.ZIndex = 10;
main.Parent = screen;

local msc = Instance.new("UISizeConstraint");
msc.MaxSize = Vector2.new(300, 800);
msc.MinSize = Vector2.new(240, 320);
msc.Parent = main;

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14);
local mstroke = Instance.new("UIStroke", main);
mstroke.Color = T.accent;
mstroke.Thickness = 2;
mstroke.Transparency = 0.2;

local titleBar = Instance.new("Frame");
titleBar.Name = "TitleBar";
titleBar.Size = UDim2.new(1, 0, 0, 40);
titleBar.BackgroundColor3 = T.panel;
titleBar.BorderSizePixel = 0;
titleBar.ZIndex = 11;
titleBar.Parent = main;
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14);

local tfix = Instance.new("Frame");
tfix.Size = UDim2.new(1, 0, 0, 14);
tfix.Position = UDim2.new(0, 0, 1, -14);
tfix.BackgroundColor3 = T.panel;
tfix.BorderSizePixel = 0;
tfix.ZIndex = 11;
tfix.Parent = titleBar;

local title = Instance.new("TextLabel");
title.Size = UDim2.new(1, -80, 1, 0);
title.Position = UDim2.new(0, 14, 0, 0);
title.BackgroundTransparency = 1;
title.Text = "vanz ♡ APOCALYPSE";
title.TextColor3 = T.accent;
title.TextSize = 14;
title.Font = Enum.Font.GothamBold;
title.TextXAlignment = Enum.TextXAlignment.Left;
title.ZIndex = 12;
title.Parent = titleBar;

local minBtn = Instance.new("TextButton");
minBtn.AnchorPoint = Vector2.new(1, 0.5);
minBtn.Size = UDim2.new(0, 28, 0, 28);
minBtn.Position = UDim2.new(1, -10, 0.5, 0);
minBtn.BackgroundColor3 = T.accent;
minBtn.Text = "—";
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
minBtn.TextSize = 18;
minBtn.Font = Enum.Font.GothamBold;
minBtn.ZIndex = 13;
minBtn.AutoButtonColor = false;
minBtn.Parent = titleBar;
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0);

local body = Instance.new("ScrollingFrame");
body.Size = UDim2.new(1, -20, 1, -52);
body.Position = UDim2.new(0, 10, 0, 44);
body.BackgroundTransparency = 1;
body.BorderSizePixel = 0;
body.ScrollBarThickness = 6;
body.ScrollBarImageColor3 = T.accent;
body.CanvasSize = UDim2.new(0, 0, 0, 0);
body.AutomaticCanvasSize = Enum.AutomaticSize.Y;
body.ScrollingDirection = Enum.ScrollingDirection.Y;
body.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable;
body.ZIndex = 11;
body.Parent = main;

local bodyLayout = Instance.new("UIListLayout");
bodyLayout.Padding = UDim.new(0, 6);
bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder;
bodyLayout.Parent = body;

local bodyPad = Instance.new("UIPadding");
bodyPad.PaddingTop = UDim.new(0, 6);
bodyPad.PaddingBottom = UDim.new(0, 16);
bodyPad.PaddingRight = UDim.new(0, 6);
bodyPad.Parent = body;

local logo = Instance.new("TextButton");
logo.Name = "vanzFPSUltraLogo";
logo.AnchorPoint = Vector2.new(0.5, 0.5);
logo.Size = UDim2.new(0, 58, 0, 58);
logo.Position = UDim2.new(0.5, 0, 0.3, 0);
logo.BackgroundColor3 = T.bg;
logo.Text = "☢";
logo.TextColor3 = T.accent;
logo.TextSize = 30;
logo.Font = Enum.Font.GothamBold;
logo.Visible = false;
logo.Active = true;
logo.AutoButtonColor = false;
logo.ZIndex = 100;
logo.Parent = screen;
Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0);
local logoStroke = Instance.new("UIStroke", logo);
logoStroke.Color = T.accent;
logoStroke.Thickness = 2.5;
logoStroke.Transparency = 0.1;

local saved = {};
local hiddenParts = {};
local destroyedCache = {};
local enabled = false;
local ultraMode = false;
local lastFps = 0;
local frameCount = 0;
local fpsTimer = 0;
local fpsLabel = nil;
local descConn = nil;
local loopConn = nil;
local shadowConn = nil;
local renderQualityBackup = nil;

local store = function(obj, key, val)
    if saved[obj] == nil then saved[obj] = {}; end;
    if saved[obj][key] == nil then saved[obj][key] = val; end;
end;

local cleanPart = function(p)
    if not p or not p.Parent then return; end;
    if p:IsA("ParticleEmitter") then;
        store(p, "Enabled", p.Enabled);
        p.Enabled = false;
        store(p, "Rate", p.Rate);
        p.Rate = 0;
        store(p, "Lifetime", p.Lifetime);
        p.Lifetime = NumberRange.new(0.01);
        store(p, "Speed", p.Speed);
        p.Speed = NumberRange.new(0);
        store(p, "EmissionDirection", p.EmissionDirection);
        return;
    end;
    if p:IsA("Trail") or p:IsA("Beam") then;
        store(p, "Enabled", p.Enabled);
        p.Enabled = false;
        return;
    end;
    if p:IsA("Fire") or p:IsA("Smoke") or p:IsA("Sparkles") or p:IsA("Explosion") then;
        store(p, "Enabled", p.Enabled);
        p.Enabled = false;
        return;
    end;
    if p:IsA("Decal") or p:IsA("Texture") then;
        store(p, "Transparency", p.Transparency);
        p.Transparency = 1;
        return;
    end;
    if p:IsA("SurfaceAppearance") then;
        store(p, "Parent", p.Parent);
        p.Parent = nil;
        return;
    end;
    if p:IsA("BasePart") then;
        if p.Material ~= Enum.Material.SmoothPlastic then;
            store(p, "Material", p.Material);
            p.Material = Enum.Material.SmoothPlastic;
        end;
        if p.Reflectance > 0 then;
            store(p, "Reflectance", p.Reflectance);
            p.Reflectance = 0;
        end;
        if p.CastShadow then;
            store(p, "CastShadow", p.CastShadow);
            p.CastShadow = false;
        end;
        if p:IsA("MeshPart") then;
            store(p, "RenderFidelity", p.RenderFidelity);
            pcall(function() p.RenderFidelity = Enum.RenderFidelity.Performance; end);
        end;
        if p:IsA("Part") or p:IsA("MeshPart") or p:IsA("UnionOperation") then;
            store(p, "DoubleSided", p.DoubleSided);
            pcall(function() p.DoubleSided = false; end);
        end;
    end;
    if p:IsA("Atmosphere") then;
        store(p, "Density", p.Density);
        p.Density = 0;
        store(p, "Haze", p.Haze);
        p.Haze = 0;
        store(p, "Glare", p.Glare);
        p.Glare = 0;
        store(p, "Enabled", p.Enabled);
        p.Enabled = false;
        return;
    end;
    if p:IsA("Clouds") then;
        store(p, "Parent", p.Parent);
        p.Parent = nil;
        return;
    end;
    if p:IsA("Sky") then;
        store(p, "Parent", p.Parent);
        p.Parent = nil;
        return;
    end;
    if p:IsA("PostEffect") or p:IsA("BloomEffect") or p:IsA("BlurEffect")
        or p:IsA("ColorCorrectionEffect") or p:IsA("SunRaysEffect")
        or p:IsA("DepthOfFieldEffect") then;
        store(p, "Enabled", p.Enabled);
        p.Enabled = false;
        return;
    end;
    if p:IsA("Sound") and p.Playing then;
        store(p, "Playing", true);
        p.Playing = false;
        return;
    end;
    if p:IsA("AnimationController") or p:IsA("Animator") then;
        store(p, "Parent", p.Parent);
        p.Parent = nil;
        return;
    end;
    if p:IsA("Highlight") or p:IsA("SelectionBox") or p:IsA("SelectionSphere") then;
        store(p, "Enabled", p.Enabled);
        p.Enabled = false;
        return;
    end;
    if p:IsA("PointLight") or p:IsA("SpotLight") or p:IsA("SurfaceLight") then;
        store(p, "Enabled", p.Enabled);
        p.Enabled = false;
        return;
    end;
    if p:IsA("Texture") or p:IsA("Decal") then;
        store(p, "Transparency", p.Transparency);
        p.Transparency = 1;
        return;
    end;
    if p:IsA("SpecialMesh") or p:IsA("BlockMesh") or p:IsA("CylinderMesh")
        or p:IsA("FileMesh") or p:IsA("BevelMesh") then;
        store(p, "Scale", p.Scale);
        p.Scale = Vector3.new(0, 0, 0);
        return;
    end;
    if p:IsA("Motor6D") or p:IsA("Motor") or p:IsA("Weld") or p:IsA("WeldConstraint") then;
        return;
    end;
end;

local deepClean = function(root)
    if not root then return; end;
    for _, p in ipairs(root:GetDescendants()) do;
        pcall(cleanPart, p);
    end;
end;

local restoreAll = function()
    for obj, keys in pairs(saved) do;
        if typeof(obj) == "Instance" and obj.Parent then;
            for k, v in pairs(keys) do;
                pcall(function()
                    obj[k] = v;
                end);
            end;
        end;
    end;
    saved = {};
end;

local boostLighting = function()
    store(Lighting, "Brightness", Lighting.Brightness);
    store(Lighting, "Ambient", Lighting.Ambient);
    store(Lighting, "OutdoorAmbient", Lighting.OutdoorAmbient);
    store(Lighting, "GlobalShadows", Lighting.GlobalShadows);
    store(Lighting, "FogEnd", Lighting.FogEnd);
    store(Lighting, "FogStart", Lighting.FogStart);
    store(Lighting, "ClockTime", Lighting.ClockTime);
    store(Lighting, "GeographicLatitude", Lighting.GeographicLatitude);
    store(Lighting, "EnvironmentDiffuseScale", Lighting.EnvironmentDiffuseScale);
    store(Lighting, "EnvironmentSpecularScale", Lighting.EnvironmentSpecularScale);
    store(Lighting, "ShadowSoftness", Lighting.ShadowSoftness);
    store(Lighting, "ExposureCompensation", Lighting.ExposureCompensation);
    store(Lighting, "ColorShift_Top", Lighting.ColorShift_Top);
    store(Lighting, "ColorShift_Bottom", Lighting.ColorShift_Bottom);
    Lighting.Brightness = 1;
    Lighting.Ambient = Color3.fromRGB(255, 255, 255);
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255);
    Lighting.GlobalShadows = false;
    Lighting.FogEnd = 1000000;
    Lighting.FogStart = 1000000;
    Lighting.ClockTime = 12;
    Lighting.GeographicLatitude = 0;
    Lighting.EnvironmentDiffuseScale = 0;
    Lighting.EnvironmentSpecularScale = 0;
    Lighting.ShadowSoftness = 0;
    Lighting.ExposureCompensation = 0;
    Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0);
    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0);
    for _, child in ipairs(Lighting:GetChildren()) do;
        if child:IsA("PostEffect") or child:IsA("Atmosphere") or child:IsA("Clouds") or child:IsA("Sky") then;
            if child:IsA("Sky") or child:IsA("Clouds") then;
                store(child, "Parent", child.Parent);
                child.Parent = nil;
            else;
                store(child, "Enabled", child.Enabled);
                child.Enabled = false;
            end;
        end;
    end;
end;

local restoreLighting = function()
    local keys = { "Brightness", "Ambient", "OutdoorAmbient", "GlobalShadows", "FogEnd", "FogStart", "ClockTime", "GeographicLatitude", "EnvironmentDiffuseScale", "EnvironmentSpecularScale", "ShadowSoftness", "ExposureCompensation", "ColorShift_Top", "ColorShift_Bottom" };
    for _, k in ipairs(keys) do;
        if saved[Lighting] and saved[Lighting][k] ~= nil then;
            pcall(function()
                Lighting[k] = saved[Lighting][k];
            end);
        end;
    end;
end;

local boostTerrain = function()
    if not Terrain then return; end;
    store(Terrain, "WaterReflectance", Terrain.WaterReflectance);
    store(Terrain, "WaterWaveSize", Terrain.WaterWaveSize);
    store(Terrain, "WaterTransparency", Terrain.WaterTransparency);
    store(Terrain, "Decoration", Terrain.Decoration);
    Terrain.WaterReflectance = 0;
    Terrain.WaterWaveSize = 0;
    Terrain.WaterTransparency = 1;
    Terrain.Decoration = false;
end;

local restoreTerrain = function()
    if not Terrain then return; end;
    if saved[Terrain] then;
        for k, v in pairs(saved[Terrain]) do;
            pcall(function()
                Terrain[k] = v;
            end);
        end;
    end;
end;

local boostSettings = function()
    pcall(function()
        UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1;
    end);
    pcall(function()
        UserGameSettings.RenderingQualityLevel = Enum.QualityLevel.Level01;
    end);
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01;
    end);
    pcall(function()
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01;
    end);
    pcall(function()
        settings().Rendering.EditQualityLevel = 1;
    end);
    pcall(function()
        settings().Rendering.EditFidelityLevel = 1;
    end);
    pcall(function()
        settings().Rendering.ViewportSize = Vector2.new(640, 360);
    end);
end;

local restoreSettings = function()
    pcall(function()
        UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.Automatic;
    end);
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic;
    end);
end;

local hideFarParts = function(range)
    range = range or 150;
    local cam = Workspace.CurrentCamera;
    if not cam then return; end;
    local origin = cam.CFrame.Position;
    for _, p in ipairs(Workspace:GetDescendants()) do;
        if p:IsA("BasePart") then;
            local dist = (p.Position - origin).Magnitude;
            if dist > range then;
                if not hiddenParts[p] then;
                    hiddenParts[p] = { LocalTransparencyModifier = p.LocalTransparencyModifier };
                end;
                p.LocalTransparencyModifier = 1;
            elseif hiddenParts[p] then;
                pcall(function()
                    p.LocalTransparencyModifier = hiddenParts[p].LocalTransparencyModifier or 0;
                end);
                hiddenParts[p] = nil;
            end;
        end;
    end;
end;

local restoreFarParts = function()
    for p, data in pairs(hiddenParts) do;
        if p and p.Parent then;
            pcall(function()
                p.LocalTransparencyModifier = data.LocalTransparencyModifier or 0;
            end);
        end;
    end;
    hiddenParts = {};
end;

local disableGuiEffects = function()
    pcall(function()
        StarterGui:SetCore("TopbarEnabled", false);
    end);
    local pg = LP:FindFirstChild("PlayerGui");
    if pg then;
        for _, g in ipairs(pg:GetDescendants()) do;
            if g:IsA("BlurEffect") or g:IsA("BloomEffect") or g:IsA("DepthOfFieldEffect")
                or g:IsA("SunRaysEffect") or g:IsA("ColorCorrectionEffect") then;
                store(g, "Enabled", g.Enabled);
                g.Enabled = false;
            end;
        end;
    end;
end;

local restoreGuiEffects = function()
    pcall(function()
        StarterGui:SetCore("TopbarEnabled", true);
    end);
end;

local killSoundsEverywhere = function()
    for _, p in ipairs(game:GetDescendants()) do;
        if p:IsA("Sound") and p.Playing then;
            store(p, "Playing", true);
            pcall(function() p.Playing = false; end);
        end;
    end;
end;

local killAnimationsEverywhere = function()
    for _, p in ipairs(game:GetDescendants()) do;
        if p:IsA("AnimationTrack") and p.IsPlaying then;
            pcall(function() p:Stop(); end);
        end;
    end;
end;

local clearTextures = function()
    for _, p in ipairs(game:GetDescendants()) do;
        if p:IsA("Decal") or p:IsA("Texture") then;
            store(p, "Transparency", p.Transparency);
            p.Transparency = 1;
        end;
        if p:IsA("SurfaceAppearance") then;
            store(p, "Parent", p.Parent);
            p.Parent = nil;
        end;
    end;
end;

local killShadowsEverywhere = function()
    for _, p in ipairs(Workspace:GetDescendants()) do;
        if p:IsA("BasePart") and p.CastShadow then;
            store(p, "CastShadow", true);
            p.CastShadow = false;
        end;
    end;
end;

local killLightsEverywhere = function()
    for _, p in ipairs(Lighting:GetDescendants()) do;
        if p:IsA("Light") then;
            store(p, "Enabled", p.Enabled);
            p.Enabled = false;
        end;
    end;
end;

local killHighlightsEverywhere = function()
    for _, p in ipairs(game:GetDescendants()) do;
        if p:IsA("Highlight") or p:IsA("SelectionBox") or p:IsA("SelectionSphere") then;
            store(p, "Enabled", p.Enabled);
            p.Enabled = false;
        end;
    end;
end;

local killBeamsTrails = function()
    for _, p in ipairs(game:GetDescendants()) do;
        if p:IsA("Beam") or p:IsA("Trail") then;
            store(p, "Enabled", p.Enabled);
            p.Enabled = false;
        end;
    end;
end;

local killParticles = function()
    for _, p in ipairs(game:GetDescendants()) do;
        if p:IsA("ParticleEmitter") then;
            store(p, "Enabled", p.Enabled);
            p.Enabled = false;
            store(p, "Rate", p.Rate);
            p.Rate = 0;
        end;
    end;
end;

local killSky = function()
    for _, p in ipairs(Lighting:GetChildren()) do;
        if p:IsA("Sky") then;
            store(p, "Parent", p.Parent);
            p.Parent = nil;
        end;
    end;
end;

local killAtmosphere = function()
    for _, p in ipairs(Lighting:GetChildren()) do;
        if p:IsA("Atmosphere") or p:IsA("Clouds") then;
            store(p, "Parent", p.Parent);
            p.Parent = nil;
        end;
    end;
end;

local killMeshes = function()
    for _, p in ipairs(game:GetDescendants()) do;
        if p:IsA("SpecialMesh") or p:IsA("BlockMesh") or p:IsA("CylinderMesh")
            or p:IsA("FileMesh") or p:IsA("BevelMesh") then;
            store(p, "Scale", p.Scale);
            p.Scale = Vector3.new(0.001, 0.001, 0.001);
        end;
    end;
end;

local killEffectsInstances = function()
    for _, p in ipairs(game:GetDescendants()) do;
        if p:IsA("Explosion") or p:IsA("Fire") or p:IsA("Smoke") or p:IsA("Sparkles") then;
            store(p, "Enabled", p.Enabled);
            pcall(function() p.Enabled = false; end);
        end;
    end;
end;

local killAllScripts = function()
    for _, p in ipairs(game:GetDescendants()) do;
        if p:IsA("LocalScript") and p ~= script then;
            pcall(function()
                if not destroyedCache[p] then;
                    destroyedCache[p] = true;
                    p.Disabled = true;
                end;
            end);
        end;
    end;
end;

local optimizeCamera = function()
    local cam = Workspace.CurrentCamera;
    if not cam then return; end;
    store(cam, "FieldOfView", cam.FieldOfView);
    cam.FieldOfView = 70;
end;

local optimizePlayers = function()
    for _, plr in ipairs(Players:GetPlayers()) do;
        if plr ~= LP and plr.Character then;
            for _, p in ipairs(plr.Character:GetDescendants()) do;
                pcall(cleanPart, p);
            end;
        end;
    end;
end;

local updateFpsCounter = function()
    if not fpsLabel then return; end;
    frameCount = frameCount + 1;
    local now = tick();
    if now - fpsTimer >= 1 then;
        lastFps = frameCount / (now - fpsTimer);
        frameCount = 0;
        fpsTimer = now;
        pcall(function()
            fpsLabel.Text = "FPS: " .. math.floor(lastFps) .. " | " .. (ultraMode and "ULTRA" or (enabled and "EXTREME" or "IDLE"));
            if lastFps >= 120 then;
                fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 100);
            elseif lastFps >= 60 then;
                fpsLabel.TextColor3 = Color3.fromRGB(255, 200, 0);
            else;
                fpsLabel.TextColor3 = Color3.fromRGB(255, 50, 50);
            end;
        end);
    end;
end;

local startLoop = function()
    if loopConn then loopConn:Disconnect(); end;
    local counter = 0;
    loopConn = RunService.RenderStepped:Connect(function()
        if not enabled then return; end;
        pcall(updateFpsCounter);
        counter = counter + 1;
        local interval = ultraMode and 30 or 60;
        if counter % interval == 0 then;
            pcall(hideFarParts, ultraMode and 80 or 150);
            pcall(optimizePlayers);
        end;
        if counter % (ultraMode and 60 or 180) == 0 then;
            pcall(killSoundsEverywhere);
            pcall(killParticles);
            pcall(killEffectsInstances);
        end;
        if counter % (ultraMode and 120 or 300) == 0 then;
            pcall(killShadowsEverywhere);
            pcall(killHighlightsEverywhere);
            pcall(killBeamsTrails);
            pcall(killLightsEverywhere);
        end;
    end);
end;

local enableAll = function()
    if enabled then return; end;
    enabled = true;
    pcall(boostLighting);
    pcall(boostTerrain);
    pcall(boostSettings);
    pcall(disableGuiEffects);
    pcall(killSky);
    pcall(killAtmosphere);
    pcall(clearTextures);
    pcall(killShadowsEverywhere);
    pcall(killLightsEverywhere);
    pcall(killHighlightsEverywhere);
    pcall(killBeamsTrails);
    pcall(killParticles);
    pcall(killEffectsInstances);
    pcall(killSoundsEverywhere);
    pcall(killAnimationsEverywhere);
    pcall(optimizeCamera);
    pcall(deepClean, Workspace);
    pcall(hideFarParts, 150);
    if descConn then descConn:Disconnect(); end;
    descConn = game.DescendantAdded:Connect(function(obj)
        if not enabled then return; end;
        task.spawn(function()
            pcall(cleanPart, obj);
            if obj:IsA("Sound") then;
                pcall(function() obj.Playing = false; end);
            end;
            if obj:IsA("Decal") or obj:IsA("Texture") then;
                pcall(function() obj.Transparency = 1; end);
            end;
            if obj:IsA("ParticleEmitter") then;
                pcall(function() obj.Enabled = false; obj.Rate = 0; end);
            end;
            if obj:IsA("BasePart") then;
                pcall(function() obj.CastShadow = false; end);
            end;
            if obj:IsA("Light") then;
                pcall(function() obj.Enabled = false; end);
            end;
            if obj:IsA("Beam") or obj:IsA("Trail") then;
                pcall(function() obj.Enabled = false; end);
            end;
        end);
    end);
    startLoop();
end;

local disableAll = function()
    if not enabled then return; end;
    enabled = false;
    ultraMode = false;
    if descConn then descConn:Disconnect(); descConn = nil; end;
    if loopConn then loopConn:Disconnect(); loopConn = nil; end;
    pcall(restoreFarParts);
    pcall(restoreGuiEffects);
    pcall(restoreLighting);
    pcall(restoreTerrain);
    pcall(restoreSettings);
    pcall(restoreAll);
end;

local enableUltra = function()
    if not enabled then enableAll(); end;
    ultraMode = true;
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01;
    end);
    pcall(function()
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01;
    end);
    pcall(function()
        UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1;
    end);
    pcall(killMeshes);
    pcall(killSky);
    pcall(killAtmosphere);
    pcall(killLightsEverywhere);
    pcall(clearTextures);
    pcall(killParticles);
    pcall(killBeamsTrails);
    pcall(killHighlightsEverywhere);
    pcall(killSoundsEverywhere);
    pcall(killEffectsInstances);
    pcall(killShadowsEverywhere);
    pcall(function()
        local cam = Workspace.CurrentCamera;
        if cam then;
            store(cam, "FieldOfView", cam.FieldOfView);
            cam.FieldOfView = 90;
        end;
    end);
end;

local makeToggle = function(name, default, cb)
    local row = Instance.new("Frame");
    row.Size = UDim2.new(1, 0, 0, 42);
    row.BackgroundColor3 = T.row;
    row.BorderSizePixel = 0;
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8);
    row.Parent = body;

    local lbl = Instance.new("TextLabel");
    lbl.Size = UDim2.new(1, -80, 1, 0);
    lbl.Position = UDim2.new(0, 12, 0, 0);
    lbl.BackgroundTransparency = 1;
    lbl.Text = name;
    lbl.TextColor3 = T.text;
    lbl.TextSize = 11;
    lbl.Font = Enum.Font.Gotham;
    lbl.TextXAlignment = Enum.TextXAlignment.Left;
    lbl.TextWrapped = true;
    lbl.Parent = row;

    local btn = Instance.new("TextButton");
    btn.Size = UDim2.new(0, 50, 0, 26);
    btn.Position = UDim2.new(1, -62, 0.5, -13);
    btn.BackgroundColor3 = default and T.on or T.off;
    btn.Text = default and "ON" or "OFF";
    btn.TextColor3 = Color3.fromRGB(255, 255, 255);
    btn.TextSize = 11;
    btn.Font = Enum.Font.GothamBold;
    btn.AutoButtonColor = false;
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6);
    btn.Parent = row;

    local state = default;
    btn.MouseButton1Click:Connect(function()
        state = not state;
        btn.BackgroundColor3 = state and T.on or T.off;
        btn.Text = state and "ON" or "OFF";
        if cb then pcall(cb, state); end;
    end);

    return btn, function()
        return state;
    end;
end;

local makeInfo = function(txt)
    local lbl = Instance.new("TextLabel");
    lbl.Size = UDim2.new(1, 0, 0, 30);
    lbl.BackgroundColor3 = T.panel;
    lbl.Text = txt;
    lbl.TextColor3 = T.dim;
    lbl.TextSize = 10;
    lbl.Font = Enum.Font.Gotham;
    lbl.TextWrapped = true;
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 6);
    lbl.Parent = body;
    return lbl;
end;

local makeButton = function(name, cb)
    local b = Instance.new("TextButton");
    b.Size = UDim2.new(1, 0, 0, 36);
    b.BackgroundColor3 = T.accent;
    b.Text = name;
    b.TextColor3 = Color3.fromRGB(255, 255, 255);
    b.TextSize = 12;
    b.Font = Enum.Font.GothamBold;
    b.AutoButtonColor = false;
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8);
    b.Parent = body;
    b.MouseButton1Click:Connect(function()
        if cb then pcall(cb); end;
    end);
    return b;
end;

fpsLabel = Instance.new("TextLabel");
fpsLabel.Size = UDim2.new(1, 0, 0, 28);
fpsLabel.BackgroundColor3 = T.panel;
fpsLabel.Text = "FPS: -- | IDLE";
fpsLabel.TextColor3 = T.dim;
fpsLabel.TextSize = 12;
fpsLabel.Font = Enum.Font.GothamBold;
Instance.new("UICorner", fpsLabel).CornerRadius = UDim.new(0, 6);
fpsLabel.Parent = body;

makeInfo("☢ APOCALYPSE MODE ☢");
makeInfo("Hancurkan grafik. Ledakkan FPS. Sadis.");

makeToggle("🔥 MASTER EXTREME", false, function(s)
    if s then enableAll(); else disableAll(); end;
end);

makeToggle("☢ ULTRA MODE (SADIS)", false, function(s)
    if s then enableUltra(); else ultraMode = false; end;
end);

makeInfo("── LIGHTING ANNIHILATION ──");
makeToggle("Kill Global Shadows", false, function(s)
    if s then pcall(killShadowsEverywhere); else pcall(function()
        for p, keys in pairs(saved) do;
            if p:IsA("BasePart") and keys.CastShadow ~= nil then;
                pcall(function() p.CastShadow = keys.CastShadow; end);
            end;
        end;
    end); end;
end);
makeToggle("Kill All Lights", false, function(s)
    if s then pcall(killLightsEverywhere); else pcall(function()
        for p, keys in pairs(saved) do;
            if p:IsA("Light") and keys.Enabled ~= nil then;
                pcall(function() p.Enabled = keys.Enabled; end);
            end;
        end;
    end); end;
end);
makeToggle("Kill Sky", false, function(s)
    if s then pcall(killSky); else pcall(function()
        for p, keys in pairs(saved) do;
            if p:IsA("Sky") and keys.Parent ~= nil then;
                pcall(function() p.Parent = keys.Parent; end);
            end;
        end;
    end); end;
end);
makeToggle("Kill Atmosphere/Clouds", false, function(s)
    if s then pcall(killAtmosphere); else pcall(function()
        for p, keys in pairs(saved) do;
            if (p:IsA("Atmosphere") or p:IsA("Clouds")) and keys.Parent ~= nil then;
                pcall(function() p.Parent = keys.Parent; end);
            end;
        end;
    end); end;
end);
makeToggle("Fog End = 1000000", false, function(s)
    if s then pcall(function()
        store(Lighting, "FogEnd", Lighting.FogEnd);
        store(Lighting, "FogStart", Lighting.FogStart);
        Lighting.FogEnd = 1000000;
        Lighting.FogStart = 1000000;
    end); else pcall(function()
        if saved[Lighting] then;
            if saved[Lighting].FogEnd then Lighting.FogEnd = saved[Lighting].FogEnd; end;
            if saved[Lighting].FogStart then Lighting.FogStart = saved[Lighting].FogStart; end;
        end;
    end); end;
end);
makeToggle("Ambient Bright", false, function(s)
    if s then pcall(function()
        store(Lighting, "Ambient", Lighting.Ambient);
        store(Lighting, "OutdoorAmbient", Lighting.OutdoorAmbient);
        Lighting.Ambient = Color3.fromRGB(255, 255, 255);
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255);
    end); else pcall(function()
        if saved[Lighting] then;
            if saved[Lighting].Ambient then Lighting.Ambient = saved[Lighting].Ambient; end;
            if saved[Lighting].OutdoorAmbient then Lighting.OutdoorAmbient = saved[Lighting].OutdoorAmbient; end;
        end;
    end); end;
end);
makeToggle("ShadowSoftness = 0", false, function(s)
    if s then pcall(function()
        store(Lighting, "ShadowSoftness", Lighting.ShadowSoftness);
        Lighting.ShadowSoftness = 0;
    end); else pcall(function()
        if saved[Lighting] and saved[Lighting].ShadowSoftness then;
            Lighting.ShadowSoftness = saved[Lighting].ShadowSoftness;
        end;
    end); end;
end);

makeInfo("── VISUAL PURGE ──");
makeToggle("Kill Particles", false, function(s)
    if s then pcall(killParticles); else pcall(function()
        for p, keys in pairs(saved) do;
            if p:IsA("ParticleEmitter") then;
                if keys.Enabled ~= nil then pcall(function() p.Enabled = keys.Enabled; end); end;
                if keys.Rate ~= nil then pcall(function() p.Rate = keys.Rate; end); end;
            end;
        end;
    end); end;
end);
makeToggle("Kill Beams/Trails", false, function(s)
    if s then pcall(killBeamsTrails); else pcall(function()
        for p, keys in pairs(saved) do;
            if (p:IsA("Beam") or p:IsA("Trail")) and keys.Enabled ~= nil then;
                pcall(function() p.Enabled = keys.Enabled; end);
            end;
        end;
    end); end;
end);
makeToggle("Kill Highlights/Boxes", false, function(s)
    if s then pcall(killHighlightsEverywhere); else pcall(function()
        for p, keys in pairs(saved) do;
            if (p:IsA("Highlight") or p:IsA("SelectionBox") or p:IsA("SelectionSphere")) and keys.Enabled ~= nil then;
                pcall(function() p.Enabled = keys.Enabled; end);
            end;
        end;
    end); end;
end);
makeToggle("Kill Decals/Textures", false, function(s)
    if s then pcall(clearTextures); else pcall(function()
        for p, keys in pairs(saved) do;
            if (p:IsA("Decal") or p:IsA("Texture")) and keys.Transparency ~= nil then;
                pcall(function() p.Transparency = keys.Transparency; end);
            end;
        end;
    end); end;
end);
makeToggle("Kill SurfaceAppearance", false, function(s)
    if s then pcall(function()
        for _, p in ipairs(game:GetDescendants()) do;
            if p:IsA("SurfaceAppearance") then;
                store(p, "Parent", p.Parent);
                p.Parent = nil;
            end;
        end;
    end); else pcall(function()
        for p, keys in pairs(saved) do;
            if p:IsA("SurfaceAppearance") and keys.Parent ~= nil then;
                pcall(function() p.Parent = keys.Parent; end);
            end;
        end;
    end); end;
end);
makeToggle("Kill Meshes (Scale 0)", false, function(s)
    if s then pcall(killMeshes); else pcall(function()
        for p, keys in pairs(saved) do;
            if (p:IsA("SpecialMesh") or p:IsA("BlockMesh") or p:IsA("CylinderMesh")
                or p:IsA("FileMesh") or p:IsA("BevelMesh")) and keys.Scale ~= nil then;
                pcall(function() p.Scale = keys.Scale; end);
            end;
        end;
    end); end;
end);
makeToggle("Kill Explosions/Effects", false, function(s)
    if s then pcall(killEffectsInstances); else pcall(function()
        for p, keys in pairs(saved) do;
            if (p:IsA("Explosion") or p:IsA("Fire") or p:IsA("Smoke") or p:IsA("Sparkles")) and keys.Enabled ~= nil then;
                pcall(function() p.Enabled = keys.Enabled; end);
            end;
        end;
    end); end;
end);

makeInfo("── WORLD PURGE ──");
makeToggle("Hide Far Parts (>150)", false, function(s)
    if s then pcall(hideFarParts, 150); else pcall(restoreFarParts); end;
end);
makeToggle("Hide Far Parts AGRESIF (>80)", false, function(s)
    if s then pcall(hideFarParts, 80); else pcall(restoreFarParts); end;
end);
makeToggle("Terrain Water Kill", false, function(s)
    if s then pcall(boostTerrain); else pcall(restoreTerrain); end;
end);
makeToggle("Force SmoothPlastic", false, function(s)
    if s then pcall(function()
        for _, p in ipairs(Workspace:GetDescendants()) do;
            if p:IsA("BasePart") and p.Material ~= Enum.Material.SmoothPlastic then;
                store(p, "Material", p.Material);
                p.Material = Enum.Material.SmoothPlastic;
            end;
        end;
    end); else pcall(function()
        for p, keys in pairs(saved) do;
            if p:IsA("BasePart") and keys.Material ~= nil then;
                pcall(function() p.Material = keys.Material; end);
            end;
        end;
    end); end;
end);
makeToggle("Reflectance = 0", false, function(s)
    if s then pcall(function()
        for _, p in ipairs(Workspace:GetDescendants()) do;
            if p:IsA("BasePart") and p.Reflectance > 0 then;
                store(p, "Reflectance", p.Reflectance);
                p.Reflectance = 0;
            end;
        end;
    end); else pcall(function()
        for p, keys in pairs(saved) do;
            if p:IsA("BasePart") and keys.Reflectance ~= nil then;
                pcall(function() p.Reflectance = keys.Reflectance; end);
            end;
        end;
    end); end;
end);

makeInfo("── AUDIO PURGE ──");
makeToggle("Kill All Sounds", false, function(s)
    if s then pcall(killSoundsEverywhere); else pcall(function()
        for p, keys in pairs(saved) do;
            if p:IsA("Sound") and keys.Playing ~= nil then;
                pcall(function() p.Playing = keys.Playing; end);
            end;
        end;
    end); end;
end);
makeToggle("Master Volume = 0", false, function(s)
    if s then pcall(function()
        store(UserGameSettings, "MasterVolume", UserGameSettings.MasterVolume);
        UserGameSettings.MasterVolume = 0;
    end); else pcall(function()
        UserGameSettings.MasterVolume = 1;
    end); end;
end);

makeInfo("── CHARACTER PURGE ──");
makeToggle("Kill Animations", false, function(s)
    if s then pcall(killAnimationsEverywhere); end;
end);
makeToggle("Optimize Other Players", false, function(s)
    if s then pcall(optimizePlayers); end;
end);
makeToggle("Camera FOV 90", false, function(s)
    if s then pcall(function()
        local cam = Workspace.CurrentCamera;
        if cam then;
            store(cam, "FieldOfView", cam.FieldOfView);
            cam.FieldOfView = 90;
        end;
    end); else pcall(function()
        local cam = Workspace.CurrentCamera;
        if cam and saved[cam] and saved[cam].FieldOfView then;
            cam.FieldOfView = saved[cam].FieldOfView;
        end;
    end); end;
end);
makeToggle("Kill LocalScripts (Risky)", false, function(s)
    if s then pcall(killAllScripts); end;
end);

makeInfo("── SYSTEM PURGE ──");
makeToggle("Quality Level 1", false, function(s)
    if s then pcall(boostSettings); else pcall(restoreSettings); end;
end);
makeToggle("Disable GUI Effects", false, function(s)
    if s then pcall(disableGuiEffects); else pcall(restoreGuiEffects); end;
end);
makeToggle("Disable Topbar", false, function(s)
    pcall(function()
        StarterGui:SetCore("TopbarEnabled", not s);
    end);
end);

makeInfo("── ACTIONS ──");
makeButton("☢ NUKE EVERYTHING (APOCALYPSE)", function()
    pcall(enableAll);
    pcall(enableUltra);
    pcall(killSky);
    pcall(killAtmosphere);
    pcall(clearTextures);
    pcall(killShadowsEverywhere);
    pcall(killLightsEverywhere);
    pcall(killHighlightsEverywhere);
    pcall(killBeamsTrails);
    pcall(killParticles);
    pcall(killEffectsInstances);
    pcall(killSoundsEverywhere);
    pcall(killAnimationsEverywhere);
    pcall(killMeshes);
    pcall(optimizeCamera);
    pcall(optimizePlayers);
    pcall(boostSettings);
    pcall(disableGuiEffects);
    pcall(hideFarParts, 80);
    for _, c in ipairs(body:GetChildren()) do;
        if c:IsA("Frame") then;
            for _, b in ipairs(c:GetChildren()) do;
                if b:IsA("TextButton") and b.Text == "OFF" then;
                    b.BackgroundColor3 = T.on;
                    b.Text = "ON";
                end;
            end;
        end;
    end;
end);

makeButton("❌ RESTORE EVERYTHING", function()
    pcall(disableAll);
    for _, c in ipairs(body:GetChildren()) do;
        if c:IsA("Frame") then;
            for _, b in ipairs(c:GetChildren()) do;
                if b:IsA("TextButton") and b.Text == "ON" then;
                    b.BackgroundColor3 = T.off;
                    b.Text = "OFF";
                end;
            end;
        end;
    end;
end);

minBtn.MouseButton1Click:Connect(function()
    main.Visible = false;
    logo.Visible = true;
end);

logo.MouseButton1Click:Connect(function()
    logo.Visible = false;
    main.Visible = true;
end);

local dragging = false;
local dragInput = nil;
local dragStart = nil;
local startPos = nil;

local function updateDrag(input)
    local delta = input.Position - dragStart;
    logo.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    );
end;

logo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then;
        dragging = true;
        dragStart = input.Position;
        startPos = logo.Position;
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then;
                dragging = false;
            end;
        end);
    end;
end);

logo.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then;
        dragInput = input;
    end;
end);

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then;
        updateDrag(input);
    end;
end);

fpsTimer = tick();

return {
    enable = enableAll;
    disable = disableAll;
    enableUltra = enableUltra;
    isEnabled = function() return enabled; end;
    isUltra = function() return ultraMode; end;
    screen = screen;
    main = main;
    logo = logo;
};
