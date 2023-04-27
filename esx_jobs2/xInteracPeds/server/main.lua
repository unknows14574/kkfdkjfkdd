ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local lastInteractionTime = 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterCommand('SellSession', function(source, args)
    local currentTime = GetGameTimer()
    if args[1] == "stop" then
        TriggerEvent("chat:addMessage", {color = {255, 0, 0}, args = {"Serveur", "Vous avez annulé votre commande."}})
        return
    end
    if currentTime - lastInteractionTime < 30000 then
        TriggerEvent("chat:addMessage", {color = {255, 0, 0}, args = {"Serveur", "Vous devez attendre un peu avant de passer une nouvelle commande."}})
        return
    end
    for _,v in pairs(Config.Interactions) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == v.Job then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - v.Position)
            if distance <= 10.0 then
                if v.hasOrdered then
                    TriggerEvent("chat:addMessage", {color = {255, 0, 0}, args = {"Serveur", "Vous avez déjà une commande en cours."}})
                else
                    lastInteractionTime = currentTime
                    v.hasOrdered = true
                    TriggerEvent("chat:addMessage", {color = {255, 255, 0}, args = {"Serveur", "Votre commande a été enregistrée."}})
                    ManageSession(v, playerCoords)
                end
                break
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        ESX.TriggerServerCallback("esx:playerLoaded", function(isLoaded)
            if isLoaded then
                TriggerEvent("chat:addSuggestion", "/" .. Config.NameCommand, "Passer une commande auprès d'un PNJ de la société associée à votre job.")
            end
        end)
    end
end)

function ManageSession(v, playerCoords)
    local spawnedPed = spawnPed(v)
    if spawnedPed then
        local playerPed = PlayerPedId()
        local animDict = v.AnimDict
        local animName = v.AnimName
        local animFlag = v.AnimFlag
        local distance = #(playerCoords - v.Position)

        if distance <= 3.0 then
            TaskTurnPedToFaceEntity(playerPed, spawnedPed, -1)
            Wait(500)
            TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, animFlag, 0, false, false, false)
            Wait(500)
            TriggerServerEvent("xInteracPeds:startInteraction", v)
        else
            TriggerEvent("chat:addMessage", {color = {255, 0, 0}, args = {"Serveur", "Vous êtes trop éloigné du PNJ pour passer une commande."}})
        end
    end
end

