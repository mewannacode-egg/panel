local Players = game:GetService("Players")

local speed = {}
speed.name = "Speed"
speed.category = "Movement"
speed.type = "slider"
speed.min = 0
speed.max = 100
speed.default = 16

local player = Players.LocalPlayer
local currentValue = nil

local function apply()
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid and currentValue then
		humanoid.WalkSpeed = currentValue
	end
end

-- Keep the speed after respawning
player.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid")
	apply()
end)

function speed.execute(executor, value)
	currentValue = value
	apply()
end

return speed
