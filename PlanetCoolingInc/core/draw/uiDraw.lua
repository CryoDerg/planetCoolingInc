--Game Width : 1200
--Game Height : 675
uiDraw = {}

--Drawing Main Menu
uiDraw.drawMainMenu = function()
	--Title Card
	love.graphics.setColor(0, 1, 1, 1)
	--On Screen Coords: 400, 100, 400, 200
	love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((400/scale)*uiScale), focusPointY - (centerHeight/scale) + ((100/scale)*uiScale), ((400/scale)*uiScale), ((200/scale)*uiScale))
	
	--Draw buttons
	--Start Button
	love.graphics.setColor(0, 0, 1, 1)
	--On Screen Coords: 450, 400, 300, 50
	love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((450/scale)*uiScale), focusPointY - (centerHeight/scale) + ((400/scale)*uiScale), ((300/scale)*uiScale), ((50/scale)*uiScale))
	
	--Options Button
	love.graphics.setColor(0, 1, 0, 1)
	--On Screen Coords: 450, 500, 300, 50
	love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((450/scale)*uiScale), focusPointY - (centerHeight/scale) + ((500/scale)*uiScale), ((300/scale)*uiScale), ((50/scale)*uiScale))

	--Exit Button
	love.graphics.setColor(1, 0, 0, 1)
	--On Screen Coords: 20, windowHeight - 70, 100, 50
	love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((20/scale)*uiScale), focusPointY + (centerHeight/scale) - ((70/scale)*uiScale), ((100/scale)*uiScale), ((50/scale)*uiScale))
end

uiDraw.drawOptionsMenu = function()
	--Draw Fullscreen Option
	--On Screen Coords: 450, 200, 300, 50
	if fullscreen then
		love.graphics.setColor(0, 1, 0, 1)
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((450/scale)*uiScale), focusPointY - (centerHeight/scale) + ((200/scale)*uiScale), ((300/scale)*uiScale), ((50/scale)*uiScale))
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print("Fullscreen: On", focusPointX - (centerWidth/scale) + ((450/scale)*uiScale), focusPointY - (centerHeight/scale) + ((200/scale)*uiScale), 0, (1/scale)*uiScale, (1/scale)*uiScale)
	else
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((450/scale)*uiScale), focusPointY - (centerHeight/scale) + ((200/scale)*uiScale), ((300/scale)*uiScale), ((50/scale)*uiScale))
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.print("Fullscreen: Off", focusPointX - (centerWidth/scale) + ((450/scale)*uiScale), focusPointY - (centerHeight/scale) + ((200/scale)*uiScale), 0, (1/scale)*uiScale, (1/scale)*uiScale)
	end
	
	
	

	--Draw Exit Button
	love.graphics.setColor(1, 0, 0, 1)
	--On Screen Coords: 20, windowHeight - 70, 100, 50
	love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((20/scale)*uiScale), focusPointY + (centerHeight/scale) - ((70/scale)*uiScale), ((100/scale)*uiScale), ((50/scale)*uiScale))
end

--Drawing Context Menu
uiDraw.drawContextMenus = function()
	for ID, menu in ipairs(contextMenus) do
		--Draw Line from root to menu
		love.graphics.setColor(1, 1, 1, 1)
		--On Screen Coords: onActualGrid(menu.rootX, menu.rootY), menu.x - menu.rootX, menu.y - menu.rootY
		love.graphics.line(menu.rootX, menu.rootY, focusPointX - (centerWidth/scale) + ((menu.x/scale)*uiScale), focusPointY - (centerHeight/scale) + ((menu.y/scale)*uiScale))

		--Draw the background
		love.graphics.setColor(0, 0, 0, 0.5)
		--On Screen Coords: menu.x, menu.y, 200, 200
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((menu.x/scale)*uiScale), focusPointY - (centerHeight/scale) + ((menu.y/scale)*uiScale), ((200/scale)*uiScale), ((200/scale)*uiScale))

		--Draw the top bar
		love.graphics.setColor(1, 1, 1, 1)
		--On Screen Coords: menu.x, menu.y, 200, 10
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((menu.x/scale)*uiScale), focusPointY - (centerHeight/scale) + ((menu.y/scale)*uiScale), ((200/scale)*uiScale), ((10/scale)*uiScale))

		--Draw the close button
		love.graphics.setColor(1, 0, 0, 1)
		--On Screen Coords: menu.x + 190, menu.y, 10, 10
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((menu.x/scale)*uiScale) + ((190/scale)*uiScale), focusPointY - (centerHeight/scale) + ((menu.y/scale)*uiScale), ((10/scale)*uiScale), ((10/scale)*uiScale))
		
		--Draw the elements
		for i, element in ipairs(menu.elements) do
			if element.type == "btn" then
				--Draw a button
				love.graphics.setColor(unpack(element.btnColor))
				--On Screen Coords: menu.x + 10, menu.y + 20 + (i - 1) * 30, 180, 20
				love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((menu.x/scale)*uiScale) + ((10/scale)*uiScale), focusPointY - (centerHeight/scale) + ((menu.y/scale)*uiScale) + ((20/scale)*uiScale) + ((i - 1) * ((30/scale)*uiScale)), ((180/scale)*uiScale), ((20/scale)*uiScale))

				--Draw button text
				love.graphics.setColor(unpack(element.textColor))
				--On Screen Coords: menu.x + 10, menu.y + 20 + (i - 1) * 30, 180, 20
				love.graphics.print(element.text, focusPointX - (centerWidth/scale) + ((menu.x/scale)*uiScale) + ((10/scale)*uiScale), focusPointY - (centerHeight/scale) + ((menu.y/scale)*uiScale) + ((20/scale)*uiScale) + ((i - 1) * ((30/scale)*uiScale)), 0, (1/scale)*uiScale, (1/scale)*uiScale)
			elseif element.type == "text" then
				--Draw text
				love.graphics.setColor(unpack(element.textColor))
				--On Screen Coords: menu.x + 10, menu.y + 20 + (i - 1) * 30, 180, 20
				love.graphics.print(element.text, focusPointX - (centerWidth/scale) + ((menu.x/scale)*uiScale) + ((10/scale)*uiScale), focusPointY - (centerHeight/scale) + ((menu.y/scale)*uiScale) + ((20/scale)*uiScale) + ((i - 1) * ((30/scale)*uiScale)), 0, (1/scale)*uiScale, (1/scale)*uiScale)
			elseif element.type == "inventory" then
				--Draw an inventory
				love.graphics.setColor(1, 1, 1, 1)
				--On Screen Coords: menu.x + 10, menu.y + 20 + (i - 1) * 30, 180, 20
				love.graphics.print("Inventory", focusPointX - (centerWidth/scale) + ((menu.x/scale)*uiScale) + ((10/scale)*uiScale), focusPointY - (centerHeight/scale) + ((menu.y/scale)*uiScale) + ((20/scale)*uiScale) + ((i - 1) * ((30/scale)*uiScale)), 0, (1/scale)*uiScale, (1/scale)*uiScale)

				--Draw the inventory
				--On Screen Coords: menu.x + 10, menu.y + 20 + (i - 1) * 30, 180, 20
				j = 1
				for itemName, item in pairs(element.inventory.items) do
					--container for text
					love.graphics.setColor(1, 1, 1, 1)
					--On Screen Coords: menu.x + 10, menu.y + 20 + (i - 1) * 30 + j * 20, 180, 20
					love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((menu.x/scale)*uiScale) + ((10/scale)*uiScale), focusPointY - (centerHeight/scale) + ((menu.y/scale)*uiScale) + ((20/scale)*uiScale) + ((i - 1) * ((30/scale)*uiScale)) + (j * ((20/scale)*uiScale)), ((180/scale)*uiScale), ((20/scale)*uiScale))
					--item name and amount
					love.graphics.setColor(0, 0, 0, 1)
					--On Screen Coords: menu.x + 10, menu.y + 20 + (i - 1) * 30 + j * 20, 180, 20
					love.graphics.print(itemName..": "..item.amount, focusPointX - (centerWidth/scale) + ((menu.x/scale)*uiScale) + ((10/scale)*uiScale), focusPointY - (centerHeight/scale) + ((menu.y/scale)*uiScale) + ((20/scale)*uiScale) + ((i - 1) * ((30/scale)*uiScale)) + (j * ((20/scale)*uiScale)), 0, (1/scale)*uiScale, (1/scale)*uiScale)
					j = j + 1
				end
			end
		end
	end
end

--Drawing Building Menu
uiDraw.drawBuildingMenu = function()
	--Check to see if the building menu is open
	if buildingMenuOpen then
		--Draw the background
		love.graphics.setColor(0, 0, 0, 0.5)
		--On Screen Coords: 0, 0, windowWidth, windowHeight
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale), focusPointY - (centerHeight/scale), ((windowWidth/scale)*uiScale), ((windowHeight/scale)*uiScale))
		--Draw the menu
		love.graphics.setColor(1, 1, 1, 1)
		--On Screen Coords: 0, windowHeight - 150, windowWidth, 150
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale), focusPointY + (centerHeight/scale) - ((150/scale)*uiScale), ((windowWidth/scale)*uiScale), ((150/scale)*uiScale))
		--Draw the buttons
		for i = 1, #buildingBlueprints do
			love.graphics.setColor(0, 0, 0, 1)
			--On Screen Coords: 143.75 + (i - 1) * 106.5, windowHeight - 125, 100, 100
			love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((143.75/scale)*uiScale) + (i - 1) * ((106.5/scale)*uiScale), focusPointY + (centerHeight/scale) - ((125/scale)*uiScale), ((100/scale)*uiScale), ((100/scale)*uiScale))
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.print(buildingBlueprints[i].name, focusPointX - (centerWidth/scale) + ((143.75/scale)*uiScale) + (i - 1) * ((106.5/scale)*uiScale), focusPointY + (centerHeight/scale) - ((125/scale)*uiScale), 0 , (1/scale)*uiScale, (1/scale)*uiScale)
		end
		--Draw Arrow Buttons
		love.graphics.setColor(0, 1, 0, 1)
		--Left Arrow
		--On Screen Coords: 112.5, windowHeight - 125, 25, 100
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((112.5/scale)*uiScale), focusPointY + (centerHeight/scale) - ((125/scale)*uiScale), ((25/scale)*uiScale), ((100/scale)*uiScale))
		--Right Arrow
		--On Screen Coords: windowWidth - 50, windowHeight - 125, 25, 100
		love.graphics.rectangle("fill", focusPointX + (centerWidth/scale) - ((50/scale)*uiScale), focusPointY + (centerHeight/scale) - ((125/scale)*uiScale), ((25/scale)*uiScale), ((100/scale)*uiScale)) 

		--Draw building info is mouse is over a building button
		love.graphics.setColor(1, 1, 1, 1)
		--On Screen Coords: 50, 50, windowWidth - 100, windowHeight - 200
		love.graphics.print(hoverInfo, focusPointX - (centerWidth/scale) + ((50/scale)*uiScale), focusPointY - (centerHeight/scale) + ((150/scale)*uiScale), 0, (1/scale)*uiScale, (1/scale)*uiScale)
	end
	--Draw building menu button in the bottom left corner
	if buildingMenuOpen then
		love.graphics.setColor(1, 0, 0, 1)
	else
		love.graphics.setColor(0, 1, 1, 1)
	end
	--On Screen Coords: 31.25, windowHeight - 125, 50, 100
	love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((31.25/scale)*uiScale), focusPointY + (centerHeight/scale) - ((125/scale)*uiScale), ((50/scale)*uiScale), ((100/scale)*uiScale))
end

--Drawing Building Placement
uiDraw.constructionUI = function()
	--Draw the building being placed
	love.graphics.setColor(1, 1, 1, 1)
	--On Screen Coords: tileX * 60, tileY * 60, 60, 60
	tileX = math.floor((mX - camX)/60)
	tileY = math.floor((mY - camY)/60)
	love.graphics.rectangle("fill", tileX * 60, tileY * 60, 60, 60)
end

--Drawing Drone Program menu
uiDraw.droneProgramUI = function()
	if droneProgramOpen then
		--Draw the drone program menu
		--Background
		love.graphics.setColor(0, 0, 0, 0.5)
		--On Screen Coords: 0, 0, windowWidth, windowHeight
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale), focusPointY - (centerHeight/scale), ((windowWidth/scale)*uiScale), ((windowHeight/scale)*uiScale))

		--Draw program events section
		love.graphics.setColor(0.5, 0.5, 0.5, 1)
		--On Screen Coords: 0, 0, windowWidth, 200
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale), focusPointY - (centerHeight/scale), ((windowWidth/scale)*uiScale), ((200/scale)*uiScale))

		--Draw Exit Button
		love.graphics.setColor(1, 0, 0, 1)
		--On Screen Coords: windowWidth - 75, windowHeight - 125, 50, 100
		love.graphics.rectangle("fill", focusPointX + (centerWidth/scale) - ((75/scale)*uiScale), focusPointY + (centerHeight/scale) - ((125/scale)*uiScale), ((50/scale)*uiScale), ((100/scale)*uiScale))

		--Draw the 5 program events
		love.graphics.setColor(1, 1, 1, 1)
		--On Screen Coords: 205, 10, 150, 80
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((205/scale)*uiScale), focusPointY - (centerHeight/scale) + ((10/scale)*uiScale), ((150/scale)*uiScale), ((80/scale)*uiScale))
		--On Screen Coords: 365, 10, 150, 80
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((365/scale)*uiScale), focusPointY - (centerHeight/scale) + ((10/scale)*uiScale), ((150/scale)*uiScale), ((80/scale)*uiScale))
		--On Screen Coords: 525, 10, 150, 80
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((525/scale)*uiScale), focusPointY - (centerHeight/scale) + ((10/scale)*uiScale), ((150/scale)*uiScale), ((80/scale)*uiScale))
		--On Screen Coords: 685, 10, 150, 80
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((685/scale)*uiScale), focusPointY - (centerHeight/scale) + ((10/scale)*uiScale), ((150/scale)*uiScale), ((80/scale)*uiScale))
		--On Screen Coords: 845, 10, 150, 80
		love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((845/scale)*uiScale), focusPointY - (centerHeight/scale) + ((10/scale)*uiScale), ((150/scale)*uiScale), ((80/scale)*uiScale))
		

		--Draw the program events text
		love.graphics.setColor(0, 0, 0, 1)
		--On Screen Coords: 210, 15
		love.graphics.print("Move To Tile", focusPointX - (centerWidth/scale) + ((210/scale)*uiScale), focusPointY - (centerHeight/scale) + ((15/scale)*uiScale), 0, (1/scale)*uiScale, (1/scale)*uiScale)
		--On Screen Coords: 370, 15
		love.graphics.print("Pick up Items", focusPointX - (centerWidth/scale) + ((370/scale)*uiScale), focusPointY - (centerHeight/scale) + ((15/scale)*uiScale), 0, (1/scale)*uiScale, (1/scale)*uiScale)
		--On Screen Coords: 530, 15
		love.graphics.print("Drop Items", focusPointX - (centerWidth/scale) + ((530/scale)*uiScale), focusPointY - (centerHeight/scale) + ((15/scale)*uiScale), 0, (1/scale)*uiScale, (1/scale)*uiScale)
		--On Screen Coords: 690, 15
		love.graphics.print("Go Idle", focusPointX - (centerWidth/scale) + ((690/scale)*uiScale), focusPointY - (centerHeight/scale) + ((15/scale)*uiScale), 0, (1/scale)*uiScale, (1/scale)*uiScale)
		--On Screen Coords: 850, 15
		love.graphics.print("Return to Hub", focusPointX - (centerWidth/scale) + ((850/scale)*uiScale), focusPointY - (centerHeight/scale) + ((15/scale)*uiScale), 0, (1/scale)*uiScale, (1/scale)*uiScale)

		--Draw already programmed events
		for i, event in ipairs(programDrone.program) do
			love.graphics.setColor(1, 1, 1, 1)
			--On Screen Coords: 10 + (i - 1) * 160, 300, 150, 80
			love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((10/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((300/scale)*uiScale), ((150/scale)*uiScale), ((80/scale)*uiScale))
			love.graphics.setColor(0, 0, 0, 1)
			--On Screen Coords: 15 + (i - 1) * 160, 305
			love.graphics.print(event.eventText, focusPointX - (centerWidth/scale) + ((15/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((305/scale)*uiScale), 0, (1/scale)*uiScale, (1/scale)*uiScale)
			--Delete Button
			love.graphics.setColor(1, 0, 0, 1)
			--On Screen Coords: 135 + (i - 1) * 160, 355, 20, 20
			love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((135/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((355/scale)*uiScale), ((20/scale)*uiScale), ((20/scale)*uiScale))

			--Draw event specific actions
			if event.event == "MoveTo" then
				--Draw the tile to move to
				love.graphics.setColor(0, 0, 0, 1)
				--On Screen Coords: 20 + (i - 1) * 160, 325
				love.graphics.print("Move To: ("..event.x..","..event.y..")", focusPointX - (centerWidth/scale) + ((20/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((325/scale)*uiScale), 0, (1/scale)*uiScale, (1/scale)*uiScale)

				--Draw the select tile button
				love.graphics.setColor(0, 1, 0, 1)
				--On Screen Coords: 20 + (i - 1) * 160, 350, 50, 20
				love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((20/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((350/scale)*uiScale), ((50/scale)*uiScale), ((20/scale)*uiScale))

			elseif event.event == "PickupItem" then
				--Draw the item to pick up
				love.graphics.setColor(0, 0, 0, 1)
				--On Screen Coords: 20 + (i - 1) * 160, 325
				local itemText = "Pick up: "
				if event.item == "" then
					itemText = itemText.."Any"
				else
					itemText = itemText..event.item.name
				end
				love.graphics.print(itemText, focusPointX - (centerWidth/scale) + ((20/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((325/scale)*uiScale), 0, (1/scale)*uiScale, (1/scale)*uiScale)

				--Draw the select item button
				love.graphics.setColor(0, 1, 0, 1)
				--On Screen Coords: 20 + (i - 1) * 160, 350, 50, 20
				love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((20/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((350/scale)*uiScale), ((50/scale)*uiScale), ((20/scale)*uiScale))

				if event.selectItem then
					--Draw the item selection menu
					love.graphics.setColor(1, 1, 1, 1)
					--On Screen Coords: 10 + (i - 1) * 160, 390, 100, 250
					love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((10/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((390/scale)*uiScale), ((100/scale)*uiScale), ((250/scale)*uiScale))

					--draw item selection
					for itemID, item in ipairs(itemList) do
						love.graphics.setColor(0.6, 0.6, 0.6, 1)
						--On Screen Coords: 15 + (i - 1) * 160, 396 + (itemID - 1) * 20, 90, 18
						love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((15/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((396/scale)*uiScale) + ((itemID - 1) * ((20/scale)*uiScale)), ((90/scale)*uiScale), ((18/scale)*uiScale))

						love.graphics.setColor(0, 0, 0, 1)
						--On Screen Coords: 15 + (i - 1) * 160, 395 + (itemID - 1) * 20
						love.graphics.print(item.name, focusPointX - (centerWidth/scale) + ((15/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((395/scale)*uiScale) + ((itemID - 1) * ((20/scale)*uiScale)), 0, (1/scale)*uiScale, (1/scale)*uiScale)
					end
				end
			elseif event.event == "DropItem" then
				--Draw the item to drop
				love.graphics.setColor(0, 0, 0, 1)
				--On Screen Coords: 20 + (i - 1) * 160, 325
				local itemText = "Drop: "
				if event.item == "" then
					itemText = itemText.."Any"
				else
					itemText = itemText..event.item.name
				end
				love.graphics.print(itemText, focusPointX - (centerWidth/scale) + ((20/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((325/scale)*uiScale), 0, (1/scale)*uiScale, (1/scale)*uiScale)

				--Draw the select item button
				love.graphics.setColor(0, 1, 0, 1)
				--On Screen Coords: 20 + (i - 1) * 160, 350, 50, 20
				love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((20/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((350/scale)*uiScale), ((50/scale)*uiScale), ((20/scale)*uiScale))

				if event.selectItem then
					--Draw the item selection menu
					love.graphics.setColor(1, 1, 1, 1)
					--On Screen Coords: 10 + (i - 1) * 160, 390, 100, 250
					love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((10/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((390/scale)*uiScale), ((100/scale)*uiScale), ((250/scale)*uiScale))

					--draw item selection
					for itemID, item in ipairs(itemList) do
						love.graphics.setColor(0.6, 0.6, 0.6, 1)
						--On Screen Coords: 15 + (i - 1) * 160, 396 + (itemID - 1) * 20, 90, 18
						love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((15/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((396/scale)*uiScale) + ((itemID - 1) * ((20/scale)*uiScale)), ((90/scale)*uiScale), ((18/scale)*uiScale))

						love.graphics.setColor(0, 0, 0, 1)
						--On Screen Coords: 15 + (i - 1) * 160, 395 + (itemID - 1) * 20
						love.graphics.print(item.name, focusPointX - (centerWidth/scale) + ((15/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((395/scale)*uiScale) + ((itemID - 1) * ((20/scale)*uiScale)), 0, (1/scale)*uiScale, (1/scale)*uiScale)
					end
				end
			elseif event.event == "idle" then
				--Draw the time to idle
				love.graphics.setColor(0, 0, 0, 1)
				--On Screen Coords: 20 + (i - 1) * 160, 325
				love.graphics.print("Idle for: "..event.time.." seconds", focusPointX - (centerWidth/scale) + ((20/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((325/scale)*uiScale), 0, (1/scale)*uiScale, (1/scale)*uiScale)

				--Draw the time selection buttons
				love.graphics.setColor(0, 1, 0, 1)
				--On Screen Coords: 20 + (i - 1) * 160, 350, 20, 20
				love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((20/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((350/scale)*uiScale), ((20/scale)*uiScale), ((20/scale)*uiScale))
				--On Screen Coords: 45 + (i - 1) * 160, 350, 20, 20
				love.graphics.rectangle("fill", focusPointX - (centerWidth/scale) + ((45/scale)*uiScale) + ((i - 1) * ((160/scale)*uiScale)), focusPointY - (centerHeight/scale) + ((350/scale)*uiScale), ((20/scale)*uiScale), ((20/scale)*uiScale))

			end
		end
	end
end