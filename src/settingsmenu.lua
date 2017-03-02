



require "class"
require "menu"

SettingsMenu = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function SettingsMenu:_init(game)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false
	self.game = game
	self.buttons = {{"Back", "back"}, {"Reset-All", "reset"},
					{"Health Items", "healthSpawn"}, {"Jump Items", "jumpSpawn"},
					{"Knife Items", "knifeSpawn"}, {"Speed Items", "speedSpawn"},
					{"Infinite Knives", "infiniteKnives"}, {"Infinite Speed", "infiniteSpeed"},
					{"Poison", "poison"}, {"Life Steal", "lifeSteal"}}
	self.menu = Menu(self.game, self.buttons, 100, 100, love.graphics.getWidth()-200, love.graphics.getHeight()-200)
	self.subscribedToInputs = false
end

function SettingsMenu:load()
	-- run when the level is given control
	love.graphics.setBackgroundColor(0, 0, 0)
	self.subscribedToInputs = true
	self.game.keyboard.settingsMenuSubscribed = true
end

function SettingsMenu:leave()
	-- run when the level no longer has control
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