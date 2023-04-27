Config_esx_jobs.Jobs.eightpool = {
  BlipInfos = {
    Sprite = 478,
    Scale = 0.6,
    Color = 27
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
    FarmAlcool = {
      Pos   = {x = 829.91, y = -1916.47, z = 29.39-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker = 0,
      Blip  = true,
      Name  = "Récupération d'alcool",
      Type  = "work",
      Item  = {
        {
          name   = "balcool",
          db_name= "balcool",
          time   = 1000,
          max    = 50,
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
      Pos   = {x = -2961.75, y = 376.82, z = 15.01-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker = 0,
      Blip  = true,
      Name  = 'Revente d\'alcool',
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
