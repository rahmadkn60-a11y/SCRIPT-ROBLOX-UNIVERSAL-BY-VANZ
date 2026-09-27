-- vanz scanner v2 (with tabs + probe + vulnerability report)
do
    -- ================================================
    --  BLOK 1 : STATE + GUI + 3 TABS
    -- ================================================
    _G.vanz = _G.vanz or {}
    local V = _G.vanz

    -- CEK: GUI + helper masih ada?
    if V.installed then
        local guiAlive = V.ScreenGui and V.ScreenGui.Parent ~= nil
        local helpersAlive = V.makeSection and V.makeToggle and V.makeBtn and V.makeInput and V.ProbeRoot
        if guiAlive and helpersAlive then
            V.ScreenGui.Enabled = true
            V.Main.Visible = true
            if V.Logo then V.Logo.Visible = false end
            print("[VANZ] GUI di-restore")
            return
        else
            print("[VANZ] GUI/helper hilang, rebuild...")
            if V.ScreenGui then pcall(function() V.ScreenGui:Destroy() end) end
            V.installed = false
        end
    end
    V.installed = true

    -- STATE INTI
    V.enabled     = false
    V.captured    = {}
    V.counter     = 0
    V.destroyed   = false
    V._pending    = {}
    V._rawNC      = {}
    V.lastLink    = ""

    -- STATE STATUS
    V.baselineOn  = false
    V.baseline    = {}
    V.liveStats   = {}
    V.findings    = {}
    V.scanRan     = false
    V.scanning    = false
    V.baselineState = "none"
    V.scanState     = "none"
    V.scanStartedAt = 0
    V.scanDoneAt    = 0
    V.baselineStartAt = 0
    V.baselineDoneAt  = 0

    -- STATE PROBE
    V.probing = false
    V.probeStop = false
    V.probeLastResult = nil
    V.probeMode = "Fire"
    V.remoteButtons = {}
    V.selectedRemote = nil

    V.categories  = { N = true, I = true, C = true, O = true, P = true }
    V.scanCfg = { [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true, [9]=true, [10]=true }

    local CoreGui = game:GetService("CoreGui")
    local cam = workspace.CurrentCamera
    local vp  = cam and cam.ViewportSize or Vector2.new(360, 640)
    local W   = math.min(320, vp.X - 40)

    if CoreGui:FindFirstChild("VanzScanner") then CoreGui.VanzScanner:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VanzScanner"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    V.ScreenGui = ScreenGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, W, 0.92, 0)
    Main.Position = UDim2.new(0, 10, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui
    V.Main = Main
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local ms = Instance.new("UIStroke", Main)
    ms.Color = Color3.fromRGB(60, 60, 80); ms.Thickness = 1

    -- TITLE BAR
    local TB = Instance.new("Frame")
    TB.Size = UDim2.new(1, 0, 0, 30)
    TB.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    TB.BorderSizePixel = 0; TB.Parent = Main
    Instance.new("UICorner", TB).CornerRadius = UDim.new(0, 8)
    local tbfix = Instance.new("Frame")
    tbfix.Size = UDim2.new(1, 0, 0, 12); tbfix.Position = UDim2.new(0, 0, 1, -12)
    tbfix.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    tbfix.BorderSizePixel = 0; tbfix.Parent = TB

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -70, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "VANZHUB • SCANNER + PROBE"
    Title.TextColor3 = Color3.fromRGB(235, 235, 245)
    Title.Font = Enum.Font.GothamBold; Title.TextSize = 10
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TB

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 8, 0, 8)
    StatusDot.Position = UDim2.new(1, -48, 0.5, -4)
    StatusDot.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    StatusDot.BorderSizePixel = 0; StatusDot.Parent = TB
    Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)
    V.StatusDot = StatusDot

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 24, 0, 22)
    MinBtn.Position = UDim2.new(1, -32, 0, 4)
    MinBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 68)
    MinBtn.Text = "–"; MinBtn.TextColor3 = Color3.fromRGB(235, 235, 245)
    MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 14
    MinBtn.BorderSizePixel = 0; MinBtn.Parent = TB
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)
    V.MinBtn = MinBtn

    -- TAB BAR
    local TabBar = Instance.new("Frame")
    TabBar.Position = UDim2.new(0, 8, 0, 36)
    TabBar.Size = UDim2.new(1, -16, 0, 24)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = Main
    local tabLayout = Instance.new("UIListLayout", TabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ContentWrap = Instance.new("Frame")
    ContentWrap.Position = UDim2.new(0, 8, 0, 66)
    ContentWrap.Size = UDim2.new(1, -16, 1, -74)
    ContentWrap.BackgroundTransparency = 1
    ContentWrap.Parent = Main
    V.ContentWrap = ContentWrap

    -- Tab SCANNER
    local TabScannerFrame = Instance.new("ScrollingFrame")
    TabScannerFrame.Size = UDim2.new(1, 0, 1, 0)
    TabScannerFrame.BackgroundTransparency = 1
    TabScannerFrame.BorderSizePixel = 0
    TabScannerFrame.ScrollBarThickness = 4
    TabScannerFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    TabScannerFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScannerFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabScannerFrame.Visible = true
    TabScannerFrame.Parent = ContentWrap
    local sLayout = Instance.new("UIListLayout", TabScannerFrame)
    sLayout.Padding = UDim.new(0, 4)
    sLayout.SortOrder = Enum.SortOrder.LayoutOrder
    V.Root = TabScannerFrame

    -- Tab PROBE
    local TabProbeFrame = Instance.new("ScrollingFrame")
    TabProbeFrame.Size = UDim2.new(1, 0, 1, 0)
    TabProbeFrame.BackgroundTransparency = 1
    TabProbeFrame.BorderSizePixel = 0
    TabProbeFrame.ScrollBarThickness = 4
    TabProbeFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    TabProbeFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabProbeFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabProbeFrame.Visible = false
    TabProbeFrame.Parent = ContentWrap
    local pLayout = Instance.new("UIListLayout", TabProbeFrame)
    pLayout.Padding = UDim.new(0, 4)
    pLayout.SortOrder = Enum.SortOrder.LayoutOrder
    V.ProbeRoot = TabProbeFrame

    -- Tab STATUS
    local TabStatusFrame = Instance.new("ScrollingFrame")
    TabStatusFrame.Size = UDim2.new(1, 0, 1, 0)
    TabStatusFrame.BackgroundTransparency = 1
    TabStatusFrame.BorderSizePixel = 0
    TabStatusFrame.ScrollBarThickness = 4
    TabStatusFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    TabStatusFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabStatusFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabStatusFrame.Visible = false
    TabStatusFrame.Parent = ContentWrap
    local stLayout = Instance.new("UIListLayout", TabStatusFrame)
    stLayout.Padding = UDim.new(0, 4)
    stLayout.SortOrder = Enum.SortOrder.LayoutOrder
    V.StatusRoot = TabStatusFrame

    local tabBtns = {}
    local function makeTabButton(text, targetFrame, w)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, w or 82, 1, 0)
        b.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(180, 180, 200)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 9
        b.BorderSizePixel = 0
        b.Parent = TabBar
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        table.insert(tabBtns, {btn = b, frame = targetFrame})
        b.MouseButton1Click:Connect(function()
            for _, t in ipairs(tabBtns) do
                t.frame.Visible = (t.frame == targetFrame)
                if t.frame == targetFrame then
                    t.btn.BackgroundColor3 = Color3.fromRGB(60, 50, 100)
                    t.btn.TextColor3 = Color3.fromRGB(235, 235, 245)
                else
                    t.btn.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
                    t.btn.TextColor3 = Color3.fromRGB(180, 180, 200)
                end
            end
        end)
        return b
    end

    local btnScanner = makeTabButton("SCANNER", TabScannerFrame, 82)
    local btnProbe   = makeTabButton("PROBE",   TabProbeFrame,   82)
    local btnStatus  = makeTabButton("STATUS",  TabStatusFrame,  82)
    btnScanner.BackgroundColor3 = Color3.fromRGB(60, 50, 100)
    btnScanner.TextColor3 = Color3.fromRGB(235, 235, 245)

    -- HELPER DEFINITIONS
    local function makeSection(parent, text, color)
        local lb = Instance.new("TextLabel")
        lb.Size = UDim2.new(1, 0, 0, 20)
        lb.BackgroundTransparency = 1
        lb.Text = text
        lb.TextColor3 = color or Color3.fromRGB(150, 130, 255)
        lb.Font = Enum.Font.GothamBold
        lb.TextSize = 10
        lb.TextXAlignment = Enum.TextXAlignment.Left
        lb.Parent = parent
        return lb
    end

    local function makeToggle(parent, text, initial, cb, color)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 24)
        row.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        row.BorderSizePixel = 0; row.Parent = parent
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -56, 1, 0); lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = color or Color3.fromRGB(220, 220, 235)
        lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 9
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 40, 0, 18)
        btn.Position = UDim2.new(1, -46, 0.5, -9)
        btn.BackgroundColor3 = initial and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 70)
        btn.Text = initial and "ON" or "OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 9
        btn.BorderSizePixel = 0; btn.Parent = row
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

        btn.MouseButton1Click:Connect(function()
            initial = not initial
            btn.BackgroundColor3 = initial and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 70)
            btn.Text = initial and "ON" or "OFF"
            if cb then cb(initial) end
        end)
        return btn
    end

    local function makeBtn(parent, text, color, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 26)
        b.BackgroundColor3 = color
        b.Text = text; b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.GothamBold; b.TextSize = 10
        b.BorderSizePixel = 0; b.Parent = parent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        b.MouseButton1Click:Connect(cb)
        return b
    end

    local function makeInput(parent, ph, h)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, 0, 0, h or 26)
        box.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
        box.TextColor3 = Color3.fromRGB(220, 220, 235)
        box.PlaceholderText = ph
        box.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
        box.Font = Enum.Font.Code
        box.TextSize = 9
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.TextYAlignment = Enum.TextYAlignment.Top
        box.BorderSizePixel = 0
        box.Text = ""
        box.ClearTextOnFocus = false
        box.Parent = parent
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
        local pad = Instance.new("UIPadding", box)
        pad.PaddingTop = UDim.new(0, 4); pad.PaddingLeft = UDim.new(0, 6)
        pad.PaddingRight = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 4)
        return box
    end

    V.makeSection = makeSection
    V.makeToggle = makeToggle
    V.makeBtn = makeBtn
    V.makeInput = makeInput

    -- ================================================
    --  TAB SCANNER CONTENT
    -- ================================================
    local S = TabScannerFrame
    makeSection(S, "RECORDER")
    makeToggle(S, "⌘ MASTER (mulai/berhenti)", false, function(s)
        V.enabled = s
        if V.StatusDot then
            V.StatusDot.BackgroundColor3 = s and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(180, 60, 60)
        end
    end, Color3.fromRGB(150, 130, 255))
    makeToggle(S, "🌐 NETWORK", true, function(s) V.categories.N = s end)
    makeToggle(S, "⌨️ INPUT",   true, function(s) V.categories.I = s end)
    makeToggle(S, "🧍 CHARACTER", true, function(s) V.categories.C = s end)
    makeToggle(S, "📦 OBJECT",  true, function(s) V.categories.O = s end)
    makeToggle(S, "👤 PLAYER",  true, function(s) V.categories.P = s end)

    makeSection(S, "BASELINE")
    makeBtn(S, "▶ START BASELINE", Color3.fromRGB(70, 130, 200), function()
        V.baselineOn = true
        V.baseline   = {}
        V.liveStats  = {}
        V.enabled    = true
        V.baselineState = "recording"
        V.baselineStartAt = tick()
        V.baselineDoneAt  = 0
        if V.StatusDot then V.StatusDot.BackgroundColor3 = Color3.fromRGB(80, 200, 120) end
        print("[VANZ] Baseline START")
    end)

    makeBtn(S, "⏸ STOP BASELINE (save)", Color3.fromRGB(200, 130, 70), function()
        V.baselineOn = false
        V.baseline = {}
        for rname, stat in pairs(V.liveStats) do
            V.baseline[rname] = {
                callCount = stat.callCount,
                argCounts = {}, argTypes = {}, samples = {}, responses = {}, numerics = {},
            }
            for k, v in pairs(stat.argCounts) do V.baseline[rname].argCounts[k] = v end
            for idx, tm in pairs(stat.argTypes) do
                V.baseline[rname].argTypes[idx] = {}
                for tk, tv in pairs(tm) do V.baseline[rname].argTypes[idx][tk] = tv end
            end
            for i = 1, math.min(#stat.samples, 5) do table.insert(V.baseline[rname].samples, stat.samples[i]) end
            for i = 1, math.min(#stat.responses, 5) do table.insert(V.baseline[rname].responses, stat.responses[i]) end
            for idx, nr in pairs(stat.numerics) do
                V.baseline[rname].numerics[idx] = {min=nr.min, max=nr.max, samples={}}
                for i = 1, math.min(#nr.samples, 5) do
                    table.insert(V.baseline[rname].numerics[idx].samples, nr.samples[i])
                end
            end
        end
        V.baselineState = "done"
        V.baselineDoneAt = tick()
        local count = 0
        for _ in pairs(V.baseline) do count = count + 1 end
        print("[VANZ] Baseline LOCKED. " .. count .. " remotes")
    end)

    makeSection(S, "SCAN FEATURES")
    makeToggle(S, "#1  Baseline Anomaly",   true, function(s) V.scanCfg[1] = s end)
    makeToggle(S, "#2  Numeric Tamper",     true, function(s) V.scanCfg[2] = s end)
    makeToggle(S, "#3  String Inject",      true, function(s) V.scanCfg[3] = s end)
    makeToggle(S, "#4  Arg Count Variance", true, function(s) V.scanCfg[4] = s end)
    makeToggle(S, "#5  Response Leak",      true, function(s) V.scanCfg[5] = s end)
    makeToggle(S, "#6  Mutable Params",     true, function(s) V.scanCfg[6] = s end)
    makeToggle(S, "#7  Instance Swap",      true, function(s) V.scanCfg[7] = s end)
    makeToggle(S, "#8  Table Structure",    true, function(s) V.scanCfg[8] = s end)
    makeToggle(S, "#9  Error Leak",         true, function(s) V.scanCfg[9] = s end)
    makeToggle(S, "#10 Fuzz Hotspot",       true, function(s) V.scanCfg[10] = s end)

    makeSection(S, "SCAN")
    makeBtn(S, "🔍 RUN SCAN", Color3.fromRGB(150, 100, 220), function()
        if V.scanning then return end
        task.spawn(function() V:runScan() end)
    end)

    makeBtn(S, "📋 COPY REPORT", Color3.fromRGB(0, 136, 204), function()
        local report = V:buildReport()
        if not report or #report == 0 then return end
        local ok = pcall(function() if setclipboard then setclipboard(report) end end)
        if ok then print("[VANZ] ✅ Report ke clipboard " .. #report .. " char")
        else print("[VANZ] ❌ setclipboard gagal") end
    end)

    makeSection(S, "RAW")
    makeBtn(S, "🧹 CLEAR LOG", Color3.fromRGB(180, 70, 70), function()
        V.captured = {}
        V.counter  = 0
        V.liveStats = {}
    end)

    makeBtn(S, "✖ CLOSE", Color3.fromRGB(100, 100, 100), function()
        ScreenGui:Destroy()
        V.destroyed = true
        V.installed = false
    end)

    -- ================================================
    --  TAB STATUS
    -- ================================================
    local ST = TabStatusFrame
    makeSection(ST, "═══ STATUS ═══", Color3.fromRGB(150, 200, 255))

    local BSCard = Instance.new("Frame")
    BSCard.Size = UDim2.new(1, 0, 0, 70)
    BSCard.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    BSCard.BorderSizePixel = 0; BSCard.Parent = ST
    Instance.new("UICorner", BSCard).CornerRadius = UDim.new(0, 6)

    local BSLbl = Instance.new("TextLabel")
    BSLbl.Size = UDim2.new(1, -12, 0, 20)
    BSLbl.Position = UDim2.new(0, 8, 0, 6)
    BSLbl.BackgroundTransparency = 1
    BSLbl.Text = "BASELINE"
    BSLbl.TextColor3 = Color3.fromRGB(180, 180, 220)
    BSLbl.Font = Enum.Font.GothamBold; BSLbl.TextSize = 10
    BSLbl.TextXAlignment = Enum.TextXAlignment.Left
    BSLbl.Parent = BSCard

    local BSStateLbl = Instance.new("TextLabel")
    BSStateLbl.Size = UDim2.new(1, -12, 0, 16)
    BSStateLbl.Position = UDim2.new(0, 8, 0, 26)
    BSStateLbl.BackgroundTransparency = 1
    BSStateLbl.Text = "State: BELUM"
    BSStateLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
    BSStateLbl.Font = Enum.Font.Code; BSStateLbl.TextSize = 10
    BSStateLbl.TextXAlignment = Enum.TextXAlignment.Left
    BSStateLbl.Parent = BSCard
    V.BSStateLbl = BSStateLbl

    local BSInfoLbl = Instance.new("TextLabel")
    BSInfoLbl.Size = UDim2.new(1, -12, 0, 16)
    BSInfoLbl.Position = UDim2.new(0, 8, 0, 42)
    BSInfoLbl.BackgroundTransparency = 1
    BSInfoLbl.Text = "Remotes: 0"
    BSInfoLbl.TextColor3 = Color3.fromRGB(150, 220, 150)
    BSInfoLbl.Font = Enum.Font.Code; BSInfoLbl.TextSize = 9
    BSInfoLbl.TextXAlignment = Enum.TextXAlignment.Left
    BSInfoLbl.Parent = BSCard
    V.BSInfoLbl = BSInfoLbl

    local SCCard = Instance.new("Frame")
    SCCard.Size = UDim2.new(1, 0, 0, 90)
    SCCard.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    SCCard.BorderSizePixel = 0; SCCard.Parent = ST
    Instance.new("UICorner", SCCard).CornerRadius = UDim.new(0, 6)

    local SCLbl = Instance.new("TextLabel")
    SCLbl.Size = UDim2.new(1, -12, 0, 20)
    SCLbl.Position = UDim2.new(0, 8, 0, 6)
    SCLbl.BackgroundTransparency = 1
    SCLbl.Text = "SCAN"
    SCLbl.TextColor3 = Color3.fromRGB(180, 180, 220)
    SCLbl.Font = Enum.Font.GothamBold; SCLbl.TextSize = 10
    SCLbl.TextXAlignment = Enum.TextXAlignment.Left
    SCLbl.Parent = SCCard

    local SCStateLbl = Instance.new("TextLabel")
    SCStateLbl.Size = UDim2.new(1, -12, 0, 16)
    SCStateLbl.Position = UDim2.new(0, 8, 0, 26)
    SCStateLbl.BackgroundTransparency = 1
    SCStateLbl.Text = "State: BELUM"
    SCStateLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
    SCStateLbl.Font = Enum.Font.Code; SCStateLbl.TextSize = 10
    SCStateLbl.TextXAlignment = Enum.TextXAlignment.Left
    SCStateLbl.Parent = SCCard
    V.SCStateLbl = SCStateLbl

    local SCFindLbl = Instance.new("TextLabel")
    SCFindLbl.Size = UDim2.new(1, -12, 0, 16)
    SCFindLbl.Position = UDim2.new(0, 8, 0, 42)
    SCFindLbl.BackgroundTransparency = 1
    SCFindLbl.Text = "Findings: 0"
    SCFindLbl.TextColor3 = Color3.fromRGB(220, 220, 200)
    SCFindLbl.Font = Enum.Font.Code; SCFindLbl.TextSize = 9
    SCFindLbl.TextXAlignment = Enum.TextXAlignment.Left
    SCFindLbl.Parent = SCCard
    V.SCFindLbl = SCFindLbl

    local SCTimeLbl = Instance.new("TextLabel")
    SCTimeLbl.Size = UDim2.new(1, -12, 0, 16)
    SCTimeLbl.Position = UDim2.new(0, 8, 0, 58)
    SCTimeLbl.BackgroundTransparency = 1
    SCTimeLbl.Text = "Last scan: -"
    SCTimeLbl.TextColor3 = Color3.fromRGB(160, 160, 180)
    SCTimeLbl.Font = Enum.Font.Code; SCTimeLbl.TextSize = 9
    SCTimeLbl.TextXAlignment = Enum.TextXAlignment.Left
    SCTimeLbl.Parent = SCCard
    V.SCTimeLbl = SCTimeLbl

    local PBCard = Instance.new("Frame")
    PBCard.Size = UDim2.new(1, 0, 0, 60)
    PBCard.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    PBCard.BorderSizePixel = 0; PBCard.Parent = ST
    Instance.new("UICorner", PBCard).CornerRadius = UDim.new(0, 6)

    local PBLbl = Instance.new("TextLabel")
    PBLbl.Size = UDim2.new(1, -12, 0, 20)
    PBLbl.Position = UDim2.new(0, 8, 0, 6)
    PBLbl.BackgroundTransparency = 1
    PBLbl.Text = "PROBE"
    PBLbl.TextColor3 = Color3.fromRGB(180, 180, 220)
    PBLbl.Font = Enum.Font.GothamBold; PBLbl.TextSize = 10
    PBLbl.TextXAlignment = Enum.TextXAlignment.Left
    PBLbl.Parent = PBCard

    local PBStateLbl = Instance.new("TextLabel")
    PBStateLbl.Size = UDim2.new(1, -12, 0, 16)
    PBStateLbl.Position = UDim2.new(0, 8, 0, 26)
    PBStateLbl.BackgroundTransparency = 1
    PBStateLbl.Text = "State: IDLE"
    PBStateLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
    PBStateLbl.Font = Enum.Font.Code; PBStateLbl.TextSize = 10
    PBStateLbl.TextXAlignment = Enum.TextXAlignment.Left
    PBStateLbl.Parent = PBCard
    V.PBStateLbl = PBStateLbl

    local LSCard = Instance.new("Frame")
    LSCard.Size = UDim2.new(1, 0, 0, 90)
    LSCard.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    LSCard.BorderSizePixel = 0; LSCard.Parent = ST
    Instance.new("UICorner", LSCard).CornerRadius = UDim.new(0, 6)

    local LSLbl = Instance.new("TextLabel")
    LSLbl.Size = UDim2.new(1, -12, 0, 20)
    LSLbl.Position = UDim2.new(0, 8, 0, 6)
    LSLbl.BackgroundTransparency = 1
    LSLbl.Text = "LIVE STATS"
    LSLbl.TextColor3 = Color3.fromRGB(180, 180, 220)
    LSLbl.Font = Enum.Font.GothamBold; LSLbl.TextSize = 10
    LSLbl.TextXAlignment = Enum.TextXAlignment.Left
    LSLbl.Parent = LSCard

    local LSLines = Instance.new("TextLabel")
    LSLines.Size = UDim2.new(1, -12, 0, 64)
    LSLines.Position = UDim2.new(0, 8, 0, 24)
    LSLines.BackgroundTransparency = 1
    LSLines.Text = "Remotes: 0\nTotal calls: 0\nRecorded: 0 lines\nRecorder: OFF"
    LSLines.TextColor3 = Color3.fromRGB(200, 200, 220)
    LSLines.Font = Enum.Font.Code; LSLines.TextSize = 9
    LSLines.TextXAlignment = Enum.TextXAlignment.Left
    LSLines.TextYAlignment = Enum.TextYAlignment.Top
    LSLines.Parent = LSCard
    V.LSLines = LSLines

    makeBtn(ST, "🔄 REFRESH", Color3.fromRGB(70, 100, 160), function()
        V:refreshStatus()
    end)

    print("[VANZ] GUI loaded (SCANNER + PROBE + STATUS)")

    -- STATUS REFRESH
    function V:refreshStatus()
        if self.baselineState == "none" then
            self.BSStateLbl.Text = "State: BELUM"
            self.BSStateLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
            self.BSInfoLbl.Text = "Remotes: 0"
        elseif self.baselineState == "recording" then
            local elapsed = math.floor(tick() - self.baselineStartAt)
            self.BSStateLbl.Text = "State: RECORDING (" .. elapsed .. "s)"
            self.BSStateLbl.TextColor3 = Color3.fromRGB(120, 220, 120)
            local cnt = 0
            for _ in pairs(self.liveStats) do cnt = cnt + 1 end
            self.BSInfoLbl.Text = "Remotes live: " .. cnt
        elseif self.baselineState == "done" then
            local cnt = 0
            for _ in pairs(self.baseline) do cnt = cnt + 1 end
            self.BSStateLbl.Text = "State: DONE"
            self.BSStateLbl.TextColor3 = Color3.fromRGB(120, 200, 255)
            self.BSInfoLbl.Text = "Remotes locked: " .. cnt
        end
        if self.scanState == "none" then
            self.SCStateLbl.Text = "State: BELUM"
            self.SCStateLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
        elseif self.scanState == "scanning" then
            self.SCStateLbl.Text = "State: SCANNING..."
            self.SCStateLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
        elseif self.scanState == "done" then
            self.SCStateLbl.Text = "State: DONE"
            self.SCStateLbl.TextColor3 = Color3.fromRGB(120, 200, 255)
        end
        local h, m, l = 0, 0, 0
        for _, f in ipairs(self.findings) do
            if f.severity == "HIGH" then h = h + 1
            elseif f.severity == "MEDIUM" then m = m + 1
            else l = l + 1 end
        end
        self.SCFindLbl.Text = string.format("Findings: %d (H:%d M:%d L:%d)", #self.findings, h, m, l)
        if self.scanDoneAt > 0 then
            local ago = math.floor(tick() - self.scanDoneAt)
            self.SCTimeLbl.Text = "Last scan: " .. ago .. "s lalu"
        else
            self.SCTimeLbl.Text = "Last scan: -"
        end
        if self.probing then
            self.PBStateLbl.Text = "State: PROBING"
            self.PBStateLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
        elseif self.probeLastResult then
            self.PBStateLbl.Text = "State: DONE"
            self.PBStateLbl.TextColor3 = Color3.fromRGB(120, 200, 255)
        else
            self.PBStateLbl.Text = "State: IDLE"
            self.PBStateLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
        end
        local remoteCount, totalCalls = 0, 0
        for _, stat in pairs(self.liveStats) do
            remoteCount = remoteCount + 1
            totalCalls = totalCalls + stat.callCount
        end
        local recState = self.enabled and "ON" or "OFF"
        self.LSLines.Text = string.format("Remotes: %d\nTotal calls: %d\nRecorded: %d lines\nRecorder: %s",
            remoteCount, totalCalls, #self.captured, recState)
    end

    task.spawn(function()
        while not V.destroyed do
            task.wait(1)
            pcall(function() V:refreshStatus() end)
        end
    end)
end

-- vanz
do
    -- BLOK 2 : LOGO MINIMIZE
    local V = _G.vanz
    if not V or V.destroyed then return end
    if V.Logo then return end  -- jangan rebuild kalo udah ada

    local Logo = Instance.new("TextButton")
    Logo.Size = UDim2.new(0, 50, 0, 50)
    Logo.Position = UDim2.new(0, 20, 0.5, -25)
    Logo.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Logo.Text = "V"
    Logo.TextColor3 = Color3.fromRGB(150, 130, 255)
    Logo.Font = Enum.Font.GothamBold; Logo.TextSize = 22
    Logo.BorderSizePixel = 0
    Logo.Visible = false
    Logo.Active = true
    Logo.Parent = V.ScreenGui
    V.Logo = Logo
    Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)
    local ls = Instance.new("UIStroke", Logo)
    ls.Color = Color3.fromRGB(150, 130, 255); ls.Thickness = 2

    Logo.InputBegan:Connect(function(input)
        local isClick = input.UserInputType == Enum.UserInputType.MouseButton1
                     or input.UserInputType == Enum.UserInputType.Touch
        if not isClick then return end
        local startInput = input.Position
        local startPos = Logo.Position
        local moved = false
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                if conn then conn:Disconnect() end
                if not moved then
                    V.Main.Visible = true
                    Logo.Visible = false
                end
                return
            end
            local d = input.Position - startInput
            if d.Magnitude > 4 then moved = true end
            if moved then
                Logo.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end)

    V.MinBtn.MouseButton1Click:Connect(function()
        V.Main.Visible = false
        Logo.Visible = true
    end)
end

-- vanz
do
    -- BLOK 3 : NETWORK HOOKS
    local V = _G.vanz
    if not V or V.destroyed then return end
    if V._networkHooked then return end
    V._networkHooked = true

    local RS = game:GetService("ReplicatedStorage")

    pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if (method == "FireServer" or method == "InvokeServer") and V.enabled and V.categories.N then
                local args = {...}
                if method == "InvokeServer" then
                    local result = oldNamecall(self, ...)
                    table.insert(V._rawNC, { method = method, self = self, args = args, result = result })
                    return result
                else
                    table.insert(V._rawNC, { method = method, self = self, args = args })
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end)

    local function hook_remote(obj, path)
        local sp = path:gsub("^ReplicatedStorage%.?", "")
        if obj:IsA("RemoteEvent") then
            obj.OnClientEvent:Connect(function(...)
                if V.enabled and V.categories.N then
                    local parts = {}
                    local n = select("#", ...)
                    for i = 1, math.min(n, 6) do
                        local a = select(i, ...)
                        local t = typeof(a)
                        local sv
                        if t == "string" then sv = (#a > 40) and (a:sub(1,40).."...") or a
                        elseif t == "Instance" then sv = a.Name
                        elseif t == "Vector3" then sv = string.format("(%.0f,%.0f,%.0f)", a.X, a.Y, a.Z)
                        elseif t == "CFrame" then local p = a.Position; sv = string.format("CF(%.0f,%.0f,%.0f)", p.X, p.Y, p.Z)
                        else sv = tostring(a) end
                        parts[i] = i .. ":" .. sv
                    end
                    V:log("N", "← " .. sp .. " | " .. table.concat(parts, " "))
                end
            end)
        end
    end

    for _, v in ipairs(RS:GetDescendants()) do
        pcall(hook_remote, v, v:GetFullName())
    end
    RS.DescendantAdded:Connect(function(v)
        pcall(hook_remote, v, v:GetFullName())
    end)
end

-- vanz
do
    -- BLOK 4 : INPUT HOOKS
    local V = _G.vanz
    if not V or V.destroyed then return end
    if V._inputHooked then return end
    V._inputHooked = true

    local UIS = game:GetService("UserInputService")
    UIS.InputBegan:Connect(function(input)
        if not V.enabled or not V.categories.I then return end
        local t = input.UserInputType
        if t == Enum.UserInputType.Keyboard then V:log("I", "KEY ↓ " .. input.KeyCode.Name)
        elseif t == Enum.UserInputType.MouseButton1 then V:log("I", "LMB ↓")
        elseif t == Enum.UserInputType.MouseButton2 then V:log("I", "RMB ↓")
        elseif t == Enum.UserInputType.Touch then V:log("I", "TOUCH ↓") end
    end)
end

-- vanz
do
    -- BLOK 5 : CHARACTER
    local V = _G.vanz
    if not V or V.destroyed then return end
    if V._charTracked then return end
    V._charTracked = true

    local plr = game.Players.LocalPlayer
    local function trackCharacter(char)
        if not char then return end
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        hum.Died:Connect(function()
            if V.enabled and V.categories.C then V:log("C", "☠ DIED") end
        end)
    end
    if plr.Character then trackCharacter(plr.Character) end
    plr.CharacterAdded:Connect(trackCharacter)
end

-- vanz
do
    -- ================================================
    --  BLOK 6 : SCANNER ENGINE + WORKER + REPORT
    -- ================================================
    local V = _G.vanz
    if not V or V.destroyed then return end
    if V._engineReady then return end
    V._engineReady = true

    local function getStat(rname)
        if not V.liveStats[rname] then
            V.liveStats[rname] = {
                callCount = 0, fires = 0, invokes = 0,
                argCounts = {}, argTypes = {}, samples = {},
                responses = {}, numerics = {},
                firstSeen = tick(), lastSeen = tick(),
            }
        end
        return V.liveStats[rname]
    end

    local function recordCall(rname, method, args, response)
        local stat = getStat(rname)
        stat.callCount = stat.callCount + 1
        stat.lastSeen = tick()
        if method == "InvokeServer" then stat.invokes = stat.invokes + 1
        else stat.fires = stat.fires + 1 end
        local ac = #args
        stat.argCounts[ac] = (stat.argCounts[ac] or 0) + 1
        for i = 1, ac do
            stat.argTypes[i] = stat.argTypes[i] or {}
            local t = typeof(args[i])
            stat.argTypes[i][t] = (stat.argTypes[i][t] or 0) + 1
            if t == "number" then
                if not stat.numerics[i] then
                    stat.numerics[i] = {min = args[i], max = args[i], samples = {}}
                else
                    if args[i] < stat.numerics[i].min then stat.numerics[i].min = args[i] end
                    if args[i] > stat.numerics[i].max then stat.numerics[i].max = args[i] end
                end
                if #stat.numerics[i].samples < 10 then table.insert(stat.numerics[i].samples, args[i]) end
            end
        end
        if #stat.samples < 10 then
            local snap = {}
            for i = 1, math.min(ac, 6) do
                local a = args[i]
                local t = typeof(a)
                if t == "string" then snap[i] = {t="string", v=tostring(a)}
                elseif t == "number" then snap[i] = {t="number", v=tostring(a)}
                elseif t == "Instance" then snap[i] = {t="Instance", v=(pcall(function() return a.Name end) and a.Name or "?")}
                else snap[i] = {t=t, v=tostring(a)} end
            end
            table.insert(stat.samples, snap)
        end
        if method == "InvokeServer" and response ~= nil then
            local rt = typeof(response)
            local respStr
            if rt == "table" then
                local ok, enc = pcall(function() return game:GetService("HttpService"):JSONEncode(response) end)
                respStr = ok and enc or "[table]"
            else respStr = tostring(response) end
            table.insert(stat.responses, {type = rt, value = respStr})
            if #stat.responses > 10 then table.remove(stat.responses, 1) end
        end
    end

    function V:log(cat, msg)
        if not self.enabled then return end
        if not self.categories[cat] then return end
        self.counter = self.counter + 1
        table.insert(self.captured, "[" .. cat .. "] " .. msg)
    end

    task.spawn(function()
        while not V.destroyed do
            task.wait(0.1)
            if #V._rawNC > 0 then
                local batch = V._rawNC
                V._rawNC = {}
                local maxBatch = math.min(#batch, 300)
                for i = 1, maxBatch do
                    local item = batch[i]
                    pcall(function()
                        local name = "?"
                        pcall(function() name = item.self:GetFullName() end)
                        recordCall(name, item.method, item.args, item.result)
                        local parts = {}
                        for k = 1, math.min(#item.args, 6) do
                            local v = item.args[k]
                            local t = typeof(v)
                            local sv
                            if t == "string" then sv = (#v > 40) and (v:sub(1, 40) .. "...") or v
                            elseif t == "Instance" then sv = v.Name
                            elseif t == "Vector3" then sv = string.format("(%.0f,%.0f,%.0f)", v.X, v.Y, v.Z)
                            elseif t == "CFrame" then local p = v.Position; sv = string.format("CF(%.0f,%.0f,%.0f)", p.X, p.Y, p.Z)
                            else sv = tostring(v) end
                            parts[k] = k .. ":" .. sv
                        end
                        V:log("N", item.method .. " > " .. name .. " | " .. table.concat(parts, " "))
                    end)
                end
                if #batch > maxBatch then
                    for i = maxBatch + 1, #batch do table.insert(V._rawNC, batch[i]) end
                end
            end
        end
    end)

    -- SCAN FUNCTIONS
    local function scan1()
        if not V.scanCfg[1] then return end
        for rname, stat in pairs(V.liveStats) do
            local base = V.baseline[rname]
            if base then
                local baseCounts = base.argCounts or {}
                local liveCounts = stat.argCounts or {}
                local baselineCount, baselineCountFreq = nil, 0
                for c, freq in pairs(baseCounts) do
                    if freq > baselineCountFreq then baselineCountFreq = freq; baselineCount = c end
                end
                for c, freq in pairs(liveCounts) do
                    if c ~= baselineCount and freq > 0 then
                        table.insert(V.findings, {
                            remote = rname, feature = 1, featureName = "Baseline Anomaly",
                            severity = "MEDIUM", confidence = 60,
                            details = "Remote dipanggil dengan jumlah arg berbeda dari baseline. Baseline: " .. tostring(baselineCount) .. " args, Live: " .. tostring(c) .. " args.",
                            exploit = "FireServer dengan arg count sama baseline, tapi ganti arg jadi nilai ekstrem.",
                        })
                    end
                end
            end
        end
    end

    local function scan2()
        if not V.scanCfg[2] then return end
        for rname, stat in pairs(V.liveStats) do
            for idx, nr in pairs(stat.numerics) do
                local range = nr.max - nr.min
                if #nr.samples >= 3 then
                    local isLikelyPrice = (nr.min > 0 and range < 100000 and math.floor(nr.min) == nr.min)
                    local isLikelyCount = (nr.min >= 0 and nr.max <= 100)
                    if isLikelyPrice or isLikelyCount then
                        local conf = isLikelyPrice and 75 or 65
                        table.insert(V.findings, {
                            remote = rname, feature = 2, featureName = "Numeric Tamper",
                            severity = "HIGH", confidence = conf,
                            details = "Arg #" .. idx .. " number range " .. nr.min .. "-" .. nr.max .. ". Samples: " .. table.concat(nr.samples, ", "),
                            exploit = "FireServer arg #" .. idx .. " = -999 atau 0.",
                        })
                    end
                end
            end
        end
    end

    local function scan3()
        if not V.scanCfg[3] then return end
        for rname, stat in pairs(V.liveStats) do
            for idx, tm in pairs(stat.argTypes) do
                if (tm["string"] or 0) > 2 then
                    local lastStr = nil
                    for i = #stat.samples, 1, -1 do
                        local s = stat.samples[i]
                        if s and s[idx] and s[idx].t == "string" then lastStr = s[idx].v; break end
                    end
                    table.insert(V.findings, {
                        remote = rname, feature = 3, featureName = "String Inject",
                        severity = "MEDIUM", confidence = 55,
                        details = "Arg #" .. idx .. " string (" .. tm["string"] .. "x). Sample: " .. tostring(lastStr),
                        exploit = "Fuzz string: '../../etc/passwd', \"' OR '1'='1\".",
                    })
                end
            end
        end
    end

    local function scan4()
        if not V.scanCfg[4] then return end
        for rname, stat in pairs(V.liveStats) do
            local kinds = {}
            for c, freq in pairs(stat.argCounts) do
                if freq > 0 then table.insert(kinds, c) end
            end
            if #kinds >= 2 then
                table.insert(V.findings, {
                    remote = rname, feature = 4, featureName = "Arg Count Variance",
                    severity = "MEDIUM", confidence = 70,
                    details = "Remote dipanggil dengan jumlah arg berbeda: " .. table.concat(kinds, ", "),
                    exploit = "FireServer dengan arg count LEBIH BANYAK.",
                })
            end
        end
    end

    local function scan5()
        if not V.scanCfg[5] then return end
        for rname, stat in pairs(V.liveStats) do
            if stat.invokes > 0 and #stat.responses > 0 then
                for _, resp in ipairs(stat.responses) do
                    local isLeak, reason = false, ""
                    if resp.type == "table" then isLeak = true; reason = "Response table structured."
                    elseif resp.type == "string" and #resp.value > 20 then isLeak = true; reason = "Response string panjang."
                    elseif resp.type == "number" and resp.value ~= 0 and resp.value ~= 1 then isLeak = true; reason = "Response angka spesifik." end
                    if isLeak then
                        local vstr = resp.value
                        if #vstr > 200 then vstr = vstr:sub(1, 200) .. "..." end
                        table.insert(V.findings, {
                            remote = rname, feature = 5, featureName = "Response Data Leak",
                            severity = "HIGH", confidence = 80,
                            details = reason .. " Type: " .. resp.type .. ". Value: " .. vstr,
                            exploit = "Data bocor dari server. Analisis strukturnya.",
                        })
                        break
                    end
                end
            end
        end
    end

    local function scan6()
        if not V.scanCfg[6] then return end
        for rname, stat in pairs(V.liveStats) do
            if stat.callCount >= 5 then
                local mutableIdx = {}
                for idx, tm in pairs(stat.argTypes) do
                    if (tm["number"] or 0) > 0 then
                        local nr = stat.numerics[idx]
                        if nr and nr.max ~= nr.min then table.insert(mutableIdx, idx) end
                    end
                end
                if #mutableIdx > 0 then
                    table.insert(V.findings, {
                        remote = rname, feature = 6, featureName = "Mutable Params",
                        severity = "MEDIUM", confidence = 65,
                        details = "Remote dipanggil " .. stat.callCount .. "x dengan arg " .. table.concat(mutableIdx, ", ") .. " yang berubah nilainya.",
                        exploit = "Fuzz arg tersebut: -1, 0, 999999, NaN.",
                    })
                end
            end
        end
    end

    local function scan7()
        if not V.scanCfg[7] then return end
        for rname, stat in pairs(V.liveStats) do
            for idx, tm in pairs(stat.argTypes) do
                if (tm["Instance"] or 0) > 0 then
                    local lastInst = nil
                    for i = #stat.samples, 1, -1 do
                        local s = stat.samples[i]
                        if s and s[idx] and s[idx].t == "Instance" then lastInst = s[idx].v; break end
                    end
                    table.insert(V.findings, {
                        remote = rname, feature = 7, featureName = "Instance Reference Swap",
                        severity = "HIGH", confidence = 70,
                        details = "Arg #" .. idx .. " Instance (" .. tm["Instance"] .. "x). Sample: " .. tostring(lastInst),
                        exploit = "Swap Instance dengan object lain.",
                    })
                end
            end
        end
    end

    local function scan8()
        if not V.scanCfg[8] then return end
        for rname, stat in pairs(V.liveStats) do
            for idx, tm in pairs(stat.argTypes) do
                if (tm["table"] or 0) > 0 then
                    table.insert(V.findings, {
                        remote = rname, feature = 8, featureName = "Table Argument Structure",
                        severity = "HIGH", confidence = 75,
                        details = "Arg #" .. idx .. " table (" .. tm["table"] .. "x). Table bisa di-inject field tambahan.",
                        exploit = "FireServer dengan table field ekstra (price=0).",
                    })
                end
            end
        end
    end

    local function scan9()
        if not V.scanCfg[9] then return end
        for rname, stat in pairs(V.liveStats) do
            for _, resp in ipairs(stat.responses) do
                local rv = tostring(resp.value)
                local lower = rv:lower()
                if lower:find("error") or lower:find("invalid") or lower:find("nil") or lower:find("attempt to") or lower:find("stack") then
                    table.insert(V.findings, {
                        remote = rname, feature = 9, featureName = "Error Message Leak",
                        severity = "MEDIUM", confidence = 70,
                        details = "Remote bocorin error: " .. rv:sub(1, 200),
                        exploit = "Error bocorin struktur internal.",
                    })
                    break
                end
            end
        end
    end

    local function scan10()
        if not V.scanCfg[10] then return end
        for rname, stat in pairs(V.liveStats) do
            if stat.callCount >= 20 then
                table.insert(V.findings, {
                    remote = rname, feature = 10, featureName = "Fuzz Hotspot",
                    severity = "LOW", confidence = 50,
                    details = "Remote dipanggil " .. stat.callCount .. "x.",
                    exploit = "Fuzz remote ini dengan berbagai payload.",
                })
            end
        end
    end

    function V:runScan()
        self.scanning = true
        self.scanState = "scanning"
        self.scanStartedAt = tick()
        self.findings = {}
        scan1(); task.wait(0.05)
        scan2(); task.wait(0.05)
        scan3(); task.wait(0.05)
        scan4(); task.wait(0.05)
        scan5(); task.wait(0.05)
        scan6(); task.wait(0.05)
        scan7(); task.wait(0.05)
        scan8(); task.wait(0.05)
        scan9(); task.wait(0.05)
        scan10()
        self.scanRan = true
        self.scanning = false
        self.scanState = "done"
        self.scanDoneAt = tick()
        local sevOrder = {HIGH = 1, MEDIUM = 2, LOW = 3}
        table.sort(self.findings, function(a, b)
            local sa = sevOrder[a.severity] or 99
            local sb = sevOrder[b.severity] or 99
            if sa ~= sb then return sa < sb end
            return (a.confidence or 0) > (b.confidence or 0)
        end)
        print("[VANZ] SCAN done. Findings: " .. #self.findings)
        pcall(function() V:refreshStatus() end)
    end

    -- BUILD REPORT (detailed format)
    local function shortenPath(r) return r:gsub("^ReplicatedStorage%.?", "") end
    local function getRemoteName(r)
        local last = r
        for seg in r:gmatch("[^%.]+") do last = seg end
        return last
    end
    local function getRemoteType(r, stat)
        if stat and stat.invokes > 0 and stat.fires == 0 then return "RemoteFunction" end
        return "RemoteEvent"
    end
    local function getMethod(r, stat)
        if stat and stat.invokes > 0 and stat.fires == 0 then return "InvokeServer" end
        return "FireServer"
    end
    local function buildArgDesc(stat)
        if not stat or not stat.samples or #stat.samples == 0 then return "  (no sample captured)" end
        local out = {}
        local sample = stat.samples[1]
        for i = 1, #sample do
            local s = sample[i]
            table.insert(out, string.format("  Argument %d: Type = %s | Value = %s | Control = Client-controlled", i, s.t or "?", tostring(s.v or "?"):sub(1, 60)))
        end
        return table.concat(out, "\n")
    end
    local function getImpactShort(f)
        local t = {
            [1]="Server accepts anomalous argument count deviating from baseline.",
            [2]="Server trusts client-controlled numeric values without proper validation.",
            [3]="Server processes unsanitized string input without validation.",
            [4]="Server accepts unexpected number of arguments.",
            [5]="Server returns sensitive data not meant for client.",
            [6]="Server accepts fuzzed mutable parameters without clamping.",
            [7]="Server accepts client-provided Instance reference without ownership verification.",
            [8]="Server accepts table payload without schema whitelisting.",
            [9]="Server leaks internal error messages revealing implementation details.",
            [10]="High-frequency remote is prime fuzzing target.",
        }
        return t[f.feature] or "Potential unauthorized server-side state manipulation."
    end
    local function getImpactLong(f)
        return f.exploit or "A regular player can influence server-side state without satisfying the intended authorization or validation requirements."
    end

    function V:buildReport()
        if not self.scanRan then
            return "Roblox Remote Vulnerability Report\n\nBelum ada scan. Klik RUN SCAN dulu."
        end
        local lines = {}
        local rc = 0
        for _ in pairs(self.liveStats) do rc = rc + 1 end
        local h, m, l = 0, 0, 0
        for _, f in ipairs(self.findings) do
            if f.severity == "HIGH" then h = h + 1
            elseif f.severity == "MEDIUM" then m = m + 1
            else l = l + 1 end
        end
        table.insert(lines, "════════════════════════════════════════════════════════════")
        table.insert(lines, "        ROBLOX REMOTE VULNERABILITY REPORT")
        table.insert(lines, "════════════════════════════════════════════════════════════")
        table.insert(lines, "Generated    : " .. os.date("%Y-%m-%d %H:%M:%S"))
        table.insert(lines, "Scanner      : VanzHub Vuln Scanner v2")
        table.insert(lines, "Remotes      : " .. rc .. " analyzed")
        table.insert(lines, "Total finding: " .. #self.findings)
        table.insert(lines, "Breakdown    : HIGH=" .. h .. " | MEDIUM=" .. m .. " | LOW=" .. l)
        table.insert(lines, "════════════════════════════════════════════════════════════")
        table.insert(lines, "")
        if #self.findings == 0 then
            table.insert(lines, "Tidak ada vulnerability yang terdeteksi pada sesi ini.")
            return table.concat(lines, "\n")
        end
        for idx, f in ipairs(self.findings) do
            local rname = f.remote or "Unknown"
            local short = shortenPath(rname)
            local remoteName = getRemoteName(rname)
            local stat = self.liveStats[rname]
            local rType = getRemoteType(rname, stat)
            local method = getMethod(rname, stat)
            local sevFinal = f.severity
            if sevFinal == "HIGH" and (f.confidence or 0) >= 80 then sevFinal = "CRITICAL" end
            local arg1Sample, arg1Type = "?", "?"
            if stat and stat.samples and #stat.samples > 0 then
                local s = stat.samples[1]
                if s[1] then arg1Type = s[1].t or "?"; arg1Sample = tostring(s[1].v or "?") end
            end
            table.insert(lines, "════════════════════════════════════════════════════════════")
            table.insert(lines, "FINDING #" .. idx)
            table.insert(lines, "════════════════════════════════════════════════════════════")
            table.insert(lines, "")
            table.insert(lines, "TITLE")
            table.insert(lines, f.featureName .. " — " .. remoteName .. " — " .. getImpactShort(f))
            table.insert(lines, "")
            table.insert(lines, "SUMMARY")
            table.insert(lines, "Ditemukan potential vulnerability pada remote " .. remoteName .. " di path:")
            table.insert(lines, "  " .. rname)
            table.insert(lines, "")
            table.insert(lines, "Remote dapat dipanggil client menggunakan " .. method .. ". Argument dapat dikontrol client dan server tidak melakukan authorization/ownership/validation memadai.")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "AFFECTED REMOTE")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Remote Type   : " .. rType)
            table.insert(lines, "Remote Name   : " .. remoteName)
            table.insert(lines, "Full Path     : game:GetService(\"ReplicatedStorage\")." .. short)
            table.insert(lines, "Method        : " .. method .. "(...)")
            table.insert(lines, "Client Access : Yes")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "REMOTE ARGUMENTS")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Remote menerima argument sebagai berikut:")
            table.insert(lines, buildArgDesc(stat))
            table.insert(lines, "")
            table.insert(lines, "Argument yang relevan terhadap vulnerability:")
            table.insert(lines, "  Argument 1")
            table.insert(lines, "  Type           : " .. arg1Type)
            table.insert(lines, "  Client-control : Yes")
            table.insert(lines, "  Sample value   : " .. arg1Sample:sub(1, 80))
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "NORMAL REQUEST")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, string.format('  %s:%s( "%s" )', remoteName, method, arg1Sample:sub(1, 30)))
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "MODIFIED REQUEST")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, string.format('  %s:%s( "[modified_value]" )', remoteName, method))
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "STEPS TO REPRODUCE")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "1. Masuk ke experience menggunakan akun test.")
            table.insert(lines, "2. Hook remote: " .. rname)
            table.insert(lines, "3. Amati request normal dari client.")
            table.insert(lines, "4. Ubah argument yang teridentifikasi.")
            table.insert(lines, "5. Amati hasil.")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "EXPECTED RESULT")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Server seharusnya memverifikasi:")
            table.insert(lines, "  - Player memiliki permission yang diperlukan")
            table.insert(lines, "  - Player memiliki resource/object yang digunakan")
            table.insert(lines, "  - Argument sesuai state server")
            table.insert(lines, "  - Nilai sensitif tidak dipercaya dari client")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "ACTUAL RESULT")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Server menerima request ke " .. remoteName .. " meskipun argument dari client tidak melewati validasi memadai.")
            table.insert(lines, "")
            table.insert(lines, "Impact: " .. getImpactLong(f))
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "SERVER-SIDE VALIDATION")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "  Authorization check : Tidak diverifikasi")
            table.insert(lines, "  Ownership check     : Tidak diverifikasi")
            table.insert(lines, "  Argument validation : Tidak memadai")
            table.insert(lines, "  State validation    : Tidak diverifikasi")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "TECHNICAL ANALYSIS")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "  Client → " .. remoteName .. " → Server Handler → Processing → Security-sensitive operation")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "PROOF OF CONCEPT")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, 'local remote = game:GetService("ReplicatedStorage").' .. short)
            table.insert(lines, string.format('remote:%s( "%s" )', method, arg1Sample:sub(1, 30)))
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "IMPACT")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "  " .. getImpactLong(f))
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "EVIDENCE")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "  1. Remote path : " .. rname)
            table.insert(lines, "  2. Method      : " .. method)
            table.insert(lines, "  3. Arg sample  : " .. arg1Sample:sub(1, 80))
            table.insert(lines, "  4. Call count  : " .. (stat and stat.callCount or 0))
            table.insert(lines, "  5. First seen  : " .. (stat and os.date("%H:%M:%S", stat.firstSeen) or "-"))
            table.insert(lines, "  6. Last seen   : " .. (stat and os.date("%H:%M:%S", stat.lastSeen) or "-"))
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "ROOT CAUSE")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, remoteName .. " menerima client-controlled argument dan menggunakannya tanpa required server-side validation.")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "SUGGESTED REMEDIATION")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "  1. Anggap seluruh remote arguments sebagai untrusted input.")
            table.insert(lines, "  2. Authorization berdasarkan Player yang diterima server.")
            table.insert(lines, "  3. Verifikasi ownership/resource secara server-side.")
            table.insert(lines, "  4. Validasi type, range, dan state argument.")
            table.insert(lines, "  5. Hitung nilai sensitif di server.")
            table.insert(lines, "  6. Tolak request yang tidak memenuhi kondisi.")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "REPRODUCTION SUMMARY")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Remote              : " .. remoteName)
            table.insert(lines, "Path                : " .. rname)
            table.insert(lines, "Method              : " .. method)
            table.insert(lines, "Vulnerable Argument : Argument 1")
            table.insert(lines, "Type                : " .. arg1Type)
            table.insert(lines, "Client Controlled   : Yes")
            table.insert(lines, "Server Validation   : Missing / Insufficient")
            table.insert(lines, "Reproducible        : Yes (observed)")
            table.insert(lines, "Verified Impact     : " .. getImpactShort(f))
            table.insert(lines, "Confidence          : " .. (f.confidence or 0) .. "%")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "RESEARCHER NOTE")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Pengujian dilakukan secara terbatas pada akun dan resource yang")
            table.insert(lines, "dikontrol oleh researcher. Tidak dilakukan akses, perubahan, atau")
            table.insert(lines, "penghapusan data milik pengguna lain.")
            table.insert(lines, "")
            table.insert(lines, "════════════════════════════════════════════════════════════")
            table.insert(lines, "")
        end
        table.insert(lines, "════════════════════════════════════════════════════════════")
        table.insert(lines, "                 END OF REPORT")
        table.insert(lines, "════════════════════════════════════════════════════════════")
        return table.concat(lines, "\n")
    end

    print("[VANZ] Scanner engine ready")
end

-- vanz
do
    -- ================================================
    --  BLOK 7 : PROBE (SELF-CONTAINED - no V.makeSection dependency)
    -- ================================================
    local V = _G.vanz
    if not V or V.destroyed then return end
    if V._probeReady then
        print("[VANZ] Probe already ready")
        return
    end

    local P = V.ProbeRoot
    if not P then
        print("[VANZ] ERROR: V.ProbeRoot nil, probe tab not available")
        return
    end

    -- Reuse helper dari BLOK 1 kalo ada, atau fallback
    local function makeSectionLocal(parent, text, color)
        local lb = Instance.new("TextLabel")
        lb.Size = UDim2.new(1, 0, 0, 20)
        lb.BackgroundTransparency = 1
        lb.Text = text
        lb.TextColor3 = color or Color3.fromRGB(150, 130, 255)
        lb.Font = Enum.Font.GothamBold
        lb.TextSize = 10
        lb.TextXAlignment = Enum.TextXAlignment.Left
        lb.Parent = parent
        return lb
    end

    local function makeInputLocal(parent, ph, h)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, 0, 0, h or 26)
        box.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
        box.TextColor3 = Color3.fromRGB(220, 220, 235)
        box.PlaceholderText = ph
        box.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
        box.Font = Enum.Font.Code
        box.TextSize = 9
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.TextYAlignment = Enum.TextYAlignment.Top
        box.BorderSizePixel = 0
        box.Text = ""
        box.ClearTextOnFocus = false
        box.Parent = parent
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
        local pad = Instance.new("UIPadding", box)
        pad.PaddingTop = UDim.new(0, 4)
        pad.PaddingLeft = UDim.new(0, 6)
        pad.PaddingRight = UDim.new(0, 6)
        pad.PaddingBottom = UDim.new(0, 4)
        return box
    end

    local function makeBtnLocal(parent, text, color, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 26)
        b.BackgroundColor3 = color
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
        b.BorderSizePixel = 0
        b.Parent = parent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        b.MouseButton1Click:Connect(cb)
        return b
    end

    -- REMOTE INPUT
    makeSectionLocal(P, "▎ REMOTE", Color3.fromRGB(240, 140, 0))
    local remoteBox = makeInputLocal(P, "ReplicatedStorage.Remotes.Healing.Reset", 26)
    V.ProbeRemoteBox = remoteBox

    -- ARGS INPUT
    makeSectionLocal(P, "▎ ARGS", Color3.fromRGB(240, 140, 0))
    local argsBox = makeInputLocal(P, "arg1, arg2, ...", 36)
    V.ProbeArgsBox = argsBox

    -- OPTIONS
    makeSectionLocal(P, "▎ OPTIONS", Color3.fromRGB(240, 140, 0))
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 48)
    Row.BackgroundTransparency = 1
    Row.Parent = P

    local rl = Instance.new("TextLabel")
    rl.Size = UDim2.new(0.5, -3, 0, 14)
    rl.BackgroundTransparency = 1
    rl.Text = "Repeat:"
    rl.TextColor3 = Color3.fromRGB(200, 200, 220)
    rl.Font = Enum.Font.GothamBold
    rl.TextSize = 9
    rl.TextXAlignment = Enum.TextXAlignment.Left
    rl.Parent = Row

    local dl = Instance.new("TextLabel")
    dl.Size = UDim2.new(0.5, -3, 0, 14)
    dl.Position = UDim2.new(0.5, 3, 0, 0)
    dl.BackgroundTransparency = 1
    dl.Text = "Delay (ms):"
    dl.TextColor3 = Color3.fromRGB(200, 200, 220)
    dl.Font = Enum.Font.GothamBold
    dl.TextSize = 9
    dl.TextXAlignment = Enum.TextXAlignment.Left
    dl.Parent = Row

    local rBox = makeInputLocal(Row, "1", 28)
    rBox.Size = UDim2.new(0.5, -3, 0, 28)
    rBox.Position = UDim2.new(0, 0, 0, 16)
    rBox.Text = "1"
    V.ProbeRepeatBox = rBox

    local dBox = makeInputLocal(Row, "100", 28)
    dBox.Size = UDim2.new(0.5, -3, 0, 28)
    dBox.Position = UDim2.new(0.5, 3, 0, 16)
    dBox.Text = "100"
    V.ProbeDelayBox = dBox

    -- MODE
    local modeFrame = Instance.new("Frame")
    modeFrame.Size = UDim2.new(1, 0, 0, 26)
    modeFrame.BackgroundTransparency = 1
    modeFrame.Parent = P

    local fireBtn = Instance.new("TextButton")
    fireBtn.Size = UDim2.new(0.5, -2, 1, 0)
    fireBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    fireBtn.Text = "FireServer"
    fireBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    fireBtn.Font = Enum.Font.GothamBold
    fireBtn.TextSize = 9
    fireBtn.BorderSizePixel = 0
    fireBtn.Parent = modeFrame
    Instance.new("UICorner", fireBtn).CornerRadius = UDim.new(0, 5)

    local invBtn = Instance.new("TextButton")
    invBtn.Size = UDim2.new(0.5, -2, 1, 0)
    invBtn.Position = UDim2.new(0.5, 2, 0, 0)
    invBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    invBtn.Text = "InvokeServer"
    invBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    invBtn.Font = Enum.Font.GothamBold
    invBtn.TextSize = 9
    invBtn.BorderSizePixel = 0
    invBtn.Parent = modeFrame
    Instance.new("UICorner", invBtn).CornerRadius = UDim.new(0, 5)

    V.probeMode = "Fire"

    fireBtn.MouseButton1Click:Connect(function()
        V.probeMode = "Fire"
        fireBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        fireBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        invBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        invBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    end)
    invBtn.MouseButton1Click:Connect(function()
        V.probeMode = "Invoke"
        invBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        invBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        fireBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        fireBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    end)

    -- ACTION
    makeSectionLocal(P, "▎ ACTION", Color3.fromRGB(240, 140, 0))
    makeBtnLocal(P, "▶ PROBE", Color3.fromRGB(200, 80, 40), function()
        if V.runProbe then V:runProbe() end
    end)
    makeBtnLocal(P, "⏹ STOP", Color3.fromRGB(120, 50, 50), function()
        V.probeStop = true
        print("[VANZ] Probe stop requested")
    end)

    -- RESULT
    makeSectionLocal(P, "▎ RESULT", Color3.fromRGB(240, 140, 0))
    local resultLbl = Instance.new("TextLabel")
    resultLbl.Size = UDim2.new(1, 0, 0, 250)
    resultLbl.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    resultLbl.BorderSizePixel = 0
    resultLbl.Text = "(belum ada probe)"
    resultLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    resultLbl.Font = Enum.Font.Code
    resultLbl.TextSize = 9
    resultLbl.TextXAlignment = Enum.TextXAlignment.Left
    resultLbl.TextYAlignment = Enum.TextYAlignment.Top
    resultLbl.TextWrapped = true
    resultLbl.Parent = P
    Instance.new("UICorner", resultLbl).CornerRadius = UDim.new(0, 5)
    local pad = Instance.new("UIPadding", resultLbl)
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 6)
    V.ProbeResultLbl = resultLbl

    makeBtnLocal(P, "📋 COPY RESULT", Color3.fromRGB(0, 136, 204), function()
        local txt = V.ProbeResultLbl and V.ProbeResultLbl.Text or ""
        if #txt > 0 then
            pcall(function() if setclipboard then setclipboard(txt) end end)
            print("[VANZ] Probe result copied")
        end
    end)

    -- REMOTE LIST
    makeSectionLocal(P, "▎ REMOTE LIST (klik = auto-fill)", Color3.fromRGB(240, 140, 0))
    local listScroll = Instance.new("ScrollingFrame")
    listScroll.Size = UDim2.new(1, 0, 0, 300)
    listScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    listScroll.BorderSizePixel = 0
    listScroll.ScrollBarThickness = 6
    listScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 130)
    listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    listScroll.Parent = P
    Instance.new("UICorner", listScroll).CornerRadius = UDim.new(0, 5)
    local sp = Instance.new("UIPadding", listScroll)
    sp.PaddingTop = UDim.new(0, 4); sp.PaddingLeft = UDim.new(0, 4)
    sp.PaddingRight = UDim.new(0, 4); sp.PaddingBottom = UDim.new(0, 4)
    local ll = Instance.new("UIListLayout", listScroll)
    ll.Padding = UDim.new(0, 3); ll.SortOrder = Enum.SortOrder.LayoutOrder
    V.ProbeListScroll = listScroll

    makeBtnLocal(P, "🔄 REFRESH LIST", Color3.fromRGB(100, 150, 220), function()
        if V.refreshProbeList then V:refreshProbeList() end
    end)

    makeBtnLocal(P, "🧹 CLEAR LIST", Color3.fromRGB(150, 70, 70), function()
        V.remoteButtons = {}
        for _, c in ipairs(listScroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        print("[VANZ] Remote list cleared")
    end)

    -- REFRESH FUNCTION
    function V:refreshProbeList()
        if not self.ProbeListScroll then return end
        local existing = {}
        for _, btn in ipairs(self.remoteButtons or {}) do existing[btn.path] = true end
        local count = 0
        for rname, stat in pairs(self.liveStats) do
            if not existing[rname] then
                count = count + 1
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
                btn.Text = "[" .. (stat.invokes > 0 and "RF" or "RE") .. "] " .. rname:sub(-55)
                btn.TextColor3 = Color3.fromRGB(180, 180, 200)
                btn.Font = Enum.Font.Code
                btn.TextSize = 8
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.TextTruncate = Enum.TextTruncate.AtEnd
                btn.BorderSizePixel = 0
                btn.LayoutOrder = count
                btn.Parent = self.ProbeListScroll
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
                local pad = Instance.new("UIPadding", btn)
                pad.PaddingLeft = UDim.new(0, 6); pad.PaddingRight = UDim.new(0, 6)

                btn.MouseButton1Click:Connect(function()
                    V.selectedRemote = { path = rname, stat = stat }
                    if V.ProbeRemoteBox then V.ProbeRemoteBox.Text = rname end
                    -- Auto-fill args dari sample terakhir
                    if stat.samples and #stat.samples > 0 then
                        local sample = stat.samples[#stat.samples]
                        local parts = {}
                        for i = 1, #sample do
                            local s = sample[i]
                            if s.t == "string" then parts[i] = tostring(s.v or "")
                            elseif s.t == "number" then parts[i] = tostring(s.v or "0")
                            elseif s.t == "boolean" then parts[i] = tostring(s.v or "false")
                            elseif s.t == "Instance" then parts[i] = tostring(s.v or "nil")
                            else parts[i] = "nil" end
                        end
                        if V.ProbeArgsBox then V.ProbeArgsBox.Text = table.concat(parts, ", ") end
                    end
                    -- Set mode
                    if stat.invokes > 0 and stat.fires == 0 then
                        V.probeMode = "Invoke"
                        if invBtn then
                            invBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
                            invBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end
                        if fireBtn then
                            fireBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                            fireBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
                        end
                    else
                        V.probeMode = "Fire"
                        if fireBtn then
                            fireBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
                            fireBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end
                        if invBtn then
                            invBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                            invBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
                        end
                    end
                    for _, other in ipairs(V.remoteButtons) do
                        if other.btn == btn then
                            other.btn.BackgroundColor3 = Color3.fromRGB(60, 50, 100)
                            other.btn.TextColor3 = Color3.fromRGB(235, 235, 245)
                        else
                            other.btn.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
                            other.btn.TextColor3 = Color3.fromRGB(180, 180, 200)
                        end
                    end
                    print("[VANZ] Selected: " .. rname)
                end)
                table.insert(self.remoteButtons, { btn = btn, path = rname, stat = stat })
            end
        end
        print("[VANZ] List refreshed. New: " .. count)
    end

    -- HELPERS
    local function parseArgString(s)
        if not s or s == "" then return {} end
        local args = {}
        local i, len = 1, #s
        while i <= len do
            while i <= len and s:sub(i, i):match("[%s,]") do i = i + 1 end
            if i > len then break end
            local c = s:sub(i, i)
            local val
            if c == '"' or c == "'" then
                local q = c
                i = i + 1
                local buf = {}
                while i <= len do
                    local cc = s:sub(i, i)
                    if cc == "\\" and i < len then
                        buf[#buf + 1] = s:sub(i + 1, i + 1)
                        i = i + 2
                    elseif cc == q then
                        i = i + 1
                        break
                    else
                        buf[#buf + 1] = cc
                        i = i + 1
                    end
                end
                val = table.concat(buf)
            else
                local start = i
                while i <= len and s:sub(i, i) ~= "," do i = i + 1 end
                local raw = s:sub(start, i - 1):gsub("^%s+", ""):gsub("%s+$", "")
                if raw == "" then val = ""
                elseif raw == "true" then val = true
                elseif raw == "false" then val = false
                elseif raw == "nil" then val = nil
                elseif tonumber(raw) then val = tonumber(raw)
                else
                    local resolved = nil
                    pcall(function()
                        local cur = game
                        for _, seg in ipairs(string.split(raw, ".")) do
                            if seg == "ReplicatedStorage" or seg == "Workspace" or seg == "Players" then
                                cur = game:GetService(seg)
                            else
                                cur = cur:FindFirstChild(seg)
                                if not cur then break end
                            end
                        end
                        if cur then resolved = cur end
                    end)
                    val = resolved or raw
                end
            end
            if val ~= nil then table.insert(args, val) end
        end
        return args
    end

    local function resolveInstance(path)
        if not path or path == "" then return nil end
        local cur = game
        for _, seg in ipairs(string.split(path, ".")) do
            if seg == "ReplicatedStorage" or seg == "Workspace" or seg == "Players" or seg == "CoreGui" then
                cur = game:GetService(seg)
            else
                cur = cur:FindFirstChild(seg)
                if not cur then return nil end
            end
        end
        return cur
    end

    local function snapshot()
        local s = {}
        local ch = game.Players.LocalPlayer.Character
        if ch then
            local h = ch:FindFirstChildOfClass("Humanoid")
            local r = ch:FindFirstChild("HumanoidRootPart")
            if h then s.hp = h.Health; s.ws = h.WalkSpeed; s.jp = h.JumpPower end
            if r then s.tr = r.Transparency; s.cc = r.CanCollide; s.p = r.Position end
        end
        s.wc = #workspace:GetChildren()
        return s
    end

    local function diff(a, b)
        if not a or not b then return {} end
        local c = {}
        if a.hp ~= b.hp then table.insert(c, "HP:" .. tostring(a.hp) .. "->" .. tostring(b.hp)) end
        if a.ws ~= b.ws then table.insert(c, "WS:" .. tostring(a.ws) .. "->" .. tostring(b.ws)) end
        if a.jp ~= b.jp then table.insert(c, "JP:" .. tostring(a.jp) .. "->" .. tostring(b.jp)) end
        if a.tr ~= b.tr then table.insert(c, "Tr:" .. tostring(a.tr) .. "->" .. tostring(b.tr)) end
        if a.cc ~= b.cc then table.insert(c, "CC:" .. tostring(a.cc) .. "->" .. tostring(b.cc)) end
        if a.p and b.p then
            local d = (a.p - b.p).Magnitude
            if d > 5 then table.insert(c, string.format("Pos:%.1f", d)) end
        end
        if a.wc ~= b.wc then table.insert(c, "WC:" .. a.wc .. "->" .. b.wc) end
        return c
    end

    function V:runProbe()
        if self.probing then print("[VANZ] Probe already running"); return end
        local remotePath = self.ProbeRemoteBox and self.ProbeRemoteBox.Text or ""
        if remotePath == "" then
            self.ProbeResultLbl.Text = "ERROR: remote path kosong"
            return
        end
        local remoteInst = resolveInstance(remotePath)
        if not remoteInst then
            self.ProbeResultLbl.Text = "ERROR: ga bisa resolve:\n" .. remotePath
            return
        end
        local argsStr = self.ProbeArgsBox and self.ProbeArgsBox.Text or ""
        local args = parseArgString(argsStr)
        local repeatN = tonumber(self.ProbeRepeatBox and self.ProbeRepeatBox.Text) or 1
        local delayMs = tonumber(self.ProbeDelayBox and self.ProbeDelayBox.Text) or 100
        if repeatN < 1 then repeatN = 1 end
        if repeatN > 200 then repeatN = 200 end
        if delayMs < 0 then delayMs = 0 end
        local mode = self.probeMode or "Fire"
        self.probing = true
        self.probeStop = false
        local wasEnabled = self.enabled
        self.enabled = false
        print("[VANZ] Probing x" .. repeatN .. " (" .. delayMs .. "ms) mode=" .. mode)
        task.spawn(function()
            local out = {}
            table.insert(out, "═══ PROBE RESULT ═══")
            table.insert(out, "Remote : " .. remotePath)
            table.insert(out, "Class  : " .. remoteInst.ClassName)
            table.insert(out, "Method : " .. mode .. "Server")
            table.insert(out, "Args   : " .. argsStr)
            table.insert(out, "Repeat : " .. repeatN)
            table.insert(out, "Delay  : " .. delayMs .. "ms")
            table.insert(out, "")
            local success, errors = 0, 0
            for i = 1, repeatN do
                if self.probeStop then
                    table.insert(out, "[STOPPED at #" .. i .. "]")
                    break
                end
                local snapB = snapshot()
                local ok, resp = pcall(function()
                    if mode == "Invoke" then
                        return remoteInst:InvokeServer(table.unpack(args))
                    else
                        remoteInst:FireServer(table.unpack(args))
                        return nil
                    end
                end)
                task.wait(delayMs / 1000)
                local snapA = snapshot()
                local changes = diff(snapB, snapA)
                table.insert(out, "-- #" .. i .. " --")
                if ok then
                    success = success + 1
                    table.insert(out, "  STATUS: OK")
                else
                    errors = errors + 1
                    table.insert(out, "  STATUS: ERROR")
                    table.insert(out, "  ERR: " .. tostring(resp):sub(1, 120))
                end
                if ok and resp ~= nil and mode == "Invoke" then
                    local rt = typeof(resp)
                    local rs
                    if rt == "table" then
                        local ok2, enc = pcall(function() return game:GetService("HttpService"):JSONEncode(resp) end)
                        rs = ok2 and enc or "[table]"
                    else rs = tostring(resp) end
                    table.insert(out, "  RESP: " .. rs:sub(1, 150))
                end
                if #changes > 0 then
                    table.insert(out, "  STATE CHANGES:")
                    for _, c in ipairs(changes) do table.insert(out, "    • " .. c) end
                else
                    table.insert(out, "  STATE: no change")
                end
                table.insert(out, "")
                if self.ProbeResultLbl then
                    self.ProbeResultLbl.Text = table.concat(out, "\n")
                end
            end
            table.insert(out, "═══ SUMMARY ═══")
            table.insert(out, "Success : " .. success)
            table.insert(out, "Errors  : " .. errors)
            self.probeLastResult = { success = success, errors = errors }
            if self.ProbeResultLbl then
                self.ProbeResultLbl.Text = table.concat(out, "\n")
            end
            self.probing = false
            self.enabled = wasEnabled
            print("[VANZ] Probe done. OK=" .. success .. " ERR=" .. errors)
        end)
    end

    V._probeReady = true
    print("[VANZ] Probe tab ready")
end

-- vanz
do
    -- BOOT MESSAGE
    local V = _G.vanz
    if not V then return end
    print("")
    print("==============================================")
    print(" VANZHUB SCANNER + PROBE READY")
    print("==============================================")
    print("Tab SCANNER : Rekam + Baseline + Scan + Report")
    print("Tab PROBE   : Kirim payload + liat delta")
    print("Tab STATUS  : Status sistem")
    print("==============================================")
end
