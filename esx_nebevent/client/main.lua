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

function Ftext_esx_nebevent(txt)
	return Config_esx_nebevent.Txt[txt]
end


local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Blips                   = {}

local isInMarker              = false
local isInPublicMarker        = false
local hintIsShowed            = false
local hintToDisplay           = "no hint to display"

function nevent_SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 3,
    modBrakes       = 2,
    modTransmission = 3,
    modSuspension   = 3,
    modTurbo        = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function nevent_IsJobTrue()
    if (PlayerData ~= nil) or (PlayerData ~= nil) then
        local IsJobTrue = false
        if (PlayerData.job ~= nil and PlayerData.job.name == 'nebevent' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'nebevent' and PlayerData.job2.service == 1) then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end

function nevent_IsGradeBoss()
    if PlayerData ~= nil then
        local IsGradeBoss = false
        if (PlayerData.job.grade_name == 'boss') or (PlayerData.job2.grade_name == 'boss') then
            IsGradeBoss = true
        end
        return IsGradeBoss
    end
end

 --Create blips
Citizen.CreateThread(function()

		local blip = AddBlipForCoord(Config_esx_nebevent.Blips.Blip.Pos.x, Config_esx_nebevent.Blips.Blip.Pos.y, Config_esx_nebevent.Blips.Blip.Pos.z)
		  SetBlipSprite (blip, 488)
		  SetBlipDisplay(blip, 4)
		  SetBlipScale  (blip, 0.6)
		  SetBlipAsShortRange(blip, true)
		  SetBlipColour(blip, 9)
		  BeginTextCommandSetBlipName("STRING")
		  AddTextComponentString("Niémen Racing")
		  EndTextCommandSetBlipName(blip)

end)

function nevent_cleanPlayer(fef)
  ClearPedBloodDamage(playerPed)
  ResetPedVisibleDamage(playerPed)
  ClearPedLastWeaponDamage(playerPed)
  ResetPedMovementClipset(playerPed, 0)
end

function nevent_setClipset(peddd, clip)
  RequestAnimSet(clip)
  while not HasAnimSetLoaded(clip) do
    Citizen.Wait(0)
  end
  SetPedMovementClipset(playerPed, clip, true)
end

function nevent_setUniform(job, pedd)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
      if Config_esx_nebevent.Uniforms[job].male ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config_esx_nebevent.Uniforms[job].male)
      else
        ESX.ShowNotification(Ftext_esx_nebevent('no_outfit'))
      end
      if job ~= 'citizen_wear' and job ~= 'nebevent_outfit' then
        nevent_setClipset(playerPed, "MOVE_M@POSH@")
      end
    else
      if Config_esx_nebevent.Uniforms[job].female ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config_esx_nebevent.Uniforms[job].female)
      else
        ESX.ShowNotification(Ftext_esx_nebevent('no_outfit'))
      end
      if job ~= 'citizen_wear' and job ~= 'nebevent_outfit' then
        nevent_setClipset(playerPed, "MOVE_F@POSH@")
      end
    end

  end)
end


function nevent_OpenRoomMenu()

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


function nevent_OpenCloakroomMenu()

  local elements = {
  -- { label = "Civil", value = 'citizen_wear'},
		{ label = "Dressing", value = 'dressing'},
	--	{ label = Ftext_esx_nebevent('nebevent_outfit'),    value = 'nebevent_outfit'},
	--	{ label = Ftext_esx_nebevent('nebevent_outfit_1'),  value = 'nebevent_outfit_1'},
	--	{ label = Ftext_esx_nebevent('nebevent_outfit_2'),  value = 'nebevent_outfit_2'},
--		{ label = Ftext_esx_nebevent('nebevent_outfit_3'),  value = 'nebevent_outfit_3'},
      }

  ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cloakroom',
      {
        title    = Ftext_esx_nebevent('cloakroom'),
        align = 'right',
        elements = elements,
        },

        function(data, menu)

		if data.current.value == 'dressing' then
			nevent_OpenRoomMenu()
		end

        if data.current.value == 'citizen_wear' then
		  TriggerEvent('esx_jobs:SelecJob', 0)
		  TriggerServerEvent("player:serviceOff", "casino")
		
          DeleteBlip()

            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
                ClearPedBloodDamage(playerPed)
                ResetPedVisibleDamage(playerPed)
                ClearPedLastWeaponDamage(playerPed)

                ResetPedMovementClipset(playerPed, 0)

                isBarman = false
            end)
        end
		
		if (data.current.value == 'nebevent_outfit' or
			data.current.value == 'nebevent_outfit_1' and PlayerData.job.grade_name == 'employer' or PlayerData.job.grade_name == 'organisateur' or nevent_IsGradeBoss() or
			data.current.value == 'nebevent_outfit_2' and PlayerData.job.grade_name == 'organisateur' or nevent_IsGradeBoss() or
			data.current.value == 'nebevent_outfit_3' and nevent_IsGradeBoss()) then
			TriggerEvent('esx_jobs:SelecJob', 1)
			nevent_setUniform(data.current.value, playerPed)
		  end
		  
		if (data.current.value == 'nebevent_outfit_1' and PlayerData.job2.grade_name == 'employer' or PlayerData.job2.grade_name == 'organisateur' or nevent_IsGradeBoss() or
			data.current.value == 'nebevent_outfit_2' and PlayerData.job2.grade_name == 'organisateur' or nevent_IsGradeBoss() or
			data.current.value == 'nebevent_outfit_3' and nevent_IsGradeBoss()) then
			TriggerEvent('esx_jobs:SelecJob', 2)
			nevent_setUniform(data.current.value, playerPed)
		end

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = Ftext_esx_nebevent('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = Ftext_esx_nebevent('open_cloackroom')
      CurrentActionData = {}
    end
    )

end

function nevent_OpenCloakroomMenu1()

  local elements = {
	--{ label = "Entreprise",     value = 'entreprise'},
    { label = Ftext_esx_nebevent('citizen_wear'),     value = 'citizen_wear'},
    { label = Ftext_esx_nebevent('nebevent_outfit'),    value = 'nebevent_outfit'},
    { label = Ftext_esx_nebevent('nebevent_outfit_1'),  value = 'nebevent_outfit_1'},
    { label = Ftext_esx_nebevent('nebevent_outfit_2'),  value = 'nebevent_outfit_2'},
    { label = Ftext_esx_nebevent('nebevent_outfit_3'),  value = 'nebevent_outfit_3'},
  }
	
	ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = Ftext_esx_nebevent('cloakroom'),
      align = 'right',
      elements = elements,
    },
    function(data, menu)

      isBarman = false
      nevent_cleanPlayer(playerPed)

	  if data.current.value == 'entreprise' then
		  if PlayerData.job.name ~= nil and PlayerData.job.grade_name == 'boss' then
			local jname = PlayerData.job.name
			TriggerEvent('esx_extendedjob:Entreprise', jname)
		  else
			ESX.ShowNotification("Réserver au patron.")
		  end
	  end
	  
      if data.current.value == 'citizen_wear' then
	    TriggerEvent('esx_jobs:SelecJob', 0)
	  
	    if (PlayerData.job ~= nil and PlayerData.job.name == 'nebevent' and PlayerData.job.service == 1) then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			  TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end
		
		if (PlayerData.job2 ~= nil and PlayerData.job2.name == 'nebevent' and PlayerData.job2.service == 1) then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin2', function(skin)
			  TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end
		
      end

      if (data.current.value == 'nebevent_outfit' or
        data.current.value == 'nebevent_outfit_1' and PlayerData.job.grade_name == 'employer' or PlayerData.job.grade_name == 'organisateur' or nevent_IsGradeBoss() or
        data.current.value == 'nebevent_outfit_2' and PlayerData.job.grade_name == 'organisateur' or nevent_IsGradeBoss() or
        data.current.value == 'nebevent_outfit_3' and nevent_IsGradeBoss()) then
		TriggerEvent('esx_jobs:SelecJob', 1)
        nevent_setUniform(data.current.value, playerPed)
      end
	  
	  if (data.current.value == 'nebevent_outfit_1' and PlayerData.job2.grade_name == 'employer' or PlayerData.job2.grade_name == 'organisateur' or nevent_IsGradeBoss() or
        data.current.value == 'nebevent_outfit_2' and PlayerData.job2.grade_name == 'organisateur' or nevent_IsGradeBoss() or
        data.current.value == 'nebevent_outfit_3' and nevent_IsGradeBoss()) then
		TriggerEvent('esx_jobs:SelecJob', 2)
        nevent_setUniform(data.current.value, playerPed)
      end

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = Ftext_esx_nebevent('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = Ftext_esx_nebevent('open_cloackroom')
      CurrentActionData = {}
    end
  )
end

function nevent_OpenMobileReporterActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_reporter_actions',
    {
      title    = 'Niémen Racing',
	  align = 'right',
      elements = {
--		{label = 'Camera', value = 'cam'},
	--	{label = 'Micro', value = 'mic'},
	--	{label = 'Micro Perche', value = 'bmic'},
		{label = 'Facture', value = 'billing'}
      }
    },
    function(data, menu)

--[[if data.current.value == 'cam' then
		TriggerEvent("Cam:ToggleCam")
	end
	
	if data.current.value == 'mic' then
		TriggerEvent("Mic:ToggleMic")
	end
	
	if data.current.value == 'bmic' then
		TriggerEvent("Mic:ToggleBMic")
	end]]
	
      if data.current.value == 'billing' then

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'billing',
          {
            title = "Montant"
          },
          function(data, menu)

            local amount = tonumber(data.value)

            if amount == nil then
              ESX.ShowNotification("Montant invalide")
            else

              menu.close()

              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification("Aucun joueur à proximité")
              else
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_nebevent', 'nebevent', amount)
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

function nevent_OpenVaultMenu()

  if Config_esx_nebevent.EnableVaultManagement then

    local elements = {
      {label = 'Ouvrir l\'armurerie', value = 'get_weapon'},
			{label = 'Ouvrir le stockage', value = 'get_stock'}
    }
    

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault',
      {
        title    = Ftext_esx_nebevent('vault'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'get_weapon' then
          TriggerEvent('core_inventory:client:openSocietyWeaponsInventory', 'society_nebevent')
          menu.close()
        end
        if data.current.value == 'get_stock' then
          TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_nebevent')
          menu.close()
        end

      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = Ftext_esx_nebevent('open_vault')
        CurrentActionData = {}
      end
    )

  end

end

function nevent_OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_nebevent:getStockItems', function(items)

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
        title    = 'Niémen Racing Stock',
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = Ftext_esx_nebevent('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_nebevent('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              nevent_OpenGetStocksMenu()

              TriggerServerEvent('esx_nebevent:getStockItem', itemName, count)
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

function nevent_OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_nebevent:getPlayerInventory', function(inventory)

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
        title    = Ftext_esx_nebevent('inventory'),
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = Ftext_esx_nebevent('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Ftext_esx_nebevent('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              nevent_OpenPutStocksMenu()

              TriggerServerEvent('esx_nebevent:putStockItems', itemName, count)
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

function nevent_OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_nebevent:getVaultWeapons', function(weapons)

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
      'default', GetCurrentResourceName(), 'vault_get_weapon',
      {
        title    = Ftext_esx_nebevent('get_weapon_menu'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_nebevent:removeVaultWeapon', function()
          nevent_OpenGetWeaponMenu()
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function nevent_OpenPutWeaponMenu()

  local elements   = {}

  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPONFtext_esx_nebeventNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'vault_put_weapon',
    {
      title    = Ftext_esx_nebevent('put_weapon_menu'),
      align = 'right',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_nebevent:addVaultWeapon', function()
        nevent_OpenPutWeaponMenu()
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function nevent_nevent_OpenVehicleSpawnerMenu2()

  local vehicles = Config_esx_nebevent.Zones.Vehicles2

  ESX.UI.Menu.CloseAll()

    local elements = {}

    for i=1, #Config_esx_nebevent.AuthorizedVehicles2, 1 do
      local vehicle = Config_esx_nebevent.AuthorizedVehicles2[i]
      table.insert(elements, {label = vehicle.label, value = vehicle.name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = Ftext_esx_nebevent('vehicle_menu'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        local vehicle = GetClosestVehicle(vehicles.SpawnPoint.x,  vehicles.SpawnPoint.y,  vehicles.SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

			ESX.Game.SpawnVehicle(model, {
				  x = vehicles.SpawnPoint.x,
				  y = vehicles.SpawnPoint.y,
				  z = vehicles.SpawnPoint.z
				}, vehicles.Heading, function(vehicle)
				  local rand = math.random(1000,9999)
				  SetVehicleNumberPlateText(vehicle, "DRIFT0" .. rand)
				  TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				  nevent_SetVehicleMaxMods(vehicle)
				  SetVehicleLivery(vehicle, 0)
				  
				  TriggerEvent('esx_vehiclelock:givekey', "DRIFT0" .. rand)
			end)


        else
          ESX.ShowNotification(Ftext_esx_nebevent('vehicle_out'))
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner2'
        CurrentActionMsg  = Ftext_esx_nebevent('vehicle_spawner')
        CurrentActionData = {}

      end
    )

end


function nevent_OpenVehicleSpawnerMenu()

  local vehicles = Config_esx_nebevent.Zones.Vehicles

  ESX.UI.Menu.CloseAll()

  if Config_esx_nebevent.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

      for i=1, #garageVehicles, 1 do
        table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_spawner',
        {
          title    = Ftext_esx_nebevent('vehicle_menu'),
          align = 'right',
          elements = elements,
        },
        function(data, menu)

          menu.close()

          local vehicleProps = data.current.value
          ESX.Game.SpawnVehicle(vehicleProps.model, vehicles.SpawnPoint, vehicles.Heading, function(vehicle)
              ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
              local rand = math.random(1000,9999)
              SetVehicleNumberPlateText(vehicle, "DRIFT0" .. rand)
			  TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			  SetVehicleLivery(vehicle, 0)
          end)            

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'nebevent', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'menu_vehicle_spawner'
          CurrentActionMsg  = Ftext_esx_nebevent('vehicle_spawner')
          CurrentActionData = {}

        end
      )

    end, 'nebevent')

  else

    local elements = {}

    for i=1, #Config_esx_nebevent.AuthorizedVehicles, 1 do
      local vehicle = Config_esx_nebevent.AuthorizedVehicles[i]
      table.insert(elements, {label = vehicle.label, value = vehicle.name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = Ftext_esx_nebevent('vehicle_menu'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        local vehicle = GetClosestVehicle(vehicles.SpawnPoint.x,  vehicles.SpawnPoint.y,  vehicles.SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

          if Config_esx_nebevent.MaxInService == -1 then

			ESX.Game.SpawnVehicle(model, {
				  x = vehicles.SpawnPoint.x,
				  y = vehicles.SpawnPoint.y,
				  z = vehicles.SpawnPoint.z
				}, vehicles.Heading, function(vehicle)
				  local rand = math.random(1000,9999)
				  SetVehicleNumberPlateText(vehicle, "DRIFT0" .. rand)
				  TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				  nevent_SetVehicleMaxMods(vehicle)
				  --SetVehicleDirtLevel(vehicle, 0)
				  SetVehicleLivery(vehicle, 0)
				  
				  if model == 'speedobox' then
					SetVehicleLivery(vehicle, 3)
				  end
			end)

          else

            ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

              if canTakeService then

                ESX.Game.SpawnVehicle(model, {
                  x = vehicles[partNum].SpawnPoint.x,
                  y = vehicles[partNum].SpawnPoint.y,
                  z = vehicles[partNum].SpawnPoint.z
                }, vehicles[partNum].Heading, function(vehicle)
                  local rand = math.random(1000,9999)
				  SetVehicleNumberPlateText(vehicle, "DRIFT0" .. rand)
				  TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                  nevent_SetVehicleMaxMods(vehicle)
                  --SetVehicleDirtLevel(vehicle, 0)
				  SetVehicleLivery(vehicle, 0)
				  
				  if model == 'speedobox' then
					SetVehicleLivery(vehicle, 3)
				  end
                end)

              else
                ESX.ShowNotification(Ftext_esx_nebevent('service_max') .. inServiceCount .. '/' .. maxInService)
              end

            end, 'etat')

          end

        else
          ESX.ShowNotification(Ftext_esx_nebevent('vehicle_out'))
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = Ftext_esx_nebevent('vehicle_spawner')
        CurrentActionData = {}

      end
    )

  end

end

AddEventHandler('esx_nebevent:hasEnteredMarker', function(zone)
 
    if zone == 'BossActions' and nevent_IsGradeBoss() then
      CurrentAction     = 'menu_boss_actions'
      CurrentActionMsg  = Ftext_esx_nebevent('open_bossmenu')
      CurrentActionData = {}
    end
	
    if zone == 'Cloakrooms' then
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = Ftext_esx_nebevent('open_cloackroom')
      CurrentActionData = {}
    end	

    --[[if zone == 'Vehicles' then
        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = Ftext_esx_nebevent('vehicle_spawner')
        CurrentActionData = {}
    end	
	
	if zone == 'Vehicles2' then
        CurrentAction     = 'menu_vehicle_spawner2'
        CurrentActionMsg  = Ftext_esx_nebevent('vehicle_spawner')
        CurrentActionData = {}
    end	]]
	
    if Config_esx_nebevent.EnableVaultManagement then
      if zone == 'Vaults' then
        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = Ftext_esx_nebevent('open_vault')
        CurrentActionData = {}
      end
    end	

    --[[if zone == 'VehicleDeleters' or zone == 'VehicleDeleters2' then


      if IsPedInAnyVehicle(playerPed,  false) then

        local vehicle = GetVehiclePedIsIn(playerPed,  false)

        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = Ftext_esx_nebevent('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
      end

    end]]
	
end)

AddEventHandler('esx_nebevent:hasExitedMarker', function(zone)
	if CurrentAction ~= nil then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	end
end)

-- Display markers
function nebevent04()
        if nevent_IsJobTrue() then

            

            for k,v in pairs(Config_esx_nebevent.Zones) do
                if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_esx_nebevent.DrawDistance) then
                    DrawMarker(0, v.Pos.x, v.Pos.y, v.Pos.z+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 100, false, false, 2, false, false, false, false)
                end
            end

        end
end

-- Enter / Exit marker events
function nebevent03()
        if nevent_IsJobTrue() then

            
            local isInMarker  = false
            local currentZone = nil

            for k,v in pairs(Config_esx_nebevent.Zones) do
                if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                    isInMarker  = true
                    currentZone = k
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                HasAlreadyEnteredMarker = true
                LastZone                = currentZone
                TriggerEvent('esx_nebevent:hasEnteredMarker', currentZone)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('esx_nebevent:hasExitedMarker', LastZone)
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
function nebevent02()
	if (PlayerData.job ~= nil and PlayerData.job.name == 'nebevent' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'nebevent' and PlayerData.job2.service == 1) then
		
		if GetDistanceBetweenCoords(coords, Config_esx_nebevent.Zones.Cloakrooms.Pos.x, Config_esx_nebevent.Zones.Cloakrooms.Pos.y, Config_esx_nebevent.Zones.Cloakrooms.Pos.z,  true) < 2.0 then
      sleepThread = 20
      DrawText3Ds(Config_esx_nebevent.Zones.Cloakrooms.Pos.x, Config_esx_nebevent.Zones.Cloakrooms.Pos.y, Config_esx_nebevent.Zones.Cloakrooms.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour se changer')
		end
		if GetDistanceBetweenCoords(coords, Config_esx_nebevent.Zones.Vaults.Pos.x, Config_esx_nebevent.Zones.Vaults.Pos.y, Config_esx_nebevent.Zones.Vaults.Pos.z,  true) < 2.0 then
      sleepThread = 20
      DrawText3Ds(Config_esx_nebevent.Zones.Vaults.Pos.x, Config_esx_nebevent.Zones.Vaults.Pos.y, Config_esx_nebevent.Zones.Vaults.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour acceder au coffre')
		end
		--if GetDistanceBetweenCoords(coords, Config_esx_nebevent.Zones.Vehicles.Pos.x, Config_esx_nebevent.Zones.Vehicles.Pos.y, Config_esx_nebevent.Zones.Vehicles.Pos.z,  true) < 2.0 then
			--DrawText3Ds(Config_esx_nebevent.Zones.Vehicles.Pos.x, Config_esx_nebevent.Zones.Vehicles.Pos.y, Config_esx_nebevent.Zones.Vehicles.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour sortir un véhicule')
		--end
		--if GetDistanceBetweenCoords(coords, Config_esx_nebevent.Zones.Vehicles2.Pos.x, Config_esx_nebevent.Zones.Vehicles2.Pos.y, Config_esx_nebevent.Zones.Vehicles2.Pos.z,  true) < 2.0 then
			--DrawText3Ds(Config_esx_nebevent.Zones.Vehicles2.Pos.x, Config_esx_nebevent.Zones.Vehicles2.Pos.y, Config_esx_nebevent.Zones.Vehicles2.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour sortir un véhicule')
		--end
		--if GetDistanceBetweenCoords(coords, Config_esx_nebevent.Zones.VehicleDeleters.Pos.x, Config_esx_nebevent.Zones.VehicleDeleters.Pos.y, Config_esx_nebevent.Zones.VehicleDeleters.Pos.z,  true) < 2.0 then
			--DrawText3Ds(Config_esx_nebevent.Zones.VehicleDeleters.Pos.x, Config_esx_nebevent.Zones.VehicleDeleters.Pos.y, Config_esx_nebevent.Zones.VehicleDeleters.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour ranger le véhicule')
		--end
		--if GetDistanceBetweenCoords(coords, Config_esx_nebevent.Zones.VehicleDeleters2.Pos.x, Config_esx_nebevent.Zones.VehicleDeleters2.Pos.y, Config_esx_nebevent.Zones.VehicleDeleters2.Pos.z,  true) < 2.0 then
			--DrawText3Ds(Config_esx_nebevent.Zones.VehicleDeleters2.Pos.x, Config_esx_nebevent.Zones.VehicleDeleters2.Pos.y, Config_esx_nebevent.Zones.VehicleDeleters2.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour ranger le véhicule')
		--end
		
		if Config_esx_nebevent.EnablePlayerManagement and (PlayerData.job ~= nil and PlayerData.job.name == 'nebevent' and PlayerData.job.grade_name == 'boss' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'nebevent' and PlayerData.job2.grade_name == 'boss' and PlayerData.job2.service == 1) then		
			if GetDistanceBetweenCoords(coords, Config_esx_nebevent.Zones.BossActions.Pos.x, Config_esx_nebevent.Zones.BossActions.Pos.y, Config_esx_nebevent.Zones.BossActions.Pos.z,  true) < 2.0 then
        sleepThread = 20
        DrawText3Ds(Config_esx_nebevent.Zones.BossActions.Pos.x, Config_esx_nebevent.Zones.BossActions.Pos.y, Config_esx_nebevent.Zones.BossActions.Pos.z + 1, 'Appuyez sur ~y~E~s~ pour ouvrir le boss menu')
			end
		end
			
	end
end

-- Key Controls
function nebevent01()
    if CurrentAction ~= nil then

      --SetTextComponentFormat('STRING')
      --AddTextComponentString(CurrentActionMsg)
      --DisplayHelpTextFromStringLabel(0, 0, 1, -1)

	  if IsControlJustReleased(0, Keys['BACKSPACE']) then
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	  end

      if IsControlJustReleased(0,  Keys['E']) and nevent_IsJobTrue() then

        if CurrentAction == 'menu_cloakroom' then
            nevent_OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_vault' then
            nevent_OpenVaultMenu()
        end
		
        --if CurrentAction == 'menu_vehicle_spawner' then
            --nevent_OpenVehicleSpawnerMenu()
        --end
		
		--if CurrentAction == 'menu_vehicle_spawner2' then
            --nevent_nevent_OpenVehicleSpawnerMenu2()
        --end

        --if CurrentAction == 'delete_vehicle' then
          --ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
        --end
		
        if CurrentAction == 'menu_boss_actions' and nevent_IsGradeBoss() then

          local options = {
            wash      = Config_esx_nebevent.EnableMoneyWash,
          }

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'nebevent', function(data, menu)

            menu.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = Ftext_esx_nebevent('open_bossmenu')
            CurrentActionData = {}

          end,options)

        end

        
        CurrentAction = nil

      end

    end

    --if IsControlJustReleased(0,  Keys['F6']) and nevent_IsJobTrue()then
        --nevent_OpenMobileReporterActionsMenu()
    --end
end

RegisterNetEvent('esx_nebevent:openMenuJob')
AddEventHandler('esx_nebevent:openMenuJob', function()
	nevent_OpenMobileReporterActionsMenu()
end)
