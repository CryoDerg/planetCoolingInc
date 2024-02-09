--Configure controls and keybindings
function configControls(controls)
  --If the controls are not set, set them to the default
  if controls == nil then
    controls = {
      genWorld = "g",
      toggleTempOverlay = "t",
      toggleNetworkOverlay = "x",
      placeBuilding = "m1",
      openContextMenu = "m2"
    }
  end
end
