

require "class"


Attacks = class()




function Attacks:_init(level, players)
	self.level = level
	self.players = players
	self.attacks = {}
	-- {x, y, width, height, color, damage?, facing}
end

function Attacks:checkCollisions(player, playerX, playerY, playerWidth, playerHeight)
	-- {x, y, width, height, color, damage?}
	for k, attack in pairs(self.attacks) do
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

function Attacks:draw()
	love.graphics.setColor(0, 0, 255)
	for k, attack in pairs(self.attacks) do
		love.graphics.rectangle("fill", attack[1], attack[2], attack[3], attack[4])
	end
end