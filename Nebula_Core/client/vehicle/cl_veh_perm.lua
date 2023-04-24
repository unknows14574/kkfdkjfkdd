-- RegisterNetEvent('persistent-vehicles/register-vehicle')
-- AddEventHandler('persistent-vehicles/register-vehicle', function (entity, light, forgetAfter)
-- 	local props = Core.Vehicle.GetVehicleProperties(entity, light)
-- 	props.damage = Core.Vehicle.GetDamageVehicle(entity)
-- 	local netid = NetworkGetNetworkIdFromEntity(entity)
-- 	SetNetworkIdAlwaysExistsForPlayer(netid, PlayerId(), true)
-- 	if forgetAfter ~= nil then
-- 		forgetAfter = forgetAfter * 1000
-- 	end
-- 	TriggerServerEvent('persistent-vehicles/server/register-vehicle', netid, props, GetTrailer(entity), forgetAfter)
-- end)

-- RegisterNetEvent('persistent-vehicles/update-vehicle')
-- AddEventHandler('persistent-vehicles/update-vehicle', function (entity, light, forgetAfter)
-- 	local props = Core.Vehicle.GetVehicleProperties(entity, light)
-- 	props.damage = Core.Vehicle.GetDamageVehicle(entity)
-- 	if forgetAfter ~= nil then
-- 		forgetAfter = forgetAfter * 1000
-- 	end
-- 	TriggerServerEvent('persistent-vehicles/server/update-vehicle', props.plate, props, GetTrailer(entity), forgetAfter)
-- end)

-- RegisterNetEvent('persistent-vehicles/forget-vehicle')
-- AddEventHandler('persistent-vehicles/forget-vehicle', function (entity)
-- 	TriggerServerEvent('persistent-vehicles/server/forget-vehicle', Core.Math.Trim(GetVehicleNumberPlateText(entity)))
-- end)

-- RegisterNetEvent('persistent-vehicles/update-vehicle-ped-is-in')
-- AddEventHandler('persistent-vehicles/update-vehicle-ped-is-in', function (currentVeh, light)
-- 	if currentVeh > 0 then
-- 		local props = Core.Vehicle.GetVehicleProperties(currentVeh, light)
-- 		props.damage = Core.Vehicle.GetDamageVehicle(currentVeh)
-- 		TriggerServerEvent('persistent-vehicles/server/update-vehicle', props.plate, props, GetTrailer(currentVeh))
-- 	end
-- end)

-- RegisterNetEvent('persistent-vehicles/spawn-vehicles')
-- AddEventHandler('persistent-vehicles/spawn-vehicles', function (vehicles)
-- 	local updatedNetIds = {}
-- 	for i, vehicle in pairs(vehicles) do
-- 	-- for i = 1, #vehicles do
-- 	-- 	local vehicle = vehicles[i]

-- 		-- sometimes onesync reports wrong player cords on server. And sometimes pos is nil from server not getting to update position in time
-- 		if vehicle.pos and Config.VehiclePerm.respawnDistance < Core.Pos.DistanceBetweenCoords(coords, vehicle.pos) then
-- 			return
-- 		end

-- 		-- clientside vehicle dupe check
-- 		-- local possibleDuplicate = Core.Vehicle.IsDuplicateVehicle(vehicle.props.plate)
-- 		-- if possibleDuplicate then
-- 		-- 	entity = possibleDuplicate
-- 		--local entity = Core.Vehicle.IsDuplicateVehicle(vehicle.props.plate, (vehicle.netId ~= nil and NetworkDoesNetworkIdExist(vehicle.netId)) and NetworkGetEntityFromNetworkId(vehicle.netId) or nil)
-- 		local entity = Core.Vehicle.IsDuplicateVehicle(vehicle.props.plate, (vehicle.netId ~= nil and NetworkDoesNetworkIdExist(vehicle.netId)) and NetworkGetEntityFromNetworkId(vehicle.netId) or nil)
-- 		while entity == nil do
-- 			Wait(10)
-- 		end
		
-- 		if entity then
-- 			-- local foundGround, newz = GetGroundZFor_3dCoord(vehicle.pos.x, vehicle.pos.y, vehicle.pos.z)

-- 			-- while GetDistanceBetweenCoords(GetEntityCoords(entity), vehicle.pos.x, vehicle.pos.y, ((foundGround and newz + 0.6) or vehicle.pos.z + 0.1), true) > 1.2 do
-- 			-- 	SetEntityCoords(entity, vehicle.pos.x, vehicle.pos.y, vehicle.pos.z)
-- 			-- 	Wait(150)
-- 			-- end
-- 			table.insert(updatedNetIds, {netId = NetworkGetNetworkIdFromEntity(entity), plate = vehicle.props.plate})

-- 		elseif GetClosestVehicle(vehicle.pos.x, vehicle.pos.y, vehicle.pos.z, 1.2, 0, 71) == 0 then
-- 			local foundGround, newz = GetGroundZFor_3dCoord(vehicle.pos.x, vehicle.pos.y, vehicle.pos.z)
-- 			entity = Core.Vehicle.SpawnVehicle(vehicle.props.model, { x = vehicle.pos.x, y = vehicle.pos.y, z = ((foundGround and newz + 0.6) or vehicle.pos.z + 0.1), h = vehicle.pos.h}, vehicle.props, vehicle.props.damage)

-- 			-- throttle otherwise NetworkGetNetworkIdFromEntity fails more often
-- 			while entity == nil do
-- 				Wait(50)
-- 			end

-- 			local netid = NetworkGetNetworkIdFromEntity(entity)
			
-- 			-- one last check to ensure we have a valid netid
-- 			if NetworkDoesEntityExistWithNetworkId(netid) then
-- 				while GetDistanceBetweenCoords(GetEntityCoords(entity), vehicle.pos.x, vehicle.pos.y, ((foundGround and newz + 0.6) or vehicle.pos.z + 0.1), true) > 1.2 do
-- 					SetEntityCoords(entity, vehicle.pos.x, vehicle.pos.y, vehicle.pos.z)
-- 					Wait(150)
-- 				end

-- 				if vehicle.trailer then
-- 					local trailerEntity = NetworkGetEntityFromNetworkId(vehicle.trailer.netId)
-- 					if trailerEntity == 0 then
-- 						trailerEntity = Core.Vehicle.SpawnVehicle(vehicle.trailer.model, { x = vehicle.pos.x, y = vehicle.pos.y, z = vehicle.pos.z})

-- 						while trailerEntity == nil do
-- 							Wait(50)
-- 						end

-- 						while not IsVehicleAttachedToTrailer(entity) do
-- 							AttachVehicleToTrailer(entity, trailerEntity, 1.0)
-- 							Wait(150)
-- 						end
-- 					end
-- 				end
-- 				table.insert(updatedNetIds, {netId = netid, plate = vehicle.props.plate})
-- 			else
-- 				DeleteEntity(entity)
-- 			end
-- 		end
-- 	end
-- 	if updatedNetIds[1] ~= nil then
-- 		TriggerServerEvent('persistent-vehicles/done-spawning', updatedNetIds)
-- 	end
-- end)

-- RegisterNetEvent('persistent-vehicles/delete-vehicles')
-- AddEventHandler('persistent-vehicles/delete-vehicles', function (Table)
-- 	for vehicle in EnumerateVehicles() do
-- 		for k, result in pairs(Table) do
-- 			if result.entity == vehicle and GetHashKey(GetEntityModel(vehicle)) == GetHashKey(GetEntityModel(result.hash)) and Core.Math.Trim(GetVehicleNumberPlateText(vehicle)) == Core.Math.Trim(result.plate) and Core.Pos.DistanceBetweenCoords(result.pos, GetEntityCoords(vehicle)) > 0.5 then
-- 				Core.Vehicle.DeleteVehicule(vehicle, true)
-- 				break
-- 			end
-- 		end
-- 	end
-- end)

-- function GetTrailer(entity)
-- 	local trailer = nil
-- 	local hasTrailer, trailerEntity = GetVehicleTrailerVehicle(entity)
-- 	if hasTrailer  then
-- 		local trailerNetId = NetworkGetNetworkIdFromEntity(trailerEntity)
-- 		trailer = {model = GetEntityModel(trailerEntity), netId = trailerNetId}
-- 		SetNetworkIdExistsOnAllMachines(trailerNetId, true)
-- 	end
-- 	return trailer
-- end

-- function ExitVehicle()
-- 	if currentVeh > 0 and GetPedInVehicleSeat(currentVeh, -1) then
-- 		local netid = NetworkGetNetworkIdFromEntity(currentVeh)
-- 		if NetworkDoesEntityExistWithNetworkId(netid) then
-- 			SetNetworkIdAlwaysExistsForPlayer(netid, PlayerId(), true)
-- 			local props = Core.Vehicle.GetVehicleProperties(currentVeh, light)
-- 			props.damage = Core.Vehicle.GetDamageVehicle(currentVeh)
-- 			TriggerServerEvent('persistent-vehicles/server/save-pos-vehicle', netid, props, GetTrailer(ActualIdVehicle), GetEntityCoords(currentVeh), GetEntityHeading(currentVeh), GetEntityRotation(currentVeh))
-- 		end
-- 		return
-- 	else
-- 		local ActualIdVehicle = GetLastDrivenVehicle()
-- 		if ActualIdVehicle > 0 and Config.VehiclePerm.LastIdVehicle ~= ActualIdVehicle then
-- 			local netid = NetworkGetNetworkIdFromEntity(ActualIdVehicle)
-- 			if NetworkDoesEntityExistWithNetworkId(netid) then
-- 				Config.VehiclePerm.LastIdVehicle = ActualIdVehicle
-- 				SetNetworkIdAlwaysExistsForPlayer(netid, PlayerId(), true)
-- 				local props = Core.Vehicle.GetVehicleProperties(ActualIdVehicle, light)
-- 				props.damage = Core.Vehicle.GetDamageVehicle(ActualIdVehicle)
-- 				TriggerServerEvent('persistent-vehicles/server/save-pos-vehicle', netid, props, GetTrailer(ActualIdVehicle), GetEntityCoords(ActualIdVehicle), GetEntityHeading(ActualIdVehicle), GetEntityRotation(ActualIdVehicle))
-- 			end
-- 			return
-- 		end
-- 	end
-- end

