ESX                = nil

function Ftext_esxFtext_esx_unicornnicorn(txt)
	return Config_esxFtext_esx_unicornnicorn.Txt[txt]
end

local PlayersHarvesting  = {}
local Harvesting = false
local Transforming = false
local Selling = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addCommand', 'playunicorn', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'event') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'event') then
    TriggerClientEvent("esx_unicorn:playmusic", -1, args[1])
    music = args[1]
	end	
end)

TriggerEvent('es:addCommand', 'pauseunicorn', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'event') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'event') then
		print(pause)
		if pause then
			TriggerClientEvent("esx_unicorn:pauseunicorn", -1, "play")
			pause = false
		else
			TriggerClientEvent("esx_unicorn:pauseunicorn", -1, "pause")
			pause = true
		end
	end	
end)

TriggerEvent('es:addCommand', 'volumeunicorn', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'event') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'event') then
		print(args[1])
		TriggerClientEvent("esx_unicorn:volumeunicorn", -1, args[1])
	end	
end)

TriggerEvent('es:addCommand', 'stopunicorn', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'event') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'event') then
		TriggerClientEvent("esx_unicorn:stopunicorn", -1)
	end	
end)

if Config_esxFtext_esx_unicornnicorn.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'event', Config_esxFtext_esx_unicornnicorn.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'event', 'event', 'society_event', 'society_event', 'society_event', {type = 'private'})


RegisterServerEvent('esx_evenementiel:stopHarvest')
AddEventHandler('esx_evenementiel:stopHarvest', function()
  Harvesting = false
end)
RegisterServerEvent('esx_evenementiel:stopTraitement')
AddEventHandler('esx_evenementiel:stopTraitement', function()
  Transforming = false
end)
RegisterServerEvent('esx_evenementiel:stopSell')
AddEventHandler('esx_evenementiel:stopSell', function()
  Selling = false
end)

local temp = false
local tempZ = 3000
RegisterServerEvent('esx_evenementiel:drugsOn')
AddEventHandler('esx_evenementiel:drugsOn', function()
    temp = true
end)
RegisterServerEvent('esx_evenementiel:drugsOff')
AddEventHandler('esx_evenementiel:drugsOff', function()
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

function rDBText()
    local num = math.random(0,3)
    --if num == 0 then return "ruinart"
    if num == 0 then return "bvodka"
    elseif num == 1 then return "bwhisky"
    elseif num == 2 then return "brhum"
    elseif num == 3 then return "btequila"
    --elseif num == 5 then return "champagne"
    --elseif num == 6 then return "vrose"
    end
end

--[[ESX.RegisterUsableItem('balcool', function(source)

    local xPlayer = ESX.GetPlayerFromId(source)
    
	xPlayer.addInventoryItem(rDBText(), 5)
	xPlayer.removeInventoryItem('balcool', 1)
	
	TriggerClientEvent('esx:showNotification', source, "Vous avez ouvert un carton d'alcool")
end)]]

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

RegisterServerEvent('esx_evenementiel:startHarvest', item)
AddEventHandler('esx_evenementiel:startHarvest', function(item)
  Harvesting = true
  TriggerClientEvent('esx:showNotification', source, 'En cours..')
  Harvest(source, item)
end)
RegisterServerEvent('esx_evenementiel:startHarvest2', item)
AddEventHandler('esx_evenementiel:startHarvest2', function(item)
  Harvesting = true
  TriggerClientEvent('esx:showNotification', source, 'En cours..')
  Harvest2(source, item)
end)
RegisterServerEvent('esx_evenementiel:startTraitement')
AddEventHandler('esx_evenementiel:startTraitement', function()
  Transforming = true
  TriggerClientEvent('esx:showNotification', source, 'En cours..')
  Traitement(source)
end)
RegisterServerEvent('esx_evenementiel:startTraitement2')
AddEventHandler('esx_evenementiel:startTraitement2', function()
  Transforming = true
  TriggerClientEvent('esx:showNotification', source, 'En cours..')
  Traitement2(source)
end)
RegisterServerEvent('esx_evenementiel:startSell')
AddEventHandler('esx_evenementiel:startSell', function()
  Selling = true
  TriggerClientEvent('esx:showNotification', source, 'En cours..')
  SellAlcool(source)
end)


RegisterServerEvent('esx_evenementiel:getStockItem')
AddEventHandler('esx_evenementiel:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_event', function(inventory)

    local item = inventory.getItem(itemName)

		TriggerEvent('esx_advanced_inventory:GetInventoryWeight', function(invTaille, itemTaille) 
			weight = 50000 - invTaille
			  if item.count >= count then
				local getTaille = itemTaille * count
				if getTaille <= weight then
				   inventory.removeItem(itemName, count)
				   xPlayer.addInventoryItem(itemName, count)
				   TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Vous avez retirer " .. count .. ' ' .. item.label, 'CHAR_DAVE', 1)
           TriggerEvent('CoreLog:SendDiscordLog', 'Unicorn - Coffre', "`[COFFRE]` "..GetPlayerName(xPlayer.source) .. " a retiré x"..count.."`[".. item.label .."]`", 'Red', false, xPlayer.source)
				elseif getTaille >= weight then
				  TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Tu n\'as pas assez de place dans tes poches...", 'CHAR_DAVE', 1)
				end
			  else
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Quantité invalide", 'CHAR_DAVE', 1)
			  end
		  end, source, itemName)

  end)

end)

ESX.RegisterServerCallback('esx_evenementiel:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_event', function(inventory)
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

RegisterServerEvent('esx_evenementiel:putStockItems')
AddEventHandler('esx_evenementiel:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_event', function(inventory)
			local item = inventory.getItem(itemName)
	
			if item.count >= 0 then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
        TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez ajouter ~y~x" .. count .. ' ~b~' .. item.label)
        TriggerEvent('CoreLog:SendDiscordLog', 'Unicorn - Coffre', "`[COFFRE]` "..GetPlayerName(xPlayer.source) .. " a déposé x"..count.."`[".. item.label .."]`", 'Green', false, xPlayer.source)
			else
				TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Quantité invalide. Veuillez ressayer.')
      end
		end)
	else
		TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Vous n\'avez pas cet objet sur vous.')
	end
end)


RegisterServerEvent('esx_evenementiel:getFridgeStockItem')
AddEventHandler('esx_evenementiel:getFridgeStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_event_fridge', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
      TriggerEvent('CoreLog:SendDiscordLog', 'Unicorn - Coffre', "`[FRIGO]` "..GetPlayerName(xPlayer.source) .. " a retiré x"..count.."`[".. item.label .."]`", 'Red', false, xPlayer.source)
      TriggerClientEvent('esx:showNotification', xPlayer.source, Ftext_esx_unicorn('you_removed') .. count .. ' ' .. item.label)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, Ftext_esx_unicorn('quantity_invalid'))
    end
  end)
end)

ESX.RegisterServerCallback('esx_evenementiel:getFridgeStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_event_fridge', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_evenementiel:putFridgeStockItems')
AddEventHandler('esx_evenementiel:putFridgeStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_event_fridge', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
      TriggerEvent('CoreLog:SendDiscordLog', 'Unicorn - Coffre', "`[FRIGO]` "..GetPlayerName(xPlayer.source) .. " a déposé x"..count.."`[".. item.label .."]`", 'Green', false, xPlayer.source)
      TriggerClientEvent('esx:showNotification', xPlayer.source, Ftext_esx_unicorn('you_added') .. count .. ' ' .. item.label)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, Ftext_esx_unicorn('invalid_quantity'))
    end
  end)

end)


RegisterServerEvent('esx_evenementiel:buyItem')
AddEventHandler('esx_evenementiel:buyItem', function(itemName, price, itemLabel)

    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local limit = xPlayer.getInventoryItem(itemName).limit
    local qtty = xPlayer.getInventoryItem(itemName).count
    --local societyAccount = nil

   -- TriggerEvent('esx_addonaccount:getSharedAccount', 'society_event', function(account)
        --societyAccount = account
    --end)
    
    --if societyAccount ~= nil and societyAccount.money >= price then
        if qtty < limit then
            --societyAccount.removeMoney(price)
            xPlayer.addInventoryItem(itemName, 1)
            --TriggerClientEvent('esx:showNotification', _source, Ftext_esx_unicorn('bought') .. itemLabel)
        else
            TriggerClientEvent('esx:showNotification', _source, Ftext_esx_unicorn('max_item'))
        end
    --else
        --TriggerClientEvent('esx:showNotification', _source, 'L\'entreprise na pas assez d\'argent')
    --end

end)

ESX.RegisterServerCallback('esx_evenementiel:getVaultWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_event', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_evenementiel:addVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_event', function(store)

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

ESX.RegisterServerCallback('esx_evenementiel:removeVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_event', function(store)

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

ESX.RegisterServerCallback('esx_evenementiel:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)
