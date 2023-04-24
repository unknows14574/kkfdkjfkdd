ESX = nil
HelpInit = ''
local is_currently_used = false

function Ftext_esx_policejob(txt)
	return Config_esx_policejob.Txt[txt]
end

-- Gyrophare sur vehicule civil
local vehicleLights = {}
local currentSoundId = 0
-- Gyrophare sur vehicule civil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config_esx_policejob.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'police', Config_esx_policejob.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})

msg = ""
RegisterCommand('wanted', function(source, args, user)

	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' then
		if IsPlayerAceAllowed(source, "command") then
			for i,v in pairs(args) do
				msg = msg .. " " .. v
      end
      TriggerClientEvent('Core:MessageLifeInvader', -1, 0.588, 0.09, 0.005, 0.0028, 0.8, "~b~POLICE: ~r~AVIS DE RECHERCHE ~d~", 255, 255, 255, 255, 1, 0)
      TriggerClientEvent('Core:MessageLifeInvader', -1, 0.586, 0.150, 0.005, 0.0028, 0.6, table.concat(args, " "), 255, 255, 255, 255, 7, 0)
      TriggerClientEvent('Core:MessageLifeInvader', -1, 0.588, 0.246, 0.005, 0.0028, 0.4, "", 255, 255, 255, 255, 0, 0)
			msg = ""
		end
	else
		TriggerClientEvent('esx:showNotification', source, "Cette commande est réverser a la LSPD.")
	end
end)

RegisterServerEvent('gps:itemadd')
AddEventHandler('gps:itemadd', function(item)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('esx_policejob:giveWeapon')
AddEventHandler('esx_policejob:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_policejob:giveBraceletGps')
AddEventHandler('esx_policejob:giveBraceletGps', function(player)
  local xPlayer = ESX.GetPlayerFromId(player)
  local count = xPlayer.getInventoryItem("braceletgps").count

  if count >= 1 then
    TriggerClientEvent('Core:ShowNotification', source, "Le ~y~citoyen ~w~a déjà un bracelet electronique.")
  else
    TriggerEvent('Nebula_jobs:BraceletAddToArray', xPlayer)
    TriggerClientEvent('Core:ShowNotification', source, "Vous avez ~b~poser ~w~un bracelet electronique au ~y~citoyen~w~.")
    xPlayer.addInventoryItem("braceletgps", 1)
  end
end)

RegisterServerEvent('esx_policejob:removeBraceletGps')
AddEventHandler('esx_policejob:removeBraceletGps', function(player)
  local xPlayer = ESX.GetPlayerFromId(player)
  local count = xPlayer.getInventoryItem("braceletgps").count

  if xPlayer then
    TriggerClientEvent('Core:ShowNotification', source, "Vous avez ~g~retiré ~w~le bracelet electronique du ~y~citoyen~w~.")
    xPlayer.removeInventoryItem("braceletgps", count)
    TriggerEvent('Nebula_jobs:BraceletRemoveFromArray', xPlayer.source)
  end
end)

RegisterServerEvent('esx_policejob:fouiller')
AddEventHandler('esx_policejob:fouiller', function(id)
  local id = id  
  local targetXPlayer = ESX.GetPlayerFromId(id)
  TriggerClientEvent('Core:ShowNotification', targetXPlayer.source, 'Quelqu\'un vous fouille !')
end)

RegisterServerEvent('esx_policejob:confiscatePlayerItem')
AddEventHandler('esx_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label
    local playerItemCount = targetXPlayer.getInventoryItem(itemName).count

    if playerItemCount <= amount then
      targetXPlayer.removeInventoryItem(itemName, amount)
      sourceXPlayer.addInventoryItem(itemName, amount)
    else
      TriggerClientEvent('Core:ShowNotification', _source, "Quantité invalide.")
    end

    if itemName == "radio" then
      TriggerClientEvent('Radio.RemovedItem', targetXPlayer.source)
      TriggerClientEvent('Core:ShowNotification', targetXPlayer.source, "~r~Radio déconnectée.")
    end

    TriggerClientEvent('Core:ShowNotification', sourceXPlayer.source, "Vous avez ~r~confisqué ~y~x".. amount .. " ".. label .. "~w~ au citoyen le plus proche.")
    TriggerClientEvent('Core:ShowNotification', targetXPlayer.source, "Un membre des forces de l'ordre vous a ~r~confisqué ~y~x".. amount .. " ".. label .. "~w~.")
  end

  if itemType == 'item_account' then
    targetXPlayer.removeAccountMoney(itemName, amount)
    sourceXPlayer.addAccountMoney(itemName, amount)

    TriggerClientEvent('Core:ShowNotification', sourceXPlayer.source, "Vous avez ~r~confisqué ~y~".. amount .. "$~w~ au citoyen le plus proche (".. targetXPlayer.name ..").")
    TriggerClientEvent('Core:ShowNotification', targetXPlayer.source, "Un membre des forces de l'ordre vous a ~r~confisqué ~g~".. amount .. "$~w~.")
  end

  if itemType == 'item_weapon' then
    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('Core:ShowNotification', sourceXPlayer.source, "Vous avez ~r~confisqué ~y~un(e) ".. ESX.GetWeaponLabel(itemName) .. "~w~ au citoyen le plus proche.")
    TriggerClientEvent('Core:ShowNotification', targetXPlayer.source, "Un membre des forces de l'ordre vous a ~r~confisqué ~g~un(e) ".. ESX.GetWeaponLabel(itemName) .. "~w~.")
  end

  if itemType == 'item_amount_choose_money' then
    targetXPlayer.removeMoney(amount)
    sourceXPlayer.addMoney(amount)

    TriggerClientEvent('Core:ShowNotification', sourceXPlayer.source, "Vous avez ~r~confisqué ~y~".. amount .. "$~w~ au citoyen le plus proche (".. targetXPlayer.name ..").")
    TriggerClientEvent('Core:ShowNotification', targetXPlayer.source, "Un membre des forces de l'ordre vous a ~r~confisqué ~y~".. amount .."$~w~.")
  end
end)

-- Vérifications d'ID
RegisterServerEvent('esx_policejob:CheckId')
AddEventHandler('esx_policejob:CheckId', function(prenom, nom)
  local _source = source

  if prenom and nom then

    prenom = string.upper(prenom)
    nom = string.upper(nom)

    local result = MySQL.query.await("SELECT * FROM users WHERE UPPER(firstname) = @prenom AND UPPER(lastname) = @nom Limit 1", {
      ['@prenom'] = prenom,
      ['@nom'] = nom,
    })
    if result ~= nil then
      if result[1] then
        if tostring(result[1].isIdChanged) == tostring(1) then
          TriggerClientEvent('Core:ShowNotification', _source, "Cette identité ~r~n'est pas enregistrée~w~ dans le registre des ~y~citoyens~w~.")
          TriggerClientEvent('Core:ShowNotification', _source, "~r~HRP:~w~ Si tu effectues une scène de prise d'empruntes: fait un /report !")
        else
          TriggerClientEvent('Core:ShowNotification', _source, "Cette identité est ~g~confirmée~w~.")
        end
      else
        TriggerClientEvent('Core:ShowNotification', _source, "~r~Erreur:~w~ Merci de vérifier le nom et prénom utilisé et réessayer.")
      end
    end
  else
    TriggerClientEvent('Core:ShowNotification', _source, "Une erreur s'est produite. Merci de réessayer.")
  end
end)

ESX.RegisterCommand('checkname', "admin", function(xPlayer, args, showError)
  local targetId = args.playerId
  local target = ESX.GetPlayerFromId(targetId)
  local _source = xPlayer.source
  local result = MySQL.query.await("SELECT AncienNom, AncienPrenom, isIdChanged FROM users WHERE identifier = @identifier LIMIT 1", {
    ['@identifier'] = target.identifier
  })

  if result[1] then
    if result[1].isIdChanged == 1 then
      TriggerClientEvent('Core:ShowNotification', _source, "La vraie identité de la personne est: ~y~".. result[1].AncienPrenom.." ".. result[1].AncienNom.."~w~.")
    else
      TriggerClientEvent('Core:ShowNotification', _source, "Cette personne n'a pas changé d'identité.")
    end
  else
    TriggerClientEvent('Core:ShowNotification', _source, "Il y a eu un problème lors de la commande checkname. Reessaie.")
  end
end, true, {help = 'Vérifier la vrais identité du joueur', validate = false, arguments = {
  {help = 'Id joueur', name = 'playerId', type = 'any'}
}})

-- Fin identité check

RegisterServerEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(target, heading)
  TriggerClientEvent('esx_policejob:handcuff', target, heading)
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
  local _source = source
  TriggerClientEvent('esx_policejob:drag', target, _source)
end)

RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
  TriggerClientEvent('esx_policejob:putInVehicle', target)
end)

RegisterServerEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
    TriggerClientEvent('esx_policejob:OutVehicle', target)
end)

RegisterServerEvent('esx_policejob:getStockItem')
AddEventHandler('esx_policejob:getStockItem', function(itemName, count, job)
  local xPlayer = ESX.GetPlayerFromId(source)
  
  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..job, function(inventory)

    local item = inventory.getItem(itemName)

		TriggerEvent('esx_advanced_inventory:GetInventoryWeight', function(invTaille, itemTaille) 
			weight = 50000 - invTaille
			  if item.count >= count then
				local getTaille = itemTaille * count
				if getTaille <= weight then
				   inventory.removeItem(itemName, count)
				   xPlayer.addInventoryItem(itemName, count)
           TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Vous avez retirer " .. count .. ' ' .. item.label, 'CHAR_DAVE', 1)
           TriggerEvent('CoreLog:SendDiscordLog', 'LSPD - Coffre', "`[COFFRE] ["..xPlayer.matricule.." | "..xPlayer.firstname.." "..xPlayer.firstname.."]` **"..GetPlayerName(source) .. "** a retiré **`[x"..count.." "..item.label.."]`**",'Red', false, source)
				elseif getTaille >= weight then
				  TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Tu n\'as pas assez de place dans tes poches...", 'CHAR_DAVE', 1)
				end
			  else
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Coffre", "", "Quantité invalide", 'CHAR_DAVE', 1)
			  end
		  end, source, itemName)

  end)

end)

RegisterServerEvent('esx_policejob:putStockItems')
AddEventHandler('esx_policejob:putStockItems', function(itemName, count, job)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemCount = xPlayer.getInventoryItem(itemName).count

	if count <= itemCount then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
			local item = inventory.getItem(itemName)
	
			if item.count >= 0 then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
        TriggerEvent('CoreLog:SendDiscordLog', 'LSPD - Coffre', "`[COFFRE] ["..xPlayer.matricule.." | "..xPlayer.firstname.." "..xPlayer.firstname.."]` **"..GetPlayerName(source) .. "** a deposé **`[x"..count.." "..item.label.."]`**",'Green', false, source)
			else
				TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Quantité invalide. Veuillez ressayer.')
			end
	
			TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Vous avez ajouter ~y~x" .. count .. ' ~b~' .. item.label)
		end)
	else
		TriggerClientEvent('Core:ShowNotification', xPlayer.source, 'Vous n\'avez pas cet objet sur vous.')
	end
end)

ESX.RegisterServerCallback('esx_policejob:GetFactures', function(source, cb, job)
	local bill = {}

	MySQL.query("SELECT * FROM billing WHERE target_type=@target_type",{['@target_type'] = "society_police"}, function(data) 
		for _,v in pairs(data) do
			table.insert(bill, {label = v.label, identifier = v.identifier, amount = v.amount, society = v.target, id = v.id})
		end
		cb(bill)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:GetBilling', function(source, cb, job)
	local bill = {}

	MySQL.query("SELECT * FROM billing WHERE target=@target",{['@target'] = "society_police"}, function(data) 
    for _,v in pairs(data) do
      if v.lastname == nil then
        local result = MySQL.query.await("SELECT * FROM users WHERE identifier = @identifier LIMIT 1", {
          ['@identifier'] = v.identifier
          })
          table.insert(bill, {label = v.label, identifier = v.identifier, amount = v.amount, society = v.target, id = v.id, lastname = result[1].lastname, firstname = result[1].firstname})
      else
        table.insert(bill, {label = v.label, identifier = v.identifier, amount = v.amount, society = v.target, id = v.id, lastname = v.lastname, firstname = v.firstname})
      end
		end
		cb(bill)
	end)
end)

RegisterServerEvent('esx_policejob:delete_bill')
AddEventHandler('esx_policejob:delete_bill', function (id)
	local id = id

	MySQL.query(
	  'SELECT * FROM billing',
	  {},
	  function (result)
		for i=1, #result, 1 do
		  local idZ = result[i].id
  
		  if idZ == id then
			MySQL.update(
			  'DELETE FROM billing WHERE id = @id',
			  { ['@id'] = result[i].id }
			)
		  end
		end
	  end
	)

end)

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData2', function(source, cb)

  local source = source
  if Config_esx_policejob.EnableESXIdentity then

    local xPlayer = ESX.GetPlayerFromId(source)

    local identifier = GetPlayerIdentifiers(source)[1]

    local result = MySQL.query.await("SELECT * FROM users WHERE identifier = @identifier LIMIT 1", {
      ['@identifier'] = identifier
    })

    local user       	= result[1]
    local firstname     = user['firstname']
    local lastname      = user['lastname']
    local sex           = user['sex']
    local dob           = user['dateofbirth']
    local height        = user['height'] .. " Inches"

    local data = {
      name        = GetPlayerName(source),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex         = sex,
      dob         = dob,
      height      = height,
	  money 	  = xPlayer.getMoney()
    }

    TriggerEvent('esx_status:getStatus', source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

    if Config_esx_policejob.EnableLicenses then

      TriggerEvent('esx_license:getLicenses', source, function(licenses)
        data.licenses = licenses
        cb(data)
      end)

    else
      cb(data)
    end

  else

    local xPlayer = ESX.GetPlayerFromId(source)

    local data = {
      name       = GetPlayerName(source),
      job        = xPlayer.job,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout,
	  money 	 = xPlayer.getMoney()
    }

    TriggerEvent('esx_status:getStatus', source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = status.getPercent()
      end

    end)

    TriggerEvent('esx_license:getLicenses', source, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)


ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target)

  if Config_esx_policejob.EnableESXIdentity then

    local xPlayer = ESX.GetPlayerFromId(target)

    local identifier = GetPlayerIdentifiers(target)[1]

    local result = MySQL.query.await("SELECT * FROM users WHERE identifier = @identifier LIMIT 1", {
      ['@identifier'] = identifier
    })

    local user      = result[1]
    local firstname     = user['firstname']
    local lastname      = user['lastname']
    local sex           = user['sex']
    local dob           = user['dateofbirth']
    local height        = user['height'] .. " Inches"

    local data = {
      name        = GetPlayerName(target),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex         = sex,
      dob         = dob,
      height      = height,
	  money 	 = xPlayer.getMoney()
    }

    TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)
    
    TriggerEvent('esx_status:getStatus', target, 'drug', function(status)

      if status ~= nil then
        data.drug = math.floor(status.percent)
      end

    end)

    if Config_esx_policejob.EnableLicenses then

      TriggerEvent('esx_license:getLicenses', target, function(licenses)
        data.licenses = licenses
        cb(data)
      end)

    else
      cb(data)
    end

  else

    local xPlayer = ESX.GetPlayerFromId(target)

    local data = {
      name       = GetPlayerName(target),
      job        = xPlayer.job,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout,
	  money 	 = xPlayer.getMoney()
    }

    TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)

      if status ~= nil then
        data.drunk = status.getPercent()
      end

    end)

    TriggerEvent('esx_license:getLicenses', target, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)

ESX.RegisterServerCallback('esx_policejob:getFineList', function(source, cb, category)

  MySQL.query(
    'SELECT * FROM fine_types WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )
end)

RegisterServerEvent('esx_policejob:giveLicense')
 AddEventHandler('esx_policejob:giveLicense', function (target, licence, label)
   local _source = source
   local xTarget = ESX.GetPlayerFromId(target)
 
     TriggerEvent('esx_license:addLicense', target, licence, function ()
	   TriggerClientEvent('esx:showNotification', _source, "Vous avez donner ~b~" .. label .. "~s~ à " .. xTarget.name)
	   TriggerClientEvent('esx:showNotification', target, "Vous avez recu ~b~" .. label)
     end)
 end)

local function deleteLicense(owner, license)
  MySQL.update("DELETE FROM user_licenses WHERE `owner` = @owner AND `type` = @license", {
      ['@owner'] = owner,
      ['@license'] = license,
  })
end

local function addLicense(owner, license) 
  MySQL.update(
		'INSERT IGNORE INTO user_licenses (type, owner) VALUES (@type, @owner)',
		{
			['@type']  = license,
			['@owner'] = owner
		})
end

RegisterServerEvent('esx_policejob:deletelicense')
AddEventHandler('esx_policejob:deletelicense', function(target, license)
  local text = ""
  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if(license =="weapon")then
    text= "Permis de port d'arme"
  end
  if(license =="dmv")then
    text = "Code de la route"
  end
  if(license =="drive")then
    text= "Permis de conduire"
  end
  if(license =="drive_bike")then
    text= "Permis moto"
  end
  if(license =="drive_truck")then
    text="Permis camion"
  end
  if(license =="chasse")then
    text="Permis de chasse"
  end
  if(license =="peche")then
    text="Permis de peche"
  end
  if(license =="vmedic")then
    text="Visite médicale"
  end
  if(license =="cmedic")then
    text="Certificat médicale"
  end
  if(license =="ppa")then
    text="Licence PPA"
  end

  TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~retiré~w~ : '..text..' de ~b~'..targetXPlayer.name )
  TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~r~' .. sourceXPlayer.name .. ' vous a retiré : '.. text)

  local identifier = GetPlayerIdentifiers(target)[1]
  deleteLicense(targetXPlayer.identifier,license)
end)

RegisterServerEvent('esx_policejob:addlicense')
AddEventHandler('esx_policejob:addlicense', function(target, license)
  local text = ""
  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if(license =="weapon")then
    text= "Permis de port d'arme"
  end
  if(license =="dmv")then
    text = "Code de la route"
  end
  if(license =="drive")then
    text= "Permis de conduire"
  end
  if(license =="drive_bike")then
    text= "Permis moto"
  end
  if(license =="drive_truck")then
    text="Permis camion"
  end
  if(license =="chasse")then
    text="Permis de chasse"
  end
  if(license =="peche")then
    text="Permis de peche"
  end
  if(license =="vmedic")then
    text="Visite médicale"
  end
  if(license =="cmedic")then
    text="Certificat médicale"
  end
  if(license =="ppa")then
    text="Licence PPA"
  end

  TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~restitué~w~ : '..text..' de ~b~'..targetXPlayer.name )
  TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~r~' .. sourceXPlayer.name .. ' vous a restitué : '.. text)

  local identifier = GetPlayerIdentifiers(target)[1]
  addLicense(targetXPlayer.identifier, license)
end)

function ShowPermis(source,identifier)
  local _source = source
  local licenses = MySQL.query.await("SELECT * FROM user_licenses where `owner`= @owner",{['@owner'] = identifier})

    for i=1, #licenses, 1 do
        if(licenses[i].type =="weapon")then
         TriggerClientEvent('esx:showNotification',_source,"Permis de port d'arme")
        end
        if(licenses[i].type =="dmv")then
            TriggerClientEvent('esx:showNotification',_source,"Code de la route")
        end
        if(licenses[i].type =="drive")then
            TriggerClientEvent('esx:showNotification',_source,"Permis de conduire")
        end
        if(licenses[i].type =="drive_bike")then
           TriggerClientEvent('esx:showNotification',_source,"Permis moto")
        end
        if(licenses[i].type =="drive_truck")then
          TriggerClientEvent('esx:showNotification',_source,"Permis camion")
        end
        if(licenses[i].type =="chasse")then
          TriggerClientEvent('esx:showNotification',_source,"Permis de chasse")
        end
        if(licenses[i].type =="peche")then
          TriggerClientEvent('esx:showNotification',_source,"Permis de pêche")
        end
		    if(licenses[i].type =="vmedic")then
          TriggerClientEvent('esx:showNotification',_source,"Visite médicale")
        end
		    if(licenses[i].type =="cmedic")then
          TriggerClientEvent('esx:showNotification',_source,"Certificat médicale")
        end
		    if(licenses[i].type =="ppa")then
          TriggerClientEvent('esx:showNotification',_source,"Licence PPA")
        end
    end
end

RegisterServerEvent('esx_policejob:license_see')
AddEventHandler('esx_policejob:license_see', function(target)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  local identifier = GetPlayerIdentifiers(target)[1]

  TriggerClientEvent('esx:showNotification', sourceXPlayer.source, '~b~'..targetXPlayer.name)
  ShowPermis(source, identifier)
end)

local prenom = {"Finn","Hannah","Carla","Thomas","Sandy","Michael","Marvin","Timothé","Benjamin","Hugo","Arthur","Jeff","Kevin","Juan","Diego","Samuel","John","Josh","Jeanne","Jade","Rose","Rosie","Clara","Ava","Eva","Laura","Julie","Sandrine","Carine","Eric","Emilie","Sam","Samantha","Lea","Leo","Mark","Melissa","Johanna","Cameron","Tiago","Elias","Patricia"}
local nom = {"Smith","Salva","Spencer","Rodriguez","Flores","Johns","White","Black","Silver","Johnson","Harper","Ivanof","Riekao","Labune","Munch","Xinma","Newton","Kepler","Carlos","Rogers","Collins","Pearse","Person","Crooks","Bennette","Diaz","Darwinn","Becker","McCray","Harrington","Clarc","Brown","Walsh","O'Brian","O'Ryan","O'Neil","Miller","Maller","Davis"}
local plateOwners = {}
ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)
		MySQL.query("SELECT * FROM owned_vehicles WHERE plate=@plate LIMIT 1",{['@plate'] = plate}, function(data) 
			if data ~= nil then
          if next(data) == nil then
            local countprenom = 0
            local countnom = 0

            for i=1, #prenom, 1 do
              countprenom = countprenom + 1
            end
            for i=1, #nom, 1 do
              countnom = countnom + 1
            end
            
            local randomprenom = prenom[math.random(1,countprenom)]
            local randomnom = nom[math.random(1,countnom)]

            if plateOwners[plate] == nil then
              plateOwners[plate] = randomprenom .. " " .. randomnom
            end

            local infos = {
              plate = plate,
              owner = plateOwners[plate]
            }
            cb(infos)
          end
        for _,v in pairs(data) do
          if v.plate == plate then
            MySQL.query(
              'SELECT * FROM users WHERE identifier = @identifier LIMIT 1',
              {
                ['@identifier'] = v.owner
              },
              function(result)
      
                local ownerName = result[1].firstname .. " " .. result[1].lastname
      
                local infos = {
                  plate = v.plate,
                  assurance = v.assurance,
                  owner = ownerName,
                  state = tostring(v.state)
                }
                cb(infos)
              end
            )
          end
        end
      end
    end)
end)

RegisterServerEvent('esx_policejob:GetPlate')
AddEventHandler('esx_policejob:GetPlate', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	if plate ~= nil then
		MySQL.query("SELECT * FROM owned_vehicles WHERE plate=@plate LIMIT 1",{['@plate'] = plate}, function(data) 
			if data ~= nil then
        if next(data) == nil then
          local countprenom = 0
          local countnom = 0

          for i=1, #prenom, 1 do
            countprenom = countprenom + 1
          end
          for i=1, #nom, 1 do
            countnom = countnom + 1
          end
          
          local randomprenom = prenom[math.random(1,countprenom)]
          local randomnom = nom[math.random(1,countnom)]

          if plateOwners[plate] == nil then
            plateOwners[plate] = randomprenom .. " " .. randomnom
          end
          TriggerClientEvent('Core:ShowNotification', xPlayer.source, "~s~Immatriculation n°: ~y~".. plate .. "~w~.~n~~s~Assurance: ~r~Non~w~.~n~~s~Volé: ~r~Oui~w~...")
          TriggerClientEvent('Core:ShowNotification', xPlayer.source, "~s~Propriétaire: ~b~".. plateOwners[plate] .."~w~.")
          return
        end
				for _,v in pairs(data) do
					if v.plate == plate then
						MySQL.query("SELECT * FROM users WHERE identifier=@identifier LIMIT 1",{['@identifier'] = v.owner}, function(data2) 
							if data2 ~= nil then
                if next(data2) ~= nil then
                  for _,x in pairs(data2) do
                    if x.name ~= nil then
                      print(v.assurance)
                      TriggerClientEvent('Core:ShowNotification', xPlayer.source, "~s~Immatriculation n°: ~y~".. plate .. "~w~.~n~~s~Assurance: ".. ((v.assurance and "~g~Oui~w~.") or "~r~Non~w~.").."~n~~s~Volé: ".. ((v.state == 2 and "~r~Oui~w~.") or "~g~Non~w~..."))
                      TriggerClientEvent('Core:ShowNotification', xPlayer.source, "~s~Propriétaire: ~b~".. x.firstname .. " ".. x.lastname.."~w~.")
                    end
                  end
                else
                  MySQL.query("SELECT * FROM job_grades WHERE job_name=@jobname AND name = 'boss' LIMIT 1",{['@jobname'] = tostring(v.owner)}, function(data3)
                    if data3 ~= nil then
                      for _,y in pairs(data3) do
                        if tostring(y.name) == "boss" then
                          MySQL.query("SELECT * FROM users WHERE (job=@job AND job_grade=@jobgrade) OR (job2=@job AND job2_grade=@jobgrade) LIMIT 1",{['@job'] = v.owner, ['@jobgrade'] = y.grade}, function(data4)
                            if next(data4) ~= nil then
                              for _,z in pairs(data4) do
                                  TriggerClientEvent('Core:ShowNotification', xPlayer.source, "~s~Immatriculation n°: ~y~".. plate .. "~w~.~n~~s~Assurance: ".. ((v.assurance and "~g~Oui~w~.") or "~r~Non~w~.").."~n~~s~Volé: ".. ((v.state == 2 and "~r~Oui~w~.") or "~g~Non~w~..."))
                                  TriggerClientEvent('Core:ShowNotification', xPlayer.source, "~s~Propriétaire: ~b~".. z.firstname .. " ".. z.lastname.."~w~. (Entreprise ou autre)") 
                              end
                            else
                              MySQL.query("SELECT * FROM jobs WHERE name=@job",{['@job'] = v.owner}, function(data4)
                                for _,z in pairs(data4) do
                                  TriggerClientEvent('Core:ShowNotification', xPlayer.source, "~s~Immatriculation n°: ~y~".. plate .. "~w~.~n~~s~Assurance: ".. ((v.assurance and "~g~Oui~w~.") or "~r~Non~w~.").."~n~~s~Volé: ".. ((v.state == 2 and "~r~Oui~w~.") or "~g~Non~w~..."))
                                  TriggerClientEvent('Core:ShowNotification', xPlayer.source, "~s~Propriétaire: ~b~".. z.label .."~w~. (Entreprise ou autre)")
                                end
                              end)
                            end
                          end)
                        end
                      end
                    end
                  end)
								end
							end
						end)
					end
				end
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_policejob:getArmoryWeapons', function(source, cb, job)
  
  TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_policejob:addArmoryWeapon', function(source, cb, weaponName, job)
  
  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)
  TriggerEvent('CoreLog:SendDiscordLog', 'LSPD - Armurerie', "`[ARMURERIE]` **"..GetPlayerName(source) .. "** a déposé **"..weaponName.."** `["..ESX.GetWeaponLabel(weaponName).."]`",'Green', false, source)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      elseif weapons[i].count <= 0 then
        table.remove(weapons, i)
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)
TriggerClientEvent('esx_add:saveLoadout', source)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_policejob:removeArmoryWeapon', function(source, cb, weaponName, job)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
		if weapons[i] ~= nil then
		  if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
        xPlayer.addWeapon(weaponName, 150)
        TriggerEvent('CoreLog:SendDiscordLog', 'LSPD - Armurerie', "`[ARMURERIE]` **"..GetPlayerName(source) .. "** a retiré **"..weaponName.."** `["..ESX.GetWeaponLabel(weaponName).."]`",'Red', false, source)
		  elseif weapons[i].count <= 0 then
			table.remove(weapons, i)
		  end
		end
    end


    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)
      TriggerClientEvent('esx_add:saveLoadout', source)

     cb()

  end)
end)


ESX.RegisterServerCallback('esx_policejob:buy', function(source, cb, amount, job)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job, function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('esx_policejob:getStockItems', function(source, cb, job)
  

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..job, function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_policejob:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)




function moneychecker(money, need)
	if money <= need then
		return true
	else
		return false
	end

end

ESX.RegisterServerCallback('esx_police:CheckMoney', function (source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)

  local result = MySQL.query.await("SELECT money FROM addon_account_data WHERE account_name = @account_name LIMIT 1", 
	{
        ['@account_name'] = "society_police"
    })
	
    if result[1] ~= nil then
		cb(result[1].money)
	else
		cb(0)
    end
end)

ESX.RegisterServerCallback('esx_police:CheckBlackMoney', function (source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)

  local result = MySQL.query.await("SELECT black_money FROM addon_account_data WHERE account_name = @account_name LIMIT 1", 
	{
        ['@account_name'] = "society_police"
    })
	
    if result[1] ~= nil then
		cb(result[1].black_money)
	else
		cb(0)
    end
end)

RegisterServerEvent('esx_police:putmoney')
AddEventHandler('esx_police:putmoney', function(money, job)
  
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local need = xPlayer.getMoney()

	if moneychecker(tonumber(money), tonumber(need)) == true then
		xPlayer.removeMoney(tonumber(money))
		
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job, function(account)
			account.addMoney(tonumber(money))
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposer $" .. tonumber(money) .. " en propre")
    end)
    TriggerEvent('CoreLog:SendDiscordLog', 'LSPD - Argent', "`[ARGENT PROPRE]` **"..GetPlayerName(_source) .. "** a déposé **`[$"..tonumber(money).."]`**",'Green', false, _source)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas l\'argent')
	end
	CancelEvent()
end)

RegisterServerEvent('esx_police:getmoney')
AddEventHandler('esx_police:getmoney', function(money, job)
  
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job, function(account)
	
		local need = account.money
	
		if moneychecker(tonumber(money), tonumber(need)) == true then
			account.removeMoney(tonumber(money))
			
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
				xPlayer.addMoney(tonumber(money))
      end)
      TriggerEvent('CoreLog:SendDiscordLog', 'LSPD - Argent', "`[ARGENT PROPRE]` **"..GetPlayerName(_source) .. "** a retiré **`[$"..tonumber(money).."]`**",'Red', false, _source)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retirer $" .. tonumber(money) .. " en propre")
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Il n\'y a pas assez d\'argent')
		end
	end)

end)

RegisterServerEvent('esx_police:putblackmoney')
AddEventHandler('esx_police:putblackmoney', function(_money, _blackmoney, job)
  
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local money = _money
	local blackmoney = _blackmoney
	
	local need = xPlayer.getBlackMoney()
	
	if moneychecker(tonumber(money), tonumber(need)) == true then

		local final = (tonumber(blackmoney) + tonumber(money))
	
		MySQL.update('UPDATE addon_account_data SET black_money = @black_money WHERE account_name = @account_name',
		{
			['@account_name'] = "society_"..job,
			['@black_money']   = tonumber(final)
		})
		
    xPlayer.removeAccountMoney('black_money', tonumber(money))
    TriggerEvent('CoreLog:SendDiscordLog', 'LSPD - Argent', "`[ARGENT MARQUE]` **"..GetPlayerName(_source) .. "** a déposé **`[$"..tonumber(money).."]`**",'Green', false, _source)
		
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposer $" .. tonumber(money) .. " en sale")
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas l\'argent')
	end
end)

RegisterServerEvent('esx_police:getblackmoney')
AddEventHandler('esx_police:getblackmoney', function(_money, _blackmoney, job)
  
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local money = _money
	local blackmoney = _blackmoney
	
	if moneychecker(tonumber(money), tonumber(blackmoney)) == true then
	
	local final = (tonumber(blackmoney) - tonumber(money))

		MySQL.update('UPDATE addon_account_data SET black_money = @black_money WHERE account_name = @account_name',
		{
			['@account_name'] = "society_"..job,
			['@black_money']   = tonumber(final)
		})
		
		xPlayer.addAccountMoney('black_money', tonumber(money))
    TriggerEvent('CoreLog:SendDiscordLog', 'LSPD - Argent', "`[ARGENT MARQUE]` **"..GetPlayerName(_source) .. "** a retiré **`[$"..tonumber(money).."]`**",'Red', false, _source)

		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retirer $" .. tonumber(money) .. " en sale")
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Il n\'y a pas assez d\'argent')
	end


end)

-- Gyrophare sur voiture civile 
RegisterNetEvent('copsrp_gyrophare:triggerSound')
AddEventHandler('copsrp_gyrophare:triggerSound', function(soundName, vehicle)
	if vehicleLights[vehicle] == nil then
		vehicleLights[vehicle] = currentSoundId
		currentSoundId = currentSoundId + 1
	end

	TriggerClientEvent('copsrp_gyrophare:triggerSound', -1, soundName, vehicle, vehicleLights[vehicle])
end)

RegisterNetEvent('copsrp_gyrophare:stopSound')
AddEventHandler('copsrp_gyrophare:stopSound', function(vehicle)
	TriggerClientEvent('copsrp_gyrophare:stopSound', -1, vehicleLights[vehicle], vehicle)
end)

RegisterNetEvent('xNeb_jobs:setarmureriePeds')
AddEventHandler('xNeb_jobs:setarmureriePeds', function(bool)
	is_currently_used = bool
end)

ESX.RegisterServerCallback('xNeb_jobs:armureriePeds', function (source, cb)
  cb(is_currently_used)
end)
-- Gyrophare sur voiture civile 

RegisterServerEvent('esx_policejob:AttributeMatricule')
AddEventHandler('esx_policejob:AttributeMatricule', function(target, matricule)
  local xPlayer = ESX.GetPlayerFromId(target)
  if xPlayer and matricule then
    MySQL.update.await("UPDATE users SET matricule=@matricule WHERE identifier=@id",{
      ['@matricule'] = matricule,
      ['@id'] = xPlayer.identifier
    })

    TriggerClientEvent('Core:ShowNotification', xPlayer.source, "Le matricule ~y~"..matricule.."~w~ vous a été attribué.")
  end
end)

local armoryStorageOpenOneTime = false

-- PREVENT INVENTORY NOT OPEN AN WEAPON CAN't BE PLACE IN
ESX.RegisterServerCallback('esx_policejob:checkIfArmoryStorageOpenOneTime', function(source, cb, inventoryName)
  if not armoryStorageOpenOneTime then
    armoryStorageOpenOneTime = true
    cb(false)
  else
    cb(true)
  end
end)