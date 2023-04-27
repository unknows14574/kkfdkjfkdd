Config_esx_jobs2.Jobs.journaliste = {
  BlipInfos = {
    Sprite = 525,
    Scale = 0.6,
    Color = 71
  },

  Zones = {
  
    Recolte = {
      Pos   = {x = 46.83, y = 6458.61, z = 31.42-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "Récolte de journaux",
      Type  = "work",
      Item  = {
        {
          name   = "Journal",
          db_name= "journal",
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
      Pos   = {x = -799.02, y = -99.00, z = 37.61-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "Vente de journaux",
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 3000,
          remove = 1,
          max    = 50,
          price  = 15,
          requires = "journal",
          requires_name = "Journal",
          drop   = 100
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour vendre.",
      GPS = 0
    },

  },
}
