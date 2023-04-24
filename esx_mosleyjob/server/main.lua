ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function moneychecker(money, need)
	if money <= need then
		return true
	else
		return false
	end

end

RegisterServerEvent('esx_flywheels:sell')
AddEventHandler('esx_flywheels:sell', function (store, index)
	local _source = source
	local id = index
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayer2 = ESX.GetPlayerFromId(id)

	local vehplate = store
  
	TriggerClientEvent('esx:showNotification', id, "Le véhicule " .. vehplate .. " est maintenant à vous")
			
    if vehplate ~= nil then
				
		MySQL.update(
			'UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate',
			{
				['@owner'] = xPlayer2.identifier,
				['@plate'] = vehplate
			}
		)
    end
end)

RegisterServerEvent('esx_flywheels:sell_entreprise')
AddEventHandler('esx_flywheels:sell_entreprise', function (store, iJobZ)
	local _source = source
	local vehplate = store
	
    if vehplate ~= nil then
				
		MySQL.update(
			'UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate',
			{
				['@owner'] = iJobZ,
				['@plate'] = vehplate
			}
		)
    end
end)

RegisterServerEvent('esx_flywheels:flywheels')
AddEventHandler('esx_flywheels:flywheels', function (store)
	local _source = source
	local vehplate = store
			
    if vehplate ~= nil then	
		MySQL.update(
			'UPDATE owned_vehicles SET owner = @owner, IsGrade = @grade WHERE plate = @plate',
			{
				['@owner'] = "flywheels",
				['@grade'] = '[0]',
				['@plate'] = vehplate
			}
		)
		MySQL.update.await("UPDATE owned_vehicles SET assurance =@assurance WHERE plate=@plate",{['@assurance'] = 0 , ['@plate'] = vehplate})
    end
end)

RegisterServerEvent('esx_flywheels:resell')
AddEventHandler('esx_flywheels:resell', function (store, price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local vehplate = store
  
    if vehplate ~= nil then
				
		MySQL.update(
			'DELETE FROM owned_vehicles WHERE plate = @plate',
			{
				['@owner'] = "flywheels",
				['@plate'] = vehplate
			}
		)
		
		xPlayer.addMoney(price)
    end
end)

function getPlayerVehicles(identifier)
	local vehicles = {}
	local data = MySQL.query.await("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = identifier})	
	for _,v in pairs(data) do
		local vehicle = json.decode(v.vehicle)
		table.insert(vehicles, {id = v.id, plate = vehicle.plate})
	end
	return vehicles
end

RegisterServerEvent('esx_flywheels:state')
AddEventHandler('esx_flywheels:state', function(vehicleProps, state)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = getPlayerVehicles("flywheels")
	local plate = vehicleProps.plate
	local state = state

	for _,v in pairs(vehicules) do
		if(plate == v.plate)then
			local idveh = v.id
			MySQL.update.await("UPDATE owned_vehicles SET state =@state WHERE id=@id",{['@state'] = state , ['@id'] = v.id})
			break
		end		
	end
end)	

ESX.RegisterServerCallback('esx_flywheels:stockVeh',function(source,cb, vehicleProps)
	local isFound = false
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = getPlayerVehicles("flywheels")
	local plate = vehicleProps.plate
	print(plate)
	
		for _,v in pairs(vehicules) do
			if(plate == v.plate)then
				local idveh = v.id
				local vehprop = json.encode(vehicleProps)
				MySQL.update.await("UPDATE owned_vehicles SET vehicle =@vehprop WHERE id=@id",{['@vehprop'] = vehprop, ['@id'] = v.id})
				isFound = true
				break
			end		
		end
		cb(isFound)
end)

ESX.RegisterServerCallback('esx_flywheels:getVeh', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = {}

	MySQL.query("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = "flywheels"}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicules, {vehicle = vehicle, state = v.state, plate = v.plate})
		end
		cb(vehicules)
	end)
end)

ESX.RegisterServerCallback('esx_flywheels:getJobs', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobz = {}

	MySQL.query("SELECT * FROM jobs WHERE whitelisted=@whitelisted",{['@whitelisted'] = 1}, function(data) 
		for _,v in pairs(data) do
			table.insert(jobz, {name = v.name, label = v.label, whitelisted = v.whitelisted})
		end
		cb(jobz)
	end)
end)

ESX.RegisterServerCallback('esx_flywheels:getVeh2', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = {}

	MySQL.query("SELECT * FROM flywheels WHERE owner=@identifier",{['@identifier'] = "flywheels"}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicules, {vehicle = vehicle, state = v.state, plate = v.plate})
		end
		cb(vehicules)
	end)
end)

local charset = {}
-- QWERTYUIOPASDFGHJKLZXCVBNM1234567890
for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
function string.random(length)
  math.randomseed(os.time())
  if length > 0 then
    return string.random(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end

local returnPlate = nil
function setVehicleOwned(source, vehicleProps, prix, nameV)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  vehicleProps.plate = string.random(8)
  returnPlate = vehicleProps.plate
  
  MySQL.update(
    'INSERT INTO owned_vehicles (vehicle, owner, plate, price, assurance, model, state, garage, health, IsGrade) VALUES (@vehicle, @owner, @plate, @price, @assurance, @model, @state, @garage, @health, @IsGrade)',
    {
      ['@vehicle'] = json.encode(vehicleProps),
      ['@owner']   = xPlayer.identifier, --"flywheels",
	  ['@plate']   = vehicleProps.plate,
	  ['@price']   = prix,
	  ['@assurance']   = 0,
	  ['@model']   = nameV,
	  ['@state']   = 0,
	  ['@garage']   = 0,
	  ['@health']   = '{"fuel":100.0,"engine":1000.0,"body":1000.0}',
      ['@IsGrade']   = '[0]'
    },
    function (rowsChanged)
      TriggerClientEvent('esx:showNotification', _source, "Le vehicule vous appartient !")
    end
  )
  
end

function removeVehicleOwned(plate)
  MySQL.query(
    'SELECT * FROM stolen_vehicles',
    {},
    function (result)
      for i=1, #result, 1 do
        local vehicleProps = json.decode(result[i].vehicle)

        if vehicleProps.plate == plate then
          MySQL.update(
            'DELETE FROM stolen_vehicles WHERE id = @id',
            { ['@id'] = result[i].id }
          )
        end
      end
    end
  )
end

ESX.RegisterServerCallback('esx_flywheels:returnPlate', function(source, cb)
	print(returnPlate)
	cb(returnPlate)
end)

RegisterServerEvent('esx_flywheels:steal')
AddEventHandler('esx_flywheels:steal', function(vehicleProps, prix, nameV)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicleProps = vehicleProps

	removeVehicleOwned(vehicleProps.plate)
	setVehicleOwned(_source, vehicleProps, prix, nameV)
	
end)	

ESX.RegisterServerCallback('esx_flywheels:hasMoney', function (source, cb, price)
	local occaz = math.floor(price / 100 * 25)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_voleur', function (account)
		if account.money >= occaz then
			account.removeMoney(occaz)
			cb(true)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_flywheels:GetPrice', function(source, cb, name)
	print(name)
	MySQL.query("SELECT * FROM vehicles WHERE model=@model",{['@model'] = name}, function(data) 
		for _,v in pairs(data) do
			cb(math.ceil(v.price))
		end
	end)
end)

ESX.RegisterServerCallback('esx_flywheels:GetPrixReSell', function (source, cb, plate)
    MySQL.query(
        'SELECT * FROM owned_vehicles WHERE plate = @plate',{ ['@plate'] = plate },
        function (result)
			if result ~= nil then
				for i=1, #result, 1 do
					if result[i].plate == plate then
						cb(math.ceil(result[i].price))
					else
						cb(0)
					end
				end
			else
				cb(0)
			end
        end
    )
end)

RegisterServerEvent('esx_flywheels:getStockItem2')
AddEventHandler('esx_flywheels:getStockItem2', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_flywheels', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
	  xPlayer.addInventoryItem(itemName, count)
	  TriggerEvent('CoreLog:SendDiscordLog', 'Mosley - Coffre', "`[COFFRE 2]` "..GetPlayerName(xPlayer.source) .. " a retiré x"..count.."`[".. item.label .."]`", 'Red', false, xPlayer.source)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'quantité invalide')
    end

  end)

end)

RegisterServerEvent('esx_flywheels:getStockItem')
AddEventHandler('esx_flywheels:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_flywheels', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
	  xPlayer.addInventoryItem(itemName, count)
	  TriggerEvent('CoreLog:SendDiscordLog', 'Mosley - Coffre', "`[COFFRE 1]` "..GetPlayerName(xPlayer.source) .. " a retiré x"..count.."`[".. item.label .."]`", 'Red', false, xPlayer.source)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'quantité invalide')
    end

  end)

end)

ESX.RegisterServerCallback('esx_flywheels:CheckOwner2', function (source, cb, plate)
    MySQL.query(
        'SELECT * FROM owned_vehicles WHERE plate = @plate',{ ['@plate'] = plate },
        function (result)
			if result == nil then
				cb("no")
			else
				for i=1, #result, 1 do
					if result[i].plate == plate --[[and result[i].state == 2]] then
						cb("ok")
					end
				end
			end
        end
    )
end)

ESX.RegisterServerCallback('esx_flywheels:CheckOwner', function(source, cb, plate)
	local player = ESX.GetPlayerFromId(source)
    local result = 0

    MySQL.query('SELECT * FROM owned_vehicles WHERE owner = @identifier', {
        ['@identifier'] = player.identifier
    }, function(results)
        for k, v in pairs(results) do
            local propsre = json.decode(v.vehicle) 
            if (propsre.plate == plate and v.owner == player.identifier) then
				print(player.identifier)
                result = math.ceil(v.price)
                break
            end
        end
    end)

    Wait(1000)

    if result then
        cb(result)
    else
        cb(result)
    end
end)

ESX.RegisterServerCallback('esx_flywheels:getStockItems2', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_flywheels', function(inventory)
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

ESX.RegisterServerCallback('esx_flywheels:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_flywheels', function(inventory)
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

RegisterServerEvent('esx_flywheels:putStockItems2')
AddEventHandler('esx_flywheels:putStockItems2', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_flywheels', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
	  inventory.addItem(itemName, count)
	  TriggerEvent('CoreLog:SendDiscordLog', 'Mosley - Coffre', "`[COFFRE 2]` "..GetPlayerName(xPlayer.source) .. " a déposé x"..count.."`[".. item.label .."]`", 'Green', false, xPlayer.source)
	  TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez ajouter ~y~x" .. count .. ' ~b~' .. item.label)
	else
		TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Quantité invalide. Veuillez ressayer.')
	end
  end)
end)

RegisterServerEvent('esx_flywheels:putStockItems')
AddEventHandler('esx_flywheels:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_flywheels', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
	  inventory.addItem(itemName, count)
	  TriggerEvent('CoreLog:SendDiscordLog', 'Mosley - Coffre', "`[COFFRE 1]` "..GetPlayerName(xPlayer.source) .. " a déposé x"..count.."`[".. item.label .."]`", 'Green', false, xPlayer.source)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'quantité invalide')
    end

  end)

end)

ESX.RegisterServerCallback('esx_flywheels:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)

RegisterServerEvent('esx_flywheels:onNPCJobMissionCompleted')
AddEventHandler('esx_flywheels:onNPCJobMissionCompleted', function(pay)
  local xPlayer = ESX.GetPlayerFromId(source)
  local runs = 1000
  local societyAccount = nil

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_flywheels', function(account)
    societyAccount = account
  end)

  if societyAccount ~= nil then
	local playerMoney  = runs/2
    local societyMoney = runs

    xPlayer.addMoney(playerMoney)
    societyAccount.addMoney(societyMoney)

    TriggerClientEvent('esx:showNotification', xPlayer.source, 'vous avez gagné ~g~$' .. playerMoney)
  else
    xPlayer.addMoney(runs)
    TriggerClientEvent('esx:showNotification', xPlayer.source, 'votre avez gagné ~g~$' .. runs)
	
  end
end)

ESX.RegisterServerCallback('esx_flywheels:getVaultWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_flywheels', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_flywheels:removeVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_flywheels', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
		foundWeapon = true
		xPlayer.addWeapon(weaponName, 1000)
		TriggerEvent('CoreLog:SendDiscordLog', 'Mosley - Coffre', "`[ARMURERIE]` "..GetPlayerName(source) .. " a retiré`[".. ESX.GetWeaponLabel(weaponName) .."]`", 'Red', false, source)
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

ESX.RegisterServerCallback('esx_flywheels:addVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_flywheels', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
		foundWeapon = true
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('CoreLog:SendDiscordLog', 'Mosley - Coffre', "`[ARMURERIE]` "..GetPlayerName(source) .. " a déposé `[".. ESX.GetWeaponLabel(weaponName) .."]`", 'Green', false, source)
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

ESX.RegisterServerCallback('esx_flywheels:CheckMoney2', function (source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)

  local result = MySQL.query.await("SELECT money FROM addon_account_data WHERE account_name = @account_name", 
	{
        ['@account_name'] = "society_flywheels"
    })
	
    if result[1] ~= nil then
		cb(result[1].money)
	else
		cb(0)
    end
end)

ESX.RegisterServerCallback('esx_flywheels:CheckMoney', function (source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)

  local result = MySQL.query.await("SELECT money FROM addon_account_data WHERE account_name = @account_name", 
	{
        ['@account_name'] = "society_flywheels"
    })
	
    if result[1] ~= nil then
		cb(result[1].money)
	else
		cb(0)
    end
end)

ESX.RegisterServerCallback('esx_flywheels:CheckBlackMoney', function (source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)

  local result = MySQL.query.await("SELECT black_money FROM addon_account_data WHERE account_name = @account_name", 
	{
        ['@account_name'] = "society_flywheels"
    })
	
    if result[1] ~= nil then
		cb(result[1].black_money)
	else
		cb(0)
    end
end)

RegisterServerEvent('esx_flywheels:putmoney2')
AddEventHandler('esx_flywheels:putmoney2', function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local need = xPlayer.getMoney()

	if moneychecker(tonumber(money), tonumber(need)) == true then
		xPlayer.removeMoney(tonumber(money))
		
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_flywheels', function(account)
			account.addMoney(tonumber(money))
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposer $" .. tonumber(money) .. " en propre")
			TriggerEvent('CoreLog:SendDiscordLog', 'Mosley - Argent', "`[ARGENT PROPRE | COFFRE 2]` "..GetPlayerName(source) .. " a déposé `$"..tonumber(money).."`", 'Green', false, source)
		end)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas l\'argent')
	end
	CancelEvent()
end)

RegisterServerEvent('esx_flywheels:putmoney')
AddEventHandler('esx_flywheels:putmoney', function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local need = xPlayer.getMoney()

	if moneychecker(tonumber(money), tonumber(need)) == true then
		xPlayer.removeMoney(tonumber(money))
		
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_flywheels', function(account)
			account.addMoney(tonumber(money))
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposer $" .. tonumber(money) .. " en propre")
			TriggerEvent('CoreLog:SendDiscordLog', 'Mosley - Argent', "`[ARGENT PROPRE | COFFRE 1]` "..GetPlayerName(source) .. " a déposé `$"..tonumber(money).."`", 'Green', false, source)
		end)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas l\'argent')
	end
	CancelEvent()
end)

RegisterServerEvent('esx_flywheels:getmoney2')
AddEventHandler('esx_flywheels:getmoney2', function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_flywheels', function(account)
	
		local need = account.money
	
		if moneychecker(tonumber(money), tonumber(need)) == true then
			account.removeMoney(tonumber(money))
			
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_flywheels', function(account)
				xPlayer.addMoney(tonumber(money))
			end)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retirer $" .. tonumber(money) .. " en propre")
			TriggerEvent('CoreLog:SendDiscordLog', 'Mosley - Argent', "`[ARGENT PROPRE | COFFRE 2]` "..GetPlayerName(source) .. " a retiré `$"..tonumber(money).."`", 'Red', false, source)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Il n\'y a pas assez d\'argent')
		end
	end)

end)

RegisterServerEvent('esx_flywheels:getmoney')
AddEventHandler('esx_flywheels:getmoney', function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_flywheels', function(account)
	
		local need = account.money
	
		if moneychecker(tonumber(money), tonumber(need)) == true then
			account.removeMoney(tonumber(money))
			
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_flywheels', function(account)
				xPlayer.addMoney(tonumber(money))
			end)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retirer $" .. tonumber(money) .. " en propre")
			TriggerEvent('CoreLog:SendDiscordLog', 'Mosley - Argent', "`[ARGENT PROPRE | COFFRE 1]` "..GetPlayerName(source) .. " a retiré `$"..tonumber(money).."`", 'Red', false, source)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Il n\'y a pas assez d\'argent')
		end
	end)

end)

RegisterServerEvent('esx_flywheels:putblackmoney')
AddEventHandler('esx_flywheels:putblackmoney', function(_money, _blackmoney)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = _money
	local blackmoney = _blackmoney
	
	local need = xPlayer.getBlackMoney()
	
	if moneychecker(tonumber(money), tonumber(need)) == true then

		local final = (tonumber(blackmoney) + tonumber(money))
	
		MySQL.update('UPDATE addon_account_data SET black_money = @black_money WHERE account_name = @account_name',
		{
			['@account_name'] = "society_flywheels",
			['@black_money']   = tonumber(final)
		})
		
		xPlayer.removeAccountMoney('black_money', tonumber(money))
		
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposer $" .. tonumber(money) .. " en sale")
		TriggerEvent('CoreLog:SendDiscordLog', 'Mosley - Argent', "`[ARGENT MARQUEE | COFFRE 1]` "..GetPlayerName(source) .. " a déposé `$"..tonumber(money).."`", 'Green', false, source)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas l\'argent')
	end
end)

RegisterServerEvent('esx_flywheels:getblackmoney')
AddEventHandler('esx_flywheels:getblackmoney', function(_money, _blackmoney)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = _money
	local blackmoney = _blackmoney
	
	if moneychecker(tonumber(money), tonumber(blackmoney)) == true then
	
	local final = (tonumber(blackmoney) - tonumber(money))

		MySQL.update('UPDATE addon_account_data SET black_money = @black_money WHERE account_name = @account_name',
		{
			['@account_name'] = "society_flywheels",
			['@black_money']   = tonumber(final)
		})
		
		xPlayer.addAccountMoney('black_money', tonumber(money))
		
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retirer $" .. tonumber(money) .. " en sale")
		TriggerEvent('CoreLog:SendDiscordLog', 'Mosley - Argent', "`[ARGENT MARQUEE | COFFRE 1]` "..GetPlayerName(source) .. " a retiré `$"..tonumber(money).."`", 'Red', false, source)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Il n\'y a pas assez d\'argent')
	end


end)

RegisterServerEvent('esx_flywheels:ChangeJob')
AddEventHandler('esx_flywheels:ChangeJob', function(id, job, grade)
	local xPlayer = ESX.GetPlayerFromId(tonumber(id))
	xPlayer.setJob(job, grade)
	
	TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez un nouveau job !')
	
	TriggerClientEvent('esx:setJob', job)
end)

RegisterServerEvent('esx_flywheels:ChangeJob2')
AddEventHandler('esx_flywheels:ChangeJob2', function(id, job, grade)
	local xPlayer = ESX.GetPlayerFromId(tonumber(id))
	xPlayer.setJob2(job, grade)
	
	TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez un nouveau job !')
	
	TriggerClientEvent('esx:setJob2', job)
end)

ESX.RegisterServerCallback('esx_flywheels:getVehicles', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = {}

	MySQL.query("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = xPlayer.getIdentifier()}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			local health = json.decode(v.health)
			table.insert(vehicules, {vehicle = vehicle, state = v.state, assurance = v.assurance, plate = v.plate, price = v.price, garage = v.garage, health = health})
		end
		cb(vehicules)
	end)
end)

RegisterServerEvent('esx_mosley:checkForLimitation')
AddEventHandler('esx_mosley:checkForLimitation', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  local checkLimitation = exports.Nebula_farmlimitation:UserReachFarmLimitation(xPlayer.getIdentifier(), 1, 'mosleyJob')
  TriggerClientEvent("esx_mosley:responseCheckForLimitation", source, checkLimitation)
end)

TriggerEvent('es:addCommand', 'playmosley', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'flywheels') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'flywheels') then
		TriggerClientEvent("esx_mosley:playmusic", -1, args[1])
		music = args[1]
	end	
end)

TriggerEvent('es:addCommand', 'pausemosley', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'flywheels') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'flywheels') then
		if pause then
			TriggerClientEvent("esx_mosley:pausemosley", -1, "play")
			pause = false
		else
			TriggerClientEvent("esx_mosley:pausemosley", -1, "pause")
			pause = true
		end
	end	
end)

TriggerEvent('es:addCommand', 'volumemosley', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'flywheels') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'flywheels') then
		print(args[1])
		TriggerClientEvent("esx_mosley:volumemosley", -1, args[1])
	end	
end)

TriggerEvent('es:addCommand', 'stopmosley', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'flywheels') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'flywheels') then
		TriggerClientEvent("esx_mosley:stopmosley", -1)
	end	
end)