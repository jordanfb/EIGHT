

require "player"
require "attacks"

require "class"

Level = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function Level:_init(keyboard)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false

	self.keyboard = keyboard
	-- 1920, 1080
	self.platforms = {{1920-200, 900, 200, 30}, {0, 900, 200, 30}}
	-- {  {x, y, width, height}  }

	self.players = {Player(self, self.keyboard, 100, 100,      "`", "1", "2", "3", "4", "5", 0),
					Player(self, self.keyboard, 1920-100, 100, "7", "8", "9", "0", "-", "=", 1),
					Player(self, self.keyboard, 1920-200, 100, "q", "w", "e", "r", "t", "y", 2),
					Player(self, self.keyboard, 1920-300, 100, "u", "i", "o", "p", "[", "]", 3),
					Player(self, self.keyboard, 1920-400, 100, "a", "s", "d", "f", "g", "h", 4),
					Player(self, self.keyboard, 1920-500, 100, "j", "k", "l", ";", "'", "return", 5),
					Player(self, self.keyboard, 1920-600, 100, "lshift", "z", "x", "c", "v", "b", 6),
					Player(self, self.keyboard, 1920-700, 100, "n", "m", ",", ".", "/", "rshift", 7),
					}
	
	self.attacks = Attacks(self, self.players)

end

function Level:load()
	-- run when the level is given control
end

function Level:leave()
	-- run when the level no longer has control
end

function Level:draw()
	love.graphics.setColor(255, 0, 0)
	for i = 1, #self.platforms, 1 do
		love.graphics.rectangle("fill", self.platforms[i][1], self.platforms[i][2], self.platforms[i][3], self.platforms[i][4], 5, 5)
	end
	love.graphics.setColor(255, 255, 255)
	for i = 1, #self.players, 1 do
		self.players[i]:draw()
	end
	self.attacks:draw()
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