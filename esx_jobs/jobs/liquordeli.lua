Config_esx_jobs.Jobs.liquordeli = {
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
      Pos   = {x = -59.68, y = 6526.79, z = 31.49-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker = 0,
      Blip  = true,
      Name  = "balcool",
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
      Pos   = {x = 389.06,y = -1083.06,z = 29.41-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker = 0,
      Blip  = true,
      Name  = 'revente d\'alcool',
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 1000,
          remove = 1,
          max    = 50,
          price  = 14,
          requires = "balcool",
          requires_name = "balcool",
          drop   = 100
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour vendre.',
    },

  },
}
