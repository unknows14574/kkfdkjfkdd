iV = {}

iV.Blips = {

  Garage = {
    Blips = {Sprite = 473, Color = 24, Display = 4},
    TailleDrawMarker = {TypeDrawMarker = 36, zDel = 0.4, Xloin = 0.4, Yloin = 0.4, Zloin = 0.4, Xproche = 1.0, Yproche = 1.0, Zproche = 1.0},
    ColorDrawMarker = {r = 255, g = 255, b = 0},
    DrawDistance = {Action = true, DrawDistance = 10.0, Distance = 2.0},
    StolenGarage = 4,
    Touche = Config.Keys["E"].id,
    Text = { main = "", get = "Appuyez sur ~" .. Config.Keys["E"].input .. "~ pour ouvrir le menu", put = "Appuyez sur ~" .. Config.Keys["E"].input .. "~ pour ranger le véhicule"},
    Name = "Parking"
  },

  Fourriere = {
    Blips = {Sprite = 365, Color = 63, Display = 4},
    TailleDrawMarker = {TypeDrawMarker = 39, zDel = 0.4, Xloin = 0.4, Yloin = 0.4, Zloin = 0.4, Xproche = 1.0, Yproche = 1.0, Zproche = 1.0},
    ColorDrawMarker = {r = 255, g = 165, b = 0},
    DrawDistance = {Action = true, DrawDistance = 10.0, Distance = 2.0},
    Price = 500,
    Touche = Config.Keys["E"].id,
    Text = { main = "Appuyez sur ~" .. Config.Keys["E"].input .. "~ pour ouvrir le menu"},
    Name = "Fourrière de la ville"
  },

  Assurance = {
    Blips = {Sprite = 380, Color = 23, Display = 4},
    TailleDrawMarker = {TypeDrawMarker = 27, zDel = 0.0, Xloin = 1.2, Yloin = 1.2, Zloin = 1.2, Xproche = 0.8, Yproche = 0.8, Zproche = 0.8},
    ColorDrawMarker = {r = 255, g = 255, b = 0},
    DrawDistance = {Action = true, DrawDistance = 10.0, Distance = 2.0},
    Pourcentage = 0.75,
    Touche = Config.Keys["E"].id,
    Text = { main = "Appuyez sur ~" .. Config.Keys["E"].input .. "~ pour ouvrir le menu"},
    Name = "Assurance"
  },

  Prefecture = {
    Blips = {Sprite = 545, Color = 8, Display = 4},
    TailleDrawMarker = {TypeDrawMarker = 27, zDel = 0.0, Xloin = 1.2, Yloin = 1.2, Zloin = 1.2, Xproche = 0.8, Yproche = 0.8, Zproche = 0.8},
    ColorDrawMarker = {r = 255, g = 255, b = 0},
    DrawDistance = {Action = true, DrawDistance = 10.0, Distance = 3.0},
    Touche = Config.Keys["E"].id,
    Text = { main = "Appuyez sur ~" .. Config.Keys["E"].input .. "~ pour ouvrir le menu"},
    Name = "Prefecture"
  },

  CarWash = {
    Blips = {Sprite = 100, Color = 8, Display = 4},
    TailleDrawMarker = {TypeDrawMarker = 27, zDel = 0.0, Xloin = 2.5, Yloin = 2.5, Zloin = 2.5, Xproche = 1.5, Yproche = 1.5, Zproche = 1.5},
    ColorDrawMarker = {r = 255, g = 255, b = 0},
    DrawDistance = {Action = true, DrawDistance = 10.0, Distance = 3.0},
    Touche = Config.Keys["E"].id,
    Text = { main = "Appuyez sur ~" .. Config.Keys["E"].input .. "~ pour nettoyer la voiture"},
    Name = "CarWash"
  },

  ZoneGang = {
    Blips = {Sprite = 630, Color = 0, Display = 4},
    Name = "???"
  },

  ZoneSafe = {
    DrawDistance = {Action = false, DrawDistance = 20.0},
    Name = "SafeZone"
  },

  DoorLock = {
    TailleDrawMarker = {TypeDrawMarker = 27, zDel = 0.0, Xloin = 0.5, Yloin = 0.5, Zloin = 0.5, Xproche = 0.8, Yproche = 0.8, Zproche = 0.8},
    ColorDrawMarker = {r = 255, g = 255, b = 0},
    DrawDistance = {Action = true, DrawDistance = 35.0, Distance = 20.0},
    Touche = Config.Keys["E"].id,
    Text = { main = "", open = "Appuyez sur ~" .. Config.Keys["E"].input .. "~ pour ~g~ouvrir~s~ la porte", close = "Appuyez sur ~" .. Config.Keys["E"].input .. "~ pour ~r~fermer~s~ la porte"},
    Name = "DoorLock"
  },
  -- Autotamponneuse = {
  --   Blips = {Sprite = 782, Color = 3, Display = 4},
  --   Name = "Autotamponneuse"
  -- },
}

iV.Zones = {
  --CarWash
  CarWash1 = { -- F4L
    Pos    = { x = 26.5906, y = -1392.0261, z = 28.3634 },
    TypeZone = iV.Blips.CarWash,
    Blips    =  0.6,
    Action   = true,
    
  },
  CarWash2 = { -- Ballas
    Pos    = { x = 167.1034, y = -1719.4704, z = 28.2916 },
    TypeZone = iV.Blips.CarWash,
    Blips    =  0.6,
    Action   = true,
  },
  CarWash3 = { -- Paleto
    Pos    = { x = -80.52, y = 6421.8, z = 30.6400 },
    TypeZone = iV.Blips.CarWash,
    Blips    =  0.6,
    Action   = true,
  },
  CarWash4 = { -- Little seoul
    Pos    = { x = -699.6325, y = -932.7043, z = 18.0139 },
    TypeZone = iV.Blips.CarWash,
    Blips    =  0.6,
    Action   = true,
  },
  CarWash5 = { -- Taxi
    Pos    = { x = 897.40, y = -151.89, z = 75.60 },
    TypeZone = iV.Blips.CarWash,
    Action   = true,
  },
  CarWash6 = { -- Sandy Shore
  Pos    = { x = 1982.46, y = 3781.71, z = 31.18 },
  TypeZone = iV.Blips.CarWash,
  Blips    =  0.6,
  Action   = true,
},
  CarWash7 = { -- Vinewood
  Pos    = { x = 627.75, y = 249.91, z = 102.15 },
  TypeZone = iV.Blips.CarWash,
  Blips    =  0.6,
  Action   = true,
},


  -----------------
  --  ZONE SAFE  --
  -----------------  
  SafeAero = {
    Pos    = { x = -1037.88, y = -2737.83, z = 18.16 },
    TypeZone = iV.Blips.ZoneSafe,
    Action   = true,
  },

  --------------------------------------------------------------------------
  --                            DOORLOCK                                  --
  --------------------------------------------------------------------------


  -----------------
  --  Entreprise --
  -----------------  

  --Mosley

  mosley1 = {
  name = 911651337,
    Pos  = {x = -768.64, y = -1037.57, z = 13.25},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'flywheels'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  mosley2 = {
  name = 2427807429,
    Pos  = {x = -769.64, y = -1035.63, z = 13.25},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'flywheels'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  mosley3 = {
  name = 911651337,
    Pos  = {x = -777.03, y = -1050.00, z = 12.00},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'flywheels'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  mosley4 = {
  name = 2427807429,
    Pos  = {x = -777.93, y = -1048.26, z = 12.00},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'flywheels'}, distance = 3.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  mosley_5 = {
  name = 4061882133,
    Pos  = {x = -772.29	, y = -1030.37, z = 12.9},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'flywheels'}, distance = 7, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  -- Weazel News

  weazel_news1 = {
		name = 1808123841,
    Pos  = {x = -587.77, y = -912.86, z = 22.97},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'journaliste'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },  

  weazel_news2 = {
		name = 1808123841,
    Pos  = {x = -585.43, y = -913.01, z = 22.97},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'journaliste'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  weazel_news3 = {
		name = 1808123841,
    Pos  = {x = -576.00, y = -939.63, z = 22.86},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'journaliste'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  }, 

  weazel_news4 = {
		name = 1808123841,
    Pos  = {x = -573.48, y = -939.58, z = 22.86},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'journaliste'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  bennys = {
		name = -427498890,
    Pos  = {x = -205.57, y = -1310.63, z = 30.29},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'mecano'}, distance = 8.0, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 1.8 },
  },  

	bahama1 = {
		name = 'v_ilev_ph_gendoor006',
    Pos  = {x = -1392.48, y = -592.71, z = 29.21},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'bahama'}, distance = 3.0, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },  

	bahama2 = {
		name = 'v_ilev_ph_gendoor006',
    Pos  = {x = -1393.18, y = -591.75, z = 29.22},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'bahama'}, distance = 3.0, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
	},

  --Departement of Justice
  
	doj_1 = {--DOJ porte acces 1
		name = -1441580718,
		Pos = {x = -533.18, y = -166.78, z = 38.31-0.98},
		TypeZone = iV.Blips.DoorLock,
		Action = { job = {'gouv', 'doj', 'police'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
	},

	doj_2 = {--DOJ porte acces droite
		name = -1441580718,
		Pos = {x = -534.83, y = -167.68, z = 38.31-0.98},
		TypeZone = iV.Blips.DoorLock,
		Action = { job = {'gouv', 'doj', 'police'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
	},

	doj_3 = {--DOJ porte acces gauche
		name = -1441580718,
		Pos = {x = -581.90, y = -194.75, z = 38.32-0.98},
		TypeZone = iV.Blips.DoorLock,
		Action = { job = {'gouv', 'doj', 'police'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
	},

	doj_4 = {--DOJ porte acces droite
		name = -1441580718,
		Pos = {x = -583.52, y = -195.63, z = 38.32-0.98},
		TypeZone = iV.Blips.DoorLock,
		Action = { job = {'gouv', 'doj', 'police'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
	},

	doj_5 = {--DOJ porte avant droit
		name = -1847344035,
		Pos = {x = -556.67, y = -227.92, z = 38.32-0.98},
		TypeZone = iV.Blips.DoorLock,
		Action = { job = {'gouv', 'doj', 'police'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
	},

	doj_6 = {--DOJ porte avant gauche
		name = -1847344035,
		Pos = {x = -555.98, y = -229.49, z = 38.32-0.98},
		TypeZone = iV.Blips.DoorLock,
		Action = { job = {'gouv', 'doj', 'police'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
	},

	doj_7 = {--DOJ porte avant droit
		name = -1847344035,
		Pos = {x = -515.562, y = -211.198, z = 38.32-0.98},
		TypeZone = iV.Blips.DoorLock,
		Action = { job = {'gouv', 'doj', 'police'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
	},

	doj_8 = {--DOJ porte avant gauche
		name = -1847344035,
		Pos = {x = -516.28, y = -209.66, z = 42.83-0.98},
		TypeZone = iV.Blips.DoorLock,
		Action = { job = {'gouv', 'doj', 'police'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
	},

  doj_9 = {--DOJ porte bureau DOJ
  name = -2030220382,
  Pos = {x = -535.71, y = -187.76, z = 42.83-0.98},
  TypeZone = iV.Blips.DoorLock,
  Action = { job = {'gouv', 'doj', 'police'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },
  -- Music Record

--  WadeRecord = {
--    name = -1045015371,
--    Pos = {x = 202.80, y = -19.46, z = 74.98-0.98},
--    TypeZone = iV.Blips.DoorLock,
--    Action = { job = {'musicrecord', 'hustlers'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
--  },

--  WadeRecord2 = {
--    name = -1045015371,
--    Pos = {x = 204.72, y = -17.62, z = 74.98-0.98},
--    TypeZone = iV.Blips.DoorLock,
--    Action = { job = {'musicrecord', 'hustlers'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
--  },

  --Blackwoods Saloon

 BWS_porte_1 = {--Black Woods porte principale droite
   name = 262671971,
   Pos = {x = -300.18, y = 6257.74, z = 30.49},
   TypeZone = iV.Blips.DoorLock,
   Action = { job = {'diner'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
 },

 BWS_porte_2 = {--Black Woods  porte principale gauche
   name = 1504256620,
   Pos = {x = -302.02, y = 6255.93, z = 30.49},
   TypeZone = iV.Blips.DoorLock,
   Action = { job = {'diner'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
 },

  BWS_porte_3 = {--Black Woods  porte cour
    name = -1627599682,
    Pos = {x = -309.93, y = 6271.35, z = 30.6},
    TypeZone = iV.Blips.DoorLock,
    Action = { job = {'diner'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  BWS_porte_4 = {--Black Woods  porte cuisine
    name = -2023754432,
    Pos = {x = -310.44, y = 6267.37, z = 30.55},
    TypeZone = iV.Blips.DoorLock,
    Action = { job = {'diner'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  BWS_porte_5 = {--Black Woods  porte Fire Escape
    name = 1099436502,
    Pos = {x = -298.71, y = 6273.56, z = 30.55},
    TypeZone = iV.Blips.DoorLock,
    Action = { job = {'diner'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  -- Pizza This
  PizzaThis_doorleft_Right = {
    name = -49173194,
    Pos = {x =   803.30, y = -747.91, z = 26.78 - 0.98},
    TypeZone = iV.Blips.DoorLock,
    Action = { job = {'pizzathis'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  PizzaThis_doorleft_Left = {
    name = 95403626,
    Pos = {x = 805.63, y = -747.90, z = 26.78 - 0.98},
    TypeZone = iV.Blips.DoorLock,
    Action = { job = {'pizzathis'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  PizzaThis_doorback_Left = {
    name = -420112688,
    Pos = {x = 814.68, y = -762.80, z = 26.78 - 0.98},
    TypeZone = iV.Blips.DoorLock,
    Action = { job = {'pizzathis'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  PizzaThis_doorright_Left = {
    name = 95403626,
    Pos = {x = 794.28, y = -757.07, z = 26.78 - 0.98},
    TypeZone = iV.Blips.DoorLock,
    Action = { job = {'pizzathis'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  PizzaThis_doorright_Right = {
    name = -49173194,
    Pos = {x = 794.20, y = -759.40, z = 26.78 - 0.98},
    TypeZone = iV.Blips.DoorLock,
    Action = { job = {'pizzathis'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  -- Bean Machine Coffee

  Bean_door_left = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = -690.65, y = 315.54, z = 83.11-0.98},
    name = 1942545850,
    Action = { job = {'coffee'}, distance = 2.7, lock_dist = 5.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  Bean_door_right = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = -688.11, y = 315.33, z = 83.11-0.98},
    name = 1942545850,
    Action = { job = {'coffee'}, distance = 2.7, lock_dist = 5.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  Bean_door_left2 = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = -685.56, y = 316.56, z = 83.11-0.98},
    name = -2117893713,
    Action = { job = {'coffee'}, distance = 2.7, lock_dist = 5.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  Bean_door_right2 = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = -685.36, y = 319.1, z = 83.11-0.98},
    name = -2117893713,
    Action = { job = {'coffee'}, distance = 2.7, lock_dist = 5.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  -- Bean coffe Mapping Gabz
  Bean2_door_left = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 128.24, y = -1029.47, z = 29.36-0.98},
    name = 494354570,
    Action = { job = {'coffee'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  Bean2_double_door_left = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 115.28, y = -1037.56, z = 29.34-0.98},
    name = 3547956024,
    Action = { job = {'coffee'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  Bean2_double_door_right = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 114.45, y = -1039.87, z = 29.34-0.98},
    name = 3112806417,
    Action = { job = {'coffee'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  --Unicorn

  unicorn = {
    name = 'prop_strip_door_01',
    Pos  = {x = 128.64, y = -1298.10, z = 29.26-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'event'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  unicorn2 = {
  name = 'ba_prop_door_club_glam_generic',
  Pos  = {x = 95.46, y = -1285.30, z = 29.27-0.98},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'event'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },	

  unicorn3 = {
  name = 'ba_prop_door_club_edgy_generic',
  Pos  = {x = 113.81, y = -1296.82, z = 29.26-0.98},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'event'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },	

  unicorn4 = {
  name = 'ba_prop_door_club_edgy_generic',
  Pos  = {x = 99.57, y = -1293.32, z = 29.26-0.98},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'event'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  unicorn5 = {
  name = 'ba_prop_door_club_edgy_generic',
  Pos  = {x = 116.55, y = -1295.16, z = 29.26-0.98},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'event'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  unicorn6 = {
  name = 'ba_prop_door_club_glam_generic',
  Pos  = {x = 127.52, y = -1279.63, z = 29.26-0.98},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'event'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  -- Casino

  casino_porteA = {
    name = 'vw_prop_vw_casino_door_02a',
    Pos  = {x = 927.77, y = 49.56, z = 81.08-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'casino'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
    },

  casino_porteA2 = {
    name = 'vw_prop_vw_casino_door_02a',
    Pos  = {x = 926.49, y = 47.68, z = 81.08-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'casino'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
    },

  casino_porteB = {
    name = 'vw_prop_vw_casino_door_02a',
    Pos  = {x = 926.09, y = 46.94, z = 81.08-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'casino'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
    },

  casino_porteB2 = {
    name = 'vw_prop_vw_casino_door_02a',
    Pos  = {x = 925.05, y = 45.21, z = 81.08-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'casino'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
    },
    
  casino_porteC = {
    name = 'vw_prop_vw_casino_door_02a',
    Pos  = {x = 924.49, y = 44.70, z = 81.08-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'casino'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
    },

  casino_porteC2 = {
    name = 'vw_prop_vw_casino_door_02a',
    Pos  = {x = 923.34, y = 42.88, z = 81.08-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'casino'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
    },

  -- Taxi

  taxi_entrance_door_right = {
    name = -1318573207,
    Pos = {x = 907.91, y = -159.58, z = 74.14-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action = { job = {'taxi'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  taxi_entrance_door_left = {
    name = 539363547,
    Pos = {x = 906.43, y = -161.76, z = 74.13-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action = { job = {'taxi'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  taxi_second_entrance_door_right = {
    name = -2023754432,
    Pos = {x = 895.25, y = -177.96, z = 74.7-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action = { job = {'taxi'}, distance = 2, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  taxi_second_entrance_door_left = {
    name = -2023754432,
    Pos = {x = 893.91, y = -180.13, z = 74.7-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action = { job = {'taxi'}, distance = 2, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  taxi_back_car_wash = {
    name = 426403179,
    Pos = {x = 889.29, y = -159.78, z = 76.94-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action = { job = {'taxi'}, distance = 1.8, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  -- LSPD Mission Row

  police = {
  name = -1213562692,
  Pos  = {x = -561.17, y = -130.270, z = 38.43-1.08},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'police'}, distance = 1.8, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  police2 = {
  name = -1213562692,
  Pos  = {x = -563.15, y = -131.035, z = 38.43-1.08},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'police'}, distance = 1.8, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  police3 = {
  name = -1213562692,
  Pos  = {x = -541.99, y = -131.65, z = 38.799-1.08},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'police'}, distance = 1.8, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  police4 = {
  name = -1213562692,
  Pos  = {x = -543.85, y = -132.35, z = 38.799-1.08},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'police'}, distance = 1.8, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  police5 = {
  name = -1213562692,
  Pos  = {x = -588.44, y = -136.755, z = 47.77-1.08},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'police'}, distance = 1.8, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  police6 = {
  name = -1213562692,
  Pos  = {x = -587.70, y = -134.68, z = 47.77-1.08},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'police'}, distance = 1.8, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  police7 = {
  name = 631614199, -- CELL 1
  Pos  = {x = -542.85, y = -121.38, z = 33.75-0.98},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'police'}, distance = 1.8, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  police8 = {
  name = 631614199,
  Pos  = {x = -542.12, y = -122.93, z = 33.75-0.98},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'police'}, distance = 1.8, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  police9 = {
  name = 631614199,
  Pos  = {x = -540.94, y = -125.64, z = 33.75-0.98},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'police'}, distance = 1.8, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  police10 = {
  name = 631614199,
  Pos  = {x = -542.69, y = -129.26, z = 33.75-0.98},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'police'}, distance = 1.8, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  police11 = {
  name = 631614199,
  Pos  = {x = -545.74, y = -130.38, z = 33.75-0.98},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'police'}, distance = 1.8, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  police12 = {
  name = 631614199,
  Pos  = {x = -546.92, y = -130.97, z = 33.75-0.98},
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'police'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  -- LSCS 
  --SandyShore PDP

  sheriff_cellule_enter = {
    name = 2010487154,
    Pos  = {x = 1813.68, y = 3675.03, z = 34.19-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },  

  sheriff_cellule_1 = {
    name = 2010487154,
    Pos  = {x = 1810.17, y = 3676.6, z = 34.19-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },  

  sheriff_cellule_2 = {
    name = 2010487154,
    Pos  = {x = 1808.52, y = 3678.94, z = 34.19-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  sheriff_cellule_3 = {
    name = 2010487154,
    Pos  = {x = 1807.46, y = 3681.27, z = 34.19-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  sheriff_back_enter = {
    name = -1501157055,
    Pos  = {x = 1823.79, y = 3681.13, z = 34.2-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  sheriff_front_enter_left = {
    name = -1501157055,
    Pos  = {x = 1835.08, y = 3673.45, z = 34.18-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  sheriff_front_enter_right = {
    name = -1501157055,
    Pos  = {x = 1837.44, y = 3674.82, z = 34.18-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  sheriff_office_enter_left = {
    name = -1264811159,
    Pos  = {x = 1829.73, y = 3673.87, z = 34.19-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  sheriff_office_enter_front = {
    name = -1264811159,
    Pos  = {x = 1830.64, y = 3676.56, z = 34.19-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  sheriff_office_enter_right = {
    name = 1364638935,
    Pos  = {x = 1838.06, y = 3677.03, z = 34.19-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  --Sherif
  -- Devis PDP

  sheriff_jail_0 = {
    name = 'v_ilev_lssddoor',
    Pos  = {x = 369.62, y = -1606.61, z = 28.30},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.8, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  sheriff_jail_1 = {
    name = -674638964,
    Pos  = {x = 375.97, y = -1599.19, z = 25.45-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  sheriff_jail_2 = {
    name = -674638964,
    Pos  = {x = 374.95, y = -1598.27, z = 25.45-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  sheriff_jail_3 = {
    name = -674638964,
    Pos  = {x = 369.19, y = -1605.75, z = 30.05-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  sheriff_jail_4 = {
    name = -674638964,
    Pos  = {x = 367.89, y = -1604.75, z = 30.05-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'sheriff'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  pacific_esca = {
    name = 1956494919,
    Pos  = {x = 237.78, y = 228.16, z = 105.29},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'pacific'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  --Hopital Nord	

  hopital_back_right = {
    name = 613848716,
    Pos  = {x = -261.65, y = 6310.15, z = 32.43-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  }, 

  hopital_back_left = {
    name = 613848716,
    Pos  = {x = -263.51, y = 6311.79, z = 32.43-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  }, 
  
  hospital_interior_left = {
    name = -770740285,
    Pos  = {x = -250.33, y = 6321.66, z = 32.43-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  }, 

  hospital_interior_right = {
    name = -770740285,
    Pos  = {x = -252.11, y = 6323.41, z = 32.43-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },


  --Hopital Sud	

-- 1er Etage : Accueil
  hopital_access1 = {
    name = -770740285,
    Pos  = {x = -672.07, y = 329.63, z = 83.08-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff','coffee'}, distance = 2.5, lock_dist = 10.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  }, 
  hopital_access2 = {
    name = -770740285,
    Pos  = {x = -670.07, y = 329.54, z = 83.08-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff','coffee'}, distance = 2.5, lock_dist = 10.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  }, 
  hopital_escalier = {
    name = 475418095,
    Pos  = {x = -682.62, y = 330.72, z = 83.08-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 10.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  }, 

  

  -- 2eme Etage 
  hopital_2a= {
    name = -770740285,
    Pos  = {x = -654.73, y = 328.78, z = 87.68-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 10.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  }, 
  hopital_2b = {
    name = -770740285,
    Pos  = {x = -654.51, y = 331.15, z = 87.63-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 10.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },
  hopital_2aa= {
    name = -770740285,
    Pos  = {x = -672.83, y = 330.65, z = 87.68-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 10.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  }, 
  hopital_2ab = {
    name = -770740285,
    Pos  = {x = -672.72, y = 332.63, z = 87.63-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 10.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },  
  hopital_escalier2 = {
    name = 475418095,
    Pos  = {x = -683.04, y = 330.73, z = 88.02-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 10.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  }, 
  -- 3eme Etage 
  hopital_3a= {
    name = -770740285,
    Pos  = {x = -679.28, y = 333.17, z = 92.74-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 10.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  }, 
  hopital_3b = {
    name = -770740285,
    Pos  = {x = -681.39, y = 333.27, z = 92.74-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 10.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },
  hopital_3aa= {
    name = -770740285,
    Pos  = {x = -654.81, y = 327.74, z = 92.74-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 10.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  }, 
  hopital_3ab = {
    name = -770740285,
    Pos  = {x = -657.02, y = 327.87, z = 92.74-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 10.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },  
  hopital_escalier3 = {
    name = 475418095,
    Pos  = {x = -687.21, y = 331.15, z = 92.74-0.98},
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'ambulance','police','ambulance2','sheriff'}, distance = 2.5, lock_dist = 10.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  }, 

  -- Tequilala

  tequilala = { -- Porte entrée Tequi-La-La
  name = 1117236368,
  Pos  = {x = -559.70, y = 278.42, z = 82.00}, 
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'tequi'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.6 },
  },  

  tequilala2 = { -- Porte entrée Tequi-La-La
  name = 202981272,
  Pos  = {x = -561.37, y = 278.54, z = 82.00}, 
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'tequi'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.6 },
  },

  tequilala3 = { -- Porte derrière
  name = 993120320,
  Pos  = {x = -561.32, y = 293.46, z = 86.60}, 
  TypeZone = iV.Blips.DoorLock,
  Action   = { job = {'tequi'}, distance = 1.6, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  -- Prison 

  prison_porte_entrer_prison = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 1845.99, y = 2586.29, z = 45.89 - 0.8},
    name = -1033001619,
    Action = { job = {'police', 'sheriff', 'prison'}, distance = 1.9, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  prison_porte_accueil = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 1837.74, y = 2594.24, z = 45.95 - 0.8},
    name = -1033001619,
    Action = { job = {'police', 'sheriff', 'prison'}, distance = 1.9, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  prison_entree_Parloir = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 1785.55, y = 2600.22, z = 46.17 - 0.8},
    name = 262839150,
    Action = { job = {'police', 'sheriff', 'prison'}, distance = 1.9, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  -- Eight Pool Bar 

  eight_pool_main_entrance = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 16.2, y = 6437.63, z = 31.6 - 0.98},
    name = 1316811110,
    Action = { job = {'eightpool'}, distance = 1.9, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  eight_pool_second_entrance = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 2.53, y = 6448.22, z = 31.55 - 0.98},
    name = 715102714,
    Action = { job = {'eightpool'}, distance = 3.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  -- Up n atom

  up_n_atom_main_entrance_right = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 82.57, y = 274.94, z = 110.21 - 0.98},
    name = 3121535196,
    Action = { job = {'upnatom'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  up_n_atom_main_entrance_left = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 80.41, y = 275.77, z = 110.21 - 0.98},
    name = 3121535196,
    Action = { job = {'upnatom'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  up_n_atom_second_entrance_right = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 79.14, y = 287.9, z = 110.21 - 0.98},
    name = 2231299773,
    Action = { job = {'upnatom'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  up_n_atom_second_entrance_left = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 79.98, y = 290.02, z = 110.21 - 0.98},
    name = 2231299773,
    Action = { job = {'upnatom'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

   -- Arcadian bar 

   arcadian_main_entrance = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 757.97, y = -816.62, z = 26.39 - 0.98},
    name = 2305201762,
    Action = { job = {'arcade'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  arcadian_disable_fridge_left = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 739.91, y = -809.65, z = 24.27 - 0.98},
    name = 2517325783,
    Action = { job = {'arcade'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  arcadian_disable_fridge_right = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 741.02, y = -809.72, z = 24.27 - 0.98},
    name = 2056855795,
    Action = { job = {'arcade'}, distance = 1.5, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  arcadian_disable_garage_door = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 717.52, y = -766.82, z = 24.9 - 0.98},
    name = 346272656,
    Action = { job = {'arcade'}, distance = 15.0, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  --Assurance

  assuranceSud = {
    Pos    = { x = -826.23, y = -261.60, z = 37.0, Angle = 292.68 }, 
    TypeZone = iV.Blips.Assurance,
    Ped = { Text = "Alice", PedType = 4, Hash = "a_f_y_business_01", x = -826.23, y = -261.60, z = 37.0, Angle = 292.68 },
    Blips    = 0.6,
    Action   = true,
  },

  assuranceNord = {
    Pos    = { x = -152.60, y = 6300.08, z = 30.48, Angle = 224.91 }, 
    TypeZone = iV.Blips.Assurance,
    Ped = { Text = "Bertrand", PedType = 4, Hash = "a_m_y_business_02", x = -826.23, y = -261.60, z = 37.0, Angle = 292.68 },
    Blips    = 0.6,
    Action   = true,
  },

  --Prefecture

  prefecture = {
    Pos    = { x = -554.64, y = -185.08, z = 37.22, Angle = 214.74 }, 
    TypeZone = iV.Blips.Prefecture,
    Ped = { Text = "Jade", PedType = 4, Hash = "s_f_m_shop_high", x = -554.64, y = -185.08, z = 37.22, Angle = 214.74 },
    Blips    = 0.6,
    Action   = true,
  },

  prefectureNord = {
    Pos    = { x = -136.85, y = 6294.99, z = 30.50, Angle = 132.67 }, 
    TypeZone = iV.Blips.Prefecture,
    Ped = { Text = "José", PedType = 4, Hash = "a_m_y_business_01", x = -136.85, y = 6294.99, z = 30.50, Angle = 132.67 },
    Blips    = 0.6,
    Action   = true,
  },

  --Fourrière Point

  fourriere_sud = {
    Pos    = { x = 409.04, y = -1623.02, z = 28.29, Angle = 234.53 },
    TypeZone = iV.Blips.Fourriere,
    Ped = { Text = "Michael", PedType = 5, Hash = "s_m_m_autoshop_02", x = 405.86, y = -1643.417, z = 28.29, Angle = 230.17 },
    Blips    = 1.0,
    Action   = true,
  },

  fourriere_nord = {
    Pos    = { x = 2507.14, y = 4200.61, z = 38.93, Angle  = 163.28 }, 
    TypeZone = iV.Blips.Fourriere,
    Ped = { Text = "Ethan", PedType = 4, Hash = "s_m_m_autoshop_01", x = 2504.55, y = 4194.13, z = 38.94, Angle = 230.81 },
    Blips    = 1.0,
    Action   = true,
  },

  fourriere_nord_nord = {
    Pos    = { x = -235.17, y = 6230.96, z = 30.49, Angle  =  42.89 }, 
    TypeZone = iV.Blips.Fourriere,
    Ped = { Text = "Chucky", PedType = 4, Hash = "s_m_m_autoshop_01", x = -239.36, y = 6232.16, z = 31.49, Angle = 130.13, Scena = "WORLD_HUMAN_LEANING" },
    Blips    = 1.0,
    Action   = true,
  },
  
    -- Garages de Saisies / Fourrière joueur

  Fourrierejoueur = {
    name   = "Fourrière privée",
    Pos    = { x = 112.74, y = 6605.59, z = 31.91-0.98,  Angle  = 318.09 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
    StateToAttribute = 4,
    IsJob = "fourriere",
  },

  SaisiesLSPD = {
    name   = "Saisies LSPD",
    Pos    = { x = -617.98, y = -106.077, z = 33.75-0.98,  Angle  = 89.76 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
    StateToAttribute = 5,
    IsJob = "police",
  },

  SaisiesSheriff = {
    name   = "Saisies Sheriff",
    Pos    = { x = 1861.63, y = 3694.61, z = 33.97-0.98,  Angle  = 128.28 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
    StateToAttribute = 6,
    IsJob = "sheriff",
  },

  SaisiesSheriff2 = {
    name   = "Saisies Sheriff Davis",
    Pos    = { x = 385.21, y = -1634.24, z = 29.29-0.98,  Angle  = 312.19 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
    StateToAttribute = 6,
    IsJob = "sheriff",
  },  

  SaisieBennys = {
    name   = "Dépôt Benny's",
    Pos    = { x = -236.34, y = -1330.08, z = 18.41-0.98,  Angle  = 1.57 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
    StateToAttribute = 8,
    IsJob = "mecano",
  },

  SaisieLsCustomNorth = {
    name   = "Dépôt LS Custom North",
    Pos    = { x = 1163.26, y = 2630.66, z = 37.95-0.98,  Angle  = 0.73 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
    StateToAttribute = 9,
    IsJob = "mecano2",
  },

  -----------------
  --Groupe QG--
  -----------------  

--  lostQG = {-- Porte Club LOST SUD
--    name = 190770132,
--    Pos = {x = 981.41, y = -103.04, z = 74.84-0.98},
--    TypeZone = iV.Blips.DoorLock,
--    Action = { job = {'bikers'}, distance = 2.0, lock_dist = 10.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
--  },

--  lostQGPortail = {-- Portail Club LOST SUD
--  name = -930593859,
--  Pos = {x = 957.47, y = -138.75, z = 74.50-0.98},
--  TypeZone = iV.Blips.DoorLock,
--  Action = { job = {'bikers'}, distance = 13.0, lock_dist = 13.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
--},

  psycho = {
    name = 1742849246,
    Pos  = {x = 1557.76, y = 3593.84, z = 37.90}, 
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'psycho'}, distance = 1.6, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  vdd1 = {
    name = 4147641866,
    Pos  = {x = -2666.89, y = 1330.05, z = 146.50}, 
    TypeZone = iV.Blips.DoorLock,
    Action   = { steam = {'steam:1100001059e43ec', 'steam:110000113a5e3d9'}, distance = 1.6, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  vdd2 = {
    name = 'apa_p_mp_yacht_door_01',
    Pos  = {x = -2667.66, y = 1326.63, z = 146.50}, 
    TypeZone = iV.Blips.DoorLock,
    Action   = { job = {'psycho'}, distance = 1.6, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

	cabane = { -- Cabane 2 Piwel
		name = 736699661,
		Pos  = {x = 301.70, y = 4344.60, z = 50.35}, 
		TypeZone = iV.Blips.DoorLock,
		Action   = { steam = {'steam:1100001059e43ec', 'steam:110000113a5e3d9', 'steam:11000010a619693'}, distance = 2.0, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  }, 
  
  mayans_garage_door = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 37.41, y = 6454.68, z = 31.44 - 0.98},
    name = 464622595,
    Action = { job = {'bikers2'}, distance = 11, lock_dist = 20.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  mayans_between_8pool_door = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = 22.44, y = 6449.77, z = 30.52},
    name = 1461976904,
    Action = { job = {'bikers2'}, distance = 1.5, lock_dist = 5.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  Villa_Monetti_QG_Front = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = -112.15, y = 985.35, z = 234.90},
    name = 1901183774,
    Action = { job = {'monetti'}, distance = 1.5, lock_dist = 5.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  Villa_Monetti_QG_Back = {
    TypeZone = iV.Blips.DoorLock,
    Pos = {x = -61.76, y = 998.06, z = 233.65},
    name = 1901183774,
    Action = { job = {'monetti'}, distance = 1.5, lock_dist = 5.0, checked = false, locked = true, TailleDrawMarker = 0.8 },
  },

  --------------------------------------------------------------------------
  --                            POINT DE GARAGE                           --
  --------------------------------------------------------------------------


  -----------------
  --  Entreprise --
  ----------------- 
  
  Auto_ecole_Garage = {
    name   = "Garage Auto Ecole",
    Pos    = { x = 222.13, y = -1388.05, z = 30.54-0.98,  Angle  = 276.113 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Arcadian_Garage = {
    name   = "Garage Arcadian Bar",
    Pos    = { x = 762.99, y = -792.26, z = 26.28-0.98,  Angle  = 182.0 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Blackwood_Garage = {
    name   = "Garage BlackWoods Saloon",
    Pos    = { x = -306.39, y = 6282.95, z = 31.49-0.98,  Angle  = 132.12 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  PizzaThis_Garage = {
    name   = "Garage Pizza This",
    Pos    = { x = 808.39, y = -733.90, z = 27.59-0.98,  Angle  = 132.15 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
    IsJob = "pizzathis",
  },

  tequigarage = {
    name  = "Tequi-La-La Garage",
    Pos   = { x = -565.71, y = 318.81, z = 84.39-0.98,  Angle = 91.61 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  GOUV_avant = {
    name  = "Garage Gouvernement",
    Pos   = { x = -524.40, y = -267.56, z = 34.63,  Angle = 110.78 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  GOUV_arriere = {
    name  = "Garage Gouvernement privé",
    Pos   = { x = -562.45, y = -163.71, z = 37.11,  Angle = 287.78 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  mosleygarage = {
  name  = "Mosley Garage Souterrain",
    Pos   = { x = -762.7, y = -986.93, z = 15.17 - 0.98, Angle = 30.58  },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },	

  bahama = {
  name  = "Bahama Garage",
  Pos   = { x = -1411.85, y = -591.79, z = 29.37,  Angle = 300.68 }, 
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  yellowjack = {
  name  = "Yellow Jack Garage",
  Pos   = { x = 2006.03, y = 3072.19, z = 46.05,  Angle = 57.97 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  Tabac = {
  name  = "Garage Entrepôt Tabac",
  Pos   = { x = 64.38, y = 157.48, z = 103.59, Angle = 253.72 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  Tabac_Magasin = {
  name  = "Garage Magasin Tabac",
  Pos   = { x = -50.31, y = -1047.34, z = 27.07,  Angle = 67.63 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  Journaliste = {
  name  = "Garage Journaliste",
  Pos   = { x = -1068.43, y = -233.14, z = 32.36, Angle = 209.28 }, 
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

    Journaliste2 = {
  name  = "Garage Dépot",
  Pos   = { x = -1051.02, y = -250.11, z = 36.94, Angle = 207.33 }, 
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  BWS = {
  name  = "Garage Blackwoods Saloon",
  Pos   = { x = -301.81, y = 6254.87, z = 30.50,  Angle = 223.45 },
  TypeZone = iV.Blips.Garage,
  Ped = { Text = "Miky", PedType = 4, Hash = "s_m_y_doorman_01", x = -60.72, y = 6390.08, z = 30.60,  Angle = 134.54, Scena = "WORLD_HUMAN_GUARD_STAND_CLUBHOUSE" },
  Action   = false,
  },

  Unicorn = {
  name  = "Garage Unicorn",
  Pos   = { x = 146.44, y = -1280.21, z = 28.05, Angle = 301.29 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  Casino = {
  name  = "Garage Casino",
  Pos   = { x = 910.81, y = 31.31, z = 79.22,  Angle = 327.0 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },	

  Assurance = {
  name  = "Garage Assurance",
  Pos   = { x = -851.22, y = -217.13, z = 36.59,  Angle = 302.85 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  UpnAtom = {
  name  = "Garage Up'N Atom",
  Pos   = { x = 116.08, y = 282.66, z = 108.97,  Angle = 339.55 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  AvocatJonesWade = {
  name  = "Garage Cabinet Avocat",
  Pos   = { x = -150.97, y = -617.97, z = 32.42 - 0.98, Angle = 59.84 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  avocat2 = {
  name   = "Maze Bank Tour",
  Pos    = { x = -50.44, y = -787.61, z = 43.07, Angle = 332.73 },
  TypeZone = iV.Blips.Garage,
  Ped = { Text = "Thomas", PedType = 6, Hash = "s_m_y_barman_01", x = -47.87, y = -782.94, z = 43.30,  Angle  = 239.75, Dict = "random@shop_gunstore", Anim = "_greeting" },
  Action   = true,
  },

  Avocat = {
    name  = "Garage Wallace Wade",
    Pos   = { x = -589.97, y = -356.15, z = 34.09, Angle = 88.82 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  BOLINGBROKE = {
  name  = "Garage BolingBroke",
  Pos   = { x = 1663.80, y = 2604.74, z = 44.56,  Angle = 269.87 },
  TypeZone = iV.Blips.Garage,
  Ped = { Text = "Peterson", PedType = 6, Hash = "s_m_m_prisguard_01", x = 1673.08, y = 2604.56, z = 44.56,  Angle = 269.87 },
  Action   = true,
  },

  weazelplazaapt = {
  name   = "Weazel Plaza Apartments",
  Pos    = { x = -932.27, y = -460.66, z = 36.18, Angle = 33.20 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  weazelnews = {
  name   = "Garage Pro Weazel News" ,
  Pos    = { x = -532.85, y = -889.78, z = 23.81, Angle = 182.54 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  weazelnews2 = {
  name   = "Garage Weazel News" ,
  Pos    = { x = -620.82, y = -917.03, z = 22.68, Angle = 181.06 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  LSPD1bis = {
    name  = "Garage LSPD Principal",
    Pos   = { x = 458.55, y = -1017.20, z = 28.20-0.98,  Angle = 95.22 },
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Agent", PedType = 6, Hash = "s_m_y_cop_01", x = 451.36, y = -1020.12, z = 28.41-0.90,  Angle = 94.09, Scena = "WORLD_HUMAN_COP_IDLES" },
    Action   = true,
  },

  LSPD1 = {
    name  = "RHPD Principal",
    Pos   = { x = -571.65, y = -92.76, z = 33.90-0.98,  Angle = 117.70 },
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Sarah O\'Connor", PedType = 6, Hash = "s_f_y_cop_01", x = -577.40, y = -94.79, z = 33.75-0.98,  Angle = 113.20, Scena = "WORLD_HUMAN_COP_IDLES" },
    Action   = true,
  },

  LSPD3 = {
    name  = "RHPD Gros véhicules",
    Pos   = { x = -600.38, y = -129.00, z = 33.90-0.98,  Angle = 31.95 }, 
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Agent 48", PedType = 6, Hash = "s_m_y_cop_01", x = 435.5, y = -975.8, z = 24.72,  Angle = 90.40, Scena = "WORLD_HUMAN_COP_IDLES" },
    Action   = true,
  },

  comicovespu = {
    name  = "Parking LSPD",
    Pos   = { x = -552.31, y = -143.50, z = 38.21-0.98, Angle = 59.40 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  LSPD2 = {
  name  = "Garage Shérif - Nord",
  Pos   = { x = 1829.74, y = 3684.97, z = 32.99, Angle = 30.92 },
  TypeZone = iV.Blips.Garage,
  Ped = { Text = "Samuel", PedType = 6, Hash = "csb_cop", x = 1825.16, y = 3691.88, z = 33.97-0.98,  Angle = 296.47, Scena = "WORLD_HUMAN_COP_IDLES" },
  Action   = true,
  },  

  BCSOPaleto = {
  name  = "Garage BCSO - Paleto",
  Pos   = { x = -454.63, y = 5994.13, z = 30.32, Angle = 43.07 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  PDP_Davis_Sheriff = {
    name  = "Garage Davis Sheriff PDP",
    Pos   = { x = 390.65, y = -1614.06, z = 28.29, Angle = 228.78 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
    },

  EMSNord = {
  name	= "Garage EMS - Nord",
  Pos   = { x = -284.98, y = 6326.83, z = 32.43-0.98,	Angle = 227.21 },
  TypeZone = iV.Blips.Garage,
  Ped = { Text = "Jones", PedType = 6, Hash = "s_m_m_paramedic_01", x = -279.84, y = 6321.54, z = 32.34-0.98,	Angle = 228.41 },
  Action   = true,
  },

  PillboxHill = {
    name  = "Pillbox Hill Garage",
    Pos   = { x = 299.40, y = -611.86, z = 42.45, Angle = 72.0 },
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Marc", PedType = 6, Hash = "s_m_m_paramedic_01", x = 295.15, y = -610.6319, z = 42.41-0.10, Angle = 69.39, Scena = "WORLD_HUMAN_SEAT_WALL" },
    Action   = true,
  },

  PillboxHill2 = {
    name  = "Urgences Pillbox",
    Pos   = { x = 325.56, y = -581.70, z = 27.75, Angle = 249.36 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  MountZonah = {
  name  = "Mount Zonah Garage",
  Pos   = { x = -483.85, y = -337.96, z = 34.30-1,  Angle = 264.90 },
  TypeZone = iV.Blips.Garage,
  Ped = { Text = "Papy", PedType = 4, Hash = "s_m_m_paramedic_01", x = -478.35, y = -338.79, z = 34.38-1, Angle = 170.13, Scena = "WORLD_HUMAN_SEAT_WALL" },
  Action   = true,
  },

  Eclypse_Hopital = {
    name  = 'Hopital Gordon McMillen Reed',
    Pos   = { x = -681.91, y = 370.38, z = 78.12-1,  Angle = 174.36 },
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Isaac", PedType = 4, Hash = "s_m_m_paramedic_01", x = -678.13, y = 362.66, z = 78.12-1, Angle = 84.89, Scena = "WORLD_HUMAN_LEANING" },
    Action   = true,
    },

  Mecano = {
  name  = "Garage Mécano Auto",
  Pos   = { x = -235.8, y = -1282.02, z = 31.29-0.98,  Angle = 270.50 },
  TypeZone = iV.Blips.Garage,
  Ped = { Text = "Brian", PedType = 5, Hash = "s_m_m_lathandy_01", x = -227.35, y = -1279.44, z = 31.3-0.98,  Angle = 175.85, Scena = "WORLD_HUMAN_LEANING" },
  Action   = true,
  },

  Mecano2 = {
  name  = "Garage Mécano Moto",
  Pos   = { x = 1164.02, y = 2662.27, z = 37.97-0.98,  Angle = 271.44 }, 
  TypeZone = iV.Blips.Garage,
  Ped = { Text = "Billy", PedType = 4, Hash = "s_m_m_gaffer_01", x = 1175.22, y = 2661.34, z = 37.10,  Angle = 353.46, Scena = "WORLD_HUMAN_LEANING" },
  Action   = true,
  },

  coffeeshop = {
  name   = "Garage Bean Machine",
  Pos    = { x = 113.27, y = -1054.2, z = 29.2-0.98,  Angle  = 244.82 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  EMS = {
  name  = "Garage EMS",
  Pos   = { x = 315.82, y = -545.16, z = 27.74,  Angle = 271.90 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  Taxi = {
  name  = "Garage Taxi",
  Pos   = { x = 900.56, y = -186.57, z = 73.79-1, Angle = 329.50},
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  phareouest = {
	name  = "Phare Ouest Garage",
    Pos   = { x = -697.01, y = 5772.24, z = 17.31-0.90,  Angle = 61.45 }, 
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  GalaxySud = {
    name  = "Garage Galaxy Sud",
    Pos   = { x = 273.38, y = -225.39, z = 52.96, Angle = 177.94 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },  

  Auto_Tamponeuse = {
    name  = "Garage Auto Tamponeuse",
    Pos   = { x = -1663.77, y = -1108.64, z = 12.12, Angle = 233.75 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  eight_pool_garage = {
    name  = "Garage 8 Pool Bar",
    Pos   = { x = -30.02, y = 6458.04, z = 30.45,  Angle = 222.95 },
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Marcus", PedType = 4, Hash = "ig_juanstrickler", x = -22.76, y = 6457.36, z = 31.42-0.98,  Angle  = 223.53, Scena = "WORLD_HUMAN_LEANING" },
    Action   = true,
    },

  wash_machhine_ped = {
    name  = "Wash Machine",
    Pos   = { x = -2604.59, y = 1916.18, z = 163.46 - 1.0, Angle = 187.18 },
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Trayvon", PedType = 4, Hash = "s_m_y_doorman_01", x = -2603.8, y = 1915, z = 160.71 - 1.0, Angle = 187.18, Scena = "WORLD_HUMAN_GUARD_STAND_CLUBHOUSE" },
    Action   = false,
    },

  -- Garage location vehicle
  Location1_Garage = {
    name  = "Garage location grap seed",
    Pos   = { x = 2242.3, y = 5162.51, z = 60.26-1.98,  Angle = 60.18 },
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Cletu", PedType = 5, Hash = "ig_cletus", x = 2237.04, y = 5165.98, z = 58.89-0.98,  Angle = 320.99, Scena = "PROP_HUMAN_SEAT_BENCH_DRINK_BEER" },
    Action   = true,
  },

  Location2_Garage = {
    name  = "Garage location ocean hightway",
    Pos   = { x = -1490.33, y = 4981.52, z = 63.36-0.98, Angle = 90.42 },
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Margarette", PedType = 5, Hash = "s_f_y_ranger_01", x = -1495.19, y = 4981.84, z = 62.96-0.98,  Angle = 353.6, Scena = "WORLD_HUMAN_COP_IDLES" },
    Action   = true,
  },

  ----------------------
  --  Groupe illégaux --
  ---------------------- 



  Morningwood_garage = {
  name  = "MorningWood Garage",
  Pos   = { x = -1573.65, y = -263.30, z = 47.27,  Angle = 166.19 },
  Angle = 166.19,
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },	

  Morningwood_garage = {
    name  = "Bloods Garage",
    Pos   = { x = -1546.52, y = -420.75, z = 40.99,  Angle = 48.78 },
    Angle = 48.78,
    TypeZone = iV.Blips.Garage,
    Action   = true,
    },

  Marabunta_3 = {
  name  = "East Los Santos Garage",
  Pos   = { x = 1302.62, y = -1706.93, z = 54.13,  Angle = 199.17 }, 
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },	

  Ballas = {
    name  = "Garage Ballas",
    Pos   = { x = 84.41, y = -1966.89, z = 19.90,  Angle = 257.62 },
    Ped   = { Text = "Tatie", PedType = 5, Hash = "s_f_m_fembarber", x = 90.12, y = -1966.27, z = 19.25,  Angle = 322.56, PosArrivVeh = vector4(96.92, -1957.96, 19.74, 322.56) },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },
  Burtons = {
    name  = "Burton Street",
    Pos   = { x = -371.20, y = 40.34, z = 50.10,  Angle = 96.37 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },
  Vagos = {
  name  = "Garage Vagos",
  Pos   = { x = 337.64, y = -2035.80, z = 21.38-0.98,  Angle = 135.61 },
  TypeZone = iV.Blips.Garage,
  Ped = { Text = "Lobo", PedType = 4, Hash = "g_m_y_mexgoon_01", x = 333.82, y = -2038.97, z = 21.07 - 0.98,  Angle = 49.94, Scena = "WORLD_HUMAN_DRUG_DEALER" },
  Action   = true,
  },	

  Franklin = {
  name  = "Families Garage",
  Pos   = { x = -24.29, y = -1437.21, z = 29.65,  Angle = 180.33 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  Franklin1 = {
  name  = "Chamberlain Hills",
  Pos   = { x = -187.37, y = -1586.26, z = 33.83,  Angle = 180.33 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  Vigne = {
  name  = "Garage Villa Leone",
  Pos   = { x = -1888.44, y = 2045.70, z = 140.86-0.98, Angle = 66.70 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  Lost_Sud = {
  name  = "Garage LOST MC South",
  Pos   = { x = 997.38, y = -126.93, z = 73.06, Angle = 57.90 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },


  Kkangpae = {
  name  = "Garage Kkangpae",
  Pos   = { x = -816.16, y = -730.99, z = 22.77,  Angle = 178.08 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  Wade = {
  name	= "Garage Famille Wade",
  Pos   = { x = 101.20, y = 64.92, z = 73.41-0.98,	Angle = 71.78 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  Psycho = {
  name  = "Garage Villa",
  Pos   = { x = -2661.04, y = 1307.34, z = 147.11-1,  Angle = 270.11 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  Psycho_1 = {
  name  = "Garage Bunker",
  Pos   = { x = 836.86, y = -3237.67, z = -98.69-1,  Angle = 261.31 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  LostMCStab = {
  name  = "Lost MC Stab City",
  Pos   = { x = 95.77, y = 3685.61, z = 38.60,  Angle = 2.61 },
  TypeZone = iV.Blips.Garage,
  Ped = { Text = "Mi-couilles", PedType = 4, Hash = "g_m_y_lost_01", x = 96.16, y = 3690.54, z = 38.56,  Angle = 83.61, Scena = "WORLD_HUMAN_SMOKING_CLUBHOUSE" },
  Action   = true,
  },

  MayansMCClub = {
    name  = "Mayans MC Garage Club",
    Pos   = { x = 23.78, y = 6465.57, z = 30.50,  Angle = 222.66 },
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Miguel Venom", PedType = 4, Hash = "u_m_m_aldinapoli", x = 28.44, y = 6462.51, z = 30.45, Angle = 220.89, Scena = "WORLD_HUMAN_LEANING" },
    Action   = true,
    },

    
  AOD_MC = {
    name  = "Garage AOD MC",
    Pos   = { x = 901.42, y = 3593.00, z = 32.02,  Angle = 175.08 },
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Prospect", PedType = 4, Hash = "s_m_y_ammucity_01", x = 909.54, y = 3588.94, z = 32.32,  Angle = 267.38, Scena = "WORLD_HUMAN_SMOKING_CLUBHOUSE" },
    Action   = true,
      },



  LostMCClub = {
    name  = "LOST MC Garage Extérieur",
    Pos   = { x = 966.22, y = -115.90, z = 73.35,  Angle = 220.79 },
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Prospect", PedType = 4, Hash = "g_m_y_lost_01", x = 966.08, y = -120.13, z = 73.39, Angle = 220.90, Scena = "WORLD_HUMAN_LEANING" },
    Action   = true,
     },  

  Gitan = {
  name  = "Garage à Niglos",
  Pos   = { x =2361.14, y = 3142.62, z = 48.21-0.98, Angle = 162.39 }, 
  TypeZone = iV.Blips.Garage,
  Ped = { Text = "Niglo", PedType = 5, Hash = "a_m_y_salton_01", x = 2355.85, y = 3140.37, z = 48.21-0.98, Angle = 78.19, Scena = "WORLD_HUMAN_LEANING" },
  Action   = true,
  },

  Oneil = {
  name  = "Ferme Garage",
  Pos   = { x = 2478.80, y = 4952.11, z = 44.03, Angle = 133.88 },
  TypeZone = iV.Blips.Garage,
  Action   = true,
  },

  Mara = {
	name  = "Mara Garage",
    Pos   = { x = 1412.42, y = -1500.66, z = 58.81,  Angle = 190.70 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Mara_2 = {
	name  = "Garage Mara west",
    Pos   = { x = 1271.04, y = -1607.35, z = 53.89 - 0.98,  Angle = 26.02 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },
  
  Madrazo = {
    name  = "Garage Fuente Blanca",
      Pos   = { x = 1390.22, y = 1117.13, z = 114.00,  Angle = 90.00 },
      TypeZone = iV.Blips.Garage,
      Action   = true,
    },

    
  Darksmile = {
    name  = "Garage QG D.S",
      Pos   = { x = 320.16, y = -2734.20, z = 5.95 - 0.98,  Angle = 8.89 },
      TypeZone = iV.Blips.Garage,
      Ped = { Text = "Daddy", PedType = 4, Hash = "ig_dale", x = 321.55, y = -2729.03, z = 4.99,  Angle = 107.72, Scena = "WORLD_HUMAN_LEANING" },
      Action   = true,
  },

  Monetti = {
    name  = "Garage La Firme",
      Pos   = { x = -129.34, y = 1003.47, z = 235.73 - 0.98,  Angle = 196.03 },
      TypeZone = iV.Blips.Garage,
      Action   = true,
    },
  

  

  ----------------------
  --     Autres       --
  ----------------------


  VillaPlayboy_Garage = {
    name   = "Playboy Richman Garage",
    Pos    = { x = -1530.25, y = 85.13, z = 56.68-0.98,  Angle  = 318.78 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  ComedyClub = {
    name   = "Comedy Club Garage",
    Pos    = { x = -420.81, y = 294.00, z = 83.22-0.98,  Angle  = 263.71 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  aptlittleseoul = {
    name   = "7302 Little Seoul",
    Pos    = { x = -477.11, y = -741.31, z = 29.58, Angle = 271.81 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  aptaltastreet = {
    name   = "3 Alta Street",
    Pos    = { x = -304.44, y = -986.99, z = 30.10, Angle = 339.98 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  vinewood_house_3 = {
    name   = "Garage Vinewood House 3",
    Pos    = { x = -552.97, y = 831.43, z = 197.97-0.98, Angle = 342.50 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  chumsashhouse1 = {
    name   = "Garage Yellow House",
    Pos    = { x = -3176.60, y = 1298.04, z = 13.61,  Angle  = 250.50 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  paletohouse1 = {
    name   = "Garage Maison Paleto",
    Pos    = { x = -432.48, y = 6265.62, z = 29.27,  Angle  = 253.17 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  paletohouse2 = {
    name   = "Garage Maison Paleto 2",
    Pos    = { x = -437.65, y = 6204.36, z = 28.66,  Angle  = 282.21 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  paletohouse3 = {
    name   = "Garage Maison Paleto 3",
    Pos    = { x = -395.13, y = 6310.65, z = 28.15,  Angle  = 218.47 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  paletohouse4 = {
    name   = "Garage Maison Paleto 4",
    Pos    = { x = -360.78, y = 6328.97, z = 28.85,  Angle  = 220.67 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  paletohouse5 = {
    name   = "Garage Maison Paleto 5",
    Pos    = { x = -250.76, y = 6408.69, z = 30.25,  Angle  = 216.52 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  paletohouse6 = {
    name   = "Garage Maison Paleto 6",
    Pos    = { x = -221.91, y = 6433.31, z = 30.29,  Angle  = 228.51 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  paletohouse7 = {
    name   = "Garage Maison Paleto 7",
    Pos    = { x = -114.65, y = 6570.39, z = 28.54,  Angle  = 224.97 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  paletohouse8 = {
    name   = "Garage Maison Paleto 8",
    Pos    = { x = -15.72, y = 6644.47, z = 30.19,  Angle  = 208.52 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  paletohouse9 = {
    name   = "Garage Maison Paleto 9",
    Pos    = { x = 21.52, y = 6660.09, z = 30.62,  Angle  = 185.37 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },
  
  paletohouse10 = {
    name   = "Garage Maison Paleto 10",
    Pos    = { x = -263.27, y = 6404.23, z = 30.06,  Angle  = 214.70 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  paletohouse11 = {
    name   = "Garage Maison Paleto 11",
    Pos    = { x = -52.15, y = 6621.24, z = 29.03,  Angle  = 222.30 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  sandyshorehouse1 = {
    name  = "2nd/3rd Marina Drive",
    Pos   = { x = 1806.53, y = 3934.31, z = 33.66-0.98, Angle = 99.19 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  sandyshorehouse2 = {
    name  = "26 Marina Drive",
    Pos   = { x = 1672.10, y = 3819.52, z = 34.91-0.98, Angle = 312.11 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  sandyshorehouse3 = {
    name  = "16 Armadillo Avenue",
    Pos   = { x = 1832.17, y = 3877.72, z = 33.55-0.98, Angle = 114.41 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  sandyshorehouse4 = {
    name  = "1st Niland Avenue",
    Pos   = { x = 1896.82, y = 3806.74, z = 32.30-0.98, Angle = 32.25 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  sandyshorehouse5 = {
    name  = "1st Lesbos Lane",
    Pos   = { x = 1447.41, y = 3656.80, z = 34.28-0.98, Angle = 22.08 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  alamoseahouse = {
    name  = "Alamo Sea Calafia Way",
    Pos   = { x = 714.18, y = 4175.06, z = 40.70-0.98, Angle = 276.55 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  grapeseedhouse1 = {
    name  = "24 Grapeseed Avenue",
    Pos   = { x = 1666.22, y = 4769.10, z = 41.96-0.98, Angle = 278.93 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  grapeseedhouse2 = {
    name  = "15 Grapeseed Avenue",
    Pos   = { x = 1714.53, y = 4668.75, z = 43.07-0.98, Angle = 91.52 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  grapeseedhangar = {
    name  = "2nd Seaview Road",
    Pos   = { x = 2553.03, y = 4676.39, z = 33.91-0.98, Angle = 21.87 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  sandyshorehangar = {
    name  = "1st Zancudo River",
    Pos   = { x = 389.36, y = 3592.34, z = 33.29-0.98, Angle = 85.81 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  lsporthangar = {
    name  = "2047 Elysian Island",
    Pos   = { x = -260.42, y = -2586.28, z = 6.00-0.98, Angle = 90.69 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  paletohangar = {
    name  = "24 Gt Ocean Highway",
    Pos   = { x = 139.43, y = 6361.39, z = 31.37-0.98, Angle = 30.42 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  pacific_banque = {
    name   = "Garage Pacific Standard", 
    Pos    = { x = 249.81, y = 192.22, z = 104.92-0.98, Angle  = 74.43 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },
	
  villastony = {
    name   = "Garage Villa Vinewood",
    Pos    = { x = -721.35, y = 509.19, z = 108.32,  Angle  = 204.17 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  gitan2 = {
    name   = "Le Gite \"Hano\"",
    Pos    = { x = 1505.44, y = 6329.41, z = 23.10,  Angle  = 335.56 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },  

  villa_lac = {
    name   = "Garage Villa Lac", 
    Pos    = { x = -161.67, y = 927.48, z = 235.65-0.98, Angle  = 225.49 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  PiwelCabane = {
    name   = "Cabane Mont Chilliad",
    Pos    = { x = 345.12, y = 4423.08, z = 63.60,  Angle  = 303.81 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

	BlackwoodSaloon_Farmhouse = {
	  name  = "Farmhouse Garage",
    Pos   = { x = 2133.44, y = 4782.48, z = 40.97-0.99,  Angle = 25.53 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

	LPW = {
	  name = "LPW Garage",
    Pos  = { x = -324.49, y = -1356.14, z = 30.29, Angle = 82.44 }, 
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Jason", PedType = 6, Hash = "s_m_y_xmech_02", x = -331.86, y = -1352.50, z = 30.31, Angle = 178.20 },
    Blips    = 0.5,
    Action   = true,
  },

  mboubar = {
    name  = "Garage Vespuci Beach",
      Pos   = { x = -1164.54, y = -1744.49, z = 3.01,  Angle = 194.78 }, 
      TypeZone = iV.Blips.Garage,
      Action   = true,
  },

  lscustomair = {
	name  = "LSCustom Airport Garage",
    Pos   = { x = -1150.88, y = -1982.65, z = 12.16,  Angle = 269.36 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Mirrorpark = {
	name  = "Mirror Drive Garage",
    Pos   = { x = 1097.37, y = -429.06, z = 66.28,  Angle = 82.54 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },  

  playboy = {
    name  = "Garage Salvatore",
    Pos   = { x = -808.39, y = 164.93, z = 70.56, Angle = 205.49 }, 
    Ped = { Text = "Luigi", PedType = 9, Hash = "cs_chengsr", x = -806.02, y = 162.40, z = 70.53, Angle = 110.47 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  ghost2 = {
    name  ="Garage Villa G",
    Pos   = { x = -1065.12, y = -68.81, z = -90.19-0.98,  Angle =177.18 },
    Ped = { Text = "André", PedType = 9, Hash = "s_m_m_strpreach_01", x = -1065.12, y = -74.77, z = -90.14-0.98,  Angle = 80.28, Scena = "WORLD_HUMAN_LEANING" },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },	

  siara = {
    name  ="Vespucci Garage", 
    Pos   = { x = -1186.05, y = -948.73, z = 3.05,  Angle = 216.52 }, 
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Little_garage = {
    name  = "Little Seoul Garage",
    Pos   = { x = -677.51, y = -879.79, z = 23.46,  Angle = 98.07 }, 
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },	

  concess = {
    name  = "Concessionnaire Auto",
    Pos   = { x = -52.01, y = -1110.28, z = 25.43,  Angle = 70.38 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },	


  fouriere = {
    name  = "Fourrière Centre Ville",
    Pos   = { x = 411.23, y = -1636.89, z = 28.29,  Angle = 232.86 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },	
	
  Vinehood_Big_House = {
	name  = "Vinewood Hills Garage",
	Pos    = { x = -676.69, y = 903.91, z = 229.58,  Angle = 327.81 }, 
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  VinewoodWest = {
    name  = "Vinewood West Garage",
    Pos    = { x = -126.39, y = -22.07, z = 57.30,  Angle = 158.00 }, 
      TypeZone = iV.Blips.Garage,
      Action   = true,
  },

  Grove = {
    name  = "Grove Street Garage",
    Pos   = { x = -54.08, y = -1835.37, z = 25.57, Angle = 318.90 },
    Angle = 318.90,
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Aeroport = {
    name  = "Garage Perceval",
    Pos   = { x = -950.07, y = -2074.76, z = 8.45,  Angle = 226.48 },
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Leroy", PedType = 4, Hash = "g_m_y_ballaeast_01", x = -943.00, y = -2081.47, z = 8.45,  Angle = 225.71, Scena = "WORLD_HUMAN_GUARD_STAND_CLUBHOUSE" },
    Action   = true,
  },	

  GaragePaleto = {
    name  = "Garage Paleto",
    Pos   = { x = 126.18, y = 6608.45, z = 30.85,  Angle = 230.00 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },	

  GarageMiddle = {
    name  = "Sandy Shores Market Garage",
    Pos   = { x = 2768.46, y = 3463.06, z = 54.62, Angle = 252.74 },
    Ped = { Text = "Lewis", PedType = 9, Hash = "cs_martinmadrazo", x = 2776.73, y = 3460.19, z = 54.54, Angle = 157.00 },
    TypeZone = iV.Blips.Garage,
    Blips    = 0.6,
    Action   = true,
  },	

  GarageCentre2 = {
    name  = "Central Bank Garage",
    Pos   = { x = 378.69, y = 287.85, z = 102.15,  Angle = 70.09 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },	

  GarageCentre3 = {
    name  = "Rockford Hills Garage",
    Pos   = { x = -898.92, y = -152.36, z = 40.88, Angle = 126.51}, 
    Ped = { Text = "Virginy", PedType = 5, Hash = "a_f_y_vinewood_03", x = -903.87, y = -155.66, z = 41.88-0.98, Angle = 31.98 },
    TypeZone = iV.Blips.Garage,
    Blips    = 0.6,
    Action   = true,
  },

  Parking = {
    name  = "Parking Central",
    Pos   = { x = 215.47, y = -808.77, z = 29.75, Angle = 251.80 }, 
    TypeZone = iV.Blips.Garage,
    Ped = { Text = "Noah", PedType = 5, Hash = "a_m_y_eastsa_02", x = 232.53, y = -790.76, z = 29.62, Angle = 160.00 },
    Blips    = 0.6,
    Action   = true,
  },		

  Arena2 = {
    name  = "Factory Garage",
    Pos   = { x = 979.04, y = -1817.90, z = 30.17,  Angle = 83.60 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Entrepot = {
    name  = "Garage Entrepot 1",
    Pos   = { x = 924.53, y = -1563.83, z = 29.72,  Angle = 81.34 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },	
	
  Motel = {
    name  = "Garage Motel 1",
    Pos   = { x = 364.69, y = 2636.91, z = 43.49, Angle = 225.57 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Motel2 = {
    name  = "Garage Motel 2",
    Pos   = { x = -89.74, y = 6342.94, z = 30.49,  Angle = 317.89 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Villa1 = {
    name  = "Garage Villa 1",
    Pos   = { x = 360.10, y = 439.28, z = 144.04,  Angle = 269.35 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Villa2 = {
    name  = "Garage Villa 2",
    Pos   = { x = 130.81, y = 568.98, z = 182.31, Angle = 292.65 },
    Angle = 292.65,
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Villa3 = {
    name  = "Garage Villa 3",
    Pos   = { x = -188.37, y = 503.08, z = 133.49,  Angle = 82.33 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Villa4 = {
    name  = "Garage Villa 4",
    Pos   = { x = -684.41, y = 603.90, z = 142.64,  Angle = 107.35 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Villa5 = {
    name  = "Garage Villa 5",
    Pos   = { x = -752.34, y = 627.99, z = 141.45,  Angle = 358.73 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Villa6 = {
    name  = "Garage Villa 6",
    Pos   = { x = -863.05, y = 700.31, z = 148.04, Angle = 348.39 }, 
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Villa7 = {
    name  = "Garage Villa 7",
    Pos   = { x = -1271.86, y = 451.77, z = 93.97,  Angle = 16.54 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },  

  Villa8 = {
    name  = "Garage Villa 8",
    Pos   = { x = -1036.84, y = 591.57, z = 102.12, Angle = 2.73 }, 
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Appart1 = {
    name  = "Garage Appartement 1",
    Pos   = { x = -796.15, y = 323.46, z = 84.70,  Angle = 177.91 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Appart2 = {
    name  = "Garage Appartement 2",
    Pos   = { x = -623.49, y = 56.52, z = 42.72,  Angle = 88.00 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Appart3 = {
    name  = "Garage Appartement 3",
    Pos   = { x = 459.49, y = -281.24, z = 47.64, Angle = 159.33 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Appart4 = {
    name  = "Garage Appartement 4",
    Pos   = { x = -886.63, y = -343.21, z = 33.53,   Angle = 204.16, },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Appart5 = {
    name  = "Garage Appartement 5",
    Pos   = { x = -1474.77, y = -502.65, z = 31.80, Angle = 307.11 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Appart6 = {
    name  = "Garage Gruppe6",
    Pos   = { x = -34.86, y = -673.32, z = 31.33,  Angle = 190.63 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Appart62 = {
    name  = "Garage Privé Apt 6",
    Pos   = { x = -37.90, y = -620.05, z = 34.07,  Angle = 249.22 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Appart7 = {
    name  = "Garage Appartement 7",
    Pos   = { x = 331.45, y = -1160.25, z = 28.29, Angle = 357.88 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  Appart8 = {
    name  = "Garage Appartement 8",
    Pos   = { x = -987.12, y = -1452.35, z = 4.99 - 0.98, Angle = 104.87 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },	

  Appart35 = {
    name  = "Garage Appartement 35",
    Pos   = { x = -460.89, y = -619.27, z = 30.17, Angle = 88.05 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },	

  Pizza = {
    name  = "Garage Pizzeria",
    Pos   = { x = 339.92, y = -950.91, z = 28.43, Angle = 140.23 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },	

  Chauffeur = {
    name  = "Garage Mall Chauffeur",
    Pos   = { x = 49.13, y = -1740.99, z = 28.30,   Angle = 51.17 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },	

  Studio_nord = {
    name  = "Garage Studio Nord",
    Pos   = { x = 2462.96, y = 4074.88, z = 37.06, Angle = 249.71 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },  

  Garage_DS = {
    name  = "Garage DidierSachs",
    Pos   = { x = -249.51, y = -244.41, z = 36.51-0.98, Angle = 4.74 },
    TypeZone = iV.Blips.Garage,
    Action   = true,
  },

  MarinaLaPuerta = {
    name  = "Garage Marina la puerta",
    Pos   = { x = -817.3, y = -1309.35, z = 5-0.98, Angle = 353.62 },
    Angle = 353.62,
    TypeZone = iV.Blips.Garage,
    Action   = true
  },

}