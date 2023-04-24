ESX           = nil
PlayerData    = {}
local menuIsOpen = false
local isTaz = false

if Core == nil then
    Core = {}
end


--Restart Ressource
AddEventHandler('onClientResourceStart', function (resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerServerEvent("Core:restartRessource")
    end
end)

RegisterNetEvent('Core:playerLoaded')
AddEventHandler('Core:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

--ESX Infos
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    TriggerServerEvent("Core:AddDiscordContrib")
    PlayerData = xPlayer
    DisplayRadar(false)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job)
    PlayerData.job2 = job
end)

RegisterNetEvent('esx:setService')
AddEventHandler('esx:setService', function(job, service)
    if PlayerData.job.name == job then
        PlayerData.job.service = service
    elseif PlayerData.job2.name == job then
        PlayerData.job2.service = service
    end
end)

-- Désactiver HUD 
local IsHudEnabled = true
RegisterNetEvent('xpiwel:disableHud')
AddEventHandler('xpiwel:disableHud', function(active)
	IsHudEnabled = active
end)

RegisterNetEvent('xpiwel:disableRadar')
AddEventHandler('xpiwel:disableRadar', function(active)
	IsHudEnabled = active
end)

-- Ouvrir Menu Principal
RegisterCommand( "openmenu_principal", function()
    if not ESX.UI.Menu.IsOpen('default', "esx_menuperso", 'menu_perso') then
        ESX.UI.Menu.CloseAll()
        TriggerEvent('NB:openMenuPersonnel')
    else
        ESX.UI.Menu.CloseAll()
    end
end, false)
RegisterKeyMapping( "openmenu_principal", "Ouvrir/Fermer le Menu Principal", "keyboard", Config.keyDefaults.menu_principal)

-- Ouvrir Téléphone
-- local phone_open = false
-- RegisterCommand( "open_phone", function()
-- 	ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
--         if qtty > 0 then
--             TriggerEvent('gcPhone:forceOpenPhone')
--             TriggerEvent('gcphone:IsPhoneOpen', function(phone) 
--                 phone_open = phone
--             end)
--         else
--             phone_open = false
--             Core.Main.ShowNotification("Vous n'avez pas de ~r~téléphone~s~")
--         end
--     end, 'phone')
-- end, false)
-- RegisterKeyMapping( "open_phone", "Ouvrir/Fermer le Téléphone", "keyboard", Config.keyDefaults.phone)

-- Ouvrir Menu Animation
-- RegisterCommand( "openmenu_animation", function()
--     if not ESX.UI.Menu.IsOpen('default', "esx_animations", 'animations') then
--         ESX.UI.Menu.CloseAll()
--         TriggerEvent('esx_animations:OpenAnim')
--     else
--         ESX.UI.Menu.CloseAll()
--     end
-- end, false)
-- RegisterKeyMapping( "openmenu_animation", "Ouvrir/Fermer le Menu Animation", "keyboard", Config.keyDefaults.menu_animation)

-- Changer la distance de voix
--[[RegisterCommand( "voix_distance", function()
    TriggerEvent('update:vocalmode')
end, false)]]
RegisterKeyMapping( "voix_distance", "Changer la distance de voix", "keyboard", Config.keyDefaults.voix_distance)

-- Ouvrir Menu Job
RegisterCommand( "openmenu_job", function()
    if not ESX.UI.Menu.IsOpen('default', "esx_menuperso", 'menuperso_doublejob') then
        ESX.UI.Menu.CloseAll()
        TriggerEvent('NB:OpenDoubleJobMenu')
    else
        ESX.UI.Menu.CloseAll()
    end
end, false)
RegisterKeyMapping( "openmenu_job", "Ouvrir/Fermer le Menu Job", "keyboard", Config.keyDefaults.menu_job)

-- Afficher/Cacher HUD
-- SCN : go to Nebula_hud to see this register key mapping

-- Vehicule Lock
RegisterCommand( "vehicule_lock", function()
    OpenCloseVehicle()
end, false)
RegisterKeyMapping( "vehicule_lock", "Ouvrir/Fermer Véhicule", "keyboard", Config.keyDefaults.vehicule_lock)

-- Coffre Véhicule
-- Handle bu core_inventory

-- Ceinture
-- SCN : go to Nebula_hud to see this register key mapping


-- Régulateur Activer Désactiver
-- SCN : go to Nebula_hud to see this register key mapping


-- Régulateur Monter Vitesse
-- SCN : go to Nebula_hud to see this register key mapping

-- Régulateur Descendre Vitesse
-- SCN : go to Nebula_hud to see this register key mapping

-- Menu Masque
RegisterCommand( "menu_masque", function()
    TriggerEvent('mask:openMenu')
end, false)
RegisterKeyMapping( "menu_masque", "Mettre/Enlever le Masque", "keyboard", Config.keyDefaults.menu_masque)

-- Ouvrir/Fermer Radio
RegisterKeyMapping( "radio", "Ouvrir/Fermer la Radio", "keyboard", Config.keyDefaults.radio)

-- Ouvrir/Fermer Radio
RegisterKeyMapping( "onoffradio", "Mute/Unmute la Radio", "keyboard", Config.keyDefaults.OnOffradio)

-- Mettre speaker radio
RegisterKeyMapping( "onoffspeaker", "Mettre/Enlever haut-parleur de la radio", "keyboard", Config.keyDefaults.Speaker)

-- Ouvrir/Fermer menu stamina
RegisterCommand( "menu_stamina", function()
    TriggerEvent('skill:menuopen')
end, false)
RegisterKeyMapping( "menu_stamina", "Ouvrir/Fermer le Menu Stanima", "keyboard", Config.keyDefaults.menu_stamina)

-- Siren Management
RegisterCommand( "toggleemergencysiren", function()
    TriggerEvent('capri_els:toggle_siren')
end, false)
RegisterKeyMapping( "toggleemergencysiren", "Siren : Allumer/Eteindre les gyrophares", "keyboard", Config.keyDefaults.toggleSiren)

RegisterCommand( "toggleemergencysoundsiren", function()
    TriggerEvent('capri_els:toggle_sound_siren')
end, false)
RegisterKeyMapping( "toggleemergencysoundsiren", "Siren : Allumer/Eteindre la siren", "keyboard", Config.keyDefaults.toggleSoundSiren)

RegisterCommand("changeemergencysoundsiren", function()
    TriggerEvent('capri_els:change_sound_siren')
end, false)
RegisterKeyMapping( "changeemergencysoundsiren", "Siren : Changer le son de la siren", "keyboard", Config.keyDefaults.changeSoundSiren)

RegisterCommand("openmegaphoneemergencymenu", function()
    TriggerEvent('capri_els:open_emergency_voice_menu')
end, false)
RegisterKeyMapping( "openmegaphoneemergencymenu", "Siren : Ouvrir le menu des voix", "keyboard", Config.keyDefaults.openMenuEmergencyVoice)

-- End Siren Management

-- Tablette
-- RegisterCommand( "tablet", function()
--     ESX.TriggerServerCallback('tablet:getItemAmount', function(qtty) 
--         if qtty > 0 then
--             TriggerEvent('yordi:tablet')
--         else
--             Core.Main.ShowNotification("Vous n'avez pas de ~r~téléphone~s~")
--         end
--     end, 'tablet')
-- end, false)
-- RegisterKeyMapping( "tablet", "Ouvrir/Fermer la Tablette", "keyboard", Config.keyDefaults.tablet)

-- -- Enlever/Mettre sirène
-- RegisterCommand( "togglesiren", function()
--     SirenVehicle()
-- end, false)
-- RegisterKeyMapping( "togglesiren", "Activer/Désactiver la sirène", "keyboard", Config.keyDefaults.siren)

-- Pousser Véhicule
RegisterCommand( "vehiclepush", function()
    VehiclePush()
end, false)
RegisterKeyMapping( "vehiclepush", "Pousser un véhicule", "keyboard", Config.keyDefaults.vehiclepush)

RegisterCommand( "creverpneu", function()
    CreverPneu()
end, false)
RegisterKeyMapping( "creverpneu", "Crever Pneu", "keyboard", Config.keyDefaults.creverpneu)

-- Activer Interaction
RegisterCommand( "interaction", function()
    TriggerEvent('ActivateInteract')
	Core.Main.ShowNotification("Intéraction activée")
end, false)
RegisterKeyMapping( "interaction", "Activer les intéractions", "keyboard", Config.keyDefaults.interaction)


--Annonce Special
RegisterNetEvent('Core:MessageMilieu')
AddEventHandler('Core:MessageMilieu', function(title, msg, time, reboot)
    PlaySoundFrontend(-1, "DELETE","HUD_DEATHMATCH_SOUNDSET", 1)
    Core.Main.MessageMilieu(title, msg, time)
    if reboot then
        SetWeatherTypePersist("HALLOWEEN")
        SetWeatherTypeNowPersist("HALLOWEEN")
        SetWeatherTypeNow("HALLOWEEN")
        SetOverrideWeather("HALLOWEEN")
    end
end)

--Annonce Journaliste
RegisterNetEvent('Core:MessageLifeInvader')
AddEventHandler('Core:MessageLifeInvader', function(x, y , w, h, sc, text, r, g, b, a, font, jus)
    PlaySoundFrontend(-1, "DELETE","HUD_DEATHMATCH_SOUNDSET", 1)
    Core.Main.DrawRectangleAnnounce(x, y , w, h, sc, text, r, g, b, a, font, jus, 1000)
end)

--Mode Cinématique
RegisterNetEvent('GMz:cinema')
AddEventHandler('GMz:cinema', function(tg)
	SendNUIMessage({openCinema = tg})
end)

--Progress Bar
RegisterNetEvent('progressBar:drawBar')
AddEventHandler('progressBar:drawBar', function(IsEnable, time, text, cb, options)
	Core.Main.DrawBar(IsEnable, time, text, cb, options)
end)

--Core.Main.ShowNotification
RegisterNetEvent('Core:ShowNotification')
AddEventHandler('Core:ShowNotification', function(msg, flash, saveToBrief, hudColorIndex)
	Core.Main.ShowNotification(msg, flash, saveToBrief, hudColorIndex)
end)

--ShowAdvancedNotification
RegisterNetEvent('Core:ShowAdvancedNotification')
AddEventHandler('Core:ShowAdvancedNotification', function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
    Core.Main.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
end)

--SetActivityDiscord
RegisterNetEvent('Discord:SetActivity')
AddEventHandler('Discord:SetActivity', function(NumPlayers)
    local IPPORT = GetCurrentServerEndpoint()
    local IP = 'fivem://connect/wl.nebularp.com'
    SetDiscordAppId(901580579567435847)
    SetDiscordRichPresenceAsset('nebula')
    SetDiscordRichPresenceAssetText("🌌 Nebula RP")
    SetDiscordRichPresenceAssetSmall('discord')
    SetDiscordRichPresenceAssetSmallText("discord.gg/nebularp")
    if playerID then
        SetRichPresence(GetPlayerName(playerID) .. " - " .. NumPlayers .. "/300 joueurs")
    else
        SetRichPresence(NumPlayers .. "/300 joueurs")
    end
    SetDiscordRichPresenceAction(0, "Rejoindre la partie", IP)
    SetDiscordRichPresenceAction(1, "Rejoindre NebulaRP", 'https://discord.gg/nebularp')
end)

--Density npc
RegisterNetEvent('DensityNPC')
AddEventHandler('DensityNPC', function(taille, taillePieton)
    if taille == 100 or taille then
        Config.density.densityGlobal = 1.00
    elseif taille == 0 then
        Config.density.densityGlobal = 0.00
    else
        Config.density.densityGlobal = taille / 100
	end
	if taillePieton then
		Config.density.densityPieton = 1.0
	else
		Config.density.densityPieton = 0.0
	end
end)

local CollisionDisabled = false
local function DisablePlayerCollisions()
    CollisionDisabled = not CollisionDisabled
    
    FreezeEntityPosition(playerPed, CollisionDisabled)
    SetEntityCollision(playerPed, not CollisionDisabled, not CollisionDisabled)
end
RegisterCommand('piwelcolli', DisablePlayerCollisions, false)

--Changement Nom Menu
local function ChangeNameMenu()
	Core.Main.AddTextEntry('FE_THDR_GTAO', '~o~[Nebula] ~c~discord.gg/nebularp')
    Core.Main.AddTextEntry('PM_PANE_LEAVE', 'Retourner sur la liste des serveurs')
    Core.Main.AddTextEntry('PM_PANE_QUIT', '~r~Aller dormir ?')
    Core.Main.AddTextEntry("PM_PANE_CFX", "Nebula")
end

--Affich DateTime
local function AffichDateTime()
    SetTextScale(0.0, 0.22)
    SetTextColour(255, 255, 255, 200)
    SetTextEntry("STRING")
    AddTextComponentString("Nebula " .. ((days <= 9 and "0" .. days) or days) .. "/" .. ((months <= 9 and "0" .. months) or months) .. "/" .. years .. " " .. ((hours <= 9 and "0" .. hours) or hours) .. ":" .. ((minutes <= 9 and "0" .. minutes) or minutes))
    DrawText(-0.000, -0.000)
end

--Pas de reticule
local TabExeptionAuthorizeReticuleWeapon = {
    100416529,
    205991906,
    -952879014,
    177293209
}
local function NoReticuleWeapon()
    if Core.Weapon.CanUseWeapon(currentWeaponHash, TabExeptionAuthorizeReticuleWeapon) then
        return
    end
    HideHudComponentThisFrame(14)
end

--Pas de coup de cross
local function NoCross()
    if IsPedArmed(playerPed, 6) then
        DisableControlAction(1, 140, true)
        DisableControlAction(1, 141, true)
        DisableControlAction(1, 142, true)
    end
end

--KO
local function KoMelee()
    if entityhealth < 115 and IsPedInMeleeCombat(playerPed) then
        SetPlayerInvincible(playerID, true)
        DisablePlayerFiring(playerID, true)
        Core.Main.ShowNotification("~r~Tu es KO!")
        SetPedToRagdoll(playerPed, 10000, 10000, 0, 0, 0, 0)
        Citizen.Wait(10000)
        SetPlayerInvincible(playerID, false)
        SetEntityHealth(playerPed, 175)
    end
end

--NoDropWeaponPnj
local TabNoWeaponDrop = {
    GetHashKey('PICKUP_WEAPON_CARBINERIFLE'), -- M4
    GetHashKey('PICKUP_WEAPON_PISTOL'), -- PISTOL 9mm
    GetHashKey('PICKUP_WEAPON_PUMPSHOTGUN'), -- Pompe
    GetHashKey('PICKUP_WEAPON_CARBINERIFLE_MK2') -- MK MK2
}
local function NoDropWeaponPnj()
    for k, v in pairs(TabNoWeaponDrop) do
        RemoveAllPickupsOfType(v)
    end
end

--density npc
local function NpcTrafic()
    if Config.density.IsEnable then
        SetPedDensityMultiplierThisFrame(Config.density.densityPieton) -- 0.1 = 1 ped pieton par joueur 
        SetRandomVehicleDensityMultiplierThisFrame(Config.density.densityGlobal) -- set random vehicles (car scenarios / cars driving off from a parking spot etc.) to 0
        SetScenarioPedDensityMultiplierThisFrame(Config.density.densityGlobal, Config.density.densityGlobal) -- set random npc/ai peds or scenario peds to 0
        SetParkedVehicleDensityMultiplierThisFrame(Config.density.densityGlobal)
        SetAmbientPedRangeMultiplierThisFrame(Config.density.rangeDensity) -- Set la range de despawn
        SetVehicleDensityMultiplierThisFrame(Config.density.densityGlobal)
    end
end

local function NpcOther(densityGlobal)
    if Config.density.IsEnable then
        local VariableNPCOther = (densityGlobal == 0 and true) and false
        SetGarbageTrucks(VariableNPCOther) -- Stop garbage trucks from randomly spawning
        SetRandomBoats(VariableNPCOther) -- Stop random boats from spawning in the water.
        SetCreateRandomCops(VariableNPCOther) -- disable random cops walking/driving around.
        SetCreateRandomCopsNotOnScenarios(VariableNPCOther) -- stop random cops (not in a scenario) from spawning.
        SetCreateRandomCopsOnScenarios(VariableNPCOther) -- stop random cops (in a scenario) from spawning.
    end
end

--CalmAI
local TabCalmAI = {
    playerHash = GetHashKey('PLAYER'),
    relationshipTypes = {
        GetHashKey('PLAYER'), 
        GetHashKey('CIVMALE'), 
        GetHashKey('CIVFEMALE'), 
        GetHashKey('GANG_1'), 
        GetHashKey('GANG_2'), 
        GetHashKey('GANG_9'), 
        GetHashKey('GANG_10'), 
        GetHashKey('AMBIENT_GANG_LOST'), 
        GetHashKey('AMBIENT_GANG_MEXICAN'), 
        GetHashKey('AMBIENT_GANG_FAMILY'), 
        GetHashKey('AMBIENT_GANG_BALLAS'), 
        GetHashKey('AMBIENT_GANG_MARABUNTE'), 
        GetHashKey('AMBIENT_GANG_CULT'), 
        GetHashKey('AMBIENT_GANG_SALVA'), 
        GetHashKey('AMBIENT_GANG_WEICHENG'), 
        GetHashKey('AMBIENT_GANG_HILLBILLY'), 
        GetHashKey('DEALER'), 
        GetHashKey('COP'), 
        GetHashKey('PRIVATE_SECURITY'), 
        GetHashKey('SECURITY_GUARD'), 
        GetHashKey('ARMY'), 
        GetHashKey('MEDIC'), 
        GetHashKey('FIREMAN'), 
        GetHashKey('HATES_PLAYER'), 
        GetHashKey('NO_RELATIONSHIP'), 
        GetHashKey('SPECIAL'), 
        GetHashKey('MISSION2'), 
        GetHashKey('MISSION3'), 
        GetHashKey('MISSION4'), 
        GetHashKey('MISSION5'), 
        GetHashKey('MISSION6'), 
        GetHashKey('MISSION7'), 
        GetHashKey('MISSION8')
    }
}
local function CalmAI()
    for k, v in pairs(TabCalmAI.relationshipTypes) do
        SetRelationshipBetweenGroups(1, v, TabCalmAI.playerHash)
    end
end

--ClearPedArea
local function CleanAreaOfPeds()
    for k, v in pairs(Config.ClearPed) do
        if v.ClearPed then
            ClearAreaOfPeds(v.x, v.y, v.z, v.Distance, v.Flags)
        end
    end
end

--ClearAreaVehicle
local function ClearAreaVehicles()
    for k, v in pairs(Config.CleanZone) do
        if v.ClearArea then
            ClearAreaOfVehicles(v.x, v.y, v.z, v.Distance, false, false, false, false, false)
        end
        RemoveVehiclesFromGeneratorsInArea(v.x - v.Distance, v.y - v.Distance, v.z - v.Distance, v.x + v.Distance, v.y + v.Distance, v.z + v.Distance)
    end
end

--Taser effect
local function TaserEffect()
    while true do
        if IsPedBeingStunned(playerPed) then
            SetPedToRagdoll(playerPed, 12000, 12000, 0, 0, 0, 0) 
        end
        if IsPedBeingStunned(playerPed) and not isTaz then
            isTaz = true
            TriggerEvent('xPiwel_skin:NoStopAnim', true)
            SetTimecycleModifier("REDMIST_blend")
            ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0) 
        elseif not IsPedBeingStunned(playerPed) and isTaz then 
            isTaz = false
            Wait(5000)
            SetTimecycleModifier("hud_def_desat_Trevor")
            Wait(10000)
            SetTimecycleModifier("")
            SetTransitionTimecycleModifier("")
            StopGameplayCamShaking()
            TriggerEvent('xPiwel_skin:NoStopAnim', false)
            break
        end
        Wait(10)
    end
end

--spawn trains
local function SpawnTrain()
    SwitchTrainTrack(0, true)
    SwitchTrainTrack(3, true)
    N_0x21973bbf8d17edfa(0, 120000)
    SetRandomTrains(1)
end

--Disable Vehicle
local function DisableVehicleCirculation()
    local TabVehicle = {
        2046537925,  --police
        -1627000575,  --police2
        1912215274,  --police3
        -1973172295,  --police4
        353883353, --polmav
        -1683328900, --sheriff
        744705981, --frogger
        1949211328 --frogger2
    }
    for k, v in pairs(TabVehicle) do
        SetVehicleModelIsSuppressed(v, true)
    end
end

local function DisableHelmetAndSeatShuffle()
    local playerPedId = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPedId, false)
    local model = GetEntityModel(vehicle) or nil

    -- Disable auto helmet on bike and quadbike
    if IsPedOnAnyBike(playerPedId) or (IsThisModelAQuadbike(model) or nil) then 
        SetPedConfigFlag(playerPedId, 35, false)
    end  
    -- Disable Seat Shuffle
    SetPedConfigFlag(playerPedId, 184, true)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Thread et boucle
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Boucle Unique
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    -- TriggerServerEvent('persistent-vehicles/new-player') 
    OnSpawnDoorLock()
    --SpawnTrain() -- Possiblement la cause de passages sous maps. A confirmer. 
    CalmAI()
    ChangeNameMenu()
    CreatePedPos()
    BlipPos()
    NpcOther(Config.density.densityGlobal)
    PositionAction()
end)

local hud_active = false
--Qui a besoin de while pour opti
Citizen.CreateThread(function()
    while true do Citizen.Wait(1000)
        if currentVeh == 0 and not menuIsOpen then
            DisplayRadar(false)
        end
        while currentVeh ~= 0 or IsWeapon do
            if IsWeapon then
                -- NoReticuleWeapon()
                NoCross()
            end
    
            if currentVeh ~= 0 then
                StopBasicSirenVehicle(currentVeh)
                NotShuffle(currentVeh)
                if IsHudEnabled then
                    DisplayRadar(true)
                end
            else
                DisplayRadar(menuIsOpen)
            end
    
            Wait(0)
        end
    end
end)

AddEventHandler('high_phone:openPhone', function()
    menuIsOpen = true
    DisplayRadar(menuIsOpen)
end)

AddEventHandler('high_phone:closePhone', function()
    menuIsOpen = false
    DisplayRadar(menuIsOpen)
end)

--Boucle 0 secondes
-- Citizen.CreateThread(function()
--     while true do Citizen.Wait(0)
--         --Native
--         -- DisablePlayerVehicleRewards(playerID)
--         -- ClearPlayerWantedLevel(playerID)
        
--         --Function Custom
--         -- NoDropWeaponPnj()
--         -- KoMelee()
--         -- AffichDateTime()
--         --NpcTrafic()
--         -- NoReticuleWeapon()
--         --SetVehicleDoorEnter()
--         -- NoCross()
--         -- NotShuffle()
--         --DisableVehicleCirculation()
--         -- StopBasicSirenVehicle()	
--     end
-- end)

--Boucle 10 millisecondes
Citizen.CreateThread(function()
    while true do Citizen.Wait(0)
        DisablePlayerVehicleRewards(playerID)
        NoDropWeaponPnj()
        AffichDateTime()
        KoMelee()
        LogShooting()
        LogDead()
        DisableHelmetAndSeatShuffle()   
        if IsPedBeingStunned(playerPed) then
            TaserEffect()
        end
        CleanAreaOfPeds()
        ClearAreaVehicles()
    end
end)

--Boucle 1 secondes
Citizen.CreateThread(function()
    while true do
        --variable
        playerID = PlayerId()
        playerServID = GetPlayerServerId(playerID)
        playerPed = PlayerPedId()
        coords = GetEntityCoords(playerPed)
        IsWeapon, currentWeaponHash = GetCurrentPedWeapon(playerPed)
        currentVeh = GetVehiclePedIsIn(playerPed)
        entityhealth = GetEntityHealth(playerPed)

        --function
        Citizen.Wait(1000)
    end
end)

--Boucle 3 secondes
Citizen.CreateThread(function()
    while true do Citizen.Wait(3000)
        ClearPlayerWantedLevel(playerID)

        --Function Custom
        -- ExitVehicle()
	end
end)

--Boucle 10 secondes
-- Citizen.CreateThread(function()
--     while true do Citizen.Wait(10000)
--         --Function Custom
        
-- 	end
-- end)

--Boucle 30 secondes
-- Citizen.CreateThread(function()
--     while true do Citizen.Wait(30000)
--         --Native
--         --RemoveVehiclesFromGeneratorsInArea(coords.x - 700.0, coords.y - 700.0, coords.z - 700.0, coords.x + 700.0, coords.y + 700.0, coords.z + 700.0)

--         --Function Custom
--         --DisableVehicleCirculation()
--         --CleanAreaOfPeds()
--         --ClearAreaVehicles()
-- 	end
-- end)

--Boucle 60 secondes
Citizen.CreateThread(function()
    while true do 
        years, months, days, hours, minutes, seconds = Core.Main.CalculateDateTime()

        CheckNameJob()
        --RichPrecenseDiscord()
        --Core.Weapon.ZoneSafe(false)
        Citizen.Wait(60000)
	end
end)

--A retirer lorsque la native RemoveAllPickupsOfType fonctionnera
-- Citizen.CreateThread(function()
--     while true do
--         local handle, ped = FindFirstPed()
--         repeat
--             if not IsEntityDead(ped) then
--                 SetPedDropsWeaponsWhenDead(ped, false)
--             end
--             Wait(100)
--         until not FindNextPed(handle)

--         EndFindPed(handle)
--     end
-- end)
