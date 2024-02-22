--Drawing Context Menu
function drawContextMenus()
	for ID, menu in ipairs(contextMenus) do
		--Draw Line from root to menu
		love.graphics.setColor(1, 1, 1, 1)
		--On Screen Coords: menu.rootX, menu.rootY, menu.x - menu.rootX, menu.y - menu.rootY
		love.graphics.line(focusPointX - (centerWidth/scale) + (menu.rootX/scale), focusPointY - (centerHeight/scale) + (menu.rootY/scale), focusPointX - (centerWidth/scale) + (menu.x/scale), focusPointY - (centerHeight/scale) + (menu.y/scale))

		--Draw the background
		love.graphics.setColor(0, 0, 0, 0.5)
		--On Screen Coords: menu.x, menu.y, 200, 200
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (menu.x/scale), focusPointY - (centerHeight/scale) + (menu.y/scale), (200/scale), (200/scale))

		--Draw the top bar
		love.graphics.setColor(1, 1, 1, 1)
		--On Screen Coords: menu.x, menu.y, 200, 10
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (menu.x/scale), focusPointY - (centerHeight/scale) + (menu.y/scale), (200/scale), (10/scale))

		--Draw the close button
		love.graphics.setColor(1, 0, 0, 1)
		--On Screen Coords: menu.x + 190, menu.y, 10, 10
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (menu.x/scale) + (190/scale), focusPointY - (centerHeight/scale) + (menu.y/scale), (10/scale), (10/scale))
		
		--Draw the elements
		for i, element in ipairs(menu.elements) do
			if element.type == "btn" then
				--Draw a button
				love.graphics.setColor(1, 1, 1, 1)
				--On Screen Coords: menu.x + 10, menu.y + 10 + (i - 1) * 30, 180, 20
				love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (menu.x/scale) + (10/scale), focusPointY - (centerHeight/scale) + (menu.y/scale) + (10/scale) + ((i - 1) * (30/scale)), (180/scale), (20/scale))
				love.graphics.setColor(1, 1, 1, 1)
				--On Screen Coords: menu.x + 10, menu.y + 10 + (i - 1) * 30, 180, 20
				love.graphics.print(element.text, focusPointX - (centerWidth/scale) + (menu.x/scale) + (10/scale), focusPointY - (centerHeight/scale) + (menu.y/scale) + (10/scale) + ((i - 1) * (30/scale)))
			elseif element.type == "text" then
				--Draw text
				love.graphics.setColor(1, 1, 1, 1)
				--On Screen Coords: menu.x + 10, menu.y + 10 + (i - 1) * 30, 180, 20
				love.graphics.print(element.text, focusPointX - (centerWidth/scale) + (menu.x/scale) + (10/scale), focusPointY - (centerHeight/scale) + (menu.y/scale) + (10/scale) + ((i - 1) * (30/scale)))
			elseif element.type == "inventory" then
				--Draw an inventory
				love.graphics.setColor(1, 1, 1, 1)
				--On Screen Coords: menu.x + 10, menu.y + 10 + (i - 1) * 30, 180, 20
				love.graphics.print("Inventory", focusPointX - (centerWidth/scale) + (menu.x/scale) + (10/scale), focusPointY - (centerHeight/scale) + (menu.y/scale) + (10/scale) + ((i - 1) * (30/scale)))
			end
		end
	end
end

--Drawing Building Menu
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

--Drawing Building Placement
function constructionUI()
	--Draw the building being placed
	love.graphics.setColor(1, 1, 1, 1)
	--On Screen Coords: tileX * 60, tileY * 60, 60, 60
	tileX = math.floor((mX - camX)/60)
	tileY = math.floor((mY - camY)/60)
	love.graphics.rectangle("fill", tileX * 60, tileY * 60, 60, 60)
end

--Drawing Inventory
function drawInventory(inventory)
	--Draw an inventory in the from of a context menu
end
