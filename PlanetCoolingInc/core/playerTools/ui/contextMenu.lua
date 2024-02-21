--Handles the creation of and interactions with context menus

function initContextMenu()
  contextMenus = {}
  --[[Context Menu Example:
    {
      ID = 1,
      x = 0,
      y = 0,
      rootX = 75,
      rootY = 72,
      elements = {
        {
          type = "btn",
          text = "Move Player Here",
          func = movePlayerTo,
          funcArgs = {x = 0, y = 0},
        },
        {
          type = "text",
          text = "Tile: (0,0)\nTemperature: 25\n",
        },
        {
          type = "inventory",
          inventory = inventories[7],
        }
      }
    }
  ]]
  --The elements of the context menu are drawn in the order they are in the table
end

function createContextMenu(x, y)
  --Check if click is on something other than tile (like the player or a drone)
  --Checking for player
  if math.checkIfPointInCircle(x - camX, y - camY, player.x, player.y, 15) and not player.hasContextMenu then
    local contextMenu = {
      ID = #contextMenus + 1,
      x = x,
      y = y,
      rootX = x,
      rootY = y,
      elements = {
        {
          type = "text",
          text = "Player Coords: ("..player.x..","..player.y..")\n",
        },
        {
          type = "text",
          text = "Health: "..player.health.."\n",
        },
        {
          type = "inventory",
          inventory = inventories.player,
        }
      }
    }
    table.insert(contextMenus, contextMenu)
    player.hasContextMenu = true
  --[[
    elseif for ID, drone in pairs(drones) do if math.checkIfPointInCircle(x, y, drone.x, drone.y, 15) and not drone.hasContextMenu then return true end end then
    local contextMenu = {
      ID = #contextMenus + 1,
      x = x,
      y = y,
      rootX = x,
      rootY = y,
      elements = {
        {
          type = "text",
          text = "Drone Coords: ("..drone.x..","..drone.y..")\n",
        },
        {
          type = "inventory",
          inventory = drone.inventory,
        }
      }
    }
    table.insert(contextMenus, contextMenu)
    drone.hasContextMenu = true
  ]]
  elseif not grid.tiles[math.floor((x - camX)/60)][math.floor((y - camY)/60)].hasContextMenu then
    --Create context menu for tile
    local tile = grid.tiles[math.floor((x - camX)/60)][math.floor((y - camY)/60)]
    local contextMenu = {
      ID = #contextMenus + 1,
      x = x,
      y = y,
      rootX = x,
      rootY = y,
      elements = {
        {
          type = "btn",
          text = "Move Player Here",
          func = movePlayerTo,
          funcArgs = {x = tile.x, y = tile.y},
        },
        {
          type = "text",
          text = "Tile: ("..tile.x..","..tile.y..")\nTemperature: "..math.round(tile.temp, 2).."\n",
        }
      }
    }

    if tile.building then
      local buildingContext = {
        {
          type = "text",
          text = "Building: "..tile.building.name.."\n",
        },
      }

      table.insert(contextMenu.elements, 2, buildingContext)
    end
    table.insert(contextMenus, contextMenu)
    tile.hasContextMenu = true
  end
end

--[[function updateContextMenu(x, y)
  --Open context menu on tile
  local tile = nil
  if contextMenu.isOpen then
    tile = grid.tiles[math.floor((contextMenu.x)/60)][math.floor((contextMenu.y)/60)]
    x = contextMenu.x + camX
    y = contextMenu.y + camY
  else
    tile = grid.tiles[math.floor((x - camX)/60)][math.floor((y - camY)/60)]
  end

  local text = "Tile: ("..tile.x..","..tile.y..")\nTemperature: "..math.round(tile.temp, 2).."\n"
  if tile.onElectricNetwork then
    text = text.."On Electric Network "..tile.onElectricNetwork.."\n"..electricNetworks.networkCharge[tile.onElectricNetwork].." Watts\n"
  end
  if tile.onPipeNetwork then
    text = text.."On Pipe Network "..tile.onPipeNetwork.."\n"..pipeNetworks.networkHeat[tile.onPipeNetwork].." Celsius\n"
  end
  if tile.building then
    text = text.."Building: "..tile.building.name.."\n"
  end
  contextMenu = {
    isOpen = true,
    x = x - camX,
    y = y - camY,
    text = text,
    dragging = contextMenu.dragging
  }
end]]

--[[
function clickContextMenu(x, y)
  --Check if context menu is open
  if contextMenu.isOpen then
    --Check what the player clicked
    --Clicked top bar
    
    if math.checkIfPointInRect(x, y, (contextMenu.x/scale) - focusPointX + (centerWidth/scale), (contextMenu.x/scale) - focusPointX + (centerWidth/scale) + 200, (contextMenu.y/scale) - focusPointY + (centerHeight/scale) - 300, (contextMenu.y/scale) - focusPointY + (centerHeight/scale) - 290) then
      --Drag the context menu
      contextMenu.dragging = true
    end

    --Clicked Close Button


    --Clicked Move Player Button


  end
end
]]

  