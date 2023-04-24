

function GenerateUniquePhoneNumber()
    local running = true
    local phone = nil
    while running do
        local rand = 555 .. "-" .. math.random(1111, 9999)
		local count = MySQL.query.await("SELECT 1 FROM sim WHERE phone_number = @phone_number", { ['@phone_number'] = rand })
        if #count == nil or #count < 1 then
            phone = rand
            running = false
        end
    end
    return phone
end

function rNum(source)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
  
	local result = MySQL.query.await("SELECT users.phone FROM users WHERE users.identifier = @identifier", {
		['@identifier'] = xPlayer.identifier
	})

	if result[1] ~= nil then
		if result[1].phone ~= nil then
			return result[1].phone
		else
			return nil
		end
	else
		return nil
	end
end

AddEventHandler('esx:playerLoaded',function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local num = rNum(_source)

	if num ~= nil and num ~= 0 and num ~= "0" then
		local phoneNumber = rNum(_source)
		
		local count = MySQL.query.await("SELECT 1 FROM sim WHERE phone_number = @phone_number", { ['@phone_number'] = phoneNumber })
		if (#count == nil or #count < 1) and phoneNumber ~= nil then
			MySQL.update(
				'INSERT INTO sim (phone_number, identifier) VALUES (@phone_number, @identifier)',
				{
					['@phone_number']   = phoneNumber,
					['@identifier']   = xPlayer.identifier,
				},
				function (rowsChanged)

				end
			)
		end
	else
		MySQL.query(
			'SELECT * FROM users WHERE identifier = @identifier',
			{
				['@identifier'] = xPlayer.identifier
			},
			function(result)
			
			if result[1].phone ~= nil then
				local count = MySQL.query.await("SELECT 1 FROM sim WHERE phone_number = @phone_number", { ['@phone_number'] = result[1].phone })
				if (#count == nil or #count < 1) then
					MySQL.update(
						'INSERT INTO sim (phone_number, identifier) VALUES (@phone_number, @identifier)',
						{
							['@phone_number']   = result[1].phone,
							['@identifier']   = xPlayer.identifier,
						},
						function (rowsChanged)

						end
					)
				end
			end
		end)
	end
	
end)

RegisterServerEvent('esx_prefecture:SaveSim')
AddEventHandler('esx_prefecture:SaveSim', function (number)
	if number ~= nil then
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)

		xPlayer.removeInventoryItem('sim', 1)

		MySQL.update(
		'INSERT INTO sim (phone_number, identifier) VALUES (@phone_number, @identifier)',
		{
			['@phone_number']   = number,
			['@identifier']   = xPlayer.identifier,
		},
		function (rowsChanged)
			TriggerClientEvent('Core:ShowNotification', _source, "Vous avez une nouvelle carte sim. Numéro: ~b~"..number)
		end)
	else
		TriggerClientEvent('Core:ShowNotification', _source, "~r~Une erreur s'est produite. Contactez le support. (SIM SaveSim Error)")
	end
end)

RegisterServerEvent('esx_prefecture:SavePlate')
AddEventHandler('esx_prefecture:SavePlate', function (oldPlate, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('custom_plaque', 1)

	MySQL.query(
	'SELECT * FROM owned_vehicles WHERE plate = @plate',
	{
		['@plate'] = oldPlate
	},
	function(result)
		if #result >= 1 then
			MySQL.update(
			'UPDATE owned_vehicles SET plate = @plate WHERE plate = @old_plate',
			{
				['@plate'] = plate,
				['@old_plate'] = oldPlate
			})
		end
	end)
end)

RegisterServerCallback('esx_prefecture:NumExist', function(source, cb, rand)
	local count = MySQL.query.await("SELECT 1 FROM sim WHERE phone_number = @phone_number", { ['@phone_number'] = rand })
	if #count == nil or #count < 1 then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerCallback('esx_prefecture:PlateExist', function(source, cb, plate)
	local newdata = MySQL.query.await("SELECT 1 FROM owned_vehicles WHERE plate=@plate",{['@plate'] = plate})	
	
	local newdata2 = MySQL.query.await("SELECT 1 FROM stolen_vehicles WHERE plate=@plate",{['@plate'] = plate})
		
	if #newdata >= 1 or #newdata2 >= 1 then
		cb(false)
	else
		cb(true)
	end
end)

local function CheckHowMuchSim(identifier)
	local count = MySQL.query.await("SELECT * FROM sim WHERE identifier = @identifier and isDelete = false", { ['@identifier'] = identifier })

	if #count > 6 then
		return false
	else
		return true
	end
end

function NewSim(source)
	local source = source
	
	local xPlayer = ESX.GetPlayerFromId(source)
	if CheckHowMuchSim(xPlayer.identifier) then
		xPlayer.removeInventoryItem('sim', 1)

		local phoneNumber = GenerateUniquePhoneNumber()

		if phoneNumber == nil then
			phoneNumber = GenerateUniquePhoneNumber()
		end
		
		if phoneNumber ~= nil then
			MySQL.update(
			'INSERT INTO sim (phone_number, identifier) VALUES (@phone_number, @identifier)',
			{
				['@phone_number']   = phoneNumber,
				['@identifier']   = xPlayer.identifier,
			},
			function (rowsChanged)
				TriggerClientEvent('Core:ShowNotification', source, "Vous avez une nouvelle carte sim [~b~"..phoneNumber.."~w~].")
			end)
		else
			print("SIM ERROR NEWSIM(source). PHONENUMBER WAS NIL FOR "..xPlayer.identifier)
		end
	else
		TriggerClientEvent('Core:ShowNotification', source, "~r~Vous avez déjà trop de carte sim. Supprime-en pour pouvoir en réutiliser.")
	end
end

ESX.RegisterUsableItem('sim', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if DiscordIsRolePresent(_source, {"📱 Contributeur #13", "📱 Contributeur #12", "📱 Contributeur #11", "📱 Contributeur #10", "📱 Contributeur #9", "📱 Contributeur #8", "📱 Contributeur #7", "📱 Contributeur #6", "📱 Contributeur #5", "📱 Contributeur #4", "📱 Contributeur #3"}) then
		TriggerClientEvent('esx_prefecture:CreateSimContrib', _source)
	else
		NewSim(_source)
	end
end)

ESX.RegisterServerCallback('esx_prefecture:CheckSim', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local cartesim = rNum(_source)

	if cartesim == 0 then
		cb(false)
	else
		cb(true)
	end
end)

--donner la carte sim a un autre joueur
RegisterServerEvent('esx_prefecture:sim_give')
AddEventHandler('esx_prefecture:sim_give', function (store, index)
  local _source = source
  local id = index
  local xPlayer = ESX.GetPlayerFromId(_source)
  local xPlayer2 = ESX.GetPlayerFromId(id)
  local simZ = store
  local cartesim = nil
  
  TriggerClientEvent('Core:ShowNotification', _source, "Vous avez donné la carte sim ~o~" .. simZ)
  TriggerClientEvent('Core:ShowNotification', id, "Vous avez recu la carte sim ~o~" .. simZ)
			
	if simZ ~= nil then

		local num = rNum(_source)

		if num ~= nil then
			if num == simZ then
				MySQL.update(
					'UPDATE `users` SET phone = @phone_number WHERE `identifier` = @identifier',
					{
						['@identifier']   = xPlayer.identifier,
						['@phone_number'] = 0
					}
				)
			end
		end

		MySQL.update(
			'UPDATE sim SET identifier = @identifier WHERE phone_number = @phone_number',
			{
				['@identifier'] = xPlayer2.identifier,
				['@phone_number'] = simZ
			}
		)
    end

	TriggerClientEvent("high_phone:updateData", _source)
end)

RegisterServerEvent('esx_prefecture:get_sim')
AddEventHandler('esx_prefecture:get_sim', function (target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	local identifier = GetPlayerIdentifier(target)

	local phone_number = MySQL.query.await("SELECT users.phone FROM users WHERE identifier = @identifier", {
      ['@identifier'] = identifier
    })
  
	if phone_number[1] ~= nil then

		if phone_number[1].phone ~= nil then
		
			MySQL.update(
				'INSERT INTO sim (phone_number, identifier) VALUES (@phone_number, @identifier)',
				{
					['@phone_number'] = phone_number[1].phone_number,
					['@identifier'] = xPlayer.identifier
				}
			)
			
			TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez dump la carte sim ~o~" .. phone_number[1].phone_number)
		end
	end
end)

RegisterServerEvent("esx_prefecture:rename")
AddEventHandler("esx_prefecture:rename", function(sim, name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local phone_number = sim
	local name = name
	local identifier = xPlayer.identifier
	
	if phone_number ~= nil then
		MySQL.update(
			'UPDATE `sim` SET name = @name WHERE `phone_number` = @phone_number',
			{
				['@phone_number'] = phone_number,
				['@name'] = name
			}
		)
	end
	
end)

--supprimer la carte sim
RegisterServerEvent('esx_prefecture:sim_delete')
AddEventHandler('esx_prefecture:sim_delete', function (sim)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sim = sim

	local num = rNum(source)

	if num ~= nil then
		if num == sim then
			MySQL.update(
				'UPDATE `users` SET phone = @phone_number WHERE `identifier` = @identifier',
				{
					['@identifier']   = xPlayer.identifier,
					['@phone_number'] = 0
				}
			)
		end
	end

	MySQL.query(
	  'SELECT * FROM sim',
	  {},
	  function (result)
		for i=1, #result, 1 do
		  local simZ = result[i].phone_number
  
		  if simZ == sim then
			MySQL.update(
				'UPDATE sim set isDelete = true WHERE phone_number = @phone_number',
				{
					['@phone_number'] = result[i].phone_number
				})
		  end
		end
	  end
	)

end)

--changer de carte sim (need change identifier inside phone_users_contacts)
RegisterServerEvent('esx_prefecture:sim_use')
AddEventHandler('esx_prefecture:sim_use', function (sim)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local new = sim

	MySQL.update(
		'UPDATE users SET phone = @phone_number WHERE identifier = @identifier',
		{
			['@identifier'] = xPlayer.getIdentifier(),
			['@phone_number'] = new
		}
	)
	TriggerClientEvent("high_phone:updateData", _source)
end)

--Recupere les cartes sim
RegisterServerCallback('esx_prefecture:GetList', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local cartesim = {}

	MySQL.query("SELECT sim.phone_number, sim.name FROM sim WHERE identifier=@identifier and isDelete = false",{['@identifier'] = xPlayer.getIdentifier()}, function(data) 
		for _,v in pairs(data) do
			table.insert(cartesim, {number = v.phone_number, name = v.name})
		end
		cb(cartesim)
	end)
end)

local simAlreadyCheck = { }

RegisterServerCallback('esx_prefecture:StealSimData', function(source, cb, phoneNumber)
	local xPlayer = ESX.GetPlayerFromId(source)

	local sim = { 
		messages = nil,
		calls = nil,
		contacts = nil
	}
	-- if data already retrive from database, return data  
	if simAlreadyCheck[phoneNumber] ~= nil then
		cb(true, simAlreadyCheck[phoneNumber])
	else
		MySQL.query("SELECT identifier FROM users WHERE phone = @phoneNumber LIMIT 1"  ,{['@phoneNumber'] = phoneNumber}, function(data) 
			if data ~= nil and #data > 0 then			
				local ownerIdentifier = data[1].identifier
				if ownerIdentifier then
					MySQL.query("SELECT `from`, `to`, `message`, `attachments`, time FROM phone_messages WHERE `from` = @phoneNumber OR `to` = @phoneNumber order by time desc"  ,{['@phoneNumber'] = phoneNumber}, function(data) 
						if data ~= nil and #data > 0 then
							sim.messages = { }
							for _, value in ipairs(data) do
								-- Convert timespan to date
								value.time = os.date('%d/%m/%Y %H:%M:%S', tostring(value.time):sub(1,10))
			
								-- string > 364 can be display in description in rageui menu
								if value.message:len() >= 365 then
									value.message = tostring(value.message):sub(1,360) .. '[...]'
								end

								local attachment = json.decode(value.attachments)
								if attachment ~= nil and #attachment > 0 then
									local img = attachment[1].image
									if img ~= nil and string.len(img) then
										value.image = img
									else
										value.image = nil
									end
								end
			
								if value.from == phoneNumber then
									if sim.messages[value.to] == nil then
										sim.messages[value.to] = { }
									end
									table.insert(sim.messages[value.to], #sim.messages[value.to] + 1, value)							
								else
									if sim.messages[value.from] == nil then
										sim.messages[value.from] = { }
									end
									table.insert(sim.messages[value.from], #sim.messages[value.from] + 1, value)
								end
							end
						end
			
						MySQL.query("SELECT calls from users where identifier = @identifier LIMIT 1" ,{['@identifier'] = ownerIdentifier}, function(data) 
							if (data ~= nil and #data > 0) then
								local callsDecode = json.decode(data[1].calls) 
								if callsDecode then
									for _, v in pairs(callsDecode) do
										-- Convert timespan to date
										v.time = os.date('%d/%m/%Y %H:%M:%S', tostring(v.time):sub(1,10))
										v = { from = v.from, to = v.to, length = v.length, time = v.time, contactName = nil, incomming = (v.to == phoneNumber)}
									end
									table.sort(callsDecode, function(x, y) return x.time > y.time end)
									sim.calls = callsDecode									
								end
							end
			
							MySQL.query("SELECT number, name from phone_contacts where owner = @identifier order by name" ,{['@identifier'] = ownerIdentifier}, function(data) 
								if (data ~= nil and #data > 0) then
									sim.contacts = { }
									table.sort(data, function(x, y) return string.lower(x.name) < string.lower(y.name) end)
									for _, value in pairs(data) do
										sim.contacts[value.number] = { number = value.number, name = value.name}
									end
									if (sim.contacts ~= nil or sim.messages ~= nil or sim.calls ~= nil) then
										simAlreadyCheck[phoneNumber] = sim
										cb(true, sim)
									else
										cb(false, nil)
									end
								end
							end)
						end)
					end)
				else
					cb(false, nil)
				end
			end
		end)
	end		
end)

ESX.RegisterServerCallback('Core:moderation:GetPlayerData', function (source, cb, targetId)
	local _source = source
	local targetPlayerId = targetId
	local xTarget = ESX.GetPlayerFromId(targetPlayerId)

	cb({ firstname = xTarget.firstname, lastname = xTarget.lastname, name = xTarget.name, coord = vector3( xTarget.getCoords().x, xTarget.getCoords().y, xTarget.getCoords().z), pedId = GetPlayerPed(targetId), modoPedId = GetPlayerPed(_source)})
end)
