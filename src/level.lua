require "player"
require "attacks"
require "projectile"
require "item"

require "class"

Level = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function Level:_init(keyboard, setPlayers, game)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false

	self.SCREENWIDTH = 1920
	self.SCREENHEIGHT = 1080
	
	self.game = game
	self.keyboard = keyboard
	-- 1920, 1080
	self.allLevels = {}
	self.allLevels[1] = {{0, 1000, 1920, 80}, {100, 700, 200, 30}, {0, 900, 200, 30}, {1920-300, 700, 200, 30}, {1920-200, 900, 200, 30}, {300, 600, 1920-300-300, 30}}
	self.allLevels[2] = {{0, 1000, 1920, 80}, {100, 500, 600, 30}, {1920 - 700, 500, 600, 30}, {400, 700, 1920-800, 30}, {150, 850, 200, 30}, {1920 - 350, 850, 200, 30}, {500, 320, 920, 30}}
	self.allLevels[3] = {{0, 1000, 600, 80}, {600+720, 1000, 900, 80}, {0, 700, 1920, 30}, {150, 850, 200, 30}, {1920 - 350, 850, 200, 30}, {500, 320, 920, 30}, {1920/2-50, 1080/2-30, 100, 30}, {0, 1080/2-30, 200, 30}, {1720, 1080/2-30, 200, 30}}
	self.allLevels[4] = {{1920/2-300, 800, 600, 30}, {200, 600, 300, 30}, {1920-500, 600, 300, 30}}
	
	self.allLevelItemSpawns = {}
	self.allLevelItemSpawns[1] = {self.SCREENHEIGHT*(1/2)}
	self.allLevelItemSpawns[2] = {self.SCREENHEIGHT*(2/3)}
	self.allLevelItemSpawns[3] = {self.SCREENHEIGHT*(1/3), self.SCREENHEIGHT*(2/3)}
	self.allLevelItemSpawns[4] = {self.SCREENHEIGHT*(1/2)}
	
	self.level = math.random(#self.allLevels)
	self.platforms = self.allLevels[self.level]
	-- {  {x, y, width, height}  }

	self.players = {Player(self, self.keyboard, 100, 100, 1, 0),
					Player(self, self.keyboard, 900+100, 100, 5, 4),
					Player(self, self.keyboard, 300+25, 100, 2, 1),
					Player(self, self.keyboard, 1100+125, 100, 6, 5),
					Player(self, self.keyboard, 500+50, 100, 3, 2),
					Player(self, self.keyboard, 1300+150, 100, 7, 6),
					Player(self, self.keyboard, 700+75, 100, 4, 3),
					Player(self, self.keyboard, 1500+175, 100, 8, 7),
					}
	self.numPlayersAlive = 8
	
	self.players = setPlayers or self.players -- if setPlayers == nil then set it to self.players

	self.attacks = Attacks(self, self.players, self.game)
	self.projectiles = {}
	self.items = {}
	
	self.grassImage = love.graphics.newImage('images/grass.png')
	self.platformImage = love.graphics.newImage('images/platform.png')

	self.backgroundImages = {love.graphics.newImage('images/bg.png'), love.graphics.newImage('images/bg-2.png'),
						love.graphics.newImage('images/bg-3.png'), love.graphics.newImage('images/bg-4.png')}
	self.bg = self.backgroundImages[self.level]

	self.fullCanvas = love.graphics.newCanvas(self.SCREENWIDTH, self.SCREENHEIGHT)
end

function Level:resetPlayers()
	for i = 1, #self.players, 1 do
		self.players[i].x = self.SCREENWIDTH*i/(#self.players+1) - self.players[1].width/2
		self.players[i].y = 100
		self.players[i].health = 100
		if self.SCREENWIDTH*i/(#self.players+1) - self.players[1].width/2 < self.SCREENWIDTH/2 then
			self.players[i].facing = 1
		else
			self.players[i].facing = -1
		end
		self.players[i].dy = 0
		self.players[i].dx = 0
		self.players[i].ay = 0
		self.players[i].speedUp = 0
		self.players[i].superJumps = 0
		self.players[i].numKnives = 0
		self.players[i].attackedTimer = 0
	end
	self.numPlayersAlive = #self.players
end

function Level:load()
	-- run when the level is given control
	self.level = math.random(#self.allLevels)
	self:resetPlayers()
	self.items = {}
	self.projectiles = {}
	self.attacks = Attacks(self, self.players, self.game)
	self.platforms = self.allLevels[self.level]
	self.bg = self.backgroundImages[self.level]

	love.mouse.setVisible(false)
	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 36))
	
	self.attacks.players = self.players
	self.gameOver = false
	self.winner = -1
	-- for k, v in pairs(self.keyboard.keys) do
	-- 	self.keyboard.keys[k] = false
	-- end
end

function Level:leave()
	-- run when the level no longer has control
end

function Level:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 36))
	-- this resizes everything on screen to the correct size, but may be super inefficient...
	love.graphics.setCanvas(self.fullCanvas)
	-- everything to be drawn in the draw function should be beneath this

	love.graphics.draw(self.bg, 0, 0)
	for i = 1, #self.platforms, 1 do
		if self.platforms[i][4]==80 then
			for x = 0, self.platforms[i][3], 80 do
				love.graphics.draw(self.grassImage, self.platforms[i][1] + x, self.platforms[i][2])
			end
		else
			for x = 0, self.platforms[i][3], 1 do
				love.graphics.draw(self.platformImage, self.platforms[i][1] + x, self.platforms[i][2])
			end
		end
	end
	love.graphics.setColor(255, 255, 255)
	for i = 1, #self.players, 1 do
		self.players[i]:draw()
	end
	for i = 1, #self.projectiles, 1 do
		self.projectiles[i]:draw()
	end
	for i = 1, #self.items, 1 do
		self.items[i]:draw()
	end
--	for i = 0, 50, 1 do
--		love.graphics.draw(self.grassImage, i*80, self.SCREENHEIGHT-80)
--	end
	self.attacks:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 0, self.SCREENWIDTH, 100)
	love.graphics.setColor(255, 255, 255)
	self:drawHealth()

	-- this is the ending of the scaling things to the correct size, so nothing should be beneath this.
	love.graphics.setCanvas()
	love.graphics.draw(self.fullCanvas, 0, 0, 0, love.graphics.getWidth()/1920, love.graphics.getHeight()/1080)
end

function Level:playerDied()
	if self.numPlayersAlive <= self.game.gameSettingRates.suddenDeathOnNumberOfPeople then
		--
	end
end

function Level:drawHealth()
	love.graphics.setColor(255, 255, 255)
	local colors = {{211, 46, 12}, {44, 145, 16}, {30, 72, 227}, {182, 29, 209}}
	local colorsText = {"Red", "Green", "Blue", "Purple"}
	local y = 10
	local healthText = {}
	for i = 1, #self.players, 1 do
		healthText[#healthText+1] = colors[(self.players[i].color)%4+1]
		healthText[#healthText+1] = "P"..(self.players[i].color+1)..":"..math.max(0, math.floor(self.players[i].health)).."  "
	end
	-- local healthText = {{211, 46, 12},"P1:"..self.players[1].health.."  ", {44, 145, 16},"P2:"..self.players[2].health.."  ",
	-- 					{30, 72, 227}, "P3:"..self.players[3].health.."  ", {182, 29, 209},"P4:"..self.players[4].health.."  ",}
	love.graphics.printf(healthText, 0, y, self.SCREENWIDTH, "center")
	
	--if (#self.players==1)
	if not self.gameOver then
		self.gameOver = true
		self.winner = -1
		for i = 1, #self.players, 1 do
			if self.players[i].health>0 then
				if self.winner == -1 then
					self.winner = self.players[i].color
				elseif self.winner%4 ~= self.players[i].color%4 then
					self.gameOver = false
				end
			end
		end
	end
	
	if self.gameOver==true then
		if self.winner == -1 then
			love.graphics.setColor(255, 255, 255)
			love.graphics.printf("NO TEAM WINS", 0, 100, self.SCREENWIDTH, "center")
		else
			love.graphics.setColor(colors[self.winner%4+1])
			love.graphics.printf("TEAM "..colorsText[self.winner%4+1].." WINS!", 0, 100, self.SCREENWIDTH, "center")
		end
	end
end

function Level:update(dt)
	for i = 1, #self.players, 1 do
		self.players[i]:update(dt)
		if self.game.gameSettings.poison and not self.gameOver then -- do poison
			-- do damage per second
			self.players[i].health = self.players[i].health - self.game.gameSettingRates.poisonRate*dt
		end
		if self.game.gameSettings.regen then -- do regen
			-- do health per second
			if self.players[i].health > 1 then -- because otherwise it will show zero health, which will make people sad.
				self.players[i].health = math.min(self.players[i].health + self.game.gameSettingRates.regenRate*dt, 100)
			end
		end
	end

	for i = 1, #self.projectiles, 1 do
		self.projectiles[i]:update(dt)
	end
	for i = 1, #self.items, 1 do
		self.items[i]:update(dt)
	end
	if self.game.gameSettings.healthSpawn then
		if math.random(3000/self.game.gameSettingRates.health)==1 then
			table.insert(self.items, Item("health", -50, self.allLevelItemSpawns[self.level][math.random(#self.allLevelItemSpawns[self.level])], 1, 1, self.game))
		end
		if math.random(3000/self.game.gameSettingRates.health)==1 then
			table.insert(self.items, Item("health", self.SCREENWIDTH, self.allLevelItemSpawns[self.level][math.random(#self.allLevelItemSpawns[self.level])], -1, 1, self.game))
		end
	end
	if self.game.gameSettings.knifeSpawn and not self.game.gameSettings.infiniteKnives then
		if math.random(3000/self.game.gameSettingRates.knife)==1 then
		-- if math.random(100) == 1 then
			table.insert(self.items, Item("knife", -70, self.allLevelItemSpawns[self.level][math.random(#self.allLevelItemSpawns[self.level])], 1, 1, self.game))
		end
		if math.random(3000/self.game.gameSettingRates.knife)==1 then
			table.insert(self.items, Item("knife", self.SCREENWIDTH, self.allLevelItemSpawns[self.level][math.random(#self.allLevelItemSpawns[self.level])], -1, 1, self.game))
		end
	end
	if self.game.gameSettings.jumpSpawn and not self.game.gameSettings.infiniteJumps then
		if math.random(3000/self.game.gameSettingRates.jump)==1 then
		-- if math.random(100) == 1 then
			table.insert(self.items, Item("jump", -70, self.allLevelItemSpawns[self.level][math.random(#self.allLevelItemSpawns[self.level])], 1, 1, self.game))
		end
		if math.random(3000/self.game.gameSettingRates.jump)==1 then
			table.insert(self.items, Item("jump", self.SCREENWIDTH, self.allLevelItemSpawns[self.level][math.random(#self.allLevelItemSpawns[self.level])], -1, 1, self.game))
		end
	end
	if self.game.gameSettings.speedSpawn and not self.game.gameSettings.infiniteSpeed then
		if math.random(3000/self.game.gameSettingRates.speed)==1 then
		-- if math.random(100) == 1 then
			table.insert(self.items, Item("speed", -70, self.allLevelItemSpawns[self.level][math.random(#self.allLevelItemSpawns[self.level])], 1, 1, self.game))
		end
		if math.random(3000/self.game.gameSettingRates.speed)==1 then
			table.insert(self.items, Item("speed", self.SCREENWIDTH, self.allLevelItemSpawns[self.level][math.random(#self.allLevelItemSpawns[self.level])], -1, 1, self.game))
		end
	end
	self.attacks:update(dt)

	for k, v in pairs(self.projectiles) do
		if v.x < -50 or v.y > 1200 or v.x > 1970 then
			table.remove(self.projectiles, k)
		end
	end
end

function Level:resize(w, h)
	for i = 1, #self.players, 1 do
		self.players[i]:resize(w, h)
	end
end

function Level:leftCollision(playerX, playerY, playerWidth, playerHeight)
	for i = 1, #self.platforms, 1 do
		if playerY < self.platforms[i][2]+self.platforms[i][4] and playerY + playerHeight > self.platforms[i][2] then
			if playerX < self.platforms[i][1]+self.platforms[i][3] and playerX + playerWidth > self.platforms[i][1] then
				return self.platforms[i][1]+self.platforms[i][3]
			end
		end
	end
	return playerX
end

function Level:rightCollision(playerX, playerY, playerWidth, playerHeight)
	for i = 1, #self.platforms, 1 do
		if playerY < self.platforms[i][2]+self.platforms[i][4] and playerY + playerHeight > self.platforms[i][2] then
			if playerX < self.platforms[i][1]+self.platforms[i][3] and playerX + playerWidth > self.platforms[i][1] then
				return self.platforms[i][1]-playerWidth
			end
		end
	end
	return playerX
end

function Level:downCollision(playerX, playerY, playerWidth, playerHeight, dy)
	for i = 1, #self.platforms, 1 do
		local addX = 0
		if self.platforms[i][4]==80 then
			addX = 30
		end
		if playerY+playerHeight <= self.platforms[i][2] and playerY + playerHeight + dy >= self.platforms[i][2] then
			if playerX - addX < self.platforms[i][1]+self.platforms[i][3] and playerX + playerWidth > self.platforms[i][1] then
				return {self.platforms[i][2]-playerHeight, true, self.platforms[i][4] == 80}
				-- the last one is if it's ground, in which case don't drop through
			end
		end
	end
	return {playerY, false, false}
end

function Level:keypressed(key, unicode)
	if key == "escape" or key == "back" or key == "start" then
		if self.gameOver then
			self.game:popScreenStack()
		else
			self.game:addToScreenStack(self.game.pauseMenu)
		end
	end
end

function Level:keyreleased(key, unicode)
	--
end

function Level:mousepressed(x, y, button)
	--
end

function Level:mousereleased(x, y, button)
	--
end