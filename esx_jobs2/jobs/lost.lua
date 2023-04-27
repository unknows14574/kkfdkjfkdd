Config_esx_jobs2.Jobs.lost = {
  BlipInfos = {
    Sprite = 499,
    Color = 1
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

    --[[SpawnVeh = {
      Pos   = {x = 976.02, y = -129.13, z = 74.11-0.95},
      Color = {r = 0, g = 0, b = 0},
      Size  = {x = 1.2, y = 1.2, z = 1.0},
      Marker= 25,
    },
	DelVeh = {
      Pos   = {x = 971.17, y = -137.80, z = 74.32-0.92},
      Color = {r = 0, g = 0, b = 0},
      Size  = {x = 3.0, y = 3.0, z = 1.0},
      Marker= 25,
    },]]
  
    FarmAlcool = {
      Pos   = {x = -67.22, y = 6533.96, z = 31.49-0.98},
      Size  = {x = 3.0, y = 3.0, z = 1.0},
      Color = {r = 0, g = 0, b = 0},
      Marker= 25,
      Blip  = true,
      Name  = "Récolte d'alcools",
      Type  = "work",
      Item  = {
        {
          name   = "balcool",
          db_name= "balcool",
          time   = 3000,
          max    = 25,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 100
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour récolté.',
    },

    VenteAlcool = {
      Pos   = {x = -394.24,y = 208.49,z = 83.15-0.98},
      Color = {r = 0, g = 0, b = 0},
      Size  = {x = 4.0, y = 4.0, z = 3.0},
      Marker= 25,
      Blip  = true,
      Name  = "Vente d'alcools",
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 1000,
          remove = 1,
          max    = 50,
          price  = 15,
          requires = "balcool",
          requires_name = "balcool",
          drop   = 100
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour vendre.',
    },

  },
}
