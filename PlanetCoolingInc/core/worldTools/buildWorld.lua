function genNewWorld(size, seed)
	initBuildings()
	initItems()
	initInventories()
	initContextMenu()
	initDrones()
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
		seed = os.time() / math.random(1, 982)
		math.randomseed(seed)
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
				hasContextMenu = false,
				droneHubInfo = {
					hasHub = false,
					slots = {
						--[[
						[1] = {
							linkedDrone = nil,
							linkedDroneID = nil,
						}
						]]
					},
					droneCapacity = nil,
				},
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

	gamestate = 1

	logMessage("World Generated - Seed: "..seed)
	logMessage("GameState Set to 1")
end

function loadWorld(fileName)
	--Open file
	local fileData
	if love.filesystem.getInfo("saves/"..fileName..".sav") then
		fileData = love.filesystem.read("saves/"..fileName..".sav")
	else
		print("File not found")
		return
	end
	--Load tiles individually
	grid.tiles = {}
	local s, e = string.find(fileData, "&grid.tiles")
	



end

function saveWorld(fileName)
	--Things to save:
	--grid.tiles
	--Inventories
	--Ground Inventory
	--Drones
	--Player

	local saveData
	--Save grid.tiles
	saveData = "&grid.tiles = {\n"..table.toString(grid.tiles, 1).."}\n"
	--Save Inventories
	saveData = saveData.."&inventories = {\n"..table.toString(inventories, 1).."}\n"
	--Save Ground Inventory
	saveData = saveData.."&groundInventories = {\n"..table.toString(groundInventories, 1).."}\n"
	--Save Drones
	saveData = saveData.."&drones = {\n"..table.toString(drones, 1).."}\n"
	--Save Player
	saveData = saveData.."&player = {\n"..table.toString(player, 1).."}\n" 

	



	--Open file if none specified
	local file
	if not fileName then
		if not love.filesystem.getInfo("saves") then
			love.filesystem.createDirectory("saves")
		end
		file = love.filesystem.newFile("saves/save"..os.date("%m-%d-%Y_%H-%M-%S")..".sav")
		local s, e = file:open("w")
		print(s, e)
	else
		file = io.open("saves/"..fileName..".sav", "w")
	end
	--Write to file
	file:write(saveData)
	print("World Saved")
	--Close the file
	file:close()
end