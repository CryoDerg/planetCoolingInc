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