

require "class"

Player = class()



function Player:_init(x, y, color, LEFTKEY, RIGHTKEY, UPKEY, PUNCHKEY, KICKKEY)
	self.x = x
	self.y = y
	self.color = color
	self:loadImages()

	self.LEFTKEY = LEFTKEY
	self.RIGHTKEY = RIGHTKEY
	self.UPKEY = UPKEY
	self.PUNCHKEY = PUNCHKEY
	self.KICKKEY = KICKKEY

	-- animations:
	-- punch, kick jump, duck, walking,
end

function loadImages()
	-- load the correct images by appending things to the default filename
end


function Player:draw()
	--
end


function Player:update()
	--
end