



require "class"

PauseMenu = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function PauseMenu:_init(game)
	-- this is for the draw stack
	self.drawUnder = true
	self.updateUnder = false

	self.game = game
end

function PauseMenu:load()
	-- run when the level is given control
end

function PauseMenu:leave()
	-- run when the level no longer has control
end

function PauseMenu:draw()
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle("fill", 0, 0, 1920, 1080)
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf("Click, Space, or Play to continue, Escape or Back to exit", 1920/2-500, 1080/2, 1000, "center")
end

function PauseMenu:update(dt)
	--
end

function PauseMenu:resize(w, h)
	--
end

function PauseMenu:keypressed(key, unicode)
	if key == "escape" then
		self.game:popScreenStack()
		self.game:popScreenStack()
	elseif key == "space" then
		self.game:popScreenStack()
	end
end

function PauseMenu:keyreleased(key, unicode)
	--
end

function PauseMenu:mousepressed(x, y, button)
	self.game:popScreenStack()
end

function PauseMenu:mousereleased(x, y, button)
	--
end