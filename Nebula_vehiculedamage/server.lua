RegisterNetEvent("baseevents:enteredVehicle")
AddEventHandler("baseevents:enteredVehicle", function()
    TriggerClientEvent("Nebula_vehiculedamage:playerEnteredVehicule", source)
end)

RegisterNetEvent("baseevents:leftVehicle")
AddEventHandler('baseevents:leftVehicle', function()
    TriggerClientEvent("Nebula_vehiculedamage:playerLeftVehicle", source)
end)