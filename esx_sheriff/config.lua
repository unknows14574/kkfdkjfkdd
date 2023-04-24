Config_esx_sheriff                            = {}
Config_esx_sheriff.DrawDistance = 15.0--               = 100.0
Config_esx_sheriff.MarkerType                 = 0
Config_esx_sheriff.MarkerSize                 = { x = 1.3, y = 1.3, z = 3.0 }
Config_esx_sheriff.MarkerSizeDel              = { x = 5.0, y = 5.0, z = 3.0 }
Config_esx_sheriff.MarkerColor                = { r = 0, g = 0, b = 0 }
Config_esx_sheriff.MarkerColorDel             = { r = 0, g = 0, b = 0 }
Config_esx_sheriff.EnablePlayerManagement     = true
Config_esx_sheriff.EnableArmoryManagement     = true
Config_esx_sheriff.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config_esx_sheriff.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config_esx_sheriff.EnableSocietyOwnedVehicles = false
Config_esx_sheriff.EnableLicenses             = true
Config_esx_sheriff.MaxInService               = -1

Config_esx_sheriff.Txt = {
  -- Cloakroom
  ['cloakroom'] = 'vestiaire',
  ['citizen_wear'] = 'tenue Civil',
  ['open_cloackroom'] = 'Appuyez sur ~INPUT_PICKUP~ pour vous changer',
  -- Armory
  ['get_weapon'] = 'prendre Arme',
  ['put_weapon'] = 'déposer Arme',
  ['buy_weapons'] = 'acheter Armes',
  ['armory'] = 'armurerie',
  ['open_armory'] = 'Appuyez sur ~INPUT_PICKUP~ pour accéder à l\'armurerie',
  -- Vehicles
  ['vehicle_menu'] = 'véhicule',
  ['vehicle_out'] = 'il y a déja un véhicule de sorti',
  ['vehicle_spawner'] = 'Appuyez sur ~INPUT_PICKUP~ pour sortir un véhicule',
  ['store_vehicle'] = 'Appuyez sur ~INPUT_PICKUP~ pour ranger le véhicule',
  ['service_max'] = 'Service complet : ',
  -- Action Menu
  ['citizen_interaction'] = 'interaction citoyen',
  ['vehicle_interaction'] = 'interaction véhicule',
  ['object_spawner'] = 'placer objets',

  ['id_card'] = 'carte d\'identité',
  ['search'] = 'fouiller',
  ['handcuff'] = 'Menotter / Démenotter',
  ['drag'] = 'escorter',
  ['put_in_vehicle'] = 'mettre dans véhicule',
  ['out_the_vehicle'] = 'sortir du véhicule',
  ['fine'] = 'Amende', 
  ['del_vehicle'] = 'Mettre véhicule en fourrière',
  ['vehicle_impounded']         = 'Vehicule ~r~mis en fourrière',
  ['must_seat_driver']          = 'Vous devez être assis du ~r~côté conducteur!',
  ['no_players_nearby'] = 'Aucun joueur à proximité',

  ['vehicle_info'] = 'infos véhicule',
  ['pick_lock'] = 'crocheter véhicule',
  ['vehicleFtext_esx_sheriffnlocked'] = 'véhicule ~g~déverouillé~s~',
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
  ['ownerFtext_esx_sheriffnknown'] = 'propriétaire : Inconnu',
  ['owner'] = 'propriétaire : ',
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
  ['open_bossmenu'] = 'Appuyez sur ~INPUT_PICKUP~ pour ouvrir le menu',
  ['quantity_invalid'] = 'Quantité invalide',
  ['have_withdrawn'] = 'Vous avez retiré x',
  ['added'] = 'Vous avez ajouté x',
  ['quantity'] = 'Quantité',
  ['inventory'] = 'inventaire',
  ['sheriff_stock'] = 'Sheriff Stock',
  -- Misc
  ['remove_object'] = 'Appuyez sur ~INPUT_PICKUP~ pour enlever l\'objet',
  ['map_blip'] = 'Sheriff',
  -- Notifications
  ['from'] = '~s~ à ~b~',
  ['you_have_confinv'] = 'vous avez confisqué ~y~x', 
  ['confinv'] = '~s~ vous a confisqué ~y~x',
  ['you_have_confdm'] = 'vous avez confisqué ~y~$',
  ['confdm'] = '~s~ vous a confisqué ~y~$',
  ['you_have_confweapon'] = 'vous avez confisqué ~y~x1 ',
  ['confweapon'] = '~s~ vous a confisqué ~y~x1 ',
  ['alert_sheriff'] = 'alerte sheriff',
  -- Authorized Vehicles
  ['policeb'] = 'moto',
  ['policet'] = 'van de transport',

  --permis
  ['codedmv'] = 'Retirer le code de la route',
  ['codedrive'] = 'Retirer le permis de voiture',
  ['codedrivebike'] = 'Retirer le permis de moto',
  ['codedrivetruck'] = 'Retirer le permis de camion',
  ['weaponlicense'] = "Retirer le permis d'armes",
  ['dmv'] = 'code de la route',
  ['drive'] = 'permis voiture',
  ['drive_bike'] = 'permis moto',
  ['drive_truck'] = 'permis camion',
  ['weapon'] = "permis d'arme",
}
function Ftext_esx_sheriff(txt)
	return Config_esx_sheriff.Txt[txt]
end

Config_esx_sheriff.BCSStations = {

  BCS = {

    Blip = {
      Pos     = {x = 1838.17,y = 3678.91,z = 34.19 },
      Sprite  = 468, --526
      Display = 4,
      Scale   = 1.2,
      Colour  = 28,
    },

    AuthorizedWeapons = {
      { name = 'weapon_flashlight', label = 'Lampe torche', price = 150 },
      { name = 'weapon_nightstick', label = 'Matraque', price = 250 },
      { name = 'weapon_stungun', label = 'Tazer', price = 400 },
      { name = 'weapon_combatpistol', label = 'Pistolet de combat', price = 3250 },
      { name = 'weapon_pistol_mk2', label = 'Glock .20', price = 6000 },
      { name = 'weapon_heavypistol', label = 'Pistolet lourd', price = 5000 },
      { name = 'weapon_revolver', label = 'Revolver', price = 8000 },
      { name = 'weapon_pumpshotgun', label = 'Fusil à pompe', price = 22500 },
	    { name = 'weapon_pumpshotgun_mk2',label = 'Fusil à pompe lourd', price = 24000 },
      { name = 'weapon_bullpupshotgun',label = 'Fusil à pompe Bullup', price = 24000 },
      { name = 'weapon_combatpdw', label = 'Mitraillette de defense personnelle', price = 27500 },
	    { name = 'weapon_smg', label = 'MP5', price = 29000 },
      { name = 'weapon_assaultsmg',label = 'MP5 d\'assault', price = 29500 },
      { name = 'weapon_carbinerifle',label = 'Fusil d\'assault M4', price = 30000 },
	    { name = 'weapon_carbinerifle_mk2',label = 'Fusil d\'assault MK2', price = 41000 },
      { name = 'weapon_specialcarbine_mk2', label = 'Fusil d\'assaut G36C amélioré', price = 47000 },
	    { name = 'weapon_advancedrifle', label = 'Fusil d\'assault Tar .21', price = 34000 },
	    { name = 'weapon_bullpuprifle',label = 'Fusil d\'assault Bullup', price = 35000 },
	    { name = 'weapon_sniperrifle',label = 'Fusil sniper', price = 46000 },
	    { name = 'weapon_heavysniper',label = 'Fusil sniper lourd', price = 47500 },
	    { name = 'weapon_marksmanrifle',label = 'Fusil de précision Marksman', price = 49000 },
	    { name = 'weapon_musket',label = 'Fusil à verrou Mousquet', price = 25000 },
      { name = 'weapon_fireextinguisher',label = 'Extincteur',  price = 500 },
      { name = 'weapon_flaregun',label = 'Pistolet fusée de detresse', price = 1500 },
      { name = 'gadget_parachute', label = 'Parachute', price = 2000 },
      { name = 'weapon_case', label = 'Caisse d\'arme', price = 15000 },
      { name = 'storage_case', label = 'Caisse de stockage', price = 10000 },
  	  { name = 'clip', label = 'Chargeur d\'arme', price = 200 },
      { name = 'radio', label = 'Radio', price = 500 }
    },

    AuthorizedVehicles = {
      {name = 'police4', label = 'Voiture Banalisée'},
      {name = 'fbi2', label = 'Suv FIB'},
      {name = 'fbi', label = 'Buffalo FIB'},  
      {name = 'jackal2', label = 'Jackal Banalisée'},  
	    {name = 'police44', label = 'Dodge Charger Banalisée'}, 
      {name = 'adder2', label = 'Adder Banalisée'},   
    },
	
	AuthorizedVehicles1 = {
	  {name = 'maverick2' , label = 'Hélico'}
	},

  Cloakrooms = {
		{x = 1841.5, y = 3680.57, z = 34.19-0.98 }, --Sandy Shore
	    {x = 360.72,y = -1593.07,z = 25.45-0.98 }, --sud
  },

  IdentityCheck = {
    { x = 480.53, y = -1012.17, z = 34.22-0.98 }, -- PDP LSPD
    { x = 1818.58, y = 3666.43, z = 34.19-0.98 }, -- Sandy Shore
    { x = 368.34, y = -1592.21, z = 25.45-0.98 } -- POSTE SHERIFF SUD
  },

    Armories = {
		{x = 1838.43, y = 3686.21, z = 34.19-0.98 }, --Sandy Shore
		{x = 364.41,y = -1603.87,z = 25.45-0.98 }, --sud
    },
	

	HelicoPaleto = {
	  {
      Spawner1    = {x = 1853.04, y = 3706.28, z = 33.97-0.98 },  -- Sandy Shore
      SpawnPoint1 =  {x = 1853.04, y = 3706.28, z = 33.97-0.98 }, 
      Heading1   = 26.77
	  },
	  {
      Spawner1    = {x = 368.3 ,y = -1597.06 ,z = 43.76-0.98 }, --sud
      SpawnPoint1 =  {x = 368.3 ,y = -1597.06 ,z = 43.76-0.98 },
      Heading1   = 33.02
	  }
	},

    BossActions = {
      {x = 1825.36, y = 3672.97, z = 38.86-0.98 }, --Sandy Shore
      {x = 359.68, y = -1589.40,z = 31.05-0.98 }, --sud
    },
  },
}