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

  function avocat_OpenRoomMenu()

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

function avocat_OpenArmoryMenu(station)

    if Config_esx_avocat.EnableArmoryManagement then

	    local elements = {
			{label = 'Ouvrir le stockage', value = 'get_stock'},
			{label = 'Ouvrir l\'armurerie', value = 'get_weapon'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'armory',
			{
			    title    = Config_esx_avocat.Txt.U_armory,
				align = 'right',
				elements = elements,
			},
      function(data, menu)
		if data.current.value == 'get_weapon' then
			TriggerEvent('core_inventory:client:openSocietyWeaponsInventory', 'society_avocat')
			menu.close()
		end
		if data.current.value == 'get_stock' then
			TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_avocat')
			menu.close()
		end
			end,
			function(data, menu)

			    menu.close()

				CurrentAction     = 'menu_armory'
				CurrentActionMsg  = Config_esx_avocat.Txt.U_open_armory
				CurrentActionData = {station = station}
			end
		)

	else

	    local elements = {}

		for i=1, #Config_esx_avocat.AvocatStations[station].AuthorizedWeapons, 1 do
		    local weapon = Config_esx_avocat.AvocatStations[station].AuthorizedWeapons[i]
			table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'armory',
			{
			    title    = Config_esx_avocat.Txt.U_armory,
				align = 'right',
				elements = elements,
			},
			function(data, menu)
			    local weapon = data.current.value
				TriggerServerEvent('esx_avocat:giveWeapon', weapon, 1000)
			end,
			function(data, menu)

			    menu.close()

				CurrentAction     = 'menu_armory'
				CurrentActionMsg  = Config_esx_avocat.Txt.U_open_armory
				CurrentActionData = {station = station}

			end
		)
	end

end


function avocat_OpenIdentityCardMenu(player)

    if Config_esx_avocat.EnableESXIdentity then

	    ESX.TriggerServerCallback('esx_avocat:getOtherPlayerData', function(data)

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
			    {label = Config_esx_avocat.Txt.U_name .. data.firstname .. " " .. data.lastname, value = nil},
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
				    title     = Config_esx_avocat.Txt.U_citizen_interaction,
					align = 'right',
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

	    ESX.TriggerServerCallback('esx_avocat:getOtherPlayerData', function(data)

		    local jobLabel = nil

			if data.job.grade_label ~= nil and data.job.grade_label ~= '' then
	            jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
			else
			    jobLabel = 'Job : ' .. data.job.label
			end

                local elements = {
                    {label = Config_esx_avocat.Txt.U_name .. data.name, value = nil},
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
				    title    = Config_esx_avocat.Txt.U_citizen_interaction,
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

function avocat_OpenAvocatActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'avocatZZ_actions',
    {
      title    = 'Avocat',
	  align = 'right',
      elements = {
        {label = Config_esx_avocat.Txt.U_persofine, value = 'persofine'}
      }
    },
    function(data, menu)

      if data.current.value == 'persofine' then

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'persofine',
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
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_avocat', 'Avocat', amount)
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


function avocat_OpenGetWeaponMenu()

    ESX.TriggerServerCallback('esx_avocat:getArmoryWeapons', function(weapons)

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
			    title    = Config_esx_avocat.Txt.U_get_weapon_menu,
				align = 'right',
				elements = elements,
			},
			function(data, menu)

			    menu.close()

				ESX.TriggerServerCallback('esx_avocat:removeArmoryWeapon', function()
				    avocat_OpenGetWeaponMenu()
				end, data.current.value)

			end,
			function(data, menu)
			    menu.close()
			end
		)

	end)

end

function avocat_OpenPutWeaponMenu()

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
		    title    = Config_esx_avocat.Txt.U_put_weapon_menu,
			align = 'right',
			elements = elements,
		},
		function(data, menu)

		    menu.close()

			ESX.TriggerServerCallback('esx_avocat:addArmoryWeapon', function()
			    avocat_OpenPutWeaponMenu()
			end, data.current.value)

		end,
		function(data, menu)
		    menu.close()
		end
	)

end

function avocat_OpenGetStockMenu()

    ESX.TriggerServerCallback('esx_avocat:getStockItems', function(items)

        print(json.encode(items))

        local elements = {}

        for i=1, #items,1 do
            table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
		end

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'stocks_menu',
			{
			    title    = "Stocks",
				align = 'right',
				elements = elements
			},
			function(data, menu)

			    local itemName = data.current.value

				ESX.UI.Menu.Open(
				    'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
					{
					    title = Config_esx_avocat.Txt.U_quantity
					},
					function(data2, menu2)

					    local count = tonumber(data2.value)

						if count == nil then
						    ESX.ShowNotification(Config_esx_avocat.Txt.U_quantity_invalid)
						else
						    menu2.close()
							menu.close()
							avocat_OpenGetStockMenu()

							TriggerServerEvent('esx_avocat:getStockItem', itemName, count)
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

function avocat_OpenPutStockMenu()

    ESX.TriggerServerCallback('esx_avocat:getPlayerInventory', function(inventory)

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
			    title    = Config_esx_avocat.Txt.U_inventory,
				align = 'right',
				elements = elements
			},
			function(data, menu)

			    local itemName = data.current.value

				ESX.UI.Menu.Open(
				    'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
				    {
					    title = Config_esx_avocat.Txt.U_quantity
					},
					function(data2, menu2)

					    local count = tonumber(data2.value)

					    if count == nil then
						    ESX.ShowNotification(Config_esx_avocat.Txt.U_quantity_invalid)
						else
						    menu2.close()
							menu.close()
							avocat_OpenPutStockMenu()

							TriggerServerEvent('esx_avocat:putStockItems', itemName, count)
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
	    name       = 'Avocat',
		  number     = 'avocat',
        base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAB8SURBVEhLYxgFo2AUjIKRABihNBHgjYwKhCHy5A6EQQxggtI0A6RZsPzrJyAJ9woxgFgLIIbmvn8F4RIPBkcQcTAi0gIkhokPJaJSEVbjiExLNA8iwuCguCzQB8ieiOHmQxPBAwj7QJuVHUgiB8gScGIdBaNgFAwWwMAAAJCkGvcXbMRGAAAAAElFTkSuQmCC'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('esx_avocat:hasEnteredMarker', function(station, part, partNum)

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = Config_esx_avocat.Txt.U_open_armory
    CurrentActionData = {station = station}
  end

  if part == 'ClothRoom' then
    CurrentAction     = 'menu_clothRoom'
    CurrentActionMsg  = Config_esx_avocat.Txt.U_open_cloth
    CurrentActionData = {station = station}
  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = Config_esx_avocat.Txt.U_open_bossmenu
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_avocat:hasExitedMarker', function(station, part, partNum)
    if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	end
end)

Citizen.CreateThread(function()

    for k,v in pairs(Config_esx_avocat.AvocatStations) do
	    local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config_esx_avocat.Txt.U_map_blip)
		EndTextCommandSetBlipName(blip)

	end
end)

function Avocat01()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'avocat' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'avocat' and PlayerData.job2.service == 1) then

      for k,v in pairs(Config_esx_avocat.AvocatStations) do
		

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config_esx_avocat.DrawDistance then
            DrawMarker(0, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_esx_avocat.MarkerColor.r, Config_esx_avocat.MarkerColor.g, Config_esx_avocat.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.ClothRoom, 1 do
          if GetDistanceBetweenCoords(coords,  v.ClothRoom[i].x,  v.ClothRoom[i].y,  v.ClothRoom[i].z,  true) < Config_esx_avocat.DrawDistance then
            DrawMarker(0, v.ClothRoom[i].x, v.ClothRoom[i].y, v.ClothRoom[i].z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_esx_avocat.MarkerColor.r, Config_esx_avocat.MarkerColor.g, Config_esx_avocat.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        if (Config_esx_avocat.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'avocat' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or
		(Config_esx_avocat.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'avocat' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then

          for i=1, #v.BossActions, 1 do
            if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config_esx_avocat.DrawDistance then
              DrawMarker(0, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_esx_avocat.MarkerColor.r, Config_esx_avocat.MarkerColor.g, Config_esx_avocat.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end
          end

        end

      end

    end
end

function Avocat02()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'avocat' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'avocat' and PlayerData.job2.service == 1) then

      local coords         = coords
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config_esx_avocat.AvocatStations) do

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config_esx_avocat.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Armory'
            currentPartNum = i
          end
        end

        for i=1, #v.ClothRoom, 1 do
          if GetDistanceBetweenCoords(coords,  v.ClothRoom[i].x,  v.ClothRoom[i].y,  v.ClothRoom[i].z,  true) < Config_esx_avocat.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'ClothRoom'
            currentPartNum = i
          end
        end

        if (Config_esx_avocat.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'avocat' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or 
		(Config_esx_avocat.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'avocat' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then

          for i=1, #v.BossActions, 1 do
            if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config_esx_avocat.MarkerSize.x then
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
          TriggerEvent('esx_avocat:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_avocat:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_avocat:hasExitedMarker', LastStation, LastPart, LastPartNum)
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
function Avocat03()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'avocat' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'avocat' and PlayerData.job2.service == 1) then

      for k,v in pairs(Config_esx_avocat.AvocatStations) do
		

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < 2.0 then
			sleepThread = 20
			DrawText3Ds(v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z  + 1.2, 'Appuyez sur ~y~E~s~ pour acceder aux stockages')
		  end
        end

        for i=1, #v.ClothRoom, 1 do
          if GetDistanceBetweenCoords(coords,  v.ClothRoom[i].x,  v.ClothRoom[i].y,  v.ClothRoom[i].z,  true) < 2.0 then
			sleepThread = 20
			DrawText3Ds(v.ClothRoom[i].x,  v.ClothRoom[i].y,  v.ClothRoom[i].z  + 1.2, 'Appuyez sur ~y~E~s~ pour acceder au vestiaire')
		  end
        end

        if (Config_esx_avocat.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'avocat' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or
		(Config_esx_avocat.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'avocat' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then

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

function Avocat04()
    if CurrentAction ~= nil then

      if IsControlJustReleased(0, Keys['BACKSPACE']) then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	  end
	  
      if (IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'avocat' and PlayerData.job.service == 1) or (IsControlPressed(0,  Keys['E']) and PlayerData.job2 ~= nil and PlayerData.job2.name == 'avocat' and PlayerData.job2.service == 1) then

        if CurrentAction == 'menu_armory' then
          avocat_OpenArmoryMenu(CurrentActionData.station)
        end

        if CurrentAction == 'menu_clothRoom' then
			avocat_OpenRoomMenu()
		end

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'avocat', function(data, menu)

            menu.close()

            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = Config_esx_avocat.Txt.U_open_bossmenu
            CurrentActionData = {}

          end)

        end

        if CurrentAction == 'remove_entity' then
          DeleteEntity(CurrentActionData.entity)
        end

        GUI.Time      = GetGameTimer()

      end

    end
end

RegisterNetEvent('esx_avocat:openMenuJob')
AddEventHandler('esx_avocat:openMenuJob', function()
	avocat_OpenAvocatActionsMenu()
end)

xSound = exports.xsound
RegisterNetEvent("esx_avocat:playmusic")
AddEventHandler("esx_avocat:playmusic", function(data)
    local pos = vec3(385.26, -63.98, 107.47)
    if xSound:soundExists("stony") then
      xSound:Destroy("stony")
    end
    xSound:PlayUrlPos("stony", data, 0.1, pos)
    xSound:Distance("stony", 12)
    xSound:Position("stony", pos)
end)

RegisterNetEvent("esx_avocat:pausestony")
AddEventHandler("esx_avocat:pausestony", function(status)
	if status == "play" then
    xSound:Resume("stony")
	elseif status == "pause" then
    xSound:Pause("stony")
	end
end)

RegisterNetEvent("esx_avocat:volumestony")
AddEventHandler("esx_avocat:volumestony", function(volume)
	print(volume/100)
    xSound:setVolume("stony", volume / 100)
end)

RegisterNetEvent("esx_avocat:stopstony")
AddEventHandler("esx_avocat:stopstony", function()
    xSound:Destroy("stony")
end) 
    -- ====================================================================
    -- =----------------------- [Load l'intérieur du (JOB AVOCAT)] -----------------------=
    -- ====================================================================
	RequestIpl("ex_dt1_02_office_02a")

