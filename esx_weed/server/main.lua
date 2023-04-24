ESX                    = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'weed', 'weed', 'society_weed', 'society_weed', 'society_weed', {type = 'private'})


TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

TriggerEvent('es:addCommand', 'playweed', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'weed') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'weed') then
    TriggerClientEvent("esx_weed:playmusic", -1, args[1])
    music = args[1]
	end	
end)

TriggerEvent('es:addCommand', 'pauseweed', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'weed') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'weed') then
		print(pause)
		if pause then
			TriggerClientEvent("esx_weed:pauseweed", -1, "play")
			pause = false
		else
			TriggerClientEvent("esx_weed:pauseweed", -1, "pause")
			pause = true
		end
	end	
end)

TriggerEvent('es:addCommand', 'volumeweed', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'weed') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'weed') then
		print(args[1])
		TriggerClientEvent("esx_weed:volumeweed", -1, args[1])
	end	
end)

TriggerEvent('es:addCommand', 'stopweed', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'weed') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'weed') then
		TriggerClientEvent("esx_weed:stopweed", -1)
	end	
end)


RegisterServerEvent('esx_weed:getFridgeStockItem')
AddEventHandler('esx_weed:getFridgeStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_weed', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez retiré x' .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_weed:getFridgeStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_weed', function(inventory)
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

RegisterServerEvent('esx_weed:putFridgeStockItems')
AddEventHandler('esx_weed:putFridgeStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_weed', function(inventory)
			local item = inventory.getItem(itemName)
	
			if item.count >= 0 then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
			else
				TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Quantité invalide. Veuillez ressayer.')
			end
	
			TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez ajouter ~y~x" .. count .. ' ~b~' .. item.label)
		end)
	else
		TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Vous n\'avez pas cet objet sur vous.')
	end
end)


RegisterServerEvent('esx_weed:buyItem')
AddEventHandler('esx_weed:buyItem', function(itemName, price, itemLabel)

    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local limit = 10
    local qtty = xPlayer.getInventoryItem(itemName).count
    local societyAccount = nil

        if qtty < limit then
            xPlayer.addInventoryItem(itemName, 1)
        else
            TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas porter plus")
        end
end)

ESX.RegisterServerCallback('esx_weed:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)
