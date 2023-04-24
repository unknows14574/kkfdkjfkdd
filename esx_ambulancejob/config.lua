Config_esx_ambulancejob                            = {}
Config_esx_ambulancejob.DrawDistance = 15.0--               = 15.0
Config_esx_ambulancejob.MarkerColor                = { r = 255, g = 255, b = 14 }

Config_esx_ambulancejob.ZoneSize     = {x = 1.5, y = 1.5, z = 2.0}
Config_esx_ambulancejob.MarkerColorTenue  = {r = 100, g = 100, b = 204}

local second = 1000
local minute = 30 * second

-- How much time before auto respawn at hospital
Config_esx_ambulancejob.RespawnDelayAfterRPDeath   = 30 * minute

-- How much time before a menu opens to ask the player if he wants to respawn at hospital now
-- The player is not obliged to select YES, but he will be auto respawn
-- at the end of RespawnDelayAfterRPDeath just above.
Config_esx_ambulancejob.RespawnToHospitalMenuTimer   = true
Config_esx_ambulancejob.MenuRespawnToHospitalDelay   = 5 * minute

Config_esx_ambulancejob.EnablePlayerManagement       = true
Config_esx_ambulancejob.EnableSocietyOwnedVehicles   = false

Config_esx_ambulancejob.RemoveWeaponsAfterRPDeath    = true
Config_esx_ambulancejob.RemoveCashAfterRPDeath       = true
Config_esx_ambulancejob.RemoveItemsAfterRPDeath      = false

-- Will display a timer that shows RespawnDelayAfterRPDeath time remaining
Config_esx_ambulancejob.ShowDeathTimer               = true

-- Will allow to respawn at any time, don't use RespawnToHospitalMenuTimer at the same time !
Config_esx_ambulancejob.EarlyRespawn                 = true
-- The player can have a fine (on bank account)
Config_esx_ambulancejob.RespawnFine                  = true
Config_esx_ambulancejob.RespawnFineAmount            = 1000

Config_esx_ambulancejob.NPCJobEarningsPlayer = 300
Config_esx_ambulancejob.NPCJobEarningsEntreprise = 450

Config_esx_ambulancejob.Txt = {
  -- Cloakroom
  ['cloakroom'] = 'Vestiaire',
  ['ems_clothes_civil'] = 'Tenue Civil',
  ['ems_clothes_ems'] = 'Tenue Travail',
  -- Vehicles
  ['veh_menu'] = 'véhicule',
  ['veh_spawn'] = '~INPUT_CONTEXT~ pour ~g~SORTIR~w~ un véhicule',
  ['store_veh'] = '~INPUT_CONTEXT~ pour ~r~RANGER~w~ le véhicule',
  ['ambulance'] = 'Menu EMS',
  ['helicopter'] = 'Hélicoptère',
  ['ambulance2'] = 'Dodge Samu',
  -- Action Menu
  ['hospital'] = 'Hopital',
  ['revive_inprogress'] = 'réanimation en cours',
  ['revive_complete'] = 'vous avez réanimé l\'individu',
  ['no_players'] = 'aucun joueur à proximité',
  ['no_vehicles'] = 'aucun véhicule à proximité',
  ['isdead'] = 'a succombé',
  ['unconscious'] = 'n\'est pas inconscient',
  ['billing_amount'] = 'Montant de la facture',
  ['amount_invalid'] = 'montant invalide',
  ['billing'] = 'Facture',
  ['no_players_nearby'] = 'aucun joueur à proximité',
  ['search'] = 'Fouiller',
  -- Misc
  ['invalid_amount'] = '~r~montant invalide',
  ['open_menu'] = 'appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu',
  ['deposit_amount'] = 'montant du dépôt',
  ['money_withdraw'] = 'montant du retrait',
  ['fast_travel'] = 'appuyez sur ~INPUT_CONTEXT~ pour vous déplacer rapidement.',
  ['open_pharmacy'] = 'appuyez sur ~INPUT_CONTEXT~ pour ouvrir la pharmacie.',
  ['pharmacy_menu_title'] = 'Pharmacie',
  ['pharmacy_take'] = 'Prendre',
  ['medikit'] = 'medikit',
  ['bandage'] = 'bandage',
  ['pills'] = 'pilule',
  ['defibrillateur'] = 'défibrillateur',
  ['max_item'] = 'vous en portez déjà assez sur vous.',
  -- F6 Menu
  ['ems_menu'] = 'Interaction citoyen',
  ['ems_menu_title'] = 'EMS - Interactions Citoyen',
  ['ems_menu_revive'] = 'Réanimer',
  ['ems_menu_putincar'] = 'Mettre dans véhicule',
  ['ems_menu_small'] = 'Soigner petites blessures',
  ['ems_menu_big'] = 'Soigner blessures graves',
  -- Phone
  ['alert_ambulance'] = 'alerte Samu',
  -- Death
  ['respawn_at_hospital'] = 'voulez-vous être transporté à l\'hôpital ?',
  ['yes'] = 'oui',
  ['please_wait'] = 'Vous serez automatiquement transporté à l\'hôpital dans ~b~',
  ['minutes'] = ' minutes ',
  ['seconds_fine'] = ' secondes ~w~ pour réapparaître \nRéapparaître maintenant pour ~g~$',
  ['seconds'] = ' secondes ~w~.',
  ['press_respawn_fine'] = 'vous payerez ~g~',
  ['press_respawn'] = 'appuyez sur [~b~E~w~] pour réapparaître.',
  ['distress_send'] = 'appuyez sur ~b~[G]~s~ pour appeler un ems',
  ['distress_sent'] = 'le signal de détresse a été envoyé aux unités disponibles!',
  ['distress_message'] = 'Alert Besoin EMS',
  -- Revive
  ['revive_help'] = 'relancer un joueur',
  ['fine_total']             = 'Cout Total',
  -- Item
  ['used_medikit'] = 'vous avez utilisé 1x medikit',
  ['used_bandage'] = 'vous avez utilisé 1x bandage',
  ['used_pills'] = 'vous avez utilisé 1x pilule',
  ['used_defib'] = 'vous avez utilisé 1x défibrillateur',
  ['not_enough_medikit'] = 'vous n\'avez pas de ~b~medikit~w~.',
  ['not_enough_bandage'] = 'vous n\'avez pas de ~b~bandage~w~.',
  ['not_enough_defib'] = 'vous n\'avez pas de ~b~défibrillateur~w~.',
  ['healed'] = 'vous avez été soigné.',
  ['heal_inprogress'] = 'soin en cours.',
  ['heal_complete'] = 'vous avez soigné l\'individu.',
  -- Boss Menu
  ['boss_actions']           = 'action Patron',
  ['invalid_quantity']       = 'Quantité invalide',
  ['you_removed']            = 'Vous avez retiré x',
  ['you_added']              = 'Vous avez ajouté x',
  ['quantity']               = 'Quantité',
  ['inventory']              = 'Inventaire',
  ['ambulance_stock']        = 'Stock de l\'Hopital',
  -- Weapons Menus (Vault)
  ['get_weapon_menu']        = 'Coffre - Prendre Arme',
  ['put_weapon_menu']        = 'Coffre - Déposer Arme',
  -- Vault
  ['get_weapon']             = 'Prendre Arme',
  ['put_weapon']             = 'Déposer Arme',
  ['get_object']             = 'Prendre Objet',
  ['put_object']             = 'Déposer Objet',
  ['vault']                  = 'Coffre',
  ['open_vault']             = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au coffre',
  -- Misc
  ['must_in_ambulance'] = 'Vous devez être en Samu pour commencer la mission',
  ['must_in_vehicle'] = 'Vous devez être en véhicule pour commencer la mission',
  --NPC
  ['have_earned'] = 'vous avez gagné ~g~$',
  ['comp_earned'] = 'votre société a gagné ~g~$',
  ['taking_service'] = 'Prise de service : ',
  ['mission_complete'] = "Patrouille terminée rentre à l'hopital",
  ['drive_search_pass'] = "Patrouille jusqu'a ce que tu recoives une position.",
  ['customer_found'] = 'Une personne malade est proche de vous. La ~g~position~s~ est sur votre GPS.',
  ['client_unconcious'] = 'votre malade est ~r~inconscient~w~. Cherchez-en un autre.',
  ['arrive_dest'] = 'Vous êtes ~g~arrivé~s~ à destination',
  ['take_me_to_emergency'] = '~w~Emmenez la personne aux urgences.~y~',
  ['close_to_client'] = 'La personne est à proximité, approchez-vous de lui.',
  ['return_to_veh'] = 'Remonte dans ton ambulance pour faire monter la personne.',
  ['client_ano'] = "La personne a refusé de se faire emmener. La centrale t'envois nouveau patient à la centrale.",
  
  -- Core_inventory 

  ['open_weapon_stash'] = 'Ouvrir l\'armurerie',
  ['open_utility_stash'] = 'Ouvrir le stockage',
}
function Ftext_esx_ambulancejob(txt)
	return Config_esx_ambulancejob.Txt[txt]
end

Config_esx_ambulancejob.Blip = { -- Blips maps et points journal autos
	{ x = -670.37, y = 312.53, z = 83.08, principal = true }, -- Sud (batiment principal Life Invader)
	{ x = -253.27, y = 6322.37, z = 32.43 }, -- Nord Paleto
}

Config_esx_ambulancejob.HelicopterSpawner = {
  PointBlip  = { x = -687.29, y = 321.45, z = 140.15 },
  SpawnPoint  = { x = -687.29, y = 321.45, z = 140.15 },
  Heading     = 174.96
}

-- Config_esx_ambulancejob.HelicopterSpawner = {
--   PointBlip  = { x = 341.07, y = -581.279, z = 74.16-1 },
--   SpawnPoint  = { x = 351.4666, y = -587.92, z = 74.16-1 },
--   Heading     = 249.04
-- }

Config_esx_ambulancejob.HelicopterSpawner2 = {
  PointBlip  = { x = -252.32, y = 6319.03, z = 39.66-0.98  },
  SpawnPoint  = { x = -252.32, y = 6319.03, z = 39.66-0.98 },
  Heading     = 224.51
}

Config_esx_ambulancejob.Zones = {

  RespawnPos = { 
    Pos  = {x = -670.01, y = -317.1, z = 83.08-0.80, h = 358.5, r = 1.45},
    Size = { x = 1.5, y = 1.5, z = 1.0 },
	  Color = { r = 0, g = 255, b = 0 },
    Type = -1
  },

  Pharmacy = { 
    Pos  = {x = -680.04, y = 329.15, z = 88.02-0.7},
    Size = { x = 0.3, y = 0.3, z = 0.3 },
	  Color = { r = 0, g = 255, b = 0 },
    Type = 0
  },

  AmbulanceActions = { -- CLOACKROOM
    Pos  = {x = -664.83, y = 323.36, z = 92.74-0.7, h = 89.0, r = 1.85},
    Size = { x = 0.3, y = 0.3, z = 0.3 },
  	Color = { r = 0, g = 255, b = 0 },
    Type = 0
  },

  AmbulanceActions2 = { -- CLOACKROOM NORTH
    Pos  = { x = -252.08, y = 6309.91, z = 32.43-0.98},
    Size = { x = 0.3, y = 0.3, z = 0.3 },
  	Color = { r = 0, g = 255, b = 0 },
    Type = 0,
    Second = true
  },


  VehicleSpawner = {
    Pos  = {  x = -687.29, y = 321.45, z = 140.15 },
    Size = { x = 1.0, y = 1.0, z = 1.0 },
	  Color = { r = 255, g = 255, b = 0 },
    Type = 39
  },

  VehicleSpawner2 = {
    Pos  = { x = -252.61, y = 6319.19, z = 39.66-0.98 },
    Size = { x = 1.0, y = 1.0, z = 1.0 },
	  Color = { r = 255, g = 255, b = 0 },
    Type = 39
  }
}

Config_esx_ambulancejob.JobsVehicles = {
  [1039450829] = true, --EMSSPEEDO
  [1500677296] = true, --EMSNSPEEDO
}
