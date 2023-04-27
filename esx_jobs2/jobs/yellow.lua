Config_esx_jobs2.Jobs.yellow = {
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
      Pos   = {x = 907.72, y = -1725.66, z = 32.15-0.7},
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
          time   = 3000,
          max    = 50,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 100
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour récolter.',
    },

    VenteAlcool = {
      Pos   = {x = 2752.63,y = 3470.90,z = 55.72-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker = 0,
      Blip  = true,
      Name  = 'revente d\'alcool',
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'livraison',
          time   = 2000,
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
