--Manage drones and their tasks
--Drones can be placed using the drone hubs
--Drones can be programmed by accessing the drone through the drone hub's context menu
--If a drone runs out of power, it will fall to the ground and break

--The programming of the drones is done through a simple event system that can be arranged to create a sequence of events that the drone will follow
--[[List of events = {
	- MoveTo(x, y) - Moves the drone to the specified tile
	- PickupItem(item) - Picks up the specified item from the tile the drone is on, if no item is specified, the drone will pick up anything
	- DropItem(item) - Drops the specified item from the drone's inventory, if no item is specified, the drone will drop everything
	- idle(time) - The drone will do nothing for the specified amount of time
	- returnToHub() - The drone will return to the drone hub and charge
}
]]

function initDrones()
	drones = {}
	--[[drone = {
		x = 0,
		y = 0,
		program = {},
		charging = false,
		power = 100,
		maxPower = 100,
		inventoryID = 3,
		inventory = inventories[3],
		droneID = 1,
		linkedHubInfo = {
			hubX = 0,
			hubY = 0,
			hubTile = grid.tiles[0][0],
			hubSlot = 1,
		},
	}
	]]

	--[[droneProgram = {
		{event = "MoveTo", x = 8, y = 1},
		{event = "PickupItem", item = "Iron"},
		{event = "MoveTo", x = 7, y = 3},
		{event = "DropItem", item = "Iron"},
		{event = "idle", time = 5},
		{event = "returnToHub"},
	}
	]]
end

function createDrone(x, y)
	--init the inventory
	local inventory = {
		capacity = 10,
		itemAmount = 0,
		items = {},
	}
	table.insert(inventories, inventory)

	local drone = {
		x = x,
		y = y,
		program = {},
		charging = false,
		power = 100,
		maxPower = 100,
		inventoryID = #inventories,
		inventory = inventories[#inventories],
		droneID = #drones + 1,
		hasContextMenu = false,
		linkedHubInfo = {
			linked = false,
			hubX = nil,
			hubY = nil,
			hubTile = nil,
			hubSlot = nil,
		},
	}
	table.insert(drones, drone)
end