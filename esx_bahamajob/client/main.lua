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

local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local PedBlacklist            = {}

function bahama_SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 0,
    modBrakes       = 0,
    modTransmission = 0,
    modSuspension   = 0,
    modTurbo        = false,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function bahama_SetWindowTint(vehicle)

  local props = {
    windowTint       = 1,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end


function bahama_OpenRoomMenu()

  ESX.UI.Menu.CloseAll()

  local elements = {}

    table.insert(elements, {label = "Vêtements", value = 'player_dressing'})
    table.insert(elements, {label = "Supprimer des tenues", value = 'remove_cloth'})

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
        
      if data.current.value == 'remove_cloth' then
          ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
              local elements = {}
      
              for i=1, #dressing, 1 do
                  table.insert(elements, {label = dressing[i].label, value = i})
              end

              table.sort(elements, function (x, y) return string.lower(x.label) < string.lower(y.label) end)
              
              ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'remove_cloth',
              {
                title    = "Supprimer des tenues",
                align = 'right',
                elements = elements,
              },
              function(data, menu)
                  menu.close()
                  TriggerServerEvent('esx_property:removeOutfit', data.current.value)
                  ESX.ShowNotification("Cette tenue a bien été supprimée de votre garde robe !")
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

function bahama_OpenCloakroomMenu()

  local elements = {
        {label = "Civil", value = 'citizen_wear'},
		{label = "Dressing", value = 'dressing'},
		{label = "Vigiles", value = 'vigiles'},
        {label = "Barman", value = 'barman_outfit'},
        {label = "Danceur", value = 'com_outfit'},
      }

  ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cloakroom',
      {
        title    = 'cloakroom',
        align = 'right',
        elements = elements,
        },

        function(data, menu)

		if data.current.value == 'dressing' then
			bahama_OpenRoomMenu()
		end

        if data.current.value == 'citizen_wear' then
		  TriggerServerEvent("player:serviceOff", "bahama")
		
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)

                TriggerEvent('skinchanger:loadSkin', skin)
                ClearPedBloodDamage(playerPed)
                ResetPedVisibleDamage(playerPed)
                ClearPedLastWeaponDamage(playerPed)

                ResetPedMovementClipset(playerPed, 0)
            end)
        end
		
		if data.current.value == 'vigiles' then

		  TriggerServerEvent("player:serviceOn", "bahama")

            TriggerEvent('skinchanger:getSkin', function(skin)
        
                if skin.sex == 0 then

                    local clothesSkin = {
                        ['tshirt_1'] = 31, ['tshirt_2'] = 0,
                        ['torso_1'] = 29, ['torso_2'] = 0,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 22,
                        ['pants_1'] = 24, ['pants_2'] = 0,
                        ['shoes_1'] = 20, ['shoes_2'] = 3,
                        ['chain_1'] = 28, ['chain_2'] = 2
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                else

                    local clothesSkin = {
                        ['tshirt_1'] = 60, ['tshirt_2'] = 1,
                        ['torso_1'] = 25, ['torso_2'] = 0,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 6,
                        ['pants_1'] = 54, ['pants_2'] = 2,
                        ['shoes_1'] = 77, ['shoes_2'] = 0,
                        ['chain_1'] = 68, ['chain_2'] = 1
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                end

                ClearPedBloodDamage(playerPed)
                ResetPedVisibleDamage(playerPed)
                ClearPedLastWeaponDamage(playerPed)

                ResetPedMovementClipset(playerPed, 0)

                isBarman = true

            end)
        end
		
        if data.current.value == 'barman_outfit' then

		  TriggerServerEvent("player:serviceOn", "bahama")

            TriggerEvent('skinchanger:getSkin', function(skin)
        
                if skin.sex == 0 then

                    local clothesSkin = {
                        ['tshirt_1'] = 6, ['tshirt_2'] = 4,
                        ['torso_1'] = 11, ['torso_2'] = 0,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 11,
                        ['pants_1'] = 24, ['pants_2'] = 1,
                        ['shoes_1'] = 10, ['shoes_2'] = 0,
                        ['chain_1'] = 24, ['chain_2'] = 2
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                else

                    local clothesSkin = {
                        ['tshirt_1'] = 60, ['tshirt_2'] = 1,
                        ['torso_1'] = 25, ['torso_2'] = 0,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 6,
                        ['pants_1'] = 54, ['pants_2'] = 2,
                        ['shoes_1'] = 77, ['shoes_2'] = 0,
                        ['chain_1'] = 68, ['chain_2'] = 1
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                end

                ClearPedBloodDamage(playerPed)
                ResetPedVisibleDamage(playerPed)
                ClearPedLastWeaponDamage(playerPed)

                ResetPedMovementClipset(playerPed, 0)

            end)
        end
        if data.current.value == 'com_outfit' then

		  TriggerServerEvent("player:serviceOn", "bahama")

            TriggerEvent('skinchanger:getSkin', function(skin)

                if skin.sex == 0 then

                    local clothesSkin = {
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                        ['torso_1'] = 15, ['torso_2'] = 0,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 40,
                        ['pants_1'] = 61, ['pants_2'] = 9,
                        ['shoes_1'] = 16, ['shoes_2'] = 9,
                        ['chain_1'] = 118, ['chain_2'] = 0
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                    RequestAnimSet("MOVE_M@POSH@")
                    while not HasAnimSetLoaded("MOVE_M@POSH@") do
                      Citizen.Wait(1)
                    end
                    SetPedMovementClipset(playerPed, "MOVE_M@POSH@", true)

                else

                    local clothesSkin = {
                        ['tshirt_1'] = 13, ['tshirt_2'] = 11,
                        ['torso_1'] = 13, ['torso_2'] = 11,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 4,
                        ['pants_1'] = 17, ['pants_2'] = 8,
                        ['shoes_1'] = 19, ['shoes_2'] = 10,
                        ['chain_1'] = 12, ['chain_2'] = 0
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                    RequestAnimSet("MOVE_F@POSH@")
                    while not HasAnimSetLoaded("MOVE_F@POSH@") do
                      Citizen.Wait(1)
                    end
                    SetPedMovementClipset(playerPed, "MOVE_F@POSH@", true)

                end

                ClearPedBloodDamage(playerPed)
                ResetPedVisibleDamage(playerPed)
                ClearPedLastWeaponDamage(playerPed)

            end)
        end

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
      CurrentActionData = {}
    end
    )

end

function bahama_OpenVehicleSpawnerMenu()

  local vehicles = Config_esx_bahamajob.Zones.Vehicles

  ESX.UI.Menu.CloseAll()

    local elements = {}

	table.insert(elements, {label = "Cognoscenti 55", value = "cog55"})
	table.insert(elements, {label = "Revolter", value = "revolter"})
	table.insert(elements, {label = "Baller Sport", value = "baller2"})
    table.insert(elements, {label = "Limousine", value = "stretch"})
	table.insert(elements, {label = "Mule", value = "speedobox"})
	
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = 'Garage Vehicule',
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        local vehicle = GetClosestVehicle(vehicles.SpawnPoint.x,  vehicles.SpawnPoint.y,  vehicles.SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

          --local playerPed = GetPlayerPed(-1)

            ESX.Game.SpawnVehicle(model, {
              x = vehicles.SpawnPoint.x,
              y = vehicles.SpawnPoint.y,
              z = vehicles.SpawnPoint.z
            }, vehicles.Heading, function(vehicle)
              TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1) -- teleport into vehicle
			  local rand = math.random(10,99)
			  SetVehicleNumberPlateText(vehicle, "BAHAMA" .. rand)
              SetVehicleDirtLevel(vehicle, 0)
			  
        TriggerEvent('esx_vehiclelock:givekey', "BAHAMA" .. rand)
        
        if model == 'speedobox' then
          SetVehicleLivery(vehicle, 9)
          end
			  
			  bahama_SetVehicleMaxMods(vehicle)
              bahama_SetWindowTint(vehicle)
			  SetVehicleColours(vehicle, 0, 0)
						  
            end)

        else
          ESX.ShowNotification('vehicle out')
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = 'vehicle_spawner'
        CurrentActionData = {}

      end
    )



end


function bahama_OpenBahamaCocktailMenu()

  TriggerEvent('Nebula_restaurants:OpenMenu', "bahama", true)
end

function OpenMobileBahamaActionsMenu()

 	ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'boss_actions',
    {
      title    = 'Bahama Mamas',
	  align = 'right',
      elements = {
      	{label = 'Facturation', value = 'billing'}
    	}
    },
    function(data, menu)

			if data.current.value == 'billing' then

				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'billing',
					{
						title = 'Montant de la facture'
					},
					function(data, menu)

						local amount = tonumber(data.value)

						if amount == nil then
							TriggerEvent('Core:ShowNotification', 'Montant invalide')
						else
							
							menu.close()
							
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('Aucun joueur à proximité')
							else
								TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_bahama', 'Bahama Mamas', amount)
                TriggerServerEvent('CoreLog:SendDiscordLog', "Bahama - Factures", "**" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$"..amount.."`", "Yellow")
							end

						end

					end,
					function(data, menu)
						menu.close()
					end
				)

			end

    end,
    function(data, menu)
    	menu.close()
    end
  )

end

RegisterNetEvent('esx_bahamajob:openMenuJob')
AddEventHandler('esx_bahamajob:openMenuJob', function()
	OpenMobileBahamaActionsMenu()
end)

function bahama_OpenGetFridgeStocksMenu()

  ESX.TriggerServerCallback('esx_bahamajob:getFridgeStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fridge_menu',
      {
        title    = 'Frigo',
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'fridge_menu_get_item_count',
          {
            title = 'Quantité'
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification('Quantité invalide')
            else
              menu2.close()
              menu.close()
              bahama_OpenGetFridgeStocksMenu()
			  --TriggerServerEvent('bahamasbot:GetFridgeStocks', itemName, count)
              TriggerServerEvent('esx_bahamajob:getFridgeStockItem', itemName, count)
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

function bahama_OpenPutFridgeStocksMenu()

ESX.TriggerServerCallback('esx_bahamajob:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fridge_menu',
      {
        title    = 'Inventaire',
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'fridge_menu_put_item_count',
          {
            title = 'Quantité'
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification('Quantité invalide')
            else
              menu2.close()
              menu.close()
              bahama_OpenPutFridgeStocksMenu()
			  --TriggerServerEvent('bahamasbot:PutFridgeStocks', itemName, count)
              TriggerServerEvent('esx_bahamajob:putFridgeStockItems', itemName, count)
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

function bahama_OpenFridgeMenu()

  local elements = {
    {label = 'Ouvrir l\'armurerie', value = 'get_weapon'},
    {label = 'Ouvrir le stockage', value = 'get_stock'}
  }    

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fridge',
      {
        title    = 'Frigo',
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'get_weapon' then
          TriggerEvent('core_inventory:client:openSocietyWeaponsInventory', 'society_bahama')
          menu.close()
        end
        if data.current.value == 'get_stock' then
          TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_bahama')
          menu.close()
        end

      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_fridge'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au frigo'
        CurrentActionData = {}
      end
    )

end


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  while (PlayerData.job or PlayerData.job2) == nil do
    Citizen.Wait(10)
  end
  if (PlayerData.job.name == 'bahama'  and PlayerData.job.service == 1) or (PlayerData.job2.name == 'bahama'  and PlayerData.job2.service == 1) then
		Config_esx_bahamajob.Zones.Vehicles.Type = 1
		Config_esx_bahamajob.Zones.VehicleDeleters.Type = 1
		Config_esx_bahamajob.Zones.BahamaActionsBoss.Type = 1
		Config_esx_bahamajob.Zones.BahamaStockBoss.Type = 1
    Config_esx_bahamajob.Zones.BahamaStockBoss2.Type = 1
		Config_esx_bahamajob.Zones.BahamaCocktail.Type = 1
		Config_esx_bahamajob.Zones.Cloakrooms.Type = 1
		Config_esx_bahamajob.Zones.BahamaCocktail2.Type = 1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter.Type = 1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter2.Type = 1
		Config_esx_bahamajob.Zones.BahamaComptoirEnterZ.Type = 1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter2Z.Type = 1
		
		Config_esx_bahamajob.Zones.BahamaVehEnterZ.Type = 1
		Config_esx_bahamajob.Zones.BahamaVehEnter2Z.Type = 1
		
	TriggerServerEvent("player:serviceOn", "bahama")
  else
		Config_esx_bahamajob.Zones.Vehicles.Type = -1
		Config_esx_bahamajob.Zones.VehicleDeleters.Type = -1
		Config_esx_bahamajob.Zones.BahamaActionsBoss.Type = -1
		Config_esx_bahamajob.Zones.BahamaStockBoss.Type = -1
    Config_esx_bahamajob.Zones.BahamaStockBoss2.Type = -1
		Config_esx_bahamajob.Zones.BahamaCocktail.Type = -1
		Config_esx_bahamajob.Zones.Cloakrooms.Type = 1
		Config_esx_bahamajob.Zones.BahamaCocktail2.Type = 1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter.Type = -1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter2.Type = -1
		Config_esx_bahamajob.Zones.BahamaComptoirEnterZ.Type = -1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter2Z.Type = -1
		
		Config_esx_bahamajob.Zones.BahamaVehEnterZ.Type = -1
		Config_esx_bahamajob.Zones.BahamaVehEnter2Z.Type = -1
  end

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  while (PlayerData.job or PlayerData.job2) == nil do
    Citizen.Wait(10)
  end

  if PlayerData.job.name == 'bahama' and PlayerData.job.service == 1 then
		Config_esx_bahamajob.Zones.Vehicles.Type = 1
		Config_esx_bahamajob.Zones.VehicleDeleters.Type = 1
		Config_esx_bahamajob.Zones.BahamaActionsBoss.Type = 1
		Config_esx_bahamajob.Zones.BahamaStockBoss.Type = 1
    Config_esx_bahamajob.Zones.BahamaStockBoss2.Type = 1
		Config_esx_bahamajob.Zones.BahamaCocktail.Type = 1
		Config_esx_bahamajob.Zones.Cloakrooms.Type = 1
		Config_esx_bahamajob.Zones.BahamaCocktail2.Type = 1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter.Type = 1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter2.Type = 1
		Config_esx_bahamajob.Zones.BahamaComptoirEnterZ.Type = 1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter2Z.Type = 1
		
		Config_esx_bahamajob.Zones.BahamaVehEnterZ.Type = 1
		Config_esx_bahamajob.Zones.BahamaVehEnter2Z.Type = 1
	TriggerServerEvent("player:serviceOn", "bahama")
  else
		Config_esx_bahamajob.Zones.Vehicles.Type = -1
		Config_esx_bahamajob.Zones.VehicleDeleters.Type = -1
		Config_esx_bahamajob.Zones.BahamaActionsBoss.Type = -1
		Config_esx_bahamajob.Zones.BahamaStockBoss.Type = -1
    Config_esx_bahamajob.Zones.BahamaStockBoss2.Type = -1
		Config_esx_bahamajob.Zones.BahamaCocktail.Type = -1
		Config_esx_bahamajob.Zones.Cloakrooms.Type = 1
		Config_esx_bahamajob.Zones.BahamaCocktail2.Type = 1		
		Config_esx_bahamajob.Zones.BahamaComptoirEnter.Type = -1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter2.Type = -1
		Config_esx_bahamajob.Zones.BahamaComptoirEnterZ.Type = -1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter2Z.Type = -1
		
		Config_esx_bahamajob.Zones.BahamaVehEnterZ.Type = -1
		Config_esx_bahamajob.Zones.BahamaVehEnter2Z.Type = -1
	end

end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job)
  while (PlayerData.job or PlayerData.job2) == nil do
    Citizen.Wait(10)
  end
  if PlayerData.job2.name == 'bahama' and PlayerData.job2.service == 1 then
		Config_esx_bahamajob.Zones.Vehicles.Type = 1
		Config_esx_bahamajob.Zones.VehicleDeleters.Type = 1
		Config_esx_bahamajob.Zones.BahamaActionsBoss.Type = 1
		Config_esx_bahamajob.Zones.BahamaStockBoss.Type = 1
    Config_esx_bahamajob.Zones.BahamaStockBoss2.Type = 1
		Config_esx_bahamajob.Zones.BahamaCocktail.Type = 1
		Config_esx_bahamajob.Zones.Cloakrooms.Type = 1
		Config_esx_bahamajob.Zones.BahamaCocktail2.Type = 1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter.Type = 1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter2.Type = 1
		Config_esx_bahamajob.Zones.BahamaComptoirEnterZ.Type = 1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter2Z.Type = 1
		
		Config_esx_bahamajob.Zones.BahamaVehEnterZ.Type = 1
		Config_esx_bahamajob.Zones.BahamaVehEnter2Z.Type = 1
	TriggerServerEvent("player:serviceOn", "bahama")
  else
		Config_esx_bahamajob.Zones.Vehicles.Type = -1
		Config_esx_bahamajob.Zones.VehicleDeleters.Type = -1
		Config_esx_bahamajob.Zones.BahamaActionsBoss.Type = -1
		Config_esx_bahamajob.Zones.BahamaStockBoss.Type = -1
    Config_esx_bahamajob.Zones.BahamaStockBoss2.Type = -1
		Config_esx_bahamajob.Zones.BahamaCocktail.Type = -1
		Config_esx_bahamajob.Zones.Cloakrooms.Type = 1
		Config_esx_bahamajob.Zones.BahamaCocktail2.Type = 1		
		Config_esx_bahamajob.Zones.BahamaComptoirEnter.Type = -1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter2.Type = -1
		Config_esx_bahamajob.Zones.BahamaComptoirEnterZ.Type = -1
		Config_esx_bahamajob.Zones.BahamaComptoirEnter2Z.Type = -1
		
		Config_esx_bahamajob.Zones.BahamaVehEnterZ.Type = -1
		Config_esx_bahamajob.Zones.BahamaVehEnter2Z.Type = -1
	end

end)

RegisterNetEvent('esx:setService')
AddEventHandler('esx:setService', function(job, service)
  while (PlayerData.job or PlayerData.job2) == nil do
    Citizen.Wait(10)
  end
  if PlayerData.job or PlayerData.job2 ~= nil then
    if (PlayerData.job.name == 'bahama'  and PlayerData.job.service == 1) or (PlayerData.job2.name == 'bahama'  and PlayerData.job2.service == 1) then
      Config_esx_bahamajob.Zones.Vehicles.Type = 1
      Config_esx_bahamajob.Zones.VehicleDeleters.Type = 1
      Config_esx_bahamajob.Zones.BahamaActionsBoss.Type = 1
      Config_esx_bahamajob.Zones.BahamaStockBoss.Type = 1
      Config_esx_bahamajob.Zones.BahamaStockBoss2.Type = 1
      Config_esx_bahamajob.Zones.BahamaCocktail.Type = 1
      Config_esx_bahamajob.Zones.Cloakrooms.Type = 1
      Config_esx_bahamajob.Zones.BahamaCocktail2.Type = 1
      Config_esx_bahamajob.Zones.BahamaComptoirEnter.Type = 1
      Config_esx_bahamajob.Zones.BahamaComptoirEnter2.Type = 1
      Config_esx_bahamajob.Zones.BahamaComptoirEnterZ.Type = 1
      Config_esx_bahamajob.Zones.BahamaComptoirEnter2Z.Type = 1
      
      Config_esx_bahamajob.Zones.BahamaVehEnterZ.Type = 1
      Config_esx_bahamajob.Zones.BahamaVehEnter2Z.Type = 1
      
    TriggerServerEvent("player:serviceOn", "bahama")
    else
      Config_esx_bahamajob.Zones.Vehicles.Type = -1
      Config_esx_bahamajob.Zones.VehicleDeleters.Type = -1
      Config_esx_bahamajob.Zones.BahamaActionsBoss.Type = -1
      Config_esx_bahamajob.Zones.BahamaStockBoss.Type = -1
      Config_esx_bahamajob.Zones.BahamaStockBoss2.Type = -1
      Config_esx_bahamajob.Zones.BahamaCocktail.Type = -1 
      Config_esx_bahamajob.Zones.Cloakrooms.Type = 1
      Config_esx_bahamajob.Zones.BahamaCocktail2.Type = 1
      Config_esx_bahamajob.Zones.BahamaComptoirEnter.Type = -1
      Config_esx_bahamajob.Zones.BahamaComptoirEnter2.Type = -1
      Config_esx_bahamajob.Zones.BahamaComptoirEnterZ.Type = -1
      Config_esx_bahamajob.Zones.BahamaComptoirEnter2Z.Type = -1
      
      Config_esx_bahamajob.Zones.BahamaVehEnterZ.Type = -1
      Config_esx_bahamajob.Zones.BahamaVehEnter2Z.Type = -1
    end
  end
end)

AddEventHandler('esx_bahamajob:hasEnteredMarker', function(zone)

  if (PlayerData.job ~= nil and PlayerData.job.name == 'bahama' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'bahama' and PlayerData.job2.service == 1) then
  
		if zone == 'BahamaActionsBoss' and (PlayerData.job.name == 'bahama' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) then
			CurrentAction     = 'bahama_actions_menu'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
		end
		
		if zone == 'BahamaStockBoss' then
			CurrentAction     = 'bahama_stock_menu'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
		end

    if zone == 'BahamaStockBoss2' then
			CurrentAction     = 'bahama_stock_menu'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
		end
	  
		--[[if zone == 'Vehicles' then
			CurrentAction     = 'menu_vehicle_spawner'
			CurrentActionMsg  = 'vehicle_spawner'
			CurrentActionData = {}
		end

		if zone == 'VehicleDeleters' then

		  if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle = GetVehiclePedIsIn(playerPed,  false)

			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = 'store_vehicle'
			CurrentActionData = {vehicle = vehicle}
		  end

		end]]

		if zone == 'Cloakrooms' then
			CurrentAction     = 'menu_cloakroom'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
		end
		
		if zone == 'BahamaCocktail' then
			CurrentAction     = 'bahama_cocktail_menu'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
		end
	  
		if zone == 'BahamaCocktail2' then
			CurrentAction     = 'bahama_cocktail_menu'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
		end

		if zone == 'BahamaComptoirEnter' then
			TeleportFadeEffect(GetPlayerPed(-1), Config_esx_bahamajob.Zones.BahamaComptoirExit.Pos)
		end
		if zone == 'BahamaComptoirEnter2' then
			TeleportFadeEffect(GetPlayerPed(-1), Config_esx_bahamajob.Zones.BahamaComptoirExit2.Pos)
		end
		
		if zone == 'BahamaComptoirEnterZ' then
			TeleportFadeEffect(GetPlayerPed(-1), Config_esx_bahamajob.Zones.BahamaComptoirExitZ.Pos)
		end
		if zone == 'BahamaComptoirEnter2Z' then
			TeleportFadeEffect(GetPlayerPed(-1), Config_esx_bahamajob.Zones.BahamaComptoirExit2Z.Pos)
		end
		
		if zone == 'BahamaVehEnterZ' then
			TeleportFadeEffect(GetPlayerPed(-1), Config_esx_bahamajob.Zones.BahamaVehExitZ.Pos)
		end
		if zone == 'BahamaVehEnter2Z' then
			TeleportFadeEffect(GetPlayerPed(-1), Config_esx_bahamajob.Zones.BahamaVehExit2Z.Pos)
		end
	
	end

end)

AddEventHandler('esx_bahamajob:hasExitedMarker', function(zone)
	if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
		TriggerServerEvent('esx_bahamajob:stopCraft')
		TriggerServerEvent('esx_bahamajob:stopCraft2')
		TriggerServerEvent('esx_bahamajob:stopCraft3')
		TriggerServerEvent('esx_bahamajob:stopCraft4')
	end
end)

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
function bahama03()
		if (PlayerData.job ~= nil and PlayerData.job.name == 'bahama' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'bahama' and PlayerData.job2.service == 1) then
			
			
			if GetDistanceBetweenCoords(coords, Config_esx_bahamajob.Zones.Cloakrooms.Pos.x, Config_esx_bahamajob.Zones.Cloakrooms.Pos.y, Config_esx_bahamajob.Zones.Cloakrooms.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_bahamajob.Zones.Cloakrooms.Pos.x, Config_esx_bahamajob.Zones.Cloakrooms.Pos.y, Config_esx_bahamajob.Zones.Cloakrooms.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour vous changer')
			end
			if GetDistanceBetweenCoords(coords, Config_esx_bahamajob.Zones.BahamaStockBoss.Pos.x, Config_esx_bahamajob.Zones.BahamaStockBoss.Pos.y, Config_esx_bahamajob.Zones.BahamaStockBoss.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_bahamajob.Zones.BahamaStockBoss.Pos.x, Config_esx_bahamajob.Zones.BahamaStockBoss.Pos.y, Config_esx_bahamajob.Zones.BahamaStockBoss.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au frigo')
			end
      if GetDistanceBetweenCoords(coords, Config_esx_bahamajob.Zones.BahamaStockBoss2.Pos.x, Config_esx_bahamajob.Zones.BahamaStockBoss2.Pos.y, Config_esx_bahamajob.Zones.BahamaStockBoss2.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_bahamajob.Zones.BahamaStockBoss2.Pos.x, Config_esx_bahamajob.Zones.BahamaStockBoss2.Pos.y, Config_esx_bahamajob.Zones.BahamaStockBoss2.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au frigo')
			end
			if GetDistanceBetweenCoords(coords, Config_esx_bahamajob.Zones.BahamaCocktail.Pos.x, Config_esx_bahamajob.Zones.BahamaCocktail.Pos.y, Config_esx_bahamajob.Zones.BahamaCocktail.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_bahamajob.Zones.BahamaCocktail.Pos.x, Config_esx_bahamajob.Zones.BahamaCocktail.Pos.y, Config_esx_bahamajob.Zones.BahamaCocktail.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au cocktail')
			end
			if GetDistanceBetweenCoords(coords, Config_esx_bahamajob.Zones.BahamaCocktail2.Pos.x, Config_esx_bahamajob.Zones.BahamaCocktail2.Pos.y, Config_esx_bahamajob.Zones.BahamaCocktail2.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_bahamajob.Zones.BahamaCocktail2.Pos.x, Config_esx_bahamajob.Zones.BahamaCocktail2.Pos.y, Config_esx_bahamajob.Zones.BahamaCocktail2.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au cocktail')
			end
			--[[if GetDistanceBetweenCoords(coords, Config_esx_bahamajob.Zones.Vehicles.Pos.x, Config_esx_bahamajob.Zones.Vehicles.Pos.y, Config_esx_bahamajob.Zones.Vehicles.Pos.z,  true) < 2.0 then
				DrawText3Ds(Config_esx_bahamajob.Zones.Vehicles.Pos.x, Config_esx_bahamajob.Zones.Vehicles.Pos.y, Config_esx_bahamajob.Zones.Vehicles.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour sortir un véhicule')
			end
			if GetDistanceBetweenCoords(coords, Config_esx_bahamajob.Zones.VehicleDeleters.Pos.x, Config_esx_bahamajob.Zones.VehicleDeleters.Pos.y, Config_esx_bahamajob.Zones.VehicleDeleters.Pos.z,  true) < 2.0 then
				DrawText3Ds(Config_esx_bahamajob.Zones.VehicleDeleters.Pos.x, Config_esx_bahamajob.Zones.VehicleDeleters.Pos.y, Config_esx_bahamajob.Zones.VehicleDeleters.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour ranger le véhicule')
			end]]
			
			
			if (PlayerData.job ~= nil and PlayerData.job.name == 'bahama' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'bahama' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then
				if GetDistanceBetweenCoords(coords, Config_esx_bahamajob.Zones.BahamaActionsBoss.Pos.x, Config_esx_bahamajob.Zones.BahamaActionsBoss.Pos.y, Config_esx_bahamajob.Zones.BahamaActionsBoss.Pos.z,  true) < 2.0 then
          sleepThread = 20
          DrawText3Ds(Config_esx_bahamajob.Zones.BahamaActionsBoss.Pos.x, Config_esx_bahamajob.Zones.BahamaActionsBoss.Pos.y, Config_esx_bahamajob.Zones.BahamaActionsBoss.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au boss menu')
				end
			end
		end
end

-- Create blips
Citizen.CreateThread(function()

 local blip = AddBlipForCoord(Config_esx_bahamajob.Zones.Bahama.Pos.x, Config_esx_bahamajob.Zones.Bahama.Pos.y, Config_esx_bahamajob.Zones.Bahama.Pos.z)
  
  SetBlipSprite (blip, 93)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.6)
  SetBlipColour (blip, 8)
  SetBlipAsShortRange(blip, true)
  
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Bahama")
  EndTextCommandSetBlipName(blip)

end)

-- Display markers
function bahama01()
    
    
    for k,v in pairs(Config_esx_bahamajob.Zones) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_esx_bahamajob.DrawDistance) then
        DrawMarker(0, v.Pos.x, v.Pos.y, v.Pos.z+0.25, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.2, 0.2, 0.2, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
      end
    end
end

-- Enter / Exit marker events
function bahama02()
    local coords          = coords
    local isInMarker      = false
    local currentZone     = nil

    for k,v in pairs(Config_esx_bahamajob.Zones) do
      if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
        isInMarker      = true
        currentZone     = k
      end
    end

    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
      HasAlreadyEnteredMarker = true
      LastZone                = currentZone
      TriggerEvent('esx_bahamajob:hasEnteredMarker', currentZone)
    end

    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_bahamajob:hasExitedMarker', LastZone)
    end

end

-- Key Controls
function bahama04()
    if CurrentAction ~= nil then

      if IsControlJustReleased(0, Keys['BACKSPACE']) then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	  end
	  
	  if (PlayerData.job ~= nil and PlayerData.job.name == 'bahama' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'bahama' and PlayerData.job2.service == 1) then

		  if IsControlJustReleased(0, Keys['E']) then

			if CurrentAction == 'bahama_actions_menu'  then  
			  TriggerEvent('esx_society:openBossMenu', 'bahama', function(data, menu)
				menu.close()
			  end)
			end
					
			if CurrentAction == 'bahama_stock_menu' then
			  bahama_OpenFridgeMenu()
			end

			if CurrentAction == 'bahama_cocktail_menu' then  
			  bahama_OpenBahamaCocktailMenu()
			end
			
			if CurrentAction == 'menu_cloakroom' then  
			  bahama_OpenCloakroomMenu()
			end
			
			--if CurrentAction == 'delete_vehicle' then
			  --ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
			--end
			
			--if CurrentAction == 'menu_vehicle_spawner' then
				--bahama_OpenVehicleSpawnerMenu()
			--end
			
			CurrentAction = nil
		  end
	  
	  end

    end
end

function TeleportFadeEffect(entity, coords)

	Citizen.CreateThread(function()

		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(1)
		end

		ESX.Game.Teleport(entity, coords, function()
			DoScreenFadeIn(800)
		end)

	end)

end

function Bahama_OpenPutWeaponMenu()

	local elements   = {}
	local weaponList = ESX.GetWeaponList()
  
	for i=1, #weaponList, 1 do  
	  local weaponHash = GetHashKey(weaponList[i].name)
  
	  if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
		local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
		table.insert(elements, {label = weaponList[i].label..'['..ammo..']', value = weaponList[i].name})
	  end
  
	end
  
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'armory_put_weapon',
	  {
		title    = "Déposer une arme",
		align = 'right',
		elements = elements,
	  },
	  function(data, menu)
  
		menu.close()
		ESX.TriggerServerCallback('esx_groupes:addArmoryWeapon', function(isAdded)
			bahama_OpenFridgeMenu()
			while isAdded == nil do
				Citizen.Wait(10)
			end
			if isAdded then  
        TriggerServerEvent('CoreLog:SendDiscordLog', 'Bahama - Coffre', "`[COFFRE]` "..GetPlayerName(PlayerId()) .. " a déposé `[".. ESX.GetWeaponLabel(data.current.value) .."]`", 'Green')      
				local weaponList = ESX.GetWeaponList()
				local playerPed = PlayerPedId()
			
				for i=1, #weaponList, 1 do
			
				if weaponList[i].name == data.current.value then
			
					local weaponHash = GetHashKey(weaponList[i].name)
			
					while HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' do
					local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
					local weaponHash = GetHashKey(data.current.value)
			
					RemoveWeaponFromPed(playerPed, weaponHash)
					TriggerEvent('esx:removeInventoryItem', {label = ESX.GetWeaponLabel(data.current.value)}, 1)
					
					if ammo then
						local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
						local finalAmmo = math.floor(pedAmmo - ammo)
						SetPedAmmo(playerPed, weaponHash, finalAmmo)
					else
						SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo
					end
					Citizen.Wait(0)
					end
				end
			end
		  end
		end, data.current.value, "bahama", ESX.GetWeaponLabel(data.current.value))  
	  end,
	  function(data, menu)
		menu.close()
	  end)
end

function Bahama_OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_groupes:getArmoryWeapons', function(weapons)

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
    'default', GetCurrentResourceName(), 'armory_get_weapon',
    {
      title    = "Prendre une arme",
      align = 'right',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_groupes:removeArmoryWeapon', function()
        bahama_OpenFridgeMenu()
        TriggerServerEvent('CoreLog:SendDiscordLog', 'Bahama - Coffre', "`[COFFRE]` "..GetPlayerName(PlayerId()) .. " a récupéré `[".. ESX.GetWeaponLabel(data.current.value) .."]`", 'Red')
      end, data.current.value, "bahama", ESX.GetWeaponLabel(data.current.value))

    end,
    function(data, menu)
      menu.close()
    end)
  end, "bahama")
end

xSound = exports.xsound
RegisterNetEvent("esx_bahamajob:playmusic")
AddEventHandler("esx_bahamajob:playmusic", function(data)
    local pos = vec3(-1392.93, -614.85, 30.81)
    if xSound:soundExists("bahama") then
      xSound:Destroy("bahama")
    end
    xSound:PlayUrlPos("bahama", data, 0.1, pos)
    xSound:Distance("bahama", 30)
    xSound:Position("bahama", pos)
end)

RegisterNetEvent("esx_bahamajob:pausebahama")
AddEventHandler("esx_bahamajob:pausebahama", function(status)
	if status == "play" then
    xSound:Resume("bahama")
	elseif status == "pause" then
    xSound:Pause("bahama")
	end
end)

RegisterNetEvent("esx_bahamajob:volumebahama")
AddEventHandler("esx_bahamajob:volumebahama", function(volume)
	print(volume/100)
    xSound:setVolume("bahama", volume / 100)
end)

RegisterNetEvent("esx_bahamajob:stopbahama")
AddEventHandler("esx_bahamajob:stopbahama", function()
    xSound:Destroy("bahama")
end)