Config_esx_jobs.Jobs.weed = {
  BlipInfos = {
    Sprite = 501,
    Color = 5
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
 

    Recolte_Weed = {
      Pos   = {x = 347.04, y = 6655.25, z = 28.86-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'Recolte de weed',
      Type  = "work",
      Item  = {
        {
          name   = 'Weed médical',
          db_name= "weed2",
          time   = 3000,
          max    = 50,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 110
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour récolter la weed.',
      GPS = {x = 0, y = 0, z = 0},
    },

    Vente_Weed = {
      Pos   = {x =-240.58, y = -307.91, z = 30.11-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= -1,
      Blip  = true,
      Name  = 'Revente de weed',
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 3000,
          remove = 1,
          max    = 50,
          price  = 14, 
          requires = "weed2",
          requires_name = "weed2",
          drop   = 100
        }
      },
      Hint  = 'Presse ~y~E~s~ pour vendre de la weed',
      GPS = {x = 0, y = 0, z = 0}
    },

  },
}
