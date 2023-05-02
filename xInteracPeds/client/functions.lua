--local ped, session = nil, false
local session = false
local spawnedPeds = {}



local function startInteraction(v, ped, session)
    local cb, item = math.random(v.CommandeMax), math.random(#v.Commande)
    ESX.ShowAdvancedNotification("Client", "Commande", ("Bonjour, je voudrais ~r~%s %s~s~ s'il vous plaît !"):format(cb, v.Commande[item].Label), "CHAR_ARTHUR", 1)
    while true do
        local wait = 1000
        local pPos, pedPos = GetEntityCoords(PlayerPedId()), GetEntityCoords(ped)
        local dst = Vdist(pPos.x, pPos.y, pPos.z, pedPos.x, pedPos.y, pedPos.z)

        if dst <= 2.0 then
            wait = 0
            ESX.ShowHelpNotification(("Appuyez sur ~INPUT_CONTEXT~ pour donner ~r~x%s %s au client."):format(cb, v.Commande[item].Label))
            if IsControlJustPressed(1, 51) then
                -- Ajout de la vérification de l'inventaire
                local inventory = ESX.GetPlayerData().inventory
                local itemFound = false
                for i=1, #inventory do
                    if inventory[i].name == v.Commande[item].Name and inventory[i].count >= tonumber(cb) then
                        itemFound = true
                        break
                    end
                end

                if itemFound then
                    -- Ajout de l'animation et de la prop synchronisées
                    local dict = "mp_am_hold_up"
                    local anim = "purchase_beerbox_shopkeeper"
                    local prop = "prop_cs_paper_bag"

                    RequestAnimDict(dict)
                    while not HasAnimDictLoaded(dict) do
                        Wait(1)
                    end

                    local playerPed = PlayerPedId()
                    local propEntity = CreateObject(GetHashKey(prop), 1.0, 1.0, 1.0, 1, 1, 0)

                    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                    AttachEntityToEntity(propEntity, playerPed, GetPedBoneIndex(playerPed, 57005), 0.12, 0.03, -0.05, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                    TriggerServerEvent('xInteracPeds:syncAnimation', GetPlayerServerId(PlayerId()), dict, anim, prop)
                    Wait(1000)
                    ClearPedTasks(playerPed)
                    DetachEntity(propEntity, true, true)
                    DeleteObject(propEntity)
                    -- Fin de l'ajout de l'animation et de la prop synchronisées

                    -- Retrait de l'article de l'inventaire
                    TriggerServerEvent("esx:removeInventoryItem", v.Commande[item].Name, tonumber(cb))

                    -- Ajout de l'article à l'inventaire du joueur
                    TriggerServerEvent("esx:addInventoryItem", v.Commande[item].Name, tonumber(cb))

                    TriggerServerEvent("xInteracPeds:give", v.Commande[item].Name, tonumber(cb), tonumber(v.Commande[item].Price), v.nameSociety)
                    TriggerServerEvent("xInteracPeds:releasePed", ped)
                    Wait(5000)
                    break
                else
                    ESX.ShowNotification("Vous n'avez pas assez d'articles pour effectuer cette commande.")
                end
            end
        else
            TaskGoToEntity(ped, PlayerPedId(), -1, 1.0, 2.0, 1073741824, 0)
        end

        Wait(wait)
    end
end



-- Fonction pour créer un ped
function spawnPed(pedModel, spawnPos, v)
    local ped = CreatePed(4, pedModel, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, false)
    if DoesEntityExist(ped) then
        print("Ped spawned successfully.") -- Ajouter cette ligne pour afficher un message de débogage
        SetEntityAsMissionEntity(ped, true, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedCanBeTargetted(ped, false)
        SetPedCanBeTargettedByPlayer(ped, false)
        SetPedConfigFlag(ped, 118, true)
        SetPedFleeAttributes(ped, 0, 0)
        SetPedCombatAttributes(ped, 17, true)
        SetPedSeeingRange(ped, 0.0)
        SetPedHearingRange(ped, 0.0)
        SetPedAlertness(ped, 0)
        SetPedKeepTask(ped, true)
        TaskGoToEntity(ped, source, -1, 1.0, 1.0, 1073741824, 0)
        table.insert(spawnedPeds, ped)
    end
end





local function ManageSession(v)
    local ped = nil
    local spawnPos = v.SpawnZone[1]

    if not session then
        session = true
        ESX.ShowNotification("(~y~Information~s~)\nLes clients vont bientôt arriver.")
        while session do
            Wait(v.TimeSpwan * 1000)
            if ped == nil then
                local pedModel = Config.PedModels[math.random(#Config.PedModels)] -- Choisir un modèle de peds aléatoire
                RequestModel(GetHashKey(pedModel)) -- Charger le modèle
                while not HasModelLoaded(GetHashKey(pedModel)) do
                    Wait(1)
                end
                TriggerEvent('xInteracPeds:spawnPed', pedModel, spawnPos, v)
                ped = spawnedPeds[#spawnedPeds] -- Prendre le dernier ped spawné
                startInteraction(v, ped)
            end
        end
    else
        session = false
        ESX.ShowNotification("(~y~Information~s~)\nLes clients rentrent chez eux.")
        if ped ~= nil then
            DeletePed(ped)
            ped = nil
        end
    end
end




RegisterCommand(Config.NameCommand, function()
    for _,v in pairs(Config.Interaction) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == v.Job then
            ManageSession(v)
        end
    end
end)






RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('xInteracPeds:spawnPedClient')
AddEventHandler('xInteracPeds:spawnPedClient', function(pedModel, spawnPos, v)
    spawnPed(pedModel, spawnPos, v)
end)

-- Événement pour créer un ped
RegisterNetEvent('xInteracPeds:spawnPed')
AddEventHandler('xInteracPeds:spawnPed', function(pedModel, spawnPos, v)
    spawnPed(pedModel, spawnPos, v)
end)


-- Ajout de la synchronisation de l'animation et de la prop
RegisterNetEvent('xInteracPeds:syncAnimation')
AddEventHandler('xInteracPeds:syncAnimation', function(playerId, dict, anim, prop)
    local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(1)
    end

    local propEntity = CreateObject(GetHashKey(prop), 1.0, 1.0, 1.0, 1, 1, 0)

    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
    AttachEntityToEntity(propEntity, playerPed, GetPedBoneIndex(playerPed, 57005), 0.12, 0.03, -0.05, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    Wait(1000)
    ClearPedTasks(playerPed)
    DetachEntity(propEntity, true, true)
    DeleteObject(propEntity)
end)


