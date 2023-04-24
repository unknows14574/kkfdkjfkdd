local InSpectatorMode	= false
local TargetSpectate	= nil
local LastPositionSpectate		= nil
local polarAngleDeg		= 0;
local azimuthAngleDeg	= 90;
local radius			= -3.5;
local cam 				= nil

local function OpenAdminActionMenu(targetPed, data)
	local jobLabel    = nil
	local jobLabel2    = nil
	local sexLabel    = nil
	local sex         = nil
	local dobLabel    = nil
	local heightLabel = nil
	local idLabel     = nil
	local Money		= 0
	local Bank		= 0
	local blackMoney	= 0
	local Inventory	= nil
	
	for i=1, #data.accounts, 1 do
		if data.accounts[i].name == 'black_money' then
			blackMoney = data.accounts[i].money
		end
	end

	local jobservice, jobservice2 = "Hors Service", "Hors Service"
	if data.job.service == 1 then
		jobservice = "En Service"
	end
	if data.job2.service == 1 then
		jobservice2 = "En Service"
	end

	if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
		jobLabel =  jobservice .. ' Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
	else
		jobLabel =  jobservice .. ' Job : ' .. data.job.label
	end
	
	if data.job2.grade_label ~= nil and  data.job2.grade_label ~= '' then
		jobLabel2 = jobservice2 .. ' Job2 : ' .. data.job2.label .. ' - ' .. data.job2.grade_label
	else
		jobLabel2 =  jobservice2 .. ' Job2 : ' .. data.job2.label
	end

	if data.sex ~= nil then
		if (data.sex == 'm') or (data.sex == 'M') then
			sex = 'Male'
		else
			sex = 'Female'
		end
		sexLabel = 'Sex : ' .. sex
	else
		sexLabel = 'Sex : Unknown'
	end
	
	if data.money ~= nil then
		Money = data.money
	else
		Money = 'No Data'
	end

	if data.bank ~= nil then
		Bank = data.bank
	else
		Bank = 'No Data'
	end
	
	if data.dob ~= nil then
		dobLabel = 'DOB : ' .. data.dob
	else
		dobLabel = 'DOB : Unknown'
	end

	if data.height ~= nil then
		heightLabel = 'Height : ' .. data.height
	else
		heightLabel = 'Height : Unknown'
	end

	if data.name ~= nil then
		idLabel = 'Steam ID : ' .. data.name
	else
		idLabel = 'Steam ID : Unknown'
	end
	
	local elements = {
		{label = 'Name: ' .. data.firstname .. " " .. data.lastname, value = nil},
		{label = 'Money: '.. data.money, value = nil},
		{label = 'Bank: '.. data.bank, value = nil},
		{label = 'Black Money: '.. blackMoney, value = nil, itemType = 'item_account', amount = blackMoney},
		{label = jobLabel,    value = nil},
		{label = jobLabel2,    value = nil},
		{label = idLabel,     value = nil},
	}

	table.insert(elements, {label = '--- Inventory ---', value = nil})

	for i=1, #data.inventory, 1 do
		if data.inventory[i].count > 0 then
			table.insert(elements, {label          = data.inventory[i].label .. ' x ' .. data.inventory[i].count,
									value          = nil,
									itemType       = 'item_standard',
									amount         = data.inventory[i].count,
								})
		end
	end

	table.insert(elements, {label = '--- Weapons ---', value = nil})

	for i=1, #data.weapons, 1 do
		table.insert(elements, {label = ESX.GetWeaponLabel(data.weapons[i].name),
								value          = nil,
								itemType       = 'item_weapon',
								amount         = data.ammo,
								})
	end
	if data.licenses ~= nil then
		table.insert(elements, {label = '--- Licenses ---', value = nil})

		for i=1, #data.licenses, 1 do
			table.insert(elements, {label = data.licenses[i].label, value = nil})
		end
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'citizen_interaction',
		{
		title    = 'Player Control',
		align = 'right',
		elements = elements,
		},
		function(data, menu)

		end,
	function(data, menu)
		menu.close()
	end)
	while InSpectatorMode do
		Citizen.Wait(0)
		local text = {}
		local targetGod = GetPlayerInvincible(targetPed)
		if targetGod then
			table.insert(text,"Godmode: ~r~Found~w~")
		else
			table.insert(text,"Godmode: ~g~Not Found~w~")
		end
		if not CanPedRagdoll(targetPed) and not IsPedInAnyVehicle(targetPed, false) and (GetPedParachuteState(targetPed) == -1 or GetPedParachuteState(targetPed) == 0) and not IsPedInParachuteFreeFall(targetPed) then
			table.insert(text,"~r~Anti-Ragdoll~w~")
		end
		table.insert(text,"Health"..": "..GetEntityHealth(targetPed).."/"..GetEntityMaxHealth(targetPed))
		table.insert(text,"Armor"..": "..GetPedArmour(targetPed))

		for i,theText in pairs(text) do
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.30)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString(theText)
			EndTextCommandDisplayText(0.3, 0.7+(i/30))
		end
	end
end

local function resetspectate()
	local playerPed = GetPlayerPed(-1)
	InSpectatorMode = false
	TargetSpectate  = nil

	Citizen.Wait(400)

	DetachEntity(playerPed, true, true)
	SetEntityVisible(playerPed, true)
	SetEntityCollision(playerPed, true, true)
	SetEntityInvincible(playerPed, false)
	SetEveryoneIgnorePlayer(playerPed, false)
	NetworkSetEntityInvisibleToNetwork(playerPed, false)

	SetCamActive(cam,  false)
	RenderScriptCams(false, false, 0, true, true)

	SetEntityCoords(playerPed, LastPositionSpectate.x, LastPositionSpectate.y, LastPositionSpectate.z-0.98)
end

local function spectate(target)
	TriggerServerCallback('Core:getOtherPlayerData', function(player)
	
		if player ~= nil then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Mode spectateur', GetPlayerName(playerID) .. " a regardé **".. player.firstname .. " ".. player.lastname .. " [".. player.name .."]**", 'Purple', target)
			SetEntityVisible(playerPed, false)
			SetEveryoneIgnorePlayer(playerPed, true)
			SetEntityInvincible(playerPed, true)
			NetworkSetEntityInvisibleToNetwork(playerPed, true)

			SetEntityCoords(playerPed, player.coords.x, player.coords.y, player.coords.z - 1.0)
			
			Wait(800)

			if not DoesCamExist(cam) then
				cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
			end

			SetCamActive(cam, true)
			RenderScriptCams(true, false, 0, true, true)

			InSpectatorMode = true
			TargetSpectate  = target

			local targetPed	= GetPlayerPed(GetPlayerFromServerId(TargetSpectate))
			-- Bone index main : 28422
			-- Bone index au pied : 0x3779
			if playerPed == targetPed then -- Sécurité car si le modo se spec lui même, il crash. 
				resetspectate()
			else
				AttachEntityToEntity(playerPed, targetPed, GetPedBoneIndex(targetPed,  0x3779), 0, 0, 0, 0, 0, 0, false, false, false, false, 2, true)
			end

			while InSpectatorMode do
				Citizen.Wait(0)
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 25, true)
				DisableControlAction(0, 37, true)
				DisableControlAction(0, 140, true)

				for _, player in ipairs(GetActivePlayers()) do
					SetEntityNoCollisionEntity(playerPed, GetPlayerPed(player), true)
				end

				if IsControlPressed(2, 241) then
					radius = radius + 2.0
				elseif IsControlPressed(2, 242) then
					radius = radius - 2.0
				elseif IsControlPressed(2, 311) then
					OpenAdminActionMenu(targetPed, player)
				end

				if radius > -1 then
					radius = -1
				end

				polarAngleDeg = polarAngleDeg + GetDisabledControlNormal(0, 1) * 10;

				if polarAngleDeg >= 360 then
					polarAngleDeg = 0
				end

				azimuthAngleDeg = azimuthAngleDeg + GetDisabledControlNormal(0, 2) * 10;

				if azimuthAngleDeg >= 360 then
					azimuthAngleDeg = 0
				end

				--local coordsTarget = GetEntityCoords(targetPed)
				--SetEntityCollision(playerPed, false, false)
				SetEveryoneIgnorePlayer(playerPed, true)
				-- SetEntityVisible(playerPed, false)
				SetCamCoord(cam, Core.Main.Polar3DToWorld3D(GetEntityCoords(targetPed), radius, polarAngleDeg, azimuthAngleDeg))
				PointCamAtEntity(cam, targetPed)
				--SetEntityCoords(playerPed, coordsTarget.x, coordsTarget.y, coordsTarget.z -1.50)
			end
		else
			resetspectate()
		end
	end, target)
end

local function spectateTarget(playerTarget)
	local target = playerTarget
	local playerPed = PlayerPedId()
	if playerTarget == GetPlayerServerId(PlayerId()) then
		resetspectate()
		return
	end

	local playerId = PlayerId()

	ESX.TriggerServerCallback('Core:moderation:GetPlayerData', function(targetPlayerInfo)
		if targetPlayerInfo ~= nil then
			TriggerServerEvent('CoreLog:SendDiscordLog', 'Mode spectateur', GetPlayerName(playerId) .. " a regardé **".. targetPlayerInfo.firstname .. " ".. targetPlayerInfo.lastname .. " [".. targetPlayerInfo.name .."]**", 'Purple', playerTarget)

			SetEntityVisible(playerPed, false)
			SetEveryoneIgnorePlayer(playerPed, true)
			SetEntityInvincible(playerPed, true)
			NetworkSetEntityInvisibleToNetwork(playerPed, true)

			TargetSpectate  = target

			SetEntityCoords(playerPed, targetPlayerInfo.coord.x, targetPlayerInfo.coord.y, targetPlayerInfo.coord.z)
			
			Wait(800)

			if not DoesCamExist(cam) then
				cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
			end

			SetCamActive(cam, true)
			RenderScriptCams(true, false, 0, true, true)

			InSpectatorMode = true

			local targetPed	= GetPlayerPed(GetPlayerFromServerId(TargetSpectate))
			-- Bone index main : 28422
			-- Bone index au pied : 0x3779
			if playerPed == targetPed then -- Sécurité car si le modo se spec lui même, il crash. 
				resetspectate()
			else
				AttachEntityToEntity(playerPed, targetPed, GetPedBoneIndex(targetPed,  0x3779), 0, 0, 0, 0, 0, 0, false, false, false, false, 2, true)
			end

			while InSpectatorMode do
				Citizen.Wait(0)
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 25, true)
				DisableControlAction(0, 37, true)
				DisableControlAction(0, 140, true)

				for _, player in ipairs(GetActivePlayers()) do
					SetEntityNoCollisionEntity(playerPed, GetPlayerPed(player), true)
				end

				if IsControlPressed(2, 241) then
					radius = radius + 2.0
				elseif IsControlPressed(2, 242) then
					radius = radius - 2.0				
				end

				if radius > -1 then
					radius = -1
				end

				polarAngleDeg = polarAngleDeg + GetDisabledControlNormal(0, 1) * 10;

				if polarAngleDeg >= 360 then
					polarAngleDeg = 0
				end

				azimuthAngleDeg = azimuthAngleDeg + GetDisabledControlNormal(0, 2) * 10;

				if azimuthAngleDeg >= 360 then
					azimuthAngleDeg = 0
				end

				SetEveryoneIgnorePlayer(playerPed, true)
				SetCamCoord(cam, Core.Main.Polar3DToWorld3D(GetEntityCoords(targetPed), radius, polarAngleDeg, azimuthAngleDeg))
				PointCamAtEntity(cam, targetPed)
			end
		else
			resetspectate()
		end
	end, playerTarget)
end

RegisterNetEvent('Core:moderation:spectate')
AddEventHandler('Core:moderation:spectate', function(playerTarget)
	print('enter', playerTarget)
	if InSpectatorMode and TargetSpectate then
		resetspectate()
	else
		local player = GetPlayerPed(-1)
		local playerCoords = GetEntityCoords(player)
		LastPositionSpectate = playerCoords
	end
	spectateTarget(playerTarget)
end)


RegisterNetEvent('esx_spectate:command')
AddEventHandler('esx_spectate:command', function(target)
	if InSpectatorMode then
		resetspectate()
	else
		LastPositionSpectate = coords
		spectate(target)
	end
end)

RegisterNetEvent('esx_spectate:iSpec')
AddEventHandler('esx_spectate:iSpec', function(target)
	if InSpectatorMode and TargetSpectate then
		resetspectate()
	else
		LastPositionSpectate = coords
	end
	spectate(target)
end)

RegisterNetEvent('esx_spectate:iReset')
AddEventHandler('esx_spectate:iReset', function(target)
	resetspectate()
end)

