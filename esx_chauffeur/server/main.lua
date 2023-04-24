ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx_chauffeur:pay')
AddEventHandler('esx_chauffeur:pay', function()

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.addMoney(2500)-- en 20-30min

  TriggerClientEvent('esx:showNotification', _source, "Vous avez recu $2500")

end)
