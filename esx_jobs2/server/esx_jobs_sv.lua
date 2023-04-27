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

--[[AddEventHandler('esx:playerDropped', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local caution = xPlayer.get('caution')
  TriggerEvent('esx_addonaccount:getAccount', 'caution', xPlayer.identifier, function(account)
    account.addMoney(caution)
  end)
end)]]

AddEventHandler('esx:setJob', function(source, job, lastJob)
  timeWhileNotFisnish[source] = false
  time[source] = 0
end)

AddEventHandler('esx:setJob2', function(source, job, lastJob)
  timeWhileNotFisnish[source] = false
  time[source] = 0
end)

RegisterServerEvent('esx_jobs2:setCautionInCaseOfDrop')
AddEventHandler('esx_jobs2:setCautionInCaseOfDrop', function(caution)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  xPlayer.set('caution', caution)
end)

RegisterServerEvent('esx_jobs2:giveBackCautionInCaseOfDrop')
AddEventHandler('esx_jobs2:giveBackCautionInCaseOfDrop', function()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addonaccount:getAccount', 'caution', xPlayer.identifier, function(account)
    local caution = account.money
    account.removeMoney(caution)
    if caution > 0 then
      xPlayer.addAccountMoney('bank', caution)
      TriggerClientEvent('esx:showNotification', _source, _U('bank_deposit_g').. caution .. _U('bank_deposit2'))
    else
      --TriggerClientEvent('esx:showNotification', _source, _U('bank_nodeposit'))
    end
  end)
end)

local temp = false
local tempZ = 1000
RegisterServerEvent('esx_jobs2:drugsOn')
AddEventHandler('esx_jobs2:drugsOn', function()
    temp = true
end)
RegisterServerEvent('esx_jobs2:drugsOff')
AddEventHandler('esx_jobs2:drugsOff', function()
    temp = false
end)

local function Work(source, item)

  TriggerClientEvent('esx_drugs:EnableE', source)

  if temp then
	tempZ = 500
  else
    tempZ = 1000
  end

  if PlayersWorking[source] == true then
    local xPlayer = ESX.GetPlayerFromId(source)
    local nameItem, nameRequired, itemRequired = nil, nil, nil
    local itemQtty, requiredItemQtty, itemMax, itemDrop, itemAdd, itemPrice = 0, 0, 0, 0, 0, 0
    for i=1, #item, 1 do
      if item[i].name ~= _U('delivery') then
        nameItem = item[i].db_name
        itemQtty = xPlayer.getInventoryItem(item[i].db_name).count
        itemMax = item[i].max
        itemDrop = item[i].drop
        itemAdd = itemMax - itemQtty
        time[source] = tempZ * itemAdd
      end
      if item[1].requires ~= "nothing" then
        nameRequired = item[i].requires_name
        requiredItemQtty = xPlayer.getInventoryItem(item[i].requires).count
        itemRequired = item[i].requires
        itemMax = item[i].max
        itemDrop = item[i].drop
        if item[i].name == _U('delivery') then
          time[source] = tempZ * requiredItemQtty
          itemPrice = item[i].price
        end
      end
    end
    
    if nameItem ~= nil and itemQtty >= itemMax then
      TriggerClientEvent('esx:showNotification', source, _U('max_limit') .. nameItem)
      PlayersWorking[source] = false
    elseif nameRequired ~= nil and requiredItemQtty <= 0 then
      TriggerClientEvent('esx:showNotification', source, _U('not_enough') .. nameRequired .. _U('not_enough2'))
      PlayersWorking[source] = false
    else
      timeWhileNotFisnish[source] = true
      if nameItem ~= nil then
        if itemDrop == 100 then
          local playerIdentifier = xPlayer.getIdentifier()
          -- Check if player farm limitation is reach
          local farmLimitationReach = exports.Nebula_farmlimitation:UserReachFarmLimitation(playerIdentifier, itemAdd, 'boxJob')
          if farmLimitationReach == false then
            TriggerClientEvent('progressBar:drawBar', source, true, time[_source], "En cours, Veuillez patienter")
            --TriggerClientEvent('progressBar:start', source, time[source], "En cours, Veuillez patienter")
            Citizen.Wait(time[source])
            if PlayersWorking[source] == true then
              xPlayer.addInventoryItem(nameItem, itemAdd)

              -- Update number of items get in job
              exports.Nebula_farmlimitation:UpdateUserAndRunValue(playerIdentifier, itemAdd, 'boxJob')

              if nameRequired ~= nil then
                xPlayer.removeInventoryItem(itemRequired, requiredItemQtty)
              end
            end
          else
	          TriggerClientEvent('esx:showAdvancedNotification', source, "Employeur", "SMS", "Désolé, mais vous avez atteint votre quota de travail pour aujourd'hui. Repassez demain", 'CHAR_MRS_THORNHILL', 2)
          end
        else
          local chanceToDrop = math.random(100)
          if chanceToDrop <= itemDrop then
            TriggerClientEvent('progressBar:drawBar', source, true, time[_source], "En cours, Veuillez patienter")
            --TriggerClientEvent('progressBar:start', source, time[source], "En cours, Veuillez patienter")
            Citizen.Wait(time[source])
            if PlayersWorking[source] == true then
              xPlayer.addInventoryItem(nameItem, itemAdd)
              if nameRequired ~= nil then
                xPlayer.removeInventoryItem(itemRequired, requiredItemQtty)
              end
            end
          end
        end
      elseif requiredItemQtty > 0 then
        TriggerClientEvent('progressBar:drawBar', source, true, time[_source], "En cours, Veuillez patienter")
        --TriggerClientEvent('progressBar:start', source, time[source], "En cours, Veuillez patienter")
        Citizen.Wait(time[source])
        if PlayersWorking[source] == true then
          local vPrix = itemPrice * requiredItemQtty
          local eAddEnt = math.floor(vPrix / 100 * 70) --70%
		  local eAddPly = math.floor(vPrix / 100 * 30) --30%
          xPlayer.removeInventoryItem(itemRequired, requiredItemQtty)
          xPlayer.addMoney(eAddPly)
      
          TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. xPlayer.job.name, function(account)
            account.addMoney(eAddEnt)
          end)
          TriggerClientEvent('esx:showNotification', source, "Vendu pour" .. " ~r~$" .. eAddPly)
        end
      end
      timeWhileNotFisnish[source] = false
    end
  end
end

RegisterServerEvent('esx_jobs2:startWork')
AddEventHandler('esx_jobs2:startWork', function(item)
  local source = source
  if timeWhileNotFisnish[source] == false then
    PlayersWorking[source] = true
    Work(source, item)
  else
    TriggerClientEvent('esx:showNotification', source, "Attend un peu")
  end
end)

RegisterServerEvent('esx_jobs2:stopWork')
AddEventHandler('esx_jobs2:stopWork', function()
  local source = source
  if PlayersWorking[source] == true then
    TriggerClientEvent('progressBar:stop', source)
    TriggerClientEvent('esx:showNotification', source, "Tu t'es trop éloigné, vous devez attendre " .. time[source] / 1000 .. " secondes avant de pouvoir retourner sur le point" )
  end
  PlayersWorking[source] = false
end)

RegisterServerEvent('esx_jobs2:caution')
AddEventHandler('esx_jobs2:caution', function(cautionType, cautionAmount, spawnPoint, vehicle)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  if cautionType == "take" then
    --xPlayer.removeAccountMoney('bank', cautionAmount)
    --xPlayer.set('caution', cautionAmount)
    --TriggerClientEvent('esx:showNotification', source, _U('bank_deposit_r') .. cautionAmount .. _U('caution_taken'))
    TriggerClientEvent('esx_jobs2:spawnJobVehicle', source, spawnPoint, vehicle)
  elseif cautionType == "give_back" then
    --xPlayer.addAccountMoney('bank', cautionAmount)
    --xPlayer.set('caution', 0)
    --TriggerClientEvent('esx:showNotification', source, "Votre caution de ~g~$" .. cautionAmount .. " ~w~vous a été remis.")
  end
end)
