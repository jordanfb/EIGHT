require "class"

Keyboard = class()




function Keyboard:_init()
	self.keys = {}
	self.wasd = false
	self.mode = true
	self.unpress = {
		f1 = "`",
		f2 = "1",
		f3 = "2",
		f4 = "3",
		f5 = "4",
		f6 = "5",
		f7 = "7",
		f8 = "8",
		f9 = "9",
		f10 = "0",
		f11 = "-",
		f12 = "=",
		f13 = "q",
		f14 = "w",
		f15 = "e",
		f16 = "r",
		f17 = "t",
		f18 = "y",
		f19 = "u",
		kp0 = "i",
		kp1 = "o",
		kp2 = "p",
		kp3 = "[",
		kp4 = "]",
		kp5 = "a",
		kp6 = "s",
		kp7 = "d",
		kp8 = "f",
		kp9 = "g",
		-- kp* = "",
		-- kp- = "",
		-- kp+ = "",
		kpenter = "'",
		-- kp. = "",
		insert = "'",







		lshift = "6",
		lctrl = "z",
		tab = "x",
		up = "c",
		down = "v",
		left = "b",
		right = "n",
		delete = ",",
		backspace = ".",
		pagedown = "\\",
		lalt = "m",
		pageup = "h",
		home = "return"


	}
	self.unpress["kp/"] = "h"
	self.unpress["kp*"] = "j"
	self.unpress["kp-"] = "k"
	self.unpress["kp+"] = "l"
	self.unpress["kp."] = ";"
	self.unpress["end"] = "/"

end


function Keyboard:keypressed(key, unicode)
	-- print("KEYPRESSED:"..key.."UNICODE"..unicode)
	if not self.wasd then
		self.keys[key] = true
	else -- deal with the pain
		if self.unpress[key] then
			self.keys[self.unpress[key]] = false
		else
			self.keys[key] = true
		end
		-- if key == "space" then
		-- 	self.mode = false -- not pressed
		-- else -- I think it only sends it1 once when it's released, so we save more keys this way.
		-- 	self.keys[key] = self.mode
		-- 	self.mode = true
		-- end
	end
end

function Keyboard:keyreleased(key, unicode)
	if not self.wasd then
		self.keys[key] = false
	else -- deal with the pain, but don't since screw releases.
		--
	end
end

function Keyboard:isDown(key)
	return self.keys[key]
end