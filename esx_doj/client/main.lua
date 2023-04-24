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

function doj_SetVehicleMaxMods(vehicle)

    local props = {
	    modEngine       = 4,
		modBrakes       = 4,
		modTransmission = 4,
		modsuspension   = 3,
		modTurbo        = true,
	}

	ESX.Game.SetVehicleProperties(vehicle, props)

end

function doj_SetWindowTint(vehicle)

    local props = {
      windowTint       = 1,
    }
  
    ESX.Game.SetVehicleProperties(vehicle, props)
  
  end

function doj_OpenRoomMenu()

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

function doj_OpenCloakroomMenu()

  local elements = {
    {label = "Dressing", value = 'dressing'},
    { label = 'tenue Civil', value = 'citizen_wear' }
  }

  table.insert(elements, {label = 'tenue', value = 'agent_wear'})

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = 'vestiaire',
      align = 'right',
      elements = elements,
    },
    function(data, menu)
      menu.close()

      if data.current.value == 'dressing' then
        doj_OpenRoomMenu()
      end

      if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          local model = nil

          if skin.sex == 0 then
            model = GetHashKey("mp_m_freemode_01")
          else
            model = GetHashKey("mp_f_freemode_01")
          end

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(1)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')

          SetPedArmour(playerPed, 0)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      if data.current.value == 'agent_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

            if skin.sex == 0 then

                local clothesSkin = {
                  ['tshirt_1'] = 13, ['tshirt_2'] = 0,
                  ['torso_1'] = 27, ['torso_2'] = 0,
                  ['decals_1'] = 0, ['decals_2'] = 0,
                  ['arms'] = 4,
                  ['pants_1'] = 10, ['pants_2'] = 0,
                  ['shoes_1'] = 10, ['shoes_2'] = 0,
                  ['helmet_1'] = -1, ['helmet_2'] = 0,
                  ['chain_1'] = 24, ['chain_2'] = 2,
                  ['ears_1'] = 2, ['ears_2'] = 0
                  }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                  ['tshirt_1'] = 39, ['tshirt_2'] = 0,
                  ['torso_1'] = 6, ['torso_2'] = 4,
                  ['decals_1'] = 8, ['decals_2'] = 3,
                  ['arms'] = 5,
                  ['pants_1'] = 36, ['pants_2'] = 2,
                  ['shoes_1'] = 8, ['shoes_2'] = 0,
                  ['helmet_1'] = -1, ['helmet_2'] = 0,
                  ['chain_1'] = 0, ['chain_2'] = 0,
                  ['ears_1'] = 2, ['ears_2'] = 0
              }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)

        end)
      end

      if data.current.value == 'doj_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

            if skin.sex == 0 then

                local clothesSkin = {
                    ['tshirt_1'] = 58, ['tshirt_2'] = 0,
                    ['torso_1'] = 55, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 41,
                    ['pants_1'] = 25, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                    ['tshirt_1'] = 35, ['tshirt_2'] = 0,
                    ['torso_1'] = 48, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 44,
                    ['pants_1'] = 34, ['pants_2'] = 0,
                    ['shoes_1'] = 27, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)

        end)
      end

      if data.current.value == 'doj_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

            if skin.sex == 0 then

                local clothesSkin = {
                    ['tshirt_1'] = 58, ['tshirt_2'] = 0,
                    ['torso_1'] = 55, ['torso_2'] = 0,
                    ['decals_1'] = 8, ['decals_2'] = 2,
                    ['arms'] = 41,
                    ['pants_1'] = 25, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                    ['tshirt_1'] = 35, ['tshirt_2'] = 0,
                    ['torso_1'] = 48, ['torso_2'] = 0,
                    ['decals_1'] = 7, ['decals_2'] = 2,
                    ['arms'] = 44,
                    ['pants_1'] = 34, ['pants_2'] = 0,
                    ['shoes_1'] = 27, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)

        end)
      end

      if data.current.value == 'patron_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

            if skin.sex == 0 then

                local clothesSkin = {
                    ['tshirt_1'] = 11, ['tshirt_2'] = 0,
                    ['torso_1'] = 28, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 4,
                    ['pants_1'] = 37, ['pants_2'] = 2,
                    ['shoes_1'] = 10, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                  ['tshirt_1'] = 39, ['tshirt_2'] = 0,
                  ['torso_1'] = 6, ['torso_2'] = 4,
                  ['decals_1'] = 8, ['decals_2'] = 3,
                  ['arms'] = 5,
                  ['pants_1'] = 36, ['pants_2'] = 2,
                  ['shoes_1'] = 8, ['shoes_2'] = 0,
                  ['helmet_1'] = -1, ['helmet_2'] = 0,
                  ['chain_1'] = 0, ['chain_2'] = 0,
                  ['ears_1'] = 2, ['ears_2'] = 0
              }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)

        end)
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

Citizen.CreateThread(function()
    local hash = GetHashKey("csb_cop")

    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end

    ped = CreatePed("PED_TYPE_CIVMALE", "csb_cop",-535.47,-188.72,41.85, 117.03, false, true) -- Position du ped

    SetBlockingOfNonTemporaryEvents(ped, true) -- Fait en sorte que le ped ne réagisse à rien (n'aura pas peur si il y a des tirs etc...)
    FreezeEntityPosition(ped, true) -- Freeze le ped
    SetEntityInvincible(ped, true) -- Le rend invincible
	SetModelAsNoLongerNeeded(hash)
end)



function doj_OpenArmoryMenu(station)

    if Config_esx_doj.EnableArmoryManagement then

	    local elements = {
			{label = 'Ouvrir l\'armurerie', value = 'get_weapon'},
			{label = 'Ouvrir le stockage', value = 'get_stock'}
		}

		if PlayerData.job.grade_name == 'boss' then
		    table.insert(elements, {label = 'acheter Armes', value = 'buy_weapons'})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'armory',
			{
			    title    = 'armurerie',
				align = 'right',
				elements = elements,
			},
			function(data, menu)    

				if data.current.value == 'buy_weapons' then
				    doj_OpenBuyWeaponsMenu(station)
				end

			    if data.current.value == 'get_weapon' then
					TriggerEvent('core_inventory:client:openSocietyWeaponsInventory', 'society_doj')
					menu.close()
				end
				
				if data.current.value == 'get_stock' then
					TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_doj')
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

	else

	    local elements = {}

		for i=1, #Config_esx_doj.dojStations[station].AuthorizedWeapons, 1 do
		    local weapon = Config_esx_doj.dojStations[station].AuthorizedWeapons[i]
			table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'armory',
			{
			    title    = 'armurerie',
				align = 'right',
				elements = elements,
			},
			function(data, menu)
			    local weapon = data.current.value
				TriggerServerEvent('esx_doj:giveWeapon', weapon, 1000)
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

function doj_OpenVehicleSpawnerMenu(station, partNum)

    local vehicles = Config_esx_doj.dojStations[station].Vehicles

	ESX.UI.Menu.CloseAll()

	if Config_esx_doj.EnableSocietyOwnedVehicles then

	    local elements = {}

		ESX.TriggerServerCallback('esx_doj:getVehiclesInGarage', function(garageVehicles)

		    for i=1, #garageVehicles, 1 do
			    table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
			end

			ESX.UI.Menu.Open(
			    'default', GetCurrentResourceName(), 'vehicle_spawner',
				{
				    title    = 'véhicule',
					align = 'right',
					elements = elements,
				},
				function(data, menu)

				    menu.close()

					local vehicleProps = data.current.value

					ESX.Game.SpawnVehicle(vehicleProps.model, vehicles[partNum].SpawnPoint, 270.0, function(vehicle)
					    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
						TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
					end)

					TriggerServerEvent('esx_society:removeVehicleFromGarage', 'doj', vehicleProps)

				end,
				function(data, menu)

				    menu.close()

					CurrentAction     = 'menu_vehicle_spawner'
					CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule'
					CurrentActionData = {station = station, partNum = partNum}

				end
			)

		end, 'doj')

	else

	    local elements = {}

            table.insert(elements, { label = 'Granger', value = 'granger'})
            table.insert(elements, { label = 'Cognoscenti', value = 'cognoscenti'})
            table.insert(elements, { label = 'Blindé', value = 'XLS2'})
            table.insert(elements, { label = 'Limousine', value = 'stretch'})

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'vehicle_spawner',
			{
			    title    = 'véhicule',
				align = 'right',
				elements = elements,
			},
			function(data, menu)

			    menu.close()

				local model = data.current.value

				local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x, vehicles[partNum].SpawnPoint.y, vehicles[partNum].SpawnPoint.z, 3.0, 0, 71)

				if not DoesEntityExist(vehicle) then

					if Config_esx_doj.MaxInService == -1 then

					    ESX.Game.SpawnVehicle(model, {
						    x = vehicles[partNum].SpawnPoint.x,
							y = vehicles[partNum].SpawnPoint.y,
							z = vehicles[partNum].SpawnPoint.z
						}, vehicles[partNum].Heading, function(vehicle)
						    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                            doj_SetVehicleMaxMods(vehicle)
                            doj_SetWindowTint(vehicle)
                            local rand = math.random(10,99)
			                SetVehicleNumberPlateText(vehicle, "doj" .. rand)
							
							TriggerEvent('esx_vehiclelock:givekey', "doj" .. rand)
						end)

					else

					    ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

						    if canTakeService then

							    ESX.Game.SpawnVehicle(model, {
								    x = vehicles[partNum].SpawnPoint.x,
									y = vehicles[partNum].SpawnPoint.y,
									z = vehicles[partNum].SpawnPoint.z
								}, vehicles[partNum].Heading, function(vehicle)
								    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                    doj_SetVehicleMaxMods(vehicle)
                                    doj_SetWindowTint(vehicle)
                                    local rand = math.random(10,99)
			                        SetVehicleNumberPlateText(vehicle, "doj" .. rand)
									
									TriggerEvent('esx_vehiclelock:givekey', "doj" .. rand)
								end)

							else
							    ESX.ShowNotification('Service complet : ' .. inServiceCount .. '/' .. maxInService)
							end

						end, 'doj')

					end

				else
				    ESX.ShowNotification('il y a déja un véhicule de sorti')
				end

			end,
			function(data, menu)

			    menu.close()

				CurrentAction     = 'menu_vehicle_spawner'
				CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule'
				CurrentActionData = {station = station, partNum = partNum}

			end
		)

	end

end

function doj_OpenIdentityCardMenu(player)

    if Config_esx_doj.EnableESXIdentity then

	    ESX.TriggerServerCallback('esx_doj:getOtherPlayerData', function(data)

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
			    {label = 'nom : ' .. data.firstname .. " " .. data.lastname, value = nil},
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
				    title     = 'interaction citoyen',
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

	    ESX.TriggerServerCallback('esx_doj:getOtherPlayerData', function(data)

		    local jobLabel = nil

			if data.job.grade_label ~= nil and data.job.grade_label ~= '' then
	            jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
			else
			    jobLabel = 'Job : ' .. data.job.label
			end

                local elements = {
                    {label = 'nom : ' .. data.name, value = nil},
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
				    title    = 'interaction citoyen',
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

--function doj_OpenFineMenu(player)

   -- ESX.UI.Menu.Open(
	    --'default', GetCurrentResourceName(), 'persofine',
		--{
		    --title    = 'Paiement diverse',
			--align = 'right',
			--elements = {
			    --{label = 'paiment : ', value = 0}
			--},
		--},
		--function(data, menu)

		    --OpenFineCategoryMenu(player, data.current.value)

		--end,
		--function(data, menu)
		    --menu.close()
		--end
	--)

--

function doj_OpenAccessoiresMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'Accessoires_menu',
    {
      title    = "Accessoires",
      align = 'right',
      elements = {
    {label = "Mettre gilet pare-balles", value = 'gilet1_put'},
		{label = "Mettre oreillette", value = 'Oreillette_put'},
		{label = "Mettre pin's", value = 'pins_put'},
    {label = "Mettre bonnet", value = 'Bonnet_put'},
    {label = "Mettre gants", value = 'gants_put'},
    {label = 'Mettre masque', value = 'Masque_put'},
    {label = 'Retirer gilet pare-balle', value = 'gilet_remove'},
    {label = "Retirer bonnet", value = 'Casque_remove'},
    {label = "Retirer gants", value = 'gants_remove'},
		{label = "Retirer pin's", value = 'pins_remove'},
    {label = 'Retirer masque, oreillette', value = 'Masque_remove'},
      },
    },
    function(data, menu)

	if data.current.value == 'gilet1_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
          ['bproof_1'] = 6, ['bproof_2'] = 1
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
          ['bproof_1'] = 6, ['bproof_2'] = 1
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

  if data.current.value == 'pins_put' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then
				local clothesSkin = {
					['chain_1'] = 13, ['chain_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else
				local clothesSkin = {
					['chain_1'] = 7, ['chain_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end	
		end)
	end

  if data.current.value == 'pins_remove' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then

				local clothesSkin = {
					['chain_1'] = -1, ['chain_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else

				local clothesSkin = {
					['chain_1'] = -1, ['chain_2'] = 0
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

function doj_OpendojActionsMenu()

  ESX.UI.Menu.CloseAll()

  local elements = {}

  table.insert(elements, {label = "------JUGES---------", value = ''})
  table.insert(elements, {label = "Amender un citoyen", value = 'persofine'})
  table.insert(elements, {label = "-----SECURITY-------", value = ''})
  table.insert(elements, {label = "Accessoires", value = 'accessoires'})
  table.insert(elements, {label = "Fouiller un citoyen", value = 'body_search'})
  table.insert(elements, {label = "Menotter un citoyen", value = 'handcuff'})
  table.insert(elements, {label = "Escorter un citoyen", value = 'drag'})

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'doj_actions',
    {
      title    = 'Department of Justice',
      align = 'right',
      elements = elements
    },
    function(data, menu)

      if data.current.value == 'accessoires' then
        doj_OpenAccessoiresMenu()
        return
      end

      local player, distance = ESX.Game.GetClosestPlayer()
      if distance ~= -1 and distance <= 3.0 then

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
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_doj', 'Department of Justice', amount)

              end
            end,
            function(data, menu)
              menu.close()
            end 
          )

        end

        if data.current.value == 'body_search' then
			TriggerServerEvent('core_inventory:custom:searchPlayer', GetPlayerServerId(player))
			-- TriggerServerEvent('core_inventory:server:openInventory', GetPlayerServerId(player), 'otherplayer')
			TriggerServerEvent('esx_policejob:fouiller', GetPlayerServerId(player))
        end

        if data.current.value == 'handcuff' then
          TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(player))
        end

        if data.current.value == 'drag' then
          TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(player))
        end
      else
        ESX.ShowNotification("Il n'y a personne à proximité.")
      end

    end,
    function(data, menu)
      menu.close()
    end
  )

end


function doj_OpenGetWeaponMenu()

    ESX.TriggerServerCallback('esx_doj:getArmoryWeapons', function(weapons)

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
			    title    = 'armurerie - Prendre Arme',
				align = 'right',
				elements = elements,
			},
			function(data, menu)

			    menu.close()

				ESX.TriggerServerCallback('esx_doj:removeArmoryWeapon', function()
				    doj_OpenGetWeaponMenu()
				end, data.current.value)

			end,
			function(data, menu)
			    menu.close()
			end
		)

	end)

end

function doj_OpenPutWeaponMenu()

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
		    title    = 'armurerie - Déposer Arme',
			align = 'right',
			elements = elements,
		},
		function(data, menu)

		    menu.close()

			ESX.TriggerServerCallback('esx_doj:addArmoryWeapon', function()
			    doj_OpenPutWeaponMenu()
			end, data.current.value)

		end,
		function(data, menu)
		    menu.close()
		end
	)

end

function doj_OpenBuyWeaponsMenu(station)

    ESX.TriggerServerCallback('esx_doj:getArmoryWeapons', function(weapons)

	    local elements = {}

		for i=1, #Config_esx_doj.dojStations[station].AuthorizedWeapons, 1 do

		    local weapon = Config_esx_doj.dojStations[station].AuthorizedWeapons[i]
			local count  = 0

			for i=1, #weapons, 1 do
			    if weapons[i].name == weapon.name then
				    count = weapons[i].count
					break
				end
			end

			table.insert(elements, {label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})
		end

		ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'armory_buy_weapons',
            {
                title    = 'armurerie - Acheter Armes',
                align = 'right',
                elements = elements,
            },
            function(data, menu)

                ESX.TriggerServerCallback('esx_doj:buy', function(hasEnoughMoney)

                    if hasEnoughMoney then
                        ESX.TriggerServerCallback('esx_doj:addArmoryWeapon', function()
                            doj_OpenBuyWeaponsMenu(station)
                        end, data.current.value)
                    else
                        ESX.ShowNotification('vous n\'avez pas assez d\'argent')
                    end

                end, data.current.price)

            end,
            function(data, menu)
                menu.close()
            end
        )

    end)

end

function doj_OpenGetStockMenu()

    ESX.TriggerServerCallback('esx_doj:getStockItems', function(items)

        print(json.encode(items))

        local elements = {}

        for i=1, #items,1 do
            table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
		end

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'stocks_menu',
			{
			    title    = 'doj_stock',
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
						    ESX.ShowNotification('Quantité invalide')
						else
						    menu2.close()
							menu.close()
							doj_OpenGetStockMenu()

							TriggerServerEvent('esx_doj:getStockItem', itemName, count)
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

function doj_OpenPutStockMenu()

    ESX.TriggerServerCallback('esx_doj:getPlayerInventory', function(inventory)

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
						    ESX.ShowNotification('Quantité invalide')
						else
						    menu2.close()
							menu.close()
							doj_OpenPutStockMenu()

							TriggerServerEvent('esx_doj:putStockItems', itemName, count)
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
		  name       = 'doj',
		  number     = 'doj',
        base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAB8SURBVEhLYxgFo2AUjIKRABihNBHgjYwKhCHy5A6EQQxggtI0A6RZsPzrJyAJ9woxgFgLIIbmvn8F4RIPBkcQcTAi0gIkhokPJaJSEVbjiExLNA8iwuCguCzQB8ieiOHmQxPBAwj7QJuVHUgiB8gScGIdBaNgFAwWwMAAAJCkGvcXbMRGAAAAAElFTkSuQmCC'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('esx_doj:hasEnteredMarker', function(station, part, partNum)

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

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu'
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_doj:hasExitedMarker', function(station, part, partNum)
    if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	end
end)

function doj04()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'doj' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'doj' and PlayerData.job2.service == 1) then
	  
      for k,v in pairs(Config_esx_doj.dojStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config_esx_doj.DrawDistance then
            DrawMarker(0, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_esx_doj.MarkerColor.r, Config_esx_doj.MarkerColor.g, Config_esx_doj.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config_esx_doj.DrawDistance then
            DrawMarker(0, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_esx_doj.MarkerColor.r, Config_esx_doj.MarkerColor.g, Config_esx_doj.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        if (Config_esx_doj.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'doj' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or
		(Config_esx_doj.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'doj' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then

          for i=1, #v.BossActions, 1 do
            if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config_esx_doj.DrawDistance then
              DrawMarker(0, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, Config_esx_doj.MarkerColor.r, Config_esx_doj.MarkerColor.g, Config_esx_doj.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end
          end

        end

      end

    end
end

function doj03()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'doj' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'doj' and PlayerData.job2.service == 1) then

      
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config_esx_doj.dojStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config_esx_doj.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Cloakroom'
            currentPartNum = i
          end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config_esx_doj.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Armory'
            currentPartNum = i
          end
        end

        if (Config_esx_doj.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'doj' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or 
		(Config_esx_doj.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'doj' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then

          for i=1, #v.BossActions, 1 do
            if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config_esx_doj.MarkerSize.x then
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
          TriggerEvent('esx_doj:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_doj:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_doj:hasExitedMarker', LastStation, LastPart, LastPartNum)
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

function doj02()
    if (PlayerData.job ~= nil and PlayerData.job.name == 'doj' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'doj' and PlayerData.job2.service == 1) then
	  
      for k,v in pairs(Config_esx_doj.dojStations) do

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < 2.0 then
            sleepThread = 20
            DrawText3Ds(v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z  + 1.2, 'Appuyez sur ~y~E~s~ pour acceder au stocks')
		      end
        end

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < 2.0 then
            sleepThread = 20
            DrawText3Ds(v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z  + 1.2, 'Appuyez sur ~y~E~s~ pour acceder au vestiaire')
		      end
        end

        if (Config_esx_doj.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'doj' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or
		(Config_esx_doj.EnablePlayerManagement and PlayerData.job2 ~= nil and PlayerData.job2.name == 'doj' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then

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

function doj01()
    if CurrentAction ~= nil then

      if IsControlJustReleased(0, Keys['BACKSPACE']) then
		    ESX.UI.Menu.CloseAll()
		    CurrentAction = nil
	    end
	  
      if (IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'doj' and PlayerData.job.service == 1) or (IsControlPressed(0,  Keys['E']) and PlayerData.job2 ~= nil and PlayerData.job2.name == 'doj' and PlayerData.job2.service == 1) then

        if CurrentAction == 'menu_cloakroom' then
          doj_OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_armory' then
          doj_OpenArmoryMenu(CurrentActionData.station)
        end

        if CurrentAction == 'menu_boss_actions' then
          ESX.UI.Menu.CloseAll()
            TriggerEvent('esx_society:openBossMenu', 'doj', function(data, menu)
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

RegisterNetEvent('esx_doj:openMenuJob')
AddEventHandler('esx_doj:openMenuJob', function()
	doj_OpendojActionsMenu()
end)
