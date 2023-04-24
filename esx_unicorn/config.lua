Config_esxFtext_esx_unicornnicorn                            = {}
Config_esxFtext_esx_unicornnicorn.DrawDistance = 15.0--               = 100.0

Config_esxFtext_esx_unicornnicorn.EnablePlayerManagement     = true
Config_esxFtext_esx_unicornnicorn.EnableSocietyOwnedVehicles = false
Config_esxFtext_esx_unicornnicorn.EnableVaultManagement      = true
Config_esxFtext_esx_unicornnicorn.EnableHelicopters          = false
Config_esxFtext_esx_unicornnicorn.EnableMoneyWash            = false
Config_esxFtext_esx_unicornnicorn.MaxInService               = -1
Config_esxFtext_esx_unicornnicorn.Locale                     = 'fr'

Config_esxFtext_esx_unicornnicorn.MissCraft                  = 10 -- %

Config_esxFtext_esx_unicornnicorn.Txt = {
    -- Cloakroom
    ['cloakroom']                = 'Vestiaire',
    ['citizen_wear']             = 'Tenue civile',
    ['barman_outfit']            = 'Tenue de serveur',
    ['dancer_outfit_1']          = 'Tenue de danse 1',
    ['dancer_outfit_2']          = 'Tenue de danse 2',
    ['dancer_outfit_3']          = 'Patronne event',
    ['dancer_outfit_4']          = 'Tenue de vigile',
    ['dancer_outfit_5']          = 'Tenue de danse 5',
    ['dancer_outfit_6']          = 'Tenue de danse 6',
    ['dancer_outfit_7']          = 'Tenue de danse 7',
    ['open_cloackroom']          = 'Appuyez sur ~INPUT_CONTEXT~ pour vous changer',

    -- Vault  
    ['get_weapon']               = 'Prendre Arme',
    ['put_weapon']               = 'Déposer Arme',
    ['get_weapon_menu']          = 'Coffre - Prendre Arme',
    ['put_weapon_menu']          = 'Coffre - Déposer Arme',
    ['get_object']               = 'Prendre Objet',
    ['put_object']               = 'Déposer Objet',
    ['vault']                    = 'Coffre',
    ['open_vault']               = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au coffre',

    -- Fridge  
    ['get_object']               = 'Prendre Objet',
    ['put_object']               = 'Déposer Objet',
    ['fridge']                   = 'Frigo',
    ['open_fridge']              = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au frigo',
    ['event_fridge_stock']     = 'Frigo',
    ['fridge_inventory']         = 'Contenu du frigo',

    -- Shops  
    ['shop']                     = 'Boutique',
    ['shop_menu']                = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder à la boutique.',
    ['bought']                   = 'Vous avez acheté ~b~1x ',
	['avalcol']                  = 'Boutique alcool',
	['salcol']                 	 = 'Boutique boisson sans alcool',
	['apero']                  	 = 'Boutique apéritifs',
    ['not_enough_money']         = 'Vous n\'avez ~r~pas assez~s~ d\'argent.',
    ['max_item']                 = 'Vous en portez déjà assez sur vous.',

    -- Vehicles  
    ['vehicle_menu']             = 'Véhicule',
    ['vehicle_out']              = 'Il y a déja un véhicule dehors',
    ['vehicle_spawner']          = 'Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule',
    ['store_vehicle']            = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule',
    ['service_max']              = 'Service complet : ',
    ['spawn_point_busy']         = 'Un véhicule occupe le point de sortie',

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
    ['event_stock']            = 'Stock',

    -- Billing Menu  
    ['billing']                  = 'Facture',
    ['no_players_nearby']        = 'Aucun joueur à proximité',
    ['billing_amount']           = 'Montant de la facture',
    ['amount_invalid']           = 'Montant invalide',

    -- Crafting Menu  
    ['crafting']                 = 'Mixologie',
    ['martini']                  = 'Martini blanc',
    ['icetea']                   = 'Ice Tea',
    ['drpepper']                 = 'Dr. Pepper',
    ['saucisson']                = 'Saucisson',
    ['raisin']             		 = 'Grappe de raisin',
    ['energy']                   = 'Energy Drink',
    ['jager']                    = 'Jägermeister',
    ['limonade']                 = 'Limonade',
    ['vodka']                    = 'Vodka',
    ['ice']                      = 'Glaçon',
    ['soda']                     = 'Soda',
    ['whisky']                   = 'Whisky',
    ['rhum']                     = 'Rhum',
    ['tequila']                  = 'Tequila',
    ['menthe']                   = 'Menthe',
    ['jusfruit']                 = 'Jus de fruits',
    ['jagerbomb']                = 'Jägerbomb',
    ['bolcacahuetes']            = 'Cacahuètes',
    ['bolnoixcajou']             = 'Noix de cajou',
    ['bolpistache']              = 'Pistaches',
    ['bolchips']                 = 'Chips',
    ['jagerbomb']                = 'Jägerbomb',
    ['golem']                    = 'Golem',
    ['whiskycoca']               = 'Whisky-coca',
    ['vodkaenergy']              = 'Vodka-energy',
    ['vodkafruit']               = 'Vodka-jus de fruits',
    ['rhumfruit']                = 'Rhum-jus de fruits',
    ['teqpaf']                   = 'Teq\'paf',
    ['rhumcoca']                 = 'Rhum-coca',
    ['mojito']                   = 'Mojito',
    ['mixapero']                 = 'Mix Apéro',
    ['metreshooter']             = 'Mètre de shooter',
    ['jagercerbere']             = 'Jäger Cerbère',
	['ephedrink']             = 'ephedrink',
    ['assembling_cocktail']      = 'Mélange des différents ingrédients en cours !',
    ['craft_miss']               = 'Malheureux échec du mélange...',
    ['not_enough']               = 'Pas assez de ~r~ ',
    ['craft']                    = 'Mélange terminé de ~g~',

    -- Misc  
    ['map_blip']                 = 'Vanilla Unicorn',
    ['event']                  = 'Vanilla Unicorn',

    -- Phone  
    ['event_phone']            = 'event',
    ['event_customer']         = 'Citoyen',

    -- Teleporters
    ['e_to_enter_1']             = 'Appuyez sur ~INPUT_PICKUP~ pour passer derrière le bar',
    ['e_to_enter_3']             = 'Appuyez sur ~INPUT_PICKUP~ pour entrer',
    ['e_to_exit_1']              = 'Appuyez sur ~INPUT_PICKUP~ pour passer devant le bar.',
    ['e_to_enter_2']             = 'Appuyez sur ~INPUT_PICKUP~ pour monter sur le toit.',
    ['e_to_exit_2']              = 'Appuyez sur ~INPUT_PICKUP~ pour descendre dans les bureaux.',
    ['e_to_exit_3']              = 'Appuyez sur ~INPUT_PICKUP~ pour sortir',
}

function Ftext_esx_unicorn(txt)
	return Config_esxFtext_esx_unicornnicorn.Txt[txt]
end

Config_esxFtext_esx_unicornnicorn.Blips = {
    
    Blip = {
      Pos     = { x = 129.246, y = -1299.363, z = 29.501 },
      Sprite  = 121,
      Display = 4,
      Scale   = 0.6,
      Colour  = 27,
    },
}

Config_esxFtext_esx_unicornnicorn.Zones = {

    Cloakrooms = {
        Pos   = { x = 105.11, y = -1303.18, z = 28.76-0.98 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 255, g = 187, b = 255 },
        Type  = 25,
    },

    Vaults = {
        Pos   = { x = 93.46, y = -1291.81, z = 29.26-0.98 },
        Size  = { x = 1.3, y = 1.3, z = 1.0 },
        Color = { r = 30, g = 144, b = 255 },
        Type  = 25,
    },

    Fridge = {
        Pos   = { x = 128.96, y = -1280.30, z = 29.26-0.98 },
        Size  = { x = 1.6, y = 1.6, z = 1.0 },
        Color = { r = 248, g = 248, b = 255 },
        Type  = 25,
    },
	
	Fridge2 = {
        Pos   = { x = -3023.53, y = 37.65, z = 10.11-0.98 },
        Size  = { x = 1.6, y = 1.6, z = 1.0 },
        Color = { r = 248, g = 248, b = 255 },
        Type  = 25,
    },

    BossActions = {
        Pos   = { x = 95.38, y = -1294.13, z = 29.26-0.98 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 100, b = 0 },
        Type  = 25,
    },
    -----------------------
    -------- SHOPS --------
    Shops = {
        Pos   = { x = 130.19, y = -1282.53, z = 28.26 },
        Size  = { x = 1.6, y = 1.6, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Type  = 25,

    },
}

Config_esxFtext_esx_unicornnicorn.Farm = {
    Pos     = { x = -82.90, y = 6497.60, z = 31.49-0.98 },
    Sprite  = 499,
    Display = 4,
    Scale   = 0.6,
    Colour  = 5,
}
  
Config_esxFtext_esx_unicornnicorn.Trait = {
    Pos     = { x = 2906.65, y = 4346.41, z = 50.29-0.98 },
    Sprite  = 499,
    Display = 4,
    Scale   = 0.6,
    Colour  = 5,
}
  
Config_esxFtext_esx_unicornnicorn.Sell = {
    Pos     = { x = -394.24,y = 208.49,z = 83.15-0.98 },
    Sprite  = 499,
    Display = 4,
    Scale   = 0.6,
    Colour  = 5,
}

Config_esxFtext_esx_unicornnicorn.Shop = {
    Pos     = { x = 129.76, y = -1284.62, z = 29.26-0.98 },
    Sprite  = 499,
    Display = 4,
    Scale   = 0.6,
    Colour  = 5,
}

Config_esxFtext_esx_unicornnicorn.Weed = {
    Pos     = { x = 161.64, y = -1306.95, z = 29.35 }, 
    Sprite  = 496,
    Display = 4,
    Scale   = 0.6,
    Colour  = 25,
}