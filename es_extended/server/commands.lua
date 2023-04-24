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

ESX.RegisterCommand({'tp', 'setcoords' }, 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		xPlayer.setCoords({x = args.x, y = args.y, z = args.z})
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, false, {help = _U('command_setcoords'), validate = true, arguments = {
	{name = 'x', help = _U('command_setcoords_x'), type = 'number'},
	{name = 'y', help = _U('command_setcoords_y'), type = 'number'},
	{name = 'z', help = _U('command_setcoords_z'), type = 'number'}
}})

ESX.RegisterCommand('setjob', 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if ESX.DoesJobExist(args.job, args.grade) then
			args.playerId.setJob(args.job, args.grade)

			if args.playerId.firstname and args.playerId.lastname then
				TriggerEvent('CoreLog:SendDiscordLog', 'SetJob', GetPlayerName(xPlayer.source).." a `setjob` en [JOB 1] **"..args.playerId.firstname.." "..args.playerId.lastname.. " ["..GetPlayerName(args.playerId.source).."]** au job `"..args.job.."` grade `"..args.grade.."`", 'Purple', xPlayer.source, args.playerId.source)
			else
				TriggerEvent('CoreLog:SendDiscordLog', 'SetJob', GetPlayerName(xPlayer.source).." a `setjob` en [JOB 1] **["..GetPlayerName(args.playerId.source).."]** au job `"..args.job.."` grade `"..args.grade.."`", 'Purple', xPlayer.source, args.playerId.source)
			end

		else
			showError(_U('command_setjob_invalid'))
		end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = _U('command_setjob'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'job', help = _U('command_setjob_job'), type = 'string'},
	{name = 'grade', help = _U('command_setjob_grade'), type = 'number'}
}})

ESX.RegisterCommand('setjob2', 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if ESX.DoesJobExist(args.job2, args.grade) then
			args.playerId.setJob2(args.job2, args.grade)

			local playerSet = ESX.GetPlayerFromId(args.playerId.source)
			if playerSet.firstname and playerSet.lastname then
				TriggerEvent('CoreLog:SendDiscordLog', 'SetJob', GetPlayerName(xPlayer.source).." a `setjob` en [JOB 2] **"..playerSet.firstname.." "..playerSet.lastname.. " ["..GetPlayerName(args.playerId.source).."]** au job `"..args.job2.."` grade `"..args.grade.."`", 'Purple', xPlayer.source, args.playerId.source)
			else
				TriggerEvent('CoreLog:SendDiscordLog', 'SetJob', GetPlayerName(xPlayer.source).." a `setjob` en [JOB 2] **["..GetPlayerName(args.playerId.source).."]** au job `"..args.job2.."` grade `"..args.grade.."`", 'Purple', xPlayer.source, args.playerId.source)
			end
		else
			showError(_U('command_setjob_invalid'))
		end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = _U('command_setjob'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'job2', help = _U('command_setjob_job'), type = 'string'},
	{name = 'grade', help = _U('command_setjob_grade'), type = 'number'}
}})

ESX.RegisterCommand('setservice', 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if args.playerId ~= nil then
			args.playerId.setService(args.playerId.job.name, args.status)
			TriggerClientEvent('Core:ShowNotification',  args.playerId, "✅ Service job1 de ~b~"..xPlayer.name.."~w~ défini sur ~y~".. args.status)
			if args.status == 1 then
				TriggerClientEvent('Core:ShowNotification',  args.playerId,"~h~Vous êtes maintenant en service!", true, false, 210)
			else
				TriggerClientEvent('Core:ShowNotification',  args.playerId,"~h~Vous êtes maintenant hors service.", true, false, 130)
			end
		end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, false, {help = 'Définir le status du job 1', validate = false, arguments = {
	{name = 'playerId', help = _U('command_setjob_job'), type = 'player'},
	{name = 'status', help = "[0 - 1]", type = 'number'}
}})

ESX.RegisterCommand('setservice2', 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if args.playerId ~= nil then
			args.playerId.setService(args.playerId.job.name, args.status)
			TriggerClientEvent('Core:ShowNotification', xPlayer.source, "✅ Service job2 de ~b~"..xPlayer.name.."~w~ défini sur ~y~".. args.status)
			if args.status == 1 then
				TriggerClientEvent('Core:ShowNotification', args.playerId,"~h~Vous êtes maintenant en service!", true, false, 210)
			else
				TriggerClientEvent('Core:ShowNotification', args.playerId,"~h~Vous êtes maintenant hors service.", true, false, 130)
			end
		end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end

end, false, {help = 'Définir le status du job 2', validate = false, arguments = {
	{name = 'playerId', help = _U('command_setjob_job'), type = 'player'},
	{name = 'status', help = "[0 - 1]", type = 'number'}
}})

ESX.RegisterCommand('car', 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		xPlayer.triggerEvent('esx:spawnVehicleAdmin', args.car)
		TriggerEvent('CoreLog:SendDiscordLog', 'Spawn de véhicule', "**"..GetPlayerName(xPlayer.source) .. "** s'est fait apparaitre un véhicule. **[".. args.car .. "]**", 'Green', false, xPlayer.source)
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end

end, false, {help = _U('command_car'), validate = false, arguments = {
	{name = 'car', help = _U('command_car_car'), type = 'any'}
}})

ESX.RegisterCommand({'cardel', 'dv'}, 'admin', function(xPlayer, args, showError)
	-- if not args.radius then args.radius = 4 end
	xPlayer.triggerEvent('esx:deleteVehicle', args.radius)
end, false, {help = _U('command_cardel'), validate = false, arguments = {
	{name = 'radius', help = _U('command_cardel_radius'), type = 'any'}
}})

ESX.RegisterCommand('fixveh', 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then		
		if args.playerId then
			TriggerClientEvent('esx:fixVehiclePlayer', args.playerId)
			TriggerEvent('CoreLog:SendDiscordLog', 'Réparation de véhicule', "**"..GetPlayerName(xPlayer.source) .. "** a réparer le véhicule de ".. GetPlayerName(args.playerId) .. "", 'Green', args.playerId, xPlayer.source)
		else
			TriggerClientEvent('esx:fixVehiclePlayer', xPlayer.source)
			TriggerEvent('CoreLog:SendDiscordLog', 'Réparation de véhicule', "**"..GetPlayerName(xPlayer.source) .. "** a réparer son propre véhicule", 'Green', args.playerId, xPlayer.source)
		end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, false, {help = 'Réparer le véhicule', validate = false, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'any'},
}})

ESX.RegisterCommand('setaccountmoney', 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then		
		if args.playerId.getAccount(args.account) then
			args.playerId.setAccountMoney(args.account, args.amount)
			TriggerEvent('CoreLog:SendDiscordLog', 'Give Items / Argent / Armes', "**"..GetPlayerName(xPlayer.source) .. "** a donné x".. args.amount .. " ".. args.account .. " à **".. GetPlayerName(args.playerId.source).."**", 'Pink', ((xPlayer.source ~= tonumber(args.playerId.source) and xPlayer.source) or false), args.playerId.source)
		else
			showError(_U('command_giveaccountmoney_invalid'))
		end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = _U('command_setaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_setaccountmoney_amount'), type = 'number'}
}})

ESX.RegisterCommand('giveaccountmoney', 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if args.playerId.getAccount(args.account) then
			args.playerId.addAccountMoney(args.account, args.amount, "Remboursement gouvernemental", "gouv")
			TriggerEvent('CoreLog:SendDiscordLog', 'Give Items / Argent / Armes', "**"..GetPlayerName(xPlayer.source) .. "** a donné x".. args.amount .. " ".. args.account .. " à **".. GetPlayerName(args.playerId.source).."**", 'Pink', ((xPlayer.source ~= tonumber(args.playerId.source) and xPlayer.source) or false), args.playerId.source)
		else
			showError(_U('command_giveaccountmoney_invalid'))
		end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = _U('command_giveaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_giveaccountmoney_amount'), type = 'number'}
}})

if not Config.OxInventory then
	ESX.RegisterCommand('giveitem', 'admin', function(xPlayer, args, showError)
		if CanAccessModeration(xPlayer.source) then
			args.playerId.addInventoryItem(args.item, args.count)
			TriggerEvent('CoreLog:SendDiscordLog', 'Give Items / Argent / Armes', "**"..GetPlayerName(xPlayer.source) .. "** a donné x".. args.count .. " ".. ESX.GetItemLabel(args.item) .. " à **".. GetPlayerName(args.playerId.source).."**", 'Pink', ((xPlayer.source ~= tonumber(args.playerId.source) and xPlayer.source) or false), args.playerId.source)
		else
			showError('Vous n\'avez pas les permissions necessaires')
		end

	end, true, {help = _U('command_giveitem'), validate = true, arguments = {
		{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
		{name = 'item', help = _U('command_giveitem_item'), type = 'item'},
		{name = 'count', help = _U('command_giveitem_count'), type = 'number'}
	}})

	ESX.RegisterCommand('giveweapon', 'admin', function(xPlayer, args, showError)
		if CanAccessModeration(xPlayer.source) then
			if args.playerId.hasWeapon(args.weapon) then
				showError(_U('command_giveweapon_hasalready'))
			else
				args.playerId.addInventoryItem(string.lower(args.weapon), 1)
				TriggerEvent('CoreLog:SendDiscordLog', 'Give Items / Argent / Armes', "**"..GetPlayerName(xPlayer.source) .. "** a donné x1 ".. ESX.GetItemLabel(args.item) .. " à **".. GetPlayerName(args.playerId.source).."**", 'Pink', ((xPlayer.source ~= tonumber(args.playerId.source) and xPlayer.source) or false), args.playerId.source)

			end
		else
			showError('Vous n\'avez pas les permissions necessaires')
		end
	end, true, {help = _U('command_giveweapon'), validate = true, arguments = {
		{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
		{name = 'weapon', help = _U('command_giveweapon_weapon'), type = 'weapon'},
		{name = 'ammo', help = _U('command_giveweapon_ammo'), type = 'number'}
	}})

	ESX.RegisterCommand('giveweaponcomponent', 'admin', function(xPlayer, args, showError)
		if CanAccessModeration(xPlayer.source) then
			if args.playerId.hasWeapon(args.weaponName) then
				local component = ESX.GetWeaponComponent(args.weaponName, args.componentName)

				if component then
					if args.playerId.hasWeaponComponent(args.weaponName, args.componentName) then
						showError(_U('command_giveweaponcomponent_hasalready'))
					else
						args.playerId.addWeaponComponent(args.weaponName, args.componentName)
					end
				else
					showError(_U('command_giveweaponcomponent_invalid'))
				end
			else
				showError(_U('command_giveweaponcomponent_missingweapon'))
			end
		else
			showError('Vous n\'avez pas les permissions necessaires')
		end
	end, true, {help = _U('command_giveweaponcomponent'), validate = true, arguments = {
		{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
		{name = 'weaponName', help = _U('command_giveweapon_weapon'), type = 'weapon'},
		{name = 'componentName', help = _U('command_giveweaponcomponent_component'), type = 'string'}
	}})
end

ESX.RegisterCommand({ 'disc', 'disconnect' }, 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		DropPlayer(args.playerId.source, 'You have been disconnected')
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, false, {help = _U('command_clear'), validate = false, argumentes = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand({'clear', 'cls'}, 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('chat:clear')
end, false, {help = _U('command_clear')})

ESX.RegisterCommand({'clearall', 'clsall'}, 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		TriggerClientEvent('chat:clear', -1)
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, false, {help = _U('command_clearall')})

if not Config.OxInventory then
	ESX.RegisterCommand('clearinventory', 'admin', function(xPlayer, args, showError)
		if CanAccessModeration(xPlayer.source) then
			for k,v in ipairs(args.playerId.inventory) do
				if v.count > 0 then
					args.playerId.setInventoryItem(v.name, 0)
				end
			end
		else
			showError('Vous n\'avez pas les permissions necessaires')
		end
	end, true, {help = _U('command_clearinventory'), validate = true, arguments = {
		{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
	}})

	ESX.RegisterCommand('clearloadout', 'admin', function(xPlayer, args, showError)
		if CanAccessModeration(xPlayer.source) then
			for i=#args.playerId.loadout, 1, -1 do
				args.playerId.removeWeapon(args.playerId.loadout[i].name)
			end
		else
			showError('Vous n\'avez pas les permissions necessaires')
		end
	end, true, {help = _U('command_clearloadout'), validate = true, arguments = {
		{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
	}})
end

ESX.RegisterCommand('setgroup', 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if not args.playerId then args.playerId = xPlayer.source end
		args.playerId.setGroup(args.group)
		TriggerEvent('CoreLog:SendDiscordLog', 'SetGroup', GetPlayerName(xPlayer.source).." a `setgroup` **"..args.playerId.firstname.." "..args.playerId.lastname.. " ["..GetPlayerName(args.playerId.source).."]** au group `"..args.group, 'Purple', xPlayer.source, args.playerId.source)
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = _U('command_setgroup'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'group', help = _U('command_setgroup_group'), type = 'string'},
}})

ESX.RegisterCommand('save', 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		Core.SavePlayer(args.playerId)
		print("[^2Info^0] Saved Player!")
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = _U('command_save'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('saveall', 'admin', function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		Core.SavePlayers()
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = _U('command_saveall')})

ESX.RegisterCommand('group', {"user", "admin"}, function(xPlayer, args, showError)
	print(xPlayer.getName()..", You are currently: ^5".. xPlayer.getGroup() .. "^0")
end, true)

ESX.RegisterCommand('goto', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		local targetCoords = args.playerId.getCoords()
		xPlayer.setCoords(targetCoords)
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = _U('goto'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('bring', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		local playerCoords = xPlayer.getCoords()
		args.playerId.setCoords(playerCoords)
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = _U('bring'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('kill', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		args.playerId.triggerEvent("esx:killPlayer")
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = _U('kill'), validate = true, arguments = {
{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('freeze', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		args.playerId.triggerEvent('esx:freezePlayer', "freeze")
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Freeze un joueur', validate = true, arguments = {
{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('unfreeze', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		args.playerId.triggerEvent('esx:freezePlayer', "unfreeze")
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Unfreeze un joueur', validate = true, arguments = {
{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('crash', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		args.playerId.triggerEvent('esx:adminCrash')
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Faire crash un joueur', validate = true, arguments = {
{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

local showname = {
	
}
ESX.RegisterCommand('showname', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if (showname[xPlayer.source] == nil) then
			showname[xPlayer.source] = false
		end

		if showname[xPlayer.source] then
			TriggerClientEvent("esx_showname:Disable", xPlayer.source, true)
		else
			TriggerClientEvent("esx_showname:Enable", xPlayer.source, true)			
		end

		showname[xPlayer.source] = not showname[xPlayer.source]
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Afficher / Masquer les noms en jeu', validate = false})

ESX.RegisterCommand('spec', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then
		if args.playerId ~= nil then
			local players = ESX.GetPlayers()
			for _, value in pairs(players) do
				if value == args.playerId then
					TriggerClientEvent('Core:moderation:spectate', xPlayer.source, value)
					return
				end
			end
			TriggerClientEvent('chatMessage', xPlayer.source, "SYSTEM", {255, 0, 0}, "Player does not exist !")
		else
			TriggerClientEvent('chatMessage', xPlayer.source, "SYSTEM", {255, 0, 0}, "Missing player Id !")
		end
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Activer le mode spectateur sur le joueur donné', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'number'}
}})

ESX.RegisterCommand('stopSpec', "admin", function(xPlayer, args, showError)
	if CanAccessModeration(xPlayer.source) then	
		TriggerClientEvent('esx_spectate:iReset', xPlayer.source)
	else
		showError('Vous n\'avez pas les permissions necessaires')
	end
end, true, {help = 'Sortir du mode spectateur'})


RegisterCommand('report', function(source, args, rawCommand)
	local players = ESX.GetPlayers()
	for m, n in pairs(players) do
		if n == source then
			local targetPlayer = ESX.GetPlayerFromId(n)
			TriggerClientEvent('chatMessage', source, "REPORT", {255, 0, 0}, " (^2" .. targetPlayer.firstname .. " " .. targetPlayer.lastname .." [".. GetPlayerName(source) .."] | "..source.."^0) " .. table.concat(args, " "))
			TriggerEvent('CoreLog:SendDiscordLog', 'Report', "`[REPORT]` **".. targetPlayer.firstname .. " " .. targetPlayer.lastname .."** [".. GetPlayerName(source) .."] | **"..source.. "** : `".. table.concat(args, " ") .."`", 'Yellow', false, source)

			local player = ESX.GetPlayers()
			for k,v in ipairs(player) do
				local user = ESX.GetPlayerFromId(v)
				if user.getGroup() == "user" and v == source then
					TriggerClientEvent('chatMessage', source, "REPORT", {255, 0, 0}, "Report envoyé ! Un modérateur / helpeur va te répondre dès que possible ! N'hésite pas à créer un ticket si personne ne répond.", "report")
				end
				if user.getGroup() ~= "user" and v ~= source then
					TriggerClientEvent('chatMessage', v, "REPORT", {255, 0, 0}, " (^2" .. targetPlayer.firstname .. " " .. targetPlayer.lastname .." [".. GetPlayerName(source) .."] | "..source.."^0) " .. table.concat(args, " "))
				end
			end
		end
	end
end, false)