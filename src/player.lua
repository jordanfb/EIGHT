require "class"

Player = class()



function Player:_init(level, keyboard, x, y, playerNumber, color)
	self.level = level
	self.keyboard = keyboard
	self.moveSpeed = 500
	self.x = x
	self.y = y
	self.dx = 0
	self.dy = 0
	self.ay = 1
	self.facing = 1 -- 1 = right, -1 = left
	self.numKnives = 0
	self.superJumps = 0
	self.speedUp = 0
	self.jumpForce = -1000
	
	self.attackSpeed = 2
	self.coolDownSpeed = 1
	--self.airTime = 0
	
	self.anim = 1
	self.runAnim = 1
	self.hitAnim = 1
	self.kickAnim = 1
	
	self.onGround = false
	self.onPlatform = false
	
	self.attackTimer = 0
	self.attackedTimer = 0
	self.attackType = 0
	self.coolDown = 0
	self.isAttacking = false

	self.color = color
	self.colorTable = {{255, 255, 255}, {0, 0, 0}, {255, 255, 255}, {0, 255, 0}}
	self:loadImages()
	self.width = 100
	self.height = 150

	self.playerNumber = playerNumber
	self.inputNumber = playerNumber % 4

	self.health = 100
	self.dead = false

	-- animations:
	-- punch, kick jump, duck, walking,
	self:loadImages()
	self.SCREENWIDTH = 1920
	self.SCREENHEIGHT = 1080

	self.switchedDirections = false
end

function Player:resize(screenWidth, screenHeight)
	-- self.SCREENWIDTH = screenWidth
	-- self.SCREENHEIGHT = screenHeight
	self.SCREENWIDTH = 1920
	self.SCREENHEIGHT = 1080
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
	if self.health <= 0 then
		return
	end
		
	love.graphics.setColor(self.colorTable[self.color % 4 + 1])
	love.graphics.draw(self.pImage, self.x + 30, self.y - 100)
	love.graphics.setColor(255, 255, 255, 255)
	
	if self.attackedTimer > 0 then
		love.graphics.setColor(255, 0, 0)
	elseif self.speedUp > 0 then
		love.graphics.setColor(255, 155, 255)
	end
	
	--love.graphics.setColor(0, 255, 0)
	--love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	local addX = 0
	if self.facing == -1 then
		addX = self.width
	end
	if self.attackTimer > 0 then
	
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
	elseif not self.onPlatform then
		love.graphics.draw(self.jumpImage, self.x+addX, self.y, 0, self.facing, 1)
	elseif (self.keyboard:keyState(self.inputNumber, "down") > 0) and self.dx==0 then
		love.graphics.draw(self.duckImage, self.x+addX, self.y, 0, self.facing, 1)
	elseif self.dx == 0 then
		love.graphics.draw(self.breathImages[math.ceil(self.anim/10)], self.x+addX, self.y, 0, self.facing, 1)
	elseif self.dx ~= 0 then
		-- then run!
		love.graphics.draw(self.runImages[math.ceil(self.runAnim/5)], self.x+addX, self.y, 0, self.facing, 1)
	end
	
	love.graphics.setColor(255, 255, 255)
end

function Player:onPlayerDeath()
	self.level.game:startScreenshake(.5, 10)
	self.level.numPlayersAlive = self.level.numPlayersAlive - 1
	self.level:playerDied()
end

function Player:update(dt)

	if self.speedUp > 0 then
		self.moveSpeed = 750
		self.coolDownSpeed = 2
		self.speedUp = self.speedUp - 1
	else 
		self.moveSpeed = 500
		self.coolDownSpeed = 1
	end


	if self.health == 0 and not self.dead then
		self.dead = true
		-- CAUSE EXCITEMENT TO HAPPEN!
		self:onPlayerDeath()
	end
	if self.health < 0 then
		self.health = 0
		return
	end
	if self.health == 0 then
		return
	end

	local leftMove = 0
	local rightMove = 0
	if self.attackTimer==0 then
		leftMove = self.keyboard:keyState(self.inputNumber, "left")
		rightMove = self.keyboard:keyState(self.inputNumber, "right")
	end
	local dx = rightMove - leftMove

	-- check for switching directions:
	--self.keyboard:keyState(self.inputNumber, "swapdirections") > 0
	if ((leftMove > 0 and rightMove > 0) or self.keyboard:keyState(self.inputNumber, "switchdirection") > 0) and self.attackTimer==0 then
		if not self.switchedDirections then
			self.facing = -self.facing
			self.switchedDirections = true
			-- self.x = self.x + self.width
			-- self.width = -self.width
		end
	else
		self.switchedDirections = false
	end
	if self.keyboard:keyState(self.inputNumber, "lookleft") > 0 and self.attackTimer==0 then
		self.facing = -1
	elseif self.keyboard:keyState(self.inputNumber, "lookright") > 0 and self.attackTimer==0 then
		self.facing = 1
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
	if (self.y >= self.SCREENHEIGHT) then
		self.y = -100
		self.dx = 0
		self.dy = 0
		if self.level.game.gameSettings.takeFallingOutOfWorldDamage then
			self.health = math.max(self.health - self.level.game.gameSettingRates.fallingOutOfWorldDamage, 0)
		end
		self.attackedTimer = 50
	end
	-- then check platforms of level
	

	if self.dy >= 0 then
		-- and not (self.keyboard:keyState(self.inputNumber, "down") > 0)
		local change = self.level:downCollision(self.x, self.y, self.width, self.height, self.dy*dt)
		if change[2] then
			if change[3] then
				self.onGround = change[3]
				self.onPlatform = true
				self.y = change[1]
			elseif not (self.keyboard:keyState(self.inputNumber, "down") > 0) then
				self.onGround = change[3]
				self.onPlatform = true
				self.y = change[1]
			-- else
			-- -- if change[2] then
				
			end
		end
	end

	for i = 1, #self.level.platforms, 1 do
		if self.level.platforms[i][4]==80 then
			if self.y + self.height + self.dy < self.level.platforms[i][2] and self.y + self.height > self.level.platforms[i][2] then
				if self.x < self.level.platforms[i][1]+self.level.platforms[i][3] and self.x + self.width > self.level.platforms[i][1] then
					self.onGround = true
					self.y = self.level.platforms[i][2] - self.height + .01
				end
			end
		end
	end
	-- elseif self.dy == 0 then
	-- 	if (self.dx < 0) then
	-- 		self.x = self.level:leftCollision(self.x, self.y, self.width, self.height)
	-- 	elseif (self.dx > 0) then
	-- 		self.x = self.level:rightCollision(self.x, self.y, self.width, self.height)
	-- 	end


	--ATTACKS	----------------------------------------------------
	if (self.keyboard:keyState(self.inputNumber, "punch") > 0) and self.attackTimer == 0 and self.onPlatform and self.coolDown == 0 then
		self.attackType = 1
		self.attackTimer = 1
		self.isAttacking = true
	elseif (self.keyboard:keyState(self.inputNumber, "kick") > 0) and self.attackTimer == 0 and self.onPlatform and self.coolDown == 0 then
		self.attackType = 2
		self.attackTimer = 1
		self.isAttacking = true
	elseif ( not (self.keyboard:keyState(self.inputNumber, "punch") > 0) and not (self.keyboard:keyState(self.inputNumber, "kick") > 0 )) or self.attackTimer==25 then
		self.isAttacking = false
		if (self.keyboard:keyState(self.inputNumber, "punch") > 0) then
			if self.facing==1 then
				if self.numKnives > 0 or self.level.game.gameSettings.infiniteKnives then
					table.insert(self.level.projectiles, Projectile("knife", self.x+100, self.y+60, 1, self.color))
					self.numKnives = self.numKnives - 1
					if self.level.game.gameSettings.punchWhileThrowing then
						self.level.attacks:newAttack(self.x+100, self.y+20, 90, 90, self.color, self.level.game.gameSettingRates.punchDamage, self.facing, 20)
					end
				else
					self.level.attacks:newAttack(self.x+100, self.y+20, 90, 90, self.color, self.level.game.gameSettingRates.punchDamage, self.facing, 20)
				end
			else
				if self.numKnives > 0 or self.level.game.gameSettings.infiniteKnives then
					table.insert(self.level.projectiles, Projectile("knife", self.x-70, self.y+60, -1, self.color))
					self.numKnives = self.numKnives - 1
					if self.level.game.gameSettings.punchWhileThrowing then
						self.level.attacks:newAttack(self.x-70, self.y+20, 90, 90, self.color, 	self.level.game.gameSettingRates.punchDamage, self.facing, 20)
					end
				else
					self.level.attacks:newAttack(self.x-70, self.y+20, 90, 90, self.color, 	self.level.game.gameSettingRates.punchDamage, self.facing, 20)
				end
			end
			self.coolDown = 50
		elseif (self.keyboard:keyState(self.inputNumber, "kick") > 0) then
			if self.facing==1 then
				self.level.attacks:newAttack(self.x+120, self.y+10, 90, 90, self.color, self.level.game.gameSettingRates.kickDamage, self.facing, 20)
			else
				self.level.attacks:newAttack(self.x-80, self.y+10, 90, 90, self.color, self.level.game.gameSettingRates.kickDamage, self.facing, 20)
			end
			self.coolDown = 50
		end
	end
	
	
	if self.isAttacking and self.attackTimer < 150 then
		self.attackTimer = self.attackTimer + self.attackSpeed/self.attackType
	elseif self.attackTimer >= 150 then
		self.attackTimer = 20
		self.isAttacking = false
	elseif not self.isAttacking  then
		self.attackTimer = self.attackTimer - self.attackSpeed/self.attackType
	elseif not self.isAttacking then
		self.attackTimer = 20
	end
	
	if self.attackTimer < 0 then
		self.attackTimer = 0
	elseif self.attackTimer > 25 then
		self.attackTimer = 24
	end
		
	if self.coolDown > 0 then
		self.coolDown = self.coolDown - self.coolDownSpeed
		if self.coolDown < 0 then
			self.coolDown = 0
		end
	end
	
	--if self.isAttacking
	--
	----------------------------------------------------
	
	
	if self.onPlatform then
		self.ay = 0
		self.dy = 0
	else
		self.ay = 40
		if (self.keyboard:keyState(self.inputNumber, "down") > 0) then
			self.ay = 80
		end
	end

	self.x = self.x + self.dx * dt * self.moveSpeed
	self.y = self.y + self.dy * dt

	-- then jump?
	
	--[[
	if not self.onPlatform then
		self.airTime = self.airTime + 1
	else
		self.airTime = 0
	end
	
	if self.airTime > 15 then
		self.jumpReset = false
	end
	
	if (self.keyboard:keyState(self.inputNumber, "up") == 0) then
		self.jumpReset = false
		--if self.dy < 0 then
		--	self.dy = 4*(self.dy/5)
		--end
	end
	
	if self.onPlatform then
		self.jumpReset = true
	end
	]]--
	
	if self.dy < self.jumpForce*1.6 then
		self.dy = self.jumpForce*1.6
	end

	if self.onPlatform and (self.keyboard:keyState(self.inputNumber, "up") > 0) then --and self.attackTimer==0 then
		if self.superJumps > 0 then
			self.superJumps = self.superJumps - 1
			self.dy = self.dy + self.jumpForce*.6
		end
		self.dy = self.dy + self.jumpForce
		self.onGround = false
		self.onPlatform = false
		self.y = self.y - 1
		--self.doubleJump = false;
	end
	
	--projectile damage
	for i = 1, #self.level.projectiles, 1 do
		removed = false
		if self.level.projectiles[i] then
			if self.x + self.width - 10 > self.level.projectiles[i].x and self.x + 10 < self.level.projectiles[i].x + self.level.projectiles[i].width then
				if self.y + self.height > self.level.projectiles[i].y and self.y < self.level.projectiles[i].y + self.level.projectiles[i].height then
					if self.color%4 ~= self.level.projectiles[i].color%4 then
						self.health = self.health - 30
						self.attackedTimer = 20
						table.remove(self.level.projectiles, i)
						self.level.game:startScreenshake(.15, 4)
						i = #self.level.projectiles+10
						removed = true
					end
				end
			end
		end
	end
	for i = 1, #self.level.projectiles, 1 do
		if self.level.projectiles[i] then
			if self.level.projectiles[i].x + self.level.projectiles[i].width < 0 or self.level.projectiles[i].x > self.SCREENWIDTH then
				table.remove(self.level.projectiles, i)
				i = #self.level.projectiles+10
			end
		end
	end

	--animations
	self.anim = self.anim%40 + 1
	self.runAnim = self.runAnim%30 + 1
	
	if self.dx==0 then
		self.runAnim = 1
	end
	
	if self.attackedTimer > 0 then
		self.attackedTimer = self.attackedTimer - 1
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
