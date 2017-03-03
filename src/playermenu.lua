

require "class"

PlayerMenu = class()


function PlayerMenu:_init(game, mainMenu, level, playerNum, inputNum, font)
	self.game = game
	self.mainMenu = mainMenu
	self.level = level
	self.font = font
	self.mapIndexToValue = {"ready", "color", "controls", "settings", "map", "leave"}
	self.playerValues = {color = 1, controls = 1, ready = 1, settings = 1, map = 1, leave = 1}
	self.playerNum = playerNum
	self.inputNum = inputNum

	self.playerValues.color = playerNum
	self.menuOptions = {{"Not Ready", "Ready"},
						{"Red\nTeam", "Green\nTeam", "Blue\nTeam", "Purple\nTeam", "Orange\nTeam", "Yellow\nTeam", "Teal\nTeam", "Pink\nTeam"},
						{"Controls"}, {"Settings"}, 
						{"Map:\nRandom\nMap", "Map:\nBlue\nMountain", "Map:\nHigh\nTemple",  "Map:\nTom\nPond", "Map:\nPenultimate\nDestination"},
						{"Leave"}}
	for i = 1, #self.menuOptions do
		self.menuPosition = i
		self:changeValue()
	end
	self.menuPosition = 1
end

function PlayerMenu:getTextToDisplay(optionNumber)
	-- returns a string and a boolean, the boolean is whether or not it is adjustable.
	return self.menuOptions[optionNumber][self.playerValues[self.mapIndexToValue[optionNumber]]], #self.menuOptions[optionNumber] > 1
	-- if optionNumber == 2 then
	-- 	-- then cry because this is dependant on what input things you have. This probably launches the input setup
	-- 	return self.menuOptions[2][1], false
	-- elseif optionNumber == 1 then -- the team color name
	-- 	return self.menuOptions[1][self.color], true
	-- elseif optionNumber == 3 then -- the ready state
	-- 	return self.menuOptions[3][self.readyState+1], true
	-- else
	-- 	--
	-- end
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
				love.graphics.rectangle("fill", x-width/2-10-2, y+10, 10, 10) -- the -10 is to subtract the rectangle's width
				love.graphics.rectangle("fill", x+width/2+2, y+10, 10, 10)
			end
		else
			love.graphics.setColor(150, 150, 150)
		end
		love.graphics.printf(text, x-500, y, 1000, "center")
		y = y + 40
		_, count = string.gsub(self.menuOptions[i][1], "\n", "\n")
		for i = 1, count do
			y = y + 30
		end
	end
end

function PlayerMenu:update(dt)
	--
end

function PlayerMenu:listIndexMod(i, listLen)
	if i <= 0 then
		return listLen
	elseif i > listLen then
		i = 1
	end
	return i
end

function PlayerMenu:onLoadScreen()
	self.menuPosition = 1
	self.playerValues.ready = 1
end

function PlayerMenu:changeValue()
	if self.mapIndexToValue[self.menuPosition] == "color" then
		self.mainMenu.playerColors[self.playerNum] = self.playerValues.color-1
	end
end

function PlayerMenu:selectValue()
	if self.mapIndexToValue[self.menuPosition] == "settings" then
		self.game.settingsMenu.menu:setInput(self.inputNum)
		self.game:addToScreenStack(self.game.settingsMenu)
		-- print("ADDING SETTINGS HOPEFULLY? PLEASE?")
	elseif self.mapIndexToValue[self.menuPosition] == "controls" then
		self.game.controlsMenu:setInput(self.inputNum)
		self.game:addToScreenStack(self.game.controlsMenu)
	elseif self.mapIndexToValue[self.menuPosition] == "leave" then
		self.mainMenu:removePlayerFromGame(self.playerNum)
	end
end

function PlayerMenu:inputMade(inputNum, input, pressValue)
	if inputNum ~= self.inputNum then    return    end
	if input == "up" or input == "menuup" then
		self.menuPosition = self.menuPosition - 1
	elseif input == "down" or input == "menudown" then
		self.menuPosition = self.menuPosition + 1
	end
	self.menuPosition = self:listIndexMod(self.menuPosition, #self.menuOptions)

	if #self.menuOptions[self.menuPosition] > 1 then
		if input == "left" or input == "punch" or input == "menuleft" or input == "lookleft" or input == "menupunch" then
			self.playerValues[self.mapIndexToValue[self.menuPosition]] = self.playerValues[self.mapIndexToValue[self.menuPosition]] - 1
			-- return self.menuOptions[optionNumber][self.playerValues[self.mapIndexToValue[optionNumber]]]
		elseif input == "right" or input == "kick" or input == "menuright" or input == "lookright" or input == "menukick" then
			self.playerValues[self.mapIndexToValue[self.menuPosition]] = self.playerValues[self.mapIndexToValue[self.menuPosition]] + 1
		end
		self.playerValues[self.mapIndexToValue[self.menuPosition]] = self:listIndexMod(self.playerValues[self.mapIndexToValue[self.menuPosition]], #self.menuOptions[self.menuPosition])
		self:changeValue()
	else
		if input == "punch" or input == "kick" or input == "menupunch" or input == "menukick" then
			self:selectValue()
		end
	end
end

