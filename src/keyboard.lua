

require "class"

Keyboard = class()




function Keyboard:_init()
	self.keys = {}
end


function Keyboard:keypressed(key, unicode)
	self.keys[key] = true
end

function Keyboard:keyreleased(key, unicode)
	self.keys[key] = false
end

function Keyboard:isDown(key)
	return self.keys[key]
end