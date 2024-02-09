function updateElectric()

	--update Generators
	for netID, net in pairs(electricNetworks.networks) do
		--reset charge on network
		electricNetworks.networkCharge[netID] = 0
		for genID, generator in pairs(electricNetworks.networkBuildings[netID].generators) do
			electricNetworks.networkCharge[netID] = electricNetworks.networkCharge[netID] + generator.building.powerGeneration
		end
	
		--update consumers
		for conID, consumer in pairs(electricNetworks.networkBuildings[netID].consumers) do
			electricNetworks.networkCharge[netID] = electricNetworks.networkCharge[netID] - consumer.building.powerConsumption
		end
		print("Charge of Network "..netID..": "..electricNetworks.networkCharge[netID])
	end

	--update storage
	

end

function connectElectric(tile)
	local x = tile.x
	local y = tile.y
	local networkID = #electricNetworks.networks + 1
	local wireID = 0

	if #electricNetworks.networks > 0 then
		--check for surrounding wires, and connect to them
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

		local foundNetwork = false
		for k, t in pairs(affectedTiles) do
			if t.onElectricNetwork then
				--if surrounded by wires from different networks combine the networks
				if not foundNetwork then
					foundNetwork = t.onElectricNetwork
				else
					if foundNetwork > t.onElectricNetwork then
						transferNetwork(foundNetwork, t.onElectricNetwork, "electric")
						foundNetwork = t.onElectricNetwork
					elseif foundNetwork ~= t.onElectricNetwork then
						transferNetwork(t.onElectricNetwork, foundNetwork, "electric")
					end
				
				end

			end
		end

		if foundNetwork then
			networkID = foundNetwork
			local t = {
				x = x,
				y = y,
				netID = networkID,
				onGenerator = false,
				onConsumer = false,
				onStorage = false
			}
			table.insert(electricNetworks.networks[networkID], t)
		else
			electricNetworks.networks[networkID] = {}
			electricNetworks.networkCharge[networkID] = 0
			electricNetworks.networkBuildings[networkID] = {
				generators = {},
				consumers = {},
				storage = {}
			}

			local t = {
				x = x,
				y = y,
				netID = networkID,
				onGenerator = false,
				onConsumer = false,
				onStorage = false
			}
			table.insert(electricNetworks.networks[networkID], t)
		end

		print("Wire put onto net "..networkID)
	else
		electricNetworks.networks[networkID] = {}
		electricNetworks.networkCharge[networkID] = 0
		electricNetworks.networkBuildings[networkID] = {
			generators = {},
			consumers = {},
			storage = {}
		}

		local t = {
			x = x,
			y = y,
			netID = networkID,
			onGenerator = false,
			onConsumer = false,
			onStorage = false
		}
		table.insert(electricNetworks.networks[networkID], t)
		
	end
	wireID = #electricNetworks.networks[networkID]
	tile.wireID = wireID
	tile.onElectricNetwork = networkID
end

function splitElectric(tile)
	local x = tile.x
	local y = tile.y
	local breakNetID = tile.onElectricNetwork

	--remove wire and buildings on tile
	electricNetworks.networkBuildings[breakNetID].generators[electricNetworks.networks[breakNetID][tile.wireID].onGenerator] = nil
	electricNetworks.networkBuildings[breakNetID].consumers[electricNetworks.networks[breakNetID][tile.wireID].onConsumer] = nil
	electricNetworks.networkBuildings[breakNetID].storage[electricNetworks.networks[breakNetID][tile.wireID].onStorage] = nil
	electricNetworks.networks[breakNetID][tile.wireID] = nil
	tile.onElectricNetwork = false
	tile.wireID = false

	--check for surrounding wires, and reconfigure their networks
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

	--Find surrounding tiles that have a network
	local tilesFound = 1
	local leadNetID = false
	for k, t in pairs(affectedTiles) do
		local moveTiles = {}
		if t.onElectricNetwork == breakNetID then
			print("Splitting Network "..breakNetID.." "..tilesFound.." times...")
			local toNetID = #electricNetworks.networks + 1
			if not leadNetID then
				leadNetID = toNetID
			end
			electricNetworks.networks[toNetID] = {}
			electricNetworks.networkCharge[toNetID] = 0
			electricNetworks.networkBuildings[toNetID] = {
			generators = {},
			consumers = {},
			storage = {}
			}
			tilesFound = tilesFound + 1
			table.insert(moveTiles, t)

			--Move wire path to new network
			while #moveTiles > 0 do
				local pathTile = moveTiles[#moveTiles]
				local pX = pathTile.x
				local pY = pathTile.y
				table.remove(moveTiles, #moveTiles)
				if pathTile.onElectricNetwork == breakNetID then
					--check around tile
					if grid.tiles[pX + 1] then
						if grid.tiles[pX + 1][pY].onElectricNetwork == breakNetID then
							table.insert(moveTiles, grid.tiles[pX + 1][pY])
							print("Found tile on net "..grid.tiles[pX + 1][pY].onElectricNetwork)
						end
					end
				
					if grid.tiles[pX - 1] then
						if grid.tiles[pX - 1][pY].onElectricNetwork == breakNetID then
							table.insert(moveTiles, grid.tiles[pX - 1][pY])
							print("Found tile on net "..grid.tiles[pX - 1][pY].onElectricNetwork)
						end
					end
					
					if grid.tiles[pX][pY + 1] then
						if grid.tiles[pX][pY + 1].onElectricNetwork == breakNetID then
							table.insert(moveTiles, grid.tiles[pX][pY + 1])
							print("Found tile on net "..grid.tiles[pX][pY + 1].onElectricNetwork)
						end
					end
				
					if grid.tiles[pX][pY - 1] then
						if grid.tiles[pX][pY - 1].onElectricNetwork == breakNetID then
							table.insert(moveTiles, grid.tiles[pX][pY - 1])
							print("Found tile on net "..grid.tiles[pX][pY - 1].onElectricNetwork)
						end
					end

					--move tile to new network
					print("Moving Wire "..pathTile.wireID)
					local tileWire = electricNetworks.networks[breakNetID][pathTile.wireID]
					print(tileWire, #electricNetworks.networks[breakNetID], pathTile.wireID)
					--move generator
					--breakpoint({tileWire=tileWire})
					if tileWire.onGenerator then
						table.insert(electricNetworks.networkBuildings[toNetID].generators, electricNetworks.networkBuildings[breakNetID].generators[tileWire.onGenerator])
						electricNetworks.networkBuildings[breakNetID].generators[tileWire.onGenerator] = nil
						tileWire.onGenerator = #electricNetworks.networkBuildings[toNetID].generators
					end
					--move consumer
					if tileWire.onConsumer then
						table.insert(electricNetworks.networkBuildings[toNetID].consumers, electricNetworks.networkBuildings[breakNetID].consumers[tileWire.onConsumer])
						electricNetworks.networkBuildings[breakNetID].consumers[tileWire.onConsumer] = nil
						tileWire.onConsumer = #electricNetworks.networkBuildings[toNetID].consumers
					end
					--move storage
					if tileWire.onStorage then
						table.insert(electricNetworks.networkBuildings[toNetID].storage, electricNetworks.networkBuildings[breakNetID].storage[tileWire.onStorage])
						electricNetworks.networkBuildings[breakNetID].storage[tileWire.onStorage] = nil
						tileWire.onStorage = #electricNetworks.networkBuildings[toNetID].storage
					end
					--move wire
					tileWire.netID = toNetID 
					pathTile.onElectricNetwork = toNetID 
					table.insert(electricNetworks.networks[toNetID], tileWire)
					electricNetworks.networks[breakNetID][pathTile.wireID] = nil
					pathTile.wireID = #electricNetworks.networks[toNetID]
					print("New Wire ID: "..pathTile.wireID)
				end
			end
		end
	end
	
	transferNetwork(breakNetID, breakNetID, "electric")
end

function updatePipes()
	for netID, net in pairs(pipeNetworks.networks) do
		for radID, radiator in pairs(pipeNetworks.networkBuildings[netID].radiators) do
			--Act as a radiator
			print("Radiator "..radiator.building.name.." on Network "..netID.." is transferring heat")
			radiator.building.buildingFunction(grid.tiles[radiator.x][radiator.y])
		end

		for colID, collector in pairs(pipeNetworks.networkBuildings[netID].collectors) do
			--Act as a collector
			print("Collector "..collector.building.name.." on Network "..netID.." is collecting heat")
			collector.building.buildingFunction(grid.tiles[collector.x][collector.y])
		end
	end
end

function connectPipes(tile)
	local x = tile.x
	local y = tile.y
	local networkID = #pipeNetworks.networks + 1
	local pipeID = 0

	if #pipeNetworks.networks > 0 then
		--check for surrounding pipes, and connect to them
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

		local foundNetwork = false
		for k, t in pairs(affectedTiles) do
			if t.onPipeNetwork then
				--if surrounded by pipes from different networks combine the networks
				if not foundNetwork then
					foundNetwork = t.onPipeNetwork
				else
					if foundNetwork > t.onPipeNetwork then
						transferNetwork(foundNetwork, t.onPipeNetwork, "pipe")
						foundNetwork = t.onPipeNetwork
					elseif foundNetwork ~= t.onPipeNetwork then
						transferNetwork(t.onPipeNetwork, foundNetwork, "pipe")
					end
				
				end

			end
		end

		if foundNetwork then
			networkID = foundNetwork
			local t = {
				x = x,
				y = y,
				netID = networkID,
				onRadiator = false,
				onCollector = false
			}
			table.insert(pipeNetworks.networks[networkID], t)
			tile.update = true
		else
			pipeNetworks.networks[networkID] = {}
			pipeNetworks.networkBuildings[networkID] = {
				radiators = {},
				collectors = {}
			}
			pipeNetworks.networkHeat[networkID] = 0

			local t = {
				x = x,
				y = y,
				netID = networkID,
				onRadiator = false,
				onCollector = false
			}
			table.insert(pipeNetworks.networks[networkID], t)
			tile.update = true
		end

		print("Pipe put onto net "..networkID)
	else
		pipeNetworks.networks[networkID] = {}
		pipeNetworks.networkBuildings[networkID] = {
			radiators = {},
			collectors = {}
		}
		pipeNetworks.networkHeat[networkID] = 0

		local t = {
			x = x,
			y = y,
			netID = networkID,
			onRadiator = false,
			onCollector = false
		}
		table.insert(pipeNetworks.networks[networkID], t)
		tile.update = true
		
	end
	grid.updateTiles[x][y] = true
	pipeID = #pipeNetworks.networks[networkID]
	tile.pipeID = pipeID
	tile.onPipeNetwork = networkID
end

function splitPipe(tile)
	local x = tile.x
	local y = tile.y
	local breakNetID = tile.onPipeNetwork

	--remove pipe and buildings on tile
	pipeNetworks.networkBuildings[breakNetID].radiators[pipeNetworks.networks[breakNetID][tile.pipeID].onRadiator] = nil
	pipeNetworks.networks[breakNetID][tile.pipeID] = nil
	tile.onPipeNetwork = false
	tile.pipeID = false
	tile.cooling = false

	--check for surrounding pipes, and reconfigure their networks
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

	--Find surrounding tiles that have a network
	local tilesFound = 1
	local leadNetID = false
	for k, t in pairs(affectedTiles) do
		local moveTiles = {}
		if t.onPipeNetwork == breakNetID then
			print("Splitting Network "..breakNetID.." "..tilesFound.." times...")
			local toNetID = #pipeNetworks.networks + 1
			if not leadNetID then
				leadNetID = toNetID
			end
			pipeNetworks.networks[toNetID] = {}
			pipeNetworks.networkBuildings[toNetID] = {
				radiators = {}
			}
			pipeNetworks.networkHeat[toNetID] = 0
			tilesFound = tilesFound + 1
			table.insert(moveTiles, t)

			--Move pipe path to new network
			while #moveTiles > 0 do
				local pathTile = moveTiles[#moveTiles]
				local pX = pathTile.x
				local pY = pathTile.y
				table.remove(moveTiles, #moveTiles)
				if pathTile.onPipeNetwork == breakNetID then
					--check around tile
					if grid.tiles[pX + 1] then
						if grid.tiles[pX + 1][pY].onPipeNetwork == breakNetID then
							table.insert(moveTiles, grid.tiles[pX + 1][pY])
							print("Found tile on net "..grid.tiles[pX + 1][pY].onPipeNetwork)
						end
					end
				
					if grid.tiles[pX - 1] then
						if grid.tiles[pX - 1][pY].onPipeNetwork == breakNetID then
							table.insert(moveTiles, grid.tiles[pX - 1][pY])
							print("Found tile on net "..grid.tiles[pX - 1][pY].onPipeNetwork)
						end
					end
					
					if grid.tiles[pX][pY + 1] then
						if grid.tiles[pX][pY + 1].onPipeNetwork == breakNetID then
							table.insert(moveTiles, grid.tiles[pX][pY + 1])
							print("Found tile on net "..grid.tiles[pX][pY + 1].onPipeNetwork)
						end
					end
				
					if grid.tiles[pX][pY - 1] then
						if grid.tiles[pX][pY - 1].onPipeNetwork == breakNetID then
							table.insert(moveTiles, grid.tiles[pX][pY - 1])
							print("Found tile on net "..grid.tiles[pX][pY - 1].onPipeNetwork)
						end
					end

					--move tile to new network
					print("Moving Pipe "..pathTile.pipeID)
					local tilePipe = pipeNetworks.networks[breakNetID][pathTile.pipeID]
					print(tilePipe, #pipeNetworks.networks[breakNetID], pathTile.pipeID)
					--breakpoint({tilePipe=tilePipe})

					--move radiator
					if tilePipe.onRadiator then
						table.insert(pipeNetworks.networkBuildings[toNetID].radiators, pipeNetworks.networkBuildings[breakNetID].radiators[tilePipe.onRadiator])
						pipeNetworks.networkBuildings[breakNetID].radiators[tilePipe.onRadiator] = nil
						tilePipe.onRadiator = #pipeNetworks.networkBuildings[toNetID].radiators
					end

					--move collector
					if tilePipe.onCollector then
						table.insert(pipeNetworks.networkBuildings[toNetID].collectors, pipeNetworks.networkBuildings[breakNetID].collectors[tilePipe.onCollector])
						pipeNetworks.networkBuildings[breakNetID].collectors[tilePipe.onCollector] = nil
						tilePipe.onCollector = #pipeNetworks.networkBuildings[toNetID].collectors
					end
				
					--move pipe
					tilePipe.netID = toNetID 
					pathTile.onPipeNetwork = toNetID 
					table.insert(pipeNetworks.networks[toNetID], tilePipe)
					pipeNetworks.networks[breakNetID][pathTile.pipeID] = nil
					pathTile.pipeID = #pipeNetworks.networks[toNetID]
					print("New Pipe ID: "..pathTile.pipeID)
				end
			end
		end
	end
	
	transferNetwork(breakNetID, breakNetID, "pipe")
end

function transferNetwork(netID, toNetID, netType)
	print("transferring "..netType..": Net "..netID.." to Net "..toNetID)
	
	if netType == "electric" then
		--move wires
		print("Moving Wires...")
		for ID, wire in pairs(electricNetworks.networks[netID]) do
			--put wire into desired network
			print(wire.x, wire.y, wire.netID, grid.tiles[wire.x][wire.y].onElectricNetwork, grid.tiles[wire.x][wire.y].wireID)
			table.insert(electricNetworks.networks[toNetID], wire)

			--update values of tile and wire
			electricNetworks.networks[toNetID][#electricNetworks.networks[toNetID]].netID = toNetID
			grid.tiles[wire.x][wire.y].onElectricNetwork = toNetID
			grid.tiles[wire.x][wire.y].wireID = #electricNetworks.networks[toNetID]

			
			print(electricNetworks.networks[toNetID][#electricNetworks.networks[toNetID]].x, electricNetworks.networks[toNetID][#electricNetworks.networks[toNetID]].y, electricNetworks.networks[toNetID][#electricNetworks.networks[toNetID]].netID, grid.tiles[wire.x][wire.y].onElectricNetwork, grid.tiles[wire.x][wire.y].wireID)
		end
		--remove previous wire network
		table.remove(electricNetworks.networks, netID)

		--move buildings
		print("Moving Buildings")
		--move generators
		print("	Moving Generators")
		for ID, building in pairs(electricNetworks.networkBuildings[netID].generators) do
			print(building.building.name)
			--put building in desired network
			table.insert(electricNetworks.networkBuildings[toNetID].generators, building)
			electricNetworks.networks[toNetID][grid.tiles[building.x][building.y].wireID].onGenerator = #electricNetworks.networkBuildings[toNetID].generators
		end
		--move consumers
		print("	Moving Consumers")
		for ID, building in pairs(electricNetworks.networkBuildings[netID].consumers) do
			print(building.building.name)
			--put building in desired network
			table.insert(electricNetworks.networkBuildings[toNetID].consumers, building)
			electricNetworks.networks[toNetID][grid.tiles[building.x][building.y].wireID].onConsumer = #electricNetworks.networkBuildings[toNetID].consumers
		end
		--move storage
		print("	Moving Storage")
		for ID, building in pairs(electricNetworks.networkBuildings[netID].storage) do
			print(building.building.name)
			--put building in desired network
			table.insert(electricNetworks.networkBuildings[toNetID].storage, building)
			electricNetworks.networks[toNetID][grid.tiles[building.x][building.y].wireID].onStorage = #electricNetworks.networkBuildings[toNetID].storage
		end
		--remove previous buildings network
		table.remove(electricNetworks.networkBuildings, netID)

		--remove previous network charge
		table.remove(electricNetworks.networkCharge, netID)

		--shift networks to match the new new values in the moved tables
		if netID <= #electricNetworks.networks then
			for n = netID, #electricNetworks.networks do
				for ID, wire in pairs(electricNetworks.networks[n]) do
					print("Resetting value "..wire.netID.." and "..grid.tiles[wire.x][wire.y].onElectricNetwork)
					grid.tiles[wire.x][wire.y].onElectricNetwork = n
					wire.netID = n
					print("To "..wire.netID.." and "..grid.tiles[wire.x][wire.y].onElectricNetwork)
				end

			end
		end



	elseif netType == "pipe" then
		print("Transfer Pipe Network "..netID.." to Pipe Network "..toNetID)
		--move pipes
		print("Moving Pipes...")
		for ID, pipe in pairs(pipeNetworks.networks[netID]) do
			--put pipe into desired network
			print(pipe.x, pipe.y, pipe.netID, grid.tiles[pipe.x][pipe.y].onPipeNetwork, grid.tiles[pipe.x][pipe.y].pipeID)
			table.insert(pipeNetworks.networks[toNetID], pipe)

			--update values of tile and pipe
			pipeNetworks.networks[toNetID][#pipeNetworks.networks[toNetID]].netID = toNetID
			grid.tiles[pipe.x][pipe.y].onPipeNetwork = toNetID
			grid.tiles[pipe.x][pipe.y].pipeID = #pipeNetworks.networks[toNetID]

			
			print(pipeNetworks.networks[toNetID][#pipeNetworks.networks[toNetID]].x, pipeNetworks.networks[toNetID][#pipeNetworks.networks[toNetID]].y, pipeNetworks.networks[toNetID][#pipeNetworks.networks[toNetID]].netID, grid.tiles[pipe.x][pipe.y].onPipeNetwork, grid.tiles[pipe.x][pipe.y].pipeID)
		end
		--remove previous pipe network
		table.remove(pipeNetworks.networks, netID)

		--move buildings
		print("Moving Buildings")
		--move radiators
		print("	Moving Radiators")
		for ID, building in pairs(pipeNetworks.networkBuildings[netID].radiators) do
			print(building.building.name)
			--put building in desired network
			table.insert(pipeNetworks.networkBuildings[toNetID].radiators, building)
			pipeNetworks.networks[toNetID][grid.tiles[building.x][building.y].pipeID].onRadiator = #pipeNetworks.networkBuildings[toNetID].radiators
		end

		--move collectors
		print("	Moving Collectors")
		for ID, building in pairs(pipeNetworks.networkBuildings[netID].collectors) do
			print(building.building.name)
			--put building in desired network
			table.insert(pipeNetworks.networkBuildings[toNetID].collectors, building)
			pipeNetworks.networks[toNetID][grid.tiles[building.x][building.y].pipeID].onCollector = #pipeNetworks.networkBuildings[toNetID].collectors
		end

		--remove previous buildings network
		table.remove(pipeNetworks.networkBuildings, netID)

		--shift networks to match the new new values in the moved tables
		if netID <= #pipeNetworks.networks then
			for n = netID, #pipeNetworks.networks do
				for ID, pipe in pairs(pipeNetworks.networks[n]) do
					print("Resetting value "..pipe.netID.." and "..grid.tiles[pipe.x][pipe.y].onPipeNetwork)
					grid.tiles[pipe.x][pipe.y].onPipeNetwork = n
					pipe.netID = n
					print("To "..pipe.netID.." and "..grid.tiles[pipe.x][pipe.y].onPipeNetwork)
				end

			end
		end
	end
end