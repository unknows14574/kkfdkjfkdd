local CurrentMission = nil
local CurrentMissionType = nil
local CurrentCheckPoint = 0
local LastCheckPoint = -1
local CurrentBlip = nil

function DrawMissionText(msg, time)
    ESX.ShowNotification(msg)
end

local nModel = "mrumpo"

function StartMission(type)
    CurrentMission = 'drive'
    CurrentMissionType = type
    CurrentCheckPoint = 0
    LastCheckPoint = -1
    CurrentZoneType = 'residence'
    ESX.UI.Menu.CloseAll()
end

function StopMission(success)

    if success then
        TriggerServerEvent('esx_flywheels:end')
    else
        ESX.ShowNotification("Vous n'avez pas fini votre boulot.")
    end
    CurrentMission = nil
    CurrentMissionType = nil
end

function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local factor = #text / 370
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end

RegisterNetEvent('esx_flywheels:livraison')
AddEventHandler('esx_flywheels:livraison', function()
    StartMission("")
end)

RegisterNetEvent('esx_flywheels:stopliv')
AddEventHandler('esx_flywheels:stopliv', function()
    StopMission(false)
    RemoveBlip(CurrentBlip)
end)

Citizen.CreateThread(function()
    while true do

        Citizen.Wait(10)

        if CurrentMission == 'drive' then
            local nextCheckPoint = CurrentCheckPoint + 1

            if MosleyConfig.CheckPoints[nextCheckPoint] == nil then
                if DoesBlipExist(CurrentBlip) then
                    RemoveBlip(CurrentBlip)
                end

                CurrentMission = nil

                StopMission(true)

            else
                if IsPedInAnyVehicle(playerPed, false) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)

                    if CurrentCheckPoint ~= LastCheckPoint then

                        if DoesBlipExist(CurrentBlip) then
                            RemoveBlip(CurrentBlip)
                        end

                        CurrentBlip = AddBlipForCoord(MosleyConfig.CheckPoints[nextCheckPoint].Pos.x, MosleyConfig.CheckPoints[nextCheckPoint].Pos.y, MosleyConfig.CheckPoints[nextCheckPoint].Pos.z)
                        SetBlipRoute(CurrentBlip, 1)

                        LastCheckPoint = CurrentCheckPoint

                    end

                    local distance = GetDistanceBetweenCoords(coords, MosleyConfig.CheckPoints[nextCheckPoint].Pos.x, MosleyConfig.CheckPoints[nextCheckPoint].Pos.y, MosleyConfig.CheckPoints[nextCheckPoint].Pos.z, true)

                    if distance <= 1000.0 then
                        DrawMarker(0, MosleyConfig.CheckPoints[nextCheckPoint].Pos.x,
                            MosleyConfig.CheckPoints[nextCheckPoint].Pos.y,
                            MosleyConfig.CheckPoints[nextCheckPoint].Pos.z - 0.7, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3,
                            0.3, 255, 255, 0, 100, false, true, 2, false, false, false, false)
                    end

                    local iClass = GetVehicleClass(vehicle)

                    -- if distance <= 6.0 and IsVehicleModel(vehicle, GetHashKey(nModel)) then
                    if distance <= 6.0 and (iClass == 10 or iClass == 11 or iClass == 12 or iClass == 20) then
                        MosleyConfig.CheckPoints[nextCheckPoint].Action(playerPed, currentVeh, nil)
                        CurrentCheckPoint = CurrentCheckPoint + 1
                    end
                end
            end
        end
    end
end)
