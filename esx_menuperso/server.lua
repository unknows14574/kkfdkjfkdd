ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('NB:getUsergroup', function(source, cb)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer ~= nil then
  local group = xPlayer.getGroup()
	cb(group)
  end
end)

function getMaximumGrade(jobname)
    local result = MySQL.query.await("SELECT * FROM job_grades WHERE job_name=@jobname  ORDER BY `grade` DESC ;", {
        ['@jobname'] = jobname
    })
    if result[1] ~= nil then
        return result[1].grade
    end
    return nil
end

local function CanAccessModeration(source)
	local result = exports['Nebula_Core']:CanAccessModeration(source)
	print(result, result.canByPass, result.canHandleCommand)
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

local isAuthorized = {}
ESX.RegisterServerCallback('IsZeus', function(source, cb)
	if IsPlayerAceAllowed(source, "command") or CanAccessModeration(source) then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('txAdmin:CheckIsZeus')
AddEventHandler('txAdmin:CheckIsZeus', function()
	local _source = source
	if IsPlayerAceAllowed(_source, "command") or CanAccessModeration(_source) then
		TriggerClientEvent('txAdmin:ReponseIsZeus', true)
	else
		TriggerClientEvent('txAdmin:ReponseIsZeus', false)
	end
end)

TriggerEvent('es:addGroupCommand', 'makemod', "superadmin", function(source, args, user)
	if IsPlayerAceAllowed(source, "command") then
		if isAuthorized[args[1]] ~= nil then
			isAuthorized[args[1]] = nil
			TriggerEvent('xPiwel_Admin:isAuthorized', args[1], nil)
			if GetPlayerName(args[1]) == "Carlita" then
				TriggerClientEvent('Core:ShowNotification', args[1], "Mode ~y~Juge-Suprême~r~ désactivé~w~.")
			else
				TriggerClientEvent('Core:ShowNotification', args[1], "~u~Mode ~y~Vice Juge-Suprême~r~ désactivé~w~.")
			end
		else
			isAuthorized[args[1]] = true
			TriggerEvent('xPiwel_Admin:isAuthorized', args[1], true)
			if GetPlayerName(args[1]) == "Carlita" then
				TriggerClientEvent('Core:ShowNotification', args[1], "~u~Bienvenue très chère ~r~Vice ~y~Juge-Suprême ❤️~u~.")
			else
				TriggerClientEvent('Core:ShowNotification', args[1], "Bienvenue en mode ~y~Juge-Suprême~w~.")
			end
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end, {help = "Make mod", params = {{name = "makemod", help = "Help"}}})

ESX.RegisterServerCallback('AdminMenu:getPlayerData', function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(id)
    if xPlayer ~= nil then
        cb(xPlayer)
    end
end)

ESX.RegisterServerCallback('IsDiscordAnimal', function(source, cb)
    cb(exports.Nebula_Core:DiscordIsRolePresent(source, {"📱 Contributeur #13", "📱 Contributeur #12", "📱 Contributeur #11", "📱 Contributeur #10", "📱 Contributeur #9", "📱 Contributeur #8", "📱 Contributeur #7"}))
end)

ESX.RegisterServerCallback('AdminMenu:getOtherPlayerData', function(source, cb, target)
        
        local xPlayer = ESX.GetPlayerFromId(target)
        if xPlayer ~= nil then
            local identifier = GetPlayerIdentifiers(target)[1]
            
            local result = MySQL.query.await("SELECT * FROM users WHERE identifier = @identifier", {
                ['@identifier'] = identifier
            })
            
            local user = result[1]
            local firstname = user['firstname']
            local lastname = user['lastname']
            local sex = user['sex']
            local dob = user['dateofbirth']
            local height = user['height'] .. " Centimetri"
            local money = user['money']
            local bank = user['bank']
            
            local data = {
                name = GetPlayerName(target),
				job = xPlayer.job,
				job2 = xPlayer.job2,
                inventory = xPlayer.inventory,
                accounts = xPlayer.accounts,
                weapons = xPlayer.loadout,
                firstname = firstname,
                lastname = lastname,
                sex = sex,
                dob = dob,
                height = height,
                money = money,
                bank = bank
            }
            
            TriggerEvent('esx_license:getLicenses', target, function(licenses)
                data.licenses = licenses
                cb(data)
            end)
        end
end)

-- TODO SCN : Review this method for wipe player
RegisterServerEvent('AdminMenu:resetPlayer')
AddEventHandler('AdminMenu:resetPlayer', function(target, playerName)
	local _source = source
	local _target = target
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(_target)
	playerName = playerName or (xPlayer.firstname .. ' ' .. xPlayer.lastname)

	if xPlayer.getGroup() ~= "user" then --si il est admin
		local identifier = GetPlayerIdentifier(target)
		local name = GetPlayerName(target)

		TriggerEvent('esx_datastore:getDataStore', 'property', identifier, function(store)
			dressing = {}
			storeWeapons = {}
	
			store.set('dressing', dressing)
			store.set('weapons', storeWeapons)
		end)

		TriggerEvent('esx_addonaccount:getAccount', 'property_black_money', identifier, function(account)
			local roomAccountMoney = account.money

			account.removeMoney(roomAccountMoney)
		end)

		TriggerEvent('esx_addonaccount:getAccount', 'property_money', identifier, function(account)
			local roomAccountMoney = account.money

			account.removeMoney(roomAccountMoney)
		end)
		-- Remove inventory content
		local inventory = exports['core_inventory']:getInventory('content-' .. xTarget.identifier:gsub(':',''))
		for _,v in ipairs(inventory) do
			exports['core_inventory']:removeItemExact('content-' .. xTarget.identifier:gsub(':',''), v.id)
		end
		
		local primaryInventory = exports['core_inventory']:getInventory('primary-' .. xTarget.identifier:gsub(':',''))
		for _,v in ipairs(primaryInventory) do
			exports['core_inventory']:removeItemExact('primary-' .. xTarget.identifier:gsub(':',''), v.id)
		end
		
		local secondryInventory = exports['core_inventory']:getInventory('secondry-' .. xTarget.identifier:gsub(':',''))
		for _,v in ipairs(secondryInventory) do
			exports['core_inventory']:removeItemExact('secondry-' .. xTarget.identifier:gsub(':',''), v.id)
		end

		local tertiaryInventory = exports['core_inventory']:getInventory('tertiary-' .. xTarget.identifier:gsub(':',''))
		for _,v in ipairs(tertiaryInventory) do
			exports['core_inventory']:removeItemExact('tertiary-' .. xTarget.identifier:gsub(':',''), v.id)
		end
		-- End remove inventory content

		local phone_number = MySQL.query.await('SELECT * FROM users WHERE identifier = @identifier LIMIT 1', { ['@identifier'] = identifier })
		if phone_number and phone_number[1] then
			MySQL.update(
				'DELETE FROM phone_messages WHERE `from` = @number',
				{ ['@number'] = phone_number[1].phone }
			)
		end
		
		MySQL.update(
			'DELETE FROM users WHERE identifier = @identifier',
			{ ['@identifier'] = identifier }
		)

		MySQL.update(
			'DELETE FROM transactions WHERE from_identifier = @identifier AND to_identifier = @other',
			{ ['@identifier'] = identifier,
			  ['@other'] = "unknown"
			}
		)

		MySQL.update(
			'DELETE FROM transactions WHERE to_identifier = @identifier AND from_identifier = @other',
			{ ['@identifier'] = identifier,
			  ['@other'] = "unknown"
			}
		)

		MySQL.update(
			'DELETE FROM transactions WHERE to_identifier = "bank" AND from_identifier = @identifier',
			{ ['@identifier'] = identifier}
		)
		
		MySQL.update(
			'DELETE FROM user_accessories WHERE identifier = @identifier',
			{ ['@identifier'] = identifier }
		)

		MySQL.update(
			'DELETE FROM user_documents WHERE owner = @identifier',
			{ ['@identifier'] = identifier }
		)
		
		MySQL.update(
			'DELETE FROM phone_contacts WHERE owner = @identifier',
			{ ['@identifier'] = identifier }
		)

		MySQL.update(
			'DELETE FROM phone_ads WHERE owner = @identifier',
			{ ['@identifier'] = identifier }
		)

		local phone_darkgroups = MySQL.query.await('SELECT * FROM phone_darkgroups WHERE owner = @identifier', { ['@identifier'] = identifier })
		if phone_darkgroups then
			for _, value in pairs(phone_darkgroups) do
				MySQL.update('DELETE FROM phone_darkmessages WHERE `to` = @id',{ ['@id'] = value.id })
				MySQL.update('DELETE FROM phone_darkgroups WHERE `id` = @id',{ ['@id'] = value.id })
			end
		end

		local phone_groups = MySQL.query.await('SELECT * FROM phone_groups WHERE owner = @identifier', { ['@identifier'] = identifier })
		if phone_groups then
			for _, value in pairs(phone_groups) do
				MySQL.update('DELETE FROM phone_messages WHERE `to` = CONCAT(\'GROUP-\', \'@id\')',{ ['@id'] = value.id })
				MySQL.update('DELETE FROM phone_groups WHERE `id` = @id',{ ['@id'] = value.id })
			end
		end

		-- MySQL.update(
		-- 	'DELETE FROM user_inventory WHERE identifier = @identifier',
		-- 	{ ['@identifier'] = identifier }
		-- )
		
		MySQL.update(
			'DELETE FROM billing WHERE identifier = @identifier',
			{ ['@identifier'] = identifier }
		)
		
		-- MySQL.update(
		-- 	'DELETE FROM characters WHERE identifier = @identifier',
		-- 	{ ['@identifier'] = identifier }
		-- )
		
		-- MySQL.update(
		-- 	'DELETE FROM playerstattoos WHERE identifier = @identifier',
		-- 	{ ['@identifier'] = identifier }
		-- )
		
		MySQL.update(
			'DELETE FROM user_licenses WHERE owner = @owner',
			{ ['@owner'] = identifier }
		)

		MySQL.update(
			'DELETE FROM dopeplants WHERE owner = @owner',
			{ ['@owner'] = identifier }
		)
		
		-- MySQL.update(
		-- 	'DELETE FROM addon_inventory_items WHERE owner = @owner',
		-- 	{ ['@owner'] = identifier }
		-- )
		
		MySQL.update('DELETE FROM datastore_data WHERE owner = @owner', { ['@owner'] = identifier })

		local owned_vehicles = MySQL.query.await('SELECT * FROM owned_vehicles WHERE owner = @identifier', { ['@identifier'] = identifier })
		if owned_vehicles then
			for _, value in pairs(owned_vehicles) do
				local plate = value.plate
				local deleteVehicleTrunk = "DELETE FROM coreinventories WHERE `name` = 'trunk-" .. plate .. "'" 
				MySQL.update(deleteVehicleTrunk)
				local deleteVehicleGlovebox = "DELETE FROM coreinventories WHERE `name` = 'glovebox-" .. plate .. "'" 
				MySQL.update(deleteVehicleGlovebox)
			end			
		end

		local deleteInventoriesQuery = "DELETE FROM `coreinventories` WHERE `name` like '%".. identifier:gsub(':','') .."%'"
		MySQL.update(deleteInventoriesQuery)

		MySQL.update(
			'DELETE FROM owned_vehicles WHERE owner = @owner',
			{ ['@owner'] = identifier }
		)
		
		MySQL.update(
			'DELETE FROM stolen_vehicles WHERE owner = @identifier',
			{ ['@identifier'] = identifier }
		)

		MySQL.update(
			'DELETE FROM owned_properties WHERE owner = @owner',
			{ ['@owner'] = identifier }
		)

		MySQL.update(
			'DELETE FROM sim WHERE identifier = @identifier',
			{ ['@identifier'] = identifier }
		)

		MySQL.update(
			'DELETE FROM skill WHERE identifier = @identifier',
			{ ['@identifier'] = identifier }
		)

		MySQL.update(
			'UPDATE owned_vehicles SET owner2 = "steam:000000000000000" WHERE owner2 = @identifier',
			{ ['@identifier'] = identifier }
		)

		-- Suppréssion de clés partagées 
		local jsondecode = {}
		local jsonencode = {}

		local result = MySQL.query.await("SELECT * FROM owned_properties", {})
		for i=1, #result, 1 do
			jsondecode = json.decode(result[i].shared)
			for k, v in pairs(jsondecode) do
				if v == identifier then
					table.remove(jsondecode, k)
					if #jsondecode <= 0 then
						jsonencode = json.encode({})
						MySQL.update('UPDATE owned_properties SET shared = @shared WHERE name = @name AND owner = @owner', {
							['@name'] = result[i].name,
							['@owner'] = result[i].owner,
							['@shared'] = jsonencode
						})
					else
						jsonencode = json.encode(jsondecode)
						MySQL.update('UPDATE owned_properties SET shared = @shared WHERE name = @name AND owner = @owner', {
							['@name'] = result[i].name,
							['@owner'] = result[i].owner,
							['@shared'] = jsonencode
						})
					end
				end
			end
		end
		--
		
		DropPlayer(target, "Ton personnage a été reset du serveur.\nTu peux donc te reconnecter afin de créer ton nouveau personnage.\nATTENTION : penses à bien fermer FiveM et à la réouvrir avant de te reconnecter.\n\nBon jeu sur Nebula")
		TriggerEvent('CoreLog:SendDiscordLog', 'Wipe', GetPlayerName(_source) .. " a **RESET** `".. playerName .."`", 'Purple', false, _source)
		
		if _source ~= nil then
			TriggerClientEvent('Core:ShowNotification', xPlayer.source,  "Vous avez reset "..playerName.." !")
		end
	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', source)
	end
	
end)

-------------------------------------------------------------------------------Admin Menu

RegisterServerEvent('AdminMenu:kick')
AddEventHandler('AdminMenu:kick', function(target, rs)
	local _source = source
	local rs = rs
	
	DropPlayer(target, rs)
	TriggerClientEvent('esx:showNotification', _source,  "Vous avez kick ce joueur")
	
end)

RegisterServerEvent('AdminMenu:ban')
AddEventHandler('AdminMenu:ban', function(target)
	local _source = source

	DropPlayer(target, "Vous avez été Banni du serveur !")
	
	TriggerClientEvent('esx:showNotification', _source,  "Vous avez ban ce joueur")
end)

RegisterServerEvent('AdminMenu:setjob')
AddEventHandler('AdminMenu:setjob', function(slot, label, job, grade, target)
	local _source = source
	
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if slot == 1 then
		targetXPlayer.setJob(job, grade)
	elseif slot == 2 then
		targetXPlayer.setJob2(job, grade)
	end

	TriggerClientEvent('esx:showNotification', _source, targetXPlayer.name .. " est maintenant ~y~" .. label .. "~w~.")
	TriggerClientEvent('esx:showNotification', target,  "[JOB#" .. slot .. "] Vous avez un nouveau job ~y~" ..label .. "~w~.")	
	
end)

RegisterServerEvent('AdminMenu:giveWeapon')
AddEventHandler('AdminMenu:giveWeapon', function(weapon, ammo, target)
  local xPlayer = ESX.GetPlayerFromId(target)
	xPlayer.addInventoryItem(string.lower(weapon), 1)
	TriggerEvent('CoreLog:SendDiscordLog', 'Give Items / Argent / Armes', "**"..GetPlayerName(source) .. "** a donné **".. weapon .. "** avec **x"..ammo.." balles** à **".. GetPlayerName(target).."** `["..ESX.GetItemLabel(weapon).."]`", 'Yellow', ((source ~= target and source) or false), target)
end)

RegisterServerEvent("AdminMenu:giveCash")
AddEventHandler("AdminMenu:giveCash", function(money)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	if xPlayer.getGroup() ~= "user" then --si il est admin
	
		xPlayer.addAccountMoney('money', total)
		local item = ' $ d\'argent !'
		local message = 'Tu t\'est GIVE '
		TriggerClientEvent('Core:ShowNotification', _source, message.." "..total.." "..item)

	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', _source)
	end

end)

RegisterServerEvent("AdminMenu:giveCash2")
AddEventHandler("AdminMenu:giveCash2", function(money, target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(target)
	local xMe = ESX.GetPlayerFromId(_source)
	local total = money
	
	if xMe.getGroup() ~= "user" then --si il est admin
	
		xPlayer.addAccountMoney('money', total)

		TriggerClientEvent('Core:ShowNotification', _source, "Vous avez donné $" .. total .. " (cash) à " .. xPlayer.name)
		TriggerClientEvent('Core:ShowNotification', target, "Vous avez recu $" .. total .. " (cash)")
		TriggerEvent('CoreLog:SendDiscordLog', 'Give Items / Argent / Armes', "**"..GetPlayerName(_source) .. "** a donné **".. total .. "$** à **".. GetPlayerName(target).."** `[CASH]`", 'Blue', ((_source ~= target and _source) or false), target)

	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', _source)
	end

end)

RegisterServerEvent("AdminMenu:giveBank2")
AddEventHandler("AdminMenu:giveBank2", function(money, target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(target)
	local xMe = ESX.GetPlayerFromId(_source)
	local total = money
	
	if xMe.getGroup() ~= "user" then --si il est admin

		xPlayer.addAccountMoney('bank', total, "Remboursement gouvernemental", "gouv")

		TriggerClientEvent('esx:showNotification', _source, "Vous avez give $" .. total .. " (bank) à " .. xPlayer.name)
		TriggerClientEvent('esx:showNotification', target, "Vous avez recu $" .. total .. " (bank)")
		TriggerEvent('CoreLog:SendDiscordLog', 'Give Items / Argent / Armes', "**"..GetPlayerName(_source) .. "** a donné **".. total .. "$** à **".. GetPlayerName(target).."** `[BANK]`", 'Purple', ((_source ~= target and _source) or false), target)


	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', _source)
	end
	
end)

RegisterServerEvent("AdminMenu:giveBank")
AddEventHandler("AdminMenu:giveBank", function(money)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	if xPlayer.getGroup() ~= "user" then --si il est admin
	
		xPlayer.addAccountMoney('bank', total, "Remboursement gouvernemental", "gouv")
		local item = ' $ en banque.'
		local message = 'Tu t\'es octroyé '
		TriggerClientEvent('esx:showNotification', _source, message.." "..total.." "..item)

	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', _source)
	end

end)

RegisterServerEvent("AdminMenu:giveDirtyMoney")
AddEventHandler("AdminMenu:giveDirtyMoney", function(money)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	if xPlayer.getGroup() ~= "user" then --si il est admin
	
		xPlayer.addAccountMoney('black_money', total)
		local item = ' $ d\'argent sale.'
		local message = 'Tu t\'es octroyé '
		TriggerClientEvent('esx:showNotification', _source, message.." "..total.." "..item)

	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', _source)
	end

end)

RegisterServerEvent("AdminMenu:giveDirtyMoney2")
AddEventHandler("AdminMenu:giveDirtyMoney2", function(money, target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(target)
	local xMe = ESX.GetPlayerFromId(_source)
	local total = money
	
	if xMe.getGroup() ~= "user" then --si il est admin
	
		xPlayer.addAccountMoney('black_money', total)

		TriggerClientEvent('esx:showNotification', _source, "Vous avez give $" .. total .. " (sale) à " .. xPlayer.name)
		TriggerClientEvent('esx:showNotification', target, "Vous avez recu $" .. total .. " (sale)")
		TriggerEvent('CoreLog:SendDiscordLog', 'Give Items / Argent', "**"..GetPlayerName(_source) .. "** a donné **".. total .. "$** à **".. GetPlayerName(target).."** `[ARGENT MARQUÉ]`", 'Black', ((_source ~= target and _source) or false), target)

	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', _source)
	end
	
end)

-------------------------------------------------------------------------------Grade Menu
RegisterServerEvent('NB:promouvoirplayer')
AddEventHandler('NB:promouvoirplayer', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	
	if sourceXPlayer.job.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'coboss' or sourceXPlayer.job.grade_name == 'coboss' or (sourceXPlayer.job.grade_name == 'capitaine' and sourceXPlayer.job.name == 'police') then --un petit check si le joueurs est vraiment boss
	
		local maximumgrade = tonumber(getMaximumGrade(sourceXPlayer.job.name)) -1 

		if (targetXPlayer.job.grade == maximumgrade) or (targetXPlayer.job2.grade == maximumgrade) then
			TriggerClientEvent('esx:showNotification', _source, "Vous devez demander une autorisation du ~r~Gouvernement~w~.")
		else
			if (sourceXPlayer.job.name == targetXPlayer.job.name) or (sourceXPlayer.job2.name == targetXPlayer.job2.name) or 
			(sourceXPlayer.job2.name == targetXPlayer.job.name) or (sourceXPlayer.job.name == targetXPlayer.job2.name) then

				local grade = tonumber(targetXPlayer.job.grade) + 1 
				local job = targetXPlayer.job.name

				targetXPlayer.setJob(job, grade)

				TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~promu "..targetXPlayer.name.."~w~.")
				TriggerClientEvent('esx:showNotification', target,  "Vous avez été ~g~promu par ".. sourceXPlayer.name.."~w~.")		
			else
				TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
			end
		end 
	
	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', source)
	end
	
end)
RegisterServerEvent('NB:promouvoirplayer2')
AddEventHandler('NB:promouvoirplayer2', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	
	if sourceXPlayer.job.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'coboss' or sourceXPlayer.job.grade_name == 'coboss' or (sourceXPlayer.job.grade_name == 'capitaine' and sourceXPlayer.job.name == 'police') then --un petit check si le joueurs est vraiment boss
	
		local maximumgrade = tonumber(getMaximumGrade(sourceXPlayer.job2.name)) -1 

		if (targetXPlayer.job2.grade == maximumgrade) or (targetXPlayer.job.grade == maximumgrade) then
			TriggerClientEvent('Core:ShowNotification', _source, "Vous ne pouvez pas faire ceci.")
		else
			if (sourceXPlayer.job.name == targetXPlayer.job.name) or (sourceXPlayer.job2.name == targetXPlayer.job2.name) or 
			(sourceXPlayer.job2.name == targetXPlayer.job.name) or (sourceXPlayer.job.name == targetXPlayer.job2.name) then

				local grade = tonumber(targetXPlayer.job2.grade) + 1 
				local job = targetXPlayer.job2.name

				targetXPlayer.setJob2(job, grade)

				TriggerClientEvent('Core:ShowNotification', _source, "Vous avez ~g~promu "..targetXPlayer.name.."~w~.")
				TriggerClientEvent('Core:ShowNotification', target,  "Vous avez été ~g~promu par ".. sourceXPlayer.name.."~w~.")		
			else
				TriggerClientEvent('Core:ShowNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
			end
		end 
	
	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', source)
	end
	
end)

RegisterServerEvent('NB:destituerplayer')
AddEventHandler('NB:destituerplayer', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'coboss' or sourceXPlayer.job.grade_name == 'coboss' or (sourceXPlayer.job.grade_name == 'capitaine' and sourceXPlayer.job.name == 'police') then --un petit check si le joueurs est vraiment boss

		if (targetXPlayer.job.grade == 0) or (targetXPlayer.job2.grade == 0) then
			TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas plus ~r~rétrograder~w~ davantage.")
		else
			if (sourceXPlayer.job.name == targetXPlayer.job.name) or (sourceXPlayer.job2.name == targetXPlayer.job2.name) or 
			(sourceXPlayer.job2.name == targetXPlayer.job.name) or (sourceXPlayer.job.name == targetXPlayer.job2.name) then
				local grade = tonumber(targetXPlayer.job.grade) - 1 
				local job = targetXPlayer.job.name

				targetXPlayer.setJob(job, grade)

				TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~rétrogradé "..targetXPlayer.name.."~w~.")
				TriggerClientEvent('esx:showNotification', target,  "Vous avez été ~r~rétrogradé par ".. sourceXPlayer.name.."~w~.")		
			else
				TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
			end
		end 
	
	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', source)
	end
	
end)
RegisterServerEvent('NB:destituerplayer2')
AddEventHandler('NB:destituerplayer2', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'coboss' or sourceXPlayer.job.grade_name == 'coboss' or (sourceXPlayer.job.grade_name == 'capitaine' and sourceXPlayer.job.name == 'police') then --un petit check si le joueurs est vraiment boss
		
		if (targetXPlayer.job2.grade == 0) or (targetXPlayer.job2.grade == 0) then
			TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas plus ~r~rétrograder~w~ davantage.")
		else
			if (sourceXPlayer.job.name == targetXPlayer.job.name) or (sourceXPlayer.job2.name == targetXPlayer.job2.name) or 
			(sourceXPlayer.job2.name == targetXPlayer.job.name) or (sourceXPlayer.job.name == targetXPlayer.job2.name) then
				local grade = tonumber(targetXPlayer.job2.grade) - 1 
				local job = targetXPlayer.job2.name

				targetXPlayer.setJob2(job, grade)

				TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~rétrogradé "..targetXPlayer.name.."~w~.")
				TriggerClientEvent('esx:showNotification', target,  "Vous avez été ~r~rétrogradé par ".. sourceXPlayer.name.."~w~.")		
			else
				TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
			end
		end

	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', source)
	end
	
end)

RegisterServerEvent('NB:recruterplayer')
AddEventHandler('NB:recruterplayer', function(target, job, grade)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	
	if sourceXPlayer.job.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'coboss' or sourceXPlayer.job.grade_name == 'coboss' or sourceXPlayer.job2.grade_name == 'boss' or (sourceXPlayer.job.grade_name == 'capitaine' and sourceXPlayer.job.name == 'police') then --un petit check si le joueurs est vraiment boss
		
		targetXPlayer.setJob(job, grade)

		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~recruté "..targetXPlayer.name.."~w~.")
		TriggerClientEvent('esx:showNotification', target,  "Vous avez été ~g~embauché par ".. sourceXPlayer.name.."~w~.")		
	
	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', source)
	end

end)
RegisterServerEvent('NB:recruterplayer2')
AddEventHandler('NB:recruterplayer2', function(target, job, grade)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	
	if sourceXPlayer.job.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'coboss' or sourceXPlayer.job.grade_name == 'coboss' or (sourceXPlayer.job.grade_name == 'capitaine' and sourceXPlayer.job.name == 'police') then --un petit check si le joueurs est vraiment boss
	
		targetXPlayer.setJob2(job, grade)

		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~recruté "..targetXPlayer.name.."~w~.")
		TriggerClientEvent('esx:showNotification', target,  "Vous avez été ~g~embauché par ".. sourceXPlayer.name.."~w~.")		

	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', source)
	end

end)

RegisterServerEvent('NB:virerplayer')
AddEventHandler('NB:virerplayer', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	
	if sourceXPlayer.job.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'coboss' or sourceXPlayer.job.grade_name == 'coboss' or (sourceXPlayer.job.grade_name == 'capitaine' and sourceXPlayer.job.name == 'police') then --un petit check si le joueurs est vraiment boss
	
		local job = "unemployed"
		local grade = "0"

		if (sourceXPlayer.job.name == targetXPlayer.job.name) or (sourceXPlayer.job2.name == targetXPlayer.job2.name) or 
		 (sourceXPlayer.job2.name == targetXPlayer.job.name) or (sourceXPlayer.job.name == targetXPlayer.job2.name) then
			targetXPlayer.setJob(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~viré "..targetXPlayer.name.."~w~.")
			TriggerClientEvent('esx:showNotification', target,  "Vous avez été ~g~viré par ".. sourceXPlayer.name.."~w~.")	
		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
		end
	
	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', source)
	end
	
end)
RegisterServerEvent('NB:virerplayer2')
AddEventHandler('NB:virerplayer2', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	
	if sourceXPlayer.job.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'coboss' or sourceXPlayer.job.grade_name == 'coboss' or (sourceXPlayer.job.grade_name == 'capitaine' and sourceXPlayer.job.name == 'police') then --un petit check si le joueurs est vraiment boss
	
		local job = "unemployed2"
		local grade = "0"

		if (sourceXPlayer.job.name == targetXPlayer.job.name) or (sourceXPlayer.job2.name == targetXPlayer.job2.name) or 
		 (sourceXPlayer.job2.name == targetXPlayer.job.name) or (sourceXPlayer.job.name == targetXPlayer.job2.name) then
			targetXPlayer.setJob2(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~viré "..targetXPlayer.name.."~w~.")
			TriggerClientEvent('esx:showNotification', target,  "Vous avez été ~g~viré par ".. sourceXPlayer.name.."~w~.")	
		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
		end
	
	else --si il est pas boss est que ce trigger est call forcement il cheat
		TriggerClientEvent('esx_society:cheats', source)
	end
	
end)

ESX.RegisterServerCallback('NB:GetGang', function (source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
  
	if xPlayer ~= nil and xPlayer.identifier ~= nil then
  
		local result = MySQL.query.await("SELECT users.gang FROM users WHERE users.identifier = @identifier", {
			  ['@identifier'] = xPlayer.identifier
		  })
		  
		  if result[1] ~= nil then
				--print(result[1].gang)
			  cb(result[1].gang)
		  else
			  --print("nil")
			  cb("")
		  end
	  end
 end)

ESX.RegisterServerCallback('esx_menuperso:getOtherPlayerData', function(source, cb, target)
	  local xPlayer = ESX.GetPlayerFromId(target)

	  local result = MySQL.query.await("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = xPlayer.identifier
	  })
  
	  local user      = result[1]
	  local firstname     = user['firstname']
	  local lastname      = user['lastname']
	  local sex           = user['sex']
	  local dob           = user['dateofbirth']
	  local bank           = user['bank']
	  local money           = user['money']
	  local height        = user['height'] .. " Inches"
  
	  local data = {
		name        = xPlayer.name,
		job         = xPlayer.job,
		inventory   = xPlayer.inventory,
		accounts    = xPlayer.accounts,
		weapons     = xPlayer.loadout,
		firstname   = firstname,
		lastname    = lastname,
		sex         = sex,
		dob         = dob,
		height      = height,
		money 	    = money,
		bank        = bank,
	  }
  
	  TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
  
		if status ~= nil then
		  data.drunk = math.floor(status.percent)
		end
  
	  end)

	cb(data)

end)

 RegisterServerEvent('esx_menuperso:confiscatePlayerItem')
 AddEventHandler('esx_menuperso:confiscatePlayerItem', function(target, itemType, itemName, amount)
 
   local sourceXPlayer = ESX.GetPlayerFromId(source)
   local targetXPlayer = ESX.GetPlayerFromId(target)
 
   if itemType == 'item_standard' then
 
	 local label = sourceXPlayer.getInventoryItem(itemName).label
	 local playerItemCount = targetXPlayer.getInventoryItem(itemName).count

 
	 if playerItemCount >= amount then
	   targetXPlayer.removeInventoryItem(itemName, amount)
	   if itemName == "radio" then
		TriggerClientEvent('Radio.RemovedItem', targetXPlayer.source)
		TriggerClientEvent('Core:ShowNotification', targetXPlayer.source, "~r~Radio déconnectée.")
	  end
	 else
	   TriggerClientEvent('esx:showNotification', _source, "Mauvaise quantité")
	 end
 
	 TriggerClientEvent('Core:ShowNotification', sourceXPlayer.source, "Vous avez retiré ~y~x" .. amount .. " " .. label .. "~w~ à " .. targetXPlayer.firstname .. " " .. targetXPlayer.firstname .. " ["..targetXPlayer.name.."].") 
   end

	if itemType == 'item_money' then

		targetXPlayer.removeMoney(amount)
		TriggerClientEvent('Core:ShowNotification', sourceXPlayer.source, "Vous avez retiré ~g~$" .. amount .. "~w~ à " .. targetXPlayer.firstname .. " " .. targetXPlayer.firstname .. " ["..targetXPlayer.name.."].") 
	end
 
   if itemType == 'item_account' then
 
	 targetXPlayer.removeAccountMoney(itemName, amount, "Retrait gouvernemental", "gouv") 
	 TriggerClientEvent('Core:ShowNotification', sourceXPlayer.source, "Vous avez retiré ~r~$" .. amount .. "~w~ à " .. targetXPlayer.firstname .. " " .. targetXPlayer.firstname .. " ["..targetXPlayer.name.."].") 
   end
 
 
   if itemType == 'item_weapon' then
 
	 targetXPlayer.removeWeapon(itemName)

	 TriggerClientEvent('Core:ShowNotification', sourceXPlayer.source, "Vous avez retiré ~r~" .. ESX.GetWeaponLabel(itemName) .. "~w~ à " .. targetXPlayer.firstname .. " " .. targetXPlayer.firstname .. " ["..targetXPlayer.name.."].") 
   end
 end)


ESX.RegisterServerCallback('esx_menuperso:job_user', function(source, cb, jobName)
	MySQL.query('SELECT * FROM users WHERE job = @jobname OR job2 = @job2name', {
		['@jobname'] = jobName,
		['@job2name'] = jobName
	}, function(results)
		local resultUser = {}
		for _,v in pairs(results) do
			local accounts = json.decode(v.accounts)
			table.insert(resultUser, {firstname = v.firstname, lastname = v.lastname, identifier = v.identifier, bank = accounts.bank})
		end
		cb(resultUser)
	end)
end)

RegisterServerEvent('esx_menuperso:givemoney')
AddEventHandler('esx_menuperso:givemoney', function(target, montant, job, bank, targetName)
	TriggerEvent('esx_jobcounter:returnTableMetierServer', function(JobConnected) 
		TriggerEvent('esx_addonaccount:getSharedAccount', "society_" .. job, function(account_society)
			if account_society.money >= montant then
				if targetName then
					account_society.removeMoney(montant, "Virement vers le compte de l'employé "..targetName, "bill")
				else
					account_society.removeMoney(montant)
				end
				
				local UseActuel = false
				for k, v in pairs(JobConnected) do
					if v.identifier == target and (v.job == job or v.job2 == job) then
						local xPlayer = ESX.GetPlayerFromId(v.id)
						xPlayer.addAccountMoney('bank', montant, "Virement de votre employeur depuis le compte entreprise", "transaction")
						TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Vous avez reçu un virement de ~g~$' .. montant .. '~w~ de votre entreprise.')
						UseActuel = true
						break
					end
				end
				if UseActuel == false then

					local userResult = MySQL.query.await('SELECT * FROM users WHERE identifier = @identifier LIMIT 1', { ['@identifier'] = target})
					if userResult ~= nil and #userResult >= 1 then
						local user = userResult[1]
						local accounts = json.decode(user.accounts)
						local moneyadd = bank + montant
						accounts.bank = moneyadd
						MySQL.update(
						'UPDATE users SET accounts = @accounts WHERE identifier = @identifier',
						{
							['@accounts']      = json.encode(accounts),
							['@identifier'] = target
						}
						)
						
					end
				end
				UseActuel = false
				
			else
				TriggerClientEvent('Core:ShowNotification', source,"Vous n'avez pas assez d'argent")
			end
		end)
	end, "tabjob", "players")
end)

RegisterServerEvent('esx_menuperso:givemoneyEntreprise')
AddEventHandler('esx_menuperso:givemoneyEntreprise', function(target, montant, job, targetLabel, jobLabel)
	TriggerEvent('esx_addonaccount:getSharedAccount', "society_" .. job, function(account)
		TriggerEvent('esx_addonaccount:getSharedAccount', "society_" .. target, function(account_society)
			if account_society.money >= montant then
				account.removeMoney(montant, "Virement vers "..targetLabel, "bill")
				account_society.addMoney(montant, "Virement de "..jobLabel, "deposit")
			else
				TriggerClientEvent('Core:ShowNotification', source,"Vous n'avez pas assez d'argent")
			end
		end)
	end)
end)

ESX.RegisterServerCallback('admin:getVaultWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_admin', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('admin:removeVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_admin', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons do
		if weapons[i] ~= nil then 
		  if weapons[i].name == weaponName then
			weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
			foundWeapon = true
		  elseif weapons[i].count <= 0 then
			table.remove(weapons, i)
		  end
		end
	end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)
TriggerClientEvent('esx_add:saveLoadout', source)

     cb()

  end)

end)

ESX.RegisterServerCallback('admin:addVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_admin', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
		if weapons[i] ~= nil then
		  if weapons[i].name == weaponName then
			weapons[i].count = weapons[i].count + 1
			foundWeapon = true
		  elseif weapons[i].count <= 0 then
			table.remove(weapons, i)
		  end
		end
	end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)
TriggerClientEvent('esx_add:saveLoadout', source)

     cb()

  end)

end)

-- Coffre Helpeurs

ESX.RegisterServerCallback('helpeur:getVaultWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_helpeur', function(store)
  
	  local weapons = store.get('weapons')
  
	  if weapons == nil then
		weapons = {}
	  end
  
	  cb(weapons)
  
	end)
  
  end)
  
  ESX.RegisterServerCallback('helpeur:removeVaultWeapon', function(source, cb, weaponName)
  
	local xPlayer = ESX.GetPlayerFromId(source)
  
	xPlayer.addWeapon(weaponName, 1000)
  
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_helpeur', function(store)
  
	  local weapons = store.get('weapons')
  
	  if weapons == nil then
		weapons = {}
	  end
  
	  local foundWeapon = false
  
	  for i=1, #weapons do
		  if weapons[i] ~= nil then 
			if weapons[i].name == weaponName then
			  weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
			  foundWeapon = true
			elseif weapons[i].count <= 0 then
			  table.remove(weapons, i)
			end
		  end
	  end
  
	  if not foundWeapon then
		table.insert(weapons, {
		  name  = weaponName,
		  count = 0
		})
	  end
  
	   store.set('weapons', weapons)
TriggerClientEvent('esx_add:saveLoadout', source)
  
	   cb()
  
	end)
  
  end)
  
  ESX.RegisterServerCallback('helpeur:addVaultWeapon', function(source, cb, weaponName)
  
	local xPlayer = ESX.GetPlayerFromId(source)
  
	xPlayer.removeWeapon(weaponName)
  
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_helpeur', function(store)
  
	  local weapons = store.get('weapons')
  
	  if weapons == nil then
		weapons = {}
	  end
  
	  local foundWeapon = false
  
	  for i=1, #weapons, 1 do
		  if weapons[i] ~= nil then
			if weapons[i].name == weaponName then
			  weapons[i].count = weapons[i].count + 1
			  foundWeapon = true
			elseif weapons[i].count <= 0 then
			  table.remove(weapons, i)
			end
		  end
	  end
  
	  if not foundWeapon then
		table.insert(weapons, {
		  name  = weaponName,
		  count = 1
		})
	  end
  
	   store.set('weapons', weapons)
TriggerClientEvent('esx_add:saveLoadout', source)
  
	   cb()
  
	end)
  
end)

---------------------------------

RegisterServerEvent('PriseFinService')
AddEventHandler('PriseFinService', function(job)
	local xPlayer = ESX.GetPlayerFromId(source)
	local jobService = 1

	if job == "job1" then
		if xPlayer.job.service == 1 then
			jobService = 0
		end
		xPlayer.setService(xPlayer.job.name, jobService)
		
	elseif job == "job2" then
		if xPlayer.job2.service == 1 then
			jobService = 0
		end
		xPlayer.setService(xPlayer.job2.name, jobService)
	end

	if jobService == 1 then
		TriggerClientEvent('Core:ShowNotification', xPlayer.source,"~h~Vous êtes maintenant en service!", true, false, 210)
	else
		TriggerClientEvent('Core:ShowNotification', xPlayer.source,"~h~Vous êtes maintenant hors service.", true, false, 130)
	end
end)

RegisterServerEvent('esx_menuperso:giveItem')
AddEventHandler('esx_menuperso:giveItem', function(itemName)

  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addInventoryItem(itemName, 1)
end)
