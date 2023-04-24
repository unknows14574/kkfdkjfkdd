local ESX = nil
local canAccess = { }
local canByPass = { }
local canHandleCommand = { }

local function CanAccessModeration(source)
    local result = { canAccess = false, canByPass = false, canHandleCommand = false }
    if canAccess[source] then
        result.canAccess = canAccess[source]
        if canHandleCommand[source] then
            result.canHandleCommand = canHandleCommand[source]
        end
        if canByPass[source] then
            result.canByPass = canByPass[source]
            result.canHandleCommand = canByPass[source]
        end
    end
    return result
end

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('Core:SetCanHandleCommand', function(playerSource, value)
    local _source = source
    if playerSource == nil then
        playerSource = _source
    end
    canHandleCommand[playerSource] = value
end)

RegisterNetEvent('Core:SetCanByPassModeration', function(playerSource, value)
    canByPass[playerSource] = value
end)

RegisterNetEvent('Core:SetCanAccessModeration', function(playerSource, value)
    canAccess[playerSource] = value
end)

ESX.RegisterServerCallback('Core:CanAccessModeration', function(source, cb)
    cb(CanAccessModeration(source))
end)

exports('CanAccessModeration', CanAccessModeration)