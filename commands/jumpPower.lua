local Players = game:GetService("Players")

local jumpPower = {}
jumpPower.name = "Jump Power"
jumpPower.category = "Movement"
jumpPower.type = "slider"
jumpPower.min = 0
jumpPower.max = 200
jumpPower.default = 50

local player = Players.LocalPlayer
local currentValue = nil

local function apply()
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid and currentValue then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = currentValue
	end
end

-- Keep the jump power after respawning
player.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid")
	apply()
end)

function jumpPower.execute(executor, value)
	currentValue = value
	apply()
end

return jumpPower
