Config_esx_jobs.Jobs.mecano = {
  BlipInfos = {
    Sprite = 568,
    Scale = 0.6,
    Color = 5
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

    FarmPiece = {
      Pos   = {x = 2749.26, y = 3472.35, z = 55.67-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "kits",
      Type  = "work",
      Item  = {
        {
          name   = "kits",
          db_name= "kits",
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

    VentePiece = {
      Pos   = {x = 76.79,y = -217.38,z = 54.64-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'revente marchandises',
        Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 1000,
          remove = 1,
          max    = 50,
          price  = 14,
          requires = "kits",
          requires_name = "kits",
          drop   = 100
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour vendre.',
    },

  },
}
