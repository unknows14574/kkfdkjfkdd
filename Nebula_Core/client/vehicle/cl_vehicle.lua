--NotShuffle
function NotShuffle(vehicle)
	if GetIsTaskActive(playerPed, 165) then
		SetPedIntoVehicle(playerPed, vehicle, 0)
	end
end

--RealistSpeed
ClassesVehicle = {
	["Compacts"] = {id = 0, multiplier = 2.5}, 
	["Sedans"] = {id = 1, multiplier = 2.5},  
	["SUVs"] = {id = 2, multiplier = 2.5},  
	["Coupes"] = {id = 3, multiplier = 2.5}, 
	["Muscle"] = {id = 4, multiplier = 15.0}, 
	["SportsClassic"] = {id = 5, multiplier = 15.0},  
	["Sports"] = {id = 6, multiplier = 24.0},  
	["Super"] = {id = 7, multiplier = 70.0}, 
	["Motorcycles"] = {id = 8, multiplier = 16.0}, 
	["OffRoad"] = {id = 9, multiplier = 15.0}, 
	["Industrial"] = {id = 10, multiplier = 0}, 
	["Utility"] = {id = 11, multiplier = 0}, 
	["Vans"] = {id = 12, multiplier = 0},  
	["Cycles"] = {id = 13, multiplier = 0}, 
	["Boats"] = {id = 14, multiplier = 0}, 
	["Helicopters"] = {id = 15, multiplier = 0},
	["Planes"] = {id = 16, multiplier = 0},
	["Service"] = {id = 17, multiplier = 0},
	["Emergency"] = {id = 18, multiplier = 18.75},
	["Military"] = {id = 19, multiplier = 0},
	["Commercial"] = {id = 20, multiplier = 16.0},
	["Trains"] = {id = 21, multiplier = 0}
}

NameItemVehicle = {
	Moteur = {"Origine", "Niveau 1", "Niveau 2", "Niveau 3", "Niveau 4"},
	Frein = {"Origine", "Rue", "Sport", "Course"},
	Suspension = {"Origine", "Rue", "Sport", "Course", "Compétition"},
	Transmission = {"Origine", "Rue", "Sport", "Course"}
}

local VehicleModifSpeed = {
	["notmodif"] = {'charger', 'polexp20', 'polaventa'}, 
	["mustang19"] = 30.0,
	["dominator3"] = 40.0,
}

local veh_turbo = 0
local veh_drift = 0
RegisterNetEvent('esx_realistspeed:turbo')
AddEventHandler('esx_realistspeed:turbo', function(vehUse)
	veh_turbo = vehUse
end)

RegisterNetEvent('esx_realistspeed:drift')
AddEventHandler('esx_realistspeed:drift', function(vehUse)
	veh_drift = vehUse
end)

RegisterNetEvent('esx_realistspeed:nitro')
AddEventHandler('esx_realistspeed:nitro', function(vehUse)
	veh_drift = vehUse
end)

RegisterNetEvent('esx_realistspeed:realistSpeed')
AddEventHandler('esx_realistspeed:realistSpeed', function(vehUse)
	RealistSpeed(vehUse)
end)

function RealistSpeed(vehicle)
	if vehicle ~= veh_turbo then
		local entitymodel = GetEntityModel(vehicle)
		for m, l in pairs(VehicleModifSpeed["notmodif"]) do
			if entitymodel ~= GetHashKey(l) then
				for f, x in pairs(VehicleModifSpeed) do
					if entitymodel == GetHashKey(f) then
						ModifyVehicleTopSpeed(vehicle, x)
						break
					end
				end
				for k, v in pairs(ClassesVehicle) do
					if GetVehicleClass(vehicle) == v.id then
						ModifyVehicleTopSpeed(vehicle, v.multiplier)
						break
					end
				end
			end
		end
	end
end

--VehicleLock
RegisterNetEvent('Nebula_Core:LockVeh')
AddEventHandler('Nebula_Core:LockVeh', function()
	OpenCloseVehicle()
end)

function OpenCloseVehicle()
	local VehUse = Core.Vehicle.VehicleDetectInZone(6.0)
	if VehUse ~= 0 then
		Core.Object.ChargeAnimDict("anim@mp_player_intmenu@key_fob@")
		TaskPlayAnim(playerPed, "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
		TriggerServerCallback('Core:requestPlayerCars', function(isOwnedVehicle)
			if isOwnedVehicle then
				local locked = GetVehicleDoorLockStatus(VehUse)
				if locked <= 1 then
					locked = 2
					SetVehicleDoorsLockedForAllPlayers(VehUse, true)
					TriggerEvent('InteractSound_CL:PlayOnOne', 'lock', 1.0)
					Core.Main.ShowNotification("Vous avez ~r~fermé~s~ le véhicule.")
				elseif locked >= 2 then
					locked = 1
					SetVehicleDoorsLockedForAllPlayers(VehUse, false)
					TriggerEvent('InteractSound_CL:PlayOnOne', 'unlock', 1.0)
					Core.Main.ShowNotification("Vous avez ~g~ouvert~s~ le véhicule.")
				end
				SetVehicleDoorsLocked(VehUse, locked)
				SetVehicleLights(VehUse, 2)
				Wait(200)
				SetVehicleLights(VehUse, 0)
				StartVehicleHorn(VehUse, 100, 1, false)
				Wait(200)
				SetVehicleLights(VehUse, 2)
				Wait(400)
				SetVehicleLights(VehUse, 0)
			else
				Core.Main.ShowNotification("~r~Vous n'avez pas les clés de ce véhicule.")
			end
		end, Core.Math.Trim(GetVehicleNumberPlateText(VehUse)))
	end
end

--Monter a la porte du vehicule al plus proche
local VehicleDoorEnter = {
	runningVehicleDoor = false,
	doors = {	
		{"seat_dside_f", -1},
		{"seat_pside_f", 0},
		{"seat_dside_r", 1},
		{"seat_pside_r", 2}
	}
}
function SetVehicleDoorEnter()
	if IsControlJustReleased(0, 23) and not VehicleDoorEnter.runningVehicleDoor then
		VehicleDoorEnter.runningVehicleDoor = true
		local vehicleDoor = Core.Vehicle.VehicleDetectInZone()
		if vehicleDoor ~= nil then
			local DistanceMin = 99
			local DoorUse = 1
			for k, door in pairs(VehicleDoorEnter.doors) do
				local DistanceDoor = Vdist(coords, GetWorldPositionOfEntityBone(vehicleDoor, GetEntityBoneIndexByName(vehicleDoor, door[1])))
				if DistanceDoor < DistanceMin then
					DistanceMin = DistanceDoor
					DoorUse = k
				end
			end
			TaskEnterVehicle(playerPed, vehicleDoor, -1, VehicleDoorEnter.doors[DoorUse][2], 1.0, 1, 0)
			RealistSpeed(vehicleDoor)
		end
		VehicleDoorEnter.runningVehicleDoor = false
	end
end

--Sirene de police
-- function SirenVehicle()
-- 	if GetPedInVehicleSeat(currentVeh, -1) == playerPed then                                     
-- 		PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
-- 		TriggerServerEvent('SilentSiren', IsVehicleSirenAudioOn(currentVeh))
-- 	end
-- end

-- RegisterNetEvent('updateSirens')
-- AddEventHandler('updateSirens', function(PID, Toggle)
-- 	SetVehicleHasMutedSirens(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(PID)), false), Toggle)
-- end)

--Stop Basic de police
function StopBasicSirenVehicle(vehicle)
	if GetVehicleClass(vehicle) == 18 then
		DisableControlAction(0, 86, true) 
	end
end

--CarWash
function CarWash()
	SetVehicleDirtLevel(currentVeh, 0.0000000001)
	SetVehicleUndriveable(currentVeh, false)
	Citizen.Wait(5000)
	TriggerServerEvent('cleanveh:clean', 50)
end

--Vehicle Push
function VehiclePush()
	local IsInFront = true
	local closestVehicle = Core.Vehicle.VehicleDetectInZone()
	if currentVeh == 0 and closestVehicle ~= 0 then
		if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), coords, true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, coords, true) then
			IsInFront = false
		end
		if IsVehicleSeatFree(closestVehicle, -1) and not IsEntityAttachedToEntity(playerPed, closestVehicle) and (GetVehicleEngineHealth(closestVehicle) <= 200.0 or GetVehicleFuelLevel(vehicle) <= 5.0) then
			local dimension = GetModelDimensions(GetEntityModel(closestVehicle), vector3(0.0, 0.0, 0.0), vector3(5.0, 5.0, 5.0))
			NetworkRequestControlOfEntity(closestVehicle)
			if IsInFront then    
				AttachEntityToEntity(playerPed, closestVehicle, GetPedBoneIndex(6286), 0.0, dimension.y * -1 + 0.1 , dimension.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
			else
				AttachEntityToEntity(playerPed, closestVehicle, GetPedBoneIndex(6286), 0.0, dimension.y - 0.3, dimension.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
			end
			Core.Object.ChargeAnimDict("missfinale_c2ig_11")
			TaskPlayAnim(playerPed, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
			Citizen.Wait(200)

			while true do
				Citizen.Wait(5)
				if IsDisabledControlPressed(0, Config.Keys["A"].id) then
					TaskVehicleTempAction(playerPed, closestVehicle, 11, 1000)
				end

				if IsDisabledControlPressed(0, Config.Keys["D"].id) then
					TaskVehicleTempAction(playerPed, closestVehicle, 10, 1000)
				end

				if IsInFront then
					SetVehicleForwardSpeed(closestVehicle, -1.0)
				else
					SetVehicleForwardSpeed(closestVehicle, 1.0)
				end

				if HasEntityCollidedWithAnything(closestVehicle) then
					SetVehicleOnGroundProperly(closestVehicle)
				end

				if IsControlPressed(0, Config.Keys["ESC"].id) or IsControlPressed(0, Config.Keys["BACKSPACE"].id) then
					DetachEntity(playerPed, false, false)
					StopAnimTask(playerPed, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
					FreezeEntityPosition(playerPed, false)
					break
				else
					Core.Main.ShowHelpNotification("Appuyez sur ~" .. Config.Keys["BACKSPACE"].input .. "~ ou ~" .. Config.Keys["ESC"].input .. "~ pour arreter de pousser la voiture", false, true)
				end
			end
		end
	end
end

-- CreverPneu
function CreverPneu()
	local vehicle = Core.Vehicle.VehicleDetectInZone()
	if currentVeh == 0 and vehicle ~= 0 then
		local allowedWeapons = {"WEAPON_KNIFE", "WEAPON_BOTTLE", "WEAPON_DAGGER", "WEAPON_HATCHET", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE"}
		local animDict = "melee@knife@streamed_core_fps"
		local animName = "ground_attack_on_spot"
		local currentWeapon = GetSelectedPedWeapon(playerPed)
		if Core.Weapon.CanUseWeapon(currentWeapon, allowedWeapons) then
			local closestTire = Core.Vehicle.GetClosestVehicleTire(vehicle)
			if closestTire ~= nil then
				
				if not IsVehicleTyreBurst(vehicle, closestTire.tireIndex, 0) then
					Core.Object.ChargeAnimDict(animDict)

					local animDuration = GetAnimDuration(animDict, animName)
					TaskPlayAnim(playerPed, animDict, animName, 8.0, 8.0, animDuration, 15, 1.0, 0, 0, 0)
					Citizen.Wait(animDuration * 1000)

					local driverServer = GetPlayerServerId(Core.Player.GetClosestPlayer(3))

					if driverServer == 0 then
						SetVehicleTyreBurst(vehicle, closestTire.tireIndex, 0, 100.0)
					else
						TriggerServerEvent("Core:CreverPneuServer", driverServer, closestTire.tireIndex)
					end

					Citizen.Wait((animDuration / 2) * 1000)
					ClearPedTasksImmediately(playerPed)
				end
			end
		end
	end
end

RegisterNetEvent("Core:CreverPneu")
AddEventHandler("Core:CreverPneu", function(tireIndex)
	SetVehicleTyreBurst(currentVeh, tireIndex, 0, 100.0)
    Core.Main.ShowNotification("~b~Tableau de bord:~w~ Vérifiez la pression des pneus.")
end)