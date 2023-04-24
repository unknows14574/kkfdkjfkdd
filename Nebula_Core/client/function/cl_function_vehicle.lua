Core.Vehicle = {}

--Delete Vehicle
Core.Vehicle.DeleteVehicule = function(vehicle, Persistent)
-- function DeleteVehicule(vehicle, NoPersistent)

	-- if Persistent then
	-- 	TriggerServerEvent('harybo_permanent:forget', Core.Math.Trim(GetVehicleNumberPlateText(vehicle)))
	-- 	Wait(50)
	-- end

	--SetVehicleHasBeenOwnedByPlayer(vehicle, false)

	SetEntityAsMissionEntity(vehicle, false, true)
	DeleteVehicle(vehicle)

	Wait(50)

	if DoesEntityExist(vehicle) then
		while not NetworkHasControlOfEntity(vehicle) do 
			NetworkRequestControlOfEntity(vehicle)
			Citizen.Wait(0)    
		end
		while not IsEntityAMissionEntity(vehicle) do 
			SetEntityAsMissionEntity(vehicle, false, true)
			Citizen.Wait(0)    
		end
		DeleteVehicle(vehicle)
		while DoesEntityExist(vehicle) do
			NetworkRequestControlOfEntity(vehicle)
			SetEntityAsMissionEntity(vehicle, false, true)
			DeleteVehicle(vehicle)
			Wait(50)
		end
	end
end

--Reparer Vehicule
Core.Vehicle.RepairVehicle = function(vehicle)
-- function RepairVehicle(vehicle)
	SetVehicleFixed(vehicle)
	SetVehicleDeformationFixed(vehicle)
	SetVehicleDirtLevel(vehicle, 0.0)
	SetVehicleFuelLevel(vehicle, 100.0)
	exports['Nebula_Fuel']:SetFuel(vehicle, 100.0)
	SetVehicleUndriveable(vehicle, false)
end

--Détection véhicule devant
Core.Vehicle.VehicleDetectInZone = function(radius)
-- function VehicleInFront(radius)
	local vehicle = GetVehiclePedIsIn(playerPed)
	if vehicle ~= 0 then
		return vehicle
	end
	local _, _, _, _, vehicle = GetShapeTestResult(StartShapeTestCapsule(GetEntityCoords(playerPed), GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 0.0), not radius and 3.0 or radius, 10, playerPed, 7))
	return vehicle
end

--FlipVehicle
Core.Vehicle.FlipVehicle = function(vehicle)
-- function FlipVehicle(vehicle)
	SetEntityCoords(vehicle, coords + vector3(0, 2, 0))
end

--GetVehicleProperties
Core.Vehicle.GetVehicleProperties = function(vehicle)
-- function GetVehicleProperties(vehicle)
	local color1, color2 = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	local extras = {}

	for id=0, 12 do
		if DoesExtraExist(vehicle, id) then
			local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
			extras[tostring(id)] = state
		end
	end

	local props = {
		model             = GetEntityModel(vehicle),

		plate             = Core.Math.Trim(GetVehicleNumberPlateText(vehicle)),
		plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

		health            = GetEntityHealth(vehicle),
		dirtLevel         = GetVehicleDirtLevel(vehicle),

		color1            = color1,
		color2            = color2,

		-- rgbcolor1 = {GetVehicleCustomPrimaryColour(vehicle)},
		-- rgbcolor2 = {GetVehicleCustomSecondaryColour(vehicle)},

		pearlescentColor  = pearlescentColor,
		wheelColor        = wheelColor,

		wheels            = GetVehicleWheelType(vehicle),
		windowTint        = GetVehicleWindowTint(vehicle),
		xenonColor        = GetVehicleXenonLightsColour(vehicle),

		neonEnabled       = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},

		extras            = extras,

		neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
		tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

		modSpoilers       = GetVehicleMod(vehicle, 0),
		modFrontBumper    = GetVehicleMod(vehicle, 1),
		modRearBumper     = GetVehicleMod(vehicle, 2),
		modSideSkirt      = GetVehicleMod(vehicle, 3),
		modExhaust        = GetVehicleMod(vehicle, 4),
		modFrame          = GetVehicleMod(vehicle, 5),
		modGrille         = GetVehicleMod(vehicle, 6),
		modHood           = GetVehicleMod(vehicle, 7),
		modFender         = GetVehicleMod(vehicle, 8),
		modRightFender    = GetVehicleMod(vehicle, 9),
		modRoof           = GetVehicleMod(vehicle, 10),

		modEngine         = GetVehicleMod(vehicle, 11),
		modBrakes         = GetVehicleMod(vehicle, 12),
		modTransmission   = GetVehicleMod(vehicle, 13),
		modHorns          = GetVehicleMod(vehicle, 14),
		modSuspension     = GetVehicleMod(vehicle, 15),
		modArmor          = GetVehicleMod(vehicle, 16),

		modTurbo          = IsToggleModOn(vehicle, 18),
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),
		modXenon          = IsToggleModOn(vehicle, 22),

		modFrontWheels    = GetVehicleMod(vehicle, 23),
		modBackWheels     = GetVehicleMod(vehicle, 24),

		modPlateHolder    = GetVehicleMod(vehicle, 25),
		modVanityPlate    = GetVehicleMod(vehicle, 26),
		modTrimA          = GetVehicleMod(vehicle, 27),
		modOrnaments      = GetVehicleMod(vehicle, 28),
		modDashboard      = GetVehicleMod(vehicle, 29),
		modDial           = GetVehicleMod(vehicle, 30),
		modDoorSpeaker    = GetVehicleMod(vehicle, 31),
		modSeats          = GetVehicleMod(vehicle, 32),
		modSteeringWheel  = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate         = GetVehicleMod(vehicle, 35),
		modSpeakers       = GetVehicleMod(vehicle, 36),
		modTrunk          = GetVehicleMod(vehicle, 37),
		modHydrolic       = GetVehicleMod(vehicle, 38),
		modEngineBlock    = GetVehicleMod(vehicle, 39),
		modAirFilter      = GetVehicleMod(vehicle, 40),
		modStruts         = GetVehicleMod(vehicle, 41),
		modArchCover      = GetVehicleMod(vehicle, 42),
		modAerials        = GetVehicleMod(vehicle, 43),
		modTrimB          = GetVehicleMod(vehicle, 44),
		modTank           = GetVehicleMod(vehicle, 45),
		modWindows        = GetVehicleMod(vehicle, 46),
		modLivery         = GetVehicleLivery(vehicle),

		interiorColor	  = GetVehicleInteriorColour(vehicle),
		locked = GetVehicleDoorLockStatus(vehicle),
		

		engine = GetIsVehicleEngineRunning(vehicle)
	}

	if props.locked <= 1 then
		props.locked = 1
	elseif props.locked >= 2 then
		props.locked = 2
	end

	for k, v in pairs(props) do
		if v == false or v == -1 then
			props[k] = nil
		end
	end

	return props
end

--SetVehicleProperties
Core.Vehicle.SetVehicleProperties = function(vehicle, props)
-- function SetVehicleProperties(vehicle, props)
	local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	SetVehicleModKit(vehicle, 0)

	if props.engine ~= nil then
		SetVehicleEngineOn(vehicle, props.engine, true, false)
	end

	if props.plate ~= nil then
		SetVehicleNumberPlateText(vehicle, props.plate)
	end

	if props.plateIndex ~= nil then
		SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
	end

	if props.health ~= nil then
		SetEntityHealth(vehicle, props.health)
	end

	if props.dirtLevel ~= nil then
		SetVehicleDirtLevel(vehicle, props.dirtLevel)
	end

	if props.color1 ~= nil then
		SetVehicleColours(vehicle, props.color1, colorSecondary)
	end

	if props.color2 ~= nil then
		SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2)
	end

	-- if props.rgbcolor1 then 
	-- 	SetVehicleCustomPrimaryColour(vehicle, props.rgbcolor1[1], props.rgbcolor1[2], props.rgbcolor1[3])
	-- end

	-- if props.rgbcolor2 then 
	-- 	SetVehicleCustomSecondaryColour(vehicle, props.rgbcolor2[1], props.rgbcolor2[2], props.rgbcolor2[3]) 
	-- end

	if props.pearlescentColor ~= nil then
		SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
	end

	if props.wheelColor ~= nil then
		SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor)
	end

	if props.wheels ~= nil then
		SetVehicleWheelType(vehicle, props.wheels)
	end

	if props.windowTint ~= nil then
		SetVehicleWindowTint(vehicle, props.windowTint)
	end

	if props.neonEnabled ~= nil then
		SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
		SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
		SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
		SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
	end

	if props.extras ~= nil then
		for id,enabled in pairs(props.extras) do
			if enabled then
				SetVehicleExtra(vehicle, tonumber(id), 0)
			else
				SetVehicleExtra(vehicle, tonumber(id), 1)
			end
		end
	end

	if props.neonColor ~= nil then
		SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
	end

	if props.xenonColor then 
		SetVehicleXenonLightsColour(vehicle, props.xenonColor) 
	end

	if props.modSmokeEnabled ~= nil and props.modSmokeEnabled then
		ToggleVehicleMod(vehicle, 20, true)
	else
		ToggleVehicleMod(vehicle, 20, false)
	end

	if props.tyreSmokeColor ~= nil then
		SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
	end

	if props.modSpoilers ~= nil then
		SetVehicleMod(vehicle, 0, props.modSpoilers, false)
	end

	if props.modFrontBumper ~= nil then
		SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
	end

	if props.modRearBumper ~= nil then
		SetVehicleMod(vehicle, 2, props.modRearBumper, false)
	end

	if props.modSideSkirt ~= nil then
		SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
	end

	if props.modExhaust ~= nil then
		SetVehicleMod(vehicle, 4, props.modExhaust, false)
	end

	if props.modFrame ~= nil then
		SetVehicleMod(vehicle, 5, props.modFrame, false)
	end

	if props.modGrille ~= nil then
		SetVehicleMod(vehicle, 6, props.modGrille, false)
	end

	if props.modHood ~= nil then
		SetVehicleMod(vehicle, 7, props.modHood, false)
	end

	if props.modFender ~= nil then
		SetVehicleMod(vehicle, 8, props.modFender, false)
	end

	if props.modRightFender ~= nil then
		SetVehicleMod(vehicle, 9, props.modRightFender, false)
	end

	if props.modRoof ~= nil then
		SetVehicleMod(vehicle, 10, props.modRoof, false)
	end

	if props.modEngine ~= nil then
		SetVehicleMod(vehicle, 11, props.modEngine, false)
	end

	if props.modBrakes ~= nil then
		SetVehicleMod(vehicle, 12, props.modBrakes, false)
	end

	if props.modTransmission ~= nil then
		SetVehicleMod(vehicle, 13, props.modTransmission, false)
	end

	if props.modHorns ~= nil then
		SetVehicleMod(vehicle, 14, props.modHorns, false)
	end

	if props.modSuspension ~= nil then
		SetVehicleMod(vehicle, 15, props.modSuspension, false)
	end

	if props.modArmor ~= nil then
		SetVehicleMod(vehicle, 16, props.modArmor, false)
	end

	if props.modTurbo ~= nil then
		ToggleVehicleMod(vehicle,  18, props.modTurbo)
	end

	if props.modXenon ~= nil then
		ToggleVehicleMod(vehicle,  22, props.modXenon)
	end

	if props.modFrontWheels ~= nil then
		SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
	end

	if props.modBackWheels ~= nil then
		SetVehicleMod(vehicle, 24, props.modBackWheels, false)
	end

	if props.modPlateHolder ~= nil then
		SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
	end

	if props.modVanityPlate ~= nil then
		SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
	end

	if props.modTrimA ~= nil then
		SetVehicleMod(vehicle, 27, props.modTrimA, false)
	end

	if props.modOrnaments ~= nil then
		SetVehicleMod(vehicle, 28, props.modOrnaments, false)
	end

	if props.modDashboard ~= nil then
		SetVehicleMod(vehicle, 29, props.modDashboard, false)
	end

	if props.modDial ~= nil then
		SetVehicleMod(vehicle, 30, props.modDial, false)
	end

	if props.modDoorSpeaker ~= nil then
		SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
	end

	if props.modSeats ~= nil then
		SetVehicleMod(vehicle, 32, props.modSeats, false)
	end

	if props.modSteeringWheel ~= nil then
		SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
	end

	if props.modShifterLeavers ~= nil then
		SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
	end

	if props.modAPlate ~= nil then
		SetVehicleMod(vehicle, 35, props.modAPlate, false)
	end

	if props.modSpeakers ~= nil then
		SetVehicleMod(vehicle, 36, props.modSpeakers, false)
	end

	if props.modTrunk ~= nil then
		SetVehicleMod(vehicle, 37, props.modTrunk, false)
	end

	if props.modHydrolic ~= nil then
		SetVehicleMod(vehicle, 38, props.modHydrolic, false)
	end

	if props.modEngineBlock ~= nil then
		SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
	end

	if props.modAirFilter ~= nil then
		SetVehicleMod(vehicle, 40, props.modAirFilter, false)
	end

	if props.modStruts ~= nil then
		SetVehicleMod(vehicle, 41, props.modStruts, false)
	end

	if props.modArchCover ~= nil then
		SetVehicleMod(vehicle, 42, props.modArchCover, false)
	end

	if props.modAerials ~= nil then
		SetVehicleMod(vehicle, 43, props.modAerials, false)
	end

	if props.modTrimB ~= nil then
		SetVehicleMod(vehicle, 44, props.modTrimB, false)
	end

	if props.modTank ~= nil then
		SetVehicleMod(vehicle, 45, props.modTank, false)
	end

	if props.modWindows ~= nil then
		SetVehicleMod(vehicle, 46, props.modWindows, false)
	end

	if props.modLivery ~= nil then
		SetVehicleMod(vehicle, 48, props.modLivery, false)
		SetVehicleLivery(vehicle, props.modLivery)
	end
	
	if props.interiorColor ~= nil then
		SetVehicleInteriorColour(vehicle, props.interiorColor)
	end

	if props.locked ~= nil then
		if props.locked <= 1 then
			props.locked = 1
			SetVehicleDoorsLockedForAllPlayers(vehicle, false)
		elseif props.locked >= 2 then
			props.locked = 2
			SetVehicleDoorsLockedForAllPlayers(vehicle, true)
		end
		SetVehicleDoorsLocked(vehicle, props.locked)
	end
end

--GetDamageVehicle
Core.Vehicle.GetDamageVehicle = function(veh)
	-- Rollup windows to avoid false positive when call IsVehicleWindowIntact
	for i = 0, 7, 1 do
		RollUpWindow(veh, i)		
	end
	local vehicle = {
		window = {
			[0] = IsVehicleWindowIntact(veh, 0),
			[1] = IsVehicleWindowIntact(veh, 1),
			[2] = IsVehicleWindowIntact(veh, 2),
			[3] = IsVehicleWindowIntact(veh, 3),
			[4] = IsVehicleWindowIntact(veh, 4),
			[5] = IsVehicleWindowIntact(veh, 5),
			[6] = IsVehicleWindowIntact(veh, 6),
			[7] = IsVehicleWindowIntact(veh, 7)
		},
		
		tyre = {
			[0] = IsVehicleTyreBurst(veh, 0, false),
			[1] = IsVehicleTyreBurst(veh, 1, false),
			[2] = IsVehicleTyreBurst(veh, 2, false),
			[3] = IsVehicleTyreBurst(veh, 3, false),
			[4] = IsVehicleTyreBurst(veh, 4, false),
			[5] = IsVehicleTyreBurst(veh, 5, false),
			[6] = IsVehicleTyreBurst(veh, 45, false),
			[7] = IsVehicleTyreBurst(veh, 47, false)
		},
		
		door = {
			[0] = IsVehicleDoorDamaged(veh, 0),
			[1] = IsVehicleDoorDamaged(veh, 1),
			[2] = IsVehicleDoorDamaged(veh, 2),
			[3] = IsVehicleDoorDamaged(veh, 3),
			[4] = IsVehicleDoorDamaged(veh, 4),
			[5] = IsVehicleDoorDamaged(veh, 5)
		},

		tank = GetVehiclePetrolTankHealth(veh),

		dirt = GetVehicleDirtLevel(veh),

		engine = GetVehicleEngineHealth(veh),

		body = GetVehicleBodyHealth(veh),

		fuel = GetVehicleFuelLevel(veh)
	}
	return vehicle
end

--SetVehicleDamage
Core.Vehicle.SetVehicleDamage = function(veh, damage)
-- function SetVehicleDamage(veh, damage)
	if damage.window ~= nil then
		for k, v in pairs(damage.window) do
			if not v then
				SmashVehicleWindow(veh, tonumber(k))
			end
		end
	end
	   
	if damage.tyre ~= nil then
		for k, v in pairs(damage.tyre) do
			if v then
				SetVehicleTyreBurst(veh, tonumber(k), true, 1000)
			end
		end       
	end

	if damage.door ~= nil then
		for k, v in pairs(damage.door) do
			if v then
				SetVehicleDoorBroken(veh, tonumber(k), true)
			end
		end 
   	end 

	if damage.tank ~= nil then
		SetVehiclePetrolTankHealth(veh, damage.tank)
	end

	if damage.dirt ~= nil then
		SetVehicleDirtLevel(veh, damage.dirt)
	end

	if damage.engine ~= nil then
		SetVehicleEngineHealth(veh, damage.engine)
	end

	if damage.body ~= nil then
		SetVehicleBodyHealth(veh, damage.body)
	end

	if damage.fuel ~= nil then
		SetVehicleFuelLevel(veh, damage.fuel)
		exports['Nebula_Fuel']:SetFuel(veh, damage.fuel)
	end
end

--SpawnVehicle
Core.Vehicle.SpawnVehicle = function(modelName, coords, properties, damage, instance)
-- function SpawnVehicle(modelName, coords, properties, damage, instance)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
	Core.Object.ChargerModel(model)

	if coords.h == nil then
		coords.h = 0
	end
	local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.h, ((instance == nil and true) or false), false)

	while vehicle == nil do
		Wait(100)
	end

	if coords.r then
		SetEntityRotation(vehicle, coords.r.x, coords.r.y, coords.r.z, 1, true)
	end

	local foundGround, newz = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)
	while GetDistanceBetweenCoords(GetEntityCoords(vehicle), coords.x, coords.y, ((foundGround and newz + 0.6) or coords.z + 0.1)) > 1.2 do
		SetEntityCoords(vehicle, coords.x, coords.y, ((foundGround and newz + 0.6) or coords.z + 0.1))
		Wait(150)
	end

	
	SetEntityAsMissionEntity(vehicle, true, false)
	SetVehicleHasBeenOwnedByPlayer(vehicle, true)
	SetVehicleNeedsToBeHotwired(vehicle, false)
	SetModelAsNoLongerNeeded(model)
	SetVehRadioStation(vehicle, 'OFF')
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)

	SetVehicleOnGroundProperly(vehicle)

	SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(vehicle), true)

	if properties then
		Core.Vehicle.SetVehicleProperties(vehicle, properties)
	end
	if damage then
		Core.Vehicle.SetVehicleDamage(vehicle, damage)
	end

	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	local limit = 1
	while (not HasCollisionLoadedAroundEntity(vehicle) or not IsVehicleModLoadDone(vehicle)) and limit < 4000 do
		Wait(1)
		limit = limit + 1
		if limit == 4000 then
			DeleteEntity(vehicle)
		end
	end

	RealistSpeed(vehicle)

	return vehicle
end

--Retourne tout les véhicules
Core.Vehicle.GetVehicles = function()
-- function GetVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

--Retourne tout les véhicules de la zone défini
Core.Vehicle.GetVehiclesInArea = function(coords, area)
-- function GetVehiclesInArea(coords, area)
	local vehiclesInArea = {}

	for k, result in pairs(Core.Vehicle.GetVehicles()) do
		local vehicleCoords = GetEntityCoords(result)
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(vehiclesInArea, result)
		end
	end

	return vehiclesInArea
end

-- Verif si vehicle exist dans une zone
Core.Vehicle.GetDuplicateVehicleCloseby = function(plate, coords, area)
-- function GetDuplicateVehicleCloseby(plate, coords, area)
	local vehicles = Core.Vehicle.GetVehiclesInArea(coords, area)
	for i, v in ipairs(vehicles) do
		if Core.Math.Trim(GetVehicleNumberPlateText(v)) == plate then
			return v
		end
	end
	return false
end

-- Verif si vehicle exist
Core.Vehicle.IsDuplicateVehicle = function(plate, entity)
-- function IsDuplicateVehicle(plate, entity)
	-- if entity ~= nil and DoesEntityExist(entity) then
	-- 	return entity
	-- end 
	
	plate = Core.Math.Trim(plate)
	for vehicle in EnumerateVehicles() do
		if Core.Math.Trim(GetVehicleNumberPlateText(vehicle)) == plate then
			-- print("exist plate")
			return vehicle
		end
	end
	return false
end



-- Get des roues à proximité du ped
Core.Vehicle.GetClosestVehicleTire = function(vehicle)
-- function GetClosestVehicleTire(vehicle)
	local tireIndex = {
		["wheel_lf"] = 0,
		["wheel_rf"] = 1,
		["wheel_lm1"] = 2,
		["wheel_rm1"] = 3,
		["wheel_lm2"] = 45,
		["wheel_rm2"] = 47,
		["wheel_lm3"] = 46,
		["wheel_rm3"] = 48,
		["wheel_lr"] = 4,
		["wheel_rr"] = 5,
	}
	local closestTire = nil

	for k, v in pairs(tireIndex) do
		local bonePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, k))
		local distance = Vdist(coords.x, coords.y, coords.z, bonePos.x, bonePos.y, bonePos.z)

		if closestTire == nil then
			if distance <= 1.0 then
				closestTire = {boneDist = distance, bonePos = bonePos, tireIndex = v}
			end
		else
			if distance < closestTire.boneDist then
				closestTire = {boneDist = distance, bonePos = bonePos, tireIndex = v}
			end
		end
	end

	return closestTire
end
