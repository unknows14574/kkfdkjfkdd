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

function Ftext_esx_ambulancejob(txt)
	return Config_esx_ambulancejob.Txt[txt]
end

local GUI                     = {}

local FirstSpawn              = true
local IsDead                  = false
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local RespawnToHospitalMenu   = nil

local OnJob                     = false
local CurrentCustomer           = nil
local CurrentCustomerBlip       = nil
local LastCustomerCoords        = nil
local EmergencyCoords           = vector3(-498.97,-335.8,34.5)
local DestinationBlip           = nil
local IsNearCustomer            = false
local CustomerIsEnteringVehicle = false
local CustomerEnteredVehicle    = false
local WaitingForLimitationReach = false
local CanAskForNewJob           = true

local TargetCoords              = nil
local isInPatientlistingMarker  = false
local CurrentSecond             = nil

GUI.Time                      = 0

--[[
Citizen.CreateThread(function()
	RequestIpl("rc12b_fixed")
	RequestIpl("rc12b_destroyed")
	RequestIpl("rc12b_default")
	RequestIpl("rc12b_hospitalinterior_lod")
	RequestIpl("rc12b_hospitalinterior")
end)
]]
function EMS_SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 2,
    modBrakes       = 2,
    modTransmission = 2,
    modSuspension   = 3,
    modTurbo        = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

----------------------------------------------
------------- AMBULANCE MISSIONS -------------
----------------------------------------------
function DrawSub(msg, time)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(msg)
  DrawSubtitleTimed(time, 1)
end

function ShowLoadingPromt(msg, time, type)
  Citizen.CreateThread(function()
    Citizen.Wait(10)
    N_0xaba17d7ce615adbf("STRING")
    AddTextComponentString(msg)
    N_0xbd12f8228410d9b4(type)
    Citizen.Wait(time)
    N_0x10d373323e5b9c0d()
  end)
end

function EMS_GetRandomWalkingNPC()
  
  local search = {}
  local peds   = ESX.Game.GetPeds()
  local pedselected = nil

  for i=1, #peds, 1 do
    if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) and (GetDistanceBetweenCoords(peds[i], LastCustomerCoords) > 2) and (GetDistanceBetweenCoords(peds[i], EmergencyCoords) > 2) then
      table.insert(search, peds[i])
    end
  end

  if #search > 0 then
    pedselected = search[GetRandomIntInRange(1, #search)]
    if (GetDistanceBetweenCoords(pedselected, LastCustomerCoords) > 2) and (GetDistanceBetweenCoords(pedselected, EmergencyCoords) > 2) then
      return pedselected
    end
  end

  -- for i=1, 250, 1 do

  --   local ped = GetRandomPedAtCoord(0.0,  0.0,  0.0,  math.huge + 0.0,  math.huge + 0.0,  math.huge + 0.0,  26)

  --   if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
  --     table.insert(search, ped)
  --   end

  -- end

  if #search > 0 then
    return search[GetRandomIntInRange(1, #search)]
  end
end

function EMS_ClearCurrentMission()

  if DoesBlipExist(CurrentCustomerBlip) then
    RemoveBlip(CurrentCustomerBlip)
  end

  if DoesBlipExist(DestinationBlip) then
    RemoveBlip(DestinationBlip)
  end

  CurrentCustomer           = nil
  CurrentCustomerBlip       = nil
  LastCustomerCoords        = nil
  DestinationBlip           = nil
  IsNearCustomer            = false
  CustomerIsEnteringVehicle = false
  CustomerEnteredVehicle    = false
  TargetCoords              = nil

end

function EMS_StartAmbulanceJob()--Debut de mission ambulance

  ShowLoadingPromt(Ftext_esx_ambulancejob('taking_service') .. 'Ambulance', 5000, 3)
  EMS_ClearCurrentMission()
  LastCustomerCoords = EmergencyCoords
  OnJob = true
end

function EMS_StopAmbulanceJob(reachLimitWhenAsk)

  if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
    local vehicle = GetVehiclePedIsIn(playerPed,  false)
    TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)

    if CustomerEnteredVehicle then
      TaskGoStraightToCoord(CurrentCustomer,  TargetCoords.x,  TargetCoords.y,  TargetCoords.z,  1.0,  -1,  0.0,  0.0)
    end

  end

  EMS_ClearCurrentMission()

  OnJob = false
  if not reachLimitWhenAsk then
    TriggerEvent('Core:ShowAdvancedNotification', "~r~Centrale EMS", "~y~Patrouille EMS", Ftext_esx_ambulancejob('mission_complete'), 'CHAR_CALL911', 0, false, false, 150)
  end
end
----------------------------------------------
----------------------------------------------


function EMS_RespawnPed(ped, coords)
  SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
  NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false)
  SetPlayerInvincible(ped, false)
  TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
  ClearPedBloodDamage(ped)
  if RespawnToHospitalMenu ~= nil then
    RespawnToHospitalMenu.close()
    RespawnToHospitalMenu = nil
  end
  ESX.UI.Menu.CloseAll()
end

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(_type)
    local maxHealth = GetEntityMaxHealth(playerPed)
    if _type == 'small' then
        TriggerEvent('esx_hospital:setInjured', false)
        TriggerServerEvent('esx_ambulancejob:isalife', 1)
    elseif _type == 'harybo' then
      SetEntityHealth(playerPed, maxHealth)
      TriggerEvent('esx_hospital:setInjured', false)
      TriggerServerEvent('esx_ambulancejob:isalife', 1)
    elseif _type == 'big' then
      SetEntityHealth(playerPed, 100)
      TriggerEvent('esx_hospital:setInjured', false)
      TriggerServerEvent('esx_ambulancejob:isalife', 1)
    end
    ESX.ShowNotification(Ftext_esx_ambulancejob('healed'))
end)

local function InteractSound(distance, sound, volume)
	local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), distance)

	for i=1, #players, 1 do
		TriggerServerEvent('InteractSound_SV:PlayOnOne', GetPlayerServerId(players[i]), sound, volume)
	end
end

RegisterNetEvent('esx_ambulancejob:defibrevive')
AddEventHandler('esx_ambulancejob:defibrevive', function()
  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  if closestPlayer == -1 or closestDistance > 8.0 then
    ESX.ShowNotification(Ftext_esx_ambulancejob('no_players'))
  else
    ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
        if qtty > 0 then
            local closestPlayerPed = GetPlayerPed(closestPlayer)
            local health = GetEntityHealth(closestPlayerPed)
            if health == 0 then

                Citizen.CreateThread(function()
                ESX.ShowNotification(Ftext_esx_ambulancejob('revive_inprogress'))
                InteractSound(10, "defib", 0.1)
                --TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "defib", 0.1)
                TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                Wait(10000)
                ClearPedTasks(playerPed)
                if GetEntityHealth(closestPlayerPed) == 0 then
                    TriggerServerEvent('esx_ambulancejob:removeItem', 'defib')
                    TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
                    ESX.ShowNotification(Ftext_esx_ambulancejob('revive_complete'))
                else
                    ESX.ShowNotification(Ftext_esx_ambulancejob('isdead'))
                end
                end)
            else
            ESX.ShowNotification(Ftext_esx_ambulancejob('unconscious'))
            end
        else
            ESX.ShowNotification(Ftext_esx_ambulancejob('not_enough_defib'))
        end
    end, 'defib')
  end
end)

RegisterNetEvent('esx_ambulancejob:onDefib')
AddEventHandler('esx_ambulancejob:onDefib', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							
	if closestPlayer == -1 or closestDistance > 3.0 then
		ESX.ShowNotification("Personne n'est autour de vous !")
	else
		ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
			if qtty > 0 then
				local closestPlayerPed = GetPlayerPed(closestPlayer)
					ESX.ShowNotification("Reviving")
          InteractSound(10, "defib", 0.1)
          --TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "defib", 0.1)
					RequestAnimDict("missheistfbi3b_ig8_2")
					while not HasAnimDictLoaded("missheistfbi3b_ig8_2") do Citizen.Wait(1) end 
					TaskPlayAnim(playerPed, "missheistfbi3b_ig8_2" ,"cpr_loop_paramedic" ,8.0, -8.0, -1, 1, 0, false, false, false )
					
					Citizen.Wait(10000)
					ClearPedTasks(playerPed)
					
					TriggerServerEvent('esx_ambulancejob:removeItem', 'defib')
					TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
			else
				ESX.ShowNotification("Vous n'avez pas de défibrillateur !")
			end
		end, 'defib')
	end
end)

function EMS_OnPlayerDeath()
	TriggerServerEvent('esx_ambulancejob:isalife', 0)
	TriggerEvent('esx_hospital:setInjured', true)
	
	Citizen.Wait(30000)
	
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
		  Citizen.Wait(10)
		end
		
		local ply_coords = GetEntityCoords(PlayerPedId())

		ESX.SetPlayerData('coords', {
		  x = ply_coords.x,
		  y = ply_coords.y,
		  z = ply_coords.z
		})

		TriggerServerEvent('esx:updateCoords', {
		  x = ply_coords.x,
		  y = ply_coords.y,
		  z = ply_coords.z
		})

		EMS_RespawnPed(playerPed, {
		  x = ply_coords.x,
		  y = ply_coords.y,
		  z = ply_coords.z
		})

		StopScreenEffect('DeathFailOut')

		DoScreenFadeIn(800)
	end)
end

AddEventHandler('esx:onPlayerDeath', function(data)
	EMS_OnPlayerDeath()
end)
function TeleportFadeEffect(entity, coords)

  Citizen.CreateThread(function()

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
      Citizen.Wait(10)
    end

    ESX.Game.Teleport(entity, coords, function()
      DoScreenFadeIn(800)
    end)

  end)

end

function EMS_WarpPedInClosestVehicle(ped)

  

  local vehicle, distance = ESX.Game.GetClosestVehicle({
    x = coords.x,
    y = coords.y,
    z = coords.z
  })

  if distance ~= -1 and distance <= 5.0 then

    local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
    local freeSeat = nil

    for i=maxSeats - 1, 0, -1 do
      if IsVehicleSeatFree(vehicle, i) then
        freeSeat = i
        break
      end
    end

    if freeSeat ~= nil then
      TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
    end

  else
    ESX.ShowNotification(Ftext_esx_ambulancejob('no_vehicles'))
  end

end

function EMS_OpenAmbulanceIRM()

  local elements = {
	  {label = "bide", value = "bide"},
    {label = "dti", value = "dti"},
	  {label = "flare", value = "flare"},
    {label = "gradient", value = "gradient"},
    {label = "kiss", value = "kiss"},
    {label = "mp_rage", value = "mp_rage"}
  }

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'irm',
    {
      title    = "IRM",
	  align = 'right',
      elements = elements
    },
    function(data, menu)

      --InteractSound(10, data.current.value, 0.1)
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, data.current.value, 0.1)

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'ambulance_irm'
      CurrentActionMsg  = Ftext_esx_ambulancejob('open_menu')
      CurrentActionData = {}

    end
  )

end


function EMS_OpenAmbulanceActionsMenu()

  local elements = {}

  table.insert(elements, {label = Ftext_esx_ambulancejob('cloakroom'), value = 'cloakroom'})
  table.insert(elements, {label = "Mettre Gilet pare-balles", value = 'gileton'})
  table.insert(elements, {label = "Retirer Gilet pare-balles", value = 'giletoff'})
  table.insert(elements, {label = "Retirer la caméra", value = 'camoff'})
  if not CurrentSecond then
    table.insert(elements, {label = Ftext_esx_ambulancejob('open_weapon_stash'), value = 'get_weapon'})
    table.insert(elements, {label = Ftext_esx_ambulancejob('open_utility_stash'), value = 'get_stock'})
  end


	if ((PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' and PlayerData.job.grade_name == 'boss'  and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'ambulance' and PlayerData.job2.grade_name == 'boss'  and PlayerData.job2.service == 1)) and not CurrentSecond then
		table.insert(elements, {label = Ftext_esx_ambulancejob('boss_actions'), value = 'boss_actions'})
	end
	

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'ambulance_actions',
    {
      title    = Ftext_esx_ambulancejob('ambulance'),
	  align = 'right',
      elements = elements
    },
    function(data, menu)

		if data.current.value == 'cloakroom' then
		  EMS_OpenCloakroomMenu()
		end
	  
		if data.current.value == 'gileton' then
		 TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
          ['bproof_1'] = 26, ['bproof_2'] = 8
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
          ['bproof_1'] = 30, ['bproof_2'] = 8
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
    end)
		
		
		SetPedArmour(playerPed, 50)
		ClearPedBloodDamage(playerPed)
		ResetPedVisibleDamage(playerPed)
		ClearPedLastWeaponDamage(playerPed)
		end
		if data.current.value == 'giletoff' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
          ['bproof_1'] = 13, ['bproof_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
          ['bproof_1'] = 14, ['bproof_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
    end)
    SetPedArmour(playerPed, 0)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
  end
  if data.current.value == 'camoff' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
          ['bproof_1'] = 0, ['bproof_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
          ['bproof_1'] = 0, ['bproof_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
    end)
    SetPedArmour(playerPed, 0)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
  end
    if data.current.value == 'get_weapon' then
      TriggerEvent('core_inventory:client:openSocietyWeaponsInventory', 'society_ambulance')
      menu.close()
    end
    if data.current.value == 'get_stock' then
      TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_ambulance')
      menu.close()
    end

      if data.current.value == 'boss_actions' then
        TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
          menu.close()
        end, {wash = false})
      end

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'ambulance_actions_menu'
      CurrentActionMsg  = Ftext_esx_ambulancejob('open_menu')
      CurrentActionData = {}

    end
  )
end

RegisterNetEvent('EMS_Ask:Answer')
AddEventHandler('EMS_Ask:Answer', function(question,receiver)
  ESX.UI.Menu.CloseAll()
  local emiter = receiver
  ESX.UI.Menu.Open(
    'dialog', GetCurrentResourceName(), 'requested_action',
    {
      title = question,
    },
    function(data, menu)
      menu.close()
      TriggerServerEvent('EMS_Ask:SendAnswer', data.value, emiter)
    end,
    function(data, menu)
      menu.close()
    end
  )
end)

function EMS_OpenReviveMenu()
	local elements = {}

	local infos = {}
	for _, i in ipairs(GetActivePlayers()) do
	--onesync --for i = 0, 255 do
		if NetworkIsPlayerActive(i) then
			table.insert(infos, {name = GetPlayerName(i), id = GetPlayerServerId(i)})
		end
	end

	for _,v in pairs(infos) do
		if v.name ~= nil and v.id ~= nil and v.name ~= "**Invalid**" then
			table.insert(elements, {label = "[" .. v.id .. "] " .. v.name, value = v.id})
		end
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'modlist2',
		{
			title    = "Revive (si bug uniquement)",
			align = 'right',
			elements = elements,
		},
		function(data, menu)

			if data.current.value ~= GetPlayerServerId(PlayerId()) then
				TriggerServerEvent('esx_ambulancejob:revive2', data.current.value)
			end
      
		end,
		
		function(data, menu)
			menu.close()
		end
	)	

end

function EMS_OpenMobileAmbulanceActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_ambulance_actions',
    {
      title    = Ftext_esx_ambulancejob('ambulance'),
	  align = 'right',
      elements = {
        {label = Ftext_esx_ambulancejob('ems_menu'), value = 'citizen_interaction'},
		{label = "Lit d'Hopital",      value = 'object_spawner'},
		{label = "Documents médicaux", value = 'medical'},
		{label = "[---------] Missions [---------]", value = 'lol'},
		{label = "Chercher des Interventions", value = 'start'},
    {label = "Arreter les Interventions", value = 'stop'},
    {label = "[---------] Autres [---------]", value = 'lol'},
    {label = "Mettre les gants médicaux", value = 'gants_put'},
    {label = "Enlever les gants médicaux", value = 'gants_remove'},
		--{label = "[---------] Tracker GPS [---------]", value = 'lol'},
		--{label = "Voir les ambulanciers sur votre GPS", value = 'gpstracker'},
      }
    },
    function(data, menu)
	
		if data.current.value == 'gpstracker' then
			TriggerEvent('esx_braceletgps:ems')
		end
	
		if data.current.value == 'start' then
			EMS_StartAmbulanceJob()
      ESX.UI.Menu.CloseAll()
    end
    
		if data.current.value == 'stop' then
			EMS_StopAmbulanceJob()
    end
    
    if data.current.value == 'gants_put' then
      if (PlayerData.job.grade_name == "chief_doctor" or PlayerData.job.grade_name == "co_boss" or PlayerData.job.grade_name == "boss" or PlayerData.job.grade_name == "chef_ambulance" or PlayerData.job.grade_name == "stagiaire") then
          TriggerEvent('skinchanger:getSkin', function(skin)
            if skin.sex == 0 then
      
              local clothesSkin = {
                ['arms'] = 85
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
      
              local clothesSkin = {
                ['arms'] = 104
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end	
          end)
        else
          TriggerEvent('skinchanger:getSkin', function(skin)
            if skin.sex == 0 then
      
              local clothesSkin = {
                ['arms'] = 85
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            else
      
              local clothesSkin = {
                ['arms'] = 109
              }
              TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end	
          end)
      end
    end

    if data.current.value == 'gants_remove' then
      if (PlayerData.job.grade_name == "chief_doctor" or PlayerData.job.grade_name == "co_boss" or PlayerData.job.grade_name == "boss" or PlayerData.job.grade_name == "chef_ambulance") then
        TriggerEvent('skinchanger:getSkin', function(skin)
          if skin.sex == 0 then
    
            local clothesSkin = {
              ['arms'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
    
            local clothesSkin = {
              ['arms'] = 3
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end	
        end)
      elseif PlayerData.job.grade_name == "stagiaire" then
        TriggerEvent('skinchanger:getSkin', function(skin)
          if skin.sex == 0 then
    
            local clothesSkin = {
              ['arms'] = 1
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
    
            local clothesSkin = {
              ['arms'] = 6
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end	
        end)
      else
        TriggerEvent('skinchanger:getSkin', function(skin)
          if skin.sex == 0 then
    
            local clothesSkin = {
              ['arms'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
    
            local clothesSkin = {
              ['arms'] = 14
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end	
        end)
      end
    end
		
		if data.current.value == 'medical' then
			EMS_OpenDocMedicMenu()
		end

      if data.current.value == 'citizen_interaction' then

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'citizen_interaction',
					{
						title    = Ftext_esx_ambulancejob('ems_menu_title'),
						align = 'right',
						elements = {
              {label = "Poser une question au patient (réponse en /me)",   value = 'ask'},
              {label = "Poser une question au patient (réponse en notification)",   value = 'ask2'},
							{label = Ftext_esx_ambulancejob('ems_menu_revive'),   value = 'revive'},
              {label = Ftext_esx_ambulancejob('search'),        value = 'body_search'},
							--{label = Ftext_esx_ambulancejob('ems_menu_revive') .." (si bug)",   value = 'revive2'},
							--{label = Ftext_esx_ambulancejob('ems_menu_small'),      value = 'small'},
							{label = Ftext_esx_ambulancejob('ems_menu_big'),        value = 'big'},
							--{label = Ftext_esx_ambulancejob('ems_menu_putincar'), value = 'put_in_vehicle'},
							{label = "Facturations",              value = 'fine'},
						}
					},
					function(data, menu)

						if data.current.value == 'ask' then
              local closestPlayer, closetDistance = ESX.Game.GetClosestPlayer()
              local receiver    = GetPlayerServerId(closestPlayer)
              if closestPlayer ~= -1 and closetDistance <= 3.0 then
                ESX.UI.Menu.Open(
                  'dialog', GetCurrentResourceName(), 'requested_action',
                  {
                    title = "Poser une question au patient",
                  },
                  function(data, menu)
                    menu.close()
                    TriggerServerEvent('3dme:question', data.value,receiver)
                  end,
                  function(data, menu)
                    menu.close()
                  end
                )
              end
            end

            if data.current.value == 'ask2' then
              local closestPlayer, closetDistance= ESX.Game.GetClosestPlayer()
              local receiver    = GetPlayerServerId(closestPlayer)
              if closestPlayer ~= -1 and closetDistance <= 3.0 then
                ESX.UI.Menu.Open(
                  'dialog', GetCurrentResourceName(), 'requested_action',
                  {
                    title = "Poser une question au patient",
                  },
                  function(data, menu)
                    menu.close()
                    TriggerServerEvent('EMS_Ask:GetAnswer', data.value, receiver)
                  end,
                  function(data, menu)
                    menu.close()
                  end
                )
              end
            end

            if data.current.value == 'revive2' then
							EMS_OpenReviveMenu()
						end
						if data.current.value == 'revive' then

							menu.close()

							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification(Ftext_esx_ambulancejob('no_players'))
							else

								local ped    = GetPlayerPed(closestPlayer)
								--local health = GetEntityHealth(ped)
								
								--ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
                                    --if qtty > 0 then
											local ped    = GetPlayerPed(closestPlayer)
											--local health = GetEntityHealth(ped)
											
											--if health < 50 then

												local closestPlayerPed = GetPlayerPed(closestPlayer)

												Citizen.CreateThread(function()

													ESX.ShowNotification(Ftext_esx_ambulancejob('revive_inprogress'))
                          InteractSound(10, "defib", 0.1)
                          --TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "defib", 0.1)
													RequestAnimDict("missheistfbi3b_ig8_2")
													while not HasAnimDictLoaded("missheistfbi3b_ig8_2") do Citizen.Wait(1) end 
													TaskPlayAnim(playerPed, "missheistfbi3b_ig8_2" ,"cpr_loop_paramedic" ,8.0, -8.0, -1, 1, 0, false, false, false )
					
													Citizen.Wait(10000)
													ClearPedTasks(playerPed)

													if GetEntityHealth(closestPlayerPed) == 0 then
														--TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
														TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
														ESX.ShowNotification(Ftext_esx_ambulancejob('revive_complete') .. GetPlayerName(closestPlayer))
													else
														ESX.ShowNotification(GetPlayerName(closestPlayer) .. Ftext_esx_ambulancejob('isdead'))
													end

												end)

											--else
												--ESX.ShowNotification(GetPlayerName(closestPlayer) .. Ftext_esx_ambulancejob('unconscious'))
											--end
										--else
											--ESX.ShowNotification(Ftext_esx_ambulancejob('not_enough_medikit'))
									--end
                                --end, 'medikit')
							end
						end
            if data.current.value == 'body_search' then
              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
              if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('core_inventory:custom:searchPlayer', GetPlayerServerId(closestPlayer))
                TriggerServerEvent('esx_policejob:fouiller', GetPlayerServerId(closestPlayer))
              end
          end
						if data.current.value == 'small' then
                            menu.close()
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification(Ftext_esx_ambulancejob('no_players'))
                            else
                                --ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
                                    --if qtty > 0 then

                                        Citizen.CreateThread(function()
                                            ESX.ShowNotification(Ftext_esx_ambulancejob('heal_inprogress'))
                                            TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                                            Wait(10000)
                                            ClearPedTasks(playerPed)
                                            --TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
                                            TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
                                            ESX.ShowNotification(Ftext_esx_ambulancejob('heal_complete'))
                                        end)
                                    --else
                                        --ESX.ShowNotification(Ftext_esx_ambulancejob('not_enough_bandage'))
                                    --end
                                --end, 'bandage')
                            end
                        end

                        if data.current.value == 'big' then
                            menu.close()
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification(Ftext_esx_ambulancejob('no_players'))
                            else
                                --ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
                                    --if qtty > 0 then
      
                                        Citizen.CreateThread(function()
                                            ESX.ShowNotification(Ftext_esx_ambulancejob('heal_inprogress'))
                                            TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                                            Wait(10000)
                                            ClearPedTasks(playerPed)
                                            --TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
                                            TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'harybo')
                                            ESX.ShowNotification(Ftext_esx_ambulancejob('heal_complete'))
                                        end)
                                    --else
                                        --ESX.ShowNotification(Ftext_esx_ambulancejob('not_enough_medikit'))
                                    --end
                                --end, 'medikit')
                            end
                        end

						if data.current.value == 'put_in_vehicle' then
							menu.close()
							EMS_WarpPedInClosestVehicle(GetPlayerPed(closestPlayer))
						end
						
						local player, distance = ESX.Game.GetClosestPlayer()
						
						if distance ~= -1 and distance <= 3.0 then
							if data.current.value == 'put_in_vehicle' then
								menu.close()
								TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(player))
							end
							
							if data.current.value == 'fine' then
								EMS_OpenFineMenu(player)
							end
						else
							ESX.ShowNotification(Ftext_esx_ambulancejob('no_players_nearby'))
						end
					end,
					function(data, menu)
						menu.close()
					end
				)

			end
			if data.current.value == 'object_spawner' then
        menu.close()
        ExecuteCommand("litter")

      end
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function LoadLicenses(source)
	TriggerEvent('esx_license:getLicenses', source, function (licenses)
	  TriggerClientEvent('esx_chasse:loadLicenses', source, licenses)
	end)
end

RegisterNetEvent('esx_ambulancejob:loadLicenses')
AddEventHandler('esx_ambulancejob:loadLicenses', function (licenses)
  for i = 1, #licenses, 1 do
	Licenses[licenses[i].type] = true
  end
end)

function EMS_OpenDocMedicMenu()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'doc_medic',
    {
      title    = "Documents médical",
      align = 'right',
      elements = {
        {label = "Visite médical (travail/ppa)", value = 0},
		{label = "Certificat médical (drogue)", value = 1},
      },
    },
    function(data, menu)

		if data.current.value == 0 then
			local player, distance = ESX.Game.GetClosestPlayer()

			if distance ~= -1 and distance <= 3.0 then
				TriggerServerEvent('esx_policejob:giveLicense', GetPlayerServerId(player), 'vmedic', "Visite médicale")
				TriggerServerEvent('emsbot:doc', GetPlayerServerId(player), 0)
			else
				ESX.ShowNotification('Personne à proximité')
			end
		end

		if data.current.value == 1 then
			local player, distance = ESX.Game.GetClosestPlayer()

			if distance ~= -1 and distance <= 3.0 then
				TriggerServerEvent('esx_policejob:giveLicense', GetPlayerServerId(player), 'cmedic', "Certificat médicale")
				TriggerServerEvent('emsbot:doc', GetPlayerServerId(player), 1)
			else
				ESX.ShowNotification('Personne à proximité')
			end
		end

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function EMS_OpenFineMenu(player)

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'fine',
    {
      title    = "Facturation",
      align = 'right',
      elements = {
				{label = "Soin/Réanimation",   value = 0},
        {label = "Visite/Certificat",   value = 1},
        {label = "Facture personnalisée",   value = 2},
      },
    },
    function(data, menu)
      if data.current.value == 2 then
        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'persofine2',
          {
            title = "Montant"
          },
          function(data2, menu2)

            local amount = tonumber(data2.value)
            if amount == nil then
              TriggerEvent('Core:ShowNotification', "Montant invalide!")
            else
              ESX.UI.Menu.CloseAll()
              TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_ambulance', 'Facture des EMS', amount)
              TriggerEvent('Core:ShowNotification', "Facture de ~g~"..amount.."$ ~w~émise.")
            end
          end,
          function(data2, menu2)
            menu2.close()
          end 
        )
      else
        EMS_OpenFineCategoryMenu(player, data.current.value)
      end

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function EMS_OpenFineCategoryMenu(player, category)

  ESX.TriggerServerCallback('esx_ambulancejob:getFineList', function(fines)

    local elements = {}

    for i=1, #fines, 1 do
      table.insert(elements, {
        label     = fines[i].label .. ' $' .. fines[i].amount,
        value     = fines[i].id,
        amount    = fines[i].amount,
        fineLabel = fines[i].label
      })
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fine_category',
      {
        title    = Ftext_esx_ambulancejob('fine'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        local label  = data.current.fineLabel
        local amount = data.current.amount

        menu.close()
		
		ESX.ShowNotification(GetPlayerServerId(player))

        if Config_esx_ambulancejob.EnablePlayerManagement then
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_ambulance', Ftext_esx_ambulancejob('fine_total') .. label, amount)
		  TriggerServerEvent('emsbot:bill', GetPlayerServerId(player), label, amount)
        else
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', Ftext_esx_ambulancejob('fine_total') .. label, amount)
		  TriggerServerEvent('emsbot:bill', GetPlayerServerId(player), label, amount)
        end

        ESX.SetTimeout(300, function()
          EMS_OpenFineCategoryMenu(player, category)
        end)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, category)

end

function EMS_OpenCloakroomMenu()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = Ftext_esx_ambulancejob('cloakroom'),
      align = 'right',
      elements = {
        {label = Ftext_esx_ambulancejob('ems_clothes_civil'), value = 'garde_robe'},
        {label = Ftext_esx_ambulancejob('ems_clothes_ems'), value = 'ambulance_wear'},
		{label = 'Prendre un tracker gps ems', value = 'gps_ems'},
      },
    },
    function(data, menu)

      menu.close()
	  
	  if data.current.value == 'gps_ems' then
			TriggerServerEvent('gps:itemadd', "braceletgps3")
		end

		-- Garde robe
		if data.current.value == 'garde_robe' then

			ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerDressing', function(dressing)

				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {label = dressing[i], value = i})
				end

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'player_dressing',
					{
					  title    = 'Changer tenue',
					  align = 'right',
					  elements = elements,
					},
					function(data, menu)

					  TriggerEvent('skinchanger:getSkin', function(skin)

						ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerOutfit', function(clothes)

							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)

							ESX.ShowNotification('Vous avez bien récupéré la tenue')
							HasLoadCloth = true

						end, data.current.value)

					  end)

					end,
					function(data, menu)
					  menu.close()
					  ESX.UI.Menu.CloseAll()
					end
				)

			end)

		end

      if data.current.value == 'ambulance_wear' then
		TriggerServerEvent("player:serviceOn", "ambulance")
    if (PlayerData.job ~= nil and PlayerData.job.name == 'ambulance'  and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'ambulance'  and PlayerData.job2.service == 1) then
      if (PlayerData.job.grade_name == "ambulance") then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
         if skin.sex == 0 then
                local clothesSkin = {
                ['tshirt_1'] = 154, ['tshirt_2'] = 0,
                ['torso_1'] = 190, ['torso_2'] = 8,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 85,
                ['pants_1'] = 24, ['pants_2'] = 5,
                ['shoes_1'] = 54, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['chain_1'] = 127, ['chain_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
                local clothesSkin = {
                ['tshirt_1'] = 190, ['tshirt_2'] = 0,
                ['torso_1'] = 192, ['torso_2'] = 8,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 109,
                ['pants_1'] = 51, ['pants_2'] = 1,
                ['shoes_1'] = 55, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['chain_1'] = 97, ['chain_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end
        end)
      elseif (PlayerData.job.grade_name == "chief_doctor" or PlayerData.job.grade_name == "co_boss" or PlayerData.job.grade_name == "boss" ) then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          if skin.sex == 0 then
            local clothesSkin = {
            ['tshirt_1'] = 154, ['tshirt_2'] = 0,
            ['torso_1'] = 190, ['torso_2'] = 9,
            ['bproof_1'] = 13, ['bproof_2'] = 0,
            ['arms'] = 85,
            ['pants_1'] = 49, ['pants_2'] = 0,
            ['shoes_1'] = 10, ['shoes_2'] = 0,
            ['helmet_1'] = 122, ['helmet_2'] = 1,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['chain_1'] = 30, ['chain_2'] = 0,
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
      else
            local clothesSkin = {
            ['tshirt_1'] = 190, ['tshirt_2'] = 0,
            ['torso_1'] = 195, ['torso_2'] = 9,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['bproof_1'] = 14, ['bproof_2'] = 0,
            ['arms'] = 104,
            ['pants_1'] = 136, ['pants_2'] = 4,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 96, ['chain_2'] = 0,
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end
        end)
		
		 elseif (PlayerData.job.grade_name == "doctor") then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          if skin.sex == 0 then
            local clothesSkin = {
            ['tshirt_1'] = 129, ['tshirt_2'] = 0,
            ['torso_1'] = 190, ['torso_2'] = 9,
            ['bproof_1'] = 13, ['bproof_2'] = 0,
            ['arms'] = 85,
            ['pants_1'] = 96, ['pants_2'] = 1,
            ['shoes_1'] = 51, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['chain_1'] = 30, ['chain_2'] = 0,
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
      else
            local clothesSkin = {
            ['tshirt_1'] = 190, ['tshirt_2'] = 0,
            ['torso_1'] = 192, ['torso_2'] = 9,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['bproof_1'] = 14, ['bproof_2'] = 0,
            ['arms'] = 109,
            ['pants_1'] = 99, ['pants_2'] = 1,
            ['shoes_1'] = 60, ['shoes_2'] = 9,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 96, ['chain_2'] = 0,
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end
        end)
	  elseif (PlayerData.job.grade_name == "chef_ambulance") then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          if skin.sex == 0 then
                local clothesSkin = {
                ['tshirt_1'] = 154, ['tshirt_2'] = 0,
                ['torso_1'] = 200, ['torso_2'] = 8,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 86,
                ['pants_1'] = 129, ['pants_2'] = 0,
                ['shoes_1'] = 51, ['shoes_2'] = 0,
                ['helmet_1'] = 122, ['helmet_2'] = 0,
                ['chain_1'] = 127, ['chain_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
                local clothesSkin = {
                ['tshirt_1'] = 190, ['tshirt_2'] = 0,
                ['torso_1'] = 202, ['torso_2'] = 8,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 101,
                ['pants_1'] = 51, ['pants_2'] = 1,
                ['shoes_1'] = 55, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['chain_1'] = 97, ['chain_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end
        end)
      elseif (PlayerData.job.grade_name == "stagiaire") then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          if skin.sex == 0 then
                local clothesSkin = {
                ['tshirt_1'] = 72, ['tshirt_2'] = 5,
                ['torso_1'] = 249, ['torso_2'] = 0,
                ['decals_1'] = 59, ['decals_2'] = 0,
                ['bproof_1'] = 13, ['bproof_2'] = 0,
                ['arms'] = 75,
                ['pants_1'] = 24, ['pants_2'] = 5,
                ['shoes_1'] = 8, ['shoes_2'] = 0,
                ['helmet_1'] = 9, ['helmet_2'] = 5,
                ['chain_1'] = 127, ['chain_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          else
                local clothesSkin = {
                ['tshirt_1'] = 14, ['tshirt_2'] = 0,
                ['torso_1'] = 257, ['torso_2'] = 0,
                ['decals_1'] = 67, ['decals_2'] = 0,
                ['bproof_1'] = 14, ['bproof_2'] = 0,
                ['arms'] = 101,
                ['pants_1'] = 37, ['pants_2'] = 5,
                ['shoes_1'] = 10, ['shoes_2'] = 1,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['chain_1'] = 97, ['chain_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end
        end)
		
		 
      end
		end
				
		


      end
	  

      CurrentAction     = 'ambulance_actions_menu'
      CurrentActionMsg  = Ftext_esx_ambulancejob('open_menu')
      CurrentActionData = {}

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function EMS_EMS_OpenVehicleSpawnerMenu2()

ESX.UI.Menu.CloseAll()

ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner2',
      {
        title    = Ftext_esx_ambulancejob('veh_menu'),
        align = 'right',
        elements = {
			{label = "Helico", value = 'maverick2'},
        },
      },
      function(data, menu)
        menu.close()
        local model = data.current.value
		
        if not IsAnyVehicleNearPoint(Config_esx_ambulancejob.Zones.VehicleSpawnPoint2.Pos.x, Config_esx_ambulancejob.Zones.VehicleSpawnPoint2.Pos.y, Config_esx_ambulancejob.Zones.VehicleSpawnPoint2.Pos.z, 5.0) then
		
			local model = 'maverick2'
			local vehicle = GetHashKey(model)

			ESX.Game.SpawnVehicle(model, Config_esx_ambulancejob.Zones.VehicleSpawnPoint2.Pos, 341.95, function(vehicle)


			if model == 'maverick2' then
							SetVehicleModKit(vehicle, 0)
              SetVehicleLivery(vehicle, 2)
			end

			TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
			EMS_SetVehicleMaxMods(vehicle)
			local plate = GetVehicleNumberPlateText(vehicle)
			TriggerServerEvent("ls:mainCheck", plate, vehicle, true)


			end)

		end


end,
      function(data, menu)
        menu.close()
        CurrentAction     = 'vehicle_spawner_menu2'
        CurrentActionMsg  = Ftext_esx_ambulancejob('veh_spawn')
        CurrentActionData = {}
      end
    )

end

function EMS_OpenVehicleSpawnerMenu()

  ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = Ftext_esx_ambulancejob('veh_menu'),
        align = 'right',
        elements = {
			{label = "Hélicoptère",  value = 'maverick2'},
        },
      },
      function(data, menu)
        menu.close()
        local model = data.current.value
		
        ESX.Game.SpawnVehicle(model, Config_esx_ambulancejob.HelicopterSpawner.SpawnPoint, 0.0, function(vehicle)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		  
			EMS_SetVehicleMaxMods(vehicle)
			
			if model == 'speedobox' then
				SetVehicleLivery(vehicle, 11)
			end
			
			if model == 'ems' then
				SetVehicleAudio(vehicle, "fbi")
			end
			
			local rand = math.random(1000,9999)
			SetVehicleNumberPlateText(vehicle, "AMBU" .. rand)
			TriggerEvent('esx_vehiclelock:givekey', "AMBU" .. rand)
			
		end)


end,
      function(data, menu)
        menu.close()
        CurrentAction     = 'vehicle_spawner_menu'
        CurrentActionMsg  = Ftext_esx_ambulancejob('veh_spawn')
        CurrentActionData = {}
      end
    )
end

function EMS_OpenPharmacyMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pharmacy',
        {
            title    = Ftext_esx_ambulancejob('pharmacy_menu_title'),
            align = 'right',
            elements = {
                --{label = Ftext_esx_ambulancejob('pharmacy_take') .. ' ' .. _('defibrillateur'),  value = 'defibrillateur'},
                {label = Ftext_esx_ambulancejob('pharmacy_take') .. ' ' .. 'medikit',  value = 'medikit'},
                {label = Ftext_esx_ambulancejob('pharmacy_take') .. ' ' .. 'bandage',  value = 'bandage'},
				        {label = Ftext_esx_ambulancejob('pharmacy_take') .. ' ' .. "Médicaments",  value = 'medicaments'},
                {label = Ftext_esx_ambulancejob('pharmacy_take') .. ' ' .. "Xanax",  value = 'xanax'}
            },
        },
        function(data, menu)
            TriggerServerEvent('esx_ambulancejob:giveItem', data.current.value)
        end,
        function(data, menu)
            menu.close()
            CurrentAction     = 'pharmacy'
            CurrentActionMsg  = Ftext_esx_ambulancejob('open_pharmacy')
            CurrentActionData = {}
        end
    )
end

function EMS_OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_ambulancejob:getStockItems', function(items)

    local elements = {}

    for i=1, #items, 1 do
      local check = true 

      for y=1, #items, 1 do
        if (y ~= i and y > i) and items[y].label == items[i].label then
          check = false
          break
        end
      end

      if check and items[i].count > 0 then
        table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = Ftext_esx_ambulancejob('ambulance_stock'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = Ftext_esx_ambulancejob('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_ambulancejob('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              EMS_OpenGetStocksMenu()

              TriggerServerEvent('esx_ambulancejob:getStockItem', itemName, count)
			  TriggerServerEvent('emsbot:GetStocks', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function EMS_OpenPutStocksMenu()

ESX.TriggerServerCallback('esx_ambulancejob:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = Ftext_esx_ambulancejob('inventory'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = Ftext_esx_ambulancejob('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_ambulancejob('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              EMS_OpenPutStocksMenu()

              TriggerServerEvent('esx_ambulancejob:putStockItems', itemName, count)
			  TriggerServerEvent('emsbot:PutStocks', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function EMS_OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_ambulancejob:getVaultWeapons', function(weapons)

    local elements = {}

    for i=1, #weapons, 1 do
      local check = true

      for y=1, #weapons, 1 do
        if (y ~= i and y > i) and weapons[y].name == weapons[i].name then
          check = false
          break
        end
      end

      if check and weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault_get_weapon',
      {
        title    = Ftext_esx_ambulancejob('get_weapon_menu'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_ambulancejob:removeVaultWeapon', function()
          EMS_OpenGetWeaponMenu()
		  TriggerServerEvent('emsbot:GetWeapon', data.current.value)
        end, data.current.value, ESX.GetWeaponLabel(data.current.value))

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function EMS_OpenPutWeaponMenu()

  local elements   = {}

  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPONFtext_esx_ambulancejobNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'vault_put_weapon',
    {
      title    = Ftext_esx_ambulancejob('put_weapon_menu'),
      align = 'right',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_ambulancejob:addVaultWeapon', function()
        EMS_OpenPutWeaponMenu()
		TriggerServerEvent('emsbot:PutWeapon', data.current.value)
      end, data.current.value, ESX.GetWeaponLabel(data.current.value))

    end,
    function(data, menu)
      menu.close()
    end
  )

end


AddEventHandler('playerSpawned', function()

  IsDead = false

  if FirstSpawn then
    exports.spawnmanager:setAutoSpawn(false)
    FirstSpawn = false
  end

end)

RegisterNetEvent('esx:setService')
AddEventHandler('esx:setService', function(job, service)
	if (PlayerData.job ~= nil and PlayerData.job.name == 'ambulance') or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'ambulance') then
		TriggerServerEvent("emsbot:service", service)
	end
	if (PlayerData.job ~= nil and PlayerData.job.name == 'ambulance') or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'ambulance') then
		TriggerServerEvent("emsbot:service", service)
	end
end)


RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

  local specialContact = {
    name       = 'Ambulance',
    number     = 'ambulance',
    base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAABp5JREFUWIW1l21sFNcVhp/58npn195de23Ha4Mh2EASSvk0CPVHmmCEI0RCTQMBKVVooxYoalBVCVokICWFVFVEFeKoUdNECkZQIlAoFGMhIkrBQGxHwhAcChjbeLcsYHvNfsx+zNz+MBDWNrYhzSvdP+e+c973XM2cc0dihFi9Yo6vSzN/63dqcwPZcnEwS9PDmYoE4IxZIj+ciBb2mteLwlZdfji+dXtNU2AkeaXhCGteLZ/X/IS64/RoR5mh9tFVAaMiAldKQUGiRzFp1wXJPj/YkxblbfFLT/tjq9/f1XD0sQyse2li7pdP5tYeLXXMMGUojAiWKeOodE1gqpmNfN2PFeoF00T2uLGKfZzTwhzqbaEmeYWAQ0K1oKIlfPb7t+7M37aruXvEBlYvnV7xz2ec/2jNs9kKooKNjlksiXhJfLqf1PXOIU9M8fmw/XgRu523eTNyhhu6xLjbSeOFC6EX3t3V9PmwBla9Vv7K7u85d3bpqlwVcvHn7B8iVX+IFQoNKdwfstuFtWoFvwp9zj5XL7nRlPXyudjS9z+u35tmuH/lu6dl7+vSVXmDUcpbX+skP65BxOOPJA4gjDicOM2PciejeTwcsYek1hyl6me5nhNnmwPXBhjYuGC699OpzoaAO0PbYJSy5vgt4idOPrJwf6QuX2FO0oOtqIgj9pDU5dCWrMlyvXf86xsGgHyPeLos83Brns1WFXLxxgVBorHpW4vfQ6KhkbUtCot6srns1TLPjNVr7+1J0PepVc92H/Eagkb7IsTWd4ZMaN+yCXv5zLRY9GQ9xuYtQz4nfreWGdH9dNlkfnGq5/kdO88ekwGan1B3mDJsdMxCqv5w2Iq0khLs48vSllrsG/Y5pfojNugzScnQXKBVA8hrX51ddHq0o6wwIlgS8Y7obZdUZVjOYLC6e3glWkBBVHC2RJ+w/qezCuT/2sV6Q5VYpowjvnf/iBJJqvpYBgBS+w6wVB5DLEOiTZHWy36nNheg0jUBs3PoJnMfyuOdAECqrZ3K7KcACGQp89RAtlysCphqZhPtRzYlcPx+ExklJUiq0le5omCfOGFAYn3qFKS/fZAWS7a3Y2wa+GJOEy4US+B3aaPUYJamj4oI5LA/jWQBt5HIK5+JfXzZsJVpXi/ac8+mxWIXWzAG4Wb4g/jscNMp63I4U5FcKaVvsNyFALokSA47Kx8PVk83OabCHZsiqwAKEpjmfUJIkoh/R+L9oTpjluhRkGSPG4A7EkS+Y3HZk0OXYpIVNy01P5yItnptDsvtIwr0SunqoVP1GG1taTHn1CloXm9aLBEIEDl/IS2W6rg+qIFEYR7+OJTesqJqYa95/VKBNOHLjDBZ8sDS2998a0Bs/F//gvu5Z9NivadOc/U3676pEsizBIN1jCYlhClL+ELJDrkobNUBfBZqQfMN305HAgnIeYi4OnYMh7q/AsAXSdXK+eH41sykxd+TV/AsXvR/MeARAttD9pSqF9nDNfSEoDQsb5O31zQFprcaV244JPY7bqG6Xd9K3C3ALgbfk3NzqNE6CdplZrVFL27eWR+UASb6479ULfhD5AzOlSuGFTE6OohebElbcb8fhxA4xEPUgdTK19hiNKCZgknB+Ep44E44d82cxqPPOKctCGXzTmsBXbV1j1S5XQhyHq6NvnABPylu46A7QmVLpP7w9pNz4IEb0YyOrnmjb8bjB129fDBRkDVj2ojFbYBnCHHb7HL+OC7KQXeEsmAiNrnTqLy3d3+s/bvlVmxpgffM1fyM5cfsPZLuK+YHnvHELl8eUlwV4BXim0r6QV+4gD9Nlnjbfg1vJGktbI5UbN/TcGmAAYDG84Gry/MLLl/zKouO2Xukq/YkCyuWYV5owTIGjhVFCPL6J7kLOTcH89ereF1r4qOsm3gjSevl85El1Z98cfhB3qBN9+dLp1fUTco+0OrVMnNjFuv0chYbBYT2HcBoa+8TALyWQOt/ImPHoFS9SI3WyRajgdt2mbJgIlbREplfveuLf/XXemjXX7v46ZxzPlfd8YlZ01My5MUEVdIY5rueYopw4fQHkbv7/rZkTw6JwjyalBCHur9iD9cI2mU0UzD3P9H6yZ1G5dt7Gwe96w07dl5fXj7vYqH2XsNovdTI6KMrlsAXhRyz7/C7FBO/DubdVq4nBLPaohcnBeMr3/2k4fhQ+Uc8995YPq2wMzNjww2X+vwNt1p00ynrd2yKDJAVN628sBX1hZIdxXdStU9G5W2bd9YHR5L3f/CNmJeY9G8WAAAAAElFTkSuQmCC'
  }

  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('baseevents:onPlayerDied', function(killerType, coords)
  EMS_OnPlayerDeath()
end)

AddEventHandler('baseevents:onPlayerKilled', function(killerId, data)
  EMS_OnPlayerDeath()
end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()

  Citizen.CreateThread(function()

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
      Citizen.Wait(10)
    end
	
    ESX.SetPlayerData('coords', {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })

    TriggerServerEvent('esx:updateCoords', {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })

    EMS_RespawnPed(playerPed, {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })

    StopScreenEffect('DeathFailOut')

    DoScreenFadeIn(800)

  end)
  TriggerEvent('esx_hospital:setInjured', false)
  TriggerServerEvent('esx_ambulancejob:isalife', 1)
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(zone, second)	

  CurrentSecond = nil


  if zone == 'AmbulanceActions' then
    CurrentAction     = 'ambulance_actions_menu'
    CurrentActionMsg  = Ftext_esx_ambulancejob('open_menu')
    CurrentActionData = {}
  end

  if zone == 'AmbulanceActions2' then
    CurrentAction     = 'ambulance_actions_menu'
    CurrentActionMsg  = Ftext_esx_ambulancejob('open_menu')
    CurrentActionData = {}
    CurrentSecond = second
  end
  
  if zone == 'Pharmacy' then
    CurrentAction     = 'pharmacy'
    CurrentActionMsg  = Ftext_esx_ambulancejob('open_menu')
    CurrentActionData = {}
  end

  if zone == 'VehicleSpawner' then
	print("VehicleSpanwer - current action")
    CurrentAction     = 'vehicle_spawner_menu'
    CurrentActionMsg  = Ftext_esx_ambulancejob('veh_spawn')
    CurrentActionData = {}
  end

  if zone == 'VehicleSpawner2' then
    print("VehicleSpanwer2 - current action")
      CurrentAction     = 'vehicle_spawner_menu2'
      CurrentActionMsg  = Ftext_esx_ambulancejob('veh_spawn')
      CurrentActionData = {}
  end

end)

function EMS_FastTravel(pos)
    TeleportFadeEffect(playerPed, pos)
end

AddEventHandler('esx_ambulancejob:hasExitedMarker', function(zone)
    if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
    CurrentSecond = nil
	end
end)

-- Create blips
Citizen.CreateThread(function()
  for k,v in pairs(Config_esx_ambulancejob.Blip) do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		  SetBlipSprite (blip, 61)
		  SetBlipDisplay(blip, 4)
		  SetBlipScale  (blip, 0.8)
		  SetBlipAsShortRange(blip, true)
		  SetBlipColour(blip, 3)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString("Hopital Gordon McMillen Reed")
		  EndTextCommandSetBlipName(blip)
  end
end)

-- Display markers
function ambulance02()
    
    for k,v in pairs(Config_esx_ambulancejob.Zones) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_esx_ambulancejob.DrawDistance) then
                if (PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'ambulance' and PlayerData.job2.service == 1) then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                  elseif k ~= 'AmbulanceActions' and k ~= 'AmbulanceActions2' and k ~= 'VehicleSpawner' --[[and k ~= 'VehicleSpawner2' and k ~= 'VehicleDeleter']]
                  and k ~= 'Pharmacy' and k ~= 'StairsGoTopBottom' and k ~= 'StairsGoBottomTop' then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                end
      end
    end
end

-- Activate menu when player is inside marker
function ambulance01()
    
    local isInMarker  = false
    local currentZone = nil
    for k,v in pairs(Config_esx_ambulancejob.Zones) do
      if (PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'ambulance' and PlayerData.job2.service == 1) then
        if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2.0) then
          isInMarker  = true
          currentZone = k
          second = v.Second
        end
      elseif k ~= 'AmbulanceActions' and k ~= 'AmbulanceActions2' and k ~= 'VehicleSpawner' --[[and k ~= 'VehicleSpawner2' and k ~= 'VehicleDeleter']]
        and k ~= 'Pharmacy' and k ~= 'StairsGoTopBottom' and k ~= 'StairsGoBottomTop' then
          if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2.0) then
            isInMarker  = true
            currentZone = k
            second = v.Second
          end
      end
    end
    if isInMarker and not hasAlreadyEnteredMarker then
      hasAlreadyEnteredMarker = true
      lastZone                = currentZone
	  print("Entered : " .. currentZone)
      TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentZone, second)
    end
    if not isInMarker and hasAlreadyEnteredMarker then
      hasAlreadyEnteredMarker = false
      TriggerEvent('esx_ambulancejob:hasExitedMarker', lastZone)
    end
end

----------------------------------------------
------------- AMBULANCE MISSIONS -------------
----------------------------------------------

function AmbulanceMission()
  repeat
    if OnJob then
      local PlayerCoords = GetEntityCoords(playerPed)
      sleepThread = 20
      if CurrentCustomer == nil then

        TriggerServerEvent('esx_ambulancejob:checkForLimitation')
          WaitingForLimitationReach = true
          while WaitingForLimitationReach do
            Wait(500)
          end
          if CanAskForNewJob == false then
            EMS_StopAmbulanceJob(true)
            do return end
          end

        local vehicle = GetVehiclePedIsIn(playerPed,true)
        vehicle = GetEntityModel(vehicle)
        if Config_esx_ambulancejob.JobsVehicles[vehicle] and GetEntitySpeed(playerPed) > 0 then
          TriggerEvent('Core:ShowAdvancedNotification', "~r~Centrale EMS", "~y~Patrouille EMS", Ftext_esx_ambulancejob('drive_search_pass'), 'CHAR_CALL911', 0, false, false, 2)
          
          Citizen.Wait(30000)

          PlayerCoords = GetEntityCoords(playerPed)

          while OnJob and (GetDistanceBetweenCoords(PlayerCoords, LastCustomerCoords) < 500) or (GetDistanceBetweenCoords(PlayerCoords, EmergencyCoords) < 500) do
            PlayerCoords = GetEntityCoords(playerPed)
            Citizen.Wait(1000)
          end

          if OnJob and Config_esx_ambulancejob.JobsVehicles[vehicle] and GetEntitySpeed(playerPed) > 0 then

            CurrentCustomer = EMS_GetRandomWalkingNPC()

            if CurrentCustomer ~= nil then
              CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)
              LastCustomerCoords = GetEntityCoords(CurrentCustomer)

              SetBlipAsFriendly(CurrentCustomerBlip, 1)
              SetBlipColour(CurrentCustomerBlip, 2)
              SetBlipCategory(CurrentCustomerBlip, 3)
              SetBlipRoute(CurrentCustomerBlip,  true)
              local standTime = 30000

              ClearPedTasksImmediately(CurrentCustomer)
              SetBlockingOfNonTemporaryEvents(CurrentCustomer, 1)    
              TaskStandGuard(CurrentCustomer, LastCustomerCoords, 1, 'PROP_HUMAN_STAND_IMPATIENT')
              SetPedMovementClipset(CurrentCustomer, "move_m@injured", 0.2)
              TriggerEvent('Core:ShowAdvancedNotification', "~r~Centrale EMS", "~y~Patrouille EMS", Ftext_esx_ambulancejob('customer_found'), 'CHAR_CALL911', 1, false, false, 150)
              while OnJob and not IsNearCustomer and CurrentCustomer ~= nil do
                PlayerCoords = GetEntityCoords(playerPed)
                local CurrentCustomerCoords = GetEntityCoords(CurrentCustomer)
                if GetDistanceBetweenCoords(PlayerCoords, CurrentCustomerCoords) < 3 then
                  SetEntityAsMissionEntity(CurrentCustomer,  false, false)
                  SetPedMovementClipset(CurrentCustomer, "anim_group_move_ballistic", 0.2)
                  IsNearCustomer = true
                end
                if CurrentCustomerCoords == vector3(0,0,0) then
                  LastCustomerCoords = EmergencyCoords
                  CurrentCustomer = nil
                  TriggerEvent('Core:ShowAdvancedNotification', "~r~Centrale EMS", "~y~Patrouille EMS", Ftext_esx_ambulancejob('client_ano'), 'CHAR_CALL911', 1, false, false, 150)
                end
                Wait(500)
              end
            end

          end

        end

      else

        if IsPedFatallyInjured(CurrentCustomer) then
          ESX.ShowNotification(Ftext_esx_ambulancejob('client_unconcious'))

          if DoesBlipExist(CurrentCustomerBlip) then
            RemoveBlip(CurrentCustomerBlip)
          end

          if DoesBlipExist(DestinationBlip) then
            RemoveBlip(DestinationBlip)
          end

          SetEntityAsMissionEntity(CurrentCustomer,  false, true)

          CurrentCustomer           = nil
          CurrentCustomerBlip       = nil
          DestinationBlip           = nil
          IsNearCustomer            = false
          CustomerIsEnteringVehicle = false
          CustomerEnteredVehicle    = false
          TargetCoords              = nil

        end

        if IsPedInAnyVehicle(playerPed,  false) then

          local vehicle          = GetVehiclePedIsIn(playerPed,  false)
          playerCoords     = coords
          local customerCoords   = GetEntityCoords(CurrentCustomer)
          local customerDistance = GetDistanceBetweenCoords(playerCoords.x,  playerCoords.y,  playerCoords.z,  customerCoords.x,  customerCoords.y,  customerCoords.z)

          if IsPedSittingInVehicle(CurrentCustomer,  vehicle) then

            if CustomerEnteredVehicle then

              local targetDistance = GetDistanceBetweenCoords(playerCoords.x,  playerCoords.y,  playerCoords.z,  TargetCoords.x,  TargetCoords.y,  TargetCoords.z)

              if targetDistance <= 5.0 then

                TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)

                TriggerEvent('Core:ShowAdvancedNotification', "~r~Centrale EMS", "~y~Patrouille EMS", Ftext_esx_ambulancejob('arrive_dest'), 'CHAR_CALL911', 1, false, false, 150)

                SetEntityAsMissionEntity(CurrentCustomer,  false, true)
                TaskGoStraightToCoord(CurrentCustomer,  EmergencyCoords,  1.0,  -1,  0.0,  0.0)

                TriggerServerEvent('esx_ambulancejob:success')

                RemoveBlip(DestinationBlip)

                Wait(10000)
                DeleteEntity(CurrentCustomer)

                CurrentCustomer           = nil
                CurrentCustomerBlip       = nil
                DestinationBlip           = nil
                IsNearCustomer            = false
                CustomerIsEnteringVehicle = false
                CustomerEnteredVehicle    = false
                TargetCoords              = nil

              end

              if TargetCoords ~= nil then
                DrawMarker(1, TargetCoords.x, TargetCoords.y, TargetCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
              end

            else

              RemoveBlip(CurrentCustomerBlip)

              CurrentCustomerBlip = nil

              TargetCoords = {x = -668.71,y = 294.59,z = 81.72 }

              TriggerEvent('Core:ShowAdvancedNotification', "~r~Centrale EMS", "~y~Patrouille EMS", Ftext_esx_ambulancejob('take_me_to_emergency'), 'CHAR_CALL911', 1, false, false, 150)

              DestinationBlip = AddBlipForCoord(TargetCoords.x, TargetCoords.y, TargetCoords.z)

              BeginTextCommandSetBlipName("STRING")
              AddTextComponentString("Destination")
              EndTextCommandSetBlipName(blip)

              SetBlipRoute(DestinationBlip,  true)

              CustomerEnteredVehicle = true
            end

          else

            DrawMarker(1, customerCoords.x, customerCoords.y, customerCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)

            if not CustomerEnteredVehicle then

              if customerDistance <= 30.0 then

                if not IsNearCustomer then
                  ESX.ShowNotification(Ftext_esx_ambulancejob('close_to_client'))
                  IsNearCustomer = true
                end

              end

              if customerDistance <= 100.0 then

                if not CustomerIsEnteringVehicle then

                  ClearPedTasksImmediately(CurrentCustomer)

                  local seat = 2

                  for i=4, 0, 1 do
                    if IsVehicleSeatFree(vehicle,  seat) then
                      seat = i
                      break
                    end
                  end

                  TaskEnterVehicle(CurrentCustomer,  vehicle,  -1,  seat,  2.0,  1)
                  CustomerIsEnteringVehicle = true

                end

              end

            end

          end

        else
          
        TriggerEvent('Core:ShowAdvancedNotification', "~r~Centrale EMS", "~y~Patrouille EMS", Ftext_esx_ambulancejob('return_to_veh'), 'CHAR_CALL911', 1, false, false, 150)

        end

      end

    end
    Wait(0)
  until not OnJob Wait(0)
end
----------------------------------------------
----------------------------------------------

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
function ambulance04()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'ambulance' and PlayerData.job2.service == 1) then
    
    
    if GetDistanceBetweenCoords(coords,  Config_esx_ambulancejob.Zones.AmbulanceActions.Pos.x, Config_esx_ambulancejob.Zones.AmbulanceActions.Pos.y, Config_esx_ambulancejob.Zones.AmbulanceActions.Pos.z,  true) < 2.0 then
      sleepThread = 20
      DrawText3Ds(Config_esx_ambulancejob.Zones.AmbulanceActions.Pos.x, Config_esx_ambulancejob.Zones.AmbulanceActions.Pos.y, Config_esx_ambulancejob.Zones.AmbulanceActions.Pos.z + 1, 'Appuyez sur ~r~E~s~ pour acceder au menu')
    end

    if GetDistanceBetweenCoords(coords,  Config_esx_ambulancejob.Zones.AmbulanceActions2.Pos.x, Config_esx_ambulancejob.Zones.AmbulanceActions2.Pos.y, Config_esx_ambulancejob.Zones.AmbulanceActions2.Pos.z,  true) < 2.0 then
      sleepThread = 20
      DrawText3Ds(Config_esx_ambulancejob.Zones.AmbulanceActions2.Pos.x, Config_esx_ambulancejob.Zones.AmbulanceActions2.Pos.y, Config_esx_ambulancejob.Zones.AmbulanceActions2.Pos.z + 1, 'Appuyez sur ~r~E~s~ pour acceder au menu')
    end

    if GetDistanceBetweenCoords(coords,  Config_esx_ambulancejob.Zones.Pharmacy.Pos.x,  Config_esx_ambulancejob.Zones.Pharmacy.Pos.y,  Config_esx_ambulancejob.Zones.Pharmacy.Pos.z,  true) < 2.0 then
      sleepThread = 20
      DrawText3Ds(Config_esx_ambulancejob.Zones.Pharmacy.Pos.x,  Config_esx_ambulancejob.Zones.Pharmacy.Pos.y,  Config_esx_ambulancejob.Zones.Pharmacy.Pos.z  + 1, 'Appuyez sur ~r~E~s~ pour acceder à la pharmacie')
    end

    if GetDistanceBetweenCoords(coords,  Config_esx_ambulancejob.HelicopterSpawner.PointBlip.x,  Config_esx_ambulancejob.HelicopterSpawner.PointBlip.y,  Config_esx_ambulancejob.HelicopterSpawner.PointBlip.z,  true) < 2.0 then
      sleepThread = 20
      DrawText3Ds(Config_esx_ambulancejob.HelicopterSpawner.PointBlip.x,  Config_esx_ambulancejob.HelicopterSpawner.PointBlip.y,  Config_esx_ambulancejob.HelicopterSpawner.PointBlip.z  + 1, 'Appuyez sur ~r~E~s~ pour sortir ou ranger ou sortir un hélicoptère')
    end
        
    if GetDistanceBetweenCoords(coords,  Config_esx_ambulancejob.HelicopterSpawner2.PointBlip.x,  Config_esx_ambulancejob.HelicopterSpawner2.PointBlip.y,  Config_esx_ambulancejob.HelicopterSpawner2.PointBlip.z,  true) < 3.0 then
      sleepThread = 20
      DrawText3Ds(Config_esx_ambulancejob.HelicopterSpawner2.PointBlip.x,  Config_esx_ambulancejob.HelicopterSpawner2.PointBlip.y,  Config_esx_ambulancejob.HelicopterSpawner2.PointBlip.z  + 1, 'Appuyez sur ~r~E~s~ pour sortir ou ranger un hélicoptère')
    end
    end
end

-- Key Controls
function ambulance03()
    if CurrentAction ~= nil then

      if IsControlJustReleased(0, Keys['BACKSPACE']) then
        ESX.UI.Menu.CloseAll()
        CurrentAction = nil
      end
	  
      if IsControlJustReleased(0, Keys['E']) then

		if(PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'ambulance' and PlayerData.job2.service == 1) then
			if CurrentAction == 'ambulance_actions_menu' then
			  EMS_OpenAmbulanceActionsMenu()
			end
		
      if CurrentAction == 'vehicle_spawner_menu' then
        if IsPedInAnyVehicle(playerPed) then
          SetEntityAsMissionEntity(GetVehiclePedIsUsing(playerPed), true, true)
          DeleteVehicle(GetVehiclePedIsUsing(playerPed), false)
        else
          local model = 'maverick2'
          local vehicle = GetHashKey(model)

          ESX.Game.SpawnVehicle(model,  Config_esx_ambulancejob.HelicopterSpawner.SpawnPoint, Config_esx_ambulancejob.HelicopterSpawner.Heading, function(vehicle)
            if model == 'maverick2' then
              SetVehicleModKit(vehicle, 0)
              SetVehicleLivery(vehicle, 2)
            end
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            EMS_SetVehicleMaxMods(vehicle)
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent("ls:mainCheck", plate, vehicle, true)
          end)
        end
			end
			
      if CurrentAction == 'vehicle_spawner_menu2' then
        if IsPedInAnyVehicle(playerPed) then
          SetEntityAsMissionEntity(GetVehiclePedIsUsing(playerPed), true, true)
          DeleteVehicle(GetVehiclePedIsUsing(playerPed), false)
        else
          local model = 'maverick2'
          local vehicle = GetHashKey(model)

          ESX.Game.SpawnVehicle(model,  Config_esx_ambulancejob.HelicopterSpawner2.SpawnPoint, Config_esx_ambulancejob.HelicopterSpawner2.Heading, function(vehicle)
            if model == 'maverick2' then
              SetVehicleModKit(vehicle, 0)
              SetVehicleLivery(vehicle, 2)
            end
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            EMS_SetVehicleMaxMods(vehicle)
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent("ls:mainCheck", plate, vehicle, true)
          end)
        end
			end

			if CurrentAction == 'pharmacy' then
				EMS_OpenPharmacyMenu()
			end

			if CurrentAction == 'fast_travel_goto_top' or CurrentAction == 'fast_travel_goto_bottom' then
				EMS_FastTravel(CurrentActionData.pos)
			end

			if CurrentAction == 'delete_vehicle' then
			  local vehicle = GetVehiclePedIsIn(playerPed,  false)

			  ESX.Game.DeleteVehicle(vehicle)

			end
			
			if CurrentAction == 'delete_vehicle2' then

			  local vehicle = GetVehiclePedIsIn(playerPed,  false)

			  ESX.Game.DeleteVehicle(vehicle)

			end

			CurrentAction = nil
    end
      end

    end
end

---------------------------------------------------------------------------------------------------------
--NB : gestion des menu
---------------------------------------------------------------------------------------------------------

RegisterNetEvent('NB:openMenuDiablos')
AddEventHandler('NB:openMenuDiablos', function()
	OpenMafiaActionsMenu()
end)

-- String string
function stringsplit(inputstr, sep)
  if sep == nil then
      sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      t[i] = str
      i = i + 1
  end
  return t
end

RegisterNetEvent('esx_ambulancejob:receiveReset')
AddEventHandler('esx_ambulancejob:receiveReset', function(state, addTime)
	if state then
		bleedoutTimer = bleedoutTimer + addTime
	end
end)

RegisterNetEvent('esx_ambulancejob:openMenuJob')
AddEventHandler('esx_ambulancejob:openMenuJob', function()
	EMS_OpenMobileAmbulanceActionsMenu()
end)

function ambulance_IsInVehicle()
	local ply = playerPed
	if IsPedSittingInAnyVehicle(ply) then
		return true
	else
		return false
	end
end

RegisterNetEvent('esx_ambulancejob:responseCheckForLimitation')
AddEventHandler('esx_ambulancejob:responseCheckForLimitation', function(result)
    CanAskForNewJob = result == false
    if result then
      TriggerEvent('Core:ShowAdvancedNotification', "~r~Centrale EMS", "~y~Patrouille EMS", "Vous avez atteint le quota de course pour aujourd'hui. Recommencez demain", 'CHAR_CALL911', 1, false, false, 150)
    end
    WaitingForLimitationReach = false      
end)