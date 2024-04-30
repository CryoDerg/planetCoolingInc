--Manages every item that is currently in the world, from items that are on the ground to items that are in inventories
--Each inventory has a capacity that only allows a certain amount of items to be stored in it
--Each slot of an inventory corresponds to a specific item type that is being stored with the same x and y coordinates (x and y are tiles, not pixels)

--[[
	Slot Example (in the items table):

	items = {
		coal = {
			itemName = "Coal",
			amount = 5,
		}
	}
]]

function initItems()
	--Initialize all the items in the game
	itemList = {
		{
			name = "Heat Cell",
			interName = "heatUnit",

			heatStored = 0,
		},

		{
			name = "Uranium",
			internalName = "uranium",
		},
		
		--More items will be added later
	}
end

function initInventories()
  --inventories is a table that holds all the inventories in the world (except for ones on the ground)
	inventories = {
		player = {
			capacity = 20,
			itemAmount = 0,
			items = {},
			x = player.x,
			y = player.y,
		},
		
		--More inventories can be added during gameplay

	}
	--groundInventories is a table that holds all the inventories that are on the ground
	groundInventories = {
		--[[
			Example:
			[1] = {
				capacity = 20,
				itemAmount = 0,
				items = {},
				x = 0,
				y = 0,
				onTile = grid.tiles[1][1],
			}
		
		]]
	}
end

function transferItemToInventory(itemName, amount, fromInventory, toInventory)
	--Transfers an item(s) from one inventory to another
	
	if fromInventory.items[itemName] then
		addItemToInventory(itemName, amount, toInventory)
		removeItemFromInventory(itemName, amount, fromInventory)
	end
end

function addItemToInventory(itemName, amount, inventory)
	--Adds an item(s) to an inventory
	--If the inventory is full, the item is added to the ground inventory
	local fitAmount = math.min(inventory.capacity - inventory.itemAmount, amount)
	logMessage("Adding " .. fitAmount .. " " .. itemName .. " to inventory")
	local slot = inventory.items[itemName]
	if slot then
		logMessage("Slot: \n" .. table.toString(slot))
		slot.amount = slot.amount + fitAmount
		logMessage("Slot After: \n" .. table.toString(slot))
	else
		inventory.items[itemName] = {
			itemName = itemName,
			amount = fitAmount,
		}
	end
	inventory.itemAmount = inventory.itemAmount + fitAmount
	logMessage("Inventory: \n" .. table.toString(inventory))
	if amount > fitAmount then
		putItemOnGround(itemName, amount - fitAmount, grid.tiles[math.floor(inventory.x/60)][math.floor(inventory.y/60)])
	end
end

function removeItemFromInventory(itemName, amount, inventory)
	--Removes an item(s) from a specified slot in an inventory

	local slot = inventory.items[itemName]
	local amountRemoved = 0

	if slot then
		if slot.amount > amount then
			slot.amount = slot.amount - amount
			amountRemoved = amount
		else
			amountRemoved = slot.amount
			inventory.items[itemName] = nil
		end
		logMessage("Removing " .. amountRemoved .. " " .. itemName .. " from inventory")
		logMessage("Inventory: \n" .. table.toString(inventory))
		inventory.itemAmount = inventory.itemAmount - amountRemoved
	end
end

function putItemOnGround(itemName, amount, tile)
	--Create new ground inventory
	local inventory = {
		capacity = amount,
		itemAmount = 0,
		items = {},
		x = tile.x,
		y = tile.y,
		onTile = tile,
	}
	table.insert(groundInventories, inventory)
	logMessage("Adding " .. amount .. " " .. itemName .. " to ground inventory on tile " .. tile.x .. ", " .. tile.y)
	--Add item(s) to ground inventory
	addItemToInventory(itemName, amount, groundInventories[#groundInventories])
end