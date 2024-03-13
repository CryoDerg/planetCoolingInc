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
	grid = {}
	grid.tiles = {}
	grid.updateTiles = {}
	local s, e = string.find(fileData, "&grid.tiles = {")
	--find tiles (each tile is preceded by a #)
	--local tileData = string.sub(fileData, e + 2, string.find(fileData, "#", e + 2) - 1)
	tileEnd = string.find(fileData, "&tilesEnd")
	local iter = true
	local numOfTiles = 0
	while iter do
		s, e = string.find(fileData, "#", e + 1)
		--print(s, e)
		local s2 = string.find(fileData, "#", e + 1) or tileEnd
		
		
		local tileData = string.sub(fileData, e + 1, s2 - 1)
		--load tile
		local x  = tonumber(string.sub(tileData, 2, string.find(tileData, "]") - 1))
		local y = string.sub(tileData, string.find(tileData, "]" ) + 2, string.find(tileData, "]", string.find(tileData, "]") + 1) - 1)
		if x == -2 then
			print("Tile "..x..", "..y.." found")
		end
		if not grid.tiles[x] then
			grid.updateTiles[x] = {}
			loadstring("grid.tiles"..string.sub(tileData, 1, string.find(tileData, "]")).." = {}")()
		end
		loadstring("grid.tiles"..tileData)()
		numOfTiles = numOfTiles + 1
		if s2 >= tileEnd then
			iter = false
		end
	end
	
	print(numOfTiles)
	
	--[[
		#[x][y] = {

		}
		#[x][y] = {

		}
	]]
		
	
		


	--Load gridSize
	s, e = string.find(fileData, "&gridSize = ")
	gridSize = tonumber(string.sub(fileData, e + 1, string.find(fileData, "\n", e + 1) - 1))
	--Load inventories
	s, e = string.find(fileData, "&inventories")
	loadstring(string.sub(fileData, s + 1, string.find(fileData, "&", e) - 1))()
	--Load groundInventories
	s, e = string.find(fileData, "&groundInventories")
	loadstring(string.sub(fileData, s + 1, string.find(fileData, "&", e) - 1))()
	--Load drones
	s, e = string.find(fileData, "&drones")
	loadstring(string.sub(fileData, s + 1, string.find(fileData, "&", e) - 1))()
	--Load player
	s, e = string.find(fileData, "&player")
	loadstring(string.sub(fileData, s + 1, string.find(fileData, "&", e) - 1))()
	--Load pipeNetworks
	s, e = string.find(fileData, "&pipeNetworks")
	loadstring(string.sub(fileData, s + 1, string.find(fileData, "&", e) - 1))()
	--Load electricNetworks
	s, e = string.find(fileData, "&electricNetworks")
	loadstring(string.sub(fileData, s + 1, string.find(fileData, "&", e) - 1))()

	--find important tiles
	fullGridUpdate()

	--Init other important things
	initBuildings()
	initItems()
	initContextMenu()
	--Set gamestate
	gamestate = 1
	
	



end

function saveWorld(fileName)
	--Things to save:
	--grid.tiles
	--gridSize
	--Inventories
	--Ground Inventory
	--Drones
	--Player
	--Pipe Networks
	--Electric Networks

	local saveData
	--Save grid.tiles
	saveData = "&grid.tiles = {"
	for x, yTable in pairs(grid.tiles) do
		for y, tile in pairs(yTable) do
			saveData = saveData.."#["..x.."]["..y.."] = "..table.toString(tile, 1).."}"
		end
	end
	saveData = saveData.."&tilesEnd\n"
	--Save gridSize
	saveData = saveData.."&gridSize = "..gridSize.."\n"
	--Save Inventories
	saveData = saveData.."&inventories = "..table.toString(inventories, 1).."}\n"
	--Save Ground Inventory
	saveData = saveData.."&groundInventories = "..table.toString(groundInventories, 1).."}\n"
	--Save Drones
	saveData = saveData.."&drones = "..table.toString(drones, 1).."}\n"
	--Save Player
	saveData = saveData.."&player = "..table.toString(player, 1).."}\n"
	--Save Pipe Networks
	saveData = saveData.."&pipeNetworks = "..table.toString(pipeNetworks, 1).."}\n"
	--Save Electric Networks
	saveData = saveData.."&electricNetworks = "..table.toString(electricNetworks, 1).."}&" 

	



	--Open file if none specified
	local file
	if not fileName then
		if not love.filesystem.getInfo("saves") then
			love.filesystem.createDirectory("saves")
		end
		fileName = "save"..os.date("%m-%d-%Y_%H-%M-%S")
		local fileDat = love.filesystem.newFile("saves/"..fileName..".sav")
	end
	file = love.filesystem.read("saves/"..fileName..".sav")
	
	--Write to file
	love.filesystem.write("saves/"..fileName..".sav", saveData)
	--file:write(saveData)
	print("World Saved")
	

	--edit savDat file
	local data
	if love.filesystem.getInfo("saves/savDat.dat") then
		data = love.filesystem.read("saves/savDat.dat")
	else
		local datFile = love.filesystem.newFile("saves/savDat.dat")
		data = datFile:read()
	end
	love.filesystem.write("saves/savDat.dat", "LastSave = \""..os.date("%m-%d-%Y_%H-%M-%S").."\" - \nFilename = \""..fileName.."\"")
end