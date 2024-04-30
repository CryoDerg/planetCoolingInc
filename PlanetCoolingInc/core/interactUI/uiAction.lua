interactUI = {}

interactUI.mainMenuVars = {
	startButtonHover = false,
	optionsButtonHover = false,
	exitButtonHover = false,
}
interactUI.mainMenu = function(x, y, k)
	--Check if k is not nil
	if k then
		--Check for key or mouse interaction
		if k == "escape" then
			--Exit the game
			love.event.quit()
		elseif k == "M1" and x > 450 and x < 750 and y > 400 and y < 450 then
			--select planet
			gamestate = "planets"
			updateControls(false)
		elseif k == "M1" and x > 450 and x < 750 and y > 500 and y < 550 then
			--Open the options menu
			gamestate = "options"
			updateControls(false)
			interactUI.optionsMenuVars.previousState = "mainMenu"
			print("Options menu opened")
		elseif k == "M1" and x > 20 and x < 120 and y > (windowHeight / uiScale) - 70 and y < (windowHeight / uiScale) - 20 then
			--Exit the game
			love.event.quit()
		end
	else
		--Check for mouse position interaction
		if x > 450 and x < 750 and y > 400 and y < 450 then
			interactUI.mainMenuVars.startButtonHover = true
		else
			interactUI.mainMenuVars.startButtonHover = false
		end

		if x > 450 and x < 750 and y > 500 and y < 550 then
			interactUI.mainMenuVars.optionsButtonHover = true
		else
			interactUI.mainMenuVars.optionsButtonHover = false
		end

		if x > 20 and x < 120 and y > (windowHeight / uiScale) - 70 and y < (windowHeight / uiScale) - 20 then
			interactUI.mainMenuVars.exitButtonHover = true
		else
			interactUI.mainMenuVars.exitButtonHover = false
		end
	end
end

interactUI.optionsMenuVars = {
	fullscreenButtonHover = false,
	exitButtonHover = false,
	previousState = "mainMenu",
}
interactUI.optionsMenu = function(x, y, k)
	if k then
		if k == "escape" then
			--Exit the options menu
			gamestate = "mainMenu"
			updateControls(false)
			print("Options menu closed")
		elseif k == "M1" and x > 450 and x < 750 and y > 200 and y < 250 then
			--Toggle fullscreen
			settings.fullscreenState = not settings.fullscreenState
			saveSettings()
		elseif k == "M1" and x > 20 and x < 120 and y > (windowHeight / uiScale) - 70 and y < (windowHeight / uiScale) - 20 then
			--Exit the options menu
			gamestate = interactUI.optionsMenuVars.previousState
			updateControls(false)
			print("Options menu closed")
		end
	else
		--Check for mouse position interaction
		if x > 450 and x < 750 and y > 200 and y < 250 then
			interactUI.optionsMenuVars.fullscreenButtonHover = true
		else
			interactUI.optionsMenuVars.fullscreenButtonHover = false
		end

		if x > 20 and x < 120 and y > (windowHeight / uiScale) - 70 and y < (windowHeight / uiScale) - 20 then
			interactUI.optionsMenuVars.exitButtonHover = true
		else
			interactUI.optionsMenuVars.exitButtonHover = false
		end
	end
end

interactUI.planetMenuVars = {
	selectedPlanet = 1,
	startButtonHover = false,

}
interactUI.planetMenu = function(x, y, k)
	if k then
		if k == "escape" then
			--main menu
			gamestate = "mainMenu"
			updateControls(false)
		elseif k == "a" and interactUI.planetMenuVars.selectedPlanet > 1 then
			interactUI.planetMenuVars.selectedPlanet = interactUI.planetMenuVars.selectedPlanet - 1
		elseif k == "d" and interactUI.planetMenuVars.selectedPlanet < 3 then
			interactUI.planetMenuVars.selectedPlanet = interactUI.planetMenuVars.selectedPlanet + 1
		elseif k == "M1" and x > (centerWidth / uiScale) - 100 and x < (centerWidth / uiScale) + 100 and y > (windowHeight / uiScale) - 100 and y < (windowHeight / uiScale) - 50 then
			--start game
			gamestate = "load"
			love.graphics.clear()
			love.draw()
			love.graphics.present()
			genNewWorld(100)
			updateControls(false)
		end
	else
		if x > (centerWidth / uiScale) - 100 and x < (centerWidth / uiScale) + 100 and y > (windowHeight / uiScale) - 100 and y < (windowHeight / uiScale) - 50 then
			interactUI.planetMenuVars.startButtonHover = true
		else
			interactUI.planetMenuVars.startButtonHover = false
		end
	end
end

interactUI.pauseMenuVars = {
	resumeButtonHover = false,
	optionsButtonHover = false,
	mainMenuButtonHover = false,
}
interactUI.pauseMenu = function(x, y, k)
	if k then
		if k == "escape" then
			--Close the pause menu
			gamestate = "game"
			updateControls(false)
		elseif k == "M1" and x > 450 and x < 750 and y > 200 and y < 250 then
			--Close the pause menu
			gamestate = "game"
			updateControls(false)
		elseif k == "M1" and x > 450 and x < 750 and y > 300 and y < 350 then
			--Open the options menu
			gamestate = "options"
			updateControls(false)
			interactUI.optionsMenuVars.previousState = "pause"
		elseif k == "M1" and x > 450 and x < 750 and y > 400 and y < 450 then
			--Back to main menu bucko
			gamestate = "mainMenu"
			updateControls(false)
		end

	else
		--Check for mouse position interaction
		if x > 450 and x < 750 and y > 200 and y < 250 then
			interactUI.pauseMenuVars.resumeButtonHover = true
		else
			interactUI.pauseMenuVars.resumeButtonHover = false
		end

		if x > 450 and x < 750 and y > 300 and y < 350 then
			interactUI.pauseMenuVars.optionsButtonHover = true
		else
			interactUI.pauseMenuVars.optionsButtonHover = false
		end

		if x > 450 and x < 750 and y > 400 and y < 450 then
			interactUI.pauseMenuVars.mainMenuButtonHover = true
		else
			interactUI.pauseMenuVars.mainMenuButtonHover = false
		end
	end
end

interactUI.gameVars = {
	buildingMenuOpen = false,
	buildingMenuScroll = 1,
	buildingMenuHoverInfo = "",
	selectBuilding = 0,
	placingBuilding = false,

	placingBuilding = false,
	tileSelectionOpen = false,
	hubLinkOpen = false,
}
interactUI.game = function(x, y, k)
	if k then
		if k == "t" then
			--Toggle temperature overlay
			tempOverlay = not tempOverlay
		elseif k == "g" then
			--Generate a new world 
			genNewWorld(100)
		elseif k == "h" then
			--Toggle update tiles overlay
			showHotTiles = not showHotTiles
		elseif k == "x" then
			--Toggle network overlay
			networkOverlay = not networkOverlay
		elseif k == "m" then
			--move player to mouse
			movePlayerTo(mX - camX, mY - camY)
		elseif k == "M1" then
			if interactUI.gameVars.tileSelectionOpen then
				local tile = clickTile(mX, mY)
				if tile then
					tileSelectionDrone.program[tileSelectionEvent] = {event = "MoveTo", eventText = "Move To Tile", x = tile.x, y = tile.y, tile = tile}
					tileSelectionOpen = false
					droneProgramOpen = true
				end
			elseif interactUI.gameVars.hubLinkOpen then
				--Link a drone to a hub
				local tile = clickTile(mX, mY)
				if tile then
					if tile.droneHubInfo.hasHub then
						linkDroneToHub(linkDrone, tile)
						moveDroneTo(linkDrone, tile.x*60 + 30, tile.y*60 + 30)
						hubLinkOpen = false
					end
			  	end
			elseif interactUI.gameVars.buildingMenuOpen then
				--mouse is over the left arrow button
				if math.checkIfPointInRect(x, y, 112.5, 137.5, (windowHeight / uiScale) - 125, (windowHeight / uiScale) - 25) and interactUI.gameVars.buildingMenuScroll > 1 then
					interactUI.gameVars.buildingMenuScroll = interactUI.gameVars.buildingMenuScroll - 1
					print("Left Arrow")
			
				--mouse is over the right arrow button
				elseif math.checkIfPointInRect(x, y, (windowWidth / uiScale) - 50, (windowWidth / uiScale) - 25, (windowHeight / uiScale) - 125, (windowHeight / uiScale) - 25) then
					interactUI.gameVars.buildingMenuScroll = interactUI.gameVars.buildingMenuScroll + 1
					print("Right Arrow")
						
				--mouse is over a building button
				else
					for i = 1, #buildingBlueprints do
						local x1 = 143.75 + (i - 1) * 106.5
						local x2 = 243.75 + (i - 1) * 106.5
						local y1 = (windowHeight / uiScale) - 125
						local y2 = (windowHeight / uiScale) - 25
						if math.checkIfPointInRect(x, y, x1, x2, y1, y2) then
							interactUI.gameVars.selectBuilding = i
							interactUI.gameVars.placingBuilding = true
							interactUI.gameVars.buildingMenuOpen = false
							clickedButton = true
							break
						end
					end
				end
			end

			--mouse is over the building menu button
			if math.checkIfPointInRect(x, y, 31.25, 81.25, (windowHeight / uiScale) - 125, (windowHeight / uiScale) - 25) then
				interactUI.gameVars.buildingMenuOpen = not interactUI.gameVars.buildingMenuOpen
				interactUI.gameVars.placingBuilding = false
			end

			clickContextMenu(x, y)
			clickProgramMenu(x, y)
			
		 	if interactUI.gameVars.placingBuilding then
				--Place a building
			 	local x, y = math.floor((mX - camX)/60), math.floor((mY - camY)/60)
			 	buildingBlueprints[interactUI.gameVars.selectBuilding].placeBuilding(grid.tiles[x][y], x, y)
		  	end
		elseif k == "M2R" and clickTile(mX, mY) and camMoved < 8 then
			--Open the context menu
			createContextMenu(mX, mY)
		elseif k == "escape" then
			--open pause menu
			gamestate = "pause"
			updateControls(false)
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
		elseif k == "up" then
			scale = scale * 1.5
		elseif k == "down" then
			scale = scale / 1.5
		end
	else
		--Check for mouse position interaction
		if buildingMenuOpen then
			--Is mouse is over a building button?
			for i = 1, #buildingBlueprints do
				local x1 = 143.75 + (i - 1) * 106.5
				local x2 = 243.75 + (i - 1) * 106.5
				local y1 = (windowHeight / uiScale) - 125
				local y2 = (windowHeight / uiScale) - 25
				if math.checkIfPointInRect(x, y, x1, x2, y1, y2) then
					--Draw building info
					love.graphics.setColor(1, 1, 1, 1)
					--On Screen Coords: 50, 50, windowWidth - 100, windowHeight - 200
					interactUI.gameVars.buildingMenuHoverInfo = buildingBlueprints[i].name.."\n\n"..buildingBlueprints[i].description
					break
				else
					interactUI.gameVars.buildingMenuHoverInfo = ""
				end
			end
		end
	end
end