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
			name = "Coal",
			internalName = "coal",
		},
		{
			name = "Iron",
			internalName = "iron",
		},
		{
			name = "Uranium",
			internalName = "uranium",
		},
		--More items will be added later (these are just placeholders)
	}
end

function initInventories()
  --inventories is a table that holds all the inventories in the world (except for ones on the ground)
	inventories = {
		player = {
			capacity = 20,
			itemAmount = 0,
			items = {},
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
				onTile = grid.tiles[1][1],
			}
		
		]]
	}
end

function transferItemToInventory(fromInventory, toInventory, itemName, amount)
	--Transfers an item(s) from one inventory to another
	
	if fromInventory.items[slot] then
		addItemToInventory(fromInventory.items[slot], toInventory)
		removeItemFromInventory(fromInventory, slot)
	end
end

function addItemToInventory(itemName, amount, inventory)
	--Adds an item(s) to an inventory
	--If the inventory is full, the item is added to the ground inventory

	if inventory.itemAmount < inventory.capacity then
		local slot = toInventory[itemName]
		if slot then
			slot.amount = slot.amount + amount
		else
			inventory.items[itemName] = {
				itemName = itemName,
				amount = amount,
			}
		end
		inventory.itemAmount = inventory.itemAmount + amount
	else
		putItemOnGround(itemName, amount, inventory.onTile)
	end
end

function removeItemFromInventory(inventory, itemName, amount)
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
	end
end

function putItemOnGround(itemName, amount, tile)
	--Create new ground inventory
	local inventory = {
		capacity = amount,
		itemAmount = 0,
		items = {},
		onTile = tile,
	}
	table.insert(groundInventories, inventory)

	--Add item(s) to ground inventory
	addItemToInventory(itemName, amount, groundInventories[#groundInventories])
end