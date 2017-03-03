require "class"
require "copy"

Menu = class()

function Menu:_init(game, buttons, x, y, width, height)
	self.buttonNames = buttons -- buttons = a list of k = display name, v = thing to return with the new value of it.
	self.game = game
	self.controllingInput = 0 -- the input that is allowed to edit. 0 can be controlled by anyone.
	self.buttons = {}
	self:importFromButtons(buttons)
	self.buttonBackup = {}
	self:makeDefaultsBackup()
	self.x = x
	self.y = y
	self.width = width or 0
	self.height = height or 0
	self.selection = 0

	self.numPerHorizontal = 5
	self.numPerVertical = 4
	self:setButtonPositions()
	self.mainFont = love.graphics.newFont("fonts/joystixMonospace.ttf", 18)
	self.subFont = love.graphics.newFont("fonts/joystixMonospace.ttf", 16)
	self.selectionToggle = false
end

function Menu:makeDefaultsBackup()
	for i = 1, #self.buttons do
		self.buttonBackup[self.buttons[i].message] = self.game.gameSettings[self.buttons[i].message]
	end
end

function Menu:loadDefaults(defaults)
	for k, v in pairs(defaults) do
		self.game.gameSettings[k] = v
	end
end

function Menu:importFromButtons(buttons)
	for i = 1, #buttons do
		local v = buttons[i]
		self.buttons[i] = {displayName = v[1], message = v[2], value = 0, min = 0, max = 1, isBoolean = true, x = 0, y = 0, action = false}
		if v[3] == "action" then
			self.buttons[i].action = true
		end
	end
	self.selection = 0
end

function Menu:drawSwitches(x, y, state)
	love.graphics.printf(state, x-500, y, 1000, "center")
end

function Menu:setButtonPositions()
	self.x = love.graphics.getWidth()/8
	self.width = love.graphics.getWidth()-self.x*2
	self.height = love.graphics.getHeight()-self.y*2
	local i = 0
	-- local buttonX = self.x
	-- local buttonY = self.y
	for k, v in pairs(self.buttons) do
		v.x = self.x + (self.width/(self.numPerHorizontal-1)*(i % self.numPerHorizontal))
		v.y = self.y + self.height/(self.numPerVertical-1)*math.floor(i/self.numPerHorizontal)
		-- buttonX = 
		-- print(i % self.numPerHorizontal)
		-- print((self.width/(self.numPerHorizontal-1))*(i % self.numPerHorizontal))
		-- buttonY = 
		-- print(self.height/(self.numPerVertical-1)*math.floor(i/self.numPerHorizontal))
		i = i + 1
		-- if i % self.numPerHorizontal == 0 then
		-- 	buttonX = self.x
		-- 	buttonY = buttonY + self.height/(self.numPerVertical-1)
		-- end
	end
end

function Menu:setInput(inputNum)
	self.controllingInput = inputNum
end

function Menu:draw()
	local i = 0
	love.graphics.setFont(self.mainFont)
	for k, v in pairs(self.buttons) do
		if i == self.selection then
			love.graphics.setColor(200, 200, 200)
		else
			love.graphics.setColor(100, 100, 100)
		end
		love.graphics.printf(v.displayName, v.x-500, v.y, 1000, "center")
		i = i + 1
	end
	love.graphics.setFont(self.subFont)
	love.graphics.setColor(0, 0, 0)
	for k, v in pairs(self.buttons) do
		-- love.graphics.printf(v.displayName, v.x-500, v.y, 1000, "center")
		if v.action then
			-- draw magic stuff
			self:drawSwitches(v.x, v.y+50, tostring(""))
		else
			if not self.game.gameSettings[v.message] or tostring(self.game.gameSettings[v.message]) == "off" then
				love.graphics.setColor(255, 100, 100)
			else
				love.graphics.setColor(100, 255, 100)
			end
			-- print("DKLSJDFLKSJ")
			if tostring(self.game.gameSettings[v.message]) == "false" then
				self:drawSwitches(v.x, v.y+50, "off")
			elseif tostring(self.game.gameSettings[v.message]) == "true" then
				self:drawSwitches(v.x, v.y+50, "on")
			else
				self:drawSwitches(v.x, v.y+50, tostring(self.game.gameSettings[v.message]))
			end
		end
	end
end

function Menu:selectSelected()
	if self.buttons[self.selection+1].message == "back" then
		self.game:popScreenStack()
	elseif self.buttons[self.selection+1].message == "reset" then
		self.game.gameSettings = clone(self.game.defaultSettings)
	elseif self.buttons[self.selection+1].message == "random" then
		for i, v in ipairs(self.buttons) do
			if not v.action then
				for i = 1, math.random(10) do
					self.game:changeSetting(v.message)
				end
			end
		end
	elseif self.buttons[self.selection+1].message == "alloff" then
		for i, v in ipairs(self.buttons) do
			if tostring(self.game.gameSettings[v.message]) == "true" then
				self.game.gameSettings[v.message] = false
			elseif tostring(self.game.gameSettings[v.message]) ~= "false" then
				self.game.gameSettings[v.message] = "off"
			end
		end
	else
		-- print("button changed "..tostring(self.buttons[self.selection+1].message))
		self.game:changeSetting(self.buttons[self.selection+1].message)
	end
end

function Menu:update(dt)
	self:setButtonPositions()
end

function Menu:inputMade(inputNum, input, pressValue)
	if pressValue == 0 then
		return
	end
	if self.controllingInput == 0 or self.controllingInput == inputNum then
		if (input == "punch" or input == "kick") then
			self:selectSelected()
			-- self.selectionToggle = true
		-- else
			-- self.selectionToggle = false
		end
		if input == "up" then
			self.selection = self.selection - self.numPerHorizontal
		elseif input == "down" then
			self.selection = self.selection + self.numPerHorizontal
		elseif input == "left" or input == "lookleft" then
			self.selection = self.selection - 1
		elseif input == "right" or input == "lookright" then
			self.selection = self.selection + 1
		end
	end
	if self.selection >= #self.buttons then
		self.selection = self.selection % self.numPerHorizontal
	end
	if self.selection < 0 then
		self.selection = #self.buttons+self.selection
	end
end