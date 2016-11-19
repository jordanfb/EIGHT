

require "class"

Keyboard = class()




function Keyboard:_init()
	self.keys = {}
	self.wasd = true
	self.mode = true
end


function Keyboard:keypressed(key, unicode)
	if not self.wasd then
		self.keys[key] = true
	else -- deal with the pain
		if key == "space" then
			self.mode = false -- not pressed
		else -- I think it only sends it once when it's released, so we save more keys this way.
			self.keys[key] = self.mode
			self.mode = true
		end
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