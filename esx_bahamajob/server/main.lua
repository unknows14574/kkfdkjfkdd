ESX                    = nil
local PlayersCrafting  = {}
local PlayersCrafting2 = {}
local PlayersCrafting3 = {}
local PlayersCrafting4 = {}
local music = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'bahama', 'Bahama mas', 'society_bahama', 'society_bahama', 'society_bahama', {type = 'private'})


TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)


TriggerEvent('es:addCommand', 'playbahama', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'bahama') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'bahama') then
    TriggerClientEvent("esx_bahamajob:playmusic", -1, args[1])
    music = args[1]
	end	
end)

TriggerEvent('es:addCommand', 'pausebahama', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'bahama') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'bahama') then
		print(pause)
		if pause then
			TriggerClientEvent("esx_bahamajob:pausebahama", -1, "play")
			pause = false
		else
			TriggerClientEvent("esx_bahamajob:pausebahama", -1, "pause")
			pause = true
		end
	end	
end)

TriggerEvent('es:addCommand', 'volumebahama', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'bahama') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'bahama') then
		print(args[1])
		TriggerClientEvent("esx_bahamajob:volumebahama", -1, args[1])
	end	
end)

TriggerEvent('es:addCommand', 'stopbahama', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'bahama') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'bahama') then
		TriggerClientEvent("esx_bahamajob:stopbahama", -1)
	end	
end)

RegisterServerEvent('esx_bahamajob:getFridgeStockItem')
AddEventHandler('esx_bahamajob:getFridgeStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_bahama', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
      TriggerEvent('CoreLog:SendDiscordLog', 'Bahama - Coffre', "`[COFFRE]` **"..GetPlayerName(source) .. "** a retiré **`[x"..count.." "..item.label.."]`**",'Red', false, source)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez retiré x' .. count .. ' ' .. item.label)
  end)

end)

ESX.RegisterServerCallback('esx_bahamajob:getFridgeStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_bahama', function(inventory)
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

RegisterServerEvent('esx_bahamajob:putFridgeStockItems')
AddEventHandler('esx_bahamajob:putFridgeStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_bahama', function(inventory)
			local item = inventory.getItem(itemName)
	
			if item.count >= 0 then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
        TriggerEvent('CoreLog:SendDiscordLog', 'Bahama - Coffre', "`[COFFRE]` **"..GetPlayerName(source) .. "** a déposé **`[x"..count.." "..item.label.."]`**",'Green', false, source)
			else
				TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Quantité invalide. Veuillez ressayer.')
			end
	
			TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez ajouter ~y~x" .. count .. ' ~b~' .. item.label)
		end)
	else
		TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Vous n\'avez pas cet objet sur vous.')
  end
end)


RegisterServerEvent('esx_bahamajob:buyItem')
AddEventHandler('esx_bahamajob:buyItem', function(itemName, price, itemLabel)

    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local limit = xPlayer.getInventoryItem(itemName).limit
    local qtty = xPlayer.getInventoryItem(itemName).count
    local societyAccount = nil

    --TriggerEvent('esx_addonaccount:getSharedAccount', 'society_bahama', function(account)
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

ESX.RegisterServerCallback('esx_bahamajob:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)