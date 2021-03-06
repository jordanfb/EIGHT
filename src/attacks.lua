require "class"

Attacks = class()

function Attacks:_init(level, players, game)
	self.game = game
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
				if player.color ~= attack[5] and not attack[9+player.playerNumber] then
					-- then it's not the same color, so do damage
					if player.health ~= 0 then
						-- otherwise ignore it, since it's already dead
						if attack[6] == self.game.gameSettingRates.punchDamage and self.game.gameSettings.punching then -- a punch
							self.game:startScreenshake(.15, 2)
							player.health = math.max(player.health - attack[6], 0)
							if self.game.gameSettings.instantKill then
								player.health = 0
								self.game:startScreenshake(.25, 10)
							end
							player.attackedTimer = 10
							attack[9+player.playerNumber] = true
						elseif attack[6] == self.game.gameSettingRates.kickDamage and self.game.gameSettings.kicking then -- a kick
							self.game:startScreenshake(.15, 5)
							player.health = math.max(player.health - attack[6], 0)
							if self.game.gameSettings.instantKill then
								player.health = 0
								self.game:startScreenshake(.25, 10)
							end
							player.attackedTimer = 10
							attack[9+player.playerNumber] = true
						elseif attack[6]==self.game.gameSettingRates.swordDamage then
							self.game:startScreenshake(.15, 5)
							player.health = math.max(player.health - attack[6], 0)
							if self.game.gameSettings.instantKill then
								player.health = 0
								self.game:startScreenshake(.25, 10)
							end
							player.attackedTimer = 10
							attack[9+player.playerNumber] = true
						end
						if self.game.gameSettings.lifeSteal or self.game.gameSettings.healthGainOnKill then
							-- steal life for the player who did the attack.
							for k, v in pairs(self.players) do
								if v.color == attack[5] then
									-- give that person the life!
									if self.game.gameSettings.lifeSteal then
										v.health = math.min(v.health + attack[6]*self.game.gameSettingRates.lifeStealPercent/100, 100)
									end
									if self.game.gameSettings.healthGainOnKill then
										v.heatlh = math.min(v.health + self.game.gameSettingRates.healthGainOnKillAmount, 100)
									end
									break
								end
							end
						end
					end
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
	for i = 1, #self.level.items, 1 do
		for j = self.firstAttack, #self.attacks, 1 do
			local attack = self.attacks[j]
			if self.level.items[i] then
				if attack[1] + attack[3] > self.level.items[i].x and attack[1] < self.level.items[i].x + self.level.items[i].width then
					if attack[2] + attack[4] > self.level.items[i].y and attack[2] < self.level.items[i].y + self.level.items[i].height then
						-- it's a hit by at least someone
						for k = 1, #self.level.players, 1 do
							if (self.level.players[k].playerNumber == attack[9]) then
								if self.level.items[i].itemType == "health" then
									if self.game.gameSettings.noHealthLimit then
										self.level.players[k].health = self.level.players[k].health + self.game.gameSettingRates.healthPickupAmount
									else
										self.level.players[k].health = math.min(self.level.players[k].health + self.game.gameSettingRates.healthPickupAmount, 100)
									end
								elseif self.level.items[i].itemType == "knife" then
									self.level.players[k].numKnives = self.level.players[k].numKnives + 1
								elseif self.level.items[i].itemType == "jump" then
									self.level.players[k].superJumps = self.game.gameSettingRates.numberJumps
								elseif self.level.items[i].itemType == "speed" then
									self.level.players[k].speedUp = 500
								elseif self.level.items[i].itemType == "platform" then
									self.level.players[k].hasPlatforms = 2
								elseif self.level.items[i].itemType == "rainbow" then
									self.level.players[k].rainbow = 100
								elseif self.level.items[i].itemType == "bat" then
									self.level:creatureKilled("bat")
								elseif self.level.items[i].itemType == "revive" then
									for n, player in ipairs(self.level.players) do
										if player.health == 0 then
											player.dead = false
											player.health = 50
											player.y = -player.height
											player.dy = 0
										elseif player.health < 50 then
											player.health = 50
										end
									end
								elseif self.level.items[i].itemType == "sword" then
									self.level.players[k].hasSword = 500
								end
								self.game:startScreenshake(.15, 1)
								table.remove(self.level.items, i)
							end
						end
					end
				end
			end
		end
	end
end

function Attacks:draw()
	love.graphics.setColor(255, 0, 0)
	for i = self.firstAttack, #self.attacks, 1 do
		local attack = self.attacks[i]
		if (attack[6] == self.game.gameSettingRates.punchDamage and self.game.gameSettings.punching) or (attack[6] == self.game.gameSettingRates.kickDamage and self.game.gameSettings.kicking) or attack[6]==self.game.gameSettingRates.swordDamage then
			if attack[8]>12 then
				love.graphics.draw(self.attackImages[6-math.ceil((attack[8]-10)/2)], attack[1], attack[2])
			else
				love.graphics.draw(self.attackImages[5], attack[1], attack[2])
			end
		end
	end
end

function Attacks:newAttack(x, y, width, height, color, damage, facing, time, playerNumber)
	self.attacks[#self.attacks+1] = {x, y, width, height, color, damage, facing, time, playerNumber, false, false, false, false, false, false, false, false}
end