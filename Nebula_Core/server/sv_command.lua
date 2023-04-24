local function CanAccessModeration(source)
	local result = exports['Nebula_Core']:CanAccessModeration(source)
	if result then
		if result.canByPass then
			return true
		elseif result.canHandleCommand then
			return true
		else
			return false
		end
	else
		return false
	end
end

--ChatMessage
AddEventHandler('chatMessage', function(source, name, message)
    if string.sub(message, 1, string.len("/")) ~= "/" then
		TriggerClientEvent('chatMessage', source, "^5Inutile d\'écrire ici personnes ne verra ton message.")
		TriggerClientEvent('chatMessage', source, "^2utilise le /report pour signalé quelque chose aux membres du staff.")
    end
    CancelEvent()
end)

--annonce IG special
ESX.RegisterCommand('announcespecial', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then	
		TriggerClientEvent('Core:MessageMilieu', -1, "~y~Annonce", args.message, 1500)
		TriggerEvent('CoreLog:SendDiscordLog', 'Annonces modérateurs', "`[ANNONCE SPECIAL]` "..GetPlayerName(xPlayer.source) .. " a annoncé : `".. args.message .."`", 'Yellow', false, xPlayer.source)
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Ecrire un message pour tous les joueurs (bandeau)', validate = false, arguments = {
	{ help = 'Le message entre " " (ne pas oublier les guillemets début et fin)', name= 'message', type = 'string'}
}})

ESX.RegisterCommand('stopchat', "admin", function(xPlayer, args, showError)
	TriggerClientEvent('stopchat', xPlayer.source)
end, true, {help = 'Desactiver le chat modération'})


ESX.RegisterCommand('announce', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin" then
			if #args <= 0 then return end
			local message = args.message
			TriggerClientEvent('chatMessage', -1, "^3Annonce", { 30, 144, 255 }, message)
			TriggerEvent('CoreLog:SendDiscordLog', 'Annonces modérateurs', "`[ANNONCE ADMIN]` "..GetPlayerName(xPlayer.source) .. " a annoncé : `".. message .."`", 'Green', false, xPlayer.source)
		end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Ecrire un message dans le chat joueur IG à tous les joueurs', validate = false, arguments = {
	{ help = 'Le message entre " " (ne pas oublier les guillemets début et fin)', name= 'message', type = 'string'}
}})

ESX.RegisterCommand('dvall', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if xPlayer.getGroup() ~= "user" then
			TriggerClientEvent("wld:delallveh", -1) 
			TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, "Tous les véhicules ont été supprimés!")
		end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Supprimer tous les véhicules de la map'})

--start/stop whitelist
RegisterCommand('stopdiscord', function(source, args)
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)

		if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin" then
			Config.Discord.Enable = not Config.Discord.Enable
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Discord Whitelist : " .. Config.Discord.Enable)
		end
    else
		Config.Discord.Enable = not Config.Discord.Enable
	end
	print("Discord Whitelist : " .. tostring(Config.Discord.Enable))
end)

--Reply
RegisterCommand("reply", function(source, args, raw)
	local xPlayer = ESX.GetPlayerFromId(source)
	if #args <= 0 then return end
	local cm = Core.Math.StringSplit(raw, " ")
	if Core.Math.Tablelength(cm) > 2 then
		local tPID = tonumber(cm[2])
		local xTarget = ESX.GetPlayerFromId(tPID)
		local names2 = GetPlayerName(tPID)
		local names3 = GetPlayerName(source)
		local tFirstname = nil 
		local tLastname = nil
		if xTarget then
			if names2 and names3 then
				local textmsg = ""
				for i=1, #cm do
					if i ~= 1 and i ~= 2 then
						textmsg = (textmsg .. " " .. tostring(cm[i]))
					end
				end
				if xPlayer.getGroup() ~= 'user' or xTarget.getGroup() ~= 'user' then
					TriggerEvent('esx_jobcounter:returnTableMetierServer', function(tablePlayer)
						for k,v in pairs(tablePlayer) do
							if v.id == source then
								for m, n in pairs(tablePlayer) do
									if n.group ~= 'user' and n.id ~= source and n.id ~= tPID then
										TriggerClientEvent('chatMessage', n.id, "> [" .. source .. "] ".. v.firstname .. " " .. v.lastname .." à [" .. tPID .. "] ".. xTarget.firstname .. " " .. xTarget.lastname, {50, 255, 0})
									end
								end
								TriggerClientEvent('chatMessage', source, "Réponse envoyé à:^0 " .. xTarget.name .."^0  [" .. tPID .. "]", {205, 205, 0}, "", "reply")
								TriggerEvent('CoreLog:SendDiscordLog', 'Reply', "`[REPLY]` Réponse de **".. v.firstname .. " " .. v.lastname .."** [".. GetPlayerName(source) .."] | **"..source.. "** à **" .. xTarget.firstname .." "..xTarget.lastname.."** ["..GetPlayerName(tPID).."] | **"..tPID.. "** :`".. textmsg .."`", 'Red', tPID, source)
								TriggerClientEvent('chatMessage', tPID, "Réponse reçu par " .. names3 ..", pour répondre fait /reply " .. source .. " [MESSAGE]", {50, 255, 0}, textmsg, "reply")
							end
						end
					end, "tabName", "players")
				else
					TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insuficient Premissions!")
				end
			end
		else
			TriggerClientEvent('chatMessage', source, "REPLY", {255, 0, 0}, "Le joueur n'est pas en ligne !")
		end
	end
end)

ESX.RegisterCommand('pedname', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		TriggerClientEvent('NB:changepedname', args.playerId or xPlayer.source, args.pedname)
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Changer son ped', validate = false, arguments = {
	{name = "playerId", help = "ID du joueur", type='number'},
	{name = "pedname", help = "Nom du ped", type='string'}
}})

ESX.RegisterCommand('ped', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		TriggerClientEvent('NB:openPedMenu', args.playerId or xPlayer.source)
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Afficher le menu ped', validate = false, arguments = {
	{name = "playerId", help = "ID du joueur", type='number'}
}})

ESX.RegisterCommand('delitem', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		TriggerClientEvent('NB:RetirerItems', xPlayer.source, args.itemName)
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Supprimer un item sur vous', validate = true, arguments = {
	{name = "itemName", help = "Nom bdd de l'item", type='string'}
}})

ESX.RegisterCommand({'changeplateveh', 'cpveh'}, "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		TriggerClientEvent("Nebula_Core:ChangePlateAdmin", xPlayer.source, args.plate)
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Changer la plaque d\'immatriculation du véhicule', validate = true, arguments = {
	{name = "plate", help = "Nouvelle plaque d'immatriculation", type='string'}
}})

ESX.RegisterCommand('pedok', "admin", function(xPlayer, args, showError)
	if args.status == 1 then
		TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Tu as autorisé ~b~'..GetPlayerName(args.playerId)..'~w~ a faire un PED contributeur.')
		TriggerClientEvent('Core:ShowNotification', args.playerId, 'Tu as été ~b~autorisé~w~ a faire un PED contributeur.')
		TriggerEvent('CoreLog:SendDiscordLog', 'PED Contributeur', GetPlayerName(xPlayer.source) .. " a autorisé `"..GetPlayerName(args.playerId).."` a faire un ped contributeur.", 'Green', args.playerId, xPlayer.source)
	else
		TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Tu as enlevé l\'autorisation de ~b~'..GetPlayerName(args.playerId)..'~w~ a faire un PED contributeur.')
		TriggerClientEvent('Core:ShowNotification', args.playerId, 'Ton autorisation à faire un ped contributeur a été ~r~retirée~w~.')
		TriggerEvent('CoreLog:SendDiscordLog', 'PED Contributeur', GetPlayerName(xPlayer.source) .. " a enlevé l'autorisation de `"..GetPlayerName(args.playerId).."` a faire un ped contributeur.", 'Red', args.playerId, xPlayer.source)
	end
	local bool = args.status == 1
	TriggerClientEvent('Contributeur:AutoriserUnPed', args.playerId, bool)
end, true, {help = 'Autoriser un joueur a faire un PED contributeur', validate = true, arguments = {
	{name = "playerId", help = "ID du joueur", type = 'number'}, 
	{name = "status", help = "[0 ou 1]", type = 'number'}
}})

ESX.RegisterCommand('skin', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if args.playerId ~= nil then
			TriggerClientEvent('esx_skin:openSaveableMenu', args.playerId)
			TriggerEvent('CoreLog:SendDiscordLog', 'Apparence', "**"..GetPlayerName(xPlayer.source) .. "** a modifié l'apparence de **".. GetPlayerName(args.playerId).."**", 'Blue', xPlayer.source, args.playerId)
		  else
			xPlayer.triggerEvent('esx_skin:openSaveableMenu')
			TriggerEvent('CoreLog:SendDiscordLog', 'Apparence', "**"..GetPlayerName(xPlayer.source) .. "** a modifié l'apparence de son propre personnage.", 'Purple', false, xPlayer.source)
		  end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Ouvrir le menu skin', validate = false, arguments = {
	{help = 'Id du joueur (vide si pour sois)', name = 'playerId', type ='any'}
}})

ESX.RegisterCommand('skinsave', 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		xPlayer.triggerEvent('esx_skin:requestSaveSkin')
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Sauvegarder le joueur'})

ESX.RegisterCommand('reload', 'user', function(xPlayer, args, showError)	
	TriggerClientEvent('esx_skin:reloadskin', xPlayer.source)
	TriggerEvent('Core:SetCanHandleCommand', xPlayer.source, false)
end, {help = "Recharge l'apparence de ton personnage"})

-- END SKIN --

ESX.RegisterCommand('showlistplayerjob', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		TriggerEvent('esx_jobcounter:returnTableMetierServer', function(JobConnected) 
			if #JobConnected == 0 then
				TriggerClientEvent('chatMessage', xPlayer.source, "SYSTEM", {255, 0, 0}, "Pas de joueur dans ce métier")
			else
				for k, v in pairs(JobConnected) do
					TriggerClientEvent('chatMessage', xPlayer.source, "SYSTEM", {255, 0, 0}, v.idServ .. " " .. v.identifier .. " " .. v.name .. " " .. v.job .. " " .. v.job2)
				end
			end
		end, "tab", args.jobname)
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Voir la liste des joueurs par métier', validate = false, arguments = {
	{help = 'Nom du job', name = 'jobname', type = 'string'}
}})

ESX.RegisterCommand('announcejob', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if args.message then
			TriggerEvent('esx_jobcounter:returnTableMetierServer', function(JobConnected) 
				for k, v in pairs(JobConnected) do
					TriggerClientEvent('chatMessage', v.idServ, "ANNONCE", {255, 0, 0}, args.message)
				end
				if (#JobConnected > 0 ) then
					TriggerClientEvent('chatMessage', xPlayer.source, "ANNONCE", {255, 0, 0}, "Message d'annonce bien envoyé aux personnes en service pour le job " .. args.jobname)
				else
					TriggerClientEvent('chatMessage', xPlayer.source, "ANNONCE", {255, 0, 0}, "Aucune personne en service pour le job " .. args.jobname)
				end
			end, "tab", args.jobname)
		end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Ecrire un message pour tous les joueurs d\'un job en service', validate = false, arguments = {
	{ help = 'Nom du job a qui envoyer le message', name= 'jobname', type = 'string'},
	{ help = 'Le message entre " " (ne pas oublier les guillemets début et fin)', name= 'message', type = 'string'}
}})

ESX.RegisterCommand('massrp', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if args.message then
			TriggerEvent('esx_jobcounter:returnTableMetierServer', function(JobConnected) 
				for k, v in pairs(JobConnected) do
					TriggerClientEvent('chatMessage', v.idServ, "[MASSRP]", {255, 0, 0}, args.message)
				end
				if (#JobConnected > 0 ) then
					TriggerClientEvent('chatMessage', xPlayer.source, "ANNONCE", {255, 0, 0}, "Message de Mass RP bien envoyé aux personnes en service pour le job " .. args.jobname)
				else
					TriggerClientEvent('chatMessage', xPlayer.source, "ANNONCE", {255, 0, 0}, "Aucune personne en service pour le job " .. args.jobname)
				end
			end, "tab", args.jobname)
		end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Ecrire un message pour tous les joueurs d\'un job en service', validate = false, arguments = {
	{ help = 'Nom du job a qui envoyer le message (police / sheriff / doj / gouv)', name= 'jobname', type = 'string'},
	{ help = 'Le message entre " " (ne pas oublier les guillemets début et fin)', name= 'message', type = 'string'}
}})

ESX.RegisterCommand('revive', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if args.playerId ~= nil then
			TriggerClientEvent('esx_ambulancejob:revive', args.playerId)
			TriggerEvent('CoreLog:SendDiscordLog', 'Réanimation', GetPlayerName(xPlayer.source) .. " a **réanimé** ".. GetPlayerName(args.playerId), 'Grey', xPlayer.source, args.playerId)
		else
			TriggerClientEvent('esx_ambulancejob:revive', xPlayer.source)
			TriggerEvent('CoreLog:SendDiscordLog', 'Réanimation', GetPlayerName(xPlayer.source) .. " s'est réanimer.", 'Grey', false, xPlayer.source)
		end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Revive la personne', validate = false, arguments = {
  {help = 'Id du joueur (vide si pour sois)', name ='playerId', type = 'any'}
}})


ESX.RegisterCommand('announceweazel', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if args.message then
			TriggerEvent('CoreLog:SendDiscordLog', 'Annonces modérateurs', "`[ANNONCE WEAZEL NEWS]` "..GetPlayerName(xPlayer.source) .. " a annoncé : `".. args.message .."`", 'Purple', false, xPlayer.source)
			TriggerClientEvent('Core:MessageLifeInvader', -1, 0.588, 0.09, 0.005, 0.0028, 0.8, "~r~WEAZEL NEWS ~d~", 255, 255, 255, 255, 1, 0)
			TriggerClientEvent('Core:MessageLifeInvader', -1, 0.586, 0.150, 0.005, 0.0028, 0.6, args.message, 255, 255, 255, 255, 7, 0)
			TriggerClientEvent('Core:MessageLifeInvader', -1, 0.588, 0.246, 0.005, 0.0028, 0.4, "", 255, 255, 255, 255, 0, 0)
		end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
  end, true, { help = 'Envoyez un message bandeau Weazel News', validate = false, arguments = {
	{ help = 'Le message entre " " (ne pas oublier les guillemets début et fin)', name= 'message', type = 'string'}
}})

ESX.RegisterCommand('customveh', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		TriggerClientEvent("esxlscustom:menuadmin", xPlayer.source) 
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Afficher le menu de customisation des véhicules'})