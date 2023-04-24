local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local CurrentAction     = nil
local CurrentActionMsg  = nil
local CurrentActionData = nil
local Licenses          = {}
local CurrentTest       = nil
local CurrentTestType   = nil
local CurrentVehicle    = nil
local CurrentCheckPoint = 0
local LastCheckPoint    = -1
local CurrentBlip       = nil
local CurrentZoneType   = nil
local DriveErrors       = 0
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil

function DrawMissionText(msg, time)
  ESX.ShowNotification(msg)
end

function chauffeur_StartMission(type)

  ESX.Game.SpawnVehicle("pounder", Config_esx_chauffeur.Zones.VehicleSpawnPoint.Pos, 317.0, function(vehicle)
    CurrentTest       = 'drive'
    CurrentTestType   = type
    CurrentCheckPoint = 0
    LastCheckPoint    = -1
    CurrentZoneType   = 'residence'
    DriveErrors       = 0
    IsAboveSpeedLimit = false
    CurrentVehicle    = vehicle
    LastVehicleHealth = GetEntityHealth(vehicle)
	local rand = math.random(1000,9999)
	SetVehicleNumberPlateText(vehicle, "WORK" .. rand)

	
    TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
  end)

end

function chauffeur_StopMission(success)

  if success then
    TriggerServerEvent('esx_chauffeur:pay')
    ESX.ShowNotification("Vous avez recu votre paye.")
	local vehicle = GetVehiclePedIsIn(playerPed,  false)
    ESX.Game.DeleteVehicle(vehicle)
  else
    ESX.ShowNotification("Vous n'avez pas fini votre boulot.")
  end

  CurrentTest     = nil
  CurrentTestType = nil

end

function chauffeur_SetCurrentZoneType(type)
  CurrentZoneType = type
end

AddEventHandler('esx_chauffeur:hasEnteredMarker', function(zone)

  if zone == 'Routier' then

    CurrentAction     = 'chauffeur_menu'
    CurrentActionMsg  = 'Appuyez sur ~o~E~s~ pour commencer les livraisons'
    CurrentActionData = {}

  end
  
  if zone == 'DelVeh' then

    CurrentAction     = 'delveh_menu'
    CurrentActionMsg  = "Press ~o~E~s~ pour arreter les livraisons"
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_chauffeur:hasExitedMarker', function(zone)
	if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	end
end)

-- Create Blips
Citizen.CreateThread(function()

  local blip = AddBlipForCoord(Config_esx_chauffeur.Zones.Routier.Pos.x, Config_esx_chauffeur.Zones.Routier.Pos.y, Config_esx_chauffeur.Zones.Routier.Pos.z)

  SetBlipSprite (blip, 477)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.5)
  SetBlipColour (blip, 36)
  SetBlipAsShortRange(blip, true)

  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Chauffeur Livreur")
  EndTextCommandSetBlipName(blip)

end)

-- Display markers
function chauffeur01()
	

    for k,v in pairs(Config_esx_chauffeur.Zones) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_esx_chauffeur.DrawDistance) then
        DrawMarker(0, v.Pos.x, v.Pos.y, v.Pos.z +0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
      end
    end
end

-- Enter / Exit marker events
function chauffeur02()
	

    local isInMarker  = false
    local currentZone = nil

    for k,v in pairs(Config_esx_chauffeur.Zones) do
      if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
        isInMarker  = true
        currentZone = k
      end
    end

    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
      HasAlreadyEnteredMarker = true
      LastZone                = currentZone
      TriggerEvent('esx_chauffeur:hasEnteredMarker', currentZone)
    end

    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_chauffeur:hasExitedMarker', LastZone)
    end
end

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end

function chauffeur03()
	

    if GetDistanceBetweenCoords(coords, Config_esx_chauffeur.Zones.Routier.Pos.x, Config_esx_chauffeur.Zones.Routier.Pos.y, Config_esx_chauffeur.Zones.Routier.Pos.z, true) < 2.0 then
      sleepThread = 20  
      DrawText3Ds(Config_esx_chauffeur.Zones.Routier.Pos.x, Config_esx_chauffeur.Zones.Routier.Pos.y, Config_esx_chauffeur.Zones.Routier.Pos.z + 1.2, "Appuie sur ~y~E~s~ pour commencer les livraisons")
    end
    if GetDistanceBetweenCoords(coords, Config_esx_chauffeur.Zones.DelVeh.Pos.x, Config_esx_chauffeur.Zones.DelVeh.Pos.y, Config_esx_chauffeur.Zones.DelVeh.Pos.z, true) < 2.0 then
      sleepThread = 20
      DrawText3Ds(Config_esx_chauffeur.Zones.DelVeh.Pos.x, Config_esx_chauffeur.Zones.DelVeh.Pos.y, Config_esx_chauffeur.Zones.DelVeh.Pos.z + 1.2, "Press ~y~A~s~ pour arreter les livraisons")
    end
end

function chauffeur04()
    if CurrentAction ~= nil then

	  if IsControlJustReleased(0, Keys['BACKSPACE']) then
		CurrentAction = nil
	  end
	  
	  if IsControlJustReleased(0,  Keys['Q']) then
		if CurrentAction == 'delveh_menu' then
		  local vehicle = GetVehiclePedIsIn(playerPed,  false)
          ESX.Game.DeleteVehicle(vehicle)
		  chauffeur_StopMission(false)
		  RemoveBlip(CurrentBlip)
        end
        CurrentAction = nil
      end

      if IsControlJustReleased(0,  Keys['E']) then
        if CurrentAction == 'chauffeur_menu' then
		  chauffeur_StartMission("")
        end
        CurrentAction = nil
      end

    end
end

function chauffeur05()

    if CurrentTest == 'drive' then

      
	  
      local nextCheckPoint = CurrentCheckPoint + 1

      if Config_esx_chauffeur.CheckPoints[nextCheckPoint] == nil then
                  if DoesBlipExist(CurrentBlip) then
          RemoveBlip(CurrentBlip)
      end

      CurrentTest = nil

      chauffeur_StopMission(true)
		
      else

      	if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
		  
		        if CurrentCheckPoint ~= LastCheckPoint then

		          if DoesBlipExist(CurrentBlip) then
		            RemoveBlip(CurrentBlip)
		          end

		          CurrentBlip = AddBlipForCoord(Config_esx_chauffeur.CheckPoints[nextCheckPoint].Pos.x, Config_esx_chauffeur.CheckPoints[nextCheckPoint].Pos.y, Config_esx_chauffeur.CheckPoints[nextCheckPoint].Pos.z)
		          SetBlipRoute(CurrentBlip, 1)

		          LastCheckPoint = CurrentCheckPoint

		        end

		        local distance = GetDistanceBetweenCoords(coords, Config_esx_chauffeur.CheckPoints[nextCheckPoint].Pos.x, Config_esx_chauffeur.CheckPoints[nextCheckPoint].Pos.y, Config_esx_chauffeur.CheckPoints[nextCheckPoint].Pos.z, true)

		        if distance <= 25.0 then
		          DrawMarker(0, Config_esx_chauffeur.CheckPoints[nextCheckPoint].Pos.x, Config_esx_chauffeur.CheckPoints[nextCheckPoint].Pos.y, Config_esx_chauffeur.CheckPoints[nextCheckPoint].Pos.z-0.7, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 100, false, true, 2, false, false, false, false)
		        end

		        if distance <= 3.0 and IsVehicleModel(vehicle, GetHashKey("pounder")) then
		          Config_esx_chauffeur.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, chauffeur_SetCurrentZoneType)
		          CurrentCheckPoint = CurrentCheckPoint + 1
		        end
		end

      end

    end
end

