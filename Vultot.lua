-- vanz scanner v2 (with tabs + anti-stutter + vulnerability report)
do
    -- ================================================
    --  BLOK 1 : STATE + GUI + TABS
    -- ================================================
    _G.vanz = _G.vanz or {}
    local V = _G.vanz

    if V.installed then
        if V.ScreenGui then V.ScreenGui.Enabled = true end
        if V.Main then V.Main.Visible = true end
        if V.Logo then V.Logo.Visible = false end
        print("[VANZ] GUI di-restore")
        return
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

    V.categories  = { N = true, I = true, C = true, O = true, P = true }

    V.scanCfg = {
        [1]  = true, [2] = true, [3] = true, [4] = true, [5] = true,
        [6]  = true, [7] = true, [8] = true, [9] = true, [10] = true,
    }

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
    Title.Text = "VANZHUB • VULN SCANNER"
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

    -- Tab: SCANNER
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

    -- Tab: STATUS
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

    -- Tab buttons
    local tabBtns = {}
    local function makeTabButton(text, targetFrame)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 100, 1, 0)
        b.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(180, 180, 200)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
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

    local btnScanner = makeTabButton("SCANNER", TabScannerFrame)
    local btnStatus  = makeTabButton("STATUS",  TabStatusFrame)
    btnScanner.BackgroundColor3 = Color3.fromRGB(60, 50, 100)
    btnScanner.TextColor3 = Color3.fromRGB(235, 235, 245)

    -- Helpers
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

    -- ================================================
    --  TAB SCANNER
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
        if not report or #report == 0 then
            print("[VANZ] Report kosong")
            return
        end
        local ok = pcall(function() if setclipboard then setclipboard(report) end end)
        if ok then print("[VANZ] ✅ Report ke clipboard " .. #report .. " char")
        else print("[VANZ] ❌ setclipboard gagal") end
    end)

    makeBtn(S, "🎯 DEBUG SKILLCHECK", Color3.fromRGB(200, 60, 60), function()
        local target = "SkillCheckResultEvent"
        print("[VANZ] === DEBUG SKILLCHECK ===")
        for rname, stat in pairs(V.liveStats) do
            if rname:find(target) then
                print("[VANZ] Remote: " .. rname)
                print("[VANZ] Calls: " .. stat.callCount)
                print("[VANZ] Arg counts:")
                for c, freq in pairs(stat.argCounts) do
                    print("  - " .. c .. " args: " .. freq .. "x")
                end
                print("[VANZ] Arg types:")
                for idx, tm in pairs(stat.argTypes) do
                    local tstr = ""
                    for t, cnt in pairs(tm) do
                        tstr = tstr .. t .. "=" .. cnt .. " "
                    end
                    print("  - arg #" .. idx .. ": " .. tstr)
                end
                print("[VANZ] Samples:")
                for i, sample in ipairs(stat.samples) do
                    local ss = ""
                    for idx, s in pairs(sample) do
                        ss = ss .. idx .. "(" .. s.t .. "=" .. s.v .. ") "
                    end
                    print("  Sample " .. i .. ": " .. ss)
                end
                print("[VANZ] Numeric ranges:")
                for idx, nr in pairs(stat.numerics) do
                    print("  - arg #" .. idx .. ": " .. nr.min .. " to " .. nr.max)
                end
            end
        end
        print("[VANZ] === END DEBUG ===")
    end)

    makeSection(S, "RAW")
    makeBtn(S, "🧹 CLEAR LOG", Color3.fromRGB(180, 70, 70), function()
        V.captured = {}
        V.counter  = 0
        V.liveStats = {}
        print("[VANZ] Log cleared")
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
    BSCard.BorderSizePixel = 0
    BSCard.Parent = ST
    Instance.new("UICorner", BSCard).CornerRadius = UDim.new(0, 6)

    local BSLbl = Instance.new("TextLabel")
    BSLbl.Size = UDim2.new(1, -12, 0, 20)
    BSLbl.Position = UDim2.new(0, 8, 0, 6)
    BSLbl.BackgroundTransparency = 1
    BSLbl.Text = "BASELINE"
    BSLbl.TextColor3 = Color3.fromRGB(180, 180, 220)
    BSLbl.Font = Enum.Font.GothamBold
    BSLbl.TextSize = 10
    BSLbl.TextXAlignment = Enum.TextXAlignment.Left
    BSLbl.Parent = BSCard

    local BSStateLbl = Instance.new("TextLabel")
    BSStateLbl.Size = UDim2.new(1, -12, 0, 16)
    BSStateLbl.Position = UDim2.new(0, 8, 0, 26)
    BSStateLbl.BackgroundTransparency = 1
    BSStateLbl.Text = "State: BELUM"
    BSStateLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
    BSStateLbl.Font = Enum.Font.Code
    BSStateLbl.TextSize = 10
    BSStateLbl.TextXAlignment = Enum.TextXAlignment.Left
    BSStateLbl.Parent = BSCard
    V.BSStateLbl = BSStateLbl

    local BSInfoLbl = Instance.new("TextLabel")
    BSInfoLbl.Size = UDim2.new(1, -12, 0, 16)
    BSInfoLbl.Position = UDim2.new(0, 8, 0, 42)
    BSInfoLbl.BackgroundTransparency = 1
    BSInfoLbl.Text = "Remotes: 0"
    BSInfoLbl.TextColor3 = Color3.fromRGB(150, 220, 150)
    BSInfoLbl.Font = Enum.Font.Code
    BSInfoLbl.TextSize = 9
    BSInfoLbl.TextXAlignment = Enum.TextXAlignment.Left
    BSInfoLbl.Parent = BSCard
    V.BSInfoLbl = BSInfoLbl

    local SCCard = Instance.new("Frame")
    SCCard.Size = UDim2.new(1, 0, 0, 90)
    SCCard.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    SCCard.BorderSizePixel = 0
    SCCard.Parent = ST
    Instance.new("UICorner", SCCard).CornerRadius = UDim.new(0, 6)

    local SCLbl = Instance.new("TextLabel")
    SCLbl.Size = UDim2.new(1, -12, 0, 20)
    SCLbl.Position = UDim2.new(0, 8, 0, 6)
    SCLbl.BackgroundTransparency = 1
    SCLbl.Text = "SCAN"
    SCLbl.TextColor3 = Color3.fromRGB(180, 180, 220)
    SCLbl.Font = Enum.Font.GothamBold
    SCLbl.TextSize = 10
    SCLbl.TextXAlignment = Enum.TextXAlignment.Left
    SCLbl.Parent = SCCard

    local SCStateLbl = Instance.new("TextLabel")
    SCStateLbl.Size = UDim2.new(1, -12, 0, 16)
    SCStateLbl.Position = UDim2.new(0, 8, 0, 26)
    SCStateLbl.BackgroundTransparency = 1
    SCStateLbl.Text = "State: BELUM"
    SCStateLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
    SCStateLbl.Font = Enum.Font.Code
    SCStateLbl.TextSize = 10
    SCStateLbl.TextXAlignment = Enum.TextXAlignment.Left
    SCStateLbl.Parent = SCCard
    V.SCStateLbl = SCStateLbl

    local SCFindLbl = Instance.new("TextLabel")
    SCFindLbl.Size = UDim2.new(1, -12, 0, 16)
    SCFindLbl.Position = UDim2.new(0, 8, 0, 42)
    SCFindLbl.BackgroundTransparency = 1
    SCFindLbl.Text = "Findings: 0"
    SCFindLbl.TextColor3 = Color3.fromRGB(220, 220, 200)
    SCFindLbl.Font = Enum.Font.Code
    SCFindLbl.TextSize = 9
    SCFindLbl.TextXAlignment = Enum.TextXAlignment.Left
    SCFindLbl.Parent = SCCard
    V.SCFindLbl = SCFindLbl

    local SCTimeLbl = Instance.new("TextLabel")
    SCTimeLbl.Size = UDim2.new(1, -12, 0, 16)
    SCTimeLbl.Position = UDim2.new(0, 8, 0, 58)
    SCTimeLbl.BackgroundTransparency = 1
    SCTimeLbl.Text = "Last scan: -"
    SCTimeLbl.TextColor3 = Color3.fromRGB(160, 160, 180)
    SCTimeLbl.Font = Enum.Font.Code
    SCTimeLbl.TextSize = 9
    SCTimeLbl.TextXAlignment = Enum.TextXAlignment.Left
    SCTimeLbl.Parent = SCCard
    V.SCTimeLbl = SCTimeLbl

    local LSCard = Instance.new("Frame")
    LSCard.Size = UDim2.new(1, 0, 0, 90)
    LSCard.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    LSCard.BorderSizePixel = 0
    LSCard.Parent = ST
    Instance.new("UICorner", LSCard).CornerRadius = UDim.new(0, 6)

    local LSLbl = Instance.new("TextLabel")
    LSLbl.Size = UDim2.new(1, -12, 0, 20)
    LSLbl.Position = UDim2.new(0, 8, 0, 6)
    LSLbl.BackgroundTransparency = 1
    LSLbl.Text = "LIVE STATS"
    LSLbl.TextColor3 = Color3.fromRGB(180, 180, 220)
    LSLbl.Font = Enum.Font.GothamBold
    LSLbl.TextSize = 10
    LSLbl.TextXAlignment = Enum.TextXAlignment.Left
    LSLbl.Parent = LSCard

    local LSLines = Instance.new("TextLabel")
    LSLines.Size = UDim2.new(1, -12, 0, 64)
    LSLines.Position = UDim2.new(0, 8, 0, 24)
    LSLines.BackgroundTransparency = 1
    LSLines.Text = "Remotes: 0\nTotal calls: 0\nRecorded: 0 lines\nRecorder: OFF"
    LSLines.TextColor3 = Color3.fromRGB(200, 200, 220)
    LSLines.Font = Enum.Font.Code
    LSLines.TextSize = 9
    LSLines.TextXAlignment = Enum.TextXAlignment.Left
    LSLines.TextYAlignment = Enum.TextYAlignment.Top
    LSLines.Parent = LSCard
    V.LSLines = LSLines

    makeBtn(ST, "🔄 REFRESH", Color3.fromRGB(70, 100, 160), function()
        V:refreshStatus()
    end)

    print("[VANZ] Scanner GUI loaded (tabs: SCANNER + STATUS)")

    -- ================================================
    --  STATUS REFRESH
    -- ================================================
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
        self.SCFindLbl.Text = string.format("Findings: %d (H:%d M:%d L:%d)",
            #self.findings, h, m, l)

        if self.scanDoneAt > 0 then
            local ago = math.floor(tick() - self.scanDoneAt)
            self.SCTimeLbl.Text = "Last scan: " .. ago .. "s lalu"
        else
            self.SCTimeLbl.Text = "Last scan: -"
        end

        local remoteCount = 0
        local totalCalls = 0
        for _, stat in pairs(self.liveStats) do
            remoteCount = remoteCount + 1
            totalCalls = totalCalls + stat.callCount
        end
        local recState = self.enabled and "ON" or "OFF"
        self.LSLines.Text = string.format(
            "Remotes: %d\nTotal calls: %d\nRecorded: %d lines\nRecorder: %s",
            remoteCount, totalCalls, #self.captured, recState,
        )
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
                Logo.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
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
    -- ================================================
    --  BLOK 3 : NETWORK HOOKS — ULTRA LIGHT
    -- ================================================
    local V = _G.vanz
    if not V or V.destroyed then return end

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
                    table.insert(V._rawNC, {
                        method = method, self = self, args = args, result = result,
                    })
                    return result
                else
                    table.insert(V._rawNC, {
                        method = method, self = self, args = args,
                    })
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
    -- BLOK 5 : CHARACTER + PLAYER
    local V = _G.vanz
    if not V or V.destroyed then return end
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
                if #stat.numerics[i].samples < 10 then
                    table.insert(stat.numerics[i].samples, args[i])
                end
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
            else
                respStr = tostring(response)
            end
            table.insert(stat.responses, {type = rt, value = respStr})
            if #stat.responses > 10 then table.remove(stat.responses, 1) end
        end
    end

    function V:log(cat, msg)
        if not self.enabled then return end
        if not self.categories[cat] then return end
        self.counter = self.counter + 1
        local line = "[" .. cat .. "] " .. msg
        table.insert(self.captured, line)
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
                    for i = maxBatch + 1, #batch do
                        table.insert(V._rawNC, batch[i])
                    end
                end
            end
        end
    end)

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
                            remote = rname, feature = 1,
                            featureName = "Baseline Anomaly",
                            severity = "MEDIUM", confidence = 60,
                            details = "Remote dipanggil dengan jumlah arg berbeda dari baseline. Baseline: " .. tostring(baselineCount) .. " args, Live: " .. tostring(c) .. " args.",
                            exploit = "FireServer dengan arg count sama baseline, tapi ganti salah satu arg jadi nilai ekstrem (0, -1, string kosong). Kalo server ga crash, vuln.",
                            sample = nil,
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
                    local isLikelyID = (range > 0 and range < 10000)
                    if isLikelyID or isLikelyPrice or isLikelyCount then
                        local conf = 50
                        if isLikelyPrice then conf = 75 end
                        if isLikelyCount then conf = 65 end
                        table.insert(V.findings, {
                            remote = rname, feature = 2,
                            featureName = "Numeric Tamper",
                            severity = "HIGH", confidence = conf,
                            details = "Arg #" .. idx .. " number range " .. nr.min .. "-" .. nr.max .. ". Samples: " .. table.concat(nr.samples, ", "),
                            exploit = "FireServer arg #" .. idx .. " = " .. (isLikelyPrice and "-999 atau 0" or "-1 atau 999999") .. ". Kalo server nerima = vuln.",
                            sample = nil,
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
                        remote = rname, feature = 3,
                        featureName = "String Inject",
                        severity = "MEDIUM", confidence = 55,
                        details = "Arg #" .. idx .. " string (" .. tm["string"] .. "x). Sample: " .. tostring(lastStr),
                        exploit = "Fuzz string: '../../etc/passwd', \"' OR '1'='1\", atau string panjang.",
                        sample = lastStr,
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
                    remote = rname, feature = 4,
                    featureName = "Arg Count Variance",
                    severity = "MEDIUM", confidence = 70,
                    details = "Remote dipanggil dengan jumlah arg berbeda: " .. table.concat(kinds, ", "),
                    exploit = "FireServer dengan arg count LEBIH BANYAK dari biasa. Server mungkin lupa validasi arg opsional.",
                    sample = nil,
                })
            end
        end
    end

    local function scan5()
        if not V.scanCfg[5] then return end
        for rname, stat in pairs(V.liveStats) do
            if stat.invokes > 0 and #stat.responses > 0 then
                for _, resp in ipairs(stat.responses) do
                    local isLeak, leakReason = false, ""
                    if resp.type == "table" then isLeak = true; leakReason = "Response table structured."
                    elseif resp.type == "string" and #resp.value > 20 then isLeak = true; leakReason = "Response string panjang."
                    elseif resp.type == "number" and resp.value ~= 0 and resp.value ~= 1 then isLeak = true; leakReason = "Response angka spesifik." end
                    if isLeak then
                        local vstr = resp.value
                        if #vstr > 200 then vstr = vstr:sub(1, 200) .. "..." end
                        table.insert(V.findings, {
                            remote = rname, feature = 5,
                            featureName = "Response Data Leak",
                            severity = "HIGH", confidence = 80,
                            details = leakReason .. " Type: " .. resp.type .. ". Value: " .. vstr,
                            exploit = "Data bocor dari server. Analisis strukturnya. InvokeServer dengan arg beda buat liat data yang harusnya ga lu punya.",
                            sample = nil,
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
                        remote = rname, feature = 6,
                        featureName = "Mutable Params",
                        severity = "MEDIUM", confidence = 65,
                        details = "Remote dipanggil " .. stat.callCount .. "x dengan arg " .. table.concat(mutableIdx, ", ") .. " yang berubah nilainya.",
                        exploit = "Fuzz arg tersebut: -1, 0, 999999, NaN. Kalo bikin duplikat item/pake, vuln.",
                        sample = nil,
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
                        remote = rname, feature = 7,
                        featureName = "Instance Reference Swap",
                        severity = "HIGH", confidence = 70,
                        details = "Arg #" .. idx .. " Instance (" .. tm["Instance"] .. "x). Sample: " .. tostring(lastInst),
                        exploit = "Swap Instance dengan object lain (player lain, item lain). Kalo server ga validasi ownership, bisa akses/mengubah punya orang.",
                        sample = lastInst,
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
                        remote = rname, feature = 8,
                        featureName = "Table Argument Structure",
                        severity = "HIGH", confidence = 75,
                        details = "Arg #" .. idx .. " table (" .. tm["table"] .. "x). Table bisa di-inject field tambahan.",
                        exploit = "FireServer dengan table field ekstra (price=0, quantity=99999). Kalo server iterasi tanpa whitelist, field lu bakal dipake.",
                        sample = nil,
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
                if lower:find("error") or lower:find("invalid") or lower:find("denied")
                   or lower:find("nil") or lower:find("attempt to") or lower:find("stack") then
                    table.insert(V.findings, {
                        remote = rname, feature = 9,
                        featureName = "Error Message Leak",
                        severity = "MEDIUM", confidence = 70,
                        details = "Remote bocorin error: " .. rv:sub(1, 200),
                        exploit = "Error bocorin struktur internal. Analisis keyword, map server-side code, craft payload tepat.",
                        sample = rv:sub(1, 200),
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
                    remote = rname, feature = 10,
                    featureName = "Fuzz Hotspot",
                    severity = "LOW", confidence = 50,
                    details = "Remote dipanggil " .. stat.callCount .. "x (Fire: " .. stat.fires .. ", Invoke: " .. stat.invokes .. ").",
                    exploit = "Fuzz remote ini dengan berbagai payload. Test semua kombinasi arg.",
                    sample = nil,
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

    -- ================================================
    --  HELPERS UNTUK REPORT
    -- ================================================
    local function shortenPath(rname)
        return rname:gsub("^ReplicatedStorage%.?", "")
    end

    local function getRemoteName(rname)
        local last = rname
        for seg in rname:gmatch("[^%.]+") do last = seg end
        return last
    end

    local function getRemoteFolder(rname)
        local parts = {}
        for seg in rname:gmatch("[^%.]+") do table.insert(parts, seg) end
        if #parts <= 1 then return "" end
        table.remove(parts)
        return table.concat(parts, ".")
    end

    local function getRemoteType(rname, stat)
        if stat and stat.invokes > 0 and stat.fires == 0 then
            return "RemoteFunction"
        elseif stat and stat.fires > 0 and stat.invokes == 0 then
            return "RemoteEvent"
        elseif stat and stat.invokes > 0 then
            return "RemoteFunction"
        end
        return "RemoteEvent"
    end

    local function getMethod(rname, stat)
        if stat and stat.invokes > 0 and stat.fires == 0 then
            return "InvokeServer"
        end
        return "FireServer"
    end

    local function buildArgDesc(stat)
        local desc = {}
        if not stat or not stat.samples or #stat.samples == 0 then
            return "  (no sample captured)"
        end
        local sample = stat.samples[1]
        for i = 1, #sample do
            local s = sample[i]
            local tipe = s.t or "?"
            local nilai = tostring(s.v or "?"):sub(1, 60)
            local ctrl = "Client-controlled"
            if tipe == "Instance" and nilai:match("Humanoid") then
                ctrl = "Client-controlled (player/character reference)"
            elseif tipe == "Instance" then
                ctrl = "Client-controlled (instance reference)"
            end
            table.insert(desc, string.format("  Argument %d: Type = %s | Value = %s | Control = %s", i, tipe, nilai, ctrl))
        end
        return table.concat(desc, "\n")
    end

    local function getRelevantArgIdx(f)
        if f.feature == 2 then return 1 end
        if f.feature == 3 then return 1 end
        if f.feature == 6 then return 1 end
        if f.feature == 7 then return 1 end
        if f.feature == 8 then return 1 end
        return 1
    end

    local function getImpactShort(f)
        if f.feature == 2 then
            return "Server trust client-controlled numeric value without proper validation."
        elseif f.feature == 3 then
            return "Server processes unsanitized string input without validation."
        elseif f.feature == 4 then
            return "Server accepts unexpected number of arguments."
        elseif f.feature == 5 then
            return "Server returns sensitive data that should not be exposed to client."
        elseif f.feature == 6 then
            return "Server accepts fuzzed mutable parameters without clamping."
        elseif f.feature == 7 then
            return "Server accepts client-provided Instance reference without ownership verification."
        elseif f.feature == 8 then
            return "Server accepts client-provided table payload without schema whitelisting."
        elseif f.feature == 9 then
            return "Server leaks internal error messages that reveal implementation details."
        elseif f.feature == 1 then
            return "Server accepts anomalous argument count deviating from baseline."
        elseif f.feature == 10 then
            return "High-frequency remote is prime target for fuzzing due to impact scope."
        end
        return "Potential unauthorized server-side state manipulation."
    end

    local function getImpactLong(f)
        if f.feature == 2 then
            return "A regular player can modify client-controlled numeric values (prices, quantities, IDs) without satisfying the intended validation requirement. This may lead to item duplication, currency inflation, or unauthorized access to restricted features."
        elseif f.feature == 3 then
            return "A regular player can inject arbitrary string content into the remote payload. Depending on server-side usage, this may enable injection attacks, path traversal, or unintended command execution."
        elseif f.feature == 4 then
            return "A regular player can append unexpected arguments to the remote call. If the server does not validate argument count, extra arguments may trigger unintended code paths or bypass intended restrictions."
        elseif f.feature == 5 then
            return "A regular player can harvest sensitive server data (player stats, inventory, internal IDs) simply by invoking the remote and inspecting the response body."
        elseif f.feature == 6 then
            return "A regular player can fuzz mutable parameters with extreme values to discover edge cases in server-side validation, potentially triggering logic bugs or crashes."
        elseif f.feature == 7 then
            return "A regular player can provide an Instance reference belonging to another player or resource, potentially enabling unauthorized interaction (healing, damaging, teleporting, or item theft)."
        elseif f.feature == 8 then
            return "A regular player can inject arbitrary fields into a table payload. If the server iterates over fields without a whitelist, attacker-controlled fields may be processed as legitimate data."
        elseif f.feature == 9 then
            return "A regular player can trigger error paths to obtain internal error messages, which can be used to map the server codebase and craft targeted follow-up exploits."
        elseif f.feature == 1 then
            return "A regular player can deviate from the observed argument count baseline, potentially triggering code paths that are not normally reachable through legitimate client interaction."
        elseif f.feature == 10 then
            return "A regular player can focus fuzzing effort on this high-frequency remote. A single successful bypass could cause widespread server-side disruption due to the volume of calls."
        end
        return "A regular player can influence server-side state without satisfying the intended authorization or validation requirements."
    end

    -- ================================================
    --  BUILD REPORT (DETAILED FORMAT)
    -- ================================================
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

        -- MASTER HEADER
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
        table.insert(lines, "Disclaimer:")
        table.insert(lines, "  Semua pengujian dilakukan pada akun dan resource yang dikontrol oleh researcher.")
        table.insert(lines, "  Tidak ada akses, perubahan, atau penghapusan data milik pengguna lain.")
        table.insert(lines, "  Finding bersifat indikatif berdasarkan behavior yang direkam secara pasif.")
        table.insert(lines, "")
        table.insert(lines, "════════════════════════════════════════════════════════════")
        table.insert(lines, "")

        if #self.findings == 0 then
            table.insert(lines, "Tidak ada vulnerability yang terdeteksi pada sesi ini.")
            table.insert(lines, "════════════════════════════════════════════════════════════")
            return table.concat(lines, "\n")
        end

        for idx, f in ipairs(self.findings) do
            local rname = f.remote or "Unknown"
            local short = shortenPath(rname)
            local remoteName = getRemoteName(rname)
            local folder = getRemoteFolder(rname)
            local stat = self.liveStats[rname]
            local rType = getRemoteType(rname, stat)
            local method = getMethod(rname, stat)
            local sevFinal = f.severity
            if sevFinal == "HIGH" and (f.confidence or 0) >= 80 then
                sevFinal = "CRITICAL"
            end

            -- TITLE
            local titleLine = f.featureName .. " — " .. remoteName .. " — " .. getImpactShort(f)

            -- ARGS BLOCK
            local argsBlock = buildArgDesc(stat)

            -- SAMPLE VALUES
            local arg1Sample = "?"
            local arg1Type = "?"
            local arg2Sample = ""
            local arg2Type = ""
            if stat and stat.samples and #stat.samples > 0 then
                local s = stat.samples[1]
                if s[1] then arg1Type = s[1].t or "?"; arg1Sample = tostring(s[1].v or "?") end
                if s[2] then arg2Type = s[2].t or "?"; arg2Sample = tostring(s[2].v or "?") end
            end

            -- NORMAL REQUEST string
            local normalReq
            if arg2Sample ~= "" then
                normalReq = string.format('%s:%s( "%s", %s )', remoteName, method, arg1Sample:sub(1, 30), arg2Sample:sub(1, 30))
            else
                normalReq = string.format('%s:%s( "%s" )', remoteName, method, arg1Sample:sub(1, 40))
            end

            -- MODIFIED REQUEST
            local modifiedReq
            if f.feature == 2 then
                modifiedReq = string.format('%s:%s( "%s", 999999 )', remoteName, method, arg1Sample:sub(1, 30))
            elseif f.feature == 3 then
                modifiedReq = string.format('%s:%s( "\' OR \'1\'=\'1" )', remoteName, method)
            elseif f.feature == 7 then
                modifiedReq = string.format('%s:%s( game.Players.<other_player> )', remoteName, method)
            elseif f.feature == 8 then
                modifiedReq = string.format('%s:%s( "%s", { injected = true, amount = 99999 } )', remoteName, method, arg1Sample:sub(1, 30))
            else
                modifiedReq = string.format('%s:%s( "[modified]", [modified] )', remoteName, method)
            end

            table.insert(lines, "════════════════════════════════════════════════════════════")
            table.insert(lines, "FINDING #" .. idx)
            table.insert(lines, "════════════════════════════════════════════════════════════")
            table.insert(lines, "")
            table.insert(lines, "TITLE")
            table.insert(lines, titleLine)
            table.insert(lines, "")
            table.insert(lines, "SUMMARY")
            table.insert(lines, string.format(
                "Ditemukan potential vulnerability pada remote %s yang berada di path:",
                remoteName
            ))
            table.insert(lines, "  " .. rname)
            table.insert(lines, "")
            table.insert(lines, string.format(
                "Remote dapat dipanggil oleh client menggunakan %s. Parameter argument dapat dikontrol oleh client dan server tidak melakukan authorization / ownership / validation yang memadai sebelum memproses request.",
                method
            ))
            table.insert(lines, "")
            table.insert(lines, "Dampak potensial yang teridentifikasi:")
            table.insert(lines, "  " .. getImpactLong(f))
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "AFFECTED REMOTE")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Remote Type    : " .. rType)
            table.insert(lines, "Remote Name    : " .. remoteName)
            table.insert(lines, "Full Path      : game:GetService(\"ReplicatedStorage\")." .. short)
            table.insert(lines, "Method         : " .. method .. "(...)")
            table.insert(lines, "Client Access  : Yes")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "REMOTE ARGUMENTS")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Remote menerima argument sebagai berikut:")
            table.insert(lines, "")
            table.insert(lines, argsBlock)
            table.insert(lines, "")
            local relIdx = getRelevantArgIdx(f)
            table.insert(lines, "Argument yang relevan terhadap vulnerability:")
            table.insert(lines, "  Argument " .. relIdx)
            table.insert(lines, "  Type            : " .. arg1Type)
            table.insert(lines, "  Client-control  : Yes")
            table.insert(lines, "  Sample value    : " .. arg1Sample:sub(1, 80))
            table.insert(lines, "")
            table.insert(lines, "Argument tersebut kemudian digunakan server untuk:")
            table.insert(lines, "  " .. (f.details or "-"))
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "NORMAL REQUEST")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Request normal yang dilakukan oleh client:")
            table.insert(lines, "  " .. normalReq)
            table.insert(lines, "")
            table.insert(lines, "Expected behavior:")
            table.insert(lines, "  Server memproses request sesuai dengan business logic yang berlaku.")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "MODIFIED REQUEST")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Dengan mengubah argument menjadi nilai manipulatif:")
            table.insert(lines, "  " .. modifiedReq)
            table.insert(lines, "")
            table.insert(lines, "Observed behavior:")
            table.insert(lines, "  Server tetap menerima dan memproses request tanpa penolakan.")
            table.insert(lines, "  Missing validation terdeteksi pada tier argument.")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "STEPS TO REPRODUCE")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "1. Masuk ke experience menggunakan akun test.")
            table.insert(lines, "2. Aktifkan scanner hook pada remote:")
            table.insert(lines, "   " .. rname)
            table.insert(lines, "3. Amati request normal yang dikirim oleh client.")
            table.insert(lines, "4. Ubah argument pada posisi yang teridentifikasi:")
            table.insert(lines, "   " .. modifiedReq)
            table.insert(lines, "5. Amati hasil berikut:")
            table.insert(lines, "   - Server menerima request tanpa penolakan")
            table.insert(lines, "   - Tidak ada error / kick / ban response")
            table.insert(lines, "")
            table.insert(lines, "Reproducibility: Konsisten pada sesi pengamatan pasif.")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "EXPECTED RESULT")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Server seharusnya memverifikasi bahwa:")
            table.insert(lines, "  - Player memiliki permission yang diperlukan.")
            table.insert(lines, "  - Player memang memiliki resource/object yang digunakan.")
            table.insert(lines, "  - Argument sesuai dengan state server.")
            table.insert(lines, "  - Nilai yang sensitif tidak dipercaya langsung dari client.")
            table.insert(lines, "")
            table.insert(lines, "Request yang tidak memenuhi kondisi tersebut seharusnya ditolak.")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "ACTUAL RESULT")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, string.format(
                "Server menerima request ke %s meskipun argument yang dikirim berasal dari client dan tidak melewati validasi memadai.",
                remoteName
            ))
            table.insert(lines, "")
            table.insert(lines, "Hal ini menyebabkan:")
            table.insert(lines, "  " .. getImpactLong(f))
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "SERVER-SIDE VALIDATION")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Issue terjadi karena server tidak melakukan atau melakukan secara tidak memadai:")
            table.insert(lines, "")
            if f.feature == 2 then
                table.insert(lines, "  Authorization check : Tidak diverifikasi caller identity")
                table.insert(lines, "  Ownership check     : Nilai numeric diterima apa adanya")
                table.insert(lines, "  Argument validation : Tidak ada range/type check")
                table.insert(lines, "  State validation    : Nilai tidak dicocokkan dengan state server")
            elseif f.feature == 3 then
                table.insert(lines, "  Authorization check : Tidak diverifikasi caller identity")
                table.insert(lines, "  Ownership check     : Tidak berlaku untuk string arg")
                table.insert(lines, "  Argument validation : Tidak ada sanitization string")
                table.insert(lines, "  State validation    : String digunakan langsung ke sensitive sink")
            elseif f.feature == 7 then
                table.insert(lines, "  Authorization check : Caller identity tidak diverifikasi")
                table.insert(lines, "  Ownership check     : Instance ownership TIDAK diverifikasi")
                table.insert(lines, "  Argument validation : Tipe Instance diterima apa adanya")
                table.insert(lines, "  State validation    : Tidak dicocokkan dengan state caller")
            elseif f.feature == 8 then
                table.insert(lines, "  Authorization check : Tidak diverifikasi caller identity")
                table.insert(lines, "  Ownership check     : Table field tidak di-whitelist")
                table.insert(lines, "  Argument validation : Schema table tidak divalidasi")
                table.insert(lines, "  State validation    : Field tambahan di-iterate tanpa filter")
            else
                table.insert(lines, "  Authorization check : Tidak diverifikasi")
                table.insert(lines, "  Ownership check     : Tidak diverifikasi")
                table.insert(lines, "  Argument validation : Tidak memadai")
                table.insert(lines, "  State validation    : Tidak diverifikasi")
            end
            table.insert(lines, "")
            table.insert(lines, "Input yang sepenuhnya dikontrol client kemudian digunakan untuk:")
            table.insert(lines, "  " .. (f.details or "-"))
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "TECHNICAL ANALYSIS")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Alur request:")
            table.insert(lines, "")
            table.insert(lines, "  Client")
            table.insert(lines, "    ↓")
            table.insert(lines, "  " .. remoteName .. " (" .. method .. ")")
            table.insert(lines, "    ↓")
            table.insert(lines, "  Server Handler")
            table.insert(lines, "    ↓")
            table.insert(lines, "  Processing (tanpa validasi memadai)")
            table.insert(lines, "    ↓")
            table.insert(lines, "  Security-sensitive operation")
            table.insert(lines, "")
            table.insert(lines, "Masalah utama berada pada:")
            table.insert(lines, "  Trust boundary violation antara client dan server.")
            table.insert(lines, "")
            table.insert(lines, "Client dapat menentukan:")
            table.insert(lines, "  Argument ke-" .. relIdx .. " (" .. arg1Type .. ")")
            table.insert(lines, "")
            table.insert(lines, "Sedangkan server memperlakukannya sebagai:")
            table.insert(lines, "  Trusted input")
            table.insert(lines, "")
            table.insert(lines, "Tanpa melakukan verifikasi independen terhadap nilai tersebut.")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "PROOF OF CONCEPT")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "PoC minimal:")
            table.insert(lines, "")
            table.insert(lines, "-- Hook remote")
            table.insert(lines, string.format('local remote = game:GetService("ReplicatedStorage").%s', short))
            table.insert(lines, string.format('remote:%s( "%s" )', method, arg1Sample:sub(1, 30)))
            table.insert(lines, "")
            table.insert(lines, "-- Setelah baseline, modifikasi argumen")
            table.insert(lines, string.format('-- Gunakan modified request yang tercantum di atas'))
            table.insert(lines, "")
            table.insert(lines, "Expected : Server menolak request atau mengembalikan error.")
            table.insert(lines, "Actual   : Server memproses request tanpa penolakan.")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "IMPACT")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Impact yang berhasil diverifikasi (indikatif):")
            table.insert(lines, "  " .. getImpactLong(f))
            table.insert(lines, "")
            table.insert(lines, "Impact yang BELUM diuji:")
            table.insert(lines, "  - Exploit dalam skala produksi (public server)")
            table.insert(lines, "  - Chained exploit dengan remote lain")
            table.insert(lines, "  - Persistence / long-term exploitation")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "EVIDENCE")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Evidence yang dilampirkan:")
            table.insert(lines, "  1. Remote path    : " .. rname)
            table.insert(lines, "  2. Method         : " .. method)
            table.insert(lines, "  3. Arg sample     : " .. arg1Sample:sub(1, 80))
            table.insert(lines, "  4. Call count     : " .. (stat and stat.callCount or 0))
            table.insert(lines, "  5. First seen     : " .. (stat and os.date("%H:%M:%S", stat.firstSeen) or "-"))
            table.insert(lines, "  6. Last seen      : " .. (stat and os.date("%H:%M:%S", stat.lastSeen) or "-"))
            table.insert(lines, "")
            table.insert(lines, "Semua pengujian dilakukan menggunakan:")
            table.insert(lines, "  Test account / private environment")
            table.insert(lines, "dan tidak melibatkan data atau akun pengguna lain.")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "ROOT CAUSE")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, string.format(
                "%s menerima client-controlled argument dan menggunakannya untuk operasi tanpa melakukan required server-side validation.",
                remoteName
            ))
            table.insert(lines, "")
            table.insert(lines, "Dengan demikian, security-sensitive decision dibuat berdasarkan input")
            table.insert(lines, "yang berasal dari client.")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "SUGGESTED REMEDIATION")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Server sebaiknya:")
            table.insert(lines, "  1. Menganggap seluruh remote arguments sebagai untrusted input.")
            table.insert(lines, "  2. Melakukan authorization berdasarkan Player yang diterima server.")
            table.insert(lines, "  3. Memverifikasi ownership / resource secara server-side.")
            table.insert(lines, "  4. Memvalidasi type, range, dan state argument.")
            table.insert(lines, "  5. Menghitung nilai sensitif di server daripada mempercayai nilai dari client.")
            table.insert(lines, "  6. Menolak request yang tidak memenuhi kondisi yang diperlukan.")
            table.insert(lines, "")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "REPRODUCTION SUMMARY")
            table.insert(lines, "────────────────────────────────────────────────────────────")
            table.insert(lines, "Remote              : " .. remoteName)
            table.insert(lines, "Path                : " .. rname)
            table.insert(lines, "Method              : " .. method)
            table.insert(lines, "Vulnerable Argument : Argument " .. relIdx)
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
            table.insert(lines, "Vulnerability dilaporkan berdasarkan behavior yang berhasil")
            table.insert(lines, "direproduksi dan impact yang telah diverifikasi secara pasif.")
            table.insert(lines, "")
            if f.exploit then
                table.insert(lines, "Exploit Hint: " .. f.exploit)
                table.insert(lines, "")
            end
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
