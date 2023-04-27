Config_esx_jobs2.Jobs.brinks = {
  BlipInfos = {
    Sprite = 616,
    Color = 28
  },
  Vehicles = {
    Truck = {
      Spawner = 1,
      Hash = "stockade",
      Trailer = "none",
      HasCaution = false
    }
  },
  Zones = {
  
    Entreprise = {
      Pos   = {x = 9.19, y = -661.23, z = 33.44-0.7},
      Color = {r = 0, g = 90, b = 255},
      Size  = {x = 1.2, y = 1.2, z = 10.0},
      Marker= 25,
	  Blip  = true,
      Name  = "Brinks"
    },

    Recolte = {
      Pos   = {x = -125.91, y = 6477.91, z = 31.46},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "Ramassage de billets",
      Type  = "work",
      Item  = {
        {
          name   = "Billets",
          db_name= "billet",
          time   = 3000,
          max    = 25,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 100
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour prends les billets.",
      GPS = 0
    },
	
    VehicleSpawner = {
      Pos   = {x = -12.44, y = -669.69, z = 32.44-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = false
      --Name  = 'spawner véhicule de fonction',
      --Type  = "vehspawner",
      --Spawner = 1,
      --Hint  = 'appuyez sur ~y~E~s~ pour appeler le véhicule de livraison.',
      --Caution = 100,
      --GPS = 0
    },

    VehicleSpawnPoint = {
      Pos   = {x = -5.49, y = -670.90, z = 31.73-0.90},
      Size  = {x = 1.0, y = 1.0, z = 1.0},
      Marker= -1,
      Blip  = false,
      Name  = 'véhicule de fonction',
      Type  = "vehspawnpt",
      Spawner = 1,
      Heading = 183.63,
      GPS = 0
    },

    VehicleDeletePoint = {
      Pos   = {x = -19.29, y = -670.89, z = 32.33-0.98},
      Size  = {x = 3.0, y = 3.0, z = 1.0},
      Color = {r = 166, g = 0, b = 0},
      Marker= 25,
      Blip  = false
      --Name  = 'supression du véhicule',
      --Type  = "vehdelete",
      --Hint  = 'appuyez sur ~y~E~s~ pour rendre le véhicule.',
      --Spawner = 1,
      --Caution = 100,
      --GPS = 0,
      --Teleport = 0
    },

    Vente = {
      Pos   = {x = 158.39, y = -1036.68, z = 29.19-0.98},
      Color = {r = 0, g = 0, b = 0},
      Size  = {x = 8.0, y = 8.0, z = 3.0},
      Marker= -1,
      Blip  = true,
      Name  = "Point de livraison",
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 3000,
          remove = 1,
          max    = 50,
          price  = 14,
          requires = "billet",
          requires_name = "Billet",
          drop   = 100
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour livrer les billets.",
      GPS = 0
    },

  },
}
