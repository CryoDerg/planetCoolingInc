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
  if gamestate == "mainMenu" then
    print(uiScale)
    interactUI.mainMenu(screenMX / uiScale, screenMY / uiScale, k)
  elseif gamestate == "options" then
    interactUI.optionsMenu(screenMX / uiScale, screenMY / uiScale, k)
  elseif gamestate == "game" then
    interactUI.game(screenMX / uiScale, screenMY / uiScale, k)
  end

  if k == "b" then
    --Breakpoint
    breakpoint({}, true)
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