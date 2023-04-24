ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--Connecting Player
AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
	local _source = source
	if Config.Maintenance then
		deferrals.defer()
		deferrals.update("Il semblerait que Nebula soit en maintenance, vérifions si tu es autorisé à te connecter.")
		local identifier = "steam:"..GetIdentifierForPlayer(_source, "steam")

		if Config.MaintenanceAllowId[identifier] then
			deferrals.done()
		else
			deferrals.done("Bonjour, le serveur est en maintenance, plus d'informations sur: discord.gg/nebularp")
		end

		-- MySQL.query('SELECT `group`,`firstname` FROM users WHERE `identifier`=@identifier LIMIT 1;', {identifier = identifier}, function(users)
		-- 	if users[1].group and users[1].firstname then
		-- 		if users[1].group == "superadmin" then
		-- 			deferrals.done()
		-- 			return
		-- 		else
		-- 			deferrals.done("Bonjour "..users[1].firstname..", le serveur est en maintenance, plus d'informations sur: discord.gg/nebularp")
		-- 			return
		-- 		end
		-- 	else
		-- 		deferrals.done("Une erreur s'est produite, veuillez contacter le support: discord.gg/nebularp")
		-- 	end
		-- end)
	elseif Config.Discord.Enable then
		DiscordWhitelist(deferrals, _source)
	end
end)

RegisterCommand('maintenance', function (source, args, rawCommand)
    if tonumber(source) > 0 then return end
	Config.Maintenance = not Config.Maintenance
	print("^7Etat de maintenance modifié. Nouvel état: ", Config.Maintenance)
end, true)

AddEventHandler('esx:playerLoaded', function(source)
	local playerIdentifier = GetIdentifierForPlayer(source)
	
	SendDiscordLog("Connexion / Déconnexion", "**" .. GetPlayerName(source) .. "** est connecté" .. GetIdentifierPlayerForLog(source), "Green")
	if playerIdentifier ~= nil and playerIdentifier.steam ~= nil then
		MySQL.update.await('UPDATE `users` SET `last_connexion` = @lastConnexion WHERE identifier = @identifier', {
			['@lastConnexion'] = os.date('%Y-%m-%d %H:%M:%S', os.time()),
			['@identifier'] = 'steam:'..tostring(playerIdentifier.steam)
		})
	end
end)

--Deconnecting Player
AddEventHandler('playerDropped', function (reason)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	SendDiscordLog("Connexion / Déconnexion", "**" .. GetPlayerName(_source) .. "** vient de déconnecter \n**Raison:** `" .. reason .. "`" .. GetIdentifierPlayerForLog(_source), "Red")
	if xPlayer ~= nil then

		-- INTERIM TAXI JOB 
		if xPlayer.job.name == 'taxi' then
			xPlayer.setJob('unemployed', 0)
			xPlayer.setService('unemployed', 1)
		end

		local playerJobActive = xPlayer.job.service or xPlayer.job.service == 1
		if xPlayer.job.name ~= "unemployed" and playerJobActive then
			xPlayer.setService(xPlayer.job.name, 0) 
		end
		if playerJobActive then
			if xPlayer.job.name == "mecano" then
				SendDiscordLog("Bennys - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")
			elseif xPlayer.job.name == "mecano2" then
				SendDiscordLog("Mecano Sandy Shores - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")
			elseif xPlayer.job.name == "tequi" then
				SendDiscordLog("Tequi-La-La - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")		
			elseif xPlayer.job.name == "journaliste" then
				SendDiscordLog("Weazel News - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")
			elseif xPlayer.job.name == "musicrecord" then
				SendDiscordLog("Music Record - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")
			elseif xPlayer.job.name == "arcade" then
				SendDiscordLog("Arcadian Bar - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")
			elseif xPlayer.job.name == "gruppe6" then
				SendDiscordLog("Gruppe6 - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")
			elseif xPlayer.job.name == "upnatom" then
				SendDiscordLog("Up N Atom - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")
			elseif xPlayer.job.name == "event" then
				SendDiscordLog("Unicorn - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")
			elseif xPlayer.job.name == "mboubar" then
				SendDiscordLog("Le Phare Ouest - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")
			elseif xPlayer.job.name == "gouv" then
				SendDiscordLog("Gouvernement - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")
			elseif xPlayer.job.name == "prison" then
				SendDiscordLog("Prison - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")	
			elseif xPlayer.job.name == "police" then
				SendDiscordLog("LSPD - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")	
			elseif xPlayer.job.name == "sheriff" then
				SendDiscordLog("Sheriff - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")	
			elseif xPlayer.job.name == "flywheels" then
				SendDiscordLog("Mosley - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")	
			elseif xPlayer.job.name == "galaxy" then
				SendDiscordLog("Galaxy - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")	
			elseif xPlayer.job.name == "diner" then
				SendDiscordLog("Black Wood - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")	
			elseif xPlayer.job.name == "eightpool" then
				SendDiscordLog("8 Pool Bar - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")	
			elseif xPlayer.job.name == "bahama" then
				SendDiscordLog("Bahama - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")	
			elseif xPlayer.job.name == "coffee" then
				SendDiscordLog("Bean Coffee - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")	
			elseif xPlayer.job.name == "yellow" then
				SendDiscordLog("Yellow Jack - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")	
			elseif xPlayer.job.name == "hooka" then
				SendDiscordLog("Hookah Lounge - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")	
			elseif xPlayer.job.name == "casino" then
				SendDiscordLog("Casino - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")	
			elseif xPlayer.job.name == "pizzathis" then
				SendDiscordLog("Pizza This - Service", "`[SERVICE]` **"..GetPlayerName(_source) .. "** a pris sa fin de service." .. GetIdentifierPlayerForLog(_source), "Red")
			end
		end
		-- Reset hair of the player if he deconnect using the pince
        TriggerClientEvent('esx_pince_hair', _source, true)
	end
end)

--AddDiscordContrib
RegisterServerEvent("Core:AddDiscordContrib")
AddEventHandler('Core:AddDiscordContrib', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local TableContrib = {"📱 Contributeur #13", "📱 Contributeur #12", "📱 Contributeur #11", "📱 Contributeur #10", "📱 Contributeur #9", "📱 Contributeur #8", "📱 Contributeur #7", "📱 Contributeur #6", "📱 Contributeur #5", "📱 Contributeur #4"}
	local IsContrib = DiscordIsRolePresent(source, TableContrib)
	MySQL.update.await('UPDATE users SET `contrib` = @contrib WHERE identifier = @identifier', {
		['@contrib'] = IsContrib,
		['@identifier'] = xPlayer.identifier
	})
end)

--Update ESX
RegisterServerEvent("Core:restartRessource")
AddEventHandler('Core:restartRessource', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then
		TriggerClientEvent('Core:playerLoaded', _source, {
			identifier   = xPlayer.identifier,
			accounts     = xPlayer.getAccounts(),
			inventory    = xPlayer.getInventory(),
			job          = xPlayer.getJob(),
			job2         = xPlayer.getJob2(),
			loadout      = xPlayer.getLoadout(),
			coords = xPlayer.getCoords(),
			money        = xPlayer.getMoney()
		})
	end
end)

--Player data
RegisterServerCallback('Core:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer ~= nil then
		TriggerEvent('es:getPlayerFromId', target, function(targetid)
			local result = MySQL.query.await("SELECT users.firstname, users.lastname, users.sex, users.dateofbirth, users.height, users.money, users.bank FROM users WHERE identifier = @identifier LIMIT 1", {
				['@identifier'] = xPlayer.identifier
			})

			local data = {
				coords 	  	= vector3(targetid.getCoords().x, targetid.getCoords().y, targetid.getCoords().z),
				name        = xPlayer.name,
				job         = xPlayer.job,
				job2        = xPlayer.job2,
				inventory   = xPlayer.inventory,
				accounts    = xPlayer.accounts,
				weapons     = xPlayer.loadout,
				firstname   = result[1]['firstname'],
				lastname    = result[1]['lastname'],
				sex         = result[1]['sex'],
				dob         = result[1]['dateofbirth'],
				height      = result[1]['height'] .. " Centimetre",
				money 	  	= result[1]['money'],
				bank 		= result[1]['bank']
			}

			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
			end)

			cb(data)
		end)
	end
end)

--annonce reboot
-- RegisterServerEvent("restart:checkreboot")
-- AddEventHandler('restart:checkreboot', function()
function AnnonceRestart()
	local date_local = os.date('%H:%M:%S', os.time())

	if date_local >= '08:14:45' and date_local <= '08:15:15' then TriggerClientEvent('Core:MessageMilieu', -1, "~y~Tempête en approche !", "Tempête dans 15 minutes.", 1500, true)
	elseif date_local >= '08:19:45' and date_local <= '08:20:15' then TriggerClientEvent('Core:MessageMilieu', -1, "~y~Tempête en approche !", "Tempête dans 10 minutes.", 1500, true)
	elseif date_local >= '08:24:45' and date_local <= '08:25:15' then TriggerClientEvent('Core:MessageMilieu', -1, "~y~Tempête en approche !", "Tempête dans 3 minutes.", 1500, true)
	elseif date_local >= '08:28:45' and date_local <= '08:29:15' then TriggerClientEvent('Core:MessageMilieu', -1, "~y~Tempête en approche !", "Tempête dans 1 minutes.", 1500, true)
	elseif date_local >= '08:29:45' and date_local <= '08:30:15'  then TriggerClientEvent('Core:MessageMilieu', -1, "~y~Tempête en approche !", "Extinction..", 1500, true)
	
	--elseif date_local >= '19:14:45' and date_local <= '19:15:15' then TriggerClientEvent('Core:MessageMilieu', -1, "~y~Tempête en approche !", "Tempête dans 15 minutes.", 1500, true)
	--elseif date_local >= '19:19:45' and date_local <= '19:20:15' then TriggerClientEvent('Core:MessageMilieu', -1, "~y~Tempête en approche !", "Tempête dans 10 minutes.", 1500, true)
	--elseif date_local >= '19:24:45' and date_local <= '19:25:15' then TriggerClientEvent('Core:MessageMilieu', -1, "~y~Tempête en approche !", "Tempête dans 3 minutes.", 1500, true)
	--elseif date_local >= '19:28:45' and date_local <= '19:29:15' then TriggerClientEvent('Core:MessageMilieu', -1, "~y~Tempête en approche !", "Tempête dans 1 minutes.", 1500, true)
	--elseif date_local >= '19:29:45' and date_local <= '19:30:15'  then TriggerClientEvent('Core:MessageMilieu', -1, "~y~Tempête en approche !", "Extinction..", 1500, true)

	end
end
--end)

-- SetTimeout(30000, AnnonceRestart)

-- function restart_server()
--SetTimeout(30000, AnnonceRestart)
-- 	SetTimeout(30000, function()
-- 		TriggerEvent('restart:checkreboot')
-- 		restart_server()
-- 	end)
-- end
-- restart_server()

--SirenVehicle
RegisterServerEvent('SilentSiren')
AddEventHandler('SilentSiren', function(Toggle)
    TriggerClientEvent('updateSirens', -1, source, Toggle)
end)

--CarWash
RegisterServerEvent('cleanveh:clean')
AddEventHandler('cleanveh:clean', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeMoney(tonumber(price))
	
	TriggerClientEvent('Core:ShowNotification', source, "~y~Votre véhicule a été nettoyé pour ~r~$" .. tonumber(price))
end)

--GetAllPlayers
RegisterServerCallback('Core:GetAllPlayers', function(source, cb)
	cb(GetPlayers())
end)


--Boucle 30s
Citizen.CreateThread(function()
    while true do Citizen.Wait(30000)
        SetActivityDiscord()
        AnnonceRestart()
	end
end)

--GiveItem
RegisterServerEvent('Core-Give:Item')
AddEventHandler('Core-Give:Item', function(nameItem, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem(nameItem, amount)
end)

-- Illegal Activity Can Be trigger
ESX.RegisterServerCallback("Core:allCopsCanBeTrigger",function(source, cb, copsNeeded)
	local iOnline = 0
	TriggerEvent('esx_jobcounter:returnTableMetierServer', function(JobConnected, JobConnected1) 
		iOnline = JobConnected + JobConnected1
	end, "numberLineTab", "police", "sheriff")
	if iOnline >= copsNeeded then
		cb(true)
	else 
		cb(false)
	end
end)

ESX.RegisterServerCallback("Core:onlyPoliceCanBeTrigger",function(source, cb, copsNeeded)
	local iOnline = 0
	TriggerEvent('esx_jobcounter:returnTableMetierServer', function(JobConnected) 
		iOnline = JobConnected
	end, "numberLineTab", "police")
	if iOnline >= copsNeeded then
		cb(true)
	else 
		cb(false)
	end
end)

ESX.RegisterServerCallback("Core:onlySheriffCanBeTrigger",function(source, cb, copsNeeded)
	local iOnline = 0
	TriggerEvent('esx_jobcounter:returnTableMetierServer', function(JobConnected) 
		iOnline = JobConnected
	end, "numberLineTab", "sheriff")
	if iOnline >= copsNeeded then
		cb(true)
	else 
		cb(false)
	end
end)
