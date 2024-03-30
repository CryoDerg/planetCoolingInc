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
	for x = (-size-10)/2, (size+10)/2 do
		grid.tiles[x] = {}
		grid.updateTiles[x] = {}
		for y = (-size-10)/2, (size+10)/2 do
			grid.tiles[x][y] = {
				x = x,
				y = y,
				temp = math.random(200, 300),
				biome = "badlands", --"badlands", "volcanic", "driedLake", "driedRiver"
				hotspot = false,
				volcano = false,
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
	end

	love.graphics.clear()
	love.draw()
	love.graphics.present()

	--Feature Generation (Hotspots, Rocks, Volcanoes, Dried Lakes, Dried Rivers)
	--Determine Hotspot locations
	for h = 1, 13 do
		local x, y = math.random(0, size) - size/2, math.random(0, size) - size/2
		grid.tiles[x][y].hotspot = true
		grid.tiles[x][y].temp = grid.tiles[x][y].temp + 700 
		grid.tiles[x][y].conductivity = 100
	end

	--Determine Rock locations
	local rockMaterials = {
		"granite",
		"iron",
		"marble",
	}
	local numOfRocks = math.random(40, 60)
	for r = 1, numOfRocks do
		local rock = {
			material = rockMaterials[math.random(1, #rockMaterials)],
			materialAmount = math.random(40, 100),
		}
		local x, y = math.random(0, size) - size/2, math.random(0, size) - size/2
		grid.tiles[x][y].rock = rock
		grid.tiles[x][y].conductivity = 10
	end

	--Determine Volcano locations
	local numOfVolcanoes = math.random(1,2)
	--gen volcano biome
	for v = 1, numOfVolcanoes do
		--determine center of biome
		local x, y = math.random(10, size - 10) - size/2, math.random(10, size - 10) - size/2
		local biomeSize = math.random(5, 10)
		grid.tiles[x][y].volcano = true
		--"grow" biome from center
		--[[
			Growth Behavior for Volcanic Biome:
			- Biome starts at center
			- Grows out two short branches 
			- Branches are 2-3 tiles thick
			- Branches are 5-10 tiles long
		]]
		--dertermine branch directions
		for branchNum = 1, 2 do
			local branchDir = math.random(1, 4)
			local branchLength = math.random(5, 10)
			local branchThickness = math.random(2, 3)
			local branchPosVariance = 0
			local bX, bY = x, y
			for b = 1, branchLength do
				if branchDir == 1 then
					--up
					bX, bY = bX + branchPosVariance, bY - 1
				elseif branchDir == 2 then
					--down
					bX, bY = bX + branchPosVariance, bY + 1
				elseif branchDir == 3 then
					--left
					bX, bY = bX - 1, bY + branchPosVariance
				elseif branchDir == 4 then
					--right
					bX, bY = bX + 1, bY + branchPosVariance
				end

				--Change tile to volcanic biome
				local bTile = createTile(bX, bY)
				bTile.biome = "volcanic"
				bTile.temp = bTile.temp + 500
				bTile.conductivity = 100

				--Apply branch thickness
				local thickBranch = {bTile}
				local function applyBranchThickness(thickness)
					print("Applying Branch Thickness: "..thickness.." / "..branchThickness)
					print(#thickBranch)
					--add four tiles around the tile
					local tTile = thickBranch[1]
					local tX, tY = tTile.x, tTile.y
					local tTiles = {
						createTile(tX + 1, tY),
						createTile(tX - 1, tY),
						createTile(tX, tY + 1),
						createTile(tX, tY - 1),
					}
					table.remove(thickBranch, 1)
					for k, t in pairs(tTiles) do
						if t.biome == "badlands" and t.biome ~= "volcanic" then
							t.biome = "volcanic"
							t.temp = t.temp + 500
							t.conductivity = 100
							if thickness > 0 then
								table.insert(thickBranch, t)
								applyBranchThickness(thickness - 1)
							end
						end
					end
				end
				applyBranchThickness(branchThickness)
					

				--Add variance to branch position
				--branchPosVariance = math.random(-1, 1)

			end
		end
	end

	love.graphics.clear()
	love.draw()
	love.graphics.present()

	--Presimulate heat spread
	local cycles = 25
	for c = 1, cycles do
		--print("Simulation Cycle: "..c)
		gameTime = gameTime + 1
		fullGridUpdate()
	end

	--Presimulate relative heat spread
	cycles = 40
	for c = 1, cycles do
		--print("Relative Simulation Cycle: "..c)
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