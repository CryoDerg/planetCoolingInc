--Configure controls and keybindings
function configControls(controls) --Controls for Mouse: M1, M2... add "R" to indicate release
  --If the controls are not set, set them to the default
  if controls == nil then
    return {
      genWorld = settings.defaults.controls.genWorld,
      tempOverlay = settings.defaults.controls.toggleTempOverlay,
      networkOverlay = settings.defaults.controls.toggleNetworkOverlay,
      placeBuilding = settings.defaults.controls.placeBuilding,
      openContextMenu = settings.defaults.controls.openContextMenu
    }
  end
end

function updateControls(k)
  --When input is received, check to see if it is a control and execute the appropriate action
  if k == settings.controls.tempOverlay then
    tempOverlay = not tempOverlay
  end

  if k == settings.controls.genWorld then 
    genNewWorld(100)
  end

  if k == "b" then
    breakpoint({}, true)
  end

  if k == "h" then
    showHotTiles = not showHotTiles
  end

  if k == settings.controls.networkOverlay then
    networkOverlay = not networkOverlay
  end

  if k == "f" then 
    settings.fullscreenState = not settings.fullscreenState 
    saveSettings()
  end

  if k == "m" then
    --move player to mouse
    movePlayerTo(mX - camX, mY - camY)
  end

  if k == "p" then
    print(tableToString(settings))
  end

  if k == "d" then
    buildingBlueprints[9].placeBuilding(grid.tiles[math.floor((mX - camX)/60)][math.floor((mY - camY)/60)])
    openProgramMenu(drones[1])
  end

  if k == settings.controls.placeBuilding then
    if tileSelectionOpen then
      local tile = clickTile(mX, mY)
      if tile then
        tileSelectionDrone.program[tileSelectionEvent] = {event = "MoveTo", eventText = "Move To Tile", x = tile.x, y = tile.y, tile = tile}
        tileSelectionOpen = false
        droneProgramOpen = true
      end
    elseif hubLinkOpen then
      local tile = clickTile(mX, mY)
      if tile then
        if tile.droneHubInfo.hasHub then
          linkDroneToHub(linkDrone, tile)
          hubLinkOpen = false
        end
      end
    else
      clickBuildingUI(screenMX, screenMY)
      clickContextMenu(screenMX, screenMY)
      clickProgramMenu(screenMX, screenMY)
    
      if placingBuilding and not clickedButton[1] then
        local x, y = math.floor((mX - camX)/60), math.floor((mY - camY)/60)
        buildingBlueprints[selectBuilding].placeBuilding(grid.tiles[x][y])
      end
    end
  end

  if k == settings.controls.openContextMenu and clickTile(mX, mY) and camMoved < 8 then
    createContextMenu(mX, mY)
  end

  if k == "escape" then
    buildingMenuOpen = false
  end

  if k == "1" then
    createGameMessage("Hewwo", mX - camX, mY - camY, 5)
  end
end

function clickTile(x, y)
  --Check to see if the mouse is in the grid
  if grid.tiles[math.floor((x - camX)/60)] then
    if grid.tiles[math.floor((x - camX)/60)][math.floor((y - camY)/60)] then
      --get tile
      return grid.tiles[math.floor((x - camX)/60)][math.floor((y - camY)/60)]
    end
  end

  return false

end