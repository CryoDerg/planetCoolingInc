--Display a message in game for a certain amount of time at a certain location

inGameMessages = {}

function createGameMessage(message, x, y, time)
	--Display a message in game for a certain amount of time at a certain location
	table.insert(inGameMessages, {message = message, x = x, y = y, time = time, created = runTime})
end

function drawGameMessages()
	for i, message in pairs(inGameMessages) do
		love.graphics.setColor(1,1,1)
		if message.time - (runTime - message.created) < 1 then
			love.graphics.setColor(1,1,1, message.time - (runTime - message.created))
		end
		love.graphics.print(message.message, message.x, message.y, 0, 1/scale, 1/scale)
		if message.time < runTime - message.created then
			table.remove(inGameMessages, i)
		end
	end
end