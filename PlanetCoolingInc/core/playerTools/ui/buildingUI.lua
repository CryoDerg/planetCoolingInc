--Manage the UI for construction menus and building placement

function clickBuildingUI(x, y)
	--Check to see if the building menu is open
	if buildingMenuOpen then
		--Check to see if the mouse is over the left arrow button
		if math.checkIfPointInRect(x, y, 112.5, 137.5, windowHeight - 125, windowHeight - 25) then
      clickedButton = {112.5, 137.5, windowHeight - 125, windowHeight - 25}
			print("Left Arrow")

		--Check to see if the mouse is over the right arrow button
		elseif math.checkIfPointInRect(x, y, windowWidth - 50, windowWidth - 25, windowHeight - 125, windowHeight - 25) then
      clickedButton = {windowWidth - 50, windowWidth - 25, windowHeight - 125, windowHeight - 25}
			print("Right Arrow")
			
		--Check to see if the mouse is over a building button
		else
			for i = 1, #buildingBlueprints do
				local x1 = 143.75 + (i - 1) * 106.5
				local x2 = 243.75 + (i - 1) * 106.5
				local y1 = windowHeight - 125
				local y2 = windowHeight - 25
				if math.checkIfPointInRect(x, y, x1, x2, y1, y2) then
          clickedButton = {x1, x2, y1, y2}
					selectBuilding = i
					placingBuilding = true
					buildingMenuOpen = false
					break
				end
			end
		end
	end
	--Check to see if the mouse is over the building menu button
	if math.checkIfPointInRect(x, y, 31.25, 81.25, windowHeight - 125, windowHeight - 25) then
    clickedButton = {31.25, 81.25, windowHeight - 125, windowHeight - 25}
		buildingMenuOpen = not buildingMenuOpen
		placingBuilding = false
	end
end

function hoverBuildingUI(x, y)
	--Check to see if the building menu is open
	if buildingMenuOpen then
		--Check if mouse is over a building button
		for i = 1, #buildingBlueprints do
			local x1 = 143.75 + (i - 1) * 106.5
			local x2 = 243.75 + (i - 1) * 106.5
			local y1 = windowHeight - 125
			local y2 = windowHeight - 25
			if math.checkIfPointInRect(x, y, x1, x2, y1, y2) then
				--Draw the building info
				love.graphics.setColor(1, 1, 1, 1)
				--On Screen Coords: 50, 50, windowWidth - 100, windowHeight - 200
				hoverInfo = buildingBlueprints[i].name.."\n\n"..buildingBlueprints[i].description
				break
			else
				hoverInfo = ""
			end
		end
	end
end