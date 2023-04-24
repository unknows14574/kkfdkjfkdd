local function OpenSimMenu()

	ESX.UI.Menu.CloseAll()

	local elements = {}
	local elements2 = {}
  
	  TriggerServerCallback('esx_prefecture:GetList', function(sim)
  
		  for _,v in pairs(sim) do
  
			  table.insert(elements, {label = tostring(v.number) .. " - " .. tostring(v.name), value = v})
			  
		  end
  
		  ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'phone_change',
		  {
			  title    = 'Liste des cartes sim',
			 align = 'right',
			  elements = elements,
		  },
	  function(data, menu)
  
		local elements2 = {
			{label = 'Utiliser', value = 'sim_use'},
			{label = 'Renommer', value = 'sim_name'},
			{label = 'Donner', value = 'sim_give'},
			{label = 'Pirater les données', value = 'sim_check_data'},
		  	{label = 'Détruire (action irreversible)', value = 'sim_delete'}
		  }
  
		  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sim_change', {
			title    = "Que voulez vous faire de cette carte sim?",
			align = 'right',
			elements = elements2,
  
		  }, 
		  function(data2, menu2)
		  
			if data2.current.value == 'sim_name' then
				
				menu2.close()
				
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'renamesim', {title = "Renommer la carte sim"}, 	
				function(data3, menu3)
				
					if data3.value ~= nil then
						TriggerServerEvent('esx_prefecture:rename', data.current.value.number, data3.value)
						Core.Main.ShowNotification("Carte sim renommer!")
						OpenSimMenu()
					else
						Core.Main.ShowNotification("Texte invalide!")
					end
					
				end, function(data3, menu3)
				menu3.close()
			end)
				
			end
			if data2.current.value == 'sim_use' then
				ESX.UI.Menu.CloseAll()
				TriggerServerEvent('esx_prefecture:sim_use', data.current.value.number)
				Core.Main.ShowNotification("Vous avez activé la carte sim ~o~" .. data.current.value.number)
				TriggerServerEvent('gcPhone:allUpdate')
			end
			if data2.current.value == 'sim_give' then
				ESX.UI.Menu.CloseAll()
				local closestPlayer = Core.Player.GetClosestPlayer(1.5)
				if closestPlayer == -1 then
					Core.Main.ShowNotification('Aucun joueur à proximité')
				else
					TriggerServerEvent('esx_prefecture:sim_give', data.current.value.number, GetPlayerServerId(closestPlayer))
				end
				TriggerServerEvent('gcPhone:allUpdate')
			end
			if data2.current.value == 'sim_delete' then
				ESX.UI.Menu.CloseAll()
				TriggerServerEvent('esx_prefecture:sim_delete', data.current.value.number)
				Core.Main.ShowNotification("Vous avez jeté la carte sim ~o~" .. data.current.value.number)
				TriggerServerEvent('gcPhone:allUpdate')
			end

			if data2.current.value == 'sim_check_data' then
				local number = data.current.value.number
				ESX.UI.Menu.CloseAll()
				Core.Sim.CheckSimData(number)
			end

			menu2.close()
		  end, function(data2, menu2)
			menu2.close()
		  end)
  
		  end,
		  function(data, menu)
			  menu.close()
		  end
	  )	
	end)
  
end

local function OpenPhoneMenu()

	ESX.UI.Menu.CloseAll()

	local elements = {
	  {label = 'Ouvrir', value = 'open_phone'},
	  {label = 'Carte Sim', value = 'sim_phone'}
	}
  
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'phone_actions',
	  {
		title    = 'Téléphone',
		align = 'right',
		elements = elements
	  },
	  function(data, menu)
  
		if data.current.value == 'open_phone' then
			ESX.UI.Menu.CloseAll()
			ESX.TriggerServerCallback('esx_prefecture:CheckSim', function(sim)
				if sim then
					TriggerEvent("high_phone:openPhone")
				else
					Core.Main.ShowNotification("Vous n'avez pas de carte sim !")
				end
			end)

		end

		if data.current.value == 'sim_phone' then
			OpenSimMenu()
		end
  
	  end,
	  function(data, menu)
  
		menu.close()
	  end
	)
  
end

RegisterNetEvent('esx_prefecture:OpenSim')
AddEventHandler('esx_prefecture:OpenSim', function()
	OpenPhoneMenu()
end)

RegisterNetEvent('esx_prefecture:CreateSimContrib')
AddEventHandler('esx_prefecture:CreateSimContrib', function()
	ESX.UI.Menu.Open(
		'dialog', GetCurrentResourceName(), 'sim_contrib',
		{
		  title = "Choisissez 4 numéros qui viendrons après le 555-...."
		},
		function(data, menu)

		  local number = tonumber(data.value)

		  if number == nil or string.match(number, "%W") then
			Core.Main.ShowNotification("Numero Invalide")
		  else
			menu.close()
			local pattern = "%d%d%d%d"
			local final_number = string.sub(data.value, string.find(data.value, pattern))
			number = 555 .. "-" .. final_number
			TriggerServerCallback('esx_prefecture:NumExist', function(sim)
				if sim then
					TriggerServerEvent('esx_prefecture:SaveSim', number)
				else
					Core.Main.ShowNotification("Numéro déjà utilisé. Réessayer avec un autre numéro.")
				end
			end, number)
		  end

		end,
		function(data, menu)
		  menu.close()
		end
	)
end)

-------------------------------------------------- dvall vehicle ---------------------
RegisterNetEvent("wld:delallveh")
AddEventHandler("wld:delallveh", function ()
	  local totalvehc = 0
	  local notdelvehc = 0
  
	  for vehicle in EnumerateVehicles() do
		  if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then SetVehicleHasBeenOwnedByPlayer(vehicle, false) SetEntityAsMissionEntity(vehicle, false, false) DeleteVehicle(vehicle)
			  if (DoesEntityExist(vehicle)) then DeleteVehicle(vehicle) end
			  if (DoesEntityExist(vehicle)) then notdelvehc = notdelvehc + 1 end
		  end
		  totalvehc = totalvehc + 1 
	  end
	  local vehfrac = totalvehc - notdelvehc .. " / " .. totalvehc
	  Citizen.Trace("You just deleted "..vehfrac.." vehicles in the server!")
end)