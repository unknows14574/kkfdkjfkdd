ESX = nil

local _source = source

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

---------------------------------------------------------------------------------------------------------
--|                                                                                                   |--
--|                                           PED ARMURIE                                             |--
--|                                                                                                   |--
---------------------------------------------------------------------------------------------------------

local v1 = vector3(15.094986915588,-1097.736328125,28.834789276123)

local distance = 20
local entities = {}
local NotDeadYet = false
local launched = false

Citizen.CreateThread(function()
    while true do
        local dodo = 1000
        if Vdist2(GetEntityCoords(PlayerPedId(), false), v1) < distance then
            dodo = 50

            if not NotDeadYet then
                if Vdist2(GetEntityCoords(PlayerPedId(), false), v1) < 2.0 then

                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_TALK~ pour demander à ~r~tester~w~ vos armes") -- text en haut à droite
                    dodo = 10

                    if IsControlPressed(0, 38) then
                        local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 4.0)

                        if #players > 1 then
                            TriggerEvent('Core:ShowAdvancedNotification', "~b~Ammunation", "~y~Instructeur 09", "Dit aux gens de s'écarter. Je voudrais pas qu'il y ai de blessés.", 'CHAR_AMMUNATION', 1, false, false, 140)
                        else
                            NotDeadYet = true
                            ESX.TriggerServerCallback('xNeb_jobs:armureriePeds', function(is_currently_used)
                                if is_currently_used == false and is_currently_used ~= nil then
                                    ClearAreaOfPeds(16.139713287354, -1089.2314453125, 28.797031402588, 30.0, 1)
                                    TriggerServerEvent('xNeb_jobs:setarmureriePeds', true)
    
                                    NotDeadYet = true
    
                                    TriggerEvent('Core:ShowAdvancedNotification', "~b~Ammunation", "~y~Instructeur 09", "Tiens, je t'ai placé des ~y~mannequins~w~ d'entrainement ! Fait pas l'con, je t'ai à l'oeil.", 'CHAR_AMMUNATION', 1, false, false, 150)
                                    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1) -- Son
    
                                    local hashm1 = GetHashKey("a_m_y_bevhills_01")
    
                                    while not HasModelLoaded(hashm1) do
                                        RequestModel(hashm1)
                                        Wait(20)
                                    end
    
                                    -- Ped 1
                                    Wait(50) -- Anti Lag
                                    mannequin1 = CreatePed("PED_TYPE_CIVMALE", "a_m_y_bevhills_01",16.124643325806,-1079.6947021484,28.797031402588, 159.58, true, true) 
                                    SetBlockingOfNonTemporaryEvents(mannequin1, true)
                                    table.insert(entities, mannequin1)
    
                                    -- Ped 2
                                    Wait(50) -- Anti Lag
                                    mannequin1 = CreatePed("PED_TYPE_CIVMALE", "a_m_y_bevhills_01",21.750091552734,-1081.9945068359,28.799915313721, 159.58, true, true)
                                    SetBlockingOfNonTemporaryEvents(mannequin1, true)
                                    table.insert(entities, mannequin1)
    
                                    -- Ped 3
                                    Wait(50) -- Anti Lag
                                    mannequin1 = CreatePed("PED_TYPE_CIVMALE", "a_m_y_bevhills_01",17.759696960449,-1085.1070556641,29.797027587891, 159.58, true, true) 
                                    SetBlockingOfNonTemporaryEvents(mannequin1, true)
                                    table.insert(entities, mannequin1)
    
                                    -- Ped 4
                                    Wait(50) -- Anti Lag
                                    mannequin1 = CreatePed("PED_TYPE_CIVMALE", "a_m_y_bevhills_01",21.107862472534,-1075.7071533203,28.797027587891, 159.58, true, true) 
                                    SetBlockingOfNonTemporaryEvents(mannequin1, true)
                                    table.insert(entities, mannequin1)
    
                                    -- Ped 5
                                    Wait(50) -- Anti Lag
                                    mannequin1 = CreatePed("PED_TYPE_CIVMALE", "a_m_y_bevhills_01",16.139713287354,-1089.2314453125,28.797031402588, 159.58, true, true) 
                                    SetBlockingOfNonTemporaryEvents(mannequin1, true)
                                    table.insert(entities, mannequin1)
    
                                    -- Ped 6
                                    Wait(50) -- Anti Lag
                                    mannequin1 = CreatePed("PED_TYPE_CIVMALE", "a_m_y_bevhills_01",22.014314651489,-1088.8293457031,28.795991897583, 159.58, true, true) 
                                    SetBlockingOfNonTemporaryEvents(mannequin1, true)
                                    table.insert(entities, mannequin1)
    
                                    -- Ped 7
                                    Wait(50) -- Anti Lag
                                    mannequin1 = CreatePed("PED_TYPE_CIVMALE", "a_m_y_bevhills_01",11.967206001282,-1085.6817626953,28.797027587891, 159.58, true, true) 
                                    SetBlockingOfNonTemporaryEvents(mannequin1, true)
                                    table.insert(entities, mannequin1)
    
                                    -- Ped 8
                                    Wait(50) -- Anti Lag
                                    mannequin1 = CreatePed("PED_TYPE_CIVMALE", "a_m_y_bevhills_01",18.938812255859,-1094.8686523438,28.797008514404, 159.58, true, true) 
                                    SetBlockingOfNonTemporaryEvents(mannequin1, true)
                                    table.insert(entities, mannequin1)
    
                                    -- Ped 9
                                    Wait(50) -- Anti Lag
                                    mannequin1 = CreatePed("PED_TYPE_CIVMALE", "a_m_y_bevhills_01",10.442371368408,-1091.8399658203,28.797008514404, 159.58, true, true) 
                                    SetBlockingOfNonTemporaryEvents(mannequin1, true)
                                    table.insert(entities, mannequin1)
    
                                    launched = true
                                else
                                    TriggerEvent('Core:ShowAdvancedNotification', "~b~Ammunation", "~y~Instructeur 09", "Quelqu'un se charge déjà des mannequins. Attends un peu.", 'CHAR_AMMUNATION', 1, false, false, 140)
                                end
                            end)
                        end
                    end
                end
            end

            if next(entities) ~= nil then
                for i, mannequin1 in pairs(entities) do
                    if IsPedDeadOrDying(mannequin1, 1) then
                        NetworkUnregisterNetworkedEntity(mannequin1)
                        SetEntityAsNoLongerNeeded(mannequin1)
                        DeletePed(mannequin1)
                        DeleteEntity(mannequin1)
                        table.remove(entities, i)
                    end
                end
            else
                if NotDeadYet and launched then
                    ClearAreaOfPeds(16.139713287354, -1089.2314453125, 28.797031402588, 30.0, 1)
                    TriggerServerEvent('xNeb_jobs:setarmureriePeds', false)
                    NotDeadYet = false
                    launched = false
                end
            end
        elseif (Vdist2(GetEntityCoords(PlayerPedId(), false), v1) > 21) and (Vdist2(GetEntityCoords(PlayerPedId(), false), v1) < 25) then
            if next(entities) ~= nil then
                for i, mannequin1 in pairs(entities) do
                    NetworkUnregisterNetworkedEntity(mannequin1)
                    SetEntityAsNoLongerNeeded(mannequin1)
                    DeletePed(mannequin1)
                    DeleteEntity(mannequin1)
                    table.remove(entities, i)
                end
                ClearAreaOfPeds(16.139713287354, -1089.2314453125, 28.797031402588, 30.0, 1)
                TriggerEvent('Core:ShowAdvancedNotification', "~b~Ammunation", "~y~Instructeur 09", "T'aurais pu me prévenir que tu partais. J'ai enlevé les mannequins !", 'CHAR_AMMUNATION', 1, false, false, 130)
                TriggerServerEvent('xNeb_jobs:setarmureriePeds', false)
                NotDeadYet = false
                launched = false
            end
        end
        Citizen.Wait(dodo)
    end
end)

Citizen.CreateThread(function()
    local hash = GetHashKey("csb_mweather")

    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end

    ped = CreatePed("PED_TYPE_CIVMALE", "csb_mweather",15.094986915588,-1097.736328125,28.834789276123, 113.65, false, true) -- Position du ped

    SetBlockingOfNonTemporaryEvents(ped, true) -- Fait en sorte que le ped ne réagisse à rien (n'aura pas peur si il y a des tirs etc...)
    FreezeEntityPosition(ped, true) -- Freeze le ped
    SetEntityInvincible(ped, true) -- Le rend invincible
    GiveWeaponToPed(ped, 0x9D61E50F --[[hash de l'arme : https://wiki.rage.mp/index.php?title=Weapons]], 0, true --[[arme en main]], true --[[arme en main]]) --donne une arme au ped

end)

RegisterCommand('clearpedsarmurerie', function()
    ClearAreaOfPeds(16.139713287354, -1089.2314453125, 28.797031402588, 30.0, 1)
end)