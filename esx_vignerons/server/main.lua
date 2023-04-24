function Ftext_esx_vigneronstxt(txt)
	return Config_esx_vignerons.Txt[txt]
end

ESX = nil
local PlayersTransforming, PlayersSelling, PlayersHarvesting = {}, {}, {}
local vine, jus = 1, 1
xSound = exports.xsound
local pause = false
local music = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--------------------------Sound------------------------
TriggerEvent('es:addCommand', 'playvigne', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'vigne') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'vigne') then
    TriggerClientEvent("esx_vigneronjob:playmusic", -1, args[1])
    music = args[1]
	end	
end)

TriggerEvent('es:addCommand', 'pausevigne', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'vigne') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'vigne') then
		print(pause)
		if pause then
			TriggerClientEvent("esx_vigneronjob:pausevigne", -1, "play")
			pause = false
		else
			TriggerClientEvent("esx_vigneronjob:pausevigne", -1, "pause")
			pause = true
		end
	end	
end)

TriggerEvent('es:addCommand', 'volumevigne', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'vigne') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'vigne') then
		print(args[1])
		TriggerClientEvent("esx_vigneronjob:volumevigne", -1, args[1])
	end	
end)

TriggerEvent('es:addCommand', 'stopvigne', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'vigne') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'vigne') then
		TriggerClientEvent("esx_vigneronjob:stopvigne", -1)
	end	
end)
------------------------------------------------------
if Config_esx_vignerons.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'vigne', Config_esx_vignerons.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'vigne', 'Vigneron', 'society_vigne', 'society_vigne', 'society_vigne', {type = 'private'})

local timeZ = 1800
local drugsOn = false
RegisterServerEvent('esx_vigneronjob:drugsOn')
AddEventHandler('esx_vigneronjob:drugsOn', function()
	drugsOn = true
end)

local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "RaisinFarm" then
			local itemQuantity = xPlayer.getInventoryItem('rblanc').count
			if itemQuantity >= 50 then
				TriggerClientEvent('Core:ShowNotification', source, Ftext_esx_vignerons('not_enough_place')) 
				return
			else
				timeZ = 1800
				if drugsOn then timeZ = 1800/2
				else timeZ = 1800
				end
				SetTimeout(timeZ, function()
					xPlayer.addInventoryItem('rblanc', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end
local function Harvest1(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "RaisinFarm2" then
			local itemQuantity = xPlayer.getInventoryItem('rrouge').count
			if itemQuantity >= 50 then
				TriggerClientEvent('Core:ShowNotification', source, Ftext_esx_vignerons('not_enough_place'))
				return
			else
				timeZ = 1800
				if drugsOn then timeZ = 1800/2
				else timeZ = 1800
				end
				SetTimeout(timeZ, function()
					xPlayer.addInventoryItem('rrouge', 1)
					Harvest1(source, zone)
				end)
			end
		end
	end
end
local function Harvest2(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "GingembreFarm" then
			local itemQuantity = xPlayer.getInventoryItem('gingembre').count
			if itemQuantity >= 50 then
				TriggerClientEvent('Core:ShowNotification', source, Ftext_esx_vignerons('not_enough_place'))
				return
			else
				timeZ = 1800
				if drugsOn then timeZ = 1800/2
				else timeZ = 1800
				end
				SetTimeout(timeZ, function()
					xPlayer.addInventoryItem('gingembre', 1)
					Harvest2(source, zone)
				end)
			end
		end
	end
end
local function Harvest3(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "RaisinNormalFarm" then
			local itemQuantity = xPlayer.getInventoryItem('raisin').count
			if itemQuantity >= 50 then
				TriggerClientEvent('Core:ShowNotification', source, Ftext_esx_vignerons('not_enough_place'))
				return
			else
				timeZ = 1800
				if drugsOn then timeZ = 1800/2
				else timeZ = 1800
				end
				SetTimeout(timeZ, function()
					xPlayer.addInventoryItem('raisin', 1)
					Harvest3(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_vigneronjob:startHarvest')
AddEventHandler('esx_vigneronjob:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('Core:ShowNotification', _source, 'Vous ne pouvez pas faire cela actuellement.')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source] = true
		TriggerClientEvent('Core:ShowNotification', _source, Ftext_esx_vignerons('raisin_taken'))  
		Harvest(_source,zone)
	end
end)
RegisterServerEvent('esx_vigneronjob:startHarvest1')
AddEventHandler('esx_vigneronjob:startHarvest1', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('Core:ShowNotification', _source, 'Vous ne pouvez pas faire cela actuellement.')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('Core:ShowNotification', _source, Ftext_esx_vignerons('raisin_taken'))  
		Harvest1(_source,zone)
	end
end)
RegisterServerEvent('esx_vigneronjob:startHarvest2')
AddEventHandler('esx_vigneronjob:startHarvest2', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('Core:ShowNotification', _source, 'Vous ne pouvez pas faire cela actuellement.')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('Core:ShowNotification', _source, 'Vous être en train de ramasser du gingembre')  
		Harvest2(_source,zone)
	end
end)
RegisterServerEvent('esx_vigneronjob:startHarvest3')
AddEventHandler('esx_vigneronjob:startHarvest3', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('Core:ShowNotification', _source, 'Vous ne pouvez pas faire cela actuellement.')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('Core:ShowNotification', _source, 'Vous être en train de ramasser du raisin.')  
		Harvest3(_source,zone)
	end
end)

RegisterServerEvent('esx_vigneronjob:stopHarvest')
AddEventHandler('esx_vigneronjob:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('Core:ShowNotification', _source, 'Vous sortez de la ~r~zone')
	else
		TriggerClientEvent('Core:ShowNotification', _source, 'Vous pouvez ~g~récolter')
		PlayersHarvesting[_source]=true
	end
end)
RegisterServerEvent('esx_vigneronjob:stopHarvest2')
AddEventHandler('esx_vigneronjob:stopHarvest2', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('Core:ShowNotification', _source, 'Vous sortez de la ~r~zone')
	else
		TriggerClientEvent('Core:ShowNotification', _source, 'Vous pouvez ~g~récolter')
		PlayersHarvesting[_source]=true
	end
end)
RegisterServerEvent('esx_vigneronjob:stopHarvest3')
AddEventHandler('esx_vigneronjob:stopHarvest3', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('Core:ShowNotification', _source, 'Vous sortez de la ~r~zone')
	else
		TriggerClientEvent('Core:ShowNotification', _source, 'Vous pouvez ~g~récolter')
		PlayersHarvesting[_source]=true
	end
end)

local function Transform(source, zone)

	if PlayersTransforming[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "TraitementJus" then
			local itemQuantity = xPlayer.getInventoryItem('rais').count
			if itemQuantity <= 0 then
				TriggerClientEvent('Core:ShowNotification', source, Ftext_esx_vignerons('not_enough_raisin'))
				return
			else
				timeZ = 1800
				if drugsOn then timeZ = 1800/2
				else timeZ = 1800
				end
				SetTimeout(timeZ, function()
					xPlayer.removeInventoryItem('rais', 1)
					xPlayer.addInventoryItem('jrais', 1)

					PlayersTransforming[source] = nil
				end)
			end
		end
	end	
end

RegisterServerEvent('esx_vigneronjob:startTransform')
AddEventHandler('esx_vigneronjob:startTransform', function(zone)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		TriggerClientEvent('Core:ShowNotification', _source, 'Vous ne pouvez pas faire cela actuellement.')
		PlayersTransforming[_source] = false
	else
		PlayersTransforming[_source] = true
		TriggerClientEvent('Core:ShowNotification', _source, Ftext_esx_vignerons('transforming_in_progress')) 
		Transform(_source,zone)
	end
end)

local function gTransform(source, zone, item)

	local _source = source

	if PlayersTransforming[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "TraitementJus" then
			local itemQuantity = xPlayer.getInventoryItem(item).count
			local raisinQTE = xPlayer.getInventoryItem('raisin').count
			local gingQTE = xPlayer.getInventoryItem('gingembre').count
			local raisinRougeQTE = xPlayer.getInventoryItem('rrouge').count
			local raisinBlancQTE = xPlayer.getInventoryItem('rblanc').count

			
			if itemQuantity >= 50 then
				TriggerClientEvent('Core:ShowNotification', _source, (Ftext_esx_vignerons('not_enough_place')))
				return
			else
				timeZ = 5000
				if drugsOn then timeZ = 5000/2
				else timeZ = 5000
				end
				SetTimeout(timeZ, function()
					if item == "champagne" then
						if raisinQTE >= 5 then
							xPlayer.removeInventoryItem('raisin', 5)
							xPlayer.addInventoryItem(item, 1)
						else
							PlayersTransforming[_source] = nil
							TriggerClientEvent('Core:ShowNotification', _source, "Vous avez besoin de ~y~5 ~b~raisins ~w~!")
							return
						end
					elseif item == "brais" then
						if raisinQTE >= 2 then
							xPlayer.removeInventoryItem('raisin', 2)
							xPlayer.addInventoryItem(item, 1)
						else
							PlayersTransforming[_source] = nil
							TriggerClientEvent('Core:ShowNotification', _source, "Vous avez besoin de ~y~2 ~b~raisins ~w~!")
							return
						end
					elseif item == "ving" then
						if gingQTE >= 3 then
							xPlayer.removeInventoryItem('gingembre', 3)
							xPlayer.addInventoryItem(item, 1)
						else
							PlayersTransforming[_source] = nil
							TriggerClientEvent('Core:ShowNotification', _source, "Vous avez besoin de ~y~3 ~b~gingembre ~w~!")
							return
						end
					elseif item == "vrouge" then
						if raisinRougeQTE >= 3 then
							xPlayer.removeInventoryItem('rrouge', 3)
							xPlayer.addInventoryItem(item, 1)
						else
							PlayersTransforming[_source] = nil
							TriggerClientEvent('Core:ShowNotification', _source, "Vous avez besoin de ~y~3 ~b~raisins rouge ~w~!")
							return
						end
					elseif item == "vblanc" then
						if raisinBlancQTE >= 2 then
							xPlayer.removeInventoryItem('rblanc', 3)
							xPlayer.addInventoryItem(item, 1)
						else
							PlayersTransforming[_source] = nil
							TriggerClientEvent('Core:ShowNotification', _source, "Vous avez besoin de ~y~3 ~b~raisins blancs ~w~!")
							return
						end
					elseif item == "ruinart" then
						if raisinQTE >= 10 then
							xPlayer.removeInventoryItem('raisin', 10)
							xPlayer.addInventoryItem(item, 1)
						else
							PlayersTransforming[_source] = nil
							TriggerClientEvent('Core:ShowNotification', _source, "Vous avez besoin de ~y~10~b~ raisins ~w~!")
							return
						end
					end

					PlayersTransforming[_source] = nil
				end)
			end
			
		end
	end	
end
RegisterServerEvent('esx_vigneronjob:gTransform')
AddEventHandler('esx_vigneronjob:gTransform', function(zone, item)
	local _source = source

	if PlayersTransforming[_source] == false then
		TriggerClientEvent('Core:ShowNotification', _source, 'Vous ne pouvez pas faire cela actuellement.')
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
		TriggerClientEvent('Core:ShowNotification', _source, Ftext_esx_vignerons('transforming_in_progress')) 
		gTransform(_source,zone,item)
	end
end)

RegisterServerEvent('esx_vigneronjob:stopTransform')
AddEventHandler('esx_vigneronjob:stopTransform', function()
	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
	end
end)

RegisterServerEvent('esx_vigneronjob:getStockItem')
AddEventHandler('esx_vigneronjob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
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

ESX.RegisterServerCallback('esx_vigneronjob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
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

RegisterServerEvent('esx_vigneronjob:putStockItems')
AddEventHandler('esx_vigneronjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
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

ESX.RegisterServerCallback('esx_vigneronjob:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})
end)

ESX.RegisterUsableItem('brais', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('brais', 1)
	xPlayer.addInventoryItem('jrais', 5)
end)