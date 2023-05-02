-- Événement pour créer un ped
RegisterNetEvent('xInteracPeds:spawnPed')
AddEventHandler('xInteracPeds:spawnPed', function(pedModel, spawnPos, v)
    TriggerClientEvent('xInteracPeds:spawnPedClient', source, pedModel, spawnPos, v)
end)

RegisterServerEvent('xInteracPeds:releasePed')
AddEventHandler('xInteracPeds:releasePed', function(ped)
    for i=1, #activePeds do
        if activePeds[i] == ped then
            table.remove(activePeds, i)
            DeletePed(ped)
            break
        end
    end
end)

RegisterNetEvent("xInteracPeds:give")
AddEventHandler("xInteracPeds:give", function(name, cb, price, nameSociety)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    cb = tonumber(cb)
    if xPlayer.getInventoryItem(name).count >= cb then
        xPlayer.removeInventoryItem(name, cb)
        xPlayer.addMoney((1 * Config.PercentPlayer / 100) * (cb * price))
        TriggerEvent('esx_addonaccount:getSharedAccount', nameSociety, function(account)
            account.addMoney((1 - (1 * Config.PercentPlayer / 100)) * (cb * price))
        end)
    end
end)

