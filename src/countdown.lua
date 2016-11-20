


require "class"


CountdownScreen = class()


function CountdownScreen:_init(game, countdownTimer)
	self.drawUnder = true
	self.updateUnder = false


	self.game = game
	if countdownTimer then
		self.countdownTimer = countdownTimer+1
		self.maxCountdownTimer = countdownTimer+1
	else
		self.countdownTimer = 3
		self.maxCountdownTimer = 3
	end
	print("I EXIST!")
end

function CountdownScreen:load()
	-- run when the level is given control
	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 72))
	self.countdownTimer = self.maxCountdownTimer
end

function CountdownScreen:leave()
	-- run when the level no longer has control
end

function CountdownScreen:draw()
	love.graphics.setFont(love.graphics.newFont("fonts/joystixMonospace.ttf", 72))
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf(string.sub(self.countdownTimer, 1, 1), 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
end

function CountdownScreen:update(dt)
	self.countdownTimer = self.countdownTimer - dt
	if self.countdownTimer <= 1 then
		self.game:popScreenStack()
	end
end

function CountdownScreen:resize(w, h)
	--
end

function CountdownScreen:keypressed(key, unicode)
	--
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