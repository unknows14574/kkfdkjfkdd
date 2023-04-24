local isAllowedToStop = false

AddEventHandler('xPiwel_skin:NoStopAnim', function(isAllowed)
    isAllowedToStop = isAllowed
end)

-- Ragdoll
local ragdoll = false
RegisterCommand('ragdoll', function()
    if not IsPedInAnyVehicle(playerPed, false) and not isAllowedToStop then
        TriggerEvent('gcphone:IsPhoneOpen', function(phone) 
            phone_open = phone
        end)
        if ragdol then
            ragdol = false
        elseif not phone_open then
            ClearPedTasksImmediately(playerPed)
            ragdol = true
        end
        while ragdol do
            SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)
            Citizen.Wait(1)
        end
    end
end, false)
RegisterKeyMapping('ragdoll', 'Ragdoll', 'keyboard', Config.keyDefaults.ragdoll)

-- Pointer du doigt
local pointing_fingers = false
RegisterCommand('pointing_fingers', function()
    TriggerEvent('gcphone:IsPhoneOpen', function(phone) 
        phone_open = phone
    end)
    if pointing_fingers then
        pointing_fingers = false
        --ClearPedTasks(playerPed)
        RequestTaskMoveNetworkStateTransition(playerPed, "Stop")
        SetPedConfigFlag(playerPed, 36, 0)
        ClearPedSecondaryTask(playerPed)
    elseif not phone_open then
        pointing_fingers = true
        --ClearPedTasks(playerPed)
        Core.Object.ChargeAnimDict("anim@mp_point")
        TaskMoveNetworkByName(playerPed, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
        RemoveAnimDict("anim@mp_point")
    end
    Citizen.CreateThread(function()
        while IsTaskMoveNetworkActive(playerPed) do
            Citizen.Wait(10)
            local camPitch = GetGameplayCamRelativePitch()
            if camPitch < -70.0 then
                camPitch = -70.0
            elseif camPitch > 42.0 then
                camPitch = 42.0
            end
            camPitch = (camPitch + 70.0) / 112.0

            local camHeading = GetGameplayCamRelativeHeading()
            local cosCamHeading = Cos(camHeading)
            local sinCamHeading = Sin(camHeading)
            if camHeading < -180.0 then
                camHeading = -180.0
            elseif camHeading > 180.0 then
                camHeading = 180.0
            end
            camHeading = (camHeading + 180.0) / 360.0

            local blocked = 0
            local nn = 0

            local coordsOff = GetOffsetFromEntityInWorldCoords(playerPed, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
            local ray = Cast_3dRayPointToPoint(coordsOff.x, coordsOff.y, coordsOff.z - 0.2, coordsOff.x, coordsOff.y, coordsOff.z + 0.2, 0.4, 95, playerPed, 7);
            nn,blocked,coordsOff,coordsOff = GetRaycastResult(ray)

            SetTaskMoveNetworkSignalFloat(playerPed, "Pitch", camPitch)
            SetTaskMoveNetworkSignalFloat(playerPed, "Heading", camHeading * -1.0 + 1.0)
            SetTaskMoveNetworkSignalBool(playerPed, "isBlocked", blocked)
            SetTaskMoveNetworkSignalBool(playerPed, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
        end
    end)
end, false)
RegisterKeyMapping('pointing_fingers', 'Pointer du doigt', 'keyboard', Config.keyDefaults.pointing_fingers)

-- S'allonger
local proned = false
RegisterCommand( "allonger", function()
    if not IsPedInAnyVehicle(playerPed, false) then
        TriggerEvent('gcphone:IsPhoneOpen', function(phone) 
            phone_open = phone
        end)
        if proned then
            proned = false
            ClearPedTasks(playerPed)
        elseif not phone_open then
            ClearPedTasks(playerPed)
            Core.Object.ChargeAnimDict("move_crawl")
            proned = true
            if IsPedSprinting(playerPed) or IsPedRunning(playerPed) or GetEntitySpeed(playerPed) > 5 then
                TaskPlayAnim(playerPed, "move_jump", "dive_start_run", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
                Citizen.Wait(1000)
            end
            TaskPlayAnimAdvanced(playerPed, "move_crawl", "onfront_fwd", coords, 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
        end
        while proned do
            Citizen.Wait(10)
            coords = GetEntityCoords(playerPed)
            if IsControlPressed(0, 32) or IsControlPressed(0, 33) then
                DisablePlayerFiring(playerPed, true)
            elseif IsControlJustReleased(0, 32) or IsControlJustReleased(0, 33) then
                DisablePlayerFiring(playerPed, false)
            end
            if IsControlJustPressed(0, 32) and not movefwd then
                movefwd = true
                TaskPlayAnimAdvanced(playerPed, "move_crawl", "onfront_fwd", coords, 1.0, 0.0, GetEntityHeading(playerPed), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
            elseif IsControlJustReleased(0, 32) and movefwd then
                TaskPlayAnimAdvanced(playerPed, "move_crawl", "onfront_fwd", coords, 1.0, 0.0, GetEntityHeading(playerPed), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
                movefwd = false
            end		
            if IsControlJustPressed(0, 33) and not movebwd then
                movebwd = true
                TaskPlayAnimAdvanced(playerPed, "move_crawl", "onfront_bwd", coords, 1.0, 0.0, GetEntityHeading(playerPed), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
            elseif IsControlJustReleased(0, 33) and movebwd then 
                TaskPlayAnimAdvanced(playerPed, "move_crawl", "onfront_bwd", coords, 1.0, 0.0, GetEntityHeading(playerPed), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
                movebwd = false
            end
            if IsControlPressed(0, 34) then
                SetEntityHeading(playerPed, GetEntityHeading(playerPed)+2.0 )
            elseif IsControlPressed(0, 35) then
                SetEntityHeading(playerPed, GetEntityHeading(playerPed)-2.0 )
            end
        end
    end
end, false)
RegisterKeyMapping( "allonger", "S'allonger", "keyboard", Config.keyDefaults.allonger)

-- S'accroupir
local crouched = false
RegisterCommand( "accroupi", function()
    if not IsPedInAnyVehicle(playerPed, false) and not isAllowedToStop then
        DisableControlAction(0, 36, true)      
        ClearPedTasks(playerPed) 
        if crouched then
            Core.Object.ChargeAnimSet("MOVE_M@TOUGH_GUY@") 
            ResetPedMovementClipset(playerPed)
            ResetPedStrafeClipset(playerPed)
            SetPedMovementClipset(playerPed,"MOVE_M@TOUGH_GUY@", 0.5)
            SetPedMovementClipset(playerPed,"move_m@multiplayer", 0.5)
            crouched = false 
        else
            Core.Object.ChargeAnimSet("move_ped_crouched")
            SetPedMovementClipset(playerPed, "move_ped_crouched", 0.55 )
            SetPedStrafeClipset(playerPed, "move_ped_crouched_strafing")
            crouched = true 
        end 
    end
end, false)
RegisterKeyMapping( "accroupi", "S'accroupir", "keyboard", Config.keyDefaults.accroupi)

-- Lever les mains
local handsUp = false
RegisterCommand('handsup', function()
    if not IsPedInAnyVehicle(playerPed, false) then
        TriggerEvent('gcphone:IsPhoneOpen', function(phone) 
            phone_open = phone
        end)
        if handsUp then
            handsUp = false
            ClearPedTasks(playerPed)
            ResetPedMovementClipset(playerPed, 0)
            ClearPedSecondaryTask(playerPed)
        elseif not phone_open then
            handsUp = true
            ClearPedTasks(playerPed)
            Core.Object.ChargeAnimDict("random@mugging3")
            TaskPlayAnim(playerPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
        end
    end
end, false)
RegisterKeyMapping('handsup', 'Lever les Mains', 'keyboard', Config.keyDefaults.handsup)

-- Siffler
RegisterCommand("siffler", function()
    if not IsPedInAnyVehicle(playerPed, false) then
        TriggerEvent('gcphone:IsPhoneOpen', function(phone) 
            phone_open = phone
        end)
        if not phone_open then
            ClearPedTasks(playerPed)
            Core.Object.ChargeAnimDict('rcmnigel1c')
            TaskPlayAnim(playerPed, 'rcmnigel1c', 'hailing_whistle_waive_a' ,8.0, -8, -1, 120, 0, false, false, false)
        end
    end
end, false)
RegisterKeyMapping( "siffler", "Siffler", "keyboard", Config.keyDefaults.siffler)

-- Holster
local holster = false
RegisterCommand( "holster", function()
    if not IsPedInAnyVehicle(playerPed, false) then
        TriggerEvent('gcphone:IsPhoneOpen', function(phone) 
            phone_open = phone
        end)
        if holster then
            holster = false
            ClearPedTasks(playerPed)
        elseif not phone_open then
            holster = true
            ClearPedTasks(playerPed)
            Core.Object.ChargeAnimDict("reaction@intimidation@cop@unarmed")
            TaskPlayAnim(playerPed, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
        end
    end
end, false)
RegisterKeyMapping( "holster", "Main sur le Holster", "keyboard", Config.keyDefaults.holster)

-- Croiser les bras
local croiser_bras = false
RegisterCommand( "croiser_bras", function()
    if not IsPedInAnyVehicle(playerPed, false) then
        TriggerEvent('gcphone:IsPhoneOpen', function(phone) 
            phone_open = phone
        end)
        if croiser_bras then
            croiser_bras = false
            ClearPedTasks(playerPed)
        elseif not phone_open then
            croiser_bras = true
            ClearPedTasks(playerPed)
            Core.Object.ChargeAnimDict("anim@amb@nightclub@peds@")
            TaskPlayAnim(playerPed, "anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", 8.0, -8, -1, 49, 0, 0, 0, 0)
        end
    end
end, false)
RegisterKeyMapping( "croiser_bras", "Croiser les bras", "keyboard", Config.keyDefaults.croiser_bras)

-- Main sur la tête
local hand_on_head = false
RegisterCommand( "hand_on_head", function()
    if not IsPedInAnyVehicle(playerPed, false) then
        TriggerEvent('gcphone:IsPhoneOpen', function(phone) 
            phone_open = phone
        end)
        if hand_on_head then
            hand_on_head = false
            ClearPedTasks(playerPed)
        elseif not phone_open then
            hand_on_head = true
            ClearPedTasks(playerPed)
            Core.Object.ChargeAnimDict("random@arrests@busted")
            TaskPlayAnim(playerPed, "random@arrests@busted", "idle_a", 8.0, -8, -1, 49, 0, 0, 0, 0)
        end
    end
end, false)
RegisterKeyMapping( "hand_on_head", "Main sur la tête", "keyboard", Config.keyDefaults.hand_on_head)

-- Arreter animation
-- RegisterCommand( "stop_animation", function()
--     if not IsPedInAnyVehicle(playerPed, false) then
--         ResetPedMovementClipset(playerPed, 0)
--         ClearPedTasks(playerPed)
--         ClearPedSecondaryTask(playerPed)
--         TriggerEvent("esx_optionalneeds:StopSmoke")
--         TriggerEvent('skinchanger:getSkin', function(skin)
--         end)
--     end
-- end, false)
-- RegisterKeyMapping( "stop_animation", "Arreter une animation", "keyboard", Config.keyDefaults.stop_animation)

-- CarryPeople
local carryingBackInProgress = false
RegisterCommand("carry",function(source, args)
	if not carryingBackInProgress then
		TriggerEvent("carrypeople")
	else
        TriggerEvent("carrypeople")
    end
end,false)

RegisterNetEvent('carrypeople')
AddEventHandler('carrypeople', function()
    local player = Core.Player.GetClosestPlayer(1.5)
    if player ~= nil and player ~= -1 then
        if not carryingBackInProgress then
            carryingBackInProgress = true
            Core.Object.ChargeAnimDict('missfinale_c2mcs_1')
            TaskPlayAnim(playerPed, 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', 8.0, -8.0, -1, 49, 0, false, false, false)
            TriggerServerEvent('carrypeople:sync', "on", GetPlayerServerId(player))
        else
            carryingBackInProgress = false
            ClearPedSecondaryTask(playerPed)
            DetachEntity(playerPed, true, false)
            TriggerServerEvent('carrypeople:sync', "off", GetPlayerServerId(player))
        end
    else
        Core.Main.ShowNotification("Aucune personne n'est à ~y~proximité~w~.")
    end
end)

RegisterNetEvent('carrypeople:syncTarget')
AddEventHandler('carrypeople:syncTarget', function(target, OnOff)
    if OnOff == "on" then
        local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
        carryingBackInProgress = true
        Core.Object.ChargeAnimDict('nm')
        AttachEntityToEntity(playerPed, targetPed, 0, 0.27, 0.15, 0.63, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
        TaskPlayAnim(playerPed, 'nm', 'firemans_carry', 8.0, -8.0, -1, 33, 0, false, false, false)
    elseif OnOff == "off" then
        carryingBackInProgress = false
        ClearPedSecondaryTask(playerPed)
        DetachEntity(playerPed, true, false)
    end
end)

--Porter dans les bras
local lyftuppInProgress = false
RegisterCommand("lyftupp",function(source, args)
	if not lyftuppInProgress then
		TriggerEvent("lyftupp")
	else
        TriggerEvent("lyftupp")
    end
end,false)

RegisterNetEvent('lyftupp')
AddEventHandler('lyftupp', function()
    local player = Core.Player.GetClosestPlayer(1.5)
    if player ~= nil and player ~= -1 then
        if not lyftuppInProgress then
            lyftuppInProgress = true
            Core.Object.ChargeAnimDict("anim@heists@box_carry@")
            TaskPlayAnim(playerPed, "anim@heists@box_carry@", 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
            TriggerServerEvent('lyftupp:sync', "on", GetPlayerServerId(player))
        else
            lyftuppInProgress = false
            ClearPedSecondaryTask(playerPed)
            DetachEntity(playerPed, true, false)
            TriggerServerEvent('lyftupp:sync', "off", GetPlayerServerId(player))
        end
    else
        Core.Main.ShowNotification("Aucune personne n'est à ~y~proximité~w~.")
    end
end)

RegisterNetEvent('lyftupp:syncTarget')
AddEventHandler('lyftupp:syncTarget', function(target, OnOff)
    if OnOff == "on" then
        local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
        lyftuppInProgress = true
        Core.Object.ChargeAnimDict("amb@code_human_in_car_idles@generic@ps@base")
        AttachEntityToEntity(playerPed, targetPed, 9816, 0.015, 0.38, 0.11, 0.9, 0.30, 90.0, false, false, false, false, 2, false)
        TaskPlayAnim(playerPed, "amb@code_human_in_car_idles@generic@ps@base", "base", 8.0, -8, -1, 33, 0, 0, 40, 0)
    elseif OnOff == "off" then
        lyftuppInProgress = false
        DetachEntity(playerPed, true, false)
        ClearPedTasks(playerPed)
    end
end)

--Porter sur le dos
local piggybackInProgress = false
RegisterCommand("piggyback",function(source, args)
	if not piggybackInProgress then
		TriggerEvent("piggyback")
	else
        TriggerEvent("piggyback")
    end
end,false)

RegisterNetEvent('piggyback')
AddEventHandler('piggyback', function()
    local player = Core.Player.GetClosestPlayer(1.5)
    if player ~= nil and player ~= -1 then
        if not piggybackInProgress then
            piggybackInProgress = true
            Core.Object.ChargeAnimDict('anim@arena@celeb@flat@paired@no_props@')
            TaskPlayAnim(playerPed, 'anim@arena@celeb@flat@paired@no_props@', 'piggyback_c_player_a', 8.0, -8.0, -1, 49, 0, false, false, false)
            TriggerServerEvent('piggyback:sync', "on", GetPlayerServerId(player))
        else
            piggybackInProgress = false
            ClearPedSecondaryTask(playerPed)
            DetachEntity(playerPed, true, false)
            TriggerServerEvent('piggyback:sync', "off", GetPlayerServerId(player))
        end
    else
        Core.Main.ShowNotification("Aucune personne n'est à ~y~proximité~w~.")
    end
end)

RegisterNetEvent('piggyback:syncTarget')
AddEventHandler('piggyback:syncTarget', function(target, OnOff)
    if OnOff == "on" then
        local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
        piggybackInProgress = true
        Core.Object.ChargeAnimDict('anim@arena@celeb@flat@paired@no_props@')
        AttachEntityToEntity(playerPed, targetPed, 0, 0.0, -0.07, 0.45, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
        TaskPlayAnim(playerPed, 'anim@arena@celeb@flat@paired@no_props@', 'piggyback_c_player_b', 8.0, -8, -1, 33, 0, false, false, false)
    elseif OnOff == "off" then
        piggybackInProgress = false
        DetachEntity(playerPed, true, false)
        ClearPedTasks(playerPed)
    end
end)

--Prendre en hotage
local takehostageInProgress = false
local hostageAllowedWeapons = {"WEAPON_PISTOL", "WEAPON_PISTOL_MK2", "WEAPON_PISTOL", "WEAPON_PISTOL50", "WEAPON_HEAVYPISTOL", "WEAPON_VINTAGEPISTOL", "WEAPON_COMBATPISTOL", "WEAPON_SNSPISTOL_MK2", "WEAPON_SNSPISTOL", "WEAPON_REVOLVER", "WEAPON_MICROSMG", "WEAPON_MINISMG"}
RegisterCommand("takehostage",function(source, args)
	if not takehostageInProgress then
		TriggerEvent("takehostage")
	else
        TriggerEvent("takehostage")
    end
end,false)

RegisterNetEvent('takehostage')
AddEventHandler('takehostage', function()
    local player = Core.Player.GetClosestPlayer(1.5)
    if player ~= nil and player ~= -1 then
        for i=1, #hostageAllowedWeapons do
            if HasPedGotWeapon(playerPed, GetHashKey(hostageAllowedWeapons[i]), false) then
                if GetAmmoInPedWeapon(playerPed, GetHashKey(hostageAllowedWeapons[i])) > 0 then
                    foundWeapon = GetHashKey(hostageAllowedWeapons[i])
                    break
                end 					
            end
        end
        if foundWeapon and not takehostageInProgress then
            takehostageInProgress = true
            Core.Object.ChargeAnimDict('anim@gangops@hostage@')
            SetCurrentPedWeapon(playerPed, foundWeapon, true)
            TaskPlayAnim(playerPed, 'anim@gangops@hostage@', 'perp_idle', 8.0, -8.0, -1, 49, 0, false, false, false)
            TriggerServerEvent('takehostage:sync', "on", GetPlayerServerId(player), 'anim@gangops@hostage@', 'victim_idle')
            while takehostageInProgress do
                Citizen.Wait(5)
                if IsEntityDead(playerPed) then
                    takehostageInProgress = false
                    ClearPedSecondaryTask(playerPed)
                    DetachEntity(playerPed, true, false)
                    TriggerServerEvent('takehostage:sync', "off", GetPlayerServerId(player))
                end
                DisableControlAction(0,24,true)
                DisableControlAction(0,25,true)
                DisableControlAction(0,47,true)
                DisableControlAction(0,58,true)
                DisablePlayerFiring(playerPed,true)
                coords = GetEntityCoords(playerPed)
                Core.Main.DrawText3Ds(coords.x, coords.y, coords.z, "Appuie sur ~y~E~s~ pour relacher ou ~r~Y~s~ pour tuer")
                if IsDisabledControlJustPressed(0,38) then --release
                    takehostageInProgress = false
                    TriggerServerEvent('takehostage:sync', "off", GetPlayerServerId(player))
                    Core.Object.ChargeAnimDict('reaction@shove')
                    TaskPlayAnim(playerPed, 'reaction@shove', 'shove_var_a', 8.0, -8.0, -1, 120, 0, false, false, false)
                    TriggerServerEvent('takehostage:sync', "on", GetPlayerServerId(player), 'reaction@shove', 'shoved_back')
                elseif IsDisabledControlJustPressed(0,246) then --kill 
                    takehostageInProgress = false
                    TriggerServerEvent('takehostage:sync', "off", GetPlayerServerId(player))	
                    Core.Object.ChargeAnimDict('anim@gangops@hostage@')		
                    TaskPlayAnim(playerPed, 'anim@gangops@hostage@', 'perp_fail', 8.0, -8.0, 0.2, 168, 0, false, false, false)
                    SetPedShootsAtCoord(playerPed, 0.0, 0.0, 0.0, 0)
                    TriggerServerEvent('takehostage:sync', "on", GetPlayerServerId(player), 'anim@gangops@hostage@', 'victim_fail')
                end
            end
        else
            takehostageInProgress = false
            ClearPedSecondaryTask(playerPed)
            DetachEntity(playerPed, true, false)
            TriggerServerEvent('takehostage:sync', "off", GetPlayerServerId(player))
        end
    else
        Core.Main.ShowNotification("Aucune personne n'est à ~y~proximité~w~.")
    end
end)

RegisterNetEvent('takehostage:syncTarget')
AddEventHandler('takehostage:syncTarget', function(target, OnOff, dict, anim)
    if OnOff == "on" then
        local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
        takehostageInProgress = true
        Core.Object.ChargeAnimDict(dict)
        if anim == 'victim_idle' then
            AttachEntityToEntity(playerPed, targetPed, 0, -0.24, 0.11, 0.0, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
            TaskPlayAnim(playerPed, dict, anim, 8.0, -8, -1, 33, 0, false, false, false)
        elseif anim == 'victim_fail' then
            takehostageInProgress = false
            SetEntityHealth(playerPed,0)
		    DetachEntity(playerPed, true, false)
		    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, 0.2, 0, 0, false, false, false)
        elseif anim == "shoved_back" then
            takehostageInProgress = false
            DetachEntity(playerPed, true, false)
		    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        end
        while takehostageInProgress do
            Citizen.Wait(5)
            DisableControlAction(0,21,true)
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,47,true)
			DisableControlAction(0,58,true)
			DisableControlAction(0,263,true)
			DisableControlAction(0,264,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,140,true)
			DisableControlAction(0,141,true)
			DisableControlAction(0,142,true)
			DisableControlAction(0,143,true)
			DisableControlAction(0,75,true)
			DisableControlAction(27,75,true)
			DisableControlAction(0,22,true)
			DisableControlAction(0,32,true)
			DisableControlAction(0,268,true)
			DisableControlAction(0,33,true)
			DisableControlAction(0,269,true)
			DisableControlAction(0,34,true)
			DisableControlAction(0,270,true)
			DisableControlAction(0,35,true)
			DisableControlAction(0,271,true)
        end
    elseif OnOff == "off" then
        takehostageInProgress = false
        DetachEntity(playerPed, true, false)
        ClearPedTasks(playerPed)
    end
end)

--claque
RegisterCommand("claque", function()
    if not IsPedInAnyVehicle(playerPed, false) then
        TriggerEvent('gcphone:IsPhoneOpen', function(phone) 
            phone_open = phone
        end)
        if not phone_open then
            ClearPedTasks(playerPed)
            TriggerEvent('claque')
        end
    end
end, false)
RegisterKeyMapping( "claque", "Claque", "keyboard", Config.keyDefaults.claque)

local dClaque = true
RegisterNetEvent('claque')
AddEventHandler('claque', function()
    local player = Core.Player.GetClosestPlayer(1.5)
    if player ~= -1 and dClaque then
        if IsPedArmed(playerPed, 7) then
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
        end

        if (DoesEntityExist(playerPed) and not IsEntityDead(playerPed)) then
            Core.Object.ChargeAnimDict("melee@unarmed@streamed_variations")
            TaskPlayAnim(playerPed, "melee@unarmed@streamed_variations", "plyr_takedown_front_slap", 8.0, 1.0, 1500, 1, 0, 0, 0, 0)
            TriggerServerEvent("claque:sync", GetPlayerServerId(player))
        end
		dClaque = false
    end
	SetTimeout(10000, function()
		dClaque = true
	end)
end)

RegisterNetEvent('claque:syncTarget')
AddEventHandler('claque:syncTarget', function()
    SetPedToRagdoll(playerPed, 2000, 2000, 0, 0, 0, 0)
end)

RegisterNetEvent('claque:son')
AddEventHandler('claque:son', function(targetcoords)
    if GetDistanceBetweenCoords(coords, targetcoords, true) <= 3.0 then
        SendNUIMessage({
            DemarrerLaMusique   = 'DemarrerLaMusique',
            VolumeDeLaMusique   = 0.2
        })
    end
end)

--incoffre
local inVehicle = false
RegisterCommand("incoffre", function()
    TriggerEvent("high_phone:closePhone")
    if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
        if not inVehicle then
            local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 71)
            local modelv = GetEntityModel(vehicle)
            if vehicle ~= 0 and not IsThisModelABike(modelv) then
                ClearPedTasks(playerPed)
                SetCarBootOpen(vehicle)
                Wait(550)
                
                local min, max = GetModelDimensions(modelv)
                AttachEntityToEntity(playerPed, vehicle, -1, 0.0, (max.y - 0.45) * -1, 0.35, 0.0, 0.0, 0.0, false, false, false, false, 20, true)	
                Core.Object.ChargeAnimDict('timetable@floyd@cryingonbed@base')
                TaskPlayAnim(playerPed, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
                TriggerEvent('xPiwel_skin:NoStopAnim', true)
    
                Wait(250)
                SetVehicleDoorShut(vehicle, 5, false)
                inVehicle = true
            end
    
            while inVehicle do
                Wait(10)
                if IsControlJustReleased(0, 38) then
                    inVehicle = false
                    SetCarBootOpen(vehicle)
                    Wait(750)
                    DetachEntity(playerPed, true, false)
                    SetEntityVisible(playerPed, true, false)
                    ClearPedTasks(playerPed)
                    TriggerEvent('xPiwel_skin:NoStopAnim', false)
                    SetEntityCoordsNoOffset(playerPed, GetOffsetFromEntityInWorldCoords(playerPed, 0.0, -1.5, 0.0))
                    Wait(250)
                    SetVehicleDoorShut(vehicle, 5, false)
                else
                    Core.Object.ChargeAnimDict('timetable@floyd@cryingonbed@base')
                    TaskPlayAnim(playerPed, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
                    Core.Main.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour ~g~sortir~s~ du coffre", false, true)
                end
            end
        end
    end
   
end, false)
RegisterKeyMapping( "incoffre", "Entrer / Sortir du coffre de véhicule", "keyboard", Config.keyDefaults.InTrunk)
