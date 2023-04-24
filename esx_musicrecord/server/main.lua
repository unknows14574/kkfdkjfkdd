ESX                = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'musicrecord', 'musicrecord', 'society_musicrecord', 'society_musicrecord', 'society_musicrecord', {type = 'public'})

RegisterServerEvent('esx_musicrecord:getStockItem')
AddEventHandler('esx_musicrecord:getStockItem', function(itemName, count)
  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_musicrecord', function(inventory)
    local item = inventory.getItem(itemName)
		TriggerEvent('esx_advanced_inventory:GetInventoryWeight', function(invTaille, itemTaille) 
			weight = 50000 - invTaille
			  if item.count >= count then
				local getTaille = itemTaille * count
				if getTaille <= weight then
				   inventory.removeItem(itemName, count)
				   xPlayer.addInventoryItem(itemName, count)
           TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Vous avez retirer " .. count .. ' ' .. item.label, 'CHAR_DAVE', 1)
           TriggerEvent('CoreLog:SendDiscordLog', 'Music Record - Coffre', "`[COFFRE]` "..GetPlayerName(xPlayer.source) .. " a retiré x"..count.."`[".. item.label .."]`", 'Red', false, xPlayer.source)
				elseif getTaille >= weight then
				  TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Tu n\'as pas assez de place dans tes poches...", 'CHAR_DAVE', 1)
				end
			  else
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Quantité invalide", 'CHAR_DAVE', 1)
			  end
		  end, source, itemName)

  end)

end)

ESX.RegisterServerCallback('esx_musicrecord:getStockItems', function(source, cb)
  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_musicrecord', function(inventory)
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

    table.sort(inventory.items, cmp)
    cb(inventory.items)
  end)
end)

RegisterServerEvent('esx_musicrecord:AddItem')
AddEventHandler('esx_musicrecord:AddItem', function(item)
  local _source = source
  local player = ESX.GetPlayerFromId(_source)

  if player then
    player.addInventoryItem(item, 1)
    TriggerClientEvent('Core:ShowNotification', "Tu as gravé ~y~x1 "..item)
  end
end)

RegisterServerEvent('esx_musicrecord:putStockItems')
AddEventHandler('esx_musicrecord:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_musicrecord', function(inventory)
			local item = inventory.getItem(itemName)
	
			if item.count >= 0 then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
        TriggerEvent('CoreLog:SendDiscordLog', 'Music Record - Coffre', "`[COFFRE]` "..GetPlayerName(xPlayer.source) .. " a déposé x"..count.."`[".. item.label .."]`", 'Green', false, xPlayer.source)
        TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez ajouter ~y~x" .. count .. ' ~b~' .. item.label)
			else
				TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Quantité invalide. Veuillez ressayer.')
			end
		end)
	else
		TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Vous n\'avez pas cet objet sur vous.')
	end
end)

ESX.RegisterServerCallback('esx_musicrecord:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })
end)

ESX.RegisterServerCallback('esx_musicrecord:getFineList', function(source, cb, category)
  MySQL.query(
    'SELECT * FROM fine_types_radio WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )
end)

RegisterServerEvent('esx_musicrecord:canCraftObject')
AddEventHandler('esx_musicrecord:canCraftObject', function(itemName, price)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_musicrecord', function(account)
		if account.money < price then
			TriggerClientEvent('esx:showAdvancedNotification', source, "Coffre", "", "Vous n'avez pas assez d'argent dans le coffre de l'entreprise", 'CHAR_DAVE', 1)			
		else
			account.removeMoney(price)
			TriggerClientEvent('esx_musicrecord:craftObject', source, itemName)
		end
	end)
end)

TriggerEvent('es:addCommand', 'playlabel', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'musicrecord') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'musicrecord') then
    TriggerClientEvent("esx_musicrecord:playmusic", -1, args[1])
    music = args[1]
	end	
end)

TriggerEvent('es:addCommand', 'pauselabel', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'musicrecord') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'musicrecord') then
		if pause then
			TriggerClientEvent("esx_musicrecord:pausemusicrecord", -1, "play")
			pause = false
		else
			TriggerClientEvent("esx_musicrecord:pausemusicrecord", -1, "pause")
			pause = true
		end
	end	
end)

TriggerEvent('es:addCommand', 'volumelabel', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'musicrecord') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'musicrecord') then
		TriggerClientEvent("esx_musicrecord:volumemusicrecord", -1, args[1])
	end	
end)

TriggerEvent('es:addCommand', 'stoplabel', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'musicrecord') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'musicrecord') then
		TriggerClientEvent("esx_musicrecord:stopmusicrecord", -1)
	end	
end)

-- Studio 2
TriggerEvent('es:addCommand', 'playlabel2', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'musicrecord') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'musicrecord') then
    TriggerClientEvent("esx_musicrecord:playmusic2", -1, args[1])
    music = args[1]
	end	
end)

TriggerEvent('es:addCommand', 'pauselabel2', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'musicrecord') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'musicrecord') then
		if pause then
			TriggerClientEvent("esx_musicrecord:pausemusicrecord2", -1, "play")
			pause = false
		else
			TriggerClientEvent("esx_musicrecord:pausemusicrecord2", -1, "pause")
			pause = true
		end
	end	
end)

TriggerEvent('es:addCommand', 'volumelabel2', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'musicrecord') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'musicrecord') then
		TriggerClientEvent("esx_musicrecord:volumemusicrecord2", -1, args[1])
	end	
end)

TriggerEvent('es:addCommand', 'stoplabel2', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'musicrecord') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'musicrecord') then
		TriggerClientEvent("esx_musicrecord:stopmusicrecord2", -1)
	end	
end)