

require "class"

MainMenu = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function MainMenu:_init(game)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false

	self.game = game
	self.keyboard = self.game.keyboard
	self.bg = love.graphics.newImage('images/bg.png')
	self.i = 0
	self:makeTitleImage()
end

function MainMenu:makeTitleImage()
	self.titleImage = love.graphics.newCanvas()
	love.graphics.setCanvas(self.titleImage)
	love.graphics.clear()
	-- print stuff
	love.graphics.setCanvas()
end

function MainMenu:load()
	-- run when the level is given control
	love.mouse.setVisible(true)
	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 128))
end

function MainMenu:leave()
	-- run when the level no longer has control
end

function MainMenu:draw()
	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 1000-self.i))
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.bg, 0, 0)
	love.graphics.printf("EIGHT", 0, love.graphics.getHeight()/6, love.graphics.getWidth(), "center")
end

function MainMenu:update(dt)
	--
	if self.i < 1000-64 then
		self.i = self.i + dt*100
	elseif self.i > 1000-64 then
		self.i = 1000-64
	end
end

function MainMenu:resize(w, h)
	--
end

function MainMenu:keypressed(key, unicode)
	if not self.keyboard.wasd and key == "return" then
		-- add the level to the game as a quick default
		self.game:addToScreenStack(self.game.level)
	end
end

function MainMenu:keyreleased(key, unicode)
	--
end

function MainMenu:mousepressed(x, y, button)
	--
end

function MainMenu:mousereleased(x, y, button)
	--
end