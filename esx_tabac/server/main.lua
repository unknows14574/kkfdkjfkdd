ESX                = nil

function Ftext_esx_tabac(txt)
	return Config_esx_tabac.Txt[txt]
end

local PlayersHarvesting  = {}
local Harvesting = false
local Transforming = false
local Selling = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config_esx_tabac.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'tabac', Config_esx_tabac.MaxInService)
end

--TriggerEvent('esx_society:registerSociety', 'tabac', 'tabac', 'society_tabac', 'society_tabac', 'society_tabac', {type = 'private'})


RegisterServerEvent('esx_tabac:stopHarvest')
AddEventHandler('esx_tabac:stopHarvest', function()
  Harvesting = false
end)
RegisterServerEvent('esx_tabac:stopTraitement')
AddEventHandler('esx_tabac:stopTraitement', function()
  Transforming = false
end)
RegisterServerEvent('esx_tabac:stopSell')
AddEventHandler('esx_tabac:stopSell', function()
  Selling = false
end)

local temp = false
local tempZ = 3000
RegisterServerEvent('esx_tabac:drugsOn')
AddEventHandler('esx_tabac:drugsOn', function()
    temp = true
end)
RegisterServerEvent('esx_tabac:drugsOff')
AddEventHandler('esx_tabac:drugsOff', function()
    temp = false
end)

local function Harvest(source, item)

	TriggerClientEvent('esx_drugs:EnableE', source)

  if temp then
	tempZ = 1500
  else
    tempZ = 3000
  end
	
  SetTimeout(tempZ, function()

    if Harvesting == true then

      local xPlayer = ESX.GetPlayerFromId(source)
      local Quantity = xPlayer.getInventoryItem(item).count

      if Quantity >= xPlayer.getInventoryItem(item).limit then
        Harvesting = false
        TriggerClientEvent('esx:showNotification', source, 'vous en portez déjà assez sur vous.')
      else
		--TriggerClientEvent('esx_drugs:PlayAnim', source)
        xPlayer.addInventoryItem(item, 1)

        Harvest(source, item)
      end
    end
  end)
end

local function Harvest2(source, item)

	TriggerClientEvent('esx_drugs:EnableE', source)

  if temp then
	tempZ = 1500
  else
    tempZ = 3000
  end
	
  SetTimeout(tempZ, function()

    if Harvesting == true then

      local xPlayer = ESX.GetPlayerFromId(source)
      local Quantity = xPlayer.getInventoryItem(item).count
      local qtt = xPlayer.getInventoryItem("engrais").count

      if qtt >= 1 then
        if Quantity >= xPlayer.getInventoryItem(item).limit then
            Harvesting = false
            TriggerClientEvent('esx:showNotification', source, 'vous en portez déjà assez sur vous.')
        else
            --TriggerClientEvent('esx_drugs:PlayAnim', source)
            xPlayer.removeInventoryItem("engrais", 1)
            xPlayer.addInventoryItem(item, 1)

            Harvest2(source, item)
        end
      else
        TriggerClientEvent('esx:showNotification', source, "Vous n\'avez pas assez d'engrais")
      end
    end
  end)
end

-- function rDBText()
--     local num = math.random(0,6)
--     if num == 0 then return "ruinart"
--     elseif num == 1 then return "bvodka"
--     elseif num == 2 then return "bwhisky"
--     elseif num == 3 then return "brhum"
--     elseif num == 4 then return "btequila"
--     elseif num == 5 then return "champagne"
--     elseif num == 6 then return "vrose"
--     end
-- end

-- ESX.RegisterUsableItem('balcool', function(source)

--     local xPlayer = ESX.GetPlayerFromId(source)
    
-- 	xPlayer.addInventoryItem(rDBText(), 5)
-- 	xPlayer.removeInventoryItem('balcool', 1)
	
-- 	TriggerClientEvent('esx:showNotification', source, "Vous avez ouvert un carton d'alcool")
-- end)

local function Traitement(source)

	TriggerClientEvent('esx_drugs:EnableE', source)

	if temp then
	tempZ = 1500
  else
    tempZ = 3000
  end
	
	SetTimeout(tempZ, function()
		if Transforming == true then
			local xPlayer  = ESX.GetPlayerFromId(source)
			local Quantity1 = xPlayer.getInventoryItem('alcool').count
			local Quantity2 = xPlayer.getInventoryItem('balcool').count

			if Quantity1 >= 5 then
                if Quantity2 >= xPlayer.getInventoryItem('balcool').limit then
                    Transforming = false
					TriggerClientEvent('esx:showNotification', source, 'vous portez trop de bouteille sur vous.')
				else
					--TriggerClientEvent('esx_drugs:PlayAnim', source)
					xPlayer.removeInventoryItem('alcool', 5)
					xPlayer.addInventoryItem('balcool', 1)
					Traitement(source)
				end
				
			else
				TriggerClientEvent('esx:showNotification', source, 'vous n\'avez pas assez d\'alcool pur.')
			end
		end
	end)
end
local function Traitement2(source)

	TriggerClientEvent('esx_drugs:EnableE', source)

	if temp then
	tempZ = 1500
	  else
		tempZ = 3000
	  end
	
	SetTimeout(tempZ, function()
		if Transforming == true then
			local xPlayer  = ESX.GetPlayerFromId(source)
			local Quantity1 = xPlayer.getInventoryItem('weed2').count
            local Quantity2 = xPlayer.getInventoryItem('pweed2').count

			if Quantity1 >= 5 then
                if Quantity2 >= xPlayer.getInventoryItem('pweed2').limit then
                    Transforming = false
					TriggerClientEvent('esx:showNotification', source, 'vous portez trop de pochon sur vous.')
				else
					--TriggerClientEvent('esx_drugs:PlayAnim', source)
					xPlayer.removeInventoryItem('weed2', 5)
					xPlayer.addInventoryItem('pweed2', 1)
					Traitement2(source)
				end
				
			else
				TriggerClientEvent('esx:showNotification', source, 'vous n\'avez pas assez de weed.')
			end
		end
	end)
end
local function SellAlcool(source)

	TriggerClientEvent('esx_drugs:EnableE', source)
	
	if temp then
	tempZ = 1500
	  else
		tempZ = 3000
	  end
	
	SetTimeout(tempZ, function()
		if Selling == true then
			local xPlayer  = ESX.GetPlayerFromId(source)
			local Quantity = xPlayer.getInventoryItem('balcool').count
			local rand = 5
			
			if xPlayer.job.grade == 0 then
				rand = math.random(5,8)
				--rand = math.random(10,15)
			elseif xPlayer.job.grade == 1 or xPlayer.job.grade == 2 then
				rand = math.random(8,12)
				--rand = math.random(15,20)
			end
			
			if Quantity >= 1 then
				--TriggerClientEvent('esx_drugs:PlayAnim', source)
				xPlayer.removeInventoryItem('balcool', 1)
				xPlayer.addMoney(rand)
				
				local eAdd = rand / 4 --25%
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. xPlayer.job.name, function(account)
					account.addMoney(eAdd)
				end)
				
				TriggerClientEvent('esx:showNotification', source, 'x1 bouteille d\'alcool' .. " ~r~$" .. rand)
				SellAlcool(source)
			else
				TriggerClientEvent('esx:showNotification', source, 'vous avez besoin de ~r~1 ~b~bouteille d\'alcool.')
			end
		end
	end)
end

RegisterServerEvent('esx_tabac:startHarvest', item)
AddEventHandler('esx_tabac:startHarvest', function(item)
  Harvesting = true
  TriggerClientEvent('esx:showNotification', source, 'En cours..')
  Harvest(source, item)
end)
RegisterServerEvent('esx_tabac:startHarvest2', item)
AddEventHandler('esx_tabac:startHarvest2', function(item)
  Harvesting = true
  TriggerClientEvent('esx:showNotification', source, 'En cours..')
  Harvest2(source, item)
end)
RegisterServerEvent('esx_tabac:startTraitement')
AddEventHandler('esx_tabac:startTraitement', function()
  Transforming = true
  TriggerClientEvent('esx:showNotification', source, 'En cours..')
  Traitement(source)
end)
RegisterServerEvent('esx_tabac:startTraitement2')
AddEventHandler('esx_tabac:startTraitement2', function()
  Transforming = true
  TriggerClientEvent('esx:showNotification', source, 'En cours..')
  Traitement2(source)
end)
RegisterServerEvent('esx_tabac:startSell')
AddEventHandler('esx_tabac:startSell', function()
  Selling = true
  TriggerClientEvent('esx:showNotification', source, 'En cours..')
  SellAlcool(source)
end)


RegisterServerEvent('esx_tabac:getStockItem')
AddEventHandler('esx_tabac:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tabac', function(inventory)

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

ESX.RegisterServerCallback('esx_tabac:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tabac', function(inventory)
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

RegisterServerEvent('esx_tabac:putStockItems')
AddEventHandler('esx_tabac:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tabac', function(inventory)
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


RegisterServerEvent('esx_tabac:getFridgeStockItem')
AddEventHandler('esx_tabac:getFridgeStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tabac_fridge', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, Ftext_esx_tabac('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, Ftext_esx_tabac('you_removed') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_tabac:getFridgeStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tabac_fridge', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_tabac:putFridgeStockItems')
AddEventHandler('esx_tabac:putFridgeStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tabac_fridge', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, Ftext_esx_tabac('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, Ftext_esx_tabac('you_added') .. count .. ' ' .. item.label)

  end)

end)


RegisterServerEvent('esx_tabac:buyItem')
AddEventHandler('esx_tabac:buyItem', function(itemName, price, itemLabel)

    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local limit = xPlayer.getInventoryItem(itemName).limit
    local qtty = xPlayer.getInventoryItem(itemName).count
    local societyAccount = nil

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_tabac', function(account)
        societyAccount = account
      end)
    
    if societyAccount ~= nil and societyAccount.money >= price then
        if qtty < limit then
            societyAccount.removeMoney(price)
            xPlayer.addInventoryItem(itemName, 1)
            TriggerClientEvent('esx:showNotification', _source, Ftext_esx_tabac('bought') .. itemLabel)
        else
            TriggerClientEvent('esx:showNotification', _source, Ftext_esx_tabac('max_item'))
        end
    else
        TriggerClientEvent('esx:showNotification', _source, 'L\'entreprise na pas assez d\'argent')
    end

end)

ESX.RegisterServerCallback('esx_tabac:getVaultWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_tabac', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_tabac:addVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_tabac', function(store)

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

ESX.RegisterServerCallback('esx_tabac:removeVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_tabac', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
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

ESX.RegisterServerCallback('esx_tabac:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)

RegisterServerEvent('tabac:giveWeapon')
AddEventHandler('tabac:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

function moneychecker(money, need)
	if money <= need then
		return true
	else
		return false
	end

end

RegisterServerEvent('tabac:ChangeJob')
AddEventHandler('tabac:ChangeJob', function(id, job, grade)
	local xPlayer = ESX.GetPlayerFromId(tonumber(id))
	xPlayer.setJob(job, grade)
	
	TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez un nouveau job !')
	
	TriggerClientEvent('esx:setJob', job)
end)

RegisterServerEvent('tabac:ChangeJob2')
AddEventHandler('tabac:ChangeJob2', function(id, job, grade)
	local xPlayer = ESX.GetPlayerFromId(tonumber(id))
	xPlayer.setJob2(job, grade)
	
	TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez un nouveau job !')
	
	TriggerClientEvent('esx:setJob2', job)
end)

RegisterServerEvent('tabac:putmoney')
AddEventHandler('tabac:putmoney', function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local need = xPlayer.getMoney()

	if moneychecker(tonumber(money), tonumber(need)) == true then
		xPlayer.removeMoney(tonumber(money))
		
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_tabac', function(account)
			account.addMoney(tonumber(money))
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposer $" .. tonumber(money) .. " en propre")
		end)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas l\'argent')
	end
	CancelEvent()
end)

RegisterServerEvent('tabac:getmoney')
AddEventHandler('tabac:getmoney', function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_tabac', function(account)
	
		local need = account.money
	
		if moneychecker(tonumber(money), tonumber(need)) == true then
			account.removeMoney(tonumber(money))
			
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_tabac', function(account)
				xPlayer.addMoney(tonumber(money))
			end)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retirer $" .. tonumber(money) .. " en propre")
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Il n\'y a pas assez d\'argent')
		end
	end)

end)

RegisterServerEvent('tabac:putblackmoney')
AddEventHandler('tabac:putblackmoney', function(_money, _blackmoney)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = _money
	local blackmoney = _blackmoney
	
	local need = xPlayer.getBlackMoney()
	
	if moneychecker(tonumber(money), tonumber(need)) == true then

		local final = (tonumber(blackmoney) + tonumber(money))
	
		MySQL.update('UPDATE addon_account_data SET black_money = @black_money WHERE account_name = @account_name',
		{
			['@account_name'] = "society_tabac",
			['@black_money']   = tonumber(final)
		})
		
		xPlayer.removeAccountMoney('black_money', tonumber(money))
		
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposer $" .. tonumber(money) .. " en sale")
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas l\'argent')
	end
end)

RegisterServerEvent('tabac:getblackmoney')
AddEventHandler('tabac:getblackmoney', function(_money, _blackmoney)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = _money
	local blackmoney = _blackmoney
	
	if moneychecker(tonumber(money), tonumber(blackmoney)) == true then
	
	local final = (tonumber(blackmoney) - tonumber(money))

		MySQL.update('UPDATE addon_account_data SET black_money = @black_money WHERE account_name = @account_name',
		{
			['@account_name'] = "society_tabac",
			['@black_money']   = tonumber(final)
		})
		
		xPlayer.addAccountMoney('black_money', tonumber(money))
		
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retirer $" .. tonumber(money) .. " en sale")
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Il n\'y a pas assez d\'argent')
	end


end)

RegisterServerEvent('tabac:confiscatePlayerItem')
AddEventHandler('tabac:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label

    targetXPlayer.removeInventoryItem(itemName, amount)
    sourceXPlayer.addInventoryItem(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, Ftext_esx_tabac('you_have_confinv') .. amount .. ' ' .. label .. Ftext_esx_tabac('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. Ftext_esx_tabac('confinv') .. amount .. ' ' .. label )

  end

  if itemType == 'item_account' then

    targetXPlayer.removeAccountMoney(itemName, amount)
    sourceXPlayer.addAccountMoney(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, Ftext_esx_tabac('you_have_confdm') .. amount .. Ftext_esx_tabac('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. Ftext_esx_tabac('confdm') .. amount)

  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, Ftext_esx_tabac('you_have_confweapon') .. ESX.GetWeaponLabel(itemName) .. Ftext_esx_tabac('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. Ftext_esx_tabac('confweapon') .. ESX.GetWeaponLabel(itemName))

  end

end)

RegisterServerEvent('tabac:handcuff')
AddEventHandler('tabac:handcuff', function(target)
  TriggerClientEvent('tabac:handcuff', target)
end)

RegisterServerEvent('tabac:drag')
AddEventHandler('tabac:drag', function(target)
  local _source = source
  TriggerClientEvent('tabac:drag', target, _source)
end)

RegisterServerEvent('tabac:putInVehicle')
AddEventHandler('tabac:putInVehicle', function(target)
  TriggerClientEvent('tabac:putInVehicle', target)
end)

RegisterServerEvent('tabac:OutVehicle')
AddEventHandler('esx_cammujob:OutVehicle', function(target)
    TriggerClientEvent('tabac:OutVehicle', target)
end)

RegisterServerEvent('tabac:getStockItem')
AddEventHandler('tabac:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tabac', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, Ftext_esx_tabac('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, Ftext_esx_tabac('have_withdrawn') .. count .. ' ' .. item.label)

  end)

end)

RegisterServerEvent('tabac:putStockItems')
AddEventHandler('tabac:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tabac', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
	  TriggerClientEvent('esx:showNotification', xPlayer.source, Ftext_esx_tabac('added') .. count .. ' ' .. item.label)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, Ftext_esx_tabac('quantity_invalid'))
    end
  end)

end)

ESX.RegisterServerCallback('tabac:getOtherPlayerData', function(source, cb, target)

  if Config_esx_tabac.EnableESXIdentity then

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

    TriggerEvent('esx_status:getStatus', source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

    if Config_esx_tabac.EnableLicenses then

      TriggerEvent('esx_license:getLicenses', source, function(licenses)
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

ESX.RegisterServerCallback('tabac:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_tabac', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('tabac:getFineList', function(source, cb, category)

  MySQL.query(
    'SELECT * FROM fine_types_ammu WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

ESX.RegisterServerCallback('tabac:getVehicleInfos', function(source, cb, plate)

  if Config_esx_tabac.EnableESXIdentity then

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
            'SELECT * FROM users WHERE identifier = @identifier',
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
            'SELECT * FROM users WHERE identifier = @identifier',
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

ESX.RegisterServerCallback('tabac:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_tabac', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('tabac:addArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_tabac', function(store)

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

ESX.RegisterServerCallback('tabac:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_tabac', function(store)

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


ESX.RegisterServerCallback('tabac:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tabac', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('tabac:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)

TriggerEvent('es:addCommand', 'playauto', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'gitan') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'gitan') then
    TriggerClientEvent("esx_tabac:playmusic", -1, args[1])
    music = args[1]
	end	
end)

TriggerEvent('es:addCommand', 'pauseauto', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'gitan') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'gitan') then
		if pause then
			TriggerClientEvent("esx_tabac:pauseauto", -1, "play")
			pause = false
		else
			TriggerClientEvent("esx_tabac:pauseauto", -1, "pause")
			pause = true
		end
	end	
end)

TriggerEvent('es:addCommand', 'volumeauto', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'gitan') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'gitan') then
		print(args[1])
		TriggerClientEvent("esx_tabac:volumeauto", -1, args[1])
	end	
end)

TriggerEvent('es:addCommand', 'stopauto', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'gitan') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'gitan') then
		TriggerClientEvent("esx_tabac:stopauto", -1)
	end	
end)