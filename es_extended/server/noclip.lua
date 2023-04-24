ESX.RegisterServerCallback('es_extended:custom:getGroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer ~= nil) then
        cb(xPlayer.getGroup())
    end
end)