Core.Main = {}
Core.Object = {}
Core.Weapon = {}
Core.Player = {}
Core.Pos = {}

Core.Sim = {}

AddEventHandler("playerSpawned", function()
    playerPed = GetPlayerPed(-1)
  
    -- Enable pvp
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(playerPed, true, true)
end)

--Calcul le temps à l'heure française
Core.Main.CalculateDateTime = function()
-- function CalculateDateTime()
    local y, m, d, h, min, s = GetLocalTime()
    h = h
    if h >= 24 then
        h = h - 24
        if d < 31 then
            d = d + 1
        else
            d = 01
        end
    end

    return y, m, d, h, min, s
end

--AddTextEntry
Core.Main.AddTextEntry = function(key, value)
-- function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

--Notification au dessus map
Core.Main.ShowNotification = function(msg, flash, saveToBrief, hudColorIndex)
-- function ShowNotification(msg, flash, saveToBrief, hudColorIndex)
	SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    
    if hudColorIndex then
        ThefeedNextPostBackgroundColor(hudColorIndex)
    end

    DrawNotification(flash, saveToBrief)
end

--Core PedMugShot
Core.Main.GetPedMugShot = function(ped)
-- function GetPedMugShot(ped)
	local mugshot = RegisterPedheadshot(ped)

	while not IsPedheadshotReady(mugshot) do
		Citizen.Wait(0)
	end

	return mugshot, GetPedheadshotTxdString(mugshot)
end

--Notification au dessus map avec image
Core.Main.ShowAdvancedNotification = function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
-- function ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
    local mugshot, mugshotStr = Core.Main.GetPedMugShot(playerPed)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(msg)
  
    if hudColorIndex then
      ThefeedNextPostBackgroundColor(hudColorIndex)
    end
  
    EndTextCommandThefeedPostMessagetext(textureDict or mugshotStr, textureDict or mugshotStr, false, iconType, sender, subject)
    EndTextCommandThefeedPostTicker(flash or false, saveToBrief or saveToBrief == nil and true)
    UnregisterPedheadshot(mugshot)
end

--ShowHelpNotification En haut à gauche
Core.Main.ShowHelpNotification = function(msg, thisFrame, beep, duration)
-- function ShowHelpNotification(msg, thisFrame, beep, duration)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
  
    if thisFrame then
        DisplayHelpTextThisFrame(msg, false)
    else
        EndTextCommandDisplayHelp(0, false, beep == nil and true or beep, duration or -1)
    end
end

--Charger Anim Dict
Core.Object.ChargeAnimDict = function(animDict)
-- function ChargeAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        RequestAnimDict(animDict)
        Citizen.Wait(1) 
    end
end

--Charger Anim Set
Core.Object.ChargeAnimSet = function(animDict)
-- function ChargeAnimSet(animDict)
    while not HasAnimSetLoaded(animDict) do 
        RequestAnimSet(animDict)
        Citizen.Wait(1)
    end 
end

--Charger anim ou vehicle ou object
Core.Object.ChargerModel = function(hash)
-- function ChargerModel(hash)
    hash = (type(hash) == 'number' and hash or GetHashKey(hash))

    while not HasModelLoaded(hash) do
        Citizen.Wait(1)
        RequestModel(hash)
    end
end

--Charge Particule
Core.Object.ChargePtfxAsset = function(particleDict)
-- function ChargePtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        RequestNamedPtfxAsset(particleDict)
        Citizen.Wait(1)
    end
end

--CanUseWeapon 
Core.Weapon.CanUseWeapon = function(CurrentWeapon, Weapons)
-- function CanUseWeapon(CurrentWeapon, Weapons)
    if type(Weapons) == "table" then
        for k, v in pairs(Weapons) do
            if CurrentWeapon == ((type(v) == "string" and GetHashKey(v)) or v) then
                return true
            end
        end
    elseif type(Weapons) == "string" and Weapons == GetHashKey(v) then
        return true
    end

    return false
end

--GetPlayers
Core.Player.GetPlayers = function()
-- function GetPlayers()
	local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		if DoesEntityExist(GetPlayerPed(player)) then
			table.insert(players, player)
		end
	end

	return players
end

--Zone Safe
Core.Weapon.ZoneSafe = function(IsEnable)
-- function ZoneSafe(IsEnable)
    if IsEnable then
        --NetworkSetFriendlyFireOption(false)
        SetCurrentPedWeapon(playerPed, -1569615261, true)
        DisableControlAction(2, 37, true)
        DisablePlayerFiring(playerPed, true)
        DisableControlAction(0, 106, true)
    -- else
    --     NetworkSetFriendlyFireOption(true)
    end
end

--draw3dtext
Core.Main.DrawText3D = function(pos, text, size)
-- function DrawText3D(pos, text, size)
    local onScreen, x, y = World3dToScreen2d(pos.x, pos.y, pos.z)
	local scale = ((size == nil and 1 or size / GetDistanceBetweenCoords(GetGameplayCamCoords(), pos.x, pos.y, pos.z, true)) * 2) * ((1 / GetGameplayCamFov()) * 100)

    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(x, y)
end

--DrawText3ds
Core.Main.DrawText3Ds = function(x, y, z, text)
-- function DrawText3Ds(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + (#text / 370), 0.03, 0, 0, 0, 120)
end

--Notif milieu ecran
Core.Main.MessageMilieu = function(titre, message, time)
-- function MessageMilieu(titre, message, time)
    scaleform = RequestScaleformMovie("mp_big_message_freemode")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    PushScaleformMovieFunctionParameterString(titre)
    PushScaleformMovieFunctionParameterString(message)
    PopScaleformMovieFunctionVoid()
    while time ~= 0 do
        time = time - 1
        Citizen.Wait(1)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end
end

--Draw Rectangle Mid haut écran
Core.Main.DrawRectangleAnnounce = function(x, y, w, h, sc, text, r, g, b, a, font, jus, timer)
-- function DrawRectangleAnnounce(x, y, w, h, sc, text, r, g, b, a, font, jus, timer)
    while timer ~= 0 do
        DrawRect(0.494, 0.15, 5.185, 0.06, 0, 0, 0, 75)
        SetTextFont(font)
        SetTextProportional(0)
        SetTextScale(sc, sc)
        SetTextJustification(jus)
        SetTextColour(r, g, b, a)
        SetTextDropShadow(0, 0, 0, 0,255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(x - 0.1+w, y - 0.02+h)

        timer = timer - 1
        Citizen.Wait(1)
    end
end

--cam coords
Core.Main.Polar3DToWorld3D = function(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)
-- function polar3DToWorld3D(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)
	local polarAngleRad   = polarAngleDeg   * math.pi / 180.0
	local azimuthAngleRad = azimuthAngleDeg * math.pi / 180.0
    
	return vector3(entityPosition.x + radius * (math.sin(azimuthAngleRad) * math.cos(polarAngleRad)), entityPosition.y - radius * (math.sin(azimuthAngleRad) * math.sin(polarAngleRad)), entityPosition.z - radius * math.cos(azimuthAngleRad))
end

Core.Pos.DistanceBetweenCoords = function(coordsA, coordsB)
-- function DistanceBetweenCoords(coordsA, coordsB)
	return #(vector3(coordsA.x, coordsA.y, coordsA.z).xy - vector3(coordsB.x, coordsB.y, coordsB.z).xy)
end

--Progress Bar
Core.Main.DrawBar = function(IsProgressBar, time, text, cb, options)
-- function drawBar(IsProgressBar, time, text, cb, options)
	SendNUIMessage({
        IsProgressBar = IsProgressBar,
		time = time,
		text = text,
		options = options
	})
	if cb then
		Citizen.SetTimeout(time + 100, cb)
	end
end

--GetClosestPlayer
Core.Player.GetClosestPlayer = function(distance)
-- function GetClosestPlayer(distance)
    for k, v in pairs(Core.Player.GetPlayers()) do
        local target = GetPlayerPed(v)

        if target ~= playerPed and GetDistanceBetweenCoords(GetEntityCoords(target), GetEntityCoords(PlayerPedId())) <= distance and IsEntityVisible(target) then
            return v
        end
    end

    return -1
end

-- Zone de Texte
Core.Main.EnterZoneText = function(TextEntry, ExampleText, MaxStringLenght)
    -- function EnterZoneText(TextEntry, ExampleText, MaxStringLenght)
	-- TextEntry		-->	The Text above the typing field in the black square
	-- ExampleText		-->	An Example Text, what it should say in the typing field
	-- MaxStringLenght	-->	Maximum String Lenght
    AddTextEntry('FMMC_KEY_TIP10', TextEntry) --Sets the Text above the typing field in the black square
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP10", "", ExampleText, "", "", "", MaxStringLenght) --Actually calls the Keyboard Input

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do --While typing is not aborted and not finished, this loop waits
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() --Gets the result of the typing
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		return result --Returns the result
	else
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		return nil --Returns nil if the typing got aborted
	end
end

Core.Sim.CheckSimData = function(number)
    TriggerServerCallback('esx_prefecture:StealSimData', function(find, phoneData)
		if (find) then

            local simMenu = RageUI.CreateMenu("Sim numéro " .. number, "Que veux tu chercher ?", nil, nil, nil, nil, nil, 0, 0, 0, 155)
            local messageMenu = RageUI.CreateSubMenu(simMenu, "Messages", "Choisi la conversation à afficher", nil, nil, nil, nil, nil, 0, 0, 0, 155)
            local messageSelectMenu = RageUI.CreateSubMenu(messageMenu, "Messages", "Voici les messages", nil, nil, nil, nil, nil, 0, 0, 0, 155)
            local contactMenu = RageUI.CreateSubMenu(simMenu, "Contacts", "Voici tous les contacts de la sim", nil, nil, nil, nil, nil, 0, 0, 0, 155)
            local callMenu = RageUI.CreateSubMenu(simMenu, "Journal d'appel", "Voici tous les appelles de la sim", nil, nil, nil, nil, nil, 0, 0, 0, 155)

            -- Add contact name from message
            local messageGroup = { }
            if phoneData.messages then
                for key, value in pairs(phoneData.messages) do
                    local contact = phoneData.contacts[key]
                    local contactName = key
    
                    if contact ~= nil and contact.name ~= '' then
                        contactName = contact.name .. ' - ' .. contact.number
                    end
    
                    if messageGroup[key] == nil then
                        messageGroup[key] = { name = contactName, number = key, messages = value }
                    end
                end
            end

            -- Add contact name from call
            if phoneData.calls then
                for _, value in pairs(phoneData.calls) do
                    value.incomming = value.to == number
    
                    local num = nil
                    if value.incomming then
                        num = value.from
                    else
                        num = value.to
                    end
    
                    local contact = phoneData.contacts[num]
                    local contactName = num
    
                    if contact ~= nil and contact.name ~= '' then
                        contactName = contact.name .. ' - ' .. contact.number
                    end
                    value.contactName = contactName                
                end
            end            

            local tempTable = { }
            local index = 1
            for key, value in pairs(messageGroup) do
                if index > 1 then
                    local position, findPosition = 1, false

                    while position < #tempTable + 1  do
                        local currentitem = tempTable[position]
                        if value ~= nil and currentitem ~= nil then
                            if string.lower(currentitem.name) > string.lower(value.name) then
                                table.insert(tempTable, position, { name = value.name, number = key, messages = value.messages })
                                findPosition = true
                                break
                            end
                            position = position + 1
                        end
                    end
                    if not findPosition then
                        table.insert(tempTable, position, { name = value.name, number = key, messages = value.messages })
                    end
                else
                    table.insert(tempTable, { name = value.name, number = key, messages = value.messages })
                end
                index = index + 1
            end   

            local messageSelected = { }
            
            RageUI.Visible(simMenu, not RageUI.Visible(simMenu))

            while simMenu do
                RageUI.IsVisible(simMenu, function()
                    RageUI.Button("Messages", "Afficher les messages de la sim", { RightLabel = "💬" }, true, {}, messageMenu)
                    RageUI.Button("Contacts", "Afficher les contacts de la sim", { RightLabel = "📱" }, true, {}, contactMenu)
                    RageUI.Button("Journal d'appel", "Afficher le journal d'appel de la sim", { RightLabel = "📞" }, true, {}, callMenu)
                    RageUI.Button("Quitter", "Appuie sur ~y~entrer~w~ pour partir.", {RightLabel = "→→→", Color = {BackgroundColor = RageUI.ItemsColour.Red}}, true, {
                        onSelected = function()
                                RageUI.GoBack()
                            end
                    }, nil)
                end)

                RageUI.IsVisible(messageMenu, function()
                    RageUI.Button("Retour", "Appuie sur ~y~entrer~w~ pour revenir au menu.", {RightLabel = "→→→"}, true, {
                        onSelected = function()
                            RageUI.GoBack()
                        end
                    }, simMenu)

                    for key, value in pairs(tempTable) do
                        RageUI.Button(value.name, nil, {}, true, {
                            onSelected = function()
                                messageSelectMenu:SetSubtitle('Voici les messages de ' .. value.name)
                                messageSelected = value.messages
                            end
                        }, messageSelectMenu)                        
                    end                   
                end)

                RageUI.IsVisible(messageSelectMenu, function()
                    RageUI.Button("Retour", "Appuie sur ~y~entrer~w~ pour revenir au menu.", {RightLabel = "→→→"}, true, {
                        onSelected = function()
                            RageUI.GoBack()
                        end
                    }, messageMenu)

                    for _, value in pairs(messageSelected) do
                        local from = 'Reçus le : '
                         if value.from == number then
                            from = 'Envoyé le : '
                         end

                         local gpsPosBegin, gpsPosEnd, _ = string.find(value.message, "(GPS:", 1, true)
                         local rightLabel = ''

                         if (gpsPosBegin ~= nil and gpsPosEnd ~= nil) or value.image ~= nil then
                            rightLabel = '→→→'
                         end

                         if value.message == '' and value.image ~= nil then
                            value.message = 'Appuyez sur ~y~entrer~w~ pour afficher l\'image'
                         end

                        RageUI.Button(from .. value.time, value.message, { RightLabel = rightLabel } , true, {
                            onSelected = function()
                                local message = value.message
                                if (message ~= nil) then
                                    local beginGps, endGps, _ = string.find(message, "(GPS:", 1, true)
                                    if beginGps ~= nil and endGps ~= nil then
                                        local beginGpsString = string.sub(message, endGps + 1, #message)
                                        local beginLastParentesis, lastLastParentesis, __ = string.find(beginGpsString, ')', 1, true)
                                        if beginLastParentesis ~= nil and lastLastParentesis ~= nil then
                                            local endString = string.sub(beginGpsString, 1, lastLastParentesis - 1)
                                            local h, i, j = string.find(endString, ',', 1, true)
                                            if string.len(endString) > 3 then
                                                local xLocation = string.sub(endString, 1, h-1)
                                                local yLocation = string.sub(endString, h + 1, #endString)
                                                SetNewWaypoint(tonumber(xLocation), tonumber(yLocation))
                                                TriggerEvent('Core:ShowAdvancedNotification', 'Cracking Sim', "Position", "La position a été mise sur ton GPS de téléphone.", 'CHAR_LESTER_DEATHWISH', 7, false, false, 140)
                                            end
                                        end
                                    end                                    
                                end
                                if value.image ~= nil then
                                    SendNUIMessage({
                                        srcImage   = value.image
                                    })
                                    local imgDisplay = true
                                    while imgDisplay do
                                        Citizen.Wait(5)
                                        if IsControlJustPressed(1, 177) then
                                            SendNUIMessage({
                                                srcImage   = ''
                                            })
                                            imgDisplay = false
                                        end
                                    end
                                end
                            end
                        }, nil)
                    end
                end)

                RageUI.IsVisible(contactMenu, function()
                    RageUI.Button("Retour", "Appuie sur ~y~entrer~w~ pour revenir au menu.", {RightLabel = "→→→"}, true, {
                        onSelected = function()
                            RageUI.GoBack()
                        end
                    }, simMenu)

                    if phoneData.contacts then
                        for _, value in pairs(phoneData.contacts) do
                            RageUI.Button(value.name .. " - " .. value.number, nil, {} , true, {}, nil)                        
                        end
                    end
                end)

                RageUI.IsVisible(callMenu, function()
                    RageUI.Button("Retour", "Appuie sur ~y~entrer~w~ pour revenir au menu.", {RightLabel = "→→→"}, true, {
                        onSelected = function()
                            RageUI.GoBack()
                        end
                    }, simMenu)
                    if phoneData.calls then
                        for _, value in pairs(phoneData.calls) do
                            local title, icon = 'Sortant : ', '📱'
                            if value.incomming == true then
                                 title = 'Entrant : '
                                 icon = '📲'
                             end
                            RageUI.Button(title .. value.contactName, 'Le : ' .. value.time .. '~n~Durée : ' .. value.length .. ' secondes' , {  RightLabel = icon } , true, {}, nil)                        
                        end
                    end
                end)
			    Citizen.Wait(3)
            end
		else
            Core.Main.ShowNotification("La sim ~b~" .. number .."~w~ ne contient aucune donnée ou est introuvable")
		end
	end, number)
end