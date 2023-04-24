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

zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

GUI.Time                        = 0

function prison_OpenRoomMenu()

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

function prison_OpenCloakroomMenu()

  local elements = {
    {label = "Vestiaire", value = 'dressing'},
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
      menu.close()

      if data.current.value == 'dressing' then
        prison_OpenRoomMenu()
      end

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour vous changer'
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour vous changer'
      CurrentActionData = {}
    end
  )

end

function prison_OpenCoffreMenu(station)
  if Config_prisonfederal.EnableArmoryManagement then

    local elements = {
			{label = 'Ouvrir le stockage', value = 'get_stock'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'coffre',
      {
          title    = 'coffre',
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'get_stock' then
          TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_prison')
          menu.close()
        end
      end,
      function(data, menu)

          menu.close()

        CurrentAction     = 'menu_coffre'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au coffre'
        CurrentActionData = {station = station}
      end
    )
end
end

function prison_OpenArmoryMenu(station)
    if Config_prisonfederal.EnableArmoryManagement then

      local elements = {
        {label = 'Ouvrir l\'armurerie', value = 'get_weapon'},
      }

      ESX.UI.Menu.CloseAll()

      ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'armory',
        {
            title    = 'armurerie',
          align = 'right',
          elements = elements,
        },
        function(data, menu)

          if data.current.value == 'get_weapon' then
            TriggerEvent('core_inventory:client:openSocietyWeaponsInventory', 'society_prison')
            menu.close()
          end
        end,
        function(data, menu)

            menu.close()

          CurrentAction     = 'menu_armory'
          CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder à l\'armurerie'
          CurrentActionData = {station = station}
        end
      )
	end
end

function prison_OpenAccessoiresMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'Accessoires_menu',
    {
      title    = "Accessoires",
      align = 'right',
      elements = {
    {label = "Mettre gilet pare-balles", value = 'gilet1_put'},
		{label = "Mettre Oreillette", value = 'Oreillette_put'},
    {label = "Mettre Bonnet", value = 'Bonnet_put'},
    {label = "Mettre Gants", value = 'gants_put'},
    {label = 'Mettre Masque', value = 'Masque_put'},
    {label = 'Retirer le gilet pare-balle', value = 'gilet_remove'},
    {label = "Retirer Bonnet", value = 'Casque_remove'},
    {label = "Retirer gants", value = 'gants_remove'},
    {label = 'Retirer Masque, Oreillette', value = 'Masque_remove'},
      },
    },
    function(data, menu)

	if data.current.value == 'gilet1_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
          ['bproof_1'] = 20, ['bproof_2'] = 8
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
          ['bproof_1'] = 23, ['bproof_2'] = 8
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
    end)
    SetPedArmour(playerPed, 35)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
  end

	if data.current.value == 'gilet_remove' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
          ['bproof_1'] = 0, ['bproof_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
          ['bproof_1'] = 0, ['bproof_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
    end)
    SetPedArmour(playerPed, 0)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
  end

  if data.current.value == 'Casque_remove' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['helmet_1'] = -1, ['helmet_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['helmet_1'] = -1, ['helmet_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
	end

	if data.current.value == 'Oreillette_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['mask_1'] = 121, ['mask_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['mask_1'] = 121, ['mask_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
	end
	
	if data.current.value == 'Bonnet_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['helmet_1'] = 5, ['helmet_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['helmet_1'] = 5, ['helmet_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
  end
  
  if data.current.value == 'gants_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['arms'] = 38
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['arms'] = 36
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
  end
  
  if data.current.value == 'gants_remove' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['arms'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['arms'] = 14
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
  end
	  
	if data.current.value == 'Masque_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['mask_1'] = 56, ['mask_2'] = 1
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['mask_1'] = 56, ['mask_2'] = 1
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
  end

	if data.current.value == 'Masque_remove' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['mask_1'] = -1, ['mask_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['mask_1'] = -1, ['mask_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
    end

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function prison_OpenprisonActionsMenu()

  ESX.UI.Menu.CloseAll()

  local elements = {}

  if ESX.PlayerData.job.grade_name == 'medic' or ESX.PlayerData.job.grade_name == 'coboss' then
    table.insert(elements, {label = "---------Medecin---------", value = ''})
    table.insert(elements, {label = "Soigner", value = 'heal'})
  end

  table.insert(elements, {label = "---------GARDIEN---------", value = ''})
  table.insert(elements, {label = "Accessoires", value = 'accessoires'})
  table.insert(elements, {label = "Fouiller un prisonnier", value = 'body_search'})
  table.insert(elements, {label = "Menotter un prisonnier", value = 'handcuff'})
  table.insert(elements, {label = "Escorter un prisonnier", value = 'drag'})
  table.insert(elements, {label = "Mettre en prison", value = 'jail_menu'} )

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'prison_actions',
    {
      title    = 'Prison',
      align = 'right',
      elements = elements
    },
    function(data, menu)
      if data.current.value == 'accessoires' then
        prison_OpenAccessoiresMenu()
        return
      end
      
      if data.current.value == 'jail_menu' then
        local pedCoords = coords
        local JailLoc = zones[GetNameOfZone(pedCoords.x, pedCoords.y, pedCoords.z)]
        
        if JailLoc == "Bolingbroke Penitentiary" then
          TriggerEvent("esx-qalle-jail:openJailMenu")
        else
          TriggerEvent('Core:ShowAdvancedNotification', "~b~Bolingbroke Penitentiary", "~y~Notification", "Tu n\'es pas à la prison.", 'CHAR_LESTER', 1, false, false, 140)
        end
      end

      local player, distance = ESX.Game.GetClosestPlayer()
      if player ~= -1 and distance <= 3.0 then
        if data.current.value == 'body_search' then
          police_OpenBodySearchMenu(player)
        end

        if data.current.value == 'handcuff' then
          TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(player))
        end

        if data.current.value == 'drag' then
          TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(player))
        end

        if data.current.value == 'heal' then
          if GetDistanceBetweenCoords(GetEntityCoords(playerPed), 1779.81, 2561.24, 45.79, false) <= 30 then
            Citizen.CreateThread(function()
              TriggerEvent('Core:ShowNotification', "Soins en cours...")
              TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
              Wait(30000)
              ClearPedTasks(playerPed)
              TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(player), 'harybo')
              TriggerEvent('Core:ShowNotification', "Vous avez effectué les premiers soins à la personne. Pensez à appeler les secours.")
            end)
          else
            TriggerEvent('Core:ShowNotification', "~r~Vous devez être à l'infirmerie.")
          end
        end

      else
        TriggerEvent('Core:ShowNotification', "Il n'y a personne à proximité.")
      end
    end,
    function(data, menu)
      menu.close()
    end
  )

end


function prison_OpenGetWeaponMenu()

    ESX.TriggerServerCallback('esx_prisonfederal:getArmoryWeapons', function(weapons)

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
        title    = 'Armurerie - Prendre Arme',
        align = 'right',
        elements = elements,
			},
			function(data, menu)

			    menu.close()

				ESX.TriggerServerCallback('esx_prisonfederal:removeArmoryWeapon', function()
				    prison_OpenGetWeaponMenu()
				end, data.current.value)

			end,
			function(data, menu)
			    menu.close()
			end
		)

	end)

end

function prison_OpenPutWeaponMenu()

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
		    title    = 'Armurerie - Déposer arme',
			align = 'right',
			elements = elements,
		},
		function(data, menu)

		    menu.close()

			ESX.TriggerServerCallback('esx_prisonfederal:addArmoryWeapon', function()
			    prison_OpenPutWeaponMenu()
			end, data.current.value)

		end,
		function(data, menu)
		    menu.close()
		end
	)

end

function prison_OpenGetStockMenu()

    ESX.TriggerServerCallback('esx_prisonfederal:getStockItems', function(items)

        print(json.encode(items))

        local elements = {}

        for i=1, #items,1 do
          table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
		    end

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'stocks_menu',
			{
			    title    = 'prison_stock',
				align = 'right',
				elements = elements
			},
			function(data, menu)

			    local itemName = data.current.value

				ESX.UI.Menu.Open(
				    'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
					{
					    title = 'Quantité'
					},
					function(data2, menu2)

					    local count = tonumber(data2.value)

						if count == nil then
						    TriggerEvent('Core:ShowNotification', 'Quantité invalide')
						else
						    menu2.close()
							menu.close()
							prison_OpenGetStockMenu()

							TriggerServerEvent('esx_prisonfederal:getStockItem', itemName, count)
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

function prison_OpenPutStockMenu()

    ESX.TriggerServerCallback('esx_prisonfederal:getPlayerInventory', function(inventory)

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
			    title    = 'inventaire',
				align = 'right',
				elements = elements
			},
			function(data, menu)

			    local itemName = data.current.value

				ESX.UI.Menu.Open(
				    'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
				    {
					    title = 'Quantité'
					},
					function(data2, menu2)

					    local count = tonumber(data2.value)

					    if count == nil then
						    TriggerEvent('Core:ShowNotification', 'Quantité invalide')
						else
						    menu2.close()
							menu.close()
							prison_OpenPutStockMenu()

							TriggerServerEvent('esx_prisonfederal:putStockItems', itemName, count)
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
		  name       = 'prison',
		  number     = 'prison',
        base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAB8SURBVEhLYxgFo2AUjIKRABihNBHgjYwKhCHy5A6EQQxggtI0A6RZsPzrJyAJ9woxgFgLIIbmvn8F4RIPBkcQcTAi0gIkhokPJaJSEVbjiExLNA8iwuCguCzQB8ieiOHmQxPBAwj7QJuVHUgiB8gScGIdBaNgFAwWwMAAAJCkGvcXbMRGAAAAAElFTkSuQmCC'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('esx_prisonfederal:hasEnteredMarker', function(station, part, partNum)

  if part == 'Cloakroom' then
    CurrentAction     = 'menu_cloakroom'
    CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour vous changer'
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder à l\'armurerie'
    CurrentActionData = {station = station}
  end

  if part == 'Coffre' then
    CurrentAction     = 'menu_coffre'
    CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au coffre'
    CurrentActionData = {station = station}
  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu'
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_prisonfederal:hasExitedMarker', function(station, part, partNum)
    if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	end
end)

Citizen.CreateThread(function()

    for k,v in pairs(Config_prisonfederal.prisonStations) do

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

function prison04()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'prison' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'prison' and PlayerData.job2.service == 1) then
	  
      for k,v in pairs(Config_prisonfederal.prisonStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config_prisonfederal.DrawDistance then
            DrawMarker(0, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_prisonfederal.MarkerColor.r, Config_prisonfederal.MarkerColor.g, Config_prisonfederal.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config_prisonfederal.DrawDistance then
            DrawMarker(0, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_prisonfederal.MarkerColor.r, Config_prisonfederal.MarkerColor.g, Config_prisonfederal.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Coffre, 1 do
          if GetDistanceBetweenCoords(coords,  v.Coffre[i].x,  v.Coffre[i].y,  v.Coffre[i].z,  true) < Config_prisonfederal.DrawDistance then
            DrawMarker(0, v.Coffre[i].x, v.Coffre[i].y, v.Coffre[i].z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_prisonfederal.MarkerColor.r, Config_prisonfederal.MarkerColor.g, Config_prisonfederal.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        if (Config_prisonfederal.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'prison' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or
		      (Config_prisonfederal.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'prison' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) or
          (Config_prisonfederal.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'prison' and PlayerData.job.grade_name == 'coboss' and PlayerData.job.service == 1) or
		      (Config_prisonfederal.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'prison' and PlayerData.job2.grade_name == 'coboss' and PlayerData.job2.service == 1) then

          for i=1, #v.BossActions, 1 do
            if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config_prisonfederal.DrawDistance then
              DrawMarker(0, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_prisonfederal.MarkerColor.r, Config_prisonfederal.MarkerColor.g, Config_prisonfederal.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end
          end

        end

      end

    end
end

function prison03()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'prison' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'prison' and PlayerData.job2.service == 1) then

      
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config_prisonfederal.prisonStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config_prisonfederal.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Cloakroom'
            currentPartNum = i
          end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config_prisonfederal.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Armory'
            currentPartNum = i
          end
        end

        for i=1, #v.Coffre, 1 do
          if GetDistanceBetweenCoords(coords,  v.Coffre[i].x,  v.Coffre[i].y,  v.Coffre[i].z,  true) < Config_prisonfederal.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Coffre'
            currentPartNum = i
          end
        end

        if (Config_prisonfederal.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'prison' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or 
		    (Config_prisonfederal.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'prison' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) or 
        (Config_prisonfederal.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'prison' and PlayerData.job.grade_name == 'coboss' and PlayerData.job.service == 1) or 
		    (Config_prisonfederal.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'prison' and PlayerData.job2.grade_name == 'coboss' and PlayerData.job2.service == 1)then

          for i=1, #v.BossActions, 1 do
            if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config_prisonfederal.MarkerSize.x then
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
          TriggerEvent('esx_prisonfederal:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_prisonfederal:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_prisonfederal:hasExitedMarker', LastStation, LastPart, LastPartNum)
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

function prison02()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'prison' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'prison' and PlayerData.job2.service == 1) then
	  
      for k,v in pairs(Config_prisonfederal.prisonStations) do

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < 2.0 then
            sleepThread = 20
            DrawText3Ds(v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z  + 1.2, 'Appuyez sur ~y~E~s~ pour acceder à l\'armurerie')
		      end
        end

        for i=1, #v.Coffre, 1 do
          if GetDistanceBetweenCoords(coords,  v.Coffre[i].x,  v.Coffre[i].y,  v.Coffre[i].z,  true) < 2.0 then
            sleepThread = 20
            DrawText3Ds(v.Coffre[i].x,  v.Coffre[i].y,  v.Coffre[i].z  + 1.2, 'Appuyez sur ~y~E~s~ pour acceder au coffre')
		      end
        end

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < 2.0 then
            sleepThread = 20
            DrawText3Ds(v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z  + 1.2, 'Appuyez sur ~y~E~s~ pour acceder aux vestiaires')
		      end
        end

        if (Config_prisonfederal.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'prison' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or
		    (Config_prisonfederal.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'prison' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) or 
        (Config_prisonfederal.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'prison' and PlayerData.job.grade_name == 'coboss' and PlayerData.job.service == 1) or
		    (Config_prisonfederal.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'prison' and PlayerData.job2.grade_name == 'coboss' and PlayerData.job2.service == 1) then

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

function prison01()
    if CurrentAction ~= nil then

      if IsControlJustReleased(0, Keys['BACKSPACE']) then
        ESX.UI.Menu.CloseAll()
        CurrentAction = nil
      end
	  
      if (IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'prison' and PlayerData.job.service == 1) or (IsControlPressed(0,  Keys['E']) and PlayerData.job2 ~= nil and PlayerData.job2.name == 'prison' and PlayerData.job2.service == 1) then

        if CurrentAction == 'menu_cloakroom' then
          prison_OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_armory' then
          prison_OpenArmoryMenu(CurrentActionData.station)
        end

        if CurrentAction == 'menu_coffre' then
          prison_OpenCoffreMenu(CurrentActionData.station)
        end

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'prison', function(data, menu)

            menu.close()

            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu'
            CurrentActionData = {}

          end)

        end
        CurrentAction = nil
        GUI.Time      = GetGameTimer()
      end
    end
end

RegisterNetEvent('esx_prisonfederal:openMenuJob')
AddEventHandler('esx_prisonfederal:openMenuJob', function()
	prison_OpenprisonActionsMenu()
end)
