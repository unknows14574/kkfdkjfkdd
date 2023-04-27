Config_esx_jobs.Jobs.mecano2 = {
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
      Pos   = {x = 2749.26, y = 3472.35, z = 55.67-0.98},
      Size  = {x = 4.0, y = 4.0, z = 1.0},
      Color = {r = 0, g = 0, b = 0},
      Marker= 25,
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
      Pos   = {x = 119.48, y = 6626.49, z = 31.95-0.98},
      Color = {r = 0, g = 0, b = 0},
      Size  = {x = 4.0, y = 4.0, z = 3.0},
      Marker= 25,
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
          price  = 15,
          requires = "kits",
          requires_name = "kits",
          drop   = 100
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour vendre.',
    },

  },
}
