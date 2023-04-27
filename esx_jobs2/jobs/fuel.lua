Config_esx_jobs2.Jobs.fuel = {
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

    Farm = {
      Pos   = {x = -56.24, y = 6524.66, z = 31.49-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "Centre de stockage",
      Type  = "work",
      Item  = {
        {
          name   = "Carton de marchandise",
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
      Hint  = "Appuyez sur ~y~E~s~ pour prendre un carton.",
    },

    Vente = {
      Pos   = {x = -394.24,y = 208.49,z = 83.15-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "Point de livraison",
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 1000,
          remove = 1,
          max    = 50,
          price  = 14,
          requires = "marchandise",
          requires_name = "Carton de marchandise",
          drop   = 100
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour livrer le carton.",
    },

  },
}
