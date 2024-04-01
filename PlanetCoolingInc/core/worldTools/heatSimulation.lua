function updateTileHeat(x, y)
	local tile = grid.tiles[x][y]
	local timeSinceUpdate = gameTime - tile.updatedTime
	--If hotspot, increase heat more
	if tile.hotspot then
		tile.temp = tile.temp + ((tile.conductivity*(3000-tile.temp))/3600)
	end

	--If cooling, put heat into pipe network
	--If Heating, take heat from pipe network and put into tile
	if tile.cooling and ((tile.powerConsumption and electricNetworks.networkCharge[tile.onElectricNetwork] >= 0) or not tile.powerConsumption) then
		if pipeNetworks.networkHeat[tile.onPipeNetwork] < 700 then
			--Take heat from tile and store it in pipe network
			local heatStored = ((tile.conductivity*(tile.temp-math.min(40, pipeNetworks.networkHeat[tile.onPipeNetwork])))/3600)
			tile.temp = tile.temp - heatStored
			pipeNetworks.networkHeat[tile.onPipeNetwork] = pipeNetworks.networkHeat[tile.onPipeNetwork] + heatStored
		end
	elseif tile.heating and ((tile.powerConsumption and electricNetworks.networkCharge[tile.onElectricNetwork] >= 0) or not tile.powerConsumption) then
		--Output heat from pipe network into tile
		if pipeNetworks.networkHeat[tile.onPipeNetwork] > tile.temp then
			local heatStored = ((tile.conductivity*(pipeNetworks.networkHeat[tile.onPipeNetwork]-tile.temp))/3600)
			tile.temp = tile.temp + heatStored
			pipeNetworks.networkHeat[tile.onPipeNetwork] = pipeNetworks.networkHeat[tile.onPipeNetwork] - heatStored
		end
	end
	--Spread heat to nearby tiles
	local heatTransferRate = 0
	local heatTransferred = 0
	local totalHeatTransferred = 0
	
	local tile1 = {}
	local tile2 = {}
	local tile3 = {}
	local tile4 = {}

	if grid.tiles[x + 1] then
		tile1 = grid.tiles[x + 1][y]
	end

	if grid.tiles[x - 1] then
		tile2 = grid.tiles[x - 1][y]
	end
	
	if grid.tiles[x][y + 1] then
		tile3 = grid.tiles[x][y + 1]
	end

	if grid.tiles[x][y - 1] then
		tile4 = grid.tiles[x][y - 1]
	end
	local affectedTiles = {
		tile1, 
		tile2,
		tile3,
		tile4
	}

	for k, t in pairs(affectedTiles) do
		if t.temp then
			if tile.temp > t.temp then
				heatTransferRate = (tile.conductivity*(tile.temp-t.temp))/3600
				heatTransferred = heatTransferRate
				t.temp = t.temp + heatTransferred
				totalHeatTransferred = totalHeatTransferred + heatTransferred
			end
		end
	end

	tile.temp = tile.temp - totalHeatTransferred

	--check for new relatively hot tiles
	local function checkForRelHot(rX,rY)
		--print(rX,rY)
		local tempTolerance = 10
		local relTile = grid.tiles[rX][rY]
		local relTile1 = {}
		local relTile2 = {}
		local relTile3 = {}
		local relTile4 = {}


		if grid.tiles[rX + 1] and grid.tiles[rX + 1][rY] then
			relTile1 = grid.tiles[rX + 1][rY]
		else
			relTile1 = relTile
		end

		if grid.tiles[rX - 1] and grid.tiles[rX - 1][rY] then
			relTile2 = grid.tiles[rX - 1][rY]
		else
			relTile2 = relTile
		end

		if grid.tiles[rX][rY + 1] then
			relTile3 = grid.tiles[rX][rY + 1]
		else
			relTile3 = relTile
		end

		if grid.tiles[rX][rY - 1] then
			relTile4 = grid.tiles[rX][rY - 1]
		else
			relTile4 = relTile
		end

		if relTile.temp-relTile1.temp > tempTolerance then
			relTile.update = true
			grid.updateTiles[rX][rY] = true

		elseif relTile.temp-relTile2.temp > tempTolerance then
			relTile.update = true
			grid.updateTiles[rX][rY] = true

		elseif relTile.temp-relTile3.temp > tempTolerance then
			relTile.update = true
			grid.updateTiles[rX][rY] = true

		elseif relTile.temp-relTile4.temp > tempTolerance then
			relTile.update = true
			grid.updateTiles[rX][rY] = true

		elseif not relTile.hotspot and not relTile.cooling and not relTile.heating then
			relTile.update = false
			grid.updateTiles[rX][rY] = nil
		end
	end
	
	if grid.tiles[x + 1] and grid.tiles[x + 1][y] then
		checkForRelHot(x + 1, y)
	end

	if grid.tiles[x - 1] and grid.tiles[x - 1][y] then
		checkForRelHot(x - 1, y)
	end
	
	if grid.tiles[x][y + 1] then
		checkForRelHot(x, y + 1)
	end

	if grid.tiles[x][y - 1] then
		checkForRelHot(x, y - 1)
	end

	if not tile.hotspot and not tile.cooling and not tile.heating then
		checkForRelHot(x,y)
	end
		
	tile.updatedTime = gameTime
	--print(x,y)
end

function fullGridUpdate()
	for x, vX in pairs(grid.tiles) do
		
		for y, vY in pairs(vX) do
			updateTileHeat(x,y)
		end
	end
end

function countUpdatedTiles()
	updateTiles = updateImportantTiles()
end

function updateImportantTiles()
	local updateDelay = 0
	local updatedTiles = {}
	local updateTilesCount = 0
	for x, vX in pairs(grid.updateTiles) do
		for y, vY in pairs(vX) do
			table.insert(updatedTiles, {x = x, y = y})
			updateTilesCount = updateTilesCount + 1
		end
	end

	local updateAmount = updateTilesCount / 20
	local currentIndex = currentIndex and (currentIndex > #updatedTiles and 1 or currentIndex) or 1
	local updateTimer = 0

	local function updateNextTile(dt)
		updateTimer = updateTimer + dt
		if updateTimer >= updateDelay then
			for i = 1, updateAmount do
				local tile = updatedTiles[currentIndex]
				if tile then
					updateTileHeat(tile.x, tile.y)
					if grid.tiles[tile.x][tile.y].hasContextMenu then
						updateContextMenu(grid.tiles[tile.x][tile.y].contextMenuID)
					end
					currentIndex = currentIndex + 1
				end
			end
			updateTimer = 0
		end
	end

	return updateNextTile
end