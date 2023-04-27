Config_esx_jobs.Jobs.vignerons = {
  BlipInfos = {
    Sprite = 468,
    Color = 27
  },
  Vehicles = {
    Truck = {
      Spawner = 1,
      Hash = "kamacho",
      Trailer = "none",
      HasCaution = false
    }
  },
  Zones = {
    CloakRoom = {
      Pos   = {x = -1888.29, y = 2049.53, z = 140.08},--ok
      Size  = {x = 2.0, y = 2.0, z = 1.0},
      Color = {r = 0, g = 0, b = 0},
      Marker= 25,
      Blip  = true,
      Name  = "entreprise de vignerons",
      Type  = "cloakroom",
      Hint  = 'appuyez sur ~y~E~s~ pour vous changer.',
      GPS = {x = -1911.53, y = 2071.68, z = 139.48}--ok
    },

    Vigne = {
      Pos   = {x = -1749.54, y = 2381.67, z = 44.93},--ok
      Size  = {x = 4.0, y = 4.0, z = 1.0},
      Color = {r = 0, g = 0, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'raisin',
      Type  = "work",
      Item  = {
        {
          name   = 'raisin',
          db_name= "raisin",
          time   = 1000,
          max    = 20,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 100
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour récupérer des raisins.',
      GPS = {x = 1207.19, y = 1857.35, z = 77.99},--ok
    },

    Cave = {
      Pos   = {x = 1207.19, y = 1857.35, z = 77.99},--ok
      Size  = {x = 4.0, y = 4.0, z = 1.0},
      Color = {r = 0, g = 0, b = 0},
      Marker= 25,
      Blip  = true,
      Name  = 'Cave',
      Type  = "work",
      Item  = {
        {
          name   = 'vin blanc',
          db_name= "vblanc",
          time   = 1000,
          max    = 20,
          add    = 1,
          remove = 2,
          requires = "raisin",
          requires_name = "raisin",
          drop   = 100
        },
      },
      Hint  = 'appuyez sur ~y~E~s~ pour mettre en bouteille les raisins.',
      GPS = {x = -169.79, y = 283.72, z = 92.76}
    },
	
    VehicleSpawner = {
      Pos   = {x = -1911.53, y = 2071.68, z = 139.48},--ok
      Size  = {x = 2.0, y = 2.0, z = 1.0},
      Color = {r = 0, g = 0, b = 0},
      Marker= 25,
      Blip  = false,
      Name  = 'spawner véhicule de fonction',
      Type  = "vehspawner",
      Spawner = 1,
      Hint  = 'appuyez sur ~y~E~s~ pour appeler le véhicule de livraison.',
      Caution = 100,
      GPS = {x = -1749.54, y = 2381.67, z = 44.93}--ok
    },

    VehicleSpawnPoint = {
      Pos   = {x = -1909.98, y = 2050.35, z = 139.83},--ok
      Size  = {x = 5.0, y = 5.0, z = 1.0},
      Marker= -1,
      Blip  = false,
      Name  = 'véhicule de fonction',
      Type  = "vehspawnpt",
      Spawner = 1,
      Heading = 47.0,
      GPS = 0
    },

    VehicleDeletePoint = {
      Pos   = {x = -1903.91, y = 2056.87, z = 139.82},--ok
      Size  = {x = 3.0, y = 3.0, z = 1.0},
      Color = {r = 166, g = 0, b = 0},
      Marker= 25,
      Blip  = false,
      Name  = 'supression du véhicule',
      Type  = "vehdelete",
      Hint  = 'appuyez sur ~y~E~s~ pour rendre le véhicule.',
      Spawner = 1,
      Caution = 100,
      GPS = 0,
      Teleport = 0
    },

    Vinblanc = {
      Pos   = {x = -169.79, y = 283.72, z = 92.76},--ok
      Color = {r = 0, g = 0, b = 0},
      Size  = {x = 4.0, y = 4.0, z = 3.0},
      Marker= 25,
      Blip  = true,
      Name  = 'revente de vin blanc',
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 1000,
          remove = 1,
          max    = 100, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
          price  = 15,
          requires = "vblanc",
          requires_name = 'vin blanc',
          drop   = 100
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour livrer le vin blanc.',
      GPS = {x = 1174.83, y = -397.37, z = 66.92},--ok
    },


  },
}
