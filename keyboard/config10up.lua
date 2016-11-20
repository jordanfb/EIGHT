lmc_assign_keyboard('ONE');
lmc_assign_keyboard('TWO');
lmc_assign_keyboard('THREE');
lmc_assign_keyboard('FOUR');

function sendKey(key)
	for i = 1, 2, 1 do
		lmc_send_keys(key)
	end
end

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
		if (button == string.byte('A')) then sendKey('{UP}`')
		elseif (button == string.byte('D')) then sendKey('{UP}1')
		elseif (button == string.byte('W')) then sendKey('{UP}2')
		elseif (button == string.byte('S')) then sendKey('{UP}3')
		elseif (button == string.byte('C')) then sendKey('{UP}4')
	    elseif (button == string.byte('V')) then sendKey('{UP}5')

		elseif (button == string.byte('J')) then sendKey('{UP}7')
		elseif (button == string.byte('L')) then sendKey('{UP}8')
		elseif (button == string.byte('I')) then sendKey('{UP}9')
		elseif (button == string.byte('K')) then sendKey('{UP}0')
		elseif (button == 190) then sendKey('{UP}-')
        elseif (button == 191) then sendKey('{UP}=')
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
		if (button == string.byte('A')) then sendKey(' q')
		elseif (button == string.byte('D')) then sendKey(' w')
		elseif (button == string.byte('W')) then sendKey(' e')
		elseif (button == string.byte('S')) then sendKey(' r')
		elseif (button == string.byte('C')) then sendKey(' t')
	    elseif (button == string.byte('V')) then sendKey(' y')

		elseif (button == string.byte('J')) then sendKey(' u')
		elseif (button == string.byte('L')) then sendKey(' i')
		elseif (button == string.byte('I')) then sendKey(' o')
		elseif (button == string.byte('K')) then sendKey(' p')
		elseif (button == 190) then sendKey(' [')
        elseif (button == 191) then sendKey(' ]')
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
		if (button == string.byte('A')) then sendKey(' a')
		elseif (button == string.byte('D')) then sendKey(' s')
		elseif (button == string.byte('W')) then sendKey(' d')
		elseif (button == string.byte('S')) then sendKey(' f')
		elseif (button == string.byte('C')) then sendKey(' g')
	    elseif (button == string.byte('V')) then sendKey(' h')

		elseif (button == string.byte('J')) then sendKey(' j')
		elseif (button == string.byte('L')) then sendKey(' k')
		elseif (button == string.byte('I')) then sendKey(' l')
		elseif (button == string.byte('K')) then sendKey(' ;')
		elseif (button == 190) then sendKey(' \'')
        elseif (button == 191) then sendKey(' {ENTER}')
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
		if (button == string.byte('A')) then sendKey(' 6')
		elseif (button == string.byte('D')) then sendKey(' z')
		elseif (button == string.byte('W')) then sendKey(' x')
		elseif (button == string.byte('S')) then sendKey(' c')
		elseif (button == string.byte('C')) then sendKey(' v')
	    elseif (button == string.byte('V')) then sendKey(' b')

		elseif (button == string.byte('J')) then sendKey(' n')
		elseif (button == string.byte('L')) then sendKey(' m')
		elseif (button == string.byte('I')) then sendKey(' ,')
		elseif (button == string.byte('K')) then sendKey(' .')
		elseif (button == 190) then sendKey(' /')
        elseif (button == 191) then sendKey(' \\')
		end
	end
end)
