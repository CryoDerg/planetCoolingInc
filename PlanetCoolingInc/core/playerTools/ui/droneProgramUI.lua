--Manage the UI for when the player is programming a drone
--This menu allows the player to program the drone to do certain tasks
--The player can click events to add/remove them from the drone's program

function openProgramMenu(drone)
	--Opens the program menu for a drone
	print("Opening Program Menu")
	droneProgramOpen = true
	programDrone = drone
	programScroll = 0
end

function clickProgramMenu(x, y)
	--Check for clicks on the 5 events in the program menu
	if droneProgramOpen then
		--Check for clicks on the 5 events in the program menu
		if x > 205 and x < 355 and y > 10 and y < 90 then
			--MoveTo
			table.insert(programDrone.program, {event = "MoveTo", eventText = "Move To Tile", x = 0, y = 0})
		elseif x > 365 and x < 515 and y > 10 and y < 90 then
			--PickupItem
			table.insert(programDrone.program, {event = "PickupItem", eventText = "Pick up Items", item = ""})
		elseif x > 525 and x < 675 and y > 10 and y < 90 then
			--DropItem
			table.insert(programDrone.program, {event = "DropItem", eventText = "Drop Items", item = ""})
		elseif x > 685 and x < 835 and y > 10 and y < 90 then
			--Idle
			table.insert(programDrone.program, {event = "idle", eventText = "Go Idle", time = 0})
		elseif x > 845 and x < 995 and y > 10 and y < 90 then
			--ReturnToHub
			table.insert(programDrone.program, {event = "returnToHub", eventText = "Return to Hub"})
		end

		--Check for clicks on the events in the program
		for i, event in ipairs(programDrone.program) do
			if event.event == "MoveTo" then
				
			end
		end
	end
end