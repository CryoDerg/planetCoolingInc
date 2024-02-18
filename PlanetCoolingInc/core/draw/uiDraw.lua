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

function constructionUI()
	--Draw the building being placed
	love.graphics.setColor(1, 1, 1, 1)
	--On Screen Coords: tileX * 60, tileY * 60, 60, 60
	tileX = math.floor((mX - camX)/60)
	tileY = math.floor((mY - camY)/60)
	love.graphics.rectangle("fill", tileX * 60, tileY * 60, 60, 60)
end