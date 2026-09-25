-- vanz
_G.vanz = _G.vanz or {}

-- BLOCK 1: SETUP
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local LP = Players.LocalPlayer

    for _, n in ipairs({"vanzSlimMenu"}) do
        pcall(function()
            if gethui then
                local h = gethui()
                local o = h:FindFirstChild(n)
                if o then o:Destroy() end
            end
        end)
        pcall(function()
            local o = CoreGui:FindFirstChild(n)
            if o then o:Destroy() end
        end)
        pcall(function()
            local o = LP.PlayerGui:FindFirstChild(n)
            if o then o:Destroy() end
        end)
    end

    local parentGui = LP:WaitForChild("PlayerGui")
    pcall(function()
        if gethui then
            local h = gethui()
            if h then parentGui = h end
        end
    end)

    _G.vanz.Players = Players
    _G.vanz.RunService = RunService
    _G.vanz.UIS = UIS
    _G.vanz.Workspace = Workspace
    _G.vanz.Lighting = Lighting
    _G.vanz.HttpService = HttpService
    _G.vanz.TeleportService = TeleportService
    _G.vanz.LP = LP
    _G.vanz.parentGui = parentGui
    _G.vanz.T = {
        bg = Color3.fromRGB(16, 14, 20),
        panel = Color3.fromRGB(26, 22, 32),
        row = Color3.fromRGB(34, 28, 42),
        accent = Color3.fromRGB(255, 90, 140),
        text = Color3.fromRGB(235, 225, 240),
        dim = Color3.fromRGB(150, 135, 165),
        on = Color3.fromRGB(90, 205, 130),
        off = Color3.fromRGB(70, 60, 82),
        sel = Color3.fromRGB(255, 90, 140),
    }
    _G.vanz.CT = Color3.fromRGB(60, 140, 255)
    _G.vanz.CE = Color3.fromRGB(255, 60, 60)
    _G.vanz.CU = Color3.fromRGB(180, 180, 180)
    _G.vanz.CA = Color3.fromRGB(255, 40, 40)
    _G.vanz._vanzAimbotBodyPart = "Kepala"
end

-- BLOCK 2: UI BASE
do
    local LP = _G.vanz.LP
    local T = _G.vanz.T
    local parentGui = _G.vanz.parentGui

    local screen = Instance.new("ScreenGui")
    screen.Name = "vanzSlimMenu"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 999999
    screen.Enabled = true
    screen.Parent = parentGui

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Size = UDim2.new(0, 280, 0.85, 0)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.BackgroundColor3 = T.bg
    main.BorderSizePixel = 0
    main.Active = true
    main.Visible = true
    main.ZIndex = 10
    main.Parent = screen

    local msc = Instance.new("UISizeConstraint", main)
    msc.MaxSize = Vector2.new(300, 720)
    msc.MinSize = Vector2.new(260, 300)

    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
    local ms = Instance.new("UIStroke", main)
    ms.Color = T.accent
    ms.Thickness = 1.5
    ms.Transparency = 0.3

    local tb = Instance.new("Frame", main)
    tb.Size = UDim2.new(1, 0, 0, 40)
    tb.BackgroundColor3 = T.panel
    tb.BorderSizePixel = 0
    tb.ZIndex = 11
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 14)

    local tfix = Instance.new("Frame", tb)
    tfix.Size = UDim2.new(1, 0, 0, 14)
    tfix.Position = UDim2.new(0, 0, 1, -14)
    tfix.BackgroundColor3 = T.panel
    tfix.BorderSizePixel = 0
    tfix.ZIndex = 11

    local tt = Instance.new("TextLabel", tb)
    tt.Size = UDim2.new(1, -20, 1, 0)
    tt.Position = UDim2.new(0, 14, 0, 0)
    tt.BackgroundTransparency = 1
    tt.Text = "vanz slim"
    tt.TextColor3 = T.accent
    tt.TextSize = 16
    tt.Font = Enum.Font.GothamBold
    tt.TextXAlignment = Enum.TextXAlignment.Left
    tt.ZIndex = 12

    local tabBar = Instance.new("Frame", main)
    tabBar.Size = UDim2.new(1, -12, 0, 32)
    tabBar.Position = UDim2.new(0, 6, 0, 44)
    tabBar.BackgroundColor3 = T.panel
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 11
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8)

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 2)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local body = Instance.new("ScrollingFrame", main)
    body.Size = UDim2.new(1, -20, 1, -90)
    body.Position = UDim2.new(0, 10, 0, 82)
    body.BackgroundTransparency = 1
    body.BorderSizePixel = 0
    body.ScrollBarThickness = 6
    body.ScrollBarImageColor3 = T.accent
    body.CanvasSize = UDim2.new(0, 0, 0, 0)
    body.AutomaticCanvasSize = Enum.AutomaticSize.Y
    body.ScrollingDirection = Enum.ScrollingDirection.Y
    body.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    body.ZIndex = 11

    local bl = Instance.new("UIListLayout", body)
    bl.Padding = UDim.new(0, 6)
    bl.SortOrder = Enum.SortOrder.LayoutOrder

    local bpd = Instance.new("UIPadding", body)
    bpd.PaddingTop = UDim.new(0, 4)
    bpd.PaddingBottom = UDim.new(0, 16)
    bpd.PaddingRight = UDim.new(0, 6)

    local minBtn = Instance.new("TextButton", main)
    minBtn.AnchorPoint = Vector2.new(0, 0.5)
    minBtn.Size = UDim2.new(0, 36, 0, 36)
    minBtn.Position = UDim2.new(1, 8, 0.5, 0)
    minBtn.BackgroundColor3 = T.accent
    minBtn.Text = "-"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.TextSize = 20
    minBtn.Font = Enum.Font.GothamBold
    minBtn.ZIndex = 50
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)
    local mbs = Instance.new("UIStroke", minBtn)
    mbs.Color = T.bg
    mbs.Thickness = 2
    mbs.Transparency = 0.3

    local logo = Instance.new("TextButton", screen)
    logo.AnchorPoint = Vector2.new(0.5, 0)
    logo.Size = UDim2.new(0, 58, 0, 58)
    logo.Position = UDim2.new(0.5, 0, 0, 12)
    logo.BackgroundColor3 = T.bg
    logo.Text = "o"
    logo.TextColor3 = T.accent
    logo.TextSize = 28
    logo.Font = Enum.Font.GothamBold
    logo.Visible = false
    logo.Active = true
    logo.ZIndex = 100
    Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)
    local ls = Instance.new("UIStroke", logo)
    ls.Color = T.accent
    ls.Thickness = 2
    ls.Transparency = 0.2

    minBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        logo.Visible = true
    end)
    logo.MouseButton1Click:Connect(function()
        logo.Visible = false
        main.Visible = true
    end)

    _G.vanz.screen = screen
    _G.vanz.main = main
    _G.vanz.tabBar = tabBar
    _G.vanz.body = body

    local function getPlayerColor(plr)
        if plr == LP then return _G.vanz.CT end
        if LP.Team and plr.Team then
            if plr.Team == LP.Team then return _G.vanz.CT else return _G.vanz.CE end
        end
        if LP.TeamColor and plr.TeamColor then
            if plr.TeamColor == LP.TeamColor then return _G.vanz.CT else return _G.vanz.CE end
        end
        return _G.vanz.CU
    end

    local function isTeam(plr)
        if plr == LP then return true end
        if LP.Team and plr.Team then return plr.Team == LP.Team end
        if LP.TeamColor and plr.TeamColor then return plr.TeamColor == LP.TeamColor end
        return false
    end

    _G.vanz.getPlayerColor = getPlayerColor
    _G.vanz.isTeam = isTeam
end

-- BLOCK 3: CORE FEATURES
do
    local Players = _G.vanz.Players
    local RunService = _G.vanz.RunService
    local UIS = _G.vanz.UIS
    local Workspace = _G.vanz.Workspace
    local Lighting = _G.vanz.Lighting
    local HttpService = _G.vanz.HttpService
    local TeleportService = _G.vanz.TeleportService
    local LP = _G.vanz.LP
    local T = _G.vanz.T

    local wallhackEnabled = false
    local savedCollide = {}
    local lastGroundY = nil
    local flyEnabled = false
    local floorCheckDistance = 60

    local function findGroundBelow(char, hrp)
        local pr = RaycastParams.new()
        pr.FilterType = Enum.RaycastFilterType.Exclude
        pr.FilterDescendantsInstances = {char}
        pr.IgnoreWater = true
        local origin = hrp.Position + Vector3.new(0, 1, 0)
        local dir = Vector3.new(0, -(floorCheckDistance + 1), 0)
        local res = Workspace:Raycast(origin, dir, pr)
        if res and res.Instance then return true, res.Position.Y end
        return false, nil
    end

    local function applyWallhack()
        local c = LP.Character
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then
                if savedCollide[p] == nil then savedCollide[p] = p.CanCollide end
                p.CanCollide = false
            end
        end
    end

    local function restoreWallhack()
        for p, v in pairs(savedCollide) do
            if p.Parent then pcall(function() p.CanCollide = v end) end
        end
        savedCollide = {}
        lastGroundY = nil
    end

    RunService.Stepped:Connect(function()
        if not wallhackEnabled then return end
        local c = LP.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
        if flyEnabled then return end
        local hasGround, groundY = findGroundBelow(c, hrp)
        if hasGround then
            lastGroundY = groundY or hrp.Position.Y
            return
        end
        if not lastGroundY then lastGroundY = hrp.Position.Y end
        local hoverY = lastGroundY + 3
        if hrp.Position.Y <= hoverY + 0.5 then
            hrp.CFrame = CFrame.new(hrp.Position.X, hoverY, hrp.Position.Z)
            local v = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z)
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end)

    local speedEnabled = false
    local currentSpeed = 100
    local speedConn

    local function applySpeed()
        local c = LP.Character
        if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        if not h then return end
        h.WalkSpeed = currentSpeed
        if speedConn then speedConn:Disconnect() end
        speedConn = h:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if speedEnabled and h.WalkSpeed ~= currentSpeed then h.WalkSpeed = currentSpeed end
        end)
    end

    local flyConn, flyVel, flyAlign, flyAttach
    local savedWS, savedJP
    local upPressed, downPressed = false, false

    local upBtn = Instance.new("TextButton", _G.vanz.screen)
    upBtn.AnchorPoint = Vector2.new(1, 1)
    upBtn.Size = UDim2.new(0, 54, 0, 54)
    upBtn.Position = UDim2.new(1, -14, 1, -156)
    upBtn.BackgroundColor3 = T.panel
    upBtn.Text = "U"
    upBtn.TextColor3 = T.accent
    upBtn.TextSize = 24
    upBtn.Font = Enum.Font.GothamBold
    upBtn.Visible = false
    upBtn.Active = true
    upBtn.AutoButtonColor = false
    upBtn.ZIndex = 250
    Instance.new("UICorner", upBtn).CornerRadius = UDim.new(1, 0)

    local downBtn = Instance.new("TextButton", _G.vanz.screen)
    downBtn.AnchorPoint = Vector2.new(1, 1)
    downBtn.Size = UDim2.new(0, 54, 0, 54)
    downBtn.Position = UDim2.new(1, -14, 1, -94)
    downBtn.BackgroundColor3 = T.panel
    downBtn.Text = "D"
    downBtn.TextColor3 = T.accent
    downBtn.TextSize = 24
    downBtn.Font = Enum.Font.GothamBold
    downBtn.Visible = false
    downBtn.Active = true
    downBtn.AutoButtonColor = false
    downBtn.ZIndex = 250
    Instance.new("UICorner", downBtn).CornerRadius = UDim.new(1, 0)

    upBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            upPressed = true
            upBtn.BackgroundColor3 = T.accent
            upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
    upBtn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            upPressed = false
            upBtn.BackgroundColor3 = T.panel
            upBtn.TextColor3 = T.accent
        end
    end)
    downBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            downPressed = true
            downBtn.BackgroundColor3 = T.accent
            downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
    downBtn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            downPressed = false
            downBtn.BackgroundColor3 = T.panel
            downBtn.TextColor3 = T.accent
        end
    end)

    local function getAnalogMove()
        local c = LP.Character
        if not c then return Vector3.zero end
        local h = c:FindFirstChildOfClass("Humanoid")
        if not h then return Vector3.zero end
        local md = h.MoveDirection
        if md.Magnitude > 0.05 then return md.Unit end
        local mv = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then mv = mv + Vector3.new(0, 0, -1) end
        if UIS:IsKeyDown(Enum.KeyCode.S) then mv = mv + Vector3.new(0, 0, 1) end
        if UIS:IsKeyDown(Enum.KeyCode.A) then mv = mv + Vector3.new(-1, 0, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.D) then mv = mv + Vector3.new(1, 0, 0) end
        if mv.Magnitude < 0.05 then return Vector3.zero end
        local cam = Workspace.CurrentCamera
        if not cam then return Vector3.zero end
        local ccf = cam.CFrame
        local fw = ccf.LookVector
        local rt = ccf.RightVector
        local ff = Vector3.new(fw.X, 0, fw.Z)
        if ff.Magnitude < 0.01 then ff = Vector3.new(0, 0, -1) end
        ff = ff.Unit
        local fr = Vector3.new(rt.X, 0, rt.Z)
        if fr.Magnitude < 0.01 then fr = ff:Cross(Vector3.new(0, 1, 0)) end
        fr = fr.Unit
        local wm = (ff * -mv.Z) + (fr * mv.X)
        if wm.Magnitude > 0.01 then return wm.Unit end
        return Vector3.zero
    end

    local function getFlyVertical()
        if UIS:IsKeyDown(Enum.KeyCode.Space) then return 1 end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then return -1 end
        if upPressed then return 1 end
        if downPressed then return -1 end
        return 0
    end

    local function getCurrentSpeed()
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then return h.WalkSpeed end
        return 16
    end

    local function stopFly()
        flyEnabled = false
        if flyConn then flyConn:Disconnect() flyConn = nil end
        if flyVel then pcall(function() flyVel:Destroy() end) flyVel = nil end
        if flyAlign then pcall(function() flyAlign:Destroy() end) flyAlign = nil end
        if flyAttach then pcall(function() flyAttach:Destroy() end) flyAttach = nil end
        upPressed = false
        downPressed = false
        upBtn.Visible = false
        downBtn.Visible = false
        local c = LP.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h then
                if savedWS then h.WalkSpeed = savedWS end
                if savedJP then h.JumpPower = savedJP end
                h.PlatformStand = false
                pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
        end
        savedWS = nil
        savedJP = nil
    end

    local function startFly()
        flyEnabled = true
        local c = LP.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        if not h then return end
        savedWS = h.WalkSpeed
        savedJP = h.JumpPower
        h.WalkSpeed = 0
        h.JumpPower = 0
        pcall(function() h:ChangeState(Enum.HumanoidStateType.Physics) end)
        flyAttach = Instance.new("Attachment")
        flyAttach.Parent = hrp
        flyAlign = Instance.new("AlignOrientation")
        flyAlign.Mode = Enum.OrientationAlignmentMode.OneAttachment
        flyAlign.Attachment0 = flyAttach
        flyAlign.MaxTorque = 1e8
        flyAlign.Responsiveness = 100
        flyAlign.Parent = hrp
        flyVel = Instance.new("LinearVelocity")
        flyVel.Attachment0 = flyAttach
        flyVel.MaxForce = 1e8
        flyVel.VectorVelocity = Vector3.zero
        flyVel.RelativeTo = Enum.ActuatorRelativeTo.World
        flyVel.Parent = hrp
        upBtn.Visible = true
        downBtn.Visible = true
        flyConn = RunService.RenderStepped:Connect(function(dt)
            if not flyEnabled then return end
            local cc = LP.Character
            if not cc then return end
            local root = cc:FindFirstChild("HumanoidRootPart")
            if not root then return end
            if not flyVel or not flyVel.Parent then return end
            if not flyAlign or not flyAlign.Parent then return end
            local mv = getAnalogMove()
            local vr = getFlyVertical()
            local sp = getCurrentSpeed()
            if sp <= 0 then sp = 16 end
            local fm = mv
            if vr ~= 0 then
                fm = Vector3.new(mv.X, 0, mv.Z) + Vector3.new(0, vr, 0)
                if fm.Magnitude > 0.01 then fm = fm.Unit end
            end
            flyVel.VectorVelocity = fm * sp
            local cam = Workspace.CurrentCamera
            if cam then flyAlign.CFrame = cam.CFrame end
        end)
    end

    local espEnabled = false
    local espData = {}

    local function findBestEspPart(char)
        if not char then return nil end
        local pri = {"HumanoidRootPart", "UpperTorso", "Torso", "Head"}
        for _, n in ipairs(pri) do
            local p = char:FindFirstChild(n)
            if p and p:IsA("BasePart") then return p end
        end
        return nil
    end

    local function findHeadPart(char)
        if not char then return nil end
        return char:FindFirstChild("Head")
    end

    local function createESPTag(plr)
        if espData[plr] then return end
        local char = plr.Character
        if not char then return end
        local hrp = findBestEspPart(char)
        local h = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not h then return end
        local col = _G.vanz.getPlayerColor(plr)
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 4
        box.Size = Vector3.new(2, 5, 1)
        box.Transparency = 0.5
        box.Color3 = col
        box.Parent = hrp
        local hl = Instance.new("Highlight")
        hl.Adornee = char
        hl.FillColor = col
        hl.FillTransparency = 0.6
        hl.OutlineColor = col
        hl.OutlineTransparency = 0.2
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 160, 0, 20)
        bb.StudsOffset = Vector3.new(0, 3.2, 0)
        bb.AlwaysOnTop = true
        bb.Parent = findHeadPart(char) or hrp
        local nl = Instance.new("TextLabel", bb)
        nl.Size = UDim2.new(1, 0, 1, 0)
        nl.BackgroundTransparency = 1
        nl.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
        nl.TextColor3 = col
        nl.TextStrokeTransparency = 0
        nl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nl.TextSize = 12
        nl.Font = Enum.Font.GothamBold
        espData[plr] = {box = box, hl = hl, bb = bb, lastColor = col}
    end

    local function destroyESPTag(plr)
        local d = espData[plr]
        if not d then return end
        pcall(function() d.box:Destroy() end)
        pcall(function() d.hl:Destroy() end)
        pcall(function() d.bb:Destroy() end)
        espData[plr] = nil
    end

    local function refreshESP()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                if plr.Character then
                    local h = plr.Character:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 then
                        if not espData[plr] then createESPTag(plr) end
                    else
                        if espData[plr] then destroyESPTag(plr) end
                    end
                elseif espData[plr] then
                    destroyESPTag(plr)
                end
            end
        end
    end

    task.spawn(function()
        while true do
            task.wait(1)
            if espEnabled then refreshESP() end
        end
    end)

    local aimbotEnabled = false
    local aimbotPOV = 60
    local aimbotConn = nil
    local aimbotTarget = nil
    local aimbotLocked = false
    local aimbotTeamSafe = true

    local function getBodyPartPos(char, partName)
        if not char then return nil end
        if partName == "Kepala" then
            local hd = char:FindFirstChild("Head")
            if hd then return hd.Position end
        elseif partName == "Leher" then
            local hd = char:FindFirstChild("Head")
            if hd then return hd.Position - Vector3.new(0, 0.5, 0) end
        elseif partName == "Badan" then
            local ut = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if ut then return ut.Position end
        elseif partName == "Paha" then
            local ul = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("RightUpperLeg")
            if ul then return ul.Position end
        elseif partName == "Kaki" then
            local ft = char:FindFirstChild("LeftFoot") or char:FindFirstChild("RightFoot")
            if ft then return ft.Position end
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then return hrp.Position end
        return nil
    end

    local function startAimbot()
        aimbotEnabled = true
        if aimbotConn then aimbotConn:Disconnect() end
        aimbotConn = RunService.RenderStepped:Connect(function()
            if not aimbotEnabled then return end
            local cam = Workspace.CurrentCamera
            if not cam then return end
            local cl = cam.CFrame.LookVector
            local ha = aimbotPOV / 2
            local bt = nil
            local bd = math.huge
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    if not (aimbotTeamSafe and _G.vanz.isTeam(plr)) then
                        local h = plr.Character:FindFirstChildOfClass("Humanoid")
                        if h and h.Health > 0 then
                            local tp = findBestEspPart(plr.Character)
                            if tp then
                                local tt = tp.Position - cam.CFrame.Position
                                local dst = tt.Magnitude
                                if dst > 0.1 then
                                    local dt = cl:Dot(tt.Unit)
                                    local ag = math.deg(math.acos(math.clamp(dt, -1, 1)))
                                    if ag <= ha and dst < bd then
                                        bd = dst
                                        bt = plr
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if bt and bt.Character then
                local tp = getBodyPartPos(bt.Character, _G.vanz._vanzAimbotBodyPart or "Kepala")
                if tp then
                    local cp = cam.CFrame.Position
                    cam.CFrame = CFrame.new(cp, tp)
                end
            end
        end)
    end

    local function stopAimbot()
        aimbotEnabled = false
        if aimbotConn then aimbotConn:Disconnect() aimbotConn = nil end
    end

    local antiRagdollEnabled = false
    local antiRagdollConn = nil

    local function startAntiRagdoll()
        antiRagdollEnabled = true
        if antiRagdollConn then antiRagdollConn:Disconnect() end
        antiRagdollConn = RunService.Heartbeat:Connect(function()
            if not antiRagdollEnabled then return end
            local c = LP.Character
            if not c then return end
            local h = c:FindFirstChildOfClass("Humanoid")
            if not h then return end
            if h.PlatformStand then h.PlatformStand = false end
            local s = h:GetState()
            if s == Enum.HumanoidStateType.FallingDown or s == Enum.HumanoidStateType.Ragdoll or s == Enum.HumanoidStateType.Physics then
                pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            end
            pcall(function()
                h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end)
        end)
    end

    local function stopAntiRagdoll()
        antiRagdollEnabled = false
        if antiRagdollConn then antiRagdollConn:Disconnect() antiRagdollConn = nil end
    end

    local fullbrightEnabled = false
    local fullbrightLevel = 3

    local function applyFullbright()
        if not fullbrightEnabled then return end
        Lighting.Brightness = fullbrightLevel
        local amb = math.clamp(fullbrightLevel / 10, 0, 1)
        Lighting.Ambient = Color3.fromRGB(255 * amb, 255 * amb, 255 * amb)
        Lighting.OutdoorAmbient = Color3.fromRGB(255 * amb, 255 * amb, 255 * amb)
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
        Lighting.GlobalShadows = false
    end

    local function hopToServer(mode)
        local PlaceId = game.PlaceId
        local JobId = game.JobId
        local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"
        local ok, response = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        if not ok or not response or not response.data or #response.data == 0 then
            pcall(function() TeleportService:Teleport(PlaceId, LP) end)
            return false
        end
        local servers = {}
        for _, srv in ipairs(response.data) do
            if srv.id ~= JobId and srv.playing and srv.maxPlayers then
                table.insert(servers, {id = srv.id, playing = srv.playing, maxPlayers = srv.maxPlayers})
            end
        end
        if #servers == 0 then
            pcall(function() TeleportService:Teleport(PlaceId, LP) end)
            return false
        end
        local chosen = nil
        if mode == "crowded" then
            table.sort(servers, function(a, b) return a.playing > b.playing end)
            for _, srv in ipairs(servers) do
                if srv.playing < srv.maxPlayers then chosen = srv break end
            end
            if not chosen then chosen = servers[1] end
        else
            table.sort(servers, function(a, b) return a.playing < b.playing end)
            for _, srv in ipairs(servers) do
                if srv.playing >= 1 and srv.playing < srv.maxPlayers then chosen = srv break end
            end
            if not chosen then chosen = servers[1] end
        end
        if chosen then
            pcall(function() TeleportService:TeleportToPlaceInstance(PlaceId, chosen.id, LP) end)
            return true
        end
        pcall(function() TeleportService:Teleport(PlaceId, LP) end)
        return false
    end

    local teleportSelected = nil
    local teleportListFrame = nil
    local teleportPlayerRows = {}

    local function teleportToPlayer(plr)
        if not plr then return end
        local tc = plr.Character
        if not tc then return end
        local th = findBestEspPart(tc)
        if not th then return end
        local mc = LP.Character
        if not mc then return end
        local mh = mc:FindFirstChild("HumanoidRootPart")
        if not mh then return end
        local lk = th.CFrame.LookVector
        local fl = Vector3.new(lk.X, 0, lk.Z)
        if fl.Magnitude < 0.01 then fl = Vector3.new(0, 0, -1) end
        mh.CFrame = CFrame.new(th.Position - fl.Unit * 4 + Vector3.new(0, 2, 0))
    end

    local function refreshTeleportList()
        if not teleportListFrame then return end
        for _, row in pairs(teleportPlayerRows) do pcall(function() row:Destroy() end) end
        teleportPlayerRows = {}
        if teleportSelected and teleportSelected.Parent == nil then teleportSelected = nil end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local row = Instance.new("TextButton")
                row.Size = UDim2.new(1, 0, 0, 34)
                row.BackgroundColor3 = T.row
                row.BorderSizePixel = 0
                row.Text = "  " .. plr.DisplayName .. "  (@" .. plr.Name .. ")"
                row.TextColor3 = T.text
                row.TextSize = 12
                row.Font = Enum.Font.Gotham
                row.TextXAlignment = Enum.TextXAlignment.Left
                row.AutoButtonColor = true
                row.ZIndex = 2
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
                row.Parent = teleportListFrame
                teleportPlayerRows[plr] = row
                row.MouseButton1Click:Connect(function()
                    teleportSelected = plr
                    for p, r in pairs(teleportPlayerRows) do
                        if p == plr then
                            r.BackgroundColor3 = T.sel
                            r.TextColor3 = Color3.fromRGB(255, 255, 255)
                        else
                            r.BackgroundColor3 = T.row
                            r.TextColor3 = T.text
                        end
                    end
                end)
            end
        end
    end

    task.spawn(function()
        while true do
            task.wait(1)
            refreshTeleportList()
        end
    end)

    _G.vanz.setWallhack = function(s) wallhackEnabled = s if s then applyWallhack() else restoreWallhack() end end
    _G.vanz.setSpeed = function(s)
        speedEnabled = s
        local c = LP.Character
        if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        if not h then return end
        if s then applySpeed() else if speedConn then speedConn:Disconnect() speedConn = nil end h.WalkSpeed = 16 end
    end
    _G.vanz.setCurrentSpeed = function(n) currentSpeed = n if speedEnabled then applySpeed() end end
    _G.vanz.startFly = startFly
    _G.vanz.stopFly = stopFly
    _G.vanz.setESP = function(s) espEnabled = s if not s then for p,_ in pairs(espData) do destroyESPTag(p) end espData = {} end end
    _G.vanz.startAimbot = startAimbot
    _G.vanz.stopAimbot = stopAimbot
    _G.vanz.setAimbotPOV = function(v) aimbotPOV = v end
    _G.vanz.setAimbotTeamSafe = function(s) aimbotTeamSafe = s end
    _G.vanz.startAntiRagdoll = startAntiRagdoll
    _G.vanz.stopAntiRagdoll = stopAntiRagdoll
    _G.vanz.applyFullbright = applyFullbright
    _G.vanz.setFullbrightEnabled = function(s) fullbrightEnabled = s end
    _G.vanz.setFullbrightLevel = function(v) fullbrightLevel = v if fullbrightEnabled then applyFullbright() end end
    _G.vanz.hopToServer = hopToServer
    _G.vanz.refreshTeleportList = refreshTeleportList
    _G.vanz.setTeleportListFrame = function(f) teleportListFrame = f end
    _G.vanz.getTeleportSelected = function() return teleportSelected end
    _G.vanz.teleportToPlayer = teleportToPlayer
    _G.vanz.findBestEspPart = findBestEspPart
end

-- BLOCK 4: AUTO PARRY
do
    local Players = _G.vanz.Players
    local RunService = _G.vanz.RunService
    local LP = _G.vanz.LP

    local autoParryEnabled = false
    local parryRange = 20
    local parryDebounce = 0.1
    local parryDebounceMap = {}
    local autoParryLastFire = 0

    local function getGuiMob()
        local pg = LP:FindFirstChild("PlayerGui")
        if not pg then return nil end
        local survivorMob = pg:FindFirstChild("Survivor-mob")
        if not survivorMob then return nil end
        local controls = survivorMob:FindFirstChild("Controls")
        if not controls then return nil end
        return controls:FindFirstChild("Gui-mob")
    end

    local cachedGuiMob = nil

    task.spawn(function()
        while true do
            task.wait(2)
            if not cachedGuiMob or not cachedGuiMob.Parent then cachedGuiMob = getGuiMob() end
        end
    end)

    local function fireGuiMob()
        local guiMob = cachedGuiMob
        if not guiMob or not guiMob.Parent then
            guiMob = getGuiMob()
            cachedGuiMob = guiMob
        end
        if not guiMob then return end
        pcall(function()
            if firesignal then firesignal(guiMob.MouseButton1Down)
            elseif fireclickdetector then fireclickdetector(guiMob) end
        end)
    end

    local function getKillerChar(plr)
        if not plr or plr == LP then return nil end
        local char = plr.Character
        if not char then return nil end
        if char:FindFirstChild("Lookscriptkiller", true) then return char end
        return nil
    end

    local function getCharHrp(char)
        if not char then return nil end
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    end

    local function getMyHrp()
        local char = LP.Character
        if not char then return nil end
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    end

    RunService.Heartbeat:Connect(function()
        if not autoParryEnabled then return end
        local myHrp = getMyHrp()
        if not myHrp then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local char = getKillerChar(plr)
                if char then
                    local killerHrp = getCharHrp(char)
                    if killerHrp then
                        local dist = (killerHrp.Position - myHrp.Position).Magnitude
                        if dist <= parryRange then
                            local now = tick()
                            if now - autoParryLastFire < 0.005 then return end
                            local key = tostring(char:GetDebugId())
                            if now - (parryDebounceMap[key] or 0) < parryDebounce then return end
                            parryDebounceMap[key] = now
                            autoParryLastFire = now
                            fireGuiMob()
                        end
                    end
                end
            end
        end
    end)

    _G.vanz.setAutoParry = function(s) autoParryEnabled = s end
    _G.vanz.setParryRange = function(v) parryRange = v end
end

-- BLOCK 5: SILENT AIM 6 MEKANISME
do
    local Players = _G.vanz.Players
    local RunService = _G.vanz.RunService
    local Workspace = _G.vanz.Workspace
    local LP = _G.vanz.LP
    local T = _G.vanz.T

    local silentTarget = nil
    local silentBodyPart = "Kepala"
    local silentListFrame = nil

    local hitboxOn = false
    local hitboxLoopRunning = false
    local hitboxData = {}

    local mouseOn = false
    local mouse = nil
    local mouseOriginalHit = nil

    local cameraRayOn = false
    local cameraRayConn = nil

    local wsRaycastOn = false
    local findPartOnRayOn = false
    local remoteInjectOn = false

    pcall(function() mouse = LP:GetMouse() end)

    local function getTargetChar()
        if not silentTarget then return nil end
        return silentTarget.Character
    end

    local function getTargetPart()
        local char = getTargetChar()
        if not char then return nil end
        if silentBodyPart == "Kepala" then return char:FindFirstChild("Head")
        elseif silentBodyPart == "Leher" then return char:FindFirstChild("Head")
        elseif silentBodyPart == "Badan" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        elseif silentBodyPart == "Paha" then return char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("LowerTorso")
        elseif silentBodyPart == "Kaki" then return char:FindFirstChild("LeftFoot") or char:FindFirstChild("RightFoot")
        end
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function getTargetPos()
        local p = getTargetPart()
        if not p then return nil end
        if silentBodyPart == "Leher" then
            return p.Position - Vector3.new(0, 0.5, 0)
        end
        return p.Position
    end

    local function isTargetValid()
        local char = getTargetChar()
        if not char then return false end
        local h = char:FindFirstChildOfClass("Humanoid")
        if not h or h.Health <= 0 then return false end
        return true
    end

    -- MEKANISME 1: HITBOX EXPAND
    local function applyHitboxOnce()
        if not hitboxOn then return end
        if not isTargetValid() then return end
        local char = getTargetChar()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if hitboxData[char] then return end
        hitboxData[char] = {size = hrp.Size, transparency = hrp.Transparency, canCollide = hrp.CanCollide}
        pcall(function()
            hrp.Size = Vector3.new(8, 8, 8)
            hrp.Transparency = 0.5
            hrp.CanCollide = false
        end)
    end

    local function restoreHitbox()
        for char, d in pairs(hitboxData) do
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                pcall(function()
                    hrp.Size = d.size
                    hrp.Transparency = d.transparency
                    hrp.CanCollide = d.canCollide
                end)
            end
        end
        hitboxData = {}
    end

    local function hitboxLoop()
        if hitboxLoopRunning then return end
        hitboxLoopRunning = true
        task.spawn(function()
            while hitboxOn do
                task.wait(1)
                applyHitboxOnce()
                for char, d in pairs(hitboxData) do
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if not hrp or not isTargetValid() then
                        if hrp then
                            pcall(function()
                                hrp.Size = d.size
                                hrp.Transparency = d.transparency
                                hrp.CanCollide = d.canCollide
                            end)
                        end
                        hitboxData[char] = nil
                    end
                end
            end
            hitboxLoopRunning = false
        end)
    end

    local function enableHitbox()
        hitboxOn = true
        applyHitboxOnce()
        hitboxLoop()
    end

    local function disableHitbox()
        hitboxOn = false
        restoreHitbox()
    end

    -- MEKANISME 2: MOUSE SPOOF
    local function enableMouse()
        mouseOn = true
    end

    local function disableMouse()
        mouseOn = false
    end

    if mouse then
        mouse.Button1Down:Connect(function()
            if not mouseOn then return end
            if not isTargetValid() then return end
            local pos = getTargetPos()
            if not pos then return end
            mouseOriginalHit = mouse.Hit
            pcall(function()
                mouse.Hit = CFrame.new(pos)
                mouse.Target = getTargetPart()
            end)
        end)
        mouse.Button1Up:Connect(function()
            if mouseOriginalHit and mouse then
                pcall(function() mouse.Hit = mouseOriginalHit end)
            end
        end)
    end

    -- MEKANISME 3: CAMERA RAY (soft — cuma redirect kamera, gak hook metatable)
    local function enableCameraRay()
        cameraRayOn = true
        if cameraRayConn then return end
        cameraRayConn = RunService.RenderStepped:Connect(function()
            if not cameraRayOn then return end
            if not isTargetValid() then return end
            local pos = getTargetPos()
            if not pos then return end
            local cam = Workspace.CurrentCamera
            if not cam then return end
            cam.CFrame = CFrame.new(cam.CFrame.Position, pos)
        end)
    end

    local function disableCameraRay()
        cameraRayOn = false
        if cameraRayConn then cameraRayConn:Disconnect() cameraRayConn = nil end
    end

    -- MEKANISME 4,5,6: FLAG ONLY (hook dipasang di BLOCK 6)
    local function enableWsRaycast() wsRaycastOn = true end
    local function disableWsRaycast() wsRaycastOn = false end
    local function enableFindPartOnRay() findPartOnRayOn = true end
    local function disableFindPartOnRay() findPartOnRayOn = false end
    local function enableRemoteInject() remoteInjectOn = true end
    local function disableRemoteInject() remoteInjectOn = false end

    local targetRows = {}

    local function refreshList()
        if not silentListFrame then return end
        for _, row in pairs(targetRows) do pcall(function() row:Destroy() end) end
        targetRows = {}
        if silentTarget and silentTarget.Parent == nil then
            silentTarget = nil
            disableHitbox()
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local row = Instance.new("TextButton")
                row.Size = UDim2.new(1, 0, 0, 34)
                row.BackgroundColor3 = T.row
                row.BorderSizePixel = 0
                row.Text = "  " .. plr.DisplayName .. "  (@" .. plr.Name .. ")"
                row.TextColor3 = T.text
                row.TextSize = 12
                row.Font = Enum.Font.Gotham
                row.TextXAlignment = Enum.TextXAlignment.Left
                row.AutoButtonColor = true
                row.ZIndex = 2
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
                row.Parent = silentListFrame
                targetRows[plr] = row
                if plr == silentTarget then
                    row.BackgroundColor3 = T.sel
                    row.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
                row.MouseButton1Click:Connect(function()
                    disableHitbox()
                    silentTarget = plr
                    for p, r in pairs(targetRows) do
                        if p == plr then
                            r.BackgroundColor3 = T.sel
                            r.TextColor3 = Color3.fromRGB(255, 255, 255)
                        else
                            r.BackgroundColor3 = T.row
                            r.TextColor3 = T.text
                        end
                    end
                    if hitboxOn then applyHitboxOnce() end
                end)
            end
        end
    end

    Players.PlayerAdded:Connect(function() task.wait(0.5) refreshList() end)
    Players.PlayerRemoving:Connect(function(plr)
        if silentTarget == plr then
            silentTarget = nil
            disableHitbox()
        end
        task.wait(0.1)
        refreshList()
    end)
    task.spawn(function()
        while true do task.wait(1) refreshList() end
    end)

    _G.vanz.silentListFrame = nil
    _G.vanz.setSilentListFrame = function(f) silentListFrame = f end
    _G.vanz.setSilentTarget = function(p)
        disableHitbox()
        silentTarget = p
        if hitboxOn then applyHitboxOnce() end
    end
    _G.vanz.setSilentBodyPart = function(p) silentBodyPart = p end
    _G.vanz.refreshSilentList = refreshList
    _G.vanz.enableHitbox = enableHitbox
    _G.vanz.disableHitbox = disableHitbox
    _G.vanz.enableMouse = enableMouse
    _G.vanz.disableMouse = disableMouse
    _G.vanz.enableCameraRay = enableCameraRay
    _G.vanz.disableCameraRay = disableCameraRay
    _G.vanz.enableWsRaycast = enableWsRaycast
    _G.vanz.disableWsRaycast = disableWsRaycast
    _G.vanz.enableFindPartOnRay = enableFindPartOnRay
    _G.vanz.disableFindPartOnRay = disableFindPartOnRay
    _G.vanz.enableRemoteInject = enableRemoteInject
    _G.vanz.disableRemoteInject = disableRemoteInject
    _G.vanz.isTargetValid = isTargetValid
    _G.vanz.getTargetPos = getTargetPos
    _G.vanz.getTargetPart = getTargetPart
    _G.vanz._getFlags = function()
        return {
            wsRaycast = wsRaycastOn,
            findPartOnRay = findPartOnRayOn,
            remoteInject = remoteInjectOn,
        }
    end

    task.wait(0.3)
    refreshList()
end

-- BLOCK 6: METATABLE HOOK (ISOLATED, DIPASANG SEKALI)
do
    local Workspace = _G.vanz.Workspace

    local mt = nil
    pcall(function() mt = getrawmetatable and getrawmetatable(game) end)

    if mt and mt.__namecall then
        local oldNamecall = mt.__namecall
        pcall(function() setreadonly(mt, false) end)
        local ok = pcall(function()
            mt.__namecall = newcclosure(function(self, ...)
                local flags = _G.vanz._getFlags and _G.vanz._getFlags()
                if flags and _G.vanz.isTargetValid and _G.vanz.isTargetValid() then
                    local pos = _G.vanz.getTargetPos and _G.vanz.getTargetPos()
                    if pos then
                        local method = getnamecallmethod and getnamecallmethod() or ""
                        if flags.remoteInject and (method == "FireServer" or method == "InvokeServer") then
                            local args = {...}
                            for i, arg in ipairs(args) do
                                if typeof(arg) == "CFrame" then
                                    args[i] = CFrame.new(arg.Position, pos)
                                elseif typeof(arg) == "Vector3" then
                                    args[i] = pos
                                end
                            end
                            return oldNamecall(self, table.unpack(args))
                        end
                        if self == Workspace and method == "Raycast" and flags.wsRaycast then
                            local args = {...}
                            if typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
                                local dir = pos - args[1]
                                if dir.Magnitude > 0.1 then
                                    args[2] = dir.Unit * args[2].Magnitude
                                end
                            end
                            return oldNamecall(self, table.unpack(args))
                        end
                        if self == Workspace and (method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist") and flags.findPartOnRay then
                            local args = {...}
                            for i, arg in ipairs(args) do
                                if typeof(arg) == "Ray" then
                                    local dir = pos - arg.Origin
                                    args[i] = Ray.new(arg.Origin, dir.Unit * arg.Direction.Magnitude)
                                end
                            end
                            return oldNamecall(self, table.unpack(args))
                        end
                    end
                end
                return oldNamecall(self, ...)
            end)
        end)
        pcall(function() setreadonly(mt, true) end)
        if not ok then
            warn("[vanz] metatable hook gagal, tapi script tetap jalan")
        end
    end
end

-- BLOCK 7: TAB BUILDERS
do
    local UIS = _G.vanz.UIS
    local T = _G.vanz.T
    local tabBar = _G.vanz.tabBar
    local body = _G.vanz.body

    local tabs = {}
    local tabContainers = {}
    local currentTab = nil

    local function switchTab(name)
        for tName, tData in pairs(tabs) do
            if tData.frame then tData.frame.Visible = false end
            if tData.btn then
                tData.btn.BackgroundColor3 = T.off
                tData.btn.TextColor3 = T.text
            end
        end
        if tabs[name] then
            tabs[name].frame.Visible = true
            tabs[name].btn.BackgroundColor3 = T.accent
            tabs[name].btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end

    local function createTab(name, label)
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(0, 38, 0, 26)
        btn.BackgroundColor3 = T.off
        btn.Text = label or name
        btn.TextColor3 = T.text
        btn.TextSize = 10
        btn.Font = Enum.Font.GothamBold
        btn.LayoutOrder = #tabs + 1
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local frame = Instance.new("Frame", body)
        frame.Size = UDim2.new(1, 0, 0, 0)
        frame.AutomaticSize = Enum.AutomaticSize.Y
        frame.BackgroundTransparency = 1
        frame.Visible = false
        frame.LayoutOrder = 1
        local fl = Instance.new("UIListLayout", frame)
        fl.Padding = UDim.new(0, 6)
        fl.SortOrder = Enum.SortOrder.LayoutOrder
        tabs[name] = {btn = btn, frame = frame}
        tabContainers[name] = frame
        btn.MouseButton1Click:Connect(function() switchTab(name) end)
        return frame
    end

    local function makeToggle(name, default, cb, parentOverride)
        local p = parentOverride or body
        local r = Instance.new("Frame", p)
        r.Size = UDim2.new(1, 0, 0, 42)
        r.BackgroundColor3 = T.row
        r.BorderSizePixel = 0
        Instance.new("UICorner", r).CornerRadius = UDim.new(0, 8)
        local lb = Instance.new("TextLabel", r)
        lb.Size = UDim2.new(1, -80, 1, 0)
        lb.Position = UDim2.new(0, 12, 0, 0)
        lb.BackgroundTransparency = 1
        lb.Text = name
        lb.TextColor3 = T.text
        lb.TextSize = 13
        lb.Font = Enum.Font.Gotham
        lb.TextXAlignment = Enum.TextXAlignment.Left
        local b = Instance.new("TextButton", r)
        b.Size = UDim2.new(0, 50, 0, 26)
        b.Position = UDim2.new(1, -62, 0.5, -13)
        b.BackgroundColor3 = default and T.on or T.off
        b.Text = default and "ON" or "OFF"
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = 11
        b.Font = Enum.Font.GothamBold
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        local st = default
        b.MouseButton1Click:Connect(function()
            st = not st
            b.BackgroundColor3 = st and T.on or T.off
            b.Text = st and "ON" or "OFF"
            if cb then pcall(cb, st) end
        end)
    end

    local function makeButton(name, cb, parentOverride)
        local p = parentOverride or body
        local b = Instance.new("TextButton", p)
        b.Size = UDim2.new(1, 0, 0, 36)
        b.BackgroundColor3 = T.accent
        b.Text = name
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = 13
        b.Font = Enum.Font.GothamBold
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        b.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
    end

    local function makeInfo(txt, parentOverride)
        local p = parentOverride or body
        local lb = Instance.new("TextLabel", p)
        lb.Size = UDim2.new(1, 0, 0, 32)
        lb.BackgroundColor3 = T.row
        lb.Text = txt
        lb.TextColor3 = T.dim
        lb.TextSize = 10
        lb.Font = Enum.Font.Gotham
        lb.TextWrapped = true
        Instance.new("UICorner", lb).CornerRadius = UDim.new(0, 6)
    end

    local function makeNum(name, default, cb, parentOverride)
        local p = parentOverride or body
        local r = Instance.new("Frame", p)
        r.Size = UDim2.new(1, 0, 0, 42)
        r.BackgroundColor3 = T.row
        r.BorderSizePixel = 0
        Instance.new("UICorner", r).CornerRadius = UDim.new(0, 8)
        local lb = Instance.new("TextLabel", r)
        lb.Size = UDim2.new(0, 90, 1, 0)
        lb.Position = UDim2.new(0, 12, 0, 0)
        lb.BackgroundTransparency = 1
        lb.Text = name
        lb.TextColor3 = T.text
        lb.TextSize = 13
        lb.Font = Enum.Font.Gotham
        lb.TextXAlignment = Enum.TextXAlignment.Left
        local bx = Instance.new("TextBox", r)
        bx.Size = UDim2.new(1, -120, 0, 28)
        bx.Position = UDim2.new(0, 108, 0.5, -14)
        bx.BackgroundColor3 = T.bg
        bx.Text = tostring(default)
        bx.TextColor3 = T.text
        bx.TextSize = 13
        bx.Font = Enum.Font.GothamBold
        bx.ClearTextOnFocus = false
        Instance.new("UICorner", bx).CornerRadius = UDim.new(0, 6)
        bx.FocusLost:Connect(function()
            local n = tonumber(bx.Text)
            if n then
                bx.Text = tostring(n)
                if cb then pcall(cb, n) end
            else
                bx.Text = tostring(default)
            end
        end)
    end

    local cb = createTab("combat", "C")
    local vb = createTab("visual", "V")
    local mb = createTab("movement", "M")
    local ub = createTab("utility", "U")
    local tpb = createTab("teleport", "T")
    local ab = createTab("aimbot", "A")
    local sb = createTab("silent", "S")
    switchTab("combat")

    -- COMBAT
    makeInfo("Combat: Anti-Ragdoll + Auto Parry", cb)
    makeToggle("Anti Ragdoll", false, function(s)
        if s then _G.vanz.startAntiRagdoll() else _G.vanz.stopAntiRagdoll() end
    end, cb)
    makeToggle("Auto Parry", false, function(s) _G.vanz.setAutoParry(s) end, cb)
    makeNum("Parry Range", 20, function(v) _G.vanz.setParryRange(v) end, cb)

    -- VISUAL
    makeInfo("Visual: ESP + Fullbright", vb)
    makeToggle("ESP", false, function(s) _G.vanz.setESP(s) end, vb)
    makeToggle("Fullbright", false, function(s)
        if s then
            _G.vanz.setFullbrightEnabled(true)
            _G.vanz.applyFullbright()
        else
            _G.vanz.setFullbrightEnabled(false)
        end
    end, vb)

    -- MOVEMENT
    makeInfo("Movement", mb)
    makeToggle("Wallhack", false, function(s) _G.vanz.setWallhack(s) end, mb)
    makeToggle("Speed Hack", false, function(s) _G.vanz.setSpeed(s) end, mb)
    makeNum("Speed", 100, function(n) _G.vanz.setCurrentSpeed(n) end, mb)
    local infJump = false
    UIS.JumpRequest:Connect(function()
        if infJump then
            local c = _G.vanz.LP.Character
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end
    end)
    makeToggle("Infinite Jump", false, function(s) infJump = s end, mb)
    makeToggle("Fly", false, function(s)
        if s then _G.vanz.startFly() else _G.vanz.stopFly() end
    end, mb)

    -- UTILITY
    makeInfo("Server Hop", ub)
    makeButton("HOP RAMAI", function() _G.vanz.hopToServer("crowded") end, ub)
    makeButton("HOP SEPI", function() _G.vanz.hopToServer("empty") end, ub)

    -- TELEPORT
    makeInfo("Player List (pilih):", tpb)
    local tFrame = Instance.new("Frame", tpb)
    tFrame.Size = UDim2.new(1, 0, 0, 160)
    tFrame.BackgroundColor3 = T.bg
    tFrame.BorderSizePixel = 0
    tFrame.ClipsDescendants = true
    Instance.new("UICorner", tFrame).CornerRadius = UDim.new(0, 8)
    local ls2 = Instance.new("ScrollingFrame", tFrame)
    ls2.Size = UDim2.new(1, -8, 1, -8)
    ls2.Position = UDim2.new(0, 4, 0, 4)
    ls2.BackgroundTransparency = 1
    ls2.BorderSizePixel = 0
    ls2.ScrollBarThickness = 4
    ls2.ScrollBarImageColor3 = T.accent
    ls2.CanvasSize = UDim2.new(0, 0, 0, 0)
    ls2.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local ll2 = Instance.new("UIListLayout", ls2)
    ll2.Padding = UDim.new(0, 4)
    ll2.SortOrder = Enum.SortOrder.LayoutOrder
    _G.vanz.setTeleportListFrame(ls2)
    makeButton("TELEPORT", function()
        local sel = _G.vanz.getTeleportSelected()
        if sel then pcall(function() _G.vanz.teleportToPlayer(sel) end) end
    end, tpb)

    -- AIMBOT
    makeInfo("Aimbot", ab)
    makeToggle("Aimbot", false, function(s)
        if s then _G.vanz.startAimbot() else _G.vanz.stopAimbot() end
    end, ab)
    makeToggle("Team Safe", true, function(s) _G.vanz.setAimbotTeamSafe(s) end, ab)

    -- SILENT AIM
    makeInfo("Silent Aim — pilih mekanisme 1 per 1 biar aman", sb)
    makeInfo("1. Hitbox Expand (paling aman)", sb)
    makeToggle("Hitbox Expand", false, function(s)
        if s then _G.vanz.enableHitbox() else _G.vanz.disableHitbox() end
    end, sb)
    makeInfo("2. Mouse Spoof", sb)
    makeToggle("Mouse Spoof", false, function(s)
        if s then _G.vanz.enableMouse() else _G.vanz.disableMouse() end
    end, sb)
    makeInfo("3. Camera Ray", sb)
    makeToggle("Camera Ray", false, function(s)
        if s then _G.vanz.enableCameraRay() else _G.vanz.disableCameraRay() end
    end, sb)
    makeInfo("4. Workspace Raycast", sb)
    makeToggle("Workspace Raycast", false, function(s)
        if s then _G.vanz.enableWsRaycast() else _G.vanz.disableWsRaycast() end
    end, sb)
    makeInfo("5. FindPartOnRay", sb)
    makeToggle("FindPartOnRay", false, function(s)
        if s then _G.vanz.enableFindPartOnRay() else _G.vanz.disableFindPartOnRay() end
    end, sb)
    makeInfo("6. Remote Inject", sb)
    makeToggle("Remote Inject", false, function(s)
        if s then _G.vanz.enableRemoteInject() else _G.vanz.disableRemoteInject() end
    end, sb)

    makeInfo("Hit Target:", sb)
    local bpSelSil = Instance.new("Frame", sb)
    bpSelSil.Size = UDim2.new(1, 0, 0, 40)
    bpSelSil.BackgroundColor3 = T.row
    bpSelSil.BorderSizePixel = 0
    Instance.new("UICorner", bpSelSil).CornerRadius = UDim.new(0, 8)
    local bpRowSil = Instance.new("Frame", bpSelSil)
    bpRowSil.Size = UDim2.new(1, -16, 0, 30)
    bpRowSil.Position = UDim2.new(0, 8, 0, 5)
    bpRowSil.BackgroundTransparency = 1
    local bpLaySil = Instance.new("UIListLayout", bpRowSil)
    bpLaySil.FillDirection = Enum.FillDirection.Horizontal
    bpLaySil.Padding = UDim.new(0, 4)
    local optSil = {"Kepala", "Leher", "Badan", "Paha", "Kaki"}
    local btnSil = {}
    local function setSil(idx)
        for i, b in ipairs(btnSil) do
            if i == idx then
                b.BackgroundColor3 = T.accent
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                b.BackgroundColor3 = T.off
                b.TextColor3 = T.text
            end
        end
        _G.vanz.setSilentBodyPart(optSil[idx])
    end
    for i, lab in ipairs(optSil) do
        local b = Instance.new("TextButton", bpRowSil)
        b.Size = UDim2.new(0, 46, 0, 28)
        b.BackgroundColor3 = (i == 1) and T.accent or T.off
        b.Text = lab
        b.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or T.text
        b.TextSize = 10
        b.Font = Enum.Font.GothamBold
        b.LayoutOrder = i
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        btnSil[i] = b
        b.MouseButton1Click:Connect(function() setSil(i) end)
    end

    makeInfo("Player List (pilih target):", sb)
    local listFrame = Instance.new("Frame", sb)
    listFrame.Size = UDim2.new(1, 0, 0, 180)
    listFrame.BackgroundColor3 = T.bg
    listFrame.BorderSizePixel = 0
    listFrame.ClipsDescendants = true
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 8)

    local scroll = Instance.new("ScrollingFrame", listFrame)
    scroll.Size = UDim2.new(1, -8, 1, -8)
    scroll.Position = UDim2.new(0, 4, 0, 4)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = T.accent
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local sl = Instance.new("UIListLayout", scroll)
    sl.Padding = UDim.new(0, 4)
    sl.SortOrder = Enum.SortOrder.LayoutOrder
    _G.vanz.setSilentListFrame(scroll)

    makeButton("REFRESH TARGET LIST", function() _G.vanz.refreshSilentList() end, sb)
end

pcall(function()
    if setthreadidentity then setthreadidentity(8) end
end)

print("[vanz] Slim menu + 6 Silent Aim mekanisme")
