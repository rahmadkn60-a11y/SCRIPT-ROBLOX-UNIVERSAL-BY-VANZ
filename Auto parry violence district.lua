local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local LP = Players.LocalPlayer

local ATTACK_IDS = {
    "139369275981139",
    "121216847022485",
    "78935059863801",
    "74968262036854",
    "82666958311998",
    "78432063483146",
    "132817836308238",
    "111920872708571",
    "138720291317243",
    "130593238885843",
    "106871536134254",
    "109402730355822"
}

local T = {
    bg = Color3.fromRGB(16, 14, 20),
    panel = Color3.fromRGB(26, 22, 32),
    row = Color3.fromRGB(34, 28, 42),
    accent = Color3.fromRGB(255, 90, 140),
    text = Color3.fromRGB(235, 225, 240),
    dim = Color3.fromRGB(150, 135, 165),
    on = Color3.fromRGB(90, 205, 130),
    off = Color3.fromRGB(70, 60, 82)
}

for _, n in ipairs({"vanzAutoParry"}) do
    pcall(
        function()
            if gethui then
                local h = gethui()
                local o = h:FindFirstChild(n)
                if o then
                    o:Destroy()
                end
            end
        end
    )
    pcall(
        function()
            local o = CoreGui:FindFirstChild(n)
            if o then
                o:Destroy()
            end
        end
    )
    pcall(
        function()
            local o = LP:WaitForChild("PlayerGui"):FindFirstChild(n)
            if o then
                o:Destroy()
            end
        end
    )
end

local parentGui = LP:WaitForChild("PlayerGui")
pcall(
    function()
        if gethui then
            local h = gethui()
            if h then
                parentGui = h
            end
        end
    end
)

local screen = Instance.new("ScreenGui")
screen.Name = "vanzAutoParry"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.DisplayOrder = 999999
screen.Enabled = true
screen.Parent = parentGui

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Size = UDim2.new(0, 240, 0, 240)
main.Position = UDim2.new(0.5, 0, 0.3, 0)
main.BackgroundColor3 = T.bg
main.BorderSizePixel = 0
main.Active = true
main.Visible = true
main.ZIndex = 10
main.Parent = screen

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
local mstroke = Instance.new("UIStroke", main)
mstroke.Color = T.accent
mstroke.Thickness = 1.5
mstroke.Transparency = 0.3

local titleBar = Instance.new("Frame", main)
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = T.panel
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 11
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

local tfix = Instance.new("Frame", titleBar)
tfix.Size = UDim2.new(1, 0, 0, 14)
tfix.Position = UDim2.new(0, 0, 1, -14)
tfix.BackgroundColor3 = T.panel
tfix.BorderSizePixel = 0
tfix.ZIndex = 11

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "vanz ♡ Auto Parry"
title.TextColor3 = T.accent
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12

local minBtn = Instance.new("TextButton", titleBar)
minBtn.AnchorPoint = Vector2.new(1, 0.5)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -8, 0.5, 0)
minBtn.BackgroundColor3 = T.accent
minBtn.Text = "—"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 16
minBtn.Font = Enum.Font.GothamBold
minBtn.AutoButtonColor = false
minBtn.ZIndex = 13
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

local body = Instance.new("Frame", main)
body.Size = UDim2.new(1, -16, 1, -52)
body.Position = UDim2.new(0, 8, 0, 44)
body.BackgroundTransparency = 1
body.ZIndex = 11

local bodyLayout = Instance.new("UIListLayout", body)
bodyLayout.Padding = UDim.new(0, 6)
bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder

local logo = Instance.new("TextButton", screen)
logo.Name = "vanzAutoParryLogo"
logo.AnchorPoint = Vector2.new(0.5, 0)
logo.Size = UDim2.new(0, 54, 0, 54)
logo.Position = UDim2.new(0.5, 0, 0, 12)
logo.BackgroundColor3 = T.bg
logo.Text = "♡"
logo.TextColor3 = T.accent
logo.TextSize = 26
logo.Font = Enum.Font.GothamBold
logo.Visible = false
logo.Active = true
logo.AutoButtonColor = false
logo.ZIndex = 100
logo.Parent = screen
Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)
local logoStroke = Instance.new("UIStroke", logo)
logoStroke.Color = T.accent
logoStroke.Thickness = 2
logoStroke.Transparency = 0.2

local function makeToggle(name, default, cb)
    local row = Instance.new("Frame", body)
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = T.row
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -80, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = T.text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 50, 0, 24)
    btn.Position = UDim2.new(1, -60, 0.5, -12)
    btn.BackgroundColor3 = default and T.on or T.off
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local state = default
    btn.MouseButton1Click:Connect(
        function()
            state = not state
            btn.BackgroundColor3 = state and T.on or T.off
            btn.Text = state and "ON" or "OFF"
            if cb then
                pcall(cb, state)
            end
        end
    )
    return btn
end

local function makeSlider(name, mn, mx, default, cb)
    local r = Instance.new("Frame", body)
    r.Size = UDim2.new(1, 0, 0, 50)
    r.BackgroundColor3 = T.row
    r.BorderSizePixel = 0
    Instance.new("UICorner", r).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", r)
    lbl.Size = UDim2.new(1, -20, 0, 18)
    lbl.Position = UDim2.new(0, 12, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = name .. ": " .. default
    lbl.TextColor3 = T.text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local bar = Instance.new("Frame", r)
    bar.Size = UDim2.new(1, -24, 0, 8)
    bar.Position = UDim2.new(0, 12, 0, 30)
    bar.BackgroundColor3 = T.off
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default - mn) / (mx - mn), 0, 1, 0)
    fill.BackgroundColor3 = T.accent
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local dg = false
    local function upd(inp)
        local rel = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local v = math.floor(mn + (mx - mn) * rel + 0.5)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        lbl.Text = name .. ": " .. v
        if cb then
            pcall(cb, v)
        end
    end
    bar.InputBegan:Connect(
        function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dg = true
                upd(inp)
            end
        end
    )
    UserInputService.InputChanged:Connect(
        function(inp)
            if
                dg and
                    (inp.UserInputType == Enum.UserInputType.MouseMovement or
                        inp.UserInputType == Enum.UserInputType.Touch)
             then
                upd(inp)
            end
        end
    )
    UserInputService.InputEnded:Connect(
        function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dg = false
            end
        end
    )
    return r
end

local autoParryEnabled = false
local parryRange = 16
local rangeVisualEnabled = false

local function getGuiMob()
    local pg = LP:FindFirstChild("PlayerGui")
    if not pg then
        return nil
    end
    local survivorMob = pg:FindFirstChild("Survivor-mob")
    if not survivorMob then
        return nil
    end
    local controls = survivorMob:FindFirstChild("Controls")
    if not controls then
        return nil
    end
    local guiMob = controls:FindFirstChild("Gui-mob")
    if not guiMob then
        return nil
    end
    return guiMob
end

local function fireGuiMob()
    local guiMob = getGuiMob()
    if not guiMob then
        return false
    end
    pcall(
        function()
            if firesignal then
                firesignal(guiMob.MouseButton1Down)
            elseif fireclickdetector then
                fireclickdetector(guiMob)
            end
        end
    )
    return true
end

local function getKillerChar(plr)
    if not plr or plr == LP then
        return nil
    end
    local char = plr.Character
    if not char then
        return nil
    end
    if char:FindFirstChild("Lookscriptkiller", true) then
        return char
    end
    return nil
end

local function getHrp(char)
    if not char then
        return nil
    end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or
        char:FindFirstChild("Head")
end

local function getMyHrp()
    local char = LP.Character
    if not char then
        return nil
    end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
end

local function isAttackAnimation(animName)
    if not animName then
        return false
    end
    local id = tostring(animName)
    if id:find("rbxassetid://") then
        id = id:gsub("rbxassetid://", "")
    end
    if id:find("rbxassetid%://") then
        id = id:gsub("rbxassetid%://", "")
    end
    if id:find("http") then
        id = id:match("(%d+)$") or id
    end
    for _, aid in ipairs(ATTACK_IDS) do
        if id == aid then
            return true
        end
    end
    return false
end

local activeAttack = {}

local function hookKillerChar(char)
    if not char then
        return
    end
    if activeAttack[char] then
        return
    end
    activeAttack[char] = {attacking = false, lastAttack = 0}
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then
        return
    end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        return
    end
    animator.AnimationPlayed:Connect(
        function(track)
            local aid = track.Animation and track.Animation.AnimationId or ""
            if isAttackAnimation(aid) then
                local data = activeAttack[char]
                if data then
                    data.attacking = true
                    data.lastAttack = tick()
                end
            end
        end
    )
end

local function watchPlayer(plr)
    if plr == LP then
        return
    end
    if plr.Character then
        hookKillerChar(plr.Character)
    end
    plr.CharacterAdded:Connect(
        function(char)
            task.wait(0.3)
            hookKillerChar(char)
        end
    )
end

for _, plr in ipairs(Players:GetPlayers()) do
    watchPlayer(plr)
end

Players.PlayerAdded:Connect(
    function(plr)
        watchPlayer(plr)
    end
)

local ringAdornment = nil
local ringConn = nil
local ringOnMyChar = nil

local function createRing()
    local myHrp = getMyHrp()
    if not myHrp then
        return
    end
    if ringAdornment and ringOnMyChar == myHrp then
        return
    end
    if ringAdornment then
        pcall(
            function()
                ringAdornment:Destroy()
            end
        )
        ringAdornment = nil
    end
    local ad = Instance.new("CylinderHandleAdornment")
    ad.Name = "vanzParryRing"
    ad.Adornee = myHrp
    ad.AlwaysOnTop = true
    ad.ZIndex = 5
    ad.Height = 0.2
    ad.Radius = parryRange
    ad.Color3 = Color3.fromRGB(255, 40, 40)
    ad.Transparency = 0.3
    ad.CFrame = CFrame.new(0, -2.5, 0) * CFrame.Angles(math.rad(90), 0, 0)
    ad.Parent = myHrp
    ringAdornment = ad
    ringOnMyChar = myHrp
end

local function destroyRing()
    if ringAdornment then
        pcall(
            function()
                ringAdornment:Destroy()
            end
        )
        ringAdornment = nil
    end
    ringOnMyChar = nil
end

local function checkKillerAttackingInRange()
    local myHrp = getMyHrp()
    if not myHrp then
        return false
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local char = getKillerChar(plr)
            if char then
                local data = activeAttack[char]
                if data then
                    local killerHrp = getHrp(char)
                    if killerHrp then
                        local dist = (killerHrp.Position - myHrp.Position).Magnitude
                        if dist <= parryRange then
                            if tick() - data.lastAttack < 1.5 then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

local lastFire = 0
local fireCooldown = 0.05

local function tryFireParry()
    if not autoParryEnabled then
        return
    end
    local now = tick()
    if now - lastFire < fireCooldown then
        return
    end
    local myHrp = getMyHrp()
    if not myHrp then
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local char = getKillerChar(plr)
            if char then
                local data = activeAttack[char]
                if data then
                    if tick() - data.lastAttack < 1.2 then
                        local killerHrp = getHrp(char)
                        if killerHrp then
                            local dist = (killerHrp.Position - myHrp.Position).Magnitude
                            if dist <= parryRange then
                                lastFire = now
                                fireGuiMob()
                                return
                            end
                        end
                    end
                end
            end
        end
    end
end

local function startLoop()
    if ringConn then
        ringConn:Disconnect()
    end
    ringConn =
        RunService.Heartbeat:Connect(
        function()
            if autoParryEnabled then
                tryFireParry()
            end
            if rangeVisualEnabled then
                if not ringAdornment or not ringAdornment.Parent then
                    createRing()
                end
                if ringAdornment then
                    ringAdornment.Radius = parryRange
                    local attacking = checkKillerAttackingInRange()
                    if attacking then
                        ringAdornment.Color3 = Color3.fromRGB(0, 255, 80)
                        ringAdornment.Transparency = 0.15
                    else
                        ringAdornment.Color3 = Color3.fromRGB(255, 40, 40)
                        ringAdornment.Transparency = 0.3
                    end
                end
            else
                if ringAdornment then
                    destroyRing()
                end
            end
        end
    )
end

LP.CharacterAdded:Connect(
    function()
        task.wait(0.5)
        if rangeVisualEnabled then
            destroyRing()
            createRing()
        end
    end
)

makeToggle(
    "Auto Parry",
    false,
    function(s)
        autoParryEnabled = s
    end
)

makeSlider(
    "Parry Range",
    1,
    32,
    16,
    function(v)
        parryRange = v
        if ringAdornment then
            ringAdornment.Radius = v
        end
    end
)

makeToggle(
    "Range Visual",
    false,
    function(s)
        rangeVisualEnabled = s
        if s then
            createRing()
        else
            destroyRing()
        end
    end
)

local dragging = false
local dragStart = nil
local startPos = nil
local dragTarget = nil

local function setupDrag(target)
    target.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = target.Position
                dragTarget = target
            end
        end
    )
    target.InputEnded:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                dragTarget = nil
            end
        end
    )
end

setupDrag(titleBar)
setupDrag(logo)

UserInputService.InputChanged:Connect(
    function(input)
        if dragging and dragTarget then
            if
                input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch
             then
                local delta = input.Position - dragStart
                dragTarget.Position =
                    UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    end
)

minBtn.MouseButton1Click:Connect(
    function()
        main.Visible = false
        logo.Visible = true
    end
)

logo.MouseButton1Click:Connect(
    function()
        if not dragging then
            logo.Visible = false
            main.Visible = true
        end
    end
)

startLoop()

print("[vanz] Auto Parry loaded")
