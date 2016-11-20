require "class"

Projectile = class()

--TUNE ALL OF THESE VALUES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function Projectile:_init(projectType, x, y, direction, color)
	self.x = x
	self.y = y 
	self.width = 30
	self.height = 10
	self.projectType = projectType
	self.ded = false
	self.direction = direction
	self.dx = 0
	self.damage = 0
	self.animation = 0
	self.color = color

	if self.projectType == "fireball" then
		self.dx = 2000 * direction
		self.damage = 30
		self.width = 30
		self.height = 30
	
	elseif self.projectType == "knife" then
		self.dx = 1500 * direction
		self.damage = 10
		self.width = 30
		self.height = 10
	end

	self.fireBallImages = {love.graphics.newImage('images/fireball-1.png'),
						   love.graphics.newImage('images/fireball-2.png')}
				   
	self.knifeImage = love.graphics.newImage('images/knife.png')
end

function Projectile:update(dt)
	self.x = self.x + self.dx * dt
	self.animation = self.animation + 1
end

function Projectile:draw()
		love.graphics.draw(self.knifeImage, self.x, self.y, 0, self.direction, 1)

--[[
	if self.animation%2==0 then
		love.graphics.draw(self.images[1], self.x, self.y, 0, self.direction, 1)
	else
		love.graphics.draw(self.images[2], self.x, self.y, 0, self.direction, 1)
	end
]]--
end