Config_esx_nebevent                            = {}
Config_esx_nebevent.DrawDistance = 15.0--               = 100.0
Config_esx_nebevent.MarkerColor                = { r = 102, g = 0, b = 102 }
Config_esx_nebevent.EnablePlayerManagement     = true
Config_esx_nebevent.EnableVaultManagement      = true
Config_esx_nebevent.EnableSocietyOwnedVehicles = false
Config_esx_nebevent.EnableHelicopters          = false
Config_esx_nebevent.EnableMoneyWash            = false
Config_esx_nebevent.MaxInService               = -1
Config_esx_nebevent.Locale                     = 'fr'

Config_esx_nebevent.AuthorizedVehicles = {
	{ name = 'elegy2', label = 'Elegy DRIFT' },
	{ name = 'sultanrsv8', label = 'Sultan RSDRIFT' },
	{ name = 'bmwe3', label = 'BMW DRIFT' },
}

Config_esx_nebevent.AuthorizedVehicles2 = {
	{ name = 'newsheli', label = 'Helico #1' },
	{ name = 'buzzard2', label = 'Helico #2' },
}

Config_esx_nebevent.Blips = {

	Blip = {
		Pos   = { x = 1208.80, y = -3115.16, z = 5.54-0.98 },
	}
}

Config_esx_nebevent.Zones = {

    BossActions = {
        Pos   = { x = 1208.80, y = -3115.16, z = 5.54-0.98 },
        Size  = { x = 1.3, y = 1.3, z = 1.0 },
        Color = { r = 0, g = 100, b = 0 },
        Type  = 25,
    },
	
	Cloakrooms = {
		Pos   = { x = 1209.77, y = -3121.78, z = 5.54-0.98 },
		Size  = { x = 1.3, y = 1.3, z = 1.0 },
        Color = { r = 0, g = 100, b = 0 },
        Type  = 25,
	},

    Vehicles = {
        Pos          = { x = 1196.38, y = -3105.56, z = 6.02-0.98 },
        SpawnPoint   = { x = 1196.39, y = -3103.07, z = 6.02-0.98},
        Size         = { x = 1.3, y = 1.3, z = 1.0 },
        Color        = { r = 0, g = 255, b = 128 },
        Type         = 25,
        Heading      = 359.85,
    },	
	
	Vehicles2 = {
        Pos          = { x = -576.22, y = 927.62, z = 36.83-0.98 },
		SpawnPoint   = { x = -583.49, y = -930.47, z = 36.83-0.98},
        Size         = { x = 1.3, y = 1.3, z = 1.0 },
        Color        = { r = 0, g = 255, b = 128 },
        Type         = 25,
        Heading      = 298.13,
    },

	VehicleDeleters = {
		Pos  = { x = 1189.54, y = -3105.51, z = 5.67-0.98},
		Size = { x = 4.0, y = 4.0, z = 2.0 },
        Color = { r = 255, g = 0, b = 0 },		
		Type = 25
	},	
	
	VehicleDeleters2 = {
		Pos  = { x = -583.49, y = -930.47, z = 36.83},
		Size = { x = 7.0, y = 7.0, z = 2.0 },
        Color = { r = 255, g = 0, b = 0 },		
		Type = 25
	},

    Vaults = {
        Pos   = { x = 1198.76, y = -3117.37, z = 5.54-0.98 },
        Size  = { x = 1.3, y = 1.3, z = 1.0 },
        Color        = { r = 0, g = 255, b = 128 },
        Type  = 25,
    },	
}

Config_esx_nebevent.Uniforms = {
	nebevent_outfit = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 111,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 4,
			['pants_1'] = 13,   ['pants_2'] = 0,
			['shoes_1'] = 57,   ['shoes_2'] = 10,
			['chain_1'] = 0,  ['chain_2'] = 0
		},
		female = {
			['tshirt_1'] = 14,   ['tshirt_2'] = 0,
			['torso_1'] = 27,    ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 0,   ['pants_2'] = 8,
			['shoes_1'] = 3,    ['shoes_2'] = 2,
			['chain_1'] = 2,    ['chain_2'] = 1
		}
	},
  nebevent_outfit_1 = {
		male = {
			['tshirt_1'] = 6,  ['tshirt_2'] = 1,
			['torso_1'] = 25,   ['torso_2'] = 3,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 13,   ['pants_2'] = 0,
			['shoes_1'] = 51,   ['shoes_2'] = 1,
			['chain_1'] = 24,  ['chain_2'] = 5
		},
		female = {
			['glasses_1'] = 5,	['glasses_2'] = 0,
			['tshirt_1'] = 24,   ['tshirt_2'] = 0,
			['torso_1'] = 28,   ['torso_2'] = 4,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['chain_1'] = 0,   ['chain_2'] = 0
		}	
	},
  nebevent_outfit_2 = {
		male = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 77,   ['torso_2'] = 1,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 13,   ['pants_2'] = 0,
			['shoes_1'] = 51,   ['shoes_2'] = 1,
			['chain_1'] = 27,  ['chain_2'] = 5
		},
		female = {
			['glasses_1'] = 5,	['glasses_2'] = 0,
			['tshirt_1'] = 40,   ['tshirt_2'] = 7,
			['torso_1'] = 64,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['chain_1'] = 0,   ['chain_2'] = 0
		}	
	},
  nebevent_outfit_3 = {
		male = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 31,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 4,
			['pants_1'] = 10,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['chain_1'] = 27,  ['chain_2'] = 5
		},
		female = {
			['glasses_1'] = 5,	['glasses_2'] = 0,
			['tshirt_1'] = 20,   ['tshirt_2'] = 2,
			['torso_1'] = 24,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 5,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['chain_1'] = 0,   ['chain_2'] = 0
		}	
	}
}

Config_esx_nebevent.Txt = {
	-- Cloakroom
	['cloakroom'] = 'Vestiaire',
	['citizen_wear'] = 'Tenue civile',
	['nebevent_outfit'] = 'Tenue de stagiaire',
	['nebevent_outfit_1'] = 'Tenue de reporter',
	['nebevent_outfit_2'] = 'Tenue d\'enquêteur',
	['nebevent_outfit_3'] = 'Tenue de directeur', 
    ['no_outfit'] = 'Il n\'y a pas d\'uniforme à votre taille...',
    ['open_cloackroom'] = 'Appuyez sur ~INPUT_CONTEXT~ pour vous changer',
	
	-- Vehicles  
    ['vehicle_menu']             = 'Véhicule',
    ['vehicle_out']              = 'Il y a déja un véhicule dehors',
    ['vehicle_spawner']          = 'Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule',
    ['store_vehicle']            = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule',
    ['service_max']              = 'Service complet : ',
    ['spawn_point_busy']         = 'Un véhicule occupe le point de sortie',
	
	-- Boss Menu
	['deposit_society'] = 'déposer argent',
	['withdraw_society'] = 'retirer argent société',
	['boss_actions'] = 'action Patron',
	-- Misc
	['invalid_amount'] = '~r~montant invalide',
	['open_menu'] = 'appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu',
	['deposit_amount'] = 'montant du dépôt',
	['money_withdraw'] = 'montant du retrait',
 
    -- Vault  
    ['get_weapon']               = 'Prendre Arme',
    ['put_weapon']               = 'Déposer Arme',
    ['get_weapon_menu']          = 'Coffre - Prendre Arme',
    ['put_weapon_menu']          = 'Coffre - Déposer Arme',
    ['get_object']               = 'Prendre Objet',
    ['put_object']               = 'Déposer Objet',
    ['vault']                    = 'Coffre',
    ['open_vault']               = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au coffre',

    -- Boss Menu  
    ['take_company_money']       = 'Retirer argent société',
    ['deposit_money']            = 'Déposer argent',
    ['amount_of_withdrawal']     = 'Montant du retrait',
    ['invalid_amount']           = 'Montant invalide',
    ['amount_of_deposit']        = 'Montant du dépôt',
    ['open_bossmenu']            = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu',
    ['invalid_quantity']         = 'Quantité invalide',
    ['you_removed']              = 'Vous avez retiré x',
    ['you_added']                = 'Vous avez ajouté x',
    ['quantity']                 = 'Quantité',
    ['inventory']                = 'Inventaire',
    ['unicorn_stock']            = 'Stock',

    -- Misc 
    ['map_blip']                 = 'Los Santos Informer',

    -- Billing Menu  
    ['billing']                  = 'Facture',
    ['no_players_nearby']        = 'Aucun joueur à proximité',
    ['billing_amount']           = 'Montant de la facture',
    ['amount_invalid']           = 'Montant invalide',
    
}