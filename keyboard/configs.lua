lmc_assign_keyboard('ONE');
lmc_assign_keyboard('TWO');
lmc_assign_keyboard('THREE');
lmc_assign_keyboard('FOUR');

lmc_set_handler('ONE', function(button, direction)
	if (direction == 1) then -- it's a key press
		if (button == string.byte('A')) then lmc_send_keys('`')
		elseif (button == string.byte('D')) then lmc_send_keys('1')
		elseif (button == string.byte('W')) then lmc_send_keys('2')
		elseif (button == string.byte('S')) then lmc_send_keys('3')
		elseif (button == string.byte('C')) then lmc_send_keys('4')
	    elseif (button == string.byte('V')) then lmc_send_keys('5')

		elseif (button == string.byte('J')) then lmc_send_keys('7')
		elseif (button == string.byte('L')) then lmc_send_keys('8')
		elseif (button == string.byte('I')) then lmc_send_keys('9')
		elseif (button == string.byte('K')) then lmc_send_keys('0')
		elseif (button == 190) then lmc_send_keys('-')
        elseif (button == 191) then lmc_send_keys('=')
        elseif (button == 27) then lmc_send_keys('{ESC}')
        end
		return
	else
		if (button == string.byte('A')) then lmc_send_keys('{SPACE}`')
		elseif (button == string.byte('D')) then lmc_send_keys('{SPACE}1')
		elseif (button == string.byte('W')) then lmc_send_keys('{SPACE}2')
		elseif (button == string.byte('S')) then lmc_send_keys('{SPACE}3')
		elseif (button == string.byte('C')) then lmc_send_keys('{SPACE}4')
	    elseif (button == string.byte('V')) then lmc_send_keys('{SPACE}5')

		elseif (button == string.byte('J')) then lmc_send_keys('{SPACE}7')
		elseif (button == string.byte('L')) then lmc_send_keys('{SPACE}8')
		elseif (button == string.byte('I')) then lmc_send_keys('{SPACE}9')
		elseif (button == string.byte('K')) then lmc_send_keys('{SPACE}0')
		elseif (button == 190) then lmc_send_keys('{SPACE}-')
        elseif (button == 191) then lmc_send_keys('{SPACE}=')
		end
	end
end)



lmc_set_handler('TWO', function(button, direction)
	if (direction == 1) then -- it's a key press
		if (button == string.byte('A')) then lmc_send_keys('q')
		elseif (button == string.byte('D')) then lmc_send_keys('w')
		elseif (button == string.byte('W')) then lmc_send_keys('e')
		elseif (button == string.byte('S')) then lmc_send_keys('r')
		elseif (button == string.byte('C')) then lmc_send_keys('t')
	    elseif (button == string.byte('V')) then lmc_send_keys('y')

		elseif (button == string.byte('J')) then lmc_send_keys('u')
		elseif (button == string.byte('L')) then lmc_send_keys('i')
		elseif (button == string.byte('I')) then lmc_send_keys('o')
		elseif (button == string.byte('K')) then lmc_send_keys('p')
		elseif (button == 190) then lmc_send_keys('[')
        elseif (button == 191) then lmc_send_keys(']')
        elseif (button == 27) then lmc_send_keys('{ESC}')
        end
		return
	else
		if (button == string.byte('A')) then lmc_send_keys('{SPACE}q')
		elseif (button == string.byte('D')) then lmc_send_keys('{SPACE}w')
		elseif (button == string.byte('W')) then lmc_send_keys('{SPACE}e')
		elseif (button == string.byte('S')) then lmc_send_keys('{SPACE}r')
		elseif (button == string.byte('C')) then lmc_send_keys('{SPACE}t')
	    elseif (button == string.byte('V')) then lmc_send_keys('{SPACE}y')

		elseif (button == string.byte('J')) then lmc_send_keys('{SPACE}u')
		elseif (button == string.byte('L')) then lmc_send_keys('{SPACE}i')
		elseif (button == string.byte('I')) then lmc_send_keys('{SPACE}o')
		elseif (button == string.byte('K')) then lmc_send_keys('{SPACE}p')
		elseif (button == 190) then lmc_send_keys('{SPACE}[')
        elseif (button == 191) then lmc_send_keys('{SPACE}]')
		end
	end
end)

lmc_set_handler('THREE', function(button, direction)
	if (direction == 1) then -- it's a key press
		if (button == string.byte('A')) then lmc_send_keys('a')
		elseif (button == string.byte('D')) then lmc_send_keys('s')
		elseif (button == string.byte('W')) then lmc_send_keys('d')
		elseif (button == string.byte('S')) then lmc_send_keys('f')
		elseif (button == string.byte('C')) then lmc_send_keys('g')
	    elseif (button == string.byte('V')) then lmc_send_keys('h')

		elseif (button == string.byte('J')) then lmc_send_keys('j')
		elseif (button == string.byte('L')) then lmc_send_keys('k')
		elseif (button == string.byte('I')) then lmc_send_keys('l')
		elseif (button == string.byte('K')) then lmc_send_keys(';')
		elseif (button == 190) then lmc_send_keys('\'')
        elseif (button == 191) then lmc_send_keys('{ENTER}')
        elseif (button == 27) then lmc_send_keys('{ESC}')
        end
		return
	else
		if (button == string.byte('A')) then lmc_send_keys('{SPACE}a')
		elseif (button == string.byte('D')) then lmc_send_keys('{SPACE}s')
		elseif (button == string.byte('W')) then lmc_send_keys('{SPACE}d')
		elseif (button == string.byte('S')) then lmc_send_keys('{SPACE}f')
		elseif (button == string.byte('C')) then lmc_send_keys('{SPACE}g')
	    elseif (button == string.byte('V')) then lmc_send_keys('{SPACE}h')

		elseif (button == string.byte('J')) then lmc_send_keys('{SPACE}j')
		elseif (button == string.byte('L')) then lmc_send_keys('{SPACE}k')
		elseif (button == string.byte('I')) then lmc_send_keys('{SPACE}l')
		elseif (button == string.byte('K')) then lmc_send_keys('{SPACE};')
		elseif (button == 190) then lmc_send_keys('{SPACE}\'')
        elseif (button == 191) then lmc_send_keys('{SPACE}{ENTER}')
		end
	end
end)


lmc_set_handler('FOUR', function(button, direction)
	if (direction == 1) then -- it's a key press
		if (button == string.byte('A')) then lmc_send_keys('6')
		elseif (button == string.byte('D')) then lmc_send_keys('z')
		elseif (button == string.byte('W')) then lmc_send_keys('x')
		elseif (button == string.byte('S')) then lmc_send_keys('c')
		elseif (button == string.byte('C')) then lmc_send_keys('v')
	    elseif (button == string.byte('V')) then lmc_send_keys('b')

		elseif (button == string.byte('J')) then lmc_send_keys('n')
		elseif (button == string.byte('L')) then lmc_send_keys('m')
		elseif (button == string.byte('I')) then lmc_send_keys(',')
		elseif (button == string.byte('K')) then lmc_send_keys('.')
		elseif (button == 190) then lmc_send_keys('/')
        elseif (button == 191) then lmc_send_keys('\\')
        elseif (button == 27) then lmc_send_keys('{ESC}')
        end
		return
	else
		if (button == string.byte('A')) then lmc_send_keys('{SPACE}6')
		elseif (button == string.byte('D')) then lmc_send_keys('{SPACE}z')
		elseif (button == string.byte('W')) then lmc_send_keys('{SPACE}x')
		elseif (button == string.byte('S')) then lmc_send_keys('{SPACE}c')
		elseif (button == string.byte('C')) then lmc_send_keys('{SPACE}v')
	    elseif (button == string.byte('V')) then lmc_send_keys('{SPACE}b')

		elseif (button == string.byte('J')) then lmc_send_keys('{SPACE}n')
		elseif (button == string.byte('L')) then lmc_send_keys('{SPACE}m')
		elseif (button == string.byte('I')) then lmc_send_keys('{SPACE},')
		elseif (button == string.byte('K')) then lmc_send_keys('{SPACE}.')
		elseif (button == 190) then lmc_send_keys('{SPACE}/')
        elseif (button == 191) then lmc_send_keys('{SPACE}\\')
		end
	end
end)
