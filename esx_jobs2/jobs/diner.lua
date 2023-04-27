Config_esx_jobs2.Jobs.diner = {
  BlipInfos = {
    Sprite = 538,
    Color = 23
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

    Recolte_Vache = {
      Pos   = {x = 2294.79, y = 4929.16, z = 41.41-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'Recolte de vache',
      Type  = "work",
      Item  = {
        {
          name   = "Vache",
          db_name= "vache",
          time   = 3000,
          max    = 50,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 110
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour récolté de boeuf.",
      GPS = {x = 1207.19, y = 1857.35, z = 77.99},
    },

	Recolte_Ble = {
      Pos   = {x = 2630.28, y = 4605.39, z = 35.44-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'Recolte de blé',
      Type  = "work",
      Item  = {
        {
          name   = "Blé",
          db_name= "ble",
          time   = 3000,
          max    = 50,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 110
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour récolté du blé.",
      GPS = {x = 1207.19, y = 1857.35, z = 77.99},
    },
	
	Recolte_Cochon = {
      Pos   = {x = 2445.01, y = 4761.68, z = 34.30-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'Recolte de cochon',
      Type  = "work",
      Item  = {
        {
          name   = "Cochon",
          db_name= "cochon",
          time   = 3000,
          max    = 50,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 110
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour récolté de cochon.",
      GPS = {x = 1207.19, y = 1857.35, z = 77.99},
    },
	
	Recolte_Salades = {
      Pos   = {x = 2286.42, y = 4761.34, z = 38.59-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'Recolte des salades',
      Type  = "work",
      Item  = {
        {
          name   = "Salades",
          db_name= "salades",
          time   = 3000,
          max    = 50,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 110
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour récolté des salades.",
      GPS = {x = 1207.19, y = 1857.35, z = 77.99},
    },
	
	Recolte_Tomates = {
      Pos   = {x = 1857.21, y = 5020.61, z = 53.32-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'Recolte des tomates',
      Type  = "work",
      Item  = {
        {
          name   = "Tomates",
          db_name= "tomates",
          time   = 3000,
          max    = 50,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 110
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour récolté des tomates.",
      GPS = {x = 1207.19, y = 1857.35, z = 77.99},
    },
	
	Recolte_Oeufs = {
      Pos   = {x = 2306.81, y = 4753.03, z = 37.17-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'Recolte des oeufs',
      Type  = "work",
      Item  = {
        {
          name   = "Oeufs",
          db_name= "oeufs",
          time   = 3000,
          max    = 50,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 110
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour récolté des oeufs.",
      GPS = {x = 1207.19, y = 1857.35, z = 77.99},
    },
	
	Recolte_Lait = {
      Pos   = {x = 2174.86, y = 4966.95, z = 41.32-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'Recolte des lait',
      Type  = "work",
      Item  = {
        {
          name   = "Lait",
          db_name= "lait",
          time   = 3000,
          max    = 50,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 110
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour récolté des lait.",
      GPS = {x = 1207.19, y = 1857.35, z = 77.99},
    },
	
	Recolte_Pommes = {
      Pos   = {x = 2323.83, y = 5014.05, z = 42.54-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'Recolte des pommes',
      Type  = "work",
      Item  = {
        {
          name   = "Pommes",
          db_name= "pommes",
          time   = 3000,
          max    = 50,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 110
        }
      },
      Hint  = "Appuyez sur ~y~E~s~ pour récolté des pommes.",
      GPS = {x = 1207.19, y = 1857.35, z = 77.99},
    },


  },
}
