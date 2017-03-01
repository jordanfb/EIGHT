require "class"

MainMenu = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function MainMenu:_init(game)
	-- this is for the draw stack
	self.drawUnder = false
	self.updateUnder = false

	self.game = game
	self.keyboard = self.game.keyboard
	self.mapInputsToPlayers = {}
	self.mapPlayersToInputs = {} -- the input num for the player num
	for i = 1, 8 do
		self.mapPlayersToInputs[i] = {connected = false, input = 0}
	end

	self.bg = love.graphics.newImage('images/bg.png')

	self.zoom = 10
	self.playingPlayers = {}

	self.SCREENWIDTH = 1920
	self.SCREENHEIGHT = 1080
	self.menuCanvas = love.graphics.newCanvas(self.SCREENWIDTH, self.SCREENHEIGHT)

	self:createDefaultPlayers()
end

function MainMenu:createDefaultPlayers()
	self.players = {Player(self.game.level, self.keyboard, 100, 100, 1, 0),
					Player(self.game.level, self.keyboard, 900+100, 100, 5, 4),
					Player(self.game.level, self.keyboard, 300+25, 100, 2, 1),
					Player(self.game.level, self.keyboard, 1100+125, 100, 6, 5),
					Player(self.game.level, self.keyboard, 500+50, 100, 3, 2),
					Player(self.game.level, self.keyboard, 1300+150, 100, 7, 6),
					Player(self.game.level, self.keyboard, 700+75, 100, 4, 3),
					Player(self.game.level, self.keyboard, 1500+175, 100, 8, 7),
					}

	self.playerKeys = {{"`", "1", "2", "3", "4", "5"}, {"7", "8", "9", "0", "-", "="}, {"q", "w", "e", "r", "t", "y"}, {"u", "i", "o", "p", "[", "]"},
						{"a", "s", "d", "f", "g", "h"}, {"j", "k", "l", ";", "'", "return"}}
	if self.keyboard.wasd then
		self.playerKeys[7] = {"6", "z", "x", "c", "v", "b"}
		self.playerKeys[8] = {"n", "m", ",", ".", "/", "\\"}
	else
		self.playerKeys[7] = {"lshift", "z", "x", "c", "v", "b"}
		self.playerKeys[8] = {"n", "m", ",", ".", "/", "rshift"}
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

	-- this is for resetting the settings at the end of each match, this is an absolutely horrible place to put it
	-- but the code's already a mess...
	-- it needs to exist because of the way final showdowns (fewer than X players) are coded (by me, heh).
	self.game.gameSettings = self.gameSettingsBackup or self.game.gameSettings
	self.game.gameSettingRates = self.gameSettingRatesBackup or self.game.gameSettingRates
	self.keyboard.mainmenuSubscribed = true -- starts the keyboard getting every input press
end

function MainMenu:leave()
	-- run when the level no longer has control
	if self.fpsWasOn then
		self.game.drawFPS = true
	end
	self.game.level.players = self.playingPlayers -- just be a dick and overwrite it
	self.gameSettingsBackup = self:copyTable(self.game.gameSettings)
	self.gameSettingRatesBackup = self:copyTable(self.game.gameSettingRates)
	self.keyboard.mainmenuSubscribed = false -- stop the keyboard from sending this every keypress
end

function MainMenu:copyTable(t)
	local newT = {}
	for k, v in pairs(t) do
		newT[k] = v
	end
	return newT
end

function MainMenu:draw()
	love.graphics.setCanvas(self.menuCanvas)
	love.graphics.clear()
	-- now start the drawing
	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 128))
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf("EIGHT", 0, self.SCREENHEIGHT/6, self.SCREENWIDTH, "center")
	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 64))
	love.graphics.printf("Controls are wasd+cv or ijkl+./", 0, self.SCREENHEIGHT/3, self.SCREENWIDTH, "center")
	love.graphics.printf("Press any key to join", 0, self.SCREENHEIGHT/2, self.SCREENWIDTH, "center")
	love.graphics.printf("Click the mouse to start", 0, self.SCREENHEIGHT*2/3, self.SCREENWIDTH, "center")

	-- print("COLORS"..#self.playingPlayers)
	if #self.playingPlayers > 0 then
		for k, v in pairs(self.playingPlayers) do
			-- print("color: "..self.playingPlayers[i].color)
			love.graphics.draw(v.pImage, self.SCREENWIDTH*(v.color+1)/(9), self.SCREENHEIGHT - 100)
		end
	end


	-- now be done with the drawing
	love.graphics.setCanvas()
	love.graphics.setColor(255, 255, 255)

	love.graphics.draw(self.bg)
	love.graphics.draw(self.menuCanvas, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, self.zoom*love.graphics.getWidth()/self.SCREENWIDTH, self.zoom*love.graphics.getHeight()/self.SCREENHEIGHT, self.SCREENWIDTH/2, self.SCREENHEIGHT/2)

	-- love.graphics.draw(self.menuCanvas, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, self.zoom*love.graphics.getWidth()/self.SCREENWIDTH, self.zoom*love.graphics.getHeight()/self.SCREENHEIGHT, love.graphics.getWidth()/2, love.graphics.getHeight()/2)

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
	if self.zoom > 1 then
		self.zoom = self.zoom - dt*10
	elseif self.zoom < 1 then
		self.zoom = 1
	end
end

function MainMenu:resize(w, h)
	--
end

function MainMenu:addInputToPlayerMap(inputNum)
	if self.mapInputsToPlayers[inputNum] ~= nil then
		if self.mapPlayersToInputs[self.mapInputsToPlayers[inputNum]].input == inputNum then
			-- then it hasn't been snapped up yet, so take it!
			self.mapPlayersToInputs[self.mapInputsToPlayers[inputNum]].connected = true
			self:addPlayerToGame(inputNum, self.mapInputsToPlayers[inputNum])
			print("connected an input to its previous player")
			return true
		end
		self.mapInputsToPlayers[inputNum] = nil
		print("unable to connect an input to its previous player")
	end
	for k, v in pairs(self.mapPlayersToInputs) do
		if not v.connected then
			-- it's free for the taking
			v.connected = true
			v.input = inputNum
			self.mapInputsToPlayers[inputNum] = k
			self:addPlayerToGame(inputNum, k)
			print("connected an input to a new player")
			return true
		end
	end
	print("Unable to connect an input to a player")
	return false
end

function MainMenu:inputMade(inputNum, input, pressValue)
	if pressValue > 0 then
		if input == "disconected" and self.mapInputsToPlayers[inputNum] ~= nil then
			self.mapPlayersToInputs[self.mapInputsToPlayers[inputNum]].connected = false
			self:removePlayerFromGame(self.mapInputsToPlayers[inputNum])
			-- self.mapInputsToPlayers[inputNum] == nil -- not actually certain if this line should exist...
			print("disconected a player because joystick is gone. inputNum: "..inputNum)
			return
		end
		print("input source "..inputNum)
		if self.mapInputsToPlayers[inputNum] == nil then
			-- it's a new player! yay!
			-- print("found new input source")
			self:addInputToPlayerMap(inputNum)
		else
			-- print("previously connected input")
		end
		-- print("did stuff "..input)
	end
end

function MainMenu:addPlayerToGame(inputNum, playerNum)
	print("PLAYER NUMBER IS "..tostring(playerNum))
	for k = 1, #self.playingPlayers, 1 do -- should prevent joining twice
		if self.playingPlayers[k].playerNumber == playerNum then
			-- print("EXITED EARLY")
			return
		end
	end
	local k = 1
	self.players[playerNum].inputNumber = inputNum
	if #self.playingPlayers == 0 then
		-- print("ADDED AT 1")
		table.insert(self.playingPlayers, self.players[playerNum])
	else
		while k <= #self.playingPlayers and self.playingPlayers[k].color < self.players[playerNum].color do
			k = k + 1
		end
		-- print("ADDED ELSEWHERE")
		table.insert(self.playingPlayers, k, self.players[playerNum])
	end
end

function MainMenu:removePlayerFromGame(playerNum)
	for k = 1, #self.playingPlayers, 1 do -- should prevent joining twice
		if self.playingPlayers[k].playerNumber == playerNum then
			table.remove(self.playingPlayers, k)
			print("REMOVED PLAYER "..playerNum.." FROM PLAYING PLAYERS")
			return
		end
	end
end

function MainMenu:keypressed(key, unicode)
	if key == "space" or key == "start" then
		if #self.playingPlayers >= 2 then -- at least two players, technically two from the same team could do it though
			self.game:addToScreenStack(self.game.level)
			self.game:addToScreenStack(self.game.countdownScreen)
		else
			print("NOT ENOUGH PLAYERS")
		end
	end
	-- for i = 1, #self.playerKeys, 1 do
	-- 	for j = 1, #self.playerKeys[i], 1 do
	-- 		if self.playerKeys[i][j] == key then
	-- 			-- player i join the game!
	-- 			for k = 1, #self.playingPlayers, 1 do -- should prevent joining twice
	-- 				if self.playingPlayers[k].color == self.players[i].color then
	-- 					return
	-- 				end
	-- 			end
	-- 			local k = 1
	-- 			if #self.playingPlayers == 0 then
	-- 				table.insert(self.playingPlayers, self.players[i])
	-- 			else
	-- 				while k <= #self.playingPlayers and self.playingPlayers[k].color < self.players[i].color do
	-- 					k = k + 1
	-- 				end
	-- 				table.insert(self.playingPlayers, k, self.players[i])
	-- 			end
	-- 		end
	-- 	end
	-- end
end

function MainMenu:keyreleased(key, unicode)
	--
end

function MainMenu:mousepressed(x, y, button)
	-- if not self.keyboard.wasd then
	-- 	-- add the level to the game as a quick default
	-- 	self.game:addToScreenStack(self.game.level)
	-- else
		
	-- end
	if #self.playingPlayers >= 2 then -- at least two players, technically two from the same team could do it though
		self.game:addToScreenStack(self.game.level)
		-- if self.game.countdownScreen then
		-- 	print("is not nil!")
		-- else
		-- 	print("is nil")
		-- end
		self.game:addToScreenStack(self.game.countdownScreen)
	else
		print("NOT ENOUGH PLAYERS!")
	end
end

function MainMenu:mousereleased(x, y, button)
	--
end