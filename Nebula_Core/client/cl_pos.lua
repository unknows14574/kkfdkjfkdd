--Affichage Blip Pos
function BlipPos()
	for zoneKey,zoneValues in pairs(iV.Zones)do
		if zoneValues.Blips then
			if zoneValues.Color then
				zoneValues.TypeZone.Blips.Color = zoneValues.Color
			end
			if zoneValues.Name then
				zoneValues.TypeZone.Name = zoneValues.Name
			end
			local blip = AddBlipForCoord(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z)
		
			SetBlipSprite(blip, zoneValues.TypeZone.Blips.Sprite)
			SetBlipDisplay(blip, zoneValues.TypeZone.Blips.Display)
			SetBlipScale(blip, zoneValues.Blips)
			SetBlipColour(blip, zoneValues.TypeZone.Blips.Color)

			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(zoneValues.TypeZone.Name)
			EndTextCommandSetBlipName(blip)
		end
	end
end

--Affichage Create Ped Pos
function CreatePedPos()
	for zoneKey, zoneValues in pairs(iV.Zones) do
		if zoneValues.Ped then
			-- for ped in EnumeratePeds() do
			-- 	if GetDistanceBetweenCoords(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z, GetEntityCoords(ped), true) <= 1.5 then
			-- 		zoneValues.Ped.id = ped
			-- 		break
			-- 	end
			-- end
			if zoneValues.Ped.id == nil then
				Core.Object.ChargerModel(zoneValues.Ped.Hash)

				local npc = CreatePed(zoneValues.Ped.PedType, type(zoneValues.Ped.Hash) == 'number' and zoneValues.Ped.Hash or GetHashKey(zoneValues.Ped.Hash), zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z, zoneValues.Pos.Angle, false, true)

				SetPedDefaultComponentVariation(npc)
				if zoneValues.Ped.Dict then
					Core.Object.ChargeAnimDict(zoneValues.Ped.Dict)
					TaskPlayAnim(npc, zoneValues.Ped.Dict, zoneValues.Ped.Anim, 1.0, -1.0, -1, 1, 1, true, true, true)
				elseif zoneValues.Ped.Scena then
					TaskStartScenarioInPlace(npc, zoneValues.Ped.Scena, 0, false)
				end
				FreezeEntityPosition(npc, true)
				SetEntityInvincible(npc, true)
				SetBlockingOfNonTemporaryEvents(npc, true)

				zoneValues.Ped.id = npc
			end
		end
	end
end

--Boucle detection Pos
local function OpenMenuOrActionPos(Infos)
	if Infos.Blips.Name == "Parking" then
		local VehClosest = 0
		if Infos.Ped then
			-- if Infos.Ped.PosArrivVeh then
			-- 	VehClosest = GetClosestVehicle(Infos.Ped.PosArrivVeh.x, Infos.Ped.PosArrivVeh.y, Infos.Ped.PosArrivVeh.z, 10.0, 0, 71)
			-- end
			if VehClosest == 0 then
				VehClosest = GetClosestVehicle(Infos.Pos.x, Infos.Pos.y, Infos.Pos.z, 3.0, 0, 71)
			end
			-- if VehClosest ~= 0 then
			-- 	FreezeEntityPosition(Infos.Ped.id, false)
			-- 	TaskVehiclePark(Infos.Ped.id, VehClosest, Infos.Pos.x, Infos.Pos.y, Infos.Pos.z, Infos.Pos.Angle, 0, Infos.Pos.Angle, false)
			-- end
		else
			VehClosest = GetVehiclePedIsIn(playerPed)
		end
		if VehClosest ~= 0 then
			if (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId()) or Infos.Ped then
				if Infos.IsJob and Infos.IsJob == PlayerData.job.name then
					ReturnVehicleGarage(Infos.Name, VehClosest, Infos.Ped, Infos.StateToAttribute)
				elseif not Infos.IsJob then
					ReturnVehicleGarage(Infos.Name, VehClosest, Infos.Ped)
				else
					Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Vous ne pouvez pas ranger de véhicule ici.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 80)
				end
			else
				Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Vous n\'êtes pas conducteur du véhicule. Vous ne pouvez pas le ranger.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 80)
			end
			-- if Infos.Ped then
			-- 	Citizen.Wait(3000)
			-- 	while GetClosestVehicle(Infos.Pos.x, Infos.Pos.y, Infos.Pos.z, 3.0, 0, 70) == 0 do
			-- 		Citizen.Wait(500)
			-- 	end

			-- 	TaskGoToCoordAnyMeans(Infos.Ped.id, Infos.Ped.Pos.x, Infos.Ped.Pos.y, Infos.Ped.Pos.z, Infos.Ped.Pos.Angle, 0, 0, 0, 0xbf800000)
			-- 	Citizen.Wait(3000)
			-- end

			-- if Infos.IsJob and Infos.IsJob == PlayerData.job.name then
			-- 	ReturnVehicleGarage(Infos.Name, VehClosest, Infos.Ped, Infos.StateToAttribute)
			-- elseif not Infos.IsJob then
			-- 	ReturnVehicleGarage(Infos.Name, VehClosest, Infos.Ped)
			-- else
			-- 	Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Vous ne pouvez pas ranger de véhicule ici.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 80)
			-- end

			-- if Infos.Ped then
			-- 	while GetDistanceBetweenCoords(GetEntityCoords(Infos.Ped.id), Infos.Ped.Pos.x, Infos.Ped.Pos.y, Infos.Ped.Pos.z, true) >= 1.6 do
			-- 		Citizen.Wait(500)
			-- 	end

			-- 	SetEntityCoords(Infos.Ped.id, Infos.Ped.Pos.x, Infos.Ped.Pos.y, Infos.Ped.Pos.z)
			-- 	SetEntityHeading(Infos.Ped.id, Infos.Ped.Pos.Angle)
			-- 	FreezeEntityPosition(Infos.Ped.id, true)
			-- end
		else
			if Infos.IsJob and Infos.IsJob == PlayerData.job.name then
				OpenGaragaPV(Infos.Name, Infos.Pos, Infos.Ped, Infos.StateToAttribute, Infos.IsJob)
			elseif not Infos.IsJob then
				OpenGaragaPV(Infos.Name, Infos.Pos, Infos.Ped)
			else
				Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Vous ne pouvez pas consulter ce garage.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 180)
			end
		end
	elseif Infos.Blips.Name == "Fourrière de la ville" then
		OpenMenuFourriere(Infos.Pos, Infos.Ped)
	elseif Infos.Blips.Name == "Assurance" then
		OpenMenuAssurance()
	elseif Infos.Blips.Name == "Prefecture" then
		OpenMenuPrefecture()
	elseif Infos.Blips.Name == "CarWash" then
		CarWash()
	elseif Infos.Blips.Name == "SafeZone" then
		Core.Weapon.ZoneSafe(true)
	elseif Infos.Blips.Name =="DoorLock" then
		ChangeStateDoor(Infos)
	end
end

--Renvoie info
local function ReturnInfoPos(id)
	local InfoLocal = iV.Zones[id]
	if InfoLocal.TypeZone.Name == "DoorLock" then
		InfoLocal.TypeZone.DrawDistance.DrawDistance = InfoLocal.Action.distance
		InfoLocal.TypeZone.DrawDistance.Distance = InfoLocal.Action.distance
		if InfoLocal.Action.locked then
			InfoLocal.TypeZone.Text.main = InfoLocal.TypeZone.Text.open
			InfoLocal.TypeZone.ColorDrawMarker = {r = 255, g = 0, b = 0}
		else
			InfoLocal.TypeZone.Text.main = InfoLocal.TypeZone.Text.close
			InfoLocal.TypeZone.ColorDrawMarker = {r = 0, g = 128, b = 0}
		end
		InfoLocal = { Blips = InfoLocal.TypeZone, Name = InfoLocal.name, Pos = InfoLocal.Pos, Action = InfoLocal.Action, NumLine = id, PushKeyOff = true }
		if InfoLocal.Action.job then
			for k, v in pairs(InfoLocal.Action.job) do
				if v == PlayerData.job.name or v == PlayerData.job2.name then
					InfoLocal.PushKeyOff = false
					break
				end
			end
		elseif InfoLocal.Action.steam then
			for k, v in pairs(InfoLocal.Action.steam) do
				TriggerServerCallback('esx_doorlock:GetSteamAllowed', function(identifier)
					if identifier == v then
						InfoLocal.PushKeyOff = false
					end
				end)
			end
		end
		DoorLock(InfoLocal)
		CheckDoorLock()
	elseif InfoLocal.Ped then
		if InfoLocal.TypeZone.Name == "Parking" then
			InfoLocal.TypeZone.Text.main = InfoLocal.TypeZone.Text.get
			if (InfoLocal.Ped.PosArrivVeh and GetClosestVehicle(InfoLocal.Ped.PosArrivVeh.x, InfoLocal.Ped.PosArrivVeh.y, InfoLocal.Ped.PosArrivVeh.z, 3.0, 0, 71) ~= 0) or GetClosestVehicle(InfoLocal.Ped.x, InfoLocal.Ped.y, InfoLocal.Ped.z, 3.0, 0, 71) ~= 0 then
				InfoLocal.TypeZone.Text.main = InfoLocal.TypeZone.Text.put
			end
			InfoLocal.TypeZone.TailleDrawMarker.TypeDrawMarker = 27
			InfoLocal.TypeZone.TailleDrawMarker.zDel = 0.0
			InfoLocal.TypeZone.DrawDistance.DrawDistance = 7.0
		else
			InfoLocal.TypeZone.TailleDrawMarker.TypeDrawMarker = false
		end
		InfoLocal = { Blips = InfoLocal.TypeZone, Name = InfoLocal.name, Pos = {Text = InfoLocal.Ped.Text, x = InfoLocal.Pos.x, y = InfoLocal.Pos.y, z = InfoLocal.Pos.z, Angle = InfoLocal.Pos.Angle}, Ped = InfoLocal.Ped }
	else
		if InfoLocal.TypeZone.Name == "Parking" then
			InfoLocal.TypeZone.Text.main = InfoLocal.TypeZone.Text.get
			if IsPedInAnyVehicle(playerPed, false) then
				InfoLocal.TypeZone.Text.main = InfoLocal.TypeZone.Text.put
			end
			InfoLocal.TypeZone.TailleDrawMarker.TypeDrawMarker = 36
			InfoLocal.TypeZone.TailleDrawMarker.zDel = 0.4
			InfoLocal.TypeZone.DrawDistance.DrawDistance = 10.0
		end
		InfoLocal = { Blips = InfoLocal.TypeZone, Name = InfoLocal.name, Pos = InfoLocal.Pos, StateToAttribute = InfoLocal.StateToAttribute, IsJob = InfoLocal.IsJob}
	end

	return InfoLocal
end

--Boucle detection Pos
Infos = nil
function PositionAction()
	local wait = 300
	while true do
		Citizen.Wait(wait)
		if not Infos then
			coords = GetEntityCoords(PlayerPedId())
			for k, v in pairs(iV.Zones) do
				if v.TypeZone.Name == "DoorLock" and (not v.Action.checked and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) <= v.Action.lock_dist) then
					local InfoDoor = iV.Zones[k]
					InfoDoor = { Blips = InfoDoor.TypeZone, Name = InfoDoor.name, Pos = InfoDoor.Pos, Action = InfoDoor.Action, NumLine = id, PushKeyOff = true}
					DoorLock(InfoDoor)
					CheckDoorLock()
					iV.Zones[k].Action.checked = true
				end
				if v.Action and (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) <= v.TypeZone.DrawDistance.DrawDistance) then
					wait = 3
					Core.Weapon.ZoneSafe(false)
					Infos = ReturnInfoPos(k)
					break
				end
				wait = 300
			end
		else
			local GetDistance = GetDistanceBetweenCoords(coords, Infos.Pos.x, Infos.Pos.y, Infos.Pos.z, true)
			if GetDistance <= Infos.Blips.DrawDistance.DrawDistance then
				if Infos.Blips.DrawDistance.Action then
					if GetDistance <= Infos.Blips.DrawDistance.Distance then
						if Infos.Pos.Text then
							Core.Main.DrawText3Ds(Infos.Pos.x, Infos.Pos.y, Infos.Pos.z + 2.0, Infos.Pos.Text)
							if Infos.Blips.TailleDrawMarker.TypeDrawMarker then
								DrawMarker(Infos.Blips.TailleDrawMarker.TypeDrawMarker, Infos.Ped.x, Infos.Ped.y, Infos.Ped.z + Infos.Blips.TailleDrawMarker.zDel, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Infos.Blips.TailleDrawMarker.Xproche, Infos.Blips.TailleDrawMarker.Yproche, Infos.Blips.TailleDrawMarker.Zproche, Infos.Blips.ColorDrawMarker.r, Infos.Blips.ColorDrawMarker.g, Infos.Blips.ColorDrawMarker.b, 150, false, true, 2, true, false, false, false)
							end
						elseif Infos.StateToAttribute then
							DrawMarker(Infos.Blips.TailleDrawMarker.TypeDrawMarker, Infos.Pos.x, Infos.Pos.y, Infos.Pos.z + Infos.Blips.TailleDrawMarker.zDel, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Infos.Blips.TailleDrawMarker.Xproche, Infos.Blips.TailleDrawMarker.Yproche, Infos.Blips.TailleDrawMarker.Zproche, 255, 165, 0, 150, false, true, 2, true, false, false, false)
						else
							DrawMarker(Infos.Blips.TailleDrawMarker.TypeDrawMarker, Infos.Pos.x, Infos.Pos.y, Infos.Pos.z + Infos.Blips.TailleDrawMarker.zDel, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Infos.Blips.TailleDrawMarker.Xproche, Infos.Blips.TailleDrawMarker.Yproche, Infos.Blips.TailleDrawMarker.Zproche, Infos.Blips.ColorDrawMarker.r, Infos.Blips.ColorDrawMarker.g, Infos.Blips.ColorDrawMarker.b, 150, false, true, 2, true, false, false, false)
						end
						if not Infos.PushKeyOff then
							if IsControlJustReleased(0, Infos.Blips.Touche) then
								if Infos.Ped then
									Infos.Ped.Pos = Infos.Pos
									Infos.Pos = Infos.Ped
								end
								ESX.UI.Menu.CloseAll()
								OpenMenuOrActionPos(Infos)
							else
								Core.Main.ShowHelpNotification(Infos.Blips.Text.main, false, true)
							end
						end
					else
						if Infos.Pos.Text then
							Core.Main.DrawText3Ds(Infos.Pos.x, Infos.Pos.y, Infos.Pos.z + 2.0, Infos.Pos.Text)
							if Infos.Blips.TailleDrawMarker.TypeDrawMarker then
								DrawMarker(Infos.Blips.TailleDrawMarker.TypeDrawMarker, Infos.Ped.x, Infos.Ped.y, Infos.Ped.z + Infos.Blips.TailleDrawMarker.zDel, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Infos.Blips.TailleDrawMarker.Xloin, Infos.Blips.TailleDrawMarker.Yloin, Infos.Blips.TailleDrawMarker.Zloin, Infos.Blips.ColorDrawMarker.r, Infos.Blips.ColorDrawMarker.g, Infos.Blips.ColorDrawMarker.b, 150, false, true, 2, true, false, false, false)
							end
						elseif Infos.StateToAttribute then
							DrawMarker(Infos.Blips.TailleDrawMarker.TypeDrawMarker, Infos.Pos.x, Infos.Pos.y, Infos.Pos.z + Infos.Blips.TailleDrawMarker.zDel, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Infos.Blips.TailleDrawMarker.Xloin, Infos.Blips.TailleDrawMarker.Yloin, Infos.Blips.TailleDrawMarker.Zloin, 255, 165, 0, 150, false, true, 2, true, false, false, false)
						else
							DrawMarker(Infos.Blips.TailleDrawMarker.TypeDrawMarker, Infos.Pos.x, Infos.Pos.y, Infos.Pos.z + Infos.Blips.TailleDrawMarker.zDel, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Infos.Blips.TailleDrawMarker.Xloin, Infos.Blips.TailleDrawMarker.Yloin, Infos.Blips.TailleDrawMarker.Zloin, Infos.Blips.ColorDrawMarker.r, Infos.Blips.ColorDrawMarker.g, Infos.Blips.ColorDrawMarker.b, 150, false, true, 2, true, false, false, false)
						end
					end
				else
					OpenMenuOrActionPos(Infos)
				end
			else
				Infos = nil
			end
		end	
	end
end