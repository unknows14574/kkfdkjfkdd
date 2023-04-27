Config_esx_jobs2.Jobs.tabac = {
  BlipInfos = {
    Sprite = 469,
    Color = 28
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
 

    Recolte_Tabac = {
      Pos   = {x = 368.08, y = 6650.17, z = 28.84-0.7}, --ok
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'Recolte de Tabac',
      Type  = "work",
      Item  = {
        {
          name   = 'Tabac',
          db_name= "tabac",
          time   = 3000,
          max    = 50,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 110
        }
      },
      Hint  = 'appuyez sur ~y~E~s~ pour récolter le tabac.',
      GPS = {x = 1207.19, y = 1857.35, z = 77.99},
    },

	
	Traitement_Tabac = {
      Pos   = {x =93.21, y = 187.11, z = 105.26-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'Traitement Tabac',
      Type  = "work",
      Item  = {
        {
          name   = 'paquet cigarette',
          db_name= "packcig",
          time   = 3000,
          max    = 50,
          add    = 1,
          remove = 2,
          requires = "tabac",
          requires_name = "tabac",
          drop   = 100
        },
      },
      Hint  = 'Presse ~y~E~s~ pour mettre en paquet',
      GPS = {x = -169.79, y = 283.72, z = 92.76}
    },

    Vente_Tabac = {
      Pos   = {x =86.97, y = 189.61, z = 105.26-0.7},
      Size  = {x = 0.3, y = 0.3, z = 0.3},
      Color = {r = 255, g = 255, b = 0},
      Marker= 0,
      Blip  = true,
      Name  = 'Revente de Tabac',
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = 'point de livraison',
          time   = 3000,
          remove = 1,
          max    = 50,
          price  = 14, 
          requires = "tabac",
          requires_name = "tabac",
          drop   = 100
        }
      },
      Hint  = 'Presse ~y~E~s~ pour vendre du tabac',
      GPS = {x = -1749.52, y = 2181.58, z = 44.97}--ok
    },

  },
}

--temps de run 60min
--10920‬$ gains employé
--4680$ gains pour l'entreprise