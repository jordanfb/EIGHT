require "class"

Keyboard = class()




function Keyboard:_init()
	self.keyboardType = 0 -- 0 = max four on keyboard, 1 = all eight on one keyboard, 2 = all eight on wasd

	self.playerMappings = {} -- a table of playernum to inputnum

	self.keySets = {}
	for i = 1, 16 do -- make 8 for keyboards, then 8 for joysticks
		self.keySets[i] = {}
	end

	local left = 1
	local right = 2
	local up = 3
	local down = 4
	local punch = 5
	local kick = 6
	self.fourBasic = {
		w = 0*6+left, d = 0*6+right, w = 0*6+up, s = 0*6+down, c = 0*6+punch, v = 0*6+kick,
		f = 1*6+left, h = 1*6+right, t = 1*6+up, g = 1*6+down, n = 1*6+punch, m = 1*6+kick,
		j = 2*6+left, l = 2*6+right, i = 2*6+up, k = 2*6+down
	}
	self.fourBasic[","] = 2*6+punch
	self.fourBasic["."] = 2*6+kick


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
end

function Keyboard:keyTypeToNum(keyType)
	local convertTable = {left = 1, right = 2, up = 3, down = 4, punch = 5, kick = 6}
	return convertTable[keyType]
end

function Keyboard:keyNumToType(keyNum)
	local convertTable = {"left", "right", "up", "down", "punch", "kick"}
	return convertTable[keyNum]
end

function Keyboard:keypressed(key, unicode)
	-- supports three types of keyboard input. Ow.
	local inputNum = 0
	local keyType = 0
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

	if keyValue ~= nil then
		inputNum = math.floor(keyValue/6)+1
		keyType = keyValue % 6
		if inputNum ~= nil and inputNum ~= 0 then
			if press then
				self.keySets[inputNum][self:keyNumToType(keyType)] = 1
			else
				-- just to deal with the legacy 4 keyboard system
				self.keySets[inputNum][self:keyNumToType(keyType)] = 0
			end
		end
	end
end

function Keyboard:keyreleased(key, unicode)
	if self.keyboardType == 0 then
		keyValue = self.fourBasic[key]
	elseif self.keyboardType == 1 then
		keyValue = self.eightStandard[key]
	elseif self.keyboardType == 2 then
		return -- since these are handled in keypressed
	end

	if keyValue ~= nil then
		inputNum = math.floor(keyValue/6)+1
		keyType = keyValue % 6
		if inputNum ~= nil and inputNum ~= 0 then
			self.keySets[inputNum][self:keyNumToType(keyType)] = 0
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

function Keyboard:keyState(playerNumber, keyType)
	local inputNum = self:getInputForPlayernum(playerNumber)
	if inputNum == 0 then
		return 0
	end
	if self.keySets[inputNum][keyType] == nil then
		return 0
	end
	return self.keySets[inputNum][keyType]
end




