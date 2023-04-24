local Inventory

if Config.OxInventory then
	AddEventHandler('ox_inventory:loadInventory', function(module)
		Inventory = module
	end)
end

function CreateExtendedPlayer(playerId, identifier, license, group, accounts, usages, inventory, weight, job, job2, loadout, name, firstname, lastname, coords, matricule)
	local self = {}
	self.accounts = accounts
	self.coords = coords
	self.group = group
	self.identifier = identifier
	self.license = license
	self.usages = usages
	self.inventory = inventory
	self.job = job
	self.job2 = job2
	self.loadout = loadout
	self.name = name
	self.firstname = firstname
	self.lastname = lastname
	self.matricule = matricule
	self.playerId = playerId
	self.source = playerId
	self.variables = {}
	self.weight = weight
	self.maxWeight = Config.MaxWeight
	if Config.Multichar then 
		self.license = 'license'.. identifier:sub(identifier:find(':'), identifier:len()) 
	else 
		self.license = 'license:'..identifier 
	end

	ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.identifier, self.group))

	function self.triggerEvent(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	function self.setCoords(coords)
		self.updateCoords(coords)
		self.triggerEvent('esx:teleport', coords)
	end

	function self.updateCoords(coords)
		self.coords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1), heading = ESX.Math.Round(coords.heading or 0.0, 1)}
	end

	function self.getCoords(vector)
		if vector then
			return vector3(self.coords.x, self.coords.y, self.coords.z)
		else
			return self.coords
		end
	end

	function self.kick(reason)
		DropPlayer(self.source, reason)
	end

	function self.setMoney(money)
		money = ESX.Math.Round(money)
		if money >= 0 then self.setAccountMoney('money', money)	end
	end

	function self.getBlackMoney()
		local money = self.getInventoryItem('dirty')
		-- SCN : Money and Black money as item in core_inventory
		if money then
			if self.getAccount('black_money').money ~= money.count then
				self.setAccountMoney('black_money', money.count)
			end
		end
		-- END SCN
		return self.getAccount('black_money').money
	end

	function self.getMoney()
		local money = self.getInventoryItem('cash')
		-- SCN : Money and Black money as item in core_inventory
		if money then
			if self.getAccount('money').money ~= money.count then
				self.setAccountMoney('money', money.count)
			end
		end
		-- END SCN
		return self.getAccount('money').money
	end

	function self.addMoney(money, type, usage)
		money = ESX.Math.Round(money)
		if money >= 0 then self.addAccountMoney('money', money, type, usage) end
	end

	function self.removeMoney(money, type, usage)
		money = ESX.Math.Round(money)
		if money >= 0 then self.removeAccountMoney('money', money, type, usage) end
	end

	function self.getIdentifier()
		return self.identifier
	end

	function self.getLicense()
		return self.license
	end

	function self.setGroup(newGroup)
		ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.identifier, self.group))
		self.group = newGroup
		ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.identifier, self.group))
		self.setCanAccess()
	end

	function self.getGroup()
		return self.group
	end

	function self.set(k, v)
		self.variables[k] = v
	end

	function self.get(k)
		return self.variables[k]
	end

	function self.getAccounts(minimal)
		if minimal then
			local minimalAccounts = {}

			for k,v in ipairs(self.accounts) do
				minimalAccounts[v.name] = v.money
			end

			return minimalAccounts
		else
			return self.accounts
		end
	end

	function self.getAccount(account)
		for k,v in ipairs(self.accounts) do
			if v.name == account then
				return v
			end
		end
	end

	function self.getBank()
		return self.getAccount('bank').money
	end

	function self.removeBank(amount, type, usage)
		return self.removeAccountMoney('bank', amount, type, usage)
	end

	function self.getInventory(minimal, inventory)
		-- if minimal then
		-- 	local minimalInventory = {}

		-- 	if not Inventory then
		-- 		for k, v in ipairs(self.inventory) do
		-- 			if v.count > 0 then
		-- 				minimalInventory[v.name] = v.count
		-- 			end
		-- 		end
		-- 	else
		-- 		for k, v in pairs(self.inventory) do
		-- 			if v.count and v.count > 0 then
		-- 				local metadata = v.metadata

		-- 				if v.metadata and next(v.metadata) == nil then
		-- 					metadata = nil
		-- 				end

		-- 				minimalInventory[#minimalInventory+1] = {
		-- 					name = v.name,
		-- 					count = v.count,
		-- 					slot = k,
		-- 					metadata = metadata
		-- 				}
		-- 			end
		-- 		end
		-- 	end

		-- 	return minimalInventory
		-- end

		-- return self.inventory
		inventory = inventory or 'content-' ..  self.identifier:gsub(":", "")
        return exports['core_inventory']:getInventory(inventory)
	end

	function self.getUsages()
		return self.usages
	end

	function self.getUsage(a)
		for i=1, #self.usages, 1 do
			if self.usages[i].id == a then
				return self.usages[i]
			end
		end
	end

	function self.setUsageValue(a, value)
		for i=1, #self.usages, 1 do
			if self.usages[i].id == a then
				self.usages[i].value = value
			end
		end
	end

	function self.addUsage(id, type, name, label, value)
		local usage = {
			["id"] = id,
			["type"] = type, 
			["name"] = name, 
			["label"] = label, 
			["value"] = value
		}

		table.insert(self.usages, usage)
		
		TriggerEvent('esx:onAddInventoryUsage', self.source, usage)
		TriggerClientEvent('esx:addInventoryUsage', self.source, usage)
	end

	function self.createNewUsage(type, name, label, value)
		newUsage = {
			["type"] = type, 
			["name"] = name, 
			["label"] = label, 
			["value"] = value
		}

		MySQL.insert('INSERT INTO `users_usages` (type, name, label, value) VALUES (@type, @name, @label, @value)', {
			['@type'] 	= type,
			['@name']   = name,
			['@label']  = label,
			['@value']  = json.encode(value)
		}, function(insertId)
			newUsage.id = insertId

			table.insert(self.usages, newUsage)
			-- No need to save it again
			table.insert(ESX.LastPlayerData[self.source].usages, newUsage)
			
			TriggerEvent('esx:onAddInventoryUsage', self.source, newUsage)
			TriggerClientEvent('esx:addInventoryUsage', self.source, newUsage)
		end)
	end

	function self.removeUsage(a)
		local usage = nil

		for i=1, #self.usages, 1 do
			if self.usages[i].id == a then
				usage = self.usages[i]
				table.remove(self.usages, i)
				break
			end
		end

		for i=1, #ESX.LastPlayerData[self.source].usages, 1 do
			if ESX.LastPlayerData[self.source].usages[i].id == a then
				table.remove(ESX.LastPlayerData[self.source].usages, i)
				break
			end
		end

		MySQL.insert('DELETE FROM `users_usages` WHERE id = @id', {
			['@id'] = a,
		}, function(r) end)
		
		TriggerEvent('esx:onRemoveInventoryUsage', self.source, usage)
		TriggerClientEvent('esx:removeInventoryUsage', self.source, usage)
	end

	function self.getJob()
		return self.job
	end

	function self.getJob2()
		return self.job2
	end

	function self.getLoadout(minimal)
		if Inventory then return {} end
		if minimal then
			local minimalLoadout = {}

			for k,v in ipairs(self.loadout) do
				minimalLoadout[v.name] = {ammo = v.ammo}
				if v.tintIndex > 0 then minimalLoadout[v.name].tintIndex = v.tintIndex end

				if #v.components > 0 then
					local components = {}

					for k2,component in ipairs(v.components) do
						if component ~= 'clip_default' then
							components[#components + 1] = component
						end
					end

					if #components > 0 then
						minimalLoadout[v.name].components = components
					end
				end
			end

			return minimalLoadout
		else
			return self.loadout
		end
	end

	function self.getName()
		return self.name
	end

	function self.getfirstname()
		return self.firstname
	end

	function self.getlastname()
		return self.lastname
	end
	
	function self.getmatricule()
		return self.matricule
	end

	function self.setName(newName)
		self.name = newName
	end

	function self.setAccountMoney(accountName, money)
		if money >= 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = ESX.Math.Round(money)
								
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)

				if Inventory and Inventory.accounts[accountName] then
					Inventory.SetItem(self.source, accountName, money)
				end
			end
		end
	end

	function self.addAccountMoney(accountName, money, type, usage)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money + ESX.Math.Round(money)
				account.money = newMoney

				if account == 'bank' then
					self.set('bank', newMoney)
					if not type then
						type = "Inconnu"
					end
					if not usage then
						usage = 'unknown'
					end
					MySQL.insert("INSERT INTO `transactions` (from_identifier, from_last_name, from_first_name, to_identifier, to_last_name, to_first_name, reason, amount, `at`, `usage`) SELECT 'unknown', 'unknown', 'unknown', @JOUEUR_STEAMID, users.lastname, users.firstname, @type, @MONTANT, NOW(), @usage FROM `users` WHERE users.identifier = @JOUEUR_STEAMID", {
						['@JOUEUR_STEAMID'] = self.getIdentifier(),
						['@type'] = type,
						['@MONTANT'] = ESX.Math.Round(money),
						['@usage'] = usage
					})
				end
				-- SCN : Money and Blakc money as item in core_inventory
				if accountName == 'money' then
                    self.addInventoryItem('cash', ESX.Math.Round(money))
                end
                if accountName == 'black_money' then
                    self.addInventoryItem('dirty', ESX.Math.Round(money))
                end

				-- END SCN

				self.triggerEvent('esx:setAccountMoney', account)

				if Inventory and Inventory.accounts[accountName] then
					Inventory.AddItem(self.source, accountName, money)
				end
			end
		end
	end

	function self.removeAccountMoney(accountName, money, type, usage)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money - ESX.Math.Round(money)
				account.money = newMoney

				if account == 'bank' then
					self.set('bank', newMoney)
					if not type then
						type = "Inconnu"
					end
					if not usage then
						usage = 'unknown'
					end
					MySQL.insert("INSERT INTO `transactions` (from_identifier, from_last_name, from_first_name, to_identifier, to_last_name, to_first_name, reason, amount, `at`, `usage`) SELECT @JOUEUR_STEAMID, users.lastname, users.firstname, 'unknown', 'unknown', 'unknown', @type, @MONTANT, NOW(), @usage FROM `users` WHERE users.identifier = @JOUEUR_STEAMID", {
						['@JOUEUR_STEAMID'] = self.getIdentifier(),
						['@type'] = type,
						['@MONTANT'] = ESX.Math.Round(money),
						['@usage'] = usage
					})
				end
				-- SCN : Money and Blakc money as item in core_inventory
				if accountName == 'money' then
                    self.removeInventoryItem('cash', ESX.Math.Round(money))
                end
                if accountName == 'black_money' then
                    self.removeInventoryItem('dirty', ESX.Math.Round(money))
                end
				-- END SCN

				self.triggerEvent('esx:setAccountMoney', account)

				if Inventory and Inventory.accounts[accountName] then
					Inventory.RemoveItem(self.source, accountName, money)
				end
			end
		end
	end

	function self.getInventoryItem(name, inventory)
		inventory = inventory or 'content-' ..  self.identifier:gsub(":", "")
		return exports['core_inventory']:getItem(inventory, name)
		-- if Inventory then
		-- 	return Inventory.GetItem(self.source, name, metadata)
		-- end

		-- for k,v in ipairs(self.inventory) do
		-- 	if v.name == name then
		-- 		return v
		-- 	end
		-- end
	end

	function self.addInventoryItem(name, count, metadata, inventory)
		inventory = inventory or 'content-' ..  self.identifier:gsub(":", "")
		local canCarry = self.canCarryItem(name, count, inventory)
		while canCarry == nil do
			Wait(50)
		end
		local itemName = ESX.GetItemLabel(name)
		if canCarry  then
			TriggerClientEvent('Core:ShowNotification', self.source, 'Vous avez reçus ~y~x' .. count .. ' '.. (itemName or name))
			return exports['core_inventory']:addItem(inventory, name, count, metadata)
		else
			TriggerClientEvent('Core:ShowNotification', self.source, 'Vous n\'avez pas assez de place pour ~y~x'.. count .. ' ' .. (itemName or name))
			return
		end
		-- if Inventory then
		-- 	return Inventory.AddItem(self.source, name, count or 1, metadata, slot)
		-- end

		-- local item = self.getInventoryItem(name)

		-- if item then
		-- 	count = ESX.Math.Round(count)
		-- 	item.count = item.count + count
		-- 	self.weight = self.weight + (item.weight * count)

		-- 	TriggerEvent('esx:onAddInventoryItem', self.source, item.name, item.count)
		-- 	self.triggerEvent('esx:addInventoryItem', item.name, item.count)
		-- end
	end

	function self.removeInventoryItem(name, count, inventory)
		-- if Inventory then
		-- 	return Inventory.RemoveItem(self.source, name, count or 1, metadata, slot)
		-- end

		-- local item = self.getInventoryItem(name)

		-- if item then
		-- 	count = ESX.Math.Round(count)
		-- 	local newCount = item.count - count

		-- 	if newCount >= 0 then
		-- 		item.count = newCount
		-- 		self.weight = self.weight - (item.weight * count)

		-- 		TriggerEvent('esx:onRemoveInventoryItem', self.source, item.name, item.count)
		-- 		self.triggerEvent('esx:removeInventoryItem', item.name, item.count)
		-- 	end
		-- end
		inventory = inventory or 'content-' ..  self.identifier:gsub(":", "")
		return exports['core_inventory']:removeItem(inventory, name, count)
	end

	function self.setInventoryItem(name, count, metadata)
		if Inventory then
			return Inventory.SetItem(self.source, name, count, metadata)
		end

		local item = self.getInventoryItem(name)

		if item and count >= 0 then
			count = ESX.Math.Round(count)

			if count > item.count then
				self.addInventoryItem(item.name, count - item.count)
			else
				self.removeInventoryItem(item.name, item.count - count)
			end
		end
	end

	function self.getWeight()
		return self.weight
	end

	function self.getMaxWeight()
		return self.maxWeight
	end

	function self.canCarryItem(name, count, inventory)
		inventory = inventory or 'content-' ..  self.identifier:gsub(":", "")
		local itemCountStack =  exports['core_inventory']:RetrieveStackNumberForItemCount(name, count)
		while itemCountStack == nil do
			Wait(50)
		end

		if itemCountStack > 0 then
			local canCarry = exports['core_inventory']:canCarry(inventory, name, itemCountStack)
			if canCarry  then
				return true
			else
				TriggerEvent('Core:ShowNotification', 'Vous n\'avez pas assez de place pour ~y~x'.. count .. ' ' .. ESX.GetItemLabel(name))
				return false
			end
		else
			if not exports['core_inventory']:canCarry(inventory, name, count) then
				TriggerEvent('Core:ShowNotification', 'Vous n\'avez pas assez de place pour ~y~x'.. count .. ' ' .. ESX.GetItemLabel(name))
				return false
			else
				return true
			end
		end

		
		-- if Inventory then
		-- 	return Inventory.CanCarryItem(self.source, name, count, metadata)
		-- end

		-- local currentWeight, itemWeight = self.weight, ESX.Items[name].weight
		-- local newWeight = currentWeight + (itemWeight * count)

		-- return newWeight <= self.maxWeight
	end

	function self.canSwapItem(firstItem, firstItemCount, testItem, testItemCount)
		if Inventory then
			return Inventory.CanSwapItem(self.source, firstItem, firstItemCount, testItem, testItemCount)
		end

		local firstItemObject = self.getInventoryItem(firstItem)
		local testItemObject = self.getInventoryItem(testItem)

		if firstItemObject.count >= firstItemCount then
			local weightWithoutFirstItem = ESX.Math.Round(self.weight - (firstItemObject.weight * firstItemCount))
			local weightWithTestItem = ESX.Math.Round(weightWithoutFirstItem + (testItemObject.weight * testItemCount))

			return weightWithTestItem <= self.maxWeight
		end

		return false
	end

	function self.setMaxWeight(newWeight)
		self.maxWeight = newWeight
		self.triggerEvent('esx:setMaxWeight', self.maxWeight)

		if Inventory then
			return Inventory.Set(self.source, 'maxWeight', newWeight)
		end
	end

    function self.setService(job, bool)
		if job == self.job.name then
			self.job.service = bool
			self.triggerEvent('esx:setJob', self.job)
			TriggerEvent('esx:setService', self.source, self.job.name, self.job.service)
			TriggerClientEvent('esx:setService', self.source, self.job.name, self.job.service)
		elseif job == self.job2.name then
			self.job2.service = bool
			self.triggerEvent('esx:setJob2', self.job2)
			TriggerEvent('esx:setService', self.source, self.job2.name, self.job2.service)
			TriggerClientEvent('esx:setService', self.source, self.job2.name, self.job2.service)
		end
    end

	function self.setJob(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job))

		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label

			self.job.grade        = tonumber(grade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary
            self.job.service = 0

			if gradeObject.skin_male then
				self.job.skin_male = json.decode(gradeObject.skin_male)
			else
				self.job.skin_male = {}
			end

			if gradeObject.skin_female then
				self.job.skin_female = json.decode(gradeObject.skin_female)
			else
				self.job.skin_female = {}
			end

			TriggerEvent('esx:setJob', self.source, self.job, lastJob)
			self.triggerEvent('esx:setJob', self.job)
		else
			print(('[es_extended] [^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.identifier))
		end
	end

	function self.setJob2(job2, grade2)
		grade2 = tostring(grade2)
		local lastJob = json.decode(json.encode(self.job2))

		if ESX.DoesJobExist(job2, grade2) then
			local jobObject, gradeObject = ESX.Jobs[job2], ESX.Jobs[job2].grades[grade2]

			self.job2.id    = jobObject.id
			self.job2.name  = jobObject.name
			self.job2.label = jobObject.label

			self.job2.grade        = tonumber(grade2)
			self.job2.grade_name   = gradeObject.name
			self.job2.grade_label  = gradeObject.label
			self.job2.grade_salary = gradeObject.salary
            self.job2.service = Config.service

			if gradeObject.skin_male then
				self.job2.skin_male = json.decode(gradeObject.skin_male)
			else
				self.job2.skin_male = {}
			end

			if gradeObject.skin_female then
				self.job2.skin_female = json.decode(gradeObject.skin_female)
			else
				self.job2.skin_female = {}
			end

			TriggerEvent('esx:setJob2', self.source, self.job2, lastJob)
			self.triggerEvent('esx:setJob2', self.job2)
		else
			print(('[es_extended] [^3WARNING^7] Ignoring invalid .setJob2() usage for "%s"'):format(self.identifier))
		end
	end

	function self.addWeapon(weaponName, ammo)
		-- SCN : remove when stop using core_inventory
		if true then
			self.addInventoryItem(weaponName, 1)
			return 
		end
		-- END
		
		if Inventory then return end

		if not self.hasWeapon(weaponName) then
			local weaponLabel = ESX.GetWeaponLabel(weaponName)

			table.insert(self.loadout, {
				name = weaponName,
				ammo = ammo,
				label = weaponLabel,
				components = {},
				tintIndex = 0
			})

			self.triggerEvent('esx:addWeapon', weaponName, ammo)
			self.triggerEvent('esx:addInventoryItem', weaponLabel, false, true)
		end
	end

	function self.addWeaponComponent(weaponName, weaponComponent)
		if Inventory then return end

		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if not self.hasWeaponComponent(weaponName, weaponComponent) then
					self.loadout[loadoutNum].components[#self.loadout[loadoutNum].components + 1] = weaponComponent
					self.triggerEvent('esx:addWeaponComponent', weaponName, weaponComponent)
					self.triggerEvent('esx:addInventoryItem', component.label, false, true)
				end
			end
		end
	end

	function self.addWeaponAmmo(weaponName, ammoCount)
		if Inventory then return end

		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo + ammoCount
			self.triggerEvent('esx:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	function self.updateWeaponAmmo(weaponName, ammoCount)
		if Inventory then return end

		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = ammoCount
		end
	end

	function self.setWeaponTint(weaponName, weaponTintIndex)
		if Inventory then return end

		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local weaponNum, weaponObject = ESX.GetWeapon(weaponName)

			if weaponObject.tints and weaponObject.tints[weaponTintIndex] then
				self.loadout[loadoutNum].tintIndex = weaponTintIndex
				self.triggerEvent('esx:setWeaponTint', weaponName, weaponTintIndex)
				self.triggerEvent('esx:addInventoryItem', weaponObject.tints[weaponTintIndex], false, true)
			end
		end
	end

	function self.getWeaponTint(weaponName)
		if Inventory then return 0 end

		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			return weapon.tintIndex
		end

		return 0
	end

	function self.removeWeapon(weaponName)
		if Inventory then return end

		local weaponLabel

		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				weaponLabel = v.label

				for k2,v2 in ipairs(v.components) do
					self.removeWeaponComponent(weaponName, v2)
				end

				table.remove(self.loadout, k)
				break
			end
		end

		if weaponLabel then
			self.triggerEvent('esx:removeWeapon', weaponName)
			self.triggerEvent('esx:removeInventoryItem', weaponLabel, false, true)
		end
	end

	function self.removeWeaponComponent(weaponName, weaponComponent)
		if Inventory then return end

		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if self.hasWeaponComponent(weaponName, weaponComponent) then
					for k,v in ipairs(self.loadout[loadoutNum].components) do
						if v == weaponComponent then
							table.remove(self.loadout[loadoutNum].components, k)
							break
						end
					end

					self.triggerEvent('esx:removeWeaponComponent', weaponName, weaponComponent)
					self.triggerEvent('esx:removeInventoryItem', component.label, false, true)
				end
			end
		end
	end

	function self.removeWeaponAmmo(weaponName, ammoCount)
		if Inventory then return end

		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo - ammoCount
			self.triggerEvent('esx:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	function self.hasWeaponComponent(weaponName, weaponComponent)
		if Inventory then return false end

		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			for k,v in ipairs(weapon.components) do
				if v == weaponComponent then
					return true
				end
			end

			return false
		else
			return false
		end
	end

	function self.hasWeapon(weaponName)
		if Inventory then return false end

		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return true
			end
		end

		return false
	end

	function self.hasItem(item, metadata)
		if Inventory then
			return Inventory.GetItem(self.source, name, metadata)
		end

		for k,v in ipairs(self.inventory) do
			if (v.name == name) and (v.count >= 1) then
				return v, v.count
			end
		end

		return false
	end

	function self.getWeapon(weaponName)
		if Inventory then return end

		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return k, v
			end
		end
	end

	function self.showNotification(msg)
		self.triggerEvent('esx:showNotification', msg)
	end

	function self.showHelpNotification(msg, thisFrame, beep, duration)
		self.triggerEvent('esx:showHelpNotification', msg, thisFrame, beep, duration)
	end

	function self.setCanAccess()
		if self.group == 'admin' then
			TriggerEvent('Core:SetCanAccessModeration', self.source, true)
			TriggerEvent('Core:SetCanByPassModeration', self.source, false)
			TriggerEvent('Core:SetCanHandleCommand', self.source, false)
		elseif self.group == 'superadmin' then
			TriggerEvent('Core:SetCanAccessModeration', self.source, true)
			TriggerEvent('Core:SetCanByPassModeration', self.source, true)
			TriggerEvent('Core:SetCanHandleCommand', self.source, true)
		end
	end

	function self.getCanAccess()
		exports['Nebula_Core']:CanAccessModeration(self.source)
	end

	if Inventory then
		self.syncInventory = function(weight, maxWeight, items, money)
			self.weight, self.maxWeight = weight, maxWeight
			self.inventory = items

			if money then
				for k, v in pairs(money) do
					local account = self.getAccount(k)
					if ESX.Math.Round(account.money) ~= v then
						account.money = v
						self.triggerEvent('esx:setAccountMoney', account)
					end
				end
			end
		end
	end

	self.setCanAccess()

	return self
end
