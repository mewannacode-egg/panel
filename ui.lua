local ui = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- UI Configuration
local config = {
	bgColor = Color3.fromRGB(20, 20, 25),
	accentColor = Color3.fromRGB(100, 200, 255),
	textColor = Color3.fromRGB(240, 240, 245),
	hoverColor = Color3.fromRGB(35, 35, 45),
	borderColor = Color3.fromRGB(80, 88, 110),
}

-- Add outline (and optional rounded corners)
local function addStroke(instance, color, thickness, radius)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness or 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = instance
	if radius then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, radius)
		corner.Parent = instance
	end
end

-- Create main ScreenGui
local function createGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AdminPanel"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	return screenGui
end

-- Create category frame
function ui.createCategory(parent, title)
	local categoryFrame = Instance.new("Frame")
	categoryFrame.Name = title .. "Category"
	categoryFrame.BackgroundColor3 = config.bgColor
	categoryFrame.BorderColor3 = config.borderColor
	categoryFrame.BorderSizePixel = 0
	categoryFrame.Size = UDim2.new(1, -10, 0, 0)
	categoryFrame.AutomaticSize = Enum.AutomaticSize.Y
	categoryFrame.LayoutOrder = 1
	categoryFrame.Parent = parent
	addStroke(categoryFrame, config.borderColor, 1, 8)

	local categoryPadding = Instance.new("UIPadding")
	categoryPadding.PaddingBottom = UDim.new(0, 8)
	categoryPadding.Parent = categoryFrame

	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Text = title
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = config.accentColor
	titleLabel.TextSize = 16
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Size = UDim2.new(1, -10, 0, 25)
	titleLabel.Position = UDim2.new(0, 5, 0, 0)
	titleLabel.Parent = categoryFrame

	-- Container for elements
	local container = Instance.new("Frame")
	container.Name = "Container"
	container.BackgroundTransparency = 1
	container.Size = UDim2.new(1, -10, 0, 0)
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.Position = UDim2.new(0, 5, 0, 30)
	container.Parent = categoryFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 8)
	listLayout.Parent = container

	return categoryFrame, container
end

-- Create button
function ui.createButton(parent, text, callback)
	local button = Instance.new("TextButton")
	button.Name = text .. "Button"
	button.Text = text
	button.BackgroundColor3 = config.accentColor
	button.TextColor3 = config.bgColor
	button.TextSize = 14
	button.Font = Enum.Font.GothamSemibold
	button.Size = UDim2.new(1, 0, 0, 35)
	button.BorderSizePixel = 0
	button.Parent = parent
	addStroke(button, Color3.fromRGB(160, 225, 255), 1, 6)

	-- Hover effect
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(120, 220, 255)
	end)

	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = config.accentColor
	end)

	button.MouseButton1Click:Connect(callback)

	return button
end

-- Create toggle
function ui.createToggle(parent, text, defaultValue, callback)
	local container = Instance.new("Frame")
	container.Name = text .. "Toggle"
	container.BackgroundTransparency = 1
	container.Size = UDim2.new(1, 0, 0, 35)
	container.Parent = parent

	local label = Instance.new("TextLabel")
	label.Text = text
	label.BackgroundTransparency = 1
	label.TextColor3 = config.textColor
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.Parent = container

	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "Toggle"
	toggleButton.Text = defaultValue and "ON" or "OFF"
	toggleButton.BackgroundColor3 = defaultValue and config.accentColor or Color3.fromRGB(70, 70, 85)
	toggleButton.TextColor3 = config.bgColor
	toggleButton.TextSize = 12
	toggleButton.Font = Enum.Font.GothamBold
	toggleButton.Size = UDim2.new(0.25, 0, 1, 0)
	toggleButton.Position = UDim2.new(0.7, 0, 0, 0)
	toggleButton.BorderSizePixel = 0
	toggleButton.Parent = container
	addStroke(toggleButton, config.borderColor, 1, 6)

	local state = defaultValue

	toggleButton.MouseButton1Click:Connect(function()
		state = not state
		toggleButton.Text = state and "ON" or "OFF"
		toggleButton.BackgroundColor3 = state and config.accentColor or Color3.fromRGB(70, 70, 85)
		if callback then callback(state) end
	end)

	return container, toggleButton
end

-- Create slider with input box (drag the slider OR type a value)
function ui.createSlider(parent, text, min, max, defaultValue, callback)
	local container = Instance.new("Frame")
	container.Name = text .. "Slider"
	container.BackgroundTransparency = 1
	container.Size = UDim2.new(1, 0, 0, 60)
	container.Parent = parent

	local label = Instance.new("TextLabel")
	label.Text = text
	label.BackgroundTransparency = 1
	label.TextColor3 = config.textColor
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Size = UDim2.new(1, -70, 0, 24)
	label.Parent = container

	local inputBox = Instance.new("TextBox")
	inputBox.Name = "Input"
	inputBox.Text = tostring(defaultValue)
	inputBox.BackgroundColor3 = config.hoverColor
	inputBox.TextColor3 = config.accentColor
	inputBox.TextSize = 13
	inputBox.Font = Enum.Font.GothamSemibold
	inputBox.ClearTextOnFocus = false
	inputBox.Size = UDim2.new(0, 60, 0, 24)
	inputBox.Position = UDim2.new(1, -60, 0, 0)
	inputBox.BorderSizePixel = 0
	inputBox.Parent = container
	addStroke(inputBox, config.borderColor, 1, 6)

	local sliderBg = Instance.new("Frame")
	sliderBg.Name = "SliderBg"
	sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
	sliderBg.BorderSizePixel = 0
	sliderBg.Size = UDim2.new(1, -16, 0, 8)
	sliderBg.Position = UDim2.new(0, 8, 0, 42)
	sliderBg.Parent = container
	addStroke(sliderBg, config.borderColor, 1, 4)

	local sliderFill = Instance.new("Frame")
	sliderFill.Name = "Fill"
	sliderFill.BackgroundColor3 = config.accentColor
	sliderFill.BorderSizePixel = 0
	sliderFill.Parent = sliderBg
	addStroke(sliderFill, config.accentColor, 0, 4)

	local sliderButton = Instance.new("TextButton")
	sliderButton.Name = "Knob"
	sliderButton.Text = ""
	sliderButton.BackgroundColor3 = config.accentColor
	sliderButton.BorderSizePixel = 0
	sliderButton.Size = UDim2.new(0, 16, 0, 16)
	sliderButton.Parent = sliderBg
	addStroke(sliderButton, Color3.fromRGB(160, 225, 255), 1, 8)

	local currentValue = defaultValue

	local function setValue(value, fire)
		value = math.clamp(math.floor(value + 0.5), min, max)
		currentValue = value
		local percentage = (value - min) / (max - min)
		sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
		sliderButton.Position = UDim2.new(percentage, -8, -0.5, 0)
		inputBox.Text = tostring(value)
		if fire and callback then callback(value) end
	end

	-- Slider dragging (mouse + touch)
	local dragging = false

	local function updateFromInput(input)
		local percentage = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
		setValue(min + (max - min) * percentage, true)
	end

	local function startDrag(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateFromInput(input)
		end
	end

	sliderBg.InputBegan:Connect(startDrag)
	sliderButton.InputBegan:Connect(startDrag)

	local changedConn = UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateFromInput(input)
		end
	end)

	local endedConn = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	container.AncestryChanged:Connect(function()
		if not container:IsDescendantOf(game) then
			changedConn:Disconnect()
			endedConn:Disconnect()
		end
	end)

	-- Typing a value
	inputBox.FocusLost:Connect(function()
		local typed = tonumber(inputBox.Text)
		if typed then
			setValue(typed, true)
		else
			inputBox.Text = tostring(currentValue)
		end
	end)

	setValue(defaultValue, false)

	return container
end

-- Make an element draggable (mouse + touch). onClick fires only if it wasn't dragged
function ui.makeDraggable(handle, target, onClick)
	local dragging = false
	local moved = false
	local dragStart, startPos

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			dragStart = input.Position
			startPos = target.Position
		end
	end)

	local changedConn = UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			if delta.Magnitude > 6 then moved = true end
			if moved then
				target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end
	end)

	local endedConn = UserInputService.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
			if not moved and onClick then onClick() end
		end
	end)

	target.AncestryChanged:Connect(function()
		if not target:IsDescendantOf(game) then
			changedConn:Disconnect()
			endedConn:Disconnect()
		end
	end)
end

-- Initialize main panel
function ui.init()
	local screenGui = createGui()

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainPanel"
	mainFrame.BackgroundColor3 = config.bgColor
	mainFrame.BorderSizePixel = 0
	mainFrame.Size = UDim2.new(0, 280, 0, 340)
	mainFrame.Position = UDim2.new(0.5, -140, 0.5, -170)
	mainFrame.Parent = screenGui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 10)
	mainCorner.Parent = mainFrame

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = config.borderColor
	mainStroke.Thickness = 1.5
	mainStroke.Parent = mainFrame

	-- Title bar (drag handle)
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	titleBar.BorderSizePixel = 0
	titleBar.Size = UDim2.new(1, 0, 0, 36)
	titleBar.Active = true
	titleBar.Parent = mainFrame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 10)
	titleCorner.Parent = titleBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Text = "Admin Panel"
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = config.textColor
	titleLabel.TextSize = 14
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Size = UDim2.new(1, -80, 1, 0)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = titleBar

	-- Close button
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "Close"
	closeButton.Text = "X"
	closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
	closeButton.TextColor3 = config.bgColor
	closeButton.TextSize = 14
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Size = UDim2.new(0, 26, 0, 26)
	closeButton.Position = UDim2.new(1, -32, 0, 5)
	closeButton.BorderSizePixel = 0
	closeButton.Parent = titleBar

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 6)
	closeCorner.Parent = closeButton

	-- Minimize button
	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Name = "Minimize"
	minimizeButton.Text = "-"
	minimizeButton.BackgroundColor3 = config.borderColor
	minimizeButton.TextColor3 = config.textColor
	minimizeButton.TextSize = 16
	minimizeButton.Font = Enum.Font.GothamBold
	minimizeButton.Size = UDim2.new(0, 26, 0, 26)
	minimizeButton.Position = UDim2.new(1, -62, 0, 5)
	minimizeButton.BorderSizePixel = 0
	minimizeButton.Parent = titleBar

	local minimizeCorner = Instance.new("UICorner")
	minimizeCorner.CornerRadius = UDim.new(0, 6)
	minimizeCorner.Parent = minimizeButton

	ui.makeDraggable(titleBar, mainFrame)

	-- Scroll frame for categories
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ScrollFrame"
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.Size = UDim2.new(1, 0, 1, -36)
	scrollFrame.Position = UDim2.new(0, 0, 0, 36)
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.ScrollBarThickness = 4
	scrollFrame.ScrollBarImageColor3 = config.borderColor
	scrollFrame.Parent = mainFrame

	local scrollPadding = Instance.new("UIPadding")
	scrollPadding.PaddingTop = UDim.new(0, 8)
	scrollPadding.PaddingLeft = UDim.new(0, 5)
	scrollPadding.Parent = scrollFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 10)
	listLayout.Parent = scrollFrame

	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 16)
	end)

	return {
		gui = screenGui,
		mainFrame = mainFrame,
		scrollFrame = scrollFrame,
		closeButton = closeButton,
		minimizeButton = minimizeButton,
	}
end

return ui
