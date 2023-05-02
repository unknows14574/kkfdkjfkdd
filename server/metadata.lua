-- EDIT DEFAULT METADATA FOR CERTAIN ITEMS
ESX = nil

TriggerEvent("esx:getSharedObject", function(obj)
		ESX = obj
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	else
		if (Config.RemoveDropOnStart) then
			local removeDropAndSpawnVehiculeData = 'DELETE FROM `coreinventories` WHERE `name` like \'%drop-%\' OR `name` like \'%trunk-loca%\' OR `name` like \'%glovebox-loca%\'';
			MySQL.update(removeDropAndSpawnVehiculeData)

			local removeAllEmptyInventory = 'DELETE FROM `coreinventories` WHERE data like \'%"content":[],%\' and (name not like \'primary-%\' and name not like \'secondry-%\' and name not like \'tertiary-%\')';
			MySQL.update(removeAllEmptyInventory)

			-- TODO SCN : check for vehicle plate and remove trunk not own by player (npc / rend / spawn car)
		end
	end
end)

function defaultMetadata(source, itemData, currentMetadata)
	-- doesn't work at all
	local Player = ESX.GetPlayerFromId(source)
	local info = currentMetadata

	--------------------------------------------------------------
	--EDIT STARTS HERE
	--------------------------------------------------------------

	if itemData['name'] == 'idcard' then
		info.firstname = Player.get('firstName')
		info.lastname = Player.get('lastName')
		info.dob = Player.get('dateofbirth')
		info.sex = Player.get('sex')
		info.height = Player.get('height')
	end
	
	--------------------------------------------------------------
	--EDIT ENDS HERE
	--------------------------------------------------------------

	return info

end
-- #################### CUSTOM ADDON ####################

local function splitString (inputstr, sep)
	if sep == nil then
	   sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
	   table.insert(t, str)
	end
	return t
 end

 local function storageJobType(job, storageType)
	if storageType == 'storage' then
		for key, value in pairs(Config.LegalJob['storage']) do
			if string.lower(key) == string.lower(job) then
				return { { type = 'legal', logName = value } }
			end
		end
		for key, value in pairs(Config.IllegalJob['storage']) do
			if string.lower(key) == string.lower(job) then
				return { { type = 'illegal', logName = value } }
			end
		end
	elseif storageType == 'weapon' then
		for key, value in pairs(Config.LegalJob['weapon']) do
			if string.lower(key) == string.lower(job) then
				return { {type = 'legal', logName = value } }
			end
		end
		for key, value in pairs(Config.IllegalJob['weapon']) do
			if string.lower(key) == string.lower(job) then
				return { {type = 'illegal', logName = value } }
			end
		end
	else
		return nil
	end
 end

 local function getPropertyOwner(inventoryName)
	local propertyAndOwner = splitString(inventoryName, '_')
	if propertyAndOwner ~= nil and #propertyAndOwner > 0 then
		local owner = splitString(propertyAndOwner[1], '-')
		if owner ~= nil and #owner > 0 then
			return { property = owner[1], owner = owner[2]:gsub('steam','steam:') }
		else
			return propertyAndOwner[1]
		end
	else
		return inventoryName
	end
 end

-- HELPERS CUSTOM ADDON To know if inventory can carry item
ESX.RegisterServerCallback('core_inventory:custom:InventoryCanCarry',function(source, cb, inventoryName, itemName, itemCount)
	cb(exports['core_inventory']:canCarry(inventoryName, itemName, itemCount))
end)

-- HELPERS CUSTOM ADDON To display notification when buy weapon (police / sheriff)

ESX.RegisterServerCallback('core_inventory:custom:AddItemIntoInventory', function(source, cb, inventoryName, itemName, itemCount, price)
	if (exports['core_inventory']:canCarry(inventoryName, itemName, itemCount) and exports['core_inventory']:addItem(inventoryName, itemName, itemCount)) then
		if (price) then
			TriggerClientEvent('Core:ShowNotification', source,
				'Vous avez acheté ~y~x' ..
				itemCount .. ' ' .. ESX.GetItemLabel(itemName) .. '~w~ pour ~g~' .. math.ceil(itemCount * price) .. '$')
		else
			TriggerClientEvent('Core:ShowNotification', source,
				'Vous avez récupéré ~y~x' .. itemCount .. ' ' .. ESX.GetItemLabel(itemName))
		end
	else
		if (price) then
			TriggerClientEvent('Core:ShowNotification', source,
				'Impossible d\'acheter ~r~x' ..
				itemCount .. ' ' .. ESX.GetItemLabel(itemName) .. '~w~ pour ~g~' .. math.ceil(itemCount * price) .. '$')
		else
			TriggerClientEvent('Core:ShowNotification', source,
				'Impossible de récupérer ~r~x' .. itemCount .. ' ' .. ESX.GetItemLabel(itemName))
		end
	end
end)

-- CUSTOM ADDON For count stack with item count

exports('RetrieveStackNumberForItemCount', function(itemName, count)
	local result = MySQL.query.await('SELECT `category` FROM `items` WHERE `name` = @itemName LIMIT 1', { ['@itemName'] = itemName}) 
	if (result ~= nil and result[1] ~= nil and result[1].category ~= nil) then
		local category = Config.ItemCategories[result[1].category];
		if category ~= nil and category.stack then
			local c = count / category.stack
			return c;
		else
			return count;
		end
	else
		return count
	end
end)

-- CUSTOM ADDON For add 3dme

RegisterNetEvent('core_inventory:custom:call3dme')
AddEventHandler('core_inventory:custom:call3dme', function(text, target)
	if target == nil then
		exports['3dme']:shareDisplay(source , text )
	else
		exports['3dme']:shareDisplay(target , text )		
	end
end)

-- CUSTOM ADDON For add 3dme when give item

RegisterNetEvent('core_inventory:custom:logGiveItem')
AddEventHandler('core_inventory:custom:logGiveItem', function(target, itemName, amount)
	local _source = source
	local _target = target
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(_target)
	TriggerEvent('CoreLog:SendDiscordLog', "Échange d'objets", "**".. xPlayer.firstname.." "..xPlayer.lastname.." [".. GetPlayerName(xPlayer.source) .. "]** a donné x"..amount.." `"..itemName.."` à **"..xTarget.firstname.." "..xTarget.lastname.." [".. GetPlayerName(xTarget.source) .. "]**.", 'Grey', xTarget.source, xPlayer.source)
end)

-- CUSTOM ADDON For GetItemLabel

ESX.RegisterServerCallback('core_inventory:custom:getItemLabel', function(source, cb, itemTable)
	if (type(itemTable) == 'table') then
		local result = {}
		for index, value in ipairs(t) do
			table.insert(result, ESX.GetItemLabel(value))
		end
		cb(result)
	else
		cb(ESX.GetItemLabel(itemTable))
	end

end)

-- CUSTOM ADDON For open other user inventory

RegisterNetEvent('core_inventory:custom:searchPlayer')
AddEventHandler('core_inventory:custom:searchPlayer', function(targetPlayerServerId)
	local _source = source
	local _targetPlayerId = targetPlayerServerId
	local _targetPlayer = ESX.GetPlayerFromId(_targetPlayerId)
	exports['core_inventory']:openInventory(_source, 'content-' .. _targetPlayer.identifier:gsub(":", ""), 'content', 10, 10, true, {})
	exports['core_inventory']:openInventory(_source, 'primary-' .. _targetPlayer.identifier:gsub(":", ""), 'primary', 20, 20, true, {})
	exports['core_inventory']:openInventory(_source, 'secondry-' .. _targetPlayer.identifier:gsub(":", ""), 'secondry', 30, 30, true, {})
	exports['core_inventory']:openInventory(_source, 'tertiary-' .. _targetPlayer.identifier:gsub(":", ""), 'tertiary', 40, 40, true, {})
end)


-- CUSTOM ADDON For retrieve scratchcard offline
RegisterNetEvent('core_inventory:custom:setScratchCardAmount')
AddEventHandler('core_inventory:custom:setScratchCardAmount', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.query('SELECT identifier, amount FROM user_scratchcard WHERE identifier = @identifier LIMIT 1', {
		['@identifier'] = tostring(xPlayer.identifier)
	  }, function(userResult)
		if userResult ~= nil and #userResult >= 1 then
			local result = userResult[1]
			if result.amount > 0 then
				if xPlayer.canCarryItem('scratchcard', result.amount) then
					xPlayer.addInventoryItem('scratchcard', result.amount)
					TriggerClientEvent('Core:ShowNotification', _source, 'Vous avez reçus '.. result.amount .. ' carte a gratter')
					MySQL.update("UPDATE user_scratchcard SET amount = @amount WHERE identifier= @identifier",{
						['@identifier'] = xPlayer.identifier,
						['@amount'] = 0
					})
				else
					TriggerClientEvent('Core:ShowNotification', _source, 'Vous n\'avez pas de place pour recevoir '.. result.amount .. ' carte a gratter')
				end
			end
		end
	  end)
end)

-- CUSTOM ADDON Check if item is usable

ESX.RegisterServerCallback('core_inventory:custom:isItemUsable', function(source, cb, item)
	cb(ESX.GetUsableItem(item))
end)

-- CUSTOM ADDON Add discord log for give item

RegisterNetEvent('core_inventory:custom:addDiscordLogGive')
AddEventHandler('core_inventory:custom:addDiscordLogGive', function(itemName, fromInv, toInv, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local targetIdentifier = toInv:gsub('content%-', ''):gsub('steam', 'steam:')
	local xTarget = ESX.GetPlayerFromIdentifier(targetIdentifier)

	if xTarget ~= nil then
		TriggerEvent('CoreLog:SendDiscordLog', "Échange d'objets", "**"..xPlayer.firstname.." "..xPlayer.lastname.." [".. GetPlayerName(_source) .. "]** a donné x"..amount.." `".. itemName .."` à **".. xTarget.firstname .." ".. xTarget.lastname .." [".. GetPlayerName(xTarget.source) .. "]**.", 'Grey', xTarget.source, _source)
	end
end)

-- CUSTOM ADDON Add discord log for put item in inventory

RegisterNetEvent('core_inventory:custom:addDiscordLogStorageAndVehicle')
AddEventHandler('core_inventory:custom:addDiscordLogStorageAndVehicle', function(itemName, item, fromInv, toInv, amount, state)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if state == 'put' then
		if string.find(toInv, 'trunk-') then
			-- put in trunk
			local plate = toInv:gsub('trunk%-', '')
			local itemType = 'ITEM'
			if string.find(item, 'weapon_') then
				itemType = 'ARME'
			end
			TriggerEvent('CoreLog:SendDiscordLog', 'Coffres de véhicules', "**[DEPOT " .. itemType .. "]** **"..xPlayer.firstname.." "..xPlayer.lastname.." `["..GetPlayerName(_source).."]` a déposé `x".. amount .." ".. itemName .."` dans le coffre du véhicule `[".. plate .."]`", 'Green', false, _source)

		elseif string.find(toInv, 'glovebox-') then
			-- put in glovebox
			local plate = toInv:gsub('glovebox%-', '')
			local itemType = 'ITEM'
			if string.find(item, 'weapon_') then
				itemType = 'ARME'
			end
			TriggerEvent('CoreLog:SendDiscordLog', 'Coffres de véhicules', "**[DEPOT " .. itemType .. "]** `"..GetPlayerName(_source).."` a déposé `x".. amount .." ".. itemName .."` dans la boite à gant du véhicule `[".. plate .."]`", 'Green', false, _source)			
			
		elseif (string.find(toInv, 'property')) then
			-- property storage
			local itemType = 'ITEM'
			if string.find(item, 'weapon_') then
				itemType = 'ARME'
			end
			local splitOwner = getPropertyOwner(toInv)
			if type(splitOwner) == 'string' then
				TriggerEvent('CoreLog:SendDiscordLog', 'Coffre propriétés', "`[DEPOT " .. itemType .. "]` **"..GetPlayerName(_source) .. "** a déposé `[x".. amount .." ".. itemName .."]` dans la propriété. [Actionnaire de l'action: ".. xPlayer.identifier ..".\nOwner de la propriété: ".. splitOwner .."].",'Green', false, _source)				
			elseif type(splitOwner) == 'table' then
				local propertyOwner = ESX.GetPlayerFromIdentifier(splitOwner.owner)
				if propertyOwner ~= nil then
					TriggerEvent('CoreLog:SendDiscordLog', 'Coffre propriétés', "`[DEPOT " .. itemType .. "]` **"..GetPlayerName(_source) .. "** a déposé `[x".. amount .." ".. itemName .."]` dans la propriété. [Actionnaire de l'action: ".. xPlayer.identifier ..".\nOwner de la propriété: ".. propertyOwner.firstname .. ' ' .. propertyOwner.lastname .. ' ' .. propertyOwner.identifier .." / Propriété : " .. splitOwner.property .."].",'Green', false, _source)
				else
					TriggerEvent('CoreLog:SendDiscordLog', 'Coffre propriétés', "`[DEPOT " .. itemType .. "]` **"..GetPlayerName(_source) .. "** a déposé `[x".. amount .." ".. itemName .."]` dans la propriété. [Actionnaire de l'action: ".. xPlayer.identifier ..".\nOwner de la propriété: ".. splitOwner.owner .. " / Proprité : " .. splitOwner.property .."].",'Green', false, _source)
				end
			end
		elseif string.find(toInv, 'society_') then
			-- enterprise storage
			local inventoryNameSplit = splitString(toInv, '_')
			local itemType = 'ITEM'
			if string.find(item, 'weapon_') then
				itemType = 'ARME'
			end
			if inventoryNameSplit ~= nil and #inventoryNameSplit > 2 then
				if string.find(toInv, 'weapons') then
					-- coffre arme
					local datas = storageJobType(inventoryNameSplit[2], 'weapon')
					if datas ~= nil and #datas > 0 then
						if not string.find(datas[1].logName, 'Default - Armurerie') then
							if datas[1].type == 'legal' then
								TriggerEvent('CoreLog:SendDiscordLog', datas[1].logName, "`[DEPOT " .. itemType .. "]` **"..xPlayer.firstname.." "..xPlayer.lastname.." `["..GetPlayerName(_source).."]` a déposé `[x".. amount .." ".. itemName .."]` dans un coffre.",'Green', false, _source)
							elseif datas[1].type == 'illegal' then
								TriggerEvent('CoreLog:SendDiscordLog', datas[1].logName, "**[COFFRE ".. itemType .." - DEPOT]**\n**[society_" .. inventoryNameSplit[2] .. "]**\n\n**"..xPlayer.firstname.." "..xPlayer.lastname.." a déposé `[x".. amount .. " " .. itemName .."]` dans un coffre.",'Green', false, _source)
							end
						else
							TriggerEvent('CoreLog:SendDiscordLog', datas[1].logName, "`[DEPOT " .. itemType .. "]`\n**[society_" .. inventoryNameSplit[2] .. "]**\n\n**"..xPlayer.firstname.." "..xPlayer.lastname.." `["..GetPlayerName(_source).."]` a déposé `[x".. amount .." ".. itemName .."]` dans un coffre.\nMétier `" .. xPlayer.job.name .. "`",'Green', false, _source)
						end						
					end				
				elseif string.find(toInv, 'utility') then
					-- coffre storage
					local datas = storageJobType(inventoryNameSplit[2], 'storage')
					if datas ~= nil and #datas > 0 then
						if not string.find(datas[1].logName, 'Default - Coffre') then
							if datas[1].type == 'legal' then
								TriggerEvent('CoreLog:SendDiscordLog', datas[1].logName, "`[DEPOT " .. itemType .. "]` **"..xPlayer.firstname.." "..xPlayer.lastname.." `["..GetPlayerName(_source).."]` a déposé `[x".. amount .." ".. itemName .."]` dans un coffre.",'Green', false, _source)
							elseif datas[1].type == 'illegal' then
								TriggerEvent('CoreLog:SendDiscordLog', datas[1].logName, "**[COFFRE ".. itemType .." - DEPOT]**\n**[society_" .. inventoryNameSplit[2] .. "]**\n\n**"..xPlayer.firstname.." "..xPlayer.lastname.." a déposé `[x".. amount .. " " .. itemName .."]` dans un coffre.",'Green', false, _source)
							end
						else
							TriggerEvent('CoreLog:SendDiscordLog', datas[1].logName, "`[DEPOT " .. itemType .. "]`\n**[society_" .. inventoryNameSplit[2] .. "]**\n\n**"..xPlayer.firstname.." "..xPlayer.lastname.." `[" .. GetPlayerName(_source).."]` a déposé `[x".. amount .." ".. itemName .."]` dans un coffre.\nMétier `" .. xPlayer.job.name .. "`",'Green', false, _source)
						end						
					end
				end
			end 
		
		elseif string.find(toInv, 'drop-') then
			local itemType = 'ITEM'
			if string.find(item, 'weapon_') then
				itemType = 'ARME'
			end
			TriggerEvent('CoreLog:SendDiscordLog', 'Default - Objet jeter', "**[DEPOT " .. itemType .. "]** **"..xPlayer.firstname.." "..xPlayer.lastname.." `["..GetPlayerName(_source).."]` a jeté `x".. amount .." ".. itemName .."` au sol", 'Green', false, _source)
		else
			-- not found default log
			TriggerEvent('CoreLog:SendDiscordLog', 'Default - Log Not Track', "`[DEPOT - NOT TRACK]`**"..xPlayer.firstname.." "..xPlayer.lastname.." `["..GetPlayerName(_source).."]` a déposé `[x".. amount .." ".. itemName .."]` du coffre [" .. toInv .. "].",'Purple', false, _source)
		end
	elseif state == 'withdraw' then
		if string.find(fromInv, 'trunk-') then
			-- put in trunk
			local plate = fromInv:gsub('trunk%-', '')
			local itemType = 'ITEM'
			if string.find(item, 'weapon_') then
				itemType = 'ARME'
			end
			TriggerEvent('CoreLog:SendDiscordLog', 'Coffres de véhicules', "**[RETRAIT " .. itemType .. "]** **"..xPlayer.firstname.." "..xPlayer.lastname.." `["..GetPlayerName(_source).."]` a retiré `x".. amount .." ".. itemName .."` dans le coffre du véhicule `[".. plate .."]`", 'Red', false, _source)

		elseif string.find(fromInv, 'glovebox-') then
			-- put in glovebox
			local plate = fromInv:gsub('glovebox%-', '')
			local itemType = 'ITEM'
			if string.find(item, 'weapon_') then
				itemType = 'ARME'
			end
			TriggerEvent('CoreLog:SendDiscordLog', 'Coffres de véhicules', "**[RETRAIT " .. itemType .. "]** `"..GetPlayerName(_source).."` a retiré `x".. amount .." ".. itemName .."` de la boite à gant du véhicule `[".. plate .."]`", 'Red', false, _source)
		elseif (string.find(fromInv, 'property')) then
			-- property storage
			local itemType = 'ITEM'
			if string.find(item, 'weapon_') then
				itemType = 'ARME'
			end

			local splitOwner = getPropertyOwner(fromInv)
			if type(splitOwner) == 'string' then
				TriggerEvent('CoreLog:SendDiscordLog', 'Coffre propriétés', "`[RETRAIT " .. itemType .. "]` **"..GetPlayerName(_source) .. "** a retiré `[x".. amount .." ".. itemName .."]` de la propriété. [Actionnaire de l'action: ".. xPlayer.identifier ..".\nOwner de la propriété: ".. splitOwner .."].",'Red', false, _source)				
			elseif type(splitOwner) == 'table' then
				local propertyOwner = ESX.GetPlayerFromIdentifier(splitOwner.owner)
				if propertyOwner ~= nil then
					TriggerEvent('CoreLog:SendDiscordLog', 'Coffre propriétés', "`[RETRAIT " .. itemType .. "]` **"..GetPlayerName(_source) .. "** a retiré `[x".. amount .." ".. itemName .."]` de la propriété. [Actionnaire de l'action: ".. xPlayer.identifier ..".\nOwner de la propriété: ".. propertyOwner.firstname .. ' ' .. propertyOwner.lastname .. ' ' .. propertyOwner.identifier .." / Propriété : " .. splitOwner.property .."].",'Red', false, _source)
				else
					TriggerEvent('CoreLog:SendDiscordLog', 'Coffre propriétés', "`[RETRAIT " .. itemType .. "]` **"..GetPlayerName(_source) .. "** a retiré `[x".. amount .." ".. itemName .."]` de la propriété. [Actionnaire de l'action: ".. xPlayer.identifier ..".\nOwner de la propriété: ".. splitOwner.owner .. " / Proprité : " .. splitOwner.property .."].",'Red', false, _source)
				end
			end		
		elseif string.find(fromInv, 'society_') then
			-- enterprise storage
			local inventoryNameSplit = splitString(fromInv, '_')
			local itemType = 'ITEM'
			if string.find(item, 'weapon_') then
				itemType = 'ARME'
			end
			if inventoryNameSplit ~= nil and #inventoryNameSplit > 2 then
				if string.find(fromInv, 'weapons') then
					-- coffre arme
					local datas = storageJobType(inventoryNameSplit[2], 'weapon')
					if datas ~= nil and #datas > 0 then
						if not string.find(datas[1].logName, 'Default - Armurerie') then
							if datas[1].type == 'legal' then
								TriggerEvent('CoreLog:SendDiscordLog', datas[1].logName, "`[RETRAIT " .. itemType .. "]` **"..xPlayer.firstname.." "..xPlayer.lastname.." `["..GetPlayerName(_source).."]` a retiré `[x".. amount .." ".. itemName .."]` du coffre.",'Red', false, _source)
							elseif datas[1].type == 'illegal' then
								TriggerEvent('CoreLog:SendDiscordLog', datas[1].logName, "**[COFFRE ".. itemType .." - RETRAIT]**\n**[society_" .. inventoryNameSplit[2] .. "]**\n\n**"..xPlayer.firstname.." "..xPlayer.lastname.." a retiré `[x".. amount .. " " .. itemName .."]` du coffre.",'Red', false, _source)
							end
						else
							TriggerEvent('CoreLog:SendDiscordLog', datas[1].logName, "`[RETRAIT " .. itemType .. "]`\n**[society_" .. inventoryNameSplit[2] .. "]**\n\n**"..xPlayer.firstname.." "..xPlayer.lastname.." `["..GetPlayerName(_source).."]` a retiré `[x".. amount .." ".. itemName .."]` du coffre.\nMétier `" .. xPlayer.job.name .. "`",'Red', false, _source)
						end
					end				
				elseif string.find(fromInv, 'utility') then
					-- coffre storage
					local datas = storageJobType(inventoryNameSplit[2], 'storage')
					if datas ~= nil and #datas > 0 then						
						if not string.find(datas[1].logName, 'Default - Coffre') then
							if datas[1].type == 'legal' then
								TriggerEvent('CoreLog:SendDiscordLog', datas[1].logName, "`[RETRAIT " .. itemType .. "]` **"..xPlayer.firstname.." "..xPlayer.lastname.." `["..GetPlayerName(_source).."]` a retiré `[x".. amount .." ".. itemName .."]` du coffre.",'Red', false, _source)
							elseif datas[1].type == 'illegal' then
								TriggerEvent('CoreLog:SendDiscordLog', datas[1].logName, "**[COFFRE ".. itemType .." - RETRAIT]**\n**[society_" .. inventoryNameSplit[2] .. "]**\n\n**"..xPlayer.firstname.." "..xPlayer.lastname.." a retiré `[x".. amount .. " " .. itemName .."]` du coffre.",'Red', false, _source)
							end
						else
							TriggerEvent('CoreLog:SendDiscordLog', datas[1].logName, "`[RETRAIT " .. itemType .. "]`\n**[society_" .. inventoryNameSplit[2] .. "]**\n\n**"..xPlayer.firstname.." "..xPlayer.lastname.." `["..GetPlayerName(_source).."]` a retiré `[x".. amount .." ".. itemName .."]` du coffre.\nMétier `" .. xPlayer.job.name .. "`",'Red', false, _source)
						end
					end
				end
			end
		elseif string.find(fromInv, 'drop-') then
			local itemType = 'ITEM'
			if string.find(item, 'weapon_') then
				itemType = 'ARME'
			end
			TriggerEvent('CoreLog:SendDiscordLog', 'Default - Objet jeter', "**[RETRAIT " .. itemType .. "]** **"..xPlayer.firstname.." "..xPlayer.lastname.." `["..GetPlayerName(_source).."]` a récupéré `x".. amount .." ".. itemName .."` au sol", 'Red', false, _source)
		
		else
			-- not found default log
			TriggerEvent('CoreLog:SendDiscordLog', 'Default - Log Not Track', "`[DEPOT / RETRAIT - NOT TRACK]`**"..xPlayer.firstname.." "..xPlayer.lastname.." `["..GetPlayerName(_source).."]` a retiré `[x".. amount .." ".. itemName .."]` du coffre [" .. fromInv .. "].",'Purple', false, _source)
		end
	end
end)

-- CUSTOM ADDON TO UPDATE METADA 

RegisterNetEvent('core_inventory:custom:updateMetadata')
AddEventHandler('core_inventory:custom:updateMetadata', function(inventory, item, metadata)
	exports['core_inventory']:updateMetadata(inventory, item, metadata)
end)

-- CUSTOM ADDON TO remvoe weapon equiped 
RegisterNetEvent('core_inventory:custom:removeAllWeaponEquiped')
AddEventHandler('core_inventory:custom:removeAllWeaponEquiped', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	exports['core_inventory']:clearInventory('primary-'..xPlayer.identifier:gsub(":",""))
	exports['core_inventory']:clearInventory('secondry-'..xPlayer.identifier:gsub(":",""))
	exports['core_inventory']:clearInventory('tertiary-'..xPlayer.identifier:gsub(":",""))
end)

-- CUSTOM AADDON TO RESET UI IsPositionOccupied

ESX.RegisterServerCallback('core_inventory:custom:resetUI', function(source, cb)
	local inventoriesToReset = { }
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		local identifierInventory = xPlayer.identifier:gsub(":", "")
		local inventories = MySQL.query.await("SELECT `name`, `data` FROM coreinventories WHERE `name` like '%".. identifierInventory .."%'", { })
		if inventories ~= nil and #inventories > 0 then
			for index, value in ipairs(inventories) do
				local inventoryCategory = value.name:gsub('-'..identifierInventory,'')
				if inventoryCategory then
					local configInventoryType = Config.Inventories[inventoryCategory]
					if configInventoryType then
						local x = configInventoryType.x
						local y = configInventoryType.y
						table.insert(inventoriesToReset, {name = value.name, x = x, y = y})
					end
				end
			end
		end
	end
	cb(inventoriesToReset)
end)