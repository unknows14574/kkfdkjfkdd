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



local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
--local CopPed                    = 0

GUI.Time                        = 0

function avocat2_OpenArmoryMenu(station)

if Config_esx_avoca2.EnableArmoryManagement then

  local elements = {
    {label = "Dressing", value = 'dressing'},
    {label = 'Ouvrir l\'armurerie', value = 'get_weapon'},
    {label = 'Ouvrir le stockage', value = 'get_stock'}
  }

ESX.UI.Menu.CloseAll()

ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory',
  {
      title    = Config_esx_avoca2.Txt.U_armory,
    align = 'right',
    elements = elements,
  },
  function(data, menu)
    
    if data.current.value == 'dressing' then
      avocat2_OpenRoomMenu()
    end

    if data.current.value == 'get_weapon' then
      TriggerEvent('core_inventory:client:openSocietyWeaponsInventory', 'society_avocat2')
      menu.close()
    end
    if data.current.value == 'get_stock' then
      TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_avocat2')
      menu.close()
    end
  end,
  function(data, menu)

      menu.close()

    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = Config_esx_avoca2.Txt.U_open_armory
    CurrentActionData = {station = station}
  end
)

else

  local elements = {}

for i=1, #Config_esx_avoca2.AvocatStations[station].AuthorizedWeapons, 1 do
    local weapon = Config_esx_avoca2.AvocatStations[station].AuthorizedWeapons[i]
  table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
end

ESX.UI.Menu.CloseAll()

ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory',
  {
      title    = Config_esx_avoca2.Txt.U_armory,
    align = 'right',
    elements = elements,
  },
  function(data, menu)
      local weapon = data.current.value
    TriggerServerEvent('esx_avocat2:giveWeapon', weapon, 1000)
  end,
  function(data, menu)

      menu.close()

    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = Config_esx_avoca2.Txt.U_open_armory
    CurrentActionData = {station = station}

  end
)
end

end







function avocat2_OpenRoomMenu()

  ESX.UI.Menu.CloseAll()

  local elements = {}

    table.insert(elements, {label = "Vêtements", value = 'player_dressing'})
    --table.insert(elements, {label = "Supprimer des tenues", value = 'remove_cloth'})

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

function avocat2_OpenIdentityCardMenu(player)

    if Config_esx_avoca2.EnableESXIdentity then

	    ESX.TriggerServerCallback('esx_avocat2:getOtherPlayerData', function(data)

		    local jobLabel    = nil
			local sexLabel    = nil
			local sex         = nil
			local dobLabel    = nil
			local heightLabel = nil
			local idLabel     = nil

			if data.job.grade_label ~= nil and data.job.grade_label ~= '' then
			    jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
			else
			    jobLabel = 'Job : ' .. data.job.label
			end

			if data.sex ~= nil then
			    if (data.sex == 'm') or (data.sex == 'M') then
				    sex = 'Male'
				else
				    sex = 'Female'
				end
				sexLabel = 'Sex : ' .. sex
			else
			    sexLabel = 'Sex : Unknown'
			end

			if data.job ~= nil then
			    dobLabel = 'DOB : ' .. data.dob
			else
			    dobLabel = 'DOB : Unknown'
			end

			if data.height ~= nil then
			    heightLabel = 'Height : ' .. data.height
			else
			    heightLabel = 'Height : Unknown'
			end

			if data.name ~= nil then
			    idLabel = 'ID : ' .. data.name
			else
			    idLabel = 'ID : Unknown'
			end

			local elements = {
			    {label = Config_esx_avoca2.Txt.U_name .. data.firstname .. " " .. data.lastname, value = nil},
				{label = sexLabel,    value = nil},
				{label = dobLabel,    value = nil},
				{label = heightLabel, value = nil},
				{label = jobLabel,    value = nil},
				{label = idLabel,     value = nil},
			}

			if data.licenses ~= nil then

			    table.insert(elements, {label = '--- Licenses ---', value = nil})

				for i=1, #data.licenses, 1 do
				    table.insert(elements, {label = data.licenses[i].label, value = nil})
				end

			end

			ESX.UI.Menu.Open(
			    'default', GetCurrentResourceName(), 'citizen_interaction',
				{
				    title     = Config_esx_avoca2.Txt.U_citizen_interaction,
					align     = 'top-left',
					elements  = elements,
				},
				function(data, menu)

				end,
				function(data, menu)
			        menu.close()
				end
			)
		end, GetPlayerServerId(player))

	else

	    ESX.TriggerServerCallback('esx_avocat2:getOtherPlayerData', function(data)

		    local jobLabel = nil

			if data.job.grade_label ~= nil and data.job.grade_label ~= '' then
	            jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
			else
			    jobLabel = 'Job : ' .. data.job.label
			end

                local elements = {
                    {label = Config_esx_avoca2.Txt.U_name .. data.name, value = nil},
                    {label = jobLabel,                value = nil},
				}

			if data.licenses ~= nil then

			    table.insert(elements, {label = '--- Licenses ---', value = nil})

				for i=1, #data.licenses, 1 do
				    table.insert(elements, {label = data.licenses[i].label, value = nil})
				end

			end

			ESX.UI.Menu.Open(
			    'default', GetCurrentResourceName(), 'citizen_interaction',
				{
				    title    = Config_esx_avoca2.Txt.U_citizen_interaction,
					align = 'right',
					elements = elements,
				},
				function(data, menu)

				end,
				function(data, menu)
				    menu.close()
				end
			)

		end, GetPlayerServerId(player))

	end

end

function avocat2_OpenAvocatActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'avocat2_actions',
    {
      title    = 'Avocat',
	  align = 'right',
      elements = {
        {label = Config_esx_avoca2.Txt.U_persofine, value = 'persofine'}
      }
    },
    function(data, menu)

      if data.current.value == 'persofine' then

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'persofine2',
          {
            title = "Montant"
          },
          function(data, menu)

            local amount = tonumber(data.value)

            if amount == nil then
              ESX.ShowNotification("Montant invalide!")
            else

              menu.close()

              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification("Personne a proximité!")
              else
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_avocat2', 'Avocat', amount)
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


function avocat2_OpenGetWeaponMenu()

    ESX.TriggerServerCallback('esx_avocat2:getArmoryWeapons', function(weapons)

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
			    title    = Config_esx_avoca2.Txt.U_get_weapon_menu,
				align = 'right',
				elements = elements,
			},
			function(data, menu)

			    menu.close()

				ESX.TriggerServerCallback('esx_avocat2:removeArmoryWeapon', function()
				    avocat2_OpenGetWeaponMenu()
				end, data.current.value)

			end,
			function(data, menu)
			    menu.close()
			end
		)

	end)

end

function avocat2_OpenPutWeaponMenu()

    local elements   = {}

	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do

	    local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
		    local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
			table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
		end

	end

	ESX.UI.Menu.Open(
	    'default', GetCurrentResourceName(), 'armory_put_weapon',
		{
		    title    = Config_esx_avoca2.Txt.U_put_weapon_menu,
			align = 'right',
			elements = elements,
		},
		function(data, menu)

		    menu.close()

			ESX.TriggerServerCallback('esx_avocat2:addArmoryWeapon', function()
			    avocat2_OpenPutWeaponMenu()
			end, data.current.value)

		end,
		function(data, menu)
		    menu.close()
		end
	)

end

function avocat2_OpenGetStockMenu()

    ESX.TriggerServerCallback('esx_avocat2:getStockItems', function(items)

        print(json.encode(items))

        local elements = {}

        for i=1, #items,1 do
            table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
		end

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'stocks_menu',
			{
			    title    = Config_esx_avoca2.Txt.U_avocat_stock,
				align = 'right',
				elements = elements
			},
			function(data, menu)

			    local itemName = data.current.value

				ESX.UI.Menu.Open(
				    'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
					{
					    title = Config_esx_avoca2.Txt.U_quantity
					},
					function(data2, menu2)

					    local count = tonumber(data2.value)

						if count == nil then
						    ESX.ShowNotification(Config_esx_avoca2.Txt.U_quantity_invalid)
						else
						    menu2.close()
							menu.close()
							avocat2_OpenGetStockMenu()

							TriggerServerEvent('esx_avocat2:getStockItem', itemName, count)
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

function avocat2_OpenPutStockMenu()

    ESX.TriggerServerCallback('esx_avocat2:getPlayerInventory', function(inventory)

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
			    title    = Config_esx_avoca2.Txt.U_inventory,
				align = 'right',
				elements = elements
			},
			function(data, menu)

			    local itemName = data.current.value

				ESX.UI.Menu.Open(
				    'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
				    {
					    title = Config_esx_avoca2.Txt.U_quantity
					},
					function(data2, menu2)

					    local count = tonumber(data2.value)

					    if count == nil then
						    ESX.ShowNotification(Config_esx_avoca2.Txt.U_quantity_invalid)
						else
						    menu2.close()
							menu.close()
							avocat2_OpenPutStockMenu()

							TriggerServerEvent('esx_avocat2:putStockItems', itemName, count)
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

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

    local specialContact = {
		  name       = 'Avocat2',
		  number     = 'avocat2',
        base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAB8SURBVEhLYxgFo2AUjIKRABihNBHgjYwKhCHy5A6EQQxggtI0A6RZsPzrJyAJ9woxgFgLIIbmvn8F4RIPBkcQcTAi0gIkhokPJaJSEVbjiExLNA8iwuCguCzQB8ieiOHmQxPBAwj7QJuVHUgiB8gScGIdBaNgFAwWwMAAAJCkGvcXbMRGAAAAAElFTkSuQmCC'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('esx_avocat2:hasEnteredMarker', function(station, part, partNum)

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = Config_esx_avoca2.Txt.U_open_armory
    CurrentActionData = {station = station}
  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = Config_esx_avoca2.Txt.U_open_bossmenu
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_avocat2:hasExitedMarker', function(station, part, partNum)
    if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	end
end)

Citizen.CreateThread(function()

    for k,v in pairs(Config_esx_avoca2.AvocatStations) do

		local blip2 = AddBlipForCoord(v.Blip2.Pos.x, v.Blip2.Pos.y, v.Blip2.Pos.z)

		SetBlipSprite (blip2, v.Blip2.Sprite)
		SetBlipDisplay(blip2, v.Blip2.Display)
		SetBlipScale  (blip2, v.Blip2.Scale)
		SetBlipColour (blip2, v.Blip2.Colour)
		SetBlipAsShortRange(blip2, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.Blip2.Name)
		EndTextCommandSetBlipName(blip2)
	end
end)
function iAvocat01()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'avocat2' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'avocat2' and PlayerData.job2.service == 1) then
	  
      for k,v in pairs(Config_esx_avoca2.AvocatStations) do

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config_esx_avoca2.DrawDistance then
            DrawMarker(0, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_esx_avoca2.MarkerColor.r, Config_esx_avoca2.MarkerColor.g, Config_esx_avoca2.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        if (Config_esx_avoca2.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'avocat2' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or
		(Config_esx_avoca2.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'avocat2' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then

          for i=1, #v.BossActions, 1 do
            if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config_esx_avoca2.DrawDistance then
              DrawMarker(0, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_esx_avoca2.MarkerColor.r, Config_esx_avoca2.MarkerColor.g, Config_esx_avoca2.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end
          end

        end

      end

    end
end

function iAvocat02()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'avocat2' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'avocat2' and PlayerData.job2.service == 1) then

      
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config_esx_avoca2.AvocatStations) do

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config_esx_avoca2.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Armory'
            currentPartNum = i
          end
        end

        if (Config_esx_avoca2.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'avocat2' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or 
		(Config_esx_avoca2.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'avocat2' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then

          for i=1, #v.BossActions, 1 do
            if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config_esx_avoca2.MarkerSize.x then
              isInMarker     = true
              currentStation = k
              currentPart    = 'BossActions'
              currentPartNum = i
            end
          end

        end

      end

      local hasExited = false

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

        if
          (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('esx_avocat2:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_avocat2:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_avocat2:hasExitedMarker', LastStation, LastPart, LastPartNum)
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

function iAvocat03()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'avocat2' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'avocat2' and PlayerData.job2.service == 1) then
	  
      for k,v in pairs(Config_esx_avoca2.AvocatStations) do

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < 2.0 then
            sleepThread = 20
            DrawText3Ds(v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z  + 1.2, 'Appuyez sur ~y~E~s~ pour acceder aux vestaires')
		      end
        end

        if (Config_esx_avoca2.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'avocat2' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or
		(Config_esx_avoca2.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'avocat2' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then

          for i=1, #v.BossActions, 1 do
            if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < 2.0 then
              sleepThread = 20
              DrawText3Ds(v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z  + 1.2, 'Appuyez sur ~y~E~s~ pour acceder au menu boss')
            end
          end

        end

      end

    end
end

function iAvocat04()
    if CurrentAction ~= nil then

      if IsControlJustReleased(0, Keys['BACKSPACE']) then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	  end
	  
      if (IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'avocat2' and PlayerData.job.service == 1) or (IsControlPressed(0,  Keys['E']) and PlayerData.job2 ~= nil and PlayerData.job2.name == 'avocat2' and PlayerData.job2.service == 1) then

        if CurrentAction == 'menu_cloakroom' then
          avocat2_OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_armory' then
          avocat2_OpenArmoryMenu(CurrentActionData.station)
        end

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'avocat2', function(data, menu)

            menu.close()

            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = Config_esx_avoca2.Txt.U_open_bossmenu
            CurrentActionData = {}

          end)

        end

        if CurrentAction == 'remove_entity' then
          DeleteEntity(CurrentActionData.entity)
        end

        CurrentAction = nil
        GUI.Time      = GetGameTimer()

      end

    end

    --if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'avocat2' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'avocat2_actions') and (GetGameTimer() - GUI.Time) > 150 then
      --OpenPoliceActionsMenu()
      --GUI.Time = GetGameTimer()
    --end

end

Citizen.CreateThread(function()
  local hash = GetHashKey("csb_anita")

  while not HasModelLoaded(hash) do
      RequestModel(hash)
      Wait(20)
  end

  ped = CreatePed("PED_TYPE_CIVMALE", "csb_anita",-594.14,-344.79,34.15, 110.59, false, true) -- Position du ped

  SetBlockingOfNonTemporaryEvents(ped, true) -- Fait en sorte que le ped ne réagisse à rien (n'aura pas peur si il y a des tirs etc...)
  FreezeEntityPosition(ped, true) -- Freeze le ped
  SetEntityInvincible(ped, true) -- Le rend invincible
SetModelAsNoLongerNeeded(hash)
end)

RegisterNetEvent('esx_avocat2:openMenuJob')
AddEventHandler('esx_avocat2:openMenuJob', function()
	avocat2_OpenAvocatActionsMenu()
end)
    -- ====================================================================
    -- =----------------------- [Load l'intérieur du (JOB AVOCAT2)] -----------------------=
    -- ====================================================================
    RequestIpl("ex_dt1_11_office_02b")