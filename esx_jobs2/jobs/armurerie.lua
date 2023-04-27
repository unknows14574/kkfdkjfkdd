Config_esx_jobs2.Jobs.armurerie = {
  BlipInfos = {
    Sprite = 110,
    Color = 8
  },

  Zones = {
  
    Recolte = {
      Pos   = {x = -318.47, y = 6087.42, z = 31.46-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "Récolte accessoires d'armes",
      Type  = "work",
      Item  = {
        {
          name   = "Carton d'accessoires armes",
          db_name= "wbox",
          time   = 3000,
          max    = 25,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 100
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour récolter.",
      GPS = 0
    },

    Vente = {
      Pos   = {x = 803.08, y = -2133.89, z = 29.41-0.7},
      Color = {r = 255, g = 255, b = 0},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Marker= 0,
      Blip  = true,
      Name  = "Vente accessoires d'armes",
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 3000,
          remove = 1,
          max    = 50,
          price  = 14,
          requires = "wbox",
          requires_name = "Carton d'accessoires armes",
          drop   = 100
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour vendre.",
      GPS = 0
    },

  },
}
