fx_version 'bodacious'
games { 'gta5' }

name "Police Backups"
description "Police Backups"
author "xPiwel"
version "1.0"

lua54 'yes'

client_scripts {
	--RageUI
	"RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",

    "RageUI/components/Audio.lua",
    "RageUI/components/Enum.lua",
    "RageUI/components/Keys.lua",
    "RageUI/components/Rectangle.lua",
    "RageUI/components/Sprite.lua",
    "RageUI/components/Text.lua",
    "RageUI/components/Visual.lua",

    "RageUI/menu/elements/ItemsBadge.lua",
    "RageUI/menu/elements/ItemsColour.lua",
    "RageUI/menu/elements/PanelColour.lua",

    "RageUI/menu/items/UIButton.lua",
    "RageUI/menu/items/UICheckBox.lua",
    "RageUI/menu/items/UIList.lua",
    "RageUI/menu/items/UIProgress.lua",
    "RageUI/menu/items/UISeparator.lua",
    "RageUI/menu/items/UISlider.lua",
    "RageUI/menu/items/UISliderHeritage.lua",
    "RageUI/menu/items/UISliderProgress.lua",

    "RageUI/menu/panels/UIButtonPanel.lua",
    "RageUI/menu/panels/UIColourPanel.lua",
    "RageUI/menu/panels/UIGridPanel.lua",
    "RageUI/menu/panels/UIPercentagePanel.lua",
	"RageUI/menu/panels/UIStatisticsPanel.lua",
	
	"RageUI/menu/windows/UIHeritage.lua",
	
	--main
    "client/cl_esx.lua",

	"client/cl_menu.lua",
    "client/cl_functions.lua",
    "client/cl_events.lua"
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    "server/sv_esx.lua",
	"server/sv_functions.lua",
	"server/sv_events.lua"
}

dependency '/assetpacks'