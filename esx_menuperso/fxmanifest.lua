fx_version 'cerulean'
games { 'gta5' }
description "Menu Perso No Brain"

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- nb_menuperso
---------------------------------------------------------------------------------------------------------------------------------------------------------
client_script 'config.lua'
client_script 'keycontrol.lua'
client_script 'client.lua'
--client_script 'handsup.lua'
--client_script 'pointing.lua'
--client_script 'crouch.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server.lua'
}