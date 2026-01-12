--// Sctript By Poz

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Rep = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- chat khi execute
pcall(function()
    Rep.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
        "Sctript By Poz","All"
    )
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
    distance = 5,

    autoSkill = false,
    autoClick = true,

    -- thứ tự skill (PHÍM SỐ)
    skillOrder = {1,2,3,4},

    skillDelay = {0.3,0.3,0.3,0.3},
    clickDelay = 0.12,
    qDelay = 0.4
}

-- ================= KEY PRESS =================
local numKeys = {
    [1]=Enum.KeyCode.One,
    [2]=Enum.KeyCode.Two,
    [3]=Enum.KeyCode.Three,
    [4]=Enum.KeyCode.Four
}

local function pressKey(k)
    keypress(k)
    task.wait(0.05)
    keyrelease(k)
end

-- ================= UI BASE =================
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name = "PozUI"

local main = Instance.new("Frame",gui)
main.Size = UDim2.fromScale(0.34,0.48)
main.Position = UDim2.fromScale(0.33,0.25)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner",main).CornerRadius = UDim.new(0,14)

-- drag main
do
    local drag,ds,dp
    main.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=true ds=i.Position dp=main.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds
            main.Position=UDim2.new(dp.X.Scale,dp.X.Offset+d.X,dp.Y.Scale,dp.Y.Offset+d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
end

-- title
local title = Instance.new("TextLabel",main)
title.Size = UDim2.fromScale(1,0.12)
title.BackgroundTransparency = 1
title.Text = "POZ SCRIPT"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)

-- tab buttons
local tabFollow = Instance.new("TextButton",main)
tabFollow.Size = UDim2.fromScale(0.5,0.1)
tabFollow.Position = UDim2.fromScale(0,0.12)
tabFollow.Text = "Follow Player"

local tabSkill = tabFollow:Clone()
tabSkill.Parent = main
tabSkill.Position = UDim2.fromScale(0.5,0.12)
tabSkill.Text = "Auto Skill"

for _,b in ipairs({tabFollow,tabSkill}) do
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
end

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
list.Size = UDim2.fromScale(0.9,0.45)
list.Position = UDim2.fromScale(0.05,0.05)
list.ScrollBarImageTransparency = 0.3
list.CanvasSize = UDim2.new(0,0,0,0)
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

-- distance slider
local distLabel = Instance.new("TextLabel",pageFollow)
distLabel.Position = UDim2.fromScale(0.05,0.55)
distLabel.Size = UDim2.fromScale(0.9,0.08)
distLabel.Text = "Distance: 5"
distLabel.BackgroundTransparency = 1
distLabel.TextColor3 = Color3.new(1,1,1)

local slider = Instance.new("Frame",pageFollow)
slider.Position = UDim2.fromScale(0.05,0.63)
slider.Size = UDim2.fromScale(0.9,0.05)
slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner",slider)

local fill = Instance.new("Frame",slider)
fill.Size = UDim2.fromScale(0.25,1)
fill.BackgroundColor3 = Color3.fromRGB(100,100,255)
Instance.new("UICorner",fill)

local sliding=false
slider.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=true end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end
end)
UIS.InputChanged:Connect(function(i)
    if sliding then
        local x=(i.Position.X-slider.AbsolutePosition.X)/slider.AbsoluteSize.X
        x=math.clamp(x,0,1)
        fill.Size=UDim2.fromScale(x,1)
        state.distance=math.floor(x*20)
        distLabel.Text="Distance: "..state.distance
    end
end)

local followBtn = Instance.new("TextButton",pageFollow)
followBtn.Size = UDim2.fromScale(0.9,0.1)
followBtn.Position = UDim2.fromScale(0.05,0.78)
followBtn.Text = "Follow : OFF"
followBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
followBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",followBtn)

followBtn.MouseButton1Click:Connect(function()
    state.follow = not state.follow
    followBtn.Text = "Follow : "..(state.follow and "ON" or "OFF")
end)

RunService.Heartbeat:Connect(function()
    if state.follow and state.target and state.target.Character then
        local tHRP = state.target.Character:FindFirstChild("HumanoidRootPart")
        if tHRP and HRP then
            HRP.CFrame = tHRP.CFrame * CFrame.new(0,0,-state.distance)
        end
    end
end)

-- ================= AUTO SKILL LOOP =================
task.spawn(function()
    while task.wait() do
        if state.autoSkill then
            for i,n in ipairs(state.skillOrder) do
                local key = numKeys[n]
                if key then
                    pressKey(key)
                    task.wait(state.skillDelay[i] or 0.3)
                end
            end

            -- auto click 3 lần
            for i=1,3 do
                mouse1press() task.wait() mouse1release()
                task.wait(state.clickDelay)
            end

            -- nhấn Q
            pressKey(Enum.KeyCode.Q)
            task.wait(state.qDelay)
        end
    end
end)

-- ================= AUTO SKILL UI =================
local autoBtn = followBtn:Clone()
autoBtn.Parent = pageSkill
autoBtn.Position = UDim2.fromScale(0.05,0.82)
autoBtn.Text = "Auto Skill : OFF"

autoBtn.MouseButton1Click:Connect(function()
    state.autoSkill = not state.autoSkill
    autoBtn.Text = "Auto Skill : "..(state.autoSkill and "ON" or "OFF")
end)

-- ================= MINI MENU =================
local mini = Instance.new("TextButton",gui)
mini.Size = UDim2.fromScale(0.05,0.05)
mini.Position = UDim2.fromScale(0.01,0.4)
mini.Text = "POZ"
mini.BackgroundColor3 = Color3.fromRGB(40,40,40)
mini.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",mini)

mini.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
