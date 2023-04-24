Config_MusicRecord                            = {}
Config_MusicRecord.DrawDistance = 15.0--               = 100.0
Config_MusicRecord.MarkerColor                = { r = 102, g = 0, b = 102 }
Config_MusicRecord.EnablePlayerManagement     = true
Config_MusicRecord.EnableVaultManagement      = true
Config_MusicRecord.EnableSocietyOwnedVehicles = false
Config_MusicRecord.EnableHelicopters          = false
Config_MusicRecord.EnableMoneyWash            = false
Config_MusicRecord.MaxInService               = -1
Config_MusicRecord.Locale                     = 'fr'

Config_MusicRecord.Txt = {
	-- Cloakroom
	['cloakroom'] = 'Vestiaire',
	['citizen_wear'] = 'Dressing',
    ['open_cloackroom'] = 'Appuyez sur ~INPUT_CONTEXT~ pour vous changer',
	
	-- Boss Menu
	['deposit_society'] = 'Déposer argent',
	['withdraw_society'] = 'Retirer argent',
	['boss_actions'] = 'Action Patron',
	-- Misc
	['invalid_amount'] = '~r~Montant invalide',
	['open_menu'] = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu',
	['deposit_amount'] = 'Montant du dépôt',
	['money_withdraw'] = 'Montant du retrait',
 
    -- Vault  
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

Config_MusicRecord.CraftZones = {
    {x = -996.38, y = -66.54, z = -99.00-0.98},
    {x = -999.18, y = -60.45, z = -99.00-0.98},
}

Config_MusicRecord.Zones = {
    BossActions = {
        Pos   = { x = 395.09, y = -61.02, z = 107.16-0.98 },
        Size  = { x = 1.3, y = 1.3, z = 1.0 },
        Color = { r = 0, g = 100, b = 0 },
        Type  = 25,
    },
	
	Cloakrooms = {
		Pos = { x = -1014.04, y = -89.70, z = -99.40-0.98},
		Size = { x = 1.3, y = 1.3, z = 1.0 },
        Color = { r = 0, g = 255, b = 128 },
		Type = 25,
	},

    Vaults = {
        Pos   = { x = -1004.77, y = -63.69, z = -99.00-0.98 },
        Size  = { x = 1.3, y = 1.3, z = 1.0 },
        Color        = { r = 0, g = 255, b = 128 },
        Type  = 25,
	},	
}