-- Script By Poz
-- TSB Auto Follow + Auto Skill

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
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
    follow=false,
    target=nil,
    distance=5,

    autoSkill=false,
    order={Enum.KeyCode.One,Enum.KeyCode.Two,Enum.KeyCode.Three,Enum.KeyCode.Four},
    delay={0.3,0.3,0.3,0.3},
    autoClick=false,
    clickDelay=0.2,
    qDelay=0.5,
}

-- ================= UI BASE =================
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name="PozUI"

local main = Instance.new("Frame",gui)
main.Size=UDim2.fromScale(0.32,0.45)
main.Position=UDim2.fromScale(0.35,0.25)
main.BackgroundColor3=Color3.fromRGB(25,25,25)
Instance.new("UICorner",main).CornerRadius=UDim.new(0,14)

-- drag
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
local title=Instance.new("TextLabel",main)
title.Size=UDim2.fromScale(1,0.12)
title.BackgroundTransparency=1
title.Text="POZ SCRIPT"
title.Font=Enum.Font.GothamBold
title.TextSize=18
title.TextColor3=Color3.new(1,1,1)

-- tab buttons
local tab1=Instance.new("TextButton",main)
tab1.Size=UDim2.fromScale(0.5,0.1)
tab1.Position=UDim2.fromScale(0,0.12)
tab1.Text="Follow Player"

local tab2=tab1:Clone()
tab2.Parent=main
tab2.Position=UDim2.fromScale(0.5,0.12)
tab2.Text="Auto Skill"

for _,b in ipairs({tab1,tab2}) do
    b.BackgroundColor3=Color3.fromRGB(40,40,40)
    b.TextColor3=Color3.new(1,1,1)
    b.Font=Enum.Font.Gotham
end

-- pages
local page1=Instance.new("Frame",main)
page1.Size=UDim2.fromScale(1,0.78)
page1.Position=UDim2.fromScale(0,0.22)
page1.BackgroundTransparency=1

local page2=page1:Clone()
page2.Parent=main
page2.Visible=false

tab1.MouseButton1Click:Connect(function()
    page1.Visible=true page2.Visible=false
end)
tab2.MouseButton1Click:Connect(function()
    page1.Visible=false page2.Visible=true
end)

-- ================= TAB 1 : FOLLOW =================
local list=Instance.new("ScrollingFrame",page1)
list.Size=UDim2.fromScale(0.9,0.45)
list.Position=UDim2.fromScale(0.05,0.05)
list.CanvasSize=UDim2.new(0,0,0,0)
list.ScrollBarImageTransparency=0.3
Instance.new("UIListLayout",list)

local function refreshPlayers()
    list:ClearAllChildren()
    local ui=Instance.new("UIListLayout",list)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then
            local b=Instance.new("TextButton")
            b.Size=UDim2.fromScale(1,0)
            b.AutomaticSize=Enum.AutomaticSize.Y
            b.Text=p.Name
            b.BackgroundColor3=Color3.fromRGB(45,45,45)
            b.TextColor3=Color3.new(1,1,1)
            b.Parent=list
            Instance.new("UICorner",b)
            b.MouseButton1Click:Connect(function()
                state.target=p
            end)
        end
    end
    task.wait()
    list.CanvasSize=UDim2.new(0,0,0,ui.AbsoluteContentSize.Y)
end
refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

-- distance slider
local dist=Instance.new("TextLabel",page1)
dist.Position=UDim2.fromScale(0.05,0.55)
dist.Size=UDim2.fromScale(0.9,0.1)
dist.Text="Distance: 5"
dist.TextColor3=Color3.new(1,1,1)
dist.BackgroundTransparency=1

local slider=Instance.new("Frame",page1)
slider.Position=UDim2.fromScale(0.05,0.65)
slider.Size=UDim2.fromScale(0.9,0.05)
slider.BackgroundColor3=Color3.fromRGB(50,50,50)
Instance.new("UICorner",slider)

local fill=Instance.new("Frame",slider)
fill.Size=UDim2.fromScale(0.25,1)
fill.BackgroundColor3=Color3.fromRGB(100,100,255)
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
        dist.Text="Distance: "..state.distance
    end
end)

-- follow toggle
local fbtn=Instance.new("TextButton",page1)
fbtn.Size=UDim2.fromScale(0.9,0.1)
fbtn.Position=UDim2.fromScale(0.05,0.78)
fbtn.Text="Follow : OFF"
fbtn.BackgroundColor3=Color3.fromRGB(45,45,45)
fbtn.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",fbtn)
fbtn.MouseButton1Click:Connect(function()
    state.follow=not state.follow
    fbtn.Text="Follow : "..(state.follow and "ON" or "OFF")
end)

-- follow loop
RS.Heartbeat:Connect(function()
    if state.follow and state.target and state.target.Character then
        local t=state.target.Character:FindFirstChild("HumanoidRootPart")
        if t and HRP then
            HRP.CFrame=t.CFrame*CFrame.new(0,0,-state.distance)
        end
    end
end)

-- ================= TAB 2 : AUTO SKILL =================
local y=0.05
for i=1,4 do
    local t=Instance.new("TextLabel",page2)
    t.Position=UDim2.fromScale(0.05,y)
    t.Size=UDim2.fromScale(0.9,0.08)
    t.Text="Skill "..i.." delay: "..state.delay[i]
    t.TextColor3=Color3.new(1,1,1)
    t.BackgroundTransparency=1

    local s=slider:Clone()
    s.Parent=page2
    s.Position=UDim2.fromScale(0.05,y+0.08)
    local f=s:FindFirstChildOfClass("Frame")

    local sl=false
    s.InputBegan:Connect(function(i2)
        if i2.UserInputType==Enum.UserInputType.MouseButton1 then sl=true end
    end)
    UIS.InputEnded:Connect(function(i2)
        if i2.UserInputType==Enum.UserInputType.MouseButton1 then sl=false end
    end)
    UIS.InputChanged:Connect(function(i2)
        if sl then
            local x=(i2.Position.X-s.AbsolutePosition.X)/s.AbsoluteSize.X
            x=math.clamp(x,0,1)
            f.Size=UDim2.fromScale(x,1)
            state.delay[i]=math.floor(x*100)/100
            t.Text="Skill "..i.." delay: "..state.delay[i]
        end
    end)
    y=y+0.18
end

local abtn=fbtn:Clone()
abtn.Parent=page2
abtn.Position=UDim2.fromScale(0.05,0.78)
abtn.Text="Auto Skill : OFF"
abtn.MouseButton1Click:Connect(function()
    state.autoSkill=not state.autoSkill
    abtn.Text="Auto Skill : "..(state.autoSkill and "ON" or "OFF")
end)

task.spawn(function()
    while task.wait() do
        if state.autoSkill then
            for i,k in ipairs(state.order) do
                keypress(k) task.wait(0.05) keyrelease(k)
                task.wait(state.delay[i])
            end
            if state.autoClick then
                for i=1,3 do
                    mouse1press() task.wait() mouse1release()
                    task.wait(state.clickDelay)
                end
                keypress(Enum.KeyCode.Q) task.wait(0.05) keyrelease(Enum.KeyCode.Q)
                task.wait(state.qDelay)
            end
        end
    end
end)

-- ================= MINI MENU BUTTON =================
local mini=Instance.new("TextButton",gui)
mini.Size=UDim2.fromScale(0.05,0.05)
mini.Position=UDim2.fromScale(0.01,0.4)
mini.Text="POZ"
mini.BackgroundColor3=Color3.fromRGB(40,40,40)
mini.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",mini)

mini.MouseButton1Click:Connect(function()
    main.Visible=not main.Visible
end)
