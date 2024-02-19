function genNewWorld(size, seed)
	initBuildings()
	initInventories()
	initContextMenu()
	--set up world variables and tables
	gameTime = 0
	updateTime = 0
	randomUpdateTime = 0

	buildings = {}
	pipeNetworks = {
		networks = {},
		networkBuildings = {
		--[[
		networkBuildings[x] = {
			radiators = {},
			collectors = {}
		}
		]]
		},
		networkHeat = {}
	}
	electricNetworks = {
		networks = {},
		--[[
		networkBuildings[x] = {
			generators = {},
			consumers = {},
			storage = {}
		}
		]]
		networkBuildings = {},
		networkCharge = {}
	}

	--grid works by using x and y coords, each x coord is a table that has all available y values nested inside
	grid = {
		updateTiles = {},
		tiles = {}
	}
	gridSize = size

	--set seed
	if seed then
		math.randomseed(seed)
	else
		math.randomseed(os.time() / math.random(1, 982))
	end

	--create grid
	for x = -size/2, size/2 do
		grid.tiles[x] = {}
		grid.updateTiles[x] = {}
		for y = -size/2, size/2 do
			grid.tiles[x][y] = {
				x = x,
				y = y,
				temp = math.random(200, 300),
				hotspot = false,
				updatedTime = 0,
				conductivity = 50,
				update = false,
				cooling = false,
				building = false,
				onElectricNetwork = false,
				wireID = false,
				onPipeNetwork = false,
				pipeID = false,
				inventoryID = false,
			}
		end
	end

	--Determine Hotspot locations
	for h = 1, 13 do
		local x, y = math.random(0, size) - size/2, math.random(0, size) - size/2
		grid.tiles[x][y].hotspot = true
		grid.tiles[x][y].temp = grid.tiles[x][y].temp + 700 
		grid.tiles[x][y].conductivity = 100
	end

	--Presimulate heat spread
	local cycles = 25
	for c = 1, cycles do
		print("Simulation Cycle: "..c)
		gameTime = gameTime + 1
		fullGridUpdate()
	end

	--Presimulate relative heat spread
	cycles = 100
	for c = 1, cycles do
		print("Relative Simulation Cycle: "..c)
		gameTime = gameTime + 1
		updateImportantTiles()
	end


	print(#grid.updateTiles)

	gamestate = 1
end

function loadWorld()

end
