ESX                    = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'coffee', 'coffee', 'society_coffee', 'society_coffee', 'society_coffee', {type = 'private'})


TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('esx_coffee:getFridgeStockItem')
AddEventHandler('esx_coffee:getFridgeStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_coffee', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez retiré x' .. count .. ' ' .. item.label)
    TriggerEvent('CoreLog:SendDiscordLog', 'Bean Coffee - Coffre', "`[COFFRE]` "..GetPlayerName(xPlayer.source) .. " a retiré x"..count.."`[".. item.label .."]`", 'Red', false, xPlayer.source)
  end)

end)

ESX.RegisterServerCallback('esx_coffee:getFridgeStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_coffee', function(inventory)
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

RegisterServerEvent('esx_coffee:putFridgeStockItems')
AddEventHandler('esx_coffee:putFridgeStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_coffee', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
      TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez ajouter ~y~x" .. count .. ' ~b~' .. item.label)
      TriggerEvent('CoreLog:SendDiscordLog', 'Bean Coffee - Coffre', "`[COFFRE]` "..GetPlayerName(xPlayer.source) .. " a déposé x"..count.."`[".. item.label .."]`", 'Green', false, xPlayer.source)
    else
      TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Quantité invalide. Veuillez ressayer.')
    end
  end)

end)


RegisterServerEvent('esx_coffee:buyItem')
AddEventHandler('esx_coffee:buyItem', function(itemName, price, itemLabel)

    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local limit = 10
    local qtty = xPlayer.getInventoryItem(itemName).count
    local societyAccount = nil

    --TriggerEvent('esx_addonaccount:getSharedAccount', 'society_coffee', function(account)
        --societyAccount = account
   -- end)
    
    --if societyAccount ~= nil and societyAccount.money >= price then
        if qtty < limit then
            --societyAccount.removeMoney(price)
            xPlayer.addInventoryItem(itemName, 1)
            --TriggerClientEvent('esx:showNotification', _source, _U('bought') .. itemLabel)
        else
            TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas porter plus")
        end
    --else
       -- TriggerClientEvent('esx:showNotification', _source, 'L\'entreprise na pas assez d\'argent')
    --end

end)

ESX.RegisterServerCallback('esx_coffee:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)

TriggerEvent('es:addCommand', 'playcoffee', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'coffee') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'coffee') then
    TriggerClientEvent("esx_coffee:playmusic", -1, args[1])
    music = args[1]
	end	
end)

TriggerEvent('es:addCommand', 'pausecoffee', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'coffee') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'coffee') then
		if pause then
			TriggerClientEvent("esx_coffee:pausecoffee", -1, "play")
			pause = false
		else
			TriggerClientEvent("esx_coffee:pausecoffee", -1, "pause")
			pause = true
		end
	end	
end)

TriggerEvent('es:addCommand', 'volumecoffee', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'coffee') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'coffee') then
		print(args[1])
		TriggerClientEvent("esx_coffee:volumecoffee", -1, args[1])
	end	
end)

TriggerEvent('es:addCommand', 'stopcoffee', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'coffee') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'coffee') then
		TriggerClientEvent("esx_coffee:stopcoffee", -1)
	end	
end)