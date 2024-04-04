interactUI = {}

interactUI.mainMenu = function(x, y, k)
	--Check if k is not nil
	if k then
		--Check for key or mouse interaction
		if k == "escape" then
			--Exit the game
			love.event.quit()
		elseif k == "M1" and x > 450 and x < 750 and y > 400 and y < 450 then
			--Start the game
			genNewWorld(100)
			print("Game started")
		elseif k == "M1" and x > 450 and x < 750 and y > 500 and y < 550 then
			--Open the options menu
			gamestate = "options"
			print("Options menu opened")
		elseif k == "M1" and x > 20 and x < 120 and y > windowHeight - 70 and y < windowHeight - 20 then
			--Exit the game
			love.event.quit()
		end
	else
		--Check for mouse position interaction

	end
end

interactUI.optionsMenu = function(x, y, k)
	if k then
		if k == "escape" then
			--Exit the options menu
			gamestate = "mainMenu"
			print("Options menu closed")
		elseif k == "M1" and x > 450 and x < 750 and y > 200 and y < 250 then
			--Toggle fullscreen
			settings.fullscreenState = not settings.fullscreenState
			saveSettings()
		end
	else
		--Check for mouse position interaction

	end
end

interactUI.game = function(x, y, k)
	if k then
		if k == "t" then
			--Toggle temperature overlay
			tempOverlay = not tempOverlay
		elseif k == "g" then
			--Generate a new world 
			genNewWorld(100)
		elseif k == "h" then
			--Toggel update tiles overlay
			showHotTiles = not showHotTiles
		elseif k == "x" then
			--Toggle network overlay
			networkOverlay = not networkOverlay
		elseif k == "m" then
			--move player to mouse
			movePlayerTo(mX - camX, mY - camY)
		elseif k == "M1" then
			if tileSelectionOpen then
				--Select a tile
				local tile = clickTile(mX, mY)
				if tile then
					tileSelectionDrone.program[tileSelectionEvent] = {event = "MoveTo", eventText = "Move To Tile", x = tile.x, y = tile.y, tile = tile}
					tileSelectionOpen = false
					droneProgramOpen = true
				end
			elseif hubLinkOpen then
				--Link a drone to a hub
				local tile = clickTile(mX, mY)
				if tile then
					if tile.droneHubInfo.hasHub then
						linkDroneToHub(linkDrone, tile)
						moveDroneTo(linkDrone, tile.x*60 + 30, tile.y*60 + 30)
						hubLinkOpen = false
					end
			  	end
			else
				--Check for other ui interactions
				clickBuildingUI(x, y)
			  	clickContextMenu(x, y)
			  	clickProgramMenu(x, y)
			
			  	if placingBuilding and not clickedButton[1] then
					--Place a building
				 	local x, y = math.floor((mX - camX)/60), math.floor((mY - camY)/60)
				 	buildingBlueprints[selectBuilding].placeBuilding(grid.tiles[x][y])
			  	end
			end
		elseif k == "M2R" and clickTile(mX, mY) and camMoved < 8 then
			--Open the context menu
			createContextMenu(mX, mY)
		elseif k == "escape" then
			--Return to main menu
			gamestate = "mainMenu"
		elseif k == "s" then
			--Save the game
			saveWorld()
		elseif k == "l" then
			--Load most recent save
			if love.filesystem.getInfo("saves/savDat.dat") then
			  local fileData = love.filesystem.read("saves/savDat.dat")
			  fileName = string.match(fileData, "Filename = \"(.-)\"")
			  print("Loading: " .. fileName)
			  loadWorld(fileName)
			else
			  print("No save Data file found")
			end
		end
	end
end
