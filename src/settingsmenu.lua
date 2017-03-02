



require "class"
require "menu"

SettingsMenu = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function SettingsMenu:_init(game)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false
	self.game = game
	local b1 = {"Back", "back"}
	local b2 = {"Reset-All", "reset"}
	local b3 = {"Health Items", "healthSpawn"}
	local b4 = {"Jump Items", "jumpSpawn"}
	local b5 = {"Knife Items", "knifeSpawn"}
	local b6 = {"Speed Items", "speedSpawn"}
	local b7 = {"Infinite Knives", "infiniteKnives"}
	local b8 = {"Infinite Speed", "infiniteSpeed"}
	self.buttons = {b1, b2, b3, b4, b5, b6, b7, b8}
	self.menu = Menu(self.game, self.buttons, 100, 100, love.graphics.getWidth()-200, love.graphics.getHeight()-200)
end

function SettingsMenu:load()
	-- run when the level is given control
	love.graphics.setBackgroundColor(255, 255, 255)
end

function SettingsMenu:leave()
	-- run when the level no longer has control
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

function SettingsMenu:keypressed(key, unicode)
	--
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