Config_esx_jobs.Jobs.reporter = {
  BlipInfos = {
    Sprite = 184,
    Color = 1
  },
  Vehicles = {
    Truck = {
      Spawner = 1,
      Hash = "rumpo",
      Trailer = "none",
      HasCaution = false
    }
  },
  Zones = {
    VehicleSpawner = {
      Pos   = { x = -141.41, y = -620.80, z = 167.82 },
      Size  = {x = 2.0, y = 2.0, z = 0.2},
      Color = {r = 204, g = 204, b = 0},
      Marker= 1,
      Blip  = true,
      Name  = 'le Maclerait Libéré',
      Type  = "vehspawner",
      Spawner = 1,
      Hint  = 'appuyez sur ~y~E~s~ pour descendre au garage.',
      Caution = 100
    },

    VehicleSpawnPoint = {
      Pos   = { x = -149.32023620605, y = -592.17163085938, z = 31.42448425293 },
      Size  = {x = 3.0, y = 3.0, z = 1.0},
      Marker= -1,
      Blip  = false,
      Name  = 'véhicule de fonction',
      Type  = "vehspawnpt",
      Spawner = 1,
      Heading = 200.1
    },

    VehicleDeletePoint = {
      Pos   = { x = -144.2229309082,  y = -577.02972412109, z = 31.42448425293 },
      Size  = {x = 5.0, y = 5.0, z = 0.2},
      Color = {r = 255, g = 0, b = 0},
      Marker= 1,
      Blip  = false,
      Name  = 'supression du véhicule',
      Type  = "vehdelete",
      Hint  = 'appuyez sur ~y~E~s~ pour rendre le véhicule.',
      Spawner = 1,
      Caution = 100,
      GPS = 0,
      Teleport = { x = -139.09838867188, y = -620.74865722656, z = 167.82052612305 }
    }
  }
}
