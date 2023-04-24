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

function Ftext_esx_taxijob(txt)
	return Config_esx_taxijob.Txt[txt]
end


local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local OnJob                     = false
local CurrentCustomer           = nil
local CurrentCustomerBlip       = nil
local DestinationBlip           = nil
local IsNearCustomer            = false
local CustomerIsEnteringVehicle = false
local CustomerEnteredVehicle    = false
local TargetCoords              = nil
local notFindPosition           = false
local WaitingForLimitationReach = false
local CanAskForNewJob           = true
local ModelTaxi                 = GetHashKey('taxi')

-- INTERIM TAXI JOB VAR
local playerFacture = { }
local playerMission = { }

local playerPed = nil
local playerData = nil 
-- END INTERIM TAXI JOB VAR

GUI.Time                        = 0

function DrawSub(msg, time)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(msg)
  DrawSubtitleTimed(time, 1)
end

function ShowLoadingPromt(msg, time, type)
  Citizen.CreateThread(function()
    Citizen.Wait(1)
    N_0xaba17d7ce615adbf("STRING")
    AddTextComponentString(msg)
    N_0xbd12f8228410d9b4(type)
    Citizen.Wait(time)
    N_0x10d373323e5b9c0d()
  end)
end

function taxi_GetRandomWalkingNPC()

  local search = {}
  local peds   = ESX.Game.GetPeds()

  for i=1, #peds, 1 do
    if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
      table.insert(search, peds[i])
    end
  end

  if #search > 0 then
    return search[GetRandomIntInRange(1, #search)]
  end

  print('Using fallback code to find walking ped')

  for i=1, 250, 1 do

    local ped = GetRandomPedAtCoord(0.0,  0.0,  0.0,  math.huge + 0.0,  math.huge + 0.0,  math.huge + 0.0,  26)

    if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
      table.insert(search, ped)
    end

  end

  if #search > 0 then
    return search[GetRandomIntInRange(1, #search)]
  end

end

function taxi_ClearCurrentMission()

  if DoesBlipExist(CurrentCustomerBlip) then
    RemoveBlip(CurrentCustomerBlip)
  end

  if DoesBlipExist(DestinationBlip) then
    RemoveBlip(DestinationBlip)
  end

  if CurrentCustomer ~= nil then
    SetEntityAsNoLongerNeeded(CurrentCustomer)   
  end

  CurrentCustomer           = nil
  CurrentCustomerBlip       = nil
  DestinationBlip           = nil
  IsNearCustomer            = false
  CustomerIsEnteringVehicle = false
  CustomerEnteredVehicle    = false
  TargetCoords              = nil
  LastZone                  = nil
  OnJob                     = false
  notFindPosition           = false
end

function taxi_StartTaxiJob()

  ShowLoadingPromt(Ftext_esx_taxijob('taking_service') .. 'Taxi', 5000, 3)
  taxi_ClearCurrentMission()

  OnJob = true

end

function taxi_StopTaxiJob(isForce, ReachLimitWhenAsk)

  if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
    local vehicle = GetVehiclePedIsIn(playerPed,  false)
    TaskLeaveVehicle(CurrentCustomer,  vehicle, 0)
    Citizen.Wait(1500) -- wait ped got out and force close
    for i = 1, 3 do
      SetVehicleDoorShut(vehicle, i, false) 
    end    
    if CustomerEnteredVehicle then
      TaskGoStraightToCoord(CurrentCustomer,  TargetCoords.x,  TargetCoords.y,  TargetCoords.z,  1.0,  -1,  0.0,  0.0)
      SetEntityAsNoLongerNeeded(CurrentCustomer)
    end
  elseif not IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
    local lastPlayerVehicle = GetPlayersLastVehicle()
    if lastPlayerVehicle ~= nil then
      TaskLeaveVehicle(CurrentCustomer,  lastPlayerVehicle, 0)
      Citizen.Wait(1500) -- wait ped got out and force close

      for i = 1, 3 do
        SetVehicleDoorShut(lastPlayerVehicle, i, false) 
      end
      if CustomerEnteredVehicle then
        TaskGoStraightToCoord(CurrentCustomer,  TargetCoords.x,  TargetCoords.y,  TargetCoords.z,  1.0,  -1,  0.0,  0.0)
        SetEntityAsNoLongerNeeded(CurrentCustomer)
      end
    end
  end

  taxi_ClearCurrentMission()
  OnJob = false

  if not isForce and not ReachLimitWhenAsk then
    TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Course", Ftext_esx_taxijob('mission_complete'), 'CHAR_TAXI', 140)
  end
end

function taxi_SetWindowTint(vehicle)

  local props = {
    windowTint       = 1,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function taxi_OpenTaxiActionsMenu()

  local elements = {
    --{label = "Prise de service", value = "start_service"},
    --{label = "Fin de service", value = "end_service"},
      --{label = Ftext_esx_taxijob('spawn_veh'), value = 'spawn_vehicle'},
      {label = "Dressing", value = 'dressing'},
      {label = 'Ouvrir le stockage', value = 'get_stock'}
  }

  if (Config_esx_taxijob.EnablePlayerManagement and PlayerData.job ~= nil and (PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'coboss') and PlayerData.job.service == 1) or 
  (Config_esx_taxijob.EnablePlayerManagement and PlayerData.job2 ~= nil and (PlayerData.job2.grade_name == 'boss' or PlayerData.job2.grade_name == 'coboss') and PlayerData.job2.service == 1) then
    table.insert(elements, {label = Ftext_esx_taxijob('boss_actions'), value = 'boss_actions'})
  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'taxi_actions',
    {
      title    = 'Taxi',
	  align = 'right',
      elements = elements
    },
    function(data, menu)

	  if data.current.value == 'start_service' then
        TriggerServerEvent("player:serviceOn", "taxi")
        --TriggerServerEvent('duty:taxi')
		TriggerEvent('esx:showNotification', "~g~Prise de service")
		TriggerServerEvent('taxibot:service', true)
      end
	  if data.current.value == 'end_service' then
        TriggerServerEvent("player:serviceOff", "taxi")
        --TriggerServerEvent('duty:taxi')
		TriggerEvent('esx:showNotification', "~r~Fin de service")
		TriggerServerEvent('taxibot:service', false)
      end

      if data.current.value == 'dressing' then
        taxi_OpenRoomMenu()
      end
	
      if data.current.value == 'get_stock' then
        TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_taxi')
        menu.close()
      end

  if data.current.value == 'spawn_vehicle' then

		ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = "Vehicule de disponnible",
        align = 'right',
        elements = {
          {label = "Taxi",  value = 'taxi'},
		  --{label = "Taxi 2", value = 'taxi4'},
		  --{label = "Taxi 3", value = 'taxi5'},
		  --{label = "Taxi 4", value = 'cabby'},
          {label = "Jackal", value = 'taxi3'},
          {label = "Baller", value = 'taxi2'},
		  --{label = "PMP600", value = 'pmp600'},
		  {label = "Limousine", value = 'stretch'},
          {label = "Patriot Limo", value = 'patriot2'},
		  {label = "Mercedes E63", value = 'e63taxi'},
		  {label = "BMW M5", value = 'm5taxi'},
        },
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        ESX.Game.SpawnVehicle(model, Config_esx_taxijob.Zones.VehicleSpawnPoint.Pos, 327.70, function(vehicle)

		  if model == 'pmp600' or model == 'patriot2' or model == 'stretch' then
			taxi_SetWindowTint(vehicle)
		  end
		  
          if model == 'taxi3' then
            SetVehicleLivery(vehicle, 2)
            SetVehicleModKit(vehicle, 0)
            SetVehicleColours(vehicle, 88, 88)
          end
          
          if model == 'taxi2' then
            SetVehicleLivery(vehicle, 1)
            SetVehicleModKit(vehicle, 0)
            SetVehicleColours(vehicle, 88, 88)
          end

          TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
          --SetVehicleMaxMods(vehicle)
          local rand = math.random(1000,9999)
          SetVehicleNumberPlateText(vehicle, "Taxi" .. rand)
          local plate = GetVehicleNumberPlateText(vehicle)
          TriggerEvent('esx_vehiclelock:givekey', "Taxi" .. rand)
		  --TriggerServerEvent('taxibot:service', true)

		  WashDecalsFromVehicle(vehicle)
		  SetVehicleDirtLevel(vehicle)
        end)

		ESX.UI.Menu.CloseAll()

      end,
      function(data, menu)

        menu.close()
        ESX.UI.Menu.CloseAll()

        CurrentAction     = ''
        CurrentActionMsg  = ''
        CurrentActionData = {}

      end
    )


  end

      if data.current.value == 'boss_actions' then
        TriggerEvent('esx_society:openBossMenu', 'taxi', function(data, menu)
          menu.close()
        end)
      end

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'taxi_actions_menu'
      CurrentActionMsg  = Ftext_esx_taxijob('press_to_open')
      CurrentActionData = {}

    end
  )

end

function taxi_OpenRoomMenu()

  ESX.UI.Menu.CloseAll()

  local elements = {}

    table.insert(elements, {label = "Vêtements", value = 'player_dressing'})

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'roomZ',
    {
      title    = "Dressing",
      align = 'right',
      elements = elements,
    },
    function(data, menu)

      if data.current.value == 'player_dressing' then

        ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)

          local elements = {}

          for i=1, #dressing, 1 do
            table.insert(elements, {label = dressing[i], value = i})
          end

          table.sort(elements, function (x, y) return string.lower(x.label) < string.lower(y.label) end)

          ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'player_dressing',
            {
              title    = "Vêtements",
              align = 'right',
              elements = elements,
            },
            function(data, menu)

              TriggerEvent('skinchanger:getSkin', function(skin)

                ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)

                  TriggerEvent('skinchanger:loadClothes', skin, clothes)
                  TriggerEvent('esx_skin:setLastSkin', skin)

                  TriggerEvent('skinchanger:getSkin', function(skin)
                    TriggerServerEvent('esx_skin:save', skin)
                  end)

                end, data.current.value)

              end)

            end,
            function(data, menu)
              menu.close()
            end
          )

        end)

      end

    end,
    function(data, menu)

      menu.close()

    end
  )

end

function taxi_OpenMobileTaxiActionsMenu()

  ESX.UI.Menu.CloseAll()

  local elements = { }

  if not Config_esx_taxijob.interimJobConfiguration.isEnable then
    table.insert(elements,{label = Ftext_esx_taxijob('billing'), value = 'billing'})    
  else
    table.insert(elements,{label = Ftext_esx_taxijob('billing') .. ' [500$]', value = 'billingInterim'})    
  end
  
  table.insert(elements,{label = 'Course citoyenne', value = 'mission'})

  if not Config_esx_taxijob.interimJobConfiguration.isEnable then
    table.insert(elements,{label = '[---------] Regler le Compteur [---------]', value = 'lol'})
    table.insert(elements,{label = 'Afficher/Cacher le compteur', value = 'taxicompteur'})
    table.insert(elements,{label = 'Reset le compteur', value = 'taxireset'})
    table.insert(elements,{label = 'Start/Stop le compteur', value = 'taxifreeze'})
    table.insert(elements,{label = 'Prix de base', value = 'taxibase'})
    table.insert(elements,{label = 'Prix par minutes', value = 'taximin'})
  end		

  ESX.UI.Menu.Open(
  'default', GetCurrentResourceName(), 'mobile_taxi_actions',
  {
    title    = 'Taxi',
    align = 'right',
    elements = elements
  },
    function(data, menu)

      if data.current.value == 'taxicompteur' then
        TriggerEvent('esx_taxijob:taxicompteur')
      end
	if data.current.value == 'taxireset' then
		TriggerEvent('esx_taxijob:taxireset')
	end
	if data.current.value == 'taxifreeze' then
		TriggerEvent('esx_taxijob:taxifreeze')
	end
	if data.current.value == 'taxibase' then
		TriggerEvent('esx_taxijob:taxibase')
	end
	if data.current.value == 'taximin' then
		TriggerEvent('esx_taxijob:taximin')
	end

	if data.current.value == 'mission' then
		if OnJob then
      taxi_StopTaxiJob(false, false)
		else
			if (PlayerData.job ~= nil and PlayerData.job.name == 'taxi' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'taxi' and PlayerData.job2.service == 1) then
        if IsPedInAnyVehicle(playerPed, false) and (GetEntityModel(GetVehiclePedIsIn(playerPed, false)) == ModelTaxi) then
          taxi_StartTaxiJob()
          ESX.UI.Menu.CloseAll()
        else
          TriggerEvent('Core:ShowNotification', "~r~Vous devez être dans un véhicule officiel de TAXI pour débuter cette mission.")
				end
			end
		end
	end
	
      if data.current.value == 'billing' then

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'billing',
          {
            title = Ftext_esx_taxijob('invoice_amount')
          },
          function(data, menu)

            local amount = tonumber(data.value)

            if amount == nil then
              ESX.ShowNotification(Ftext_esx_taxijob('amount_invalid'))
            else

              menu.close()

              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification(Ftext_esx_taxijob('no_players_near'))
              else
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_taxi', 'Taxi', amount)
                TriggerServerEvent('CoreLog:SendDiscordLog', "Taxi - Factures", "**" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$"..amount.."`", "Yellow")
              end
            end
          end,
          function(data, menu)
            menu.close()
          end
        )

      end

      if data.current.value == 'billingInterim' then

        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        if closestPlayer == -1 or closestDistance > 3.0 then
          ESX.ShowNotification(Ftext_esx_taxijob('no_players_near'))
        else
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_taxi', 'Taxi', Config_esx_taxijob.interimJobConfiguration.jobBillingPrice)
          TriggerServerEvent('CoreLog:SendDiscordLog', "Taxi - Factures", "**" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `" .. Config_esx_taxijob.interimJobConfiguration.jobBillingPrice .."$` via la société de taxi en interim.", "Yellow")

          table.insert(playerFacture,  Config_esx_taxijob.interimJobConfiguration.jobBillingPrice)
          menu.close()
        end
      end
    end,
    function(data, menu)
      menu.close()
    end
  )

end

function taxi_OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_taxijob:getStockItems', function(items)

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
        title    = 'Taxi Stock',
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = Ftext_esx_taxijob('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_taxijob('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              taxi_OpenGetStocksMenu()

              TriggerServerEvent('esx_taxijob:getStockItem', itemName, count)
			  
			  TriggerServerEvent('taxibot:GetStocks', itemName, count)
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

function taxi_OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_taxijob:getPlayerInventory', function(inventory)

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
        title    = Ftext_esx_taxijob('inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = Ftext_esx_taxijob('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_taxijob('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              taxi_OpenPutStocksMenu()

              TriggerServerEvent('esx_taxijob:putStockItems', itemName, count)
			  
			  TriggerServerEvent('taxibot:PutStocks', itemName, count)
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

AddEventHandler('esx_taxijob:hasEnteredMarker', function(zone)

  if zone == 'TaxiActions' then
    CurrentAction     = 'taxi_actions_menu'
    CurrentActionMsg  = Ftext_esx_taxijob('press_to_open')
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_taxijob:hasExitedMarker', function(zone)
	if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

  local specialContact = {
    name       = 'Taxi',
    number     = 'taxi',
    base64Icon = 'data:image/png;base64,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',
  }

  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

-- Create Blips
Citizen.CreateThread(function()

  local blip = AddBlipForCoord(Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.x, Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.y, Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.z)

  SetBlipSprite (blip, 198)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.6)
  SetBlipColour (blip, 5)
  SetBlipAsShortRange(blip, true)

  BeginTextCommandSetBlipName("STRING")
  if not Config_esx_taxijob.interimJobConfiguration.isEnable then
    AddTextComponentString("Taxi")
  else
    AddTextComponentString("Taxi interim")
  end
    
  EndTextCommandSetBlipName(blip)

end)

local function calculateInterimPay()
  local callFinish = false
  local totalAmountToPay = 0

  ESX.TriggerServerCallback('esx_taxijob:allInterimBillArePay', function(numberOfNonPayBill)
    local factureAmount = 0  
    if numberOfNonPayBill ~= nil and numberOfNonPayBill > 0 then
      if numberOfNonPayBill > #playerFacture then
        --ERROR BILLS NOT PAY > TO BILL GET
      else
        for _, value in ipairs(playerFacture) do
          factureAmount = tonumber(factureAmount) + tonumber(value)
        end
        local unpayBillAmount = numberOfNonPayBill * Config_esx_taxijob.interimJobConfiguration.jobBillingPrice
        factureAmount = factureAmount - unpayBillAmount
      end
    else
      for _, value in ipairs(playerFacture) do
        factureAmount = tonumber(factureAmount) + tonumber(value)
      end
    end
    
    local missionAmount = 0
    for _, value in ipairs(playerMission) do
      missionAmount = tonumber(missionAmount) + tonumber(value)
    end
    
    totalAmountToPay = missionAmount + (factureAmount * 0.4)
    callFinish = true
  end)

  while not callFinish do
    Citizen.Wait(100)
  end 
  
  return totalAmountToPay
end

local function SetInterimJob()
  local playerHasJob = (playerData.job ~= nil and playerData.job.name ~= 'unemployed');
  if not playerHasJob then
    ESX.TriggerServerCallback('esx_taxijob:setInterimJob', function(response) 
      if response then
        playerFacture = { }
        playerMission = { }
        local carmodel = Config_esx_taxijob.interimJobConfiguration.jobVehicleModel
        RequestModel(carmodel)
        while not HasModelLoaded(carmodel) do
            Citizen.Wait(0)
        end

        local vehicle = CreateVehicle(carmodel, Config_esx_taxijob.interimJobConfiguration.jobVehicleSpawn.Pos.x, Config_esx_taxijob.interimJobConfiguration.jobVehicleSpawn.Pos.y, Config_esx_taxijob.interimJobConfiguration.jobVehicleSpawn.Pos.z, Config_esx_taxijob.interimJobConfiguration.jobVehicleSpawn.heading, true, false)   
        SetModelAsNoLongerNeeded(carmodel)
        local retval = SetVehicleOnGroundProperly(vehicle)
        SetVehicleDirtLevel(vehicle)
        local prefix = math.random(10,99)
        local suffix = math.random(10,99)
        SetVehicleNumberPlateText(vehicle, prefix .. Config_esx_taxijob.interimJobConfiguration.plateText .. suffix);
        SetVehicleMaxSpeed(vehicle, 40.3)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Patron", Config_esx_taxijob.interimJobConfiguration.locales.getYourCar, 'CHAR_TAXI', 140)
        Citizen.Wait(2500)
        TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Patron", Config_esx_taxijob.interimJobConfiguration.locales.howItWork1, 'CHAR_TAXI', 140)
        Citizen.Wait(2500)
        TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Patron", Config_esx_taxijob.interimJobConfiguration.locales.howItWork2, 'CHAR_TAXI', 140)
      end
    end)
  end
end

local function unsetInterimJobAndPay()
  local factureMultiplicator = 1
  local toPay = 0

  if playerData.job2 ~= nil and playerData.job2.name ~= 'unemployed2' then
    factureMultiplicator = 1/3
    
    toPay = math.floor(calculateInterimPay())
    TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Patron", Config_esx_taxijob.interimJobConfiguration.locales.payMessage .. tonumber(toPay * factureMultiplicator) .. '$', 'CHAR_TAXI', 140)
    TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Patron", Config_esx_taxijob.interimJobConfiguration.locales.finishWorkIllegalP1, 'CHAR_TAXI', 140)
    TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Patron", Config_esx_taxijob.interimJobConfiguration.locales.finishWorkIllegalP2, 'CHAR_TAXI', 140)
    print(IsPedSittingInAnyVehicle(playerPed), GetVehiclePedIsIn(playerPed, false))
    if IsPedSittingInAnyVehicle(playerPed) then
      local vehicle = GetVehiclePedIsIn(playerPed, false)
      TaskLeaveVehicle(playerPed, vehicle, 0)
      Citizen.Wait(1400)
      SetEntityAsMissionEntity(vehicle, false, true)
      DeleteEntity(vehicle)
    end
  elseif IsPedSittingInAnyVehicle(playerPed) then
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if GetEntityModel(vehicle) ~= Config_esx_taxijob.interimJobConfiguration.jobVehicleHash then
      -- If player don't give back his taxi, player earn only half of the money 
      factureMultiplicator = 0.5
    else
      TaskLeaveVehicle(playerPed, vehicle, 0)
      Citizen.Wait(1400)
      SetEntityAsMissionEntity(vehicle, false, true)
      DeleteEntity(vehicle)
      toPay = calculateInterimPay()
      TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Patron", Config_esx_taxijob.interimJobConfiguration.locales.payMessage .. toPay .. '$', 'CHAR_TAXI', 140)
      TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Patron", Config_esx_taxijob.interimJobConfiguration.locales.finishWork, 'CHAR_TAXI', 140)
      ESX.TriggerServerCallback('esx_taxijob:unsetInterimJob', function()
        playerFacture = { }
        playerMission = { }
      end, tonumber(toPay * factureMultiplicator), #playerFacture, #playerMission, factureMultiplicator)
      return
    end

    toPay = calculateInterimPay()
    
    TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Patron", Config_esx_taxijob.interimJobConfiguration.locales.payMessage .. tonumber(toPay * factureMultiplicator) .. '$', 'CHAR_TAXI', 140)
    TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Patron", Config_esx_taxijob.interimJobConfiguration.locales.finishWorkWithoutCarP1, 'CHAR_TAXI', 140)
    TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Patron", Config_esx_taxijob.interimJobConfiguration.locales.finishWorkWithoutCarP2, 'CHAR_TAXI', 140)
  else
    factureMultiplicator = 0.5
    toPay = calculateInterimPay()
    TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Patron", Config_esx_taxijob.interimJobConfiguration.locales.payMessage .. tonumber(toPay * factureMultiplicator) .. '$', 'CHAR_TAXI', 140)
    TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Patron", Config_esx_taxijob.interimJobConfiguration.locales.finishWorkWithoutCarP1, 'CHAR_TAXI', 140)
    TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Patron", Config_esx_taxijob.interimJobConfiguration.locales.finishWorkWithoutCarP2, 'CHAR_TAXI', 140)
  end
  ESX.TriggerServerCallback('esx_taxijob:unsetInterimJob', function()
    playerFacture = { }
    playerMission = { }
  end, tonumber(toPay * factureMultiplicator), #playerFacture, #playerMission, factureMultiplicator)
end

Citizen.CreateThread(function()
  while true do
    playerPed = PlayerPedId()
    playerData = ESX.GetPlayerData()
    local threadSleep = nil

    local playerCoord = GetEntityCoords(playerPed)
    local playerHasJob = (playerData.job ~= nil and playerData.job.name ~= 'unemployed');
    local playerHasTaxiJob = playerData.job ~= nil and playerData.job.name == 'taxi'

    if not playerHasJob and not playerHasTaxiJob and #(playerCoord - vector3(Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.x, Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.y, Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.z)) <= Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.drawMarkerDistance then
      threadSleep = 5
      DrawMarker(21, Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.x, Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.y, Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.z + 0.4, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 100, true, true, 2, false, false, false, false)
      if #(playerCoord - vector3(Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.x, Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.y, Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.z)) <= Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.drawTextDistance then
        DrawText3Ds(Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.x, Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.y, Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.z + 0.8, Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.text)
         if IsControlJustPressed(0, 38) then
          SetInterimJob()
         end
      end
    elseif playerHasTaxiJob and #(playerCoord - vector3(Config_esx_taxijob.interimJobConfiguration.giveBackJobAndVehicle.Pos.x, Config_esx_taxijob.interimJobConfiguration.giveBackJobAndVehicle.Pos.y, Config_esx_taxijob.interimJobConfiguration.giveBackJobAndVehicle.Pos.z)) <= Config_esx_taxijob.interimJobConfiguration.giveBackJobAndVehicle.drawMarkerDistance then
      threadSleep = 5
      DrawMarker(27, Config_esx_taxijob.interimJobConfiguration.giveBackJobAndVehicle.Pos.x, Config_esx_taxijob.interimJobConfiguration.giveBackJobAndVehicle.Pos.y, Config_esx_taxijob.interimJobConfiguration.giveBackJobAndVehicle.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 200, false, false, false, false, false, false, false)
      if #(playerCoord - vector3(Config_esx_taxijob.interimJobConfiguration.giveBackJobAndVehicle.Pos.x, Config_esx_taxijob.interimJobConfiguration.giveBackJobAndVehicle.Pos.y, Config_esx_taxijob.interimJobConfiguration.getJobAndVehicle.Pos.z)) <= Config_esx_taxijob.interimJobConfiguration.giveBackJobAndVehicle.drawTextDistance then
        DrawText3Ds(Config_esx_taxijob.interimJobConfiguration.giveBackJobAndVehicle.Pos.x, Config_esx_taxijob.interimJobConfiguration.giveBackJobAndVehicle.Pos.y, Config_esx_taxijob.interimJobConfiguration.giveBackJobAndVehicle.Pos.z + 0.5, Config_esx_taxijob.interimJobConfiguration.giveBackJobAndVehicle.text)
        if IsControlJustPressed(0, 38) then
          unsetInterimJobAndPay()
        end
      end
    else
      threadSleep = 1000
    end

    Citizen.Wait(threadSleep)
  end
end)

-- Display markers
function taxi05()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'taxi' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'taxi' and PlayerData.job2.service == 1) then
      for k,v in pairs(Config_esx_taxijob.Zones) do
        -- if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_esx_taxijob.DrawDistance) then
        --   DrawMarker(0, v.Pos.x, v.Pos.y, v.Pos.z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
        -- end
      end

    end
end

-- Enter / Exit marker events
function taxi04()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'taxi' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'taxi' and PlayerData.job2.service == 1) then

      
      local isInMarker  = false
      local currentZone = nil

      for k,v in pairs(Config_esx_taxijob.Zones) do
        if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
          isInMarker  = true
          currentZone = k
        end
      end

      if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
        HasAlreadyEnteredMarker = true
        LastZone                = currentZone
        TriggerEvent('esx_taxijob:hasEnteredMarker', currentZone)
      end

      if not isInMarker and HasAlreadyEnteredMarker then
        HasAlreadyEnteredMarker = false
        TriggerEvent('esx_taxijob:hasExitedMarker', LastZone)
      end

    end
end

-- Taxi Job
function taxi03()
    if OnJob then
      if IsPedInAnyVehicle(playerPed, false) and (GetEntityModel(GetVehiclePedIsIn(playerPed, false)) == ModelTaxi) then
        sleepThread = 20
        if CurrentCustomer == nil then
          TriggerServerEvent('esx_taxijob:checkForLimitation')
          WaitingForLimitationReach = true
          while WaitingForLimitationReach do
            Wait(500)
          end
          if CanAskForNewJob == false then
            taxi_StopTaxiJob(true, true)
            do return end
          end

          DrawSub(Ftext_esx_taxijob('drive_search_pass'), 5000)

          if IsPedInAnyVehicle(playerPed,  false) and GetEntitySpeed(playerPed) > 0 then

            local waitUntil = nil
            if notFindPosition then
              Citizen.Wait(2500)
            else
              Citizen.Wait(30000)
            end

            if OnJob and IsPedInAnyVehicle(playerPed,  false) and GetEntitySpeed(playerPed) > 0 then
              CurrentCustomer = taxi_GetRandomWalkingNPC()

              if CurrentCustomer == nil then
                local playerCoords = coords 

                local positive, xDif, yDif = math.random(0,1), math.random(100, 300), math.random(100, 300)
                if positive == 0 then
                  xDif = xDif * -1
                  yDif = yDif * -1
                end 

                local rnX = playerCoords.x + xDif
                local rnY = playerCoords.y + yDif                               

                local u, Z = GetGroundZFor_3dCoord(rnX ,rnY ,playerCoords.z,0)
                local safeCoordForPed = GetSafeCoordForPedSpawn(rnX, rnY, Z)
                if safeCoordForPed ~= nil then
                  notFindPosition = false
                  local npcalea = math.random(1, #Config_esx_taxijob.pedHash)
                  RequestModel(Config_esx_taxijob.pedHash[npcalea])
                  while not HasModelLoaded(Config_esx_taxijob.pedHash[npcalea]) do
                    Wait(1)
                  end
                  CurrentCustomer = CreatePed(26, Config_esx_taxijob.pedHash[npcalea], safeCoordForPed.x, safeCoordForPed.y, safeCoordForPed.z, 187.06-0.98, false, false)               
                else
                  notFindPosition = true
                end
              else
                notFindPosition = false;
              end

              if CurrentCustomer ~= nil then

                CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

                SetBlipAsFriendly(CurrentCustomerBlip, 1)
                SetBlipColour(CurrentCustomerBlip, 2)
                SetBlipCategory(CurrentCustomerBlip, 3)
                SetBlipRoute(CurrentCustomerBlip,  true)

                ClearPedTasksImmediately(CurrentCustomer)
                SetEntityAsMissionEntity(CurrentCustomer,  true, false)
                SetBlockingOfNonTemporaryEvents(CurrentCustomer, 1)

                TaskWanderStandard(CurrentCustomer, 10.0, 10)
                TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Client", Ftext_esx_taxijob('customer_found'), 'CHAR_TAXI', 140)
              end

            end
          
          end

        else

          if IsEntityDead(CurrentCustomer) then
            TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Client", '~r~'..Ftext_esx_taxijob('clientFtext_esx_taxijobnconcious'), 'CHAR_TAXI', 140)

            if DoesBlipExist(CurrentCustomerBlip) then
              RemoveBlip(CurrentCustomerBlip)
            end

            if DoesBlipExist(DestinationBlip) then
              RemoveBlip(DestinationBlip)
            end

            SetEntityAsNoLongerNeeded(CurrentCustomer)

            CurrentCustomer           = nil
            CurrentCustomerBlip       = nil
            DestinationBlip           = nil
            IsNearCustomer            = false
            CustomerIsEnteringVehicle = false
            CustomerEnteredVehicle    = false
            TargetCoords              = nil
            notFindPosition = true -- wait 2.5s instead of 30s if client is dead

          end

          if IsPedInAnyVehicle(playerPed,  false) then

            local vehicle          = GetVehiclePedIsIn(playerPed,  false)
            local playerCoords     = coords
            local customerCoords   = GetEntityCoords(CurrentCustomer)
            local customerDistance = GetDistanceBetweenCoords(playerCoords.x,  playerCoords.y,  playerCoords.z,  customerCoords.x,  customerCoords.y,  customerCoords.z)

            if IsPedSittingInVehicle(CurrentCustomer,  vehicle) then

              if CustomerEnteredVehicle then

                local targetDistance = GetDistanceBetweenCoords(playerCoords.x,  playerCoords.y,  playerCoords.z,  TargetCoords.x,  TargetCoords.y,  TargetCoords.z)
                                
                if targetDistance <= 10.0 then
                  
                  TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Destination", Ftext_esx_taxijob('arrive_dest'), 'CHAR_TAXI', 140)
                  
                  TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)
                  while IsPedInVehicle(CurrentCustomer, vehicle, false) do
                    SetPedKeepTask(CurrentCustomer, true)
                    Citizen.Wait(500)
                  end
                  SetPedKeepTask(CurrentCustomer, false)
                  FreezeEntityPosition(vehicle, true)
                  local customerCoord = GetEntityCoords(CurrentCustomer)
                  TaskGoStraightToCoord(CurrentCustomer, customerCoord.x-2.0,customerCoord.y+2.0, customerCoord.z, 1.0,  -1,  0.0,  0.0)
                  SetEntityAsMissionEntity(CurrentCustomer,  false, true)
                  SetEntityAsNoLongerNeeded(CurrentCustomer)

                  Citizen.Wait(750)
                  local allDoorClose = false
                  while not allDoorClose do
                    allDoorClose = true
                    for i = 0, 3 do
                      if GetVehicleDoorAngleRatio(vehicle, i) > 0.0 and IsVehicleDoorDamaged(vehicle, i) ~= 1 then
                        SetVehicleDoorShut(vehicle, i, false) 
                      end
                      if GetVehicleDoorAngleRatio(vehicle, i) > 0.0 and IsVehicleDoorDamaged(vehicle, i) ~= 1 then
                        allDoorClose = false
                      end
                    end
                    Citizen.Wait(100)
                  end
                  FreezeEntityPosition(vehicle, false)

                  TriggerServerEvent('esx_taxijob:success', TargetCoords.price)

                  RemoveBlip(DestinationBlip)

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

                TargetCoords = Config_esx_taxijob.JobLocations[GetRandomIntInRange(1,  #Config_esx_taxijob.JobLocations)]

                -- Log to debug when player get unreachable destination
                -- Ask player to send coord with screen when they get the bug (1/1000 to reproduce) 
                print(TargetCoords.x, TargetCoords.y, TargetCoords.z)

                local targetSafeCoord = GetSafeCoordForPedDestination(TargetCoords.x, TargetCoords.y, TargetCoords.z)

                if targetSafeCoord ~= nil then
                  TargetCoords.x = targetSafeCoord.x
                  TargetCoords.y = targetSafeCoord.y
                  TargetCoords.z = targetSafeCoord.z
                end

                local street = table.pack(GetStreetNameAtCoord(TargetCoords.x, TargetCoords.y, TargetCoords.z))
                local msg    = nil

                if street[2] ~= 0 and street[2] ~= nil then
                  msg = '~w~Emmenez-moi à ~g~' .. GetStreetNameFromHashKey(street[1]) .. '~w~ près de ~g~' .. GetStreetNameFromHashKey(street[2]) ..' ~w~s\'il vous plait'
                else
                  msg = '~w~Emmenez-moi à ~g~' .. GetStreetNameFromHashKey(street[1])..' ~w~s\'il vous plait'
                end
               
                TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Destination", msg, 'CHAR_TAXI', 140)

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
                    TriggerEvent('Core:ShowAdvancedNotification', "DOWNTOWN CAB CO", "Client", Ftext_esx_taxijob('close_to_client'), 'CHAR_TAXI', 140)
                    IsNearCustomer = true
                  end

                end

                if customerDistance <= 20.0 then

                  if not CustomerIsEnteringVehicle then

                    ClearPedTasksImmediately(CurrentCustomer)

                    local seat = 2

                    for i = 2, 0, -1 do
                      local seatFree = GetPedInVehicleSeat(vehicle, seat)
                      if seatFree == 0 then                        
                        break
                      else
                        seat = i
                      end
                    end
                    TaskEnterVehicle(CurrentCustomer,  vehicle,  -1,  seat,  1.0,  1)
                    CustomerIsEnteringVehicle = true
                  end

                end

              end

            end

          else            
            DrawSub(Ftext_esx_taxijob('return_to_veh'), 5000)
          end

        end
      else
        TriggerEvent('Core:ShowNotification', "~r~Vous devez être dans un véhicule TAXI pour continuer la mission.")        
        taxi_StopTaxiJob(true, false)
      end
    end
end

function GetSafeCoordForPedSpawn(x,y,z) 
    local ret, coordsTemp, heading = GetClosestVehicleNodeWithHeading(x, y, z, 4, 3.0, 0)
    local retval, coordsSide = GetPointOnRoadSide(coordsTemp.x, coordsTemp.y, coordsTemp.z)
    
    local isFind = false
    local coord = nil
  
    isFind, coord = GetSafeCoordForPed(x, y, z, true, 16)

    if( isFind == false) then
      return coordsSide
    else
      return coord
    end
end

function GetSafeCoordForPedDestination(x,y,z) 
  local isFind = false
  local coord = nil
  
    isFind, coord = GetSafeCoordForPed(x, y, z, true, 16)

    if( isFind == false) then
      return nil
    else
      return coord
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

function taxi02()
	if (PlayerData.job ~= nil and PlayerData.job.name == 'taxi' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'taxi' and PlayerData.job2.service == 1) then
		
		-- if GetDistanceBetweenCoords(coords, Config_esx_taxijob.Zones.TaxiActions.Pos.x, Config_esx_taxijob.Zones.TaxiActions.Pos.y, Config_esx_taxijob.Zones.TaxiActions.Pos.z,  true) < 2.0 then
    --   sleepThread = 20
    --   DrawText3Ds(Config_esx_taxijob.Zones.TaxiActions.Pos.x, Config_esx_taxijob.Zones.TaxiActions.Pos.y, Config_esx_taxijob.Zones.TaxiActions.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au menu')
		-- end
		--if GetDistanceBetweenCoords(coords, Config_esx_taxijob.Zones.VehicleDeleter.Pos.x, Config_esx_taxijob.Zones.VehicleDeleter.Pos.y, Config_esx_taxijob.Zones.VehicleDeleter.Pos.z,  true) < 2.0 then
			--DrawText3Ds(Config_esx_taxijob.Zones.VehicleDeleter.Pos.x, Config_esx_taxijob.Zones.VehicleDeleter.Pos.y, Config_esx_taxijob.Zones.VehicleDeleter.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour ranger le véhicule')
		--end
			
	end

end

-- Key Controls
function taxi01()
    if CurrentAction ~= nil then

      if IsControlJustReleased(0, Keys['BACKSPACE']) then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	  end
	  
      if (IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'taxi' and PlayerData.job.service == 1 and (GetGameTimer() - GUI.Time) > 300) or
		(IsControlPressed(0,  Keys['E']) and PlayerData.job2 ~= nil and PlayerData.job2.name == 'taxi' and PlayerData.job2.service == 1 and (GetGameTimer() - GUI.Time) > 300) then

        if CurrentAction == 'taxi_actions_menu' then
          taxi_OpenTaxiActionsMenu()
        end

        if CurrentAction == 'delete_vehicle' then

		  --TriggerServerEvent('taxibot:service', false)

          if Config_esx_taxijob.EnableSocietyOwnedVehicles then
            local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
            TriggerServerEvent('esx_society:putVehicleInGarage', 'taxi', vehicleProps)
          else
            if GetEntityModel(CurrentActionData.vehicle) == GetHashKey('taxi') then
              if Config_esx_taxijob.MaxInService ~= -1 then
                TriggerServerEvent('esx_service:disableService', 'taxi')
              end
            end
          end

          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

        end

        CurrentAction = nil
        GUI.Time      = GetGameTimer()

      end

    end

end

RegisterNetEvent('esx_taxijob:openMenuJob')
AddEventHandler('esx_taxijob:openMenuJob', function()
	taxi_OpenMobileTaxiActionsMenu()
end)

RegisterNetEvent('esx_taxijob:responseCheckForLimitation')
AddEventHandler('esx_taxijob:responseCheckForLimitation', function(result)
    CanAskForNewJob = result == false
    if result then
      TriggerEvent('Core:ShowAdvancedNotification', "~r~DOWNTOWN CAB CO", "~y~Course", "Vous avez atteint le quota de course pour aujourd'hui. Recommencez demain", 'CHAR_TAXI', 0, false, false, 140)
    end
    WaitingForLimitationReach = false      
end)

RegisterNetEvent('esx_taxijob:updateInterimMissionAccount')
AddEventHandler('esx_taxijob:updateInterimMissionAccount', function(amount)
    table.insert(playerMission, amount)    
end)