

require "class"

Keyboard = class()




function Keyboard:_init()
	self.keys = {}
end


function Keyboard:keypressed(key, unicode)
	self.keys[unicode] = true
end

function Keyboard:keyreleased(key, unicode)
	self.keys[unicode] = false
end

function Keyboard.isDown(unicode)
	return self.keys[unicode]
end