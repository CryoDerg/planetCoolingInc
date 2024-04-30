--[[
	Procedural World Generation
	- Generates a new world with a specified size and seed (the size will increase as the player progresses)
	- The world is generated with a grid of tiles that have different noise values (which will be represented as temperature and tile height)


	Tile Heat Properties
	- Each tile has a temperature value that will be used to determine the heat of the tile
	- The temp will spread to adjacent tiles based on the conductivity of the tile
	- Each tile has a certain material that will determine the conductivity and melting point of the tile
	- If melting point is reached, the tile will turn into a lava tile
	- Lava can be cooled in different ways to form different types of tiles

]]
function genNewWorld(size, seed, tempSize, heightSize)
	--Set size to nearest value divisible by 8
	size = math.floor(size / 8) * 8

	--Set up world
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

	gridSeed = seed

	--Set random noise bases
	local baseXHeat = math.random(1, 1000) * 92
	local baseYHeat = math.random(1, 1000) * 38
	local baseXHeight = math.random(1, 1000) * 12
	local baseYHeight = math.random(1, 1000) * 74

	--create grid
	for x = (-size)/2, (size)/2 - 1 do
		grid.tiles[x] = {}
		grid.updateTiles[x] = {}
		for y = (-size)/2, (size)/2 - 1 do
			--create tile
			grid.tiles[x][y] = {
				x = x,
				y = y,
				z = 50,

				temp = 0,
				material = "rock",
				meltingPoint = 1000,
				biome = "badlands", --"badlands", "volcanic", "driedLake", "driedRiver"
				
				updatedTime = 0,
				update = false,
				conductivity = 50,
				
				cooling = false,
				heating = false,

				buildings = {},
				
				onElectricNetwork = false,
				wireID = false,
				powerConsumption = false,

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
	
	--Map temp and height
	heatMapSize = tempSize or 90
	heightMapSize = heightSize or 64
	riverMapSize = 100
	for x = (-size)/2, (size)/2 - 1 do
		for y = (-size)/2, (size)/2 - 1 do
			local tile = grid.tiles[x][y]
			local temp = 400 + love.math.noise(x/heatMapSize + baseXHeat, y/heatMapSize + baseYHeat) * 120
			local height = love.math.noise(x/heightMapSize + baseXHeight, y/heightMapSize + baseYHeight) * 150
			local river = love.math.noise(x/riverMapSize + (baseXHeight+19), y/riverMapSize + (baseYHeight+73)) * 100
			if river > 25 and river < 38 then
				tile.z = river
			else
				tile.z = height
			end
			tile.temp = temp
			
		end
	end

	--Set biomes
	local volcanoCount = 0
	for x = (-size)/2, (size)/2 - 1 do
		for y = (-size)/2, (size)/2 - 1 do
			local tile = grid.tiles[x][y]
			local temp = tile.temp
			local height = tile.z

			--Biomes: badlands, volcanic, driedLake, driedRiver, lavaLake, lavaRiver
			if temp > 500 and height > 50 then
				tile.biome = "volcanic"
				tile.temp = tile.temp + 500
				--Determine if a feature is generated on the tile (volcano) - 1/500 chance
				if math.random(1, 500) == 1 then
					tile.feature = "volcano"
				end
				volcanoCount = volcanoCount + 1
			elseif temp > 500 and height <= 40 then
				tile.biome = "lavaLake"
				tile.temp = tile.temp + 350
			elseif temp < 500 and height <= 40 then
				tile.temp = tile.temp - 75
				tile.biome = "driedLake"
			else
				tile.biome = "badlands"
			end
			
		end
	end
	if volcanoCount == 0 then
		print("No Volcanoes Generated")
	end

	--Presimulate heat spread
	local cycles = 1
	for c = 1, cycles do
		--print("Simulation Cycle: "..c)
		gameTime = gameTime + 1
		fullGridUpdate()
	end

	--Presimulate relative heat spread
	cycles = 100
	for c = 1, cycles do
		--print("Relative Simulation Cycle: "..c)
		gameTime = gameTime + 1
		countUpdatedTiles()
		for t = 1, 100 do
			updateTiles(0.01)
		end
	end

	gamestate = "game"

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
		local y = tonumber(string.sub(tileData, string.find(tileData, "]" ) + 2, string.find(tileData, "]", string.find(tileData, "]") + 1) - 1))
		
		if not grid.tiles[x] then
			grid.updateTiles[x] = {}
			loadstring("grid.tiles"..string.sub(tileData, 1, string.find(tileData, "]")).." = {}")()
		end
		loadstring("grid.tiles"..tileData)()
		numOfTiles = numOfTiles + 1
		local tile = grid.tiles[x][y]
		tile.hasContextMenu = false
		if tile.update then
			grid.updateTiles[x][y] = true
		end
		if s2 >= tileEnd then
			iter = false
		end
	end

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

	--Init other important things
	initBuildings()
	initItems()
	initContextMenu()
	updateElectric()
	updatePipes()

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
			saveData = saveData.."#["..x.."]["..y.."] = "..table.toString(tile).."}"
		end
	end
	saveData = saveData.."&tilesEnd\n"
	--Save gridSize
	saveData = saveData.."&gridSize = "..gridSize.."\n"
	--Save Inventories
	saveData = saveData.."&inventories = "..table.toString(inventories).."}\n"
	--Save Ground Inventory
	saveData = saveData.."&groundInventories = "..table.toString(groundInventories).."}\n"
	--Save Drones
	saveData = saveData.."&drones = "..table.toString(drones).."}\n"
	--Save Player
	saveData = saveData.."&player = "..table.toString(player).."}\n"
	--Save Pipe Networks
	saveData = saveData.."&pipeNetworks = "..table.toString(pipeNetworks).."}\n"
	--Save Electric Networks
	saveData = saveData.."&electricNetworks = "..table.toString(electricNetworks).."}&" 

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

function createTile(x, y)
	if not grid.tiles[x] then
		grid.tiles[x] = {}
		grid.updateTiles[x] = {}
	end
	if not grid.tiles[x][y] then
		grid.tiles[x][y] = {
			x = x,
			y = y,
			temp = math.random(200, 300),
			biome = "badlands",
			hotspot = false,
			updatedTime = 0,
			conductivity = 50,
			update = false,
			cooling = false,
			heating = false,
			building = false,
			onElectricNetwork = false,
			wireID = false,
			powerConsumption = false,
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
	return grid.tiles[x][y]
 end

 function checkTile(x, y)
	if grid.tiles[x] then
		if grid.tiles[x][y] then
			return grid.tiles[x][y]
		end
	end
	return false
 end