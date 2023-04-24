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

function Ftext_esx_tabac(txt)
	return Config_esx_tabac.Txt[txt]
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


function tabac_IsJobTrue()
    if PlayerData ~= nil then
        local IsJobTrue = false
        if (PlayerData.job ~= nil and PlayerData.job.name == 'tabac' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'tabac' and PlayerData.job2.service == 1) then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end

function tabac_IsGradeBoss()
    if PlayerData ~= nil then
        local IsGradeBoss = false
        if (PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'chef') or (PlayerData.job2.grade_name == 'boss' or PlayerData.job2.grade_name == 'chef') then
            IsGradeBoss = true
        end
        return IsGradeBoss
    end
end

function tabac_IsGradeBoss1()
    if PlayerData ~= nil then
        local IsGradeBoss = false
        if (PlayerData.job.grade_name == 'boss') or (PlayerData.job2.grade_name == 'boss') then
            IsGradeBoss = true
        end
        return IsGradeBoss
    end
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

   local specialContact = {
     name       = 'Tabac',
     number     = 'tabac',
     base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTV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'
   }

   TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

local wBlip = nil
local sBlip = nil
local rBlip = nil
local tBlip = nil
local vBlip = nil

function tabac_DeleteBlip()
    RemoveBlip(sBlip)
    RemoveBlip(rBlip)
    RemoveBlip(vBlip)
end

function tabac_weedBlip()

	wBlip = AddBlipForCoord(Config_esx_tabac.Weed.Pos.x, Config_esx_tabac.Weed.Pos.y, Config_esx_tabac.Weed.Pos.z)

	SetBlipSprite (wBlip, Config_esx_tabac.Weed.Sprite)
	SetBlipDisplay(wBlip, Config_esx_tabac.Weed.Display)
	SetBlipScale  (wBlip, Config_esx_tabac.Weed.Scale)
	SetBlipColour (wBlip, Config_esx_tabac.Weed.Colour)
	SetBlipAsShortRange(wBlip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Labo de weed")
  EndTextCommandSetBlipName(wBlip)
end

function dText(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function tabac_farmBlip()

	rBlip = AddBlipForCoord(Config_esx_tabac.Farm.Pos.x, Config_esx_tabac.Farm.Pos.y, Config_esx_tabac.Farm.Pos.z)

	SetBlipSprite (rBlip, Config_esx_tabac.Farm.Sprite)
	SetBlipDisplay(rBlip, Config_esx_tabac.Farm.Display)
	SetBlipScale  (rBlip, Config_esx_tabac.Farm.Scale)
	SetBlipColour (rBlip, Config_esx_tabac.Farm.Colour)
	SetBlipAsShortRange(rBlip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Récolte d'alcool")
  EndTextCommandSetBlipName(rBlip)
end

function tabac_traitBlip()

	tBlip = AddBlipForCoord(Config_esx_tabac.Trait.Pos.x, Config_esx_tabac.Trait.Pos.y, Config_esx_tabac.Trait.Pos.z)

	SetBlipSprite (tBlip, Config_esx_tabac.Trait.Sprite)
	SetBlipDisplay(tBlip, Config_esx_tabac.Trait.Display)
	SetBlipScale  (tBlip, Config_esx_tabac.Trait.Scale)
	SetBlipColour (tBlip, Config_esx_tabac.Trait.Colour)
	SetBlipAsShortRange(tBlip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Traitement d'alcool")
  EndTextCommandSetBlipName(tBlip)
end

function tabac_venteBlip()

	vBlip = AddBlipForCoord(Config_esx_tabac.Sell.Pos.x, Config_esx_tabac.Sell.Pos.y, Config_esx_tabac.Sell.Pos.z)

	SetBlipSprite (vBlip, Config_esx_tabac.Sell.Sprite)
	SetBlipDisplay(vBlip, Config_esx_tabac.Sell.Display)
	SetBlipScale  (vBlip, Config_esx_tabac.Sell.Scale)
	SetBlipColour (vBlip, Config_esx_tabac.Sell.Colour)
	SetBlipAsShortRange(vBlip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Vente d'alcool")
  EndTextCommandSetBlipName(vBlip)
end

function tabac_OpenGetWeaponMenu()

  ESX.TriggerServerCallback('tabac:getArmoryWeapons', function(weapons)

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
        title    = Ftext_esx_tabac('get_weapon_menu'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('tabac:removeArmoryWeapon', function()
          tabac_OpenGetWeaponMenu()
		  TriggerServerEvent('tabac:GetWeapon', data.current.value)
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function tabac_OpenPutWeaponMenu()

  local elements   = {}

  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPONFtext_esx_tabacNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = Ftext_esx_tabac('put_weapon_menu'),
      align = 'right',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('tabac:addArmoryWeapon', function()
        tabac_OpenPutWeaponMenu()
		TriggerServerEvent('tabac:PutWeapon', data.current.value)
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function tabac_OpenGetStocksMenu()

  ESX.TriggerServerCallback('tabac:getStockItems', function(items)

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
        title    = 'Ammu stock',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = Ftext_esx_tabac('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_tabac('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              tabac_OpenGetStocksMenu()
			  TriggerServerEvent('tabac:GetStocks', itemName, count)
              TriggerServerEvent('tabac:getStockItem', itemName, count)
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

function tabac_OpenPutStocksMenu()

  ESX.TriggerServerCallback('tabac:getPlayerInventory', function(inventory)

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
        title    = Ftext_esx_tabac('inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = Ftext_esx_tabac('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_tabac('quantity_invalid'))
            else
              TriggerServerEvent('tabac:putStockItems', itemName, count)
			  
			  menu2.close()
              menu.close()
			  
			  tabac_OpenPutStocksMenu()
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


function tabac_OpenEntreprise()

  local elements = {
	
    {label = 'Ouvrir l\'armurerie', value = 'get_weapon'},
    {label = 'Ouvrir le stockage', value = 'get_stock'},
    {label = 'Déposer Argent',  value = 'put_money'},
    {label = 'Retirer Argent',  value = 'get_money'},
  }
	

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'Entreprise',
      {
        title    = "Entreprise",
        align = 'right',
        elements = elements,
      },
      function(data, menu)
		
        if data.current.value == 'get_weapon' then
          TriggerEvent('core_inventory:client:openSocietyWeaponsInventory', 'society_tabac')
          menu.close()
        end
        if data.current.value == 'get_stock' then
          TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_tabac')
          menu.close()
        end
		
		if data.current.value == 'put_money' then
				ESX.TriggerServerCallback('tabac:CheckMoney', function (_money)
					local money = _money
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_tabac',
						{
							title = "[$" .. tonumber(money) .. "] d'argent dans le coffre"
						}, function(data, menu)
		
							local amount = tonumber(data.value)
		
							if amount == nil then
								ESX.ShowNotification("Montant invalide")
							else
								menu.close()
								TriggerServerEvent('tabac:putmoney', amount)
							end
		
						end, function(data, menu)
							menu.close()
						end)
					end)
		end
	  
		if data.current.value == 'get_money' then
				ESX.TriggerServerCallback('tabac:CheckMoney', function (_money)
					local money = _money
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_tabac',
					{
						title = "[$" .. tonumber(money) .. "] d'argent dans le coffre"
					}, function(data, menu)
	
						local amount = tonumber(data.value)
	
						if amount == nil then
							ESX.ShowNotification("Montant invalide")
						else
							menu.close()
							TriggerServerEvent('tabac:getmoney', amount)
						end
	
					end, function(data, menu)
						menu.close()
					end)
				end)

		end
		
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'Entreprise'
        CurrentActionMsg  = 'Entreprise'
		CurrentActionData = {}
      end
    )
end

function tabac_Vestiaires()
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


function tabac_Coffre()
  local elements = {
        {label = 'Déposer Item',  value = 'put_stock'},
	      {label = 'Retirer Item',  value = 'get_stock'},
		    {label = "Gestion entreprise", value = 'entreprise'},
      }

      ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'comptoir',
      {
        title    = "Comptoir",
        align = 'right',
        elements = elements,
        },

        function(data, menu)
		
		    if data.current.value == 'entreprise' then
		        if PlayerData.job.name ~= nil and ((PlayerData.job.grade_name == 'boss' and PlayerData.job.name == 'tabac') or (PlayerData.job2.grade_name == 'boss' and PlayerData.job2.name == 'tabac')) or ((PlayerData.job.grade_name == 'coboss' and PlayerData.job.name == 'tabac') or (PlayerData.job2.grade_name == 'coboss' and PlayerData.job2.name == 'tabac')) then
			        TriggerEvent('esx_extendedjob:EntrepriseV', 'tabac')
		        else
			      ESX.ShowNotification("Réserver au patron ou co-patron.")
		      end
        end
        if data.current.value == 'get_stock' then
          tabac_OpenGetStocksMenu()
        end
		    if data.current.value == 'put_stock' then
          tabac_OpenPutStocksMenu()
        end
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = Ftext_esx_tabac('open_cloackroom')
      CurrentActionData = {}
    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = Ftext_esx_tabac('open_cloackroom')
      CurrentActionData = {}
    end
    )

end

local locked = true

function tabac_OpenSocietyActionsMenu()

  local elements = {}

  table.insert(elements, {label = Ftext_esx_tabac('billing'),    value = 'billing'})

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'tabac_actions',
    {
      title    = Ftext_esx_tabac('tabac'),
      align = 'right',
      elements = elements
    },
    function(data, menu)

      if data.current.value == 'billing' then
        tabac_OpenBillingMenu()
      end
     
    end,
    function(data, menu)

      menu.close()

    end
  )

end

function tabac_OpenBillingMenu()

  ESX.UI.Menu.Open(
    'dialog', GetCurrentResourceName(), 'billing',
    {
      title = Ftext_esx_tabac('billing_amount')
    },
    function(data, menu)
    
      local amount = tonumber(data.value)
      local player, distance = ESX.Game.GetClosestPlayer()

      if player ~= -1 and distance <= 3.0 then

        menu.close()
        if amount == nil then
            ESX.ShowNotification(Ftext_esx_tabac('amount_invalid'))
        else
            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_tabac', Ftext_esx_tabac('billing'), amount)
        end

      else
        ESX.ShowNotification(Ftext_esx_tabac('no_players_nearby'))
      end

    end,
    function(data, menu)
        menu.close()
    end
  )
end

function tabac_OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_tabac:getStockItems', function(items)

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
        title    = Ftext_esx_tabac('tabac_stock'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = Ftext_esx_tabac('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_tabac('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              tabac_OpenGetStocksMenu()

              TriggerServerEvent('esx_tabac:getStockItem', itemName, count)
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

function tabac_OpenPutStocksMenu()

ESX.TriggerServerCallback('esx_tabac:getPlayerInventory', function(inventory)

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
        title    = Ftext_esx_tabac('inventory'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = Ftext_esx_tabac('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_tabac('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              tabac_OpenPutStocksMenu()

              TriggerServerEvent('esx_tabac:putStockItems', itemName, count)
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

function tabac_OpenGetFridgeStocksMenu()

  ESX.TriggerServerCallback('esx_tabac:getFridgeStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fridge_menu',
      {
        title    = Ftext_esx_tabac('tabac_fridge_stock'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'fridge_menu_get_item_count',
          {
            title = Ftext_esx_tabac('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_tabac('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              tabac_OpenGetStocksMenu()

              TriggerServerEvent('esx_tabac:getFridgeStockItem', itemName, count)
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

function tabac_OpenPutFridgeStocksMenu()

ESX.TriggerServerCallback('esx_tabac:getPlayerInventory', function(inventory)

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
        title    = Ftext_esx_tabac('fridge_inventory'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'fridge_menu_put_item_count',
          {
            title = Ftext_esx_tabac('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_tabac('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              tabac_OpenPutFridgeStocksMenu()

              TriggerServerEvent('esx_tabac:putFridgeStockItems', itemName, count)
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

function tabac_animsAction(animObj)
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

AddEventHandler('esx_tabac:hasEnteredMarker', function(zone)
    if zone == 'Cloakrooms' then
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = "Appuie sur ~y~E~w~ pour accéder au comptoir"
      CurrentActionData = {}
    end
    if zone == 'Vestiaire' then
      CurrentAction     = 'menu_vestiaire'
      CurrentActionMsg  = "Appuie sur ~y~E~w~ pour accéder aux vestiaires"
      CurrentActionData = {}
    end
end)

AddEventHandler('esx_tabac:hasExitedMarker', function(zone)
    if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
		TriggerServerEvent('esx_tabac:stopHarvest')
		TriggerServerEvent('esx_tabac:stopSell')
	end
end)

-- Create blips
Citizen.CreateThread(function()

    local blipMarker = Config_esx_tabac.Blips.Blip
    local blipCoord = AddBlipForCoord(blipMarker.Pos.x, blipMarker.Pos.y, blipMarker.Pos.z)

    SetBlipSprite (blipCoord, blipMarker.Sprite)
    SetBlipDisplay(blipCoord, blipMarker.Display)
    SetBlipScale  (blipCoord, blipMarker.Scale)
    SetBlipColour (blipCoord, blipMarker.Colour)
    SetBlipAsShortRange(blipCoord, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Ftext_esx_tabac('map_blip'))
    EndTextCommandSetBlipName(blipCoord)


end)

-- Display markers
function tabac05()
        if tabac_IsJobTrue() then

           
            for k,v in pairs(Config_esx_tabac.Zones) do
                if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_esx_tabac.DrawDistance) then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, false, false, false, false)
                end
            end

        end
end

-- Enter / Exit marker events
function tabac04()
        if tabac_IsJobTrue() then

            
            local isInMarker  = false
            local currentZone = nil

            for k,v in pairs(Config_esx_tabac.Zones) do
                if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2.0) then
                    isInMarker  = true
                    currentZone = k
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                HasAlreadyEnteredMarker = true
                LastZone                = currentZone
                TriggerEvent('esx_tabac:hasEnteredMarker', currentZone)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('esx_tabac:hasExitedMarker', LastZone)
            end

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
function tabac03()
      if tabac_IsJobTrue() then
			  if GetDistanceBetweenCoords(coords, Config_esx_tabac.Zones.Cloakrooms.Pos.x, Config_esx_tabac.Zones.Cloakrooms.Pos.y, Config_esx_tabac.Zones.Cloakrooms.Pos.z,  true) < 2.0 then
          sleepThread = 20
          DrawText3Ds(Config_esx_tabac.Zones.Cloakrooms.Pos.x, Config_esx_tabac.Zones.Cloakrooms.Pos.y, Config_esx_tabac.Zones.Cloakrooms.Pos.z, 'Appuyez sur ~y~E~s~ pour accéder au comptoir')
			  end
        if GetDistanceBetweenCoords(coords, Config_esx_tabac.Zones.Vestiaire.Pos.x, Config_esx_tabac.Zones.Vestiaire.Pos.y, Config_esx_tabac.Zones.Vestiaire.Pos.z,  true) < 2.0 then
          sleepThread = 20
          DrawText3Ds(Config_esx_tabac.Zones.Vestiaire.Pos.x, Config_esx_tabac.Zones.Vestiaire.Pos.y, Config_esx_tabac.Zones.Vestiaire.Pos.z, 'Appuyez sur ~y~E~s~ pour accéder aux vestiaires')
			  end
      end
end

-- Key Controls
function tabac02()
    if CurrentAction ~= nil then

      if IsControlJustReleased(0, Keys['BACKSPACE']) then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	  end 
	  
      if IsControlJustReleased(0,  Keys['E']) and tabac_IsJobTrue() then

        if CurrentAction == 'menu_cloakroom' then
          tabac_Coffre()
        end

        if CurrentAction == 'menu_vestiaire' then
          tabac_Vestiaires()
        end

        if CurrentAction == 'menu_fridge' then
            tabac_OpenFridgeMenu()
        end

        if CurrentAction == 'menu_boss_actions' and tabac_IsGradeBoss() then

          local options = {
            wash      = Config_esx_tabac.EnableMoneyWash,
          }

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'tabac', function(data, menu)

            menu.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = Ftext_esx_tabac('open_bossmenu')
            CurrentActionData = {}

          end,options)
        end
        CurrentAction = nil
      end
    end
end

RegisterNetEvent('esx_tabac:openMenuJob')
AddEventHandler('esx_tabac:openMenuJob', function()
	tabac_OpenSocietyActionsMenu()
end)

-- Show top left hint
function tabac01()
    if hintIsShowed == true then
      SetTextComponentFormat("STRING")
      AddTextComponentString(hintToDisplay)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end
end

xSound = exports.xsound
RegisterNetEvent("esx_tabac:playmusic")
AddEventHandler("esx_tabac:playmusic", function(data)
    local pos = vec3(-1731.28, -1158.52, 15.30)
    if xSound:soundExists("auto") then
      xSound:Destroy("auto")
    end
    xSound:PlayUrlPos("auto", data, 0.1, pos)
    xSound:Distance("auto", 50)
    xSound:Position("auto", pos)
end)

RegisterNetEvent("esx_tabac:pauseauto")
AddEventHandler("esx_tabac:pauseauto", function(status)
	if status == "play" then
    xSound:Resume("auto")
	elseif status == "pause" then
    xSound:Pause("auto")
	end
end)

RegisterNetEvent("esx_tabac:volumeauto")
AddEventHandler("esx_tabac:volumeauto", function(volume)
	print(volume/100)
    xSound:setVolume("auto", volume / 100)
end)

RegisterNetEvent("esx_tabac:stopauto")
AddEventHandler("esx_tabac:stopauto", function()
    xSound:Destroy("auto")
end)