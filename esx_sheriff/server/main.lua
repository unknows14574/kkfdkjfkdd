ESX = nil

function Ftext_esx_sheriff(txt)
	return Config_esx_sheriff.Txt[txt]
end

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config_esx_sheriff.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'sheriff', Config_esx_sheriff.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'sheriff', 'sheriff', 'society_sheriff', 'society_sheriff', 'society_sheriff', {type = 'public'})

RegisterServerEvent('esx_sheriff:giveWeapon')
AddEventHandler('esx_sheriff:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_sheriff:confiscatePlayerItem')
AddEventHandler('esx_sheriff:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label

    if (itemName == "weapon" or itemName == "dmv" or itemName == "drive"  or itemName == "drive_bike" or itemName == "drive_truck") then
      TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Tu peux lui prendre sa licence par l'autre menu")
    else
      targetXPlayer.removeInventoryItem(itemName, amount)
      sourceXPlayer.addInventoryItem(itemName, amount)
	
      TriggerClientEvent('esx:showNotification', sourceXPlayer.source, Ftext_esx_sheriff('you_have_confinv') .. amount .. ' ' .. label .. Ftext_esx_sheriff('from') .. targetXPlayer.name)
      TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. Ftext_esx_sheriff('confinv') .. amount .. ' ' .. label )
    end
  end

  if itemType == 'item_account' then

    targetXPlayer.removeAccountMoney(itemName, amount)
    sourceXPlayer.addAccountMoney(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, Ftext_esx_sheriff('you_have_confdm') .. amount .. Ftext_esx_sheriff('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. Ftext_esx_sheriff('confdm') .. amount)

  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, Ftext_esx_sheriff('you_have_confweapon') .. ESX.GetWeaponLabel(itemName) .. Ftext_esx_sheriff('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. Ftext_esx_sheriff('confweapon') .. ESX.GetWeaponLabel(itemName))

  end

  if itemType == 'item_amount_choose_money' then
    targetXPlayer.removeMoney(amount)
    sourceXPlayer.addMoney(amount)

    TriggerClientEvent('Core:ShowNotification', sourceXPlayer.source, "Vous avez ~r~confisqué ~y~".. amount .. "$~w~ au citoyen le plus proche (".. targetXPlayer.name ..").")
    TriggerClientEvent('Core:ShowNotification', targetXPlayer.source, "Un membre des sheriffs vous a ~r~confisqué ~y~".. amount .."$~w~.")
  end
end)

RegisterServerEvent('esx_sheriff:handcuff')
AddEventHandler('esx_sheriff:handcuff', function(target)
  TriggerClientEvent('esx_sheriff:handcuff', target)
end)

RegisterServerEvent('esx_sheriff:drag')
AddEventHandler('esx_sheriff:drag', function(target)
  local _source = source
  TriggerClientEvent('esx_sheriff:drag', target, _source)
end)

RegisterServerEvent('esx_sheriff:putInVehicle')
AddEventHandler('esx_sheriff:putInVehicle', function(target)
  TriggerClientEvent('esx_sheriff:putInVehicle', target)
end)

RegisterServerEvent('esx_sheriff:OutVehicle')
AddEventHandler('esx_sheriff:OutVehicle', function(target)
    TriggerClientEvent('esx_sheriff:OutVehicle', target)
end)

RegisterServerEvent('esx_sheriff:getStockItem')
AddEventHandler('esx_sheriff:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)

    local item = inventory.getItem(itemName)

		TriggerEvent('esx_advanced_inventory:GetInventoryWeight', function(invTaille, itemTaille) 
			weight = 50000 - invTaille
			  if item.count >= count then
				local getTaille = itemTaille * count
				if getTaille <= weight then
				   inventory.removeItem(itemName, count)
				   xPlayer.addInventoryItem(itemName, count)
				   TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Vous avez retirer " .. count .. ' ' .. item.label, 'CHAR_DAVE', 1)
           TriggerEvent('CoreLog:SendDiscordLog', 'Sheriff - Coffre', "`[COFFRE]` **"..GetPlayerName(source) .. "** a retiré **`[x"..count.." "..item.label.."]`**",'Red', false, source)
        elseif getTaille >= weight then
				  TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Tu n\'as pas assez de place dans tes poches...", 'CHAR_DAVE', 1)
				end
			  else
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Quantité invalide", 'CHAR_DAVE', 1)
			  end
		  end, source, itemName)

  end)

end)

RegisterServerEvent('esx_sheriff:putStockItems')
AddEventHandler('esx_sheriff:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)
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

ESX.RegisterServerCallback('esx_sheriff:getOtherPlayerData', function(source, cb, target)
  if Config_esx_sheriff.EnableESXIdentity then
    
    local xPlayer = ESX.GetPlayerFromId(target)

    local identifier = GetPlayerIdentifiers(target)[1]

    local result = MySQL.query.await("SELECT * FROM characters WHERE identifier = @identifier LIMIT 1", {
      ['@identifier'] = identifier
    })

    local user      = result[1]
    local firstname     = user['firstname']
    local lastname      = user['lastname']
    local sex               = user['sex']
    local dob               = user['dateofbirth']
    local heightInit        = user['height']
    local heightFeet    = tonumber(string.format("%.0f",heightInit / 12, 0))
    local heightInches    = tonumber(string.format("%.0f",heightInit % 12, 0))
    local height        = heightFeet .. "\' " .. heightInches .. "\""

    local data = {
      name        = GetPlayerName(target),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex           = sex,
      dob           = dob,
      height        = height
    }

    TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

    TriggerEvent('esx_status:getStatus', target, 'drug', function(status)

      if status ~= nil then
        data.drug = math.floor(status.percent)
      end

    end)
    
    if Config_esx_sheriff.EnableLicenses then

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

    TriggerEvent('esx_status:getStatus', _source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = status.getPercent()
      end

    end)

    TriggerEvent('esx_license:getLicenses', _source, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)

ESX.RegisterServerCallback('esx_sheriff:getFineList', function(source, cb, category)

  MySQL.query(
    'SELECT * FROM fine_types WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

ESX.RegisterServerCallback('esx_sheriff:getVehicleInfos', function(source, cb, plate)

  if Config_esx_sheriff.EnableESXIdentity then

    MySQL.query(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.query(
            'SELECT * FROM characters WHERE identifier = @identifier LIMIT 1',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local ownerName = result[1].firstname .. " " .. result[1].lastname

              local infos = {
                plate = plate,
                owner = ownerName
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  else

    MySQL.query(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.query(
            'SELECT * FROM users WHERE identifier = @identifier LIMIT 1',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local infos = {
                plate = plate,
                owner = result[1].name
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  end

end)

ESX.RegisterServerCallback('esx_sheriff:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_sheriff', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_sheriff:addArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)
  TriggerEvent('CoreLog:SendDiscordLog', 'Sheriff - Armurerie', "`[ARMURERIE]` **"..GetPlayerName(source) .. "** a déposé **"..weaponName.."** `["..ESX.GetWeaponLabel(weaponName).."]`",'Green', false, source)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_sheriff', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i] ~= nil then 
        if weapons[i].name == weaponName then
          weapons[i].count = weapons[i].count + 1
          foundWeapon = true
        elseif weapons[i].count <= 0 then
          table.remove(weapons, i)
        end
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

ESX.RegisterServerCallback('esx_sheriff:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_sheriff', function(store)

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
        TriggerEvent('CoreLog:SendDiscordLog', 'Sheriff - Armurerie', "`[ARMURERIE]` **"..GetPlayerName(source) .. "** a retiré **"..weaponName.."** `["..ESX.GetWeaponLabel(weaponName).."]`",'Red', false, source)
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


ESX.RegisterServerCallback('esx_sheriff:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_sheriff', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('esx_sheriff:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_sheriff:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)




function moneychecker(money, need)
	if money <= need then
		return true
	else
		return false
	end

end

ESX.RegisterServerCallback('esx_sheriff:CheckMoney', function (source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)

  local result = MySQL.query.await("SELECT money FROM addon_account_data WHERE account_name = @account_name LIMIT 1", 
	{
        ['@account_name'] = "society_sheriff"
    })
	
    if result[1] ~= nil then
		cb(result[1].money)
	else
		cb(0)
    end
end)

ESX.RegisterServerCallback('esx_sheriff:CheckBlackMoney', function (source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)

  local result = MySQL.query.await("SELECT black_money FROM addon_account_data WHERE account_name = @account_name LIMIT 1", 
	{
        ['@account_name'] = "society_sheriff"
    })
	
    if result[1] ~= nil then
		cb(result[1].black_money)
	else
		cb(0)
    end
end)

RegisterServerEvent('esx_sheriff:putmoney')
AddEventHandler('esx_sheriff:putmoney', function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local need = xPlayer.getMoney()

	if moneychecker(tonumber(money), tonumber(need)) == true then
		xPlayer.removeMoney(tonumber(money))
		
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_sheriff', function(account)
			account.addMoney(tonumber(money))
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposer $" .. tonumber(money) .. " en propre")
    end)
    TriggerEvent('CoreLog:SendDiscordLog', 'Sheriff - Argent', "`[ARGENT PROPRE]` **"..GetPlayerName(_source) .. "** a déposé **`[$"..tonumber(money).."]`**",'Green', false, _source)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas l\'argent')
	end
	CancelEvent()
end)

RegisterServerEvent('esx_sheriff:getmoney')
AddEventHandler('esx_sheriff:getmoney', function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_sheriff', function(account)
	
		local need = account.money
	
		if moneychecker(tonumber(money), tonumber(need)) == true then
			account.removeMoney(tonumber(money))
			
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_sheriff', function(account)
				xPlayer.addMoney(tonumber(money))
      end)
      TriggerEvent('CoreLog:SendDiscordLog', 'Sheriff - Argent', "`[ARGENT PROPRE]` **"..GetPlayerName(_source) .. "** a retiré **`[$"..tonumber(money).."]`**",'Red', false, _source)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retirer $" .. tonumber(money) .. " en propre")
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Il n\'y a pas assez d\'argent')
		end
	end)

end)

RegisterServerEvent('esx_sheriff:putblackmoney')
AddEventHandler('esx_sheriff:putblackmoney', function(_money, _blackmoney)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local money = _money
	local blackmoney = _blackmoney
	
	local need = xPlayer.getBlackMoney()
	
	if moneychecker(tonumber(money), tonumber(need)) == true then

		local final = (tonumber(blackmoney) + tonumber(money))
	
		MySQL.update('UPDATE addon_account_data SET black_money = @black_money WHERE account_name = @account_name',
		{
			['@account_name'] = "society_sheriff",
			['@black_money']   = tonumber(final)
		})
		
		xPlayer.removeAccountMoney('black_money', tonumber(money))
    TriggerEvent('CoreLog:SendDiscordLog', 'Sheriff - Argent', "`[ARGENT MARQUE]` **"..GetPlayerName(_source) .. "** a déposé **`[$"..tonumber(money).."]`**",'Green', false, _source)

		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposer $" .. tonumber(money) .. " en sale")
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas l\'argent')
	end
end)

RegisterServerEvent('esx_sheriff:getblackmoney')
AddEventHandler('esx_sheriff:getblackmoney', function(_money, _blackmoney)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local money = _money
	local blackmoney = _blackmoney
	
	if moneychecker(tonumber(money), tonumber(blackmoney)) == true then
	
	local final = (tonumber(blackmoney) - tonumber(money))

		MySQL.update('UPDATE addon_account_data SET black_money = @black_money WHERE account_name = @account_name',
		{
			['@account_name'] = "society_sheriff",
			['@black_money']   = tonumber(final)
		})
		
		xPlayer.addAccountMoney('black_money', tonumber(money))
    TriggerEvent('CoreLog:SendDiscordLog', 'Sheriff - Argent', "`[ARGENT MARQUE]` **"..GetPlayerName(_source) .. "** a retiré **`[$"..tonumber(money).."]`**",'Red', false, _source)

		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retirer $" .. tonumber(money) .. " en sale")
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Il n\'y a pas assez d\'argent')
	end
end)

local armoryStorageOpenOneTime = false

-- PREVENT INVENTORY NOT OPEN AN WEAPON CAN't BE PLACE IN
ESX.RegisterServerCallback('esx_sheriff:checkIfArmoryStorageOpenOneTime', function(source, cb, inventoryName)
  if not armoryStorageOpenOneTime then
    armoryStorageOpenOneTime = true
    cb(false)
  else
    cb(true)
  end
end)