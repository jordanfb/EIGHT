
require "level"
require "keyboard"
require "mainmenu"
require "countdown"

require "class"

Game = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function Game:_init()
	-- these are for draw stacks:
	self.drawUnder = false
	self.updateUnder = false

	-- here are the actual variables
	self.drawFPS = true

	self.keyboard = Keyboard()

	self.gameSettings = {
			infiniteKnives = false,
			healthspawn = true,
			knifespawn = true,
			punching = true,
			kicking = true,
			instantKill = false,
			lifeSteal = true, -- harming other people gives you health
			poisonMode = true,
			regen = false,
			suddenDeathOnNumberOfPeople = false,
			noItemsAtNumberOfPeople = false,
			noHealthAtNumberOfPeople = false,
			takeFallingOutOfWorldDamage = true,
			healthGainOnKill = true,
		}
	self.gameSettingRates = {
			knife = 0.5,
			health = 0.5,
			punchTime = 1,
			kickTime = 1,
			knifeTime = 1,
			punchDamage = 1,
			kickDamage = 1,
			knifeDamage = 1,
			lifeStealPercent = 10, -- the percentage of life stolen, out of 100
			poisonRate = 1, -- per second
			regenRate = 1,
			suddenDeathOnNumberOfPeople = 2,
			noItemsAtNumberOfPeople = 2,
			noHealthAtNumberOfPeople = 2,
			fallingOutOfWorldDamage = 40,
			healthGainOnKillAmount = 20,
		} -- jumping?

	self.countdownScreen = CountdownScreen(self)
	self.level = Level(self.keyboard, nil, self) -- we should have it load by filename or something.
	self.mainMenu = MainMenu(self)
	self.screenStack = {}
	
	self.bg = love.graphics.newImage('images/bg.png')
	
	bgm = love.audio.newSource("music/battlemusic.mp3")
	bgm:setVolume(0.9) -- 90% of ordinary volume
	bgm:setLooping( true )
	bgm:play()

	self:addToScreenStack(self.mainMenu)
end

function Game:load(args)
	--
end

function Game:draw()

	-- love.graphics.draw(self.bg, 0, 0)

	local thingsToDraw = 1 -- this will become the index of the lowest item to draw
	for i = #self.screenStack, 1, -1 do
		thingsToDraw = i
		if not self.screenStack[i].drawUnder then
			break
		end
	end
	-- this is so that the things earlier in the screen stack get drawn first, so that things like pause menus get drawn on top.
	for i = thingsToDraw, #self.screenStack, 1 do
		self.screenStack[i]:draw()
		-- if i ~= 1 then
		-- 	print("DRAWING "..i)
		-- end
	end
	if (self.drawFPS) then
		love.graphics.setColor(255, 0, 0)
		love.graphics.print("FPS: "..love.timer.getFPS(), 10, love.graphics.getHeight()-45)
		love.graphics.setColor(255, 255, 255)
	end
end

function Game:update(dt)
	for i = #self.screenStack, 1, -1 do
		self.screenStack[i]:update(dt)
		if self.screenStack[i] and not self.screenStack[i].updateUnder then
			break
		end
	end
end

function Game:popScreenStack()
	self.screenStack[#self.screenStack]:leave()
	self.screenStack[#self.screenStack] = nil
	self.screenStack[#self.screenStack]:load()
end

function Game:addToScreenStack(newScreen)
	if self.screenStack[#self.screenStack] ~= nil then
		self.screenStack[#self.screenStack]:leave()
	end
	self.screenStack[#self.screenStack+1] = newScreen
	newScreen:load()
end

function Game:resize(w, h)
	for i = 1, #self.screenStack, 1 do
		self.screenStack[i]:resize(w, h)
	end
	self.level:resize(w, h)
end

function Game:keypressed(key, unicode)
	self.screenStack[#self.screenStack]:keypressed(key, unicode)
	self.keyboard:keypressed(key, unicode)
end

function Game:keyreleased(key, unicode)
	self.screenStack[#self.screenStack]:keyreleased(key, unicode)
	self.keyboard:keyreleased(key, unicode)
end

function Game:mousepressed(x, y, button)
	self.screenStack[#self.screenStack]:mousepressed(x, y, button)
end

function Game:mousereleased(x, y, button)
	self.screenStack[#self.screenStack]:mousereleased(x, y, button)
end

function Game:quit()
	--
end