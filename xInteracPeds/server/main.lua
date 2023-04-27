ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_npc_order:getJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob().name
    cb(job)
end)

ESX.RegisterServerCallback('esx_npc_order:getDutyStatus', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob()

    TriggerEvent('esx:getDutyStatus', job.name, function(isDuty)
        cb(isDuty)
    end)
end)

RegisterNetEvent('esx_npc_order:completeOrder')
AddEventHandler('esx_npc_order:completeOrder', function(item, price, businessName)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem(item, 1)

    local playerPayment = math.floor(price * 0.3)
    local businessPayment = math.floor(price * 0.7)

    xPlayer.addMoney(playerPayment)

    TriggerEvent('esx_addonaccount:getSharedAccount', businessName, function(account)
        account.addMoney(businessPayment)
    end)

    TriggerClientEvent('esx:showNotification', _source, 'Vous avez reçu ' .. playerPayment .. '$ pour la vente.')
end)

ESX.RegisterServerCallback('esx_npc_order:hasItem', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemQuantity = xPlayer.getInventoryItem(item).count

    cb(itemQuantity > 0)
end)
