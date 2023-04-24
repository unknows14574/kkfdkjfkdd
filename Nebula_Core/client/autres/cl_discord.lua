function LogShooting()
	if IsPedShooting(playerPed) then
		TriggerServerEvent('CoreLog:SendDiscordLog', "Tirs", "**" .. GetPlayerName(playerID) .. "** a tiré avec `"  ..  ((Config.WeaponNames[tostring(currentWeaponHash)] ~= nil and Config.WeaponNames[tostring(currentWeaponHash)]) or "jspl'arme") .. "`".. (IsPedCurrentWeaponSilenced(playerPed) and " **[avec un silencieux]**" or ""), "Grey")
		Citizen.Wait(Config.Discord.Log.TimeToSendNewWeponAlert)
	end
end

function LogDead()
	if entityhealth <= 0 then
		local PedKiller = GetPedSourceOfDeath(playerPed)
		local Weapon = Config.WeaponNames[tostring(GetPedCauseOfDeath(playerPed))]
		local PedKillerVeh = GetPedInVehicleSeat(PedKiller, -1)
		local Killer = nil

		if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
			Killer = NetworkGetPlayerIndexFromPed(PedKiller)
		elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(PedKillerVeh) and IsPedAPlayer(PedKillerVeh) then
			Killer = NetworkGetPlayerIndexFromPed(PedKillerVeh)
		end

		if Killer == playerID or Killer == nil then
			TriggerServerEvent('CoreLog:SendDiscordLog', "Morts / Suicides", "**`" .. GetPlayerName(playerID) .. "`** s'est suicidé".. ((Weapon ~= nil and (" avec `" .. Weapon .. "`")) or ""), "Red")
		else
			TriggerServerEvent('CoreLog:SendDiscordLog', "Morts / Suicides", "**`" .. GetPlayerName(Killer) .. "`** a tué " .. GetPlayerName(playerID) .. " " .. (Weapon ~= nil and " avec `" .. Weapon.."`"), "Red", GetPlayerServerId(Killer))
		end

		while IsEntityDead(playerPed) do
			Citizen.Wait(0)
		end
	end
end

