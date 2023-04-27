Config_esx_jobs2.Jobs.ambulance = {
  BlipInfos = {
    Sprite = 403,
    Color = 1
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

    FarmEphedrine = {
      Pos   = {x = 3606.38,y = 3730.18,z = 29.68-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = "Récolte ephedrine",
      Type  = "work",
      Item  = {
        {
          name   = "ephedrine_farm",
          db_name= "ephedrine_farm",
          time   = 3000,
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

    VenteEphedrine = {
	  Pos   = {x = -449.18,y = -341.00,z = 33.60-0.7},
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
          price  = 16,
          requires = "ephedrine_farm",
          requires_name = "ephedrine_farm",
          drop   = 100
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour vendre.',
    },

  },
}
