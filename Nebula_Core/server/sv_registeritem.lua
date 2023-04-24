-- FireWork
ESX.RegisterUsableItem('trailburst', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('fireworks:use', source, 'trailburst')
	xPlayer.removeInventoryItem('trailburst', 1)
end)

ESX.RegisterUsableItem('fountain', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('fireworks:use', source, 'fountain')
	xPlayer.removeInventoryItem('fountain', 1)
end)

ESX.RegisterUsableItem('shotburst', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('fireworks:use', source, 'shotburst')
	xPlayer.removeInventoryItem('shotburst', 1)
end)

ESX.RegisterUsableItem('starburst', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('fireworks:use', source, 'starburst')
	xPlayer.removeInventoryItem('starburst', 1)
end)