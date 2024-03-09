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
		if x > windowWidth - 75 and x < windowWidth - 25 and y > windowHeight - 125 and y < windowHeight - 25 then
			--Close the program menu
			droneProgramOpen = false

			if #programDrone.program > 0 then
				--If the program is not empty, set the drone to the first event
				programDrone.onEvent = 1
			else
				--If the program is empty, set the drone to idle
				programDrone.onEvent = false
			end

		--Check for clicks on the 5 events in the program menu
		elseif x > 205 and x < 355 and y > 10 and y < 90 then
			--MoveTo
			table.insert(programDrone.program, {event = "MoveTo", eventText = "Move To Tile", x = 0, y = 0, tile = grid.tiles[0][0]})
		elseif x > 365 and x < 515 and y > 10 and y < 90 then
			--PickupItem
			table.insert(programDrone.program, {event = "PickupItem", eventText = "Pick up Items", item = "", selectItem = false, selectScroll = 0, time = 5,})
		elseif x > 525 and x < 675 and y > 10 and y < 90 then
			--DropItem
			table.insert(programDrone.program, {event = "DropItem", eventText = "Drop Items", item = "", selectItem = false, selectScroll = 0, time = 5})
		elseif x > 685 and x < 835 and y > 10 and y < 90 then
			--Idle
			table.insert(programDrone.program, {event = "idle", eventText = "Go Idle", time = 5})
		elseif x > 845 and x < 995 and y > 10 and y < 90 then
			--ReturnToHub
			table.insert(programDrone.program, {event = "returnToHub", eventText = "Return to Hub"})
		else

			--Check for clicks on the events in the program
			for i, event in ipairs(programDrone.program) do
				if x > 135 + (i - 1) * 160 and x < 155 + (i - 1) * 160 and y > 355 and y < 375 then
					--Clicked on an event
					table.remove(programDrone.program, i)
				end
				--Check for event specific actions
				if event.event == "MoveTo" then
					--check for click on select tile button
					if x > 20 + (i - 1) * 160 and x < 70 + (i - 1) * 160 and y > 350 and y < 370 then
						--Open the tile selection menu
						print("Opening Tile Selection Menu")
						tileSelectionOpen = true
						tileSelectionDrone = programDrone
						tileSelectionEvent = i

						droneProgramOpen = false

					end
				elseif event.event == "PickupItem" then
					--check for click on select item button
					if x > 20 + (i - 1) * 160 and x < 70 + (i - 1) * 160 and y > 350 and y < 370 then
						if event.selectItem then
							event.selectItem = false
						else
							event.selectItem = true
						end
					elseif x > 15 + (i - 1) * 160 and x < 105 + (i - 1) * 160 and y > 395 and y < 645 then
						--Check for clicks to select an item
						local item = math.floor((y - 395)/20) + event.selectScroll + 1
						if itemList[item] then
							event.item = itemList[item]
							event.selectItem = false
						end
					end
				elseif event.event == "DropItem" then
					--check for click on select item button
					if x > 20 + (i - 1) * 160 and x < 70 + (i - 1) * 160 and y > 350 and y < 370 then
						if event.selectItem then
							event.selectItem = false
						else
							event.selectItem = true
						end
					elseif x > 15 + (i - 1) * 160 and x < 105 + (i - 1) * 160 and y > 395 and y < 645 then
						--Check for clicks to select an item
						local item = math.floor((y - 395)/20) + event.selectScroll + 1
						if itemList[item] then
							event.item = itemList[item]
							event.selectItem = false
						end
					end
				elseif event.event == "idle" then
					--check for click on decrease and increase time button
					if x > 20 + (i - 1) * 160 and x < 40 + (i - 1) * 160 and y > 350 and y < 370 and event.time >= 2 then
						event.time = event.time - 1
					elseif x > 45 + (i - 1) * 160 and x < 65 + (i - 1) * 160 and y > 350 and y < 370 then
						event.time = event.time + 1
					end
				end
			end
		end
	end
end