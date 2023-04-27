ESX = nil
local onDuty = true
local npc = nil
local selectedItem = nil
local jobConfig = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while not ESX.IsPlayerLoaded() do
        Citizen.Wait(500)
    end

    ESX.TriggerServerCallback('esx_npc_order:getJob', function(job)
        jobConfig = Config.Jobs[job]
    end)

    CheckDutyStatus()
end)

function CheckDutyStatus()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            ESX.TriggerServerCallback('esx_npc_order:getDutyStatus', function(dutyStatus)
                onDuty = dutyStatus
            end)
        end
    end)
end

RegisterCommand('commande_pnj', function()
    StartNpcOrder()
end, false)

function GetSafeSpawnCoords(coords)
    local spawnCoords
    local distance
    repeat
        local randomX = math.random(-15, 15)
        local randomY = math.random(-15, 15)
        spawnCoords = vector3(coords.x + randomX, coords.y + randomY, coords.z)
        distance = #(coords - spawnCoords)
    until distance > 1.0
    return spawnCoords
end

function StartNpcOrder()
    if onDuty then
        if not npc then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local spawnCoords = GetSafeSpawnCoords(playerCoords)
            local model = GetHashKey(jobConfig.npcModels[math.random(#jobConfig.npcModels)])

            RequestModel(model)

            while not HasModelLoaded(model) do
                Wait(1)
            end

            npc = CreatePed(4, model, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, false, true)
            TaskStartScenarioInPlace(npc, jobConfig.animation, 0, false)

            selectedItem = jobConfig.items[math.random(#jobConfig.items)]

            ESX.ShowNotification('Un PNJ est apparu pour passer une commande.')
        else
            DeleteEntity(npc)
            npc = nil

            ESX.ShowNotification('Vous avez arrêté de prendre des commandes de PNJ.')
        end
    else
        ESX.ShowNotification('Vous devez être en service pour utiliser cette commande.')
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        if onDuty and npc then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = GetDistanceBetweenCoords(playerCoords, GetEntityCoords(npc))

            if distance <= 1.0 then
                local hasItem = false

                ESX.TriggerServerCallback('esx_npc_order:hasItem', function(result)
                    hasItem = result
                end, selectedItem.item)

                if hasItem then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour donner l'article au PNJ.")

                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('esx_npc_order:completeOrder', selectedItem.item, selectedItem.price, jobConfig.businessName)
                        DeleteEntity(npc)
                        npc = nil
                    end
                else
                    ESX.ShowNotification("Vous n'avez pas l'article requis dans votre inventaire.")
                end
            end
        end
    end
end)
