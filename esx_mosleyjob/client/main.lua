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

local GUI = {}
GUI.Time = 0

local Blips                   = {}
local NPCOnJob                = false
local NPCTargetTowable        = nil
local NPCTargetTowableZone    = nil
local NPCHasSpawnedTowable    = false
local NPCLastCancel           = GetGameTimer() - 5 * 60000
local NPCHasBeenNextToTowable = false
local NPCTargetDeleterZone    = false
local CurrentlyTowedVehicle   = nil
local blipDelivery = nil

local isInSellMarker = false
local isInSellMarker2 = false
local isInGarageMarker = false
local isInSellVehMarker = false
local isInInoPriceMarker = false
local isInmosley_StealVehMarker = false
local isInRoomMarker = false
local isInVaultMarker = false
local isInBossMarker = false
local isInSpawnVehMarker = false
local isInDelVehMarker = false
local CanAskForNewJob = true
local WaitingForLimitationReach = false

local isInInfoEngineMarker = false
local isInResellMarker = false

local hName = "flatbed"
local cPay = 1500

TriggerEvent('esx_society:registerSociety', 'flywheels', 'flywheels', 'society_flywheels', 'society_flywheels', 'society_flywheels', {type = 'private'})

function mosley_OpenGiveKeys()

  ESX.UI.Menu.CloseAll()

  local elements = {}

  table.insert(elements, {label = "Personel", value = 'perso'})
  table.insert(elements, {label = "Entreprise", value = 'entreprise'})

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mosley_auto442',
    {
      title    = "Mosley AutoShop",
      align = 'right',
      elements = elements,
    },
    function(data, menu)

      if data.current.value == 'perso' then
		mosley_OpenMenu()
      end
	  if data.current.value == 'entreprise' then
		mosley_mosley_OpenMenu22()
      end

    end,
    function(data, menu)

      menu.close()

    end
  )

end

function mosley_SelectJob(job)

	ESX.UI.Menu.CloseAll()

	local elements2 = {}
	local elements = {}
	table.insert(elements, {label = 'Employé', value = 0})
	table.insert(elements, {label = 'Chef D\'equipe', value = 1})
	table.insert(elements, {label = 'Responsable', value = 2})
	table.insert(elements, {label = 'Virer l\'employé', value = 3})
	
	ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'flygrade',
			{
				title    = "Menu grade",
				align = 'right',
				elements = elements
			},
			function(data, menu)
			
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 3.0 then
					if job == 1 then
						if data.current.value == 3 then
							TriggerServerEvent('esx_flywheels:ChangeJob', GetPlayerServerId(player), "unemployed", 0)
						else
							TriggerServerEvent('esx_flywheels:ChangeJob', GetPlayerServerId(player), "flywheels", data.current.value)
						end
					end
					if job == 2 then
						if data.current.value == 3 then
							TriggerServerEvent('esx_flywheels:ChangeJob2', GetPlayerServerId(player), "unemployed2", 0)
						else
							TriggerServerEvent('esx_flywheels:ChangeJob2', GetPlayerServerId(player), "flywheels", data.current.value)
						end
					end
				else
					ESX.ShowNotification("Aucun joueur a proximité !")
				end
				menu.close()
			end,
			function(data, menu)
				menu.close()
			end
		)
end

function mosley_GradeMenu()

	local elements2 = {}
	local elements = {}
	table.insert(elements, {label = 'Job #1', value = 'job1'})
	table.insert(elements, {label = 'Job #2', value = 'job2'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'job12',
		{
			title    = "Selectionner le job 1 ou 2.",
			align = 'right',
			elements = elements
		},
			function(data, menu)
			
			if data.current.value == "job1" then
				mosley_SelectJob(1)
			end
			
			if data.current.value == "job2" then
				mosley_SelectJob(2)
			end
				
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function mosley_OpenAllMenu()

  ESX.UI.Menu.CloseAll()

  local elements = {}

    --table.insert(elements, {label = "Info Prix", value = 'prix'})
	if PlayerData.job.grade >= 0 then
    	table.insert(elements, {label = "Donner vehicule", value = 'giveveh'})
	end
	
	table.insert(elements, {label = "Coffre Entreprise", value = 'empl_confirmed'})
	
	if PlayerData.job.grade >= 2 then
		table.insert(elements, {label = "Espace Responsable", value = 'gradeup'})
	end
	
	if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'coboss' then
		table.insert(elements, {label = "Gestion Entreprise", value = 'boss'})
	end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mosley_auto',
    {
      title    = "Mosley AutoShop",
      align = 'right',
      elements = elements,
    },
    function(data, menu)

	  if data.current.value == 'gradeup' then
		mosley_GradeMenu()
	  end

	  if data.current.value == 'empl_confirmed' then
		mosley_OpenVaultMenu2()
	  end

      if data.current.value == 'prix' then
		TriggerEvent('esx_flywheels:OpenInfoVeh')
      end

	  if data.current.value == 'giveveh' then
		mosley_OpenMenu()-- vendre le vehicule a un joueur
      end

	  if data.current.value == 'boss' then
		TriggerEvent('esx_extendedjob:EntrepriseV', 'flywheels')
      end
        

    end,
    function(data, menu)

      menu.close()

    end
  )

end

function mosley_mosley_OpenMenu22()

  ESX.UI.Menu.CloseAll()
	
  local elements = {}
  local elements2 = {}
  
	ESX.TriggerServerCallback('esx_flywheels:getVeh', function(vehicles)
		for _,v in pairs(vehicles) do
			local hashVehicule = v.vehicle.model
    		local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
    		local labelvehicle
    		labelvehicle = '<span style="color:orange;">' .. vehicleName .. ' <span style="color:yellow;">' .. v.plate
			table.insert(elements, {label =labelvehicle , value = v})
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'flywheelsjob25',
		{
			title = 'Dispo au [Mosley AutoShop]',
			align = 'right',
			elements = elements,
		},
		
    function(data, menu)
	  
	  ESX.TriggerServerCallback('esx_flywheels:getJobs', function(jobz)
	   for _,j in pairs(jobz) do
		table.insert(elements2, {label = j.label, value = j.name})
	   end
	  
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'flywheels_sell54', {
          title    = "A qui voulez vous donné ce véhicule ?",
          align = 'right',
          elements = elements2,
        }, 
        function(data2, menu2)

            TriggerServerEvent('esx_flywheels:sell_entreprise', data.current.value.plate, data2.current.value)
            ESX.ShowNotification("Vous avez donné votre véhicule ~o~" .. data.current.value.plate .. "~n~~s~à l'entreprise ~p~" .. data2.current.name)
			TriggerServerEvent('CoreLog:SendDiscordLog', "Mosley - Vente Véhicules", "**" .. GetPlayerName(PlayerId()) .. "** a donné les clé du véhicule **`"..data.current.value.plate.."`** a l'entreprise `"..data2.current.name.."`", "Purple")
            ESX.UI.Menu.CloseAll()
    
          menu2.close()
        end, function(data2, menu2)
          menu2.close()
        end)
		
	  end)

      
		end,
		function(data, menu)
			menu.close()
		end
	)	
	end)
end
     
function mosley_OpenMenu()

  ESX.UI.Menu.CloseAll()
	
  local elements = {}
  local elements2 = {}

	ESX.TriggerServerCallback('esx_flywheels:getVeh', function(vehicles)
		for _,v in pairs(vehicles) do
			local hashVehicule = v.vehicle.model
    		local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
    		local labelvehicle
    		labelvehicle = '<span style="color:green;">' .. vehicleName .. ' <span style="color:yellow;">' .. v.plate
			table.insert(elements, {label =labelvehicle , value = v})
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'flywheelsjob',
		{
			title = 'Dispo au [Mosley AutoShop]',
			align = 'right',
			elements = elements,
		},
	function(data, menu)
		
		local elements2 = {}
		ESX.TriggerServerCallback('esx_jobcounter:returnTableMetier',function(valid)
			for k, v in pairs(valid) do
				--print(v.firstname .. " " .. v.lastname .. v.id)
				table.insert(elements2, {label = v.firstname .. " " .. v.lastname, name = v.firstname, value = v.id})
			end

			local function cmp(a, b)
				a = tostring(a.name)
				b = tostring(b.name)
				local patt = '^(.-)%s*(%d+)$'
				local _,_, col1, num1 = a:find(patt)
				local _,_, col2, num2 = b:find(patt)
				if (col1 and col2) and col1 == col2 then
				return tonumber(num1) < tonumber(num2)
				end
				return a < b
			end

			table.sort(elements2, cmp)

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'flywheels_sell', {
				title    = "A qui voulez vous donné ce véhicule ?",
				align = 'right',
				elements = elements2,
			  }, 
			  function(data2, menu2)
	  
				if data2.current.name ~= nil and data2.current.value ~= nil and data2.current.value ~= "**Invalid**" then
				  TriggerServerEvent('esx_flywheels:sell', data.current.value.plate, data2.current.value)
				  ESX.ShowNotification("Vous avez donné votre véhicule ~o~" .. data.current.value.plate .. "~n~~s~à ~p~" .. data2.current.label)
				  TriggerServerEvent('CoreLog:SendDiscordLog', "Mosley - Vente Véhicules", "**" .. GetPlayerName(PlayerId()) .. "** a donné les clé du véhicule **`"..data.current.value.plate.."`** a `"..data2.current.label.."`", "Grey")
				  ESX.UI.Menu.CloseAll()
				end
		  
				menu2.close()
			  end, function(data2, menu2)
				menu2.close()
			  end)
				
		end, "tabName", "players")
	

      
		end,
		function(data, menu)
			menu.close()
		end
	)	
	end)
end

function mosley_mosley_OpenMenu2()

  ESX.UI.Menu.CloseAll()
	
  local elements = {}
  local elements2 = {}

	ESX.TriggerServerCallback('esx_flywheels:getVehicles', function(vehicles)
		for _,v in pairs(vehicles) do
			local hashVehicule = v.vehicle.model
    		local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
    		local labelvehicle
    		labelvehicle = '<span style="color:green;">' .. vehicleName .. ' <span style="color:yellow;">' .. v.plate
			table.insert(elements, {label =labelvehicle , value = v})
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'flywheelsjob2',
		{
			title = 'Mosley AutoShop',
			align = 'right',
			elements = elements,
		},
		function(data, menu)
		  
			menu.close()
			table.insert(elements2, {label = "Non, je ne veux pas donner mon véhicule." , value = "non"})
			table.insert(elements2, {label = "Oui, je veux donner mon véhicule." , value = "oui"})

		  
			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'flywheelsjob12',
				{
					title = 'Etes-vous sûr de donner ce vehicule au mosley autoshop?',
					align = 'right',
					elements = elements2,
				},
				function(data2, menu2)
				  
				  if data2.current.value == "oui" then
					TriggerServerEvent('esx_flywheels:flywheels', data.current.value.plate)
					ESX.ShowNotification("Vous avez vendu votre véhicule au mosley ~o~" .. data.current.value.plate)
					TriggerServerEvent('CoreLog:SendDiscordLog', "Mosley - Vente Véhicules", "**" .. GetPlayerName(PlayerId()) .. "** a vendu/donné son véhicule au Mosley **`"..data.current.value.plate.."`", "Red")
					ESX.UI.Menu.CloseAll()
				  end
				  ESX.UI.Menu.CloseAll()
				  
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

local function InteractSound(distance, sound, volume)
	local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), distance)

	for i=1, #players, 1 do
		TriggerServerEvent('InteractSound_SV:PlayOnOne', GetPlayerServerId(players[i]), sound, volume)
	end
end

function mosley_OpenGetStocksMenu2()

  ESX.TriggerServerCallback('esx_flywheels:getStockItems2', function(items)

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
      'default', GetCurrentResourceName(), 'stocks_menu2',
      {
        title    = 'Mosley Stock',
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count2',
          {
            title = 'Quantité'
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification('Quantité invalide!')
            else
              menu2.close()
              menu.close()
              mosley_OpenGetStocksMenu2()
              TriggerServerEvent('esx_flywheels:getStockItem2', itemName, count)
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


function mosley_OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_flywheels:getStockItems', function(items)

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
        title    = 'Mosley Stock',
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
              ESX.ShowNotification('Quantité invalide!')
            else
              menu2.close()
              menu.close()
              mosley_OpenGetStocksMenu()
              TriggerServerEvent('esx_flywheels:getStockItem', itemName, count)
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

function mosley_OpenPutStocksMenu2()

ESX.TriggerServerCallback('esx_flywheels:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu2',
      {
        title    = 'Inventaire',
		align = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count2',
          {
            title = 'Quantité'
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification('Quantité invalide!')
            else
              menu2.close()
              menu.close()
              mosley_OpenPutStocksMenu2()
              TriggerServerEvent('esx_flywheels:putStockItems2', itemName, count)
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


function mosley_OpenPutStocksMenu()

ESX.TriggerServerCallback('esx_flywheels:getPlayerInventory', function(inventory)

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
        title    = 'Inventaire',
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
              ESX.ShowNotification('Quantité invalide!')
            else
              menu2.close()
              menu.close()
              mosley_OpenPutStocksMenu()
              TriggerServerEvent('esx_flywheels:putStockItems', itemName, count)
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

function mosley_OpenRoomMenu()

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

function mosley_OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_flywheels:getVaultWeapons', function(weapons)

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
        title    = 'get_weapon_menu',
        align = 'right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_flywheels:removeVaultWeapon', function()
		  mosley_OpenGetWeaponMenu()
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function mosley_OpenPutWeaponMenu()

  local elements   = {}

  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'vault_put_weapon',
    {
      title    = 'put_weapon_menu',
      align = 'right',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_flywheels:addVaultWeapon', function()
		mosley_OpenPutWeaponMenu()
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function mosley_OpenVaultMenu2()

	local elements = {
		{label = 'Ouvrir l\'armurerie', value = 'get_weapon'},
		{label = 'Ouvrir le stockage', value = 'get_stock'}
	}
	
	if PlayerData.job.grade >= 2 then
		table.insert(elements, {label = "Retirer Argent", value = 'get_money'})
		table.insert(elements, {label = "Déposer Argent", value = 'put_money'})	
	end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault',
      {
        title    = "flywheels Coffre",
        align = 'right',
        elements = elements,
      },
      function(data, menu)


		if data.current.value == 'get_weapon' then
			TriggerEvent('core_inventory:client:openSocietyWeaponsInventory', 'society_flywheels')
			menu.close()
		  end
		  if data.current.value == 'get_stock' then
			TriggerEvent('core_inventory:client:openSocietyStockageInventory', 'society_flywheels')
			menu.close()
		  end

		if data.current.value == 'put_money' then
				ESX.TriggerServerCallback('esx_flywheels:CheckMoney2', function (_money)
					local money = _money
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_flywheels2',
						{
							title = "[$" .. tonumber(money) .. "] d'argent dans le coffre"
						}, function(data, menu)
		
							local amount = tonumber(data.value)
		
							if amount == nil then
								ESX.ShowNotification("Montant invalide")
							else
								menu.close()
								TriggerServerEvent('esx_flywheels:putmoney2', amount)
							end
		
						end, function(data, menu)
							menu.close()
						end)
					end)
		end
		
		if data.current.value == 'get_money' then
				ESX.TriggerServerCallback('esx_flywheels:CheckMoney2', function (_money)
					local money = _money
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_flywheels2',
					{
						title = "[$" .. tonumber(money) .. "] d'argent dans le coffre"
					}, function(data, menu)
	
						local amount = tonumber(data.value)
	
						if amount == nil then
							ESX.ShowNotification("Montant invalide")
						else
							menu.close()
							TriggerServerEvent('esx_flywheels:getmoney2', amount)
						end
	
					end, function(data, menu)
						menu.close()
					end)
				end)

		end

      end,
      
      function(data, menu)
        menu.close()
      end
    )

end

function mosley_OpenVaultMenu()

	local elements = {}

	if (PlayerData.job ~= nil and PlayerData.job.name == 'flywheels' and PlayerData.job.grade_name == 'boss' and PlayerData.job2 ~= nil and PlayerData.job2.name == 'voleur'  and PlayerData.job.service == 1) then
		table.insert(elements, {label = "Retirer Argent (sans trace)", value = 'get_money'})
		table.insert(elements, {label = "Déposer Argent (sans trace)", value = 'put_money'})
	end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault',
      {
        title    = "flywheels Coffre",
        align = 'right',
        elements = elements,
      },
      function(data, menu)

		if data.current.value == 'put_money' then
				ESX.TriggerServerCallback('esx_flywheels:CheckMoney', function (_money)
					local money = _money
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_flywheels',
						{
							title = "[$" .. tonumber(money) .. "] d'argent dans le coffre"
						}, function(data, menu)
		
							local amount = tonumber(data.value)
		
							if amount == nil then
								ESX.ShowNotification("Montant invalide")
							else
								menu.close()
								TriggerServerEvent('esx_flywheels:putmoney', amount)
							end
		
						end, function(data, menu)
							menu.close()
						end)
					end)
		end
		
		if data.current.value == 'get_money' then
				ESX.TriggerServerCallback('esx_flywheels:CheckMoney', function (_money)
					local money = _money
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_flywheels',
					{
						title = "[$" .. tonumber(money) .. "] d'argent dans le coffre"
					}, function(data, menu)
	
						local amount = tonumber(data.value)
	
						if amount == nil then
							ESX.ShowNotification("Montant invalide")
						else
							menu.close()
							--TriggerServerEvent("flywheels:bot", " a retirer $".. amount)
							TriggerServerEvent('esx_flywheels:getmoney', amount)
						end
	
					end, function(data, menu)
						menu.close()
					end)
				end)

		end
		
      end,
      
      function(data, menu)
        menu.close()
      end
    )

end

Citizen.CreateThread(function() 
  local blip = AddBlipForCoord(GuTu_esx_mosleyjob.Sell.x, GuTu_esx_mosleyjob.Sell.y, GuTu_esx_mosleyjob.Sell.z)
  SetBlipSprite (blip, 641)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.6)
  SetBlipAsShortRange(blip, true)
  SetBlipColour(blip, 81)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Mosley : Véhicules d'occasion")
  EndTextCommandSetBlipName(blip)
end)

function mosley02()
	if (PlayerData.job ~= nil and PlayerData.job.name == 'flywheels' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'flywheels' and PlayerData.job2.service == 1) then
		
		if(GetDistanceBetweenCoords(coords, GuTu_esx_mosleyjob.InfoEngine.x, GuTu_esx_mosleyjob.InfoEngine.y, GuTu_esx_mosleyjob.InfoEngine.z, true) < GuTu_esx_mosleyjob.DrawDistance) then
		  DrawMarker(42, GuTu_esx_mosleyjob.InfoEngine.x, GuTu_esx_mosleyjob.InfoEngine.y, GuTu_esx_mosleyjob.InfoEngine.z+0.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, GuTu_esx_mosleyjob.MarkerColor.r, GuTu_esx_mosleyjob.MarkerColor.g, GuTu_esx_mosleyjob.MarkerColor.b, 255, true, false, 2, nil, nil, false)
		end
		
		if(GetDistanceBetweenCoords(coords, GuTu_esx_mosleyjob.Sell.x, GuTu_esx_mosleyjob.Sell.y, GuTu_esx_mosleyjob.Sell.z, true) < GuTu_esx_mosleyjob.DrawDistance) then
		  DrawMarker(42, GuTu_esx_mosleyjob.Sell.x, GuTu_esx_mosleyjob.Sell.y, GuTu_esx_mosleyjob.Sell.z+0.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, GuTu_esx_mosleyjob.MarkerColor.r, GuTu_esx_mosleyjob.MarkerColor.g, GuTu_esx_mosleyjob.MarkerColor.b, 255, true, false, 2, nil, nil, false)
		end

		if(GetDistanceBetweenCoords(coords, GuTu_esx_mosleyjob.Sell2.x, GuTu_esx_mosleyjob.Sell2.y, GuTu_esx_mosleyjob.Sell2.z, true) < GuTu_esx_mosleyjob.DrawDistance) then
			DrawMarker(42, GuTu_esx_mosleyjob.Sell2.x, GuTu_esx_mosleyjob.Sell2.y, GuTu_esx_mosleyjob.Sell2.z+0.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, GuTu_esx_mosleyjob.MarkerColor.r, GuTu_esx_mosleyjob.MarkerColor.g, GuTu_esx_mosleyjob.MarkerColor.b, 255, true, false, 2, nil, nil, false)
		end

		if(GetDistanceBetweenCoords(coords, GuTu_esx_mosleyjob.Room.x, GuTu_esx_mosleyjob.Room.y, GuTu_esx_mosleyjob.Room.z, true) < GuTu_esx_mosleyjob.DrawDistance) then
		  DrawMarker(42, GuTu_esx_mosleyjob.Room.x, GuTu_esx_mosleyjob.Room.y, GuTu_esx_mosleyjob.Room.z+0.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, GuTu_esx_mosleyjob.MarkerColor.r, GuTu_esx_mosleyjob.MarkerColor.g, GuTu_esx_mosleyjob.MarkerColor.b, 255, true, false, 2, nil, nil, false)
		end
	end
end

function mosley01()
	
	if (PlayerData.job ~= nil and PlayerData.job.name == 'flywheels' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'flywheels' and PlayerData.job2.service == 1) then
		if(GetDistanceBetweenCoords(coords, GuTu_esx_mosleyjob.VehicleDelivery.x, GuTu_esx_mosleyjob.VehicleDelivery.y, GuTu_esx_mosleyjob.VehicleDelivery.z, true) <  40.0) then
			NPCTargetDeleterZone = true
		else
			NPCTargetDeleterZone = false
		end

		if(GetDistanceBetweenCoords(coords, GuTu_esx_mosleyjob.InfoEngine.x, GuTu_esx_mosleyjob.InfoEngine.y, GuTu_esx_mosleyjob.InfoEngine.z, true) < GuTu_esx_mosleyjob.MarkerSize.x) then
			isInInfoEngineMarker = true
		else
			isInInfoEngineMarker = false
		end
		if(GetDistanceBetweenCoords(coords, GuTu_esx_mosleyjob.Sell.x, GuTu_esx_mosleyjob.Sell.y, GuTu_esx_mosleyjob.Sell.z, true) < GuTu_esx_mosleyjob.MarkerSize.x) then
			isInSellMarker = true
		else
			isInSellMarker = false
		end
		if(GetDistanceBetweenCoords(coords, GuTu_esx_mosleyjob.Sell2.x, GuTu_esx_mosleyjob.Sell2.y, GuTu_esx_mosleyjob.Sell2.z, true) < GuTu_esx_mosleyjob.MarkerSize.x) then
			isInSellMarker2 = true
		else
			isInSellMarker2 = false
		end
		if(GetDistanceBetweenCoords(coords, GuTu_esx_mosleyjob.Room.x, GuTu_esx_mosleyjob.Room.y, GuTu_esx_mosleyjob.Room.z, true) < GuTu_esx_mosleyjob.MarkerSize.x) then
			isInRoomMarker = true
		else
			isInRoomMarker = false
		end
		
	end
end

local InfoVeh = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		
		if InfoVeh then
			if IsPedInAnyVehicle(playerPed, false) then
				local veh = GetVehiclePedIsIn(playerPed, false)
				local name = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
				local vehicleProps = ESX.Game.GetVehicleProperties(veh)
				DrawText3Ds(GuTu_esx_mosleyjob.InfoEngine.x, GuTu_esx_mosleyjob.InfoEngine.y, GuTu_esx_mosleyjob.InfoEngine.z+2, "Model: " .. name .. "~n~~n~Moteur: " .. vehicleProps.modEngine+1 .. "~n~Freins: " .. vehicleProps.modBrakes+1 .."~n~Transmission: " .. vehicleProps.modTransmission+1 .."~n~Suspension: " .. vehicleProps.modSuspension+1)
			end
		end
	end
end)

function mosley_ShowInfoVeh()
	InfoVeh = true
	Citizen.Wait(15000)
	InfoVeh = false
end

--function Repair(vehicle, op)
--	while (not HasAnimDictLoaded("mini@repair" )) do
--        RequestAnimDict("mini@repair")
--        Citizen.Wait(5)
--    end

--	TaskTurnPedToFaceEntity(playerPed, vehicle, 100000)  
	
--	if not op then
--		TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_KNEEL", 0, true)
--	end
--	TriggerEvent('progressBar:drawBar', true, 100000, "Réparation..")
--	Citizen.Wait(30000)
--	ClearPedTasksImmediately(playerPed)
--	Citizen.Wait(5000)
--	if not op then
--		TaskPlayAnim(playerPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 1, 0, 0, 0, 0)
--	end
--	Citizen.Wait(60000)
--	if not op then
--		TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
--	end
--	Citizen.Wait(5000)
--	SetVehicleFixed(vehicle)
--	SetVehicleDeformationFixed(vehicle)
--	SetVehicleDirtLevel(vehicle, 0.0000000001)
--	SetVehicleUndriveable(vehicle, false)
--	SetVehicleEngineOn(vehicle,  true,  true)
--	ESX.ShowNotification("Vehicule Réparer!")
--	ClearPedTasksImmediately(playerPed)
--end

function mosley_RepaVeh()
	local vehicle = nil
	if IsPedInAnyVehicle(playerPed, false) then
		--[[vehicle = GetVehiclePedIsIn(playerPed, false)
		if DoesEntityExist(vehicle) then
			Repair(vehicle, true)
		end]]
		ESX.ShowNotification("Vous devez dessendre du véhicule!")
	else
		
		vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		if DoesEntityExist(vehicle) then
			Repair(vehicle, false)
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

function mosley04()
	
	if (PlayerData.job ~= nil and PlayerData.job.name == 'flywheels' and PlayerData.job.service == 1) or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'flywheels' and PlayerData.job2.service == 1) then
		if isInSellMarker or isInSellMarker2 then
			sleepThread = 20
			if isInSellMarker then
				DrawText3Ds(GuTu_esx_mosleyjob.Sell.x, GuTu_esx_mosleyjob.Sell.y, GuTu_esx_mosleyjob.Sell.z + 0.5, "Appuyez sur ~o~E ~s~pour accéder au clef des vehicules")
			elseif isInSellMarker2 then
				DrawText3Ds(GuTu_esx_mosleyjob.Sell2.x, GuTu_esx_mosleyjob.Sell2.y, GuTu_esx_mosleyjob.Sell2.z + 0.5, "Appuyez sur ~o~E ~s~pour accéder au clef des vehicules")
			end
		  if IsControlPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 300 then
			if isInSellMarker or isInSellMarker2 then
			  mosley_OpenAllMenu()
			end
			CurrentAction = nil
			GUI.Time = GetGameTimer()
		  end
		end
		
		if isInInfoEngineMarker then
			sleepThread = 20
			DrawText3Ds(GuTu_esx_mosleyjob.InfoEngine.x, GuTu_esx_mosleyjob.InfoEngine.y, GuTu_esx_mosleyjob.InfoEngine.z + 0.5, "Appuyez sur ~o~E ~s~pour accéder du info du vehicule")
		  if IsControlPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 300 then
			if isInInfoEngineMarker then
			  mosley_ShowInfoVeh()
			end
			CurrentAction = nil
			GUI.Time = GetGameTimer()
		  end
		end
		if isInRoomMarker then
			sleepThread = 20
			DrawText3Ds(GuTu_esx_mosleyjob.Room.x, GuTu_esx_mosleyjob.Room.y, GuTu_esx_mosleyjob.Room.z + 0.5, "Appuyez sur ~o~E ~s~pour vous changer")
		  if IsControlPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 300 then
			if isInRoomMarker then
			  mosley_OpenRoomMenu()
			end
			CurrentAction = nil
			GUI.Time = GetGameTimer()
		  end
		end
	end
end

function mosley08()
	if(GetDistanceBetweenCoords(coords, GuTu_esx_mosleyjob.SellVeh.x, GuTu_esx_mosleyjob.SellVeh.y, GuTu_esx_mosleyjob.SellVeh.z, true) < GuTu_esx_mosleyjob.DrawDistance) then
		DrawMarker(42, GuTu_esx_mosleyjob.SellVeh.x, GuTu_esx_mosleyjob.SellVeh.y, GuTu_esx_mosleyjob.SellVeh.z+0.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, GuTu_esx_mosleyjob.MarkerColor.r, GuTu_esx_mosleyjob.MarkerColor.g, GuTu_esx_mosleyjob.MarkerColor.b, 255, true, false, 2, nil, nil, false)
	end
end

function mosley09()
	if(GetDistanceBetweenCoords(coords, GuTu_esx_mosleyjob.SellVeh.x, GuTu_esx_mosleyjob.SellVeh.y, GuTu_esx_mosleyjob.SellVeh.z, true) < GuTu_esx_mosleyjob.MarkerSize.x) then
        isInSellVehMarker = true
    else
        isInSellVehMarker = false
    end
	
	if isInSellVehMarker then
		sleepThread = 20
		DrawText3Ds(GuTu_esx_mosleyjob.SellVeh.x, GuTu_esx_mosleyjob.SellVeh.y, GuTu_esx_mosleyjob.SellVeh.z + 0.5, "Appuyez sur ~o~E ~s~pour donner vos clés au mosley")
      if IsControlPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 300 then
        if isInSellVehMarker then
          mosley_mosley_OpenMenu2()--vendre le vehicle au flywheels
        end
        CurrentAction = nil
        GUI.Time = GetGameTimer()
      end
	end
end

function mosley_OpenflywheelsMenuJob()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'actions1', 
    {
      title    = 'flywheels Menu',
	  align = 'right',
      elements = {
		{label = 'Info Prix', value = 'info_prix'},
      	{label = 'Facturation', value = 'billing'},
		--{label = 'Start/Stop Mission (nord)', value = 'mission_nord'},
		{label = 'Start/Stop Mission (livraison)', value = 'livraison'},
		--{label = 'Réparer le véhicule',    value = 'fix_vehicle'},
		{label = 'Nettoyer le véhicule',    value = 'clean_vehicle'},
		{label = 'Supprimer un plateau (bug)',    value = 'del_plateau'},
		--{label = 'Start/Stop Mission (sud)', value = 'mission_sud'},
		--{label = 'Attach/Dettach Vehicule', value = 'mosley_Towing'}
    	}
    },
    function(data, menu)

		if data.current.value == 'del_plateau' then
			local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z, 8.0,  GetHashKey("inm_flatbed_base"), false, false, false)
			if DoesEntityExist(object) then
				DeleteObject(object)
			end
		end

		if data.current.value == 'info_prix' then
			TriggerEvent('esx_flywheels:OpenInfoVeh')
		end
		
		if data.current.value == 'livraison' then
			toggle = not toggle
			if toggle then
				TriggerServerEvent('esx_mosley:checkForLimitation')
				WaitingForLimitationReach = true
				while WaitingForLimitationReach do
					Wait(500)
				end
				if CanAskForNewJob == false then
					do return end
				end

				TriggerEvent('esx_flywheels:livraison')
			else 
				TriggerEvent('esx_flywheels:stopliv')
			end
		end
	
		if data.current.value == 'mission_nord' then
			mosley_StartMission("nord")
		end

		if data.current.value == 'fix_vehicle' then
			local vehicle = nil

			if IsPedInAnyVehicle(playerPed, false) then
				vehicle = GetVehiclePedIsIn(playerPed, false)
			else
				vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
			end

			local engineHealth  = GetVehicleEngineHealth(vehicle)
			local vehicleFuel   = GetVehicleFuelLevel(vehicle)

			if GetDistanceBetweenCoords(GuTu_esx_mosleyjob.Repa.x, GuTu_esx_mosleyjob.Repa.y, GuTu_esx_mosleyjob.Repa.z, coords) <= 45 then
				if DoesEntityExist(vehicle) then
					TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
					Citizen.CreateThread(function()
					Citizen.Wait(60000)
					SetVehicleFixed(vehicle)
					SetVehicleDeformationFixed(vehicle)
					SetVehicleUndriveable(vehicle, false)
					SetVehicleFuelLevel(vehicle, vehicleFuel)
					exports['Nebula_Fuel']:SetFuel(vehicle, vehicleFuel)
					SetVehicleEngineOn(vehicle,  true,  true)
					ClearPedTasksImmediately(playerPed)
					SetVehicleMaxSpeed(vehicle, -1)
					TriggerEvent('Core:ShowNotification', "Véhicule ~g~réparé.")
					end)
				end			
			else
				if DoesEntityExist(vehicle) then
					TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
					Citizen.CreateThread(function()
					Citizen.Wait(40000)
					SetVehicleUndriveable(vehicle, false)
					SetVehicleEngineHealth(vehicle, 940.00)
					SetVehicleBodyHealth(vehicle, 940.00)
					SetVehicleFuelLevel(vehicle, vehicleFuel)
					exports['Nebula_Fuel']:SetFuel(vehicle, vehicleFuel)
					SetVehicleEngineOn(vehicle,  true,  true)
					ClearPedTasksImmediately(playerPed)
					TriggerEvent('Core:ShowNotification', "Réparation de ~y~secours~w~ effectué.")
					end)
				end
			end
		end

		if data.current.value == 'clean_vehicle' then
			if GetDistanceBetweenCoords(GuTu_esx_mosleyjob.Repa.x, GuTu_esx_mosleyjob.Repa.y, GuTu_esx_mosleyjob.Repa.z, coords) <= 45 then
				local vehicle = nil

				if IsPedInAnyVehicle(playerPed, false) then
				  vehicle = GetVehiclePedIsIn(playerPed, false)
				else
				  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
				end
	  
				if DoesEntityExist(vehicle) then
				  TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
				  Citizen.CreateThread(function()
					Citizen.Wait(40000)
					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)
					TriggerEvent('Core:ShowNotification', "Vehicule ~b~nettoyé~w~.")
				end)
				end
			else
				TriggerEvent('Core:ShowNotification', "Vous devez être au ~y~garage~w~.")
			end
		end
		
		if data.current.value == 'mission_sud' then
			mosley_StartMission("sud")
		end
	
		if data.current.value == 'mosley_Towing' then
			mosley_Towing()
		end
	
		if data.current.value == 'billing' then
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'billing1',
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
								TriggerServerEvent('CoreLog:SendDiscordLog', "Mosley - Factures", "**" .. GetPlayerName(PlayerId()) .. "** a facturé **"..GetPlayerName(closestPlayer).."** d'un montant de `$"..amount.."`", "Yellow")
								TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_flywheels', 'flywheels', amount)
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

RegisterNetEvent('esx_flywheels:openMenuJob')
AddEventHandler('esx_flywheels:openMenuJob', function()
	mosley_OpenflywheelsMenuJob()
end)

function mosley_SelectRandomTowable(mission)
  local mission = mission

  if mission == "nord" then
	  cPay = 1500
	  GuTu_esx_mosleyjob.VehicleDelivery = GuTu_esx_mosleyjob.VehicleDelivery_nord
	  GuTu_esx_mosleyjob.Zones = GuTu_esx_mosleyjob.Zones_nord
	  local index = GetRandomIntInRange(1, #GuTu_esx_mosleyjob.Towables_nord)
	  for k,v in pairs(GuTu_esx_mosleyjob.Zones) do
		if v.Pos.x == GuTu_esx_mosleyjob.Towables_nord[index].x and v.Pos.y == GuTu_esx_mosleyjob.Towables_nord[index].y and v.Pos.z == GuTu_esx_mosleyjob.Towables_nord[index].z then
		  return k
		end
	  end
  elseif mission == "sud" then
	  cPay = 1000
	  GuTu_esx_mosleyjob.VehicleDelivery = GuTu_esx_mosleyjob.VehicleDelivery_sud
	  GuTu_esx_mosleyjob.Zones = GuTu_esx_mosleyjob.Zones_sud
	  local index = GetRandomIntInRange(1, #GuTu_esx_mosleyjob.Towables_sud)
	  for k,v in pairs(GuTu_esx_mosleyjob.Zones) do
		if v.Pos.x == GuTu_esx_mosleyjob.Towables_sud[index].x and v.Pos.y == GuTu_esx_mosleyjob.Towables_sud[index].y and v.Pos.z == GuTu_esx_mosleyjob.Towables_sud[index].z then
		  return k
		end
	  end
  end
end

function mosley_StartNPCJob(mission)
  local mission = mission
  
  NPCOnJob = true

  NPCTargetTowableZone = mosley_SelectRandomTowable(mission)
  local zone = GuTu_esx_mosleyjob.Zones[NPCTargetTowableZone] --needfix

  Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x, zone.Pos.y, zone.Pos.z)
  SetBlipRoute(Blips['NPCTargetTowableZone'], true)

  ESX.ShowNotification('Conduisez jusqu\'à l\'endroit indiqué !')
end

function mosley_StopNPCJob(cancel)

  if Blips['NPCTargetTowableZone'] ~= nil then
    RemoveBlip(Blips['NPCTargetTowableZone'])
    Blips['NPCTargetTowableZone'] = nil
  end

  if blipDelivery ~= nil then
    RemoveBlip(blipDelivery)
  end

  NPCOnJob                = false
  NPCTargetTowable        = nil
  NPCTargetTowableZone    = nil
  NPCHasSpawnedTowable    = false
  NPCHasBeenNextToTowable = false

  if cancel then
    ESX.ShowNotification('Mission annulée !')
  else
	ESX.ShowNotification('Mission terminée !')
  end

end

function mosley03()

    if NPCTargetTowableZone ~= nil and not NPCHasSpawnedTowable then

      
      local zone   = GuTu_esx_mosleyjob.Zones[NPCTargetTowableZone]

      if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < GuTu_esx_mosleyjob.NPCSpawnDistance then
		sleepThread = 20
		local model = GuTu_esx_mosleyjob.Vehicles[GetRandomIntInRange(1,  #GuTu_esx_mosleyjob.Vehicles)]
        ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
          NPCTargetTowable = vehicle
        end)
        NPCHasSpawnedTowable = true
      end
    end

    if NPCTargetTowableZone ~= nil and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then
      
      local zone   = GuTu_esx_mosleyjob.Zones[NPCTargetTowableZone]
	  
      if(GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < GuTu_esx_mosleyjob.NPCNextToDistance) then
        ESX.ShowNotification('Veuillez remorquer le véhicule !')
	
        NPCHasBeenNextToTowable = true
      end
	  
    end
end

function mosley_StartMission(mission)
	local mission = mission
	if NPCOnJob then
		if GetGameTimer() - NPCLastCancel > 5 * 60000 then
			mosley_StopNPCJob(true)
			NPCLastCancel = GetGameTimer()
		else
			ESX.ShowNotification('Vous devez ~r~attendre~s~ 5 minutes')
		end
	else

		if IsPedInAnyVehicle(playerPed,  false) and IsVehicleModel(GetVehiclePedIsIn(playerPed,  false), GetHashKey(hName)) then
			mosley_StartNPCJob(mission)
		else
			ESX.ShowNotification('Vous devez être en towtruk pour commencer la mission')
		end
	end
end

RegisterCommand("voleur",function(source, args)
	TriggerEvent('esx_flywheels:OpenInfoVeh')
end,false)

function mosley_Towing()
	local vehicle = GetVehiclePedIsIn(playerPed, true)
    local towmodel = GetHashKey(hName)
    local isVehicleTow = IsVehicleModel(vehicle, towmodel)
		
	if isVehicleTow then
        local targetVehicle = ESX.Game.GetVehicleInDirection()

        if CurrentlyTowedVehicle == nil then
            if targetVehicle ~= 0 then
				if not IsPedInAnyVehicle(playerPed, true) then
					if vehicle ~= targetVehicle then
						AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
						CurrentlyTowedVehicle = targetVehicle
						ESX.ShowNotification('Vehicule attaché avec succès!')
						
						if NPCOnJob then
							if NPCTargetTowable == targetVehicle then
								ESX.ShowNotification('Veuillez déposer le véhicule au mosley')
								if Blips['NPCTargetTowableZone'] ~= nil then
									RemoveBlip(Blips['NPCTargetTowableZone'])
									Blips['NPCTargetTowableZone'] = nil
								end
								blipDelivery = AddBlipForCoord(GuTu_esx_mosleyjob.VehicleDelivery.x, GuTu_esx_mosleyjob.VehicleDelivery.y, GuTu_esx_mosleyjob.VehicleDelivery.z)
								SetBlipRoute(blipDelivery, true)
							end
						  end
					else
						ESX.ShowNotification('Impossible~s~ d\'attacher votre propre dépanneuse')
					end
				end
			else
				ESX.ShowNotification('Il n\'y a pas de véhicule à attacher')
			end
		else
			AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
			DetachEntity(CurrentlyTowedVehicle, true, true)
			if NPCOnJob then
				if NPCTargetDeleterZone then
					if CurrentlyTowedVehicle == NPCTargetTowable then
						ESX.Game.DeleteVehicle(NPCTargetTowable)
						TriggerServerEvent('esx_flywheels:onNPCJobMissionCompleted', cPay)
						mosley_StopNPCJob()
						NPCTargetDeleterZone = false
					else
						ESX.ShowNotification('Ce n\'est pas le bon véhicule')
					end
				else
					ESX.ShowNotification('Vous devez être au bon endroit pour faire cela')
				end
            end
            CurrentlyTowedVehicle = nil
            ESX.ShowNotification('Vehicule détattaché avec succès!')
		end
	else
        ESX.ShowNotification("Impossible! Vous devez avoir un towtruk pour ça")
    end
end

RegisterNetEvent('esx_mosley:responseCheckForLimitation')
AddEventHandler('esx_mosley:responseCheckForLimitation', function(result)
    CanAskForNewJob = result == false
    if result then
		TriggerEvent('Core:ShowNotification', "Vous avez atteint le quota de livraison pour aujourd'hui. Recommencez demain.")
    end
    WaitingForLimitationReach = false      
end)

xSound = exports.xsound
RegisterNetEvent("esx_mosley:playmusic")
AddEventHandler("esx_mosley:playmusic", function(data)
	local pos = vec3(-778.80, -1045.42, 14.13)
	if xSound:soundExists("mosley") then
		xSound:Destroy("mosley")
	end
	xSound:PlayUrlPos("mosley", data, 0.1, pos)
	xSound:Distance("mosley", 25)
	xSound:Position("mosley", pos)
end)

RegisterNetEvent("esx_mosley:pausemosley")
AddEventHandler("esx_mosley:pausemosley", function(status)
	if status == "play" then
		xSound:Resume("mosley")
	elseif status == "pause" then
		xSound:Pause("mosley")
	end
end)

RegisterNetEvent("esx_mosley:volumemosley")
AddEventHandler("esx_mosley:volumemosley", function(volume)
	print(volume/100)
	xSound:setVolume("mosley", volume / 100)
end)

RegisterNetEvent("esx_mosley:stopmosley")
AddEventHandler("esx_mosley:stopmosley", function()
	xSound:Destroy("mosley")
end)