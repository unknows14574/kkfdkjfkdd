local DoorInfo	= {}

RegisterServerEvent('esx_doorlock:updateState')
AddEventHandler('esx_doorlock:updateState', function(doorID, state)
	DoorInfo[doorID] = state

	TriggerClientEvent('esx_doorlock:setState', -1, doorID, state)
end)

RegisterServerCallback('esx_doorlock:getDoorInfo', function(source, cb)
	cb(DoorInfo)
end)

RegisterServerCallback('esx_doorlock:GetSteamAllowed', function(source, cb)
	cb(GetPlayerIdentifier(source))
end)