--[[ STATES : 
0 = Sortie
1 = Rangé
2 = Volé 
3 = Fourrière serveur
4 = Fourrière Paleto Wreck
5 = Saisies LSPD 
6 = Saisies Shériff 
7 = Vente aux enchères Paleto Wreck ]]

--Variable Locale
local elements, elements2, elements3, elements4 = {}, {}, nil, {}
local Use = nil
local Search = ""

--Menu Modification accès véhicule entreprise
local function ModifGradeVehEntreprise(garage, identifier)
	elements = {}
	TriggerServerCallback('Core-Garage:getVehicles', function(vehiculesTab, identifierSteam)
		TriggerServerCallback('Core-Garage:job_grade',function(resultGrade, resultUsers)
			for _,v in pairs(vehiculesTab) do
				v.vehicle = json.decode(v.vehicle)
				v.health = json.decode(v.health)
				if identifier ~= "stolen" then
					v.IsGrade = json.decode(v.IsGrade)
				end
				local state = "Garage"
				local vehTrouver = false

				if v.state == 2 then
					state = "Volé ou détruit"
				elseif v.state == 0 then
					state = "Sortie"
				end
						
				for _,m in pairs(v.IsGrade) do
					if string.sub(m, 0, 5) == "steam" then
						for k, p in pairs(resultUsers) do
							if p.identifier == m then
								table.insert(elements, {label = " - " .. p.firstname .. " " .. p.lastname , value = v, plate = v.plate, grade = v.IsGrade, state = state, name_vehicle = v.name_vehicle, model = v.vehicle.model})
								if v.name_vehicle ~= nil then
									elements[#elements].label = v.name_vehicle .. elements[#elements].label
								else
									elements[#elements].label = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)) .. elements[#elements].label
								end
								vehTrouver = true
							end
						end
						if not vehTrouver then
							table.insert(elements, {label = ' - Ancien Employé', value = v, plate= v.plate, grade = v.IsGrade, state = state, name_vehicle = v.name_vehicle, model = v.vehicle.model})
							if v.name_vehicle ~= nil then
								elements[#elements].label = v.name_vehicle .. elements[#elements].label
							else
								elements[#elements].label = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)) .. elements[#elements].label
							end
						end
						vehTrouver = false
					else
						for _,l in pairs(resultGrade) do
							if l.grade == tonumber(m) then
								table.insert(elements, {label = " - " .. l.label, value = v, plate= v.plate, grade = v.IsGrade, state = state, name_vehicle = v.name_vehicle, model = v.vehicle.model})
								if v.name_vehicle ~= nil then
									elements[#elements].label = v.name_vehicle .. elements[#elements].label
								else
									elements[#elements].label = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)) .. elements[#elements].label
								end
								break
							end
						end
					end
				end
			
				table.sort(elements, function(a, b) return string.lower(a.label) < string.lower(b.label) end)
			end

			local menu = RageUI.CreateMenu("Gérer les Véhicules", "Garage", nil, nil, nil, nil, nil, 112, 128, 144, 255)
			menu:SetStyleSize(300)
			local submenu = RageUI.CreateSubMenu(menu, "Gérer les Véhicules", "Garage", nil, nil, nil, nil, nil, 112, 128, 144, 255)
			submenu:SetStyleSize(300)
			local submenu2 = RageUI.CreateSubMenu(submenu, "Gérer les Véhicules", "Garage", nil, nil, nil, nil, nil, 112, 128, 144, 255)
			submenu2:SetStyleSize(300)

			RageUI.Visible(menu, not RageUI.Visible(menu))
			while menu do
				RageUI.IsVisible(menu, function()
					for _, e in pairs(elements) do
						RageUI.Button(e.label, "Plaque : " .. e.plate .. " Etat : " .. e.state, {RightLabel = "→→→"}, true, {
							onSelected = function()
								elements2 = {
									{label ="Autoriser le véhicule à partir d'un certains grades" , value = "grade", plate = e.plate},
									{label ="Autoriser le véhicule à certaines personnes" , value = "personne", plate = e.plate, grade = e.grade},
									{label ="Supprimer le véhicule à certaines personnes" , value = "del_personne", plate = e.plate, grade = e.grade},
									{label ="Modifier le nom du véhicule", value = "name_véhicle", info = e}
								}
								if e.name_vehicle and e.name_vehicle ~= GetLabelText(GetDisplayNameFromVehicleModel(e.model)) then
									table.insert(elements2, {label ="Reinitialiser le nom du véhicule", value = "reset_vehicle", info = e})
								end 
							end
						}, submenu)
					end                 
				end)

				RageUI.IsVisible(submenu, function()
					for _, g in pairs(elements2) do
						RageUI.Button(g.label, g.label, {RightLabel = "→→→"}, true, {
							onSelected = function()
								Use = g.value
								if g.value == "grade" then
									elements3 = {}
									for _,v in pairs(resultGrade) do
										table.insert(elements3, {label = "Grade : " .. v.label , value = v.grade, labelName=v.label, plate = g.plate})
									end

								elseif g.value == "personne" then
									elements3 = {}
									for _,v in pairs(resultUsers) do
										table.insert(elements3, {label = v.firstname .. " " .. v.lastname , value = v.identifier, plate = g.plate, grade = g.grade})
									end
									
									table.sort(elements3, function(a, b) return string.lower(a.label) < string.lower(b.label) end)

								elseif g.value == "del_personne" then
									elements3 = {}
									for _,m in pairs(g.grade) do
										for _,v in pairs(resultUsers) do
											if m == v.identifier then
												table.insert(elements3, {label = v.firstname .. " " .. v.lastname , value = v.identifier, plate = g.plate, grade = g.grade})
											end
										end
									end
									if #elements3 <= 0 then
										table.insert(elements3, {label = "Supprimer autorisation ancien employé", value = "del_old_emploie", plate = g.plate})
									end
								elseif g.value == "name_véhicle" then
									elements3 = nil
									local name_vehicle = Core.Main.EnterZoneText("Nom du Véhicule", "", 10)
									Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Nom du véhicule modifié', "CHAR_MP_MORS_MUTUAL", 1, false, true, 80)
									TriggerServerEvent('Core-Garage:ChangeNameVeh', g.info.plate, name_vehicle)
									RageUI.CloseAll()
								elseif g.value == "reset_vehicle" then
									elements3 = nil
									local name_vehicle = GetLabelText(GetDisplayNameFromVehicleModel(g.info.model))
									Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Nom du véhicule modifié', "CHAR_MP_MORS_MUTUAL", 1, false, true, 80)
									TriggerServerEvent('Core-Garage:ChangeNameVeh', g.info.plate, name_vehicle)
									RageUI.CloseAll()
								end
							end
						}, ((elements3 ~= nil and submenu2) or nil))
					end                 
				end)

				RageUI.IsVisible(submenu2, function()
					if Use == "grade" then
						for _, m in pairs(elements3) do
							RageUI.Button(m.label, m.labelName, {RightLabel = "→→→"}, true, {
								onSelected = function()
									TriggerServerEvent('Core-Garage:GradeChangeVeh', m.plate, {m.value})
									Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Grade changé sur ' .. m.labelName, "CHAR_MP_MORS_MUTUAL", 1, false, true, 210)
									RageUI.CloseAll()
								end,
							})
						end                 
					elseif Use == "personne" then
						for _, m in pairs(elements3) do
							RageUI.Button(m.label, m.label, {RightLabel = "→→→"}, true, {
								onSelected = function()
									local UserChoose = m.value
									local GradeChooseModif = m.grade
									for n,m in pairs(GradeChooseModif) do
										if tonumber(m) then
											table.remove(GradeChooseModif, n)
										end
									end
									table.insert(GradeChooseModif, UserChoose)

									TriggerServerEvent('Core-Garage:GradeChangeVeh', m.plate, GradeChooseModif)
									Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Autorisation attribué à ' .. m.label, "CHAR_MP_MORS_MUTUAL", 1, false, true, 210)
									RageUI.CloseAll()
								end
							})
						end
					elseif Use == "del_personne" then
						for _, m in pairs(elements3) do
							RageUI.Button(m.label, m.label, {RightLabel = "→→→"}, true, {
								onSelected = function()
									local UserChoose = m.value
									local GradeChooseModif = m.grade
								
									if m.value == "del_old_emploie" then
										GradeChooseModif = {0}
									else
										for n,m in pairs(GradeChooseModif) do
											if tonumber(m) or m == UserChoose then
												table.remove(GradeChooseModif, n)
											end
										end
										if #GradeChooseModif <= 0 then
											GradeChooseModif = {0}
										end
									end

									TriggerServerEvent('Core-Garage:GradeChangeVeh', m.plate, GradeChooseModif)
									Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Autorisation supprimé pour ' .. m.label, "CHAR_MP_MORS_MUTUAL", 1, false, true, 130)
									RageUI.CloseAll()
								end
							})
						end
					end
				end)

				if not RageUI.Visible(menu) and not RageUI.Visible(submenu) and not RageUI.Visible(submenu2) then
					Infos = nil
					menu = RMenu:DeleteType('garage', true)
				end
				Citizen.Wait(3)
			end	
		end, identifier)
	end, identifier)
end

--Menu liste des véhicules en fonction de l'option choisit
local function GetVehicle(garage, identifier, StateToAttribute, IsJob)
	local tableLocal = {}
	TriggerServerCallback('Core-Garage:getVehicles', function(vehiculesTab, identifierSteam)
		for _,v in pairs(vehiculesTab) do
			v.vehicle = json.decode(v.vehicle)
			v.health = json.decode(v.health)
			local AuthPass = false
			if identifier ~= "stolen" and identifier ~= "owner" and identifier ~= "owner2" and identifier ~= "special" then
				v.IsGrade = json.decode(v.IsGrade)
				for m,l in pairs(v.IsGrade) do
					if l == identifierSteam or (identifier == PlayerData.job.name and ((type(l) == "number" and tonumber(l) <= PlayerData.job.grade) or PlayerData.job.grade_name == "boss")) or (identifier == PlayerData.job2.name and ((type(l) == "number" and tonumber(l) <= PlayerData.job2.grade) or PlayerData.job2.grade_name == "boss")) then						
						AuthPass = true
						break
					end
				end
			else
				AuthPass = true
			end

			if AuthPass then
				if v.state == 0 then
					labelvehicle = {etat = '~b~Sortie', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = false}
				elseif v.state == 1 then
					if v.garage == garage then
						labelvehicle = {etat = "~g~" .. v.garage, Style = { RightBadge = RageUI.BadgeStyle.Car }, ActionEnable = true}
					elseif v.garage == "0" or v.garage == nil then
						labelvehicle = {etat = '~g~Aucun Garage', Style = { RightBadge = RageUI.BadgeStyle.Car }, ActionEnable = true}
					else
						labelvehicle = {etat = "~p~" .. v.garage, Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = false}
					end
				elseif v.state == 2 then
					labelvehicle = {etat = '~r~Volé ou détruit', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = false}
				elseif v.state == 3 then
					labelvehicle = {etat = '~o~Fourrière de l\'etat', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = false}
				elseif v.state == 4 then
					if PlayerData.job.name == IsJob then
						labelvehicle = {etat = v.plate..' : ~g~Véhicule garé ici', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = true}
					else
						labelvehicle = {etat = '~y~Fourrière privée', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = false}
					end
				elseif v.state == 5 then
					if PlayerData.job.name == IsJob then
						labelvehicle = {etat = v.plate..' : ~g~Véhicule saisi', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = true}
					else
						labelvehicle = {etat = '~b~Saisie par les services de police', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = false}
					end
				elseif v.state == 6 then
					if PlayerData.job.name == IsJob then
						labelvehicle = {etat = v.plate..' : ~g~Véhicule saisi', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = true}
					else
						labelvehicle = {etat = '~b~Saisie par les services de Sheriff\'s', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = false}
					end
				elseif v.state == 7 then
					if PlayerData.job.name == IsJob then
						labelvehicle = {etat = v.plate..' : ~g~Véhicule mis aux enchères', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = true}
					else
						labelvehicle = {etat = '~y~Véhicule mis aux enchères', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = false}
					end	
				elseif v.state == 8 then
					if PlayerData.job.name == IsJob then
						labelvehicle = {etat = v.plate..' : ~g~Véhicule en contrôle / réparation', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = true}
					else
						labelvehicle = {etat = '~b~Véhicule en dépôt au Benny\'s', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = false}
					end
				elseif v.state == 9 then
					if PlayerData.job.name == IsJob then
						labelvehicle = {etat = v.plate..' : ~g~Véhicule en contrôle / réparation', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = true}
					else
						labelvehicle = {etat = '~b~Véhicule en dépôt au LS Custom North', Style = { RightBadge = RageUI.BadgeStyle.Lock }, ActionEnable = false}
					end
				end
				
				table.insert(tableLocal, {label = " - " .. labelvehicle.etat, value = v, state = v.state, garage = v.garage, name = {name = GetDisplayNameFromVehicleModel(v.vehicle.model), Style = labelvehicle.Style, ActionEnable = labelvehicle.ActionEnable}, identifier = identifier, name_vehicle = v.name_vehicle})				if v.name_vehicle ~= nil then
					tableLocal[#tableLocal].label = v.name_vehicle .. tableLocal[#tableLocal].label
				else
					tableLocal[#tableLocal].label = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)) .. tableLocal[#tableLocal].label
				end
			end
		
			table.sort(tableLocal, function(a, b) return string.lower(a.label) < string.lower(b.label) end)
		end
	end, identifier, (assurance or false), StateToAttribute, IsJob)

	return tableLocal
end


--Menu pour choisir la catégorie de véhicule
function OpenGaragaPV(garage, Pos, Ped, StateToAttribute, IsJob)
	elements, elements2, elements3 = {}, {}, {}
	local menu = RageUI.CreateMenu("Garage", "Garage", nil, nil, nil, nil, nil, 112, 128, 144, 255)
	menu:SetTitle(garage)
	menu:SetStyleSize(100)
	local submenuModif = RageUI.CreateSubMenu(menu, "Garage", "Garage", nil, nil, nil, nil, nil, 112, 128, 144, 255)
	submenuModif:SetStyleSize(100)

	local EnPlusJob, elementsModifActive = 1, false
	if not IsJob or (IsJob and not StateToAttribute) then
		IsJob = nil
		if PlayerData.job.grade_name == "boss" or PlayerData.job.grade_name == "coboss" then
			table.insert(elements3, {Name = "Gérer Véhicule d'entreprise " .. PlayerData.job.label, value = PlayerData.job.name})
			EnPlusJob = EnPlusJob + 1
		end
		if PlayerData.job2.grade_name == "boss" or PlayerData.job2.grade_name == "coboss" then
			table.insert(elements3, {Name = "Gérer Véhicule d'entreprise " .. PlayerData.job2.label, value = PlayerData.job2.name})
			EnPlusJob = EnPlusJob + 1
		end

		table.insert(elements, {Name = "Personnel", value = "owner"})
		table.insert(elements, {Name = "Partager", value = 'owner2'})
		table.insert(elements, {Name = "Volé", value = 'stolen'})
		table.insert(elements, {Name = PlayerData.job.label, value = PlayerData.job.name})
		table.insert(elements, {Name = PlayerData.job2.label, value = PlayerData.job2.name})
	else
		table.insert(elements, {Name = "Véhicules dans le garage", value = "special"})
	end
	
	local listGarage = {
		id = 1,
		items = "owner"
	}
	local VehicleUseDemo = {
		Plate = nil,
		idVehicle = nil,
		StatPanel = {
			id = nil,
			info = nil
		}
	}
	local elementsModifActive, elementsModif = false, nil
	elements2 = GetVehicle(garage, elements[1].value, StateToAttribute, IsJob)

	TriggerEvent('xpiwel:disableRadar', false)
	RageUI.Visible(menu, not RageUI.Visible(menu))
	while menu do
		RageUI.IsVisible(menu, function()
			RageUI.Button("Rechercher", "Entrer un partie ou le mot entier", {RightLabel = "🔎"}, true, {
				onSelected = function()
					Search = Core.Main.EnterZoneText("Entrer un partie ou le mot entier", "", 20)
					Search = ((Search ~= nil and string.lower(Search)) or "")
					local TableSearch = {}
					for k, result in pairs(elements2) do
						table.insert(TableSearch, Core.Math.SearchTable(result, Search))
					end
					elements2 = TableSearch
				end
			})
			if Search ~= "" then
				RageUI.Button("Supprimer la Recherche", "", {RightLabel = "❌"}, true, {
					onSelected = function()
						Search = ""
						elements2 = GetVehicle(garage, listGarage.items, StateToAttribute, IsJob)
					end
				})
			end
			for k, v in pairs(elements3) do
				RageUI.Button(v.Name, nil, {RightBadge = RageUI.BadgeStyle.Valise}, true, {
					onSelected = function()
						ModifGradeVehEntreprise(garage, v.value)
					end
				})
			end
			RageUI.List("Trier", elements, listGarage.id, "Choisir votre garage", {}, true, {
				onListChange = function(Index, Items)
					listGarage.id = Index
					listGarage.items = Items.value
					Search = ""
					elements2 = GetVehicle(garage, Items.value, StateToAttribute, IsJob)
				end
		   	})
		   	if #elements2 >= 1 then
				for k, e in pairs(elements2) do
					RageUI.Button(e.label, "Plaque : " .. ((e.value.vehicle.plate and e.value.vehicle.plate) or ""), e.name.Style, e.name.ActionEnable, {
						onSelected = function()
							-- if e.value.pos ~= nil then
							-- 	elementsModifActive = false
							-- 	print("POSITION VEHICULE : ", e.value.pos.x, e.value.pos.y, e.value.pos.z)
							-- 	SetNewWaypoint(e.value.pos.x, e.value.pos.y) 
							-- 	RageUI.CloseAll()
							-- else
							if e.name.name ~= 'CARNOTFOUND' then
								if e.identifier == "stolen" or e.identifier == "owner" or e.identifier == "owner2" then
									elementsModifActive = true
								else
									elementsModifActive = false
									if VehicleUseDemo.idVehicle ~= nil then
										TriggerEvent('xpiwel:disableRadar', true)
										if not Ped then
											SetEntityVisible(playerPed, true)
										end
										Core.Vehicle.DeleteVehicule(VehicleUseDemo.idVehicle)
										VehicleUseDemo.idVehicle = nil
									end
									if e.state == 0 then
										Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est sortie', "CHAR_MP_MORS_MUTUAL", 1, false, true, 80)
									elseif e.state == 1 or e.state == 4 or e.state == 5 or e.state == 6 or e.state == 7 or e.state == 8 or e.state == 9 then
										if e.garage == garage or e.garage == "0" or e.garage == nil then
											if GetClosestVehicle(Pos.x, Pos.y, Pos.z, 3.0, 0, 71) == 0 then
												RageUI.CloseAll()
												Wait(100)
												-- if Ped then
												-- 	FreezeEntityPosition(Ped.id, false)
												-- 	TaskGoToCoordAnyMeans(Ped.id, Pos.x - 2.5, Pos.y, Pos.z, Pos.Angle, 0, 0, 0, 0xbf800000)
												-- 	while GetDistanceBetweenCoords(GetEntityCoords(Ped.id), Pos.x - 2.5, Pos.y, Pos.z, true) >= 1.5 do
												-- 		Citizen.Wait(500)
												-- 	end
												-- end
												local callback_vehicle = Core.Vehicle.SpawnVehicle(e.value.vehicle.model, { x = Pos.x, y = Pos.y, z = Pos.z, h = Pos.Angle}, e.value.vehicle, e.value.health)
												if not Ped then
													TaskWarpPedIntoVehicle(playerPed, callback_vehicle, -1)
												end
												TriggerServerEvent('Core-Garage:modifystate', e.value.vehicle.plate, 0, e.value.garage, e.value.health, e.identifier)

												Citizen.Wait(500)
												TriggerEvent('harybo_permanent:registerveh', callback_vehicle)
												Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule ' .. e.name.name .. " vient d'être sorti", "CHAR_MP_MORS_MUTUAL", 1, false, true, 30)
											else
												Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Sortie encombré. Veuillez attendre que la place se libère.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 130)
											end
										else
											Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est dans le ' .. e.garage, "CHAR_MP_MORS_MUTUAL", 1, false, true, 40)
										end
									elseif e.state == 2 then
										Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est volé ou détruit', "CHAR_MP_MORS_MUTUAL", 1, false, true, 130)
									elseif e.state == 3 then
										Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est à la fourrière de la ville.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 120)
									elseif e.state == 4 then
										Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est à la fourrière privée : Paleto Wreck', "CHAR_MP_MORS_MUTUAL", 1, false, true, 120)
									elseif e.state == 5 then
										Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est saisie par les services de polices.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 120)
									elseif e.state == 6 then
										Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est saisie par les Sheriff\'s.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 120)
									elseif e.state == 7 then
										Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est mis aux enchères.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 120)	
									elseif e.state == 8 then
										Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est en dépôt au Benny\'s.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 120)
									elseif e.state == 9 then
										Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est en dépôt au LS Custom North.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 120)
									end
								end
							else
								Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule ['..e.value.vehicle.plate..'] a un problème. Contacter l\'assistance.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 130)
								RageUI.CloseAll()
							end
						end,
						onActive = function()
							if (VehicleUseDemo.Plate == nil or VehicleUseDemo.Plate ~= e.value.vehicle.plate) and e.name.name ~= 'CARNOTFOUND' then
								if VehicleUseDemo.idVehicle ~= nil then
									Core.Vehicle.DeleteVehicule(VehicleUseDemo.idVehicle)
									VehicleUseDemo.idVehicle = nil
								end

								if e.identifier == "stolen" or e.identifier == "owner" or e.identifier == "owner2" then
									submenuModif:SetTitle((e.name_vehicle ~= nil and e.name_vehicle) or GetLabelText(GetDisplayNameFromVehicleModel(e.value.vehicle.model)))
									elementsModif = {
										{label ="Sortir le Véhicule" , value = "out_vehicle", info = e},
										{label ="Modifier le nom du véhicule", value = "name_véhicle", info = e}
									}
									if e.name_vehicle and e.name_vehicle ~= GetLabelText(GetDisplayNameFromVehicleModel(e.value.vehicle.model)) then
										table.insert(elementsModif, {label ="Reset le nom du véhicule", value = "reset_vehicle", info = e})
									end 
								end

								VehicleUseDemo.StatPanel.id = k
								VehicleUseDemo.Plate = e.value.vehicle.plate

								local callback_vehicle = Core.Vehicle.SpawnVehicle(e.value.vehicle.model, { x = Pos.x, y = Pos.y, z = Pos.z, h = Pos.Angle}, e.value.vehicle, e.value.health, true)
								VehicleUseDemo.idVehicle = callback_vehicle
								VehicleUseDemo.StatPanel.info = e.value
								FreezeEntityPosition(callback_vehicle, true)
								if not Ped then
									SetEntityVisible(playerPed, false)
									TaskWarpPedIntoVehicle(playerPed, callback_vehicle, -1)
								end

								VehicleUseDemo.StatPanel.info.vehicle.capacity = GetVehicleMaxNumberOfPassengers(VehicleUseDemo.idVehicle) + 1
								for k, v in pairs(ClassesVehicle) do
									if GetVehicleClass(VehicleUseDemo.idVehicle) == v.id then
										VehicleUseDemo.StatPanel.info.vehicle.ClassesVehicle = k
										break
									end
								end
								if not VehicleUseDemo.StatPanel.info.vehicle.modTurbo then
									VehicleUseDemo.StatPanel.info.vehicle.Turbo = "Non"
								else
									VehicleUseDemo.StatPanel.info.vehicle.Turbo = "Oui"
								end
								VehicleUseDemo.StatPanel.info.vehicle.modele = GetLabelText(GetDisplayNameFromVehicleModel(VehicleUseDemo.StatPanel.info.vehicle.model))
								VehicleUseDemo.StatPanel.info.vehicle.marque = GetLabelText(GetMakeNameFromVehicleModel(VehicleUseDemo.StatPanel.info.vehicle.model))

								for m, v in pairs(NameItemVehicle) do
									for k, l in pairs(v) do
										if (m == "Moteur" and (GetVehicleMod(VehicleUseDemo.idVehicle, 11) + 1) == k - 1) or (m == "Frein" and (GetVehicleMod(VehicleUseDemo.idVehicle, 12) + 1) == k - 1) or (m == "Suspension" and (GetVehicleMod(VehicleUseDemo.idVehicle, 15) + 1) == k - 1) or (m == "Transmission" and (GetVehicleMod(VehicleUseDemo.idVehicle, 13) + 1) == k - 1) then
											VehicleUseDemo.StatPanel.info.vehicle[m] = l
										end
										
									end
								end
							end
						end
					}, ((elementsModifActive ~= nil and submenuModif) or nil))
				end
			end  
		end, function()
			if VehicleUseDemo.StatPanel.info ~= nil then
				local Ajout = 1 + EnPlusJob + ((Search ~= "" and 1) or 0)
				RageUI.StatisticPanelString("Marque", VehicleUseDemo.StatPanel.info.vehicle.marque, VehicleUseDemo.StatPanel.id + Ajout)
				RageUI.StatisticPanelString("Modèle", VehicleUseDemo.StatPanel.info.vehicle.modele, VehicleUseDemo.StatPanel.id + Ajout)
				RageUI.StatisticPanelString("Type", VehicleUseDemo.StatPanel.info.vehicle.ClassesVehicle, VehicleUseDemo.StatPanel.id + Ajout)
				RageUI.StatisticPanelString("Capacité", VehicleUseDemo.StatPanel.info.vehicle.capacity, VehicleUseDemo.StatPanel.id + Ajout)
				RageUI.StatisticPanelString("Moteur", VehicleUseDemo.StatPanel.info.vehicle.Moteur, VehicleUseDemo.StatPanel.id + Ajout)
				RageUI.StatisticPanelString("Frein", VehicleUseDemo.StatPanel.info.vehicle.Frein, VehicleUseDemo.StatPanel.id + Ajout)
				RageUI.StatisticPanelString("Transmission", VehicleUseDemo.StatPanel.info.vehicle.Transmission, VehicleUseDemo.StatPanel.id + Ajout)
				RageUI.StatisticPanelString("Suspension", VehicleUseDemo.StatPanel.info.vehicle.Suspension, VehicleUseDemo.StatPanel.id + Ajout)
				RageUI.StatisticPanelString("Turbo", VehicleUseDemo.StatPanel.info.vehicle.Turbo, VehicleUseDemo.StatPanel.id + Ajout)
				RageUI.StatisticPanel(VehicleUseDemo.StatPanel.info.health.fuel / 100, "Essence", VehicleUseDemo.StatPanel.id + Ajout)
			end
		end)

		RageUI.IsVisible(submenuModif, function()
			if #elementsModif >= 1 then
				for _, g in pairs(elementsModif) do
					RageUI.Button(g.label, nil, {RightLabel = "→→→"}, true, {
						onSelected = function()
							if g.value == "out_vehicle" then

								if VehicleUseDemo.idVehicle ~= nil then
									TriggerEvent('xpiwel:disableRadar', true)
									if not Ped then
										SetEntityVisible(playerPed, true)
									end
									Core.Vehicle.DeleteVehicule(VehicleUseDemo.idVehicle)
									VehicleUseDemo.idVehicle = nil
								end
								if g.info.state == 0 then
									Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est sortie', "CHAR_MP_MORS_MUTUAL", 1, false, true, 80)
								elseif g.info.state == 1 or g.info.state == 4 or g.info.state == 5 or g.info.state == 6 or g.info.state == 7 or g.info.state == 8 or g.info.state == 9 then
									if g.info.garage == garage or g.info.garage == "0" or g.info.garage == nil then
										if GetClosestVehicle(Pos.x, Pos.y, Pos.z, 3.0, 0, 71) == 0 then
											RageUI.CloseAll()
											Wait(100)
											local callback_vehicle = Core.Vehicle.SpawnVehicle(g.info.value.vehicle.model, { x = Pos.x, y = Pos.y, z = Pos.z, h = Pos.Angle}, g.info.value.vehicle, g.info.value.health)
											TriggerServerEvent('Core-Garage:modifystate', g.info.value.vehicle.plate, 0, g.info.value.garage, g.info.value.health, g.info.identifier)
											if not Ped then
												TaskWarpPedIntoVehicle(playerPed, callback_vehicle, -1)
											end
											Citizen.Wait(500)
											TriggerEvent('harybo_permanent:registerveh', callback_vehicle)
											Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule ' .. g.info.name.name .. " vient d'être sorti", "CHAR_MP_MORS_MUTUAL", 1, false, true, 30)
											if not Ped then
												TriggerEvent('Nebula_hud:ForceVehiculeHud', true)												
											end
										else
											Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Sortie Encombré', "CHAR_MP_MORS_MUTUAL", 1, false, true, 130)
										end
									else
										Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est dans le ' .. g.info.garage, "CHAR_MP_MORS_MUTUAL", 1, false, true, 40)
									end
								elseif g.info.state == 2 then
									Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est volé ou détruit', "CHAR_MP_MORS_MUTUAL", 1, false, true, 130)
								elseif g.info.state == 3 then
									Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est à la fourrière de la ville.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 120)
								elseif g.info.state == 4 then
									Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est à la fourrière privée : Paleto Wreck', "CHAR_MP_MORS_MUTUAL", 1, false, true, 120)
								elseif g.info.state == 5 then
									Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est saisie par les services de polices.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 120)
								elseif g.info.state == 6 then
									Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est saisie par les Sheriff\'s.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 120)
								elseif g.info.state == 7 then
									Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est mis aux enchères.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 120)	
								elseif g.info.state == 8 then
									Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est en dépôt au Benny\'s.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 120)
								elseif g.info.state == 9 then
									Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Votre véhicule est en dépôt au LS Custom North.', "CHAR_MP_MORS_MUTUAL", 1, false, true, 120)
								end

							elseif g.value == "name_véhicle" then
								local name_vehicle = Core.Main.EnterZoneText("Nom du Véhicule", "", 10)
								Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Nom du véhicule modifié', "CHAR_MP_MORS_MUTUAL", 1, false, true, 80)
								TriggerServerEvent('Core-Garage:ChangeNameVeh', g.info.value.vehicle.plate, name_vehicle, g.info.identifier)
								submenuModif:SetTitle(name_vehicle)
								elements2 = GetVehicle(garage, listGarage.items, StateToAttribute, IsJob)
							elseif g.value == "reset_vehicle" then
								local name_vehicle = GetLabelText(GetDisplayNameFromVehicleModel(g.info.value.vehicle.model))
								Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Nom du véhicule modifié', "CHAR_MP_MORS_MUTUAL", 1, false, true, 80)
								TriggerServerEvent('Core-Garage:ChangeNameVeh', g.info.value.vehicle.plate, name_vehicle, g.info.identifier)
								submenuModif:SetTitle(name_vehicle)
								elements2 = GetVehicle(garage, listGarage.items, StateToAttribute, IsJob)
							end
						end
					})
				end  
			end               
		end)

		if not RageUI.Visible(menu) and not RageUI.Visible(submenuModif) then
			Infos = nil
			menu = RMenu:DeleteType('garage', true)
			TriggerEvent('xpiwel:disableRadar', true)
			FreezeEntityPosition(playerPed,false)
			if VehicleUseDemo.idVehicle ~= nil then
				if not Ped then
					SetEntityVisible(playerPed, true)
				end
				Core.Vehicle.DeleteVehicule(VehicleUseDemo.idVehicle)
				VehicleUseDemo.idVehicle = nil
			end
		end
		
		Citizen.Wait(3)
	end
end

--Menu fourrière
function OpenMenuFourriere(Pos, Ped)
	elements = {
		{label = "Retour véhicule personnel ("..iV.Blips.Fourriere.Price.."$)", value = "owner"},
		{label = "Retour véhicule partager ("..iV.Blips.Fourriere.Price.."$)", value = 'owner2'},
		{label = "Retour véhicule d'entreprise ".. PlayerData.job.label.." ("..iV.Blips.Fourriere.Price.."$)", value = PlayerData.job.name},
		{label = "Retour véhicule d'entreprise ".. PlayerData.job2.label.." ("..iV.Blips.Fourriere.Price.."$)", value = PlayerData.job2.name}
	}

	local VehicleUseDemo = {
		Plate = nil,
		idVehicle = nil,
		StatPanel = {
			id = nil,
			info = nil
		}
	}

	local menu = RageUI.CreateMenu("Fourrière de la ville", "Fourrière", nil, nil, nil, nil, nil, 139, 0, 0, 255)
	menu:SetStyleSize(300)
	local submenu = RageUI.CreateSubMenu(menu, "Liste des Véhicules", "Fourriere", nil, nil, nil, nil, nil, 139, 0, 0, 255)
	submenu:SetStyleSize(300)

	TriggerEvent('xpiwel:disableRadar', false)
	RageUI.Visible(menu, not RageUI.Visible(menu))
	while menu do
		RageUI.IsVisible(menu, function()
			for _, e in pairs(elements) do
				RageUI.Button(e.label, e.label, {RightLabel = "→→→"}, true, {
					onSelected = function()
						elements2 = {}
						TriggerServerCallback('Core-Garage:getVehicles', function(vehiclesTab, identifierSteam)
							for _,v in pairs(vehiclesTab) do
								if v.state == 3 then
									local AuthPass = false
									if e.value ~= "owner" and e.value ~= "owner2" then
										v.IsGrade = json.decode(v.IsGrade)
										for m,l in pairs(v.IsGrade) do
											if l == identifierSteam or (e.value == PlayerData.job.name and ((type(l) == "number" and tonumber(l) <= PlayerData.job.grade) or PlayerData.job.grade_name == "boss")) or (e.value == PlayerData.job2.name and ((type(l) == "number" and tonumber(l) <= PlayerData.job2.grade) or PlayerData.job2.grade_name == "boss")) then						
												AuthPass = true
												break
											end
										end
									else
										AuthPass = true
									end

									if AuthPass then
										v.vehicle = json.decode(v.vehicle)
										v.health = json.decode(v.health)
										
										table.insert(elements2, {label = ' - Fourrière' , value = v, state = v.state, garage = v.garage})
										if v.name_vehicle ~= nil then
											elements2[#elements2].label = v.name_vehicle .. elements2[#elements2].label
										else
											elements2[#elements2].label = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)) .. elements2[#elements2].label
										end

										table.sort(elements2, function(a, b) return string.lower(a.label) < string.lower(b.label) end)
									end
								end
							end
						end, e.value)
					end
				}, submenu)
			end                 
		end)
		RageUI.IsVisible(submenu, function()
			for k, l in pairs(elements2) do
				RageUI.Button(l.label, "Plaque : " .. l.value.plate, {RightLabel = "→→→"}, true, {
					onSelected = function()
						if VehicleUseDemo.idVehicle ~= nil then
							TriggerEvent('xpiwel:disableRadar', true)
							if not Ped then
								SetEntityVisible(playerPed, true)
							end
							Core.Vehicle.DeleteVehicule(VehicleUseDemo.idVehicle)
							VehicleUseDemo.idVehicle = nil
						end
						if GetClosestVehicle(Pos.x, Pos.y, Pos.z, 3.0, 0, 71) == 0 then
							TriggerServerCallback('Core-Garage:checkMoney', function(hasEnoughMoney)
								if hasEnoughMoney then
									RageUI.CloseAll()
									Wait(100)
									local callback_vehicle = Core.Vehicle.SpawnVehicle(l.value.vehicle.model, { x = Pos.x, y = Pos.y, z = Pos.z, h = Pos.Angle}, l.value.vehicle, l.value.health)
									if not Ped then
										TaskWarpPedIntoVehicle(playerPed, callback_vehicle, -1)
										RealistSpeed(callback_vehicle)
									end

									Citizen.Wait(500)
									TriggerEvent('harybo_permanent:registerveh', callback_vehicle)		
								end
							end, l.value.vehicle.plate)
						else
							Core.Main.ShowAdvancedNotification("Garage", "Notification", 'Sortie Encombré', "CHAR_MP_MORS_MUTUAL", 1, false, true, 130)
						end
					end,
					onActive = function()
						if VehicleUseDemo.Plate == nil or VehicleUseDemo.Plate ~= l.value.vehicle.plate then
							if VehicleUseDemo.idVehicle ~= nil then
								Core.Vehicle.DeleteVehicule(VehicleUseDemo.idVehicle)
								VehicleUseDemo.idVehicle = nil
							end
							VehicleUseDemo.StatPanel.id = k
							VehicleUseDemo.Plate = l.value.vehicle.plate

							local callback_vehicle = Core.Vehicle.SpawnVehicle(l.value.vehicle.model, { x = Pos.x, y = Pos.y, z = Pos.z, h = Pos.Angle}, l.value.vehicle, l.value.health, true)
							VehicleUseDemo.idVehicle = callback_vehicle
							VehicleUseDemo.StatPanel.info = l.value
							FreezeEntityPosition(callback_vehicle, true)
							if not Ped then
								SetEntityVisible(playerPed, false)
								TaskWarpPedIntoVehicle(playerPed, callback_vehicle, -1)
							end

							VehicleUseDemo.StatPanel.info.vehicle.capacity = GetVehicleMaxNumberOfPassengers(VehicleUseDemo.idVehicle) + 1
							for k, v in pairs(ClassesVehicle) do
								if GetVehicleClass(VehicleUseDemo.idVehicle) == v.id then
									VehicleUseDemo.StatPanel.info.vehicle.ClassesVehicle = k
									break
								end
							end
							if not VehicleUseDemo.StatPanel.info.vehicle.modTurbo then
								VehicleUseDemo.StatPanel.info.vehicle.Turbo = "Non"
							else
								VehicleUseDemo.StatPanel.info.vehicle.Turbo = "Oui"
							end
							VehicleUseDemo.StatPanel.info.vehicle.modele = GetLabelText(GetDisplayNameFromVehicleModel(VehicleUseDemo.StatPanel.info.vehicle.model))
							VehicleUseDemo.StatPanel.info.vehicle.marque = GetLabelText(GetMakeNameFromVehicleModel(VehicleUseDemo.StatPanel.info.vehicle.model))

							for m, v in pairs(NameItemVehicle) do
								for k, l in pairs(v) do
									if (m == "Moteur" and (GetVehicleMod(VehicleUseDemo.idVehicle, 11) + 1) == k - 1) or (m == "Frein" and (GetVehicleMod(VehicleUseDemo.idVehicle, 12) + 1) == k - 1) or (m == "Suspension" and (GetVehicleMod(VehicleUseDemo.idVehicle, 15) + 1) == k - 1) or (m == "Transmission" and (GetVehicleMod(VehicleUseDemo.idVehicle, 13) + 1) == k - 1) then
										VehicleUseDemo.StatPanel.info.vehicle[m] = l
									end
									
								end
							end
						end
					end
				})
			end            
		end, function()
			if VehicleUseDemo.StatPanel.info ~= nil then

				RageUI.StatisticPanelString("Marque", VehicleUseDemo.StatPanel.info.vehicle.marque, VehicleUseDemo.StatPanel.id)
				RageUI.StatisticPanelString("Modèle", VehicleUseDemo.StatPanel.info.vehicle.modele, VehicleUseDemo.StatPanel.id)
				RageUI.StatisticPanelString("Type", VehicleUseDemo.StatPanel.info.vehicle.ClassesVehicle, VehicleUseDemo.StatPanel.id)
				RageUI.StatisticPanelString("Capacité", VehicleUseDemo.StatPanel.info.vehicle.capacity, VehicleUseDemo.StatPanel.id)
				RageUI.StatisticPanelString("Moteur", VehicleUseDemo.StatPanel.info.vehicle.Moteur, VehicleUseDemo.StatPanel.id)
				RageUI.StatisticPanelString("Frein", VehicleUseDemo.StatPanel.info.vehicle.Frein, VehicleUseDemo.StatPanel.id)
				RageUI.StatisticPanelString("Transmission", VehicleUseDemo.StatPanel.info.vehicle.Transmission, VehicleUseDemo.StatPanel.id)
				RageUI.StatisticPanelString("Suspension", VehicleUseDemo.StatPanel.info.vehicle.Suspension, VehicleUseDemo.StatPanel.id)
				RageUI.StatisticPanelString("Turbo", VehicleUseDemo.StatPanel.info.vehicle.Turbo, VehicleUseDemo.StatPanel.id)
				RageUI.StatisticPanel(VehicleUseDemo.StatPanel.info.health.fuel / 100, "Essence", VehicleUseDemo.StatPanel.id)
				

			end
		end)

		if not RageUI.Visible(menu) and not RageUI.Visible(submenu) then
			Infos = nil
			menu = RMenu:DeleteType('fourriere', true)
			TriggerEvent('xpiwel:disableRadar', true)

			if VehicleUseDemo.idVehicle ~= nil then
				if not Ped then
					SetEntityVisible(playerPed, true)
				end
				Core.Vehicle.DeleteVehicule(VehicleUseDemo.idVehicle)
				VehicleUseDemo.idVehicle = nil
			end
		end
		Citizen.Wait(3)
	end
end

--Menu Assurance
function OpenMenuAssurance()
	elements, elements2 = {}, {}
	table.insert(elements, {label = "Personnel", value = "owner"})
	if PlayerData.job.grade_name == "boss" or PlayerData.job.grade_name == "coboss" then
		table.insert(elements, {label = PlayerData.job.label, value = PlayerData.job.name, isJob = true})
	end
	if PlayerData.job2.grade_name == "boss" or PlayerData.job2.grade_name == "coboss" then
		table.insert(elements, {label = PlayerData.job2.label, value = PlayerData.job2.name, isJob = true})
	end

	local menu = RageUI.CreateMenu("Assurance", "Assurance", nil, nil, nil, nil, nil, 255, 192, 203, 255)
	menu:SetStyleSize(300)
	local submenu = RageUI.CreateSubMenu(menu, "Liste des Véhicules", "Assurance", nil, nil, nil, nil, nil, 255, 192, 203, 255)
	submenu:SetStyleSize(300)

	RageUI.Visible(menu, not RageUI.Visible(menu))
	while menu do
		RageUI.IsVisible(menu, function()
			for _, e in pairs(elements) do
				RageUI.Button(e.label, e.label, {RightLabel = "→→→"}, true, {
					onSelected = function()
						elements2 = {}
						TriggerServerCallback('Core-Garage:getVehicles', function(vehiclesTab, identifierSteam)
							for _,v in pairs(vehiclesTab) do
								--if v.state ~= 2 then
									if GetLabelText(GetDisplayNameFromVehicleModel(v.model)) == nil or GetLabelText(GetDisplayNameFromVehicleModel(v.model)) == "NULL" then
										if v.model ~= nil then
											label_veh = v.model
										else
											label_veh = v.plate
										end
									else
										label_veh = GetLabelText(GetDisplayNameFromVehicleModel(v.model))
									end
									table.insert(elements2, {label = label_veh, model = v.model, assuranceState = v.assurance, price = v.price, plate = v.plate, state = v.state})
									if v.name_vehicle ~= nil then
										elements2[#elements2].label = v.name_vehicle
									end

									table.sort(elements2, function(a, b) return string.lower(a.label) < string.lower(b.label) end)
								--end
							end
						end, e.value, true, nil, e.isJob)
					end
				}, submenu)
			end			
			RageUI.Button('Informations sur les retours d\'assurances', 'Assurer votre véhicule vous permet de vous le faire rembourser sous ~b~5 jours~w~ en cas de vol ou de destruction. Le véhicule vous sera alors remis passé ce délai dans le garage de votre choix.' , {}, true, {
				onSelected = function()
				end
			}, nil)
			RageUI.Button('Informations sur le paiement des assurances', 'Les assurances que vous avez souscrites sont débitées ~b~tous les jours~w~ directement sur votre compte en banque ou sur le compte de l\'entreprise pour les véhicules d\'entreprise.' , {}, true, {
				onSelected = function()
				end
			}, nil)
			RageUI.Button('Informations sur l\'annulation d\'un contrat d\'assurance', 'Un contrat d\'assurance peut être résilié à tout moment. Les contrats ne sont pas résiliés automatiquement même si vous n\'avez plus assez de provision sur votre compte.' , {}, true, {
				onSelected = function()
				end
			}, nil)
		end)
		RageUI.IsVisible(submenu, function()
			if elements2 == nil then
				RageUI.Item.Separator("Veuillez attendre quelques secondes,")
				RageUI.Item.Separator("le temps que la liste des véhicules charge")
			else
				for k, l in pairs(elements2) do
					if l.state ~= 2 then
						RageUI.Checkbox(l.label .. ((l.assuranceState and " - ~g~Assuré") or " - ~r~Non Assuré"), "Plaque : " .. l.plate .. ", Prix : " .. tostring(tonumber(l.price) * (iV.Blips.Assurance.Pourcentage / 100)) .. "$", l.assuranceState, { Style = RageUI.CheckboxStyle.Tick }, {
							onChecked = function(Index)
								TriggerServerCallback('Core-Garage:assurancechange', function(assuranceChanged)
									if assuranceChanged ~= nil then
										if assuranceChanged then
											l.assuranceState = true
											Core.Main.ShowAdvancedNotification("Assurance", "Notification", "Votre véhicule est maintenant assuré !", "CHAR_MP_MORS_MUTUAL", 1, false, true, 210)
										end
									else
										Core.Main.ShowAdvancedNotification("Assurance", "Notification", "Une erreur s'est produite, merci de reessayer. Code erreur #0002", "CHAR_MP_MORS_MUTUAL", 1, false, true, 140)
									end
								end, l.plate, 1, tonumber(l.price) * (iV.Blips.Assurance.Pourcentage / 100))
							end,
							onUnChecked = function(Index)
								TriggerServerCallback('Core-Garage:assurancechange', function(assuranceChanged)
									if assuranceChanged == "ok" then
										l.assuranceState = false
										Core.Main.ShowAdvancedNotification("Assurance", "Notification", "Votre véhicule n'est plus assuré !", "CHAR_MP_MORS_MUTUAL", 1, false, true, 130)
									else
										Core.Main.ShowAdvancedNotification("Assurance", "Notification", "Une erreur s'est produite, merci de reessayer. Code erreur #0002", "CHAR_MP_MORS_MUTUAL", 1, false, true, 140)
									end
								end, l.plate, 0, tonumber(l.price) * (iV.Blips.Assurance.Pourcentage / 100))
							end
						})
					else
						RageUI.Button(l.label .. ((l.assuranceState and " - ~g~Assuré") or " - ~r~Non Assuré"), "Plaque : " .. l.plate .. ", ~r~volée~w~.", {RightBadge = RageUI.BadgeStyle.Lock}, false, {
							onSelected = function() end
						}, nil)
					end
				end   
			end  
		end)
		if not RageUI.Visible(menu) and not RageUI.Visible(submenu) then
			Infos = nil
			menu = RMenu:DeleteType('assurance', true)
		end
		Citizen.Wait(3)
	end
end

--Menu Prefecture
function OpenMenuPrefecture()
	elements = {
	  {label = 'Donner un véhicule', table = "owner", action = "give_vehicle"},
	  {label = 'Partager un véhicule', table = "owner", action = "partage_vehicle"},
	  {label = 'Supprimer un véhicule partagé', table = "owner", action = "del_partage_vehicle"},
	}
	if PlayerData.job.grade_name == "boss" then
		table.insert(elements, {label = "Donner un véhicule de " .. PlayerData.job.name, table = PlayerData.job.name, action = "give_vehicle"})
	end
	if PlayerData.job2.grade_name == "boss" then
		table.insert(elements, {label = "Donner un véhicule de " .. PlayerData.job2.name, table = PlayerData.job2.name, action = "give_vehicle"})
	end

	local menu = RageUI.CreateMenu("Prefecture", "Prefecture", nil, nil, nil, nil, nil, 0, 0, 0, 125)
	menu:SetStyleSize(300)
	local submenu = RageUI.CreateSubMenu(menu, "Prefecture", "Prefecture", nil, nil, nil, nil, nil, 0, 0, 0, 125)
	submenu:SetStyleSize(300)
	local submenu2 = RageUI.CreateSubMenu(submenu, "Prefecture", "Prefecture", nil, nil, nil, nil, nil, 0, 0, 0, 125)
	submenu2:SetStyleSize(300)
	local submenu3 = RageUI.CreateSubMenu(submenu2, "Prefecture", "A qui voulez vous donné ce véhicule ?", nil, nil, nil, nil, nil, 0, 0, 0, 125)
	submenu3:SetStyleSize(300)

	RageUI.Visible(menu, not RageUI.Visible(menu))
	while menu do
		RageUI.IsVisible(menu, function()
			for _, e in pairs(elements) do
				RageUI.Button(e.label, e.label, {RightLabel = "→→→"}, true, {
					onSelected = function()
						elements2 = {}
						TriggerServerCallback('Core-Garage:getVehicles', function(vehiclesTab, identifierSteam)
							for _,v in pairs(vehiclesTab) do
								v.vehicle = json.decode(v.vehicle)
								
								local pricegive = (tonumber(v.price) * (7 / 100))
								table.insert(elements2, {label = " - " .. v.plate, value = v, action = e.action, price = pricegive })
								if v.name_vehicle ~= nil then
									elements2[#elements2].label = v.name_vehicle .. elements2[#elements2].label
								else
									elements2[#elements2].label = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)) .. elements2[#elements2].label
								end

								if e.action == "give_vehicle" then
									elements2[#elements2].RightLabel = "~r~Tarif: ".. pricegive .. "$"
								end
							
								table.sort(elements2, function(a, b) return string.lower(a.label) < string.lower(b.label) end)
							end
						end, e.table)
					end
				}, submenu)
			end                 
		end)

		RageUI.IsVisible(submenu, function()
			for _, l in pairs(elements2) do
				RageUI.Button(l.label, l.label, {RightLabel = l.RightLabel}, true, {
					onSelected = function()
						if l.action == 'give_vehicle' or l.action == 'partage_vehicle' then
							elements3 = {
								{label = "Donner à une entreprise", value="entreprise", vehicle = l.value, activate = l.action ~= 'partage_vehicle', price = l.price},
								{label = "Donner à un joueur", value="joueur", vehicle = l.value, activate = l.action, price = l.price},
							}
						elseif l.action == 'del_partage_vehicle' then
							RageUI.CloseAll()
							TriggerServerEvent('Core-Garage:AddDelPartageVehicle', l.value.plate, "0")
							Core.Main.ShowAdvancedNotification("Préfecture", "Notification", "~y~Vous avez supprimez le deuxième conducteur~r~ [" .. l.value.plate .. "]", "CHAR_MP_MORS_MUTUAL", 1, false, true, 130)
						end
					end
				}, submenu2)
			end  
		end)

		RageUI.IsVisible(submenu2, function()
			for _, r in pairs(elements3) do
				RageUI.Button(r.label, "Choisir", {RightLabel = "→→→"}, (r.activate ~= nil or not r.activate), {
					onSelected = function()	
						elements4 = {}
						if r.value == 'entreprise' then
							TriggerServerCallback('Core:job', function(valid)
								for k, v in pairs(valid) do
									table.insert(elements4, {label = v.label, value = v.name, type = r.value, vehicle = r.vehicle, price = r.price})
								end
							end)
						elseif r.value == 'joueur' then
							ESX.TriggerServerCallback('esx_jobcounter:returnTableMetier',function(valid)
								for k, v in pairs(valid) do
									table.insert(elements4, { value = v.id, label = v.firstname .. " " .. v.lastname, type = r.value, vehicle = r.vehicle, partageVeh = r.activate, price = r.price})
								end	
							end, "tabName", "players")
						end
						table.sort(elements4, function(a, b) return string.lower(a.label) < string.lower(b.label) end)
					end
				}, submenu3)
			end           
		end)

		RageUI.IsVisible(submenu3, function()
			for _, e in pairs(elements4) do
				RageUI.Button(e.label, e.label, {RightLabel = "→→→"}, true, {
					onSelected = function()
						if e.type == 'entreprise' then
							TriggerServerCallback('Core-Garage:GiveVehicle', function(hasEnoughMoney)
								if hasEnoughMoney then
									Core.Main.ShowAdvancedNotification("Préfecture", "Notification", "Vous avez donné votre véhicule ~o~" .. e.vehicle.plate .. "~n~~s~à l'entreprise ~p~" .. e.label, "CHAR_MP_MORS_MUTUAL", 1, false, true, 210)	
									TriggerServerEvent('CoreLog:SendDiscordLog', 'Préfécture - don de véhicule', GetPlayerName(PlayerId()) .. " a donné son véhicule `" .. e.vehicle.model .. "` immatriculé `[".. e.vehicle.plate .. "]` à l'entreprise ".. e.label, 'Orange')
								else
									Core.Main.ShowAdvancedNotification("Préfecture", "Notification", "Vous n'avez pas assez d'argent", "CHAR_MP_MORS_MUTUAL", 1, false, true, 210)	
								end
							end, e.vehicle.plate, e.value, e.price)
							RageUI.CloseAll()
						elseif e.type == 'joueur' then
							if e.partageVeh == "partage_vehicle" then
								TriggerServerEvent('Core-Garage:AddDelPartageVehicle', e.vehicle.plate, e.value)
								Core.Main.ShowAdvancedNotification("Préfecture", "Notification", "~y~Vous avez ajouté ~r~" .. e.label .. " ~y~en tant que 2eme conducteur [" .. e.vehicle.plate .. "]", "CHAR_MP_MORS_MUTUAL", 1, false, true, 210)
								RageUI.CloseAll()
							else
								TriggerServerCallback('Core-Garage:GiveVehicle', function(hasEnoughMoney)
									if hasEnoughMoney then
										Core.Main.ShowAdvancedNotification("Préfecture", "Notification", "Vous avez donné votre véhicule ~o~" .. e.vehicle.plate .. "~n~~s~à ~p~" .. e.label, "CHAR_MP_MORS_MUTUAL", 1, false, true, 210)
										TriggerServerEvent('CoreLog:SendDiscordLog', 'Préfécture - don de véhicule', GetPlayerName(PlayerId()) .. " a donné son véhicule `" .. e.vehicle.model .. "` immatriculé `[".. e.vehicle.plate .. "]` à ".. e.label, 'Green', e.value, GetPlayerServerId(PlayerId()))
									else
										Core.Main.ShowAdvancedNotification("Préfecture", "Notification", "Vous n'avez pas assez d'argent", "CHAR_MP_MORS_MUTUAL", 1, false, true, 210)	
									end
								end, e.vehicle.plate, e.value, e.price)
								RageUI.CloseAll()
							end
						end
					end
				})
			end                 
		end)

		if not RageUI.Visible(menu) and not RageUI.Visible(submenu) and not RageUI.Visible(submenu2) and not RageUI.Visible(submenu3) then
			Infos = nil
			menu = RMenu:DeleteType('prefecture', true)
		end
		Citizen.Wait(3)
	end
end

--Rentrer Vehicle Garage
function ReturnVehicleGarage(GarageName, VehClosest, Ped, StateToAttribute)	
	TriggerServerCallback('Core-Garage:stockVehicle',function(valid)
		if valid then
			if type(valid) == "boolean" then
				if not Ped then
					TaskLeaveVehicle(playerPed, VehClosest, 0)
					Wait(1500)
				end
				---- TriggerEvent('harybo_permanent:forgetveh', VehClosest, true)
				Core.Vehicle.DeleteVehicule(VehClosest, true)
				Core.Main.ShowAdvancedNotification("Garage", "Notification", "Vous avez rangé le véhicule", "CHAR_MP_MORS_MUTUAL", 1, false, true, 210)
			elseif type(valid) == "string" then
				Core.Main.ShowAdvancedNotification("Garage", "Notification", valid, "CHAR_MP_MORS_MUTUAL", 1, false, true, 130)
			end
		else
			Core.Main.ShowAdvancedNotification("Garage", "Notification", "Vous ne pouvez pas stocker ce véhicule", "CHAR_MP_MORS_MUTUAL", 1, false, true, 130)
		end
		Infos = nil
	end, json.encode(Core.Vehicle.GetVehicleProperties(VehClosest)), GarageName, json.encode(Core.Vehicle.GetDamageVehicle(VehClosest)), Core.Math.Trim(GetVehicleNumberPlateText(VehClosest)), {PlayerData.job.name, PlayerData.job2.name}, StateToAttribute)	
end