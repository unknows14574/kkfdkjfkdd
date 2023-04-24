fx_version 'bodacious'
games { 'gta5' }

name "Core"
description "Core by Neb dev's"
author "Nebula dev's Initially Harybo"
version "1.0"

shared_scripts {
	"config/cf_main.lua",
	"config/cf_pos.lua",
	"config/cf_moderation.lua",
	"config/cf_vehicle.lua",
	"config/cf_sitonprops.lua",
	"shared/sh_callback.lua",
	"shared/function/sh_function_math.lua"
}

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
	
	"client/entityiter.lua",

	--main
	"client/cl_main.lua",
	"client/cl_callback.lua",
	"client/cl_pos.lua",
	"client/function/cl_function_main.lua",
	"client/function/cl_function_vehicle.lua",

	--main
	
	
	

	--animation
	"client/animation/cl_animation.lua",

	--useObject
	"client/useObject/cl_firework.lua",

	--autres
	"client/autres/cl_bazard.lua",
	"client/autres/cl_doorlock.lua",
	"client/autres/cl_contrib.lua",
	"client/autres/cl_discord.lua",

	--vehicle
	"client/vehicle/function/cl_function_vehicle.lua",
	"client/vehicle/cl_garage.lua",
	"client/vehicle/cl_vehicle.lua",
	--"client/vehicle/cl_veh_perm.lua",

	--moderation
	"client/moderation/cl_spectate.lua",
	"client/moderation/cl_showname.lua",
	"client/moderation/cl_menumoderation.lua",

	--sitonprops
	"client/sitonprops/cl_sitonprops.lua",
}

ui_page {
	'html/index.html'
}

files {
	'html/index.html',
	'html/css/main.css',
	'html/scripts/app.js',
	'html/img/cinematique.png',
	'html/sound/Giffle.ogg',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"server/sv_callback.lua",
	"server/function/sv_function.lua",
	"server/sv_cron.lua",
	"server/sv_main.lua",
	"server/sv_command.lua",
	"server/sv_registeritem.lua",
	"server/sv_sync.lua",
	"server/sv_garage.lua",
	--"server/sv_veh_perm.lua",
	"server/sv_bazard.lua",
	"server/sv_doorlock.lua",
	"server/sv_discord.lua",
	"server/sv_contrib.lua",
	"server/sv_counter.lua",
}

server_export "DiscordIsRolePresent"
server_export "DiscordGetRoles"


