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

function arcade_OpenRoomMenu()

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

function arcade_OpenCloakroomMenu()

  local elements = {
		{label = "Dressing", value = 'dressing'},
      }

  ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cloakroom',
      {
        title    = 'Vestiaire',
        align = 'right',
        elements = elements,
      },
      function(data, menu)
        if data.current.value == 'dressing' then
          arcade_OpenRoomMenu()
        end
        if data.current.value == 'citizen_wear' then
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

function OpenMobilearcadeActionsMenu()
 	ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'boss_actions',
    {
      title    = 'Arcade Bar',
	  align = 'right',
      elements = {
      	{label = 'Facturation', value = 'billing'},
        {label = 'Donner un ticket Bronze', value = 'bronze'},
        {label = 'Donner un ticket Argent', value = 'argent'},
        {label = 'Donner un ticket Or', value = 'or'},
        {label = 'Se donner un ticket Or (à soi-même)', value = 'self_or'},
        {label = 'Retirer le ticket au client', value = 'stopticket'}
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
								TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_arcade', 'Arcadian Bar', amount)
                TriggerServerEvent('CoreLog:SendDiscordLog', "Arcadian Bar - Factures", "**" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$"..amount.."`", "Yellow")
							end

						end

					end,
					function(data, menu)
						menu.close()
					end
				)
      elseif data.current.value == 'bronze' or data.current.value == 'argent' or data.current.value == 'or' then
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        if closestPlayer ~= -1 and closestDistance <= 2.5 then
          TriggerServerEvent("rcore_arcade:giveTicket", data.current.value, GetPlayerServerId(closestPlayer))
          TriggerServerEvent('CoreLog:SendDiscordLog', "Arcadian Bar - Tickets", "**" .. GetPlayerName(PlayerId()) .. "** a donné 1 ticket `"..data.current.value.."`", "Green")
        else
          TriggerEvent('Core:ShowNotification', 'Aucune ~y~personne~w~ à proximité.')
        end
      elseif data.current.value == "self_or" then
        TriggerEvent('rcore_arcade:ticketResult', 'or')
        TriggerServerEvent('CoreLog:SendDiscordLog', "Arcadian Bar - Tickets", "**" .. GetPlayerName(PlayerId()) .. "** s'est donné 1 ticket `or`", "Green")
      elseif data.current.value == "stopticket" then
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        if closestPlayer ~= -1 and closestDistance <= 2.5 then
          TriggerServerEvent('rcore_arcade:stopTicket', GetPlayerServerId(closestPlayer))
          TriggerServerEvent('CoreLog:SendDiscordLog', "Arcadian Bar - Tickets", "**" .. GetPlayerName(PlayerId()) .. "** a repris le ticket d'un client", "Red")
        else
          TriggerEvent('Core:ShowNotification', 'Aucune ~y~personne~w~ à proximité.')
        end
			end
    end,
    function(data, menu)
    	menu.close()
    end
  )

end

RegisterNetEvent('esx_arcade:openMenuJob')
AddEventHandler('esx_arcade:openMenuJob', function()
	OpenMobilearcadeActionsMenu()
end)

function arcade_OpenGetFridgeStocksMenu()

  ESX.TriggerServerCallback('esx_arcade:getFridgeStockItems', function(items)

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
              arcade_OpenGetFridgeStocksMenu()
              TriggerServerEvent('esx_arcade:getFridgeStockItem', itemName, count)
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

function arcade_OpenPutFridgeStocksMenu()
ESX.TriggerServerCallback('esx_arcade:getPlayerInventory', function(inventory)
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
              arcade_OpenPutFridgeStocksMenu()
              TriggerServerEvent('esx_arcade:putFridgeStockItems', itemName, count)
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

function arcade_OpenFridgeMenu()

    local elements = {
      {label = 'Ouvrir le stockage', value = 'get_stock'},
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
          TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_arcade')
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
  if (PlayerData.job.name == 'arcade'  and PlayerData.job.service == 1) or (PlayerData.job2.name == 'arcade'  and PlayerData.job2.service == 1) then
		Config_esx_arcade.Zones.arcadeActionsBoss.Type = 1
		Config_esx_arcade.Zones.arcadeStockBoss.Type = 1
    Config_esx_arcade.Zones.arcadeBar.Type = 1
    Config_esx_arcade.Zones.arcadeKitchen.Type = 1
		Config_esx_arcade.Zones.Cloakrooms.Type = 1
  else
		Config_esx_arcade.Zones.arcadeActionsBoss.Type = -1
		Config_esx_arcade.Zones.arcadeStockBoss.Type = -1
    Config_esx_arcade.Zones.arcadeBar.Type = -1
    Config_esx_arcade.Zones.arcadeKitchen.Type = -1
		Config_esx_arcade.Zones.Cloakrooms.Type = -1
  end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  while (PlayerData.job or PlayerData.job2) == nil do
    Citizen.Wait(10)
  end
  if PlayerData.job.name == 'arcade' and PlayerData.job.service == 1 then
		Config_esx_arcade.Zones.arcadeActionsBoss.Type = 1
		Config_esx_arcade.Zones.arcadeStockBoss.Type = 1
    Config_esx_arcade.Zones.arcadeBar.Type = 1
    Config_esx_arcade.Zones.arcadeKitchen.Type = 1
		Config_esx_arcade.Zones.Cloakrooms.Type = 1
  else
		Config_esx_arcade.Zones.arcadeActionsBoss.Type = -1
		Config_esx_arcade.Zones.arcadeStockBoss.Type = -1
    Config_esx_arcade.Zones.arcadeBar.Type = -1
    Config_esx_arcade.Zones.arcadeKitchen.Type = -1
		Config_esx_arcade.Zones.Cloakrooms.Type = -1
	end
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job)
  while (PlayerData.job or PlayerData.job2) == nil do
    Citizen.Wait(10)
  end
  if PlayerData.job2.name == 'arcade' and PlayerData.job2.service == 1 then
		Config_esx_arcade.Zones.arcadeActionsBoss.Type = 1
		Config_esx_arcade.Zones.arcadeStockBoss.Type = 1
    Config_esx_arcade.Zones.arcadeBar.Type = 1
    Config_esx_arcade.Zones.arcadeKitchen.Type = 1
		Config_esx_arcade.Zones.Cloakrooms.Type = 1
  else
		Config_esx_arcade.Zones.arcadeActionsBoss.Type = -1
		Config_esx_arcade.Zones.arcadeStockBoss.Type = -1
    Config_esx_arcade.Zones.arcadeBar.Type = -1
    Config_esx_arcade.Zones.arcadeKitchen.Type = -1
		Config_esx_arcade.Zones.Cloakrooms.Type = -1
	end
end)

RegisterNetEvent('esx:setService')
AddEventHandler('esx:setService', function(job, service)
  while (PlayerData.job or PlayerData.job2) == nil do
    Citizen.Wait(10)
  end
  if (PlayerData.job.name == 'arcade'  and PlayerData.job.service == 1) or (PlayerData.job2.name == 'arcade'  and PlayerData.job2.service == 1) then
		Config_esx_arcade.Zones.arcadeActionsBoss.Type = 1
		Config_esx_arcade.Zones.arcadeStockBoss.Type = 1
    Config_esx_arcade.Zones.arcadeBar.Type = 1
    Config_esx_arcade.Zones.arcadeKitchen.Type = 1
		Config_esx_arcade.Zones.Cloakrooms.Type = 1
  else
		Config_esx_arcade.Zones.arcadeActionsBoss.Type = -1
		Config_esx_arcade.Zones.arcadeStockBoss.Type = -1
    Config_esx_arcade.Zones.arcadeBar.Type = -1
    Config_esx_arcade.Zones.arcadeKitchen.Type = -1
		Config_esx_arcade.Zones.Cloakrooms.Type = -1
  end
end)

AddEventHandler('esx_arcade:hasEnteredMarker', function(zone)

  if (PlayerData.job ~= nil and PlayerData.job.name == 'arcade' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'arcade' and PlayerData.job2.service == 1) then
  
		if zone == 'arcadeActionsBoss' and (PlayerData.job.name == 'arcade' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) then
			CurrentAction     = 'arcade_actions_menu'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
		end
		
		if zone == 'arcadeStockBoss' then
			CurrentAction     = 'arcade_stock_menu'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au frigo'
			CurrentActionData = {}
		end

		if zone == 'arcadeBar' then
			CurrentAction     = 'arcade_bar'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour préparer une boisson'
			CurrentActionData = {}
		end

    if zone == 'arcadeKitchen' then
			CurrentAction     = 'arcade_kitchen'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour préparer à manger'
			CurrentActionData = {}
		end

		if zone == 'Cloakrooms' then
			CurrentAction     = 'menu_cloakroom'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
		end
	end
end)

AddEventHandler('esx_arcade:hasExitedMarker', function(zone)
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

function arcade03()
		if (PlayerData.job ~= nil and PlayerData.job.name == 'arcade' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'arcade' and PlayerData.job2.service == 1) then
			if GetDistanceBetweenCoords(coords, Config_esx_arcade.Zones.Cloakrooms.Pos.x, Config_esx_arcade.Zones.Cloakrooms.Pos.y, Config_esx_arcade.Zones.Cloakrooms.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_arcade.Zones.Cloakrooms.Pos.x, Config_esx_arcade.Zones.Cloakrooms.Pos.y, Config_esx_arcade.Zones.Cloakrooms.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour vous changer')
			end
			if GetDistanceBetweenCoords(coords, Config_esx_arcade.Zones.arcadeStockBoss.Pos.x, Config_esx_arcade.Zones.arcadeStockBoss.Pos.y, Config_esx_arcade.Zones.arcadeStockBoss.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_arcade.Zones.arcadeStockBoss.Pos.x, Config_esx_arcade.Zones.arcadeStockBoss.Pos.y, Config_esx_arcade.Zones.arcadeStockBoss.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au frigo')
			end
      if GetDistanceBetweenCoords(coords, Config_esx_arcade.Zones.arcadeBar.Pos.x, Config_esx_arcade.Zones.arcadeBar.Pos.y, Config_esx_arcade.Zones.arcadeBar.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_arcade.Zones.arcadeBar.Pos.x, Config_esx_arcade.Zones.arcadeBar.Pos.y, Config_esx_arcade.Zones.arcadeBar.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour préparer une boisson')
			end
      if GetDistanceBetweenCoords(coords, Config_esx_arcade.Zones.arcadeKitchen.Pos.x, Config_esx_arcade.Zones.arcadeKitchen.Pos.y, Config_esx_arcade.Zones.arcadeKitchen.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_arcade.Zones.arcadeKitchen.Pos.x, Config_esx_arcade.Zones.arcadeKitchen.Pos.y, Config_esx_arcade.Zones.arcadeKitchen.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour préparer à manger')
			end
			if (PlayerData.job ~= nil and PlayerData.job.name == 'arcade' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'arcade' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then
				if GetDistanceBetweenCoords(coords, Config_esx_arcade.Zones.arcadeActionsBoss.Pos.x, Config_esx_arcade.Zones.arcadeActionsBoss.Pos.y, Config_esx_arcade.Zones.arcadeActionsBoss.Pos.z,  true) < 2.0 then
          sleepThread = 20
          DrawText3Ds(Config_esx_arcade.Zones.arcadeActionsBoss.Pos.x, Config_esx_arcade.Zones.arcadeActionsBoss.Pos.y, Config_esx_arcade.Zones.arcadeActionsBoss.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au boss menu')
				end
			end
		end
end

-- Create blips
Citizen.CreateThread(function()

 local blip = AddBlipForCoord(Config_esx_arcade.Zones.arcade.Pos.x, Config_esx_arcade.Zones.arcade.Pos.y, Config_esx_arcade.Zones.arcade.Pos.z)
  
  SetBlipSprite (blip, 647)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.6)
  SetBlipColour (blip, 48)
  SetBlipAsShortRange(blip, true)
  
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Arcadian Bar")
  EndTextCommandSetBlipName(blip)

end)

-- Display markers
function arcade01()
    for k,v in pairs(Config_esx_arcade.Zones) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_esx_arcade.DrawDistance) then
        DrawMarker(0, v.Pos.x, v.Pos.y, v.Pos.z+0.25, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.2, 0.2, 0.2, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
      end
    end
end

-- Enter / Exit marker events
function arcade02()
    local coords          = coords
    local isInMarker      = false
    local currentZone     = nil

    for k,v in pairs(Config_esx_arcade.Zones) do
      if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
        isInMarker      = true
        currentZone     = k
      end
    end

    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
      HasAlreadyEnteredMarker = true
      LastZone                = currentZone
      TriggerEvent('esx_arcade:hasEnteredMarker', currentZone)
    end

    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_arcade:hasExitedMarker', LastZone)
    end

end

-- Key Controls
function arcade04()
    if CurrentAction ~= nil then
      if IsControlJustReleased(0, Keys['BACKSPACE']) then
        ESX.UI.Menu.CloseAll()
        CurrentAction = nil
      end
      
      if (PlayerData.job ~= nil and PlayerData.job.name == 'arcade' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'arcade' and PlayerData.job2.service == 1) then

        if IsControlJustReleased(0, Keys['E']) then
          if CurrentAction == 'arcade_actions_menu'  then  
            TriggerEvent('esx_society:openBossMenu', 'arcade', function(data, menu)
            menu.close()
            end)
          end

          if CurrentAction == 'arcade_stock_menu' then
            arcade_OpenFridgeMenu()
          end

          if CurrentAction == 'arcade_bar' then
            ESX.UI.Menu.CloseAll()
            TriggerEvent('Nebula_restaurants:OpenMenu', "arcade", true)
          end

          if CurrentAction == 'arcade_kitchen' then
            ESX.UI.Menu.CloseAll()
            TriggerEvent('Nebula_restaurants:OpenMenu', "arcade", false)
          end

          if CurrentAction == 'menu_cloakroom' then  
            arcade_OpenCloakroomMenu()
          end
          CurrentAction = nil
        end
      end
    end
end

local ArcadeSound = exports.xsound
RegisterNetEvent("esx_arcade:playmusic")
AddEventHandler("esx_arcade:playmusic", function(data)
    local pos = vec3(742.49, -820.52, 24.87)
    if ArcadeSound:soundExists("arcade") then
      ArcadeSound:Destroy("arcade")
    end
    ArcadeSound:PlayUrlPos("arcade", data, 0.1, pos)
    ArcadeSound:Distance("arcade", 25)
    ArcadeSound:Position("arcade", pos)
end)

RegisterNetEvent("esx_arcade:pausearcade")
AddEventHandler("esx_arcade:pausearcade", function(status)
	if status == "play" then
    ArcadeSound:Resume("arcade")
	elseif status == "pause" then
    ArcadeSound:Pause("arcade")
	end
end)

RegisterNetEvent("esx_arcade:volumearcade")
AddEventHandler("esx_arcade:volumearcade", function(volume)
	print(volume/100)
  ArcadeSound:setVolume("arcade", volume / 100)
end)

RegisterNetEvent("esx_arcade:stoparcade")
AddEventHandler("esx_arcade:stoparcade", function()
  ArcadeSound:Destroy("arcade")
end)