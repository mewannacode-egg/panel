local baseUrl = "https://raw.githubusercontent.com/mewannacode-egg/panel/main/"

local ui = loadstring(game:HttpGet(baseUrl .. "ui.lua"))()
local config = loadstring(game:HttpGet(baseUrl .. "config.lua"))()
local utils = loadstring(game:HttpGet(baseUrl .. "utils.lua"))()
local loader = loadstring(game:HttpGet(baseUrl .. "loader.lua"))()

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local panelGui = nil
local panelVisible = false

-- Check if player is admin
print("[AdminPanel] Modules loaded")

if not utils.isAdmin(player, config) then
	warn("You are not an admin! UserId: " .. player.UserId)
	return
end

-- Initialize loader and load commands
loader.loadCommands(baseUrl, config.commandList)
print("[AdminPanel] Commands loaded")

-- State + full cleanup (X button)
local destroyed = false
local toggleGui = nil
local keybindConn = nil

local function nukePanel()
	destroyed = true
	if keybindConn then keybindConn:Disconnect() end
	if panelGui then panelGui.gui:Destroy() end
	if toggleGui then toggleGui:Destroy() end
	panelGui = nil
	print("[AdminPanel] Panel closed")
end

-- Initialize UI
local function initializePanel()
	panelGui = ui.init()
	panelGui.closeButton.MouseButton1Click:Connect(nukePanel)
	panelGui.minimizeButton.MouseButton1Click:Connect(function()
		panelVisible = false
		panelGui.gui.Enabled = false
	end)
	
	-- Load all commands and create UI elements
	local categories = loader.getCategories()
	
	for _, category in pairs(categories) do
		local categoryCommands = loader.getCommandsByCategory(category)
		local categoryFrame, container = ui.createCategory(panelGui.scrollFrame, category)
		
		for _, command in pairs(categoryCommands) do
			if command.type == "button" then
				ui.createButton(container, command.name, function()
					loader.executeCommand(command.name, player)
					utils.notify("Command", command.name .. " executed", 2)
				end)
			elseif command.type == "toggle" then
				ui.createToggle(container, command.name, command.default or false, function(state)
					loader.executeCommand(command.name, player, state)
				end)
			elseif command.type == "slider" then
				ui.createSlider(container, command.name, command.min or 0, command.max or 100, command.default or 50, function(value)
					loader.executeCommand(command.name, player, value)
				end)
			end
		end
	end
	
	panelVisible = false
	panelGui.gui.Enabled = false
end

-- Toggle panel visibility
local function togglePanel()
	if destroyed then return end
	if not panelGui then
		initializePanel()
	end
	
	panelVisible = not panelVisible
	panelGui.gui.Enabled = panelVisible
end

-- Create toggle button for mobile/PC
local function createToggleButton()
	local playerGui = player:WaitForChild("PlayerGui")
	
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Name = "PanelToggle"
	toggleBtn.Text = "⚙"
	toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
	toggleBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
	toggleBtn.TextSize = 24
	toggleBtn.Font = Enum.Font.GothamBold
	toggleBtn.Size = UDim2.new(0, 50, 0, 50)
	toggleBtn.Position = UDim2.new(1, -60, 0, 10)
	toggleBtn.BorderSizePixel = 0
	toggleGui = Instance.new("ScreenGui")
	toggleGui.Name = "PanelToggle"
	toggleGui.ResetOnSpawn = false
	toggleGui.Parent = playerGui
	toggleBtn.Parent = toggleGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = toggleBtn
	
	ui.makeDraggable(toggleBtn, toggleBtn, togglePanel)
end

-- Input handling for keyboard (PC)
keybindConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == config.toggleKey then
		togglePanel()
	end
end)

-- Initialize panel and toggle button on startup
createToggleButton()
initializePanel()

print("[AdminPanel] Admin panel initialized successfully!")
print("[AdminPanel] Press " .. tostring(config.toggleKey) .. " to toggle the panel or click the ⚙ button")