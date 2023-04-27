Config_esx_jobs.Jobs.beer = {
  BlipInfos = {
    Sprite = 468,
    Color = 2
  },
  Vehicles = {
    Truck = {
      Spawner = 1,
      Hash = "speedobox",
      Trailer = "none",
      HasCaution = false,
	  Livery = 1
    }
  },
  Zones = {
  
    Entreprise = {
      Pos   = {x = 939.59, y = -1457.47, z = 31.39-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
	  Blip  = true,
      Name  = "Beer & Love"
    },

    Recolte = {
      Pos   = {x = 2622.31, y = 4616.94, z = 34.49-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "Récolte d'orges",
      Type  = "work",
      Item  = {
        {
          name   = "Orge",
          db_name= "orge",
          time   = 3000,
          max    = 25,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 100
        }
      },
      Time   = 1000,
      Hint  = "Appuyez sur ~y~E~s~ pour récolter de l'orges.",
      GPS = 0
    },

    Traitement = {
      Pos   = {x = 1207.19, y = 1857.35, z = 77.99-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "Traitement de bieres",
      Type  = "work",
      Item  = {
        {
          name   = "Biere",
          db_name= "beer2",
          time   = 3000,
          max    = 25,
          add    = 1,
          remove = 2,
          requires = "orge",
          requires_name = "Orge",
          drop   = 100
        },
      },
      Time   = 1000,
      Hint  = "Appuyez sur ~y~E~s~ pour mettre en bouteilles.",
      GPS = 0
    },
	
    VehicleSpawner = {
      Pos   = {x = 946.81, y = -1457.66, z = 31.40-0.95-0.7},
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
      Pos   = {x = 943.27, y = -1453.00, z = 31.13},
      Size  = {x = 1.0, y = 1.0, z = 1.0},
      Marker= -1,
      Blip  = false,
      Name  = 'véhicule de fonction',
      Type  = "vehspawnpt",
      Spawner = 1,
      Heading = 1.09,
      GPS = 0
    },

    VehicleDeletePoint = {
      Pos   = {x = 943.29, y = -1456.66, z = 31.35-0.7},
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
      Pos   = {x = 1170.90, y = -425.20, z = 67.09-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "Vente de bieres",
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 3000,
          remove = 1,
          max    = 100,
          price  = 16,
          requires = "beer2",
          requires_name = "Biere",
          drop   = 100
        }
      },
      Time   = 1000,
      Hint  = "Appuyez sur ~y~E~s~ pour vendre.",
      GPS = 0
    },

  },
}
