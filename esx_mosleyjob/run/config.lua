MosleyConfig = {}
MosleyConfig.DrawDistance = 15.0
MosleyConfig.NPCJobEarningsPlayer = 3500
MosleyConfig.NPCJobEarningsEntreprise = 5250
MosleyConfig.CheckPoints = {

  {
    Pos = {x = 478.45, y = -1278.75, z = 29.54},--repa four
    Action = function(playerPed, vehicle, setCurrentZoneType)
	  ESX.ShowNotification("Livraison..")
	  FreezeEntityPosition(vehicle, true)
	  TriggerEvent('progressBar:drawBar', true, 15000, "Livraison..")
	  --exports['progressBars']:startUI(15000, "Livraison..")
	  Citizen.Wait(15000)
	  FreezeEntityPosition(vehicle, false)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = 1144.82, y = -770.87, z = 57.58},--repa
    Action = function(playerPed, vehicle, setCurrentZoneType)
	  ESX.ShowNotification("Livraison..")
	  FreezeEntityPosition(vehicle, true)
	  TriggerEvent('progressBar:drawBar', true, 15000, "Livraison..")
	  --exports['progressBars']:startUI(15000, "Livraison..")
	  Citizen.Wait(15000)
	  FreezeEntityPosition(vehicle, false)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },
  
  {
    Pos = {x = 532.85, y = -182.60, z = 54.23},--repa2
    Action = function(playerPed, vehicle, setCurrentZoneType)
	  ESX.ShowNotification("Livraison..")
	  FreezeEntityPosition(vehicle, true)
	  TriggerEvent('progressBar:drawBar', true, 15000, "Livraison..")
	  --exports['progressBars']:startUI(15000, "Livraison..")
	  Citizen.Wait(15000)
	  FreezeEntityPosition(vehicle, false)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },
  
  
  {
    Pos = {x = 439.29, y = 3579.09, z = 33.23},--repa nord
    Action = function(playerPed, vehicle, setCurrentZoneType)
	  ESX.ShowNotification("Livraison..")
	  FreezeEntityPosition(vehicle, true)
	  TriggerEvent('progressBar:drawBar', true, 15000, "Livraison..")
	  --exports['progressBars']:startUI(15000, "Livraison..")
	  Citizen.Wait(15000)
	  FreezeEntityPosition(vehicle, false)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },
  
  {
    Pos = {x = 1778.24, y = 3337.37, z = 41.09},--flywheels
    Action = function(playerPed, vehicle, setCurrentZoneType)
	  ESX.ShowNotification("Livraison..")
	  FreezeEntityPosition(vehicle, true)
	  TriggerEvent('progressBar:drawBar', true, 15000, "Livraison..")
	  --exports['progressBars']:startUI(15000, "Livraison..")
	  Citizen.Wait(15000)
	  FreezeEntityPosition(vehicle, false)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },
  
  {
    Pos = {x = 2761.62, y = 3467.26, z = 55.68},--youtool
    Action = function(playerPed, vehicle, setCurrentZoneType)
	  ESX.ShowNotification("Livraison..")
	  FreezeEntityPosition(vehicle, true)
	  TriggerEvent('progressBar:drawBar', true, 15000, "Livraison..")
	  --exports['progressBars']:startUI(15000, "Livraison..")
	  Citizen.Wait(15000)
	  FreezeEntityPosition(vehicle, false)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },
  
  {
    Pos = {x = 128.28, y = 6622.67, z = 31.79},--repa paleto
    Action = function(playerPed, vehicle, setCurrentZoneType)
	  ESX.ShowNotification("Livraison..")
	  FreezeEntityPosition(vehicle, true)
	  TriggerEvent('progressBar:drawBar', true, 15000, "Livraison..")
	  --exports['progressBars']:startUI(15000, "Livraison..")
	  Citizen.Wait(15000)
	  FreezeEntityPosition(vehicle, false)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },
  
  {
    Pos = {x = -1378.27, y = -372.21, z = 36.55},--auto service
    Action = function(playerPed, vehicle, setCurrentZoneType)
	  ESX.ShowNotification("Livraison..")
	  FreezeEntityPosition(vehicle, true)
	  TriggerEvent('progressBar:drawBar', true, 15000, "Livraison..")
	  --exports['progressBars']:startUI(15000, "Livraison..")
	  Citizen.Wait(15000)
	  FreezeEntityPosition(vehicle, false)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },
  
  {
    Pos = {x = -364.68, y = -120.26, z = 38.69},--ls centre
    Action = function(playerPed, vehicle, setCurrentZoneType)
	  ESX.ShowNotification("Livraison..")
	  FreezeEntityPosition(vehicle, true)
	  TriggerEvent('progressBar:drawBar', true, 15000, "Livraison..")
	  --exports['progressBars']:startUI(15000, "Livraison..")
	  Citizen.Wait(15000)
	  FreezeEntityPosition(vehicle, false)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },
  
  {
    Pos = {x = -530.59, y = -1208.65, z = 18.18},--essence
    Action = function(playerPed, vehicle, setCurrentZoneType)
	  ESX.ShowNotification("Merci de mettre l'essence!")
	  Citizen.Wait(15000)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },
  
  {
    Pos = {x = -229.59, y = -1385.55, z = 31.25},--glass
    Action = function(playerPed, vehicle, setCurrentZoneType)
	  ESX.ShowNotification("Livraison..")
	  FreezeEntityPosition(vehicle, true)
	  TriggerEvent('progressBar:drawBar', true, 15000, "Livraison..")
	  --exports['progressBars']:startUI(15000, "Livraison..")
	  Citizen.Wait(15000)
	  FreezeEntityPosition(vehicle, false)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },
  
  {
    Pos = {x = 12.83, y = -1392.00, z = 29.34},--lavage
    Action = function(playerPed, vehicle, setCurrentZoneType)
	  ESX.ShowNotification("Néttoyage..")
	  FreezeEntityPosition(vehicle, true)
	  SetVehicleDirtLevel(vehicle, 0.0000000001)
	  SetVehicleUndriveable(vehicle, false)
	  TriggerEvent('progressBar:drawBar', true, 15000, "Néttoyage..")
	  --exports['progressBars']:startUI(15000, "Néttoyage..")
	  Citizen.Wait(15000)
	  FreezeEntityPosition(vehicle, false)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },
  
  {
    Pos = {x = -43.80, y = -1677.57, z = 29.41},--end
    Action = function(playerPed, vehicle, setCurrentZoneType)
	  ESX.ShowNotification("Réparation..")
	  TriggerEvent('progressBar:drawBar', true, 15000, "Réparation..")
	  --exports['progressBars']:startUI(15000, "Réparation..")
	  Citizen.Wait(15000)
	  PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },
  


}
