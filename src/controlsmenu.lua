




require "class"
require "menu"

ControlsMenu = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function ControlsMenu:_init(game, mainFont, smallerFont)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false
	self.game = game
	self.mainFont = mainFont
	self.smallerFont = smallerFont
	self.subscribedToInputs = false
	self.inputNum = 0
	self.menuSelection = 1
	self.menuOptions = {"Swap shit", "Leave"}
	self.keys = {}
end

function ControlsMenu:setInput(input)
	self.inputNum = input
	self.menuSelection = 1
end

function ControlsMenu:load()
	print("Controls loaded (input == "..self.inputNum..")")
	love.graphics.setFont(self.smallerFont)
	self.subscribedToInputs = true
	self.game.keyboard.ControlsMenuSubscribed = true
end

function ControlsMenu:leave()
	-- run when the level no longer has control
	print("controls left")
	self.subscribedToInputs = false
	self.game.keyboard.ControlsMenuSubscribed = false
end

function ControlsMenu:draw()
	love.graphics.printf("Hello world", love.graphics.getWidth()/2-500, love.graphics.getHeight()/3, 1000, "center")
end

function ControlsMenu:update(dt)
	--
end

function ControlsMenu:resize(w, h)
	--
end

function ControlsMenu:inputMade(inputNum, input, pressValue)
	if inputNum ~= self.inputNum then
		-- ignore input made by other controllers
		return
	end
end

function ControlsMenu:keypressed(key, unicode)
	if key == "escape" or key == "back" then
		self.game:popScreenStack()
	end
end

function ControlsMenu:keyreleased(key, unicode)
	--
end

function ControlsMenu:mousepressed(x, y, button)
	--
end

function ControlsMenu:mousereleased(x, y, button)
	--
end