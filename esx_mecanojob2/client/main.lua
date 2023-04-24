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

function Ftext_esx_mecanojob2(txt)
	return Config_esx_mecanojob2.Txt[txt]
end



local GUI                     = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentPos      		  = nil
local CurrentActionData       = {}
local OnJob                   = false
local TargetCoords            = nil
local CurrentlyTowedVehicle   = nil
local Blips                   = {}
local NPCOnJob                = false
local NPCTargetTowable         = nil
local NPCTargetTowableZone     = nil
local NPCHasSpawnedTowable    = false
local NPCLastCancel           = GetGameTimer() - 5 * 60000
local NPCHasBeenNextToTowable = false
local NPCTargetDeleterZone    = false
local hName = "flatbed"

GUI.Time                      = 0


function meca2_SelectRandomTowable()

  local index = GetRandomIntInRange(1,  #Config_esx_mecanojob2.Towables)

  for k,v in pairs(Config_esx_mecanojob2.Zones) do
    if v.Pos.x == Config_esx_mecanojob2.Towables[index].x and v.Pos.y == Config_esx_mecanojob2.Towables[index].y and v.Pos.z == Config_esx_mecanojob2.Towables[index].z then
      return k
    end
  end

end

function mecano_OpenShopMenu(zone)

  local elements = {}
  for i=1, #Config_esx_mecanojob2.Zones[zone].Items, 1 do

      local item = Config_esx_mecanojob2.Zones[zone].Items[i]

      table.insert(elements, {
        label = item.label,
        item = item.name,
        price = item.price,
        value = 1,
        type = 'slider', 
        min = 1, 
        max = 100
      })

  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'mecano_shop',
      {
          title    = Ftext_esx_mecanojob2('shop'),
          elements = elements
      },
      function(data, menu)
          TriggerServerEvent('esx_mecanojob2:buyItem', data.current.item, data.current.price, data.current.label, data.current.value)
          ESX.UI.Menu.CloseAll()
      end,
      function(data, menu)
          menu.close()
      end
  )

end

function meca2_OpenMecanoActionsMenu()

  local elements = {
    --{label = Ftext_esx_mecanojob2('vehicle_list'), value = 'vehicle_list'},
    {label = "Dressing", value = 'dressing2'},
    {label = 'Ouvrir le stockage', value = 'get_stock'}
  }
  if (Config_esx_mecanojob2.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'coboss'  and PlayerData.job.service == 1) or 
  (Config_esx_mecanojob2.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.grade_name == 'boss' or PlayerData.job.grade_name == 'coboss' and PlayerData.job2.service == 1) then
    table.insert(elements, {label = Ftext_esx_mecanojob2('boss_actions'), value = 'boss_actions'})
  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mecano_actions',
    {
      title    = Ftext_esx_mecanojob2('mechanic'),
	  align = 'right',
      elements = elements
    },
    function(data, menu)

      function meca_OpenDress()
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

      if data.current.value == 'dressing2' then
        meca_OpenDress()
      end
      
      if data.current.value == 'get_stock' then
        TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_mecano2')
        menu.close()
      end

      if data.current.value == 'boss_actions' then
        TriggerEvent('esx_society:openBossMenu', 'mecano2', function(data, menu)
          menu.close()
        end)
      end

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'mecano_actions_menu'
      CurrentActionMsg  = Ftext_esx_mecanojob2('open_actions')
      CurrentActionData = {}
    end
  )
end

function meca2_BillingADV()

  ESX.UI.Menu.CloseAll()

  -- ESX.UI.Menu.Open(
  --   'default', GetCurrentResourceName(), 'RecruterPlayer',
  --   {
  --     title    = 'Facturation',
	--   align = 'right',
  --     elements = {
  --       {label = 'Custom', value = 'custom'},
	-- 	{label = 'Réparation (en ville) - $500', value = 'repa1'},
	-- 	{label = 'Réparation (dans le nord) - $1000', value = 'repa2'},
	-- 	{label = 'Crochetage (en ville) - $500', value = 'cro1'},
	-- 	{label = 'Crochetage (dans le nord) - $1000', value = 'cro2'},
	-- 	{label = 'Remorquage (en ville) - $600', value = 'remo1'},
	-- 	{label = 'Remorquage (dans le nord) - $1200', value = 'remo2'},
	-- 	{label = 'Kit réparation - $600', value = 'kit'}
  --     }
  --   },
  --   function(data, menu)

	-- if data.current.value == 'custom' then
		ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'billing',
          {
            title = Ftext_esx_mecanojob2('invoice_amount')
          },
          function(data, menu)
            local amount = tonumber(data.value)
            if amount == nil then
              ESX.ShowNotification(Ftext_esx_mecanojob2('amount_invalid'))
            else
              menu.close()
              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
              if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification(Ftext_esx_mecanojob2('no_players_nearby'))
              else
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mecano2', Ftext_esx_mecanojob2('mechanic'), amount)
                TriggerServerEvent('CoreLog:SendDiscordLog', "Mecano Sandy Shores - Factures", "`[FACTURE]` **" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$"..amount.." [CUSTOMS]`", "Yellow")
              end
            end
          end,
        function(data, menu)
          menu.close()
        end
        )
	-- end
	
	-- if data.current.value == 'kit' then
	-- 	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  --       if closestPlayer == -1 or closestDistance > 3.0 then
  --           ESX.ShowNotification(Ftext_esx_mecanojob2('no_players_nearby'))
  --       else
  --           TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mecano2', Ftext_esx_mecanojob2('mechanic') .. " - kit", 600)
  --           TriggerServerEvent('CoreLog:SendDiscordLog', "Mecano Sandy Shores - Factures", "`[FACTURE]` **" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$600 [Vente de kit]`", "Yellow")
  --       end
  --   end
	
  --   if data.current.value == 'repa1' then
	-- 	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  --       if closestPlayer == -1 or closestDistance > 3.0 then
  --           ESX.ShowNotification(Ftext_esx_mecanojob2('no_players_nearby'))
  --       else
  --           TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mecano2', Ftext_esx_mecanojob2('mechanic') .. " - repa", 500)
  --           TriggerServerEvent('CoreLog:SendDiscordLog', "Mecano Sandy Shores - Factures", "`[FACTURE]` **" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$500 [Réparation en ville]`", "Yellow")
  --       end
  --   end
	
	-- if data.current.value == 'repa2' then
	-- 	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  --       if closestPlayer == -1 or closestDistance > 3.0 then
  --           ESX.ShowNotification(Ftext_esx_mecanojob2('no_players_nearby'))
  --       else
  --           TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mecano2', Ftext_esx_mecanojob2('mechanic') .. " - repa", 1000)
  --           TriggerServerEvent('CoreLog:SendDiscordLog', "Mecano Sandy Shores - Factures", "`[FACTURE]` **" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$1000 [Réparation dans le Nord]`", "Yellow")
  --       end
  --   end
	
	-- if data.current.value == 'cro1' then
	-- 	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  --       if closestPlayer == -1 or closestDistance > 3.0 then
  --           ESX.ShowNotification(Ftext_esx_mecanojob2('no_players_nearby'))
  --       else
  --           TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mecano2', Ftext_esx_mecanojob2('mechanic') .. " - cro", 500)
  --           TriggerServerEvent('CoreLog:SendDiscordLog', "Mecano Sandy Shores - Factures", "`[FACTURE]` **" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$500 [Crochetage en ville]`", "Yellow")
  --       end
  --   end
	
	-- if data.current.value == 'cro2' then
	-- 	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  --       if closestPlayer == -1 or closestDistance > 3.0 then
  --           ESX.ShowNotification(Ftext_esx_mecanojob2('no_players_nearby'))
  --       else
  --           TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mecano2', Ftext_esx_mecanojob2('mechanic') .. " - cro", 1000)
  --           TriggerServerEvent('CoreLog:SendDiscordLog', "Mecano Sandy Shores - Factures", "`[FACTURE]` **" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$1000 [Crochetage dans le Nord]`", "Yellow")
  --       end
  --   end
	
	-- if data.current.value == 'remo1' then
	-- 	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  --       if closestPlayer == -1 or closestDistance > 3.0 then
  --           ESX.ShowNotification(Ftext_esx_mecanojob2('no_players_nearby'))
  --       else
  --           TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mecano2', Ftext_esx_mecanojob2('mechanic') .. " - remo", 600)
  --           TriggerServerEvent('CoreLog:SendDiscordLog', "Mecano Sandy Shores - Factures", "`[FACTURE]` **" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$600 [Remorquage en ville]`", "Yellow")
  --       end
  --   end
	
	-- if data.current.value == 'remo2' then
	-- 	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  --       if closestPlayer == -1 or closestDistance > 3.0 then
  --           ESX.ShowNotification(Ftext_esx_mecanojob2('no_players_nearby'))
  --       else
  --           TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mecano2', Ftext_esx_mecanojob2('mechanic') .. " - remo", 1200)
  --           TriggerServerEvent('CoreLog:SendDiscordLog', "Mecano Sandy Shores - Factures", "`[FACTURE]` **" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$1200 [Remorquage dans le Nord]`", "Yellow")
  --       end
  --   end

  --   end,
  --   function(data, menu)
  --     menu.close()
  --   end
  -- )
end

function meca2_OpenMobileMecanoActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_mecano_actions',
    {
      title    = Ftext_esx_mecanojob2('mechanic'),
	  align = 'right',
      elements = {
        {label = Ftext_esx_mecanojob2('billing'),    value = 'billing'},
        {label = Ftext_esx_mecanojob2('hijack'),     value = 'hijack_vehicle'},
        {label = Ftext_esx_mecanojob2('repair'),       value = 'fix_vehicle'},
        {label = Ftext_esx_mecanojob2('clean'),      value = 'clean_vehicle'},
        {label = Ftext_esx_mecanojob2('imp_veh'),     value = 'del_vehicle'},
		    {label = "Supprimer le plateau (si bugs)",       value = 'del_plateau'},
        {label = Ftext_esx_mecanojob2('place_objects'), value = 'object_spawner'},
        {label = Ftext_esx_mecanojob2('CheckPlate'),       value = 'check_plate'}
      }
    },
    function(data, menu)
      if data.current.value == 'billing' then
        meca2_BillingADV()
      end

      if data.current.value == 'hijack_vehicle' then

        if (GetDistanceBetweenCoords(coords, 1175.29, 2641.80, 37.75, false) < 40.0)
        or(GetDistanceBetweenCoords(coords, 1176.72, 2628.28, 37.80, false) < 15.0) then

          if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

            local vehicle = nil

            if IsPedInAnyVehicle(playerPed, false) then
              vehicle = GetVehiclePedIsIn(playerPed, false)
            else
              vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
            end

            if DoesEntityExist(vehicle) then
              TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
              Citizen.CreateThread(function()
                Citizen.Wait(10000)
                SetVehicleDoorsLocked(vehicle, 1)
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                ClearPedTasksImmediately(playerPed)
                ESX.ShowNotification(Ftext_esx_mecanojob2('vehicleFtext_esx_mecanojob2(nlocked'))
          TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
              end)
            end

          end
        else
          TriggerEvent('Core:ShowAdvancedNotification', "~b~LS Motor's", "~y~Personnel du LS Motor's", "Tu ne peux pas ~y~crocheter~w~ en dehors des locaux du mécano !", 'CHAR_LS_CUSTOMS', 1, false, false, 150)
        end
      end

      if data.current.value == 'fix_vehicle' then

        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

          local vehicle = nil

          if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
          else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
          end
          local bodyHealth = GetVehicleBodyHealth(vehicle)
          local engineHealth  = GetVehicleEngineHealth(vehicle)
          local vehicleFuel   = GetVehicleFuelLevel(vehicle)

          if bodyHealth > 970 and engineHealth > 970 then
            if DoesEntityExist(vehicle) then
              TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
              Citizen.CreateThread(function()
                Citizen.Wait(60000)
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                SetVehicleFuelLevel(vehicle, vehicleFuel)
                exports['Nebula_Fuel']:SetFuel(vehicle, vehicleFuel)
                SetVehicleEngineOn(vehicle,  true,  true)
                ClearPedTasksImmediately(playerPed)
                SetVehicleMaxSpeed(vehicle, -1)
                ESX.ShowNotification(Ftext_esx_mecanojob2('vehicle_repaired'))
              end)
            end
          elseif (GetDistanceBetweenCoords(coords, 1175.29, 2641.80, 37.75, false) < 15.0) 
          or(GetDistanceBetweenCoords(coords, 1176.72, 2628.28, 37.80, false) < 15.0)  then
            if DoesEntityExist(vehicle) then
              TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
              Citizen.CreateThread(function()
                Citizen.Wait(60000)
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                SetVehicleFuelLevel(vehicle, vehicleFuel)
                exports['Nebula_Fuel']:SetFuel(vehicle, vehicleFuel)
                SetVehicleEngineOn(vehicle,  true,  true)
                ClearPedTasksImmediately(playerPed)
                SetVehicleMaxSpeed(vehicle, -1)
                ESX.ShowNotification(Ftext_esx_mecanojob2('vehicle_repaired'))
              end)
            end
          else
            if DoesEntityExist(vehicle) then
              TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
              Citizen.CreateThread(function()
                Citizen.Wait(30000)
                SetVehicleUndriveable(vehicle, false)
                SetVehicleEngineHealth(vehicle, 940.00)
                SetVehicleBodyHealth(vehicle, 940.00)
                SetVehicleFuelLevel(vehicle, vehicleFuel)
                exports['Nebula_Fuel']:SetFuel(vehicle, vehicleFuel)
                SetVehicleEngineOn(vehicle,  true,  true)
                ClearPedTasksImmediately(playerPed)
                ESX.ShowNotification("Réparation de secours effectué")
              end)
            end
            --ESX.ShowNotification("Retour au garage obligatoire pour pouvoir le réparer")
          end
        end
      end

      if data.current.value == 'clean_vehicle' then

        

        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

          local vehicle = nil

          if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
          else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
          end

          if DoesEntityExist(vehicle) then
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
            Citizen.CreateThread(function()
              Citizen.Wait(10000)
              SetVehicleDirtLevel(vehicle, 0)
              ClearPedTasksImmediately(playerPed)
              ESX.ShowNotification(Ftext_esx_mecanojob2('vehicle_cleaned'))
            end)
          end
        end
      end
	  
	  if data.current.value == 'del_plateau' then
      local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z, 8.0,  GetHashKey("inm_flatbed_base"), false, false, false)
        if DoesEntityExist(object) then
          DeleteObject(object)
        end
	  end

      if data.current.value == 'del_vehicle' then       
        local ped = playerPed
        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then

          if ( IsPedSittingInAnyVehicle( ped ) ) then
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then
              ESX.ShowNotification(Ftext_esx_mecanojob2('vehicle_impounded'))
              -- TriggerEvent('harybo_permanent:forgetveh', vehicle)
              SetEntityAsMissionEntity( vehicle, true, true )
              NetworkRequestControlOfEntity(vehicle)
              local timeout = 2000
              while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do 
                Wait(100) 
                timeout = timeout - 100
              end
              local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)) 
              deleteCar( vehicle )
              TriggerServerEvent('Core:SetVehicleFourriere', plate)
              TriggerEvent('Core:ShowNotification', "Le véhicule ~b~"..plate.."~w~ a été mis en fourrière")
            else
              ESX.ShowNotification(Ftext_esx_mecanojob2('must_seat_driver'))
            end
          else
            local playerPos =  GetEntityCoords(ped)
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, 3.0, 0.0 )
            local vehicle = meca2_getVehicleInDirection( playerPos, inFrontOfPlayer )
                
            if ( DoesEntityExist( vehicle ) ) then
              ESX.ShowNotification(Ftext_esx_mecanojob2('vehicle_impounded'))
              SetEntityAsMissionEntity( vehicle, true, true )
              NetworkRequestControlOfEntity(vehicle)
              local timeout = 2000
              while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do 
                Wait(100) 
                timeout = timeout - 100
              end
              local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
              deleteCar( vehicle )
              TriggerServerEvent('Core:SetVehicleFourriere', plate)
              TriggerEvent('Core:ShowNotification', "Le véhicule ~b~"..plate.."~w~ a été mis en fourrière")
            else
              ESX.ShowNotification(Ftext_esx_mecanojob2('must_near'))
            end
          end
        end
      end

      if data.current.value == 'dep_vehicle' then

        local vehicle = GetVehiclePedIsIn(playerPed, true)
  
        local towmodel = GetHashKey('flatbed')
        local isVehicleTow = IsVehicleModel(vehicle, towmodel)
  
        if isVehicleTow then
          local targetVehicle = ESX.Game.meca2_getVehicleInDirection()
  
          if CurrentlyTowedVehicle == nil then
            if targetVehicle ~= 0 then
              if not IsPedInAnyVehicle(playerPed, true) then
                if vehicle ~= targetVehicle then
                  AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                  CurrentlyTowedVehicle = targetVehicle
                  ESX.ShowNotification(Ftext_esx_mecanojob2('vehicle_success_attached'))
                else
                  ESX.ShowNotification(Ftext_esx_mecanojob2('cant_attach_own_tt'))
                end
              end
            else
              ESX.ShowNotification(Ftext_esx_mecanojob2('no_veh_att'))
            end
          else
            AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
            DetachEntity(CurrentlyTowedVehicle, true, true)
  
            CurrentlyTowedVehicle = nil
            ESX.ShowNotification(Ftext_esx_mecanojob2('veh_det_succ'))
          end
        else
          ESX.ShowNotification(Ftext_esx_mecanojob2('imp_flatbed'))
        end
      end

      if data.current.value == 'object_spawner' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'mobile_mecano_actions_spawn',
          {
            title    = Ftext_esx_mecanojob2('objects'),
            align = 'right',
            elements = {
              {label = Ftext_esx_mecanojob2('roadcone'),     value = 'prop_roadcone02a'},
              {label = Ftext_esx_mecanojob2('toolbox'), value = 'prop_toolchest_01'},
            },
          },
          function(data2, menu2)


            local model     = data2.current.value
            
            local forward   = GetEntityForwardVector(playerPed)
            local x, y, z   = table.unpack(coords + forward * 1.0)

            if model == 'prop_roadcone02a' then
              z = z - 2.0
            elseif model == 'prop_toolchest_01' then
              z = z - 2.0
            end

            ESX.Game.SpawnObject(model, {
              x = x,
              y = y,
              z = z
            }, function(obj)
              SetEntityHeading(obj, GetEntityHeading(playerPed))
              PlaceObjectOnGroundProperly(obj)
            end)

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

      if data.current.value == 'check_plate' then
        local playerCoord = GetEntityCoords(playerPed)
        if IsAnyVehicleNearPoint(playerCoord.x, playerCoord.y, playerCoord.z, 5.0) then
          local vehicle = nil
          -- Get vehicle
          if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
          else
            vehicle = GetClosestVehicle(playerCoord.x, playerCoord.y, playerCoord.z, 5.0, 0, 71)
          end
          local vehiclePlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

          ESX.ShowAdvancedNotification("LS Custom North", "Mécanicien", "Véhicule immatriculé : ~b~" .. vehiclePlate, 'CHAR_LS_CUSTOMS', 2)
        else
          ESX.ShowAdvancedNotification("LS Custom North", "Mécanicien", "Aucun véhicule au alentours", 'CHAR_LS_CUSTOMS', 2)
        end
      end

    end,
  function(data, menu)
    menu.close()
  end
  )
end

function meca2_OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_mecanojob2:getStockItems', function(items)

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
        title    = Ftext_esx_mecanojob2('mechanic_stock'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = Ftext_esx_mecanojob2('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_mecanojob2('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              meca2_OpenGetStocksMenu()

              TriggerServerEvent('esx_mecanojob2:getStockItem', itemName, count)
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

function meca2_OpenPutStocksMenu()

ESX.TriggerServerCallback('esx_mecanojob2:getPlayerInventory', function(inventory)

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
        title    = Ftext_esx_mecanojob2('inventory'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = Ftext_esx_mecanojob2('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_mecanojob2('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              meca2_OpenPutStocksMenu()

              TriggerServerEvent('esx_mecanojob2:putStockItems', itemName, count)
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

RegisterNetEvent('esx_mecanojob2:onLockpick')
AddEventHandler('esx_mecanojob2:onLockpick', function()
  

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    --local crochete = math.random(100)
    local alarm    = math.random(100)

    if DoesEntityExist(vehicle) then
      if alarm <= 70 then
        SetVehicleAlarm(vehicle, true)
        StartVehicleAlarm(vehicle)
      end
      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
      Citizen.CreateThread(function()
    Citizen.Wait(15000)
        --if crochete <= 50 then
          SetVehicleDoorsLocked(vehicle, 1)
          SetVehicleDoorsLockedForAllPlayers(vehicle, false)
          ClearPedTasksImmediately(playerPed)
          ESX.ShowNotification(Ftext_esx_mecanojob2('vehFtext_esx_mecanojob2(nlocked'))
          --TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
        --else
          --ESX.ShowNotification(Ftext_esx_mecanojob2('hijack_failed'))
          --ClearPedTasksImmediately(playerPed)
        --end
      end)
    end

  end
end)

RegisterNetEvent('esx_mecanojob2:onCleanKit')
AddEventHandler('esx_mecanojob2:onCleanKit', function()

	
	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
		else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
            Citizen.CreateThread(function()
				Citizen.Wait(10000)
				SetVehicleDirtLevel(vehicle, 0)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(Ftext_esx_mecanojob2('vehicle_cleaned'))
			end)
		end
	end
end)

RegisterNetEvent('esx_mecanojob2:onCarokit')
AddEventHandler('esx_mecanojob2:onCarokit', function()

  
  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    if DoesEntityExist(vehicle) then
      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_HAMMERING", 0, true)
      Citizen.CreateThread(function()
        Citizen.Wait(10000)
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        ClearPedTasksImmediately(playerPed)
        ESX.ShowNotification(Ftext_esx_mecanojob2('body_repaired'))
      end)
    end
  end
end)

RegisterNetEvent('esx_mecanojob2:onFixkit')
AddEventHandler('esx_mecanojob2:onFixkit', function()
  
  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    if DoesEntityExist(vehicle) then
      TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
      Citizen.CreateThread(function()
        Citizen.Wait(20000)
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        ClearPedTasksImmediately(playerPed)
		SetVehicleEngineOn(vehicle, true, false, true)
        ESX.ShowNotification(Ftext_esx_mecanojob2('veh_repaired'))
      end)
    end
  end
end)

local used = 0
local plate = 0

RegisterNetEvent('esx_mecanojob2:onPlate')
AddEventHandler('esx_mecanojob2:onPlate', function()

  
  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    if DoesEntityExist(vehicle) then
      TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
      Citizen.CreateThread(function()
        Citizen.Wait(20000)

        local rand = math.random(10000000,90000000)
        SetVehicleNumberPlateText(vehicle, rand)

        ClearPedTasksImmediately(playerPed)
        ESX.ShowNotification(("Vous venez de changer votre plaque.")) 
      end)
    end
  end
end)

function meca2_setEntityHeadingFromEntity ( vehicle, playerPed )
    local heading = GetEntityHeading(vehicle)
    SetEntityHeading( playerPed, heading )
end

function meca2_getVehicleInDirection(coordFrom, coordTo)
  local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, playerPed, 0)
  local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
  return vehicle
end

function meca2_deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
	
	local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  6.0,  GetHashKey("inm_flatbed_base"), false, false, false)
	if DoesEntityExist(object) then
		DeleteObject(object)
	end
end

AddEventHandler('esx_mecanojob2:hasEnteredMarker', function(zone)

  if zone == 'MecanoActions' then
    CurrentAction     = 'mecano_actions_menu'
    CurrentActionMsg  = Ftext_esx_mecanojob2('open_actions')
    CurrentActionData = {}
  end

  if zone == 'Shops' and PlayerData.job.grade_name == 'boss' then
    CurrentAction     = 'menu_shop'
    CurrentActionMsg  = Ftext_esx_mecanojob2('shop_menu')
    CurrentActionData = {zone = zone}
  end

end)

AddEventHandler('esx_mecanojob2:hasExitedMarker', function(zone)
  	if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	end
end)

AddEventHandler('esx_mecanojob2:hasEnteredEntityZone', function(entity)

  if (PlayerData.job ~= nil and PlayerData.job.name == 'mecano2' and PlayerData.job.service == 1 and not IsPedInAnyVehicle(playerPed, false)) or 
  (PlayerData.job2 ~= nil and PlayerData.job2.name == 'mecano2' and PlayerData.job2.service == 1 and not IsPedInAnyVehicle(playerPed, false)) then
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = Ftext_esx_mecanojob2('press_remove_obj')
    CurrentActionData = {entity = entity}
  end

end)

AddEventHandler('esx_mecanojob2:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end

end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
  local specialContact = {
    name       = Ftext_esx_mecanojob2(''),
    number     = 'mecano2',
    base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAAA4BJREFUWIXtll9oU3cUx7/nJA02aSSlFouWMnXVB0ejU3wcRteHjv1puoc9rA978cUi2IqgRYWIZkMwrahUGfgkFMEZUdg6C+u21z1o3fbgqigVi7NzUtNcmsac40Npltz7S3rvUHzxQODec87vfD+/e0/O/QFv7Q0beV3QeXqmgV74/7H7fZJvuLwv8q/Xeux1gUrNBpN/nmtavdaqDqBK8VT2RDyV2VHmF1lvLERSBtCVynzYmcp+A9WqT9kcVKX4gHUehF0CEVY+1jYTTIwvt7YSIQnCTvsSUYz6gX5uDt7MP7KOKuQAgxmqQ+neUA+I1B1AiXi5X6ZAvKrabirmVYFwAMRT2RMg7F9SyKspvk73hfrtbkMPyIhA5FVqi0iBiEZMMQdAui/8E4GPv0oAJkpc6Q3+6goAAGpWBxNQmTLFmgL3jSJNgQdGv4pMts2EKm7ICJB/aG0xNdz74VEk13UYCx1/twPR8JjDT8wttyLZtkoAxSb8ZDCz0gdfKxWkFURf2v9qTYH7SK7rQIDn0P3nA0ehixvfwZwE0X9vBE/mW8piohhl1WH18UQBhYnre8N/L8b8xQvlx4ACbB4NnzaeRYDnKm0EALCMLXy84hwuTCXL/ExoB1E7qcK/8NCLIq5HcTT0i6u8TYbXUM1cAyyveVq8Xls7XhYrvY/4n3gC8C+dsmAzL1YUiyfWxvHzsy/w/dNd+KjhW2yvv/RfXr7x9QDcmo1he2RBiCCI1Q8jVj9szPNixVfgz+UiIGyDSrcoRu2J16d3I6e1VYvNSQjXpnucAcEPUOkGYZs/l4uUhowt/3kqu1UIv9n90fAY9jT3YBlbRvFTD4fw++wHjhiTRL/bG75t0jI2ITcHb5om4Xgmhv57xpGOg3d/NIqryOR7z+r+MC6qBJB/ZB2t9Om1D5lFm843G/3E3HI7Yh1xDRAfzLQr5EClBf/HBHK462TG2J0OABXeyWDPZ8VqxmBWYscpyghwtTd4EKpDTjCZdCNmzFM9k+4LHXIFACJN94Z6FiFEpKDQw9HndWsEuhnADVMhAUaYJBp9XrcGQKJ4qFE9k+6r2+MG3k5N8VQ22TVglbX2ZwOzX2VvNKr91zmY6S7N6zqZicVT2WNLyVSehESaBhxnOALfMeYX+K/S2yv7wmMAlvwyuR7FxQUyf0fgc/jztfkJr7XeGgC8BJJgWNV8ImT+AAAAAElFTkSuQmCC'
  }
  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Display markers
function mecano02()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'mecano2' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'mecano2' and PlayerData.job2.service == 1) then
      for k,v in pairs(Config_esx_mecanojob2.Zones) do
        if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_esx_mecanojob2.DrawDistance) then
          DrawMarker(0, v.Pos.x, v.Pos.y, v.Pos.z +0.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 100, false, true, 2, false, false, false, false)
        end
      end
    end
end

-- Enter / Exit marker events
function mecano01()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'mecano2' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'mecano2' and PlayerData.job2.service == 1) then
      
      local isInMarker  = false
      local currentZone = nil
      for k,v in pairs(Config_esx_mecanojob2.Zones) do
        if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
          isInMarker  = true
          currentZone = k
        end
      end
      if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
        HasAlreadyEnteredMarker = true
        LastZone                = currentZone
        TriggerEvent('esx_mecanojob2:hasEnteredMarker', currentZone)
      end
      if not isInMarker and HasAlreadyEnteredMarker then
        HasAlreadyEnteredMarker = false
        TriggerEvent('esx_mecanojob2:hasExitedMarker', LastZone)
      end
    end
end

--3D Text Interaction
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

function mecano04()
	if (PlayerData.job ~= nil and PlayerData.job.name == 'mecano2' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'mecano2' and PlayerData.job2.service == 1) then
		if GetDistanceBetweenCoords(coords, Config_esx_mecanojob2.Zones.MecanoActions.Pos.x, Config_esx_mecanojob2.Zones.MecanoActions.Pos.y, Config_esx_mecanojob2.Zones.MecanoActions.Pos.z,  true) < 2.0 then
			sleepThread = 20
			DrawText3Ds(Config_esx_mecanojob2.Zones.MecanoActions.Pos.x, Config_esx_mecanojob2.Zones.MecanoActions.Pos.y, Config_esx_mecanojob2.Zones.MecanoActions.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au menu')	
		end
	end
  if (PlayerData.job.grade_name == 'boss') then
    if GetDistanceBetweenCoords(coords, Config_esx_mecanojob2.Zones.Shops.Pos.x, Config_esx_mecanojob2.Zones.Shops.Pos.y, Config_esx_mecanojob2.Zones.Shops.Pos.z,  true) < 2.0 then
      sleepThread = 20
      DrawText3Ds(Config_esx_mecanojob2.Zones.Shops.Pos.x, Config_esx_mecanojob2.Zones.Shops.Pos.y, Config_esx_mecanojob2.Zones.Shops.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour ouvrir le stock')
    end  
  end
end

-- Key Controls
function mecano03()
        if CurrentAction ~= nil then

          if IsControlJustReleased(0, 177) then
			ESX.UI.Menu.CloseAll()
			CurrentAction = nil
		  end

          if (IsControlJustReleased(0, 38) and PlayerData.job ~= nil and PlayerData.job.name == 'mecano2' and PlayerData.job.service == 1) or 
		          (IsControlJustReleased(0, 38) and PlayerData.job2 ~= nil and PlayerData.job2.name == 'mecano2' and PlayerData.job2.service == 1) then

            if CurrentAction == 'mecano_actions_menu' then
                meca2_OpenMecanoActionsMenu()
            end

            if CurrentAction == 'remove_entity' then
              DeleteEntity(CurrentActionData.entity)
            end

            if CurrentAction == 'menu_shop' and PlayerData.job.grade_name == 'boss' then
              mecano_OpenShopMenu(CurrentActionData.zone)
            end

            CurrentAction = nil
          end
        end
end

RegisterNetEvent('esx_mecanojob2:openMenuJob')
AddEventHandler('esx_mecanojob2:openMenuJob', function()
	meca2_OpenMobileMecanoActionsMenu()
end)

------------------------
-----------------------
xSound = exports.xsound
RegisterNetEvent("esx_mecano2:playmusic")
AddEventHandler("esx_mecano2:playmusic", function(data)
    local pos = vec3(1176.85, 2640.25, 37.75)
    if xSound:soundExists("mecano2") then
      xSound:Destroy("mecano2")
    end
    xSound:PlayUrlPos("mecano2", data, 0.1, pos)
    xSound:Distance("mecano2", 30)
    xSound:Position("mecano2", pos)
end)

RegisterNetEvent("esx_mecano2:pausemecano2")
AddEventHandler("esx_mecano2:pausemecano2", function(status)
	if status == "play" then
    xSound:Resume("mecano2")
	elseif status == "pause" then
    xSound:Pause("mecano2")
	end
end)

RegisterNetEvent("esx_mecano2:volumemecano2")
AddEventHandler("esx_mecano2:volumemecano2", function(volume)
	print(volume/100)
    xSound:setVolume("mecano2", volume / 100)
end)

RegisterNetEvent("esx_mecano2:stopmecano2")
AddEventHandler("esx_mecano2:stopmecano2", function()
    xSound:Destroy("mecano2")
end)
