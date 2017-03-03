



require "class"
require "menu"

SettingsMenu = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function SettingsMenu:_init(game)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false
	self.game = game
	self.buttons = {{"Back", "back", "action"}, {"Reset-All", "reset", "action"}, {"Randomize", "random", "action"}, {"All off", "alloff", "action"},
					{"Health Items", "healthSpawn"}, {"Jump Items", "superJumps"}, {"Knife Items", "knives"}, {"Speed Items", "speedUps"}, {"Platform Items", "platforms"}, {"Bats", "bats"},
					{"Poison", "poison"}, {"Life Steal", "lifeSteal"}, {"Life Regen", "regen"}, {"Fall Damage", "takeFallingOutOfWorldDamage"}, {"Play Music", "playMusic"}}

	self.menu = Menu(self.game, self.buttons, 100, 100, love.graphics.getWidth()-200, love.graphics.getHeight()-200)
	self.subscribedToInputs = false
end

function SettingsMenu:load()
	-- print("settings loaded")
	-- run when the level is given control
	love.graphics.setBackgroundColor(0, 0, 0)
	self.subscribedToInputs = true
	self.game.keyboard.settingsMenuSubscribed = true
end

function SettingsMenu:leave()
	-- run when the level no longer has control
	-- print("settings left")
	self.subscribedToInputs = false
	self.game.keyboard.settingsMenuSubscribed = false
end

function SettingsMenu:draw()
	self.menu:draw()
end

function SettingsMenu:update(dt)
	self.menu:update(dt)
end

function SettingsMenu:resize(w, h)
	--
end

function SettingsMenu:inputMade(inputNum, input, pressValue)
	self.menu:inputMade(inputNum, input, pressValue)
end

function SettingsMenu:keypressed(key, unicode)
	if key == "escape" or key == "back" then
		print("I don't think this is ever called")
		self.game:popScreenStack()
	end
end

function SettingsMenu:keyreleased(key, unicode)
	--
end

function SettingsMenu:mousepressed(x, y, button)
	--
end

function SettingsMenu:mousereleased(x, y, button)
	--
end