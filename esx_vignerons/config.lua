Config_esx_vignerons                            = {}
Config_esx_vignerons.DrawDistance               = 15.0
Config_esx_vignerons.MaxInService               = -1
Config_esx_vignerons.EnablePlayerManagement     = true
Config_esx_vignerons.EnableSocietyOwnedVehicles = false
Config_esx_vignerons.Locale                     = 'fr'

Config_esx_vignerons.Txt = {
	-- General
	['cloakroom'] = 'Vestiaire',
	['vine_clothes_civil'] = 'Tenue Civil',
	['vine_clothes_vine'] = 'Tenue de travail',
	['veh_menu'] = 'Garage',
	['spawn_veh'] = 'appuyez sur ~INPUT_CONTEXT~ pour sortir véhicule',
	['amount_invalid'] = 'montant invalide',
	['press_to_open'] = 'appuyez sur ~INPUT_CONTEXT~ pour accéder au menu',
	['billing'] = 'facturation',
	['invoice_amount'] = 'montant de la facture',
	['no_players_near'] = 'aucun joueur à proximité',
	['store_veh'] = 'appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule',
	['comp_earned'] = 'votre avez gagné ~g~$',
	['deposit_stock'] = 'Déposer Stock',
	['take_stock'] = 'Prendre Stock',
	['boss_actions'] = 'action Patron',
	['quantity'] = 'Quantité',
	['quantity_invalid'] = '~r~Quantité invalide~w~',
	['inventory'] = 'Inventaire',
	['have_withdrawn'] = 'Vous avez retiré x',
	['added'] = 'Vous avez ajouté x',
	['not_enough_place'] = 'Vous n\'avez plus de place',
	['sale_in_prog'] = 'Revente en cours...',
	['van'] = 'Camion de travail',
	['open_menu'] = ' ',
  
	-- A modifier selon l'entreprise
	['vigneron_client'] = 'client vigne',
	['transforming_in_progress'] = 'Transformation du raisin en cours...',
	['raisin_taken'] = 'Vous être en train de ramasser du raisin',
	['press_traitement'] = 'appuyez sur ~INPUT_CONTEXT~ pour transformer votre raisin',
	['press_collect'] = 'appuyez sur ~INPUT_CONTEXT~ pour récolter du raisin',
	['press_sell'] = 'appuyez sur ~INPUT_CONTEXT~ pour vendre vos produits',
	['no_jus_sale'] = 'Vous n\'avez plus ou pas assez de jus de raisin',
	['no_vin_sale'] = 'Vous n\'avez plus ou pas assez de vin',
	['not_enough_raisin'] = 'Vous n\'avez plus de raisin',
	['grand_cru'] = '~g~Génial, un grand cru !~w~',
	['no_product_sale'] = 'Vous n\'avez plus de produits',
	['press_traitement_jus'] = 'appuyez sur ~INPUT_CONTEXT~ pour transformer votre raisin',
	['used_jus'] = 'Vous avez bu du jus de raisin',
	['used_grand_cru'] = 'Vous avez bu une bouteille de grand cru',

}

function Ftext_esx_vignerons(txt)
	return Config_esx_vignerons.Txt[txt]
end

Config_esx_vignerons.Zones = {

-- Pas utilisé vestiaire volant	
	--Dressing = {
	--	Pos   = {x = -1887.27, y = 2070.19, z = 145.57-0.7},
	--	Size  = {x = 3.5, y = 3.5, z = 2.0},
	--	Color = {r = 255, g = 0, b = 0},
	--	Name  = "Dressing",
	--	Type  = 0
	--},

	RaisinFarm = {
		Pos   = {x = -1809.51, y = 2210.08, z = 91.72-0.7},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 255, g = 0, b = 255},
		Name  = "Récolte de raisin blanc",
		Type  = 0
	},
	RaisinFarm2 = {
		Pos   = {x = -1807.79, y = 2215.36, z = 90.06-0.7},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 255, g = 0, b = 255},
		Name  = "Récolte de raisin rouge",
		Type  = 0
	},
	
	GingembreFarm = {
		Pos   = {x = -1838.80, y = 2209.41, z = 89.80-0.7},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 255, g = 0, b = 255},
		Name  = "Récolte de gingembre",
		Type  = 0
	},
	
	RaisinNormalFarm = { -- Récolte de raisin normal
		Pos   = {x = -1820.20, y = 2222.68, z = 86.25-0.7},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 255, g = 0, b = 255},
		Name  = "Récolte de raisin",
		Type  = 0
	},

-- Coffre entreprise
	Cave = {
		Pos   = {x = -1866.92, y = 2058.74, z = 140.99-0.8},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 0, g = 0, b = 0},
		Name  = "Cave a vin",
		Type  = 0
	},

	TraitementJus = {
		Pos   = {x = -1931.52, y = 2055.14, z = 140.81-0.8},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Name  = "Traitement du Jus de raisin",
		Type  = 0
	},
	
	SellFarm = {
		Pos   = {x = -169.83, y = 284.04, z = 93.76-0.7},
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Name  = "Vente des produits",
		Type  = 0
	},

-- Menu Patron	
	VigneronOthers = {
		Pos   = {x = -1896.02, y = 2067.66, z = 141.02-0.7},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Boss action",
		Type  = 0
	},

-- Vestiaire
	VigneronActions = {
		Pos   = {x = -1875.37, y = 2053.88, z = 141.06-0.7},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Vestiaire",
		Type  = 0
	 },
}