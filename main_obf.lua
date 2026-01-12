-- Script By Poz

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Rep = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- CHAT KHI EXECUTE
pcall(function()
    Rep.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Sctript By Poz","All")
end)

-- ===== CONFIG SAVE =====
getgenv().POZ_CONFIG = getgenv().POZ_CONFIG or {
    distance = 6,
    delay = 0.35,
    order = {1,2,3,4}
}

-- ===== STATE =====
local state = {
    follow = false,
    target = nil,
    distance = getgenv().POZ_CONFIG.distance,
    delay = getgenv().POZ_CONFIG.delay,
    order = getgenv().POZ_CONFIG.order,
    autoCombo = false
}

-- ===== CHARACTER =====
local function getHRP()
    local c = LP.Character or LP.CharacterAdded:Wait()
    return c:WaitForChild("HumanoidRootPart")
end
local HRP = getHRP()
LP.CharacterAdded:Connect(function()
    task.wait(1)
    HRP = getHRP()
end)

-- ===== INPUT =====
local function press(k)
    keypress(k)
    task.wait(0.05)
    keyrelease(k)
end

local function click()
    mouse1press()
    task.wait(0.05)
    mouse1release()
end

-- ===== GUI ROOT =====
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

-- MINI BUTTON
local mini = Instance.new("TextButton", gui)
mini.Size = UDim2.new(0,80,0,40)
mini.Position = UDim2.new(0,20,0.5,-20)
mini.Text = "POZ"
mini.Font = Enum.Font.GothamBold
mini.TextSize = 18
mini.BackgroundColor3 = Color3.fromRGB(60,60,60)
mini.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", mini)

-- DRAG MINI
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

-- MAIN MENU
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,430,0,460)
main.Position = UDim2.new(0.5,-215,0.5,-230)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", main)

-- DRAG MAIN
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

mini.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "POZ FOLLOW + AUTO COMBO"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)

-- ===== FOLLOW PLAYER =====
local selectBtn = Instance.new("TextButton", main)
selectBtn.Size = UDim2.new(1,-40,0,40)
selectBtn.Position = UDim2.new(0,20,0,55)
selectBtn.Text = "Select Player"
selectBtn.Font = Enum.Font.Gotham
selectBtn.TextSize = 16
selectBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
selectBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", selectBtn)

local listFrame = Instance.new("Frame", main)
listFrame.Size = UDim2.new(1,-40,0,160)
listFrame.Position = UDim2.new(0,20,0,100)
listFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
listFrame.Visible = false
Instance.new("UICorner", listFrame)

local layout = Instance.new("UIListLayout", listFrame)
layout.Padding = UDim.new(0,6)

local function refreshPlayers()
    for _,c in ipairs(listFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then
            local b = Instance.new("TextButton", listFrame)
            b.Size = UDim2.new(1,-10,0,30)
            b.Text = p.Name
            b.Font = Enum.Font.Gotham
            b.TextSize = 14
            b.BackgroundColor3 = Color3.fromRGB(60,60,60)
            b.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function()
                state.target = p
                state.follow = true
                selectBtn.Text = "Target: "..p.Name
                listFrame.Visible = false
            end)
        end
    end
end

selectBtn.MouseButton1Click:Connect(function()
    listFrame.Visible = not listFrame.Visible
    if listFrame.Visible then refreshPlayers() end
end)

-- DISTANCE SLIDER
local distLabel = Instance.new("TextLabel", main)
distLabel.Size = UDim2.new(1,-40,0,25)
distLabel.Position = UDim2.new(0,20,0,265)
distLabel.BackgroundTransparency = 1
distLabel.Text = "Distance: "..state.distance
distLabel.Font = Enum.Font.Gotham
distLabel.TextSize = 14
distLabel.TextColor3 = Color3.new(1,1,1)

local slider = Instance.new("Frame", main)
slider.Size = UDim2.new(1,-40,0,8)
slider.Position = UDim2.new(0,20,0,295)
slider.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", slider)

local fill = Instance.new("Frame", slider)
fill.Size = UDim2.new((state.distance-3)/10,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(120,120,255)
Instance.new("UICorner", fill)

slider.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then
        local move
        move = UIS.InputChanged:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseMovement then
                local x = math.clamp((inp.Position.X-slider.AbsolutePosition.X)/slider.AbsoluteSize.X,0,1)
                fill.Size = UDim2.new(x,0,1,0)
                state.distance = math.floor(3 + x*10)
                getgenv().POZ_CONFIG.distance = state.distance
                distLabel.Text = "Distance: "..state.distance
            end
        end)
        UIS.InputEnded:Once(function()
            move:Disconnect()
        end)
    end
end)

-- ===== AUTO COMBO =====
local orderBox = Instance.new("TextBox", main)
orderBox.Size = UDim2.new(1,-40,0,35)
orderBox.Position = UDim2.new(0,20,0,315)
orderBox.Text = table.concat(state.order,",")
orderBox.Font = Enum.Font.Gotham
orderBox.TextSize = 14
orderBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
orderBox.TextColor3 = Color3.new(1,1,1)
orderBox.PlaceholderText = "Skill order: 1,2,3,4"
Instance.new("UICorner", orderBox)

orderBox.FocusLost:Connect(function()
    local t = {}
    for n in orderBox.Text:gmatch("%d") do
        n = tonumber(n)
        if n and n>=1 and n<=4 then table.insert(t,n) end
    end
    if #t>0 then
        state.order = t
        getgenv().POZ_CONFIG.order = t
    end
end)

local comboBtn = Instance.new("TextButton", main)
comboBtn.Size = UDim2.new(1,-40,0,40)
comboBtn.Position = UDim2.new(0,20,0,360)
comboBtn.Text = "AUTO COMBO : OFF"
comboBtn.Font = Enum.Font.GothamBold
comboBtn.TextSize = 16
comboBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
comboBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", comboBtn)

comboBtn.MouseButton1Click:Connect(function()
    state.autoCombo = not state.autoCombo
    comboBtn.Text = "AUTO COMBO : "..(state.autoCombo and "ON" or "OFF")
end)

-- ===== FOLLOW LOOP =====
RunService.RenderStepped:Connect(function()
    if state.follow and state.target and state.target.Character then
        local th = state.target.Character:FindFirstChild("HumanoidRootPart")
        if th and HRP then
            HRP.CFrame = th.CFrame * CFrame.new(0,0,-state.distance)
        end
    end
end)

-- ===== COMBO LOOP =====
task.spawn(function()
    while task.wait() do
        if state.autoCombo then
            for i=1,3 do click() task.wait(0.1) end
            press(Enum.KeyCode.Q)
            task.wait(state.delay)
            for i=1,3 do click() task.wait(0.1) end
            for _,n in ipairs(state.order) do
                press(Enum.KeyCode[tostring(n)])
                task.wait(state.delay)
            end
        end
    end
end)
