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
	Grid system - Have a grid with tiles that hold different bits of data like its temp and other things (DONE)
	Generate world - Generate a random world that has random features, as well as save and load worlds
		- On generation, have a small patch of land that is not super hot where the player starts with a drop pod 
		- Add more features and biomes
			- features may include: 
				- Irregular grid shape, like more of a circle
				- Dried Lakes
				- Dried Rivers
				- Volcanic areas
				- Elevated terrain
	Thermal system - Manage the heat of important tiles and determine which tiles are important (DONE)
	Player Control - Different ways the user interacts with the player character
		- Player stays within a radius of the center of the screen 
		- Player moves based on actions from user: placing buildings, moving drones, interacting with tiles, etc...
	Buildings - Functional/Decorative buildings that can be placed with materials
		- Add more buildings
		- Implement a material cost to place buildings
	Weather - Natural events like cloudy skies that effect gameplay in different ways
	Context Menu System - Have a list of context menus that display different bits of info depending on the data it is given 
		- Fix button interactions not lining up with the actual button
	Inventories - Have a list of inventories that hold a certain amount of items as well as having functions to transfer items between them (DONE)
	Drones - Have a list of drones that can be programmed by the player to do certain tasks 
		- Implement scolling in drone program menu
		- Have drones need charge and a hub to function
	User Interface - Implement a user interface for everything
		- Main menu and planet selection
		- Loading saves and creating new saves
		- In game UI
		- Loading screens
		- Pause menu
	Graphics - Provide better visuals and animations
		- Fix the line that connects to context menus
		- Animation system
		- Textures for player, drones, buildings, etc...
		- Weather effects
		- Calculate color of tiles based on their heat and make the square tiles less obvious
		- Add shadows to different elevation tiles and buildings
		- Textures for tiles outside the available sector
	


	Optimization improvements:
		The electric and pipe network updates cause a lot of lag when there are many buildings on the nets. They are updated every second and this causes unnessecary lag. They should pre-calculate all needed values when a new building is placed instead of every second. Anything that does need dynamic updates should be changed by a different function. The old update functions can be kept for when the world is loaded and the networks are loaded. (DONE)
			- Electric network updates can be optimized by only updating relevant values when a new building is connected.
			- Pipe network updates can be optimized by reducing the amount of times that the radiators and heat collectors need to run their update functions. They should only run when certain events like electric charge updating. Radiators can act like the opposite of heat collectors by giving the tile it is on the tile.heating value. This value can be used to determine if the tile needs to be updated like with tile.cooling.

		The entire grid is drawn every frame. Only the tiles on screen should be drawn to save resources. (DONE)

		Even with the optimized heat updates where only important tiles are updated, this may still become laggy when the grid becomes larger. All important tiles still need to be updated, but they may need to be staggered.


FUTURE IDEAS
	Sector expansion - Have the player be able to expand the grid to a new sector of the planet
	New planets - Have the player be able to unlock new assigned planets that they can go to and cool down. This would be enabled by cooling off previous planets and gaining good reputation with the company
	Previous employees - Have the player be able to find the remains of previous employees in new sectors (including the starting sector) which would give the player new items and information about the planet

]]


function love.load()
	jit.off()
	require("core/boot/boot")
	boot()
	logMessage("Boot Complete")
end

function love.update(dt)
	if love.keyboard.isDown("r") then
		genNewWorld(100)
	end
	runTime = runTime + dt
	gameTime = gameTime + dt

	--get mouse coords and scale them
	screenMX, screenMY = love.mouse.getPosition()
	mX, mY = screenMX / scale, screenMY / scale

	
	
	
	if gamestate == "game" then
		updatePlayerPosition(dt)
		updateDronesPosition(dt)

		for droneID, drone in pairs(drones) do
			if drone.timeToProgramUpdate <= gameTime and drone.onEvent then
				updateDroneProgram(drone)
			end
		end

		if gameTime - updateTime >= 1 then
			countUpdatedTiles()

			--updateElectric()

			--updatePipes()

			updateTime = gameTime
		end

		updateTiles(dt)

		if gameTime - randomUpdateTime >= 0.1 then
			local randX = math.random(-gridSize/2, gridSize/2 - 1)
			local randY = math.random(-gridSize/2, gridSize/2 - 1)
			--print(randX, randY, grid.tiles[randX])
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
end

function love.mousemoved(x, y, dx, dy)
	updateControls(false)

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
end

function love.wheelmoved(x, y)
	if not dragCam then
		--adjust the scale then adjust varables that measure screen dimensions
		if y > 0 then
			updateControls("up")
			
			--[[scaledWindowWidth = windowWidth * scale
			scaledWindowHeight = windowHeight * scale
			scaledCenterWidth = scaledWindowWidth / 2
			scaledCenterHeight = scaledWindowHeight / 2]]
		elseif y < 0 then
			updateControls("down")

			--[[scaledWindowWidth = windowWidth * scale
			scaledWindowHeight = windowHeight * scale
			scaledCenterWidth = scaledWindowWidth / 2
			scaledCenterHeight = scaledWindowHeight / 2]]
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

	if gamestate == "game" then
		drawWorld()
		drawPlayer()
		drawDrones()
	end
	
	drawUI()
end