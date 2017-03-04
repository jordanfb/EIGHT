require "class"

Item = class()

--TUNE ALL OF THESE VALUES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function sign(v)
	if v==0 then
		return 0
	elseif v > 0 then
		return 1
	else
		return -1
	end
end
		

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
	
	self.animation = 1
	
	self.image = self.game.batImages
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
	elseif self.itemType == "bat" then
		self.image = self.game.batImages
		self.width = 90
		self.attacks = {}
		for i = 1, 8 do
			self.attacks[i] = 0
		end
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
	if self.itemType == "bat" then
		self.animation = (self.animation + .1)%4
		for i, player in pairs(self.game.level.players) do
			if player.x < self.x + self.width and player.x + player.width > self.x then	
				if player.y < self.y + self.height and player.y + player.height > self.y and self.attacks[player.playerNumber] <= 0 and player.health > 0 then
					self.game:startScreenshake(.15, 5)
					player.health = math.max(player.health - 10, 0)
					if self.game.gameSettings.instantKill then
						player.health = 0
						self.game:startScreenshake(.25, 10)
					end
					player.attackedTimer = 10
					self.attacks[player.playerNumber] = 50
				end
			end
		end
		for i, knife in ipairs(self.game.level.projectiles) do
			if knife.x < self.x + self.width and knife.x + knife.width > self.x then	
				if knife.y < self.y + self.height and knife.y + knife.height > self.y then
					self.dead = true
				end
			end
		end
		for i, v in pairs(self.attacks) do
			if v > 0 then
				self.attacks[i] = v - 1
			end
		end
	end
end

function Item:draw()
	if self.itemType == "bat" then
		local addX = 0
		if sign(self.dx) == 1 then
			addX = self.width
		end
		love.graphics.draw(self.image[math.floor(self.animation)+1], self.x + addX, self.y, 0, -sign(self.dx), 1)
	else
		love.graphics.draw(self.image, self.x, self.y, 0, self.direction, 1)
	end
end