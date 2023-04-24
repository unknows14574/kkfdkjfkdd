
ESX = nil
local PlayersTransforming, PlayersSelling, PlayersHarvesting = {}, {}, {}
local diner, jus = 1, 1

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx_fermier:pay')
AddEventHandler('esx_fermier:pay', function()

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  local pMoney  = Config_esx_dinerjob.NPCJobEarningsPlayer
  local eMoney = Config_esx_dinerjob.NPCJobEarningsEntreprise

  xPlayer.addMoney(pMoney)-- en 20-30min

	-- Update number of run
	exports.Nebula_farmlimitation:UpdateUserAndRunValue(xPlayer.getIdentifier(), 1, 'dinerJob')
	print("update send")

  
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_diner', function(account)
	account.addMoney(eMoney, "Run de effectué par "..GetPlayerName(source), 'deposit')
  end)

  TriggerClientEvent('Core:ShowNotification', _source, "Vous avez recu ~g~$" .. pMoney..".~w~ Votre ~y~entreprise~w~ a reçu ~b~$"..eMoney.."~w~.")
end)



TriggerEvent('es:addCommand', 'playdiner', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'diner') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'diner') then
    TriggerClientEvent("esx_dinerjob:playmusic", -1, args[1])
    music = args[1]
	end	
end)

TriggerEvent('es:addCommand', 'pausediner', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'diner') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'diner') then
		print(pause)
		if pause then
			TriggerClientEvent("esx_dinerjob:pausediner", -1, "play")
			pause = false
		else
			TriggerClientEvent("esx_dinerjob:pausediner", -1, "pause")
			pause = true
		end
	end	
end)

TriggerEvent('es:addCommand', 'volumediner', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'diner') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'diner') then
		print(args[1])
		TriggerClientEvent("esx_dinerjob:volumediner", -1, args[1])
	end	
end)

TriggerEvent('es:addCommand', 'stopdiner', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'diner') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'diner') then
		TriggerClientEvent("esx_dinerjob:stopdiner", -1)
	end	
end)

if Config_esx_dinerjob.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'diner', Config_esx_dinerjob.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'diner', 'Diner', 'society_diner', 'society_diner', 'society_diner', {type = 'private'})

local timeZ = 1800
local drugsOn = false
RegisterServerEvent('esx_dinerjob:drugsOn')
AddEventHandler('esx_dinerjob:drugsOn', function()
	drugsOn = true
end)

local function Harvest(source, zone, item)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)

		local itemQuantity = xPlayer.getInventoryItem(item).count
		if itemQuantity >= 50 then
			TriggerClientEvent('esx:showNotification', source, 'vous n\'avez plus de place.') 
			return
		else
			timeZ = 1800
			if drugsOn then 
				timeZ = 1800/2
			else 
				timeZ = 1800
			end
			SetTimeout(timeZ, function()
				xPlayer.addInventoryItem(item, 1)
				Harvest(source, zone, item)
			end)
		end
	end
end

RegisterServerEvent('esx_dinerjob:giveitem')
AddEventHandler('esx_dinerjob:giveitem', function(item)
	local _source = source
  	
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local itemQuantity = xPlayer.getInventoryItem(item).count
	if itemQuantity >= 50 then
		TriggerClientEvent('esx:showNotification', source, 'vous n\'avez plus de place.') 
		return
	else
		xPlayer.addInventoryItem(item, 1)
	end
end)

RegisterServerEvent('esx_dinerjob:startHarvest')
AddEventHandler('esx_dinerjob:startHarvest', function(zone, item)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, 'En cours..')  
		Harvest(_source, zone, item)
	end
end)

RegisterServerEvent('esx_dinerjob:stopHarvest')
AddEventHandler('esx_dinerjob:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~récolter')
		PlayersHarvesting[_source]=true
	end
end)

local function Transform(source, zone)

	if PlayersTransforming[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "TraitementJus" then
			local itemQuantity = xPlayer.getInventoryItem('rais').count
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de raisin')
				return
			else
				timeZ = 1800
				if drugsOn then timeZ = 1800/2
				else timeZ = 1800
				end
				SetTimeout(timeZ, function()
					xPlayer.removeInventoryItem('rais', 1)
					xPlayer.addInventoryItem('jrais', 1)
		  
					Transform(source, zone)	  
				end)
			end
		end
	end	
end

RegisterServerEvent('esx_dinerjob:startTransform')
AddEventHandler('esx_dinerjob:startTransform', function(zone)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
		TriggerClientEvent('esx:showNotification', _source, 'Transformation du raisin en cours') 
		Transform(_source,zone)
	end
end)

local function gTransform(source, item)

	local _source = source

	if Transforming then

		local xPlayer  = ESX.GetPlayerFromId(source)
		local itemQuantity = xPlayer.getInventoryItem(item).count
			
			local steakQTE = xPlayer.getInventoryItem('steak').count
			local baconQTE = xPlayer.getInventoryItem('bacon').count
			local breadQTE = xPlayer.getInventoryItem('bread').count
			local laitQTE = xPlayer.getInventoryItem('lait').count
			local fromagesQTE = xPlayer.getInventoryItem('fromages').count
			local pommesQTE = xPlayer.getInventoryItem('pommes').count
			local saladesQTE = xPlayer.getInventoryItem('salades').count
			local tomatesQTE = xPlayer.getInventoryItem('tomates').count
			local oeufsQTE = xPlayer.getInventoryItem('oeufs').count
			local bleQTE = xPlayer.getInventoryItem('ble').count
			local vacheQTE = xPlayer.getInventoryItem('vache').count
			local cochonQTE = xPlayer.getInventoryItem('cochon').count
			
			if itemQuantity >= 50 then
				TriggerClientEvent('esx:showNotification', _source, 'vous n\'avez pas assez de place')
				return
			else
				timeZ = 3000
				if drugsOn then timeZ =3000/2
				else timeZ = 3000
				end
				SetTimeout(timeZ, function()

					if item == "oplat" then
						if oeufsQTE >= 2 then
							xPlayer.removeInventoryItem('oeufs', 2)
							xPlayer.addInventoryItem(item, 1)
						else
							TriggerClientEvent('esx:showNotification', _source, "Vous avez besoin de x2 oeufs!")
							return
						end
					elseif item == "dburger" then
						if steakQTE >= 1 and baconQTE >= 1 and breadQTE >= 1 and fromagesQTE >= 1 and saladesQTE >= 1 and tomatesQTE >= 1 then
							xPlayer.removeInventoryItem('steak', 1)
							xPlayer.removeInventoryItem('bacon', 1)
							xPlayer.removeInventoryItem('bread', 1)
							xPlayer.removeInventoryItem('fromages', 1)
							xPlayer.removeInventoryItem('salades', 1)
							xPlayer.removeInventoryItem('tomates', 1)
							xPlayer.addInventoryItem(item, 1)
						else
							TriggerClientEvent('esx:showNotification', _source, "Vous avez besoin de:")
							TriggerClientEvent('esx:showNotification', _source, "1 steak, 1 bacon, 1 fromage, 1 salades et 1 tomates.")
							return
						end
					elseif item == "steak" then
						if vacheQTE >= 1 then
							xPlayer.removeInventoryItem('vache', 1)
							xPlayer.addInventoryItem(item, 10)
						else
							TriggerClientEvent('esx:showNotification', _source, "Vous avez besoin de x1 vache!")
							return
						end
					elseif item == "bacon" then
						if cochonQTE >= 1 then
							xPlayer.removeInventoryItem('cochon', 1)
							xPlayer.addInventoryItem(item, 10)
						else
							TriggerClientEvent('esx:showNotification', _source, "Vous avez besoin de x1 cochon!")
							return
						end
					elseif item == "bread" then
						if bleQTE >= 5 then
							xPlayer.removeInventoryItem('ble', 5)
							xPlayer.addInventoryItem(item, 1)
						else
							TriggerClientEvent('esx:showNotification', _source, "Vous avez besoin de x5 blé!")
							return
						end
					elseif item == "btlait" then
						if laitQTE >= 5 then
							xPlayer.removeInventoryItem('lait', 5)
							xPlayer.addInventoryItem(item, 1)
						else
							TriggerClientEvent('esx:showNotification', _source, "Vous avez besoin de x5 lait!")
							return
						end
					elseif item == "fromages" then
						if laitQTE >= 2 then
							xPlayer.removeInventoryItem('lait', 2)
							xPlayer.addInventoryItem(item, 1)
						else
							TriggerClientEvent('esx:showNotification', _source, "Vous avez besoin de x2 lait!")
							return
						end
					elseif item == "jpommes" then
						if pommesQTE >= 5 then
							xPlayer.removeInventoryItem('pommes', 5)
							xPlayer.addInventoryItem(item, 1)
						else
							TriggerClientEvent('esx:showNotification', _source, "Vous avez besoin de x5 pommes!")
							return
						end
					elseif item == "cidre" then
						if pommesQTE >= 10 then
							xPlayer.removeInventoryItem('pommes', 10)
							xPlayer.addInventoryItem(item, 1)
						else
							TriggerClientEvent('esx:showNotification', _source, "Vous avez besoin de x10 pommes!")
							return
						end
					elseif item == "tarte" then
						if pommesQTE >= 10 then
							xPlayer.removeInventoryItem('pommes', 10)
							xPlayer.addInventoryItem(item, 1)
						else
							TriggerClientEvent('esx:showNotification', _source, "Vous avez besoin de x10 pommes!")
							return
						end
					end
					--gTransform(_source,item)
				end)
			end
			

	end	
end


RegisterServerEvent('esx_dinerjob:gTransform')
AddEventHandler('esx_dinerjob:gTransform', function(item)
	local _source = source
  	
	if Transforming == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		Transforming = false
	else
		Transforming = true
		TriggerClientEvent('esx:showNotification', _source, 'En cours..') 
		gTransform(_source,item)
	end
end)

RegisterServerEvent('esx_dinerjob:stopTransform')
AddEventHandler('esx_dinerjob:stopTransform', function()
	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		Transforming = false
		--TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		--TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~transformer votre raisin')
		PlayersTransforming[_source]=true
		Transforming = true
	end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		
		if zone == 'SellFarm' then

			local vblancQTE = xPlayer.getInventoryItem('vblanc').count
			local vrougeQTE = xPlayer.getInventoryItem('vrouge').count

			if vblancQTE >= 1 then
					timeZ = 3500
					if drugsOn then timeZ = 3500/2
					else timeZ = 3500
					end
					SetTimeout(timeZ, function()
						local money = 150
						xPlayer.removeInventoryItem('vblanc', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_diner', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(math.floor(money / 100 * 30))
						end
						xPlayer.addMoney(math.floor(money / 100 * 70))
						TriggerClientEvent('esx:showNotification', xPlayer.source, 'votre avez gagné ~g~$' .. money)
						
						Sell(source,zone)
					end)
			elseif vrougeQTE >= 1 then
					timeZ = 3500
					if drugsOn then timeZ = 3500/2
					else timeZ = 3500
					end
					SetTimeout(timeZ, function()
						local money = 150
						xPlayer.removeInventoryItem('vrouge', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_diner', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(math.floor(money / 100 * 30))
						end
						xPlayer.addMoney(math.floor(money / 100 * 70))
						TriggerClientEvent('esx:showNotification', xPlayer.source, 'votre avez gagné ~g~$' .. money)
						
						Sell(source,zone)
					end)
			else
				TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de produits')
			end
		end
	end
end

RegisterServerEvent('esx_dinerjob:startSell')
AddEventHandler('esx_dinerjob:startSell', function(zone)
	local _source = source

	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, 'Revente en cours...')
		Sell(_source, zone)
	end
end)

RegisterServerEvent('esx_dinerjob:stopSell')
AddEventHandler('esx_dinerjob:stopSell', function()
	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		--TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
		PlayersSelling[_source]=true
	end
end)

RegisterServerEvent('esx_dinerjob:getStockItem')
AddEventHandler('esx_dinerjob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_diner', function(inventory)
		local item = inventory.getItem(itemName)
		TriggerEvent('esx_advanced_inventory:GetInventoryWeight', function(invTaille, itemTaille) 
			weight = 50000 - invTaille
			  if item.count >= count then
				local getTaille = itemTaille * count
				if getTaille <= weight then
					inventory.removeItem(itemName, count)
					xPlayer.addInventoryItem(itemName, count)
				   	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Vous avez retiré " .. count .. ' ' .. item.label, 'CHAR_DAVE', 1)
					TriggerEvent('CoreLog:SendDiscordLog', 'Black Wood - Coffre', "`[COFFRE]` "..GetPlayerName(xPlayer.source) .. " a retiré x"..count.."`[".. item.label .."]`", 'Red', false, xPlayer.source)
				elseif getTaille >= weight then
				  TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Tu n\'as pas assez de place dans tes poches...", 'CHAR_DAVE', 1)
				end
			  else
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Quantité invalide", 'CHAR_DAVE', 1)
			  end
		  end, source, itemName)
	end)
end)

ESX.RegisterServerCallback('esx_dinerjob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_diner', function(inventory)
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

RegisterServerEvent('esx_dinerjob:putStockItems')
AddEventHandler('esx_dinerjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_diner', function(inventory)
			local item = inventory.getItem(itemName)
	
			if item.count >= 0 then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
				TriggerEvent('CoreLog:SendDiscordLog', 'Black Wood - Coffre', "`[COFFRE]` "..GetPlayerName(xPlayer.source) .. " a déposé x"..count.."`[".. item.label .."]`", 'Green', false, xPlayer.source)
			else
				TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Quantité invalide. Veuillez ressayer.')
			end
	
			TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez ajouter ~y~x" .. count .. ' ~b~' .. item.label)
		end)
	else
		TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Vous n\'avez pas cet objet sur vous.')
	end
end)

RegisterServerEvent('esx_diner:buyItem')
AddEventHandler('esx_diner:buyItem', function(itemName, price, itemLabel, iVal)

    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local limit = xPlayer.getInventoryItem(itemName).limit
    local qtty = xPlayer.getInventoryItem(itemName).count
    local final_price = price * iVal

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_diner', function(account)
		if account.money >= final_price then
			if qtty < limit then
				account.removeMoney(final_price, "Cout de production de x"..iVal.." "..itemLabel, "billing")
				xPlayer.addInventoryItem(itemName, iVal)
			else
				TriggerClientEvent('Core:ShowNotification', _source, "Vous en avez déjà trop sur vous.")
			end
		else
			TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Votre société ~r~n'a pas assez d'argent~w~ pour assumer le ~b~coût de production~w~.")
		end
	end)
end)

ESX.RegisterServerCallback('esx_dinerjob:getPlayerInventory', function(source, cb)
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

RegisterServerEvent('esx_dinerjob:checkForLimitation')
AddEventHandler('esx_dinerjob:checkForLimitation', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local checkLimitation = exports.Nebula_farmlimitation:UserReachFarmLimitation(xPlayer.getIdentifier(), 1, 'dinerJob')
  TriggerClientEvent("esx_dinerjob:responseCheckForLimitation", source, checkLimitation)
end)
