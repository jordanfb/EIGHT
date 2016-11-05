

require "class"


Attacks = class()




function Attacks:_init(level, players)
	self.level = level
	self.players = players
	self.attacks = {}
	-- {x, y, width, height, color, damage?, facing, time}
	self.firstAttack = 1
	
	self.attackImages = {}
	for i=1, 5, 1 do
		self.attackImages[i] = love.graphics.newImage('images/attack-'..i..'.png')
	end
	
	
end

function Attacks:checkCollisions(player, playerX, playerY, playerWidth, playerHeight)
	-- {x, y, width, height, color, damage?, facing, time}
	for i = self.firstAttack, #self.attacks, 1 do
		local attack = self.attacks[i]
		if playerX + playerWidth > attack[1] and playerX < attack[1]+attack[3] then
			if playerY + playerHeight > attack[2] and playerY < attack[2]+attack[4] then
				-- then it hits, so deal the damage.
				-- plus possibly add lots of blood?
				if player.color ~= attack[5] then
					-- then it's not the same color, so do damage
					player.health = player.health - attack[6]
					-- add the knockback!!
				end
			end
		end
	end
end

function Attacks:update(dt)
	for i = self.firstAttack, #self.attacks, 1 do
		local attack = self.attacks[i]
		attack[8] = attack[8]-1
		if attack[8] <= 0 then
			self.firstAttack = self.firstAttack +1
		end
	end
	for i = 1, #self.players, 1 do
		self:checkCollisions(self.players[i], self.players[i].x, self.players[i].y, self.players[i].width, self.players[i].height)
	end
end

function Attacks:draw()
	love.graphics.setColor(255, 0, 0)
	for i = self.firstAttack, #self.attacks, 1 do
		local attack = self.attacks[i]
		if attack[8]>12 then
			love.graphics.draw(self.attackImages[6-math.ceil((attack[8]-10)/2)], attack[1], attack[2])
		else
			love.graphics.draw(self.attackImages[5], attack[1], attack[2])
		end
	end
end

function Attacks:newAttack(x, y, width, height, color, damage, facing, time)
	self.attacks[#self.attacks+1] = {x, y, width, height, color, damage, facing, time}
end