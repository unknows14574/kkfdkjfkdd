ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config_esx_avoca2.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'avocat2', Config_esx_avoca2.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'avocat2', 'Avocat2', 'society_avocat2', 'society_avocat2', 'society_avocat2', {type = 'private'})

RegisterServerEvent('esx_avocat2:giveWeapon')
AddEventHandler('esx_avocat2:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_avocat2:getStockItem')
AddEventHandler('esx_avocat2:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_avocat2', function(inventory)

    local item = inventory.getItem(itemName)

		TriggerEvent('esx_advanced_inventory:GetInventoryWeight', function(invTaille, itemTaille) 
			weight = 50000 - invTaille
			  if item.count >= count then
				local getTaille = itemTaille * count
				if getTaille <= weight then
				   inventory.removeItem(itemName, count)
				   xPlayer.addInventoryItem(itemName, count)
				   TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Vous avez retirer " .. count .. ' ' .. item.label, 'CHAR_DAVE', 1)
				elseif getTaille >= weight then
				  TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Tu n\'as pas assez de place dans tes poches...", 'CHAR_DAVE', 1)
				end
			  else
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Quantité invalide", 'CHAR_DAVE', 1)
			  end
		  end, source, itemName)

  end)

end)

RegisterServerEvent('esx_avocat2:putStockItems')
AddEventHandler('esx_avocat2:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_avocat2', function(inventory)
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

ESX.RegisterServerCallback('esx_avocat2:getOtherPlayerData', function(source, cb, target)

  if Config_esx_avoca2.EnableESXIdentity then

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

    if Config_esx_avoca2.EnableLicenses then

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

--ESX.RegisterServerCallback('esx_avocat2:getFineList', function(source, cb, category)

  --MySQL.query(
    --'SELECT * FROM fine_types_avocat2 WHERE category = @category',
    --{
      --['@category'] = category
    --},
    --function(fines)
      --cb(fines)
   -- end
  --)

--end)

ESX.RegisterServerCallback('esx_avocat2:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_avocat2', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_avocat2:addArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_avocat2', function(store)

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

ESX.RegisterServerCallback('esx_avocat2:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_avocat2', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
        xPlayer.addWeapon(weaponName, 150)
      elseif weapons[i].count <= 0 then
        table.remove(weapons, i)
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


ESX.RegisterServerCallback('esx_avocat2:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_avocat2', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('esx_avocat2:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_avocat2', function(inventory)
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

ESX.RegisterServerCallback('esx_avocat2:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)
