-- vanz
do
    -- =========================================================
    -- BLOK 0 : BOOTSTRAP + SAFE HELPERS
    -- =========================================================
    pcall(function() print("[VANZ] booting...") end)

    local function g(name)
        local ok, v = pcall(function() return _G[name] end)
        if ok then return v end
        return nil
    end

    local function hasFn(name)
        local v = g(name)
        return type(v) == "function"
    end

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

    _G.vanz = _G.vanz or {}
    local V = _G.vanz
    V.HAS = HAS
    V.scriptAlive = true

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

    if V.guiInstalled then
        pcall(function()
            if V.ScreenGui then V.ScreenGui.Enabled = true end
            if V.Main then V.Main.Visible = true end
            if V.Logo then V.Logo.Visible = false end
        end)
        return
    end

    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer

    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(360, 640)
    local GUI_W = math.min(260, vp.X - 30)
    local GUI_H = math.floor(vp.Y * 0.85)

    pcall(function()
        if CoreGui:FindFirstChild("VanzMenu") then CoreGui.VanzMenu:Destroy() end
    end)

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

    -- TAB BAR (5 tabs now)
    local TabBar = Instance.new("Frame")
    TabBar.Position = UDim2.new(0, 8, 0, 38)
    TabBar.Size = UDim2.new(1, -16, 0, 22)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = Main
    local tbl = Instance.new("UIListLayout", TabBar)
    tbl.FillDirection = Enum.FillDirection.Horizontal
    tbl.Padding = UDim.new(0, 3)
    tbl.SortOrder = Enum.SortOrder.LayoutOrder

    local Content = Instance.new("Frame")
    Content.Position = UDim2.new(0, 8, 0, 66)
    Content.Size = UDim2.new(1, -16, 1, -74)
    Content.BackgroundTransparency = 1
    Content.Parent = Main
    V.Content = Content

    V.TabFrames = {}
    V.TabButtons = {}

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

    -- Tab button: smaller width to fit 5 tabs
    local function makeTabButton(text, frame, active)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 44, 1, 0)
        b.BackgroundColor3 = active and Color3.fromRGB(60, 50, 100) or Color3.fromRGB(32, 32, 44)
        b.Text = text
        b.TextColor3 = active and Color3.fromRGB(235, 235, 245) or Color3.fromRGB(180, 180, 200)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 8
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

    -- 5 tabs
    local TabMain = makeTabFrame()
    local TabConfig = makeTabFrame()
    local TabLog = makeTabFrame()
    local TabStatus = makeTabFrame()
    local TabFeatureStatus = makeTabFrame()    -- NEW: STATUS FITUR

    local BtnMain = makeTabButton("MAIN", TabMain, true)
    local BtnConfig = makeTabButton("CONFIG", TabConfig, false)
    local BtnLog = makeTabButton("LOG", TabLog, false)
    local BtnStatus = makeTabButton("INFO", TabStatus, false)
    local BtnFeature = makeTabButton("FITUR", TabFeatureStatus, false)

    TabMain.Visible = true

    V.TabMain = TabMain
    V.TabConfig = TabConfig
    V.TabLog = TabLog
    V.TabStatus = TabStatus
    V.TabFeatureStatus = TabFeatureStatus

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

    -- TOGGLE HELPER
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

        return Row, function(newState)
            state = newState
            Btn.BackgroundColor3 = state and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 70)
            Btn.Text = state and "ON" or "OFF"
        end
    end

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

    -- LOGO
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

    MinBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        Logo.Visible = true
    end)

    V.guiInstalled = true
    pcall(function() print("[VANZ] GUI loaded") end)
end

-- vanz
do
    -- =========================================================
    -- BLOK 2 : STATE INITIALIZATION + FEATURE STATUS TRACKER
    -- =========================================================
    local V = _G.vanz
    if not V or not V.guiInstalled then return end

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

    V.toggles = {
        networkHook = false,
        verboseLog = false,
        autoDump = false,
    }

    -- ============================================
    -- FEATURE STATUS TRACKER (untuk tab FITUR)
    -- ============================================
    -- Format: key = { label, state, note }
    -- state: "belum" | "proses" | "selesai" | "error"
    V.features = {
        networkHook     = { label = "Network Hook",           state = "belum", note = "" },
        sessionRec      = { label = "Session Recorder",       state = "belum", note = "" },
        staticScan      = { label = "Static Script Scanner",  state = "belum", note = "" },
        dumpSamples     = { label = "Dump Script Samples",    state = "belum", note = "" },
        crossRef        = { label = "Cross-Reference",        state = "belum", note = "" },
        copyStatic      = { label = "Copy Static Report",     state = "belum", note = "" },
        copyCross       = { label = "Copy Cross Report",      state = "belum", note = "" },
        clearData       = { label = "Clear All Data",         state = "belum", note = "" },
    }

    function V:setFeature(key, state, note)
        if not self.features[key] then
            self.features[key] = { label = key, state = state, note = note or "" }
            return
        end
        self.features[key].state = state
        if note ~= nil then self.features[key].note = note end
    end

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
            V:setFeature("sessionRec", "proses", "recording...")
            pcall(function() print("[VANZ] SESSION START") end)
        else
            V.sessionOn = false
            V.enabled = false
            V.sessionState = "stopped"
            V.sessionStoppedAt = tick()
            if V.StatusDot then
                V.StatusDot.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
            end
            local rCount = 0
            for _ in pairs(V.liveStats) do rCount = rCount + 1 end
            V:setFeature("sessionRec", "selesai", rCount .. " remotes")
            pcall(function() print("[VANZ] SESSION STOP") end)
        end
    end)
    V.setSessionToggle = setSession

    V:section(Tab, "▎ STATIC ANALYSIS")

    local _, setStatic = V:toggle(Tab, "Static Script Scanner", false, function(state)
        if state then
            V:setFeature("staticScan", "proses", "scanning...")
            pcall(function() print("[VANZ] Static scan starting...") end)
            if V.runStaticScan then
                task.spawn(function()
                    local ok, err = pcall(function() V:runStaticScan() end)
                    if ok then
                        local v = 0
                        for _, s in ipairs(V.staticScripts or {}) do
                            if s.valid then v = v + 1 end
                        end
                        V:setFeature("staticScan", "selesai", v .. " valid")
                    else
                        V:setFeature("staticScan", "error", tostring(err):sub(1, 30))
                    end
                end)
            end
        end
    end)
    V.setStaticToggle = setStatic

    V:section(Tab, "▎ CROSS-REFERENCE")

    local _, setCross = V:toggle(Tab, "Cross-Reference Analyzer", false, function(state)
        if state then
            V:setFeature("crossRef", "proses", "analyzing...")
            if V.runCrossReference then
                task.spawn(function()
                    local ok, err = pcall(function() V:runCrossReference() end)
                    if ok then
                        V:setFeature("crossRef", "selesai", #(V.crossFindings or {}) .. " findings")
                    else
                        V:setFeature("crossRef", "error", tostring(err):sub(1, 30))
                    end
                end)
            end
        end
    end)
    V.setCrossToggle = setCross

    V:section(Tab, "▎ REPORT")

    V:button(Tab, "📋 COPY STATIC REPORT", Color3.fromRGB(0, 136, 204), function()
        V:setFeature("copyStatic", "proses", "")
        if V.buildStaticReport and V.HAS.setclipboard then
            local report = V:buildStaticReport()
            if report then
                local fn = _G.setclipboard
                if type(fn) == "function" then
                    local ok = pcall(fn, report)
                    if ok then
                        V:setFeature("copyStatic", "selesai", #report .. " chars")
                        pcall(function() print("[VANZ] Static report copied") end)
                    else
                        V:setFeature("copyStatic", "error", "clipboard fail")
                    end
                end
            else
                V:setFeature("copyStatic", "error", "no report")
            end
        else
            V:setFeature("copyStatic", "error", "no clipboard/report")
        end
    end)

    V:button(Tab, "📋 COPY CROSS REPORT", Color3.fromRGB(0, 136, 204), function()
        V:setFeature("copyCross", "proses", "")
        if V.buildCrossReport and V.HAS.setclipboard then
            local report = V:buildCrossReport()
            if report then
                local fn = _G.setclipboard
                if type(fn) == "function" then
                    local ok = pcall(fn, report)
                    if ok then
                        V:setFeature("copyCross", "selesai", #report .. " chars")
                        pcall(function() print("[VANZ] Cross report copied") end)
                    else
                        V:setFeature("copyCross", "error", "clipboard fail")
                    end
                end
            end
        else
            V:setFeature("copyCross", "error", "no clipboard/report")
        end
    end)

    V:section(Tab, "▎ DEBUG")

    V:button(Tab, "🔍 DUMP SCRIPT SAMPLES", Color3.fromRGB(140, 100, 80), function()
        V:setFeature("dumpSamples", "proses", "")
        if V.dumpScriptSamples then
            local ok = pcall(function() V:dumpScriptSamples(5) end)
            if ok then
                V:setFeature("dumpSamples", "selesai", "check console")
            else
                V:setFeature("dumpSamples", "error", "dump fail")
            end
        end
    end)

    V:button(Tab, "🧹 CLEAR ALL DATA", Color3.fromRGB(150, 70, 70), function()
        V:setFeature("clearData", "proses", "")
        V.liveStats = {}
        V._rawNC = {}
        V.captured = {}
        V.staticScripts = {}
        V.staticFindings = {}
        V.staticState = "none"
        V.crossFindings = {}
        V.crossState = "none"
        V:setFeature("clearData", "selesai", "done")
        V:setFeature("sessionRec", "belum", "")
        V:setFeature("staticScan", "belum", "")
        V:setFeature("crossRef", "belum", "")
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
            V:setFeature("networkHook", "proses", "installing...")
            if V.installNetworkHook then
                local ok = pcall(function() V:installNetworkHook() end)
                if ok and V.toggles.networkHook then
                    V:setFeature("networkHook", "selesai", "installed")
                else
                    V:setFeature("networkHook", "error", "fail - check console")
                end
            else
                V:setFeature("networkHook", "error", "no installer")
            end
        else
            V:setFeature("networkHook", "belum", "disabled")
            pcall(function() print("[VANZ] Network hook disable = butuh re-inject") end)
        end
    end)

    V:toggle(Tab, "Verbose Log", false, function(state)
        V.toggles.verboseLog = state
    end)

    V:toggle(Tab, "Auto Dump After Scan", false, function(state)
        V.toggles.autoDump = state
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
    -- BLOK 5 : LOG TAB
    -- =========================================================
    local V = _G.vanz
    if not V or not V.guiInstalled then return end

    local Tab = V.TabLog

    V:section(Tab, "▎ LOG OUTPUT")

    local LogLabel = V:info(Tab, "(no logs yet)", 300)
    V.LogLabel = LogLabel

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
    -- BLOK 6 : INFO TAB (was STATUS)
    -- =========================================================
    local V = _G.vanz
    if not V or not V.guiInstalled then return end

    local Tab = V.TabStatus

    V:section(Tab, "▎ LIVE INFO")

    local StatusLabel = V:info(Tab,
        "Session: none\nStatic: none\nCross: none\n\nRemotes: 0\nFindings: 0",
        140)
    V.StatusLabel = StatusLabel

    task.spawn(function()
        while V.scriptAlive and not V.destroyed do
            task.wait(0.5)
            local rCount, cCount = 0, 0
            for _, s in pairs(V.liveStats or {}) do
                rCount = rCount + 1
                cCount = cCount + s.callCount
            end
            local placeholderC = 0
            for _, s in ipairs(V.staticScripts or {}) do
                if not s.valid then placeholderC = placeholderC + 1 end
            end
            local txt = string.format(
                "Session: %s\nStatic: %s\nCross: %s\n\nRemotes: %d\nCalls: %d\nFindings: %d\n\nStatic scripts: %d\nPlaceholder: %d",
                V.sessionState or "none",
                V.staticState or "none",
                V.crossState or "none",
                rCount, cCount,
                #(V.staticFindings or {}) + #(V.crossFindings or {}),
                #(V.staticScripts or {}),
                placeholderC
            )
            if V.StatusLabel then
                V.StatusLabel.Text = txt
            end
        end
    end)

    pcall(function() print("[VANZ] INFO tab built") end)
end

-- vanz
do
    -- =========================================================
    -- BLOK 7 : FEATURE STATUS TAB (NEW)
    -- =========================================================
    local V = _G.vanz
    if not V or not V.guiInstalled then return end

    local Tab = V.TabFeatureStatus

    V:section(Tab, "▎ FEATURE STATUS", Color3.fromRGB(150, 255, 150))

    -- Legend
    local Legend = V:info(Tab,
        "○ BELUM   ◐ PROSES   ● SELESAI   ✗ ERROR\n\nState di-refresh otomatis tiap 0.5 detik.",
        50)
    Legend.TextColor3 = Color3.fromRGB(180, 180, 200)

    V:section(Tab, "▎ FEATURES", Color3.fromRGB(150, 255, 150))

    -- Row builder
    V.featureRows = {}

    local STATE_STYLES = {
        belum   = { icon = "○", color = Color3.fromRGB(150, 150, 160), text = "BELUM" },
        proses  = { icon = "◐", color = Color3.fromRGB(255, 200, 100), text = "PROSES..." },
        selesai = { icon = "●", color = Color3.fromRGB(120, 220, 120), text = "SELESAI" },
        error   = { icon = "✗", color = Color3.fromRGB(255, 100, 100), text = "ERROR" },
    }

    local featureOrder = {
        "networkHook",
        "sessionRec",
        "staticScan",
        "dumpSamples",
        "crossRef",
        "copyStatic",
        "copyCross",
        "clearData",
    }

    for _, key in ipairs(featureOrder) do
        local feature = V.features[key]
        if feature then
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 34)
            row.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            row.BorderSizePixel = 0
            row.Parent = Tab
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

            local icon = Instance.new("TextLabel")
            icon.Size = UDim2.new(0, 24, 0, 34)
            icon.Position = UDim2.new(0, 4, 0, 0)
            icon.BackgroundTransparency = 1
            icon.Text = "○"
            icon.TextColor3 = Color3.fromRGB(150, 150, 160)
            icon.Font = Enum.Font.GothamBold
            icon.TextSize = 16
            icon.Parent = row

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -40, 0, 16)
            label.Position = UDim2.new(0, 30, 0, 2)
            label.BackgroundTransparency = 1
            label.Text = feature.label
            label.TextColor3 = Color3.fromRGB(220, 220, 235)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 10
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = row

            local stateLbl = Instance.new("TextLabel")
            stateLbl.Size = UDim2.new(1, -40, 0, 14)
            stateLbl.Position = UDim2.new(0, 30, 0, 16)
            stateLbl.BackgroundTransparency = 1
            stateLbl.Text = "BELUM"
            stateLbl.TextColor3 = Color3.fromRGB(160, 160, 180)
            stateLbl.Font = Enum.Font.Code
            stateLbl.TextSize = 9
            stateLbl.TextXAlignment = Enum.TextXAlignment.Left
            stateLbl.Parent = row

            V.featureRows[key] = {
                icon = icon,
                state = stateLbl,
                row = row,
                label = label,
            }
        end
    end

    -- Summary
    V:section(Tab, "▎ SUMMARY", Color3.fromRGB(150, 255, 150))

    local SummaryLbl = V:info(Tab, "Selesai: 0\nProses: 0\nBelum: 0\nError: 0", 90)
    V.FeatureSummaryLbl = SummaryLbl

    -- Reset all button
    V:button(Tab, "🔄 RESET SEMUA STATUS", Color3.fromRGB(80, 80, 130), function()
        for key, _ in pairs(V.features) do
            V:setFeature(key, "belum", "")
        end
        pcall(function() print("[VANZ] semua status fitur di-reset") end)
    end)

    -- Refresh loop untuk tab FITUR
    task.spawn(function()
        while V.scriptAlive and not V.destroyed do
            task.wait(0.5)

            local done, proses, belum, error_ = 0, 0, 0, 0

            for key, row in pairs(V.featureRows or {}) do
                local feature = V.features[key]
                if feature then
                    local style = STATE_STYLES[feature.state] or STATE_STYLES.belum

                    row.icon.Text = style.icon
                    row.icon.TextColor3 = style.color

                    local labelText = style.text
                    if feature.note and feature.note ~= "" then
                        labelText = labelText .. "  |  " .. feature.note
                    end
                    row.state.Text = labelText
                    row.state.TextColor3 = style.color

                    -- Row background glow saat proses
                    row.row.BackgroundColor3 = (feature.state == "proses")
                        and Color3.fromRGB(50, 45, 30)
                        or Color3.fromRGB(28, 28, 38)

                    if feature.state == "selesai" then done = done + 1
                    elseif feature.state == "proses" then proses = proses + 1
                    elseif feature.state == "error" then error_ = error_ + 1
                    else belum = belum + 1 end
                end
            end

            if V.FeatureSummaryLbl then
                V.FeatureSummaryLbl.Text = string.format(
                    "Selesai : %d\nProses  : %d\nBelum   : %d\nError   : %d",
                    done, proses, belum, error_
                )
            end
        end
    end)

    pcall(function() print("[VANZ] FEATURE STATUS tab built") end)
end

-- vanz
do
    -- =========================================================
    -- BLOK 8 : NETWORK HOOK (defensive)
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
            pcall(function() print("[VANZ] Network hook unavailable") end)
            V.toggles.networkHook = false
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
            V.toggles.networkHook = false
        else
            V.toggles.networkHook = true
        end
    end

    if V.toggles and V.toggles.networkHook then
        V:installNetworkHook()
    end

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
    -- BLOK 9 : STATIC SCANNER (defensive)
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
        local ok, src = pcall(function() return inst.Source end)
        if ok and type(src) == "string" and #src > 0 and not isPlaceholder(src) then
            return src, "Source"
        end

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
            pcall(function() print("[VANZ] collect failed") end)
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
    -- BLOK 10 : WATCHDOG
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
    -- BLOK 11 : BOOT MESSAGE
    -- =========================================================
    local V = _G.vanz
    if not V then return end

    pcall(function()
        print("")
        print("==============================================")
        print(" VANZHUB ANALYZER v2.1 (5 Tabs)")
        print("==============================================")
        print("Tabs: MAIN | CONFIG | LOG | INFO | FITUR")
        print("Tab FITUR = status semua feature realtime")
        print("Minimize = logo. Klik logo = restore.")
        print("==============================================")
    end)
end
