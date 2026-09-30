local config = {}

-- Admin settings
config.admins = {
	[11741064668] = true,
}

-- File names (without .lua) inside commands/ to load
config.commandList = {"speed", "jumpPower"}

-- Keybind to toggle panel (Default: F2)
config.toggleKey = Enum.KeyCode.F2

-- Command prefix (for chat commands if needed)
config.commandPrefix = "/"

-- UI Settings
config.panelSize = UDim2.new(0, 300, 0, 500)
config.panelPosition = UDim2.new(0.5, -150, 0.5, -250)

-- Colors
config.colors = {
	background = Color3.fromRGB(20, 20, 25),
	accent = Color3.fromRGB(100, 200, 255),
	text = Color3.fromRGB(240, 240, 245),
	hover = Color3.fromRGB(35, 35, 45),
	border = Color3.fromRGB(50, 50, 65),
	success = Color3.fromRGB(100, 200, 100),
	error = Color3.fromRGB(255, 100, 100),
}

return config