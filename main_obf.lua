-- FOLLOW PLAYER + AUTO SKILL + AUTO CLICK
-- Based on user's fixed slider version
-- Script By Poz

------------------------------------------------
-- SERVICES
------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer

------------------------------------------------
-- STATE
------------------------------------------------
-- follow
local followEnabled = false
local targetPlayer = nil
local followDistance = 5

-- auto skill / click
local autoSkill = false
local autoClick = false

local skillDelay = 1
local clickDelay = 0.15

local skillOrder = {1,2,3,4}
local skillEnabled = {true,true,true,true}

local skillIndex = 1
local lastSkill = 0
local lastClick = 0

------------------------------------------------
-- INPUT HELPERS
------------------------------------------------
local function pressKey(key)
    VIM:SendKeyEvent(true, key, false, game)
    VIM:SendKeyEvent(false, key, false, game)
end

local function mouseClick()
    VIM:SendMouseButtonEvent(0,0,0,true,game,0)
    VIM:SendMouseButtonEvent(0,0,0,false,game,0)
end

------------------------------------------------
-- GUI ROOT
------------------------------------------------
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "Poz_Follow_AutoSkill"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.34,0.55)
main.Position = UDim2.fromScale(0.03,0.4)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

------------------------------------------------
-- OPEN/CLOSE MENU BUTTON
------------------------------------------------
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromScale(0.08,0.05)
openBtn.Position = UDim2.fromScale(0.01,0.35)
openBtn.Text = "MENU"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 14
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", openBtn)

local menuVisible = true
openBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    main.Visible = menuVisible
end)

------------------------------------------------
-- TITLE
------------------------------------------------
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,38)
title.Text = "Auto buff kill"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

------------------------------------------------
-- FOLLOW PLAYER UI
------------------------------------------------
local followBtn = Instance.new("TextButton", main)
followBtn.Position = UDim2.fromScale(0.08,0.12)
followBtn.Size = UDim2.fromScale(0.84,0.07)
followBtn.Text = "FOLLOW : OFF"
followBtn.Font = Enum.Font.GothamBold
followBtn.TextSize = 14
followBtn.TextColor3 = Color3.new(1,0.3,0.3)
followBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", followBtn)

followBtn.MouseButton1Click:Connect(function()
    followEnabled = not followEnabled
    followBtn.Text = followEnabled and "FOLLOW : ON" or "FOLLOW : OFF"
    followBtn.TextColor3 = followEnabled and Color3.new(0.3,1,0.3) or Color3.new(1,0.3,0.3)
end)

-- select player
local selectBtn = Instance.new("TextButton", main)
selectBtn.Position = UDim2.fromScale(0.08,0.21)
selectBtn.Size = UDim2.fromScale(0.84,0.07)
selectBtn.Text = "Select Player"
selectBtn.Font = Enum.Font.Gotham
selectBtn.TextSize = 14
selectBtn.TextColor3 = Color3.new(1,1,1)
selectBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
Instance.new("UICorner", selectBtn)

-- popup list
local listFrame = Instance.new("Frame", gui)
listFrame.Size = UDim2.fromScale(0.25,0.4)
listFrame.Position = UDim2.fromScale(0.4,0.3)
listFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
listFrame.Visible = false
listFrame.Active = true
Instance.new("UICorner", listFrame)

local listLayout = Instance.new("UIListLayout", listFrame)
listLayout.Padding = UDim.new(0,6)

local function rebuildPlayerList()
    for _,c in ipairs(listFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local b = Instance.new("TextButton", listFrame)
            b.Size = UDim2.new(1,-12,0,32)
            b.Text = plr.Name
            b.Font = Enum.Font.Gotham
            b.TextSize = 14
            b.TextColor3 = Color3.new(1,1,1)
            b.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Instance.new("UICorner", b)

            b.MouseButton1Click:Connect(function()
                targetPlayer = plr
                selectBtn.Text = "Target: "..plr.Name
                listFrame.Visible = false
            end)
        end
    end
end

selectBtn.MouseButton1Click:Connect(function()
    rebuildPlayerList()
    listFrame.Visible = not listFrame.Visible
end)

------------------------------------------------
-- DISTANCE SLIDER
------------------------------------------------
local distLabel = Instance.new("TextLabel", main)
distLabel.Position = UDim2.fromScale(0.08,0.30)
distLabel.Size = UDim2.fromScale(0.84,0.05)
distLabel.Text = "Distance: 5"
distLabel.Font = Enum.Font.Gotham
distLabel.TextSize = 13
distLabel.TextColor3 = Color3.new(1,1,1)
distLabel.BackgroundTransparency = 1

local function createSlider(y)
    local bg = Instance.new("Frame", main)
    bg.Position = UDim2.fromScale(0.08,y)
    bg.Size = UDim2.fromScale(0.84,0.03)
    bg.BackgroundColor3 = Color3.fromRGB(70,70,70)
    Instance.new("UICorner", bg)

    local bar = Instance.new("Frame", bg)
    bar.Size = UDim2.fromScale(0.3,1)
    bar.BackgroundColor3 = Color3.fromRGB(120,120,255)
    Instance.new("UICorner", bar)
    return bg,bar
end

local distBG, distBar = createSlider(0.35)

local dragging = false
distBG.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
end)
distBG.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
        local scale = math.clamp((i.Position.X-distBG.AbsolutePosition.X)/distBG.AbsoluteSize.X,0,1)
        distBar.Size = UDim2.fromScale(scale,1)
        followDistance = math.floor((2+scale*8)*10)/10
        distLabel.Text = "Distance: "..followDistance
    end
end)

------------------------------------------------
-- AUTO SKILL / AUTO CLICK UI
------------------------------------------------
local function toggle(text,y)
    local b = Instance.new("TextButton", main)
    b.Position = UDim2.fromScale(0.08,y)
    b.Size = UDim2.fromScale(0.84,0.07)
    b.Text = text..": OFF"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,0.3,0.3)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", b)
    return b
end

local skillToggle = toggle("AUTO SKILL",0.43)
local clickToggle = toggle("AUTO CLICK",0.52)

skillToggle.MouseButton1Click:Connect(function()
    autoSkill = not autoSkill
    skillToggle.Text = autoSkill and "AUTO SKILL: ON" or "AUTO SKILL: OFF"
    skillToggle.TextColor3 = autoSkill and Color3.new(0.3,1,0.3) or Color3.new(1,0.3,0.3)
end)

clickToggle.MouseButton1Click:Connect(function()
    autoClick = not autoClick
    clickToggle.Text = autoClick and "AUTO CLICK: ON" or "AUTO CLICK: OFF"
    clickToggle.TextColor3 = autoClick and Color3.new(0.3,1,0.3) or Color3.new(1,0.3,0.3)
end)

------------------------------------------------
-- SKILL LOOP + CLICK LOOP
------------------------------------------------
RunService.RenderStepped:Connect(function()
    local now = tick()

    if autoClick and now-lastClick>=clickDelay then
        mouseClick()
        lastClick = now
    end

    if autoSkill and now-lastSkill>=skillDelay then
        local tries = 0
        while tries < #skillOrder do
            local n = skillOrder[skillIndex]
            skillIndex = skillIndex % #skillOrder + 1
            if skillEnabled[n] then
                pressKey(({Enum.KeyCode.One,Enum.KeyCode.Two,Enum.KeyCode.Three,Enum.KeyCode.Four})[n])
                lastSkill = now
                break
            end
            tries += 1
        end
    end
end)

------------------------------------------------
-- FOLLOW LOOP
------------------------------------------------
RunService.RenderStepped:Connect(function()
    if followEnabled and targetPlayer
    and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then

        local hrp = LP.Character.HumanoidRootPart
        local th = targetPlayer.Character.HumanoidRootPart

        hrp.CFrame = th.CFrame * CFrame.new(0,0,-followDistance)
    end
end)
