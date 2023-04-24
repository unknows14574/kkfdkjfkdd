--Sim Custom Contrib
RegisterNetEvent('Nebula_Core:CreateSimContrib')
AddEventHandler('Nebula_Core:CreateSimContrib', function()
	local number = Core.Main.EnterZoneText("Carte Sim", "", 7)

	if number == nil or string.match(number, "%W") then
		Core.Main.ShowNotification("Numero Invalide")
	else
		TriggerServerCallback('esx_prefecture:NumExist', function(sim)
			if sim then
				TriggerServerEvent('esx_prefecture:SaveSim', number)
			else
				Core.Main.ShowNotification("Numéro déjà utilisé")
			end
		end, number)
	end
end)

RegisterNetEvent('Nebula_Core:ChangePlateAdmin')
AddEventHandler('Nebula_Core:ChangePlateAdmin', function(args)
	local closestVehicle = Core.Vehicle.VehicleDetectInZone()

	if closestVehicle ~= 0 then
		SetVehicleNumberPlateText(closestVehicle, args)
	else
		Core.Main.ShowNotification("Pas de Véhicule à Proximité")
	end
end)

--Plaque Custom Contrib
RegisterNetEvent('Nebula_Core:ChangePlateCustom')
AddEventHandler('Nebula_Core:ChangePlateCustom', function()
	local closestVehicle = Core.Vehicle.VehicleDetectInZone()

	if closestVehicle ~= 0 then
		local oldPlate = Core.Math.Trim(GetVehicleNumberPlateText(closestVehicle))

		local plate = string.upper(Core.Main.EnterZoneText("Plaque", "", 8))

		if plate == nil or string.match(plate, "%W") then
			Core.Main.ShowNotification("Plaque Invalide")
		else
			TriggerServerCallback('esx_prefecture:PlateExist', function(newplate)
				if newplate then
					TriggerEvent('harybo_permanent:forget', closestVehicle)
					Wait(1000)
					SetVehicleNumberPlateText(closestVehicle, plate)
					TriggerEvent('harybo_permanent:registerveh', closestVehicle)
					TriggerServerEvent('esx_prefecture:SavePlate', oldPlate, plate)
				else
					Core.Main.ShowNotification("Plaque déjà utilisé")
				end
			end, plate)
		end
	else
		Core.Main.ShowNotification("Pas de Véhicule à Proximité")
	end
end)

--Use Skin Arme
RegisterNetEvent('Nebula_Core:SkinArme')
AddEventHandler('Nebula_Core:SkinArme', function(TableWeapon)
	local SkinArme = {
		[GetHashKey("WEAPON_PISTOL")] = { 
			name = "Pistol",
			first_or = GetHashKey("COMPONENT_PISTOL_VARMOD_LUXE") 
		},

		[GetHashKey("WEAPON_COMBATPISTOL")] = { 
			name = "Combat Pistol",
			first_or = GetHashKey("COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER") 
		},

		[GetHashKey("WEAPON_PISTOL50")] = { 
			name = "Pistol .50",
			first_or = GetHashKey("COMPONENT_PISTOL50_VARMOD_LUXE") 
		},

		[GetHashKey("WEAPON_APPISTOL")] = { 
			name = "AP Pistol",
			first_platine = GetHashKey("COMPONENT_APPISTOL_VARMOD_LUXE") 
		},

		[GetHashKey("WEAPON_REVOLVER")] = { 
			name = "Heavy Revolver",
			first_platine = GetHashKey("COMPONENT_REVOLVER_VARMOD_GOON"),
			first_or = GetHashKey("COMPONENT_REVOLVER_VARMOD_BOSS"),
		 },
		 
		[GetHashKey("WEAPON_SNSPISTOL")] = {
			name = "SNS Pistol",
			first_bronze = GetHashKey("COMPONENT_SNSPISTOL_VARMOD_LOWRIDER") 
		},

		[GetHashKey("WEAPON_HEAVYPISTOL")] = { 
			name = "Heavy Pistol",
			first_platine = GetHashKey("COMPONENT_HEAVYPISTOL_VARMOD_LUXE") 
		},

		[GetHashKey("weapon_revolver_mk2")] = { 
			name = "Heavy Revolver Mk II",
			first_patriot = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO")
		},

		[GetHashKey("weapon_snspistol_mk2")] = { 
			name = "SNS Pistol Mk II",
			first_patriot = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE"),
			first_boom = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_10_SLIDE"),
			first_geometric = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_09_SLIDE"),
			first_zebra = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_08_SLIDE"),
			first_leopard = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_07_SLIDE"),
			first_perseus = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_06_SLIDE"),
			first_sessanta = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_05_SLIDE"),
			first_skull = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_04_SLIDE"),
			first_woodland = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_03_SLIDE"),
			first_brushstroke = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_02_SLIDE"),
			first_digital = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_SLIDE"),

			second_patriot = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_IND_01"),
			second_boom = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_10"),
			second_geometric = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_09"),
			second_zebra = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_08"),
			second_leopard = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_07"),
			second_perseus = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_06"),
			second_sessanta = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_05"),
			second_skull = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_04"),
			second_woodland = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_03"),
			second_brushstroke = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_02"),
			second_digital = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO")
		},

		[GetHashKey("weapon_pistol_mk2")] = {
			name = "Pistol Mk II", 
			first_patriot = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_IND_01_SLIDE"),
			first_boom = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_10_SLIDE"),
			first_geometric = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_09_SLIDE"),
			first_zebra = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_08_SLIDE"),
			first_leopard = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_07_SLIDE"),
			first_perseus = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_06_SLIDE"),
			first_sessanta = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_05_SLIDE"),
			first_skull = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_04_SLIDE"),
			first_woodland = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_03_SLIDE"),
			first_brushstroke = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_02_SLIDE"),
			first_digital = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_SLIDE"),

			second_patriot = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_IND_01"),
			second_boom = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_10"),
			second_geometric = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_09"),
			second_zebra = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_08"),
			second_leopard = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_07"),
			second_perseus = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_06"),
			second_sessanta = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_05"),
			second_skull = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_04"),
			second_woodland = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_03"),
			second_brushstroke = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_02"),
			second_digital = GetHashKey("COMPONENT_PISTOL_MK2_CAMO")
		},

		[GetHashKey("WEAPON_MICROSMG")] = {
			name = "Micro SMG",  
			first_or = GetHashKey("COMPONENT_MICROSMG_VARMOD_LUXE") 
		},
		
		[GetHashKey("WEAPON_SMG")] = { 
			name = "SMG",
			first_or = GetHashKey("COMPONENT_SMG_VARMOD_LUXE") 
		},
		
		[GetHashKey("WEAPON_ASSAULTSMG")] = { 
			name = "Assault SMG",
			first_or = GetHashKey("COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER") 
		},

		[GetHashKey("weapon_smg_mk2")] = { 
			name = "SMG Mk II",
			first_patriot = GetHashKey("COMPONENT_SMG_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_SMG_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_SMG_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_SMG_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_SMG_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_SMG_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_SMG_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_SMG_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_SMG_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_SMG_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_SMG_MK2_CAMO")
		},

		[GetHashKey("WEAPON_PUMPSHOTGUN")] = { 
			name = "Pump Shotgun",
			first_or = GetHashKey("COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER") 
		},

		[GetHashKey("weapon_sawnoffshotgun")] = { 
			name = "Sawed-Off Shotgun",
			first_or = GetHashKey("COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE") 
		},

		[GetHashKey("weapon_pumpshotgun_mk2")] = { 
			name = "Pump Shotgun Mk II",
			first_patriot = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO")
		},

		[GetHashKey("WEAPON_ASSAULTRIFLE")] = { 
			name = "Assault Rifle",
			first_or = GetHashKey("COMPONENT_ASSAULTRIFLE_VARMOD_LUXE") 
		},

		[GetHashKey("WEAPON_CARBINERIFLE")] = { 
			name = "Carbine Rifle",
			first_or = GetHashKey("COMPONENT_CARBINERIFLE_VARMOD_LUXE") 
		},

		[GetHashKey("WEAPON_ADVANCEDRIFLE")] = {
			name = "Advanced Rifle",
			first_or = GetHashKey("COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE") 
		},

		[GetHashKey("WEAPON_SPECIALCARBINE")] = {
			name = "Special Carbine",
			first_or = GetHashKey("COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER") 
		},

		[GetHashKey("weapon_bullpuprifle")] = { 
			name = "Bullpup Rifle",
			first_or = GetHashKey("COMPONENT_BULLPUPRIFLE_VARMOD_LOW") 
		},

		[GetHashKey("weapon_bullpuprifle_mk2")] = { 
			name = "Bullpup Rifle Mk II",
			first_patriot = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO")
		},

		[GetHashKey("weapon_specialcarbine_mk2")] = { 
			name = "Special Carbine Mk II",
			first_patriot = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO")
		},

		[GetHashKey("weapon_assaultrifle_mk2")] = { 
			name = "Assault Rifle Mk II",
			first_patriot = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO")
		},

		[GetHashKey("weapon_carbinerifle_mk2")] = { 
			name = "Carbine Rifle Mk II",
			first_patriot = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO")
		},

		[GetHashKey("weapon_mg")] = {
			name = "MG", 
			first_or = GetHashKey("COMPONENT_MG_VARMOD_LOWRIDER") 
		},

		[GetHashKey("weapon_combatmg")] = {
			name = "Combat MG", 
			first_or = GetHashKey("COMPONENT_COMBATMG_VARMOD_LOWRIDER") 
		},

		[GetHashKey("weapon_combatmg_mk2")] = { 
			name = "Combat MG Mk II",
			first_patriot = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO")
		},

		[GetHashKey("WEAPON_SNIPERRIFLE")] = { 
			name = "Sniper Rifle",
			first_or = GetHashKey("COMPONENT_SNIPERRIFLE_VARMOD_LUXE") 
		},

		[GetHashKey("weapon_heavysniper_mk2")] = {
			name = "Heavy Sniper Mk II", 
			first_patriot = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO")
		},

		[GetHashKey("WEAPON_MARKSMANRIFLE")] = {
			name = "Marksman Rifle", 
			first_or = GetHashKey("COMPONENT_MARKSMANRIFLE_VARMOD_LUXE")
		},

		[GetHashKey("weapon_marksmanrifle_mk2")] = { 
			name = "Marksman Rifle Mk II",
			first_patriot = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO")
		},
		
	}

	for hash, table in pairs(SkinArme) do
		if currentWeaponHash == hash and (AllOrOne or currentWeaponHash == tonumber(NameWeapon)) then
			GiveWeaponComponentToPed(playerPed, currentWeaponHash, table[SecondOrFirstSkin .. "_" .. NameSkin])
			Core.Main.ShowNotification("Vous venez d'équiper votre arme skin.")
			return
		end
	end

	Core.Main.ShowNotification("Vous n'avez pas d'arme en main ou votre arme ne peux pas supporter le skin") 
end)

RegisterNetEvent('Nebula_Core:SkinArmeMenu')
AddEventHandler('Nebula_Core:SkinArmeMenu', function(TableWeapon)
	local SkinArme = {
		[GetHashKey("WEAPON_PISTOL")] = { 
			name = "Pistol",
			first_or = GetHashKey("COMPONENT_PISTOL_VARMOD_LUXE") 
		},

		[GetHashKey("WEAPON_COMBATPISTOL")] = { 
			name = "Combat Pistol",
			first_or = GetHashKey("COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER") 
		},

		[GetHashKey("WEAPON_PISTOL50")] = { 
			name = "Pistol .50",
			first_or = GetHashKey("COMPONENT_PISTOL50_VARMOD_LUXE") 
		},

		[GetHashKey("WEAPON_APPISTOL")] = { 
			name = "AP Pistol",
			first_platine = GetHashKey("COMPONENT_APPISTOL_VARMOD_LUXE") 
		},

		[GetHashKey("WEAPON_REVOLVER")] = { 
			name = "Heavy Revolver",
			first_platine = GetHashKey("COMPONENT_REVOLVER_VARMOD_GOON"),
			first_or = GetHashKey("COMPONENT_REVOLVER_VARMOD_BOSS"),
		 },
		 
		[GetHashKey("WEAPON_SNSPISTOL")] = {
			name = "SNS Pistol",
			first_bronze = GetHashKey("COMPONENT_SNSPISTOL_VARMOD_LOWRIDER") 
		},

		[GetHashKey("WEAPON_HEAVYPISTOL")] = { 
			name = "Heavy Pistol",
			first_platine = GetHashKey("COMPONENT_HEAVYPISTOL_VARMOD_LUXE") 
		},

		[GetHashKey("weapon_revolver_mk2")] = { 
			name = "Heavy Revolver Mk II",
			first_patriot = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO")
		},

		[GetHashKey("weapon_snspistol_mk2")] = { 
			name = "SNS Pistol Mk II",
			first_patriot = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE"),
			first_boom = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_10_SLIDE"),
			first_geometric = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_09_SLIDE"),
			first_zebra = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_08_SLIDE"),
			first_leopard = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_07_SLIDE"),
			first_perseus = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_06_SLIDE"),
			first_sessanta = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_05_SLIDE"),
			first_skull = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_04_SLIDE"),
			first_woodland = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_03_SLIDE"),
			first_brushstroke = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_02_SLIDE"),
			first_digital = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_SLIDE"),

			second_patriot = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_IND_01"),
			second_boom = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_10"),
			second_geometric = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_09"),
			second_zebra = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_08"),
			second_leopard = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_07"),
			second_perseus = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_06"),
			second_sessanta = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_05"),
			second_skull = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_04"),
			second_woodland = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_03"),
			second_brushstroke = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_02"),
			second_digital = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO")
		},

		[GetHashKey("weapon_pistol_mk2")] = {
			name = "Pistol Mk II", 
			first_patriot = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_IND_01_SLIDE"),
			first_boom = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_10_SLIDE"),
			first_geometric = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_09_SLIDE"),
			first_zebra = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_08_SLIDE"),
			first_leopard = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_07_SLIDE"),
			first_perseus = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_06_SLIDE"),
			first_sessanta = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_05_SLIDE"),
			first_skull = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_04_SLIDE"),
			first_woodland = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_03_SLIDE"),
			first_brushstroke = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_02_SLIDE"),
			first_digital = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_SLIDE"),

			second_patriot = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_IND_01"),
			second_boom = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_10"),
			second_geometric = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_09"),
			second_zebra = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_08"),
			second_leopard = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_07"),
			second_perseus = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_06"),
			second_sessanta = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_05"),
			second_skull = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_04"),
			second_woodland = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_03"),
			second_brushstroke = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_02"),
			second_digital = GetHashKey("COMPONENT_PISTOL_MK2_CAMO")
		},

		[GetHashKey("WEAPON_MICROSMG")] = {
			name = "Micro SMG",  
			first_or = GetHashKey("COMPONENT_MICROSMG_VARMOD_LUXE") 
		},
		
		[GetHashKey("WEAPON_SMG")] = { 
			name = "SMG",
			first_or = GetHashKey("COMPONENT_SMG_VARMOD_LUXE") 
		},
		
		[GetHashKey("WEAPON_ASSAULTSMG")] = { 
			name = "Assault SMG",
			first_or = GetHashKey("COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER") 
		},

		[GetHashKey("weapon_smg_mk2")] = { 
			name = "SMG Mk II",
			first_patriot = GetHashKey("COMPONENT_SMG_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_SMG_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_SMG_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_SMG_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_SMG_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_SMG_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_SMG_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_SMG_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_SMG_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_SMG_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_SMG_MK2_CAMO")
		},

		[GetHashKey("WEAPON_PUMPSHOTGUN")] = { 
			name = "Pump Shotgun",
			first_or = GetHashKey("COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER") 
		},

		[GetHashKey("weapon_sawnoffshotgun")] = { 
			name = "Sawed-Off Shotgun",
			first_or = GetHashKey("COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE") 
		},

		[GetHashKey("weapon_pumpshotgun_mk2")] = { 
			name = "Pump Shotgun Mk II",
			first_patriot = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO")
		},

		[GetHashKey("WEAPON_ASSAULTRIFLE")] = { 
			name = "Assault Rifle",
			first_or = GetHashKey("COMPONENT_ASSAULTRIFLE_VARMOD_LUXE") 
		},

		[GetHashKey("WEAPON_CARBINERIFLE")] = { 
			name = "Carbine Rifle",
			first_or = GetHashKey("COMPONENT_CARBINERIFLE_VARMOD_LUXE") 
		},

		[GetHashKey("WEAPON_ADVANCEDRIFLE")] = {
			name = "Advanced Rifle",
			first_or = GetHashKey("COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE") 
		},

		[GetHashKey("WEAPON_SPECIALCARBINE")] = {
			name = "Special Carbine",
			first_or = GetHashKey("COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER") 
		},

		[GetHashKey("weapon_bullpuprifle")] = { 
			name = "Bullpup Rifle",
			first_or = GetHashKey("COMPONENT_BULLPUPRIFLE_VARMOD_LOW") 
		},

		[GetHashKey("weapon_bullpuprifle_mk2")] = { 
			name = "Bullpup Rifle Mk II",
			first_patriot = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO")
		},

		[GetHashKey("weapon_specialcarbine_mk2")] = { 
			name = "Special Carbine Mk II",
			first_patriot = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO")
		},

		[GetHashKey("weapon_assaultrifle_mk2")] = { 
			name = "Assault Rifle Mk II",
			first_patriot = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO")
		},

		[GetHashKey("weapon_carbinerifle_mk2")] = { 
			name = "Carbine Rifle Mk II",
			first_patriot = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO")
		},

		[GetHashKey("weapon_mg")] = {
			name = "MG", 
			first_or = GetHashKey("COMPONENT_MG_VARMOD_LOWRIDER") 
		},

		[GetHashKey("weapon_combatmg")] = {
			name = "Combat MG", 
			first_or = GetHashKey("COMPONENT_COMBATMG_VARMOD_LOWRIDER") 
		},

		[GetHashKey("weapon_combatmg_mk2")] = { 
			name = "Combat MG Mk II",
			first_patriot = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO")
		},

		[GetHashKey("WEAPON_SNIPERRIFLE")] = { 
			name = "Sniper Rifle",
			first_or = GetHashKey("COMPONENT_SNIPERRIFLE_VARMOD_LUXE") 
		},

		[GetHashKey("weapon_heavysniper_mk2")] = {
			name = "Heavy Sniper Mk II", 
			first_patriot = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO")
		},

		[GetHashKey("WEAPON_MARKSMANRIFLE")] = {
			name = "Marksman Rifle", 
			first_or = GetHashKey("COMPONENT_MARKSMANRIFLE_VARMOD_LUXE")
		},

		[GetHashKey("weapon_marksmanrifle_mk2")] = { 
			name = "Marksman Rifle Mk II",
			first_patriot = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_IND_01"),
			first_boom = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_10"),
			first_geometric = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_09"),
			first_zebra = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_08"),
			first_leopard = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_07"),
			first_perseus = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_06"),
			first_sessanta = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_05"),
			first_skull = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_04"),
			first_woodland = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_03"),
			first_brushstroke = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_02"),
			first_digital = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO")
		},
		
	}

	local TableLocal = {}
	for k, v in pairs(TableWeapon) do
		local SplitName = Core.Math.StringSplit(v, "_")
		if TableLocal[SkinArme[SplitName[#SplitName]].name] == nil then
			TableLocal[SkinArme[SplitName[#SplitName]].name] = {}
		end
		table.insert(TableLocal[SkinArme[SplitName[#SplitName]].name], { NameSkin = SplitName[#SplitName - 1], Type = SplitName[#SplitName - 2], hash = SplitName[#SplitName] })
	end
	local TableSkinWeapon = {}

	local menu = RageUI.CreateMenu("Skin Arme", "Skin Arme", nil, nil, nil, nil, nil, 255, 192, 203, 255)
	menu:SetStyleSize(300)
	local submenu = RageUI.CreateSubMenu(menu, "Skin Arme", "Skin Arme", nil, nil, nil, nil, nil, 255, 192, 203, 255)
	submenu:SetStyleSize(300)

	RageUI.Visible(menu, not RageUI.Visible(menu))
	while menu do
		RageUI.IsVisible(menu, function()
			for k, e in pairs(TableLocal) do
				RageUI.Button(k, k, {RightLabel = "→→→"}, true, {
					onSelected = function()
						TableSkinWeapon = e
						print("tets")
					end
				}, submenu)
			end                 
		end)
		RageUI.IsVisible(submenu, function()
			for k, l in pairs(TableSkinWeapon) do
				RageUI.Button(l.Type .. " " .. l.NameSkin, l.NameSkin, {RightLabel = "→→→"}, true, {
					onSelected = function()
						if currentWeaponHash == l.hash then
							GiveWeaponComponentToPed(playerPed, currentWeaponHash, SkinArme[currentWeaponHash][l.Type .. "_" .. l.NameSkin])
							Core.Main.ShowNotification("Vous venez d'équiper votre arme skin.")
							return
						end
						print("tets")
					end
				})
			end  
		end)
		if not RageUI.Visible(menu) and not RageUI.Visible(submenu) then
			Infos = nil
			menu = RMenu:DeleteType(menu, true)
		end
		Citizen.Wait(3)
	end

	
	-- for hash, table in pairs(SkinArme) do
	-- 	if currentWeaponHash == hash and (AllOrOne or currentWeaponHash == tonumber(NameWeapon)) then
	-- 		GiveWeaponComponentToPed(playerPed, currentWeaponHash, table[SecondOrFirstSkin .. "_" .. NameSkin])
	-- 		Core.Main.ShowNotification("Vous venez d'équiper votre arme skin.")
	-- 		return
	-- 	end
	-- end

	Core.Main.ShowNotification("Vous n'avez pas d'arme en main ou votre arme ne peux pas supporter le skin") 
end)
