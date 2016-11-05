

require "class"

Player = class()



function Player:_init(x, y, LEFTKEY, RIGHTKEY, UPKEY, DOWNKEY, PUNCHKEY, KICKKEY, color)
	self.moveSpeed = 500

	self.x = x
	self.y = y
	self.dx = 0
	self.dy = 0
	self.ay = 1
	self.facing = 1 -- 1 = right, -1 = left
	self.onGround = false

	self.color = color
	self:loadImages()
	self.width = 100
	self.height = 130

	self.LEFTKEY = LEFTKEY
	self.RIGHTKEY = RIGHTKEY
	self.UPKEY = UPKEY
	self.PUNCHKEY = PUNCHKEY
	self.KICKKEY = KICKKEY

	-- animations:
	-- punch, kick jump, duck, walking,
end

function Player:loadImages()
	-- load the correct images by appending things to the default filename
end


function Player:draw()
	--
	love.graphics.setColor(0, 255, 0)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end


function Player:update(dt)
	local dx = 0
	if (love.keyboard.isDown(self.LEFTKEY)) then
		dx = -1
	end
	if (love.keyboard.isDown(self.RIGHTKEY)) then
		dx = dx + 1
	end

	self.dx = dx
	self.dy = self.dy + self.ay

	self.x = self.x + self.dx * dt * self.moveSpeed
	self.y = self.y + self.dy * dt

	if (self.x + self.width >= love.graphics.getWidth()) then
		self.x = love.graphics.getWidth() - self.width
	elseif (self.x < 0) then
		self.x = 0
	end
	if (self.y + self.height > love.graphics.getHeight()) then
		self.y = love.graphics.getHeight() - self.height
		self.onGround = true
	end
	-- then check platforms of level

	if self.onGround then
		self.ay = 0
		self.dy = 0
	else
		self.ay = 9.8
	end

	-- then jump?

	if (self.onGround and love.keyboard.isDown(self.UPKEY)) then
		self.dy = -500
		self.onGround = false
	end

end


function Player:isColliding(x, y, width, height)
	if (x > self.x + self.width or x + width < self.x) then
		return false -- not colliding on X axis
	end
	if (y > self.y+self.height or y + height < self.y) then
		return false -- not colliding on Y axis
	end
	return true -- coliding
end
