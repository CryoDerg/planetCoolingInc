function fileLoad()
	require("core/draw/mainDraw")
	require("core/draw/uiDraw")

	require("core/interactUI/uiAction")

	require("core/worldTools/buildings")
	require("core/worldTools/buildWorld")
	require("core/worldTools/heatSimulation")
	require("core/worldTools/networkManager")
	require("core/worldTools/droneUtils")
	require("core/worldTools/itemManage")
	require("core/worldTools/droneManage")

	require("core/playerTools/movement")
	
	require("core/playerTools/ui/buildingUI")
	require("core/playerTools/ui/contextMenu")
	require("core/playerTools/ui/droneProgramUI")

	require("core/utils/debugTools")
	require("core/utils/mathFunctions")
	require("core/utils/tableFunctions")
	require("core/utils/inGameMessage")

end