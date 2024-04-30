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
				end
			end
			,

			removeBuilding = function(tile)
				splitElectric(tile)
				tile.building = false
			end
			,

			drawBuilding = function(tile)
				--draw wire that connects to surrounding wires
				love.graphics.rectangle("fill", tile.x*60+29.5, tile.y*60+29.5, 1, 1)
				--check four surrounding tiles for wires
				if grid.tiles[tile.x+1][tile.y].onElectricNetwork == tile.onElectricNetwork then
					love.graphics.line(tile.x*60+30, tile.y*60+30, tile.x*60+90, tile.y*60+30)
				end
				if grid.tiles[tile.x-1][tile.y].onElectricNetwork == tile.onElectricNetwork then
					love.graphics.line(tile.x*60+30, tile.y*60+30, tile.x*60-30, tile.y*60+30)
				end
				if grid.tiles[tile.x][tile.y+1].onElectricNetwork == tile.onElectricNetwork then
					love.graphics.line(tile.x*60+30, tile.y*60+30, tile.x*60+30, tile.y*60+90)
				end
				if grid.tiles[tile.x][tile.y-1].onElectricNetwork == tile.onElectricNetwork then
					love.graphics.line(tile.x*60+30, tile.y*60+30, tile.x*60+30, tile.y*60-30)
				end
			end
			,

			contextMenu = function(tile)
				local elements = {
					{
						type = "text",
						textColor = {1, 1, 1},
						text = "\nBuilding: Wire"
					},
					{
						type = "text",
						textColor = {1, 1, 1},
						text = "Wire ID: "..tile.wireID.."\nNetwork ID: "..tile.onElectricNetwork.."\n",
					}
				}
				return elements
			end
		},

		--Pipe[2]
		{ 
			name = "Pipe",
			description = "Connects buildings to the pipe network",
			placeBuilding = function(tile)
				if not tile.onPipeNetwork then
					connectPipes(tile)
				end
			end
			,

			removeBuilding = function(tile)
				splitPipe(tile)
				tile.building = false
			end
			,

			drawBuilding = function(tile)
				--draw pipe that connects to surrounding pipes
				love.graphics.setLineWidth(5)
				love.graphics.rectangle("fill", tile.x*60+27.5, tile.y*60+27.5, 5, 5)
				--check four surrounding tiles for pipes
				if grid.tiles[tile.x+1][tile.y].onPipeNetwork == tile.onPipeNetwork then
					love.graphics.line(tile.x*60+30, tile.y*60+30, tile.x*60+90, tile.y*60+30)
				end
				if grid.tiles[tile.x-1][tile.y].onPipeNetwork == tile.onPipeNetwork then
					love.graphics.line(tile.x*60+30, tile.y*60+30, tile.x*60-30, tile.y*60+30)
				end
				if grid.tiles[tile.x][tile.y+1].onPipeNetwork == tile.onPipeNetwork then
					love.graphics.line(tile.x*60+30, tile.y*60+30, tile.x*60+30, tile.y*60+90)
				end
				if grid.tiles[tile.x][tile.y-1].onPipeNetwork == tile.onPipeNetwork then
					love.graphics.line(tile.x*60+30, tile.y*60+30, tile.x*60+30, tile.y*60-30)
				end
				love.graphics.setLineWidth(1)
			end
			,

			contextMenu = function(tile)
				local elements = {
					{
						type = "text",
						textColor = {1, 1, 1},
						text = "\nBuilding: Pipe"
					},
					{
						type = "text",
						textColor = {1, 1, 1},
						text = "Pipe ID: "..tile.pipeID.."\nNetwork ID: "..tile.onPipeNetwork.."\n",
					}
				}
				return elements
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
			placeBuilding = function(tile, x, y)
				--Associate builing with tile
				local buildDat = {
					id = 3,
					x = x,
					y = y,
				}
				table.insert(tile.buildingss, buildDat)

				--Connect to electric network
				if not tile.onElectricNetwork then
					connectElectric(tile)
				end
				
				--Put building in the network
				table.insert(electricNetworks.networkBuildings[tile.onElectricNetwork].generators, {building = 3, x=tile.x, y=tile.y})
				table.insert(electricNetworks.networkBuildings[tile.onElectricNetwork].consumers, {building = 3, x=tile.x, y=tile.y})
				electricNetworks.networkCharge[tile.onElectricNetwork] = electricNetworks.networkCharge[tile.onElectricNetwork] + 50

				--associate building ID with the wire it is on
				local wire = electricNetworks.networks[tile.onElectricNetwork][tile.wireID]
				wire.onGenerator = #electricNetworks.networkBuildings[tile.onElectricNetwork].generators
				wire.onConsumer = #electricNetworks.networkBuildings[tile.onElectricNetwork].consumers

				--connect to pipe network
				if not tile.onPipeNetwork then
					connectPipes(tile)
				end

				--Put building in the network
				table.insert(pipeNetworks.networkBuildings[tile.onPipeNetwork].radiators, {building = 3, x=tile.x, y=tile.y})

				--associate building ID with the pipe it is on
				local pipe = pipeNetworks.networks[tile.onPipeNetwork][tile.pipeID]
				pipe.onRadiator = #pipeNetworks.networkBuildings[tile.onPipeNetwork].radiators

				tile.heating = true
				tile.update = true
				grid.updateTiles[tile.x][tile.y] = true
				tile.powerConsumption = 250
			end
			,

			removeBuilding = function(tile)
				splitElectric(tile)
				splitPipe(tile)
				tile.heating = false
				tile.building = false
				tile.powerConsumption = false
			end
			,

			drawBuilding = function(tile)
				--draw drop pod
				love.graphics.setColor(1,1,1)
				love.graphics.circle("fill", x+30, y+30, 20)
			end
			,

			contextMenu = function(tile)
				local elements = {
					{
						type = "text",
						textColor = {1, 1, 1},
						text = "\nBuilding: Drop Pod"
					},
					
					{
						type = "text",
						textColor = {1, 1, 1},
						text = "Power Generation: "..buildingBlueprints[3].powerGeneration.." Watts\nPower Consumption: "..buildingBlueprints[3].powerConsumption.." Watts\n",
					}
				}
				return elements
			end
			,
			
			--update function
			buildingFunction = function(tile)
				--Act as a radiator that outputs heat from the pipe network
				if electricNetworks.networkCharge[tile.onElectricNetwork] >= 0 then
					tile.heating = true
					tile.update = true
				else
					tile.heating = false
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
			placeBuilding = function(tile, x, y)
				--Associate builing with tile
				buildDat = {
					id = 4,
					x = x,
					y = y,
				}
				table.insert(tile.buildings, buildDat)

				--Connect to electric network
				if not tile.onElectricNetwork then
					connectElectric(tile)
				end
				
				--Put building in the network
				table.insert(electricNetworks.networkBuildings[tile.onElectricNetwork].consumers, {building = 4, x=tile.x, y=tile.y})
				electricNetworks.networkCharge[tile.onElectricNetwork] = electricNetworks.networkCharge[tile.onElectricNetwork] - 100

				--associate building ID with the wire it is on
				local wire = electricNetworks.networks[tile.onElectricNetwork][tile.wireID]
				wire.onConsumer = #electricNetworks.networkBuildings[tile.onElectricNetwork].consumers

				--connect to pipe network
				if not tile.onPipeNetwork then
					connectPipes(tile)
				end

				--Put building in the network
				table.insert(pipeNetworks.networkBuildings[tile.onPipeNetwork].collectors, {building = 4, x=tile.x, y=tile.y})

				--associate building ID with the pipe it is on
				local pipe = pipeNetworks.networks[tile.onPipeNetwork][tile.pipeID]
				pipe.onCollector = #pipeNetworks.networkBuildings[tile.onPipeNetwork].collectors

				tile.cooling = true
				tile.update = true
				grid.updateTiles[tile.x][tile.y] = true
				tile.powerConsumption = 100
			end
			,

			removeBuilding = function(tile)
				splitElectric(tile)
				splitPipe(tile)
				tile.building = false
				tile.cooling = false
				tile.powerConsumption = false
			end
			,

			drawBuilding = function(tile)
				--draw heat collector
				love.graphics.setColor(1,1,1)
				love.graphics.rectangle("fill", x+10, y+10, 40, 40)
				love.graphics.setColor(0,0,1)
				love.graphics.circle("fill", x+30, y+30, 15)
			end
			,

			contextMenu = function(tile)
				local elements = {
					{
						type = "text",
						textColor = {1, 1, 1},
						text = "\nBuilding: Heat Collector"
					},
					{
						type = "text",
						textColor = {1, 1, 1},
						text = "Power Consumption: "..buildingBlueprints[4].powerConsumption.." Watts\n",
					}
				}
				return elements
			end
			,

			--update function
			buildingFunction = function(tile)
				--Collects heat from the tile and puts it into the pipe network
				if electricNetworks.networkCharge[tile.onElectricNetwork] >= 0 then
					tile.cooling = true
					tile.update = true
					
				else
					tile.cooling = false
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
			placeBuilding = function(tile, x, y)
				--Associate builing with tile
				buildDat = {
					id = 5,
					x = x,
					y = y,
				}
				table.insert(tile.buildings, buildDat)

				--Connect to electric network
				if not tile.onElectricNetwork then
					connectElectric(tile)
				end
				
				--Put building in the network
				table.insert(electricNetworks.networkBuildings[tile.onElectricNetwork].generators, {building = 5, x=tile.x, y=tile.y})
				electricNetworks.networkCharge[tile.onElectricNetwork] = electricNetworks.networkCharge[tile.onElectricNetwork] + 100

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

			drawBuilding = function(tile)
				--draw solar panel
				love.graphics.setColor(0.2,0.2,0.2)
				love.graphics.rectangle("fill", x+10, y+10, 40, 40)
				love.graphics.setColor(0.7,0.7,0.7)
				love.graphics.line(x+20, y+10, x+20, y+50)
				love.graphics.line(x+40, y+10, x+40, y+50)
			end
			,

			contextMenu = function(tile)
				local elements = {
					{
						type = "text",
						textColor = {1, 1, 1},
						text = "\nBuilding: Solar Panel"
					},
					{
						type = "text",
						textColor = {1, 1, 1},
						text = "Power Generation: "..buildingBlueprints[5].powerGeneration.." Watts\n",
					}
				}
				return elements
			end
			,

			--update function
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
			placeBuilding = function(tile, x, y)
				--Associate builing with tile
				buildDat = {
					id = 6,
					x = x,
					y = y,
				}
				table.insert(tile.buildings, buildDat)

				--Connect to pipe network
				if not tile.onPipeNetwork then
					connectPipes(tile)
				end

				--Put building in the network
				table.insert(pipeNetworks.networkBuildings[tile.onPipeNetwork].radiators, {building = 6, x=tile.x, y=tile.y})

				--associate building ID with the pipe it is on
				local pipe = pipeNetworks.networks[tile.onPipeNetwork][tile.pipeID]
				pipe.onRadiator = #pipeNetworks.networkBuildings[tile.onPipeNetwork].radiators

				tile.heating = true
				tile.update = true
				grid.updateTiles[tile.x][tile.y] = true
			end
			,

			removeBuilding = function(tile)
				splitPipe(tile)
				tile.heating = false
				tile.building = false
			end
			,

			drawBuilding = function(tile)
				--draw radiator
				love.graphics.setColor(1,1,1)
				love.graphics.rectangle("fill", x+10, y+10, 40, 40)
				love.graphics.setColor(1,0.3,0)
				love.graphics.line(x+10, y+10, x+50, y+50)
				love.graphics.line(x+50, y+10, x+10, y+50)
			end
			,

			contextMenu = function(tile)
				local elements = {
					{
						type = "text",
						textColor = {1, 1, 1},
						text = "\nBuilding: Radiator"
					}
				}
				return elements
			end
			,

			--update function
			buildingFunction = function(tile)
				--Act as a radiator that outputs heat from the pipe network
				tile.heating = true
			end
		},

		--Item Storage[7]
		{
			--Stores items and allows for drones to manage the items if powered
			name = "Item Storage",
			description = "Stores items",

			--when placed
			placeBuilding = function(tile, x, y)
				--Associate builing with tile
				buildDat = {
					id = 7,
					x = x,
					y = y,
				}
				table.insert(tile.buildings, buildDat)

				--Connect to electric network
				

				--Register Inventory
				local inventory = {
					capacity  = 20,
					itemAmount = 0,
					items = {},
					x = tile.x,
					y = tile.y,
				}
				table.insert(inventories, inventory)
				tile.inventoryID = #inventories
				print("Item Storage placed, Inventory ID: "..tile.inventoryID)
				
			end
			,

			removeBuilding = function(tile)
				tile.building = false

				--split electric network
				splitElectric(tile)

				--Drop all items on the ground
				table.insert(groundInventories, inventories[tile.inventoryID])
				table.remove(inventories, tile.inventoryID)
			end
			,

			drawBuilding = function(tile)
				--draw item storage
				love.graphics.setColor(1,1,1)
				love.graphics.rectangle("fill", x+10, y+10, 40, 40)
				love.graphics.setColor(0,1,0)
				love.graphics.rectangle("line", x+10, y+10, 40, 40)
			end
			,

			contextMenu = function(tile)
				local elements = {
					{
						type = "btn",
						text = "Add 5 Uranium",
						btnColor = {0, 1, 0},
						textColor = {0, 0, 0},
						func = function()
							addItemToInventory("uranium", 5, inventories[tile.inventoryID])
						end,
						funcArgs = {}
					},
					{
						type = "text",
						textColor = {1, 1, 1},
						text = "\nBuilding: Item Storage"
					},
					{
						type = "inventory",
						inventory = inventories[tile.inventoryID],
					}
				}
				return elements
			end
			,

			--update function
			buildingFunction = function(tile)
				--Act as a storage
			end
		},

		--Drone Hub[8]
		{
			--Contains three drone slots which allows them to charge or be idle. A drone must be assigned to a slot to be active
			name = "Drone Hub",
			description = "Acts as a control and charging center for up to three drones",
			--Power Consumption will depend on the number of drones charging
			powerConsumption = 0,
			placeBuilding = function(tile, x, y)
				--Associate builing with tile
				buildDat = {
					id = 8,
					x = x,
					y = y,
				}
				table.insert(tile.buildings, buildDat)

				--associate tile with drone hub
				tile.droneHubInfo = {
					hasHub = true,
					slots = {},
					droneCapacity = 3,
				}

				--Connect to electric network
				if not tile.onElectricNetwork then
					connectElectric(tile)
				end
			end
			,

			removeBuilding = function(tile)
				tile.building = false

				--split electric network
				splitElectric(tile)
			end
			,

			drawBuilding = function(tile)
				--draw drone hub
				love.graphics.setColor(1,1,1)
				love.graphics.rectangle("fill", x+10, y+10, 40, 40)
				love.graphics.setColor(0.3,0.3,0.3)
				love.graphics.rectangle("fill", x+11, y+11, 10, 38)
				love.graphics.rectangle("fill", x+25, y+11, 10, 38)
				love.graphics.rectangle("fill", x+39, y+11, 10, 38)

				if hubLinkOpen then
					love.graphics.setColor(0,1,0,0.5)
					love.graphics.circle("fill", x+30, y+30, 30)
				end
			end
			,

			contextMenu = function(tile)
				local elements = {
					{
						type = "text",
						textColor = {1, 1, 1},
						text = "\nBuilding: Drone Hub"
					}
				}
				return elements
			end
			,

			--update function
			buildingFunction = function(tile)
				--Act as a drone hub
			end
		},
		
		--Drone[9]
		{
			--Drone that can be programmed to perform tasks
			name = "Drone",
			description = "A drone that can be programmed to perform tasks",
			placeBuilding = function(tile, x, y)
				--Create new drone on the tile
				createDrone(x, y)
			end,
		},

		--Heat Packager[10]
		{
			name = "Heat Packager",
			description = "Packages heat into neat little cells for easier transport. (Note: Neat little cells are not included)",
			powerConsumption = 200,

			placeBuilding = function(tile, x, y)
				buildDat = {
					id = 10,
					x = x,
					y = y,
				}
				table.insert(tile.buildings, buildDat)

				if not tile.onElectricNetwork then
					connectElectric(tile)
				end
			end,

			removeBuilding = function(tile)
				tile.building = false

				splitElectric(tile)
			end,

			drawBuilding = function(tile)
				love.graphics.setColor(1,1,1)
				love.graphics.rectangle("fill", x+10, y+10, 40, 40)
			end,

			contextMenu = function(tile)
				local elements = {
					{
						type = "text",
						textColor = {1, 1, 1},
						text = "\nBuilding: Heat Packager"
					}
				}
				return elements
			end,

			buildingFunction = function(tile)
				--do thing
			end,
		},
	}
end