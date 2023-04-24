
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'pizzathis', 'pizzathis', 'society_pizzathis', 'society_pizzathis', 'society_pizzathis', {type = 'private'})

RegisterServerEvent('pizzathis:pourboire') --Paie a la livraison d'une pizzathis + pourboire eventuel
AddEventHandler('pizzathis:pourboire', function(pourboire)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local money = 300
	if xPlayer.job2 ~= nil and xPlayer.job2.name ~= 'unemployed2' then
		money = math.floor(money * (1/3))	
	end

	xPlayer.addMoney(money)
	-- Update number of run
	exports.Nebula_farmlimitation:UpdateUserAndRunValue(xPlayer.getIdentifier(), 1, 'pizzaJob')
	
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_pizzathis', function(account)
		local entreprise = account
		if entreprise ~= nil then
		    entreprise.addMoney(425)
		end
	end)
	TriggerClientEvent('esx:showNotification', _source, "Voila pour toi : " .. money .. '$')
end)

RegisterServerEvent("pizzathis:paiefinale") --Paie "bonus" lors de la fin de service
AddEventHandler("pizzathis:paiefinale", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local money = 250
	if xPlayer.job2 ~= nil and xPlayer.job2.name ~= 'unemployed2' then
		money = math.floor(money * (1/3))
	end

	xPlayer.addMoney(money)
	TriggerClientEvent('esx:showNotification', source, "Voici votre petit bonus final: ".. money ..'$')
end)

RegisterServerEvent("pizzathis:Prepa") 
AddEventHandler("pizzathis:Prepa", function(nameZ, prix, qte)--modif
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_pizzathis', function(account)
		if account.money >= prix then
			account.removeMoney(prix, "Cout de production de x"..qte.." "..nameZ, "billing")
			xPlayer.addInventoryItem(nameZ, qte)
		else
			TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Votre société ~r~n'a pas assez d'argent~w~ pour assumer le ~b~coût de production~w~.")
		end
	end)
end)

function isOnline(source)
	local Online = 0
	TriggerEvent('esx_jobcounter:returnTableMetierServer', function(JobConnected) 
		Online = JobConnected
	end, "tab", "pizzathis")
	if Online ~= 0 then
		return true
	else 
		return false
	end
end

RegisterServerEvent("pizzathis:Buy") 
AddEventHandler("pizzathis:Buy", function(nameZ, prix, qte)--modif
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if not isOnline(source) then
		local money = xPlayer.getMoney()

		if money >= prix then
			xPlayer.removeMoney(prix)
			xPlayer.addInventoryItem(nameZ, qte)
			
			local societyAccount = nil
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_pizzathis', function(account)
				societyAccount = account
			end)
			if societyAccount ~= nil then
				societyAccount.addMoney(prix)
			end
		else
			TriggerClientEvent('esx:showNotification', source, 'vous n\'avez pas assez d\'argents!')
		end
	else
		TriggerClientEvent("esx:showNotification", source, "vous ne pouvez pas acheter un employé est en ville")
	end
end)

RegisterServerEvent("pizzathis:itemadd") --Ajout temporaire de l'item "pizzathis"
AddEventHandler("pizzathis:itemadd", function(nbpizzathis)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.addInventoryItem('pfood', tonumber(nbpizzathis))
end)

RegisterServerEvent("pizzathis:itemrm") --Rm de l'item "pizzathis"
AddEventHandler("pizzathis:itemrm", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('pfood', 1)
end)

RegisterServerEvent("pizzathis:deleteAllPizz") --Rm de l'item "pizzathis"
AddEventHandler("pizzathis:deleteAllPizz", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
		
	local pizzathisnbr = xPlayer.getInventoryItem('pfood').count
	
	xPlayer.removeInventoryItem('pfood', pizzathisnbr)
end)

RegisterServerEvent('esx_pizzathisjob:getStockItem')
AddEventHandler('esx_pizzathisjob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pizzathis', function(inventory)
		local item = inventory.getItem(itemName)

		TriggerEvent('esx_advanced_inventory:GetInventoryWeight', function(invTaille, itemTaille) 
			weight = 50000 - invTaille
			  if item.count >= count then
				local getTaille = itemTaille * count
				if getTaille <= weight then
				   inventory.removeItem(itemName, count)
				   xPlayer.addInventoryItem(itemName, count)
				   TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Vous avez retirer " .. count .. ' ' .. item.label, 'CHAR_DAVE', 1)
				   TriggerEvent('CoreLog:SendDiscordLog', 'Pizza This - Coffre', "`[COFFRE]` "..GetPlayerName(xPlayer.source) .. " a retiré x"..count.."`[".. item.label .."]`", 'Red', false, xPlayer.source)
				elseif getTaille >= weight then
				  TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Tu n\'as pas assez de place dans tes poches...", 'CHAR_DAVE', 1)
				end
			  else
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Quantité invalide", 'CHAR_DAVE', 1)
			  end
		  end, source, itemName)
	end)
end)

ESX.RegisterServerCallback('esx_pizzathisjob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pizzathis', function(inventory)
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

RegisterServerEvent('esx_pizzathisjob:putStockItems')
AddEventHandler('esx_pizzathisjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pizzathis', function(inventory)
			local item = inventory.getItem(itemName)
	
			if item.count >= 0 then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
				TriggerEvent('CoreLog:SendDiscordLog', 'Pizza This - Coffre', "`[COFFRE]` "..GetPlayerName(xPlayer.source) .. " a déposé x"..count.."`[".. item.label .."]`", 'Green', false, xPlayer.source)
				TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez ajouter ~y~x" .. count .. ' ~b~' .. item.label)
			else
				TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Quantité invalide. Veuillez ressayer.')
			end	
		end)
	else
		TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Vous n\'avez pas cet objet sur vous.')
	end
end)

ESX.RegisterServerCallback('esx_pizzathisjob:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})
end)

function rFood()
    local num = math.random(0,8)
    if num == 0 then return "burger"
    elseif num == 1 then return "burgerxl"
    elseif num == 2 then return "pizza"
    elseif num == 3 then return "sandwich"
    elseif num == 4 then return "pizzathis"
    elseif num == 5 then return "kebab"
    elseif num == 6 then return "tartiflette"
    elseif num == 7 then return "raclette"
    elseif num == 8 then return "salade"
    end
end
function rWater()
    local num = math.random(0,5)
    if num == 0 then return "pepsi"
    elseif num == 1 then return "coca"
    elseif num == 2 then return "fanta"
    elseif num == 3 then return "orangina"
    elseif num == 4 then return "miranda"
    elseif num == 5 then return "icetea"
    end
end

TriggerEvent('es:addCommand', 'playpizzathis', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'pizzathis') then
    TriggerClientEvent("esx_pizzathisjob:playmusic", -1, args[1])
    music = args[1]
	end	
end)

TriggerEvent('es:addCommand', 'pausepizzathis', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'pizzathis') then
		print(pause)
		if pause then
			TriggerClientEvent("esx_pizzathisjob:pausepizzathis", -1, "play")
			pause = false
		else
			TriggerClientEvent("esx_pizzathisjob:pausepizzathis", -1, "pause")
			pause = true
		end
	end	
end)

TriggerEvent('es:addCommand', 'volumepizzathis', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'pizzathis') then
		print(args[1])
		TriggerClientEvent("esx_pizzathisjob:volumepizzathis", -1, args[1])
	end	
end)

TriggerEvent('es:addCommand', 'stoppizzathis', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job ~= nil and xPlayer.job.name == 'pizzathis') then
		TriggerClientEvent("esx_pizzathisjob:stoppizzathis", -1)
	end	
end)

RegisterServerEvent('esx_pizzathisjob:checkForLimitation')
AddEventHandler('esx_pizzathisjob:checkForLimitation', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  local checkLimitation = exports.Nebula_farmlimitation:UserReachFarmLimitation(xPlayer.getIdentifier(), 1, 'pizzaJob')
  TriggerClientEvent("esx_pizzathisjob:responseCheckForLimitation", source, checkLimitation)
end)