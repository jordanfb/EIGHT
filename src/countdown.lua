


require "class"


CountdownScreen = class()


function CountdownScreen:_init(game, countdownTimer)
	self.drawUnder = true
	self.updateUnder = false


	self.game = game
	self.useMessages = true
	self.messageIndex = 1.25
	self.countdownMessages = {"Ready", "GO!"}

	if countdownTimer then
		self.countdownTimer = countdownTimer+1
		self.maxCountdownTimer = countdownTimer+1
	else
		self.countdownTimer = 4
		self.maxCountdownTimer = 4
	end

	self.showFPSwasOn = false
end

function CountdownScreen:load()
	-- run when the level is given control
	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 72))
	self.countdownTimer = self.maxCountdownTimer
	self.messageIndex = 1
	self.showFPSwasOn = self.game.drawFPS
	self.game.drawFPS = false
end

function CountdownScreen:leave()
	-- run when the level no longer has control
	self.game.drawFPS = self.showFPSwasOn
end

function CountdownScreen:draw()
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.setColor(255, 255, 255, 255)
	if self.useMessages then
		love.graphics.printf(self.countdownMessages[math.floor(self.messageIndex)], 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
	else
		love.graphics.printf(math.floor(self.countdownTimer), 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
	end
end

function CountdownScreen:update(dt)
	if self.useMessages then
		self.messageIndex = self.messageIndex + dt
		if self.messageIndex > #self.countdownMessages + .25 then
			self.game:popScreenStack(false) -- don't load the next screen, but go to it
			self.game:startScreenshake(.15, 10)
		end
	else
		self.countdownTimer = self.countdownTimer - dt
		if self.countdownTimer <= 1 then
			self.game:popScreenStack(false) -- don't load the next screen, since it will then reload the level
		end
	end
end

function CountdownScreen:resize(w, h)
	--
end

function CountdownScreen:keypressed(key, unicode)
	if key == "back" or key == "escape" then
		self.game:popScreenStack()
		self.game:popScreenStack()
		self.game.mainMenu:endPlay()
	end
end

function CountdownScreen:keyreleased(key, unicode)
	--
end

function CountdownScreen:mousepressed(x, y, button)
	--
end

function CountdownScreen:mousereleased(x, y, button)
	--
end