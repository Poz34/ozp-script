--// O Z P  |  TSB AUTO SCRIPT
--// simple & stable

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

pcall(function()
    LP:WaitForChild("PlayerGui"):SetTopbarTransparency(0)
end)

-- chat khi execute
pcall(function()
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
        "auto buff kill by ozp","All"
    )
end)

-- ========== STATE ==========
local state = {
    follow = false,
    autoSkill = false,
    autoClick = false,
    distance = 5,
    delay = 0.6,
    target = nil,
    order = {Enum.KeyCode.One,Enum.KeyCode.Two,Enum.KeyCode.Three,Enum.KeyCode.Four}
}

-- ========== CHAR ==========
local function getChar()
    local c = LP.Character or LP.CharacterAdded:Wait()
    return c:WaitForChild("HumanoidRootPart")
end
local HRP = getChar()
LP.CharacterAdded:Connect(function()
    task.wait(1)
    HRP = getChar()
end)

-- ========== UI ==========
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name = "OZP_UI"

local main = Instance.new("Frame",gui)
main.Size = UDim2.fromScale(0.25,0.38)
main.Position = UDim2.fromScale(0.05,0.3)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Visible = true
Instance.new("UICorner",main).CornerRadius = UDim.new(0,12)

local function btn(text,y)
    local b = Instance.new("TextButton",main)
    b.Size = UDim2.fromScale(0.85,0.1)
    b.Position = UDim2.fromScale(0.075,y)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Instance.new("UICorner",b)
    return b
end

local title = Instance.new("TextLabel",main)
title.Size = UDim2.fromScale(1,0.15)
title.Text = "AUTO FOLLOW PLAYER"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local select = btn("Select Player",0.18)
local refresh = btn("Refresh Player",0.30)
local toggleFollow = btn("Follow : OFF",0.42)
local toggleSkill = btn("Auto Skill : OFF",0.54)
local toggleClick = btn("Auto Click : OFF",0.66)

-- hide / show
UIS.InputBegan:Connect(function(i,g)
    if not g and i.KeyCode == Enum.KeyCode.RightControl then
        main.Visible = not main.Visible
    end
end)

-- ========== PLAYER LIST ==========
local function getPlayers()
    local t={}
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then table.insert(t,p.Name) end
    end
    return t
end

select.MouseButton1Click:Connect(function()
    local list = getPlayers()
    if #list==0 then return end
    state.target = Players[list[1]]
    select.Text = "Target : "..list[1]
end)

refresh.MouseButton1Click:Connect(function()
    state.target=nil
    select.Text="Select Player"
end)

-- ========== TOGGLES ==========
toggleFollow.MouseButton1Click:Connect(function()
    state.follow = not state.follow
    toggleFollow.Text = "Follow : "..(state.follow and "ON" or "OFF")
end)

toggleSkill.MouseButton1Click:Connect(function()
    state.autoSkill = not state.autoSkill
    toggleSkill.Text = "Auto Skill : "..(state.autoSkill and "ON" or "OFF")
end)

toggleClick.MouseButton1Click:Connect(function()
    state.autoClick = not state.autoClick
    toggleClick.Text = "Auto Click : "..(state.autoClick and "ON" or "OFF")
end)

-- ========== FOLLOW ==========
RunService.Heartbeat:Connect(function()
    if state.follow and state.target and state.target.Character then
        local tHRP = state.target.Character:FindFirstChild("HumanoidRootPart")
        if tHRP and HRP then
            HRP.CFrame = tHRP.CFrame * CFrame.new(0,0,-state.distance)
        end
    end
end)

-- ========== AUTO SKILL ==========
task.spawn(function()
    while task.wait(state.delay) do
        if state.autoSkill then
            for _,k in ipairs(state.order) do
                pcall(function()
                    keypress(k) task.wait(0.05) keyrelease(k)
                end)
            end
        end
    end
end)

-- ========== AUTO CLICK ==========
task.spawn(function()
    while task.wait(0.1) do
        if state.autoClick then
            pcall(function()
                mouse1press() task.wait() mouse1release()
            end)
        end
    end
end)
