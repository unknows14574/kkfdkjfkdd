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

    local blip = AddBlipForEntity(ped)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("PNJ")
    EndTextCommandSetBlipName(blip)

    local destination = v.Position
    local distance = #(destination - pedPos)
    TaskGoToCoord(ped, destination.x, destination.y, destination.z, 1.0, -1, 0, 0)
    while distance > 1.0 do
        Wait(100)
        distance = #(destination - GetEntityCoords(ped))
    end
    SetBlipDisplay(blip, 0)
    table.insert(spawnedPeds, ped)
end

local function startInteraction(v, ped)
    if v.hasOrdered then
        return
    end
    v.hasOrdered = true
    local commande = v.Commande[math.random(#v.Commande)]
    local price = commande.Price * Config.PercentPlayer / 100
    local label = commande.Label
    local item = commande.Name
    TriggerEvent("mythic_progbar:client:progress", {
        name = "order_food",
        duration = 3000,
        label = "Préparation de la commande...",
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(status)
        if not status then
            TriggerServerEvent("xInteracPeds:give", item, price)
            TriggerEvent("chat:addMessage", {color = {255, 255, 0}, args = {"Serveur", "Votre commande de " .. label .. " a été préparée. Montant de la commande : " .. price .. " $"}})
            Wait(60000) -- délai avant de pouvoir passer une nouvelle commande
            v.hasOrdered = false
        end
    end)
end

function ManageSession(v)
    if not v.hasSession then
        v.hasSession = true
        ESX.ShowNotification("(~y~Information~s~) : Un PNJ est disponible à " .. v.Label)
        spawnPed(v)
        Citizen.CreateThread(function()
            while v.hasSession do
                local ped = GetClosestPed(v.Position.x, v.Position.y, v.Position.z, 1.0, 0, 71)
                if ped > 0 then
                    local pedCoords = GetEntityCoords(ped)
                    local distance = #(pedCoords - v.Position)
                    if distance <= 2.0 and not v.hasOrdered then
                        startInteraction(v, ped)
                    end
                end
                Citizen.Wait(0)
            end
        end)
        Wait(Config.SessionTime * 60000)
        v.hasSession = false
        for i, ped in ipairs(spawnedPeds) do
            if DoesEntityExist(ped) then
                DeletePed(ped)
            end
        end
        spawnedPeds = {}
    end
end

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        if Config.PNJ and #Config.PNJ > 0 then
            for i, v in ipairs(Config.PNJ) do
                if not v.hasSession then
                    local distance = #(playerCoords - v.Position)
                    if distance <= Config.SpawnDistance then
                        ManageSession(v)
                    end
                end
            end
        end

        Citizen.Wait(5000) -- Vérification toutes les 5 secondes
    end
end)

