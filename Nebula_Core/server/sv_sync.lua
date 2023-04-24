-- FireWork
RegisterServerEvent("syncbad")
AddEventHandler("syncbad", function(propFireWorks)
	for k, v in pairs(propFireWorks) do
		TriggerClientEvent("syncbad_cl", source, v, k)
	end
end)

--CarryPeople
RegisterServerEvent('carrypeople:sync')
AddEventHandler('carrypeople:sync', function(offon, target)
	TriggerClientEvent('carrypeople:syncTarget', target, source, offon)
end)

--Porter dans les bras
RegisterServerEvent('lyftupp:sync')
AddEventHandler('lyftupp:sync', function(offon, target)
	TriggerClientEvent('lyftupp:syncTarget', target, source, offon)
end)

--Porter sur le dos
RegisterServerEvent('piggyback:sync')
AddEventHandler('piggyback:sync', function(offon, target)
	TriggerClientEvent('piggyback:syncTarget', target, source, offon)
end)

--Prendre en hotage
RegisterServerEvent('takehostage:sync')
AddEventHandler('takehostage:sync', function(offon, target, dict, anim)
	TriggerClientEvent('takehostage:syncTarget', target, source, offon, dict, anim)
end)

--Claque
RegisterServerEvent('claque:sync')
AddEventHandler('claque:sync', function(target)
	TriggerClientEvent('claque:syncTarget', target)
	TriggerClientEvent('claque:son', -1, GetEntityCoords(GetPlayerPed(target)))
end)