ESX = nil

function Ftext_esx_taxijob(txt)
	return Config_esx_taxijob.Txt[txt]
end

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config_esx_taxijob.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'taxi', Config_esx_taxijob.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'private'})

RegisterServerEvent('esx_taxijob:success')
AddEventHandler('esx_taxijob:success', function(pricemultiplier)

  math.randomseed(os.time())

  local xPlayer        = ESX.GetPlayerFromId(source)
  local societyAccount = nil

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
    societyAccount = account
  end)

  if societyAccount ~= nil then
    if pricemultiplier then
      total = total * 2
    end

    local playerMoney  = Config_esx_taxijob.NPCJobEarningsPlayer
    local societyMoney = Config_esx_taxijob.NPCJobEarningsEntreprise

    if not Config_esx_taxijob.interimJobConfiguration.isEnable then      
      xPlayer.addMoney(playerMoney)
      societyAccount.addMoney(societyMoney)
  
      -- Update number of run
      exports.Nebula_farmlimitation:UpdateUserAndRunValue(xPlayer.getIdentifier(), 1, 'taxiJob')
      
      TriggerClientEvent('Core:ShowAdvancedNotification', xPlayer.source, "DOWNTOWN CAB CO", "Course", "Vous avez gagné ~g~$"..playerMoney.." ~w~. Votre société a gagné ~g~$"..societyMoney, 'CHAR_TAXI', 140)
    else     
      societyAccount.addMoney(societyMoney)
      -- Update number of run
      exports.Nebula_farmlimitation:UpdateUserAndRunValue(xPlayer.getIdentifier(), 1, 'taxiJob')
      TriggerClientEvent('esx_taxijob:updateInterimMissionAccount', xPlayer.source, Config_esx_taxijob.NPCJobEarningsPlayer)
      if xPlayer.job2 ~= nil and xPlayer.job2.name ~= 'unemployed2' then
        playerMoney = math.floor(playerMoney * (1/3))
      end
      TriggerClientEvent('Core:ShowAdvancedNotification', xPlayer.source, "DOWNTOWN CAB CO", "Course", "Vous avez gagné ~g~$"..playerMoney.." ~w~. Ramène le taxi au dépôt pour toucher ton argent.", 'CHAR_TAXI', 140)
    end
    
  else
    if not Config_esx_taxijob.interimJobConfiguration.isEnable then
      xPlayer.addMoney(total)    
      -- Update number of run
      exports.Nebula_farmlimitation:UpdateUserAndRunValue(xPlayer.getIdentifier(), 1, 'taxiJob')
      
      TriggerClientEvent('Core:ShowAdvancedNotification', xPlayer.source, "DOWNTOWN CAB CO", "Course", "Vous avez gagné ~g~$"..total, 'CHAR_TAXI', 140)
    else
      -- Update number of run
      exports.Nebula_farmlimitation:UpdateUserAndRunValue(xPlayer.getIdentifier(), 1, 'taxiJob')
      TriggerClientEvent('esx_taxijob:updateInterimMissionAccount', xPlayer.source, Config_esx_taxijob.NPCJobEarningsPlayer)
      TriggerClientEvent('Core:ShowAdvancedNotification', xPlayer.source, "DOWNTOWN CAB CO", "Course", "Vous avez gagné ~g~$"..playerMoney.." ~w~. Ramène le taxi pour toucher ton argent.", 'CHAR_TAXI', 140)
    end
  end
end)

RegisterServerEvent('esx_taxijob:getStockItem')
AddEventHandler('esx_taxijob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)

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

ESX.RegisterServerCallback('esx_taxijob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
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

RegisterServerEvent('esx_taxijob:putStockItems')
AddEventHandler('esx_taxijob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
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

ESX.RegisterServerCallback('esx_taxijob:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)

RegisterServerEvent('esx_taxijob:checkForLimitation')
AddEventHandler('esx_taxijob:checkForLimitation', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  local checkLimitation = exports.Nebula_farmlimitation:UserReachFarmLimitation(xPlayer.getIdentifier(), 1, 'taxiJob')
  TriggerClientEvent("esx_taxijob:responseCheckForLimitation", source, checkLimitation)
end)

-- INTERIM Taxi taxiJob

ESX.RegisterServerCallback('esx_taxijob:setInterimJob', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.job ~= nil and xPlayer.job.name == 'unemployed' then
    xPlayer.setJob('taxi', 0)
    xPlayer.setService('taxi', 1)
    TriggerEvent('CoreLog:SendDiscordLog', "Taxi - Set / Unset Job", "**" .. xPlayer.name .. "** a été set job dans la société de taxi en interim.", "Green")
    cb(true)
  else
    cb(false)
  end
end)

ESX.RegisterServerCallback('esx_taxijob:unsetInterimJob', function(source, cb, amountToPay, numberFacture, numberMission, factureMultiplicator)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.job ~= nil and xPlayer.job.name == 'taxi' then
    xPlayer.setJob('unemployed', 0)
    xPlayer.setService('unemployed', 1)
    TriggerEvent('CoreLog:SendDiscordLog', "Taxi - Set / Unset Job", "**" .. xPlayer.name .. "** a été unset job de la société de taxi en interim.", "Red")
    if amountToPay ~= nil and amountToPay > 0 then
      xPlayer.addMoney(amountToPay)
      TriggerEvent('CoreLog:SendDiscordLog', "Taxi - Paiement", "**" .. xPlayer.name .. "** a été payé `".. amountToPay .. "$` par la société d'interim.\nDétails : \n- Nombre de facture : `".. numberFacture .. "`\n- Nombre de mission : `" .. numberMission .."`\n - Multiplicateur de montant : `" .. factureMultiplicator .. "`", "Green")
    else
      TriggerEvent('CoreLog:SendDiscordLog', "Taxi - Paiement", "**" .. xPlayer.name .. "** n'a pas été payé par la société d'interim.\nDétails : \n- Nombre de facture : `".. numberFacture .. "`\n- Nombre de mission : `" .. numberMission .."`\n - Multiplicateur de montant : `" .. factureMultiplicator .. "`", "Orange")
    end
    cb(true)
  else
    cb(false)
  end
end)


ESX.RegisterServerCallback('esx_taxijob:allInterimBillArePay', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)

  local result = MySQL.query.await('SELECT * FROM billing WHERE sender = @identifier and target = @target',
		{
			['@identifier'] = xPlayer.identifier,
			['@target'] = 'society_taxi'
		}
  )
  cb(#result or 0)
end)