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

function weed_SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 0,
    modBrakes       = 0,
    modTransmission = 0,
    modSuspension   = 0,
    modTurbo        = false,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function weed_SetWindowTint(vehicle)

  local props = {
    windowTint       = 1,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end


function weed_OpenRoomMenu()

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

function weed_OpenCloakroomMenu()

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
			weed_OpenRoomMenu()
		end

        if data.current.value == 'citizen_wear' then
		  TriggerServerEvent("player:serviceOff", "weed")
		
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

function weed_OpenweedShopMenu()

    local elements = {}
    for i=1, #Config_esx_weed.Shops.Items, 1 do

        local item = Config_esx_weed.Shops.Items[i]

        table.insert(elements, {
            label     = item.label,
            realLabel = item.label,
            value     = item.name,
            price     = item.price
        })

    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'weed_shop_menu',
        {
            title    = 'Shop',
			align = 'right',
            elements = elements
        },
        function(data, menu)
            TriggerServerEvent('esx_weed:buyItem', data.current.value, data.current.price, data.current.realLabel)
        end,
        function(data, menu)
            menu.close()
        end
    )

end

function OpenMobileweedActionsMenu()

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
								ESX.ShowNotification('Aucun joueur à proximité')
							else
								TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_weed', 'WhiteWidow', amount)
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

RegisterNetEvent('esx_weed:openMenuJob')
AddEventHandler('esx_weed:openMenuJob', function()
	OpenMobileweedActionsMenu()
end)

function weed_OpenGetFridgeStocksMenu()

  ESX.TriggerServerCallback('esx_weed:getFridgeStockItems', function(items)

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
              weed_OpenGetFridgeStocksMenu()
			  --TriggerServerEvent('weedsbot:GetFridgeStocks', itemName, count)
              TriggerServerEvent('esx_weed:getFridgeStockItem', itemName, count)
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

function weed_OpenPutFridgeStocksMenu()

ESX.TriggerServerCallback('esx_weed:getPlayerInventory', function(inventory)

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
              weed_OpenPutFridgeStocksMenu()
			  --TriggerServerEvent('weedsbot:PutFridgeStocks', itemName, count)
              TriggerServerEvent('esx_weed:putFridgeStockItems', itemName, count)
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

function weed_OpenFridgeMenu()

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
          TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_weed')
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

  if (PlayerData.job.name == 'weed'  and PlayerData.job.service == 1) or (PlayerData.job2.name == 'weed'  and PlayerData.job2.service == 1) then
		Config_esx_weed.Zones.weedActionsBoss.Type = 1
		Config_esx_weed.Zones.weedStock.Type = 1
		Config_esx_weed.Zones.weedShop.Type = 1
		Config_esx_weed.Zones.Cloakrooms.Type = 1

		
	TriggerServerEvent("player:serviceOn", "weed")
	weed_shopBlip()
  else
		Config_esx_weed.Zones.weedActionsBoss.Type = -1
		Config_esx_weed.Zones.weedStock.Type = -1
		Config_esx_weed.Zones.weedShop.Type = -1 
		Config_esx_weed.Zones.Cloakrooms.Type = -1

		RemoveBlip(sBlip)
  end

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)

  while (PlayerData.job or PlayerData.job2) == nil do

    Citizen.Wait(10)
  end

  if PlayerData.job.name == 'weed' and PlayerData.job.service == 1 then
		Config_esx_weed.Zones.weedActionsBoss.Type = 1
		Config_esx_weed.Zones.weedStock.Type = 1
		Config_esx_weed.Zones.weedShop.Type = 1
		Config_esx_weed.Zones.Cloakrooms.Type = 1
	TriggerServerEvent("player:serviceOn", "weed")
	weed_shopBlip()
  else
		Config_esx_weed.Zones.weedActionsBoss.Type = -1
		Config_esx_weed.Zones.weedStock.Type = -1
		Config_esx_weed.Zones.weedShop.Type = -1
		Config_esx_weed.Zones.Cloakrooms.Type = -1
		RemoveBlip(sBlip)
	end

end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job)

  while (PlayerData.job or PlayerData.job2) == nil do

    Citizen.Wait(10)
  end

  if PlayerData.job2.name == 'weed' and PlayerData.job2.service == 1 then
		Config_esx_weed.Zones.weedActionsBoss.Type = 1
		Config_esx_weed.Zones.weedStock.Type = 1
		Config_esx_weed.Zones.weedShop.Type = 1
		Config_esx_weed.Zones.Cloakrooms.Type = 1
	TriggerServerEvent("player:serviceOn", "weed")
	weed_shopBlip()
  else
		Config_esx_weed.Zones.weedActionsBoss.Type = -1
		Config_esx_weed.Zones.weedStock.Type = -1
		Config_esx_weed.Zones.weedShop.Type = -1
		Config_esx_weed.Zones.Cloakrooms.Type = -1
		RemoveBlip(sBlip)
	end

end)

RegisterNetEvent('esx:setService')
AddEventHandler('esx:setService', function(job, service)
  while (PlayerData.job or PlayerData.job2) == nil do

    Citizen.Wait(10)
  end
  if (PlayerData.job.name == 'weed'  and PlayerData.job.service == 1) or (PlayerData.job2.name == 'weed'  and PlayerData.job2.service == 1) then
		Config_esx_weed.Zones.weedActionsBoss.Type = 1
		Config_esx_weed.Zones.weedStock.Type = 1
		Config_esx_weed.Zones.weedShop.Type = 1
		Config_esx_weed.Zones.Cloakrooms.Type = 1
	TriggerServerEvent("player:serviceOn", "weed")
	weed_shopBlip()
  else
		Config_esx_weed.Zones.weedActionsBoss.Type = -1
		Config_esx_weed.Zones.weedStock.Type = -1
		Config_esx_weed.Zones.weedShop.Type = -1 
		Config_esx_weed.Zones.Cloakrooms.Type = -1
		RemoveBlip(sBlip)
  end
end)

AddEventHandler('esx_weed:hasEnteredMarker', function(zone)

  if (PlayerData.job ~= nil and PlayerData.job.name == 'weed' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'weed' and PlayerData.job2.service == 1) then
  
		if zone == 'weedActionsBoss' and (PlayerData.job.name == 'weed' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) then
			CurrentAction     = 'weed_actions_menu'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
		end
		
		if zone == 'weedStock' then
			CurrentAction     = 'weed_stock_menu'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
		end

		if zone == 'Cloakrooms' then
			CurrentAction     = 'menu_cloakroom'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
		end
		
		if zone == 'weedShop' then
			CurrentAction     = 'weed_shop_menu'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
		end
	
	end

end)

AddEventHandler('esx_weed:hasExitedMarker', function(zone)
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
function weed03()
		if (PlayerData.job ~= nil and PlayerData.job.name == 'weed' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'weed' and PlayerData.job2.service == 1) then
			
			
			if GetDistanceBetweenCoords(coords, Config_esx_weed.Zones.Cloakrooms.Pos.x, Config_esx_weed.Zones.Cloakrooms.Pos.y, Config_esx_weed.Zones.Cloakrooms.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_weed.Zones.Cloakrooms.Pos.x, Config_esx_weed.Zones.Cloakrooms.Pos.y, Config_esx_weed.Zones.Cloakrooms.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour vous changer')
			end
			if GetDistanceBetweenCoords(coords, Config_esx_weed.Zones.weedStock.Pos.x, Config_esx_weed.Zones.weedStock.Pos.y, Config_esx_weed.Zones.weedStock.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_weed.Zones.weedStock.Pos.x, Config_esx_weed.Zones.weedStock.Pos.y, Config_esx_weed.Zones.weedStock.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au stock')
			end
			if GetDistanceBetweenCoords(coords, Config_esx_weed.Zones.weedShop.Pos.x, Config_esx_weed.Zones.weedShop.Pos.y, Config_esx_weed.Zones.weedShop.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_weed.Zones.weedShop.Pos.x, Config_esx_weed.Zones.weedShop.Pos.y, Config_esx_weed.Zones.weedShop.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au magasin')
			end
			
			if (PlayerData.job ~= nil and PlayerData.job.name == 'weed' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'weed' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then
				if GetDistanceBetweenCoords(coords, Config_esx_weed.Zones.weedActionsBoss.Pos.x, Config_esx_weed.Zones.weedActionsBoss.Pos.y, Config_esx_weed.Zones.weedActionsBoss.Pos.z,  true) < 2.0 then
          sleepThread = 20
          DrawText3Ds(Config_esx_weed.Zones.weedActionsBoss.Pos.x, Config_esx_weed.Zones.weedActionsBoss.Pos.y, Config_esx_weed.Zones.weedActionsBoss.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au boss menu')
				end
			end
		end
end

-- Display markers
function weed01()
    
    
    for k,v in pairs(Config_esx_weed.Zones) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_esx_weed.DrawDistance) then
        DrawMarker(0, v.Pos.x, v.Pos.y, v.Pos.z+0.25, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.2, 0.2, 0.2, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
      end
    end
end

-- Enter / Exit marker events
function weed02()
    local coords          = coords
    local isInMarker      = false
    local currentZone     = nil

    for k,v in pairs(Config_esx_weed.Zones) do
      if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
        isInMarker      = true
        currentZone     = k
      end
    end

    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
      HasAlreadyEnteredMarker = true
      LastZone                = currentZone
      TriggerEvent('esx_weed:hasEnteredMarker', currentZone)
    end

    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_weed:hasExitedMarker', LastZone)
    end

end

-- Key Controls
function weed04()
    if CurrentAction ~= nil then

      if IsControlJustReleased(0, Keys['BACKSPACE']) then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	  end
	  
	  if (PlayerData.job ~= nil and PlayerData.job.name == 'weed' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'weed' and PlayerData.job2.service == 1) then

		  if IsControlJustReleased(0, Keys['E']) then

			if CurrentAction == 'weed_actions_menu'  then  
			  TriggerEvent('esx_society:openBossMenu', 'weed', function(data, menu)
				menu.close()
			  end)
			end
					
			if CurrentAction == 'weed_stock_menu' then
			  weed_OpenFridgeMenu()
			end

			if CurrentAction == 'weed_shop_menu' then  
			  weed_OpenweedShopMenu()
			end
			
			if CurrentAction == 'menu_cloakroom' then  
			  weed_OpenCloakroomMenu()
			end

			CurrentAction = nil
		  end
	  
	  end

    end
end

-- Create blips
Citizen.CreateThread(function()

 local blip = AddBlipForCoord(Config_esx_weed.Zones.weed.Pos.x, Config_esx_weed.Zones.weed.Pos.y, Config_esx_weed.Zones.weed.Pos.z)
  
  SetBlipSprite (blip, 496)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.6)
  SetBlipColour (blip, 2)
  SetBlipAsShortRange(blip, true)
  
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("White Widow - Chicha")
  EndTextCommandSetBlipName(blip)

end)

xSound = exports.xsound
RegisterNetEvent("esx_weed:playmusic")
AddEventHandler("esx_weed:playmusic", function(data)
    local pos = vec3(-226.58, -316.72, 29.88)
    if xSound:soundExists("weed") then
      xSound:Destroy("weed")
    end
    xSound:PlayUrlPos("weed", data, 0.1, pos)
    xSound:Distance("weed", 20)
    xSound:Position("weed", pos)
end)

RegisterNetEvent("esx_weed:pauseweed")
AddEventHandler("esx_weed:pauseweed", function(status)
	if status == "play" then
    xSound:Resume("weed")
	elseif status == "pause" then
    xSound:Pause("weed")
	end
end)

RegisterNetEvent("esx_weed:volumeweed")
AddEventHandler("esx_weed:volumeweed", function(volume)
	print(volume/100)
    xSound:setVolume("weed", volume / 100)
end)

RegisterNetEvent("esx_weed:stopweed")
AddEventHandler("esx_weed:stopweed", function()
    xSound:Destroy("weed")
end)