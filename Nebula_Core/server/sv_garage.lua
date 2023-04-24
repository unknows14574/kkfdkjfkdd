--State garage
-- 0 = Sortie
-- 1 = Dans Garage
-- 2 = Volé par un joueur
-- 3 = En Fourrière
-- 4 = Saisie par la police 
-- 5 = Véhicule Volé d'un joueur Rentré
-- 6 = Véhicule Volé d'un joueur Sortie
-- 7 = Véhicule mis aux enchères
-- 8 = Véhicule en contrôle / réparation Benny's
-- 9 = Véhicule en contrôle / réparation LS Custom North

local TabVehiclePlayer = {}
local TabAllVehicles   = {}

--Génération de nouvelle plaque
-- local function NewPlateCheckBDD()
--     local newplate = nil

--     while newplate == nil do
--         newplate = Core.Math.RandomNumberLength(2) .. Core.Math.RandomStringLength(3, true) .. Core.Math.RandomNumberLength(3)

--         if #TabVehiclePlayer >= 1 then
--             for k, v in pairs(TabVehiclePlayer) do
--                 if v.plate == newplate then
--                     newplate = nil
--                 end
--             end
--         else
--             local newdata = MySQL.query.await("SELECT 1 FROM owned_vehicles WHERE plate=@plate",{['@plate'] = newplate})	
        
--             if #newdata >= 1 then
--                 newplate = nil
--             end
--         end

--         Citizen.Wait(5)
--     end

--     return newplate
-- end

--LoadVehiclePlayer
function LoadAllVehicles()
    MySQL.query("SELECT owned_vehicles.id, owned_vehicles.plate, owned_vehicles.owner, owned_vehicles.owner2, owned_vehicles.assurance, owned_vehicles.state, owned_vehicles.garage, owned_vehicles.IsGrade, owned_vehicles.model, vehicles.price FROM owned_vehicles INNER JOIN vehicles ON owned_vehicles.model = vehicles.model",
    {}, function(data) 
        for k, v in pairs(data) do
            if TabVehiclePlayer[v.id] == nil then
                TabVehiclePlayer[v.id] = {
                    state = v.state, 
                    plate = v.plate, 
                    model = v.model,
                    garage = v.garage,
                    IsGrade = v.IsGrade, 
                    assurance = v.assurance, 
                    price = v.price,
                    owner = v.owner, 
                    owner2 = v.owner2
                }
            end
        end
    end)
end

function LoadInfosForVehicleById(IdVehicle)
    local data = MySQL.query.await("SELECT owned_vehicles.id, owned_vehicles.vehicle, owned_vehicles.plate, owned_vehicles.assurance, owned_vehicles.state, owned_vehicles.garage, owned_vehicles.health, owned_vehicles.IsGrade, owned_vehicles.model, vehicles.price FROM owned_vehicles INNER JOIN vehicles ON owned_vehicles.model = vehicles.model WHERE id=@id",{ ['@id'] = IdVehicle })

    return data
end


local function InsertVehicleInLocalTable(Data)
    local IdNewVeh = nil
    if type(Data) == "number" then
        IdNewVeh = Data
    else
        local result = MySQL.query.await("SELECT owned_vehicles.id FROM owned_vehicles WHERE plate=@plate",{ ["plate"] = Data.plate })
        IdNewVeh = result[1].id
    end
    if TabVehiclePlayer[IdNewVeh] == nil then
        TabVehiclePlayer[IdNewVeh] = {
            state = Data.state, 
            plate = Data.plate, 
            garage = Data.garage,
            model = Data.model,
            IsGrade = Data.IsGrade, 
            assurance = Data.assurance, 
            price = Data.price,
            owner = Data.owner, 
            owner2 = Data.owner2
        }
    end
end

function UpdateVehicleById(IdVehicle, InfosUpdate)
    local Requete = "UPDATE owned_vehicles SET "
    local Argument = { ["@id"] = IdVehicle }

    for k, v in pairs(InfosUpdate) do
        if TabVehiclePlayer[IdVehicle] ~= nil then
            TabVehiclePlayer[IdVehicle][k] = v
        end
        Requete = Requete .. k .. "=@" .. k .. ((#InfosUpdate == k and ", ") or " WHERE id=@id")
        Argument["@" .. k] = v
    end

    MySQL.update.await(Requete, Argument)
end

function DupliVehicleForId(IdVehicle, InfosModif)
    local data = LoadInfosForVehicleById(IdVehicle)
    local newplate = NewPlateCheckBDD()

    data = {
        plate = newplate,
        assurance = ((InfosModif.assurance ~= nil and InfosModif.assurance) or data.assurance),
        state = ((InfosModif.state ~= nil and InfosModif.state) or data.state),
        garage = ((InfosModif.garage ~= nil and InfosModif.garage) or data.garage),
        health = ((InfosModif.health ~= nil and InfosModif.health) or data.health),
        IsGrade = ((InfosModif.IsGrade ~= nil and InfosModif.IsGrade) or data.IsGrade),
        price = ((InfosModif.price ~= nil and InfosModif.price) or data.price),
        owner = ((InfosModif.owner ~= nil and InfosModif.owner) or data.owner),
        owner2 = ((InfosModif.owner2 ~= nil and InfosModif.owner2) or data.owner2)
    }

    MySQL.update.await('INSERT INTO owned_vehicles (vehicle, plate, assurance, state, garage, health, IsGrade, price, owner, owner2, model) VALUES (@vehicle, @plate, @assurance, @state, @garage, @health, @IsGrade, @price, @owner, @owner2, @model)', {
        ['@vehicle'] = data.vehicle,
        ['@plate'] = data.plate,
        ['@assurance'] = data.assurance,
        ['@state'] = data.state,
        ['@garage'] = data.garage,
        ['@health'] = data.health,
        ['@IsGrade'] = data.IsGrade,
        ['@price'] = data.price,
        ['@owner'] = data.owner,
        ['@owner2'] = data.owner2,
        ["@model"] = data.model
    }) 

    InsertVehicleInLocalTable(data)
end

function ReturnVehicleByOwner(Owner)
    local VehicleOwner = {}

    for k, v in pairs(TabVehiclePlayer) do
        if v.owner == Owner or v.owner2 == Owner then
            if VehicleOwner[v.plate] == nil then
                VehicleOwner[v.plate] = {
                    id = k,
                    state = v.state, 
                    garage = v.garage,
                    IsGrade = v.IsGrade, 
                    assurance = v.assurance, 
                    price = v.price, 
                    owner = v.owner, 
                    owner2 = v.owner2,
                    model = v.model
                }
            end
        end
    end

    return VehicleOwner
end

function SearchInfoVehicleByPlate(Plate)
    for k, v in pairs(TabVehiclePlayer) do
        if v.plate == Plate then
            return v
        end
    end

    return nil
end



--VehicleLock
-- RegisterServerCallback('CoreGarage:RequestPlayerCars', function(source, cb, plate)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     local VehiclePlayer = SearchInfoVehicleByPlate(plate)

--     if VehiclePlayer.owner == xPlayer.identifier or VehiclePlayer.owner2 == xPlayer.identifier or VehiclePlayer.owner == xPlayer.job.name or VehiclePlayer.owner == xPlayer.job2.name then
--         cb(true)
--     else
--         cb(false)
--     end
-- end)



--Assurance Paiment automatique
-- function PayRent(d, h, m)
--     local tablejobs = {}
--     MySQL.query('SELECT jobs.name FROM jobs', {}, function(result3)
--         for f=1, #result3, 1 do
--           table.insert(tablejobs, result3[f].name)
--         end
--     end)
  
--     MySQL.query('SELECT users.contrib, users.bank, users.identifier FROM users',{}, function(_users)
--         local TablePlayer = {}
    
--         for i=1, #_users, 1 do
--             TablePlayer[_users[i].identifier] = {}
--             TablePlayer[_users[i].identifier].contrib = _users[i].contrib
--             TablePlayer[_users[i].identifier].PrevMoney = _users[i].bank
--             TablePlayer[_users[i].identifier].MoneyPlayer = _users[i].bank
--         end
    
--         local xPlayers = GetPlayers()

--         for l, m in pairs(TabVehiclePlayer) do
--             local price = tonumber(m.price * (iV.Blips.Assurance.Pourcentage / 100))
--             local xPlayer = nil
--             local Entreprise = false

--             for j=1, #xPlayers, 1 do
--                 if GetPlayerIdentifier(xPlayers[j]) == m.owner then
--                     if not DiscordIsRolePresent(xPlayers[j], {"📱 Contributeur #13", "📱 Contributeur #12", "📱 Contributeur #11", "📱 Contributeur #10", "📱 Contributeur #9", "📱 Contributeur #8", "📱 Contributeur #7", "📱 Contributeur #6", "📱 Contributeur #5", "📱 Contributeur #4"}) then
--                         xPlayer = ESX.GetPlayerFromId(xPlayers[j])
--                         xPlayer.removeBank(price)
--                         TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez ~g~payé~s~ ~g~$" .. price .. " ~s~d'assurance.")
--                     end
--                 end
--             end
            
--             if xPlayer == nil then
--                 for j=1, #tablejobs, 1 do
--                     if tablejobs[j] == m.owner then
--                         Entreprise = true
--                         TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. m.owner, function (account)
--                             account.removeMoney(price)
--                         end)
--                     end
--                 end
--             end
            
--             if xPlayer == nil and not Entreprise then
--                 for k, v in pairs(TablePlayer) do
--                     if k == m.owner and TablePlayer[k].contrib == 0 then
--                         TablePlayer[m.owner].MoneyPlayer = TablePlayer[m.owner].MoneyPlayer - price
--                     end
--                 end
--             end
--         end 

--         for k, v in pairs(TablePlayer) do
--             if TablePlayer[k].MoneyPlayer ~= TablePlayer[k].PrevMoney then
--                 MySQL.update('UPDATE users SET bank = @bank WHERE identifier = @identifier',
--                 {
--                     ['@bank']       = TablePlayer[k].MoneyPlayer,
--                     ['@identifier'] = k
--                 })
--             end
--         end
--     end)
-- end
  
-- TriggerEvent('cron:runAt', 22, 0, PayRent)

--Retour automatique assurance
function ReturnVehicleByAssurance()
    MySQL.query('SELECT owned_vehicles.id, owned_vehicles.vehicle, owned_vehicles.plate FROM owned_vehicles WHERE (state = @state) AND (assurance = @assurance) AND (date_vol IS NOT NULL) AND (DATEDIFF(CURRENT_TIMESTAMP(), date_vol) >= ' .. Config.Garage.DayReturnVehicleAssurance .. ')', {
        ['@state'] = 2, 
        ['@assurance'] = 1
    }, function(results)
        for k, v in pairs(results) do
            local vehicleProp = json.decode(v.vehicle)
            local newplate = NewPlateCheckBDD()

            vehicleProp.plate = newplate
            local vehiclePropEncode = json.encode(vehicleProp)

            UpdateVehicleById(v.id, { state = 1, plate = newplate, vehicle = vehiclePropEncode })
        end
    end)
end

--Suppression des lignes de véhicules volés sorties, donc perdu
function DeleteOldVehicleStolen()
    for k, v in pairs(TabVehiclePlayer) do
        if v.state == 6 then
            MySQL.update('DELETE FROM owned_vehicles WHERE id = @id', {
                ['@id'] = k
            })  
            TabVehiclePlayer[k] = nil
        end
    end
end

--Remet les vehicules a la fourriere si n'existe plus sur la map param
function SetVehicleFourriere()
    for k, v in pairs(TabVehiclePlayer) do
        if v.state == 0 then
            v.state = 3
            UpdateVehicleById(v.id, { state = v.state })
        end
    end
end

RegisterServerEvent('Core:SetVehicleFourriere')
AddEventHandler('Core:SetVehicleFourriere', function(plate)
    MySQL.update.await('UPDATE owned_vehicles SET state = @state WHERE plate = @plate', {
        ['@state'] = 3,
        ['@plate'] = plate,
    })
end)

-- MySQL.ready(function()
--     LoadJobGarage()
--     LoadAllVehicles()
--     ReturnVehicleByAssurance()
--     DeleteOldVehicleStolen()
--     SetVehicleFourriere()
-- end)

-- SetTimeout(1800000, SetVehicleFourriere)



-- event
RegisterEvent('Core-Garage:UpdateVehicleInfos', function(IdVehicle, InfosVehicle)
    UpdateVehicleById(IdVehicle, InfosVehicle)
end)






-- callback 

-- GetVehiclesByOwner si pas argument renvoie ceux de celui qui a appellé si arg renvoie de l'arg
RegisterCallback('Core-Garage:GetVehiclesByOwner', function(source, identifier)
    if identifier then
        if type(identifier) == "number" then
            source = GetPlayerIdentifier(identifier)
        else
            source = identifier
        end
    else
        source = GetPlayerIdentifier(source)
    end

    return ReturnVehicleByOwner(source)
end)




--Temp a revoir quand systeme v2 finit

--loadjob
-- local TableJob, TableJobLabel = {}, {}
-- function LoadJobGarage()
--     MySQL.query('SELECT * FROM jobs', {}, function(results)
-- 		for k, v in pairs(results) do
-- 			TableJob[v.name] = {}
-- 			TableJobLabel[v.name] = { label = v.label }
-- 		end
-- 		MySQL.query('SELECT * FROM job_grades', {}, function(results)
-- 			for k, v in pairs(results) do
-- 				if TableJobLabel[v.job_name].grade == nil then
-- 					TableJobLabel[v.job_name].grade = {}
-- 				end
-- 				table.insert(TableJobLabel[v.job_name].grade, { job_name = v.job_name, id = v.grade, name = v.name, label = v.label })
-- 			end
-- 		end)
-- 	end)
-- end


-- --Getjob
-- RegisterCallback('Core-Garage:job', function(source)
--     local ResultTable = {}
--     for k, v in pairs(TableJob) do
--         table.insert(ResultTable, {label = v.label, name = k})
--     end

--     return ResultTable
-- end)

-- --GetjobGrades
-- RegisterCallback('Core-Garage:job_grade', function(source, jobName)
--     local result = MySQL.query.await('SELECT users.firstname, users.lastname, users.identifier FROM users WHERE job = @jobname OR job2=@job2name',{ ['@jobname'] = jobName, ['@job2name'] = jobName })

--     local resultUser = {}
--     for _, v in pairs(result) do
--         table.insert(resultUser, {firstname = v.firstname, lastname = v.lastname, identifier = v.identifier})
--     end

--     return TableJobLabel, resultUser
-- end)

-- --CheckMoney
-- RegisterCallback('Core-Garage:checkMoney', function(source, plate)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     if xPlayer.getMoney() >= iV.Blips.Fourriere.Price then
--         xPlayer.removeMoney(iV.Blips.Fourriere.Price) 
--         TriggerEvent('Core-Garage:modifystate', plate, 0, "0", {engine=1000.0, body=1000.0, fuel=100.0})
--         TriggerClientEvent('Core:ShowNotification', source, 'Vous avez payé ' .. iV.Blips.Fourriere.Price)
--         return true
-- 	else
--         TriggerClientEvent('Core:ShowNotification', source, 'Vous n\'avez pas assez d\'argent')
--         return false
-- 	end
-- end)











--================================================================================================
--==                                            OLD                                             ==
--================================================================================================

local function NewPlateCheckBDD()
    local newplate = nil

    while newplate == nil do
        newplate = Core.Math.RandomNumberLength(2) .. Core.Math.RandomStringLength(3, true) .. Core.Math.RandomNumberLength(3)

        local newdata = MySQL.query.await("SELECT 1 FROM owned_vehicles WHERE plate=@plate",{['@plate'] = newplate})	

        local newdata2 = MySQL.query.await("SELECT 1 FROM stolen_vehicles WHERE plate=@plate",{['@plate'] = newplate})
        
        if #newdata >= 1 or #newdata2 >= 1 then
            newplate = nil
        end

        Citizen.Wait(5)
    end

    return newplate
end

--VehicleLock
RegisterServerCallback('Core:requestPlayerCars', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.query(
		'SELECT owned_vehicles.owner, owned_vehicles.owner2 FROM owned_vehicles WHERE plate = @plate LIMIT 1', 
		{
			['@plate'] = plate
		},
	function(result)
		if #result >= 1 then 
			if result[1].owner == xPlayer.identifier or result[1].owner2 == xPlayer.identifier or result[1].owner == xPlayer.job.name or result[1].owner == xPlayer.job2.name then
				cb(true)
			end
		else
			cb(false)
		end
	end)
end)

--Assurance Paiment automatique
function PayRent(d, h, m)
    print('## NEBULA - CORE : CHECK FOR INSURANCE TO PAY ##')
    local tablejobs, tablevehicles = {}, {}
    MySQL.query('SELECT jobs.name FROM jobs', {}, function(result3)
        for f=1, #result3, 1 do
          table.insert(tablejobs, result3[f].name)
        end
    end)

    MySQL.query("SELECT vehicles.model, vehicles.price FROM vehicles", {}, function(data) 
        for _,v in pairs(data) do
            table.insert(tablevehicles, {model = v.model, price = v.price})
        end
    end)
  
    MySQL.query('SELECT users.contrib, users.accounts, users.identifier FROM users',{}, function(_users)
        local MoneyPlayer = {}
        local PrevMoney = {}
        local Contrib = {}
    
        for i=1, #_users, 1 do
            local accounts = json.decode(_users[i].accounts)
            Contrib[_users[i].identifier] = _users[i].contrib
            PrevMoney[_users[i].identifier] = accounts.bank
            MoneyPlayer[_users[i].identifier] = accounts.bank
        end
    
        MySQL.query('SELECT owned_vehicles.model, owned_vehicles.owner, owned_vehicles.plate FROM owned_vehicles WHERE assurance = @assurance', {['@assurance'] = 1}, function(result)
            if result ~= 0 then
                local xPlayers = GetPlayers()
    
                for i=1, #result, 1 do
                    local price = 0
                    local xPlayer = nil
                    local Entreprise = false

                    for l, m in pairs(tablevehicles) do
                        if string.lower(m.model) == string.lower(tostring(result[i].model)) then
                            price = tonumber(m.price * (iV.Blips.Assurance.Pourcentage / 100))
                        end
                    end
        
                    for j=1, #xPlayers, 1 do
                        if GetPlayerIdentifier(xPlayers[j]) == result[i].owner then
                            if tonumber(Contrib[result[i].owner]) ~= 1 then
                                if not DiscordIsRolePresent(xPlayers[j], {"📱 Contributeur #13", "📱 Contributeur #12", "📱 Contributeur #11", "📱 Contributeur #10", "📱 Contributeur #9", "📱 Contributeur #8", "📱 Contributeur #7", "📱 Contributeur #6", "📱 Contributeur #5", "📱 Contributeur #4"}) then
                                    xPlayer = ESX.GetPlayerFromId(xPlayers[j])
                                    if xPlayer.getAccount('bank').money >= price then
                                        xPlayer.removeBank(price, "Paiement assurance du véhicule "..result[i].plate..".", "assurance")
                                        TriggerClientEvent('Core:ShowAdvancedNotification', xPlayer.source, "Assurance", "Notification", "Vous avez ~g~payé~w~ vos frais d'assurances ! ~n~~n~Montant: ~g~$" .. price .. "~w~.", "CHAR_MP_MORS_MUTUAL", 1, false, true, 140)
                                    else
                                        print("Removing insurance for vehicle "..result[i].plate)
                                        MySQL.update('UPDATE owned_vehicles SET assurance = @assurance WHERE plate = @plate',
                                        {
                                            ['@assurance']       = 0,
                                            ['@plate'] = result[i].plate
                                        })
                                        TriggerClientEvent('Core:ShowAdvancedNotification', xPlayer.source, "Assurance", "Notification", "Vous n'avez ~r~pas assez~w~ pour payer vos frais d'assurances ! Votre contrat a donc été radié.", "CHAR_MP_MORS_MUTUAL", 1, false, true, 140)
                                    end
                                end
                            end
                        end
                    end
                    
                    if xPlayer == nil then
                        for j=1, #tablejobs, 1 do
                            if tablejobs[j] == result[i].owner then
                                Entreprise = true
                                if result[i].owner ~= 'ambulance' and result[i].owner ~= 'police' and result[i].owner ~= 'gouv' and result[i].owner ~= 'sheriff' then
                                    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. result[i].owner, function (account)
                                        if account ~= nil then
                                            if account.money >= price then
                                                account.removeMoney(price, "Paiement assurance du véhicule "..result[i].plate..".", "assurance")
                                            else
                                                print("Removing insurance for vehicle "..result[i].plate)
                                                MySQL.update('UPDATE owned_vehicles SET assurance = @assurance WHERE plate = @plate',
                                                {
                                                    ['@assurance']       = 0,
                                                    ['@plate'] = result[i].plate
                                                })
                                            end
                                        end
                                    end)
                                end
                            end
                        end
                    end
                    
                    if xPlayer == nil and not Entreprise then
                        for k, v in pairs(Contrib) do
                            if k == result[i].owner and v == 0 then
                                if tonumber(MoneyPlayer[result[i].owner]) >= tonumber(price) then
                                    MoneyPlayer[result[i].owner] = ESX.Math.Round(MoneyPlayer[result[i].owner] - price)
                                    MySQL.update("INSERT INTO `transactions` (from_identifier, from_last_name, from_first_name, to_identifier, to_last_name, to_first_name, reason, amount, `at`, `usage`) SELECT @JOUEUR_STEAMID, users.lastname, users.firstname, 'unknown', 'unknown', 'unknown', @type, @MONTANT, NOW(), @usage FROM `users` WHERE users.identifier = @JOUEUR_STEAMID", {
                                        ['@JOUEUR_STEAMID'] = result[i].owner,
                                        ['@type'] = "Paiement assurance du véhicule "..result[i].plate,
                                        ['@MONTANT'] = ESX.Math.Round(price),
                                        ['@usage'] = "assurance"
                                    })
                                else
                                    print("Removing insurance for vehicle "..result[i].plate)
                                    MySQL.update('UPDATE owned_vehicles SET assurance = @assurance WHERE plate = @plate',
                                    {
                                        ['@assurance']       = 0,
                                        ['@plate'] = result[i].plate
                                    })
                                end
                            end
                        end
                    end
                end 
            end
    
        end)

        Citizen.Wait(20000) -- Wait pour que le script ai le temps de calculer le montant à retirer de la banque.

        for k,v in pairs(MoneyPlayer) do
            if v ~= PrevMoney[k] then
                local userResult = MySQL.query.await('SELECT * FROM users WHERE identifier = @identifier LIMIT 1', { ['@identifier'] = k})
                if userResult ~= nil and #userResult >= 1 then
                    local user = userResult[1]
                    local accounts = json.decode(user.accounts)
                    accounts.bank = v
                    MySQL.update(
                    'UPDATE users SET accounts = @accounts WHERE identifier = @identifier',
                    {
                        ['@accounts']      = json.encode(accounts),
                        ['@identifier'] = k
                    })
                end
            end
        end

    end)
end
TriggerEvent('cron:runAt', 19, 15, PayRent)



--Retour automatique assurance + suppression des lignes de véhicules volés non utilisés
function reloadVehStolen()
    MySQL.query('SELECT owned_vehicles.vehicle, owned_vehicles.plate FROM owned_vehicles WHERE (state = @state) AND (assurance = @assurance) AND (((date_vol IS NOT NULL) AND (DATEDIFF(CURRENT_TIMESTAMP(), date_vol) >= 5)) OR date_vol IS NULL)', {
        ['@state'] = 2, 
        ['@assurance'] = 1
    }, function(results2)
        if results2 ~= nil then
            for k, v in pairs(results2) do
                local vehicleProp = json.decode(v.vehicle)
                local newplate = NewPlateCheckBDD()

                vehicleProp.plate = newplate
                local vehiclePropEncode = json.encode(vehicleProp)
                MySQL.update("UPDATE owned_vehicles SET state=@state, plate=@newplate, vehicle=@vehicle WHERE plate=@plate",{
                    ['@state'] = 1, 
                    ['@plate'] = v.plate, 
                    ['@newplate'] = newplate, 
                    ['@vehicle'] = vehiclePropEncode
                })
            end
        end
    end)

    MySQL.query('SELECT stolen_vehicles.plate FROM stolen_vehicles WHERE state = @state', {
        ['@state'] = 0
    }, function(results2)
        if results2 ~= nil then
            for k, v in pairs(results2) do
                MySQL.update('DELETE FROM stolen_vehicles WHERE plate = @plate', {
                    ['@plate'] = v.plate
                })        
            end
        end
    end)
end

--Remet les vehicules a la fourriere si n'existe plus sur la map param
function GetVehicleFourr()
    print("[NEBULA CORE] - Mise en Fourrière")
    MySQL.query('SELECT owned_vehicles.plate FROM owned_vehicles WHERE state = @state', {
        ['@state'] = 0
    }, function(results2)
        if results2 ~= nil then
            for k, v in pairs(results2) do
                print(v.plate)
                MySQL.update("UPDATE owned_vehicles SET state=@state WHERE plate=@plate",{
                    ['@state'] = 3, 
                    ['@plate'] = v.plate
                })      
            end
        end
    end)
end

local function SearchVehicleData(plate, table)
    for k, v in pairs(table) do
        if plate == v then
            return true 
        end
    end

    return false
end

local function GetAllVehiclesModels()
    MySQL.query("SELECT vehicles.price, vehicles.name, vehicles.model FROM vehicles", {}, function(data) 
        for _,v in pairs(data) do
            table.insert(TabAllVehicles, {price = v.price, model = v.model, name = v.name})
        end
    end)
end

-- function GetVehicleFourr()
--     print("Mise en Fourrière")

--     TriggerEvent('harybo_permanent:returnVehicle', function(tablePlate)
--         MySQL.query('SELECT owned_vehicles.plate FROM owned_vehicles WHERE state = @state', {
--             ['@state'] = 0
--         }, function(results2)
--             if results2 ~= nil then
--                 for k, v in pairs(results2) do
--                     if tablePlate[v.plate] == nil then
--                         MySQL.update("UPDATE owned_vehicles SET state=@state WHERE plate=@plate",{
--                             ['@state'] = 3, 
--                             ['@plate'] = v.plate
--                         })      
--                     end
--                 end
--             end
--         end)
--     end)
-- end

-- function ReloadFourrVeh()
-- 	SetTimeout(1800000, function()
-- 		GetVehicleFourr()
-- 		ReloadFourrVeh()
-- 	end)
-- end
-- ReloadFourrVeh()

MySQL.ready(function ()
    reloadVehStolen()
    GetVehicleFourr()
    GetAllVehiclesModels()
    -- ReloadFourrVeh()
end)

-- function ReloadVehFouSto()
--     SetTimeout(1800000, function()
--         GetVehicleFourr()
--         ReloadVehFouSto()
--     end)
-- end

RegisterServerEvent('Core-Garage:ChangeNameVeh')
AddEventHandler('Core-Garage:ChangeNameVeh', function(plate, name_vehicle, identifierType)
    local requete = "UPDATE owned_vehicles SET name_vehicle=@name_vehicle WHERE plate=@plate"
    if identifierType == "stolen" then
        requete = "UPDATE stolen_vehicles SET name_vehicle=@name_vehicle WHERE plate=@plate"
    end
    MySQL.update.await(requete,{
        ['@name_vehicle'] = name_vehicle, 
        ['@plate'] = plate
    })
end)

RegisterServerEvent('Core-Garage:GradeChangeVeh')
AddEventHandler('Core-Garage:GradeChangeVeh', function(plate, GradeChoose)
    MySQL.update.await("UPDATE owned_vehicles SET IsGrade=@gradeChoose WHERE plate=@plate",{
        ['@gradeChoose'] = json.encode(GradeChoose), 
        ['@plate'] = plate
    })
end)

RegisterServerEvent('Core-Garage:modifystate')
AddEventHandler('Core-Garage:modifystate', function(plate, state, garage, health, stolen)
    local requete = "UPDATE owned_vehicles SET state=@state, garage=@garage, health=@health WHERE plate=@plate"
    if stolen == "stolen" then
        requete = "UPDATE stolen_vehicles SET state=@state, garage=@garage, health=@health WHERE plate=@plate"
    end
    if not garage then
        garage = "0"
    end
    if not health then
        health = {engine = 1000.0, body = 1000.0, fuel = 100.0}
    end
    local value = {
        ['@state'] = state,
        ['@garage'] = garage,
        ['@health'] = json.encode(health),
        ['@plate'] = plate
    }
    MySQL.update.await(requete, value)
end)	

local function getVehiclesPlate(plate)
    local vehicles, vehiclesStolen = nil, nil
    local data = MySQL.query.await("SELECT owned_vehicles.id, owned_vehicles.owner, owned_vehicles.state, owned_vehicles.plate, owned_vehicles.owner2 FROM owned_vehicles WHERE plate=@plate LIMIT 1",{['@plate'] = plate})
    while data == nil do
        Wait(5)
    end
    if #data >= 1 then
        vehicles = {id = data[1].id, plate = data[1].plate, state = data[1].state, owner = data[1].owner, owner2 = data[1].owner2}
    end
    local datastolen = MySQL.query.await("SELECT stolen_vehicles.id, stolen_vehicles.owner, stolen_vehicles.plate FROM stolen_vehicles WHERE plate=@plate LIMIT 1",{['@plate'] = plate})
    while datastolen == nil do
        Wait(5)
    end
    if #datastolen >= 1 then
        vehiclesStolen = {id = datastolen[1].id, plate = datastolen[1].plate, owner = datastolen[1].owner}
    end
    return vehicles, vehiclesStolen
end

RegisterServerCallback('Core-Garage:stockVehicle',function(source, cb, vehicleProps, garage, health, plate, TabJob, state)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicules, vehiculestolen = getVehiclesPlate(plate)
    while vehicules == nil do
        Wait(10)
    end
    if vehicules ~= nil or vehiculestolen ~= nil then
        if vehicules ~= nil and state then
            MySQL.update.await("UPDATE owned_vehicles SET vehicle=@vehprop, state=@state, garage=@garage, health=@health WHERE id=@id",{
                ['@vehprop'] = vehicleProps,
                ['@state'] = state,
                ['@garage'] = garage, 
                ['@health'] = health,
                ['@id'] = vehicules.id
            })
        elseif vehicules ~= nil and xPlayer.identifier == vehicules.owner or xPlayer.identifier == vehicules.owner2 or xPlayer.job.name == vehicules.owner or xPlayer.job2.name == vehicules.owner then
            MySQL.update.await("UPDATE owned_vehicles SET vehicle=@vehprop, state=@state, garage=@garage, health=@health WHERE id=@id",{
                ['@vehprop'] = vehicleProps,
                ['@state'] = 1, 
                ['@garage'] = garage, 
                ['@health'] = health,
                ['@id'] = vehicules.id
            })
        elseif vehiculestolen then
            MySQL.update.await("UPDATE stolen_vehicles SET owner=@identifier, state=@state, vehicle=@props, garage=@garage, health=@health WHERE id=@id",{
                ['@state'] = 1, 
                ['@props'] = vehicleProps, 
                ['@garage'] = garage, 
                ['@health'] = health, 
                ['@identifier'] = xPlayer.identifier,
                ['@id'] = vehiculestolen.id
            })
        elseif vehicules then
            local Numberdatastolen = MySQL.query.await("SELECT COUNT(*) FROM stolen_vehicles WHERE owner=@identifier",{['@identifier'] = xPlayer.identifier})
            while Numberdatastolen == nil do
                Wait(5)
            end
            if vehicules.state ~= 1 and Numberdatastolen[1]["COUNT(*)"] < iV.Blips.Garage.StolenGarage then -- Préventif pour les vols de véhicules étant DEJA rentré dans le garage.
                local healthEncodeUpdate = json.encode({engine=1000.0, body=1000.0, fuel=100.0})
                MySQL.update.await("UPDATE owned_vehicles SET state=@state, date_vol=CURRENT_TIMESTAMP(), garage=@garage, health=@health WHERE id=@id",{
                    ['@state'] = 2, 
                    ['@garage'] = "0", 
                    ['@health'] = healthEncodeUpdate, 
                    ['@id'] = vehicules.id
                })
                MySQL.update.await('INSERT INTO stolen_vehicles (owner, state, plate, vehicle, garage, health) VALUES (@identifier, @state, @plate, @props, @garage, @health)', {
                    ['@identifier'] = xPlayer.identifier,
                    ['@state'] = 1,
                    ['@plate'] = plate,
                    ['@props'] = vehicleProps,
                    ['@garage'] = garage,
                    ['@health'] = health
                })
                MySQL.update.await("UPDATE owned_vehicles SET state=@state, date_vol=CURRENT_TIMESTAMP(), garage=@garage, health=@health WHERE id=@id",{
                    ['@state'] = 2, 
                    ['@garage'] = "0", 
                    ['@health'] = healthEncodeUpdate, 
                    ['@id'] = vehicules.id
                })
            else
                if vehicules.state == 1 then
                    cb("Ce véhicule est déjà rangé par son propriétaire. Veuillez ressayer.")
                    return
                elseif Numberdatastolen[1]["COUNT(*)"] >= iV.Blips.Garage.StolenGarage then
                    cb("Vous avez trop de véhicule volé dans votre garage.")
                    return
                else
                    cb("Une erreur s'est produite.")
                    return
                end
            end
        else
            cb(false)
        end
        cb(true)
    else
        cb(false)
    end
end)



RegisterServerCallback('Core-Garage:getVehicles', function(source, cb, identifier, assurance, StateToAttribute, IsJob)
    --local vehiculesTab, plateTab = {}, {}
    local vehiculesTab = {}
    local IsContrib = false
    local requete = "SELECT owned_vehicles.price, owned_vehicles.vehicle, owned_vehicles.state, owned_vehicles.plate, owned_vehicles.garage, owned_vehicles.health, owned_vehicles.IsGrade, owned_vehicles.assurance, owned_vehicles.model, owned_vehicles.name_vehicle FROM owned_vehicles WHERE owner=@owner"
    if assurance then
        if not IsJob then
            IsContrib = DiscordIsRolePresent(source, {"📱 Contributeur #13", "📱 Contributeur #12", "📱 Contributeur #11", "📱 Contributeur #10", "📱 Contributeur #9", "📱 Contributeur #8", "📱 Contributeur #7", "📱 Contributeur #6", "📱 Contributeur #5", "📱 Contributeur #4"})
        end
        requete = "SELECT owned_vehicles.vehicle, owned_vehicles.state, owned_vehicles.plate, owned_vehicles.price, owned_vehicles.assurance, owned_vehicles.model, owned_vehicles.name_vehicle FROM owned_vehicles WHERE owner=@owner"
    elseif identifier == "owner2" then
        requete = "SELECT owned_vehicles.price, owned_vehicles.vehicle, owned_vehicles.state, owned_vehicles.plate, owned_vehicles.garage, owned_vehicles.health, owned_vehicles.IsGrade, owned_vehicles.assurance, owned_vehicles.model, owned_vehicles.name_vehicle FROM owned_vehicles WHERE owner2=@owner"
    elseif identifier == "stolen" then
        requete = "SELECT stolen_vehicles.vehicle, stolen_vehicles.state, stolen_vehicles.plate, stolen_vehicles.garage, stolen_vehicles.health, stolen_vehicles.name_vehicle FROM stolen_vehicles WHERE owner=@owner"
    elseif identifier == "special" then
        requete = "SELECT owned_vehicles.vehicle, owned_vehicles.state, owned_vehicles.plate, owned_vehicles.garage, owned_vehicles.health, owned_vehicles.IsGrade, owned_vehicles.assurance, owned_vehicles.model, owned_vehicles.name_vehicle FROM owned_vehicles WHERE state=@owner"
    end

    if identifier == "owner" or identifier == "owner2" or identifier == "stolen" then
        identifier = GetPlayerIdentifier(source)
    elseif identifier == "special" then
        identifier = StateToAttribute
    end

    MySQL.query(requete,{
        ['@owner'] = identifier
    }, function(data)
        for _,v in pairs(data) do
            for line, veh in pairs(TabAllVehicles) do
                if veh.model == v.model then
                    name_veh = veh.name
                    price_veh = veh.price
                else
                    name_veh = v.model
                    price_veh = v.price
                end
            end
            if IsContrib then
                if assurance then
                    price_veh = 0
                end
            end
            --table.insert(plateTab, v.plate)
            table.insert(vehiculesTab, {vehicle = v.vehicle, state = v.state, plate = v.plate, garage = v.garage, health = v.health, IsGrade = v.IsGrade, assurance = v.assurance, price = price_veh, model = v.model, name = name_veh, name_vehicle = v.name_vehicle})
        end

        -- TriggerEvent('harybo_permanent:returnPosVehicle', function(pos)
        --     while pos == nil do
        --         Wait(10)
        --     end

        --     for k, v in pairs(vehiculesTab) do
        --         for plate, posActual in pairs(pos) do
        --             if v.plate == plate then
        --                 v.pos = posActual
        --             end
        --         end
        --     end
        -- end, plateTab)
    
        cb(vehiculesTab, GetPlayerIdentifier(source))
    end)
end)

RegisterServerCallback('Core-Garage:job_grade', function(source, cb, jobName)
    MySQL.query('SELECT * FROM job_grades WHERE job_name = @jobname', {
        ['@jobname'] = jobName
    }, function(results)
        MySQL.query('SELECT users.firstname, users.lastname, users.identifier FROM users WHERE job = @jobname OR job2=@job2name', {
            ['@jobname'] = jobName,
            ['@job2name'] = jobName
        }, function(results2)
            local resultUser = {}
            for _, v in pairs(results2) do
                table.insert(resultUser, {firstname = v.firstname, lastname = v.lastname, identifier = v.identifier})
            end
            cb(results, resultUser)
        end)
    end)
end)

RegisterServerCallback('Core-Garage:checkMoney', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= iV.Blips.Fourriere.Price then
        xPlayer.removeMoney(iV.Blips.Fourriere.Price) 
        TriggerEvent('Core-Garage:modifystate', plate, 0, "0", {engine=1000.0, body=1000.0, fuel=100.0})
        TriggerClientEvent('Core:ShowNotification', source, 'Vous avez payé ' .. iV.Blips.Fourriere.Price)
        cb(true)
	else
        TriggerClientEvent('Core:ShowNotification', source, 'Vous n\'avez pas assez d\'argent')
        cb(false)
	end
end)

-- Assurance
RegisterServerCallback('Core-Garage:assurancechange', function(source, cb, plate, assurance, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if (assurance == 1) and (xPlayer.getAccount('bank').money >= price) then
        MySQL.update("UPDATE owned_vehicles SET assurance=@assurance WHERE plate=@plate",{
            ['@assurance'] = assurance, 
            ['@plate'] = plate
        })
        cb(true)
    elseif assurance == 0 then
        MySQL.update("UPDATE owned_vehicles SET assurance=@assurance WHERE plate=@plate",{
            ['@assurance'] = assurance, 
            ['@plate'] = plate
        })
        cb("ok")
    else
        TriggerClientEvent('Core:ShowAdvancedNotification', source, "Assurance", "Notification", "Vous n'avez ~r~pas assez~w~ d'argent pour établir ce contrat.", "CHAR_MP_MORS_MUTUAL", 1, false, true, 130)
        cb(false)
    end
end)

-- -- Assurance
-- RegisterServerEvent('Core-Garage:assurancechange')
-- AddEventHandler('Core-Garage:assurancechange', function(plate, assurance, price)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     if (assurance == 1) and (xPlayer.getAccount('bank').money >= price) then
--         MySQL.update("UPDATE owned_vehicles SET assurance=@assurance WHERE plate=@plate",{
--             ['@assurance'] = assurance, 
--             ['@plate'] = plate
--         })
--         TriggerClientEvent('Core:ShowAdvancedNotification', "Assurance", "Notification", "Votre véhicule est maintenant assuré !", "CHAR_MP_MORS_MUTUAL", 1, false, true, 210)
--     elseif assurance == 0 then
--         MySQL.update("UPDATE owned_vehicles SET assurance=@assurance WHERE plate=@plate",{
--             ['@assurance'] = assurance, 
--             ['@plate'] = plate
--         })
--         TriggerClientEvent('Core:ShowAdvancedNotification', source, "Assurance", "Notification", "Votre véhicule n'est plus assuré !", "CHAR_MP_MORS_MUTUAL", 1, false, true, 130)
--     else
--         TriggerClientEvent('Core:ShowAdvancedNotification', source, "Assurance", "Notification", "Vous n'avez ~r~pas assez~w~ d'argent pour établir ce contrat.", "CHAR_MP_MORS_MUTUAL", 1, false, true, 130)
--     end
-- end)

--Prefecture
RegisterServerEvent('Core-Garage:AddDelPartageVehicle')
AddEventHandler('Core-Garage:AddDelPartageVehicle', function (plate, id)
    if id ~= "0" then
        TriggerClientEvent('Core:ShowNotification', id, "Vous etes en 2eme conducteur du véhicule " .. plate)
        id = GetPlayerIdentifier(id)
    end
  
    MySQL.update(
    'UPDATE owned_vehicles SET owner2 = @owner2 WHERE plate = @plate',
    {
        ['@owner2'] = id,
        ['@plate'] = plate
    })
end)


RegisterServerCallback('Core-Garage:GiveVehicle', function(source, cb, plate, id, price)
	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getBank() >= price then
        xPlayer.removeBank(price) 
        TriggerEvent('Core-Garage:AddDelPartageVehicle', plate, "0")
        if type(id) == "number" then
            id = GetPlayerIdentifier(id)
        end
        MySQL.update(
        'UPDATE owned_vehicles SET owner = @owner, IsGrade = \'[0]\' WHERE plate = @plate',
        {
            ['@owner'] = id,
            ['@plate'] = plate
        })
        cb(true)
	else
        cb(false)
	end
end)

RegisterServerCallback('Core:job', function(source, cb)
    MySQL.query('SELECT jobs.label, jobs.name FROM jobs', {}, function(results)
        local ResultTable = {}
        for k, v in pairs(results) do
            table.insert(ResultTable, {label = v.label, name = v.name})
        end
        cb(ResultTable)
    end)
end)


--Prefecture
RegisterServerEvent('harybo_permanent:forgetBDD')
AddEventHandler('harybo_permanent:forgetBDD', function (plate)
    MySQL.update(
    'UPDATE owned_vehicles SET state = @state, garage = @garage WHERE plate = @plate',
    {
        ['@state'] = 0,
        ['@garage'] = 0,
        ['@plate'] = plate
    })
end)