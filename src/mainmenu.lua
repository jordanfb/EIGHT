

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
	-- self:makeTitleImage()

	self.zoom = 10

	self.SCREENWIDTH = 1920
	self.SCREENHEIGHT = 1080
	self.menuCanvas = love.graphics.newCanvas(self.SCREENWIDTH, self.SCREENHEIGHT)
end

function MainMenu:createDefaultPlayers()
	self.players = {Player(self, self.keyboard, 100, 100,      "`", "1", "2", "3", "4", "5", 0),
					Player(self, self.keyboard, 900+100, 100, "7", "8", "9", "0", "-", "=", 4),
					Player(self, self.keyboard, 300+25, 100, "q", "w", "e", "r", "t", "y", 1),
					Player(self, self.keyboard, 1100+125, 100, "u", "i", "o", "p", "[", "]", 5),
					Player(self, self.keyboard, 500+50, 100, "a", "s", "d", "f", "g", "h", 2),
					Player(self, self.keyboard, 1300+150, 100, "j", "k", "l", ";", "'", "return", 6),
					}
	if self.keyboard.wasd then -- then it's using the wasd translator, hopefully
		self.players[7] = Player(self, self.keyboard, 700+75, 100, "6", "z", "x", "c", "v", "b", 3)
		self.players[8] = Player(self, self.keyboard, 1500+175, 100, "n", "m", ",", ".", "/", "\\", 7)
	else
		self.players[7] = Player(self, self.keyboard, 700+75, 100, "lshift", "z", "x", "c", "v", "b", 3)
		self.players[8] = Player(self, self.keyboard, 1500+175, 100, "n", "m", ",", ".", "/", "rshift", 7)
	end
end

-- function MainMenu:makeTitleImage()
-- 	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 128))
-- 	-- self.titleImage = love.graphics.newCanvas(800, 600)
-- 	-- love.graphics.setCanvas(self.titleImage)
-- 	-- -- love.graphics.clear(255, 255, 255, 255)
-- 	-- -- print stuff
-- 	-- love.graphics.setColor(255, 255, 0, 128)
--  --    love.graphics.rectangle('fill', 0, 0, 100, 100)
-- 	-- -- love.graphics.setColor(255, 255, 255)
-- 	-- -- love.graphics.printf("EIGHT", 0, love.graphics.getHeight()/6, love.graphics.getWidth(), "center")
-- 	-- love.graphics.setCanvas()


-- 	canvas = love.graphics.newCanvas(800, 600)
-- 	love.graphics.setCanvas(canvas)
-- 	love.graphics.setColor(255, 255, 255)
-- 	love.graphics.print("HELLO", 10, 10)
-- 		love.graphics.clear()
-- 		love.graphics.setBlendMode("alpha")
-- 		love.graphics.setColor(255, 0, 0, 128)
-- 		love.graphics.rectangle('fill', 0, 0, 100, 100)
-- 	love.graphics.setCanvas()
-- end

function MainMenu:load()
	-- run when the level is given control
	love.mouse.setVisible(true)
	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 128))
	if self.game.drawFPS then
		self.fpsWasOn = true
		self.game.drawFPS = false
	end
end

function MainMenu:leave()
	-- run when the level no longer has control
	if self.fpsWasOn then
		self.game.drawFPS = true
	end
end

function MainMenu:draw()
	love.graphics.setCanvas(self.menuCanvas)
	-- now start the drawing
	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 128))
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf("EIGHT", 0, self.SCREENHEIGHT/6, self.SCREENWIDTH, "center")
	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 64))
	love.graphics.printf("Controls are wasd+cv or ijkl+,.", 0, self.SCREENHEIGHT/3, self.SCREENWIDTH, "center")
	love.graphics.printf("Press any key to join", 0, self.SCREENHEIGHT*3/6, self.SCREENWIDTH, "center")

	-- now be done with the drawing
	love.graphics.setCanvas()
	love.graphics.setColor(255, 255, 255)

	love.graphics.draw(self.bg)
	love.graphics.draw(self.menuCanvas, love.graphics.getWidth()/2.6, love.graphics.getHeight()/2.6, 0, self.zoom*love.graphics.getWidth()/1920, self.zoom*love.graphics.getHeight()/1080, love.graphics.getWidth()/2, love.graphics.getHeight()/2)
	-- love.graphics.draw(self.menuCanvas, 0, 0, 0, self.zoom*love.graphics.getWidth()/1920, self.zoom*love.graphics.getHeight()/1080)
end


-- function MainMenu:oldDraw()
-- 	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 1000-self.i))
-- 	love.graphics.setColor(255, 255, 255)
-- 	love.graphics.draw(self.bg, 0, 0)
-- 	love.graphics.setColor(255, 255, 255, 255)
-- 	love.graphics.printf("EIGHT", -2000, love.graphics.getHeight()/6, love.graphics.getWidth()+4000, "center")
-- 	love.graphics.draw(canvas, 0, 0)

-- 	-- love.graphics.setBlendMode("alpha", "premultiplied")
-- 	-- love.graphics.draw(self.titleImage)

-- 	-- love.graphics.setBlendMode("alpha")
-- 	-- love.graphics.draw(self.titleImage, 100, 0)

-- 	-- love.graphics.setColor(255, 0, 0, 128)
--  --    love.graphics.rectangle('fill', 200, 0, 100, 100)


--  	-- self:testdraw()
-- end

-- function MainMenu:testdraw()
-- 	love.graphics.setColor(255, 255, 255, 255)
 
--     -- The rectangle from the Canvas was already alpha blended.
--     -- Use the premultiplied alpha blend mode when drawing the Canvas itself to prevent improper blending.
--     love.graphics.setBlendMode("alpha", "premultiplied")
--     love.graphics.draw(canvas)
--     -- Observe the difference if the Canvas is drawn with the regular alpha blend mode instead.
--     love.graphics.setBlendMode("alpha")
--     love.graphics.draw(canvas, 100, 0)
 
--     -- Rectangle is drawn directly to the screen with the regular alpha blend mode.
--     love.graphics.setBlendMode("alpha")
--     love.graphics.setColor(255, 0, 0, 128)
--     love.graphics.rectangle('fill', 200, 0, 100, 100)
-- end

function MainMenu:update(dt)
	--
	-- if self.i < 1000-64 then
	-- 	self.i = self.i + dt*100
	-- elseif self.i > 1000-64 then
	-- 	self.i = 1000-64
	-- end

	if self.zoom > 1 then
		self.zoom = self.zoom - dt*10
	elseif self.zoom < 1 then
		self.zoom = 1
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