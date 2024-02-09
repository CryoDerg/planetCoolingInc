--The movement of the player character is controlled indirectly by the user. The user can right click on a tile to bring up a desciption of the tile, which also contains an option to move the player character to that tile. The player character will move to the tile in the shortest path possible. The player character will also move if the user enters any contruction mode, at which the player character will run toward the mouse, stopping a short distance away. 
--When idle (player character movement has not been requested for 10 seconds), the player character will wander around the map, avoiding hot tiles. The player character will not avoid hot tiles when not Idle and may be damaged or killed. 
--When the player character is killed, the world will simulate for 200 cycles and then allow the player character to respawn at an available respawn point. If there is no available respawn point, the game will end.

function updatePlayerPosition(dt)
	if player.isMoving then
		local xDist = player.moveInfo.xDist
		local yDist = player.moveInfo.yDist
		local timeToMove = player.moveInfo.timeToMove

		--Calculate the distance to move each frame and add the time elapsed
		player.x = player.x + (xDist / timeToMove) * dt
		player.y = player.y + (yDist / timeToMove) * dt
		player.moveInfo.timeElapsed = player.moveInfo.timeElapsed + dt
		
		--If the player has reached the target tile, stop moving
		if player.moveInfo.timeElapsed >= player.moveInfo.timeToMove then
			player.isMoving = false
			player.moveInfo.timeElapsed = 0
			player.moveInfo.xDist = 0
			player.moveInfo.yDist = 0
			player.moveInfo.timeToMove = 0
		end
	end
end

function movePlayerTo(tX, tY)
	--Find the distance to the tile and the direction, then calculate the amount of time it will take to get there
	local pX = player.x
	local pY = player.y

	local xDist = tX - pX
	local yDist = tY - pY
	local dist = math.findDistanceBetweenPoints(tX, tY, pX, pY)

	local xDir = 0
	local yDir = 0

	local timeToMove = dist / player.speed
	
	xDist = xDist
	yDist = yDist

	--Set variables to be updated each frame to move the player character
	player.isMoving = true
	player.moveInfo.targetX = tX
	player.moveInfo.targetY = tY
	player.moveInfo.beginX = pX
	player.moveInfo.beginY = pY
	player.moveInfo.xDist = xDist
	player.moveInfo.yDist = yDist
	player.moveInfo.timeToMove = timeToMove
	player.moveInfo.timeElapsed = 0
end