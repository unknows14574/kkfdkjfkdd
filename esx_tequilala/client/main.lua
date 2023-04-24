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

function Ftext_esx_tequilala(txt)
	return Config_esx_tequilala.Txt[txt]
end


local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Blips                   = {}

local isBarman                = false
local isInMarker              = false
local isInPublicMarker        = false
local hintIsShowed            = false
local hintToDisplay           = "no hint to display"
local Blipte = false
local pushE = false

function tequi_IsJobTrue()
    if PlayerData ~= nil then
        local IsJobTrue = false
        if (PlayerData.job ~= nil and PlayerData.job.name == 'tequi' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'tequi' and PlayerData.job2.service == 1) then
          IsJobTrue = true
            if Blipte == false then
              tequi_addBlip()
              Blipte = true
            end
        else
            if Blipte == true then
              tequi_DeleteBlip()
              Blipte = false
            end
        end
        return IsJobTrue
    end
end

function tequi_IsGradeBoss()
    if PlayerData ~= nil then
        local IsGradeBoss = false
        if (PlayerData.job.grade_name == 'boss' or PlayerData.job2.grade_name == 'boss') then
            IsGradeBoss = true
        end
        return IsGradeBoss
    end
end

function tequi_IsGradeBoss1()
    if PlayerData ~= nil then
        local IsGradeBoss = false
        if (PlayerData.job.grade_name == 'boss') or (PlayerData.job2.grade_name == 'boss') then
            IsGradeBoss = true
        end
        return IsGradeBoss
    end
end

function tequi_SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 0,
    modBrakes       = 0,
    modTransmission = 0,
    modSuspension   = 0,
    modTurbo        = false,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

local wBlip = nil
local sBlip = nil
local rBlip = nil
local tBlip = nil
local vBlip = nil

function tequi_DeleteBlip()
    RemoveBlip(sBlip)
end

function tequi_addBlip()
    tequi_shopBlip()
end

function tequi_shopBlip()

	-- sBlip = AddBlipForCoord(Config_esx_tequilala.Zones.Shops.Pos.x, Config_esx_tequilala.Zones.Shops.Pos.y, Config_esx_tequilala.Zones.Shops.Pos.z)

	-- SetBlipSprite (sBlip, Config_esx_tequilala.Zones.Shops.Sprite)
	-- SetBlipDisplay(sBlip, Config_esx_tequilala.Zones.Shops.Display)
	-- SetBlipScale  (sBlip, Config_esx_tequilala.Zones.Shops.Scale)
	-- SetBlipColour (sBlip, Config_esx_tequilala.Zones.Shops.Colour)
	-- SetBlipAsShortRange(sBlip, true)

	-- BeginTextCommandSetBlipName("STRING")
	-- AddTextComponentString("Boutique d'alcool")
  -- EndTextCommandSetBlipName(sBlip)
end

function tequi_OpenRoomMenu()

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

function tequi_OpenCloakroomMenu()

  local elements = {
    {label = Ftext_esx_tequilala('citizen_wear'), value = 'citizen_wear'},
    {label = "Dressing", value = 'dressing'},
    {label = Ftext_esx_tequilala('barman_outfit'), value = 'barman_outfit'},
    {label = Ftext_esx_tequilala('dancer_outfit_1'), value = 'dancer_outfit_1'},
      }

  ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cloakroom',
      {
        title    = Ftext_esx_tequilala('cloakroom'),
        align = 'right',
        elements = elements,
        },

        function(data, menu)

    if data.current.value == 'dressing' then
      tequi_shopBlip(true)
			tequi_OpenRoomMenu()
		end

        if data.current.value == 'citizen_wear' then
		
		  TriggerServerEvent("player:serviceOff", "tequi")
		
          tequi_DeleteBlip()

            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)

                TriggerEvent('skinchanger:loadSkin', skin)
                ClearPedBloodDamage(playerPed)
                ResetPedVisibleDamage(playerPed)
                ClearPedLastWeaponDamage(playerPed)

                ResetPedMovementClipset(playerPed, 0)

                isBarman = false
            end)
        end
        if data.current.value == 'barman_outfit' then

		  TriggerServerEvent("player:serviceOn", "tequi")

          tequi_shopBlip()

            TriggerEvent('skinchanger:getSkin', function(skin)
        
                if skin.sex == 0 then

                    local clothesSkin = {
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
						['torso_1'] = 40,   ['torso_2'] = 0,
						['decals_1'] = 0,   ['decals_2'] = 0,
						['arms'] = 40,
						['pants_1'] = 28,   ['pants_2'] = 2,
						['shoes_1'] = 38,   ['shoes_2'] = 4,
						['chain_1'] = 118,  ['chain_2'] = 0
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                else

                    local clothesSkin = {
                        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
						['torso_1'] = 8,    ['torso_2'] = 2,
						['decals_1'] = 0,   ['decals_2'] = 0,
						['arms'] = 5,
						['pants_1'] = 44,   ['pants_2'] = 4,
						['shoes_1'] = 0,    ['shoes_2'] = 0,
						['chain_1'] = 0,    ['chain_2'] = 2
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
        if data.current.value == 'dancer_outfit_1' then

			TriggerServerEvent("player:serviceOn", "tequi")
			tequi_shopBlip(true)

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

                isBarman = false

            end)
        end

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = Ftext_esx_tequilala('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = Ftext_esx_tequilala('open_cloackroom')
      CurrentActionData = {}
    end
    )

end

function tequi_OpenVaultMenu()

  if Config_esx_tequilala.EnableVaultManagement or tequi_IsGradeBoss() then

    local elements = {
      {label = 'Ouvrir l\'armurerie', value = 'get_weapon'},
			{label = 'Ouvrir le stockage', value = 'get_stock'}
    }

    table.insert(elements, {label = "Retirer Arme", value = "get_weapon"})
    table.insert(elements, {label = "Déposer Arme", value = "put_weapon"})

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault',
      {
        title    = Ftext_esx_tequilala('vault'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'get_weapon' then
          TriggerEvent('core_inventory:client:openSocietyWeaponsInventory', 'society_tequi')
          menu.close()
        end
        if data.current.value == 'get_stock' then
          TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_tequi')
          menu.close()
        end


      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = Ftext_esx_tequilala('open_vault')
        CurrentActionData = {}
      end
    )

  end

end

function tequi_OpenFridgeMenu()

    local elements = {
      {label = Ftext_esx_tequilala('get_object'), value = 'get_stock'},
      {label = Ftext_esx_tequilala('put_object'), value = 'put_stock'}
    }
    

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fridge',
      {
        title    = Ftext_esx_tequilala('fridge'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'put_stock' then
           tequi_OpenPutFridgeStocksMenu()
        end

        if data.current.value == 'get_stock' then
           tequi_OpenGetFridgeStocksMenu()
        end

      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_fridge'
        CurrentActionMsg  = Ftext_esx_tequilala('open_fridge')
        CurrentActionData = {}
      end
    )

end

local locked = true

function tequi_OpenSocietyActionsMenu()

  local elements = {}

  table.insert(elements, {label = Ftext_esx_tequilala('billing'),    value = 'billing'})

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'event_actions',
    {
      title    = Ftext_esx_tequilala('event'),
      align = 'right',
      elements = elements
    },
    function(data, menu)

      if data.current.value == 'lock_door' then
			
        if GetDistanceBetweenCoords(coords, 161.64, -1306.95, 29.35, true) then
          locked = not locked
          if locked then
            TriggerServerEvent('esx_tequi:SetDoor', 0)
            TriggerEvent('chatMessage', "Labo: ^2Ouvert")
          else
            TriggerServerEvent('esx_tequi:SetDoor', 1)
            TriggerEvent('chatMessage', "Labo: ^1Fermer")
          end
        else
          ESX.ShowNotification('Vous devez etre a coter la porte de votre Labo !')
        end
      end

      if data.current.value == 'billing' then
        tequi_OpenBillingMenu()
      end
     
    end,
    function(data, menu)

      menu.close()

    end
  )

end

function tequi_OpenBillingMenu()

  ESX.UI.Menu.Open(
    'dialog', GetCurrentResourceName(), 'billing',
    {
      title = Ftext_esx_tequilala('billing_amount')
    },
    function(data, menu)
    
      local amount = tonumber(data.value)
      local player, distance = ESX.Game.GetClosestPlayer()

      if player ~= -1 and distance <= 3.0 then

        menu.close()
        if amount == nil then
            ESX.ShowNotification(Ftext_esx_tequilala('amount_invalid'))
        else
            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_tequi', Ftext_esx_tequilala('billing'), amount)
            TriggerServerEvent('CoreLog:SendDiscordLog', "Tequi-La-La - Factures", "**" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(player).."** d'un montant de `$"..amount.."`", "Yellow")
        end

      else
        ESX.ShowNotification(Ftext_esx_tequilala('no_players_nearby'))
      end

    end,
    function(data, menu)
        menu.close()
    end
  )
end

function tequi_OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_tequi:getStockItems', function(items)

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
        table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name, realLabel = items[i].label})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = Ftext_esx_tequilala('event_stock'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value
        local itemLabel = data.current.realLabel

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = Ftext_esx_tequilala('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_tequilala('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              tequi_OpenGetStocksMenu()
              TriggerServerEvent('esx_tequi:getStockItem', itemName, count, itemLabel)
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

function tequi_OpenPutStocksMenu()

ESX.TriggerServerCallback('esx_tequi:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name, realLabel = item.label})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = Ftext_esx_tequilala('inventory'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value
        local itemLabel = data.current.realLabel

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = Ftext_esx_tequilala('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_tequilala('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              tequi_OpenPutStocksMenu()
              TriggerServerEvent('esx_tequi:putStockItems', itemName, count, itemLabel)
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

function tequi_OpenGetFridgeStocksMenu()

  ESX.TriggerServerCallback('esx_tequi:getFridgeStockItem', function(items)
    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name, realLabel = items[i].label})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fridge_menu',
      {
        title    = Ftext_esx_tequilala('event_fridge_stock'),
		    align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value
        local itemLabel = data.current.realLabel

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'fridge_menu_get_item_count',
          {
            title = Ftext_esx_tequilala('quantity')
          },
          function(data2, menu2)
            if data2 ~= nil and data2.value ~= nil then
              local count = tonumber(data2.value)

              if count == nil then
                ESX.ShowNotification(Ftext_esx_tequilala('invalid_quantity'))
              else
                menu2.close()
                menu.close()
                tequi_OpenGetFridgeStocksMenu()
                TriggerServerEvent('esx_tequi:getFridgeStockItem', itemName, count, itemLabel)
              end
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

function tequi_OpenPutFridgeStocksMenu()

ESX.TriggerServerCallback('esx_tequi:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name, realLabel = item.label})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fridge_menu',
      {
        title    = Ftext_esx_tequilala('fridge_inventory'),
		    align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value
        local itemLabel = data.current.realLabel

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'fridge_menu_put_item_count',
          {
            title = Ftext_esx_tequilala('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_tequilala('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              tequi_OpenPutFridgeStocksMenu()
              TriggerServerEvent('esx_tequi:putFridgeStockItems', itemName, count, itemLabel)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end)

      end,
      function(data, menu)
        menu.close()
      end)
  end)
end

function tequi_OpenShopMenu(zone)

    local elements = {}
    for i=1, #Config_esx_tequilala.Zones[zone].Items, 1 do

        local item = Config_esx_tequilala.Zones[zone].Items[i]

        table.insert(elements, {
            label     = item.label .. ' - <span style="color:red;">' .. "x1" .. ' </span>',
            realLabel = item.label,
            value     = item.name,
            price     = item.price
        })

    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'event_shop',
        {
            title    = Ftext_esx_tequilala('shop'),
			align = 'right',
            elements = elements
        },
        function(data, menu)
            TriggerServerEvent('esx_tequi:buyItem', data.current.value, data.current.price, data.current.realLabel)
        end,
        function(data, menu)
            menu.close()
        end
    )

end

function tequi_OpenPutWeaponMenu()

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
			tequi_OpenVaultMenu()
			while isAdded == nil do
				Citizen.Wait(10)
			end
			if isAdded then        
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
		end, data.current.value, "tequi", ESX.GetWeaponLabel(data.current.value))  
	  end,
	  function(data, menu)
		menu.close()
	  end)
end

function tequi_OpenGetWeaponMenu()

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
        tequi_OpenVaultMenu()
      end, data.current.value, "tequi", ESX.GetWeaponLabel(data.current.value))

    end,
    function(data, menu)
      menu.close()
    end)
  end, "tequi")
end

function tequi_animsAction(animObj)
    Citizen.CreateThread(function()
        if not playAnim then

            if DoesEntityExist(playerPed) then -- Check if ped exist
                dataAnim = animObj

                -- Play Animation
                RequestAnimDict(dataAnim.lib)
                while not HasAnimDictLoaded(dataAnim.lib) do
                    Citizen.Wait(1)
                end
                if HasAnimDictLoaded(dataAnim.lib) then
                    local flag = 0
                    if dataAnim.loop ~= nil and dataAnim.loop then
                        flag = 1
                    elseif dataAnim.move ~= nil and dataAnim.move then
                        flag = 49
                    end

                    TaskPlayAnim(playerPed, dataAnim.lib, dataAnim.anim, 8.0, -8.0, -1, flag, 0, 0, 0, 0)
                    playAnimation = true
                end

                -- Wait end animation
                while true do
                    Citizen.Wait(1)
                    if not IsEntityPlayingAnim(playerPed, dataAnim.lib, dataAnim.anim, 3) then
                        playAnim = false
                        TriggerEvent('ft_animation:ClFinish')
                        break
                    end
                end
            end -- end ped exist
        end
    end)
end

AddEventHandler('esx_tequi:hasEnteredMarker', function(zone)
 
    if zone == 'BossActions' and tequi_IsGradeBoss() then
      CurrentAction     = 'menu_boss_actions'
      CurrentActionMsg  = Ftext_esx_tequilala('open_bossmenu')
      CurrentActionData = {}
    end

    if zone == 'Cloakrooms' then
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = Ftext_esx_tequilala('open_cloackroom')
      CurrentActionData = {}
    end

    if Config_esx_tequilala.EnableVaultManagement then
      if zone == 'Vaults' then
        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = Ftext_esx_tequilala('open_vault')
        CurrentActionData = {}
      end
    end

    if zone == 'Fridge' then
      CurrentAction     = 'menu_fridge'
      CurrentActionMsg  = Ftext_esx_tequilala('open_fridge')
      CurrentActionData = {}
    end
	
	if zone == 'Fridge2' then
      CurrentAction     = 'menu_fridge2'
      CurrentActionMsg  = Ftext_esx_tequilala('open_fridge')
      CurrentActionData = {}
    end
    
    if zone == 'Shops' then
      CurrentAction     = 'menu_coktail_creation'
      CurrentActionMsg  = ''
      CurrentActionData = {}
    end
end)

AddEventHandler('esx_tequi:hasExitedMarker', function(zone)
	if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
  local specialContact = {
    name       = "tequi",
    number     = 'tequi',
    base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAAsTAAALEwEAmpwYAAA7amlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxMzggNzkuMTU5ODI0LCAyMDE2LzA5LzE0LTAxOjA5OjAxICAgICAgICAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIKICAgICAgICAgICAgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiCiAgICAgICAgICAgIHhtbG5zOnN0RXZ0PSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VFdmVudCMiCiAgICAgICAgICAgIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIKICAgICAgICAgICAgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIgogICAgICAgICAgICB4bWxuczpwaG90b3Nob3A9Imh0dHA6Ly9ucy5hZG9iZS5jb20vcGhvdG9zaG9wLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOnRpZmY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vdGlmZi8xLjAvIgogICAgICAgICAgICB4bWxuczpleGlmPSJodHRwOi8vbnMuYWRvYmUuY29tL2V4aWYvMS4wLyI+CiAgICAgICAgIDx4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ+eG1wLmRpZDoxMDQwMDUzRUQ2Q0JFMTExOTQwOTgyNTk4MzYxRUYyMzwveG1wTU06T3JpZ2luYWxEb2N1bWVudElEPgogICAgICAgICA8eG1wTU06RG9jdW1lbnRJRD5hZG9iZTpkb2NpZDpwaG90b3Nob3A6YjhkMDYxYTktYzdjOC0xMWU3LWExMzAtZDMzYTkwMzA3ZWYyPC94bXBNTTpEb2N1bWVudElEPgogICAgICAgICA8eG1wTU06SW5zdGFuY2VJRD54bXAuaWlkOjAxMWEzZDQwLWFiOTgtYjI0Yi05MjM2LTA2ZjY4NjQ0ODRjODwveG1wTU06SW5zdGFuY2VJRD4KICAgICAgICAgPHhtcE1NOkRlcml2ZWRGcm9tIHJkZjpwYXJzZVR5cGU9IlJlc291cmNlIj4KICAgICAgICAgICAgPHN0UmVmOmluc3RhbmNlSUQ+eG1wLmlpZDo4RTQyQzM3Njc2RDFFMTExOUE5RUVCNUNGNTQ5MzZCRjwvc3RSZWY6aW5zdGFuY2VJRD4KICAgICAgICAgICAgPHN0UmVmOmRvY3VtZW50SUQ+eG1wLmRpZDoxMDQwMDUzRUQ2Q0JFMTExOTQwOTgyNTk4MzYxRUYyMzwvc3RSZWY6ZG9jdW1lbnRJRD4KICAgICAgICAgPC94bXBNTTpEZXJpdmVkRnJvbT4KICAgICAgICAgPHhtcE1NOkhpc3Rvcnk+CiAgICAgICAgICAgIDxyZGY6U2VxPgogICAgICAgICAgICAgICA8cmRmOmxpIHJkZjpwYXJzZVR5cGU9IlJlc291cmNlIj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OmFjdGlvbj5zYXZlZDwvc3RFdnQ6YWN0aW9uPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6aW5zdGFuY2VJRD54bXAuaWlkOjk1YWFmODAyLTQzY2YtOTg0MC04YjVmLTNmNWJjOGZjNGU4Mjwvc3RFdnQ6aW5zdGFuY2VJRD4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OndoZW4+MjAxNy0xMS0xMlQxNzo0NDoxNiswMTowMDwvc3RFdnQ6d2hlbj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OnNvZnR3YXJlQWdlbnQ+QWRvYmUgUGhvdG9zaG9wIENDIDIwMTcgKFdpbmRvd3MpPC9zdEV2dDpzb2Z0d2FyZUFnZW50PgogICAgICAgICAgICAgICAgICA8c3RFdnQ6Y2hhbmdlZD4vPC9zdEV2dDpjaGFuZ2VkPgogICAgICAgICAgICAgICA8L3JkZjpsaT4KICAgICAgICAgICAgICAgPHJkZjpsaSByZGY6cGFyc2VUeXBlPSJSZXNvdXJjZSI+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDphY3Rpb24+c2F2ZWQ8L3N0RXZ0OmFjdGlvbj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0Omluc3RhbmNlSUQ+eG1wLmlpZDowMTFhM2Q0MC1hYjk4LWIyNGItOTIzNi0wNmY2ODY0NDg0Yzg8L3N0RXZ0Omluc3RhbmNlSUQ+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDp3aGVuPjIwMTctMTEtMTJUMTc6NDQ6MTYrMDE6MDA8L3N0RXZ0OndoZW4+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDpzb2Z0d2FyZUFnZW50PkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE3IChXaW5kb3dzKTwvc3RFdnQ6c29mdHdhcmVBZ2VudD4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OmNoYW5nZWQ+Lzwvc3RFdnQ6Y2hhbmdlZD4KICAgICAgICAgICAgICAgPC9yZGY6bGk+CiAgICAgICAgICAgIDwvcmRmOlNlcT4KICAgICAgICAgPC94bXBNTTpIaXN0b3J5PgogICAgICAgICA8eG1wOkNyZWF0b3JUb29sPkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE3IChXaW5kb3dzKTwveG1wOkNyZWF0b3JUb29sPgogICAgICAgICA8eG1wOkNyZWF0ZURhdGU+MjAxNy0xMS0xMlQxNzozODo0MSswMTowMDwveG1wOkNyZWF0ZURhdGU+CiAgICAgICAgIDx4bXA6TW9kaWZ5RGF0ZT4yMDE3LTExLTEyVDE3OjQ0OjE2KzAxOjAwPC94bXA6TW9kaWZ5RGF0ZT4KICAgICAgICAgPHhtcDpNZXRhZGF0YURhdGU+MjAxNy0xMS0xMlQxNzo0NDoxNiswMTowMDwveG1wOk1ldGFkYXRhRGF0ZT4KICAgICAgICAgPGRjOmZvcm1hdD5pbWFnZS9wbmc8L2RjOmZvcm1hdD4KICAgICAgICAgPHBob3Rvc2hvcDpDb2xvck1vZGU+MzwvcGhvdG9zaG9wOkNvbG9yTW9kZT4KICAgICAgICAgPHRpZmY6T3JpZW50YXRpb24+MTwvdGlmZjpPcmllbnRhdGlvbj4KICAgICAgICAgPHRpZmY6WFJlc29sdXRpb24+NzIwMDAwLzEwMDAwPC90aWZmOlhSZXNvbHV0aW9uPgogICAgICAgICA8dGlmZjpZUmVzb2x1dGlvbj43MjAwMDAvMTAwMDA8L3RpZmY6WVJlc29sdXRpb24+CiAgICAgICAgIDx0aWZmOlJlc29sdXRpb25Vbml0PjI8L3RpZmY6UmVzb2x1dGlvblVuaXQ+CiAgICAgICAgIDxleGlmOkNvbG9yU3BhY2U+NjU1MzU8L2V4aWY6Q29sb3JTcGFjZT4KICAgICAgICAgPGV4aWY6UGl4ZWxYRGltZW5zaW9uPjMyPC9leGlmOlBpeGVsWERpbWVuc2lvbj4KICAgICAgICAgPGV4aWY6UGl4ZWxZRGltZW5zaW9uPjMyPC9leGlmOlBpeGVsWURpbWVuc2lvbj4KICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgCjw/eHBhY2tldCBlbmQ9InciPz6e1E46AAAAIGNIUk0AAHolAACAgwAA+f8AAIDp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'
  }
  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Create blips
Citizen.CreateThread(function()

    local blipMarker = Config_esx_tequilala.Blips.Blip
    local blipCoord = AddBlipForCoord(blipMarker.Pos.x, blipMarker.Pos.y, blipMarker.Pos.z)

    SetBlipSprite (blipCoord, blipMarker.Sprite)
    SetBlipDisplay(blipCoord, blipMarker.Display)
    SetBlipScale  (blipCoord, blipMarker.Scale)
    SetBlipColour (blipCoord, blipMarker.Colour)
    SetBlipAsShortRange(blipCoord, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Tequi-La-La")
    EndTextCommandSetBlipName(blipCoord)
    

end)

-- Display markers
function tequi06()
    if tequi_IsJobTrue() then
        for k,v in pairs(Config_esx_tequilala.Zones) do
            if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_esx_tequilala.DrawDistance) then
                DrawMarker(0, v.Pos.x, v.Pos.y, v.Pos.z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, false, false, false, false)         
            end
        end
    end
end

-- Enter / Exit marker events
function tequi05()
    if tequi_IsJobTrue() then
        local isInMarker  = false
        local currentZone = nil

        for k,v in pairs(Config_esx_tequilala.Zones) do
            if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
              isInMarker  = true
              currentZone = k
            end
        end

        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
            HasAlreadyEnteredMarker = true
            LastZone                = currentZone
            TriggerEvent('esx_tequi:hasEnteredMarker', currentZone)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('esx_tequi:hasExitedMarker', LastZone)
        end

    end
end





-- Key Controls
function tequi04()
    if CurrentAction ~= nil then

      if IsControlJustReleased(0, Keys['BACKSPACE']) then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	  end
	  
      if IsControlJustReleased(0,  Keys['E']) and tequi_IsJobTrue() then

        if CurrentAction == 'menu_cloakroom' then
            tequi_OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_vault' then
            tequi_OpenVaultMenu()
        end

        if CurrentAction == 'menu_fridge' then
            tequi_OpenFridgeMenu()
        end
		
		if CurrentAction == 'menu_fridge2' then
            tequi_OpenFridgeMenu()
        end

        if CurrentAction == 'menu_shop' then
            tequi_OpenShopMenu(CurrentActionData.zone)
        end

        if CurrentAction == 'menu_boss_actions' and tequi_IsGradeBoss() then

          local options = {
            wash      = Config_esx_tequilala.EnableMoneyWash,
          }

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'tequi', function(data, menu)

            menu.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = Ftext_esx_tequilala('open_bossmenu')
            CurrentActionData = {}

          end,options)

        end

        if CurrentAction == 'menu_coktail_creation' then
          TriggerEvent('Nebula_restaurants:OpenMenu', "tequi", true)
        end
                
        CurrentAction = nil

      end

    end
end

RegisterNetEvent('esx_tequi:openMenuJob')
AddEventHandler('esx_tequi:openMenuJob', function()
	tequi_OpenSocietyActionsMenu()
end)


-----------------------
----- TELEPORTERS -----

AddEventHandler('esx_tequi:teleportMarkers', function(position)
  SetEntityCoords(playerPed, position.x, position.y, position.z)
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
function tequi03()
		if (PlayerData.job ~= nil and PlayerData.job.name == 'tequi' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'tequi' and PlayerData.job2.service == 1) then
			
			if GetDistanceBetweenCoords(coords, Config_esx_tequilala.Zones.Cloakrooms.Pos.x, Config_esx_tequilala.Zones.Cloakrooms.Pos.y, Config_esx_tequilala.Zones.Cloakrooms.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_tequilala.Zones.Cloakrooms.Pos.x, Config_esx_tequilala.Zones.Cloakrooms.Pos.y, Config_esx_tequilala.Zones.Cloakrooms.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour vous changer')
			end
			if GetDistanceBetweenCoords(coords, Config_esx_tequilala.Zones.Vaults.Pos.x, Config_esx_tequilala.Zones.Vaults.Pos.y, Config_esx_tequilala.Zones.Vaults.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_tequilala.Zones.Vaults.Pos.x, Config_esx_tequilala.Zones.Vaults.Pos.y, Config_esx_tequilala.Zones.Vaults.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au coffre')
			end
			if GetDistanceBetweenCoords(coords, Config_esx_tequilala.Zones.Fridge.Pos.x, Config_esx_tequilala.Zones.Fridge.Pos.y, Config_esx_tequilala.Zones.Fridge.Pos.z,  true) < 2.0 then
        sleepThread = 20 
        DrawText3Ds(Config_esx_tequilala.Zones.Fridge.Pos.x, Config_esx_tequilala.Zones.Fridge.Pos.y, Config_esx_tequilala.Zones.Fridge.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au frigo')
			end
      if GetDistanceBetweenCoords(coords, Config_esx_tequilala.Zones.Fridge2.Pos.x, Config_esx_tequilala.Zones.Fridge2.Pos.y, Config_esx_tequilala.Zones.Fridge2.Pos.z,  true) < 2.0 then
        sleepThread = 20 
        DrawText3Ds(Config_esx_tequilala.Zones.Fridge2.Pos.x, Config_esx_tequilala.Zones.Fridge2.Pos.y, Config_esx_tequilala.Zones.Fridge2.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au frigo')
			end
			if GetDistanceBetweenCoords(coords, Config_esx_tequilala.Zones.Shops.Pos.x, Config_esx_tequilala.Zones.Shops.Pos.y, Config_esx_tequilala.Zones.Shops.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_tequilala.Zones.Shops.Pos.x, Config_esx_tequilala.Zones.Shops.Pos.y, Config_esx_tequilala.Zones.Shops.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour préparer une boisson')
			end
			
			if Config_esx_tequilala.EnablePlayerManagement and (PlayerData.job ~= nil and PlayerData.job.name == 'tequi' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'tequi' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then
				if GetDistanceBetweenCoords(coords, Config_esx_tequilala.Zones.BossActions.Pos.x, Config_esx_tequilala.Zones.BossActions.Pos.y, Config_esx_tequilala.Zones.BossActions.Pos.z,  true) < 2.0 then
          sleepThread = 20
          DrawText3Ds(Config_esx_tequilala.Zones.BossActions.Pos.x, Config_esx_tequilala.Zones.BossActions.Pos.y, Config_esx_tequilala.Zones.BossActions.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au boss menu')
				end
			end
			if GetDistanceBetweenCoords(coords, Config_esx_tequilala.TeleportZones.EnterBuilding.Pos.x, Config_esx_tequilala.TeleportZones.EnterBuilding.Pos.y, Config_esx_tequilala.TeleportZones.EnterBuilding.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_tequilala.TeleportZones.EnterBuilding.Pos.x, Config_esx_tequilala.TeleportZones.EnterBuilding.Pos.y, Config_esx_tequilala.TeleportZones.EnterBuilding.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour entrer')
			end
			if GetDistanceBetweenCoords(coords, Config_esx_tequilala.TeleportZones.ExitBuilding.Pos.x, Config_esx_tequilala.TeleportZones.ExitBuilding.Pos.y, Config_esx_tequilala.TeleportZones.ExitBuilding.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_tequilala.TeleportZones.ExitBuilding.Pos.x, Config_esx_tequilala.TeleportZones.ExitBuilding.Pos.y, Config_esx_tequilala.TeleportZones.ExitBuilding.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour sortir')
			end
			
			
		end
end

-- Display teleport markers
function tequi02()
    if tequi_IsJobTrue() then

        
        for k,v in pairs(Config_esx_tequilala.TeleportZones) do
          if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_esx_tequilala.DrawDistance) then
            DrawMarker(0, v.Pos.x, v.Pos.y, v.Pos.z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
          end
        end

    end

end

-- Activate teleport marker
function tequi01()
    
    local position    = nil
    local zone        = nil

    if tequi_IsJobTrue() then

        for k,v in pairs(Config_esx_tequilala.TeleportZones) do
          if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
            isInPublicMarker = true
            position = v.Teleport
            zone = v
            break
          else
            isInPublicMarker  = false
          end
        end

        if IsControlJustReleased(0, Keys["E"]) and isInPublicMarker then
          TriggerEvent('esx_tequi:teleportMarkers', position)
        end

        -- hide or show top left zone hints
        if isInPublicMarker then
          hintToDisplay = zone.Hint
          hintIsShowed = true
        else
          if not isInMarker then
            hintToDisplay = "no hint to display"
            hintIsShowed = false
          end
        end

    end
end

-----------------------
xSound = exports.xsound
RegisterNetEvent("esx_tequilala:playmusic")
AddEventHandler("esx_tequilala:playmusic", function(data)
    local pos = vec3(-559.99, 289.40, 82.17)
    if xSound:soundExists("tequi") then
      xSound:Destroy("tequilala")
    end
    xSound:PlayUrlPos("tequi", data, 0.1, pos)
    xSound:Distance("tequi", 20)
    xSound:Position("tequi", pos)
end)

RegisterNetEvent("esx_tequilala:pausetequi")
AddEventHandler("esx_tequilala:pausetequi", function(status)
	if status == "play" then
    xSound:Resume("tequi")
	elseif status == "pause" then
    xSound:Pause("tequi")
	end
end)

RegisterNetEvent("esx_tequilala:volumetequi")
AddEventHandler("esx_tequilala:volumetequi", function(volume)
	print(volume/100)
    xSound:setVolume("tequi", volume / 100)
end)

RegisterNetEvent("esx_tequilala:stoptequi")
AddEventHandler("esx_tequilala:stoptequi", function()
    xSound:Destroy("tequi")
end)