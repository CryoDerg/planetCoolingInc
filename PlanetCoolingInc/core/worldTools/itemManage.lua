--Manages every item that is currently in the world, from items that are on the ground to items that are in inventories

function initInventories()
  --inventories is a table that holds all the inventories in the world
	inventories = {
		player = {
			size = 20,
			itemAmount = 0,
			items = {},
		},
		ground = {
			size = 999,
			itemAmount = 0,
			items = {},
		},
		--More inventories can be added during gameplay

	}
end

function transferItemToInventory(fromInventory, slot, toInventory)
	--Transfers an item from one inventory to another
	
	if fromInventory.items[slot] and inventories.ground.itemAmount < inventories.ground.size then
		addItemToInventory(fromInventory.items[slot], toInventory)
		removeItemFromInventory(fromInventory, slot)
	end
end

function addItemToInventory(item, inventory, slot)
	--Adds an item to an inventory
	--If slot is nil, it will add the item to the first available slot

	if inventory.itemAmount < inventory.size then
		if slot == nil then
			for itemSlot = 1, inventory.size do
				if inventory.items[itemSlot] == nil then
					inventory.items[itemSlot] = item
					return
				end
			end
		else
			inventory.items[slot] = item
		end
	elseif inventories.ground.itemAmount < inventories.ground.size then
		addItemToInventory(item, inventories.ground)
	end
end

function removeItemFromInventory(inventory, slot)
	--Removes an item from a specified slot in an inventory

	if inventory.items[slot] ~= nil then
		inventory.items[slot] = nil
	end
end





