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
ESX									= nil
local gangZ = nil
local GUI							= {}
GUI.Time							= 0
local PlayerData				= {}
local NBMenuIsOpen		= false


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  if (PlayerData.job.service == 1 and (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "gouv" or PlayerData.job.name == "doj" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "ambulance2" or PlayerData.job.name == "prison" or PlayerData.job.name == "parkranger")) or (PlayerData.job2.service == 1 and (PlayerData.job2.name == "police" or PlayerData.job2.name == "sheriff" or PlayerData.job2.name == "gouv" or PlayerData.job2.name == "doj" or PlayerData.job2.name == "ambulance" or PlayerData.job2.name == "ambulance2" or PlayerData.job2.name == "prison" or PlayerData.job2.name == "parkranger")) then
	exports["Neb_radio"]:GivePlayerAccessToFrequency(1)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(2)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(3)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(4)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(5)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(6)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(7)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(8)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(9)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(10)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(11)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(12)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(13)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(14)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(15)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(16)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(17)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(18)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(19)
	exports["Neb_radio"]:GivePlayerAccessToFrequency(20)
  elseif (PlayerData.job.service == 0 and (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "gouv" or PlayerData.job.name == "doj" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "ambulance2" or PlayerData.job.name == "prison" or PlayerData.job.name == "parkranger")) or (PlayerData.job2.service == 0 and (PlayerData.job2.name == "police" or PlayerData.job2.name == "sheriff" or PlayerData.job2.name == "gouv" or PlayerData.job2.name == "doj" or PlayerData.job2.name == "ambulance" or PlayerData.job2.name == "ambulance2" or PlayerData.job2.name == "prison" or PlayerData.job2.name == "parkranger")) then
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(1)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(2)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(3)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(4)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(5)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(6)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(7)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(8)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(9)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(10)  
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(11)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(12)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(13)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(14)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(15)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(16)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(17)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(18)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(19)
	exports["Neb_radio"]:RemovePlayerAccessToFrequency(20)
  end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)
RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job)
  PlayerData.job2 = job
end)
RegisterNetEvent('esx:setService')
AddEventHandler('esx:setService', function(job, service)
  if PlayerData.job.name == job then
    PlayerData.job.service = service
  elseif PlayerData.job2.name == job then
    PlayerData.job2.service = service
  end
  	if (PlayerData.job.service == 1 and (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "gouv" or PlayerData.job.name == "doj" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "ambulance2" or PlayerData.job.name == "prison" or PlayerData.job.name == "parkranger")) or (PlayerData.job2.service == 1 and (PlayerData.job2.name == "police" or PlayerData.job2.name == "sheriff" or PlayerData.job2.name == "gouv" or PlayerData.job2.name == "doj" or PlayerData.job2.name == "ambulance" or PlayerData.job2.name == "ambulance2" or PlayerData.job2.name == "prison" or PlayerData.job2.name == "parkranger")) then
		exports["Neb_radio"]:GivePlayerAccessToFrequency(1)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(2)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(3)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(4)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(5)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(6)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(7)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(8)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(9)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(10)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(11)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(12)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(13)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(14)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(15)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(16)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(17)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(18)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(19)
		exports["Neb_radio"]:GivePlayerAccessToFrequency(20)
	elseif (PlayerData.job.service == 0 and (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "gouv" or PlayerData.job.name == "doj" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "ambulance2" or PlayerData.job.name == "prison" or PlayerData.job.name == "parkranger")) or (PlayerData.job2.service == 0 and (PlayerData.job2.name == "police" or PlayerData.job2.name == "sheriff" or PlayerData.job2.name == "gouv" or PlayerData.job2.name == "doj" or PlayerData.job2.name == "ambulance" or PlayerData.job2.name == "ambulance2" or PlayerData.job2.name == "prison" or PlayerData.job2.name == "parkranger")) then
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(1)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(2)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(3)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(4)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(5)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(6)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(7)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(8)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(9)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(10)  
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(11)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(12)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(13)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(14)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(15)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(16)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(17)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(18)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(19)
		exports["Neb_radio"]:RemovePlayerAccessToFrequency(20)
  	end
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
	end
end)

function RecruterPlayer(target, job, grade, isJob2)

  ESX.UI.Menu.CloseAll()

  local elements = {}

  if not isJob2 then
	table.insert(elements, {label = 'Job #1', value = 'one'})
	table.insert(elements, {label = 'Pour recruter en Job #2, contacter un modérateur.', value = 'none'})
  else
	table.insert(elements, {label = 'Job #2', value = 'two'})
  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'RecruterPlayer',
    {
      title    = 'Selectionner un job 1 ou 2.',
	  align = 'right',
      elements = elements
    },
    function(data, menu)

	if data.current.value == 'one' then
		TriggerServerEvent('NB:recruterplayer', target, job, grade)
	end
	
    if data.current.value == 'two' then
		TriggerServerEvent('NB:recruterplayer2', target, job, grade)
    end

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function VirerPlayer(target, isJob2)

  ESX.UI.Menu.CloseAll()

  local elements = {}

  if not isJob2 then
	table.insert(elements, {label = 'Job #1', value = 'one'})
	table.insert(elements, {label = 'Pour virer en Job #2, contacter un modérateur.', value = 'none'})
  else
	table.insert(elements, {label = 'Job #2', value = 'two'})
  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'VirerPlayer',
    {
      title    = 'Selectionner un job 1 ou 2.',
	  align = 'right',
      elements = elements
    },
    function(data, menu)

	if data.current.value == 'one' then
		TriggerServerEvent('NB:virerplayer', target)
	end
	
    if data.current.value == 'two' then
		TriggerServerEvent('NB:virerplayer2', target)
    end

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function PromouvoirPlayer(target, isJob2)

  ESX.UI.Menu.CloseAll()

  local elements = {}

  if not isJob2 then
	table.insert(elements, {label = 'Job #1', value = 'one'})
	table.insert(elements, {label = 'Pour promouvoir en Job #2, contacter un modérateur.', value = 'none'})
  else
	table.insert(elements, {label = 'Job #2', value = 'two'})
  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'VirerPlayer',
    {
      title    = 'Selectionner un job 1 ou 2.',
	  align = 'right',
      elements = elements
    },
    function(data, menu)

	if data.current.value == 'one' then
		TriggerServerEvent('NB:promouvoirplayer', target)
	end
	
    if data.current.value == 'two' then
		TriggerServerEvent('NB:promouvoirplayer2', target)
    end

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function DestituerPlayer(target, isJob2)

  ESX.UI.Menu.CloseAll()

  local elements = {}

  if not isJob2 then
	table.insert(elements, {label = 'Job #1', value = 'one'})
	table.insert(elements, {label = 'Pour virer en Job #2, contacter un modérateur.', value = 'none'})
  else
	table.insert(elements, {label = 'Job #2', value = 'two'})
  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'VirerPlayer',
    {
      title    = 'Selectionner un job 1 ou 2.',
	  align = 'right',
      elements = elements
    },
    function(data, menu)

	if data.current.value == 'one' then
		TriggerServerEvent('NB:destituerplayer', target)
	end
	
    if data.current.value == 'two' then
		TriggerServerEvent('NB:destituerplayer2', target)
    end

    end,
    function(data, menu)
      menu.close()
    end
  )

end


function OpenDoubleJobMenu()

	ESX.UI.Menu.CloseAll()

	ESX.TriggerServerCallback('IsDiscordAnimal', function (IsContrib)
		
		local elements = {}
		PlayerData = ESX.GetPlayerData()
		table.insert(elements, {label = "Activer Interaction", value = 'ActivateInteract'})

		if (PlayerData.job.name == "police" and PlayerData.job.service == 1) or (PlayerData.job2.name == "police" and PlayerData.job2.service == 1) or (PlayerData.job.name == "sheriff" and PlayerData.job.service == 1) or (PlayerData.job2.name == "sheriff" and PlayerData.job2.service == 1) then
			table.insert(elements, {label = "[FDO] - Centrale d'appels", value = 'menu10-32'})
		end
		
		if PlayerData.job ~= nil then
			if PlayerData.job.service == 1 then
				table.insert(elements, {label = PlayerData.job.label .. " - " .. PlayerData.job.grade_label, value = 'job1'})
			elseif PlayerData.job.service == 0 then
				table.insert(elements, {label = "Hors Service - " .. PlayerData.job.label .. " - " .. PlayerData.job.grade_label, value = 'close'})
			end
		end
		
		if PlayerData.job2 ~= nil then
			if PlayerData.job2.service == 1 or PlayerData.job2.service == true then
				table.insert(elements, {label = PlayerData.job2.label .. " - " .. PlayerData.job2.grade_label, value = 'job2'})
			elseif PlayerData.job2.service == 0 then
				table.insert(elements, {label = "Hors Service - " .. PlayerData.job2.label .. " - " .. PlayerData.job2.grade_label, value = 'close'})
			end
		end

		if PlayerData.job ~= nil or PlayerData.job2 ~= nil then
			table.insert(elements, {label = "Prise/Fin de service", value = 'prise_fin_serice'})
		end

		if (PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'coboss') or (PlayerData.job.grade_name == 'capitaine' and PlayerData.job.name == 'police') then
			if PlayerData.job.service == 1 then
				table.insert(elements, {label = 'Gestion d\'entreprise #1', value = 'boss'})
			end
		end

		if (PlayerData.job2.grade_name == 'boss') or (PlayerData.job2.grade_name == 'coboss') then
			if PlayerData.job2.service == 1 or PlayerData.job2.service == true then
				table.insert(elements, {label = 'Gestion d\'entreprise #2', value = 'boss2'})
			end
		end

		
		if IsContrib then
			table.insert(elements, {label = "Animals Contributeur", value = 'animal_contrib'})
		end
	

	

		--ESX.TriggerServerCallback('NB:GetGang', function (gang)
			--gangZ = gang
		--end)

		--[[if gangZ ~= nil then
			if gangZ == "mafia" then
				table.insert(elements, {label = 'Mafia Menu', value = 'mafia'})
			end
			if gangZ == "cartel" then
				table.insert(elements, {label = 'Cartel Menu', value = 'cartel'})
			end
			if gangZ == "grove" then
				table.insert(elements, {label = 'Grove Menu', value = 'grove'})
			end
			if gangZ == "snk" then
				table.insert(elements, {label = 'Syndicat  Menu', value = 'snk'})
			end
			if gangZ == "bikers" then
				table.insert(elements, {label = 'Bikers  Menu', value = 'bikers'})
			end
			if gangZ == "cosa" then
				table.insert(elements, {label = 'Cosa Nostra  Menu', value = 'cosa'})
			end
		end]]

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'menuperso_doublejob',
			{
				title    = 'Job Menu',
				align = 'right',
				elements = elements
			},
			function(data, menu)

				if data.current.value == 'menu10-32' then
					TriggerEvent('Nebula_jobs:openBackupMenu')
					menu.close()
				end

				if data.current.value == 'prise_fin_serice' then
					ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'pri_fin_service',
					{
						title    = 'Selectionner un job 1 ou 2.',
						align = 'right',
						elements = {
							{label = "Prise/Fin de service " .. PlayerData.job.label, value = "job1"},
							{label = "Prise/Fin de service " .. PlayerData.job2.label, value = "job2"}
						}
					},
					function(data2, menu2)

						TriggerServerEvent('PriseFinService', data2.current.value)
					
						ESX.UI.Menu.CloseAll()
					end,
					function(data2, menu2)
						menu2.close()
					end)
				end

				--[[if data.current.value == 'mafia' then
					TriggerEvent('esx_gangs:openMenuGang')
				end
				if data.current.value == 'cartel' then
					TriggerEvent('esx_cartel:openMenuGang')
				end
				if data.current.value == 'grove' then
					TriggerEvent('esx_grove:openMenuGang')
				end
				if data.current.value == 'snk' then
					TriggerEvent('esx_snk:openMenuGang')
				end
				if data.current.value == 'bikers' then
					TriggerEvent('esx_bikers:openMenuGang')
				end
				if data.current.value == 'cosa' then
					TriggerEvent('esx_cosa:openMenuGang')
				end]]

				if data.current.value == 'ActivateInteract' then
					TriggerEvent('ActivateInteract')
					ESX.ShowNotification("Intéraction activée")
				end

				if data.current.value == 'animal_contrib' then
					TriggerEvent('NB:OpenMenuContribAnimals')
				end

				if data.current.value == 'job1' then

					TriggerEvent('NB:closeAllSubMenu')
					TriggerEvent('NB:closeAllMenu')

					if PlayerData.job ~= nil and (GetGameTimer() - GUI.Time) > 150 then 
						if PlayerData.job.name == 'police' then
							TriggerEvent('esx_policejob:openMenuJob')
						elseif PlayerData.job.name == 'pacific' then
							TriggerEvent('Pacific:openMenuJob')
						elseif PlayerData.job.name == 'ambulance' then
							TriggerEvent('esx_ambulancejob:openMenuJob')
						elseif PlayerData.job.name == 'medecinillegal' then
							TriggerEvent('esx_ambulancejob:openMenuJobIllegal')
						elseif PlayerData.job.name == 'taxi' then
							TriggerEvent('esx_taxijob:openMenuJob')
						elseif PlayerData.job.name == 'bahama' then
							TriggerEvent('esx_bahamajob:openMenuJob')
						elseif PlayerData.job.name == 'mecano' then
							TriggerEvent('esx_mecanojob:openMenuJob')
						elseif PlayerData.job.name == 'mecano2' then
							TriggerEvent('esx_mecanojob2:openMenuJob')
						elseif PlayerData.job.name == 'tequi' then
							TriggerEvent('esx_tequi:openMenuJob')
						elseif PlayerData.job.name == 'galaxy' then
							TriggerEvent('esx_galaxy:openMenuJob')
						elseif PlayerData.job.name == 'comedy' then
							TriggerEvent('esx_comedy:openMenuJob')
						elseif PlayerData.job.name == 'fourriere' then
							TriggerEvent('esx_fourriere:openMenuJob')
						elseif PlayerData.job.name == 'child' then
							TriggerEvent('NB:openPedMenuChild')
						elseif PlayerData.job.name == 'cardealer' then
							TriggerEvent('esx_vehicleshop:openMenuJob')
						elseif PlayerData.job.name == 'flywheels' then
							TriggerEvent('esx_flywheels:openMenuJob')	
						elseif PlayerData.job.name == 'event' then
							TriggerEvent('esx_evenementiel:openMenuJob')
						elseif PlayerData.job.name == 'sheriff' then
							TriggerEvent('esx_sheriff:openMenuJob')
						elseif PlayerData.job.name == 'palace' then
							TriggerEvent('esx_palace:openMenuJob')
						elseif PlayerData.job.name == 'casino' then
							TriggerEvent('esx_casino:openMenuJob')
						elseif PlayerData.job.name == 'upnatom' then
							TriggerEvent('esx_upnatomjob:openMenuJob')
						elseif PlayerData.job.name == 'pizza' then
							TriggerEvent('esx_pizzajob:openMenuJob')
						elseif PlayerData.job.name == 'avocat' then
							TriggerEvent('esx_avocat:openMenuJob')
						elseif PlayerData.job.name == 'avocat2' then
							TriggerEvent('esx_avocat2:openMenuJob')
						elseif PlayerData.job.name == 'gouv' then
							TriggerEvent('esx_gouv:openMenuJob')
						elseif PlayerData.job.name == 'prison' then
							TriggerEvent('esx_prisonfederal:openMenuJob')
						elseif PlayerData.job.name == 'doj' then
							TriggerEvent('esx_doj:openMenuJob')
						elseif PlayerData.job.name == 'journaliste' then
							TriggerEvent('esx_journaliste:openMenuJob')
						elseif PlayerData.job.name == 'musicrecord' then
							TriggerEvent('esx_musicrecord:openMenuJob')
						elseif PlayerData.job.name == 'tabac' then
							TriggerEvent('esx_tabac:openMenuJob')
						elseif PlayerData.job.name == 'henhouse' then
							TriggerEvent('esx_henhouse:openMenuJob')
						elseif PlayerData.job.name == 'coffee' then
							TriggerEvent('esx_coffee:openMenuJob')
						elseif PlayerData.job.name == 'arcade' then
							TriggerEvent('esx_arcade:openMenuJob')
						elseif PlayerData.job.name == 'gruppe6' then
							TriggerEvent('esx_gruppe6:openMenuJob')
						elseif PlayerData.job.name == 'weed' then
							TriggerEvent('esx_weed:openMenuJob')
						elseif PlayerData.job.name == 'illegalmedic' then
							TriggerEvent('NB:openMenuillegal')
						--elseif PlayerData.job.name == 'beer' then
							--TriggerEvent('esx_extendedjob:openMenuJob', PlayerData.job.name)
						elseif PlayerData.job.name == 'brinks' then
							TriggerEvent('esx_brinks:openMobileBrinksMenu')
						elseif PlayerData.job.name == 'pacific' then
							openMenuPacific()
						--elseif PlayerData.job.name == 'bijoutier' then
							--TriggerEvent('esx_extendedjob:openMenuJob', PlayerData.job.name)
						elseif PlayerData.job.name == 'lost' then
							TriggerEvent('esx_mafia:openMenuJob', 'THE LOST')
						elseif PlayerData.job.name == 'ballas' then
							TriggerEvent('esx_mafia:openMenuJob', 'Ballas')
						elseif PlayerData.job.name == 'hustlers' then
							TriggerEvent('esx_mafia:openMenuJob', 'Famille Wade')
						elseif PlayerData.job.name == 'muertos' then
							TriggerEvent('esx_mafia:openMenuJob', 'Les Oneil')
						elseif PlayerData.job.name == 'cdg' then
							TriggerEvent('esx_mafia:openMenuJob', 'Bonelli')
						elseif PlayerData.job.name == 'madrazo' then
							TriggerEvent('esx_mafia:openMenuJob', 'Mafia - madrazo')
						elseif PlayerData.job.name == 'SAB' then
							TriggerEvent('esx_mafia:openMenuJob', 'SAB')
						elseif PlayerData.job.name == 'elt' then
							TriggerEvent('esx_mafia:openMenuJob', 'Mafia - elt')
						elseif PlayerData.job.name == 'bikers' then
							TriggerEvent('esx_mafia:openMenuJob', 'Bikers')
						elseif PlayerData.job.name == 'bikers2' then
							TriggerEvent('esx_mafia:openMenuJob', 'Sons Of Hells MC')
						elseif PlayerData.job.name == 'snk' then
							TriggerEvent('esx_mafia:openMenuJob', 'snk')
						elseif PlayerData.job.name == 'VCF' then
							TriggerEvent('esx_mafia:openMenuJob', 'Vance Crime Family')
						elseif PlayerData.job.name == 'vagos' then
							TriggerEvent('esx_mafia:openMenuJob', 'Vagos')
						elseif PlayerData.job.name == 'orga' then
							TriggerEvent('esx_mafia:openMenuJob', 'L\'organisation')
						elseif PlayerData.job.name == 'hacker' then
							TriggerEvent('esx_hacker:openMenuJob')
						elseif PlayerData.job.name == 'vigne' then
							TriggerEvent('esx_vignerons:OpenMenuJob')
						elseif PlayerData.job.name == 'pizza' then
							TriggerEvent('esx_pizzajob:openMenuJob')
						elseif PlayerData.job.name == 'ghost' then
							TriggerEvent('esx_mafia:openMenuJob', 'ghost')
						elseif PlayerData.job.name == 'leninskaia' then
							TriggerEvent('esx_mafia:openMenuJob', 'Bratva')
						elseif PlayerData.job.name == 'bikers4' then
							TriggerEvent('esx_mafia:openMenuJob', 'Sightless Skulls')
						elseif PlayerData.job.name == 'bikers5' then
							TriggerEvent('esx_mafia:openMenuJob', 'Storm Devils')
						elseif PlayerData.job.name == 'mcreary' then
							TriggerEvent('esx_mafia:openMenuJob', 'Famille McReary')
						elseif PlayerData.job.name == 'stony' then
							TriggerEvent('esx_mafia:openMenuJob', 'Stony')
						elseif PlayerData.job.name == 'mafiacala' then
							TriggerEvent('esx_mafia:openMenuJob', 'Mafia Calabraise')
						elseif PlayerData.job.name == 'locosyndicate' then
							TriggerEvent('esx_mafia:openMenuJob', 'Loco Syndicate')
						elseif PlayerData.job.name == 'shadow' then
							TriggerEvent('esx_mafia:openMenuJob', 'Shadow')
						elseif PlayerData.job.name == 'nebevent' then
							TriggerEvent('esx_nebevent:openMenuJob')
							
						elseif PlayerData.job.name == 'mara' then
							TriggerEvent('esx_mafia:openMenuJob', 'Marabunta')
						elseif PlayerData.job.name == 'voleur' then
							TriggerEvent('esx_mafia:openMenuJob', 'Voleur')
						elseif PlayerData.job.name == 'gitan' then
							TriggerEvent('esx_mafia:openMenuJob', 'Gitan')
						elseif PlayerData.job.name == 'yakuza' then
							TriggerEvent('esx_mafia:openMenuJob', 'Kkangpae')
						elseif PlayerData.job.name == 'mboubar' then
							TriggerEvent('esx_mboubar:openMenuJob')
						elseif PlayerData.job.name == 'liquordeli' then
							TriggerEvent('esx_liquordeli:openMenuJob')
						elseif PlayerData.job.name == 'yellow' then
							TriggerEvent('esx_yellowjack:openMenuJob')							
						elseif PlayerData.job.name == 'diner' then
							TriggerEvent('esx_dinerjob:openMenuJob')
						elseif PlayerData.job.name == 'tucker' then
							TriggerEvent('esx_mafia:openMenuJob', 'Tucker')
						elseif PlayerData.job.name == 'psycho' then
							TriggerEvent('esx_mafia:openMenuJob', 'J&B')
						elseif PlayerData.job.name == 'duggan' then
							TriggerEvent('esx_mafia:openMenuJob', 'Famille Duggan')
						elseif PlayerData.job.name == 'monetti' then
							TriggerEvent('esx_mafia:openMenuJob', 'Famille Monetti')
						elseif PlayerData.job.name == 'bmf' then
							TriggerEvent('esx_mafia:openMenuJob', 'Black Mafia Familie')
						elseif PlayerData.job.name == 'eightpool' then
							TriggerEvent('esx_eightpooljob:openMenuJob')
						end

						GUI.Time = GetGameTimer()
					end
				end
				if data.current.value == 'job2' then

					TriggerEvent('NB:closeAllSubMenu')
					TriggerEvent('NB:closeAllMenu')

					if PlayerData.job2 ~= nil and (GetGameTimer() - GUI.Time) > 150 then 
						if PlayerData.job2.name == 'police' then
							TriggerEvent('esx_policejob:openMenuJob')
						elseif PlayerData.job2.name == 'pacific' then
							TriggerEvent('Pacific:openMenuJob')
						elseif PlayerData.job2.name == 'ambulance' then
							TriggerEvent('esx_ambulancejob:openMenuJob')
						elseif PlayerData.job2.name == 'medecinillegal' then
							TriggerEvent('esx_ambulancejob:openMenuJobIllegal')
						elseif PlayerData.job2.name == 'taxi' then
							TriggerEvent('esx_taxijob:openMenuJob')
						elseif PlayerData.job2.name == 'bahama' then
							TriggerEvent('esx_bahamajob:openMenuJob')
						elseif PlayerData.job2.name == 'mecano' then
							TriggerEvent('esx_mecanojob:openMenuJob')
						elseif PlayerData.job2.name == 'mecano2' then
							TriggerEvent('esx_mecanojob2:openMenuJob')
						elseif PlayerData.job2.name == 'galaxy' then
							TriggerEvent('esx_galaxy:openMenuJob')
						elseif PlayerData.job2.name == 'comedy' then
							TriggerEvent('esx_comedy:openMenuJob')
						elseif PlayerData.job2.name == 'fourriere' then
							TriggerEvent('esx_fourriere:openMenuJob')
						elseif PlayerData.job2.name == 'child' then
							TriggerEvent('NB:openPedMenuChild')
						elseif PlayerData.job2.name == 'cardealer' then
							TriggerEvent('esx_vehicleshop:openMenuJob')
						elseif PlayerData.job2.name == 'flywheels' then
							TriggerEvent('esx_flywheels:openMenuJob')
						elseif PlayerData.job2.name == 'event' then
							TriggerEvent('esx_evenementiel:openMenuJob')
						elseif PlayerData.job2.name == 'sheriff' then
							TriggerEvent('esx_sheriff:openMenuJob')
						elseif PlayerData.job2.name == 'palace' then
							TriggerEvent('esx_palace:openMenuJob')
						elseif PlayerData.job2.name == 'casino' then
							TriggerEvent('esx_casino:openMenuJob')
						elseif PlayerData.job2.name == 'upnatom' then
							TriggerEvent('esx_upnatomjob:openMenuJob')
						elseif PlayerData.job2.name == 'pizza' then
							TriggerEvent('esx_pizzajob:openMenuJob')
						elseif PlayerData.job2.name == 'avocat' then
							TriggerEvent('esx_avocat:openMenuJob')
						elseif PlayerData.job2.name == 'avocat2' then
							TriggerEvent('esx_avocat2:openMenuJob')
						elseif PlayerData.job2.name == 'gouv' then
							TriggerEvent('esx_gouv:openMenuJob')
						elseif PlayerData.job2.name == 'prison' then
							TriggerEvent('esx_prisonfederal:openMenuJob')
						elseif PlayerData.job2.name == 'doj' then
							TriggerEvent('esx_doj:openMenuJob')
						elseif PlayerData.job2.name == 'journaliste' then
							TriggerEvent('esx_journaliste:openMenuJob')
						elseif PlayerData.job2.name == 'musicrecord' then
							TriggerEvent('esx_musicrecord:openMenuJob')
						elseif PlayerData.job2.name == 'henhouse' then
							TriggerEvent('esx_henhouse:openMenuJob')
						elseif PlayerData.job2.name == 'coffee' then
							TriggerEvent('esx_coffee:openMenuJob')
						elseif PlayerData.job2.name == 'arcade' then
							TriggerEvent('esx_arcade:openMenuJob')
						elseif PlayerData.job.name == 'gruppe6' then
							TriggerEvent('esx_gruppe6:openMenuJob')
						elseif PlayerData.job2.name == 'weed' then
							TriggerEvent('esx_weed:openMenuJob')
						elseif PlayerData.job2.name == 'illegalmedic' then
							TriggerEvent('NB:openMenuillegal')
						elseif PlayerData.job2.name == 'leninskaia' then
							TriggerEvent('esx_mafia:openMenuJob', 'Bratva')
						elseif PlayerData.job2.name == 'pacific' then
							openMenuPacific()
						--elseif PlayerData.job2.name == 'beer' then
							--TriggerEvent('esx_extendedjob:openMenuJob', PlayerData.job2.name)
						elseif PlayerData.job2.name == 'brinks' then
							TriggerEvent('esx_brinks:openMobileBrinksMenu')
						--elseif PlayerData.job2.name == 'bijoutier' then
							--TriggerEvent('esx_extendedjob:openMenuJob', PlayerData.job2.name)
						elseif PlayerData.job2.name == 'lost' then
							TriggerEvent('esx_mafia:openMenuJob', 'THE LOST')
						elseif PlayerData.job2.name == 'ballas' then
							TriggerEvent('esx_mafia:openMenuJob', 'Ballas')
						elseif PlayerData.job2.name == 'hustlers' then
							TriggerEvent('esx_mafia:openMenuJob', 'Famille Wade')
						elseif PlayerData.job2.name == 'muertos' then
							TriggerEvent('esx_mafia:openMenuJob', 'Les Oneil')
						elseif PlayerData.job2.name == 'cdg' then
							TriggerEvent('esx_mafia:openMenuJob', 'Famille Leone')
						elseif PlayerData.job2.name == 'madrazo' then
							TriggerEvent('esx_mafia:openMenuJob', 'Mafia - madrazo')
						elseif PlayerData.job2.name == 'SAB' then
							TriggerEvent('esx_mafia:openMenuJob', 'SAB')
						elseif PlayerData.job2.name == 'elt' then
							TriggerEvent('esx_mafia:openMenuJob', 'Mafia - elt')
						elseif PlayerData.job2.name == 'bikers' then
							TriggerEvent('esx_mafia:openMenuJob', 'Bikers')
						elseif PlayerData.job2.name == 'bikers2' then
							TriggerEvent('esx_mafia:openMenuJob', 'Son\'s of Hell')
						elseif PlayerData.job2.name == 'snk' then
							TriggerEvent('esx_mafia:openMenuJob', 'snk')
						elseif PlayerData.job2.name == 'VCF' then
							TriggerEvent('esx_mafia:openMenuJob', 'Vance Crime Family')
						elseif PlayerData.job2.name == 'vagos' then
							TriggerEvent('esx_mafia:openMenuJob', 'Vagos')
						elseif PlayerData.job2.name == 'orga' then
							TriggerEvent('esx_mafia:openMenuJob', 'L\'organisation')
						elseif PlayerData.job2.name == 'hacker' then
							TriggerEvent('esx_hacker:openMenuJob')
						elseif PlayerData.job2.name == 'vigne' then
							TriggerEvent('esx_vignerons:OpenMenuJob')
						elseif PlayerData.job2.name == 'ghost' then
							TriggerEvent('esx_mafia:openMenuJob', 'ghost')
						elseif PlayerData.job2.name == 'shadow' then
							TriggerEvent('esx_mafia:openMenuJob', 'Shadow')
						elseif PlayerData.job2.name == 'nebevent' then
							TriggerEvent('esx_nebevent:openMenuJob')
						elseif PlayerData.job2.name == 'tequi' then
							TriggerEvent('esx_tequi:openMenuJob')
						elseif PlayerData.job2.name == 'bikers3' then
							TriggerEvent('esx_mafia:openMenuJob', 'Outlaw')
						elseif PlayerData.job2.name == 'bikers4' then
							TriggerEvent('esx_mafia:openMenuJob', 'Sightless Skulls')
						elseif PlayerData.job2.name == 'bikers5' then
							TriggerEvent('esx_mafia:openMenuJob', 'Storm Devils')
						elseif PlayerData.job2.name == 'mcreary' then
							TriggerEvent('esx_mafia:openMenuJob', 'Famille McReary')
						elseif PlayerData.job2.name == 'stony' then
							TriggerEvent('esx_mafia:openMenuJob', 'Stony')
						elseif PlayerData.job2.name == 'mafiacala' then
							TriggerEvent('esx_mafia:openMenuJob', 'Mafia Calabraise')
						elseif PlayerData.job2.name == 'locosyndicate' then
							TriggerEvent('esx_mafia:openMenuJob', 'Loco Syndicate')
						elseif PlayerData.job2.name == 'mara' then
							TriggerEvent('esx_mafia:openMenuJob', 'Marabunta')
						elseif PlayerData.job2.name == 'voleur' then
							TriggerEvent('esx_mafia:openMenuJob', 'Voleur')
						elseif PlayerData.job2.name == 'gitan' then
							TriggerEvent('esx_mafia:openMenuJob', 'Gitan')
						elseif PlayerData.job2.name == 'yakuza' then
							TriggerEvent('esx_mafia:openMenuJob', 'Kkangpae')
						elseif PlayerData.job2.name == 'mboubar' then
							TriggerEvent('esx_mboubar:openMenuJob')
						elseif PlayerData.job2.name == 'liquordeli' then
							TriggerEvent('esx_liquordeli:openMenuJob')
						elseif PlayerData.job2.name == 'yellow' then
							TriggerEvent('esx_yellowjack:openMenuJob')
						elseif PlayerData.job2.name == 'diner' then
							TriggerEvent('esx_dinerjob:openMenuJob')
						elseif PlayerData.job2.name == 'tucker' then
							TriggerEvent('esx_mafia:openMenuJob', 'Tucker')
						elseif PlayerData.job2.name == 'psycho' then
							TriggerEvent('esx_mafia:openMenuJob', 'J&B')
						elseif PlayerData.job2.name == 'duggan' then
							TriggerEvent('esx_mafia:openMenuJob', 'Famille Duggan')
						elseif PlayerData.job2.name == 'monetti' then
							TriggerEvent('esx_mafia:openMenuJob', 'Famille Monetti')
						elseif PlayerData.job2.name == 'bmf' then
							TriggerEvent('esx_mafia:openMenuJob', 'Black Mafia Familie')
						elseif PlayerData.job.name == 'eightpool' then
							TriggerEvent('esx_eightpooljob:openMenuJob')
						end

						GUI.Time = GetGameTimer()
					end

				end

				if data.current.value == 'boss' then

					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'menuperso_grade',
						{
							title    = 'Gestion d\'entreprise #1',
							align = 'right',
							elements = {
								{label = 'Recruter',     value = 'menuperso_grade_recruter'},
								{label = 'Virer',              value = 'menuperso_grade_virer'},
								{label = 'Promouvoir', value = 'menuperso_grade_promouvoir'},
								{label = 'Destituer',  value = 'menuperso_grade_destituer'},
								{label = 'Donner de l\'argent à un employé',  value = 'menuperso_give_money'},
								{label = 'Donner de l\'argent à une entreprise',  value = 'menuperso_give_money_entreprise'}
							},
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_give_money_entreprise' then
								ESX.TriggerServerCallback('esx:getJobs',function(resultJob)
									local elements231 = {}

									for _,v in pairs(resultJob) do
										table.insert(elements231, {label = v.label, value = v.name})
									end

									local function cmp(a, b)
										a = tostring(a.label)
										b = tostring(b.label)
										local patt = '^(.-)%s*(%d+)$'
										local _,_, col1, num1 = a:find(patt)
										local _,_, col2, num2 = b:find(patt)
										if (col1 and col2) and col1 == col2 then
											return tonumber(num1) < tonumber(num2)
										end
										return a < b
									end
									
									table.sort(elements231, cmp)

									ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'choix_job_entreprise',
									{
										title    = "Choix Entreprise",
										align = 'right',
										elements = elements231
									},
									function(data3, menu3)
										ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'choix_montant',
										{
											title = "Montant à donner"
										}, 	
										function(data4, menu4)

											local montant = tonumber(data4.value)

											if montant == nil then
												ESX.ShowNotification("Merci de mettre un montant")
											else
												--TriggerServerEvent('fisc:GetMoney', montant, PlayerData.job.name)
												TriggerServerEvent('CoreLog:SendDiscordLog', "Virement entreprise", "`["..PlayerData.job.name.."]` **" .. GetPlayerName(PlayerId()) .. "** a viré `"..montant.."$` du compte entreprise `"..PlayerData.job.name.."` vers le compte de l'entreprise `"..data3.current.label.."`.", "Purple")
												TriggerServerEvent('esx_menuperso:givemoneyEntreprise', data3.current.value, montant, PlayerData.job.name, data3.current.label, PlayerData.job.label)
												ESX.ShowNotification(data3.current.label .. " a reçu " .. montant .. "$")
										
												ESX.UI.Menu.CloseAll()
											end

											end, function(data4, menu4)
											menu4.close()
										end)
									end,
									function(data3, menu3)
										menu3.close()
									end)
								end)	
							end

							if data2.current.value == 'menuperso_give_money' then
								ESX.TriggerServerCallback('esx_menuperso:job_user',function(resultUsers)
									local elements231 = {}

									for _,v in pairs(resultUsers) do
										table.insert(elements231, {label = v.firstname .. " " .. v.lastname , value = v.identifier, bank = v.bank})
									end

									local function cmp(a, b)
										a = tostring(a.label)
										b = tostring(b.label)
										local patt = '^(.-)%s*(%d+)$'
										local _,_, col1, num1 = a:find(patt)
										local _,_, col2, num2 = b:find(patt)
										if (col1 and col2) and col1 == col2 then
											return tonumber(num1) < tonumber(num2)
										end
										return a < b
									end
									
									table.sort(elements231, cmp)

									ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'choix_job_user',
									{
										title    = "Choix Employé",
										align = 'right',
										elements = elements231
									},
									function(data3, menu3)
										ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'choix_montant',
										{
											title = "Montant à donner"
										}, 	
										function(data4, menu4)

											local montant = tonumber(data4.value)

											if montant == nil then
												ESX.ShowNotification("Merci de mettre un montant")
											else
												TriggerServerEvent('CoreLog:SendDiscordLog', "Virement entreprise", "`["..PlayerData.job.name.."]` **" .. GetPlayerName(PlayerId()) .. "** a viré `"..montant.."$` du compte entreprise `"..PlayerData.job.name.."` vers le compte de `"..data3.current.label.."`.", "Green")
												TriggerServerEvent('esx_menuperso:givemoney', data3.current.value, montant, PlayerData.job.name, data3.current.bank, data3.current.label)
												ESX.ShowNotification(data3.current.label .. " a reçu " .. montant .. "$")
										
												ESX.UI.Menu.CloseAll()
											end

											end, function(data4, menu4)
											menu4.close()
										end)
									end,
									function(data3, menu3)
										menu3.close()
									end)
								end, PlayerData.job.name)	
							end

							if data2.current.value == 'menuperso_grade_recruter' then
								if (PlayerData.job.grade_name == 'boss') or (PlayerData.job.grade_name == 'coboss') or (PlayerData.job.grade_name == 'capitaine' and PlayerData.job.name == 'police') then
										local job =  PlayerData.job.name
										local grade = 0
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										RecruterPlayer(GetPlayerServerId(closestPlayer), job, grade, false)
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
							end

							if data2.current.value == 'menuperso_grade_virer' then
								if (PlayerData.job.grade_name == 'boss') or (PlayerData.job.grade_name == 'coboss') or (PlayerData.job.grade_name == 'capitaine' and PlayerData.job.name == 'police') then
										local job =  PlayerData.job.name
										local grade = 0
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										VirerPlayer(GetPlayerServerId(closestPlayer), false)
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
							end

							if data2.current.value == 'menuperso_grade_promouvoir' then

								if (PlayerData.job.grade_name == 'boss') or (PlayerData.job.grade_name == 'coboss') or (PlayerData.job.grade_name == 'capitaine' and PlayerData.job.name == 'police') then
									local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										PromouvoirPlayer(GetPlayerServerId(closestPlayer), false)
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
								
							end

							if data2.current.value == 'menuperso_grade_destituer' then

								if (PlayerData.job.grade_name == 'boss') or (PlayerData.job.grade_name == 'coboss') or (PlayerData.job.grade_name == 'capitaine' and PlayerData.job.name == 'police') then
									local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										DestituerPlayer(GetPlayerServerId(closestPlayer), false)
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
								
							end

							
						end,
						function(data2, menu2)
							menu2.close()
						end
					)
				end	

				if data.current.value == 'boss2' then

					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'menuperso_grade2',
						{
							title    = 'Gestion d\'entreprise #2',
							align = 'right',
							elements = {
								{label = 'Recruter',     value = 'menuperso_grade_recruter2'},
								{label = 'Virer',              value = 'menuperso_grade_virer2'},
								{label = 'Promouvoir', value = 'menuperso_grade_promouvoir2'},
								{label = 'Destituer',  value = 'menuperso_grade_destituer2'},
								{label = 'Donner de l\'argent à un employé',  value = 'menuperso_give_money2'},
								{label = 'Donner de l\'argent à une entreprise',  value = 'menuperso_give_money_entreprise2'}
							},
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_give_money_entreprise2' then
								ESX.TriggerServerCallback('esx:getJobs',function(resultJob)
									local elements231 = {}

									for _,v in pairs(resultJob) do
										table.insert(elements231, {label = v.label, value = v.name})
									end

									local function cmp(a, b)
										a = tostring(a.label)
										b = tostring(b.label)
										local patt = '^(.-)%s*(%d+)$'
										local _,_, col1, num1 = a:find(patt)
										local _,_, col2, num2 = b:find(patt)
										if (col1 and col2) and col1 == col2 then
											return tonumber(num1) < tonumber(num2)
										end
										return a < b
									end
									
									table.sort(elements231, cmp)

									ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'choix_job_entreprise',
									{
										title    = "Choix Entreprise",
										align = 'right',
										elements = elements231
									},
									function(data3, menu3)
										ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'choix_montant',
										{
											title = "Montant à donner"
										}, 	
										function(data4, menu4)

											local montant = tonumber(data4.value)

											if montant == nil then
												ESX.ShowNotification("Merci de mettre un montant")
											else
												TriggerServerEvent('CoreLog:SendDiscordLog', "Virement entreprise", "`["..PlayerData.job2.name.."]` **" .. GetPlayerName(PlayerId()) .. "** a viré `"..montant.."$` du compte entreprise `"..PlayerData.job2.name.."` vers le compte de l'entreprise `"..data3.current.label.."`.", "Purple")
												TriggerServerEvent('esx_menuperso:givemoneyEntreprise', data3.current.value, montant, PlayerData.job.name, data3.current.label, PlayerData.job.label)
												ESX.ShowNotification(data3.current.label .. " a reçu " .. montant .. "$")
										
												ESX.UI.Menu.CloseAll()
											end

											end, function(data4, menu4)
											menu4.close()
										end)
									end,
									function(data3, menu3)
										menu3.close()
									end)
								end)	
							end

							if data2.current.value == 'menuperso_give_money2' then
								ESX.TriggerServerCallback('esx_menuperso:job_user',function(resultUsers)
									local elements231 = {}

									for _,v in pairs(resultUsers) do
										table.insert(elements231, {label = v.firstname .. " " .. v.lastname , value = v.identifier, bank = v.bank})
									end

									local function cmp(a, b)
										a = tostring(a.label)
										b = tostring(b.label)
										local patt = '^(.-)%s*(%d+)$'
										local _,_, col1, num1 = a:find(patt)
										local _,_, col2, num2 = b:find(patt)
										if (col1 and col2) and col1 == col2 then
											return tonumber(num1) < tonumber(num2)
										end
										return a < b
									end
									
									table.sort(elements231, cmp)

									ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'choix_job_user',
									{
										title    = "Choix Employé",
										align = 'right',
										elements = elements231
									},
									function(data3, menu3)
										ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'choix_montant',
										{
											title = "Montant à donner"
										}, 	
										function(data4, menu4)

											local montant = tonumber(data4.value)

											if montant == nil then
												ESX.ShowNotification("Merci de mettre un montant")
											else
												TriggerServerEvent('CoreLog:SendDiscordLog', "Virement entreprise", "`["..PlayerData.job2.name.."]` **" .. GetPlayerName(PlayerId()) .. "** a viré `"..montant.."$` du compte entreprise `"..PlayerData.job2.name.."` vers le compte de `"..data3.current.label.."`.", "Green")
												TriggerServerEvent('esx_menuperso:givemoney', data3.current.value, montant, PlayerData.job2.name, data3.current.bank, data3.current.label)
												ESX.ShowNotification(data3.current.label .. " a reçu " .. montant .. "$")
										
												ESX.UI.Menu.CloseAll()
											end

											end, function(data4, menu4)
											menu4.close()
										end)
									end,
									function(data3, menu3)
										menu3.close()
									end)
								end, PlayerData.job2.name)	
							end

							if data2.current.value == 'menuperso_grade_recruter2' then
								if (PlayerData.job2.grade_name == 'boss') or (PlayerData.job2.grade_name == 'coboss') then
										local job =  PlayerData.job2.name
										local grade = 0
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										RecruterPlayer(GetPlayerServerId(closestPlayer), job, grade, true)
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")
								end
							end

							if data2.current.value == 'menuperso_grade_virer2' then
								if (PlayerData.job2.grade_name == 'boss') or (PlayerData.job2.grade_name == 'coboss') then
										local job =  PlayerData.job2.name
										local grade = 0
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										VirerPlayer(GetPlayerServerId(closestPlayer), true)
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
							end

							if data2.current.value == 'menuperso_grade_promouvoir2' then

								if (PlayerData.job2.grade_name == 'boss') or (PlayerData.job2.grade_name == 'coboss') then
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										PromouvoirPlayer(GetPlayerServerId(closestPlayer), true)
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
								
							end

							if data2.current.value == 'menuperso_grade_destituer2' then

								if (PlayerData.job2.grade_name == 'boss') or (PlayerData.job2.grade_name == 'coboss') then
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										DestituerPlayer(GetPlayerServerId(closestPlayer), true)
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
								
							end

							
						end,
						function(data2, menu2)
							menu2.close()
						end
					)
				end	

			end,
			function(data, menu)
				menu.close()
			end
		)
	end)
end

Citizen.CreateThread(function()
	while true do
		Wait(10)
		
		--[[if gangZ == nil then
			Wait(5000)
			ESX.TriggerServerCallback('NB:GetGang', function (gang)
				gangZ = gang
			end)
		end]]
		
--double job
		--[[if (IsControlPressed(1, Config.menujob.clavier) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_doublejob') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('NB:closeAllSubMenu')
			TriggerEvent('NB:closeAllMenu')
			OpenDoubleJobMenu()
			GUI.Time  = GetGameTimer()
		end
		
		if (IsControlPressed(1, Config.menujob.clavier) and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_doublejob') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('NB:closeAllSubMenu')
			TriggerEvent('NB:closeAllMenu')
			GUI.Time  = GetGameTimer()
		end]]
		
		if (IsControlPressed(1, Config.TPMarker.clavier1) and IsControlPressed(1, Config.TPMarker.clavier2) and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('NB:closeAllSubMenu')
			TriggerEvent('NB:closeAllMenu')
			TriggerEvent('NB:goTpMarcker')
			GUI.Time  = GetGameTimer()
		end

		if Config.general.manettes then
			if (IsControlPressed(2, Config.TPMarker.manette1) and IsControlPressed(2, Config.TPMarker.manette2) and (GetGameTimer() - GUI.Time) > 150) then
				TriggerEvent('NB:closeAllSubMenu')
				TriggerEvent('NB:closeAllMenu')
				TriggerEvent('NB:goTpMarcker')
				GUI.Time  = GetGameTimer()
			end
		end
		
		--[[if ( (IsControlPressed(0, 288) and not IsControlPressed(1, 18) and not IsControlPressed(2, 18) )
		and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menu_perso') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('NB:closeAllSubMenu')
			TriggerEvent('NB:closeAllMenu')
			TriggerEvent('NB:openMenuPersonnel')
			GUI.Time  = GetGameTimer()
		end
		
		if ( (IsControlPressed(0, 288) and not IsControlPressed(1, 18) and not IsControlPressed(2, 18) )
		and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menu_perso') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('NB:closeAllSubMenu')
			TriggerEvent('NB:closeAllMenu')
			GUI.Time  = GetGameTimer()
		end]]
		
		--[[if Config.general.manettes then
			if ( (IsControlPressed(0, 7) and not IsControlPressed(1, 288) and not IsControlPressed(2, 288) ) and not ESX.UI.Menu.IsOpen('default',  GetCurrentResourceName(), 'menu_perso') and (GetGameTimer() - GUI.Time) > 150) then
				TriggerEvent('NB:closeAllSubMenu')
				TriggerEvent('NB:closeAllMenu')
				TriggerEvent('NB:openMenuPersonnel')
				GUI.Time  = GetGameTimer()
			end
			
			if ( (IsControlPressed(0, 7) and not IsControlPressed(1, 288) and not IsControlPressed(2, 288) ) and ESX.UI.Menu.IsOpen('default',  GetCurrentResourceName(), 'menu_perso') and (GetGameTimer() - GUI.Time) > 150) then
				TriggerEvent('NB:closeAllSubMenu')
				TriggerEvent('NB:closeAllMenu')
				GUI.Time  = GetGameTimer()
			end
		end]]
		
	end
end)

RegisterNetEvent('NB:closeAllSubMenu')
AddEventHandler('NB:closeAllSubMenu', function()
	TriggerEvent('NB:closeMenuAmbulance')
	TriggerEvent('NB:closeMenuPolice')
	TriggerEvent('NB:closeMenuMecano')
	TriggerEvent('NB:closeMenuInventaire')
	TriggerEvent('NB:closeMenuPersonnel')
end)

RegisterNetEvent('NB:closeAllMenu')
AddEventHandler('NB:closeAllMenu', function()
	ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('NB:OpenDoubleJobMenu')
AddEventHandler('NB:OpenDoubleJobMenu', function()
	OpenDoubleJobMenu()
end)

--------------------------------------------------------------------------------------------
-- Fermeture des Menu
--------------------------------------------------------------------------------------------
-- Menu Perso
RegisterNetEvent('NB:closeMenuPersonnel')
AddEventHandler('NB:closeMenuPersonnel', function()

	if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_moi') then
		ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_moi')
		
	elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions') then
		if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Salute') then
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_actions_Salute')
		elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Humor') then
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_actions_Humor')
		elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Travail') then
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_actions_Travail')
		elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Festives') then
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_actions_Festives')
		elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Others') then
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_actions_Others')
		end
		ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_actions')
		
	elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_vehicule') then
		ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_vehicule')
		
	elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_gpsrapide') then
		ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_gpsrapide')
		
	elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_grade') then
		ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_grade')
		
	elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_modo') then
		ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_modo')
		
	end
end)

-- Inventaire
RegisterNetEvent('NB:closeMenuInventaire')
AddEventHandler('NB:closeMenuInventaire', function()
	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.UI.Menu.Close('default', 'es_extended', 'inventory')
		
	elseif ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory_item') then
		ESX.UI.Menu.Close('default', 'es_extended', 'inventory_item')
		
	elseif ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory_item_count_give') then
		ESX.UI.Menu.Close('default', 'es_extended', 'inventory_item_count_give')
		
	elseif ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory_item_count_remove') then
		ESX.UI.Menu.Close('default', 'es_extended', 'inventory_item_count_remove')
	end
end)

-- Telephone
RegisterNetEvent('NB:closeMenuTelephone')
AddEventHandler('NB:closeMenuTelephone', function()
	TriggerEvent('NB:closeAllMenu')
end)

-- Factures
RegisterNetEvent('NB:closeMenuFactures')
AddEventHandler('NB:closeMenuFactures', function()
	TriggerEvent('NB:closeAllMenu')
end)

-- Police
RegisterNetEvent('NB:closeMenuPolice')
AddEventHandler('NB:closeMenuPolice', function()
	if ESX.UI.Menu.IsOpen('default', 'esx_policejob', 'citizen_interaction') then
		ESX.UI.Menu.Close('default', 'esx_policejob', 'citizen_interaction')
		
	elseif ESX.UI.Menu.IsOpen('default', 'esx_policejob', 'vehicle_interaction') then
		ESX.UI.Menu.Close('default', 'esx_policejob', 'vehicle_interaction')
		
	elseif ESX.UI.Menu.IsOpen('default', 'esx_policejob', 'object_spawner') then
		ESX.UI.Menu.Close('default', 'esx_policejob', 'object_spawner')
	end
end)

-- Ambulance
RegisterNetEvent('NB:closeMenuAmbulance')
AddEventHandler('NB:closeMenuAmbulance', function()
	if ESX.UI.Menu.IsOpen('default', 'esx_ambulancejob', 'citizen_interaction') then
		ESX.UI.Menu.Close('default', 'esx_ambulancejob', 'citizen_interaction')
	end
end)

-- Mecano
RegisterNetEvent('NB:closeMenuMecano')
AddEventHandler('NB:closeMenuMecano', function()
	if ESX.UI.Menu.IsOpen('default', 'esx_mecanojob', 'citizen_interaction') then
		ESX.UI.Menu.Close('default', 'esx_mecanojob', 'citizen_interaction')
	end
end)



--------------------------------------------------------------------------------------------
-- Pause menu Cache L'HUD et ferme les menu
--------------------------------------------------------------------------------------------
--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if (IsPauseMenuActive() or IsControlPressed(1, Keys["TAB"])) and not IsPaused then
			IsPaused = true
			TriggerEvent('NB:closeAllSubMenu')
			TriggerEvent('NB:closeAllMenu')
			NBMenuIsOpen = false
			TriggerEvent('es:setMoneyDisplay', 0.0)
			ESX.UI.HUD.SetDisplay(0.0)
		elseif not (IsPauseMenuActive() or IsControlPressed(1, Keys["TAB"])) and IsPaused then
			IsPaused = false
			NBMenuIsOpen = false
			TriggerEvent('es:setMoneyDisplay', 1.0)
			ESX.UI.HUD.SetDisplay(1.0)
		end
	end
end)]]

Citizen.CreateThread(function()
	while true do

		Wait(10)
		
		if (ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menu_perso')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_moi')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Salute')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Humor')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Travail')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Festives')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Others')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_vehicule')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_vehicule_ouvrirportes')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_vehicule_fermerportes')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_gpsrapide')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_grade')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_modo')) or
		
		(ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory')) or
		(ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory_item')) or
		(ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory_item_count_give')) or
		(ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory_item_count_remove')) or
		
		(ESX.UI.Menu.IsOpen('default', 'esx_phone', 'main')) or
		
		(ESX.UI.Menu.IsOpen('default', 'esx_billing', 'billing')) or
		
		(ESX.UI.Menu.IsOpen('default', 'esx_policejob', 'police_actions')) or
		(ESX.UI.Menu.IsOpen('default', 'esx_policejob', 'citizen_interaction')) or
		(ESX.UI.Menu.IsOpen('default', 'esx_policejob', 'vehicle_interaction')) or
		(ESX.UI.Menu.IsOpen('default', 'esx_policejob', 'object_spawner')) or
		
		(ESX.UI.Menu.IsOpen('default', 'esx_ambulancejob', 'mobile_ambulance_actions')) or
		(ESX.UI.Menu.IsOpen('default', 'esx_ambulancejob', 'citizen_interaction')) or
		
		(ESX.UI.Menu.IsOpen('default', 'esx_mecanojob', 'MecanoActions')) or
		(ESX.UI.Menu.IsOpen('default', 'esx_mecanojob', 'citizen_interaction')) or
		(ESX.UI.Menu.IsOpen('default', 'esx_shops', 'shop')) 
		then
		
			NBMenuIsOpen = true
		
		else
		
			NBMenuIsOpen = false
			
		end
		
		if NBMenuIsOpen then
			local ply = GetPlayerPed(-1)
			local active = true 

			------------------------------------------------------------------------ FONCTION ACTION GTA -- codes here: https://pastebin.com/guYd0ht4
			DisablePlayerFiring(ply, active) -- desactive armes a feu
			--DisableControlAction(0, 1, active) -- mouvement camera horizontale
			--DisableControlAction(0, 2, active) -- mouvement camera verticale
			--DisableControlAction(0, 30,  active) -- Mouvement personnage horizontale
			--DisableControlAction(0, 31,  active) -- Mouvement personnage verticale
			DisableControlAction(0, 24, active) -- attaque
			DisableControlAction(0, 142, active) -- attaque de melee
			--DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
			
			DisableControlAction(0, 12, active) -- Selection d'arme roue
			DisableControlAction(0, 14, active) -- Selection d'arme suivante roue
			DisableControlAction(0, 15, active) -- Selection d'arme precedente roue
			DisableControlAction(0, 16, active) -- Selection d'arme suivante
			DisableControlAction(0, 17, active) -- Selection d'arme precedente
			DisableControlAction(0, 140, active) -- coup de poing
			DisableControlAction(0, 80, active) -- Camera aleatoire en voiture
			DisableControlAction(0, 73, active) -- Camera aleatoire en voiture
			
			if IsDisabledControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
				SendNUIMessage({type = "click"})
			end
		end
			break
	end
end)
