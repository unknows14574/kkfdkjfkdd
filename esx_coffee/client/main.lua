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
local Blips                   = {}
local PedBlacklist            = {}

function coffee_SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 0,
    modBrakes       = 0,
    modTransmission = 0,
    modSuspension   = 0,
    modTurbo        = false,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function coffee_SetWindowTint(vehicle)

  local props = {
    windowTint       = 1,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end


function coffee_OpenRoomMenu()

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

function coffee_OpenCloakroomMenu()

  local elements = {
		{label = "Dressing", value = 'dressing'},
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
			coffee_OpenRoomMenu()
		end

        if data.current.value == 'citizen_wear' then
		  TriggerServerEvent("player:serviceOff", "coffee")
		
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)

                TriggerEvent('skinchanger:loadSkin', skin)
                ClearPedBloodDamage(playerPed)
                ResetPedVisibleDamage(playerPed)
                ClearPedLastWeaponDamage(playerPed)

                ResetPedMovementClipset(playerPed, 0)
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

function coffee_OpenVehicleSpawnerMenu()

  local vehicles = Config_esx_coffee.Zones.Vehicles

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
			  SetVehicleNumberPlateText(vehicle, "coffee" .. rand)
              SetVehicleDirtLevel(vehicle, 0)
			  
        TriggerEvent('esx_vehiclelock:givekey', "coffee" .. rand)
        
        if model == 'speedobox' then
          SetVehicleLivery(vehicle, 9)
          end
			  
			  coffee_SetVehicleMaxMods(vehicle)
              coffee_SetWindowTint(vehicle)
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


function coffee_OpencoffeeCocktailMenu()

    local elements = {}
    for i=1, #Config_esx_coffee.Shops.Items, 1 do

        local item = Config_esx_coffee.Shops.Items[i]

        table.insert(elements, {
            label     = item.label,
            realLabel = item.label,
            value     = item.name,
            price     = item.price
        })

    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'coffee_cocktail_menu',
        {
            title    = 'Bean Machine Shop',
			align = 'right',
            elements = elements
        },
        function(data, menu)
            TriggerServerEvent('esx_coffee:buyItem', data.current.value, data.current.price, data.current.realLabel)
        end,
        function(data, menu)
            menu.close()
        end
    )

end

function OpenMobilecoffeeActionsMenu()

 	ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'boss_actions',
    {
      title    = 'Bean Machine',
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
								TriggerEvent('Core:ShowNotification','Aucun joueur à proximité')
							else
								TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_coffee', 'Bean machine coffee', amount)
                TriggerServerEvent('CoreLog:SendDiscordLog', "Bean Coffee - Factures", "**" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$"..amount.."`", "Yellow")
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

RegisterNetEvent('esx_coffee:openMenuJob')
AddEventHandler('esx_coffee:openMenuJob', function()
	OpenMobilecoffeeActionsMenu()
end)

function coffee_OpenGetFridgeStocksMenu()

  ESX.TriggerServerCallback('esx_coffee:getFridgeStockItems', function(items)

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
              coffee_OpenGetFridgeStocksMenu()
			      --TriggerServerEvent('coffeesbot:GetFridgeStocks', itemName, count)
              TriggerServerEvent('esx_coffee:getFridgeStockItem', itemName, count)
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

function coffee_OpenPutFridgeStocksMenu()

ESX.TriggerServerCallback('esx_coffee:getPlayerInventory', function(inventory)

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
              coffee_OpenPutFridgeStocksMenu()
			      --TriggerServerEvent('coffeesbot:PutFridgeStocks', itemName, count)
              TriggerServerEvent('esx_coffee:putFridgeStockItems', itemName, count)
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

function coffee_OpenFridgeMenu()

  local elements = {
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

        if data.current.value == 'get_stock' then
          TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_coffee')
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
  if PlayerData.job2.name == "coffee" or PlayerData.job.name == "coffee" then
    coffee_shopBlip()
  end
  if (PlayerData.job.name == 'coffee'  and PlayerData.job.service == 1) or (PlayerData.job2.name == 'coffee'  and PlayerData.job2.service == 1) then
		Config_esx_coffee.Zones.Vehicles.Type = 1
		Config_esx_coffee.Zones.VehicleDeleters.Type = 1
		Config_esx_coffee.Zones.coffeeActionsBoss.Type = 1
		Config_esx_coffee.Zones.coffeeStockBoss.Type = 1
		Config_esx_coffee.Zones.coffeeCocktail.Type = 1
		Config_esx_coffee.Zones.Cloakrooms.Type = 1
		
		Config_esx_coffee.Zones.coffeeVehEnterZ.Type = 1
		Config_esx_coffee.Zones.coffeeVehEnter2Z.Type = 1
		
	TriggerServerEvent("player:serviceOn", "coffee")
  else
		Config_esx_coffee.Zones.Vehicles.Type = -1
		Config_esx_coffee.Zones.VehicleDeleters.Type = -1
		Config_esx_coffee.Zones.coffeeActionsBoss.Type = -1
		Config_esx_coffee.Zones.coffeeStockBoss.Type = -1
		Config_esx_coffee.Zones.coffeeCocktail.Type = -1 
		Config_esx_coffee.Zones.Cloakrooms.Type = -1
		
		Config_esx_coffee.Zones.coffeeVehEnterZ.Type = -1
		Config_esx_coffee.Zones.coffeeVehEnter2Z.Type = -1
  end

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  while (PlayerData.job or PlayerData.job2) == nil do
    Citizen.Wait(10)
  end
  if PlayerData.job.name == "coffee" then
    coffee_shopBlip()
  end
  if PlayerData.job.name == 'coffee' and PlayerData.job.service == 1 then
		Config_esx_coffee.Zones.Vehicles.Type = 1
		Config_esx_coffee.Zones.VehicleDeleters.Type = 1
		Config_esx_coffee.Zones.coffeeActionsBoss.Type = 1
		Config_esx_coffee.Zones.coffeeStockBoss.Type = 1
		Config_esx_coffee.Zones.coffeeCocktail.Type = 1
		Config_esx_coffee.Zones.Cloakrooms.Type = 1
		
		Config_esx_coffee.Zones.coffeeVehEnterZ.Type = 1
		Config_esx_coffee.Zones.coffeeVehEnter2Z.Type = 1
	TriggerServerEvent("player:serviceOn", "coffee")
  else
		Config_esx_coffee.Zones.Vehicles.Type = -1
		Config_esx_coffee.Zones.VehicleDeleters.Type = -1
		Config_esx_coffee.Zones.coffeeActionsBoss.Type = -1
		Config_esx_coffee.Zones.coffeeStockBoss.Type = -1
		Config_esx_coffee.Zones.coffeeCocktail.Type = -1
		Config_esx_coffee.Zones.Cloakrooms.Type = -1
		
		Config_esx_coffee.Zones.coffeeVehEnterZ.Type = -1
		Config_esx_coffee.Zones.coffeeVehEnter2Z.Type = -1
	end

end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job)
  while (PlayerData.job or PlayerData.job2) == nil do
    Citizen.Wait(10)
  end
  if PlayerData.job2.name == "coffee" then
    coffee_shopBlip()
  end
  if PlayerData.job2.name == 'coffee' and PlayerData.job2.service == 1 then
		Config_esx_coffee.Zones.Vehicles.Type = 1
		Config_esx_coffee.Zones.VehicleDeleters.Type = 1
		Config_esx_coffee.Zones.coffeeActionsBoss.Type = 1
		Config_esx_coffee.Zones.coffeeStockBoss.Type = 1
		Config_esx_coffee.Zones.coffeeCocktail.Type = 1
		Config_esx_coffee.Zones.Cloakrooms.Type = 1
		
		Config_esx_coffee.Zones.coffeeVehEnterZ.Type = 1
		Config_esx_coffee.Zones.coffeeVehEnter2Z.Type = 1
	TriggerServerEvent("player:serviceOn", "coffee")
  else
		Config_esx_coffee.Zones.Vehicles.Type = -1
		Config_esx_coffee.Zones.VehicleDeleters.Type = -1
		Config_esx_coffee.Zones.coffeeActionsBoss.Type = -1
		Config_esx_coffee.Zones.coffeeStockBoss.Type = -1
		Config_esx_coffee.Zones.coffeeCocktail.Type = -1
		Config_esx_coffee.Zones.Cloakrooms.Type = -1
		
		Config_esx_coffee.Zones.coffeeVehEnterZ.Type = -1
		Config_esx_coffee.Zones.coffeeVehEnter2Z.Type = -1
	end

end)

RegisterNetEvent('esx:setService')
AddEventHandler('esx:setService', function(job, service)
  while (PlayerData.job or PlayerData.job2) == nil do
    Citizen.Wait(10)
  end
  if (PlayerData.job.name == 'coffee'  and PlayerData.job.service == 1) or (PlayerData.job2.name == 'coffee'  and PlayerData.job2.service == 1) then
		Config_esx_coffee.Zones.Vehicles.Type = 1
		Config_esx_coffee.Zones.VehicleDeleters.Type = 1
		Config_esx_coffee.Zones.coffeeActionsBoss.Type = 1
		Config_esx_coffee.Zones.coffeeStockBoss.Type = 1
		Config_esx_coffee.Zones.coffeeCocktail.Type = 1
		Config_esx_coffee.Zones.Cloakrooms.Type = 1
		
		Config_esx_coffee.Zones.coffeeVehEnterZ.Type = 1
		Config_esx_coffee.Zones.coffeeVehEnter2Z.Type = 1
	else
		Config_esx_coffee.Zones.Vehicles.Type = -1
		Config_esx_coffee.Zones.VehicleDeleters.Type = -1
		Config_esx_coffee.Zones.coffeeActionsBoss.Type = -1
		Config_esx_coffee.Zones.coffeeStockBoss.Type = -1
		Config_esx_coffee.Zones.coffeeCocktail.Type = -1 
		Config_esx_coffee.Zones.Cloakrooms.Type = -1
		
		Config_esx_coffee.Zones.coffeeVehEnterZ.Type = -1
		Config_esx_coffee.Zones.coffeeVehEnter2Z.Type = -1
  end
end)

AddEventHandler('esx_coffee:hasEnteredMarker', function(zone)

  if (PlayerData.job ~= nil and PlayerData.job.name == 'coffee' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'coffee' and PlayerData.job2.service == 1) then
  
		if zone == 'coffeeActionsBoss' and (PlayerData.job.name == 'coffee' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) then
			CurrentAction     = 'coffee_actions_menu'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
		end
		
		if zone == 'coffeeStockBoss' then
			CurrentAction     = 'coffee_stock_menu'
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
		
		if zone == 'coffeeCocktail' then
			CurrentAction     = 'menu_drink'
		end
	
	end

end)

AddEventHandler('esx_coffee:hasExitedMarker', function(zone)
	if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
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
function coffee03()
		if (PlayerData.job ~= nil and PlayerData.job.name == 'coffee' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'coffee' and PlayerData.job2.service == 1) then
			
			
			if GetDistanceBetweenCoords(coords, Config_esx_coffee.Zones.Cloakrooms.Pos.x, Config_esx_coffee.Zones.Cloakrooms.Pos.y, Config_esx_coffee.Zones.Cloakrooms.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_coffee.Zones.Cloakrooms.Pos.x, Config_esx_coffee.Zones.Cloakrooms.Pos.y, Config_esx_coffee.Zones.Cloakrooms.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour vous changer')
			end
			if GetDistanceBetweenCoords(coords, Config_esx_coffee.Zones.coffeeStockBoss.Pos.x, Config_esx_coffee.Zones.coffeeStockBoss.Pos.y, Config_esx_coffee.Zones.coffeeStockBoss.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_coffee.Zones.coffeeStockBoss.Pos.x, Config_esx_coffee.Zones.coffeeStockBoss.Pos.y, Config_esx_coffee.Zones.coffeeStockBoss.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au stockage')
			end
			if GetDistanceBetweenCoords(coords, Config_esx_coffee.Zones.coffeeCocktail.Pos.x, Config_esx_coffee.Zones.coffeeCocktail.Pos.y, Config_esx_coffee.Zones.coffeeCocktail.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_coffee.Zones.coffeeCocktail.Pos.x, Config_esx_coffee.Zones.coffeeCocktail.Pos.y, Config_esx_coffee.Zones.coffeeCocktail.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour préparer une boisson')
			end
			
			if (PlayerData.job ~= nil and PlayerData.job.name == 'coffee' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'coffee' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then
				if GetDistanceBetweenCoords(coords, Config_esx_coffee.Zones.coffeeActionsBoss.Pos.x, Config_esx_coffee.Zones.coffeeActionsBoss.Pos.y, Config_esx_coffee.Zones.coffeeActionsBoss.Pos.z,  true) < 2.0 then
          sleepThread = 20
          DrawText3Ds(Config_esx_coffee.Zones.coffeeActionsBoss.Pos.x, Config_esx_coffee.Zones.coffeeActionsBoss.Pos.y, Config_esx_coffee.Zones.coffeeActionsBoss.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au boss menu')
				end
			end
		end
end

-- Create blips
Citizen.CreateThread(function()

 local blip = AddBlipForCoord(Config_esx_coffee.Zones.coffee.Pos.x, Config_esx_coffee.Zones.coffee.Pos.y, Config_esx_coffee.Zones.coffee.Pos.z)
  
  SetBlipSprite (blip, 214)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.6)
  SetBlipColour (blip, 31)
  SetBlipAsShortRange(blip, true)
  
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Bean Machine")
  EndTextCommandSetBlipName(blip)

end)

-- Display markers
function coffee01()
    for k,v in pairs(Config_esx_coffee.Zones) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_esx_coffee.DrawDistance) then
        DrawMarker(0, v.Pos.x, v.Pos.y, v.Pos.z+0.25, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.2, 0.2, 0.2, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
      end
    end
end

-- Enter / Exit marker events
function coffee02()
    local coords          = coords
    local isInMarker      = false
    local currentZone     = nil

    for k,v in pairs(Config_esx_coffee.Zones) do
      if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
        isInMarker      = true
        currentZone     = k
      end
    end

    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
      HasAlreadyEnteredMarker = true
      LastZone                = currentZone
      TriggerEvent('esx_coffee:hasEnteredMarker', currentZone)
    end

    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_coffee:hasExitedMarker', LastZone)
    end

end

-- Key Controls
function coffee04()
    if CurrentAction ~= nil then

      if IsControlJustReleased(0, Keys['BACKSPACE']) then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	  end
	  
	  if (PlayerData.job ~= nil and PlayerData.job.name == 'coffee' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'coffee' and PlayerData.job2.service == 1) then

		  if IsControlJustReleased(0, Keys['E']) then

			if CurrentAction == 'coffee_actions_menu'  then  
			  TriggerEvent('esx_society:openBossMenu', 'coffee', function(data, menu)
				menu.close()
			  end)
			end
					
			if CurrentAction == 'coffee_stock_menu' then
			  coffee_OpenFridgeMenu()
			end

			if CurrentAction == 'coffee_cocktail_menu' then  
			  coffee_OpencoffeeCocktailMenu()
			end
			
			if CurrentAction == 'menu_cloakroom' then  
			  coffee_OpenCloakroomMenu()
			end

			if CurrentAction == 'menu_drink' then  
        TriggerEvent('Nebula_restaurants:OpenMenu', "coffee", false)
			end
			
			--if CurrentAction == 'delete_vehicle' then
			  --ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
			--end
			
			--if CurrentAction == 'menu_vehicle_spawner' then
				--coffee_OpenVehicleSpawnerMenu()
			--end
			
			CurrentAction = nil
		  end
	  
	  end

    end
end

-- Blip map shop
function coffee_shopBlip()
  sBlip = AddBlipForCoord(29.13, -1770.21, 29.60)
  
  SetBlipSprite (sBlip, 537)
  SetBlipDisplay(sBlip, 4)
  SetBlipScale  (sBlip, 0.6)
  SetBlipColour (sBlip, 61)
  SetBlipAsShortRange(sBlip, true)
  
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Bean Machine - Shop")
  EndTextCommandSetBlipName(sBlip)
end

xSound = exports.xsound
RegisterNetEvent("esx_coffee:playmusic")
AddEventHandler("esx_coffee:playmusic", function(data)
    local pos = vec3(-631.96, 232.75, 81.88)
    if xSound:soundExists("coffee") then
      xSound:Destroy("coffee")
    end
    xSound:PlayUrlPos("coffee", data, 0.1, pos)
    xSound:Distance("coffee", 25)
    xSound:Position("coffee", pos)
end)

RegisterNetEvent("esx_coffee:pausecoffee")
AddEventHandler("esx_coffee:pausecoffee", function(status)
	if status == "play" then
    xSound:Resume("coffee")
	elseif status == "pause" then
    xSound:Pause("coffee")
	end
end)

RegisterNetEvent("esx_coffee:volumecoffee")
AddEventHandler("esx_coffee:volumecoffee", function(volume)
	print(volume/100)
    xSound:setVolume("coffee", volume / 100)
end)

RegisterNetEvent("esx_coffee:stopcoffee")
AddEventHandler("esx_coffee:stopcoffee", function()
    xSound:Destroy("coffee")
end)