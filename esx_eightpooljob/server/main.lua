ESX                    = nil
local PlayersCrafting  = {}
local PlayersCrafting2 = {}
local PlayersCrafting3 = {}
local PlayersCrafting4 = {}
local music = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_phone:registerNumber', 'eightpool', "8 Pool", true, true)
TriggerEvent('esx_society:registerSociety', 'eightpool', '8 Pool', 'society_eightpool', 'society_eightpool', 'society_eightpool', {type = 'private'})

AddEventHandler('esx:playerLoaded', function(source)
	if music then
		TriggerClientEvent("xnNightclub:playmusic", source, music)
	end
end)


TriggerEvent('es:addCommand', 'playeightpool', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'eightpool') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'eightpool') then
    TriggerClientEvent("esx_eightpooljob:playmusic", -1, args[1])
    music = args[1]
	end	
end)

TriggerEvent('es:addCommand', 'pauseeightpool', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'eightpool') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'eightpool') then
		print(pause)
		if pause then
			TriggerClientEvent("esx_eightpooljob:pauseeightpool", -1, "play")
			pause = false
		else
			TriggerClientEvent("esx_eightpooljob:pauseeightpool", -1, "pause")
			pause = true
		end
	end	
end)

TriggerEvent('es:addCommand', 'volumeeightpool', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'eightpool') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'eightpool') then
		print(args[1])
		TriggerClientEvent("esx_eightpooljob:volumeeightpool", -1, args[1])
	end	
end)

TriggerEvent('es:addCommand', 'stopeightpool', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'eightpool') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'eightpool') then
		TriggerClientEvent("esx_eightpooljob:stopeightpool", -1)
	end	
end)

RegisterServerEvent('esx_eightpooljob:getFridgeStockItem')
AddEventHandler('esx_eightpooljob:getFridgeStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_eightpool', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez retiré x' .. count .. ' ' .. item.label)
	TriggerEvent('CoreLog:SendDiscordLog', '8 Pool Bar - Coffre', "`[COFFRE]` "..GetPlayerName(xPlayer.source) .. " a retiré x"..count.."`[".. item.label .."]`", 'Red', false, xPlayer.source)
  end)

end)

ESX.RegisterServerCallback('esx_eightpooljob:getFridgeStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_eightpool', function(inventory)
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

RegisterServerEvent('esx_eightpooljob:putFridgeStockItems')
AddEventHandler('esx_eightpooljob:putFridgeStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_eightpool', function(inventory)
			local item = inventory.getItem(itemName)
	
			if item.count >= 0 then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
			else
				TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Quantité invalide. Veuillez ressayer.')
			end
	
			TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez ajouté ~y~x" .. count .. ' ~b~' .. item.label)
			TriggerEvent('CoreLog:SendDiscordLog', '8 Pool Bar - Coffre', "`[COFFRE]` "..GetPlayerName(xPlayer.source) .. " a déposé x"..count.."`[".. item.label .."]`", 'Green', false, xPlayer.source)
		end)
	else
		TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Vous n\'avez pas cet objet sur vous.')
  end
end)

ESX.RegisterServerCallback('esx_eightpooljob:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items = xPlayer.inventory

  cb({
    items = items
  })
end)
