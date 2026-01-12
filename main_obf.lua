--// Sctript By Poz

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Rep = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- chat khi execute
pcall(function()
    Rep.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Sctript By Poz","All")
end)

-- character
local function getHRP()
    local c = LP.Character or LP.CharacterAdded:Wait()
    return c:WaitForChild("HumanoidRootPart")
end
local HRP = getHRP()
LP.CharacterAdded:Connect(function()
    task.wait(1)
    HRP = getHRP()
end)

-- ================= STATE =================
local state = {
    follow = false,
    target = nil,
    distance = 6,

    autoSkill = false,

    skillOrder = {1,2,3,4},
    skillDelay = 0.35,

    clickDelay = 0.12,
    qDelay = 0.4
}

-- ================= KEY =================
local numKey = {
    [1]=Enum.KeyCode.One,
    [2]=Enum.KeyCode.Two,
    [3]=Enum.KeyCode.Three,
    [4]=Enum.KeyCode.Four
}

local function press(k)
    keypress(k)
    task.wait(0.05)
    keyrelease(k)
end

-- ================= GUI =================
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name = "PozUI"

local main = Instance.new("Frame",gui)
main.Size = UDim2.fromScale(0.36,0.52)
main.Position = UDim2.fromScale(0.32,0.24)
main.BackgroundColor3 = Color3.fromRGB(22,22,22)
Instance.new("UICorner",main).CornerRadius = UDim.new(0,16)

-- drag
do
    local d,ds,dp
    main.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            d=true ds=i.Position dp=main.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if d and i.UserInputType==Enum.UserInputType.MouseMovement then
            local delta=i.Position-ds
            main.Position=UDim2.new(dp.X.Scale,dp.X.Offset+delta.X,dp.Y.Scale,dp.Y.Offset+delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then d=false end
    end)
end

-- title
local title = Instance.new("TextLabel",main)
title.Size = UDim2.fromScale(1,0.12)
title.BackgroundTransparency = 1
title.Text = "POZ SCRIPT"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255,255,255)

-- tabs
local function tabBtn(txt,x)
    local b = Instance.new("TextButton",main)
    b.Size = UDim2.fromScale(0.5,0.09)
    b.Position = UDim2.fromScale(x,0.12)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner",b)
    return b
end

local tabFollow = tabBtn("FOLLOW",0)
local tabSkill  = tabBtn("AUTO SKILL",0.5)

-- pages
local pageFollow = Instance.new("Frame",main)
pageFollow.Size = UDim2.fromScale(1,0.78)
pageFollow.Position = UDim2.fromScale(0,0.22)
pageFollow.BackgroundTransparency = 1

local pageSkill = pageFollow:Clone()
pageSkill.Parent = main
pageSkill.Visible = false

tabFollow.MouseButton1Click:Connect(function()
    pageFollow.Visible=true
    pageSkill.Visible=false
end)
tabSkill.MouseButton1Click:Connect(function()
    pageFollow.Visible=false
    pageSkill.Visible=true
end)

-- ================= FOLLOW TAB =================
local list = Instance.new("ScrollingFrame",pageFollow)
list.Size = UDim2.fromScale(0.9,0.42)
list.Position = UDim2.fromScale(0.05,0.05)
list.CanvasSize = UDim2.new()
list.ScrollBarImageTransparency = 0.3
Instance.new("UIListLayout",list)

local function refreshPlayers()
    list:ClearAllChildren()
    local ui = Instance.new("UIListLayout",list)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then
            local b = Instance.new("TextButton",list)
            b.Size = UDim2.fromScale(1,0)
            b.AutomaticSize = Enum.AutomaticSize.Y
            b.Text = p.Name
            b.Font = Enum.Font.Gotham
            b.TextSize = 16
            b.BackgroundColor3 = Color3.fromRGB(45,45,45)
            b.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner",b)
            b.MouseButton1Click:Connect(function()
                state.target = p
            end)
        end
    end
    task.wait()
    list.CanvasSize = UDim2.new(0,0,0,ui.AbsoluteContentSize.Y)
end
refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

-- distance
local dist = Instance.new("TextLabel",pageFollow)
dist.Position = UDim2.fromScale(0.05,0.5)
dist.Size = UDim2.fromScale(0.9,0.08)
dist.Text = "Distance : 6"
dist.Font = Enum.Font.GothamBold
dist.TextSize = 16
dist.BackgroundTransparency = 1
dist.TextColor3 = Color3.new(1,1,1)

-- follow toggle
local fbtn = Instance.new("TextButton",pageFollow)
fbtn.Size = UDim2.fromScale(0.9,0.1)
fbtn.Position = UDim2.fromScale(0.05,0.78)
fbtn.Text = "FOLLOW : OFF"
fbtn.Font = Enum.Font.GothamBold
fbtn.TextSize = 16
fbtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
fbtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",fbtn)

fbtn.MouseButton1Click:Connect(function()
    state.follow = not state.follow
    fbtn.Text = "FOLLOW : "..(state.follow and "ON" or "OFF")
end)

RunService.Heartbeat:Connect(function()
    if state.follow and state.target and state.target.Character then
        local t = state.target.Character:FindFirstChild("HumanoidRootPart")
        if t and HRP then
            HRP.CFrame = t.CFrame * CFrame.new(0,0,-state.distance)
        end
    end
end)

-- ================= AUTO SKILL TAB =================
local info = Instance.new("TextLabel",pageSkill)
info.Size = UDim2.fromScale(0.9,0.35)
info.Position = UDim2.fromScale(0.05,0.1)
info.BackgroundTransparency = 1
info.TextWrapped = true
info.TextYAlignment = Enum.TextYAlignment.Top
info.Font = Enum.Font.GothamBold
info.TextSize = 16
info.TextColor3 = Color3.new(1,1,1)
info.Text =
"Skill Order:\n1 → 2 → 3 → 4\n\nAfter skills:\n• Auto Click x3\n• Press Q"

local abtn = Instance.new("TextButton",pageSkill)
abtn.Size = UDim2.fromScale(0.9,0.12)
abtn.Position = UDim2.fromScale(0.05,0.75)
abtn.Text = "AUTO SKILL : OFF"
abtn.Font = Enum.Font.GothamBold
abtn.TextSize = 16
abtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
abtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",abtn)

abtn.MouseButton1Click:Connect(function()
    state.autoSkill = not state.autoSkill
    abtn.Text = "AUTO SKILL : "..(state.autoSkill and "ON" or "OFF")
end)

-- loop
task.spawn(function()
    while task.wait() do
        if state.autoSkill then
            for _,n in ipairs(state.skillOrder) do
                press(numKey[n])
                task.wait(state.skillDelay)
            end
            for i=1,3 do
                mouse1press() task.wait() mouse1release()
                task.wait(state.clickDelay)
            end
            press(Enum.KeyCode.Q)
            task.wait(state.qDelay)
        end
    end
end)

-- mini button
local mini = Instance.new("TextButton",gui)
mini.Size = UDim2.fromScale(0.06,0.06)
mini.Position = UDim2.fromScale(0.02,0.45)
mini.Text = "POZ"
mini.Font = Enum.Font.GothamBold
mini.TextSize = 16
mini.BackgroundColor3 = Color3.fromRGB(50,50,50)
mini.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",mini)

mini.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
