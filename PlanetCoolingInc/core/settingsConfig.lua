function settingsSetup()
	settings = {}
	settings.defaults = {
		fullscreenState = false,
		controls = {
			genWorld = "g",
			toggleTempOverlay = "t",
			toggleNetworkOverlay = "x",
			placeBuilding = "M1",
			openContextMenu = "M2"
		}
	}

	print(love.filesystem.getInfo("settings.txt"))
	if love.filesystem.getInfo("settings.txt") then
		settingsValues = love.filesystem.read("settings.txt")

		local function findSetting(term)
			local s, e = string.find(settingsValues, term)
			local s, e = string.find(settingsValues, "%b[]", e)
			state = string.sub(settingsValues, s+1, e-1)
			return state
		end

		local function toBool(str)
			return str == "true"
		end

		settings.fullscreenState = toBool(findSetting("fullscreenState"))
		settings.controls = configControls(stringToTable(findSetting("controls")))
	else
		firstPlay = true

		settingDefaults()

		settingsValues = love.filesystem.newFile("settings.txt")
		settingsValues:open("w")

	end

	saveSettings()
	
end

--[[
List of Settings:
  Fullscreen (True/False) Default:False
  Hover Text (True/False) Default:True
  Hover Text Delay (0s-5s) Default:0s
	


  Default Controls (Will be updated):
    Gen World: g
    Toggle Temp Overlay: t
    Toggle Network Overlay: x
    Place Building: M1
    Open Context Menu: M2


        
        

]]


function settingDefaults()
	settings.fullscreenState = settings.defaults.fullscreenState
	settings.controls = configControls(nil)
end

function saveSettings()
	checkFullscreen()
	
	--Save Fullscreen State
	love.filesystem.write("settings.txt", "fullscreenState = ["..tostring(settings.fullscreenState).."]\n")

	--Save Controls
	love.filesystem.append("settings.txt", "controls = ["..tableToString(settings.controls).."]\n")



end

function checkFullscreen()
	if settings.fullscreenState then
		love.window.setFullscreen(settings.fullscreenState)
	else
		love.window.setMode(gameWidth, gameHeight)
	end

	windowWidth, windowHeight = love.window.getMode()
	centerWidth = (windowWidth / 2)
	centerHeight = (windowHeight / 2)
	--scale = math.min((windowWidth/gameWidth),(windowHeight/gameHeight))
end
