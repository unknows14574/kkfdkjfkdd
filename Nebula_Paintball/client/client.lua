ESX = nil
local playingPaintball = false
local queuing = false
local queueText = ''
local matchends = ''
local kills = 0
local deaths = 0
local teamMode = false


RegisterNetEvent('loaf_paintball:queueInfo')
AddEventHandler('loaf_paintball:queueInfo', function(text, other)
    queueText = text
    matchends = other
end)

RegisterNetEvent('loaf_paintball:hudNotify')
AddEventHandler('loaf_paintball:hudNotify', function(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(text)
      ESX.ShowNotification(false, true)
end)

RegisterNetEvent('loaf_paintball:start')
AddEventHandler('loaf_paintball:start', function()
    queuing = false
    playingPaintball = true
    deaths = 0
    kills = 0

    if Config.Clothes.ChangeClothes then
        TriggerEvent('skinchanger:loadSkin', Config.Clothes.Outfits[math.random(1, #Config.Clothes.Outfits)])
    end


    local spawnPoint = Config.SpawnPoints[math.random(1, #Config.SpawnPoints)]
    SetEntityCoords(PlayerPedId(), spawnPoint)
end)

RegisterNetEvent('loaf_paintball:stop')
AddEventHandler('loaf_paintball:stop', function()
    playingPaintball = false
    SetPedInfiniteAmmo(PlayerPedId(), false, GetHashKey(Config.Weapon))
    SetEntityInvincible(PlayerPedId(), false)
    SetPlayerInvincible(PlayerId(), false)
    deaths = 0
    kills = 0
    queuing = false
    if Config.Clothes.ChangeClothes then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
    end
end)

RegisterNetEvent('loaf_paintball:matchOver')
AddEventHandler('loaf_paintball:matchOver', function(winner, me)
    if Config.RemoveWeapon then
        RemoveWeaponFromPed(PlayerPedId(), GetHashKey(Config.Weapon))
    end
    playingPaintball = false
    SetPedInfiniteAmmo(PlayerPedId(), false, GetHashKey(Config.Weapon))
    SetEntityInvincible(PlayerPedId(), false)
    SetPlayerInvincible(PlayerId(), false)
    kills = 0
    deaths = 0
    winner = json.decode(winner)
    me = json.decode(me)
    local timer = GetGameTimer() + (Config.DisplayWinner * 1000)
    if GetPlayerFromServerId(winner.id) == PlayerId() then
        SetEntityCoords(PlayerPedId(), Config.WinnerPosition)
        FreezeEntityPosition(PlayerPedId(), true)

        local cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
        SetCamCoord(cam, Config.WinnerCam.x, Config.WinnerCam.y, Config.WinnerCam.z)
        RenderScriptCams(1, 0, 0, 1, 1)
        ClearPedBloodDamage(PlayerPedId())
        while timer >= GetGameTimer() do
            Wait(0)
            SetEntityHeading(PlayerPedId(), Config.WinnerHeading)
            for i = 0, 31 do
                DisableAllControlActions(i)
            end
            PointCamAtEntity(cam, GetPlayerPed(GetPlayerFromServerId(winner.id)), 0.0, 0.0, 0.0, true)
            drawText((Config.Translations['you_won']):format(winner.kills, winner.deaths), 0.015, 0.75)
        end
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cam)
        SetEntityCoords(PlayerPedId(), Config.JoinCircle)
    else
        SetEntityCoords(PlayerPedId(), Config.WinnerPosition)
        local cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
        SetCamCoord(cam, Config.WinnerCam.x, Config.WinnerCam.y, Config.WinnerCam.z)
        RenderScriptCams(1, 0, 0, 1, 1)
        ClearPedBloodDamage(PlayerPedId())
        while timer >= GetGameTimer() do
            Wait(0)
            for i = 0, 31 do
                DisableAllControlActions(i)
            end
            SetEntityVisible(PlayerPedId(), false, false)
            PointCamAtEntity(cam, GetPlayerPed(GetPlayerFromServerId(winner.id)), 0.0, 0.0, 0.0, true)
            drawText((Config.Translations['won']):format(GetPlayerName(GetPlayerFromServerId(winner.id)), winner.kills, winner.deaths, me.kills, me.deaths), 0.015, 0.75)
        end
        SetEntityVisible(PlayerPedId(), true, false)
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cam)
        SetEntityCoords(PlayerPedId(), Config.JoinCircle)
    end
    if Config.Clothes.ChangeClothes then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
    end
    FreezeEntityPosition(PlayerPedId(), false)
end)

RegisterNetEvent('loaf_paintball:died')
AddEventHandler('loaf_paintball:died', function(killedBy)
    deaths = deaths + 1
    local timer = GetGameTimer() + 10000
    SetTimecycleModifier("BlackOut")
    SetEntityHasGravity(PlayerPedId(), false)

    local coordsFrom = GetEntityCoords(PlayerPedId())

    local cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
    SetCamCoord(cam, coordsFrom.x, coordsFrom.y, coordsFrom.z)
    RenderScriptCams(1, 0, 0, 1, 1)

    SetEntityCoords(PlayerPedId(), GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z+5.0)
    Citizen.CreateThread(function()
        while timer >= GetGameTimer() and playingPaintball do
            SetCamFov(cam, GetCamFov(cam) - 0.1)
            Wait(50)
        end
    end)
    while timer >= GetGameTimer() and playingPaintball do
        Wait(0)
        PointCamAtEntity(cam, GetPlayerPed(GetPlayerFromServerId(killedBy)), 0.0, 0.0, 0.0, true)
        SetEntityVisible(PlayerPedId(), false, false)
        for i = 0, 31 do
            DisableAllControlActions(i)
        end
    end
    if playingPaintball then
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cam)
        local spawnPoint = Config.SpawnPoints[math.random(1, #Config.SpawnPoints)]
        SetEntityCoords(PlayerPedId(), spawnPoint)   
     end
    SetEntityVisible(PlayerPedId(), true, false)
    SetEntityHasGravity(PlayerPedId(), true)
    ClearTimecycleModifier()
    ClearPedTasks(PlayerPedId())
    ClearPedBloodDamage(PlayerPedId())
end)

Citizen.CreateThread(function()
    while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
    while not NetworkIsSessionStarted() or ESX.GetPlayerData().job == nil do Wait(0) end

    local blip = AddBlipForCoord(Config.JoinCircle)
    SetBlipSprite(blip, 156)
    SetBlipColour(blip, 40)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Paintball')
    EndTextCommandSetBlipName(blip)

    local gameMode = nil

    while true do
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.JoinCircle, true) <= 25.0 then
            DrawMarker(1, Config.JoinCircle.x, Config.JoinCircle.y, Config.JoinCircle.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 0.1, 50, 255, 50, 150, false, true, 2, false, false, false, false)

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.JoinCircle, true) <= 7.5 then
                if queueText ~= Config.Translations['match_progress'] and not queuing and gameMode == nil then
                    drawText3D(vector3(Config.JoinCircle.x, Config.JoinCircle.y, Config.JoinCircle.z+1.0), "~r~PaintBall~s~ Press ~r~E~s~: Solo Mode ou Team Mode")
                    if IsControlJustReleased(0, 38) then
                        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'team_mode_menu', {
                            title = 'Mode de jeux',
                            align = 'top-left',
                            elements = {
                                {label = 'Solo', value = 'solo'},
                                {label = 'Team', value = 'team'}
                            }
                        }, function(data, menu)
                            if data.current.value == 'solo' then
                                gameMode = 'solo'
                                ESX.ShowNotification("Tu as choisi ~r~ Solo mode.")
                            elseif data.current.value == 'team' then
                                gameMode = 'team'
                                ESX.ShowNotification("Tu as choisi  ~r~ Team mode.")
                            end
                            menu.close()
                        end, function(data, menu)
                            menu.close()
                        end)
                    end
                elseif queueText ~= Config.Translations['match_progress'] then
                    if not queuing then
                        drawText3D(vector3(Config.JoinCircle.x, Config.JoinCircle.y, Config.JoinCircle.z+1.0), (Config.Translations['join_paintball']):format(Config.Price, queueText))
                    else
                        drawText3D(vector3(Config.JoinCircle.x, Config.JoinCircle.y, Config.JoinCircle.z+1.0), (Config.Translations['leave_paintball']):format(queueText))
                    end
                    if IsControlJustReleased(0, 38) then
                        if gameMode ~= nil then
                            queuing = not queuing
                            TriggerServerEvent('loaf_paintball:join', gameMode) -- Passe le mode de jeu choisi
                        else
                            ESX.ShowNotification("Choisis un mode de jeux.")
                        end
                    end
                else
                    drawText3D(vector3(Config.JoinCircle.x, Config.JoinCircle.y, Config.JoinCircle.z+1.0), (Config.Translations['match_in_progress']):format(queueText, matchends))
                end
            else
                -- Réinitialise gameMode lorsque le joueur sort de la zone
                if gameMode ~= nil then
                    gameMode = nil
                end
                if queuing then
                    queuing = false
                    TriggerServerEvent('loaf_paintball:join')
                    Citizen.CreateThread(function()
                        notify(Config.Translations['left_paintball'], 3)
                    end)
                end
            end
        end
        Wait(5)
    end
end)










--[[RegisterCommand('team_mode', function(source, args)
  teamMode = not teamMode
  if teamMode then
    -- Afficher le menu de choix de mode de jeu
    local elements = {
      {label = 'Solo', value = 'solo'},
      {label = 'Equipe', value = 'team'}
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'team_mode_menu', {
      title = 'Choix du mode de jeu',
      align = 'top-left',
      elements = elements
    }, function(data, menu)
      if data.current.value == 'team' then
        -- Ajouter le joueur à une équipe
        AddPlayerToTeam(PlayerId())
      end
      menu.close()
    end, function(data, menu)
      menu.close()
    end)
  else
    -- Terminer le mode en équipe
    -- Code pour terminer le mode en équipe
  end
end, false)]]


-- GetPedLastWeaponImpactCoord(PlayerPedId())
Citizen.CreateThread(function()
    while true do
        local sleep = 250
        if playingPaintball then
            if IsPedShooting(PlayerPedId()) and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(Config.Weapon) then
                local coords = GetEntityCoords(PlayerPedId())
                local coords = GetPedBoneCoords(PlayerPedId(), GetHashKey('SKEL_R_Hand'), 0.0, 0.0, 0.0)
                local x, bulletCoord = GetPedLastWeaponImpactCoord(PlayerPedId())
                if x then
                    local rayHandle = StartShapeTestRay(coords.x, coords.y, coords.z, bulletCoord.x, bulletCoord.y, bulletCoord.z, 10, PlayerPedId(), 0)
                    local _, _, _, _, ped = GetShapeTestResult(rayHandle)
                    if GetEntityType(ped) == 1 then
                        for k, v in pairs(GetActivePlayers()) do
                            if GetPlayerPed(v) == ped then
                                TriggerServerEvent('loaf_paintball:kill', GetPlayerServerId(v))
                                kills = kills + 1
                                Wait(500)
                                break
                            end
                        end
                    end
                end
            end
            sleep = 0
        end
        Wait(sleep)
    end
end)
Citizen.CreateThread(function()
    while true do
        local sleep = 250
        if playingPaintball then
            sleep = 0
            if type(matchends) == 'number' then
                drawText((Config.Translations['match_ends']):format(matchends-Config.DisplayWinner, kills, deaths), 0.015, 0.015)
            else
                drawText((Config.Translations['match_ends']):format(matchends, kills, deaths), 0.015, 0.015)
            end
            if Config.ForceFirstPerson then
                SetFollowPedCamViewMode(4)
            end
            SetEntityInvincible(PlayerPedId(), true)
            SetPlayerInvincible(PlayerId(), true)
            if not HasPedGotWeapon(PlayerPedId(), GetHashKey(Config.Weapon), false) then
                GiveWeaponToPed(PlayerPedId(), GetHashKey(Config.Weapon), 250, false, true)
            end
            SetPedInfiniteAmmo(PlayerPedId(), true, GetHashKey(Config.Weapon))
        else
            if HasPedGotWeapon(PlayerPedId(), GetHashKey(Config.Weapon), false) and Config.RemoveWeapon then
                RemoveWeaponFromPed(PlayerPedId(), GetHashKey(Config.Weapon))
                notify(Config.Translations['gun_removed'], 5)
            end
        end
        Wait(sleep)
    end
end)

notify = function(text, length)
    local wait = GetGameTimer()+length*1000
    while wait >= GetGameTimer() do
        Wait(0)
        drawText3D(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.5, 0.4), text)
    end
end

drawText = function(text, x, y)
    SetTextColour(255, 255, 255, 255)
    SetTextFont(4)
    SetTextScale(0.5, 0.5)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(false)
    SetTextOutline()
    SetTextEdge(1, 0, 0, 0, 205)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

drawText3D = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
  
    SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
  
    AddTextComponentString(text)
    DrawText(_x, _y)
end

loadDict = function(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end