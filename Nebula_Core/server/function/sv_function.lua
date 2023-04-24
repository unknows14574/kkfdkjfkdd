-- Récupère les coordonnées d'une target définie. 
RegisterServerCallback('Core:CoordsTarget', function(source, cb, target)
    cb(GetEntityCoords(GetPlayerPed(target)))
end)

-- Procéssus de téléportation sur joueur ou sur target.
RegisterServerEvent('Core:BringPlayer')
AddEventHandler('Core:BringPlayer', function(Target, Coords)
    TriggerClientEvent('Core:Teleport', Target, Coords)
end)

RegisterServerEvent('Core:GoToPlayer')
AddEventHandler('Core:GoToPlayer', function(Target)
    TriggerClientEvent('Core:Teleport', source, GetEntityCoords(GetPlayerPed(Target)))
end)

-- Récupère les données pour la modération
RegisterServerCallback('Core:GetPlayersInfos', function(source, cb, PlayerId)
    local playerPed = GetPlayerPed(PlayerId)
    local data = {
        ping = GetPlayerPing(PlayerId),
        health = GetEntityHealth(playerPed),
        maxhealth = GetEntityMaxHealth(playerPed),
        armor = GetPedArmour(playerPed)
    }

    print(data.ping, data.health, data.maxhealth, data.armor)

    cb(data)
end)

--Prise/Fin de Service
RegisterServerEvent('Core:SetServiceJobPlayer')
AddEventHandler('Core:SetServiceJobPlayer', function(PlayerId, Job, InService)
	local xPlayer = ESX.GetPlayerFromId((not PlayerId and source) or PlayerId)

    if Job == "job" then
        if not InService then
            if xPlayer.job.service == 1 then
                InService = 0
            else
                InService = 1
            end
        end
        xPlayer.setService(xPlayer.job.name, InService)
        SetService(xPlayer.source, xPlayer.job.name, InService)
    elseif Job == "job2" then
        if not InService then
            if xPlayer.job2.service == 1 then
                InService = 0
            else
                InService = 1
            end
        end
        xPlayer.setService(xPlayer.job2.name, InService)
        SetService(xPlayer.source, xPlayer.job2.name, InService)
    end

	if InService == 1 then
		TriggerClientEvent('Core:ShowNotification', xPlayer.source,"~h~Vous êtes maintenant en service!", true, false, 210)
	else
		TriggerClientEvent('Core:ShowNotification', xPlayer.source,"~h~Vous êtes maintenant hors service.", true, false, 130)
	end
end)

--SetJob
RegisterServerEvent('Core:SetJob')
AddEventHandler('Core:SetJob', function(PlayerId, Job, JobName, Grade, LastJob)
	local xPlayer = ESX.GetPlayerFromId((not PlayerId and source) or PlayerId)

    if Job == "job" then
        xPlayer.setJob(JobName, Grade)
        SetJob(xPlayer.source, JobName, LastJob)
    elseif Job == "job2" then
        xPlayer.setJob2(JobName, Grade) 
        SetJob2(xPlayer.source, JobName, LastJob)
    end
    TriggerClientEvent('Core:ShowNotification', xPlayer.source,"~h~Vous êtes maintenant ~b~" .. JobName, true, false, 140)
end)

RegisterServerEvent('Core:ChangeInfoPlayerBDD')
AddEventHandler('Core:ChangeInfoPlayerBDD', function(PlayerId, NameValue, Value)
	local xPlayer = ESX.GetPlayerFromId((not PlayerId and source) or PlayerId)
end)

RegisterServerEvent("Core:CreverPneuServer")
AddEventHandler("Core:CreverPneuServer", function(client, tireIndex)
	TriggerClientEvent("Core:CreverPneu", client, tireIndex)
end)


function DistanceBetweenCoords(coordsA, coordsB)
	return #(vector3(coordsA.x, coordsA.y, coordsA.z).xy - vector3(coordsB.x, coordsB.y, coordsB.z).xy)
end

function DistanceFrom(x1, y1, z1, x2, y2, z2)
    return  math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
end
