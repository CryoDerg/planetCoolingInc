--Handle the context menu that appears when the player right clicks on a tile\
--The context menu will include info about the tile like temperature, wire connections, pipe connections, etc. as well as some options
--[[
  Context Menu:
    -Temperature
    -Wire Connections
    -Pipe Connections
    -Building
    -Options
      -Move player to tile
]]
function updateContextMenu(x, y)
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
end

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

function drawContextMenu()
  --Draw the context menu
  --Background
  love.graphics.setColor(0, 0, 0, 0.5)
  --print(math.findDistanceBetweenPoints(contextMenu.x, contextMenu.y, focusPointX - (centerWidth/scale), focusPointY - (centerHeight/scale)))
  print(contextMenu.x - focusPointX + (centerWidth/scale), contextMenu.y - focusPointY + (centerHeight/scale))
  --On Screen Coords: contextMenu.x - focusPointX + (centerWidth/scale), contextMenu.y - focusPointY + (centerHeight/scale), 200, 300
  love.graphics.rectangle("fill", contextMenu.x, contextMenu.y - (300/scale), 200/scale, 300/scale)

  --Top Bar
  love.graphics.setColor(1, 1, 1, 1)
  --On Screen Coords: contextMenu.x - focusPointX + (centerWidth/scale), contextMenu.y - focusPointY + (centerHeight/scale), 200, 10
  love.graphics.rectangle("fill", contextMenu.x, contextMenu.y - (300/scale), 200/scale, 10/scale)

  --Text
  love.graphics.setColor(1, 1, 1, 1)
  --On Screen Coords: contextMenu.x - focusPointX + (centerWidth/scale) + (10/scale), contextMenu.y - focusPointY + (centerHeight/scale) - (280/scale)
  love.graphics.print(contextMenu.text, contextMenu.x + (10/scale), contextMenu.y - (280/scale), 0, 1/scale, 1/scale)

  --Close Button
  love.graphics.setColor(1, 0, 0, 1)
  --On Screen Coords: contextMenu.x - focusPointX + (centerWidth/scale) + (180/scale), contextMenu.y - focusPointY + (centerHeight/scale) - (300/scale), 20, 10
  love.graphics.rectangle("fill", contextMenu.x + (180/scale), contextMenu.y - (300/scale), 20/scale, 10/scale) 

  --Move Player Button

  
end
  