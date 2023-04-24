Config_esx_policejob                            = {}
Config_esx_policejob.DrawDistance = 15.0--               = 100.0
Config_esx_policejob.MarkerType                 = 0
Config_esx_policejob.MarkerSize                 = { x = 2.5, y = 2.5, z = 2.5 }
Config_esx_policejob.MarkerColor                = { r = 50, g = 50, b = 204 }
Config_esx_policejob.EnablePlayerManagement     = true
Config_esx_policejob.EnableArmoryManagement     = true
Config_esx_policejob.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config_esx_policejob.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config_esx_policejob.EnableSocietyOwnedVehicles = false
Config_esx_policejob.EnableLicenses             = true
Config_esx_policejob.MaxInService               = -1

Config_esx_policejob.Txt = {
  -- Cloakroom
  ['cloakroom'] = 'vestiaire',
  ['citizen_wear'] = 'Tenue Civil',
  ['police_wear'] = 'Tenue Policier',
  ['lieutenant_wear'] = 'Tenue Lieutenant ',
  ['commandant_wear'] = 'Tenue Commandant',
  ['specops_wear'] = 'Tenu SWAT',
  ['bullet_wear'] = 'Gilet Pare-balles',
  ['open_cloackroom'] = 'Appuyez sur ~INPUT_CONTEXT~ pour vous changer',
  -- Armory
  ['get_weapon'] =  'Prendre Arme',
  ['put_weapon'] =  'Déposer Arme',
  ['buy_weapons'] = 'acheter Armes',
  ['armory'] = 'armurerie',
  ['open_armory'] = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder à l\'armurerie',
  -- Vehicles
  ['vehicle_menu'] = 'véhicule',
  ['vehicle_out'] = 'il y a déja un véhicule de sorti',
  ['vehicle_spawner'] = 'Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule',
  ['store_vehicle'] = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule',
  ['service_max'] = 'Service complet : ',
  -- Action Menu
  ['citizen_interaction'] = 'Interaction citoyen',
  ['vehicle_interaction'] = 'Interaction véhicule',
  ['object_spawner'] = 'Placer objets',

  ['id_card'] = 'Carte d\'identité',
  ['search'] = 'Fouiller',
  ['handcuff'] = 'Menotter / Démenotter',
  ['drag'] = 'Escorter',
  ['put_in_vehicle'] = 'Mettre dans véhicule',
  ['out_the_vehicle'] = 'Sortir du véhicule',
  ['fine'] = 'Amende',
  ['del_vehicle'] = 'Mettre véhicule en fourrière',
  ['vehicle_impounded']         = 'vehicule ~r~mis en fourrière',
  ['must_seat_driver']          = 'vous devez être assis du ~r~côté conducteur!',
  ['no_players_nearby'] = 'Aucun joueur à proximité',

  ['vehicle_info'] = 'Infos véhicule',
  ['pick_lock'] = 'Crocheter véhicule',
  ['vehicleFtext_esx_policejobnlocked'] = 'véhicule ~g~déverouillé~s~',
  ['no_vehicles_nearby'] = 'aucun véhicule à proximité',
  ['traffic_interaction'] = 'Interaction Voirie',
  ['cone'] = 'plot',
  ['barrier'] = 'barrière',
  ['spikestrips'] = 'herse',
  ['box'] = 'caisse',
  ['cash'] = 'caisse',
  -- ID Card Menu
  ['name'] = 'nom : ',
  ['bac'] = 'alcoolémie : ',
  ['duc'] = 'drogue : ',
  -- Body Search Menu
  ['confiscate_dirty'] = 'confisquer argent sale : $',
  ['guns_label'] = '--- Armes ---',
  ['confiscate'] = 'confisquer ',
  ['inventory_label'] = '--- Inventaire ---',
  ['confiscate_inv'] = 'confisquer x',

  ['traffic_offense'] = 'code de la route',
  ['minor_offense'] = 'délit mineur',
  ['average_offense'] = 'délit moyen',
  ['major_offense'] = 'délit grave',
  ['fine_total'] = 'amende : ',
  -- Vehicle Info Menu
  ['plate'] = 'N°: ',
  ['ownerFtext_esx_policejobnknown'] = 'propriétaire : Inconnu',
  ['owner'] = 'propriétaire : ',
  ['assured'] = 'assurance : ',
  -- Weapons Menus
  ['get_weapon_menu'] = 'Armurerie - Prendre Arme',
  ['put_weapon_menu'] = 'Armurerie - Déposer Arme',
  ['buy_weapon_menu'] = 'Armurerie - Acheter Armes',
  ['not_enough_money'] = 'vous n\'avez pas assez d\'argent',
  -- Boss Menu
  ['take_company_money'] = 'retirer argent société',
  ['deposit_money'] = 'déposer argent',
  ['amount_of_withdrawal'] = 'montant du retrait',
  ['invalid_amount'] = 'montant invalide',
  ['amount_of_deposit'] = 'montant du dépôt',
  ['open_bossmenu'] = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu',
  ['quantity_invalid'] = 'Quantité invalide',
  ['have_withdrawn'] = 'Vous avez retiré x',
  ['added'] = 'Vous avez ajouté x',
  ['quantity'] = 'Quantité',
  ['inventory'] = 'inventaire',
  ['police_stock'] = 'Police Stock',
  -- Misc
  ['remove_object'] = 'Appuyez sur ~INPUT_CONTEXT~ pour enlever l\'objet',
  ['map_blip'] = 'Poste de police',
  ['map_blip_fib'] = 'Bureaux du FIB',
  -- Notifications
  ['from'] = '~s~ à ~b~',
  ['you_have_confinv'] = 'vous avez confisqué ~y~x',
  ['confinv'] = '~s~ vous a confisqué ~y~x',
  ['you_have_confdm'] = 'vous avez confisqué ~y~$',
  ['confdm'] = '~s~ vous a confisqué ~y~$',
  ['you_have_confweapon'] = 'vous avez confisqué ~y~x1 ',
  ['confweapon'] = '~s~ vous a confisqué ~y~x1 ',
  ['alert_police'] = 'alerte police',
  -- Authorized Vehicles
  ['police'] = 'véhicule de patrouille 1',
  ['police2'] = 'véhicule de patrouille 2',
  ['police3'] = 'véhicule de patrouille 3',
  ['police4'] = 'véhicule civil',
  ['policeb'] = 'moto',
  ['policet'] = 'van de transport',
}
function Ftext_esx_policejob(txt)
	return Config_esx_policejob.Txt[txt]
end

Config_esx_policejob.PoliceStations = {

 LSPD = {

    Blip = {
      Pos     = { x = -587.15, y = -123.39, z = 39.61 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.0,
      Colour  = 29,
    },

    BlipFib = {
      Pos     = { x = 127.38, y = -729.19, z = 242.14 },
      Sprite  = 86,
      Display = 4,
      Scale   = 0.5,
      Colour  = 26,
    },

    AuthorizedWeapons = {
	    { name = 'weapon_flashlight', label = 'Lampe torche', price = 300 },
      { name = 'weapon_nightstick', label = 'Matraque', price = 500 },
      { name = 'weapon_stungun', label = 'Tazer', price = 2500 },
      { name = 'weapon_combatpistol', label = 'Pistolet de combat', price = 5000 },
      { name = 'weapon_heavypistol', label = 'Pistolet lourd', price = 15000 },

      { name = 'weapon_revolver', label = 'Revolver', price = 20000 },
	    { name = 'weapon_pumpshotgun', label = 'Fusil à pompe', price = 22000 },
      { name = 'weapon_bullpupshotgun', label = 'Fusil à pompe Bullup', price = 25000 },

      { name = 'weapon_combatpdw', label = 'Mitraillette de defense personnelle', price = 27000 },
	    { name = 'weapon_smg', label = 'MP5', price = 30000 },
      { name = 'weapon_assaultsmg', label = 'MP5 d\'assault', price = 35000 },
	    { name = 'weapon_carbinerifle', label = 'Fusil d\'assault M4', price = 40000 },
	    { name = 'weapon_advancedrifle', label = 'Fusil d\'assault Tar .21', price = 45000 },
	    { name = 'weapon_bullpuprifle', label = 'Fusil d\'assault Bullup', price = 50000 },

	    { name = 'weapon_sniperrifle', label = 'Fusil sniper', price = 100000 },
	    { name = 'weapon_heavysniper', label = 'Fusil sniper lourd', price = 110000 },
	    { name = 'weapon_marksmanrifle', label = 'Fusil de précision Marksman', price = 120000 },
      { name = 'weapon_fireextinguisher', label = 'Extincteur',  price = 500 },
      { name = 'weapon_flaregun', label = 'Pistolet fusée de detresse', price = 1500 },
	  
      { name = 'weapon_pistol_mk2', label = 'Glock .20', price = 6000 },
      { name = 'weapon_pumpshotgun_mk2', label = 'Fusil à pompe lourd', price = 24000 },
      { name = 'weapon_carbinerifle_mk2', label = 'Fusil d\'assault MK2', price = 41000 },
      { name = 'weapon_specialcarbine_mk2', label = 'Fusil d\'assaut G36C amélioré', price = 47000 },

      { name = 'weapon_case', label = 'Caisse d\'arme', price = 15000 },
      { name = 'storage_case', label = 'Caisse de stockage', price = 10000 },
      { name = 'clip', label = 'Chargeur d\'arme', price = 200 },
      { name = 'radio', label = 'Radio', price = 500 },
    },
	
    AuthorizedVehicles = {
      { name = 'police',  label = 'Véhicule de patrouille 1' },
      { name = 'police2', label = 'Véhicule de patrouille 2' },
      { name = 'police3', label = 'Véhicule de patrouille 3' },
      { name = 'police4', label = 'Véhicule civil' },
      { name = 'policeb', label = 'Moto' },
      { name = 'policet', label = 'Van de transport' },
    },

  Cloakrooms = {
    { x = -548.50, y = -132.04, z = 38.79-0.98 },
    { x = -563.05, y = -117.25, z = 42.25-0.98 },
    { x = -555.74, y = -108.72, z = 50.37-0.98 },
    { x = 452.02, y = -993.26, z = 30.68-0.98 } -- Mission ROW Mapping base
  },

  Billing = {
    { x = -549.60, y = -110.814, z = 42.25-0.98 },
  },

  IdentityCheck = {
    { x = -555.83, y = -132.089, z = 33.75-0.98 }, -- PDP LSPD
    { x = -441.13, y = 6004.54, z = 31.71-0.98 }, -- POSTE PALETO
    { x = 361.16, y = -1597.65, z = 29.29-0.98 } -- POSTE SHERIFF SUD
  },

  Armories = {
    { x = -548.96, y = -118.51, z = 37.85-0.98, job = 'police' },
    { x = -552.50, y = -118.80, z = 33.75-0.98, job = 'police' },
    { x = 127.38, y = -729.19, z = 242.14-0.98, job = 'fib' },
  },

  Helicopters = {
    {
      Spawner    = { x = -548.36, y = -114.71, z = 51.98-0.95},
      SpawnPoint = { x = -546.94, y = -122.099, z = 51.98-0.95 },
      Heading    = 202.67805,
    }
  },

  VehicleDeleters = {
    { x = -546.94, y = -122.09, z = 51.98-0.10 }, -- Helicopter Deleter MissionRow 
  },

  BossActions = {
    { x = -577.64, y = -129.11, z = 47.51-0.98 }, -- Mission Row
  },
	
  },
}