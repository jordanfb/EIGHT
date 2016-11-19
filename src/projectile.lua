require "class"

Projectile = class()

--TUNE ALL OF THESE VALUES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function Projectile:_init(type, x, y, direction)
	self.fireballDX = 10
	self.knifeDX = 15
	self.fireballDamage = 30
	self.knifeDamage = 30
	self.x = x
	self.y = y 
	self.type = type
	self.ded = false
	self.direction = direction
	self.dx = 0
	self.damage = 0

	if self.type == "fireball" then
		if direction ==  1 then
			self.dx = self.fireballDX
		else
			self.dx = -1 * self.fireballDX
		end 
		self.damage = self.fireballDamage
	
	elseif self.type == "knife" then
		if direction ==  1 then
			self.dx = self.knifeDX
		else
			self.dx = -1 * self.knifeDX
		end 
		self.damage = self.knifeDamage
	end
	
	self.images = {love.graphics.newImage('images/fireball-1.png'),
				   love.graphics.newImage('images/fireball-2.png')}
end

function Projectile:update(dt)
	self.x = self.x + self.dx * dt
	if self.x < 0 or self.x > love.graphics.getWidth() then
		self.ded = true
	end
end

function Projectile:draw()
	error(1)
	love.graphics.draw(self.images[1], self.x, self.y)--, 0, self.direction, 1)
end

function Projectile:checkCollisions(player, playerX, playerY, playerWidth, playerHeight)
	if self.x > playerX and self.x < playerX + playerWidth then
		if self.y > playerY and self.y < playerY + playerHeight then
			player.health = player.health - self.damage
			if self.type == "knife" then
				self.ded = true
			end
		end
	end
end

function isDead( )
	return self.ded
end