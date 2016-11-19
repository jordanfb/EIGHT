

require "class"

MainMenu = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function MainMenu:_init(args)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false

	self.bg = love.graphics.newImage('images/bg.png')
end

function MainMenu:load()
	-- run when the level is given control
	love.mouse.setVisible(true)
	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 40))
end

function MainMenu:leave()
	-- run when the level no longer has control
end

function MainMenu:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.bg, 0, 0)
end

function MainMenu:update(dt)
	--
end

function MainMenu:resize(w, h)
	--
end

function MainMenu:keypressed(key, unicode)
	--
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