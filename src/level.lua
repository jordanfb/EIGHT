

require "player"
require "attacks"

require "class"

Level = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function Level:_init(keyboard, setPlayers, game)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false

	self.game = game
	self.keyboard = keyboard
	-- 1920, 1080
	self.platforms = {{100, 700, 200, 30}, {0, 900, 200, 30}, {1920-300, 700, 200, 30}, {1920-200, 900, 200, 30}, {300, 600, 1920-300-300, 30}}

	-- {  {x, y, width, height}  }

	self.players = {Player(self, self.keyboard, 100, 100,      "`", "1", "2", "3", "4", "5", 0),
					Player(self, self.keyboard, 900+100, 100, "7", "8", "9", "0", "-", "=", 4),
					Player(self, self.keyboard, 300+25, 100, "q", "w", "e", "r", "t", "y", 1),
					Player(self, self.keyboard, 1100+125, 100, "u", "i", "o", "p", "[", "]", 5),
					Player(self, self.keyboard, 500+50, 100, "a", "s", "d", "f", "g", "h", 2),
					Player(self, self.keyboard, 1300+150, 100, "j", "k", "l", ";", "'", "return", 6),
					}
	-- self.players = {}
	if self.keyboard.wasd then -- then it's using the wasd translator, hopefully
		self.players[7] = Player(self, self.keyboard, 700+75, 100, "6", "z", "x", "c", "v", "b", 3)
		self.players[8] = Player(self, self.keyboard, 1500+175, 100, "n", "m", ",", ".", "/", "\\", 7)
	else
		self.players[7] = Player(self, self.keyboard, 700+75, 100, "lshift", "z", "x", "c", "v", "b", 3)
		self.players[8] = Player(self, self.keyboard, 1500+175, 100, "n", "m", ",", ".", "/", "rshift", 7)
	end

	if setPlayers ~= nil then
		self.players = setPlayers
	end
	
	self.attacks = Attacks(self, self.players)
	
	self.grassImage = love.graphics.newImage('images/grass.png')
	self.platformImage = love.graphics.newImage('images/platform.png')
	self.bg = love.graphics.newImage('images/bg.png')


	self.SCREENWIDTH = 1920
	self.SCREENHEIGHT = 1080
	self.fullCanvas = love.graphics.newCanvas(self.SCREENWIDTH, self.SCREENHEIGHT)
end

function Level:load()
	-- run when the level is given control
	love.mouse.setVisible(false)
	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 36))
	for i = 1, #self.players, 1 do
		self.players[i].x = self.SCREENWIDTH*i/(#self.players+1) - self.players[1].width/2
		self.players[i].y = 100
	end
	self.attacks.players = self.players
	-- for k, v in pairs(self.keyboard.keys) do
	-- 	self.keyboard.keys[k] = false
	-- end
end

function Level:leave()
	-- run when the level no longer has control
end

function Level:draw()
	-- this resizes everything on screen to the correct size, but may be super inefficient...
	love.graphics.setCanvas(self.fullCanvas)
	-- everything to be drawn in the draw function should be beneath this

	love.graphics.draw(self.bg, 0, 0)
	for i = 1, #self.platforms, 1 do
		for x = 0, self.platforms[i][3], 1 do
			love.graphics.draw(self.platformImage, self.platforms[i][1] + x, self.platforms[i][2])
		end
	end
	love.graphics.setColor(255, 255, 255)
	for i = 1, #self.players, 1 do
		self.players[i]:draw()
	end
	for i = 0, 50, 1 do
		love.graphics.draw(self.grassImage, i*80, self.SCREENHEIGHT-80)
	end
	self.attacks:draw()
	self:drawHealth()


	-- this is the ending of the scaling things to the correct size, so nothing should be beneath this.
	love.graphics.setCanvas()
	love.graphics.draw(self.fullCanvas, 0, 0, 0, love.graphics.getWidth()/1920, love.graphics.getHeight()/1080)
end

function Level:drawHealth()
	love.graphics.setColor(255, 255, 255)
	local colors = {{211, 46, 12}, {44, 145, 16}, {30, 72, 227}, {182, 29, 209}}
	local colorsText = {"Red", "Green", "Blue", "Purple"}
	local y = 10
	local healthText = {}
	for i = 1, #self.players, 1 do
		healthText[#healthText+1] = colors[(self.players[i].color)%4+1]
		healthText[#healthText+1] = "P"..(self.players[i].color+1)..":"..math.max(0, self.players[i].health).."  "
	end
	-- local healthText = {{211, 46, 12},"P1:"..self.players[1].health.."  ", {44, 145, 16},"P2:"..self.players[2].health.."  ",
	-- 					{30, 72, 227}, "P3:"..self.players[3].health.."  ", {182, 29, 209},"P4:"..self.players[4].health.."  ",}
	love.graphics.printf(healthText, 0, y, self.SCREENWIDTH, "center")
	
	--if (#self.players==1)
	local gameOver = true
	local winner = -1
	for i = 1, #self.players, 1 do
		if self.players[i].health>0 then
			if winner == -1 then
				winner = self.players[i].color
			elseif winner%4 ~= self.players[i].color%4 then
				gameOver = false
			end
		end
	end
	
	if gameOver==true then
		if winner == -1 then
			print("WINNER IS -1!!!!!")
			love.graphics.setColor(255, 255, 255)
			love.graphics.print("NO TEAM WINS", 600, 100)
		else
			love.graphics.setColor(colors[winner%4+1])
			love.graphics.print("TEAM "..colorsText[winner%4+1].." WINS!", 600, 100)
		end
	end
end

function Level:update(dt)
	for i = 1, #self.players, 1 do
		self.players[i]:update(dt)
	end
	self.attacks:update(dt)
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
		if playerY+playerHeight <= self.platforms[i][2] and playerY + playerHeight + dy >= self.platforms[i][2] then
			if playerX < self.platforms[i][1]+self.platforms[i][3] and playerX + playerWidth > self.platforms[i][1] then
				return {self.platforms[i][2]-playerHeight, true}
			end
		end
	end
	return {playerY, false}
end

function Level:keypressed(key, unicode)
	--
	if key == "escape" then
		self.game:popScreenStack()
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