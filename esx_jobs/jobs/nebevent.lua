Config_esx_jobs.Jobs.nebevent = {
  BlipInfos = {
    Sprite = 478,
    Scale = 0.6,
    Color = 27
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

    FarmAlcool = {
      Pos   = {x = 119.48, y = 6626.49, z = 31.95-0.98},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker = 0,
      Blip  = true,
      Name  = "Récolte de pneus",
      Type  = "work",
      Item  = {
        {
          name   = "cpneus",
          db_name= "cpneus",
          time   = 1000,
          max    = 50,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 100
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour récolter.',
    },

    VenteAlcool = {
      Pos   = {x = 722.73,y = -1069.52,z = 23.06-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker = 0,
      Blip  = true,
      Name  = 'Revente de pneus',
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 1000,
          remove = 1,
          max    = 50,
          price  = 15,
          requires = "cpneus",
          requires_name = "cpneus",
          drop   = 100
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour vendre.',
    },

  },
}
