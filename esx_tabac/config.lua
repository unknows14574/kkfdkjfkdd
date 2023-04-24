Config_esx_tabac                            = {}
Config_esx_tabac.DrawDistance = 15.0--               = 100.0

Config_esx_tabac.EnablePlayerManagement     = true
Config_esx_tabac.EnableSocietyOwnedVehicles = false
Config_esx_tabac.EnableVaultManagement      = true
Config_esx_tabac.EnableHelicopters          = false
Config_esx_tabac.EnableMoneyWash            = false
Config_esx_tabac.MaxInService               = -1
Config_esx_tabac.Locale                     = 'fr'

Config_esx_tabac.Txt = {
    -- Cloakroom
    ['cloakroom']                = 'Vestiaire',
    ['citizen_wear']             = 'Tenue civile',
    ['barman_outfit']            = 'Tenue de barman',
    ['dancer_outfit_1']          = 'Tenue de danse 1',
    ['dancer_outfit_2']          = 'Tenue de danse 2',
    ['dancer_outfit_3']          = 'Patronne event',
    ['dancer_outfit_4']          = 'Vigile',
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
    ['fridge']                   = 'Stock',
    ['open_fridge']              = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au stock',
    ['tabac_fridge_stock']     = 'Stock',
    ['fridge_inventory']         = 'Contenu des stocks',

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
    ['tabac_stock']            = 'Stock',

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
    ['map_blip']                 = 'Natural Tobacco Industry',
    ['tabac']                  = 'Natural Tobacco Industry',

    -- Phone  
    ['tabac_phone']            = 'tabac',
    ['tabac_customer']         = 'Citoyen',
}

function Ftext_esx_tabac(txt)
	return Config_esx_tabac.Txt[txt]
end

Config_esx_tabac.MissCraft                  = 10 -- %

Config_esx_tabac.Blips = {
    
    Blip = {
      Pos     = {x = -45.12, y = -1060.23, z = 27.61},
      Sprite  = 59,
      Display = 4,
      Scale   = 0.6,
      Colour  = 0,
    },
}

Config_esx_tabac.Zones = {
    Cloakrooms = {
        Pos   = { x = -36.50, y = -1061.40, z = 27.60-0.60 },
        Size  = { x = 0.3, y = 0.3, z = 0.3 },
        Color = { r = 255, g = 187, b = 255 },
        Type  = 0,
    },
    Vestiaire = {
      Pos   = { x = -34.97, y = -1070.55, z = 27.60-0.60 },
      Size  = { x = 0.3, y = 0.3, z = 0.3 },
      Color = { r = 255, g = 187, b = 255 },
      Type  = 0,
    },
}

Config_esx_tabac.Farm = {
    Pos     = { x = -57.28, y = 6523.70, z = 31.49-0.98 },
    Sprite  = 443,
    Display = 4,
    Scale   = 0.6,
    Colour  = 5,
  }
  
  Config_esx_tabac.Trait = {
    Pos     = { x = 2906.65, y = 4346.41, z = 50.29-0.98 },
    Sprite  = 443,
    Display = 4,
    Scale   = 0.6,
    Colour  = 5,
  }
  
  Config_esx_tabac.Sell = {
    Pos     = { x = -394.24,y = 208.49,z = 83.15-0.98 },
    Sprite  = 443,
    Display = 4,
    Scale   = 0.6,
    Colour  = 5,
  }

  Config_esx_tabac.Shop = {
    Pos     = { x = -61.22, y = 6527.90, z = 31.49-0.98 },
    Sprite  = 443,
    Display = 4,
    Scale   = 0.6,
    Colour  = 5,
  }

  Config_esx_tabac.Weed = {
    Pos     = { x = 161.64, y = -1306.95, z = 29.35 }, 
    Sprite  = 443,
    Display = 4,
    Scale   = 0.6,
    Colour  = 25,
  }