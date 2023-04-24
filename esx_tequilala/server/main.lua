ESX                = nil


function Ftext_esx_tequilala(txt)
	return Config_esx_tequilala.Txt[txt]
end

local PlayersHarvesting  = {}
local music = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


TriggerEvent('es:addCommand', 'playtequi', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'tequi') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'tequi') then
    TriggerClientEvent("esx_tequilala:playmusic", -1, args[1])
    music = args[1]
	end	
end)

TriggerEvent('es:addCommand', 'pausetequi', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'tequi') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'tequi') then
		print(pause)
		if pause then
			TriggerClientEvent("esx_tequilala:pausetequi", -1, "play")
			pause = false
		else
			TriggerClientEvent("esx_tequilala:pausetequi", -1, "pause")
			pause = true
		end
	end	
end)

TriggerEvent('es:addCommand', 'volumetequi', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'tequi') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'tequi') then
		print(args[1])
		TriggerClientEvent("esx_tequilala:volumetequi", -1, args[1])
	end	
end)

TriggerEvent('es:addCommand', 'stoptequi', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'tequi') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'tequi') then
		TriggerClientEvent("esx_tequilala:stoptequi", -1)
	end	
end)

if Config_esx_tequilala.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'tequi', Config_esx_tequilala.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'tequi', 'tequi', 'society_tequi', 'society_tequi', 'society_tequi', {type = 'private'})

local temp = false
local tempZ = 3000
RegisterServerEvent('esx_tequi:drugsOn')
AddEventHandler('esx_tequi:drugsOn', function()
    temp = true
end)
RegisterServerEvent('esx_tequi:drugsOff')
AddEventHandler('esx_tequi:drugsOff', function()
    temp = false
end)

function rDBText()
    local num = math.random(0,3)
    if num == 0 then return "bvodka"
    elseif num == 1 then return "bwhisky"
    elseif num == 2 then return "brhum"
    elseif num == 3 then return "btequila"
    end
end

RegisterServerEvent('esx_tequi:getStockItem')
AddEventHandler('esx_tequi:getStockItem', function(itemName, count, itemLabel)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tequi', function(inventory)

    local item = inventory.getItem(itemName)

		TriggerEvent('esx_advanced_inventory:GetInventoryWeight', function(invTaille, itemTaille) 
			weight = 50000 - invTaille
			  if item.count >= count then
				local getTaille = itemTaille * count
				if getTaille <= weight then
				   inventory.removeItem(itemName, count)
				   xPlayer.addInventoryItem(itemName, count)
           TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Vous avez retirer " .. count .. ' ' .. item.label, 'CHAR_DAVE', 1)
           TriggerEvent('CoreLog:SendDiscordLog', 'Tequi-La-La', "`[COFFRE]` **".. xPlayer.name .. "** a retiré **`[x"..count.." "..itemLabel.."]`**",'Red', false, source)
          elseif getTaille >= weight then
				  TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Tu n\'as pas assez de place dans tes poches...", 'CHAR_DAVE', 1)
				end
			  else
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Quantité invalide", 'CHAR_DAVE', 1)
			  end
		  end, source, itemName)

  end)

end)

ESX.RegisterServerCallback('esx_tequi:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tequi', function(inventory)
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

RegisterServerEvent('esx_tequi:putStockItems')
AddEventHandler('esx_tequi:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tequi', function(inventory)
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

RegisterServerEvent('esx_tequi:getFridgeStockItem')
AddEventHandler('esx_tequi:getFridgeStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tequi_fridge', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)

      xPlayer.addInventoryItem(itemName, count)
      TriggerEvent('CoreLog:SendDiscordLog', 'Tequi-La-La', "`[FRIGO]` **".. xPlayer.name .. "** a retiré **`[x"..count.." "..item.label.."]`**",'Red', false, source)
      TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez retiré ~y~x" .. count .. ' ~b~' .. item.label)
    else
      TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Quantité invalide')
    end
  end)
end)

ESX.RegisterServerCallback('esx_tequi:getFridgeStockItem', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tequi_fridge', function(inventory)
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

RegisterServerEvent('esx_tequi:putFridgeStockItems')
AddEventHandler('esx_tequi:putFridgeStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tequi_fridge', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
      TriggerEvent('CoreLog:SendDiscordLog', 'Tequi-La-La', "`[FRIGO]` **".. xPlayer.name .. "** a déposé **`[x"..count.." "..item.label.."]`**",'Green', false, source)
      TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez ajouter ~y~x" .. count .. ' ~b~' .. item.label)
    else
      TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Quantité invalide')
    end
  end)
end)

RegisterServerEvent('esx_tequi:buyItem')
AddEventHandler('esx_tequi:buyItem', function(itemName, price, itemLabel)

    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local limit = xPlayer.getInventoryItem(itemName).limit
    local qtty = xPlayer.getInventoryItem(itemName).count
        if qtty < limit then
            xPlayer.addInventoryItem(itemName, 50)
            TriggerEvent('CoreLog:SendDiscordLog', 'Tequi-La-La', "`[BOUTIQUE]` **".. xPlayer.name .. "** a acheté **"..itemLabel.."** à la boutique.",'Purple', false, source)
        else
            TriggerClientEvent('esx:showNotification', _source, Ftext_esx_tequilala('max_item'))
        end
end)

ESX.RegisterServerCallback('esx_tequi:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)
