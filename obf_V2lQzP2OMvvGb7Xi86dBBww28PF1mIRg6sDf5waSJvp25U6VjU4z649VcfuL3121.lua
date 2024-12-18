local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = Player:WaitForChild("PlayerGui")

ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 200, 0, 50)
ToggleButton.Position = UDim2.new(0.5, -100, 0.9, -25)
ToggleButton.Text = "Start Farm"
ToggleButton.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local isFarming = false
local farmProcess

_G.ProximityPromptCountdown = 1
_G.AutoProximityPrompt = false

local function fireproximityprompt(Obj, Amount, Skip)
    if Obj.ClassName == "ProximityPrompt" then 
        Amount = Amount or 1
        local PromptTime = Obj.HoldDuration
        if Skip then 
            Obj.HoldDuration = 0
        end
        for i = 1, Amount do 
            Obj:InputHoldBegin()
            if not Skip then 
                wait(Obj.HoldDuration)
            end
            Obj:InputHoldEnd()
        end
        Obj.HoldDuration = PromptTime
    else 
        error("userdata<ProximityPrompt> expected")
    end
end

local function ProximityPromptCountdown()
    while _G.AutoProximityPrompt do
        wait(_G.ProximityPromptCountdown)
        for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
            if v:IsA("ProximityPrompt") then 
                fireproximityprompt(v, 1, true)
            end 
        end
    end
end

local function teleportTo(position)
    HumanoidRootPart.CFrame = CFrame.new(position)
end

local function executeFarmSequence()
    local firstPositions = {
        Vector3.new(918.5054931640625, 6.004361629486084, 2593.403076171875),
        Vector3.new(906.214111328125, 5.937725067138672, 2598.89599609375),
        Vector3.new(902.2783203125, 5.911746501922607, 2598.19482421875),
        Vector3.new(893.4700927734375, 6.002333164215088, 2604.52685546875),
        Vector3.new(894.46728515625, 6.192965030670166, 2609.843505859375),
        Vector3.new(916.9315185546875, 5.948697090148926, 2617.240966796875),
        Vector3.new(922.0988159179688, 5.937203884124756, 2617.114013671875),
        Vector3.new(931.0291748046875, 5.925728797912598, 2616.84619140625),
        Vector3.new(934.7196044921875, 5.966183185577393, 2616.73583984375),
        Vector3.new(960.099853515625, 5.936804294586182, 2609.057373046875),
        Vector3.new(960.1348266601562, 5.867787837982178, 2605.752197265625),
        Vector3.new(951.9701538085938, 5.467665195465088, 2599.0078125),
        Vector3.new(946.7758178710938, 5.467687606811523, 2599.128662109375),
    }

    for _, position in ipairs(firstPositions) do
        teleportTo(position)
        if position == Vector3.new(918.5054931640625, 6.004361629486084, 2593.403076171875) then
            wait(15)
        else
            wait(1)
        end
    end

    teleportTo(Vector3.new(849.0470581054688, 4.961475372314453, 51.236000061035156))
    wait(380)

    for _, position in ipairs(firstPositions) do
        teleportTo(position)
        if position == Vector3.new(918.5054931640625, 6.004361629486084, 2593.403076171875) then
            wait(5)
        else
            wait(1)
        end
    end

    teleportTo(Vector3.new(849.0470581054688, 4.961475372314453, 51.236000061035156))
    wait(380)
end

ToggleButton.MouseButton1Click:Connect(function()
    isFarming = not isFarming
    if isFarming then
        ToggleButton.Text = "Stop Farm"
        _G.AutoProximityPrompt = true
        farmProcess = coroutine.wrap(function()
            while isFarming do
                executeFarmSequence()
            end
        end)
        farmProcess()
        ProximityPromptCountdown()
    else
        ToggleButton.Text = "Start Farm"
        _G.AutoProximityPrompt = false
    end
end)