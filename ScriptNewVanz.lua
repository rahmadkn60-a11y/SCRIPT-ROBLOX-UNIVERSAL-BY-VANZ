local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UIS = game:GetService("UserInputService");
local CoreGui = game:GetService("CoreGui");
local Workspace = game:GetService("Workspace");
local Lighting = game:GetService("Lighting");
local HttpService = game:GetService("HttpService");
local TeleportService = game:GetService("TeleportService");
local LP = Players.LocalPlayer;

for _, n in ipairs({"vanzSlimMenu"}) do;
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

local parentGui = LP:WaitForChild("PlayerGui");
pcall(function()
    if gethui then;
        local h = gethui();
        if h then parentGui = h; end;
    end;
end);

local screen = Instance.new("ScreenGui");
screen.Name = "vanzSlimMenu";
screen.ResetOnSpawn = false;
screen.IgnoreGuiInset = true;
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
screen.DisplayOrder = 999999;
screen.Enabled = true;
screen.Parent = parentGui;

local T = {
    bg = Color3.fromRGB(16, 14, 20);
    panel = Color3.fromRGB(26, 22, 32);
    row = Color3.fromRGB(34, 28, 42);
    accent = Color3.fromRGB(255, 90, 140);
    text = Color3.fromRGB(235, 225, 240);
    dim = Color3.fromRGB(150, 135, 165);
    on = Color3.fromRGB(90, 205, 130);
    off = Color3.fromRGB(70, 60, 82);
    sel = Color3.fromRGB(255, 90, 140);
};
local CT = Color3.fromRGB(60, 140, 255);
local CE = Color3.fromRGB(255, 60, 60);
local CU = Color3.fromRGB(180, 180, 180);
local CA = Color3.fromRGB(255, 40, 40);

local main = Instance.new("Frame");
main.Name = "Main";
main.AnchorPoint = Vector2.new(0.5, 0.5);
main.Size = UDim2.new(0, 280, 0.85, 0);
main.Position = UDim2.new(0.5, 0, 0.5, 0);
main.BackgroundColor3 = T.bg;
main.BorderSizePixel = 0;
main.Active = true;
main.Visible = true;
main.ZIndex = 10;
main.Parent = screen;

local msc = Instance.new("UISizeConstraint");
msc.MaxSize = Vector2.new(300, 720);
msc.MinSize = Vector2.new(260, 300);
msc.Parent = main;

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14);
local ms = Instance.new("UIStroke", main);
ms.Color = T.accent;
ms.Thickness = 1.5;
ms.Transparency = 0.3;

local tb = Instance.new("Frame", main);
tb.Name = "TitleBar";
tb.Size = UDim2.new(1, 0, 0, 40);
tb.BackgroundColor3 = T.panel;
tb.BorderSizePixel = 0;
tb.ZIndex = 11;
Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 14);

local tfix = Instance.new("Frame", tb);
tfix.Size = UDim2.new(1, 0, 0, 14);
tfix.Position = UDim2.new(0, 0, 1, -14);
tfix.BackgroundColor3 = T.panel;
tfix.BorderSizePixel = 0;
tfix.ZIndex = 11;

local tt = Instance.new("TextLabel", tb);
tt.Size = UDim2.new(1, -20, 1, 0);
tt.Position = UDim2.new(0, 14, 0, 0);
tt.BackgroundTransparency = 1;
tt.Text = "vanz ♡ slim";
tt.TextColor3 = T.accent;
tt.TextSize = 16;
tt.Font = Enum.Font.GothamBold;
tt.TextXAlignment = Enum.TextXAlignment.Left;
tt.ZIndex = 12;

local tabBar = Instance.new("Frame", main);
tabBar.Name = "TabBar";
tabBar.Size = UDim2.new(1, -12, 0, 32);
tabBar.Position = UDim2.new(0, 6, 0, 44);
tabBar.BackgroundColor3 = T.panel;
tabBar.BorderSizePixel = 0;
tabBar.ZIndex = 11;
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8);

local tabLayout = Instance.new("UIListLayout", tabBar);
tabLayout.FillDirection = Enum.FillDirection.Horizontal;
tabLayout.Padding = UDim.new(0, 2);
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder;
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center;

local body = Instance.new("ScrollingFrame", main);
body.Size = UDim2.new(1, -20, 1, -90);
body.Position = UDim2.new(0, 10, 0, 82);
body.BackgroundTransparency = 1;
body.BorderSizePixel = 0;
body.ScrollBarThickness = 6;
body.ScrollBarImageColor3 = T.accent;
body.CanvasSize = UDim2.new(0, 0, 0, 0);
body.AutomaticCanvasSize = Enum.AutomaticSize.Y;
body.ScrollingEnabled = true;
body.ScrollingDirection = Enum.ScrollingDirection.Y;
body.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable;
body.ZIndex = 11;

local bl = Instance.new("UIListLayout", body);
bl.Padding = UDim.new(0, 6);
bl.SortOrder = Enum.SortOrder.LayoutOrder;

local bp = Instance.new("UIPadding", body);
bp.PaddingTop = UDim.new(0, 4);
bp.PaddingBottom = UDim.new(0, 16);
bp.PaddingRight = UDim.new(0, 6);

local minBtn = Instance.new("TextButton", main);
minBtn.AnchorPoint = Vector2.new(0, 0.5);
minBtn.Size = UDim2.new(0, 36, 0, 36);
minBtn.Position = UDim2.new(1, 8, 0.5, 0);
minBtn.BackgroundColor3 = T.accent;
minBtn.Text = "—";
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
minBtn.TextSize = 20;
minBtn.Font = Enum.Font.GothamBold;
minBtn.ZIndex = 50;
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0);
local mbs = Instance.new("UIStroke", minBtn);
mbs.Color = T.bg;
mbs.Thickness = 2;
mbs.Transparency = 0.3;

local logo = Instance.new("TextButton", screen);
logo.AnchorPoint = Vector2.new(0.5, 0);
logo.Size = UDim2.new(0, 58, 0, 58);
logo.Position = UDim2.new(0.5, 0, 0, 12);
logo.BackgroundColor3 = T.bg;
logo.Text = "♡";
logo.TextColor3 = T.accent;
logo.TextSize = 28;
logo.Font = Enum.Font.GothamBold;
logo.Visible = false;
logo.Active = true;
logo.ZIndex = 100;
Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0);
local ls = Instance.new("UIStroke", logo);
ls.Color = T.accent;
ls.Thickness = 2;
ls.Transparency = 0.2;

minBtn.MouseButton1Click:Connect(function()
    main.Visible = false;
    logo.Visible = true;
end);
logo.MouseButton1Click:Connect(function()
    logo.Visible = false;
    main.Visible = true;
end);

local function getPlayerColor(plr)
    if plr == LP then return CT; end;
    if LP.Team and plr.Team then;
        if plr.Team == LP.Team then return CT; else return CE; end;
    end;
    if LP.TeamColor and plr.TeamColor then;
        if plr.TeamColor == LP.TeamColor then return CT; else return CE; end;
    end;
    return CU;
end;

local function isTeam(plr)
    if plr == LP then return true; end;
    if LP.Team and plr.Team then return plr.Team == LP.Team; end;
    if LP.TeamColor and plr.TeamColor then return plr.TeamColor == LP.TeamColor; end;
    return false;
end;

local function makeToggle(name, default, cb, parentOverride)
    local p = parentOverride or body;
    local r = Instance.new("Frame", p);
    r.Size = UDim2.new(1, 0, 0, 42);
    r.BackgroundColor3 = T.row;
    r.BorderSizePixel = 0;
    Instance.new("UICorner", r).CornerRadius = UDim.new(0, 8);
    local lb = Instance.new("TextLabel", r);
    lb.Size = UDim2.new(1, -80, 1, 0);
    lb.Position = UDim2.new(0, 12, 0, 0);
    lb.BackgroundTransparency = 1;
    lb.Text = name;
    lb.TextColor3 = T.text;
    lb.TextSize = 13;
    lb.Font = Enum.Font.Gotham;
    lb.TextXAlignment = Enum.TextXAlignment.Left;
    local b = Instance.new("TextButton", r);
    b.Size = UDim2.new(0, 50, 0, 26);
    b.Position = UDim2.new(1, -62, 0.5, -13);
    b.BackgroundColor3 = default and T.on or T.off;
    b.Text = default and "ON" or "OFF";
    b.TextColor3 = Color3.fromRGB(255, 255, 255);
    b.TextSize = 11;
    b.Font = Enum.Font.GothamBold;
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6);
    local st = default;
    b.MouseButton1Click:Connect(function()
        st = not st;
        b.BackgroundColor3 = st and T.on or T.off;
        b.Text = st and "ON" or "OFF";
        if cb then pcall(cb, st); end;
    end);
    return r, b;
end;

local function makeButton(name, cb, parentOverride)
    local p = parentOverride or body;
    local b = Instance.new("TextButton", p);
    b.Size = UDim2.new(1, 0, 0, 36);
    b.BackgroundColor3 = T.accent;
    b.Text = name;
    b.TextColor3 = Color3.fromRGB(255, 255, 255);
    b.TextSize = 13;
    b.Font = Enum.Font.GothamBold;
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8);
    b.MouseButton1Click:Connect(function()
        if cb then pcall(cb); end;
    end);
    return b;
end;

local function makeInfo(txt, parentOverride)
    local p = parentOverride or body;
    local lb = Instance.new("TextLabel", p);
    lb.Size = UDim2.new(1, 0, 0, 44);
    lb.BackgroundColor3 = T.row;
    lb.Text = txt;
    lb.TextColor3 = T.dim;
    lb.TextSize = 10;
    lb.Font = Enum.Font.Gotham;
    lb.TextWrapped = true;
    Instance.new("UICorner", lb).CornerRadius = UDim.new(0, 6);
    return lb;
end;

local function makeNum(name, default, cb, parentOverride)
    local p = parentOverride or body;
    local r = Instance.new("Frame", p);
    r.Size = UDim2.new(1, 0, 0, 42);
    r.BackgroundColor3 = T.row;
    r.BorderSizePixel = 0;
    Instance.new("UICorner", r).CornerRadius = UDim.new(0, 8);
    local lb = Instance.new("TextLabel", r);
    lb.Size = UDim2.new(0, 90, 1, 0);
    lb.Position = UDim2.new(0, 12, 0, 0);
    lb.BackgroundTransparency = 1;
    lb.Text = name;
    lb.TextColor3 = T.text;
    lb.TextSize = 13;
    lb.Font = Enum.Font.Gotham;
    lb.TextXAlignment = Enum.TextXAlignment.Left;
    local bx = Instance.new("TextBox", r);
    bx.Size = UDim2.new(1, -120, 0, 28);
    bx.Position = UDim2.new(0, 108, 0.5, -14);
    bx.BackgroundColor3 = T.bg;
    bx.Text = tostring(default);
    bx.PlaceholderText = "angka...";
    bx.TextColor3 = T.text;
    bx.TextSize = 13;
    bx.Font = Enum.Font.GothamBold;
    bx.ClearTextOnFocus = false;
    Instance.new("UICorner", bx).CornerRadius = UDim.new(0, 6);
    local bxs = Instance.new("UIStroke", bx);
    bxs.Color = T.accent;
    bxs.Thickness = 1;
    bxs.Transparency = 0.5;
    bx.FocusLost:Connect(function()
        local n = tonumber(bx.Text);
        if n then;
            bx.Text = tostring(n);
            if cb then pcall(cb, n); end;
        else;
            bx.Text = tostring(default);
        end;
    end);
    return r, bx;
end;

local function makeSlider(name, mn, mx, default, cb, parentOverride)
    local p = parentOverride or body;
    local r = Instance.new("Frame", p);
    r.Size = UDim2.new(1, 0, 0, 54);
    r.BackgroundColor3 = T.row;
    r.BorderSizePixel = 0;
    Instance.new("UICorner", r).CornerRadius = UDim.new(0, 8);
    local lb = Instance.new("TextLabel", r);
    lb.Size = UDim2.new(1, -20, 0, 20);
    lb.Position = UDim2.new(0, 12, 0, 4);
    lb.BackgroundTransparency = 1;
    lb.Text = name .. ": " .. default;
    lb.TextColor3 = T.text;
    lb.TextSize = 13;
    lb.Font = Enum.Font.Gotham;
    lb.TextXAlignment = Enum.TextXAlignment.Left;
    local bar = Instance.new("Frame", r);
    bar.Size = UDim2.new(1, -24, 0, 8);
    bar.Position = UDim2.new(0, 12, 0, 34);
    bar.BackgroundColor3 = T.off;
    bar.BorderSizePixel = 0;
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0);
    local fill = Instance.new("Frame", bar);
    fill.Size = UDim2.new((default - mn) / (mx - mn), 0, 1, 0);
    fill.BackgroundColor3 = T.accent;
    fill.BorderSizePixel = 0;
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0);
    local dg = false;
    local function upd(inp)
        local rel = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1);
        local v = math.floor(mn + (mx - mn) * rel);
        fill.Size = UDim2.new(rel, 0, 1, 0);
        lb.Text = name .. ": " .. v;
        if cb then pcall(cb, v); end;
    end;
    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then;
            dg = true;
            upd(inp);
        end;
    end);
    UIS.InputChanged:Connect(function(inp)
        if dg and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then;
            upd(inp);
        end;
    end);
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then;
            dg = false;
        end;
    end);
    return r;
end;

local tabs = {};
local tabContainers = {};
local currentTab = nil;

local function switchTab(name)
    for tName, tData in pairs(tabs) do;
        if tData.frame then tData.frame.Visible = false; end;
        if tData.btn then;
            tData.btn.BackgroundColor3 = T.off;
            tData.btn.TextColor3 = T.text;
        end;
    end;
    if tabs[name] then;
        tabs[name].frame.Visible = true;
        tabs[name].btn.BackgroundColor3 = T.accent;
        tabs[name].btn.TextColor3 = Color3.fromRGB(255, 255, 255);
        currentTab = name;
    end;
end;

local function createTab(name, label)
    local btn = Instance.new("TextButton", tabBar);
    btn.Size = UDim2.new(0, 44, 0, 26);
    btn.BackgroundColor3 = T.off;
    btn.Text = label or name;
    btn.TextColor3 = T.text;
    btn.TextSize = 10;
    btn.Font = Enum.Font.GothamBold;
    btn.LayoutOrder = #tabs + 1;
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6);
    local frame = Instance.new("Frame", body);
    frame.Size = UDim2.new(1, 0, 0, 0);
    frame.AutomaticSize = Enum.AutomaticSize.Y;
    frame.BackgroundTransparency = 1;
    frame.Visible = false;
    frame.LayoutOrder = 1;
    local fl = Instance.new("UIListLayout", frame);
    fl.Padding = UDim.new(0, 6);
    fl.SortOrder = Enum.SortOrder.LayoutOrder;
    tabs[name] = {btn = btn, frame = frame, label = label or name};
    tabContainers[name] = frame;
    btn.MouseButton1Click:Connect(function()
        switchTab(name);
    end);
    return frame;
end;

createTab("combat", "⚔");
createTab("visual", "👁");
createTab("movement", "🏃");
createTab("utility", "🔧");
createTab("teleport", "📍");
createTab("aimbot", "🎯");

switchTab("combat");

-- ===== WALLHACK (gabung Anti Fall) =====
local wallhackEnabled = false;
local floorCheckDistance = 60;
local savedCollide = {};
local lastGroundY = nil;
local flyEnabled = false;

local function findGroundBelow(char, hrp)
    local pr = RaycastParams.new();
    pr.FilterType = Enum.RaycastFilterType.Exclude;
    pr.FilterDescendantsInstances = {char};
    pr.IgnoreWater = true;
    local origin = hrp.Position + Vector3.new(0, 1, 0);
    local dir = Vector3.new(0, -(floorCheckDistance + 1), 0);
    local res = Workspace:Raycast(origin, dir, pr);
    if res and res.Instance then return true, res.Position.Y; end;
    local op = OverlapParams.new();
    op.FilterType = Enum.RaycastFilterType.Exclude;
    op.FilterDescendantsInstances = {char};
    op.MaxParts = 30;
    local cf1 = CFrame.new(hrp.Position - Vector3.new(0, 3, 0));
    local p1 = Workspace:GetPartBoundsInBox(cf1, Vector3.new(6, 8, 6), op);
    for _, pt in ipairs(p1) do;
        if pt.CanCollide and pt.Transparency < 1 then;
            return true, hrp.Position.Y;
        end;
    end;
    return false, nil;
end;

local function applyWallhack()
    local c = LP.Character;
    if not c then return; end;
    for _, p in ipairs(c:GetDescendants()) do;
        if p:IsA("BasePart") then;
            if savedCollide[p] == nil then savedCollide[p] = p.CanCollide; end;
            p.CanCollide = false;
        end;
    end;
end;

local function restoreWallhack()
    for p, v in pairs(savedCollide) do;
        if p.Parent then;
            pcall(function() p.CanCollide = v; end);
        end;
    end;
    savedCollide = {};
    lastGroundY = nil;
end;

RunService.Stepped:Connect(function()
    if not wallhackEnabled then return; end;
    local c = LP.Character;
    if not c then return; end;
    local hrp = c:FindFirstChild("HumanoidRootPart");
    if not hrp then return; end;
    for _, p in ipairs(c:GetDescendants()) do;
        if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false; end;
    end;
    if flyEnabled then return; end;
    local hasGround, groundY = findGroundBelow(c, hrp);
    if hasGround then;
        lastGroundY = groundY or hrp.Position.Y;
        return;
    end;
    if not lastGroundY then lastGroundY = hrp.Position.Y; end;
    local hoverY = lastGroundY + 3;
    if hrp.Position.Y <= hoverY + 0.5 then;
        hrp.CFrame = CFrame.new(hrp.Position.X, hoverY, hrp.Position.Z);
        local v = hrp.AssemblyLinearVelocity;
        hrp.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z);
        hrp.AssemblyAngularVelocity = Vector3.zero;
    end;
end);

-- ===== SPEED =====
local speedEnabled = false;
local currentSpeed = 100;
local speedConn;

local function applySpeed()
    local c = LP.Character;
    if not c then return; end;
    local h = c:FindFirstChildOfClass("Humanoid");
    if not h then return; end;
    h.WalkSpeed = currentSpeed;
    if speedConn then speedConn:Disconnect(); end;
    speedConn = h:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if speedEnabled and h.WalkSpeed ~= currentSpeed then;
            h.WalkSpeed = currentSpeed;
        end;
    end);
end;

-- ===== FLY =====
local flyConn, flyVel, flyAlign, flyAttach;
local savedWS = nil;
local savedJP = nil;

local upBtn = Instance.new("TextButton", screen);
upBtn.AnchorPoint = Vector2.new(1, 1);
upBtn.Size = UDim2.new(0, 54, 0, 54);
upBtn.Position = UDim2.new(1, -14, 1, -156);
upBtn.BackgroundColor3 = T.panel;
upBtn.Text = "▲";
upBtn.TextColor3 = T.accent;
upBtn.TextSize = 24;
upBtn.Font = Enum.Font.GothamBold;
upBtn.Visible = false;
upBtn.Active = true;
upBtn.AutoButtonColor = false;
upBtn.ZIndex = 250;
Instance.new("UICorner", upBtn).CornerRadius = UDim.new(1, 0);

local downBtn = Instance.new("TextButton", screen);
downBtn.AnchorPoint = Vector2.new(1, 1);
downBtn.Size = UDim2.new(0, 54, 0, 54);
downBtn.Position = UDim2.new(1, -14, 1, -94);
downBtn.BackgroundColor3 = T.panel;
downBtn.Text = "▼";
downBtn.TextColor3 = T.accent;
downBtn.TextSize = 24;
downBtn.Font = Enum.Font.GothamBold;
downBtn.Visible = false;
downBtn.Active = true;
downBtn.AutoButtonColor = false;
downBtn.ZIndex = 250;
Instance.new("UICorner", downBtn).CornerRadius = UDim.new(1, 0);

local upPressed = false;
local downPressed = false;

upBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then;
        upPressed = true;
        upBtn.BackgroundColor3 = T.accent;
        upBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
    end;
end);
upBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then;
        upPressed = false;
        upBtn.BackgroundColor3 = T.panel;
        upBtn.TextColor3 = T.accent;
    end;
end);
downBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then;
        downPressed = true;
        downBtn.BackgroundColor3 = T.accent;
        downBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
    end;
end);
downBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then;
        downPressed = false;
        downBtn.BackgroundColor3 = T.panel;
        downBtn.TextColor3 = T.accent;
    end;
end);

local function getAnalogMove()
    local c = LP.Character;
    if not c then return Vector3.zero; end;
    local h = c:FindFirstChildOfClass("Humanoid");
    if not h then return Vector3.zero; end;
    local md = h.MoveDirection;
    if md.Magnitude > 0.05 then return md.Unit; end;
    local mv = Vector3.zero;
    if UIS:IsKeyDown(Enum.KeyCode.W) then mv = mv + Vector3.new(0, 0, -1); end;
    if UIS:IsKeyDown(Enum.KeyCode.S) then mv = mv + Vector3.new(0, 0, 1); end;
    if UIS:IsKeyDown(Enum.KeyCode.A) then mv = mv + Vector3.new(-1, 0, 0); end;
    if UIS:IsKeyDown(Enum.KeyCode.D) then mv = mv + Vector3.new(1, 0, 0); end;
    if mv.Magnitude < 0.05 then return Vector3.zero; end;
    local cam = Workspace.CurrentCamera;
    if not cam then return Vector3.zero; end;
    local ccf = cam.CFrame;
    local fw = ccf.LookVector;
    local rt = ccf.RightVector;
    local ff = Vector3.new(fw.X, 0, fw.Z);
    if ff.Magnitude < 0.01 then ff = Vector3.new(0, 0, -1); end;
    ff = ff.Unit;
    local fr = Vector3.new(rt.X, 0, rt.Z);
    if fr.Magnitude < 0.01 then fr = ff:Cross(Vector3.new(0, 1, 0)); end;
    fr = fr.Unit;
    local wm = (ff * -mv.Z) + (fr * mv.X);
    if wm.Magnitude > 0.01 then return wm.Unit; end;
    return Vector3.zero;
end;

local function getFlyVertical()
    if UIS:IsKeyDown(Enum.KeyCode.Space) then return 1; end;
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then return -1; end;
    if upPressed then return 1; end;
    if downPressed then return -1; end;
    return 0;
end;

local function getCurrentSpeed()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid");
    if h then return h.WalkSpeed; end;
    return 16;
end;

local function checkCollision(char, fromPos, toPos)
    if wallhackEnabled then return false; end;
    local pr = RaycastParams.new();
    pr.FilterType = Enum.RaycastFilterType.Exclude;
    pr.FilterDescendantsInstances = {char};
    pr.IgnoreWater = true;
    local dir = toPos - fromPos;
    local dist = dir.Magnitude;
    if dist < 0.01 then return false; end;
    local res = Workspace:Raycast(fromPos, dir.Unit * dist, pr);
    if res and res.Instance then;
        if res.Instance.CanCollide then return true; end;
    end;
    return false;
end;

local function stopFly()
    flyEnabled = false;
    if flyConn then flyConn:Disconnect(); flyConn = nil; end;
    if flyVel then pcall(function() flyVel:Destroy(); end); flyVel = nil; end;
    if flyAlign then pcall(function() flyAlign:Destroy(); end); flyAlign = nil; end;
    if flyAttach then pcall(function() flyAttach:Destroy(); end); flyAttach = nil; end;
    upPressed = false;
    downPressed = false;
    upBtn.Visible = false;
    downBtn.Visible = false;
    local c = LP.Character;
    if c then;
        local h = c:FindFirstChildOfClass("Humanoid");
        if h then;
            if savedWS then h.WalkSpeed = savedWS; end;
            if savedJP then h.JumpPower = savedJP; end;
            h.PlatformStand = false;
            pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp); end);
        end;
        local hrp = c:FindFirstChild("HumanoidRootPart");
        if hrp then hrp.AssemblyLinearVelocity = Vector3.zero; end;
    end;
    savedWS = nil;
    savedJP = nil;
end;

local function startFly()
    flyEnabled = true;
    local c = LP.Character;
    if not c then return; end;
    local hrp = c:FindFirstChild("HumanoidRootPart");
    if not hrp then return; end;
    local h = c:FindFirstChildOfClass("Humanoid");
    if not h then return; end;
    savedWS = h.WalkSpeed;
    savedJP = h.JumpPower;
    h.WalkSpeed = 0;
    h.JumpPower = 0;
    pcall(function() h:ChangeState(Enum.HumanoidStateType.Physics); end);
    flyAttach = Instance.new("Attachment");
    flyAttach.Name = "vanzFlyAttach";
    flyAttach.Parent = hrp;
    flyAlign = Instance.new("AlignOrientation");
    flyAlign.Mode = Enum.OrientationAlignmentMode.OneAttachment;
    flyAlign.Attachment0 = flyAttach;
    flyAlign.MaxTorque = 1e8;
    flyAlign.Responsiveness = 100;
    flyAlign.Parent = hrp;
    flyVel = Instance.new("LinearVelocity");
    flyVel.Attachment0 = flyAttach;
    flyVel.MaxForce = 1e8;
    flyVel.VectorVelocity = Vector3.zero;
    flyVel.RelativeTo = Enum.ActuatorRelativeTo.World;
    flyVel.Parent = hrp;
    upBtn.Visible = true;
    downBtn.Visible = true;
    flyConn = RunService.RenderStepped:Connect(function(dt)
        if not flyEnabled then return; end;
        local cc = LP.Character;
        if not cc then return; end;
        local root = cc:FindFirstChild("HumanoidRootPart");
        if not root then return; end;
        if not flyVel or not flyVel.Parent then return; end;
        if not flyAlign or not flyAlign.Parent then return; end;
        local mv = getAnalogMove();
        local vr = getFlyVertical();
        local sp = getCurrentSpeed();
        if sp <= 0 then sp = 16; end;
        local fm = mv;
        if vr ~= 0 then;
            fm = Vector3.new(mv.X, 0, mv.Z) + Vector3.new(0, vr, 0);
            if fm.Magnitude > 0.01 then fm = fm.Unit; end;
        end;
        flyVel.VectorVelocity = fm * sp;
        local cam = Workspace.CurrentCamera;
        if cam then flyAlign.CFrame = cam.CFrame; end;
    end);
end;

-- ===== ESP =====
local espEnabled = false;
local espData = {};

local function findBestEspPart(char)
    if not char then return nil; end;
    local pri = {"HumanoidRootPart", "UpperTorso", "Torso", "Head", "LowerTorso", "HipHeight"};
    for _, n in ipairs(pri) do;
        local p = char:FindFirstChild(n);
        if p and p:IsA("BasePart") then return p; end;
    end;
    for _, p in ipairs(char:GetDescendants()) do;
        if p:IsA("BasePart") then return p; end;
    end;
    return nil;
end;

local function findHeadPart(char)
    if not char then return nil; end;
    local hd = char:FindFirstChild("Head");
    if hd and hd:IsA("BasePart") then return hd; end;
    for _, p in ipairs(char:GetDescendants()) do;
        if p:IsA("BasePart") and p.Name:lower():find("head") then return p; end;
    end;
    return nil;
end;

local function createESPTag(plr)
    if espData[plr] then return; end;
    local char = plr.Character;
    if not char then return; end;
    local hrp = findBestEspPart(char);
    local hd = findHeadPart(char);
    local h = char:FindFirstChildOfClass("Humanoid");
    if not hrp or not h then return; end;
    local col = getPlayerColor(plr);
    local box = Instance.new("BoxHandleAdornment");
    box.Name = "vanzESPBox";
    box.Adornee = hrp;
    box.AlwaysOnTop = true;
    box.ZIndex = 4;
    box.Size = Vector3.new(2, 5, 1) + Vector3.new(0.2, 0.2, 0.2);
    box.Transparency = 0.5;
    box.Color3 = col;
    box.Parent = hrp;
    local hl = Instance.new("Highlight");
    hl.Name = "vanzESPHL";
    hl.Adornee = char;
    hl.FillColor = col;
    hl.FillTransparency = 0.6;
    hl.OutlineColor = col;
    hl.OutlineTransparency = 0.2;
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    hl.Parent = char;
    local bb = Instance.new("BillboardGui");
    bb.Name = "vanzESPBB";
    bb.Size = UDim2.new(0, 160, 0, 50);
    bb.StudsOffset = Vector3.new(0, 3.2, 0);
    bb.AlwaysOnTop = true;
    bb.Parent = hd or hrp;
    local nl = Instance.new("TextLabel", bb);
    nl.Size = UDim2.new(1, 0, 0, 16);
    nl.BackgroundTransparency = 1;
    nl.Text = plr.DisplayName .. " (@" .. plr.Name .. ")";
    nl.TextColor3 = col;
    nl.TextStrokeTransparency = 0;
    nl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
    nl.TextSize = 12;
    nl.Font = Enum.Font.GothamBold;
    local hb = Instance.new("Frame", bb);
    hb.Size = UDim2.new(1, 0, 0, 6);
    hb.Position = UDim2.new(0, 0, 0, 20);
    hb.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    hb.BorderSizePixel = 0;
    Instance.new("UICorner", hb).CornerRadius = UDim.new(1, 0);
    local hf = Instance.new("Frame", hb);
    hf.Size = UDim2.new(1, 0, 1, 0);
    hf.BackgroundColor3 = Color3.fromRGB(80, 220, 120);
    hf.BorderSizePixel = 0;
    Instance.new("UICorner", hf).CornerRadius = UDim.new(1, 0);
    local ht = Instance.new("TextLabel", bb);
    ht.Size = UDim2.new(1, 0, 0, 14);
    ht.Position = UDim2.new(0, 0, 0, 28);
    ht.BackgroundTransparency = 1;
    ht.Text = "100 / 100";
    ht.TextColor3 = Color3.fromRGB(200, 240, 210);
    ht.TextStrokeTransparency = 0;
    ht.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
    ht.TextSize = 11;
    ht.Font = Enum.Font.Gotham;
    local line = Instance.new("Frame", screen);
    line.Name = "vanzESPLine_" .. plr.Name;
    line.BackgroundColor3 = col;
    line.BorderSizePixel = 0;
    line.ZIndex = 2;
    line.Size = UDim2.new(0, 0, 0, 1);
    espData[plr] = {
        box = box;
        hl = hl;
        bb = bb;
        line = line;
        nameLbl = nl;
        hf = hf;
        ht = ht;
        lastColor = col;
        lastChar = char;
    };
end;

local function destroyESPTag(plr)
    local d = espData[plr];
    if not d then return; end;
    pcall(function() d.box:Destroy(); end);
    pcall(function() d.hl:Destroy(); end);
    pcall(function() d.bb:Destroy(); end);
    pcall(function() d.line:Destroy(); end);
    espData[plr] = nil;
end;

local function clearAllESP()
    for plr, _ in pairs(espData) do destroyESPTag(plr); end;
    espData = {};
end;

local function refreshESP()
    for _, plr in ipairs(Players:GetPlayers()) do;
        if plr ~= LP then;
            if plr.Character then;
                local h = plr.Character:FindFirstChildOfClass("Humanoid");
                if h and h.Health > 0 then;
                    if not espData[plr] then;
                        createESPTag(plr);
                    elseif espData[plr].lastChar ~= plr.Character then;
                        destroyESPTag(plr);
                        task.wait();
                        createESPTag(plr);
                    end;
                else;
                    if espData[plr] then destroyESPTag(plr); end;
                end;
            elseif espData[plr] then;
                destroyESPTag(plr);
            end;
        end;
    end;
end;

Players.PlayerAdded:Connect(function(plr)
    task.wait(1);
    if espEnabled then refreshESP(); end;
    plr.CharacterAdded:Connect(function()
        task.wait(0.8);
        if espEnabled then;
            destroyESPTag(plr);
            refreshESP();
        end;
    end);
end);

Players.PlayerRemoving:Connect(function(plr)
    destroyESPTag(plr);
end);

task.spawn(function()
    while true do;
        task.wait(1);
        if espEnabled then refreshESP(); end;
    end;
end);

RunService.RenderStepped:Connect(function()
    if not espEnabled then return; end;
    local cam = Workspace.CurrentCamera;
    if not cam then return; end;
    local ox = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y);
    for plr, d in pairs(espData) do;
        local char = plr.Character;
        if char then;
            local hrp = findBestEspPart(char);
            local hd = findHeadPart(char);
            local h = char:FindFirstChildOfClass("Humanoid");
            if hrp and h then;
                if d.lastChar ~= char then;
                    d.lastChar = char;
                    pcall(function() d.hl.Adornee = char; end);
                    pcall(function() d.bb.Parent = hd or hrp; end);
                end;
                local col = getPlayerColor(plr);
                if col ~= d.lastColor then;
                    d.lastColor = col;
                    pcall(function() d.box.Color3 = col; end);
                    pcall(function()
                        d.hl.FillColor = col;
                        d.hl.OutlineColor = col;
                    end);
                    pcall(function()
                        d.nameLbl.TextColor3 = col;
                        d.line.BackgroundColor3 = col;
                    end);
                end;
                d.box.Adornee = hrp;
                local pct = math.clamp(h.Health / math.max(h.MaxHealth, 1), 0, 1);
                d.hf.Size = UDim2.new(pct, 0, 1, 0);
                d.hf.BackgroundColor3 = Color3.fromRGB(math.floor(255 * (1 - pct)), math.floor(220 * pct), 80);
                d.ht.Text = math.floor(h.Health) .. " / " .. math.floor(h.MaxHealth);
                d.nameLbl.Text = plr.DisplayName .. " (@" .. plr.Name .. ")";
                local pos, os = cam:WorldToViewportPoint(hrp.Position);
                if os and pos.Z > 0 then;
                    d.line.Visible = true;
                    local tg = Vector2.new(pos.X, pos.Y);
                    local df = tg - ox;
                    local ln = df.Magnitude;
                    local an = math.deg(math.atan2(df.Y, df.X));
                    d.line.Position = UDim2.new(0, ox.X, 0, ox.Y);
                    d.line.Size = UDim2.new(0, ln, 0, 1);
                    d.line.Rotation = an;
                else;
                    d.line.Visible = false;
                end;
            end;
        end;
    end;
end);

-- ===== AIMBOT =====
local aimbotEnabled = false;
local aimbotPOV = 60;
local aimbotConn = nil;
local aimbotCircleFrame = nil;
local aimbotTarget = nil;
local aimbotLocked = false;
local aimbotLastCamCF = nil;
local aimbotOutOfConeTimer = 0;
local aimbotTeamSafe = true;

local function createAimbotCircle()
    local circle = Instance.new("Frame", screen);
    circle.Name = "vanzAimbotCircle";
    circle.AnchorPoint = Vector2.new(0.5, 0.5);
    circle.Position = UDim2.new(0.5, 0, 0.5, 0);
    circle.BackgroundTransparency = 1;
    circle.BorderSizePixel = 0;
    circle.Size = UDim2.new(0, 100, 0, 100);
    circle.Visible = false;
    circle.ZIndex = 3;
    aimbotCircleFrame = circle;
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0);
    local st = Instance.new("UIStroke", circle);
    st.Color = CA;
    st.Thickness = 2;
    st.Transparency = 0.15;
    local dot = Instance.new("Frame", circle);
    dot.AnchorPoint = Vector2.new(0.5, 0.5);
    dot.Size = UDim2.new(0, 10, 0, 10);
    dot.Position = UDim2.new(0.5, 0, 0.5, 0);
    dot.BackgroundColor3 = CA;
    dot.BorderSizePixel = 0;
    dot.ZIndex = 5;
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0);
end;

local function updateAimbotCircleVisual()
    if not aimbotCircleFrame then return; end;
    local cam = Workspace.CurrentCamera;
    if not cam then return; end;
    local vp = cam.ViewportSize;
    local bs = math.min(vp.X, vp.Y);
    local rp = (aimbotPOV / 360) * bs * 1.1;
    if rp < 40 then rp = 40; end;
    aimbotCircleFrame.Size = UDim2.new(0, rp * 2, 0, rp * 2);
end;

local function getBodyPartPos(char, partName)
    if not char then return nil; end;
    if partName == "Kepala" then;
        local hd = char:FindFirstChild("Head");
        if hd and hd:IsA("BasePart") then return hd.Position; end;
    elseif partName == "Leher" then;
        local hd = char:FindFirstChild("Head");
        if hd and hd:IsA("BasePart") then return hd.Position - Vector3.new(0, 0.5, 0); end;
    elseif partName == "Badan" then;
        local ut = char:FindFirstChild("UpperTorso");
        if ut and ut:IsA("BasePart") then return ut.Position; end;
        local to = char:FindFirstChild("Torso");
        if to and to:IsA("BasePart") then return to.Position; end;
    elseif partName == "Paha" then;
        local ul = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("RightUpperLeg");
        if ul and ul:IsA("BasePart") then return ul.Position; end;
        local lt = char:FindFirstChild("LowerTorso");
        if lt and lt:IsA("BasePart") then return lt.Position - Vector3.new(0, 1, 0); end;
    elseif partName == "Kaki" then;
        local ft = char:FindFirstChild("LeftFoot") or char:FindFirstChild("RightFoot");
        if ft and ft:IsA("BasePart") then return ft.Position; end;
        local ll = char:FindFirstChild("LeftLowerLeg") or char:FindFirstChild("RightLowerLeg");
        if ll and ll:IsA("BasePart") then return ll.Position; end;
        local hrp = char:FindFirstChild("HumanoidRootPart");
        if hrp and hrp:IsA("BasePart") then return hrp.Position - Vector3.new(0, 2.5, 0); end;
    end;
    local hrp = findBestEspPart(char);
    if hrp then return hrp.Position + Vector3.new(0, 1.5, 0); end;
    return nil;
end;

local function getTargetInCone()
    local cam = Workspace.CurrentCamera;
    if not cam then return nil; end;
    local mc = LP.Character;
    if not mc then return nil; end;
    local mh = mc:FindFirstChild("HumanoidRootPart");
    if not mh then return nil; end;
    local cl = cam.CFrame.LookVector;
    local ha = aimbotPOV / 2;
    local bt = nil;
    local bd = math.huge;
    for _, plr in ipairs(Players:GetPlayers()) do;
        if plr ~= LP and plr.Character then;
            local skip = false;
            if aimbotTeamSafe and isTeam(plr) then skip = true; end;
            if not skip then;
                local h = plr.Character:FindFirstChildOfClass("Humanoid");
                if h and h.Health > 0 then;
                    local tp = findBestEspPart(plr.Character);
                    if tp then;
                        local tt = tp.Position - cam.CFrame.Position;
                        local dst = tt.Magnitude;
                        if dst > 0.1 then;
                            local dt = cl:Dot(tt.Unit);
                            local ag = math.deg(math.acos(math.clamp(dt, -1, 1)));
                            if ag <= ha and dst < bd then;
                                bd = dst;
                                bt = plr;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    return bt;
end;

local function isTargetInCone(plr)
    if not plr or not plr.Character then return false; end;
    local cam = Workspace.CurrentCamera;
    if not cam then return false; end;
    local tp = findBestEspPart(plr.Character);
    if not tp then return false; end;
    local tt = tp.Position - cam.CFrame.Position;
    if tt.Magnitude < 0.1 then return true; end;
    local cl = cam.CFrame.LookVector;
    local dt = cl:Dot(tt.Unit);
    local ag = math.deg(math.acos(math.clamp(dt, -1, 1)));
    return ag <= aimbotPOV / 2;
end;

local function startAimbot()
    aimbotEnabled = true;
    if aimbotCircleFrame then aimbotCircleFrame.Visible = true; end;
    updateAimbotCircleVisual();
    aimbotLastCamCF = Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame or nil;
    if aimbotConn then aimbotConn:Disconnect(); end;
    aimbotConn = RunService.RenderStepped:Connect(function(dt)
        if not aimbotEnabled then return; end;
        local cam = Workspace.CurrentCamera;
        if not cam then return; end;
        local mc = LP.Character;
        if not mc then return; end;
        local mh = mc:FindFirstChild("HumanoidRootPart");
        if not mh then return; end;
        if aimbotLastCamCF then;
            local cur = cam.CFrame.LookVector;
            local lst = aimbotLastCamCF.LookVector;
            local dt2 = cur:Dot(lst);
            local ag = math.deg(math.acos(math.clamp(dt2, -1, 1)));
            if ag > 10.5 then;
                aimbotLocked = false;
                aimbotTarget = nil;
                aimbotOutOfConeTimer = 0;
            end;
        end;
        aimbotLastCamCF = cam.CFrame;
        if not aimbotLocked then;
            local tg = getTargetInCone();
            if tg then;
                aimbotTarget = tg;
                aimbotLocked = true;
                aimbotOutOfConeTimer = 0;
            end;
        end;
        if aimbotLocked and aimbotTarget then;
            local tc = aimbotTarget.Character;
            if not tc then;
                aimbotLocked = false;
                aimbotTarget = nil;
                return;
            end;
            local th = tc:FindFirstChildOfClass("Humanoid");
            if not th or th.Health <= 0 then;
                aimbotLocked = false;
                aimbotTarget = nil;
                return;
            end;
            if not isTargetInCone(aimbotTarget) then;
                aimbotOutOfConeTimer = aimbotOutOfConeTimer + dt;
                if aimbotOutOfConeTimer > 0.3 then;
                    aimbotLocked = false;
                    aimbotTarget = nil;
                    aimbotOutOfConeTimer = 0;
                    return;
                end;
            else;
                aimbotOutOfConeTimer = 0;
            end;
            local bp2 = _G._vanzAimbotBodyPart or "Kepala";
            local tp = getBodyPartPos(aimbotTarget.Character, bp2);
            if not tp then;
                aimbotLocked = false;
                aimbotTarget = nil;
                return;
            end;
            local cp = cam.CFrame.Position;
            cam.CFrame = CFrame.new(cp, tp);
        end;
    end);
end;

local function stopAimbot()
    aimbotEnabled = false;
    if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil; end;
    if aimbotCircleFrame then aimbotCircleFrame.Visible = false; end;
    aimbotTarget = nil;
    aimbotLocked = false;
    aimbotOutOfConeTimer = 0;
end;

-- ===== ANTI RAGDOLL =====
local antiRagdollEnabled = false;
local antiRagdollConn = nil;

local function startAntiRagdoll()
    antiRagdollEnabled = true;
    if antiRagdollConn then antiRagdollConn:Disconnect(); end;
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return; end;
        local c = LP.Character;
        if not c then return; end;
        local h = c:FindFirstChildOfClass("Humanoid");
        if not h then return; end;
        if h.PlatformStand then h.PlatformStand = false; end;
        local s = h:GetState();
        if s == Enum.HumanoidStateType.FallingDown or s == Enum.HumanoidStateType.Ragdoll or s == Enum.HumanoidStateType.Physics then;
            pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp); end);
        end;
        pcall(function()
            h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
            h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false);
        end);
    end);
end;

local function stopAntiRagdoll()
    antiRagdollEnabled = false;
    if antiRagdollConn then antiRagdollConn:Disconnect(); antiRagdollConn = nil; end;
    local c = LP.Character;
    if c then;
        local h = c:FindFirstChildOfClass("Humanoid");
        if h then;
            pcall(function()
                h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true);
                h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true);
            end);
        end;
    end;
end;

-- ===== FULLBRIGHT =====
local fullbrightEnabled = false;
local fullbrightLevel = 3;
local fullbrightSaved = {};

local function applyFullbright()
    if not fullbrightEnabled then return; end;
    Lighting.Brightness = fullbrightLevel;
    local amb = math.clamp(fullbrightLevel / 10, 0, 1);
    Lighting.Ambient = Color3.fromRGB(255 * amb, 255 * amb, 255 * amb);
    Lighting.OutdoorAmbient = Color3.fromRGB(255 * amb, 255 * amb, 255 * amb);
    Lighting.ClockTime = 12;
    Lighting.FogEnd = 100000;
    Lighting.FogStart = 100000;
    Lighting.GlobalShadows = false;
end;

-- ===== SERVER HOP =====
local function hopToServer(mode)
    local PlaceId = game.PlaceId;
    local JobId = game.JobId;
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true";
    local ok, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url));
    end);
    if not ok or not response or not response.data or #response.data == 0 then;
        pcall(function() TeleportService:Teleport(PlaceId, LP); end);
        return false;
    end;
    local servers = {};
    for _, srv in ipairs(response.data) do;
        if srv.id ~= JobId and srv.playing ~= nil and srv.maxPlayers ~= nil then;
            table.insert(servers, {id = srv.id, playing = srv.playing, maxPlayers = srv.maxPlayers});
        end;
    end;
    if #servers == 0 then;
        pcall(function() TeleportService:Teleport(PlaceId, LP); end);
        return false;
    end;
    local chosen = nil;
    if mode == "crowded" then;
        table.sort(servers, function(a, b) return a.playing > b.playing; end);
        for _, srv in ipairs(servers) do;
            if srv.playing < srv.maxPlayers then;
                chosen = srv;
                break;
            end;
        end;
        if not chosen then chosen = servers[1]; end;
    else;
        table.sort(servers, function(a, b) return a.playing < b.playing; end);
        for _, srv in ipairs(servers) do;
            if srv.playing >= 1 and srv.playing < srv.maxPlayers then;
                chosen = srv;
                break;
            end;
        end;
        if not chosen then chosen = servers[1]; end;
    end;
    if chosen then;
        local success, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(PlaceId, chosen.id, LP);
        end);
        if not success then;
            pcall(function() TeleportService:Teleport(PlaceId, LP); end);
        end;
        return true;
    end;
    pcall(function() TeleportService:Teleport(PlaceId, LP); end);
    return false;
end;

-- ===== WAYPOINT =====
local waypointMarked = false;
local waypointPos = nil;
local waypointSavedCFrame = nil;
local waypointSavedAnchored = nil;
local waypointMarkerPart = nil;
local waypointMarkerHL = nil;
local waypointMarkerBox = nil;
local waypointMarkerSphere = nil;
local waypointMarkerBB = nil;
local waypointMarkerLine = nil;

local function createWaypointMarker(pos)
    local mp = Instance.new("Part");
    mp.Name = "vanzWaypointMarker";
    mp.Size = Vector3.new(2, 5, 1);
    mp.Position = pos;
    mp.Anchored = true;
    mp.CanCollide = false;
    mp.CanQuery = false;
    mp.CanTouch = false;
    mp.Transparency = 0.75;
    mp.Color = Color3.fromRGB(80, 220, 255);
    mp.Material = Enum.Material.Neon;
    mp.Parent = Workspace;
    waypointMarkerPart = mp;
    local hl = Instance.new("Highlight");
    hl.Adornee = mp;
    hl.FillColor = Color3.fromRGB(80, 220, 255);
    hl.FillTransparency = 0.5;
    hl.OutlineColor = Color3.fromRGB(255, 255, 255);
    hl.OutlineTransparency = 0;
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    hl.Parent = mp;
    waypointMarkerHL = hl;
    local box = Instance.new("BoxHandleAdornment");
    box.Adornee = mp;
    box.AlwaysOnTop = true;
    box.ZIndex = 8;
    box.Size = Vector3.new(2.2, 5.2, 1.2);
    box.Transparency = 0.3;
    box.Color3 = Color3.fromRGB(255, 255, 255);
    box.Parent = mp;
    waypointMarkerBox = box;
    local sph = Instance.new("SphereHandleAdornment");
    sph.Adornee = mp;
    sph.AlwaysOnTop = true;
    sph.ZIndex = 7;
    sph.Radius = 1.5;
    sph.Transparency = 0.6;
    sph.Color3 = Color3.fromRGB(80, 220, 255);
    sph.Parent = mp;
    waypointMarkerSphere = sph;
    local bb = Instance.new("BillboardGui");
    bb.Size = UDim2.new(0, 160, 0, 40);
    bb.StudsOffset = Vector3.new(0, 4, 0);
    bb.AlwaysOnTop = true;
    bb.Parent = mp;
    waypointMarkerBB = bb;
    local lbl = Instance.new("TextLabel", bb);
    lbl.Size = UDim2.new(1, 0, 0, 22);
    lbl.BackgroundTransparency = 1;
    lbl.Text = "◈ WAYPOINT";
    lbl.TextColor3 = Color3.fromRGB(80, 220, 255);
    lbl.TextStrokeTransparency = 0;
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
    lbl.TextSize = 16;
    lbl.Font = Enum.Font.GothamBold;
    local sub = Instance.new("TextLabel", bb);
    sub.Size = UDim2.new(1, 0, 0, 16);
    sub.Position = UDim2.new(0, 0, 0, 22);
    sub.BackgroundTransparency = 1;
    sub.Text = "titik waypoint kamu";
    sub.TextColor3 = Color3.fromRGB(200, 230, 240);
    sub.TextStrokeTransparency = 0.3;
    sub.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
    sub.TextSize = 11;
    sub.Font = Enum.Font.Gotham;
    local line = Instance.new("Frame", screen);
    line.BackgroundColor3 = Color3.fromRGB(80, 220, 255);
    line.BorderSizePixel = 0;
    line.ZIndex = 5;
    line.Size = UDim2.new(0, 0, 0, 2);
    waypointMarkerLine = line;
end;

local function destroyWaypointMarker()
    if waypointMarkerPart then pcall(function() waypointMarkerPart:Destroy(); end); waypointMarkerPart = nil; end;
    if waypointMarkerHL then pcall(function() waypointMarkerHL:Destroy(); end); waypointMarkerHL = nil; end;
    if waypointMarkerBox then pcall(function() waypointMarkerBox:Destroy(); end); waypointMarkerBox = nil; end;
    if waypointMarkerSphere then pcall(function() waypointMarkerSphere:Destroy(); end); waypointMarkerSphere = nil; end;
    if waypointMarkerBB then pcall(function() waypointMarkerBB:Destroy(); end); waypointMarkerBB = nil; end;
    if waypointMarkerLine then pcall(function() waypointMarkerLine:Destroy(); end); waypointMarkerLine = nil; end;
end;

local function markWaypoint()
    local char = LP.Character;
    if not char then return; end;
    local hrp = char:FindFirstChild("HumanoidRootPart");
    if not hrp then return; end;
    destroyWaypointMarker();
    waypointPos = hrp.Position;
    createWaypointMarker(waypointPos);
    waypointMarked = true;
    task.spawn(function()
        while waypointMarked and waypointMarkerLine and waypointMarkerLine.Parent do;
            task.wait();
            local cam = Workspace.CurrentCamera;
            if cam and waypointPos then;
                local origin = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y);
                local pos2, on2 = cam:WorldToViewportPoint(waypointPos);
                if on2 and pos2.Z > 0 then;
                    waypointMarkerLine.Visible = true;
                    local target = Vector2.new(pos2.X, pos2.Y);
                    local diff = target - origin;
                    local length = diff.Magnitude;
                    local angle = math.deg(math.atan2(diff.Y, diff.X));
                    waypointMarkerLine.Position = UDim2.new(0, origin.X, 0, origin.Y);
                    waypointMarkerLine.Size = UDim2.new(0, length, 0, 2);
                    waypointMarkerLine.Rotation = angle;
                else;
                    waypointMarkerLine.Visible = false;
                end;
            else;
                break;
            end;
        end;
    end);
end;

local function clearWaypoint()
    waypointMarked = false;
    waypointPos = nil;
    destroyWaypointMarker();
end;

local function teleportToWaypoint()
    if not waypointPos then return; end;
    local char = LP.Character;
    if not char then return; end;
    local hrp = char:FindFirstChild("HumanoidRootPart");
    if not hrp then return; end;
    hrp.CFrame = CFrame.new(waypointPos + Vector3.new(0, 3, 0));
    hrp.AssemblyLinearVelocity = Vector3.zero;
    hrp.AssemblyAngularVelocity = Vector3.zero;
end;

-- ===== TELEPORT =====
local teleportSelected = nil;
local teleportListFrame = nil;
local teleportPlayerRows = {};
local followEnabled = false;
local followConn = nil;

local teleportV2Enabled = false;
local teleportV2SavedCFrame = nil;
local teleportV2SavedAnchored = nil;
local teleportV2SavedWalkSpeed = nil;
local teleportV2SavedJumpPower = nil;
local teleportV2Conn = nil;
local teleportV2PhantomPos = nil;
local teleportV2OriginPos = nil;
local teleportV2MarkerPart = nil;
local teleportV2MarkerHL = nil;
local teleportV2MarkerBox = nil;
local teleportV2MarkerSphere = nil;
local teleportV2MarkerBB = nil;
local teleportV2MarkerLine = nil;
local flyWasActiveWhenTp2Started = false;

local function createOriginMarker(originPos)
    local mp = Instance.new("Part");
    mp.Name = "vanzOriginMarker";
    mp.Size = Vector3.new(2, 5, 1);
    mp.Position = originPos;
    mp.Anchored = true;
    mp.CanCollide = false;
    mp.CanQuery = false;
    mp.CanTouch = false;
    mp.Transparency = 0.75;
    mp.Color = Color3.fromRGB(180, 80, 255);
    mp.Material = Enum.Material.Neon;
    mp.Parent = Workspace;
    teleportV2MarkerPart = mp;
    local hl = Instance.new("Highlight");
    hl.Adornee = mp;
    hl.FillColor = Color3.fromRGB(180, 80, 255);
    hl.FillTransparency = 0.5;
    hl.OutlineColor = Color3.fromRGB(255, 200, 80);
    hl.OutlineTransparency = 0;
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    hl.Parent = mp;
    teleportV2MarkerHL = hl;
    local box = Instance.new("BoxHandleAdornment");
    box.Adornee = mp;
    box.AlwaysOnTop = true;
    box.ZIndex = 8;
    box.Size = Vector3.new(2.2, 5.2, 1.2);
    box.Transparency = 0.3;
    box.Color3 = Color3.fromRGB(255, 200, 80);
    box.Parent = mp;
    teleportV2MarkerBox = box;
    local sph = Instance.new("SphereHandleAdornment");
    sph.Adornee = mp;
    sph.AlwaysOnTop = true;
    sph.ZIndex = 7;
    sph.Radius = 1.5;
    sph.Transparency = 0.6;
    sph.Color3 = Color3.fromRGB(180, 80, 255);
    sph.Parent = mp;
    teleportV2MarkerSphere = sph;
    local bb = Instance.new("BillboardGui");
    bb.Size = UDim2.new(0, 140, 0, 40);
    bb.StudsOffset = Vector3.new(0, 4, 0);
    bb.AlwaysOnTop = true;
    bb.Parent = mp;
    teleportV2MarkerBB = bb;
    local lbl = Instance.new("TextLabel", bb);
    lbl.Size = UDim2.new(1, 0, 0, 22);
    lbl.BackgroundTransparency = 1;
    lbl.Text = "♡ ORIGIN";
    lbl.TextColor3 = Color3.fromRGB(255, 200, 80);
    lbl.TextStrokeTransparency = 0;
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
    lbl.TextSize = 16;
    lbl.Font = Enum.Font.GothamBold;
    local sub = Instance.new("TextLabel", bb);
    sub.Size = UDim2.new(1, 0, 0, 16);
    sub.Position = UDim2.new(0, 0, 0, 22);
    sub.BackgroundTransparency = 1;
    sub.Text = "posisi asli kamu";
    sub.TextColor3 = Color3.fromRGB(200, 200, 220);
    sub.TextStrokeTransparency = 0.3;
    sub.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
    sub.TextSize = 11;
    sub.Font = Enum.Font.Gotham;
    local line = Instance.new("Frame", screen);
    line.BackgroundColor3 = Color3.fromRGB(180, 80, 255);
    line.BorderSizePixel = 0;
    line.ZIndex = 5;
    line.Size = UDim2.new(0, 0, 0, 1);
    teleportV2MarkerLine = line;
end;

local function destroyOriginMarker()
    if teleportV2MarkerPart then pcall(function() teleportV2MarkerPart:Destroy(); end); end;
    if teleportV2MarkerHL then pcall(function() teleportV2MarkerHL:Destroy(); end); end;
    if teleportV2MarkerBox then pcall(function() teleportV2MarkerBox:Destroy(); end); end;
    if teleportV2MarkerSphere then pcall(function() teleportV2MarkerSphere:Destroy(); end); end;
    if teleportV2MarkerBB then pcall(function() teleportV2MarkerBB:Destroy(); end); end;
    if teleportV2MarkerLine then pcall(function() teleportV2MarkerLine:Destroy(); end); end;
    teleportV2MarkerPart = nil;
    teleportV2MarkerHL = nil;
    teleportV2MarkerBox = nil;
    teleportV2MarkerSphere = nil;
    teleportV2MarkerBB = nil;
    teleportV2MarkerLine = nil;
end;

local function stopTeleportV2()
    if not teleportV2Enabled then return; end;
    teleportV2Enabled = false;
    if teleportV2Conn then teleportV2Conn:Disconnect(); teleportV2Conn = nil; end;
    local char = LP.Character;
    if char then;
        local hrp = char:FindFirstChild("HumanoidRootPart");
        if hrp then;
            if teleportV2PhantomPos then hrp.CFrame = CFrame.new(teleportV2PhantomPos); end;
            hrp.Anchored = false;
            hrp.AssemblyLinearVelocity = Vector3.zero;
            hrp.AssemblyAngularVelocity = Vector3.zero;
        end;
        local hum = char:FindFirstChildOfClass("Humanoid");
        if hum then;
            hum.PlatformStand = false;
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false); end);
            if teleportV2SavedWalkSpeed then hum.WalkSpeed = teleportV2SavedWalkSpeed; else hum.WalkSpeed = 16; end;
            if teleportV2SavedJumpPower then hum.JumpPower = teleportV2SavedJumpPower; end;
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp); end);
            task.wait(0.1);
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running); end);
        end;
    end;
    upPressed = false;
    downPressed = false;
    destroyOriginMarker();
    local flyRestart = flyWasActiveWhenTp2Started;
    flyWasActiveWhenTp2Started = false;
    if flyRestart and flyEnabled then;
        task.wait(0.15);
        startFly();
    end;
    teleportV2SavedCFrame = nil;
    teleportV2SavedAnchored = nil;
    teleportV2SavedWalkSpeed = nil;
    teleportV2SavedJumpPower = nil;
    teleportV2PhantomPos = nil;
    teleportV2OriginPos = nil;
end;

local function startTeleportV2()
    local char = LP.Character;
    if not char then return; end;
    local hrp = char:FindFirstChild("HumanoidRootPart");
    if not hrp then return; end;
    local hum = char:FindFirstChildOfClass("Humanoid");
    if not hum then return; end;
    flyWasActiveWhenTp2Started = flyEnabled;
    if flyEnabled then;
        if flyConn then flyConn:Disconnect(); flyConn = nil; end;
        if flyVel then pcall(function() flyVel:Destroy(); end); flyVel = nil; end;
        if flyAlign then pcall(function() flyAlign:Destroy(); end); flyAlign = nil; end;
        if flyAttach then pcall(function() flyAttach:Destroy(); end); flyAttach = nil; end;
    end;
    teleportV2Enabled = true;
    teleportV2SavedCFrame = hrp.CFrame;
    teleportV2SavedAnchored = hrp.Anchored;
    teleportV2SavedWalkSpeed = hum.WalkSpeed;
    teleportV2SavedJumpPower = hum.JumpPower;
    teleportV2PhantomPos = hrp.Position;
    teleportV2OriginPos = hrp.Position;
    createOriginMarker(teleportV2OriginPos);
    hrp.Anchored = true;
    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true);
        hum:ChangeState(Enum.HumanoidStateType.Physics);
    end);
    if teleportV2Conn then teleportV2Conn:Disconnect(); end;
    teleportV2Conn = RunService.RenderStepped:Connect(function(dt)
        if not teleportV2Enabled then return; end;
        local c = LP.Character;
        if not c then return; end;
        local root = c:FindFirstChild("HumanoidRootPart");
        if not root then return; end;
        local h = c:FindFirstChildOfClass("Humanoid");
        if not h then return; end;
        local move = getAnalogMove();
        local vertical = getFlyVertical();
        local speed = getCurrentSpeed();
        if speed <= 0 then speed = 16; end;
        local fm = move;
        if vertical ~= 0 then;
            fm = Vector3.new(move.X, 0, move.Z) + Vector3.new(0, vertical, 0);
            if fm.Magnitude > 0.01 then fm = fm.Unit; end;
        end;
        if fm.Magnitude < 0.01 then return; end;
        local distance = speed * dt;
        local fromPos = teleportV2PhantomPos;
        local toPos = fromPos + fm * distance;
        if checkCollision(c, fromPos, toPos) then return; end;
        teleportV2PhantomPos = toPos;
        root.CFrame = CFrame.new(toPos) * (root.CFrame - root.Position);
    end);
    if teleportV2MarkerLine then;
        task.spawn(function()
            while teleportV2Enabled do;
                task.wait();
                local cam = Workspace.CurrentCamera;
                if cam and teleportV2MarkerLine and teleportV2MarkerLine.Parent then;
                    local origin = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y);
                    local phantomPos = teleportV2PhantomPos;
                    if phantomPos and teleportV2OriginPos then;
                        local pos1, on1 = cam:WorldToViewportPoint(phantomPos);
                        local pos2, on2 = cam:WorldToViewportPoint(teleportV2OriginPos);
                        if on1 and on2 and pos1.Z > 0 and pos2.Z > 0 then;
                            teleportV2MarkerLine.Visible = true;
                            local target = Vector2.new(pos2.X, pos2.Y);
                            local diff = target - origin;
                            local length = diff.Magnitude;
                            local angle = math.deg(math.atan2(diff.Y, diff.X));
                            teleportV2MarkerLine.Position = UDim2.new(0, origin.X, 0, origin.Y);
                            teleportV2MarkerLine.Size = UDim2.new(0, length, 0, 2);
                            teleportV2MarkerLine.Rotation = angle;
                        else;
                            teleportV2MarkerLine.Visible = false;
                        end;
                    end;
                end;
            end;
        end);
    end;
end;

local function getBehindPosition(targetHrp, dist)
    if not targetHrp then return nil; end;
    local lk = targetHrp.CFrame.LookVector;
    local fl = Vector3.new(lk.X, 0, lk.Z);
    if fl.Magnitude < 0.01 then fl = Vector3.new(0, 0, -1); end;
    fl = fl.Unit;
    return targetHrp.Position - fl * dist + Vector3.new(0, 2, 0);
end;

local function teleportToPlayer(plr)
    if not plr then return; end;
    local tc = plr.Character;
    if not tc then return; end;
    local th = findBestEspPart(tc);
    if not th then return; end;
    local mc = LP.Character;
    if not mc then return; end;
    local mh = mc:FindFirstChild("HumanoidRootPart");
    if not mh then return; end;
    local dst = getBehindPosition(th, 4);
    if not dst then return; end;
    mh.CFrame = CFrame.new(dst);
end;

local function stopFollow()
    followEnabled = false;
    if followConn then followConn:Disconnect(); followConn = nil; end;
end;

local function startFollow()
    if followConn then followConn:Disconnect(); followConn = nil; end;
    followConn = RunService.RenderStepped:Connect(function()
        if not followEnabled then return; end;
        if not teleportSelected then return; end;
        local tc = teleportSelected.Character;
        if not tc then return; end;
        local th = findBestEspPart(tc);
        if not th then return; end;
        local mc = LP.Character;
        if not mc then return; end;
        local mh = mc:FindFirstChild("HumanoidRootPart");
        if not mh then return; end;
        local dst = getBehindPosition(th, 4);
        if not dst then return; end;
        mh.CFrame = CFrame.new(dst);
    end);
end;

local function refreshTeleportList()
    if not teleportListFrame then return; end;
    for _, row in pairs(teleportPlayerRows) do;
        pcall(function() row:Destroy(); end);
    end;
    teleportPlayerRows = {};
    if teleportSelected and teleportSelected.Parent == nil then;
        teleportSelected = nil;
        stopFollow();
    end;
    for _, plr in ipairs(Players:GetPlayers()) do;
        if plr ~= LP then;
            local row = Instance.new("TextButton");
            row.Size = UDim2.new(1, 0, 0, 34);
            row.BackgroundColor3 = T.row;
            row.BorderSizePixel = 0;
            row.Text = "  " .. plr.DisplayName .. "  (@" .. plr.Name .. ")";
            row.TextColor3 = T.text;
            row.TextSize = 12;
            row.Font = Enum.Font.Gotham;
            row.TextXAlignment = Enum.TextXAlignment.Left;
            row.AutoButtonColor = true;
            row.ZIndex = 2;
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6);
            row.Parent = teleportListFrame;
            teleportPlayerRows[plr] = row;
            row.MouseButton1Click:Connect(function()
                teleportSelected = plr;
                for p, r in pairs(teleportPlayerRows) do;
                    if p == plr then;
                        r.BackgroundColor3 = T.sel;
                        r.TextColor3 = Color3.fromRGB(255, 255, 255);
                    else;
                        r.BackgroundColor3 = T.row;
                        r.TextColor3 = T.text;
                    end;
                end;
            end);
        end;
    end;
    if teleportSelected and teleportPlayerRows[teleportSelected] then;
        teleportPlayerRows[teleportSelected].BackgroundColor3 = T.sel;
        teleportPlayerRows[teleportSelected].TextColor3 = Color3.fromRGB(255, 255, 255);
    end;
end;

Players.PlayerAdded:Connect(function()
    task.wait(0.5);
    refreshTeleportList();
end);

Players.PlayerRemoving:Connect(function(plr)
    if teleportSelected == plr then;
        teleportSelected = nil;
        stopFollow();
    end;
    task.wait(0.1);
    refreshTeleportList();
end);

task.spawn(function()
    while true do;
        task.wait(0.5);
        refreshTeleportList();
    end;
end);

-- ===== BUILD UI =====

local cb = tabContainers["combat"];
makeInfo("Combat: Anti-Ragdoll", cb);
makeToggle("Anti Ragdoll", false, function(state)
    if state then startAntiRagdoll(); else stopAntiRagdoll(); end;
end, cb);

local vb = tabContainers["visual"];
makeInfo("Visual: ESP + Fullbright", vb);
makeToggle("ESP", false, function(state)
    espEnabled = state;
    if state then refreshESP(); else clearAllESP(); end;
end, vb);
makeToggle("Fullbright", false, function(state)
    if state then;
        fullbrightEnabled = true;
        fullbrightSaved.Brightness = Lighting.Brightness;
        fullbrightSaved.Ambient = Lighting.Ambient;
        fullbrightSaved.OutdoorAmbient = Lighting.OutdoorAmbient;
        fullbrightSaved.ClockTime = Lighting.ClockTime;
        fullbrightSaved.FogEnd = Lighting.FogEnd;
        fullbrightSaved.FogStart = Lighting.FogStart;
        fullbrightSaved.GlobalShadows = Lighting.GlobalShadows;
        applyFullbright();
    else;
        fullbrightEnabled = false;
        if fullbrightSaved.Brightness then Lighting.Brightness = fullbrightSaved.Brightness; end;
        if fullbrightSaved.Ambient then Lighting.Ambient = fullbrightSaved.Ambient; end;
        if fullbrightSaved.OutdoorAmbient then Lighting.OutdoorAmbient = fullbrightSaved.OutdoorAmbient; end;
        if fullbrightSaved.ClockTime then Lighting.ClockTime = fullbrightSaved.ClockTime; end;
        if fullbrightSaved.FogEnd then Lighting.FogEnd = fullbrightSaved.FogEnd; end;
        if fullbrightSaved.FogStart then Lighting.FogStart = fullbrightSaved.FogStart; end;
        if fullbrightSaved.GlobalShadows ~= nil then Lighting.GlobalShadows = fullbrightSaved.GlobalShadows; end;
    end;
end, vb);
makeSlider("Brightness", 0, 10, 3, function(val)
    fullbrightLevel = val;
    if fullbrightEnabled then applyFullbright(); end;
end, vb);

local mb = tabContainers["movement"];
makeInfo("Movement: Wallhack (auto anti-fall), Speed, Jump, Fly", mb);
makeToggle("Wallhack", false, function(state)
    wallhackEnabled = state;
    if state then applyWallhack(); else restoreWallhack(); end;
end, mb);
makeToggle("Speed Hack", false, function(state)
    speedEnabled = state;
    local c = LP.Character;
    if not c then return; end;
    local h = c:FindFirstChildOfClass("Humanoid");
    if not h then return; end;
    if state then;
        applySpeed();
    else;
        if speedConn then speedConn:Disconnect(); speedConn = nil; end;
        h.WalkSpeed = 16;
    end;
end, mb);
makeNum("Speed", 100, function(num)
    currentSpeed = num;
    if speedEnabled then applySpeed(); end;
end, mb);
local infJump = false;
UIS.JumpRequest:Connect(function()
    if infJump then;
        local c = LP.Character;
        if c then;
            local h = c:FindFirstChildOfClass("Humanoid");
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping); end;
        end;
    end;
end);
makeToggle("Infinite Jump", false, function(state)
    infJump = state;
end, mb);
makeToggle("Fly", false, function(state)
    if state then startFly(); else stopFly(); end;
end, mb);

local ub = tabContainers["utility"];
makeInfo("Utility: Teleport V2 + Server Hop", ub);
makeToggle("Teleport V2", false, function(state)
    if state then;
        if followEnabled then stopFollow(); end;
        startTeleportV2();
    else;
        stopTeleportV2();
    end;
end, ub);

local hopInfo = Instance.new("TextLabel", ub);
hopInfo.Size = UDim2.new(1, 0, 0, 44);
hopInfo.BackgroundColor3 = T.row;
hopInfo.Text = "Server Hop: Ramai = player terbanyak yang masih bisa masuk.\nSepi = player paling sedikit (min 1).";
hopInfo.TextColor3 = T.dim;
hopInfo.TextSize = 10;
hopInfo.Font = Enum.Font.Gotham;
hopInfo.TextWrapped = true;
Instance.new("UICorner", hopInfo).CornerRadius = UDim.new(0, 6);

makeButton("🔥 HOP RAMAI", function()
    hopToServer("crowded");
end, ub);

makeButton("❄ HOP SEPI", function()
    hopToServer("empty");
end, ub);

local tpb = tabContainers["teleport"];
local tLabel = Instance.new("TextLabel", tpb);
tLabel.Size = UDim2.new(1, 0, 0, 20);
tLabel.BackgroundTransparency = 1;
tLabel.Text = "Player List (pilih satu):";
tLabel.TextColor3 = T.dim;
tLabel.TextSize = 11;
tLabel.Font = Enum.Font.Gotham;
tLabel.TextXAlignment = Enum.TextXAlignment.Left;

local tFrame = Instance.new("Frame", tpb);
tFrame.Size = UDim2.new(1, 0, 0, 160);
tFrame.BackgroundColor3 = T.bg;
tFrame.BorderSizePixel = 0;
tFrame.ClipsDescendants = true;
Instance.new("UICorner", tFrame).CornerRadius = UDim.new(0, 8);

local ls2 = Instance.new("ScrollingFrame", tFrame);
ls2.Size = UDim2.new(1, -8, 1, -8);
ls2.Position = UDim2.new(0, 4, 0, 4);
ls2.BackgroundTransparency = 1;
ls2.BorderSizePixel = 0;
ls2.ScrollBarThickness = 4;
ls2.ScrollBarImageColor3 = T.accent;
ls2.CanvasSize = UDim2.new(0, 0, 0, 0);
ls2.AutomaticCanvasSize = Enum.AutomaticSize.Y;

local ll2 = Instance.new("UIListLayout", ls2);
ll2.Padding = UDim.new(0, 4);
ll2.SortOrder = Enum.SortOrder.LayoutOrder;

teleportListFrame = ls2;

local tpBtn = Instance.new("TextButton", tpb);
tpBtn.Size = UDim2.new(1, 0, 0, 40);
tpBtn.BackgroundColor3 = T.accent;
tpBtn.Text = "TELEPORT";
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
tpBtn.TextSize = 14;
tpBtn.Font = Enum.Font.GothamBold;
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 8);
tpBtn.MouseButton1Click:Connect(function()
    if teleportSelected then;
        pcall(function() teleportToPlayer(teleportSelected); end);
    end;
end);

makeToggle("Follow", false, function(state)
    followEnabled = state;
    if state then;
        if teleportSelected then startFollow(); else followEnabled = false; end;
    else;
        stopFollow();
    end;
end, tpb);

makeInfo("Waypoint: tandai posisi kamu, teleport balik kapan aja", tpb);
makeToggle("Waypoint (Mark)", false, function(state)
    if state then;
        markWaypoint();
    else;
        clearWaypoint();
    end;
end, tpb);
makeButton("◈ TELEPORT KE WAYPOINT", function()
    teleportToWaypoint();
end, tpb);

local ab = tabContainers["aimbot"];
makeInfo("Aimbot: lock brutal ke body part", ab);
makeToggle("Aimbot", false, function(state)
    if state then startAimbot(); else stopAimbot(); end;
end, ab);
makeToggle("Team Safe (Aimbot)", true, function(state)
    aimbotTeamSafe = state;
end, ab);
makeSlider("POV", 5, 360, 60, function(val)
    aimbotPOV = val;
    updateAimbotCircleVisual();
end, ab);

local bpSelector = Instance.new("Frame", ab);
bpSelector.Size = UDim2.new(1, 0, 0, 70);
bpSelector.BackgroundColor3 = T.row;
bpSelector.BorderSizePixel = 0;
Instance.new("UICorner", bpSelector).CornerRadius = UDim.new(0, 8);
local bptitle = Instance.new("TextLabel", bpSelector);
bptitle.Size = UDim2.new(1, -20, 0, 20);
bptitle.Position = UDim2.new(0, 10, 0, 4);
bptitle.BackgroundTransparency = 1;
bptitle.Text = "Lock Target:";
bptitle.TextColor3 = T.dim;
bptitle.TextSize = 11;
bptitle.Font = Enum.Font.Gotham;
bptitle.TextXAlignment = Enum.TextXAlignment.Left;
local bpRow = Instance.new("Frame", bpSelector);
bpRow.Size = UDim2.new(1, -16, 0, 34);
bpRow.Position = UDim2.new(0, 8, 0, 28);
bpRow.BackgroundTransparency = 1;
local bpLayout = Instance.new("UIListLayout", bpRow);
bpLayout.FillDirection = Enum.FillDirection.Horizontal;
bpLayout.Padding = UDim.new(0, 4);
local bpOptions = {"Kepala", "Leher", "Badan", "Paha", "Kaki"};
local bpButtons = {};
local function setBPSelected(idx)
    for i, b in ipairs(bpButtons) do;
        if i == idx then;
            b.BackgroundColor3 = T.accent;
            b.TextColor3 = Color3.fromRGB(255, 255, 255);
        else;
            b.BackgroundColor3 = T.off;
            b.TextColor3 = T.text;
        end;
    end;
    _G._vanzAimbotBodyPart = bpOptions[idx];
end;
for i, label in ipairs(bpOptions) do;
    local btn = Instance.new("TextButton", bpRow);
    btn.Size = UDim2.new(0, 46, 0, 30);
    btn.BackgroundColor3 = (i == 1) and T.accent or T.off;
    btn.Text = label;
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or T.text;
    btn.TextSize = 10;
    btn.Font = Enum.Font.GothamBold;
    btn.LayoutOrder = i;
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6);
    bpButtons[i] = btn;
    btn.MouseButton1Click:Connect(function()
        setBPSelected(i);
    end);
end;
_G._vanzAimbotBodyPart = "Kepala";

createAimbotCircle();

LP.CharacterAdded:Connect(function()
    savedCollide = {};
    lastGroundY = nil;
    task.wait(0.2);
    if wallhackEnabled then applyWallhack(); end;
    if speedEnabled and currentSpeed then;
        task.wait(0.1);
        local c = LP.Character;
        local h = c and c:FindFirstChildOfClass("Humanoid");
        if h then h.WalkSpeed = currentSpeed; end;
    end;
    if flyEnabled then;
        task.wait(0.3);
        if flyEnabled then;
            stopFly();
            startFly();
        end;
    end;
    if teleportV2Enabled then stopTeleportV2(); end;
end);

task.wait(0.5);
refreshTeleportList();

pcall(function()
    if setthreadidentity then setthreadidentity(8); end;
end);

print("[vanz] Slim menu + Waypoint");