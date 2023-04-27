RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterCommand(Config.NameCommand, function()
    for _,v in pairs(Config.Interaction) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == v.Job then
            ManageSession(v)
        end
    end
end)

