function drawWorld()
	--Determine what portion of the grid to draw based on the camera position and scale
	local xStart = math.floor((focusPointX - (centerWidth/scale)) / 60) - 5
	local xEnd = math.ceil((focusPointX + (centerWidth/scale)) / 60) + 4
	local yStart = math.floor((focusPointY - (centerHeight/scale)) / 60) - 5
	local yEnd = math.ceil((focusPointY + (centerHeight/scale)) / 60) + 4
	--The above math is to make sure that the grid is drawn in a way that it is always at least 5 tiles off screen in each direction

	--draw the grid
	tilesWithBuildings = {}
	for x = xStart, xEnd do
		vX = grid.tiles[x]
		if vX then
			for y = yStart, yEnd do
				vY = vX[y]
				if vY then
					--draw the tile
					if tempOverlay then
						if vY.temp > 200 then
							love.graphics.setColor(vY.temp/800, vY.temp/3000, vY.temp/3000)
						elseif vY.temp > 25 then
							love.graphics.setColor(vY.temp/800, (215 - vY.temp) / 350, 0.2)
						else
							love.graphics.setColor(0.07, (215 - vY.temp) / 350, (70 - vY.temp) / 100)
						end
						if vY.biome == "volcanic" then
							love.graphics.setColor(1,0,0)
							if vY.feature == "volcano" then
								love.graphics.setColor(0.5,0,0)
							end
						end
						if vY.biome == "lavaLake" then
							love.graphics.setColor(1,1,0)
						end
						if vY.biome == "driedLake" then
							love.graphics.setColor(0,0,1)
						end
						if vY.biome == "badlands" then
							love.graphics.setColor(0,1,1)
						end
						if vY.river then
							love.graphics.setColor(1,0,1)
						end
					else
						love.graphics.setColor(vY.temp/700, vY.temp/1000, 0.2)
						
					end
					
					if vY.update and showHotTiles then
						love.graphics.setColor(0,1,0)
					end
					--draw the tile
					love.graphics.rectangle("fill", x*60, y*60, 60, 60)
					--draw rock
					if vY.rock then
						love.graphics.setColor(0.5,0.5,0.5)
						love.graphics.rectangle("fill", x*60, y*60, 60, 60)
					end

					if networkOverlay then
						if vY.onPipeNetwork then
							love.graphics.setColor(0,vY.onPipeNetwork/#pipeNetworks.networks,vY.onPipeNetwork/#pipeNetworks.networks)
							buildingBlueprints[2].drawBuilding(vY)
						end
						if vY.onElectricNetwork then
							love.graphics.setColor(vY.onElectricNetwork/#electricNetworks.networks,vY.onElectricNetwork/#electricNetworks.networks,0)
							buildingBlueprints[1].drawBuilding(vY)
						end
					end
					
					if vY.building then
						table.insert(tilesWithBuildings, vY)
					end
				end
			end
		end
	end

	--draw the buildings
	for i, tile in pairs(tilesWithBuildings) do
		if tile.building then
			local building = buildingBlueprints[tile.building]
			building.drawBuilding(tile)
		end
	end
end

function drawPlayer()
	love.graphics.setColor(0,0,1)
	love.graphics.circle("fill", player.x, player.y, 15)
end

function drawDrones()
	for i, drone in pairs(drones) do
		love.graphics.setColor(0,1,0)
		love.graphics.circle("fill", drone.x, drone.y, 5)
	end
end

function drawUI()
	if placingBuilding or tileSelectionOpen or hubLinkOpen then
		constructionUI()
	end

	drawContextMenus()

	if not tileSelectionOpen then
		drawBuildingUI()
		droneProgramUI()
	end

	drawGameMessages()
end