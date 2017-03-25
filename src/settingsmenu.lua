



require "class"
require "menu"
require "copy" 

SettingsMenu = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function SettingsMenu:_init(game)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false
	self.game = game
	self.versusButtons = {{"Back", "back", "action"}, {"Reset-All", "reset", "action"}, {"Randomize", "random", "action"}, {"All off", "alloff", "action"}, {"Game Mode", "gameMode"},
						  {"Health Items", "healthSpawn"}, {"Jump Items", "superJumps"}, {"Knife Items", "knives"}, {"Speed Items", "speedUps"}, {"Platform Items", "platforms"},
						  {"Sword Items", "swords"}, {"Bats", "bats"},  {"Poison", "poison"}, {"Life Steal", "lifeSteal"}, {"Life Regen", "regen"},
						  {"Item Spawning", "itemSpawn"}, {"Screen Shake", "screenShake"}, {"Fall Damage", "takeFallingOutOfWorldDamage"}, {"Play Music", "playMusic"}}

	self.coopButtons = {{"Back", "back", "action"}, {"Reset-All", "reset", "action"}, {"Randomize", "random", "action"}, {"All off", "alloff", "action"}, {"Game Mode", "gameMode"},
						{"Difficulty", "difficulty"}, {"Play Music", "playMusic"}}
	
	self.buttons = clone(self.versusButtons)
	
	self.wasGameMode = "versus"
					
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
	if self.game.gameSettings.gameMode == "co-op" and self.wasGameMode == "versus" then
		self.buttons = clone(self.coopButtons)
		self.menu = Menu(self.game, self.buttons, 100, 100, love.graphics.getWidth()-200, love.graphics.getHeight()-200, 4)
		self.wasGameMode = "co-op"
		
		-----SET UP CO-OP!!! -----
		self.game.oldSettings = clone(self.game.gameSettings)
		for i, v in pairs(self.game.coopSettings) do
			self.game.gameSettings[i] = v
		end
		
		--set team colors
		for i, v in pairs(self.game.mainMenu.playerMenus) do
			self.game.mainMenu.playerMenus[i].playerValues.color = 1
			self.game.mainMenu.playerColors[self.game.mainMenu.playingPlayers[i].playerNumber] = 1
		end
		self.game.gameSettingRates.bat = 16
		
	elseif self.game.gameSettings.gameMode == "versus" and self.wasGameMode == "co-op" then
		self.buttons = clone(self.versusButtons)
		self.menu = Menu(self.game, self.buttons, 100, 100, love.graphics.getWidth()-200, love.graphics.getHeight()-200, 4)
		self.wasGameMode = "versus"
		self.game.gameSettings = clone(self.game.oldSettings)
		self.game.gameSettings.gameMode = "versus"
		self.game.gameSettingRates.bat = 2
	end
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