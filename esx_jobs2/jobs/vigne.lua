Config_esx_jobs2.Jobs.vigne = {
  BlipInfos = {
    Sprite = 85,
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

    Vigne = {
      Pos   = {x = -1720.09, y = 2336.96, z = 62.38},--ok
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 0, b = 255},
      Marker= 0,
      Blip  = true,
      Name  = 'Recolte de raisins',
      Type  = "work",
      Item  = {
        {
          name   = 'raisin',
          db_name= "raisin",
          time   = 3000,
          max    = 50,
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

    Vente = {
      Pos   = {x = -169.79, y = 283.72, z = 92.76},--ok
      Color = {r = 255, g = 0, b = 255},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Marker= 0,
      Blip  = true,
      Name  = 'Vente de raisins',
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 1000,
          remove = 1,
          max    = 50, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
          price  = 14,
          requires = "raisin",
          requires_name = 'raisin',
          drop   = 100
        }
      },
      Hint  = 'Appuie sur ~y~E~s~ pour vendre du raisin',
      GPS = {x = 1174.83, y = -397.37, z = 66.92},--ok
    },

  },
}
