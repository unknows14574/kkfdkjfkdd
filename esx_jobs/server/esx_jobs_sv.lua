local PlayersWorking = {}
local Players = {}
local timeWhileNotFisnish = {}
local time = {}

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  timeWhileNotFisnish[_source] = false
  time[_source] = 0
  xPlayer.set('caution', 0)
end)

AddEventHandler('esx:setJob', function(source, job, lastJob)
  timeWhileNotFisnish[source] = false
  time[source] = 0
end)

AddEventHandler('esx:setJob2', function(source, job, lastJob)
  timeWhileNotFisnish[source] = false
  time[source] = 0
end)


RegisterServerEvent('esx_jobs:setCautionInCaseOfDrop')
AddEventHandler('esx_jobs:setCautionInCaseOfDrop', function(caution)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  xPlayer.set('caution', caution)
end)

RegisterServerEvent('esx_jobs:giveBackCautionInCaseOfDrop')
AddEventHandler('esx_jobs:giveBackCautionInCaseOfDrop', function()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addonaccount:getAccount', 'caution', xPlayer.identifier, function(account)
    local caution = account.money
    account.removeMoney(caution)
    if caution > 0 then
      xPlayer.addAccountMoney('bank', caution)
    end
  end)
end)

local temp = false
local tempZ = 1000
RegisterServerEvent('esx_jobs:drugsOn')
AddEventHandler('esx_jobs:drugsOn', function()
    temp = true
end)
RegisterServerEvent('esx_jobs:drugsOff')
AddEventHandler('esx_jobs:drugsOff', function()
    temp = false
end)

local function Work(source, item, job)
  TriggerClientEvent('esx_drugs:EnableE', source)
  if PlayersWorking[source] == true then
    local xPlayer = ESX.GetPlayerFromId(source)
    local nameItem, nameRequired, itemRequired = nil, nil, nil
    local itemQtty, requiredItemQtty, itemMax, itemDrop, itemAdd, itemPrice = 0, 0, 0, 0, 0, 0
    for i=1, #item, 1 do
      if item[i].name ~= 'point de livraison' then
        nameItem = item[i].db_name
        itemQtty = xPlayer.getInventoryItem(item[i].db_name).count
        itemMax = item[i].max
        itemDrop = item[i].drop
        itemAdd = itemMax - itemQtty
        time[source] = item[i].time * itemAdd
      end
      if item[1].requires ~= "nothing" then
        nameRequired = item[i].requires_name
        requiredItemQtty = xPlayer.getInventoryItem(item[i].requires).count
        itemRequired = item[i].requires
        itemMax = item[i].max
        itemDrop = item[i].drop
        itemTransfoAdd = requiredItemQtty / 2
        itemTransforemove = item[i].remove * itemTransfoAdd
        itemRequieredQtty = item[i].required_quantity
        if item[i].name == 'point de livraison' or item[i].name == 'paquet cigarette' then
          time[source] = item[i].time * requiredItemQtty
          itemPrice = item[i].price
        end
      end
    end
    
    if nameItem ~= nil and itemQtty >= itemMax then
	  TriggerClientEvent('esx:showAdvancedNotification', source, "Employeur", "SMS", "Vous avez déjà le maximum de: " .. nameItem ..".", 'CHAR_MRS_THORNHILL', 2)
      PlayersWorking[source] = false
    elseif nameRequired ~= nil and requiredItemQtty <= 0 then
	  TriggerClientEvent('esx:showAdvancedNotification', source, "Employeur", "SMS", "Vous n'avez plus assez de " .. nameRequired .. " pour continuer cette tâche.", 'CHAR_MRS_THORNHILL', 2)
      PlayersWorking[source] = false
    else
      timeWhileNotFisnish[source] = true
      if nameItem ~= nil then
        if itemDrop == 100 or itemDrop == 110 then
          local playerIdentifier = xPlayer.getIdentifier()
          -- Check if player farm limitation is reach
          local farmLimitationReach = exports.Nebula_farmlimitation:UserReachFarmLimitation(playerIdentifier, itemAdd, "boxJob")

          if farmLimitationReach == false then
            local _source = source
            TriggerClientEvent('progressBar:drawBar', source, true, time[_source], "Récolte en cours, veuillez patienter...")
            Citizen.Wait(time[source])
            if PlayersWorking[source] == true then
              xPlayer.addInventoryItem(nameItem, itemAdd)

              -- Update number of items get in job
              exports.Nebula_farmlimitation:UpdateUserAndRunValue(playerIdentifier, itemAdd, "boxJob")
              
              if nameRequired ~= nil then
                xPlayer.removeInventoryItem(itemRequired, requiredItemQtty)
              end
            end
          else
	          TriggerClientEvent('esx:showAdvancedNotification', source, "Employeur", "SMS", "Désolé, mais vous avez atteint votre quota de travail pour aujourd'hui. Repassez demain", 'CHAR_MRS_THORNHILL', 2)
          end
	      	
        elseif itemDrop == 120 then
          local chanceToDrop = math.random(100)
          if chanceToDrop <= itemDrop then
            if itemRequieredQtty <= requiredItemQtty then
              local _source = source
              TriggerClientEvent('progressBar:drawBar', source, true, time[_source], "Traitement en cours, veuillez patienter...")
              Citizen.Wait(time[source])
              if PlayersWorking[source] == true then
                xPlayer.addInventoryItem(nameItem, math.floor(itemTransfoAdd))
                if nameRequired ~= nil then
                  xPlayer.removeInventoryItem(itemRequired, math.floor(itemTransforemove))
                end
              end
            else
              TriggerClientEvent('Core:ShowNotification', source, "Vous n'avez pas assez de x~y~"..itemTransforemove.." ~b~"..itemRequired.."~w~ pour débuter le traitement.")
            end
          end
        end
      elseif requiredItemQtty > 0 then
		local _source = source
        TriggerClientEvent('progressBar:drawBar', source, true, time[_source], "Vente en cours, veuillez patienter...")
        Citizen.Wait(time[source])
        if PlayersWorking[source] == true then
          local itemInInventory =  xPlayer.getInventoryItem(itemRequired)
          if itemInInventory ~= nil and itemInInventory.count > 0 then
            local vPrix = itemPrice * itemInInventory.count
            local eAddEnt = math.floor(vPrix / 100 * 60) --60%
            local eAddPly = math.floor(vPrix / 100 * 40) --40%
            xPlayer.removeInventoryItem(itemRequired, itemInInventory.count)
            if xPlayer.job2 ~= nil and xPlayer.job2.name ~= 'unemployed2' then
              eAddPly = math.floor(eAddPly * (1/3))
            end
            xPlayer.addMoney(eAddPly)
        
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' ..job, function(account)
              account.addMoney(eAddEnt, "Run de "..itemRequired.. "x"..requiredItemQtty.." effectué par "..GetPlayerName(_source), 'deposit')
            end)
            TriggerClientEvent('esx:showAdvancedNotification', source, "Employeur", "Bon travail !", "Tu as vendu pour" .. " ~r~$" .. eAddPly .."", 'CHAR_BANK_MAZE', 9)
          else
            TriggerClientEvent('Core:ShowNotification', source, "Vous n'avez pas le necessaire de " .. itemRequired .. " pour débuter le traitement.")
          end
        end
      end
      timeWhileNotFisnish[source] = false
    end
  end
end

RegisterServerEvent('esx_jobs:startWork') 
AddEventHandler('esx_jobs:startWork', function(item, job)
  local source = source
  if timeWhileNotFisnish[source] == false or timeWhileNotFisnish[source] == nil then
    PlayersWorking[source] = true
    Work(source, item, job)
  else
	  TriggerClientEvent('esx:showAdvancedNotification', source, "Employeur", "SMS", "Tu dois attendre encore un peu...", 'CHAR_MRS_THORNHILL', 2)
  end
end)

RegisterServerEvent('esx_jobs:stopWork')
AddEventHandler('esx_jobs:stopWork', function()
  local source = source
  if PlayersWorking[source] == true then
    TriggerClientEvent("progressBar:drawBar", source, false)
	TriggerClientEvent('esx:showAdvancedNotification', source, "Employeur", "SMS", "Tu es trop éloigné, tu devras attendre " .. time[source] / 1000 .. " secondes avant de pouvoir retourner sur le point", 'CHAR_MRS_THORNHILL', 2)
  end
  PlayersWorking[source] = false
end)

RegisterServerEvent('esx_jobs:caution')
AddEventHandler('esx_jobs:caution', function(cautionType, cautionAmount, spawnPoint, vehicle)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  if cautionType == "take" then
    TriggerClientEvent('esx_jobs:spawnJobVehicle', source, spawnPoint, vehicle)
  elseif cautionType == "give_back" then
  end
end)
