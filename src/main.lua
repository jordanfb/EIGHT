io.stdout:setvbuf("no") -- this is so that sublime will print things when they come (rather than buffering).

local debug = false

require "game"
require "class"


local game = Game()


function love.load(args)
	math.randomseed(os.time())
	love.filesystem.setIdentity('EIGHT')
	
	game:load(args)
	--local width, height = 512, 256
	local width, height = 1920, 1080
	love.window.setMode(width/2, height/2, {resizable = true, fullscreen = true})
	-- not much here
	game:resize(width, height)
	love.mouse.setVisible(false)
end

function love.resize(w, h)
	game:resize(w, h)
end

function love.draw()
	game:draw()
end

function love.update(dt)
	--print(1/dt) -- the framerate, I think.
	game:update(dt)
end

function love.keypressed(key, unicode)
	if debug == true and key == "F3" then
		local screenshot = love.graphics.newScreenshot()
		screenshot:encode('png', os.time()..'.png')
	end
	if key == "escape" then
		if #game.screenStack == 1 then
			love.event.quit()
		-- else
		-- 	game:popScreenStack() -- this is temporary, in reality it should bring up a pause menu if you're in level.
		end
	end
	game:keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
	game:keyreleased(key, unicode)
end

function love.mousepressed(x, y, button)
	game:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	game:mousereleased(x, y, button)
end

function love.quit()
	game:quit()
end

function love.joystickadded(joystick)
	game:joystickadded(joystick)
end

function love.joystickremoved(joystick)
	game:joystickremoved(joystick)
end

function love.gamepadpressed(gamepad, button)
	game:gamepadpressed(gamepad, button)
end

function love.gamepadreleased(gamepad, button)
	game:gamepadreleased(gamepad, button)
end

function love.gamepadaxis( joystick, axis, value )
	game:gamepadaxis(joystick, axis, value)
end
