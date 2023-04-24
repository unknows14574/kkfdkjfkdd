ESX = nil

local EMSConnected = 0

function Ftext_esx_ambulancejob(txt)
	return Config_esx_ambulancejob.Txt[txt]
end

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountEMS()
  TriggerEvent('esx_jobcounter:returnTableMetierServer', function(JobConnected, JobConnected2) 
		EMSConnected = JobConnected + JobConnected2
	end, "numberLineTab", "ambulance", "ambulance2")
	if EMSConnected >= 1 then
		return true
	else 
		return false
  end
	--SetTimeout(100000, CountEMS)
end

--IsZeus -- ADMIN
local isZeus = {}
RegisterServerEvent('Admin:IsZeus')
AddEventHandler('Admin:IsZeus', function(Zeus)
  if Zeus then
    isZeus[source] = Zeus
  else
    isZeus[source] = nil
  end
end)

local function PiwelZeus(source)
  if IsPlayerAceAllowed(source, "command") then
    return true
  else
    for k,v in pairs(isZeus) do
      if k == source and v then
        return true
      end
    end
    return false
  end
end

--CountEMS()

RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(source, target, IsAdmin)
  if IsAdmin then
    TriggerEvent('CoreLog:SendDiscordLog', 'Réanimation', GetPlayerName(source) .. " a **réanimer** "..  GetPlayerName((target and tonumber(target) or source)), 'Grey', (target and tonumber(target) or nil), source)
  end
  TriggerClientEvent('esx_ambulancejob:revive', target)
end)

RegisterServerEvent('esx_ambulancejob:revive2')
AddEventHandler('esx_ambulancejob:revive2', function(target)
  TriggerClientEvent('esx_ambulancejob:revive', target)
end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
  TriggerClientEvent('esx_ambulancejob:heal', target, type)
end)

RegisterServerEvent('EMS_Ask:GetAnswer')
AddEventHandler('EMS_Ask:GetAnswer', function(question, target)
  local returnID = source
  TriggerClientEvent('EMS_Ask:Answer', target, question, returnID)
end)

RegisterServerEvent('EMS_Ask:SendAnswer')
AddEventHandler('EMS_Ask:SendAnswer', function(msg, target)
  TriggerClientEvent('Core:ShowNotification', target, "~y~Etat/réponse ~w~du ~y~patient: ~b~".. msg ..".")
end)

TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)

  if Config_esx_ambulancejob.RemoveCashAfterRPDeath then

    if xPlayer.getMoney() > 0 then
      xPlayer.removeMoney(xPlayer.getMoney())
    end

    if xPlayer.getBlackMoney() > 0 then
      xPlayer.setAccountMoney('black_money', 0)
    end

  end

  if Config_esx_ambulancejob.RemoveItemsAfterRPDeath then
    for i=1, #xPlayer.inventory, 1 do
      if xPlayer.inventory[i].count > 0 then
        xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
      end
    end
  end

  if Config_esx_ambulancejob.RemoveWeaponsAfterRPDeath then
    for i=1, #xPlayer.loadout, 1 do
      xPlayer.removeWeapon(xPlayer.loadout[i].name)
    end
  end

  if Config_esx_ambulancejob.RespawnFine then
    xPlayer.removeAccountMoney('bank', Config_esx_ambulancejob.RespawnFineAmount)
  end
  
	MySQL.update(
		'UPDATE users SET isalife = @isalife WHERE identifier = @identifier',
		{
		  ['@isalife']        = 1,
		  ['@identifier']   = xPlayer.identifier,
		}
	 )


  cb()

end)

RegisterServerEvent('esx_ambulancejob:isalife')
AddEventHandler('esx_ambulancejob:isalife', function(isalifeornot)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		MySQL.update(
		'UPDATE users SET isalife = @isalife WHERE identifier = @identifier',
		{
		  ['@isalife']      = isalifeornot,
		  ['@identifier']   = xPlayer.identifier,
		}
	  )
	end
end)

--[[AddEventHandler('es:playerLoaded', function(source) 
	local xPlayer = GetPlayerIdentifiers(source)[1]
	MySQL.query(
	'select * from users WHERE identifier = @identifier',
	{
	  ['@identifier']   = xPlayer,
	}, 
	function (result)
		if(result[1].isalife ~= 1) then
			print(xPlayer.." es mort")
			TriggerClientEvent('esx_ambulancejob:killped', source)
		else
		end
	end)
end)]]

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
  local xPlayer = ESX.GetPlayerFromId(source)
  local qtty = xPlayer.getInventoryItem(item).count
  cb(qtty)
end)

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  xPlayer.removeInventoryItem(item, 1)
  if item == 'bandage' then
    TriggerClientEvent('esx:showNotification', _source, Ftext_esx_ambulancejob('used_bandage'))
  elseif item == 'medikit' then
    TriggerClientEvent('esx:showNotification', _source, Ftext_esx_ambulancejob('used_medikit'))
  elseif item == 'défibrillateur' then
    TriggerClientEvent('esx:showNotification', _source, Ftext_esx_ambulancejob('used_defib'))
  end
end)

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(item)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local limit = xPlayer.getInventoryItem(item).limit
  local delta = 1
  local qtty = xPlayer.getInventoryItem(item).count
  if limit ~= -1 then
    delta = limit - qtty
  end
  if qtty < limit then
    if delta <= 10 then
      xPlayer.addInventoryItem(item, delta)
    else
      xPlayer.addInventoryItem(item, 10)
    end
  else
  TriggerClientEvent('esx:showNotification', _source, Ftext_esx_ambulancejob('max_item'))
  end
end)


RegisterServerEvent('esx_ambulancejob:success')
AddEventHandler('esx_ambulancejob:success', function()
  math.randomseed(os.time())

  local xPlayer        = ESX.GetPlayerFromId(source)
  local societyAccount = nil

  -- if xPlayer.job.grade >= 3 then
    -- total = total * 2
  -- end

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
    societyAccount = account    
  end)
  if societyAccount ~= nil then

    local playerMoney  = Config_esx_ambulancejob.NPCJobEarningsPlayer
    local societyMoney = Config_esx_ambulancejob.NPCJobEarningsEntreprise

    xPlayer.addMoney(playerMoney)
    societyAccount.addMoney(societyMoney)

    -- Update number of items get in job
    exports.Nebula_farmlimitation:UpdateUserAndRunValue(xPlayer.getIdentifier(), 1, 'emsJob')

    TriggerClientEvent('Core:ShowNotification', xPlayer.source, Ftext_esx_ambulancejob('have_earned') .. playerMoney)
    TriggerClientEvent('Core:ShowNotification', xPlayer.source, Ftext_esx_ambulancejob('comp_earned') .. societyMoney)

  else
    xPlayer.addMoney(Config_esx_ambulancejob.NPCJobEarningsEntreprise)
    TriggerClientEvent('esx:showNotification', xPlayer.source, Ftext_esx_ambulancejob('have_earned') .. Config_esx_ambulancejob.NPCJobEarningsEntreprise)
  end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getFineList', function(source, cb, category)

  MySQL.query(
    'SELECT * FROM fine_types_ambulance WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )
end)

ESX.RegisterCommand('revive', "admin", function(xPlayer, args, showError)
	if PiwelZeus(xPlayer.source) then
    if args.playerId ~= nil then
      TriggerClientEvent('esx_ambulancejob:revive', args.playerId)
      TriggerEvent('CoreLog:SendDiscordLog', 'Réanimation', GetPlayerName(xPlayer.source) .. " a **réanimé** ".. GetPlayerName(args.playerId), 'Grey', xPlayer.source, args.playerId)
    else
      TriggerClientEvent('esx_ambulancejob:revive', xPlayer.source)
      TriggerEvent('CoreLog:SendDiscordLog', 'Réanimation', GetPlayerName(xPlayer.source) .. " s'est réanimer.", 'Grey', false, xPlayer.source)
    end
  end
end, true, {help = 'Revive la personne', validate = false, arguments = {
  {help = 'Id du joueur (vide si pour sois)', name ='playerId', type = 'any'}
}})

ESX.RegisterUsableItem('medikit', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  
  if CountEMS() then
	  TriggerClientEvent('esx:showNotification', source, "~r~" .. EMSConnected .. "/1 ~g~Ambulancier" .. " ~b~est en ville !")
	return
  end
  
  xPlayer.removeInventoryItem('medikit', 1)
  TriggerClientEvent('esx_ambulancejob:heal', source, 'harybo')
  TriggerClientEvent('esx:showNotification', source, Ftext_esx_ambulancejob('used_medikit'))
end)

ESX.RegisterUsableItem('bandage', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)

  if CountEMS() then
	  TriggerClientEvent('esx:showNotification', source, "~r~" .. EMSConnected .. "/1 ~g~Ambulancier" .. " ~b~est en ville !")
	return
  end

  xPlayer.removeInventoryItem('bandage', 1)
  TriggerClientEvent('esx_ambulancejob:heal', source, 'small')
  TriggerClientEvent('esx:showNotification', source, Ftext_esx_ambulancejob('used_bandage'))
end)

ESX.RegisterUsableItem('harybo_super_medikit', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerClientEvent('esx_ambulancejob:heal', source, 'harybo')
  TriggerClientEvent('esx:showNotification', source, Ftext_esx_ambulancejob('used_bandage'))
end)

ESX.RegisterUsableItem('harybo_medikit', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('harybo_medikit', 1)
  TriggerClientEvent('esx_ambulancejob:heal', source, 'harybo')
  TriggerClientEvent('esx:showNotification', source, Ftext_esx_ambulancejob('used_bandage'))
end)

ESX.RegisterUsableItem('pills', function(source)
  local xPlayer  = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('pills', 1)
  TriggerClientEvent('shakeCam', source, false)
  TriggerClientEvent('esx:showNotification', source, Ftext_esx_ambulancejob('used_pills'))
end)

ESX.RegisterUsableItem('medicaments', function(source)
  local xPlayer  = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('medicaments', 1)
  TriggerClientEvent('esx:showNotification', source, "Vous avez pris des médicaments")
end)

-- AJOUT DEFIBRILLATEUR ITEM DELDU
ESX.RegisterUsableItem('defibrillateur', function(source)
    TriggerClientEvent('esx_ambulancejob:defibrevive', source)
end)

RegisterServerEvent('esx_ambulancejob:getStockItem')
AddEventHandler('esx_ambulancejob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)

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

ESX.RegisterUsableItem('defib', function(source)

	if CountEMS() then
		TriggerClientEvent('esx:showNotification', source, "~r~" .. EMSConnected .. "/1 ~g~Ambulancier" .. " ~b~est en ville !")
		return
	end

    TriggerClientEvent('esx_ambulancejob:defibrevive', source)
end)

--[[ESX.RegisterUsableItem('defib', function(source)

	if CountEMS() then
		TriggerClientEvent('esx:showNotification', source, "~r~" .. EMSConnected .. "/1 ~g~Ambulancier" .. " ~b~est en ville !")
		return
	end

  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(source)

  xPlayer.removeInventoryItem('defib', 1)

  TriggerClientEvent('esx_ambulancejob:onDefib', _source)
   TriggerClientEvent('esx:showNotification', _source, Ftext_esx_ambulancejob('used_defib'))

end)]]

ESX.RegisterServerCallback('esx_ambulancejob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)
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

RegisterServerEvent('esx_ambulancejob:putStockItems')
AddEventHandler('esx_ambulancejob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)
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

ESX.RegisterServerCallback('esx_ambulancejob:getVaultWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_ambulance', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_ambulancejob:addVaultWeapon', function(source, cb, weaponName, weaponLabel)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_ambulance', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i] ~= nil then 
        if weapons[i].name == weaponName then
          xPlayer.removeWeapon(weaponName)
          weapons[i].count = weapons[i].count + 1
          TriggerClientEvent('Core:ShowNotification', source, "Tu as déposé ~y~"..weaponLabel.."~w~.")
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

ESX.RegisterServerCallback('esx_ambulancejob:removeVaultWeapon', function(source, cb, weaponName, weaponLabel)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_ambulance', function(store)

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
          TriggerClientEvent('Core:ShowNotification', source, "Tu as retiré ~y~"..weaponLabel.."~w~.")
        elseif weapons[i].count <= 0 then
          table.remove(weapons, i)
          TriggerClientEvent('Core:ShowNotification', source, "L'arme n'est plus présente dans le coffre.")
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

ESX.RegisterServerCallback('esx_ambulancejob:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)

RegisterServerEvent('esx_ambulancejob:checkForLimitation')
AddEventHandler('esx_ambulancejob:checkForLimitation', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  local checkLimitation = exports.Nebula_farmlimitation:UserReachFarmLimitation(xPlayer.getIdentifier(), 1, 'emsJob')
  TriggerClientEvent("esx_ambulancejob:responseCheckForLimitation", source, checkLimitation)
end)