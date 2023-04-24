Config_esx_dinerjob                            = {}
Config_esx_dinerjob.DrawDistance               = 15.0
Config_esx_dinerjob.MaxInService               = -1
Config_esx_dinerjob.EnablePlayerManagement     = true
Config_esx_dinerjob.EnableSocietyOwnedVehicles = false
Config_esx_dinerjob.Locale                     = 'fr'
Config_esx_dinerjob.NPCJobEarningsPlayer       = 580
Config_esx_dinerjob.NPCJobEarningsEntreprise   = 850


Config_esx_dinerjob.Blips = {
    
    Blip = {
      Pos     = { x = -304.36, y = 6265.06, z = 37.92 },
      Sprite  = 514,
      Display = 4,
      Scale   = 0.6,
      Colour  = 47,
    },
}

Config_esx_dinerjob.Zones = {
    
    BossActions = {
       Pos   = { x = -314.09, y = 6266.34, z = 31.52-0.98 },
        Size  = { x = 2.1, y = 2.1, z = 2.1 },
        Color = { r = 255, g = 187, b = 255 },
        Type  = 0,
    },

    Fridge = {
        Pos   = { x = -306.48, y = 6268.13, z = 31.53 },
        Size  = { x = 2.1, y = 2.1, z = 2.1 },
        Color = { r = 248, g = 248, b = 255 },
        Type  = 0,
    },

    Cloakrooms = {
        Pos   = { x = -295.82, y = 6268.55, z = 30.55  },
        Size  = { x = 2.1, y = 2.1, z = 2.1 },
        Color = { r = 0, g = 100, b = 0 },
        Type  = 0,
    },

    Farm = {
        Pos   = {x = 2130.93, y = 4792.71, z = 41.12-0.90},
        Size  = {x = 1.0, y = 1.5, z = 2.0},
        Color = {r = 204, g = 204, b = 0},
        Type  = 0
    },

    FarmEnd = {
        Pos   = {x = 2111.19, y = 4768.77, z = 41.31-1},
        Size  = {x = 2.0, y = 3.0, z = 2.0},
        Color = {r = 255, g = 0, b = 0},
        Type  = 0
    },

    VehicleSpawnPoint = {
        Pos   = {x = 2117.70, y = 4799.21, z = 41.28-1},
        Size  = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 204, g = 204, b = 0},
        Type  = -1
    },

    Shops = {
        Pos   = {x = -302.17, y = 6271.55, z = 31.53 },
        Size  = { x = 1.6, y = 1.6, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Type  = 0,

    },
    DrinkShop = {
      Pos   = {x = -304.03, y = 6269.44, z = 31.53 },
      Size  = { x = 1.6, y = 1.6, z = 1.0 },
      Color = { r = 255, g = 255, b = 255 },
      Type  = 0,

  },
}

Config_esx_dinerjob.CheckPoints = {
    {
      Pos = {x = 1911.13, y = 4742.74, z = 42.26},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('ramassage du blé en cours  en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 1941.55, y = 4769.61, z = 42.75},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 1971.98, y = 4797.47, z = 43.12},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 1943.47, y = 4785.04, z = 43.50},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 1963.68, y = 4807.77, z = 43.61},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 1942.02, y = 4799.79, z = 43.97},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 1887.75, y = 4761.82, z = 41.83},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 1905.02, y = 4798.90, z = 44.68},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 1873.66, y = 4780.85, z = 42.99},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 1893.06, y = 4810.10, z = 45.40},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 1858.07, y = 4801.44, z = 44.07},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 1874.63, y = 4830.44, z = 45.38},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 1842.95, y = 4810.76, z = 44.15},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 1985.04, y = 4902.21, z = 42.96},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 2029.85, y = 4858.50, z = 42.90},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 2000.38, y = 4904.93, z = 42.90},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 2050.94, y = 4879.15, z = 42.98},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        DrawMissionText('Ramassage du blé en cours..', 4000)
        Citizen.Wait(2500)
        DrawMissionText('Allez au prochain ramassage..', 5000)
        Citizen.Wait(10000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      end
    },
  
    {
      Pos = {x = 2137.86, y = 4818.65, z = 41.33},
      Action = function(playerPed, vehicle, setCurrentZoneType)
        ESX.Game.DeleteVehicle(vehicle)
      end
    },
  }
