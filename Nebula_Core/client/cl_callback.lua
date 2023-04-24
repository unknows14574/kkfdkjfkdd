local ServerCallbacks = {}

function TriggerServerCallback(name, cb, ...)
    local CurrentRequestId = #ServerCallbacks + 1
    ServerCallbacks[CurrentRequestId] = cb
    TriggerServerEvent('trigger_server_callback', name, CurrentRequestId, ...)
end

RegisterNetEvent('server_callback')
AddEventHandler('server_callback', function(requestId, ...)
    ServerCallbacks[requestId](...)
    ServerCallbacks[requestId] = nil
end)