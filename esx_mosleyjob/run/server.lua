ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx_flywheels:end')
AddEventHandler('esx_flywheels:end', function()
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)

  local playerMoney = MosleyConfig.NPCJobEarningsPlayer
  local entrepriseMoney = MosleyConfig.NPCJobEarningsEntreprise

	if xPlayer.job2 ~= nil and xPlayer.job2.name ~= 'unemployed2' then
		playerMoney = math.floor(playerMoney * (1/3))
	end

	xPlayer.addMoney(playerMoney)-- en 20-30min

  -- Update number of items get in job
  exports.Nebula_farmlimitation:UpdateUserAndRunValue(xPlayer.identifier, 1, 'mosleyJob')

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_flywheels', function(account)
	  account.addMoney(entrepriseMoney, "Run de effectué par ".. GetPlayerName(_source) , 'deposit')
  end)

  TriggerClientEvent('Core:ShowNotification', _source, "Vous avez recu ~g~$" .. playerMoney .. "~y~ [$"..entrepriseMoney.." pour l'entreprise]~w~.")
end)
