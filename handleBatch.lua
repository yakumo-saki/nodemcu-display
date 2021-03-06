httpServer:use('/batch', function(req, res)

	if (powersave_flag) then
		print("batch command ignored (powersave)")
		return
	end

	disp = get_display(req.query.disp)

	if (req.query.cmd == nil) then
		res:status(BAD_REQUEST)
		res:send('Error: parameter cmd is nil')
		return
	end

	print(">>> batch cmd")
	print(req.query.cmd)
	print("<<< batch cmd")

	cmds = split(req.query.cmd, "\n")

	for dummy1,cmdstr in pairs(cmds) do

		cmd_params = split(cmdstr, ",")

		-- print("params count = " .. #cmd_params)

		for dummy2, param in pairs(cmd_params) do
			-- print(param)
			cmd = cmd_params[1]

			if (cmd == "clr") then
				clearDisplay(disp)
			elseif (cmd == "msg") then
				x = cmd_params[2]
				y = cmd_params[3]
				size = cmd_params[4]
				text = cmd_params[5]
				color = cmd_params[6]
				mode = cmd_params[7]
				direction = cmd_params[8]
				ret = drawString(disp, x, y, text, mode, color, size, direction)
			else
				print("unknown command. ignore => " .. cmd)
			end
		end
	end

	-- ret = drawString(req.query.x, req.query.y, req.query.text, req.query.fontmode, req.query.fontcolor, req.query.fontsize, req.query.direction)
	ret = ""
	if (ret ~= "") then
		res:status(BAD_REQUEST)
		res:send(ret)
		return
	end

	disp:sendBuffer()
	res:status(OK)
	res:send("OK \n" .. req.query.cmd .. "\n")

end)
