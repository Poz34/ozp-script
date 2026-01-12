-- Script By Poz (FIX GUI)

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
    autoSkill = false
}

-- ================= KEY =================
local keys = {
    Enum.KeyCode.One,
    Enum.KeyCode.Two,
    Enum.KeyCode.Three,
    Enum.KeyCode.Four
}

local function press(k)
    keypress(k)
    task.wait(0.05)
    keyrelease(k)
end

-- ================= GUI ROOT =================
local gui = Instance.new("ScreenGui")
gui.Name = "PozUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- ================= MAIN MENU =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,420,0,360)
main.Position = UDim2.new(0.5,-210,0.5,-180)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Visible = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

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
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "POZ SCRIPT"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.new(1,1,1)

-- ================= TAB BUTTONS =================
local tabFollow = Instance.new("TextButton", main)
tabFollow.Size = UDim2.new(0.5,0,0,40)
tabFollow.Position = UDim2.new(0,0,0,50)
tabFollow.Text = "FOLLOW"
tabFollow.Font = Enum.Font.GothamBold
tabFollow.TextSize = 18
tabFollow.BackgroundColor3 = Color3.fromRGB(45,45,45)
tabFollow.TextColor3 = Color3.new(1,1,1)

local tabSkill = tabFollow:Clone()
tabSkill.Parent = main
tabSkill.Position = UDim2.new(0.5,0,0,50)
tabSkill.Text = "AUTO SKILL"

-- ================= PAGES =================
local pageFollow = Instance.new("Frame", main)
pageFollow.Size = UDim2.new(1,0,1,-90)
pageFollow.Position = UDim2.new(0,0,0,90)
pageFollow.BackgroundTransparency = 1

local pageSkill = pageFollow:Clone()
pageSkill.Parent = main
pageSkill.Visible = false

tabFollow.MouseButton1Click:Connect(function()
    pageFollow.Visible = true
    pageSkill.Visible = false
end)

tabSkill.MouseButton1Click:Connect(function()
    pageFollow.Visible = false
    pageSkill.Visible = true
end)

-- ================= FOLLOW PAGE =================
local infoF = Instance.new("TextLabel", pageFollow)
infoF.Size = UDim2.new(1,-20,0,40)
infoF.Position = UDim2.new(0,10,0,10)
infoF.BackgroundTransparency = 1
infoF.Text = "Follow selected player"
infoF.Font = Enum.Font.GothamBold
infoF.TextSize = 18
infoF.TextColor3 = Color3.new(1,1,1)

-- ================= AUTO SKILL PAGE (FIX CHẮC CHẮN HIỆN) =================
local infoS = Instance.new("TextLabel", pageSkill)
infoS.Size = UDim2.new(1,-20,0,160)
infoS.Position = UDim2.new(0,10,0,10)
infoS.BackgroundTransparency = 1
infoS.TextWrapped = true
infoS.TextYAlignment = Enum.TextYAlignment.Top
infoS.Text =
"AUTO SKILL ACTIVE:\n\n"..
"- Use skill 1 → 2 → 3 → 4\n"..
"- Auto click 3 times\n"..
"- Press key Q\n\n"..
"All automatic when enabled"
infoS.Font = Enum.Font.GothamBold
infoS.TextSize = 18
infoS.TextColor3 = Color3.new(1,1,1)

local autoBtn = Instance.new("TextButton", pageSkill)
autoBtn.Size = UDim2.new(1,-40,0,50)
autoBtn.Position = UDim2.new(0,20,0,190)
autoBtn.Text = "AUTO SKILL : OFF"
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextSize = 18
autoBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
autoBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", autoBtn)

autoBtn.MouseButton1Click:Connect(function()
    state.autoSkill = not state.autoSkill
    autoBtn.Text = "AUTO SKILL : "..(state.autoSkill and "ON" or "OFF")
end)

-- ================= AUTO SKILL LOOP =================
task.spawn(function()
    while task.wait() do
        if state.autoSkill then
            for _,k in ipairs(keys) do
                press(k)
                task.wait(0.35)
            end
            for i=1,3 do
                mouse1press() task.wait() mouse1release()
                task.wait(0.12)
            end
            press(Enum.KeyCode.Q)
            task.wait(0.4)
        end
    end
end)

-- ================= MINI BUTTON (KÉO ĐƯỢC) =================
local mini = Instance.new("TextButton", gui)
mini.Size = UDim2.new(0,70,0,40)
mini.Position = UDim2.new(0,20,0.5,-20)
mini.Text = "POZ"
mini.Font = Enum.Font.GothamBold
mini.TextSize = 18
mini.BackgroundColor3 = Color3.fromRGB(50,50,50)
mini.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", mini)

-- drag mini
do
    local d,ds,dp
    mini.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            d=true ds=i.Position dp=mini.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if d and i.UserInputType==Enum.UserInputType.MouseMovement then
            local delta=i.Position-ds
            mini.Position=UDim2.new(dp.X.Scale,dp.X.Offset+delta.X,dp.Y.Scale,dp.Y.Offset+delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then d=false end
    end)
end

mini.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
