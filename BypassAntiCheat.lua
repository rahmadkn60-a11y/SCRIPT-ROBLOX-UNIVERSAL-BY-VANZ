local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local LP = Players.LocalPlayer

local AntiBypass = {}

local function guid()
    return HttpService:GenerateGUID(false):gsub("-", "")
end

local function isPlayerPart(part)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and part:IsDescendantOf(plr.Character) then
            return true
        end
    end
    return false
end

AntiBypass.state = {
    velSmooth = {on = false, max = 40, conn = nil},
    wsNorm = {on = false, real = 16, jump = 50, conn = nil, last = 0},
    stateGuard = {on = false, conn = nil},
    netGuard = {on = false, conn = nil},
    fpsSmooth = {on = false, target = 60, conn = nil, last = 0},
    charGuard = {conn = nil, cbs = {}},
    nameObf = {on = false, conn = nil},
}

function AntiBypass.hideGui(gui)
    if not gui then return nil end
    gui.Name = guid()
    gui.DisplayOrder = math.random(1, 30)
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    pcall(function()
        gui.Parent = CoreGui
    end)
    return gui
end

function AntiBypass.obfuscate(gui)
    if not gui then return end
    pcall(function()
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("GuiObject") then
                obj.Name = guid()
                pcall(function()
                    obj:SetAttribute("id", nil)
                    obj:SetAttribute("uid", nil)
                    obj:SetAttribute("class", nil)
                end)
            end
        end
        gui.Name = guid()
    end)
end

function AntiBypass.setVelSmooth(on, maxDelta)
    local s = AntiBypass.state.velSmooth
    if maxDelta then s.max = maxDelta end
    s.on = on and true or false
    if s.conn then
        s.conn:Disconnect()
        s.conn = nil
    end
    if not s.on then return end
    s.conn = RunService.Heartbeat:Connect(function()
        if not s.on then return end
        local c = LP.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local v = hrp.AssemblyLinearVelocity
        local m = v.Magnitude
        if m > s.max then
            hrp.AssemblyLinearVelocity = v.Unit * s.max
        end
        local av = hrp.AssemblyAngularVelocity
        local am = av.Magnitude
        if am > math.rad(1080) then
            hrp.AssemblyAngularVelocity = av.Unit * math.rad(1080)
        end
    end)
end

function AntiBypass.setWSNormalizer(on, ws, jp)
    local s = AntiBypass.state.wsNorm
    if ws then s.real = ws end
    if jp then s.jump = jp end
    s.on = on and true or false
    if s.conn then
        s.conn:Disconnect()
        s.conn = nil
    end
    if not s.on then return end
    s.conn = RunService.Heartbeat:Connect(function()
        if not s.on then return end
        local c = LP.Character
        if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        if not h then return end
        local moving = h.MoveDirection.Magnitude > 0.05
        if moving then
            s.last = tick()
            if h.WalkSpeed ~= s.real then
                h.WalkSpeed = s.real
            end
            if h.JumpPower ~= s.jump then
                h.JumpPower = s.jump
            end
        elseif tick() - s.last > 0.6 then
            if h.WalkSpeed ~= 16 then
                h.WalkSpeed = 16
            end
            if h.JumpPower ~= 50 then
                h.JumpPower = 50
            end
        end
    end)
end

function AntiBypass.setStateGuard(on)
    local s = AntiBypass.state.stateGuard
    s.on = on and true or false
    if s.conn then
        s.conn:Disconnect()
        s.conn = nil
    end
    if not s.on then return end
    s.conn = RunService.Heartbeat:Connect(function()
        if not s.on then return end
        local c = LP.Character
        if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        if not h then return end
        local st = h:GetState()
        if st == Enum.HumanoidStateType.Physics then
            return
        end
        if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
            if h.MoveDirection.Magnitude < 0.05 then
                pcall(function()
                    h:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
        end
    end)
end

function AntiBypass.setNetGuard(on)
    local s = AntiBypass.state.netGuard
    s.on = on and true or false
    if s.conn then
        s.conn:Disconnect()
        s.conn = nil
    end
    if not s.on then return end
    s.conn = RunService.Heartbeat:Connect(function()
        if not s.on then return end
        local c = LP.Character
        if not c then return end
        for _, part in ipairs(c:GetDescendants()) do
            if part:IsA("BasePart") and not part.Anchored then
                pcall(function()
                    if part:GetNetworkOwner() ~= LP then
                        part:SetNetworkOwner(LP)
                    end
                end)
            end
        end
    end)
end

function AntiBypass.setFpsSmooth(on, target)
    local s = AntiBypass.state.fpsSmooth
    if target then s.target = target end
    s.on = on and true or false
    if s.conn then
        s.conn:Disconnect()
        s.conn = nil
    end
    if not s.on then return end
    s.conn = RunService.Heartbeat:Connect(function()
        if not s.on then return end
        local now = tick()
        local dt = now - s.last
        s.last = now
        local frame = 1 / s.target
        if dt < frame * 0.5 then
            task.wait(frame - dt)
        end
    end)
end

function AntiBypass.smoothTeleport(targetCF, steps, delay)
    steps = steps or 10
    delay = delay or 0.015
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local startCF = hrp.CFrame
    local startPos = startCF.Position
    local targetPos = targetCF.Position
    local targetRot = targetCF - targetPos
    for i = 1, steps do
        local a = i / steps
        local pos = startPos:Lerp(targetPos, a)
        hrp.CFrame = CFrame.new(pos) * targetRot
        task.wait(delay)
    end
end

function AntiBypass.jitter(fn, mn, mx)
    mn = mn or 0.1
    mx = mx or 0.5
    local active = true
    task.spawn(function()
        while active do
            task.wait(mn + math.random() * (mx - mn))
            if not active then break end
            pcall(fn)
        end
    end)
    return function()
        active = false
    end
end

function AntiBypass.clearFootprint()
    pcall(function()
        local g = getgenv and getgenv()
        if not g then return end
        for _, k in ipairs({
            "getreg", "getgc", "getupvalue", "getupvalues",
            "getconstants", "getproto", "getprotos",
            "hookfunction", "hookmetamethod",
            "getnamecallmethod", "getrawmetatable",
        }) do
            if g[k] then
                g[k] = nil
            end
        end
    end)
end

function AntiBypass.setNameObfuscate(on, pattern)
    local s = AntiBypass.state.nameObf
    s.on = on and true or false
    if s.conn then
        s.conn:Disconnect()
        s.conn = nil
    end
    if not s.on then return end
    pattern = pattern or ""
    s.conn = Workspace.DescendantAdded:Connect(function(obj)
        if not s.on then return end
        if obj:IsA("BasePart") and not isPlayerPart(obj) then
            if pattern ~= "" and obj.Name:find(pattern) then
                obj.Name = guid():sub(1, 10)
            end
        end
    end)
end

function AntiBypass.attachCharacterGuard(cb)
    local s = AntiBypass.state.charGuard
    if cb then
        table.insert(s.cbs, cb)
    end
    if s.conn then return end
    s.conn = LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        for _, f in ipairs(s.cbs) do
            pcall(f, char)
        end
    end)
end

function AntiBypass.init(opts)
    opts = opts or {}
    if opts.gui then
        AntiBypass.hideGui(opts.gui)
        AntiBypass.obfuscate(opts.gui)
    end
    if opts.velSmooth ~= false then
        AntiBypass.setVelSmooth(true, opts.maxVel or 40)
    end
    if opts.wsNorm ~= false then
        AntiBypass.setWSNormalizer(true, opts.ws or 16, opts.jp or 50)
    end
    if opts.stateGuard ~= false then
        AntiBypass.setStateGuard(true)
    end
    if opts.netGuard ~= false then
        AntiBypass.setNetGuard(true)
    end
    if opts.fpsSmooth then
        AntiBypass.setFPSmooth(true, opts.targetFps or 60)
    end
    if opts.nameObf then
        AntiBypass.setNameObfuscate(true, opts.namePattern or "")
    end
    if opts.clearFootprint ~= false then
        AntiBypass.clearFootprint()
    end
end

return AntiBypass
