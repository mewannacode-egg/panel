local loader = {}

local commands = {}

-- Load all commands listed in config.commandList from GitHub
function loader.loadCommands(baseUrl, commandList)
	for _, fileName in pairs(commandList) do
		local success, command = pcall(function()
			return loadstring(game:HttpGet(baseUrl .. "commands/" .. fileName .. ".lua"))()
		end)
		
		if success and type(command) == "table" and command.name then
			commands[command.name:lower()] = command
			print("[Loader] Loaded command: " .. command.name)
		else
			warn("[Loader] Failed to load command: " .. fileName)
		end
	end
	
	return commands
end

-- Get command by name
function loader.getCommand(name)
	return commands[name:lower()]
end

-- Get all commands
function loader.getAllCommands()
	return commands
end

-- Get commands by category
function loader.getCommandsByCategory(category)
	local categoryCommands = {}
	
	for name, command in pairs(commands) do
		if command.category == category then
			table.insert(categoryCommands, command)
		end
	end
	
	return categoryCommands
end

-- Get all categories
function loader.getCategories()
	local categories = {}
	local categorySet = {}
	
	for _, command in pairs(commands) do
		if command.category and not categorySet[command.category] then
			table.insert(categories, command.category)
			categorySet[command.category] = true
		end
	end
	
	return categories
end

-- Execute command
function loader.executeCommand(commandName, executor, ...)
	local command = loader.getCommand(commandName)
	
	if not command then
		return false, "Command not found: " .. commandName
	end
	
	if command.execute then
		local success, result = pcall(command.execute, executor, ...)
		return success, result
	end
	
	return false, "Command has no execute function"
end

return loader