-- vanz
do
    -- =========================================================
    -- BLOK 0 : BOOTSTRAP + SAFE HELPERS
    -- =========================================================
    pcall(function() print("[VANZ] booting...") end)

    -- Safe global getter (avoid rawget entirely)
    local function g(name)
        local ok, v = pcall(function() return _G[name] end)
        if ok then return v end
        return nil
    end

    local function hasFn(name)
        local v = g(name)
        return type(v) == "function"
    end

    local function safeCall(name, ...)
        local fn = g(name)
        if type(fn) ~= "function" then return nil, "missing" end
        local ok, r = pcall(fn, ...)
        if ok then return r, nil end
        return nil, tostring(r)
    end

    -- Executor capabilities
    local HAS = {
        getrawmetatable = hasFn("getrawmetatable"),
        setreadonly = hasFn("setreadonly"),
        newcclosure = hasFn("newcclosure"),
        getnamecallmethod = hasFn("getnamecallmethod"),
        hookfunction = hasFn("hookfunction"),
        getscriptbytecode = hasFn("getscriptbytecode"),
        decompile = hasFn("decompile"),
        decompiler = hasFn("decompiler"),
        getscriptclosure = hasFn("getscriptclosure"),
        setclipboard = hasFn("setclipboard"),
    }

    -- Init global state
    _G.vanz = _G.vanz or {}
    local V = _G.vanz
    V.HAS = HAS
    V.scriptAlive = true

    -- Boot message
    pcall(function()
        print("[VANZ] executor capabilities:")
        for k, v in pairs(HAS) do
            print("  " .. k .. ": " .. (v and "YES" or "NO"))
        end
    end)
end

-- vanz
do
    -- =========================================================
    -- BLOK 1 : GUI (260px wide, 85% height, auto-resize)
    -- =========================================================
    local V = _G.vanz
    if not V then return end

    -- Idempotency: skip if already installed
    if V.guiInstalled then
        pcall(function()
            if V.ScreenGui then V.ScreenGui.Enabled = true end
            if V.Main then V.Main.Visible = true end
            if V.Logo then V.Logo.Visible = false end
        end)
        return
    end

    -- Services
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer

    -- Auto-size based on viewport
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(360, 640)
    local GUI_W = math.min(260, vp.X - 30)
    local GUI_H = math.floor(vp.Y * 0.85)

    -- Cleanup old instance
    pcall(function()
        if CoreGui:FindFirstChild("VanzMenu") then CoreGui.VanzMenu:Destroy() end
    end)

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VanzMenu"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999999
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then
        pcall(function() ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
    end
    V.ScreenGui = ScreenGui

    -- MAIN WINDOW
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    Main.Position = UDim2.new(0, 12, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Visible = true
    Main.Parent = ScreenGui
    V.Main = Main
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local ms = Instance.new("UIStroke", Main)
    ms.Color = Color3.fromRGB(60, 60, 80)
    ms.Thickness = 1

    -- TITLE BAR
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 32)
    TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)
    -- Bottom-fix so rounded top doesn't show rounded bottom
    local tbf = Instance.new("Frame")
    tbf.Size = UDim2.new(1, 0, 0, 12)
    tbf.Position = UDim2.new(0, 0, 1, -12)
    tbf.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    tbf.BorderSizePixel = 0
    tbf.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "VANZHUB  •  ANALYZER"
    Title.TextColor3 = Color3.fromRGB(235, 235, 245)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 11
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 8, 0, 8)
    StatusDot.Position = UDim2.new(1, -46, 0.5, -4)
    StatusDot.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    StatusDot.BorderSizePixel = 0
    StatusDot.Parent = TitleBar
    Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)
    V.StatusDot = StatusDot

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 24, 0, 22)
    MinBtn.Position = UDim2.new(1, -30, 0, 5)
    MinBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 68)
    MinBtn.Text = "–"
    MinBtn.TextColor3 = Color3.fromRGB(235, 235, 245)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14
    MinBtn.BorderSizePixel = 0
    MinBtn.Parent = TitleBar
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)
    V.MinBtn = MinBtn

    -- TAB BAR
    local TabBar = Instance.new("Frame")
    TabBar.Position = UDim2.new(0, 8, 0, 38)
    TabBar.Size = UDim2.new(1, -16, 0, 22)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = Main
    local tbl = Instance.new("UIListLayout", TabBar)
    tbl.FillDirection = Enum.FillDirection.Horizontal
    tbl.Padding = UDim.new(0, 3)
    tbl.SortOrder = Enum.SortOrder.LayoutOrder

    -- CONTENT
    local Content = Instance.new("Frame")
    Content.Position = UDim2.new(0, 8, 0, 66)
    Content.Size = UDim2.new(1, -16, 1, -74)
    Content.BackgroundTransparency = 1
    Content.Parent = Main
    V.Content = Content

    -- Storage for tab frames + content
    V.TabFrames = {}
    V.TabButtons = {}

    -- Tab content creator
    local function makeTabFrame()
        local sf = Instance.new("ScrollingFrame")
        sf.Size = UDim2.new(1, 0, 1, 0)
        sf.BackgroundTransparency = 1
        sf.BorderSizePixel = 0
        sf.ScrollBarThickness = 4
        sf.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
        sf.CanvasSize = UDim2.new(0, 0, 0, 0)
        sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
        sf.Visible = false
        sf.Parent = Content
        local l = Instance.new("UIListLayout", sf)
        l.Padding = UDim.new(0, 4)
        l.SortOrder = Enum.SortOrder.LayoutOrder
        return sf
    end

    -- Tab button creator
    local function makeTabButton(text, frame, active)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 74, 1, 0)
        b.BackgroundColor3 = active and Color3.fromRGB(60, 50, 100) or Color3.fromRGB(32, 32, 44)
        b.Text = text
        b.TextColor3 = active and Color3.fromRGB(235, 235, 245) or Color3.fromRGB(180, 180, 200)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 9
        b.BorderSizePixel = 0
        b.Parent = TabBar
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)

        table.insert(V.TabButtons, { btn = b, frame = frame })

        b.MouseButton1Click:Connect(function()
            for _, item in ipairs(V.TabButtons) do
                local isActive = item.frame == frame
                item.frame.Visible = isActive
                item.btn.BackgroundColor3 = isActive and Color3.fromRGB(60, 50, 100) or Color3.fromRGB(32, 32, 44)
                item.btn.TextColor3 = isActive and Color3.fromRGB(235, 235, 245) or Color3.fromRGB(180, 180, 200)
            end
        end)
        return b
    end

    -- Create tabs
    local TabMain = makeTabFrame()
    local TabConfig = makeTabFrame()
    local TabLog = makeTabFrame()
    local TabStatus = makeTabFrame()

    local BtnMain = makeTabButton("MAIN", TabMain, true)
    local BtnConfig = makeTabButton("CONFIG", TabConfig, false)
    local BtnLog = makeTabButton("LOG", TabLog, false)
    local BtnStatus = makeTabButton("STATUS", TabStatus, false)

    TabMain.Visible = true

    V.TabMain = TabMain
    V.TabConfig = TabConfig
    V.TabLog = TabLog
    V.TabStatus = TabStatus

    -- SECTION HELPER
    function V:section(parent, text, color)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0, 18)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = color or Color3.fromRGB(150, 130, 255)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = parent
        return l
    end

    -- TOGGLE HELPER (returns row + button)
    function V:toggle(parent, label, initial, callback)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 30)
        Row.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        Row.BorderSizePixel = 0
        Row.Parent = parent
        Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 5)

        local Lbl = Instance.new("TextLabel")
        Lbl.Size = UDim2.new(1, -70, 1, 0)
        Lbl.Position = UDim2.new(0, 10, 0, 0)
        Lbl.BackgroundTransparency = 1
        Lbl.Text = label
        Lbl.TextColor3 = Color3.fromRGB(220, 220, 235)
        Lbl.Font = Enum.Font.GothamBold
        Lbl.TextSize = 10
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Parent = Row

        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 50, 0, 22)
        Btn.Position = UDim2.new(1, -58, 0.5, -11)
        Btn.BackgroundColor3 = initial and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 70)
        Btn.Text = initial and "ON" or "OFF"
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 10
        Btn.BorderSizePixel = 0
        Btn.Parent = Row
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

        local state = initial
        Btn.MouseButton1Click:Connect(function()
            state = not state
            Btn.BackgroundColor3 = state and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 70)
            Btn.Text = state and "ON" or "OFF"
            if callback then pcall(callback, state) end
        end)

        -- Expose setter
        return Row, function(newState)
            state = newState
            Btn.BackgroundColor3 = state and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 70)
            Btn.Text = state and "ON" or "OFF"
        end
    end

    -- BUTTON HELPER
    function V:button(parent, text, color, callback)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 30)
        b.BackgroundColor3 = color
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
        b.BorderSizePixel = 0
        b.Parent = parent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        b.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
        return b
    end

    -- INFO LABEL HELPER
    function V:info(parent, initialText, height)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0, height or 60)
        l.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
        l.BorderSizePixel = 0
        l.Text = initialText
        l.TextColor3 = Color3.fromRGB(200, 200, 220)
        l.Font = Enum.Font.Code
        l.TextSize = 9
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextYAlignment = Enum.TextYAlignment.Top
        l.TextWrapped = true
        l.Parent = parent
        Instance.new("UICorner", l).CornerRadius = UDim.new(0, 5)
        local pad = Instance.new("UIPadding", l)
        pad.PaddingTop = UDim.new(0, 4)
        pad.PaddingLeft = UDim.new(0, 6)
        pad.PaddingRight = UDim.new(0, 6)
        pad.PaddingBottom = UDim.new(0, 4)
        return l
    end

    -- ============================================
    -- LOGO (minimized state, draggable)
    -- ============================================
    local Logo = Instance.new("TextButton")
    Logo.Name = "VanzLogo"
    Logo.Size = UDim2.new(0, 50, 0, 50)
    Logo.Position = UDim2.new(0, 40, 0.5, -25)
    Logo.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    Logo.Text = "V"
    Logo.TextColor3 = Color3.fromRGB(150, 130, 255)
    Logo.Font = Enum.Font.GothamBold
    Logo.TextSize = 22
    Logo.BorderSizePixel = 0
    Logo.Visible = false
    Logo.Active = true
    Logo.Parent = ScreenGui
    V.Logo = Logo
    Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)
    local LogoStroke = Instance.new("UIStroke", Logo)
    LogoStroke.Color = Color3.fromRGB(150, 130, 255)
    LogoStroke.Thickness = 2

    -- Logo drag + click
    Logo.InputBegan:Connect(function(input)
        local valid = input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        if not valid then return end

        local startInput = input.Position
        local startPos = Logo.Position
        local moved = false
        local conn

        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                if conn then conn:Disconnect() end
                if not moved then
                    -- Click: restore menu
                    Main.Visible = true
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

    -- Minimize button
    MinBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        Logo.Visible = true
    end)

    -- Mark installed
    V.guiInstalled = true

    pcall(function() print("[VANZ] GUI loaded") end)
end

-- vanz
do
    -- =========================================================
    -- BLOK 2 : STATE INITIALIZATION
    -- =========================================================
    local V = _G.vanz
    if not V or not V.guiInstalled then return end

    -- Feature states
    V.enabled = false
    V.sessionOn = false
    V.sessionState = "none"
    V.sessionStartedAt = 0
    V.sessionStoppedAt = 0

    V.liveStats = {}
    V._rawNC = {}
    V.captured = {}
    V.counter = 0

    V.staticState = "none"
    V.staticScripts = {}
    V.staticFindings = {}
    V.staticError = nil
    V.staticProgress = { total = 0, done = 0, current = "" }

    V.crossState = "none"
    V.crossFindings = {}

    -- Toggle storage
    V.toggles = {
        networkHook = false,
        autoDump = false,
        verboseLog = false,
    }

    pcall(function() print("[VANZ] state initialized") end)
end

-- vanz
do
    -- =========================================================
    -- BLOK 3 : MAIN TAB UI
    -- =========================================================
    local V = _G.vanz
    if not V or not V.guiInstalled then return end

    local Tab = V.TabMain

    V:section(Tab, "▎ SESSION CONTROL")

    local _, setSession = V:toggle(Tab, "Dynamic Session Recorder", false, function(state)
        if state then
            -- Start session
            V.liveStats = {}
            V._rawNC = {}
            V.captured = {}
            V.counter = 0
            V.sessionOn = true
            V.enabled = true
            V.sessionState = "recording"
            V.sessionStartedAt = tick()
            V.sessionStoppedAt = 0
            if V.StatusDot then
                V.StatusDot.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
            end
            pcall(function() print("[VANZ] SESSION START") end)
        else
            -- Stop session
            V.sessionOn = false
            V.enabled = false
            V.sessionState = "stopped"
            V.sessionStoppedAt = tick()
            if V.StatusDot then
                V.StatusDot.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
            end
            pcall(function() print("[VANZ] SESSION STOP") end)
        end
    end)
    V.setSessionToggle = setSession

    V:section(Tab, "▎ STATIC ANALYSIS")

    local _, setStatic = V:toggle(Tab, "Static Script Scanner", false, function(state)
        if state then
            pcall(function() print("[VANZ] Static scan queued (sync)") end)
            if V.runStaticScan then
                task.spawn(function()
                    pcall(function() V:runStaticScan() end)
                end)
            end
        else
            pcall(function() print("[VANZ] Static scan cancelled") end)
        end
    end)
    V.setStaticToggle = setStatic

    V:section(Tab, "▎ CROSS-REFERENCE")

    local _, setCross = V:toggle(Tab, "Cross-Reference Analyzer", false, function(state)
        if state then
            if V.runCrossReference then
                task.spawn(function()
                    pcall(function() V:runCrossReference() end)
                end)
            end
        end
    end)
    V.setCrossToggle = setCross

    V:section(Tab, "▎ REPORT")

    V:button(Tab, "📋 COPY STATIC REPORT", Color3.fromRGB(0, 136, 204), function()
        if V.buildStaticReport and V.HAS.setclipboard then
            local report = V:buildStaticReport()
            if report then
                local fn = _G.setclipboard
                if type(fn) == "function" then
                    pcall(fn, report)
                    pcall(function() print("[VANZ] Static report copied: " .. #report .. " char") end)
                end
            end
        else
            pcall(function() print("[VANZ] setclipboard tidak tersedia atau report belum siap") end)
        end
    end)

    V:button(Tab, "📋 COPY CROSS REPORT", Color3.fromRGB(0, 136, 204), function()
        if V.buildCrossReport and V.HAS.setclipboard then
            local report = V:buildCrossReport()
            if report then
                local fn = _G.setclipboard
                if type(fn) == "function" then
                    pcall(fn, report)
                    pcall(function() print("[VANZ] Cross report copied: " .. #report .. " char") end)
                end
            end
        end
    end)

    V:section(Tab, "▎ DEBUG")

    V:button(Tab, "🔍 DUMP SCRIPT SAMPLES", Color3.fromRGB(140, 100, 80), function()
        if V.dumpScriptSamples then
            V:dumpScriptSamples(5)
        end
    end)

    V:button(Tab, "🧹 CLEAR ALL DATA", Color3.fromRGB(150, 70, 70), function()
        V.liveStats = {}
        V._rawNC = {}
        V.captured = {}
        V.staticScripts = {}
        V.staticFindings = {}
        V.staticState = "none"
        V.crossFindings = {}
        V.crossState = "none"
        pcall(function() print("[VANZ] data cleared") end)
    end)

    pcall(function() print("[VANZ] MAIN tab built") end)
end

-- vanz
do
    -- =========================================================
    -- BLOK 4 : CONFIG TAB UI
    -- =========================================================
    local V = _G.vanz
    if not V or not V.guiInstalled then return end

    local Tab = V.TabConfig

    V:section(Tab, "▎ HOOK SETTINGS")

    V:toggle(Tab, "Network Hook (FireServer)", false, function(state)
        V.toggles.networkHook = state
        if state then
            if V.installNetworkHook then
                V:installNetworkHook()
            end
        else
            pcall(function() print("[VANZ] Network hook disable = butuh re-inject") end)
        end
    end)

    V:toggle(Tab, "Verbose Log", false, function(state)
        V.toggles.verboseLog = state
    end)

    V:toggle(Tab, "Auto Dump After Scan", false, function(state)
        V.toggles.autoDump = state
    end)

    V:section(Tab, "▎ SCANNER SETTINGS")

    V:toggle(Tab, "Decompile Scripts", true, function(state)
        V.cfg = V.cfg or {}
        V.cfg.decompile = state
    end)

    V:toggle(Tab, "Include ModuleScript", true, function(state)
        V.cfg = V.cfg or {}
        V.cfg.includeModule = state
    end)

    V:toggle(Tab, "Include LocalScript", true, function(state)
        V.cfg = V.cfg or {}
        V.cfg.includeLocal = state
    end)

    V:section(Tab, "▎ EXECUTOR INFO")

    local capText = ""
    if V.HAS then
        for k, val in pairs(V.HAS) do
            capText = capText .. k .. ": " .. (val and "YES" or "NO") .. "\n"
        end
    end
    V:info(Tab, capText ~= "" and capText or "Capabilities unknown", 140)

    pcall(function() print("[VANZ] CONFIG tab built") end)
end

-- vanz
do
    -- =========================================================
    -- BLOK 5 : LOG TAB (in-GUI log viewer)
    -- =========================================================
    local V = _G.vanz
    if not V or not V.guiInstalled then return end

    local Tab = V.TabLog

    V:section(Tab, "▎ LOG OUTPUT")

    local LogLabel = V:info(Tab, "(no logs yet)", 300)
    V.LogLabel = LogLabel

    -- Simple log buffer
    V.logLines = {}
    V.MAX_LOG = 200

    function V:guiLog(msg)
        table.insert(self.logLines, msg)
        while #self.logLines > self.MAX_LOG do
            table.remove(self.logLines, 1)
        end
        if self.LogLabel then
            local text = table.concat(self.logLines, "\n")
            self.LogLabel.Text = text
        end
    end

    V:button(Tab, "🧹 CLEAR LOG", Color3.fromRGB(150, 70, 70), function()
        V.logLines = {}
        if V.LogLabel then V.LogLabel.Text = "(no logs yet)" end
    end)

    pcall(function() print("[VANZ] LOG tab built") end)
end

-- vanz
do
    -- =========================================================
    -- BLOK 6 : STATUS TAB UI
    -- =========================================================
    local V = _G.vanz
    if not V or not V.guiInstalled then return end

    local Tab = V.TabStatus

    V:section(Tab, "▎ LIVE STATUS")

    local StatusLabel = V:info(Tab,
        "Session: none\nStatic: none\nCross: none\n\nRemotes: 0\nFindings: 0",
        140)
    V.StatusLabel = StatusLabel

    -- Refresh loop
    task.spawn(function()
        while V.scriptAlive and not V.destroyed do
            task.wait(0.5)
            local rCount, cCount = 0, 0
            for _, s in pairs(V.liveStats or {}) do
                rCount = rCount + 1
                cCount = cCount + s.callCount
            end
            local txt = string.format(
                "Session: %s\nStatic: %s\nCross: %s\n\nRemotes: %d\nCalls: %d\nFindings: %d\n\nStatic scripts: %d\nPlaceholder: %d",
                V.sessionState or "none",
                V.staticState or "none",
                V.crossState or "none",
                rCount, cCount,
                #(V.staticFindings or {}) + #(V.crossFindings or {}),
                #(V.staticScripts or {}),
                (function()
                    local p = 0
                    for _, s in ipairs(V.staticScripts or {}) do
                        if not s.valid then p = p + 1 end
                    end
                    return p
                end)()
            )
            if V.StatusLabel then
                V.StatusLabel.Text = txt
            end
        end
    end)

    pcall(function() print("[VANZ] STATUS tab built") end)
end

-- vanz
do
    -- =========================================================
    -- BLOK 7 : NETWORK HOOK (defensive)
    -- =========================================================
    local V = _G.vanz
    if not V or not V.guiInstalled then return end

    local function safeFullName(inst)
        if typeof(inst) ~= "Instance" then return "?" end
        local ok, r = pcall(function() return inst:GetFullName() end)
        return ok and r or ("<" .. tostring(inst.Name) .. ">")
    end

    function V:installNetworkHook()
        local HAS = V.HAS or {}
        if not (HAS.getrawmetatable and HAS.setreadonly and HAS.newcclosure and HAS.getnamecallmethod) then
            pcall(function() print("[VANZ] Network hook unavailable - missing executor functions") end)
            return
        end

        local success = pcall(function()
            local mt = _G.getrawmetatable(game)
            if not mt then return end
            local oldNamecall = mt.__namecall
            if not oldNamecall then return end

            _G.setreadonly(mt, false)
            mt.__namecall = _G.newcclosure(function(self, ...)
                local method = _G.getnamecallmethod()
                if V.enabled and (method == "FireServer" or method == "InvokeServer") then
                    local args = {...}
                    if method == "InvokeServer" then
                        local result = oldNamecall(self, ...)
                        table.insert(V._rawNC, {
                            self = self, method = method, args = args, result = result
                        })
                        return result
                    else
                        table.insert(V._rawNC, {
                            self = self, method = method, args = args
                        })
                    end
                end
                return oldNamecall(self, ...)
            end)
            _G.setreadonly(mt, true)
            pcall(function() print("[VANZ] Network hook installed") end)
        end)

        if not success then
            pcall(function() print("[VANZ] Network hook FAILED") end)
        end
    end

    -- Auto-install if toggle on
    if V.toggles and V.toggles.networkHook then
        V:installNetworkHook()
    end

    -- Worker: drain queue into liveStats
    task.spawn(function()
        while V.scriptAlive and not V.destroyed do
            task.wait(0.1)
            if V._rawNC and #V._rawNC > 0 then
                local queue = V._rawNC
                V._rawNC = {}
                for _, item in ipairs(queue) do
                    pcall(function()
                        local name = safeFullName(item.self)
                        local stat = V.liveStats[name]
                        if not stat then
                            stat = { callCount = 0, fires = 0, invokes = 0, argCounts = {} }
                            V.liveStats[name] = stat
                        end
                        stat.callCount = stat.callCount + 1
                        if item.method == "InvokeServer" then
                            stat.invokes = stat.invokes + 1
                        else
                            stat.fires = stat.fires + 1
                        end
                        local ac = #item.args
                        stat.argCounts[ac] = (stat.argCounts[ac] or 0) + 1
                    end)
                end
            end
        end
    end)

    pcall(function() print("[VANZ] network hook worker started") end)
end

-- vanz
do
    -- =========================================================
    -- BLOK 8 : STATIC SCANNER (defensive)
    -- =========================================================
    local V = _G.vanz
    if not V or not V.guiInstalled then return end

    local function isPlaceholder(src)
        if not src or type(src) ~= "string" then return true end
        local t = src:gsub("^%s+", ""):gsub("%s+$", "")
        if #t < 50 then return true end
        local lower = t:lower()
        if lower:find("unavailable", 1, true) then return true end
        if lower:find("cannot decompile", 1, true) then return true end
        if lower:find("bytecode only", 1, true) then return true end
        return false
    end

    local function tryGetSource(inst)
        -- Method 1: .Source
        local ok, src = pcall(function() return inst.Source end)
        if ok and type(src) == "string" and #src > 0 and not isPlaceholder(src) then
            return src, "Source"
        end

        -- Method 2: bytecode + decompile
        if V.HAS.getscriptbytecode then
            local ok2, bc = pcall(_G.getscriptbytecode, inst)
            if ok2 and type(bc) == "string" and #bc > 0 then
                if V.HAS.decompile then
                    local ok3, dec = pcall(_G.decompile, bc)
                    if ok3 and type(dec) == "string" and #dec > 0 and not isPlaceholder(dec) then
                        return dec, "decompile"
                    end
                end
            end
        end

        return nil, "unavailable"
    end

    local function safeAddRoot(roots, parent)
        if not parent then return end
        local ok = pcall(function() local _ = parent.Name end)
        if ok then table.insert(roots, parent) end
    end

    function V:collectScripts()
        local results = {}
        local roots = {}

        safeAddRoot(roots, game:GetService("ReplicatedStorage"))
        safeAddRoot(roots, game:GetService("ReplicatedFirst"))
        safeAddRoot(roots, game:GetService("StarterGui"))
        safeAddRoot(roots, game:GetService("StarterPlayer"))
        safeAddRoot(roots, game:GetService("StarterPack"))
        safeAddRoot(roots, workspace)

        local Players = game:GetService("Players")
        local LP = Players.LocalPlayer
        if LP then
            local ps = LP:FindFirstChild("PlayerScripts")
            if ps then table.insert(roots, ps) end
            local pg = LP:FindFirstChild("PlayerGui")
            if pg then table.insert(roots, pg) end
        end

        for _, plr in ipairs(Players:GetPlayers()) do
            local char = plr and plr.Character
            if char then table.insert(roots, char) end
        end

        -- Dedup
        local seenRoot = {}
        local uniqueRoots = {}
        for _, r in ipairs(roots) do
            if not seenRoot[r] then
                seenRoot[r] = true
                table.insert(uniqueRoots, r)
            end
        end

        local seen = {}
        for _, root in ipairs(uniqueRoots) do
            local ok, descendants = pcall(function() return root:GetDescendants() end)
            if ok and descendants then
                for _, obj in ipairs(descendants) do
                    local isScript = obj:IsA("LocalScript") or obj:IsA("ModuleScript") or obj:IsA("Script")
                    if isScript and not seen[obj] then
                        seen[obj] = true
                        local pathOk, path = pcall(function() return obj:GetFullName() end)
                        path = pathOk and path or ("<" .. tostring(obj.Name) .. ">")
                        local srcOk, src, method = pcall(function() return tryGetSource(obj) end)
                        if srcOk and type(src) == "string" and #src > 0 then
                            table.insert(results, {
                                path = path, className = obj.ClassName,
                                source = src, method = method or "?", size = #src,
                                valid = true,
                            })
                        else
                            table.insert(results, {
                                path = path, className = obj.ClassName,
                                source = "", method = "FAILED", size = 0,
                                valid = false,
                                note = tostring(method or "unavailable"),
                            })
                        end
                    end
                end
            end
        end
        return results
    end

    function V:runStaticScan()
        self.staticState = "running"
        self.staticScripts = {}
        self.staticFindings = {}
        self.staticProgress = { total = 0, done = 0, current = "" }

        pcall(function() print("[VANZ] STATIC SCAN START") end)

        local ok, scripts = pcall(function() return self:collectScripts() end)
        if not ok then
            self.staticState = "error"
            pcall(function() print("[VANZ] collect failed: " .. tostring(scripts)) end)
            return
        end

        self.staticProgress.total = #scripts
        local validCount = 0
        local placeholderCount = 0

        for idx, info in ipairs(scripts) do
            self.staticProgress.done = idx
            self.staticProgress.current = info.path
            if info.valid then
                validCount = validCount + 1
            else
                placeholderCount = placeholderCount + 1
            end
            table.insert(self.staticScripts, info)
            task.wait()
        end

        self.staticState = "done"
        self.staticProgress.current = ""

        pcall(function()
            print("[VANZ] STATIC SCAN DONE")
            print("[VANZ] Valid: " .. validCount)
            print("[VANZ] Placeholder: " .. placeholderCount)
        end)
    end

    function V:dumpScriptSamples(limit)
        limit = limit or 5
        pcall(function() print("[VANZ] ===== SAMPLES =====") end)
        local shown = 0
        for _, info in ipairs(self.staticScripts) do
            if info.valid and shown < limit then
                shown = shown + 1
                pcall(function()
                    print("--- SAMPLE #" .. shown .. " ---")
                    print("PATH: " .. info.path)
                    print("SIZE: " .. info.size)
                    print(info.source:sub(1, 500))
                end)
            end
        end
        pcall(function() print("[VANZ] ===== END =====") end)
    end

    function V:runCrossReference()
        self.crossState = "running"
        self.crossFindings = {}
        -- minimal: nothing fancy without static findings
        self.crossState = "done"
        pcall(function() print("[VANZ] CROSS-REF DONE") end)
    end

    function V:buildStaticReport()
        local lines = {}
        lines[#lines + 1] = "VANZHUB STATIC REPORT"
        lines[#lines + 1] = "Scripts: " .. #(self.staticScripts or {})
        lines[#lines + 1] = "Findings: " .. #(self.staticFindings or {})
        return table.concat(lines, "\n")
    end

    function V:buildCrossReport()
        return "VANZHUB CROSS REPORT\nFindings: " .. #(self.crossFindings or {})
    end

    pcall(function() print("[VANZ] static scanner ready") end)
end

-- vanz
do
    -- =========================================================
    -- BLOK 9 : WATCHDOG (keep GUI responsive)
    -- =========================================================
    local V = _G.vanz
    if not V then return end

    task.spawn(function()
        while V.scriptAlive do
            task.wait(1)
            pcall(function()
                if V.ScreenGui and not V.ScreenGui.Parent then
                    V.scriptAlive = false
                end
            end)
        end
    end)

    pcall(function() print("[VANZ] watchdog started") end)
end

-- vanz
do
    -- =========================================================
    -- BLOK 10 : FINAL BOOT MESSAGE
    -- =========================================================
    local V = _G.vanz
    if not V then return end

    pcall(function()
        print("")
        print("==============================================")
        print(" VANZHUB ANALYZER v2.0 (Mod Menu Style)")
        print("==============================================")
        print("Tabs: MAIN | CONFIG | LOG | STATUS")
        print("Minimize = logo. Klik logo = restore.")
        print("Logo bisa di-drag ke mana aja.")
        print("==============================================")
    end)
end
