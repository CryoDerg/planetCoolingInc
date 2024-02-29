function drawWorld()
	--draw the grid
	tilesWithBuildings = {}
	for x, vX in pairs(grid.tiles) do
		for y, vY in pairs(vX) do
			if tempOverlay then
				if vY.temp > 200 then
					love.graphics.setColor(vY.temp/800, vY.temp/3000, vY.temp/3000)
				elseif vY.temp > 25 then
					love.graphics.setColor(vY.temp/800, (215 - vY.temp) / 350, 0.2)
				else
					love.graphics.setColor(0.07, (215 - vY.temp) / 350, (70 - vY.temp) / 100)
				end
			else
				love.graphics.setColor(vY.temp/700, vY.temp/1000, 0.2)
				
			end
			
			if vY.update and showHotTiles then
				love.graphics.setColor(0,1,0)
			end
			love.graphics.rectangle("fill", x*60, y*60, 60, 60)

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

	--draw the buildings
	for i, tile in pairs(tilesWithBuildings) do
		if tile.building then
			tile.building.drawBuilding(tile)
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
	if placingBuilding then
		constructionUI()
	end

	drawContextMenus()
	drawBuildingUI()
end