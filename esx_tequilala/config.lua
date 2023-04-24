Config_esx_tequilala                            = {}
Config_esx_tequilala.DrawDistance = 15.0--               = 100.0

Config_esx_tequilala.EnablePlayerManagement     = true
Config_esx_tequilala.EnableSocietyOwnedVehicles = false
Config_esx_tequilala.EnableVaultManagement      = true
Config_esx_tequilala.EnableHelicopters          = false
Config_esx_tequilala.EnableMoneyWash            = false
Config_esx_tequilala.MaxInService               = -1
Config_esx_tequilala.Locale                     = 'fr'

Config_esx_tequilala.MissCraft                  = 10 -- %

Config_esx_tequilala.Txt = {
    -- Cloakroom
    ['cloakroom']                = 'Vestiaire',
    ['citizen_wear']             = 'Tenue civile',
    ['barman_outfit']            = 'Tenue de barman',
    ['dancer_outfit_1']          = 'Tenue de danse 1',
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
    ['billing']                  = 'Facture Tequi-La-La',
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
    ['map_blip']                 = 'Tequi-La-La',
    ['event']                  = 'Tequi-La-La',

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

function Ftext_esx_tequilala(txt)
	return Config_esx_tequilala.Txt[txt]
end


Config_esx_tequilala.AuthorizedVehicles = {
    
    { name = 'mule2',  label = 'Farming' },
  { name = 'pbus2',  label = 'Bus Disco' },
	{ name = 'moonbeam2',  label = 'Van moonbeam' },
    
}

Config_esx_tequilala.Blips = {
    
    Blip = {
      Pos     = { x = -565.38, y = 273.92, z = 83.01 },
      Sprite  = 93,
      Display = 4,
      Scale   = 0.7,
      Colour  = 5,
    },

}

Config_esx_tequilala.Zones = {

    Cloakrooms = {
       Pos   = { x = -568.60, y = 279.98, z = 82.97-0.98 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 255, g = 187, b = 255 },
        Type  = 25,
    },

    Vaults = {
        Pos   = { x = -549.85, y = 289.86, z = 82.17-0.98 },
        Size  = { x = 1.3, y = 1.3, z = 1.0 },
        Color = { r = 30, g = 144, b = 255 },
        Type  = 25,
    },

    Fridge = {
        Pos   = { x = -561.67, y = 289.80, z = 81.17},
        Size  = { x = 1.6, y = 1.6, z = 1.0 },
        Color = { r = 248, g = 248, b = 255 },
        Type  = 25,
    },
	
	Fridge2 = {
        Pos   = { x = -565.62, y = 284.88, z = 85.37-0.98 },
        Size  = { x = 1.6, y = 1.6, z = 1.0 },
        Color = { r = 248, g = 248, b = 255 },
        Type  = 25,
    },

    BossActions = {
        Pos   = { x = -563.33, y = 279.38, z = 82.97-0.98 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 100, b = 0 },
        Type  = 25,
    },

-----------------------
-------- SHOPS --------

    Shops = {
        Pos   = { x = -561.81, y = 286.10, z = 81.17},
        Size  = { x = 1.6, y = 1.6, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Type  = 25,
        Sprite  = 93,
      Display = 4,
      Scale   = 0.6,
      Colour  = 6,

    },
}


-----------------------
----- TELEPORTERS -----

Config_esx_tequilala.TeleportZones = {
    EnterBuilding = {
        Pos       = { x = -563.21, y = 287.72, z = 85.37-0.98 },
        Size      = { x = 1.2, y = 1.2, z = 0.1 },
        Color     = { r = 128, g = 128, b = 128 },
        Marker    = 1,
        Hint      = Ftext_esx_tequilala('e_to_enter_1'),
        Teleport  = { x = -564.96, y = 287.52, z = 85.37-0.98 }
      },
    
      ExitBuilding = {
        Pos       = { x = -564.96, y = 287.52, z = 85.37-0.98 },
        Size      = { x = 1.2, y = 1.2, z = 0.1 },
        Color     = { r = 128, g = 128, b = 128 },
        Marker    = 1,
        Hint      = Ftext_esx_tequilala('e_to_exit_1'),
        Teleport  = { x = -563.21, y = 287.72, z = 85.37-0.98 },
      },
}

