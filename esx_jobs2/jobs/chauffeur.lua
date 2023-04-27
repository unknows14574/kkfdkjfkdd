Config_esx_jobs2.Jobs.chauffeur = {
  BlipInfos = {
    Sprite = 478,
    Color = 9
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
      Pos   = {x = 868.51, y = -1639.89, z = 30.33-0.98},
      Size  = {x = 1.3, y = 1.3, z = 1.0},
      Color = {r = 204, g = 204, b = 0},
      Marker= 1,
      Blip  = true,
      Name  = "Vestiaire",
      Type  = "cloakroom",
      Hint  = 'appuyez sur ~y~E~s~ pour vous changer.',
      GPS = {x = 554.597, y = -2314.43, z = 4.86293}
    },

    Farm = {
      Pos   = {x = -56.41, y = 6524.43, z = 31.49-0.98},
      Size  = {x = 8.0, y = 8.0, z = 1.0},
      Color = {r = 255, g = 0, b = 0},
      Marker= 25,
      Blip  = true,
      Name  = "Récolte de marchandises",
      Type  = "work",
      Item  = {
        {
          name   = "Carton de marchandises",
          db_name= "marchandise",
          time   = 3000,
          max    = 25,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 100
        }
      },
      Hint  = 'Appuyez sur ~y~E~s~ pour prendre un carton.',
      GPS = {x = 2736.94, y = 1417.99, z = 23.4888}
    },

    VehicleSpawner = { 
      Pos   = {x = 881.18, y = -1663.09, z = 30.34-0.98},
      Size  = {x = 1.5, y = 1.5, z = 1.0},
      Color = {r = 255, g = 0, b = 0},
      Marker= 1,
      Blip  = false,
      Name  = 'spawner véhicule de fonction',
      Type  = "vehspawner",
      Spawner = 1,
      Hint  = 'appuyez sur ~y~E~s~ pour appeler le camion.',
      Caution = 100,
      GPS = {x = 602.254, y = 2926.62, z = 39.6898}
    },

    VehicleSpawnPoint = {
      Pos   = {x = 882.92, y = -1656.50, z = 30.24-0.98},
      Size  = {x = 3.0, y = 3.0, z = 1.0},
      Marker= -1,
      Blip  = false,
      Name  = 'véhicule de fonction',
      Type  = "vehspawnpt",
      Spawner = 1,
      GPS = 0,
      Heading = 96.26
    },

    VehicleDeletePoint = {
      Pos   = {x = 886.29, y = -1655.83, z = 30.18-0.98},
      Size  = {x = 5.0, y = 5.0, z = 1.0},
      Color = {r = 255, g = 0, b = 0},
      Marker= 1,
      Blip  = false,
      Name  = 'supression du véhicule',
      Type  = "vehdelete",
      Hint  = 'appuyez sur ~y~E~s~ pour rendre le véhicule.',
      Spawner = 1,
      Caution = 100,
      GPS = 0,
      Teleport = 0
    },

    Delivery = { 
      Pos   = {x = 904.51, y = -1722.53, z = 32.15-0.98},
      Color = {r = 0, g = 255, b = 0},
      Size  = {x = 8.0, y = 8.0, z = 1.0},
      Marker= 25,
      Blip  = true,
      Name  = "Point de livraison",
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 3000,
          remove = 1,
          max    = 100,
          price  = 15,
          requires = "marchandise",
          requires_name = "Carton de marchandises",
          drop   = 100
        }
      },
      Hint  = 'Appuyez sur ~y~E~s~ pour livrer la marchandises.',
      GPS = {x = 609.589, y = 2856.74, z = 39.4958}
    }
  }
}
