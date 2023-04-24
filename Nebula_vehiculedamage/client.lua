local Player, Vehicule, PlayerVehicule, PlayerVehiculeLastBodyHealth, PlayerVehiculeLastEngineHealth = nil, nil, nil,
    nil, nil

local ReferenceWeaponDamage = nil

AddEventHandler('playerSpawned', function()
    SetPlayer()
    ReferenceWeaponDamage = GetWeaponDamage(Config.ReferencePistolHash)
end)

-- If enter vehicule and is the driver we set the player vehicule to calculate
-- domage when vehicule it entity (object, cars, wall etc)
RegisterNetEvent("Nebula_vehiculedamage:playerEnteredVehicule")
AddEventHandler("Nebula_vehiculedamage:playerEnteredVehicule", function()
    print('entered')
    if CheckPlayer() then
        print('playercheck')
        local vehicule = GetVehiclePedIsIn(Player, false)
        print('vehicule found', vehicule, 'is driver', IsDriver(vehicule))
        if IsDriver(vehicule) then
            PlayerVehicule = vehicule
            PlayerVehiculeLastBodyHealth = GetVehicleBodyHealth(PlayerVehicule)
            PlayerVehiculeLastEngineHealth = GetVehicleEngineHealth(PlayerVehicule)
        end
    end
end)

RegisterNetEvent("Nebula_vehiculedamage:playerLeftVehicle")
AddEventHandler("Nebula_vehiculedamage:playerLeftVehicle", function()
    print('left')
    PlayerVehicule = nil
    PlayerVehiculeLastBodyHealth = nil
    PlayerVehiculeLastEngineHealth = nil
    Vehicule = nil
end)

local count = 0;
-- TODO TO REMOVE
-- Citizen.CreateThread(function()
--     while true do
--         if Vehicule ~= nil and Vehicule > 0 then
--             local vehiculeBodyHealth = GetVehicleBodyHealth(Vehicule)
--             local vehiculeEngineHealth = GetVehicleEngineHealth(Vehicule)
--             local vehiculeFuelTankHealth = GetVehiclePetrolTankHealth(Vehicule)
--             print("Vehicule body health :", vehiculeBodyHealth, "engine ", vehiculeEngineHealth, "tank",
--                 vehiculeFuelTankHealth, "entity", GetEntityHealth(Vehicule))
--         end
--         print("count", count)
--         Citizen.Wait(1000)
--     end
-- end)

AddEventHandler('gameEventTriggered', function(name, args)
    print('game event from vd in vehicle damage' .. name .. ' (' .. json.encode(args) .. ')')
    if name == "CEventNetworkEntityDamage" then
        local victim = args[1]
        local attacker = args[2]
        local entityType = GetEntityType(victim)
        print("Victim :", victim, "attacker :", attacker, 'entitytype', entityType)

        -- 0 = no entity, 1 = ped, 2 = vehicle, 3 = object
        if entityType == 2 then
            print("entity is vehicule")
            SetPlayer()
            print('isInVehicule', IsInVehicule())
            if IsInVehicule() then
                SetPlayerVehicule()
                print('player vehicule', Vehicule)
                if Vehicule ~= nil then
                    print("player in vehicule")
                    -- Is Driver or No one drive and it's the next (or only) passenger                   
                    if IsDriver() or (not SomeoneIsDriver() and isTheNextFirstPassenger()) then
                        print("player driver or other passenger")
                        local damageIsMele = args[12]
                        local damageLocation = args[13]
                        local weaponHash = args[7]
                        CalculateDamage(weaponHash, damageIsMele, damageLocation)
                    end
                end
            elseif IsAttacker(attacker) then
                count = count + 1
                print("player is attacker")
                local vehiculeDriver = vehiculeHasPedIn(victim)
                -- if the car hit is occuped by an npc
                if vehiculeDriver ~= nil and vehiculeDriver > 0 and not IsPedAPlayer(vehiculeDriver) then
                    SetVehicle(victim)
                    print("car occupe npc")
                    local damageIsMele = args[12]
                    local damageLocation = args[13]
                    local weaponHash = args[7]
                    CalculateDamage(weaponHash, damageIsMele, damageLocation)
                    -- if no one is in the car
                elseif vehiculeDriver == nil or vehiculeDriver <= 0 then
                    SetVehicle(victim)
                    print("no one in car", Vehicule)
                    local damageIsMele = args[12]
                    local damageLocation = args[13]
                    local weaponHash = args[7]
                    CalculateDamage(weaponHash, damageIsMele, damageLocation)
                end
            end
        end
    end
end)

-- Business

function CalculateDamage(weaponHash, damageIsMele, damageLocation)
    print('launch calculate damage')
    -- local vehiculeBodyHealth = GetVehicleBodyHealth(Vehicule)
    -- local vehiculeEngineHealth = GetVehicleEngineHealth(Vehicule)
    -- local vehiculeFuelTankHealth = GetVehiclePetrolTankHealth(Vehicule)
    -- print("Vehicule body health :", vehiculeBodyHealth, "engine ", vehiculeEngineHealth, "tank", vehiculeFuelTankHealth)
    -- print(GetEntityHealth(Vehicule))

    -- -- SetVehicleBodyHealth(Vehicule, 1000)
    -- -- SetVehiclePetrolTankHealth(Vehicule, 1000)
    -- -- SetVehicleEngineHealth(Vehicule, 1000)
    -- -- SetVehicleFixed(Vehicule)

    -- -- Fist / foot damage are insane (trigger event 3/4 times)
    -- -- Restore health minus the real mele damage from config
    -- if damageIsMele > 0 then
    --     if Config.FistWeaponHash == weaponHash then
    --         local weaponDamage = Config.FistWeaponDamage
    --         local newDamage = Config.NewMeleWeaponDamage
    --         local restoreDamage = weaponDamage - newDamage
    --         vehiculeBodyHealth = GetVehicleBodyHealth(Vehicule)
    --         SetVehicleBodyHealth(Vehicule, vehiculeBodyHealth + restoreDamage)

    --         -- if is mele but not fist, restore health minus the real mele damage from config
    --     else
    --         local weaponDamage = Config.MeleWeaponDamage
    --         local newDamage = Config.NewMeleWeaponDamage
    --         local restoreDamage = weaponDamage - newDamage
    --         vehiculeBodyHealth = GetVehicleBodyHealth(Vehicule)
    --         SetVehicleBodyHealth(Vehicule, vehiculeBodyHealth + restoreDamage)
    --     end

    -- elseif damageLocationIsNotEngine(damageLocation) then
    --     CheckReferenceDamage()
    --     local weaponDamage = GetWeaponDamage(weaponHash)
    --     local newDamage = Config.MaxVehiculeHealthBeforeDisable / Config.MaxNumberOfBulletNeedToDisableVehicule
    --     local weaponDeltaBetweenReference = weaponDamage - ReferenceWeaponDamage

    --     print("weapon delta ref", weaponDeltaBetweenReference)
    --     if weaponDeltaBetweenReference > 0 then
    --         newDamage = newDamage + weaponDeltaBetweenReference
    --     end

    --     local restoreDamage = weaponDamage - newDamage

    --     vehiculeBodyHealth = GetVehicleBodyHealth(Vehicule)
    --     SetVehicleBodyHealth(Vehicule, vehiculeBodyHealth + restoreDamage)
    -- elseif weaponHash == Config.RammedByCarHash then
    --     print("hit something")
    --     -- if In Vehicule and it is always the driver
    --     -- we calculate the damage with this player
    --     if CheckPlayerVehicule() and IsDriver(PlayerVehicule) then
    --         local vehiculeClass = GetVehicleClass(PlayerVehicule)
    --         local vehiculeBodyHealth = GetVehicleBodyHealth(PlayerVehicule)
    --         local vehiculeEngineHealth = GetVehicleEngineHealth(PlayerVehicule)
    --         local lastTotalHealthVehicule = PlayerVehiculeLastBodyHealth + PlayerVehiculeLastEngineHealth
    --         local totalVehiculeHealth = vehiculeBodyHealth + vehiculeEngineHealth
    --         local deltaDamage = lastTotalHealthVehicule - totalVehiculeHealth
    --         local damageMultiplicator = Config.VehiculeClassDomageMultiplicator[vehiculeClass]

    --         print('damagemulti', damageMultiplicator)
    --         if damageMultiplicator ~= nil then
    --             local realDamageToApply = deltaDamage * damageMultiplicator
    --             print('realDamageToApply', realDamageToApply)

    --             if realDamageToApply < deltaDamage then
    --                 print('Add health')
    --                 SetVehicleBodyHealth(PlayerVehicule, vehiculeBodyHealth + realDamageToApply)
    --             elseif realDamageToApply > deltaDamage then
    --                 local missingDamage = realDamageToApply - deltaDamage
    --                 print('substract health', missingDamage)
    --                 SetVehicleBodyHealth(PlayerVehicule, vehiculeBodyHealth - missingDamage)
    --             end
    --         end

    --         PlayerVehiculeLastBodyHealth = GetVehicleBodyHealth(PlayerVehicule)
    --         PlayerVehiculeLastEngineHealth = GetVehicleEngineHealth(PlayerVehicule)

    --     end
    --     print(GetEntitySpeed(Vehicule))
    -- else
    --     -- verify if is 1 or 2 event distinct
    --     -- when hitting engine (body and engine are substract, restore body with new damage )
    --     local weaponDamage = GetWeaponDamage(weaponHash)
    --     local newDamage = Config.MaxVehiculeHealthBeforeDisable / Config.MaxNumberOfBulletNeedToDisableVehicule

    --     print('not know', weaponDamage, newDamage, vehiculeBodyHealth)
    --     vehiculeBodyHealth = GetVehicleBodyHealth(Vehicule)
    --     SetVehicleBodyHealth(Vehicule, vehiculeBodyHealth + weaponDamage)
    -- end

    SetVehiculeState()

    -- 56 ???
    -- Check when engine is damage event 
    -- if damageLocation == ?? then

    -- end
end

function SetVehiculeState()
    -- Set Vehicule state
    local vehiculeBodyHealth = GetVehicleBodyHealth(Vehicule)
    local vehiculeEngineHealth = GetVehicleEngineHealth(Vehicule)

    local vehiculeTotalHealth = vehiculeBodyHealth + vehiculeEngineHealth
    local vehiculeDamageDelta = Config.MaxVehiculeDefaultHealth - vehiculeTotalHealth

    if vehiculeDamageDelta >= Config.MaxVehiculeHealthBeforeLockSpeed and vehiculeDamageDelta <
        Config.MaxVehiculeHealthBeforeDisable then
        print('delta >= maxconfigdelta 120')
        local actualSpeed = GetEntitySpeed(Vehicule)
        if actualSpeed <= 1 / 3.9 then
            -- Vehicule need to 'moove' to enable maxspeed
            SetVehicleForwardSpeed(Vehicule, 0.5 / 3.6)
        end
        -- SetVehicleCheatPowerIncrease check for tork like capri say
        -- lock speed of vehicule
        SetVehicleMaxSpeed(Vehicule, Config.MaxSpeedWhenLock / 3.9)

    elseif vehiculeDamageDelta >= Config.MaxVehiculeHealthBeforeDisable then
        print('delta >= maxconfigdelta 150')
        SetVehicleBodyHealth(Vehicule, 400+0.0)
        SetVehicleEngineHealth(Vehicule, 100+0.0)
        SetVehicleUndriveable(Vehicule, true)
        print('call export')
        exports["Nebula_hud"]:SetVehicleDommageBlinker()
    end

end

-- Get Vehicule health Status
-- --1 : Error
-- 0 : fine => healthDelta <= Config.MaxVehiculeHealthBeforeLockSpeed / 2
-- 1 : mid => healthDelta >= Config.MaxVehiculeHealthBeforeLockSpeed / 2
-- 2 : Critical => healthDelta >= Config.MaxVehiculeHealthBeforeLockSpeed
-- 3 : undrivable => healthDelta >= Config.MaxVehiculeHealthBeforeDisable
function GetVehiculeHealthStatus()
    if not CheckPlayer() then
        SetPlayer()
    end
    SetPlayerVehicule();
    
    if CheckVehicule() then

        SetVehiculeState()

        local vehiculeBodyHealth = GetVehicleBodyHealth(Vehicule)
        local vehiculeEngineHealth = GetVehicleEngineHealth(Vehicule)
        local vehiculeTotalHealth = vehiculeBodyHealth + vehiculeEngineHealth
        local vehiculeDamageDelta = Config.MaxVehiculeDefaultHealth - vehiculeTotalHealth
        -- TODO TO REACTIVE WHEN WORK ON DAMAGE print("in get", vehiculeBodyHealth, vehiculeEngineHealth, vehiculeDamageDelta)
        print('Vehicle delta helth', vehiculeDamageDelta)
        if vehiculeDamageDelta < Config.GoodLimit then
            return 0
        elseif vehiculeDamageDelta >= Config.MiddleLimit and vehiculeDamageDelta < Config.CriticalLimit then
            return 1
        elseif vehiculeDamageDelta >= Config.CriticalLimit and vehiculeDamageDelta < Config.UndrivableLimit then
            return 2
        elseif vehiculeDamageDelta > Config.UndrivableLimit then
            return 3
        end
    end
    -- player not in vehicule or error on delta damage
    return -1
end

-- HELPERS

function SetPlayer()
    if not CheckPlayer() then
        Player = GetPlayerPed(-1)
    end
end

function CheckPlayer()
    return Player ~= nil and Player > 0
end

function CheckPlayerVehicule()
    return PlayerVehicule ~= nil and PlayerVehicule > 0
end

function IsAttacker(entityId)
    return Player == entityId
end

function SetPlayerVehicule()
    if CheckPlayer() then
        Vehicule = GetVehiclePedIsIn(Player, false)
    end
end

function CheckVehicule()
    return Vehicule ~= nil and Vehicule > 0
end

function SetVehicle(entityId)
    Vehicule = entityId
end

function IsInVehicule()
    if CheckPlayer() then
        return IsPedInAnyVehicle(Player, true)
    end
    return false
end

function IsDriver(vehicule)
    if CheckPlayer() then
        local driver = nil
        if vehicule ~= nil and vehicule > 0 then
            driver = GetPedInVehicleSeat(Vehicule, -1)
        end
        driver = GetPedInVehicleSeat(Vehicule, -1)
        return driver == Player
    end
    return false
end

function SomeoneIsDriver()
    local driver = GetPedInVehicleSeat(Vehicule, -1)
    return driver ~= nil and driver > 0
end

function isTheNextFirstPassenger()
    for i = 0, 6, 1 do
        local passenger = GetPedInVehicleSeat(Vehicule, i)
        if passenger ~= nil and passenger > 0 then
            return passenger == Player
        end
    end
    return false
end

function vehiculeHasPedIn(vehicule)
    for i = -1, 6, 1 do
        local passenger = GetPedInVehicleSeat(vehicule, i)
        if passenger ~= nil and passenger > 0 then
            return passenger
        end
    end
    return nil
end

function damageLocationIsNotEngine(damageLocation)
    -- 116 = vehicule body
    -- 93 = vehicule tire
    -- 120 = sidewindow
    -- 121 = rear window
    -- 122 windscreen
    return damageLocation == 116 or damageLocation == 93 or damageLocation == 120 or damageLocation == 121 or
               damageLocation == 122
end

function CheckReferenceDamage()
    if ReferenceWeaponDamage == nil then
        ReferenceWeaponDamage = GetWeaponDamage(Config.ReferencePistolHash)
    end
end
