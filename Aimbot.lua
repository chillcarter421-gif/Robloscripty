local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIGURATION
local MAX_DISTANCE = 75
local SMOOTHNESS = 0.15 
local TOGGLE_KEY = Enum.KeyCode.E

local aimbotEnabled = true

-- Toggle tracking on key press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == TOGGLE_KEY then
        aimbotEnabled = not aimbotEnabled
    end
end)

local function getClosestCharacter(myRoot)
    local closest = nil
    local closestDist = MAX_DISTANCE

    for _, player in ipairs(Players:GetPlayers()) do
        -- Skip self and check if player is on the same team
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
            if player.Character then
                local head = player.Character:FindFirstChild("Head")
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChild("Humanoid")

                if head and hrp and hum and hum.Health > 0 then
                    local dist = (hrp.Position - myRoot.Position).Magnitude
                    if dist < closestDist then
                        closest = head
                        closestDist = dist
                    end
                end
            end
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
    if not aimbotEnabled then return end

    local myChar = LocalPlayer.Character
    if not myChar then return end
    
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local target = getClosestCharacter(myRoot)
    if target then
        local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, SMOOTHNESS)
    end
end)
