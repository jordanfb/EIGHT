
require "level"
require "keyboard"
require "mainmenu"
require "countdown"
require "pausemenu"
require "class"
require "settingsmenu"
require "copy"
require "controlsmenu"

Game = class()

-- _init, load, draw, update(dt), keypressed, keyreleased, mousepressed, mousereleased, resize, (drawUnder, updateUnder)

function Game:_init()
	-- these are for draw stacks:
	self.drawUnder = false
	self.updateUnder = false

	-- here are the actual variables
	self.drawFPS = false

	self.mainFont = love.graphics.newFont("fonts/joystixMonospace.ttf", 128)
	self.smallerFont = love.graphics.newFont("fonts/joystixMonospace.ttf", 64)
	self:makeGameSettings()

	self.keyboard = Keyboard(self)
	self.pauseMenu = PauseMenu(self)
	self.settingsMenu = SettingsMenu(self)
	self.controlsMenu = ControlsMenu(self, self.mainFont, love.graphics.newFont("fonts/joystixMonospace.ttf", 32))

	self:loadPlayerImages() -- this loads all the player images once, so we don't have to do it again.

	self.countdownScreen = CountdownScreen(self)
	self.level = Level(self.keyboard, nil, self) -- we should have it load by filename or something.
	self.mainMenu = MainMenu(self)
	self.screenStack = {}
	
	self.bg = love.graphics.newImage('images/bg.png')
	
	self.bgm = love.audio.newSource("music/battlemusic.mp3")
	self.bgm:setVolume(0.9) -- 90% of ordinary volume
	self.bgm:setLooping( true )
	if self.gameSettings.playMusic then
		self.bgm:play()
	end

	self.healthItemImage = love.graphics.newImage('images/health-item.png')
	self.knifeItemImage = love.graphics.newImage('images/knife-item.png')
	self.jumpItemImage = love.graphics.newImage('images/jump-item.png')
	self.speedItemImage = love.graphics.newImage('images/speed-item.png')
	self.platformItemImage = love.graphics.newImage('images/platform-item.png')
	self.reviveItemImage = love.graphics.newImage('images/revive-item.png')
	self.swordItemImage = love.graphics.newImage('images/sword-item.png')
	self.rainbowItemImage = love.graphics.newImage('images/rainbow-item.png')

	self.batImages = {}
	for i = 1, 4 do
		table.insert(self.batImages, love.graphics.newImage('images/bat-'..i..'.png'))
	end
	
	self:addToScreenStack(self.mainMenu)
	self.screenshakeDuration = 0
	self.screenshakeMagnitude = 0
	
	self.batSpeed = {}
	self.batSpeed[2] = 1.25
	self.batSpeed[3] = 1.5
end

function Game:loadScores()
	-- Score loading:
	self.scoreFilename = "coop-scores.txt"
	self.scoreData = self:loadTable(self.scoreFilename, "coop_score")
	self.highScore = {}
	self.highScoreDisplayText = ""
	self.highScore, self.highScoreDisplayText = self:findBestScore(self.scoreData)
end

function Game:makeGameSettings()
	self.defaultSettings = {
		knives = "on",
		superJumps = "on",
		speedUps = "on",
		platforms = "on",
		bats = "off",
		swords = "on",
		rainbows = "on",
		gameMode = "versus",
		difficulty = "easy",
		screenShake = "normal",
		itemSpawn = "normal",
		healthSpawn = true,
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
	}

	self.coopSettings = {
		knives = "on",
		superJumps = "off",
		speedUps = "off",
		platforms = "off",
		bats = "on",
		swords = "off",
		healthSpawn = false,
		instantKill = false, --Man that'd be so Kayne
		lifeSteal = false, -- harming other people gives you health
		poison = false,
		regen = false,
		takeFallingOutOfWorldDamage = true
	}

	self.oldSettings = {}

	
	self.settingOptions = {knives = {"on", "off", "always"},
						   superJumps = {"on", "off", "always"},
						   speedUps = {"on", "off", "always"},
						   platforms = {"on", "off", "always"},
						   gameMode = {"versus", "co-op"},
						   swords = {"on", "off", "always"},
						   difficulty = {"easy", "medium", "hard"},
						   screenShake = {"normal", "extreme", "off"},
						   itemSpawn = {"normal", "many", "rediculous", "almost none", "few"},
-- =======
-- 						   bats = {"on", "off", "co-op"},
-- >>>>>>> Coopbranch
						   default = {"on", "off"}} 
	
	self.gameSettings = clone(self.defaultSettings)
	
	self.gameSettingRates = {
			knife = 3,
			health = 1,
			jump = 3,
			speed = 3,
			bat = 2,
			platforms = 1,
			swords = 2,
			numberJumps = 5,
			rainbows = .5,
			punchTime = 1, -- I don't think this is functional
			kickTime = 1, -- I don't think this is functional
			knifeTime = 1,
			punchDamage = 20,
			kickDamage = 40,
			knifeDamage = 30,
			swordDamage = 40,
			lifeStealPercent = 50, -- the percentage of life stolen, out of 100
			poisonRate = 1, -- per second
			regenRate = 1, -- per second
			suddenDeathOnNumberOfPeople = 2,
			noItemsAtNumberOfPeople = 2,
			noHealthAtNumberOfPeople = 2,
			fallingOutOfWorldDamage = 40,
			healthGainOnKillAmount = 20,
			healthPickupAmount = 30
		} -- jumping?
end

function Game:recordNewScore(scoreTable)
	-- table will have #players, map, difficulty, num bats killed, stage gotten to.
	self:saveTable(scoreTable, self.scoreFilename)
	table.insert(self.scoreData, scoreTable)
	self.highScore, self.highScoreDisplayText = self:findBestScore(self.scoreData)
end

function Game:findBestScore(scoreTable)
	local bestScore = {}
	local bestStage = -1
	local bestBats = -1
	if self.scoreData == nil then
		return -1
	end
	for k, score in pairs(scoreTable) do
		if score.difficulty == self.gameSettings.difficulty then
			if score.stage > bestStage then
				bestStage = score.stage
				bestBats = score.batskilled
				bestScore = score
			elseif score.stage == bestStage then
				if score.batskilled > bestBats then
					bestBats = score.batskilled
					bestScore = score
				end
			end
		end
	end
	local displayText = ""
	if bestStage ~= -1 then
		displayText = "Stage: "..tostring(bestStage).." Bats Killed: "..tostring(bestBats)
	end
	return bestScore, displayText
end

function Game:loadTable(filename, tableBreakString)
	local fn = filename or self.scoreFilename
	local startPoint = tableBreakString or "coop_score"
	local t = {}
	-- print(love.filesystem.getIdentity())
	-- for k, v in pairs(love.filesystem.getDirectoryItems(love.filesystem.getAppdataDirectory())) do
	-- 	print(v)
	-- end
	if love.filesystem.exists(fn) then
		-- read the file
		local subTable = {}
		local key = ""
		local value = ""
		local state = 0
		for line in love.filesystem.lines(fn) do
			if line ~= "" and string.sub(line, 1, 1) ~= "#" then
				if line == startPoint then
					state = 1 -- loading keys/values
				elseif line == startPoint .. "_end" then
					table.insert(t, clone(subTable))
					state = 0 -- looking for startpoint state
				elseif state == 1 then
					-- set the key
					key = line
					state = 2 -- the value setting state
				elseif state == 2 then
					-- add the key value pair to the table and set state to 1
					subTable[key] = tonumber(line) or line
					-- ^ if it's a number make it a number
					state = 1
				end
			end
		end
	-- else
	-- 	error("TRIED TO READ SOMETHING THAT DIDN'T EXIST") -- it could not happen, so don't do this.
	end
	return t
end

function Game:makeTableString(t, tableName)
	local s = tableName.."\n" or "coop_score\n"
	for k, v in pairs(t) do
		s = s .. tostring(k) .. "\n" .. tostring(v) .. "\n"
	end
	if tableName then
		s = s .. tableName .. "_end\n"
	else
		s = s .. "coop_score_end\n"
	end
	return s
end

function Game:saveTable(inTable) -- inTable, filename
	local fn = filename or self.scoreFilename
	if love.filesystem.exists(fn) then
		return love.filesystem.append(fn, self:makeTableString(inTable, "coop_score"))
	else
		return love.filesystem.write(fn, self:makeTableString(inTable, "coop_score"))
	end
end

function Game:changeSetting(setting)
	if not self.settingOptions[setting] then
		self.gameSettings[setting] = not self.gameSettings[setting]
	else
		for i, v in ipairs(self.settingOptions[setting]) do
			if i == #self.settingOptions[setting] then
				self.gameSettings[setting] = self.settingOptions[setting][1]
				break
			elseif v == self.gameSettings[setting] then
				self.gameSettings[setting] = self.settingOptions[setting][i+1]
				break
			end
		end
	end
end

function Game:startScreenshake(time, intensity)
	if self.gameSettings.screenShake == "off" then
		intensity = 0
	elseif self.gameSettings.screenShake == "extreme" then
		intensity = 3*intensity
		time = 2*time
	end
	if self.gameSettings.screenShake then
		self.screenshakeDuration = time
		self.screenshakeMagnitude = intensity
	end
end

function Game:load(args)
	self:loadScores()
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
end

function Game:resize(w, h)
	for i = 1, #self.screenStack, 1 do
		self.screenStack[i]:resize(w, h)
	end
	self.level:resize(w, h)
end

function Game:loadPlayerImages()
	-- load the correct images by appending things to the default filename
	self.playerImages = {}
	for color = 1, 8 do
		self.playerImages[color] = {}
		self.playerImages[color].breathImages = {}
		for i = 1, 4, 1 do
			self.playerImages[color].breathImages[i] = love.graphics.newImage('images/'..color..'-breath-'..i..'.png')
		end 
		
		self.playerImages[color].runImages = {}
		for i = 1, 6, 1 do
			self.playerImages[color].runImages[i] = love.graphics.newImage('images/'..color..'-run-'..i..'.png')
		end
		
		self.playerImages[color].hitImages = {}
		for i = 1, 4, 1 do
			self.playerImages[color].hitImages[i] = love.graphics.newImage('images/'..color..'-hit-'..i..'.png')
		end
		
		self.playerImages[color].kickImages = {}
		for i = 1, 5, 1 do
			self.playerImages[color].kickImages[i] = love.graphics.newImage('images/'..color..'-kick-'..i..'.png')
		end
		
		self.playerImages[color].duckImage = love.graphics.newImage('images/'..color..'-duck-1.png')
		
		self.playerImages[color].jumpImage = love.graphics.newImage('images/'..color..'-jump.png')
	end
	for playerNum = 1, 8 do
		if playerNum > 8 then
			self.playerImages[playerNum] = {}
		end
		self.playerImages[playerNum].pImage = love.graphics.newImage('images/'..playerNum..'-p.png')
	end
	self.knifeImages = {}
	self.knifeImages.attack = {}
	for i = 1, 5 do
		table.insert(self.knifeImages.attack, love.graphics.newImage('images/sword-attack-'..i..'.png'))
	end
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