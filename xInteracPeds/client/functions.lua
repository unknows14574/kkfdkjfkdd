local ped, session, commande = nil, false, false

local function startInteraction(v)
    local cb, item = math.random(v.CommandeMax), math.random(#v.Commande)
    ESX.ShowAdvancedNotification("Client", "Commande", ("Bonjour, je voudrais ~r~%s %s~s~ s'il vous plaît !"):format(cb, v.Commande[item].Label), "CHAR_ARTHUR", 1)
    commande = true
    while commande do
        local wait = 1000
        local pPos, pedPos = GetEntityCoords(PlayerPedId()), GetEntityCoords(ped)
        local dst = Vdist(pPos.x, pPos.y, pPos.z, pedPos.x, pedPos.y, pedPos.z)

        if dst <= 2.0 then
            wait = 0
            ESX.ShowHelpNotification(("Appuyez sur ~INPUT_CONTEXT~ pour donner ~r~x%s %s au client."):format(cb, v.Commande[item].Label))
            if IsControlJustPressed(1, 51) then
                TriggerServerEvent("xInteracPeds:give", v.Commande[item].Name, tonumber(cb), tonumber(v.Commande[item].Price), v.nameSociety)
                TaskWanderStandard(ped, 10, 10)
                SetBlockingOfNonTemporaryEvents(ped, true)
                commande = false
                Wait(5000)
                DeletePed(ped)
                ped = nil
            end
        end

        Wait(wait)
    end
end

local function spwanPed(v)
    local pedSelected = v.Peds[math.random(#v.Peds)]
    local hash = GetHashKey(pedSelected)
    while not HasModelLoaded(hash) do RequestModel(hash) Wait(20) end
    ped = CreatePed("PED_TYPE_CIVMALE", pedSelected, v.PositionSpwan.x, v.PositionSpwan.y,  v.PositionSpwan.z, v.HeadingSpwan, false, true)
    local targetPed = GetPlayerPed(-1)
    TaskGoStraightToCoord(ped, v.Position.x, v.Position.y,  v.Position.z, 1.0, 150000, 500, 1.0 )
    Wait(11000)
    TaskGoStraightToCoord(ped, v.Position2.x, v.Position2.y,  v.Position2.z, 1.0, 150000, 500, 1.0 )
    Wait(100)
    startInteraction(v)
end

function ManageSession(v)
    if not session then
        session = true
        ESX.ShowNotification("(~y~Information~s~)\nLes clients vont bientôt arriver.")
        while session do
            Wait(v.TimeSpwan * 1000)
            if ped == nil then spwanPed(v) end
        end
    else
        session = false
        ESX.ShowNotification("(~y~Information~s~)\nLes clients rentrent chez eux.")
        if ped ~= nil then DeletePed(ped) ped = nil end
    end
end