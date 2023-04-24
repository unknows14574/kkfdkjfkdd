ESX                = nil

function Ftext_esx_mecanojob2(txt)
	return Config_esx_mecanojob2.Txt[txt]
end


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addCommand', 'playmeca', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'mecano2') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'mecano2') then
    TriggerClientEvent("esx_mecano2:playmusic", -1, args[1])
    music = args[1]
	end	
end)

TriggerEvent('es:addCommand', 'pausemeca', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'mecano2') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'mecano2') then
		print(pause)
		if pause then
			TriggerClientEvent("esx_mecano2:pausemecano2", -1, "play")
			pause = false
		else
			TriggerClientEvent("esx_mecano2:pausemecano2", -1, "pause")
			pause = true
		end
	end	
end)

TriggerEvent('es:addCommand', 'volumemeca', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'mecano2') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'mecano2') then
		print(args[1])
		TriggerClientEvent("esx_mecano2:volumemecano2", -1, args[1])
	end	
end)

TriggerEvent('es:addCommand', 'stopmeca', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'mecano2') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'mecano2') then
		TriggerClientEvent("esx_mecano2:stopmecano2", -1)
	end	
end)

if Config_esx_mecanojob2.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'mecano', Config_esx_mecanojob2.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'mecano2', 'Mecano moto', 'society_mecano2', 'society_mecano2', 'society_mecano2', {type = 'private'})

----------------------------------
---- Ajout Gestion Stock Boss ----
----------------------------------

RegisterServerEvent('esx_mecanojob2:getStockItem')
AddEventHandler('esx_mecanojob2:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano2', function(inventory)

    local item = inventory.getItem(itemName)

		TriggerEvent('esx_advanced_inventory:GetInventoryWeight', function(invTaille, itemTaille) 
			weight = 50000 - invTaille
			  if item.count >= count then
				local getTaille = itemTaille * count
				if getTaille <= weight then
				   inventory.removeItem(itemName, count)
				   xPlayer.addInventoryItem(itemName, count)
				   TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Vous avez retirer " .. count .. ' ' .. item.label, 'CHAR_DAVE', 1)
				   TriggerEvent('CoreLog:SendDiscordLog', 'Mecano Sandy Shores - Coffre', "`[COFFRE]` **"..GetPlayerName(source) .. "** a retiré **`["..item.label.."]`**",'Red', false, source)
				elseif getTaille >= weight then
				  TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Tu n\'as pas assez de place dans tes poches...", 'CHAR_DAVE', 1)
				end
			  else
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Quantité invalide", 'CHAR_DAVE', 1)
			  end
		  end, source, itemName)

  end)

end)

ESX.RegisterServerCallback('esx_mecanojob2:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano2', function(inventory)
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

-------------
-- AJOUT 2 --
-------------

RegisterServerEvent('esx_mecanojob2:putStockItems')
AddEventHandler('esx_mecanojob2:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano2', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
	  inventory.addItem(itemName, count)
	  TriggerEvent('CoreLog:SendDiscordLog', 'Mecano Sandy Shores - Coffre', "`[COFFRE]` **"..GetPlayerName(source) .. "** a deposé **`["..item.label.."]`**",'Green', false, source)
	  TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez ajouter ~y~x" .. count .. ' ~b~' .. item.label)
	else
		TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Quantité invalide. Veuillez ressayer.')
	end
  end)

end)

--ESX.RegisterServerCallback('esx_mecanojob2:putStockItems', function(source, cb)

--  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_policestock', function(inventory)
--    cb(inventory.items)
--  end)

--end)

ESX.RegisterServerCallback('esx_mecanojob2:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)




RegisterServerEvent('esx_mecanojob2:buyItem')
AddEventHandler('esx_mecanojob2:buyItem', function(itemName, price, itemLabel, iVal)

    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local limit = xPlayer.getInventoryItem(itemName).limit
    local qtty = xPlayer.getInventoryItem(itemName).count
    local societyAccount = nil


    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mecano2', function(account)
        societyAccount = account
   	end)

	   if societyAccount ~= nil and societyAccount.money >= price then
        	if qtty < limit then
				societyAccount.removeMoney(price)
            	xPlayer.addInventoryItem(itemName, iVal)
        	else
				TriggerClientEvent('Core:ShowNotification', _source, 'Vous ne pouvez pas porter plus.')
        	end
		else
			TriggerClientEvent('Core:ShowNotification', _source, 'Il n\'y pas assez d\'argent dans le coffre pour payer cela.')
		end
end)