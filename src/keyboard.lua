require "class"

Keyboard = class()




function Keyboard:_init(game)
	self.keyboardType = 0 -- 0 = max four on keyboard, 1 = all eight on one keyboard, 2 = all eight on wasd
	self.joystickDeadZone = .25
	self.defaultJoystickMode = 0


	self.game = game
	self.gamepads = {}
	for i = 1, 8 do
		local debouncing = {leftx = 0, lefty = 0, rightx = 0, righty = 0, triggerleft = 0, triggerright = 0}
		self.gamepads[i] = {gamepad = nil, mode = self.defaultJoystickMode, hasGamepad = false, debounce = debouncing} -- 0 is jordan one per, 1 is martin's gameboy method, 2 is two per
	end
	self.gamepadMappings = {} -- a map of gamepadID() to 1-8 of self.gamepads
	self.mainmenuSubscribed = false
	self.settingsMenuSubscribed = false
	self.controlsMenuSubscribed = false

	self.keySets = {}
	for i = 1, 24 do -- make 8 for keyboards, then 8 for joysticks, then 8 for the second half of those joysticks...
		self.keySets[i] = {}
	end

	local left = 1
	local right = 2
	local up = 3
	local down = 4
	local punch = 5
	local kick = 6
	self.fourBasic = {
		a = 0*6+left, d = 0*6+right, w = 0*6+up, s = 0*6+down, c = 0*6+punch, v = 0*6+kick,
		f = 1*6+left, h = 1*6+right, t = 1*6+up, g = 1*6+down, n = 1*6+punch, m = 1*6+kick,
		j = 2*6+left, l = 2*6+right, i = 2*6+up, k = 2*6+down,
		kp4 = 3*6+left, kp6 = 3*6+right, kp8 = 3*6+up, kp5 = 3*6+down, kp3 = 3*6+punch, kpenter = 3*6+kick
	}
	self.fourBasic["."] = 2*6+punch
	self.fourBasic["/"] = 2*6+kick


	self.eightStandard = {
		q = 2*6+left, w = 2*6+right, e = 2*6+up, r = 2*6+down, t = 2*6+punch, y = 2*6+kick,
		u = 3*6+left, i = 3*6+right, o = 3*6+up, p = 3*6+down, 
		a = 4*6+left, s = 4*6+right, d = 4*6+up, f = 4*6+down, g = 4*6+punch, h = 4*6+kick,
		j = 5*6+left, k = 5*6+right, l = 5*6+up,
		lshift = 6*6+left, z = 6*6+right, x = 6*6+up, c = 6*6+down, v = 6*6+punch, b = 6*6+kick,
		n = 7*6+left, m = 7*6+right, rshift = 7*6+kick,
	}
	self.eightStandard["`"] = 0*6+left
	self.eightStandard["1"] = 0*6+right
	self.eightStandard["2"] = 0*6+up
	self.eightStandard["3"] = 0*6+down
	self.eightStandard["4"] = 0*6+punch
	self.eightStandard["5"] = 0*6+kick

	self.eightStandard["7"] = 1*6+left
	self.eightStandard["8"] = 1*6+right
	self.eightStandard["9"] = 1*6+up
	self.eightStandard["0"] = 1*6+down
	self.eightStandard["-"] = 1*6+punch
	self.eightStandard["="] = 1*6+kick
	
	self.eightStandard["["] = 3*6+punch
	self.eightStandard["]"] = 3*6+kick

	self.eightStandard[";"] = 5*6+down
	self.eightStandard["'"] = 5*6+punch
	self.eightStandard["return"] = 5*6+kick

	self.eightStandard[","] = 7*6+up
	self.eightStandard["."] = 7*6+down
	self.eightStandard["/"] = 7*6+punch



	self.eightWasdPress = {unpack(self.eightStandard)}
	self.eightWasdPress["6"] = 6*6+left
	self.eightWasdPress["z"] = 6*6+right
	self.eightWasdPress["x"] = 6*6+up
	self.eightWasdPress["c"] = 6*6+down
	self.eightWasdPress["v"] = 6*6+punch
	self.eightWasdPress["b"] = 6*6+kick

	self.eightWasdPress["n"] = 7*6+left
	self.eightWasdPress["m"] = 7*6+right
	self.eightWasdPress[","] = 7*6+up
	self.eightWasdPress["."] = 7*6+down
	self.eightWasdPress["/"] = 7*6+punch
	self.eightWasdPress["\\"] = 7*6+kick
	self.eightWasdPress["rshift"] = nil

	self.eightWasdUnpress = {
		f1 = "`", f2 = "1", f3 = "2", f4 = "3", f5 = "4", f6 = "5", f7 = "7",
		f8 = "8", f9 = "9", f10 = "0", f11 = "-", f12 = "=", f13 = "q", f14 = "w",
		f15 = "e", f16 = "r", f17 = "t", f18 = "y", f19 = "u", kp0 = "i", kp1 = "o",
		kp2 = "p", kp3 = "[", kp4 = "]", kp5 = "a", kp6 = "s", kp7 = "d", kp8 = "f",
		kp9 = "g", kpenter = "'", insert = "'", lshift = "6", lctrl = "z", tab = "x",
		up = "c", down = "v", left = "b", right = "n", delete = ",", backspace = ".",
		pagedown = "\\", lalt = "m", pageup = "h", home = "return"
	}
	self.eightWasdUnpress["kp/"] = "h"
	self.eightWasdUnpress["kp*"] = "j"
	self.eightWasdUnpress["kp-"] = "k"
	self.eightWasdUnpress["kp+"] = "l"
	self.eightWasdUnpress["kp."] = ";"
	self.eightWasdUnpress["end"] = "/"

	local leftx = {"right", "left"}
	local lefty = {"down", "up"}
	local rightx = {"lookright", "lookleft"}
	local righty = {"down", "up"}
	local triggerleft = {"kick", ""}
	local triggerright = {"punch", ""}
	local gamepad0 = {leftx = leftx, lefty = lefty, rightx = rightx, righty = righty, triggerleft = triggerleft, triggerright = triggerright}
	leftx = {"right", "left"}
	lefty = {"down", "up"}
	rightx = {"lookright", "lookleft"}
	righty = {"down", "up"}
	triggerleft = {"kick", ""}
	triggerright = {"punch", ""}
	local gamepad1 = {leftx = leftx, lefty = lefty, rightx = rightx, righty = righty, triggerleft = triggerleft, triggerright = triggerright}
	leftx = {"right", "left"}
	lefty = {"down", "up"}
	rightx = {"right", "left"}
	righty = {"down", "up"}
	triggerleft = {"kick", ""}
	triggerright = {"kick", ""}
	local gamepad2 = {leftx = leftx, lefty = lefty, rightx = rightx, righty = righty, triggerleft = triggerleft, triggerright = triggerright}
	self.gamepadAxisToMeaning = {gamepad0, gamepad1, gamepad2}

end

function Keyboard:keyTypeToNum(keyType)
	local convertTable = {left = 1, right = 2, up = 3, down = 4, punch = 5, kick = 6}
	return convertTable[keyType]
end

function Keyboard:keyNumToType(keyNum)
	local convertTable = {"left", "right", "up", "down", "punch", "kick"}
	return convertTable[keyNum]
end

function Keyboard:keyTypeInputNumKeyboard(key, unicode)
	-- returns: keyType, inputNum, press
	local keyValue = 0
	local press = true
	if self.keyboardType == 0 then
		keyValue = self.fourBasic[key]
	elseif self.keyboardType == 1 then
		keyValue = self.eightStandard[key]
	elseif self.keyboardType == 2 then
		-- deal with the pain of eightWasdPress/Unpress
		if self.unpress[key] then
			press = false
			keyValue = self.eightWasdPress[self.eightWasdUnpress[key]]
		else
			keyValue = self.eightWasdPress[key]
		end
	end
	if keyValue == nil then
		return nil, nil, nil
	end
	local keyType = ((keyValue-1) % 6) + 1
	local inputNum = math.floor((keyValue-1)/6)+1
	return keyType, inputNum, press
end

function Keyboard:keypressed(key, unicode)
	-- supports three types of keyboard input. Ow.
	local keyType, inputNum, press = self:keyTypeInputNumKeyboard(key, unicode)
	-- if keyType == 0 then keyType = 6 end
	if inputNum ~= nil and inputNum ~= 0 then
		if self:keyNumToType(keyType) == nil then
			return
		elseif press then
			self.keySets[inputNum][self:keyNumToType(keyType)] = 1
			self:inputPressDistribute(inputNum, self:keyNumToType(keyType), 1)
		else
			-- just to deal with the legacy 4 keyboard system
			self.keySets[inputNum][self:keyNumToType(keyType)] = 0
			self:inputPressDistribute(inputNum, self:keyNumToType(keyType), 0)
		end
	end
end

function Keyboard:keyreleased(key, unicode)
	local inputNum = 0
	local keyValue = ""
	if self.keyboardType == 0 then
		keyValue = self.fourBasic[key]
	elseif self.keyboardType == 1 then
		keyValue = self.eightStandard[key]
	elseif self.keyboardType == 2 then
		return -- since these are handled in keypressed
	end

	if keyValue ~= nil then
		inputNum = math.floor((keyValue-1)/6)+1
		keyType = ((keyValue-1) % 6) + 1
		-- if keyType == 0 then keyType = 6 end
		if inputNum ~= nil and inputNum ~= 0 then
			if self:keyNumToType(keyType) ~= nil then
				self.keySets[inputNum][self:keyNumToType(keyType)] = 0
				self:inputPressDistribute(inputNum, self:keyNumToType(keyType), 0)
			end
		end
	end
end

function Keyboard:isDown(key)
	-- this is old and shouldn't be used anymore
	error("DEPRICATED CALL TO keyboard:isDown!")
	return self.keys[key]
end

function Keyboard:getInputForPlayernum(playerNumber)
	if self.playerMappings[playerNumber] ~= nil then
		return self.playerMappings[playerNumber]
	end
	return 0
end

function Keyboard:keyState(inputNumber, keyType)
	-- local inputNum = self:getInputForPlayernum(playerNumber)
	if inputNumber == 0 then
		return 0
	end
	if self.keySets[inputNumber][keyType] == nil then
		return 0
	end
	return self.keySets[inputNumber][keyType]
end

function Keyboard:getGamepadNumber(gamepad)
	if self.gamepadMappings[gamepad:getID()] ~= nil then
		if self.gamepads[self.gamepadMappings[gamepad:getID()]].gamepad:getID() == gamepad:getID() then
			return self.gamepadMappings[gamepad:getID()], self.gamepads[self.gamepadMappings[gamepad:getID()]].hasGamepad -- it was disconnec
		end
	end
	for k, v in pairs(self.gamepads) do
		if v.gamepad ~= nil and gamepad:getID() == v.gamepad:getID() then
			return k, v.hasGamepad
		end
	end
	return 0, false
end

function Keyboard:gamepadButtonToInputType(inputNum, button)
	local gp = self.gamepads[inputNum - 8]
	if gp.mode == 0 then -- it's one person per Jordan's method
		t = {a = "up", b = "down", x = "punch", y = "kick", leftshoulder = "kick", rightshoulder = "punch", leftstick = "switchdirection",
					back = "back", start = "start", dpleft = "left", dpright = "right", dpup = "up", dpdown = "down"}
	elseif gp.mode == 1 then -- it's Martin's method
		t = {a = "kick", b = "punch", x = "down", y = "up", leftshoulder = "lookleft", rightshoulder = "lookright", leftstick = "switchdirection",
					back = "back", start = "start", dpleft = "left", dpright = "right", dpup = "up", dpdown = "down"}
	elseif gp.mode == 2 then -- it's two players on one gamepad
		local secondHalf = {rightshoulder = true, a = true, b = true, x = true, y = true, rightstick = true}
		-- print("CHECKING IF SECOND STICK")
		-- print(secondHalf[button])
		-- print(button)
		if secondHalf[button] ~= nil then
			inputNum = inputNum + 8 -- it's eight further along...
		end
		t = {rightshoulder = "punch", a = "down", b = "lookright", x = "lookleft", y = "up", leftstick = "switchdirection", back = "back", start = "start",
			leftshoulder = "punch", dpleft = "lookleft", dpright = "lookright", dpup = "up", dpdown = "down", rightstick = "switchdirection"}
	end
	return t[button], inputNum
end

function Keyboard:gamepadButtonToPress(gamepadID, button, pressedValue) -- pressedValue
	local gp = self.gamepads[gamepadID]
	local t = {}
	local inputType, inputNum = self:gamepadButtonToInputType(gamepadID+8, button)
	if inputType == nil then return end
	
	self.keySets[inputNum][inputType] = pressedValue
	self:inputPressDistribute(inputNum, inputType, pressedValue)
	if pressedValue == 1 and (inputType == "back" or inputType == "start") then
		self.game:keypressed(inputType, 0)
	end
end

function Keyboard:joystickadded(gamepad)
	if gamepad:isGamepad() then
		local i, alreadyConnected = self:getGamepadNumber(gamepad)
		if i ~= 0 then
			-- it was connected previously, so reconnect to that inputnumber
			self.gamepads[i].hasGamepad = true
			self.gamepads[i].gamepad = gamepad
			-- print("JOYSTICK RECONNECTED to pos "..i)
			return true
		else
			-- a brand new one
			for i = 1, #self.gamepads do
				if not self.gamepads[i].hasGamepad then
					self.gamepads[i].hasGamepad = true
					self.gamepads[i].gamepad = gamepad
					self.gamepadMappings[gamepad:getID()] = i
					self.gamepads[i].mode = self.defaultJoystickMode
					-- print("JOYSTICK ADDED TO POS "..i)
					return true
				end
			end
		end
	end
	-- print("JOYSTICK FAILED TO BE ADDED")
	return false -- because it didn't work!
end

function Keyboard:joystickremoved(gamepad)
	local i, connected = self:getGamepadNumber(gamepad)
	self:inputPressDistribute(i+8, "disconected", 1) -- for the main joystick
	self:inputPressDistribute(i+16, "disconected", 1) -- in case it's a two person joystick
	if i ~= 0 then
		self.gamepads[i].hasGamepad = false
		-- print("REMOVED JOYSTICK FROM POS "..i)
		return true
	end
	for i = 1, #self.gamepads do
		-- this should never occur, but just in case, this code is here
		-- print(" LOOPING ")
		-- print(gamepad:getID())
		if self.gamepads[i].gamepad ~= nil then
			-- print("ID = "..self.gamepads[i].gamepad:getID())
			if self.gamepads[i].gamepad:getID() == gamepad:getID() then
				self.gamepads[i].hasGamepad = false
				-- print("JOYSTICK REMOVED FROM POS THROUGH PAIN "..i)
				return true
			end
		end
	end
	-- print("JOYSTICK FAILED TO BE REMOVED")
	return false -- because it didn't work!
end

function Keyboard:gamepadpressed(gamepad, button)
	local gamepadID, connected = self:getGamepadNumber(gamepad)
	if gamepadId == 0 then return end -- since it doesn't exist.
	-- print("JOYSTICK PRESSED "..button)
	self:gamepadButtonToPress(gamepadID, button, 1)
end

function Keyboard:gamepadreleased(gamepad, button)
	local gamepadID, connected = self:getGamepadNumber(gamepad)
	if gamepadId == 0 then return end -- since it doesn't exist.
	-- print("JOYSTICK RELEASED "..button)
	self:gamepadButtonToPress(gamepadID, button, 0)
end

function Keyboard:inputPressDistribute(inputNum, keyType, pressValue)
	if self.mainmenuSubscribed then
		self.game.mainMenu:inputMade(inputNum, keyType, pressValue)
	elseif self.settingsMenuSubscribed then
		self.game.settingsMenu:inputMade(inputNum, keyType, pressValue)
	elseif self.controlsMenuSubscribed then
		self.game.controlsMenu:inputMade(inputNum, keyType, pressValue)
	end
end

function Keyboard:gamepadaxis(gamepad, axis, value)
	local gamepadNum, connected = self:getGamepadNumber(gamepad)
	if gamepadNum == 0 then return end
	local inputNum = gamepadNum + 8
	local onValue = ""
	local offValue = ""
	if self.gamepads[gamepadNum].mode == 2 then
		if axis == "rightx" or axis == "righty" or axis == "triggerright" then
			inputNum = inputNum + 8
		end
		onValue = self.gamepadAxisToMeaning[3][axis][1]
		offValue = self.gamepadAxisToMeaning[3][axis][2]
	elseif self.gamepads[gamepadNum].mode == 1 then
		onValue = self.gamepadAxisToMeaning[2][axis][1]
		offValue = self.gamepadAxisToMeaning[2][axis][2]
	elseif self.gamepads[gamepadNum].mode == 0 then
		onValue = self.gamepadAxisToMeaning[1][axis][1]
		offValue = self.gamepadAxisToMeaning[1][axis][2]
	end
	if math.abs(value) < self.joystickDeadZone then
		value = 0
	end
	
	if value < 0 then
		if self.gamepads[gamepadNum].debounce[axis] >= 0 then
			self.gamepads[gamepadNum].debounce[axis] = -1 -- larger than 0
			if offValue ~= "" then
				self:inputPressDistribute(inputNum, "menu"..offValue, 1)
			end
			-- if axis == "lefty" or axis == "righty" then
			-- 	self:inputPressDistribute(inputNum, "menuup", 1)
			-- else -- it's leftx or rightx, since triggers can't be negative.
			-- 	self:inputPressDistribute(inputNum, "menuleft", 1)
			-- end
		end
	elseif value > 0 then
		if self.gamepads[gamepadNum].debounce[axis] <= 0 then
			self.gamepads[gamepadNum].debounce[axis] = 1 -- larger than 0
			if onValue ~= "" then
				self:inputPressDistribute(inputNum, "menu"..onValue, 1)
			end
			-- if axis == "lefty" or axis == "righty" then
			-- 	self:inputPressDistribute(inputNum, "menuup", 1)
			-- elseif axis == "leftx" or axis == "rightx" then
			-- 	self:inputPressDistribute(inputNum, "menuleft", 1)
			-- elseif axis == "triggerleft" then -- then it's triggers. Welp.
			-- 	self:inputPressDistribute(inputNum, "punch", 1)
			-- elseif axis == "triggerright" then
			-- 	self:inputPressDistribute(inputNum, "kick", 1)
			-- end
		end
	else
		self.gamepads[gamepadNum].debounce[axis] = 0
	end

	if value > 0 then
		if onValue ~= "" then
			self.keySets[inputNum][onValue] = math.abs(value)
		end
		if offValue ~= "" then
			self.keySets[inputNum][offValue] = 0
		end
	else
		if onValue ~= "" then
			self.keySets[inputNum][onValue] = 0
		end
		if offValue ~= "" then
			self.keySets[inputNum][offValue] = math.abs(value)
		end
	end
end


