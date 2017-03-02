

require "class"

PlayerMenu = class()


function PlayerMenu:_init(game, level, playerNum, inputNum, font)
	self.game = game
	self.level = level
	self.font = font
	self.playerNum = playerNum
	self.inputNum = inputNum
	self.color = playerNum - 1
	self.menuPosition = 1
	self.readyState = 0 -- ready is 1
	self.menuOptions = {{"Team Red", "Team Green", "Team Blue", "Team Purple"}, {"Controls"}, {"Not Ready", "Ready"}}
end

function PlayerMenu:getTextToDisplay(optionNumber)
	-- returns a string and a boolean, the boolean is whether or not it is adjustable.
	if optionNumber == 2 then
		-- then cry because this is dependant on what input things you have. This probably launches the input setup
		return self.menuOptions[2][1], false
	elseif optionNumber == 1 then -- the team color name
		return self.menuOptions[1][(self.color%4)+1], true
	elseif optionNumber == 3 then -- the ready state
		return self.menuOptions[3][self.readyState+1], true
	else
		--
	end
end

function PlayerMenu:draw(globalx, globaly)
	local x = globalx
	local y = globaly
	for i = 1, #self.menuOptions do
		local text, isAdjustable = self:getTextToDisplay(i)
		if i == self.menuPosition then
			love.graphics.setColor(255, 255, 255)
			if isAdjustable then
				-- draw the arrows around the side of the text
				local width = self.font:getWidth(text)
				love.graphics.rectangle("fill", x-width/2-10-10, y-5, 10, 10)
				love.graphics.rectangle("fill", x+width/2+10, y-5, 10, 10)
			end
		else
			love.graphics.setColor(200, 200, 200)
		end
		love.graphics.printf(text, x-500, y, 1000, "center")
		y = y + 60
	end
end

function PlayerMenu:update(dt)
	--
end

function PlayerMenu:inputMade(inputNum, input, pressValue)
	if inputNum ~= self.inputNum then    return    end
	if input == "up" then
		self.menuPosition = self.menuPosition - 1
	elseif input == "down" then
		self.menuPosition = self.menuPosition + 1
	end
	if self.menuPosition < 1 then
		self.menuPosition = #self.menuOptions
	elseif self.menuPosition > #self.menuOptions then
		self.menuPosition = 1
	end
end