local utils = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Check if player is admin
function utils.isAdmin(player, config)
	return config.admins[player.UserId] == true
end

-- Create notification
function utils.notify(title, message, duration)
	duration = duration or 3
	
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	local notification = Instance.new("TextLabel")
	notification.Name = "Notification"
	notification.Text = title .. ": " .. message
	notification.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	notification.TextColor3 = Color3.fromRGB(200, 200, 210)
	notification.TextSize = 13
	notification.Font = Enum.Font.Gotham
	notification.BorderSizePixel = 0
	notification.Size = UDim2.new(0, 300, 0, 50)
	notification.Position = UDim2.new(1, -320, 1, -70)
	notification.Parent = playerGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = notification
	
	game:GetService("Debris"):AddItem(notification, duration)
end

-- Get player by name or partial name
function utils.getPlayer(name)
	local targetPlayer = nil
	local nameLower = name:lower()
	
	for _, player in pairs(Players:GetPlayers()) do
		if player.Name:lower():sub(1, #name) == nameLower then
			targetPlayer = player
			break
		end
	end
	
	return targetPlayer
end

-- Get all players
function utils.getAllPlayers()
	return Players:GetPlayers()
end

-- Wait for character
function utils.waitForCharacter(player, timeout)
	timeout = timeout or 30
	local character = player.Character or player.CharacterAdded:Wait()
	
	if not character then
		local start = tick()
		repeat
			character = player.Character
			if character then break end
			RunService.Heartbeat:Wait()
		until tick() - start > timeout or character
	end
	
	return character
end

-- Get humanoid root part
function utils.getHumanoidRootPart(player)
	local character = utils.waitForCharacter(player)
	if character then
		return character:FindFirstChild("HumanoidRootPart")
	end
	return nil
end

-- Log command execution
function utils.logCommand(commandName, executor, target)
	target = target or "N/A"
	print("[AdminPanel] Command: " .. commandName .. " | Executor: " .. executor.Name .. " | Target: " .. tostring(target))
end

return utils