lmc_assign_keyboard('ONE');
lmc_assign_keyboard('TWO');
lmc_assign_keyboard('THREE');
lmc_assign_keyboard('FOUR');

lmc_set_handler('ONE', function(button, direction)
	if (direction == 1) then -- it's a key press
		if (button == string.byte('A')) then lmc_send_keys('f1')
		elseif (button == string.byte('W')) then lmc_send_keys('f2')
		elseif (button == string.byte('D')) then lmc_send_keys('f2')
		elseif (button == string.byte('S')) then lmc_send_keys('f3')
		elseif (button == string.byte('C')) then lmc_send_keys('f4')
	        elseif (button == string.byte('V')) then lmc_send_keys('f5')

		elseif (button == string.byte('J')) then lmc_send_keys('f6')
		elseif (button == string.byte('I')) then lmc_send_keys('f7')
		elseif (button == string.byte('L')) then lmc_send_keys('f8')
		elseif (button == string.byte('O')) then lmc_send_keys('f9')
		elseif (button == string.byte('P')) then lmc_send_keys('f20')
                end
		return
	else
		if (button == string.byte('A')) then lmc_send_keys('`')
		elseif (button == string.byte('W')) then lmc_send_keys('1')
		elseif (button == string.byte('D')) then lmc_send_keys('2')
		elseif (button == string.byte('S')) then lmc_send_keys('3')
		elseif (button == string.byte('C')) then lmc_send_keys('4')
		elseif (button == string.byte('V')) then lmc_send_keys('5')

		elseif (button == string.byte('J')) then lmc_send_keys('6')
		elseif (button == string.byte('I')) then lmc_send_keys('7')
		elseif (button == string.byte('L')) then lmc_send_keys('8')
		elseif (button == string.byte('O')) then lmc_send_keys('9')
		elseif (button == string.byte('P')) then lmc_send_keys('0')

		else print('invalid')
		end
	end
end)




lmc_set_handler('TWO', function(button, direction)
	if (button == string.byte('A')) then lmc_send_keys('Q')
	elseif (button == string.byte('W')) then lmc_send_keys('W')
	elseif (button == string.byte('D')) then lmc_send_keys('E')
	elseif (button == string.byte('C')) then lmc_send_keys('R')
	elseif (button == string.byte('V')) then lmc_send_keys('T')

	elseif (button == string.byte('J')) then lmc_send_keys('Y')
	elseif (button == string.byte('I')) then lmc_send_keys('U')
	elseif (button == string.byte('L')) then lmc_send_keys('I')
	elseif (button == string.byte('O')) then lmc_send_keys('O')
	elseif (button == string.byte('P')) then lmc_send_keys('P')

	else print('invalid')
	end
end)


lmc_set_handler('THREE', function(button, direction)
	if (button == string.byte('A')) then lmc_send_keys('A')
	elseif (button == string.byte('W')) then lmc_send_keys('S')
	elseif (button == string.byte('D')) then lmc_send_keys('D')
	elseif (button == string.byte('C')) then lmc_send_keys('F')
	elseif (button == string.byte('V')) then lmc_send_keys('G')

	elseif (button == string.byte('J')) then lmc_send_keys('H')
	elseif (button == string.byte('I')) then lmc_send_keys('J')
	elseif (button == string.byte('L')) then lmc_send_keys('K')
	elseif (button == string.byte('O')) then lmc_send_keys('L')
	elseif (button == string.byte('P')) then lmc_send_keys(';')

	else print('invalid')
	end
end)


lmc_set_handler('FOUR', function(button, direction)
	if (button == string.byte('A')) then lmc_send_keys('Z')
	elseif (button == string.byte('W')) then lmc_send_keys('X')
	elseif (button == string.byte('D')) then lmc_send_keys('C')
	elseif (button == string.byte('C')) then lmc_send_keys('V')
	elseif (button == string.byte('V')) then lmc_send_keys('B')

	elseif (button == string.byte('J')) then lmc_send_keys('N')
	elseif (button == string.byte('I')) then lmc_send_keys('M')
	elseif (button == string.byte('L')) then lmc_send_keys(',')
	elseif (button == string.byte('O')) then lmc_send_keys('.')
	elseif (button == string.byte('P')) then lmc_send_keys('/')

	else print('invalid')
	end
end)

