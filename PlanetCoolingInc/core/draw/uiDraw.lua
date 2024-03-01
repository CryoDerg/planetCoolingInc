--Drawing Context Menu
function drawContextMenus()
	for ID, menu in ipairs(contextMenus) do
		--Draw Line from root to menu
		love.graphics.setColor(1, 1, 1, 1)
		--On Screen Coords: onActualGrid(menu.rootX, menu.rootY), menu.x - menu.rootX, menu.y - menu.rootY
		love.graphics.line(menu.rootX, menu.rootY, focusPointX - (centerWidth/scale) + (menu.x/scale), focusPointY - (centerHeight/scale) + (menu.y/scale))

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
				love.graphics.setColor(unpack(element.btnColor))
				--On Screen Coords: menu.x + 10, menu.y + 20 + (i - 1) * 30, 180, 20
				love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (menu.x/scale) + (10/scale), focusPointY - (centerHeight/scale) + (menu.y/scale) + (20/scale) + ((i - 1) * (30/scale)), (180/scale), (20/scale))

				--Draw button text
				love.graphics.setColor(unpack(element.textColor))
				--On Screen Coords: menu.x + 10, menu.y + 20 + (i - 1) * 30, 180, 20
				love.graphics.print(element.text, focusPointX - (centerWidth/scale) + (menu.x/scale) + (10/scale), focusPointY - (centerHeight/scale) + (menu.y/scale) + (20/scale) + ((i - 1) * (30/scale)), 0, 1/scale, 1/scale)
			elseif element.type == "text" then
				--Draw text
				love.graphics.setColor(unpack(element.textColor))
				--On Screen Coords: menu.x + 10, menu.y + 20 + (i - 1) * 30, 180, 20
				love.graphics.print(element.text, focusPointX - (centerWidth/scale) + (menu.x/scale) + (10/scale), focusPointY - (centerHeight/scale) + (menu.y/scale) + (20/scale) + ((i - 1) * (30/scale)), 0, 1/scale, 1/scale)
			elseif element.type == "inventory" then
				--Draw an inventory
				love.graphics.setColor(1, 1, 1, 1)
				--On Screen Coords: menu.x + 10, menu.y + 20 + (i - 1) * 30, 180, 20
				love.graphics.print("Inventory", focusPointX - (centerWidth/scale) + (menu.x/scale) + (10/scale), focusPointY - (centerHeight/scale) + (menu.y/scale) + (20/scale) + ((i - 1) * (30/scale)), 0, 1/scale, 1/scale)

				--Draw the inventory
				--On Screen Coords: menu.x + 10, menu.y + 20 + (i - 1) * 30, 180, 20
				j = 1
				for itemName, item in pairs(element.inventory.items) do
					--container for text
					love.graphics.setColor(1, 1, 1, 1)
					--On Screen Coords: menu.x + 10, menu.y + 20 + (i - 1) * 30 + j * 20, 180, 20
					love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (menu.x/scale) + (10/scale), focusPointY - (centerHeight/scale) + (menu.y/scale) + (20/scale) + ((i - 1) * (30/scale)) + (j * (20/scale)), (180/scale), (20/scale))
					--item name and amount
					love.graphics.setColor(0, 0, 0, 1)
					--On Screen Coords: menu.x + 10, menu.y + 20 + (i - 1) * 30 + j * 20, 180, 20
					love.graphics.print(itemName..": "..item.amount, focusPointX - (centerWidth/scale) + (menu.x/scale) + (10/scale), focusPointY - (centerHeight/scale) + (menu.y/scale) + (20/scale) + ((i - 1) * (30/scale)) + (j * (20/scale)), 0, 1/scale, 1/scale)
					j = j + 1
				end
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

--Drawing Drone Program menu
function droneProgramUI()
	if droneProgramOpen then
		--Draw the drone program menu
		--Background
		love.graphics.setColor(0, 0, 0, 0.5)
		--On Screen Coords: 0, 0, windowWidth, windowHeight
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale), focusPointY - (centerHeight/scale), (windowWidth/scale), (windowHeight/scale))

		--Draw program events section
		love.graphics.setColor(0.5, 0.5, 0.5, 1)
		--On Screen Coords: 0, 0, windowWidth, 200
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale), focusPointY - (centerHeight/scale), (windowWidth/scale), (200/scale))

		--Draw the 5 program events
		love.graphics.setColor(1, 1, 1, 1)
		--On Screen Coords: 205, 10, 150, 80
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (205/scale), focusPointY - (centerHeight/scale) + (10/scale), (150/scale), (80/scale))
		--On Screen Coords: 365, 10, 150, 80
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (365/scale), focusPointY - (centerHeight/scale) + (10/scale), (150/scale), (80/scale))
		--On Screen Coords: 525, 10, 150, 80
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (525/scale), focusPointY - (centerHeight/scale) + (10/scale), (150/scale), (80/scale))
		--On Screen Coords: 685, 10, 150, 80
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (685/scale), focusPointY - (centerHeight/scale) + (10/scale), (150/scale), (80/scale))
		--On Screen Coords: 845, 10, 150, 80
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (845/scale), focusPointY - (centerHeight/scale) + (10/scale), (150/scale), (80/scale))
		

		--Draw the program events text
		love.graphics.setColor(0, 0, 0, 1)
		--On Screen Coords: 210, 15
		love.graphics.print("Move To Tile", focusPointX - (centerWidth/scale) + (210/scale), focusPointY - (centerHeight/scale) + (15/scale), 0, 1/scale, 1/scale)
		--On Screen Coords: 370, 15
		love.graphics.print("Pick up Items", focusPointX - (centerWidth/scale) + (370/scale), focusPointY - (centerHeight/scale) + (15/scale), 0, 1/scale, 1/scale)
		--On Screen Coords: 530, 15
		love.graphics.print("Drop Items", focusPointX - (centerWidth/scale) + (530/scale), focusPointY - (centerHeight/scale) + (15/scale), 0, 1/scale, 1/scale)
		--On Screen Coords: 690, 15
		love.graphics.print("Go Idle", focusPointX - (centerWidth/scale) + (690/scale), focusPointY - (centerHeight/scale) + (15/scale), 0, 1/scale, 1/scale)
		--On Screen Coords: 850, 15
		love.graphics.print("Return to Hub", focusPointX - (centerWidth/scale) + (850/scale), focusPointY - (centerHeight/scale) + (15/scale), 0, 1/scale, 1/scale)

		--Draw already programmed events
		for i, event in ipairs(programDrone.program) do
			love.graphics.setColor(1, 1, 1, 1)
			--On Screen Coords: 10 + (i - 1) * 160, 300, 150, 80
			love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (10/scale) + ((i - 1) * (160/scale)), focusPointY - (centerHeight/scale) + (300/scale), (150/scale), (80/scale))
			love.graphics.setColor(0, 0, 0, 1)
			--On Screen Coords: 15 + (i - 1) * 160, 305
			love.graphics.print(event.eventText, focusPointX - (centerWidth/scale) + (15/scale) + ((i - 1) * (160/scale)), focusPointY - (centerHeight/scale) + (305/scale), 0, 1/scale, 1/scale)
			--Delete Button
			love.graphics.setColor(1, 0, 0, 1)
			--On Screen Coords: 135 + (i - 1) * 160, 355, 20, 20
			love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + (135/scale) + ((i - 1) * (160/scale)), focusPointY - (centerHeight/scale) + (355/scale), (20/scale), (20/scale))
		end
	end
end