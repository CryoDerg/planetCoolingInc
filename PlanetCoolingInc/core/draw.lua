function drawWorld()
	for x, vX in pairs(grid.tiles) do
		for y, vY in pairs(vX) do
			if tempOverlay then
				if vY.temp > 200 then
					love.graphics.setColor(vY.temp/800, vY.temp/3000, vY.temp/3000)
				elseif vY.temp > 25 then
					love.graphics.setColor(vY.temp/800, (215 - vY.temp) / 350, 0.2)
				else
					love.graphics.setColor(0.07, (215 - vY.temp) / 350, (70 - vY.temp) / 100)
				end
			else
				love.graphics.setColor(vY.temp/700, vY.temp/1000, 0.2)
				
			end
			if vY.update and showHotTiles then
				love.graphics.setColor(0,1,0)
			end
			if networkOverlay then
				if vY.onElectricNetwork then
					love.graphics.setColor(vY.onElectricNetwork/#electricNetworks.networks,vY.onElectricNetwork/#electricNetworks.networks,0)
				end
				if vY.onPipeNetwork then
					love.graphics.setColor(0,vY.onPipeNetwork/#pipeNetworks.networks,vY.onPipeNetwork/#pipeNetworks.networks)
				end
			end
			love.graphics.rectangle("fill", x*60, y*60, 60, 60)
		end
	end
end

function drawPlayer()
	love.graphics.setColor(0,0,1)
	love.graphics.circle("fill", player.x, player.y, 15)
end

function drawUI()
	if placingBuilding then
		constructionUI()
	end

	if contextMenu.isOpen then
		drawContextMenu()
	end
	drawBuildingUI()
end