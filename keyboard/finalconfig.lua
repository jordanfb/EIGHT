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
		if (button == string.byte('A')) then lmc_send_keys('{F1}')
		elseif (button == string.byte('D')) then lmc_send_keys('{F2}')
		elseif (button == string.byte('W')) then lmc_send_keys('{F3}')
		elseif (button == string.byte('S')) then lmc_send_keys('{F4}')
		elseif (button == string.byte('C')) then lmc_send_keys('{F5}')
	    elseif (button == string.byte('V')) then lmc_send_keys('{F6}')

		elseif (button == string.byte('J')) then lmc_send_keys('{F7}')
		elseif (button == string.byte('L')) then lmc_send_keys('{F8}')
		elseif (button == string.byte('I')) then lmc_send_keys('{F9}')
		elseif (button == string.byte('K')) then lmc_send_keys('{F10}')
		elseif (button == 190) then lmc_send_keys('{F11}')
        elseif (button == 191) then lmc_send_keys('{F12}')
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
		if (button == string.byte('A')) then lmc_send_keys('{F13}')
		elseif (button == string.byte('D')) then lmc_send_keys('{F14}')
		elseif (button == string.byte('W')) then lmc_send_keys('{F15}')
		elseif (button == string.byte('S')) then lmc_send_keys('{F16}')
		elseif (button == string.byte('C')) then lmc_send_keys('{F17}')
	    elseif (button == string.byte('V')) then lmc_send_keys('{F18}')

		elseif (button == string.byte('J')) then lmc_send_keys('{F19}')
		elseif (button == string.byte('L')) then lmc_send_keys('{NUM0}')
		elseif (button == string.byte('I')) then lmc_send_keys('{NUM1}')
		elseif (button == string.byte('K')) then lmc_send_keys('{NUM2}')
		elseif (button == 190) then lmc_send_keys('{NUM3}')
        elseif (button == 191) then lmc_send_keys('{NUM4}')
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
		if (button == string.byte('A')) then lmc_send_keys('{NUM5}')
		elseif (button == string.byte('D')) then lmc_send_keys('{NUM6}')
		elseif (button == string.byte('W')) then lmc_send_keys('{NUM7}')
		elseif (button == string.byte('S')) then lmc_send_keys('{NUM8}')
		elseif (button == string.byte('C')) then lmc_send_keys('{NUM9}')
	    elseif (button == string.byte('V')) then lmc_send_keys('{PGUP}')

		elseif (button == string.byte('J')) then lmc_send_keys('{NUMMULTIPLY}')
		elseif (button == string.byte('L')) then lmc_send_keys('{NUMMINUS}')
		elseif (button == string.byte('I')) then lmc_send_keys('{NUMPLUS}')
		elseif (button == string.byte('K')) then lmc_send_keys('{NUMDECIMAL}')
		elseif (button == 190) then lmc_send_keys('{INS}')
        elseif (button == 191) then lmc_send_keys('{HOME}')
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
		if (button == string.byte('A')) then lmc_send_keys('+')
		elseif (button == string.byte('D')) then lmc_send_keys('^')
		elseif (button == string.byte('W')) then lmc_send_keys('{TAB}')
		elseif (button == string.byte('S')) then lmc_send_keys('{UP}')
		elseif (button == string.byte('C')) then lmc_send_keys('{DOWN}')
	    elseif (button == string.byte('V')) then lmc_send_keys('{LEFT}')

		elseif (button == string.byte('J')) then lmc_send_keys('{RIGHT}')
		elseif (button == string.byte('L')) then lmc_send_keys('%')
		elseif (button == string.byte('I')) then lmc_send_keys('{DELETE}')
		elseif (button == string.byte('K')) then lmc_send_keys('{BACKSPACE}')
		elseif (button == 190) then lmc_send_keys('{END}')
        elseif (button == 191) then lmc_send_keys('{PGDN}')
		end
	end
end)
