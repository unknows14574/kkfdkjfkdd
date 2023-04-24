Config_esx_avocat                            = {}
Config_esx_avocat.DrawDistance = 15.0--               = 25.0
Config_esx_avocat.MarkerType                 = 25
Config_esx_avocat.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config_esx_avocat.MarkerColor                = { r = 255, g = 255, b = 0 }
Config_esx_avocat.EnablePlayerManagement     = true
Config_esx_avocat.EnableArmoryManagement     = true
Config_esx_avocat.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config_esx_avocat.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config_esx_avocat.EnableSocietyOwnedVehicles = false
Config_esx_avocat.EnableLicenses             = true
Config_esx_avocat.MaxInService               = -1

Config_esx_avocat.Txt = {
  -- Cloakroom
  U_cloakroom = 'vestiaire',
  U_citizen_wear = 'tenue Civil',
  U_avocat_wear = 'tenue d\'avocat',
  U_open_cloackroom = 'Appuyez sur ~INPUT_CONTEXT~ pour vous changer',
  -- Armory
  U_get_weapon = 'prendre Arme',
  U_put_weapon = 'déposer Arme',
  U_buy_weapons = 'acheter Armes',
  U_armory = 'armurerie',
  U_open_armory = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder à l\'armurerie',
  U_open_cloth = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au dressing',
  -- Vehicles
  U_vehicle_menu = 'véhicule',
  U_vehicle_out = 'il y a déja un véhicule de sorti',
  U_vehicle_spawner = 'Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule',
  U_store_vehicle = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule',
  U_service_max = 'Service complet : ',
  -- Action Menu
  U_citizen_interaction = 'interaction citoyen',

  U_id_card = 'carte d\'identité',
  U_persofine = 'Facture',
  U_no_players_nearby = 'aucun joueur à proximité',


  -- ID Card Menu
  U_name = 'nom : ',
  -- Body Search Menu
  U_payment = 'paiment : ',
  U_persofine = 'Paiement diverse',

  -- Weapons Menus
  U_get_weapon_menu = 'armurerie - Prendre Arme',
  U_put_weapon_menu = 'armurerie - Déposer Arme',
  U_buy_weapon_menu = 'armurerie - Acheter Armes',
  U_not_enough_money = 'vous n\'avez pas assez d\'argent',
  -- Boss Menu
  U_take_company_money = 'retirer argent société',
  U_deposit_money = 'déposer argent',
  U_amount_of_withdrawal = 'montant du retrait',
  U_invalid_amount = 'montant invalide',
  U_amount_of_deposit = 'montant du dépôt',
  U_open_bossmenu = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu',
  U_quantity_invalid = 'Quantité invalide',
  U_have_withdrawn = 'Vous avez retiré x',
  U_added = 'Vous avez ajouté x',
  U_quantity = 'Quantité',
  U_inventory = 'inventaire',
  U_police_stock = 'Police Stock',
  -- Misc
  U_map_blip = 'Cabinet Harris',
  -- Notifications
  U_from = '~s~ à ~b~',
  U_you_have_confdm = 'vous avez confisqué ~y~$',
  U_alert_avocat = 'alerte avocat',
  -- Authorized Vehicles
  U_police = 'véhicule de patrouille 1',
  U_police2 = 'véhicule de patrouille 2',
  U_police3 = 'véhicule de patrouille 3',
  U_police4 = 'véhicule civil',
  U_policeb = 'moto',
  U_policet = 'van de transport',
}


Config_esx_avocat.AvocatStations = {

  AVOCAT = {

    Blip = {
      Pos     = { x = -141.1987, y = -620.913, z = 168.8205 },
      Sprite  = 269,
      Display = 4,
      Scale   = 0.4,
      Colour  = 3,
	    Name = "Cabinet Harris",
    },

    ClothRoom = {
      { x = -132.50, y = -632.90, z = 168.82-0.98 },
    },

    Armories = {
      { x = -150.10, y = -634.46, z = 168.82-0.98 },
      { x = -128.87, y = -638.64, z = 168.82-0.98 },
    },

    BossActions = {
      { x = -123.91, y = -641.37, z = 168.82-0.98 }
    },

  },

}
