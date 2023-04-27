ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local npcDetectionEnabled = true
ESX.RegisterServerCallback('esx:getPlayerData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        if result[1] then
            PlayerData = {
                identifier = identifier,
                money = result[1].money,
                bank = result[1].bank,
                dirty_money = result[1].dirty_money
            }
            cb(PlayerData)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        TriggerClientEvent('esx:updatePlayerData', -1, PlayerData)
        Citizen.Wait(10000) -- Mettre à jour toutes les 10 secondes
    end
end)

local spawnedPeds = {}

local function spawnPed(v)
    local modelHash = GetHashKey(Config.PedModels[math.random(#Config.PedModels)])
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    local pedPos = v.PositionSpwan
    local ped = CreatePed(26, modelHash, pedPos, v.HeadingSpwan, 1, 0)
    SetPedComponentVariation(ped, 0, 0, 0, 0)
    SetPedComponentVariation(ped, 3, 0, 0, 0)
    SetPedComponentVariation(ped, 4, 0, 0, 0)
    SetPedComponentVariation(ped, 6, 0, 0, 0)
    SetPedComponentVariation(ped, 11, 0, 0, 0)
    SetPedComponentVariation(ped, 8, 0, 0, 0)
    SetPedComponentVariation(ped, 10, 0, 0, 0)
    SetPedComponentVariation(ped, 2, 0, 0, 0)
    SetPedComponentVariation(ped, 1, 0, 0, 0)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    SetPedComponentVariation(ped, 9, 0, 0, 0)
    SetPedComponentVariation(ped, 7, 0, 0, 0)
    SetPedComponentVariation(ped, 12, 0, 0, 0)
    SetPedComponentVariation(ped, 13, 0, 0, 0)
    SetPedComponentVariation(ped, 14, 0, 0, 0)
    SetPedComponentVariation(ped, 15, 0, 0, 0)
    SetPedComponentVariation(ped, 16, 0, 0, 0)
    SetPedComponentVariation(ped, 17, 0, 0, 0)
    SetPedComponentVariation(ped, 18, 0, 0, 0)
    SetPedComponentVariation(ped, 19, 0, 0, 0)
    SetPedComponentVariation(ped, 20, 0, 0, 0)
    SetPedComponentVariation(ped, 21, 0, 0, 0)
    SetPedComponentVariation(ped, 22, 0, 0, 0)
    SetPedComponentVariation(ped, 23, 0, 0, 0)
    SetPedComponentVariation(ped, 24, 0, 0, 0)
    SetPedComponentVariation(ped, 25, 0, 0, 0)
    SetPedComponentVariation(ped, 26, 0, 0, 0)
    SetPedComponentVariation(ped, 27, 0, 0, 0)
    SetPedComponentVariation(ped, 28, 0, 0, 0)
    SetPedComponentVariation(ped, 29, 0, 0, 0)

    SetPedAsNoLongerNeeded(ped)
    table.insert(spawnedPeds, ped)

    local interaction = v.Interaction or "default"
    local interactionData = Config.Interactions[interaction]
    if interactionData then
        local pedData = {
            nameSociety = interactionData.nameSociety,
            job = interactionData.Job,
            timeSpwan = interactionData.TimeSpwan,
            commande = interactionData.Commande,
            commandeMax = interactionData.CommandeMax,
            percentPlayer = Config.PercentPlayer,
            nameCommand = Config.NameCommand
        }
        TriggerEvent('xInteracPeds:spawnedPed', ped, pedData)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k, v in pairs(Config.PedList) do
            local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.PositionSpwan, true)
            if distance <= Config.SpawnDistance and not IsPedInAnyVehicle(PlayerPedId(), true) then
                local canSpawn = true
                for i=1, #spawnedPeds do
                    local spawnedDistance = GetDistanceBetweenCoords(GetEntityCoords(spawnedPeds[i]), v.PositionSpwan, true)
                    if spawnedDistance <= Config.SpawnDistance then
                        canSpawn = false
                        break
                    end
                end
                if canSpawn then
                    spawnPed(v)
                end
            end
        end
    end
end)

RegisterCommand('toggleNPCDetection', function()
    npcDetectionEnabled = not npcDetectionEnabled
    if npcDetectionEnabled then
        ESX.ShowNotification('Détection des PNJs activée')
    else
        ESX.ShowNotification('Détection des PNJs désactivée')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if npcDetectionEnabled then
            for k, v in pairs(Config.PedList) do
                local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.PositionSpwan, true)
                if distance <= Config.SpawnDistance and not IsPedInAnyVehicle(PlayerPedId(), true) then
                    local canSpawn = true
                    for i=1, #spawnedPeds do
                        local spawnedDistance = GetDistanceBetweenCoords(GetEntityCoords(spawnedPeds[i]), v.PositionSpwan, true)
                        if spawnedDistance <= Config.SpawnDistance then
                            canSpawn = false
                            break
                        end
                    end
                    if canSpawn then
                        spawnPed(v)
                    end
                end
            end
        end
    end
end)
