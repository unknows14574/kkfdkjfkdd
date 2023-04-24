ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config_prisonfederal ~= -1 then
  TriggerEvent('esx_service:activateService', 'prison', Config_prisonfederal)
end

TriggerEvent('esx_society:registerSociety', 'prison', 'GouPrisonv', 'society_prison', 'society_prison', 'society_prison', {type = 'private'})

RegisterServerEvent('esx_prisonfederal:giveWeapon')
AddEventHandler('esx_prisonfederal:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_prisonfederal:getStockItem')
AddEventHandler('esx_prisonfederal:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_prison', function(inventory)

    local item = inventory.getItem(itemName)

		TriggerEvent('esx_advanced_inventory:GetInventoryWeight', function(invTaille, itemTaille) 
			weight = 50000 - invTaille
			  if item.count >= count then
				local getTaille = itemTaille * count
				if getTaille <= weight then
				   inventory.removeItem(itemName, count)
				   xPlayer.addInventoryItem(itemName, count)
           TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Vous avez retirer " .. count .. ' ' .. item.label, 'CHAR_DAVE', 1)
           TriggerEvent('CoreLog:SendDiscordLog', 'Prison - Coffre', "`[COFFRE]` **"..GetPlayerName(source) .. "** a retiré **`["..item.label.."]`**",'Red', false, source)
				elseif getTaille >= weight then
				  TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Tu n\'as pas assez de place dans tes poches...", 'CHAR_DAVE', 1)
				end
			  else
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Quantité invalide", 'CHAR_DAVE', 1)
			  end
		  end, source, itemName)

  end)

end)

RegisterServerEvent('esx_prisonfederal:putStockItems')
AddEventHandler('esx_prisonfederal:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_prison', function(inventory)
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

ESX.RegisterServerCallback('esx_prisonfederal:getOtherPlayerData', function(source, cb, target)

  if Config_esx_prisonfederalEnableESXIdentity then

    local xPlayer = ESX.GetPlayerFromId(target)

    local identifier = GetPlayerIdentifiers(target)[1]

    local result = MySQL.query.await("SELECT * FROM users WHERE identifier = @identifier", {
      ['@identifier'] = identifier
    })

    local user      = result[1]
    local firstname     = user['firstname']
    local lastname      = user['lastname']
    local sex           = user['sex']
    local dob           = user['dateofbirth']
    local height        = user['height'] .. " Inches"

    local data = {
      name        = GetPlayerName(target),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex         = sex,
      dob         = dob,
      height      = height
    }

    if Config_esx_prisonfederalEnableLicenses then

      TriggerEvent('esx_license:getLicenses', target, function(licenses)
        data.licenses = licenses
        cb(data)
      end)

    else
      cb(data)
    end

  else

    local xPlayer = ESX.GetPlayerFromId(target)

    local data = {
      name       = GetPlayerName(target),
      job        = xPlayer.job,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout
    }

    TriggerEvent('esx_license:getLicenses', target, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)

ESX.RegisterServerCallback('esx_prisonfederal:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_prison', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_prisonfederal:addArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('CoreLog:SendDiscordLog', 'Prison - Coffre', "`[ARMURERIE]` **"..GetPlayerName(source) .. "** a déposé **"..weaponName.."** `["..ESX.GetWeaponLabel(weaponName).."]`",'Green', false, source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_prison', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      elseif weapons[i].count <= 0 then
        table.remove(weapons, i)
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

ESX.RegisterServerCallback('esx_prisonfederal:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('CoreLog:SendDiscordLog', 'Prison - Coffre', "`[ARMURERIE]` **"..GetPlayerName(source) .. "** a retiré **"..weaponName.."** `["..ESX.GetWeaponLabel(weaponName).."]`",'Red', false, source)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_prison', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i] ~= nil then 
        if weapons[i].name == weaponName then
          weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
          foundWeapon = true
          xPlayer.addWeapon(weaponName, 150)
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


ESX.RegisterServerCallback('esx_prisonfederal:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_prison', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('esx_prisonfederal:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_prison', function(inventory)
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

ESX.RegisterServerCallback('esx_prisonfederal:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)
