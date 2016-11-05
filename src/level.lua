

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
	self.platforms = {{100, 700, 200, 30}, {0, 900, 200, 30}}
	-- {  {x, y, width, height}  }

	self.players = {Player(self, self.keyboard, 100, 100,      "`", "1", "2", "3", "4", "5", 0),
				--	Player(self, self.keyboard, 1920-100, 100, "7", "8", "9", "0", "-", "=", 1),
					--Player(self, self.keyboard, 1920-200, 100, "q", "w", "e", "r", "t", "y", 2),
		---			Player(self, self.keyboard, 1920-300, 100, "u", "i", "o", "p", "[", "]", 3),
					Player(self, self.keyboard, 1920-400, 100, "a", "s", "d", "f", "g", "h", 4),
			--		Player(self, self.keyboard, 1920-500, 100, "j", "k", "l", ";", "'", "return", 5),
				--	Player(self, self.keyboard, 1920-600, 100, "lshift", "z", "x", "c", "v", "b", 6),
					--Player(self, self.keyboard, 1920-700, 100, "n", "m", ",", ".", "/", "rshift", 7),
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
	self:drawHealth()
end

function Level:drawHealth()
	love.graphics.setColor(255, 255, 255)
	local colors = {{211, 46, 12}, {44, 145, 16}, {30, 72, 227}, {182, 29, 209}}
	local colorsText = {"Red", "Green", "Blue", "Purple"}
	local y = 10
	local healthText = {}
	for i = 1, #self.players, 1 do
		healthText[#healthText+1] = colors[(i-1)%4+1]
		healthText[#healthText+1] = "P"..i..":"..self.players[i].health.."  "
	end
	-- local healthText = {{211, 46, 12},"P1:"..self.players[1].health.."  ", {44, 145, 16},"P2:"..self.players[2].health.."  ",
	-- 					{30, 72, 227}, "P3:"..self.players[3].health.."  ", {182, 29, 209},"P4:"..self.players[4].health.."  ",}
	love.graphics.printf(healthText, 0, y, love.graphics.getWidth(), "center")
	
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
		love.graphics.setColor(colors[winner+1])
		love.graphics.print("TEAM "..colorsText[winner+1].." WINS!", 500, 100)
	end
	--end
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