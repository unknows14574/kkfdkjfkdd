fx_version 'cerulean'
games { 'gta5' }"44febabe-d386-4d18-afbe-5e627f4af937"

lua54 'yes'

server_scripts {
  "config.lua",
  "server/server.lua"
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

    "config.lua",
    "client/client.lua"
}

escrow_ignore {
    "config.lua"
}
dependency '/assetpacks'