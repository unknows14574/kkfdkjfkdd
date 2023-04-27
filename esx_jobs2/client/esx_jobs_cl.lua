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


local menuIsShowed        = false
local hintIsShowed        = false
local GUI                       = {}

local hasAlreadyEnteredMarker = false
local Blips                   = {}
local JobBlips                = {}

local collectedItem           = nil
local collectedQtty       = 0
local collectedQttyUpToDate   = false
local previousCollectedItem   = nil
local previousCollectedQtty   = 0
local isInMarker              = false
local isInPublicMarker        = false

local newTask                 = false
local hintToDisplay           = "no hint to display"
local jobDone                 = false
local onDuty          = true
local moneyInBank       = 0

local spawner           = 0
local myPlate                 = {}

local isJobVehicleDestroyed   = false

local cautionVehicleInCaseofDrop  = 0
local maxCautionVehicleInCaseofDrop = 0
local vehicleObjInCaseofDrop    = nil
local vehicleInCaseofDrop       = nil
local vehicleHashInCaseofDrop     = nil
local vehicleMaxHealthInCaseofDrop  = nil
local vehicleOldHealthInCaseofDrop  = nil

GUI.Time                        = 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    --TriggerServerEvent('esx_jobs2:giveBackCautionInCaseOfDrop')
    jobs2_refreshBlips()
	--onDuty = true
end)


AddEventHandler('esx_jobs2:publicTeleports', function(position)
  SetEntityCoords(GetPlayerPed(-1), position.x, position.y, position.z)
end)

function jobs2_OpenMenu()
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom22',
    {
      title    = _U('cloakroom'),
	  align = 'right',
      elements = {
        {label = _U('job_wear'), value = 'job_wear'},
        {label = _U('citizen_wear'), value = 'citizen_wear'},
		{label = "Entreprise", value = 'entreprise'}
      }
    },
    function(data, menu)
	
	  if data.current.value == 'entreprise' then
		  if PlayerData.job2.name ~= nil and PlayerData.job2.grade_name ~= 'interim' and PlayerData.job.service == 1 then
			local jname = PlayerData.job2.name
			TriggerEvent('esx_extendedjob:Entreprise', jname)
		  end
	  end
	
      if data.current.value == 'citizen_wear' then
        --onDuty = false
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin2', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
      end
      if data.current.value == 'job_wear' then
        --onDuty = true
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin2', function(skin, jobSkin)
            if skin.sex == 0 then
              TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
          else
              TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
          end
        end)
      end
      menu.close()
    end,
    function(data, menu)
      menu.close()
    end
  )
end

AddEventHandler('esx_jobs2:action', function(job, zone)
  menuIsShowed = true
  if zone.Type == "cloakroom" then
    jobs2_OpenMenu()
  elseif zone.Type == "work" then
	Citizen.Wait(100)
    hintToDisplay = "no hint to display"
    hintIsShowed = false

    if IsPedInAnyVehicle(playerPed, 0) then
      TriggerEvent('esx:showNotification', _U('foot_work'))
    else
      TriggerServerEvent('esx_jobs2:startWork', zone.Item)
    end
  elseif zone.Type == "vehspawner" then
    TriggerServerEvent('esx_jobs2:requestPlayerData', 'refresh_bank_account')
    local spawnpt = nil
    local deliverypt = nil
    local vehicle = nil

    for k,v in pairs(Config_esx_jobs2.Jobs) do
      if (PlayerData.job2.name == k) then
        for l,w in pairs(v.Zones) do
          if (w.Type == "vehspawnpt") and (w.Spawner == zone.Spawner) then
            spawnpt = w
            spawner = w.Spawner
          end
        end
        for m,x in pairs(v.Vehicles) do
          if (x.Spawner == zone.Spawner) then
            vehicle = x
          end
        end
      end
    end

    local caution = zone.Caution

    if deliverypt == nil then
      deliverypt = 0
    end

    --TriggerServerEvent('esx_jobs2:setCautionInCaseOfDrop', caution)
    --cautionVehicleInCaseofDrop = caution
    --maxCautionVehicleInCaseofDrop = cautionVehicleInCaseofDrop

    jobs2_spawncar(spawnpt, vehicle)

  elseif zone.Type == "vehdelete" then
    local looping = true
    for k,v in pairs(Config_esx_jobs2.Jobs) do
      if (PlayerData.job2.name == k) then
        for l,w in pairs(v.Zones) do
          if (w.Type == "vehdelete") and (w.Spawner == zone.Spawner) then

            if IsPedInAnyVehicle(playerPed, 0) then
              local vehicle = GetVehiclePedIsIn(playerPed, 0)
              --local plate = GetVehicleNumberPlateText(vehicle)
              --plate = string.gsub(plate, " ", "")
              --local driverPed = GetPedInVehicleSeat(vehicle, -1)
              --for i=1, #myPlate, 1 do
                --if (myPlate[i] == plate) and (playerPed == driverPed) then
                  --TriggerServerEvent('esx_jobs2:caution', "give_back", cautionVehicleInCaseofDrop, 0, 0)
                  DeleteVehicle(GetVehiclePedIsIn(playerPed, 0))

                  if w.Teleport ~= 0 then
                    SetEntityCoords(GetPlayerPed(-1), w.Teleport.x, w.Teleport.y, w.Teleport.z)
                  end

                  --TriggerEvent('esx_vehiclelock:updatePlayerCars', "remove", myPlate[i])
                  --table.remove(myPlate, i)

                  --if vehicleObjInCaseofDrop.HasCaution then
                    --cautionVehicleInCaseofDrop = 0
                    --maxCautionVehicleInCaseofDrop = 0
                    --vehicleInCaseofDrop = nil
                    --vehicleHashInCaseofDrop = nil
                    --vehicleMaxHealthInCaseofDrop = nil
                    --vehicleOldHealthInCaseofDrop = nil
                    --vehicleObjInCaseofDrop = nil
                    --TriggerServerEvent('esx_jobs2:setCautionInCaseOfDrop', 0)
                  --end

                  break
                --end
              --end
            end
            looping = false
            break
          end
          if looping == false then
            break
          end
        end
      end
      if looping == false then
        break
      end
    end
  elseif zone.Type == "delivery" then
    if Blips['delivery'] ~= nil then
      RemoveBlip(Blips['delivery'])
      Blips['delivery'] = nil
    end
    hintToDisplay = "no hint to display"
    hintIsShowed = false
    TriggerServerEvent('esx_jobs2:startWork', zone.Item)
  end
  --jobs2_nextStep(zone.GPS)
end)

function jobs2_nextStep(gps)
  if gps ~= 0 then
    if Blips['delivery'] ~= nil then
      RemoveBlip(Blips['delivery'])
      Blips['delivery'] = nil
    end
    Blips['delivery'] = AddBlipForCoord(gps.x, gps.y, gps.z)
    SetBlipRoute(Blips['delivery'], true)
    TriggerEvent('esx:showNotification', _U('next_point'))
  end
end

-- #########################
AddEventHandler('esx_jobs2:hasExitedMarker', function(zone)
  --if hintToDisplay ~= "aucun indice à afficher" then
	  --TriggerServerEvent('esx_jobs2:stopWork')
	  hintToDisplay = "no hint to display"
	  menuIsShowed = false
	  hintIsShowed = false
	  isInMarker = false
  --end
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job)
  while (PlayerData.job or PlayerData.job2) == nil do

    Citizen.Wait(10)
  end
  --onDuty = false
  myPlate = {} -- loosing vehicle caution in case player changes job.
  isJobVehicleDestroyed = false
  spawner = 0
  jobs2_deleteBlips()
  jobs2_refreshBlips()
  --onDuty = true
end)

function jobs2_deleteBlips()
  if JobBlips[1] ~= nil then
    for i=1, #JobBlips, 1 do
      RemoveBlip(JobBlips[i])
      JobBlips[i] = nil
    end
  end
end

function jobs2_refreshBlips()
  local zones = {}
  local blipInfo = {}

  if (PlayerData.job2 ~= nil) then
    for jobKey,jobValues in pairs(Config_esx_jobs2.Jobs) do

      if (jobKey == PlayerData.job2.name) then
        for zoneKey,zoneValues in pairs(jobValues.Zones) do
          if zoneValues.Blip then
            local blip = AddBlipForCoord(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z)
            SetBlipSprite (blip, jobValues.BlipInfos.Sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, 0.6)
            SetBlipColour (blip, jobValues.BlipInfos.Color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(zoneValues.Name)
            EndTextCommandSetBlipName(blip)
            table.insert(JobBlips, blip)
          end
        end
      end

    end
  end

end

function jobs2_spawncar(spawnPoint, vehicle)
  hintToDisplay = "no hint to display"
  hintIsShowed = false
  TriggerServerEvent('esx_jobs2:caution', "take", cautionVehicleInCaseofDrop, spawnPoint, vehicle)
end

RegisterNetEvent('esx_jobs2:spawnJobVehicle')
AddEventHandler('esx_jobs2:spawnJobVehicle', function(spawnPoint, vehicle)
  local coords = spawnPoint.Pos
  local vehicleModel = GetHashKey(vehicle.Hash)

  RequestModel(vehicleModel)
  while not HasModelLoaded(vehicleModel) do
    Citizen.Wait(1)
  end

  local platePrefix = "WORK"
  local plate = math.random(1000, 9000)
  if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
    --local veh = CreateVehicle(vehicleModel, coords.x, coords.y, coords.z, spawnPoint.Heading, true, false)

	ESX.Game.SpawnVehicle(vehicleModel, coords, spawnPoint.Heading, function(veh)
	
		if vehicle.Trailer ~= "none" then
		  RequestModel(vehicle.Trailer)

		  while not HasModelLoaded(vehicle.Trailer) do
			Citizen.Wait(1)
		  end

		  local trailer = CreateVehicle(vehicle.Trailer, coords.x, coords.y, coords.z, spawnPoint.Heading, true, false)
		  AttachVehicleToTrailer(veh, trailer, 1.1)
		end

		for k,v in pairs(Config_esx_jobs2.Plates) do
		  if (PlayerData.job2.name == k) then
			platePrefix = v
		  end
		end

		SetVehicleNumberPlateText(veh, platePrefix .. plate)
		table.insert(myPlate, platePrefix .. plate)
		--plate = string.gsub(plate, " ", "")
		--TriggerEvent('esx_vehiclelock:updatePlayerCars', "add", plate)
		SetVehRadioStation(veh, "OFF")
		TaskWarpPedIntoVehicle(playerPed, veh, -1)
		isJobVehicleDestroyed = false
		
		if vehicle.Livery ~= nil then
			SetVehicleLivery(veh, vehicle.Livery)
		end

		if vehicle.HasCaution then
		  vehicleInCaseofDrop = veh
		  vehicleHashInCaseofDrop = vehicle.Hash
		  vehicleObjInCaseofDrop = vehicle
		  vehicleMaxHealthInCaseofDrop = GetEntityMaxHealth(veh)
		  vehicleOldHealthInCaseofDrop = vehicleMaxHealthInCaseofDrop
		end
	end)
	
	TriggerEvent('esx_vehiclelock:givekey', platePrefix .. plate)
	
  end
end)

-- Show top left hint
function jobs01()
    if hintIsShowed == true then
      SetTextComponentFormat("STRING")
      AddTextComponentString(hintToDisplay)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end
end

-- Display markers (only if on duty and the player's job ones)
function jobs03()
    local zones = {}
    if (PlayerData.job2 ~= nil) then
      for k,v in pairs(Config_esx_jobs2.Jobs) do
        if (PlayerData.job2.name == k) then
          zones = v.Zones
        end
      end

      
      for k,v in pairs(zones) do
        if (onDuty or v.Type == "cloakroom" or PlayerData.job2.name == "reporter" and PlayerData.job.service == 1) then
          if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_esx_jobs2.DrawDistance) then
            DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
          end
        end
      end
    end
end

-- Display public markers
--Citizen.CreateThread(function()
  --while true do
    --Wait(1)
    --
    --for k,v in pairs(Config_esx_jobs2.PublicZones) do
      --if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_esx_jobs2.DrawDistance) then
        --DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
      --end
    --end
  --end
--end)

-- Activate public marker
--Citizen.CreateThread(function()
  --while true do
  --  Wait(10)
    --
  --  local position    = nil
  --  local zone        = nil

  --  for k,v in pairs(Config_esx_jobs2.PublicZones) do
  --    if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
  --      isInPublicMarker = true
  --      position = v.Teleport
  --      zone = v
  --      break
  --    else
  --      isInPublicMarker  = false
  --    end
  --  end

  --  if IsControlJustReleased(0, Keys["E"]) and isInPublicMarker then
	  --Citizen.Wait(5000)
  --    TriggerEvent('esx_jobs2:publicTeleports', position)
  --  end

    -- hide or show top left zone hints
  --  if isInPublicMarker then
  --    hintToDisplay = zone.Hint
  --    hintIsShowed = true
  --  else
  --    if not isInMarker then
  --      hintToDisplay = "no hint to display"
  --      hintIsShowed = false
  --    end
  --  end
  --end
--end)

-- Activate menu when player is inside marker
function jobs04()
    if (PlayerData.job2 ~= nil and PlayerData.job2.name ~= 'unemployed2' and PlayerData.job2.service == 1) then
      local zones = nil
      local job = nil

      for k,v in pairs(Config_esx_jobs2.Jobs) do
        if (PlayerData.job2.name == k) then
          job = v
          zones = v.Zones
        end
      end

      if zones ~= nil then
        
        local currentZone = nil
        local zone      = nil
        local lastZone    = nil

        for k,v in pairs(zones) do
          if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
            isInMarker  = true
            currentZone = k
            zone        = v
            break
          else
            isInMarker  = false
          end
        end

        if IsControlJustReleased(0, Keys["E"]) and not menuIsShowed and isInMarker then
          if (onDuty or zone.Type == "cloakroom" or PlayerData.job2.name == "reporter") then
            TriggerEvent('esx_jobs2:action', job, zone)
          end
        end

        -- hide or show top left zone hints
        if isInMarker and not menuIsShowed then
          hintIsShowed = true
          if ((onDuty or zone.Type == "cloakroom" or PlayerData.job2.name == "reporter") and zone.Type ~= "vehdelete") then
            hintToDisplay = zone.Hint
            hintIsShowed = true
          elseif (zone.Type == "vehdelete" and (onDuty or PlayerData.job2.name == "reporter")) then
            if IsPedInAnyVehicle(playerPed, 0) then
              local vehicle = GetVehiclePedIsIn(playerPed)
              local driverPed = GetPedInVehicleSeat(vehicle, -1)
              local isVehicleOwner = false
              local plate = GetVehicleNumberPlateText(vehicle)
              plate = string.gsub(plate, " ", "")
              for i=1, #myPlate, 1 do
                Citizen.Trace(myPlate[i])
                if (myPlate[i] == plate) and (playerPed == driverPed) then
                  hintToDisplay = zone.Hint
                  isVehicleOwner = true
                  break
                end
              end
              if not isVehicleOwner then
                hintToDisplay = _U('not_your_vehicle')
              end
            else
              hintToDisplay = _U('in_vehicle')
            end
            hintIsShowed = true
          elseif onDuty and zone.Spawner ~= spawner then
            hintToDisplay = _U('wrong_point')
            hintIsShowed = true
          else
            if not isInPublicMarker then
              hintToDisplay = "no hint to display"
              hintIsShowed = false
            end
          end
        end

        if isInMarker and not hasAlreadyEnteredMarker then
          hasAlreadyEnteredMarker = true
        end

        if not isInMarker and hasAlreadyEnteredMarker then
          hasAlreadyEnteredMarker = false
          TriggerEvent('esx_jobs2:hasExitedMarker', zone)
        end
      end
    end
end

-- VEHICLE CAUTION
--[[Citizen.CreateThread(function()
  while true do
    Wait(1)
    if vehicleInCaseofDrop ~= nil then
      if onDuty and IsVehicleModel(vehicleInCaseofDrop, vehicleHashInCaseofDrop) then
        local vehicleHealth = GetEntityHealth(vehicleInCaseofDrop)
        if vehicleOldHealthInCaseofDrop ~= vehicleHealth then
          local cautionValue = 0
            vehicleOldHealthInCaseofDrop = vehicleHealth
            if vehicleHealth == vehicleMaxHealthInCaseofDrop then
              cautionValue = maxCautionVehicleInCaseofDrop
              cautionVehicleInCaseofDrop = cautionValue
            else
            local healthPct = (vehicleHealth * 100) / vehicleMaxHealthInCaseofDrop
            local damagePct = 100 - healthPct
            cautionValue =  math.ceil(cautionVehicleInCaseofDrop - cautionVehicleInCaseofDrop * damagePct * 2.5 / 100)
            if cautionValue < 0 then
                cautionValue = 0
            elseif cautionValue >= cautionVehicleInCaseofDrop then
                cautionValue = cautionVehicleInCaseofDrop
            end
            cautionVehicleInCaseofDrop = cautionValue
          end
          TriggerServerEvent('esx_jobs2:setCautionInCaseOfDrop', cautionValue)
        end
      end
    end
  end
end)]]

Citizen.CreateThread(function()

  -- Slaughterer
  RemoveIpl("CS1_02_cf_offmission")
  RequestIpl("CS1_02_cf_onmission1")
  RequestIpl("CS1_02_cf_onmission2")
  RequestIpl("CS1_02_cf_onmission3")
  RequestIpl("CS1_02_cf_onmission4")

  -- Textil
  RequestIpl("id2_14_during_door")
  RequestIpl("id2_14_during1")

end)

-- Key Controls
--Citizen.CreateThread(function()
  --while true do

    --Citizen.Wait(1)

    --if IsControlPressed(0, Keys['F2']) and PlayerData.job ~= nil and (GetGameTimer() - GUI.Time) > 150 then
      --if PlayerData.job.name == 'vignerons' or PlayerData.job.name == 'agriculteur' then
        --local jname = PlayerData.job.name
        --TriggerEvent('esx_extendedjob:jobs2_OpenMenuJob', jname)
        --GUI.Time = GetGameTimer()
      --end
    --end

  --end
--end)