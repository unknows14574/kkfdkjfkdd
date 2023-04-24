local toogle = false
local EnableShowId = {}
local InfoSaved = {}

local function JobColor(job)
	local TableJob = {
		["ambulance"] = "~r~LSDH",
		["ambulance2"] = "~r~BCDH",
		["avocat"] = "~c~Avocat",
		["avocat2"] = "~c~Avocat",
		["bahama"] = "~p~Bahama",
		["casino"] = "~y~Casino",
		["coffee"] = "~g~Coffee",
		["comedy"] = "~p~Comedy",
		["diner"] = "~g~Blackwoods Saloon",
		["event"] = "~p~Unicorn",
		["fib"] = "~m~FIB",
		["flywheels"] = "~o~Mosley",
		["galaxy"] = "~p~Galaxy",
		["gouv"] = "~c~Gouv",
		["journaliste"] = "~y~Journal",
		["radio"] = "~p~Radio",
		["liquordeli"] = "~p~Deli",
		["mboubar"] = "~p~Tropic",
		["mecano"] = "~o~Benny",
		["mecano2"] = "~o~MecanoM",
		["henhouse"] = "~y~Blackwoods Saloon",
		["pacific"] = "~c~Pacific",
		["pizzathis"] = "~g~Pizza This",
		["police"] = "~b~LSPD",
		["prison"] = "~b~Prison",
		["sheriff"] = "~b~Sheriff",
		["parkranger"] = "~b~Park Ranger",
		["tabac"] = "~g~Tabac",
		["upnatom"] = "~g~Up N Atom Burger",
		["taxi"] = "~y~Taxi",
		["tequi"] = "~p~TequiLaLa",
		["vigne"] = "~y~Vigneron",
		["weed"] = "~g~Chicha",
		["yellow"] = "~y~Yellow",
		["fourriere"] = "~y~Fourrière",
		["doj"] = "~c~Department of Justice",
		["arcade"] = "~p~Arcade Bar",
		["musicrecord"] = "~p~Music Record",
		["eightpool"] = "~p~8 Pool Bar",
		["hooka"] = "~p~Hookah Lounge",
		["unemployed"] = "~w~Chômeur",
	}

	local TableGang = {
		["snk"] = "~c~Broker",
		["mara"] = "~b~Marabunta",
		["burton"] = "~b~Burton",
		["vagos"] = "~y~Vagos",
		["ballas"] = "~p~Ballas",
		["hustlers"] = "~r~Bloods",
		["SAB"] = "~g~Families",
		["VCF"] = "~m~La firme",
		["gitan"] = "~m~Gitan",
		["orga"] = "~m~L'organisation",
		["leninskaia"] = "~m~Bratva",
		["muertos"] = "~m~Oneil",
		["voleur"] = "~m~Cartel",
		["madrazo"] = "~m~Madrazo",
		["mafiacala"] = "~g~SlotLibre",
		["salvatore"] = "~m~Salvatore",
		["yakuza"] = "~m~Kkangpae",
		["bikers"] = "~m~Lost MC",
		["bikers2"] = "~m~Mayans MC",
		["bikers3"] = "~m~Outlaw MC",
		["bikers4"] = "~m~Angel Of Death MC",
		["bikers5"] = "~m~Storm Devils MC",
		["mcreary"] = "~r~Famille McReary",
		["locosyndicate"] = "~m~Loco Syndicate",
		["cdg"] = "~m~Dark Smile",
		["psycho"] = "~w~Psycho - Staff",
		["stony"] = "~w~Stony",
		["unemployed2"] = "~w~Chômeur",
		["duggan"] = "~m~Famille Duggan",
		["monetti"] = "~m~Famille Monetti",
		["bmf"] = "~m~Black Mafia Familie"
	}
	
	for k, v in pairs(TableJob) do
		if k == job then
			return v
		end
	end

	for k, v in pairs(TableGang) do
		if k == job then
			return v
		end
	end

	return "~u~NULL"
end

local function DrawESP(pos, upAdd, text)
	local onScreen, x, y = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z + upAdd)
	local scale = 0.25 * ((1 / GetGameplayCamFov()) * 100)

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(0)
	SetTextProportional(1)
	--SetTextColour(255, 255, 255, 215)
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(x, y)
end

function CheckNameJob()
	if toogle then
		ESX.TriggerServerCallback('esx_jobcounter:returnTableMetier',function(valid)
			for k, v in pairs(valid) do
				InfoSaved[v.id] = {name = ((v.group ~= "user" and v.name) or (v.firstname .. " " .. v.lastname)), job = JobColor(v.job), job2 = JobColor(v.job2), group = ((v.group ~= "user" and "~c~¦") or ""), ping = v.ping }
			end
		end, "tabJob", "players")
	end
end

local function isZeus()
	local zModel = GetHashKey("ig_ary_02")
	local Pass = nil

	ESX.TriggerServerCallback('IsZeus', function (IsAce)
		Pass = IsAce
	end)

	while Pass == nil do
		Citizen.Wait(100)
	end

	if Pass then
		TriggerServerEvent('Admin:IsZeus', true)
		return true
	elseif IsModelValid(zModel) then
		if not HasModelLoaded(zModel) then
			RequestModel(zModel)
			while not HasModelLoaded(zModel) do
				Citizen.Wait(0)
			end
		end
		
		if IsPedModel(PlayerPedId(), zModel) then
			TriggerServerEvent('Admin:IsZeus', true)
			return true
		else
			Core.Main.ShowNotification("Vous devez être en mode modération !")
			return false
		end
	end
end

local function showid()
	if toogle then
		CheckNameJob()
		local distaffich = 440
		while toogle do
			Citizen.Wait(5)
			BlipPlayer(toogle)
			if IsControlJustPressed(2, 314) then
				if distaffich > 450 then
					distaffich = 450
				else
					distaffich = distaffich + 10
				end
				Core.Main.ShowNotification("Distance défini sur ~r~" .. distaffich .. "~s~m", true)
			elseif IsControlJustPressed(2, 315) then
				if distaffich < 0 then
					distaffich = 0
				else
					distaffich = distaffich - 10
				end
				Core.Main.ShowNotification("Distance défini sur ~r~" .. distaffich .. "~s~m", true)
			end

			for _, i in ipairs(GetActivePlayers()) do
				if NetworkIsPlayerActive(i) then
					--local pos = GetEntityCoords(GetPlayerPed(i), true)
					local pos = GetPedBoneCoords(GetPlayerPed(i), 31086, 0, 0, 0)
					local dist = math.floor(GetDistanceBetweenCoords(GetGameplayCamCoords(), pos, 1))
					
					local x, y, z = table.unpack(pos)
					z = z-0.60

					if dist <= distaffich then
						local id = GetPlayerServerId(i)
						local ped = GetPlayerPed(i)
						local currentVeh = GetVehiclePedIsIn(ped)

						if InfoSaved[id] ~= nil then
							if currentVeh ~= 0 then
								if GetPedInVehicleSeat(currentVeh, -1) == ped then
									local vehSpeed = GetEntitySpeed(currentVeh)
									local speed = math.ceil(vehSpeed * 3.6)
									DrawESP(vector3(x, y, z), 1.0, "~r~∑".. InfoSaved[id].group .. " ~s~[" .. InfoSaved[id].job .. "~s~/" .. InfoSaved[id].job2 .. "~s~] [" .. id .. "] " .. InfoSaved[id].name .. " [" .. dist .. "m] [" .. InfoSaved[id].ping .. "ms] [" .. speed .."Km/h]")
								else
									DrawESP(vector3(x, y, z), 1.0, InfoSaved[id].group .. " [" .. InfoSaved[id].job .. "~s~/" .. InfoSaved[id].job2 .. "~s~] [" .. id .. "] " .. InfoSaved[id].name .. " [" .. dist .. "m] [" .. InfoSaved[id].ping .. "ms]")
								end
							else
								DrawESP(vector3(x, y, z), 1.0, InfoSaved[id].group .. " [" .. InfoSaved[id].job .. "~s~/" .. InfoSaved[id].job2 .. "~s~] [" .. id .. "] " .. InfoSaved[id].name .. " [" .. dist .. "m] [" .. InfoSaved[id].ping .. "ms]")
							end
						else
							DrawESP(vector3(x, y, z), 1.0, "[" .. id .. "] " .. GetPlayerName(i) .. " [" .. dist .. "m]")
						end
					end
				end
			end
		end
	elseif #EnableShowId > 0 then
		while #EnableShowId > 0 do
			Citizen.Wait(5)
			for _, i in pairs(EnableShowId) do
				local playerped = GetPlayerPed(i.player)
				if IsEntityVisible(playerped) then
					local pos = GetEntityCoords(playerped, true)
					if GetDistanceBetweenCoords(GetGameplayCamCoords(), pos, 1) <= 6.0 then
						DrawESP(pos, 0.5, i.label)
					end
				end
			end
		end
	end
end

RegisterNetEvent('esx_showname:Enable')
AddEventHandler('esx_showname:Enable', function(isSpecialAllowed)
	TriggerServerEvent('CoreLog:SendDiscordLog', 'Afficher / Cacher Noms', GetPlayerName(playerID) .. " a afficher les noms.", 'Green')
	if isZeus() or isSpecialAllowed then
		CheckNameJob()
		toogle = true
		showid()
	end
end)

RegisterNetEvent('esx_showname:Disable')
AddEventHandler('esx_showname:Disable', function()
	if toogle then
		TriggerServerEvent('CoreLog:SendDiscordLog', 'Afficher / Cacher Noms', GetPlayerName(playerID) .. " a **arrêter** d'afficher les noms.", 'Orange')
	end
    toogle = false
	BlipPlayer(toogle)
end)

RegisterNetEvent('esx_showid')
AddEventHandler('esx_showid', function(show)
	if show then
		EnableShowId = show
		showid()
	else
		EnableShowId = {}
	end
end)


local function Text(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(true)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.50, 0.001)
end

local function ShowCoords()
	if showcoord then
		while showcoord do
			Citizen.Wait(5)
			Text("~r~X~s~: " .. coords.x.. " ~b~Y~s~: " .. coords.y .." ~g~Z~s~: " ..coords.z.." ~y~Angle~s~: " .. GetEntityHeading(playerPed) .. "")
			Text("~n~~p~Rot~s~: " .. GetEntityRotation(playerPed) .. "")
		end
	end
end

function ShowCoordsMod()
	showcoord = not showcoord
	ShowCoords()
end

--ShowName Modération
function ShowNameMod()
	if not toogle then
		TriggerEvent('esx_showname:Enable')
	else
		TriggerEvent('esx_showname:Disable')
	end
end


-- blip minimap
function BlipPlayer(blipsActive)
	if blipsActive then
		DisplayRadar(true)
		for _, player in pairs(GetActivePlayers()) do
			if player ~= PlayerId() then
				local ped = GetPlayerPed(player)
				local blip = GetBlipFromEntity( ped )
				if not DoesBlipExist( blip ) then
					blip = AddBlipForEntity(ped)
					SetBlipCategory(blip, 7)
					SetBlipScale( blip,  0.85 )
					ShowHeadingIndicatorOnBlip(blip, true)
					SetBlipSprite(blip, 1)
					SetBlipColour(blip, 0)
				end

				SetBlipNameToPlayerName(blip, player)

				local veh = GetVehiclePedIsIn(ped, false)
				local blipSprite = GetBlipSprite(blip)

				if IsEntityDead(ped) then
					if blipSprite ~= 303 then
						SetBlipSprite( blip, 303 )
						SetBlipColour(blip, 1)
						ShowHeadingIndicatorOnBlip( blip, false )
					end
				elseif veh ~= nil then
					if IsPedInAnyBoat( ped ) then
						if blipSprite ~= 427 then
							SetBlipSprite( blip, 427 )
							SetBlipColour(blip, 0)
							ShowHeadingIndicatorOnBlip( blip, false )
						end
					elseif IsPedInAnyHeli( ped ) then
						if blipSprite ~= 43 then
							SetBlipSprite( blip, 43 )
							SetBlipColour(blip, 0)
							ShowHeadingIndicatorOnBlip( blip, false )
						end
					elseif IsPedInAnyPlane( ped ) then
						if blipSprite ~= 423 then
							SetBlipSprite( blip, 423 )
							SetBlipColour(blip, 0)
							ShowHeadingIndicatorOnBlip( blip, false )
						end
					elseif IsPedInAnyPoliceVehicle( ped ) then
						if blipSprite ~= 137 then
							SetBlipSprite( blip, 137 )
							SetBlipColour(blip, 0)
							ShowHeadingIndicatorOnBlip( blip, false )
						end
					elseif IsPedInAnySub( ped ) then
						if blipSprite ~= 308 then
							SetBlipSprite( blip, 308 )
							SetBlipColour(blip, 0)
							ShowHeadingIndicatorOnBlip( blip, false )
						end
					elseif IsPedInAnyVehicle( ped ) then
						if blipSprite ~= 225 then
							SetBlipSprite( blip, 225 )
							SetBlipColour(blip, 0)
							ShowHeadingIndicatorOnBlip( blip, false )
						end
					else
						if blipSprite ~= 1 then
							SetBlipSprite(blip, 1)
							SetBlipColour(blip, 0)
							ShowHeadingIndicatorOnBlip( blip, true )
						end
					end
				else
					if blipSprite ~= 1 then
						SetBlipSprite( blip, 1 )
						SetBlipColour(blip, 0)
						ShowHeadingIndicatorOnBlip( blip, true )
					end
				end
				if veh then
					SetBlipRotation( blip, math.ceil( GetEntityHeading( veh ) ) )
				else
					SetBlipRotation( blip, math.ceil( GetEntityHeading( ped ) ) )
				end
			end
		end
	else
		for _, player in pairs(GetActivePlayers()) do
			local blip = GetBlipFromEntity( GetPlayerPed(player) )
			if blip ~= nil then
				RemoveBlip(blip)
			end
		end
	end
end