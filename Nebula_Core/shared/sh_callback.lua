-- --Print Custom
local _print = print
function print(...)
  local str = '[^6' .. GetCurrentResourceName() .. '^7] '

  for k, v in pairs({...}) do
    str = str .. (v == nil and "nil" or tostring(v)) .. '    '
  end

  _print(str)
end

--RegisterNetEvent
function RegisterEvent(name, cb)
    RegisterNetEvent(name)
    return AddEventHandler(name, cb)
end

--RemoveEventHandler
function StopRegister(name)
    RemoveEventHandler(name)
end


if IsDuplicityVersion() then

    function EmitClient(name, client, ...)
        TriggerClientEvent(name, client, ...)
    end

    local ServerCallbacks = {}

    function RegisterCallback(name, cb)
        ServerCallbacks[name] = cb
    end

    RegisterEvent('TriggerServerCallback', function(name, requestId, ...)
        if ServerCallbacks[name] then
            EmitClient('ServerCallback', source, requestId, ServerCallbacks[name](source, ...))
        else
            print("^7Callback Inexistant " .. name)
        end
    end)

else

    function EmitServer(name, ...)
        TriggerServerEvent(name, ...)
    end

    local ServerCallbacks = {}

    function CallbackServer(name, cb, ...)
        local CurrentRequestId = #ServerCallbacks + 1
        ServerCallbacks[CurrentRequestId] = cb
        EmitServer('TriggerServerCallback', name, CurrentRequestId, ...)
    end

    RegisterEvent('ServerCallback', function(requestId, ...)
        if ServerCallbacks[requestId] then
            ServerCallbacks[requestId](...)
            ServerCallbacks[requestId] = nil
        else
            print("^7Callback Inexistant ID : " .. requestId)
        end
    end)

end





-- if IsDuplicityVersion() then

--     -- Server
--     RegisterCallback('test', function(source, identifier)
--         print("testd", identifier)
--         return "testd", identifier
--     end)

-- else

--     -- client
--     CallbackServer('test', function(result, result2)
--         print(result, result2)
--     end, "ezdhfsfesfs")

-- end




