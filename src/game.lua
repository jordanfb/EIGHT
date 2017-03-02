
require "level"
require "keyboard"
require "mainmenu"
require "countdown"
require "pausemenu"
require "class"
require "settingsmenu"

Game = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function Game:_init()
	-- these are for draw stacks:
	self.drawUnder = false
	self.updateUnder = false

	-- here are the actual variables
	self.drawFPS = false

	self.keyboard = Keyboard(self)
	self.pauseMenu = PauseMenu(self)
	self.settingsMenu = SettingsMenu(self)

	self.gameSettings = {
			infiniteKnives = false, --I Miss the Old Kanye
			healthSpawn = true, --Straight from the Go Kayne
			knifeSpawn = true, --Set on his goals Kayne
			jumpSpawn = true, --Set on his goals Kayne
			speedSpawn = true, --Set on his goals Kayne
			punching = true, -- I hate the new Kayne
			kicking = true, --What if Kayne wrote a song about Kayne
			instantKill = false, --Man that'd be so Kayne
			lifeSteal = false, -- harming other people gives you health
			poison = false,
			regen = false,
			suddenDeathOnNumberOfPeople = false,
			noItemsAtNumberOfPeople = false,
			noHealthAtNumberOfPeople = false,
			takeFallingOutOfWorldDamage = true,
			healthGainOnKill = true, -- I don't think this is functional
			playMusic = false,
			punchWhileThrowing = false,
			noHealthLimit = false,
			screenShake = true,
		}
	self.gameSettingRates = {
			knife = 3,
			health = 1,
			jump = 3,
			speed = 3,
			numberJumps = 5,
			punchTime = 1, -- I don't think this is functional
			kickTime = 1, -- I don't think this is functional
			knifeTime = 1,
			punchDamage = 20,
			kickDamage = 40,
			knifeDamage = 30,
			lifeStealPercent = 10, -- the percentage of life stolen, out of 100
			poisonRate = 1, -- per second
			regenRate = 1, -- per second
			suddenDeathOnNumberOfPeople = 2,
			noItemsAtNumberOfPeople = 2,
			noHealthAtNumberOfPeople = 2,
			fallingOutOfWorldDamage = 40,
			healthGainOnKillAmount = 20,
			healthPickupAmount = 30
		} -- jumping?

	self.countdownScreen = CountdownScreen(self)
	self.level = Level(self.keyboard, nil, self) -- we should have it load by filename or something.
	self.mainMenu = MainMenu(self)
	self.screenStack = {}
	
	self.bg = love.graphics.newImage('images/bg.png')
	
	bgm = love.audio.newSource("music/battlemusic.mp3")
	bgm:setVolume(0.9) -- 90% of ordinary volume
	bgm:setLooping( true )
	if self.gameSettings.playMusic then
		bgm:play()
	end

	self.healthItemImage = love.graphics.newImage('images/health-item.png')
	self.knifeItemImage = love.graphics.newImage('images/knife-item.png')
	self.jumpItemImage = love.graphics.newImage('images/jump-item.png')
	self.speedItemImage = love.graphics.newImage('images/speed-item.png')

	self:addToScreenStack(self.mainMenu)

	self.screenshakeDuration = 0
	self.screenshakeMagnitude = 0
end

function Game:startScreenshake(time, intensity)
	if self.gameSettings.screenShake then
		self.screenshakeDuration = time
		self.screenshakeMagnitude = intensity
	end
end

function Game:load(args)
	if self.gameSettings.playMusic then
		bgm:play()
	else
		bgm:stop()
	end
end

function Game:draw()
	-- love.graphics.draw(self.bg, 0, 0)
	if self.screenshakeDuration > 0 then
		local dx = love.math.random(-self.screenshakeMagnitude, self.screenshakeMagnitude)
        local dy = love.math.random(-self.screenshakeMagnitude, self.screenshakeMagnitude)
        love.graphics.translate(dx, dy)
    end

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
	end
	if (self.drawFPS) then
		love.graphics.setColor(255, 0, 0)
		love.graphics.print("FPS: "..love.timer.getFPS(), 10, love.graphics.getHeight()-45)
		love.graphics.setColor(255, 255, 255)
	end
end

function Game:update(dt)
	print(self.gameSettings.infiniteKnives)
	if self.screenshakeDuration > 0 then
		self.screenshakeDuration = self.screenshakeDuration - dt
	end
	for i = #self.screenStack, 1, -1 do
		self.screenStack[i]:update(dt)
		if self.screenStack[i] and not self.screenStack[i].updateUnder then
			break
		end
	end
end

function Game:popScreenStack(loadBelow)
	self.screenStack[#self.screenStack]:leave()
	self.screenStack[#self.screenStack] = nil
	if loadBelow == nil or loadBelow then
		self.screenStack[#self.screenStack]:load()
	end
end

function Game:addToScreenStack(newScreen)
	if self.screenStack[#self.screenStack] ~= nil then
		self.screenStack[#self.screenStack]:leave()
	end
	self.screenStack[#self.screenStack+1] = newScreen
	newScreen:load()
	if self.gameSettings.playMusic then
		bgm:play()
	end
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

function Game:joystickadded(joystick)
	self.keyboard:joystickadded(joystick)
end

function Game:joystickremoved(joystick)
	self.keyboard:joystickremoved(joystick)
end

function Game:gamepadpressed(gamepad, button)
	self.keyboard:gamepadpressed(gamepad, button)
end

function Game:gamepadreleased(gamepad, button)
	self.keyboard:gamepadreleased(gamepad, button)
end

function Game:gamepadaxis(gamepad, axis, value)
	self.keyboard:gamepadaxis(gamepad, axis, value)
end