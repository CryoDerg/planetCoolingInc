--[[
This game will be about the automation of cooling an overheating planet. Each save will be randomized as to where resources are and the terrain.

An employee is dispatched onto this overheating planet where there is a small patch of land that is not super hot. The main objective is to build a radiator system that will cool down tiles to expand for more automation. The radiator system needs power so that will be one of the first things automated.

Power sources: 
	Solar Panels (Collects power from the sun if not blocked by weather)
	Thermal generators (Converts heat into energy)
	Coal Generators (Burns coal for energy)

Cooling Methods:
	Radiators
	Ice Delivery
	Deliver heat to space
	Wormholes to throw heat into (maybe)



TODO
	Grid system (DONE)
	Generate world
	Thermal system (DONE)
	Player Control
	Buildings 
	Weather

	Context Menu System - Have a list of context menus that display different bits of info depending on the data it is given (DONE)
	Inventories - Have a list of inventories that hold a certain amount of items as well as having functions to transfer items between them
	Drones - Have a list of drones that can be programmed by the player to do certain tasks


FUTURE IDEAS
	Sector expansion - Have the player be able to expand the grid to a new sector of the planet
	New planets - Have the player be able to unlock new assigned planets that they can go to and cool down. This would be enabled by cooling off previous planets and gaining good reputation with the company
	Previous employees - Have the player be able to find the remains of previous employees in new sectors (including the starting sector) which would give the player new items and information about the planet

]]


function love.load()
	jit.off()
	require("core/boot/boot")
	boot()
end

function love.update(dt)
	runTime = runTime + dt
	gameTime = gameTime + dt

	--get mouse coords and scale them
	screenMX, screenMY = love.mouse.getPosition()
	mX, mY = screenMX / scale, screenMY / scale

	
	
	
	if gamestate == 1 then
		updatePlayerPosition(dt)

		if gameTime - updateTime >= 1 then
			updateImportantTiles()

			updateElectric()

			updatePipes()

			updateTime = gameTime
		end

		if gameTime - randomUpdateTime >= 0.1 then
			local randX = math.random(-gridSize/2, gridSize/2)
			local randY = math.random(-gridSize/2, gridSize/2)
			local tile = grid.tiles[randX][randY]
			tile.temp = tile.temp + math.random(1,10)
			updateTileHeat(randX, randY)
			randomUpdateTime = gameTime
		end
	end
end

function love.keypressed(k)
	updateControls(k)
end

function love.mousepressed(x, y, k)
	mDown = true
	updateControls("M"..k)
	if k == 2 then
    --When clicked, check if on button. If not on button, drag the camera
    if not clickedButton[1] then
      dragCam = true
		camMovedX, camMovedY, camMoved = 0, 0 ,0
    end
	end

	if k == 3 then
		--show tile info
		
		local tile = grid.tiles[math.floor((mX - camX)/60)][math.floor((mY - camY)/60)]
		print("Tile Info:")
		print("Temp: "..tile.temp)
		print("Hotspot: "..tostring(tile.hotspot))
		print("Updated: "..tostring(tile.update))
		print("Cooling: "..tostring(tile.cooling))
		print("Building: "..tostring(tile.building))
		print("On Electric Network: "..tostring(tile.onElectricNetwork))
		print("Wire ID: "..tostring(tile.wireID))
		print("On Pipe Network: "..tostring(tile.onPipeNetwork))
		print("Pipe ID: "..tostring(tile.pipeID))
		print("Updated Time: "..tostring(tile.updatedTime))
		print("Conductivity: "..tostring(tile.conductivity))
		print("X: "..tostring(tile.x))
		print("Y: "..tostring(tile.y))
		print("___________________________________________________________")
	end

end

function love.mousereleased(x, y, k)
	mDown = false
	dragCam = false
	camMoved = math.findHyptenuse(camMovedX, camMovedY)
	clickedButton = {}

	updateControls("M"..k.."R")
	if draggedMenu then
		draggedMenu = false
	end
	--contextMenu.dragging = false
end

function love.mousemoved(x, y, dx, dy)
	if buildingMenuOpen then
		--Check to see if mouse is over a button
		hoverBuildingUI(x, y)
	end

	if draggedMenu then
		draggedMenu.x = draggedMenu.x + dx
		draggedMenu.y = draggedMenu.y + dy
	elseif dragCam then
		--drag the camera by measuring the distance the mouse moves each frame
		focusPointX = focusPointX - dx/scale
		focusPointY = focusPointY - dy/scale
		camMovedX = camMovedX + dx
		camMovedY = camMovedY + dy
	end

	--[[
	if contextMenu.dragging then
		contextMenu.x = contextMenu.x + dx
		contextMenu.y = contextMenu.y + dy
	end
	]]
end

function love.wheelmoved(x, y)
	if not dragCam then
		--adjust the scale then adjust varables that measure screen dimensions
		if y > 0 then
			scale = scale * 1.5
			scaledWindowWidth = windowWidth * scale
			scaledWindowHeight = windowHeight * scale
			scaledCenterWidth = scaledWindowWidth / 2
			scaledCenterHeight = scaledWindowHeight / 2
		elseif y < 0 then
			scale = scale / 1.5
			scaledWindowWidth = windowWidth * scale
			scaledWindowHeight = windowHeight * scale
			scaledCenterWidth = scaledWindowWidth / 2
			scaledCenterHeight = scaledWindowHeight / 2
		end
	end
end

function love.draw()
	love.graphics.scale(scale)
	
	--position the camera, camX & Y are the final positions after scaling, focusPoint X & Y is the center of the screen
	--by moving the focus point, you move the camera
	camX = -focusPointX + (centerWidth/scale)
	camY = -focusPointY + (centerHeight/scale)
	love.graphics.translate(camX, camY)


	if grid then
		drawWorld()
	end

	if gamestate == 1 then
		drawPlayer()
		drawDrones()
		drawUI()
	end
end