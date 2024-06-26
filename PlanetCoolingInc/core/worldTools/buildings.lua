function initBuildings()
	--store all buildings, that can be used, in a table

	buildingBlueprints = {
		--Wire[1]
		{
			name = "Wire",
			description = "Connects buildings to the electric network",
			placeBuilding = function(tile)
				if not tile.onElectricNetwork then
					connectElectric(tile)
					tile.building = buildingBlueprints[1]
				end
			end
			,

			removeBuilding = function(tile)
				splitElectric(tile)
				tile.building = false
			end
		},

		--Pipe[2]
		{
			name = "Pipe",
			description = "Connects buildings to the pipe network",
			placeBuilding = function(tile)
				if not tile.onPipeNetwork then
					connectPipes(tile)
					tile.building = buildingBlueprints[2]
				end
			end
			,

			removeBuilding = function(tile)
				splitPipe(tile)
				tile.building = false
			end
		},

		--Drop pod[3]
		{
			name = "Drop Pod",
			description = "Generates electricity and radiates heat",

			--Generate Electricity with solar panel
			powerGeneration = 300,

			--Consume Electricity with Radiator
			powerConsumption = 250,

			--when placed
			placeBuilding = function(tile)
				--Associate builing with tile
				tile.building = buildingBlueprints[3]

				--Connect to electric network
				if not tile.onElectricNetwork then
					connectElectric(tile)
				end
				
				--Put building in the network
				table.insert(electricNetworks.networkBuildings[tile.onElectricNetwork].generators, {building = buildingBlueprints[3], x=tile.x, y=tile.y})
				table.insert(electricNetworks.networkBuildings[tile.onElectricNetwork].consumers, {building = buildingBlueprints[3], x=tile.x, y=tile.y})

				--associate building ID with the wire it is on
				local wire = electricNetworks.networks[tile.onElectricNetwork][tile.wireID]
				wire.onGenerator = #electricNetworks.networkBuildings[tile.onElectricNetwork].generators
				wire.onConsumer = #electricNetworks.networkBuildings[tile.onElectricNetwork].consumers

				--connect to pipe network
				if not tile.onPipeNetwork then
					connectPipes(tile)
				end

				--Put building in the network
				table.insert(pipeNetworks.networkBuildings[tile.onPipeNetwork].radiators, {building = buildingBlueprints[3], x=tile.x, y=tile.y})

				--associate building ID with the pipe it is on
				local pipe = pipeNetworks.networks[tile.onPipeNetwork][tile.pipeID]
				pipe.onRadiator = #pipeNetworks.networkBuildings[tile.onPipeNetwork].radiators
			end
			,

			removeBuilding = function(tile)
				splitElectric(tile)
				splitPipe(tile)
				tile.building = false
			end
			,
			
			--passive operation
			buildingFunction = function(tile)
				--Act as a radiator that outputs heat from the pipe network
				if electricNetworks.networkCharge[tile.onElectricNetwork] >= 0 then
					print("Drop Pod Radiating, using 250 Watts from Network "..tile.onElectricNetwork)
					local heatTransferred = 0
					if pipeNetworks.networkHeat[tile.onPipeNetwork] > tile.temp then
						heatTransferred = ((tile.conductivity*(pipeNetworks.networkHeat[tile.onPipeNetwork]-tile.temp))/3600)
						tile.temp = tile.temp + (heatTransferred * 0.8)
						pipeNetworks.networkHeat[tile.onPipeNetwork] = pipeNetworks.networkHeat[tile.onPipeNetwork] - heatTransferred
						updateTileHeat(tile.x, tile.y)
					end
					print("Transferred "..heatTransferred.." Degrees...\nNew Network Heat: "..pipeNetworks.networkHeat[tile.onPipeNetwork])
				end
			end
		},

		--Heat Collector[4]
		{	
			--Connects to pipe network and uses electricity to take heat and put it into the pipe network
			name = "Heat Collector",
			description = "Collects heat from the ground and puts it into the pipe network",

			--Consume Electricity with Heat Pump
			powerConsumption = 100,

			--when placed
			placeBuilding = function(tile)
				--Associate builing with tile
				tile.building = buildingBlueprints[4]

				--Connect to electric network
				if not tile.onElectricNetwork then
					connectElectric(tile)
				end
				
				--Put building in the network
				table.insert(electricNetworks.networkBuildings[tile.onElectricNetwork].consumers, {building = buildingBlueprints[4], x=tile.x, y=tile.y})

				--associate building ID with the wire it is on
				local wire = electricNetworks.networks[tile.onElectricNetwork][tile.wireID]
				wire.onConsumer = #electricNetworks.networkBuildings[tile.onElectricNetwork].consumers

				--connect to pipe network
				if not tile.onPipeNetwork then
					connectPipes(tile)
				end

				--Put building in the network
				table.insert(pipeNetworks.networkBuildings[tile.onPipeNetwork].collectors, {building = buildingBlueprints[4], x=tile.x, y=tile.y})

				--associate building ID with the pipe it is on
				local pipe = pipeNetworks.networks[tile.onPipeNetwork][tile.pipeID]
				pipe.onCollector = #pipeNetworks.networkBuildings[tile.onPipeNetwork].collectors
			end
			,

			removeBuilding = function(tile)
				splitElectric(tile)
				splitPipe(tile)
				tile.building = false
				tile.cooling = false
			end
			,

			--passive operation
			buildingFunction = function(tile)
				--Collects heat from the tile and puts it into the pipe network
				if electricNetworks.networkCharge[tile.onElectricNetwork] >= 0 and pipeNetworks.networkHeat[tile.onPipeNetwork] < 700 then
					tile.cooling = true
					tile.update = true
					grid.updateTiles[tile.x][tile.y] = true
					print("Heat Collector running, using 100 Watts from Network "..tile.onElectricNetwork.." to cool tile by "..((tile.conductivity*(tile.temp-math.min(95, pipeNetworks.networkHeat[tile.onPipeNetwork])))/3600).." Degrees")
				else
					tile.cooling = false
					if pipeNetworks.networkHeat[tile.onPipeNetwork] >= 700 then
						print("Heat Collector not running, pipe network too hot!")
					else
						print("Heat Collector not running, no power on Network "..tile.onElectricNetwork)
					end
				end
			end
		},

		--Solar Panel[5]
		{
			--Connects to electric network and generates electricity
			name = "Solar Panel",
			description = "Generates electricity from the sun",

			--Generate Electricity with solar panel
			powerGeneration = 100,

			--when placed
			placeBuilding = function(tile)
				--Associate builing with tile
				tile.building = buildingBlueprints[5]

				--Connect to electric network
				if not tile.onElectricNetwork then
					connectElectric(tile)
				end
				
				--Put building in the network
				table.insert(electricNetworks.networkBuildings[tile.onElectricNetwork].generators, {building = buildingBlueprints[5], x=tile.x, y=tile.y})

				--associate building ID with the wire it is on
				local wire = electricNetworks.networks[tile.onElectricNetwork][tile.wireID]
				wire.onGenerator = #electricNetworks.networkBuildings[tile.onElectricNetwork].generators
			end
			,

			removeBuilding = function(tile)
				splitElectric(tile)
				tile.building = false
			end
			,

			--passive operation
			buildingFunction = function(tile)
				--Act as a generator
				print("Solar Panel generating 100 Watts")
			end
		},

		--Radiator[6]
		{
			--Take heat from the pipe network and put it into the air
			name = "Radiator",
			description = "Takes heat from the pipe network and outputs it into its surroundings",

			--when placed
			placeBuilding = function(tile)
				--Associate builing with tile
				tile.building = buildingBlueprints[6]

				--Connect to pipe network
				if not tile.onPipeNetwork then
					connectPipes(tile)
				end

				--Put building in the network
				table.insert(pipeNetworks.networkBuildings[tile.onPipeNetwork].radiators, {building = buildingBlueprints[6], x=tile.x, y=tile.y})

				--associate building ID with the pipe it is on
				local pipe = pipeNetworks.networks[tile.onPipeNetwork][tile.pipeID]
				pipe.onRadiator = #pipeNetworks.networkBuildings[tile.onPipeNetwork].radiators
			end
			,

			removeBuilding = function(tile)
				splitPipe(tile)
				tile.building = false
			end
			,

			--passive operation
			buildingFunction = function(tile)
				--Act as a radiator that outputs heat from the pipe network
				local heatTransferred = 0
				if pipeNetworks.networkHeat[tile.onPipeNetwork] > tile.temp then
					heatTransferred = ((tile.conductivity*(pipeNetworks.networkHeat[tile.onPipeNetwork]-tile.temp))/3600)
					tile.temp = tile.temp + (heatTransferred * 0.8)
					pipeNetworks.networkHeat[tile.onPipeNetwork] = pipeNetworks.networkHeat[tile.onPipeNetwork] - heatTransferred
					updateTileHeat(tile.x, tile.y)
				end
				print("Radiator Transferred "..heatTransferred.." Degrees...\nNew Network Heat: "..pipeNetworks.networkHeat[tile.onPipeNetwork])
			end
		}
	}
end

