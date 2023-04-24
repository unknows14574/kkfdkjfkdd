fx_version 'cerulean'
games { 'gta5' }

author 'Nebula Dev Team'
description 'Nebula farm limitation'
Version  '1.0'


client_scripts { }

server_scripts {
	'server.lua',
	'config.lua'
}

server_export {
	'UserReachFarmLimitation',
	'UpdateUserAndRunValue'
}
