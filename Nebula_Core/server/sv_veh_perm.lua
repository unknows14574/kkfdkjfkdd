-- local PV = {
--     players = {},
--     vehicles = {},
--     waiting = 0,
--     debugging = Config.VehiclePerm.debug,
--   }
  
--   if Config.VehiclePerm.txAdmin then
--     AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
--       if eventData.secondsRemaining == 60 then
--         Citizen.CreateThread(function() 
--           Wait(50000)
--           PV:SavedPlayerVehiclesToFile()
--         end)
--       end
--     end)
--   end

-- local function GetClosestPlayerToCoordsVehPerm(players, coords)
--   local closestDist, closestPlayerId
--   for playerId in pairs(players) do
--     local ped = GetPlayerPed(playerId)
--     if ped > 0 then
--       local pedCoords = GetEntityCoords(ped)
--       while pedCoords == nil do
--         Wait(50)
--         pedCoords = GetEntityCoords(ped)
--       end
--       local dist = DistanceBetweenCoords(pedCoords, coords)
--       if not closestDist or dist < closestDist then
--         closestDist = dist
--         closestPlayerId = playerId
--       end
--       -- this is close enough, no need to go through every player
--       if closestDist < Config.VehiclePerm.respawnDistance then
--           break
--       end
--     end
--   end
--   return closestPlayerId, closestDist
-- end


--   -- commands
--   RegisterCommand('pv-cull', function (source, args, rawCommand)
--     if tonumber(source) > 0 then return end
--     PV:CullVehicles(args[1])
--     print('Persistent Vehicles: Culled:', args[1] or 10)
--   end, true)
  
--   RegisterCommand('pv-forget', function (source, args, rawCommand)
--     if tonumber(source) > 0 then return end
--     if args[1] == nil then return end
--     print(args[1])
--     PV:ForgetVehicle(tostring(args[1]))
--   end, true)
  
--   RegisterCommand('pv-forget-all', function (source, args, rawCommand)
--     if tonumber(source) > 0 then return end
--     PV:ForgetAllVehicles()
--   end, true)
  
--   RegisterCommand('pv-save-to-file', function (source, args, rawCommand)
--     if tonumber(source) > 0 then return end
--     PV:SavedPlayerVehiclesToFile()
--   end, true)
  
--   RegisterCommand('pv-toggle-debugging', function (source, args, rawCommand)
--     if tonumber(source) > 0 then return end
--     PV.debugging = not PV.debugging
--     print('Persistent Vehicles: Toggled debugging', PV.debugging)
--   end, true)
  
--   RegisterCommand('pv-num-spawned', function (source, args, rawCommand)
--     if tonumber(source) > 0 then return end
--     print('Persistent Vehicles: Number of vehicles currently spawned including unregistered:' .. Core.Math.Tablelength(GetAllVehicles()) .. ' Number of registered spawned: ' .. PV:NumberSpawned())
--   end, true)
  
--   RegisterCommand('pv-num-registered', function (source, args, rawCommand)
--     if tonumber(source) > 0 then return end
--     print('Persistent Vehicles: Number of persistent vehicles registered: ' .. Core.Math.Tablelength(PV.vehicles))
--   end, true)
  
--   RegisterCommand('pv-shutdown', function (source, args, rawCommand)
--     if tonumber(source) > 0 then return end
--     for i = GetNumResources(), 1, -1 do
--         local resource = GetResourceByFindIndex(i)
--         StopResource(resource)
--     end
--   end, true)

--   RegisterCommand('pv-forget-null', function (source, args, rawCommand)
--     if tonumber(source) > 0 then return end
--     for id, vehicle in pairs(PV.vehicles) do
--       if vehicle.props.plate == nil and vehicle.props.model == nil then
--         PV:ForgetVehicle(id)
--         print('Forgot vehicle '..id)
--       end
--     end
--   end, true)
  
   
--   -- pv-spawn-test <number of vehicles> <vehicle model name>
--   RegisterCommand('pv-spawn-test', function (source, args, rawCommand)
--     local total = Core.Math.Tablelength(PV.vehicles) + 1
--       local num = 0.5
--     print('GetPlayerPed(source)', source)
--     local ped = GetPlayerPed(source)
--     local coords = GetEntityCoords(ped)
--     local amount = args[1] or 1
--     for i = 1, tonumber(amount) do
--       local plate = tostring(total)
--       local data = {
--         props = {model = args[2] or 't20', plate = plate },
--         pos = {x = coords.x + num, y = coords.y + num, z = coords.z + 0.1, h = 40.0},
--       }
--       num = num + 1.45
--       total = total + 1
--       PV.vehicles[data.props.plate] = data
--       print('Debugging: Added Vehicles')
--     end
--   end, true)
  
  
--   -- events
--   RegisterServerEvent('persistent-vehicles/server/register-vehicle')
--   AddEventHandler('persistent-vehicles/server/register-vehicle', function (netId, props, trailer, forgetAfter)
--     local _source = source
--     if type(netId) ~= 'number' then return end
--     PV.players[_source] = true
--     PV:RegisterVehicle(netId, props, trailer, forgetAfter)
--   end)
  
--   RegisterServerEvent('persistent-vehicles/server/update-vehicle')
--   AddEventHandler('persistent-vehicles/server/update-vehicle', function (plate, props, trailer, forgetAfter)
--     if PV.vehicles[plate] == nil then return end
--     PV.vehicles[plate].props = props

--     if trailer ~= nil and trailer.netId > 0 then
--       PV.vehicles[plate].trailer = trailer
--     end
  
--     if forgetAfter ~= nil then
--       PV.vehicles[plate].forgetOn = forgetAfter + GetGameTimer()
--     end
  
--     if PV.debugging then
--       print('Persistent Vehicles: Updated vehicle props for:', plate)
--     end
--   end)
  
--   RegisterServerEvent('persistent-vehicles/server/forget-vehicle')
--   AddEventHandler('persistent-vehicles/server/forget-vehicle', function (plate)
--     PV:ForgetVehicle(plate)
--   end)
  
--   -- must be called from the server with TriggerEvent('persistent-vehicles/save-vehicles-to-file')
--   RegisterServerEvent('persistent-vehicles/save-vehicles-to-file')
--   AddEventHandler('persistent-vehicles/save-vehicles-to-file', function ()
--     --if not GetInvokingResource() then return end
--     PV:SavedPlayerVehiclesToFile()
--   end)
  
--   RegisterServerEvent('persistent-vehicles/server/save-pos-vehicle')
--   AddEventHandler('persistent-vehicles/server/save-pos-vehicle', function (netId, props, trailer, coordsVeh, heading, rot)
--     if PV.vehicles[props.plate] ~= nil then
--       PV:SavePosition(netId, props, trailer, coordsVeh, heading, rot)
--     elseif Config.VehiclePerm.PersistPnjVehicle then
--       PV:RegisterVehicle(netId, props, trailer, Config.VehiclePerm.ForgetAfterVehicleNPC) 
--     end
--   end)

--   RegisterServerEvent('persistent-vehicles/done-spawning')
--   AddEventHandler('persistent-vehicles/done-spawning', function (response)
--     local _source = source
--     if PV.waiting[_source] then
--       for i, data in pairs(response) do
--       -- for i = 1, #response do
--       --   local data = response[i]
--         local entity = NetworkGetEntityFromNetworkId(data.netId)
        
--         -- bug fix: sometimes onesync cannot get entity from net id :/
--         if not DoesEntityExist(entity) then
--             if PV.vehicles[data.plate] ~= nil and PV.vehicles[data.plate].tried then
--               if PV.debugging then
--                 print('Persistent Vehicles: Had to forget vehicle: '.. data.plate .. ' because OneSync couldn\'t get its entity twice in a row :/')
--               end
--               PV:ForgetVehicle(data.plate)
--             elseif PV.vehicles[data.plate] ~= nil then
--               PV.vehicles[data.plate].tried = true
--             end
--         elseif(PV.vehicles[data.plate]) then
--           PV.vehicles[data.plate].netId = data.netId
--           PV.vehicles[data.plate].entity = entity
--           PV.vehicles[data.plate].tried = nil
--         end
--       end
--       Wait(250)
--       PV.waiting[_source] = nil
--     end
  
--     if PV.debugging then
--       print('Persistent Vehicles: Server received client spawn confirmation from:', _source)
--     end
--   end)
  
--   RegisterServerEvent('persistent-vehicles/new-player')
--   AddEventHandler('persistent-vehicles/new-player', function()
--     local _source = source
--     PV.players[_source] = true
--   end)
  
--   AddEventHandler("onResourceStop", function(resource)
--     if resource ~= GetCurrentResourceName() then return end
--     if Config.VehiclePerm.populateOnReboot then
--       PV:SavedPlayerVehiclesToFile()
--     end
--   end)
  
--   -- global functions
--   function PV:RegisterVehicle(netId, props, trailer, forgetAfter) 
--     if self.vehicles[props.plate] ~= nil then return end
    
--     if props.plate == nil then
--       if self.debugging then
--         return print('Persistent Vehicles: You tried to register a vehicle without passing its vehicle properties')
--       else
--         return
--       end
--     end
--     -- if self.vehicles[props.plate] ~= nil then return end
--       -- don't register the vehicle immediately incase it is deleted straight away
--     Citizen.SetTimeout(1500, function ()
--       local entity = NetworkGetEntityFromNetworkId(netId)
--       if not entity then return end
--       self.vehicles[props.plate] = {netId = netId, entity = entity, props = props}
  
--       if trailer ~= nil and trailer.netId > 0 then
--         self.vehicles[props.plate].trailer = trailer
--       end
      
--       if forgetAfter ~= nil then
--         self.vehicles[props.plate].forgetOn = forgetAfter + GetGameTimer()
--       end

--       local coords = GetEntityCoords(entity)
--       while coords == nil do
--         Wait(50)
--         coords = GetEntityCoords(entity)
--       end
--       local rot = GetEntityRotation(entity)

--       self.vehicles[props.plate].pos = {
--         x = coords.x,
--         y = coords.y,
--         z = coords.z,
--         h = GetEntityHeading(entity),
--         r = { x = rot.x, y = rot.y, z = rot.z }
--       }
  
--       if self.debugging then
--         print('Persistent Vehicles: Registered Vehicle', props.plate, netId, entity)
--       end
--     end)
-- end
  
--   function PV:NumberSpawned()
--     local num = 0
--     for plate, data in pairs(self.vehicles) do
--       if DoesEntityExist(data.entity) then
--         num = num + 1
--       end
--     end
--     return num
--   end
  
--   function PV:ForgetVehicle(plate)
--     if not plate then return end
--     self.vehicles[plate] = nil
--     -- TriggerEvent('Core-Garage:modifystate', plate, 1)
--     if self.debugging then
--       print('Persistent Vehicles: Forgotten Vehicle', plate)
--     end
--   end
  
--   function PV:CullVehicles(amount)
--     local num = amount or 10
--     for key, value in pairs(self.vehicles) do
--       PV:ForgetVehicle(key)
--       num = num - 1
--       if num == 0 then
--         break
--       end
--     end
--     if self.debugging then
--       print('Persistent Vehicles: Culled vehicles', num)
--     end
--   end
  
--   function PV:ForgetAllVehicles()
--     local num = Core.Math.Tablelength(self.vehicles)
--     self.vehicles = {}
--     self:SavedPlayerVehiclesToFile()
--     print('Persistent Vehicles: Forgotten '..num..' vehicles. No vehicles are now persistent.')
--   end
  
--   function PV:SavedPlayerVehiclesToFile()
--     SaveResourceFile(GetCurrentResourceName(), "json/vehicle-data.json", json.encode(PV.vehicles), -1)
--     print('Persistent Vehicles: '.. Core.Math.Tablelength(PV.vehicles) .. ' vehicles saved to file')
--   end
  
--   function PV:LoadVehiclesFromFile()
--     Wait(0)
--     local SavedPlayerVehicles = LoadResourceFile(GetCurrentResourceName(), "json/vehicle-data.json")
--     if SavedPlayerVehicles ~= '' then
--         Wait(0)
--         self.vehicles = json.decode(SavedPlayerVehicles)
--         if not self.vehicles then
--             self.vehicles = {}
--         end
--         if self.debugging then
--             print('Persistent Vehicles: Loaded '.. Core.Math.Tablelength(self.vehicles) .. ' Vehicle(s) from file')
--         end
--     end
--   end

--   function PV:SavePosition(netId, props, trailer, coordsVeh, heading, rot)
--     if self.vehicles[props.plate] == nil then return end

--     if netId ~= nil and netId > 0 then
--       self.vehicles[props.plate].netId = netId

--       local entityVeh = NetworkGetEntityFromNetworkId(netId)
--       self.vehicles[props.plate].entity = entityVeh

--       self.vehicles[props.plate].props = props

--       if trailer ~= nil and trailer.netId > 0 then
--         self.vehicles[props.plate].trailer = trailer
--       end
--     end
    
--     self.vehicles[props.plate].pos = {
--       x = coordsVeh.x,
--       y = coordsVeh.y,
--       z = coordsVeh.z,
--       h = heading,
--       r = { x = rot.x, y = rot.y, z = rot.z }
--     }
--   end
  
--   -- we shouldn't need to do this but so many people report duplicate vehicles spawning.. 
--   function PV:RemoveDuplicates(payloads)
--     -- local allVehicles = GetAllVehicles()
--     local plates = {}
--     local newresult = {}
--     for k, vehicles in pairs(GetAllVehicles()) do
--     -- for i=1, #allVehicles do
--       plates[GetVehicleNumberPlateText(vehicles)] = true
--     end
--     --throttle
--     Citizen.Wait(0) 
    
--     for id, data in pairs(payloads) do
--       -- for i=1, #data do
--         for k, result in pairs(data) do
--           if plates[result.props.plate] and DistanceBetweenCoords(vector3(result.pos.x, result.pos.y, result.pos.z), GetEntityCoords(vehicle)) >= 1 then
--             if self.debugging then
--               print('Persistent Vehicles: Duplicate vehicle prevented from spawning ' ..  result.props.plate)
--             end
--             -- self:ForgetVehicle(result.props.plate)
--             result = nil
--           else
--             if newresult[id] == nil then
--               newresult[id] = {}
--             end
--             table.insert(newresult[id], result)
--           end
--         end
--     end
    
--     return newresult
--   end
  
--   function PV:TriggerSpawnEvents()
--     local payloads = {}
--     local requests = 0
--     local spawned = 0
  
--     for plate, data in pairs(self.vehicles) do
  
--       if data.entity == nil or not DoesEntityExist(data.entity) then
--         if data.pos then
--           -- throttle if request gets too large
--           requests = requests + 1
--           if requests % 3 == 0 then
--             Citizen.Wait(0)
--           end
  
--           if Config.VehiclePerm.forgetOnDestroyed and data.forgetOn ~= nil and GetGameTimer() > data.forgetOn then
--               self:ForgetVehicle(plate)
--           else
  
--             local closestPlayerId, closestDistance = GetClosestPlayerToCoordsVehPerm(self.players, data.pos)
  
  
--             -- only spawn the vehicle if a client is close enough
--             if closestPlayerId ~= nil and closestDistance < Config.VehiclePerm.respawnDistance then
  
--               if payloads[closestPlayerId] == nil then
--                 payloads[closestPlayerId] = {}
--                 spawned = spawned + 1 -- cheaper than counting the payloads
--               end
              
--               -- limit total number of vehicles this player will spawn this tick
--               if #payloads[closestPlayerId] <= 10 then
--                 table.insert(payloads[closestPlayerId], data)
--               end
--             end
--           end
--         else
--           self:ForgetVehicle(plate)
--           if self.debugging then
--             print('Persistent Vehicles: Warning', plate, 'did NOT have time to update its position before it was deleted')
--           end
--         end
--       end
--     end
    
--     if spawned > 0 then
--       Citizen.Wait(0)
--       self.waiting = {}
  
--       -- payloads = self:RemoveDuplicates(payloads)
  
--       -- consume any respawn requests we have
--       for id, payload in pairs(payloads) do
--         if DoesEntityExist(GetPlayerPed(id)) and #payload > 0 then
--           TriggerClientEvent('persistent-vehicles/spawn-vehicles', id, payload)
--           self.waiting[id] = true
--           if self.debugging then
--             print('Persistent Vehicles: Sent', #payload, 'vehicle(s) to client', id, 'for spawning.')
--           end
--         end
--       end
  
--       -- wait upto 6 seconds for clients to report that they've finished spawning. Nearly all should report in the first tick.
--       local waited = 0
--       repeat
--         Citizen.Wait(500)
--         waited = waited + 1
--       until Core.Math.Tablelength(self.waiting) == 0 or waited == 12
--       if self.debugging and waited >= 12 then
--         print('Persistent Vehicles: Waited too long for ' .. Core.Math.Tablelength(self.waiting) .. ' client(s) to respawn vehicles')
--       end
--     end
--   end
  
--   function PV:UpdateAllVehicleData()
--       for plate, data in pairs(self.vehicles) do
--         if data.entity ~= nil and DoesEntityExist(data.entity) then
--           if data.props and data.pos then

--             local coords = GetEntityCoords(data.entity)
--             while coords == nil do
--               Wait(5)
--               coords = GetEntityCoords(data.entity)
--             end

--             if DistanceBetweenCoords(data.pos, coords) <= 320 then
              
--             -- local closestPlayerId, closestDistance = GetClosestPlayerToCoordsVehPerm(self.players, data.pos)
--             -- if closestPlayerId ~= nil and closestDistance < 250 then
              
--               local rot = GetEntityRotation(data.entity)

--               data.pos = {
--                 x = coords.x,
--                 y = coords.y,
--                 z = coords.z,
--                 h = GetEntityHeading(data.entity),
--                 r = { x = rot.x, y = rot.y, z = rot.z }
--               }

--               --data.props.fuelLevel = 25 -- maybe GetVehicleFuelLevel() will be implemented server side one day?
--               local Vehlocked = GetVehicleDoorLockStatus(data.entity)
--               if Vehlocked <= 1 then
--                 data.props.locked = 1
--               elseif Vehlocked >= 2 then
--                 data.props.locked = 2
--               end
--               data.props.engine = GetIsVehicleEngineRunning(data.entity)
--               data.props.engineHealth = GetVehicleEngineHealth(data.entity)
--               data.props.tankHealth = GetVehiclePetrolTankHealth(data.entity)
--               data.props.dirtLevel = GetVehicleDirtLevel(data.entity)
--               data.props.bodyHealth = GetVehicleBodyHealth(data.entity)
--               if data.props.damage == nil then
--                 data.props.damage = {}
--               end
--               data.props.damage.tyre = {
--                   [0] = IsVehicleTyreBurst(data.entity, 0, false),
--                   [1] = IsVehicleTyreBurst(data.entity, 1, false),
--                   [2] = IsVehicleTyreBurst(data.entity, 2, false),
--                   [3] = IsVehicleTyreBurst(data.entity, 3, false)
--               }
--             end

--             -- forget vehicle if destroyed
--             if Config.VehiclePerm.forgetOnDestroyed and (data.props.bodyHealth < 0 or data.props.tankHealth < 0) then
--               self:ForgetVehicle(plate)
--             end
    
--           else
--             self:ForgetVehicle(plate)
--           end
          
--         end
--       end
--   end

--   function PV:DeleteVehiclePnjSamePlate()
--     local VehDelete = {}
--     for _, vehicle in pairs(GetAllVehicles()) do
--         for plate, idVehicle in pairs(self.vehicles) do
--           -- print(vehicle == NetworkGetEntityFromNetworkId(idVehicle.netId))
--           -- if idVehicle.props.plate == plate then
--           --   print(plate)
--           -- end
--           if DoesEntityExist(vehicle) and vehicle ~= NetworkGetEntityFromNetworkId(idVehicle.netId) and idVehicle.props.plate == plate then
--             -- print(Core.Math.Trim(GetVehicleNumberPlateText(vehicle)), plate)
--             local coords = nil
--             while coords == nil do
--               coords = GetEntityCoords(vehicle)
--               Wait(10)
--             end
--             local closestPlayerId, closestDistance = GetClosestPlayerToCoordsVehPerm(self.players, coords)
--             if closestPlayerId ~= nil and closestDistance < Config.VehiclePerm.respawnDistance then
--               if VehDelete[closestPlayerId] == nil then
--                 VehDelete[closestPlayerId] = {}
--               end   
--               table.insert(VehDelete[closestPlayerId], {plate = plate, entity = vehicle, pos = coords})
--             end
--             break
--           end
--         end
--     end
--     if #VehDelete > 0 then
--       for idPlayer, TableVehicle in pairs(VehDelete) do
--         TriggerClientEvent('persistent-vehicles/delete-vehicles', idPlayer, TableVehicle)
--       end
--     end
--   end
  
  -- -- main thread
  -- Citizen.CreateThread(function ()
  
  --   if Config.VehiclePerm.populateOnReboot then
  --     PV:LoadVehiclesFromFile() 
  --   end
    
  --   while true do
  --     Citizen.Wait(Config.VehiclePerm.serverTickTime)
  --     -- PV:DeleteVehiclePnjSamePlate()
  --     -- PV:UpdateAllVehicleData()
  --     Citizen.Wait(0)
  --     PV:TriggerSpawnEvents()
  --   end
  -- end)

  -- Citizen.CreateThread(function() 
  --   while true do
  --     Citizen.Wait(60000)
  --     PV:SavedPlayerVehiclesToFile()
  --   end
  -- end)