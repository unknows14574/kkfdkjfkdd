Config_esx_jobs.Jobs.journaliste = {
  BlipInfos = {
    Sprite = 525,
    Scale = 0.6,
    Color = 71
  },

  Zones = {
  
    Recolte = {
      Pos   = {x = 180.72, y = 2793.26, z = 45.65-0.7},
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
          time   = 1000,
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
      Pos   = {x = -543.82, y = -887.285, z = 25.16-0.7},
      Size  = {x = 0.1, y = 0.1, z = 0.1},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "Vente de journaux",
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 1000,
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
