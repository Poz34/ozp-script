local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local KORBLOX_MESH = "101851696"
local KORBLOX_TEX  = "101851254"
local HEAD_MESH    = "134082579"
local HEAD_TEX     = "134082627"

local Window = Rayfield:CreateWindow({
   Name = "opz Hub",
   LoadingTitle = "opz Hub",
   LoadingSubtitle = "Cảm ơn vì đã sài ",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Main", 4483362458)
local MoveTab = Window:CreateTab("movetest", 4483362458)
local CreditTab = Window:CreateTab("Credit", 4483362458)

local headlessEnabled = false
local korbloxEnabled = false

local function FakeKorblox()
    local Char = LP.Character
    if not Char then return end
    local Leg = Char:FindFirstChild("Right Leg") or Char:FindFirstChild("RightLowerLeg")
    if not Leg then return end
    if Char:FindFirstChild("FakeKorbloxLeg") then
        Char.FakeKorbloxLeg:Destroy()
    end
    local Fake = Instance.new("Part")
    Fake.Name = "FakeKorbloxLeg"
    Fake.Size = Leg.Size
    Fake.CFrame = Leg.CFrame
    Fake.CanCollide = false
    Fake.Anchored = false
    Fake.Material = Enum.Material.Plastic
    Fake.BrickColor = BrickColor.new("Really black")
    local Mesh = Instance.new("SpecialMesh")
    Mesh.MeshType = Enum.MeshType.FileMesh
    Mesh.MeshId = "rbxassetid://" .. KORBLOX_MESH
    Mesh.TextureId = "rbxassetid://" .. KORBLOX_TEX
    Mesh.Parent = Fake
    Fake.Parent = Char
    local Weld = Instance.new("WeldConstraint")
    Weld.Part0 = Leg
    Weld.Part1 = Fake
    Weld.Parent = Leg
    Leg.Transparency = 1
end

local function FakeHeadless()
    local Char = LP.Character
    if not Char then return end
    local Head = Char:FindFirstChild("Head")
    if not Head then return end
    for _,v in pairs(Head:GetChildren()) do
        if v:IsA("Decal") or v:IsA("SpecialMesh") then
            v:Destroy()
        end
    end
    local Mesh = Instance.new("SpecialMesh")
    Mesh.MeshType = Enum.MeshType.FileMesh
    Mesh.MeshId = "rbxassetid://" .. HEAD_MESH
    Mesh.TextureId = "rbxassetid://" .. HEAD_TEX
    Mesh.Scale = Vector3.new(1.25,1.25,1.25)
    Mesh.Parent = Head
    Head.Transparency = 0.1
    Head.BrickColor = BrickColor.new("Really black")
end

local function ApplyAll()
    if headlessEnabled then FakeHeadless() end
    if korbloxEnabled then FakeKorblox() end
end

MainTab:CreateToggle({
   Name = "Fake Headless",
   CurrentValue = false,
   Callback = function(Value)
       headlessEnabled = Value
       ApplyAll()
   end
})

MainTab:CreateToggle({
   Name = "Fake Korblox",
   CurrentValue = false,
   Callback = function(Value)
       korbloxEnabled = Value
       ApplyAll()
   end
})

MoveTab:CreateButton({
   Name = "Jun ( saitama )",
   Callback = function()
       loadstring(game:HttpGet("https://gist.githubusercontent.com/GoldenHeads2/f66279000c58a020e894a6db44914838/raw/62e53e1acacec0b38b43cd0f594292c32e09c39b/gistfile1.txt"))()
   end
})

CreditTab:CreateParagraph({
   Title = "opz Hub",
   Content = "Script by: Poz"
})

CreditTab:CreateButton({
   Name = "Copy TikTok",
   Callback = function()
       setclipboard("https://www.tiktok.com/@hoangtugio17211")
       Rayfield:Notify({
          Title = "Copied",
          Content = "TikTok link copied",
          Duration = 3
       })
   end
})

LP.CharacterAdded:Connect(function()
    task.wait(1)
    ApplyAll()
end)

Rayfield:Notify({
   Title = "opz Hub",
   Content = "Đã load thành công",
   Duration = 3
})
