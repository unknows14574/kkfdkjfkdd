RegisterNetEvent("xInteracPeds:give")
AddEventHandler("xInteracPeds:give", function(name, cb, price, nameSociety)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    if xPlayer.getInventoryItem(name).count >= cb then
        xPlayer.removeInventoryItem(name, cb)
        xPlayer.addMoney(( 1 * Config.PercentPlayer / 100) * (cb * price))
        TriggerEvent('esx_addonaccount:getSharedAccount', nameSociety, function(account)
            account.addMoney(( 1 - (1 * Config.PercentPlayer / 100)) * (cb * price))
        end)
    end
end)