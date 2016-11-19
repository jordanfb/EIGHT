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
		if (button == string.byte('A')) then lmc_send_keys(' `')
		elseif (button == string.byte('D')) then lmc_send_keys(' 1')
		elseif (button == string.byte('W')) then lmc_send_keys(' 2')
		elseif (button == string.byte('S')) then lmc_send_keys(' 3')
		elseif (button == string.byte('C')) then lmc_send_keys(' 4')
	    elseif (button == string.byte('V')) then lmc_send_keys(' 5')

		elseif (button == string.byte('J')) then lmc_send_keys(' 7')
		elseif (button == string.byte('L')) then lmc_send_keys(' 8')
		elseif (button == string.byte('I')) then lmc_send_keys(' 9')
		elseif (button == string.byte('K')) then lmc_send_keys(' 0')
		elseif (button == 190) then lmc_send_keys(' -')
        elseif (button == 191) then lmc_send_keys(' =')
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
		if (button == string.byte('A')) then lmc_send_keys(' q')
		elseif (button == string.byte('D')) then lmc_send_keys(' w')
		elseif (button == string.byte('W')) then lmc_send_keys(' e')
		elseif (button == string.byte('S')) then lmc_send_keys(' r')
		elseif (button == string.byte('C')) then lmc_send_keys(' t')
	    elseif (button == string.byte('V')) then lmc_send_keys(' y')

		elseif (button == string.byte('J')) then lmc_send_keys(' u')
		elseif (button == string.byte('L')) then lmc_send_keys(' i')
		elseif (button == string.byte('I')) then lmc_send_keys(' o')
		elseif (button == string.byte('K')) then lmc_send_keys(' p')
		elseif (button == 190) then lmc_send_keys(' [')
        elseif (button == 191) then lmc_send_keys(' ]')
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
		if (button == string.byte('A')) then lmc_send_keys(' a')
		elseif (button == string.byte('D')) then lmc_send_keys(' s')
		elseif (button == string.byte('W')) then lmc_send_keys(' d')
		elseif (button == string.byte('S')) then lmc_send_keys(' f')
		elseif (button == string.byte('C')) then lmc_send_keys(' g')
	    elseif (button == string.byte('V')) then lmc_send_keys(' h')

		elseif (button == string.byte('J')) then lmc_send_keys(' j')
		elseif (button == string.byte('L')) then lmc_send_keys(' k')
		elseif (button == string.byte('I')) then lmc_send_keys(' l')
		elseif (button == string.byte('K')) then lmc_send_keys(' ;')
		elseif (button == 190) then lmc_send_keys(' \'')
        elseif (button == 191) then lmc_send_keys(' {ENTER}')
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
		if (button == string.byte('A')) then lmc_send_keys(' 6')
		elseif (button == string.byte('D')) then lmc_send_keys(' z')
		elseif (button == string.byte('W')) then lmc_send_keys(' x')
		elseif (button == string.byte('S')) then lmc_send_keys(' c')
		elseif (button == string.byte('C')) then lmc_send_keys(' v')
	    elseif (button == string.byte('V')) then lmc_send_keys(' b')

		elseif (button == string.byte('J')) then lmc_send_keys(' n')
		elseif (button == string.byte('L')) then lmc_send_keys(' m')
		elseif (button == string.byte('I')) then lmc_send_keys(' ,')
		elseif (button == string.byte('K')) then lmc_send_keys(' .')
		elseif (button == 190) then lmc_send_keys(' /')
        elseif (button == 191) then lmc_send_keys(' \\')
		end
	end
end)
