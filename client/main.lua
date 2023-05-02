ESX = nil

cid = 'nil'
inventoryOpened = true
Settings = nil
Items = nil

-- PROPS
spawnedProps = {}

-- CAMERAS
cam = nil
cam2 = nil
trackMode = nil
trackEntity = nil
trackOffset = nil
trackCam = false

-- PLAYER SHOWCASE
playerZoomed = false
playerModel = nil

-- TRUNK
trunkOpened = false

-- WEAPON SHOWCASE
weaponZoomed = false
weaponObject = nil
weaponRotation = nil
weaponID = nil
weaponBox = nil

-- WEAPONS
currentWeapon = nil
currentWeaponInventory = nil
currentWeaponData = nil

-- HOLDERS
Holders = {}

-- DROPS
Drops = {}
DropsProps = {}

-- EXTERNAL
ExternalInventories = {}

-- BACKPACKS
currentBackpack = nil

-- KEYBINDS
Keybinds = {}

Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    -- ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118,
    ["6"] = 159,
    ["-"] = 159,
    ["7"] = 161,
    ["È"] = 161,
    ["3"] = 160,
    ['"'] = 160,
    ["8"] = 162,
    ["_"] = 162,
    ["9"] = 163,
    ["Ç"] = 163,
    ["4"] = 164,
    ["'"] = 164,
    ["5"] = 165,
    ["("] = 165
}

-- CUSTOM ADDON 
KeyMapping = {
    [3] = '"',
    [4] = "'",
    [5] = "(",
    [6] = "-",
    [7] = "È",
    [8] = "_",
    [9] = "Ç",
}

Citizen.CreateThread(function()

    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(31)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    while ESX.GetPlayerData().identifier == nil do
        Citizen.Wait(10)
    end

    TriggerServerEvent('core_inventory:server:loadInventory')

    SetWeaponsNoAutoswap(true)
    while true do

        local ped = PlayerPedId()
        job = ESX.GetPlayerData().job.name
        grade = ESX.GetPlayerData().job.grade
        cid = ESX.GetPlayerData().identifier
        cid = cid:gsub(":", "")

        Wait(1000)

        if Config.SyncBackpacks then
            ESX.TriggerServerCallback('core_inventory:server:getBackpacks', function(backpacks)
                local found = false

                for k, v in pairs(backpacks) do

                    if currentBackpack == k then
                        found = true
                    end

                    if currentBackpack == nil then
                        found = true
                        currentBackpack = k
                        SetPedComponentVariation(ped, 5, v.backpackModel, v.backpackTexture, 0)
                    end

                end

                if not found then

                    currentBackpack = nil
                    SetPedComponentVariation(ped, 5, 0, 0, 0)

                end
            end)
        end

        if playerModel and not inventoryOpened then
            ExecuteCommand('showped')
        end

        if IsPedInAnyVehicle(ped, false) and currentWeapon ~= nil then
            currentWeapon = nil
            currentWeaponData = nil
            currentWeaponInventory = nil
        end
    end

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(j)
    job = j.name
    grade = j.grade
end)

RegisterNetEvent('core_inventory:client:setSettings', function(settings, items)

    Settings = settings
    Items = items
    inventoryOpened = false

end)

RegisterNetEvent('esx:playerLoaded', function()

    Citizen.Wait(2000)
    TriggerServerEvent('core_inventory:server:loadInventory')

    -- SETUP STORAGE PROPS
    for k, v in pairs(Config.Storage) do
        if v.prop ~= nil then
            prop = CreateObject(GetHashKey(v.prop), v.coords, false, true, false)
            table.insert(spawnedProps, prop)
        end
    end

    Citizen.Wait(5000)
    SetScratchCard()
end)

AddEventHandler('playerDropped', function(reason)
    if playerModel then
        DeleteEntity(playerModel)
    end
end)

RegisterKeyMapping('inv', 'Ouvrir l\'inventaire', 'keyboard', Config.OpenKey)
RegisterKeyMapping('primary', 'Arme principale', 'keyboard', '1')
RegisterKeyMapping('secondry', 'Arme secondaire', 'keyboard', '2')
RegisterKeyMapping('tertiary', 'Arme tertiaire', 'keyboard', '3')

-- DROP LOOP 
Citizen.CreateThread(function()

    while true do

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if next(Drops) ~= nil then
            -- DROPS
            for k, v in pairs(Drops) do

                if #(v.coords - coords) < Config.DropShowDistance then

                    DrawMarker(2, v.coords[1], v.coords[2], v.coords[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15,
                        217, 17, 90, 155, false, false, false, 1, false, false, false)

                end

            end

        else
            for k, v in pairs(Config.Storage) do
                if #(v.coords - coords) < Config.DropShowDistance then
                    if v.prop ~= nil then
                        DrawMarker(2, v.coords[1], v.coords[2], v.coords[3] + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 245, 245, 245, 155, false, false, false, 1, false, false, false)
                    else
                        DrawMarker(2, v.coords[1], v.coords[2], v.coords[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 245, 245, 245, 155, false, false, false, 1, false, false, false)
                    end
                end
            end
        end

        BlockWeaponWheelThisFrame()
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 199, true)
        Citizen.Wait(0)
    end

end)

Citizen.CreateThread(function()
    while true do
        if DropsProps ~= nil and #DropsProps > 0 then
            local entryToDelete = { }
            for i = 1, #DropsProps, 1 do
                if Drops[DropsProps[i].name] == nil then
                    SetEntityAsMissionEntity(DropsProps[i].props)
                    DeleteEntity(DropsProps[i].props)
                    table.insert(entryToDelete, { name =  DropsProps[i].name, index = i })
                end
            end
            for index, value in ipairs(entryToDelete) do
                table.remove(DropsProps, value.index)
            end
        end
        Citizen.Wait(5000)
    end
end)

for i = 4, 9 do
    RegisterCommand('slot' .. i, function()
        if not IsPauseMenuActive() and not inventoryOpened and not IsNuiFocused() then
            for k, v in pairs(Keybinds) do
                if tostring(k) == tostring(KeyMapping[i]) or tostring(k) == Keys[tostring(i)] then
                    if not inventoryOpened and not IsNuiFocused() then
                        TriggerServerEvent('core_inventory:server:useItem',v.item, v.exact)
                    end
                end

            end
        end
    end)
    RegisterKeyMapping('slot' .. i, 'Utiliser l\'item du racourcis ' .. i, 'keyboard', i)
end

-- DURABILITY
Citizen.CreateThread(function()

    while true do

        local ped = PlayerPedId()

        if currentWeaponData then

            if IsPedShooting(ped) then

                currentWeaponData.metadata.durability = currentWeaponData.metadata.durability - Config.ShootingDurabilityDegradation
                TriggerServerEvent('core_inventory:server:removeDurability', currentWeaponData.id, currentWeaponInventory, Config.ShootingDurabilityDegradation)
            end

            local re1, clipAmmo = GetAmmoInClip(ped, currentWeapon)
            local maxClip = GetMaxAmmoInClip(ped, currentWeapon)
            local ammo = GetAmmoInPedWeapon(ped, currentWeapon)
            TriggerServerEvent('core_inventory:server:updateAmmo', currentWeaponData.id, currentWeaponInventory, ammo)

            SendNUIMessage({
                type = 'weaponUI',
                data = currentWeaponData,
                show = true,
                ammo = clipAmmo or 0,
                maxammo = currentWeaponData.metadata.ammo or 0,
                percent = currentWeaponData.metadata.durability or 100

            })

        end

        Citizen.Wait(500)

    end

end)

-- CAMERA LOOP
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if playerZoomed then

            local pCoords = GetEntityCoords(PlayerPedId())

            local start = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 10.0, 10.0)
            local dir = pCoords - start

            SetArtificialLightsState(true)
            NetworkOverrideClockTime(6, 00, 00)
            DrawSpotLight(start[1], start[2], start[3], dir[1], dir[2], dir[3], 255, 255, 255, 25.0, 2.0, 2.0, 7.0, 0.0)
            DisplayRadar(false)

        end
        if weaponZoomed then

            x, y, z = table.unpack(GetEntityCoords(weaponObject, true))

            NetworkOverrideClockTime(1, 00, 00)
            DrawSpotLight(x, y + 10.0, z + 10.2, 10, -10.0, -15.0, 255, 255, 255, 25.0, 4.0, 2.0, 20.0, 0.0)
            DisplayRadar(false)

            SendNUIMessage({
                type = 'attachmentLine',
                suppressor = getWeaponBoneLoc(weaponObject, 'WAPSupp', false),
                flashlight = getWeaponBoneLoc(weaponObject, 'WAPFlshLasr', false),
                grip = getWeaponBoneLoc(weaponObject, 'WAPGrip', false),
                scope = getWeaponBoneLoc(weaponObject, 'WAPScop', false),
                finish = getWeaponBoneLoc(weaponObject, 'Gun_GripR', false),
                clip = getWeaponBoneLoc(weaponObject, 'WAPClip', false)

            })

        end
        if trackCam then
            local offset = GetOffsetFromEntityInWorldCoords(trackEntity, trackOffset)
            SetCamCoord(cam2, offset)
            SetCamFov(cam2, Config.EndFOV)
        end
    end
end)

local function PlayerCanDropGiveItem(item)
    local jobByPass = false
    for index, value in ipairs(Config.JobCanByPassRestriction) do
        if (value == job) then
            jobByPass = true
            break
        end
    end
    if not jobByPass then
        for key, value in ipairs(Config.ItemCantBeDrop) do
            if string.find(item, value) then
                SendNUIMessage({
                    type = 'closeInventory',
                    name = 'content-' .. cid
                })
               TriggerEvent('Core:ShowNotification', 'Vous ne pouvez pas jeter cet objet')
               return false
            end
        end
    end
    return true
end

function createPedScreen(refresh)

    CreateThread(function()

        if playerModel then

            DeleteEntity(playerModel)
            playerModel = nil
            SetFrontendActive(false)
            ReplaceHudColourWithRgba(117, 31, 31, 31, 100)
            if not refresh then
                return
            else
                Citizen.Wait(100)
            end
        end

        heading = GetEntityHeading(PlayerPedId())

        SetFrontendActive(true)

        ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_EMPTY_NO_BACKGROUND"), true, -1)

        Wait(100)

        SetMouseCursorVisibleInMenus(false)

        playerModel = ClonePed(PlayerPedId(), heading, true, false)
        
        local x, y, z = table.unpack(GetEntityCoords(playerModel))

        SetEntityCoords(playerModel, x, y, z - 10)

        FreezeEntityPosition(playerModel, true)

        SetEntityVisible(playerModel, false, false)

        SetBlockingOfNonTemporaryEvents(playerModel, true)

        NetworkSetEntityInvisibleToNetwork(playerModel, false)

        Wait(200)

        SetPedAsNoLongerNeeded(playerModel)

        GivePedToPauseMenu(playerModel, 1)

        SetPauseMenuPedLighting(true)

        SetPauseMenuPedSleepState(true)

        ReplaceHudColourWithRgba(117, 0, 0, 0, 0)

    end)
end

RegisterCommand('showped', function()
    createPedScreen()
end)

RegisterNUICallback("selectlocation", function(data)
    local location = data['location']

    if Config.ItemBuy[location] then

        local loc = Config.ItemBuy[location].coords

        SetNewWaypoint(loc[1], loc[2])
    else
        local loc = Config.ItemSell[location].coords

        SetNewWaypoint(loc[1], loc[2])
    end

    SendTextMessage(Config.Text['waypoint_set'])
end)

RegisterNUICallback("openPopupInventory", function(data)
    local inventory, type = data['inventory'], data['type']
    TriggerServerEvent('core_inventory:server:openInventory', inventory, type, nil, nil)
end)

local function CreateDrop(pedId, dropPosition, dropsName)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(pedId, 0.0, 0.5, 0.05))
    local prop = CreateObject(GetHashKey("prop_cs_box_clothes"), x, y, z, true, true, true)
    PlaceObjectOnGroundProperly(prop)
    table.insert(DropsProps, { coords = dropPosition, props = prop, itemNumber = 1, name = dropsName })
end

local function PickAndThorwObjectAnimation(pedId)
    while (not HasAnimDictLoaded("random@domestic")) do
        RequestAnimDict("random@domestic")
        Wait(100)
    end
    TaskPlayAnim(pedId, 'random@domestic', 'pickup_low', 8.0, 8.0, -1, 50, 0, false, false, false)
    Wait(500)
end

local function UpdateDropsPropsInfo(dropsName, coords, amount)
    for key, value in pairs(DropsProps) do
        if value.coords == coords then
            value.itemNumber = value.itemNumber + 1
            value.name = dropsName
        end
    end
end

local function DropPropsExist(coords)
    if DropsProps == nil then DropsProps = { } end
    for key, value in pairs(DropsProps) do
        if value.coords == coords then
            return true
        end
    end
    return false
end

local function FindDropByCoords(coords)
    for key, value in pairs(Drops) do
        if value.coords == coords then
            return key
        end
    end
    return nil
end

local function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

RegisterNUICallback("dropItem", function(data)

    if PlayerCanDropGiveItem(data['item']) then
        if (not IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
            local dropPosition = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.5, 0.05)
            TriggerServerEvent('core_inventory:server:createDrop', data['item'], dropPosition)
            Citizen.Wait(200)

            local propsExist = DropPropsExist(dropPosition)
            local dropsName = nil

            if not propsExist then
                dropsName = FindDropByCoords(dropPosition)
                if dropsName == nil then
                    -- increase Citizen.Wait to find the name return by server
                    print('Error when try to retrieve drop name')
                    return
                end
            end

            if not propsExist then
                PickAndThorwObjectAnimation(PlayerPedId())                
                CreateDrop(PlayerPedId(), dropPosition, dropsName)
                Wait(1000)
                ClearPedTasks(PlayerPedId())
            else
                UpdateDropsPropsInfo(dropsName, dropPosition, 1)
                PickAndThorwObjectAnimation(PlayerPedId())                
                Wait(1000)
                ClearPedTasks(PlayerPedId())
            end

            -- LOG Part
            ESX.TriggerServerCallback('core_inventory:custom:getItemLabel', function(itemResult)
                local amount = data['amount'] or 1
                TriggerServerEvent('core_inventory:custom:call3dme', " jette x" .. data['amount'] .. " ".. itemResult)
                TriggerServerEvent('core_inventory:custom:addDiscordLogStorageAndVehicle', itemResult, data['item'], 'content' .. cid, 'drop-', amount, 'put')
            end, data['label'])
        else
            SendNUIMessage({
                type = 'closeInventory',
                name = 'content-' .. cid
            })
            TriggerEvent('Core:ShowNotification', 'Tu ne peux pas jeter d\'objet en étant dans un véhicule')
        end
    end    
end)

RegisterNUICallback("useItem", function(data)
    ESX.TriggerServerCallback('core_inventory:custom:isItemUsable', function(isUsable)
        if isUsable then
            TriggerServerEvent('core_inventory:server:useItem', data['item'], data['exact'])
        else
            ESX.TriggerServerCallback('core_inventory:custom:getItemLabel', function(itemResult)
                SendNUIMessage({
                    type = 'closeInventory',
                    name = 'content-' .. cid
                })
                TriggerEvent('Core:ShowNotification','Cet objet (~y~'.. itemResult .. '~w~) n\'est pas utilisable')
            end, data['item'])
        end
    end, data['item'])
end)

function getWeaponBoneLoc(entity, part, offset)

    local bi = GetEntityBoneIndexByName(entity, part)

    if bi == -1 then
        return nil
    end

    local cord = GetWorldPositionOfEntityBone(entity, bi)
    local ok, xx, yy = GetScreenCoordFromWorldCoord(cord[1], cord[2], cord[3])

    if offset then
        xx = xx * 100
        yy = yy * 100

        if (yy > 45) then
            yy = yy + 10.0
        else
            yy = yy - 10.0
        end
        if (xx > 50) then
            xx = xx + 10.0
        else
            xx = xx - 10.0
        end

    end

    return vector2(xx, yy)

end

RegisterNUICallback("setupAttachments", function(data)
    zoomPlayer(false)
    weaponID = data['weapon']
    zoomWeapon(data['data'], true)

end)

RegisterNUICallback("closeAttachments", function(data)

    zoomWeapon(nil, false)
    zoomPlayer(true)

end)

local weaponRotation

RegisterNUICallback("registerMouse", function(data)
    weaponRotation = GetEntityRotation(weaponObject)
end)

RegisterNUICallback("mouseMovement", function(data)

    if weaponObject then

        local x = data['x'] / 10
        local y = data['y'] / 10

        SetEntityRotation(weaponObject, weaponRotation[1] + y, 0.0, weaponRotation[3] - x)

    end

end)

RegisterNUICallback("close", function(data)
    zoomPlayer(false)
    SetNuiFocus(false, false)
    handleTrunk(false)

    TriggerServerEvent('core_inventory:server:updateSettings', data['settings'])
    Settings = data['settings']

    for k, v in pairs(data['data']) do
        TriggerServerEvent('core_inventory:server:closeInventory', k, v)
    end

    Citizen.Wait(400)
    trackMode = nil
    inventoryOpened = false
end)

RegisterNUICallback("giveItem", function(data)

    local coords = GetEntityCoords(PlayerPedId())
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()

    if distance < 2.5 then
        if PlayerCanDropGiveItem(data['item']) then
            if (not IsPedInAnyVehicle(GetPlayerPed(-1), false) and not IsPedInAnyVehicle(closestPlayer, false)) then            
                TriggerServerEvent('core_inventory:server:giveItem', data['item'], GetPlayerServerId(closestPlayer))
                ESX.TriggerServerCallback('core_inventory:custom:getItemLabel', function(itemResult)
                    TriggerServerEvent('core_inventory:custom:call3dme', " donne x" .. data['amount'] .. " ".. itemResult)
                    TriggerServerEvent('core_inventory:custom:call3dme', " reçois x" .. data['amount'] .. " ".. itemResult,  GetPlayerServerId(closestPlayer))
                    TriggerServerEvent('core_inventory:custom:logGiveItem', GetPlayerServerId(closestPlayer), itemResult, data['amount'])
                end, data['label'])
            else
                SendNUIMessage({
                    type = 'closeInventory',
                    name = 'content-' .. cid
                })
                TriggerEvent('Core:ShowNotification', 'Vous ne pouvez pas donner un objet lorsque vous êtes dans un véhicule')
            end
        end
    else
        SendTextMessage(Config.Text['no_player_close'])
    end

    -- local players      = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
	-- 			local foundPlayers = false
	-- 			local elements     = {}

	-- 			for i=1, #players, 1 do
	-- 				if players[i] ~= PlayerId() then
	-- 					foundPlayers = true

	-- 					table.insert(elements, {
	-- 						label = GetPlayerServerId(players[i]),
	-- 						player = players[i]
	-- 					})
	-- 				end
	-- 			end
    -- TriggerEvent('esx_showid', elements)

    -- WHEN FINISH give 
    -- TriggerEvent('esx_showid', false)
end)

RegisterNUICallback("putItems", function(data)
    local item, finv, tinv, type = data['item'], data['finv'], data['tinv'], data['type']

    TriggerServerEvent('core_inventory:server:putItems', item, finv, tinv, type)

end)

RegisterNUICallback("closeInventory", function(data)

    TriggerServerEvent('core_inventory:server:closeInventory', data['inventory'], data['data'])

end)

RegisterNUICallback("stackItems", function(data)
    local fitem, titem, finv, tinv = data['fitem'], data['titem'], data['finv'], data['tinv']

    TriggerServerEvent('core_inventory:server:stackItems', fitem, titem, finv, tinv)
    if finv ~= tinv and  not CheckItsOwnInventory(finv, tinv) then            
        ESX.TriggerServerCallback('core_inventory:custom:getItemLabel', function(itemResult)
            local amount = data['getAmount'] or 1
            if tinv == 'content-' .. cid or tinv == 'primary-' .. cid or tinv == 'secondry-' .. cid or tinv == 'tertiary-' .. cid then
                TriggerServerEvent('core_inventory:custom:call3dme', " prend x" .. amount .. " ".. itemResult)
                TriggerServerEvent('core_inventory:custom:addDiscordLogStorageAndVehicle', itemResult, fitem, finv, tinv, amount, 'withdraw')
            elseif tinv ~= 'content-' .. cid and string.find(tinv, 'content-steam') then
                TriggerServerEvent('core_inventory:custom:call3dme', " donne x" .. amount .. " ".. itemResult)
                TriggerServerEvent('core_inventory:custom:addDiscordLogGive', itemResult, finv, tinv, amount)
            else
                TriggerServerEvent('core_inventory:custom:call3dme', " dépose x" .. amount .. " ".. itemResult)
                TriggerServerEvent('core_inventory:custom:addDiscordLogStorageAndVehicle', itemResult, fitem, finv, tinv, amount, 'put')
            end
        end, data['label'])
    end

end)

RegisterNUICallback("splitItems", function(data)
    local fitem, tslot, finv, tinv, stack = data['fitem'], data['tslot'], data['finv'], data['tinv'], data['stack']

    TriggerServerEvent('core_inventory:server:splitItems', fitem, tslot, finv, tinv, stack)

end)

RegisterNUICallback("changeItemLocation", function(data)
    local item, inventory, slot, fromInv, itemData = data['item'], data['inventory'], data['slot'], data['fromInv'], data['itemData']

    local needCheck = false
    for _, value in ipairs(Config.ItemCantBeMoveFromInventory) do
        if string.find(item, value) then
            needCheck = true
        end
    end

    local canChange = false
    if needCheck then
        if fromInv ~= inventory then
            local job = ESX.GetPlayerData().job.name
            for _, value in ipairs(Config.JobCanByPassRestriction) do
                if (value == job) then
                    canChange = true
                    break
                end
            end
        
            if not canChange then
                if inventory == 'content-' .. cid then
                    canChange = true
                end
            end
        else
            canChange = true;
        end
    else
        canChange = true;
    end

    if canChange then
        TriggerServerEvent('core_inventory:server:changeItemLocation', item, inventory, slot, fromInv, itemData)
        if fromInv ~= inventory and not CheckItsOwnInventory(fromInv, inventory) then            
            ESX.TriggerServerCallback('core_inventory:custom:getItemLabel', function(itemResult)
                local amount = itemData.amount or 1
                if inventory == 'content-' .. cid or inventory == 'primary-' .. cid or inventory == 'secondry-' .. cid or inventory == 'tertiary-' .. cid then
                    TriggerServerEvent('core_inventory:custom:call3dme', " prend x" .. amount .. " ".. itemResult)
                    TriggerServerEvent('core_inventory:custom:addDiscordLogStorageAndVehicle', itemResult, itemData.name, fromInv, inventory, amount, 'withdraw')
                elseif inventory ~= 'content-' .. cid and string.find(inventory, 'content-steam') then
                    TriggerServerEvent('core_inventory:custom:call3dme', " donne x" .. amount .. " ".. itemResult)
                    TriggerServerEvent('core_inventory:custom:addDiscordLogGive', itemResult, fromInv, inventory, amount)
                else
                    TriggerServerEvent('core_inventory:custom:call3dme', " dépose x" .. amount .. " ".. itemResult)
                    TriggerServerEvent('core_inventory:custom:addDiscordLogStorageAndVehicle', itemResult, itemData.name, fromInv, inventory, amount, 'put')
                end
            end, itemData.name)

            if string.find(fromInv, 'drop-') then
                local props = nil
                for i = 1, #DropsProps, 1 do
                    if DropsProps[i].name == fromInv then
                        props = { data = DropsProps[i], index = i}
                        break
                    end
                end

                if props ~= nil then
                    if props.data.itemNumber > 1 then
                        DropsProps[i].itemNumber = DropsProps[i].itemNumber - 1
                    else
                        PickAndThorwObjectAnimation(PlayerPedId())
                        Wait(250)
                        DeleteEntity(props.data.props)
                        table.remove(DropsProps, props.index)
                        Wait(1000)
                        ClearPedTasks(PlayerPedId())
                    end
                else
                    PickAndThorwObjectAnimation(PlayerPedId())                
                    Wait(1000)
                    ClearPedTasks(PlayerPedId())
                end
            end
        end
    else
        SendNUIMessage({
            type = 'closeInventory',
            name = 'content-' .. cid
        })
        TriggerEvent('Core:ShowNotification', 'Vous ne pouvez pas déposer cet objet')
    end
end)

RegisterNUICallback("resetKeybinds", function(data)
    Keybinds = {}
    SendTextMessage(Config.Text['keybinds_cleared'])
end)

RegisterNUICallback("resetUI", function(data)
    ESX.TriggerServerCallback('core_inventory:custom:resetUI', function(inventories)
        if inventories ~= nil then
            SendNUIMessage({
                type = 'resetUI',
                data = inventories
            })
        end
    end)
end)

RegisterNUICallback("setKeybind", function(data)
    local key, item, exact = data['key'], data['item'], data['exact']

    for k, v in pairs(Keybinds) do
        if v.item == item then
            Keybinds[k] = nil
        end
    end
    if Keys[key] then
        Keybinds[key] = {
            item = item,
            exact = exact
        }
        SendTextMessage(Config.Text['keybind_set'])
    else
        SendTextMessage(Config.Text['no_such_key'])
    end

end)

RegisterNUICallback("sync", function(data)
    local inventory, content = data['inventory'], data['data']

    TriggerServerEvent('core_inventory:server:updateInventory', inventory, content)

end)

RegisterNUICallback("holderData", function(data)
    local holder, data = data['holder'], data['data']

    handleAttachment(holder, data)
    handleClothing(holder, data)
    handleWeapons(holder, data)

    Holders[holder] = data

end)

function handleWeapons(holder, wep)

    local ped = PlayerPedId()

    if (holder == 'primary-' .. cid or holder == 'secondry-' .. cid or holder == 'tertiary-' .. cid) and Holders[holder] and wep == nil then

        if currentWeapon == Holders[holder].name then

            TriggerServerEvent('core_inventory:server:updateAmmo', currentWeaponData.id, currentWeaponInventory, GetAmmoInPedWeapon(ped, currentWeapon))

            SetCurrentPedWeapon(ped, 'WEAPON_UNARMED', true)
            RemoveAllPedWeapons(ped, true)

            SendNUIMessage({
                type = 'weaponUI',
                data = currentWeaponData,
                show = false,
                ammo = 0,
                maxammo = 0

            })

            currentWeapon = nil
            currentWeaponData = nil
            currentWeaponInventory = nil

        end
    end

end

function handleClothing(holder, clothes)

    if Config.DisableClothing then
        return
    end

    local ped = PlayerPedId()

    local found = nil

    for k, v in pairs(Config.InventoryClothing) do
        if k .. '-' .. cid == holder then
            found = k
        end
    end

    if found then

        if clothes and next(clothes) ~= nil then

            if clothes.metadata.wID or clothes.metadata.mID then

                local model = GetEntityModel(ped)

                if (model == GetHashKey("mp_f_freemode_01")) then
                    SetPedComponentVariation(ped, clothes.metadata.wID, clothes.metadata.wModel,
                        clothes.metadata.wTexture, 0)
                    if playerModel then
                        SetPedComponentVariation(playerModel, clothes.metadata.wID, clothes.metadata.wModel,
                            clothes.metadata.wTexture, 0)
                    end
                    if clothes.metadata.wTorso then
                        SetPedComponentVariation(ped, 3, clothes.metadata.wTorso, 0, 0)
                        if playerModel then
                            SetPedComponentVariation(playerModel, 3, clothes.metadata.wTorso, 0, 0)
                        end
                    end
                end
                if (model == GetHashKey("mp_m_freemode_01")) then

                    SetPedComponentVariation(ped, clothes.metadata.mID, clothes.metadata.mModel,
                        clothes.metadata.mTexture, 0)
                    if playerModel then
                        SetPedComponentVariation(playerModel, clothes.metadata.mID, clothes.metadata.mModel,
                            clothes.metadata.mTexture, 0)
                    end
                    if clothes.metadata.mTorso then
                        SetPedComponentVariation(ped, 3, clothes.metadata.mTorso, 0, 0)
                        if playerModel then
                            SetPedComponentVariation(playerModel, 3, clothes.metadata.mTorso, 0, 0)
                        end
                    end
                end

            end
        else

            local defaultClothes = Config.InventoryClothing[found]

            local model = GetEntityModel(ped)
            -- ADJUST FOR NAKED BODY
            if (model == GetHashKey("mp_f_freemode_01")) then

                SetPedComponentVariation(ped, defaultClothes.wID, defaultClothes.wModel, defaultClothes.wTexture, 0)
                if playerModel then
                    SetPedComponentVariation(playerModel, defaultClothes.wID, defaultClothes.wModel,
                        defaultClothes.wTexture, 0)
                end
                if defaultClothes.wTorso then
                    SetPedComponentVariation(ped, 3, defaultClothes.wTorso, 0, 0)
                    if playerModel then
                        SetPedComponentVariation(playerModel, 3, defaultClothes.wTorso, 0, 0)
                    end
                end

            end
            if (model == GetHashKey("mp_m_freemode_01")) then

                SetPedComponentVariation(ped, defaultClothes.mID, defaultClothes.mModel, defaultClothes.mTexture, 0)
                if playerModel then
                    SetPedComponentVariation(playerModel, defaultClothes.mID, defaultClothes.mModel,
                        defaultClothes.mTexture, 0)
                end
                if defaultClothes.mTorso then
                    SetPedComponentVariation(ped, 3, defaultClothes.mTorso, 0, 0)
                    if playerModel then
                        SetPedComponentVariation(playerModel, 3, defaultClothes.mTorso, 0, 0)
                    end
                end

            end

        end

    end

end

function handleTrunk(open)

    local vehicle, dst = ESX.Game.GetClosestVehicle()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    SetEntityAsMissionEntity(vehicle, true, true)

    if dst < 3.0 and DoesEntityExist(vehicle) then
        local vehicleClass = GetVehicleClass(vehicle)
        if open then

            if not IsPedInVehicle(ped, vehicle, true) then

                local locked = GetVehicleDoorLockStatus(vehicle)

                if locked == 0 or locked == 1 then

                    for _, value in ipairs(Config.BlackListedVehicleClassTrunk) do
                        if vehicleClass == value then
                            -- vehicle class trunk blacklisted 
                            return
                        end
                    end

                    local bone = GetEntityBoneIndexByName(vehicle, 'boot')
                    position = GetWorldPositionOfEntityBone(vehicle, bone)

                    if #(coords - position) < 1.8 or bone == -1 then

                        TaskTurnPedToFaceCoord(PlayerPedId(), position.x, position.y, position.z)

                        while (not HasAnimDictLoaded("anim@heists@prison_heiststation@cop_reactions")) do
                            RequestAnimDict("anim@heists@prison_heiststation@cop_reactions")
                            Wait(100)
                        end
                        TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 2.0,
                            2.0, -1, 50, 0, false, false, false)

                        SetVehicleDoorOpen(vehicle, 5, false, false)

                        TriggerServerEvent('core_inventory:server:openTrunk', GetVehicleNumberPlateText(vehicle),
                            GetVehicleClass(vehicle),
                            string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
                        trackMode = 'trunk'
                        trunkOpened = true

                    end

                end

            else
                if (not IsPedOnAnyBike(GetPlayerPed(-1))) then
                    TriggerServerEvent('core_inventory:server:openGlovebox', GetVehicleNumberPlateText(vehicle),
                        string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))

                    trackMode = 'vehicle'
                    trunkOpened = true
                    trackEntity = vehicle
                end
            end

        elseif trunkOpened then

            if not IsPedInVehicle(ped, vehicle, true) then

                while (not HasAnimDictLoaded("anim@heists@fleeca_bank@scope_out@return_case")) do
                    RequestAnimDict("anim@heists@fleeca_bank@scope_out@return_case")
                    Wait(100)
                end
                TaskPlayAnimAdvanced(ped, 'anim@heists@fleeca_bank@scope_out@return_case', 'trevor_action', coords.x,
                    coords.y, coords.z, 0.0, 0.0, GetEntityHeading(ped), 2.0, 2.0, 1000, 49, 0.25, 0, 0)

                Citizen.Wait(900)

                SetVehicleDoorShut(vehicle, 5, false)

            end

            trunkOpened = false
        end

    end

end

function handleAttachment(holder, component)

    if holder == 'suppressor' or holder == 'clip' or holder == 'finish' or holder == 'scope' or holder == 'flashlight' or
        holder == 'grip' then

        if component == nil then

            if Holders[holder].componentHash then

                RemoveWeaponComponentFromWeaponObject(weaponObject, GetHashKey(Holders[holder].componentHash))
                TriggerServerEvent('core_inventory:server:handleAttachment', weaponID, holder, component)

            elseif Holders[holder].componentTint then
                SetWeaponObjectTintIndex(weaponObject, 0)
                TriggerServerEvent('core_inventory:server:handleAttachment', weaponID, holder, component)
            end

        else

            if component.componentHash then

                SendNUIMessage({
                    type = 'playSound',
                    sound = 'construct'

                })

                local model = GetWeaponComponentTypeModel(GetHashKey(component.componentHash))
                RequestModel(model)

                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end

                GiveWeaponComponentToWeaponObject(weaponObject, GetHashKey(component.componentHash))
                TriggerServerEvent('core_inventory:server:handleAttachment', weaponID, holder, component)

            elseif component.componentTint then
                SetWeaponObjectTintIndex(weaponObject, component.componentTint)
                TriggerServerEvent('core_inventory:server:handleAttachment', weaponID, holder, component)
            end

        end

    end

end

RegisterCommand('primary', function()
    if Holders['primary-' .. cid] then
        useWeapon(Holders['primary-' .. cid], 'primary-' .. cid)
    end
end)

RegisterCommand('secondry', function()
    if Holders['secondry-' .. cid] then
        useWeapon(Holders['secondry-' .. cid], 'secondry-' .. cid)
    end
end)

RegisterCommand('tertiary', function()
    if Holders['tertiary-' .. cid] then
        useWeapon(Holders['tertiary-' .. cid], 'tertiary-' .. cid)
    end
end)

function useWeapon(weapon, inventory)

    local ped = PlayerPedId()
    local weaponName = tostring(weapon.name)

    if weapon.metadata.durability then
        if weapon.metadata.durability <= 0 then
            Citizen.Trace('WEAPON IS BROKEN!')
            return
        end
    end

    if currentWeapon then
        Holders[currentWeaponInventory].metadata.ammo = GetAmmoInPedWeapon(ped, currentWeapon)
        TriggerServerEvent('core_inventory:server:updateAmmo', currentWeaponData.id, currentWeaponInventory, GetAmmoInPedWeapon(ped, currentWeapon)) 
    end

    if currentWeapon == weaponName then

        SetCurrentPedWeapon(ped, 'WEAPON_UNARMED', true)
        RemoveAllPedWeapons(ped, true)
        currentWeapon = nil
        currentWeaponData = nil
        currentWeaponInventory = nil

        SendNUIMessage({
            type = 'weaponUI',
            data = weapon,
            show = false,
            ammo = 0,
            maxammo = 0

        })
    elseif weaponName == "weapon_stickybomb" or weaponName == "weapon_pipebomb" or weaponName == "weapon_smokegrenade" or
        weaponName == "weapon_flare" or weaponName == "weapon_proxmine" or weaponName == "weapon_ball" or weaponName ==
        "weapon_molotov" or weaponName == "weapon_grenade" or weaponName == "weapon_bzgas" then
        GiveWeaponToPed(ped, GetHashKey(weaponName), 1, false, false)
        SetPedAmmo(ped, GetHashKey(weaponName), 1)
        SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
        currentWeapon = weaponName
        currentWeaponData = weapon
        currentWeaponInventory = inventory
        Holders[inventory] = nil

        currentWeapon = nil
        currentWeaponData = nil
        currentWeaponInventory = nil

        TriggerServerEvent('core_inventory:server:removeThrowable', inventory)

    elseif weaponName == "weapon_snowball" then
        GiveWeaponToPed(ped, GetHashKey(weaponName), 10, false, false)
        SetPedAmmo(ped, GetHashKey(weaponName), 10)
        SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
        currentWeapon = weaponName
        currentWeaponData = weapon
        currentWeaponInventory = inventory
        Holders[inventory] = nil

        currentWeapon = nil
        currentWeaponData = nil
        currentWeaponInventory = nil

        TriggerServerEvent('core_inventory:server:removeThrowable', inventory)

    else
        local ammo = weapon.metadata.ammo or 0
        if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then
            if weapon.metadata.isSetFirstTime == nil or weapon.metadata.isSetFirstTime == false then
                ammo = 4000
                weapon.metadata.ammo = ammo
                weapon.metadata.isSetFirstTime = true
                TriggerServerEvent('core_inventory:custom:updateMetadata', inventory, weapon.id, weapon.metadata)
            end
        end

        -- ADDON CUSTOM TO TRIGGER ANIMATION WHEN SWITCH BETWEEN TWO GUN
        if currentWeapon ~= nil then
            SetCurrentPedWeapon(ped, 'WEAPON_UNARMED', true)
            RemoveAllPedWeapons(ped, true)
            currentWeapon = nil
            currentWeaponData = nil
            currentWeaponInventory = nil
            
            Citizen.Wait(1850) -- Wait until anim finish
        end

        GiveWeaponToPed(ped, GetHashKey(weaponName), 0, false, false)
        SetPedAmmo(ped, GetHashKey(weaponName), ammo)
        SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)

        SendNUIMessage({
            type = 'weaponUI',
            data = weapon,
            show = false,
            ammo = 0,
            maxammo = 0
        })
        Citizen.Wait(100)

        SendNUIMessage({
            type = 'weaponUI',
            data = weapon,
            show = true,
            ammo = ammo,
            maxammo = 100

        })

        for k, v in pairs(weapon.metadata.attachments) do

            if v then

                if v.componentHash then
                    GiveWeaponComponentToPed(ped, GetHashKey(weaponName), GetHashKey(v.componentHash))
                elseif v.componentTint then
                    SetPedWeaponTintIndex(ped, GetHashKey(weaponName), v.componentTint)
                end
            end

        end

        currentWeapon = weaponName
        currentWeaponInventory = inventory
        currentWeaponData = weapon

    end

end

function getWeaponFOV(hash)
    local ped = GetPlayerPed(-1)

    if GetWeapontypeGroup(hash) == -957766203 then
        return 30.0
    end
    if GetWeapontypeGroup(hash) == 416676503 then
        return 20.0
    end
    if GetWeapontypeGroup(hash) == 860033945 then
        return 35.0
    end
    if GetWeapontypeGroup(hash) == 970310034 then
        return 27.0
    end
    if GetWeapontypeGroup(hash) == 1159398588 then
        return 30.0
    end
    if GetWeapontypeGroup(hash) == -1212426201 then
        return 40.0
    end
    if GetWeapontypeGroup(hash) == -1569042529 then
        return 40.0
    end

    return 35.0
end

function zoomWeapon(weapon, bool)

    if bool then

        local lastRotation = vector3(0.0, 0.0, 0.0)

        local weaponModel = GetHashKey(weapon.name)

        RequestWeaponAsset(weaponModel, 31, 0)

        while not HasWeaponAssetLoaded(weaponModel) do
            Citizen.Wait(0)
        end

        local coords = GetEntityCoords(PlayerPedId())

        weaponObject = CreateWeaponObject(weaponModel, 120, coords[1], coords[2], coords[3] - 100.0, true, 1.0, 0)
        weaponBox = CreateObject(GetHashKey('core_blackbox'), coords[1], coords[2], coords[3] - 110.0, false, true, 0)

        SetEntityRotation(weaponObject, lastRotation)

        FreezeEntityPosition(weaponObject, true)

        local offset2 = GetOffsetFromEntityInWorldCoords(weaponObject, 1.0, 1.0, 0.0)

        SetTimecycleModifier('METRO_Tunnels')
        SetTimecycleModifierStrength(1.0)

        cam3 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", offset2, 0.0, 0.0, 0, 60.00, false, 0)
        PointCamAtEntity(cam3, weaponObject, 0.2, 0, 0, true)

        SetCamFov(cam3, getWeaponFOV(GetHashKey(weapon.name)))
        SetCamActive(cam3, true)
        RenderScriptCams(true, false, 1, true, true)

        Citizen.Wait(100)

        SendNUIMessage({
            type = 'setupAttachments',
            data = weapon,
            suppressor = getWeaponBoneLoc(weaponObject, 'WAPSupp', true),
            flashlight = getWeaponBoneLoc(weaponObject, 'WAPFlshLasr', true),
            grip = getWeaponBoneLoc(weaponObject, 'WAPGrip', true),
            scope = getWeaponBoneLoc(weaponObject, 'WAPScop', true),
            finish = getWeaponBoneLoc(weaponObject, 'Gun_GripR', true),
            clip = getWeaponBoneLoc(weaponObject, 'WAPClip', true)

        })

        weaponZoomed = true
    else

        DeleteEntity(weaponObject)
        DeleteEntity(weaponBox)
        DisplayRadar(true)
        NetworkClearClockTimeOverride()

        SetTimecycleModifier('default')
        DestroyCam(cam3, true)
        RenderScriptCams(false, false, 1, true, true)
        weaponZoomed = false

    end

end

function zoomPlayer(bool)

    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)

    if ((GetInteriorFromEntity(PlayerPedId()) ~= 0 or pcoords[3] < Config.HeightRecognizedAsInterior) and
        Config.Use3DModelInteriors) or Config.Use3DModelAlways then

        if bool then
            if Config.BlurIf3DModel then
                TriggerScreenblurFadeIn(1000)
            end
            createPedScreen(false)

        else
            if Config.BlurIf3DModel then
                TriggerScreenblurFadeOut(1000)
            end
            createPedScreen(false)

        end

    elseif (GetInteriorFromEntity(PlayerPedId()) == 0 and pcoords[3] > Config.HeightRecognizedAsInterior) then

        if bool then

            if trackMode == 'trunk' then

                trackOffset = Config.CameraTrunkOffsetEnd
                trackEntity = ped

                offsetEnd = GetOffsetFromEntityInWorldCoords(trackEntity, Config.CameraTrunkOffsetEnd)
                offsetStart = GetOffsetFromEntityInWorldCoords(trackEntity, Config.CameraTrunkOffsetStart)
                camTime = Config.TrunkCameraTransitionTime

            elseif trackMode == 'vehicle' then

                trackOffset = Config.CameraVehicleOffsetEnd

                offsetEnd = GetOffsetFromEntityInWorldCoords(trackEntity, Config.CameraVehicleOffsetEnd)
                offsetStart = GetOffsetFromEntityInWorldCoords(trackEntity, Config.CameraVehicleOffsetStart)
                camTime = Config.VehicleCameraTransitionTime

            else

                trackOffset = Config.CameraOffsetEnd
                trackEntity = ped

                offsetEnd = GetOffsetFromEntityInWorldCoords(trackEntity, Config.CameraOffsetEnd)
                offsetStart = GetOffsetFromEntityInWorldCoords(trackEntity, Config.CameraOffsetStart)
                camTime = Config.CameraTransitionTime

            end

            SetTimecycleModifier('METRO_Tunnels')
            SetTimecycleModifierStrength(3.0)
            FreezeEntityPosition(ped, true)

            cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", offsetStart, 0.0, 0.0, 0, 60.00, false, 0)
            PointCamAtEntity(cam, trackEntity, 0, 0, 0, true)
            FreezeEntityPosition(ped, false)
            SetCamFov(cam, Config.StartFOV)
            SetCamActiveWithInterp(cam, cam2, camTime, true, true)
            RenderScriptCams(true, false, 1, true, true)

            cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", offsetEnd, 0.0, 0.0, 0, 60.00, false, 0)
            PointCamAtEntity(cam2, trackEntity, 0, 0, 0, true)
            SetCamFov(cam2, Config.EndFOV)
            SetCamActiveWithInterp(cam2, cam, camTime, true, true)

            Citizen.CreateThread(function()

                Citizen.Wait(camTime)
                if DoesCamExist(cam) then
                    DestroyCam(cam, true)
                end
            end)

        else
            SetArtificialLightsState(false)
            NetworkClearClockTimeOverride()
            DisplayRadar(true)

            SetTimecycleModifier('default')
            if DoesCamExist(cam) then
                DestroyCam(cam, true)
            end
            if DoesCamExist(cam2) then
                DestroyCam(cam2, true)
            end

            RenderScriptCams(false, false, 1, true, true)
            FreezeEntityPosition(ped, false)

        end

        playerZoomed = bool

        if bool then
            Citizen.Wait(camTime)
        end

        trackCam = bool

    end

end

RegisterNetEvent('core_inventory:client:handshake')
AddEventHandler('core_inventory:client:handshake', function(target)

    TaskTurnPedToFaceCoord(PlayerPedId(), NetworkGetPlayerCoords(GetPlayerFromServerId(target)))

    while (not HasAnimDictLoaded("mp_common")) do
        RequestAnimDict("mp_common")
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a', 8.0, 8.0, 2000, 50, 0, false, false, false)
    Wait(2000)
    ClearPedTasks(PlayerPedId())

end)

RegisterNetEvent('core_inventory:client:syncDrops')
AddEventHandler('core_inventory:client:syncDrops', function(data)
    Drops = data    
end)

RegisterNetEvent('core_inventory:client:openInventory')
AddEventHandler('core_inventory:client:openInventory', function(name, slots, rows, content, label, locationX, locationY, hidden, type, restrictedTo)
        if not inventoryOpened then
            openInventory()
        end

        SendNUIMessage({
            type = 'openInventory',
            name = name,
            slots = slots,
            rows = rows,
            content = content,
            label = label,
            locationX = locationX,
            locationY = locationY,
            hidden = hidden,
            invType = type,
            restrictedTo = restrictedTo

        })
end)

RegisterNetEvent('core_inventory:client:openHolder')
AddEventHandler('core_inventory:client:openHolder', function(name, slots, rows, content, label, locationX, locationY, restrictedTo, hidden, type)        
        if not inventoryOpened then
            openInventory()
        end

        SendNUIMessage({
            type = 'openHolder',
            name = name,
            slots = slots,
            rows = rows,
            content = content,
            label = label,
            locationX = locationX,
            locationY = locationY,
            restrictedTo = restrictedTo,
            hidden = hidden,
            invType = type

        })
end)

RegisterNetEvent('core_inventory:client:holderData')
AddEventHandler('core_inventory:client:holderData', function(holder, data)

    handleAttachment(holder, data)
    handleClothing(holder, data)
    handleWeapons(holder, data)

    Holders[holder] = data
end)

RegisterNetEvent('core_inventory:client:sync', function(inventory, data)
    SendNUIMessage({

        type = 'Sync',
        inventory = inventory,
        data = data
    })
end)

RegisterNetEvent('core_inventory:client:removeItem', function(inventory, item)
    SendNUIMessage({

        type = 'removeItem',
        inventory = inventory,
        item = item

    })
end)

RegisterNetEvent('core_inventory:client:sendTextMessage', function(msg)
    print(msg)
    SendTextMessage(msg)
end)

RegisterNetEvent('core_inventory:client:registerExternalInventory', function(inventory, type, x, y, coords)
    ExternalInventories[inventory] = {
        type = type,
        x = x,
        y = y,
        coords = coords
    }
end)

RegisterNetEvent('core_inventory:client:addBackpack', function(backpack, data)
    Backpacks[backpack] = data

    if currentBackpack == nil then

        currentBackpack = backpack
        -- add backpack

    end
end)

RegisterNetEvent('core_inventory:client:removeBackpack', function(backpack)
    if Backpacks[backpack] then
        Backpacks[backpack] = nil
    end

    if currentBackpack == backpack then

        if #Backpacks > 0 then
            -- add next in line
        else
            currentBackpack = nil
            -- remove backpack
        end

    end
end)

RegisterNetEvent('core_inventory:client:addItem', function(inventory, item)
    SendNUIMessage({

        type = 'addItem',
        inventory = inventory,
        item = item

    })
end)

function openInventory()
    if inventoryOpened then
        return
    end
    inventoryOpened = true

    TriggerServerEvent('core_inventory:server:openPersonalInventory')

    SendNUIMessage({

        type = 'openBase',
        config = Config,
        cid = cid,
        settings = Settings,
        qbitems = Items

    })

    local coords = GetEntityCoords(PlayerPedId())

    for k, v in pairs(Drops) do

        if #(v.coords - coords) < 2.0 then

            TriggerServerEvent('core_inventory:server:openDrop', k)

        end

    end

    for k, v in pairs(Config.Storage) do

        if #(v.coords - coords) < 2.0 then

            if v.jobs then
                for _, g in ipairs(v.jobs) do
                    if g == job then
                        if v.personal then
                            TriggerServerEvent('core_inventory:server:openInventory', k .. '-' .. cid, v.inventory)

                            break
                        else
                            TriggerServerEvent('core_inventory:server:openInventory', k, v.inventory)
                            break
                        end
                    end
                end
            else

                if v.personal then
                    TriggerServerEvent('core_inventory:server:openInventory', k .. '-' .. cid, v.inventory)

                else
                    TriggerServerEvent('core_inventory:server:openInventory', k, v.inventory)

                end

            end

        end

    end

    for k, v in pairs(ExternalInventories) do

        if #(v.coords - coords) < 2.0 then

            TriggerServerEvent('core_inventory:server:openInventory', k, v.type)
            break

        end

    end

    handleTrunk(true)
    zoomPlayer(true)
    SetNuiFocus(true, true)

    -- ADDON CUSTOM TERTIARY WEAPON
    
    TriggerServerEvent('core_inventory:server:openHolder', 'tertiary-' .. cid , 'tertiary')
end

RegisterCommand('inv', function()

    openInventory()

end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    for _, v in ipairs(spawnedProps) do
        DeleteEntity(v)
    end

end)

-- Storage Inventory CUSTOM ADDON 
RegisterNetEvent('core_inventory:client:openSocietyStockageInventory')
AddEventHandler('core_inventory:client:openSocietyStockageInventory', function(societyName)
    local inventoryType = 'big_entreprise_utility_storage'
    TriggerServerEvent('core_inventory:server:openInventory', societyName .. '_' .. inventoryType, inventoryType)
end)

RegisterNetEvent('core_inventory:client:openSocietyStockageInventory')
AddEventHandler('core_inventory:client:openSocietyStockageInventory', function(societyName, inventoryType)
    if (inventoryType == nil or inventoryType == '') then
        inventoryType = 'big_entreprise_utility_storage'
    end
    TriggerServerEvent('core_inventory:server:openInventory', societyName .. '_' .. inventoryType, inventoryType)
end)

RegisterNetEvent('core_inventory:client:openOwnerPropertyStockageInventory')
AddEventHandler('core_inventory:client:openOwnerPropertyStockageInventory', function(propertyName, ownerIdentifier)
    local inventoryType = 'big_property_utility_storage'
    TriggerServerEvent('core_inventory:server:openInventory', propertyName .. '-' .. ownerIdentifier:gsub(":", "") .. '_' .. inventoryType, inventoryType)
end)

-- Weapon Inventory CUSTOM ADDON 

RegisterNetEvent('core_inventory:client:openSocietyWeaponsInventory')
AddEventHandler('core_inventory:client:openSocietyWeaponsInventory', function(societyName)
    local inventoryType = 'big_entreprise_weapons_storage'
    TriggerServerEvent('core_inventory:server:openInventory', societyName .. '_' .. inventoryType, inventoryType)
end)

RegisterNetEvent('core_inventory:client:openSocietyWeaponsInventoryName')
AddEventHandler('core_inventory:client:openSocietyWeaponsInventoryName', function(societyName, inventoryType)
    if (inventoryType == nil or inventoryType == '') then
        inventoryType = 'big_entreprise_weapons_storage'
    end
    TriggerServerEvent('core_inventory:server:openInventory', societyName .. '_' .. inventoryType, inventoryType)
end)

-- Retrieve offline scratchCard CUSTOM ADDON 
function SetScratchCard()
    TriggerServerEvent('core_inventory:custom:setScratchCardAmount')
end

-- Check if it's own inventory (inventory / primary / secondry / tertiary)

function CheckItsOwnInventory(fromInv, toInv)
    local isFromPlayerInventory = false
    local isToPlayerInventory = false
    if fromInv == 'content-' .. cid or fromInv == 'primary-' .. cid or fromInv == 'secondry-'.. cid or fromInv == 'tertiary-'.. cid then
        isFromPlayerInventory = true
    end
    if toInv == 'content-' .. cid or toInv == 'primary-' .. cid or toInv == 'secondry-'.. cid or toInv == 'tertiary-'.. cid then
        isToPlayerInventory = true
    end

    return isFromPlayerInventory and isToPlayerInventory
end