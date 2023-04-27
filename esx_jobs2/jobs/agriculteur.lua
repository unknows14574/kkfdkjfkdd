Config_esx_jobs2.Jobs.agriculteur = {
  BlipInfos = {
    Sprite = 478,
    Color = 33
  },
  Vehicles = {
    Truck = {
      Spawner = 1,
      Hash = "mule",
      Trailer = "none",
      HasCaution = false
    }
  },
  Zones = {
    CloakRoom = {
      Pos   = {x = 417.50, y = 6520.76, z = 27.71-0.7},--ok
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "entreprise de agriculture",
      Type  = "cloakroom",
      Hint  = 'appuyez sur ~y~E~s~ pour vous changer.',
      --GPS = {x = -1911.53, y = 2071.68, z = 139.48}
    },

    FarmFruit = {
      Pos   = {x = 239.98, y = 6514.07, z = 31.16-0.7},--ok
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'fruit',
      Type  = "work",
      Item  = {
        {
          name   = 'fruit',
          db_name= "fruit",
          time   = 3000,
          max    = 100,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 100
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour récolté.',
      --GPS = {x = 1207.19, y = 1857.35, z = 77.99},
    },

    VehicleSpawner = {
      Pos   = {x = 422.29, y = 6479.21, z = 28.81-0.7},--ok
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = false,
      Name  = 'spawner véhicule de fonction',
      Type  = "vehspawner",
      Spawner = 1,
      Hint  = 'appuyez sur ~y~E~s~ pour appeler le véhicule de livraison.',
      Caution = 100,
      --GPS = {x = -1749.54, y = 2381.67, z = 44.93}
    },

    VehicleSpawnPoint = {
      Pos   = {x = 421.62, y = 6474.93, z = 28.81-0.7},--ok
      Size  = {x = 5.0, y = 5.0, z = 1.0},
      Marker= -1,
      Blip  = false,
      Name  = 'véhicule de fonction',
      Type  = "vehspawnpt",
      Spawner = 1,
      Heading = 47.0,
      --GPS = 0
    },

    VehicleDeletePoint = {
      Pos   = {x = 428.09, y = 6469.46, z = 28.78-0.7},--ok
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = false,
      Name  = 'supression du véhicule',
      Type  = "vehdelete",
      Hint  = 'appuyez sur ~y~E~s~ pour rendre le véhicule.',
      Spawner = 1,
      Caution = 100,
      --GPS = 0,
      Teleport = 0
    },

    VenteFruit = {
      Pos   = {x = 148.45, y = 1665.50, z = 228.96-0.7},--ok
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'revente de fruits',
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'livraison',
          time   = 3000,
          remove = 1,
          max    = 100, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
          price  = 7,
          requires = "fruit",
          requires_name = 'fruit',
          drop   = 100
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour vendre.',
      --GPS = {x = -1749.52, y = 2181.58, z = 44.97}--ok
    },

  },
}
