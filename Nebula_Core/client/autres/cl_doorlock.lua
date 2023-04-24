function OnSpawnDoorLock()
	TriggerServerCallback('esx_doorlock:getDoorInfo', function(doorInfo)
		for k, v in pairs(doorInfo) do
			if k ~= nil then
				iV.Zones[k].Action.locked = v
			end
		end
	end)
	for k, v in pairs(iV.Zones)do
		if v.TypeZone.Name == "DoorLock" then
			DoorLock({ Pos = v.Pos, Name = v.name, Action = { locked = v.Action.locked } })
		end
	end
end

function ChangeStateDoor(Table)
	if Table.Action.job then
		for k, v in pairs(Table.Action.job) do
			if PlayerData.job.name == v or PlayerData.job2.name == v then
				DoorLock(Table)
				TriggerServerEvent('esx_doorlock:updateState', Table.NumLine, not Table.Action.locked)
			end
		end
	elseif Table.Action.steam then
		for k, v in pairs(Table.Action.steam) do
			TriggerServerCallback('esx_doorlock:GetSteamAllowed', function(identifier)
				if identifier == v then
					DoorLock(Table)
					TriggerServerEvent('esx_doorlock:updateState', Table.NumLine, not Table.Action.locked)
				end
			end)
		end
	end
end

function DoorLock(doorID)
	FreezeEntityPosition(GetClosestObjectOfType(doorID.Pos.x, doorID.Pos.y, doorID.Pos.z, 1.0, type(doorID.Name) == 'number' and doorID.Name or GetHashKey(doorID.Name), false, false, false), doorID.Action.locked)
end

function CheckDoorLock()
	for k, v in pairs(iV.Zones) do
		if v.TypeZone.Name == "DoorLock" and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) <= v.TypeZone.DrawDistance.DrawDistance then
			DoorLock({ Name = iV.Zones[k].name, Pos = iV.Zones[k].Pos, Action = iV.Zones[k].Action})
		end
	end
end

RegisterNetEvent('esx_doorlock:setState')
AddEventHandler('esx_doorlock:setState', function(doorID, state)
	iV.Zones[doorID].Action.locked = state
	Infos = nil
end)