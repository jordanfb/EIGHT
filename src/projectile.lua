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

function Projectile:update(dt)
	self.x = self.x + self.dx * dt
	if self.x < 0 or self.x > love.graphics.getWidth() then
		self.ded = true
	end
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