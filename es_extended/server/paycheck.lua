local Pays = {}

function StartPayCheck()
	CreateThread(function()
		while true do
			Wait(Config.PaycheckInterval)
			local xPlayers = ESX.GetExtendedPlayers()
			for _, xPlayer in pairs(xPlayers) do
				local job     = xPlayer.job.grade_name
                local service  = xPlayer.job.service
				local salary  = xPlayer.job.grade_salary

				if salary > 0 then
					if job == 'unemployed' then -- unemployed
						xPlayer.addAccountMoney('bank', salary)
						TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_help', salary), 'CHAR_BANK_MAZE', 9)
					elseif Config.EnableSocietyPayouts and service then -- possibly a society
						TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
							if society ~= nil then -- verified society
								TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
									if account.money >= salary then -- does the society money to pay its employees?
										xPlayer.addAccountMoney('bank', salary)
										account.removeMoney(salary)

										if Pays[xPlayer.source] ~= nil then
											Pays[xPlayer.source] = Pays[xPlayer.source] + salary
										else
											Pays[xPlayer.source] = salary
										end

										TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), "Vous avez reçu votre salaire", xPlayer.job.label .. " - " .. xPlayer.job.grade_label .. " [$" .. xPlayer.job.grade_salary .. "]", 'CHAR_BANK_MAZE', 9)
									else
										TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), "Entreprise", "~r~Votre entreprise n'a plus d'argent pour vous payer.", 'CHAR_BANK_MAZE', 9)
									end
								end)
							else -- not a society
								xPlayer.addAccountMoney('bank', salary)

								if Pays[xPlayer.source] ~= nil then
									Pays[xPlayer.source] = Pays[xPlayer.source] + salary
								else
									Pays[xPlayer.source] = salary
								end

								TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
							end
						end)
					elseif job ~= 'unemployed' then -- generic job
						if service == 0 or not service then
							salary = math.floor(xPlayer.job.grade_salary / 2)
						end
						
						xPlayer.addAccountMoney('bank', salary)

						if Pays[xPlayer.source] ~= nil then
							Pays[xPlayer.source] = Pays[xPlayer.source] + salary
						else
							Pays[xPlayer.source] = salary
						end

						TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), "Vous avez reçu votre salaire", xPlayer.job.label .. " - " .. xPlayer.job.grade_label .. " [" .. salary .. "$]", 'CHAR_BANK_MAZE', 9)
					end
				end
			end
		end
	end)
end

AddEventHandler('playerDropped', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer and Pays[xPlayer.source] then
		MySQL.update("INSERT INTO `transactions` (from_identifier, from_last_name, from_first_name, to_identifier, to_last_name, to_first_name, reason, amount, `at`, `usage`) SELECT 'unknown', 'unknown', 'unknown', @JOUEUR_STEAMID, users.lastname, users.firstname, @type, @MONTANT, NOW(), @usage FROM `users` WHERE users.identifier = @JOUEUR_STEAMID", {
			['@JOUEUR_STEAMID'] = xPlayer.identifier,
			['@type'] = "Salaires du jour de "..xPlayer.job.label .. " - " .. xPlayer.job.grade_label,
			['@MONTANT'] = ESX.Math.Round(Pays[xPlayer.source]),
			['@usage'] = "salary"
		})

		Pays[xPlayer.source] = nil
	end
end)
