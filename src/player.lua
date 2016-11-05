

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
	self.runAnim = 1
	self.hitAnim = 1
	self.kickAnim = 1
	self.runanim = 1
	self.onGround = false
	self.onPlatform = false
	
	self.attackTimer = 0
	self.attackType = 0
	self.coolDown = 0
	self.isAttacking = false
	
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

	self.health = 100

	-- animations:
	-- punch, kick jump, duck, walking,
	self:loadImages()
	self.SCREENWIDTH = love.graphics.getWidth()
	self.SCREENHEIGHT = love.graphics.getHeight()

	self.switchedDirections = false
end

function Player:resize(screenWidth, screenHeight)
	self.SCREENWIDTH = screenWidth
	self.SCREENHEIGHT = screenHeight
end

function Player:loadImages()

	-- load the correct images by appending things to the default filename
	self.breathImages = {  }
	for i = 1, 4, 1 do
		self.breathImages[i] = love.graphics.newImage('images/'..(self.color%4+1)..'-breath-'..i..'.png')
	end 
	
	self.runImages = {}
	for i = 1, 6, 1 do
		self.runImages[i] = love.graphics.newImage('images/'..(self.color%4+1)..'-run-'..i..'.png')
	end
	
	self.hitImages = {}
	for i = 1, 4, 1 do
		self.hitImages[i] = love.graphics.newImage('images/'..(self.color%4+1)..'-hit-'..i..'.png')
	end
	
	self.kickImages = {}
	for i = 1, 5, 1 do
		self.kickImages[i] = love.graphics.newImage('images/'..(self.color%4+1)..'-kick-'..i..'.png')
	end
	
	self.duckImage = love.graphics.newImage('images/'..(self.color%4+1)..'-duck-1.png')
	
	self.jumpImage = love.graphics.newImage('images/'..(self.color%4+1)..'-jump.png')
	
	self.pImage = love.graphics.newImage('images/'..(self.color+1)..'-p.png')
	
end

function Player:draw()
	--
	love.graphics.draw(self.pImage, self.x + 30, self.y - 100)
	
	--love.graphics.setColor(0, 255, 0)
	--love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	local addX = 0
	if self.facing == -1 then
		addX = self.width
	end
	if not self.onGround then
		love.graphics.draw(self.jumpImage, self.x+addX, self.y, 0, self.facing, 1)
	elseif self.keyboard:isDown(self.DOWNKEY) and self.dx==0 then
		love.graphics.draw(self.duckImage, self.x+addX, self.y, 0, self.facing, 1)
	elseif self.attackTimer > 0 then
	
		if self.attackType==1 then
			if self.attackTimer < 20 then
				love.graphics.draw(self.hitImages[math.ceil(self.attackTimer/5)], self.x+addX, self.y, 0, self.facing, 1)
			else
				love.graphics.draw(self.hitImages[4], self.x+addX, self.y, 0, self.facing, 1)
			end
		else
			if self.attackTimer < 20 then
				love.graphics.draw(self.kickImages[math.ceil(self.attackTimer/5)], self.x+addX, self.y, 0, self.facing, 1)
			else
				love.graphics.draw(self.kickImages[5], self.x+addX, self.y, 0, self.facing, 1)
			end
		end
		
	
	
	elseif self.dx == 0 then
		love.graphics.draw(self.breathImages[math.ceil(self.anim/10)], self.x+addX, self.y, 0, self.facing, 1)
	elseif self.dx ~= 0 then
		-- then run!
		love.graphics.draw(self.runImages[math.ceil(self.runAnim/5)], self.x+addX, self.y, 0, self.facing, 1)
	end
	
	if self.color==0 then
		love.graphics.print(self.attackTimer, 100, 100)
	end
	
end


function Player:update(dt)
	local dx = 0
	if (self.keyboard:isDown(self.LEFTKEY)) and self.attackTimer==0 then
		dx = -1
	end
	if (self.keyboard:isDown(self.RIGHTKEY)) and self.attackTimer==0 then
		dx = dx + 1
	end

	-- check for switching directions:
	if self.keyboard:isDown(self.LEFTKEY) and self.keyboard:isDown(self.RIGHTKEY) and self.attackTimer==0 then
		if not self.switchedDirections then
			self.facing = -self.facing
			self.switchedDirections = true
			-- self.x = self.x + self.width
			-- self.width = -self.width
		end
	else
		self.switchedDirections = false
	end

	self.dx = dx
	self.dy = self.dy + self.ay

	self.onGround = false
	self.onPlatform = false

	if (self.x + self.width >= self.SCREENWIDTH) then
		self.x = self.SCREENWIDTH - self.width
	elseif (self.x < 0) then
		self.x = 0
	end
	if (self.y + self.height >= self.SCREENHEIGHT) then
		self.y = self.SCREENHEIGHT - self.height
		self.onGround = true
		self.dy = 0
	end
	-- then check platforms of level
	

	if self.dy >= 0 and not self.keyboard:isDown(self.DOWNKEY) then
		local change = self.level:downCollision(self.x, self.y, self.width, self.height, self.dy*dt)
		if change[2] then
			self.onGround = true
			self.onPlatform = true
			self.y = change[1]
		end
	-- elseif self.dy == 0 then
	-- 	if (self.dx < 0) then
	-- 		self.x = self.level:leftCollision(self.x, self.y, self.width, self.height)
	-- 	elseif (self.dx > 0) then
	-- 		self.x = self.level:rightCollision(self.x, self.y, self.width, self.height)
	-- 	end
	end

	--ATTACKS	----------------------------------------------------
	
	if self.keyboard:isDown(self.PUNCHKEY) and self.attackTimer == 0 and self.onGround and self.dx==0  and self.coolDown == 0 then
		self.attackType = 1
		self.attackTimer = 1
		self.isAttacking = true
	elseif self.keyboard:isDown(self.KICKKEY) and self.attackTimer == 0 and self.onGround and self.dx==0  and self.coolDown == 0 then
		self.attackType = 2
		self.attackTimer = 1
		self.isAttacking = true
	elseif ( not self.keyboard:isDown(self.PUNCHKEY) and not self.keyboard:isDown(self.KICKKEY) ) or self.attackTimer==25 then
		self.isAttacking = false
		if self.keyboard:isDown(self.PUNCHKEY) then
			if self.facing==1 then
				self.level.attacks:newAttack(self.x+100, self.y+20, 90, 90, self.color, 10, self.facing, 20)
			else
				self.level.attacks:newAttack(self.x-50, self.y+20, 90, 90, self.color, 	10, self.facing, 20)
			end
			self.coolDown = 50
		elseif self.keyboard:isDown(self.KICKKEY) then
			if self.facing==1 then
				self.level.attacks:newAttack(self.x+100, self.y+20, 90, 90, self.color, 25, self.facing, 20)
			else
				self.level.attacks:newAttack(self.x-50, self.y+20, 90, 90, self.color, 25, self.facing, 20)
			end
			self.coolDown = 50
		end
	end
	
	
	if self.isAttacking and self.attackTimer < 150 then
		self.attackTimer = self.attackTimer + 2/self.attackType
	elseif self.attackTimer >= 150 then
		self.attackTimer = 20
		self.isAttacking = false
	elseif not self.isAttacking  then
		self.attackTimer = self.attackTimer - 2/self.attackType
	elseif not self.isAttacking then
		self.attackTimer = 20
	end
	
	if self.attackTimer < 0 then
		self.attackTimer = 0
	elseif self.attackTimer > 25 then
		self.attackTimer = 24
	end
		
	if self.coolDown > 0 then
		self.coolDown = self.coolDown - 1
	end
	
	--if self.isAttacking
	--
	----------------------------------------------------
	
	
	if self.onGround then
		self.ay = 0
		self.dy = 0
	else
		self.ay = 40
		if self.keyboard:isDown(self.DOWNKEY) then
			self.ay = 80
		end
	end

	self.x = self.x + self.dx * dt * self.moveSpeed
	self.y = self.y + self.dy * dt

	-- then jump?

	if self.onGround and self.keyboard:isDown(self.UPKEY) and self.attackTimer==0 then
		self.dy = -1000
		self.onGround = false
		self.onPlatform = false
		self.y = self.y - 1
	end
	
	--animations
	self.anim = self.anim%40 + 1
	self.runAnim = self.runAnim%30 + 1
	
	if self.dx==0 then
		self.runAnim = 1
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
