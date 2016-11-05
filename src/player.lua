

require "class"

Player = class()



function Player:_init(level, keyboard, x, y, LEFTKEY, RIGHTKEY, UPKEY, DOWNKEY, PUNCHKEY, KICKKEY, color)
	self.level = level
	self.keyboard = keyboard
	self.moveSpeed = 500
	self.x = x
	self.y = y
	self.dx = 0
	self.dy = 0
	self.ay = 1
	self.facing = 1 -- 1 = right, -1 = left
	self.anim = 1
	self.onGround = false
	
	self.color = color
	self:loadImages()
	self.width = 100
	self.height = 150

	self.LEFTKEY = LEFTKEY
	self.RIGHTKEY = RIGHTKEY
	self.UPKEY = UPKEY
	self.DOWNKEY = DOWNKEY
	self.PUNCHKEY = PUNCHKEY
	self.KICKKEY = KICKKEY

	-- animations:
	-- punch, kick jump, duck, walking,
	self:loadImages()
	self.SCREENWIDTH = love.graphics.getWidth()
	self.SCREENHEIGHT = love.graphics.getHeight()
end

function Player:resize(screenWidth, screenHeight)
	self.SCREENWIDTH = screenWidth
	self.SCREENHEIGHT = screenHeight
end

function Player:loadImages()

	-- load the correct images by appending things to the default filename
	self.breathImages = {  }
	for i = 1, 4, 1 do
		self.breathImages[i] = love.graphics.newImage('images/'..self.color..'-breath-'..i..'.png')
	end 
	
	self.runImages = {}
	for i = 1, 6, 1 do
		self.runImages[i] = love.graphics.newImage('images/'..self.color..'-run-'..i..'.png')
	end
	
	self.hitImages = {}
	for i = 1, 4, 1 do
		self.hitImages[i] = love.graphics.newImage('images/'..self.color..'-hit-'..i..'.png')
	end
	
	self.kickImages = {}
	for i = 1, 5, 1 do
		self.kickImages[i] = love.graphics.newImage('images/'..self.color..'-kick-'..i..'.png')
	end
	
	self.duckImages = {}
	for i = 1, 6, 1 do
		self.duckImages[i] = love.graphics.newImage('images/'..self.color..'-duck-'..i..'.png')
	end
	
	self.jumpImage = love.graphics.newImage('images/'..self.color..'-jump.png')
	
end

function Player:draw()
	--
	--love.graphics.setColor(0, 255, 0)
	--love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	
	love.graphics.draw(self.breathImages[math.ceil(self.anim/10)], self.x, self.y, 0, self.facing, 1)
	
end


function Player:update(dt)
	local dx = 0
	if (self.keyboard:isDown(self.LEFTKEY)) then
		dx = -1
	end
	if (self.keyboard:isDown(self.RIGHTKEY)) then
		dx = dx + 1
	end

	self.dx = dx
	self.dy = self.dy + self.ay

	self.x = self.x + self.dx * dt * self.moveSpeed
	self.y = self.y + self.dy * dt

	self.onGround = false

	if (self.x + self.width >= self.SCREENWIDTH) then
		self.x = self.SCREENWIDTH - self.width
	elseif (self.x < 0) then
		self.x = 0
	end
	if not self.onGround and (self.y + self.height > self.SCREENHEIGHT) then
		self.y = self.SCREENHEIGHT - self.height
		self.onGround = true
		self.dy = 0
	end
	-- then check platforms of level
	

	if self.dy > 0 then
		local change = self.level:downCollision(self.x, self.y, self.width, self.height)
		if change ~= self.y then
			self.onGround = true
			self.y = change
		end
	-- elseif self.dy == 0 then
	-- 	if (self.dx < 0) then
	-- 		self.x = self.level:leftCollision(self.x, self.y, self.width, self.height)
	-- 	elseif (self.dx > 0) then
	-- 		self.x = self.level:rightCollision(self.x, self.y, self.width, self.height)
	-- 	end
	end

	if self.onGround then
		self.ay = 0
		self.dy = 0
	else
		self.ay = 40
	end

	-- then jump?

	if (self.onGround) then
		if self.keyboard:isDown(self.UPKEY) then
			self.dy = -1000
			self.onGround = false
		elseif self.keyboard:isDown(self.DOWNKEY) then
			self.dy = 100
			self.onGround = false
		end
	end
	--animations
	self.anim = self.anim%40 + 1

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
