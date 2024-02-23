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
      type = "player",
      ID = #contextMenus + 1,
      x = x*scale,
      y = y*scale,
      rootX = player.x,
      rootY = player.y,
      elements = {
        {
          type = "text",
          text = "Player Coords: ("..math.ceil(player.x)..","..math.ceil(player.y)..")\n",
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
    player.contextMenuID = #contextMenus
  --[[
    elseif for ID, drone in pairs(drones) do if math.checkIfPointInCircle(x, y, drone.x, drone.y, 15) and not drone.hasContextMenu then return true end end then
    local contextMenu = {
      type = "drone",
      ID = #contextMenus + 1,
      x = x,
      y = y,
      rootX = drone.x,
      rootY = drone.y,
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
    drone.contextMenuID = #contextMenus
  ]]
  elseif not grid.tiles[math.floor((x - camX)/60)][math.floor((y - camY)/60)].hasContextMenu then
    --Create context menu for tile
    local tile = grid.tiles[math.floor((x - camX)/60)][math.floor((y - camY)/60)]
    local contextMenu = {
      type = "tile",
      tile = tile,
      ID = #contextMenus + 1,
      x = x*scale,
      y = y*scale,
      rootX = tile.x*60 + 30,
      rootY = tile.y*60 + 30,
      elements = {
        {
          type = "btn",
          text = "Move Player Here",
          func = movePlayerTo, --movePlayerTo(x, y)
          funcArgs = {tile.x*60+30, tile.y*60+30},
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
    tile.contextMenuID = #contextMenus
  end
end

function updateContextMenu(menuID)
  if contextMenus[menuID] then
    --Update displayed values of context menu
    local menu = contextMenus[menuID]
    if menu.type == "player" then
      menu.rootX = player.x
      menu.rootY = player.y
      menu.elements[1].text = "Player Coords: ("..math.ceil(player.x)..","..math.ceil(player.y)..")\n"
      menu.elements[2].text = "Health: "..player.health.."\n"
    elseif menu.type == "drone" then
      menu.elements[1].text = "Drone Coords: ("..drone.x..","..drone.y..")\n"
    elseif menu.type == "tile" then
      menu.elements[2].text = "Tile: ("..menu.tile.x..","..menu.tile.y..")\nTemperature: "..math.round(menu.tile.temp, 2).."\n"
    end
  end
end

function clickContextMenu(x, y)
  --Iterate through context menus backwards to check if clicked on
  for menuID = #contextMenus, 1, -1 do
    local menu = contextMenus[menuID]
    if x > menu.x and x < menu.x + 200 and y > menu.y and y < menu.y + 200 then

      --Check if clicked on close button
      if x > menu.x + 190 and x < menu.x + 200 and y > menu.y and y < menu.y + 10 then
        --Close the context menu
        if menu.type == "player" then
          player.hasContextMenu = false
        elseif menu.type == "drone" then
          --drone.hasContextMenu = false
        elseif menu.type == "tile" then
          menu.tile.hasContextMenu = false
        end
        table.remove(contextMenus, menuID)
        return
      elseif x > menu.x and x < menu.x + 200 and y > menu.y and y < menu.y + 10 then
        --Drag the context menu
        draggedMenu = menu
        return
      else
        --Check if clicked on a button
        for i, element in ipairs(menu.elements) do
          if element.type == "btn" and x > menu.x + 10 and x < menu.x + 190 and y > menu.y + 20 + ((i - 1) * 40) and y < menu.y + 40 + ((i - 1) * 40) then
            --Run the function
            element.func(unpack(element.funcArgs))
            return
          end
        end
      end
    end
  end 
end


  