require "class"

Item = class()

--TUNE ALL OF THESE VALUES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function Item:_init(itemType, x, y, dX, dY)
	self.x = x
	self.y = y 
	self.width = 70
	self.height = 70
	self.itemType = itemType
	self.dx = dX*300
	self.dy = dY*50
	
	self.image = love.graphics.newImage('images/health-item.png')

	if self.itemType == "knife" then
		self.image = love.graphics.newImage('images/knife-item.png')
	end
	
end

function Item:update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
	if math.random(1,15)==1 then
		self.dy = -self.dy
	end
	if math.random(1,300)==1 then
		self.dx = -self.dx
	end
end

function Item:draw()
	love.graphics.draw(self.image, self.x, self.y, 0, self.direction, 1)
end