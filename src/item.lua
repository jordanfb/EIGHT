require "class"

Item = class()

--TUNE ALL OF THESE VALUES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function Item:_init(itemType, x, y, dX, dY, game)
	self.x = x
	self.y = y 
	self.width = 70
	self.height = 70
	self.itemType = itemType
	self.dx = dX*300
	self.dy = dY*50

	self.game = game
	
	self.image = nil --love.graphics.newImage('images/health-item.png')
	if self.itemType == "knife" then
		self.image = self.game.knifeItemImage
	elseif self.itemType == "health" then
		self.image = self.game.healthItemImage
	elseif self.itemType == "jump" then
		self.image = self.game.jumpItemImage
	elseif self.itemType == "speed" then
		self.image = self.game.speedItemImage
	elseif self.itemType == "platform" then
		self.image = self.game.platformItemImage
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