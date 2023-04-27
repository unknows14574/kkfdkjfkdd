Config_esx_jobs.Jobs.bijoutier = {
  BlipInfos = {
    Sprite = 617,
    Color = 28
  },
  Vehicles = {
    Truck = {
      Spawner = 1,
      Hash = "speedobox",
      Trailer = "none",
      HasCaution = false,
	  Livery = 2
    }
  },
  Zones = {
  
    Entreprise = {
      Pos   = {x = -629.44, y = -228.53, z = 38.05-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
	  Blip  = true,
      Name  = "Bijouterie Vangelico"
    },

    Recolte = {
      Pos   = {x = 1015.76, y = 2905.85, z = 41.36-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "Récolte pierres précieuse",
      Type  = "work",
      Item  = {
        {
          name   = "Pierre",
          db_name= "pierre",
          time   = 3000,
          max    = 100,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 100
        }
      },
      Time   = 1000,
      Hint  = "Appuyez sur ~y~E~s~ pour récolter des pierres.",
      GPS = 0
    },

    Traitement = {
      Pos   = {x = 844.29, y = -2361.44, z = 30.44-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "Traitement des pierres",
      Type  = "work",
      Item  = {
        {
          name   = "Saphir",
          db_name= "saphir",
          time   = 1000,
          max    = 50,
          add    = 1,
          remove = 2,
          requires = "pierre",
          requires_name = "pierre",
          drop   = 100
        },
		{
          name   = "Rubis",
          db_name= "rubis",
          max    = 50,
          add    = 1,
          drop   = 50
        },
		{
          name   = "Emeraude",
          db_name= "emeraude",
          max    = 50,
          add    = 1,
          drop   = 50
        },
      },
      Hint  = "Appuyez sur ~y~E~s~ pour tailler les pierres.",
      GPS = 0
    },
	
    VehicleSpawner = {
      Pos   = {x = -661.61, y = -220.12, z = 37.73-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = false,
      Name  = 'spawner véhicule de fonction',
      Type  = "vehspawner",
      Spawner = 1,
      Hint  = 'appuyez sur ~y~E~s~ pour appeler le véhicule de livraison.',
      Caution = 100,
      GPS = 0
    },

    VehicleSpawnPoint = {
      Pos   = {x = -667.00, y = -220.97, z = 37.31},
      Size  = {x = 1.0, y = 1.0, z = 1.0},
      Marker= -1,
      Blip  = false,
      Name  = 'véhicule de fonction',
      Type  = "vehspawnpt",
      Spawner = 1,
      Heading = 53.63,
      GPS = 0
    },

    VehicleDeletePoint = {
      Pos   = {x = -673.37, y = -227.59, z = 37.09-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = false,
      Name  = 'supression du véhicule',
      Type  = "vehdelete",
      Hint  = 'appuyez sur ~y~E~s~ pour rendre le véhicule.',
      Spawner = 1,
      Caution = 100,
      GPS = 0,
      Teleport = 0
    },

    Vente = {
      Pos   = {x = -636.90, y = -231.95, z = 37.85-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = false,
      Name  = "Vente de saphir",
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 1000,
          remove = 1,
          max    = 100,
          price  = 8,
          requires = "saphir",
          requires_name = "Saphir",
          drop   = 100
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour vendre le saphir.",
      GPS = 0
    },
	
	--[[Vente1 = {
      Pos   = {x = -627.98, y = -244.54, z = 38.29-0.95},
      Color = {r = 0, g = 0, b = 0},
      Size  = {x = 2.8, y = 2.8, z = 3.0},
      Marker= 25,
      Blip  = false,
      Name  = "Vente de diamant",
      Type  = "delivery",
      Spawner = 1,
      Item  = {
		{
          name   = 'point de livraison',
          time   = 3000,
          remove = 1,
          max    = 100,
          price  = 50,
          requires = "diamond",
          requires_name = "Diamond",
          drop   = 100
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour vendre le diamant.",
      GPS = 0
    },]]
	
	Vente2 = {
      Pos   = {x = -634.53, y = -235.57, z = 37.98-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = false,
      Name  = "Vente de rubis",
      Type  = "delivery",
      Spawner = 1,
      Item  = {
		{
          name   = 'point de livraison',
          time   = 3000,
          remove = 1,
          max    = 100,
          price  = 9,
          requires = "rubis",
          requires_name = "Rubis",
          drop   = 100
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour vendre le rubis.",
      GPS = 0
    },
	
	Vente3 = {
      Pos   = {x = -630.49, y = -241.18, z = 38.16-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = false,
      Name  = "Vente d'emeraude",
      Type  = "delivery",
      Spawner = 1,
      Item  = {
		{
          name   = 'point de livraison',
          time   = 3000,
          remove = 1,
          max    = 100,
          price  = 10,
          requires = "emeraude",
          requires_name = "Emeraude",
          drop   = 100
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour vendre l'emeraude.",
      GPS = 0
    }


  },
}
