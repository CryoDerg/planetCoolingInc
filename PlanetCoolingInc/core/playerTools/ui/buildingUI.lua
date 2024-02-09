--Manage the UI for construction menus and building placement

function drawBuildingUI()
	--Check to see if the building menu is open
	if buildingMenuOpen then
		--Draw the background
		love.graphics.setColor(0, 0, 0, 0.5)
		--On Screen Coords: 0, 0, windowWidth, windowHeight
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale), focusPointY - (centerHeight/scale), (windowWidth/scale), (windowHeight/scale))
		--Draw the menu
		love.graphics.setColor(1, 1, 1, 1)
		--On Screen Coords: 0, windowHeight - 150, windowWidth, 150
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale), focusPointY + (centerHeight/scale) - (150/scale), (windowWidth/scale), (150/scale))
		--Draw the buttons
		for i = 1, #buildingBlueprints do
			love.graphics.setColor(0, 0, 0, 1)
			--On Screen Coords: 143.75 + (i - 1) * 106.5, windowHeight - 125, 100, 100
			love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (143.75/scale) + (i - 1) * (106.5/scale), focusPointY + (centerHeight/scale) - (125/scale), (100/scale), (100/scale))
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.print(buildingBlueprints[i].name, focusPointX - (centerWidth/scale) + (143.75/scale) + (i - 1) * (106.5/scale), focusPointY + (centerHeight/scale) - (125/scale), 0 , 1/scale, 1/scale)
		end
		--Draw Arrow Buttons
		love.graphics.setColor(0, 1, 0, 1)
		--Left Arrow
		--On Screen Coords: 112.5, windowHeight - 125, 25, 100
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (112.5/scale), focusPointY + (centerHeight/scale) - (125/scale), (25/scale), (100/scale))
		--Right Arrow
		--On Screen Coords: windowWidth - 50, windowHeight - 125, 25, 100
		love.graphics.rectangle("fill", focusPointX + (centerWidth/scale) - (50/scale), focusPointY + (centerHeight/scale) - (125/scale), (25/scale), (100/scale)) 

		--Draw building info is mouse is over a building button
		love.graphics.setColor(1, 1, 1, 1)
		--On Screen Coords: 50, 50, windowWidth - 100, windowHeight - 200
		love.graphics.print(hoverInfo, focusPointX - (centerWidth/scale) + (50/scale), focusPointY - (centerHeight/scale) + (150/scale), 0, 1/scale, 1/scale)
	end
	--Draw building menu button in the bottom left corner
	if buildingMenuOpen then
		love.graphics.setColor(1, 0, 0, 1)
	else
		love.graphics.setColor(0, 1, 1, 1)
	end
	--On Screen Coords: 31.25, windowHeight - 125, 50, 100
	love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (31.25/scale), focusPointY + (centerHeight/scale) - (125/scale), (50/scale), (100/scale))
end

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

function constructionUI()
	--Draw the building being placed
	love.graphics.setColor(1, 1, 1, 1)
	--On Screen Coords: tileX * 60, tileY * 60, 60, 60
	tileX = math.floor((mX - camX)/60)
	tileY = math.floor((mY - camY)/60)
	love.graphics.rectangle("fill", tileX * 60, tileY * 60, 60, 60)
end