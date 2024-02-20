function boot()
	--Default Res
	gameWidth, gameHeight = 1200, 675

	--Load Graphics
	require("core/boot/initGraphics")
	graphicLoad()

	--Load Code
	require("core/boot/initCode")
	fileLoad()

	--Load Controls
	require("core/boot/controls")

	--Load Settings
	require("core/settingsConfig")
	settingsSetup()

	

	--Define Variables
	centerWidth = (windowWidth / 2)
	centerHeight = (windowHeight / 2)
	scale = math.min((windowWidth/gameWidth),(windowHeight/gameHeight))
	scaledWindowWidth = windowWidth * scale
	scaledWindowHeight = windowHeight * scale
	scaledCenterWidth = scaledWindowWidth / 2
	scaledCenterHeight = scaledWindowHeight / 2
	
	tempOverlay = false
	showHotTiles = false
	networkOverlay = false
	camX, camY = centerWidth, centerHeight
	runTime = 0
	gameTime = 0
	updateTime = 0
	randomUpdateTime = 0
	focusPointX = camX - centerWidth
	focusPointY = camY - centerHeight
	hoverInfo = ""
	clickedButton = {}

	gamestate = 0
	gridSize = 0
	buildingMenuOpen = false
	contextMenuOpen = false
	placingBuilding = false
	

	player = {
		x = 0,
		y = 0,
		speed = 100,
		temp = 0,
		heatCapacity = 50,
		conductivity = 0.5,
		health = 100,
		healthMax = 100,
		healthRegen = 0.1,
		isIdle = false,
		isMoving = false,
		hasContextMenu = false,
		moveInfo = {
			targetX = 0,
			targetY = 0,
			beginX = 0,
			beginY = 0,
			xDist = 0,
			yDist = 0,
			timeToMove = 0,
			timeElapsed = 0,
		},
	}
	selectBuilding = 1

end