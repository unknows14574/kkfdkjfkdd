local propFireWorks = {}
local objectname = {{item = "starburst", objectName = "ind_prop_firework_01", animName = 'place_firework_1_rocket', particle = "scr_indep_firework_starburst", numberParticle = 1},  
					{item = "shotburst", objectName = "ind_prop_firework_02", animName = 'place_firework_2_cylinder', particle = "scr_indep_firework_shotburst", numberParticle = 8}, 
					{item = "trailburst", objectName = "ind_prop_firework_03", animName = 'place_firework_3_box', particle = "scr_indep_firework_trailburst", numberParticle = 9}, 
					{item = "fountain", objectName = "ind_prop_firework_04", animName = 'place_firework_4_cone', particle = "scr_indep_firework_fountain", numberParticle = 6}
				}

local function activeFireWorks()
	if #propFireWorks >= 1 then
		while #propFireWorks >= 1 do 
			Citizen.Wait(5)
			Core.Main.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour lancer", false, true)
			if IsControlJustReleased(0, 38) then
				local veh = GetClosestVehicle(propFireWorks[1].coords.x, propFireWorks[1].coords.y, propFireWorks[1].coords.z, 100.0, 0, 70)
				SetVehicleAlarm(veh, true)

				Core.Object.ChargePtfxAsset("scr_indep_fireworks")

				TriggerServerEvent("syncbad", propFireWorks)

				SetVehicleAlarm(veh, false)
			end
		end
	end
end

RegisterNetEvent('fireworks:use')
AddEventHandler('fireworks:use', function(objectChoose)
	local coords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.5, -1.02)
	Core.Object.ChargeAnimDict("anim@mp_fireworks")

	for k, v in pairs(objectname) do
		if v.item == objectChoose then
			TaskPlayAnim(playerPed, "anim@mp_fireworks", v.animName, 8.0, -1, -1, 0, 0, 0, 0, 0)

			Citizen.Wait(1250)
			ClearPedSecondaryTask(playerPed)

			local objectName = GetHashKey(v.objectName)
			local prop = CreateObject(objectName, coords, true, false, true)
			table.insert(propFireWorks, {prop = prop, coords = coords, numberParticle = v.numberParticle, particle = v.particle})
			SetEntityHeading(prop, GetEntityHeading(playerPed))
			PlaceObjectOnGroundProperly(prop)
			FreezeEntityPosition(prop, true)
			
			activeFireWorks()
		end
	end
end)

RegisterNetEvent("syncbad_cl")
AddEventHandler("syncbad_cl", function(v, k)
	propFireWorks = {}
	for i = 1, v.numberParticle, 1 do
		UseParticleFxAssetNextCall("scr_indep_fireworks")
		StartNetworkedParticleFxNonLoopedAtCoord(v.particle, v.coords, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
		Citizen.Wait(1500)
	end
	Citizen.Wait(10000)
	DeleteObject(v.prop)
end)