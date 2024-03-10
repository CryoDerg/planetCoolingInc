-- Manage the pathfinding of drones as well as their different functions
-- Drones will be the main way to transport solid resources. Specialized drones will also be able to repair structures and possibly perform other functions.
-- To function, a drone needs to be connected to a drone hub and to be charged.

function linkDroneToHub(drone, hubTile)
	--Link the drone to the hub
	drone.linkedHubInfo = {
		linked = true,
		hubX = hubTile.x,
		hubY = hubTile.y,
		hubTile = hubTile,
		hubSlot = #hubTile.droneHubInfo.slots + 1,
	}
	--Link the hub to the drone
	hubTile.droneHubInfo.slots[drone.linkedHubInfo.hubSlot] = {
		linkedDrone = drone,
		linkedDroneID = drone.droneID,
	}
end

function unlinkDroneFromHub(drone)
	--Unlink the drone from the hub
	drone.linkedHubInfo = {
		linked = false,
		hubX = nil,
		hubY = nil,
		hubTile = nil,
		hubSlot = nil,
	}
end

function openHubLinkMenu(drone)
	--Open the menu to link the drone to a hub
	hubLinkOpen = true
	linkDrone = drone
end

function updateDroneProgram(drone)
	--Update a drone based on its program
	
	local event = drone.program[drone.onEvent]
	if event.event == "MoveTo" then
		moveDroneTo(drone, (event.x * 60) + 30, (event.y * 60) + 30)
		drone.timeToProgramUpdate = gameTime + drone.moveInfo.timeToMove
	elseif event.event == "PickupItem" then
		drone.timeToProgramUpdate = gameTime + event.time
		--check if drone inventory is full
		print("Checking for item pickup")
		if drone.inventory.itemAmount < drone.inventory.capacity then
			local spaceRemaining = drone.inventory.capacity - drone.inventory.itemAmount
			print("Space Remaining: "..spaceRemaining)
			--check for inventory on tile
			print("Checking for tile inventory")
			local tile = grid.tiles[math.floor(drone.x/60)][math.floor(drone.y/60)]
			if tile.inventoryID then
				print("Tile has inventory")
				local inventory = inventories[tile.inventoryID]
				if event.item ~= "" then
					--check for item in tile inventory
					if inventory.items[event.item] then
						--pickup the item
						local transferAmount = math.min(spaceRemaining, inventory.items[event.item].amount)
						transferItemToInventory(event.item, transferAmount, inventory, drone.inventory)
						createGameMessage("Picked up "..event.item.."x"..transferAmount, drone.x, drone.y - 30, 2)
					end
				else
					--pickup any item
					print("pickup any item")
					for itemName, item in pairs(inventory.items) do
						print("Checking for item: "..itemName)
						local transferAmount = math.min(spaceRemaining, item.amount)
						print("Transfer Amount: "..transferAmount)
						transferItemToInventory(itemName, transferAmount, inventory, drone.inventory)
						createGameMessage("Picked up "..itemName.."x"..transferAmount, drone.x, drone.y - 30, 2)
						break
					end
				end
			end
		else
			createGameMessage("Drone Inventory Full", drone.x, drone.y - 30, 2)
		end
	elseif event.event == "DropItem" then
		drone.timeToProgramUpdate = gameTime + event.time
		--check if drone inventory has item
		if drone.inventory.items[event.item.internalName] then
			--check for tile inventory
			local tile = grid.tiles[math.floor(drone.x/60)][math.floor(drone.y/60)]
			if tile.inventoryID then
				local inventory = inventories[tile.inventoryID]
				--drop the item
				local transferAmount = math.min(drone.inventory.items[event.item].amount, inventory.capacity - inventory.itemAmount)
				transferItemToInventory(event.item.internalName, transferAmount, drone.inventory, inventory)
				createGameMessage("Deposited "..event.item.."x"..transferAmount, drone.x, drone.y - 30, 2)
			else
				removeItemFromInventory(event.item.internalName, drone.inventory.items[event.item].amount, drone.inventory)
				putItemOnGround(event.item.internalName, drone.inventory.items[event.item].amount, tile)
			end
		elseif event.item == "" then
			--drop any item
			local tile = grid.tiles[math.floor(drone.x/60)][math.floor(drone.y/60)]
			if tile.inventoryID then
				local inventory = inventories[tile.inventoryID]
				for itemName, item in pairs(drone.inventory.items) do
					local transferAmount = math.min(item.amount, inventory.capacity - inventory.itemAmount)
					transferItemToInventory(itemName, transferAmount, drone.inventory, inventory)
					createGameMessage("Deposited "..itemName.."x"..transferAmount, drone.x, drone.y - 30, 2)
					if inventory.itemAmount >= inventory.capacity then
						break
					end
				end
			else
				for itemName, item in pairs(drone.inventory.items) do
					removeItemFromInventory(itemName, item.amount, drone.inventory)
					putItemOnGround(itemName, item.amount, tile)
				end
			end
		
		else
			createGameMessage("Drone does not have "..event.item.name, drone.x, drone.y - 30, 2)
		end
	elseif event.event == "idle" then
		drone.timeToProgramUpdate = gameTime + event.time
	elseif event.event == "returnToHub" then
		moveDroneTo(drone, (drone.linkedHubInfo.hubX * 60) + 30, (drone.linkedHubInfo.hubY * 60) + 30)
		drone.timeToProgramUpdate = gameTime + drone.moveInfo.timeToMove
	end

	drone.onEvent = drone.onEvent + 1
	if drone.onEvent > #drone.program then
		drone.onEvent = 1
	end
end


function moveDroneTo(drone, tX, tY)
	--Move the drone to a specific tile

	droneX = drone.x
	droneY = drone.y

	xDist = tX - droneX
	yDist = tY - droneY
	dist = math.findDistanceBetweenPoints(tX, tY, droneX, droneY)

	timeToMove = dist / 100

	--Set Variables
	drone.moveInfo = {
		isMoving = true,
		targetX = tX,
		targetY = tY,
		beginX = droneX,
		beginY = droneY,
		xDist = xDist,
		yDist = yDist,
		timeToMove = timeToMove,
		timeElapsed = 0,
	}
end

function updateDronesPosition(dt)
	for droneID, drone in pairs(drones) do
		if drone.moveInfo.isMoving then
			--Calculate the distance to move each frame and add the time elapsed
			drone.x = drone.x + (drone.moveInfo.xDist / drone.moveInfo.timeToMove) * dt
			drone.y = drone.y + (drone.moveInfo.yDist / drone.moveInfo.timeToMove) * dt
			drone.moveInfo.timeElapsed = drone.moveInfo.timeElapsed + dt

			--If the drone has reached the target tile, stop moving
			if drone.moveInfo.timeElapsed >= drone.moveInfo.timeToMove then
				drone.moveInfo.isMoving = false
				drone.moveInfo.timeElapsed = 0
				drone.moveInfo.xDist = 0
				drone.moveInfo.yDist = 0
				drone.moveInfo.timeToMove = 0
			end
		end
	end
end
