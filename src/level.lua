

require "player"

require "class"

Level = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function Level:_init()
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false


	self.players = {Player(100, 100, "1", "2", "3", "4", "5", "6", "blue")}
end

function Level:load()
	-- run when the level is given control
end

function Level:leave()
	-- run when the level no longer has control
end

function Level:draw()
	for i = 1, #self.players, 1 do
		self.players[i]:draw()
	end
end

function Level:update(dt)
	for i = 1, #self.players, 1 do
		self.players[i]:update(dt)
	end
end

function Level:resize(w, h)
	--
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