Config_esx_chauffeur                 = {}
Config_esx_chauffeur.DrawDistance = 15.0

Config_esx_chauffeur.Zones = {

  Routier = {
    Pos   = {x = 54.57, y = -1738.84, z = 29.58-1},
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = 1
  },
  
  DelVeh = {
    Pos   = {x = 39.04, y = -1742.89, z = 29.30-1},
    Size  = {x = 3.0, y = 3.0, z = 1.0},
    Color = {r = 255, g = 0, b = 0},
    Type  = 1
  },

  VehicleSpawnPoint = {
    Pos   = {x = 36.91, y = -1741.35, z = 29.30-1},
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = -1
  },

}

Config_esx_chauffeur.CheckPoints = {

  {
    Pos = {x = 282.46, y = -1261.76, z = 29.23},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Livraison en cours..', 5000)
	  Citizen.Wait(1000)
	  DrawMissionText('Attendre la prochaine livraison..', 5000)
	  Citizen.Wait(20000)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = 2567.99, y = 385.14, z = 108.46},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Livraison en cours..', 5000)
	  Citizen.Wait(1000)
	  DrawMissionText('Attendre la prochaine livraison..', 5000)
	  Citizen.Wait(20000)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = 1398.08, y = 3591.07, z = 34.87},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Livraison en cours..', 5000)
	  Citizen.Wait(1000)
	  DrawMissionText('Attendre la prochaine livraison..', 5000)
	  Citizen.Wait(20000)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = 1693.98, y = 4939.75, z = 42.18},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Livraison en cours..', 5000)
	  Citizen.Wait(1000)
	  DrawMissionText('Attendre la prochaine livraison..', 5000)
	  Citizen.Wait(20000)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = 1725.14, y = 6402.13, z = 34.37},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Livraison en cours..', 5000)
	  Citizen.Wait(1000)
	  DrawMissionText('Attendre la prochaine livraison..', 5000)
	  Citizen.Wait(20000)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = 151.65, y = 6622.84, z = 31.81},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Livraison en cours..', 5000)
	  Citizen.Wait(1000)
	  DrawMissionText('Attendre la prochaine livraison..', 5000)
	  Citizen.Wait(20000)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = -3029.92, y = 592.43, z = 7.78},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Livraison en cours..', 5000)
	  Citizen.Wait(1000)
	  DrawMissionText('Attendre la prochaine livraison..', 5000)
	  Citizen.Wait(20000)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = -1231.15, y = -896.13, z = 12.15},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Livraison en cours..', 5000)
	  Citizen.Wait(1000)
	  DrawMissionText('Attendre la prochaine livraison..', 5000)
	  Citizen.Wait(20000)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = -712.29, y = -923.37, z = 19.01},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Livraison en cours..', 5000)
	  Citizen.Wait(1000)
	  DrawMissionText('Attendre la prochaine livraison..', 5000)
	  Citizen.Wait(20000)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = -67.42, y = -1749.61, z = 29.45},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Livraison en cours..', 5000)
	  Citizen.Wait(1000)
	  DrawMissionText('Attendre la prochaine livraison..', 5000)
	  Citizen.Wait(20000)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = 55.91, y = -1722.69, z = 29.30},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      ESX.Game.DeleteVehicle(vehicle)
    end
  },

}
