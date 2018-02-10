




require "class"
require "menu"

ControlsMenu = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function ControlsMenu:_init(game, mainFont, smallerFont)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false
	self.game = game
	self.mainFont = mainFont
	self.smallerFont = smallerFont
	self.subscribedToInputs = false
	self.inputNum = 0
	self.menuSelection = 1
	self.menuValues = {1, 1, 1} -- the position in the menu
	self.menuOptions = {{"Binding", "Binding"}, {"Two people per joystick:\nFalse", "Two people per joystick:\nTrue"}, {"Leave"}}
	self.keys = {}
	self.controlsText = ""
end

function ControlsMenu:setInput(input)
	self.inputNum = input
	self.menuSelection = 1
	-- changed for arcade machine
	local keyboardT = {{punch = "left button", kick = "middle button", ["switch direction"] = "right button", ["joystick"] = "move, jump and duck"},
						{punch = "n", kick = "m", left = "f", right = "h", up = "t", down = "g"},
						{punch = "left button", kick = "middle button", ["switch direction"] = "right button", ["joystick"] = "move, jump and duck"},
						{punch = "numpad 3", kick = "numpad enter", left = "numpad 4", right = "numpad 6", up = "numpad 8", down = "numpad 5"}}
	local controlOrder = {"joystick", "punch", "kick", "switch direction"}
	local currentInput = {}
	self.controlsText = "Player "..self.game.mainMenu.mapInputsToPlayers[input]..":\n"
	if input <= 8 then
		-- assume the keyboard mode is the nice one, because I'm too lazy to do otherwise
		for i, j in pairs(controlOrder) do
			for k, v in pairs(keyboardT[(input-1)%4+1]) do
				if j == k then
					if k == "punch" or k == "kick" then
						self.controlsText = self.controlsText .. "Hold "..v .. " = "..k.."\n"
					else
						self.controlsText = self.controlsText .. v .. " = "..k.."\n"
					end
				end
			end
		end
		self.controlsText = self.controlsText .. "\n\nPress any input to return."
	else
		if input <= 16 or not self.game.keyboard.gamepads[(input-9)%8+1].split then
			self.controlsText = self.controlsText.."Joystick Binding: "..self.game.keyboard.gamepadBindings[self.game.keyboard.gamepads[(input-9)%8+1].primaryMode].name.."\n\n"
			self.controlsText = self.controlsText..string.gsub(self.game.keyboard.gamepadBindings[self.game.keyboard.gamepads[(input-9)%8+1].primaryMode].displaytextprimary, "|", "\n")
		else
			self.controlsText = self.controlsText.."Joystick Binding: "..self.game.keyboard.gamepadBindings[self.game.keyboard.gamepads[(input-9)%8+1].secondaryMode].name.."\n\n"
			self.controlsText = self.controlsText..string.gsub(self.game.keyboard.gamepadBindings[self.game.keyboard.gamepads[(input-9)%8+1].secondaryMode].displaytextsecondary, "|", "\n")
		end
	end
end

function ControlsMenu:changeJoystickInputMethod(goingRight, reload)
	local goingRight = goingRight or true
	if self.inputNum <= 8 then
		return -- it's a keyboard. Sucks to be you.
	end
	local current = 0
	if self.inputNum <= 16 then
		current = self.game.keyboard.gamepads[(self.inputNum-9)%8+1].primaryMode
	else
		current = self.game.keyboard.gamepads[(self.inputNum-9)%8+1].secondaryMode
	end
	local split = self.game.keyboard.gamepads[(self.inputNum-9)%8+1].split
	while true do
		if goingRight then
			current = current + 1
		else
			current = current - 1
		end
		if current <= 0 then
			current = #self.game.keyboard.gamepadBindings
		elseif current > #self.game.keyboard.gamepadBindings then
			current = 1
		end
		if (self.game.keyboard.gamepadBindings[current].size == "half") == split then
			break -- since it's the next one to look at
		end
		-- otherwise continue
	end
	-- set it to the new joystick input method
	if self.inputNum <= 16 then
		self.game.keyboard.gamepads[(self.inputNum-9)%8+1].primaryMode = current
	else
		self.game.keyboard.gamepads[(self.inputNum-9)%8+1].secondaryMode = current
	end
	if reload == nil or reload then
		-- reload the text
		self:setInput(self.inputNum)
	end
end

function ControlsMenu:reloadText()
	-- reload the text
	self:setInput(self.inputNum)
end

function ControlsMenu:load()
	self.menuSelection = 1
	self.menuValues = {1, 1, 1} -- the position in the menu
	-- print("Controls loaded (input == "..self.inputNum..")")
	love.graphics.setFont(self.smallerFont)
	self.subscribedToInputs = true
	self.game.keyboard.controlsMenuSubscribed = true
	-- set whether or not it's two person per controller
	if self.game.keyboard.gamepads[(self.inputNum-9)%8+1].split then
		self.menuValues[2] = 2
	else
		self.menuValues[2] = 1
	end
	-- set what binding it has
	-- if self.inputNum > 8 and self.inputNum <= 16 then
	-- 	self.menuValues[1] = self.game.keyboard.gamepads[(self.inputNum-9)%8+1].primaryMode
	-- elseif self.inputNum > 16 then
	-- 	self.menuValues[1] = self.game.keyboard.gamepads[(self.inputNum-9)%8+1].secondaryMode
	-- end
end

function ControlsMenu:leave()
	-- run when the level no longer has control
	-- print("controls left")
	self.subscribedToInputs = false
	self.game.keyboard.controlsMenuSubscribed = false
end

function ControlsMenu:draw()
	love.graphics.printf(self.controlsText, love.graphics.getWidth()/2-500, love.graphics.getHeight()/10, 1000, "center")
	if self.inputNum <= 8 then
		return
	end
	local y = love.graphics.getHeight()/2+love.graphics.getHeight()/4
	local x = love.graphics.getWidth()/2
	for i = 1, #self.menuOptions do
		local displayText = self.menuOptions[i][self.menuValues[i]]
		if displayText == nil then
			displayText = "THERE'S A BUG!"
		end
		if i == self.menuSelection then
			love.graphics.setColor(255, 255, 255)
			if #self.menuOptions[i] > 1 then
				local width = self.smallerFont:getWidth(displayText)
				love.graphics.rectangle("fill", x-width/2-10-2, y+10, 10, 10) -- the -10 is to subtract the rectangle's width
				love.graphics.rectangle("fill", x+width/2+2, y+10, 10, 10)
			end
		else
			love.graphics.setColor(150, 150, 150)
		end
		love.graphics.printf(displayText, x-500, y, 1000, "center")
		_, count = string.gsub(self.menuOptions[i][self.menuValues[i]], "\n", "\n")
		for i = 1, count do
			y = y + 40
		end
		y = y + 40
	end
	love.graphics.setColor(255, 255, 255)
end

function ControlsMenu:update(dt)
	--
end

function ControlsMenu:resize(w, h)
	--
end

function ControlsMenu:inputMade(inputNum, input, pressValue)
	if pressValue == 0 then
		return
	end
	if inputNum ~= self.inputNum then
		-- ignore input made by other controllers
		return
	end
	if self.inputNum <= 8 then
		self.game:popScreenStack() -- it's a keyboard, so exit out
	end
	if input == "right" or input == "lookright" or input == "menuright" or input == "punch" or input == "menupunch" then
		if self.menuSelection == 1 then
			self:changeJoystickInputMethod(true)
		elseif self.menuSelection == 2 then
			self.menuValues[2] = 3-self.menuValues[2]
			self.game.keyboard.gamepads[(self.inputNum-9)%8+1].split = not self.game.keyboard.gamepads[(self.inputNum-9)%8+1].split
			self:changeJoystickInputMethod(true)
			local past = self.inputNum
			if self.inputNum >= 16 then
				self.inputNum = self.inputNum - 8
			else
				self.inputNum = self.inputNum + 8
			end
			self:changeJoystickInputMethod(true, false)
			self.inputNum = past
			if not self.game.keyboard.gamepads[(self.inputNum-9)%8+1].split and self.inputNum >= 16 then
				self.game:popScreenStack()
				self.game.mainMenu:removePlayerFromGame(self.game.mainMenu.mapInputsToPlayers[self.inputNum])
			elseif not self.game.keyboard.gamepads[(self.inputNum-9)%8+1].split then
				self.game.mainMenu:removePlayerFromGame(self.game.mainMenu.mapInputsToPlayers[self.inputNum+8])
			end
		elseif self.menuSelection == 3 then
			self.game:popScreenStack()
		end
	elseif input == "left" or input == "lookleft" or input == "menuleft" or input == "kick" or input == "menukick" then
		if self.menuSelection == 1 then
			self:changeJoystickInputMethod(false)
		elseif self.menuSelection == 2 then
			self.menuValues[2] = 3-self.menuValues[2]
			self.game.keyboard.gamepads[(self.inputNum-9)%8+1].split = not self.game.keyboard.gamepads[(self.inputNum-9)%8+1].split
			self:changeJoystickInputMethod(false)
			local past = self.inputNum
			if self.inputNum >= 16 then
				self.inputNum = self.inputNum - 8
			else
				self.inputNum = self.inputNum + 8
			end
			self:changeJoystickInputMethod(false, false)
			self.inputNum = past
			if not self.game.keyboard.gamepads[(self.inputNum-9)%8+1].split and self.inputNum >= 16 then
				self.game:popScreenStack()
				self.game.mainMenu:removePlayerFromGame(self.game.mainMenu.mapInputsToPlayers[self.inputNum])
			elseif not self.game.keyboard.gamepads[(self.inputNum-9)%8+1].split then
				self.game.mainMenu:removePlayerFromGame(self.game.mainMenu.mapInputsToPlayers[self.inputNum+8])
			end
		elseif self.menuSelection == 3 then
			self.game:popScreenStack()
		end
	elseif input == "down" or input == "menudown" then
		self.menuSelection = self.menuSelection + 1
		if self.menuSelection > #self.menuOptions then
			self.menuSelection = 1
		end
	elseif input == "up" or input == "menuup" then
		self.menuSelection = self.menuSelection - 1
		if self.menuSelection <= 0 then
			self.menuSelection = #self.menuOptions
		end
	else
		self.game:popScreenStack()
	end
end

function ControlsMenu:keypressed(key, unicode)
	if key == "escape" then
		self.game:popScreenStack()
	end
end

function ControlsMenu:keyreleased(key, unicode)
	--
end

function ControlsMenu:mousepressed(x, y, button)
	--
end

function ControlsMenu:mousereleased(x, y, button)
	--
end