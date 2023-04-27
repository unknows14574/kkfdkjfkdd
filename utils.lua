
ESX = nil
PlayerData = {}
local service = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
	PlayerData2 = ESX.GetPlayerData()

	SetStaticEmitterEnabled('se_dlc_biker_tequilala_exterior_emitter', false) -- désactivation musique exterieur tequila
	SetStaticEmitterEnabled('collision_9qv4ecm', false) -- désactivation musique interieur tequila

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	jobs_refreshBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	PlayerData.job = job
	jobs_deleteBlips()
	jobs_refreshBlips()

	-- Trigger des logs de service
	service = ESX.PlayerData.job.service
	xPiwel_LogsService()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
	PlayerData.job2 = job2
	jobs_deleteBlips()
	jobs_refreshBlips()

	-- Trigger des logs de service
	service = ESX.PlayerData.job2.service
	xPiwel_LogsService()
end)

RegisterNetEvent('esx:setService')
AddEventHandler('esx:setService', function(job, isDuty)
  if PlayerData.job.name == job then
	PlayerData.job.service = isDuty
  elseif PlayerData.job2.name == job then
	PlayerData.job2.service = isDuty
  end
  if isDuty == 1 then
	jobs_refreshBlips()
  elseif isDuty == 0 then
  	jobs_deleteBlips()
  end

	-- Trigger des logs de service
	service = isDuty
	xPiwel_LogsService()
end)

-- Logs de service
function xPiwel_LogsService()
	while service == nil do
		Citizen.Wait(10)
	end
	if PlayerData.job or PlayerData.job2 ~= nil then
		if PlayerData.job.name == "mecano" or PlayerData.job2.name == "mecano" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Bennys - Service', "`[SERVICE]` **".. GetPlayerName(PlayerId()) .. "** " .. (service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service') .."", (service == 1 and 'Green' or service == 0 and 'Red'))
		elseif PlayerData.job.name == "mecano2" or PlayerData.job2.name == "mecano2" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Mecano Sandy Shores - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))
		elseif PlayerData.job.name == "tequi" or PlayerData.job2.name == "tequi" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Tequi-La-La - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))		
		elseif PlayerData.job.name == "journaliste" or PlayerData.job2.name == "journaliste" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Weazel News - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))
		elseif PlayerData.job.name == "musicrecord" or PlayerData.job2.name == "musicrecord" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Music Record - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))
		elseif PlayerData.job.name == "arcade" or PlayerData.job2.name == "arcade" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Arcadian Bar - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))
		elseif PlayerData.job.name == "gruppe6" or PlayerData.job2.name == "gruppe6" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Gruppe6 - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))
		elseif PlayerData.job.name == "upnatom" or PlayerData.job2.name == "upnatom" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Up N Atom - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))
		elseif PlayerData.job.name == "event" or PlayerData.job2.name == "event" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Unicorn - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))
		elseif PlayerData.job.name == "mboubar" or PlayerData.job2.name == "mboubar" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Le Phare Ouest - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))
		elseif PlayerData.job.name == "gouv" or PlayerData.job2.name == "gouv" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Gouvernement - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))	
		elseif PlayerData.job.name == "prison" or PlayerData.job2.name == "prison" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Prison - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))
		elseif PlayerData.job.name == "police" or PlayerData.job2.name == "police" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'LSPD - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))	
		elseif PlayerData.job.name == "sheriff" or PlayerData.job2.name == "sheriff" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Sheriff - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))	
		elseif PlayerData.job.name == "flywheels" or PlayerData.job2.name == "flywheels" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Mosley - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))		
		elseif PlayerData.job.name == "galaxy" or PlayerData.job2.name == "galaxy" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Galaxy - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))		
		elseif PlayerData.job.name == "diner" or PlayerData.job2.name == "diner" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Black Wood - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))		
		elseif PlayerData.job.name == "eightpool" or PlayerData.job2.name == "eightpool" then
			TriggerServerEvent('CoreLog:SendDiscordLog', '8 Pool Bar - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))		
		elseif PlayerData.job.name == "bahama" or PlayerData.job2.name == "bahama" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Bahama - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))		
		elseif PlayerData.job.name == "coffee" or PlayerData.job2.name == "coffee" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Bean Coffee - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** ".. (service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service') .."", (service == 1 and 'Green' or service == 0 and 'Red'))		
		elseif PlayerData.job.name == "yellow" or PlayerData.job2.name == "yellow" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Yellow Jack - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))		
		elseif PlayerData.job.name == "hooka" or PlayerData.job2.name == "hooka" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Hookah Lounge - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))		
		elseif PlayerData.job.name == "casino" or PlayerData.job2.name == "casino" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Casino - Service', "`[SERVICE]` **".. GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))
		elseif PlayerData.job.name == "pizzathis" or PlayerData.job2.name == "pizzathis" then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Pizza This - Service', "`[SERVICE]` **"..GetPlayerName(PlayerId()) .. "** "..(service == 1 and 'a pris son service' or service == 0 and 'a pris sa fin de service').."", (service == 1 and 'Green' or service == 0 and 'Red'))		
		end
		service = nil
	end
end

--Restart Ressource
AddEventHandler('onClientResourceStart', function (resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerServerEvent("Core:restartRessource")
    end
end)

RegisterNetEvent('Core:playerLoaded')
AddEventHandler('Core:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	jobs_deleteBlips()
	jobs_refreshBlips()
end)

playerPed = nil
coords = nil
playerID = nil
currentWeaponHash = nil
currentVeh = nil
inVeh = nil
IsHandcuffed = false -- Police menottes
IsDragged  = false -- Police escorter

Citizen.CreateThread(function()
	while true do
		playerID = PlayerId()
		playerPed = PlayerPedId()
		currentWeaponHash = GetSelectedPedWeapon(playerPed)
		currentVeh = GetVehiclePedIsIn(playerPed)
		inVeh = IsPedInAnyVehicle(playerPed, false)
		coords = GetEntityCoords(playerPed)
        Citizen.Wait(1000)
    end
end)

function DrawText3D_gutu(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end
